Return-Path: <kvm+bounces-55726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 851BAB3539E
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 07:56:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2865683E2C
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 05:56:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 127502F3C07;
	Tue, 26 Aug 2025 05:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IklL/jbp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44FF1514E4
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 05:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756187781; cv=none; b=XtV+XqEPkZTvs95123/rqD6nqJ9LePqTxl7Q9Yz2nTP/Jr1ufzjsRr/zkOU5bZVKLHH4Tvjnns2aDMXB6kp0Dbo03pVQ9cH4QV1ajfusSDmIwNN3DZbGEh/9dHa9eJ4r8xNz4wFu1v9s3aNIon5v6nLG0Yr+zjbFqVGrjn0C+9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756187781; c=relaxed/simple;
	bh=3IMFVPR4H+std93tHS/o8EsubyOXoGEm20YC7XCEDYg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fWpoHvdctjtZpMuXxa2mD3MDgnXsToyV8S6UafxGfU/rCqsNfRI0wtiAEZ0DGWL+y+tq+FyyoXXfWjKyUBt1sRwPiilp2tAyDTBwvMT4Kn4INudvTKAMRs05uA52zIXlIsQwIxtZpdOf+aF/pfj+fEXiaeB7Y/UEJQxHPhplSbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IklL/jbp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756187778;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e1i3XQYd2gaMEvx3nNt7fx+dB6uOCMF18PNuwF1Ri60=;
	b=IklL/jbpRlFsKmAWtRJNPU691G8l0GRT87vlm0jl/z9jr5AQFPTu77aRXNhpcRKlUvykog
	0grWattpB28W8ia50SVf94Y2eaGy6vCKQCRrU7XRxf8FoGJlKDrdrenr9UIKGoN2a0OAeW
	VMamdS0zISGrGR6s+iD3tPULaTdO0Sc=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-WZdNWe_pO2Sgska9045JWw-1; Tue, 26 Aug 2025 01:56:16 -0400
X-MC-Unique: WZdNWe_pO2Sgska9045JWw-1
X-Mimecast-MFC-AGG-ID: WZdNWe_pO2Sgska9045JWw_1756187776
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7e8704d540cso560277085a.1
        for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 22:56:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756187775; x=1756792575;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e1i3XQYd2gaMEvx3nNt7fx+dB6uOCMF18PNuwF1Ri60=;
        b=ZpJ1s+oE41oAly5zheK7jsS86TOpyejoAt+2ZHyLjpZEl750z3B5ZlvDfbD78E4n5A
         vaPuWLJhBc9g+aivp8RgnnWlF3BjizWwAWD7BMCb8fWwbsV9iqMls26kuFi8EHBo6m56
         iVsaOvZE1YxvNoIVUJtm3oMYUtnZDIJAdLlSHPLExClkVJ8uBNBdsZ6J0//S6tFZwwmP
         H+GBgLr4HhblyWXWiIyiAes13Ay/DYXD7i9O5G6N7CkihZlULnMpS5gerVqHD/vFQ1A5
         VXEXcMw75vPy+8l1zYU8oekKy7Y1QDCWLz94y3+FvDp41OeaKxegaDUT9/3NSVQ1sPu5
         X9oQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDf6PJ73N7M1xGjvd4txOfx7kMuc+I/3wqq7VUEBUF3EP21/LUQuKklaAqDvpeW5UZdXM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlLNhSaK6VLVhZvMkfXzKf1SVeLRqMBW8HkG91zKy1BexZZ8Fk
	XvY3JCmAtXk8rkawCE8KtoPKvqxbOutHnKIT7p2e83gZz0l3okeNIxmsvj9sg350v2j5f6rA785
	oMReYFnwmnyGwXlN6g5F9FgFg0/ISwmgH/lawUSdz4vAxhRuRYK2SAQrgypQqYya+
X-Gm-Gg: ASbGnctmrPNyXZxpzyLR+zX5cvMxSjrO1DO++Y+9PP4ANB0gx40tcWOZuIbn8nxv0dF
	htij5VD8IAMDCfhlbJzTJqRnSXatqdYQ6EuiVApkfcxtjDyXNbvb1EB5f+gquUC3KNfMqBzFarz
	jjfvDaeHTAlZw6TxWGLHvz8nXwGMSFCeEYWwgHqrrzJyyJloVZzVhomkQnIhfu0FYEOMfo57BHp
	xb6mb1O4Xf6+qFA+W4OIfp7yQh/MtNCzNGblfMMZXTggqFfRi0c64QTyyEj7OpIwdzLgfWI82Ru
	ZGkz9odb/HZQbdBp/nqc5ume7xMPRWFVHToBQvWmH0N/qr327+xWwoRf4MlYBcpp8NPBaYpieU9
	csm72DvDNQA0=
X-Received: by 2002:a05:620a:450f:b0:7e6:6028:6180 with SMTP id af79cd13be357-7ea10faa10dmr1447143585a.30.1756187775446;
        Mon, 25 Aug 2025 22:56:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGrPzH7YqkXBUFd+3t9I9zVVXOx3cBGPtcyqkUaCBB838vbSl8ehUgL3NJQsYtaPpyveh/ohA==
X-Received: by 2002:a05:620a:450f:b0:7e6:6028:6180 with SMTP id af79cd13be357-7ea10faa10dmr1447142185a.30.1756187775044;
        Mon, 25 Aug 2025 22:56:15 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ebed79a712sm619918585a.17.2025.08.25.22.56.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 22:56:13 -0700 (PDT)
Message-ID: <3a1c41be-ce5d-4713-b7ef-9bdab3a05816@redhat.com>
Date: Tue, 26 Aug 2025 07:56:11 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 0/2] vfio/platform: Deprecate vfio-amba and reset drivers
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, smostafa@google.com, praan@google.com
References: <20250825175807.3264083-1-alex.williamson@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250825175807.3264083-1-alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/25/25 7:57 PM, Alex Williamson wrote:
> Based on discussion[1] there's still interest in keeping vfio-platform
> itself, but the use case doesn't involve any of the current reset
> drivers and doesn't include vfio-amba.  To give any users a chance to
> speak up, let's mark these as deprecated and generate logs if they're
> used.
>
> I intend to pull the vfio/fsl-mc removal from the previous series given
> there were no objections.  Thanks,
>
> Alex
>
> [1] https://lore.kernel.org/all/20250806170314.3768750-1-alex.williamson@redhat.com/
for the series:
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Eric
>
> Alex Williamson (2):
>   vfio/amba: Mark for removal
>   vfio/platform: Mark reset drivers for removal
>
>  drivers/vfio/platform/Kconfig                            | 5 ++++-
>  drivers/vfio/platform/reset/Kconfig                      | 6 +++---
>  drivers/vfio/platform/reset/vfio_platform_amdxgbe.c      | 2 ++
>  drivers/vfio/platform/reset/vfio_platform_bcmflexrm.c    | 2 ++
>  drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c | 2 ++
>  drivers/vfio/platform/vfio_amba.c                        | 2 ++
>  6 files changed, 15 insertions(+), 4 deletions(-)
>


