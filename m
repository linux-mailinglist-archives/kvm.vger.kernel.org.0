Return-Path: <kvm+bounces-56339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1E7CB3BF60
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 17:35:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3813817DF5B
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 15:35:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE9D3335BBC;
	Fri, 29 Aug 2025 15:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="IjT2u0ZS"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24BE322750;
	Fri, 29 Aug 2025 15:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756481591; cv=none; b=onLUYMHI3dgPFfx6Fi26bN7PtgZHNhIN1Co1JGiJ3FMvSax797cAwbFSXsTjSxhLHbNqAJSILtg84qgyxxGYG+aA/O8Dmjt8BOnAIfqPM2T6BfH7W1iK1S0BRVe4OUVN8t7HMKe1AZs6/okwqUxeKdozbUM7eBOXn5qTsS6j1Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756481591; c=relaxed/simple;
	bh=XYSogkyqKJmDNOoavnrgelOUo2Y5qU9bg2gISgmxnDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iaqCVql04iy5+Dx0Xr065PQaTdxc/n63s2cNc+UJfNiSDNLPsA48huGIf/7m3smz0g5yLo4L+XaF0oPI8zJu6nRDQiIAD/uMs/CgMY5jdf+aTQOyd5bdoeu7eJtbPhkDMaEqhcs8gp/Vu+YazgrRs54BMPR1hXJ8RJhLiIAwRJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=IjT2u0ZS; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57TFVo492871953
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 29 Aug 2025 08:32:14 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57TFVo492871953
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1756481535;
	bh=BKIhi2HRmuVi1d+LJMGpfctVa/64EyGlYG2YgyGtIHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IjT2u0ZSQ7D2hji71Lu3F2s8TLBoD5+0YlaR2MHRD2CM2IVpsam6EcIWndMXeUVeW
	 VTVyoj10Q+ndktScH7vS5yg8meXwYgpEZ+8V3ha0Iek/ZTt+xvuNA1H7ERQ9Ru2fb7
	 WGRq9ZalxwKhhesM980acsANKuQWUgHKDCLdrpkHkPIzUPsLXemRdMUHRVBgUFz8Yc
	 oE0xdZHWpkp/u9hLrly6a0bAYuejkM++ZIWF2RLXOZGQDDeMsYwBpbEJ/a5lAuvRAy
	 hwe11kGE+KB1wMPgYRC1mpYitoEvC63czdGYjmEx5s/ETGIpu1JeJP6Aa81IBneAwE
	 7i1tGqFQYHsBg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v7 03/21] KVM: VMX: Disable FRED if FRED consistency checks fail
Date: Fri, 29 Aug 2025 08:31:31 -0700
Message-ID: <20250829153149.2871901-4-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829153149.2871901-1-xin@zytor.com>
References: <20250829153149.2871901-1-xin@zytor.com>
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
2.51.0


