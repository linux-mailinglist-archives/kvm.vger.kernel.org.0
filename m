Return-Path: <kvm+bounces-53842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FEA4B18429
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 16:48:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39CF73B726E
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 14:48:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 184912701C5;
	Fri,  1 Aug 2025 14:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="eKuf4Yc4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1AC26FA7B
	for <kvm@vger.kernel.org>; Fri,  1 Aug 2025 14:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754059685; cv=none; b=lIBCJXBeOCbpL+pdSAc/wGsppOeEvZSOWP6Mvx1AQELdKJJ5PlvBEdzPgUn/4KLaRizJgrcW10vVlDNjVY+V7WNy6gn7nleyzPwYT17Fow7q7XrdQPsRzBhZdhcA+HNe3N7eCwrWQ5qH8uudCpjhZTy0ZtDjHhzgR2k5VZoxpAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754059685; c=relaxed/simple;
	bh=YZHza/EnmxkcBOGDn7hmlJIwbMxL3JM9EGMYOvHGSg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e/SeEVSDDR3JTJgCwjtPd0s01cLjQpfcDErjDy4igNlu35+WBr00PjxFWqbNNn5S7gB/VM/ZPmBxEYsdCyD1HFwWhari2+staHNlbqECZjYf9tnxrrxWn2+uUj0krki/VmrSGQThcTGO/ldiF2vm8QH7GRw2uY8Ha+so/tIzrzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=eKuf4Yc4; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ab63f8fb91so7233571cf.0
        for <kvm@vger.kernel.org>; Fri, 01 Aug 2025 07:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1754059682; x=1754664482; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8XiRDfRvpK/TGGlwkWMQ0+U85MYh7SiuBVb/dOXV04M=;
        b=eKuf4Yc4TorJbgGykdYoBvaeZqaAyOsgl+nrOfD1b7DHbvX8corhOVkj4BE8EJ38jF
         Lisl22KdnYGuS4GQq9Z/PVvjFXnyDz5YnhHRTF43Ccu+97c0OvxzTP5wmdsJifBc6MSj
         Cwfe79ArwyaO/V4RNiDQ+9HmVdgdV5CbIYH3ASPhbJNOnuYlL76vEdLfFc5x8k8PrGyr
         RHf2z8fzeHoJj5/e4pabvVrr2V3IM0HNHdZHXJmtnFppXUfq4jNULMGhlLA7C2kyUHOB
         KjVMb5CVwr//aq1RiehWeQsoMKK3clFIFJo1OHt8wAmlpSoPi7JZLRexgpkVz5kdUbot
         RX1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754059682; x=1754664482;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8XiRDfRvpK/TGGlwkWMQ0+U85MYh7SiuBVb/dOXV04M=;
        b=wyK/0EBZcaMu0E4aeWiyGsD0IZ7/lx+at4Fsg2wTWzXrJt+PXjf/d2IPEAYF5AeZln
         eQUTOT5JYsC0i6F9zkggi5GgPIe6/3suc+fuQ+WWmF1JG1QFDcUf/H6CuoANZe3l0ss4
         zgFbZD9YE7iT9jOHQjYu++VOtdM7ubdGtwJK0IHfdtKX7TshmKwk3ZQDwL9v3sQtfo1a
         h4ylkYnTdlwGrnaTvlbAPnol6nT3sqVYWcuq0r6pHVdD0DeUzex80Joce/2AzEaFXld2
         sLqOhMALLTFNugnBygqZ3n9HSq3OotnkPWT2IrlmFy36KSFLDuGTr6wjgp222T4cMnCm
         hcJg==
X-Forwarded-Encrypted: i=1; AJvYcCUohkX6cTkzi5xSGMDbIt4W3rM9I5g4ZOkLqJTfh1G+rlp9Qyl4Vm/d6kBT/0qBEaH9oGU=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywp6ARU5N6L1ASaKKTbgtBu5XuWaii76BfKMmh7EOyapgjf7NRf
	DmBQvg7LjZ5AYoeO9Bkjob7hhMZkD0Huod842nb/mQBPaV19/ixCthSoIlTHpLd86R8=
X-Gm-Gg: ASbGncsyWaBMMkaKNLMUwj29HiN2bINEiduXz3Ue/FsLUvfgvvHcRS58mnI6oYNfKFr
	sKNA4Wsza87BfkJJOWF2amk95fJWcAvvjhucnnDYxeLGhzwKbh5m4nT9nHn+5VDRzkZIce6ti2U
	P/gyc3l8y4gr4H33uctYC0vKGL3/Y3yKuq+UdcWB8lfPLBYN31+JygDSo7MdNJSztRJyYyxtkut
	SbOQZQMZExTwFZLH8rk4cnH3Gp2WGMZ3+wBOxh5rzjrHlEIHvSsGNKSGBnrGQe27Q08Kq63ImUc
	f642HXU5Cd+sxbMttI69H1gkzEVgqOj0ppVHL/S8W3F3xaYkjJK70axSOYNr9rFRXsEpuOGlcon
	/gXb3fAtXs2Kbp9AQmHTWpPBh3vE4dos7ByAYbt99d4wL5sZHaTWVZYz81buSuMvNtwKoMezFjS
	VqUdg=
X-Google-Smtp-Source: AGHT+IHuruq8e4nOotgiFQqAg6PBap8xAM5qGI7N6LDcn+/UHmrffFvYqn7c/dW/3W+MAg6BCfHAoQ==
X-Received: by 2002:ac8:5d4f:0:b0:4a8:1841:42ff with SMTP id d75a77b69052e-4af1099c444mr665711cf.8.1754059681970;
        Fri, 01 Aug 2025 07:48:01 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4aeeee21d29sm20498461cf.64.2025.08.01.07.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 07:48:01 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uhr3A-000000012U6-3dEE;
	Fri, 01 Aug 2025 11:48:00 -0300
Date: Fri, 1 Aug 2025 11:48:00 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Mastro <amastro@fb.com>
Cc: alex.williamson@redhat.com, kvm@vger.kernel.org, peterx@redhat.com,
	kbusch@kernel.org
Subject: Re: [PATCH v2] vfio/pci: print vfio-device syspath to fdinfo
Message-ID: <20250801144800.GA26511@ziepe.ca>
References: <20250724-show-fdinfo-v2-1-2952115edc10@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724-show-fdinfo-v2-1-2952115edc10@fb.com>

On Thu, Jul 24, 2025 at 04:29:53PM -0700, Alex Mastro wrote:
> Print the PCI device syspath to a vfio device's fdinfo. This enables tools
> to query which device is associated with a given vfio device fd.
> 
> This results in output like below:
> 
> $ cat /proc/"$SOME_PID"/fdinfo/"$VFIO_FD" | grep vfio
> vfio-device-syspath: /sys/devices/pci0000:e0/0000:e0:01.1/0000:e1:00.0/0000:e2:05.0/0000:e8:00.0
> 
> Signed-off-by: Alex Mastro <amastro@fb.com>
> ---
> Based on the feedback received from Jason G. and Alex W. in v1, print
> the PCI device syspath to fdinfo instead of the BDF. This provides a
> more specific waypoint for user space to query for any other relevant
> information about the device.
> 
> There was discussion about removing vfio_device_ops callbacks, and
> relying on just dev_name() in vfio_main.c, but since the concept of PCI
> syspath is implementation-specific, I think we need to keep some form
> of callback.

??

> +static void vfio_pci_core_show_fdinfo(struct vfio_device *core_vdev, struct seq_file *m)
> +{
> +	char *path;
> +	struct vfio_pci_core_device *vdev =
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +
> +	path = kobject_get_path(&vdev->pdev->dev.kobj, GFP_KERNEL);
                                 ^^^^^^^^^^^^^

vdev->pdev == core_vdev->dev 

int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
{
	vdev->pdev = to_pci_dev(core_vdev->dev);

It is the right thing to just make this generic and use
core_dev->dev.kobj

Every vfio parent device has a sysfs path.

Jason

