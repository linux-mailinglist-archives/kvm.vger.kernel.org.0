Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734E562A27B
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 21:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbiKOUHr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 15:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiKOUHp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 15:07:45 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E664B646F
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 12:07:41 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id c15-20020a17090a1d0f00b0021365864446so14859027pjd.4
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 12:07:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j8ZywzlJ9gNLgr5ZzI2h5JaTktuRQJCarasUQLptVEY=;
        b=dKbzgUC9lipQYhQKT4GhjUAiDdSRWBKVcBbQMPN1V3PUtSgyYPryZTwr9HFhvUN2o3
         l+mE1qmz9jXdxnv0uPg8+IJtxAZBQN7PJijbWjNp15QBVey2+4hS/ocuX2d3eVna7B5m
         nzSiOieEFcE+3L2g3syoyQVvA/4QoFPvKIfZnsBIxfIEnufUs0gWG0s3V9AfSO3r8rh4
         1KrMF2Xp9pigKaQnYqo+VvjioB/XN1Ip0f5vva9Uk64tXaXK2ywSj51lrBKh5T1GOGNd
         tCmGhva7k2HHPk4BwlZbJm7g+E6l08qN2hpYHYeShL9epGvO+4jYHGxL/FOYWnoQ43a1
         1+tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j8ZywzlJ9gNLgr5ZzI2h5JaTktuRQJCarasUQLptVEY=;
        b=JNt9xdAGcBtjxSASJnDP95cm2qxFdJrr8/ljYPDJf8IFdp5dAbUAC9ewJOlzUZq8Q3
         FYg+Fno//mPYA2eJotjxDQ6JDVaxmkIQjG9eaGSIBl/2D2n+3EJQmIaj+B7r1WK6E1Vh
         Ree+L1hrvnvGXGeA1p85ECUPw7JiXMNuue87Zskmm+fQZxbLxDdESU8JNsoY9GkDpprw
         8EE+iQREirtdIXbmGptN0EID03P0jDnR75gqBolRhb2m5RDlm3uLVndzQWV5yjOrdSs2
         zho7BgdSuBXrRYfqFD3VTpIcqXiVJRL0wOs7/YB+BSm0K9KacM/9G9eSdKNBR/nufBqS
         VhlQ==
X-Gm-Message-State: ANoB5pkdnRLHcOR9PSRp/0kwRT87YnRAhxpco5qifMCMBuUSNcwmGXto
        aw4OvuT46GwYo48cu4TRQWQ4Sw==
X-Google-Smtp-Source: AA0mqf4UEiJrFW1Ur8F4d6USvMZzw+qUbciplyzqE9PFTAP68TQk9VTB4aIT0vQGLHAv1V0fFTE1bA==
X-Received: by 2002:a17:902:d70e:b0:185:57b6:13c3 with SMTP id w14-20020a170902d70e00b0018557b613c3mr5632758ply.116.1668542861279;
        Tue, 15 Nov 2022 12:07:41 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g11-20020a170902e38b00b00186c3af9644sm10182578ple.273.2022.11.15.12.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 12:07:40 -0800 (PST)
Date:   Tue, 15 Nov 2022 20:07:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     syzbot <syzbot+644848628d5e12d5438c@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        syzkaller-bugs@googlegroups.com, kvm@vger.kernel.org
Subject: Re: [syzbot] kernel BUG in workingset_activation (2)
Message-ID: <Y3PxiIMOu+7x89YS@google.com>
References: <000000000000a2c79f05ed84c7f9@google.com>
 <20221115112729.1c82988047557e45765cc42d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115112729.1c82988047557e45765cc42d@linux-foundation.org>
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

On Tue, Nov 15, 2022, Andrew Morton wrote:
> On Tue, 15 Nov 2022 08:23:44 -0800 syzbot <syzbot+644848628d5e12d5438c@syzkaller.appspotmail.com> wrote:
> 
> > Hello,
> > 
> > syzbot found the following issue on:
> 
> Thanks.
> 
> > HEAD commit:    f4bc5bbb5fef Merge tag 'nfsd-5.17-2' of git://git.kernel.o..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=16c683d8700000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=5707221760c00a20
> > dashboard link: https://syzkaller.appspot.com/bug?extid=644848628d5e12d5438c
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1691d2c2700000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16cde752700000
> > 
> > Bisection is inconclusive: the issue happens on the oldest tested release.
> > 
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=174c8174700000
> > final oops:     https://syzkaller.appspot.com/x/report.txt?x=14cc8174700000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=10cc8174700000
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+644848628d5e12d5438c@syzkaller.appspotmail.com
> > 
> >  do_one_initcall+0x103/0x650 init/main.c:1300
> >  do_initcall_level init/main.c:1373 [inline]
> >  do_initcalls init/main.c:1389 [inline]
> >  do_basic_setup init/main.c:1408 [inline]
> >  kernel_init_freeable+0x6b1/0x73a init/main.c:1613
> >  kernel_init+0x1a/0x1d0 init/main.c:1502
> >  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> > ------------[ cut here ]------------
> > kernel BUG at include/linux/memcontrol.h:470!
> 
> That's
> 
> 	VM_BUG_ON_FOLIO(folio_test_slab(folio), folio);
> 
> in folio_memcg_rcu().
> 
> I'll cc the KVM list.

Thanks!  Saw this internally, was waiting for it to hit the lists.

I haven't been able to repro the syzkaller test (abuses /dev/bus/usb crud), but
I believe the issue is that KVM attempts to mark a kmalloc'd page as accessed.
workingset_activation() doesn't expect this and invokes folio_memcg_rcu() on a
SLAB page, which triggers the VM_BUG.

I suspect this can be reproduced with a KVM selftest by mapping KVM's own vcpu->run
memory into the guest.  I'll give that a shot.

In the meantime...

#sys test https://github.com/sean-jc/linux.git x86/no_slab_accessed
