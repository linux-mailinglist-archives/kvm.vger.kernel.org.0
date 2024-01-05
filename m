Return-Path: <kvm+bounces-5713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2E94825111
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 10:44:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CBDE1C22E98
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 09:44:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCDF0250E9;
	Fri,  5 Jan 2024 09:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="llifZT+L"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8210624B49;
	Fri,  5 Jan 2024 09:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704447854; x=1735983854;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=TAQv9JJR1XqAj6tjxwKS30HsTbZYt1Z095C7qYz5bks=;
  b=llifZT+LT5JFklPZLtvMD6OSUyLlFZdQAxyVQwUyy85tmICkuc/cqXuU
   5VbNfepjNfrHPRTF87oa3jb7W8PdQASabjwJ5IY7CQYfNXmO/BME9pRl0
   Xn8+0gO72RU8Q9jlQWAiJHmgd/5A3pxROn3CqYM6fjK4GSFH4IWcbaZ0m
   p6g59h/OD3IHe0Vm7DjrXUiOiLIOWGZjTWN8Bc4F2hLZFr/hLjO/b6yfX
   iDoJ6PyobELrAtjGtVmrR07CmgrZUxqnetHRH/ipB8PiThBy5MubqRyZP
   bAEc0WKhFl7awk/AilCXHQ8AYrzcuvmRqFWNfR2Ts410s3BeCQvqV++d1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="10842964"
X-IronPort-AV: E=Sophos;i="6.04,333,1695711600"; 
   d="scan'208";a="10842964"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2024 01:44:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,333,1695711600"; 
   d="scan'208";a="22458420"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2024 01:44:07 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	olvaffe@gmail.com,
	kevin.tian@intel.com,
	zhiyuan.lv@intel.com,
	zhenyu.z.wang@intel.com,
	yongwei.ma@intel.com,
	vkuznets@redhat.com,
	wanpengli@tencent.com,
	jmattson@google.com,
	joro@8bytes.org,
	gurchetansingh@chromium.org,
	kraxel@redhat.com,
	zzyiwei@google.com,
	ankita@nvidia.com,
	jgg@nvidia.com,
	alex.williamson@redhat.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: [PATCH 2/4] KVM: x86: Add a new param "slot" to op get_mt_mask in kvm_x86_ops
Date: Fri,  5 Jan 2024 17:14:54 +0800
Message-Id: <20240105091454.24700-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240105091237.24577-1-yan.y.zhao@intel.com>
References: <20240105091237.24577-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Add param "slot" to op get_mt_mask in kvm_x86_ops.
This is a preparation patch to later honor guest PATs for certain memslots.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/mmu/spte.c         | 3 ++-
 arch/x86/kvm/vmx/vmx.c          | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a565a2e70f30..6be0d8ccff65 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1675,7 +1675,8 @@ struct kvm_x86_ops {
 	int (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
-	u8 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
+	u8 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio,
+			  const struct kvm_memory_slot *slot);
 
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 4a599130e9c9..2c3ede3f27a9 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -191,7 +191,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 
 	if (shadow_memtype_mask)
 		spte |= static_call(kvm_x86_get_mt_mask)(vcpu, gfn,
-							 kvm_is_mmio_pfn(pfn));
+							 kvm_is_mmio_pfn(pfn),
+							 slot);
 	if (host_writable)
 		spte |= shadow_host_writable_mask;
 	else
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 40e3780d73ae..85a23765e506 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7576,7 +7576,8 @@ static int vmx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
-static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
+static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio,
+			  const struct kvm_memory_slot *slot)
 {
 	/* We wanted to honor guest CD/MTRR/PAT, but doing so could result in
 	 * memory aliases with conflicting memory types and sometimes MCEs.
-- 
2.17.1


