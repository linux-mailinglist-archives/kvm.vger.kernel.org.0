Return-Path: <kvm+bounces-66262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 89CD0CCC2FE
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 15:11:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6D85730F1646
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 14:07:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88BB1341642;
	Thu, 18 Dec 2025 14:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="V6NNYJ9Q"
X-Original-To: kvm@vger.kernel.org
Received: from out28-194.mail.aliyun.com (out28-194.mail.aliyun.com [115.124.28.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD8B33FE3A;
	Thu, 18 Dec 2025 14:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766066471; cv=none; b=DRs5P+pChKLWIgZiWJRAT9s422ZFxKctIURK3YHDHmVhhhiEExRw2N9mhtIvd5ewITwpYDnI1gT97nSH2X85w0onB89SBaTHkyzJdgHLVkVofLuDKz1TWUn6oVsqaoTgdYtrsAWfSkyZUavO06sxQIvKE2vefjGmIclNlTQoW5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766066471; c=relaxed/simple;
	bh=0azWD/REJUjsRlOa6K/t3rxaehmr1nby8w8O3bzwC58=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z/8OO/frY1YoM5T4yCAki9yCvNp7EB6ho690E69yi38QHCpEVyRHn90QNzwFe2pzOjePlhZU/7+eugG4VX5aayus18gHtjiBD4tSo2hFuOJK5Hd1kOp/jQhEE/RWzx+gj/fyiJ1Qx3SbJtkL0hA7khStQo18W8UFPU7DT0SPJ18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=V6NNYJ9Q; arc=none smtp.client-ip=115.124.28.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1766066458; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=Gh6LXne9O2mxElK9tqEIshKDA3L14nhlmFMSDFa72U4=;
	b=V6NNYJ9Q80SyML+kkX2g51Gq38XV/4s1UrdQG+phX/tpB0gWcPZvAY3JpVtecsBughXh/bYXGW9TdL7TOuMCQOpjTMKLX2Le7naoIX3HhL7TSeogytlq7VGhnD6xpSrhyDu3Uon4AqtKnfJmyABL8UuiJ0UUsV+A+C+ay1QvHzU=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.fnkarBO_1766066457 cluster:ay29)
          by smtp.aliyun-inc.com;
          Thu, 18 Dec 2025 22:00:57 +0800
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
Subject: [PATCH v2 2/9] KVM: x86: Set guest DR6 by kvm_queue_exception_p() in instruction emulation
Date: Thu, 18 Dec 2025 22:00:37 +0800
Message-Id: <9b859ab6a6b59e5ccfdac741459117996fe2da6e.1766066076.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1766066076.git.houwenlong.hwl@antgroup.com>
References: <cover.1766066076.git.houwenlong.hwl@antgroup.com>
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
 arch/x86/kvm/x86.c         |  5 ++++-
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index c8e292e9a24d..997cd6e46d90 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -540,8 +540,9 @@ static int emulate_exception(struct x86_emulate_ctxt *ctxt, int vec,
 	return X86EMUL_PROPAGATE_FAULT;
 }
 
-static int emulate_db(struct x86_emulate_ctxt *ctxt)
+static int emulate_db(struct x86_emulate_ctxt *ctxt, unsigned long dr6)
 {
+	ctxt->exception.dr6 = dr6;
 	return emulate_exception(ctxt, DB_VECTOR, 0, false);
 }
 
@@ -3834,15 +3835,8 @@ static int check_dr_read(struct x86_emulate_ctxt *ctxt)
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
index fb3dab4b5a53..7fe38b174e18 100644
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
index ab298bfa7d9f..f33ce947633e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8925,7 +8925,9 @@ static void inject_emulated_exception(struct kvm_vcpu *vcpu)
 {
 	struct x86_exception *ex = &vcpu->arch.emulate_ctxt->exception;
 
-	if (ex->vector == PF_VECTOR)
+	if (ex->vector == DB_VECTOR)
+		kvm_queue_exception_e(vcpu, DB_VECTOR, ex->dr6);
+	else if (ex->vector == PF_VECTOR)
 		kvm_inject_emulated_page_fault(vcpu, ex);
 	else if (ex->error_code_valid)
 		kvm_queue_exception_e(vcpu, ex->vector, ex->error_code);
@@ -8970,6 +8972,7 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
 	ctxt->interruptibility = 0;
 	ctxt->have_exception = false;
 	ctxt->exception.vector = -1;
+	ctxt->exception.payload = 0;
 	ctxt->perm_ok = false;
 
 	init_decode_cache(ctxt);
-- 
2.31.1


