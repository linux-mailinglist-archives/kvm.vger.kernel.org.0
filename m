Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02D3C666C57
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 09:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbjALIYZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 03:24:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239553AbjALIX5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 03:23:57 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30863DE99
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 00:23:55 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id l139so17789773ybl.12
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 00:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IG/lXuBi4W6bnR7FT/EfwptVnjmC9kTL2vImM/29XUc=;
        b=BtyBdfPy7rq6ANcxjxuZcWUkW0PzQqpxPNP5gSH+U5v3D7Z8NJ2VgKNIOme6aymNP4
         2CzNQKk7aKEInGLp07mD3Vtk2QbhpvcBlgdYHlxd4PjkKDbQJIFTaWJHVFV2F5kxQwgy
         dJpBUXRjvVam0h11QcBrq1NswA/SrewqD//v9uTpdu9igB6kJJCh53F/k0puaRBEWpjA
         zoL5tsgmLasj1Wx5oqhyrxCb5J6dRQMxJLIdxbNCSjpltGSF1HqWkzDz4/biCAbxI6KK
         0cpMA4hH4qIg8PAv+rizRQlxa/zq3CpwTWma2uz+20WvBTzjHJ5cKAGn4COGOXiZRG9I
         ZItA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IG/lXuBi4W6bnR7FT/EfwptVnjmC9kTL2vImM/29XUc=;
        b=WLk8kDQdIcPFpyAPWHcfGFajVmt72/QXKRhF1JfQit/7/IsOhMdcXWyb3poMFccIEY
         Su3cqiWi3nEx3yLT+zrEwAS0bdHBNFeuLwPP4NFKS1iqtIPeUwouk6GolguSgWtCUVyb
         WqTIjFgoEGIUd4A3MdZOl1HRTKk7rQnePIG2pHKj/F/z3+HJktLt8FhJM60ccUEdSmy8
         dkvCXrCVxP3mq8ybmeJw1hdwuwppDIng0NBrrcd3p6d8bO2XLCrCOB9bDubZJTCoFoT3
         vxxyodwUfqPoyzPXqgwvqv+nyf+I1CQbOkta1eSp5DP9zGawjEy96ARTZhVW+t3Iowsx
         dqLw==
X-Gm-Message-State: AFqh2ko9KWO05kGTyZBjEqw6GCsTg26L32l5GMs5vMi+/u8J400xXHhs
        yqIHB8cjVtt7R/+HwcCxGTqr5OpKkmD9UtuTpjyw8Q==
X-Google-Smtp-Source: AMrXdXsmmJiY8FKovMiOWbRsrx15VJu0Wp4I8ApmSa2FHOQC74u6+SLogHjTvt9IVADl1tflz7b8tjYRtMbQWKhszPU=
X-Received: by 2002:a25:eb0b:0:b0:73e:1951:3e92 with SMTP id
 d11-20020a25eb0b000000b0073e19513e92mr2672672ybs.388.1673511834231; Thu, 12
 Jan 2023 00:23:54 -0800 (PST)
MIME-Version: 1.0
References: <b8017e09-f336-3035-8344-c549086c2340@kernel.org> <CAKbZUD0Tqct_G9OcO8ocdH1J_YvLSEod-ofr97hsyoHgcvBwuw@mail.gmail.com>
In-Reply-To: <CAKbZUD0Tqct_G9OcO8ocdH1J_YvLSEod-ofr97hsyoHgcvBwuw@mail.gmail.com>
From:   Yu Zhao <yuzhao@google.com>
Date:   Thu, 12 Jan 2023 01:23:17 -0700
Message-ID: <CAOUHufapeXp_EFC2L5TFhLcVD95Wap2Zir8zHOEsANLV5CLdXQ@mail.gmail.com>
Subject: Re: Stalls in qemu with host running 6.1 (everything stuck at mmap_read_lock())
To:     Pedro Falcato <pedro.falcato@gmail.com>,
        Liam Howlett <liam.howlett@oracle.com>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        mm <linux-mm@kvack.org>, Michal Hocko <MHocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>, shy828301@gmail.com
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

On Wed, Jan 11, 2023 at 5:37 PM Pedro Falcato <pedro.falcato@gmail.com> wrote:
>
> On Wed, Jan 11, 2023 at 8:00 AM Jiri Slaby <jirislaby@kernel.org> wrote:
> >
> > Hi,
> >
> > after I updated the host from 6.0 to 6.1 (being at 6.1.4 ATM), my qemu
> > VMs started stalling (and the host at the same point too). It doesn't
> > happen right after boot, maybe a suspend-resume cycle is needed (or
> > longer uptime, or a couple of qemu VM starts, or ...). But when it
> > happens, it happens all the time till the next reboot.
> >
> > Older guest's kernels/distros are affected as well as Win10.
> >
> > In guests, I see for example stalls in memset_orig or
> > smp_call_function_many_cond -- traces below.
> >
> > qemu-kvm-7.1.0-13.34.x86_64 from openSUSE.
> >
> > It's quite interesting that:
> >    $ cat /proc/<PID_OF_QEMU>/cmdline
> > is stuck at read:
> >
> > openat(AT_FDCWD, "/proc/12239/cmdline", O_RDONLY) = 3
> > newfstatat(3, "", {st_mode=S_IFREG|0444, st_size=0, ...}, AT_EMPTY_PATH) = 0
> > fadvise64(3, 0, 0, POSIX_FADV_SEQUENTIAL) = 0
> > mmap(NULL, 139264, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
> > 0) = 0x7f22f0487000
> > read(3, ^C^C^C^\^C
> >
> > too. So I dumped blocked tasks (sysrq-w) on _host_ (see below) and
> > everything seems to stall on mmap_read_lock() or
> > mmap_write_lock_killable(). I don't see the hog (the one actually
> > _having_ and sitting on the (presumably write) lock) in the dump though.
> > I will perhaps boot a LOCKDEP-enabled kernel, so that I can do sysrq-d
> > next time and see the holder.
> >
> >
> > There should be enough free memory (note caches at 8G):
> >                 total        used        free      shared  buff/cache
> > available
> > Mem:            15Gi        10Gi       400Mi       2,5Gi       8,0Gi
> >    5,0Gi
> > Swap:             0B          0B          0B
> >
> >
> > I rmmoded kvm-intel now, so:
> >    qemu-kvm: failed to initialize kvm: No such file or directory
> >    qemu-kvm: falling back to tcg
> > and it behaves the same (more or less expected).
> >
> > Is this known? Any idea how to debug this? Or maybe someone (I CCed a
> > couple of guys who Acked mmap_*_lock() shuffling patches in 6.1) has a
> > clue? Bisection is hard as it reproduces only under certain unknown
> > circumstances.
>
> Hi,
>
> I just want to chime in and say that I've also hit this regression
> right as I (Arch) updated to 6.1 a few weeks ago.
> This completely ruined my qemu workflow such that I had to fallback to
> using an LTS kernel.
>
> Some data I've gathered:
> 1) It seems to not happen right after booting - I'm unsure if this is
> due to memory pressure or less CPU load or any other factor
> 2) It seems to intensify after swapping a fair amount? At least this
> has been my experience.
> 3) The largest slowdown seems to be when qemu is booting the guest,
> possibly during heavy memory allocation - problems range from "takes
> tens of seconds to boot" to "qemu is completely blocked and needs a
> SIGKILL spam".
> 4) While traditional process monitoring tools break (likely due to
> mmap_lock getting hogged), I can (empirically, using /bin/free) tell
> that the system seems to be swapping in/out quite a fair bit
>
> My 4) is particularly confusing to me as I had originally blamed the
> problem on the MGLRU changes, while you don't seem to be swapping at
> all.
> Could this be related to the maple tree patches? Should we CC both the
> MGLRU folks and the maple folks?

I don't think it's MGLRU because the way it uses mmap_lock is very
simple. Also you could prevent MGLRU from taking mmap_lock by echo 3
>/sys/kernel/mm/lru_gen/enabled, or you could disable MGLRU entirely
by echoing 0 to the same file, or even at build time, to rule it out.
(I assume you
turned on MGLRU in the first place.)

Adding Liam. He can speak for the maple tree.
