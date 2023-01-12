Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED176667E9
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 01:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbjALAjI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 19:39:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235842AbjALAiG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 19:38:06 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A78B7D7
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 16:37:45 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id s13-20020a17090a6e4d00b0022900843652so315907pjm.1
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 16:37:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QQybfljezbpjIcQRaMgbBWNLNDOtaKJdBbtvg7KxLWk=;
        b=no4xU7lPmNdhM4MBL45sxx8uEKJqgJvK0SjWs+YGXd4+QOs13UkfmkhYsdc1N/37BS
         3Gc8MMszYNk0J+fV9azvfIPMWTVv7VdpbeicGq5EeN7IH9O7ZR9zMaqvybkx1VNaYs8/
         kRiu814Oq7XT5a+M3LYefHbOW4/g02CrtvH1iz3wlTCTy+iDppnl+p2HCC6AQPWdfxJ4
         6Dkuk0LyIXh1P5QXnHp9lxqfJk5vf5JOGQhn55BZY/dFssUSbZh+mxl/6ZdUSQMisaQK
         7LRNOHeX24s84WfoTS0ng9QIDP/+NGevZXwOc8IexKRosYviLH4zR7mfRi+MjBkd4Uuf
         kUfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QQybfljezbpjIcQRaMgbBWNLNDOtaKJdBbtvg7KxLWk=;
        b=MadYLhab5z8Mimdw+HcnBdag+LF3v//xj3QZiS48ETjXKj40TvorKZx1Z+axBmFzTr
         xh4L63JNf42zoijMt04sUsfZarSCO+QMGYu5v5Dxh9Hj7XmOS5IPxlXu0NMpsFawjk3o
         ud8S704NsWTzZXYWcZFMWNi7IFXHPIy1OZicwBfQCX6t36U3IOW+NQCrHWud+7jzyM7N
         Zh4tyD/JO5UcEV1bPy9GUSzsV0XIW7KZw2YREnxWgpVgHRI680ueTlS0dAxZYOeZZWfq
         kazohGw3N9ukE1hOYr1Ti6EXweAmuPyFWkj2hnSoFC33HIXHLmQPGyKIBk1JLztAGYLo
         yWmw==
X-Gm-Message-State: AFqh2kofvzt2SA6IgI/wiAbRse9j0ePAFuTJsXATUIfgET7oiHLltzto
        ZU13LabmxPHuMCRzeeOwdgfDmwFVMHPqmyhGLiI=
X-Google-Smtp-Source: AMrXdXuWTqAVKsjvBH4EEfHmlpip/wyOtf6jzZQXPy7wmiNV/CoqJv4iqzhnnrvHL5ak0LfiwLU7m1Kuxkq4+JCc++U=
X-Received: by 2002:a17:90b:2398:b0:226:fe58:d60a with SMTP id
 mr24-20020a17090b239800b00226fe58d60amr1887377pjb.225.1673483864950; Wed, 11
 Jan 2023 16:37:44 -0800 (PST)
MIME-Version: 1.0
References: <b8017e09-f336-3035-8344-c549086c2340@kernel.org>
In-Reply-To: <b8017e09-f336-3035-8344-c549086c2340@kernel.org>
From:   Pedro Falcato <pedro.falcato@gmail.com>
Date:   Thu, 12 Jan 2023 00:37:33 +0000
Message-ID: <CAKbZUD0Tqct_G9OcO8ocdH1J_YvLSEod-ofr97hsyoHgcvBwuw@mail.gmail.com>
Subject: Re: Stalls in qemu with host running 6.1 (everything stuck at mmap_read_lock())
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        mm <linux-mm@kvack.org>, yuzhao@google.com,
        Michal Hocko <MHocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>, shy828301@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 11, 2023 at 8:00 AM Jiri Slaby <jirislaby@kernel.org> wrote:
>
> Hi,
>
> after I updated the host from 6.0 to 6.1 (being at 6.1.4 ATM), my qemu
> VMs started stalling (and the host at the same point too). It doesn't
> happen right after boot, maybe a suspend-resume cycle is needed (or
> longer uptime, or a couple of qemu VM starts, or ...). But when it
> happens, it happens all the time till the next reboot.
>
> Older guest's kernels/distros are affected as well as Win10.
>
> In guests, I see for example stalls in memset_orig or
> smp_call_function_many_cond -- traces below.
>
> qemu-kvm-7.1.0-13.34.x86_64 from openSUSE.
>
> It's quite interesting that:
>    $ cat /proc/<PID_OF_QEMU>/cmdline
> is stuck at read:
>
> openat(AT_FDCWD, "/proc/12239/cmdline", O_RDONLY) = 3
> newfstatat(3, "", {st_mode=S_IFREG|0444, st_size=0, ...}, AT_EMPTY_PATH) = 0
> fadvise64(3, 0, 0, POSIX_FADV_SEQUENTIAL) = 0
> mmap(NULL, 139264, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
> 0) = 0x7f22f0487000
> read(3, ^C^C^C^\^C
>
> too. So I dumped blocked tasks (sysrq-w) on _host_ (see below) and
> everything seems to stall on mmap_read_lock() or
> mmap_write_lock_killable(). I don't see the hog (the one actually
> _having_ and sitting on the (presumably write) lock) in the dump though.
> I will perhaps boot a LOCKDEP-enabled kernel, so that I can do sysrq-d
> next time and see the holder.
>
>
> There should be enough free memory (note caches at 8G):
>                 total        used        free      shared  buff/cache
> available
> Mem:            15Gi        10Gi       400Mi       2,5Gi       8,0Gi
>    5,0Gi
> Swap:             0B          0B          0B
>
>
> I rmmoded kvm-intel now, so:
>    qemu-kvm: failed to initialize kvm: No such file or directory
>    qemu-kvm: falling back to tcg
> and it behaves the same (more or less expected).
>
> Is this known? Any idea how to debug this? Or maybe someone (I CCed a
> couple of guys who Acked mmap_*_lock() shuffling patches in 6.1) has a
> clue? Bisection is hard as it reproduces only under certain unknown
> circumstances.

Hi,

I just want to chime in and say that I've also hit this regression
right as I (Arch) updated to 6.1 a few weeks ago.
This completely ruined my qemu workflow such that I had to fallback to
using an LTS kernel.

Some data I've gathered:
1) It seems to not happen right after booting - I'm unsure if this is
due to memory pressure or less CPU load or any other factor
2) It seems to intensify after swapping a fair amount? At least this
has been my experience.
3) The largest slowdown seems to be when qemu is booting the guest,
possibly during heavy memory allocation - problems range from "takes
tens of seconds to boot" to "qemu is completely blocked and needs a
SIGKILL spam".
4) While traditional process monitoring tools break (likely due to
mmap_lock getting hogged), I can (empirically, using /bin/free) tell
that the system seems to be swapping in/out quite a fair bit

My 4) is particularly confusing to me as I had originally blamed the
problem on the MGLRU changes, while you don't seem to be swapping at
all.
Could this be related to the maple tree patches? Should we CC both the
MGLRU folks and the maple folks?

I have little insight into what the kernel's state actually is apart
from this - perf seems to break, and I have no kernel debugger as this
is my live personal machine :/
I would love it if someone hinted to possible things I/we could try in
order to track this down. Is this not git-bisectable at all?

Thanks,
Pedro
