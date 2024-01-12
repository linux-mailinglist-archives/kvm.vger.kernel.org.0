Return-Path: <kvm+bounces-6119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD75382B901
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 02:11:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3CEB81F2427D
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 01:11:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4478C1117;
	Fri, 12 Jan 2024 01:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iRBL3n60"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B85EA6;
	Fri, 12 Jan 2024 01:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705021903; x=1736557903;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bRgCO+xQvI0DoUXfM+Vajb+rpF3VFlCfbXxGEOR60DU=;
  b=iRBL3n60YYLEBWSd6hMtRiOaSa+qboyi5n/+cj00+c5Np0qvSCvPdO2d
   NWMhvD/MqP3DyMiMBZSHKkDq+SXcV4XoGffhliR7nwbMmfzpGgfRsd8BD
   Jj/bbQ50KtsiWcZDFAReB9n0g8g4D6OaoljYxOY8VNjIKVEVe7LrPOhVe
   I3v1rNStqzoRHzTzJIzGtl0i2NsmTFBCnsnDrI10RvOE9NL+Yac+btdjw
   bDucdpW9aoUYDqpR84m0a0/AXb1PafyNIFMz5p214o4PgmzRH5uqttpQB
   irUBBreoAIQCjxy+ox1i6J3ZmfJ/dJzwWdSzdqDnkxjoe5R67x4d6Vtwn
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="6417511"
X-IronPort-AV: E=Sophos;i="6.04,187,1695711600"; 
   d="scan'208";a="6417511"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 17:11:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="901791863"
X-IronPort-AV: E=Sophos;i="6.04,187,1695711600"; 
   d="scan'208";a="901791863"
Received: from linux.bj.intel.com ([10.238.157.71])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 17:11:38 -0800
Date: Fri, 12 Jan 2024 09:08:36 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Chao Gao <chao.gao@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Yi Lai <yi1.lai@intel.com>, Xudong Hao <xudong.hao@intel.com>
Subject: Re: [PATCH] x86/cpu: Add a VMX flag to enumerate 5-level EPT support
 to userspace
Message-ID: <ZaCRFPIMfAPNy2rU@linux.bj.intel.com>
References: <20240110002340.485595-1-seanjc@google.com>
 <ZZ42Vs3uAPwBmezn@chao-email>
 <ZZ7FMWuTHOV-_Gn7@google.com>
 <ZZ9X5anB/HGS8JR6@linux.bj.intel.com>
 <ZaAWXSvMgIMkxr50@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZaAWXSvMgIMkxr50@google.com>

On Thu, Jan 11, 2024 at 08:25:01AM -0800, Sean Christopherson wrote:
> On Thu, Jan 11, 2024, Tao Su wrote:
> > On Wed, Jan 10, 2024 at 08:26:25AM -0800, Sean Christopherson wrote:
> > > On Wed, Jan 10, 2024, Chao Gao wrote:
> > > > On Tue, Jan 09, 2024 at 04:23:40PM -0800, Sean Christopherson wrote:
> > > > >Add a VMX flag in /proc/cpuinfo, ept_5level, so that userspace can query
> > > > >whether or not the CPU supports 5-level EPT paging.  EPT capabilities are
> > > > >enumerated via MSR, i.e. aren't accessible to userspace without help from
> > > > >the kernel, and knowing whether or not 5-level EPT is supported is sadly
> > > > >necessary for userspace to correctly configure KVM VMs.
> > > > 
> > > > This assumes procfs is enabled in Kconfig and userspace has permission to
> > > > access /proc/cpuinfo. But it isn't always true. So, I think it is better to
> > > > advertise max addressable GPA via KVM ioctls.
> > > 
> > > Hrm, so the help for PROC_FS says:
> > > 
> > >   Several programs depend on this, so everyone should say Y here.
> > > 
> > > Given that this is working around something that is borderline an erratum, I'm
> > > inclined to say that userspace shouldn't simply assume the worst if /proc isn't
> > > available.  Practically speaking, I don't think a "real" VM is likely to be
> > > affected; AFAIK, there's no reason for QEMU or any other VMM to _need_ to expose
> > > a memslot at GPA[51:48] unless the VM really has however much memory that is
> > > (hundreds of terabytes?).  And a if someone is trying to run such a massive VM on
> > > such a goofy CPU...
> > 
> > It is unusual to assign a huge RAM to guest, but passthrough a device also may trigger
> > this issue which we have met, i.e. alloc memslot for the 64bit BAR which can set
> > bits[51:48]. BIOS can control the BAR address, e.g. seabios moved 64bit pci window
> > to end of address space by using advertised physical bits[1].
> 
> Drat.  Do you know if these CPUs are going to be productized?  We'll still need
> something in KVM either way, but whether or not the problems are more or less
> limited to funky software setups might influence how we address this.

Yes, please see the CPU model I submitted[1].

[1] https://lore.kernel.org/all/20231206131923.1192066-1-tao1.su@linux.intel.com/

Thanks,
Tao

> 

