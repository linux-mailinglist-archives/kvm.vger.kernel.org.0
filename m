Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62FD5155DC4
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgBGSS2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:18:28 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40728 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727379AbgBGSQr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:47 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id C5DCD305D3DC;
        Fri,  7 Feb 2020 20:16:39 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id B608E3052068;
        Fri,  7 Feb 2020 20:16:39 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 25/78] KVM: x86: add .control_singlestep()
Date:   Fri,  7 Feb 2020 20:15:43 +0200
Message-Id: <20200207181636.1065-26-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
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
index e05569a5da10..6927a6044e26 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1257,6 +1257,7 @@ struct kvm_x86_ops {
 	u64 (*fault_gla)(struct kvm_vcpu *vcpu);
 	bool (*spt_fault)(struct kvm_vcpu *vcpu);
 	bool (*gpt_translation_fault)(struct kvm_vcpu *vcpu);
+	void (*control_singlestep)(struct kvm_vcpu *vcpu, bool enable);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 83f047fe6bc1..475f5eb6c4c2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7837,6 +7837,16 @@ static bool vmx_gpt_translation_fault(struct kvm_vcpu *vcpu)
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
@@ -7998,6 +8008,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.fault_gla = vmx_fault_gla,
 	.spt_fault = vmx_spt_fault,
 	.gpt_translation_fault = vmx_gpt_translation_fault,
+	.control_singlestep = vmx_control_singlestep,
 };
 
 static void vmx_cleanup_l1d_flush(void)
