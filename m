Return-Path: <kvm+bounces-57168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D28D0B50BF7
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 04:55:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 32FAB7A7972
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 02:53:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36AF4257858;
	Wed, 10 Sep 2025 02:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="WaGWB7fm"
X-Original-To: kvm@vger.kernel.org
Received: from out198-17.us.a.mail.aliyun.com (out198-17.us.a.mail.aliyun.com [47.90.198.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4333248F5C;
	Wed, 10 Sep 2025 02:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.198.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757472901; cv=none; b=pgKMBhDJPknE6gjaxHXGs0U2jvtvNt49/dFT4AUZLaRMDoNybLtg2pEu5SFo3DHQuOEFAuKqCd/HjhLHOqItRvHSKEOb6EsCbriekuFl8PPCxrT1CY4mwMXDWUZUarbDCrJvbEQzjwgonG2rK8WdA6u6XqZJUEa/dasW+qvFVcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757472901; c=relaxed/simple;
	bh=kYZbqIr5MidBn0HJ2lhzmxRbTeiwTgdazPiuPuescF8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iLuumOCe09XGyfBApzAgon8IQuW8wDfZ7vQzCEkj0RZS6SkigGnfjLventAl+56uFR4oBQ94ucT+tc+bbqT68ciZR3My3QTJHYHxfpstTeykqvA2sO5PseAuqwkjKsrH/XonOuDTpl9f3m1GUqOrbjIAYr0/srf5cvAqWMK0Dv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=WaGWB7fm; arc=none smtp.client-ip=47.90.198.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1757472887; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=JnJ9k+tsKVXHxmYDXdwSc1SeFCgYSHPpp2qWvdPYtD0=;
	b=WaGWB7fmPYdLcdMYQ6HzymjGivZ49jkqLShmu8xk9eSwLwArI3CmUM+bxRiuTpX/mQE8NEbMDqZnCLclU2Q1NM7Omnp3rhrT6LSR9I2KrcWPUkGdP9ID8UJ6I45j75o5iUtruxQac8rMMf/VnkCKduD4GWkbA87I8Gxg2mUesFU=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.ebdO4aZ_1757472567 cluster:ay29)
          by smtp.aliyun-inc.com;
          Wed, 10 Sep 2025 10:49:27 +0800
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
Subject: [PATCH 4/7] KVM: x86: Consolidate KVM_GUESTDBG_SINGLESTEP check into the kvm_inject_emulated_db()
Date: Wed, 10 Sep 2025 10:49:16 +0800
Message-Id: <45cbc005e14ea2a4b9ec803a91af63e364aeb71a.1757416809.git.houwenlong.hwl@antgroup.com>
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

Use kvm_inject_emulated_db() in kvm_vcpu_do_singlestep() to consolidate
'KVM_GUESTDBG_SINGLESTEP' check into kvm_inject_emulated_db() during
emulation.

No functional change intended.

Suggested-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/x86.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5af652916a19..83960214d5d8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8632,7 +8632,10 @@ static int kvm_inject_emulated_db(struct kvm_vcpu *vcpu, unsigned long dr6)
 {
 	struct kvm_run *kvm_run = vcpu->run;
 
-	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
+	/* Data breakpoints are not supported in emulation for now. */
+	WARN_ON((dr6 & DR6_BS) && (dr6 & DR_TRAP_BITS));
+
+	if (vcpu->guest_debug & (KVM_GUESTDBG_USE_HW_BP | KVM_GUESTDBG_SINGLESTEP)) {
 		kvm_run->debug.arch.dr6 = dr6 | DR6_ACTIVE_LOW;
 		kvm_run->debug.arch.pc = kvm_get_linear_rip(vcpu);
 		kvm_run->debug.arch.exception = DB_VECTOR;
@@ -8907,17 +8910,7 @@ static int kvm_vcpu_check_hw_bp(unsigned long addr, u32 type, u32 dr7,
 
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


