Return-Path: <kvm+bounces-2446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB2767F78E1
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 17:26:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 927D6281369
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 16:25:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EFA235EFD;
	Fri, 24 Nov 2023 16:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED0CD41;
	Fri, 24 Nov 2023 08:25:45 -0800 (PST)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ScL0J3zRqz67cSV;
	Sat, 25 Nov 2023 00:24:16 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 24 Nov
 2023 16:25:43 +0000
Date: Fri, 24 Nov 2023 16:25:42 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy <aik@amd.com>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	<suzuki.poulose@arm.com>
Subject: Re: TDISP enablement
Message-ID: <20231124162542.00005d95@Huawei.com>
In-Reply-To: <654ebd31be94a_46f0294a5@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <e05eafd8-04b3-4953-8bca-dc321c1a60b9@amd.com>
	<20231101072717.GB25863@wunner.de>
	<20231101110551.00003896@Huawei.com>
	<654ebd31be94a_46f0294a5@dwillia2-mobl3.amr.corp.intel.com.notmuch>
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
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Fri, 10 Nov 2023 15:30:57 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> Jonathan Cameron wrote:
> > On Wed, 1 Nov 2023 08:27:17 +0100
> > Lukas Wunner <lukas@wunner.de> wrote:
> > 
> > Thanks Alexy, this is a great discussion to kick off.
> >   
> > > On Wed, Nov 01, 2023 at 09:56:11AM +1100, Alexey Kardashevskiy wrote:  
> > > > - device_connect - starts CMA/SPDM session, returns measurements/certs,
> > > > runs IDE_KM to program the keys;    
> > > 
> > > Does the PSP have a set of trusted root certificates?
> > > If so, where does it get them from?
> > > 
> > > If not, does the PSP just blindly trust the validity of the cert chain?
> > > Who validates the cert chain, and when?
> > > Which slot do you use?
> > > Do you return only the cert chain of that single slot or of all slots?
> > > Does the PSP read out all measurements available?  This may take a while
> > > if the measurements are large and there are a lot of them.  
> > 
> > I'd definitely like their to be a path for certs and measurement to be
> > checked by the Host OS (for the non TDISP path). Whether the
> > policy setup cares about result is different question ;)
> >   
> > > 
> > >   
> > > > - tdi_info - read measurements/certs/interface report;    
> > > 
> > > Does this return cached cert chains and measurements from the device
> > > or does it retrieve them anew?  (Measurements might have changed if
> > > MEAS_FRESH_CAP is supported.)
> > > 
> > >   
> > > > If the user wants only CMA/SPDM, the Lukas'es patched will do that without
> > > > the PSP. This may co-exist with the AMD PSP (if the endpoint allows multiple
> > > > sessions).    
> > > 
> > > It can co-exist if the pci_cma_claim_ownership() library call
> > > provided by patch 12/12 is invoked upon device_connect.
> > > 
> > > It would seem advantageous if you could delay device_connect
> > > until a device is actually passed through.  Then the OS can
> > > initially authenticate and measure devices and the PSP takes
> > > over when needed.  
> > 
> > Would that delay mean IDE isn't up - I think that wants to be
> > available whether or not pass through is going on.
> > 
> > Given potential restrictions on IDE resources, I'd expect to see an explicit
> > opt in from userspace on the host to start that process for a given
> > device.  (udev rule or similar might kick it off for simple setups).
> > 
> > Would that work for the flows described?  
> > 
> > Next bit probably has holes...  Key is that a lot of the checks
> > may fail, and it's up to host userspace policy to decide whether
> > to proceed (other policy in the secure VM side of things obviously)
> > 
> > So my rough thinking is - for the two options (IDE / TDISP)
> > 
> > Comparing with Alexey's flow I think only real difference is that
> > I call out explicit host userspace policy controls. I'd also like
> > to use similar interfaces to convey state to host userspace as
> > per Lukas' existing approaches.  Sure there will also be in
> > kernel interfaces for driver to get data if it knows what to do
> > with it.  I'd also like to enable the non tdisp flow to handle
> > IDE setup 'natively' if that's possible on particular hardware.  
> 
> Are there any platforms that have IDE host capability that are not also
> shipping a TSM. I know that some platform allow for either the TSM or
> the OS to own that setup, but there are no standards there. I am not
> opposed to the native path, but given a cross-vendor "TSM" concept is
> needed and that a TSM is likely available on all IDE capable platforms
> it seems reasonable for Linux to rely on TSM managed IDE for the near
> term if not the long term as well.

Just for completeness, (I mentioned it in the LPC discussion):
IDE might well be link based between a switch inside the chassis and devices
outside the chassis in which case it is all standards defined and the host
isn't involved.  Not TDISP related though in that case.

> 
> > 
> > 1. Host has a go at CMA/SPDM. Policy might say that a failure here is
> >    a failure in general so reject device - or it might decide it's up to
> >    the PSP etc.   (userspace can see if it succeeded)
> >    I'd argue host software can launch this at any time.  It will
> >    be a denial of service attack but so are many other things the host
> >    can do.
> > 2. TDISP policy decision from host (userspace policy control)
> >    Need to know end goal.  
> 
> If the TSM owns the TDISP state what this policy decision rely comes
> down to is IDE stream resource management, I otherwise struggle to
> conceptualize "TDISP policy".
> 
> The policy is userspace deciding to assign an interface to a TVM, and
> that TVM requests that the assigned interface be allowed to access
> private memory. So it's not necessarily TDISP policy, its assigned
> interface is allowed to transition to private operation.
Agreed - that is probably enough. I was avoiding calling out specific
policy method, just don't want it to all flow through in the kernel without
a hook.  If we assume that we do stuff only when allocated to a TVM
then that acts as the gate.

> 
> > 3. IDE opt in from userspace.  Policy decision.
> >   - If not TDISP 
> >     - device_connect(IDE ONLY) - bunch of proxying in host OS.
> >     - Cert chain and measurements presented to host, host can then check if
> >       it is happy and expose for next policy decision.
> >     - Hooks exposed for host to request more measurements, key refresh etc.
> >       Idea being that the flow is host driven with PSP providing required
> >       services.  If host can just do setup directly that's fine too.
> >   - If TDISP (technically you can run tdisp from host, but lets assume
> >     for now no one wants to do that? (yet)).
> >     - device_connect(TDISP) - bunch of proxying in host OS.
> >     - Cert chain and measurements presented to host, host can then check if
> >       it is happy and expose for next policy decision.
> > 
> > 4. Flow after this depends on early or late binding (lockdown)
> >    but could load driver at this point.  Userspace policy.
> >    tdi-bind etc.  
> 
> It is valid to load the driver and operate the device in shared mode, so
> I am not sure that acceptance should gate driver loading. It also seems
> like something that could be managed with module policy if someone
> wanted to prevent shared operation before acceptance.

Indeed that might work.  Depends on device and whether it needs to be exposed
in shared mode (which may well require driver code auditing etc that can be relaxed
if it's up with TDISP and we know it's not a 'fake').

> 
> [..]
> > > > The next steps:
> > > > - expose blobs via configfs (like Dan did configfs-tsm);  
> 
> I am missing the context here, but for measurements I think those are
> better in sysfs. configs was only to allow for multiple containers to grab
> attestation reports, measurements are device local and containers can
> all see the same measurements.

Ah. Fair point.

> 
> > > > - s/tdisp.ko/coco.ko/;  
> 
> My bikeshed contribution, perhaps tsm.ko? I am still not someone who can
> say "coco" for confidential computing with a straight face.

Then definitely should be coco.ko :)

Jonathan

