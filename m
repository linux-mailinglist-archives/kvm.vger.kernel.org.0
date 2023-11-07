Return-Path: <kvm+bounces-972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5447F7E42AD
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:06:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 58950B21DBB
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:06:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE2E037155;
	Tue,  7 Nov 2023 15:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DrLOwDGS"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A91634CF4
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:04:51 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EDD61AE;
	Tue,  7 Nov 2023 07:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369323; x=1730905323;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LmPaDERgXGzpcbIQ/FnzmYBjtH50b2aHF6TCTDqp+ag=;
  b=DrLOwDGSiHvPGQwO5V/DGhxNKyB0iay2sVL/w5qCQLjYl0fQrRgItYGs
   U5oH9JSgTC/svbXsf2MocR3ldL9CAnaipejTIpr307id/13xDJE4npxX/
   C+49H2N5OV4QlMxIZs9nsDOuu188vIFY5qRrpCVuwZOKyNyXAOdNtkuTf
   YnMOwKtCA5+LTJE51KaasDWGN4kSu/6UJrB8TWjSVOQCAmubh1ehg+QMX
   8XJ6uDkrZpzcC1nPdZC7sCEKrgY3JI31Iir/Owa883QFwYXh+6IZ5r1dm
   6K3HI0tOlslwhMk7xR39H6TNCQpP2jXBd4Mu1fwk38FeymL17MF5++zL4
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462687"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462687"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10851668"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:29 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v17 113/116] KVM: TDX: Add hint TDX ioctl to release Secure-EPT
Date: Tue,  7 Nov 2023 06:57:19 -0800
Message-Id: <29875b6a0d1117f0305cf2ce66b516e700a98fb8.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a new hint KVM TDX ioctl to release Secure-EPT as an optimization to
reduce the time of the destruction of the guest.

It takes tens of minutes to destroy a guest with tens or hundreds of GB of
guest memory.  There are two cases to release pages used for the Secure-EPT
and guest private memory.  One case is runtime while the guest is still
running.  Another case is static when the TD won't run anymore.

In Runtime: Use this when the KVM memory slot is deleted or closes KVM file
descriptors while the user process is live.  Because the guest can still
run, a TLB shoot-down is needed.  The sequence is TLB shoot down, cache
flush each page, releasing the page from the Secure-EPT tree, and
zero-clear them.  It requires four SEAMCALLs per page.
TDH.MEM.RANGE.BLOCK() and TDH.MEM.TRACK() for TLB shoot down,
TDH.PHYMEM.PAGE.WBINVD() for cache flush, and TDH.MEM.PAGE.REMOVE() to
release a page.

In process existing: When we know the vcpu won't run further, KVM can free
the host key ID (HKID) for memory encryption with cache flush.  The vcpu
can't run after that.  It simplifies the sequence to release private pages
by reclaiming and zeroing them to reduce the number of SEAMCALLs to one per
private page, TDH.PHYMEM.PAGE.RECLAIM().  However, this is applicable only
when the user process exits with the MMU notifier release callback.

Add a way for the user space to tell KVM a hint when it starts to destruct
the guest for the efficient way in addition to the MMU notifier.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

---
v16
- Newly added
---
 arch/x86/include/uapi/asm/kvm.h | 1 +
 arch/x86/kvm/mmu/mmu.c          | 1 +
 arch/x86/kvm/vmx/tdx.c          | 9 +++++++++
 3 files changed, 11 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 1b4134247837..afd10fb55cfb 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -574,6 +574,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_INIT_VCPU,
 	KVM_TDX_INIT_MEM_REGION,
 	KVM_TDX_FINALIZE_VM,
+	KVM_TDX_RELEASE_VM,
 
 	KVM_TDX_CMD_NR_MAX,
 };
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 18836345c99a..eb17a508c5d1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6912,6 +6912,7 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 	static_call_cond(kvm_x86_flush_shadow_all_private)(kvm);
 	kvm_mmu_zap_all(kvm);
 }
+EXPORT_SYMBOL_GPL(kvm_arch_flush_shadow_all);
 
 static void kvm_mmu_zap_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 20590b2bb330..8c0291535a78 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2756,6 +2756,15 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_TDX_FINALIZE_VM:
 		r = tdx_td_finalizemr(kvm);
 		break;
+	case KVM_TDX_RELEASE_VM: {
+		int idx;
+
+		idx = srcu_read_lock(&kvm->srcu);
+		kvm_arch_flush_shadow_all(kvm);
+		srcu_read_unlock(&kvm->srcu, idx);
+		r = 0;
+		break;
+	}
 	default:
 		r = -EINVAL;
 		goto out;
-- 
2.25.1


