Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35C0F52CEE6
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 11:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235773AbiESJDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 05:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbiESJDA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 05:03:00 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37936A5ABF;
        Thu, 19 May 2022 02:02:56 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1652950974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rGB9iQQcUTGQsdYgD2JHwGYlEDy8xN3OzEgy7BBIBMU=;
        b=gYwseLMv+xWD91tlwq/rg0UlNRd1k8V8K5DhwvE2XQ5TzRksLGHZRsvQvlj4jEUOIj1U5q
        dhplF39VE/mG+FhpGW9dXvLPddh66A9p5hjPRHVmx2U4b0JlYPi7guGNl+26blOyCeXqfU
        rJt8Bu8HBCRiH3JnNO11rwmv86gIE+c=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH] KVM: x86: Move kzalloc out of atomic context on PREEMPT_RT
Date:   Thu, 19 May 2022 17:02:18 +0800
Message-Id: <20220519090218.2230653-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The memory allocator is fully preemptible and therefore cannot
be invoked from truly atomic contexts.

See Documentation/locking/locktypes.rst (line: 470)

Add raw_spin_unlock() before memory allocation and raw_spin_lock()
after it.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 arch/x86/kernel/kvm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index d0bb2b3fb305..8f8ec9bbd847 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -205,7 +205,9 @@ void kvm_async_pf_task_wake(u32 token)
 		 * async PF was not yet handled.
 		 * Add dummy entry for the token.
 		 */
-		n = kzalloc(sizeof(*n), GFP_ATOMIC);
+		raw_spin_unlock(&b->lock);
+		n = kzalloc(sizeof(*n), GFP_KERNEL);
+		raw_spin_lock(&b->lock);
 		if (!n) {
 			/*
 			 * Allocation failed! Busy wait while other cpu
-- 
2.25.1

