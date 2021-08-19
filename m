Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CC03F1DBA
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 18:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbhHSQYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 12:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhHSQYU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 12:24:20 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19ACC061756
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 09:23:43 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id u21so2050263qtw.8
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 09:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9acgzKmR2WuqPl6it0Hp6jgoni4C9UqmVkSOp+rUYjI=;
        b=TGN4GsKYUEQMTeQdQCDEnqkYbFt5RYxcij/MAtmSu7X88Y16k2D4I1+SeHK6I0Ujh0
         kIyZgAhXD859VZigHi4LHdAWcYn+WSbMNRC4JxcYe/xMFKAFim2F4DC9Zh2eIVe61UKi
         5Vzo7GMCVjOC/LebCf04MczqMoXk25xez7LMQrQt06W7SFFiNxwZBAGF9X3USq13s8Ve
         gZlHMzLyw9uuyrwnHIJuCFsUSz1x+/0IFxctpJnjjOAZKbj0aUR+qfJO2RmqUpa0payl
         yfXds5IurfTVWyZseI2pgYwf2jglDI7zXcmGIFte0s7j8+/MTpe1ioeQpa0DrVwI4VoN
         MZhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9acgzKmR2WuqPl6it0Hp6jgoni4C9UqmVkSOp+rUYjI=;
        b=M16iiYm8PeShm8/fSubzs1B0wPVM0DyroKmXuak64ogxDCopYbwaC7UhvinHPILAtq
         /yjuyFKb19q1v9LEcQNcN+lFYeT7Hc2GiZXrXQFeyclCbaXGqB8gkloiAL54nbCIG0qp
         dZ2uSiMGYs586BaZzqOXteuBH5rN5E+YlAc3I6Ud0XI14fG3afBCMSN5IeDkNjWd+fG8
         +f1jmaMBIujg46oQKf7RONjzP78rX7r2bXHb1Vuzv5AiJsMw6ptAo2guEG5CMBe0rQt+
         vMhRiEoelsEG01uzeubpFG6DzVOgGnNxVEmSJOT2O/LM8lzfhrXdyarcXqLOvzZGUuPz
         4yCg==
X-Gm-Message-State: AOAM532t6Cio4rugv5rPkUgbqGGWi2kMU7m/EOGA2ctuNyg+sKjKrJfP
        x/mV1PkmYtH5MUgEqXUPC5qlAEk3Iy12cm6FMfRQbg==
X-Google-Smtp-Source: ABdhPJzX37c5Nzl1deN8fEagm4R24z1g24zxL4dlOowDpjryKk7NfQ5Ri2JATvFhrVxm9ScxK89FqfXWbC4KJbZ/Usg=
X-Received: by 2002:ac8:48c1:: with SMTP id l1mr13150385qtr.89.1629390222642;
 Thu, 19 Aug 2021 09:23:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210819154910.1064090-1-pgonda@google.com> <20210819154910.1064090-2-pgonda@google.com>
In-Reply-To: <20210819154910.1064090-2-pgonda@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 19 Aug 2021 09:23:31 -0700
Message-ID: <CAA03e5Gh0kJYHP1R3F7uh6x83LBFPp=af2xt7q3epgg+8XW53g@mail.gmail.com>
Subject: Re: [PATCH 1/2 V4] KVM, SEV: Add support for SEV intra host migration
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 19, 2021 at 8:49 AM Peter Gonda <pgonda@google.com> wrote:
>
> For SEV to work with intra host migration, contents of the SEV info struct
> such as the ASID (used to index the encryption key in the AMD SP) and
> the list of memory regions need to be transferred to the target VM.
> This change adds a commands for a target VMM to get a source SEV VM's sev
> info.
>
> The target is expected to be initialized (sev_guest_init), but not
> launched state (sev_launch_start) when performing receive. Once the
> target has received, it will be in a launched state and will not
> need to perform the typical SEV launch commands.
>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  Documentation/virt/kvm/api.rst  |  15 +++++
>  arch/x86/include/asm/kvm_host.h |   1 +
>  arch/x86/kvm/svm/sev.c          | 108 ++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c          |   1 +
>  arch/x86/kvm/svm/svm.h          |   3 +
>  arch/x86/kvm/x86.c              |   5 ++
>  include/uapi/linux/kvm.h        |   1 +
>  7 files changed, 134 insertions(+)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 86d7ad3a126c..9dc56778b421 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6701,6 +6701,21 @@ MAP_SHARED mmap will result in an -EINVAL return.
>  When enabled the VMM may make use of the ``KVM_ARM_MTE_COPY_TAGS`` ioctl to
>  perform a bulk copy of tags to/from the guest.
>
> +7.29 KVM_CAP_VM_MIGRATE_ENC_CONTEXT_FROM
> +-------------------------------------
> +
> +Architectures: x86 SEV enabled
> +Type: vm
> +Parameters: args[0] is the fd of the source vm
> +Returns: 0 on success
> +
> +This capability enables userspace to migrate the encryption context from the vm
> +indicated by the fd to the vm this is called on.
> +
> +This is intended to support intra-host migration of VMs between userspace VMMs.
> +in-guest workloads scheduled by the host. This allows for upgrading the VMM
> +process without interrupting the guest.
> +
>  8. Other capabilities.
>  ======================
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 20daaf67a5bf..fd3a118c9e40 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1448,6 +1448,7 @@ struct kvm_x86_ops {
>         int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>         int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>         int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
> +       int (*vm_migrate_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
>
>         int (*get_msr_feature)(struct kvm_msr_entry *entry);
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 75e0b21ad07c..2d98b56b6f8c 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1501,6 +1501,114 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
>         return sev_issue_cmd(kvm, SEV_CMD_RECEIVE_FINISH, &data, &argp->error);
>  }
>
> +static int svm_sev_lock_for_migration(struct kvm *kvm)
> +{
> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +       int ret;
> +
> +       /*
> +        * Bail if this VM is already involved in a migration to avoid deadlock
> +        * between two VMs trying to migrate to/from each other.
> +        */
> +       spin_lock(&sev->migration_lock);
> +       if (sev->migration_in_progress)
> +               ret = -EBUSY;
> +       else {
> +               /*
> +                * Otherwise indicate VM is migrating and take the KVM lock.
> +                */
> +               sev->migration_in_progress = true;
> +               mutex_lock(&kvm->lock);
> +               ret = 0;
> +       }
> +       spin_unlock(&sev->migration_lock);
> +
> +       return ret;
> +}
> +
> +static void svm_unlock_after_migration(struct kvm *kvm)
> +{
> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +
> +       mutex_unlock(&kvm->lock);
> +       WRITE_ONCE(sev->migration_in_progress, false);
> +}
> +

This entire locking scheme seems over-complicated to me. Can we simply
rely on `migration_lock` and get rid of `migration_in_progress`? I was
chatting about these patches with Peter, while he worked on this new
version. But he mentioned that this locking scheme had been suggested
by Sean in a previous review. Sean: what do you think? My rationale
was that this is called via a VM-level ioctl. So serializing the
entire code path on `migration_lock` seems fine. But maybe I'm missing
something?

> +static void migrate_info_from(struct kvm_sev_info *dst,
> +                             struct kvm_sev_info *src)
> +{
> +       sev_asid_free(dst);
> +
> +       dst->asid = src->asid;
> +       dst->misc_cg = src->misc_cg;
> +       dst->handle = src->handle;
> +       dst->pages_locked = src->pages_locked;
> +
> +       src->asid = 0;
> +       src->active = false;
> +       src->handle = 0;
> +       src->pages_locked = 0;
> +       src->misc_cg = NULL;
> +
> +       INIT_LIST_HEAD(&dst->regions_list);
> +       list_replace_init(&src->regions_list, &dst->regions_list);
> +}
> +
> +int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
> +{
> +       struct kvm_sev_info *dst_sev = &to_kvm_svm(kvm)->sev_info;
> +       struct file *source_kvm_file;
> +       struct kvm *source_kvm;
> +       int ret;
> +
> +       ret = svm_sev_lock_for_migration(kvm);
> +       if (ret)
> +               return ret;
> +
> +       if (!sev_guest(kvm) || sev_es_guest(kvm)) {
> +               ret = -EINVAL;
> +               pr_warn_ratelimited("VM must be SEV enabled to migrate to.\n");
> +               goto out_unlock;
> +       }
> +
> +       if (!list_empty(&dst_sev->regions_list)) {
> +               ret = -EINVAL;
> +               pr_warn_ratelimited(
> +                       "VM must not have encrypted regions to migrate to.\n");
> +               goto out_unlock;
> +       }
> +
> +       source_kvm_file = fget(source_fd);
> +       if (!file_is_kvm(source_kvm_file)) {
> +               ret = -EBADF;
> +               goto out_fput;
> +       }
> +
> +       source_kvm = source_kvm_file->private_data;
> +       ret = svm_sev_lock_for_migration(source_kvm);
> +       if (ret)
> +               goto out_fput;
> +
> +       if (!sev_guest(source_kvm) || sev_es_guest(source_kvm)) {
> +               ret = -EINVAL;
> +               pr_warn_ratelimited(
> +                       "Source VM must be SEV enabled to migrate from.\n");
> +               goto out_source;
> +       }
> +
> +       migrate_info_from(dst_sev, &to_kvm_svm(source_kvm)->sev_info);
> +       ret = 0;
> +
> +out_source:
> +       svm_unlock_after_migration(source_kvm);
> +out_fput:
> +       if (source_kvm_file)
> +               fput(source_kvm_file);
> +out_unlock:
> +       svm_unlock_after_migration(kvm);
> +       return ret;
> +}
> +
>  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>         struct kvm_sev_cmd sev_cmd;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7b58e445a967..8b5bcab48937 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4627,6 +4627,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>         .mem_enc_unreg_region = svm_unregister_enc_region,
>
>         .vm_copy_enc_context_from = svm_vm_copy_asid_from,
> +       .vm_migrate_enc_context_from = svm_vm_migrate_from,
>
>         .can_emulate_instruction = svm_can_emulate_instruction,
>
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 524d943f3efc..3576a12700d7 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -80,6 +80,8 @@ struct kvm_sev_info {
>         u64 ap_jump_table;      /* SEV-ES AP Jump Table address */
>         struct kvm *enc_context_owner; /* Owner of copied encryption context */
>         struct misc_cg *misc_cg; /* For misc cgroup accounting */
> +       spinlock_t migration_lock;
> +       bool migration_in_progress;
>  };
>
>  struct kvm_svm {
> @@ -552,6 +554,7 @@ int svm_register_enc_region(struct kvm *kvm,
>  int svm_unregister_enc_region(struct kvm *kvm,
>                               struct kvm_enc_region *range);
>  int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd);
> +int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd);
>  void pre_sev_run(struct vcpu_svm *svm, int cpu);
>  void __init sev_set_cpu_caps(void);
>  void __init sev_hardware_setup(void);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fdc0c18339fb..ea3100134e35 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5655,6 +5655,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>                 if (kvm_x86_ops.vm_copy_enc_context_from)
>                         r = kvm_x86_ops.vm_copy_enc_context_from(kvm, cap->args[0]);
>                 return r;
> +       case KVM_CAP_VM_MIGRATE_ENC_CONTEXT_FROM:
> +               r = -EINVAL;
> +               if (kvm_x86_ops.vm_migrate_enc_context_from)
> +                       r = kvm_x86_ops.vm_migrate_enc_context_from(kvm, cap->args[0]);
> +               return r;
>         case KVM_CAP_EXIT_HYPERCALL:
>                 if (cap->args[0] & ~KVM_EXIT_HYPERCALL_VALID_MASK) {
>                         r = -EINVAL;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index a067410ebea5..49660204cdb9 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1112,6 +1112,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_BINARY_STATS_FD 203
>  #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
>  #define KVM_CAP_ARM_MTE 205
> +#define KVM_CAP_VM_MIGRATE_ENC_CONTEXT_FROM 206
>
>  #ifdef KVM_CAP_IRQ_ROUTING
>
> --
> 2.33.0.rc1.237.g0d66db33f3-goog
>
