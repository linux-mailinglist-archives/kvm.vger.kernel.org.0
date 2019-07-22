Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 031736F875
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2019 06:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbfGVE03 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jul 2019 00:26:29 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38708 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727404AbfGVE03 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jul 2019 00:26:29 -0400
Received: by mail-pl1-f194.google.com with SMTP id az7so18552024plb.5;
        Sun, 21 Jul 2019 21:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KkQ+Pf6+qToCR37/fN3WwGFZWrKUQApYlq4rvuPnwdM=;
        b=UMHZ+vKEgfICcULWelNdpMFtjDrGGeWbirtEqMLDBazIKNkXIxBOzORVSj+IWXigfP
         lW1G14yX9+pjePMWtHJPv7gfsGkl4FV7J3/ZOg2KcE6ShNvwFpRdr3gw5dZZqFgBiPrD
         6gKKq5dMkxfQItddrXM78QNAIa1SibQIP74lyXnUWt6dfu/VeiwSfkruWQ6hj8uugI8C
         urHrXZMVrJGUz3LGwE7g5HTCHr0eYl6B20LmOw6ccRNCDyKTO42Ynvawx/MQbVpBmbDx
         gAQPv0v0i06QObd4a7okMRUrpyO7dOw/lRzWU/JAJKY7sps8JiNBYCTVW0IK/qEb8xNv
         +lbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KkQ+Pf6+qToCR37/fN3WwGFZWrKUQApYlq4rvuPnwdM=;
        b=c7f2wA/4YUeVUwtAF9kHkJPSbj78e1QnQLHexDP4CWnuXPfMyXVISEIzxPzkTnOYYs
         GjQaVI5i3KllYtPfkJL8MOAjfzGyULE7QV1pwtu7pnLpWrp9WVVwlOqfonSjZMq9ZelM
         h3kI+CnPmwww61ifGwtlQoAu/6OtsnUAVaZEN7UTaH4bQja7o9Z7otw9haLfVRY/VsE8
         Rkicp0ZH1fSeye+cKT0WRLXRUv2XZdWtV1hwKWimoOaTI0Dpt0PiZ4Gwqwd7lBD8F4PX
         A2lnqx6F0XjQQ+MqamTHAsS8yMJXUoCKGThyDiH5d4DFq/tpG6S6/hj/TR6FuZ7D80mJ
         6udg==
X-Gm-Message-State: APjAAAVDUiZbZyPpjEDxkJbM5WlI/mutTX9vJZ5SWSp8o/B5rqWzAJkk
        pYVCoy35g72ljO9f7ZpT5AuD6WyDOLc=
X-Google-Smtp-Source: APXvYqzooHPsRlSTibc76awHb/m7uhXARacTdJ6Wh1ZeBuu2i/mFRc3kI4AmUc//gnr1bDDlhch9yQ==
X-Received: by 2002:a17:902:b08a:: with SMTP id p10mr73916631plr.83.1563769588393;
        Sun, 21 Jul 2019 21:26:28 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id r9sm17108217pjq.3.2019.07.21.21.26.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 21 Jul 2019 21:26:27 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 2/2] KVM: X86: Dynamically allocate user_fpu
Date:   Mon, 22 Jul 2019 12:26:21 +0800
Message-Id: <1563769581-20293-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1563769581-20293-1-git-send-email-wanpengli@tencent.com>
References: <1563769581-20293-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

After reverting commit 240c35a3783a (kvm: x86: Use task structs fpu field
for user), struct kvm_vcpu is 19456 bytes on my server, PAGE_ALLOC_COSTLY_ORDER(3)
is the order at which allocations are deemed costly to service. In serveless
scenario, one host can service hundreds/thoudands firecracker/kata-container
instances, howerver, new instance will fail to launch after memory is too
fragmented to allocate kvm_vcpu struct on host, this was observed in some
cloud provider product environments.

This patch dynamically allocates user_fpu, kvm_vcpu is 15168 bytes now on my
Skylake server.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm.c              | 13 ++++++++++++-
 arch/x86/kvm/vmx/vmx.c          | 13 ++++++++++++-
 arch/x86/kvm/x86.c              |  4 ++--
 4 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4f938ac..7b0a4ee 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -616,7 +616,7 @@ struct kvm_vcpu_arch {
 	 * "guest_fpu" state here contains the guest FPU context, with the
 	 * host PRKU bits.
 	 */
-	struct fpu user_fpu;
+	struct fpu *user_fpu;
 	struct fpu *guest_fpu;
 
 	u64 xcr0;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 19f69df..7eafc69 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2143,12 +2143,20 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 		goto out;
 	}
 
+	svm->vcpu.arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
+						     GFP_KERNEL_ACCOUNT);
+	if (!svm->vcpu.arch.user_fpu) {
+		printk(KERN_ERR "kvm: failed to allocate kvm userspace's fpu\n");
+		err = -ENOMEM;
+		goto free_partial_svm;
+	}
+
 	svm->vcpu.arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
 						     GFP_KERNEL_ACCOUNT);
 	if (!svm->vcpu.arch.guest_fpu) {
 		printk(KERN_ERR "kvm: failed to allocate vcpu's fpu\n");
 		err = -ENOMEM;
-		goto free_partial_svm;
+		goto free_user_fpu;
 	}
 
 	err = kvm_vcpu_init(&svm->vcpu, kvm, id);
@@ -2211,6 +2219,8 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	kvm_vcpu_uninit(&svm->vcpu);
 free_svm:
 	kmem_cache_free(x86_fpu_cache, svm->vcpu.arch.guest_fpu);
+free_user_fpu:
+	kmem_cache_free(x86_fpu_cache, svm->vcpu.arch.user_fpu);
 free_partial_svm:
 	kmem_cache_free(kvm_vcpu_cache, svm);
 out:
@@ -2241,6 +2251,7 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 	__free_page(virt_to_page(svm->nested.hsave));
 	__free_pages(virt_to_page(svm->nested.msrpm), MSRPM_ALLOC_ORDER);
 	kvm_vcpu_uninit(vcpu);
+	kmem_cache_free(x86_fpu_cache, svm->vcpu.arch.user_fpu);
 	kmem_cache_free(x86_fpu_cache, svm->vcpu.arch.guest_fpu);
 	kmem_cache_free(kvm_vcpu_cache, svm);
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a279447..074385c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6598,6 +6598,7 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 	free_loaded_vmcs(vmx->loaded_vmcs);
 	kfree(vmx->guest_msrs);
 	kvm_vcpu_uninit(vcpu);
+	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.user_fpu);
 	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.guest_fpu);
 	kmem_cache_free(kvm_vcpu_cache, vmx);
 }
@@ -6613,12 +6614,20 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	if (!vmx)
 		return ERR_PTR(-ENOMEM);
 
+	vmx->vcpu.arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
+			GFP_KERNEL_ACCOUNT);
+	if (!vmx->vcpu.arch.user_fpu) {
+		printk(KERN_ERR "kvm: failed to allocate kvm userspace's fpu\n");
+		err = -ENOMEM;
+		goto free_partial_vcpu;
+	}
+
 	vmx->vcpu.arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
 			GFP_KERNEL_ACCOUNT);
 	if (!vmx->vcpu.arch.guest_fpu) {
 		printk(KERN_ERR "kvm: failed to allocate vcpu's fpu\n");
 		err = -ENOMEM;
-		goto free_partial_vcpu;
+		goto free_user_fpu;
 	}
 
 	vmx->vpid = allocate_vpid();
@@ -6721,6 +6730,8 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 free_vcpu:
 	free_vpid(vmx->vpid);
 	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.guest_fpu);
+free_user_fpu:
+	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.user_fpu);
 free_partial_vcpu:
 	kmem_cache_free(kvm_vcpu_cache, vmx);
 	return ERR_PTR(err);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bdcd250..09dbc93 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8272,7 +8272,7 @@ static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 {
 	fpregs_lock();
 
-	copy_fpregs_to_fpstate(&vcpu->arch.user_fpu);
+	copy_fpregs_to_fpstate(vcpu->arch.user_fpu);
 	/* PKRU is separately restored in kvm_x86_ops->run.  */
 	__copy_kernel_to_fpregs(&vcpu->arch.guest_fpu->state,
 				~XFEATURE_MASK_PKRU);
@@ -8289,7 +8289,7 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 	fpregs_lock();
 
 	copy_fpregs_to_fpstate(vcpu->arch.guest_fpu);
-	copy_kernel_to_fpregs(&vcpu->arch.user_fpu.state);
+	copy_kernel_to_fpregs(&vcpu->arch.user_fpu->state);
 
 	fpregs_mark_activate();
 	fpregs_unlock();
-- 
2.7.4

