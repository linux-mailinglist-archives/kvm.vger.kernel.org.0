Return-Path: <kvm+bounces-6761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CA44E839F6D
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 03:46:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C852B266A5
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 02:46:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ADF517BA8;
	Wed, 24 Jan 2024 02:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hbARKvv8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562F117541;
	Wed, 24 Jan 2024 02:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706064162; cv=none; b=jraaZdaxLTk7uqXxSSRZiL8Xi+GAP1r69mopqKEIClXI1UGiwJ+4ot/42iLzsSQbLA02f6d0CydoTvywmIWimeitaQ5dgx5h5+XMnmGeN72OsOpX/3PEdCXzjKl/hz/q81KpNlbBtk04p7jzDULvH6o99hYiw2vm1kgi3/4eGkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706064162; c=relaxed/simple;
	bh=deVC/2fUZfj8WeG3WjFFJ61TeWJaKY/1dV/6Kp3bPHY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pS69gigGbe53+CbCaZ9kGxV7J+/733Bd6Zv8nRPl25+n5z1od9vGSGSSf7WqleBFcVGxs1UJvdO1/oplqmH+cnW5WR45JYflkqrRD9iTUdnp8u5qE/km/O7/vdpTFej+xpVq1eonC8Qp+nelooLIn9ilDVyLgkl0F76zg1EpTSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hbARKvv8; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706064160; x=1737600160;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=deVC/2fUZfj8WeG3WjFFJ61TeWJaKY/1dV/6Kp3bPHY=;
  b=hbARKvv83UznF+VpyRQI3xoqkpb8fAV5VlVb1g7L1hgRsRDSoLNZGZb5
   OpJNPUOIDx21TmWoRFe4i21UO41h7QhiI5tzIA0J30capf2vhAX5J1Al5
   7fH735ACQVOGVjKXOmvunagP9s8f12ATQ/KnOj56Va4LYF7DgYw/MeOqo
   VZpqQ7yGUuRAdh0YXQYNlbHVr/YlLGXiKDjBZ1X//3p/WxY66wQUvHHuV
   2Sr9L4zuaS1uH3uhwyJOTIiTvw953QFmlUOhX98GJv2I4JiDnWbO1gSXO
   mRQ2gdDFnIk+NxftlPKTiU0lMMOuk1/avHhawqry84S7ONPuzQteMO4QD
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="400586484"
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="400586484"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="1825858"
Received: from 984fee00a5ca.jf.intel.com ([10.165.9.183])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:36 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	yuan.yao@linux.intel.com
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v9 11/27] KVM: x86: Add kvm_msr_{read,write}() helpers
Date: Tue, 23 Jan 2024 18:41:44 -0800
Message-Id: <20240124024200.102792-12-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240124024200.102792-1-weijiang.yang@intel.com>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
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


