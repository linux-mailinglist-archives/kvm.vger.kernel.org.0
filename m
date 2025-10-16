Return-Path: <kvm+bounces-60181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1417BBE4D58
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:23:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EA2BD4E7E64
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:23:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 327EB3161A0;
	Thu, 16 Oct 2025 17:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fPhwMCj3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D6D3346A5;
	Thu, 16 Oct 2025 17:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760635391; cv=none; b=SKAYrRUU0+dHKPqsRgxYbf2lPSMZ80t0HyN05LXHfiKMDQa2WF/vQxTautb/GjxR3IjnriT6SXi/iI58RbZN+tLakFRnDNOMA6qMNzZLz8nxFn51JvWG8cROjxBxfMCaij1B1O8znjPrcDxJAQJw3lvXaoGw0cEPFW1qUJU4Nfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760635391; c=relaxed/simple;
	bh=lOFgD0LyfRpzUx+oLqOf3WVoQ7V6BqFdDH6cnaanqgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oI0kgK6Jtia/OJ1iBqjREwT+uDkJTncgZocjyUjjONissIw5/pbCf5gM5ty/kV8dFnJ3JewEZahzqjN5dyUK6t61vtc8LqUCJnXV69ip/3kT0ZPZaLabxISdDqn2ovKssFmbXFtFLEvxT9SnV/Ux8uEsXAz4BnCnEge36UjR81A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fPhwMCj3; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760635389; x=1792171389;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lOFgD0LyfRpzUx+oLqOf3WVoQ7V6BqFdDH6cnaanqgo=;
  b=fPhwMCj3OBL59L+Z5EkAn34TrzxhNJXo8EARJepZ58c62TgDL/DqwU8q
   IFYayBpFfkseDv8ehb3NIl2SeyEev3NVSll0C9STBi7DN9zrf8dVAznoG
   6Y9KDxdV9/9QxC+XgO1i7kxqk6PUrE9aOlRYZLKkUx5immeAGo3P2jKsc
   sHsHXCEsX2jo4IgMwSqTzPvgR33Pl2uTa3pDuPHxPD8fwQcngV4wVgXRX
   HLixdREGV+0ImEGQQ0bojozjfCCj7fq0ydeqYhLKU0c7XknhRRdOOdPdi
   1R3ym7M+MBje+MJlShv82dS2U3EvGN91jhbikZbXuTIiiDSkY9DEojTQM
   w==;
X-CSE-ConnectionGUID: hFz+b6OuTpu1Kfj7sFu7nA==
X-CSE-MsgGUID: a/zmjVqmS5SvT2h3BdinnQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11584"; a="85457800"
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="85457800"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 10:23:09 -0700
X-CSE-ConnectionGUID: MXhEq54OR0Kwe43Clpyhuw==
X-CSE-MsgGUID: KZF5q4xDSRCvSLO3AjAmdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="187788426"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO desk) ([10.124.223.124])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 10:23:08 -0700
Date: Thu, 16 Oct 2025 10:23:02 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: "Kaplan, David" <David.Kaplan@amd.com>
Cc: "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH v2 0/3] VMSCAPE optimization for BHI variant
Message-ID: <20251016172302.a6uin2qqqyxmufxc@desk>
References: <20251015-vmscape-bhb-v2-0-91cbdd9c3a96@linux.intel.com>
 <DS0PR12MB9273669FB9A3DBE8F53C51FA94E9A@DS0PR12MB9273.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR12MB9273669FB9A3DBE8F53C51FA94E9A@DS0PR12MB9273.namprd12.prod.outlook.com>

On Thu, Oct 16, 2025 at 03:57:56PM +0000, Kaplan, David wrote:
> [AMD Official Use Only - AMD Internal Distribution Only]
> 
> > -----Original Message-----
> > From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > Sent: Wednesday, October 15, 2025 8:52 PM
> > To: x86@kernel.org; H. Peter Anvin <hpa@zytor.com>; Josh Poimboeuf
> > <jpoimboe@kernel.org>; Kaplan, David <David.Kaplan@amd.com>; Sean
> > Christopherson <seanjc@google.com>; Paolo Bonzini <pbonzini@redhat.com>
> > Cc: linux-kernel@vger.kernel.org; kvm@vger.kernel.org; Asit Mallick
> > <asit.k.mallick@intel.com>; Tao Zhang <tao1.zhang@intel.com>
> > Subject: [PATCH v2 0/3] VMSCAPE optimization for BHI variant
> >
> > Caution: This message originated from an External Source. Use proper caution
> > when opening attachments, clicking links, or responding.
> >
> >
> > v2:
> > - Added check for IBPB feature in vmscape_select_mitigation(). (David)
> > - s/vmscape=auto/vmscape=on/ (David)
> > - Added patch to remove LFENCE from VMSCAPE BHB-clear sequence.
> > - Rebased to v6.18-rc1.
> >
> > v1: https://lore.kernel.org/r/20250924-vmscape-bhb-v1-0-
> > da51f0e1934d@linux.intel.com
> >
> > Hi All,
> >
> > These patches aim to improve the performance of a recent mitigation for
> > VMSCAPE[1] vulnerability. This improvement is relevant for BHI variant of
> > VMSCAPE that affect Alder Lake and newer processors.
> >
> > The current mitigation approach uses IBPB on kvm-exit-to-userspace for all
> > affected range of CPUs. This is an overkill for CPUs that are only affected
> > by the BHI variant. On such CPUs clearing the branch history is sufficient
> > for VMSCAPE, and also more apt as the underlying issue is due to poisoned
> > branch history.
> >
> > Roadmap:
> >
> > - First patch introduces clear_bhb_long_loop() for processors with larger
> >   branch history tables.
> > - Second patch replaces IBPB on exit-to-userspace with branch history
> >   clearing sequence.
> >
> > Below is the iPerf data for transfer between guest and host, comparing IBPB
> > and BHB-clear mitigation. BHB-clear shows performance improvement over IBPB
> > in most cases.
> >
> > Platform: Emerald Rapids
> > Baseline: vmscape=off
> >
> > (pN = N parallel connections)
> >
> > | iPerf user-net | IBPB    | BHB Clear |
> > |----------------|---------|-----------|
> > | UDP 1-vCPU_p1  | -12.5%  |   1.3%    |
> > | TCP 1-vCPU_p1  | -10.4%  |  -1.5%    |
> > | TCP 1-vCPU_p1  | -7.5%   |  -3.0%    |
> > | UDP 4-vCPU_p16 | -3.7%   |  -3.7%    |
> > | TCP 4-vCPU_p4  | -2.9%   |  -1.4%    |
> > | UDP 4-vCPU_p4  | -0.6%   |   0.0%    |
> > | TCP 4-vCPU_p4  |  3.5%   |   0.0%    |
> >
> > | iPerf bridge-net | IBPB    | BHB Clear |
> > |------------------|---------|-----------|
> > | UDP 1-vCPU_p1    | -9.4%   |  -0.4%    |
> > | TCP 1-vCPU_p1    | -3.9%   |  -0.5%    |
> > | UDP 4-vCPU_p16   | -2.2%   |  -3.8%    |
> > | TCP 4-vCPU_p4    | -1.0%   |  -1.0%    |
> > | TCP 4-vCPU_p4    |  0.5%   |   0.5%    |
> > | UDP 4-vCPU_p4    |  0.0%   |   0.9%    |
> > | TCP 1-vCPU_p1    |  0.0%   |   0.9%    |
> >
> > | iPerf vhost-net | IBPB    | BHB Clear |
> > |-----------------|---------|-----------|
> > | UDP 1-vCPU_p1   | -4.3%   |   1.0%    |
> > | TCP 1-vCPU_p1   | -3.8%   |  -0.5%    |
> > | TCP 1-vCPU_p1   | -2.7%   |  -0.7%    |
> > | UDP 4-vCPU_p16  | -0.7%   |  -2.2%    |
> > | TCP 4-vCPU_p4   | -0.4%   |   0.8%    |
> > | UDP 4-vCPU_p4   |  0.4%   |  -0.7%    |
> > | TCP 4-vCPU_p4   |  0.0%   |   0.6%    |
> >
> > [1] https://comsec.ethz.ch/research/microarch/vmscape-exposing-and-exploiting-
> > incomplete-branch-predictor-isolation-in-cloud-environments/
> >
> > ---
> > Pawan Gupta (3):
> >       x86/bhi: Add BHB clearing for CPUs with larger branch history
> >       x86/vmscape: Replace IBPB with branch history clear on exit to userspace
> >       x86/vmscape: Remove LFENCE from BHB clearing long loop
> >
> >  Documentation/admin-guide/hw-vuln/vmscape.rst   |  8 ++++
> >  Documentation/admin-guide/kernel-parameters.txt |  4 +-
> >  arch/x86/entry/entry_64.S                       | 63 ++++++++++++++++++-------
> >  arch/x86/include/asm/cpufeatures.h              |  1 +
> >  arch/x86/include/asm/entry-common.h             | 12 +++--
> >  arch/x86/include/asm/nospec-branch.h            |  5 +-
> >  arch/x86/kernel/cpu/bugs.c                      | 53 +++++++++++++++------
> >  arch/x86/kvm/x86.c                              |  5 +-
> >  8 files changed, 110 insertions(+), 41 deletions(-)
> > ---
> > base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
> > change-id: 20250916-vmscape-bhb-d7d469977f2f
> >
> > Best regards,
> > --
> > Pawan
> >
> 
> Looks good to me.
> 
> Acked-by: David Kaplan <david.kaplan@amd.com>

Thanks.

