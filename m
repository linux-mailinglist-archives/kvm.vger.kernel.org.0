Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0D2872CF3F
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 21:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbjFLTUd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 15:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbjFLTUc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 15:20:32 -0400
Received: from out-16.mta0.migadu.com (out-16.mta0.migadu.com [91.218.175.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C815EB0
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 12:20:30 -0700 (PDT)
Date:   Mon, 12 Jun 2023 21:20:26 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686597628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=56IOyjS+GBgnu/S1KNwnnS84oPh9pw2u4TnmZ1agPlk=;
        b=vxQGlxavmwCM2GxhYHZVC80KCwkgUIc425f9Gs1FF1Lng93Hrjy9TcFy1BsNCUlRmr6dN/
        03FELDKYstqVUPstcIAk7ruZ42iTiqG9wRdW8NHK1l5QZVd4jeQzHryLd4Hau1A9WeH7CY
        DyaI/JSQDeJArioBZdxiD3ic9TlyeEk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 05/17] arm64: Don't enable VHE for the kernel if
 OVERRIDE_HVHE is set
Message-ID: <ZIdv+q9hemnlIDtl@linux.dev>
References: <20230609162200.2024064-1-maz@kernel.org>
 <20230609162200.2024064-6-maz@kernel.org>
 <ZIduFSAPFumGotwV@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIduFSAPFumGotwV@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Catalin,

Thanks a bunch for the reviews/acks, I plan on queueing this up for 6.5.

On Mon, Jun 12, 2023 at 08:12:21PM +0100, Catalin Marinas wrote:
> On Fri, Jun 09, 2023 at 05:21:48PM +0100, Marc Zyngier wrote:
> > If the OVERRIDE_HVHE SW override is set (as a precursor of
> > the KVM_HVHE capability), do not enable VHE for the kernel
> > and drop to EL1 as if VHE was either disabled or unavailable.
> > 
> > Further changes will enable VHE at EL2 only, with the kernel
> > still running at EL1.
> > 
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >  arch/arm64/kernel/hyp-stub.S | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
> > index 9439240c3fcf..5c71e1019545 100644
> > --- a/arch/arm64/kernel/hyp-stub.S
> > +++ b/arch/arm64/kernel/hyp-stub.S
> > @@ -82,7 +82,15 @@ SYM_CODE_START_LOCAL(__finalise_el2)
> >  	tbnz	x1, #0, 1f
> >  
> >  	// Needs to be VHE capable, obviously
> > -	check_override id_aa64mmfr1 ID_AA64MMFR1_EL1_VH_SHIFT 2f 1f x1 x2
> > +	check_override id_aa64mmfr1 ID_AA64MMFR1_EL1_VH_SHIFT 0f 1f x1 x2
> > +
> > +0:	// Check whether we only want the hypervisor to run VHE, not the kernel
> > +	adr_l	x1, arm64_sw_feature_override
> > +	ldr	x2, [x1, FTR_OVR_VAL_OFFSET]
> > +	ldr	x1, [x1, FTR_OVR_MASK_OFFSET]
> > +	and	x2, x2, x1
> > +	ubfx	x2, x2, #ARM64_SW_FEATURE_OVERRIDE_HVHE, #4
> > +	cbz	x2, 2f
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> (I think we are trying too hard to make this look like a hardware
> features when a tbz would do ;)).

I had a similar feeling and whined on v1 :) Perhaps we can make a macro
for testing software feature if/when we ever stop representing SW
features like ID registers, per your suggestion.

--
Thanks,
Oliver
