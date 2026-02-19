Return-Path: <kvm+bounces-71350-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SGCNJMnulmngrAIAu9opvQ
	(envelope-from <kvm+bounces-71350-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 12:06:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F111415E297
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 12:06:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B6EA630221DC
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 11:06:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0885533DEC0;
	Thu, 19 Feb 2026 11:06:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E70323BD1D;
	Thu, 19 Feb 2026 11:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771499186; cv=none; b=WQzHvM2VhLssnBA5rVyoI4MMhWaHGWgJ3FQbMXejfMRejBwxWydNTV2XnDU+sqd50KaDhLxWAEIqA15rEJ4KobaMHj4E22AVPhUr3XEytXPK+znka+NWX7jN9nMrNrp+WSZY/JBpbNnx3kIw2/yPXYLrVDGQsVdgMyMWg1NOFU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771499186; c=relaxed/simple;
	bh=DdsdJPC4N6BgU/09EygoLkWbF5qbGpKqJ73bRH9Vsn4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k3sKDSNNZMQrcsIekOyNLLCZy+WuJ0GlyO6h2VBC7Y/WqpomukHeWdAuKrlwK19TKOwSUjdeujkVrYjG/Nxh3Ml6TKHzmCiQOTxY7Au1suVCGryg1efGFeh9mzCHc7S7uS+N84KhBIqdHh4J/0G5YsRe7b25ejmTjhc7VQvG3I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 28FF3339;
	Thu, 19 Feb 2026 03:06:17 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4470C3F7F5;
	Thu, 19 Feb 2026 03:06:16 -0800 (PST)
Message-ID: <d995e00d-2b90-4df4-a067-c4c76979e499@arm.com>
Date: Thu, 19 Feb 2026 11:06:14 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: "Luck, Tony" <tony.luck@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>
Cc: "Moger, Babu" <bmoger@amd.com>, "Moger, Babu" <Babu.Moger@amd.com>,
 Drew Fustini <fustini@kernel.org>, "corbet@lwn.net" <corbet@lwn.net>,
 "Dave.Martin@arm.com" <Dave.Martin@arm.com>,
 "james.morse@arm.com" <james.morse@arm.com>,
 "tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
 "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
 "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
 "dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>,
 "rostedt@goodmis.org" <rostedt@goodmis.org>,
 "bsegall@google.com" <bsegall@google.com>, "mgorman@suse.de"
 <mgorman@suse.de>, "vschneid@redhat.com" <vschneid@redhat.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>,
 "pmladek@suse.com" <pmladek@suse.com>,
 "feng.tang@linux.alibaba.com" <feng.tang@linux.alibaba.com>,
 "kees@kernel.org" <kees@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>,
 "fvdl@google.com" <fvdl@google.com>,
 "lirongqing@baidu.com" <lirongqing@baidu.com>,
 "bhelgaas@google.com" <bhelgaas@google.com>,
 "seanjc@google.com" <seanjc@google.com>, "xin@zytor.com" <xin@zytor.com>,
 "Shukla, Manali" <Manali.Shukla@amd.com>,
 "dapeng1.mi@linux.intel.com" <dapeng1.mi@linux.intel.com>,
 "chang.seok.bae@intel.com" <chang.seok.bae@intel.com>,
 "Limonciello, Mario" <Mario.Limonciello@amd.com>,
 "naveen@kernel.org" <naveen@kernel.org>,
 "elena.reshetova@intel.com" <elena.reshetova@intel.com>,
 "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "peternewman@google.com" <peternewman@google.com>,
 "eranian@google.com" <eranian@google.com>,
 "Shenoy, Gautham Ranjal" <gautham.shenoy@amd.com>,
 Zeng Heng <zengheng4@huawei.com>
References: <IA0PPF9A76BB3A655A28E9695C8AD1CC59F9591A@IA0PPF9A76BB3A6.namprd12.prod.outlook.com>
 <bbe80a9a-70f0-4cd1-bd6a-4a45212aa80b@amd.com>
 <7a4ea07d-88e6-4f0f-a3ce-4fd97388cec4@intel.com>
 <1f703c24-a4a9-416e-ae43-21d03f35f0be@intel.com>
 <aYyxAPdTFejzsE42@e134344.arm.com>
 <679dcd01-05e5-476a-91dd-6d1d08637b3e@intel.com>
 <aY3bvKeOcZ9yG686@e134344.arm.com>
 <2b2d0168-307a-40c3-98fa-54902482e861@intel.com>
 <aZM1OY7FALkPWmh6@e134344.arm.com>
 <d704ea1f-ed9f-4814-8fce-81db40b1ee3c@intel.com>
 <aZThTzdxVcBkLD7P@agluck-desk3>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <aZThTzdxVcBkLD7P@agluck-desk3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71350-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[47];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ben.horgan@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.965];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:mid]
X-Rspamd-Queue-Id: F111415E297
X-Rspamd-Action: no action

+Zeng

Discussion of resctrl configuration when running in the kernel. You
previously commented on similar on the MPAM series.

On 2/17/26 21:44, Luck, Tony wrote:
>>>>> I'm not sure if this would happen in the real world or not.
>>>>
>>>> Ack. I would like to echo Tony's request for feedback from resctrl users
>>>>  https://lore.kernel.org/lkml/aYzcpuG0PfUaTdqt@agluck-desk3/
>>>
>>> Indeed. This is all getting a bit complicated.
>>>
>>
>> ack
> 
> We have several proposals so far:

Thanks for making the summary.

> 
> 1) Ben's suggestion to use the default group (either with a Babu-style
> "plza" file just in that group, or a configuration file under "info/").
> 
> This is easily the simplest for implementation, but has no flexibility.
> Also requires users to move all the non-critical workloads out to other
> CTRL_MON groups. Doesn't steal a CLOSID/RMID.
> 
> 2) My thoughts are for a separate group that is only used to configure
> the schemata. This does allocate a dedicated CLOSID/RMID pair. Those
> are used for all tasks when in kernel mode.

If you mark the group somehow can you avoid a dedicated CLOSID/RMID
pair? (MPAM systems are often sized so you can use a partid per cpu,
num_partids=num_cpus.) The tasks/cpus files in the group could just be
used as normal for userspace configuration.

For 1,2 I think we need to be able to have an option where the rmid is
fixed to the userspace value and one where it isn't.

> 
> No context switch overhead. Has some flexibility.
> 
> 3) Babu's RFC patch. Designates an existing CTRL_MON group as the one
> that defines kernel CLOSID/RMID. Tasks and CPUs can be assigned to this
> group in addition to belonging to another group than defines schemata
> resources when running in non-kernel mode.
> Tasks aren't required to be in the kernel group, in which case they
> keep the same CLOSID in both user and kernel mode. When used in this
> way there will be context switch overhead when changing between tasks
> with different kernel CLOSID/RMID.
> 
> 4) Even more complex scenarios with more than one user configurable
> kernel group to give more options on resources available in the kernel.


If we are going to add more files to resctrl we should perhaps think of
a reserved prefix so they won't conflict with the names of user created
CTRL_MON groups.

>
> > I had a quick pass as coding my option "2". My UI to designate the
> group to use for kernel mode is to reserve the name "kernel_group"

I think we need to keep it possible for the kernel group to be the
default group. In MPAM systems the firmware and MPAM hypervisors are
likely to run with partid=0,pmg=0 and we may want the kernel to follow suit.

I need to check on an rdt system but I think the kernel also always runs
the idle thread with the default configuration. (Writing 0 to the tasks
file changes the configuration for the current task rather than the idle
tasks. I think this is missing from the documentation so I'll create a
patch to add it.)

> when making CTRL_MON groups. Some tweaks to avoid creating the
> "tasks", "cpus", and "cpus_list" files (which might be done more
> elegantly), and "mon_groups" directory in this group.
> 
> I just have stubs in the arch/x86 core.c file for enumeration and
> enable/disable. Just realized I'm missing a call to disable on
> unmount of the resctrl file system.
> 
> Apart from umount, I think it is more or less complete, and fairly
> compact:
> 
>  arch/x86/kernel/cpu/resctrl/core.c |   25 +++++++++++++++++++++++++
>  fs/resctrl/internal.h              |    9 +++++++--
>  fs/resctrl/rdtgroup.c              |   49 ++++++++++++++++++++++++++++++++++++-------------
>  include/linux/resctrl.h            |    4 ++++
>  4 files changed, 72 insertions(+), 15 deletions(-)
> 
> -Tony
> 
> ---
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 006e57fd7ca5..540ab9d7621a 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -702,6 +702,10 @@ bool resctrl_arch_get_io_alloc_enabled(struct rdt_resource *r);
>  extern unsigned int resctrl_rmid_realloc_threshold;
>  extern unsigned int resctrl_rmid_realloc_limit;
>  
> +bool resctrl_arch_kernel_group_is_supported(void);
> +void resctrl_arch_kernel_group_enable(u32 closid, u32 rmid);
> +void resctrl_arch_kernel_group_disable(void);
> +
>  int resctrl_init(void);
>  void resctrl_exit(void);
>  
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index 1a9b29119f88..99fbdcaf3c63 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -156,6 +156,7 @@ extern bool resctrl_mounted;
>  enum rdt_group_type {
>  	RDTCTRL_GROUP = 0,
>  	RDTMON_GROUP,
> +	RDTKERNEL_GROUP,
>  	RDT_NUM_GROUP,
>  };
>  
> @@ -245,6 +246,8 @@ struct rdtgroup {
>  
>  #define RFTYPE_BASE			BIT(1)
>  
> +#define RFTYPE_TASKS_CPUS		BIT(2)
> +
>  #define RFTYPE_CTRL			BIT(4)
>  
>  #define RFTYPE_MON			BIT(5)
> @@ -267,9 +270,11 @@ struct rdtgroup {
>  
>  #define RFTYPE_TOP_INFO			(RFTYPE_INFO | RFTYPE_TOP)
>  
> -#define RFTYPE_CTRL_BASE		(RFTYPE_BASE | RFTYPE_CTRL)
> +#define RFTYPE_CTRL_BASE		(RFTYPE_BASE | RFTYPE_TASKS_CPUS | RFTYPE_CTRL)
> +
> +#define RFTYPE_MON_BASE			(RFTYPE_BASE | RFTYPE_TASKS_CPUS | RFTYPE_MON)
>  
> -#define RFTYPE_MON_BASE			(RFTYPE_BASE | RFTYPE_MON)
> +#define RFTYPE_KERNEL_BASE		(RFTYPE_BASE | RFTYPE_CTRL)
>  
>  /* List of all resource groups */
>  extern struct list_head rdt_all_groups;
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 7667cf7c4e94..94d20b200e47 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -733,6 +733,28 @@ static void clear_closid_rmid(int cpu)
>  	      RESCTRL_RESERVED_CLOSID);
>  }
>  
> +static bool kernel_group_is_enabled;
> +static u32 kernel_group_closid, kernel_group_rmid;
> +
> +bool resctrl_arch_kernel_group_is_supported(void)
> +{
> +	return true;
> +}
> +
> +void resctrl_arch_kernel_group_enable(u32 closid, u32 rmid)
> +{
> +	pr_info("Enable kernel group on all CPUs here closid=%u rmid=%u\n", closid, rmid);
> +	kernel_group_closid = closid;
> +	kernel_group_rmid = rmid;
> +	kernel_group_is_enabled = true;
> +}
> +
> +void resctrl_arch_kernel_group_disable(void)
> +{
> +	pr_info("Disable kernel group on all CPUs here\n");
> +	kernel_group_is_enabled = false;
> +}
> +
>  static int resctrl_arch_online_cpu(unsigned int cpu)
>  {
>  	struct rdt_resource *r;
> @@ -743,6 +765,9 @@ static int resctrl_arch_online_cpu(unsigned int cpu)
>  	mutex_unlock(&domain_list_lock);
>  
>  	clear_closid_rmid(cpu);
> +	if (kernel_group_is_enabled)
> +		pr_info("Enable kernel group on CPU:%d closid=%u rmid=%u\n",
> +			cpu, kernel_group_closid, kernel_group_rmid);
>  	resctrl_online_cpu(cpu);
>  
>  	return 0;
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index ba8d503551cd..0d396569a76a 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -2046,7 +2046,7 @@ static struct rftype res_common_files[] = {
>  		.kf_ops		= &rdtgroup_kf_single_ops,
>  		.write		= rdtgroup_cpus_write,
>  		.seq_show	= rdtgroup_cpus_show,
> -		.fflags		= RFTYPE_BASE,
> +		.fflags		= RFTYPE_BASE | RFTYPE_TASKS_CPUS,
>  	},
>  	{
>  		.name		= "cpus_list",
> @@ -2055,7 +2055,7 @@ static struct rftype res_common_files[] = {
>  		.write		= rdtgroup_cpus_write,
>  		.seq_show	= rdtgroup_cpus_show,
>  		.flags		= RFTYPE_FLAGS_CPUS_LIST,
> -		.fflags		= RFTYPE_BASE,
> +		.fflags		= RFTYPE_BASE | RFTYPE_TASKS_CPUS,
>  	},
>  	{
>  		.name		= "tasks",
> @@ -2063,14 +2063,14 @@ static struct rftype res_common_files[] = {
>  		.kf_ops		= &rdtgroup_kf_single_ops,
>  		.write		= rdtgroup_tasks_write,
>  		.seq_show	= rdtgroup_tasks_show,
> -		.fflags		= RFTYPE_BASE,
> +		.fflags		= RFTYPE_BASE | RFTYPE_TASKS_CPUS,
>  	},
>  	{
>  		.name		= "mon_hw_id",
>  		.mode		= 0444,
>  		.kf_ops		= &rdtgroup_kf_single_ops,
>  		.seq_show	= rdtgroup_rmid_show,
> -		.fflags		= RFTYPE_MON_BASE | RFTYPE_DEBUG,
> +		.fflags		= RFTYPE_BASE | RFTYPE_MON | RFTYPE_DEBUG,
>  	},
>  	{
>  		.name		= "schemata",
> @@ -2078,7 +2078,7 @@ static struct rftype res_common_files[] = {
>  		.kf_ops		= &rdtgroup_kf_single_ops,
>  		.write		= rdtgroup_schemata_write,
>  		.seq_show	= rdtgroup_schemata_show,
> -		.fflags		= RFTYPE_CTRL_BASE,
> +		.fflags		= RFTYPE_BASE | RFTYPE_CTRL,
>  	},
>  	{
>  		.name		= "mba_MBps_event",
> @@ -2093,14 +2093,14 @@ static struct rftype res_common_files[] = {
>  		.kf_ops		= &rdtgroup_kf_single_ops,
>  		.write		= rdtgroup_mode_write,
>  		.seq_show	= rdtgroup_mode_show,
> -		.fflags		= RFTYPE_CTRL_BASE,
> +		.fflags		= RFTYPE_BASE | RFTYPE_CTRL,
>  	},
>  	{
>  		.name		= "size",
>  		.mode		= 0444,
>  		.kf_ops		= &rdtgroup_kf_single_ops,
>  		.seq_show	= rdtgroup_size_show,
> -		.fflags		= RFTYPE_CTRL_BASE,
> +		.fflags		= RFTYPE_BASE | RFTYPE_CTRL,
>  	},
>  	{
>  		.name		= "sparse_masks",
> @@ -2114,7 +2114,7 @@ static struct rftype res_common_files[] = {
>  		.mode		= 0444,
>  		.kf_ops		= &rdtgroup_kf_single_ops,
>  		.seq_show	= rdtgroup_closid_show,
> -		.fflags		= RFTYPE_CTRL_BASE | RFTYPE_DEBUG,
> +		.fflags		= RFTYPE_BASE | RFTYPE_CTRL | RFTYPE_DEBUG,
>  	},
>  };
>  
> @@ -3788,11 +3788,15 @@ static int mkdir_rdt_prepare(struct kernfs_node *parent_kn,
>  	}
>  
>  	if (rtype == RDTCTRL_GROUP) {
> -		files = RFTYPE_BASE | RFTYPE_CTRL;
> +		files = RFTYPE_CTRL_BASE;
> +		if (resctrl_arch_mon_capable())
> +			files |= RFTYPE_MON_BASE;
> +	} else if (rtype == RDTKERNEL_GROUP) {
> +		files = RFTYPE_KERNEL_BASE;
>  		if (resctrl_arch_mon_capable())
>  			files |= RFTYPE_MON;
>  	} else {
> -		files = RFTYPE_BASE | RFTYPE_MON;
> +		files = RFTYPE_MON_BASE;
>  	}
>  
>  	ret = rdtgroup_add_files(kn, files);
> @@ -3866,12 +3870,21 @@ static int rdtgroup_mkdir_mon(struct kernfs_node *parent_kn,
>  static int rdtgroup_mkdir_ctrl_mon(struct kernfs_node *parent_kn,
>  				   const char *name, umode_t mode)
>  {
> +	enum rdt_group_type rtype = RDTCTRL_GROUP;
>  	struct rdtgroup *rdtgrp;
>  	struct kernfs_node *kn;
>  	u32 closid;
>  	int ret;
>  
> -	ret = mkdir_rdt_prepare(parent_kn, name, mode, RDTCTRL_GROUP, &rdtgrp);
> +	if (!strcmp(name, "kernel_group")) {
> +		if (!resctrl_arch_kernel_group_is_supported()) {
> +			rdt_last_cmd_puts("No support for kernel group\n");
> +			return -EINVAL;
> +		}
> +		rtype = RDTKERNEL_GROUP;
> +	}
> +
> +	ret = mkdir_rdt_prepare(parent_kn, name, mode, rtype, &rdtgrp);
>  	if (ret)
>  		return ret;
>  
> @@ -3898,7 +3911,7 @@ static int rdtgroup_mkdir_ctrl_mon(struct kernfs_node *parent_kn,
>  
>  	list_add(&rdtgrp->rdtgroup_list, &rdt_all_groups);
>  
> -	if (resctrl_arch_mon_capable()) {
> +	if (rtype == RDTCTRL_GROUP && resctrl_arch_mon_capable()) {
>  		/*
>  		 * Create an empty mon_groups directory to hold the subset
>  		 * of tasks and cpus to monitor.
> @@ -3912,6 +3925,9 @@ static int rdtgroup_mkdir_ctrl_mon(struct kernfs_node *parent_kn,
>  			rdtgrp->mba_mbps_event = mba_mbps_default_event;
>  	}
>  
> +	if (rtype == RDTKERNEL_GROUP)
> +		resctrl_arch_kernel_group_enable(rdtgrp->closid, rdtgrp->mon.rmid);
> +
>  	goto out_unlock;
>  
>  out_del_list:
> @@ -4005,6 +4021,11 @@ static int rdtgroup_rmdir_ctrl(struct rdtgroup *rdtgrp, cpumask_var_t tmpmask)
>  	u32 closid, rmid;
>  	int cpu;
>  
> +	if (rdtgrp->type == RDTKERNEL_GROUP) {
> +		resctrl_arch_kernel_group_disable();
> +		goto skip_tasks_and_cpus;
> +	}
> +
>  	/* Give any tasks back to the default group */
>  	rdt_move_group_tasks(rdtgrp, &rdtgroup_default, tmpmask);
>  
> @@ -4025,6 +4046,7 @@ static int rdtgroup_rmdir_ctrl(struct rdtgroup *rdtgrp, cpumask_var_t tmpmask)
>  	cpumask_or(tmpmask, tmpmask, &rdtgrp->cpu_mask);
>  	update_closid_rmid(tmpmask, NULL);
>  
> +skip_tasks_and_cpus:
>  	rdtgroup_unassign_cntrs(rdtgrp);
>  
>  	free_rmid(rdtgrp->closid, rdtgrp->mon.rmid);
> @@ -4073,7 +4095,8 @@ static int rdtgroup_rmdir(struct kernfs_node *kn)
>  	 * If the rdtgroup is a mon group and parent directory
>  	 * is a valid "mon_groups" directory, remove the mon group.
>  	 */
> -	if (rdtgrp->type == RDTCTRL_GROUP && parent_kn == rdtgroup_default.kn &&
> +	if ((rdtgrp->type == RDTCTRL_GROUP || rdtgrp->type == RDTKERNEL_GROUP) &&
> +	    parent_kn == rdtgroup_default.kn &&
>  	    rdtgrp != &rdtgroup_default) {
>  		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP ||
>  		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED) {

Thanks,

Ben


