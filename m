Return-Path: <kvm+bounces-52203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 69474B0260F
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 23:00:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9E8587BF18A
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 20:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8EC7220F51;
	Fri, 11 Jul 2025 21:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M3upjZsN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5BC1B414E
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 21:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752267635; cv=none; b=Dny3OEAbAFd9IQm8JuQuxUuzAYja/4OzCoJlBqkLXxh1oekZSsGFr3mcJ7s38ftmHGfQYMVkKnvx25c3C9YRWqObcoZvna7O461/jjVDT9rgurOEz7F03fwWCOXDYiapjH/ofGLWyaQxqcRSbIO28gW0FmoirxXxtcix6//7sdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752267635; c=relaxed/simple;
	bh=jvLnJOirTp/xRYA4btkG5bfclApJS6l3rkthMF/Az64=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e60pMnpFiB6HnYI5lPJN0jCBNo+aAuNnuTCnmnQzpg1D/c82IHfRj62txA2R8nkAAaky84fcfAdkcvdzM0W+jDZ4a7bsymYdPEM1CtyvqFEY8ScaJUVddR8fxgoLAG7hG6e4raIr2zgixBBflcJJSWnn7w4InkJ0SeUVMop2vfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M3upjZsN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752267631;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+k5Kf2aCZd0TUr7Eba5a8FIqCkFy3kz8bRsUhqWADsM=;
	b=M3upjZsNi/AIldTymnaeHTGBPCIkkjQkJ6xNGSqfkMHRmRHgAlkVyanWHOAjOtv1lnqras
	RS6lW7dBlf9KPML2+CR2nvDGu9CB6a48arx10tqx2KIcYhYVLt4bPPTWNW9u0wF5k8Kxpl
	qnuK1Jc1Ieq6boMLpZ3t/dMWmUczCjY=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-496-6O9TkhhPObW-s6WN681bfA-1; Fri, 11 Jul 2025 17:00:29 -0400
X-MC-Unique: 6O9TkhhPObW-s6WN681bfA-1
X-Mimecast-MFC-AGG-ID: 6O9TkhhPObW-s6WN681bfA_1752267629
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-86cf803792dso7614539f.3
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 14:00:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752267629; x=1752872429;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+k5Kf2aCZd0TUr7Eba5a8FIqCkFy3kz8bRsUhqWADsM=;
        b=RxDmbhWpa0/MgVlK5ek4g4poASRYKXOlCdJ19o5RIrYV1lJNEXaLJG7mv+eO/BbY47
         WV2rOZz703qZ3hEIrdYX0MaoeVDVn83bFKfXYhE4S/IuYxJHZJtcv+F+h7+BJe0QbDX/
         sb+5k3s4e/tW32jwMWszhZL51yX4IOZ+kG7vBoSJaBA1F7HDOo6ajsqyHKs17G4c9saH
         A+1kvuk2iHfT0iBCWmStgiFO2ExIuCpvHrWvr0rfeFLs+zVIJMuHYQfbhXn9AoRGNBgm
         Rc/wQ9X9Hkj8AvNV5B7Sf7XJNxyNyb1BzTyxtFPJbo68jl7JqjpecTYOC/nKVBYIFCgs
         xi6w==
X-Gm-Message-State: AOJu0YxVISMMe1pr+Vs8g85XHW2GI+ZAEEP9s81tR54aX8p5gIctKmWc
	2hOMlW1SzdqZaeOohDvgAbpFf5mEYy/MOyCwa3KKxqXtwl1W1/dKRzVa48Y90bewnu9ywZLX4UX
	mlmRRQio5DWrRFIFaDbQlJA2y1HO3tI1OMI4O6XIdQLHmdgYhjkCMMg==
X-Gm-Gg: ASbGncvbvHTKzWKUVnfBvg1m2e3UbaIIGAyd5LK3FHA1ECsCgnPlQLDPdQg1EpI0bga
	pOXPPEytLLPMyRxnDB+mNHIY8r3dawv5hqwg82ot4q4bzcdl5pshUGE5fTNHjTSZEWzF/FbiIF6
	tYP3FoKBGU4M8D+WiZB1iGTKIdZwliV+xPwWD1ouON4bG39o4TzpOISwtciw4T4coOvzEtD4RzV
	j4T9kvAJeYKp1r2yjTfh2ntEsum2zrCHur5XWi/5ROVE/qd3aTzk1ZiWy8rIao1qNbd+amq2Mgv
	QnD+hIN/PWwEqdQJ2cCVsFE7HWgqb64MPQeR/JSycLQ=
X-Received: by 2002:a05:6e02:2489:b0:3dc:87c7:a5a5 with SMTP id e9e14a558f8ab-3e2543def86mr17790685ab.5.1752267628745;
        Fri, 11 Jul 2025 14:00:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGako33wjOvTa0EzFSB/ZXx9i7F0QzpG+pjUcSbdRvxlqcki3WNixgJXwNk5hEcX3PINDImAg==
X-Received: by 2002:a05:6e02:2489:b0:3dc:87c7:a5a5 with SMTP id e9e14a558f8ab-3e2543def86mr17790485ab.5.1752267628325;
        Fri, 11 Jul 2025 14:00:28 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e24620aad0sm14180805ab.34.2025.07.11.14.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jul 2025 14:00:27 -0700 (PDT)
Date: Fri, 11 Jul 2025 15:00:26 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Artem Sadovnikov <a.sadovnikov@ispras.ru>
Cc: kvm@vger.kernel.org, Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>, linux-kernel@vger.kernel.org,
 lvc-project@linuxtesting.org
Subject: Re: [PATCH v2] vfio/mlx5: fix possible overflow in tracking max
 message size
Message-ID: <20250711150026.19818a98.alex.williamson@redhat.com>
In-Reply-To: <20250701144017.2410-2-a.sadovnikov@ispras.ru>
References: <20250701144017.2410-2-a.sadovnikov@ispras.ru>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  1 Jul 2025 14:40:17 +0000
Artem Sadovnikov <a.sadovnikov@ispras.ru> wrote:

> MLX cap pg_track_log_max_msg_size consists of 5 bits, value of which is
> used as power of 2 for max_msg_size. This can lead to multiplication
> overflow between max_msg_size (u32) and integer constant, and afterwards
> incorrect value is being written to rq_size.
> 
> Fix this issue by extending integer constant to u64 type.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Artem Sadovnikov <a.sadovnikov@ispras.ru>
> ---
> Changes from v1:
> - The constant type was changed instead of variable type.
> - The patch name was accidentally cut and is now fixed.
> - LKML: https://lore.kernel.org/all/20250629095843.13349-1-a.sadovnikov@ispras.ru/
> ---
>  drivers/vfio/pci/mlx5/cmd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
> index 5b919a0b2524..a92b095b90f6 100644
> --- a/drivers/vfio/pci/mlx5/cmd.c
> +++ b/drivers/vfio/pci/mlx5/cmd.c
> @@ -1523,8 +1523,8 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
>  	log_max_msg_size = MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_max_msg_size);
>  	max_msg_size = (1ULL << log_max_msg_size);
>  	/* The RQ must hold at least 4 WQEs/messages for successful QP creation */
> -	if (rq_size < 4 * max_msg_size)
> -		rq_size = 4 * max_msg_size;
> +	if (rq_size < 4ULL * max_msg_size)
> +		rq_size = 4ULL * max_msg_size;
>  
>  	memset(tracker, 0, sizeof(*tracker));
>  	tracker->uar = mlx5_get_uars_page(mdev);

LGTM, Yishai?  Thanks,

Alex


