Return-Path: <kvm+bounces-61711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32CB9C264DB
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 18:14:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F6B43BF6E8
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 17:09:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D361C302770;
	Fri, 31 Oct 2025 17:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="AC+KR0IZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1D92FD692
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 17:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761930540; cv=none; b=tF7HANa/y40fswYtWQiV3+r7wHh2nEKFM9gWVrJ5ImmfTBG9MlrTwNWfUcnFxaxE0Oz0MmxzyWLMNuODrMdBCcnr444nsJjUmKMSAa52kjQeJQGVHc1JnrZnzGiCLcQqw9Q3zCGQl5ghUVNmRfeVOE4IkM7aFZGkfnRTIL+dnZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761930540; c=relaxed/simple;
	bh=+i8ZQoycELSQ103UOhO+mdZBcfAiIIrnA4J6dDV9Rf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gCE36SNt+w1qpm90WHWnv6FovF5y7SRI4Y0LKLfHx7iJbw3cdp6TtelWib7hpNJSDAxLavXYXvtgByALoImImeD6Xth4G9priYacNzo48GFM8CM+XnS8mKSRm82x3sRECWBmhQuNqqF/K1lCWj9r0ocD0PQSetFSbU/uztNbv+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=AC+KR0IZ; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8803da4b369so8657766d6.0
        for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 10:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761930536; x=1762535336; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RBTAuVS/sQ3VXQZHeQmZFPYxDEAuSifyHPnjgyaRJZ8=;
        b=AC+KR0IZfRGme+akB6A0fwMMIQFg4vdjSSOMlJbqdk89PL/G7m1abGKO7O/6hIwq2J
         ApoJ4nvNKi+7RiC8ivdrQmFmf1UIG5GKipNYB2rRdynzkZTiwHfMQc11KCvmGM8Bf4He
         9uDU3pVbWOqDYu2TGuii3C8aEo9/VxlIRDkwTFlQYxvbs4jXeU2rY4sh1FdDb7xJrZTM
         CHj3XQqRBsAPplzoGnUO3HovhH3Igw7CMCGZ4H7hCZ2zDpfVEVVNefvEUkNUZekneX8A
         SxpGEraPvKN7JaO7GWIhi5dAIkEX6or2y8OjNFViWkx0yU7wK8o04uQN6p/yI2qGOVWS
         BIqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761930536; x=1762535336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RBTAuVS/sQ3VXQZHeQmZFPYxDEAuSifyHPnjgyaRJZ8=;
        b=VhKSjwesoGjCuDNTcPOm91vDJzwH/rrZUgQ6WsIyEGW382+YDKypykOJ76C3d/0PB5
         nfFvh8LIb5b/oInjqFtQOGMDiS5/VBT71NPVkYSTXKwYTSZu428YQBqhm+qiosm/ObJy
         UP+rUw4/Tj+2kxciBghRgEdib6QmuSnlT27pMbDJluNSLTROuhf1McWb+BcjoAP4VqgU
         BPzQ/eHoW/7lKNN6yiG33omntFPKXUoJc3VVDmdW6Y/dYrW7d0Vtz6m6/sPZkDQwsHn1
         0EesZYYShP3QyDVDerZO/Up4C7cAadDIgKKVa05m1A0kxPDJnxPRyYSvBAixW1/JkyjO
         8GOQ==
X-Forwarded-Encrypted: i=1; AJvYcCViATjIZQhqjkfgsKn8U+/07XDsKCRL9tElDtTLtX1+TsYsqK1BhVnx3neQxYSaQK21e2c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKS340WglDYW1vSaV+rviWYzBKK+RIN9KOfQo/7mGs3Ppja8Jd
	2DcpcE6ir1rmDsjbRRlcCH1joUT5MF3XfVfkb9hcXm/UOOuzi9lRxTFvNp50iMe1WGM=
X-Gm-Gg: ASbGnctYnYHDldSXL/lNI+1WP70qMiSRvo60RR2SO7IoGzc1v0uNa0bDVPZ/Dqgbk64
	Ly7/4UUePmCqSIslD4vnJoO7IB6F5WxmdNYXvWAAujliOgsp4B39Z5RRr0I8YcW1gUs4+yLqwOD
	XTiHdGKCyleJYASOwdfc4Q5trfGBblpgQuz9rrhj2Zd5zRYjZzuwZudGilG01NYzJP+lczJVoZn
	SYmsfT3jmLZ1nXdc7pXViqhk29hemXhgicowMKiakTiB1X97X3yfxSn8bTE3JrsVZZ+TMkgKyMp
	bTlauweEi/LvE+/gpmVvXn2DwIMd2W8dqkhGOjUoGPfVUdy39QFvO1+KH74E4ivbhgOD7ZwR0Ei
	/m7v6FW1uSTgJC8DFu4kXRNx42bXTy/lmo2V/DlxIa9paHI7k8NjtBWLv5jSvAhGCszjY5Zmu8y
	2c3GgQ1idMGtuB+d1M3fN2PMx+MS0hvhNbI8PERqSxrSKp4w==
X-Google-Smtp-Source: AGHT+IGG5ZGx6z+RQHh9WYWUaZzZke4tiLtpbh29MnMDJ7MHc4q2Mxi4KBypDwpLY9ZKti48DkZCFQ==
X-Received: by 2002:a05:6214:246d:b0:87c:16e7:892e with SMTP id 6a1803df08f44-8802f4ea951mr56300486d6.62.1761930536323;
        Fri, 31 Oct 2025 10:08:56 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88044879326sm2392456d6.32.2025.10.31.10.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 10:08:55 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vEscR-00000005mGA-0THn;
	Fri, 31 Oct 2025 14:08:55 -0300
Date: Fri, 31 Oct 2025 14:08:55 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Longfang Liu <liulongfang@huawei.com>,
	David Matlack <dmatlack@google.com>,
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] hisi_acc_vfio_pci: Add .match_token_uuid callback
 in hisi_acc_vfio_pci_migrn_ops
Message-ID: <20251031170855.GE1204670@ziepe.ca>
References: <20251031170603.2260022-1-rananta@google.com>
 <20251031170603.2260022-3-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031170603.2260022-3-rananta@google.com>

On Fri, Oct 31, 2025 at 05:06:03PM +0000, Raghavendra Rao Ananta wrote:
> The commit, <86624ba3b522> ("vfio/pci: Do vf_token checks for
> VFIO_DEVICE_BIND_IOMMUFD") accidentally ignored including the
> .match_token_uuid callback in the hisi_acc_vfio_pci_migrn_ops struct.
> Introduce the missed callback here.
> 
> Fixes: 86624ba3b522 ("vfio/pci: Do vf_token checks for VFIO_DEVICE_BIND_IOMMUFD")
> Cc: stable@vger.kernel.org
> Suggested-by: Longfang Liu <liulongfang@huawei.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

