Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3882DFB04
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 11:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgLUK0R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Dec 2020 05:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbgLUK0Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Dec 2020 05:26:16 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2BAC0613D3
        for <kvm@vger.kernel.org>; Mon, 21 Dec 2020 02:25:35 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id z3so6212779qtw.9
        for <kvm@vger.kernel.org>; Mon, 21 Dec 2020 02:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6M/YwkCYIyGlJVAYe704Xk3oPcJUgFz/KZ270jgPQzU=;
        b=KJb2taVRBZB8INRt0J7DosLa2gmPLDQJL4D704CX7AKJTkz6hYU3Hm3HVdtNoC8BPE
         4M5ZgBi2xvXGJq+GvOOQiZyzGT7gJ8ckWQH76Aw3BZSV+kfPK87t3oyQA6sK3xJn+7Tg
         AEilKWBc9AfOAC9J7daFVbeH6XNHkkOaWFl3/kN+BgD2QSWc1uUtgScEe0RwtIjRJo+7
         +38/0DDGt/x0IUuo6ek5AqWqmXVrrMoKOT51K6o5DTTbtfvW9vlPeub1gdnNClqWd+L5
         gCAXZwQk14aW5LyRU3QLHnZf3FKNIliwpzOOjhkX9T22z/gmWjp72z9IZd/EVYfMINw+
         KLeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6M/YwkCYIyGlJVAYe704Xk3oPcJUgFz/KZ270jgPQzU=;
        b=IW4qcbCI5Gaq71MO1ycarkhzUzrjDHtZMMyyMF0lk4N3XFdfGowyI+VRZHoHsJeHqv
         5tyAMeJSildfv0eRPs12j8VuYo5NPGptXKyr3PYZxpeZF8S5YAUW3kYC4fIfwzwl1uwG
         I5zEBZFs3uso+rzs/Qgkde9DPk+RjaqyHA45Ufh+MAQklUUGaHnVnNrtKdnupX3KdX8x
         aCRxQaed2M3MtgJ6fpjwqvuLqnieaZ0uGxSTI0jmg/yFxTg/Iqaw9ypNa8KxWL+drZLK
         N4/WcVjkINaYwVqvkO+thM4riTeTx+TFX7ehhXzkMWKSI4sPXo2Gp2ROPNhDuoBSnfAN
         I5KA==
X-Gm-Message-State: AOAM5315gDmrecK2sslK93l0Ev50kvnTi2nBIUBFu7lCEjFB9RxuNoTL
        DFBFG44psGYSoHgB6iNREpNELb8pMjB8bDBmjAGpcTBUseo=
X-Google-Smtp-Source: ABdhPJzy05k7aN1jFIeWNe77asiU17/4WYNEu2MvhoBXizH3PyaLmma7rEiKGjOIUOL6+owIYb4FJQnLzDT/iJVRW7w=
X-Received: by 2002:ac8:5ac3:: with SMTP id d3mr15794400qtd.66.1608542498564;
 Mon, 21 Dec 2020 01:21:38 -0800 (PST)
MIME-Version: 1.0
References: <000000000000264c6305a9c74d9b@google.com> <0000000000008647f705b6e215de@google.com>
In-Reply-To: <0000000000008647f705b6e215de@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 21 Dec 2020 10:21:27 +0100
Message-ID: <CACT4Y+YnmECGRg7yOrkCQAw6OSm6TeEzOCBnJE7F32aoL0_2RQ@mail.gmail.com>
Subject: Re: INFO: rcu detected stall in tipc_release
To:     syzbot <syzbot+3654c027d861c6df4b06@syzkaller.appspotmail.com>
Cc:     Markus Elfring <Markus.Elfring@web.de>,
        Borislav Petkov <bp@alien8.de>, coreteam@netfilter.org,
        David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Hillf Danton <hdanton@sina.com>,
        "H. Peter Anvin" <hpa@zytor.com>, jmaloy@redhat.com,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kadlec@netfilter.org,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        subashab@codeaurora.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        tuong.t.lien@dektech.com.au,
        Vitaly Kuznetsov <vkuznets@redhat.com>, wanpengli@tencent.com,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Dec 20, 2020 at 10:37 AM syzbot
<syzbot+3654c027d861c6df4b06@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit cc00bcaa589914096edef7fb87ca5cee4a166b5c
> Author: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> Date:   Wed Nov 25 18:27:22 2020 +0000
>
>     netfilter: x_tables: Switch synchronization to RCU
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1445cb37500000
> start commit:   7cc2a8ea Merge tag 'block-5.8-2020-07-01' of git://git.ker..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7be693511b29b338
> dashboard link: https://syzkaller.appspot.com/bug?extid=3654c027d861c6df4b06
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12948233100000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11344c05100000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: netfilter: x_tables: Switch synchronization to RCU
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

It's not immediately obvious that this is indeed the fix for this, but
also not obvious that this is not the fix for this. Bisection log
looks plausible.
Was this bug in tipc fixed? Is it the fix?
If I don't hear better suggestions I will close this bug as fixed by
this commit later.
