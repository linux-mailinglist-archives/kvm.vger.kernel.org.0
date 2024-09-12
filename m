Return-Path: <kvm+bounces-26661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 535B7976351
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:49:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8608B1C23056
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:49:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E693F18E03A;
	Thu, 12 Sep 2024 07:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KEKAb3O6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E7D15C3;
	Thu, 12 Sep 2024 07:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726127388; cv=none; b=NuqZW/nlTGjKDk+2nVeKtiW59dhunJCG34yTnYqRqDPufEfsQdEcLD9s9Rr3Z00pKjt0f3FIydppj/PAUxmS4P2hm1t4QfsYo+rYbwiB1TYxSzJ0j2/usqDvtwtF9v6nlgVfVd41VjGnY5+dQi2DbUFqF6A7d3E/noYtabftkaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726127388; c=relaxed/simple;
	bh=4cfUrNrNQI0pGpRJ4Z3iwcyQuYqTrPywWDtjicOzygg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y2eHrD+aTzdk/vqAWKIshV0NPo10c5/4elPd3nDmjChTMOjxeGPOvOTXxAb//xyYMTA5C2Zb/0a6rjwNwCcUSC09nGq4rBsshhzgmRbXbfPRxg2Wx+yLhflILIeXUHivGtg5pYJzfbAEIxtyPYZPZNPOxzgod73eSD2XWAqdYsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KEKAb3O6; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726127387; x=1757663387;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=4cfUrNrNQI0pGpRJ4Z3iwcyQuYqTrPywWDtjicOzygg=;
  b=KEKAb3O6YCiH525ix+Jr16ciu0e68tV5CD5HCPN5fCg53fZ5u05UrZmw
   2rbxS1/Vakjp2vusHrroyF7ze2CJK9kvYX6gClp2vsOtjnNxHIf6548p7
   QeOBFFS7kL8FvLOVd1wTEORu+y6CdizVS2EPXo+UfzDml4Jp9l8G5cZ3P
   yQpqJ6A8Uu3/9ujtM8h9zAqVYXqs+r9kwVJWom9C2phQ//kTT0oRorS9P
   eXkihSlQwNtVR9gqOXTJpFbZk+BdT53eusE6uEpwJyO+IiIGTa66Jx1qp
   kN+pb1vlEaxYWyta3+0K8LwwG7jCvytKDTjBP1FJ315Q1cWF11iHI480E
   A==;
X-CSE-ConnectionGUID: Oo5M4cAjRD2FvSeOabcVKQ==
X-CSE-MsgGUID: PWlM+hJwR52u1hPO5EOeLQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11192"; a="36103241"
X-IronPort-AV: E=Sophos;i="6.10,222,1719903600"; 
   d="scan'208";a="36103241"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 00:49:46 -0700
X-CSE-ConnectionGUID: eKc6OE1+TgyhYuEBPSCeQw==
X-CSE-MsgGUID: UbolNsVqR/mYPtpOlu9PrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,222,1719903600"; 
   d="scan'208";a="67684250"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa008.fm.intel.com with ESMTP; 12 Sep 2024 00:49:43 -0700
Date: Thu, 12 Sep 2024 15:47:01 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>,
	"dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH 13/21] KVM: TDX: Handle TLB tracking for TDX
Message-ID: <ZuKcdbXO7ImQJqbm@yilunxu-OptiPlex-7050>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-14-rick.p.edgecombe@intel.com>
 <ZuE38n/yhI24vS20@yilunxu-OptiPlex-7050>
 <6b9671bfdc7f1e8dab0ede65fa7c7e76f0358a06.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6b9671bfdc7f1e8dab0ede65fa7c7e76f0358a06.camel@intel.com>

On Wed, Sep 11, 2024 at 05:28:18PM +0000, Edgecombe, Rick P wrote:
> On Wed, 2024-09-11 at 14:25 +0800, Xu Yilun wrote:
> > > +static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
> > > +{
> > > +       /*
> > > +        * TDX calls tdx_track() in tdx_sept_remove_private_spte() to ensure
> > > +        * private EPT will be flushed on the next TD enter.
> > > +        * No need to call tdx_track() here again even when this callback is
> > > as
> > > +        * a result of zapping private EPT.
> > > +        * Just invoke invept() directly here to work for both shared EPT
> > > and
> > > +        * private EPT.
> > 
> > IIUC, private EPT is already flushed in .remove_private_spte(), so in
> > theory we don't have to invept() for private EPT?
> 
> I think you are talking about the comment, and not an optimization. So changing:

Yes, just the comment.

> "Just invoke invept() directly here to work for both shared EPT and private EPT"
> to just "Just invoke invept() directly here to work for shared EPT".

Maybe also remind invept() is redundant for private EPT in some cases,
but we implement like this for simplicity.

Thanks,
Yilun

> 
> Seems good to me.

