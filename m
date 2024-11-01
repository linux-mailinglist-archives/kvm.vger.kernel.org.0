Return-Path: <kvm+bounces-30311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AB979B9374
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 15:39:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABF261C20DCA
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 14:39:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE86C1A7271;
	Fri,  1 Nov 2024 14:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RJIM8CHG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9539F1531C5
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 14:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730471943; cv=none; b=qJLee5RhPFXet+cMPmJukXuOLn9TepLNUtHO3On8ugFLezOv3Fla5oexHXDk9KEunvdgoOsepOhLcFbmTjaRymolSnewn0qRO/cg7DsepF+MSBWpdp3vl/aPshWHxOZsmQZwLNmlGCJRqKkSPSOUQdHXhYlqkIFFZHjTIyvgPqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730471943; c=relaxed/simple;
	bh=Y38QQrJXyIzC27Zb5Y70kq+LVb66PlU9agQi+H5nsOU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lPFB4JEBPDL9oSdfyATc6ppzSrZl4rtxPOaFJD+2D43TazqKaZFzZt/czDOM2sowoG7OtnfDQ3giivOCSLuPaczk3fj8BEalWtmoYVQ0E+MEPOw8viWOx6dJvUo0TAOEHBnctT52r0jRNbFsCBFuf++b+USKFlhygJ3eeDO4k+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RJIM8CHG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730471940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PjBxXqU+pM0vC60LmXgGLO5qOIRdoqxNpK1lcWYvr1A=;
	b=RJIM8CHGcrJb9zzANJfsPNeF0DdG9DiNUDZHdLXgP4/iW+6/5s8KFnk+NXtN3lhPy2r9pS
	wWbnrD8bCTs6Z553SQM0weAS7xwrGlU6AfeQG60jxYuImE/MUG//AqttbqLO/UoIESrKTG
	X+0nhzxQp2gwh6uyoLMlpl8GqXzNaUk=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-490-3tLGc8e9M029lGWg7i2Cwg-1; Fri, 01 Nov 2024 10:38:59 -0400
X-MC-Unique: 3tLGc8e9M029lGWg7i2Cwg-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a4f803aa47so1772035ab.3
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 07:38:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730471938; x=1731076738;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PjBxXqU+pM0vC60LmXgGLO5qOIRdoqxNpK1lcWYvr1A=;
        b=vCkz2ugx9t69fJOYngvMSAsBjmB94HPCmi1jpdMADX2R3g+yuOOK47giCM/6MJ1kjI
         F+sZeMBBT3GxnT0gHdmX1uh8jELh0XYVl9S2LpEKyVWxQook33fzts1CHotcTFcn0+rV
         eCJzwAD3t+EQfs7I3WXuspS81LbNxiIj2wEylHTZ2yMOba8QOrLKcDJ2IBuE4h3GtpPM
         DxHdMyswWZFE9DfgFCLxsiK8+Ez7neU59HHac1mUXu0jzDiz4bnQdghyezSsCE/8IfBX
         oZttykK48hxsmt3l9/xrYcrRmzoxqsLxxINOrecYV+Mm05C+M7Pyeef5ZSqcuJ+SrAvn
         frxQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSzK3KXFfqZYz20DwSRpLQibRSlJkGlvGu5ltLIn6OPuGztLFnKab2eVtLGkEpIj/n5po=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyfjfgd5eJ/43QaKmyKC+FBKJWvowh71sFfQmNbGIO13bnBuPhF
	nGEdqSpEcZY6dd8LYfEVMDyrTOUm2GN9iXbp1Lbldmyix+hwqJClzbLCogfxhKHC8CourzkpiHX
	vFXVhYBmMuII2+ZlhyrDf/f6M+E5Sr3GUTKJolrj8LLR8j8ELTw==
X-Received: by 2002:a92:c264:0:b0:3a3:b4ec:b3fe with SMTP id e9e14a558f8ab-3a4ed30ccaamr64455415ab.5.1730471938352;
        Fri, 01 Nov 2024 07:38:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE7nZwd4QYd2Kqt6n+Vk5UKw8q+RJ0a/CtlOIPXX1gGRhLlpcRjOUVpYuIqY4BAyZdXiPM68A==
X-Received: by 2002:a92:c264:0:b0:3a3:b4ec:b3fe with SMTP id e9e14a558f8ab-3a4ed30ccaamr64455235ab.5.1730471937957;
        Fri, 01 Nov 2024 07:38:57 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4de04acaa2csm748195173.172.2024.11.01.07.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2024 07:38:57 -0700 (PDT)
Date: Fri, 1 Nov 2024 08:38:55 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: jgg@ziepe.ca, yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
 kevin.tian@intel.com, xin.zeng@intel.com, kvm@vger.kernel.org,
 qat-linux@intel.com, stable@vger.kernel.org, Zijie Zhao <zzjas98@gmail.com>
Subject: Re: [PATCH] vfio/qat: fix overflow check in qat_vf_resume_write()
Message-ID: <20241101083855.233afee0.alex.williamson@redhat.com>
In-Reply-To: <20241021123843.42979-1-giovanni.cabiddu@intel.com>
References: <20241021123843.42979-1-giovanni.cabiddu@intel.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 21 Oct 2024 13:37:53 +0100
Giovanni Cabiddu <giovanni.cabiddu@intel.com> wrote:

> The unsigned variable `size_t len` is cast to the signed type `loff_t`
> when passed to the function check_add_overflow(). This function considers
> the type of the destination, which is of type loff_t (signed),
> potentially leading to an overflow. This issue is similar to the one
> described in the link below.
> 
> Remove the cast.
> 
> Note that even if check_add_overflow() is bypassed, by setting `len` to
> a value that is greater than LONG_MAX (which is considered as a negative
> value after the cast), the function copy_from_user(), invoked a few lines
> later, will not perform any copy and return `len` as (len > INT_MAX)
> causing qat_vf_resume_write() to fail with -EFAULT.
> 
> Fixes: bb208810b1ab ("vfio/qat: Add vfio_pci driver for Intel QAT SR-IOV VF devices")
> CC: stable@vger.kernel.org # 6.10+
> Link: https://lore.kernel.org/all/138bd2e2-ede8-4bcc-aa7b-f3d9de167a37@moroto.mountain
> Reported-by: Zijie Zhao <zzjas98@gmail.com>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Xin Zeng <xin.zeng@intel.com>
> ---
>  drivers/vfio/pci/qat/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/qat/main.c b/drivers/vfio/pci/qat/main.c
> index e36740a282e7..1e3563fe7cab 100644
> --- a/drivers/vfio/pci/qat/main.c
> +++ b/drivers/vfio/pci/qat/main.c
> @@ -305,7 +305,7 @@ static ssize_t qat_vf_resume_write(struct file *filp, const char __user *buf,
>  	offs = &filp->f_pos;
>  
>  	if (*offs < 0 ||
> -	    check_add_overflow((loff_t)len, *offs, &end))
> +	    check_add_overflow(len, *offs, &end))
>  		return -EOVERFLOW;
>  
>  	if (end > mig_dev->state_size)

Applied to vfio next branch for v6.13.  Thanks,

Alex


