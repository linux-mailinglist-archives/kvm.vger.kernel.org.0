Return-Path: <kvm+bounces-9699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 05720866D1F
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:52:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE07128367F
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:52:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C82C1CAAE;
	Mon, 26 Feb 2024 08:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mn9Rlq5/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E29692E8;
	Mon, 26 Feb 2024 08:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936115; cv=none; b=d9L+eKTP792pbFzCaiJvLGa7VDjEY7rBotYwv4VJ5HHwoMYPVRI4OYqXoVVYE9G0q0Urk50ypNSe+QSsfW3NTVPJ3EgIfA8O/kQV5cWaQkPnxd682v1ro3UK92iTMNKuiwKWucf9rOxxdZyVepnnyrROmQGMg2HeDYEWaNkJq6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936115; c=relaxed/simple;
	bh=WRkO1YUitiN/S3sFKUXbIqDdVI858msvJkdcbzWDebk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hR4goN0BYE5c81ecOatLcbffezkfgxYA2MOqWLk1NR07hVxVZSZH77MAmQhAfGPGuTiySbI9e5XHbl1ao6lcq7pgIbbahIlI+nPISvCWXqgTKS4nvm+nzt6OB90v0UfQpKCWFenM076UlvF3uFNIP8xc/3atQykrH/M23vqqIlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mn9Rlq5/; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936114; x=1740472114;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WRkO1YUitiN/S3sFKUXbIqDdVI858msvJkdcbzWDebk=;
  b=Mn9Rlq5/8AJ2Nv56ZkMlKpMEvr3k1OefYg5jM0bXaxR7oTyFYHe/G7Si
   vzbngtkR3zODUo6tTHLDtCsn2EIvR7IqKJbuLiidSgZ+8TLstoa3SlYNa
   zJGNJTtaQuBZj+IlOwF0JhpQmJopF8aaxt9W1HZxEoBRF4MvSbanefEuM
   2IM4XYlTvrUBzC8qgsKygjhlflLVr1Tifl7yHxNvhLixE4YREKLw0KbeT
   gsAzHpjYxq5hsGjtgs1bqQyaT0vtxH2Chz1nIxIlisdoi+pqU7dCDiJyT
   zzXfkRy0Oc9VRM3AGOhnGCa45RLmHjCKGIzPWq+9+Kur+gO5f/qC10lN5
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3069485"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3069485"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="11272476"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:33 -0800
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
Subject: [PATCH v19 075/130] KVM: TDX: Extend memory measurement with initial guest memory
Date: Mon, 26 Feb 2024 00:26:17 -0800
Message-Id: <c4a905d3245bc20ae1bf0cf2bc8f66816c81466c.1708933498.git.isaku.yamahata@intel.com>
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

TDX allows to extned memory measurement with the initial memory.  Define
new subcommand, KVM_TDX_EXTEND_MEMORY, of VM-scoped KVM_MEMORY_ENCRYPT_OP.
it extends memory measurement of the TDX guest.  The memory region must
be populated with KVM_MEMORY_MAPPING command.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v19:
- newly added
- Split KVM_TDX_INIT_MEM_REGION into only extension function
---
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/vmx/tdx.c          | 64 +++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 4000a2e087a8..34167404020c 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -572,6 +572,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
 	KVM_TDX_INIT_VCPU,
+	KVM_TDX_EXTEND_MEMORY,
 
 	KVM_TDX_CMD_NR_MAX,
 };
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 8cf6e5dab3e9..3cfba63a7762 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1339,6 +1339,67 @@ void tdx_flush_tlb_current(struct kvm_vcpu *vcpu)
 	tdx_track(vcpu->kvm);
 }
 
+static int tdx_extend_memory(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct kvm_memory_mapping mapping;
+	struct tdx_module_args out;
+	bool extended = false;
+	int idx, ret = 0;
+	gpa_t gpa;
+	u64 err;
+	int i;
+
+	/* Once TD is finalized, the initial guest memory is fixed. */
+	if (is_td_finalized(kvm_tdx))
+		return -EINVAL;
+
+	if (cmd->flags)
+		return -EINVAL;
+
+	if (copy_from_user(&mapping, (void __user *)cmd->data, sizeof(mapping)))
+		return -EFAULT;
+
+	/* Sanity check */
+	if (mapping.source || !mapping.nr_pages ||
+	    mapping.nr_pages & GENMASK_ULL(63, 63 - PAGE_SHIFT) ||
+	    mapping.base_gfn + (mapping.nr_pages << PAGE_SHIFT) <= mapping.base_gfn ||
+	    !kvm_is_private_gpa(kvm, mapping.base_gfn) ||
+	    !kvm_is_private_gpa(kvm, mapping.base_gfn + (mapping.nr_pages << PAGE_SHIFT)))
+		return -EINVAL;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	while (mapping.nr_pages) {
+		if (signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
+
+		if (need_resched())
+			cond_resched();
+
+		gpa = gfn_to_gpa(mapping.base_gfn);
+		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
+			err = tdh_mr_extend(kvm_tdx->tdr_pa, gpa + i, &out);
+			if (err) {
+				ret = -EIO;
+				break;
+			}
+		}
+		mapping.base_gfn++;
+		mapping.nr_pages--;
+		extended = true;
+	}
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	if (extended && mapping.nr_pages > 0)
+		ret = -EAGAIN;
+	if (copy_to_user((void __user *)cmd->data, &mapping, sizeof(mapping)))
+		ret = -EFAULT;
+
+	return ret;
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
@@ -1358,6 +1419,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_TDX_INIT_VM:
 		r = tdx_td_init(kvm, &tdx_cmd);
 		break;
+	case KVM_TDX_EXTEND_MEMORY:
+		r = tdx_extend_memory(kvm, &tdx_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
-- 
2.25.1


