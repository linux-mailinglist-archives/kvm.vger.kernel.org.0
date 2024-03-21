Return-Path: <kvm+bounces-12376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ADE75885906
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 13:23:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 09DA7B21949
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 12:23:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93DF1762C0;
	Thu, 21 Mar 2024 12:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PKVtGhTu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1749428379;
	Thu, 21 Mar 2024 12:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711023790; cv=none; b=dN7MyVKnVIX2mj0L6iuoF7lrOTAhtbu9Fq4qxuOLka2d/jtEVKDcJjYkN0w9OB1MDNp206kfI9eG+LAyE+nveq2qGMZaLbN3pL1VhSvPYLTBuQhqcRgn/Ur/NPl6vuezmboZmz7TI/u4z8ybhK4/PPejmseC0cilI3HfDWGWR3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711023790; c=relaxed/simple;
	bh=zPQPtG8FlPDzdRl/IlTPYX+93JqW3jbsX1nFS16TQpY=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YpOm4mMaNhk5M1R2reSmgbgeFLgjvQv+01s6Ec6NIFNktM8POSLQXLEHkNJ0XsJWPCzFZLolIMHzAxShL7jsfJWU0Iv+UF9P5iocYK9zOr011gCtWSCvk0SVd9MywuVLUDsHhrA/UiX0sqpWuinUapmZxl8wrxwFAke5WLqC3cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PKVtGhTu; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a46f97b8a1bso117075866b.0;
        Thu, 21 Mar 2024 05:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711023787; x=1711628587; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VPsUYtU0/oIu1g6pXqWAWl6e/kRaRRBG+QVumvEzpho=;
        b=PKVtGhTu7kJJS1v90wkTRH0VMeTi1VWGMMyno2B5iNh/m7Aoy8en/1s9uuBHFjZvDD
         ckFCnoJozydgPRDVPSkaBYr+LcUfcRKk3SlaXwmjLWtPY5n3gWv0pT/5gyGZuGqVUUKH
         /5YsZ4q/qF1e6oB0tJd7+mNynIOkRVhvIrLG7pKF+wZ/awR9Og3Yl3e4PbEzhLyuYRtl
         quEXEb8/BCaP8TcgEfgnfojaJcv/R4g0+CYawfP8Ja6QEnk1ymaa9V39Y+GOuJBjro/8
         S+4xthJvr7DwtJ4bGTA91tX8AcBgBnGvDsHecDm0KQJP+xxmve/oSKZwV+mppTYwXJfX
         PzkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711023787; x=1711628587;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VPsUYtU0/oIu1g6pXqWAWl6e/kRaRRBG+QVumvEzpho=;
        b=jHfWAQMoalrfD71HCCLGAcRd2wtBr5y3g8q4HQisLYpIPRVmLG5sqK+ozFf7dZxD0y
         aqCn+SX5Jjol0FSgQ1TGbF5gKH7+hJY3IJ8vD6xtjPyNv1RkhPaSgpfHLS2syxEF9gTV
         XBZd85Tou+HXi9T4XfGaFFRoDboZw6k500hLPDHy9jEAn43vmklgXG2H8KHlXAyH3tfn
         IbD23WcPXC8tuOd+rDWB+TYfcP2CMJTt2ZVKFZ67ZLLV8u7By7tNZ3VD9x1NNUPMdKRg
         q4tm7Vcll6D9lYhpmfMm8ONS4+Djj+znytVkkrcQYU7w3TJFaZKL1ZLXQhMZmNCMrPqf
         Rg3g==
X-Forwarded-Encrypted: i=1; AJvYcCX1a0dwZuQSPH/dioimdXKeVVt2FnkMkbH2h9EXRZ9xdtFhWeT4F3z8gs6d3WgN8EqV03KZD9S75trRD5LUxGP3xhWbazRKZMfmNuBWVzAmn12iQdRYDUWtcWCGYnQznrWp
X-Gm-Message-State: AOJu0YwCGHRiXobez0myGL8JBMdrHEu1FtyLJRzXYO++Dslb4UWeRYua
	mcUQRUsonrhW8JbvRaksdbFkKRua5eHo7zSh7Wo1tzMPs7DTn1iG
X-Google-Smtp-Source: AGHT+IEzDCrv2Y2A3UeDXzKt7t5e/ypEKGDj3d7eSdRbJ6MGDn65UZ9b0bq9orAPSjMTHBB+6+O4kQ==
X-Received: by 2002:a17:906:280f:b0:a46:d6f7:e82c with SMTP id r15-20020a170906280f00b00a46d6f7e82cmr5898972ejc.22.1711023787063;
        Thu, 21 Mar 2024 05:23:07 -0700 (PDT)
Received: from bxlr ([62.96.37.222])
        by smtp.gmail.com with ESMTPSA id lg21-20020a170906f89500b00a46cc25b550sm4129120ejb.5.2024.03.21.05.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 05:23:06 -0700 (PDT)
From: Mikhail Malyshev <mike.malyshev@gmail.com>
X-Google-Original-From: Mikhail Malyshev <mikem>
Date: Thu, 21 Mar 2024 13:23:04 +0100
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Mikhail Malyshev <mike.malyshev@gmail.com>, jgg@ziepe.ca, 
	yi.l.liu@intel.com, kevin.tian@intel.com, tglx@linutronix.de, 
	reinette.chatre@intel.com, stefanha@redhat.com, abhsahu@nvidia.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] Reenable runtime PM for dynamically unbound devices
Message-ID: <23maxefvqgcelvlpckq6jmnzqeo5e3j7ku2pquykwvupgzyl6k@f6tt4wtzsxnj>
References: <20240319120410.1477713-1-mike.malyshev@gmail.com>
 <20240319085011.2da113ae.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319085011.2da113ae.alex.williamson@redhat.com>

On Tue, Mar 19, 2024 at 08:50:11AM -0600, Alex Williamson wrote:
> On Tue, 19 Mar 2024 12:04:09 +0000
> Mikhail Malyshev <mike.malyshev@gmail.com> wrote:
> 
> > When trying to run a VM with PCI passthrough of intel-eth-pci ETH device
> > QEMU fails with "Permission denied" error. This happens only if
> > intel-eth-pci driver is dynamically unbound from the device using
> > "echo -n $DEV > /sys/bus/pci/drivers/stmmac/unbind" command. If
> > "vfio-pci.ids=..." is used to bind the device to vfio-pci driver and the
> > device is never probed by intel-eth-pci driver the problem does not occur.
> > 
> > When intel-eth-pci driver is dynamically unbound from the device
> > .remove()
> >   intel_eth_pci_remove()
> >     stmmac_dvr_remove()
> >       pm_runtime_disable();
> 
> Why isn't the issue in intel-eth-pci?
> 
> For example stmmac_dvr_remove() does indeed call pm_runtime_disable()
> unconditionally, but stmmac_dvr_probe() only conditionally calls
> pm_runtime_enable() with logic like proposed here for vfio-pci.  Isn't
> it this conditional enabling which causes an unbalanced disable depth
> that's the core of the problem?
> 
The common code in the stmmac driver is used for both PCI and non-PCI
drivers and this code doen't handle this correctly. That condition is
actually wrong

> It doesn't seem like it should be the responsibility of the next driver
> to correct the state from the previous driver.  You've indicated that
> the device works with vfio-pci if there's no previous driver, so
> clearly intel-eth-pci isn't leaving the device in the same runtime pm
> state that it found it.  Thanks,
yes, I agree. I was confused by a number of driver calling
pm_runtime_disabe in their remove() function but those are not PCI
drivers. Unfortunataly runtime PM documentation is not very clear on
this topic. I'll submit another patch for the driver. Are there any
subsystems other than PCI that call pm_runtime_enable/disable? Right now
my patch for the driver do not call them only for PCI case.

BR,
Mikhail
> 
> Alex
> 
> > Later when QEMU tries to get the device file descriptor by calling
> > VFIO_GROUP_GET_DEVICE_FD ioctl pm_runtime_resume_and_get returns -EACCES.
> > It happens because dev->power.disable_depth == 1 .
> > 
> > vfio_group_fops_unl_ioctl(VFIO_GROUP_GET_DEVICE_FD)
> >   vfio_group_ioctl_get_device_fd()
> >     vfio_device_open()
> >       ret = device->ops->open_device()
> >         vfio_pci_open_device()
> >           vfio_pci_core_enable()
> >               ret = pm_runtime_resume_and_get();
> > 
> > This behavior was introduced by
> > commit 7ab5e10eda02 ("vfio/pci: Move the unused device into low power state with runtime PM")
> > 
> > This may be the case for any driver calling pm_runtime_disable() in its
> > .remove() callback.
> > 
> > The case when a runtime PM may be disable for a device is not handled so we
> > call pm_runtime_enable() in vfio_pci_core_register_device to re-enable it.
> > 
> > Mikhail Malyshev (1):
> >   vfio/pci: Reenable runtime PM for dynamically unbound devices
> > 
> >  drivers/vfio/pci/vfio_pci_core.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > --
> > 2.34.1
> > 
> 

