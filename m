Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91AD3938D1
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 00:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236136AbhE0Wxl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 18:53:41 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37420 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233203AbhE0Wxk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 18:53:40 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622155923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uAIoLlMtrjzvrcsBxWhaicEwWt4fesWA8JrISGhrLd8=;
        b=XK0pzWuM+eObk9PdHaBYcRiPNn68IG5lkkSx+/M1IFv1KJVDo4XGjreMmYtvfcptFdJaMK
        o8SAPmC2vpJsvRPrME1koGoJpxNT6UHo6MNWwTVoUwCCdTjyFu2gEKbVN3gcCQ1uAWpKn2
        eMP0WdUIgfjHREIlP0+JcDkIW057x0G6Nzuk+8V0P741kSHsc8BdMuqlCin/skeHZ1v9tl
        d57tofIlP/91yyXfeHbJcEQb4au943NVBZRydPidUONCE+/77OLFVbPnRAffEEYUhuqdE1
        1OVM4filzuJMq3TAb9snPrtMAq5hUXBcXu/CpEd4kL/ZC/dDScu36YsxvKFbiw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622155923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uAIoLlMtrjzvrcsBxWhaicEwWt4fesWA8JrISGhrLd8=;
        b=NgIBE2poQuAfCdybmeEvdWm3RcgZ7+Cwxqm+Hlou0f5BLGQUi1m1uWytGTEfuproQ+/nss
        kUTkS29UD5CGimCw==
To:     syzbot <syzbot+71271244f206d17f6441@syzkaller.appspotmail.com>,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jarkko@kernel.org, jmattson@google.com, joro@8bytes.org,
        kan.liang@linux.intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, peterz@infradead.org,
        seanjc@google.com, steve.wahl@hpe.com,
        syzkaller-bugs@googlegroups.com, vkuznets@redhat.com,
        wanpengli@tencent.com, x86@kernel.org
Subject: Re: [syzbot] WARNING in x86_emulate_instruction
In-Reply-To: <000000000000f3fc9305c2e24311@google.com>
References: <000000000000f3fc9305c2e24311@google.com>
Date:   Fri, 28 May 2021 00:52:03 +0200
Message-ID: <87v9737pt8.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 21 2021 at 19:52, syzbot wrote:

> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    8ac91e6c Merge tag 'for-5.13-rc2-tag' of git://git.kernel...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16a80fc7d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=dddb87edd6431081
> dashboard link: https://syzkaller.appspot.com/bug?extid=71271244f206d17f6441
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12d1f89bd00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=134683fdd00000
>
> The issue was bisected to:
>
> commit 9a7832ce3d920426a36cdd78eda4b3568d4d09e3
> Author: Steve Wahl <steve.wahl@hpe.com>
> Date:   Fri Jan 8 15:35:49 2021 +0000
>
>     perf/x86/intel/uncore: With > 8 nodes, get pci bus die id from NUMA info
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=152bf9b3d00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=172bf9b3d00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=132bf9b3d00000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+71271244f206d17f6441@syzkaller.appspotmail.com
> Fixes: 9a7832ce3d92 ("perf/x86/intel/uncore: With > 8 nodes, get pci bus die id from NUMA info")

So this is stale for a week now. It's fully reproducible and nobody
can't be bothered to look at that?

What's wrong with you people?

Thanks,

        tglx
