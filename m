Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6134747007
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 13:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbjGDLfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 07:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbjGDLfe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 07:35:34 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C5C172B
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 04:34:51 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1b82616c4ecso24858935ad.2
        for <kvm@vger.kernel.org>; Tue, 04 Jul 2023 04:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1688470491; x=1691062491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vX+IcUnnGo66OiUlAe+T2bgBkHMF6tovqCGWaacWWp0=;
        b=hqJthy8eneNLNhStDpLQMPNcFLc///PvceiQrj0YabAbFkvHdp9IGpmj2EZ104d2aR
         I/F/ftRlZSZ7U7FmfIy8GBr0mmg1XHgOrtutzpOWrXeYDTeD+jIhINas1Vs4ui3EOVqO
         Ns5u2cXasFz3H83Uivp4Nww4FPPu9vomstZ0I5xwJaTAlKNxiY8/sLzZsb5SYvITMivL
         j0AV4rZWgj4ZI0/9sT/rQ2DnzfHZSPZHnts+xrUETBYEunYJplbbNSaL8RI6tFfGfxUO
         axd+5gnOw2NIgnhfNC3fRsx7t6r6ojMChHRTtX606TpebglnapScXT/Q7J2q+UOh6PeZ
         BGhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688470491; x=1691062491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vX+IcUnnGo66OiUlAe+T2bgBkHMF6tovqCGWaacWWp0=;
        b=cuIT6sR8ETuE5izU813OT9DoLy2xOapzdEtj4zxI3TwtqE6aTG7rdZaDgPTC89Pjsd
         tl59UQsW41NZcahdVYXSIfczbML6ilYBmxodI2w6JmQRwDAJBEBPej/8UZ55uDe6RdWf
         vRbpbk60HnJfIy33I1FHHV2ThPU/PbjJNFONp1yJ2q9c2KT5E00sA4Ck2q0Rx0UGPtZS
         avM0zXipNc7JJY+0LN/dhFkZAb4wKqDUPA0QPGz0yeGAyatlBZKUJCL2zvfffoNd6YGN
         xEQ1ujZtPlwrxf0exmqXXOHz274s0RB52yzstA9py4pDraaHE3bk6Y3v3X3Z5emrNthT
         WvmA==
X-Gm-Message-State: ABy/qLas/jtNyxMk7wgMMBeg97+dHr7Lik6THNdCrQQX2+a5Qdc/Cwh5
        DnBbBZj+bVk0ERD9n1vBmIpyeQ==
X-Google-Smtp-Source: APBJJlHo4AkgsIvc07sjsIQzFsqO2qiwuO87rpQGYieS6MfkOi1EoSqenVLkcGJJ7u0FLSHyj/Gn7g==
X-Received: by 2002:a17:902:f68c:b0:1b7:eebc:884 with SMTP id l12-20020a170902f68c00b001b7eebc0884mr12205180plg.64.1688470491045;
        Tue, 04 Jul 2023 04:34:51 -0700 (PDT)
Received: from n157-102-137.byted.org ([240e:b1:e401:3::41])
        by smtp.gmail.com with ESMTPSA id 12-20020a170902c10c00b001b694140d96sm8039917pli.170.2023.07.04.04.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jul 2023 04:34:50 -0700 (PDT)
From:   Qi Ai <aiqi.i7@bytedance.com>
To:     seanjc@google.com
Cc:     aiqi.i7@bytedance.com, bp@alien8.de, cenjiahui@bytedance.com,
        chao.gao@intel.com, dave.hansen@linux.intel.com,
        dengqiao.joey@bytedance.com, fangying.tommy@bytedance.com,
        fengzhimin@bytedance.com, hpa@zytor.com, kvm@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH] kvm/x86: clear hlt for intel cpu when resetting vcpu 
Date:   Tue,  4 Jul 2023 19:34:05 +0800
Message-Id: <20230704113405.3335046-1-aiqi.i7@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <ZJ9djqQZWSEjJlfb@google.com>
References: <ZJ9djqQZWSEjJlfb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 1, 2023 at 6:56 AM Sean Christopherson <seanjc@google.com> wrote:
>
> mn Fri, Jun 30, 2023, Chao Gao wrote:
> > On Fri, Jun 30, 2023 at 03:26:12PM +0800, Qi Ai wrote:
> > >+                            !is_protmode(vcpu))
> > >+                    kvm_x86_ops.clear_hlt(vcpu);
> >
> > Use static_call_cond(kvm_x86_clear_hlt)(vcpu) instead.
> >
> > It looks incorrect that we add this side-effect heuristically here. I
>
> Yeah, adding heuristics to KVM_SET_REGS isn't happening.  KVM's existing hack
> for "Older userspace" in __set_sregs_common() is bad enough:
>
>         /* Older userspace won't unhalt the vcpu on reset. */
>         if (kvm_vcpu_is_bsp(vcpu) && kvm_rip_read(vcpu) == 0xfff0 &&
>             sregs->cs.selector == 0xf000 && sregs->cs.base == 0xffff0000 &&
>             !is_protmode(vcpu))
>                 vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>
> > am wondering if we can link vcpu->arch.mp_state to VMCS activity state,
>
> Hrm, maybe.
>
> > i.e., when mp_state is set to RUNNABLE in KVM_SET_MP_STATE ioctl, KVM
> > sets VMCS activity state to active.
>
> Not in the ioctl(), there needs to be a proper set of APIs, e.g. so that the
> existing hack works, and so that KVM actually reports out to userspace that a
> vCPU is HALTED if userspace gained control of the vCPU, e.g. after an IRQ exit,
> while the vCPU was HALTED.  I.e. mp_state versus vmcs.ACTIVITY_STATE needs to be
> bidirectional, not one-way.  E.g. if a vCPU is live migrated, I'm pretty sure
> vmcs.ACTIVITY_STATE is lost, which is wrong.
>
> The downside is that if KVM propagates vmcs.ACTIVITY_STATE to mp_state for the
> halted case, then KVM will enter kvm_vcpu_halt() instead of entering the guest
> in halted state, which is undesirable.   Hmm, that can be handled by treating
> the vCPU as running, e.g.
>
> static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
> {
>         return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE ||
>                 (vcpu->arch.mp_state == KVM_MP_STATE_HALTED &&
>                  kvm_hlt_in_guest(vcpu->kvm))) &&
>                !vcpu->arch.apf.halted);
> }
>
> but that would have cascading effect to a whole pile of things.  I don't *think*
> they'd be used with kvm_hlt_in_guest(), but we've had weirder stuff.
>
> I'm half tempted to solve this particular issue by stuffing vmcs.ACTIVITY_STATE on
> shutdown, similar to what SVM does on shutdown interception.  KVM doesn't come
> anywhere near faithfully emulating shutdown, so it's unlikely to break anything.
> And then the mp_state vs. hlt_in_guest coulbe tackled separately.  Ugh, but that
> wouldn't cover a synthesized KVM_REQ_TRIPLE_FAULT.
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 44fb619803b8..ee4bb37067d1 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5312,6 +5312,8 @@ static __always_inline int handle_external_interrupt(struct kvm_vcpu *vcpu)
>
>  static int handle_triple_fault(struct kvm_vcpu *vcpu)
>  {
> +       vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
> +
>         vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
>         vcpu->mmio_needed = 0;
>         return 0;
>
>
> I don't suppose QEMU can to blast INIT at all vCPUs for this case?

Reproduce this problem need to use the cpu_pm=on in QEMU, so execute halt in vm doesn't
cause a vm exit, so mp_state will never be HLT. I am confused why mp_state is considered in this case.

And the bsp's vmcs.ACTIVITY_STATE need to reset to ACTIVITY to solve this problem.
We need a proper set of APIs as you say. In this case, do we only provide a reset ioctl,
or do we need to report vmcs.ACTIVITY_STATE to the userspace?
