Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21C8B71F371
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 22:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbjFAULI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 16:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbjFAULH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 16:11:07 -0400
Received: from out-33.mta1.migadu.com (out-33.mta1.migadu.com [IPv6:2001:41d0:203:375::21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89AA195
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 13:11:01 -0700 (PDT)
Date:   Thu, 1 Jun 2023 20:10:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685650260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RygkjhnuiaNw7c5uQLoy01AXmbNq/ULLzHOSyqx57zc=;
        b=C8z6oBXbjtQ7dp9Vuc55GiY+wVtYzNGNdh9RH0ankwutpHqSP6A/PPmgOkXE8vSWfYMMhH
        VvkXszkK0UrepvIeE6Mng3YF/i8O+Ql5gGqUauRFrTSVxRMUTwE3wiFkycgbXQ00Quy1u6
        F0CuJIJzTHAuFM7GvR5EoDwYPtb/PLI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2 05/17] arm64: Don't enable VHE for the kernel if
 OVERRIDE_HVHE is set
Message-ID: <ZHj7UM8EbH38Z69k@linux.dev>
References: <20230526143348.4072074-1-maz@kernel.org>
 <20230526143348.4072074-6-maz@kernel.org>
 <ZHhJmJU/m//uTI9n@linux.dev>
 <87bkhzpcut.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bkhzpcut.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 01, 2023 at 01:48:42PM +0100, Marc Zyngier wrote:
> On Thu, 01 Jun 2023 08:32:40 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > On Fri, May 26, 2023 at 03:33:36PM +0100, Marc Zyngier wrote:
> > > If the OVERRIDE_HVHE SW override is set (as a precursor of
> > > the KVM_HVHE capability), do not enable VHE for the kernel
> > > and drop to EL1 as if VHE was either disabled or unavailable.
> > > 
> > > Further changes will enable VHE at EL2 only, with the kernel
> > > still running at EL1.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kernel/hyp-stub.S | 10 +++++++++-
> > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
> > > index 9439240c3fcf..5c71e1019545 100644
> > > --- a/arch/arm64/kernel/hyp-stub.S
> > > +++ b/arch/arm64/kernel/hyp-stub.S
> > > @@ -82,7 +82,15 @@ SYM_CODE_START_LOCAL(__finalise_el2)
> > >  	tbnz	x1, #0, 1f
> > >  
> > >  	// Needs to be VHE capable, obviously
> > > -	check_override id_aa64mmfr1 ID_AA64MMFR1_EL1_VH_SHIFT 2f 1f x1 x2
> > > +	check_override id_aa64mmfr1 ID_AA64MMFR1_EL1_VH_SHIFT 0f 1f x1 x2
> > > +
> > > +0:	// Check whether we only want the hypervisor to run VHE, not the kernel
> > > +	adr_l	x1, arm64_sw_feature_override
> > > +	ldr	x2, [x1, FTR_OVR_VAL_OFFSET]
> > > +	ldr	x1, [x1, FTR_OVR_MASK_OFFSET]
> > > +	and	x2, x2, x1
> > 
> > nit: is applying the mask even necessary? I get it in the context of an
> > overlay on top of an ID register, but the software features are more of
> > a synthetic ID register in their own right.
> 
> I guess I don't have a good reason just yet, but on the other hand it
> makes things predictable if the override code refuses the override for
> some reason other than not being VHE-capable (mask becomes 0 and val
> becomes 0xf).
> 
> Overall, I feel that this code is too hard to follow to do anything
> different from the "standard" case.

Fair enough. Coming at it from the other angle (i.e. ignoring the ID
reg side) it is only slightly weird, but does not really matter. I'm
fine with this as-is.

-- 
Thanks,
Oliver
