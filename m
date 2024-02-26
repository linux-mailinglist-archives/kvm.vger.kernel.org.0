Return-Path: <kvm+bounces-9957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 451A4867F8C
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:07:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 765471C2BCC4
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 18:07:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADA3412F361;
	Mon, 26 Feb 2024 18:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fvBEiuVT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEFE1292FF;
	Mon, 26 Feb 2024 18:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708970835; cv=none; b=ssG1FU8VXYO8nP6NbJzAPOZIwbU5Zwa2/OFiUt437aKKNze/QMWr/jNjfWHbRBv2w+nUWSFyftPf5Bd7l9MHWGxqxEV7KBE15A4mXcRcMxdnpFfdxwSXT5nAIYTV2TNJGctvddLdkAQ/MsOEZEgeeFxKVtTd4jb4c9ZVFZr4R6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708970835; c=relaxed/simple;
	bh=Ah4K95o9NohIieqV9hLq8pAEFQiM8C/l4p3fKUsB1Ts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PP5+zTXmkXmFWh5mByxaIY5g2X8KwSUKVEW9Y+AJh87zklXupN4kqp+Wag0xH/NDwscAb6B/ednLqi/H0p+1beqKqFBQNCdiFvljv5GsThZrX74735e3o4CCg1oIuAH1Ct9GK2PRircGI7Y+BbD+LHZUT8twiUJwd9pVCXh+SIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fvBEiuVT; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708970834; x=1740506834;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Ah4K95o9NohIieqV9hLq8pAEFQiM8C/l4p3fKUsB1Ts=;
  b=fvBEiuVTXYhlQ4UzO7+DIUYX2N1EPXi/fg9jANJxGv7ZFemOT7pBdE+N
   vi30mvW4qSI5f/M8vQdsZHJ5Eb6dLdKrCDY7+6KjRRlPONDqPCViPjT/r
   5fIbGSs58u8nv0BNjuiDsF4WjpxmFiQLqUrNUmGssdTc1qsztZYNpIW5m
   0dLZJmUrgmJSNUb1/PBBGy8HK6z6vJIXOmNuyVxStAbrt+RT8FJbCNlYN
   9U3BirY+XmkqJd6zFSFghLCpQwtn+lgE7KQfTcimGZ6zB8VXZfiniMuTV
   DX66uUqh6FZMnFyMH2fAng6odZPl74Johx19xXUPw8hfL3I2++WH4mjtl
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="13913522"
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="13913522"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 10:07:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="29927118"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 10:07:12 -0800
Date: Mon, 26 Feb 2024 10:07:12 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: David Matlack <dmatlack@google.com>
Cc: Sean Christopherson <seanjc@google.com>, isaku.yamahata@intel.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com, gkirkpatrick@google.com,
	Vipin Sharma <vipinsh@google.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v18 064/121] KVM: TDX: Create initial guest memory
Message-ID: <20240226180712.GF177224@ls.amr.corp.intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <97bb1f2996d8a7b828cd9e3309380d1a86ca681b.1705965635.git.isaku.yamahata@intel.com>
 <Zbrj5WKVgMsUFDtb@google.com>
 <CALzav=diVvCJnJpuKQc7-KeogZw3cTFkzuSWu6PLAHCONJBwhg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=diVvCJnJpuKQc7-KeogZw3cTFkzuSWu6PLAHCONJBwhg@mail.gmail.com>

On Thu, Feb 01, 2024 at 03:06:46PM -0800,
David Matlack <dmatlack@google.com> wrote:

> +Vipin Sharma
> 
> On Wed, Jan 31, 2024 at 4:21 PM Sean Christopherson <seanjc@google.com> wrote:
> > On Mon, Jan 22, 2024, isaku.yamahata@intel.com wrote:
> >
> > The real reason for this drive-by pseudo-review is that I am hoping/wishing we
> > can turn this into a generic KVM ioctl() to allow userspace to pre-map guest
> > memory[*].
> >
> > If we're going to carry non-trivial code, we might as well squeeze as much use
> > out of it as we can.
> >
> > Beyond wanting to shove this into KVM_MEMORY_ENCRYPT_OP, is there any reason why
> > this is a VM ioctl() and not a vCPU ioctl()?  Very roughly, couldn't we use a
> > struct like this as input to a vCPU ioctl() that maps memory, and optionally
> > initializes memory from @source?
> >
> >         struct kvm_memory_mapping {
> >                 __u64 base_gfn;
> >                 __u64 nr_pages;
> >                 __u64 flags;
> >                 __u64 source;
> >         }
> >
> > TDX would need to do special things for copying the source, but beyond that most
> > of the code in this function is generic.
> >
> > [*] https://lore.kernel.org/all/65262e67-7885-971a-896d-ad9c0a760907@polito.it
> 
> We would also be interested in such an API to reduce the guest
> performance impact of intra-host migration.

I introduce KVM_MEMORY_MAPPING and KVM_CAP_MEMORY_MAPPING with v19.
We can continue the discussion there.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

