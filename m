Return-Path: <kvm+bounces-9641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C944A866C59
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:33:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 695B81F221A5
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:33:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EF3753E01;
	Mon, 26 Feb 2024 08:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aj5qsrUs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7010951C4C;
	Mon, 26 Feb 2024 08:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936070; cv=none; b=WYQTY+BDKmL9DtW3m6Ui+zw9b0+77douwVH3Bwc97w4YarW0/ke7fOf0MWFwFtdMJP+LvqzVM1XvbNQuOd2x7h3DeiEp4o5pqRvtvv1Jx88SRnV0QGeSMNDK6fTx9PGH1Zc/WjivMTkllaEFuSMsOOT2vO45GiRdMjTNosuKHg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936070; c=relaxed/simple;
	bh=o8YPZiq6LeeZQGwQQQuIE5wqxkP0AxPJNMylilPEjus=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=POK9SGWXNt5Pwsg8gV1AZkU3XtTILmPlmFpI5BibedFfnK1JgWj7qyIDW9FAyMC9JjODoEGmUe+cF0zj+ajF5vJNGbtzMzWM1wzv7OrNxyCaFTgAfFLpuLVSqwRv574d0gCiPNaLHUASTiaUGniGbXPwwczEw3+ju6hsnOrMilk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aj5qsrUs; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936068; x=1740472068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o8YPZiq6LeeZQGwQQQuIE5wqxkP0AxPJNMylilPEjus=;
  b=aj5qsrUsb0uB8pdy59w+SY8cx0gRe8kKqrf8ZYPVrwbz9hnCAOmktJmO
   kTXuh3VyIqc1hgpzb5sDU+hAtP9mDnWEoS21FYufyDUPq6bcjHOtYONl3
   +QQFzsm/1KWbp/HOMtQ+pw03csWPVaFzC1K/+VFdho9uz5KzmzYdchFi1
   QjS3i8FKtjYafwk86Rk44pHbvVk6SIeQuOVYsG6f6nLnQCJwsItL5XuUq
   4XUVnRSGWuJhL46IFluOpZQAQIT12Exjg/KHVmDmtpYslZboM1c8tBFJJ
   mn1MpLOQX3+gMUclX71+AKnrIItX5lpK9hNJtacZUUQ6Nm12yUZ4PQ7Ge
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="28631497"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="28631497"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6474348"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:43 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v19 017/130] KVM: x86: Implement kvm_arch_{, pre_}vcpu_memory_mapping()
Date: Mon, 26 Feb 2024 00:25:19 -0800
Message-Id: <b61447f906e77f64bd1ddc5389408b901ac20046.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Wire KVM_MEMORY_MAPPING ioctl to kvm_mmu_map_tdp_page() to populate
guest memory.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v19:
- newly added
---
 arch/x86/kvm/x86.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 48a61d283406..03dab4266172 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4663,6 +4663,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_MEMORY_FAULT_INFO:
+	case KVM_CAP_MEMORY_MAPPING:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
@@ -5801,6 +5802,31 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 	}
 }
 
+void kvm_arch_vcpu_pre_memory_mapping(struct kvm_vcpu *vcpu)
+{
+	kvm_mmu_reload(vcpu);
+}
+
+int kvm_arch_vcpu_memory_mapping(struct kvm_vcpu *vcpu,
+				 struct kvm_memory_mapping *mapping)
+{
+	u8 max_level = KVM_MAX_HUGEPAGE_LEVEL;
+	u64 error_code = PFERR_WRITE_MASK;
+	u8 goal_level = PG_LEVEL_4K;
+	int r;
+
+	r = kvm_mmu_map_tdp_page(vcpu, gfn_to_gpa(mapping->base_gfn), error_code,
+				 max_level, &goal_level);
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


