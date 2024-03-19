Return-Path: <kvm+bounces-12188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BC4E8806EC
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 22:50:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9AAD1C22049
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 21:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C3BF4F5F9;
	Tue, 19 Mar 2024 21:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D+YVUFKT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033454084B;
	Tue, 19 Mar 2024 21:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710885019; cv=none; b=ZjoUFll1fPb5Vku1DaIMfOvPwWGUwOYUSL5q1d+Fuumqo6pG0XOhqHy+4ck4V9ZDRI5kU3m/bctBGdjeE15iQlY1k0dpfXagUMROUzgCbe4qaptbxktQ9x4zcSZWzpASVzdv5vjIhiUit/nRyn5UCnTc47FnSY7OtIcKr8zqhtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710885019; c=relaxed/simple;
	bh=u0ky7lD4WYHe1mIe+kxX9IJ6CqaLw9ZqOtDSuwYZpSc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ARIOuBY6wkurEIFM5jIyfAFysgYs51ju1w5EoB7yOaIS2pMghdoilaGROQXVmOCoOgimrhw1zjK0HSsGuu+noUP+c/tY9ubXC6m6r01vHQKzbrwmW4fK2zcjZ7hTO8gy9tl9efg+eWBiqSRMq1oi/AEC8wn8CrCxfSXDS3crVDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D+YVUFKT; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710885017; x=1742421017;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=u0ky7lD4WYHe1mIe+kxX9IJ6CqaLw9ZqOtDSuwYZpSc=;
  b=D+YVUFKTVcajqxUGRYYyRdmEZpl9ZY/1JmyfLclRZ6iUgro6Y3bUSSOZ
   9kNLiEHc1zDhzcHpJlUybC65Q284F4mc0FxAbchWzYTzrL1VmsQvgN2Cd
   dgL/ebkFQik8eZDYqotjD4MkewB9D5EqzIDbMpfIKnCBcjG7F4EeKI09/
   E4WlL+h80Qtb7XOjZmKYxjtfZ8VJvlwiXoVB0ffrfBQ+NtRkr8aH+47Bz
   xVgC8+bVC4s10au19TnWSq6Q7Kmjx0vqw3d07QyWO7wsH/UMBgvr1hq3H
   BbKUfWzKziDYW7j13pV0vqJRt3EAfUsmtlu3FrzNktAlXqc9I3G8wpKO6
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="5961197"
X-IronPort-AV: E=Sophos;i="6.07,138,1708416000"; 
   d="scan'208";a="5961197"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 14:50:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,138,1708416000"; 
   d="scan'208";a="14336090"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 14:50:16 -0700
Date: Tue, 19 Mar 2024 14:50:15 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"Chen, Bo2" <chen.bo@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v19 011/130] KVM: Add new members to struct kvm_gfn_range
 to operate on
Message-ID: <20240319215015.GA1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <e324ff5e47e07505648c0092a5370ac9ddd72f0b.1708933498.git.isaku.yamahata@intel.com>
 <2daf03ae-6b5a-44ae-806e-76d09fb5273b@linux.intel.com>
 <20240313171428.GK935089@ls.amr.corp.intel.com>
 <52bc2c174c06f94a44e3b8b455c0830be9965cdf.camel@intel.com>
 <1d1da229d4bd56acabafd2087a5fabca9f48c6fc.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1d1da229d4bd56acabafd2087a5fabca9f48c6fc.camel@intel.com>

On Tue, Mar 19, 2024 at 02:47:47PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Mon, 2024-03-18 at 19:50 -0700, Rick Edgecombe wrote:
> > On Wed, 2024-03-13 at 10:14 -0700, Isaku Yamahata wrote:
> > > > IMO, an enum will be clearer than the two flags.
> > > > 
> > > >     enum {
> > > >         PROCESS_PRIVATE_AND_SHARED,
> > > >         PROCESS_ONLY_PRIVATE,
> > > >         PROCESS_ONLY_SHARED,
> > > >     };
> > > 
> > > The code will be ugly like
> > > "if (== PRIVATE || == PRIVATE_AND_SHARED)" or
> > > "if (== SHARED || == PRIVATE_AND_SHARED)"
> > > 
> > > two boolean (or two flags) is less error-prone.
> > 
> > Yes the enum would be awkward to handle. But I also thought the way
> > this is specified in struct kvm_gfn_range is a little strange.
> > 
> > It is ambiguous what it should mean if you set:
> >  .only_private=true;
> >  .only_shared=true;
> > ...as happens later in the series (although it may be a mistake).
> > 
> > Reading the original conversation, it seems Sean suggested this
> > specifically. But it wasn't clear to me from the discussion what the
> > intention of the "only" semantics was. Like why not?
> >  bool private;
> >  bool shared;
> 
> I see Binbin brought up this point on v18 as well:
> https://lore.kernel.org/kvm/6220164a-aa1d-43d2-b918-6a6eaad769fb@linux.intel.com/#t
> 
> and helpfully dug up some other discussion with Sean where he agreed
> the "_only" is confusing and proposed the the enum:
> https://lore.kernel.org/kvm/ZUO1Giju0GkUdF0o@google.com/
> 
> He wanted the default value (in the case the caller forgets to set
> them), to be to include both private and shared. I think the enum has
> the issues that Isaku mentioned. What about?
> 
>  bool exclude_private;
>  bool exclude_shared;
> 
> It will become onerous if more types of aliases grow, but it clearer
> semantically and has the safe default behavior.

I'm fine with those names. Anyway, I'm fine with wither way, two bools or enum.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

