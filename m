Return-Path: <kvm+bounces-48980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 378A6AD5095
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 11:52:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC92817FD62
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 09:52:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD1E1262FC4;
	Wed, 11 Jun 2025 09:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hDsllbdH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEB82AD2C;
	Wed, 11 Jun 2025 09:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749635541; cv=none; b=pP0VbBjuQbYYW0EJPoYJ56LDlcOjhfR2gsJTJ3SgbNPpRylTfH/ZaNO1WQau0tnup8qpq1KYTb9iISKkkWZ88EnT/RGRCsQv/qXd8izbo34YQHul7IZ8eAYtExDjpF3yB/KumynF3Q7k4GJyuFl66vJ6h5qcm0QyOd5nWEnjzk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749635541; c=relaxed/simple;
	bh=GGizW/M7VQbzlo7DKDQvlGPhtn9EZ02EQGWQqnU9QTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KoLeR+iD/6N9X/MaoaFjs/tUBpXfFbQtD65ubhf6DYYz/vUTv5bD56ldHnjDQI9Poox4x/sK0e6mxJeInDDw95kI7A7igc/NiFl4RkLEX5gkmJf9V46R/crGOkvpgWj7AhwnBGolbQ7fisWkf/oabzRamz0hcuoHB4W4xwH+4Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hDsllbdH; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749635539; x=1781171539;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GGizW/M7VQbzlo7DKDQvlGPhtn9EZ02EQGWQqnU9QTI=;
  b=hDsllbdHHhOHyh6p9+qtGaf+YlDrefKu+dfAW82yofoBbDU6dFViMJ5W
   fHPxfEJ9onJTYT68vUCOQ7/8XAaOn6dRvX5um4y/jnwVudZqLmhZzz1IO
   gf8rVfcoJuAiACvo+NvtWkYcnq8poPflLYFqYlJ+3pMOehqCHmgCDcO2S
   SIvKpFTNupbHa3KqOKX+m4sBMH5joRWanp3mgVyLczLJGHnlmG8hrqZkM
   SgI5BooIIrGSidegm8In8dXURZmjTYRtTOsYKuUN8r9aXvf3VNNM3L68N
   QvPN+e2+UuagwmIrwWLmJHQjwi6cJC7WXk0FomD8TVHcPBXWO9BS8UMOT
   w==;
X-CSE-ConnectionGUID: DFQpk6sORJOJNmuYS9CJXA==
X-CSE-MsgGUID: HeTDpOnwTJ6+v3L3TO+NNw==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="51872629"
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="51872629"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 02:52:19 -0700
X-CSE-ConnectionGUID: rCnoe8qdTj6n8hxMLcD60Q==
X-CSE-MsgGUID: 48/dVdZqSJKuHn08KvRaaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="184350750"
Received: from opintica-mobl1 (HELO localhost.localdomain) ([10.245.245.146])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 02:52:13 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kirill.shutemov@linux.intel.com,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	isaku.yamahata@intel.com,
	linux-kernel@vger.kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com
Subject: [PATCH V4 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
Date: Wed, 11 Jun 2025 12:51:58 +0300
Message-ID: <20250611095158.19398-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250611095158.19398-1-adrian.hunter@intel.com>
References: <20250611095158.19398-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

Add sub-ioctl KVM_TDX_TERMINATE_VM to release the HKID prior to shutdown,
which enables more efficient reclaim of private memory.

Private memory is removed from MMU/TDP when guest_memfds are closed. If
the HKID has not been released, the TDX VM is still in RUNNABLE state,
so pages must be removed using "Dynamic Page Removal" procedure (refer
TDX Module Base spec) which involves a number of steps:
	Block further address translation
	Exit each VCPU
	Clear Secure EPT entry
	Flush/write-back/invalidate relevant caches

However, when the HKID is released, the TDX VM moves to TD_TEARDOWN state
where all TDX VM pages are effectively unmapped, so pages can be reclaimed
directly.

Reclaiming TD Pages in TD_TEARDOWN State was seen to decrease the total
reclaim time.  For example:

	VCPUs	Size (GB)	Before (secs)	After (secs)
	 4	 18		  72		 24
	32	107		 517		134
	64	400		5539		467

Link: https://lore.kernel.org/r/Z-V0qyTn2bXdrPF7@google.com
Link: https://lore.kernel.org/r/aAL4dT1pWG5dDDeo@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---


Changes in V4:

	Drop TDX_FLUSHVP_NOT_DONE change.  It will be done separately.
	Use KVM_BUG_ON() instead of WARN_ON().
	Correct kvm_trylock_all_vcpus() return value.

Changes in V3:

	Remove KVM_BUG_ON() from tdx_mmu_release_hkid() because it would
	trigger on the error path from __tdx_td_init()

	Put cpus_read_lock() handling back into tdx_mmu_release_hkid()

	Handle KVM_TDX_TERMINATE_VM in the switch statement, i.e. let
	tdx_vm_ioctl() deal with kvm->lock


 Documentation/virt/kvm/x86/intel-tdx.rst | 16 +++++++++++
 arch/x86/include/uapi/asm/kvm.h          |  1 +
 arch/x86/kvm/vmx/tdx.c                   | 34 ++++++++++++++++++------
 3 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
index de41d4c01e5c..e5d4d9cf4cf2 100644
--- a/Documentation/virt/kvm/x86/intel-tdx.rst
+++ b/Documentation/virt/kvm/x86/intel-tdx.rst
@@ -38,6 +38,7 @@ ioctl with TDX specific sub-ioctl() commands.
           KVM_TDX_INIT_MEM_REGION,
           KVM_TDX_FINALIZE_VM,
           KVM_TDX_GET_CPUID,
+          KVM_TDX_TERMINATE_VM,
 
           KVM_TDX_CMD_NR_MAX,
   };
@@ -214,6 +215,21 @@ struct kvm_cpuid2.
 	  __u32 padding[3];
   };
 
+KVM_TDX_TERMINATE_VM
+-------------------
+:Type: vm ioctl
+:Returns: 0 on success, <0 on error
+
+Release Host Key ID (HKID) to allow more efficient reclaim of private memory.
+After this, the TD is no longer in a runnable state.
+
+Using KVM_TDX_TERMINATE_VM is optional.
+
+- id: KVM_TDX_TERMINATE_VM
+- flags: must be 0
+- data: must be 0
+- hw_error: must be 0
+
 KVM TDX creation flow
 =====================
 In addition to the standard KVM flow, new TDX ioctls need to be called.  The
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 6f3499507c5e..697d396b2cc0 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -940,6 +940,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_INIT_MEM_REGION,
 	KVM_TDX_FINALIZE_VM,
 	KVM_TDX_GET_CPUID,
+	KVM_TDX_TERMINATE_VM,
 
 	KVM_TDX_CMD_NR_MAX,
 };
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b952bc673271..457f91b95147 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -515,6 +515,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 		goto out;
 	}
 
+	write_lock(&kvm->mmu_lock);
 	for_each_online_cpu(i) {
 		if (packages_allocated &&
 		    cpumask_test_and_set_cpu(topology_physical_package_id(i),
@@ -539,7 +540,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	} else {
 		tdx_hkid_free(kvm_tdx);
 	}
-
+	write_unlock(&kvm->mmu_lock);
 out:
 	mutex_unlock(&tdx_lock);
 	cpus_read_unlock();
@@ -1789,13 +1790,13 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	struct page *page = pfn_to_page(pfn);
 	int ret;
 
-	/*
-	 * HKID is released after all private pages have been removed, and set
-	 * before any might be populated. Warn if zapping is attempted when
-	 * there can't be anything populated in the private EPT.
-	 */
-	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
-		return -EINVAL;
+	if (!is_hkid_assigned(to_kvm_tdx(kvm))) {
+		KVM_BUG_ON(!kvm->vm_dead, kvm);
+		ret = tdx_reclaim_page(page);
+		if (!ret)
+			tdx_unpin(kvm, page);
+		return ret;
+	}
 
 	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
 	if (ret <= 0)
@@ -2790,6 +2791,20 @@ static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	return 0;
 }
 
+static int tdx_terminate_vm(struct kvm *kvm)
+{
+	if (kvm_trylock_all_vcpus(kvm))
+		return -EBUSY;
+
+	kvm_vm_dead(kvm);
+
+	kvm_unlock_all_vcpus(kvm);
+
+	tdx_mmu_release_hkid(kvm);
+
+	return 0;
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
@@ -2817,6 +2832,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_TDX_FINALIZE_VM:
 		r = tdx_td_finalize(kvm, &tdx_cmd);
 		break;
+	case KVM_TDX_TERMINATE_VM:
+		r = tdx_terminate_vm(kvm);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
-- 
2.48.1


