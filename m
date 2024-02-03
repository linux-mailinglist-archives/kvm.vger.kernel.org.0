Return-Path: <kvm+bounces-7902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DEB68484A7
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:02:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C00A71C2739E
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:02:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C83DA5E228;
	Sat,  3 Feb 2024 09:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B/cUFpCn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B60E5D727;
	Sat,  3 Feb 2024 09:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706950831; cv=none; b=NcljuE+OQOS4RcWo1xnk02W6YTZk+wcx86QfLoWUTrKUCE/4vq7iJ0lFG1MQtRboBVygBT73e744gJFWrp8NvMSHPJEkEEYpEz9VzeYr4LyWQCBoF0yaS3vDDRZqKSgKGhIl5UflFqcbNhFlUo0a0Ct+B6TRJ8VHKb1X4JRmsA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706950831; c=relaxed/simple;
	bh=pRteXlHaQGDUTIvzskDwM7LxHqTRhHkoy/T6XfHmLLs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BJq5WDJ2FJLWFCKXgenuy19hwYvIBG0gNYMOeXIk98zXHN9Ybzvv5vsvw0iTuTbBQaee+mtUWyHQpe3o5E59F6efdCJaIXXX0LRZvAQF4ewsWwNwuYVT9d5PPVcJL3v765YphShAmisI/Gz2mQ2w2Hg8B0et7uUFAjf49GM4MAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B/cUFpCn; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706950830; x=1738486830;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pRteXlHaQGDUTIvzskDwM7LxHqTRhHkoy/T6XfHmLLs=;
  b=B/cUFpCnkTRZEcGGLynukYXICSWwqFWvZWiU1YOz+glp5dNgH6fYYa4E
   DQZReSydXutB2aYeQHRthyBWRU19HcKkXKZ7iDOO/j7QSy8A+ufebW+bl
   jHkU9EL+GAabqylmb8RYE5pnaV7JoeaiCADRXbDjS5mRs01iL7GEk1juh
   8CU43dWeksDTZSHUkaoL/+7v56omUS3WTvdsPpHu4iLUcn48uLfUJoauN
   aHH8eIh9KpdYOt+EgIBnrL5HI6Ha2ortn3GFkeYQYDD213ViiXeuhaiSo
   p+HxXBOGtTX6zwcz0QKg8LeCiXa8K+WaCUScfmCkYoW59Ksm0jwFhS3cv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="4131915"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="4131915"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 01:00:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="291248"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 03 Feb 2024 01:00:14 -0800
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
Subject: [RFC 06/26] KVM: VMX: Add helpers to handle the writes to MSR's R/O and R/WC0 bits
Date: Sat,  3 Feb 2024 17:11:54 +0800
Message-Id: <20240203091214.411862-7-zhao1.liu@linux.intel.com>
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

For WRMSR emulation, any write to R/O bit and any nonzero write to R/WC0
bit must be ignored.

Provide 2 helpers to emulate the above R/O and R/WC0 write behavior.

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e262bc2ba4e5..8f5981635fe5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2147,6 +2147,20 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
 	return debugctl;
 }
 
+/* Ignore writes to R/O bits. */
+static inline u64 vmx_set_msr_ro_bits(u64 new_val, u64 old_val, u64 ro_mask)
+{
+	return (new_val & ~ro_mask) | (old_val & ro_mask);
+}
+
+/* Ignore non-zero writes to R/WC0 bits. */
+static inline u64 vmx_set_msr_rwc0_bits(u64 new_val, u64 old_val, u64 rwc0_mask)
+{
+	u64 new_rwc0 = new_val & rwc0_mask, old_rwc0 = old_val & rwc0_mask;
+
+	return ((new_rwc0 | ~old_rwc0) & old_rwc0) | (new_val & ~rwc0_mask);
+}
+
 /*
  * Writes msr value into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
-- 
2.34.1


