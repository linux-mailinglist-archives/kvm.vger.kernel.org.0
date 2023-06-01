Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04DFF71F3DC
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 22:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbjFAUbn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 16:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbjFAUbk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 16:31:40 -0400
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CDB1A5
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 13:31:36 -0700 (PDT)
Received: by mail-vk1-xa29.google.com with SMTP id 71dfb90a1353d-45739737afcso194810e0c.2
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 13:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685651495; x=1688243495;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fCdppP1yzs2e9HWgLEox7Link4qX3QEAMcIV5JXxai4=;
        b=N8eO1ZM32oqOBHH95Zbd98y4z9RgkY90p6VScKoG8T6k2j5QsA9kuJM+EVjN5wuPGd
         aC1MguSg77IKa4H5TMXhYD2cqZQjMgXN3ciiALsg/uAHoYdDClBpvRqyUY6Lv7kW/9dD
         lgk2GPWMdB7DXjvtYpFvqEDWbibQdnuP6LcLg5B4bwZ5MdkjaKEQKZ1o830vF67a4T+J
         ATURAoUoMYows1dUccovCZVqJMU57DA35LqRYMAEovWZp+e5YybXCZLuSgfsBUmxe2dl
         z4KiAfSnUQdYnQZAuPawdvVYG2m7bHHhBSIjr5aoCpSP2ugxQDQeidWT2QziAIXnhQWZ
         rJ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685651495; x=1688243495;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fCdppP1yzs2e9HWgLEox7Link4qX3QEAMcIV5JXxai4=;
        b=YBy+TbpQyHten6VuA/XUJx1Ufh//IiEmLp6q/a8/Jft6aE6i0+xj6DUJqdn674OS00
         2Ql0FUxk5J0WAZ+M/rGZ6HQ2sX83R8jS4urJBXvGYcv4Z05tfB9+NHa2h4DM10cZt48H
         h+1+7kMGfvbYDcnm2NC+SQ2MLLo7zgODIquoCk4Rj6BEC1PToFftQh/NX14DzFqPdPrG
         KSparokToDqAu7etCq1Q+CYsJ5Zoti7tS7CjW5KsIVVaL4u2HD5/gGkmG+EVgnWPEf65
         eded3gIH/OWQIcPBzcH+hDGtEmcWuJ5OTw4FVhOJJjpYwN92gEPEdRyULl9yprelZlqj
         xdag==
X-Gm-Message-State: AC+VfDxwk+3/pxrFwRhcr/QG40Tnmp1/pDEQMM4zeVTcj5Uwb3nCVfwE
        mYqMKzw8oEonKvLTz9i6rrjhUe6QVx2xmFZKOJ4C6A==
X-Google-Smtp-Source: ACHHUZ6yUmT7COf02IzIPOe4hskbEzCwLrkpgUz5VmUI8BA1m07nbgRhybPSjRJm4w5iLcdwfXjPF9CdwbXN/2Xv9sM=
X-Received: by 2002:a1f:52c3:0:b0:440:3ef7:35ba with SMTP id
 g186-20020a1f52c3000000b004403ef735bamr1076568vkb.13.1685651495198; Thu, 01
 Jun 2023 13:31:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-6-amoorthy@google.com>
 <ZHj25HsCExz/uCo/@linux.dev>
In-Reply-To: <ZHj25HsCExz/uCo/@linux.dev>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Thu, 1 Jun 2023 13:30:58 -0700
Message-ID: <CAF7b7mrK+SgyxjYqMyJC0PA4C8SFRX_Q=x7Db+Ck8i89wzvw8w@mail.gmail.com>
Subject: Re: [PATCH v3 05/22] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        jthoughton@google.com, bgardon@google.com, dmatlack@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Thu, Jun 1, 2023 at 12:52=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> So the other angle of my concern w.r.t. NOWAIT exits is the fact that
> userspace gets to decide whether or not we annotate such an exit. We all
> agree that a NOWAIT exit w/o context isn't actionable, right?

Yup

> Sean is suggesting that we abuse the fact that kvm_run already contains
> junk for EFAULT exits and populate kvm_run::memory_fault unconditionally
> [*]. I agree with him, and it eliminates the odd quirk of 'bare' NOWAIT
> exits too. Old userspace will still see 'garbage' in kvm_run struct,
> but one man's trash is another man's treasure after all :)
>
> So, based on that, could you:
>
>  - Unconditionally prepare MEMORY_FAULT exits everywhere you're
>    converting here
>
>  - Redefine KVM_CAP_MEMORY_FAULT_INFO as an informational cap, and do
>    not accept an attempt to enable it. Instead, have calls to
>    KVM_CHECK_EXTENSION return a set of flags describing the supported
>    feature set.

Sure. I've been collecting feedback as it comes in, so I can send up a
v4 with everything up to now soon. The major thing left to resolve is
that the exact set of annotations is still waiting on feedback: I've
already gone ahead and dropped everything I wasn't sure of in [1], so
the next version will be quite a bit smaller. If it turns out that
I've dropped too much, then I can add things back in based on the
feedback.

[1] https://lore.kernel.org/kvm/20230412213510.1220557-1-amoorthy@google.co=
m/T/#mfe28e6a5015b7cd8c5ea1c351b0ca194aeb33daf

>    Eventually, you can stuff a bit in there to advertise that all
>    EFAULTs are reliable.

I don't think this is an objective: the idea is to annotate efaults
tracing back to user accesses (see [2]). Although the idea of
annotating with some "unrecoverable" flag set for other efaults has
been tossed around, so we may end up with that.

[2] https://lore.kernel.org/kvm/20230412213510.1220557-1-amoorthy@google.co=
m/T/#m5715f3a14a6a9ff9a4188918ec105592f0bfc69a

> [*] https://lore.kernel.org/kvmarm/ZHjqkdEOVUiazj5d@google.com/
>
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index cf7d3de6f3689..f3effc93cbef3 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1142,6 +1142,7 @@ static struct kvm *kvm_create_vm(unsigned long ty=
pe, const char *fdname)
> >       spin_lock_init(&kvm->mn_invalidate_lock);
> >       rcuwait_init(&kvm->mn_memslots_update_rcuwait);
> >       xa_init(&kvm->vcpu_array);
> > +     kvm->fill_efault_info =3D false;
> >
> >       INIT_LIST_HEAD(&kvm->gpc_list);
> >       spin_lock_init(&kvm->gpc_lock);
> > @@ -4096,6 +4097,8 @@ static long kvm_vcpu_ioctl(struct file *filp,
> >                       put_pid(oldpid);
> >               }
> >               r =3D kvm_arch_vcpu_ioctl_run(vcpu);
> > +             WARN_ON_ONCE(r =3D=3D -EFAULT &&
> > +                                      vcpu->run->exit_reason !=3D KVM_=
EXIT_MEMORY_FAULT);
>
> This might be a bit overkill, as it will definitely fire on unsupported
> architectures. Instead you may want to condition this on an architecture
> actually selecting support for MEMORY_FAULT_INFO.

Ah, that's embarrassing. Thanks for the catch.
