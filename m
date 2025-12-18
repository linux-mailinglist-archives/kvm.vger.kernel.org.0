Return-Path: <kvm+bounces-66265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 49303CCC2E8
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 15:09:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 969AF30A5E36
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 14:06:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE5AA3446B3;
	Thu, 18 Dec 2025 14:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="K3zzeg8Q"
X-Original-To: kvm@vger.kernel.org
Received: from out28-221.mail.aliyun.com (out28-221.mail.aliyun.com [115.124.28.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861633431E6;
	Thu, 18 Dec 2025 14:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766066478; cv=none; b=j8lD5PnV+CyFiiZK6xyhkLfvPQocITcb56qdQ8ogAcp8yJpea5onlVHWLkluYLoevdE3HX3hxyyXx3V675LgLuSqJUgHjUKJ7AAZwefTaMZY6aQQe0IdcpqM3/eaTwNYwY6RhNOSIJ7CGQRT9uFm2qTy7/H+5teLzYoI9EzyOzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766066478; c=relaxed/simple;
	bh=Uz8/j1l7dC96sfyXq+AD4fX6cqO+4WKg7++VqzGmYaQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UA+iieBEXc+oDwkKz3aIBHNL1FdvSO5T/gwBc9RxpmXo9PIeQQ8mGJbu/fFIZgOf/lbWKKW5WXvqVX6CAx4xTqCqo+945FF6USeriocwDPAjNbyyY3Qz/3Kim8aaSVrDE3eByMDshyAlFiKen6+tvDrcv20QD9IzOm1oxr3m08s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=K3zzeg8Q; arc=none smtp.client-ip=115.124.28.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1766066464; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=iIJgsaJAJFg81C2Ck2lA9fwsw0HWn+BnyWHs7EtssAg=;
	b=K3zzeg8QzpF6hIV30tmEbuEtd8g3211MtbDnw4k/bauM47T4Inxg/kSxETf04yyBkdhR/drqTukS+UMH/AqhGI6c46PYJtY0tQT9Ex38UNv0reXq42BewKXNFlF3ut1Eob4IxeFblkTjWdQCW0TiCamVOHt08EDHdc8ZgykSL0k=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.fnj5fA3_1766066463 cluster:ay29)
          by smtp.aliyun-inc.com;
          Thu, 18 Dec 2025 22:01:03 +0800
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
Subject: [PATCH v2 5/9] KVM: x86: Consolidate KVM_GUESTDBG_SINGLESTEP check into the kvm_inject_emulated_db()
Date: Thu, 18 Dec 2025 22:00:40 +0800
Message-Id: <f5c495a43a03a20e04fbc9f1f78fd490e1f6ad50.1766066076.git.houwenlong.hwl@antgroup.com>
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

Use kvm_inject_emulated_db() in kvm_vcpu_do_singlestep() to consolidate
'KVM_GUESTDBG_SINGLESTEP' check into kvm_inject_emulated_db() during
emulation.

No functional change intended.

Suggested-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/x86.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3000139a19db..44c2886589d7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8947,7 +8947,7 @@ static int kvm_inject_emulated_db(struct kvm_vcpu *vcpu, unsigned long dr6)
 {
 	struct kvm_run *kvm_run = vcpu->run;
 
-	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
+	if (vcpu->guest_debug & (KVM_GUESTDBG_USE_HW_BP | KVM_GUESTDBG_SINGLESTEP)) {
 		kvm_run->debug.arch.dr6 = dr6 | DR6_ACTIVE_LOW;
 		kvm_run->debug.arch.pc = kvm_get_linear_rip(vcpu);
 		kvm_run->debug.arch.exception = DB_VECTOR;
@@ -9232,17 +9232,7 @@ static int kvm_vcpu_check_hw_bp(unsigned long addr, u32 type, u32 dr7,
 
 static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *kvm_run = vcpu->run;
-
-	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
-		kvm_run->debug.arch.dr6 = DR6_BS | DR6_ACTIVE_LOW;
-		kvm_run->debug.arch.pc = kvm_get_linear_rip(vcpu);
-		kvm_run->debug.arch.exception = DB_VECTOR;
-		kvm_run->exit_reason = KVM_EXIT_DEBUG;
-		return 0;
-	}
-	kvm_queue_exception_p(vcpu, DB_VECTOR, DR6_BS);
-	return 1;
+	return kvm_inject_emulated_db(vcpu, DR6_BS);
 }
 
 int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
-- 
2.31.1


