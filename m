Return-Path: <kvm+bounces-9443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75E708604F2
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 22:38:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A78731C24C46
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 21:38:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC17E13793D;
	Thu, 22 Feb 2024 21:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tf8RaTXO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4033B137911
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 21:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708637851; cv=none; b=O/MT7RyOmf7QqArnsFZB8uc0P03h/lA+wAYXFQW/dS0nSZQJBCKgyLKih0pIRRjU10QHHfS9+IFMfWwozvndZ1UraGa1stPImuqZFpDh31ZuffaIh4x/xEtaCQ4/ISvVSayolUzV4oSLBQN9Y7geMn+qNez6NNjmtpqHxuPreKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708637851; c=relaxed/simple;
	bh=AayyxAQrxK2A/bnBXFgcewbW3zRL7n5CwkyOAzT/oh4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CBrGKuj73cmoKEGNUc7zIj0hsBcTxrzpymmjID+OZIO7El0otmIZilBqYMWOI7us8tNcZEKeVMdo9Ms2U1Jmb6z/kTlrS9FDZirqNdEIm+hbXoHs1aGIzEp9HVCj2C+i2dWsjHc+elfcL1SGsz5ZUv1Fvvqu9GsqtlnWhISlooA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tf8RaTXO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708637849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ynSN6V24mhzEFud726k/VEB4lxgqL1s9xXCaqY9c6Cg=;
	b=Tf8RaTXOdQ8QtwxeZvGeR6himtC8WJPnBBfmT5xht53bRwBmXrv9B5zQAB8PwL1mxy2ZKo
	YSv307Y5r8Sy5EWGFQDXQQxMtH23cT1FqL+Iax3Z0IeUcb8Aa+kGBtAygTXd5LyZP/BmsV
	0NFL5MhrvGQwXoL2wD7ClEyeLkM2X3U=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-QzrLFVBkORyjqaClLYOyaw-1; Thu, 22 Feb 2024 16:37:28 -0500
X-MC-Unique: QzrLFVBkORyjqaClLYOyaw-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7bec4b24a34so17976139f.3
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 13:37:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708637847; x=1709242647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ynSN6V24mhzEFud726k/VEB4lxgqL1s9xXCaqY9c6Cg=;
        b=rbpYhDk4fdeXgy4OBu0wndpXF8iaDXsc65V1K8s9Ub9MR6pdICQ+DVlbHUXbpozP6R
         GfDua9TMEjoB30gblbDwV7ek1wa/NICqdwTKs1KA0KTxZ36QPEJEb7Nzn30OAblFk12l
         f3xj3MDXKfje6Zz0vx9XIvpaV0dqojrXWrWfhTAQV0MJpe5vtm8WPTCnfCDGrWss1/5D
         kkYYzrh2l+Sq5lVz3Laq9V7HYtR5IXz1HzuDgvafe3qlE60/YyfjKbCCv8kw8uTnlyXW
         ctnwhFuL/sAWsTf2kvlFsBTs0RSPDZxAqcRgVLhYogEDlvOOnC/L7ZOcgKzVffu568U3
         SxyA==
X-Forwarded-Encrypted: i=1; AJvYcCU0bFiCgrZz717DkfZWpPkpmBKyXZ0tB4fFVKmh7Bz1JKdLjflDFpvl1qCZ0z7qKKAafjt/Zg8vw3I6yfmcFYyNkNpw
X-Gm-Message-State: AOJu0YzSrFxeUAWChBgV6yr4nLn5TK4JAS/UW2NAzRWI+uUVKrhNsDPT
	Hg5LL5UFXh8yniCnHRDKWX3qa2hA7DZfJ9ym1hkawuoCaRFICeIpacigqJVamw+I8c5aV7eHFYE
	xFYuCyFgHXj9f+SYSd/2Km5jVdFpT/pr7TYguD6s0aHWOOkH57Q==
X-Received: by 2002:a6b:5a04:0:b0:7c4:9618:5fcb with SMTP id o4-20020a6b5a04000000b007c496185fcbmr149580iob.8.1708637847263;
        Thu, 22 Feb 2024 13:37:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IER8sfIwPJCLg4nXVBxCbQvy9EaLLgKqUNw8v5u1b9pu5aRo0hfXkQAxtRy1zZV3IuXEQyNAg==
X-Received: by 2002:a6b:5a04:0:b0:7c4:9618:5fcb with SMTP id o4-20020a6b5a04000000b007c496185fcbmr149574iob.8.1708637847048;
        Thu, 22 Feb 2024 13:37:27 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id l14-20020a056638220e00b004743021012asm2117827jas.2.2024.02.22.13.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Feb 2024 13:37:25 -0800 (PST)
Date: Thu, 22 Feb 2024 14:37:11 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: <jgg@nvidia.com>, <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
 <joao.m.martins@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V1 vfio 0/5] Improve mlx5 driver to better handle some
 error cases
Message-ID: <20240222143711.20b16769.alex.williamson@redhat.com>
In-Reply-To: <20240205124828.232701-1-yishaih@nvidia.com>
References: <20240205124828.232701-1-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 5 Feb 2024 14:48:23 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> This series improves the mlx5 driver to better handle some error cases
> as of below.
> 
> The first two patches let the driver recognize whether the firmware
> moved the tracker object to an error state. In that case, the driver
> will skip/block any usage of that object.
> 
> The next two patches (#3, #4), improve the driver to better include the
> proper firmware syndrome in dmesg upon a failure in some firmware
> commands.
> 
> The last patch follows the device specification to let the firmware know
> upon leaving PRE_COPY back to RUNNING. (e.g. error in the target,
> migration cancellation, etc.).
> 
> This will let the firmware clean its internal resources that were turned
> on upon PRE_COPY.
> 
> Note:
> As the first patch should go to net/mlx5, we may need to send it as a
> pull request format to vfio before acceptance of the series, to avoid
> conflicts.
> 
> Changes from V0: https://lore.kernel.org/kvm/20240130170227.153464-1-yishaih@nvidia.com/
> Patch #2:
> - Rename to use 'object changed' in some places to make it clearer.
> - Enhance the commit log to better clarify the usage/use case.
> 
> The above was suggested by Tian, Kevin <kevin.tian@intel.com>.
> 
> Yishai
> 
> Yishai Hadas (5):
>   net/mlx5: Add the IFC related bits for query tracker
>   vfio/mlx5: Add support for tracker object change event
>   vfio/mlx5: Handle the EREMOTEIO error upon the SAVE command
>   vfio/mlx5: Block incremental query upon migf state error
>   vfio/mlx5: Let firmware knows upon leaving PRE_COPY back to RUNNING
> 
>  drivers/vfio/pci/mlx5/cmd.c   | 74 ++++++++++++++++++++++++++++++++---
>  drivers/vfio/pci/mlx5/cmd.h   |  5 ++-
>  drivers/vfio/pci/mlx5/main.c  | 39 ++++++++++++++----
>  include/linux/mlx5/mlx5_ifc.h |  5 +++
>  4 files changed, 110 insertions(+), 13 deletions(-)
> 

Applied to vfio next branch for v6.9.  Thanks,

Alex


