Return-Path: <kvm+bounces-20309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DD4BC912E65
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 22:17:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3AC95B21B14
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 20:17:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F92816D4F9;
	Fri, 21 Jun 2024 20:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ceFSfLeH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02BE82D68
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 20:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719001053; cv=none; b=D3h2sPWVZWvl5iVTZAzOofhjkkUhd/ija+UUUoHz//H5ZDQXlzUZDtBzRXOGHF2CiQn4lQtU/1RDkQk6T/XxtWuKS1bn+WSG/eSnY66Aqb61b4TVrQY49m0c0FGvy8N+a/ijBpNaIlrnTFDJBxtfTrefFNADW+y2hBRAFzmAYdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719001053; c=relaxed/simple;
	bh=1e30kVLyzFq1PU3An6ylOGV4PAe55sJot7fsu6AUC0k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DKC8rKVknm4lDyZvBV6/EAJMrOOa6KpmewlE9XbNp37Dstf+Ujm9/f75fEV8kcBhpRINFY+/npYMlPXb4WX7z6PnK3M/KLvaR1fWMSEpSBkYC0iyLFiInxeMeSYv27HG5Hrm8PAbU802pbAR5ucBcmnhBonQlafWfN3W+DErYQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ceFSfLeH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719001050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Um7T9PGjBIGkvoDVAKpflWXByq5XUAzYLuKCcXhMqaY=;
	b=ceFSfLeHudXmgfBtajLhGtSWzTnTz6yPGP/YyJ1H7DVmNa1yn2PZYcntg8H5Y2Vz4Dv5mW
	erQyQ1VNQHbv9cKUOsXUvWLIlOENdn7ScKTeqkg8npRDBfBXAd7w74IqY2tWoLAcijc2jp
	w184BfWMKFurQcdDqZQjpcDF605mZM8=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551--f9xJf2uP9ePNBUhwQICwQ-1; Fri, 21 Jun 2024 16:17:29 -0400
X-MC-Unique: -f9xJf2uP9ePNBUhwQICwQ-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3737b6fc28fso28748095ab.0
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 13:17:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719001048; x=1719605848;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Um7T9PGjBIGkvoDVAKpflWXByq5XUAzYLuKCcXhMqaY=;
        b=vYIhvqVMJFBxqktuWIDUKHmziQu6i9bZ3bfdSQkgWH5p8nmD/hjHIWcF5a9E1e4SG9
         PbJ8h0GoDKATEoqolH4aNjbJZh2PFa3QHv1Dp4+OYs4f+xzGfAymmpnzVptMOugA+pCO
         64F3o+NTfNzuR8iHsoCbhGvpvrfh1rhB4Yl8YBWEY7hpJZ45Tn7ur3WdWTrkKraV2xHZ
         gn+DM5YwcZ2eH92u7hOeyRGitFLYzk4o2eQqdkO0HLOG0WcRqWUmMNtIKXkcE3puZ3pD
         OivZ2WXqcJLkzKHG/Za3StS1nbxrdoT/1Fs14f4ARE9NOIH2AQLqJ1G6mXGleP29GR3O
         4UCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMDxU2sK3LvvBC1/Q5dGosIZBeV7SsxMAh3lTd0Vto3JLHczAIT7c04qlgWbbT4zbFTjhbpIaY3fpEvf4DAcgQpwTV
X-Gm-Message-State: AOJu0YxNhif3eom/Cxt2tVEJ0VwPsQYO10jVRfN2Y5GnzTQIgST/W7ok
	aPwZgXjTwvSCcJZ94jce8TkivzHJud+ceCYCyM+bLPDzcUreEUR1nLOJzEGn75ry5ZqKHzR9W1f
	eFJBCy8Y/N216AXjAUZ2x+/HbQgUOrSnya1SX07pjcgLAjkV2ZA==
X-Received: by 2002:a05:6e02:54d:b0:375:dc04:378d with SMTP id e9e14a558f8ab-3763641c664mr4276295ab.6.1719001048539;
        Fri, 21 Jun 2024 13:17:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGm8aM6CP7HpAsbVpMIZYwjxc8YU/y9+kdeZyEPluz+E05lG59Fcq21BUDsEiQMbh6Wj2GUsQ==
X-Received: by 2002:a05:6e02:54d:b0:375:dc04:378d with SMTP id e9e14a558f8ab-3763641c664mr4276115ab.6.1719001048153;
        Fri, 21 Jun 2024 13:17:28 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3762f3a6a76sm4855055ab.86.2024.06.21.13.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jun 2024 13:17:27 -0700 (PDT)
Date: Fri, 21 Jun 2024 14:17:24 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Gerd Bayer <gbayer@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Niklas Schnelle
 <schnelle@linux.ibm.com>, Ramesh Thomas <ramesh.thomas@intel.com>,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org, Ankit Agrawal
 <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, Halil Pasic
 <pasic@linux.ibm.com>, Ben Segal <bpsegal@us.ibm.com>, "Tian, Kevin"
 <kevin.tian@intel.com>, Julian Ruess <julianr@linux.ibm.com>
Subject: Re: [PATCH v6 0/3] vfio/pci: Support 8-byte PCI loads and stores
Message-ID: <20240621141724.28fe0c5d.alex.williamson@redhat.com>
In-Reply-To: <20240619115847.1344875-1-gbayer@linux.ibm.com>
References: <20240619115847.1344875-1-gbayer@linux.ibm.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 19 Jun 2024 13:58:44 +0200
Gerd Bayer <gbayer@linux.ibm.com> wrote:

> Hi all,
> 
> this all started with a single patch by Ben to enable writing a user-mode
> driver for a PCI device that requires 64bit register read/writes on s390.
> A quick grep showed that there are several other drivers for PCI devices
> in the kernel that use readq/writeq and eventually could use this, too.
> So we decided to propose this for general inclusion.
> 
> A couple of suggestions for refactorizations by Jason Gunthorpe and Alex
> Williamson later [1], I arrived at this little series that avoids some
> code duplication in vfio_pci_core_do_io_rw().
> Also, I've added a small patch to correct the spelling in one of the
> declaration macros that was suggested by Ramesh Thomas [2]. However,
> after some discussions about making 8-byte accesses available for x86,
> Ramesh and I decided to do this in a separate patch [3].
> 
> This version was tested with a pass-through PCI device in a KVM guest
> and with explicit test reads of size 8, 16, 32, and 64 bit on s390.
> For 32bit architectures this has only been compile tested for the
> 32bit ARM architecture.
> 
> Thank you,
> Gerd Bayer
> 
> 
> [1] https://lore.kernel.org/all/20240422153508.2355844-1-gbayer@linux.ibm.com/
> [2] https://lore.kernel.org/kvm/20240425165604.899447-1-gbayer@linux.ibm.com/T/#m1b51fe155c60d04313695fbee11a2ccea856a98c
> [3] https://lore.kernel.org/all/20240522232125.548643-1-ramesh.thomas@intel.com/
> 
> Changes v5 -> v6:
> - restrict patch 3/3 to just the typo fix - no move of semicolons

Applied to vfio next branch for v6.11.  Thanks,

Alex

> 
> Changes v4 -> v5:
> - Make 8-byte accessors depend on the definitions of ioread64 and
>   iowrite64, again. Ramesh agreed to sort these out for x86 separately.
> 
> Changes v3 -> v4:
> - Make 64-bit accessors depend on CONFIG_64BIT (for x86, too).
> - Drop conversion of if-else if chain to switch-case.
> - Add patch to fix spelling of declaration macro.
> 
> Changes v2 -> v3:
> - Introduce macro to generate body of different-size accesses in
>   vfio_pci_core_do_io_rw (courtesy Alex Williamson).
> - Convert if-else if chain to a switch-case construct to better
>   accommodate conditional compiles.
> 
> Changes v1 -> v2:
> - On non 64bit architecture use at most 32bit accesses in
>   vfio_pci_core_do_io_rw and describe that in the commit message.
> - Drop the run-time error on 32bit architectures.
> - The #endif splitting the "else if" is not really fortunate, but I'm
>   open to suggestions.
> 
> 
> Ben Segal (1):
>   vfio/pci: Support 8-byte PCI loads and stores
> 
> Gerd Bayer (2):
>   vfio/pci: Extract duplicated code into macro
>   vfio/pci: Fix typo in macro to declare accessors
> 
>  drivers/vfio/pci/vfio_pci_rdwr.c | 122 ++++++++++++++++---------------
>  include/linux/vfio_pci_core.h    |  21 +++---
>  2 files changed, 74 insertions(+), 69 deletions(-)
> 


