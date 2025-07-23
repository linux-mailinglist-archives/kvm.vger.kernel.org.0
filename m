Return-Path: <kvm+bounces-53294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85F0DB0F9C5
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 19:58:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15590967F2E
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5275B244662;
	Wed, 23 Jul 2025 17:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="SBG5DkO3"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011B8223704;
	Wed, 23 Jul 2025 17:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753293280; cv=none; b=UJ+ZHUexibZ6Bdzuz68Dq8boI4gwaSdz2zfX52+FAWMKReChOd8MK4APwh4a1xEWTMm4q0ZqC30Yb+v+ARV2JQm9drqWn5IrHCdTxXmL6uLOxn0oQV79zbfaaqpQ+fI6M4K3p8LdjjId+cujc2sk7sjzrzGqVd2UNL5mEBjAx7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753293280; c=relaxed/simple;
	bh=cIId5kcAjZVRwjWCEwIG02N9gFcnlWs3CphxzwwvPHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6MaqZ0Gihbq9e/j9OzJTg6Gl8X5mPDt+gf4in4G3X9ENr8T2JDJvcMZWDDBMvmWmKoExKJnj2lOBG83i5mCy2mPteTp1Lk/nXDpjJlxqHx61vAIKy8Re1+6W+2Zp3Nha+KoflBN8RAkiGMl2gVvYg1vmHHvk0L7nJoOG6V5oSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=SBG5DkO3; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56NHrfxr1284522
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 23 Jul 2025 10:53:48 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56NHrfxr1284522
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1753293229;
	bh=ezk0SHtbQQhiYpEbIX5qyLWNRlt8kAg5n8VSrXZq8vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SBG5DkO3dKiHcTN75kdVqAXWeltE94c7xBGWTKYJvw/yS2O39DTLlnwCB5AWSfR0O
	 UHpFDiDCe7lnxhMPqFPCocHavFsj/RYgi+yF5wOGHOB3RxP//ubMVDp+FAGLtLqmXm
	 pD0DYchlwuKkWC9U5wPR1rT7hmGjBnV3N6E3wOInhZ4NLaZzuGxnOR5rz7snb/Nx00
	 Qu7hbQvHhYZxYrJEFCufscaoqsK+jE4lKAmo0NSo6gN51Sm5WVo0zH+RJui2wlWhcB
	 U4rCtufoAnV7W2vXxh/Tw/03BEcp7QqHSeDsWCjIg+bgxJfgndjL7qMEIzGRk/hfHn
	 7DNLbpbkZET9w==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v5 03/23] KVM: VMX: Disable FRED if FRED consistency checks fail
Date: Wed, 23 Jul 2025 10:53:21 -0700
Message-ID: <20250723175341.1284463-4-xin@zytor.com>
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
index 7cdc855f8968..76c69685b9be 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -399,6 +399,16 @@ static inline bool vmx_pebs_supported(void)
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
index 463fc4a65788..c893ea2db9de 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7883,6 +7883,9 @@ static __init void vmx_set_cpu_caps(void)
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


