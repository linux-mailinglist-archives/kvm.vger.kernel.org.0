Return-Path: <kvm+bounces-52816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 56AC8B098E3
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 02:20:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18EBA1C45FC9
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 00:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49FF414F9D6;
	Fri, 18 Jul 2025 00:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j/cEXA/l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797CB135A53;
	Fri, 18 Jul 2025 00:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752798002; cv=none; b=g45qH2SRLFt5dMwEsawd0syQn7zjrqzuu0+iNbW6GKC6yAY3IG+few4thopC/ceuxj9GitbF49InVx5wjI16/Jb+25Ia493/pMG3V43FQn6vGC608RIfwrNjWfKQesbp3t6h6Be/rLUsCJAE652PhwJ/hEHA9+lHr9dBTdu9kpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752798002; c=relaxed/simple;
	bh=ffN9G6aPNV4OgsnURkRXHTjZEHzeVj6CrNHovHf83Gg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XQPELjL8+SZjVnOxUsFYuLwN9Xo1sU6Sq+kFRkqsKB8bijFJOYfuID1nbbwdWaHsLFPLIb2ALmUdkLbDlqojI4vtNUngJPuel2fsbYlEbyQSAHH6IH/095xhINCNwEkR8t42VJ3koqSCd/A+PaxX70rfBI2KEHPiF0YKw1/J8BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j/cEXA/l; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752798001; x=1784334001;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ffN9G6aPNV4OgsnURkRXHTjZEHzeVj6CrNHovHf83Gg=;
  b=j/cEXA/liEdVgejzNe2ZHg1fFAeXCKHEGrP/D9nF3j4vKYKFdzjzInu0
   +onCss8jIUhQb8u8onzkUtVQoEjKlxOiUApK5z4xua32eJSi8dfwvjSlh
   f8hS5yLOT2AQZpvaszZCXBivwXZcHOnOz7gDGBA3V3RGlCuIJSaC61M1T
   DnJF/5CYv/wuXtphrVWXOH2NQj+BuDe22PmjHJ02X7SGhoCI9ejsI+Uz2
   Zn88HS/jkGsaUVfD0NDWt73dz88kxjZXErHkBTkJQ1+62wQNmM+SF4q6D
   RCjEPJI/pW6UwTDTeFvZ0H/93a+t4kLVysBTYlLpYC8/nxFXi12ddkEQ4
   A==;
X-CSE-ConnectionGUID: 4DMOX9K/Rh2nS2QNX83liQ==
X-CSE-MsgGUID: aY5055F1QCK9OQrQVY0fiw==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="65780103"
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="65780103"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 17:20:01 -0700
X-CSE-ConnectionGUID: W2EAW3SeR/aJVoOuuc/MHA==
X-CSE-MsgGUID: CkfzDOGtS4y93gdi58nvHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="157322809"
Received: from spr.sh.intel.com ([10.112.229.196])
  by orviesa010.jf.intel.com with ESMTP; 17 Jul 2025 17:19:57 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Zide Chen <zide.chen@intel.com>,
	Das Sandipan <Sandipan.Das@amd.com>,
	Shukla Manali <Manali.Shukla@amd.com>,
	Yi Lai <yi1.lai@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH v2 2/5] KVM: selftests: Add timing_info bit support in vmx_pmu_caps_test
Date: Fri, 18 Jul 2025 08:19:02 +0800
Message-Id: <20250718001905.196989-3-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250718001905.196989-1-dapeng1.mi@linux.intel.com>
References: <20250718001905.196989-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A new bit PERF_CAPABILITIES[17] called "PEBS_TIMING_INFO" bit is added
to indicated if PEBS supports to record timing information in a new
"Retried Latency" field.

Since KVM requires user can only set host consistent PEBS capabilities,
otherwise the PERF_CAPABILITIES setting would fail, so add
pebs_timing_info bit into "immutable_caps" to block host inconsistent
PEBS configuration and cause errors.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
 tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c
index a1f5ff45d518..f8deea220156 100644
--- a/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c
@@ -29,7 +29,7 @@ static union perf_capabilities {
 		u64 pebs_baseline:1;
 		u64	perf_metrics:1;
 		u64	pebs_output_pt_available:1;
-		u64	anythread_deprecated:1;
+		u64	pebs_timing_info:1;
 	};
 	u64	capabilities;
 } host_cap;
@@ -44,6 +44,7 @@ static const union perf_capabilities immutable_caps = {
 	.pebs_arch_reg = 1,
 	.pebs_format = -1,
 	.pebs_baseline = 1,
+	.pebs_timing_info = 1,
 };
 
 static const union perf_capabilities format_caps = {
-- 
2.34.1


