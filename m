Return-Path: <kvm+bounces-18057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DB178CD6E5
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 17:19:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D6119B21BC0
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 15:19:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94CE31170F;
	Thu, 23 May 2024 15:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="QxvdT3f0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCF9101CA
	for <kvm@vger.kernel.org>; Thu, 23 May 2024 15:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716477576; cv=none; b=hkUmQ1i6Khz8VkecD+PmH0S3YHSDoPrubDjL00eRcsDyopvqtfQbWkkLADBbIP+kvvJnDL5N27Sahu22aXKZR/MsxEVD/NR476eH9WR2vIvK9IO1tMp8lODo5v3t65kMY2i1NKvucafPEr+2CvJXhDuoVFODF7Rll8Mne6Dk5pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716477576; c=relaxed/simple;
	bh=rZEd8LdQ6Zv26yckL/PfuFMPfamA+s3S+lytwF/58SU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LhtipP6NY2BUKAu8Es0L6KaBYru4RwOBoT/ITP8kM5G/ujCU6zrs91iLz4bDbMETLAWQnRp6fjDCJ3uZNEpAVvcZkJE0XLVqRWinU9WUX/69eZa10XvWswanus265CO6X11HzBEWvl753+/PnZsA8pV74/QT2//6y2cZfi8BQ+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=QxvdT3f0; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-6a8691d736cso14977086d6.0
        for <kvm@vger.kernel.org>; Thu, 23 May 2024 08:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1716477573; x=1717082373; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C5GM0ixhavCb3lJsnHYS4J/lZEUFFylRa25YYAO3lZY=;
        b=QxvdT3f0OetY2YBgbq6kFihQldxVsBO9P8xWNY7pPU1opsjoRdBtIAJH03jsjk/+Mx
         QI3VQLVd/ISyg5POOJtiJS0QTnytupG4yeRC4GCRHUKF+NO3JcPjGgdAqiY9ZJgDWA+5
         rtVh8Mz4ZW20YZyImMKToYbHqFO6ubmkVyMrklD54ycbWPxwVRMM992VmbzcTTXtYC36
         RpJQK0M8QDVgd0KqJTwk71cP+/dwV6znZSyC3I3deNNVvHbpkRZpMXafujmO7WyN2+hQ
         wcQOtKzY73J0JSYWUpbQW2MY9bVUxtJ/aPoyhpNaGkur/p0ayvx9VUIiwEQ6pHJNa4kW
         NB4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716477573; x=1717082373;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C5GM0ixhavCb3lJsnHYS4J/lZEUFFylRa25YYAO3lZY=;
        b=RG8reYbogPAnToe3KCv/fCBqW7YBBiWXi9Rt/MQXp9uqrIkO49sP83idJX3bYNqTeu
         DNmAwMdxwU0OwpgmN9IP2quBQgCg4BH45Vs+pTj5vQ8ebI6mvX0uo8AB+Ii52Ml8s0QV
         xjGrwuqYaNoHbMFIcQrgHpQChfVRhlJdX1rGJxFDPcIOcHlPzoPtxUumJSfnC4+/i2xA
         HlZ4mFpPMcfeRWJfLzDyj5JiZe0SUHH8Np5c0DBWjtZ2G1fRQv94lkg6HZFwiTj90/+b
         NfIMiLzd2K8Vxhm5LS5dUsAaFL7o5b0eRkiMpOiHlwcVmgIGnClDrE2f3gJxqKdeP3Cm
         VKLg==
X-Forwarded-Encrypted: i=1; AJvYcCWT5xIarSAQSnID+MkVPuKdTkQsL8fWHtY2cP73GJ9KZaYN/Yki9ia1HChHPz2wsc3st+ssJBJvT149Sd17rtap9czq
X-Gm-Message-State: AOJu0YwCpn1sYsSB5NUS3sQilfEiLUpwavlK6iz1XXC9TOEfxyXdZ6g5
	yU8fwnTcMsDsQtTRP8xvhmdcIXT4P63Iq3la3O6xiiZbDMUJw8eQ1ij5Dli55Bs=
X-Google-Smtp-Source: AGHT+IFmPxDsj9nLUxgy/gv2BFbjFqLJH4yge1yEpFnhep0gZXO8FyvVSlATXLi0pQDD5PxbIp3m/w==
X-Received: by 2002:a05:6214:3d07:b0:6a0:e690:2f96 with SMTP id 6a1803df08f44-6ab8f5f3c9amr57165256d6.21.1716477573044;
        Thu, 23 May 2024 08:19:33 -0700 (PDT)
Received: from ziepe.ca ([128.77.69.89])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ab818288f0sm16704726d6.146.2024.05.23.08.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 08:19:32 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sAAE7-00Fqd0-BJ;
	Thu, 23 May 2024 12:19:31 -0300
Date: Thu, 23 May 2024 12:19:31 -0300
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
Subject: Re: [PATCH v2 3/3] vfio/pci: Enable PCI resource mmap() on s390 and
 remove VFIO_PCI_MMAP
Message-ID: <20240523151931.GK69273@ziepe.ca>
References: <20240523-vfio_pci_mmap-v2-0-0dc6c139a4f1@linux.ibm.com>
 <20240523-vfio_pci_mmap-v2-3-0dc6c139a4f1@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240523-vfio_pci_mmap-v2-3-0dc6c139a4f1@linux.ibm.com>

On Thu, May 23, 2024 at 01:10:16PM +0200, Niklas Schnelle wrote:
> With the introduction of memory I/O (MIO) instructions enbaled in commit
> 71ba41c9b1d9 ("s390/pci: provide support for MIO instructions") s390
> gained support for direct user-space access to mapped PCI resources.
> Even without those however user-space can access mapped PCI resources
> via the s390 specific MMIO syscalls. Thus mmap() can and should be
> supported on all s390 systems with native PCI. Since VFIO_PCI_MMAP
> enablement for s390 would make it unconditionally true and thus
> pointless just remove it entirely.
> 
> Link: https://lore.kernel.org/all/c5ba134a1d4f4465b5956027e6a4ea6f6beff969.camel@linux.ibm.com/
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> ---
>  drivers/vfio/pci/Kconfig         | 4 ----
>  drivers/vfio/pci/vfio_pci_core.c | 3 ---
>  2 files changed, 7 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

