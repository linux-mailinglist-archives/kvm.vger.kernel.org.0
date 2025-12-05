Return-Path: <kvm+bounces-65326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 27BE9CA6AF5
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 09:20:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CB6B430021D3
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 08:20:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 840C0352FA1;
	Fri,  5 Dec 2025 07:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XqcUubIG";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XqcUubIG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA2D33A6E8
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 07:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764920834; cv=none; b=V0Tq8tlp/gZZ3/jtWaCYBM0hTaSaQf3gyTuAIxsP7L26WVPxeKZzsaebcZx4wEyfUOflb7XEVsWANoE6XvCOUFuUayE1LP5RDSwTRtckKRnhzp3m4HliApAvKS0VPpAJlY+RH1jmCadkuKCLwUhJR0vv+MFdRStE75BRQgVUhCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764920834; c=relaxed/simple;
	bh=F03vwSIyH3QwZ7+J8klChfo8LPDXIVGpsKTP3tQIz1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXK9P0cmyP7WD4rYIKnMe6IyojiiwEzCqF7gINAxJqWtfwpqpZH8yo0EhpwT7JPQ0R2h2vHud2mQyo2a6GC/5IkuCQr2z6ttoZSvPUhI9Aq+Okfi+uF6qL3IL9Aq4OMFvIHvnCZNx0po5e6JsASiLBuOFFFHjVQgBL+soPKs8NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XqcUubIG; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XqcUubIG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3C9B0336D6;
	Fri,  5 Dec 2025 07:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764920769; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X6CHhb5OAE1R7uzfG7dWT1EBmM+u6p8mpAXwy6JrV0w=;
	b=XqcUubIG4Dyu9hRcWBKztaiM3q6ZqLvoMgXV+dwLF1sw3grTrzSAjLUEK2X518Acv9IC7w
	Rm5xo30Pb25AbpA1WUGPUpdZnkzyAWAQ0S8sU+sb1dKxayTVYU8hdZyK8U84tCFINr4eld
	PWk/Xn7g9A3KvZM69c61m7xwSGBkIt0=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764920769; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X6CHhb5OAE1R7uzfG7dWT1EBmM+u6p8mpAXwy6JrV0w=;
	b=XqcUubIG4Dyu9hRcWBKztaiM3q6ZqLvoMgXV+dwLF1sw3grTrzSAjLUEK2X518Acv9IC7w
	Rm5xo30Pb25AbpA1WUGPUpdZnkzyAWAQ0S8sU+sb1dKxayTVYU8hdZyK8U84tCFINr4eld
	PWk/Xn7g9A3KvZM69c61m7xwSGBkIt0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DCA663EA63;
	Fri,  5 Dec 2025 07:46:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WY95NMCNMml8EgAAD6G6ig
	(envelope-from <jgross@suse.com>); Fri, 05 Dec 2025 07:46:08 +0000
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
Subject: [PATCH 05/10] KVM/x86: Add KVM_MSR_RET_* defines for values 0 and 1
Date: Fri,  5 Dec 2025 08:45:32 +0100
Message-ID: <20251205074537.17072-6-jgross@suse.com>
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
	NEURAL_HAM_SHORT(-0.20)[-0.990];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	R_RATELIMIT(0.00)[to_ip_from(RLfdszjqhz8kzzb9uwpzdm8png)];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -2.80

For MSR emulation return values only 2 special cases have defines,
while the most used values 0 and 1 don't.

Reason seems to be the maze of function calls of MSR emulation
intertwined with the KVM guest exit handlers, which are using the
values 0 and 1 for other purposes. This even led to the comment above
the already existing defines, warning to use the values 0 and 1 (and
negative errno values) in the MSR emulation at all.

Fact is that MSR emulation and exit handlers are in fact rather well
distinct, with only very few exceptions which are handled in a sane
way.

So add defines for 0 and 1 values of MSR emulation and at the same
time comments where exit handlers are calling into MSR emulation.

The new defines will be used later.

No change of functionality intended.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/kvm/x86.c |  2 ++
 arch/x86/kvm/x86.h | 10 ++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e733cb923312..e87963a47aa5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2130,6 +2130,7 @@ static int __kvm_emulate_rdmsr(struct kvm_vcpu *vcpu, u32 msr, int reg,
 	u64 data;
 	int r;
 
+	/* Call MSR emulation. */
 	r = kvm_emulate_msr_read(vcpu, msr, &data);
 
 	if (!r) {
@@ -2171,6 +2172,7 @@ static int __kvm_emulate_wrmsr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 {
 	int r;
 
+	/* Call MSR emulation. */
 	r = kvm_emulate_msr_write(vcpu, msr, data);
 	if (!r) {
 		trace_kvm_msr_write(msr, data);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index f3dc77f006f9..e44b6373b106 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -639,15 +639,21 @@ enum kvm_msr_access {
 /*
  * Internal error codes that are used to indicate that MSR emulation encountered
  * an error that should result in #GP in the guest, unless userspace handles it.
- * Note, '1', '0', and negative numbers are off limits, as they are used by KVM
- * as part of KVM's lightly documented internal KVM_RUN return codes.
+ * Note, negative errno values are possible for return values, too.
+ * In case MSR emulation is called from an exit handler, any return value other
+ * than KVM_MSR_RET_OK will normally result in a GP in the guest.
  *
+ * OK		- Emulation succeeded. Must be 0, as in some cases return values
+ *		  of functions returning 0 or -errno will just be passed on.
+ * ERR		- Some error occurred.
  * UNSUPPORTED	- The MSR isn't supported, either because it is completely
  *		  unknown to KVM, or because the MSR should not exist according
  *		  to the vCPU model.
  *
  * FILTERED	- Access to the MSR is denied by a userspace MSR filter.
  */
+#define  KVM_MSR_RET_OK			0
+#define  KVM_MSR_RET_ERR		1
 #define  KVM_MSR_RET_UNSUPPORTED	2
 #define  KVM_MSR_RET_FILTERED		3
 
-- 
2.51.0


