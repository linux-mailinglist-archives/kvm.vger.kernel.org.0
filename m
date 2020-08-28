Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBF9256222
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 22:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgH1Ujz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 16:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbgH1Ujw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 16:39:52 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CA3C061264
        for <kvm@vger.kernel.org>; Fri, 28 Aug 2020 13:39:52 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id r8so347186ota.6
        for <kvm@vger.kernel.org>; Fri, 28 Aug 2020 13:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LoEnI6osRj6yag/7TgRddr4TWXVaho6xu2ojKmFndVs=;
        b=TiElAugIVvRoduQxZ8e0Ug49jkWVhXTEhvgxShz2TILmhyYd6887UvA4i908P2zVGL
         oBC+yeSxYh5ryXv3nuafaJQ3bFDs08Xk1cTzq9dYidvBvAAUiBfZcICepOssoo1bmPaA
         gVNaRDHNN8WHZ+PrEigLtPw04cI9HdST4dcC4YYIMeaCBziGVR3LDG5/BU9nzfAT+ZG2
         td5QJ+kyFugt4LACdOiIXA+Z0env1/KRqWP/Dt2gKj59tJ/MXArIKqpUWG/S94TLj38W
         9SL/JepY4yTrtbw41wghHxlr32fZb7Ulj3eJtvyavAt8ipOALUuzVkgG6itu3RS3HLJC
         XX+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LoEnI6osRj6yag/7TgRddr4TWXVaho6xu2ojKmFndVs=;
        b=XnTb9LmNFrBJWLCROSZaJUIoPBSXMRDJedNOXyJ9cKgf40AUmgUxSFF1iKbtAiQpdZ
         L4feprXA8FSWhWtzD7LMFMPI0FamB/oc3y1aY+x9gDItgwkiqnv8dAb2QTVqYLNFcqEK
         6jXLoqkQrTCb+C+jXWBBZ+uT60et2XRBDDIc1J2O8X74+xko7JqqxC+EoC/HLgoCp0kE
         hAT+9k6nvU4IAK8UhA2E7qgbSeJgyjKv48bYQEggA/+vHHyCKm+VgN8BfAC7C9rSdvZK
         3XerfPq60dYjrhu/nzMGnuvnxqWTdJm7Iol6iFF68voZ+PZYYib9FvCOBCqNiw0w/g0Y
         7Oqw==
X-Gm-Message-State: AOAM530g7EiYIM+s5uL/NZaH5fglUMrvOr4IBh5eDfhujXH7CKgMHc5j
        3/f5dg67RuWIo30eaRgTJXme1d0D8FKmDzKAeuG9mQ==
X-Google-Smtp-Source: ABdhPJxYdLw7BXQXA24VIltH7C6XUh7pH1HLMLSyWcOc2TFZmVnQFgAM/7fnxZTmVHnDhy7J8INPrPSPHU83LIS1l74=
X-Received: by 2002:a9d:1c8f:: with SMTP id l15mr302546ota.241.1598647190949;
 Fri, 28 Aug 2020 13:39:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200828085622.8365-1-chenyi.qiang@intel.com> <20200828085622.8365-4-chenyi.qiang@intel.com>
In-Reply-To: <20200828085622.8365-4-chenyi.qiang@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 28 Aug 2020 13:39:39 -0700
Message-ID: <CALMp9eT1makVq46TB-EtTPiz=Z_2DfhudJekrtheSsmwBc4pZA@mail.gmail.com>
Subject: Re: [PATCH 3/5] KVM: nVMX: Update VMX controls MSR according to guest
 CPUID after setting VMX MSRs
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 28, 2020 at 1:54 AM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
>
> Update the fields (i.e. VM_{ENTRY_LOAD, EXIT_CLEAR}_BNDCFGS and
> VM_{ENTRY, EXIT}_LOAD_IA32_PERF_GLOBAL_CTRL) in
> nested MSR_IA32_VMX_TRUE_{ENTRY, EXIT}_CTLS according to guest CPUID
> when user space initializes the features MSRs. Regardless of the order
> of SET_CPUID and SET_MSRS from the user space, do the update to avoid
> MSR values overriding.
>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 819c185adf09..f9664ccc003b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -345,6 +345,7 @@ static bool guest_state_valid(struct kvm_vcpu *vcpu);
>  static u32 vmx_segment_access_rights(struct kvm_segment *var);
>  static __always_inline void vmx_disable_intercept_for_msr(unsigned long *msr_bitmap,
>                                                           u32 msr, int type);
> +static void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu);
>
>  void vmx_vmexit(void);
>
> @@ -2161,7 +2162,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>                         return 1; /* they are read-only */
>                 if (!nested_vmx_allowed(vcpu))
>                         return 1;
> -               return vmx_set_vmx_msr(vcpu, msr_index, data);
> +               ret = vmx_set_vmx_msr(vcpu, msr_index, data);
> +               nested_vmx_pmu_entry_exit_ctls_update(vcpu);
> +               nested_vmx_entry_exit_ctls_update(vcpu);
> +               break;

Now I see what you're doing. This commit should probably come before
the previous commit, so that at no point in the series can userspace
set VMX MSR bits that should be cleared based on the guest CPUID.

There's an ABI change here: userspace may no longer get -EINVAL if it
tries to set an illegal VMX MSR bit. Instead, some illegal bits are
silently cleared. Moreover, these functions will potentially set VMX
MSR bits that userspace has just asked to clear.

>         case MSR_IA32_RTIT_CTL:
>                 if (!vmx_pt_mode_is_host_guest() ||
>                         vmx_rtit_ctl_check(vcpu, data) ||
> --
> 2.17.1
>
