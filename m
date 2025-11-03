Return-Path: <kvm+bounces-61789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D52B8C2A43A
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 08:18:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 81814347296
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 07:18:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D63DA29A326;
	Mon,  3 Nov 2025 07:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M5OuQIWZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E06B2505A5
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 07:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762154280; cv=none; b=OR3gSuB0/jd0sgozWFWNBgnQPq2KFdMiGFb2cngdlI7NSUafvzhINCe5s1wCaOau672wtVdhbFVyDomUiWIed3/LUeJnx1HmfuBpb5HzLuKQY6uBGw711Adk6ova7ovjyUL9NiDnEnH0+VXNW7LcTho9JJ/e7WlUovmoPgqAWIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762154280; c=relaxed/simple;
	bh=u2RitBJJYcOeGrXcJN16D/BkVV6lr7NwWHkSsUefBtc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I7fdU356zhn+QvO5Wjit6D1DtEYqqWXmVjfLUJr3lioPESsctVHj4N4wYjrVqKbVp/CQP6MeFTHyKM51mtnu36eAMuzgFluetcUFAOaiWYAWEcWoNcbePXZJox4tRyMjSQZbdttXGHwdWFfw4987NgxTejkQqn43lXlmof9C8zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M5OuQIWZ; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-27d67abd215so381825ad.0
        for <kvm@vger.kernel.org>; Sun, 02 Nov 2025 23:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762154278; x=1762759078; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fkl25q/g8s7OS88Wbysk4mwVIyDLafMsvz/s+Uj9Ki4=;
        b=M5OuQIWZC9DxXUsMzoFAO+mWl+Z/mFl2K8RQad7408r4wRhLKs1CQMPQxpWfTFLBIX
         6OmB9FlV4eCBEs9ScU00cLnClPhiA1CjX8Y1Xvp9AP0vSt7xv3kZfOTiZgUDEMUQQ2Mg
         hkW852aBT5ch3drnKaMIL9JNX9nvNcgSjAn+aT7B2SM/oVNmibI9o9h1HtEgBUPCoRrL
         SXjsPYK4PChcj/+DOEaAnt15CgTzx6Sco4ujpUR/yF8YGfHsnupBb26unOZb99ha03Xc
         zkeflX1sqtwKqA5G7KpFZW1KS2bFr5KjpaOdypyj8aTlYbqI4GC+rgxQL4eftPxmlJmp
         wBHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762154278; x=1762759078;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fkl25q/g8s7OS88Wbysk4mwVIyDLafMsvz/s+Uj9Ki4=;
        b=kHeqfSD2885VUVXTgomgu2Fc/D3spDCSVl7eqYY4kQzcqr0cKnv9JQpM6VpRzzua/0
         wp4DdrQsD+x/0H5sWZZHubh7Q4uTcHGUg/jJ4O7gmpzt6r7N6rl6fpTSExphxQuv/yus
         1Zm5HFnaTjJkEBdbFmlu1vUG6SJ02dTjqlKVWcaQ6c4oyCIrJ/8GYQfayhJfIFGG9DW1
         vamTQMNdSESTiDtz5drWbpIadMOPP/MAreuMEbKq5bffoDCYOlermKsSIm/JqoxcZ1TJ
         e1eFNvdrdo5TjP/B6yLVSoHnNYgqM7BIu+2aFdKBlVd49ZmHRy6mb4TRy6WKdH6bKULn
         /MHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYBo8tgnXRbOOx21XWGUZQ+XEEOpPe4qy/llneG+ebhrIIfMBzpa0yQ0grJ3crkIv7iPw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9Beo6hXq2KLLUcyvI1q9KO03XKztF4NcwQv8UJqHTEcCk49Bf
	Vqk9mMkFVauzn66TCmiv+DtJTJATxZdV/osqgM9LJDFD46NSYN9SzAelBstbbOAOEw==
X-Gm-Gg: ASbGncvBRbKVB9Fqtg81FWipZyDmD8H1NkwvOmd61UNJe5WyrzZLeHhHGmC6gvW0vAR
	v5MavPVTjNTBgYdAferjjE7rtUeRLMHXhedUcjfPV4B+iyvEFcgtFYdDdrPqFybim63XNQYmY9a
	ZDpPLbepREeG66Bs5y52Z2qHpnL/1poVRmcvb+4KvavWYNtXO3gpg7MmFdhPOyn/TCcMH5H6Vig
	T5PHi6XIT/CMHi06yOqhX0dM4qilLIGHdm6wsb2jG4o2UXWgj2oyHctshPrvSelZ1ki1UKl2nkz
	C//ypiOZDmPR8v0sMl7h2J6UZjkYCktQRK9DqpUtpk+qVSS3LpAZZvqEBV9qljQCdN4CjiXfqLb
	WdwYFqD6Z/QOB9NVj2bqEqsTQImXZAbm+ywPMs5cgIJuo/3wXI75MVrD1vHaVH7/dz598qjzbo3
	T3bBAqTQykGoi2AlzTPcWHi9EVO9KlZyx4y6QOVpAInnIgzmic
X-Google-Smtp-Source: AGHT+IHfDR3pQIMSIQjN/GyrpnHhW694vgQCyWpAq5GaAMMYhNpX5IKRikqyk5tXJtqoi708RLXBcA==
X-Received: by 2002:a17:902:e88c:b0:290:d4dd:b042 with SMTP id d9443c01a7336-29554bc5206mr6800415ad.16.1762154277664;
        Sun, 02 Nov 2025 23:17:57 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b93b7e19ea0sm9634160a12.5.2025.11.02.23.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 23:17:57 -0800 (PST)
Date: Mon, 3 Nov 2025 07:17:47 +0000
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
Subject: Re: [PATCH 06/22] vfio/mtty: Provide a get_region_info op
Message-ID: <aQhXGwlxZrZl5GMN@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <6-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:20PM -0300, Jason Gunthorpe wrote:
> Move it out of mtty_ioctl() and re-indent it.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  samples/vfio-mdev/mtty.c | 53 ++++++++++++++++++++++------------------
>  1 file changed, 29 insertions(+), 24 deletions(-)
> 

Acked-by: Pranjal Shrivastava <praan@google.com>

-Praan

