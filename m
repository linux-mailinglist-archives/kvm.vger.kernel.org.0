Return-Path: <kvm+bounces-3257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CB38801C1F
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 11:05:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AFD51B20E58
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 10:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A93A15AE1;
	Sat,  2 Dec 2023 10:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KceNHWxV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E366B1A6;
	Sat,  2 Dec 2023 02:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701511531; x=1733047531;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=2TvSYcYyRxZJXd7jYUAEf7Q9pF2z8JkVIapNJrcQxZk=;
  b=KceNHWxVMoHHTCmvnwDci7v4XGhRA6PCaY/ADkAwT9wtdPMJuhU39Z95
   lNJ5WhQo/wnsCjMXGFEtTODwDNVqzp9y1mUfL8dRoVhX4WCCqcQvtvaTk
   4+3CCJHY3NTVG8LQiWyKwqMf1MIzguE8PFYHFVl+EFKwDwbYyLpfCm6Hg
   5tiZDzi4uOg9vfXeHZispiHtTJHqZ26+4nIzECS3tCMCqJuzCWtS+SaHk
   khXqUGefse4Nz4Tk7ZRAlBNHgCrZYzDzsK7jtC6kKOKe7JGac1QSwK5mK
   qbEAKQNj5TDE4m0oIEe+vBaUlu2T/D/LTYsQ4EXVAO3p0pTaTtwDr/lmN
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="392459741"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="392459741"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 02:05:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="887939973"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="887939973"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 02:05:28 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com,
	jgg@nvidia.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com,
	dwmw2@infradead.org,
	yi.l.liu@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 41/42] KVM: VMX: Implement ops .flush_remote_tlbs* in VMX when EPT is on
Date: Sat,  2 Dec 2023 17:36:33 +0800
Message-Id: <20231202093633.15991-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Add VMX implementation of ops of flush_remote_tlbs* in kvm_x86_ops when
enable_ept is on and CONFIG_HYPERV is off.

Without ops flush_remote_tlbs* in VMX, kvm_flush_remote_tlbs*() just makes
all cpus request KVM_REQ_TLB_FLUSH after finding the two ops are
non-present.
So, by also making all cpu requests KVM_REQ_TLB_FLUSH in ops
flush_remote_tlbs* in VMX, no functional changes should be introduced.

The two ops allow vendor code (e.g. VMX) to control when to notify IOMMU
to flush TLBs. This is useful for contidions when sequence to flush CPU
TLBs and IOTLBs is important.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7965bc32f87de..2fec351a3fa5b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7544,6 +7544,17 @@ static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 	return err;
 }
 
+static int vmx_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, gfn_t nr_pages)
+{
+	kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH);
+	return 0;
+}
+
+static int vmx_flush_remote_tlbs(struct kvm *kvm)
+{
+	return vmx_flush_remote_tlbs_range(kvm, 0, -1ULL);
+}
+
 #define L1TF_MSG_SMT "L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 #define L1TF_MSG_L1D "L1TF CPU bug present and virtualization mitigation disabled, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 
@@ -8528,6 +8539,11 @@ static __init int hardware_setup(void)
 		vmx_x86_ops.flush_remote_tlbs = hv_flush_remote_tlbs;
 		vmx_x86_ops.flush_remote_tlbs_range = hv_flush_remote_tlbs_range;
 	}
+#else
+	if (enable_ept) {
+		vmx_x86_ops.flush_remote_tlbs = vmx_flush_remote_tlbs;
+		vmx_x86_ops.flush_remote_tlbs_range = vmx_flush_remote_tlbs_range;
+	}
 #endif
 
 	if (!cpu_has_vmx_ple()) {
-- 
2.17.1


