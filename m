Return-Path: <kvm+bounces-51320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61EC9AF6061
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 19:50:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D75CF4A3AED
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 17:50:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 681B2309A75;
	Wed,  2 Jul 2025 17:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LJ5BKiJ4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40CE2749E5
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 17:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751478640; cv=none; b=Apbe2y4GTP+x0vsBqU4VveYCnT8y1ngcCFmQHIV9+Es6xCDDjcY+TjFRdkOAu1E59RU9XFCBIGbpaNeXVFyFnSSmSTO3gV9tt6U18hPZwFSbYp2ukLNAcCIwPX06z0kmS8K04P4as68JyOVioI/1XAhucPox6cXTtkbTzH001II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751478640; c=relaxed/simple;
	bh=Jh8qm2w89/VK64dwhZIkzsXPT+h5ZZQ4iQGMCY2KtuY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uY2sYJtEokzsyus/g41k6jZNswfUzvc098kwyqnVUS5gLyzQ/YWitdjJKDMxh3Sh/KLByuoagQnbshs3QSABS7jpRGPzBRfvm2YBiMFerpqAp9hFncFx7vc4XAHPT4Kb7Gd60sxTlQnWC1ePz7yGRzKQ4F7z6QNs5LVpjaiHWSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LJ5BKiJ4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751478637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EIuMvtBl5uukRflspz/nx9+YOr63VpPwlXWWN03S4Ns=;
	b=LJ5BKiJ4hffjZSS22N9sKdz5/WwvQ1FAYnaImznPUduyR788fgwNWZBNaepvu11LyM4+9F
	GdyzMQH7JO/IMD+hPcncH+MhGVeClM2XAHYunWEVXubl5oQcPQme0Y3M9EHl/x1Ua4IMPZ
	Q1OIo0xZVQq8PDvdyj1YdqTmKszNg8o=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-157-DTiwZhuUOQy56PhZdwbjcA-1; Wed, 02 Jul 2025 13:50:36 -0400
X-MC-Unique: DTiwZhuUOQy56PhZdwbjcA-1
X-Mimecast-MFC-AGG-ID: DTiwZhuUOQy56PhZdwbjcA_1751478636
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-86cfa0cb1eeso69335439f.1
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 10:50:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751478636; x=1752083436;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EIuMvtBl5uukRflspz/nx9+YOr63VpPwlXWWN03S4Ns=;
        b=Evft/9d/uvW6lbDuZsTng6NcshY3i3EgHDgTW7q9Fn6GG2aIfLSyDJpI87f0b19Vwh
         VA6wJQyEJSHv5fc3ovqjCAaEYjpwTdAt79BxIHL4nbjw23jcl6YITt87KcVRzGxauKhe
         YJnsGhGIOSx9JLLRXhjPNgtN7vnD97iQgjKZkUbhXN9Jgkk/Q+vmJfDVXGJffsTtGstj
         QYMg6TqVfvXbQ3byqkCoOt1kslIk3SfxDW0FAmR3MZobA1X0rUQ7pnnOrpKu2Hn44oxM
         5rAR7KyC/3JcHerbQMUYh133kVEd02MJgZzqPDMGFrraWLeqnk79Z5R31onXKiSh34hu
         zh4g==
X-Gm-Message-State: AOJu0YydkJdDjNxJE+D0dqjgmSCqeXw+8Na+mpo7Bc2CR0PSM9t8t39d
	Ub7aygUxlYZH2ifW/mb2yAhxYq0/7tv7wfAQSd1QuF9ac9r0jqKNLP/5OB95zDM3yOs2Ma4T7b+
	OnFqrVl245WazNvCVUjCQCpk/8Uyx6ngnDPxWdn4VLxEQoQi8noqcSg==
X-Gm-Gg: ASbGncuKNBhhhqciBjSt/ShOaNrpspjTiMry9hhr3OvXJaYm7MvYrWn0b8KLr5Lk5nt
	XZLohDFnv885basDE6AnL8RYcjMKMRcGdyZMaVuEn5mTu5JKb9bYT2loku0K+SiaZvhhOZdfgTH
	2sggxPeJDxrwmIxv7GvlKVmfuR0XxEstsaXWdrVSWgM80SGqqh0cd4VauTS4rL+svYRWXEXQ68S
	nfUci0/+RjMVJmbkDsjk01bEU5kAueabGNSVYjpvlnFvMYtD4WKUCLGUjrnkUDAZuZwJGoPJ1us
	RtSAuVgGdPH89LdvIYpNPq9zqg==
X-Received: by 2002:a05:6e02:1f0b:b0:3e0:504b:da6a with SMTP id e9e14a558f8ab-3e05496a156mr12700165ab.7.1751478635855;
        Wed, 02 Jul 2025 10:50:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHB+TIfLevz/mjFXitgtf3I6EYbKo3luIp6yp2bJiOXevSJVFaMpAtkxJ7a7TSfDJKwcmmFxw==
X-Received: by 2002:a05:6e02:1f0b:b0:3e0:504b:da6a with SMTP id e9e14a558f8ab-3e05496a156mr12699995ab.7.1751478635354;
        Wed, 02 Jul 2025 10:50:35 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3df4a0b062asm36657225ab.58.2025.07.02.10.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 10:50:34 -0700 (PDT)
Date: Wed, 2 Jul 2025 11:50:32 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, aaronlewis@google.com, bhelgaas@google.com,
 dmatlack@google.com, vipinsh@google.com, seanjc@google.com,
 jrhilke@google.com, kevin.tian@intel.com
Subject: Re: [PATCH] vfio/pci: Separate SR-IOV VF dev_set
Message-ID: <20250702115032.243d194a.alex.williamson@redhat.com>
In-Reply-To: <20250702160031.GB1139770@nvidia.com>
References: <20250626225623.1180952-1-alex.williamson@redhat.com>
	<20250702160031.GB1139770@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 2 Jul 2025 13:00:31 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Jun 26, 2025 at 04:56:18PM -0600, Alex Williamson wrote:
> > @@ -2149,7 +2149,7 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
> >  		return -EBUSY;
> >  	}
> >  
> > -	if (pci_is_root_bus(pdev->bus)) {
> > +	if (pci_is_root_bus(pdev->bus) || pdev->is_virtfn) {
> >  		ret = vfio_assign_device_set(&vdev->vdev, vdev);
> >  	} else if (!pci_probe_reset_slot(pdev->slot)) {
> >  		ret = vfio_assign_device_set(&vdev->vdev, pdev->slot);  
> 
> What about the logic in vfio_pci_dev_set_resettable()?

IIRC, VFs are going to fail the pci_probe_reset_slot() and
pci_probe_reset_bus() tests because they don't have a pdev->slot or
pdev->bus->self respectively.

> I guess in most cases vfio_pci_dev_set_resettable() == NULL already
> for VFs since it would be rare that the PFs and VFs are all under
> VFIO.

Regardless, the VF will return NULL.

> But it could happen and this would permanently block hot reset? Maybe
> just mention it in the commit?

There is no bridge from which to initiate an SBR for a VF, there would
only be the bridge above the PF.  We require SR-IOV is disabled when
the PF is opened, so the dev_set of the PF would never have included the
VFs.  I haven't tried it, but it may be possible to trigger a hot reset
on a user owned PF while there are open VFs.  If that is possible, I
wonder if it isn't just a userspace problem though, it doesn't seem
there's anything fundamentally wrong with it from a vfio perspective.
The vf-token already indicates at the kernel level that there is
collaboration between PF and VF userspace drivers.

> I guess the commit message is also trying to say that we don't use
> VFIO_DEVICE_PCI_HOT_RESET if VFs are present on either the VF or
> PF - and this change will block that.

The hot reset ioctl has never been available to VFs, there's no bridge
from which to initiate an SBR without traversing above the PF.
 
> All VF resets should go through VFIO_DEVICE_RESETF. If you want to
> slot/bus reset the PF then you have to disable SRIOV first.

I'm not positive on the latter, but AFAIK it's always been the case
that only FLR is available on VFs and this doesn't change that.  Am I
still overlooking something that concerns you?  Thanks,

Alex


