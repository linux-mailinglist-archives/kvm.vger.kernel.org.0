Return-Path: <kvm+bounces-71602-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aLwHMyxynWmAQAQAu9opvQ
	(envelope-from <kvm+bounces-71602-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 10:41:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 0220C184CD1
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 10:40:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A914D3064EF5
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 09:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B309C36C5B8;
	Tue, 24 Feb 2026 09:36:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C2A436C0BA;
	Tue, 24 Feb 2026 09:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771925790; cv=none; b=qvgv2/fl3ZQORV5kPoB9ljWCcuZNzuLoLh9bnXovUvcTo6a0nPxwMhZUd53KI6ItNgoZUEI6hdltRiIr7P4CSjnUrOg4wymm0puWLsV3xmop5whzobPuqk2TeUrWxZCFZsjSOS5IOAZF3IkhmOlBTaus+A/uQzfcbh6CDFS8sOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771925790; c=relaxed/simple;
	bh=jiLD7T/Ws70D67gEmvYD133dGrOXikvQtOuu8fqMz3k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DACbYif4Miv8dJO7fl4A1cp9kFI6Fr5IyXSHru8OYbBl0QNKGmSzmXZgkc79zoFPA90QI3sroSESWrfvW76jVqecn53x0AcwCt6crC0B+dWkCCYyP6ZhEAGB7Mpbofmv/1/C9mI9/1EyHgJTVjBZD2s2gDmSjCRbWeLBvr8nsu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C8F8339;
	Tue, 24 Feb 2026 01:36:21 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EF7453F59E;
	Tue, 24 Feb 2026 01:36:20 -0800 (PST)
Message-ID: <08b3568a-c034-4531-8263-e27015306dca@arm.com>
Date: Tue, 24 Feb 2026 09:36:19 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: Reinette Chatre <reinette.chatre@intel.com>,
 "Luck, Tony" <tony.luck@intel.com>, "Moger, Babu" <Babu.Moger@amd.com>,
 "eranian@google.com" <eranian@google.com>
Cc: "Moger, Babu" <bmoger@amd.com>, Drew Fustini <fustini@kernel.org>,
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
 <2ab556af-095b-422b-9396-f845c6fd0342@intel.com>
 <730c193e-bf31-47a8-8f46-3a4c19b96f77@arm.com>
 <9ae7909a-dbb1-4d54-a47c-2ffdb4899b64@intel.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <9ae7909a-dbb1-4d54-a47c-2ffdb4899b64@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71602-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.964];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0220C184CD1
X-Rspamd-Action: no action

Hi Reinette,

On 2/23/26 16:38, Reinette Chatre wrote:
> Hi Ben,
> 
> On 2/23/26 2:08 AM, Ben Horgan wrote:
>> On 2/20/26 02:53, Reinette Chatre wrote:
> 
> ...
> 
>>> Dedicated global allocations for kernel work, monitoring same for user space and kernel (MPAM)
>>> ----------------------------------------------------------------------------------------------
>>> 1. User space creates resource and monitoring groups for user tasks:
>>>  	/sys/fs/resctrl <= User space default allocations
>>> 	/sys/fs/resctrl/g1 <= User space allocations g1
>>> 	/sys/fs/resctrl/g1/mon_groups/g1m1 <= User space monitoring group g1m1
>>> 	/sys/fs/resctrl/g1/mon_groups/g1m2 <= User space monitoring group g1m2
>>> 	/sys/fs/resctrl/g2 <= User space allocations g2
>>> 	/sys/fs/resctrl/g2/mon_groups/g2m1 <= User space monitoring group g2m1
>>> 	/sys/fs/resctrl/g2/mon_groups/g2m2 <= User space monitoring group g2m2
>>>
>>> 2. User space creates resource and monitoring groups for kernel work (system has two PMG):
>>> 	/sys/fs/resctrl/kernel <= Kernel space allocations 
>>> 	/sys/fs/resctrl/kernel/mon_data               <= Kernel space monitoring for all of default and g1
>>> 	/sys/fs/resctrl/kernel/mon_groups/kernel_g2   <= Kernel space monitoring for all of g2
>>> 3. Set kernel mode to per_group_assign_ctrl_assign_mon:
>>> 	# echo per_group_assign_ctrl_assign_mon > info/kernel_mode
>>>    - info/kernel_mode_assignment becomes visible and contains
>>> 	# cat info/kernel_mode_assignment
>>> 	//://
>>> 	g1//://
>>> 	g1/g1m1/://
>>> 	g1/g1m2/://
>>> 	g2//://
>>> 	g2/g2m1/://
>>> 	g2/g2m2/://
>>>    - An optimization here may be to have the change to per_group_assign_ctrl_assign_mon mode be implemented
>>>      similar to the change to global_assign_ctrl_assign_mon that initializes a global default. This can
>>>      avoid keeping tasklist_lock for a long time to set all tasks' kernel CLOSID/RMID to default just for
>>>      user space to likely change it.
>>> 4. Set groups to be used for kernel work:
>>> 	# echo '//:kernel//\ng1//:kernel//\ng1/g1m1/:kernel//\ng1/g1m2/:kernel//\ng2//:kernel/kernel_g2/\ng2/g2m1/:kernel/kernel_g2/\ng2/g2m2/:kernel/kernel_g2/\n' > info/kernel_mode_assignment
>>
>> Am I right in thinking that you want this in the info directory to avoid
>> adding files to the CTRL_MON/MON groups?
> 
> I see this file as providing the same capability as you suggested in
> https://lore.kernel.org/lkml/aYyxAPdTFejzsE42@e134344.arm.com/. The reason why I
> presented this as a single file is not because I am trying to avoid adding
> files to the CTRL_MON/MON groups but because I believe such interface enables
> resctrl to have more flexibility and support more scenarios for optimization.
> 
> As you mentioned in your proposal the solution enables a single write to move
> a task. As I thought through what resctrl needs to do on such write I saw a lot
> of similarities with mongrp_reparent() that loops through all the tasks via
> for_each_process_thread() while holding tasklist_lock. Issues with mongrp_reparent()
> holding tasklist_lock for a long time are described in [1].
> 
> While the single file does not avoid taking tasklist_lock it does give the user the
> ability to set kernel group for multiple user groups with a single write.  When user space
> does so I believe it is possible for resctrl to have an optimization that takes tasklist_lock
> just once and make changes to tasks belonging to all groups while looping through all tasks on
> system just once. With files within the CTRL_MON/MON groups setting kernel group for
> multiple user groups will require multiple writes from user space where each write requires
> looping through tasks while holding tasklist_lock during each loop. From what I learned
> from [1] something like this can be very disruptive to the rest of the system.
> 
> In summary, I see having this single file provide the same capability as the
> on-file-per-CTRL_MON/MON group since user can choose to set kernel group for user
> group one at a time but it also gives more flexibility to resctrl for optimization.
> 
> Nothing is set in stone here. There is still flexibility in this proposal to support
> PARTID and PMG assignment with a single file in each CTRL_MON/MON group if we find that
> it has the more benefits. resctrl can still expose a "per_group_assign_ctrl_assign_mon" mode
> but instead of making  "info/kernel_mode_assignment" visible when it is enabled the control file
> in CTRL_MON/MON groups are made visible ... even in this case resctrl could still add the single
> file later if deemed necessary at that time.
> 
> Considering all this, do you think resctrl should rather start with a file in each
> CTRL_MON/MON group?

From what you say, it sounds like the optimization opportunities granted
by having a single file will be necessary with some usage patterns and
so I'd be happy to start with just the single
"info/kernel_mode_assignment" file. It does mean that you need to
consider more than the current CTRL_MON directory when reading or
writing configuration but I don't see any real problem there.

> 
> Reinette
> 
> [1] https://lore.kernel.org/lkml/CALPaoCh0SbG1+VbbgcxjubE7Cc2Pb6QqhG3NH6X=WwsNfqNjtA@mail.gmail.com/ 

Thanks,

Ben


