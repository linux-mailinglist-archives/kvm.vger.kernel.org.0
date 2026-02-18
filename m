Return-Path: <kvm+bounces-71217-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iGY0N/WHlWnqSAIAu9opvQ
	(envelope-from <kvm+bounces-71217-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 10:35:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 41C10154C25
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 10:35:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7E60F301187A
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 09:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D56433CEAF;
	Wed, 18 Feb 2026 09:35:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 639A525B1CB;
	Wed, 18 Feb 2026 09:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771407337; cv=none; b=Zx5KGEfTr3X6xVBrzGc32T6AjBak/PJje4kM2oaEJMX7jEY2U9ObER/l3FJGFep6aJfEG5ZaJpZ6na09Nsr7lBiX73KB2cVncF7UZOHJExIN2av6ppdvglP8QVrFL3xzFWmzLDXSL/sWGFrR4hVe8uXTeq0OadxitSa/5rsFHUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771407337; c=relaxed/simple;
	bh=skintGXkdxIGoNLBet6IdAti6A/CqAhPs+KLWpbLka0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RntieAIRTvxC8B8+aIzDYOHp8IZJgw20Zk1/sWdI1/xwfKMMGnYmXKLX9wTiGTP/YCTDFF1bKcLhKCUUEbKO+Itjnzg1XAfGZeyW64QX7HASvKUmd3BrrD6ayJnibuZZhNUMQKzjPWKu1AmfL3KZNPg4JTGIL11wONI+PpyUKJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6224F1477;
	Wed, 18 Feb 2026 01:35:29 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C4C453F7F5;
	Wed, 18 Feb 2026 01:35:28 -0800 (PST)
Message-ID: <845587f3-4c27-46d9-83f8-6b38ccc54183@arm.com>
Date: Wed, 18 Feb 2026 09:35:27 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: Stephane Eranian <eranian@google.com>
Cc: "Moger, Babu" <bmoger@amd.com>,
 Reinette Chatre <reinette.chatre@intel.com>, "Moger, Babu"
 <Babu.Moger@amd.com>, "Luck, Tony" <tony.luck@intel.com>,
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
 "Shenoy, Gautham Ranjal" <gautham.shenoy@amd.com>
References: <cover.1769029977.git.babu.moger@amd.com>
 <17c9c0c252dcfe707dffe5986e7c98cd121f7cef.1769029977.git.babu.moger@amd.com>
 <aXk8hRtv6ATEjW8A@agluck-desk3>
 <5ec19557-6a62-4158-af82-c70bac75226f@amd.com>
 <aXpDdUQHCnQyhcL3@agluck-desk3>
 <IA0PPF9A76BB3A655A28E9695C8AD1CC59F9591A@IA0PPF9A76BB3A6.namprd12.prod.outlook.com>
 <bbe80a9a-70f0-4cd1-bd6a-4a45212aa80b@amd.com>
 <7a4ea07d-88e6-4f0f-a3ce-4fd97388cec4@intel.com>
 <abb049fa-3a3d-4601-9ae3-61eeb7fd8fcf@amd.com>
 <1a0a7306-f833-45a8-8f2b-c6d2e8b98ff5@intel.com>
 <fd7e0779-7e29-461d-adb6-0568a81ec59e@arm.com>
 <fbaa21b3-d010-4b89-8e87-f13d3f176ea3@amd.com>
 <951b9a1f-a9d7-4834-b6b8-61417e984f2f@arm.com>
 <CABPqkBSq=cgn-am4qorA_VN0vsbpbfDePSi7gubicpROB1=djw@mail.gmail.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <CABPqkBSq=cgn-am4qorA_VN0vsbpbfDePSi7gubicpROB1=djw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71217-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[45];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ben.horgan@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,arm.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 41C10154C25
X-Rspamd-Action: no action

Hi Stephane,

On 2/18/26 06:22, Stephane Eranian wrote:
> On Tue, Feb 17, 2026 at 7:56 AM Ben Horgan <ben.horgan@arm.com> wrote:
>>
>> Hi Babu,
>>
>> On 2/16/26 22:52, Moger, Babu wrote:
>>> Hi Ben,
>>>
>>> On 2/16/2026 9:41 AM, Ben Horgan wrote:
>>>> Hi Babu, Reinette,
>>>>
>>>> On 2/14/26 00:10, Reinette Chatre wrote:
>>>>> Hi Babu,
>>>>>
>>>>> On 2/13/26 8:37 AM, Moger, Babu wrote:
>>>>>> Hi Reinette,
>>>>>>
>>>>>> On 2/10/2026 10:17 AM, Reinette Chatre wrote:
>>>>>>> Hi Babu,
>>>>>>>
>>>>>>> On 1/28/26 9:44 AM, Moger, Babu wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On 1/28/2026 11:41 AM, Moger, Babu wrote:
>>>>>>>>>> On Wed, Jan 28, 2026 at 10:01:39AM -0600, Moger, Babu wrote:
>>>>>>>>>>> On 1/27/2026 4:30 PM, Luck, Tony wrote:
>>>>>>>>>> Babu,
>>>>>>>>>>
>>>>>>>>>> I've read a bit more of the code now and I think I understand more.
>>>>>>>>>>
>>>>>>>>>> Some useful additions to your explanation.
>>>>>>>>>>
>>>>>>>>>> 1) Only one CTRL group can be marked as PLZA
>>>>>>>>>
>>>>>>>>> Yes. Correct.
>>>>>>>
>>>>>>> Why limit it to one CTRL_MON group and why not support it for MON
>>>>>>> groups?
>>>>>>
>>>>>> There can be only one PLZA configuration in a system. The values in
>>>>>> the MSR_IA32_PQR_PLZA_ASSOC register (RMID, RMID_EN, CLOSID,
>>>>>> CLOSID_EN) must be identical across all logical processors. The only
>>>>>> field that may differ is PLZA_EN.
>>>>
>>>> Does this have any effect on hypervisors?
>>>
>>> Because hypervisor runs at CPL0, there could be some use case. I have
>>> not completely understood that part.
>>>
>>>>
>>>>>
>>>>> ah - this is a significant part that I missed. Since this is a per-
>>>>> CPU register it seems
>>>>
>>>> I also missed that.
>>>>
>>>>> to have the ability for expanded use in the future where different
>>>>> CLOSID and RMID may be
>>>>> written to it? Is PLZA leaving room for such future enhancement or
>>>>> does the spec contain
>>>>> the text that state "The values in the MSR_IA32_PQR_PLZA_ASSOC
>>>>> register (RMID, RMID_EN,
>>>>> CLOSID, CLOSID_EN) must be identical across all logical processors."?
>>>>> That is, "forever
>>>>> and always"?
>>>>>
>>>>> If I understand correctly MPAM could have different PARTID and PMG
>>>>> for kernel use so we
>>>>> need to consider these different architectural behaviors.
>>>>
>>>> Yes, MPAM has a per-cpu register MPAM1_EL1.
>>>>
>>>
>>> oh ok.
>>>
>>>>>
>>>>>> I was initially unsure which RMID should be used when PLZA is
>>>>>> enabled on MON groups.
>>>>>>
>>>>>> After re-evaluating, enabling PLZA on MON groups is still feasible:
>>>>>>
>>>>>> 1. Only one group in the system can have PLZA enabled.
>>>>>> 2. If PLZA is enabled on CTRL_MON group then we cannot enable PLZA
>>>>>> on MON group.
>>>>>> 3. If PLZA is enabled on the CTRL_MON group, then the CLOSID and
>>>>>> RMID of the CTRL_MON group can be written.
>>>>>> 4. If PLZA is enabled on a MON group, then the CLOSID of the
>>>>>> CTRL_MON group can be used, while the RMID of the MON group can be
>>>>>> written.
>>>>
>>>> Given that CLOSID and RMID are fixed once in the PLZA configuration
>>>> could this be simplified by just assuming they have the values of the
>>>> default group, CLOSID=0 and RMID=0 and let the user base there
>>>> configuration on that?
>>>>
>>>
>>> I didn't understand this question. There are 16 CLOSIDs and 1024 RMIDs.
>>> We can use any one of these to enable PLZA.  It is not fixed in that sense.
>>
>> Sorry, I wasn't clear. What I'm trying to understand is what you gain by
>> this flexibility. Given that the values CLOSID and the RMID are just
>> identifiers within the hardware and have only the meaning they are given
>> by the grouping and controls/monitors set up by resctrl (or any other
>> software interface) would you lose anything by just saying the PLZA
>> group has CLOSID=0 and RMID=0. Is there value in changing the PLZA
>> CLOSID and RMID or can the same effect happen by just changing the
>> resctrl configuration?
>>
> Not quite.
> When you enter the kernel, you want to run unthrottled to avoid
> priority inversion situations.
> But at the same time, you still want to be able to monitor the
> bandwidth for your thread or job, i..e, keep the same
> RMID you have in user space.

Thanks for sharing your usecase.

> 
> The kernel is by construction shared by all threads running in the
> system. It should run unrestricted or with the
> bandwidth allocated to the highest priority tasks.
> 
> PLZA should not change the RMID at all.

Would the above with RMID_EN=0 give you this usecase?

Unfortunately, this isn't possible when rmid/pmg is scoped to
closid/partid as is the case in MPAM, i.e. the monitors require a match
on the pair (closid, partid). Hence, I think we need to support the case
where both RMID and CLOSID change.

> 
> You could obtain the same effect by changing the quote for each CLOSID
> entering the kernel. But that would likely be more expensive
> and you would have to do this for every possible entry and exit point
> (restore on exit).
> 
> 
> 
>> I was also wondering if using the default group this way would mean that
>> you wouldn't need to reserve the group for only kernel use.
>>
>>>
>>>
>>>>>>
>>>>>> I am thinking this approach should work.
>>>>>>
>>>>>>>
>>>>>>> Limiting it to a single CTRL group seems restrictive in a few ways:
>>>>>>> 1) It requires that the "PLZA" group has a dedicated CLOSID. This
>>>>>>> reduces the
>>>>>>>      number of use cases that can be supported. Consider, for
>>>>>>> example, an existing
>>>>>>>      "high priority" resource group and a "low priority" resource
>>>>>>> group. The user may
>>>>>>>      just want to let the tasks in the "low priority" resource
>>>>>>> group run as "high priority"
>>>>>>>      when in CPL0. This of course may depend on what resources are
>>>>>>> allocated, for example
>>>>>>>      cache may need more care, but if, for example, user is only
>>>>>>> interested in memory
>>>>>>>      bandwidth allocation this seems a reasonable use case?
>>>>>>> 2) Similar to what Tony [1] mentioned this does not enable what the
>>>>>>> hardware is
>>>>>>>      capable of in terms of number of different control groups/
>>>>>>> CLOSID that can be
>>>>>>>      assigned to MSR_IA32_PQR_PLZA_ASSOC. Why limit PLZA to one
>>>>>>> CLOSID?
>>>>>>> 3) The feature seems to support RMID in MSR_IA32_PQR_PLZA_ASSOC
>>>>>>> similar to
>>>>>>>      MSR_IA32_PQR_ASSOC. With this, it should be possible for user
>>>>>>> space to, for
>>>>>>>      example, create a resource group that contains tasks of
>>>>>>> interest and create
>>>>>>>      a monitor group within it that monitors all tasks' bandwidth
>>>>>>> usage when in CPL0.
>>>>>>>      This will give user space better insight into system behavior
>>>>>>> and from what I can
>>>>>>>      tell is supported by the feature but not enabled?
>>>>>>
>>>>>>
>>>>>> Yes, as long as PLZA is enabled on only one group in the entire system
>>>>>>
>>>>>>>
>>>>>>>>>
>>>>>>>>>> 2) It can't be the root/default group
>>>>>>>>>
>>>>>>>>> This is something I added to keep the default group in a un-
>>>>>>>>> disturbed,
>>>>>>>
>>>>>>> Why was this needed?
>>>>>>>
>>>>>>
>>>>>> With the new approach mentioned about we can enable in default group
>>>>>> also.
>>>>>>
>>>>>>>>>
>>>>>>>>>> 3) It can't have sub monitor groups
>>>>>>>
>>>>>>> Why not?
>>>>>>
>>>>>> Ditto. With the new approach mentioned about we can enable in
>>>>>> default group also.
>>>>>>
>>>>>>>
>>>>>>>>>> 4) It can't be pseudo-locked
>>>>>>>>>
>>>>>>>>> Yes.
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> Would a potential use case involve putting *all* tasks into the
>>>>>>>>>> PLZA group? That
>>>>>>>>>> would avoid any additional context switch overhead as the PLZA
>>>>>>>>>> MSR would never
>>>>>>>>>> need to change.
>>>>>>>>>
>>>>>>>>> Yes. That can be one use case.
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> If that is the case, maybe for the PLZA group we should allow
>>>>>>>>>> user to
>>>>>>>>>> do:
>>>>>>>>>>
>>>>>>>>>> # echo '*' > tasks
>>>>>>>
>>>>>>> Dedicating a resource group to "PLZA" seems restrictive while also
>>>>>>> adding many
>>>>>>> complications since this designation makes resource group behave
>>>>>>> differently and
>>>>>>> thus the files need to get extra "treatments" to handle this "PLZA"
>>>>>>> designation.
>>>>>>>
>>>>>>> I am wondering if it will not be simpler to introduce just one new
>>>>>>> file, for example
>>>>>>> "tasks_cpl0" in both CTRL_MON and MON groups. When user space
>>>>>>> writes a task ID to the
>>>>>>> file it "enables" PLZA for this task and that group's CLOSID and
>>>>>>> RMID is the associated
>>>>>>> task's "PLZA" CLOSID and RMID. This gives user space the
>>>>>>> flexibility to use the same
>>>>>>> resource group to manage user space and kernel space allocations
>>>>>>> while also supporting
>>>>>>> various monitoring use cases. This still supports the "dedicate a
>>>>>>> resource group to PLZA"
>>>>>>> use case where user space can create a new resource group with
>>>>>>> certain allocations but the
>>>>>>> "tasks" file will be empty and "tasks_cpl0" contains the tasks
>>>>>>> needing to run with
>>>>>>> the resource group's allocations when in CPL0.
>>>>>>
>>>>>> Yes. We should be able do that. We need both tasks_cpl0 and cpus_cpl0.
>>>>>>
>>>>>> We need make sure only one group can configured in the system and
>>>>>> not allow in other groups when it is already enabled.
>>>>>
>>>>> As I understand this means that only one group can have content in its
>>>>> tasks_cpl0/tasks_kernel file. There should not be any special
>>>>> handling for
>>>>> the remaining files of the resource group since the resource group is
>>>>> not
>>>>> dedicated to kernel work and can be used as a user space resource
>>>>> group also.
>>>>> If user space wants to create a dedicated kernel resource group there
>>>>> can be
>>>>> a new resource group with an empty tasks file.
>>>>>
>>>>> hmmm ... but if user space writes a task ID to a tasks_cpl0/
>>>>> tasks_kernel file then
>>>>> resctrl would need to create new syntax to remove that task ID.
>>>>>
>>>>> Possibly MPAM can build on this by allowing user space to write to
>>>>> multiple
>>>>> tasks_cpl0/tasks_kernel files? (and the next version of PLZA may too)
>>>>>
>>>>> Reinette
>>>>>
>>>>>
>>>>>>
>>>>>> Thanks
>>>>>> Babu
>>>>>>
>>>>>>>
>>>>>>> Reinette
>>>>>>>
>>>>>>> [1] https://lore.kernel.org/lkml/aXpgragcLS2L8ROe@agluck-desk3/
>>>>>>>
>>>>>>
>>>>>
>>>>>
>>>>
>>>> Thanks,
>>>>
>>>> Ben
>>>>
>>>>
>>>
>>
>> Thanks,
>>
>> Ben
>>

Thanks,

Ben


