Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C55836743D
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 22:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245663AbhDUUjn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 16:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243627AbhDUUjl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 16:39:41 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D18C06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 13:39:08 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id e2so18014938plh.8
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 13:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KKUtJunTlOVu2OKgX69YYpzxtBTRi610v8MmHtEu08M=;
        b=aQOjP5KVKXIrF75x7knGDiJrlA0LeU+VfOH1p9j8Jwt8dxdzfHmu0Tc/ERKKiGeO7p
         /Pn8h1uZbGPHkp+HE4UR7c4+z5Vi3dZqKhHzX4af+mCbWn7NAyaOFtyei57ZUPSqRXoc
         CM4MkmRjWzEBPmbD8srr5h+dcSkNtMRN+lQWJGQ+YrZPxiSvb2ayKzjRYNcs++YQNsLC
         okRaC6XxjkSXZgRsPcz0MQdLjjq2bfo7EwkYGRCIHOL99zj4RwXxQ852DfqBjKkiXQiq
         eB+S9rjY1REOxfG96dzGphsaOmK7lntuNMxcrs+I/lPCZwLGUKaUZu6lV7CDe8Qu7OSo
         ohJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KKUtJunTlOVu2OKgX69YYpzxtBTRi610v8MmHtEu08M=;
        b=gEPegmm5WIZTi9CK9WkufZuEdY/p6IkvvAJUHtDgQ48bvX+SAFiIqk1iosLo9/9p3g
         f3LJWUtpqii2EIzD+jClkloKLfdepXsSYrbAlyrBi0FfCGvkQ7dr7hZcnzSBWmCGFzRS
         jdyDbcN81M2nn1aTogxBs1AaY7qVp5nG+JLneOPFBI55QcuSBxuFi6B6x5FpqsZEm1W4
         AL0Pxsp65vAFW8W1Vs+Nft80zKiVwU/CcotvrZ14IemA0Nx54zaZesjTRkvMaF0yYuCD
         nogtO3Yty9nfOlLJpfXYYSfsyC7dyCVj5TYTGbS0Kq6ELKiqNhn2vsuggDIJ+WXcNMnt
         LfMg==
X-Gm-Message-State: AOAM532BMNnULD9OyxUyZLJlxDJwE8ReCGdr34fFc4d+7na91pIH9wFe
        2dCPYvhRgrnbXlJFWMkiZtlfjFLv17VifqszfyywyQ==
X-Google-Smtp-Source: ABdhPJxPhz9pS3zMmYUKvHlu7DSL+hq4ErjNpN1BjY0w8iet8rSe0NUPZk0lezBNk7W1c302LoqGCyq8/a4ZotFmipg=
X-Received: by 2002:a17:902:fe8c:b029:ec:a2ef:4e3f with SMTP id
 x12-20020a170902fe8cb02900eca2ef4e3fmr18036407plm.36.1619037547569; Wed, 21
 Apr 2021 13:39:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210408223214.2582277-1-natet@google.com>
In-Reply-To: <20210408223214.2582277-1-natet@google.com>
From:   Nathan Tempelman <natet@google.com>
Date:   Wed, 21 Apr 2021 13:38:55 -0700
Message-ID: <CAKiEG5q87kqQZ1=Nj8xN4aeWg_zgLyqr7CqCi=NXj55+NkiGVg@mail.gmail.com>
Subject: Re: [RFC v3] KVM: x86: Support KVM VMs sharing SEV context
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>
Cc:     Thomas Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
        kvm <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Steve Rutherford <srutherford@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        dovmurik@linux.vnet.ibm.com, lersek@redhat.com, jejb@linux.ibm.com,
        frankeh@us.ibm.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 8, 2021 at 3:47 PM Nathan Tempelman <natet@google.com> wrote:
>
> Add a capability for userspace to mirror SEV encryption context from
> one vm to another. On our side, this is intended to support a
> Migration Helper vCPU, but it can also be used generically to support
> other in-guest workloads scheduled by the host. The intention is for
> the primary guest and the mirror to have nearly identical memslots.
>
> The primary benefits of this are that:
> 1) The VMs do not share KVM contexts (think APIC/MSRs/etc), so they
> can't accidentally clobber each other.
> 2) The VMs can have different memory-views, which is necessary for post-copy
> migration (the migration vCPUs on the target need to read and write to
> pages, when the primary guest would VMEXIT).
>
> This does not change the threat model for AMD SEV. Any memory involved
> is still owned by the primary guest and its initial state is still
> attested to through the normal SEV_LAUNCH_* flows. If userspace wanted
> to circumvent SEV, they could achieve the same effect by simply attaching
> a vCPU to the primary VM.
> This patch deliberately leaves userspace in charge of the memslots for the
> mirror, as it already has the power to mess with them in the primary guest.
>
> This patch does not support SEV-ES (much less SNP), as it does not
> handle handing off attested VMSAs to the mirror.
>
> For additional context, we need a Migration Helper because SEV PSP
> migration is far too slow for our live migration on its own. Using
> an in-guest migrator lets us speed this up significantly.
>
> Signed-off-by: Nathan Tempelman <natet@google.com>
> ---
>  Documentation/virt/kvm/api.rst  | 17 +++++++
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/svm/sev.c          | 90 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c          |  2 +
>  arch/x86/kvm/svm/svm.h          |  2 +
>  arch/x86/kvm/x86.c              |  7 ++-
>  include/linux/kvm_host.h        |  1 +
>  include/uapi/linux/kvm.h        |  1 +
>  virt/kvm/kvm_main.c             |  6 +++
>  9 files changed, 126 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 482508ec7cc4..332ba8b5b6f4 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6213,6 +6213,23 @@ the bus lock vm exit can be preempted by a higher priority VM exit, the exit
>  notifications to userspace can be KVM_EXIT_BUS_LOCK or other reasons.
>  KVM_RUN_BUS_LOCK flag is used to distinguish between them.
>
> +7.23 KVM_CAP_VM_COPY_ENC_CONTEXT_FROM
> +-------------------------------------
> +
> +Architectures: x86 SEV enabled
> +Type: vm
> +Parameters: args[0] is the fd of the source vm
> +Returns: 0 on success; ENOTTY on error
> +
> +This capability enables userspace to copy encryption context from the vm
> +indicated by the fd to the vm this is called on.
> +
> +This is intended to support in-guest workloads scheduled by the host. This
> +allows the in-guest workload to maintain its own NPTs and keeps the two vms
> +from accidentally clobbering each other with interrupts and the like (separate
> +APIC/MSRs/etc).
> +
> +
>  8. Other capabilities.
>  ======================
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 84499aad01a4..46df415a8e91 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1334,6 +1334,7 @@ struct kvm_x86_ops {
>         int (*mem_enc_op)(struct kvm *kvm, void __user *argp);
>         int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>         int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
> +       int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
>
>         int (*get_msr_feature)(struct kvm_msr_entry *entry);
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 874ea309279f..20c46ba8201d 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -66,6 +66,11 @@ static int sev_flush_asids(void)
>         return ret;
>  }
>
> +static inline bool is_mirroring_enc_context(struct kvm *kvm)
> +{
> +       return !!to_kvm_svm(kvm)->sev_info.enc_context_owner;
> +}
> +
>  /* Must be called with the sev_bitmap_lock held */
>  static bool __sev_recycle_asids(int min_asid, int max_asid)
>  {
> @@ -1126,6 +1131,12 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>
>         mutex_lock(&kvm->lock);
>
> +       /* enc_context_owner handles all memory enc operations */
> +       if (is_mirroring_enc_context(kvm)) {
> +               r = -EINVAL;
> +               goto out;
> +       }
> +
>         switch (sev_cmd.id) {
>         case KVM_SEV_INIT:
>                 r = sev_guest_init(kvm, &sev_cmd);
> @@ -1186,6 +1197,10 @@ int svm_register_enc_region(struct kvm *kvm,
>         if (!sev_guest(kvm))
>                 return -ENOTTY;
>
> +       /* If kvm is mirroring encryption context it isn't responsible for it */
> +       if (is_mirroring_enc_context(kvm))
> +               return -EINVAL;
> +
>         if (range->addr > ULONG_MAX || range->size > ULONG_MAX)
>                 return -EINVAL;
>
> @@ -1252,6 +1267,10 @@ int svm_unregister_enc_region(struct kvm *kvm,
>         struct enc_region *region;
>         int ret;
>
> +       /* If kvm is mirroring encryption context it isn't responsible for it */
> +       if (is_mirroring_enc_context(kvm))
> +               return -EINVAL;
> +
>         mutex_lock(&kvm->lock);
>
>         if (!sev_guest(kvm)) {
> @@ -1282,6 +1301,71 @@ int svm_unregister_enc_region(struct kvm *kvm,
>         return ret;
>  }
>
> +int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
> +{
> +       struct file *source_kvm_file;
> +       struct kvm *source_kvm;
> +       struct kvm_sev_info *mirror_sev;
> +       unsigned int asid;
> +       int ret;
> +
> +       source_kvm_file = fget(source_fd);
> +       if (!file_is_kvm(source_kvm_file)) {
> +               ret = -EBADF;
> +               goto e_source_put;
> +       }
> +
> +       source_kvm = source_kvm_file->private_data;
> +       mutex_lock(&source_kvm->lock);
> +
> +       if (!sev_guest(source_kvm)) {
> +               ret = -EINVAL;
> +               goto e_source_unlock;
> +       }
> +
> +       /* Mirrors of mirrors should work, but let's not get silly */
> +       if (is_mirroring_enc_context(source_kvm) || source_kvm == kvm) {
> +               ret = -EINVAL;
> +               goto e_source_unlock;
> +       }
> +
> +       asid = to_kvm_svm(source_kvm)->sev_info.asid;
> +
> +       /*
> +        * The mirror kvm holds an enc_context_owner ref so its asid can't
> +        * disappear until we're done with it
> +        */
> +       kvm_get_kvm(source_kvm);
> +
> +       fput(source_kvm_file);
> +       mutex_unlock(&source_kvm->lock);
> +       mutex_lock(&kvm->lock);
> +
> +       if (sev_guest(kvm)) {
> +               ret = -EINVAL;
> +               goto e_mirror_unlock;
> +       }
> +
> +       /* Set enc_context_owner and copy its encryption context over */
> +       mirror_sev = &to_kvm_svm(kvm)->sev_info;
> +       mirror_sev->enc_context_owner = source_kvm;
> +       mirror_sev->asid = asid;
> +       mirror_sev->active = true;
> +
> +       mutex_unlock(&kvm->lock);
> +       return 0;
> +
> +e_mirror_unlock:
> +       mutex_unlock(&kvm->lock);
> +       kvm_put_kvm(source_kvm);
> +       return ret;
> +e_source_unlock:
> +       mutex_unlock(&source_kvm->lock);
> +e_source_put:
> +       fput(source_kvm_file);
> +       return ret;
> +}
> +
>  void sev_vm_destroy(struct kvm *kvm)
>  {
>         struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> @@ -1291,6 +1375,12 @@ void sev_vm_destroy(struct kvm *kvm)
>         if (!sev_guest(kvm))
>                 return;
>
> +       /* If this is a mirror_kvm release the enc_context_owner and skip sev cleanup */
> +       if (is_mirroring_enc_context(kvm)) {
> +               kvm_put_kvm(sev->enc_context_owner);
> +               return;
> +       }
> +
>         mutex_lock(&kvm->lock);
>
>         /*
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 42d4710074a6..9ffb2bcf5389 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4608,6 +4608,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>         .mem_enc_reg_region = svm_register_enc_region,
>         .mem_enc_unreg_region = svm_unregister_enc_region,
>
> +       .vm_copy_enc_context_from = svm_vm_copy_asid_from,
> +
>         .can_emulate_instruction = svm_can_emulate_instruction,
>
>         .apic_init_signal_blocked = svm_apic_init_signal_blocked,
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 39e071fdab0c..779009839f6a 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -65,6 +65,7 @@ struct kvm_sev_info {
>         unsigned long pages_locked; /* Number of pages locked */
>         struct list_head regions_list;  /* List of registered regions */
>         u64 ap_jump_table;      /* SEV-ES AP Jump Table address */
> +       struct kvm *enc_context_owner; /* Owner of copied encryption context */
>  };
>
>  struct kvm_svm {
> @@ -561,6 +562,7 @@ int svm_register_enc_region(struct kvm *kvm,
>                             struct kvm_enc_region *range);
>  int svm_unregister_enc_region(struct kvm *kvm,
>                               struct kvm_enc_region *range);
> +int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd);
>  void pre_sev_run(struct vcpu_svm *svm, int cpu);
>  void __init sev_hardware_setup(void);
>  void sev_hardware_teardown(void);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3fa140383f5d..343cb05c2a24 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3753,6 +3753,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>         case KVM_CAP_X86_USER_SPACE_MSR:
>         case KVM_CAP_X86_MSR_FILTER:
>         case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
> +       case KVM_CAP_VM_COPY_ENC_CONTEXT_FROM:
>                 r = 1;
>                 break;
>         case KVM_CAP_XEN_HVM:
> @@ -4649,7 +4650,6 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>                         kvm_update_pv_runtime(vcpu);
>
>                 return 0;
> -
>         default:
>                 return -EINVAL;
>         }
> @@ -5321,6 +5321,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>                         kvm->arch.bus_lock_detection_enabled = true;
>                 r = 0;
>                 break;
> +       case KVM_CAP_VM_COPY_ENC_CONTEXT_FROM:
> +               r = -ENOTTY;
> +               if (kvm_x86_ops.vm_copy_enc_context_from)
> +                       r = kvm_x86_ops.vm_copy_enc_context_from(kvm, cap->args[0]);
> +               return r;
>         default:
>                 r = -EINVAL;
>                 break;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e126ebda36d0..dc5a81115df7 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -637,6 +637,7 @@ void kvm_exit(void);
>
>  void kvm_get_kvm(struct kvm *kvm);
>  void kvm_put_kvm(struct kvm *kvm);
> +bool file_is_kvm(struct file *file);
>  void kvm_put_kvm_no_destroy(struct kvm *kvm);
>
>  static inline struct kvm_memslots *__kvm_memslots(struct kvm *kvm, int as_id)
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 63f8f6e95648..9dc00f9baf54 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1077,6 +1077,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_SYS_HYPERV_CPUID 191
>  #define KVM_CAP_DIRTY_LOG_RING 192
>  #define KVM_CAP_X86_BUS_LOCK_EXIT 193
> +#define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 194
>
>  #ifdef KVM_CAP_IRQ_ROUTING
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 001b9de4e727..5baf82b01e0c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4041,6 +4041,12 @@ static struct file_operations kvm_vm_fops = {
>         KVM_COMPAT(kvm_vm_compat_ioctl),
>  };
>
> +bool file_is_kvm(struct file *file)
> +{
> +       return file && file->f_op == &kvm_vm_fops;
> +}
> +EXPORT_SYMBOL_GPL(file_is_kvm);
> +
>  static int kvm_dev_ioctl_create_vm(unsigned long type)
>  {
>         int r;
> --
> 2.31.1.295.g9ea45b61b8-goog
>

Tested-by: Nathan Tempelman <natet@google.com>

This works as intended. I managed to build an SEV self test off of
Michael Roth's work-in-progress patches upstream and also ran the sev
boot tests he's built. No issues. Big thanks to Michael for his work
here!

I'll be looking to add my tests upstream as soon as Michael's work
stabilizes and makes it in.
