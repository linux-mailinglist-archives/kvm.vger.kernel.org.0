Return-Path: <kvm+bounces-52644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B96B1B0775C
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 15:52:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBED91664B4
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 13:52:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E595B1E98FB;
	Wed, 16 Jul 2025 13:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="mvCFxaSv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C9D1E8332
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 13:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752673922; cv=none; b=ZoLxB/ctnKhfvJLjY2GIvwL1LZMFruTUFwBqOmy3Qiib9vUiqic5SnV9FXaRqTyJ7CAwN05GZbjiFdO8wcZM/kDVhOQbx98HIYVw1o2AYb0LaQxdEnrykamp5AwUBVyg2gitEL6mmV8kFNhEw9gkFt14IjTopBR0sNBVkaNWpGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752673922; c=relaxed/simple;
	bh=grW2AUSizTB1ZshpMQ9qX4KBTlAYx4u1Wd4mQU2d5Ls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f2WeBX5C/J+Or9gG4GZhuwQ9aTij9dJb087GpSqxyDcvjIjeeRQVY4735b34TPkgxW3NM6X+D/4ID+mVYULfnHIWB7Ww0yqfXEvlR567yyQpI3CPyRpqUkYKVr7xA4rWKIYOwPILalJ5C/ieGA7fT79A8VwJLKEYktwKe/k1Gzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=mvCFxaSv; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-7048d8fec46so9757486d6.0
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 06:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1752673919; x=1753278719; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZdjkYZdvq6o0RvZC4J9GMFYo4HQV1x5t2E+S5V0aQY8=;
        b=mvCFxaSvclUh5bvrlHBJvg1vH0LNX8BLOmfigK095/+azcRoBbwUDY+la/D3irZxzF
         0QMAg0PVeUDgAB2vyCqhAadnyI5rA863EnJDUJCTJy9h4M5xWgJQCXtim89d7Co4gkmP
         iWCBQr01yCMjr8OcfZRUQVzJPDKPONhKN47ml5qbKVcbmx3gyfmEPjkfydUJBDqBngdJ
         JYVGE44Od+TwF/YHAS52wbCK68yoG2qyd8WazI1s/MIzGRQZHe/oUTr86tR9QgxvXNWa
         z7D4O9Ai5Oq6hyGZy88alhOFrUBbNh2zjDwVAD55e2tl2++aBij9ztSbhOevGCev2soj
         Bajw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752673919; x=1753278719;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZdjkYZdvq6o0RvZC4J9GMFYo4HQV1x5t2E+S5V0aQY8=;
        b=vgVqxJ3+fp5jXV9VYCqIyE3Dus/5MuuVq8NsM6yY2+kc1i5qjb88+ilGyyFPR8rlh1
         IVffiFxyviNVw4OtdGUI8nZMbUFA705qzOXwrTKf5gEEnwZLqromKG6rR1j95jEFXXN0
         wrqGfluCI+2eryNArrQ2Pp7MZxHcAeBLtyCR4YeYko7bdfuzO03PmXJXY5TPPAZL4Zcd
         LZt6jNT+fo3wovzmKjWhDZNvD8O8z9BZjh70CONW6R9WHjyh4y80ps4Ug8dP4sToZSzL
         uwd1ZvIVzk7PyzTnAcYl1zj45v4jSys9B9QUA7WFcKC88/rXGpvcMmTcXN9gb17moGbI
         vk1g==
X-Forwarded-Encrypted: i=1; AJvYcCVe4hN1DSw/qmlQdjpjch8Pa4pQIjz7ejgBKFkTxtYcKWthWEeBgolGSdXI3c5iGmjaeSQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4m9f51U9YqURZ5tEf0s6Js31DST59O4BkuPycCokXExvTDz+r
	Bz02khAiW+t5ILgVGdQfGPqalhZIch+e6zQm6/3yNv/aYPvjcnOIU4gNZOcDfVpFGX8=
X-Gm-Gg: ASbGncuWWi6mBRMAtGeIOukfhnOQ2eLGYzHc3W0R3P28ExOb7YtcJtuv0CuH7btLJ6N
	Xy7S5YmtG72Wxew2g0OUTwpJ/Zqdz21Lnc2rlBs2Dcen+DUSl/RtgX59paN82gECRMGtJsVTNxP
	gc3oPRRvz5/s76fsrwwb8Os3cjKWj8W1K1gJOXYs7H2kVnVKy6eZqsJQTNiW8bKohKQyL4YfomR
	0ZucGlNvoWa02fqiPElXocnWBAoATkPoXxLJpAq1bRz15B1iEU6tDA9iuqVMho/pgl6+VYXql4/
	2VSYNt1Xg6ZiXL2qqg8htkY7ehoBSim6QgKhIzByNYCLNGQigcRvSxIU8E7AlpE73rSMkrFcOBY
	bqDo1NFAS6Ci9NjMAVJYgshB5vTADhLCleqXSDpJpiyWb9sBnBLrHmmKs7rlCxf9aXGuDhRiQAQ
	==
X-Google-Smtp-Source: AGHT+IE34DDGUpdfQtwke2r415OigmLgUTLk3xe/ctPjPqqKTT3F28vzpfc3Ass7rYE3KyXXLelv/w==
X-Received: by 2002:a05:622a:1cc9:b0:4a9:7366:40dd with SMTP id d75a77b69052e-4ab923e48c4mr44229461cf.19.1752673919173;
        Wed, 16 Jul 2025 06:51:59 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ab575ca629sm44704861cf.59.2025.07.16.06.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 06:51:58 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uc2Y9-0000000946K-3xvb;
	Wed, 16 Jul 2025 10:51:57 -0300
Date: Wed, 16 Jul 2025 10:51:57 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, alex.williamson@redhat.com,
	kvm@vger.kernel.org, linux-pci@vger.kernel.org, paulmck@kernel.org
Subject: Re: [PATCHv2] vfio/type1: conditional rescheduling while pinning
Message-ID: <20250716135157.GA2138419@ziepe.ca>
References: <20250715184622.3561598-1-kbusch@meta.com>
 <20250716123201.GA2135755@ziepe.ca>
 <aHetWNNNGstvIOvB@kbusch-mbp>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHetWNNNGstvIOvB@kbusch-mbp>

On Wed, Jul 16, 2025 at 07:47:04AM -0600, Keith Busch wrote:
> On Wed, Jul 16, 2025 at 09:32:01AM -0300, Jason Gunthorpe wrote:
> > 
> > You should be making a matching change to iommufd too..
> 
> Yeah, okay. My colleauge I've been working with on this hasn't yet
> reported CPU stalls using iommufd though, so I'm not sure which path
> iommufd takes to know where to place cond_resched(). Blindly stumbly
> through it, my best guess right now is arriving at the loop in
> iopt_fill_domains_pages(), called through iommufd_vfio_map_dma(). Am I
> close?

Yeah, I would guess maybe put it in pfn_reader_next()

But iommufd won't be faulting the MMIO memory from VFIO so you can't
hit the same exact condition you are describing..

Jason

