Return-Path: <kvm+bounces-61520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A59E1C21DF1
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 20:10:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADD0A1AA06F7
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 19:08:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87C77374AB8;
	Thu, 30 Oct 2025 19:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZckXw5vU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EE636E354
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 19:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761851244; cv=none; b=IlCguEi475oNb98Y/DC6a6owebaAxud5Fkm1JSAXCUhib8BuDp08gYBUEiftOQwupdJUFO6Bof8gnqvqsVYCIVMD4mHSn65y2XbKPe0WWb4w7vsis3On1Ew60PEDtV/0AI0jFN4kPaBG+KZvHhlTo0gXHyd4ghCk2DaY+duWhmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761851244; c=relaxed/simple;
	bh=DvFyvNSh8qxl399ZX4Dvk2UH8sJtqfrtdkTSXiS2O28=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PGrCktHsqhKOetu3tcINVAFgqLo2xkk0lLxuS5TB2V6yRXGow6Q6wgqwH9gJz/VDW6n16ETCYZBoXdL7ojtOnKXHIYgVCTqDMUKIveAInZwg/J0xtH7CS0UdiGFn+kDLDifRkIJUTUXVhqVzfagmYXg7RmGWZtLyMRgNyUASCbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZckXw5vU; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ecfafb92bcso65241cf.1
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 12:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761851242; x=1762456042; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PCoLCqthfjlxcZmXPuVo/a5TDaJzLCC0xdNynQX7McU=;
        b=ZckXw5vU0LXRw4K7WamRpYd/12eb909nfOJSCoI08y8xTLLYR3UlS/DHzw/12P+TVT
         WG9hLNIW8f5kI9IjFfPGFdWFJMouX0MULieJ838fZCCc1+PCDzM84UwKh4K1ij6ejU6Y
         xGE6IcMP/05CscvVqu/k/KQctwKgLT0Lk4Te+zPbS1RIYaNxHSKApG2/pfkSibhFMSsA
         eitOA0vQ2U4ni8qXfR7iJiFLC6lDYcuaT/zs2yQpKQ2yV4DgWKO0wAQ8dJYqW+3gCOQg
         rN2flXr4dd6UlmO7HwBbzO3VGPUlNaiUz+flcw9qqCPxtcGQF56uzothabnGPvYrXGFD
         dcJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761851242; x=1762456042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PCoLCqthfjlxcZmXPuVo/a5TDaJzLCC0xdNynQX7McU=;
        b=JpyVkKANK8/0h5WrVkKfGM6ibad0+W1pQ6wKvzmfG0wJ+0ei4r9MewPBYvNCGne3JG
         I0zjJKrwiRXxjvky7ncXDL+QkGmcWaQ9FhyS4Tc/mrra9eyn8gI+ftithbKr7ijViDkz
         vyuq7Zp7yFY3F19Jh0Z8xrdMEOmaZfBdQLojTQIj6OCuxsDoGNTXA6XNE5PnEaqRc4F0
         /jkSLB46/HVytAUkI7TXdv62qbd1qoxD5qWP1+QySMG3SL73js8q8SdfUiscxITYbNRj
         y/qlWh4JWFHW7pj3oIgqyTQmq+GKWladeQjeQx17zxb6IDj3/pvtyzVqdPsw1bp/cSIA
         OEGw==
X-Forwarded-Encrypted: i=1; AJvYcCX9wbGlcE/VGpJuvajO1js9cdwUUjuFq1+af+2fsYelyIJOTs7fAYY8RGcrSjq+/+Nk+gA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3OlIz428gXG8oQ7cWrM0tDppW8SQ38cykmu/EZT4wC4aFDv51
	n4d6Ni6EMAA2VKB2NpQlgZ3n7tO0A8EG/0fXKNhSo0+rRqfy9fneC/KXPRCKfT9fpFaRZgpEe4v
	9uxefm1ZjbzSp+RUXPdonZycrbvDH1EL6NOrdd5Cn
X-Gm-Gg: ASbGncuoLAAfdQ5neTnBdai81KamrVUM1Af1YtL29oGT3kbH4sHlNhK6Fah3zsOyIam
	ELIzhOpV7PXB+yTo+A+TnmBSI8F8CvPY1hSh0rZFEqnnkojH5LAaEFHh4FMB8QUIYR58C4izIG1
	YYUP7XoAMYQT1BUs9WxjYqoGRqp8XrEtBzdRi3B6fVviPSsTFqLlWBrt++2zJbV8GTKI7x/HQGS
	fJARYLLXwOcnNyxa956h5aGblXvCn4GA920rbexjGuJDdcY/rQL4Um5mh35ju4ihfqh+sWsfXN8
	OsOYLV1aiaq9gXLFxetBYWDvsw==
X-Google-Smtp-Source: AGHT+IHkIhJCo7NFdaHLBFyJbonDCNFLcwrhYELkE6OW4OeZdx3rf5ADytg1g/CT0hOvRfBwqeiJwH0z6jqJ9LzJDkw=
X-Received: by 2002:a05:622a:2:b0:4e8:85ac:f7a7 with SMTP id
 d75a77b69052e-4ed31f3529amr938991cf.9.1761851241873; Thu, 30 Oct 2025
 12:07:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251030171238.1674493-1-rananta@google.com> <20251030183120.GD1204670@ziepe.ca>
In-Reply-To: <20251030183120.GD1204670@ziepe.ca>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 30 Oct 2025 12:07:10 -0700
X-Gm-Features: AWmQ_bmODnSgIiguqq9wgyDj-h2iOZbOtTbAP3dhn7MpDJGiXfBAH1fV5zpiZRs
Message-ID: <CAJHc60yMgzQL9VT-K4GuDa7ZAYfNBi3Az3nnZTgd+RLYW+3iTg@mail.gmail.com>
Subject: Re: [PATCH] vfio: Fix ksize arg while copying user struct in vfio_df_ioctl_bind_iommufd()
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Alex Williamson <alex.williamson@redhat.com>, David Matlack <dmatlack@google.com>, 
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2025 at 11:31=E2=80=AFAM Jason Gunthorpe <jgg@ziepe.ca> wro=
te:
>
> On Thu, Oct 30, 2025 at 05:12:38PM +0000, Raghavendra Rao Ananta wrote:
> > For the cases where user includes a non-zero value in 'token_uuid_ptr'
> > field of 'struct vfio_device_bind_iommufd', the copy_struct_from_user()
> > in vfio_df_ioctl_bind_iommufd() fails with -E2BIG. For the 'minsz' pass=
ed,
> > copy_struct_from_user() expects the newly introduced field to be zero-e=
d,
> > which would be incorrect in this case.
> >
> > Fix this by passing the actual size of the kernel struct. If working
> > with a newer userspace, copy_struct_from_user() would copy the
> > 'token_uuid_ptr' field, and if working with an old userspace, it would
> > zero out this field, thus still retaining backward compatibility.
> >
> > Fixes: 86624ba3b522 ("vfio/pci: Do vf_token checks for VFIO_DEVICE_BIND=
_IOMMUFD")
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  drivers/vfio/device_cdev.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Cc: stable@vger.kernel.org
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>
> Though I feel this was copied from some other spot in vfio so I wonder
> if we have a larger set of things that are a little off..
>
I could only find vfio_df_ioctl_bind_iommufd() in vfio referencing
copy_struct_from_user(). The other closest would be in
drivers/iommu/iommufd/main.c::iommufd_fops_ioctl(), which seems to be
doing the right thing.

Thank you.
Raghavendra

