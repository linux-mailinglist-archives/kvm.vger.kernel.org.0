Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41F0EF74BE
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 14:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfKKNZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 08:25:49 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44181 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbfKKNZr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 08:25:47 -0500
Received: by mail-wr1-f67.google.com with SMTP id f2so14578439wrs.11;
        Mon, 11 Nov 2019 05:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cgaP4CM+Ld92kjauj0hAJd9jloxavzxYcznYyyWs8P0=;
        b=HlJap5qgPKeyY2OAT0xD92x9hUvjG4dAsQe7r3A9RrIxakt1TdKMQqZW+17e3rHq8x
         yIySwRidYiAa4PsLGQ2xLuxJkc3K5H9Zd4DLzbZHECqi9nC7nWWDg0o4MUXHeSSjUcsD
         bTVBK2A6NnqTn8xwsKyoHQZsl6EMgPNgrqO8R0C0mz9J3urvgZE7LM0DHTOljsqZ3lF9
         d5kY7AYtuybCV2IZW3cTHCRzawI9cp3Oi45UtGaf8jpp0TEGBOLOsZpPbLm/Tu5Th8Ap
         LKgChbyZ4EyDsqbxFq7Yt1qrpP29bi4g9YyoNkb/ze3ShoqZIAK5xsXhKZZc/aNzWGoi
         8mjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=cgaP4CM+Ld92kjauj0hAJd9jloxavzxYcznYyyWs8P0=;
        b=G5bs23f9RjcUpywUZD1FLK66WdxlrYjUSjv/Uo3yKQwYewNqVIj80e9pjfjBcMG2PC
         J6Uai+vRtUZcza4Ir6ejf7B0xISVLRsn8XYhJYboGGWkcUg/BBIDCRLzcEi9g3RzyEB2
         wPCCZvEA6NcKs1Ht/8uCf/11Gf/m+Otu3ZndN6PmNNq/a4+shQ0TkOVp9SJm9mkiBxFa
         UDiOu1UfA22ETulKnnSZC10wE5i0sRL1/D0yQW8weTpJ6Vk2bLB03qCK6izuSXPxHVme
         y1MMKU04zdbNfeTIDsKuF/reEZmDfYIZOoKXSpzZk1M7bvUpdS6PSAk6S5XfsthDIFf2
         7TEw==
X-Gm-Message-State: APjAAAVNDnza2uFQo7rswqIerS5rA41QoS4sBYuhFqEKOBy9HJK4RtQu
        /CM0mccDyi5UhmLLAcGG0g6nz2Md
X-Google-Smtp-Source: APXvYqzN1OYAw3H9KqAqbBcd0+XqONzKKF2E681lwA/dCOhnt2xUF7u7CCvTlZ6F3DhOYhByafUi8w==
X-Received: by 2002:adf:e78c:: with SMTP id n12mr19268205wrm.94.1573478744817;
        Mon, 11 Nov 2019 05:25:44 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id p1sm7555131wmc.38.2019.11.11.05.25.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Nov 2019 05:25:43 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jmattson@google.com, wanpengli@tencent.com,
        Junaid Shahid <junaids@google.com>
Subject: [PATCH 1/2] KVM: Fix NULL-ptr deref after kvm_create_vm fails
Date:   Mon, 11 Nov 2019 14:25:40 +0100
Message-Id: <1573478741-30959-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573478741-30959-1-git-send-email-pbonzini@redhat.com>
References: <1573478741-30959-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reported by syzkaller:

    kasan: CONFIG_KASAN_INLINE enabled
    kasan: GPF could be caused by NULL-ptr deref or user memory access
    general protection fault: 0000 [#1] PREEMPT SMP KASAN
    CPU: 0 PID: 14727 Comm: syz-executor.3 Not tainted 5.4.0-rc4+ #0
    RIP: 0010:kvm_coalesced_mmio_init+0x5d/0x110 arch/x86/kvm/../../../virt/kvm/coalesced_mmio.c:121
    Call Trace:
     kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:3446 [inline]
     kvm_dev_ioctl+0x781/0x1490 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3494
     vfs_ioctl fs/ioctl.c:46 [inline]
     file_ioctl fs/ioctl.c:509 [inline]
     do_vfs_ioctl+0x196/0x1150 fs/ioctl.c:696
     ksys_ioctl+0x62/0x90 fs/ioctl.c:713
     __do_sys_ioctl fs/ioctl.c:720 [inline]
     __se_sys_ioctl fs/ioctl.c:718 [inline]
     __x64_sys_ioctl+0x6e/0xb0 fs/ioctl.c:718
     do_syscall_64+0xca/0x5d0 arch/x86/entry/common.c:290
     entry_SYSCALL_64_after_hwframe+0x49/0xbe

Commit 9121923c457d ("kvm: Allocate memslots and buses before calling kvm_arch_init_vm")
moves memslots and buses allocations around, however, if kvm->srcu/irq_srcu fails
initialization, NULL will be returned instead of error code, NULL will not be intercepted
in kvm_dev_ioctl_create_vm() and be deferenced by kvm_coalesced_mmio_init(), this patch
fixes it.

Moving the initialization is required anyway to avoid an incorrect synchronize_srcu that
was also reported by syzkaller:

 wait_for_completion+0x29c/0x440 kernel/sched/completion.c:136
 __synchronize_srcu+0x197/0x250 kernel/rcu/srcutree.c:921
 synchronize_srcu_expedited kernel/rcu/srcutree.c:946 [inline]
 synchronize_srcu+0x239/0x3e8 kernel/rcu/srcutree.c:997
 kvm_page_track_unregister_notifier+0xe7/0x130 arch/x86/kvm/page_track.c:212
 kvm_mmu_uninit_vm+0x1e/0x30 arch/x86/kvm/mmu.c:5828
 kvm_arch_destroy_vm+0x4a2/0x5f0 arch/x86/kvm/x86.c:9579
 kvm_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:702 [inline]

so do it.

Reported-by: syzbot+89a8060879fa0bd2db4f@syzkaller.appspotmail.com
Reported-by: syzbot+e27e7027eb2b80e44225@syzkaller.appspotmail.com
Fixes: 9121923c457d ("kvm: Allocate memslots and buses before calling kvm_arch_init_vm")
Cc: Jim Mattson <jmattson@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d6f0696d98ef..e22ff63e5b1a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -645,6 +645,11 @@ static struct kvm *kvm_create_vm(unsigned long type)
 
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
 
+	if (init_srcu_struct(&kvm->srcu))
+		goto out_err_no_srcu;
+	if (init_srcu_struct(&kvm->irq_srcu))
+		goto out_err_no_irq_srcu;
+
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 		struct kvm_memslots *slots = kvm_alloc_memslots();
 
@@ -675,11 +680,6 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
 #endif
 
-	if (init_srcu_struct(&kvm->srcu))
-		goto out_err_no_srcu;
-	if (init_srcu_struct(&kvm->irq_srcu))
-		goto out_err_no_irq_srcu;
-
 	r = kvm_init_mmu_notifier(kvm);
 	if (r)
 		goto out_err;
@@ -693,10 +693,6 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	return kvm;
 
 out_err:
-	cleanup_srcu_struct(&kvm->irq_srcu);
-out_err_no_irq_srcu:
-	cleanup_srcu_struct(&kvm->srcu);
-out_err_no_srcu:
 	hardware_disable_all();
 out_err_no_disable:
 	kvm_arch_destroy_vm(kvm);
@@ -706,6 +702,10 @@ static struct kvm *kvm_create_vm(unsigned long type)
 		kfree(kvm_get_bus(kvm, i));
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
 		kvm_free_memslots(kvm, __kvm_memslots(kvm, i));
+	cleanup_srcu_struct(&kvm->irq_srcu);
+out_err_no_irq_srcu:
+	cleanup_srcu_struct(&kvm->srcu);
+out_err_no_srcu:
 	kvm_arch_free_vm(kvm);
 	mmdrop(current->mm);
 	return ERR_PTR(r);
-- 
1.8.3.1


