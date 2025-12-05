Return-Path: <kvm+bounces-65321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F78ECA6D3D
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 10:08:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B9C023548DA6
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 08:16:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52F6F30F95C;
	Fri,  5 Dec 2025 07:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="SJ8/U/A5";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="SJ8/U/A5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A7430147C
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 07:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764920776; cv=none; b=Dw2uMP+SuVH8sAT0EEXtiSWGMeid/ZEjfYPEM1mRWztpjbh1sBdAmqIfNZkpq+Jmb76SJwA/pONAZKFxjlxqI3XkqVSW50t+Qvz9K8bkjtfDH8F3Tyw5iizUe0iPXXsN0mXUEqKUt4A+lursinfLbS1c7t+Znx9FEBVJszi1fRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764920776; c=relaxed/simple;
	bh=34u3hwbVnhdw8WljlvTT+V8enCooUZucHjITlDddZFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qXuZTYbwNJFleiuEZD3wf6a1NbW0AYueNKuc6+ZCaOC+Y6PhRoVnqvprayQKb+a5kqMl/ZbSE4qoyitXIRK1b5OzgpX8Uk8880sA0wCEvrS3xlhJIrgDviT4rj3o4mtL4f5OGXPjyoREJ/38Ft4sHBEgHhofDpE0dRjh70/ZvYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=SJ8/U/A5; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=SJ8/U/A5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C44FA336CA;
	Fri,  5 Dec 2025 07:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764920751; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=evcP1gmwBy/6zmUpl4qEftqDrntYNsL9eUwvyEDUcOA=;
	b=SJ8/U/A5MWbypxmzu3qNqaf0OIDeCff3ZchpaOaAHBqnS8eFu9FRHbMmZqmmgSiqNFWrzu
	Dj9PBTCPv5pvSHg11jxKP2jg4WUEUmlHsa4NIGDa317dkyUYjk+gkGsVMzKq5vu1oj3W0Q
	66oMF/tCSzSr0lq4FPpuypk0Bb/GCvM=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="SJ8/U/A5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764920751; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=evcP1gmwBy/6zmUpl4qEftqDrntYNsL9eUwvyEDUcOA=;
	b=SJ8/U/A5MWbypxmzu3qNqaf0OIDeCff3ZchpaOaAHBqnS8eFu9FRHbMmZqmmgSiqNFWrzu
	Dj9PBTCPv5pvSHg11jxKP2jg4WUEUmlHsa4NIGDa317dkyUYjk+gkGsVMzKq5vu1oj3W0Q
	66oMF/tCSzSr0lq4FPpuypk0Bb/GCvM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5B3C73EA63;
	Fri,  5 Dec 2025 07:45:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id i83GFK+NMmlpEgAAD6G6ig
	(envelope-from <jgross@suse.com>); Fri, 05 Dec 2025 07:45:51 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev
Cc: Juergen Gross <jgross@suse.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH 02/10] KVM/x86: Use bool for the err parameter of kvm_complete_insn_gp()
Date: Fri,  5 Dec 2025 08:45:29 +0100
Message-ID: <20251205074537.17072-3-jgross@suse.com>
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
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: C44FA336CA
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLkdkdrsxe9hqhhs5ask8616i6)];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

The err parameter of kvm_complete_insn_gp() is just a flag, so bool
is the appropriate type for it.

Just converting the function itself for now is fine, as the implicit
conversion from int to bool is doing the right thing. Most callers
will be changed later to use bool, too.

As vmx_complete_emulated_msr is defined to kvm_complete_insn_gp, the
same parameter modification should be applied to
vt_complete_emulated_msr(), tdx_complete_emulated_msr() and
svm_complete_emulated_msr().

No change of functionality intended.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/include/asm/kvm_host.h | 4 ++--
 arch/x86/kvm/svm/svm.c          | 2 +-
 arch/x86/kvm/vmx/main.c         | 2 +-
 arch/x86/kvm/vmx/tdx.c          | 2 +-
 arch/x86/kvm/vmx/tdx.h          | 2 +-
 arch/x86/kvm/x86.c              | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 48598d017d6f..2b289708b56b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1930,7 +1930,7 @@ struct kvm_x86_ops {
 
 	void (*migrate_timers)(struct kvm_vcpu *vcpu);
 	void (*recalc_intercepts)(struct kvm_vcpu *vcpu);
-	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
+	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, bool err);
 
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
 
@@ -2409,7 +2409,7 @@ bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu);
 extern bool kvm_find_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 
 int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu);
-int kvm_complete_insn_gp(struct kvm_vcpu *vcpu, int err);
+int kvm_complete_insn_gp(struct kvm_vcpu *vcpu, bool err);
 
 void __user *__x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
 				     u32 size);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9d29b2e7e855..f354cf0b6c1c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2777,7 +2777,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return 0;
 }
 
-static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
+static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, bool err)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	if (!err || !sev_es_guest(vcpu->kvm) || WARN_ON_ONCE(!svm->sev_es.ghcb))
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 0eb2773b2ae2..2f1b9a75fe47 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -202,7 +202,7 @@ static void vt_recalc_intercepts(struct kvm_vcpu *vcpu)
 	vmx_recalc_intercepts(vcpu);
 }
 
-static int vt_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
+static int vt_complete_emulated_msr(struct kvm_vcpu *vcpu, bool err)
 {
 	if (is_td_vcpu(vcpu))
 		return tdx_complete_emulated_msr(vcpu, err);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0a49c863c811..6b99c8dbd8cc 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2028,7 +2028,7 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-int tdx_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
+int tdx_complete_emulated_msr(struct kvm_vcpu *vcpu, bool err)
 {
 	if (err) {
 		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index ca39a9391db1..19a066868d45 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -174,7 +174,7 @@ static __always_inline void td_##lclass##_clearbit##bits(struct vcpu_tdx *tdx,	\
 
 
 bool tdx_interrupt_allowed(struct kvm_vcpu *vcpu);
-int tdx_complete_emulated_msr(struct kvm_vcpu *vcpu, int err);
+int tdx_complete_emulated_msr(struct kvm_vcpu *vcpu, bool err);
 
 TDX_BUILD_TDVPS_ACCESSORS(16, VMCS, vmcs);
 TDX_BUILD_TDVPS_ACCESSORS(32, VMCS, vmcs);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c9c2aa6f4705..f7c84d9ea9de 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -950,7 +950,7 @@ void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned int nr,
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_requeue_exception);
 
-int kvm_complete_insn_gp(struct kvm_vcpu *vcpu, int err)
+int kvm_complete_insn_gp(struct kvm_vcpu *vcpu, bool err)
 {
 	if (err)
 		kvm_inject_gp(vcpu, 0);
-- 
2.51.0


