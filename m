Return-Path: <kvm+bounces-17995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 415818CC981
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 01:19:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE6E6281FAB
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 23:19:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCC5D149C72;
	Wed, 22 May 2024 23:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="hioXa44l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC98F2C694
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 23:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716419936; cv=none; b=GHVMqnfCvEGozaUiFLc+6CdkCYrG1+mCXzwa5zZ137ixuNja6rRU7+01YhQ2GNC2Z5oNncJDjBjZQEkZULevZY0aZ0pcouMffRX34OmDarSVdQk4cnXHMAggXPlnrXbxCpcfUgDEiAg+uBNiRlmhsKakTgywXpARG172XzVsoAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716419936; c=relaxed/simple;
	bh=a8AQZsl0hHp/MWuPJC+3jCzAsXNov1TbjZ4OUKXyAqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mdpeAdNTcWrnGR75bM6DUednpVWX85TSL2h98BkkaRXbv8AUgPyzYb4IO+2+00jq2z6eemtwa11Shi+zZzBP+7SiY3o76ZYHbl280mDc6y0tkpX2gjy/2f36lvFnuJKT+v74GoXwUUEweo3m23ENJ1v83lMQi1pAsUq8bhM3OpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=hioXa44l; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-6f0f80b780fso3471902a34.2
        for <kvm@vger.kernel.org>; Wed, 22 May 2024 16:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1716419934; x=1717024734; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9lEc0q0NFwchKt04aNPxLlVagWl6RQJdUVl1HVjQyus=;
        b=hioXa44ltZN15LYNqtx5XNRjodlRtHndmCZ4Z9alzNul/62PAyCi+Xzw/2YZmIOPTJ
         dj/9SUGKWskskvM/xlrOlaY/9HsaF1xDOCp/nrnnPkzf8jlFvqeb/o13ihL8hI0NVLjC
         p8IqYndv/4hZ8rNfUBFyA/VVuy82mQkN+wsweY2tqXjZPVEF6AoEFX9A05fFFibCT84A
         ZqUv32IxIGDzqWMYECtgFFGea67/7PhDo+ucN2bglz8jjqBaHcYLvWwo/ITOY69Fh+XW
         bX40dr/iqXhbKAA+cT8mdfhKCKSLWGB6CyGI41AU3jiYyzYm7friZvphjpl+J9wSnH1S
         xexw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716419934; x=1717024734;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9lEc0q0NFwchKt04aNPxLlVagWl6RQJdUVl1HVjQyus=;
        b=R7CnmYTynJpMROl/eR9kprj5bpdNCdJ4/M7B50pyS20CqsCUtEKeVxEr0RIy/kJrHD
         zyMAX5IKWBGY/FRfNn42RiURkI+3vQAI7/V5H+fxvIzdGIqk8Nl56wUA//sYRg58QMpu
         pV7HsWrSvFEY4grdthhG69Q5VhQ4dq/M8sSsHaW8N2pHSlKBajmsRAO6YR7MlS6JjJxI
         rij/YoRcsVYMNE0mkDZOSgTAlXtiZUQcQBp1HmvNQOHueLBlVdl0cvSXsMxwVuoSUSfr
         7mjLc1Nv2Mwy372uQ3gwO5si9R63zfM1ihUBF8zFIM41jnSA7SZt72FkIWcQlVnYFGaI
         Uxpg==
X-Forwarded-Encrypted: i=1; AJvYcCVmgBHNnlgat1pCJyTrJiBq6F+m8kCVxqwddo6pCLvlIwf8skZSflDRfU9NaoKOW45/iIk2ebLD3YCogZvI+n3f/qM0
X-Gm-Message-State: AOJu0YxVBPjM7Thy4Wg8ypoPmyQCtMUX9QoXcnrFBCm9ClRbFoEvxUGb
	sDIrAYL8ulASjcysIT2c2kAoDCGHPywhG5nWJ2hn3OfycyY0y43YTKOR7WQJpUQ=
X-Google-Smtp-Source: AGHT+IGXTwA1P98f2K83E/XepnAUDe0bm40qM8+ZbtN36/xHnQTOXwlXxoFwX2cK74BW84EIAoMvyA==
X-Received: by 2002:a05:6830:18ca:b0:6f0:4201:973a with SMTP id 46e09a7af769-6f665c2bafbmr3446974a34.13.1716419934009;
        Wed, 22 May 2024 16:18:54 -0700 (PDT)
Received: from ziepe.ca ([128.77.69.89])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-792eb3c1039sm956315885a.73.2024.05.22.16.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 May 2024 16:18:53 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1s9vES-00DcAY-9Z;
	Wed, 22 May 2024 20:18:52 -0300
Date: Wed, 22 May 2024 20:18:52 -0300
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
Subject: Re: [PATCH 1/3] s390/pci: Fix s390_mmio_read/write syscall page
 fault handling
Message-ID: <20240522231852.GF69273@ziepe.ca>
References: <20240521-vfio_pci_mmap-v1-0-2f6315e0054e@linux.ibm.com>
 <20240521-vfio_pci_mmap-v1-1-2f6315e0054e@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240521-vfio_pci_mmap-v1-1-2f6315e0054e@linux.ibm.com>

On Tue, May 21, 2024 at 02:14:57PM +0200, Niklas Schnelle wrote:
> The s390 MMIO syscalls when using the classic PCI instructions do not
> cause a page fault when follow_pte() fails due to the page not being
> present. Besides being a general deficiency this breaks vfio-pci's mmap()
> handling once VFIO_PCI_MMAP gets enabled as this lazily maps on first
> access. Fix this by following a failed follow_pte() with
> fixup_user_page() and retrying the follow_pte().
> 
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> ---
>  arch/s390/pci/pci_mmio.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

