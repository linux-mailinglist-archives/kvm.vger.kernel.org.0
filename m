Return-Path: <kvm+bounces-14700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D28378A5DD0
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 00:48:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 101001C20C89
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 22:48:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F31C1586F3;
	Mon, 15 Apr 2024 22:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kHbzJNbX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546F8156225;
	Mon, 15 Apr 2024 22:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713221311; cv=none; b=GGDyruO16hP6xJMB64meA4wOcAPCw2v0Ckim+MVYEJmr+WgU9FPMy/e50o4A/l+VtE5biBnLTBk7ypV686CyZ6MIRPIAohEkGbvyC6hnRlg7Afx/IVreAUoQW9u+VIBpbjbHZS6Vql0dgKXsZpo8GJvv2fvH8UkcuQQ6tQJ3/2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713221311; c=relaxed/simple;
	bh=nUQM7IIu77cfAfVW2e5v/L0PLjdgIG4WZ2e/s/EVWNY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WQjjCXVRRLKPv7Z+MY3R8n3FjfnLa/z5WYm6MTR4dyy/KP501ZDuS/CFJgog3lqRj2Fnqa9dVphYkTrlIEvMsj0lWeawH361VQYj8zpkA6PJaFudhVYWemk46JSAsyt7o3Nhnj0AYg3KQ+APiOSiUO1dbpobAPIq3dM8Zcpprn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kHbzJNbX; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713221310; x=1744757310;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nUQM7IIu77cfAfVW2e5v/L0PLjdgIG4WZ2e/s/EVWNY=;
  b=kHbzJNbXyTvz2acu6/1PjW3JyIWbSG3eWG3XkbxbBK8pqdEimCRlUCse
   HpGFiWQL//HQumEVklDTNwGoxrH5dvNfFuhwQMSDbzx+OEtuA1qgvwEoH
   LX5dAUKiEFc8Eb+mupJwwWFBtMUxEPfH40Xj6NfTSkGrTKDJCtjzPsJSa
   8hNsBvLz1E0Z7Rpqcta/BueM6BIZVpQrKZELxNibOOF9FaNgnu1mxmQPm
   OA1nT1x5w7MP4/GBTAtTeD8ODNPHEEQ2gPwcxkYkD7R5pgGCHAlu0ddgu
   IGy0cTGeLniksIjGIPPLPU7uVNQMTBIXSjJ8JVqqUCoWmYJL5GxZOohS6
   Q==;
X-CSE-ConnectionGUID: hlD6TPjMTJe7nKX8iW+eRQ==
X-CSE-MsgGUID: Vm0E9kw/TAWyx0YTS3KdJw==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="20025755"
X-IronPort-AV: E=Sophos;i="6.07,204,1708416000"; 
   d="scan'208";a="20025755"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 15:48:29 -0700
X-CSE-ConnectionGUID: 1JIoJDmsTKW3GcwmcbntJw==
X-CSE-MsgGUID: QDqeAMD/QsegfQkS7B7ytg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,204,1708416000"; 
   d="scan'208";a="22142145"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 15:48:29 -0700
Date: Mon, 15 Apr 2024 15:48:28 -0700
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
Message-ID: <20240415224828.GS3039520@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <b9fe57ceeaabe650f0aecb21db56ef2b1456dcfe.1708933498.git.isaku.yamahata@intel.com>
 <0c3efffa-8dd5-4231-8e90-e0241f058a20@intel.com>
 <20240412214201.GO3039520@ls.amr.corp.intel.com>
 <Zhm5rYA8eSWIUi36@google.com>
 <20240413004031.GQ3039520@ls.amr.corp.intel.com>
 <Zh0wGQ_FfPRENgb0@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zh0wGQ_FfPRENgb0@google.com>

On Mon, Apr 15, 2024 at 06:49:35AM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> On Fri, Apr 12, 2024, Isaku Yamahata wrote:
> > On Fri, Apr 12, 2024 at 03:46:05PM -0700,
> > Sean Christopherson <seanjc@google.com> wrote:
> > 
> > > On Fri, Apr 12, 2024, Isaku Yamahata wrote:
> > > > On Fri, Apr 12, 2024 at 09:15:29AM -0700, Reinette Chatre <reinette.chatre@intel.com> wrote:
> > > > > > +void tdx_mmu_release_hkid(struct kvm *kvm)
> > > > > > +{
> > > > > > +	while (__tdx_mmu_release_hkid(kvm) == -EBUSY)
> > > > > > +		;
> > > > > >  }
> > > > > 
> > > > > As I understand, __tdx_mmu_release_hkid() returns -EBUSY
> > > > > after TDH.VP.FLUSH has been sent for every vCPU followed by
> > > > > TDH.MNG.VPFLUSHDONE, which returns TDX_FLUSHVP_NOT_DONE.
> > > > > 
> > > > > Considering earlier comment that a retry of TDH.VP.FLUSH is not
> > > > > needed, why is this while() loop here that sends the
> > > > > TDH.VP.FLUSH again to all vCPUs instead of just a loop within
> > > > > __tdx_mmu_release_hkid() to _just_ resend TDH.MNG.VPFLUSHDONE?
> > > > > 
> > > > > Could it be possible for a vCPU to appear during this time, thus
> > > > > be missed in one TDH.VP.FLUSH cycle, to require a new cycle of
> > > > > TDH.VP.FLUSH?
> > > > 
> > > > Yes. There is a race between closing KVM vCPU fd and MMU notifier release hook.
> > > > When KVM vCPU fd is closed, vCPU context can be loaded again.
> > > 
> > > But why is _loading_ a vCPU context problematic?
> > 
> > It's nothing problematic.  It becomes a bit harder to understand why
> > tdx_mmu_release_hkid() issues IPI on each loop.  I think it's reasonable
> > to make the normal path easy and to complicate/penalize the destruction path.
> > Probably I should've added comment on the function.
> 
> By "problematic", I meant, why can that result in a "missed in one TDH.VP.FLUSH
> cycle"?  AFAICT, loading a vCPU shouldn't cause that vCPU to be associated from
> the TDX module's perspective, and thus shouldn't trigger TDX_FLUSHVP_NOT_DONE.
> 
> I.e. looping should be unnecessary, no?

The loop is unnecessary with the current code.

The possible future optimization is to reduce destruction time of Secure-EPT
somehow.  One possible option is to release HKID while vCPUs are still alive and
destruct Secure-EPT with multiple vCPU context.  Because that's future
optimization, we can ignore it at this phase.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

