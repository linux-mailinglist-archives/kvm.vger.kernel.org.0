Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F9967CFB0
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 16:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232378AbjAZPPy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 10:15:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbjAZPPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 10:15:41 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1E630EAA;
        Thu, 26 Jan 2023 07:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=svQEe0ECCGCg8wgaTJSn7Vk6+ZlADTvcOCMWRjGVrA4=; b=j6AtqAY3qshb8rFaiRpU53+4Fs
        d1J02gGQk0PHmOdIPPOlItYWC5gMKlVfMkNsvOKixr/gcdoRrOyoJIMmURBLFUMjjZxbH9RT+doob
        sWAjknqD0TQTUUqw5WeqAFD55KQsjxLuN3VkSTHmsOJZ27RI89v7gkCfAStu/mucawQ6N7OOReCI6
        eW2CAbQn8KA5quGx7LzF9m3lpgkZOhvOqTTlyh0DjOQGkMZEZAqRA2Rpqfg1X00lhxZaSM53Xwxsj
        ClmO4ylSPEm29DLDWKgKHaKX7Gd0eoQfQKTxnc1k+VQ1wqqiNWA6sWglXic+xTBfzRP1LWPVf5DET
        J0E7VO2A==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pL3xH-002U1d-2R;
        Thu, 26 Jan 2023 15:14:23 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3633E3010ED;
        Thu, 26 Jan 2023 16:14:53 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 10C412084C4A8; Thu, 26 Jan 2023 16:14:53 +0100 (CET)
Message-ID: <20230126151323.466670589@infradead.org>
User-Agent: quilt/0.66
Date:   Thu, 26 Jan 2023 16:08:32 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     mingo@kernel.org
Cc:     will@kernel.org, peterz@infradead.org, boqun.feng@gmail.com,
        mark.rutland@arm.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
        jgross@suse.com, srivatsa@csail.mit.edu, amakhalov@vmware.com,
        pv-drivers@vmware.com, wanpengli@tencent.com, vkuznets@redhat.com,
        boris.ostrovsky@oracle.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, lpieralisi@kernel.org,
        frederic@kernel.org, paulmck@kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, longman@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-pm@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: [PATCH v2 3/9] tracing: Warn about !rcu_is_watching()
References: <20230126150829.087606759@infradead.org>
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

When using noinstr, WARN when tracing hits when RCU is disabled.

Suggested-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/trace_recursion.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/include/linux/trace_recursion.h
+++ b/include/linux/trace_recursion.h
@@ -135,6 +135,21 @@ extern void ftrace_record_recursion(unsi
 # define do_ftrace_record_recursion(ip, pip)	do { } while (0)
 #endif
 
+#ifdef CONFIG_ARCH_WANTS_NO_INSTR
+# define trace_warn_on_no_rcu(ip)					\
+	({								\
+		bool __ret = !rcu_is_watching();			\
+		if (__ret && !trace_recursion_test(TRACE_RECORD_RECURSION_BIT)) { \
+			trace_recursion_set(TRACE_RECORD_RECURSION_BIT); \
+			WARN_ONCE(true, "RCU not on for: %pS\n", (void *)ip); \
+			trace_recursion_clear(TRACE_RECORD_RECURSION_BIT); \
+		}							\
+		__ret;							\
+	})
+#else
+# define trace_warn_on_no_rcu(ip)	false
+#endif
+
 /*
  * Preemption is promised to be disabled when return bit >= 0.
  */
@@ -144,6 +159,9 @@ static __always_inline int trace_test_an
 	unsigned int val = READ_ONCE(current->trace_recursion);
 	int bit;
 
+	if (trace_warn_on_no_rcu(ip))
+		return -1;
+
 	bit = trace_get_context_bit() + start;
 	if (unlikely(val & (1 << bit))) {
 		/*


