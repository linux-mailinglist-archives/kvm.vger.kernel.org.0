Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A324552100B
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 10:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238244AbiEJIzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 04:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238229AbiEJIzL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 04:55:11 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2327B3D1E5
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 01:51:14 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id k184-20020a6bbac1000000b0065aeedd4ba8so4197777iof.20
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 01:51:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=gEeJNjfS0q6RM62Nvi60TGEoWat+e1zZfxTGA+WRzSY=;
        b=ex93CIe2ejjXGJqW8BcrJi6aAZJ5+1xTVljn1DYqQWGOx0oHKZcumjL6GOpnygSMDU
         5yrz9WvayA0pvBgY8cPY2ZxTHXHWEUpmVN4w9x+C6isLib0eNQTQCEJmZamEU9kezXxP
         dB3Vg9H7ZOxDoQ8x+/AovDbLhruNG+8q4Hqesg01VFtIqU4bolc6L4wAPhUoVeRRQLeT
         E6KqxUiKtYtf8zEHIoacuP0IoaBcVI2CWxt6Mx77bppfr8rck15Rmlci+xBvm87Ma92O
         krRwc1Q/AyJoP393rszQAB9gEsuYoheq7farQuzvx37LkwDssOx4+Mmqiu+yIQDj5Hot
         QH4w==
X-Gm-Message-State: AOAM5317ZaTOeSZw2+Cfo1BdJxkgkKVMRLaUluOI7s93+1/SAJMWlpT3
        UUbKXB2KY19we0NztL0I4oDrnpLfM7LFnmPQLPHQhx//WaYw
X-Google-Smtp-Source: ABdhPJymd70zSLRupmjht8i7wwnCSSg/9t9Ls3kE6/21v2tdD1hcmHlI4ApXwuuuEnn2Izn9LJhqsv6m4l19IZnSt7QWs+/iF9HJ
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:218b:b0:2cd:fb28:5417 with SMTP id
 j11-20020a056e02218b00b002cdfb285417mr9002492ila.83.1652172673463; Tue, 10
 May 2022 01:51:13 -0700 (PDT)
Date:   Tue, 10 May 2022 01:51:13 -0700
In-Reply-To: <000000000000402c5305ab0bd2a2@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004f3c0d05dea46dac@google.com>
Subject: Re: [syzbot] INFO: task hung in synchronize_rcu (3)
From:   syzbot <syzbot+0c6da80218456f1edc36@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, davem@davemloft.net, jhs@mojatatu.com,
        jiri@resnulli.us, kvm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, mlevitsk@redhat.com, netdev@vger.kernel.org,
        pbonzini@redhat.com, peterz@infradead.org, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vinicius.gomes@intel.com, viro@zeniv.linux.org.uk,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 2d08935682ac5f6bfb70f7e6844ec27d4a245fa4
Author: Sean Christopherson <seanjc@google.com>
Date:   Fri Apr 15 00:43:41 2022 +0000

    KVM: x86: Don't re-acquire SRCU lock in complete_emulated_io()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16dc2e49f00000
start commit:   ea4424be1688 Merge tag 'mtd/fixes-for-5.17-rc8' of git://g..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=442f8ac61e60a75e
dashboard link: https://syzkaller.appspot.com/bug?extid=0c6da80218456f1edc36
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1685af9e700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11b09df1700000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: KVM: x86: Don't re-acquire SRCU lock in complete_emulated_io()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
