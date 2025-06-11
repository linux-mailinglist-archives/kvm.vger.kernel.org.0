Return-Path: <kvm+bounces-49086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EA2E3AD5B5B
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 18:01:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA14118957DD
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 16:00:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 891EB1E9915;
	Wed, 11 Jun 2025 16:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I5XLWUhT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978081E520A
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 16:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749657611; cv=none; b=bD/nMJ/MkPis9Fjl9eTFWtpxHEUP8E28T971WlYsnkm7eafmZWNy5mTjgCKCYK8t3fWqNf48UAQzYLaP8MKLgotDTeTFM7u4Giyv/8p03kE6qYhEMNqdz38XtpUxz8UnaPwDL/m6Fo63mD/tPQkMD8PzkIB7IjgpJkhmeuR4IqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749657611; c=relaxed/simple;
	bh=IiDuuTRA2M2+3sZDk9eXLa4R/goATGNp2RX+nSQAtoY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W+v3sRdXqSLtktuB5E2H8DOk6qh+p6DDsn82zLLTwnz1xBelcIJTnVRoVTxHsJczMxpqM+Og2fOSg7nXHfSELGD0kLx+EMzUJSitrut62dOa+nRkWLcORwJ5LXJsM0X4j5HpzlIxeISMjVElXzg/XFl4EEestSJYpRl16Tec92s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I5XLWUhT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749657608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LWl4ZRI+eTYAyrnyoF354Y0MWsELzMtlOfF1z/VHP4s=;
	b=I5XLWUhT3cXb8bjnNu4oWy/HyJZPqrAgV6M7Z8G50nGUohxALce9whOIRJKGzg7J2In3yU
	RT4jsMKH2bYcvMWQhHPKVQNBKyRXh9sXidfxqSu5rfQXHAtkqSKAekXaGLFDUt/UWN+3gu
	wlne3WhbS+isq7dM2ZlhyqGeWB1UCNE=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-zehkCPqPM96yfDXSixjM-Q-1; Wed, 11 Jun 2025 12:00:07 -0400
X-MC-Unique: zehkCPqPM96yfDXSixjM-Q-1
X-Mimecast-MFC-AGG-ID: zehkCPqPM96yfDXSixjM-Q_1749657606
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3ddc47aebc2so86365ab.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 09:00:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749657606; x=1750262406;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LWl4ZRI+eTYAyrnyoF354Y0MWsELzMtlOfF1z/VHP4s=;
        b=j0j1LULFipUwRaRBfHceXnxxsZhTvC4p1i+74Jk2QHbXUUnsWC3sAJCAnpU59CqXgn
         yQB3JgoMGcgRKfwUhDOuEE/tKkWHqh1Vdk6R3oqOkOEXj5bPe91OzIzw+8cjnA5607+w
         r5YRFONYB/Cor+SOTpj/XIlWP0NLajyBpJ0lB/Oy/yhyCAa/avLfVnPT0XDTbFGAhfhE
         3s3hGqKhIm9CGb8JMHoaaXpEQMGaAOC1l47WKARrGdM/et7hr/jmXNiJLy+s6XfbA8ER
         4vmqlp3lUTfIGeG9u80Q0xwcYywIbgd8+FDeA8YNDiFIm3Hn1gC3e+7BtKSp4Uflew2Q
         lyRA==
X-Forwarded-Encrypted: i=1; AJvYcCWsipQs4JA/bTB99Ok1ytke48VDnHGlGFY9YnLYJqhb1fkOxsgD9pmXZRl/Hjg1YswHaFI=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywz4vjVcGyWEIzpJyQp1X9YUhIvw8/A3SFKDsL0JzqjDSvi4FMG
	OxENhONVPXyV0tIcXDczREUxs+gFHKTgIEfupygOwBilGSUNA2r8T0WCKp/JN79xRiG6CJkW2xI
	TvSAV0JnrAhV6//5DSl+ZOe+lIxwL62MIDJYVkghVq5GBh0tuj9PH/w==
X-Gm-Gg: ASbGncsPtT5GgWGB17ROkb8dDrRD9OH6wH2nUBSFfTbe13ArB9SFpsKs25Pg3OEsLXt
	gMy2SnKMudmy+bMsztBN56rAGZ6Tm2hXYyehnXm7B2n7k3NpyDxiGw6pmOjYWM7AJO80W3e49b5
	k4zKLREOjFQKZVkdYGp2aYrplVAnzhECcQlEP2/07VeKG7JA4DRg7aFLAClXBjUA92GSwfoe1Xg
	jnckVBTPbdMEiy9ZP/HK2A8NlqCsWdvSsDrFoix8AORu2u6GVxFT49iK/Ira7wq24iMSCbsih/A
	6xTKuVaxTKUpxsjv2SaRhwjEVQ==
X-Received: by 2002:a05:6602:1606:b0:875:a894:8343 with SMTP id ca18e2360f4ac-875bc3cce9amr143173839f.1.1749657606428;
        Wed, 11 Jun 2025 09:00:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0gvvgK8mJjl2VAWjvOdFvpWcy2sB+ud7IQ/bdWVB5kYZmkmHpNEBhk66PrewRuy5I5Lbl+Q==
X-Received: by 2002:a05:6602:1606:b0:875:a894:8343 with SMTP id ca18e2360f4ac-875bc3cce9amr143171539f.1.1749657606047;
        Wed, 11 Jun 2025 09:00:06 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5012aaa23c6sm438160173.80.2025.06.11.09.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jun 2025 09:00:04 -0700 (PDT)
Date: Wed, 11 Jun 2025 10:00:02 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Mario Limonciello <superm1@kernel.org>
Cc: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>, bhelgaas@google.com,
 mario.limonciello@amd.com, rafael.j.wysocki@intel.com,
 huang.ying.caritas@gmail.com, stern@rowland.harvard.edu,
 linux-pci@vger.kernel.org, mike.ximing.chen@intel.com,
 ahsan.atta@intel.com, suman.kumar.chakraborty@intel.com,
 kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] PCI: Explicitly put devices into D0 when
 initializing - Bug report
Message-ID: <20250611100002.1e14381a.alex.williamson@redhat.com>
In-Reply-To: <56d0e247-8095-4793-a5a9-0b5cf2565b88@kernel.org>
References: <aEl8J3kv6HAcAkUp@gcabiddu-mobl.ger.corp.intel.com>
	<56d0e247-8095-4793-a5a9-0b5cf2565b88@kernel.org>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 11 Jun 2025 06:50:59 -0700
Mario Limonciello <superm1@kernel.org> wrote:

> On 6/11/2025 5:52 AM, Cabiddu, Giovanni wrote:
> > Hi Mario, Bjorn and Alex,
> > 
> > On Wed, Apr 23, 2025 at 11:31:32PM -0500, Mario Limonciello wrote:  
> >> From: Mario Limonciello <mario.limonciello@amd.com>
> >>
> >> AMD BIOS team has root caused an issue that NVME storage failed to come
> >> back from suspend to a lack of a call to _REG when NVME device was probed.
> >>
> >> commit 112a7f9c8edbf ("PCI/ACPI: Call _REG when transitioning D-states")
> >> added support for calling _REG when transitioning D-states, but this only
> >> works if the device actually "transitions" D-states.
> >>
> >> commit 967577b062417 ("PCI/PM: Keep runtime PM enabled for unbound PCI
> >> devices") added support for runtime PM on PCI devices, but never actually
> >> 'explicitly' sets the device to D0.
> >>
> >> To make sure that devices are in D0 and that platform methods such as
> >> _REG are called, explicitly set all devices into D0 during initialization.
> >>
> >> Fixes: 967577b062417 ("PCI/PM: Keep runtime PM enabled for unbound PCI devices")
> >> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> >> ---  
> > Through a bisect, we identified that this patch, in v6.16-rc1,
> > introduces a regression on vfio-pci across all Intel QuickAssist (QAT)
> > devices. Specifically, the ioctl VFIO_GROUP_GET_DEVICE_FD call fails
> > with -EACCES.
> > 
> > Upon further investigation, the -EACCES appears to originate from the
> > rpm_resume() function, which is called by pm_runtime_resume_and_get()
> > within vfio_pci_core_enable(). Here is the exact call trace:
> > 
> >      drivers/base/power/runtime.c: rpm_resume()
> >      drivers/base/power/runtime.c: __pm_runtime_resume()
> >      include/linux/pm_runtime.h: pm_runtime_resume_and_get()
> >      drivers/vfio/pci/vfio_pci_core.c: vfio_pci_core_enable()
> >      drivers/vfio/pci/vfio_pci.c: vfio_pci_open_device()
> >      drivers/vfio/vfio_main.c: device->ops->open_device()
> >      drivers/vfio/vfio_main.c: vfio_df_device_first_open()
> >      drivers/vfio/vfio_main.c: vfio_df_open()
> >      drivers/vfio/group.c: vfio_df_group_open()
> >      drivers/vfio/group.c: vfio_device_open_file()
> >      drivers/vfio/group.c: vfio_group_ioctl_get_device_fd()
> >      drivers/vfio/group.c: vfio_group_fops_unl_ioctl(..., VFIO_GROUP_GET_DEVICE_FD, ...)
> > 
> > Is this a known issue that affects other devices? Is there any ongoing
> > discussion or fix in progress?
> > 
> > Thanks,
> >   
> 
> This is the first I've heard about an issue with that patch.
> 
> Does setting the VFIO parameter disable_idle_d3 help?
> 
> If so; this feels like an imbalance of runtime PM calls in the VFIO 
> stack that this patch exposed.
> 
> Alex, any ideas?

Does the device in question have a PM capability?  I note that
4d4c10f763d7 makes the sequence:

       pm_runtime_forbid(&dev->dev);
       pm_runtime_set_active(&dev->dev);
       pm_runtime_enable(&dev->dev);

Dependent on the presence of a PM capability.  The PM capability is
optional on SR-IOV VFs.  This feels like a bug in the original patch,
we should be able to use pm_runtime ops on a device without
specifically checking if the device supports PCI PM.

vfio-pci also has a somewhat unique sequence versus other drivers, we
don't call pci_enable_device() until the user opens the device, but we
want to put the device into low power before that occurs.  Historically
PCI-core left device in an unknown power state between driver uses, so
we've needed to manually move the device to D0 before calling
pm_runtime_allow() and pm_runtime_put() (see
vfio_pci_core_register_device()).  Possibly this is redundant now but
we're using pci_set_power_state() which shouldn't interact with
pm_runtime, so my initial guess is that we might be unbalanced because
this is a VF w/o a PM capability and we've missed the expected
pm_runtime initialization sequence.  Thanks,

Alex


