Return-Path: <kvm+bounces-4998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD9E281B1DC
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:15:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 843F9281D20
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 09:15:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16B1A56449;
	Thu, 21 Dec 2023 09:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mdpi7fLE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B465554673;
	Thu, 21 Dec 2023 09:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703149431; x=1734685431;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=deVC/2fUZfj8WeG3WjFFJ61TeWJaKY/1dV/6Kp3bPHY=;
  b=Mdpi7fLE4f7HTd8VD75HWp6Ft81hpUdOAVJhHceMFD9X/02iPJTh2Lp+
   zQ23K9fb9VP0BrK1DuvH4ugpxLwu8YuRywjOgm+ul5HHfgwG5mk7eDick
   vdhZnCjjWMVorQSkn4PZdMRGdMkX5KOozNBlyi2jWu/g5ld+czilWnOjF
   Zq0g+EpOG93d8JIuNCKZODWr6U2n+8F3S6XMos98Qxl64jSgZRFt776D9
   NzH8FT/MR5qLwoF+QTqsvqaD8+92PTkv6mHj5zr51mrgIes68xCHCJmbU
   IjbijG4+KjOVf5yUChieiXJXIKO1VuhucahATIPMSErj3JQghU4ngiNvH
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="398729662"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="398729662"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 01:03:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="900028593"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="900028593"
Received: from 984fee00a5ca.jf.intel.com (HELO embargo.jf.intel.com) ([10.165.9.183])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 01:03:10 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v8 11/26] KVM: x86: Add kvm_msr_{read,write}() helpers
Date: Thu, 21 Dec 2023 09:02:24 -0500
Message-Id: <20231221140239.4349-12-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20231221140239.4349-1-weijiang.yang@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Wrap __kvm_{get,set}_msr() into two new helpers for KVM usage and use the
helpers to replace existing usage of the raw functions.
kvm_msr_{read,write}() are KVM-internal helpers, i.e. used when KVM needs
to get/set a MSR value for emulating CPU behavior, i.e., host_initiated ==
%true in the helpers.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/cpuid.c            |  2 +-
 arch/x86/kvm/x86.c              | 16 +++++++++++++---
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5c665165024c..40dd796ea085 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2012,9 +2012,10 @@ void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu);
 
 void kvm_enable_efer_bits(u64);
 bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
-int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data, bool host_initiated);
 int kvm_emulate_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data);
 int kvm_emulate_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data);
+int kvm_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data);
+int kvm_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data);
 int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu);
 int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu);
 int kvm_emulate_as_nop(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 624954203b40..acc360c76318 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1548,7 +1548,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 		*edx = entry->edx;
 		if (function == 7 && index == 0) {
 			u64 data;
-		        if (!__kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data, true) &&
+		        if (!kvm_msr_read(vcpu, MSR_IA32_TSX_CTRL, &data) &&
 			    (data & TSX_CTRL_CPUID_CLEAR))
 				*ebx &= ~(F(RTM) | F(HLE));
 		} else if (function == 0x80000007) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3671f4868d1b..594c9e025f95 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1920,8 +1920,8 @@ static int kvm_set_msr_ignored_check(struct kvm_vcpu *vcpu,
  * Returns 0 on success, non-0 otherwise.
  * Assumes vcpu_load() was already called.
  */
-int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
-		  bool host_initiated)
+static int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
+			 bool host_initiated)
 {
 	struct msr_data msr;
 	int ret;
@@ -1947,6 +1947,16 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 	return ret;
 }
 
+int kvm_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data)
+{
+	return __kvm_set_msr(vcpu, index, data, true);
+}
+
+int kvm_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data)
+{
+	return __kvm_get_msr(vcpu, index, data, true);
+}
+
 static int kvm_get_msr_ignored_check(struct kvm_vcpu *vcpu,
 				     u32 index, u64 *data, bool host_initiated)
 {
@@ -12296,7 +12306,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 						  MSR_IA32_MISC_ENABLE_BTS_UNAVAIL;
 
 		__kvm_set_xcr(vcpu, 0, XFEATURE_MASK_FP);
-		__kvm_set_msr(vcpu, MSR_IA32_XSS, 0, true);
+		kvm_msr_write(vcpu, MSR_IA32_XSS, 0);
 	}
 
 	/* All GPRs except RDX (handled below) are zeroed on RESET/INIT. */
-- 
2.39.3


