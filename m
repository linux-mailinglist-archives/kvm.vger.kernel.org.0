Return-Path: <kvm+bounces-47146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E566AABDF60
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 17:43:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDC64162F04
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 15:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4857725F98A;
	Tue, 20 May 2025 15:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="chO7zjdO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6631FFC54
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 15:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747755591; cv=none; b=QXGRIVjwM6KHJHtbjlak5f2VuHzY/mGrIGNaqONjsgOmojhQKq/DDsrKRtQALLVDCpR6LmkjUBBLwEzJmbrpY18TpvuF0AlXkmJd3J4Foy4IS8mLMKGfm9Ky/ZFzy+WgKVufILV0kTy1pebNKPJpCJkmhDkLimF3U3kxkOJ/768=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747755591; c=relaxed/simple;
	bh=5qaDz5va7V/bOIPJZLz/3rD4zx13j2tjLgu6z+mJZvk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CDLGGtNMAEasXPLuCb40V8yTEoBhj9LQcOLbD3v6YKoQXda9C00tpYgTYTKMyZFMw8T5N5R6O503llCDVDO6s4HO9GmlharuFWfPm/O6javQjTaiSSiL2DwEpLVHEwpvWh3v8d4BXZajxqgfIg6mUK0HFY6ge627NVyiTRoAVNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=chO7zjdO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747755588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GJ0rFA5ozhMdO1IEpBbuVAQP+phCnmZbFuLhRhdhX4A=;
	b=chO7zjdO/F6SyXs6T5Ry/gOjkIaJ9Zb/MjDToaGC60xKRNaWSy08gNNaO6ivwfFvBuzmXS
	M1ojiq64WcgVL+pmxvdT4oTNC8gwKIHtH9zsbOwpttBvvXKvMSg9UbpQzTKTh3vefuBz0m
	AsgPH+rTPZJCGhg2+DGOkvvUCNv+sVg=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-192-dCBiE-hVOvev9luleGYeLw-1; Tue, 20 May 2025 11:39:47 -0400
X-MC-Unique: dCBiE-hVOvev9luleGYeLw-1
X-Mimecast-MFC-AGG-ID: dCBiE-hVOvev9luleGYeLw_1747755587
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-864456fddb1so97523039f.2
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 08:39:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747755587; x=1748360387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GJ0rFA5ozhMdO1IEpBbuVAQP+phCnmZbFuLhRhdhX4A=;
        b=dalD9b7TvftI64PDhW5tnusHPsCH3HmvleVrprTIcg9TEuWGEvWtaI1ElOHXNPaShi
         rxa+IvWPK9rMHOFQsAqkpFIyDQQZt6nSE+Kskeqe7+yUB11tfgIqkxuFgWsYXFiPZr3c
         SIkTmKQa2WdeeQIVpHiCgIquYt6TDpdvXLjc+lMH1P2e5y9Pblq/sJj0vnLot4pOpgaU
         53vxsr0vaPzVI6rYMg6A0EKrjKdRVRyWZ9IW7kNgQ5e43kDjeFadPtN7/psuy58huz0g
         4KitREnstYX8itlyzxPngg+4YRQ88z3y4KhDiCnGjH2wFizzxtnSjl/mt0cABAuDYNBz
         zv1w==
X-Forwarded-Encrypted: i=1; AJvYcCVMby9AXSrHdQaxoY4hWGt/oMvFgyX3uk9Dt643DxQe4QGvXGFQpGt43tB7QkGCCcaBZ5Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5CcaLhYccNoj63SaTtHQe0xRL2gfoLaXUqaUv+bL7Wt0Z5XO1
	IiBDz06EP6QiOkkD8GCe4RHPoqA5339LWMUmhr9cM4TxrU4lWNvzjyn2LPvcKQyRelC9zRZDstp
	ARrvKbJtyocInqcU4sxs6hbl1ESUprXPHNPNL54ZdtxjhthiGoe1oAA==
X-Gm-Gg: ASbGncuw3DHk3Qk1H1lH+ID5hbxqoi+OR3Zq1hLUAxiRdumEGyhdNRqVdznJ3WK1ord
	+2+mpJorWSvAeyzVAujPdB9jfj55lsgRxj74OkLmsSScVWLgDHZsTEc9qHFrumepkEsZ62ykFYc
	t4ir02sTIvwCBhF+6tKOZ9pfF1Z8yCyLsCcnup1VXXZvV0pHRxi9uD3kgEdVt5xgCe0++fiQHOk
	ht3vA/2noHbcE024pSRNUc+tBWJH8+3hQ0QY4uqSfyLE7PSRi+DXDR5ISrsUtqsWjHTPNfmT1zi
	HFhfoPJLCcyzaFw=
X-Received: by 2002:a05:6e02:4515:20b0:3dc:757b:3fa4 with SMTP id e9e14a558f8ab-3dc757b42a2mr12610615ab.7.1747755586650;
        Tue, 20 May 2025 08:39:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG3VbHHu3m+p8uONX+1ieaFf8GcikTyFLsLmu7hXitJ8VoWNtERX8CvL4Yw5GgMZaX+kUid8A==
X-Received: by 2002:a05:6e02:4515:20b0:3dc:757b:3fa4 with SMTP id e9e14a558f8ab-3dc757b42a2mr12610565ab.7.1747755586291;
        Tue, 20 May 2025 08:39:46 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc3b1a96sm2298549173.51.2025.05.20.08.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 08:39:45 -0700 (PDT)
Date: Tue, 20 May 2025 09:39:43 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2] vfio/type1: Remove Fine Grained Superpages detection
Message-ID: <20250520093943.05bbe2eb.alex.williamson@redhat.com>
In-Reply-To: <0-v2-97fa1da8d983+412-vfio_fgsp_jgg@nvidia.com>
References: <0-v2-97fa1da8d983+412-vfio_fgsp_jgg@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 14 Apr 2025 10:46:39 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> VFIO is looking to enable an optimization where it can rely on a fast
> unmap operation that returned the size of a larger IOPTE.
> 
> Due to how the test was constructed this would only ever succeed on the
> AMDv1 page table that supported an 8k contiguous size. Nothing else
> supports this.
> 
> Alex says the performance win was fairly minor, so lets remove this
> code. Always use iommu_iova_to_phys() to extent contiguous pages.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 49 +--------------------------------
>  1 file changed, 1 insertion(+), 48 deletions(-)

Applied to vfio next branch for v6.16.  Thanks,

Alex


