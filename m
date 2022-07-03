Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B6C5682C1
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 11:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbiGFJEF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 05:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiGFJEE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 05:04:04 -0400
Received: from unicom146.biz-email.net (unicom146.biz-email.net [210.51.26.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD6FE24;
        Wed,  6 Jul 2022 02:04:02 -0700 (PDT)
Received: from ([60.208.111.195])
        by unicom146.biz-email.net ((D)) with ASMTP (SSL) id BIK00057;
        Wed, 06 Jul 2022 17:03:57 +0800
Received: from localhost.localdomain (10.200.104.82) by
 jtjnmail201611.home.langchao.com (10.100.2.11) with Microsoft SMTP Server id
 15.1.2507.9; Wed, 6 Jul 2022 17:03:58 +0800
From:   Deming Wang <wangdeming@inspur.com>
To:     <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
        <x86@kernel.org>
CC:     <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Deming Wang <wangdeming@inspur.com>
Subject: [PATCH] KVM: LAPIC: Separate the variable declaration and code logic
Date:   Sun, 3 Jul 2022 00:54:10 -0400
Message-ID: <20220703045410.9159-1-wangdeming@inspur.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.200.104.82]
tUid:   2022706170357e98e00458c131b46b68ac306b16c623e
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The function apic_has_interrupt_for_ppr and the function
kvm_apic_is_broadcast_dest should follow the same style as other codes.

Signed-off-by: Deming Wang <wangdeming@inspur.com>
---
 arch/x86/kvm/lapic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index f03facc2ee3e..d8940486878d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -739,12 +739,14 @@ static bool pv_eoi_test_and_clr_pending(struct kvm_vcpu *vcpu)
 static int apic_has_interrupt_for_ppr(struct kvm_lapic *apic, u32 ppr)
 {
 	int highest_irr;
+
 	if (kvm_x86_ops.sync_pir_to_irr)
 		highest_irr = static_call(kvm_x86_sync_pir_to_irr)(apic->vcpu);
 	else
 		highest_irr = apic_find_highest_irr(apic);
 	if (highest_irr == -1 || (highest_irr & 0xF0) <= ppr)
 		return -1;
+
 	return highest_irr;
 }
 
@@ -932,6 +934,7 @@ static bool kvm_apic_is_broadcast_dest(struct kvm *kvm, struct kvm_lapic **src,
 			return true;
 	} else {
 		bool x2apic_ipi = src && *src && apic_x2apic_mode(*src);
+
 		if (irq->dest_id == (x2apic_ipi ?
 		                     X2APIC_BROADCAST : APIC_BROADCAST))
 			return true;
-- 
2.27.0

