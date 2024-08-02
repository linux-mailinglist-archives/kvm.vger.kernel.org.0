Return-Path: <kvm+bounces-23105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 76584946336
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:29:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EDCB81F2216B
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 18:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B213E165EFD;
	Fri,  2 Aug 2024 18:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ToGuxAPC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF3E2746D
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 18:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722623137; cv=none; b=hKWmx+4Z4leLwaL2ZkVBIbVMSAVLWUe84V/yZRxObbgSjadoD4HR9BafLbi6LtnmBo+5+q+7EzXVbA1XZmRZXj4v6McXpL/9XRIHMfc6Gv5FYiULdjHGOs+hX5SHoZFBWrN7vjJeCwKPdkvqeP8at0r8YQZQjVa7ZZvca5ZDN/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722623137; c=relaxed/simple;
	bh=BEFw9QfyhQAWdGLLxA+IIVlNqm5JGfj1yDpXYxrDxzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mXWG+KyUveZeKx7WiSfALjZQeXg6mKd181mUbT0B/5ow6l8Fv/C21Tb39dM2a7raY3HYTPMjOBKP128eX6xWWqf64tfrCuRt6iQqsXhGvmBuxnTbZvC0z6FMwFULPNTwgjiZ790gtnT14gSpbinx+7ZC/1bePWZTHci3q8CdqFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ToGuxAPC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722623134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/s33u1cyS9l5gqjpJrKkR+wJ6Bba5lqX/XxacKFWx9M=;
	b=ToGuxAPCWmhn3LSBfs5WjrfG80Fl9yac05OETI6BsfEfdUMZmsWt9Fhg9tTMDbDLmDTi/2
	/gr1Wfatg67byaRJbvWtJ6r6I6/4J5dhTALP0c2VOn3WNiAgy7lYbHO+dvriwCaDj5gMVJ
	SV1P8pLimoiN9mlpbh8qBKA8kDUvy1E=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-693-_qR8-tyoNrufVa2kLuiO1g-1; Fri, 02 Aug 2024 14:25:33 -0400
X-MC-Unique: _qR8-tyoNrufVa2kLuiO1g-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3994393abd5so128029545ab.0
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 11:25:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722623132; x=1723227932;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/s33u1cyS9l5gqjpJrKkR+wJ6Bba5lqX/XxacKFWx9M=;
        b=dtPeOH56OTVfQui8wrR0C60aH/GaohbvxmJbGvE6x4aRY689VuW7pUQ+1Llnk7REUy
         uR6Q7wL8WZgFz3729kZbvv+Aiyx4wtH/4hQ0PnWefbCqjvQOWM/WQHlTihDmRPl7yHhk
         PaFNpxvIjP+MgkH/QQ/DJJlIWvoEscih/czvplhsh1uN6W17AWgqaw33HoMpwbTRTw6Q
         YLqjP3k6aBJO8CmD3Arle1NQ0+a5/UH5+yCI9WkgVI1Yq9SgULR4cWa9UPKeTfKXWgVh
         g8yVsEOrK+ceWkA1EpG5I8EYkYgoBOLRUhXxNV8hqoaUNEPvNkF8DcTuameNloaQJUSd
         Ra2Q==
X-Forwarded-Encrypted: i=1; AJvYcCX2s74f7zKsqQVLm4UDPj5RoIc90idu2etiQTShicYE6+GM50ApRCBWs0nDTgZ34z3unx0IE6ppeQV8/KPjd9TSUYRW
X-Gm-Message-State: AOJu0YzfwV3pi+9dwxmNcW77m6hLNyFNhKy37srv8MzxZzGZQtpueZJF
	ikRKLSdnP9ior/fgbOxIsGfygrDr5Jlq4em6SeIGiQyCrUt7t4IaTihl9+amUc3Ktxv9F59QpTj
	rcTh/90C0wfimvZL7EuFsSA8NBxyOScyqlU2/Jv+1pmYQ9KHOtA==
X-Received: by 2002:a92:d451:0:b0:396:c825:4db6 with SMTP id e9e14a558f8ab-39b1fc2ed8fmr50145015ab.26.1722623132419;
        Fri, 02 Aug 2024 11:25:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH25oImWddpW5am2xEEU9lYROzp4ymyugBOGoylb9q/oiCsiCRyr2iPzEPnFChpGaHN4lUIGQ==
X-Received: by 2002:a92:d451:0:b0:396:c825:4db6 with SMTP id e9e14a558f8ab-39b1fc2ed8fmr50144655ab.26.1722623131897;
        Fri, 02 Aug 2024 11:25:31 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39b20aa9da4sm9202045ab.23.2024.08.02.11.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Aug 2024 11:25:31 -0700 (PDT)
Date: Fri, 2 Aug 2024 12:25:28 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
 "joro@8bytes.org" <joro@8bytes.org>, "robin.murphy@arm.com"
 <robin.murphy@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
 "nicolinc@nvidia.com" <nicolinc@nvidia.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
 <chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
 <iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
 <baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
 "Pan, Jacob jun" <jacob.jun.pan@intel.com>, =?UTF-8?B?Q8OpZHJpYw==?= Le
 Goater <clg@redhat.com>
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Message-ID: <20240802122528.329814a7.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5276BEBDDD6720C2FEFD4B718CB22@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240419103550.71b6a616.alex.williamson@redhat.com>
	<BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240423120139.GD194812@nvidia.com>
	<BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240424001221.GF941030@nvidia.com>
	<20240424122437.24113510.alex.williamson@redhat.com>
	<20240424183626.GT941030@nvidia.com>
	<20240424141349.376bdbf9.alex.williamson@redhat.com>
	<20240426141117.GY941030@nvidia.com>
	<20240426141354.1f003b5f.alex.williamson@redhat.com>
	<20240429174442.GJ941030@nvidia.com>
	<BN9PR11MB5276C4EF3CFB6075C7FC60AC8CAA2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240730113517.27b06160.alex.williamson@redhat.com>
	<BN9PR11MB5276D184783C687B0B1B6FE68CB12@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240731110436.7a569ce0.alex.williamson@redhat.com>
	<BN9PR11MB5276BEBDDD6720C2FEFD4B718CB22@BN9PR11MB5276.namprd11.prod.outlook.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 1 Aug 2024 07:45:43 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Thursday, August 1, 2024 1:05 AM
> > 
> > On Wed, 31 Jul 2024 05:15:25 +0000
> > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> >   
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Wednesday, July 31, 2024 1:35 AM
> > > >
> > > >  - Seamless live migration of devices requires that configuration space
> > > >    remains at least consistent, if not identical for much of it.  
> > >
> > > I didn't quite get it. I thought being consistent means fully identical
> > > config space from guest p.o.v.  
> > 
> > See for example:
> > 
> > https://gitlab.com/qemu-project/qemu/-
> > /commit/187716feeba406b5a3879db66a7bafd687472a1f  
> 
> Thanks!
> 
> > 
> > The layout of config space and most of the contents therein need to be
> > identical, but there are arguably elements that could be volatile which
> > only need to be consistent.  
> 
> hmm IMHO it's more that the guest doesn't care volatile content in that
> field instead of the guest view being strictly consistent. Probably I
> don't really understand the meaning of consistency in this context...
> 
> btw that fix claims:
> 
>   "
>   Here consistency could mean that VSC format should be same on
>   source and destination, however actual Vendor Specific Info may
>   not be byte-to-byte identical.
>   "
> 
> Does it apply to all devices supporting VSC? It's OK for NVDIA vGPU
> but I'm not sure whether some vendor driver might be sensitive to
> byte-to-byte consistency in VSC.

It applies to all VSC capabilities.  The argument is that there is no
standard definition of the content here therefore QEMU has no authority
to impose a policy on the contents.
 
> > > >
> > > >  - We've discussed in the community and seem to have a consensus that a
> > > >    DVSEC (Designated Vendor Specific Extended Capability) could be
> > > >    defined to describe unused configuration space.  Such a DVSEC could
> > > >    be implemented natively by the device or supplied by a vfio-pci
> > > >    variant driver.  There is currently no definition of such a DVSEC.  
> > >
> > > I'm not sure whether DVSEC is still that necessary if the direction is
> > > to go userspace-defined layout. In a synthetic world the unused
> > > physical space doesn't really matter.
> > >
> > > So this consensus IMHO was better placed under the umbrella of
> > > the other direction having the kernel define the layout.  
> > 
> > I agree that we don't seem to be headed in a direction that requires
> > this, but I just wanted to include that there was a roughly agreed upon
> > way for devices and variant drivers to annotate unused config space
> > ranges for higher levels.  If we head in a direction where the VMM
> > chooses an offset for the PASID capability, we need to keep track of
> > whether this DVSEC comes to fruition and how that affects the offset
> > that QEMU might choose.  
> 
> Yes. We can keep this option in case there is a demand, especially
> if the file-based synthesized scheme won't be built in one day and
> we need a default policy in VMM.
> 
> >   
> > > > So what are we trying to accomplish here.  PASID is the first
> > > > non-device specific virtual capability that we'd like to insert into
> > > > the VM view of the capability chain.  It won't be the last.
> > > >
> > > >  - Do we push the policy of defining the capability offset to the user?  
> > >
> > > Looks yes as I didn't see a strong argument for the opposite way.  
> > 
> > It's a policy choice though, so where and how is it implemented?  It
> > works fine for those of us willing to edit xml or launch VMs by command
> > line, but libvirt isn't going to sign up to insert a policy choice for
> > a device.  If we get to even higher level tools, does anything that
> > wants to implement PASID support required a vendor operator driver to
> > make such policy choices (btw, I'm just throwing out the "operator"
> > term as if I know what it means, I don't).  
> 
> I had a rough feeling that there might be other usages requiring such
> vendor plugin, e.g. provisioning VF/ADI may require vendor specific
> configurations, but not really an expert in this area.
> 
> Overall I feel most of our discussions so far are about VMM-auto-
> find-offset vs. file-based-policy-scheme which both belong to
> user-defined policy, suggesting that we all agreed to drop the other
> way having kernel define the offset (plus in-kernel quirks, etc.)?
> 
> Even the said DVSEC is to assist such user-defined direction.

To me a "user defined policy" is placing an option on the command line
and requiring the user, or some higher level authority representing the
user, to provide the policy.  If it's done by the VMM then we're saying
QEMU owns the policy but it might be overridden by the user via a
command line argument or modifying the policy file consumed by QEMU.
 
> > > >  - Do we do some hand waving that devices supporting PASID shouldn't
> > > >    have hidden registers and therefore the VMM can simply find a gap?  
> > >
> > > I assume 'handwaving' doesn't mean any measure in code to actually
> > > block those devices (as doing so likely requires certain denylist based on
> > > device/vendor ID but then why not going a step further to also hard
> > > code an offset?). It's more a try-and-fail model where vPASID is opted
> > > in via a cmdline parameter then a device with hidden registers may
> > > misbehave if the VMM happens to find a conflict gap. And the impact
> > > is restricted only to a new setup where the user is interested in
> > > PASID  to opt hence can afford diagnostics effort to figure out the  
> > restriction.
> > 
> > If you want to hard code an offset then we're effectively introducing a
> > device specific quirk to enable PASID support.  I thought we wanted
> > this to work generically for any device exposing PASID, therefore I was
> > thinking more of "find a gap" as the default strategy with quirks used
> > to augment the resulting offset where necessary.
> > 
> > I'd also be careful about command line parameters.  I think we require
> > one for the vIOMMU to enable PASID support, but I'd prefer to avoid one
> > on the vfio-pci device, instead simply enabling support when both the
> > vIOMMU support is enabled and the device is detected to support it.
> > Each command line option requires support in the upper level tools to
> > enable it.  
> 
> Make sense. btw will there be a requirement that the user wants to
> disable PASID even if the device supports it, e.g. for testing purpose
> or to workaround a HW errata disclosed after host driver claims the
> support in an old kernel?

We can make use of "experimental options", ie. "x-" prefixed options,
in QEMU for this.  These are useful for debugging but will not be
considered for support by higher level tools nor do we consider them to
have a stable ABI.

> > > > I understand the desire to make some progress, but QEMU relies on
> > > > integration with management tools, so a temporary option for a user to
> > > > specify a PASID offset in isolation sounds like a non-starter to me.
> > > >
> > > > This might be a better sell if the user interface allowed fully
> > > > defining the capability chain layout from the command line and this
> > > > interface would continue to exist and supersede how the VMM might
> > > > otherwise define the capability chain when used.  A fully user defined
> > > > layout would be complicated though, so I think there would still be a
> > > > desire for QEMU to consume or define a consistent policy itself.
> > > >
> > > > Even if QEMU defines the layout for a device, there may be multiple
> > > > versions of that device.  For example, maybe we just add PASID now, but
> > > > at some point we decide that we do want to replicate the PF serial
> > > > number capability.  At that point we have versions of the device which
> > > > would need to be tied to versions of the machine and maybe also
> > > > selected via a profile switch on the device command line.
> > > >
> > > > If we want to simplify this, maybe we do just look at whether the
> > > > vIOMMU is configured for PASID support and if the device supports it,  
> > >
> > > and this is related to the open which I raised in last mail - whether we
> > > want to report the PASID support both in iommufd and vfio-pci uAPI.
> > >
> > > My impression is yes as there may be requirement of exposing a virtual
> > > capability which doesn't rely on the IOMMU.  
> > 
> > What's the purpose of reporting PASID via both iommufd and vfio-pci?  I
> > agree that there will be capabilities related to the iommufd and
> > capabilities only related to the device, but I disagree that that
> > provides justification to report PASID via both uAPIs.  Are we also
> > going to ask iommufd to report that a device has an optional serial
> > number capability?  It clearly doesn't make sense for iommufd to be  
> 
> Certainly no. My point was that vfio-pci/iommufd each reports its
> own capability set. They may overlap but this fact just matches the
> physical world.
> 
> > involved with that, so why does it make sense for vfio-pci to be
> > involved in reporting something that is more iommufd specific?  
> 
> It doesn't matter which one involves more. It's more akin to the
> physical world.
> 
> btw vfio-pci already reports ATS/PRI which both rely on iommufd
> in vconfig space. Throwing PASID alone to iommufd uAPI lacks of a
> good justification for why it's special.
> 
> I envision an extension to vfio device feature or a new vfio uAPI
> for reporting virtual capabilities as augment to the ones filled in
> vconfig space. 

Should ATS and PRI be reported through vfio-pci or should we just turn
them off to be more like PASID?  Maybe the issue simply hasn't arisen
yet because we don't have vIOMMU support and with that support QEMU
might need to filter out those capabilities and look elsewhere.
Anyway, iommufd and vfio-pci should not duplicate each other here.

> > > > then we just look for a gap and add the capability.  If we end up with
> > > > different results between source and target for migration, then
> > > > migration will fail.  Possibly we end up with a quirk table to override
> > > > the default placement of specific capabilities on specific devices.  
> > >
> > > emm how does a quirk table work with devices having volatile config
> > > space layout cross FW versions? Can VMM assigned with a VF be able
> > > to check the FW version of the PF?  
> > 
> > If the VMM can't find the same gap between source and destination then
> > a quirk could make sure that the PASID offset is consistent.  But also
> > if the VMM doesn't find the same gap then that suggests the config
> > space is already different and not only the offset of the PASID
> > capability will need to be fixed via a quirk, so then we're into
> > quirking the entire capability space for the device.  
> 
> yes. So the quirk table is more for fixing the functional gap (i.e. not
> overlap with a hidden register) instead of for migration. As long as
> a device can function correctly with it, the virtual caps fall into the
> same restriction as physical caps in migration i.e. upon inconsistent
> layout between src/dest we'll need separate way to synthesize the
> entire space.

Yes.

> > The VMM should not be assumed to have any additional privileges beyond
> > what we provide it through the vfio device and iommufd interface.
> > Testing anything about the PF would require access on the host that
> > won't work in more secure environments.  Therefore if we can't
> > consistently place the PASID for a device, we probably need to quirk it
> > based on the vendor/device IDs or sub-IDs or we need to rely on a
> > management implied policy such as a device profile option on the QEMU
> > command line or maybe different classes of the vfio-pci driver in QEMU.
> >   
> > > > That might evolve into a lookup for where we place all capabilities,
> > > > which essentially turns into the "file" where the VMM defines the entire
> > > > layout for some devices.  
> > >
> > > Overall this sounds a feasible path to move forward - starting with
> > > the VMM to find the gap automatically if a new PASID option is
> > > opted in. Devices with hidden registers may fail. Devices with volatile
> > > config space due to FW upgrade or cross vendors may fail to migrate.
> > > Then evolving it to the file-based scheme, and there is time to discuss
> > > any intermediate improvement (fixed quirks, cmdline offset, etc.) in
> > > between.  
> > 
> > As above, let's be careful about introducing unnecessary command line
> > options, especially if we expect support for them in higher level
> > tools.  If we place the PASID somewhere that makes the device not work,
> > then disabling PASID on the vIOMMU should resolve that.  It won't be a  
> 
> vIOMMU is per-platform then it applies to all devices behind, including
> those which don't have a problem with auto-selected offset. Not sure
> whether one would want to continue enabling PASID for other devices
> or should stop immediately to find a quirk for the problematic one and
> then resume.

I'm not sure if this is a real issue, we're talking about a VM, not a
server.  If a user wants PASID support and it's incompatible with a
device, the device can be excluded from the VM or we can have an
experimental option on the vfio-pci device in QEMU as a workaround.  I
don't think this is something we need to plumb up through the tool
stack.  Thanks,

Alex


