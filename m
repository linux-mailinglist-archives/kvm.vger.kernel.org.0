Return-Path: <kvm+bounces-24246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CD1D952E52
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 14:34:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44AE61C213D5
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 12:34:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB69819DF46;
	Thu, 15 Aug 2024 12:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iat9zcUq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6742A19AD87
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 12:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723725260; cv=none; b=rphAuGDXZ0Q6cPu6aSpxp9+scRCekHsXqRBbCdBKuoyJlp93MUoE6pfJp398jHPjWuvshqP8GxUzV84ctLoPAB1rL9jHe/7f9O4niKu4M5VAY+lMawb+7hk3UWcslSp7hoWA1jxQZM4e7L1S3DdDGJGEkeTjh+GlUKv+JRdFGkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723725260; c=relaxed/simple;
	bh=dQ/ir3vQ9ouA0LmBdDr63FP3X4MzqfAiwaQXviqoWnk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BQqpklDggBBXo/W8St0V2+ZlGecvZ0QR2lenLDjosXaDJlGJFAoUNmYM6gFEpbzbSDRnwDDRjB2SE8GL2CT4Cl4x11KTXebp354/L3nk6Jq9wFnreXogWK71a4oBv3reRAfRv93TZl2qG60ns0FtX6f7EQ6v8NExekjDubdz02c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iat9zcUq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723725257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r2j3nr2A+M+KDmPmnEY7wcKSJ4O6nztQF6dfOdyUn9w=;
	b=iat9zcUqmtgWKXUY4qFEMTH+nF0CBjQpSahEgyVSRi998MdNPeDafzvQhFa92PIEaeyDjS
	3NNHvVL49D4vbFBqKXPFyW0uiMmL02L5gpWCmvNljFN+9E2idNSbkfPvW792q+QgPnStav
	sOBsgfDpISteqEGH1e9FqIwbFTjhN2k=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-546-npIXaveMMNqW-Zv7_yduJg-1; Thu,
 15 Aug 2024 08:34:12 -0400
X-MC-Unique: npIXaveMMNqW-Zv7_yduJg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 715EB19560A3;
	Thu, 15 Aug 2024 12:34:10 +0000 (UTC)
Received: from intellaptop.lan (unknown [10.47.238.120])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8B8B8300019C;
	Thu, 15 Aug 2024 12:34:05 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>,
	x86@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Borislav Petkov <bp@alien8.de>,
	linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Chao Gao <chao.gao@intel.com>
Subject: [PATCH v3 1/4] KVM: x86: relax canonical check for some x86 architectural msrs
Date: Thu, 15 Aug 2024 15:33:46 +0300
Message-Id: <20240815123349.729017-2-mlevitsk@redhat.com>
In-Reply-To: <20240815123349.729017-1-mlevitsk@redhat.com>
References: <20240815123349.729017-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Several x86's arch msrs contain a linear base, and thus must
contain a canonical address.

This includes FS/GS base, addresses used for SYSENTER and SYSCALL
instructions and probably more.

As it turns out, when x86 architecture was updated to 5 level paging /
57 bit virtual addresses, these MSRs were allowed to contain a full
57 bit address regardless of the state of CR4.LA57.

The main reason behind this decision is that 5 level paging, and even
paging itself can be temporarily disabled (e.g by SMM entry) leaving non
canonical values in these fields.
Another reason is that OS might prepare these fields before it switches to
5 level paging.

Experemental tests on a Sapphire Rapids CPU and on a Zen4 CPU confirm this
behavior.

In addition to that, the Intel ISA extension manual mentions that this
might be the architectural behavior:

Architecture Instruction Set Extensions and Future Features Programming
Reference [1], Chapter 6.4:

"CANONICALITY CHECKING FOR DATA ADDRESSES WRITTEN TO CONTROL REGISTERS AND
MSRS"

"In Processors that support LAM continue to require the addresses written
tocontrol registers or MSRs to be 57-bit canonical if the processor
supports 5-level paging or 48-bit canonical if it supports only 4-level
paging"

[1]: https://cdrdv2.intel.com/v1/dl/getContent/671368

Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ce7c00894f32..2e83f7d74591 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -302,6 +302,31 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
 		       sizeof(kvm_vcpu_stats_desc),
 };
 
+
+/*
+ * Most x86 arch MSR values which contain linear addresses like
+ * segment bases, addresses that are used in instructions (e.g SYSENTER),
+ * have static canonicality checks,
+ * size of whose depends only on CPU's support for 5-level
+ * paging, rather than state of CR4.LA57.
+ *
+ * In addition to that, some of these MSRS are directly passed
+ * to the guest (e.g MSR_KERNEL_GS_BASE) thus even if the guest
+ * doen't have LA57 enabled in its CPUID, for consistency with
+ * CPUs' ucode, it is better to pivot the check around host
+ * support for 5 level paging.
+ */
+
+static u8  max_host_supported_virt_addr_bits(void)
+{
+	return kvm_cpu_cap_has(X86_FEATURE_LA57) ? 57 : 48;
+}
+
+static bool is_host_noncanonical_msr_value(u64 la)
+{
+	return !__is_canonical_address(la, max_host_supported_virt_addr_bits());
+}
+
 static struct kmem_cache *x86_emulator_cache;
 
 /*
@@ -1829,7 +1854,7 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 	case MSR_KERNEL_GS_BASE:
 	case MSR_CSTAR:
 	case MSR_LSTAR:
-		if (is_noncanonical_address(data, vcpu))
+		if (is_host_noncanonical_msr_value(data))
 			return 1;
 		break;
 	case MSR_IA32_SYSENTER_EIP:
@@ -1846,7 +1871,7 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 		 * value, and that something deterministic happens if the guest
 		 * invokes 64-bit SYSENTER.
 		 */
-		data = __canonical_address(data, vcpu_virt_addr_bits(vcpu));
+		data = __canonical_address(data, max_host_supported_virt_addr_bits());
 		break;
 	case MSR_TSC_AUX:
 		if (!kvm_is_supported_user_return_msr(MSR_TSC_AUX))
-- 
2.40.1


