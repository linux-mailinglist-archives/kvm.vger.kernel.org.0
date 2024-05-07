Return-Path: <kvm+bounces-16892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 645D48BE9D1
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:55:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17B431F2237A
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A31538DD6;
	Tue,  7 May 2024 16:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="LPTpxEu/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FF0C148
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 16:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715100894; cv=none; b=DeDHlosBJqtcD/gfbzyoBzbivMhX4GlMvvVFXVd1Z73UMvW/x1gQqXB/+QWm3Zls8wB3pPPfw94pdWfNxvz2QJclwYU0LeGrQFnnqZUVkkqjQ/ZMd0W7tQTpBmXyu55gAWIKdr226n3tARF26RgPUqosQd27tuSvIwz8E5RKWv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715100894; c=relaxed/simple;
	bh=qpL7mrChMH7iiYyuJ5+LEbL3MTJsN+KBRA6txOCFD6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XFfWTbbWgQ+upqZtVk3IL7MZtiu16ee9MXRfnA6y6t6mhgw2GmP9qnY7Xq0C30w5mXzzTtWN2x1bEsDZfIlhYHiUdJeNHx1MLgxV0vYyLKfw/VUI8Fx4N3OcU/9zFwMDPj2kjq/R+/9lmszGeQlc+x/Ywll2B35L9yuFpJ6FwvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=LPTpxEu/; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-792940cc66eso222525185a.0
        for <kvm@vger.kernel.org>; Tue, 07 May 2024 09:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1715100892; x=1715705692; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hs91KlgKHS6Ryk+5UHzlM+ht6/94snYgy6BHXDz+jUk=;
        b=LPTpxEu/Fb+QRbtNflP03E5gusFXmrm3wDh+bMhVPvWtlcxCQ9R/g7NRiUAEREYUyu
         yOkf5eiDW+I4ch5ioSk6ni/CdShlHKeBEe26Yz2iU+iMkDFPQ3Mn7mwdY3RnVdXR6c1m
         X0IK0j6ZuhA3h65L8tK8M+zZpHTEl2bXkvsbdEg6MMd9o/vb6oUZt+5CWMGcxP+DiBYS
         qk5fAcJgueHBHJQBD41oFIiwNFbzyUDNyb5wbefT/Lea07FD5yBKpRvMBcSXeKz0KuDX
         dzWbYNNWDTAdQ4YtsoElueVqpkvvI0TJTpTZz/9dGVOo7vKyEF3Ieg7Pb0Rs1sKzjs/i
         qC0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715100892; x=1715705692;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hs91KlgKHS6Ryk+5UHzlM+ht6/94snYgy6BHXDz+jUk=;
        b=ED0mhaK5OHs7bbgBfoIJVBoUMM6NtP7OELSJfuVxnblaN8CBPIdWqAnb3GRjgSMhgC
         7gP0d4tved0dYTX0185HV+/3EhZ3NjtfSu8jdtmYzzma7vzCi/VRln/kbvjn0KuQlkal
         RVzM1NT+9+XtrJOjzZH6qceSRRCg53G14yIsSfPAJAy8S2TWDMlVRP/3UfgGVaizROe0
         QDw/tRAPR43XLEkTNhDsGqeLhuJv22KWnNn1cz+HxywpVTF8NpVubEvwdJWTBnfeGaYb
         b5JXS3TzksrRzST8pnqqds8y+4VOjEfs7vQ0IoTwi/LMYLXJn+2BbdB85XLLGa4v1l+4
         IfIA==
X-Gm-Message-State: AOJu0YxCBVU3G/y7T+fsyz2RB5Ku6A+uxic09RJIrRTzLE785vKqtrNv
	AlQzF9c0KGTZeyvupTB0NF0Zghnm32wzgb7c2g40Cb5IPDywNP8U9CCOaLkYy3Uv2rCe0mrJ5HS
	N
X-Google-Smtp-Source: AGHT+IHlD+3EgAUHX0haSzd9vw8MtUGK2hO1IVfJXLZa0KHjmeG6nzVKMJrSdVzvJ2zmH0Bj1gzshA==
X-Received: by 2002:a05:620a:2a11:b0:790:f382:23ec with SMTP id af79cd13be357-792a6471d76mr501947985a.16.1715100891854;
        Tue, 07 May 2024 09:54:51 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id x5-20020a05620a0b4500b007929602e42asm2426537qkg.96.2024.05.07.09.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 May 2024 09:54:51 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1s4O5a-0001dZ-V3;
	Tue, 07 May 2024 13:54:50 -0300
Date: Tue, 7 May 2024 13:54:50 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: Collect hot-reset devices to local buffer
Message-ID: <20240507165450.GI4718@ziepe.ca>
References: <20240503143138.3562116-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240503143138.3562116-1-alex.williamson@redhat.com>

On Fri, May 03, 2024 at 08:31:36AM -0600, Alex Williamson wrote:
> Lockdep reports the below circular locking dependency issue.  The
> mmap_lock acquisition while holding pci_bus_sem is due to the use of
> copy_to_user() from within a pci_walk_bus() callback.
> 
> Building the devices array directly into the user buffer is only for
> convenience.  Instead we can allocate a local buffer for the array,
> bounded by the number of devices on the bus/slot, fill the device
> information into this local buffer, then copy it into the user buffer
> outside the bus walk callback.

> Chain exists of:
>   &vdev->vma_lock --> pci_bus_sem --> &mm->mmap_lock
> 
>  Possible unsafe locking scenario:
> 
> block dm-0: the capability attribute has been deprecated.
>        CPU0                    CPU1
>        ----                    ----
>   rlock(&mm->mmap_lock);
>                                lock(pci_bus_sem);
>                                lock(&mm->mmap_lock);
>   lock(&vdev->vma_lock);
> 
>  *** DEADLOCK ***

 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 78 ++++++++++++++++++++------------
>  1 file changed, 49 insertions(+), 29 deletions(-)

I feel like I created this bug...

It is sad we have to allocate kernel memory, but can't think of a
better option.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

