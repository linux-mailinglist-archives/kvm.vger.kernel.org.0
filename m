Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 296035575FB
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 10:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiFWIy5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 04:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiFWIyx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 04:54:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 752763584F
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 01:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655974491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ULy9IIamPdfsZSRsFJ2H0uvIsCHgd0HnbDP0BI9tL4I=;
        b=c1yZ6YjpAvFJsD473U1QzOU78HgoftUsk6hIluYupi2k6gVPIWLkYJ7CH/aqXd/E6DR5+4
        udgtYrgGZx+mdKNcbFW+yZV6KFCRjeltz7hikwYqZWJ1vaStYwWHhcCgOB+4ZDz4IsPGwl
        aPpE7YFrxrw1K27YV9LEO96emE5HA0w=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-395-IiZ-DFWOPXyxrC5jbz2Xiw-1; Thu, 23 Jun 2022 04:54:50 -0400
X-MC-Unique: IiZ-DFWOPXyxrC5jbz2Xiw-1
Received: by mail-pg1-f198.google.com with SMTP id d66-20020a636845000000b0040a88edd9c1so10296778pgc.13
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 01:54:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ULy9IIamPdfsZSRsFJ2H0uvIsCHgd0HnbDP0BI9tL4I=;
        b=ox8lF4EL7PbhvmNfyv/G99i/dUYzJIk93OWISx/oSn1e/uU109H3RQcoeyEEBiwh7R
         P/njDe6nLtTQIuu28GUBugWO/yQbz4zjFhA4saZ6xnLX5W5iMvGkbfASR9m2LUViiFwh
         Iel0OXgXLUA+X3tP+JV016LDXRU+acjIkPvlS3RX7VIOUhuHEKFGuv7AiicL8ZwkGHEq
         d1czM4nTEo2tWqmuFsxX7zEST/cAtVxpAHdHgSCrIzzyU4LQYHPwJJhHUNpVstL9WHJs
         V/d2jvq07q7vwaJmr6V+WZtkyG24OFX+R5mTzcpp2x8f7qXH7BiCnjOYWiOZsuHRSI1o
         8qYQ==
X-Gm-Message-State: AJIora+FHr9tJ4yRYwIeLrAVF10yzf49klOs30SbPx+Ia2pEy1v0+qaR
        3M04pP9M6cwdskrILiUYy7RFejwPMxLnbooBSieEgcjiEcibbpNd73NeQOlZf5so14oy+MflfYH
        M9GZwYVYeNeqSQbU0zIJEvty0iIjg
X-Received: by 2002:a17:902:ec83:b0:16a:3029:a44 with SMTP id x3-20020a170902ec8300b0016a30290a44mr15842253plg.141.1655974489103;
        Thu, 23 Jun 2022 01:54:49 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vK4B3HncgW6duS5f+hx8kUoau/VW9nbZ05rE0/VJMQKcwWRVhW79OpJQA/P7Sn6FUm+rj+FSdF2+5UqBofQ2s=
X-Received: by 2002:a17:902:ec83:b0:16a:3029:a44 with SMTP id
 x3-20020a170902ec8300b0016a30290a44mr15842235plg.141.1655974488824; Thu, 23
 Jun 2022 01:54:48 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000b9edeb05e1aca987@google.com> <0000000000008b8cd205e2187ea2@google.com>
In-Reply-To: <0000000000008b8cd205e2187ea2@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 23 Jun 2022 10:54:37 +0200
Message-ID: <CABgObfarsDqG3g1L561CHvg3j0aROSz5zdcB5kOibcjbLN_y9g@mail.gmail.com>
Subject: Re: [syzbot] WARNING: suspicious RCU usage (5)
To:     syzbot <syzbot+9cbc6bed3a22f1d37395@syzkaller.appspotmail.com>
Cc:     Alexander Lobakin <alobakin@pm.me>, Borislav Petkov <bp@alien8.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Anvin, H. Peter" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Networking <netdev@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        xuanzhuo@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

#syz fix: x86/kvm: Fix broken irq restoration in kvm_wait

On Thu, Jun 23, 2022 at 9:35 AM syzbot
<syzbot+9cbc6bed3a22f1d37395@syzkaller.appspotmail.com> wrote:
>
> syzbot has bisected this issue to:
>
> commit c2ff53d8049f30098153cd2d1299a44d7b124c57
> Author: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Date:   Thu Feb 18 20:50:02 2021 +0000
>
>     net: Add priv_flags for allow tx skb without linear
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11596838080000
> start commit:   a5b00f5b78b7 Merge branch 'hns3-fixres'
> git tree:       net
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=13596838080000
> console output: https://syzkaller.appspot.com/x/log.txt?x=15596838080000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=20ac3e0ebf0db3bd
> dashboard link: https://syzkaller.appspot.com/bug?extid=9cbc6bed3a22f1d37395
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=143b22abf00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=125194eff00000
>
> Reported-by: syzbot+9cbc6bed3a22f1d37395@syzkaller.appspotmail.com
> Fixes: c2ff53d8049f ("net: Add priv_flags for allow tx skb without linear")
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>

