Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEB365FA98
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 05:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjAFEOh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 23:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjAFEO3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 23:14:29 -0500
X-Greylist: delayed 482 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 05 Jan 2023 20:14:29 PST
Received: from njjs-sys-mailin01.njjs.baidu.com (mx315.baidu.com [180.101.52.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 20A2E6AD9F
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 20:14:28 -0800 (PST)
Received: from localhost (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id 882EF7F00044;
        Fri,  6 Jan 2023 12:06:25 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     kvm@vger.kernel.org, lirongqing@baidu.com, pbonzini@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, pshier@google.com,
        seanjc@google.com
Subject: [PATCH][resend] KVM: x86: fire timer when it is migrated and expired, and in oneshot mode
Date:   Fri,  6 Jan 2023 12:06:25 +0800
Message-Id: <20230106040625.8404-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.9.4
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

when the vCPU was migrated, if its timer is expired, KVM _should_ fire
the timer ASAP, zeroing the deadline here will cause the timer to
immediately fire on the destination

Cc: Sean Christopherson <seanjc@google.com>
Cc: Peter Shier <pshier@google.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kvm/lapic.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 4efdb4a4..13f8ab3 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1841,8 +1841,12 @@ static bool set_target_expiration(struct kvm_lapic *apic, u32 count_reg)
 		if (unlikely(count_reg != APIC_TMICT)) {
 			deadline = tmict_to_ns(apic,
 				     kvm_lapic_get_reg(apic, count_reg));
-			if (unlikely(deadline <= 0))
-				deadline = apic->lapic_timer.period;
+			if (unlikely(deadline <= 0)) {
+				if (apic_lvtt_period(apic))
+					deadline = apic->lapic_timer.period;
+				else
+					deadline = 0;
+			}
 			else if (unlikely(deadline > apic->lapic_timer.period)) {
 				pr_info_ratelimited(
 				    "kvm: vcpu %i: requested lapic timer restore with "
-- 
2.9.4

