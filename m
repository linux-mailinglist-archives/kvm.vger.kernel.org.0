Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2748951D010
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 06:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388941AbiEFEZZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 00:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388928AbiEFEZX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 00:25:23 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8AA605E759;
        Thu,  5 May 2022 21:21:40 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id CDC6A1E80CF6;
        Fri,  6 May 2022 12:16:59 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id JCRLcAwG6jDT; Fri,  6 May 2022 12:16:57 +0800 (CST)
Received: from localhost.localdomain (unknown [111.193.128.65])
        (Authenticated sender: kunyu@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 11A4C1E80C9B;
        Fri,  6 May 2022 12:16:57 +0800 (CST)
From:   Li kunyu <kunyu@nfschina.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li kunyu <kunyu@nfschina.com>
Subject: [PATCH] x86: The return type of the function could be void
Date:   Fri,  6 May 2022 12:21:05 +0800
Message-Id: <20220506042105.6245-1-kunyu@nfschina.com>
X-Mailer: git-send-email 2.18.2
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Perhaps the return value of the function is not used.
It may be possible to optimize the execution instructions.

Signed-off-by: Li kunyu <kunyu@nfschina.com>
---
 arch/x86/kvm/hyperv.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 46f9dfb60469..64c0d1f54258 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -608,7 +608,7 @@ static enum hrtimer_restart stimer_timer_callback(struct hrtimer *timer)
  * a) stimer->count is not equal to 0
  * b) stimer->config has HV_STIMER_ENABLE flag
  */
-static int stimer_start(struct kvm_vcpu_hv_stimer *stimer)
+static void stimer_start(struct kvm_vcpu_hv_stimer *stimer)
 {
 	u64 time_now;
 	ktime_t ktime_now;
@@ -638,7 +638,7 @@ static int stimer_start(struct kvm_vcpu_hv_stimer *stimer)
 			      ktime_add_ns(ktime_now,
 					   100 * (stimer->exp_time - time_now)),
 			      HRTIMER_MODE_ABS);
-		return 0;
+		return;
 	}
 	stimer->exp_time = stimer->count;
 	if (time_now >= stimer->count) {
@@ -649,7 +649,7 @@ static int stimer_start(struct kvm_vcpu_hv_stimer *stimer)
 		 * the past, it will expire immediately."
 		 */
 		stimer_mark_pending(stimer, false);
-		return 0;
+		return;
 	}
 
 	trace_kvm_hv_stimer_start_one_shot(hv_stimer_to_vcpu(stimer)->vcpu_id,
@@ -659,7 +659,6 @@ static int stimer_start(struct kvm_vcpu_hv_stimer *stimer)
 	hrtimer_start(&stimer->timer,
 		      ktime_add_ns(ktime_now, 100 * (stimer->count - time_now)),
 		      HRTIMER_MODE_ABS);
-	return 0;
 }
 
 static int stimer_set_config(struct kvm_vcpu_hv_stimer *stimer, u64 config,
-- 
2.18.2

