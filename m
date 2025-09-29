Return-Path: <kvm+bounces-58956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 29140BA80F4
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 08:06:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4AE7D3C0D22
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 06:06:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74CEE23D7E5;
	Mon, 29 Sep 2025 06:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d4kR6gL0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A1B238C36
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 06:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759125965; cv=none; b=tdwPuW45gkRKhnAR9XlH5OOtjiHRTlv3ETWk2aPTvYw+cyGCVj5EU9R/Cbd96ZwXMLcjk/RW0LFCKTzhIHaezamZnTbW/ETs5zy+1yuVKzl+/2BtrIB+wmbiYllfC3o5MrMSc27LGQ+67eMSBbdV4b2Y+j7WUtkxRzfmhz52WSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759125965; c=relaxed/simple;
	bh=4ZVJUKJcStOkfQvNu132ByH2QSL2oYRTRtM5t2938z0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eYxgBwTGU9PdPbh5HP0BjrzT3msk3pm1HEK130qLmlDm2KdAgDwlm4er5M+/FDJomy4hb4oLrOe3JFtIro74Luzhm6VaYCwXyz+AEdPl+Vx9Nh3J6w3hlt3Zqofa4X0VwM5SnRGVB+GRADpbxot/yyCRuyM8xn/UziVwWbJjj2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d4kR6gL0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759125962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h1yGIQOsQZ3m8F6SURAT4ync4Dvco6agAIcb00xK3BQ=;
	b=d4kR6gL0gn0UmGGornCv3+kMmEB5AUYf7xmhPYMe+RDqDNeBVL5W4pQBdhMjcMI232BvNL
	0Du2N2pOUJuNW4lXiSEEuTbJv9N+V/ZpTHkhu/Th7NN2Pc6+4XA+Ky1eJaFaxTUZKYJFaM
	iAA2NOqtk7HupDyTzkuIB5LXnNT2VNg=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-43-5XUwLGcsMHSQ-quI2NClFg-1; Mon, 29 Sep 2025 02:06:01 -0400
X-MC-Unique: 5XUwLGcsMHSQ-quI2NClFg-1
X-Mimecast-MFC-AGG-ID: 5XUwLGcsMHSQ-quI2NClFg_1759125958
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-744bf8a764aso56565487b3.1
        for <kvm@vger.kernel.org>; Sun, 28 Sep 2025 23:05:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759125958; x=1759730758;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h1yGIQOsQZ3m8F6SURAT4ync4Dvco6agAIcb00xK3BQ=;
        b=gsncuZfRPnyZzk4RWIBYaSZNyvMr42QpJopNXrj5OIb44mlxI5Rgue56NnEZNzr4b8
         qRxcMs48vrzd6KtuO41Wk9k5pZGBN6GQSQxjcbyo8agVCQfQPbb9Y0Uv0bh7zP7icL6T
         XEdI2j0d95ISQUc36CDjWos1OeYhfquM/89oDOoHKOSLREHP3s++5hR80Ke7vDvCes3b
         +w0f1Tr01U7WJE+mG41GNAA7Ry2ppSYtsWg4sGahmxxCwscQPbjkRn7g/6JUvmvDKqMw
         +z2xkMDT9V5AVEgpC+qCSbX0rvP72YbbygsqtHO4MfIfNgdKpQLu37xVn8W8cmGRh9Uv
         lmvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpvz6hMCjIQnYIvRvE/lCnPf+/is35InvBF6Ul7+XKuqtTiPbbQ6nnGXvWBOkIm9i0hzs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyshD9SiSnN/4SYNga88Qd4xKW/R93yRZvz9JXDGTcgpQ50JuTx
	hwgvCgfL8qenPqvIP+oxp6zr0phJWqGKv3eCMBz/sifLS26b5PAduIv0hPEBQa4Pd4CHxMngcf9
	n2RwlUz5J7wg4n9aUbK7s7DZOTed/dQLUW5WdViBGenotkEVJYR9fXRGCzg8nFhgxKYvnlvPb3T
	ZtEKQ0pRoWgxXKBjAugBxE4L65siiU
X-Gm-Gg: ASbGncuL0xZyiMchU7qQWuqHdG3NB6UxNMNbeYZYiDtp6FKfvR9YVFMWNGK9L6Bhb4j
	c+/LRHvUVAsqmSmYCJlkHltYFfPFMH7DwX2YSE19G8Ro9zFePKMeqYdZf8sdSfodoGl1b+d7PSr
	ucf6aFA9guCPDMyoSx67GVtaEDbsbXvWiF/5d05tJ8n5C1HmXJRkrAohsFVWgXaN14U8US5+s2c
	irL+mcr
X-Received: by 2002:a05:690e:4289:10b0:636:ca97:d6d2 with SMTP id 956f58d0204a3-636ca97d773mr16173575d50.20.1759125957876;
        Sun, 28 Sep 2025 23:05:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+BjaVuGyoNFx3yUGngOCBRLm43JB3sIAw6ThgC682NtQbB9nf4C73RlWOHPZlMIy2Osnpg0Z6d8vSJeF229Y=
X-Received: by 2002:a05:690e:4289:10b0:636:ca97:d6d2 with SMTP id
 956f58d0204a3-636ca97d773mr16173546d50.20.1759125957498; Sun, 28 Sep 2025
 23:05:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aNfXvrK5EWIL3avR@stanley.mountain>
In-Reply-To: <aNfXvrK5EWIL3avR@stanley.mountain>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Mon, 29 Sep 2025 08:05:20 +0200
X-Gm-Features: AS18NWBs1i9BHagRuYUX084a7zMJ_6ylNkBNHWiX3YPpcoyysxZQU5lwQENWqTE
Message-ID: <CAJaqyWfBoY0_X=xRnGBecDFUJqSJEitgVKzopumA4fsZVfC11g@mail.gmail.com>
Subject: Re: [PATCH] vhost-vdpa: Set s.num in GET_VRING_GROUP
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 27, 2025 at 2:25=E2=80=AFPM Dan Carpenter <dan.carpenter@linaro=
.org> wrote:
>
> The group is supposed to be copied to the user, but it wasn't assigned
> until after the copy_to_user().  Move the "s.num =3D group;" earlier.
>
> Fixes: ffc3634b6696 ("vduse: add vq group support")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
> This goes through the kvm tree I think.
>
>  drivers/vhost/vdpa.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 6305382eacbb..25ab4d06e559 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -667,9 +667,9 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa =
*v, unsigned int cmd,
>                 group =3D ops->get_vq_group(vdpa, idx);
>                 if (group >=3D vdpa->ngroups || group > U32_MAX || group =
< 0)
>                         return -EIO;
> -               else if (copy_to_user(argp, &s, sizeof(s)))
> -                       return -EFAULT;
>                 s.num =3D group;
> +               if (copy_to_user(argp, &s, sizeof(s)))
> +                       return -EFAULT;
>                 return 0;
>         }
>         case VHOST_VDPA_GET_VRING_DESC_GROUP:


Thank you very much for the report Dan! that should be fixed in v5.


