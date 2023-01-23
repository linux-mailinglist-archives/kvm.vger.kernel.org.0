Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4296788EC
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 21:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbjAWU6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 15:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbjAWU6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 15:58:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA403802B;
        Mon, 23 Jan 2023 12:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=bIfFAXl3Gv4EnKDtIDltBqYZ3txjVL6G+NhMkZyfGI4=; b=gnYqMu4PNJySVrCjnkQZIgqD33
        wQXB/rRboPQU3LRLINoxnUhxHyuyRecqTgiKPD7HJmGt1ujJzhYLpFgeknPGh83xjZgsPFTRxusSP
        6FrdKCC3GQlR3CMbnpwqtGVsjcmD/Ej0w7wbfIM3vLWi6cNVejzdRqOExLrFK1rAnGCpRPlxr5+Oc
        wDq1C+RIa8zZ3MBxAWZBdlLHGxcQGyE/awpvRp1BLNR+dLrA+45FqNKyNNuglm+LzlsIk4VYNAJ/q
        P97sHNR5ecVeHuLhJ2L/MEZt49xD/FKILOzWA0ABELctEl+d01ONaULWBfayuntvr+R+X1nyG1EMb
        5ooM8zaA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pK3se-004WTw-59; Mon, 23 Jan 2023 20:57:28 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 64BDE300747;
        Mon, 23 Jan 2023 21:57:24 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id C96002075A6F7; Mon, 23 Jan 2023 21:57:24 +0100 (CET)
Message-ID: <20230123205515.059999893@infradead.org>
User-Agent: quilt/0.66
Date:   Mon, 23 Jan 2023 21:50:12 +0100
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
        linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH 3/6] ftrace/x86: Warn and ignore graph tracing when RCU is disabled
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

All RCU disabled code should be noinstr and hence we should never get
here -- when we do, WARN about it and make sure to not actually do
tracing.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/kernel/ftrace.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -646,6 +646,9 @@ void prepare_ftrace_return(unsigned long
 	if (unlikely(atomic_read(&current->tracing_graph_pause)))
 		return;
 
+	if (WARN_ONCE(!rcu_is_watching(), "RCU not on for: %pS\n", (void *)ip))
+		return;
+
 	bit = ftrace_test_recursion_trylock(ip, *parent);
 	if (bit < 0)
 		return;


