Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 024A56978C7
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 10:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbjBOJQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 04:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbjBOJQq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 04:16:46 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC4F1C580;
        Wed, 15 Feb 2023 01:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jUYwQA4oml0TKvpa3jMzwiji+eI20kHKqSJa+RJjfkc=; b=hKTu0gnETyG9Y+L8at53B/z8a2
        vzHL1oiH+f1YgdT/qxFpjs9tKTUTHJMHZ1vcLksZnkRKFvyXuP0ni4wNlW0Z4XZh086weRif7xULT
        hQ4QmOtfDz4kWiWBCTNCzJoGxvziH1dC1IiLIOjiQBlJsWVUIVXEcKmmLQdOiBjSNhN4mLyimN4S0
        6XpS4dbl3p+fH+34PAEeRQ6QOP5MBHLoDiizfhn3rjDWRNTAtN+nHK8XgNQ1aoAAmg/Avm0yYZyyp
        G7V6XgdjtpqVju5cn+TFUTegiU23S5UwD1N1WGboXo+EZ+GGngsytKwYls7esMEVVPu2qh7gfgcDe
        qAwv4pMA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pSDt2-009uDJ-1E;
        Wed, 15 Feb 2023 09:16:20 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 87A843003E1;
        Wed, 15 Feb 2023 10:16:16 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6516F23BC8715; Wed, 15 Feb 2023 10:16:16 +0100 (CET)
Date:   Wed, 15 Feb 2023 10:16:16 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Message-ID: <Y+yi4B+P9K2FXNqt@hirez.programming.kicks-ass.net>
References: <cover.1676286526.git.kai.huang@intel.com>
 <557c526a1190903d11d67c4e2c76e01f67f6eb15.1676286526.git.kai.huang@intel.com>
 <86a8fe2f-566a-d0b9-7a22-9b41c91796f8@intel.com>
 <BL1PR11MB59789A024CFA9E9DE715C2F1F7DD9@BL1PR11MB5978.namprd11.prod.outlook.com>
 <af6034c3-98a3-239b-2c79-ff878f5d9673@intel.com>
 <43fec733ea5331c6de4592dbf44a62e0c61eecb1.camel@intel.com>
 <Y+uWu9hLMZ35JHlY@hirez.programming.kicks-ass.net>
 <0795f69fd0ff8ccdd40cc7a3d6cc32da47e6d929.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0795f69fd0ff8ccdd40cc7a3d6cc32da47e6d929.camel@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 14, 2023 at 10:53:26PM +0000, Huang, Kai wrote:

> Sure.  I just tried to do.  There are two minor things:
> 
> 1) should I just use smp_cond_func_t directly as the cond function?

Yeah, might as well I suppose...

> 2) schedule_on_each_cpu() takes cpus_read_lock() internally.  However in my
> case, tdx_enable() already takes that so I need a _locked_ version.
> 
> How does below look like? (Not tested)
> 
> +/**
> + * schedule_on_each_cpu_cond_locked - execute a function synchronously
> + *                                   on each online CPU for which the
> + *                                   condition function returns positive
> + * @func:      the function to call
> + * @cond_func:  the condition function to call
> + * @cond_data: the data passed to the condition function
> + *
> + * schedule_on_each_cpu_cond_locked() executes @func on each online CPU
> + * when @cond_func returns positive for that cpu, using the system
> + * workqueue and blocks until all CPUs have completed.
> + *
> + * schedule_on_each_cpu_cond_locked() doesn't hold read lock of CPU
> + * hotplug lock but depend on the caller to do.
> + *
> + * schedule_on_each_cpu_cond_locked() is very slow.
> + *
> + * Return:
> + * 0 on success, -errno on failure.
> + */
> +int schedule_on_each_cpu_cond_locked(work_func_t func,
> +                                    smp_cond_func_t cond_func,
> +                                    void *cond_data)
> +{
> +       int cpu;
> +       struct work_struct __percpu *works;
> +
> +       works = alloc_percpu(struct work_struct);
> +       if (!works)
> +               return -ENOMEM;
> +
> +       for_each_online_cpu(cpu) {
> +               struct work_struct *work = per_cpu_ptr(works, cpu);
> +
> +               if (cond_func && !cond_func(cpu, cond_data))
> +                       continue;
> +
> +               INIT_WORK(work, func);
> +               schedule_work_on(cpu, work);
> +       }
> +
> +       for_each_online_cpu(cpu)

I think you need to skip some flushes too. Given we skip setting
work->func, this will go WARN, see __flush_work().

> +               flush_work(per_cpu_ptr(works, cpu));
> +
> +       free_percpu(works);
> +       return 0;
> +}
> +
> +/**
> + * schedule_on_each_cpu_cond - execute a function synchronously on each
> + *                            online CPU for which the condition
> + *                            function returns positive
> + * @func:      the function to call
> + * @cond_func:  the condition function to call
> + * @cond_data: the data passed to the condition function
> + *
> + * schedule_on_each_cpu_cond() executes @func on each online CPU
> + * when @cond_func returns positive for that cpu, using the system
> + * workqueue and blocks until all CPUs have completed.
> + *
> + * schedule_on_each_cpu_cond() is very slow.
> + *
> + * Return:
> + * 0 on success, -errno on failure.
> + */
> +int schedule_on_each_cpu_cond(work_func_t func,
> +                             smp_cond_func_t cond_func,
> +                             void *cond_data)
> +{
> +       int ret;
> +
> +       cpus_read_lock();
> +
> +       ret = schedule_on_each_cpu_cond_locked(func, cond_func, cond_data);
> +
> +       cpus_read_unlock();
> +
> +       return ret;
> +}

Also, re-implement schedule_on_each_cpu() using the above to save a
bunch of duplication:

int schedule_on_each_cpu(work_func_t func)
{
	return schedule_on_each_cpu_cond(func, NULL, NULL);
}


That said, I find it jarring that the schedule_on*() family doesn't have
a void* argument to the function, like the smp_*() family has. So how
about something like the below (equally untested). It preserves the
current semantics, but allows a work function to cast to schedule_work
and access ->info if it so desires.


diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index a0143dd24430..5e97111322b2 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -103,6 +103,11 @@ struct work_struct {
 #endif
 };
 
+struct schedule_work {
+	struct work_struct work;
+	void *info;
+};
+
 #define WORK_DATA_INIT()	ATOMIC_LONG_INIT((unsigned long)WORK_STRUCT_NO_POOL)
 #define WORK_DATA_STATIC_INIT()	\
 	ATOMIC_LONG_INIT((unsigned long)(WORK_STRUCT_NO_POOL | WORK_STRUCT_STATIC))
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 07895deca271..c73bb8860bbc 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -51,6 +51,7 @@
 #include <linux/sched/isolation.h>
 #include <linux/nmi.h>
 #include <linux/kvm_para.h>
+#include <linux/smp.h>
 
 #include "workqueue_internal.h"
 
@@ -3302,43 +3303,64 @@ bool cancel_delayed_work_sync(struct delayed_work *dwork)
 }
 EXPORT_SYMBOL(cancel_delayed_work_sync);
 
-/**
- * schedule_on_each_cpu - execute a function synchronously on each online CPU
- * @func: the function to call
- *
- * schedule_on_each_cpu() executes @func on each online CPU using the
- * system workqueue and blocks until all CPUs have completed.
- * schedule_on_each_cpu() is very slow.
- *
- * Return:
- * 0 on success, -errno on failure.
- */
-int schedule_on_each_cpu(work_func_t func)
+int schedule_on_each_cpu_cond_locked(work_func_t func, smp_cond_func_t cond_func, void *info)
 {
+	struct schedule_work __percpu *works;
 	int cpu;
-	struct work_struct __percpu *works;
 
-	works = alloc_percpu(struct work_struct);
+	works = alloc_percpu(struct schedule_work);
 	if (!works)
 		return -ENOMEM;
 
-	cpus_read_lock();
-
 	for_each_online_cpu(cpu) {
-		struct work_struct *work = per_cpu_ptr(works, cpu);
+		struct schedule_work *work = per_cpu_ptr(works, cpu);
 
-		INIT_WORK(work, func);
-		schedule_work_on(cpu, work);
+		if (cond_func && !cond_func(cpu, info))
+			continue;
+
+		INIT_WORK(&work->work, func);
+		work->info = info;
+		schedule_work_on(cpu, &work->work);
 	}
 
-	for_each_online_cpu(cpu)
-		flush_work(per_cpu_ptr(works, cpu));
+	for_each_online_cpu(cpu) {
+		struct schedule_work *work = per_cpu_ptr(works, cpu);
+
+		if (work->work.func)
+			flush_work(&work->work);
+	}
 
-	cpus_read_unlock();
 	free_percpu(works);
 	return 0;
 }
 
+int schedule_on_each_cpu_cond(work_func_t func, smp_cond_func_t cond_func, void *info)
+{
+	int ret;
+
+	cpus_read_lock();
+	ret = schedule_on_each_cpu_cond_locked(func, cond, info);
+	cpus_read_unlock();
+
+	return ret;
+}
+
+/**
+ * schedule_on_each_cpu - execute a function synchronously on each online CPU
+ * @func: the function to call
+ *
+ * schedule_on_each_cpu() executes @func on each online CPU using the
+ * system workqueue and blocks until all CPUs have completed.
+ * schedule_on_each_cpu() is very slow.
+ *
+ * Return:
+ * 0 on success, -errno on failure.
+ */
+int schedule_on_each_cpu(work_func_t func)
+{
+	return schedule_on_each_cpu_cond(func, NULL, NULL);
+}
+
 /**
  * execute_in_process_context - reliably execute the routine with user context
  * @fn:		the function to execute
