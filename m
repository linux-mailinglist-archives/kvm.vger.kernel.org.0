Return-Path: <kvm+bounces-17997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F08618CC989
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 01:20:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8FD721F223E0
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 23:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22294149C77;
	Wed, 22 May 2024 23:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ctNuss0D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E759413D601
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 23:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716420029; cv=none; b=LwQv8kFzSjraSK9XerbTrjXAbAZ94h3N2yf6iHPTBhFczAj9HzwwKpcd1rksnXAn6nFdtxiVZ1U5355ithgWaoJ7U9iCR9ljpz4VRS6qcOCxl/aorYBZYcwQr9/vgRLHtRjMXPVVGiBiqkKYzuTV38AkVjifQX623cN8LvHUZJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716420029; c=relaxed/simple;
	bh=sw8yapCLRtTv5bLqcNyAlitdCMqg+LKpbh2Il4sznmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SlDUAgJamFVlVMRybxebPfA5KrwYFySTL972TqrApVFe+vI9JYAYnEsI0/wgGedPKVdGzX2AVokdil2Np55A7nn8VYLi/csfWONszOeVpu3bqiqWpHgjmbj1/ZGCV78Klt4xvMPbQSScIFgFqhU/Ww5t4jcMzqzrqy+i+7BpzUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=ctNuss0D; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-628c1f09f5cso2319037b3.1
        for <kvm@vger.kernel.org>; Wed, 22 May 2024 16:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1716420027; x=1717024827; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hRVT/HQCpieEX4UPQ3b9FruvZ7YPs6vzZePRdAjyEWU=;
        b=ctNuss0Dyy3Rxrd/Q6AUBdArj6zQJX8n9finRlT2oLz2zv+GA2SPOg9yrqhLjRYw6p
         BLR3PyQYXtO9AyFvxvT/se/JVm9YJq1uJ8E95sDC9SehVyhDPgKifKqiF1J+Mi8nYU2o
         IrHJmqzkjDd31XLRoJlhD5oPkM7OduWkkGsaajWY9w+F45qPKQ4pc+d6Gr4okG8z4gpj
         +v8U5SVg2PQ2tmldNAmhJPoPsvUvnl7ykC9smDeRaeZplsn/rhq269GOAelk1FKsNt6I
         aeBXmw0nmjdixEsNMhdimWxwqWVP8mXXQzEzFUixatd1dcHFeemC+W9qPjcQ6TNXp8lX
         uSuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716420027; x=1717024827;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hRVT/HQCpieEX4UPQ3b9FruvZ7YPs6vzZePRdAjyEWU=;
        b=UBqkWCJtqXjTGwfi7S68xZn0qy+gePKbOLmZgVvMuUXMYXAGV6kqS5qvs+aNIYsB12
         bnF9J+SUmiWfT1V2sWD4nGak+9Sf0RIRI2rpEY7VBrZKs6vH9Bxquf5tnw3c0919/BLK
         jDL1RvksLf2fNAo1dycnjMhIrDI+cwLusZMFiNCJpfUpyHirkyDn/frUYpxb2T7MOXek
         S7yPwoHtm+ph8rojGs9hByFnGqg+cn4N8d7ohM+Cm2/J5RKGjr/XxZPKhVEjwca8884A
         tnsIIb87sFvn2TBJY45kcOE7TZw1wQvhHjHsDbEXCndqUMfhBuXIJGculbKmoEUtcgaY
         98gQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJF/9pB5xBVXGhnWCXePEB5uw6ghYEUcb2lRhancB9QlagQjKL4kXOhBm9dUPATIutcSLNjdQDLtKaQ++RD7RQboFY
X-Gm-Message-State: AOJu0YyC9Wf2g0bOiPDNed5jvczcwoh7B082C3FUV8XH7+0R58vTkfCE
	mdkLmklBFMBjtydp3V7mbcwkKMUf8S3aIR2P5CIBvAd3+/xti3NxUIcPiEJzj9U=
X-Google-Smtp-Source: AGHT+IHvW5aCdlXJsaBLmnifAzEUlPyyjqpEx6u3uIPqRTKh7DLWMe+zoge0ZxLclJp8Db8si4PB6w==
X-Received: by 2002:a81:4524:0:b0:61a:ca09:dae3 with SMTP id 00721157ae682-627f0975f7emr25218317b3.26.1716420026923;
        Wed, 22 May 2024 16:20:26 -0700 (PDT)
Received: from ziepe.ca ([128.77.69.89])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6aab86b0e55sm33972586d6.85.2024.05.22.16.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 May 2024 16:20:26 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1s9vFx-00DcPG-7p;
	Wed, 22 May 2024 20:20:25 -0300
Date: Wed, 22 May 2024 20:20:25 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 3/3] vfio/pci: Enable VFIO_PCI_MMAP for s390
Message-ID: <20240522232025.GH69273@ziepe.ca>
References: <20240521-vfio_pci_mmap-v1-0-2f6315e0054e@linux.ibm.com>
 <20240521-vfio_pci_mmap-v1-3-2f6315e0054e@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240521-vfio_pci_mmap-v1-3-2f6315e0054e@linux.ibm.com>

On Tue, May 21, 2024 at 02:14:59PM +0200, Niklas Schnelle wrote:
> With the introduction of memory I/O (MIO) instructions enbaled in commit
> 71ba41c9b1d9 ("s390/pci: provide support for MIO instructions") s390
> gained support for direct user-space access to mapped PCI resources.
> Even without those however user-space can access mapped PCI resources
> via the s390 specific MMIO syscalls. Thus VFIO_PCI_MMAP can be enabled
> on all s390 systems with native PCI allowing vfio-pci user-space
> applications direct access to mapped resources.
> 
> Link: https://lore.kernel.org/all/c5ba134a1d4f4465b5956027e6a4ea6f6beff969.camel@linux.ibm.com/
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> ---
>  drivers/vfio/pci/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 15821a2d77d2..814aa0941d61 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -8,7 +8,7 @@ config VFIO_PCI_CORE
>  	select IRQ_BYPASS_MANAGER
>  
>  config VFIO_PCI_MMAP
> -	def_bool y if !S390
> +	def_bool y
>  	depends on VFIO_PCI_CORE

Should we just purge this kconfig entirely? It is never meaningfully n now?

Jason

