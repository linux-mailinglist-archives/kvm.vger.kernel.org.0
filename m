Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0FE229C83
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbgGVQBh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:01:37 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37948 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728670AbgGVQBg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:36 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 2C6B2305D7EC;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 22FDD307279A;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 09/34] KVM: x86: add .control_ept_view()
Date:   Wed, 22 Jul 2020 19:00:56 +0300
Message-Id: <20200722160121.9601-10-alazar@bitdefender.com>
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

This will be used by the introspection tool to control the EPT views to
which the guest is allowed to switch.

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/vmx.c          | 18 +++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h          |  2 ++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 300f7fc43987..5e241863153f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1310,6 +1310,7 @@ struct kvm_x86_ops {
 	bool (*get_eptp_switching_status)(void);
 	u16 (*get_ept_view)(struct kvm_vcpu *vcpu);
 	int (*set_ept_view)(struct kvm_vcpu *vcpu, u16 view);
+	int (*control_ept_view)(struct kvm_vcpu *vcpu, u16 view, u8 visible);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0d39487ce5c6..cbc943d217e3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3138,8 +3138,11 @@ static void vmx_construct_eptp_with_index(struct kvm_vcpu *vcpu,
 	if (!eptp_list)
 		return;
 
-	eptp_list[view] = construct_eptp(vcpu,
+	if (test_bit(view, &vmx->allowed_views))
+		eptp_list[view] = construct_eptp(vcpu,
 				vcpu->arch.mmu->root_hpa_altviews[view]);
+	else
+		eptp_list[view] = (~0ULL);
 }
 
 static void vmx_construct_eptp_list(struct kvm_vcpu *vcpu)
@@ -4395,6 +4398,18 @@ static int vmx_set_ept_view(struct kvm_vcpu *vcpu, u16 view)
 	return 0;
 }
 
+static int vmx_control_ept_view(struct kvm_vcpu *vcpu, u16 view, u8 visible)
+{
+	if (visible)
+		set_bit(view, &to_vmx(vcpu)->allowed_views);
+	else
+		clear_bit(view, &to_vmx(vcpu)->allowed_views);
+
+	vmx_construct_eptp_with_index(vcpu, view);
+
+	return 0;
+}
+
 #define VMX_XSS_EXIT_BITMAP 0
 
 /*
@@ -8284,6 +8299,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.get_eptp_switching_status = vmx_get_eptp_switching_status,
 	.get_ept_view = vmx_get_ept_view,
 	.set_ept_view = vmx_set_ept_view,
+	.control_ept_view = vmx_control_ept_view,
 };
 
 static __init int hardware_setup(void)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 4e2f86458ca2..38d50fc7357b 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -300,6 +300,8 @@ struct vcpu_vmx {
 	struct page *eptp_list_pg;
 	/* The view this vcpu operates on. */
 	u16 view;
+	/* Visible EPT views bitmap for in-guest VMFUNC. */
+	unsigned long allowed_views;
 };
 
 enum ept_pointers_status {
