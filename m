Return-Path: <kvm+bounces-15545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1A768AD36C
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 19:43:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C2792832CC
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 17:43:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FF31153BF5;
	Mon, 22 Apr 2024 17:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="DUQwm9ry"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D2C146A6A
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 17:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713807788; cv=none; b=pOf0XbbKOANYiPSYKYEnElsxR+Gr8V6U/3GGvI5dS/SNSYCO9Xn0JmuQjjY9kTOyIB5AecnB6KcpdckmmXqg4yfRgulHP5qln+8lC+0QxieIKTgUBbukNZ+QttC6WQj1LfVCHmUOjtNeuDsIWQCfclfoQpZqhIPFp+19W8HINik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713807788; c=relaxed/simple;
	bh=FPRYflSYPTzX630Jd0+hB1WOM3PbajZTXlGiVPiZLwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JJE1ePdaq2R05tGWErYc19Kba/89ygeQe/TWdJhfg7hSWbPJ7A7YmP2pdrjvqtoptKOOndiR/13a10pLG8hmzkG96xyW5GSiPZlmPb2sihepBcFsFbTgWSM8dxH9EardMGIQf8TuNe0wlPOckvCAadBpE1XiVfkj0JN3s/jz/hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=DUQwm9ry; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-69b24162dd6so22000736d6.2
        for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 10:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1713807786; x=1714412586; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k/KOCqovdO5PsKSs9PxME/OsGBVBN8Xn1TisHFdx68w=;
        b=DUQwm9ryLZY0bh3kXfAbzC7p/jLS0DsNSzp0F6Xrso2bUIDG0KSP//+N1wUGLLwnfx
         x5Qe4eJV2BgMp/R7vpPijfIwOPPtfj1HTPk/jdKeAWj//gzi+dCOUviK/CqxPfQ3C5Lg
         RYB6ViVzk8WuAba5UjVxgYzdG6YCEWDyD/tGp775u5jVOxuKOx/Dy7yVxqKmfa+2IDfq
         OEtQ9VW0TXKEsb3ehsczY/VJ043vTpmetD2J8YrbdX/IHQKBteoueg3F80KCzkxvJr6J
         03d2weegRHQPRaX0ZuP5D+hZrLXplxdixVqqUU7YtRvsyvZa+1PAYNJR/Tsej6o+vMUh
         zOTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713807786; x=1714412586;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k/KOCqovdO5PsKSs9PxME/OsGBVBN8Xn1TisHFdx68w=;
        b=SbXk1QAPKTFcZ+UQFskKTXSa3/L0aqeI4N4yjGJ52ZtLN7wunMcGX3l99c2hKCH+/W
         W809kLc8zqm8UO7nPK5a/39YQu2dIOupRhw7kYBNeAewYbKwKb51IrbdjLUvgmCDa/+h
         BIUdz4kNsQ21Kh+gG1jFFHVsLg7ePG79GTrXWLkfChR1uqQGnNGBkTAKJ99dbdvCDmLD
         EpbHWLjrDrxZAkVSqGBZ41J4+I2SPuFuITUf5qNKOPDZveLhn+CAm15KjTf4gCkktySJ
         4BZPhbjBiTnw/ntV4KljDNIwnUPe9UJePbrpphlYkdKx6CfqoNqS461te1oT1mAwbOgw
         3gDA==
X-Forwarded-Encrypted: i=1; AJvYcCUAcbrVut86tJKKa5taprWeLpwQf6jXx+tld6XhxqlN1733h6WsX5VQ+vLotflZhAbWfov8/iiylq4Hvm+fnnoO4qmu
X-Gm-Message-State: AOJu0Yyy6i4pL4s3wbw6qQRFeBy0al1Mb8xE1v6oAx4g8ZiuzG97GOkj
	5hIAURhWhidCEQ7FpiVc5LY3hiokN1V7V3EEKgsri7PoOkrbMDDou3ctSZj34ro=
X-Google-Smtp-Source: AGHT+IGHiFa58Cxg/cz+5GibMHdsBS0/TvPvketvKNLRvd4ffYu0hhtDDfBaJpWtYAmFnVmikIfyBA==
X-Received: by 2002:a0c:f8c9:0:b0:6a0:5e9a:a9a4 with SMTP id h9-20020a0cf8c9000000b006a05e9aa9a4mr12406744qvo.7.1713807786099;
        Mon, 22 Apr 2024 10:43:06 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id x1-20020a0c8e81000000b0069b40c06b11sm4430054qvb.105.2024.04.22.10.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Apr 2024 10:43:05 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1ryxh3-000ykz-20;
	Mon, 22 Apr 2024 14:43:05 -0300
Date: Mon, 22 Apr 2024 14:43:05 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Gerd Bayer <gbayer@linux.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>, kvm@vger.kernel.org,
	linux-s390@vger.kernel.org, Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Julian Ruess <julianr@linux.ibm.com>,
	Ben Segal <bpsegal@us.ibm.com>
Subject: Re: [PATCH v2] vfio/pci: Support 8-byte PCI loads and stores
Message-ID: <20240422174305.GB231144@ziepe.ca>
References: <20240422153508.2355844-1-gbayer@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240422153508.2355844-1-gbayer@linux.ibm.com>

On Mon, Apr 22, 2024 at 05:35:08PM +0200, Gerd Bayer wrote:
> From: Ben Segal <bpsegal@us.ibm.com>
> 
> Many PCI adapters can benefit or even require full 64bit read
> and write access to their registers. In order to enable work on
> user-space drivers for these devices add two new variations
> vfio_pci_core_io{read|write}64 of the existing access methods
> when the architecture supports 64-bit ioreads and iowrites.
> 
> Since these access methods are instantiated on 64bit architectures,
> only, their use in vfio_pci_core_do_io_rw() is restricted by conditional
> compiles to these architectures.
> 
> Signed-off-by: Ben Segal <bpsegal@us.ibm.com>
> Co-developed-by: Gerd Bayer <gbayer@linux.ibm.com>
> Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
> ---
> Hi all,
> 
> we've successfully used this patch with a user-mode driver for a PCI
> device that requires 64bit register read/writes on s390. A quick grep
> showed that there are several other drivers for PCI devices in the kernel
> that use readq/writeq and eventually could use this, too.
> So we decided to propose this for general inclusion.
> 
> Thank you,
> Gerd Bayer
> 
> Changes v1 -> v2:
> - On non 64bit architecture use at most 32bit accesses in
>   vfio_pci_core_do_io_rw and describe that in the commit message.
> - Drop the run-time error on 32bit architectures.
> - The #endif splitting the "else if" is not really fortunate, but I'm
>   open to suggestions.

Provide a iowrite64() that does back to back writes for 32 bit?

Jason

