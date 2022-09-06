Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6834C5AE04D
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 08:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbiIFGyw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 02:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiIFGyv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 02:54:51 -0400
X-Greylist: delayed 415 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 05 Sep 2022 23:54:49 PDT
Received: from bddwd-sys-mailin02.bddwd.baidu.com (mx417.baidu.com [124.64.200.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2587B10FE8
        for <kvm@vger.kernel.org>; Mon,  5 Sep 2022 23:54:47 -0700 (PDT)
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by bddwd-sys-mailin02.bddwd.baidu.com (Postfix) with ESMTP id AB81FF90005B;
        Tue,  6 Sep 2022 14:47:28 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id A2447D9932;
        Tue,  6 Sep 2022 14:47:28 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH] x86/kvm: align kvm_apic_eoi to cacheline
Date:   Tue,  6 Sep 2022 14:47:28 +0800
Message-Id: <1662446848-55805-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_apic_eoi has higher access frequency, aligning it to
cacheline can give better performance

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kernel/kvm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index d4e48b4..d413478 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -330,7 +330,8 @@ static void kvm_register_steal_time(void)
 		(unsigned long long) slow_virt_to_phys(st));
 }
 
-static DEFINE_PER_CPU_DECRYPTED(unsigned long, kvm_apic_eoi) = KVM_PV_EOI_DISABLED;
+static DEFINE_PER_CPU_DECRYPTED(unsigned long, kvm_apic_eoi) \
+	__aligned(64) = KVM_PV_EOI_DISABLED;
 
 static notrace void kvm_guest_apic_eoi_write(u32 reg, u32 val)
 {
-- 
2.9.4

