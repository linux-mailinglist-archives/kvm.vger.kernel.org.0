Return-Path: <kvm+bounces-57169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4879FB50BF9
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 04:56:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 715D5189099E
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 02:56:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 602E925A2D8;
	Wed, 10 Sep 2025 02:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="d2wXsRxt"
X-Original-To: kvm@vger.kernel.org
Received: from out198-15.us.a.mail.aliyun.com (out198-15.us.a.mail.aliyun.com [47.90.198.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD56A248F5E;
	Wed, 10 Sep 2025 02:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.198.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757472903; cv=none; b=n7KlqcDcMQapANtT4Ef2LMYjP8FLMHWwrV3wEeXoGgYJV3UHdB3XXpGwtxgjqEeGIV9z5Z/iVO8dgU7BmBBeN6zdXox9OdCUH4Lrxm26D4dmbKqT2KYt8TZkYCHdIJY256fH1WiqMn4VbC8MX4aJixYDTDBx4R7FAFPLo3Xp0Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757472903; c=relaxed/simple;
	bh=ELenBpY/5KgZte93vWBfudD9K2sGtS9FzpmRBYNgrcU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Vl+Eg/Fy0eJvPMqtUH8hBfrNw2tEcfDHSqjQWsUE+LFtD8G7v9YUTaNSTyDCqwD4XeRCsaqC7cvYZl72pHc/y4GHGiuaJEiOicGQTffJD8SvcX3RLZoU/xVRBx7O6hsh/rpKDThkdskMQFXEuD7Ar6M7Ra6Hj4Xq1z2AQIPmyI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=d2wXsRxt; arc=none smtp.client-ip=47.90.198.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1757472883; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=YXYjSPwBEzyTiJUkKnb+LmPlxLCJZLMXoTgZ0VFZOcg=;
	b=d2wXsRxtWBnGdlA8lITyJaS91t2Ioh+U22y9eR8OzsEsPlXD45vUAC1IAnQ9+wZ2u7cxVu+zLFZACVngXXDcmu1DSH1nNjs00GenSBskac7SMv383dx+IjwcsJebv6CmC8L66B52m+DgmqpkIq+OwVqxyEMvLybTu371c/BcJrg=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.ebfmCoJ_1757472563 cluster:ay29)
          by smtp.aliyun-inc.com;
          Wed, 10 Sep 2025 10:49:24 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: kvm@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] KVM: x86: Set guest DR6 by kvm_queue_exception_p() in instruction emulation
Date: Wed, 10 Sep 2025 10:49:13 +0800
Message-Id: <14773b9e2387eaeee3af9fe0c6ca28a0b8fcee69.1757416809.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1757416809.git.houwenlong.hwl@antgroup.com>
References: <cover.1757416809.git.houwenlong.hwl@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Record DR6 in emulate_db() and use kvm_queue_exception_p() to set DR6
instead of directly using kvm_set_dr6() in emulation, which keeps the
handling of DR6 during #DB injection consistent with other code paths.

No functional change intended.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/emulate.c     | 14 ++++----------
 arch/x86/kvm/kvm_emulate.h |  6 +++++-
 arch/x86/kvm/x86.c         |  3 +++
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 542d3664afa3..18e3a732d106 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -593,8 +593,9 @@ static int emulate_exception(struct x86_emulate_ctxt *ctxt, int vec,
 	return X86EMUL_PROPAGATE_FAULT;
 }
 
-static int emulate_db(struct x86_emulate_ctxt *ctxt)
+static int emulate_db(struct x86_emulate_ctxt *ctxt, unsigned long dr6)
 {
+	ctxt->exception.dr6 = dr6;
 	return emulate_exception(ctxt, DB_VECTOR, 0, false);
 }
 
@@ -3857,15 +3858,8 @@ static int check_dr_read(struct x86_emulate_ctxt *ctxt)
 	if ((cr4 & X86_CR4_DE) && (dr == 4 || dr == 5))
 		return emulate_ud(ctxt);
 
-	if (ctxt->ops->get_dr(ctxt, 7) & DR7_GD) {
-		ulong dr6;
-
-		dr6 = ctxt->ops->get_dr(ctxt, 6);
-		dr6 &= ~DR_TRAP_BITS;
-		dr6 |= DR6_BD | DR6_ACTIVE_LOW;
-		ctxt->ops->set_dr(ctxt, 6, dr6);
-		return emulate_db(ctxt);
-	}
+	if (ctxt->ops->get_dr(ctxt, 7) & DR7_GD)
+		return emulate_db(ctxt, DR6_BD);
 
 	return X86EMUL_CONTINUE;
 }
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 7b5ddb787a25..a6fad7b938e3 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -24,7 +24,11 @@ struct x86_exception {
 	bool error_code_valid;
 	u16 error_code;
 	bool nested_page_fault;
-	u64 address; /* cr2 or nested page fault gpa */
+	union {
+		u64 address; /* cr2 or nested page fault gpa */
+		unsigned long dr6;
+		u64 payload;
+	};
 	u8 async_page_fault;
 	unsigned long exit_qualification;
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7ba2cdfdac44..b2e8322aeca7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8612,6 +8612,8 @@ static void inject_emulated_exception(struct kvm_vcpu *vcpu)
 
 	if (ctxt->exception.vector == PF_VECTOR)
 		kvm_inject_emulated_page_fault(vcpu, &ctxt->exception);
+	else if (ctxt->exception.vector == DB_VECTOR)
+		kvm_queue_exception_p(vcpu, DB_VECTOR, ctxt->exception.dr6);
 	else if (ctxt->exception.error_code_valid)
 		kvm_queue_exception_e(vcpu, ctxt->exception.vector,
 				      ctxt->exception.error_code);
@@ -8656,6 +8658,7 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
 	ctxt->interruptibility = 0;
 	ctxt->have_exception = false;
 	ctxt->exception.vector = -1;
+	ctxt->exception.payload = 0;
 	ctxt->perm_ok = false;
 
 	init_decode_cache(ctxt);
-- 
2.31.1


