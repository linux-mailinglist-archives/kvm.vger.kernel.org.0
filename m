Return-Path: <kvm+bounces-51188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C7A59AEF81B
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 14:15:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF1B316776F
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 12:15:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E58371F2B88;
	Tue,  1 Jul 2025 12:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LZwod6IY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8364F273808
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 12:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751372123; cv=none; b=qCw3eu5UnE18d0YVDnQ1emYN6LZoCrTKkseCvBYrLzfjMnMgrfzQkvhX/pfbIKeTiB0fyR5ofeiJa/vyOwujMuoMJxWEfDxRnA2oda9DI2EShlOPfVlCVUbEfWm28JV0ELPkxwzTIr+3WQYizGMpIMyKrmJUpg9eHbdRj4EwuZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751372123; c=relaxed/simple;
	bh=+8OWmjwP/2bYJlYBUultibyNB+P9/EIDBMLVEEFej3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HehdETcMxLERhXSX98mv08eA087NZ30M7cVsx4QPpR2foVOeXjGhZQN/R8qzy73KtrJz/vpF/uwtO6FZpbJmlqL3YA1nEbbB5Z1gApvYlTZhQUlud5YSEATH+PaHvbPyXb0scYk7RJcJ7dudBOGNhSsB/OC7T4rX0ySqFzMww2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LZwod6IY; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751372122; x=1782908122;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+8OWmjwP/2bYJlYBUultibyNB+P9/EIDBMLVEEFej3o=;
  b=LZwod6IY+irj9fLefzG0pIwdypvHIwlPTSlJaA9pDJ9OvM26Wf+iSFwa
   tfZqa+0Ji6qY/tmOZkMp+7oJfunmAno3QOWMsdmcG180E3Uu58YLT/8Ko
   Q6tXCdppWtGUkTmszVwb0UAbZk/+cVvQiluznvdOjdd2T7pmm8H7eCLeU
   jFZKYZwBjsHJcDxKVY3c7G0C+NiVzWB42DOPFstIKeGnb+oKnBjliKRyk
   vSb4vcX/u68M06TdUZzlNhKxLOEBaNDkSLeck0fRN0F4S2wk3WvSUQD+V
   TVW5ErmPpaCAKjAh8SLaGhclVT6m+zWQY1fszwTve7xiKYEY09sqgr+JZ
   A==;
X-CSE-ConnectionGUID: We9ES9uDSNe6fqa8NqnSSg==
X-CSE-MsgGUID: iF6Kd8YCT4yBEvhx1Q9YGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="57314835"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="57314835"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 05:15:21 -0700
X-CSE-ConnectionGUID: RPuwhi74RuaLHkGVvKCWPA==
X-CSE-MsgGUID: t/tWrUs9ThG5f4jyYfWgZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="153530875"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa009.jf.intel.com with ESMTP; 01 Jul 2025 05:15:18 -0700
Date: Tue, 1 Jul 2025 20:36:43 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Alexandre Chartre <alexandre.chartre@oracle.com>, qemu-devel@nongnu.org,
	pbonzini@redhat.com, qemu-stable@nongnu.org, konrad.wilk@oracle.com,
	boris.ostrovsky@oracle.com, maciej.szmigiero@oracle.com,
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be advertised on
 AMD
Message-ID: <aGPWW/joFfohy05y@intel.com>
References: <20250630133025.4189544-1-alexandre.chartre@oracle.com>
 <aGO3vOfHUfjgvBQ9@intel.com>
 <c6a79077-024f-4d2f-897c-118ac8bb9b58@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6a79077-024f-4d2f-897c-118ac8bb9b58@intel.com>

On Tue, Jul 01, 2025 at 07:12:44PM +0800, Xiaoyao Li wrote:
> Date: Tue, 1 Jul 2025 19:12:44 +0800
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> Subject: Re: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be advertised
>  on AMD
> 
> On 7/1/2025 6:26 PM, Zhao Liu wrote:
> > > unless it was explicitly requested by the user.
> > But this could still break Windows, just like issue #3001, which enables
> > arch-capabilities for EPYC-Genoa. This fact shows that even explicitly
> > turning on arch-capabilities in AMD Guest and utilizing KVM's emulated
> > value would even break something.
> > 
> > So even for named CPUs, arch-capabilities=on doesn't reflect the fact
> > that it is purely emulated, and is (maybe?) harmful.
> 
> It is because Windows adds wrong code. So it breaks itself and it's just the
> regression of Windows.

Could you please tell me what the Windows's wrong code is? And what's
wrong when someone is following the hardware spec?

Do you expect software developers to make special modifications for QEMU
after following the hardware spec? Or do you categorize this behavior as
paravirtualization?

Resolving this issue within QEMU is already a win-win approach. I don't
understand why you're shifting the blame onto Windows.

> KVM and QEMU are not supposed to be blamed.

I do not think I'm blaming anything. So many people report
this bug issue in QEMU community, and maintainer suggested a solution.

I totally agree on this way, and provide feedback to help thoroughly
resolve the issue and prevent similar situations from happening again.

That's all.

Thanks,
Zhao



