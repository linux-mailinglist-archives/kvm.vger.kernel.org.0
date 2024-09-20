Return-Path: <kvm+bounces-27219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D541497DA31
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 23:10:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10DA91C210AC
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 21:10:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 256D7184543;
	Fri, 20 Sep 2024 21:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wy9GqyEN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3ABB17BB24
	for <kvm@vger.kernel.org>; Fri, 20 Sep 2024 21:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726866647; cv=none; b=eWcP4By+elZmyYGNQ9UEG/qL579AG2o+LdeGjmkfOgjhPCqHSHqyPY70FSii4+7tay7fhV7SAGshGf3dEX9zKaCHpTuJuBbsVaZ3ZW/HZHBH/JHYJyXZypVqP6w5HFbmKuhvn88Uu7LY6ZlEOAPZcnGV1TQIbuXc2vV0T28Bako=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726866647; c=relaxed/simple;
	bh=m+NtI7KFoRn8JqPaP71PrQB5dB7g9pqRx96cGl1zNOQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YSHL5pf7nIWgklfHdu68BHk9gybIeCJfD9I2rd5PPexMioyDq4OIo/1ibFhj5mVNotQVmLuK+MNXtbbq2jVstsBJ1fxaHPKtH1nLbFxLeWrDIOfMSTvusO3htSseR6tph8uDApphJTOdFsaq7B1IuHICpOr0eadA4N+FROnX8RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wy9GqyEN; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-53690eb134bso6762e87.0
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2024 14:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726866644; x=1727471444; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m+NtI7KFoRn8JqPaP71PrQB5dB7g9pqRx96cGl1zNOQ=;
        b=Wy9GqyENCR6rRak89lE+MmoAVFsfRhG4pPgnHcAzlv6s1K9vLr15Yqh8+fIySzyk9g
         x1/9eQXnHNbA4lbbidAvQm4cJdOuRt01xB6Xa5137qe5oGCk9d+dki5QSt7uKZWcFeUF
         Tul2tyrTaAvJihoD769elWPQonbwE/higHUHnm90zlo331Eg+uvcJX8shmDYaJdSF390
         IhOAvsXsSU4mkUKdkTWb3UP3z2UZCY6iBapVn4Tofs0z1JeA7PboIm656aXNmTKWxiis
         E+P3w+omlnEkkHu7VXV5SYYvluC8zFJwHXrLCv6ZYPAMzO9jVhXSvhAMid2BuSxRbJOj
         wgPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726866644; x=1727471444;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m+NtI7KFoRn8JqPaP71PrQB5dB7g9pqRx96cGl1zNOQ=;
        b=pn7Mm7Z9QIeKjLZ7S4Crsc7KxMj70kW7yissK3mu6e+LmI3e+sAio+dQ9ni2Xz310m
         wXUOUm+nqYYWYDeTiBjnlOVaTv/+Qf8Ro1NFknrgUwANaVRwe1qFw5so8BfD+jU8iiCJ
         4CqeTMJxWlKDMSWWIARY5jGV4QyihC9bgKYvvbDmkSGe2R/bMxvAFgOYqQUeycdWFwnv
         yzEJAemGmsqZRWR9z+i2QqJni4YArlUJgBRihIKD2sXkI4SQr+3V/iycvxVAefw5c16A
         eRo4uVFp0aCXYtR55QZxSU7N9kbylTT7UKuAXlm/QtiJZQlH0Z0oJIogomgkTHoItTi5
         6IXA==
X-Forwarded-Encrypted: i=1; AJvYcCXKgXZlAqexoM43cMMQCuR2RlMulPtTtwudEfEUlG5tnQT8bH18Tqt9G2QDPAer3XMxFx0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzsYa9BBd80y0GWCDMW0EVP1LcEbSD1Ax5IuLHt03f0p2OutEP
	mFvH87Fg3E+tRUlxXyaHK9Y/VIhTycEGmOOfg6nFMCElA/aUDcfAzIeMYPV/7RZJSHBzbIZb6eS
	4pU3MDPOunaVAIEggPwdVNfEaDhfVeMo6BX8T
X-Google-Smtp-Source: AGHT+IHbQ1owfwv0bwXyOysxmcbe5slLoFbMmljycd2jsECKG87UWxrZhXYcSekvu/JQPuY2zRUCE12merz5Ttxczic=
X-Received: by 2002:a05:6512:3f0f:b0:535:6a42:90f2 with SMTP id
 2adb3069b0e04-5374fd2163fmr105932e87.6.1726866643470; Fri, 20 Sep 2024
 14:10:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240823132137.336874-1-aik@amd.com> <20240823132137.336874-13-aik@amd.com>
 <ZudMoBkGCi/dTKVo@nvidia.com>
In-Reply-To: <ZudMoBkGCi/dTKVo@nvidia.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 20 Sep 2024 23:10:30 +0200
Message-ID: <CAGtprH8C4MQwVTFPBMbFWyW4BrK8-mDqjJn-UUFbFhw4w23f3A@mail.gmail.com>
Subject: Re: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org, iommu@lists.linux.dev, 
	linux-coco@lists.linux.dev, linux-pci@vger.kernel.org, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Alex Williamson <alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>, 
	pratikrajesh.sampat@amd.com, michael.day@amd.com, david.kaplan@amd.com, 
	dhaval.giani@amd.com, Santosh Shukla <santosh.shukla@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Alexander Graf <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Lukas Wunner <lukas@wunner.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 15, 2024 at 11:08=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> w=
rote:
>
> On Fri, Aug 23, 2024 at 11:21:26PM +1000, Alexey Kardashevskiy wrote:
> > IOMMUFD calls get_user_pages() for every mapping which will allocate
> > shared memory instead of using private memory managed by the KVM and
> > MEMFD.
>
> Please check this series, it is much more how I would expect this to
> work. Use the guest memfd directly and forget about kvm in the iommufd co=
de:
>
> https://lore.kernel.org/r/1726319158-283074-1-git-send-email-steven.sista=
re@oracle.com
>
> I would imagine you'd detect the guest memfd when accepting the FD and
> then having some different path in the pinning logic to pin and get
> the physical ranges out.

According to the discussion at KVM microconference around hugepage
support for guest_memfd [1], it's imperative that guest private memory
is not long term pinned. Ideal way to implement this integration would
be to support a notifier that can be invoked by guest_memfd when
memory ranges get truncated so that IOMMU can unmap the corresponding
ranges. Such a notifier should also get called during memory
conversion, it would be interesting to discuss how conversion flow
would work in this case.

[1] https://lpc.events/event/18/contributions/1764/ (checkout the
slide 12 from attached presentation)

>
> Probably we would also need some CAP interaction with the iommu driver
> to understand if it can accept private pages to even allow this in the
> first place.
>
> Thanks,
> Jason
>

