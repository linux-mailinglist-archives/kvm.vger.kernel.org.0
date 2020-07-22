Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4751A229C99
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731036AbgGVQB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:01:58 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37950 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730325AbgGVQBl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:41 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id EF4DE305D6CF;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id DC45D305FFB4;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 27/34] KVM: x86: add .disable_ve()
Date:   Wed, 22 Jul 2020 19:01:14 +0300
Message-Id: <20200722160121.9601-28-alazar@bitdefender.com>
In-Reply-To: <20200722160121.9601-1-alazar@bitdefender.com>
References: <20200722160121.9601-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ștefan Șicleru <ssicleru@bitdefender.com>

This function is needed for the KVMI_VCPU_DISABLE_VE command.

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/vmx.c          | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4cee641af48e..54969c2e804e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1316,6 +1316,7 @@ struct kvm_x86_ops {
 	int (*control_ept_view)(struct kvm_vcpu *vcpu, u16 view, u8 visible);
 	int (*set_ve_info)(struct kvm_vcpu *vcpu, unsigned long ve_info,
 				bool trigger_vmexit);
+	int (*disable_ve)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 871cc49063d8..96aa4b7e2857 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4464,6 +4464,15 @@ static int vmx_set_ve_info(struct kvm_vcpu *vcpu, unsigned long ve_info,
 	return 0;
 }
 
+static int vmx_disable_ve(struct kvm_vcpu *vcpu)
+{
+	if (kvm_ve_supported)
+		secondary_exec_controls_clearbit(to_vmx(vcpu),
+						 SECONDARY_EXEC_EPT_VE);
+
+	return 0;
+}
+
 #define VMX_XSS_EXIT_BITMAP 0
 
 /*
@@ -8390,6 +8399,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.set_ept_view = vmx_set_ept_view,
 	.control_ept_view = vmx_control_ept_view,
 	.set_ve_info = vmx_set_ve_info,
+	.disable_ve = vmx_disable_ve,
 };
 
 static __init int hardware_setup(void)
