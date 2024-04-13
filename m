Return-Path: <kvm+bounces-14585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BB14A8A3968
	for <lists+kvm@lfdr.de>; Sat, 13 Apr 2024 02:40:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB7511C211A9
	for <lists+kvm@lfdr.de>; Sat, 13 Apr 2024 00:40:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E870442C;
	Sat, 13 Apr 2024 00:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JVXzOag1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA6A7E9;
	Sat, 13 Apr 2024 00:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712968836; cv=none; b=EXU2YPOkDLp0slVc46d1Kgi/EJNbvc6qu219Z7PnafcZ54gmCqJY0jNQ0BYj3DfPvdWSqtL3WvZk8JA0Nlude8IrR0/TLUT3bP1RnN4lNCOgtsVQwPjo7ONMNP/UqQnnXFrMk/roWnyIE1VY9/kuSTlY9srBALwveH6+oU6oacw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712968836; c=relaxed/simple;
	bh=Z10XwQjxuMwXDF/1cSayzrUktgk7iSm3++jlMAlIwJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lLzbFkpT+C1/mL/XoC/A21Obxh+r5Qq51V4mDmytGJxjV34LP7KdLX6xzZ5oUsSfdhPHRILmnmi//NWG6t79aXgvpEpE+0HrOtmjSBPOxmddcfWWrlvisHoTGCMzVPBPIPZQf/6FfGQ5fcWWguv1tG7Pnhf1LNd5wuMsbFCv6G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JVXzOag1; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712968834; x=1744504834;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Z10XwQjxuMwXDF/1cSayzrUktgk7iSm3++jlMAlIwJA=;
  b=JVXzOag1IvWsZChBDprDDtuz4rXqMyJk42Lj57sRzuUClnQYsREkjmvl
   zZyDJo9iwLNTmOX9yNLsn6Ihsm0vWk3wGmoP+bMxyAXbUMc55sL6g2ePO
   kRXXOJk1yQknZPYSZssrLLNB5VuUbkEa0/x1lpbAI0XcWvD+GkrLTbF1J
   JmwG7YEElQqoauUuva6ldfPDXve5QY8sv8BwIej6R02l3A7NVBz+Df2ui
   +hEr/67Tlcz9z1EQn7Gpf1d3qhDiJbHs5X99mYUdKPpOTahvg7FlHVij5
   +XETh+ptSPZEACp1l1UVhXYPRBJ/qXwLeaSDYrC8yeQ1SyswvbZ2H4ky1
   w==;
X-CSE-ConnectionGUID: Ihqbk3h5QdaWy7NA1RNHfw==
X-CSE-MsgGUID: 0BRL+2QrQpOe4BYl9nXDsA==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="19044707"
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="19044707"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 17:40:33 -0700
X-CSE-ConnectionGUID: TiJFT1IvTOWAT+qhIZD25g==
X-CSE-MsgGUID: N0CR4kfuS56j9VXpeJQ8mw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="21373992"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 17:40:32 -0700
Date: Fri, 12 Apr 2024 17:40:31 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 087/130] KVM: TDX: handle vcpu migration over logical
 processor
Message-ID: <20240413004031.GQ3039520@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <b9fe57ceeaabe650f0aecb21db56ef2b1456dcfe.1708933498.git.isaku.yamahata@intel.com>
 <0c3efffa-8dd5-4231-8e90-e0241f058a20@intel.com>
 <20240412214201.GO3039520@ls.amr.corp.intel.com>
 <Zhm5rYA8eSWIUi36@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zhm5rYA8eSWIUi36@google.com>

On Fri, Apr 12, 2024 at 03:46:05PM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> On Fri, Apr 12, 2024, Isaku Yamahata wrote:
> > On Fri, Apr 12, 2024 at 09:15:29AM -0700, Reinette Chatre <reinette.chatre@intel.com> wrote:
> > > > +void tdx_mmu_release_hkid(struct kvm *kvm)
> > > > +{
> > > > +	while (__tdx_mmu_release_hkid(kvm) == -EBUSY)
> > > > +		;
> > > >  }
> > > 
> > > As I understand, __tdx_mmu_release_hkid() returns -EBUSY
> > > after TDH.VP.FLUSH has been sent for every vCPU followed by
> > > TDH.MNG.VPFLUSHDONE, which returns TDX_FLUSHVP_NOT_DONE.
> > > 
> > > Considering earlier comment that a retry of TDH.VP.FLUSH is not
> > > needed, why is this while() loop here that sends the
> > > TDH.VP.FLUSH again to all vCPUs instead of just a loop within
> > > __tdx_mmu_release_hkid() to _just_ resend TDH.MNG.VPFLUSHDONE?
> > > 
> > > Could it be possible for a vCPU to appear during this time, thus
> > > be missed in one TDH.VP.FLUSH cycle, to require a new cycle of
> > > TDH.VP.FLUSH?
> > 
> > Yes. There is a race between closing KVM vCPU fd and MMU notifier release hook.
> > When KVM vCPU fd is closed, vCPU context can be loaded again.
> 
> But why is _loading_ a vCPU context problematic?

It's nothing problematic.  It becomes a bit harder to understand why
tdx_mmu_release_hkid() issues IPI on each loop.  I think it's reasonable
to make the normal path easy and to complicate/penalize the destruction path.
Probably I should've added comment on the function.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

