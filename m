Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F08C2B4FBF
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732897AbgKPScm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:32:42 -0500
Received: from mga06.intel.com ([134.134.136.31]:20632 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387771AbgKPS2D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:03 -0500
IronPort-SDR: ZXajAuBrZ2koRQ28pD2moigbziGlX5TanRdDgllmNqAhUC1OpEKmBDabfHhaqe2DB2jd3nW74q
 oL90CDntHhzw==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410028"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410028"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:02 -0800
IronPort-SDR: HSmSmve9NahGtLT9P0ekBHeZ+ETPGer5F6hFhlc8Q5AxThCCdr1jMH67bHx+ERS18CDjE7zU2t
 i7x5r3Jy1dHw==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400527973"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:02 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 22/67] KVM: Add per-VM flag to mark read-only memory as unsupported
Date:   Mon, 16 Nov 2020 10:26:07 -0800
Message-Id: <499bf4c92e07de7e27745cf8d266a1932d18d85f.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a flag for TDX to flag RO memory as unsupported and propagate it to
KVM_MEM_READONLY to allow reporting RO memory as unsupported on a per-VM
basis.  TDX1 doesn't expose permission bits to the VMM in the SEPT
tables, i.e. doesn't support read-only private memory.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c       | 4 +++-
 include/linux/kvm_host.h | 4 ++++
 virt/kvm/kvm_main.c      | 8 +++++---
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 01380f057d9f..4060f3d91f74 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3695,7 +3695,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ASYNC_PF_INT:
 	case KVM_CAP_GET_TSC_KHZ:
 	case KVM_CAP_KVMCLOCK_CTRL:
-	case KVM_CAP_READONLY_MEM:
 	case KVM_CAP_HYPERV_TIME:
 	case KVM_CAP_IOAPIC_POLARITY_IGNORED:
 	case KVM_CAP_TSC_DEADLINE_TIMER:
@@ -3785,6 +3784,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		if (kvm_x86_ops.is_vm_type_supported(KVM_X86_TDX_VM))
 			r |= BIT(KVM_X86_TDX_VM);
 		break;
+	case KVM_CAP_READONLY_MEM:
+		r = kvm && kvm->readonly_mem_unsupported ? 0 : 1;
+		break;
 	default:
 		break;
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 95371750c23f..1a0df7b83fd0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -517,6 +517,10 @@ struct kvm {
 	pid_t userspace_pid;
 	unsigned int max_halt_poll_ns;
 
+#ifdef __KVM_HAVE_READONLY_MEM
+	bool readonly_mem_unsupported;
+#endif
+
 	bool vm_bugged;
 };
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3dc41b6e12a0..572a66a61c29 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1100,12 +1100,14 @@ static void update_memslots(struct kvm_memslots *slots,
 	}
 }
 
-static int check_memory_region_flags(const struct kvm_userspace_memory_region *mem)
+static int check_memory_region_flags(struct kvm *kvm,
+				     const struct kvm_userspace_memory_region *mem)
 {
 	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
 
 #ifdef __KVM_HAVE_READONLY_MEM
-	valid_flags |= KVM_MEM_READONLY;
+	if (!kvm->readonly_mem_unsupported)
+		valid_flags |= KVM_MEM_READONLY;
 #endif
 
 	if (mem->flags & ~valid_flags)
@@ -1278,7 +1280,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	int as_id, id;
 	int r;
 
-	r = check_memory_region_flags(mem);
+	r = check_memory_region_flags(kvm, mem);
 	if (r)
 		return r;
 
-- 
2.17.1

