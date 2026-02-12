Return-Path: <kvm+bounces-70940-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +PqEAN6kjWlh5gAAu9opvQ
	(envelope-from <kvm+bounces-70940-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 11:01:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B529C12C23D
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 11:01:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C267430488E5
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 10:00:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27F9F2E040E;
	Thu, 12 Feb 2026 10:00:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B2F22BD597;
	Thu, 12 Feb 2026 10:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770890447; cv=none; b=aZDeMM2rr8j7YFVu6YLdB+zdejrZlrn6over0D4cZETktwhaRHerbCQ4JhiOf/b2+wMFHXMkHEgPndvEeW4BC23zEt+h7b5mj5wjUsDWU9zfg04z82leok3XbKIOn1wv5b38lCWSjieSMdbS63aRdsM/iy+5HgoOJqxE+mEc2w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770890447; c=relaxed/simple;
	bh=7ZYRuBH1NIP7D3LUQw8ro0uWe3uounX6XdBjRPCMBfU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WyjEVVoUJq/uALzcit5/pd29srVMYk1ACZZrxv0h+9Aj9d4FImLuiY4QZb9qeh50TIlTE5GUZ28YuYk/ik+9EUdJDB7n17kwfgoceFDw1uSmx4n4WPSYYdckiCZs3PC5LxbuaYHzabURsgyk97moRLfE2TzO+3/rFp3TE/dGScY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF2F7339;
	Thu, 12 Feb 2026 02:00:38 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 779903F632;
	Thu, 12 Feb 2026 02:00:38 -0800 (PST)
Message-ID: <c779ce82-4d8a-4943-b7ec-643e5a345d6c@arm.com>
Date: Thu, 12 Feb 2026 10:00:36 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: "Moger, Babu" <bmoger@amd.com>, "Luck, Tony" <tony.luck@intel.com>,
 Babu Moger <babu.moger@amd.com>
Cc: corbet@lwn.net, reinette.chatre@intel.com, Dave.Martin@arm.com,
 james.morse@arm.com, tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, akpm@linux-foundation.org,
 pawan.kumar.gupta@linux.intel.com, pmladek@suse.com,
 feng.tang@linux.alibaba.com, kees@kernel.org, arnd@arndb.de,
 fvdl@google.com, lirongqing@baidu.com, bhelgaas@google.com,
 seanjc@google.com, xin@zytor.com, manali.shukla@amd.com,
 dapeng1.mi@linux.intel.com, chang.seok.bae@intel.com,
 mario.limonciello@amd.com, naveen@kernel.org, elena.reshetova@intel.com,
 thomas.lendacky@amd.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, peternewman@google.com,
 eranian@google.com, gautham.shenoy@amd.com
References: <cover.1769029977.git.babu.moger@amd.com>
 <17c9c0c252dcfe707dffe5986e7c98cd121f7cef.1769029977.git.babu.moger@amd.com>
 <aXk8hRtv6ATEjW8A@agluck-desk3>
 <5ec19557-6a62-4158-af82-c70bac75226f@amd.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <5ec19557-6a62-4158-af82-c70bac75226f@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ben.horgan@arm.com,kvm@vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70940-lists,kvm=lfdr.de];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B529C12C23D
X-Rspamd-Action: no action

Hi Babu,

On 1/28/26 16:01, Moger, Babu wrote:
> Hi Tony,
> 
> Thanks for the comment.
> 
> On 1/27/2026 4:30 PM, Luck, Tony wrote:
>> On Wed, Jan 21, 2026 at 03:12:51PM -0600, Babu Moger wrote:
>>> @@ -138,6 +143,20 @@ static inline void __resctrl_sched_in(struct
>>> task_struct *tsk)
>>>           state->cur_rmid = rmid;
>>>           wrmsr(MSR_IA32_PQR_ASSOC, rmid, closid);
>>>       }
>>> +
>>> +    if (static_branch_likely(&rdt_plza_enable_key)) {
>>> +        tmp = READ_ONCE(tsk->plza);
>>> +        if (tmp)
>>> +            plza = tmp;
>>> +
>>> +        if (plza != state->cur_plza) {
>>> +            state->cur_plza = plza;
>>> +            wrmsr(MSR_IA32_PQR_PLZA_ASSOC,
>>> +                  RMID_EN | state->plza_rmid,
>>> +                  (plza ? PLZA_EN : 0) | CLOSID_EN | state-
>>> >plza_closid);
>>> +        }
>>> +    }
>>> +
>>
>> Babu,
>>
>> This addition to the context switch code surprised me. After your talk
>> at LPC I had imagined that PLZA would be a single global setting so that
>> every syscall/page-fault/interrupt would run with a different CLOSID
>> (presumably one configured with more cache and memory bandwidth).
>>
>> But this patch series looks like things are more flexible with the
>> ability to set different values (of RMID as well as CLOSID) per group.
> 
> Yes. this similar what we have with MSR_IA32_PQR_ASSOC. The association
> can be done either thru CPUs (just one MSR write) or task based
> association(more MSR write as task moves around).
>>
>> It looks like it is possible to have some resctrl group with very
>> limited resources just bump up a bit when in ring0, while other
>> groups may get some different amount.
>>
>> The additions for plza to the Documentation aren't helping me
>> understand how users will apply this.
>>
>> Do you have some more examples?
> 
> Group creation is similar to what we have currently.
> 
> 1. create a regular group and setup the limits.
>    # mkdir /sys/fs/resctrl/group
> 
> 2. Assign tasks or CPUs.
>    # echo 1234 > /sys/fs/resctrl/group/tasks
> 
>    This is a regular group.
> 
> 3. Now you figured that you need to change things in CPL0 for this task.
> 
> 4. Now create a PLZA group now and tweek the limits,
> 
>    # mkdir /sys/fs/resctrl/group1
> 
>    # echo 1 > /sys/fs/resctrl/group1/plza
> 
>    # echo "MB:0=100" > /sys/fs/resctrl/group1/schemata
> 
> 5. Assign the same task to the plza group.
> 
>    # echo 1234 > /sys/fs/resctrl/group1/tasks

Reusing 'tasks' files for kernel configuration risks confusing existing
user space tools that don't know about the new plza option. E.g. this
may be a problem if the user manually set the plza and then tried to use
their existing tool for understanding or configuring resctrl settings.

> 
> 
> Now the task 1234 will be using the limits from group1 when running in
> CPL0.
> 
> I will add few more details in my next revision.
> 
> Thanks
> Babu
> 

Thanks,

Ben


