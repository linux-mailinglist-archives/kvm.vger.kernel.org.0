Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3781B7D39
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 19:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbgDXRrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 13:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727059AbgDXRrR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 13:47:17 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1106FC09B047
        for <kvm@vger.kernel.org>; Fri, 24 Apr 2020 10:47:17 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id t12so10060673ile.9
        for <kvm@vger.kernel.org>; Fri, 24 Apr 2020 10:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sKSSuyIM7h/aKoat8JN5p5oAc8dD6LwiiRcXuvb6FJg=;
        b=hdOLtALOJIAdp5HOeuGfD+BemNASe/wQQZAed75Fun4hGIr2Un7/KLTVdtjYlwKadT
         ySODLjD2TzaY8BERV7Dv8W9cuFn/q5m2NIuO7RBDwOQR6R9FjTLgBXfdkj2RjKCaYQMc
         jfOvD6zWaFJFgI5E/ZRV1dnEH5d9aA+5wtTyViHeColV1N4d37gt5Msya84UVIeVY2m8
         x+AohimdXrrxp432a2yKiVQ11FHpij94iNi/L2IO1OS1ZaOG7YPEe7momAoTA+WFHWwP
         ZCmIcYfy120L2gIGEl4opndwOaK0IxHEQsO3SOe3Nrj/wQXrPuhpbClUGXQu03voc9kA
         NHtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sKSSuyIM7h/aKoat8JN5p5oAc8dD6LwiiRcXuvb6FJg=;
        b=jrCGxIec1cjtRTZF+/hlxE6KLhcN7YjfIcMjgYKhldwb/iFkE4VZb/DgdBt8aO1VHt
         y5FdcMXyR+h0TTSG9Q5dgCapWSpZewKhB4ddL2rRjCK6Nf9QGSFS6wJgiUuTswnRSVHZ
         H26bsbYVaSwxHPjC8XPpHco4BX5p0Zc3mGSaLjY0AZxVrSqqK9E/qXNRN91AP2H9r3YY
         m6nKuPj9FHpaJhVq545IhVD4mBo11DP6U55OdjTiyqjYlYDa10spVBgVgrCeUY5gDfZ+
         47XZrsJ/ujiWHfNYQJ34ZkTQjQLVVkxT3wuoxw8OZNgrrhi93Hfhq0p8hWT0wZYRXrHB
         PHHA==
X-Gm-Message-State: AGi0PuazDI1IrV43DSlOxQWLg7By5zD0YqrXEi42bTndEAA1vP2gcJ1I
        TDmqMGcOZX1bWp+RtxpzO6GrT40rPaH7PEi4Os0NgA==
X-Google-Smtp-Source: APiQypL33upLDbmpcIlEJjk6eF3YQBM3XWRCo9LzVCPp+8D7H4R1+v6oXMkEL3oc6SzaHIc3QXUGu6X+yDnyEcH9CYs=
X-Received: by 2002:a92:985d:: with SMTP id l90mr10067400ili.108.1587750435970;
 Fri, 24 Apr 2020 10:47:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200424171925.1178-1-sean.j.christopherson@intel.com>
In-Reply-To: <20200424171925.1178-1-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 24 Apr 2020 10:47:04 -0700
Message-ID: <CALMp9eRG=L_dQfS_qpYhJ_86B-yyfYYg+pwcixQOfWT4hwCa1Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Tweak handling of failure code for nested
 VM-Enter failure
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 10:19 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Use an enum for passing around the failure code for a failed VM-Enter
> that results in VM-Exit to provide a level of indirection from the final
> resting place of the failure code, vmcs.EXIT_QUALIFICATION.  The exit
> qualification field is an unsigned long, e.g. passing around
> 'u32 exit_qual' throws up red flags as it suggests KVM may be dropping
> bits when reporting errors to L1.  This is a red herring because the
> only defined failure codes are 0, 2, 3, and 4, i.e. don't come remotely
> close to overflowing a u32.
>
> Setting vmcs.EXIT_QUALIFICATION on entry failure is further complicated
> by the MSR load list, which returns the (1-based) entry that failed, and
> the number of MSRs to load is a 32-bit VMCS field.  At first blush, it
> would appear that overflowing a u32 is possible, but the number of MSRs
> that can be loaded is hardcapped at 4096 (limited by MSR_IA32_VMX_MISC).
>
> In other words, there are two completely disparate types of data that
> eventually get stuffed into vmcs.EXIT_QUALIFICATION, neither of which is
> an 'unsigned long' in nature.  This was presumably the reasoning for
> switching to 'u32' when the related code was refactored in commit
> ca0bde28f2ed6 ("kvm: nVMX: Split VMCS checks from nested_vmx_run()").
>
> Using an enum for the failure code addresses the technically-possible-
> but-will-never-happen scenario where Intel defines a failure code that
> doesn't fit in a 32-bit integer.  The enum variables and values will
> either be automatically sized (gcc 5.4 behavior) or be subjected to some
> combination of truncation.  The former case will simply work, while the
> latter will trigger a compile-time warning unless the compiler is being
> particularly unhelpful.
>
> Separating the failure code from the failed MSR entry allows for
> disassociating both from vmcs.EXIT_QUALIFICATION, which avoids the
> conundrum where KVM has to choose between 'u32 exit_qual' and tracking
> values as 'unsigned long' that have no business being tracked as such.
>
> Opportunistically rename the variables in load_vmcs12_host_state() and
> vmx_set_nested_state() to call out that they're ignored, and add a
> comment in nested_vmx_load_msr() to call out that returning 'i + 1'
> can't wrap.
>
> No functional change intended.
>
> Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/vmx.h | 10 ++++++----
>  arch/x86/kvm/vmx/nested.c  | 38 +++++++++++++++++++++-----------------
>  2 files changed, 27 insertions(+), 21 deletions(-)
>
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 5e090d1f03f8..cd7de4b401fe 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -527,10 +527,12 @@ struct vmx_msr_entry {
>  /*
>   * Exit Qualifications for entry failure during or after loading guest state
>   */
> -#define ENTRY_FAIL_DEFAULT             0
> -#define ENTRY_FAIL_PDPTE               2
> -#define ENTRY_FAIL_NMI                 3
> -#define ENTRY_FAIL_VMCS_LINK_PTR       4
> +enum vm_entry_failure_code {
> +       ENTRY_FAIL_DEFAULT              = 0,
> +       ENTRY_FAIL_PDPTE                = 2,
> +       ENTRY_FAIL_NMI                  = 3,
> +       ENTRY_FAIL_VMCS_LINK_PTR        = 4,
> +};
>
>  /*
>   * Exit Qualifications for EPT Violations
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index b516c24494e3..e66320997910 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -927,6 +927,7 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
>         }
>         return 0;
>  fail:
> +       /* Note, max_msr_list_size is at most 4096, i.e. this can't wrap. */
>         return i + 1;
>  }
>
> @@ -1122,7 +1123,7 @@ static bool nested_vmx_transition_mmu_sync(struct kvm_vcpu *vcpu)
>   * @entry_failure_code.
>   */
>  static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool nested_ept,
> -                              u32 *entry_failure_code)
> +                              enum vm_entry_failure_code *entry_failure_code)
>  {
>         if (cr3 != kvm_read_cr3(vcpu) || (!nested_ept && pdptrs_changed(vcpu))) {
>                 if (CC(!nested_cr3_valid(vcpu, cr3))) {
> @@ -2475,7 +2476,7 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>   * is assigned to entry_failure_code on failure.
>   */
>  static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
> -                         u32 *entry_failure_code)
> +                         enum vm_entry_failure_code *entry_failure_code)
>  {
>         struct vcpu_vmx *vmx = to_vmx(vcpu);
>         struct hv_enlightened_vmcs *hv_evmcs = vmx->nested.hv_evmcs;
> @@ -2935,11 +2936,11 @@ static int nested_check_guest_non_reg_state(struct vmcs12 *vmcs12)
>
>  static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>                                         struct vmcs12 *vmcs12,
> -                                       u32 *exit_qual)
> +                                       enum vm_entry_failure_code *entry_failure_code)
>  {
>         bool ia32e;
>
> -       *exit_qual = ENTRY_FAIL_DEFAULT;
> +       *entry_failure_code = ENTRY_FAIL_DEFAULT;
>
>         if (CC(!nested_guest_cr0_valid(vcpu, vmcs12->guest_cr0)) ||
>             CC(!nested_guest_cr4_valid(vcpu, vmcs12->guest_cr4)))
> @@ -2954,7 +2955,7 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>                 return -EINVAL;
>
>         if (nested_vmx_check_vmcs_link_ptr(vcpu, vmcs12)) {
> -               *exit_qual = ENTRY_FAIL_VMCS_LINK_PTR;
> +               *entry_failure_code = ENTRY_FAIL_VMCS_LINK_PTR;
>                 return -EINVAL;
>         }
>
> @@ -3247,8 +3248,9 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>         struct vcpu_vmx *vmx = to_vmx(vcpu);
>         struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
>         bool evaluate_pending_interrupts;
> +       enum vm_entry_failure_code entry_failure_code;
>         u32 exit_reason = EXIT_REASON_INVALID_STATE;
> -       u32 exit_qual;
> +       u32 failed_msr;
>
>         if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
>                 kvm_vcpu_flush_tlb_current(vcpu);
> @@ -3296,7 +3298,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>                         return NVMX_VMENTRY_VMFAIL;
>                 }
>
> -               if (nested_vmx_check_guest_state(vcpu, vmcs12, &exit_qual))
> +               if (nested_vmx_check_guest_state(vcpu, vmcs12, &entry_failure_code))
>                         goto vmentry_fail_vmexit;
>         }
>
> @@ -3304,16 +3306,18 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>         if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)
>                 vcpu->arch.tsc_offset += vmcs12->tsc_offset;
>
> -       if (prepare_vmcs02(vcpu, vmcs12, &exit_qual))
> +       if (prepare_vmcs02(vcpu, vmcs12, &entry_failure_code))
>                 goto vmentry_fail_vmexit_guest_mode;
>
>         if (from_vmentry) {
>                 exit_reason = EXIT_REASON_MSR_LOAD_FAIL;
> -               exit_qual = nested_vmx_load_msr(vcpu,
> -                                               vmcs12->vm_entry_msr_load_addr,
> -                                               vmcs12->vm_entry_msr_load_count);
> -               if (exit_qual)
> +               failed_msr = nested_vmx_load_msr(vcpu,
> +                                                vmcs12->vm_entry_msr_load_addr,
> +                                                vmcs12->vm_entry_msr_load_count);
> +               if (failed_msr) {
> +                       entry_failure_code = failed_msr;

This assignment is a bit dodgy from a type perspective, and suggests
that perhaps a better type for the local variable is an
undiscriminated union of the enumerated type and a sufficiently large
unsigned integer type. But I won't be a stickler if you add a comment.
:-)
