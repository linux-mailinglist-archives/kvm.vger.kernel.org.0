Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198D53FC0B9
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 04:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239353AbhHaCPH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 22:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239339AbhHaCPG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 22:15:06 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FDBC061575;
        Mon, 30 Aug 2021 19:14:11 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id w7so14132705pgk.13;
        Mon, 30 Aug 2021 19:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=g5V5j8DWby/8xr1tG0O71qMLwIMbKtLkCRL8/HbV/wA=;
        b=NjZ2YbxxI6zuI69xWceGKEiKIl6JkeVB9FzEeObQVcyIkPRcIl11eh4dSjSfFNPJb+
         22j2QikdJ30BVWh77FV6EKCNnr8v5NM0N4tHZGq7foJTOik6I8phb0oJMAHKS3ItNBDu
         PXnW8JnieMjHjpU0Rszpb/pwyNBsTQKHRS27uwOWwU8KnkYLW/PRjoVTFvYKpdpByFOO
         /Ez3EVHhH/96FXig6SxZ9tAowHpUEwc8S8pRQZrdSkvxVUnqhNie7tz3DL2mNVWE5GGy
         YSrKZz42hngxMD8GZngpzcmGOSfecUyW8/H2dT645Udaw5ROnU/BBdXtf96WoytePu7S
         2V7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=g5V5j8DWby/8xr1tG0O71qMLwIMbKtLkCRL8/HbV/wA=;
        b=sxwGwvkDgZPY0LZXPbLmr++8By8h//oRCh8BeejDntEmqW+kBLj1LzpW4OyNrlzepJ
         irVvpPii45SlcWkhFFjeQ1LbzO0gjkRWQ4Bs8UK7nldVKHXR6Z82rFKStpI2Az1EroG0
         oTKgYpFbIRSoug9PcR4H44To9QNn4lyYhXKZmDPJgo0EuvFsWfcp+Xee8THPUJzGLU8r
         yPYIiJU+6xBpmxm8Qm4Mfli6KE0wSUtZrghOaFsFw3tKnBc9J0m34Glfmgls/0zAvpvE
         9hp8jUY8o7OhTyLx78+8/QGFLSGum7VPzdwVm+Q0itvz9nCvECoP19FsI3xc9V+ifdzR
         7I0A==
X-Gm-Message-State: AOAM533sYYamOnV27DOvPI62fuOhjkz/hWspNNnhLONgfgdboITP6P4p
        ma0EbhtNKUz45cMTw0xWO7zWy4WA/NVGPkf/
X-Google-Smtp-Source: ABdhPJyxQGZCTfnzaD+fn7tUZTdd/O+ty2sKoJAaOYPfOm4DfP54hYA7bbqZZtVUOqUcvmXpu47FkA==
X-Received: by 2002:a63:4b4c:: with SMTP id k12mr16328770pgl.172.1630376051256;
        Mon, 30 Aug 2021 19:14:11 -0700 (PDT)
Received: from localhost.localdomain ([162.14.21.36])
        by smtp.gmail.com with ESMTPSA id l19sm729876pjq.10.2021.08.30.19.14.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Aug 2021 19:14:10 -0700 (PDT)
From:   tcs.kernel@gmail.com
X-Google-Original-From: tcs_kernel@tencent.com
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>
Subject: [PATCH] KVM: x86: Add a return code and check kvm_page_track_init
Date:   Tue, 31 Aug 2021 10:14:00 +0800
Message-Id: <1630376040-20567-1-git-send-email-tcs_kernel@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haimin Zhang <tcs_kernel@tencent.com>

We found a null pointer deref by our modified syzkaller.
 KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
 CPU: 1 PID: 13993 Comm: syz-executor.0 Kdump: loaded Tainted: 
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
 BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
 RIP: 0010:rcu_segcblist_enqueue+0xf5/0x1d0 
 RSP: 0018:ffffc90001e1fc10 EFLAGS: 00010046
 RAX: dffffc0000000000 RBX: ffff888135c00080 RCX: ffffffff815ba8a1
 RDX: 0000000000000000 RSI: ffffc90001e1fd00 RDI: ffff888135c00080
 RBP: ffff888135c000a0 R08: 0000000000000004 R09: fffff520003c3f75
 R10: 0000000000000003 R11: fffff520003c3f75 R12: 0000000000000000
 R13: ffff888135c00080 R14: ffff888135c00040 R15: 0000000000000000
 FS:  00007fecc99f1700(0000) GS:ffff888135c00000(0000) knlGS:0000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000001b2f225000 CR3: 0000000093d08000 CR4: 0000000000750ee0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 PKRU: 55555554
 Call Trace:
 srcu_gp_start_if_needed+0x158/0xc60 build/../kernel/rcu/srcutree.c:823
 __synchronize_srcu+0x1dc/0x250 build/../kernel/rcu/srcutree.c:929
 kvm_mmu_uninit_vm+0x18/0x30 build/../arch/x86/kvm/mmu/mmu.c:5585
 kvm_arch_destroy_vm+0x43f/0x5c0 build/../arch/x86/kvm/x86.c:11277
 kvm_create_vm build/../arch/x86/kvm/../../../virt/kvm/kvm_main.c:1060 
 kvm_dev_ioctl_create_vm build/../arch/x86/kvm/../../../virt/kvm/kvm_main
 kvm_dev_ioctl+0xdfb/0x1860 build/../arch/x86/kvm/../../../virt/kvm/kvm_main
 vfs_ioctl build/../fs/ioctl.c:51 [inline]
 __do_sys_ioctl build/../fs/ioctl.c:1069 [inline]
 __se_sys_ioctl build/../fs/ioctl.c:1055 [inline]
 __x64_sys_ioctl+0x183/0x210 build/../fs/ioctl.c:1055
 do_syscall_x64 build/../arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x34/0xb0 build/../arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
This is because when init_srcu_struct() calls alloc_percpu(struct
srcu_data) failed, kvm_page_track_init() didn't check init_srcu_struct
return code. 

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

