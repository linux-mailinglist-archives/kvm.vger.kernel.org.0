Return-Path: <kvm+bounces-50861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AF5EAEA449
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 19:17:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D7A0179489
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 17:17:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40E842EAD0E;
	Thu, 26 Jun 2025 17:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="UDKvCF6f"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2FED2FF;
	Thu, 26 Jun 2025 17:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750958215; cv=none; b=oh+uY9rB0dtnoZZUf7NTkNLBNqn3fAneDVxLDvIedpV0jknpHwRR8aazCKNV2OAW66pe3EUWnNZKS/IsdxxhiQoNK2U8zJ86qQl9zEZDR4KYFF97JAkj3COF8ll/ENNp1IUKrhDfx2wtpAFM1UNRVqvVjUdXjAGVpAHDLMvzezg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750958215; c=relaxed/simple;
	bh=4RIeEsfrky8cqeqXUVOqNeXCdwyYRFH9Nsn25t4SsQc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bhmDAcb9vFgJF1TL6vZfZ3ymVvqw/w44vsADbnEulCxzwwS9Zyc8yH1naNiadMC9eQRJICVOX5bxkeK//86bDov+XU69+rzCOjlkdQxdNPICKvJte7kGgtSGhIwNNFLKpO/WXOzHl2p3boIltK0XP+JjzSzuBuZUb4dDHg/txFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=UDKvCF6f; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55QHG1AR2293924
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Thu, 26 Jun 2025 10:16:06 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55QHG1AR2293924
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025062101; t=1750958166;
	bh=UoQ2GEoCdX4ckMgjYXWRsxYs9/q84NF5zBjzStuss1U=;
	h=From:To:Cc:Subject:Date:From;
	b=UDKvCF6fONZwepWQKSIeFoBSKAsyhTo+3hGDUeD+DH6nuY3Z8vd5nf4LdJkRcy/TP
	 b6I3GAIK3WATxsx/l4BGdrs0FfJl2jutxYnEiEVav3W8/IRcvkfySe/KOspB1hQBg0
	 U2cZqpWHeqbhFFgsX55YzMW8fMfr9ooWRGVcL/FqzWdPYInOo1uaBCgubPZU2kHtcs
	 no5NZaGLTin1gsOIan5R99JG+gVgbiDfGWe02odDWVPO81b//XyKEgtGvSdB+JZTza
	 q3oPq+63WtreHjrLyfYNOcRTIt1vlBLgqxWRTpKFay57hQy4sGqu1EI6vs4wZ2QQsL
	 dQ3/WX2tKeKzA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, chao.gao@intel.com
Subject: [PATCH v1 1/1] KVM: VMX: Add host MSR read/write helpers to consolidate preemption handling
Date: Thu, 26 Jun 2025 10:16:01 -0700
Message-ID: <20250626171601.2293914-1-xin@zytor.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

Add host MSR read/write helpers to consolidate preemption handling to
prepare for adding FRED RSP0 access functions without duplicating the
preemption handling code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/kvm/vmx/vmx.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4953846cb30d..df5355b08431 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1399,22 +1399,35 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
 }
 
 #ifdef CONFIG_X86_64
-static u64 vmx_read_guest_kernel_gs_base(struct vcpu_vmx *vmx)
+static u64 vmx_read_guest_host_msr(struct vcpu_vmx *vmx, u32 msr, u64 *cache)
 {
 	preempt_disable();
 	if (vmx->vt.guest_state_loaded)
-		rdmsrq(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
+		*cache = read_msr(msr);
 	preempt_enable();
-	return vmx->msr_guest_kernel_gs_base;
+	return *cache;
 }
 
-static void vmx_write_guest_kernel_gs_base(struct vcpu_vmx *vmx, u64 data)
+static void vmx_write_guest_host_msr(struct vcpu_vmx *vmx, u32 msr, u64 data,
+				     u64 *cache)
 {
 	preempt_disable();
 	if (vmx->vt.guest_state_loaded)
-		wrmsrq(MSR_KERNEL_GS_BASE, data);
+		wrmsrns(msr, data);
 	preempt_enable();
-	vmx->msr_guest_kernel_gs_base = data;
+	*cache = data;
+}
+
+static u64 vmx_read_guest_kernel_gs_base(struct vcpu_vmx *vmx)
+{
+	return vmx_read_guest_host_msr(vmx, MSR_KERNEL_GS_BASE,
+				       &vmx->msr_guest_kernel_gs_base);
+}
+
+static void vmx_write_guest_kernel_gs_base(struct vcpu_vmx *vmx, u64 data)
+{
+	vmx_write_guest_host_msr(vmx, MSR_KERNEL_GS_BASE, data,
+				 &vmx->msr_guest_kernel_gs_base);
 }
 #endif
 

base-commit: e4775f57ad51a5a7f1646ac058a3d00c8eec1e98
-- 
2.50.0


