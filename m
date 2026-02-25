Return-Path: <kvm+bounces-71743-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qHh7GLlPnmlIUgQAu9opvQ
	(envelope-from <kvm+bounces-71743-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:26:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8478C18EA39
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:26:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0FD193085790
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 01:22:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C687279DB3;
	Wed, 25 Feb 2026 01:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BH2WDDCB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4DC286D64
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 01:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982480; cv=none; b=CamICrnQq+fhwA8YTP8LPkqgnntcB0XMExMTqx/sDslKeKe8WPL82f4LpKMsE6gZNaiKfon43/32o1YzQQ33+5lcjzZRUCoCzUg2helDq7osG+iGHDTe3KucGwcsZzfeBIyYQWQeZWQA0Mpde6RXz/AutOCnE9RmNPSP6lh5eC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982480; c=relaxed/simple;
	bh=IuDnIRUgFkFMGAUuxCS338MB/VHIWV/Tt1I66OqunQE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LY/wA3NwZADj5eWXMHGhigUEWu289LUyQhob+2H8iJnJvr7wBhFwmamXJWapSeHO8wLOMs9x4MsGqzC4y4pWtDIREan4zI2KEFRroyHzxm6jJInWfECBYn3+FzwJaQOlVz6HaODAN0cOpVL6OcUpV49mdOoO5ry1v5efaqGkEyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BH2WDDCB; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c6e24ee93a6so228291a12.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 17:21:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771982479; x=1772587279; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=06Kr2IGpW9wlaU49L7FaC2EfLlqxR0kfrYYtwtYSIqY=;
        b=BH2WDDCBdSTPYuywWHLI7FH7LB7c4yiB9eBtYCCMOsx8Y/Ue5MmmbBiwulwW6eTTzk
         MczA0kws+5MaxIGhEH/eifdoy13BY4330sIM5kgfyGfaodGuxnGJwlgeyrlg6e9NUzdv
         O8gH3rtGgDv4oCZZNq5mviSvkookc11ZvE2018R3eLA5+uPOeCCq13ucga57dzLFcgLz
         ehOLVBHrlnnsNYI813oQcLnvottbzM1nrZlMzTO8SKpfCJEZtVCGeyGoMHA/H8u63WM7
         GtZDD01Gy2yk8nQg9BXRmu2XfPDgStsWJ5kh7QtNgiLEc7YJg/QOrySmKqYYH2O7DRCy
         EtGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771982479; x=1772587279;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=06Kr2IGpW9wlaU49L7FaC2EfLlqxR0kfrYYtwtYSIqY=;
        b=phgZRwHNEhzU693paQ/pq7BCXTBQqykdCXWrfxA6aKrNayBN7i4ypeaWMFJTurO7L7
         s7SInTdOc7K1IaF5oFYBFUI7jrD7hRgXvoDaAx6MFvMKxfc1iHMOkgcPoOxWm/evwltl
         cK3KGfhGcuH4dlLfiGd1UGHV86HApiPyBBfbpQVtDmv0/fsnzUgDDnrQsQZ7iGcKavbK
         xADwqdrCrrWPy51l0elluLWhtamq696Jx6ia+QpHTHbaGh9dDhe8r15IYaHO9ZD2EEIk
         CUNpJrceymaw6s74+nlhmj6KhRQGbrh/kbCdpuuW4D85QnR+vNcJpH7mhx2D8J10cwhn
         CH6Q==
X-Gm-Message-State: AOJu0YwoKsLgFweXnGSkbmlVqqlhYtmhb7gNVjdKCmp8iK3Un9QJWKV5
	IKxtkJJiy+Tn9noQFlxD6oRWMHw317eKJS+tKJXGKCNUtQ5GtdGUZJEeeEcXf8C/yursHd4kOmH
	v7gZ5cw==
X-Received: from pgeh5.prod.google.com ([2002:a05:6a02:53c5:b0:c6e:8a5c:a772])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7d9b:b0:37c:b74c:d8c7
 with SMTP id adf61e73a8af0-3959ac989c4mr1507787637.22.1771982478801; Tue, 24
 Feb 2026 17:21:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 24 Feb 2026 17:20:49 -0800
In-Reply-To: <20260225012049.920665-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260225012049.920665-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260225012049.920665-15-seanjc@google.com>
Subject: [PATCH 14/14] KVM: x86: Add helpers to prepare kvm_run for userspace
 MMIO exit
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
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
	TAGGED_FROM(0.00)[bounces-71743-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 8478C18EA39
X-Rspamd-Action: no action

Add helpers to fill kvm_run for userspace MMIO exits to deduplicate a
variety of code, and to allow for a cleaner return path in
emulator_read_write().

No functional change intended.

Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 14 ++++----------
 arch/x86/kvm/x86.c     | 42 ++++++++----------------------------------
 arch/x86/kvm/x86.h     | 24 ++++++++++++++++++++++++
 3 files changed, 36 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 5df9d32d2058..a813c502336c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1467,17 +1467,11 @@ static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
 
 	/* Request the device emulation to userspace device model. */
 	vcpu->mmio_is_write = write;
-	if (!write)
+
+	__kvm_prepare_emulated_mmio_exit(vcpu, gpa, size, &val, write);
+
+	if (!write) {
 		vcpu->arch.complete_userspace_io = tdx_complete_mmio_read;
-
-	vcpu->run->mmio.phys_addr = gpa;
-	vcpu->run->mmio.len = size;
-	vcpu->run->mmio.is_write = write;
-	vcpu->run->exit_reason = KVM_EXIT_MMIO;
-
-	if (write) {
-		memcpy(vcpu->run->mmio.data, &val, size);
-	} else {
 		vcpu->mmio_fragments[0].gpa = gpa;
 		vcpu->mmio_fragments[0].len = size;
 		trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, size, gpa, NULL);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5376b370b4db..889a9098403c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8210,7 +8210,6 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
 			const struct read_write_emulator_ops *ops)
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
-	struct kvm_mmio_fragment *frag;
 	int rc;
 
 	if (WARN_ON_ONCE((bytes > 8u || !ops->write) && object_is_on_stack(val)))
@@ -8268,12 +8267,9 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
 
 	vcpu->mmio_needed = 1;
 	vcpu->mmio_cur_fragment = 0;
+	vcpu->mmio_is_write = ops->write;
 
-	frag = &vcpu->mmio_fragments[0];
-	vcpu->run->mmio.len = min(8u, frag->len);
-	vcpu->run->mmio.is_write = vcpu->mmio_is_write = ops->write;
-	vcpu->run->exit_reason = KVM_EXIT_MMIO;
-	vcpu->run->mmio.phys_addr = frag->gpa;
+	kvm_prepare_emulated_mmio_exit(vcpu, &vcpu->mmio_fragments[0]);
 
 	/*
 	 * For MMIO reads, stop emulating and immediately exit to userspace, as
@@ -8283,11 +8279,7 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
 	 * after completing emulation (see the check on vcpu->mmio_needed in
 	 * x86_emulate_instruction()).
 	 */
-	if (!ops->write)
-		return X86EMUL_IO_NEEDED;
-
-	memcpy(vcpu->run->mmio.data, frag->data, min(8u, frag->len));
-	return X86EMUL_CONTINUE;
+	return ops->write ? X86EMUL_CONTINUE : X86EMUL_IO_NEEDED;
 }
 
 static int emulator_read_emulated(struct x86_emulate_ctxt *ctxt,
@@ -11884,12 +11876,7 @@ static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
 		return complete_emulated_io(vcpu);
 	}
 
-	run->exit_reason = KVM_EXIT_MMIO;
-	run->mmio.phys_addr = frag->gpa;
-	if (vcpu->mmio_is_write)
-		memcpy(run->mmio.data, frag->data, min(8u, frag->len));
-	run->mmio.len = min(8u, frag->len);
-	run->mmio.is_write = vcpu->mmio_is_write;
+	kvm_prepare_emulated_mmio_exit(vcpu, frag);
 	vcpu->arch.complete_userspace_io = complete_emulated_mmio;
 	return 0;
 }
@@ -14296,15 +14283,8 @@ static int complete_sev_es_emulated_mmio(struct kvm_vcpu *vcpu)
 	}
 
 	// More MMIO is needed
-	run->mmio.phys_addr = frag->gpa;
-	run->mmio.len = min(8u, frag->len);
-	run->mmio.is_write = vcpu->mmio_is_write;
-	if (run->mmio.is_write)
-		memcpy(run->mmio.data, frag->data, min(8u, frag->len));
-	run->exit_reason = KVM_EXIT_MMIO;
-
+	kvm_prepare_emulated_mmio_exit(vcpu, frag);
 	vcpu->arch.complete_userspace_io = complete_sev_es_emulated_mmio;
-
 	return 0;
 }
 
@@ -14333,23 +14313,17 @@ int kvm_sev_es_mmio(struct kvm_vcpu *vcpu, bool is_write, gpa_t gpa,
 	 *       requests that split a page boundary.
 	 */
 	frag = vcpu->mmio_fragments;
-	vcpu->mmio_nr_fragments = 1;
 	frag->len = bytes;
 	frag->gpa = gpa;
 	frag->data = data;
 
 	vcpu->mmio_needed = 1;
 	vcpu->mmio_cur_fragment = 0;
+	vcpu->mmio_nr_fragments = 1;
+	vcpu->mmio_is_write = is_write;
 
-	vcpu->run->mmio.phys_addr = gpa;
-	vcpu->run->mmio.len = min(8u, frag->len);
-	vcpu->run->mmio.is_write = is_write;
-	if (is_write)
-		memcpy(vcpu->run->mmio.data, frag->data, min(8u, frag->len));
-	vcpu->run->exit_reason = KVM_EXIT_MMIO;
-
+	kvm_prepare_emulated_mmio_exit(vcpu, frag);
 	vcpu->arch.complete_userspace_io = complete_sev_es_emulated_mmio;
-
 	return 0;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_sev_es_mmio);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 1d0f0edd31b3..d66f1c53d2b5 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -718,6 +718,30 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 			 unsigned int port, void *data,  unsigned int count,
 			 int in);
 
+static inline void __kvm_prepare_emulated_mmio_exit(struct kvm_vcpu *vcpu,
+						    gpa_t gpa, unsigned int len,
+						    const void *data,
+						    bool is_write)
+{
+	struct kvm_run *run = vcpu->run;
+
+	run->mmio.len = min(8u, len);
+	run->mmio.is_write = is_write;
+	run->exit_reason = KVM_EXIT_MMIO;
+	run->mmio.phys_addr = gpa;
+	if (is_write)
+		memcpy(run->mmio.data, data, min(8u, len));
+}
+
+static inline void kvm_prepare_emulated_mmio_exit(struct kvm_vcpu *vcpu,
+						  struct kvm_mmio_fragment *frag)
+{
+	WARN_ON_ONCE(!vcpu->mmio_needed || !vcpu->mmio_nr_fragments);
+
+	__kvm_prepare_emulated_mmio_exit(vcpu, frag->gpa, frag->len, frag->data,
+					 vcpu->mmio_is_write);
+}
+
 static inline bool user_exit_on_hypercall(struct kvm *kvm, unsigned long hc_nr)
 {
 	return kvm->arch.hypercall_exit_enabled & BIT(hc_nr);
-- 
2.53.0.414.gf7e9f6c205-goog


