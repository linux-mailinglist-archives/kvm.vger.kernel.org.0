Return-Path: <kvm+bounces-31883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 153A49C925F
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 20:23:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 142DBB2CB2D
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 19:18:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 269361AA1DF;
	Thu, 14 Nov 2024 19:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L4LRg5Ss"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F471A0AFB
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 19:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731611555; cv=none; b=jblz1VjUpnrccHz02+DxuyvyIvuy/qRFH5CmCOX/u70Nabn4/Lglug01hh1fjhERDrw1WzrhbxZujaIH0CbeWNXrOtkYN38pz6Ue0+8rxcbDUk+y0wbCvXRArIOD4162aDHfon6OAi7JB21OpYscsS1uevawfeDDwh0bRvFmjmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731611555; c=relaxed/simple;
	bh=R2rfevJVocBUENusDjBfdBGn56SIQn8+tISCCPh0Ajw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zo4g7Y6y/EUj/q7OiH+12VxiFmzu/dL7Ln13R2fGVIMGZfL/UnBCaOc45WChFW9PMpvXMYz3RJ72NW6MMCZbHGGzqrR/di91fVLP9uHctKIJ4fSWtk0NmZWHUmCZ3Frmjg0eSkkTZHxsriQfTNFXZE9sfRfcW1rNG8uZYSr9WBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L4LRg5Ss; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731611552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sTnUxHM1YFnozAVamOxNzXSxfyUECp/LxnWayVqEvyY=;
	b=L4LRg5Ss2giENYA9fdd124okLknWFqD/nwrk7rR5MNnY++H4GpZPuTvBB1wCXJ7AiYbTs8
	AMQwxoLuvE7dx1IPyEEv7KWHxqyAx/WyOfvFlqj8aOhOgyD+T/a0SXmTTs2d7ZfmQo4p0/
	301EOdmgsTPjx/Bq9MymaZAUNyYTrV4=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-360-jnt3uoQ1P3KdDcVIJrYwmA-1; Thu, 14 Nov 2024 14:12:31 -0500
X-MC-Unique: jnt3uoQ1P3KdDcVIJrYwmA-1
X-Mimecast-MFC-AGG-ID: jnt3uoQ1P3KdDcVIJrYwmA
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3e5fcec5d0aso205559b6e.1
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 11:12:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731611550; x=1732216350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sTnUxHM1YFnozAVamOxNzXSxfyUECp/LxnWayVqEvyY=;
        b=Mf5uCFWv94n9fz0GQ5WpZGkWUDY0Xqpqew8ILR2Fn2/mWKD0Q6s+RVE46dhYxSHp0r
         2xTVP0cMRJXPP/s7dHhCeHEqz63Ppm2ahz47FTzGMTeCaSpW7KLjMIZIXtexBCx/1waA
         Z88mLCszUQEOvdwJc6KGEsl+kXjAGVdbCSs95kSLuMg3WJq9f+/0TOWwD88tnuBK5l2d
         vzDhZtC6tGbZq2wPYzOISdtxhIi4akVAoL/9EHnscPgnsIt9yqIjoXFKLul8a+rGOSJh
         AERk66yVYmg9nKWPd8a0SvnshBozppu1y4j6CNX+ImLBV922/G1RCNT5wk7QMq7++zF7
         x9PA==
X-Forwarded-Encrypted: i=1; AJvYcCUL+mAVT2s06SwgVYJzHPgvfyCv5bKhS09213xtTrz+2+JAnrKbkdar4RlUwM3RR9TjZbQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXxSNdxAmj6pX/sCCRh0w/IghsQK+yhQxkKt2l8aOYMGrg64nZ
	t7nRPJ/cjU8TvnBiHLg28TbmlE064REzxEUCvHyuXIfp5VpEN1bCktrVLUCgPZY4uQWdT8KULQV
	EXuxxOVqd7L5JjPeKV3/m3DiyDB2CX1RoBqTAZp1f6kAjkx80Zw==
X-Received: by 2002:a05:6808:13d0:b0:3e5:e889:771b with SMTP id 5614622812f47-3e7bc7c2ca1mr20335b6e.3.1731611550694;
        Thu, 14 Nov 2024 11:12:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF+DBkcVdN3ZW4HYLNxmp9MfrNu93H5W+Q6GJnjy0KMRC+hmdn6+ZBLCKzeuJzDXmsT4DAl9w==
X-Received: by 2002:a05:6808:13d0:b0:3e5:e889:771b with SMTP id 5614622812f47-3e7bc7c2ca1mr20330b6e.3.1731611550297;
        Thu, 14 Nov 2024 11:12:30 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3e7b85bb8e6sm551264b6e.24.2024.11.14.11.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 11:12:29 -0800 (PST)
Date: Thu, 14 Nov 2024 12:12:28 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
 <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
 <parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
 <joao.m.martins@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V4 vfio 0/7] Enhance the vfio-virtio driver to support
 live migration
Message-ID: <20241114121228.7d89fc1d.alex.williamson@redhat.com>
In-Reply-To: <20241113115200.209269-1-yishaih@nvidia.com>
References: <20241113115200.209269-1-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 13 Nov 2024 13:51:53 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> This series enhances the vfio-virtio driver to support live migration
> for virtio-net Virtual Functions (VFs) that are migration-capable.

Applied to vfio next branch for v6.13.  Thanks,

Alex


