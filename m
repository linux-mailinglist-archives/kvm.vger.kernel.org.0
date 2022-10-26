Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8DB960DC06
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 09:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbiJZHWZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 03:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiJZHWX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 03:22:23 -0400
Received: from mx405.baidu.com (mx408.baidu.com [124.64.200.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 52E3E5A887
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 00:22:20 -0700 (PDT)
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by mx405.baidu.com (Postfix) with ESMTP id 7535F1C100091;
        Wed, 26 Oct 2022 15:22:19 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id 6ECCBD9932;
        Wed, 26 Oct 2022 15:22:19 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pshier@google.com,
        jmattson@google.com, wanpengli@tencent.com, pbonzini@redhat.com
Subject: [PATCH] KVM: x86: fire timer when it is migrated and expired, and in oneshot mode
Date:   Wed, 26 Oct 2022 15:22:19 +0800
Message-Id: <20221026072219.47597-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.9.4
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index d7639d1..5c74a0f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1840,8 +1840,12 @@ static bool set_target_expiration(struct kvm_lapic *apic, u32 count_reg)
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

