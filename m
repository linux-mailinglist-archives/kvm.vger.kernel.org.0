Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB830229C7D
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbgGVQBe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:01:34 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37824 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726938AbgGVQBe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:34 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id E33593016C4A;
        Wed, 22 Jul 2020 19:01:31 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id D81173072785;
        Wed, 22 Jul 2020 19:01:31 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 01/34] KVM: x86: export .get_vmfunc_status()
Date:   Wed, 22 Jul 2020 19:00:48 +0300
Message-Id: <20200722160121.9601-2-alazar@bitdefender.com>
In-Reply-To: <20200722160121.9601-1-alazar@bitdefender.com>
References: <20200722160121.9601-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marian Rotariu <marian.c.rotariu@gmail.com>

The introspection tool uses this function to check the hardware support
for VMFUNC, which can be used either to singlestep vCPUs
on a unprotected EPT view or to use #VE in order to filter out
VM-exits caused by EPT violations.

Signed-off-by: Marian Rotariu <marian.c.rotariu@gmail.com>
Co-developed-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/vmx/vmx.c          | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d96bf0e15ea2..ab6989745f9c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1300,6 +1300,7 @@ struct kvm_x86_ops {
 	bool (*spt_fault)(struct kvm_vcpu *vcpu);
 	bool (*gpt_translation_fault)(struct kvm_vcpu *vcpu);
 	void (*control_singlestep)(struct kvm_vcpu *vcpu, bool enable);
+	bool (*get_vmfunc_status)(void);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8c9ccd1ba0f0..ec4396d5f36f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7992,6 +7992,11 @@ static void vmx_control_singlestep(struct kvm_vcpu *vcpu, bool enable)
 				CPU_BASED_MONITOR_TRAP_FLAG);
 }
 
+static bool vmx_get_vmfunc_status(void)
+{
+	return cpu_has_vmx_vmfunc();
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.hardware_unsetup = hardware_unsetup,
 
@@ -8133,6 +8138,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.spt_fault = vmx_spt_fault,
 	.gpt_translation_fault = vmx_gpt_translation_fault,
 	.control_singlestep = vmx_control_singlestep,
+	.get_vmfunc_status = vmx_get_vmfunc_status,
 };
 
 static __init int hardware_setup(void)
