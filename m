Return-Path: <kvm+bounces-71587-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4AoXElFRnWkBOgQAu9opvQ
	(envelope-from <kvm+bounces-71587-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 08:20:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D9FF8182EEC
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 08:20:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 48B8430EF1CA
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 07:18:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B69C3644A7;
	Tue, 24 Feb 2026 07:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xLob06m6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81612364031
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 07:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771917510; cv=none; b=Tnjh8fvyVTuSXWHPQQ8qZj57I2nT/lA0yaW2WGAPh8hS4RCrJc/LrzzURlB1PX0E6F8AQ26xtkd4hrzNuTo0r/OwJfRp54LHiisPozytPHz3ZxfAd89JTw/IlEjpe6OlJZ2ozpp4e+bjW0C7D3rdV1VlGypRgiPI5AA5nf7Fs0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771917510; c=relaxed/simple;
	bh=t/4eIGDwcWrsgm4X+m3qrlgXmkeUOwyBevemJiQ3rw8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r2lVrL3Efp29nabrW6C9c+IHp/AtdXFjhOZf8DNGnwzhPTjil1kKysF12SfOmN/ESM7cKQzvMdUtSEZ+r8IwiQWCxrQi+4lgdWs+PCvVLIKJAiBrVpUz6gdHV0Q29hMf/xdYjtkBgfMKkWz0fG0NfNB6pyurlZk+6oaHcTa/GT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xLob06m6; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35464d7c539so5061764a91.0
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 23:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771917509; x=1772522309; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S3RqoxsfWqLtznrpktgtZU0l3Zon+Utvni3pymAleg0=;
        b=xLob06m6XFexsyI51qWObnTlF+cRh7n7wYtkMPzYdV0VevYfKp1WuMeyvWB1Yftiau
         +R0nBeW/xFAbeoVpUCRN8jvGfqp9mYKwsZGccukrsFCEI4Wyp2Bnn8cw0LioNBC7Bn8h
         3R8zbFcQt5VfbWNAX43c+giCq80MTWaTa8/sumA/KVc+ctgdp72PWSkIZGNV0M98pWwA
         EVz3jL26yLnWvbwqPc08txg/9/5hf3fNMVzl8Rs3CQ9CKoG1SwKP7CPESq+EM5qiQv3T
         klgOd+x6DuH34FLv5+dii/JPnKBNtXO7GA6zD96A/9/tQkG3FFZjFWdzH7+GWgfg2Oqz
         8yDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771917509; x=1772522309;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S3RqoxsfWqLtznrpktgtZU0l3Zon+Utvni3pymAleg0=;
        b=gbmriT7Kl2AXoYllJ+VEl2bpkB1Cz+YMdS90GZ4HwR8ptvy35MExsFvMayzzrnv9UQ
         H1OcaHA2VlnjHo6UpqXQf4iyt2gdKNl98MYz9V7NV4K5T8pqb8NWvflWq7s3jXkw1yId
         hlLenKwZPudix3LoKbVaKM9jbi2eDxDfPi1le9mV/Zezz/n6ZH/z46Q546rk8lV1RjJu
         zXUvk/VUNAjefD6QHsnd86pI1G2r3dwIPCaOiia1doPv9OmMpnkkZkSmSpRil76ug0mV
         I7sEV31d9zL710bdfotr4GepodtZ6Sc9V8KsoSHCVF49QW4Rf/IN7YH2xWv7oDNGPAj3
         ycNQ==
X-Gm-Message-State: AOJu0YzG+HmvIJNDDvmJ4teLM8SDp90gexCxz3DdtFASHUFiwzdY98aT
	5eHg4LZbcrhFWKuW0w+NQ7629ljVy6tlTqkvHHuRdTQ6zUMkmJ+endtCS8stp4xxNe1ESP02XEG
	t+A0xjoaKvXu/6g==
X-Received: from pjbsm18.prod.google.com ([2002:a17:90b:2e52:b0:353:2ac6:b59b])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:53ce:b0:356:2fee:92c4 with SMTP id 98e67ed59e1d1-358ae8ce789mr11164142a91.24.1771917508746;
 Mon, 23 Feb 2026 23:18:28 -0800 (PST)
Date: Tue, 24 Feb 2026 07:18:20 +0000
In-Reply-To: <20260224071822.369326-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224071822.369326-1-chengkev@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260224071822.369326-3-chengkev@google.com>
Subject: [PATCH V2 2/4] KVM: SVM: Fix nested NPF injection to set PFERR_GUEST_{PAGE,FINAL}_MASK
From: Kevin Cheng <chengkev@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yosry.ahmed@linux.dev, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71587-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chengkev@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D9FF8182EEC
X-Rspamd-Action: no action

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
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu/paging_tmpl.h  | 22 ++++++++++------------
 arch/x86/kvm/svm/nested.c       | 19 +++++++++++++------
 3 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ff07c45e3c731..454f84660edfc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -280,6 +280,8 @@ enum x86_intercept_stage;
 #define PFERR_GUEST_RMP_MASK	BIT_ULL(31)
 #define PFERR_GUEST_FINAL_MASK	BIT_ULL(32)
 #define PFERR_GUEST_PAGE_MASK	BIT_ULL(33)
+#define PFERR_GUEST_FAULT_STAGE_MASK \
+	(PFERR_GUEST_FINAL_MASK | PFERR_GUEST_PAGE_MASK)
 #define PFERR_GUEST_ENC_MASK	BIT_ULL(34)
 #define PFERR_GUEST_SIZEM_MASK	BIT_ULL(35)
 #define PFERR_GUEST_VMPL_MASK	BIT_ULL(36)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 37eba7dafd14f..f148c92b606ba 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -385,18 +385,12 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
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
@@ -452,8 +446,12 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
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
index de90b104a0dd5..1013e814168b5 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -40,18 +40,25 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
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
 
+	/*
+	 * All nested page faults should be annotated as occurring on the
+	 * final translation *or* the page walk. Arbitrarily choose "final"
+	 * if KVM is buggy and enumerated both or neither.
+	 */
+	if (WARN_ON_ONCE(hweight64(vmcb->control.exit_info_1 &
+				   PFERR_GUEST_FAULT_STAGE_MASK) != 1)) {
+		vmcb->control.exit_info_1 &= ~PFERR_GUEST_FAULT_STAGE_MASK;
+		vmcb->control.exit_info_1 |= PFERR_GUEST_FINAL_MASK;
+	}
+
 	nested_svm_vmexit(svm);
 }
 
-- 
2.53.0.414.gf7e9f6c205-goog


