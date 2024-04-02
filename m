Return-Path: <kvm+bounces-13335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D65E4894B32
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 08:16:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9268D28217D
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 06:16:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F35D41B5A0;
	Tue,  2 Apr 2024 06:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dbhgBSBQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC0F18AE0;
	Tue,  2 Apr 2024 06:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712038603; cv=none; b=t074ntB0TRXH51RKf8kqp8iRk5t5txF5+XYYt/7OcFdF8ViIgtWB906x7+xkIYOCv3fNeiZ9HAymY+MUXX4W5aeaDtgG+fMjlhMfgaqy8H+0T/4FoEr2fVvaaCS9qktRKQG49D7Wz43AfO58f5nJPau825Y0/YyhW4OjRSKDX7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712038603; c=relaxed/simple;
	bh=3s6+yfpcjk1UQYeizUJGF8w4rgO9afQPaAs8wrXqY1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GXdCAIri1u2La+bOV+GQxmh207bNslAksprv13EJ0L6qkPlYUAnt9cXKNesl1btHaZpAEZku5q2MqX2HC+yi8kWzRgYuvSZ3amT+hhUyPy2VJiww7SmJJemTfDoxz/jGCNOpBBNOFmz8x0gNh4w/mIV36/5fr7gaTEsKwJWGCn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dbhgBSBQ; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712038602; x=1743574602;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3s6+yfpcjk1UQYeizUJGF8w4rgO9afQPaAs8wrXqY1Y=;
  b=dbhgBSBQbu0Bw/dw8YuM+VK6pkzJT0yd5z8tD78jSsriWaii946s+B+Z
   k4c/hKn41Hs0SyGDllFr4AkamIt1oNPibSsJqwi2cNTZZ2JZ14qITxk31
   euDIVvGgD200vDyeBK80KUuN8orMVmKtFdctezj2d4rB6XCsiskNQM+vs
   Oq+yL7BmXA9w7+Itj3IuzgcjITCH1LiZHSORCnuKsnTN5FUFvDZm3HNeD
   Hobm2FFAdyC2lrtZyLWKI9T8zikq8xcMvt38I7bmmeyHBckhPb9ZUksE7
   qJTjbbPdHV+f8VQHTlat5fn7lZwopjAsJBNzqZxm7SQvpYrG0oUEvBvZS
   g==;
X-CSE-ConnectionGUID: JrAfhIceTpuwf1L2jFsEKg==
X-CSE-MsgGUID: BudWJud3SP2g8+9I4NwUjQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11031"; a="7123915"
X-IronPort-AV: E=Sophos;i="6.07,174,1708416000"; 
   d="scan'208";a="7123915"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 23:16:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,174,1708416000"; 
   d="scan'208";a="22400098"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 23:16:39 -0700
Date: Mon, 1 Apr 2024 23:16:39 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
Message-ID: <20240402061639.GW2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
 <a0627c0f-5c2d-4403-807f-fc800b43fd3b@intel.com>
 <20240327225337.GF2444378@ls.amr.corp.intel.com>
 <4d925a79-d3cf-4555-9c00-209be445310d@intel.com>
 <20240328053432.GO2444378@ls.amr.corp.intel.com>
 <65a1a35e0a3b9a6f0a123e50ec9ddb755f70da52.camel@intel.com>
 <20240328203902.GP2444378@ls.amr.corp.intel.com>
 <71e6fa91-065c-4b28-ac99-fa71dfd499b9@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <71e6fa91-065c-4b28-ac99-fa71dfd499b9@linux.intel.com>

On Fri, Mar 29, 2024 at 03:25:47PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 3/29/2024 4:39 AM, Isaku Yamahata wrote:
> 
> [...]
> > > > > > How about this?
> > > > > > 
> > > > > > /*
> > > > > >    * We need three SEAMCALLs, TDH.MNG.VPFLUSHDONE(), TDH.PHYMEM.CACHE.WB(), and
> > > > > >    * TDH.MNG.KEY.FREEID() to free the HKID.
> > > > > >    * Other threads can remove pages from TD.  When the HKID is assigned, we need
> > > > > >    * to use TDH.MEM.SEPT.REMOVE() or TDH.MEM.PAGE.REMOVE().
> > > > > >    * TDH.PHYMEM.PAGE.RECLAIM() is needed when the HKID is free.  Get lock to not
> > > > > >    * present transient state of HKID.
> > > > > >    */
> > > > > Could you elaborate why it is still possible to have other thread removing
> > > > > pages from TD?
> > > > > 
> > > > > I am probably missing something, but the thing I don't understand is why
> > > > > this function is triggered by MMU release?  All the things done in this
> > > > > function don't seem to be related to MMU at all.
> > > > The KVM releases EPT pages on MMU notifier release.  kvm_mmu_zap_all() does. If
> > > > we follow that way, kvm_mmu_zap_all() zaps all the Secure-EPTs by
> > > > TDH.MEM.SEPT.REMOVE() or TDH.MEM.PAGE.REMOVE().  Because
> > > > TDH.MEM.{SEPT, PAGE}.REMOVE() is slow, we can free HKID before kvm_mmu_zap_all()
> > > > to use TDH.PHYMEM.PAGE.RECLAIM().
> > > Can you elaborate why TDH.MEM.{SEPT,PAGE}.REMOVE is slower than
> > > TDH.PHYMEM.PAGE.RECLAIM()?
> > > 
> > > And does the difference matter in practice, i.e. did you see using the former
> > > having noticeable performance downgrade?
> > Yes. With HKID alive, we have to assume that vcpu can run still. It means TLB
> > shootdown. The difference is 2 extra SEAMCALL + IPI synchronization for each
> > guest private page.  If the guest has hundreds of GB, the difference can be
> > tens of minutes.
> > 
> > With HKID alive, we need to assume vcpu is alive.
> > - TDH.MEM.PAGE.REMOVE()
> > - TDH.PHYMEM.PAGE_WBINVD()
> > - TLB shoot down
> >    - TDH.MEM.TRACK()
> >    - IPI to other vcpus
> >    - wait for other vcpu to exit
> 
> Do we have a way to batch the TLB shoot down.
> IIUC, in current implementation, TLB shoot down needs to be done for each
> page remove, right?

That's right because the TDP MMU allows multiple vcpus to operate on EPT
concurrently.  Batching makes the logic more complex.  It's straightforward to
use the mmu notifier to know that we start to destroy the guest.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

