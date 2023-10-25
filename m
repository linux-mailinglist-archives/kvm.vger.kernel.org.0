Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8377D6590
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 10:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233930AbjJYIqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 04:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232879AbjJYIqW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 04:46:22 -0400
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27147138
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 01:46:19 -0700 (PDT)
Date:   Wed, 25 Oct 2023 08:46:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698223577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R34VxL6nBY+odtqj70gS7ENe9/8bOPWPMd4dRDgXl9o=;
        b=jz+TN9eWAj7V4rX8XtWaUuJgGMA6e68ijIgpkREIgIgW8SQN18d4pDqqckjeKRGWOTd9QK
        4rcuw794lIdJZdOgxzdgO5b9TlRZsPsBqijYcjm34kqw6aT6MW7DbZGQncjgzTwP4ew0ny
        zOERCly4r+woBfWWtHLzky+tVVgYyW4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Miguel Luis <miguel.luis@oracle.com>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 5/5] KVM: arm64: Handle AArch32 SPSR_{irq,abt,und,fiq} as
 RAZ/WI
Message-ID: <ZTjV1Q05nXXOOyVO@linux.dev>
References: <20231023095444.1587322-1-maz@kernel.org>
 <20231023095444.1587322-6-maz@kernel.org>
 <7DD05DC0-164E-440F-BEB1-E5040C512008@oracle.com>
 <86jzrc3pbm.wl-maz@kernel.org>
 <ZThINaAfNDNrIAqI@linux.dev>
 <ZThNeyX0muR5yvey@linux.dev>
 <86h6mf3y3w.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86h6mf3y3w.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 25, 2023 at 09:28:03AM +0100, Marc Zyngier wrote:
> On Wed, 25 Oct 2023 00:04:27 +0100, Oliver Upton <oliver.upton@linux.dev> wrote:
> > Correction (I wasn't thinking): RES0 behavior should be invariant, much
> > like the UNDEF behavior of the other AA32-specific registers.
> 
> I'm not sure what you're asking for exactly here, so let me explain my
> understanding of the architecture on this point, which is that the
> *32_EL2 registers are different in nature from the SPSR_* registers.

Damn, I still didn't manage to get my point across!

> IFAR32_EL2 and co are accessors for the equivalent AArch32 registers.
> If AArch32 isn't implemented, then these registers should UNDEF,
> because there is nothing to access at all.
> 
> The status of SPSR_* is more subtle: the AArch32 exception model is
> banked (irq, fiq, abt, und), and for each bank we have a triplet
> (LR_*, SP_*, SPSR_*), plus the extra R[8-12]_fiq. On taking an
> exception from AArch32 EL1 to AArch64 EL2, all the (LR_*, SP_*,
> R*_fiq) are stored as part of the AArch64 GPRs (X16-X30, see I_PYKVS).

Thanks. Yeah, I've got a pretty good handle on what's going on here.
What I really was trying to compare is the way these aliases into AA32
state are handled, and the annoying difference between the two sets.

IFAR32 and friends UNDEF unconditionally w/o AArch32, which I quite
like.

To your point, the SPSR_* accessors still trap even if AArch32 is not
implemented. I was suggesting in passing that it'd be nice if the
architecture alternatively allowed for these to read as RES0 (no trap)
if NV==1 and AArch32 is not implemented, which aligns with your change.

But after all...

> we will never see an AArch32-capable, NV-capable HW implementation
> ever, so this is all fairly academic.

None of this matters in the first place :)

-- 
Thanks,
Oliver
