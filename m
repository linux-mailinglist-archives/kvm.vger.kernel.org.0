Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2237256657B
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 10:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbiGEIyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 04:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGEIyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 04:54:02 -0400
X-Greylist: delayed 967 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 05 Jul 2022 01:53:58 PDT
Received: from baidu.com (mx21.baidu.com [220.181.3.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F12F362CA;
        Tue,  5 Jul 2022 01:53:58 -0700 (PDT)
Received: from BC-Mail-Ex25.internal.baidu.com (unknown [172.31.51.19])
        by Forcepoint Email with ESMTPS id 542B2A4464C6F0B64C9B;
        Tue,  5 Jul 2022 16:37:46 +0800 (CST)
Received: from FB9D8C53FFFC188.internal.baidu.com (172.31.62.15) by
 BC-Mail-Ex25.internal.baidu.com (172.31.51.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Tue, 5 Jul 2022 16:37:47 +0800
From:   Wang Guangju <wangguangju@baidu.com>
To:     <seanjc@google.com>, <pbonzini@redhat.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <wanpengli@tencent.com>, <bp@alien8.de>,
        <joro@8bytes.org>, <suravee.suthikulpanit@amd.com>,
        <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <wangguangju@baidu.com>
Subject: [PATCH] KVM: x86: Add EOI exit bitmap handlers for Hyper-V SynIC vectors
Date:   Tue, 5 Jul 2022 16:37:32 +0800
Message-ID: <20220705083732.168-1-wangguangju@baidu.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.31.62.15]
X-ClientProxiedBy: BJHW-Mail-Ex05.internal.baidu.com (10.127.64.15) To
 BC-Mail-Ex25.internal.baidu.com (172.31.51.19)
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: wangguangju <wangguangju@baidu.com>

Hyper-V SynIC vectors were added into EOI exit bitmap in func
synic_set_sint().But when the Windows VM VMEXIT due to
EXIT_REASON_EOI_INDUCED, there are no EOI exit bitmap handlers
for Hyper-V SynIC vectors.

This patch fix it.

Change-Id: I2404ebf7bda60326be3f6786e0e34e63aa81bbd4
Signed-off-by: wangguangju <wangguangju@baidu.com>
---
 arch/x86/kvm/lapic.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0e68b4c..59096f8 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1303,6 +1303,10 @@ void kvm_apic_set_eoi_accelerated(struct kvm_vcpu *vcpu, int vector)
 
 	trace_kvm_eoi(apic, vector);
 
+	if (to_hv_vcpu(apic->vcpu) &&
+	    test_bit(vector, to_hv_synic(apic->vcpu)->vec_bitmap))
+		kvm_hv_synic_send_eoi(apic->vcpu, vector);
+
 	kvm_ioapic_send_eoi(apic, vector);
 	kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
 }
-- 
2.9.4

