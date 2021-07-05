Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179693BBC63
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 13:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbhGELuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 07:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbhGELuW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jul 2021 07:50:22 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EBDC061574
        for <kvm@vger.kernel.org>; Mon,  5 Jul 2021 04:47:44 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id x24so2230675qts.11
        for <kvm@vger.kernel.org>; Mon, 05 Jul 2021 04:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2anXc9o1J5CUj8jZ7vD+flFV6tAYlW07LvmjqUmo+tI=;
        b=oxBNCd9Z7tczjNhggQLh1dJeHudhfX2gRTQ8wDfrhGLFD0rWLTz17tCZHuyEXiaOKY
         mV/71KSXIKh0Ix007SELqjmbtfIE6GumGUOFFS4rITFAx2a1l+2afvUiK0mK10flTjla
         tHvrupXy90S/hoD/eaatukQegq06J0gcsEaLn+C6PcI6qW4gebM13Z5b3zsX8HWZSr+y
         Fem1uNfSMB/ftuT3uGabU+vw2I+jE2to+2tVq6REqGfzUCaFJjut7w2pMLGGYES7ElP9
         XXRfg2PwFy2BOFmkKYjb394ND5hZV70MiX+bPzydnDGQ3s9pSxczREa4AA0tXwgHY8kx
         KxUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2anXc9o1J5CUj8jZ7vD+flFV6tAYlW07LvmjqUmo+tI=;
        b=VhhIY+9Hg1YFO2VmsFKcwltQTZE3hnxPRqohAeHSGEB1YDb6XtyWLa5yiweT178Bk5
         lpmB6kcnpzbrmQ22nVeFgqMns+wS+v+c8CKU9fr1XfvubQ5geBitu5npcG4VED9ZrbCC
         y6KNlTUO4bGTKKQIukig7lM8w2veNqIG02Sj6g19zXWlWjUM+NBmgZXmO+heUwbkXd/+
         6gJ7brtRk0VdlWXs4nY00W1yjSRvMvPQ97er0TMQW0CD3yaV3QSh7Sx8yuZWdABKSLrv
         nECau7orzf0iUJ8K/d0WuQ6h20J1LYFqXgCJ3vpwxRMHcTBNDJj8WBT+0CCUyKIjh6Zz
         53Ow==
X-Gm-Message-State: AOAM531nkoqNS40MfQ3nzZ27u6PGyU50WOdnuDfS9D9mSRWoe/Hj12qC
        3yf/u3t92XQO4pvkcQ0tVe3jJNtvA4LCIeMipZMs3g==
X-Google-Smtp-Source: ABdhPJyHoyhfKlNbJ2OsQycTXwCVU8GNncHeEg3OytdDPbIjB4lfgNxZkC9kiRwZKQa/qKaVC/xOeHXux5M2duVYUe4=
X-Received: by 2002:ac8:60ca:: with SMTP id i10mr9991952qtm.43.1625485662468;
 Mon, 05 Jul 2021 04:47:42 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000bfb6cf05c631db0b@google.com> <20210703101243.45cbf143@gmail.com>
 <CACT4Y+Yk5v3=2V_t77RSqACNYQb6PmDM0Mst6N1QEgz9CdYrqw@mail.gmail.com> <20210705143652.56b3d68b@gmail.com>
In-Reply-To: <20210705143652.56b3d68b@gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 5 Jul 2021 13:47:30 +0200
Message-ID: <CACT4Y+aeiQ9=p6esuAseErekJnLzxFL1eG7qpWehZHUfb8UoNw@mail.gmail.com>
Subject: Re: [syzbot] memory leak in kvm_dev_ioctl
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     syzbot <syzbot+c87d2efb740931ec76c7@syzkaller.appspotmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 5, 2021 at 1:36 PM Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> On Mon, 5 Jul 2021 07:54:59 +0200
> Dmitry Vyukov <dvyukov@google.com> wrote:
>
> > On Sat, Jul 3, 2021 at 9:12 AM Pavel Skripkin <paskripkin@gmail.com>
> > wrote:
> > >
> > > On Fri, 02 Jul 2021 23:05:26 -0700
> > > syzbot <syzbot+c87d2efb740931ec76c7@syzkaller.appspotmail.com>
> > > wrote:
> > >
> > > > Hello,
> > > >
> > > > syzbot found the following issue on:
> > > >
> > > > HEAD commit:    e058a84b Merge tag 'drm-next-2021-07-01' of
> > > > git://anongit... git tree:       upstream
> > > > console output:
> > > > https://syzkaller.appspot.com/x/log.txt?x=171fbbdc300000 kernel
> > > > config:
> > > > https://syzkaller.appspot.com/x/.config?x=8c46abb9076f44dc
> > > > dashboard link:
> > > > https://syzkaller.appspot.com/bug?extid=c87d2efb740931ec76c7 syz
> > > > repro: https://syzkaller.appspot.com/x/repro.syz?x=119d1efc300000
> > > > C reproducer:
> > > > https://syzkaller.appspot.com/x/repro.c?x=16c58c28300000
> > > >
> > > > IMPORTANT: if you fix the issue, please add the following tag to
> > > > the commit: Reported-by:
> > > > syzbot+c87d2efb740931ec76c7@syzkaller.appspotmail.com
> > > >
> > >
> > > Corresponding fix was sent about 2 days ago
> > > https://patchwork.kernel.org/project/kvm/patch/20210701195500.27097-1-paskripkin@gmail.com/
> >
> > Hi Pavel,
> >
> > Thanks for checking. Let's tell syzbot about the fix:
> >
> > #syz fix: kvm: debugfs: fix memory leak in kvm_create_vm_debugfs
>
>
> Hi, Dmitry!
>
> Sorry for stupid question :)
>
> I don't see, that my patch was applied, so syzbot will save the patch
> name and will test it after it will be applied? I thought about
> sending `syz fix` command, but I was sure that syzbot takes only
> accepted patches.

Hi Pavel,

Please see if http://bit.do/syzbot#communication-with-syzbot answers
your questions.
