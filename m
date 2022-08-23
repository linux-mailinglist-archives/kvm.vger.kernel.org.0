Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDA2D59EBB8
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 21:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiHWTBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 15:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233564AbiHWTAZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 15:00:25 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB964A838
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 10:31:11 -0700 (PDT)
Date:   Tue, 23 Aug 2022 12:27:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661275662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B9cH+rlavh07rmBaYNLiaL07EycjD+h+sDN5b0VRnAk=;
        b=hLRSAesKGsgS0yM3sd/pZYyle7SguZjXMHnoQy7soEytupF9acck64rtKLWPrTw+gK7y8E
        FQEmRhf26oI/HRD6hZvVHh+M6wHTSiE/LQSL5cEG3sMuXLD/heahT6F9o8a6nq2POlVbyi
        tgdEQu2andp3uTGloEdg57fkxmARMN8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com, will@kernel.org
Subject: Re: [PATCH 5/6] KVM: arm64: Treat 32bit ID registers as RAZ/WI on
 64bit-only system
Message-ID: <YwUOBuDTzw+zT0/T@google.com>
References: <20220817214818.3243383-1-oliver.upton@linux.dev>
 <20220817214818.3243383-6-oliver.upton@linux.dev>
 <87czcqx547.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87czcqx547.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Marc,

Thanks for the review!

On Tue, Aug 23, 2022 at 06:05:28PM +0100, Marc Zyngier wrote:
> On Wed, 17 Aug 2022 22:48:17 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > One of the oddities of the architecture is that the AArch64 views of the
> > AArch32 ID registers are UNKNOWN if AArch32 isn't implemented at any EL.
> > Nonetheless, KVM exposes these registers to userspace for the sake of
> > save/restore. It is possible that the UNKNOWN value could differ between
> > systems, leading to a rejected write from userspace.
> > 
> > Avoid the issue altogether by handling the AArch32 ID registers as
> > RAZ/WI when on an AArch64-only system.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 63 ++++++++++++++++++++++++++-------------
> >  1 file changed, 43 insertions(+), 20 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 9f06c85f26b8..5f6a633182c8 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1145,6 +1145,20 @@ static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
> >  	return 0;
> >  }
> >  
> > +static unsigned int aa32_id_visibility(const struct kvm_vcpu *vcpu,
> > +				       const struct sys_reg_desc *r)
> > +{
> > +	/*
> > +	 * AArch32 ID registers are UNKNOWN if AArch32 isn't implemented at any
> > +	 * EL. Promote to RAZ/WI in order to guarantee consistency between
> > +	 * systems.
> > +	 */
> > +	if (!kvm_supports_32bit_el0())
> > +		return REG_RAZ | REG_USER_WI;
> 
> This is probably only a nit, but why does one visibility has a _USER_
> tag while the other doesn't? In other word, what sysregs are WI from
> userspace that aren't so from the guest?
> 
> Also, do we have any cases where RAZ and WI would be used
> independently? My gut feeling is that RAZ implies WI in most (all?)
> cases. If this assumption holds, shouldn't we simply rename REG_RAZ to
> REG_RAZ_WI and be done with it?

Yeah, this reads a bit strange, but there is some reason around it (I
think!)

As it applies to ID registers, REG_RAZ already implies RAZ w/ immutable
writes (-EINVAL if something different is written). As such I didn't want
to change the meaning of the other ID registers to WI and only ignore
writes for the registers that could have an UNKNOWN value. Furthermore,
I added the _USER_ tag to make it clear that we aren't magically allowing
writes from the guest to these registers.

I think we will need an additional visibility bit (or special accessor,
which I tried to avoid) to precisely apply WI to the 32bit registers,
but if the _USER_ tag is distracting I can get rid of it. After all,
hardware should politely UNDEF the guest when writing to such a
register.

Thoughts?

--
Thanks,
Oliver
