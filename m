Return-Path: <kvm+bounces-54477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76137B21B0B
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 04:58:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24094682B7A
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 02:57:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAE952E54A1;
	Tue, 12 Aug 2025 02:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ehcsjtly"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8082E2F09;
	Tue, 12 Aug 2025 02:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754967392; cv=none; b=r/EGUSAZDgI9HJo+IR8KQ+VT5SJ1usfK6V//KO/nnknf4TyJHcM/OkrcJrL6GrA3mNdLKyIrXpQ9LMPjZ1OO7cRmMxlQgSE7CgE66PxMdGZ5fPmf0Ux55QvHVm2hcLmLEQqhrkFkSe4Dm8ANcf0eNZf90j3MdEC4ndkUPDBqiPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754967392; c=relaxed/simple;
	bh=qK4bs4dpKAzsNUcm95NUj00AyCZjbxXuuQ8IYy7JQMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRcTD21FrwF35e0oe/v2I8M6G2TprYhk+2zI3Innw5uRwfsZ63V8Ozhcxrlfor+uXmdQWa3pn/HgGJBX01g6R+X8Bb6Ty4T2IuYG2yE/sXQLop/r4yUIC7NxwQwq+ajSLvyNJKo865NeUXWSSfQhLMOCWslO4pIQOyZ3yZkoZ90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ehcsjtly; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754967390; x=1786503390;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qK4bs4dpKAzsNUcm95NUj00AyCZjbxXuuQ8IYy7JQMo=;
  b=Ehcsjtly2BSvNQVeX7UPdx23im7Qc8SRYVAgZHetCAqV1rjVMc2UwwbW
   B5rsk0DSGaCPC9woBvjU/fGO6sbE3/fo4E2l4WZr8t/Kl+DRMRyFksaxC
   g3+U0lQJMi4eSX3MLEMrsexOVxgs05ewSxkKxeAj0MhaYCd4FENCBzHDA
   abqMNvD8xuyhRga5tuDUOe6OM8HSI28RxCU+tZ44DDmbhRJIV35KTs/hk
   Gf0irl+z6Vv2GHqTt/JbHIDPLxWu0Bqf14iplhlbRrGIAGuQCKCcDl4u2
   4xCtB1e6a6bb4ApZlHpQWqWu/cgcTd6HscSqIFi/sE8xQ8ui2nrbTc07Y
   g==;
X-CSE-ConnectionGUID: QiD2tIKIQLm+Onfpl8AW4Q==
X-CSE-MsgGUID: urG3NIg4TCK1lLUcIJHBww==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57100471"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="57100471"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:26 -0700
X-CSE-ConnectionGUID: HQHkQSFLQaiGGWQCWe7EaQ==
X-CSE-MsgGUID: bo5uQO73RUerjI/VcxP1LA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="171321243"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:26 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: mlevitsk@redhat.com,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	xin@zytor.com,
	Chao Gao <chao.gao@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Mathias Krause <minipli@grsecurity.net>,
	John Allen <john.allen@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v12 05/24] KVM: x86: Zero XSTATE components on INIT by iterating over supported features
Date: Mon, 11 Aug 2025 19:55:13 -0700
Message-ID: <20250812025606.74625-6-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250812025606.74625-1-chao.gao@intel.com>
References: <20250812025606.74625-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Tweak the code a bit to facilitate resetting more xstate components in
the future, e.g., CET's xstate-managed MSRs.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/x86.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6cf0d15a7a64..0010aa45bf9f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12392,6 +12392,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 static void kvm_xstate_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct fpstate *fpstate = vcpu->arch.guest_fpu.fpstate;
+	u64 xfeatures_mask;
+	int i;
 
 	/*
 	 * Guest FPU state is zero allocated and so doesn't need to be manually
@@ -12405,16 +12407,20 @@ static void kvm_xstate_reset(struct kvm_vcpu *vcpu, bool init_event)
 	 * are unchanged.  Currently, the only components that are zeroed and
 	 * supported by KVM are MPX related.
 	 */
-	if (!kvm_mpx_supported())
+	xfeatures_mask = (kvm_caps.supported_xcr0 | kvm_caps.supported_xss) &
+			 (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
+	if (!xfeatures_mask)
 		return;
 
+	BUILD_BUG_ON(sizeof(xfeatures_mask) * BITS_PER_BYTE <= XFEATURE_MAX);
+
 	/*
 	 * All paths that lead to INIT are required to load the guest's FPU
 	 * state (because most paths are buried in KVM_RUN).
 	 */
 	kvm_put_guest_fpu(vcpu);
-	fpstate_clear_xstate_component(fpstate, XFEATURE_BNDREGS);
-	fpstate_clear_xstate_component(fpstate, XFEATURE_BNDCSR);
+	for_each_set_bit(i, (unsigned long *)&xfeatures_mask, XFEATURE_MAX)
+		fpstate_clear_xstate_component(fpstate, i);
 	kvm_load_guest_fpu(vcpu);
 }
 
-- 
2.47.1


