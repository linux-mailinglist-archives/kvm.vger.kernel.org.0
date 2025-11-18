Return-Path: <kvm+bounces-63612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A8646C6BF6B
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 00:15:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 52F5235C6FD
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:15:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB19830748B;
	Tue, 18 Nov 2025 23:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HzUyfLby"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B093830C637;
	Tue, 18 Nov 2025 23:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763507712; cv=none; b=XiIsWCCjmnYUzDZqPwa14d6LiZLnDOGAxTfRA3zw04NoIxQMoRjh/bWE7P35SOWzbRwLvJ1A7ikqa4UOblrs1/LUNbimTyQNrGVbH4mEb1ce3eY4byW6YI+/bvK3d8T6y7bqVwU6RUHiUYokCXAJrq5sQg9/nTp1Yh/blD96g3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763507712; c=relaxed/simple;
	bh=ezq0GBoKks1ZDN8ylGI96mRLE71dnwsmeFSq+cT44Ac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e5UqCsG13gGcEc7VmO0UVzrJfHXxaLtou3R3Orcg0H5IE2GgL1fhObLGLM9Jm7C/cSuH2zkOUkNxLgCMumutjunCyNH4pPOEhI8+0JgsW7JxLXk6VEWTtfQ8JHEXbk02tD9jvMEsT1EWgboVtKAAhxPdsorcqThbXWARNyuVPHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HzUyfLby; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23AB5C16AAE;
	Tue, 18 Nov 2025 23:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763507712;
	bh=ezq0GBoKks1ZDN8ylGI96mRLE71dnwsmeFSq+cT44Ac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HzUyfLbyg7ek3Nu+QriMcCxO/hKGazIIEbRlgFlQayxo2GTNORTHsCFEVlQgr1oz6
	 p/o0A4emuejz9JZ49SeZ3UV5hrA0+030fm2fqPSjjB9ruLUxoiNMIE27Y381PbS/L0
	 v53FXMR+eZS+Y4c8W22A4lDromplbl3zHhl8QPjrdK08Qp4bqSCazFz8NGtmv6GokV
	 bCjJeL2sfArJc8jpT207gwC24qw1PeOkanmeoMAPnJ1i5vvD32szv1dGIUcGtKlaFl
	 P1vryDaOchQ9TkiZtUJ64BDnOJxuh1bTxXCq1c2lndVPiGlvbiODOO1817kFsdjnoK
	 H5bsZg2nN72zQ==
Date: Tue, 18 Nov 2025 15:15:07 -0800
From: Drew Fustini <fustini@kernel.org>
To: Babu Moger <bmoger@amd.com>
Cc: Babu Moger <babu.moger@amd.com>, corbet@lwn.net, tony.luck@intel.com,
	reinette.chatre@intel.com, Dave.Martin@arm.com, james.morse@arm.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	kas@kernel.org, rick.p.edgecombe@intel.com,
	akpm@linux-foundation.org, paulmck@kernel.org, frederic@kernel.org,
	pmladek@suse.com, rostedt@goodmis.org, kees@kernel.org,
	arnd@arndb.de, fvdl@google.com, seanjc@google.com,
	thomas.lendacky@amd.com, pawan.kumar.gupta@linux.intel.com,
	perry.yuan@amd.com, manali.shukla@amd.com, sohil.mehta@intel.com,
	xin@zytor.com, Neeraj.Upadhyay@amd.com, peterz@infradead.org,
	tiala@microsoft.com, mario.limonciello@amd.com,
	dapeng1.mi@linux.intel.com, michael.roth@amd.com,
	chang.seok.bae@intel.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
	kvm@vger.kernel.org, peternewman@google.com, eranian@google.com,
	gautham.shenoy@amd.com
Subject: Re: [PATCH v18 00/33] x86,fs/resctrl: Support AMD Assignable
 Bandwidth Monitoring Counters (ABMC)
Message-ID: <aRz9+475zDOEK46G@x1>
References: <cover.1757108044.git.babu.moger@amd.com>
 <aRoJAbfn+oBkc/sb@x1>
 <4102be40-7334-4845-b812-8481fbbc62ca@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4102be40-7334-4845-b812-8481fbbc62ca@amd.com>

On Mon, Nov 17, 2025 at 09:07:20AM -0600, Babu Moger wrote:
> Hi Drew,
[snip]
> Looks like you are on Zen 4 system. ABMC is available on Zen 5 or later
> servers.
> 
> #lscpu
> Vendor ID:                AuthenticAMD
> Model name:            AMD EPYC 9655 96-Core Processor
> CPU family:              26
> 
> Thanks for trying.
> 
> -Babu Moger

Thank for letting me know. I didn't realize until now that the last
digit is the Zen generation. Cherry Servers offer an EPYC 9255 so I'll
give that a try.

Drew

