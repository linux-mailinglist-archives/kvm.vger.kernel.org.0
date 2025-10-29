Return-Path: <kvm+bounces-61418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id CB5AAC1D423
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 21:44:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 77B704E2508
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 20:44:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D536F35BDC4;
	Wed, 29 Oct 2025 20:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="NdZ6LFnT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496403596EC
	for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 20:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761770656; cv=none; b=p+sPgB9JylDk5Djs4k6EkJ2WRQN3ZI8jfTmadD8mJ12AmzgoQFJf0K7v9pfVjS7LQ4gnotlkRIcOUKossmHU4jQj5a1xw2Y7/dSFhIXVWdPFUfjItIL03AfHxVxXJ1MLIxw2oi+IzAs3Fd+chn1IQJVlWyOASE2mOOXNEag4bDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761770656; c=relaxed/simple;
	bh=PpaAnelvP90qNut+ZwW7vK2RK0H4rH7vlQYQGs2uXZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OqJhnoBu9c3mxMs9mrXgu19Cw1Vaae66AiA0PbcmsbLxFZaVEMqfPtde5DUs5lkgO2iTHmjPZMOMjqWX1YGoSQbBveOdMNvAwU83X6AnrnDvDTBPEHbWhQDzauXYwIRLngFZVW77JqOZ8ZDMC4WiIGj1O7Fv6EdbRMRpVKrIGm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=NdZ6LFnT; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-89f4779fe03so24110485a.3
        for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 13:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761770653; x=1762375453; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RXmwII94RIU4hvYvWVxvISL3Cf6KBQEXeyuNCmaeDUA=;
        b=NdZ6LFnTI6zrhukv2ioDeAyjWqg6+j1Uuru17kHskflsn1LWBlkItFGc7c7FM3RljP
         yNnibcKgqCu4WjAaGG6c4isZ79B+uilkmI9YEZJa5qx+ybSZK9nMRJzxRxRCeRNIhWuA
         fTXGFnp5F91EUwy76Gnlay+5vEK4F2az4C8WttulzlsB+VDrq0c2hnsoL6VsfwMR+Y+p
         PhVmLtEGWeulzW9Db67U4hK+aj3aJ1qGkROJRfSu1jJQJU4aqAgfMG41/l8kdySPdb4L
         QZM08T8laY4cKBaz+Szz9g5zNkE5YbReJwaZ1Ni1yy/UtV3JwhBwR2m6yfNwWiNQ3pJp
         LU5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761770653; x=1762375453;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RXmwII94RIU4hvYvWVxvISL3Cf6KBQEXeyuNCmaeDUA=;
        b=i4mrRkkPI24WYByOaRisE2ms/n3Nbr/Ym1gch1p8cfVW6qzuD8e9nCWYsKu8qaJ/yL
         aK3ZenrFqCt1yI7EjsYrkSNGKHaDDEZzNIAanJrccM/FDrzFDJOisd3rqo3jvHVzQNo0
         KsBK9Fjor54EJ5vke2hhNukMG2tOYvrIo6lNDdYdDOGMFO8Bm53sr/kBRmqtIGlmD14/
         u70RK1ol6/p8znpR1TausXa0T5Jq5pOQC97gJfitjhOu5khlrX5iCl6RiXHSx/Pc8Wfc
         6ESNwfLWb6D/XqHwRJAmaVogvbiZgvAWHF+9GQJEvsFwRHUHv6xW8rBC2dLF2C978HMA
         P52Q==
X-Forwarded-Encrypted: i=1; AJvYcCXy6k9yEjh5Hx+2ixTbse2Scoghbrnl1n4LOENS4GwdZFXMCF7xlnM9vTGHcv8V32niNMs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoskVPdqzuq7dq0J2W1IO2zfrujQ3o2vF1WwGp53YHhwYRFxKZ
	TG9V5e5ApyGWvATmUGmqyS6auNOLfTLsafLiFaypohI8I0akAyxlFkMWOFYqtDqE4Ew=
X-Gm-Gg: ASbGnctg2Wl1xQyDFPEZujXn2+KbvluzhJDCMVytsidpE5BZmC6DF1z+BtvcTTVlfpy
	tQ2IN+dT0DVioM5hDq97fVeydePryaK7gSdC5n5p0Pi4XkmbpLZNUGNzC141XlNQls6Z5s2eSe1
	pNlbh6pcxXJyDNkPTTnwd46nbNx1HgbYjSFhNrQLs5n4MVJ6hH2mFEG7B0aHYlcJV3Bn7QNwId2
	W2iV7o4QfQ7XfxuSSBshHnjBJe5KcR0wuUH48cQR0u5LyTi0mrRSs4o02aVTR6TdOyKcf0TvcOt
	vHOSgUB+aJdLJH6eHbUFRZzuOa1r/bieaQS9FEwF4pvLIdlC+JuxvrgtUe8wzkhAbtZEcWCe+MK
	/v7zGjm3B93vRru0zyOotAo5rP3yoJ546CVVF/L2MSwrxF21+Hbz1Bqp2pD8cXdRfu+6XKDazxc
	8ARJoBygf8tBTnNSABCnkVh5kuIUIiyb9YFzhTWLO+gDSbtQ==
X-Google-Smtp-Source: AGHT+IGATc8r8DQBwuLiAP3r8TNXYtoAaZC4C/pNuGjsCGGzvT3LRAi9w0bLz5mbYMTI7xxUZ0KOWQ==
X-Received: by 2002:a05:620a:4496:b0:892:9838:b17a with SMTP id af79cd13be357-8a8e407c6d6mr467678485a.3.1761770653172;
        Wed, 29 Oct 2025 13:44:13 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89f24ecbc11sm1141931785a.24.2025.10.29.13.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 13:44:12 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vED1g-000000053O5-0MFV;
	Wed, 29 Oct 2025 17:44:12 -0300
Date: Wed, 29 Oct 2025 17:44:12 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mukesh R <mrathor@linux.microsoft.com>
Cc: alex.williamson@redhat.com, joe@perches.com, kvm@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"wei.liu@kernel.org" <wei.liu@kernel.org>
Subject: Re: [RFC] Making vma_to_pfn() public (due to vm_pgoff change)
Message-ID: <20251029204412.GU760669@ziepe.ca>
References: <a9b8a3ee-b35b-5c45-5042-2466607abcd0@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9b8a3ee-b35b-5c45-5042-2466607abcd0@linux.microsoft.com>

On Mon, Oct 27, 2025 at 02:21:56PM -0700, Mukesh R wrote:
> Hi Alex,
> 
> This regards vfio passthru support on hyperv running linux as dom0 aka
> root. At a high level, cloud hypervisor uses vfio for set up as usual,
> then maps the mmio ranges via the hyperv linux driver ioctls.
> 
> Over a year ago, when working on this I had used vm_pgoff to get the pfn
> for the mmio, that was 5.15 and early 6.x kernels. Now that I am porting
> to 6.18 for upstreaming, I noticed:
> 
> commit aac6db75a9fc
> Author: Alex Williamson <alex.williamson@redhat.com>
>     vfio/pci: Use unmap_mapping_range()
> 
> changed the behavior and vm_pgoff is no longer holding the pfn. In light
> of that, I wondered if the following minor change, making vma_to_pfn() 
> public (after renaming it), would be acceptable to you.

No way, no driver should be looking into VMAs like this - it is
already a known security problem.

Is this "hyperv linux driver ioctls" upstream?

You should probably be looking to use the coming DMABUF stuff instead.

Jason

