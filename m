Return-Path: <kvm+bounces-54022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DB7ADB1B691
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 16:31:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D47F1898821
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 14:32:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9165277003;
	Tue,  5 Aug 2025 14:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="UNvmmk+N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608F820F067
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 14:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754404299; cv=none; b=nCwhRkZa12WxcBFKl9rJEz42k3/lqT5GPvo4bs7Z2nWRDbsm5OYP+mciDrBXVYd0lp8UEyohXIq8pQ8XAmFn5ikl/bKqDxnTvjtD0VNAYejmN0hC+ZBBPqOx+yCkl1ds7Ow82Y5krZE3Yzx4VypcmyR7ZMXLdWhZYvRhclBVHsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754404299; c=relaxed/simple;
	bh=ELWmt2XwMrmxJNrnM0cZ7Lq7yZpEkIkoITwQJHoVNfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gTKuSEC4X6CA5nV5aVJfYM1UYyBfYIk6QNcIGrDNe2va+hTaxd2IU6vCxeH9jp1l6ka7Yu4FIP1Xn6e4ZYvwsoFfYtNFL1nKDH1bvcP1ysGHIcNu34i3NlD6+2q8mOogIqo7MOCYvr+kQJHM3QPpeEYmHdDhKcAG/jXlsYp2eUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=UNvmmk+N; arc=none smtp.client-ip=209.85.217.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-4fe7712bedaso2713867137.1
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 07:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1754404296; x=1755009096; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AlTuO/1jl0Qi/PGEdwZcsjPXQoMzQczvkbA6fBL4pq0=;
        b=UNvmmk+NfdH6jvovyRTWVfUkwwWw5derxEUJkj65BPMqcE5QY1thpOL2xYoR9xywjF
         R8RtYiO+zL70P2RLqwBnlmCrMOB2nDEIIjLt7sk/OPPTlWSP/jiSS7qeUdUYpeLW5LYf
         dedfbeZr5wjRbVdY5/s1bgZVVEm/DWA5McjoPFX0veDeOp2zJCF4HYCXyQexdbRUc7g1
         c6GIgeWJJ2+BjTjAGgBqbi/Y381G2suje1B1AdmDxYvQRa2Cv1MhVxqI3O+tdE9WlPnq
         5hkmt07XH3NCzCGmv5Kac55f+m5umBH1IGphE9wrffRimix6EMAnzSPDP+ka6MTeJE5E
         nG7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754404296; x=1755009096;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AlTuO/1jl0Qi/PGEdwZcsjPXQoMzQczvkbA6fBL4pq0=;
        b=tEE8q2fvAgMVN/Yu6PJsQItR9SH6O22N5qzMn1QoR3TaWgB1rCBzEZ0w27l3g0JFnt
         zmf9Grq1E5DbWoW2ciaS2HOIC4s9ncUiCYMGZkrA0svzE7ZPh19YrrkXQ/attD0KQoFf
         Pw3X5we2KtSAW2R0hgMHecbzwYLFj1FRbbUUpNSGxQDZtGRY4tLqvsQXB3/FlJzILAyh
         QYDmB2Dj0PBkgNU6xfLFeDRIGX9k4gc/j1lOPEV1s1FQGiDtWSirdJachtK/EcuvbGF/
         RHrH7WiQzCgz8wxb+F0VigpxiGN9bKfMeBmUWAnlRX+92ViyrnLke/gLxoRlrU6/MO5K
         Qe7A==
X-Forwarded-Encrypted: i=1; AJvYcCWa8SXh//ero1fvLvajlw0KVaaAYIoLAL+RBHszjaoWZWGhXqpnUVIcOO4u9yqEayjhxjo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBmS6AhcTbcgI/tEXn8nlRMFPU0yURM90l+EE3/cswSU7YYglM
	kknTZCEiQh1pUIzCW5jX07GEz/n228Z1BOIT6k8Y7vAEROI5EI84q+kus/h6Y0LUv34=
X-Gm-Gg: ASbGncuPaoMYVe1ZnTowPO/maA5RWAa3SlC+oyJ1aBb9F1kH7zhGT+iCSLs1QJhCV/G
	xjJ/2lPT4RfiZvrVQ8HIC6OoeZCRiPN11iBiARsec4lBR4kcx0rXE5KpIXKa4Kt7qaxj/AiJjgj
	05CCEP2oDRvf0fBZqIZCRiaJpP9LoUBo6eLJP58Y7z1bLT/Y8ZP4+mIkAzyTYOTOdk+z7fOHP/2
	zsEuev7aPBnTl/o7J6NHzfdhnxVrcJ1jmTDdurr8kQNi/8rU+I+9smssYd8E4Z5fsqbDJ56fKnR
	RoPFkZXM3+OUiyF72GffwdXbh1LB1Xivs6OzETFp4lAdsXH5B+aHMLZIktpBvmxWwYZgE4wOZKC
	zNKNJ3p0RFB7+KEhu8T6K7bA++V2gf/z0zMPeXkc4vTwx7OlqFrqsLXreYKV2tBrejttp
X-Google-Smtp-Source: AGHT+IHTrZpqFhNaYWp3OobLHpG9cf97WOXgGFMv9akibVpld7o64cnS8mrUbOUHDIlr96qDRpMuFA==
X-Received: by 2002:a05:6102:4244:b0:4f3:1731:8c01 with SMTP id ada2fe7eead31-4fdc3f1c0dfmr5906902137.19.1754404295882;
        Tue, 05 Aug 2025 07:31:35 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e810a63e84sm51489085a.5.2025.08.05.07.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 07:31:35 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1ujIhS-00000001Xjk-307T;
	Tue, 05 Aug 2025 11:31:34 -0300
Date: Tue, 5 Aug 2025 11:31:34 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mahmoud Nagy Adam <mngyadam@amazon.de>
Cc: Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
	benh@kernel.crashing.org, David Woodhouse <dwmw@amazon.co.uk>,
	pravkmr@amazon.de, nagy@khwaternagy.com
Subject: Re: [RFC PATCH 0/9] vfio: Introduce mmap maple tree
Message-ID: <20250805143134.GP26511@ziepe.ca>
References: <20250804104012.87915-1-mngyadam@amazon.de>
 <20250804124909.67462343.alex.williamson@redhat.com>
 <lrkyq5xf27ss7.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lrkyq5xf27ss7.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>

On Mon, Aug 04, 2025 at 10:09:44PM +0200, Mahmoud Nagy Adam wrote:
> > We should be able to convert to a maple tree without introducing these
> > "legacy" ops.
> 
> This technically be done directly by changing the current ops (ioctl,
> mmap, read & write) to add vmmap argument in place and call the ops with
> NULL for vmmap entry if the entry not found in the mt

You have gone very far away from my original suggestion:

https://lore.kernel.org/kvm/20250716184028.GA2177603@ziepe.ca/

map2 should not exist, once you introduced a vfio_mmap_ops for free
then the mmap op should be placed into that structure.

ioctl2 is nasty, that should be the "new function op for
VFIO_DEVICE_GET_REGION_INFO" instead. We have been slowly moving
towards the core code doing more decode and dispatch of ioctls instead
of duplicating in drivers.

I still stand by the patch plan I gave in the above email. Clean up
how VFIO_DEVICE_GET_REGION_INFO is handled by drivers and a maple tree
change will trivially drop on top.

The basic way you've used the maple tree here looks plausible, but I'm
still against some VFIO_DEVICE_SET_MMAP_ATTRS as a uapi. mmap cookies
should be immutable, once they are issued they are for a certain thing
and never change.

The entire point of all this infrastructure is to allow more mmap
cookies to be issued. The new UAPI should be some
'VFIO_DEVICE_GET_REGION_INFO2' or whatever that generates an entirely
new mmap cookie with write combining semantics.

Jason

