Return-Path: <kvm+bounces-36584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E228EA1BF1C
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 00:47:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CC961188C3D6
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 23:47:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD7AD1EEA29;
	Fri, 24 Jan 2025 23:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xe2xaP2z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C461E7C3D
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 23:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737762426; cv=none; b=dDQT5p6l8vEThkpYQpumdMwxcIgqEwPsGuSZ9HOMQerKHcq4Pz9fU3jDhYMXKEG4sUW20DMpaaZY1opdyYGGfqJwSLdOqKXXCZtcPe9xEozVFkNtOE9AIB8Lq8YqstKCcRY+GVb+lqgNYbAPPUuy/6gPYuMo3nE0eTOm7I1RwmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737762426; c=relaxed/simple;
	bh=fhv6fbic2s0quh3OAunJsF/luT1qeIOYufNBDSqGvto=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ByZq489MJV7qn4TYnmnGx1YGOWB+QTiTVdAKJPJ40lvEedpjZqlXCB9Io+jz0IOPdJGchm8Lwo0vhErAjGkNZTP9elomZelaq7A69wDGhGOrOGTvHVPSI1ptbMisGRjyQPUQ5LPRmqxoObCmHE8zr7WGmaJeLK+WV68TShOejlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xe2xaP2z; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef909597d9so7486352a91.3
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 15:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737762424; x=1738367224; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xZqSdmAP4JAfn0GgCRDW/fYFltIoNyRnJ22thKN56cQ=;
        b=Xe2xaP2z42NGdES5/jI+wFuLbu6PsGLHjyND7yNyq+Gw7UWQDBPUEzRm0+lpRKBZLB
         TssE1zjN/gYpos+APxLEB3JOT2qcHLZzo0KMeBqYLhmB8gTVReZDIzQtXFZiKf8xlvyA
         h+g6evoHjhReGrZUcxsgoIM5Zf1HTlSBxJdb837e9Ovv+LxIJ61Z55VGqz2UbOXrTAIV
         dIbk7UffljScaGU5Y+x7x7LFxmDaiYqaNe384PJ4DyMgeqHML0KpX7vVYnTOWpOKzngP
         2ccDneq1ns8R3hUICg72C3SA7WoN/7bgfBWJns4oL2YRzqfg9O9on06aD0k44Z3JNkpT
         8VuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737762424; x=1738367224;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xZqSdmAP4JAfn0GgCRDW/fYFltIoNyRnJ22thKN56cQ=;
        b=FetMEN2Hv03xEUgoCZT2eNyIklUL2UwLaQG8lbVARzt/OqCKjv0uypFfW9JYZHuVdX
         DP1Kgdnm4dzibkq72KyWq7pElGSzB92fDH6nbY2Fnf8uCTU1zVVsfZJ/MSNj4D1rI5Yv
         DPEqfMa4vph9ldo+LiHFhhz3lfltxQy9NUbDOAr3yNKiFtiR1IFWE2Cr3OE8XPvbwPZO
         0bixfuU9ABNbJDvyTYdtFOQ2i92gSLzj9LUW+USzZIRw5AqNyNfESiMxGDZxzCjga7Eh
         TO3TZViRjVjbZ/anPMi/7+YR8bg01wKx24WeYD7JXpyc+8o3QCI/g/MQRfw8iubWebMB
         4suQ==
X-Gm-Message-State: AOJu0Yyh/RQN/XL80fWpokAPYRHqqvNqses9IAGH43AkxrdKmsp8rdOS
	Tla8sUuUlZZT1nf8qfJNUfOLMgItf5C38aVZjsvfRCKZsOZGElWiwuFpv1QLCCqRA7MrMu8wozr
	jAw==
X-Google-Smtp-Source: AGHT+IFiedBo0HwyMC9WduQOva9J3+TGiP5ylctgfBsgVX+RBYKVPFWUUH/l3n71CNB8yD1/yv+VcEwXHU8=
X-Received: from pfbcz18.prod.google.com ([2002:aa7:9312:0:b0:72a:f9c7:a2ed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:288e:b0:72d:2444:da2d
 with SMTP id d2e1a72fcca58-72dafa03216mr39235754b3a.9.1737762423719; Fri, 24
 Jan 2025 15:47:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 24 Jan 2025 15:46:23 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250124234623.3609069-1-seanjc@google.com>
Subject: [PATCH] KVM: x86/mmu: Ensure NX huge page recovery thread is alive
 before waking
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"

When waking a VM's NX huge page recovery thread, ensure the thread is
actually alive before trying to wake it.  Now that the thread is spawned
on-demand during KVM_RUN, a VM without a recovery thread is reachable via
the related module params.

  BUG: kernel NULL pointer dereference, address: 0000000000000040
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:vhost_task_wake+0x5/0x10
  Call Trace:
   <TASK>
   set_nx_huge_pages+0xcc/0x1e0 [kvm]
   param_attr_store+0x8a/0xd0
   module_attr_store+0x1a/0x30
   kernfs_fop_write_iter+0x12f/0x1e0
   vfs_write+0x233/0x3e0
   ksys_write+0x60/0xd0
   do_syscall_64+0x5b/0x160
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
  RIP: 0033:0x7f3b52710104
   </TASK>
  Modules linked in: kvm_intel kvm
  CR2: 0000000000000040

Fixes: 931656b9e2ff ("kvm: defer huge page recovery vhost task to later")
Cc: stable@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a45ae60e84ab..74c20dbb92da 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7120,6 +7120,19 @@ static void mmu_destroy_caches(void)
 	kmem_cache_destroy(mmu_page_header_cache);
 }
 
+static void kvm_wake_nx_recovery_thread(struct kvm *kvm)
+{
+	/*
+	 * The NX recovery thread is spawned on-demand at the first KVM_RUN and
+	 * may not be valid even though the VM is globally visible.  Do nothing,
+	 * as such a VM can't have any possible NX huge pages.
+	 */
+	struct vhost_task *nx_thread = READ_ONCE(kvm->arch.nx_huge_page_recovery_thread);
+
+	if (nx_thread)
+		vhost_task_wake(nx_thread);
+}
+
 static int get_nx_huge_pages(char *buffer, const struct kernel_param *kp)
 {
 	if (nx_hugepage_mitigation_hard_disabled)
@@ -7180,7 +7193,7 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 			kvm_mmu_zap_all_fast(kvm);
 			mutex_unlock(&kvm->slots_lock);
 
-			vhost_task_wake(kvm->arch.nx_huge_page_recovery_thread);
+			kvm_wake_nx_recovery_thread(kvm);
 		}
 		mutex_unlock(&kvm_lock);
 	}
@@ -7315,7 +7328,7 @@ static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel
 		mutex_lock(&kvm_lock);
 
 		list_for_each_entry(kvm, &vm_list, vm_list)
-			vhost_task_wake(kvm->arch.nx_huge_page_recovery_thread);
+			kvm_wake_nx_recovery_thread(kvm);
 
 		mutex_unlock(&kvm_lock);
 	}
@@ -7451,14 +7464,20 @@ static void kvm_mmu_start_lpage_recovery(struct once *once)
 {
 	struct kvm_arch *ka = container_of(once, struct kvm_arch, nx_once);
 	struct kvm *kvm = container_of(ka, struct kvm, arch);
+	struct vhost_task *nx_thread;
 
 	kvm->arch.nx_huge_page_last = get_jiffies_64();
-	kvm->arch.nx_huge_page_recovery_thread = vhost_task_create(
-		kvm_nx_huge_page_recovery_worker, kvm_nx_huge_page_recovery_worker_kill,
-		kvm, "kvm-nx-lpage-recovery");
+	nx_thread = vhost_task_create(kvm_nx_huge_page_recovery_worker,
+				      kvm_nx_huge_page_recovery_worker_kill,
+				      kvm, "kvm-nx-lpage-recovery");
 
-	if (kvm->arch.nx_huge_page_recovery_thread)
-		vhost_task_start(kvm->arch.nx_huge_page_recovery_thread);
+	if (!nx_thread)
+		return;
+
+	vhost_task_start(nx_thread);
+
+	/* Make the task visible only once it is fully started. */
+	WRITE_ONCE(kvm->arch.nx_huge_page_recovery_thread, nx_thread);
 }
 
 int kvm_mmu_post_init_vm(struct kvm *kvm)

base-commit: f7bafceba76e9ab475b413578c1757ee18c3e44b
-- 
2.48.1.262.g85cc9f2d1e-goog


