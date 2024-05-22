Return-Path: <kvm+bounces-17958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EABF8CC26A
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 15:48:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DACA0B2366A
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 13:48:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF497130AFF;
	Wed, 22 May 2024 13:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="cWjlHulR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232EC81741
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 13:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716385698; cv=none; b=sQWs2W8ELuu0MNyflAqh5RXsP81VdN3BlIg+hcxM/kJKICUsWNzlE8QfPnqjdpKdX/zH6LBRg/HbFpvt98r5e0e3UCvVFiKzSg1zZiAhuP47hcrI/cM/N2IHG0FGnSu9MBWsW15lGTHMDTipBINyt++tNy0L5YOMQE6a2C/Xvd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716385698; c=relaxed/simple;
	bh=VB7Y6q3P0R0DBaYp5JNlhupnq1sPd9mP3oeB28RMPNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sSBsDLJfcToUV7atJ6fHqWYSSvvK+k63RAk3Fpm0Kw1nfhPHalcsk2sTCtzLH0ZdU5RVv8ugK4zRokpjNzFR2A4U70GSzzxPRi6EwqsCapFOKv0KozQTCWHSHZSUan0gIWksxHDQT3A6AnOBCe1YZmoSBLcbguheE3FCItdIf/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=cWjlHulR; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-43f84f53f56so6742761cf.0
        for <kvm@vger.kernel.org>; Wed, 22 May 2024 06:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1716385696; x=1716990496; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VriS+lT4fkCRz6d6ylUVr3xhpMkkPTXruVOhQlHWG1Q=;
        b=cWjlHulRt1XAOrJCoA5OxFIIA+SXaHRL9l1zLSKfXPoKqLFLtG3zHjmBz9FeHIJp7u
         rPJOk+LXrHvBBN4bLLtMrlxl2xKFlEnl5PmdskpN/O25a/3Ya7nRB2GfhIBF0ijZn+Qm
         +bXH9Rqaiw+ZB7cp21XZ9ALdda9a643sN/dz/+ILsviJoWKCw5Qb9lOMRidMdBXPZvoc
         vZFXmXgFUfe5wDBMeNIJ0smYg+OEsEZxGbWIXfPsulj6E6Qn3CehKeTetDYmkrHDLfWj
         D0ctadJNzBM3OyrhB3PFgwrlRS2N8QyYfvgxf60rtBnBoAldspibPF4vyRw/7EFd+rJr
         P1Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716385696; x=1716990496;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VriS+lT4fkCRz6d6ylUVr3xhpMkkPTXruVOhQlHWG1Q=;
        b=s8Syiok1/sybnZ5p7tNwi29eAuM57DHhzBnMFHBOUQAu5kBcwweTEcAEMsGWCDNQ/f
         pihL8lxRKK5pSP8YiW6LTDV+oyFL1Y9Cau/vJicYYBzynNReF2S37pxTXuY2hH7rVtDo
         63WtRddR8/CzkLcO9iLa/GNJ01EZ5X5Q6y78Pm9qQBrKj8iGjhojYdfamp9H/ADLqiHl
         T81ZFtB4SxYxW+upINcSMJL06l5kKAvRUCFDO0Er+LFPrfgMMZDNlu/kE7T/2SNa1TnP
         FtxON/MM1+aT9cpC8hZOOVXyum73tI4BcEvw5k3BmzkdTPPBin2BytR01nfYcQNjLD1w
         khmA==
X-Forwarded-Encrypted: i=1; AJvYcCXA4dDpnx++w0bok4vRs/FDh7EfWnUK/NX2zELyaeSwF/lLPoIuozPGcwdMRHz1lFriNcy+rX696TFrfBZMYnHI539J
X-Gm-Message-State: AOJu0YwcQzhiOnfBS/0L3CgUOoQ1aMrvKHTPWyOVSdF7eZXC7vQyWV/a
	+7aDHm2a4UYxDhxTvlRXMqvtAdY/5g62nOCmdg4tbo9OQVkVD7cWKtTXyb54I/A=
X-Google-Smtp-Source: AGHT+IHMRaVIW5wXhRCbaxnSmORMVLlS6qCVXP2eeWq5rIvq0+lwdkbPRBWbztbdALmyLU+dnHqC0A==
X-Received: by 2002:ac8:57d2:0:b0:43a:d3e6:3ecb with SMTP id d75a77b69052e-43f9e0b6562mr22129531cf.26.1716385695758;
        Wed, 22 May 2024 06:48:15 -0700 (PDT)
Received: from ziepe.ca ([128.77.69.89])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-43e069a24basm151668731cf.67.2024.05.22.06.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 May 2024 06:48:15 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1s9mKD-00CHmz-Uf;
	Wed, 22 May 2024 10:48:13 -0300
Date: Wed, 22 May 2024 10:48:13 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Gerd Bayer <gbayer@linux.ibm.com>
Cc: Ramesh Thomas <ramesh.thomas@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>, kvm@vger.kernel.org,
	linux-s390@vger.kernel.org, Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Julian Ruess <julianr@linux.ibm.com>,
	Ben Segal <bpsegal@us.ibm.com>
Subject: Re: [PATCH v3 2/3] vfio/pci: Support 8-byte PCI loads and stores
Message-ID: <20240522134813.GD69273@ziepe.ca>
References: <20240425165604.899447-1-gbayer@linux.ibm.com>
 <20240425165604.899447-3-gbayer@linux.ibm.com>
 <d29a8b0d-37e6-4d87-9993-f195a5b7666c@intel.com>
 <72da2e56f6e71be4f485245688c8b935d9c3fa18.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <72da2e56f6e71be4f485245688c8b935d9c3fa18.camel@linux.ibm.com>

On Tue, May 21, 2024 at 06:40:13PM +0200, Gerd Bayer wrote:
> > > @@ -148,6 +155,15 @@ ssize_t vfio_pci_core_do_io_rw(struct
> > > vfio_pci_core_device *vdev, bool test_mem,
> > >   		else
> > >   			fillable = 0;
> > >   
> > > +#if defined(ioread64) && defined(iowrite64)
> > 
> > Can we check for #ifdef CONFIG_64BIT instead? In x86, ioread64 and 
> > iowrite64 get declared as extern functions if CONFIG_GENERIC_IOMAP is
> > defined and this check always fails. In include/asm-generic/io.h, 
> > asm-generic/iomap.h gets included which declares them as extern
> > functions.
> 
> I thinks that should be possible - since ioread64/iowrite64 depend on
> CONFIG_64BIT themselves.
> 
> > One more thing to consider io-64-nonatomic-hi-lo.h and 
> > io-64-nonatomic-lo-hi.h, if included would define it as a macro that 
> > calls a function that rw 32 bits back to back.

This might be a better way to go than trying to have vfio provide its
own emulation.

> Even today, vfio_pci_core_do_io_rw() makes no guarantees to its users
> that register accesses will be done in the granularity they've thought
> to use. The vfs layer may coalesce the accesses and this code will then
> read/write the largest naturally aligned chunks. I've witnessed in my
> testing that one device driver was doing 8-byte writes through the 8-
> byte capable vfio layer all of a sudden when run in a KVM guest.

Sure, KVM has emulation for various byte sizes, and does invoke vfio
with the raw size it got from guest, including larger than 8 sizes
from things like SSE instructions. This has nothing to do with the VFS
layer.

> So higher-level code needs to consider how to split register accesses
> appropriately to get the intended side-effects. Thus, I'd rather stay
> away from splitting 64bit accesses into two 32bit accesses - and decide
> if high or low order values should be written first.

The VFIO API is a byte for byte memcpy. VFIO should try to do the
largest single instruction accesses it knows how to do because some HW
is sensitive to that. Otherwise it does a memcpy loop.

Jason

