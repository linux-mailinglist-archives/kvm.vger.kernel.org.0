Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAB2637CD2
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 16:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiKXPVm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 10:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiKXPVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 10:21:31 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0E850D57
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 07:20:22 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id g12so3008937lfh.3
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 07:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LxKoCofS31QFXvRcSRvD6oWtnY5faKW+CxqtALd3TyI=;
        b=CIW3bQsrx5cMeGhs7cVbSudbgvYV+4Dg2DQluJ0RT0eA9cQ37Q9Fhz2AyBlmrKlr4E
         xDD2CqHfuTWTSngibeOi4/subuel2VhhtThlJHZiBhEsmw68uftS9LhvILzoQh/HLioE
         U0Agu0U0HQ+mfCX0B+bzHCDACRCXPNM01sSxm7Kr8xGGXScaWJ9Ej+K+7Qlyhe0d5lPs
         Es/FRPaCCDQ4l156HdKiUtn4y6+oVLo2SU6g+kYP+lUYMwplsnNHvSuGajUJskJkRb3T
         kmHc7ozQaxK3jGLHRF83eyi7Cl0N86Fi4WOjgIdBVVH2Jbe/hWSOxB/+t0eW0bYrjBBk
         l+Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LxKoCofS31QFXvRcSRvD6oWtnY5faKW+CxqtALd3TyI=;
        b=QFtJlY5vWZEyKPEIoF1g0gQQrMcUDyzH7cucKxgwDrGh6rhfI0gCXS/+/NOxRYK/Tt
         v5PdUThoTCEh8EHDaH4QVetEyQW6T2yMoKUNHSzc+i0ep71xGqRA1hm1JMhe4uBOHrL0
         nptYlB8ssBXFbc/sHTLcYzT6iDkkOpO9r6etfctly2MWPN9XHFyHDGGMkVV1UBmSs58E
         u400/TY1N0hI3DSvi8qFTQOxH6uKPkPqSxvL4NJrtI0L2nNup8Chrr4mZNrALE1ucnJb
         2tfsUoUGlYkQ0ruRJpFl14jgHOZDZKO2WmO3AFgBJDY+wo4/mqZDVvR+seNqjWeM7n4I
         dWaA==
X-Gm-Message-State: ANoB5pn1EYJ5uKAvarHZoSkPviEnytizGgoJpohBY7+EVHqXjGUQyM0D
        kZEtwbGXz1/7IDlUy+GjNZGRrt0KhyAdKGWTCfb8Wg==
X-Google-Smtp-Source: AA0mqf7oRnCt9jh54JWV40GoyprINTQi6aumPhV5dPMxV6kkQLDLzsk1MTfNP9hDD5h6IHwtpPnIdP/XMTzTs97MzqI=
X-Received: by 2002:a05:6512:1106:b0:4a4:7b88:68fc with SMTP id
 l6-20020a056512110600b004a47b8868fcmr12280885lfg.30.1669303211030; Thu, 24
 Nov 2022 07:20:11 -0800 (PST)
MIME-Version: 1.0
References: <20221115111549.2784927-1-tabba@google.com> <20221115111549.2784927-9-tabba@google.com>
 <Y39PCG0ZRHf/2d5E@monolith.localdoman>
In-Reply-To: <Y39PCG0ZRHf/2d5E@monolith.localdoman>
From:   Fuad Tabba <tabba@google.com>
Date:   Thu, 24 Nov 2022 15:19:34 +0000
Message-ID: <CA+EHjTx6JRODjncxMz6pBO43S2gAFZt4vDibG=Zwbr7TkbiFeQ@mail.gmail.com>
Subject: Re: [PATCH kvmtool v1 08/17] Use memfd for all guest ram allocations
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, will@kernel.org
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

Hi,

On Thu, Nov 24, 2022 at 11:01 AM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi,
>
> On Tue, Nov 15, 2022 at 11:15:40AM +0000, Fuad Tabba wrote:
> > Allocate all guest ram backed by memfd/ftruncate instead of
> > anonymous mmap. This will make it easier to use kvm with fd-based
> > kvm guest memory proposals [*]. It also would make it easier to
> > use ipc memory sharing should that be needed in the future.
>
> Today, there are two memory allocation paths:
>
> - One using hugetlbfs when --hugetlbfs is specified on the command line, =
which
>   creates a file.
>
> - One using mmap, when --hugetlbfs is not specified.
>
> How would support in kvmtool for the secret memfd look like? I assume the=
re
> would need to be some kind of command line parameter to kvmtool to instru=
ct it
> to use the secret memfd, right? What I'm trying to figure out is why is
> necessary to make everything a memfd file instead of adding a third memor=
y
> allocation path just for that particular usecase (or merging the hugetlbf=
s path
> if they are similar enough). Right now, the anonymous memory path is a
> mmap(MAP_ANONYMOUS) call, simple and straightforward, and I would like so=
me more
> convincing that this change is needed.

This isn't about secret mem, but about the unified proposal for guest
private memory [1].  This proposal requires the use of a file
descriptor (fd) as the canonical reference to guest memory in the host
(i.e., VMM) and does not provide an alternative using a
straightforward anonymous mmap(). The idea is that guest memory
shouldn=E2=80=99t have mapping in the host by default, but unless explicitl=
y
shared and needed.

Moreover, using an fd would be more generic and flexible, which allows
for other use cases (such as IPC), or to map that memory in userspace
when appropriate. It also allows us to use the same interface for
hugetlb. Considering that other VMMs (e.g., qemu [2], crosvm [3])
already back guest memory with memfd, and looking at how private
memory would work [4], it seemed to me that the best way to unify all
of these needs is to have the backend of guest memory be fd-based.

It would be possible to have that as a separate kvmtool option, where
fd-backed memory would be only for guests that use the new private
memory extensions. However, that would mean more code to maintain that
is essentially doing the same thing (allocating and mapping memory).

I thought that it would be worth having these patches in kvmtool now
rather than wait until the guest private memory has made it into kvm.
These patches simplify the code as an end result, make it easier to
allocate and map aligned memory without overallocating, and bring
kvmtool closer to a more consistent way of allocating guest memory, in
a similar manner to other VMMs.

Moreover, with the private memory proposal [1], whether the fd-based
support available can be queried by a KVM capability. If it's
available kvmtool would use the fd, if it's not available, it would
use the host-mapped address. Therefore, there isn=E2=80=99t a need for a
command line option, unless for testing.

I have implemented this all the way to support the private memory
proposal in kvmtool [5], but I haven=E2=80=99t posted these since the priva=
te
memory proposal itself is still in flux. If you=E2=80=99re interested you
could have a look on how I would go ahead building on these patches
for full support of private memory backed by an fd.

> Regarding IPC memory sharing, is mmap'ing an memfd file enough to enable
> that? If more work is needed for it, then wouldn't it make more sense to =
do
> all the changes at once? This change might look sensible right now, but i=
t
> might turn out that it was the wrong way to go about it when someone
> actually starts implementing memory sharing.

I don=E2=80=99t plan on supporting IPC memory sharing. I just mentioned tha=
t
as yet another use case that would benefit from guest memory being
fd-based, should kvmtool decide to support it in the future.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20221025151344.3784230-1-chao.p.peng@linux.=
intel.com/
[2] https://github.com/qemu/qemu
[3] https://chromium.googlesource.com/chromiumos/platform/crosvm/
[4] https://github.com/chao-p/qemu/tree/privmem-v9
[5] https://android-kvm.googlesource.com/kvmtool/+/refs/heads/tabba/fdmem-v=
9-core



>
> Regarding IPC memory sharing, is mmap'ing an memfd file enough to enable
> that? If more work is needed for it, then wouldn't it make more sense to =
do
> all the changes at once? This change might look sensible right now, but i=
t
> might turn out that it was the wrong way to go about it when someone
> actually starts implementing memory sharing.
>
> Thanks,
> Alex
>
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> >
> > [*] https://lore.kernel.org/all/20221025151344.3784230-1-chao.p.peng@li=
nux.intel.com/
> > ---
> >  include/kvm/kvm.h  |  1 +
> >  include/kvm/util.h |  3 +++
> >  kvm.c              |  4 ++++
> >  util/util.c        | 33 ++++++++++++++++++++-------------
> >  4 files changed, 28 insertions(+), 13 deletions(-)
> >
> > diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> > index 3872dc6..d0d519b 100644
> > --- a/include/kvm/kvm.h
> > +++ b/include/kvm/kvm.h
> > @@ -87,6 +87,7 @@ struct kvm {
> >       struct kvm_config       cfg;
> >       int                     sys_fd;         /* For system ioctls(), i=
.e. /dev/kvm */
> >       int                     vm_fd;          /* For VM ioctls() */
> > +     int                     ram_fd;         /* For guest memory. */
> >       timer_t                 timerid;        /* Posix timer for interr=
upts */
> >
> >       int                     nrcpus;         /* Number of cpus to run =
*/
> > diff --git a/include/kvm/util.h b/include/kvm/util.h
> > index 61a205b..369603b 100644
> > --- a/include/kvm/util.h
> > +++ b/include/kvm/util.h
> > @@ -140,6 +140,9 @@ static inline int pow2_size(unsigned long x)
> >  }
> >
> >  struct kvm;
> > +int memfd_alloc(u64 size, bool hugetlb, u64 blk_size);
> > +void *mmap_anon_or_hugetlbfs_align(struct kvm *kvm, const char *htlbfs=
_path,
> > +                                u64 size, u64 align);
> >  void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *htlbfs_path,=
 u64 size);
> >
> >  #endif /* KVM__UTIL_H */
> > diff --git a/kvm.c b/kvm.c
> > index 78bc0d8..ed29d68 100644
> > --- a/kvm.c
> > +++ b/kvm.c
> > @@ -160,6 +160,7 @@ struct kvm *kvm__new(void)
> >       mutex_init(&kvm->mem_banks_lock);
> >       kvm->sys_fd =3D -1;
> >       kvm->vm_fd =3D -1;
> > +     kvm->ram_fd =3D -1;
> >
> >  #ifdef KVM_BRLOCK_DEBUG
> >       kvm->brlock_sem =3D (pthread_rwlock_t) PTHREAD_RWLOCK_INITIALIZER=
;
> > @@ -174,6 +175,9 @@ int kvm__exit(struct kvm *kvm)
> >
> >       kvm__arch_delete_ram(kvm);
> >
> > +     if (kvm->ram_fd >=3D 0)
> > +             close(kvm->ram_fd);
> > +
> >       list_for_each_entry_safe(bank, tmp, &kvm->mem_banks, list) {
> >               list_del(&bank->list);
> >               free(bank);
> > diff --git a/util/util.c b/util/util.c
> > index d3483d8..278bcc2 100644
> > --- a/util/util.c
> > +++ b/util/util.c
> > @@ -102,36 +102,38 @@ static u64 get_hugepage_blk_size(const char *htlb=
fs_path)
> >       return sfs.f_bsize;
> >  }
> >
> > -static void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, =
u64 size, u64 blk_size)
> > +int memfd_alloc(u64 size, bool hugetlb, u64 blk_size)
> >  {
> >       const char *name =3D "kvmtool";
> >       unsigned int flags =3D 0;
> >       int fd;
> > -     void *addr;
> > -     int htsize =3D __builtin_ctzl(blk_size);
> >
> > -     if ((1ULL << htsize) !=3D blk_size)
> > -             die("Hugepage size must be a power of 2.\n");
> > +     if (hugetlb) {
> > +             int htsize =3D __builtin_ctzl(blk_size);
> >
> > -     flags |=3D MFD_HUGETLB;
> > -     flags |=3D htsize << MFD_HUGE_SHIFT;
> > +             if ((1ULL << htsize) !=3D blk_size)
> > +                     die("Hugepage size must be a power of 2.\n");
> > +
> > +             flags |=3D MFD_HUGETLB;
> > +             flags |=3D htsize << MFD_HUGE_SHIFT;
> > +     }
> >
> >       fd =3D memfd_create(name, flags);
> >       if (fd < 0)
> > -             die("Can't memfd_create for hugetlbfs map\n");
> > +             die("Can't memfd_create for memory map\n");
> > +
> >       if (ftruncate(fd, size) < 0)
> >               die("Can't ftruncate for mem mapping size %lld\n",
> >                       (unsigned long long)size);
> > -     addr =3D mmap(NULL, size, PROT_RW, MAP_PRIVATE, fd, 0);
> > -     close(fd);
> >
> > -     return addr;
> > +     return fd;
> >  }
> >
> >  /* This function wraps the decision between hugetlbfs map (if requeste=
d) or normal mmap */
> >  void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *htlbfs_path,=
 u64 size)
> >  {
> >       u64 blk_size =3D 0;
> > +     int fd;
> >
> >       /*
> >        * We don't /need/ to map guest RAM from hugetlbfs, but we do so
> > @@ -146,9 +148,14 @@ void *mmap_anon_or_hugetlbfs(struct kvm *kvm, cons=
t char *htlbfs_path, u64 size)
> >               }
> >
> >               kvm->ram_pagesize =3D blk_size;
> > -             return mmap_hugetlbfs(kvm, htlbfs_path, size, blk_size);
> >       } else {
> >               kvm->ram_pagesize =3D getpagesize();
> > -             return mmap(NULL, size, PROT_RW, MAP_ANON_NORESERVE, -1, =
0);
> >       }
> > +
> > +     fd =3D memfd_alloc(size, htlbfs_path, blk_size);
> > +     if (fd < 0)
> > +             return MAP_FAILED;
> > +
> > +     kvm->ram_fd =3D fd;
> > +     return mmap(NULL, size, PROT_RW, MAP_PRIVATE, kvm->ram_fd, 0);
> >  }
> > --
> > 2.38.1.431.g37b22c650d-goog
> >
