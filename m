Return-Path: <kvm+bounces-49768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B6EFAADDE31
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 23:50:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59C9C17E82A
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 21:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DD4D28C00E;
	Tue, 17 Jun 2025 21:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OhkUuYOB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAFE277CB4
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 21:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750197012; cv=none; b=jToW+VhAwHEBuD+QC65SKGgIigmdRKr+EUvTUYvMmJ70QVcG2zKly1y9DLwkvu49aU/CM3h+yZjbisuyBnhmtgwIrO/k56aXed0fyIh3hspFIUZ/4IquqaU5bl1fYIhmfRl7xQZVIEzBDFio6JGs8V6Dj/SPfj3AaUA5SVIDx7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750197012; c=relaxed/simple;
	bh=7hg3diAfSTflKx1ekrefsRo12RxfH5pUGgLV5fLTmQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kW1LkeW9NZ/E2E9sDLbQ9wtW7+Er2Wl1qEmZ6PUhYc1jXCOvW+TQttHvoRMuKp4p4rZcS0InDm/wvevbY3XOYrS5ZMuJ6E/rV9791sWWD7IOOBV1d84r8FXffrvBJoSyFbyyn9yOsS5PL+do1/+cD44EN1zxnEqfFKCStdCdplg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OhkUuYOB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750197007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fBKdNTag+8kHHBGbrlvR1RGtOCqp0CC7Lr8789j1j90=;
	b=OhkUuYOBtTFVucOnjezu7BvWbv8YEBqXbZw+mdmbaRiW13KFXGC78J3+nOBtjWKorEkVqK
	+J92uBhJQjakVGVyTdDekioxw20zrPUeuc1mzfKciKO4CPG8dS0aJM+DMV35lvnKQuJiTM
	ELtcMQQBpRVcpqHxR4oDE7QWFV/yUQ4=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-pJp23ZT1PNKEAhnWaPH6Dg-1; Tue, 17 Jun 2025 17:50:06 -0400
X-MC-Unique: pJp23ZT1PNKEAhnWaPH6Dg-1
X-Mimecast-MFC-AGG-ID: pJp23ZT1PNKEAhnWaPH6Dg_1750197002
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-86cff09d29dso88482039f.3
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 14:50:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750197002; x=1750801802;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fBKdNTag+8kHHBGbrlvR1RGtOCqp0CC7Lr8789j1j90=;
        b=ktlyPbdB5egT6WxPOmF0VisDj1mrYBaBJ/9dID+HqIB3EuBLwykC2/b8DxclMlIvud
         KCdy4YNOfUXm1N1RgnhNo1phVOOW1l3y1wsZMwTNS7dxxDkjjFxYLpbjQeem/swmDn2y
         Q9kMVrfiPvztn5g2Y89kaUb0ZoFdTIQty9FE4xuAFUY+4YMMQ3dI93Hz06xBCUymd++M
         VLAyFgT15TWE0E87u8LylLQV5EJdjzziqOZfL7iFlY3T77UM2HOGKi1Fd479pvE8VlHF
         cGhiXyLGed91Jg/O9bGolas3NMK4uDhJKSxrrjylAaBVXMRVJkDKxIcewB6zCS8NKY5G
         mp2w==
X-Forwarded-Encrypted: i=1; AJvYcCWowQUW8QY6rx7oHwdP0uYCjQA5MH1XU+U7IS4QF4syrjdDd2ueiDntmQNezVszakqcf3I=@vger.kernel.org
X-Gm-Message-State: AOJu0YycF94MvI+Nee0FIR0OyyUhzqb5yMEyMd+GJBy9/vnP844UY0+I
	ZCw1PLwzXWeplvOeMHlsJv1MqR2xCWDwrP2uv6yQSTzQeC17Dudk6ywXIIEh85OpcsozLSjd3zj
	Q8tlLAo7T37AlHaaygD0hoTvGP8RaCA/LupWykt0+G6ljZqgXba9xdA==
X-Gm-Gg: ASbGncu3zURaWMyzyzAS3471WxyZ+fMgnGZpVs/bmwWTkI6D+QGwnhiuhCEk/UIedfe
	o9I1pnSzFel6NJvfyhJFw12RYT2KGt7UfBLgJgMB+/YtZ4zlytLpTQQiIRjXaAbGC+D/K5ltGcn
	bymc8knUjAThNdyU3MgDmiW7FOjTt2KIA0xXK8SCCGw3pP2zSNYuiM+n/2t/2F/ymxoDg8j9vK4
	91v9PmnhzSAQpNNthocoH5spmtbrYZhjfAFZR7nrSOw60sGp5w/ojLrB7jvf3fqMbeNF33m2Lp1
	UYeuqsXRgn8TXudAwimRB3iYbw==
X-Received: by 2002:a92:c267:0:b0:3dc:7ba2:7a2e with SMTP id e9e14a558f8ab-3de07cd4de3mr48365985ab.3.1750197002232;
        Tue, 17 Jun 2025 14:50:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEw17zHi8Y9Wb/PhxrxSkYd31JRhlQUJWVwqBEfsj4LLkKjncc5bMw2gyst2ZndPGvwl0QioA==
X-Received: by 2002:a92:c267:0:b0:3dc:7ba2:7a2e with SMTP id e9e14a558f8ab-3de07cd4de3mr48365855ab.3.1750197001760;
        Tue, 17 Jun 2025 14:50:01 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50149bb529fsm2445872173.60.2025.06.17.14.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 14:50:01 -0700 (PDT)
Date: Tue, 17 Jun 2025 15:49:57 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Daniel Dadap <ddadap@nvidia.com>
Cc: Mario Limonciello <superm1@kernel.org>, Bjorn Helgaas
 <bhelgaas@google.com>, Alex Deucher <alexander.deucher@amd.com>, Christian
 =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Lukas Wunner
 <lukas@wunner.de>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann
 <tzimmermann@suse.de>, David Woodhouse <dwmw2@infradead.org>, Lu Baolu
 <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>, Will Deacon
 <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Jaroslav Kysela
 <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, "open list:DRM DRIVERS"
 <dri-devel@lists.freedesktop.org>, open list
 <linux-kernel@vger.kernel.org>, "open list:INTEL IOMMU (VT-d)"
 <iommu@lists.linux.dev>, "open list:PCI SUBSYSTEM"
 <linux-pci@vger.kernel.org>, "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
 "open list:SOUND" <linux-sound@vger.kernel.org>, Mario Limonciello
 <mario.limonciello@amd.com>
Subject: Re: [PATCH v2 6/6] vgaarb: Look at all PCI display devices in VGA
 arbiter
Message-ID: <20250617154957.67144f0a.alex.williamson@redhat.com>
In-Reply-To: <aFHWejvqNpGv-3UI@ddadap-lakeline.nvidia.com>
References: <20250617175910.1640546-1-superm1@kernel.org>
	<20250617175910.1640546-7-superm1@kernel.org>
	<aFHABY5yTYrJ4OUw@ddadap-lakeline.nvidia.com>
	<d40a585f-6eca-45dd-aa9f-7dcda065c80a@kernel.org>
	<aFHWejvqNpGv-3UI@ddadap-lakeline.nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 17 Jun 2025 15:56:26 -0500
Daniel Dadap <ddadap@nvidia.com> wrote:

> On Tue, Jun 17, 2025 at 03:15:35PM -0500, Mario Limonciello wrote:
> > 
> > 
> > On 6/17/25 2:20 PM, Daniel Dadap wrote:  
> > > On Tue, Jun 17, 2025 at 12:59:10PM -0500, Mario Limonciello wrote:  
> > > > From: Mario Limonciello <mario.limonciello@amd.com>
> > > > 
> > > > On a mobile system with an AMD integrated GPU + NVIDIA discrete GPU the
> > > > AMD GPU is not being selected by some desktop environments for any
> > > > rendering tasks. This is because neither GPU is being treated as
> > > > "boot_vga" but that is what some environments use to select a GPU [1].
> > > > 
> > > > The VGA arbiter driver only looks at devices that report as PCI display
> > > > VGA class devices. Neither GPU on the system is a PCI display VGA class
> > > > device:
> > > > 
> > > > c5:00.0 3D controller: NVIDIA Corporation Device 2db9 (rev a1)
> > > > c6:00.0 Display controller: Advanced Micro Devices, Inc. [AMD/ATI] Device 150e (rev d1)
> > > > 
> > > > If the GPUs were looked at the vga_is_firmware_default() function actually
> > > > does do a good job at recognizing the case from the device used for the
> > > > firmware framebuffer.
> > > > 
> > > > Modify the VGA arbiter code and matching sysfs file entries to examine all
> > > > PCI display class devices. The existing logic stays the same.
> > > > 
> > > > This will cause all GPUs to gain a `boot_vga` file, but the correct device
> > > > (AMD GPU in this case) will now show `1` and the incorrect device shows `0`.
> > > > Userspace then picks the right device as well.
> > > > 
> > > > Link: https://github.com/robherring/libpciaccess/commit/b2838fb61c3542f107014b285cbda097acae1e12 [1]
> > > > Suggested-by: Daniel Dadap <ddadap@nvidia.com>
> > > > Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
> > > > Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> > > > ---
> > > >   drivers/pci/pci-sysfs.c | 2 +-
> > > >   drivers/pci/vgaarb.c    | 8 ++++----
> > > >   2 files changed, 5 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> > > > index 268c69daa4d57..c314ee1b3f9ac 100644
> > > > --- a/drivers/pci/pci-sysfs.c
> > > > +++ b/drivers/pci/pci-sysfs.c
> > > > @@ -1707,7 +1707,7 @@ static umode_t pci_dev_attrs_are_visible(struct kobject *kobj,
> > > >   	struct device *dev = kobj_to_dev(kobj);
> > > >   	struct pci_dev *pdev = to_pci_dev(dev);
> > > > -	if (a == &dev_attr_boot_vga.attr && pci_is_vga(pdev))
> > > > +	if (a == &dev_attr_boot_vga.attr && pci_is_display(pdev))
> > > >   		return a->mode;  
> > > 
> > > I can't help but worry about userspace clients that might be checking for
> > > the presence of the boot_vga sysfs file but don't check its contents.  
> > 
> > Wouldn't those clients "already" be broken by such an assumption?
> > We know today that there are systems with two VGA devices in them too.
> >  
> 
> Yes, for systems with multiple VGA devices, which is an uncommon case. I
> think that on systems with one VGA device and one 3D device, which is
> probably the most common case, this change might break such clients.

FWIW, this is exactly the opposite of what I'd expect is the common
case.  IME, an integrated GPU and discrete GPU, or multiple discrete
GPUs are all VGA devices.

> > I'd think those should have both GPUs exporting a file and one having a 0
> > the other 1.  
> 
> Yeah, agreed. I'd consider it a userspace bug if the client only tests for
> the presence of the file but doesn't look at its contents, but it's still
> preferable not to break (hypothetical, buggy) clients unnecessarily. One
> could make a philosophical argument that "boot_vga" should really mean VGA
> subclass, as the name implies, but even so I think that, in lieu of a new
> interface to report what the desktop environments are actually trying to
> test for (which nobody uses yet because it doesn't exist), exposing the
> boot_vga file for a non-VGA GPU in the special case of there being zero
> VGA GPUs on the system is a reasonable and practical compromise to allow
> existing code to work on the zero-VGA systems.
> 
> I think it ultimately comes down to a semantic argument about what "VGA"
> is really supposed to mean here. There's the real, honest-to-goodness VGA
> interface with INT 10h and VBE, and then there's the common de facto sort
> of shorthand convention (commonly but not universally followed) where VGA
> means it can drive displays and 3D means it can't. It used to be the case
> (at least on x86) that display controllers which could drive real display
> hardware were always VGA-compatible, and display controllers were not VGA
> compatible could never drive real display hardware, which I think is how
> that convention originated, but on UEFI systems with no CSM support, it's
> not necessarily true any more. However, there's so much existing software
> out there that conflates VGA-ness with display-ness that some controllers
> with no actual VGA support get listed with the VGA controller subclass to
> avoid breaking such software.
> 
> If you go by the language of the definitions for the subclasses of PCI
> base class 03h, it seems pretty clear that the VGA subclass is supposed
> to mean actually compatible with real honest-to-goodness VGA. So those
> non-VGA devices that pretend to be VGA for software compatibility aren't
> following the spec. I'd be willing to wager that the system in question
> is being accurate when it says that it has no VGA controllers. It is
> arguably a userspace bug that these desktop environments are testing for
> "VGA" when they really probably mean something else, but it will probably
> take some time to hunt down everything that's relying on boot_vga for
> possibly wrong reasons, and I think the pragmatic option is to lie about
> it until we have a better way to test for whatever the desktops really
> want to know, and that better way is widely used. But it would be nice to
> limit the lying to cases where it unbreaks things if we can.

I don't know if you have wiggle room with boot_vga specifically, I
generally take it at face value that it's a VGA device and imo seems
inconsistent to suggest otherwise.  I do note however that there's
really no philosophical discussion related to the VGA arbiter, it is
managing devices and routing among them according to the strict PCI
definition of VGA.

Elsewhere in the kernel we can see that vga_default_device() is being
used for strictly VGA related things, the VGA shadow ROM and legacy VGA
resource aperture resolution for instance.  It's unfortunate that the
x86 video_is_primary_device() relies on it, but that seems like a
growing pain of introducing non-VGA displays on a largely legacy
encumbered architecture and should be addressed.

Note that it should probably be considered whether VGA_ARB_MAX_GPUS
needs a new default value if all display adapters were to be included.
Thanks,

Alex


