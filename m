Return-Path: <kvm+bounces-10665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E93086E749
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 18:32:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DA9E28A751
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 17:32:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2DB53B19D;
	Fri,  1 Mar 2024 17:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ioruVSok"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620AA36135;
	Fri,  1 Mar 2024 17:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709314190; cv=none; b=uU7PUEr/xDMjrZ6v2a8aiyqZPQ0e+pa0+tdVQug6IfUio+kXEvKWLCd1OkhTdKhcstl4znL90peCKH0D4Edirs2hVIKtjL+SJRd+bEayJw+5B7GgetmovN/ZGjhaLIsVeLh4AZvUt8hGvvIczTJIMdZ6mu4ritGSj1G1BSJGM2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709314190; c=relaxed/simple;
	bh=4JuI8MhcUjFoTdzx1jxF5qxObLAyf716TjE4SfN0UR8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AbOhvBnyyPJZePSxMERcA6su7p8w8Y7c4N4e6m1wQi9xUaraBtBM1FCgsSUFleeRQCaqzt4T6PM7Al0D+u5wut5k4Fg8BlErFBXhzMlim9IRkMa+BE6VbX6nz0tALNxR886fcp0dS50OMYZ8parK4RthABMDNuLNqDQpWG9rZ5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ioruVSok; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709314188; x=1740850188;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4JuI8MhcUjFoTdzx1jxF5qxObLAyf716TjE4SfN0UR8=;
  b=ioruVSokUA/DfuEdEp7rqk2zzcCrLJrdammXNqJckrsGfccHDsVUZG3d
   2B6B+ABUu/q+vOyN6I/ENlPDG1JwupVYxcLbnjw2o2lLqs3feyk/A2/ru
   QC7mcsPGU4TavA/Uia5FpjoAXptadSI+2iIao34rsBA6mrUlp5HQ9tXP+
   EnOnAXd6ox3ybHqGeOwo+FP0UZrLBpkuvqI6tRMdFNYkfEhBV7f1Af3hF
   I/DS3/lDr3uK7e3ACp2DzmBFBb1xy4ETYQWmh3akx6EENT+O3ZsYLYpo5
   Mjgl1khkj/2rnXDxqaOwMCHMW9cZmQCGEy3TvfEfEKPRpr4yLKc5bFNVa
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11000"; a="6812433"
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="6812433"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 09:29:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="12946571"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 09:29:26 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	David Matlack <dmatlack@google.com>,
	Federico Parola <federico.parola@polito.it>
Subject: [RFC PATCH 6/8] KVM: x86: Implement kvm_arch_{, pre_}vcpu_map_memory()
Date: Fri,  1 Mar 2024 09:28:48 -0800
Message-Id: <66a957f4ec4a8591d2ff2550686e361ec648b308.1709288671.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1709288671.git.isaku.yamahata@intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Wire KVM_MAP_MEMORY ioctl to kvm_mmu_map_tdp_page() to populate guest
memory.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3b8cb69b04fa..6025c0e12d89 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4660,6 +4660,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_MEMORY_FAULT_INFO:
+	case KVM_CAP_MAP_MEMORY:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
@@ -5805,6 +5806,54 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 	}
 }
 
+int kvm_arch_vcpu_pre_map_memory(struct kvm_vcpu *vcpu)
+{
+	return kvm_mmu_reload(vcpu);
+}
+
+int kvm_arch_vcpu_map_memory(struct kvm_vcpu *vcpu,
+			     struct kvm_memory_mapping *mapping)
+{
+	u8 max_level, goal_level = PG_LEVEL_4K;
+	u32 error_code;
+	int r;
+
+	error_code = 0;
+	if (mapping->flags & KVM_MEMORY_MAPPING_FLAG_WRITE)
+		error_code |= PFERR_WRITE_MASK;
+	if (mapping->flags & KVM_MEMORY_MAPPING_FLAG_EXEC)
+		error_code |= PFERR_FETCH_MASK;
+	if (mapping->flags & KVM_MEMORY_MAPPING_FLAG_USER)
+		error_code |= PFERR_USER_MASK;
+	if (mapping->flags & KVM_MEMORY_MAPPING_FLAG_PRIVATE) {
+#ifdef PFERR_PRIVATE_ACCESS
+		error_code |= PFERR_PRIVATE_ACCESS;
+#else
+		return -OPNOTSUPP;
+#endif
+	}
+
+	if (IS_ALIGNED(mapping->base_gfn, KVM_PAGES_PER_HPAGE(PG_LEVEL_1G)) &&
+	    mapping->nr_pages >= KVM_PAGES_PER_HPAGE(PG_LEVEL_1G))
+		max_level = PG_LEVEL_1G;
+	else if (IS_ALIGNED(mapping->base_gfn, KVM_PAGES_PER_HPAGE(PG_LEVEL_2M)) &&
+		 mapping->nr_pages >= KVM_PAGES_PER_HPAGE(PG_LEVEL_2M))
+		max_level = PG_LEVEL_2M;
+	else
+		max_level = PG_LEVEL_4K;
+
+	r = kvm_mmu_map_page(vcpu, gfn_to_gpa(mapping->base_gfn), error_code,
+			     max_level, &goal_level);
+	if (r)
+		return r;
+
+	if (mapping->source)
+		mapping->source += KVM_HPAGE_SIZE(goal_level);
+	mapping->base_gfn += KVM_PAGES_PER_HPAGE(goal_level);
+	mapping->nr_pages -= KVM_PAGES_PER_HPAGE(goal_level);
+	return r;
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
-- 
2.25.1


