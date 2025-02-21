Return-Path: <kvm+bounces-38821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EA95AA3E9B3
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 02:13:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0797A16B359
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 01:13:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B62F738FA3;
	Fri, 21 Feb 2025 01:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OtyeFnfC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E2232C8E
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 01:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740100379; cv=none; b=rQ9FCTGYvSi9zwI5Z2OJCn5sNfnWOb/K1mTPz15DbdNusG5+jnFqLwW5OSdGhn18kMpU0KUC2yxD/hOqtAwtFxd/weYrsM4PtyCccbEZKvJJDD3+yEverW/CPz5285aZVBRZ+u0ZmKdyW8jqmhTz9VFUNRAN+s/7MaQuvUXkfmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740100379; c=relaxed/simple;
	bh=Uq7GzPfQ3uC0UiGgLsywtL1UAOYX+nwobFKbFtjrYR8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fVXYM9JEBCBgkWpTPKiXGR7LypSRKyxikimh5gNzZMZGQ/waD+bHhrxrrBV1s3rCGUie4O/Hi+MlL8So/6zFuAiKECBRd2YFUbpsO210jF1FiXY9FHUKNN8vSIvDxBk7TcZcxyj2cKAZ/Jo07ukmEKC20r4eZfs7PuUkk50oMPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OtyeFnfC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740100376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uq7GzPfQ3uC0UiGgLsywtL1UAOYX+nwobFKbFtjrYR8=;
	b=OtyeFnfC8vKGfAnuluA76oPk7WRVorGwCp7JFvzZY+wZ/6p8VUy6Lv9dqrt/sZkgb2neDb
	/iZjiOL0/yx8BSAq4lREaQ5D5LG99p55MFxNZ2Uokb0xx98P3rYZl/by2gJndJO9nk6UDQ
	3KzFo3rjhwScsSDwqbhKTYeWYM9IcHQ=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-fTud-3uDMAyEzPhHSueISQ-1; Thu, 20 Feb 2025 20:12:54 -0500
X-MC-Unique: fTud-3uDMAyEzPhHSueISQ-1
X-Mimecast-MFC-AGG-ID: fTud-3uDMAyEzPhHSueISQ_1740100374
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2fc1cb0c2cbso5077811a91.1
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:12:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740100373; x=1740705173;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uq7GzPfQ3uC0UiGgLsywtL1UAOYX+nwobFKbFtjrYR8=;
        b=KknCGQswSM7KIPqPqnMWtzgZHL203Sdj6i6JAW0cUlBtuxACLT16wPup5wvGxpIqkn
         L/qtOcDyzgJic9q0V2YtL6rSsw8ZHjFVACsnJtTvUl6SGvdGUG1pdaR46dXI/242diR5
         ZYaHLdhckG+OqFnjwS63fN+cyut2equyfCt35sCSgwATlunkhfbIbm03OnRxOPjmDeyg
         jydZEy/cgdmifa0y6EXVJVXb06eNo7gQqvjRmjp3PiE/gQdKMcVr1jIvghjExBAXXbBf
         wcCY3dzyv7Rw+cF20jlAA0v10N94unO4CZwzng/OVrx4eg1US5mpnoHqppSlvbOvszWG
         ysyQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4vwvgjHJ/8XSCVAj1SEq6bPvlxdhbY12LYGn1UXbOBaGIvTDsqs82f6x2gdM/3p583k8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzympHTCNuJUaMYCvtBk1KyfD4dAmlmAMhnb+dCRLV1sepDUVG
	hHgoPGjNn4IbIFuzgBdlEb32XFxZTos3mx0aO9kCKIvKIdz8jJ0GZUKXBAxstr00mwFgPvKl8LN
	1BH3VU9yX4/i5RS7DbqtqHI0R7V4GOrM40EKAIBeHBne/0woVo920RQuVsus6rj8LJuSrQqiMbW
	zMJHCi4gz9JvEBqMmhNsUgprFFaaqX0YhVzMLIwQ==
X-Gm-Gg: ASbGncsX+ob3IyWcPQNf/4olCU209H2uEd3xaSwxGuGi4+DMMlXup82KIjXA17D51/5
	pLcFXUPCjNzKczBu6o7AAC7NHbNhJkpf/rbsyXEuKakOkg/3k172FlVzqXpB/OMg=
X-Received: by 2002:a17:90b:5310:b0:2ea:696d:732f with SMTP id 98e67ed59e1d1-2fce7b271a4mr2148901a91.29.1740100373608;
        Thu, 20 Feb 2025 17:12:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGnQJ9hWU4v+2TwwECUtm6Pf8c9YX7B6ZUHd/Hqnqd2kx0Bc2ftH5qx2hCH5z2BE+GZRURxv4Goas3NlmOaXUg=
X-Received: by 2002:a17:90b:5310:b0:2ea:696d:732f with SMTP id
 98e67ed59e1d1-2fce7b271a4mr2148854a91.29.1740100372927; Thu, 20 Feb 2025
 17:12:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250220193732.521462-2-dtatulea@nvidia.com>
In-Reply-To: <20250220193732.521462-2-dtatulea@nvidia.com>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 21 Feb 2025 09:12:41 +0800
X-Gm-Features: AWEUYZkw-CTw854l_MFE994dYvtfLs30K1XdrnaRr8wNLayyzmZm48vwiDxgk6A
Message-ID: <CACGkMEuUsh-wH=fWPp66XAFeE_xux-drf1gatSQSiGuS_rO_zQ@mail.gmail.com>
Subject: Re: [PATCH vhost v2] vdpa/mlx5: Fix oversized null mkey longer than 32bit
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, virtualization@lists.linux.dev, 
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu <si-wei.liu@oracle.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Gal Pressman <gal@nvidia.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, stable@vger.kernel.org, 
	Cong Meng <cong.meng@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 21, 2025 at 3:40=E2=80=AFAM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
> From: Si-Wei Liu <si-wei.liu@oracle.com>
>
> create_user_mr() has correct code to count the number of null keys
> used to fill in a hole for the memory map. However, fill_indir()
> does not follow the same to cap the range up to the 1GB limit
> correspondingly. Fill in more null keys for the gaps in between,
> so that null keys are correctly populated.
>
> Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
> Cc: stable@vger.kernel.org
> Reported-by: Cong Meng <cong.meng@oracle.com>
> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


