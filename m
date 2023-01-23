Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35FEF678A59
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 23:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbjAWWI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 17:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232151AbjAWWI4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 17:08:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8441D3526C;
        Mon, 23 Jan 2023 14:08:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 254C2B80EAB;
        Mon, 23 Jan 2023 22:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA9BC433D2;
        Mon, 23 Jan 2023 22:07:55 +0000 (UTC)
Date:   Mon, 23 Jan 2023 17:07:53 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     mingo@kernel.org, will@kernel.org, boqun.feng@gmail.com,
        mark.rutland@arm.com, tglx@linutronix.de, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, jgross@suse.com,
        srivatsa@csail.mit.edu, amakhalov@vmware.com,
        pv-drivers@vmware.com, mhiramat@kernel.org, wanpengli@tencent.com,
        vkuznets@redhat.com, boris.ostrovsky@oracle.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 3/6] ftrace/x86: Warn and ignore graph tracing when RCU
 is disabled
Message-ID: <20230123170753.7ac9419e@gandalf.local.home>
In-Reply-To: <20230123165304.370121e7@gandalf.local.home>
References: <20230123205009.790550642@infradead.org>
        <20230123205515.059999893@infradead.org>
        <20230123165304.370121e7@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 23 Jan 2023 16:53:04 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 23 Jan 2023 21:50:12 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > All RCU disabled code should be noinstr and hence we should never get
> > here -- when we do, WARN about it and make sure to not actually do
> > tracing.
> > 
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> >  arch/x86/kernel/ftrace.c |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > --- a/arch/x86/kernel/ftrace.c
> > +++ b/arch/x86/kernel/ftrace.c
> > @@ -646,6 +646,9 @@ void prepare_ftrace_return(unsigned long
> >  	if (unlikely(atomic_read(&current->tracing_graph_pause)))
> >  		return;
> >  
> > +	if (WARN_ONCE(!rcu_is_watching(), "RCU not on for: %pS\n", (void *)ip))
> > +		return;
> > +  
> 
> Please add this to after recursion trylock below. Although WARN_ONCE()
> should not not have recursion issues, as function tracing can do weird
> things, I rather be safe than sorry, and not have the system triple boot
> due to some path that might get added in the future.
> 
> If rcu_is_watching() is false, it will still get by the below recursion
> check and warn. That is, the below check should be done before this
> function calls any other function.
> 
> >  	bit = ftrace_test_recursion_trylock(ip, *parent);
> >  	if (bit < 0)
> >  		return;
> >   
> 

Actually, perhaps we can just add this, and all you need to do is create
and set CONFIG_NO_RCU_TRACING (or some other name).

This should cover all ftrace locations. (Uncompiled).

-- Steve

diff --git a/include/linux/trace_recursion.h b/include/linux/trace_recursion.h
index c303f7a114e9..10ee3fbb9113 100644
--- a/include/linux/trace_recursion.h
+++ b/include/linux/trace_recursion.h
@@ -135,6 +135,22 @@ extern void ftrace_record_recursion(unsigned long ip, unsigned long parent_ip);
 # define do_ftrace_record_recursion(ip, pip)	do { } while (0)
 #endif
 
+#ifdef CONFIG_NO_RCU_TRACING
+# define trace_warn_on_no_rcu(ip)					\
+	({								\
+		bool __ret = false;					\
+		if (!trace_recursion_test(TRACE_RECORD_RECURSION_BIT)) { \
+			trace_recursion_set(TRACE_RECORD_RECURSION_BIT); \
+			__ret = WARN_ONCE(!rcu_is_watching(),		\
+					  "RCU not on for: %pS\n", (void *)ip); \
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
@@ -144,6 +160,9 @@ static __always_inline int trace_test_and_set_recursion(unsigned long ip, unsign
 	unsigned int val = READ_ONCE(current->trace_recursion);
 	int bit;
 
+	if (trace_warn_on_no_rcu(ip))
+		return -1;
+
 	bit = trace_get_context_bit() + start;
 	if (unlikely(val & (1 << bit))) {
 		/*
