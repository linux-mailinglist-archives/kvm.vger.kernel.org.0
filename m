Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 083F719D246
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 10:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390442AbgDCIbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 04:31:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54928 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389781AbgDCIbl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 04:31:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0338OGmp055614;
        Fri, 3 Apr 2020 08:30:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+eYpj3cHN7M9X5gjvpZpB28S2rfw41z8Hx4eWOPQmqc=;
 b=obY0/wpIduQrTs47sSo/eluXnEofW8KcMUwyYVc+JNZ8h06vI2YAxjQZDANz0qjW4Jzm
 tg3w+rvrKG8Fx5Y0nYfSe4eODjuWrQ5ZBKzaMCrl+YlVL17II4mgc1sFxd7cTNE/TabD
 2fDQd4ggtzsk75a0JDt4+MgVBJrbT4hiAINiRiP7b+UIhdddZKtu12RRhh2j/xHOuuGA
 j3eUizifKl16HobLqjbscQPvS/mBQYS2rvHPasb0SK3XSGQn3HuaMLDLjpeOuIFndNhK
 l0Wp1fcBSs/2q9f5YGroyPougj4toKBsXLESH1HNn892AcnrVkT6luDxZU/dp33g7LFT Yg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 303yunj9k3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 08:30:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0338MNp8180292;
        Fri, 3 Apr 2020 08:30:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 302g4x1xj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 08:30:43 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0338UeKT004493;
        Fri, 3 Apr 2020 08:30:40 GMT
Received: from linux-1.home (/92.157.90.160)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 01:30:39 -0700
Subject: Re: [RESEND][patch V3 05/23] tracing: Provide lockdep less
 trace_hardirqs_on/off() variants
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Paul McKenney <paulmck@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Brian Gerst <brgerst@gmail.com>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20200320175956.033706968@linutronix.de>
 <20200320180032.895128936@linutronix.de>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Message-ID: <322ac9e0-9567-8e7c-e2af-e9e1107717bf@oracle.com>
Date:   Fri, 3 Apr 2020 10:34:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200320180032.895128936@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030071
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=0 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030071
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/20/20 7:00 PM, Thomas Gleixner wrote:
> trace_hardirqs_on/off() is only partially safe vs. RCU idle. The tracer
> core itself is safe, but the resulting tracepoints can be utilized by
> e.g. BPF which is unsafe.
> 
> Provide variants which do not contain the lockdep invocation so the lockdep
> and tracer invocations can be split at the call site and placed properly.
> 
> The new variants also do not use rcuidle as they are going to be called
> from entry code after/before context tracking.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
> V2: New patch
> ---
>   include/linux/irqflags.h        |    4 ++++
>   kernel/trace/trace_preemptirq.c |   23 +++++++++++++++++++++++
>   2 files changed, 27 insertions(+)
> 
> --- a/include/linux/irqflags.h
> +++ b/include/linux/irqflags.h
> @@ -29,6 +29,8 @@
>   #endif
>   
>   #ifdef CONFIG_TRACE_IRQFLAGS
> +  extern void __trace_hardirqs_on(void);
> +  extern void __trace_hardirqs_off(void);
>     extern void trace_hardirqs_on(void);
>     extern void trace_hardirqs_off(void);
>   # define trace_hardirq_context(p)	((p)->hardirq_context)
> @@ -52,6 +54,8 @@ do {						\
>   	current->softirq_context--;		\
>   } while (0)
>   #else
> +# define __trace_hardirqs_on()		do { } while (0)
> +# define __trace_hardirqs_off()		do { } while (0)
>   # define trace_hardirqs_on()		do { } while (0)
>   # define trace_hardirqs_off()		do { } while (0)
>   # define trace_hardirq_context(p)	0
> --- a/kernel/trace/trace_preemptirq.c
> +++ b/kernel/trace/trace_preemptirq.c
> @@ -19,6 +19,17 @@
>   /* Per-cpu variable to prevent redundant calls when IRQs already off */
>   static DEFINE_PER_CPU(int, tracing_irq_cpu);
>   
> +void __trace_hardirqs_on(void)
> +{
> +	if (this_cpu_read(tracing_irq_cpu)) {
> +		if (!in_nmi())
> +			trace_irq_enable(CALLER_ADDR0, CALLER_ADDR1);
> +		tracer_hardirqs_on(CALLER_ADDR0, CALLER_ADDR1);
> +		this_cpu_write(tracing_irq_cpu, 0);
> +	}
> +}
> +NOKPROBE_SYMBOL(__trace_hardirqs_on);
> +

It would be good to have a comment which highlights the difference between
__trace_hardirqs_on/off and trace_hardirqs_on/off because the code difference
is not obvious and the function names are so similar.

alex.

>   void trace_hardirqs_on(void)
>   {
>   	if (this_cpu_read(tracing_irq_cpu)) {
> @@ -33,6 +44,18 @@ void trace_hardirqs_on(void)
>   EXPORT_SYMBOL(trace_hardirqs_on);
>   NOKPROBE_SYMBOL(trace_hardirqs_on);
>   
> +void __trace_hardirqs_off(void)
> +{
> +	if (!this_cpu_read(tracing_irq_cpu)) {
> +		this_cpu_write(tracing_irq_cpu, 1);
> +		tracer_hardirqs_off(CALLER_ADDR0, CALLER_ADDR1);
> +		if (!in_nmi())
> +			trace_irq_disable(CALLER_ADDR0, CALLER_ADDR1);
> +	}
> +
> +}
> +NOKPROBE_SYMBOL(__trace_hardirqs_off);
> +
>   void trace_hardirqs_off(void)
>   {
>   	if (!this_cpu_read(tracing_irq_cpu)) {
> 
