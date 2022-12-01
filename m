Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6E063E72D
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 02:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiLABmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 20:42:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiLABmq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 20:42:46 -0500
Received: from cmccmta1.chinamobile.com (cmccmta1.chinamobile.com [221.176.66.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 00B86192A0;
        Wed, 30 Nov 2022 17:42:43 -0800 (PST)
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from spf.mail.chinamobile.com (unknown[172.16.121.13])
        by rmmx-syy-dmz-app02-12002 (RichMail) with SMTP id 2ee26388069142d-76770;
        Thu, 01 Dec 2022 09:42:42 +0800 (CST)
X-RM-TRANSID: 2ee26388069142d-76770
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.108.79.98])
        by rmsmtp-syy-appsvr07-12007 (RichMail) with SMTP id 2ee76388068d3dd-2d5be;
        Thu, 01 Dec 2022 09:42:41 +0800 (CST)
X-RM-TRANSID: 2ee76388068d3dd-2d5be
From:   liujing <liujing@cmss.chinamobile.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liujing <liujing@cmss.chinamobile.com>
Subject: [PATCH] KVM: x86: Optimize your code to avoid unnecessary calls
Date:   Wed, 30 Nov 2022 20:42:37 -0500
Message-Id: <20221201014237.5764-1-liujing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.18.2
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the kvm_vm_ioctl_get_irqchip function, we can removethe 
definition of the r variable instead of return 0 in the end.
In the kvm_vm_ioctl_set_irqchip function, also use return 0 instead,
return -EINVAL to avoid calling kvm_pic_update_irq again.

Signed-off-by: liujing <liujing@cmss.chinamobile.com>
---
 arch/x86/kvm/x86.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2835bd796639..8e94f3d730ee 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6002,9 +6002,7 @@ static unsigned long kvm_vm_ioctl_get_nr_mmu_pages(struct kvm *kvm)
 static int kvm_vm_ioctl_get_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
 {
 	struct kvm_pic *pic = kvm->arch.vpic;
-	int r;
 
-	r = 0;
 	switch (chip->chip_id) {
 	case KVM_IRQCHIP_PIC_MASTER:
 		memcpy(&chip->chip.pic, &pic->pics[0],
@@ -6018,18 +6016,15 @@ static int kvm_vm_ioctl_get_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
 		kvm_get_ioapic(kvm, &chip->chip.ioapic);
 		break;
 	default:
-		r = -EINVAL;
-		break;
+		return -EINVAL;
 	}
-	return r;
+	return 0;
 }
 
 static int kvm_vm_ioctl_set_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
 {
 	struct kvm_pic *pic = kvm->arch.vpic;
-	int r;
-
-	r = 0;	
 	switch (chip->chip_id) {
 	case KVM_IRQCHIP_PIC_MASTER:
 		spin_lock(&pic->lock);
@@ -6047,11 +6042,10 @@ static int kvm_vm_ioctl_set_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
 		kvm_set_ioapic(kvm, &chip->chip.ioapic);
 		break;
 	default:
-		r = -EINVAL;
-		break;
+		return -EINVAL;
 	}
 	kvm_pic_update_irq(pic);
-	return r;
+	return 0;
 }
 
 static int kvm_vm_ioctl_get_pit(struct kvm *kvm, struct kvm_pit_state *ps)
-- 
2.18.2



