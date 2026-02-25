Return-Path: <kvm+bounces-71731-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qPFHBYlOnmlIUgQAu9opvQ
	(envelope-from <kvm+bounces-71731-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:21:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 4149518E984
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:21:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BD0E0302B04A
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 01:21:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE3BD25A357;
	Wed, 25 Feb 2026 01:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aPq45hIx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE20262FE7
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 01:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982457; cv=none; b=fD3pAAV5CHulvnZS8Ql/DPYtiDtytvBRs8vEQlxAC8r44+1xYU8gBwk7zCivBERIU77SC9K2Y4UrCEB3rygvSpbYS1W9bPI0Gi4toeIi8QB5yv0u6er3/kF4xHYqwJQOuBoWNbiBfXPnG2KAFBNkkRkVclMiEoYH9uTO7hcTxk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982457; c=relaxed/simple;
	bh=ueMQ7lNZG1mNPcnmXsV6s6mz7PApwRZnhIghYU/HyV0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XnjNouQmJ0NCC97IblVgblR8yPTHM7Zxl2NvanVL9iCuhQtrRq35JugkZS2zkx2EaDpJc8jESN7FYg6TmE0/Wbsu2LKcNtsYb4myBUgF9U5VNpM3GXQ3Lca/Jm4xWqusLhpF2a9sSO2H8l/JykPhZXr9FzmZZV0Mgt5++1PD3E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aPq45hIx; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35641c14663so6513812a91.2
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 17:20:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771982455; x=1772587255; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ufrjZKfuPvWxhnZ9cZ27jbL/GsnZnbCcINCZtRWeedI=;
        b=aPq45hIxscwrfC7Ky7Z8jMtyJKr5SaJQy3n40ZhvIlYO+rclSRHgHqXGmeVmqDJsF6
         ykFP/pOZryLxPVnwzwF83YiwN66B1PlKna93alqio6gPdxL5S/mvqHD7DvMi5wLtIDv3
         m5Ui5Bq/Sl1BVvbsiibu7fYlEHhsJYv/trbh99GqBf1SW1W2gzfXlCSDtmQkgeEskpZr
         dEcU/wuWeNLaOpCZfARW+uXtJiSXtuZ7IUdAk/8Ykym+DBTYJJeVabZnD1jpNgfESzM9
         WoLurWulEbw8yiHZmxUL1Or7umWANhtRxkk6RAwT7S2uFm08dxEUwAJBSzBTP80RxGRL
         GMrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771982455; x=1772587255;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ufrjZKfuPvWxhnZ9cZ27jbL/GsnZnbCcINCZtRWeedI=;
        b=o4GJWRnLZpPFBx5xbldgPLlCyr/Wgdn6P41XSPuv9GYN14Pk+NYqBZw0iTlWLijPrz
         4ySyuXPnqS9Eptl+xcfgH0l757EYbk08u3BS47vZG1J2I23Y8QgJkxXjWwqeWO2re9RV
         /7nuQ0QHQS0RP2JaNWK8l1GWrWdXyzFFTa+3cuzsDfrjYdTv6QIXrzPEaV2X0MAFlGDK
         14JhUakMQMxaaU1TIPOHMZM0TtllnltnIzJgsoGfojHNv7uk4VV8xTOgpjvkrN+60sTs
         Z4OZiy37UHtopiEmUfPxyh29kx/jHzZPZWdYZ9GJT82czSCbdNYiyWcqAxcIpAPth2s1
         6Ppw==
X-Gm-Message-State: AOJu0YyjG6/qhNq1PaI1NCZ+5TE4i9lkPf5oVhYxMjf+3O9qsJIa7axu
	DLdhKmBvKXfUkjAx0Z/qHwI4dRA5TjZUNPw9VS46ljCICtjwVvuss1K1P/Zz//EhZuhIxFOmF9o
	4wizs8A==
X-Received: from pjyr11.prod.google.com ([2002:a17:90a:e18b:b0:355:76b7:bf7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d887:b0:359:120f:d3aa
 with SMTP id 98e67ed59e1d1-359120fd628mr174902a91.14.1771982455286; Tue, 24
 Feb 2026 17:20:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 24 Feb 2026 17:20:37 -0800
In-Reply-To: <20260225012049.920665-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260225012049.920665-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260225012049.920665-3-seanjc@google.com>
Subject: [PATCH 02/14] KVM: x86: Open code handling of completed MMIO reads in emulator_read_write()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Yashu Zhang <zhangjiaji1@huawei.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71731-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 4149518E984
X-Rspamd-Action: no action

Open code the handling of completed MMIO reads instead of using an ops
hook, as burying the logic behind a (likely RETPOLINE'd) indirect call,
and with an unintuitive name, makes relatively straightforward code hard
to comprehend.

Opportunistically add comments to explain the dependencies between the
emulator's mem_read cache and the MMIO read completion logic, as it's very
easy to overlook the cache's role in getting the read data into the
correct destination.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c | 13 +++++++++++++
 arch/x86/kvm/x86.c     | 33 ++++++++++++++++-----------------
 2 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index c8e292e9a24d..70850e591350 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1297,12 +1297,25 @@ static int read_emulated(struct x86_emulate_ctxt *ctxt,
 	int rc;
 	struct read_cache *mc = &ctxt->mem_read;
 
+	/*
+	 * If the read gets a cache hit, simply copy the value from the cache.
+	 * A "hit" here means that there is unused data in the cache, i.e. when
+	 * re-emulating an instruction to complete a userspace exit, KVM relies
+	 * on "no decode" to ensure the instruction is re-emulated in the same
+	 * sequence, so that multiple reads are fulfilled in the correct order.
+	 */
 	if (mc->pos < mc->end)
 		goto read_cached;
 
 	if (KVM_EMULATOR_BUG_ON((mc->end + size) >= sizeof(mc->data), ctxt))
 		return X86EMUL_UNHANDLEABLE;
 
+	/*
+	 * Route all reads to the cache.  This allows @dest to be an on-stack
+	 * variable without triggering use-after-free if KVM needs to exit to
+	 * userspace to handle an MMIO read (the MMIO fragment will point at
+	 * the current location in the cache).
+	 */
 	rc = ctxt->ops->read_emulated(ctxt, addr, mc->data + mc->end, size,
 				      &ctxt->exception);
 	if (rc != X86EMUL_CONTINUE)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ff3a6f86973f..8b1f02cc8196 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8109,8 +8109,6 @@ int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 }
 
 struct read_write_emulator_ops {
-	int (*read_write_prepare)(struct kvm_vcpu *vcpu, void *val,
-				  int bytes);
 	int (*read_write_emulate)(struct kvm_vcpu *vcpu, gpa_t gpa,
 				  void *val, int bytes);
 	int (*read_write_mmio)(struct kvm_vcpu *vcpu, gpa_t gpa,
@@ -8120,18 +8118,6 @@ struct read_write_emulator_ops {
 	bool write;
 };
 
-static int read_prepare(struct kvm_vcpu *vcpu, void *val, int bytes)
-{
-	if (vcpu->mmio_read_completed) {
-		trace_kvm_mmio(KVM_TRACE_MMIO_READ, bytes,
-			       vcpu->mmio_fragments[0].gpa, val);
-		vcpu->mmio_read_completed = 0;
-		return 1;
-	}
-
-	return 0;
-}
-
 static int read_emulate(struct kvm_vcpu *vcpu, gpa_t gpa,
 			void *val, int bytes)
 {
@@ -8167,7 +8153,6 @@ static int write_exit_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
 }
 
 static const struct read_write_emulator_ops read_emultor = {
-	.read_write_prepare = read_prepare,
 	.read_write_emulate = read_emulate,
 	.read_write_mmio = vcpu_mmio_read,
 	.read_write_exit_mmio = read_exit_mmio,
@@ -8250,9 +8235,23 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
 	if (WARN_ON_ONCE((bytes > 8u || !ops->write) && object_is_on_stack(val)))
 		return X86EMUL_UNHANDLEABLE;
 
-	if (ops->read_write_prepare &&
-		  ops->read_write_prepare(vcpu, val, bytes))
+	/*
+	 * If the read was already completed via a userspace MMIO exit, there's
+	 * nothing left to do except trace the MMIO read.  When completing MMIO
+	 * reads, KVM re-emulates the instruction to propagate the value into
+	 * the correct destination, e.g. into the correct register, but the
+	 * value itself has already been copied to the read cache.
+	 *
+	 * Note!  This is *tightly* coupled to read_emulated() satisfying reads
+	 * from the emulator's mem_read cache, so that the MMIO fragment data
+	 * is copied to the correct chunk of the correct operand.
+	 */
+	if (!ops->write && vcpu->mmio_read_completed) {
+		trace_kvm_mmio(KVM_TRACE_MMIO_READ, bytes,
+			       vcpu->mmio_fragments[0].gpa, val);
+		vcpu->mmio_read_completed = 0;
 		return X86EMUL_CONTINUE;
+	}
 
 	vcpu->mmio_nr_fragments = 0;
 
-- 
2.53.0.414.gf7e9f6c205-goog


