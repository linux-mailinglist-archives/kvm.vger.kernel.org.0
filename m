Return-Path: <kvm+bounces-58600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C955B97B50
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 00:23:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 669FE1AE214C
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 22:24:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07536A48;
	Tue, 23 Sep 2025 22:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EXFBTS+d"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C09288C8B
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 22:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758666227; cv=none; b=Smt6OCKWIaGNZikZU0RCEG0U+eD2rMlEPr5z69zsLBvTISvjwgufMG7GtzVP9KVi2GCnwOC5nENAbNfkm1zN+9TkmVQfNWYAVemp0ZPs4Tj/8z0tghZgBSdGIjlFI7vMPrrL2A38TZGz08wBmhi2SYoRAZiMIfUXaA/6lJ0iH1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758666227; c=relaxed/simple;
	bh=uTuOhaiVnMw8+HEd6YtKuov7vIEq+l91UdYka5tjKSs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QeqPFlqpgYmsI9UoQZJJmFCd21YkinOmqrDwGogg1OOGo+exERg9GrWl9k+TMJ9OmNxCnq46AIubBCsNzxFMBt5GjPsqmhNJaaNAD5LeacqiawwOlqBeUdcKXJOF7Fo8xesEUMuf7gqME/++NX0vc+w7sTgW/YIQIHzXPihJhaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EXFBTS+d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758666224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1CMpiBPmpDazoQg8tDEg8758JA66nYm58i1c8T8sygQ=;
	b=EXFBTS+dp7QN9pjvpaKyrTHGNqNkw3s1/bLEncu3tswU87JIEua77eJmndGgVXtwf4HeDC
	h4cX2XY6bjOOU7Hfg3qMtbxH5SAmUqVQZzAdrm6eK9SSBrQNZOjhs7TzHdSMs2zHWrgsmR
	Pmiw4m7TowAKe7XmZCnodjUrlnD2Ncw=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-279-7sQSdZJYMFCSIKbeRjvmEg-1; Tue, 23 Sep 2025 18:23:42 -0400
X-MC-Unique: 7sQSdZJYMFCSIKbeRjvmEg-1
X-Mimecast-MFC-AGG-ID: 7sQSdZJYMFCSIKbeRjvmEg_1758666222
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-4240abfbce2so11226275ab.1
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 15:23:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758666222; x=1759271022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1CMpiBPmpDazoQg8tDEg8758JA66nYm58i1c8T8sygQ=;
        b=FRUAFpL4gFEgKDS5jPUE4EaT62Ae0v5RmQmzb02smt5AlmWVY6s6M51XCBKSTqM6mF
         uUaeh6XSAkNC2qB/WmEzDehTxU1KzApoS0Ja1NRao7l6P7rir97t+y/En1xSA2l3yVOy
         ihVeXT5UlYoXzJj/7hYZSF37hT9VxDXm4sOXVBF8XnCaTfpqnSDF2qngNPHZSHOPg9Sr
         LylcAH0zl8/pvOb4L1kusciF9VVXXeb1W5wiImPK+7CXVnmedjCmFCotQgARPreBk0g6
         9fAP/jRQ4fIrz4rleG1ZYQTgnSnQFueHyFe0j+NJWmCfjFYwcrvKOGOGMJTqrbbUafoL
         Qb4g==
X-Forwarded-Encrypted: i=1; AJvYcCWGwnSOZ5f9c8z0rDCHkoEJvVpvG60mheo5kT39/wDG7gtcR8i1czAIG3UxJlqZW8ywfKg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQAxDyn6qJpA6LI6prFsKuDz+c1wkE1tF4aWsD+jPlGMNXN8WP
	57yX8Rb2tyty9HlSKkbwwFpyWP2xCHMLnsk72kuYIhq9a4eVzCNCqO/SOIR+2g/f7gRaE1M5GX8
	Mj4wwBkwROs1rmlV5spH25V6BjUf2Z6FLm30yvizHms9Cd2cks2trpQ==
X-Gm-Gg: ASbGnctUIJcZp/zqFHHOPlvXTeeG2oPuWcjT0+O+aCTv4fYbfQBqoOkDV3bDm3fz2kL
	n0CZ2xv3BXZ9kjlVqpVC5gx30x7Eoza1GYcWaypQnXXdIQTTNOwpXSl9mIeqdbBL+Mhq7keYD4o
	Z1s05r3Y3Z68CYwK26HDDeET1O08z+3FLEv1ImeM0bsAst9vAcaZ3pjFAcmspKhKRe6OxDxvGlT
	K0YXjzqtcVfA7XO0QZbrDGvldjHa7kcAlOBXjMI62QAVhUQy2p5Ryic3LtHL8snSfs7IniwJNNK
	CaK1YnMuwPemKwU8syDB60qtQHcf/UqIw9vyH64EW2o=
X-Received: by 2002:a05:6e02:1062:b0:425:84b6:a7de with SMTP id e9e14a558f8ab-42584b6aa30mr16612135ab.0.1758666221849;
        Tue, 23 Sep 2025 15:23:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHEYi+vOF7CkWzpb7ZxI27OTwSRimDBvfOl9asq3cQr41YZxMUP1z+tPEOTecgdneH3kKaeZg==
X-Received: by 2002:a05:6e02:1062:b0:425:84b6:a7de with SMTP id e9e14a558f8ab-42584b6aa30mr16612005ab.0.1758666221303;
        Tue, 23 Sep 2025 15:23:41 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-4257c9b22afsm26303895ab.26.2025.09.23.15.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 15:23:40 -0700 (PDT)
Date: Tue, 23 Sep 2025 16:23:37 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Donald Dutile <ddutile@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>, Will Deacon
 <will@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 galshalom@nvidia.com, Joerg Roedel <jroedel@suse.de>, Kevin Tian
 <kevin.tian@intel.com>, kvm@vger.kernel.org, maorg@nvidia.com,
 patches@lists.linux.dev, tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH v3 00/11] Fix incorrect iommu_groups with PCIe ACS
Message-ID: <20250923162337.5ab1fe89.alex.williamson@redhat.com>
In-Reply-To: <0eb2e721-8b9c-40d0-afe7-c81c6b765f49@redhat.com>
References: <0-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
	<20250922163947.5a8304d4.alex.williamson@redhat.com>
	<e9d4f76a-5355-4068-a322-a6d5c081e406@redhat.com>
	<20250922200654.1d4ff8b8.alex.williamson@redhat.com>
	<0eb2e721-8b9c-40d0-afe7-c81c6b765f49@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Sep 2025 22:42:37 -0400
Donald Dutile <ddutile@redhat.com> wrote:

> On 9/22/25 10:06 PM, Alex Williamson wrote:
> > On Mon, 22 Sep 2025 21:44:27 -0400
> > Donald Dutile <ddutile@redhat.com> wrote:
> >   
> >> On 9/22/25 6:39 PM, Alex Williamson wrote:  
> >>> On Fri,  5 Sep 2025 15:06:15 -0300
> >>> Jason Gunthorpe <jgg@nvidia.com> wrote:
> >>>      
> >>>> The series patches have extensive descriptions as to the problem and
> >>>> solution, but in short the ACS flags are not analyzed according to the
> >>>> spec to form the iommu_groups that VFIO is expecting for security.
> >>>>
> >>>> ACS is an egress control only. For a path the ACS flags on each hop only
> >>>> effect what other devices the TLP is allowed to reach. It does not prevent
> >>>> other devices from reaching into this path.
> >>>>
> >>>> For VFIO if device A is permitted to access device B's MMIO then A and B
> >>>> must be grouped together. This says that even if a path has isolating ACS
> >>>> flags on each hop, off-path devices with non-isolating ACS can still reach
> >>>> into that path and must be grouped gother.
> >>>>
> >>>> For switches, a PCIe topology like:
> >>>>
> >>>>                                  -- DSP 02:00.0 -> End Point A
> >>>>    Root 00:00.0 -> USP 01:00.0 --|
> >>>>                                  -- DSP 02:03.0 -> End Point B
> >>>>
> >>>> Will generate unique single device groups for every device even if ACS is
> >>>> not enabled on the two DSP ports. It should at least group A/B together
> >>>> because no ACS means A can reach the MMIO of B. This is a serious failure
> >>>> for the VFIO security model.
> >>>>
> >>>> For multi-function-devices, a PCIe topology like:
> >>>>
> >>>>                     -- MFD 00:1f.0 ACS not supported
> >>>>     Root 00:00.00 --|- MFD 00:1f.2 ACS not supported
> >>>>                     |- MFD 00:1f.6 ACS = REQ_ACS_FLAGS
> >>>>
> >>>> Will group [1f.0, 1f.2] and 1f.6 gets a single device group. However from
> >>>> a spec perspective each device should get its own group, because ACS not
> >>>> supported can assume no loopback is possible by spec.  
> >>>
> >>> I just dug through the thread with Don that I think tries to justify
> >>> this, but I have a lot of concerns about this.  I think the "must be
> >>> implemented by Functions that support peer-to-peer traffic with other
> >>> Functions" language is specifying that IF the device implements an ACS
> >>> capability AND does not implement the specific ACS P2P flag being
> >>> described, then and only then can we assume that form of P2P is not
> >>> supported.  OTOH, we cannot assume anything regarding internal P2P of an
> >>> MFD that does not implement an ACS capability at all.
> >>>      
> >> The first, non-IF'd, non-AND'd req in PCIe spec 7.0, section 6.12.1.2 is:
> >> "ACS P2P Request Redirect: must be implemented by Functions that
> >> support peer-to-peer traffic with other Functions. This includes
> >> SR-IOV Virtual Functions (VFs)." There is not further statement about
> >> control of peer-to-peer traffic, just the ability to do so, or not.
> >>
> >> Note: ACS P2P Request Redirect.
> >>
> >> Later in that section it says:
> >> ACS P2P Completion Redirect: must be implemented by Functions that
> >> implement ACS P2P Request Redirect.
> >>
> >> That can be read as an 'IF Request-Redirect is implemented, than ACS
> >> Completion Request must be implemented. IOW, the Completion Direct
> >> control is required if Request Redirect is implemented, and not
> >> necessary if Request Redirect is omitted.
> >>
> >> If ACS P2P Require Redirect isn't implemented, than per the first
> >> requirement for MFDs, the PCIe device does not support peer-to-peer
> >> traffic amongst its function or virtual functions.
> >>
> >> It goes on...
> >> ACS Direct Translated P2P: must be implemented if the Function
> >> supports Address Translation Services (ATS) and also peer-to-peer
> >> traffic with other Functions.
> >>
> >> If an MFD does not do peer-to-peer, and P2P Request Redirect would be
> >> implemented if it did, than this ACS control does not have to be
> >> implemented either.
> >>
> >> Egress control structures are either optional or dependent on Request
> >> Redirect &/or Direct Translated P2P control, which have been
> >> addressed above as not needed if on peer-to-peer btwn functions in an
> >> MFD (and their VFs).
> >>
> >>
> >> Now, if previous PCIe spec versions (which I didn't read & re-read &
> >> re-read like the 6.12 section of PCIe spec 7.0) had more IF and ANDs,
> >> than that could be cause for less than clear specmanship enabling
> >> vendors of MFDs to yield a non-PCIe-7.0 conformant MFD wrt ACS
> >> structures. I searched section 6.12.1.2 for if/IF and AND/and, and
> >> did not yield any conditions not stated above.  
> > 
> > Back up to 6.12.1:
> > 
> >    ACS functionality is reported and managed via ACS Extended Capability
> >    structures. PCI Express components are permitted to implement ACS
> >    Extended Capability structures in some, none, or all of their
> >    applicable Functions. The extent of what is implemented is
> >    communicated through capability bits in each ACS Extended Capability
> >    structure. A given Function with an ACS Extended Capability structure
> >    may be required or forbidden to implement certain capabilities,
> >    depending upon the specific type of the Function and whether it is
> >    part of a Multi-Function Device.
> >   
> Right, depending on type of function or part of MFD.
> Maybe I mis-understood your point, or vice-versa:
> section 6.12.1.2 is for MFDs, and I was only discussing MFD ACS structs.
> I did not mean to imply the sections I was quoting was for anything but an MFD.

I'm really going after the first half of that last sentence rather than
any specific device type:

  A given Function with an ACS Extended Capability structure may be
  required or forbidden to implement certain capabilities...

"...[WITH] an ACS Extended Capbility structure..."

"implement certain capabilities" is referring to the capabilities
exposed within the capability register of the overall ACS extended
capability structure.

Therefore when section 6.12.1.2 goes on to say:

  ACS P2P Request Redirect: must be implemented by Functions that
  support peer-to-peer traffic with other Functions.

This is saying this type of function _with_ an ACS extended capability
(carrying forward from 6.12.1) must implement the p2p RR bit of the ACS
capability register (a specific bit within the register, not the ACS
extended capability) if it is capable of p2p traffic with other
functions.  We can only infer the function is not capable of p2p traffic
with other functions if it both implements an ACS extended capability
and the p2p RR bit of the capability register is zero.

> > What you're quoting are the requirements for the individual p2p
> > capabilities IF the ACS extended capability is implemented.
> >   
> No, I'm not.  I'm quoting 6.12.1.2, which is MFD-specific.
> 
> > Section 6.12.1.1 describing ACS for downstream ports begins:
> > 
> >    This section applies to Root Ports and Switch Downstream Ports
> >   that implement an ACS Extended Capability structure.
> > 
> > Section 6.12.1.2 for SR-IOV, SIOV and MFDs begins:
> > 
> >    This section applies to Multi-Function Device ACS Functions,
> >   with the exception of Downstream Port Functions, which are
> >   covered in the preceding section.
> >   
> Right.  I wasn't discussing Downstream port functions.
> 
> > While not as explicit, what is a Multi-Function Device ACS Function
> >   if not a function of a MFD that implements ACS?
> >   
> I think you are inferring too much into that less-than-optimally
>   worded section.
> 
> >>> I believe we even reached agreement with some NIC vendors in the
> >>> early days of IOMMU groups that they needed to implement an
> >>>   "empty" ACS capability on their multifunction NICs such that
> >>>   they could describe in this way that internal P2P is not
> >>>   supported by the device.  Thanks,  
> >> In the early days -- gen1->gen3 (2009->2015) I could see that
> >> happening. I think time (a decade) has closed those defaults to
> >> less-common quirks. If 'empty ACS' is how they liked to do it back
> >> than, sure. [A definition of empty ACS may be needed to fully
> >> appreciate that statement, though.] If this patch series needs to
> >> support an 'empty ACS' for this older case, let's add it now, or
> >> follow-up with another fix.  
> > 
> > An "empty" ACS capability is an ACS extended capability where the
> >   ACS capability register reads as zero, precisely to match the
> >   spec in indicating that the device does not support p2p.  Again,
> >   I don't see how time passing plays a role here.  A MFD must
> >   implement ACS to infer anything about internal p2p behavior.
> >     
> Again, I don't read the 'must' in the spec.
> Although I'll agree that your definition of an empty ACS makes it
>   unambiguous.
> 
> >> In summary, I still haven't found the IF and AND you refer to in
> >> section 6.12.1.2 for MFDs, so if you want to quote those sections I
> >> mis-read, or mis-interpreted their (subtle?) existence, than I'm
> >>   not immovable on the spec interpretation.  
> > 
> > As above, I think it's covered by 6.12.1 and the introductory
> >   sentence of 6.12.1.2 defining the requirements for ACS functions.
> >    Thanks, 
> 6.12.1 is not specific enough about what MFDs must or must not
>   support; it's a broad description of ACS in different PCIe
>   functions. As for 6.12.1.2, I stand by the statement that ACS P2P
>   Request Redirect must be implemented if peer-to-peer is implemented
>   in an MFD. It's not inferred, it's not unambiguous.
> You are intepreting the first sentence in 6.12.1.2 as indirectly
>   saying that the reqs only apply to an MFD with ACS.  The title of
>   the section is: "ACS Functions in SR-IOV, SIOV, and Multi-Function
>   Devices"  not ACS requirements for ACS-controlled SR-IOV, SIOV, and
>   Multi-Function Devices", in which case, I could agree with the
>   interpretation you gave of that first sentence.
> 
> I think it's time to reach out to the PCI-SIG, and the authors of
>   this section to dissect these interpretations and get some clarity.

You're welcome to.  I think it's sufficiently clear.

The specification is stating that if a function exposes an ACS extended
capability and the function supports p2p with other functions, it must
implement that specific bit in the ACS capability register of the ACS
extended capability.

Therefore if the function implements an ACS extended capability and
does not implement this bit in the ACS capability register, we can
infer that the device does is not capable of p2p with other functions.
It would violate the spec otherwise.

However, if the function does not implement an ACS extended capability,
we can infer nothing.

It's logically impossible for the specification to add an optional
extended capability where the lack of a function implementing the
extended capability implies some specific behavior.  It's not backwards
compatible, which is a fundamental requirement of the PCI spec.  Thanks,

Alex


