Return-Path: <kvm+bounces-68667-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uNC3HqwicGlRVwAAu9opvQ
	(envelope-from <kvm+bounces-68667-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 01:49:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1938A4EB1B
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 01:49:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 60CFA9ADB58
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 00:49:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 115B32DB7AC;
	Wed, 21 Jan 2026 00:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="371Bvvnt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6ED277CBF
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 00:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768956554; cv=none; b=MZKuKDl7YCsAFN2JLIhr4WdX7ANh3BMtVAzPD2q6PbumTIzEw63aYZ0HTQF902NDXyFxWyYQ5t61gOUxo1/SdUkuYcdDm1jNouo8GL7XnQ9leM1OWqKzW46z21w8J9PezlQWkMSAXRk98qDfBt9K2Okn43V+WuWOEiDpsElw3yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768956554; c=relaxed/simple;
	bh=YRfX9Q0a0jQNu704pRguyi2Mmku9HkppIDZwldLPdlo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W7IxVEB4PseMCmBdzk7k0kjnZb0Z8UluhNEschBXOuwC0eFvjeDLdaD1us9H5dDKZ1k1YUgD1wdtEFVa1YPp6tqusiT1E2vul2JA9xkcoKJ6VxuAbBNVMv5dOBw457efLDVXzyRY1NsfFSs4oVP+LBOugj5JnY6aqKlzqgQSMho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=371Bvvnt; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a0d43fcb2fso134037025ad.3
        for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 16:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768956552; x=1769561352; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Si4ixKO/dBgwRmsNU8E+S8GgZCzFW5296/aB45rRxK8=;
        b=371Bvvnt4UJIdt5MguXnWvGhJiHZFXPEoEY4qb/bj3iHp+qQN5pu2Kg+n3tsX/dgKk
         Z1bB3B3Fiy35i+VlQVS5u6G0c9zdfvBLu0mLWjNaLVdE02EvgdboycAkRfc37YR4Xcxm
         F+h8QAp26jwrm/+ViT1CkQVc6GxhlNCUaBd6XuREVzP5dIrnJBhrM86q08zUteUI6LZC
         X5QeGAKuxpqIQZTugYtpOzIiqWYZ6biVUyeySibhMuAIw2Ij/VQcmzgC0VEp2cZmmf5g
         glg32m3wglZh7pL9i0SPmjKAUp2dV54UI0Itn5SFzAOaYLh4SnHvX751HuwHxHOBqzQG
         pW4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768956552; x=1769561352;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Si4ixKO/dBgwRmsNU8E+S8GgZCzFW5296/aB45rRxK8=;
        b=b37+0UFzon1NnIkbRRrqFt3QUEtQ8Yw4l3sH2bQgItY0CFq1ym1lweBMbnmk8Bvs0i
         PZC4gPap7qlBXyEj1J7elDt20+DISOPsHCtHBm42ZNLN9Zzi4FeiJvQx2kPkYy0IIt1e
         uoYWmDMYx47o10L9FiJy14tJl+CSzveqVZuMN/1c4PHj1eYbfLWHKySdPBkPTAW7O/mi
         IWfZgSw2fCUQc0+BDKyG58+Gd8Yl6gAoLQ6OoKw4dbEU11K9x8PhbqQJSdF3YoUbOInQ
         Tt69df9E2GhDa0jCWjQ7Ai1B6hDSkhabPRxSZ6jhaq1slxOz4I33cNICYPG4cS/qY8wI
         gFEA==
X-Gm-Message-State: AOJu0YzIMB22Dcq1TTpqdWYuaYzszMDIrepXHY+QQtTS9Y6snWZqBd1s
	C+neVdNhaHzWsrVUBmgf7Dd026qR+hTvXWjUTi3oJ6GvBGq+fytJ7feFTe/J3jn6wltjYt6Qjb8
	KVtYMYS6JMxlD8A==
X-Received: from plse9.prod.google.com ([2002:a17:902:b789:b0:2a7:63e0:6039])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:22d1:b0:2a0:d05d:e4f with SMTP id d9443c01a7336-2a76b055c8cmr33982245ad.45.1768956551900;
 Tue, 20 Jan 2026 16:49:11 -0800 (PST)
Date: Wed, 21 Jan 2026 00:49:04 +0000
In-Reply-To: <20260121004906.2373989-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260121004906.2373989-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260121004906.2373989-2-chengkev@google.com>
Subject: [PATCH 1/3] KVM: SVM: Fix nested NPF injection to set PFERR_GUEST_{PAGE,FINAL}_MASK
From: Kevin Cheng <chengkev@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yosry.ahmed@linux.dev, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-0.46 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68667-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chengkev@google.com,kvm@vger.kernel.org];
	DMARC_POLICY_ALLOW(0.00)[google.com,reject];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 1938A4EB1B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

When KVM emulates an instruction for L2 and encounters a nested page
fault (e.g., during string I/O emulation), nested_svm_inject_npf_exit()
injects an NPF to L1. However, the code incorrectly hardcodes
(1ULL << 32) for exit_info_1's upper bits when the original exit was
not an NPF. This always sets PFERR_GUEST_FINAL_MASK even when the fault
occurred on a page table page, preventing L1 from correctly identifying
the cause of the fault.

Set PFERR_GUEST_PAGE_MASK in the error code when a nested page fault
occurs during a guest page table walk, and PFERR_GUEST_FINAL_MASK when
the fault occurs on the final GPA-to-HPA translation.

Widen error_code in struct x86_exception from u16 to u64 to accommodate
the PFERR_GUEST_* bits (bits 32 and 33).

Update nested_svm_inject_npf_exit() to use fault->error_code directly
instead of hardcoding the upper bits. Also add a WARN_ON_ONCE if neither
PFERR_GUEST_FINAL_MASK nor PFERR_GUEST_PAGE_MASK is set, as this would
indicate a bug in the page fault handling code.

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 arch/x86/kvm/kvm_emulate.h     |  2 +-
 arch/x86/kvm/mmu/paging_tmpl.h | 22 ++++++++++------------
 arch/x86/kvm/svm/nested.c      | 11 +++++------
 3 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index fb3dab4b5a53e..ff4f9b0a01ff7 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -22,7 +22,7 @@ enum x86_intercept_stage;
 struct x86_exception {
 	u8 vector;
 	bool error_code_valid;
-	u16 error_code;
+	u64 error_code;
 	bool nested_page_fault;
 	u64 address; /* cr2 or nested page fault gpa */
 	u8 async_page_fault;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 901cd2bd40b84..923179bfd5c74 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -379,18 +379,12 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 		real_gpa = kvm_translate_gpa(vcpu, mmu, gfn_to_gpa(table_gfn),
 					     nested_access, &walker->fault);
 
-		/*
-		 * FIXME: This can happen if emulation (for of an INS/OUTS
-		 * instruction) triggers a nested page fault.  The exit
-		 * qualification / exit info field will incorrectly have
-		 * "guest page access" as the nested page fault's cause,
-		 * instead of "guest page structure access".  To fix this,
-		 * the x86_exception struct should be augmented with enough
-		 * information to fix the exit_qualification or exit_info_1
-		 * fields.
-		 */
-		if (unlikely(real_gpa == INVALID_GPA))
+		if (unlikely(real_gpa == INVALID_GPA)) {
+#if PTTYPE != PTTYPE_EPT
+			walker->fault.error_code |= PFERR_GUEST_PAGE_MASK;
+#endif
 			return 0;
+		}
 
 		slot = kvm_vcpu_gfn_to_memslot(vcpu, gpa_to_gfn(real_gpa));
 		if (!kvm_is_visible_memslot(slot))
@@ -446,8 +440,12 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 #endif
 
 	real_gpa = kvm_translate_gpa(vcpu, mmu, gfn_to_gpa(gfn), access, &walker->fault);
-	if (real_gpa == INVALID_GPA)
+	if (real_gpa == INVALID_GPA) {
+#if PTTYPE != PTTYPE_EPT
+		walker->fault.error_code |= PFERR_GUEST_FINAL_MASK;
+#endif
 		return 0;
+	}
 
 	walker->gfn = real_gpa >> PAGE_SHIFT;
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index de90b104a0dd5..f8dfd5c333023 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -40,18 +40,17 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
 	struct vmcb *vmcb = svm->vmcb;
 
 	if (vmcb->control.exit_code != SVM_EXIT_NPF) {
-		/*
-		 * TODO: track the cause of the nested page fault, and
-		 * correctly fill in the high bits of exit_info_1.
-		 */
-		vmcb->control.exit_code = SVM_EXIT_NPF;
-		vmcb->control.exit_info_1 = (1ULL << 32);
+		vmcb->control.exit_info_1 = fault->error_code;
 		vmcb->control.exit_info_2 = fault->address;
 	}
 
+	vmcb->control.exit_code = SVM_EXIT_NPF;
 	vmcb->control.exit_info_1 &= ~0xffffffffULL;
 	vmcb->control.exit_info_1 |= fault->error_code;
 
+	WARN_ON_ONCE(!(vmcb->control.exit_info_1 &
+		       (PFERR_GUEST_FINAL_MASK | PFERR_GUEST_PAGE_MASK)));
+
 	nested_svm_vmexit(svm);
 }
 
-- 
2.52.0.457.g6b5491de43-goog


