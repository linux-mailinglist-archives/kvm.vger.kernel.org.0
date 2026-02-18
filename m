Return-Path: <kvm+bounces-71218-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GLwzB8uMlWl7SQIAu9opvQ
	(envelope-from <kvm+bounces-71218-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 10:56:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C57C8154FD6
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 10:56:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6BC81303EFA8
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 09:54:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FBC033DEE7;
	Wed, 18 Feb 2026 09:54:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8732333D6CB;
	Wed, 18 Feb 2026 09:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771408493; cv=none; b=orT02ZvW0joEmR6WPujQ9/AsPpmCBj9wqxBoUa6cvlSx0NSJGcpTBz1TqWZJJLa/+lkz6kIAZT4Jnr9DO9kq83qx4BKvEMkdubdTqhWsgdqCzZWLrEp5vzDY90WhIe3iuNu66caBh2ENUQU3heI3j3r3IAc5UeaGmnTTE1QPS7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771408493; c=relaxed/simple;
	bh=0Stq0g2etzMhJVlWR4YwfppUieMkaRUuzolfL046V8A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SCjn1Wfqhw78/0TdND58KwwQagMLXIJcQ6L54/BsyS39l2g0WBHlXwLjAy377SsWgLKPdVNSITUbU8ofud1iAtWFpSoZWYE9t8V/Znoulg41u558GJwYG4DW3NXrJ6/kO1rH1QdnxIxKLyQoPHqy35YH3IACbG6eW9hw72hfgZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0439F1477;
	Wed, 18 Feb 2026 01:54:44 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 841583F7F5;
	Wed, 18 Feb 2026 01:54:43 -0800 (PST)
Message-ID: <c8268b2a-50d7-44b4-ac3f-5ce6624599b1@arm.com>
Date: Wed, 18 Feb 2026 09:54:41 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: Babu Moger <babu.moger@amd.com>, "Moger, Babu" <bmoger@amd.com>,
 Reinette Chatre <reinette.chatre@intel.com>, "Luck, Tony"
 <tony.luck@intel.com>
Cc: "corbet@lwn.net" <corbet@lwn.net>,
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
 <1e91b8ed-b4b3-4d95-94e2-916b06511185@amd.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <1e91b8ed-b4b3-4d95-94e2-916b06511185@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71218-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,arm.com:mid]
X-Rspamd-Queue-Id: C57C8154FD6
X-Rspamd-Action: no action

Hi Babu,

On 2/17/26 16:38, Babu Moger wrote:
> Hi Ben,
> 
> On 2/17/26 09:56, Ben Horgan wrote:
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
>>>>>>>> On 1/28/2026 11:41 AM, Moger, Babu wrote:
>>>>>>>>>> On Wed, Jan 28, 2026 at 10:01:39AM -0600, Moger, Babu wrote:
>>>>>>>>>>> On 1/27/2026 4:30 PM, Luck, Tony wrote:
>>>>>>>>>> Babu,
>>>>>>>>>>
>>>>>>>>>> I've read a bit more of the code now and I think I understand
>>>>>>>>>> more.
>>>>>>>>>>
>>>>>>>>>> Some useful additions to your explanation.
>>>>>>>>>>
>>>>>>>>>> 1) Only one CTRL group can be marked as PLZA
>>>>>>>>> Yes. Correct.
>>>>>>> Why limit it to one CTRL_MON group and why not support it for MON
>>>>>>> groups?
>>>>>> There can be only one PLZA configuration in a system. The values in
>>>>>> the MSR_IA32_PQR_PLZA_ASSOC register (RMID, RMID_EN, CLOSID,
>>>>>> CLOSID_EN) must be identical across all logical processors. The only
>>>>>> field that may differ is PLZA_EN.
>>>> Does this have any effect on hypervisors?
>>> Because hypervisor runs at CPL0, there could be some use case. I have
>>> not completely understood that part.
>>>
>>>>> ah - this is a significant part that I missed. Since this is a per-
>>>>> CPU register it seems
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
>>>> Yes, MPAM has a per-cpu register MPAM1_EL1.
>>>>
>>> oh ok.
>>>
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
>>>> Given that CLOSID and RMID are fixed once in the PLZA configuration
>>>> could this be simplified by just assuming they have the values of the
>>>> default group, CLOSID=0 and RMID=0 and let the user base there
>>>> configuration on that?
>>>>
>>> I didn't understand this question. There are 16 CLOSIDs and 1024 RMIDs.
>>> We can use any one of these to enable PLZA.  It is not fixed in that
>>> sense.
>> Sorry, I wasn't clear. What I'm trying to understand is what you gain by
>> this flexibility. Given that the values CLOSID and the RMID are just
>> identifiers within the hardware and have only the meaning they are given
>> by the grouping and controls/monitors set up by resctrl (or any other
>> software interface) would you lose anything by just saying the PLZA
>> group has CLOSID=0 and RMID=0. Is there value in changing the PLZA
>> CLOSID and RMID or can the same effect happen by just changing the
>> resctrl configuration?
>>
>> I was also wondering if using the default group this way would mean that
>> you wouldn't need to reserve the group for only kernel use.
> 
> Yes, that is an option, but it becomes too restrictive. Would this
> approach work for the ARM implementation?

As a minimum, a fixed partid/pmg would be ok for mpam but we would want
to be able to grow features from this. (Changeable partid/pmg can also
we work.) In either case, we wouldn't want the partid to be necessarily
exclusive to the kernel as some configuration assign one partid to each
cpu and the number of partids is often equal to the number of cpus.

> 
> If a user wants to keep a selective set of tasks running at different
> allocation levels, they would need to create another new group, move all
> tasks  from default group to new group, and leave only the selected
> tasks in the default group.
> 
> And if that group is later deleted, all tasks will automatically return
> to the default group.
> 
> Thanks,
> Babu
> 

Thanks,

Ben


