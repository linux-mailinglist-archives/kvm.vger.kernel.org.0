Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5FA53DE41F
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 03:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbhHCBp5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 21:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbhHCBp4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 21:45:56 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C156C06175F;
        Mon,  2 Aug 2021 18:45:46 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id 185so22560083iou.10;
        Mon, 02 Aug 2021 18:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uv1+NuI+jQm46T5UIH7fZM+sGGArCQuLnRoIYxPk0sY=;
        b=MW3uECBVUejj6dl/243hzvdWUjNkj2HO8ic5AQ7SIj5F9+5eEFABHSv20akkmzow94
         TiJT4EeKpFUxE17eeJsLyYcm6Xv7fjHD0wOMkjisEVv0rDAJls7ARdooL+HIMF5ay0SM
         Helb4RyQZVZ4RBKT6zVCjNQuEwzWmmIfCViPtZeyV/v9mYMS9Xfwzvo3C0lY+Ld903eg
         eo4MvYHlTQWV9PP0Th8j4piMx19+IctgO2gpPBuWE5ZadXKGjZCMQTzBDCnkf3m4kZUL
         J2/CO6tQtRmrudOOD3d/n4/MEfeVO6E7XKnqwesUFPWJTigmMzNqGVr2exJm+vFhUrz6
         jcFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uv1+NuI+jQm46T5UIH7fZM+sGGArCQuLnRoIYxPk0sY=;
        b=QGYXkdWMj4xlEIA7qrnaFVgUXiQxwhPfGxCnOECesUDWOX92CwYnzryT2FaK7ptuGY
         ciQeCnZ/2FrOnihcEOK/QdgjmsMm75npHmkoD0UfInLqWanFMp5k3xCHNKodFFFGbVTg
         cvCStfUks9j2UITOtWBKIgeszNpkVb2+O6DbH5i7Z7eZ7qaVl7r1hjx6A9S0pXLPt3UV
         BjdxdlG6MAgQ+OOHqUstLk1SUulFdJIzBRSNgbt13+1tijX9sHMEMS2lNgJY/+EPMMY9
         vewNv22EBmCREq+2gkYLxQv2DhPATxw3ahLMMmamMef2SAkiIn1N96cEKd5eNDX6lMt7
         Zm8A==
X-Gm-Message-State: AOAM531xuvzNjUu/l+tT7Oc5mk4EK9n/FQ4EZwX1CG5G9tdsCiIZUUU7
        EIeE/CF0X9mD9BDLCKzr2dMa4e9a3a4laur9AEU=
X-Google-Smtp-Source: ABdhPJyUMDyHdvpVuqg+tL6JdAWjwy+ffyggZHU4slBKyVtqy3W1yWBlNCDo/n42AgBDLk2S+LCLh7/+4+Fx/nLbQ+Q=
X-Received: by 2002:a05:6638:cba:: with SMTP id x26mr13354789jad.98.1627955145847;
 Mon, 02 Aug 2021 18:45:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200320212833.3507-1-sean.j.christopherson@intel.com> <20200320212833.3507-2-sean.j.christopherson@intel.com>
In-Reply-To: <20200320212833.3507-2-sean.j.christopherson@intel.com>
From:   Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Date:   Tue, 3 Aug 2021 09:45:34 +0800
Message-ID: <CAJhGHyCPyu6BVZwqvySeT2LSr81Xospdv2O=ssvTQv0Rvky0UA@mail.gmail.com>
Subject: Re: [PATCH v3 01/37] KVM: VMX: Flush all EPTP/VPID contexts on remote
 TLB flush
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

(I'm replying to a very old email, so many CCs are dropped.)

On Sat, Mar 21, 2020 at 5:33 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Flush all EPTP/VPID contexts if a TLB flush _may_ have been triggered by
> a remote or deferred TLB flush, i.e. by KVM_REQ_TLB_FLUSH.  Remote TLB
> flushes require all contexts to be invalidated, not just the active
> contexts, e.g. all mappings in all contexts for a given HVA need to be
> invalidated on a mmu_notifier invalidation.  Similarly, the instigator
> of the deferred TLB flush may be expecting all contexts to be flushed,
> e.g. vmx_vcpu_load_vmcs().
>
> Without nested VMX, flushing only the current EPTP/VPID context isn't
> problematic because KVM uses a constant VPID for each vCPU, and

Hello, Sean

Is the patch optimized for cases where nested VMX is active?
I think the non-nested cases are normal cases.

Although the related code has been changed, the logic of the patch
is still working now, would it be better if we restore the optimization
for the normal cases (non-nested)?

Thanks
Lai

> mmu_alloc_direct_roots() all but guarantees KVM will use a single EPTP
> for L1.  In the rare case where a different EPTP is created or reused,
> KVM (currently) unconditionally flushes the new EPTP context prior to
> entering the guest.
>
> With nested VMX, KVM conditionally uses a different VPID for L2, and
> unconditionally uses a different EPTP for L2.  Because KVM doesn't
> _intentionally_ guarantee L2's EPTP/VPID context is flushed on nested
> VM-Enter, it'd be possible for a malicious L1 to attack the host and/or
> different VMs by exploiting the lack of flushing for L2.
>
>   1) Launch nested guest from malicious L1.
>
>   2) Nested VM-Enter to L2.
>
>   3) Access target GPA 'g'.  CPU inserts TLB entry tagged with L2's ASID
>      mapping 'g' to host PFN 'x'.
>
>   2) Nested VM-Exit to L1.
>
>   3) L1 triggers kernel same-page merging (ksm) by duplicating/zeroing
>      the page for PFN 'x'.
>
>   4) Host kernel merges PFN 'x' with PFN 'y', i.e. unmaps PFN 'x' and
>      remaps the page to PFN 'y'.  mmu_notifier sends invalidate command,
>      KVM flushes TLB only for L1's ASID.
>
>   4) Host kernel reallocates PFN 'x' to some other task/guest.
>
>   5) Nested VM-Enter to L2.  KVM does not invalidate L2's EPTP or VPID.
>
>   6) L2 accesses GPA 'g' and gains read/write access to PFN 'x' via its
>      stale TLB entry.
>
> However, current KVM unconditionally flushes L1's EPTP/VPID context on
> nested VM-Exit.  But, that behavior is mostly unintentional, KVM doesn't
> go out of its way to flush EPTP/VPID on nested VM-Enter/VM-Exit, rather
> a TLB flush is guaranteed to occur prior to re-entering L1 due to
> __kvm_mmu_new_cr3() always being called with skip_tlb_flush=false.  On
> nested VM-Enter, this happens via kvm_init_shadow_ept_mmu() (nested EPT
> enabled) or in nested_vmx_load_cr3() (nested EPT disabled).  On nested
> VM-Exit it occurs via nested_vmx_load_cr3().
>
> This also fixes a bug where a deferred TLB flush in the context of L2,
> with EPT disabled, would flush L1's VPID instead of L2's VPID, as
> vmx_flush_tlb() flushes L1's VPID regardless of is_guest_mode().
>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Ben Gardon <bgardon@google.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Junaid Shahid <junaids@google.com>
> Cc: Liran Alon <liran.alon@oracle.com>
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Cc: John Haxby <john.haxby@oracle.com>
> Reviewed-by: Liran Alon <liran.alon@oracle.com>
> Fixes: efebf0aaec3d ("KVM: nVMX: Do not flush TLB on L1<->L2 transitions if L1 uses VPID and EPT")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.h | 28 +++++++++++++++++++++++++++-
>  1 file changed, 27 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index be93d597306c..d6d67b816ebe 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -518,7 +518,33 @@ static inline void __vmx_flush_tlb(struct kvm_vcpu *vcpu, int vpid,
>
>  static inline void vmx_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa)
>  {
> -       __vmx_flush_tlb(vcpu, to_vmx(vcpu)->vpid, invalidate_gpa);
> +       struct vcpu_vmx *vmx = to_vmx(vcpu);
> +
> +       /*
> +        * Flush all EPTP/VPID contexts if the TLB flush _may_ have been
> +        * invoked via kvm_flush_remote_tlbs(), which always passes %true for
> +        * @invalidate_gpa.  Flushing remote TLBs requires all contexts to be
> +        * flushed, not just the active context.
> +        *
> +        * Note, this also ensures a deferred TLB flush with VPID enabled and
> +        * EPT disabled invalidates the "correct" VPID, by nuking both L1 and
> +        * L2's VPIDs.
> +        */
> +       if (invalidate_gpa) {
> +               if (enable_ept) {
> +                       ept_sync_global();
> +               } else if (enable_vpid) {
> +                       if (cpu_has_vmx_invvpid_global()) {
> +                               vpid_sync_vcpu_global();
> +                       } else {
> +                               WARN_ON_ONCE(!cpu_has_vmx_invvpid_single());
> +                               vpid_sync_vcpu_single(vmx->vpid);
> +                               vpid_sync_vcpu_single(vmx->nested.vpid02);
> +                       }
> +               }
> +       } else {
> +               __vmx_flush_tlb(vcpu, vmx->vpid, false);
> +       }
>  }
>
>  static inline void decache_tsc_multiplier(struct vcpu_vmx *vmx)
> --
> 2.24.1
>
