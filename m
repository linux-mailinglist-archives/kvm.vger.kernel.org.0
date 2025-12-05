Return-Path: <kvm+bounces-65325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CF0FCA6DBC
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 10:17:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 20C7833DBC72
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 08:19:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9355935294E;
	Fri,  5 Dec 2025 07:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="J6u72zd8";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="J6u72zd8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9A733A6EB
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 07:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764920825; cv=none; b=eVayFJJqJXWVSlkpSf3IDCiy5hD9X1tf4Bl77wbvIERJw9tmytcs/j74o6oLiF/jt3bMWKTf42pLqOQQVahA9MGT39Kvt5FejS+/uwVpHxfg2Hs/dEYM6uzKokt1W/9GabMqv0YOXoXm4kgculzJ4iG5AK30pyjD2MeLlHtqOSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764920825; c=relaxed/simple;
	bh=RMjuG9xOZRWYBTkXU1xw9IPvj7yQt8tlIIIO2zZ9c5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBCUpJasi4W4OBE+c1aaFTXKNqpibUhPHq8vDvVDlWo954mwlPk/CHs3BEoZuZ8R9Z9MdC3FlxbcNM9v+te/elNb986OIBxy0nWo9S5A4AEA4npMs7qJrQNs33pM+bPRXFazeiPES0e/7aUS7JtCT4V1Sm/MhyXKf5Qb8GIaLOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=J6u72zd8; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=J6u72zd8; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 754D3336D3;
	Fri,  5 Dec 2025 07:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764920763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O2QI2tXA+nx1LW7woBCHJciBt//PT9QL/iecUqx6nPQ=;
	b=J6u72zd8qDKeNP9YKy6a8htKzGol2VNaGLVElMZjSWLxGz5dkCVX16ZkJOMCtkXhBSS4ln
	SvbCX5dBW7pDAWuuCksVqI+9w0YaD9PcbtQmAqHGZ3b8WN4axT8yJFIIAq5Vle3xbFmlqJ
	ZfnNJv0hLp51U1ZtO8FunG4ImpDLexI=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764920763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O2QI2tXA+nx1LW7woBCHJciBt//PT9QL/iecUqx6nPQ=;
	b=J6u72zd8qDKeNP9YKy6a8htKzGol2VNaGLVElMZjSWLxGz5dkCVX16ZkJOMCtkXhBSS4ln
	SvbCX5dBW7pDAWuuCksVqI+9w0YaD9PcbtQmAqHGZ3b8WN4axT8yJFIIAq5Vle3xbFmlqJ
	ZfnNJv0hLp51U1ZtO8FunG4ImpDLexI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1DA183EA63;
	Fri,  5 Dec 2025 07:46:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0amiBbuNMml3EgAAD6G6ig
	(envelope-from <jgross@suse.com>); Fri, 05 Dec 2025 07:46:03 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	kvm@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 04/10] KVM/x86: Let x86_emulate_ops.set_dr() return a bool
Date: Fri,  5 Dec 2025 08:45:31 +0100
Message-ID: <20251205074537.17072-5-jgross@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251205074537.17072-1-jgross@suse.com>
References: <20251205074537.17072-1-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.989];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -2.80

Today x86_emulate_ops.set_dr() is returning "0" for okay and "1" in
case of an error. In order to get rid of the literal numbers, use bool
as return type for x86_emulate_ops.set_dr() and related sub-functions.

As x86_emulate_ops.set_dr() only ever returns 0 or 1, the test for its
return value less than 0 in em_dr_write() seems to be a bug. It should
probably be just a test for not 0.

No change of functionality intended.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/emulate.c          |  2 +-
 arch/x86/kvm/kvm_emulate.h      |  2 +-
 arch/x86/kvm/svm/svm.c          |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  4 ++--
 arch/x86/kvm/x86.c              | 12 ++++++------
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7997ed36de38..acb8353b97a4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2207,7 +2207,7 @@ bool kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 bool kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
 bool kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 bool kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8);
-int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val);
+bool kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val);
 unsigned long kvm_get_dr(struct kvm_vcpu *vcpu, int dr);
 unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw);
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 4e3da5b497b8..f5cae7335c26 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3280,7 +3280,7 @@ static int em_dr_write(struct x86_emulate_ctxt *ctxt)
 		val = ctxt->src.val & ~0U;
 
 	/* #UD condition is already handled. */
-	if (ctxt->ops->set_dr(ctxt, ctxt->modrm_reg, val) < 0)
+	if (ctxt->ops->set_dr(ctxt, ctxt->modrm_reg, val))
 		return emulate_gp(ctxt, 0);
 
 	/* Disable writeback. */
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index efc64396d717..eafc91207b45 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -212,7 +212,7 @@ struct x86_emulate_ops {
 	bool (*set_cr)(struct x86_emulate_ctxt *ctxt, int cr, ulong val);
 	int (*cpl)(struct x86_emulate_ctxt *ctxt);
 	ulong (*get_dr)(struct x86_emulate_ctxt *ctxt, int dr);
-	int (*set_dr)(struct x86_emulate_ctxt *ctxt, int dr, ulong value);
+	bool (*set_dr)(struct x86_emulate_ctxt *ctxt, int dr, ulong value);
 	int (*set_msr_with_filter)(struct x86_emulate_ctxt *ctxt, u32 msr_index, u64 data);
 	int (*get_msr_with_filter)(struct x86_emulate_ctxt *ctxt, u32 msr_index, u64 *pdata);
 	int (*get_msr)(struct x86_emulate_ctxt *ctxt, u32 msr_index, u64 *pdata);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 98bd087dda9c..7cbf4d686415 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2556,7 +2556,7 @@ static int dr_interception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	int reg, dr;
-	int err = 0;
+	bool err = false;
 
 	/*
 	 * SEV-ES intercepts DR7 only to disable guest debugging and the guest issues a VMGEXIT
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ff0c684d9c28..365c4ce283e5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5533,7 +5533,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 {
 	unsigned long exit_qualification;
 	int dr, dr7, reg;
-	int err = 1;
+	bool err = true;
 
 	exit_qualification = vmx_get_exit_qual(vcpu);
 	dr = exit_qualification & DEBUG_REG_ACCESS_NUM;
@@ -5580,7 +5580,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 	reg = DEBUG_REG_ACCESS_REG(exit_qualification);
 	if (exit_qualification & TYPE_MOV_FROM_DR) {
 		kvm_register_write(vcpu, reg, kvm_get_dr(vcpu, dr));
-		err = 0;
+		err = false;
 	} else {
 		err = kvm_set_dr(vcpu, dr, kvm_register_read(vcpu, reg));
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 462954633c1d..e733cb923312 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1550,7 +1550,7 @@ static u64 kvm_dr6_fixed(struct kvm_vcpu *vcpu)
 	return fixed;
 }
 
-int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
+bool kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
 {
 	size_t size = ARRAY_SIZE(vcpu->arch.db);
 
@@ -1563,19 +1563,19 @@ int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
 	case 4:
 	case 6:
 		if (!kvm_dr6_valid(val))
-			return 1; /* #GP */
+			return true; /* #GP */
 		vcpu->arch.dr6 = (val & DR6_VOLATILE) | kvm_dr6_fixed(vcpu);
 		break;
 	case 5:
 	default: /* 7 */
 		if (!kvm_dr7_valid(val))
-			return 1; /* #GP */
+			return true; /* #GP */
 		vcpu->arch.dr7 = (val & DR7_VOLATILE) | DR7_FIXED_1;
 		kvm_update_dr7(vcpu);
 		break;
 	}
 
-	return 0;
+	return false;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_set_dr);
 
@@ -8530,8 +8530,8 @@ static unsigned long emulator_get_dr(struct x86_emulate_ctxt *ctxt, int dr)
 	return kvm_get_dr(emul_to_vcpu(ctxt), dr);
 }
 
-static int emulator_set_dr(struct x86_emulate_ctxt *ctxt, int dr,
-			   unsigned long value)
+static bool emulator_set_dr(struct x86_emulate_ctxt *ctxt, int dr,
+			    unsigned long value)
 {
 
 	return kvm_set_dr(emul_to_vcpu(ctxt), dr, value);
-- 
2.51.0


