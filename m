Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66AF7339A24
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 00:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235704AbhCLXrv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 18:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235885AbhCLXrk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 18:47:40 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 952DFC061574
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 15:47:40 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id r16so1593253pfh.10
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 15:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bjFvm7GKsUKfRs9e/UxDco4aKi8EfcNZsKLV6pl4eOs=;
        b=DJ7sCUKjOc5WbvYqhvNsNgc2FV/Cksy6090XmuWgRU3SVAWAux8J2qQhk8DkhTd6gW
         0Bm75UMGlzQ9ITZJHOvUeH39Py+FHn6B0ZubvFeKCwrcSw8K7OUw7SyvEugtxpDXJRKn
         g52E5mfgsz2Nea7VPWnLbo3Y0QUzkaCFbmnaJ/MYUR3VDPyQV+/uUkEhuhqOq7u0A0FB
         4HD80ckZLBRY/CD1d5/zZ2IazLbxnlnIBNv3cdRWvGsY7WqEoXDrWLcolabRuEhP/t4j
         6UoPS+Up41yjOHthZtBfbHSWOA5+w60XpojbYYj84sDWe0O8eQtymO/zaVEmPH0xvcKh
         7gwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bjFvm7GKsUKfRs9e/UxDco4aKi8EfcNZsKLV6pl4eOs=;
        b=Lq4HeNmQ2dkQQc9BkHLedpGzOk7SSLZMzhy7AUnjkG4VOUeClf2RPBN8lLTnWnvGOr
         c+bNgddqmpL33jK6JrRI0pffXYHUbSMcEYYXZQaV7Hk+PXE6E07hTgy+Xw5aXdGux4FH
         pTobIfsusiIZ5ozV0SIPrJr/LM9aFqtaQ7sSOgLKiVtBazxOGVsM4tFZnhDioN4VUZ45
         EEVAJZJfsDdKv+mlxjli5RT+rXE6q0+RRV91d2B8FpA/njyvYyu42u6GUbWG6ibdrFZF
         SjkQvGomAWCFo+CLDtctO0mBYU6X1lknHvJtX4GVwwVRKfiRaku4uJy7zdbq42GObzMy
         wn0w==
X-Gm-Message-State: AOAM530K+16vFGFGqxjxQ2BQx2T1vrM5OOj9uWvDgJgZIbVJcqLxw7Jt
        UNvteJwN8sTxnIyHTHAohWIFTA82Jc0tIbWAIhQMew==
X-Google-Smtp-Source: ABdhPJxmSHVpfjKKFW1s79hB4r3Xbg6oEeDtCAUIL2ZzgTxPwiAGzsVT8Q4fE5cKPJwf86hKukVUbajt0VmZmcs31js=
X-Received: by 2002:a62:ea09:0:b029:1ee:3bac:8012 with SMTP id
 t9-20020a62ea090000b02901ee3bac8012mr551470pfh.35.1615592859872; Fri, 12 Mar
 2021 15:47:39 -0800 (PST)
MIME-Version: 1.0
References: <20210224085915.28751-1-natet@google.com> <YDaOw48Ug7Tgr+M6@google.com>
In-Reply-To: <YDaOw48Ug7Tgr+M6@google.com>
From:   Nathan Tempelman <natet@google.com>
Date:   Fri, 12 Mar 2021 15:47:28 -0800
Message-ID: <CAKiEG5qtTbm8dtE3pZDy_rfSfTfvhCYhDCh2DD-uh2w6xZnvcQ@mail.gmail.com>
Subject: Re: [RFC] KVM: x86: Support KVM VMs sharing SEV context
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steve Rutherford <srutherford@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 24, 2021 at 9:37 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Feb 24, 2021, Nathan Tempelman wrote:
> >  static bool __sev_recycle_asids(int min_asid, int max_asid)
> >  {
> > @@ -1124,6 +1129,10 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> >       if (copy_from_user(&sev_cmd, argp, sizeof(struct kvm_sev_cmd)))
> >               return -EFAULT;
> >
> > +     /* enc_context_owner handles all memory enc operations */
> > +     if (is_mirroring_enc_context(kvm))
> > +             return -ENOTTY;
>
> Is this strictly necessary?  Honest question, as I don't know the hardware/PSP
> flows well enough to understand how asids are tied to the state managed by the
> PSP.
>
> > +
> >       mutex_lock(&kvm->lock);
> >
> >       switch (sev_cmd.id) {
> > @@ -1186,6 +1195,10 @@ int svm_register_enc_region(struct kvm *kvm,
> >       if (!sev_guest(kvm))
> >               return -ENOTTY;
> >
> > +     /* If kvm is mirroring encryption context it isn't responsible for it */
> > +     if (is_mirroring_enc_context(kvm))
>
> Hmm, preventing the mirror from pinning memory only works if the two VMs are in
> the same address space (process), which isn't guaranteed/enforced by the ioctl().
> Obviously we could check and enforce that, but do we really need to?
>
> Part of me thinks it would be better to treat the new ioctl() as a variant of
> sev_guest_init(), i.e. purely make this a way to share asids.
>
> > +             return -ENOTTY;
> > +
> >       if (range->addr > ULONG_MAX || range->size > ULONG_MAX)
> >               return -EINVAL;
> >
> > @@ -1252,6 +1265,10 @@ int svm_unregister_enc_region(struct kvm *kvm,
> >       struct enc_region *region;
> >       int ret;
> >
> > +     /* If kvm is mirroring encryption context it isn't responsible for it */
> > +     if (is_mirroring_enc_context(kvm))
> > +             return -ENOTTY;
> > +
> >       mutex_lock(&kvm->lock);
> >
> >       if (!sev_guest(kvm)) {
> > @@ -1282,6 +1299,65 @@ int svm_unregister_enc_region(struct kvm *kvm,
> >       return ret;
> >  }
> >
> > +int svm_vm_copy_asid_to(struct kvm *kvm, unsigned int mirror_kvm_fd)
> > +{
> > +     struct file *mirror_kvm_file;
> > +     struct kvm *mirror_kvm;
> > +     struct kvm_sev_info *mirror_kvm_sev;
>
> What about using src and dst, e.g. src_kvm, dest_kvm_fd, dest_kvm, etc...?  For
> my brain, the mirror terminology adds an extra layer of translation.

I like source, but I think I'll keep mirror. I think it captures the
current state
of it better--this isn't it's own full featured sev vm, in a sense
it's a reflection of
the source.

Unless everyone found this confusing?

>
> > +     unsigned int asid;
> > +     int ret;
> > +
> > +     if (!sev_guest(kvm))
> > +             return -ENOTTY;
> > +
> > +     mutex_lock(&kvm->lock);
> > +
> > +     /* Mirrors of mirrors should work, but let's not get silly */
>
> Do we really care?
>
> > +     if (is_mirroring_enc_context(kvm)) {
> > +             ret = -ENOTTY;
> > +             goto failed;
> > +     }
> > +
> > +     mirror_kvm_file = fget(mirror_kvm_fd);
> > +     if (!kvm_is_kvm(mirror_kvm_file)) {
> > +             ret = -EBADF;
> > +             goto failed;
> > +     }
> > +
> > +     mirror_kvm = mirror_kvm_file->private_data;
> > +
> > +     if (mirror_kvm == kvm || is_mirroring_enc_context(mirror_kvm)) {
>
> This is_mirroring_enc_context() check needs to be after mirror_kvm->lock is
> acquired, else there's a TOCTOU race.

Nice. Yeah, I've flipped it around as per Paolo's point and this problem goes
away.

>
> I also suspect there needs to be more checks on the destination.  E.g. what
> happens if the destination already has vCPUs that are currently running?  Though
> on that front, sev_guest_init() also doesn't guard against this.  Feels like
> that flow and this one should check kvm->created_vcpus.
>
> > +             ret = -ENOTTY;
> > +             fput(mirror_kvm_file);
>
> Nit, probably worth adding a second error label to handle this fput(), e.g. in
> case additional checks are needed in the future.  Actually, I suspect that's
> already needed to fix the TOCTOU bug.
>
> > +             goto failed;
> > +     }
> > +
> > +     asid = *&to_kvm_svm(kvm)->sev_info.asid;
>
> Don't think "*&" is necessary. :-)

:')

>
> > +
> > +     /*
> > +      * The mirror_kvm holds an enc_context_owner ref so its asid can't
> > +      * disappear until we're done with it
> > +      */
> > +     kvm_get_kvm(kvm);
>
> Do we really need/want to take a reference to the source 'struct kvm'?  IMO,
> the so called mirror should never be doing operations with its source context,
> i.e. should not have easy access to 'struct kvm'.  We already have a reference
> to the fd, any reason not to use that to ensure liveliness of the source?

I agree the mirror should never be running operations on the source. I
don't know
that holding the fd instead of the kvm makes that much better though, are there
advantages to that I'm not seeing?

>
> > +
> > +     mutex_unlock(&kvm->lock);
> > +     mutex_lock(&mirror_kvm->lock);
> > +
> > +     /* Set enc_context_owner and copy its encryption context over */
> > +     mirror_kvm_sev = &to_kvm_svm(mirror_kvm)->sev_info;
> > +     mirror_kvm_sev->enc_context_owner = kvm;
> > +     mirror_kvm_sev->asid = asid;
> > +     mirror_kvm_sev->active = true;
>
> I would prefer a prep patch to move "INIT_LIST_HEAD(&sev->regions_list);" from
> sev_guest_init() to when the VM is instantiated.  Shaving a few cycles in that
> flow is meaningless, and not initializing the list of regions is odd, and will
> cause problems if mirrors are allowed to pin memory (or do PSP commands).

It seems like we can keep this a lot simpler and easier to reason about by not
allowing mirrors to pin memory or do psp commands. That was the intent. We
don't gain anything but complexity by allowing this to be a fully featured SEV
VM. Unless anyone can think of a good reason we'd want to have a mirror
vm be able to do more than this?

> > @@ -5321,6 +5321,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >                       kvm->arch.bus_lock_detection_enabled = true;
> >               r = 0;
> >               break;
> > +     case KVM_CAP_VM_COPY_ENC_CONTEXT_TO:
> > +             r = -ENOTTY;
> > +             if (kvm_x86_ops.vm_copy_enc_context_to)
> > +                     r = kvm_x86_ops.vm_copy_enc_context_to(kvm, cap->args[0]);
>
> This can be a static call.
>
> On a related topic, does this really need to be a separate ioctl()?  TDX can't
> share encryption contexts, everything that KVM can do for a TDX guest requires
> the per-VM context.  Unless there is a known non-x86 use case, it might be
> better to make this a mem_enc_op, and then it can be named SEV_SHARE_ASID or
> something.

I'd prefer to leave this as a capability in the same way the
register_enc_region calls
work. Moving it into mem_enc_ops means we'll have to do some messy locking
to avoid race conditions with the second vm since kvm gets locked in enc_ops.
Also seems wierd to me having this hack grouped in with all the PSP commands.
If i'm the only one that thinks this is cleaner, I'll move it though.

Interesting about the platform, too. If you're sure we'll never need
to build this for
any other platform I'll at least rename it to be amd specific. There's
no non-sev
scenario anyone can think of that might want to do this?


>
> > +             return r;
> >       default:
> >               r = -EINVAL;
> >               break;
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index e126ebda36d0..18491638f070 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -637,6 +637,7 @@ void kvm_exit(void);
> >
> >  void kvm_get_kvm(struct kvm *kvm);
> >  void kvm_put_kvm(struct kvm *kvm);
> > +bool kvm_is_kvm(struct file *file);
> >  void kvm_put_kvm_no_destroy(struct kvm *kvm);
> >
> >  static inline struct kvm_memslots *__kvm_memslots(struct kvm *kvm, int as_id)
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 63f8f6e95648..5b6296772db9 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1077,6 +1077,7 @@ struct kvm_ppc_resize_hpt {
> >  #define KVM_CAP_SYS_HYPERV_CPUID 191
> >  #define KVM_CAP_DIRTY_LOG_RING 192
> >  #define KVM_CAP_X86_BUS_LOCK_EXIT 193
> > +#define KVM_CAP_VM_COPY_ENC_CONTEXT_TO 194
> >
> >  #ifdef KVM_CAP_IRQ_ROUTING
> >
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 001b9de4e727..5f31fcda4777 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -739,6 +739,8 @@ void __weak kvm_arch_pre_destroy_vm(struct kvm *kvm)
> >  {
> >  }
> >
> > +static struct file_operations kvm_vm_fops;
>
> I'd probably prefer to put the helper just below kvm_vm_fops instead of adding
> a forward declaration.  IMO it's not all that important to add the helper close
> to kvm_get/put_kvm().
>
> > +
> >  static struct kvm *kvm_create_vm(unsigned long type)
> >  {
> >       struct kvm *kvm = kvm_arch_alloc_vm();
> > @@ -903,6 +905,12 @@ void kvm_put_kvm(struct kvm *kvm)
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_put_kvm);
> >
> > +bool kvm_is_kvm(struct file *file)
>
> Heh, maybe kvm_file_is_kvm()?  or just file_is_kvm()?
>
> > +{
> > +     return file && file->f_op == &kvm_vm_fops;
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_is_kvm);
> > +
> >  /*
> >   * Used to put a reference that was taken on behalf of an object associated
> >   * with a user-visible file descriptor, e.g. a vcpu or device, if installation
> > --
> > 2.30.0.617.g56c4b15f3c-goog
> >
