Return-Path: <kvm+bounces-61811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BDB6C2B116
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 11:31:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D930B3B4787
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 10:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B1112FDC2F;
	Mon,  3 Nov 2025 10:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Da0KLzWH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085672FD7A0
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 10:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762165784; cv=none; b=Caz5D66YeS68gjAILDJ+6DZRPa3OrL335nckFET7QgsSHeJ7o+jgcJFgAqIvweCw541khhFpILMmqUGzCuZA8C6x9ngsNLvR2awEYh5zM8HIWdbIxJq98N1rGjeRcb++H84fZOAa07C/VRGAZIOhXKN7cdx22LPJMgdEKWkP/0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762165784; c=relaxed/simple;
	bh=V327Um22bMTy/equs3K8rbAzzyPzJ9CLEIoEo0OIurE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n3E0c5Xpjb6jO0EuSKwnJ3wqkLZZNhBDgv4AJhkSDtgSdAvw14WmSNuPofOiVr1GSPUVzCKaIGTUQJXVWIuKMylXLIJvrEN+L6mSdFQPqpWz81RE26v6WavEcqjyntxLxn5j/zXiqYhNDL2nat7SkxqPEWruaxo7MjTgFIyVnZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Da0KLzWH; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-294f3105435so373865ad.1
        for <kvm@vger.kernel.org>; Mon, 03 Nov 2025 02:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762165782; x=1762770582; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gNHaVozbtXB8nI6t/qtWfMkb6Kn6PYTAjlMTSN+Ugyg=;
        b=Da0KLzWH2xxT5C6CmX/7a88N6czNNvZ+LJ7x9Em3OPLVX9p1HjLcpIeyp9q0WHG3O6
         lwpY3ZPxMR+7+N2Ys3q99PVkdBBsqUluXkIPJMEY7OyhBYiwktNlHYEKiAriN2BTBGB0
         cGRUDKtlY2HRRf77Tu8zha19XvJchHa3nBa8E1k85YqCHkIaIrFUZ7Y9VXdXWORa5ns8
         +ZxTxPwboLYygi5chVmxfuOPotUhoybaekvBOOqIXMcPkVPTfq1RmO6nnN1VMZ5n68/X
         JIawwmi62v8pQU6X8WHfVYwHkFhRDiNnACx82SemcHyLQSEXvBtkpICxc3yCd5jXs6Kc
         EMQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762165782; x=1762770582;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gNHaVozbtXB8nI6t/qtWfMkb6Kn6PYTAjlMTSN+Ugyg=;
        b=GSM1igP0xHECu1wzMD9Lz9tymi0usxI3M5xyBHKqYI0hbgedaXaPPVOpn391IhKyii
         pkLvv7HoZ4IunFe8QA6c9utB4sEJe015Ac3nP8cr/0yw+2OYqRYMPqf8oK8Un+tcs4nR
         htsq0DWkR7PL29SlXxMi18GeyQtpwl7Xn9YjSiWfI48znEwwHpWjYCG5kVBeomy0mJtV
         VRhno+iKM9mfuzXZJ+G5sWrVQEzaz5LyxqdpqD9HnhhyQws1S/t+LAXRkRiCKrMl9Sng
         5Redrt1Lhgn6cF9QNo4hG/36wYRjNLZszeIxdutimGju5utDFG+k8KeOPzOsOeFZVuju
         txpg==
X-Forwarded-Encrypted: i=1; AJvYcCVPYb1V6UlIBxiIEIYqeAZApeYUTLo/Oosx4RvSXI8ogRSwyqusHzUxuV6NnOJf0zv2ouw=@vger.kernel.org
X-Gm-Message-State: AOJu0YycL2CuDK0UMfVjlcgLdfGRlrP9zf/YelC5KUA/x9IEnXz3alIM
	7dhIybyCt2oANPHz9GflhoiVD4ojRncY7yTiF1Q933hRaqwyeAG4iczr0JuDegXCpA==
X-Gm-Gg: ASbGnctPnKU8CuQRcHcJ3klS6+BMqIwelIT9OpLDZwWIZkV1N7bDLoi67s7KLVpAGjf
	AfxnrXWQPwD5GEf8BNojOtuYx2rHL6otLyMKCjgBCwDtCUoEAcvvOv8Q5OapPdy4KXieC4oDmOF
	AO53mj3p1J8fqq6SXJNRq6dby3XTIG/fW0j1Id5AT+S2ZkdwD4EtDylzMYchw5n1fuafML5Px4O
	ZoC3jk6AbxTyLMIqBkdrJGGIGCCw1d17lLz3MJfhTex1J3LDe0lcYaMTaaJiIa/V+fQ0odQHjhF
	wphHHwUT8/tREF3YUh4uuOSmqLQ744ki3EsDmwapyub4d87cA8rbvQFyqWKjs2TsN/Lw/EhQaoo
	fHgFmY2g3x6Up2vni9SIr7OS0S7//xYULjj+TYwoVHWKiCjgidd26rkOnHE1opTppxTjK+PTGzc
	soFNFgqV6SP09h+ql/ubHURgC6hOeTOMHvlQJ2pQ==
X-Google-Smtp-Source: AGHT+IE7RbmruVQhXsny/j8l+SFhjfD6jlGy79IZqby3HlHJSxLaU8PrnA03I6j8kd1hYd7zo15JRw==
X-Received: by 2002:a17:902:d2d0:b0:295:30bc:458e with SMTP id d9443c01a7336-29556477728mr6652975ad.3.1762165781842;
        Mon, 03 Nov 2025 02:29:41 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ab30909fccsm2991326b3a.20.2025.11.03.02.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 02:29:41 -0800 (PST)
Date: Mon, 3 Nov 2025 10:29:31 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
	David Airlie <airlied@gmail.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Brett Creeley <brett.creeley@amd.com>,
	dri-devel@lists.freedesktop.org, Eric Auger <eric.auger@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>, intel-gfx@lists.freedesktop.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Kirti Wankhede <kwankhede@nvidia.com>, linux-s390@vger.kernel.org,
	Longfang Liu <liulongfang@huawei.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nikhil Agarwal <nikhil.agarwal@amd.com>,
	Nipun Gupta <nipun.gupta@amd.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>, qat-linux@intel.com,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Simona Vetter <simona@ffwll.ch>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Mostafa Saleh <smostafa@google.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	virtualization@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Zhenyu Wang <zhenyuw.linux@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>, patches@lists.linux.dev
Subject: Re: [PATCH 21/22] vfio: Move the remaining drivers to
 get_region_info_caps
Message-ID: <aQiEC2Z3lqxAIY3J@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <21-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:35PM -0300, Jason Gunthorpe wrote:
> Remove the duplicate code and change info to a pointer. caps are not used.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/cdx/main.c           | 24 +++++++------------
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c | 26 ++++++---------------
>  samples/vfio-mdev/mdpy.c          | 39 ++++++-------------------------
>  samples/vfio-mdev/mtty.c          | 38 +++++-------------------------
>  4 files changed, 28 insertions(+), 99 deletions(-)
> 

Acked-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

