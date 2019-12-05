Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5D0B113F75
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 11:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbfLEKeu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 05:34:50 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:62946 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728707AbfLEKeu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 05:34:50 -0500
Received: from fsav303.sakura.ne.jp (fsav303.sakura.ne.jp [153.120.85.134])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id xB5AUvCo044363;
        Thu, 5 Dec 2019 19:30:57 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav303.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav303.sakura.ne.jp);
 Thu, 05 Dec 2019 19:30:57 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav303.sakura.ne.jp)
Received: from [192.168.1.9] (softbank126040062084.bbtec.net [126.40.62.84])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id xB5AUqmd044301
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Thu, 5 Dec 2019 19:30:57 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: KASAN: slab-out-of-bounds Read in fbcon_get_font
To:     Dmitry Vyukov <dvyukov@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     syzbot <syzbot+4455ca3b3291de891abc@syzkaller.appspotmail.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI <dri-devel@lists.freedesktop.org>, ghalat@redhat.com,
        Gleb Natapov <gleb@kernel.org>, gwshan@linux.vnet.ibm.com,
        "H. Peter Anvin" <hpa@zytor.com>, James Morris <jmorris@namei.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        KVM list <kvm@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Russell Currey <ruscur@russell.cc>,
        Sam Ravnborg <sam@ravnborg.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, stewart@linux.vnet.ibm.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>
References: <0000000000003e640e0598e7abc3@google.com>
 <41c082f5-5d22-d398-3bdd-3f4bf69d7ea3@redhat.com>
 <CACT4Y+bCHOCLYF+TW062n8+tqfK9vizaRvyjUXNPdneciq0Ahg@mail.gmail.com>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <811afcac-ec6e-3ff0-1a4e-c83b98540f0d@i-love.sakura.ne.jp>
Date:   Thu, 5 Dec 2019 19:30:53 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <CACT4Y+bCHOCLYF+TW062n8+tqfK9vizaRvyjUXNPdneciq0Ahg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019/12/05 19:16, Dmitry Vyukov wrote:
> On Thu, Dec 5, 2019 at 11:13 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 04/12/19 22:41, syzbot wrote:
>>> syzbot has bisected this bug to:
>>>
>>> commit 2de50e9674fc4ca3c6174b04477f69eb26b4ee31
>>> Author: Russell Currey <ruscur@russell.cc>
>>> Date:   Mon Feb 8 04:08:20 2016 +0000
>>>
>>>     powerpc/powernv: Remove support for p5ioc2
>>>
>>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=127a042ae00000
>>> start commit:   76bb8b05 Merge tag 'kbuild-v5.5' of
>>> git://git.kernel.org/p..
>>> git tree:       upstream
>>> final crash:    https://syzkaller.appspot.com/x/report.txt?x=117a042ae00000
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=167a042ae00000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=dd226651cb0f364b
>>> dashboard link:
>>> https://syzkaller.appspot.com/bug?extid=4455ca3b3291de891abc
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11181edae00000
>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=105cbb7ae00000
>>>
>>> Reported-by: syzbot+4455ca3b3291de891abc@syzkaller.appspotmail.com
>>> Fixes: 2de50e9674fc ("powerpc/powernv: Remove support for p5ioc2")
>>>
>>> For information about bisection process see:
>>> https://goo.gl/tpsmEJ#bisection
>>>
>>
>> Why is everybody being CC'd, even if the bug has nothing to do with the
>> person's subsystem?
> 
> The To list should be intersection of 2 groups of emails: result of
> get_maintainers.pl on the file identified as culprit in the crash
> message + emails extracted from the bisected to commit.
> 

There is "#syz uncc" command but it is too hard to utilize?
