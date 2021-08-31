Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528223FC09E
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 03:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239315AbhHaCAt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 22:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235217AbhHaCAs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 22:00:48 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC4BC061575;
        Mon, 30 Aug 2021 18:59:54 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id s29so8868682pfw.5;
        Mon, 30 Aug 2021 18:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FjjvvKUvovp7mtNpD8uUaZFWmS34W3KCKexOJFyA59Q=;
        b=qeu9rt5pDeVTOiXodunCcBnTJL5mGNdrZMjCnvdQADtVRtwRoSJAwPbROImzLeVv4J
         sb0pS9oprsTY0tLVE8FRLlChHIMcAQztitdhhZjBCePIkWvjjzGsPNnI8YvE8eOvFYbp
         8orGbN6z+J2i9w8iD7pibDGBzoKUBAahP5FEteK03w9M4iXyIokco9E5L6QSeFRhhXnl
         5pneq1LTtJn7x938JNXs+6DMp8sq5Jc6qyfWeJYRUg5wv6+4b+Q2Xcw3vsXmxfwY6QeX
         fuJYImMpJ8oj3p7rbrNydUyBhTxagMGzlSk9ZtYz9eeH26av/HE2SRtr70cd2Z6Xis06
         5z9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FjjvvKUvovp7mtNpD8uUaZFWmS34W3KCKexOJFyA59Q=;
        b=ZS7WK3vrnSYNshClMj02GX3TPmDvFawcml7X3H+J06WBikKQMtgcRo+z4bKQMZGNgm
         oNk/ouGL94C5WEAuD14oK0oDiooAdrYlF0RI4yGuTAhnXsbJxrdgJn+s/A3ik36YfbHC
         Lm/98I26PDDtk6B/6UDXaUOiJOkctQyMKBkQDwE0pg6iyMCP0C/eBgGz4g5y74PlB5hz
         q8VdycKAC4kY7Kk7dfpWtP2wbHrJCntNAhwgSqsRQbt7OHmaigXo7VlzwxiQESSXC2S9
         A0S5YDAAoatp8b57pN3HLm92dEVbbS58jZ36LURjdFm5ejT4MXT39pUbJt+nDB9wV/u6
         CESw==
X-Gm-Message-State: AOAM530IJqLVOVURM879BH0dsO9nbp7mIj1oznHC03q3C20oPfkHdwo2
        4EXqFuh70KTvMCSp3Z98bP0=
X-Google-Smtp-Source: ABdhPJwdkxcXN7P+kpOFPvVyJC4nLrkpPDWNNxe7l1Kx1rD/5P1pDPVMoIQ88TlKU+bVLYU53js4sQ==
X-Received: by 2002:a63:7405:: with SMTP id p5mr24302939pgc.426.1630375193927;
        Mon, 30 Aug 2021 18:59:53 -0700 (PDT)
Received: from localhost.localdomain ([162.14.21.36])
        by smtp.gmail.com with ESMTPSA id t42sm15308008pfg.30.2021.08.30.18.59.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Aug 2021 18:59:53 -0700 (PDT)
From:   tcs.kernel@gmail.com
X-Google-Original-From: tcs_kernel@tencent.com
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>
Subject: [PATCH] KVM: x86: Add a return code and check kvm_page_track_init We
 found a null pointer deref by our modified syzkaller. KASAN: null-ptr-deref
 in range [0x0000000000000000-0x0000000000000007] CPU: 1 PID: 13993 Comm:
 syz-executor.0 Kdump: loaded Tainted: G            E     5.14.0-rc7+ #2
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
 rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014 RIP:
 0010:rcu_segcblist_enqueue+0xf5/0x1d0 build/../kernel/rcu/rcu_segcblist.c:348
 RSP: 0018:ffffc90001e1fc10 EFLAGS: 00010046 RAX: dffffc0000000000 RBX:
 ffff888135c00080 RCX: ffffffff815ba8a1 RDX: 0000000000000000 RSI:
 ffffc90001e1fd00 RDI: ffff888135c00080 RBP: ffff888135c000a0 R08:
 0000000000000004 R09: fffff520003c3f75 R10: 0000000000000003 R11:
 fffff520003c3f75 R12: 0000000000000000 R13: ffff888135c00080 R14:
 ffff888135c00040 R15: 0000000000000000 FS:  00007fecc99f1700(0000)
 GS:ffff888135c00000(0000) knlGS:0000000000000000 CS:  0010 DS: 0000 ES: 0000
 CR0: 0000000080050033 CR2: 0000001b2f225000 CR3: 0000000093d08000 CR4:
 0000000000750ee0 DR0: 0000000000000000 DR1: 0000000000000000 DR2:
 0000000000000000 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
 0000000000000400 PKRU: 55555554 Call Trace: srcu_gp_start_if_needed+0x158/0xc60
 build/../kernel/rcu/srcutree.c:823 __synchronize_srcu+0x1dc/0x250
 build/../kernel/rcu/srcutree.c:929 kvm_mmu_uninit_vm+0x18/0x30
 build/../arch/x86/kvm/mmu/mmu.c:5585 kvm_arch_destroy_vm+0x43f/0x5c0
 build/../arch/x86/kvm/x86.c:11277 kvm_create_vm build/../arch/x86/kvm/../../../virt/kvm/kvm_main.c:1060
 [inline] kvm_dev_ioctl_create_vm build/../arch/x86/kvm/../../../virt/kvm/kvm_main.c:4486
 [inline] kvm_dev_ioctl+0xdfb/0x1860 build/../arch/x86/kvm/../../../virt/kvm/kvm_main.c:4541
 vfs_ioctl build/../fs/ioctl.c:51 [inline] __do_sys_ioctl build/../fs/ioctl.c:1069
 [inline] __se_sys_ioctl build/../fs/ioctl.c:1055 [inline] __x64_sys_ioctl+0x183/0x210
 build/../fs/ioctl.c:1055 do_syscall_x64 build/../arch/x86/entry/common.c:50
 [inline] do_syscall_64+0x34/0xb0 build/../arch/x86/entry/common.c:80 entry_SYSCALL_64_after_hwframe+0x44/0xae
Date:   Tue, 31 Aug 2021 09:59:32 +0800
Message-Id: <1630375172-18160-1-git-send-email-tcs_kernel@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haimin Zhang <tcs_kernel@tencent.com>

Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
Reported-by: TCS Robot <tcs_robot@tencent.com>
---
 arch/x86/include/asm/kvm_page_track.h | 2 +-
 arch/x86/kvm/mmu/page_track.c         | 8 ++++++--
 arch/x86/kvm/x86.c                    | 7 +++++--
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 87bd6025d91d..6a5f3acf2b33 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -46,7 +46,7 @@ struct kvm_page_track_notifier_node {
 			    struct kvm_page_track_notifier_node *node);
 };
 
-void kvm_page_track_init(struct kvm *kvm);
+int kvm_page_track_init(struct kvm *kvm);
 void kvm_page_track_cleanup(struct kvm *kvm);
 
 void kvm_page_track_free_memslot(struct kvm_memory_slot *slot);
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 91a9f7e0fd91..44a67a50f6d2 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -163,13 +163,17 @@ void kvm_page_track_cleanup(struct kvm *kvm)
 	cleanup_srcu_struct(&head->track_srcu);
 }
 
-void kvm_page_track_init(struct kvm *kvm)
+int kvm_page_track_init(struct kvm *kvm)
 {
+	int r = -ENOMEM;
 	struct kvm_page_track_notifier_head *head;
 
 	head = &kvm->arch.track_notifier_head;
-	init_srcu_struct(&head->track_srcu);
+	r = init_srcu_struct(&head->track_srcu);
+	if (r)
+		return r;
 	INIT_HLIST_HEAD(&head->track_notifier_list);
+	return r;
 }
 
 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e5d5c5ed7dd4..5da76f989207 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11086,8 +11086,9 @@ void kvm_arch_free_vm(struct kvm *kvm)
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
+	int r = -EINVAL;
 	if (type)
-		return -EINVAL;
+		return r;
 
 	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
@@ -11121,7 +11122,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	kvm_apicv_init(kvm);
 	kvm_hv_init_vm(kvm);
-	kvm_page_track_init(kvm);
+	r = kvm_page_track_init(kvm);
+	if (r)
+		return r;
 	kvm_mmu_init_vm(kvm);
 
 	return static_call(kvm_x86_vm_init)(kvm);
-- 
2.27.0

