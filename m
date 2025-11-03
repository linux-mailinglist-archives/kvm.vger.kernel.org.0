Return-Path: <kvm+bounces-61785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 013A4C2A367
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 07:42:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id EB7F8342884
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 06:41:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49054296BC2;
	Mon,  3 Nov 2025 06:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0bnECZYk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD598184540
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 06:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762152115; cv=none; b=sO2In0CTI1V0/oOOACkJ5HHDcHpMCm3EwmF7C9AMw9PSulqv00d3xgXE5bGPG2QlGw6QOBXkZhwnONJX4UEYwBnLR4miDIh8MIEq8FZmPW3lXhtGWrzb59fXHnmniEtV/uS2p2ScGkbsXLgnq1f+K1tgRk6G2QIKjbAMWG2j5kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762152115; c=relaxed/simple;
	bh=+CzUqqO06i/e7Ypbz0z7VulGOd2vXLPuLoDoGKacS4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aZNwkLBErvJyjK1mk7DUQADGdS4g1CIn8GS2KrQgQZ/s1vLqnCERkK589k9HhkrhkqjjpJA7ZKqc7Xlpn/OjjcN7ybPNOwW/14xq6vLOdpPOnULZn2MykN8K2shfoyoiTX6FhK5CP79TgqUCn7r7OnzXtNaHGNmcDAyezCk4eL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0bnECZYk; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-295c64cb951so79345ad.0
        for <kvm@vger.kernel.org>; Sun, 02 Nov 2025 22:41:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762152112; x=1762756912; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xy09bbBV2an4SjPwDAIo8320NA2LlnNWvmRboTY817s=;
        b=0bnECZYkvrjtiIKzbq/h2ohkxkgZchTqdyniem2q1eBn3bk8l1R7CZyCEMf6SSIAtS
         jDBwAVtSPV+istaECaeSF+3AW+2Vnek7OclbuGgwfEtqH0KyOBEOFSsArSh4Ad6zYtJE
         LSz6Cf+kP6oKQIcnEEcUPhaMGJpoZQ56dYpHyySHmiJ1PbWch9BH23xuKZRHofM4gS2c
         p6z1wCzEqnR3p/eVoIuDR3O9I8qP44O65nQ/70IzqwALw0fFOYm2fxSy+pZiHO/JBVmQ
         +8C9kmzmTPTSjB9QJWXI/J7kCb9c3i8m30otXM67LYtbYuuMgA5Ssm6Y5YUNCHZ0IwIY
         xkiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762152112; x=1762756912;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xy09bbBV2an4SjPwDAIo8320NA2LlnNWvmRboTY817s=;
        b=YwY0mw9WKUS/4ZS0jRofr0ppqWYsLk0DGSW65fvp0otk4bszg2FwUpOuWqxaR+6LGE
         shSRCdkG2J9REvsu5SfW06LxCJ590YjiWD0wtS9i0NpJ7O4pV5xloxnnODD/2HCOOMz2
         y3buL02wafxuX9VjHWPcC5MxfiIf9h989NHi40qiq322POgXeBUDgF6zZ/49RapmfQea
         1NohAor6PlkLOBFnB0VqKpx0oZ4O9DNbtEjiRde+374+5ytbJmGgAngSoCe4p7cufWo+
         q2OqoJlhMu11TSGPWaEOtKxIB3Ve2v4LoIrSWrrDc4ZNTxrANV+0ZP3zkiqNlL/43ofG
         B0cQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFlQAAjJdgsPgxjXz8Iye8SLWc0ugbWkDPkykPTj+xMSM88sI9jZRkMbyspYCqX0uQTzQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGJghJkQbbJQQ4RZ//MeyvZCzGjnDnT9DaL3WpyrAluc6bWC5d
	4bStFTlNhXz2Pjx9sLxZL+Paxc4HUL8949r+OV53Mj7vHxTZ85XFUxlZulB1RhV2Hw==
X-Gm-Gg: ASbGncsXx60kGig7IYeEyyFGVmBgJRxDKhu3zxyMllHdLZByCnpUOEprAJKNyRJIHSY
	Bd9UqQ7qzRj4vytIv8ICj3tjR9vUk8u/4q5sJObF8Eb4BFe4SBTqhe9xuD49tFkO+JNTL0K+oX6
	lxeHt0IfYHKNTr52115dqgQpZRzNCEG/PsMFqTXowBAa4ZUnsXHfWPe7sOw80XDFiFS6nzKccNN
	g89xAzraCqCPKZc2bYHtV/rJsZ9JES3ox3RTHIer+yJAHLLktpDmQOlXXSlMLdsY8XuXIPuSqMm
	+/y0OMne6LkcZq99Q2mhQ8L/C1E6tsMcVABY2pwvE2+39boC9MIjgP6vGVe1aeiRmA+cJT6923E
	lTnxnF1L7VQ1pom+38q7ZBr8OKQBwJOSEvNF14s0IqI8ZkrbiAU477JqKIaTqSsUuOdpQUxnrdA
	N9yaDhcBQBnlCgh3ivjk4dqkModaPtH8xcMiMFIBPsCh5KreR5
X-Google-Smtp-Source: AGHT+IGU3X/bvekwg5vtQ6XJGr9uQJGWUTHzyQr+Es6KbcLgu8QfXVso61Ocr0oWX8j6FOttuRoGtw==
X-Received: by 2002:a17:903:1ce:b0:292:b6a0:80df with SMTP id d9443c01a7336-29554bb5aaemr5658455ad.10.1762152111810;
        Sun, 02 Nov 2025 22:41:51 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2952696eb6bsm105902925ad.58.2025.11.02.22.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 22:41:51 -0800 (PST)
Date: Mon, 3 Nov 2025 06:41:41 +0000
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
Subject: Re: [PATCH 04/22] vfio/nvgrace: Convert to the get_region_info op
Message-ID: <aQhOpec7prJD3zKm@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <4-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:18PM -0300, Jason Gunthorpe wrote:
> Change the signature of nvgrace_gpu_ioctl_get_region_info()
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
> 

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

