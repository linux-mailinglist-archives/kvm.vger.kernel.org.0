Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31CCD3C536
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 09:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404435AbfFKHed (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 03:34:33 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36071 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404276AbfFKHec (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 03:34:32 -0400
Received: by mail-pl1-f196.google.com with SMTP id d21so4723094plr.3;
        Tue, 11 Jun 2019 00:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mrGW1T2iSqhdTKZCxglyJmU60TY2UWKhtt2t3Ktg1eY=;
        b=lhXh9JzbrCKeEvpkhxKGibIZ9hpRyPXZiS1VvBwpSRo9EZutOEvdOIyKGyzSVDlrhx
         yj3c9E2wA5zPUmMML0UFmKxlyUo2QDyTpX42qNSufnOc2SkmO3xeKRUiSLOBCKrbz7zD
         zCZS7kSsvGlRonmmWITwbvsgAiJF8QyYHxHBMGkCsoRcYOwHsHeDiytpu1tAa5WMkdku
         dr/3rPk4Hw4cDytfmxrjoj6ATrQ7v+y2lUU4XruShnwhhvH16HdNF8Kf8AcsVVLqDHgR
         HkxSf5eVQPqAZCWnYAITogsNUNnzjX9cN4LVb7QmZCmriZ2ke76l+chFO9wWUkFXNzyu
         xYmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mrGW1T2iSqhdTKZCxglyJmU60TY2UWKhtt2t3Ktg1eY=;
        b=jxEdckvuo3ilzgJS+upmlLJ0ZLkBZU/hwx8JeE8I2tn3/jR9tdt+vGP7utka4gBSrC
         2qpw+Mh7See+bpSIKuCCm8hnR1mdlFFcqifY7DWC5KGgZsvGYe2JL48uHKIZxAejCeuZ
         x/Ri56KfmMitUP7sDqUXAyr2eSTFsfIBESkXjOgGzDHmd6sGJVQfK2tQO1N72e/KMuSI
         4qrz/TWIbxHk/IlDzo75TM6gxWV0PlBGovs5LS9J7uNNSMpRrcL7fHaNuT1jMPIeKAwm
         Gr/v/cJ2o+3jxD+cS8LF4VLf1CBOa/XiCIFp4Tr2JBmlAlYhdETYOY7aCJt4ZJV2rz3J
         xgoA==
X-Gm-Message-State: APjAAAUTnZbDaAwAZQmtQ40OrreG4FmkZ+qatgAXDaBhYTI9brnTIxso
        z2iWrmr3qed47VUsUZejBqxEvMYA
X-Google-Smtp-Source: APXvYqzIEA65a11MmHTFreR2/leIesD1hYM/5Xatw3lGgrf0ge5x+VAbkuh+h1t5nNOZ0TI1wtyGiA==
X-Received: by 2002:a17:902:24c:: with SMTP id 70mr74121452plc.2.1560238471181;
        Tue, 11 Jun 2019 00:34:31 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id 14sm6860800pfj.36.2019.06.11.00.34.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 11 Jun 2019 00:34:30 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v2 5/5] KVM: X86: Save/restore residency values when vCPU migrations
Date:   Tue, 11 Jun 2019 15:34:11 +0800
Message-Id: <1560238451-19495-6-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560238451-19495-1-git-send-email-wanpengli@tencent.com>
References: <1560238451-19495-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

To save/restore residency values when vCPU migrates between mulitple 
pCPUs.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/arm/include/asm/kvm_host.h     |  1 +
 arch/arm64/include/asm/kvm_host.h   |  1 +
 arch/mips/include/asm/kvm_host.h    |  1 +
 arch/powerpc/include/asm/kvm_host.h |  1 +
 arch/s390/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/x86.c                  | 38 +++++++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h            |  1 +
 virt/kvm/kvm_main.c                 |  1 +
 8 files changed, 45 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 075e192..5e6a487 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -346,6 +346,7 @@ static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
+static inline void kvm_arch_sched_out(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
 static inline void kvm_arm_init_debug(void) {}
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4bcd9c1..12fec7d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -557,6 +557,7 @@ void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
+static inline void kvm_arch_sched_out(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
 void kvm_arm_init_debug(void);
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 41204a4..217bbfd 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -1136,6 +1136,7 @@ static inline void kvm_arch_free_memslot(struct kvm *kvm,
 		struct kvm_memory_slot *free, struct kvm_memory_slot *dont) {}
 static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
+static inline void kvm_arch_sched_out(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index d10df67..4f5306d 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -854,6 +854,7 @@ static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
 static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
+static inline void kvm_arch_sched_out(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_exit(void) {}
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index da5825a..8710298 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -908,6 +908,7 @@ static inline void kvm_arch_hardware_disable(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
+static inline void kvm_arch_sched_out(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_free_memslot(struct kvm *kvm,
 		struct kvm_memory_slot *free, struct kvm_memory_slot *dont) {}
 static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 36905cd..de91cc5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3332,6 +3332,36 @@ void kvm_core_residency_setup(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_core_residency_setup);
 
+static void kvm_residency_sched_out(struct kvm_vcpu *vcpu)
+{
+	int i;
+	struct kvm_residency_msr *msr;
+
+	for (i = 0; i < NR_CORE_RESIDENCY_MSRS; i++) {
+		msr = &vcpu->arch.core_cstate_msrs[i];
+		if (msr->count_with_host) {
+			WARN_ON(!msr->delta_from_host);
+			msr->value += kvm_residency_read_host(vcpu, msr);
+			msr->delta_from_host = false;
+		}
+	}
+}
+
+static void kvm_residency_sched_in(struct kvm_vcpu *vcpu)
+{
+	int i;
+	struct kvm_residency_msr *msr;
+
+	for (i = 0; i < NR_CORE_RESIDENCY_MSRS; i++) {
+		msr = &vcpu->arch.core_cstate_msrs[i];
+		if (msr->count_with_host) {
+			WARN_ON(msr->delta_from_host);
+			msr->value -= kvm_residency_read_host(vcpu, msr);
+			msr->delta_from_host = true;
+		}
+	}
+}
+
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	/* Address WBINVD may be executed by guest */
@@ -9276,6 +9306,14 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
 	vcpu->arch.l1tf_flush_l1d = true;
 	kvm_x86_ops->sched_in(vcpu, cpu);
+	if (kvm_mwait_in_guest(vcpu->kvm))
+		kvm_residency_sched_in(vcpu);
+}
+
+void kvm_arch_sched_out(struct kvm_vcpu *vcpu)
+{
+	if (kvm_mwait_in_guest(vcpu->kvm))
+		kvm_residency_sched_out(vcpu);
 }
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index abafddb..288bd34 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -854,6 +854,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu);
 
 void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu);
+void kvm_arch_sched_out(struct kvm_vcpu *vcpu);
 
 void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9613987..7d504c0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4221,6 +4221,7 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 
 	if (current->state == TASK_RUNNING)
 		vcpu->preempted = true;
+	kvm_arch_sched_out(vcpu);
 	kvm_arch_vcpu_put(vcpu);
 }
 
-- 
2.7.4

