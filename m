Return-Path: <kvm+bounces-33419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E6509EB26C
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 14:59:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CC06289BB4
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 13:59:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24E5C1AAA1B;
	Tue, 10 Dec 2024 13:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="BCNxEF3M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3EC1AA7B7
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 13:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733839109; cv=none; b=ZmUU+KdWTg9SJBtkP0UBjct6CmhsfA2WZCLKi58t0zxfMNGnMH5bHd2YxIP2gJF4AMIWBsu1SGWd0VYbcVjovcIijNuHNFJZ0w1dCcZB0bj5QdhHTpXU239vk+VcXwS8hIt6TqylyO3E4IfqWe6qVB9amwH73YYLSx6pCNQUH/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733839109; c=relaxed/simple;
	bh=Wus6PTVVywKwLtxZ0EhZyXK0M1Oufs2XnqpD+8KgydU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kROeAmfwR4q27N62hTvRB7NmE5XCppsbg5a5uumTLZjsATBsmn5Z0nH+PIDtR/ZXWEnVOnC2ARR5OIEOX0Al51Aw6YZVw9P0OWJJsfQBiAQhMznNjoZaQm/avF1nsDAeda/KBynaK/kp9KzaF7K3ogNeO/98mZZei8SxbQ6QKt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=BCNxEF3M; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7b6e4d38185so32549985a.0
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 05:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1733839104; x=1734443904; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cPnoeJGC4S/+isJNT4aLkrLE+MbFACDHEAIE5X2EVic=;
        b=BCNxEF3M72Cr1/GhG9QWaEpnCg4GdG25ekoIXvawtohpZ2u+gEreHJWMCjPi4duk5f
         3fa019qhyrkxqRS/SQQXg7ysWA1v5GUU30FjHw5XzjsWRquTt0H7ZVilMruuC1Ump7ou
         tz2ahMTh2tMbyaU3/uWcNbDCfRMGWGwgHIs88s3877gVavLarCs459rS/9gwnFjRt31O
         x+WtWTe7/HPONip90Uy70SZZ6pAzgXu7bT+N3LsqsQGBh573BT8Sts4fQh57N6iMGEC3
         KXShjFpugPgBgtt1dsF/sTi8qnOptYN0KKh0uPZo32GVK44nxZloUvvxPytw2ZYjjc9b
         29OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733839104; x=1734443904;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cPnoeJGC4S/+isJNT4aLkrLE+MbFACDHEAIE5X2EVic=;
        b=tQOsZ0bQ7y9NlMlDh61t3JHVKM4G5NkTJHlM+JIsn5ZlHq+nLjyRCoolkT7t7rK9Po
         VC0iWvRh+vNAz83oC/CgmghjIlz8TdSpn1cIoU8iYS9W2UZ/uhh83I7/AI9KX+JE2kjo
         a8d8txhD9YUY1MpXVQQmbjYqcUm+K4TbW2GZcfbDJ3zq8ZGVSRxM5JD1/b6kNqoJhZBk
         MMYvPHyVJRxC9Sy6Y8M36J1zqeVDQlZ+xRSm77ni6ll9Z19ORgVeMyo1KO4bekr1umCC
         qSQWJ6TM4Su3JnmI05qyNHmEEnZeC+67YsPISvvFfXuxE6jlz6u9J227BYb6S+7ekIbN
         pMcg==
X-Forwarded-Encrypted: i=1; AJvYcCWEPGDdqailQh1FV/QoCLrrrXzsStx3f59h3NUctTAyQjhX0xVUr0DO2jr3mq6Be1sRsjY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeUTZ4YR1qgJ6F1t7/r3ARKEJq2X9xfM3kHYOwyKR+IXNv11fc
	nwMnnxj6atqKaHUSgGCFvd/iPd6NJ8Uy9rkF5dD5wUvQIzYjwekufej1RFnD66yDOQMZlPVDlBD
	h
X-Gm-Gg: ASbGncsELyrrrmr/aJeU5UC/i9fvxlgOM0AtcLazxoGvLIkHZ+V+0ULXhyNB5v6H4cN
	/03ZpUd36VUPZdUgkp+J/PBG/LHBHek36zcUrZHyQCWfAQulGzttKe/aJVkOnWlQ7+KMNS3cSh+
	1amdXS1jlkVpFJ07hA3cOkCEgyxvdsvnGD5JcOG7hBfEXX+lHBVEWUkmML1MPO64dWeEczo/moI
	8xfr0dP3jW1WAJR4Q9xiyH9FkjZaYo4gZ28hAoa0d16Wsbfiks7Q5/Y0wD+d9uNkJHlBUTHUy4O
	dVVpAxtW6KDo3t/yAw/lFeK2H9U=
X-Google-Smtp-Source: AGHT+IHCnaEPp4CpRU8sWpIALCYJ9lPsx/4FMzmUmHystykqZf/cdX7zqBlHRWE8kGoyRP25rAtzdg==
X-Received: by 2002:a05:620a:1a1f:b0:7b6:cfa3:c685 with SMTP id af79cd13be357-7b6dce5aa7emr703714685a.23.1733839104407;
        Tue, 10 Dec 2024 05:58:24 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d8ef223d18sm45464336d6.99.2024.12.10.05.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 05:58:23 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tL0ko-0000000A2D4-440E;
	Tue, 10 Dec 2024 09:58:22 -0400
Date: Tue, 10 Dec 2024 09:58:22 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Ramesh Thomas <ramesh.thomas@intel.com>
Cc: alex.williamson@redhat.com, schnelle@linux.ibm.com,
	gbayer@linux.ibm.com, kvm@vger.kernel.org,
	linux-s390@vger.kernel.org, ankita@nvidia.com, yishaih@nvidia.com,
	pasic@linux.ibm.com, julianr@linux.ibm.com, bpsegal@us.ibm.com,
	kevin.tian@intel.com, cho@microsoft.com
Subject: Re: [PATCH v3 1/2] vfio/pci: Enable iowrite64 and ioread64 for vfio
 pci
Message-ID: <20241210135822.GE1888283@ziepe.ca>
References: <20241210131938.303500-1-ramesh.thomas@intel.com>
 <20241210131938.303500-2-ramesh.thomas@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241210131938.303500-2-ramesh.thomas@intel.com>

On Tue, Dec 10, 2024 at 05:19:37AM -0800, Ramesh Thomas wrote:
> Definitions of ioread64 and iowrite64 macros in asm/io.h called by vfio
> pci implementations are enclosed inside check for CONFIG_GENERIC_IOMAP.
> They don't get defined if CONFIG_GENERIC_IOMAP is defined. Include
> linux/io-64-nonatomic-lo-hi.h to define iowrite64 and ioread64 macros
> when they are not defined. io-64-nonatomic-lo-hi.h maps the macros to
> generic implementation in lib/iomap.c. The generic implementation does
> 64 bit rw if readq/writeq is defined for the architecture, otherwise it
> would do 32 bit back to back rw.
> 
> Note that there are two versions of the generic implementation that
> differs in the order the 32 bit words are written if 64 bit support is
> not present. This is not the little/big endian ordering, which is
> handled separately. This patch uses the lo followed by hi word ordering
> which is consistent with current back to back implementation in the
> vfio/pci code.
> 
> Signed-off-by: Ramesh Thomas <ramesh.thomas@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_rdwr.c | 1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

