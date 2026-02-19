Return-Path: <kvm+bounces-71360-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EAT1KI5Jl2m2wQIAu9opvQ
	(envelope-from <kvm+bounces-71360-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 18:34:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EC6C16141E
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 18:34:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 09C523047502
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 17:33:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D1DB34FF44;
	Thu, 19 Feb 2026 17:33:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCFF5286891;
	Thu, 19 Feb 2026 17:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771522409; cv=none; b=tmkMjLS5xl90HRV92vZJuvJbU1p0uiUD7Hny10gxw4Qc7TwuZSpPSMypWu1EFPGQIdI+2QS7gRQ06F8vfiCi/zkROmJ6CCYmk4xeH27fWXIFUQccrdT5YsC3QJWe+ZIo8jWENT00oyEPeIuGphZwf0Ewwb9dB8wzkWZrSL4ci8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771522409; c=relaxed/simple;
	bh=YBfqhAyJBBi8jQ5+S2gpiyWB9sQOFUWNV2K7dd7lm3I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uQA6ROT/UmWgbjHDeZqRAG+BDclypDz8+In+oxYSq+KPBqhp51ot1JdjgR7waJ+dKq7lgYxU3QsLbQ2RjISu/qr69FhULeXLJghEHm5TEGtGru/VLZSmh5rLoTIZ55A37bZT7vBEMo5JFMNZmRCxfXJdrKKRb97kzOQNBYfEwak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79EC5339;
	Thu, 19 Feb 2026 09:33:20 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA58F3F7D8;
	Thu, 19 Feb 2026 09:33:19 -0800 (PST)
Message-ID: <feaa16a5-765c-4c24-9e0b-c1f4ef87a66f@arm.com>
Date: Thu, 19 Feb 2026 17:33:18 +0000
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
 "Shenoy, Gautham Ranjal" <gautham.shenoy@amd.com>
References: <aYyxAPdTFejzsE42@e134344.arm.com>
 <679dcd01-05e5-476a-91dd-6d1d08637b3e@intel.com>
 <aY3bvKeOcZ9yG686@e134344.arm.com>
 <2b2d0168-307a-40c3-98fa-54902482e861@intel.com>
 <aZM1OY7FALkPWmh6@e134344.arm.com>
 <d704ea1f-ed9f-4814-8fce-81db40b1ee3c@intel.com>
 <aZThTzdxVcBkLD7P@agluck-desk3>
 <2416004a-5626-491d-819c-c470abbe0dd0@intel.com>
 <aZTxJTWzfQGRqg-R@agluck-desk3>
 <65c279fd-0e89-4a6a-b217-3184bd570e23@intel.com>
 <aZXsihgl0B-o1DI6@agluck-desk3>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <aZXsihgl0B-o1DI6@agluck-desk3>
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
	TAGGED_FROM(0.00)[bounces-71360-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1EC6C16141E
X-Rspamd-Action: no action

Hi Tony,

On 2/18/26 16:44, Luck, Tony wrote:
> On Tue, Feb 17, 2026 at 03:55:44PM -0800, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 2/17/26 2:52 PM, Luck, Tony wrote:
>>> On Tue, Feb 17, 2026 at 02:37:49PM -0800, Reinette Chatre wrote:
>>>> Hi Tony,
>>>>
>>>> On 2/17/26 1:44 PM, Luck, Tony wrote:
>>>>>>>>> I'm not sure if this would happen in the real world or not.
>>>>>>>>
>>>>>>>> Ack. I would like to echo Tony's request for feedback from resctrl users
>>>>>>>>  https://lore.kernel.org/lkml/aYzcpuG0PfUaTdqt@agluck-desk3/
>>>>>>>
>>>>>>> Indeed. This is all getting a bit complicated.
>>>>>>>
>>>>>>
>>>>>> ack
>>>>>
>>>>> We have several proposals so far:
>>>>>
>>>>> 1) Ben's suggestion to use the default group (either with a Babu-style
>>>>> "plza" file just in that group, or a configuration file under "info/").
>>>>>
>>>>> This is easily the simplest for implementation, but has no flexibility.
>>>>> Also requires users to move all the non-critical workloads out to other
>>>>> CTRL_MON groups. Doesn't steal a CLOSID/RMID.
>>>>>
>>>>> 2) My thoughts are for a separate group that is only used to configure
>>>>> the schemata. This does allocate a dedicated CLOSID/RMID pair. Those
>>>>> are used for all tasks when in kernel mode.
>>>>>
>>>>> No context switch overhead. Has some flexibility.
>>>>>
>>>>> 3) Babu's RFC patch. Designates an existing CTRL_MON group as the one
>>>>> that defines kernel CLOSID/RMID. Tasks and CPUs can be assigned to this
>>>>> group in addition to belonging to another group than defines schemata
>>>>> resources when running in non-kernel mode.
>>>>> Tasks aren't required to be in the kernel group, in which case they
>>>>> keep the same CLOSID in both user and kernel mode. When used in this
>>>>> way there will be context switch overhead when changing between tasks
>>>>> with different kernel CLOSID/RMID.
>>>>>
>>>>> 4) Even more complex scenarios with more than one user configurable
>>>>> kernel group to give more options on resources available in the kernel.
>>>>>
>>>>>
>>>>> I had a quick pass as coding my option "2". My UI to designate the
>>>>> group to use for kernel mode is to reserve the name "kernel_group"
>>>>> when making CTRL_MON groups. Some tweaks to avoid creating the
>>>>> "tasks", "cpus", and "cpus_list" files (which might be done more
>>>>> elegantly), and "mon_groups" directory in this group.
>>>>
>>>> Should the decision of whether context switch overhead is acceptable
>>>> not be left up to the user? 
>>>
>>> When someone comes up with a convincing use case to support one set of
>>> kernel resources when interrupting task A, and a different set of
>>> resources when interrupting task B, we should certainly listen.
>>
>> Absolutely. Someone can come up with such use case at any time tough. This
>> could be, and as has happened with some other resctrl interfaces, likely will be
>> after this feature has been supported for a few kernel versions. What timeline
>> should we give which users to share their use cases with us? Even if we do hear
>> from some users will that guarantee that no such use case will arise in the
>> future? Such predictions of usage are difficult for me and I thus find it simpler
>> to think of flexible ways to enable the features that we know the hardware supports.
>>
>> This does not mean that a full featured solution needs to be implemented from day 1.
>> If folks believe there are "no valid use cases" today resctrl still needs to prepare for
>> how it can grow to support full hardware capability and hardware designs in the
>> future.
>>
>> Also, please also consider not just resources for kernel work but also monitoring for
>> kernel work. I do think, for example, a reasonable use case may be to determine
>> how much memory bandwidth the kernel uses on behalf of certain tasks.
>>  
>>>> I assume that, just like what is currently done for x86's MSR_IA32_PQR_ASSOC,
>>>> the needed registers will only be updated if there is a new CLOSID/RMID needed
>>>> for kernel space.
>>>
>>> Babu's RFC does this.
>>
>> Right.
>>
>>>
>>>>                   Are you suggesting that just this checking itself is too
>>>> expensive to justify giving user space more flexibility by fully enabling what
>>>> the hardware supports? If resctrl does draw such a line to not enable what
>>>> hardware supports it should be well justified.
>>>
>>> The check is likley light weight (as long as the variables to be
>>> compared reside in the same cache lines as the exisitng CLOSID
>>> and RMID checks). So if there is a use case for different resources
>>> when in kernel mode, then taking this path will be fine.
>>
>> Why limit this to knowing about a use case? As I understand this feature can be
>> supported in a flexible way without introducing additional context switch overhead
>> if the user prefers to use just one allocation for all kernel work. By being
>> configurable and allowing resctrl to support more use cases in the future resctrl
>> does not paint itself into a corner. This allows resctrl to grow support so that
>> the user can use all capabilities of the hardware with understanding that it will
>> increase context switch time.
>>
>> Reinette
> 
> How about this idea for extensibility.
> 
> Rename Babu's "plza" file to "plza_mode". Instead of just being an
> on/off switch, it may accept multiple possible requests.

If we're making global configuration choices then I think it should be
visible in a global location. It doesn't seem good to have to check all
CTRL_MON group.

> 
> Humorous version:
> 
> # echo "babu" > plza_mode
> 
> This results in behavior of Babu's RFC. The CLOSID and RMID assigned to
> the CTRL_MON group are used when in kernel mode, but only for tasks that
> have their task-id written to the "tasks" file or for tasks in the
> default group in the "cpus" or "cpus_list" files are used to assign
> CPUs to this group.
> 
> # echo "tony" > plza_mode
> 
> All tasks run with the CLOSID/RMID for this group. The "tasks", "cpus" and
> "cpus_list" files and the "mon_groups" directory are removed.
> 
> # echo "ben" > plza_mode"
> 
> Only usable in the top-level default CTRL_MON directory. CLOSID=0/RMID=0
> are used for all tasks in kernel mode.
> 
> # echo "stephane" > plza_mode
> 
> The RMID for this group is freed. All tasks run in kernel mode with the
> CLOSID for this group, but use same RMID for both user and kernel.
> In addition to files removed in "tony" mode, the mon_data directory is
> removed.

For these option with a single group set as plza we could have a global
option and then just a plza marker.

> 
> # echo "some-future-name" > plza_mode
> 
> Somebody has a new use case. Resctrl can be extended by allowing some
> new mode.
>
> > Likely real implementation:
> 
> Sub-components of each of the ideas above are encoded as a bitmask that
> is written to plza_mode. There is a file in the info/ directory listing
> which bits are supported on the current system (e.g. the "keep the same
> RMID" mode may be impractical on ARM, so it would not be listed as an
> option.)
> 
> -Tony

Thanks,

Ben


