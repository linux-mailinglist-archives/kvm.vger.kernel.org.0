Return-Path: <kvm+bounces-15293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B0F448AAFE1
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 15:58:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 650B4284474
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 13:58:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C1FE12D748;
	Fri, 19 Apr 2024 13:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Rd+AGjnd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2894C12D1E7
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 13:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713535108; cv=none; b=Scgo2JEmd+pBNrCsPT3+LMw4yXt167h9kxtLRTDJhiSzdrRy2wl9YKIVV+p+eLVe+k2rRA5ovRRqXIvpYIwb3pxOHmxSHoB2B15EhSex4I7HXvC/P9XfTfK1wMmn3Zf0YIY8IeQA5zekPP0FNoFLhvdgIJmU8cnBKYrJeQbzvgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713535108; c=relaxed/simple;
	bh=UNW3QZV4+gJLU3id30uoS/EvPlzfwIriWW0qthqWIDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L5K0nwhfmC07cQtaOMRcu44Hb8MapogFaLihbCiMh3sDnVQcg2sMHbdyAbeICneIYKQZt7sTs/r72EtIJf9+lmI0A5ff4taChTmKlVOKM13bQQ89e7rSRLlq0BS3gh2/Ml2OpzSXBQnjcHDYff9m47EN83hwT2IafF44jtl3XJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Rd+AGjnd; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-5aa1fe2ad39so1131856eaf.2
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 06:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1713535105; x=1714139905; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NIwb+Ip4VmhAzCakCe7bX4ZZtS5svATpWYgr8CM6tXM=;
        b=Rd+AGjnd3xrIUr5O7zNhi04vTQmYowFVxlp9HJJ1eUeBNLM/LGLUSDyDHV+fid2be5
         /jcW068jKmsGciyts9aWwcjDN50j0NPmAFNGhV0RjF5a1MUDnX+dlAUk+VDl53RrqEMo
         /AlY8Tm3TwLwKBbMTnudWhv1CeM7z36ZhC1uBznKfLBXTKwGJaTvjR/f99P/a8vRUHw4
         +RSqJTMHwsJJuaxgC7PLsL4GkaOqCRkBPhZRvqD479tZss2pediRaPw4plkf6neDc5ig
         DscOI0ATVN1rxzi+WUlHrmejwKb3w8z5hAHZW5mViiwX7ILrX7yD7I+X9xm2TcKttc9+
         9EbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713535105; x=1714139905;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NIwb+Ip4VmhAzCakCe7bX4ZZtS5svATpWYgr8CM6tXM=;
        b=S+0QnDRK8SQwvtn8SzT6aJEhLa+YfM8rZQfkPwyYyNG08wXuCaiH/OOfsauJYv51PE
         Pit/2WrAfqBNJbKLT3jb3h3CnfbsaXWzuyEzuTxrb7gxBIna7KE0UImCdhy+qMh8AAhv
         uiFHj80rKx3yMQjsVHXmHZ3vG4ECCycUKMBmOZuoCYCIKTAUBs67uXYqmRrYHSSTmRqD
         Y5B3sq8WgKA4TguB/Y68JyULhza7EMlAixK2Bs7bIM3K5u8MvdvRu6TMJCtXlH/oI4mR
         tgRIMcGch70d8Sr6tJMpMVwow2Tu2YfWiOtfzpfhUeb1Mh1/82q0+eiVeo4KJjI0YoTk
         zG0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWuk3iLE06rWSIfB1qLeHvrDUZuMPeUnhXEaNRibR7Xu02E0JRWonslUBaPMcgcSAvhZGvFpdKHR5DfwB1EiyptcGMp
X-Gm-Message-State: AOJu0Yxff0xpt7EaCKu06ixpOq2DGwfKMI0lMKcc8rPlivWolhqusJ8I
	vovuF3cTS+XEtr+B50FFTN6Sm3yrhMK86M+E3eqtb/20sHdmehsNWcJHf1dmc8IONHqOgiAWYv9
	h
X-Google-Smtp-Source: AGHT+IHOvq+gGQEh6mSTA+Vgr5DSOayWVdz/vb+zjSDQL4rbJiN/Dw6sDw9HEs4d8HUAav7a6oKDhA==
X-Received: by 2002:a4a:384:0:b0:5ac:bdbe:9cc8 with SMTP id 126-20020a4a0384000000b005acbdbe9cc8mr2404932ooi.4.1713535105273;
        Fri, 19 Apr 2024 06:58:25 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id p6-20020a4aac06000000b005a4bcb155basm836308oon.23.2024.04.19.06.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 06:58:24 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1rxokx-00FTTb-RV;
	Fri, 19 Apr 2024 10:58:23 -0300
Date: Fri, 19 Apr 2024 10:58:23 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Gerd Bayer <gbayer@linux.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
	linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Ben Segal <bpsegal@us.ibm.com>
Subject: Re: [PATCH] vfio/pci: Support 8-byte PCI loads and stores
Message-ID: <20240419135823.GE223006@ziepe.ca>
References: <20240419135323.1282064-1-gbayer@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240419135323.1282064-1-gbayer@linux.ibm.com>

On Fri, Apr 19, 2024 at 03:53:23PM +0200, Gerd Bayer wrote:
> From: Ben Segal <bpsegal@us.ibm.com>
> 
> Many PCI adapters can benefit or even require full 64bit read
> and write access to their registers. In order to enable work on
> user-space drivers for these devices add two new variations
> vfio_pci_core_io{read|write}64 of the existing access methods
> when the architecture supports 64-bit ioreads and iowrites.
> 
> Signed-off-by: Ben Segal <bpsegal@us.ibm.com>
> Co-developed-by: Gerd Bayer <gbayer@linux.ibm.com>
> Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
> ---
> 
> Hi all,
> 
> we've successfully used this patch with a user-mode driver for a PCI
> device that requires 64bit register read/writes on s390.

But why? S390 already has a system call for userspace to do the 64 bit
write, and newer S390 has a userspace instruction to do it.

Why would you want to use a VFIO system call on the mmio emulation
path?

mmap the registers and access them normally?

>   * Read or write from an __iomem region (MMIO or I/O port) with an excluded
> @@ -114,7 +117,41 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
>  		else
>  			fillable = 0;
>  
> -		if (fillable >= 4 && !(off % 4)) {
> +		if (fillable >= 8 && !(off % 8)) {
> +#if defined(ioread64) || defined(iowrite64)
> +			u64 val;
> +#endif
> +
> +			if (iswrite) {
> +#ifndef iowrite64
> +				pr_err_once("vfio does not support iowrite64 on this arch");
> +				return -EIO;

can't do that you have to go back to what the old stuff did and do the
4 byte copy.

Jason

