Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC993197919
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729736AbgC3KV3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:21:29 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43778 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729476AbgC3KT7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:19:59 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 9EA2930747CC;
        Mon, 30 Mar 2020 13:12:50 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 7A806305B7A0;
        Mon, 30 Mar 2020 13:12:50 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 13/81] KVM: x86: add .desc_ctrl_supported()
Date:   Mon, 30 Mar 2020 13:12:00 +0300
Message-Id: <20200330101308.21702-14-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This function is needed for the KVMI_EVENT_DESCRIPTOR event.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm.c              | 6 ++++++
 arch/x86/kvm/vmx/capabilities.h | 7 ++++++-
 arch/x86/kvm/vmx/vmx.c          | 1 +
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bf36ed2c5e9b..81a59b03b0c5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1105,6 +1105,7 @@ struct kvm_x86_ops {
 	void (*set_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*get_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
+	bool (*desc_ctrl_supported)(void);
 	u64 (*get_dr6)(struct kvm_vcpu *vcpu);
 	void (*set_dr6)(struct kvm_vcpu *vcpu, unsigned long value);
 	void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index de409d73ce0c..f9185f0b0c2b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6109,6 +6109,11 @@ static bool svm_xsaves_supported(void)
 	return boot_cpu_has(X86_FEATURE_XSAVES);
 }
 
+static bool svm_desc_ctrl_supported(void)
+{
+	return true;
+}
+
 static bool svm_umip_emulated(void)
 {
 	return false;
@@ -7475,6 +7480,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.set_idt = svm_set_idt,
 	.get_gdt = svm_get_gdt,
 	.set_gdt = svm_set_gdt,
+	.desc_ctrl_supported = svm_desc_ctrl_supported,
 	.get_dr6 = svm_get_dr6,
 	.set_dr6 = svm_set_dr6,
 	.set_dr7 = svm_set_dr7,
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index f486e2606247..22301cc979cb 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -140,12 +140,17 @@ static inline bool cpu_has_vmx_ept(void)
 		SECONDARY_EXEC_ENABLE_EPT;
 }
 
-static inline bool vmx_umip_emulated(void)
+static inline bool vmx_desc_ctrl_supported(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
 		SECONDARY_EXEC_DESC;
 }
 
+static inline bool vmx_umip_emulated(void)
+{
+	return vmx_desc_ctrl_supported();
+}
+
 static inline bool vmx_pku_supported(void)
 {
 	return boot_cpu_has(X86_FEATURE_PKU);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ba47f5f2ea91..657c9ac0070b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7919,6 +7919,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.set_idt = vmx_set_idt,
 	.get_gdt = vmx_get_gdt,
 	.set_gdt = vmx_set_gdt,
+	.desc_ctrl_supported = vmx_desc_ctrl_supported,
 	.get_dr6 = vmx_get_dr6,
 	.set_dr6 = vmx_set_dr6,
 	.set_dr7 = vmx_set_dr7,
