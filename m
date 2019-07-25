Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2978074D7C
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 13:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404355AbfGYLtr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 07:49:47 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33858 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404328AbfGYLtq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 07:49:46 -0400
Received: by mail-wr1-f67.google.com with SMTP id 31so50493096wrm.1
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2019 04:49:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5eFHQcAJJ1arMcU18ItSiGCK+xpQYpQYRWNTnt4Sl8M=;
        b=puERPxaQgYv1+uDM1AN0+zE1UpMMNhSlyhu8BFDOwKdk4ds7DAWCowwKXY1gf4Z4jG
         FPosGS/4vvzlH8A/1Zr1coVgWZwmjZbtb5koN1KB+cn8HfN4yznYIFHP+1LKHQY0Y6Gg
         wQ/l5lOzAhjq438lkFSUCjr5NP6nlSjzBjopfd4zgu8sYeemBpZiMRrBcuYOhmnrALE6
         +tXGtNiqnQ4I4fNIWGl0sY2Df4QEevahtKdga/7Xt83RRyb6X7txNd9hu/6Pg/bwriQt
         QakzE85fmILYg/snH7EmbUPzBFDMIORvBJj2uc2vyomodV54PNq7NFND/uALVuEZ9n7q
         7M2Q==
X-Gm-Message-State: APjAAAU9F02G4eRGILWgqiWcnh7yYIRoVl5c3hiRTekMjZDJgHlyK7sd
        tdbCjN9DUwkrDm0oXKNDSZnruUD1Zzs=
X-Google-Smtp-Source: APXvYqwHF+F+rdSQWjhG31Xnxl9xMrRVHiLRHocchVFoV1vta3opzCIwlmlEKq6AN3HyyfnnQNNydw==
X-Received: by 2002:a05:6000:1189:: with SMTP id g9mr57465609wrx.51.1564055383632;
        Thu, 25 Jul 2019 04:49:43 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id t140sm44784683wmt.0.2019.07.25.04.49.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 04:49:42 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH stable-5.1 3/3] Revert "kvm: x86: Use task structs fpu field for user"
Date:   Thu, 25 Jul 2019 13:49:38 +0200
Message-Id: <20190725114938.3976-4-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190725114938.3976-1-vkuznets@redhat.com>
References: <20190725114938.3976-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit ec269475cba7bcdd1eb8fdf8e87f4c6c81a376fe ]

This reverts commit 240c35a3783ab9b3a0afaba0dde7291295680a6b
("kvm: x86: Use task structs fpu field for user", 2018-11-06).
The commit is broken and causes QEMU's FPU state to be destroyed
when KVM_RUN is preempted.

Fixes: 240c35a3783a ("kvm: x86: Use task structs fpu field for user")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 7 ++++---
 arch/x86/kvm/x86.c              | 4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c79abe7ca093..564729a4a25c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -609,15 +609,16 @@ struct kvm_vcpu_arch {
 
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
-	 * In vcpu_run, we switch between the user, maintained in the
-	 * task_struct struct, and guest FPU contexts. While running a VCPU,
-	 * the VCPU thread will have the guest FPU context.
+	 * In vcpu_run, we switch between the user and guest FPU contexts.
+	 * While running a VCPU, the VCPU thread will have the guest FPU
+	 * context.
 	 *
 	 * Note that while the PKRU state lives inside the fpu registers,
 	 * it is switched out separately at VMENTER and VMEXIT time. The
 	 * "guest_fpu" state here contains the guest FPU context, with the
 	 * host PRKU bits.
 	 */
+	struct fpu user_fpu;
 	struct fpu *guest_fpu;
 
 	u64 xcr0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 37028ea85d4c..aede8fa2ea9a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8172,7 +8172,7 @@ static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
 static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 {
 	preempt_disable();
-	copy_fpregs_to_fpstate(&current->thread.fpu);
+	copy_fpregs_to_fpstate(&vcpu->arch.user_fpu);
 	/* PKRU is separately restored in kvm_x86_ops->run.  */
 	__copy_kernel_to_fpregs(&vcpu->arch.guest_fpu->state,
 				~XFEATURE_MASK_PKRU);
@@ -8185,7 +8185,7 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 {
 	preempt_disable();
 	copy_fpregs_to_fpstate(vcpu->arch.guest_fpu);
-	copy_kernel_to_fpregs(&current->thread.fpu.state);
+	copy_kernel_to_fpregs(&vcpu->arch.user_fpu.state);
 	preempt_enable();
 	++vcpu->stat.fpu_reload;
 	trace_kvm_fpu(0);
-- 
2.20.1

