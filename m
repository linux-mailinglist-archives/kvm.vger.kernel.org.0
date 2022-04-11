Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E2F4FC807
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 01:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbiDKX1Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 19:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbiDKX1W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 19:27:22 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05861C916
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 16:25:05 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-2eafabbc80aso183058077b3.11
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 16:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ya3YKd5y6IepYaUPt1QYjg4a14IW27FChnQ2Rm/dnOo=;
        b=jIX3CSth4/ROeETd+zz/rnkRQZLeX2FFvt7Jgbq2zA3yj4RnxbaMoDxwRZa/jKjTpB
         idTosO5hqkFhJ6tqTZO1JFvUb+fGWxW28T8Fag6zBMy5mY9ae9yBXOo/4nh4qe2W2JA/
         wBfxW4tkSb/9ea9DXj4TT16x2GrUXAhxHoEGOjdYdPVlZU3WPrFVGf1oPmHZqpZaBJr2
         CN2rew8D8yoUq1CSNKnq/8jP034ukwAU4rgvucSqx9mQFaRvPmH9236d7P5PyIsp4oze
         J1nc+qbptuCSIRr8vQpMXatxcQrxJxQl8Lfg71HGaACENZK9vIP58taLpdARBINrueAc
         YQeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ya3YKd5y6IepYaUPt1QYjg4a14IW27FChnQ2Rm/dnOo=;
        b=kieL6n6GgGHoThQuc5rzHdixtfR5kkW9cpMf2b9fWYf4FdlYEBkb634lo/sJB0uffW
         h3PgXQvXrpRktsGVbAFHLjhk1IQKcCXgL9xU7d24exCyhlby7iTCNuLYsSCwSXbvs6Nz
         sBSxzgpacWhIztyGRuXVdI87ignxzU5PsY49piqKvCNZeyAp+nhXQ/jGstaFqBb3h542
         r7cUPfF0F2KFPTAj7Vlg4Rmw8Hn2FLiLj9igLaS0of8VB3DibCXKsx03CILsGNfV1K4e
         O3oj0Q4G4zg559Y8uZEkoceM6h/dI4JJPVe/Sh9rENIPoK9SbFoIOFNE7kVw63LAS4Db
         2Vtw==
X-Gm-Message-State: AOAM531N/nTZWPk48ymEIxObivEBT5pC+fPEN2lvWVLsLYtv6Nitj/2U
        aCoV7H7BcWaH5c96+XYTRlkgMUUT/NWzTFG5nE68dQ==
X-Google-Smtp-Source: ABdhPJyBFJfDrlEG5OjDhpGsudkU7Ns3awL++PcO1zZ3vE/oJmBHHlxI3g3q2Vi9eFDhPd7aRBTxl46Vd5DavnARJB8=
X-Received: by 2002:a81:ab51:0:b0:2eb:f5d7:f4bc with SMTP id
 d17-20020a81ab51000000b002ebf5d7f4bcmr10861706ywk.42.1649719504653; Mon, 11
 Apr 2022 16:25:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220321224358.1305530-1-bgardon@google.com> <20220321224358.1305530-8-bgardon@google.com>
 <YlSzI9ZfzPQZhPqj@google.com>
In-Reply-To: <YlSzI9ZfzPQZhPqj@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 11 Apr 2022 16:24:52 -0700
Message-ID: <CANgfPd8PsV3AGF=dMWWo6McMzPYsj-Sh+Udgy9WDeF5xy3DJEg@mail.gmail.com>
Subject: Re: [PATCH v2 7/9] KVM: x86/mmu: Add try_get_mt_mask to x86_ops
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Mon, Apr 11, 2022 at 4:00 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Mar 21, 2022, Ben Gardon wrote:
> > Add another function for getting the memory type mask to x86_ops.
> > This version of the function can fail, but it does not require a vCPU
> > pointer. It will be used in a subsequent commit for in-place large page
> > promotion when disabling dirty logging.
> >
> > No functional change intended.
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  arch/x86/include/asm/kvm-x86-ops.h | 1 +
> >  arch/x86/include/asm/kvm_host.h    | 2 ++
> >  arch/x86/kvm/svm/svm.c             | 9 +++++++++
> >  arch/x86/kvm/vmx/vmx.c             | 1 +
> >  4 files changed, 13 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > index 29affccb353c..29880363b5ed 100644
> > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > @@ -88,6 +88,7 @@ KVM_X86_OP_OPTIONAL(sync_pir_to_irr)
> >  KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
> >  KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
> >  KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
> > +KVM_X86_OP(try_get_mt_mask)
> >  KVM_X86_OP(load_mmu_pgd)
> >  KVM_X86_OP(has_wbinvd_exit)
> >  KVM_X86_OP(get_l2_tsc_offset)
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index f72e80178ffc..a114e4782702 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1422,6 +1422,8 @@ struct kvm_x86_ops {
> >       int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
> >       int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
> >       u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
> > +     bool (*try_get_mt_mask)(struct kvm *kvm, gfn_t gfn,
> > +                             bool is_mmio, u64 *mask);
>
> There's an old saying in Tennessee - I know it's in Texas, probably in Tennessee -
> that says, fool me once, shame on... shame on you. Fool me... you can't get fooled again.

Haha shoot here I was saying it wrong all these years and getting
fooled too many times.

Paolo, did you already queue this series or should I send out a v3? I
thought I saw the "queued,thanks" come through at some point, but
maybe I'm mis-remembering.

>
> Thou shalt not trick me again by using a bool for pass/fail!  Though this one
> doesn't have same potential for pain as the TDP MMU's atomic operations.
>
> And as a bonus, if we use 0/-errno, then we can use KVM_X86_OP_OPTIONAL_RET0()
> and SVM doesn't need to provide an implementation.
>
> Tangentially related to the return type, what about naming it something like
> get_vm_wide_mt_mask() to convey exactly what it's doing?  The @kvm param kinda
> does that, but IMO it doesn't do a good of capturing why the function can fail.
> Adding "vm_wide" helps explain why it can, i.e. that there may not be a VM-wide
> memtype established for the gfn.
>
> As penance for your boolean sin, can you slot this in earlier in your series?
> It's obviously not a hard dependency, but using a u64 for the mask here and then
> undoing the whole thing is rather silly.  Compile tested only at this point, I'll
> test on an actual system ASAP and let you know if I did something stupid.
>
> From: Sean Christopherson <seanjc@google.com>
> Date: Mon, 11 Apr 2022 15:12:16 -0700
> Subject: [PATCH] KVM: x86: Restrict get_mt_mask() to a u8, use
>  KVM_X86_OP_OPTIONAL_RET0
>
> Restrict get_mt_mask() to a u8 and reintroduce using a RET0 static_call
> for the SVM implementation.  EPT stores the memtype information in the
> lower 8 bits (bits 6:3 to be precise), and even returns a shifted u8
> without an explicit cast to a larger type; there's no need to return a
> full u64.
>
> Note, RET0 doesn't play nice with a u64 return on 32-bit kernels, see
> commit bf07be36cd88 ("KVM: x86: do not use KVM_X86_OP_OPTIONAL_RET0 for
> get_mt_mask").
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h | 2 +-
>  arch/x86/include/asm/kvm_host.h    | 2 +-
>  arch/x86/kvm/svm/svm.c             | 6 ------
>  arch/x86/kvm/vmx/vmx.c             | 2 +-
>  4 files changed, 3 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 96e4e9842dfc..0d16f21a6203 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -87,7 +87,7 @@ KVM_X86_OP(deliver_interrupt)
>  KVM_X86_OP_OPTIONAL(sync_pir_to_irr)
>  KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
>  KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
> -KVM_X86_OP(get_mt_mask)
> +KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
>  KVM_X86_OP(load_mmu_pgd)
>  KVM_X86_OP(has_wbinvd_exit)
>  KVM_X86_OP(get_l2_tsc_offset)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 2c20f715f009..dc4d34f1bcf9 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1421,7 +1421,7 @@ struct kvm_x86_ops {
>         int (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
>         int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
>         int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
> -       u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
> +       u8 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
>
>         void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>                              int root_level);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index fc1725b7d05f..56f03eafe421 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4011,11 +4011,6 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
>         return true;
>  }
>
> -static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> -{
> -       return 0;
> -}
> -
>  static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  {
>         struct vcpu_svm *svm = to_svm(vcpu);
> @@ -4673,7 +4668,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>         .check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
>         .apicv_post_state_restore = avic_apicv_post_state_restore,
>
> -       .get_mt_mask = svm_get_mt_mask,
>         .get_exit_info = svm_get_exit_info,
>
>         .vcpu_after_set_cpuid = svm_vcpu_after_set_cpuid,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index cf8581978bce..646fa609aa0d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7142,7 +7142,7 @@ static int __init vmx_check_processor_compat(void)
>         return 0;
>  }
>
> -static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> +static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>  {
>         u8 cache;
>
>
> base-commit: 59d9e75d641565603e7c293f4cec182d86db8586
> --
>
>
>
>
>
>
