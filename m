Return-Path: <kvm+bounces-15327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 05FD38AB2EF
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 18:12:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99B5D1F22DA1
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 16:11:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3766F12F394;
	Fri, 19 Apr 2024 16:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="B08WCqC/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975A0130E4F
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 16:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713543099; cv=none; b=No14Bf9gGT8ysbD1xcDxeeFJfxnQozwO4T4YF+Ugh6fR7aPMjv0m4XX4UyW7ZJr2JRddSgW+ST7PxMKOjNe9B1XzbMc2T/RBLucjmp5O1qfMsndQwGFBWQVyINfCuFKM6kSM85v/j0r1c7HNCskLDB4a5OBBZyDlLt4wOCLEaJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713543099; c=relaxed/simple;
	bh=c355FjzRXp2PV5fV7cTtv8D/0hSyaEEZty37+zds9PA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bq7xEAoAm1LITuvHV+2RpmPHqcqx00EZJttGWuHz8FhfwbVp7NW8vHDb64B1di1eEzRGtdLibJMqlvyklNGsgFtWI80UM+lW18a45vya4rYrC6peo4Zrzsi+645acl6atsuW/bjAU5T6IRHz3V4QX47K8hnlRDTDlRSqq7tm6D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=B08WCqC/; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6ebb815f688so1408773a34.1
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 09:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1713543096; x=1714147896; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gPdDMUXyiuiq86o/a5LL/jaZpq2sMZf3qusGMS3HcBg=;
        b=B08WCqC/Tlnrq8SKJFHKOOhcHEKDCWyhvENSKiZ47tVdUkiSGE1zWPRCsywsSFebTc
         T+GtiRhCq29lQ7czlkfKIcu4UlQ4iFHwvNoGuIA2z8hQrSIQrM/SJBSbn01+iSrs5J6W
         VaFp3+KzY23aUWCkHkU/xXwrylnpJKzX10mlUPpGvbTxqhGXdWELY/Hu6cwcmnn647Hp
         zqJTEOnh394QwaR7G6OiAgPaGW33XT62z5I+W930K90NZAsCRu6Jnfc1PjdvFi7h+ktd
         bOv6qmTwUIsL1Nk7oBiNGNqUD4sJgpQzu7PCD3bhUONcOlqX+sRomnFIBajV/vyciMIh
         w9nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713543096; x=1714147896;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gPdDMUXyiuiq86o/a5LL/jaZpq2sMZf3qusGMS3HcBg=;
        b=l49j36+zNfSjakuhi47wxduskxePSj8ofrsVnliCk5+jAF4bQJoXmfE4c32/cJ8/uc
         6imNNfr6gFJ4SR/lfRvcDAZQzFjvJVL2P5lBsxQqVq56fpBbR+iSG7xyFaMVKcPWNvWB
         B/fiQupsgHoDss1c0N45mSouykEbteS5+BSlEoo6HUsktNP2LAqFy8cuA7yoPAn3gfXH
         41aF1cb22WE3O0NrWJ7Rd5rGciFLMmnvCzOkW+HjCxVH6do1P7JtvMdBa+uym2+y6MPL
         +QhBlVw7UPhrSRKlYRA2fnU/+ls2z81k1rrhYuEW3S2je+F1o/LDcGffN1mv6jjeVRGF
         YKOA==
X-Forwarded-Encrypted: i=1; AJvYcCVY2JVWrLSSLoD4zJsxxLu4BygJH9WSk4XrLTOgSHRjOLOSu43WpJPb3x9Lw9J7Vwt8x1p6A7HaUHimzYMFl92Zd4Pn
X-Gm-Message-State: AOJu0YzhpjGdK/on/24n4s4JUu+1T8ujsW6EKFaY1GVLzpRjjK/ZVI2+
	PZuk35j2DUBFZ9+TvjC9s1s3g1sKrLswjLVFmOEqBBwmi+kH37UO79dfieIcZ04=
X-Google-Smtp-Source: AGHT+IF7DVUq+dJZOo43uX5z1JMrxdHIu7CEnQutVFVuFx4NCCMcQbbW/K0XBawjCJRf1j78VXk34A==
X-Received: by 2002:a9d:7e8b:0:b0:6eb:b2d4:dd30 with SMTP id m11-20020a9d7e8b000000b006ebb2d4dd30mr2812878otp.0.1713543096601;
        Fri, 19 Apr 2024 09:11:36 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id p2-20020a9d76c2000000b006ea19aa0e4fsm733309otl.29.2024.04.19.09.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 09:11:36 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1rxqpr-00Fd4B-5i;
	Fri, 19 Apr 2024 13:11:35 -0300
Date: Fri, 19 Apr 2024 13:11:35 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Gerd Bayer <gbayer@linux.ibm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
	linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
	Ben Segal <bpsegal@us.ibm.com>
Subject: Re: [PATCH] vfio/pci: Support 8-byte PCI loads and stores
Message-ID: <20240419161135.GF223006@ziepe.ca>
References: <20240419135323.1282064-1-gbayer@linux.ibm.com>
 <20240419135823.GE223006@ziepe.ca>
 <c5ba134a1d4f4465b5956027e6a4ea6f6beff969.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5ba134a1d4f4465b5956027e6a4ea6f6beff969.camel@linux.ibm.com>

On Fri, Apr 19, 2024 at 05:57:52PM +0200, Niklas Schnelle wrote:
> On Fri, 2024-04-19 at 10:58 -0300, Jason Gunthorpe wrote:
> > On Fri, Apr 19, 2024 at 03:53:23PM +0200, Gerd Bayer wrote:
> > > From: Ben Segal <bpsegal@us.ibm.com>
> > > 
> > > Many PCI adapters can benefit or even require full 64bit read
> > > and write access to their registers. In order to enable work on
> > > user-space drivers for these devices add two new variations
> > > vfio_pci_core_io{read|write}64 of the existing access methods
> > > when the architecture supports 64-bit ioreads and iowrites.
> > > 
> > > Signed-off-by: Ben Segal <bpsegal@us.ibm.com>
> > > Co-developed-by: Gerd Bayer <gbayer@linux.ibm.com>
> > > Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
> > > ---
> > > 
> > > Hi all,
> > > 
> > > we've successfully used this patch with a user-mode driver for a PCI
> > > device that requires 64bit register read/writes on s390.
> > 
> > But why? S390 already has a system call for userspace to do the 64 bit
> > write, and newer S390 has a userspace instruction to do it.
> > 
> > Why would you want to use a VFIO system call on the mmio emulation
> > path?
> > 
> > mmap the registers and access them normally?
> 
> It's a very good point and digging into why this wasn't used by
> Benjamin. It turns out VFIO_PCI_MMAP is disabled for S390 which it
> really shouldn't be especially now that we have the user-space
> instructions. Before that though Benjamin turned to this interface
> which then lead him to this limitation. So yeah we'll definitely verify
> that it also works via VFIO_PCI_MMAP and send a patch to enable that.

Make sense to me!

> That said I still think it's odd not to have the 8 byte case working
> here even if it isn't the right approach. Could still be useful for
> debug/testing without having to add the MIO instructions or the our
> special syscall.

Yes, this also makes sense, but this patch needs some adjusting

Jason

