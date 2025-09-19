Return-Path: <kvm+bounces-58241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 074B0B8B7E1
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:37:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C69E24E2324
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:37:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2A172E8E12;
	Fri, 19 Sep 2025 22:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bHZn7hrp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AC02E7F2C
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321209; cv=none; b=iwYj36IQ+3hEkgdTpzG5ZaMNGC+utrro7K48D7Q/yd2Uzjqd3iRKgA9SDyVmpyTb+5+ht73z3667smK7m2YXe0TIYkDlZqNuIqkyapG6IyTa8VPuKsEek4C6FDCsvmDmxjwHM39uO+ZRT5TgX+coaM5vHtITvG7P9EeV7eycUjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321209; c=relaxed/simple;
	bh=WAz+OPNGncuQ7MlKExXhXByj1PrQJD9ziBuUEUdKnOQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nLn/5zlNZ4Y/fN3LurWWsqKoN0B6UHOIzNtYAGnAWZAXWF2b3Eb/eDCU9ec9T93N30F2D8FyyU52mQWPHTJsJ3ywi6+zA22lgbEClNgb0f4YILmYHvjdayiWS8dPZK+2ZVod5/tWPWt1MbNlvauC4LR3HrAQ6OF27jwreZiL+4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bHZn7hrp; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b4f8e079bc1so1801554a12.3
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321207; x=1758926007; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8opc7S0Texwr1Y0+7J7NcGWGbaq8Y3HSFNECcKZKOxk=;
        b=bHZn7hrpUtyjr6LgaJ3BWqQFAp3ua3PpKjOGzZ9qGSbFds9z5/rppR55WWFnVwlfYv
         xwtk8bClciJwUZSZlhynA+lWk6kLIbDpaDMoCo/rGZyjWsGtyJN7NHS3wH7SOpIDM7/7
         43GjxVfYgU8U4plHINSi+xXPLDOBGMiqCIkveS76eFlR1Pzk90NcuQvUGGT9N3G6UxUB
         Xm4pYvK3VzELzSaCyq1LQcDcTYdosjDO7UUgc/00YYbB65HbbaLAWXnuBQabksKRoT/l
         1L9Rx0ellRR2unp0BUFQOEVREtfctqf6ZNCZkx+2VvyWxHGAhxWjRHSpNyy3XhMie125
         ey5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321207; x=1758926007;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8opc7S0Texwr1Y0+7J7NcGWGbaq8Y3HSFNECcKZKOxk=;
        b=X5QJ2TPbLzk+BfGx9VmFK89rNYwQhLIhZzbB5kxnzi2ALrelsUCzuDfL4czvjQzL2K
         REn/En7Wnn3N6bxtpzVSJz5OnMNsI4ah/C2pd4lXEFf70jcmRlEtjMBhSN5sVyRXx2Qn
         6BpfSGmbPv5sOc9bXbLCTTT9s/blzAM0EuibcH/crIZcC/6rkGur7en3xR6HzXDc8QsL
         yVUABilxtxY04s/VGjiRdvEDZmQDK9ttkTbAaJa8AUrRD/V1JY4lXjr5s9SEdfqet6NN
         cCxv1tEkZjkIPPoldkmW2pyeYzg+QVaTB9alYhwtck783KHdiejvzsIKA0uenODha2Sp
         rPzw==
X-Gm-Message-State: AOJu0Yw//Ifg4cjyk8qhTOaEpfMEiRjJEdJ5EXNfLz8QtUjjawG6WpzM
	J1EZwO0H++IKONB8oFRfXS2jwSlm8KWwx4E73jWsjrqPwgizznO5qBOQTF6TqlN6xJElzgK49+x
	Wr//vhA==
X-Google-Smtp-Source: AGHT+IGLcHt3zxuicSOW0aEtZIt9C7ht7qM1vM3VeEofwQHXCWu0JrA1UAYPsGfA+0sHn9V626/TGf2DOOw=
X-Received: from pgco29.prod.google.com ([2002:a63:731d:0:b0:b54:fe45:6acf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:728b:b0:244:facc:65ea
 with SMTP id adf61e73a8af0-2925f57462emr6706732637.18.1758321206706; Fri, 19
 Sep 2025 15:33:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:20 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-14-seanjc@google.com>
Subject: [PATCH v16 13/51] KVM: x86: Enable guest SSP read/write interface
 with new uAPIs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

From: Yang Weijiang <weijiang.yang@intel.com>

Add a KVM-defined ONE_REG register, KVM_REG_GUEST_SSP, to let userspace
save and restore the guest's Shadow Stack Pointer (SSP).  On both Intel
and AMD, SSP is a hardware register that can only be accessed by software
via dedicated ISA (e.g. RDSSP) or via VMCS/VMCB fields (used by hardware
to context switch SSP at entry/exit).  As a result, SSP doesn't fit in
any of KVM's existing interfaces for saving/restoring state.

Internally, treat SSP as a fake/synthetic MSR, as the semantics of writes
to SSP follow that of several other Shadow Stack MSRs, e.g. the PLx_SSP
MSRs.  Use a translation layer to hide the KVM-internal MSR index so that
the arbitrary index doesn't become ABI, e.g. so that KVM can rework its
implementation as needed, so long as the ONE_REG ABI is maintained.

Explicitly reject accesses to SSP if the vCPU doesn't have Shadow Stack
support to avoid running afoul of ignore_msrs, which unfortunately applies
to host-initiated accesses (which is a discussion for another day).  I.e.
ensure consistent behavior for KVM-defined registers irrespective of
ignore_msrs.

Link: https://lore.kernel.org/all/aca9d389-f11e-4811-90cf-d98e345a5cc2@intel.com
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst  |  8 +++++++
 arch/x86/include/uapi/asm/kvm.h |  3 +++
 arch/x86/kvm/x86.c              | 37 +++++++++++++++++++++++++++++----
 arch/x86/kvm/x86.h              | 10 +++++++++
 4 files changed, 54 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index abd02675a24d..6ae24c5ca559 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2911,6 +2911,14 @@ such as set vcpu counter or reset vcpu, and they have the following id bit patte
 x86 MSR registers have the following id bit patterns::
   0x2030 0002 <msr number:32>
 
+Following are the KVM-defined registers for x86:
+
+======================= ========= =============================================
+    Encoding            Register  Description
+======================= ========= =============================================
+  0x2030 0003 0000 0000 SSP       Shadow Stack Pointer
+======================= ========= =============================================
+
 4.69 KVM_GET_ONE_REG
 --------------------
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index aae1033c8afa..467116186e71 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -437,6 +437,9 @@ struct kvm_xcrs {
 #define KVM_X86_REG_KVM(index)					\
 	KVM_X86_REG_ID(KVM_X86_REG_TYPE_KVM, index)
 
+/* KVM-defined registers starting from 0 */
+#define KVM_REG_GUEST_SSP	0
+
 #define KVM_SYNC_X86_REGS      (1UL << 0)
 #define KVM_SYNC_X86_SREGS     (1UL << 1)
 #define KVM_SYNC_X86_EVENTS    (1UL << 2)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5245b21168cb..720540f102e1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6016,9 +6016,27 @@ struct kvm_x86_reg_id {
 	__u8  x86;
 };
 
-static int kvm_translate_kvm_reg(struct kvm_x86_reg_id *reg)
+static int kvm_translate_kvm_reg(struct kvm_vcpu *vcpu,
+				 struct kvm_x86_reg_id *reg)
 {
-	return -EINVAL;
+	switch (reg->index) {
+	case KVM_REG_GUEST_SSP:
+		/*
+		 * FIXME: If host-initiated accesses are ever exempted from
+		 * ignore_msrs (in kvm_do_msr_access()), drop this manual check
+		 * and rely on KVM's standard checks to reject accesses to regs
+		 * that don't exist.
+		 */
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
+			return -EINVAL;
+
+		reg->type = KVM_X86_REG_TYPE_MSR;
+		reg->index = MSR_KVM_INTERNAL_GUEST_SSP;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
 }
 
 static int kvm_get_one_msr(struct kvm_vcpu *vcpu, u32 msr, u64 __user *user_val)
@@ -6067,7 +6085,7 @@ static int kvm_get_set_one_reg(struct kvm_vcpu *vcpu, unsigned int ioctl,
 		return -EINVAL;
 
 	if (reg->type == KVM_X86_REG_TYPE_KVM) {
-		r = kvm_translate_kvm_reg(reg);
+		r = kvm_translate_kvm_reg(vcpu, reg);
 		if (r)
 			return r;
 	}
@@ -6098,11 +6116,22 @@ static int kvm_get_set_one_reg(struct kvm_vcpu *vcpu, unsigned int ioctl,
 static int kvm_get_reg_list(struct kvm_vcpu *vcpu,
 			    struct kvm_reg_list __user *user_list)
 {
-	u64 nr_regs = 0;
+	u64 nr_regs = guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) ? 1 : 0;
+	u64 user_nr_regs;
+
+	if (get_user(user_nr_regs, &user_list->n))
+		return -EFAULT;
 
 	if (put_user(nr_regs, &user_list->n))
 		return -EFAULT;
 
+	if (user_nr_regs < nr_regs)
+		return -E2BIG;
+
+	if (nr_regs &&
+	    put_user(KVM_X86_REG_KVM(KVM_REG_GUEST_SSP), &user_list->reg[0]))
+		return -EFAULT;
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 786e36fcd0fb..a7c9c72fca93 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -101,6 +101,16 @@ do {											\
 #define KVM_SVM_DEFAULT_PLE_WINDOW_MAX	USHRT_MAX
 #define KVM_SVM_DEFAULT_PLE_WINDOW	3000
 
+/*
+ * KVM's internal, non-ABI indices for synthetic MSRs. The values themselves
+ * are arbitrary and have no meaning, the only requirement is that they don't
+ * conflict with "real" MSRs that KVM supports. Use values at the upper end
+ * of KVM's reserved paravirtual MSR range to minimize churn, i.e. these values
+ * will be usable until KVM exhausts its supply of paravirtual MSR indices.
+ */
+
+#define MSR_KVM_INTERNAL_GUEST_SSP	0x4b564dff
+
 static inline unsigned int __grow_ple_window(unsigned int val,
 		unsigned int base, unsigned int modifier, unsigned int max)
 {
-- 
2.51.0.470.ga7dc726c21-goog


