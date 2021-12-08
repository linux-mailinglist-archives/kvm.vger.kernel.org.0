Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A9E46BEC7
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 16:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238562AbhLGPNP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 10:13:15 -0500
Received: from mga14.intel.com ([192.55.52.115]:5480 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238582AbhLGPNM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 10:13:12 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="237821152"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="237821152"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 07:09:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="461289855"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga003.jf.intel.com with ESMTP; 07 Dec 2021 07:09:38 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: [PATCH 09/19] kvm: x86: Prepare reallocation check
Date:   Tue,  7 Dec 2021 19:03:49 -0500
Message-Id: <20211208000359.2853257-10-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211208000359.2853257-1-yang.zhong@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jing Liu <jing2.liu@intel.com>

On native fpstate reallocation is triggered by #NM because IA32_XFD
is initialized to 1 for all native tasks.

However #NM in guest is not trapped by KVM. Instead, guest enabling
of a dynamic extended feature can be captured via emulation of
IA32_XFD and XSETBV. Basically having guest XCR0[i]=1 and XFD[i]=0
indicates that the feature[i] is activated by the guest.

This patch provides a helper function for such check, invoked when
either XCR0 or XFD is changed in the emulation path.

Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
---
 arch/x86/kvm/x86.c | 24 ++++++++++++++++++++++++
 arch/x86/kvm/x86.h |  1 +
 2 files changed, 25 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 05f2cda73d69..91cc6f69a7ca 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -956,6 +956,30 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_load_host_xsave_state);
 
+bool kvm_check_guest_realloc_fpstate(struct kvm_vcpu *vcpu, u64 xfd)
+{
+	u64 xcr0 = vcpu->arch.xcr0 & XFEATURE_MASK_USER_DYNAMIC;
+
+	/* For any state which is enabled dynamically */
+	if ((xfd & xcr0) != xcr0) {
+		u64 request = (xcr0 ^ xfd) & xcr0;
+		struct fpu_guest *guest_fpu = &vcpu->arch.guest_fpu;
+
+		/*
+		 * If requested features haven't been enabled, update
+		 * the request bitmap and tell the caller to request
+		 * dynamic buffer reallocation.
+		 */
+		if ((guest_fpu->user_xfeatures & request) != request) {
+			vcpu->arch.guest_fpu.realloc_request = request;
+			return true;
+		}
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(kvm_check_guest_realloc_fpstate);
+
 static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 {
 	u64 xcr0 = xcr;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 4abcd8d9836d..24a323980146 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -445,6 +445,7 @@ static inline void kvm_machine_check(void)
 
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
+bool kvm_check_guest_realloc_fpstate(struct kvm_vcpu *vcpu, u64 new_xfd);
 int kvm_spec_ctrl_test_value(u64 value);
 bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
