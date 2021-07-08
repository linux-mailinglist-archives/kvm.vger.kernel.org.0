Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4133C137F
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 15:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhGHNG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 09:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbhGHNG2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jul 2021 09:06:28 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B8DC061574;
        Thu,  8 Jul 2021 06:03:46 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1625749425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MRfCbrQnCjc31mun5+lwwycjoViRgOB/BMNUJ5+WFVM=;
        b=XqHv15B4IzUHDb3aeRgQ9sUauMXSuWJTTUoBLFBg7gfNpqSdZz+HCXNTrRDVU1Hs3lihnx
        JANDD+V7ccrDsoSGZXo307eDImgnyvANXm0IZz3nwgiSjCqAUWuCMMg9tx6667WyaZF53b
        QU+hi4vZKSV2MRfp7E1o73tvD1CsOuSdsp/HsqCbe6wvkWcbxqTyBbNODiQIPdr3zDI8xo
        LLjpGBPv93PD9rzuHIOJrcPSCFdDgKCf5Tit7ww64Vg3jhXI1sTNIbgfzO1tu+btaeikY3
        BgkBZMnh6EACv5LXSbZuZsm7z6ct3YEp6uBGDZmmVtJ/Q2c3OWv9jHo3y4PEmg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1625749425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MRfCbrQnCjc31mun5+lwwycjoViRgOB/BMNUJ5+WFVM=;
        b=x5+ZjaUMukMtoLsi6pswazdqA74YMyQ4LYDTz12q7iwjXG7PC589ioXdFo3oGf5Lm6/oqS
        X39v/oanHo5CqlBQ==
To:     syzbot <syzbot+a3fcd59df1b372066f5a@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, bp@alien8.de, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        mark.rutland@arm.com, masahiroy@kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, peterz@infradead.org,
        rafael.j.wysocki@intel.com, rostedt@goodmis.org, seanjc@google.com,
        sedat.dilek@gmail.com, syzkaller-bugs@googlegroups.com,
        vitor@massaru.org, vkuznets@redhat.com, wanpengli@tencent.com,
        will@kernel.org, x86@kernel.org
Subject: Re: [syzbot] general protection fault in try_grab_compound_head
In-Reply-To: <0000000000009e89e205c63dda94@google.com>
References: <0000000000009e89e205c63dda94@google.com>
Date:   Thu, 08 Jul 2021 15:03:45 +0200
Message-ID: <87fswpot3i.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 03 2021 at 13:24, syzbot wrote:
> syzbot has bisected this issue to:
>
> commit 997acaf6b4b59c6a9c259740312a69ea549cc684
> Author: Mark Rutland <mark.rutland@arm.com>
> Date:   Mon Jan 11 15:37:07 2021 +0000
>
>     lockdep: report broken irq restoration

That's the commit which makes the underlying problem visible:

       raw_local_irq_restore() called with IRQs enabled

and is triggered by this call chain:

 kvm_wait arch/x86/kernel/kvm.c:860 [inline]
 kvm_wait+0xc3/0xe0 arch/x86/kernel/kvm.c:837
 pv_wait arch/x86/include/asm/paravirt.h:564 [inline]
 pv_wait_head_or_lock kernel/locking/qspinlock_paravirt.h:470 [inline]
 __pv_queued_spin_lock_slowpath+0x8b8/0xb40 kernel/locking/qspinlock.c:508
 pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:554 [inline]
 queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:51 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:85 [inline]
 do_raw_spin_lock+0x200/0x2b0 kernel/locking/spinlock_debug.c:113
 spin_lock include/linux/spinlock.h:354 [inline]
 alloc_huge_page+0x2b0/0xda0 mm/hugetlb.c:2318
 hugetlb_no_page mm/hugetlb.c:4323 [inline]
 hugetlb_fault+0xc35/0x1cd0 mm/hugetlb.c:4523
 follow_hugetlb_page+0x317/0xda0 mm/hugetlb.c:4836
 __get_user_pages+0x3fa/0xe30 mm/gup.c:1041
 __get_user_pages_locked mm/gup.c:1256 [inline]
 __gup_longterm_locked+0x15f/0xc80 mm/gup.c:1667
 io_sqe_buffer_register fs/io_uring.c:8462 [inline]
 __io_uring_register fs/io_uring.c:9901 [inline]
 __do_sys_io_uring_register+0xeb1/0x3350 fs/io_uring.c:10000
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Thanks,

        tglx
