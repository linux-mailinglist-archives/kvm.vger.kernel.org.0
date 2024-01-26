Return-Path: <kvm+bounces-7081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 011AF83D52D
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:01:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD3EC283B65
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:01:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 027F058AAC;
	Fri, 26 Jan 2024 07:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GGO/xmxd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8967111700;
	Fri, 26 Jan 2024 07:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706254785; cv=none; b=ME4pKaoTw+vOj5fc0gVv3cj9mRotwBNW1ccUD2ad6jw7t2xim4W67GndabG49LIwJIHwgONN4oYyS/d5px2PpIgIt/F9YMp4Xto+quXfabn2jnCn2/dViHut6oamtqFKlb3VgqcAVS3JFHWn0Ga582uTsYEYQA+p/TbhxHv5TBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706254785; c=relaxed/simple;
	bh=U9mNTNgZsSW+bVbmEnmLkw4a/p6CuTR5Z5KKpN05XeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DQbFBCmBPoefhun4yYTvqsjFmOXldO1pclML3QbD/VbKhAyaNymne3CAyOZcj8w8YfbkdjtWnyho6CFs/GxIbhicLLk6pUxDNFVHe0MrchCcEVd1Bev/6rz3PJHudtYrj9eL1DtXKkAXNsgYQ5WZSiqJrrZnNtZbXvjaJOQYqx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GGO/xmxd; arc=none smtp.client-ip=134.134.136.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706254783; x=1737790783;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=U9mNTNgZsSW+bVbmEnmLkw4a/p6CuTR5Z5KKpN05XeQ=;
  b=GGO/xmxdPb+7QhoqXI/U8mp+6Mc8vkv1wfaEpqlUxM2SGGjv+pTqt9nl
   eyuNa4kuc6MhKDtZuU+2D9Gza8F3otPcLf/eT2nO3SLjuXog8jIkR/cBI
   zqDLTS9RngUxP0Ab7TX2N5xHAB6fp737zFP1XO86FwGAK7PcQQYQmEh18
   PN1n+hvLgY40Muzf5cSgG22DY/vg3bo1kBYVG5YVB2xK+ZpRHBqF4KVw5
   WG+iGn6qli9JAnlEjjjDxXZlJPyzCiTKpNWF0iwvXXetYTWxrr6z4/ZTx
   9YvRwkmNDr3+x1BXvkNCGTn3oLsmYjqpG5vUhAwpPNx+LYTAJazY0PXbS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="406145211"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="406145211"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 23:39:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2684770"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa004.jf.intel.com with ESMTP; 25 Jan 2024 23:39:41 -0800
Date: Fri, 26 Jan 2024 15:36:20 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 1/4] KVM: Always flush async #PF workqueue when vCPU is
 being destroyed
Message-ID: <ZbNg9BFT2o6NbgRX@yilunxu-OptiPlex-7050>
References: <20240110011533.503302-1-seanjc@google.com>
 <20240110011533.503302-2-seanjc@google.com>
 <Zau/VQ0B5MCwoqZT@yilunxu-OptiPlex-7050>
 <ZbFfVxp76qoBstul@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbFfVxp76qoBstul@google.com>

On Wed, Jan 24, 2024 at 11:04:55AM -0800, Sean Christopherson wrote:
> On Sat, Jan 20, 2024, Xu Yilun wrote:
> > On Tue, Jan 09, 2024 at 05:15:30PM -0800, Sean Christopherson wrote:
> > > Always flush the per-vCPU async #PF workqueue when a vCPU is clearing its
> > > completion queue, e.g. when a VM and all its vCPUs is being destroyed.
> > > KVM must ensure that none of its workqueue callbacks is running when the
> > > last reference to the KVM _module_ is put.  Gifting a reference to the
> > > associated VM prevents the workqueue callback from dereferencing freed
> > > vCPU/VM memory, but does not prevent the KVM module from being unloaded
> > > before the callback completes.
> > > 
> > > Drop the misguided VM refcount gifting, as calling kvm_put_kvm() from
> > > async_pf_execute() if kvm_put_kvm() flushes the async #PF workqueue will
> > > result in deadlock.  async_pf_execute() can't return until kvm_put_kvm()
> > > finishes, and kvm_put_kvm() can't return until async_pf_execute() finishes:
> > > 
> > >  WARNING: CPU: 8 PID: 251 at virt/kvm/kvm_main.c:1435 kvm_put_kvm+0x2d/0x320 [kvm]
> > >  Modules linked in: vhost_net vhost vhost_iotlb tap kvm_intel kvm irqbypass
> > >  CPU: 8 PID: 251 Comm: kworker/8:1 Tainted: G        W          6.6.0-rc1-e7af8d17224a-x86/gmem-vm #119
> > >  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
> > >  Workqueue: events async_pf_execute [kvm]
> > >  RIP: 0010:kvm_put_kvm+0x2d/0x320 [kvm]
> > >  Call Trace:
> > >   <TASK>
> > >   async_pf_execute+0x198/0x260 [kvm]
> > >   process_one_work+0x145/0x2d0
> > >   worker_thread+0x27e/0x3a0
> > >   kthread+0xba/0xe0
> > >   ret_from_fork+0x2d/0x50
> > >   ret_from_fork_asm+0x11/0x20
> > >   </TASK>
> > >  ---[ end trace 0000000000000000 ]---
> > >  INFO: task kworker/8:1:251 blocked for more than 120 seconds.
> > >        Tainted: G        W          6.6.0-rc1-e7af8d17224a-x86/gmem-vm #119
> > >  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > >  task:kworker/8:1     state:D stack:0     pid:251   ppid:2      flags:0x00004000
> > >  Workqueue: events async_pf_execute [kvm]
> > >  Call Trace:
> > >   <TASK>
> > >   __schedule+0x33f/0xa40
> > >   schedule+0x53/0xc0
> > >   schedule_timeout+0x12a/0x140
> > >   __wait_for_common+0x8d/0x1d0
> > >   __flush_work.isra.0+0x19f/0x2c0
> > >   kvm_clear_async_pf_completion_queue+0x129/0x190 [kvm]
> > >   kvm_arch_destroy_vm+0x78/0x1b0 [kvm]
> > >   kvm_put_kvm+0x1c1/0x320 [kvm]
> > >   async_pf_execute+0x198/0x260 [kvm]
> > >   process_one_work+0x145/0x2d0
> > >   worker_thread+0x27e/0x3a0
> > >   kthread+0xba/0xe0
> > >   ret_from_fork+0x2d/0x50
> > >   ret_from_fork_asm+0x11/0x20
> > >   </TASK>
> > > 
> > > If kvm_clear_async_pf_completion_queue() actually flushes the workqueue,
> > > then there's no need to gift async_pf_execute() a reference because all
> > > invocations of async_pf_execute() will be forced to complete before the
> > > vCPU and its VM are destroyed/freed.  And that in turn fixes the module
> > > unloading bug as __fput() won't do module_put() on the last vCPU reference
> > > until the vCPU has been freed, e.g. if closing the vCPU file also puts the
> > 
> > I'm not sure why __fput() of vCPU fd should be mentioned here. I assume
> > we just need to say that vCPUs are freed before module_put(KVM the module)
> > in kvm_destroy_vm(), then the whole logic for module unloading fix is:
> > 
> >   1. All workqueue callbacks complete when kvm_clear_async_pf_completion_queue(vcpu)
> >   2. kvm_clear_async_pf_completion_queue(vcpu) must be executed before vCPU free.
> >   3. vCPUs must be freed before module_put(KVM the module).
> > 
> >   So all workqueue callbacks complete before module_put(KVM the module).
> > 
> > 
> > __fput() of vCPU fd is not the only trigger of kvm_destroy_vm(), that
> > makes me distracted from reason of the fix.
> 
> My goal was to call out that (a) the vCPU file descriptor is what ensures kvm.ko
> is alive at this point and (b) that __fput() very deliberately ensures module_put()
> is called after all module function callbacks/hooks complete, as there was quite

Ah, I understood. These are ensured by your previous fix which grants
kvm_vcpu_fops the module owner. LGTM now.

Thanks,
Yilun

