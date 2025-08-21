Return-Path: <kvm+bounces-55425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9203EB30956
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 00:40:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DC07606841
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA3B42FC007;
	Thu, 21 Aug 2025 22:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="CwmTsXAI"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B122EA75F;
	Thu, 21 Aug 2025 22:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755815881; cv=none; b=R1L/2D9ho7hXhUpJ65kwXg9lP1WXbT123i3UaB0xuhtie8V6drgeT55J2Mod+dE4KYxw7MUcGTPZNx5ljtpli8AvbGW8uWUz4/Y1d5oU/McA/WdPHbj5T1DATCVMumxAdHh4bM9jo5Rear1qu0tZGtPSeMSyPkkeI3d9i3jTjus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755815881; c=relaxed/simple;
	bh=bb+mMM+2R1GGL+ISqfJEjc8M0WPMQMYHn8h9/LNEH7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/4kHw+EMnQ0ufjiau/u7lKdTzl5PKsgP0Byld0kIiZnI5JxvdbnTdfLg22xPg2cA8lCIOSYBPA8VizL2umjrlP+F/retQOguVR3l95horQ13V98lm8iBbuyoDaszWclb2uOb/ob/aq2e2PG5gSFLZlkReyqp9IS4hcF1Yo/nMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=CwmTsXAI; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57LMaUOR984441
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Thu, 21 Aug 2025 15:36:44 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57LMaUOR984441
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1755815804;
	bh=pVfsURoxW25plJu6OY0riprPo8AJo3HjtE6mfTFD3hU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CwmTsXAIPRUGpBLi9PTGnrR3Qoo9/2azgyoQHG1bG+SnU/OX0pqaKd0TeTvy/dokC
	 xrtlFbEVoxtZ4AypMLpdcukuLJhAkRb5msqsuGu5p1gJJDOlCQPQJGyvWnU0SJHIJt
	 AT3qPktZwm5i83iU0DcMOhevSinFEJiUH5zQdC3FkxRbLGW8OTeYt1JBnxrqKV2Da1
	 5aM1jD/MGQh19bmbgiOfATXMjaOCwQ6uTBfJQ30CtAarTKdegk47gZmRRa1wE0oxyY
	 QJ3nkS8soA/iqtjnRGGNm9Df89Ing47KNnxd2je403sRSb3ATEDZYY41fMOMcw+Dwu
	 esgCxbdMCf4yg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v6 03/20] KVM: VMX: Disable FRED if FRED consistency checks fail
Date: Thu, 21 Aug 2025 15:36:12 -0700
Message-ID: <20250821223630.984383-4-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821223630.984383-1-xin@zytor.com>
References: <20250821223630.984383-1-xin@zytor.com>
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
Reviewed-by: Chao Gao <chao.gao@intel.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Changes in v5:
* Drop the cpu_feature_enabled() in cpu_has_vmx_fred() (Sean).
* Add TB from Xuelian Guo.

Change in v4:
* Call out the reason why not check FRED VM-exit controls in
  cpu_has_vmx_fred() (Chao Gao).
---
 arch/x86/kvm/vmx/capabilities.h | 10 ++++++++++
 arch/x86/kvm/vmx/vmx.c          |  3 +++
 2 files changed, 13 insertions(+)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 7b9e306c359d..7fe95a601c9f 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -408,6 +408,16 @@ static inline bool vmx_pebs_supported(void)
 	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
 }
 
+static inline bool cpu_has_vmx_fred(void)
+{
+	/*
+	 * setup_vmcs_config() guarantees FRED VM-entry/exit controls
+	 * are either all set or none.  So, no need to check FRED VM-exit
+	 * controls.
+	 */
+	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_FRED);
+}
+
 static inline bool cpu_has_notify_vmexit(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3b5e2805a06d..c8b95c215869 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7993,6 +7993,9 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_check_and_set(X86_FEATURE_DTES64);
 	}
 
+	if (!cpu_has_vmx_fred())
+		kvm_cpu_cap_clear(X86_FEATURE_FRED);
+
 	if (!enable_pmu)
 		kvm_cpu_cap_clear(X86_FEATURE_PDCM);
 	kvm_caps.supported_perf_cap = vmx_get_perf_capabilities();
-- 
2.50.1


