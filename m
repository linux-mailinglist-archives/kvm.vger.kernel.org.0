Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E240B44B035
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 16:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239013AbhKIPWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 10:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238916AbhKIPWc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Nov 2021 10:22:32 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A077FC061766
        for <kvm@vger.kernel.org>; Tue,  9 Nov 2021 07:19:46 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id i26so36966013ljg.7
        for <kvm@vger.kernel.org>; Tue, 09 Nov 2021 07:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N5GxqmIuogoDwNKuGho0QDJdTgcmC8zZdkPldQ7Hyts=;
        b=SiFR5a/dHAvJ8JM35hmKKe7eRiltdHK9wisHGqQxqM9AkIinpcJQOkPivpGVDQ6gMR
         XXk9Ux5Gr7CWDVdKIIM4WYrFclSpB6Pn1UY3f+NYCnMnudSH3rqKp176r7+SYQkx5Ptt
         EB0qo58RjrQk+aKw2ajGPqkJX9J1ioqAfJy9IgxZ4hQQtGD87Oln1nA/meYS+ot0LmUI
         KcAQdh9dS33WzHU/H5Cdn1HFZXOjQGHHEKi7iPfjHla71bxjLkaGqBEFTCapgj5gH5IM
         YOOWxGe/SFh7dd58gHyed+i/DrC6hezGMzjTi+dO3zhu4Y08QpKcGS3wIeiI902LsUoj
         ALGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N5GxqmIuogoDwNKuGho0QDJdTgcmC8zZdkPldQ7Hyts=;
        b=r3odIxlHFjxS0Zgs59CstCJLesDvsu76adhTqtE8T0GPQG9UoJStsFlH4ZaD9Fww1x
         ZKnfrAVWg6Joes8rGfqwUykktgqXU1xeifL7GjtGLZ9FMbeQysURTdpm/QWAs9NF+XE4
         f0f16vqRs5K8sZY03NhBD7V92Vw52cHc8usyu2iRvHpxhpqLJBCfKnSLZLCWDRG4SzjD
         hGZ1JwlE8wb7fplli3nkN4B5eLrcrU1sS+9rCvbToRicKEExHY3TZqdm7Y4tBrEENveY
         NFJ5kVOfDZJxCZP1OZ3DPKvtPTdfNlArBh+Xi2LMkcBybcT84ktkQaAN+8u7EENk2mWT
         4F9A==
X-Gm-Message-State: AOAM533akaKlKtfm+FTPU3rui2hFo6QEdCw9FSGkec/nFWGniy6CiU6j
        fJb4/HeySgt3Jl/v6dLdRqXQ50YxwZkbY2osneI9Tw==
X-Google-Smtp-Source: ABdhPJyAZCR9sCLo1/A9GLjlSdbB7s93B7H9MnKX+g8Ubb+LO70I3kppjatmk199ymiDNOW7xls7VOg6REzkp0OKFBg=
X-Received: by 2002:a05:651c:553:: with SMTP id q19mr8527767ljp.282.1636471184581;
 Tue, 09 Nov 2021 07:19:44 -0800 (PST)
MIME-Version: 1.0
References: <20211021174303.385706-1-pgonda@google.com> <20211021174303.385706-3-pgonda@google.com>
 <YYRZq+Zt52FSyjVW@google.com>
In-Reply-To: <YYRZq+Zt52FSyjVW@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 9 Nov 2021 08:19:33 -0700
Message-ID: <CAMkAt6oeNjX_+u306oHjZUf+d_AbcqLX9yd_jMgFpXf5a0GF2A@mail.gmail.com>
Subject: Re: [PATCH V11 2/5] KVM: SEV: Add support for SEV intra host migration
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
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

On Thu, Nov 4, 2021 at 4:07 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Paolo and anyone else, any thoughts before I lead Peter on an even longer wild
> goose chase?

Input would be appreciated.

Commented on some questions, otherwise taken feedback for a new revision.

>
> On Thu, Oct 21, 2021, Peter Gonda wrote:
> > @@ -6706,6 +6706,21 @@ MAP_SHARED mmap will result in an -EINVAL return.
> >  When enabled the VMM may make use of the ``KVM_ARM_MTE_COPY_TAGS`` ioctl to
> >  perform a bulk copy of tags to/from the guest.
> >
> > +7.29 KVM_CAP_VM_MIGRATE_PROTECTED_VM_FROM
> > +-------------------------------------
> > +
> > +Architectures: x86 SEV enabled
>
> I'd drop the "SEV enabled" part.  In a way, it's technically a lie for this one
> patch since an SEV-ES VM is also an SEV VM, but doesn't support this capability.
> And AFAICT no other ioctl()/capability provides this level of granularity.
>
> > +Type: vm
> > +Parameters: args[0] is the fd of the source vm
> > +Returns: 0 on success
> > +
> > +This capability enables userspace to migrate the encryption context from the VM
> > +indicated by the fd to the VM this is called on.
> > +
> > +This is intended to support intra-host migration of VMs between userspace VMMs.
> > +in-guest workloads scheduled by the host. This allows for upgrading the VMM
> > +process without interrupting the guest.
> > +
>
> ...
>
> > +static void sev_unlock_vcpus_for_migration(struct kvm *kvm)
> > +{
> > +     struct kvm_vcpu *vcpu;
> > +     int i;
> > +
> > +     kvm_for_each_vcpu(i, vcpu, kvm) {
>
> Braces not needed.
>
> > +             mutex_unlock(&vcpu->mutex);
> > +     }
> > +}
> > +
> > +static void sev_migrate_from(struct kvm_sev_info *dst,
> > +                           struct kvm_sev_info *src)
> > +{
> > +     dst->active = true;
> > +     dst->asid = src->asid;
> > +     dst->misc_cg = src->misc_cg;
>
> Ah, this is not correct.  If @dst is in a different cgroup, then @dst needs to
> be charged and @src needs to be uncharged.
>
> That would also provide a good opportunity to more tightly couple ->asid and
> ->misc_cg in the form of a helper.  Looking at the code, there's an invariant
> that misc_cg is NULL if an ASID is not assigned.  I.e. these three lines belong
> in a helper, irrespective of this code.
>
>         misc_cg_uncharge(type, sev->misc_cg, 1);
>         put_misc_cg(sev->misc_cg);
>         sev->misc_cg = NULL;
>

OK I can pull this out into a helper in a separate patch. Then do the
uncharge/charge here.

> > +     dst->handle = src->handle;
> > +     dst->pages_locked = src->pages_locked;
> > +
> > +     src->asid = 0;
> > +     src->active = false;
> > +     src->handle = 0;
> > +     src->pages_locked = 0;
> > +     src->misc_cg = NULL;
> > +     INIT_LIST_HEAD(&dst->regions_list);
> > +     list_replace_init(&src->regions_list, &dst->regions_list);
> > +}
> > +
> > +int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
> > +{
> > +     struct kvm_sev_info *dst_sev = &to_kvm_svm(kvm)->sev_info;
> > +     struct file *source_kvm_file;
> > +     struct kvm *source_kvm;
> > +     struct kvm_vcpu *vcpu;
> > +     int i, ret;
> > +
> > +     ret = sev_lock_for_migration(kvm);
> > +     if (ret)
> > +             return ret;
> > +
> > +     if (sev_guest(kvm)) {
> > +             ret = -EINVAL;
> > +             goto out_unlock;
> > +     }
> > +
> > +     source_kvm_file = fget(source_fd);
> > +     if (!file_is_kvm(source_kvm_file)) {
> > +             ret = -EBADF;
> > +             goto out_fput;
> > +     }
> > +
> > +     source_kvm = source_kvm_file->private_data;
> > +     ret = sev_lock_for_migration(source_kvm);
> > +     if (ret)
> > +             goto out_fput;
> > +
> > +     if (!sev_guest(source_kvm) || sev_es_guest(source_kvm)) {
> > +             ret = -EINVAL;
> > +             goto out_source;
> > +     }
> > +     ret = sev_lock_vcpus_for_migration(kvm);
> > +     if (ret)
> > +             goto out_dst_vcpu;
> > +     ret = sev_lock_vcpus_for_migration(source_kvm);
> > +     if (ret)
> > +             goto out_source_vcpu;
> > +
> > +     sev_migrate_from(dst_sev, &to_kvm_svm(source_kvm)->sev_info);
> > +     kvm_for_each_vcpu(i, vcpu, source_kvm) {
>
> Braces not needed.
>
> > +             kvm_vcpu_reset(vcpu, /* init_event= */ false);
>
> Phooey.  I made this suggestion, but in hindsight, it's a bad suggestion as KVM
> doesn't currently have a true RESET path; there are quite a few blobs of code
> that assume the vCPU has never been run if init_event=false.
>
> And to go through kvm_vcpu_reset(), the vcpu needs to be loaded, not just locked.
> It won't fail as hard as VMX, where KVM would write the wrong VMCS, but odds are
> good something will eventually go sideways.
>
> Aha!  An idea.  Marking the VM bugged doesn't work because "we need to keep using
> the  source VM even after the state is transfered"[*], but the core idea is sound,
> it just needs to add a different flag to more precisely prevent kvm_vcpu_ioctl().
>
> If we rename KVM_REQ_VM_BUGGED=>KVM_REQ_VM_DEAD in a prep patch (see below), then
> this patch can add something here (can't think of a good name)
>
>         source_kvm->??? = true;
>         kvm_make_all_cpus_request(kvm, KVM_REQ_VM_DEAD);
>
> and then check it in kvm_vcpu_ioctl()
>
>         struct kvm *kvm = vcpu->kvm;
>
>         if (kvm->mm != current->mm || kvm->vm_bugged || kvm->???)
>                 return -EIO;
>
> That way the source vCPUs don't need to be locked and all vCPU ioctls() are
> blocked, which I think is ideal since the vCPUs are in a frankenstate and really
> should just die.
>
> Maybe we can call the flag "zombie", or "mostly_dead" :-)

Do we actually need this functionality? We currently do intra-host
migration leaving the old vCPUs in a potentially dangling state until
we clean them up, so I am wondering why SEV VMs intra-host migration
should be special cased? Why not just zero out all the SEV-ES state
here so they cannot corrupt the GHCB, VMSA, etc. That is already safer
than what's done currently since the source vCPUs are still available
until the source VMM starts to tear down, those vCPUs could still be
run affecting guest state unexpectedly.

>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c80fa1d378c9..e3f49ca01f95 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9423,7 +9423,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>         }
>
>         if (kvm_request_pending(vcpu)) {
> -               if (kvm_check_request(KVM_REQ_VM_BUGGED, vcpu)) {
> +               if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) {
>                         r = -EIO;
>                         goto out;
>                 }
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 0f18df7fe874..de8d25cef183 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -150,7 +150,7 @@ static inline bool is_error_page(struct page *page)
>  #define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_UNBLOCK           2
>  #define KVM_REQ_UNHALT            3
> -#define KVM_REQ_VM_BUGGED         (4 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> +#define KVM_REQ_VM_DEAD                  (4 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQUEST_ARCH_BASE     8
>
>  #define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \
> @@ -654,7 +654,7 @@ struct kvm {
>  static inline void kvm_vm_bugged(struct kvm *kvm)
>  {
>         kvm->vm_bugged = true;
> -       kvm_make_all_cpus_request(kvm, KVM_REQ_VM_BUGGED);
> +       kvm_make_all_cpus_request(kvm, KVM_REQ_VM_DEAD);
>  }
>
>  #define KVM_BUG(cond, kvm, fmt...)
>
>
> Back when I made this bad suggestion in v7, you said "we need to keep using the
> source VM even after the state is transfered"[*].  What all do you need to do
> after the migration?  I assume it's mostly memory related per-VM ioctls?
>
>
> [*] https://lkml.kernel.org/r/CAMkAt6q3as414YMZco6UyCycY+jKbaYS5BUdC+U+8iWmBft3+A@mail.gmail.com
>
> > +     }
> > +     ret = 0;
> > +
> > +out_source_vcpu:
> > +     sev_unlock_vcpus_for_migration(source_kvm);
> > +
> > +out_dst_vcpu:
> > +     sev_unlock_vcpus_for_migration(kvm);
> > +
> > +out_source:
> > +     sev_unlock_after_migration(source_kvm);
> > +out_fput:
> > +     if (source_kvm_file)
> > +             fput(source_kvm_file);
> > +out_unlock:
> > +     sev_unlock_after_migration(kvm);
> > +     return ret;
> > +}
> > +
> >  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> >  {
> >       struct kvm_sev_cmd sev_cmd;
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 68294491c23d..c2e25ae4757f 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -4637,6 +4637,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
> >       .mem_enc_unreg_region = svm_unregister_enc_region,
> >
> >       .vm_copy_enc_context_from = svm_vm_copy_asid_from,
> > +     .vm_migrate_protected_vm_from = svm_vm_migrate_from,
> >
> >       .can_emulate_instruction = svm_can_emulate_instruction,
> >
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index 6d8d762d208f..d7b44b37dfcf 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -80,6 +80,7 @@ struct kvm_sev_info {
> >       u64 ap_jump_table;      /* SEV-ES AP Jump Table address */
> >       struct kvm *enc_context_owner; /* Owner of copied encryption context */
> >       struct misc_cg *misc_cg; /* For misc cgroup accounting */
> > +     atomic_t migration_in_progress;
> >  };
> >
> >  struct kvm_svm {
> > @@ -557,6 +558,7 @@ int svm_register_enc_region(struct kvm *kvm,
> >  int svm_unregister_enc_region(struct kvm *kvm,
> >                             struct kvm_enc_region *range);
> >  int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd);
> > +int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd);
> >  void pre_sev_run(struct vcpu_svm *svm, int cpu);
> >  void __init sev_set_cpu_caps(void);
> >  void __init sev_hardware_setup(void);
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 0c8b5129effd..c80fa1d378c9 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -5665,6 +5665,12 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >               if (kvm_x86_ops.vm_copy_enc_context_from)
> >                       r = kvm_x86_ops.vm_copy_enc_context_from(kvm, cap->args[0]);
> >               return r;
> > +     case KVM_CAP_VM_MIGRATE_PROTECTED_VM_FROM:
>
> I wonder... would it make sense to hedge and just call this KVM_CAP_VM_MIGRATE_VM_FROM?
> I can't think of a use case where KVM would "need" to do this for a non-protected
> VM, but I also don't see a huge naming problem if the "PROTECTED" is omitted.

Currently this CAP only deals with "protected" VM metadata. This call
isn't needed at all for non-protected VMs so wouldn't this change
imply that this call is needed for intra-host migration of all VMs?

>
> > +             r = -EINVAL;
> > +             if (kvm_x86_ops.vm_migrate_protected_vm_from)
> > +                     r = kvm_x86_ops.vm_migrate_protected_vm_from(
> > +                             kvm, cap->args[0]);
>
> Either let that poke out and/or refactor to avoid the indentation.  E.g.
>
>                 r = -EINVAL;
>                 if (!kvm_x86_ops.vm_migrate_protected_vm_from)
>                         break;
>
>                 return kvm_x86_ops.vm_migrate_protected_vm_from(kvm, cap->args[0]);
>
>
> > +             return r;
> >       case KVM_CAP_EXIT_HYPERCALL:
> >               if (cap->args[0] & ~KVM_EXIT_HYPERCALL_VALID_MASK) {
> >                       r = -EINVAL;
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index a067410ebea5..77b292ed01c1 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1112,6 +1112,7 @@ struct kvm_ppc_resize_hpt {
> >  #define KVM_CAP_BINARY_STATS_FD 203
> >  #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
> >  #define KVM_CAP_ARM_MTE 205
> > +#define KVM_CAP_VM_MIGRATE_PROTECTED_VM_FROM 206
> >
> >  #ifdef KVM_CAP_IRQ_ROUTING
> >
> > --
> > 2.33.0.1079.g6e70778dc9-goog
> >
