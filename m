Return-Path: <kvm+bounces-27011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DAF4697A73A
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 20:19:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 81B731F27E9C
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 18:19:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A142165F08;
	Mon, 16 Sep 2024 18:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="V71zJMy3";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="V71zJMy3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA5915CD64;
	Mon, 16 Sep 2024 18:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726510696; cv=none; b=oZisqhk8/FbjlViF7UsOX+2CdJpDYRsGXTP1gtli9vCzPSqeCWxTJDi6D+SHg6mBRhUaIItzWkDVu/LXgyyqEZFYuqZVYePLJA+DeHkiAdjXz5dE4RoBmkZpqig2ULzBZqcK3qeJhsDyDb/TXBsvhIRzYBJqNghpArJm4lgNzqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726510696; c=relaxed/simple;
	bh=NaYD4z/PMvcd35hhct3ZHR9P9LQY2eeQF++fxr464lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6bEyIQun6u8RXs+9zj8pPE4PqyDzkiXCjmDCtsKmWL9wGoUNOgHD7CwBQOZqSmPU9evVATSNlVLjUeikWTrd5xY+8UQvVbFBafRvXCr9mS2ccd/KwhUL6bqqzZZeJrIXWc79gVoAU5c7C6dlPgTQWtYRaGjzxOjAoty8oPUFeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=V71zJMy3; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=V71zJMy3; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 404D71F8C5;
	Mon, 16 Sep 2024 18:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1726510690; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WCm95XJJnBEDcbDJOtrx9fOx+lx0IhmYpGAcLnQXA+s=;
	b=V71zJMy3Js2dFPMYYzngiEvzIBoh3x26RyoESwZ0ytSjpoXeRG591t3PYyRUA7QqaumpN8
	aoRMVtDqqj6tJqN0N2D3a9CvfxTdeTCq/01husX2aT3gy5Zny9AWpX2T8BXRa8hnL3a8EL
	xRxqi158r+A/OFU+zReCEMttFTBW0Hk=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1726510690; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WCm95XJJnBEDcbDJOtrx9fOx+lx0IhmYpGAcLnQXA+s=;
	b=V71zJMy3Js2dFPMYYzngiEvzIBoh3x26RyoESwZ0ytSjpoXeRG591t3PYyRUA7QqaumpN8
	aoRMVtDqqj6tJqN0N2D3a9CvfxTdeTCq/01husX2aT3gy5Zny9AWpX2T8BXRa8hnL3a8EL
	xRxqi158r+A/OFU+zReCEMttFTBW0Hk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A0D65139CE;
	Mon, 16 Sep 2024 18:18:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0L8nJWF26GbveAAAD6G6ig
	(envelope-from <roy.hopkins@suse.com>); Mon, 16 Sep 2024 18:18:09 +0000
From: Roy Hopkins <roy.hopkins@suse.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev
Cc: Roy Hopkins <roy.hopkins@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Michael Roth <michael.roth@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [RFC PATCH 4/5] x86/kvm: Add x86 field to find the default VMPL that IRQs should target
Date: Mon, 16 Sep 2024 19:17:56 +0100
Message-ID: <d8eb94631cdd98196e81119f19b9a0cae9dddc3a.1726506534.git.roy.hopkins@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1726506534.git.roy.hopkins@suse.com>
References: <cover.1726506534.git.roy.hopkins@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	R_RATELIMIT(0.00)[to_ip_from(RLh8t8sqpgocps1pdp1zxxqsw5)];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -6.80
X-Spam-Flag: NO

When a CPU supports multiple VMPLs, injected interrupts need to be sent
to the correct context. This commit adds an operation that determines
the VMPL number that IRQs should be sent to in the absence of an explicit
target VMPL.

Signed-off-by: Roy Hopkins <roy.hopkins@suse.com>
---
 arch/x86/include/asm/kvm_host.h | 7 +++++++
 arch/x86/kvm/svm/sev.c          | 8 ++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 94e7b5a4fafe..3dd3a5ff0cec 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1537,6 +1537,13 @@ struct kvm_arch {
 	 */
 #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
 	struct kvm_mmu_memory_cache split_desc_cache;
+
+	/*
+	 * When a system supports multiple VMPLs, injected interrupts need to be
+	 * sent to the correct context. The default VMPL that IRQs should be sent
+	 * to is indicated in this variable.
+	 */
+	unsigned int default_irq_vmpl;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3fbb1ce5195d..ed91aa93da6e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3983,6 +3983,14 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
 		 * means.
 		 */
 		kvm_release_pfn_clean(pfn);
+
+		/*
+		 * TEMP: If the newly created VMSA is for a lower VMPL then
+		 * set this VMPL to be the default for sending IRQs to.
+		 */
+		if (vcpu->vmpl > vcpu->kvm->arch.default_irq_vmpl) {
+			vcpu->kvm->arch.default_irq_vmpl = vcpu->vmpl;
+		}
 	}
 
 	return 0;
-- 
2.43.0


