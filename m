Return-Path: <kvm+bounces-7908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C84A8484B9
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:04:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE4451C27F0A
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C3835FDA1;
	Sat,  3 Feb 2024 09:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B+ztlGDJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357335FB83;
	Sat,  3 Feb 2024 09:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706950856; cv=none; b=E5qUu5ni4G3RBNbBQNLusJLzWgdv1SI8vhkC+uT129HzTqROm0zJ1k4mA32SF/rz2orD4X9NSooPUYogMTdaa8FoZBOChKFSljHFq3s7eRDKYmtcivm5Ei6ZaeGPekeImV5RGgs50DvFfKaRs1MFjqX7ZRCpq0Vs9Em8wEEPhAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706950856; c=relaxed/simple;
	bh=xuhB6ti18yKxtjfmmEA4k56Sy3StXgqJYsS1nszVK90=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Bv7JYMiajwWvSaIpgaQpW8L05Ki6ac1Ee8q7LtitG6ElffeCjBvFvpmjGfNrc3vMXiGjiVkEBqHYHVlFoXPOK1Mr7/uZ58szU29Nu1/SqfzPbNAvm9UaN/ntdLl7QNNzyxH6lZ5bG16XCvj2NNQY7JXOpE/UGH9QLd3X0QDmMSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B+ztlGDJ; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706950855; x=1738486855;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xuhB6ti18yKxtjfmmEA4k56Sy3StXgqJYsS1nszVK90=;
  b=B+ztlGDJ3I4kpBbMIE3LTOQlXmNBXXW+uM9Q/mrh0x8LOSPgJMA1L8WI
   H4mdRYiQmV3QOqg+IuNz2Ox/QCwXXm9uNagv72T1qWK43stAKQftg+w7l
   +/VItCHcPr52eJ8uS6LOQx5xgzkbmqQDRncfJThMIuyb8RW438+HpZj1d
   qNW4+TrTpSvBwUFaXxLd4Ph9/nc70cdUqz4GoMGvzzRpTPZvb1EXgJRkL
   XUKeaPgZcKdwTtgK6NLYyjRcRVOH02ohXHUWVXEuBeFI8vkaV1x9ahOIW
   5Nwm2HRbk5NTN8ufq+eyLcb6c/bMQgcgCirVsV6UeXc6Q2DILjVuy+q55
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="4132013"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="4132013"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 01:00:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="291369"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 03 Feb 2024 01:00:49 -0800
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
Subject: [RFC 12/26] KVM: VMX: Introduce HFI table index for vCPU
Date: Sat,  3 Feb 2024 17:12:00 +0800
Message-Id: <20240203091214.411862-13-zhao1.liu@linux.intel.com>
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

The HFI table contains a table header and many table entries. Each table
entry is identified by an HFI table index, and each CPU corresponds to
one of the HFI table indexes [1].

Add hfi_table_idx in vcpu_vmx, and this will be used to build virtual
HFI table.

This HFI index is initialized to 0, but in the following patch the VMM
can be allowed to configure this index with a custom value (CPUID.0x06.
edx[bits 16-31]).

[1]: SDM, vol. 3B, section 15.6.1 Hardware Feedback Interface Table
     Structure

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 ++++++
 arch/x86/kvm/vmx/vmx.h | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 48f304683d6f..96f0f768939d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7648,6 +7648,12 @@ static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 			tsx_ctrl->mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
 	}
 
+	/*
+	 * hfi_table_idx is initialized to 0, but later it may be changed according
+	 * to the value in the Guest's CPUID.0x06.edx[bits 16-31].
+	 */
+	vmx->hfi_table_idx = 0;
+
 	err = alloc_loaded_vmcs(&vmx->vmcs01);
 	if (err < 0)
 		goto free_pml;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 4bf4ca6ac1c0..63874aad7ae3 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -362,6 +362,9 @@ struct vcpu_vmx {
 	struct pt_desc pt_desc;
 	struct lbr_desc lbr_desc;
 
+	/* Should be extracted from Guest's CPUID.0x06.edx[bits 16-31]. */
+	int hfi_table_idx;
+
 	/* Save desired MSR intercept (read: pass-through) state */
 #define MAX_POSSIBLE_PASSTHROUGH_MSRS	16
 	struct {
-- 
2.34.1


