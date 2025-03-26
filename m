Return-Path: <kvm+bounces-42049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F727A71F43
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 20:37:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 94DAA1897FB8
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 19:37:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BF7725A337;
	Wed, 26 Mar 2025 19:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Dala95Bq"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDDA254841
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 19:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743017816; cv=none; b=sJwSkn6oo7EMwZujWsZFpIrth6eIPn01RaiYS3WqSKZZgnEhZlAo95LAu4a3St4B07zI34BvqhA0G52ab9foFmIzTXzLGJtDgLuihcKEil9IOJkiWDdvUlVEFnrTf2sKts5y2/Iy7s1FwIuj6UHuEHtYHZKUhQN+hBj4GkGqdTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743017816; c=relaxed/simple;
	bh=YvYluCdRqn1n/JT+nL56Yz6B6C0twwPC3TK/14P/6hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WiPuSU+ZWiBuRFXkcXYTSxUiY2Oo7B+GvzWhB/XKJEnRd428mkmXTJhba0xZWEhS9hCPu8pnWGD8SHeRusz+IAGe4jdzNilqqsUkBlVcHKPULOIqj2kq49zfGcEm5tgFgWCD1BRPrvteYIJF/Kh8iLj+YejAoPZ3B9VL1ex32ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Dala95Bq; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743017812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6pm4uB86DLmtiLvSaBm4Xw5WzvPE3xj0w8EcuSLIOjk=;
	b=Dala95BqNdYk4YtAOcjNp8MdXBphtp86KKVDtguDgQWMxCjEMXO8dYsGVVIeAE6Txh3mTM
	oUfsveBDijb9R59To01OMfQ0o3oLOKAcs+k44ajAvgOu52fBYI2H1zfRz1br//Ft9290TV
	4Fijf3wUvuP1csQT13f3Tq6Tfe8uI3k=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [RFC PATCH 04/24] KVM: SVM: Flush everything if FLUSHBYASID is not available
Date: Wed, 26 Mar 2025 19:35:59 +0000
Message-ID: <20250326193619.3714986-5-yosry.ahmed@linux.dev>
In-Reply-To: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Currently, if FLUSHBYASID is not available when performing a TLB flush,
the fallback is decrementing the ASID generation to trigger allocating a
new ASID. In preparation for using a static ASID per VM, just fallback
to flushing everything if FLUSHBYASID is not available. This is probably
worse from a performance perspective, but FLUSHBYASID has been around
for ~15 years and it's not worth carrying the complexity.

The fallback logic is moved within vmcb_set_flush_asid(), as more
callers will be added and will need the fallback as well.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/svm.c | 5 +----
 arch/x86/kvm/svm/svm.h | 5 ++++-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0e302ae9a8435..5f71b125010d9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4005,10 +4005,7 @@ static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
 	 * unconditionally does a TLB flush on both nested VM-Enter and nested
 	 * VM-Exit (via kvm_mmu_reset_context()).
 	 */
-	if (static_cpu_has(X86_FEATURE_FLUSHBYASID))
-		vmcb_set_flush_asid(svm->vmcb);
-	else
-		svm->current_vmcb->asid_generation--;
+	vmcb_set_flush_asid(svm->vmcb);
 }
 
 static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d2c49cbfbf1ca..843a29a6d150e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -416,7 +416,10 @@ static inline bool vmcb_is_dirty(struct vmcb *vmcb, int bit)
 
 static inline void vmcb_set_flush_asid(struct vmcb *vmcb)
 {
-	vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
+	if (static_cpu_has(X86_FEATURE_FLUSHBYASID))
+		vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
+	else
+		vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
 }
 
 static inline void vmcb_clr_flush_asid(struct vmcb *vmcb)
-- 
2.49.0.395.g12beb8f557-goog


