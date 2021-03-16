Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50D933DB76
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 18:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239404AbhCPRwo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 13:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239351AbhCPRw2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 13:52:28 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F139FC061756
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 10:52:27 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id ha17so10280718pjb.2
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 10:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CfJG7uHf9HXPODwjHgsgYjlgZSnKWQC8zIWF+EDymdU=;
        b=kew0OptwqWKz2Pnd1265Rjs9uBX4IMbv3buudIgN0nuJORWyz2AjAEa+Rj8LRq43Le
         w0kgtD3vAID4ThDlzDD3cGwRsDEAEllKA7U6R04QXcy5d2qdPbKtwVmxyEXAjIzobirM
         5aZmiBroV8vE8j027YWfmsN1eh32I/G73HF1L2Ixt3Id3wWLFUD+buryEgK5+XlU9PQF
         XWzYG6a4kKoEKbaRfekJVhnjEndFgNdNoYHxrSu19Lbq1/mHWq8fjsPAgZUidQm5IbO/
         9fTa9/lZrMnX/c7Xh/lb4E6cEWah1roEFysthgtw/tO5T36pi1fXgFbaRH6YRfMv1veG
         zkug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CfJG7uHf9HXPODwjHgsgYjlgZSnKWQC8zIWF+EDymdU=;
        b=tzCT/NZBOsO8Dr10IYrPb6PItpJBMkEIZImO/w0l2wz8pronyivUTS0QuzNSrCs5SS
         LKcKeV+5/wb2e3rJ6NNJbAIjPzamr5UYj7z3ILAFvrYJhcU65h5ova7PGYpGu1ROOffq
         Jx4JVI1ddZ27s4hwtF/Ql1RshAlppxMFptldPwjrQdPuxKc2SHtUykpucqiZzWyOl/It
         VeIyZ8itGdbgB05eSJGeFbg/V1jPA9Dztl+P7ovE6/C8eTpUyy4dcOzAbcxHLY7BPXvZ
         ETh1wPUaTkEYG/Gh0Jz7kCLZe5b4PNm7C3bvulB+lJaQcKxt9ILpZOwCVYokdAilVZo/
         qUUQ==
X-Gm-Message-State: AOAM532DJ19eSpbb32HTBIeeno1WaJj7USEB/0TavqFab+RV+R6GSRbH
        N2vZs0rq+3qJQF+budVitlQZCA==
X-Google-Smtp-Source: ABdhPJwclkStqeVU7fdftldfw7IkaGIybRSkKGYf9AwNbnTVGd1lmLWHoyX6aXDPr1UeBAG2HaWiQA==
X-Received: by 2002:a17:90a:d90a:: with SMTP id c10mr236986pjv.13.1615917147308;
        Tue, 16 Mar 2021 10:52:27 -0700 (PDT)
Received: from google.com ([2620:15c:f:10:e113:95c2:2d1:e304])
        by smtp.gmail.com with ESMTPSA id d134sm17106638pfd.159.2021.03.16.10.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 10:52:26 -0700 (PDT)
Date:   Tue, 16 Mar 2021 10:52:19 -0700
From:   Sean Christopherson <seanjc@google.com>
To:     Nathan Tempelman <natet@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steve Rutherford <srutherford@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>
Subject: Re: [RFC] KVM: x86: Support KVM VMs sharing SEV context
Message-ID: <YFDwU3CC/DgRo6Vk@google.com>
References: <20210224085915.28751-1-natet@google.com>
 <YDaOw48Ug7Tgr+M6@google.com>
 <CAKiEG5qtTbm8dtE3pZDy_rfSfTfvhCYhDCh2DD-uh2w6xZnvcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKiEG5qtTbm8dtE3pZDy_rfSfTfvhCYhDCh2DD-uh2w6xZnvcQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 12, 2021, Nathan Tempelman wrote:
> On Wed, Feb 24, 2021 at 9:37 AM Sean Christopherson <seanjc@google.com> wrote:
> > > @@ -1282,6 +1299,65 @@ int svm_unregister_enc_region(struct kvm *kvm,
> > >       return ret;
> > >  }
> > >
> > > +int svm_vm_copy_asid_to(struct kvm *kvm, unsigned int mirror_kvm_fd)
> > > +{
> > > +     struct file *mirror_kvm_file;
> > > +     struct kvm *mirror_kvm;
> > > +     struct kvm_sev_info *mirror_kvm_sev;
> >
> > What about using src and dst, e.g. src_kvm, dest_kvm_fd, dest_kvm, etc...?  For
> > my brain, the mirror terminology adds an extra layer of translation.
> 
> I like source, but I think I'll keep mirror. I think it captures the current
> state of it better--this isn't it's own full featured sev vm, in a sense it's
> a reflection of the source.

The two things I dislike about mirror is that (for me) it's not clear whether
"mirror" is the source or the dest, and "mirror" implies that there is ongoing
synchronization.

> > > +
> > > +     /*
> > > +      * The mirror_kvm holds an enc_context_owner ref so its asid can't
> > > +      * disappear until we're done with it
> > > +      */
> > > +     kvm_get_kvm(kvm);
> >
> > Do we really need/want to take a reference to the source 'struct kvm'?  IMO,
> > the so called mirror should never be doing operations with its source context,
> > i.e. should not have easy access to 'struct kvm'.  We already have a reference
> > to the fd, any reason not to use that to ensure liveliness of the source?
> 
> I agree the mirror should never be running operations on the source. I don't
> know that holding the fd instead of the kvm makes that much better though,
> are there advantages to that I'm not seeing?

If there's no kvm pointer, it's much more difficult for someone to do the wrong
thing, and any such shenanigans stick out like a sore thumb in patches, which
makes reviewing future changes easier.

> > > +     mutex_unlock(&kvm->lock);
> > > +     mutex_lock(&mirror_kvm->lock);
> > > +
> > > +     /* Set enc_context_owner and copy its encryption context over */
> > > +     mirror_kvm_sev = &to_kvm_svm(mirror_kvm)->sev_info;
> > > +     mirror_kvm_sev->enc_context_owner = kvm;
> > > +     mirror_kvm_sev->asid = asid;
> > > +     mirror_kvm_sev->active = true;
> >
> > I would prefer a prep patch to move "INIT_LIST_HEAD(&sev->regions_list);" from
> > sev_guest_init() to when the VM is instantiated.  Shaving a few cycles in that
> > flow is meaningless, and not initializing the list of regions is odd, and will
> > cause problems if mirrors are allowed to pin memory (or do PSP commands).
> 
> It seems like we can keep this a lot simpler and easier to reason about by not
> allowing mirrors to pin memory or do psp commands. That was the intent. We
> don't gain anything but complexity by allowing this to be a fully featured SEV
> VM. Unless anyone can think of a good reason we'd want to have a mirror
> vm be able to do more than this?

I suspect the migration helper will need to pin memory independent of the real
VM.

But, for me, that's largely orthogonal to initializing regions_list.  Leaving a
list uninitialized for no good reason is an unnecessary risk, as any related
bugs are all but guaranteed to crash the host.

> > > @@ -5321,6 +5321,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> > >                       kvm->arch.bus_lock_detection_enabled = true;
> > >               r = 0;
> > >               break;
> > > +     case KVM_CAP_VM_COPY_ENC_CONTEXT_TO:
> > > +             r = -ENOTTY;
> > > +             if (kvm_x86_ops.vm_copy_enc_context_to)
> > > +                     r = kvm_x86_ops.vm_copy_enc_context_to(kvm, cap->args[0]);
> >
> > This can be a static call.
> >
> > On a related topic, does this really need to be a separate ioctl()?  TDX can't
> > share encryption contexts, everything that KVM can do for a TDX guest requires
> > the per-VM context.  Unless there is a known non-x86 use case, it might be
> > better to make this a mem_enc_op, and then it can be named SEV_SHARE_ASID or
> > something.
> 
> I'd prefer to leave this as a capability in the same way the
> register_enc_region calls work. Moving it into mem_enc_ops means we'll have
> to do some messy locking to avoid race conditions with the second vm since
> kvm gets locked in enc_ops.

Eh, it's not that bad.

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 83e00e524513..0cb8a5022580 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1124,6 +1124,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
        if (copy_from_user(&sev_cmd, argp, sizeof(struct kvm_sev_cmd)))
                return -EFAULT;

+       if (sev_cmd.id == SEV_SHARE_ASID)
+               return sev_shared_asid(kvm, &sev_cmd);
+
        mutex_lock(&kvm->lock);

        switch (sev_cmd.id) {

> Also seems wierd to me having this hack grouped in with all the PSP commands.
> If i'm the only one that thinks this is cleaner, I'll move it though.

Heh, IMO, that ship already sailed.  KVM_MEMORY_ENCRYPT_OP is quite the misnomer
given that most of the commands do way more than fiddle with memory encryption.
At least with this one, the ASID is directly tied to hardware's encryption of
memory.

> Interesting about the platform, too. If you're sure we'll never need to build
> this for any other platform I'll at least rename it to be amd specific.
> There's no non-sev scenario anyone can think of that might want to do this?
