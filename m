Return-Path: <kvm+bounces-42202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 048AEA74F13
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 18:17:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B981F177808
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 17:15:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3432E1EFF8A;
	Fri, 28 Mar 2025 17:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="JrVWVVso"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EE81DF270;
	Fri, 28 Mar 2025 17:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743181998; cv=none; b=fIAxzOmgrO90kS8DlDzdnIuh0SZOujsvQy/3Kslj/eT2hXE4sm/WxtLv/OtmlhStmjI4zLg+jUT3+hpw+0wPj+lYrOBu55IRdX+WVlvYPrJ05h93nvdPOMuzS0rrH15lqrl86KSnGto2h96ZHDKwhtfIIyHslOQJDXVJR5AUtF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743181998; c=relaxed/simple;
	bh=gebgWyVkhjoOy4t4bTNTbbSDcBOSmbnTCuPZiJq+ICc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPqrru8w1Jc5pJ6PbEauIwHkn/qXDEqCBBdOXf6YOud/SGWkU4jzKsbedwqcBeHKmR0f88VMhdEpraXVKYf8tDJpUXJRBi3mbipXEUOPBPFKEalQknjgxmQct1lkF/E0CivvSRMmgR5YhzfzNFhqJdleFwMeXF5UqEBrujv3oh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=JrVWVVso; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 52SHC6vZ2029344
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 28 Mar 2025 10:12:16 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 52SHC6vZ2029344
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1743181937;
	bh=a9aWUyvGAoEKwOVYYfSru+/Z/oKl0P1AvWbOapVtHaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JrVWVVsoVe6gopIVnEJ+yOY2iMe6XlrMoqoUVzI0VBF8VPCdfr4sDHu8qR87m/j5j
	 rs4cqQsLR+vCLJjjnrYPvZMNKaKUFM7m68b+gmwSJecl1CHGqjGVS3vF0l2A6wgBQe
	 UI7sTVlOh925AWYvl46tQe+A9BFUfvoOStBRxN0jFD79i/kZ8eoDyxxAMhf2gWI/mz
	 ZHuUKZLVht+VA2b9jqz4V/ebh+cTWUPOaNdz9xRJ+BG+1aJQVtbuvPyPq732/g/OSp
	 EEzl2a3Lm0SlaGjWkB6DUU0D6rM0T2M9MQpFi5XzADRIbWIxjLu2okqB+CwfVhcyOd
	 eotze1R39aiQQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        andrew.cooper3@citrix.com, luto@kernel.org, peterz@infradead.org,
        chao.gao@intel.com, xin3.li@intel.com
Subject: [PATCH v4 03/19] KVM: VMX: Disable FRED if FRED consistency checks fail
Date: Fri, 28 Mar 2025 10:11:49 -0700
Message-ID: <20250328171205.2029296-4-xin@zytor.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250328171205.2029296-1-xin@zytor.com>
References: <20250328171205.2029296-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Do not virtualize FRED if FRED consistency checks fail.

Either on broken hardware, or when run KVM on top of another hypervisor
before the underlying hypervisor implements nested FRED correctly.

Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---

Change in v4:
* Call out the reason why not check FRED VM-exit controls in
  cpu_has_vmx_fred() (Chao Gao).
---
 arch/x86/kvm/vmx/capabilities.h | 11 +++++++++++
 arch/x86/kvm/vmx/vmx.c          |  3 +++
 2 files changed, 14 insertions(+)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index b2aefee59395..b4f49a4690ca 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -400,6 +400,17 @@ static inline bool vmx_pebs_supported(void)
 	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
 }
 
+static inline bool cpu_has_vmx_fred(void)
+{
+	/*
+	 * setup_vmcs_config() guarantees FRED VM-entry/exit controls
+	 * are either all set or none.  So, no need to check FRED VM-exit
+	 * controls.
+	 */
+	return cpu_feature_enabled(X86_FEATURE_FRED) &&
+		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_FRED);
+}
+
 static inline bool cpu_has_notify_vmexit(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e38545d0dd17..ab84939ace96 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8052,6 +8052,9 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_check_and_set(X86_FEATURE_DTES64);
 	}
 
+	if (!cpu_has_vmx_fred())
+		kvm_cpu_cap_clear(X86_FEATURE_FRED);
+
 	if (!enable_pmu)
 		kvm_cpu_cap_clear(X86_FEATURE_PDCM);
 	kvm_caps.supported_perf_cap = vmx_get_perf_capabilities();
-- 
2.48.1


