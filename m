Return-Path: <kvm+bounces-37542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A9D66A2B7F8
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 02:38:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E12101668D0
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 01:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6213114F132;
	Fri,  7 Feb 2025 01:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="bB247ib2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4B37DA67
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 01:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738892319; cv=none; b=CNGlOvGKRh256kUKGYYxguUVgd46XsyGw/CX6/0UX5IgbtFAKY0SRRTd/Tn5zXmoSPu43pQTzDy+THB3SVyHkqurWrhZKh3tX/BggbQrhff8feFvntk6B1+OS7+yfb2ghzNKgygDfnesC0u8wAHTvxph6UEgMolOmb0NmLwcmAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738892319; c=relaxed/simple;
	bh=8QxwNQ5F3lUg16Ouo7FY/KDRymPfqKZizz8JYgXMkC4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SFdqgPyfbUFerzc99P+fWKBYaFjD/ECitHqFHb1Oeb4IJvYWrnfGKNSeAFmLL4yBGPiSJJAfRtfJla3PVlpOxBN2j6dAN19jlizeim0VPT5Ce1XYDWgbqVzZb7ehuAuztDY58UcWEkngz7xLEnrFd9ayMooaXZ9+vgUtdfOA21I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=bB247ib2; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id C47693F85C
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 01:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1738892305;
	bh=8nlGza3bUYWolDa4VjQUob3ri6m4nok96qBzN8kMux8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=bB247ib2lBdbl245giIMLA84CUB/dGatMjnczArAC0Nwzqh/aTLnSOZ+YT20PPM1m
	 du9KZi1ep488f5a92Wih/AtO2kfz+3XeqvMp7YEJS7GeY9n73JtorvkN5Czd7WeQd0
	 5UQswNKqX5ev+KhJhzrIbg0rfaPRWXGXTSWLcfB67UrXCmqtWaHbhl1ZO+cbPsAFk+
	 rlNvLGeOm9BGxIRU57PtK+f+6WlWcSRdFOypwIFvdN3cJQorYo6KTmvJgBDv6oFlzN
	 uHY0Gv3+015FRVHTHDk1iudZEb9bK4m4aTdaaA9y/1Z+Rz7C9g572kd2qplizXW9Es
	 8Plz0f8q+Pd1g==
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-ab76aa0e72bso140429866b.0
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2025 17:38:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738892303; x=1739497103;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8nlGza3bUYWolDa4VjQUob3ri6m4nok96qBzN8kMux8=;
        b=VuJzYNAdS+MEFUwQltM5GLWSdjlUHQOwAOjj5AhM2sLt48rlqCTfd/zvt4jqZCqCgx
         va/iZ5fwDsP6eVC66j4BE/EDNNulbDhTqovMcgBTAEkwwOcOmXUDekwrfQhkN2TI1eA4
         E+dJCke/TqCpTvKE2H0VqS2f4ZzseYDIbRs6YesKrgxj/9/hBQZhvAAKv7cUKmbGXFIp
         q+KLv0kDxYKmPWT/X2tKfKuejOdOgnyJneqkj+It2hrwhb8mZQaEypv7SPNcVAMYiGlq
         b+zmm2faa4/JkV/IELnnAoJZZmnVG+XQBKIj2E5am7jvWvqLUORmRytSzUyvQ9hi7xSV
         8BVQ==
X-Gm-Message-State: AOJu0Yyz4HDmyFDIIHI1VZ6DpljglYQARFOx0R/Ur1ZSnF6qooxeIktK
	IQErOQ9QX+qnyzgPZ5kY9fj5BD89UfM8WRblHQ4noWxL/ldS14pBoLkmBBv2hwy+pL4AZbVYjOH
	H/cT2c0Xr5dmKTyYkSUhsTqKzW4LMTdTqvWDNamgD/SzHx2kaBg8Ugq8wRDW7WCUgI/nIDW8APO
	tg3yOG2M9+OP3oRzwVYe4BAASoNIglkOo2Avx9Iqnzr1Xn+Jg/
X-Gm-Gg: ASbGncude6K3qnKs3698ulu+Wi7fIdcl2jY8D+TwuZSDZntoyuhZyexbK201fau3iTs
	sXlpBQyUbqTzx8l8QjlZeIgPWGoYWj6p8n6xFXeIEeqmTrHcIn6ueKtne17em
X-Received: by 2002:a05:6402:3907:b0:5d0:d818:559d with SMTP id 4fb4d7f45d1cf-5de450026c2mr4564597a12.11.1738892303511;
        Thu, 06 Feb 2025 17:38:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEOx1lEvrP1pDzXVIU2a3ICbv42xHzPCxIbHrelQHrmglKbu9LnpCmZmMYgVJ5/Xsp8QKtnYeoVXGszsUYrFIo=
X-Received: by 2002:a05:6402:3907:b0:5d0:d818:559d with SMTP id
 4fb4d7f45d1cf-5de450026c2mr4564572a12.11.1738892303237; Thu, 06 Feb 2025
 17:38:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250205231728.2527186-1-alex.williamson@redhat.com> <20250205231728.2527186-2-alex.williamson@redhat.com>
In-Reply-To: <20250205231728.2527186-2-alex.williamson@redhat.com>
From: Mitchell Augustin <mitchell.augustin@canonical.com>
Date: Thu, 6 Feb 2025 19:38:12 -0600
X-Gm-Features: AWEUYZmh01IaYWfQwXAr84y1vklWSet6KnJzeaENStmoiJRcweOokqw78vsFezE
Message-ID: <CAHTA-uZK_1A1tNa_GWzy010C32wN=6ePoAp0hGZ7FToRsyr4iA@mail.gmail.com>
Subject: Re: [PATCH 1/5] vfio/type1: Catch zero from pin_user_pages_remote()
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterx@redhat.com, 
	clg@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>
Tested-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>



On Wed, Feb 5, 2025 at 5:18=E2=80=AFPM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> pin_user_pages_remote() can currently return zero for invalid args
> or zero nr_pages, neither of which should ever happen.  However
> vaddr_get_pfns() indicates it should only ever return a positive
> value or -errno and there's a theoretical case where this can slip
> through and be unhandled by callers.  Therefore convert zero to
> -EFAULT.
>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_ty=
pe1.c
> index 50ebc9593c9d..119cf886d8c0 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -564,6 +564,8 @@ static int vaddr_get_pfns(struct mm_struct *mm, unsig=
ned long vaddr,
>         if (ret > 0) {
>                 *pfn =3D page_to_pfn(pages[0]);
>                 goto done;
> +       } else if (!ret) {
> +               ret =3D -EFAULT;
>         }
>
>         vaddr =3D untagged_addr_remote(mm, vaddr);
> --
> 2.47.1
>


--
Mitchell Augustin
Software Engineer - Ubuntu Partner Engineering

