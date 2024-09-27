Return-Path: <kvm+bounces-27624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 335159886BA
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 16:14:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D485A283F8A
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 14:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65973130E27;
	Fri, 27 Sep 2024 14:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nS56KZqJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF7F4D8DA
	for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 14:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727446439; cv=none; b=HKu/jooQsXzvBy/n12IqiL5+zdNritGJXqmRYzUeabfQDMJ3Ls+gbRvm5CsteWT2KBMP5YH0FG//bN169w//xvhm7oMbGscaB+ajcLG4lzvnnWtnsH0vSqBHSYPHW04sspxxBGPmfw6sMlxlMW5Wl7veoPnysXi3v5dtemeD7I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727446439; c=relaxed/simple;
	bh=E+FCtvX5tiAUXaQC8bDj+CjwksAplbtuAStfl9vHjvA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rBoWV77MPe/Oe0IV59y7xcI+q1EahDLFJx9V0WuqPqEeKsOJLywzvQehI2HoRBS2VJ53UqG5D3TxCxK5j54F0TOMcWeyurgsfocv3s69BReGQ13tnLyHD/fLW23QrO5mnDZaTC6W6aEb/8beYZNS20anOEMqWU4bYzkFPp6sJMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nS56KZqJ; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e25e3d7f514so2101555276.0
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 07:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727446436; x=1728051236; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oxHmrqFeJJMvL0LXe9u6VdmgiJC7okRqJH0b/bUsNDM=;
        b=nS56KZqJheHcYeB1MSWekLxH4U9E7TUxYGjM6r63K7IGiNuFI/z7jyQZxH2Tmvhs0L
         0JscEPHmY/dH1X+/rPTL6CcmumbcdkSz+T9Z6IKwjf1CfMJmIsYfECGrF/Ol3PiI8uWh
         GvrTkIbzqeqsLmBoT+DeJY2mea5LBktWoNjea2dKYT0OYbi8kiZ6zIsGyRNiF/gCBvKx
         XK5nsGv8GokoWi9fBQ8cHXuNZf6Ue4LrWsoVA6zOwgzl1ZqOjtGVFOcj9hQamtlRBxGx
         PVrRwFSGEUMltk2ncpC1/YA2EQwUXsFMQdoAbqgH3XWh+zDK6iDDu8uPaTyNB+JjKieU
         sBhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727446436; x=1728051236;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oxHmrqFeJJMvL0LXe9u6VdmgiJC7okRqJH0b/bUsNDM=;
        b=Bxates9zUEZL1aBuRb+zOilYWj4+0po9/ESTp/w2FmnKx2Y9XaloBy73v0Z5y0cjUL
         QIwAKd0YGLDzwvwxN9AHUie+vx/0kb5/4dKtAjDdHqaNhvGNXVmQ3VV1tk2AP23KWhG8
         g2v2cwCaPjXXbvpdryreJAGGG9QqCZqbnsdkAeX5xKPppHVqPfuOT9xB5Ly8ORUZ3sHy
         dE6HewfWajhXjbXg3OKJd5kIrzOy/teFetUPG6dzTgoDWher4Qc9hEfMt5bfVDzV0V34
         ZgPpH3YwbSSDciUr/QR2wTGQRitZ25WqwBVgUQvoIWg58DIqAjYf1iUiqdCvJSrRBvsG
         VF0g==
X-Gm-Message-State: AOJu0YyzMSnLL6V/hdgbmn8BwAsCUkSU0mX6zPdAmIdGq6PpZWkqrnm8
	G+SHpKd0oTQCF+J3VMsDCLDx36J5vobICW/FrMl4Pw1YZSWeD1VeUkTaO2riRDaIQ35wQK0e1TM
	wVw==
X-Google-Smtp-Source: AGHT+IEnEGSzHCyg8dQbKDMJQILv716YQPrF4czXU/rTygWR1FZcg+eAhEhlInCTmo02d/T8LRkvFnOJR68=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:1c2:0:b0:e25:d596:4847 with SMTP id
 3f1490d57ef6-e2604c8e14cmr25663276.6.1727446435931; Fri, 27 Sep 2024 07:13:55
 -0700 (PDT)
Date: Fri, 27 Sep 2024 07:13:54 -0700
In-Reply-To: <66f4164d.050a0220.211276.0032.GAE@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <66f4164d.050a0220.211276.0032.GAE@google.com>
Message-ID: <Zva9oi6jfBSoGwn0@google.com>
Subject: Re: [syzbot] [kvm?] WARNING in srcu_check_nmi_safety (2)
From: Sean Christopherson <seanjc@google.com>
To: syzbot <syzbot+314c2cfd4071ad738810@syzkaller.appspotmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com, Kent Overstreet <kent.overstreet@linux.dev>
Content-Type: text/plain; charset="us-ascii"

+Kent

On Wed, Sep 25, 2024, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    abf2050f51fd Merge tag 'media/v6.12-1' of git://git.kernel..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=114cc99f980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=bc30a30374b0753
> dashboard link: https://syzkaller.appspot.com/bug?extid=314c2cfd4071ad738810
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-abf2050f.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/2179ebeade58/vmlinux-abf2050f.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/f05289b5cf7c/bzImage-abf2050f.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+314c2cfd4071ad738810@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> CPU 0 old state 2 new state 1
> WARNING: CPU: 0 PID: 73 at kernel/rcu/srcutree.c:708 srcu_check_nmi_safety+0xca/0x150 kernel/rcu/srcutree.c:708
> Modules linked in:
> CPU: 0 UID: 0 PID: 73 Comm: kswapd0 Not tainted 6.11.0-syzkaller-09959-gabf2050f51fd #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:srcu_check_nmi_safety+0xca/0x150 kernel/rcu/srcutree.c:708
> Code: 81 c3 c8 01 00 00 48 89 d8 48 c1 e8 03 42 0f b6 04 20 84 c0 75 77 8b 33 48 c7 c7 20 0c 0c 8c 89 ea 44 89 f9 e8 b7 8c db ff 90 <0f> 0b 90 90 eb 0c 42 0f b6 04 23 84 c0 75 3d 45 89 3e 48 83 c4 08
> RSP: 0018:ffffc90000e464e0 EFLAGS: 00010246
> RAX: 41404736cdfea900 RBX: ffffe8ffffc414c8 RCX: ffff88801efb0000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000002 R08: ffffffff8155aaa2 R09: 1ffff11003f8519a
> R10: dffffc0000000000 R11: ffffed1003f8519b R12: dffffc0000000000
> R13: 0000607fe0041300 R14: ffffe8ffffc41320 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000564aa6d10940 CR3: 0000000011c68000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  srcu_read_lock include/linux/srcu.h:248 [inline]
>  __kvm_handle_hva_range virt/kvm/kvm_main.c:612 [inline]
>  kvm_handle_hva_range virt/kvm/kvm_main.c:684 [inline]
>  kvm_mmu_notifier_clear_flush_young+0xe6/0x820 virt/kvm/kvm_main.c:867
>  __mmu_notifier_clear_flush_young+0x11d/0x1d0 mm/mmu_notifier.c:379
>  mmu_notifier_clear_flush_young include/linux/mmu_notifier.h:410 [inline]
>  folio_referenced_one+0xb9d/0x2160 mm/rmap.c:895
>  rmap_walk_anon+0x4cd/0x8a0 mm/rmap.c:2638
>  rmap_walk mm/rmap.c:2716 [inline]
>  folio_referenced+0x394/0x7a0 mm/rmap.c:1008
>  folio_check_references mm/vmscan.c:863 [inline]
>  shrink_folio_list+0xe96/0x8cc0 mm/vmscan.c:1198
>  evict_folios+0x549b/0x7b50 mm/vmscan.c:4583
>  try_to_shrink_lruvec+0x9ab/0xbb0 mm/vmscan.c:4778
>  shrink_one+0x3b9/0x850 mm/vmscan.c:4816
>  shrink_many mm/vmscan.c:4879 [inline]
>  lru_gen_shrink_node mm/vmscan.c:4957 [inline]
>  shrink_node+0x3799/0x3de0 mm/vmscan.c:5937
>  kswapd_shrink_node mm/vmscan.c:6765 [inline]
>  balance_pgdat mm/vmscan.c:6957 [inline]
>  kswapd+0x1ca3/0x3700 mm/vmscan.c:7226
>  kthread+0x2f0/0x390 kernel/kthread.c:389
>  ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>  </TASK>

#syz set subsystems: bcachefs

Looks like another bcachefs shutdown problem.  The failure happened on a kernel
with d293ece10810 ("bcachefs: Fix shutdown ordering"), so it's not the exact same
thing as reported in https://lore.kernel.org/all/Zr-bCqSWRS3yob7V@google.com.

[   82.068524][ T5112] bcachefs (loop0): going read-write
[   82.076688][ T4530] Bluetooth: hci0: command tx timeout
[   82.092465][ T5112] bcachefs (loop0): journal_replay... done
[   82.150223][ T5112] bcachefs (loop0): resume_logged_ops... done
[   82.152607][ T5112] bcachefs (loop0): delete_dead_inodes... done
[   82.164815][ T5112] bcachefs (loop0): Fixed errors, running fsck a second time to verify fs is clean
[   82.176357][ T5112] bcachefs (loop0): resume_logged_ops... done
[   82.178950][ T5112] bcachefs (loop0): delete_dead_inodes... done
[   82.188910][ T5112] bcachefs (loop0): done starting filesystem
[   82.302896][ T5112] bcachefs (loop0): shutting down
[   82.305956][ T5112] bcachefs (loop0): going read-only
[   82.317925][ T5112] bcachefs (loop0): finished waiting for writes to stop
[   82.328724][ T5112] bcachefs (loop0): flushing journal and stopping allocators, journal seq 17
[   82.354271][ T5113] netlink: 16 bytes leftover after parsing attributes in process `syz.0.0'.
[   82.366356][ T5112] bcachefs (loop0): flushing journal and stopping allocators complete, journal seq 18
[   82.386917][ T5112] bcachefs (loop0): shutdown complete, journal seq 19
[   82.390927][ T5112] bcachefs (loop0): marking filesystem clean
[   82.472328][ T5112] bcachefs (loop0): shutdown complete
[   82.504701][   T73] ------------[ cut here ]------------
[   82.507314][   T73] CPU 0 old state 2 new state 1
[   82.509635][   T73] WARNING: CPU: 0 PID: 73 at kernel/rcu/srcutree.c:708 srcu_check_nmi_safety+0xca/0x150
[   82.513331][   T73] Modules linked in:

