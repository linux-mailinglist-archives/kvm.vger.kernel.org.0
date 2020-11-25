Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9846B2C3C98
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgKYJmM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:12 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57224 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728588AbgKYJmI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:42:08 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 4EA3A305D501;
        Wed, 25 Nov 2020 11:35:45 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 2F2AB3072785;
        Wed, 25 Nov 2020 11:35:45 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 15/81] KVM: x86: add kvm_x86_ops.msr_write_intercepted()
Date:   Wed, 25 Nov 2020 11:34:54 +0200
Message-Id: <20201125093600.2766-16-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
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
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm/svm.c          | 1 +
 arch/x86/kvm/vmx/vmx.c          | 1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0e9144e23ce6..5236008d231f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1112,6 +1112,7 @@ struct kvm_x86_ops {
 	void (*update_exception_bitmap)(struct kvm_vcpu *vcpu);
 	int (*get_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
+	bool (*msr_write_intercepted)(struct kvm_vcpu *vcpu, u32 msr);
 	u64 (*get_segment_base)(struct kvm_vcpu *vcpu, int seg);
 	void (*get_segment)(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 86f0dcf9fecd..4478942f10a5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4304,6 +4304,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.get_msr_feature = svm_get_msr_feature,
 	.get_msr = svm_get_msr,
 	.set_msr = svm_set_msr,
+	.msr_write_intercepted = msr_write_intercepted,
 	.get_segment_base = svm_get_segment_base,
 	.get_segment = svm_get_segment,
 	.set_segment = svm_set_segment,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5bd6a4add27e..d4833d3bf966 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7658,6 +7658,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.get_msr_feature = vmx_get_msr_feature,
 	.get_msr = vmx_get_msr,
 	.set_msr = vmx_set_msr,
+	.msr_write_intercepted = msr_write_intercepted,
 	.get_segment_base = vmx_get_segment_base,
 	.get_segment = vmx_get_segment,
 	.set_segment = vmx_set_segment,
