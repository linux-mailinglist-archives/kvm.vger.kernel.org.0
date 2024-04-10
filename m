Return-Path: <kvm+bounces-14165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B3688A02E9
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 00:10:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43BBA28707D
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 22:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15D641A0B15;
	Wed, 10 Apr 2024 22:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jb69LJbo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8777F199E99;
	Wed, 10 Apr 2024 22:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712786882; cv=none; b=ApROqmkruDbxqssRzNtcoxeTEZRF38G0guVmqteraBILUalz3qii8uUhMNRqgmhXNnIXDd4jxCRZFxDhSSNa/ud9xedf2jo9unnRBegcq3/OkVOaLOeISdaKFG69hASqdmTGw7Lqpd6ByH7f1AM2hr+4mrolpoLnUBT8lCy5/q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712786882; c=relaxed/simple;
	bh=yk0wcqElxl1bqJsocGv0srLS/uJA2TdoHc6rwAmCIaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQG8HKYJdhoBMNhdEEWa16z9GtzYK88AdHFiJiuK4gYrKt8GtyeCtqoQUoZ7u+47H0y/rVyTcUSl0wyDovvlj50yXqvChK/RGGSco3HPBQsv8ousw4mSkKRqAaZHaUaF0P0wAxPCFUSiUuGG4P2jgSfcfrmu9ebdMG56rcio9EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jb69LJbo; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712786881; x=1744322881;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yk0wcqElxl1bqJsocGv0srLS/uJA2TdoHc6rwAmCIaU=;
  b=Jb69LJboraDal8QeHixShG84J4vaMISGr6u8TtcXK5t3fjh5uRNFIyjO
   nrS+2M1sO1NY+fY4dB7OZPg7FXlaK3FKOWnmjsBWyYU+iFeMwMe5Px4Za
   fBw+FlaLTEXSQgRBZBlHRMXqZ5ixV5nibUuTVSm9u4IAHUriWl1BxgCSl
   pM3iSEgOl1qdyPYve4gvIvH0oXr3R/hwqLCAcQzuXwKu49FrCe+Shtb6g
   jInJQd3tRaKVpX0eigvYvZnlhWYvh18yzi/SZCtXbBgFKuNif2kGxbrx+
   ih2zW1d8/xGE+KFWlm7aQT4aEXWCqg0qaLDP8MasPrdAq6eo98wgnoIQ8
   g==;
X-CSE-ConnectionGUID: psBFvCCWRbWin35ceodU+Q==
X-CSE-MsgGUID: NyO7iItHR/W8LPrT7Usivg==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="8041154"
X-IronPort-AV: E=Sophos;i="6.07,191,1708416000"; 
   d="scan'208";a="8041154"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 15:07:59 -0700
X-CSE-ConnectionGUID: 7qyOBPlMSYuFbrYpFg10Yw==
X-CSE-MsgGUID: 46U7rv4GQBqzVjzELZQD5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,191,1708416000"; 
   d="scan'208";a="25476327"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 15:07:58 -0700
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
Subject: [PATCH v2 09/10] KVM: SVM: Implement pre_mmu_map_page() to refuse KVM_MAP_MEMORY
Date: Wed, 10 Apr 2024 15:07:35 -0700
Message-ID: <b884bf12436e69a2f16f86067d6ed17e9b86596b.1712785629.git.isaku.yamahata@intel.com>
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

Implement vendor callback for KVM_MAP_MEMORY for SEV as EOPNOTSUPP because
it should use SEV-specific ioctl instead.  This patch is only to
demonstrate how to implement the hook.

Compile only tested.  I leave the actual implementation to the SEV folks.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v2:
- Newly added
---
 arch/x86/kvm/svm/sev.c | 6 ++++++
 arch/x86/kvm/svm/svm.c | 2 ++
 arch/x86/kvm/svm/svm.h | 9 +++++++++
 3 files changed, 17 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1642d7d49bde..ab17d7c16636 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3322,3 +3322,9 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
 
 	return p;
 }
+
+int sev_pre_mmu_map_page(struct kvm_vcpu *vcpu,
+			 struct kvm_memory_mapping *mapping, u64 *error_code)
+{
+	return -EOPNOTSUPP;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 535018f152a3..a886d4409b00 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5057,6 +5057,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
+
+	.pre_mmu_map_page = sev_pre_mmu_map_page,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 323901782547..c8dafcb0bfc6 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -689,6 +689,9 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
 int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd);
 int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd);
 void sev_guest_memory_reclaimed(struct kvm *kvm);
+int sev_pre_mmu_map_page(struct kvm_vcpu *vcpu,
+			 struct kvm_memory_mapping *mapping, u64 *error_code);
+
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
 
 /* These symbols are used in common code and are stubbed below.  */
@@ -713,6 +716,12 @@ static inline void __init sev_hardware_setup(void) {}
 static inline void sev_hardware_unsetup(void) {}
 static inline int sev_cpu_init(struct svm_cpu_data *sd) { return 0; }
 static inline int sev_dev_get_attr(u32 group, u64 attr, u64 *val) { return -ENXIO; }
+static inline int sev_pre_mmu_map_page(struct kvm_vcpu *vcpu,
+				       struct kvm_memory_mapping *mapping,
+				       u64 *error_code)
+{
+	return -EOPNOTSUPP;
+}
 #define max_sev_asid 0
 #endif
 
-- 
2.43.2


