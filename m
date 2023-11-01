Return-Path: <kvm+bounces-299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A70E7DE018
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 12:06:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A0B6BB21228
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 11:06:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 705721118F;
	Wed,  1 Nov 2023 11:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C9D10A1B
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 11:06:24 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA8511A;
	Wed,  1 Nov 2023 04:06:20 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4SL3xy3gfhz6K6Lm;
	Wed,  1 Nov 2023 19:02:46 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Wed, 1 Nov
 2023 11:05:52 +0000
Date: Wed, 1 Nov 2023 11:05:51 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Lukas Wunner <lukas@wunner.de>
CC: Alexey Kardashevskiy <aik@amd.com>, <linux-coco@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-pci@vger.kernel.org>, Dan Williams
	<dan.j.williams@intel.com>, Jonathan Cameron <jic23@kernel.org>,
	<suzuki.poulose@arm.com>
Subject: Re: TDISP enablement
Message-ID: <20231101110551.00003896@Huawei.com>
In-Reply-To: <20231101072717.GB25863@wunner.de>
References: <e05eafd8-04b3-4953-8bca-dc321c1a60b9@amd.com>
	<20231101072717.GB25863@wunner.de>
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
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Wed, 1 Nov 2023 08:27:17 +0100
Lukas Wunner <lukas@wunner.de> wrote:

Thanks Alexy, this is a great discussion to kick off.

> On Wed, Nov 01, 2023 at 09:56:11AM +1100, Alexey Kardashevskiy wrote:
> > - device_connect - starts CMA/SPDM session, returns measurements/certs,
> > runs IDE_KM to program the keys;  
> 
> Does the PSP have a set of trusted root certificates?
> If so, where does it get them from?
> 
> If not, does the PSP just blindly trust the validity of the cert chain?
> Who validates the cert chain, and when?
> Which slot do you use?
> Do you return only the cert chain of that single slot or of all slots?
> Does the PSP read out all measurements available?  This may take a while
> if the measurements are large and there are a lot of them.

I'd definitely like their to be a path for certs and measurement to be
checked by the Host OS (for the non TDISP path). Whether the
policy setup cares about result is different question ;)

> 
> 
> > - tdi_info - read measurements/certs/interface report;  
> 
> Does this return cached cert chains and measurements from the device
> or does it retrieve them anew?  (Measurements might have changed if
> MEAS_FRESH_CAP is supported.)
> 
> 
> > If the user wants only CMA/SPDM, the Lukas'es patched will do that without
> > the PSP. This may co-exist with the AMD PSP (if the endpoint allows multiple
> > sessions).  
> 
> It can co-exist if the pci_cma_claim_ownership() library call
> provided by patch 12/12 is invoked upon device_connect.
> 
> It would seem advantageous if you could delay device_connect
> until a device is actually passed through.  Then the OS can
> initially authenticate and measure devices and the PSP takes
> over when needed.

Would that delay mean IDE isn't up - I think that wants to be
available whether or not pass through is going on.

Given potential restrictions on IDE resources, I'd expect to see an explicit
opt in from userspace on the host to start that process for a given
device.  (udev rule or similar might kick it off for simple setups).

Would that work for the flows described?  

Next bit probably has holes...  Key is that a lot of the checks
may fail, and it's up to host userspace policy to decide whether
to proceed (other policy in the secure VM side of things obviously)

So my rough thinking is - for the two options (IDE / TDISP)

Comparing with Alexey's flow I think only real difference is that
I call out explicit host userspace policy controls. I'd also like
to use similar interfaces to convey state to host userspace as
per Lukas' existing approaches.  Sure there will also be in
kernel interfaces for driver to get data if it knows what to do
with it.  I'd also like to enable the non tdisp flow to handle
IDE setup 'natively' if that's possible on particular hardware.

1. Host has a go at CMA/SPDM. Policy might say that a failure here is
   a failure in general so reject device - or it might decide it's up to
   the PSP etc.   (userspace can see if it succeeded)
   I'd argue host software can launch this at any time.  It will
   be a denial of service attack but so are many other things the host
   can do.
2. TDISP policy decision from host (userspace policy control)
   Need to know end goal.
3. IDE opt in from userspace.  Policy decision.
  - If not TDISP 
    - device_connect(IDE ONLY) - bunch of proxying in host OS.
    - Cert chain and measurements presented to host, host can then check if
      it is happy and expose for next policy decision.
    - Hooks exposed for host to request more measurements, key refresh etc.
      Idea being that the flow is host driven with PSP providing required
      services.  If host can just do setup directly that's fine too.
  - If TDISP (technically you can run tdisp from host, but lets assume
    for now no one wants to do that? (yet)).
    - device_connect(TDISP) - bunch of proxying in host OS.
    - Cert chain and measurements presented to host, host can then check if
      it is happy and expose for next policy decision.

4. Flow after this depends on early or late binding (lockdown)
   but could load driver at this point.  Userspace policy.
   tdi-bind etc.


> 
> 
> > If the user wants only IDE, the AMD PSP's device_connect needs to be called
> > and the host OS does not get to know the IDE keys. Other vendors allow
> > programming IDE keys to the RC on the baremetal, and this also may co-exist
> > with a TSM running outside of Linux - the host still manages trafic classes
> > and streams.  
> 
> I'm wondering if your implementation is spec compliant:
> 
> PCIe r6.1 sec 6.33.3 says that "It is permitted for a Root Complex
> to [...] use implementation specific key management."  But "For
> Endpoint Functions, [...] Function 0 must implement [...]
> the IDE key management (IDE_KM) protocol as a Responder."
> 
> So the keys need to be programmed into the endpoint using IDE_KM
> but for the Root Port it's permitted to use implementation-specific
> means.
> 
> The keys for the endpoint and Root Port are the same because this
> is symmetric encryption.
> 
> If the keys are internal to the PSP, the kernel can't program the
> keys into the endpoint using IDE_KM.  So your implementation precludes
> IDE setup by the host OS kernel.

Proxy the CMA messages through the host OS. Doesn't mean host has
visibility of the keys or certs.  So indeed, the actual setup isn't being done
by the host kernel, but rather by it requesting the 'blob' to send
to the CMA DOE from PSP.

By my reading that's a bit inelegant but I don't see it being a break
with the specification.

> 
> device_connect is meant to be used for TDISP, i.e. with devices which
> have the TEE-IO Supported bit set in the Device Capabilities Register.
> 
> What are you going to do with IDE-capable devices which have that bit
> cleared?  Are they unsupported by your implementation?
> 
> It seems to me an architecture cannot claim IDE compliance if it's
> limited to TEE-IO capable devices, which might only be a subset of
> the available products.

Agreed.  If can request the PSP does a non TDISP IDE setup then
I think we are fine.  If not then indeed usecases are limited and
meh, it might be a spec compliance issue but I suspect not as
TDISP has a note at the top that says:

"Although it is permitted (and generally expected) that TDIs will
be implemented such that they can be assigned to Legacy VMs, such
use is not the focus of TDISP."

Which rather implies that devices that don't support other usecases
are allowed.

> 
> 
> > The next steps:
> > - expose blobs via configfs (like Dan did configfs-tsm);
> > - s/tdisp.ko/coco.ko/;
> > - ask the audience - what is missing to make it reusable for other vendors
> > and uses?  
> 
> I intend to expose measurements in sysfs in a measurements/ directory
> below each CMA-capable device's directory.  There are products coming
> to the market which support only CMA and are not interested in IDE or
> TISP.  When bringing up TDISP, measurements received as part of an
> interface report must be exposed in the same way so that user space
> tooling which evaluates the measurememt works both with TEE-IO capable
> and incapable products.  This could be achieved by fetching measurements
> from the interface report instead of via SPDM when TDISP is in use.

Absolutely agree on this and superficially it feels like this should not
be hard to hook up.

There will also be paths where a driver wants to see the measurement report
but that should also be easy enough to enable.

Jonathan
> 
> Thanks,
> 
> Lukas
> 


