Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D36AD1978B8
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729232AbgC3KTu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:19:50 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43734 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728956AbgC3KTt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:19:49 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id E85DB3074899;
        Mon, 30 Mar 2020 13:12:52 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id CC1FE305B7A1;
        Mon, 30 Mar 2020 13:12:52 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 27/81] KVM: x86: add .control_singlestep()
Date:   Mon, 30 Mar 2020 13:12:14 +0300
Message-Id: <20200330101308.21702-28-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <ncitu@bitdefender.com>

This function is needed for KVMI_VCPU_CONTROL_SINGLESTEP
and KVMI_EVENT_SINGLESTEP.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/vmx.c          | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2e993b240b66..5b8e44e494b1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1292,6 +1292,7 @@ struct kvm_x86_ops {
 	u64 (*fault_gla)(struct kvm_vcpu *vcpu);
 	bool (*spt_fault)(struct kvm_vcpu *vcpu);
 	bool (*gpt_translation_fault)(struct kvm_vcpu *vcpu);
+	void (*control_singlestep)(struct kvm_vcpu *vcpu, bool enable);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5422c35a3216..13462ef2ce9e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7928,6 +7928,16 @@ static bool vmx_gpt_translation_fault(struct kvm_vcpu *vcpu)
 	return true;
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
 static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -8092,6 +8102,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.fault_gla = vmx_fault_gla,
 	.spt_fault = vmx_spt_fault,
 	.gpt_translation_fault = vmx_gpt_translation_fault,
+	.control_singlestep = vmx_control_singlestep,
 };
 
 static void vmx_cleanup_l1d_flush(void)
