Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5381D6BF0C2
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 19:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjCQSeR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 14:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCQSeQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 14:34:16 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A33335EE7
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 11:34:15 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id v48so3958354uad.6
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 11:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679078054;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GwBpg81Bs0dWXnvXPSqlhZMFacnGtj23q7VOuo+LNUY=;
        b=P8H42EP1nZzQ9p+Ct3PIvHl6k3JGsgs80Ke1aKpayPF9QBpeMJIUBtSBxD143APXQm
         MA2ffPghsXvhJ0RS8LYV/0zm35+MXwYi3wRxTH/c9AmPiQwmd6gqIbnz4TrnCxNBi/iL
         pHpWWoxt5MI5mpX/ER7HG5uEaExnNUEZZxvb7yf19f4KnDUqY/MbER5Jd7Jur6f+Kdqo
         KYGZCDPcyEoKyehBCKkYFgvtoTZK8t7IFS2rD6xUiUw24OCIBNVHO7cVTzEStOB0ol2S
         vXf48H4Eg5v+RXVaJhgMBTj0/1KJvdIQSQmeBwn1WmPjblVkPY2uYUc8LnyD5XrzukMr
         36MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679078054;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GwBpg81Bs0dWXnvXPSqlhZMFacnGtj23q7VOuo+LNUY=;
        b=C/P0xvoHWXF4l9pUF9OnqPFj7hvYXoEniPdJL0D/ZE6dabyUQx6EKwFs17PJqZy28X
         +HicPavIb5IjX4ghKuTWQnlgt8P9IE1Kxd0APC008StHPJ2gAzzKH1H0vzWHwXU1FVvA
         szSjJnNzGHykqso8S/0r7U7J+ReY+qJ6NN8k0TXKzDyeiThfQWN2YE5FzL7nen/mzvF0
         lu7iNwIuAuf6WPBrna+rlYiI0Vt2Z1XqAxld8AEame3X5Q9YdiRSnkjD353Y/4NmZ0Fw
         28IUV5AytJ5c67hWk+MVe7O1C5rbGgpOQLqzI3P+V2fkg1BKOE+NFJRCmC+2i/OZzTe4
         MAmQ==
X-Gm-Message-State: AO0yUKUv2oX9JVHl3+1VCxV4qqOrwUCFg3NzYcQkbYrtajcUJ0XTfCiO
        Tt8Xakrfj2cQSPt0azMIflpoIY4clXx8CuHeIuA2cg==
X-Google-Smtp-Source: AK7set+HtkNTp6VJjK6DoQK8sGWT65WQ/ScsFjaAAxBu3LOnSljzsF6apfcPjiHJInGCBHKo1rN+DsOZ4QKSLS5AD+Q=
X-Received: by 2002:a05:6122:180c:b0:3e2:ecf4:9f82 with SMTP id
 ay12-20020a056122180c00b003e2ecf49f82mr710764vkb.11.1679078054489; Fri, 17
 Mar 2023 11:34:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <20230315021738.1151386-5-amoorthy@google.com>
 <20230317000226.GA408922@ls.amr.corp.intel.com>
In-Reply-To: <20230317000226.GA408922@ls.amr.corp.intel.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Fri, 17 Mar 2023 11:33:38 -0700
Message-ID: <CAF7b7mrTa735kDaEsJQSHTt7gpWy_QZEtsgsnKoe6c21s0jDVw@mail.gmail.com>
Subject: Re: [WIP Patch v2 04/14] KVM: x86: Add KVM_CAP_X86_MEMORY_FAULT_EXIT
 and associated kvm_run field
To:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     seanjc@google.com, jthoughton@google.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 16, 2023 at 5:02=E2=80=AFPM Isaku Yamahata <isaku.yamahata@gmai=
l.com> wrote:

> > +7.34 KVM_CAP_X86_MEMORY_FAULT_EXIT
> > +----------------------------------
> > +
> > +:Architectures: x86
>
> Why x86 specific?

Sean was the only one to bring this functionality up and originally
did so in the context of some x86-specific functions, so I assumed
that x86 was the only ask and that maybe the other architectures had
alternative solutions. Admittedly I also wanted to avoid wading
through another big set of -EFAULT references :/

Those are the only reasons though. Marc, Oliver, should I bring this
capability to Arm as well?

> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index e38ddda05b261..00aec43860ff1 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1142,6 +1142,7 @@ static struct kvm *kvm_create_vm(unsigned long ty=
pe, const char *fdname)
> >       spin_lock_init(&kvm->mn_invalidate_lock);
> >       rcuwait_init(&kvm->mn_memslots_update_rcuwait);
> >       xa_init(&kvm->vcpu_array);
> > +     kvm->memfault_exit_reasons =3D 0;
> >
> >       INIT_LIST_HEAD(&kvm->gpc_list);
> >       spin_lock_init(&kvm->gpc_lock);
> > @@ -4671,6 +4672,14 @@ static int kvm_vm_ioctl_enable_cap_generic(struc=
t kvm *kvm,
> >
> >               return r;
> >       }
> > +     case KVM_CAP_X86_MEMORY_FAULT_EXIT: {
> > +             if (!kvm_vm_ioctl_check_extension(kvm, KVM_CAP_X86_MEMORY=
_FAULT_EXIT))
> > +                     return -EINVAL;
> > +             else if (!kvm_memfault_exit_flags_valid(cap->args[0]))
> > +                     return -EINVAL;
> > +             kvm->memfault_exit_reasons =3D cap->args[0];
> > +             return 0;
> > +     }
>
> Is KVM_CAP_X86_MEMORY_FAULT_EXIT really specific to x86?
> If so, this should go to kvm_vm_ioctl_enable_cap() in arch/x86/kvm/x86.c.
> (Or make it non-arch specific.)

Ah, thanks for the catch: I renamed my old non-x86 specific
capability, and forgot to move this block.

> > +inline int kvm_memfault_exit_or_efault(
> > +     struct kvm_vcpu *vcpu, uint64_t gpa, uint64_t len, uint64_t exit_=
flags)
> > +{
> > +     if (!(vcpu->kvm->memfault_exit_reasons & exit_flags))
> > +             return -EFAULT;
> > +     vcpu->run->exit_reason =3D KVM_EXIT_MEMORY_FAULT;
> > +     vcpu->run->memory_fault.gpa =3D gpa;
> > +     vcpu->run->memory_fault.len =3D len;
> > +     vcpu->run->memory_fault.flags =3D exit_flags;
> > +     return -1;
>
> Why -1? 0? Anyway enum exit_fastpath_completion is x86 kvm mmu internal
> convention. As WIP, it's okay for now, though.

The -1 isn't to indicate a failure in this function itself, but to
allow callers to substitute this for "return -EFAULT." A return code
of zero would mask errors and cause KVM to proceed in ways that it
shouldn't. For instance, "setup_vmgexit_scratch" uses it like this

if (kvm_read_guest(svm->vcpu.kvm, scratch_gpa_beg, scratch_va, len)) {
    ...
-  return -EFAULT;
+ return kvm_memfault_exit_or_efault(...);
}

and looking at one of its callers (sev_handle_vmgexit) shows how a
return code of zero would cause a different control flow

case SVM_VMGEXIT_MMIO_READ:
ret =3D setup_vmgexit_scratch(svm, true, control->exit_info_2);
if (ret)
    break;

ret =3D ret =3D kvm_sev_es_mmio_read(vcpu,
