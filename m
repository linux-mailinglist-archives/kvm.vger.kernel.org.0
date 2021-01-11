Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC52F2F2428
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 01:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404011AbhALAZl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 19:25:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390737AbhAKWpn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 17:45:43 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0141EC061795
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 14:45:03 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id i18so145669ooh.5
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 14:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O6kpvfJukcSfzCE8pUQQCjHIT6O76tXxg9rP/f6B+4o=;
        b=p1aPlWShuhKkImVn7MGucoVZAZix8VzDlfAzzEinRVGv+R4jXCLuH4buasWXMvHN8u
         p57itQKrg0IiSRt08vLyEpcZnCMOcYS2PfCM1cXymUb4rkiWMF3JIKt/NnIlBqMk/29k
         Guc04C9Q27972coInhcL2+HafSp/onmNdGzDPwIPeAay3qZtuU8vnznOoxDBbdvBIzfP
         sPafwQqEM5c9wi46verEsT5u7122qmDkjpnHjvlsgDWGYKXSfolsrAr8JCGbu3R+B36s
         6MBakNPiacJm3HjXc5xHpHQ3K5vP0z9DzIE6GxH1U3ByJx1qSubOQpFngerO30sgjPyX
         g7TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O6kpvfJukcSfzCE8pUQQCjHIT6O76tXxg9rP/f6B+4o=;
        b=pYPdsr+cgTX9bLRCCskW4lReZtpgfPm71SAc1E+8K1yC4zNR0C2gXTQN02r36s+oG8
         hYmrlB/DwFHuOLOmWdEnQBedfhQOPw03InvUvlIlgyHE+nKWVQ+tUoNFoyuJQqvM3cM+
         ML8Cv4+A1yx8t6Cv8PWoBl/F2tQvp9A2RDpEFZZHC+6fOJYsVgo8LeWhQPN2+kkcgS+k
         T6m8v8aNyMDeOihq9IW0brZcaTdX+sAqi43fYNt5PcyPaoM/Gk9LeMEtFVzUW6Z1POft
         QiHzk4ia6/lDRQw/z4QOy/bxKeVnL1xXRm1eYG3mevIp6YqPXnrUmz8kl+TwZ2apApvp
         jg6g==
X-Gm-Message-State: AOAM530xrD44bk5zqobWji+zHhDTTFNvlB95Hw/SV6HRwmKfybiTl1bw
        9D0cALc30ftTnz02q9k9oNSjll4G/evbdWPFK1vKlQ==
X-Google-Smtp-Source: ABdhPJzkhny7kvYdHxhBKmqcMFa1AfruRGU61uyaRwGVzukCfaf+okOYn9JpZnSnjjewZU6Ogd5CB9JmmBniRlmn8Wo=
X-Received: by 2002:a4a:e294:: with SMTP id k20mr966042oot.82.1610405102002;
 Mon, 11 Jan 2021 14:45:02 -0800 (PST)
MIME-Version: 1.0
References: <000000000000d5173d05b7097755@google.com>
In-Reply-To: <000000000000d5173d05b7097755@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 11 Jan 2021 14:44:50 -0800
Message-ID: <CALMp9eSKrn0zcmSuOE6GFi400PMgK+yeypS7+prtwBckgdW0vQ@mail.gmail.com>
Subject: Re: UBSAN: shift-out-of-bounds in kvm_vcpu_after_set_cpuid
To:     syzbot <syzbot+e87846c48bf72bc85311@syzkaller.appspotmail.com>
Cc:     Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It looks like userspace can possibly induce this by providing guest
CPUID information with a "physical address width" of 64 in leaf
0x80000008.

Perhaps cpuid_query_maxphyaddr() should just look at the low 5 bits of
CPUID.80000008H:EAX? Better would be to return an error for
out-of-range values, but I understand that the kvm community's stance
is that, in general, guest CPUID information should not be validated
by kvm.

On Tue, Dec 22, 2020 at 12:36 AM syzbot
<syzbot+e87846c48bf72bc85311@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    5e60366d Merge tag 'fallthrough-fixes-clang-5.11-rc1' of g..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11c7046b500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=db720fe37a6a41d8
> dashboard link: https://syzkaller.appspot.com/bug?extid=e87846c48bf72bc85311
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> userspace arch: i386
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+e87846c48bf72bc85311@syzkaller.appspotmail.com
>
> ================================================================================
> UBSAN: shift-out-of-bounds in arch/x86/kvm/mmu.h:52:16
> shift exponent 64 is too large for 64-bit type 'long long unsigned int'
> CPU: 1 PID: 11156 Comm: syz-executor.1 Not tainted 5.10.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x107/0x163 lib/dump_stack.c:120
>  ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
>  __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
>  rsvd_bits arch/x86/kvm/mmu.h:52 [inline]
>  kvm_vcpu_after_set_cpuid.cold+0x35/0x3a arch/x86/kvm/cpuid.c:181
>  kvm_vcpu_ioctl_set_cpuid+0x28e/0x970 arch/x86/kvm/cpuid.c:273
>  kvm_arch_vcpu_ioctl+0x1091/0x2d70 arch/x86/kvm/x86.c:4699
>  kvm_vcpu_ioctl+0x7b9/0xdb0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3386
>  kvm_vcpu_compat_ioctl+0x1a2/0x340 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3430
>  __do_compat_sys_ioctl+0x1d3/0x230 fs/ioctl.c:842
>  do_syscall_32_irqs_on arch/x86/entry/common.c:78 [inline]
>  __do_fast_syscall_32+0x56/0x80 arch/x86/entry/common.c:137
>  do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:160
>  entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
> RIP: 0023:0xf7fe8549
> Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
> RSP: 002b:00000000f55e20cc EFLAGS: 00000296 ORIG_RAX: 0000000000000036
> RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 000000004008ae8a
> RDX: 00000000200000c0 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> ================================================================================
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
