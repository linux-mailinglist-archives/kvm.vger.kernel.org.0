Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD2F4244A0
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239340AbhJFRmp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:42:45 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53562 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238874AbhJFRmf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:35 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 82B83307CAE3;
        Wed,  6 Oct 2021 20:31:00 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 680A83064495;
        Wed,  6 Oct 2021 20:31:00 +0300 (EEST)
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
Subject: [PATCH v12 18/77] KVM: x86: add kvm_x86_ops.control_singlestep()
Date:   Wed,  6 Oct 2021 20:30:14 +0300
Message-Id: <20211006173113.26445-19-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <nicu.citu@icloud.com>

This function is needed for KVMI_VCPU_CONTROL_SINGLESTEP.

Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/vmx/vmx.c             | 11 +++++++++++
 3 files changed, 13 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index ad6c19d9bef5..80cd010ab3fd 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -130,6 +130,7 @@ KVM_X86_OP(desc_intercepted)
 KVM_X86_OP(msr_write_intercepted)
 KVM_X86_OP(control_msr_intercept)
 KVM_X86_OP(fault_gla)
+KVM_X86_OP_NULL(control_singlestep)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_NULL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 96058a8a1e5e..dfc52e451f9b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1511,6 +1511,7 @@ struct kvm_x86_ops {
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
 
 	u64 (*fault_gla)(struct kvm_vcpu *vcpu);
+	void (*control_singlestep)(struct kvm_vcpu *vcpu, bool enable);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f3e880ef22c8..86fa84205d23 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7627,6 +7627,16 @@ static u64 vmx_fault_gla(struct kvm_vcpu *vcpu)
 	return ~0ull;
 }
 
+static void vmx_control_singlestep(struct kvm_vcpu *vcpu, bool enable)
+{
+	if (enable)
+		exec_controls_setbit(to_vmx(vcpu),
+			      CPU_BASED_MONITOR_TRAP_FLAG);
+	else
+		exec_controls_clearbit(to_vmx(vcpu),
+				CPU_BASED_MONITOR_TRAP_FLAG);
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.hardware_unsetup = hardware_unsetup,
 
@@ -7771,6 +7781,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
 
 	.fault_gla = vmx_fault_gla,
+	.control_singlestep = vmx_control_singlestep,
 };
 
 static __init void vmx_setup_user_return_msrs(void)
