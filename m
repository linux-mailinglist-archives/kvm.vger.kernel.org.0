Return-Path: <kvm+bounces-38402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ABC14A39515
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 09:22:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2966F3AAB2D
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 08:20:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9BBA241132;
	Tue, 18 Feb 2025 08:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RhRxyWMa"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C76424111B
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 08:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866527; cv=none; b=tpapN1TnCVYvA5f4DAEcP2xlprfnjr2f5WMrWBoV3kkZN6pPGDkNyC48ooDgd1N05RH0catlZqVlIoZoO2vPv7H6ryMjfBiW0UB5rN8z1jKb+AstOwFu2bhltUVVyWzxU0BV0nosCxGxerKigJqx8NeyJyOvhrbdNIJbJdgKkf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866527; c=relaxed/simple;
	bh=4d7dH4tkF8IEZWbA351ohEadRAb/aWdFd9TsfF1l29s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PuU43poKbyDJoMhyULGQWmPtbwZhjzGYJnhr5hMXb/S43rcoGZkC5d75odwhU1n0Qy2H9cbZ32O+AAKwop2T3WcGxM0SUpgPSld3NjnGi+juB+7trufx4sGp5HT+/Z7jqR25kuilOJ6LBVGIfs3S7e1Yw0DdENZhnulouSfcrF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RhRxyWMa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739866524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j7GHXQVLFtRp3ANseK6eUERZ/mhzkiAQmFxjXulM8Zo=;
	b=RhRxyWMaM65FtzQrxLUok/49M8x1YzGhY2bZ4OQYRzY5Nfj2kHctyfRtICRj9A/aSwdWVE
	yotv4SjV6ysjMlpX7d8Kol+Nd+ekePO5Xt/frt2GgIG0srLVhxBdKzLbr25zHwDQINdb/Y
	ZjPNr/L/5/Uq+Ag/ilQ14otQc+gzCio=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-se19Ds3EOgGCBPg1KkYIcw-1; Tue, 18 Feb 2025 03:15:20 -0500
X-MC-Unique: se19Ds3EOgGCBPg1KkYIcw-1
X-Mimecast-MFC-AGG-ID: se19Ds3EOgGCBPg1KkYIcw_1739866520
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2fc1c3b3dc7so9562801a91.2
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 00:15:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739866520; x=1740471320;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j7GHXQVLFtRp3ANseK6eUERZ/mhzkiAQmFxjXulM8Zo=;
        b=Qdj0e2rY1XAYci/LQz3czT+CBiEaRhY9cKlU9gVxoOzHY+VhI/yk1ZwhSrxRMdsjpW
         6Edgi2Dh8aNzSjWBvwpgxID8AYg5FXUJ5XGG4cgGmXLvqruyZP92ZKQfmOFczq9n/6Yl
         yJKAtVRpmctsIZiu1y9BLZzerDxSa50TfS59k7gN5bE5Z4w3K/XVvVVF8iUHrzaCSO79
         XfBzQ7CDtF1Dbt+G5lrEbNsCNSwe1rtDAT4qxXQBewNkwKSKYZXcijAJSTPW87K4srJS
         stcTOA5w2bd+bY5PYTClu8IqN1NRWO7c7N2ZPlc6JfgjIHNLSz217imLe36R9w0nbaRJ
         FAPA==
X-Forwarded-Encrypted: i=1; AJvYcCUS/vd2LvQ3ZZfDi/PcMTYgI+Sq7Q1W7du8cAbVf2t/Uik/45la7ejfFXoeKztJphtaN6o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnYjnknM3QyIlKv4pRT10E48XJVfWUOYmiBq7LT6XEsePOXgfW
	9LTzODzmkeFeLJgG5IUMP4u5inbjSnjZ9ren6B20TTr4PD9gczAMUMnEnhhB7dlZSeaKKEoiUBW
	hYSC9XqBzKnAdPcK1Z/LLcmLLy6L8YyTYgWZhIT1fey+xVfp7cA6M/wDJQAgMBbSFfR+ywTW27v
	RQ9Z4GkxAmWxKir01h+jucM10R
X-Gm-Gg: ASbGnctg9btHN3+gxjNbXnq7F1HsgNeIindQNBD6T0Rito+Sty3zBFJQkPFKSSYFKdf
	6N5W4IT+6qfp50Wa5WFxvfkjbQdUh2ggBn+FazQQw5YnHr0SeB5qfzvqSKM7b
X-Received: by 2002:a17:90b:4a81:b0:2f6:539:3cd8 with SMTP id 98e67ed59e1d1-2fc40f22d0fmr23359636a91.18.1739866519756;
        Tue, 18 Feb 2025 00:15:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE8sG5MmJpDjalMTr/uoLqJmCBZKgB65yw39zpNwpvQ/c1ljw+ptNbDRRyVCRGv34rDLEx/rjtyse/nlYZVsWo=
X-Received: by 2002:a17:90b:4a81:b0:2f6:539:3cd8 with SMTP id
 98e67ed59e1d1-2fc40f22d0fmr23359607a91.18.1739866519456; Tue, 18 Feb 2025
 00:15:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250217194443.145601-1-dtatulea@nvidia.com>
In-Reply-To: <20250217194443.145601-1-dtatulea@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Tue, 18 Feb 2025 09:14:43 +0100
X-Gm-Features: AWEUYZlSb2AcHmrjElPSu3z2kApA0bfKQBoGNMw34RhkdhIFFmh1ojpHP4uAaK8
Message-ID: <CAJaqyWcXcW9U7a1bMAngG-eEjw6t5T3XPUdn_hai5OWWTQW85Q@mail.gmail.com>
Subject: Re: [PATCH vhost] vdpa/mlx5: Fix oversized null mkey longer than 32bit
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, virtualization@lists.linux.dev, 
	Jason Wang <jasowang@redhat.com>, Si-Wei Liu <si-wei.liu@oracle.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Gal Pressman <gal@nvidia.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 17, 2025 at 8:45=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
> From: Si-Wei Liu <si-wei.liu@oracle.com>
>
> create_user_mr() has correct code to count the number of null keys
> used to fill in a hole for the memory map. However, fill_indir()
> does not follow the same to cap the range up to the 1GB limit
> correspondinly.

s/correspondinly/correspondingly/g

Sounds to me the logic can be merged in a helper?

Either way,

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Thanks!

> Fill in more null keys for the gaps in between,
> so that null keys are correctly populated.
>
> Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
> Cc: stable@vger.kernel.org
> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> ---
>  drivers/vdpa/mlx5/core/mr.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
> index 8455f08f5d40..61424342c096 100644
> --- a/drivers/vdpa/mlx5/core/mr.c
> +++ b/drivers/vdpa/mlx5/core/mr.c
> @@ -190,9 +190,12 @@ static void fill_indir(struct mlx5_vdpa_dev *mvdev, =
struct mlx5_vdpa_mr *mkey, v
>                         klm->bcount =3D cpu_to_be32(klm_bcount(dmr->end -=
 dmr->start));
>                         preve =3D dmr->end;
>                 } else {
> +                       u64 bcount =3D min_t(u64, dmr->start - preve, MAX=
_KLM_SIZE);
> +
>                         klm->key =3D cpu_to_be32(mvdev->res.null_mkey);
> -                       klm->bcount =3D cpu_to_be32(klm_bcount(dmr->start=
 - preve));
> -                       preve =3D dmr->start;
> +                       klm->bcount =3D cpu_to_be32(klm_bcount(bcount));
> +                       preve +=3D bcount;
> +
>                         goto again;
>                 }
>         }
> --
> 2.43.0
>


