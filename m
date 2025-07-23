Return-Path: <kvm+bounces-53289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EC53AB0F9B5
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 19:56:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D3975674E6
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:56:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C10023AB8B;
	Wed, 23 Jul 2025 17:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="vqCMaCrf"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CC32367CB;
	Wed, 23 Jul 2025 17:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753293264; cv=none; b=Ke/g1Q5AwiXytz0xjOyCz1KIrXcVhdajyW0qGK/Aw4pvhI32p/wlct7zxaieeQFB5p3/0uhIRBv0QFPkKDPSObtLcSIwM4+nyoLIY4ebEo5pLJpP2JhWJjTZHsCTVw5uZLzzisgnFSEhAN1wDF1jXAVrsPwt0dBjnsjMIeOcsc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753293264; c=relaxed/simple;
	bh=nx+dM1oAmgKShxYD34/rKstbrQTJJ02Iouc+nLSEfzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpmfBU0dQl8QXzwVTx+XiY+NOnzNFzXCIn34/MTmqNlg9D4P0iUUmtEHtLzLWAj39YD6gc5Lye0Uc6cY+A8haU1iW+aEiVauMCiVlPXmLt3mKMD752aU/oLavfujcKeWis7rZkNJ8Dyt0i5jkBrXDnbtjc/K4F7Hfr4fd99dcJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=vqCMaCrf; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56NHrfxx1284522
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 23 Jul 2025 10:53:53 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56NHrfxx1284522
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1753293234;
	bh=i+ns0F2Ex+xQMQzvK4DIkApu0w0I3TMwsyhuQp7IOIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vqCMaCrfuK3EFBb44a6prpg8hUMjSWnSTZOAmZS6HL+dFxlE42uMGgCrBbVJiGWiv
	 qNJqZQ81Etg6DF4y51EGvp97F/8suMJKDu1hDoh2+5KpKHb6ut5nbpznXoenVXZgqa
	 DKlEis3ly8fec0DXDBB/q3frl8dRGOtgKlHiQn6G7iagDUvr7lbKKFZYdcrOMYtnV+
	 ETkU3ASxbPwn9qMAXncgiB5qBo3Hy2PPXc/22wFVUAWateG5kWomd319cKX/o9Fup+
	 XhsmunL4UmzU3rh5MuidZio1RlK59vSRLodD1KJGEhMwXYt36COyZ73yRMY6yaSB6L
	 /qQIcT52trHfw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v5 09/23] KVM: VMX: Add host MSR read/write helpers to streamline preemption logic
Date: Wed, 23 Jul 2025 10:53:27 -0700
Message-ID: <20250723175341.1284463-10-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250723175341.1284463-1-xin@zytor.com>
References: <20250723175341.1284463-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

Introduce helper functions for host MSR access to centralize and simplify
preemption handling.  This improves code readability and reduces duplication,
laying the groundwork for a cleaner implementation of FRED RSP0 access
functions in the following patch.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/kvm/vmx/vmx.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1e58d61dc021..53dce136e24b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1358,22 +1358,35 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
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
 
-- 
2.50.1


