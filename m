Return-Path: <kvm+bounces-61791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 74606C2A4CA
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 08:23:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0617D188FC2B
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 07:24:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E973929BD85;
	Mon,  3 Nov 2025 07:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pZTuHYXg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AAC2D9EE0
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 07:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762154366; cv=none; b=BuZMEMdNMwFa3EnOvZv9+6RM45dCiJ5DHsTT+3ot9Vmx5/V+IxwpfUdoYtGkC/QNkO8vgBnmNtfenQr9OZcUMZ99TWqqoclpeMqwAWyd62A/2pf7CVBdbFdLr6W96vztJjn/lXbpsMTnpZ6RNRLU1o6Aq6jH2/BYZgcMkTnSA1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762154366; c=relaxed/simple;
	bh=bTu+sl9W2Jx7okIIkeQnTAXEp3nqEUfmyMval1/FNXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VCqiIOVVGq0P8mY/nOhbDJlT7J5+5snjtaSVyhCf6fmGg5JPK2WB20nZPg3xVJP8sYL2yt38sPo/qtUzRLYpTfJMHKJHNPi9wr3tkOlOB8ZcVmAOntcHA6pCI3fZBFYWVBd6X2Go8lD7grl7HGD7517dOWbDyiC3+UyLdnIeKDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pZTuHYXg; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-27d67abd215so382015ad.0
        for <kvm@vger.kernel.org>; Sun, 02 Nov 2025 23:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762154364; x=1762759164; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o0HFTQsa219SiFwfMSsmBPJDLvHU+B5q0B3I9fdpwts=;
        b=pZTuHYXgDAQMyaluM61z/NUOFCySrK4lbCdS3QE0QUgBRf9SRJO20A98wSqKMqemVf
         +Z09ezg9NQ34JYqhG4h2UPX//FLPFhP2zQMIM5F7Irs586PVk7fL+fgFFR+KwyWy3zvx
         5pwRMpzZjw60pwoSIoE0GjP0RsOz/Flr43V2ZKADXe14MYrAbSkZBXmvGY3DsHfXMzpf
         +VAd9O4Z1Y0OIiFnDWGzag+qiFGWGHU4B/o2PI/+8mYxbMk3Dzu0UDAzitDGVOPxnt2u
         H3MaspsDN3sw/YKYQITeZkblmxLHgeJk2umFv/yuoi62GcIyqTrpW780+SOTWM12rU7n
         aXmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762154364; x=1762759164;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o0HFTQsa219SiFwfMSsmBPJDLvHU+B5q0B3I9fdpwts=;
        b=jlfmdSAwOH/kwvCFMaG0P4dB5I74WIgrvPB5o5tgAS6cYa60DuyMB+U2mQhfFEGkWc
         E1pCmWYoZwEnA80koC9GF5GXEFC3GcTA87dhrQjv6WrV829ZEbwx8SFtIlPgZG2EwbfQ
         myX/Iwz1YZuD7yCA1Lm4iyUdwMzOWVTAgPUegowKMrVtXC/Ex6W7wVPPFg5IQUj9VhIv
         q/0Mm+KmZT0tBD3covA/z41hkwxa39YF7Kvl1dYIAtef1rcE0gNJW0qINCyScf8q1WYy
         9gGXLKxzAxfF+eVz7tGUcKss0HFzo0liEadENPD3/t9IBSRbtuQ7L7pKsZPgfOwgcN+H
         R6lg==
X-Forwarded-Encrypted: i=1; AJvYcCXle6HN9iuiUqWUsbQlNH/JQBt43KnWAiKYxGRZWBFzyYqitSG4hOVNkKNk0aRACW6OGNo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbQ9DSt4MehxulXBn4ciiLadpeETY7Eg67glLhedYkdLlrCHIJ
	1x8/UqY5bOed0SLFVs3vPohh4mgwyGVlq8AeqSkLAtFYEKCSUy2glDZT3YZ5WbbP0w==
X-Gm-Gg: ASbGncuPh5gob5vy2uRxdOejhrYyXo/zrYNtn9KNyG98ggQKq8/684e8YSQAPj/QR+b
	scvNMFcvML0N+mb/jDYHb5mOdwCiPNrn8i1ijzA1kivAl0kmWhUvPww8MGk1ZNUf3pMm4tFBxQe
	vIq3XWxpBuJmAM323JsjxR841GNqG+5y6Bmr4MdQs0flhoeL8bmPFuI0fKUyvMG46GIoBaTPM0+
	g008jXYqZ50Rpgfj0QJhqL3HSheyiM7XyL5slzmK8aFT1TAapNX9h5voonq1Fdo+jis7N9vHzk/
	v/3srCYyQI+G2C+ncW67HMce61d5Udbg1X0sh5Mz1Y1AqdcMkvO+ybXLH+OK76A9PV0uNYvoM8D
	mU1CKqZNMDkpzBI6TL4eV2mGfyTYrTzVFVftM7u+7+jt2XD/r7YYaZ/hR79w5Jd54C3I+eks4fY
	JDGATjHWrZztH1qA1d40+4YQ5zzB3Zgm2QggsZAd8j56iCwfML
X-Google-Smtp-Source: AGHT+IHBQG+HPW97p+DH7DuUW/9lAGzWwwSGGkvrgXSHhhLN9zwUvIOn1ehyN1vXIvTruEG3QceI6g==
X-Received: by 2002:a17:903:228e:b0:295:1351:f63e with SMTP id d9443c01a7336-29554b86336mr7219425ad.10.1762154363599;
        Sun, 02 Nov 2025 23:19:23 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34050992e91sm13497150a91.7.2025.11.02.23.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 23:19:23 -0800 (PST)
Date: Mon, 3 Nov 2025 07:19:13 +0000
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
Subject: Re: [PATCH 08/22] vfio/mbochs: Provide a get_region_info op
Message-ID: <aQhXcaRDSXkmPuCb@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <8-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:22PM -0300, Jason Gunthorpe wrote:
> Move it out of mbochs_ioctl() and re-indent it.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  samples/vfio-mdev/mbochs.c | 56 +++++++++++++++++++++-----------------
>  1 file changed, 31 insertions(+), 25 deletions(-)
> 

Acked-by: Pranjal Shrivastava <praan@google.com>

- Praan

