Return-Path: <kvm+bounces-39998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 321ECA4D75E
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 10:06:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 149343AB02D
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 09:06:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7BEC1EA7CE;
	Tue,  4 Mar 2025 09:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W4U2CYQt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770061FDE23
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 09:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741078857; cv=none; b=BSeVeAsDXgaTUfdg+6ywfum7tuA+1WPZc0lKytTEKgTVR5kAP5F0TJfMwq3NokrvjHc6icMYP4dOfPMPT8a+y9iCJKa+IGaU+/5fAeELYuJYgRSnbxoaUHlE7wBK3P7VYi4Qe0c1vfQWhT8glPuhEE/UYPrtI+HWR5HltWyUxfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741078857; c=relaxed/simple;
	bh=8FbyxieIiEwHhdkvr2MabCyfafRtn3Lu2vIdaeWoJYQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A1F1b9KIIHuamMKhEy+o6zL2099Zi5KqY17JJGw0woK9zl09+s7X+Dt1Az+SMxQcNPy79HTH+2oKqi6cV0AFmYkQwOvmUKVVBVZ5VwVj0PHyjQbsnswQQypaHyiwTTQVQ9JrN5MNtKdVz9SC8J7YYjsNNgpDTxWrPUW35MnBJks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W4U2CYQt; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741078855; x=1772614855;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8FbyxieIiEwHhdkvr2MabCyfafRtn3Lu2vIdaeWoJYQ=;
  b=W4U2CYQtqWhwx77m9WjCEsCOWCHIVzgOR1/SqSqO4YEAjX4zhF9sLopD
   hWFTgRJG3Nu2P9llzkn000fIMJXOKRAN92EmmDA0tnaW6aOrYFiojerTb
   4Gy0w1CRj8uySdtE9yLO8b9i4o4e5O+TRZh0nf44pD9I7zwxsIep1Kwie
   XWQBw2y7kwdBn7oLdUKSs/c0haMlvA6CxJ4AVlHxS68h4H7qaZUdXjxc8
   NpwwA5fH28TdVLFv7GyzdvfU+SbH8k4JbRQCcftvvtaWTpBhVYT9q0a4M
   oOYhZXhFoTsFdGfZDLTHLsYh5WtCvGGh8EZmowML/l7W3eZ9Y1SZVWCTs
   Q==;
X-CSE-ConnectionGUID: h89K9XejRYW+ckz+zhxDfQ==
X-CSE-MsgGUID: qTUFJIosRomfdhJ/xjDYkQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="52631334"
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="52631334"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 01:00:54 -0800
X-CSE-ConnectionGUID: 22bLQVchRMaAdUBwrXMpwQ==
X-CSE-MsgGUID: 8nkBHhH8TseOg1YMZfCkmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="118999225"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Mar 2025 01:00:52 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 1/2] KVM: x86: Remove the unreachable case for 0x80000022 leaf in __do_cpuid_func()
Date: Tue,  4 Mar 2025 03:23:13 -0500
Message-Id: <20250304082314.472202-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250304082314.472202-1-xiaoyao.li@intel.com>
References: <20250304082314.472202-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_cpu_cap_has(X86_FEATURE_PERFMON_V2) must be true when it reaches
to setup value for EBX. Remove the unreachable code.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/cpuid.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0779437edd23..f9a9175e3fe8 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1773,13 +1773,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 
 		cpuid_entry_override(entry, CPUID_8000_0022_EAX);
 
-		if (kvm_cpu_cap_has(X86_FEATURE_PERFMON_V2))
-			ebx.split.num_core_pmc = kvm_pmu_cap.num_counters_gp;
-		else if (kvm_cpu_cap_has(X86_FEATURE_PERFCTR_CORE))
-			ebx.split.num_core_pmc = AMD64_NUM_COUNTERS_CORE;
-		else
-			ebx.split.num_core_pmc = AMD64_NUM_COUNTERS;
-
+		ebx.split.num_core_pmc = kvm_pmu_cap.num_counters_gp;
 		entry->ebx = ebx.full;
 		break;
 	}
-- 
2.34.1


