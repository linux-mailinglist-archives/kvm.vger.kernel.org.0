Return-Path: <kvm+bounces-63297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 86339C61996
	for <lists+kvm@lfdr.de>; Sun, 16 Nov 2025 18:25:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 535DF35F57C
	for <lists+kvm@lfdr.de>; Sun, 16 Nov 2025 17:25:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAEA530F947;
	Sun, 16 Nov 2025 17:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hSysxEte"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D162D21FF2E;
	Sun, 16 Nov 2025 17:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763313923; cv=none; b=WSmWGRsOV0+tL4pbbGTukS2r+wectwG/1lqtIATDn14D9utenZUU+Osmzcx/Y/GFLt8URQtzQYka6dBuAZ484IW6tdz2rhBHtS8eODyYxeDskVgKrKP20D6LHd4Z9tdHTpmRxVjMzeD2iRtHzLybNDMMSWBj8gV3hnlT6TY1+yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763313923; c=relaxed/simple;
	bh=PnQmzRvxYj3xJBIpIHJUKlkpSpQzmHG2z4omra3y988=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dKn2OoX5/sF8y6Reg0Jf6oI8mKPhbHxZiOBt3c17ytXgCzCNQVFb/+OnZqYVsZg9TH0brUdYbB9PiMzGzKVm84cRvUIvjP1ZXwPmcjVIWfgOt/kf3b9v7h8uZVZeqahacKgOiekWisj2p2P68JZnrwAh2mftQYXSv6iXZpzILw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hSysxEte; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D92C4CEF1;
	Sun, 16 Nov 2025 17:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763313923;
	bh=PnQmzRvxYj3xJBIpIHJUKlkpSpQzmHG2z4omra3y988=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hSysxEte094y1ePz44qMmh8youDVXxpi8kQBZj/KjrhDUlj7q6RA64kBQPlvr4LJK
	 Wf71HhtuIJfu/XRtVtGAiujx5mHtlcUQ0JxLLko+kKlocKZHAIQfiBfJLec0LLC7F7
	 LDAxNcFb4kD55M++D5XSI8KZeDS7XIRJuXEraXXqO7bbSFHqcgSE12b1V6SQvv4O+r
	 lsLARY34VB3V0CdCA+YNW2ConRyTmCz5Sn7Ehdq+M+eX91JQJAxRFeMzcgdHs34Ldr
	 fh1qWjIPRvKceg6MxCMeTH+jeERISQ6eWQLPQKIP1+f+etevLO6Bb6H9aCnk3pjm3z
	 MPaygpLiC0Ctg==
Date: Sun, 16 Nov 2025 09:25:21 -0800
From: Drew Fustini <fustini@kernel.org>
To: Babu Moger <babu.moger@amd.com>
Cc: corbet@lwn.net, tony.luck@intel.com, reinette.chatre@intel.com,
	Dave.Martin@arm.com, james.morse@arm.com, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, kas@kernel.org,
	rick.p.edgecombe@intel.com, akpm@linux-foundation.org,
	paulmck@kernel.org, frederic@kernel.org, pmladek@suse.com,
	rostedt@goodmis.org, kees@kernel.org, arnd@arndb.de,
	fvdl@google.com, seanjc@google.com, thomas.lendacky@amd.com,
	pawan.kumar.gupta@linux.intel.com, perry.yuan@amd.com,
	manali.shukla@amd.com, sohil.mehta@intel.com, xin@zytor.com,
	Neeraj.Upadhyay@amd.com, peterz@infradead.org, tiala@microsoft.com,
	mario.limonciello@amd.com, dapeng1.mi@linux.intel.com,
	michael.roth@amd.com, chang.seok.bae@intel.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-coco@lists.linux.dev, kvm@vger.kernel.org,
	peternewman@google.com, eranian@google.com, gautham.shenoy@amd.com
Subject: Re: [PATCH v18 00/33] x86,fs/resctrl: Support AMD Assignable
 Bandwidth Monitoring Counters (ABMC)
Message-ID: <aRoJAbfn+oBkc/sb@x1>
References: <cover.1757108044.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1757108044.git.babu.moger@amd.com>

On Fri, Sep 05, 2025 at 04:33:59PM -0500, Babu Moger wrote:
> 
> This series adds the support for Assignable Bandwidth Monitoring Counters
> (ABMC). It is also called QoS RMID Pinning feature.
> 
> Series is written such that it is easier to support other assignable
> features supported from different vendors.

Is there a way to find out which EPYC parts support ABMC?

I'm rebasing the RISC-V resctrl support on 6.18 and I noticed there are
a lot of changes to how events work. I've been reading the ABMC code
but I would like to get a better feel for how it works.

I found an EPYC 9124P on Cherry Servers which I was able to experiment
with using resctrl on x86. It has the following in cpuinfo:

cat_l3 cdp_l3 cqm cqm_llc cqm_mbm_local cqm_mbm_total cqm_occup_llc mba

It also has SMBA and BMEC based on the contents of /sys/fs/resctrl.

Ideally, I'd like to find a bare metal EPYC server that has ABMC, too.

Thanks,
Drew

