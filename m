Return-Path: <kvm+bounces-71342-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MC8WIV/klmlbqgIAu9opvQ
	(envelope-from <kvm+bounces-71342-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 11:22:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AC9315DBE0
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 11:22:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2E02F30252A3
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 10:22:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D212732D7D9;
	Thu, 19 Feb 2026 10:21:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4A8B38FA3;
	Thu, 19 Feb 2026 10:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771496518; cv=none; b=sJi3XQMP7J9l1CpJoJ3q1LAroWOpe7aDoD7iqFoRtNgxlrXSlGdlLFa418ohs46zEn2NY4Sv/Tu9ni0vy1sND/e4eTD8QRTPfZE+XpI4Il2DoCYBuZhqeHJNrd/C3KlcUmCr4t1xAHKRrBpRAp7cDweQs+m9a9aQ5HZUr2UFZ/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771496518; c=relaxed/simple;
	bh=fU/vwsRP1qZP5IE4FnVqYDHuPJvSMR1FGi4lv9ghEW4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t8xPFzaC5xFYt/nlqqgD6jB+DuOjtmRtJdzdgLL0IET8ZL/prQ8yx4rhMt2nPLGm5oa3loQVvSO+ElbuBmVUcMV1yYnrCt4Fz3fSfxs/HPl1Q/KQd3u1Cd/IMNBZuicfEuHtmiF37MhnqrGQpDUYKr4NfIKVdOFSfclsZjqR0co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 66F60339;
	Thu, 19 Feb 2026 02:21:48 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CA9993F62B;
	Thu, 19 Feb 2026 02:21:47 -0800 (PST)
Message-ID: <b746428e-1a91-4ed9-8800-c9769e86df97@arm.com>
Date: Thu, 19 Feb 2026 10:21:46 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: "Moger, Babu" <bmoger@amd.com>, "Moger, Babu" <Babu.Moger@amd.com>,
 "Luck, Tony" <tony.luck@intel.com>, Drew Fustini <fustini@kernel.org>,
 "corbet@lwn.net" <corbet@lwn.net>, "Dave.Martin@arm.com"
 <Dave.Martin@arm.com>, "james.morse@arm.com" <james.morse@arm.com>,
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
 "Shenoy, Gautham Ranjal" <gautham.shenoy@amd.com>
References: <5ec19557-6a62-4158-af82-c70bac75226f@amd.com>
 <aXpDdUQHCnQyhcL3@agluck-desk3>
 <IA0PPF9A76BB3A655A28E9695C8AD1CC59F9591A@IA0PPF9A76BB3A6.namprd12.prod.outlook.com>
 <bbe80a9a-70f0-4cd1-bd6a-4a45212aa80b@amd.com>
 <7a4ea07d-88e6-4f0f-a3ce-4fd97388cec4@intel.com>
 <1f703c24-a4a9-416e-ae43-21d03f35f0be@intel.com>
 <aYyxAPdTFejzsE42@e134344.arm.com>
 <679dcd01-05e5-476a-91dd-6d1d08637b3e@intel.com>
 <aY3bvKeOcZ9yG686@e134344.arm.com>
 <2b2d0168-307a-40c3-98fa-54902482e861@intel.com>
 <aZM1OY7FALkPWmh6@e134344.arm.com>
 <d704ea1f-ed9f-4814-8fce-81db40b1ee3c@intel.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <d704ea1f-ed9f-4814-8fce-81db40b1ee3c@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71342-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[46];
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
X-Rspamd-Queue-Id: 0AC9315DBE0
X-Rspamd-Action: no action

Hi Reinette,

On 2/17/26 18:51, Reinette Chatre wrote:
> Hi Ben,
> 
> On 2/16/26 7:18 AM, Ben Horgan wrote:
>> On Thu, Feb 12, 2026 at 10:37:21AM -0800, Reinette Chatre wrote:
>>> On 2/12/26 5:55 AM, Ben Horgan wrote:
>>>> On Wed, Feb 11, 2026 at 02:22:55PM -0800, Reinette Chatre wrote:
>>>>> On 2/11/26 8:40 AM, Ben Horgan wrote:
>>>>>> On Tue, Feb 10, 2026 at 10:04:48AM -0800, Reinette Chatre wrote:
> 
>>>>>>> It looks like MPAM has a few more capabilities here and the Arm levels are numbered differently
>>>>>>> with EL0 meaning user space. We should thus aim to keep things as generic as possible. For example,
>>>>>>> instead of CPL0 using something like "kernel" or ... ?
>>>>>>
>>>>>> Yes, PLZA does open up more possibilities for MPAM usage.  I've talked to James
>>>>>> internally and here are a few thoughts.
>>>>>>
>>>>>> If the user case is just that an option run all tasks with the same closid/rmid
>>>>>> (partid/pmg) configuration when they are running in the kernel then I'd favour a
>>>>>> mount option. The resctrl filesytem interface doesn't need to change and
>>>>>
>>>>> I view mount options as an interface of last resort. Why would a mount option be needed
>>>>> in this case? The existence of the file used to configure the feature seems sufficient?
>>>>
>>>> If we are taking away a closid from the user then the number of CTRL_MON groups
>>>> that can be created changes. It seems reasonable for user-space to expect
>>>> num_closid to be a fixed value.
>>>
>>> I do you see why we need to take away a CLOSID from the user. Consider a user space that
>>
>> Yes, just slightly simpler to take away a CLOSID but could just go with the
>> default CLOSID is also used for the kernel. I would be ok with a file saying the
>> mode, like the mbm_event file does for counter assignment. It slightly misleading
>> that a configuration file is under info but necessary as we don't have another
>> location global to the resctrl mount.
> 
> Indeed, the "info" directory has evolved more into a "config" directory.
> 
>>> runs with just two resource groups, for example, "high priority" and "low priority", it seems
>>> reasonable to make it possible to let the "low priority" tasks run with "high priority"
>>> allocations when in kernel space without needing to dedicate a new CLOSID? More reasonable
>>> when only considering memory bandwidth allocation though.
>>>
>>>>
>>>>>
>>>>> Also ...
>>>>>
>>>>> I do not think resctrl should unnecessarily place constraints on what the hardware
>>>>> features are capable of. As I understand, both PLZA and MPAM supports use case where
>>>>> tasks may use different CLOSID/RMID (PARTID/PMG) when running in the kernel. Limiting
>>>>> this to only one CLOSID/PARTID seems like an unmotivated constraint to me at the moment.
>>>>> This may be because I am not familiar with all the requirements here so please do
>>>>> help with insight on how the hardware feature is intended to be used as it relates
>>>>> to its design.
>>>>>
>>>>> We have to be very careful when constraining a feature this much  If resctrl does something
>>>>> like this it essentially restricts what users could do forever.
>>>>
>>>> Indeed, we don't want to unnecessarily restrict ourselves here. I was hoping a
>>>> fixed kernel CLOSID/RMID configuration option might just give all we need for
>>>> usecases we know we have and be minimally intrusive enough to not preclude a
>>>> more featureful PLZA later when new usecases come about.
>>>
>>> Having ability to grow features would be ideal. I do not see how a fixed kernel CLOSID/RMID
>>> configuration leaves room to build on top though. Could you please elaborate?
>>
>> If we initially go with a single new configuration file, e.g. kernel_mode, which
>> could be "match_user" or "use_root, this would be the only initial change to the
>> interface needed. If more usecases present themselves a new mode could be added,
>> e.g. "configurable", and an interface to actually change the rmid/closid for the
>> kernel could be added.
> 
> Something like this could be a base to work from. I think only the two ("match_user" and
> "use_root") are a bit limiting for even the initial implementation though.
> As I understand, "use_root" implies using the allocations of the default group but
> does not indicate what MON group (which RMID/PMG) should be used to monitor the
> work done in kernel space. A way to specify the actual group may be needed?

Yeah, I'm not sure that flexibility is strictly necessary but will make
the interface easier to use.

> 
>>> I wonder if the benefit of the fixed CLOSID/RMID is perhaps mostly in the cost of
>>> context switching which I do not think is a concern for MPAM but it may be for PLZA?
>>>
>>> One option to support fixed kernel CLOSID/RMID at the beginning and leave room to build
>>> may be to create the kernel_group or "tasks_kernel" interface as a baseline but in first
>>> implementation only allow user space to write the same group to all "kernel_group" files or
>>> to only allow to write to one of the "tasks_kernel" files in the resctrl fs hierarchy. At
>>> that time the associated CLOSID/RMID would become the "fixed configuration" and attempts to
>>> write to others can return "ENOSPC"?
>>
>> I think we'd have to be sure of the final interface if we go this way.
> 
> I do not think we should aim to know the final interface since that requires knowing all future
> hardware features and their implementations in advance. Instead we should aim to have something
> that we can build on that is accompanied by documentation that supports future flexibility (some may
> refer to this as "weasel words").

Makes sense.

> 
>>> From what I can tell this still does not require to take away a CLOSID/RMID from user space
>>> though. Dedicating a CLOSID/RMID to kernel work can still be done but be in control of user
>>> that can, for example leave the "tasks" and "cpus" files empty.
>>>
>>>> One complication is that for fixed kernel CLOSID/RMID option is that for x86 you
>>>> may want to be able to monitor a tasks resource usage whether or not it is in
>>>> the kernel or userspace and so only have a fixed CLOSID. However, for MPAM this
>>>> wouldn't work as PMG (~RMID) is scoped to PARTID (~CLOSID).
>>>>
>>>>>
>>>>>> userspace software doesn't need to change. This could either take away a
>>>>>> closid/rmid from userspace and dedicate it to the kernel or perhaps have a
>>>>>> policy to have the default group as the kernel group. If you use the default
>>>>>
>>>>> Similar to above I do not see PLZA or MPAM preventing sharing of CLOSID/RMID (PARTID/PMG)
>>>>> between user space and kernel. I do not see a motivation for resctrl to place such
>>>>> constraint.
>>>>>
>>>>>> configuration, at least for MPAM, the kernel may not be running at the highest
>>>>>> priority as a minimum bandwidth can be used to give a priority boost. (Once we
>>>>>> have a resctrl schema for this.)
>>>>>>
>>>>>> It could be useful to have something a bit more featureful though. Is there a
>>>>>> need for the two mappings, task->cpl0 config and task->cpl1 to be independent or
>>>>>> would as task->(cp0 config, cp1 config) be sufficient? It seems awkward that
>>>>>> it's not a single write to move a task. If a single mapping is sufficient, then
>>>>>
>>>>> Moving a task in x86 is currently two writes by writing the CLOSID and RMID separately.
>>>>> I think the MPAM approach is better and there may be opportunity to do this in a similar
>>>>> way and both architectures use the same field(s) in the task_struct.
>>>>
>>>> I was referring to the userspace file write but unifying on a the same fields in
>>>> task_struct could be good. The single write is necessary for MPAM as PMG is
>>>> scoped to PARTID and I don't think x86 behaviour changes if it moves to the same
>>>> approach.
>>>>
>>>
>>> ah - I misunderstood. You are suggesting to have one file that user writes to
>>> to set both user space and kernel space CLOSID/RMID? This sounds like what the
>>
>> Yes, the kernel_groups idea does partially have this as once you've set the
>> kernel_group for a CTRL_MON or MON group then the user space configuration
>> dictates the kernel space configuration. As you pointed out, this is also
>> a draw back of the kernel_groups idea.
>>
>>> existing "tasks" file does but only supports the same CLOSID/RMID for both user
>>> space and kernel space. To support the new hardware features where the CLOSID/RMID
>>> can be different we cannot just change "tasks" interface and would need to keep it
>>> backward compatible. So far I assumed that it would be ok for the "tasks" file
>>> to essentially get new meaning as the CLOSID/RMID for just user space work, which 
>>> seems to require a second file for kernel space as a consequence? So far I have
>>> not seen an option that does not change meaning of the "tasks" file.
>>
>> Would it make sense to have some new type of entries in the tasks file,
>> e.g. k_ctrl_<pid>, k_mon_<pid> to say, in the kernel, use the closid of this
>> CTRL_MON for this task pid or use the rmid of this CTRL_MON/MON group for this task
>> pid? We would still probably need separate files for the cpu configuration.
> 
> I am obligated to nack such a change to the tasks file since it would impact any
> existing user space parsing of this file.
> 

Good to know. Do you consider the format of the tasks file fully fixed?

Thanks,

Ben


