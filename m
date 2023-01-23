Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4926788F9
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 21:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbjAWU7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 15:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbjAWU6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 15:58:47 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A2834C29;
        Mon, 23 Jan 2023 12:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=DwNtSkSaGTU0TFqzb2/WMPSb8JYwGKCIYZsmeR/P6pc=; b=FueaaZb7VWO4atG18KkGUgcSzQ
        FI5cJ88LeuzKk95B4T/ujA5RntI3Q5IOg661T+Nx6Jg1ofr+WaQ3jBAlstIFsm10tCM3ugdjreIdw
        jekc2aQYG/Zbaa+emGpeAz4Lv6QTZxYV0c5nx4gqJLGh7FKawVx+Ru+OgUlQzQ74ginyYEH3WP7dw
        5txleE63/CC3gyBWdpXXfg+uTfS6QliMubretWIhRomQhaeRWZ4/+Y6MJMCwfLlvq3DfaoQCRPIFH
        +KxmdhhfRE4vj/Ol3tLiIZOlGF2SQI84vVc0Rt8I4gS0JE1bOVgjV0eJCIaInsyf0I1LAQCcZ89zG
        l5gK1P0g==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pK3sB-001dto-1f;
        Mon, 23 Jan 2023 20:57:02 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 6AB39300BCB;
        Mon, 23 Jan 2023 21:57:27 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id D952B2075A6F8; Mon, 23 Jan 2023 21:57:24 +0100 (CET)
Message-ID: <20230123205515.233366796@infradead.org>
User-Agent: quilt/0.66
Date:   Mon, 23 Jan 2023 21:50:15 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     mingo@kernel.org
Cc:     will@kernel.org, peterz@infradead.org, boqun.feng@gmail.com,
        mark.rutland@arm.com, tglx@linutronix.de, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, jgross@suse.com,
        srivatsa@csail.mit.edu, amakhalov@vmware.com,
        pv-drivers@vmware.com, rostedt@goodmis.org, mhiramat@kernel.org,
        wanpengli@tencent.com, vkuznets@redhat.com,
        boris.ostrovsky@oracle.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        kernel test robot <oliver.sang@intel.com>
Subject: [PATCH 6/6] cpuidle: Fix poll_idle() noinstr annotation
References: <20230123205009.790550642@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The instrumentation_begin()/end() annotations in poll_idle() were
complete nonsense. Specifically they caused tracing to happen in the
middle of noinstr code, resulting in RCU splats.

Now that local_clock() is noinstr, mark up the rest and let it rip.

Fixes: 00717eb8c955 ("cpuidle: Annotate poll_idle()")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reported-by: kernel test robot <oliver.sang@intel.com>
Link: https://lore.kernel.org/oe-lkp/202301192148.58ece903-oliver.sang@intel.com
---
 drivers/cpuidle/cpuidle.c    |    2 +-
 drivers/cpuidle/poll_state.c |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -426,7 +426,7 @@ void cpuidle_reflect(struct cpuidle_devi
  * @dev:   the cpuidle device
  *
  */
-u64 cpuidle_poll_time(struct cpuidle_driver *drv,
+__cpuidle u64 cpuidle_poll_time(struct cpuidle_driver *drv,
 		      struct cpuidle_device *dev)
 {
 	int i;
--- a/drivers/cpuidle/poll_state.c
+++ b/drivers/cpuidle/poll_state.c
@@ -15,7 +15,6 @@ static int __cpuidle poll_idle(struct cp
 {
 	u64 time_start;
 
-	instrumentation_begin();
 	time_start = local_clock();
 
 	dev->poll_time_limit = false;
@@ -42,7 +41,6 @@ static int __cpuidle poll_idle(struct cp
 	raw_local_irq_disable();
 
 	current_clr_polling();
-	instrumentation_end();
 
 	return index;
 }


