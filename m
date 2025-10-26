Return-Path: <kvm+bounces-61107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A1064C0B26F
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 21:24:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5B6274ED565
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 20:22:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 127E33002DF;
	Sun, 26 Oct 2025 20:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="QSEl6rkR"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0976F25A2B4;
	Sun, 26 Oct 2025 20:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761510030; cv=none; b=FMHfzk0q3JLreMBjzwivP5NDVVm7uxYRdhpX8PcQZOXNrO8Pl7Q1au6BNSMDEejWDnIHdm+Kb0/jpsEk+SA8jCSM4872t1vVoIfl6Py48wk/EmNPJwWmUEnEaL+dtnYyalgKi+oFljqwGbytKbNu0vZbvVsh8w9hpgPW8H4rqcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761510030; c=relaxed/simple;
	bh=M+FipfWmfUw+8eAfstZu1IQqP0rFinDs7uUXxTQ+oxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7BXDd5HTyUUbnkxa6yvD0a3+vugQtE3YiJ48kIY95pziaBhUJlngFpnqsKLXI1MZSCy01D7NKiOMJtKA7T6URcuj5qkDYCsyPl91MMbhS65pDESQybBoEipLTXfI/FNXG4UKAET6rdynOhJUZWCrpi6XY78sMBQfqAqerVVQcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=QSEl6rkR; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59QKJBkK505258
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 26 Oct 2025 13:19:22 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59QKJBkK505258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1761509962;
	bh=U9afD4t6bdTgyB9pq+du2zmdhfY31ba5QYX4/+twSuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QSEl6rkRklSbI/veZEF/d4bqxP5C4ImhcrWdmPlhG11LOO+/U2QsaC9SPayJmINZ0
	 kjXiK9wTluwNa5NKgNSgZaFe8v3IoTsHYR9gOT3/GIqMB0d5tFFf+qCHJc6SGWncmF
	 /UD9kAve+WYlAhjFPkJPoI1cED1QtRVLkZlJNrzM0owFuOfNS1O8zjrfH8rv+vYPyh
	 8QsTWsd/9AisWa90O4te+7QKIQQj/XsZvRWEWD22s3Gh7EnLcbf53pCSJLQjd0IuJM
	 tzH41S/3qRS0GYJfpjYz8Wu5n9W7QrB9zaFdlw32hlMOw66wzL93kW+/ZPTTB8OjWH
	 TLy5g2rsWplVw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org, sohil.mehta@intel.com
Subject: [PATCH v9 03/22] KVM: VMX: Disable FRED if FRED consistency checks fail
Date: Sun, 26 Oct 2025 13:18:51 -0700
Message-ID: <20251026201911.505204-4-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026201911.505204-1-xin@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
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
index 6bd67c40ca3b..651507627ef3 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -405,6 +405,16 @@ static inline bool vmx_pebs_supported(void)
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
index be48ba2d70e1..fcfa99160018 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8020,6 +8020,9 @@ static __init void vmx_set_cpu_caps(void)
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


