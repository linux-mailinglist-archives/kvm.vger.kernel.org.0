Return-Path: <kvm+bounces-50435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DF04AE58DA
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 02:56:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 630381B66E61
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 00:56:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D0B7158218;
	Tue, 24 Jun 2025 00:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="WJhg3xAw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0B72F2A
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 00:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750726569; cv=none; b=lwpVpDur1GufVqWvwvDZsVgRoV8erof2dReeqOlCnKRCLXVh0B7/VMS3cdDekoS/fIKAyTZFp30frjQxYTpq4vpzm2zZXqPEN3oqdkhKuogS4miXUhhCtrow446FK+qnP7TGLDKg6Vp632/fHxL70kHeGtVowhKkCtT8mdMspP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750726569; c=relaxed/simple;
	bh=7O+ajiUDfZzafBBNiM6e5tJhCUr430Qh1/kaNQGaM+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=drrPAy4ku7NJnRb9XPTCsHkg/EXfznlhAa/FiIiwebCdnwcTwUz8X6WFTktsrZRvdyRxejqddgAtPsLArG3lZj8oopY2COYVUW/kUz8o1ytHoOGxTiEOCD38BBf95aeV8tQWIkwOWJzv9TJ9GwJUooXCW/xvy4dIbuzceeW934w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=WJhg3xAw; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7d38d562a55so629778085a.2
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 17:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1750726566; x=1751331366; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u8pDtojTuV6LFOjfDU1WAEP2YMGFUVnVXeIZSV015Tk=;
        b=WJhg3xAwDnEtmpOKHPAQl9ExlKfP22au9D1+PsZVs5aOzR6wChf5v4eCZjsIToE9Ab
         ScpGHEceuSn6Gtjm0iv3fsHGTgJPjZDj7w7o73tH9DSMR7vfI5tjKgIu2JosoX/n8ZkP
         eUZxpj87u0uyoPuA6IAVDHr9WE9krzPT4LrZz0FuNbRhlkJI0FABQyoNk1w7K5d8iu7U
         v16dPOpMYTrdsozdToA5QzFCfuUt1r5nRX6a2LoYbTaZRAV0PUSeGGlPa2C0hLdh1vSf
         aLv99SUSDpOy+4NiBi5LgC3h/Vg+IO12vlPNBK1hLy/f3C1wpGuJQv7dxo5qPqTDrJOW
         SG0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750726566; x=1751331366;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u8pDtojTuV6LFOjfDU1WAEP2YMGFUVnVXeIZSV015Tk=;
        b=V7yIGIBDBwr3G5Brc/67yrLVSVBTxM2o/kc/X0BO/mPMNQv8ORxhoee2rO24fpwd/Q
         eBpAmNJeJbc/ZPQ3XTJwW2MGnfY48DTWF9kG4Yl1V7AJ+XuuWuBtIm/HiJ9+mJCfIeuw
         mNS7hyBNORdo87N78Aw4nWSOZ3Rls5LPytsFMMeivlSzE6/kL0l4Ri/xE5b1Lp8K2Tgf
         ri2Gity5Q5O8k4Y8Ri6O21ymDG8xNIOJuJtLK6JYpqToUaXH2hLEsMs3ieCgoSy8HqTz
         wYg6cvKsjNnZi50+UrWGc31AOgGP3kRoyancm22fXxtFmKt6i/C4oDe9jkIdKgti4/K6
         +FPg==
X-Forwarded-Encrypted: i=1; AJvYcCXfoRoLP/oMSRErmUY6sVaFLuIK2JAlYtjh0nxnCzCYA0sOFqHH2gamJHFcHWv17StlfT8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyL3+DGAM75YYq9JOc72fGvdla0vFu7AJAlAkCnEE2h1+TXQcSU
	YFguo0xtx+mqXALmEtOayoWKJZmeijVB+qlqCjydywX6qoSMKslW7MSVOH2LKEBlWDm9tIIS209
	UJUjd
X-Gm-Gg: ASbGnctX+LlH56VYiJiP67dpzWTG4JnDfdRpJk8KG9/BlPqGw4hJA7Y6gfdd2Ichxd5
	24sT/qzJI8NyTg6JKqJWh5j5FsJUOGS6KoBR2FDbrBO+4wIGlQ8VUKR+hFtq8R4Gd01S8i+vvSD
	eoaemqfM8aF/wztyKNNSe6KS70JQ5r4LiVJu/HJIJ616ZXyxdHxBGDEd9PS+gDTNCpnPwW7ScLt
	Ft+6cAQ4yKHv0emOF4CGah+wkniy8rVoVL59NIwt166nGKnkddPx174EZ8j7SmjuliePTt7BAfr
	UnaVX6DHE/fatLjOZh37asSsdVKEzewiK8eEC0zQbZx9wMvGhMGjeFzjwgew06gSNVhb3BstheX
	/HulQp14OEpn+rA1ygAp3u2BJm5f/lOcXW4cOwg==
X-Google-Smtp-Source: AGHT+IGX6hq2GvuJ1K/s8jNlp2hlgIbEh4pTewUT8bxyCxJMmW0ogtWNidvI1vHbIFzO1aMASc52bQ==
X-Received: by 2002:a05:620a:3183:b0:7d2:2822:3f79 with SMTP id af79cd13be357-7d3f98dfd21mr1951957585a.13.1750726566656;
        Mon, 23 Jun 2025 17:56:06 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fd093e087bsm51501256d6.20.2025.06.23.17.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jun 2025 17:56:06 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uTrxF-00000000aHE-1Uw0;
	Mon, 23 Jun 2025 21:56:05 -0300
Date: Mon, 23 Jun 2025 21:56:05 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alex Mastro <amastro@fb.com>, peterx@redhat.com, kbusch@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: print vfio-device name to fdinfo
Message-ID: <20250624005605.GA72557@ziepe.ca>
References: <20250623-vfio-fdinfo-v1-1-c9cec65a2922@fb.com>
 <20250623161831.12109402.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250623161831.12109402.alex.williamson@redhat.com>

On Mon, Jun 23, 2025 at 04:18:31PM -0600, Alex Williamson wrote:
> > Alternatively, if we wanted to normalize show_fdinfo formatting, this
> > could instead hoist the print formatting up into vfio_main.c, and call
> > an optional vfio_device_ops->instance_name() to get the name. I opted
> > not to do this here due to unfamiliarity with other vfio drivers, but am
> > open to changing it.
> 
> TBH, I don't think we need a callback, just use dev_name() in
> vfio_main.

IMHO this should really be the name of /dev/vfio/XX file and not
something made up like event fd uses.

The file was opened via /dev/vfio/XX, that is what lsof should report..

For the legacy route this effectively gives you the iommu group.

For the new route this will give you the struct device.

The userspace can deduce more information, like the actual PCI BDF, by
mapping the name through sysfs.

I would have guessed this is already happening automatically as part
of the cdev mechanism? Maybe we broken it when we changed the inode to
use unmap mapping range?

> The group interface always requires the name, in some cases
> it can require further information, but we seem to have forgotten that
> in the cdev interface anyway :-\

?

Jason

