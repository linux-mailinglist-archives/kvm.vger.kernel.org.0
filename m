Return-Path: <kvm+bounces-14797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76E3B8A719C
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 18:44:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 364D7281844
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 16:44:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB33112BF3E;
	Tue, 16 Apr 2024 16:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KHzFYRX+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F4D2EAF9;
	Tue, 16 Apr 2024 16:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713285876; cv=none; b=g5V5V0fb/PfzDcFoyDaWwZgTLFHp8hzHRKek/egayBP/bnmWOs6SQ5dDN9EimUvEQVxgCsxdKt48d52KNU65pymb81O8yMlKaYc7xEA5j/j4lkiIbNYGI6WPmUWyyoNJprxt9lLnIJJMozHnSh4hVGuwLkqIsC80N3DKy/LHnc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713285876; c=relaxed/simple;
	bh=30qVteymE6fYqV8CULZ2xQ59p/2UxVIXvjxQltbgNOU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hUwYMO9YRpf+e/Cs0+1BZS1SjN1V/Adzkr/hFJvcNfluWkHsnKOLQZ++03GZJVw3jfu6dz59QRtRWV+Ehtjw6Bt3WzQPKTn4t7ZoYl2LdRVSXub+4HiAgx0Th0ten3kmRX4uJrhhAXRsTrv7UoasdQsAqZ6tX2WaNfhS/jy/jBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KHzFYRX+; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713285874; x=1744821874;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=30qVteymE6fYqV8CULZ2xQ59p/2UxVIXvjxQltbgNOU=;
  b=KHzFYRX+qBIULyTkfjMc8UKcJxniNsDT+OC82ot0xRx4tlEV75lOvsO7
   chYyTIw7E9itE7/ItP5fJVrBu4F7JgCTn0KxtSP+RvCUCyR/1gcCLsMMR
   ai0iXRroSjv842i7oLv9BPbHLRYl7waM7hFs7iOs9XsofOa+QaL21MN3l
   7Lp6CbGA+HoLutQjv8IwLP10t6dFA4gNgwmFoJE0If2ap+Q56FEPueP1p
   ausNJYhsYa7HxXum8ihQ9b+eljXIhqzpWJFfHGrtifXYm4bJwlrJY4Q5u
   FdkdrPjc4YkHI5O43xE8PgXBgjtKY+Wl2Q/mxpR0/p5XCKkFsgMl4YTaA
   g==;
X-CSE-ConnectionGUID: 9qi7IXC3QRSQMYTJv4M5nQ==
X-CSE-MsgGUID: 0pCgdxi9SmOKGVvEObZuWw==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="8853258"
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="8853258"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 09:44:33 -0700
X-CSE-ConnectionGUID: oveVtZQlQVerpF8v9O7DpA==
X-CSE-MsgGUID: +afBxC3MREm1jHYcxmSCig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="27110955"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 09:44:33 -0700
Date: Tue, 16 Apr 2024 09:44:32 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	Sagi Shahar <sagis@google.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 087/130] KVM: TDX: handle vcpu migration over logical
 processor
Message-ID: <20240416164432.GZ3039520@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <b9fe57ceeaabe650f0aecb21db56ef2b1456dcfe.1708933498.git.isaku.yamahata@intel.com>
 <0c3efffa-8dd5-4231-8e90-e0241f058a20@intel.com>
 <20240412214201.GO3039520@ls.amr.corp.intel.com>
 <Zhm5rYA8eSWIUi36@google.com>
 <20240413004031.GQ3039520@ls.amr.corp.intel.com>
 <Zh0wGQ_FfPRENgb0@google.com>
 <20240415224828.GS3039520@ls.amr.corp.intel.com>
 <a552a48d-81b6-441a-88cf-63301f6968a2@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a552a48d-81b6-441a-88cf-63301f6968a2@intel.com>

On Tue, Apr 16, 2024 at 12:05:31PM +1200,
"Huang, Kai" <kai.huang@intel.com> wrote:

> 
> 
> On 16/04/2024 10:48 am, Yamahata, Isaku wrote:
> > On Mon, Apr 15, 2024 at 06:49:35AM -0700,
> > Sean Christopherson <seanjc@google.com> wrote:
> > 
> > > On Fri, Apr 12, 2024, Isaku Yamahata wrote:
> > > > On Fri, Apr 12, 2024 at 03:46:05PM -0700,
> > > > Sean Christopherson <seanjc@google.com> wrote:
> > > > 
> > > > > On Fri, Apr 12, 2024, Isaku Yamahata wrote:
> > > > > > On Fri, Apr 12, 2024 at 09:15:29AM -0700, Reinette Chatre <reinette.chatre@intel.com> wrote:
> > > > > > > > +void tdx_mmu_release_hkid(struct kvm *kvm)
> > > > > > > > +{
> > > > > > > > +	while (__tdx_mmu_release_hkid(kvm) == -EBUSY)
> > > > > > > > +		;
> > > > > > > >   }
> > > > > > > 
> > > > > > > As I understand, __tdx_mmu_release_hkid() returns -EBUSY
> > > > > > > after TDH.VP.FLUSH has been sent for every vCPU followed by
> > > > > > > TDH.MNG.VPFLUSHDONE, which returns TDX_FLUSHVP_NOT_DONE.
> > > > > > > 
> > > > > > > Considering earlier comment that a retry of TDH.VP.FLUSH is not
> > > > > > > needed, why is this while() loop here that sends the
> > > > > > > TDH.VP.FLUSH again to all vCPUs instead of just a loop within
> > > > > > > __tdx_mmu_release_hkid() to _just_ resend TDH.MNG.VPFLUSHDONE?
> > > > > > > 
> > > > > > > Could it be possible for a vCPU to appear during this time, thus
> > > > > > > be missed in one TDH.VP.FLUSH cycle, to require a new cycle of
> > > > > > > TDH.VP.FLUSH?
> > > > > > 
> > > > > > Yes. There is a race between closing KVM vCPU fd and MMU notifier release hook.
> > > > > > When KVM vCPU fd is closed, vCPU context can be loaded again.
> > > > > 
> > > > > But why is _loading_ a vCPU context problematic?
> > > > 
> > > > It's nothing problematic.  It becomes a bit harder to understand why
> > > > tdx_mmu_release_hkid() issues IPI on each loop.  I think it's reasonable
> > > > to make the normal path easy and to complicate/penalize the destruction path.
> > > > Probably I should've added comment on the function.
> > > 
> > > By "problematic", I meant, why can that result in a "missed in one TDH.VP.FLUSH
> > > cycle"?  AFAICT, loading a vCPU shouldn't cause that vCPU to be associated from
> > > the TDX module's perspective, and thus shouldn't trigger TDX_FLUSHVP_NOT_DONE.
> > > 
> > > I.e. looping should be unnecessary, no?
> > 
> > The loop is unnecessary with the current code.
> > 
> > The possible future optimization is to reduce destruction time of Secure-EPT
> > somehow.  One possible option is to release HKID while vCPUs are still alive and
> > destruct Secure-EPT with multiple vCPU context.  Because that's future
> > optimization, we can ignore it at this phase.
> 
> I kinda lost here.
> 
> I thought in the current v19 code, you have already implemented this
> optimization?
> 
> Or is this optimization totally different from what we discussed in an
> earlier patch?
> 
> https://lore.kernel.org/lkml/8feaba8f8ef249950b629f3a8300ddfb4fbcf11c.camel@intel.com/

That's only the first step.  We can optimize it further with multiple vCPUs
context.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

