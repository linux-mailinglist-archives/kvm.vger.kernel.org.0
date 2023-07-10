Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A85EA74E04F
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 23:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbjGJVgZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 17:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbjGJVgX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 17:36:23 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E01BE8
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 14:36:22 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-666ecb21fb8so8427485b3a.1
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 14:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689024981; x=1691616981;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/QG81dWOU8+2ZMkJte6cgGvEOzd5BwfWPVokHYZjTCI=;
        b=YVhfLbBTU4JQlqdFpX2Ac0IgNx/KSHgY/Ejx2BdoDE/MLijjJYYMBBwq6Ge8MevxjD
         EEfd4626N9pgSJJiqdeOyu1+EHmFMw8fh/GUKqiT8HvaQg6JVVwKxh1wrSdJzin4Vr/Z
         JV6Y9FF44gvlIobv+bgjxcKa2uDrZzEL293g2lXwFqZjK1zbfG4NGPMkepmdk89iC3IZ
         TU4S/lHGUj4LFO6qvZ5xNXoauDexLCzPXYDFBWH4XSfxBvpFTA65emmBgFfDntbIv3vc
         JQwRFFdb8TwKqE3lpN8gtn96Go4HkixsjBHYumLD9yaYpGrMNXgoP9XKL5KhyvIlrZ1s
         OpXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689024981; x=1691616981;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/QG81dWOU8+2ZMkJte6cgGvEOzd5BwfWPVokHYZjTCI=;
        b=iuCxg33Aw8KPYUBgtNdztVIA4cXlTd8pWKqmgkjyEltKKTW6gnD8x9z72fwxWbZtL4
         zKR2wuG6xshXNq39nXukmCCo66V8t77ORadgISCRvWaY+rEty+0jl6gpElCLcx/+EwL7
         f8rj/YzbzZ+0u4yJAm4vHHGI/lok7XW68pniX1tzNHpOezSuoCTOumXqpMH1X9/S6qGn
         l395Uj/aP+jMdz+ql+zvYL2KkQLyj2prfFd+pggTRYU+tsDGw9YnEPyQ64KeVcyfb5BF
         raxnd1QikzKVw9zuCfPabaOhrBxMvv9ROSVEXcajdSAQ8cGrE5oAz3U0ED/uCOxHIHjX
         SLBg==
X-Gm-Message-State: ABy/qLa/ETPB98lMD2BQcg1+gi3E5nUDnd3mTZd+MLL24VwsXY7SfN0i
        eq3FL6mNQAfveb+HqX3hvjU80/S4e90=
X-Google-Smtp-Source: APBJJlHIuDFrwsAjRxk1OL9H4JWUY+yazFv9EjV7KH84+DIRy01I9YCDp3Q6Nc1wAFBQaSPiE5gAOrH7j9k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2392:b0:674:1663:1283 with SMTP id
 f18-20020a056a00239200b0067416631283mr18725049pfc.1.1689024981471; Mon, 10
 Jul 2023 14:36:21 -0700 (PDT)
Date:   Mon, 10 Jul 2023 14:36:19 -0700
In-Reply-To: <20230626113540-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
References: <000000000000df3e3b05ff02fe20@google.com> <20230626031411-mutt-send-email-mst@kernel.org>
 <216718d1-1e32-9ebc-bd5e-96beab3fdc1b@oracle.com> <20230626113540-mutt-send-email-mst@kernel.org>
Message-ID: <ZKx509XelfwPIkhX@google.com>
Subject: Re: [syzbot] [net?] [virt?] [kvm?] KASAN: slab-use-after-free Read in __vhost_vq_attach_worker
From:   Sean Christopherson <seanjc@google.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Mike Christie <michael.christie@oracle.com>,
        syzbot <syzbot+8540db210d403f1aa214@syzkaller.appspotmail.com>,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 26, 2023, Michael S. Tsirkin wrote:
> On Mon, Jun 26, 2023 at 10:03:25AM -0500, Mike Christie wrote:
> > On 6/26/23 2:15 AM, Michael S. Tsirkin wrote:
> > > On Mon, Jun 26, 2023 at 12:06:54AM -0700, syzbot wrote:
> > >> Hello,
> > >>
> > >> syzbot found the following issue on:
> > >>
> > >> HEAD commit:    8d2be868b42c Add linux-next specific files for 20230623
> > >> git tree:       linux-next
> > >> console+strace: https://syzkaller.appspot.com/x/log.txt?x=12872950a80000
> > >> kernel config:  https://syzkaller.appspot.com/x/.config?x=d8ac8dd33677e8e0
> > >> dashboard link: https://syzkaller.appspot.com/bug?extid=8540db210d403f1aa214
> > >> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > >> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15c1b70f280000
> > >> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=122ee4cb280000
> > >>
> > >> Downloadable assets:
> > >> disk image: https://storage.googleapis.com/syzbot-assets/2a004483aca3/disk-8d2be868.raw.xz
> > >> vmlinux: https://storage.googleapis.com/syzbot-assets/5688cb13b277/vmlinux-8d2be868.xz
> > >> kernel image: https://storage.googleapis.com/syzbot-assets/76de0b63bc53/bzImage-8d2be868.xz
> > >>
> > >> The issue was bisected to:
> > >>
> > >> commit 21a18f4a51896fde11002165f0e7340f4131d6a0
> > >> Author: Mike Christie <michael.christie@oracle.com>
> > >> Date:   Tue Jun 13 01:32:46 2023 +0000
> > >>
> > >>     vhost: allow userspace to create workers
> > >>
> > >> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=130850bf280000
> > >> final oops:     https://syzkaller.appspot.com/x/report.txt?x=108850bf280000
> > >> console output: https://syzkaller.appspot.com/x/log.txt?x=170850bf280000
> > >>
> > >> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > >> Reported-by: syzbot+8540db210d403f1aa214@syzkaller.appspotmail.com
> > >> Fixes: 21a18f4a5189 ("vhost: allow userspace to create workers")
> > > 
> > > Mike, would appreciate prompt attention to this as I am preparing
> > > a pull request for the merge window and need to make a
> > > decision on whether to include your userspace-controlled
> > > threading patchset.
> > > 
> > 
> > Do you want me to resubmit the patchset or submit a patch against your vhost
> > branch?
> 
> Resubmit pls.

Closing this out from syzbot's perspective since v9 (now in linux-next and Linus'
tree) added back Mike's fix.

#syz invalid
