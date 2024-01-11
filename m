Return-Path: <kvm+bounces-6042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AD18F82A62F
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 03:55:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E8451F23BAF
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 02:55:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07DE3ED4;
	Thu, 11 Jan 2024 02:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="atetTZY3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C21DA3C;
	Thu, 11 Jan 2024 02:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704941728; x=1736477728;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HoH9MUvgkubUOlwwOn66/K+dJfeGm9DqWpVIQurTjTE=;
  b=atetTZY3iM3vS6P/vHQUtKxkk8KfDK5nOXQatWwnbob7kLhfYX7EyQo8
   JIk7mnSYI0yXwcSbgxppbk5xdkRT6K9iawiCCsWdcB5PNFSiDf1C31mtN
   QrnnesNBVMmGNEfCtkT1sMpy86r/hMqkujC3noLs4DmUASIBr+KvtpFxu
   yPcM8iO9NI8LLCZTacbalv/GFb87AAfCeW+5OLPLf9rI/P6rNxKn3tAlV
   UFOjA6fvmSRWAso9GMmYpB4QQEhi6r/p2ZBOCHjpJJLkrKRnqK8mEndzT
   Ja4bt4qkhZWeMTvXG5LByu76xtNipBD338+W8rHCyT7+S1fi+SAUU7wnN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10949"; a="5805754"
X-IronPort-AV: E=Sophos;i="6.04,185,1695711600"; 
   d="scan'208";a="5805754"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2024 18:55:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10949"; a="775454469"
X-IronPort-AV: E=Sophos;i="6.04,185,1695711600"; 
   d="scan'208";a="775454469"
Received: from linux.bj.intel.com ([10.238.157.71])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2024 18:55:23 -0800
Date: Thu, 11 Jan 2024 10:52:21 +0800
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
Message-ID: <ZZ9X5anB/HGS8JR6@linux.bj.intel.com>
References: <20240110002340.485595-1-seanjc@google.com>
 <ZZ42Vs3uAPwBmezn@chao-email>
 <ZZ7FMWuTHOV-_Gn7@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZ7FMWuTHOV-_Gn7@google.com>

On Wed, Jan 10, 2024 at 08:26:25AM -0800, Sean Christopherson wrote:
> On Wed, Jan 10, 2024, Chao Gao wrote:
> > On Tue, Jan 09, 2024 at 04:23:40PM -0800, Sean Christopherson wrote:
> > >Add a VMX flag in /proc/cpuinfo, ept_5level, so that userspace can query
> > >whether or not the CPU supports 5-level EPT paging.  EPT capabilities are
> > >enumerated via MSR, i.e. aren't accessible to userspace without help from
> > >the kernel, and knowing whether or not 5-level EPT is supported is sadly
> > >necessary for userspace to correctly configure KVM VMs.
> > 
> > This assumes procfs is enabled in Kconfig and userspace has permission to
> > access /proc/cpuinfo. But it isn't always true. So, I think it is better to
> > advertise max addressable GPA via KVM ioctls.
> 
> Hrm, so the help for PROC_FS says:
> 
>   Several programs depend on this, so everyone should say Y here.
> 
> Given that this is working around something that is borderline an erratum, I'm
> inclined to say that userspace shouldn't simply assume the worst if /proc isn't
> available.  Practically speaking, I don't think a "real" VM is likely to be
> affected; AFAIK, there's no reason for QEMU or any other VMM to _need_ to expose
> a memslot at GPA[51:48] unless the VM really has however much memory that is
> (hundreds of terabytes?).  And a if someone is trying to run such a massive VM on
> such a goofy CPU...

It is unusual to assign a huge RAM to guest, but passthrough a device also may trigger
this issue which we have met, i.e. alloc memslot for the 64bit BAR which can set
bits[51:48]. BIOS can control the BAR address, e.g. seabios moved 64bit pci window
to end of address space by using advertised physical bits[1].

[1] https://gitlab.com/qemu-project/seabios/-/commit/bcfed7e270776ab5595cafc6f1794bea0cae1c6c

> 
> I don't think it's unreasonable for KVM selftests to require access to
> /proc/cpuinfo.  Or actually, they can probably do the same thing and self-limit
> to 48-bit addresses if /proc/cpuinfo isn't available.
> 
> I'm not totally opposed to adding a more programmatic way for userspace to query
> 5-level EPT support, it just seems unnecessary.  E.g. unlike CPUID, userspace
> can't directly influence whether or not KVM uses 5-level EPT.  Even in hindsight,
> I'm not entirely sure KVM should expose such a knob, as it raises questions around
> interactions guest.MAXPHYADDR and memslots that I would rather avoid.
> 
> And even if we do add such uAPI, enumerating 5-level EPT in /proc/cpuinfo is
> definitely worthwhile, the only thing that would need to be tweaked is the
> justification in the changelog.
> 
> One thing we can do irrespective of feature enumeration is have kvm_mmu_page_fault()
> exit to userspace with an explicit error if the guest faults ona GPA that KVM
> knows it can't map, i.e. exit with KVM_EXIT_INTERNAL_ERROR or maybe even
> KVM_EXIT_MEMORY_FAULT instead of looping indefinitely.

If KVM does report guest.MAXPHYADDR=host.MAXPHYADDR, it is not reasonable to kill the
guest directly. And just reporting that it does not support 5-level EPT in /proc/cpuinfo
will make it difficult for users to realize that physical-bits needs to be forcibly
limited in the command. But advertising max addressable GPA via ioctl and this patch do
not conflict.

Thanks,
Tao

