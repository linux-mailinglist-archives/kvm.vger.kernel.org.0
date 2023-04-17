Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B392E6E3E49
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 05:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbjDQDhd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Apr 2023 23:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjDQDhF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Apr 2023 23:37:05 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F72C4497
        for <kvm@vger.kernel.org>; Sun, 16 Apr 2023 20:34:55 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1a652700c36so429395ad.0
        for <kvm@vger.kernel.org>; Sun, 16 Apr 2023 20:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681702494; x=1684294494;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NlW2TVVx2ak294Y+VUa1rl/r58qCiE5sh+v8a4TOPOo=;
        b=tEkMX2pLHGrbo019aJCQi+10L/qFWKi2RdR9ix640cDeuAnVgB0I5VZ1oArJKNLsCF
         pWQZkLtyn8ZavtmHkVgYf7DMcxlXr38qdv0YGv/6MDZA95Ovs0JDHaO8kzjOfndIVFWw
         l+FbineuX/d3Cq+6ixhP9Fyu84qGvP0U3T+Gds7pDbB/7gYiud6w2cWeM/UiKXlm97ko
         5NODe5Ims2uMcg5t1xkSy3AtZOcycNfQ+di3hWv1lN7BmIV5O/okne+yeR+QBbe1BtX9
         442bn35GDCwsd1RExs+oAoNp+GM1+6Rkber7Ftz7qLq79QHXvsgfTZGRsrmD9NyJFpwZ
         rhgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681702494; x=1684294494;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NlW2TVVx2ak294Y+VUa1rl/r58qCiE5sh+v8a4TOPOo=;
        b=M3y7+EU14BZ+u8+DGPFTzE0dSuHgd1j0FyAEZUP19F3WnUc4Xp6xeAWoHWOeTy8dVg
         CJSx6f3abhL8/1OtmhURdcikxBCK9hqQzB0FLYwhpMMPuO5Sj52zUrLuvSqj1KqHRHWp
         7domVcGcofUnXMUPvqE/en9FSArqJWHULo9Ye3PYPopi+jQqm8qYH121weGY8oAjTkWs
         89h/33USQcbqU4sdGJCHIp4sNZ5eSfAb0HheLJczeECSvlZG/nyHZOGLG21E6GpYUz/B
         dGK0iUh37S4VKSG1zMSVl5mnWtLNyf+ioANrtvqHH1QiguYmdAQbDvSA7h8M6OieHpO6
         MuMA==
X-Gm-Message-State: AAQBX9dqK8VXm7M+UxRhtjkFyio1yKDLSM/SoTuirF9vPd4W/zYmgauJ
        ncKRVH/rBLPnjLwNHLl8QTHsGA==
X-Google-Smtp-Source: AKy350ZuBUQNLPxBSAuymBWh4oP4g4a3g2zWJtFKy9jLFZ4M1TP0qTcejsl9m7wrjq4FbzrkEVzf2g==
X-Received: by 2002:a17:903:4103:b0:1a6:760c:af3d with SMTP id r3-20020a170903410300b001a6760caf3dmr604530pld.16.1681702494429;
        Sun, 16 Apr 2023 20:34:54 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id ij8-20020a170902ab4800b001a514d75d16sm6516955plb.13.2023.04.16.20.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Apr 2023 20:34:53 -0700 (PDT)
Date:   Sun, 16 Apr 2023 20:34:49 -0700
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>,
        Colton Lewis <coltonlewis@google.com>,
        Joey Gouly <joey.gouly@arm.com>, dwmw2@infradead.org
Subject: Re: [PATCH v4 05/20] KVM: arm64: timers: Allow physical offset
 without CNTPOFF_EL2
Message-ID: <20230417033449.2obz4ywzdtkl2z42@google.com>
References: <20230330174800.2677007-1-maz@kernel.org>
 <20230330174800.2677007-6-maz@kernel.org>
 <20230410153441.vddskgxu2zzsi7bq@google.com>
 <86h6tkkky4.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86h6tkkky4.wl-maz@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > +	assign_clear_set_bit(tpt, CNTHCTL_EL1PCEN << 10, set, clr);
> > > +	assign_clear_set_bit(tpc, CNTHCTL_EL1PCTEN << 10, set, clr);
> > 
> > Nit: IMHO the way the code specifies the 'set' and 'clr' arguments for
> > the macro might be a bit confusing ('set' is for '_clr', and 'clr' is
> > for '_set')?
> 
> I don't disagree, but we end-up with bits of different polarity once
> NV is fully in, see:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/tree/arch/arm64/kvm/arch_timer.c?h=kvm-arm64/nv-6.4-WIP#n861
> 
> > Perhaps changing the parameter names of assign_clear_set_bit() like
> > below or flipping the condition (i.e. Specify !tpt or no_tpt instead
> > of tpt) might be less confusing?
> > 
> > #define assign_clear_set_bit(_pred, _bit, _t_val, _f_val)	\
> > do {								\
> > 	if (_pred)						\
> > 		(_t_val) |= (_bit);				\
> > 	else							\
> > 		(_f_val) |= (_bit);				\
> > } while (0)
> 
> See the pointer above. We need a good way to specify bits that have
> one polarity or another, and compute the result given the high-level
> constraints that are provided by the emulation code.
> 
> So far, I haven't been able to work out something "nice".

Thank you for the pointer.  Understood.
I don't have a batter idea though :)

> 
> [...]
> 
> > > +	{ SYS_DESC(SYS_CNTPCT_EL0), access_arch_timer },
> > > +	{ SYS_DESC(SYS_CNTPCTSS_EL0), access_arch_timer },
> > >  	{ SYS_DESC(SYS_CNTP_TVAL_EL0), access_arch_timer },
> > >  	{ SYS_DESC(SYS_CNTP_CTL_EL0), access_arch_timer },
> > >  	{ SYS_DESC(SYS_CNTP_CVAL_EL0), access_arch_timer },
> > > @@ -2525,6 +2533,7 @@ static const struct sys_reg_desc cp15_64_regs[] = {
> > >  	{ Op1( 0), CRn( 0), CRm( 2), Op2( 0), access_vm_reg, NULL, TTBR0_EL1 },
> > >  	{ CP15_PMU_SYS_REG(DIRECT, 0, 0, 9, 0), .access = access_pmu_evcntr },
> > >  	{ Op1( 0), CRn( 0), CRm(12), Op2( 0), access_gic_sgi }, /* ICC_SGI1R */
> > > +	{ SYS_DESC(SYS_AARCH32_CNTPCT),	      access_arch_timer },
> > 
> > Shouldn't KVM also emulate CNTPCTSS (Aarch32) when its trapping is
> > enabled on the host with ECV_CNTPOFF ?
> 
> Oh, well spotted. I'll queue something on top of the series to that
> effect (I'd rather not respin it as it has been in -next for some
> time, and the merge window is approaching).

Understood.


> 
> > 
> > 
> > >  	{ Op1( 1), CRn( 0), CRm( 2), Op2( 0), access_vm_reg, NULL, TTBR1_EL1 },
> > >  	{ Op1( 1), CRn( 0), CRm(12), Op2( 0), access_gic_sgi }, /* ICC_ASGI1R */
> > >  	{ Op1( 2), CRn( 0), CRm(12), Op2( 0), access_gic_sgi }, /* ICC_SGI0R */
> > > -- 
> > > 2.34.1
> > > 
> > > 
> > 
> > Nit: In emulating reading physical counter/timer for direct_ptimer
> > (poffset != 0 on VHE without ECV_CNTPOFF), it appears that
> > kvm_arm_timer_read_sysreg() unnecessarily calls
> > timer_{save,restore}_state(), and kvm_arm_timer_write_sysreg()
> > unnecessarily calls timer_save_state().  Couldn't we skip those
> > unnecessary calls ? (I didn't check all the following patches, but
> > the current code would be more convenient in the following patches ?)
> 
> Well, it depends how you look at it. We still perform "some" level of
> emulation (such as offsetting CVAL), and it allows us to share some
> code with the full emulation.

Even if we skip calling timer_save_state() and/or timer_restore_state(),
I would think we could still share some code with the full emulation.
What I meant was something like below (a diff from the patch-5).
Or Am I misunderstanding something?


--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1003,7 +1003,7 @@ u64 kvm_arm_timer_read_sysreg(struct kvm_vcpu *vcpu,
        get_timer_map(vcpu, &map);
        timer = vcpu_get_timer(vcpu, tmr);
 
-       if (timer == map.emul_ptimer)
+       if (timer == map.emul_ptimer || timer == map.direct_ptimer)
                return kvm_arm_timer_read(vcpu, timer, treg);
 
        preempt_disable();
@@ -1056,7 +1056,9 @@ void kvm_arm_timer_write_sysreg(struct kvm_vcpu *vcpu,
                timer_emulate(timer);
        } else {
                preempt_disable();
-               timer_save_state(timer);
+               if (timer != map.direct_ptimer)
+                       timer_save_state(timer);
+
                kvm_arm_timer_write(vcpu, timer, treg, val);
                timer_restore_state(timer);
                preempt_enable();


> On top of that, we already fast-track CNTPCT_EL0, which is the main
> user, and has a visible benefit with NV. If anything, I'd rather add a
> similar fast-tracking for the read side of CNTP_CVAL_EL0 and
> CNTP_CTL_EL0. We could then leave that code for 32bit only, which
> nobody gives a toss about.
> 
> What do you think?

Ah, I didn't check that fast-track CNTPCT_EL0.
Yes, that would be nicer.

Thank you!
Reiji
