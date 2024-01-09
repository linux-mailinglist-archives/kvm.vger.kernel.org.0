Return-Path: <kvm+bounces-5903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D011D828B35
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 18:28:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FC0F282EFD
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 17:28:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE00B3B2BB;
	Tue,  9 Jan 2024 17:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AaL9xrL8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD1338DC7;
	Tue,  9 Jan 2024 17:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 409GvpZo016352;
	Tue, 9 Jan 2024 17:27:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=pskhbSQo/hE1+s88/LvrJMsOGawm3lUwErhvYaZxIls=;
 b=AaL9xrL8u8repX5NdOFKPnbkEHc81amJplTZPu8Nsl1mOSJSTdHNrp9qjPl6Jk3taKLr
 VhW0y8/s5+oXRcLPWDkZqEXRmwLfS6NaJRG4cRqE6NXjgIyvyQBx5e6qYPilhpeVdFID
 7TylOzFqPpKeb+1NeE675nr62mwi/2rnJJgRDBgaArPMG+D5MSeqv3xqdjNsu6BgBNb0
 +v00EPxZC3ENdhTyQYQ7eSwACPjV1wWQb9f/VG7/69g8i/B4DFLPSskyLldzvTUZ1/qr
 Paa9JX+wM1ILTt5zg33v0J24cFQiGN6ZR+7eXXVd/qK/twRd1VVzNxB1M6JEzpIt9Vwa vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vha4b0ykv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jan 2024 17:27:00 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 409Gvq6g016392;
	Tue, 9 Jan 2024 17:26:59 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vha4b0yjw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jan 2024 17:26:59 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 409F8FrW000954;
	Tue, 9 Jan 2024 17:26:58 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vfkdk7qnr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jan 2024 17:26:58 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 409HQvQv23003800
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Jan 2024 17:26:57 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DC9D45805F;
	Tue,  9 Jan 2024 17:26:56 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9562858051;
	Tue,  9 Jan 2024 17:26:47 +0000 (GMT)
Received: from [9.43.54.75] (unknown [9.43.54.75])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Jan 2024 17:26:47 +0000 (GMT)
Message-ID: <5c357634-c9c5-4796-9f5c-df00a4a5a523@linux.vnet.ibm.com>
Date: Tue, 9 Jan 2024 22:56:46 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 7/8] sched/core: boost/unboost in guest scheduler
Content-Language: en-US
To: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
        Joel Fernandes <joel@joelfernandes.org>
Cc: Suleiman Souhlal <suleiman@google.com>,
        Masami Hiramatsu <mhiramat@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Ben Segall
 <bsegall@google.com>, Borislav Petkov <bp@alien8.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "H . Peter Anvin"
 <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Steven Rostedt
 <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        shrikanth hegde <sshegde@linux.vnet.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        svaidy@linux.vnet.ibm.com
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
 <20231214024727.3503870-8-vineeth@bitbyteword.org>
From: Shrikanth Hegde <sshegde@linux.vnet.ibm.com>
In-Reply-To: <20231214024727.3503870-8-vineeth@bitbyteword.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DgTPp2sVU-KgGTclpFl7KzQAgWQGkLcJ
X-Proofpoint-ORIG-GUID: oS01Y7vpjosDo7xPi0V0bknViZo2VWkd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-09_09,2024-01-09_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=832 clxscore=1011
 malwarescore=0 phishscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401090141



On 12/14/23 8:17 AM, Vineeth Pillai (Google) wrote:
> RT or higher priority tasks in guest is considered a critical workload
> and guest scheduler can request boost/unboost on a task switch and/or a
> task wakeup. Also share the preempt status of guest vcpu with the host
> so that host can take decision on boot/unboost.
> 
> CONFIG_TRACE_PREEMPT_TOGGLE is enabled for using the function
> equivalent of preempt_count_{add,sub} to update the shared memory.
> Another option is to update the preempt_count_{add,sub} macros, but
> it will be more code churn and complex.
> 
> Boost request is lazy, but unboost request is synchronous.
> 
> Detect the feature in guest from cpuid flags and use the MSR to pass the
> GPA of memory location for sharing scheduling information.
> 
> Co-developed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
> ---
>  arch/x86/Kconfig                | 13 +++++
>  arch/x86/include/asm/kvm_para.h |  7 +++
>  arch/x86/kernel/kvm.c           | 16 ++++++
>  include/linux/sched.h           | 21 ++++++++
>  kernel/entry/common.c           |  9 ++++
>  kernel/sched/core.c             | 93 ++++++++++++++++++++++++++++++++-
>  6 files changed, 158 insertions(+), 1 deletion(-)
> 


Wish you all happy new year!
Sorry for the late reply. Took a while to go through this. 

[...]
>  /*
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index b47f72b6595f..57f211f1b3d7 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -151,6 +151,71 @@ const_debug unsigned int sysctl_sched_nr_migrate = SCHED_NR_MIGRATE_BREAK;
>  
>  __read_mostly int scheduler_running;
>  
> +#ifdef CONFIG_PARAVIRT_SCHED
> +#include <linux/kvm_para.h>
> +
> +DEFINE_STATIC_KEY_FALSE(__pv_sched_enabled);
> +
> +DEFINE_PER_CPU_DECRYPTED(struct pv_sched_data, pv_sched) __aligned(64);
> +
> +unsigned long pv_sched_pa(void)
> +{
> +	return slow_virt_to_phys(this_cpu_ptr(&pv_sched));
> +}
> +
> +bool pv_sched_vcpu_boosted(void)
> +{
> +	return (this_cpu_read(pv_sched.boost_status) == VCPU_BOOST_BOOSTED);
> +}
> +
> +void pv_sched_boost_vcpu_lazy(void)
> +{
> +	this_cpu_write(pv_sched.schedinfo.boost_req, VCPU_REQ_BOOST);
> +}
> +
> +void pv_sched_unboost_vcpu_lazy(void)
> +{
> +	this_cpu_write(pv_sched.schedinfo.boost_req, VCPU_REQ_UNBOOST);
> +}
> +
> +void pv_sched_boost_vcpu(void)
> +{
> +	pv_sched_boost_vcpu_lazy();
> +	/*
> +	 * XXX: there could be a race between the boost_status check
> +	 *      and hypercall.
> +	 */
> +	if (this_cpu_read(pv_sched.boost_status) == VCPU_BOOST_NORMAL)
> +		kvm_pv_sched_notify_host();
> +}
> +
> +void pv_sched_unboost_vcpu(void)
> +{
> +	pv_sched_unboost_vcpu_lazy();
> +	/*
> +	 * XXX: there could be a race between the boost_status check
> +	 *      and hypercall.
> +	 */
> +	if (this_cpu_read(pv_sched.boost_status) == VCPU_BOOST_BOOSTED &&
> +			!preempt_count())
> +		kvm_pv_sched_notify_host();
> +}
> +
> +/*
> + * Share the preemption enabled/disabled status with host. This will not incur a
> + * VMEXIT and acts as a lazy boost/unboost mechanism - host will check this on
> + * the next VMEXIT for boost/unboost decisions.
> + * XXX: Lazy unboosting may allow cfs tasks to run on RT vcpu till next VMEXIT.
> + */
> +static inline void pv_sched_update_preempt_status(bool preempt_disabled)
> +{
> +	if (pv_sched_enabled())
> +		this_cpu_write(pv_sched.schedinfo.preempt_disabled, preempt_disabled);
> +}
> +#else
> +static inline void pv_sched_update_preempt_status(bool preempt_disabled) {}
> +#endif
> +
>  #ifdef CONFIG_SCHED_CORE
>  

Wouldn't it be better to define a arch hook for this instead? implementation then could 
follow depending on the architecture. This boosting for vcpu tasks in host may be of 
interest to other hypervisors as well. 


Currently I see there are two places where interaction is taking place for paravirt. 
1. steal time accounting 
2. vcpu_is_preempted  
each architecture seems do this in their own way. So one option is an arch hook for 
other paravirt interfaces as well. Other option is probably what was discussed. i.e 
define a framework for paravirt interfaces from the ground up. 


We are working on resource limiting aspect of para virtualization on powerVM. 
Interface for that could be done via hypercall or via VPA (he VPA is a memory structure shared 
between the hypervisor and OS, defined by PAPR). That would be one more paravirt interface. 
As you mentioned in the cover letter, I am curious to know if you have tried the resource limiting, 
since you have overcommit of vCPUs.  

>  DEFINE_STATIC_KEY_FALSE(__sched_core_enabled);
> @@ -2070,6 +2135,19 @@ unsigned long get_wchan(struct task_struct *p)
>  
>  static inline void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
>  {
> +#ifdef CONFIG_PARAVIRT_SCHED
> +	/*
> +	 * TODO: currently request for boosting remote vcpus is not implemented. So
> +	 * we boost only if this enqueue happens for this cpu.
> +	 * This is not a big problem though, target cpu gets an IPI and then gets
> +	 * boosted by the host. Posted interrupts is an exception where target vcpu
> +	 * will not get boosted immediately, but on the next schedule().
> +	 */
> +	if (pv_sched_enabled() && this_rq() == rq &&
> +			sched_class_above(p->sched_class, &fair_sched_class))
> +		pv_sched_boost_vcpu_lazy();
> +#endif
> +
>  	if (!(flags & ENQUEUE_NOCLOCK))
>  		update_rq_clock(rq);
>  
> @@ -5835,6 +5913,8 @@ static inline void preempt_latency_start(int val)
>  #ifdef CONFIG_DEBUG_PREEMPT
>  		current->preempt_disable_ip = ip;
>  #endif
> +		pv_sched_update_preempt_status(true);
> +
>  		trace_preempt_off(CALLER_ADDR0, ip);
>  	}
>  }
> @@ -5867,8 +5947,10 @@ NOKPROBE_SYMBOL(preempt_count_add);
>   */
>  static inline void preempt_latency_stop(int val)
>  {
> -	if (preempt_count() == val)
> +	if (preempt_count() == val) {
> +		pv_sched_update_preempt_status(false);
>  		trace_preempt_on(CALLER_ADDR0, get_lock_parent_ip());
> +	}
>  }
>  
>  void preempt_count_sub(int val)
> @@ -6678,6 +6760,15 @@ static void __sched notrace __schedule(unsigned int sched_mode)
>  	rq->last_seen_need_resched_ns = 0;
>  #endif
>  
> +#ifdef CONFIG_PARAVIRT_SCHED
> +	if (pv_sched_enabled()) {
> +		if (sched_class_above(next->sched_class, &fair_sched_class))
> +			pv_sched_boost_vcpu_lazy();
> +		else if (next->sched_class == &fair_sched_class)
> +			pv_sched_unboost_vcpu();
> +	}
> +#endif
> +
>  	if (likely(prev != next)) {
>  		rq->nr_switches++;
>  		/*

