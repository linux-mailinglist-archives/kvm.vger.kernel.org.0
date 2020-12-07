Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFEB2D1AF8
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgLGUrh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:47:37 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42574 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726614AbgLGUrg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:47:36 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id D1C63305D504;
        Mon,  7 Dec 2020 22:46:13 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id AF6683072784;
        Mon,  7 Dec 2020 22:46:13 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 12/81] KVM: svm: add support for descriptor-table VM-exits
Date:   Mon,  7 Dec 2020 22:45:13 +0200
Message-Id: <20201207204622.15258-13-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <nicu.citu@icloud.com>

This function is needed for the KVMI_VCPU_EVENT_DESCRIPTOR event.

Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/svm/svm.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f3ee6bad0db5..00bda794609c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2335,6 +2335,13 @@ static int rsm_interception(struct vcpu_svm *svm)
 	return kvm_emulate_instruction_from_buffer(&svm->vcpu, rsm_ins_bytes, 2);
 }
 
+static int descriptor_access_interception(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+
+	return kvm_emulate_instruction(vcpu, 0);
+}
+
 static int rdpmc_interception(struct vcpu_svm *svm)
 {
 	int err;
@@ -2959,6 +2966,14 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_RSM]                          = rsm_interception,
 	[SVM_EXIT_AVIC_INCOMPLETE_IPI]		= avic_incomplete_ipi_interception,
 	[SVM_EXIT_AVIC_UNACCELERATED_ACCESS]	= avic_unaccelerated_access_interception,
+	[SVM_EXIT_IDTR_READ]			= descriptor_access_interception,
+	[SVM_EXIT_GDTR_READ]			= descriptor_access_interception,
+	[SVM_EXIT_LDTR_READ]			= descriptor_access_interception,
+	[SVM_EXIT_TR_READ]			= descriptor_access_interception,
+	[SVM_EXIT_IDTR_WRITE]			= descriptor_access_interception,
+	[SVM_EXIT_GDTR_WRITE]			= descriptor_access_interception,
+	[SVM_EXIT_LDTR_WRITE]			= descriptor_access_interception,
+	[SVM_EXIT_TR_WRITE]			= descriptor_access_interception,
 };
 
 static void dump_vmcb(struct kvm_vcpu *vcpu)
