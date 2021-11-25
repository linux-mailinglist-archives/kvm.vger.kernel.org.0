Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F9645D1F9
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344269AbhKYA2F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:28:05 -0500
Received: from mga14.intel.com ([192.55.52.115]:6411 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352800AbhKYAYT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:19 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="235649683"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="235649683"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:09 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042164"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:08 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v3 19/59] KVM: Add per-VM flag to mark read-only memory as unsupported
Date:   Wed, 24 Nov 2021 16:20:02 -0800
Message-Id: <e89addfaf798fd27af512fe4c6ea34846dcffeb2.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 include/linux/kvm_host.h | 3 +++
 virt/kvm/kvm_main.c      | 8 +++++---
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0ebd60846079..535f65b0915d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4121,7 +4121,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ASYNC_PF_INT:
 	case KVM_CAP_GET_TSC_KHZ:
 	case KVM_CAP_KVMCLOCK_CTRL:
-	case KVM_CAP_READONLY_MEM:
 	case KVM_CAP_HYPERV_TIME:
 	case KVM_CAP_IOAPIC_POLARITY_IGNORED:
 	case KVM_CAP_TSC_DEADLINE_TIMER:
@@ -4239,6 +4238,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		if (static_call(kvm_x86_is_vm_type_supported)(KVM_X86_TDX_VM))
 			r |= BIT(KVM_X86_TDX_VM);
 		break;
+	case KVM_CAP_READONLY_MEM:
+		r = kvm && kvm->readonly_mem_unsupported ? 0 : 1;
+		break;
 	default:
 		break;
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 625de21ceb43..d59debe99212 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -624,6 +624,9 @@ struct kvm {
 	struct notifier_block pm_notifier;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
+#ifdef __KVM_HAVE_READONLY_MEM
+	bool readonly_mem_unsupported;
+#endif
 };
 
 #define kvm_err(fmt, ...) \
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4a1dbf0b1d3d..aaa6d69265ea 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1422,12 +1422,14 @@ static void update_memslots(struct kvm_memslots *slots,
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
@@ -1665,7 +1667,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	int as_id, id;
 	int r;
 
-	r = check_memory_region_flags(mem);
+	r = check_memory_region_flags(kvm, mem);
 	if (r)
 		return r;
 
-- 
2.25.1

