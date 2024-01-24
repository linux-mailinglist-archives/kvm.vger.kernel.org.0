Return-Path: <kvm+bounces-6763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CA0F839F71
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 03:47:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2FCBAB296B3
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 02:47:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 853CE182D4;
	Wed, 24 Jan 2024 02:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XRchG6Oe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B3A1775A;
	Wed, 24 Jan 2024 02:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706064164; cv=none; b=HlYrl/tfHcJf5MEO/yWIUoQjzvcJBGaScDplS27kIdxJcOtLGEO6haXL7gSsDWEaEKjou79MPrW7kswUYoim9fYOiGe2j5TbBeKNFBKDmHImc/ExquROEx6VsJu5HYKpfLj3Z/VlpE0pr5KJJs/CHDU/F4DVg5n52zdvJmJTHyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706064164; c=relaxed/simple;
	bh=0UE5IUCUA6slej5/EM6zfvBhsHMVYZs9Yfo7sj2LfOU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kPr4wQ+NSPNbk4GBuGfYmKCQSS6l0R9RuFujCBYdUw1O1L4GxtJrQ+GIHpHhLO4lL+JC+tPSIKwOttuPCW0Tahi9odavG6i8VE1fZt8+O4zo+VdBn6qB5joIBpn587NNkgHcQ/KsOO9PreBeULAJYLxfyDE0U21mVPFU5BIzpNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XRchG6Oe; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706064162; x=1737600162;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0UE5IUCUA6slej5/EM6zfvBhsHMVYZs9Yfo7sj2LfOU=;
  b=XRchG6OeN4qO7/YgppHEaV6KSn10R7WErRL81IN6tTF3RDJ0crXWGG3e
   O2ysLyzIBA94qrq28Tu4qczlwor6YnOT6wpMWJ1EjdwOZuW/4UT8m4NyM
   Zoc9vqmHdLko97K/bsD0BPq137kwp5viCs0xREyOX76ABGpzhVdG3Ip3S
   4bM6FCinbB8jwvcpBRMzrQebq4Otg9q+kwNMzElflVddnuJ7naGGHTnHt
   eC9HiRrRzF/JEazvqHLaTy47ay5Wi/KmUe+972AKXpaGf86u7YT3uheIQ
   H/XiQ8EN3cyT/CcCsp5XrtLDtsop/g8QLZjY/ISnZ82H7OPGTEozLk+4U
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="400586513"
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="400586513"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="1825873"
Received: from 984fee00a5ca.jf.intel.com ([10.165.9.183])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:38 -0800
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
Subject: [PATCH v9 14/27] KVM: x86: Initialize kvm_caps.supported_xss
Date: Tue, 23 Jan 2024 18:41:47 -0800
Message-Id: <20240124024200.102792-15-weijiang.yang@intel.com>
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

Set original kvm_caps.supported_xss to (host_xss & KVM_SUPPORTED_XSS) if
XSAVES is supported. host_xss contains the host supported xstate feature
bits for thread FPU context switch, KVM_SUPPORTED_XSS includes all KVM
enabled XSS feature bits, the resulting value represents the supervisor
xstates that are available to guest and are backed by host FPU framework
for swapping {guest,host} XSAVE-managed registers/MSRs.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7b7a15aab3aa..f50c5a523b92 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -226,6 +226,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
 
+#define KVM_SUPPORTED_XSS     0
+
 u64 __read_mostly host_efer;
 EXPORT_SYMBOL_GPL(host_efer);
 
@@ -9715,12 +9717,13 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		host_xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 		kvm_caps.supported_xcr0 = host_xcr0 & KVM_SUPPORTED_XCR0;
 	}
+	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
+		rdmsrl(MSR_IA32_XSS, host_xss);
+		kvm_caps.supported_xss = host_xss & KVM_SUPPORTED_XSS;
+	}
 
 	rdmsrl_safe(MSR_EFER, &host_efer);
 
-	if (boot_cpu_has(X86_FEATURE_XSAVES))
-		rdmsrl(MSR_IA32_XSS, host_xss);
-
 	kvm_init_pmu_capability(ops->pmu_ops);
 
 	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
-- 
2.39.3


