Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404D4645DA8
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 16:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiLGPb2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 10:31:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiLGPbZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 10:31:25 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC895C0D0
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 07:31:23 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id x11so21298444ljh.7
        for <kvm@vger.kernel.org>; Wed, 07 Dec 2022 07:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J1rGAY9HSPcas/OkUZjLyzEB6I7Hg6c2WCXOiacVvP8=;
        b=JNwVO6orYg1tIbTlftX1bqUOEWcULPIUBRywby0QeEXqPikOP63dfzQqnIyXYBjLUY
         9JU0o3kPsX1nTg7uES5BoR+rPaIo/TcuZhZ08LF3/vLmOUs3Ss5vJuAG3/bRPkCkKB8N
         BmKyvZ/jrPM2T8LX6bGRoZV7a72IUrzKrDbu8sTsrO4Bb4yBq2ft9zpnAgkAv3/FVEJj
         Q+LUidqrAfzBCGQQKH/m0yfY4WBzpbEryI8qv6Ht/h29TfUjyDz3L3ENREojPbe1R/UO
         XpqM1yzPWO9/065X+slhHrQYv33sXJ+YxKG5+YsI8iEd4VuEQzGeTCIxeJavrRtfLdZf
         PYbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J1rGAY9HSPcas/OkUZjLyzEB6I7Hg6c2WCXOiacVvP8=;
        b=oseOdCP4qj+rW53u7e2696hI9b1d/9ne6/wMzhvJb/igFyD7dOFaZraZvi3OktolMH
         +PSKR2df47VGEpLzVj8wS+Shry39A7mJzs3ByhYBKFZVFEaiv/hXOKZz6y8tOHeCsndP
         4Z6bAK1h69HdI+ozWaxSNuUiwEIOsbNrKTZo+KkGXtaQQ4cFR0igVcI0k1mmqMnt+G+y
         9sfGDCzPnj0y2rAMvd1zKIJelzhHTR95/k4qXf/sfwovBhg7BEuhiJGoDDZ7ObcjfE2g
         kxNsiw66jE54pYI/baAigvaMGBb/VQEjPmEBtFAiO0Z3tNOobN/vkuIUkqt59UKgd9Pe
         UYiw==
X-Gm-Message-State: ANoB5pmWrmJ9ApfWTYKl/5ed3VugnfQFtv4CjHXuyE3iI+gUnxYlA54Q
        ivzNXt/t/3YLl4xwzoRv+1QfSy8s7iUl5VuraDnjLw==
X-Google-Smtp-Source: AA0mqf7fKPqCTSQYEhiQ3KO6wSwDrVKrIr9pFQn3TazdHCGL9cJeV2A4KQxat3EOBYvKtdAFwLa+/n5kJlz1GpVYTEI=
X-Received: by 2002:a2e:a544:0:b0:278:f5b8:82c8 with SMTP id
 e4-20020a2ea544000000b00278f5b882c8mr24470369ljn.228.1670427081654; Wed, 07
 Dec 2022 07:31:21 -0800 (PST)
MIME-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com> <20221202174417.1310826-26-tabba@google.com>
 <94872199-2466-756b-df4a-bbf699e40a0b@arm.com> <CA+EHjTwpmGtme1MoZFR-n86YMGmQoH8T8KkmAt9u3E2O2K9A8Q@mail.gmail.com>
 <612f4925-7a69-2d21-50f8-091a2295a2ff@arm.com>
In-Reply-To: <612f4925-7a69-2d21-50f8-091a2295a2ff@arm.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Wed, 7 Dec 2022 15:30:45 +0000
Message-ID: <CA+EHjTw0gxHMcsahsrRmR+2nwbov8JCfo=JrYVBvSSTuxHgeAw@mail.gmail.com>
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

On Wed, Dec 7, 2022 at 3:09 PM Steven Price <steven.price@arm.com> wrote:
>
> On 07/12/2022 14:52, Fuad Tabba wrote:
> > Hi,
> >
> > On Wed, Dec 7, 2022 at 2:25 PM Steven Price <steven.price@arm.com> wrote:
> >>
> >> On 02/12/2022 17:44, Fuad Tabba wrote:
> >>> If specified by the option and supported by KVM, allocate guest
> >>> memory as restricted with the new system call.
> >>>
> >>> Signed-off-by: Fuad Tabba <tabba@google.com>
> >>> ---
> >>>  arm/aarch64/pvtime.c |  2 +-
> >>>  hw/vesa.c            |  2 +-
> >>>  include/kvm/util.h   |  2 +-
> >>>  util/util.c          | 12 ++++++++----
> >>>  4 files changed, 11 insertions(+), 7 deletions(-)
> >>>
> >>> diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
> >>> index a452938..8247c52 100644
> >>> --- a/arm/aarch64/pvtime.c
> >>> +++ b/arm/aarch64/pvtime.c
> >>> @@ -16,7 +16,7 @@ static int pvtime__alloc_region(struct kvm *kvm)
> >>>       int mem_fd;
> >>>       int ret = 0;
> >>>
> >>> -     mem_fd = memfd_alloc(ARM_PVTIME_SIZE, false, 0);
> >>> +     mem_fd = memfd_alloc(kvm, ARM_PVTIME_SIZE, false, 0);
> >>>       if (mem_fd < 0)
> >>>               return -errno;
> >>>
> >>> diff --git a/hw/vesa.c b/hw/vesa.c
> >>> index 3233794..6c5287a 100644
> >>> --- a/hw/vesa.c
> >>> +++ b/hw/vesa.c
> >>> @@ -90,7 +90,7 @@ struct framebuffer *vesa__init(struct kvm *kvm)
> >>>       if (r < 0)
> >>>               goto unregister_ioport;
> >>>
> >>> -     mem_fd = memfd_alloc(ARM_PVTIME_SIZE, false, 0, 0);
> >>> +     mem_fd = memfd_alloc(kvm, ARM_PVTIME_SIZE, false, 0, 0);
> >>>       if (mem_fd < 0) {
> >>>               r = -errno;
> >>>               goto unregister_device;
> >>> diff --git a/include/kvm/util.h b/include/kvm/util.h
> >>> index 79275ed..5a98d4a 100644
> >>> --- a/include/kvm/util.h
> >>> +++ b/include/kvm/util.h
> >>> @@ -139,7 +139,7 @@ static inline int pow2_size(unsigned long x)
> >>>  }
> >>>
> >>>  struct kvm;
> >>> -int memfd_alloc(u64 size, bool hugetlb, u64 blk_size);
> >>> +int memfd_alloc(struct kvm *kvm, size_t size, bool hugetlb, u64 hugepage_size);
> >>>  void *mmap_anon_or_hugetlbfs_align(struct kvm *kvm, const char *hugetlbfs_path,
> >>>                                  u64 size, u64 align);
> >>>  void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size);
> >>> diff --git a/util/util.c b/util/util.c
> >>> index 107f34d..13b3e82 100644
> >>> --- a/util/util.c
> >>> +++ b/util/util.c
> >>> @@ -17,7 +17,7 @@
> >>>  __SYSCALL(__NR_memfd_restricted, sys_memfd_restricted)
> >>>  #endif
> >>>
> >>> -static inline int memfd_restricted(unsigned int flags)
> >>> +static int memfd_restricted(unsigned int flags)
> >>>  {
> >>>       return syscall(__NR_memfd_restricted, flags);
> >>>  }
> >>> @@ -106,7 +106,7 @@ static u64 get_hugepage_blk_size(const char *hugetlbfs_path)
> >>>       return sfs.f_bsize;
> >>>  }
> >>>
> >>> -int memfd_alloc(u64 size, bool hugetlb, u64 blk_size)
> >>> +int memfd_alloc(struct kvm *kvm, size_t size, bool hugetlb, u64 blk_size)
> >>>  {
> >>>       const char *name = "kvmtool";
> >>>       unsigned int flags = 0;
> >>> @@ -120,7 +120,11 @@ int memfd_alloc(u64 size, bool hugetlb, u64 blk_size)
> >>>               flags |= blk_size << MFD_HUGE_SHIFT;
> >>>       }
> >>>
> >>> -     fd = memfd_create(name, flags);
> >>> +     if (kvm->cfg.restricted_mem)
> >>> +             fd = memfd_restricted(flags);
> >>> +     else
> >>> +             fd = memfd_create(name, flags);
> >>> +
> >>>       if (fd < 0)
> >>>               die_perror("Can't memfd_create for memory map");
> >>>
> >>> @@ -167,7 +171,7 @@ void *mmap_anon_or_hugetlbfs_align(struct kvm *kvm, const char *hugetlbfs_path,
> >>>       if (addr_map == MAP_FAILED)
> >>>               return MAP_FAILED;
> >>>
> >>> -     fd = memfd_alloc(size, hugetlbfs_path, blk_size);
> >>> +     fd = memfd_alloc(kvm, size, hugetlbfs_path, blk_size);
> >>>       if (fd < 0)
> >>>               return MAP_FAILED;
> >>>
> >> Extra context:
> >>>       /* Map the allocated memory in the fd to the specified alignment. */
> >>>       addr_align = (void *)ALIGN((u64)addr_map, align_sz);
> >>>       if (mmap(addr_align, size, PROT_RW, MAP_SHARED | MAP_FIXED, fd, 0) ==
> >>>           MAP_FAILED) {
> >>>               close(fd);
> >>>               return MAP_FAILED;
> >>>       }
> >>
> >> So I don't understand how this works. My understanding is that
> >> memfd_restricted() returns a file descriptor that cannot be mapped in
> >> user space. So surely this mmap() will always fail (when
> >> kvm->cfg.restricted_mem)?
> >>
> >> What am I missing?
> >
> > You're right for the current memfd_restricted() proposal as it is now.
> > However, in our discussions with the folks working on it (e.g., [1,
> > 2]), we pointed out that for pkvm/arm64 and for Android we need to be
> > able to mmap shared memory for a couple of reasons (e.g., sharing in
> > place without copying, guest initialization). So in the pkvm/arm64
> > port of the memfd_restricted (which we haven't yet sent out since
> > everything is still in flux, but you can have a look at it here [3]), we
> > add the ability to mmap restricted memory but with a few restrictions,
> > one of them being that the memory must be shared.
>
> Ah, ok. I'm not sure if that works for TDX or not, my understanding was
> they couldn't have a user space mapping, but I'll let others familiar
> with TDX comment on that.

My understanding of TDX is quite limited, and that's one of the
reasons I didn't even try to implement the x86 arch-specific part in
this series.

> For Arm CCA we need to ensure that the kernel doesn't create mappings:
> your tree seems to include changes to block GUP so that should work.
> Accesses from the VMM are not permitted but can be handled 'gracefully'
> by killing off the VMM - so the mappings are not necessarily a problem,
> although they do provide a significant "foot gun" to the VMM.

You're right that it includes changes to block gup, since the same
problems you've mentioned apply to pKVM.

> We still have open questions about our UABI so it would be good to have
> a discussion about how to align pKVM and Arm CCA.

Sounds good.

> > Of course, we plan on submitting these patches as soon as the
> > memfd_restricted is in.
> >
> > I hope this answers your question.
>
> Yes thanks, I hadn't realised from your cover letter you had changes to
> memfd_restricted() on top of Chao's series.

I just realized that that's my fault. I'd posted the wrong link in the
cover letter.

Cheers,
/fuad


> Thanks,
>
> Steve
>
> >
> > Cheers,
> > /fuad
> >
> > [1] https://lore.kernel.org/all/20220310140911.50924-1-chao.p.peng@linux.intel.com/
> > [2] https://lore.kernel.org/all/20220915142913.2213336-1-chao.p.peng@linux.intel.com/
> > [3] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/fdmem-v9-core
> >> Thanks,
> >>
> >> Steve
> >>
>
