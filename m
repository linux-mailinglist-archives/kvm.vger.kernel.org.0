Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD2D556A1F1
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 14:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbiGGM3Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 08:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233004AbiGGM3O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 08:29:14 -0400
Received: from baidu.com (mx21.baidu.com [220.181.3.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F29A818E21;
        Thu,  7 Jul 2022 05:29:11 -0700 (PDT)
Received: from BC-Mail-Ex25.internal.baidu.com (unknown [172.31.51.19])
        by Forcepoint Email with ESMTPS id 81DFD37407DA3D817B73;
        Thu,  7 Jul 2022 20:29:06 +0800 (CST)
Received: from FB9D8C53FFFC188.internal.baidu.com (172.31.62.12) by
 BC-Mail-Ex25.internal.baidu.com (172.31.51.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Thu, 7 Jul 2022 20:29:07 +0800
From:   Wang Guangju <wangguangju@baidu.com>
To:     <seanjc@google.com>, <pbonzini@redhat.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <wanpengli@tencent.com>, <bp@alien8.de>,
        <joro@8bytes.org>, <suravee.suthikulpanit@amd.com>,
        <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <wangguangju@baidu.com>,
        chukaiping <chukaiping@baidu.com>
Subject: [PATCH] KVM: x86: Add EOI_INDUCED exit handlers for Hyper-V SynIC vectors
Date:   Thu, 7 Jul 2022 20:28:54 +0800
Message-ID: <20220707122854.87-1-wangguangju@baidu.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.31.62.12]
X-ClientProxiedBy: BJHW-Mail-Ex12.internal.baidu.com (10.127.64.35) To
 BC-Mail-Ex25.internal.baidu.com (172.31.51.19)
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: chukaiping <chukaiping@baidu.com>

When EOI virtualization is performed on VMX,
kvm_apic_set_eoi_accelerated() is called upon
EXIT_REASON_EOI_INDUCED but unlike its non-accelerated
apic_set_eoi() sibling, Hyper-V SINT vectors are
left unhandled.

This patch fix it, and add a new helper function to
handle both IOAPIC and Hyper-V SINT vectors.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: wangguangju <wangguangju@baidu.com>
---
 arch/x86/kvm/lapic.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index f03facc..e046afe 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1269,6 +1269,16 @@ static void kvm_ioapic_send_eoi(struct kvm_lapic *apic, int vector)
 	kvm_ioapic_update_eoi(apic->vcpu, vector, trigger_mode);
 }
 
+static inline void apic_set_eoi_vector(struct kvm_lapic *apic, int vector)
+{
+	if (to_hv_vcpu(apic->vcpu) &&
+	    test_bit(vector, to_hv_synic(apic->vcpu)->vec_bitmap))
+		kvm_hv_synic_send_eoi(apic->vcpu, vector);
+
+	kvm_ioapic_send_eoi(apic, vector);
+	kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
+}
+
 static int apic_set_eoi(struct kvm_lapic *apic)
 {
 	int vector = apic_find_highest_isr(apic);
@@ -1285,12 +1295,8 @@ static int apic_set_eoi(struct kvm_lapic *apic)
 	apic_clear_isr(vector, apic);
 	apic_update_ppr(apic);
 
-	if (to_hv_vcpu(apic->vcpu) &&
-	    test_bit(vector, to_hv_synic(apic->vcpu)->vec_bitmap))
-		kvm_hv_synic_send_eoi(apic->vcpu, vector);
+	apic_set_eoi_vector(apic, vector);
 
-	kvm_ioapic_send_eoi(apic, vector);
-	kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
 	return vector;
 }
 
@@ -1304,8 +1310,7 @@ void kvm_apic_set_eoi_accelerated(struct kvm_vcpu *vcpu, int vector)
 
 	trace_kvm_eoi(apic, vector);
 
-	kvm_ioapic_send_eoi(apic, vector);
-	kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
+	apic_set_eoi_vector(apic, vector);
 }
 EXPORT_SYMBOL_GPL(kvm_apic_set_eoi_accelerated);
 
-- 
2.9.4

