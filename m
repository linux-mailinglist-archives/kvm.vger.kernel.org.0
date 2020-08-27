Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6834B254013
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 10:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgH0IBh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 04:01:37 -0400
Received: from mx55.baidu.com ([61.135.168.55]:10274 "EHLO
        tc-sys-mailedm01.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726851AbgH0IBg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Aug 2020 04:01:36 -0400
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Aug 2020 04:01:35 EDT
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm01.tc.baidu.com (Postfix) with ESMTP id 478D8204005A;
        Thu, 27 Aug 2020 15:54:49 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     kvm@vger.kernel.org, x86@kernel.org
Subject: [PATCH] KVM: x86: refine delivery_mode check
Date:   Thu, 27 Aug 2020 15:54:49 +0800
Message-Id: <1598514889-23810-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

delivery_mode of kvm_ioapic_redirect_entry, is 3 bits width
value, should be shifted 8bits when check with APIC_DM_FIXED
whose value bits are from bit 8 to bit 10. although it works
because APIC_DM_FIXED is zero

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kvm/ioapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index d057376bd3d3..43e23b0003d6 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -375,7 +375,7 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 		if (e->fields.trig_mode == IOAPIC_LEVEL_TRIG
 		    && ioapic->irr & (1 << index))
 			ioapic_service(ioapic, index, false);
-		if (e->fields.delivery_mode == APIC_DM_FIXED) {
+		if ((e->fields.delivery_mode << 8) == APIC_DM_FIXED) {
 			struct kvm_lapic_irq irq;
 
 			irq.vector = e->fields.vector;
-- 
2.16.2

