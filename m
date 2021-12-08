Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23E046BEC4
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 16:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238616AbhLGPNI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 10:13:08 -0500
Received: from mga14.intel.com ([192.55.52.115]:5480 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238622AbhLGPNE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 10:13:04 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="237821116"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="237821116"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 07:09:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="461289832"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga003.jf.intel.com with ESMTP; 07 Dec 2021 07:09:30 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: [PATCH 07/19] kvm: x86: Propagate fpstate reallocation error to userspace
Date:   Tue,  7 Dec 2021 19:03:47 -0500
Message-Id: <20211208000359.2853257-8-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211208000359.2853257-1-yang.zhong@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jing Liu <jing2.liu@intel.com>

fpstate reallocation is handled when the vCPU thread returns
to userspace. As reallocation could fail (e.g. lack of memory),
this patch extends kvm_put_guest_fpu() to return an integer value
to carry error code to userspace VMM. The userspace VMM is expected
to handle any error caused by fpstate reallocation.

Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
---
 arch/x86/kvm/x86.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0ee1a039b490..05f2cda73d69 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10171,17 +10171,21 @@ static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 }
 
 /* When vcpu_run ends, restore user space FPU context. */
-static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
+static int kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 {
-	fpu_swap_kvm_fpstate(&vcpu->arch.guest_fpu, false);
+	int ret;
+
+	ret = fpu_swap_kvm_fpstate(&vcpu->arch.guest_fpu, false);
 	++vcpu->stat.fpu_reload;
 	trace_kvm_fpu(0);
+
+	return ret;
 }
 
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *kvm_run = vcpu->run;
-	int r;
+	int r, ret;
 
 	vcpu_load(vcpu);
 	kvm_sigset_activate(vcpu);
@@ -10243,7 +10247,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		r = vcpu_run(vcpu);
 
 out:
-	kvm_put_guest_fpu(vcpu);
+	ret = kvm_put_guest_fpu(vcpu);
+	if ((r >= 0) && (ret < 0))
+		r = ret;
+
 	if (kvm_run->kvm_valid_regs)
 		store_regs(vcpu);
 	post_kvm_run_save(vcpu);
