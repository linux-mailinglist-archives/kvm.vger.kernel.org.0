Return-Path: <kvm+bounces-16080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D26C8B40B4
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 22:14:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 410211C225E7
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 20:14:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 785FA22334;
	Fri, 26 Apr 2024 20:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eN28gmFK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2780E2032A
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 20:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714162443; cv=none; b=CxrH2uez5S4HutUa5nRXJTFe8YvQbm1FyVargVXIJrtcOFuCONWXQ2j4USLzafnQYdXMoKtbue9gvAAC9hAZ3zgZqdjmpOyvW5SEjbNILhplC/x8Q9DoQhQGMQn5TXeRqLLbMn6qF/MRIJRadyVL7Ns9gHO6EhmgvysRumFtgtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714162443; c=relaxed/simple;
	bh=9SiXKJV+UYlxQscyR6k1hUddQILrJmGCwSLQDNAju70=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SNPyCbqoUDwzPvWLm79lhxN/KpChRfLiAZMMKZjM82hqfkUT1B1XrNSVyrmq5aHQ+C2LETUtrAiHw4Bzw4yK6XKJnvq3nozCyBRHRJYQIyJETgnI6y9zwfDGJT1l2cpUKoVolxOubdEkRHo2eLcET5RJeIccz6Jis8q02lqc4cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eN28gmFK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714162441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8kKazOc9qk6A4uGx0ir5JoFPS0z17L0g4Jjhk7nh8W8=;
	b=eN28gmFKHj7tXhCGQSdAxcRTlpN4of3C04lfDFBIdV8w0NLu3gHkEMefqHltoJqpAGnw/W
	lvdH4XpYcfMRs94ummqOSDJFgpD6aPSfjKfTJrDtjHXjv1r6aE6w2CxG4PNmpEEBkqlDen
	+oUcMGCakxbId2H06PQh5rIkUmwKGZM=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-2qecwQA_PT6malKIyYA0Lg-1; Fri, 26 Apr 2024 16:13:59 -0400
X-MC-Unique: 2qecwQA_PT6malKIyYA0Lg-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-36b34b3a5fdso24079595ab.0
        for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 13:13:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714162439; x=1714767239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8kKazOc9qk6A4uGx0ir5JoFPS0z17L0g4Jjhk7nh8W8=;
        b=fSXjLGRiNnqvBX/InhtMkqsFQ+SsNF5elPlXfgrkw+WqDDxQdNarFNix5PKm7AjeVm
         dfmm9tv+eAAfrZTA/E6hldSOCTIUov/WXsHPlHrL90UglQvnLX6g6EL8Y3F1Ah+qzZhJ
         DovRQiyY35HPi4GJTQp7g7vCrJn1uSw4PBK9wyO0FA1DLA1INDZg0GzDFax8qh7BiZfo
         nv3pSccBlZrwOn7c+46MaHEKru50KAcPYyRzXLIQa3BssdSR9V2xBschzk488m9Ecaaz
         PH1cwKu8g7ISLu6E55YQrsABL+ITra7etkYe86RisqP508p5n5BmCulOk0tyqxvT840V
         ToaA==
X-Forwarded-Encrypted: i=1; AJvYcCUzdwo3rLAs+/L1iF5XcUhRO+r3GjQeVWEFAmxddfzitoKt6xqUfWNUVuzG7Q92Qsp3Cdp/Qeqa1I2foOYabk0JwNsw
X-Gm-Message-State: AOJu0YxGVkQb31xqTU833xx8EulrLh66X5lC+CcGCNvwDxD8VkPEh5jo
	XRqfSrrWVPXK8d9v8ZsGdHvjJbnhJEaDlDLq2tWFEk0xxG7bifb1aLDNzKrZj+AYdWm1xIDflM6
	/hz90tV00KBD2rDTc7tEbaGr7ZpRqVtpKwbOJrurgN1aG4hkgMQ==
X-Received: by 2002:a05:6e02:1b08:b0:369:c0a3:2ad7 with SMTP id i8-20020a056e021b0800b00369c0a32ad7mr4559137ilv.12.1714162438857;
        Fri, 26 Apr 2024 13:13:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF/bOY8zg1Sw4uTwmZH3nmuvKbetISUmtPVe+7fTuKUiyq1sJnjYVdwfQl6dYscmLxPP4OYsQ==
X-Received: by 2002:a05:6e02:1b08:b0:369:c0a3:2ad7 with SMTP id i8-20020a056e021b0800b00369c0a32ad7mr4559094ilv.12.1714162438359;
        Fri, 26 Apr 2024 13:13:58 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id fh35-20020a05663862a300b004875cda091esm169252jab.85.2024.04.26.13.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 13:13:57 -0700 (PDT)
Date: Fri, 26 Apr 2024 14:13:54 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
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
Message-ID: <20240426141354.1f003b5f.alex.williamson@redhat.com>
In-Reply-To: <20240426141117.GY941030@nvidia.com>
References: <20240418143747.28b36750.alex.williamson@redhat.com>
	<BN9PR11MB5276819C9596480DB4C172228C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240419103550.71b6a616.alex.williamson@redhat.com>
	<BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240423120139.GD194812@nvidia.com>
	<BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240424001221.GF941030@nvidia.com>
	<20240424122437.24113510.alex.williamson@redhat.com>
	<20240424183626.GT941030@nvidia.com>
	<20240424141349.376bdbf9.alex.williamson@redhat.com>
	<20240426141117.GY941030@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 Apr 2024 11:11:17 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Apr 24, 2024 at 02:13:49PM -0600, Alex Williamson wrote:
> 
> > This is kind of an absurd example to portray as a ubiquitous problem.
> > Typically the config space layout is a reflection of hardware whether
> > the device supports migration or not.  
> 
> Er, all our HW has FW constructed config space. It changes with FW
> upgrades. We change it during the life of the product. This has to be
> considered..

So as I understand it, the concern is that you have firmware that
supports migration, but it also openly hostile to the fundamental
aspects of exposing a stable device ABI in support of migration.

> > If a driver were to insert a
> > virtual capability, then yes it would want to be consistent about it if
> > it also cares about migration.  If the driver needs to change the
> > location of a virtual capability, problems will arise, but that's also
> > not something that every driver needs to do.  
> 
> Well, mlx5 has to cope with this. It supports so many devices with so
> many config space layouts :( I don't know if we can just hard wire an
> offset to stick in a PASID cap and expect that to work...
> 
> > Also, how exactly does emulating the capability in the VMM solve this
> > problem?  Currently QEMU migration simply applies state to an identical
> > VM on the target.  QEMU doesn't modify the target VM to conform to the
> > data stream.  So in either case, the problem might be more along the
> > lines of how to make a V1 device from a V2 driver, which is more the
> > device type/flavor/persona problem.  
> 
> Yes, it doesn't solve anything, it just puts the responsibility for
> something that is very complicated in userspace where there are more
> options to configure and customize it to the environment.
> 
> > Currently QEMU replies on determinism that a given command line results
> > in an identical machine configuration and identical devices.  State of
> > that target VM is then populated, not defined by, the migration stream.  
> 
> But that won't be true if the kernel is making decisions. The config
> space layout depends now on the kernel driver version too.

But in the cases where we support migration there's a device specific
variant driver that supports that migration.  It's the job of that
variant driver to not only export and import the device state, but also
to provide a consistent ABI to the user, which includes the config
space layout.  I don't understand why we'd say the device programming
ABI itself falls within the purview of the device/variant driver, but
PCI config space is defined by device specific code at a higher level.

> > > I think we need to decide, either only the VMM or only the kernel
> > > should do this.  
> > 
> > What are you actually proposing?  
> 
> Okay, what I'm thinking about is a text file that describes the vPCI
> function configuration space to create. The community will standardize
> this and VMMs will have to implement to get PASID/etc. Maybe the
> community will provide a BSD licensed library to do this job.
> 
> The text file allows the operator to specify exactly the configuration
> space the VFIO function should have. It would not be derived
> automatically from physical. AFAIK qemu does not have this capability
> currently.
> 
> This reflects my observation and discussions around the live migration
> standardization. I belive we are fast reaching a point where this is
> required.
> 
> Consider standards based migration between wildly different
> devices. The devices will not standardize their physical config space,
> but an operator could generate a consistent vPCI config space that
> works with all the devices in their fleet.
> 
> Consider the usual working model of the large operators - they define
> instance types with some regularity. But an instance type is fixed in
> concrete once it is specified, things like the vPCI config space are
> fixed.
> 
> Running Instance A on newer hardware with a changed physical config
> space should continue to present Instance A's vPCI config layout
> regardless. Ie Instance A might not support PASID but Instance B can
> run on newer HW that does. The config space layout depends on the
> requested Instance Type, not the physical layout.
> 
> The auto-configuration of the config layout from physical is a nice
> feature and is excellent for development/small scale, but it shouldn't
> be the only way to work.
> 
> So - if we accept that text file configuration should be something the
> VMM supports then let's reconsider how to solve the PASID problem.
> 
> I'd say the way to solve it should be via a text file specifying a
> full config space layout that includes the PASID cap. From the VMM
> perspective this works fine, and it ports to every VMM directly via
> processing the text file.
> 
> The autoconfiguration use case can be done by making a tool build the
> text file by deriving it from physical, much like today. The single
> instance of that tool could have device specific knowledge to avoid
> quirks. This way the smarts can still be shared by all the VMMs
> without going into the kernel. Special devices with hidden config
> space could get special quirks or special reference text files into
> the tool repo.
> 
> Serious operators doing production SRIOV/etc would negotiate the text
> file with the HW vendors when they define their Instance Type. Ideally
> these reference text files would be contributed to the tool repo
> above. I think there would be some nice idea to define fully open
> source Instance Types that include VFIO devices too.

Regarding "if we accept that text file configuration should be
something the VMM supports", I'm not on board with this yet, so
applying it to PASID discussion seems premature.

We've developed variant drivers specifically to host the device specific
aspects of migration support.  The requirement of a consistent config
space layout is a problem that only exists relative to migration.  This
is an issue that I would have considered the responsibility of the
variant driver, which would likely expect a consistent interface from
the hardware/firmware.  Why does hostile firmware suddenly make it the
VMM's problem to provide a consistent ABI to the config space of the
device rather than the variant driver?

Obviously config maps are something that a VMM could do, but it also
seems to impose a non-trivial burden that every VMM requires an
implementation of a config space map and integration for each device
rather than simply expecting the exposed config space of the device to
be part of the migration ABI.  Also this solution specifically only
addresses config space compatibility without considering the more
generic issue that a variant driver can expose different device
personas.  A versioned persona and config space virtualization in the
variant driver is a much more flexible solution.  Thanks,

Alex


