Return-Path: <kvm+bounces-61514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A4CFBC21C6A
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 19:32:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D8AAB4E87F0
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 18:31:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B17E365D39;
	Thu, 30 Oct 2025 18:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Gg+iYOhC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75F8185955
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 18:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761849085; cv=none; b=EK/h1bUSVuvqiSEcs/bKQr6Jih8KVOiXBrU8QnhFbqYcHO7nH4nLVp1hU+ZYGYoJ2HcI1ptt/X//V9b9gRxPoDYGsNSak94WweriqcovUGs9eEBkY9lF61XN1LZ9rVmIcc0KyehhjjusaqPtY+h/O7c6JMFiMS1mUjzjHGXlew0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761849085; c=relaxed/simple;
	bh=5RKHu4yQCVaI/k4lkpmrIBeROuwDpbJHr1wtuuLkbUk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DCPPLFBu2ctyM2j1tUjBymMNkW8T/AxTyAwGC1I6S6cl8V2RtZb/5bS2tpPpeNZIq5UZjPTuGUrrR7/aR4ox/QlH5v3Gl2CppeEdoPQD0T/XKrH7hNbF5KBLWzcaVTagp9hGR3FTQBoN9uARDi5427UgG2pOxUogBXXrESGbFT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Gg+iYOhC; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8801e4da400so11495806d6.3
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 11:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761849082; x=1762453882; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YmA1pUSO6eHGo1pfWERtEyAsYO8fk0tMGzPgA1+3ITg=;
        b=Gg+iYOhC9eUE5OHVWT2jzQGdPwe2d0AkOCKhtGaWmf+O07sKhJqUCLh36ZezJMOSAw
         PufBmBzphhM2wk1lokMLIh42oPg5Fk5m7jZFqN9SwurEW30OYcZhhocqmvRQmG54pDuG
         6nA9evXwOi0kE2p9zpqqQIL5zhflUCUnOk67IrcYTk5f3/QXy3acsm46kFjhXkgsvKWW
         E+jC1AmqYPXspcktAP4A3djApFlzq8JhkCrt9KFv9kPsn4B2Nx+CPCHWRqaQ0KTU1OV3
         o5eWp2h5poS7waJtpfEOJJ7416dR3d5eN5ZpEbrRzPTLp5dDC4O+5hxdqqutsSQwY8i8
         TyQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761849082; x=1762453882;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YmA1pUSO6eHGo1pfWERtEyAsYO8fk0tMGzPgA1+3ITg=;
        b=rMN5AYGe5gCV88lUn2u0iwEnXGnqq/Y30YJJgfPl+Be6D7ZPP4kY/seNdFnknTjqus
         bl3sZ0E/RzHGqQP4HFIgtjKgdIY92wKL7aRi+P+LYVZDPwOjbqtE3Ugs+s7utDtD4h6D
         XeMxNv6oZ3Npu00aJF6gjg+Byw5NfEqfMgXy3w76JErl2AP2/nqxOw0mGnkyLBtblrA0
         H57p8UtliDiT2i1SyzZQUr/5iH9zQPlWTHpK8z1r5B4qAOEob2KhkxGy2Amhxva16dCj
         TUorcb3wh1gDRzHyrM8GjGjrOc3PwiCXPgFiy8xx0X5ZUXd4Wb1mieOPOqlTGzsDqr9A
         ozaA==
X-Forwarded-Encrypted: i=1; AJvYcCVWiQqf0SJmZAlU6E4K60kTvWOT9aOWo1GZ8VjDmpZBvHEbXm18Xp+2e/TWgOc/KdEJd1k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQ1xACEBMPgUdg8Si/TvgI8ptoIEh6LfJ4KFAL+RC2/U0mh5Hd
	st/xPZ1z5H5BSU45uggNDq4EV8QDo+Y2c2IxLtytB7pZ4xcdMAmswKgcS30DL4ZoFUs=
X-Gm-Gg: ASbGnctFgyYKfFvOqmkTW4DUE0Tuux9gPJZQQJy0uUiXosiPJQL1vHX/FVWkR+wLLtC
	EFjKoMTEGIHhYK3Jr1vCEBPFyhXKSsCGWp9IpJONJ2NtcDhTuuXfTmzrzvQB3vFJ015NnXDF+Hf
	gWhnc7xLu3ITHm1VyyZTX4522LhLQHYfhoq1Tu/vXNvcvLdAdulNMplFEtZrVn+HW+pRa70AhHh
	5fohkk6UoV/wNETnak3pNrwhT0yjTGILpwtWWNcfeCnhCX6yeAEn60nvv5+LrN63ayAFC5L1Mn+
	ZooHc+xTuz5R75ppKa9UbQNI12nTZxVV6Fc5sJ0+AUDuGWS3mj4RQ+EP/Wg0MMf+SG9YeF91Zj5
	5unGh0km+n5M/upQp4EVbRYOwSvnc+N2DhT0fKAf3T7fkxHcBJCAWbCYwkyvr7PBnnANoZ0c4mp
	K1Rh0TyVr5qYitP+jesia9zDw7hLH5dhwg4qRBo0/ztUSQSg==
X-Google-Smtp-Source: AGHT+IEv5ox+SBer5dHqatVl1R0h0YMhFs6NlP0L5tS5SfBtQ01+uSnat7aVp139Vftpn89RlMT38w==
X-Received: by 2002:a05:6214:dc4:b0:70d:6de2:1b2e with SMTP id 6a1803df08f44-8802f50545bmr7765036d6.58.1761849081478;
        Thu, 30 Oct 2025 11:31:21 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87fc48f6138sm123307286d6.28.2025.10.30.11.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 11:31:20 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vEXQe-00000005BP1-0lfY;
	Thu, 30 Oct 2025 15:31:20 -0300
Date: Thu, 30 Oct 2025 15:31:20 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	David Matlack <dmatlack@google.com>,
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: Fix ksize arg while copying user struct in
 vfio_df_ioctl_bind_iommufd()
Message-ID: <20251030183120.GD1204670@ziepe.ca>
References: <20251030171238.1674493-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251030171238.1674493-1-rananta@google.com>

On Thu, Oct 30, 2025 at 05:12:38PM +0000, Raghavendra Rao Ananta wrote:
> For the cases where user includes a non-zero value in 'token_uuid_ptr'
> field of 'struct vfio_device_bind_iommufd', the copy_struct_from_user()
> in vfio_df_ioctl_bind_iommufd() fails with -E2BIG. For the 'minsz' passed,
> copy_struct_from_user() expects the newly introduced field to be zero-ed,
> which would be incorrect in this case.
> 
> Fix this by passing the actual size of the kernel struct. If working
> with a newer userspace, copy_struct_from_user() would copy the
> 'token_uuid_ptr' field, and if working with an old userspace, it would
> zero out this field, thus still retaining backward compatibility.
> 
> Fixes: 86624ba3b522 ("vfio/pci: Do vf_token checks for VFIO_DEVICE_BIND_IOMMUFD")
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  drivers/vfio/device_cdev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Cc: stable@vger.kernel.org
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Though I feel this was copied from some other spot in vfio so I wonder
if we have a larger set of things that are a little off..

Jason

