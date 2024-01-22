Return-Path: <kvm+bounces-6692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 69CF2837884
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:21:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D1C9E1F21A45
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D355C85C50;
	Mon, 22 Jan 2024 23:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f2X9zfh/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF57182D7A;
	Mon, 22 Jan 2024 23:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967782; cv=none; b=JuAOfD7+LpqRamQncumlKdVzEwHLWVSyVqhmMRyL/JvPqRclblGJD9vNIMLvCeqp/d4sl+CP6l2O7pAZtj4bqtIwoOxMmmS2ehv/aXiTDpfQsylC/AN0eG9kAsXwMoOPn23z2zS3CiW4hE8i1AKxC3VLS2Zo2fi6GkqvHs8UifM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967782; c=relaxed/simple;
	bh=ZbZ7+A5EibZigj2mCZXMFbRBym1A234FgreO8NpIgF4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MERZo/1WNvyV5IUSyFwgd87A3bJz4vTDaO4P/o5YJLsO++m78+a2kdcZB6KwK/g6lBUKnVh3OU1qtBYehkzhg//zpRFb4bZGVGzRzqnzO4M2MbWxiXtNfx1R6jQAlQsFzGdiXO1GN5i279lXmpl4TJF/vj4SZQWhXmVgR9p3IyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f2X9zfh/; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967779; x=1737503779;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZbZ7+A5EibZigj2mCZXMFbRBym1A234FgreO8NpIgF4=;
  b=f2X9zfh/vD36Q30uRY7QF2pWNTc6PrKZWt16Rw+5B23Y02RAa5heCZq9
   WZ7FWMipm3/jsKQYJKIvGmDJH3S/O/DbyJrrwUGleZBvgq8ZFu4LIH5yA
   jQMuWrAa3E73HPnJNp4dXfOIwBKBbL30i4foDzuhM6U/7a4gEmuS+aoCl
   OD2OZdtgG55ailxFkrE8Rd84iETB41bFuRfRYnShUljYT1EsjfY8NO5rB
   xsei8fTg3A4H3U+U/tZeUwiJpuoY4zOXs8TEfslMfjn/Ezo6w/Dl/89mi
   Yb1+38un9vQt7KIlKARWc+InbRFgqE25yOFiVh1PV5fgVZz0VGKCcEDuZ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="400217961"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="400217961"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27818046"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:59 -0800
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
Subject: [PATCH v18 118/121] KVM: TDX: Add hint TDX ioctl to release Secure-EPT
Date: Mon, 22 Jan 2024 15:54:34 -0800
Message-Id: <06f9971cdd9523c14f963c4ea9081644cecb9c48.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
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
index f2a37b479f26..f811f433feef 100644
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
index fc258f112e73..53eb9508cde2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6908,6 +6908,7 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 	static_call_cond(kvm_x86_flush_shadow_all_private)(kvm);
 	kvm_mmu_zap_all(kvm);
 }
+EXPORT_SYMBOL_GPL(kvm_arch_flush_shadow_all);
 
 static void kvm_mmu_zap_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index be1cc08dd74a..475a913ef25e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2818,6 +2818,15 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
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


