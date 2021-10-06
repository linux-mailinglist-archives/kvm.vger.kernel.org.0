Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F633424503
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239497AbhJFRoW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:44:22 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53722 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239462AbhJFRmq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:46 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 4BCC4307CAE2;
        Wed,  6 Oct 2021 20:30:58 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 30D7A3064495;
        Wed,  6 Oct 2021 20:30:58 +0300 (EEST)
X-Is-Junk-Enabled: fGZTSsP0qEJE2AIKtlSuFiRRwg9xyHmJ
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v12 13/77] KVM: x86: add kvm_x86_ops.msr_write_intercepted()
Date:   Wed,  6 Oct 2021 20:30:09 +0300
Message-Id: <20211006173113.26445-14-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <nicu.citu@icloud.com>

This function will be used to check if the write access for a specific
MSR is already intercepted. The information will be used to restore the
interception status when the introspection tool is no longer interested
in that MSR.

Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 1 +
 arch/x86/include/asm/kvm_host.h    | 1 +
 arch/x86/kvm/svm/svm.c             | 1 +
 arch/x86/kvm/vmx/vmx.c             | 1 +
 4 files changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 30d01c9ed31b..90e913408c6e 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -127,6 +127,7 @@ KVM_X86_OP(cr3_write_intercepted)
 KVM_X86_OP(desc_ctrl_supported)
 KVM_X86_OP(control_desc_intercept)
 KVM_X86_OP(desc_intercepted)
+KVM_X86_OP(msr_write_intercepted)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_NULL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1182b0fbd245..1e77cb825ec4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1331,6 +1331,7 @@ struct kvm_x86_ops {
 	void (*update_exception_bitmap)(struct kvm_vcpu *vcpu);
 	int (*get_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
+	bool (*msr_write_intercepted)(struct kvm_vcpu *vcpu, u32 msr);
 	u64 (*get_segment_base)(struct kvm_vcpu *vcpu, int seg);
 	void (*get_segment)(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c1b1e5cdd508..31109961183e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4689,6 +4689,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.get_msr_feature = svm_get_msr_feature,
 	.get_msr = svm_get_msr,
 	.set_msr = svm_set_msr,
+	.msr_write_intercepted = msr_write_intercepted,
 	.get_segment_base = svm_get_segment_base,
 	.get_segment = svm_get_segment,
 	.set_segment = svm_set_segment,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8f34b19827a3..b036aed96912 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7637,6 +7637,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.get_msr_feature = vmx_get_msr_feature,
 	.get_msr = vmx_get_msr,
 	.set_msr = vmx_set_msr,
+	.msr_write_intercepted = msr_write_intercepted,
 	.get_segment_base = vmx_get_segment_base,
 	.get_segment = vmx_get_segment,
 	.set_segment = vmx_set_segment,
