Return-Path: <kvm+bounces-14160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 41C028A02DF
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 00:09:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EBDF61F22C0B
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 22:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCE9F194C89;
	Wed, 10 Apr 2024 22:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i3NS07Vj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A4818412B;
	Wed, 10 Apr 2024 22:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712786879; cv=none; b=acZV3H+aYFeF+pjLJiBtH+jwaEwFH8ACUGBU42dI0Eqp5qk5Jev2hKNWlzZxvEPRhguiBx1isDjXuW9jlzbBjuSSZMOHHM8P3fU/cs1c5Hfn1C1woktKxfNVRyDGA9VVm+sfp2VTyO2PvZO4h5oWhdFhzlk65KICyAE7r++R+uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712786879; c=relaxed/simple;
	bh=XwXdHZ2iQsysNrw834gj2+zq3XuIiPhYcqjrgWnIrjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPHwlekr+dF6uxm5VBFa1D90Wr8dqUz5cD5J6QzhaBBXvkNFk8OazfCJ8QLaXD7gIVMaERBmjFqwi5kF9/ZymrcwLNELEPm9eNWBozAbpplGGYjqx+rrtrwLlFEhMHwoC4/otdKfsxgobOi9Wjg9fogTJNZ0pwKp0CI0fuKHuBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i3NS07Vj; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712786878; x=1744322878;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XwXdHZ2iQsysNrw834gj2+zq3XuIiPhYcqjrgWnIrjI=;
  b=i3NS07VjEoxH0C8ExL1Qh+Xr3nj4nY90v/TBAIrRC9Z9Y9fZSK9O965k
   AwQ/Iz8JJRAexRnFk0cJ1WLWiYAHCcsCzvafF83nNgW+nCWHivOKgvPxe
   GnnvvyF0rmfI8kvzw2dlbZvM0lslHMjbtHo4Y0ugz4/gddAf/LWPjlSV0
   QCK+YVJmTIc3knZ5+b8zzFCBcq44IexkOz88GRBpTgP/xw0V4zxyMG5bN
   WJqF6s4jVP1VRB6Op2oTL7cKYhNqny4INypaQrZCM08hQ3IhgYd+Woq1H
   bF4nKzhkdb4bZQrfHzUWKwwsAsM/CBPqFvwNrmZngZYmBQO0DvLia/BXF
   A==;
X-CSE-ConnectionGUID: ENINn3snQUCcPWGY21U4bQ==
X-CSE-MsgGUID: sRPjFllqSEuFq7f1xT4UGQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="8041124"
X-IronPort-AV: E=Sophos;i="6.07,191,1708416000"; 
   d="scan'208";a="8041124"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 15:07:55 -0700
X-CSE-ConnectionGUID: 4lTHY6vySlCEXFYBF7fIew==
X-CSE-MsgGUID: FS5nXk5XQveoz4d6MiHtqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,191,1708416000"; 
   d="scan'208";a="25476308"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 15:07:54 -0700
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	David Matlack <dmatlack@google.com>,
	Federico Parola <federico.parola@polito.it>,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2 04/10] KVM: x86/mmu: Make __kvm_mmu_do_page_fault() return mapped level
Date: Wed, 10 Apr 2024 15:07:30 -0700
Message-ID: <eabc3f3e5eb03b370cadf6e1901ea34d7a020adc.1712785629.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <cover.1712785629.git.isaku.yamahata@intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

The guest memory population logic will need to know what page size or level
(4K, 2M, ...) is mapped.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v2:
- Newly added.
---
 arch/x86/kvm/mmu/mmu_internal.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 9baae6c223ee..b0a10f5a40dd 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -288,7 +288,8 @@ static inline void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 }
 
 static inline int __kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-					  u64 err, bool prefetch, int *emulation_type)
+					  u64 err, bool prefetch,
+					  int *emulation_type, u8 *level)
 {
 	struct kvm_page_fault fault = {
 		.addr = cr2_or_gpa,
@@ -330,6 +331,8 @@ static inline int __kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gp
 
 	if (fault.write_fault_to_shadow_pgtable && emulation_type)
 		*emulation_type |= EMULTYPE_WRITE_PF_TO_SP;
+	if (level)
+		*level = fault.goal_level;
 
 	return r;
 }
@@ -347,7 +350,8 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	if (!prefetch)
 		vcpu->stat.pf_taken++;
 
-	r = __kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, err, prefetch, emulation_type);
+	r = __kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, err, prefetch,
+				    emulation_type, NULL);
 
 	/*
 	 * Similar to above, prefetch faults aren't truly spurious, and the
-- 
2.43.2


