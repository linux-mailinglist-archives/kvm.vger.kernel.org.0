Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69DD5A2099
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 07:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbiHZF7j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 01:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiHZF7j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 01:59:39 -0400
X-Greylist: delayed 938 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 25 Aug 2022 22:59:37 PDT
Received: from bddwd-sys-mailin01.bddwd.baidu.com (mx414.baidu.com [124.64.201.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BF52DD11CD
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 22:59:37 -0700 (PDT)
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by bddwd-sys-mailin01.bddwd.baidu.com (Postfix) with ESMTP id 8E04F11980036;
        Fri, 26 Aug 2022 13:43:23 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id 842B0D9932;
        Fri, 26 Aug 2022 13:43:23 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: SVM: move dest calculation out of loop
Date:   Fri, 26 Aug 2022 13:43:23 +0800
Message-Id: <1661492603-52093-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no need to calculate dest in each vcpu iteration
since dest is not change

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kvm/svm/avic.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 6919dee..087c073 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -451,6 +451,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 				   u32 icrl, u32 icrh, u32 index)
 {
+	u32 dest;
 	unsigned long i;
 	struct kvm_vcpu *vcpu;
 
@@ -465,13 +466,13 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 	 * vCPUs that were in guest at the time of the IPI, and vCPUs that have
 	 * since entered the guest will have processed pending IRQs at VMRUN.
 	 */
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		u32 dest;
 
-		if (apic_x2apic_mode(vcpu->arch.apic))
-			dest = icrh;
-		else
-			dest = GET_XAPIC_DEST_FIELD(icrh);
+	if (apic_x2apic_mode(vcpu->arch.apic))
+		dest = icrh;
+	else
+		dest = GET_XAPIC_DEST_FIELD(icrh);
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
 
 		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
 					dest, icrl & APIC_DEST_MASK)) {
-- 
2.9.4

