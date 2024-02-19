Return-Path: <kvm+bounces-9026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8BF5859D8C
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 08:54:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAEDF1C21C91
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 07:54:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 392C536B1C;
	Mon, 19 Feb 2024 07:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hPXf6oYZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AC52E631;
	Mon, 19 Feb 2024 07:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708328874; cv=none; b=TgZ4jxezj7MoTXOI0Waib3vkmkpHSF+9aA1+6hJsruhqAVXLE/+iO43eKMRB6oTg5jbDvPCLEN3UPU1U6GZ2WEeeqPK8Le/Jgn71mOITYtOFYvsMZHVkQaSVLoMtT/9rcKxN469k20313CPrNV/YI/qoJ9SFEYj3/2GORYxYjuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708328874; c=relaxed/simple;
	bh=FWbGGdaxtUvQxwfS23YYfiUKdvCt6zHtKkYDzi8ptYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hx5LAu6nISnORmq/5KBZ9jKxzBq/eAK6JtsOWAUm/kegmQCoUJvkn2bQviRTtxRIwdP4Pufk2Mm9jKJQPBUSbnSpJbIn+FU1k994yXZzk0Y3exFYCDxYVTXLEg6EbdxJshz2Mn6/WWIAkc9JrlIdrBApfZ4mJseqOnPjJBKkgm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hPXf6oYZ; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708328872; x=1739864872;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FWbGGdaxtUvQxwfS23YYfiUKdvCt6zHtKkYDzi8ptYg=;
  b=hPXf6oYZhrDP83/kM81EO1tumnevzbUDkNzC7KTpu3LuU/IBqEUanfTD
   6zgoCZpHgc1prR1NcFn6N4yqrTYOh/LFpE2Tic7HvgblwgT3gbGGywxXL
   KIfyiMtEm88Q2bERA5pHlamltig4KTMMy9WWgoORwfITXK6l7Ne08vNnC
   hsjmCyMw46CnqD3MQQvYJDwzrHheBNfi+lGLjR9LY28bPasTS3MFEAj6t
   0xPjaVNbqxG3zuyqkjslAamstf5UF1zASIL72NNBgsV50fCWoCdxpPKol
   j3OXi7fVz1uhe6hAOYvbZuLxGzfjc+u4TcSkxH/G1wi+oRggIaSpv/KRS
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="2535078"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="2535078"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="826966090"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="826966090"
Received: from jf.jf.intel.com (HELO jf.intel.com) ([10.165.9.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:43 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v10 11/27] KVM: x86: Add kvm_msr_{read,write}() helpers
Date: Sun, 18 Feb 2024 23:47:17 -0800
Message-ID: <20240219074733.122080-12-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219074733.122080-1-weijiang.yang@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
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
index 5ab122f8843e..f95e93975242 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2015,9 +2015,10 @@ void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu);
 
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
index d57a6255b19f..39529e14ae59 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1548,7 +1548,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 		*edx = entry->edx;
 		if (function == 7 && index == 0) {
 			u64 data;
-		        if (!__kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data, true) &&
+			if (!kvm_msr_read(vcpu, MSR_IA32_TSX_CTRL, &data) &&
 			    (data & TSX_CTRL_CPUID_CLEAR))
 				*ebx &= ~(F(RTM) | F(HLE));
 		} else if (function == 0x80000007) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5a9c07751c0e..cbd44f904ba8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1919,8 +1919,8 @@ static int kvm_set_msr_ignored_check(struct kvm_vcpu *vcpu,
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
@@ -1946,6 +1946,16 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
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
@@ -12323,7 +12333,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 						  MSR_IA32_MISC_ENABLE_BTS_UNAVAIL;
 
 		__kvm_set_xcr(vcpu, 0, XFEATURE_MASK_FP);
-		__kvm_set_msr(vcpu, MSR_IA32_XSS, 0, true);
+		kvm_msr_write(vcpu, MSR_IA32_XSS, 0);
 	}
 
 	/* All GPRs except RDX (handled below) are zeroed on RESET/INIT. */
-- 
2.43.0


