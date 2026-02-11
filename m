Return-Path: <kvm+bounces-70879-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eNMKLBmxjGkvsQAAu9opvQ
	(envelope-from <kvm+bounces-70879-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:40:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E9AA126409
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:40:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 155C1301C957
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6862344038;
	Wed, 11 Feb 2026 16:40:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56A3A33DEDD;
	Wed, 11 Feb 2026 16:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770828045; cv=none; b=jTYvbVnCJheFlmG9Pt1FrdmXVaRj4UzfV7r9vXCXGS8jHsypEuSdXEEzb+vBPvnku0ci3b++B/toMg9p89g0AReOkUNkqsx9FPTI3vXl7/uy4QaXwXld1bbXShb/m+wZbgkie5UV4PAwOXm48JIZzzTpjc5UqrbYyGMOf7ocKag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770828045; c=relaxed/simple;
	bh=te/pumBu9baeeEsJwKU9xXSzHMANb+hA3vpvqVOZS7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H4irfUdU0MdT10BYlNaDt9KaM4OAwXJ1SREOiVb+FRyn2kIslRjQIehXivYUidmgHyKZAIGSR5DC8mwOqYhzDWjU2ZaInLony2fHuMD6OyoXGetOZj1Rf0jje7TBQf9sL8MBQbThe6fxRkrV2wr4hnKvdoTafC+Wt2v2gdgas8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C9C36339;
	Wed, 11 Feb 2026 08:40:35 -0800 (PST)
Received: from e134344.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 255FC3F632;
	Wed, 11 Feb 2026 08:40:35 -0800 (PST)
Date: Wed, 11 Feb 2026 16:40:32 +0000
From: Ben Horgan <ben.horgan@arm.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: "Moger, Babu" <bmoger@amd.com>, "Moger, Babu" <Babu.Moger@amd.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	Drew Fustini <fustini@kernel.org>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"Dave.Martin@arm.com" <Dave.Martin@arm.com>,
	"james.morse@arm.com" <james.morse@arm.com>,
	"tglx@kernel.org" <tglx@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"juri.lelli@redhat.com" <juri.lelli@redhat.com>,
	"vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
	"dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>,
	"bsegall@google.com" <bsegall@google.com>,
	"mgorman@suse.de" <mgorman@suse.de>,
	"vschneid@redhat.com" <vschneid@redhat.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>,
	"pmladek@suse.com" <pmladek@suse.com>,
	"feng.tang@linux.alibaba.com" <feng.tang@linux.alibaba.com>,
	"kees@kernel.org" <kees@kernel.org>,
	"arnd@arndb.de" <arnd@arndb.de>,
	"fvdl@google.com" <fvdl@google.com>,
	"lirongqing@baidu.com" <lirongqing@baidu.com>,
	"bhelgaas@google.com" <bhelgaas@google.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"xin@zytor.com" <xin@zytor.com>,
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
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
Message-ID: <aYyxAPdTFejzsE42@e134344.arm.com>
References: <cover.1769029977.git.babu.moger@amd.com>
 <17c9c0c252dcfe707dffe5986e7c98cd121f7cef.1769029977.git.babu.moger@amd.com>
 <aXk8hRtv6ATEjW8A@agluck-desk3>
 <5ec19557-6a62-4158-af82-c70bac75226f@amd.com>
 <aXpDdUQHCnQyhcL3@agluck-desk3>
 <IA0PPF9A76BB3A655A28E9695C8AD1CC59F9591A@IA0PPF9A76BB3A6.namprd12.prod.outlook.com>
 <bbe80a9a-70f0-4cd1-bd6a-4a45212aa80b@amd.com>
 <7a4ea07d-88e6-4f0f-a3ce-4fd97388cec4@intel.com>
 <1f703c24-a4a9-416e-ae43-21d03f35f0be@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1f703c24-a4a9-416e-ae43-21d03f35f0be@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_FROM(0.00)[bounces-70879-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[46];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NEQ_ENVFROM(0.00)[ben.horgan@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2E9AA126409
X-Rspamd-Action: no action

Hi,

Thanks for including me.

On Tue, Feb 10, 2026 at 10:04:48AM -0800, Reinette Chatre wrote:
> +Ben and Drew
> 
> On 2/10/26 8:17 AM, Reinette Chatre wrote:
> > Hi Babu,
> > 
> > On 1/28/26 9:44 AM, Moger, Babu wrote:
> >>
> >>
> >> On 1/28/2026 11:41 AM, Moger, Babu wrote:
> >>>> On Wed, Jan 28, 2026 at 10:01:39AM -0600, Moger, Babu wrote:
> >>>>> On 1/27/2026 4:30 PM, Luck, Tony wrote:
> >>>> Babu,
> >>>>
> >>>> I've read a bit more of the code now and I think I understand more.
> >>>>
> >>>> Some useful additions to your explanation.
> >>>>
> >>>> 1) Only one CTRL group can be marked as PLZA
> >>>
> >>> Yes. Correct.
> > 
> > Why limit it to one CTRL_MON group and why not support it for MON groups?
> > 
> > Limiting it to a single CTRL group seems restrictive in a few ways:
> > 1) It requires that the "PLZA" group has a dedicated CLOSID. This reduces the
> >    number of use cases that can be supported. Consider, for example, an existing
> >    "high priority" resource group and a "low priority" resource group. The user may
> >    just want to let the tasks in the "low priority" resource group run as "high priority"
> >    when in CPL0. This of course may depend on what resources are allocated, for example
> >    cache may need more care, but if, for example, user is only interested in memory
> >    bandwidth allocation this seems a reasonable use case?
> > 2) Similar to what Tony [1] mentioned this does not enable what the hardware is
> >    capable of in terms of number of different control groups/CLOSID that can be
> >    assigned to MSR_IA32_PQR_PLZA_ASSOC. Why limit PLZA to one CLOSID?
> > 3) The feature seems to support RMID in MSR_IA32_PQR_PLZA_ASSOC similar to
> >    MSR_IA32_PQR_ASSOC. With this, it should be possible for user space to, for
> >    example, create a resource group that contains tasks of interest and create
> >    a monitor group within it that monitors all tasks' bandwidth usage when in CPL0.
> >    This will give user space better insight into system behavior and from what I can
> >    tell is supported by the feature but not enabled?
> > 
> >>>
> >>>> 2) It can't be the root/default group
> >>>
> >>> This is something I added to keep the default group in a un-disturbed,
> > 
> > Why was this needed?
> > 
> >>>
> >>>> 3) It can't have sub monitor groups
> > 
> > Why not?
> > 
> >>>> 4) It can't be pseudo-locked
> >>>
> >>> Yes.
> >>>
> >>>>
> >>>> Would a potential use case involve putting *all* tasks into the PLZA group? That
> >>>> would avoid any additional context switch overhead as the PLZA MSR would never
> >>>> need to change.
> >>>
> >>> Yes. That can be one use case.
> >>>
> >>>>
> >>>> If that is the case, maybe for the PLZA group we should allow user to
> >>>> do:
> >>>>
> >>>> # echo '*' > tasks
> > 
> > Dedicating a resource group to "PLZA" seems restrictive while also adding many
> > complications since this designation makes resource group behave differently and
> > thus the files need to get extra "treatments" to handle this "PLZA" designation.
> > 
> > I am wondering if it will not be simpler to introduce just one new file, for example
> > "tasks_cpl0" in both CTRL_MON and MON groups. When user space writes a task ID to the
> > file it "enables" PLZA for this task and that group's CLOSID and RMID is the associated
> > task's "PLZA" CLOSID and RMID. This gives user space the flexibility to use the same
> > resource group to manage user space and kernel space allocations while also supporting
> > various monitoring use cases. This still supports the "dedicate a resource group to PLZA"
> > use case where user space can create a new resource group with certain allocations but the
> > "tasks" file will be empty and "tasks_cpl0" contains the tasks needing to run with
> > the resource group's allocations when in CPL0.

If there is a "tasks_cpl0"  then I'd expect a "cpus_cpl0" too.

> 
> It looks like MPAM has a few more capabilities here and the Arm levels are numbered differently
> with EL0 meaning user space. We should thus aim to keep things as generic as possible. For example,
> instead of CPL0 using something like "kernel" or ... ?

Yes, PLZA does open up more possibilities for MPAM usage.  I've talked to James
internally and here are a few thoughts.

If the user case is just that an option run all tasks with the same closid/rmid
(partid/pmg) configuration when they are running in the kernel then I'd favour a
mount option. The resctrl filesytem interface doesn't need to change and
userspace software doesn't need to change. This could either take away a
closid/rmid from userspace and dedicate it to the kernel or perhaps have a
policy to have the default group as the kernel group. If you use the default
configuration, at least for MPAM, the kernel may not be running at the highest
priority as a minimum bandwidth can be used to give a priority boost. (Once we
have a resctrl schema for this.)

It could be useful to have something a bit more featureful though. Is there a
need for the two mappings, task->cpl0 config and task->cpl1 to be independent or
would as task->(cp0 config, cp1 config) be sufficient? It seems awkward that
it's not a single write to move a task. If a single mapping is sufficient, then
as single new file, kernel_group,per CTRL_MON group (maybe MON groups) as
suggested above but rather than a task that file could hold a path to the
CTRL_MON/MON group that provides the kernel configuraion for tasks running in
that group. So that this can be transparent to existing software an empty string
can mean use the current group's when in the kernel (as well as for
userspace). A slash, /, could be used to refer to the default group. This would
give something like the below under /sys/fs/resctrl.

.
├── cpus
├── tasks
├── ctrl1
│   ├── cpus
│   ├── kernel_group -> mon_groups/mon1
│   └── tasks
├── kernel_group -> ctrl1
└── mon_groups
    └── mon1
        ├── cpus
        ├── kernel_group -> ctrl1
        └── tasks

> 
> I have not read anything about the RISC-V side of this yet.
> 
> Reinette
> 
> > 
> > Reinette
> > 
> > [1] https://lore.kernel.org/lkml/aXpgragcLS2L8ROe@agluck-desk3/
> 

Thanks,

Ben

