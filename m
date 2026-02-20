Return-Path: <kvm+bounces-71397-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wFxcCSsamGki/wIAu9opvQ
	(envelope-from <kvm+bounces-71397-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 09:24:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B7E20165A06
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 09:24:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 24B1930177AD
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 08:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06F813358C2;
	Fri, 20 Feb 2026 08:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FgkUk6Dv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39294450FE;
	Fri, 20 Feb 2026 08:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771575696; cv=none; b=jCD2o5hVIOWN5G645Qfen6DxKuR//2KnzzNuQjLMvT7i9Hn64XaWYHeJvz88ad1yYwf1qDbNg1/NSqOsQ6MrtpU7OYCdBefENX+ry95paISUk4ykuRd5GnMR9MO/k1aq34Ozny1M7IdLRNUXJD5UXyxMdy6e7AW9UqGuB5hmXKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771575696; c=relaxed/simple;
	bh=GM8hqgp2xDJs2WYwtAFTGpm0Wj5XA2UIvyI/Hw25yUI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gycHOzgK1zgIDCdyMgH+qwNc9D8GxUPAsnxSIS6VdcjeVHaSDhKPvu/xB48WRDld0/SdXIwuOVulj/agBlH+jBhASHP+X6C0zFkuEOEGMsJ6YSMLoYdfwLtgd+u0xCkXPqyY60xVRg3K7Ud6PKAkyj1SN7EXeJ2SbzJw7EoQv/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FgkUk6Dv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCCEC116C6;
	Fri, 20 Feb 2026 08:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771575695;
	bh=GM8hqgp2xDJs2WYwtAFTGpm0Wj5XA2UIvyI/Hw25yUI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FgkUk6DvexTH0mdmt9hn9+WMcRlVPMyGxqxZfbU8rpo1KCSDEmTMpGdXYxYuCmArO
	 TZu86Bh8/UJc+a68MGLnkSZHrobVFuJcLxdgyqmpd6dv19kzIc4JOCOF9viLAcIqDr
	 9R5fVzyfs8uyngIVRZs0Zkqg6W7IYpr1JsRQ+JQtFT6983hMHbMBEXrQyuxMirWXem
	 7Jnlb8LZk9ZojBSzko85TIZLY8qdWVujnRwMvG7Zxbkwfgj2hEtxlxBugCHxAGAy2z
	 OqgPGFWGCiSB2yDVyF8rHSo6EA5FBpWUOFq+IRtJqHzoNa92m6N/YWX6UjZQjUCJ5n
	 jgGMhne/JtCug==
Date: Fri, 20 Feb 2026 00:21:33 -0800
From: Drew Fustini <fustini@kernel.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Ben Horgan <ben.horgan@arm.com>, "Moger, Babu" <bmoger@amd.com>,
	"Moger, Babu" <Babu.Moger@amd.com>,
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
Message-ID: <aZgZjVAsWg6v6DgL@x1>
References: <aY3bvKeOcZ9yG686@e134344.arm.com>
 <2b2d0168-307a-40c3-98fa-54902482e861@intel.com>
 <aZM1OY7FALkPWmh6@e134344.arm.com>
 <d704ea1f-ed9f-4814-8fce-81db40b1ee3c@intel.com>
 <aZThTzdxVcBkLD7P@agluck-desk3>
 <2416004a-5626-491d-819c-c470abbe0dd0@intel.com>
 <aZTxJTWzfQGRqg-R@agluck-desk3>
 <65c279fd-0e89-4a6a-b217-3184bd570e23@intel.com>
 <aZXsihgl0B-o1DI6@agluck-desk3>
 <aZdCWCTDa777gfC9@agluck-desk3>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZdCWCTDa777gfC9@agluck-desk3>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71397-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[46];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[fustini@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B7E20165A06
X-Rspamd-Action: no action

On Thu, Feb 19, 2026 at 09:03:20AM -0800, Luck, Tony wrote:
> > Likely real implementation:
> > 
> > Sub-components of each of the ideas above are encoded as a bitmask that
> > is written to plza_mode. There is a file in the info/ directory listing
> > which bits are supported on the current system (e.g. the "keep the same
> > RMID" mode may be impractical on ARM, so it would not be listed as an
> > option.)
> 
> 
> In x86 terms where control and monitor functions are independent we
> have:
> 
> Control:
> 1) Use default (CLOSID==0) for kernel
> 2) Allocate just one CLOSID for kernel
> 3) Allocate many CLOSIDs for kernel
> 
> Monitor:
> 1) Do not monitor kernel separately from user
> 2) Use default (RMID==0) for kernel
> 3) Allocate one RMID for kernel
> 4) Allocate many RMIDs for kernel
> 
> What options are possible on ARM & RISC-V?

The RISC-V Ssqosid extension just adds one register to each processor
which contains a single resource control id (rcid) and a single
monitoring control id (mcid). Any switching of rcid or mcid between
kernel mode and user mode would need to be done manually by the kernel
on entry/exit.

Thanks,
Drew

