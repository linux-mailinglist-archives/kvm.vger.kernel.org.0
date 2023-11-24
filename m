Return-Path: <kvm+bounces-2441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4D327F76E8
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 15:53:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A249281F5A
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 14:52:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9681D2DF83;
	Fri, 24 Nov 2023 14:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C78910CA;
	Fri, 24 Nov 2023 06:52:48 -0800 (PST)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ScHsj59y3z6K5q0;
	Fri, 24 Nov 2023 22:48:25 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 24 Nov
 2023 14:52:45 +0000
Date: Fri, 24 Nov 2023 14:52:44 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: Alexey Kardashevskiy <aik@amd.com>, Lukas Wunner <lukas@wunner.de>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	<suzuki.poulose@arm.com>
Subject: Re: TDISP enablement
Message-ID: <20231124145244.00001092@Huawei.com>
In-Reply-To: <655004226efd8_46f029452@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <e05eafd8-04b3-4953-8bca-dc321c1a60b9@amd.com>
	<20231101072717.GB25863@wunner.de>
	<20231101110551.00003896@Huawei.com>
	<4cfe829f-8373-4ff4-a963-3ee74fa39efe@amd.com>
	<20231103164404.00006e0b@Huawei.com>
	<655004226efd8_46f029452@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500003.china.huawei.com (7.191.162.67) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Sat, 11 Nov 2023 14:45:54 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> Jonathan Cameron wrote:
> >    
> > > >>> - tdi_info - read measurements/certs/interface report;    
> > > >>
> > > >> Does this return cached cert chains and measurements from the device
> > > >> or does it retrieve them anew?  (Measurements might have changed if
> > > >> MEAS_FRESH_CAP is supported.)
> > > >>
> > > >>    
> > > >>> If the user wants only CMA/SPDM, the Lukas'es patched will do that without
> > > >>> the PSP. This may co-exist with the AMD PSP (if the endpoint allows multiple
> > > >>> sessions).    
> > > >>
> > > >> It can co-exist if the pci_cma_claim_ownership() library call
> > > >> provided by patch 12/12 is invoked upon device_connect.
> > > >>
> > > >> It would seem advantageous if you could delay device_connect
> > > >> until a device is actually passed through.  Then the OS can
> > > >> initially authenticate and measure devices and the PSP takes
> > > >> over when needed.    
> > > > 
> > > > Would that delay mean IDE isn't up - I think that wants to be
> > > > available whether or not pass through is going on.
> > > > 
> > > > Given potential restrictions on IDE resources, I'd expect to see an explicit
> > > > opt in from userspace on the host to start that process for a given
> > > > device.  (udev rule or similar might kick it off for simple setups).
> > > > 
> > > > Would that work for the flows described?    
> > > 
> > > This would work but my (likely wrong) intention was also to run 
> > > necessary setup in both host and guest at the same time before drivers 
> > > probe devices. And while delaying it in the host is fine (well, for us 
> > > in AMD, as we are aiming for CoCo/TDISP), in the guest this means less 
> > > flexibility in enlightening the PCI subsystem and the guest driver: 
> > > ideally (or at least initially) the driver is supposed to probe already 
> > > enabled and verified device, as otherwise it has to do SWIOTLB until the 
> > > userspace does the verification and kicks the driver to go proper direct 
> > > DMA (or reload the driver?).  
> > 
> > In the case of a guest getting a VF, there probably won't be any way for
> > the kernel to run any native attestation anyway, so policy would have to
> > rely on the CoCo paths. Kernel stuff Lukas has would just not try to attest
> > or claim anything about it. If a VF has a CMA capable DOE instance
> > then that's not there for IDE stuff at all, but for the guest to get
> > direct measurements etc without PSP or anything else getting involved
> > in which case the guest using that directly is a reasonable thing to do.  
> 
> Is that a practical reality that VFs are going to implement CMA?
Maybe?  CMA definition allows for it.
>  My
> expectation is CMA is a PF facility and the TSM retrieves measurements
> for TDIs through that. At least that seems to be fundamental assumption
> of the TDISP specification. Given config-cycles are always host-mediated
> I expect guest CMA will always be a proxy whether it is is per-VF CMA
> interface or not.

There's a different between proxying where we just pass the reads and writes
through unmodified as PCI config accesses and where we provide a userspace
interface to do it because we need to maintain locking etc vs any potential
host accesses. But sure, it's emulated even in this path.


> 
> >   
> > >   
> > > > Next bit probably has holes...  Key is that a lot of the checks
> > > > may fail, and it's up to host userspace policy to decide whether
> > > > to proceed (other policy in the secure VM side of things obviously)
> > > > 
> > > > So my rough thinking is - for the two options (IDE / TDISP)
> > > > 
> > > > Comparing with Alexey's flow I think only real difference is that
> > > > I call out explicit host userspace policy controls. I'd also like    
> > > 
> > > My imagination fails me :) What is the host supposed to do if the device 
> > > verification fails/succeeds later, and how much later, and the device is 
> > > a boot disk? Or is this userspace going to be limited to initramdisk? 
> > > What is that thing which we are protecting against? Or it is for CUDA 
> > > and such (which yeah, it can wait)?  
> > 
> > There are a bunch of non obvious cases indeed.  Hence make it all policy.
> > Though if you have a flow where verification is needed for boot disk and
> > it fails (and policy says that's not acceptable) then bad luck you
> > probably need to squirt a cert into your ramdisk or UEFI or similar.  
> 
> It seems policy mechanisms should be incrementally added as clear need
> for policy dictates, because that has ABI implications and
> kernel-depedency-on-userpace expectations.

Agreed, but I'd expect anything we implement in kernel to at least anticipate
that we may want policy.  If there are multiple possible sources of
verfication I'd be very surprised if we didn't need controls on whether
we require all to pass, none to pass, one specific one to pass, or any one to pass.

> 
> > > > to use similar interfaces to convey state to host userspace as
> > > > per Lukas' existing approaches.  Sure there will also be in
> > > > kernel interfaces for driver to get data if it knows what to do
> > > > with it.  I'd also like to enable the non tdisp flow to handle
> > > > IDE setup 'natively' if that's possible on particular hardware.
> > > > 
> > > > 1. Host has a go at CMA/SPDM. Policy might say that a failure here is
> > > >     a failure in general so reject device - or it might decide it's up to
> > > >     the PSP etc.   (userspace can see if it succeeded)
> > > >     I'd argue host software can launch this at any time.  It will
> > > >     be a denial of service attack but so are many other things the host
> > > >     can do.    
> > > 
> > > Trying to visualize it in my head - policy is a kernel cmdline or module 
> > > parameter?  
> > 
> > Neither - it's bind not happening until userspace decides to kick it off.
> > The module could provide it's own policy on top of this - so userspace
> > could defer to that if it makes sense (so bind but rely on probe failing
> > if policy not met).  
> 
> udev module policy can already gate binding, its not clear new policy
> mechanism is needed here.

Yeah, I think that works - but to be sure definitely want to see a PoC.

...

Jonathan


