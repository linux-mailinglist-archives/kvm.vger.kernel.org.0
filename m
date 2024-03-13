Return-Path: <kvm+bounces-11753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD67787AFC0
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 19:34:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 687BB289E5C
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 18:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96F137CF34;
	Wed, 13 Mar 2024 17:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FShHlpCc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9A77CF17;
	Wed, 13 Mar 2024 17:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710350076; cv=none; b=lNOPSS2uzQB5uERJJ4tro4R/mDvjSlcSkxu7jk/XBvWu/Rd09+AVJDJUlbZU9O/I5jk1002sIfGTVYgRELKOqrwxVF89yZo0fx983hhoypF3iYbJnDZduHyS+98MnAB1zugfobR+82vq4eQAtbnZLsxg1/6OPK97dMpqDyxkO9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710350076; c=relaxed/simple;
	bh=yd+LQyIBKkRzDjOGx/9XTYnW/gs4JXp/mmcKcMds5kM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YZFKcF0nq1W4GSbYwUFMFdm1G0NZnBO1wEqEGTpz04F8nPH2TUIUEOXFZ3zGtXZyP7zNi31pGjXvV2xhW6lfp7CmtAc3jXQANH+9t0sVvFweJJJvWptEXlzz3E7HVUpfQutrPgqdsr8o8JHt9MoCri3JuKjdIpvFNqQLwP81Xkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FShHlpCc; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710350074; x=1741886074;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=yd+LQyIBKkRzDjOGx/9XTYnW/gs4JXp/mmcKcMds5kM=;
  b=FShHlpCc2LBXvcjsIaDEedOUdp5/hqnEATFKicMEbUgRpQseBkfoNFO7
   2JGU7neGkH0n6F+DspAwyKX+QuqooXFf0s0yHHJcBwLJHRzydarts+ef9
   GIt+1czhtOeCrfhgNEgOTjc497PuEjHXLo+5AQ4L/jmyyZZhUs3/L81va
   Mgqx1Y91cYTsl9v8aPyqeYCmYzXapoxAqPSId8AgLCOJIh177aG2nI0Nj
   59FvtsjUzLepvCDmKIf/OdooPplkZb7hFDrZBgJOh6DE1QLulV8BKkASz
   IgdGhwwhNwucTvH4KGwK4XaU2SLhrptjGCmv9SkKjfutha2/zW9pahOFf
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11012"; a="15688327"
X-IronPort-AV: E=Sophos;i="6.07,123,1708416000"; 
   d="scan'208";a="15688327"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 10:14:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,123,1708416000"; 
   d="scan'208";a="16581412"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 10:14:33 -0700
Date: Wed, 13 Mar 2024 10:14:28 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 011/130] KVM: Add new members to struct kvm_gfn_range
 to operate on
Message-ID: <20240313171428.GK935089@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <e324ff5e47e07505648c0092a5370ac9ddd72f0b.1708933498.git.isaku.yamahata@intel.com>
 <2daf03ae-6b5a-44ae-806e-76d09fb5273b@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2daf03ae-6b5a-44ae-806e-76d09fb5273b@linux.intel.com>

On Tue, Mar 12, 2024 at 09:33:31PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Add new members to strut kvm_gfn_range to indicate which mapping
> > (private-vs-shared) to operate on.  only_private and only_shared.  Update
> > mmu notifier, set memory attributes ioctl or KVM gmem callback to
> > initialize them.
> > 
> > It was premature for set_memory_attributes ioctl to call
> > kvm_unmap_gfn_range().  Instead, let kvm_arch_ste_memory_attributes()
> "kvm_arch_ste_memory_attributes()" -> "kvm_vm_set_mem_attributes()" ?

Yes, will fix it.

> > handle it and add a new x86 vendor callback to react to memory attribute
> > change.  [1]
> Which new x86 vendor callback?

Now we don't have it. Will drop this sentnse.

> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 7e7fd25b09b3..0520cd8d03cc 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -264,6 +264,8 @@ struct kvm_gfn_range {
> >   	gfn_t start;
> >   	gfn_t end;
> >   	union kvm_mmu_notifier_arg arg;
> > +	bool only_private;
> > +	bool only_shared;
> 
> IMO, an enum will be clearer than the two flags.
> 
>     enum {
>         PROCESS_PRIVATE_AND_SHARED,
>         PROCESS_ONLY_PRIVATE,
>         PROCESS_ONLY_SHARED,
>     };

The code will be ugly like
"if (== PRIVATE || == PRIVATE_AND_SHARED)" or
"if (== SHARED || == PRIVATE_AND_SHARED)"

two boolean (or two flags) is less error-prone.

Thanks,
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

