Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFDFD46BED1
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 16:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238620AbhLGPNa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 10:13:30 -0500
Received: from mga14.intel.com ([192.55.52.115]:5581 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238630AbhLGPNU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 10:13:20 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="237821193"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="237821193"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 07:09:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="461289944"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga003.jf.intel.com with ESMTP; 07 Dec 2021 07:09:46 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: [PATCH 11/19] kvm: x86: Check fpstate reallocation in XSETBV emulation
Date:   Tue,  7 Dec 2021 19:03:51 -0500
Message-Id: <20211208000359.2853257-12-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211208000359.2853257-1-yang.zhong@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

XSETBV allows the software to write the extended control register
XCR0, thus its emulation handler also needs to check fpstate
reallocation when the changed XCR0 value enables certain
dynamically-enabled features.

Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
---
 arch/x86/kvm/x86.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c83887cb55ee..b195f4fa888f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1028,6 +1028,15 @@ int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu)
 		return 1;
 	}
 
+	if (guest_cpuid_has(vcpu, X86_FEATURE_XFD)) {
+		if (kvm_check_guest_realloc_fpstate(vcpu, vcpu->arch.guest_fpu.fpstate->xfd)) {
+			vcpu->run->exit_reason = KVM_EXIT_FPU_REALLOC;
+			vcpu->arch.complete_userspace_io =
+				kvm_skip_emulated_instruction;
+			return 0;
+		}
+	}
+
 	return kvm_skip_emulated_instruction(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_xsetbv);
