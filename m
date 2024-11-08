Return-Path: <kvm+bounces-31328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71AFB9C26E0
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 22:01:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 317E52844DF
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 21:01:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 079261F26C1;
	Fri,  8 Nov 2024 21:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jEoDmuUL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE101A9B33
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 21:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731099690; cv=none; b=GRDHp9BRBXY9c3S9AabHQUng7KAXIldbpOCIQp5YCn4ttIloKSZGBWex5HNrz9K6+fVzh1MsrlsBqvO54FM+8s6dxilHcOwJ5mJA8/Gya8fGtOuQSI0YC3YVwnpfMv3SxdDRHNA7rL/QP/1kr5WbLR7IZwFHt1a5FdlrKDICe3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731099690; c=relaxed/simple;
	bh=VDBbkVz7T2RTxe1AH3XRhRFcEO2Wl5d6RIbEYH/izOY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IHZVRASLiUj6DVqZ8AUVOfTsCm+tV3JWBL166a7h+N4vWs1vNbSEHpdQTiFau5pr1gz+6wRnQbTd2IcteuLYYax3wuY0XDNcwFXfoTBnikruGOId39u7g7geshWJl8FulPIfIIfD0NvjjxZvfD61XQEWMz0/xPN1J7i02JI6dTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jEoDmuUL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731099686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kimPDf4rDLcQh3sGbwpWiBCPrIwWEalWkLN0T0v4qh8=;
	b=jEoDmuULbVji1YSl7br82xPBldsOceOEkEknV/+CX02J5hw5QDD06qOcTHeGeBd7aQ7yxJ
	5WQTQZ0yPtrrP1rDNrBaJQVvNViViXewXmJ0UNp0BSUYsT/hElGzap/rKPopXYCMCtxvYG
	dx/IAHqq1YXrHz2m+1X9d2b9YjWMlKk=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-498-OHL62V27Mtmexs6Hs5PpEA-1; Fri, 08 Nov 2024 16:01:25 -0500
X-MC-Unique: OHL62V27Mtmexs6Hs5PpEA-1
X-Mimecast-MFC-AGG-ID: OHL62V27Mtmexs6Hs5PpEA
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-83aa8c7edb7so43258539f.3
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 13:01:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731099684; x=1731704484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kimPDf4rDLcQh3sGbwpWiBCPrIwWEalWkLN0T0v4qh8=;
        b=bZ8sjKNUBAW+vdUk1pwGc165NTSjL42TSxIv+WimFoHfZhjnR8DPgef+wJu5E2L8FU
         3VhRXn2/mSUYAeWcgCXsUcmu61pf2neYoQNwq7zlP5mgUjMlShMQmXTSDD7TvKIcunsT
         DjxL3vUvqLhltBCBfHXeGRLo0ilI+wWxAR+riYFPP8eAFDKghCKV9NbJyH7dFUl4lOK3
         +x346c4uoCk6ECa3jbSlC9/rUk2p+rrZmVJP/pttLQdS2nE8rbqDvrrvB7n0YG7Ehmuz
         cKcQj8l7D3cmkx4wXLFTTjFC6Vv5OHfW+eQH4EfAICb0ffvgxN7mhBtY3SrdgRUKx8Jt
         MV5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWO9q+Bm0VkyLB1OektVxBGIwwd2zYc90eMSLQbbUmqAL5++61IbnjYeIOWubSDSo0c+yA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHavsN9vhInOBYGwks5pkxt5VmH21I93EWqh3hpHLmfrkuioB/
	O6GcnQlMFKq7yzDHEpNfTQl5GSDOI3DPIqCUtZpPuRabhb7AjbYbhBLM4w5VdIdxrnZphKDZCca
	7dmhmKYM54+tz7nko3/iQSWG9TZ29rkWe0Twl4C34hgpylf/XZQ==
X-Received: by 2002:a05:6602:1550:b0:83a:e6b2:be3 with SMTP id ca18e2360f4ac-83e03078700mr142694739f.0.1731099684319;
        Fri, 08 Nov 2024 13:01:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGYC+igGRtK8/3QlUfGuT32tq/ShwHiJN1Q3xo+UqZRuBVIQpMGWi7EzsrfF7s6NSiJw+VE0w==
X-Received: by 2002:a05:6602:1550:b0:83a:e6b2:be3 with SMTP id ca18e2360f4ac-83e03078700mr142693239f.0.1731099683826;
        Fri, 08 Nov 2024 13:01:23 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83df503d503sm99452939f.18.2024.11.08.13.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2024 13:01:22 -0800 (PST)
Date: Fri, 8 Nov 2024 14:01:21 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Longfang Liu <liulongfang@huawei.com>
Cc: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
 <jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: Re: [PATCH v14 0/4] debugfs to hisilicon migration driver
Message-ID: <20241108140121.1032a68a.alex.williamson@redhat.com>
In-Reply-To: <20241108065538.45710-1-liulongfang@huawei.com>
References: <20241108065538.45710-1-liulongfang@huawei.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 8 Nov 2024 14:55:34 +0800
Longfang Liu <liulongfang@huawei.com> wrote:

> Add a debugfs function to the hisilicon migration driver in VFIO to
> provide intermediate state values and data during device migration.
> 
> When the execution of live migration fails, the user can view the
> status and data during the migration process separately from the
> source and the destination, which is convenient for users to analyze
> and locate problems.
> 
> Changes v13 -> v14
> 	Bugfix the parameter problem of seq_puts()

Should we assume this one is at least compile tested?  Thanks,

Alex

> 
> Changes v12 -> v13
> 	Replace seq_printf() with seq_puts()
> 
> Changes v11 -> v12
> 	Update comments and delete unnecessary logs
> 
> Changes v10 -> v11
> 	Update conditions for debugfs registration
> 
> Changes v9 -> v10
> 	Optimize symmetry processing of mutex
> 
> Changes v8 -> v9
> 	Added device enable mutex
> 
> Changes v7 -> v8
> 	Delete unnecessary information
> 
> Changes v6 -> v7
> 	Remove redundant kernel error log printing and
> 	remove unrelated bugfix code
> 
> Changes v5 -> v6
> 	Modify log output calling error
> 
> Changes v4 -> v5
> 	Adjust the descriptioniptionbugfs file directory
> 
> Changes v3 -> v4
> 	Rebased on kernel6.9
> 
> Changes 2 -> v3
> 	Solve debugfs serialization problem.
> 
> Changes v1 -> v2
> 	Solve the racy problem of io_base.
> 
> Longfang Liu (4):
>   hisi_acc_vfio_pci: extract public functions for container_of
>   hisi_acc_vfio_pci: create subfunction for data reading
>   hisi_acc_vfio_pci: register debugfs for hisilicon migration driver
>   Documentation: add debugfs description for hisi migration
> 
>  .../ABI/testing/debugfs-hisi-migration        |  25 ++
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 266 ++++++++++++++++--
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  19 ++
>  3 files changed, 279 insertions(+), 31 deletions(-)
>  create mode 100644 Documentation/ABI/testing/debugfs-hisi-migration
> 


