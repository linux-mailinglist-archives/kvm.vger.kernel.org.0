Return-Path: <kvm+bounces-60627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A379BF5170
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 09:53:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1415465BF3
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 07:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5E0F2F616B;
	Tue, 21 Oct 2025 07:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TrawG3Ex"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66582E9EDD
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 07:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761032937; cv=none; b=lUU92f+Gi/zP6Csm0jpClb09iM+nJQr9KaWWkS8omBxa5iN/4nMCUgZT4aAh/t6z3jgGGkYsekhJbmTOJGaunzfhZhTwvMUl/UZaRNFnbnI5X0VMc3ZhWnfS1Jl72TnwVP2D7VQ0PdZoetUwhli1Kogh7BRxkBhx28EZes4AAu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761032937; c=relaxed/simple;
	bh=mtIwWT8Nktn0uw9mNuy5ejlD6XdWbvYgsMXdyw5HXcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCvw7eLRDfe9qHGqGlgufWnmmcECOWj33KyXHkZRmpt9VQZX/WrDLK3pq60uNrsB6vQYrkNHJ/XITL1ZUvju60IzhfGcdN7E1I+Iyur23xtFTQVeUmllXDZHNYtKkptNnSJlze06TZ3+4/MIG8ts4slLrMtKAy1YC8DuoDF+wD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TrawG3Ex; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761032933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7BOHMwP1LaWFrXwyVNd/jaYf//p4/u+c41RTtzXqd10=;
	b=TrawG3ExK7CPm8ABxwoUAbjbtJ49fJ5iBtB2Ufa1g+UppwCaX4WnmC+NXxyVHLU2LqroVd
	qqRdhU6NZARYdRtXPHmA2hn5cc9NdxU7ElMpaCSsimjO254fimGW2pVuHluWoFyV0t0BS8
	sHLh43QwFDrblPaNHgwgssuemQK0PeA=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 17/23] KVM: selftests: Kill eptPageTablePointer
Date: Tue, 21 Oct 2025 07:47:30 +0000
Message-ID: <20251021074736.1324328-18-yosry.ahmed@linux.dev>
In-Reply-To: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace the struct overlay with explicit bitmasks, which is clearer and
less error-prone. See commit f18b4aebe107 ("kvm: selftests: do not use
bitfields larger than 32-bits for PTEs") for an example of why bitfields
are not preferrable.

Remove the unused PAGE_SHIFT_4K definition while at it.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/lib/x86/vmx.c | 37 +++++++++++------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index 46a491eb083c9..75996fc00501e 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -10,10 +10,16 @@
 #include "processor.h"
 #include "vmx.h"
 
-#define PAGE_SHIFT_4K  12
-
 #define KVM_EPT_PAGE_TABLE_MIN_PADDR 0x1c0000
 
+#define EPTP_MT_SHIFT		0 /* EPTP memtype bits 2:0 */
+#define EPTP_PWL_SHIFT		3 /* EPTP page walk length bits 5:3 */
+#define EPTP_AD_ENABLED_SHIFT	6 /* EPTP AD enabled bit 6 */
+
+#define EPTP_WB			(X86_MEMTYPE_WB << EPTP_MT_SHIFT)
+#define EPTP_PWL_4		(3ULL << EPTP_PWL_SHIFT) /* PWL is (levels - 1) */
+#define EPTP_AD_ENABLED		(1ULL << EPTP_AD_ENABLED_SHIFT)
+
 bool enable_evmcs;
 
 struct hv_enlightened_vmcs *current_evmcs;
@@ -36,14 +42,6 @@ const struct pte_masks ept_pte_masks = {
 	.nx		=	0,
 };
 
-struct eptPageTablePointer {
-	uint64_t memory_type:3;
-	uint64_t page_walk_length:3;
-	uint64_t ad_enabled:1;
-	uint64_t reserved_11_07:5;
-	uint64_t address:40;
-	uint64_t reserved_63_52:12;
-};
 int vcpu_enable_evmcs(struct kvm_vcpu *vcpu)
 {
 	uint16_t evmcs_ver;
@@ -198,16 +196,15 @@ static inline void init_vmcs_control_fields(struct vmx_pages *vmx)
 	vmwrite(PIN_BASED_VM_EXEC_CONTROL, rdmsr(MSR_IA32_VMX_TRUE_PINBASED_CTLS));
 
 	if (vmx->eptp_gpa) {
-		uint64_t ept_paddr;
-		struct eptPageTablePointer eptp = {
-			.memory_type = X86_MEMTYPE_WB,
-			.page_walk_length = 3, /* + 1 */
-			.ad_enabled = ept_vpid_cap_supported(VMX_EPT_VPID_CAP_AD_BITS),
-			.address = vmx->eptp_gpa >> PAGE_SHIFT_4K,
-		};
-
-		memcpy(&ept_paddr, &eptp, sizeof(ept_paddr));
-		vmwrite(EPT_POINTER, ept_paddr);
+		uint64_t eptp = vmx->eptp_gpa | EPTP_WB | EPTP_PWL_4;
+
+		TEST_ASSERT((vmx->eptp_gpa & ~PHYSICAL_PAGE_MASK) == 0,
+			    "Illegal bits set in vmx->eptp_gpa");
+
+		if (ept_vpid_cap_supported(VMX_EPT_VPID_CAP_AD_BITS))
+			eptp |= EPTP_AD_ENABLED;
+
+		vmwrite(EPT_POINTER, eptp);
 		sec_exec_ctl |= SECONDARY_EXEC_ENABLE_EPT;
 	}
 
-- 
2.51.0.869.ge66316f041-goog


