Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0C555740D
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 09:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbiFWHfR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 03:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiFWHfP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 03:35:15 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE8C46663
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 00:35:14 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id f18-20020a056e020c7200b002d949d97ed9so1830669ilj.7
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 00:35:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=7QItAS8B1/7qL5yTPxj88y2NM1HLwSWmFz7/r/sTOpw=;
        b=MsW16SqaYON8KW9O7Z6JEDoQ6xni3S20O/yz/XH+AHZSE8eI9YIZh72Gg1plaNShoM
         ijsEw6mSTSflsVYK12Nv69iCsMkTWc1xqpy/1PGrTLXkypREaoi97U9oHhZSZsB3xmqi
         r89Ein3vqxn4xAapOKKuL0UPlA/6mklDiN8g6b/IzEWcaYhlzrc6ny/VBmb3OI2QyJYd
         jPIYpL//lDkyhvZvwDvrGuTx9qv2ECBi92Bf6nVqrD4L7B1zrcP8CwirJmVJSdht21M6
         sCFCaJzvbZM7AxZCRXRQZCGbXUODSvxiz5XgwAU+xw5RF4oQKnTDAg2Jhf/C+ZvzZaW3
         RzKA==
X-Gm-Message-State: AJIora+EPClc6BUDj7Lp5l6w3KgvBDR8EFEzZsgjqtWyajs8j7JSp3M7
        5zwfbJupInmqBEwARWe2Oe1H4aOI6R4aVKwGl7cO7tErgie4
X-Google-Smtp-Source: AGRyM1uDHnpelBbH4pNfjqs05S1Tv86HE01S7bBLQKv9VdmULK/vAW25cGgGt/yXk/plAf0qQ01oPQbiNstvymQby6B/VLWIJO9i
MIME-Version: 1.0
X-Received: by 2002:a05:6638:38a0:b0:331:ec50:d191 with SMTP id
 b32-20020a05663838a000b00331ec50d191mr4517568jav.40.1655969713718; Thu, 23
 Jun 2022 00:35:13 -0700 (PDT)
Date:   Thu, 23 Jun 2022 00:35:13 -0700
In-Reply-To: <000000000000b9edeb05e1aca987@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008b8cd205e2187ea2@google.com>
Subject: Re: [syzbot] WARNING: suspicious RCU usage (5)
From:   syzbot <syzbot+9cbc6bed3a22f1d37395@syzkaller.appspotmail.com>
To:     alobakin@pm.me, bp@alien8.de, daniel@iogearbox.net, hpa@zytor.com,
        jmattson@google.com, john.fastabend@gmail.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org, xuanzhuo@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has bisected this issue to:

commit c2ff53d8049f30098153cd2d1299a44d7b124c57
Author: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Date:   Thu Feb 18 20:50:02 2021 +0000

    net: Add priv_flags for allow tx skb without linear

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11596838080000
start commit:   a5b00f5b78b7 Merge branch 'hns3-fixres'
git tree:       net
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13596838080000
console output: https://syzkaller.appspot.com/x/log.txt?x=15596838080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20ac3e0ebf0db3bd
dashboard link: https://syzkaller.appspot.com/bug?extid=9cbc6bed3a22f1d37395
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=143b22abf00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=125194eff00000

Reported-by: syzbot+9cbc6bed3a22f1d37395@syzkaller.appspotmail.com
Fixes: c2ff53d8049f ("net: Add priv_flags for allow tx skb without linear")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
