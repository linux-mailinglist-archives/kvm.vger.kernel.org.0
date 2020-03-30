Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD14119792C
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729650AbgC3KWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:22:01 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43784 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729303AbgC3KTz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:19:55 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id CF17C30747CD;
        Mon, 30 Mar 2020 13:12:50 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id A0B17305B7A2;
        Mon, 30 Mar 2020 13:12:50 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 14/81] KVM: svm: add support for descriptor-table exits
Date:   Mon, 30 Mar 2020 13:12:01 +0300
Message-Id: <20200330101308.21702-15-alazar@bitdefender.com>
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

This function is needed for the KVMI_EVENT_DESCRIPTOR event.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/svm.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f9185f0b0c2b..fd21439475b5 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4792,6 +4792,13 @@ static int avic_unaccelerated_access_interception(struct vcpu_svm *svm)
 	return ret;
 }
 
+static int descriptor_access_interception(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+
+	return kvm_emulate_instruction(vcpu, 0);
+}
+
 static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_READ_CR0]			= cr_interception,
 	[SVM_EXIT_READ_CR3]			= cr_interception,
@@ -4858,6 +4865,14 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
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
