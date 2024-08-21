Return-Path: <kvm+bounces-24685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2886595942F
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 07:40:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA55E2842AD
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 05:40:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B7C616A382;
	Wed, 21 Aug 2024 05:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n0TzNegA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1598121B;
	Wed, 21 Aug 2024 05:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724218805; cv=none; b=lkLw8Q1qvGze+vX/1Wj0sQa+Pk4KXmrQ/9A4RNHFaGJxSGEzCVfNlzRRmArFTBXz+RwxOPznR8CCa53umVi7GGzoPNYSLLePeQUB8ptRhv6eQooiVljYt1460++IQwDcPeWvJZ/5XD1iMcD8ji+KIY15x2lhWJ819Dpadmzh+KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724218805; c=relaxed/simple;
	bh=De6AjGkAhC9DVqZmF1odUmvxMgPuH+4GPvpY4OK0sk4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N2v/Rkm/e+mx5YqMXhAnayBLePkcArqwqgbA+o/3SLAbtdk84CfOhWL8d9YDRvthlDYKXEfO/riVsTbIag+ZbJc3VQe7IBlD3FYzFPDPEmCrbLPIRU8p3jI2fUGRSC1SNAYcCNcB9KIFu9Tzlph7PJSc0rkm8NLk+3cOakf8MCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n0TzNegA; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724218804; x=1755754804;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=De6AjGkAhC9DVqZmF1odUmvxMgPuH+4GPvpY4OK0sk4=;
  b=n0TzNegAxl3efgVPfkyNNRi37q6B4vTyhpumh+xVBPXqNlTPd6RMCe7Z
   1sFig6GCn5aPgEoFARaeqTkmhxB+fbYx3UnMcsFg7NOP5yd929AQW7nPc
   7fZfVBu/QlubOEZCUEglTcTUQS05DP6gfT4iBNkum0Ktn+aQQRugX2f/G
   xWkR8bkR9713QKhTOYdK6xYMCGA4ZbNXWIokITncO9CUOHpgHl/M5KSxx
   PubITQZSIPcccJsAKd5xt4XW/jq1q+fBQ4QTlUl3jw+dHrzuL9LEalEUh
   xwRQ+MxuJ1ZNzJYkdAzXVIHThD4f71KvTo5RiOvy1JoyTKoYQU09o8rHe
   g==;
X-CSE-ConnectionGUID: i1YB6ATSTKeK87XJRDEIHw==
X-CSE-MsgGUID: hqx5C6ZcTh+W3nWll6cRWg==
X-IronPort-AV: E=McAfee;i="6700,10204,11170"; a="33124164"
X-IronPort-AV: E=Sophos;i="6.10,164,1719903600"; 
   d="scan'208";a="33124164"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 22:40:03 -0700
X-CSE-ConnectionGUID: dTk6yVbzQZyT3QD43+YQ7g==
X-CSE-MsgGUID: gV98WCn1TLu+eP8xLy2Q0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,164,1719903600"; 
   d="scan'208";a="60690108"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.248])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 22:39:58 -0700
Date: Wed, 21 Aug 2024 08:39:54 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Wang, Wei W" <wei.w.wang@intel.com>
Subject: Re: [PATCH 13/25] KVM: TDX: create/destroy VM structure
Message-ID: <ZsV9qouTem-ynGJA@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-14-rick.p.edgecombe@intel.com>
 <e7c16241-100a-4830-9628-65edb44ca78d@suse.com>
 <850ef710eac95a5c36863c94e1b31a8090eb8a2a.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <850ef710eac95a5c36863c94e1b31a8090eb8a2a.camel@intel.com>

On Wed, Aug 21, 2024 at 12:23:42AM +0000, Edgecombe, Rick P wrote:
> On Mon, 2024-08-19 at 18:09 +0300, Nikolay Borisov wrote:
> > > +/*
> > > + * Some SEAMCALLs acquire the TDX module globally, and can fail with
> > > + * TDX_OPERAND_BUSY.  Use a global mutex to serialize these SEAMCALLs.
> > > + */
> > > +static DEFINE_MUTEX(tdx_lock);
> > 
> > The way this lock is used is very ugly. So it essentially mimics a lock 
> > which already lives in the tdx module. So why not simply gracefully 
> > handle the TDX_OPERAND_BUSY return value or change the interface of the 
> > module (yeah, it's probably late for this now) so expose the lock. This 
> > lock breaks one of the main rules of locking - "Lock data and not code"
> 
> Hmm, we would have to make SEAMCALLs to spin on that lock, where as mutexes can
> sleep. I suspect that is where it came from. But we are trying to make the code
> simple and obviously correct and add optimizations later. This might fit that
> pattern, especially since it is just used during VM creation and teardown.

For handling the busy retries for SEAMCALL callers, we could just use
iopoll.h read_poll_timeout(). I think it can handle toggling the resume
bit while looping, need to test that though. See for example the
smp_func_do_phymem_cache_wb() for toggling the resume variable.

The overhead of a SEAMCALL may not be that bad in the retry case.

Regards,

Tony

