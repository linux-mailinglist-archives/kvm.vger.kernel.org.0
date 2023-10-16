Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12147CB001
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343543AbjJPQkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234248AbjJPQj2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:39:28 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15E06F8B;
        Mon, 16 Oct 2023 09:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473371; x=1729009371;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T4a6QLAHbIlS347ZUzcknVDH3ehYa35Mi72z6gGdGHU=;
  b=RIwViGmjVjDQB8KaYXC8ua/N+3dtWkKo8+inyy+SHpr8uQoNLjh8+v2Z
   VV7M75jWe7pgeWL+gx9mFHB9N6Jb/Kw7p01DWS0glHZlOSye5FG4/ux0Q
   Vv9VVGiYmdv3jVTy1AueqQuRHiKYdwef2EjXEz7aKYTHf2tG34kSsT6E5
   mKeujM7jfWyz07luOHMw6tsmxcFLa6PJqFV7Q/edId71dI3LOLJMk9vkF
   UJ90rrGJJNbG9ibTfEEti2chvK/PYGiQzFqJpfVAc/I+dh5wVK8BNcoTT
   K8Wf7EhzK7yJkHZM1T79QxTZ7med7SBwfBVo4tt5DyY4z09fB8sVXc2Mg
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364922170"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="364922170"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="1003006493"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="1003006493"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:13 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v16 113/116] KVM: TDX: Add hint TDX ioctl to release Secure-EPT
Date:   Mon, 16 Oct 2023 09:15:05 -0700
Message-Id: <2dc3772667b544d69a473fc740220e6a3fdd6fd5.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
index 63a4efd1e40a..26bad5c646fe 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6907,6 +6907,7 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 	static_call_cond(kvm_x86_flush_shadow_all_private)(kvm);
 	kvm_mmu_zap_all(kvm);
 }
+EXPORT_SYMBOL_GPL(kvm_arch_flush_shadow_all);
 
 static void kvm_mmu_zap_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 924cbf97404a..3287701199dd 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2771,6 +2771,15 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
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

