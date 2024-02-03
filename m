Return-Path: <kvm+bounces-7913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12DFA8484CA
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:06:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 459C11C28DCA
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:06:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45C1F60ED6;
	Sat,  3 Feb 2024 09:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AWRm4P9l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9C45D489;
	Sat,  3 Feb 2024 09:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706950886; cv=none; b=hqfQireyjwqG8rMVmn70vqkSPtYmPr6+y95c9cC4zpNyPlqkPI8pteJ5dtfA1y3eqc1aOY3a8jWcabAKRwsT6Sd1zU/puyTFivwdAQWiflqF3eTyYw7uDHxnbN/1kBKtzRvbk5594gUDcCJCrb6B7lhh6tCUtq6eOOG9bdubNtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706950886; c=relaxed/simple;
	bh=SMoF3nIPJhY2CvvIts5nS/Mk2TwIlNjiRdux5w3q9k8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L7e0QZd/iimOaJ4hsH9HHb+Kw7D9wWlFTsHEcEbf7RmGAreprzaUFaInu8pGbog5L844+lHDd+uSHwSEK1ouAifXE7iOs4KsGTOc/ixm5fjMkK77ZsU1bIy0k/DOUR18r4aCT92d42zF9BqNyjJu6QfQBEDlHQ3p/pjoIfq5xGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AWRm4P9l; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706950885; x=1738486885;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SMoF3nIPJhY2CvvIts5nS/Mk2TwIlNjiRdux5w3q9k8=;
  b=AWRm4P9lOt9jckK0W6gew+9NvQoJCEKUaNX1QZvA+GPVwjjGfwPc3xeF
   Bmuq7/zV05gFQQJ8S0ZoER1p0C77FBuQ+7LWgh1gMgXFvaMh/qHKgdm8o
   NE2qS4A/HESDHIQPVfXSmIBjkFqKpf4oNTT+Y5p6xjSo0r/zrGtvW9zZJ
   ej0ueyTlte1W+ROoNk27EhYW6uKxwNZVKSExFSl1mdpCADYgNOcHa7V/W
   lTdCaUknK8FuwX+djLi0oBdZzjcUfpZDfwEiLZCadmHntxdmzZ6HagHp0
   Rlpny6jWxckhzUdAr19vGRC3++m4Xb0q2lskJ1P+ZCl+CQWqBL15D31bC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="4132070"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="4132070"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 01:01:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="291478"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 03 Feb 2024 01:01:17 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Yanting Jiang <yanting.jiang@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Vineeth Pillai <vineeth@bitbyteword.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@google.com>,
	David Dai <davidai@google.com>,
	Saravana Kannan <saravanak@google.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 17/26] KVM: VMX: Allow to inject thermal interrupt without HFI update
Date: Sat,  3 Feb 2024 17:12:05 +0800
Message-Id: <20240203091214.411862-18-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240203091214.411862-1-zhao1.liu@linux.intel.com>
References: <20240203091214.411862-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

When the HFI table memory address is set by MSR_IA32_HW_FEEDBACK_PTR or
when MSR_IA32_HW_FEEDBACK_CONFIG enables the HFI feature, the hardware
sends an initial HFI notification via thermal interrupt and sets the
thermal status bit.

To prepare for the above cases, extend vmx_update_hfi_table() to allow
the forced thermal interrupt injection (with the thermal status bit set)
regardless of whether there is the HFI table change to be updated.

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44c09c995120..97bb7b304213 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1616,7 +1616,7 @@ static int vmx_build_hfi_table(struct kvm *kvm)
 	return 1;
 }
 
-static void vmx_update_hfi_table(struct kvm *kvm)
+static void vmx_update_hfi_table(struct kvm *kvm, bool forced_int)
 {
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
 	struct hfi_desc *kvm_vmx_hfi = &kvm_vmx->pkg_therm.hfi_desc;
@@ -1635,7 +1635,7 @@ static void vmx_update_hfi_table(struct kvm *kvm)
 	}
 
 	ret = vmx_build_hfi_table(kvm);
-	if (ret <= 0)
+	if (ret < 0 || (!ret && !forced_int))
 		return;
 
 	kvm_vmx_hfi->hfi_update_status = true;
@@ -1731,7 +1731,7 @@ static void vmx_dynamic_update_hfi_table(struct kvm_vcpu *vcpu)
 	 * of the same VM are sharing the one HFI table. Therefore, one
 	 * vCPU can update the HFI table for the whole VM.
 	 */
-	vmx_update_hfi_table(vcpu->kvm);
+	vmx_update_hfi_table(vcpu->kvm, false);
 	mutex_unlock(&kvm_vmx->pkg_therm.pkg_therm_lock);
 }
 
-- 
2.34.1


