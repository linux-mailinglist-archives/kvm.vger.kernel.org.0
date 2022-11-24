Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7DCC6376BD
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 11:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiKXKqf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 05:46:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiKXKqe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 05:46:34 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD7E1647A9
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 02:46:32 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id l8so1516090ljh.13
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 02:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=s+w+SSu6ruohPKi3iDrHcLMbxnADfpb5JNjNHfNstyo=;
        b=R4ScJtaHpL0LU0VYNO5DZeOThonFO3WppgEQtMmFjrP899UKRSEK6Yt3rCEXwOwTvb
         TkptmmDz2xzDHkzDDWjGNYMRadYw4edxb2ecC3SICBVpPmCIsqocP2psN1axt/lC0wdu
         cRg3WVQenPUZ3LB9J3SjLjiHFDvc2U/yqVQY47E4c1yHciA3WO6PxVrONIRrUQB8imuR
         nZqFQoCI+m5ruM2SLIW6cI/8wzrhEHU/3q+n8TIBV+YAr2xXCw5v531hDvk/ZR9FvXOc
         KI5JxUyXUdRvzUNAY/hBbxRWzXWytUGvFg50P29BXYSplLJ3zHkFSd4lcQ6gHAjgo7W8
         9wjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s+w+SSu6ruohPKi3iDrHcLMbxnADfpb5JNjNHfNstyo=;
        b=Eturi9iVxnfx5rzRAt0p/JJiqv4pGAOqv+yswC/hxamRU8bigDNKKgkR+QTRmfaiHB
         inEjE/UD0kGKgulq4GRsLyRd45idPR/bb3CXe+ChQfPrdyzSWDDJdBXlPbhmrzI/hmuu
         PBkzknG6Z02mmLh8BqJ7dJyjfI3/cFDDe94QeCg3BlaUrT8QVRXk1RF4IXDcXwIkuZSG
         sQJdxPUHwBnNMe4VCCn9895nXzBUEMisATW9eiFuD97aIjPPNqMOLA159lRjLKahSmjw
         9OaZyloo63vXl/fKlRiXkk85fH8Pe2pRxu1/mGs+WyVHk1nduXFBunbitNeAIDkCblu+
         LH9w==
X-Gm-Message-State: ANoB5pkHoCEHoqXrn3CWcIE2+obIaGk60CcuBN4zc/C3VsdZcXpDiVNl
        KtgTUja2c2SByOh8c4mxyK/8T9dQh7CgAqwHMFUxKw==
X-Google-Smtp-Source: AA0mqf77lcN3Xlq8ttWwfUKcgEWZLHpZJ5G6fZK2G1Di9iIrW775E2ji/o0G4XOhL1XfFlFxwvhJ25SAKLKJnlnT8Is=
X-Received: by 2002:a05:651c:c99:b0:277:2b10:bf60 with SMTP id
 bz25-20020a05651c0c9900b002772b10bf60mr11075706ljb.159.1669286791064; Thu, 24
 Nov 2022 02:46:31 -0800 (PST)
MIME-Version: 1.0
References: <20221115111549.2784927-1-tabba@google.com> <20221115111549.2784927-7-tabba@google.com>
 <Y39FIxcUhvdNGNfJ@monolith.localdoman>
In-Reply-To: <Y39FIxcUhvdNGNfJ@monolith.localdoman>
From:   Fuad Tabba <tabba@google.com>
Date:   Thu, 24 Nov 2022 10:45:54 +0000
Message-ID: <CA+EHjTx7szza5DQa449_SNN+WLzDy13uss8RQqiRqeuzukOGKQ@mail.gmail.com>
Subject: Re: [PATCH kvmtool v1 06/17] Use memfd for hugetlbfs when allocating
 guest ram
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, will@kernel.org
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

On Thu, Nov 24, 2022 at 10:19 AM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi,
>
> On Tue, Nov 15, 2022 at 11:15:38AM +0000, Fuad Tabba wrote:
> > This removes the need of using a temporary file for the fd.
>
> I'm confused by this. The man page for memfd_create says that it creates an
> anonymous file that lives in RAM.

I'm referring for the need to create a temporary file in the hugetlbfs path.

>
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  util/util.c | 25 ++++++++++++++++++++-----
> >  1 file changed, 20 insertions(+), 5 deletions(-)
> >
> > diff --git a/util/util.c b/util/util.c
> > index e6c0951..d6ceb5d 100644
> > --- a/util/util.c
> > +++ b/util/util.c
> > @@ -10,6 +10,14 @@
> >  #include <sys/stat.h>
> >  #include <sys/statfs.h>
> >
> > +#ifndef MFD_HUGETLB
> > +#define MFD_HUGETLB  0x0004U
> > +#endif
> > +
> > +#ifndef MFD_HUGE_SHIFT
> > +#define MFD_HUGE_SHIFT       26
> > +#endif
>
> Hm... on my machine these are defined in linux/memfd.h, maybe you are
> missing the include?

Ack. I'll replace them with the include.

>
> > +
> >  static void report(const char *prefix, const char *err, va_list params)
> >  {
> >       char msg[1024];
> > @@ -96,10 +104,12 @@ static u64 get_hugepage_blk_size(const char *htlbfs_path)
> >
> >  static void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
> >  {
> > -     char mpath[PATH_MAX];
> > +     const char *name = "kvmtool";
> > +     unsigned int flags = 0;
> >       int fd;
> >       void *addr;
> >       u64 blk_size;
> > +     int htsize;
> >
> >       blk_size = get_hugepage_blk_size(htlbfs_path);
> >       if (blk_size == 0 || blk_size > size) {
> > @@ -107,13 +117,18 @@ static void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
> >                       (unsigned long long)blk_size, (unsigned long long)size);
> >       }
> >
> > +     htsize = __builtin_ctzl(blk_size);
> > +     if ((1ULL << htsize) != blk_size)
> > +             die("Hugepage size must be a power of 2.\n");
> > +
> > +     flags |= MFD_HUGETLB;
> > +     flags |= htsize << MFD_HUGE_SHIFT;
>
> If I understand the intention correctly, this entire sequence can be
> rewritten using is_power_of_two() from util.h:
>
>         if (!is_power_of_two(blk_size))
>                 die("Hugepage size must be a power of 2");

This is simpler, yes.

>
> Also, die() automatically adds the newline at the end of the string.
> That's unless you specifically wanted two newline characters at the end of
> the message.

Ack.

>
> > +
> >       kvm->ram_pagesize = blk_size;
> >
> > -     snprintf(mpath, PATH_MAX, "%s/kvmtoolXXXXXX", htlbfs_path);
> > -     fd = mkstemp(mpath);
> > +     fd = memfd_create(name, flags);
> >       if (fd < 0)
> > -             die("Can't open %s for hugetlbfs map\n", mpath);
> > -     unlink(mpath);
> > +             die("Can't memfd_create for hugetlbfs map\n");
>
> die_perror("memfd_create")? That way you also print the error number and
> the message associated with it. Same thing with the other die statements
> here, replacing them with die_perror() looks like it would be helpful.

Will do.

Cheers,
/fuad

>
> Thanks,
> Alex
>
> >       if (ftruncate(fd, size) < 0)
> >               die("Can't ftruncate for mem mapping size %lld\n",
> >                       (unsigned long long)size);
> > --
> > 2.38.1.431.g37b22c650d-goog
> >
