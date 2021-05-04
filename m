Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72C6137286D
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 12:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbhEDKGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 06:06:42 -0400
Received: from mail.skyhub.de ([5.9.137.197]:48022 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229914AbhEDKGL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 06:06:11 -0400
Received: from zn.tnic (p4fed3197.dip0.t-ipconnect.de [79.237.49.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 304001EC01A8;
        Tue,  4 May 2021 12:05:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1620122708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:references;
        bh=8vW4i6DL8eU6I0W1ghiBIZmx8oKJfnQzat9YecYvUPM=;
        b=J8U8rxUKjbr2EZX16M8MM0Pw01arTKmNrneG8sCf46wWMOfgQ91jDNO9+zbrjVWPeW1b0z
        uFwAvPTqnZEXXN3sFnZREXk5r3Y3Nbt97XdbJinTk2dG4eQ5/onhea3bIj2yUdYdCBiKmE
        8QumWgwgkiY14bOKaZA/nSeuNhcIr60=
Date:   Tue, 4 May 2021 12:02:53 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     kvm ML <kvm@vger.kernel.org>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [  483.545673] include/linux/kvm_host.h:648 suspicious
 rcu_dereference_check() usage!
Message-ID: <YJEbzVjirlgscmLU@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey folks,

perhaps it is fixed already - kernel is 5.12-rc8+tip/master but lemme
check if you've seen it already:

[  483.529501] =============================
[  483.533612] WARNING: suspicious RCU usage
[  483.537718] 5.12.0-rc8+ #1 Not tainted
[  483.541566] -----------------------------
[  483.545673] include/linux/kvm_host.h:648 suspicious rcu_dereference_check() usage!
[  483.553371] 
               other info that might help us debug this:

[  483.561507] 
               rcu_scheduler_active = 2, debug_locks = 1
[  483.568155] 1 lock held by qemu-system-x86/3893:
[  483.572880]  #0: ffff888107a580c8 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x6d/0x650 [kvm]
[  483.581980] 
               stack backtrace:
[  483.586442] CPU: 2 PID: 3893 Comm: qemu-system-x86 Not tainted 5.12.0-rc8+ #1
[  483.593704] Hardware name: GIGABYTE MZ01-CE1-00/MZ01-CE1-00, BIOS F02 08/29/2018
[  483.601229] Call Trace:
[  483.603768]  dump_stack+0x6d/0x89
[  483.607221]  kvm_vcpu_gfn_to_memslot+0x168/0x170 [kvm]
[  483.612567]  kvm_vcpu_unmap+0x28/0x60 [kvm]
[  483.616953]  pre_sev_run+0x122/0x250 [kvm_amd]
[  483.621546]  svm_vcpu_run+0x50d/0x780 [kvm_amd]
[  483.626227]  kvm_arch_vcpu_ioctl_run+0xe36/0x1bd0 [kvm]
[  483.631682]  ? kvm_arch_vcpu_ioctl_run+0xc2/0x1bd0 [kvm]
[  483.637233]  ? lock_is_held_type+0xd1/0x130
[  483.641563]  kvm_vcpu_ioctl+0x222/0x650 [kvm]
[  483.646127]  ? __fget_files+0xe3/0x190
[  483.650005]  ? __fget_files+0x5/0x190
[  483.653806]  __x64_sys_ioctl+0x98/0xd0
[  483.657693]  ? lockdep_hardirqs_on+0x88/0x120
[  483.662193]  do_syscall_64+0x41/0x80
[  483.665902]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  483.671100] RIP: 0033:0x7fde49a2f457
[  483.674809] Code: 00 00 90 48 8b 05 39 7a 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 09 7a 0c 00 f7 d8 64 89 01 48
[  483.693875] RSP: 002b:00007fde461547e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  483.701631] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007fde49a2f457
[  483.708919] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000015
[  483.716207] RBP: 00005615a1bf8500 R08: 00005615a00ee278 R09: 00000000ffffffff
[  483.723496] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
[  483.730787] R13: 00007fde4a37d004 R14: 0000000000000cf8 R15: 0000000000000000


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
