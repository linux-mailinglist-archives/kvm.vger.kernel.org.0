Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F754645CEE
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 15:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbiLGOws (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 09:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiLGOwq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 09:52:46 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B347C758
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 06:52:45 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id q7so21148231ljp.9
        for <kvm@vger.kernel.org>; Wed, 07 Dec 2022 06:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FrcuAlouHuvEXVHFCY8oNU/dwUMLWUN3fjRunI4kGgY=;
        b=XLfxXAI+Cq6PoqATbzilA7sBYh3yqL57HL2H+vki4Ss9ntA0QCakx2zgqrG9gsrbH1
         e7nZxqbbWDTDzb5NIdVXbhBfCpNxo+u+v9VwTeg8WAIRXOj8WYVCTmLI9okPFYtjXvAj
         B3acFQuy3kDkm48m3UDtpZwv8xxjjkELdelC6tSx2bcyPrFbjD2k1Ydirgd1XH1MNOXl
         2zzxJauddXJ16nyUpZcd4Uh5jDReB65sr2EzPh466puxMSfEuaUKYSurh9IsQJ8LlZxn
         suWDCPpa4j4l6aW0vfPNakyxQOJEq/D6oI2DPYd1GuTbmofpZp6d1jczNl8N4KVEk3r2
         d4Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FrcuAlouHuvEXVHFCY8oNU/dwUMLWUN3fjRunI4kGgY=;
        b=ifeoJCWjfF/IkaRZ1/BCI20R6152Ou9YUHeYdTkaIhZIdleRX7UOzwmy7h1wG8yYn1
         wLa8KZ2WaSFRA2+lpp/3Gg9xQKBnZlREbbMYdTwB6rZ83mZZI8y4PUEFH3/UYoTcPoKw
         fOuddAG1LMXCRMc7Qd6tEgeDR9+KzFHVK+EdlKkImhv/ugdjP0hLVpPBKHonRmq2Y6XN
         xQ3+DK3aSR97LPq+ejZahoTAZv3oTeTOUGAtIBVclTe9bhvUiBAmXSk8YngiJPccFm9X
         Om6PQpfgy/fnjgwWCcjZf1HEg1RJW8eX8jewKsj+H1GIy5IznGosSn1VTNRB0uy0vm6J
         LLag==
X-Gm-Message-State: ANoB5pn8kwFuuhe8kf6PtEDLo+rG8sQUhNx9qqQRLGitW08xDk61TcGf
        cpoJoX2WtDUexhTrfZSGxyoS4rqJGiGFmsj4bANQVk/trjhiBs+E4Is=
X-Google-Smtp-Source: AA0mqf5Hb76L4AZrq7W3S6g6fwGd4Gst/hppo17j8/OPbneEp1gHvb58VT1ypxKoNbM8cZg6asJO5Nm/axCoxMDRCgI=
X-Received: by 2002:a2e:a80d:0:b0:277:1295:31ca with SMTP id
 l13-20020a2ea80d000000b00277129531camr28347264ljq.280.1670424763107; Wed, 07
 Dec 2022 06:52:43 -0800 (PST)
MIME-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com> <20221202174417.1310826-26-tabba@google.com>
 <94872199-2466-756b-df4a-bbf699e40a0b@arm.com>
In-Reply-To: <94872199-2466-756b-df4a-bbf699e40a0b@arm.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Wed, 7 Dec 2022 14:52:06 +0000
Message-ID: <CA+EHjTwpmGtme1MoZFR-n86YMGmQoH8T8KkmAt9u3E2O2K9A8Q@mail.gmail.com>
Subject: Re: [RFC PATCH kvmtool v1 25/32] Allocate guest memory as restricted
 if needed
To:     Steven Price <steven.price@arm.com>
Cc:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, alexandru.elisei@arm.com,
        alex.bennee@linaro.org, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Dec 7, 2022 at 2:25 PM Steven Price <steven.price@arm.com> wrote:
>
> On 02/12/2022 17:44, Fuad Tabba wrote:
> > If specified by the option and supported by KVM, allocate guest
> > memory as restricted with the new system call.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arm/aarch64/pvtime.c |  2 +-
> >  hw/vesa.c            |  2 +-
> >  include/kvm/util.h   |  2 +-
> >  util/util.c          | 12 ++++++++----
> >  4 files changed, 11 insertions(+), 7 deletions(-)
> >
> > diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
> > index a452938..8247c52 100644
> > --- a/arm/aarch64/pvtime.c
> > +++ b/arm/aarch64/pvtime.c
> > @@ -16,7 +16,7 @@ static int pvtime__alloc_region(struct kvm *kvm)
> >       int mem_fd;
> >       int ret = 0;
> >
> > -     mem_fd = memfd_alloc(ARM_PVTIME_SIZE, false, 0);
> > +     mem_fd = memfd_alloc(kvm, ARM_PVTIME_SIZE, false, 0);
> >       if (mem_fd < 0)
> >               return -errno;
> >
> > diff --git a/hw/vesa.c b/hw/vesa.c
> > index 3233794..6c5287a 100644
> > --- a/hw/vesa.c
> > +++ b/hw/vesa.c
> > @@ -90,7 +90,7 @@ struct framebuffer *vesa__init(struct kvm *kvm)
> >       if (r < 0)
> >               goto unregister_ioport;
> >
> > -     mem_fd = memfd_alloc(ARM_PVTIME_SIZE, false, 0, 0);
> > +     mem_fd = memfd_alloc(kvm, ARM_PVTIME_SIZE, false, 0, 0);
> >       if (mem_fd < 0) {
> >               r = -errno;
> >               goto unregister_device;
> > diff --git a/include/kvm/util.h b/include/kvm/util.h
> > index 79275ed..5a98d4a 100644
> > --- a/include/kvm/util.h
> > +++ b/include/kvm/util.h
> > @@ -139,7 +139,7 @@ static inline int pow2_size(unsigned long x)
> >  }
> >
> >  struct kvm;
> > -int memfd_alloc(u64 size, bool hugetlb, u64 blk_size);
> > +int memfd_alloc(struct kvm *kvm, size_t size, bool hugetlb, u64 hugepage_size);
> >  void *mmap_anon_or_hugetlbfs_align(struct kvm *kvm, const char *hugetlbfs_path,
> >                                  u64 size, u64 align);
> >  void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size);
> > diff --git a/util/util.c b/util/util.c
> > index 107f34d..13b3e82 100644
> > --- a/util/util.c
> > +++ b/util/util.c
> > @@ -17,7 +17,7 @@
> >  __SYSCALL(__NR_memfd_restricted, sys_memfd_restricted)
> >  #endif
> >
> > -static inline int memfd_restricted(unsigned int flags)
> > +static int memfd_restricted(unsigned int flags)
> >  {
> >       return syscall(__NR_memfd_restricted, flags);
> >  }
> > @@ -106,7 +106,7 @@ static u64 get_hugepage_blk_size(const char *hugetlbfs_path)
> >       return sfs.f_bsize;
> >  }
> >
> > -int memfd_alloc(u64 size, bool hugetlb, u64 blk_size)
> > +int memfd_alloc(struct kvm *kvm, size_t size, bool hugetlb, u64 blk_size)
> >  {
> >       const char *name = "kvmtool";
> >       unsigned int flags = 0;
> > @@ -120,7 +120,11 @@ int memfd_alloc(u64 size, bool hugetlb, u64 blk_size)
> >               flags |= blk_size << MFD_HUGE_SHIFT;
> >       }
> >
> > -     fd = memfd_create(name, flags);
> > +     if (kvm->cfg.restricted_mem)
> > +             fd = memfd_restricted(flags);
> > +     else
> > +             fd = memfd_create(name, flags);
> > +
> >       if (fd < 0)
> >               die_perror("Can't memfd_create for memory map");
> >
> > @@ -167,7 +171,7 @@ void *mmap_anon_or_hugetlbfs_align(struct kvm *kvm, const char *hugetlbfs_path,
> >       if (addr_map == MAP_FAILED)
> >               return MAP_FAILED;
> >
> > -     fd = memfd_alloc(size, hugetlbfs_path, blk_size);
> > +     fd = memfd_alloc(kvm, size, hugetlbfs_path, blk_size);
> >       if (fd < 0)
> >               return MAP_FAILED;
> >
> Extra context:
> >       /* Map the allocated memory in the fd to the specified alignment. */
> >       addr_align = (void *)ALIGN((u64)addr_map, align_sz);
> >       if (mmap(addr_align, size, PROT_RW, MAP_SHARED | MAP_FIXED, fd, 0) ==
> >           MAP_FAILED) {
> >               close(fd);
> >               return MAP_FAILED;
> >       }
>
> So I don't understand how this works. My understanding is that
> memfd_restricted() returns a file descriptor that cannot be mapped in
> user space. So surely this mmap() will always fail (when
> kvm->cfg.restricted_mem)?
>
> What am I missing?

You're right for the current memfd_restricted() proposal as it is now.
However, in our discussions with the folks working on it (e.g., [1,
2]), we pointed out that for pkvm/arm64 and for Android we need to be
able to mmap shared memory for a couple of reasons (e.g., sharing in
place without copying, guest initialization). So in the pkvm/arm64
port of the memfd_restricted (which we haven't yet sent out since
everything is still in flux, but you can have a look at it here [3]), we
add the ability to mmap restricted memory but with a few restrictions,
one of them being that the memory must be shared.

Of course, we plan on submitting these patches as soon as the
memfd_restricted is in.

I hope this answers your question.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20220310140911.50924-1-chao.p.peng@linux.intel.com/
[2] https://lore.kernel.org/all/20220915142913.2213336-1-chao.p.peng@linux.intel.com/
[3] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/fdmem-v9-core
> Thanks,
>
> Steve
>
