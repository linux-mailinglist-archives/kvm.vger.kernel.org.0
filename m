Return-Path: <kvm+bounces-70817-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id Y+lEGf3Pi2lBbgAAu9opvQ
	(envelope-from <kvm+bounces-70817-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 01:40:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A69A120599
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 01:40:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8208930186AC
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 00:40:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 345EA219313;
	Wed, 11 Feb 2026 00:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZJ120l/z"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60815C145;
	Wed, 11 Feb 2026 00:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770770426; cv=none; b=Np7YR5+Mb2J+RABpYSi8h6EPybGFTTu82ZTBiXnsSeC3pWkub1vfGN6oAu3pcXm3uKP7+OfFW5KMZPtVEg1cfxWMo6UkB0f8VdVOf4hszK8rffJ0WIEV5EwvVPbnj59GadwHS+uUt6r1DXG2R+1gBKupjbiFy8m1kCMitdUZA9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770770426; c=relaxed/simple;
	bh=YDyBWPm08onVp7slxg+PyGMsPp1MAexWPC++OxPk4+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u45QHoDOTX+T9WdQkEd269oTYthsxCWqSefkHVjFYsjpp3/ovJdWnJS+xKVvKSMm338HpZ9UaM2mJ7GC+NMmawA2Fy1LcO14AW1ebtZv7T7votIUGbF2pcK/eE+QoL+YTexHGfV57lOz6gs2yhK6IL1epIo6zZaSGWr/knzrr54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZJ120l/z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C05C116C6;
	Wed, 11 Feb 2026 00:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770770426;
	bh=YDyBWPm08onVp7slxg+PyGMsPp1MAexWPC++OxPk4+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZJ120l/znObnboowjFJ5TRY7Uyua+I5gmOMjaZeqvH6bmV4CUndoxNcDAzoDgqj2H
	 p94ccgkPgE1097G/y73+DqD92MeOGEj7wZ1F1TTxKd7F83SPCgttt5Q3/c9j5WjPa/
	 8v23pgaXcN4rjzDWbj2fjX3p1X7BCvv4ynaih8eLDmyFGDxHzTtk4SJ1S1LkPAbZVV
	 6DddDinC8Xft5o8qjB3eiVTgzXOZhV48/0AtsVi1+19Jo8ac6hHtROLT7f962nRr8e
	 DuTBrrK2SMlC323VsuYNrE/xhJ8C/8dyI2bY92/dTf3MTv3Tyxo8+0gqleHAt4JaQq
	 OZqieV3Np75cg==
Date: Tue, 10 Feb 2026 16:40:23 -0800
From: Drew Fustini <fustini@kernel.org>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Babu Moger <babu.moger@amd.com>,
	James Morse <james.morse@arm.com>,
	Dave Martin <Dave.Martin@arm.com>, Ben Horgan <ben.horgan@arm.com>,
	corbet@lwn.net, tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, akpm@linux-foundation.org,
	pawan.kumar.gupta@linux.intel.com, pmladek@suse.com,
	feng.tang@linux.alibaba.com, kees@kernel.org, arnd@arndb.de,
	fvdl@google.com, lirongqing@baidu.com, bhelgaas@google.com,
	seanjc@google.com, xin@zytor.com, manali.shukla@amd.com,
	dapeng1.mi@linux.intel.com, chang.seok.bae@intel.com,
	mario.limonciello@amd.com, naveen@kernel.org,
	elena.reshetova@intel.com, thomas.lendacky@amd.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, peternewman@google.com, eranian@google.com,
	gautham.shenoy@amd.com
Subject: Re: [RFC PATCH 00/19] x86,fs/resctrl: Support for Global Bandwidth
 Enforcement and Priviledge Level Zero Association
Message-ID: <aYvP98xGoKPrDBCE@gen8>
References: <cover.1769029977.git.babu.moger@amd.com>
 <aYJTfc5g_qgn--eK@agluck-desk3>
 <d2ccabb1-e1de-4767-a7b0-9d72982e52af@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2ccabb1-e1de-4767-a7b0-9d72982e52af@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70817-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[45];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[fustini@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2A69A120599
X-Rspamd-Action: no action

On Mon, Feb 09, 2026 at 04:27:47PM -0800, Reinette Chatre wrote:
> Adding Ben
> 
> On 2/3/26 11:58 AM, Luck, Tony wrote:
> > On Wed, Jan 21, 2026 at 03:12:38PM -0600, Babu Moger wrote:
> >> Privilege Level Zero Association (PLZA) 
> >>
> >> Privilege Level Zero Association (PLZA) allows the hardware to
> >> automatically associate execution in Privilege Level Zero (CPL=0) with a
> >> specific COS (Class of Service) and/or RMID (Resource Monitoring
> >> Identifier). The QoS feature set already has a mechanism to associate
> >> execution on each logical processor with an RMID or COS. PLZA allows the
> >> system to override this per-thread association for a thread that is
> >> executing with CPL=0. 
> > 
> > Adding Drew, and prodding Dave & James, for this discussion.
> > 
> > At LPC it was stated that both ARM and RISC-V already have support
> > to run kernel code with different quality of service parameters from
> > user code.

Sorry, for RISC-V, I should clarify that there is no hardware feature
that changes the QoS identifier value when switching between kernel mode
and user mode. This could be done in the kernel task switching code, but
there is no implicit hardware operation.

Thanks,
Drew

