Return-Path: <kvm+bounces-66270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B3CA5CCC2C1
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 15:07:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4EA3D30198A7
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 14:06:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BA1A34C83D;
	Thu, 18 Dec 2025 14:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="bu8/T792"
X-Original-To: kvm@vger.kernel.org
Received: from out198-23.us.a.mail.aliyun.com (out198-23.us.a.mail.aliyun.com [47.90.198.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566012FF151;
	Thu, 18 Dec 2025 14:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.198.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766066796; cv=none; b=rlHIj9dXnKwi3NOraHdS2mWqzVY4Ske0a0hNAtAV4DaKPRpxmfaUmKPqSpsqqOrJ28nn33wBmLUy8FB/p2Dv/A/JSwhM/41CwLNAbicGOF7uQMFpaXRk+NhR0eYaEbtGqneQg+DMpbVmBC/Ve4//6NP0o2QZon8IAjpKLGKUXQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766066796; c=relaxed/simple;
	bh=pWUh6X2uIwuPfuUOXox7Y8U6Mi14kyXOIl29B7mzdDs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SsK2DrsYZJKAWlbyHXgms9Xe4qRLVVWjoG/H63BRBaIXawaQk/7sAdejNDu03T8TfZyp0ZfFgfQTm6N79FKB5qZjlRg5gPfY/RN4hXPhj13jsmfYJ3S4+HlLZRpIDDfW4lCPnT7BRgmORHq4b2JgVKoBLUqo/aNZg/XEnI9RnXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=bu8/T792; arc=none smtp.client-ip=47.90.198.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1766066781; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=C2RClvngFiAizt3Rruo0eAfrLEJ721g2lfOtWib8nK8=;
	b=bu8/T792PQqWfRoXBKGn0XhCvMP5/zSWjdLSmJY4cgsVfM+iNKQxx/D7jeurgVlXtxFiVcJM4G/EEDl50LQOPfVJYjLmGZkJ5yH20mFDkU3fA7GgfsFOkbnLX0BIhYcIjGI+ZTp/ccUEx6nKVYasD5Bedr5leWJMU6D75MIIFEQ=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.fniMiGa_1766066455 cluster:ay29)
          by smtp.aliyun-inc.com;
          Thu, 18 Dec 2025 22:00:55 +0800
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
Subject: [PATCH v2 1/9] KVM: x86: Capture "struct x86_exception" in inject_emulated_exception()
Date: Thu, 18 Dec 2025 22:00:36 +0800
Message-Id: <995f9d8fbc93afb86920ad294124e917ddab30d3.1766066076.git.houwenlong.hwl@antgroup.com>
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

As all callers in inject_emulated_exception() use "struct x86_exception"
directly, capture it locally instead of using the context.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/x86.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0c6d899d53dd..ab298bfa7d9f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8923,15 +8923,14 @@ static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
 
 static void inject_emulated_exception(struct kvm_vcpu *vcpu)
 {
-	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+	struct x86_exception *ex = &vcpu->arch.emulate_ctxt->exception;
 
-	if (ctxt->exception.vector == PF_VECTOR)
-		kvm_inject_emulated_page_fault(vcpu, &ctxt->exception);
-	else if (ctxt->exception.error_code_valid)
-		kvm_queue_exception_e(vcpu, ctxt->exception.vector,
-				      ctxt->exception.error_code);
+	if (ex->vector == PF_VECTOR)
+		kvm_inject_emulated_page_fault(vcpu, ex);
+	else if (ex->error_code_valid)
+		kvm_queue_exception_e(vcpu, ex->vector, ex->error_code);
 	else
-		kvm_queue_exception(vcpu, ctxt->exception.vector);
+		kvm_queue_exception(vcpu, ex->vector);
 }
 
 static struct x86_emulate_ctxt *alloc_emulate_ctxt(struct kvm_vcpu *vcpu)
-- 
2.31.1


