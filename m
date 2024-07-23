Return-Path: <kvm+bounces-22074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CB564939744
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 02:02:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C66F1F222EA
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 00:02:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46D3D1113;
	Tue, 23 Jul 2024 00:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0wPq+SMh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2C717E
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 00:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721692936; cv=none; b=gE2CbDog5YbxnXqNTd381j0uFG/W8YoknXcMHnu0uggbBfC9sL+SkhnYg1QHLDsa2aaESEnio8ZnQht6AIXH0Qct4WxbDrlbUjGqc9Jo5ykDkn6KddpkqGUD0NhXke7kCXVmoU3rjtXoQKGIdx4syx1d3tBV2qxMq4lMAVqyNs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721692936; c=relaxed/simple;
	bh=8GApfVvvJ3/nw5gofMjUIY3tJ2yoqcTmgUdEIC+GvVU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=hJZ+fcC9FXu9HBT0WtQB7e86boQxngBkkRDfflleTtWsuglW9fFzAIs5EuHuuXkNP733bGt1f2O8PZs2az2E+c09lRui7j307DhVvHoMhMW1sY84EmBZpW6SiFy/krQENyV+opcLcwtDPaAR1YCMxy7xBxUEMZa2xfGmI4BCQLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0wPq+SMh; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70d1df50db2so2113383b3a.0
        for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 17:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721692934; x=1722297734; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ui8JCYGft3E+0bmp18/t8KVooNOlV9PuIVC4X7jewq8=;
        b=0wPq+SMheeIJoTqcDKcx2ILWHXcjIvB7s5ez1aJ3nj+TUDtXi/H/TGmd6dEKTlzdu0
         Wr282/MoAgzbHK06nBHp0n+6uhjHKmZqyStQGjHvdno85k9E4EmzRCYKJXfxkH6ZinXZ
         NGr+zJKA0RnH4LAONV8DL/w0p6GsG05S62eIm5hJVRP1iBKSZErGky7iK06c4NWiJjkK
         tKcBY6spobSXoKsJ4B2tqfhmgVytd+xuxo9+zb+6auBCMxS9dDEMUqD5KEv6rcLRDzvQ
         EegsjpQWqLFTbGFS/lOpYq5Ts5Q6Wabl0EDUd1VC0wh8iKhMj7X4QatF0y/eEzWWc5MX
         yxng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721692934; x=1722297734;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ui8JCYGft3E+0bmp18/t8KVooNOlV9PuIVC4X7jewq8=;
        b=Hd4TTqqtNvQG60aCENaa/+j/9Z8Odytjt2BR7VFQKz0wU4sm2oONVZ7vidT3XIbqNX
         yILDQNp+mkNQ6ZeZFwlZuN3AHQTRivrmv6a5t2nkQcsGBImABmkJMtaH+zdCc/oyssNI
         bULWx6yGqUOC8xbe4oNXf0oycG9DAXhbGaooGfijMhD6Z6ma3Z5d6gTlOs4ifaMhVB/z
         mFn4rv34qEaQUnojPb+lB8aiumn70I5+EKOfVxJIu0ptAlHaWQTANmiFLZQplidMtP4m
         ZZpgiB3NzItyHI1L6hXFyvpFXZV4Ejk+6vJXzN6ob+DAyF2I6WscMoF2ZQdX/xF4U7g4
         R78Q==
X-Gm-Message-State: AOJu0YwEIcECpcWtoUH3Kkzn/wcU0DMY6YtwS7tryNBw3Pw8jGPbCIzS
	VM0j8bCFa+k6/rven/2Qzjt3bLw0dd7NtxhYBZwDjDW7YOjHyPwwbIzSa+PZe7gbYwtpygf7Vkw
	FbQ==
X-Google-Smtp-Source: AGHT+IG06ai+CJZgYM7nR6yvSg6EG9IDAIxvb/Uc8iPXgThYwx727h+r7bFvrI4V0oTra9DTVFb81NGzEhY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:8806:b0:70d:138a:bee8 with SMTP id
 d2e1a72fcca58-70e806142d7mr2107b3a.0.1721692934100; Mon, 22 Jul 2024 17:02:14
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 22 Jul 2024 17:02:11 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240723000211.3352304-1-seanjc@google.com>
Subject: [PATCH] KVM: x86/mmu: Check that root is valid/loaded when
 pre-faulting SPTEs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+23786faffb695f17edaa@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Error out if kvm_mmu_reload() fails when pre-faulting memory, as trying to
fault-in SPTEs will fail miserably due to root.hpa pointing at garbage.

Note, kvm_mmu_reload() can return -EIO and thus trigger the WARN on -EIO
in kvm_vcpu_pre_fault_memory(), but all such paths also WARN, i.e. the
WARN isn't user-triggerable and won't run afoul of warn-on-panic because
the kernel would already be panicking.

  BUG: unable to handle page fault for address: 000029ffffffffe8
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: Oops: 0000 [#1] PREEMPT SMP
  CPU: 22 PID: 1069 Comm: pre_fault_memor Not tainted 6.10.0-rc7-332d2c1d713e-next-vm #548
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:is_page_fault_stale+0x3e/0xe0 [kvm]
  RSP: 0018:ffffc9000114bd48 EFLAGS: 00010206
  RAX: 00003fffffffffc0 RBX: ffff88810a07c080 RCX: ffffc9000114bd78
  RDX: ffff88810a07c080 RSI: ffffea0000000000 RDI: ffff88810a07c080
  RBP: ffffc9000114bd78 R08: 00007fa3c8c00000 R09: 8000000000000225
  R10: ffffea00043d7d80 R11: 0000000000000000 R12: ffff88810a07c080
  R13: 0000000100000000 R14: ffffc9000114be58 R15: 0000000000000000
  FS:  00007fa3c9da0740(0000) GS:ffff888277d80000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 000029ffffffffe8 CR3: 000000011d698000 CR4: 0000000000352eb0
  Call Trace:
   <TASK>
   kvm_tdp_page_fault+0xcc/0x160 [kvm]
   kvm_mmu_do_page_fault+0xfb/0x1f0 [kvm]
   kvm_arch_vcpu_pre_fault_memory+0xd0/0x1a0 [kvm]
   kvm_vcpu_ioctl+0x761/0x8c0 [kvm]
   __x64_sys_ioctl+0x82/0xb0
   do_syscall_64+0x5b/0x160
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
   </TASK>
  Modules linked in: kvm_intel kvm
  CR2: 000029ffffffffe8
  ---[ end trace 0000000000000000 ]---

Fixes: 6e01b7601dfe ("KVM: x86: Implement kvm_arch_vcpu_pre_fault_memory()")
Reported-by: syzbot+23786faffb695f17edaa@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/0000000000002b84dc061dd73544@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Haven't seen a reproducer from syzbot, but I verified by forcing the same
root allocation failure (to generate the above splat).

 arch/x86/kvm/mmu/mmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 901be9e420a4..ee516baf3a31 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4747,7 +4747,9 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 	 * reload is efficient when called repeatedly, so we can do it on
 	 * every iteration.
 	 */
-	kvm_mmu_reload(vcpu);
+	r = kvm_mmu_reload(vcpu);
+	if (r)
+		return r;
 
 	if (kvm_arch_has_private_mem(vcpu->kvm) &&
 	    kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(range->gpa)))

base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.45.2.1089.g2a221341d9-goog


