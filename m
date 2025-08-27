Return-Path: <kvm+bounces-55925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AD9CB389EC
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 20:56:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A36F41611E9
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 18:56:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 782802F290A;
	Wed, 27 Aug 2025 18:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dgsljTUm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B159C2E975A
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 18:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756320951; cv=none; b=XqIQlkXZnb9Ji3VGhQ0DvBf1cTYxWHA0ktVKBaM5PuQyUvGXWShn4giYpFbs7GzZtd/cHKz1ICXb3lKKinmWPPkJYX8rpZKej4aWFovzWrb5h1NBkPJX4USc0JgLcl1pptC8ROz77B5Na3/LH0y0ZJxVuewaHPfyF6JxxwiAgS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756320951; c=relaxed/simple;
	bh=fm/h9kjoKAG+ylWDIGT9LVnDG68OmZkrGI+etIQZYV8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DXdI/LCe3MoeDKjv4CKBhJ6Ab5t/rQ+GULgUnNvQPDoWllIhU3Yv9uaGt7m2AfS0a0XkWsV32Q4C1gAnBfYQ2to+iGcSgblEcdsc40FygH/Yqn0rToDXXSBiim1s26X6fuH+OwJWRMhfNJt9CPbB3/jpdhvgQB9kLbSsd+Cg+Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dgsljTUm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756320948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G78P2jLySbgTcoxewXgkQrFdDV/LmQT300kmZTj3Q84=;
	b=dgsljTUm4Ii2eDzrVBjvY1C/IWSs4YX+YhNlNPv5vIkDImLp9bCiZC6DZMdqGjeF9DvEL6
	V1Hhf/2sC73fwnxUSDXbMitZmdEcBk+myFMZVt/c4SBCYDNwij+IhXED7wPYsTjx57iDMF
	lNh2Foz5h8oayBfDj+eywHsGBLxOvQs=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-gjTddYsdPqqwEO5t0dIDsA-1; Wed, 27 Aug 2025 14:55:47 -0400
X-MC-Unique: gjTddYsdPqqwEO5t0dIDsA-1
X-Mimecast-MFC-AGG-ID: gjTddYsdPqqwEO5t0dIDsA_1756320947
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3e67d83ee31so200565ab.2
        for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 11:55:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756320946; x=1756925746;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G78P2jLySbgTcoxewXgkQrFdDV/LmQT300kmZTj3Q84=;
        b=AR2Vfzqu+dlR0VYZ0cepZL8oZB40g3a6a9SGe3Fyc/lWXbO8RKTotjRCoqHrAZDSHH
         JUl18VJNLNv6MbkqP6MyNnitaOc9yCrMHgRHWAi+/52aPXxAADy0g3Ulxutdiy2Bx6br
         xg+WFeugsUy8WerFL5/1+V4kjINAunjZBKa19BZXe3P4kqk6kspzSq4RpQVbjP5/Trg7
         5l/6yXrxTZOf9XUTbxV3BSiQ2yVAwKpntAH2OH7m77ZFuBKHLalf9INYEiQPC43+q0Hz
         heZlc97oyzxieQUMiRCxmRNPbMuZaRRD6kXXbYlOMQnjOpYUcgu7ChkMd6JKeKO6/tav
         VP/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWxdycUFOQ5KDNcqx7XQhh7QQNW282HIp6MHDtxUMNez17/JAWPvTONZBh6EpWPoGhoH3M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyR7to/RYpJtmH7LP6H3Gon3V2pEq54Tjt6Ykx1Qpi2eytMJWMB
	qewAAqcsA87b54EmK1l0X7mXkvYNo46KjSU7ASbfsjLy63y2+EYdzFITUjatwgeymQt273nWqoW
	2kg/G3Cvsk6Ni15JZUkZDeeZ+uWvpAFkR0qmNw5++2LKjhNcawTWRIg==
X-Gm-Gg: ASbGncthfeJfu75Uz3VeqIBUW47VGFBBFv3U9yzMfxGhwCBBkKDdUcqDqWVKBE5qW79
	AgdXkavmOfWhW1Lu/QUSBkQ5+wSxHVY2f5w0Xq9SMofa1Ekay5P1xj3Y4Bed7fjcrSVkoZww6eo
	Ep3733bYY9+AV+9prfjpCE+jedY14DGKYIxdGgKFXyPOJ9k94UFd3fI56psO199F5FSqQOQhUhq
	aay/ynalIJ7V1kOgdW5zWW+vST5HsxQ7x9T2UF77Z6eQB/AFCn3e6aGGKXYQSSTcdvdD1KC6Y+W
	hALGYdoBOwihDM/bBfjwA6TNHLCQLiWEDOjbk89qae4=
X-Received: by 2002:a05:6e02:1a28:b0:3e6:7828:1e9c with SMTP id e9e14a558f8ab-3e91fc22d89mr100262795ab.1.1756320946588;
        Wed, 27 Aug 2025 11:55:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH8WZXs1ldaE5WPtxVBCuJgwtfvCviDgiBhlB5oMfRmOE1uzeqRxAI2n1ueVCV7Kg0lvDb/yA==
X-Received: by 2002:a05:6e02:1a28:b0:3e6:7828:1e9c with SMTP id e9e14a558f8ab-3e91fc22d89mr100262515ab.1.1756320945914;
        Wed, 27 Aug 2025 11:55:45 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ea4e45c5d4sm90957965ab.27.2025.08.27.11.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 11:55:45 -0700 (PDT)
Date: Wed, 27 Aug 2025 12:55:43 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Shameer Kolothum <skolothumtho@nvidia.com>
Cc: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
 <wangzhou1@hisilicon.com>, <liulongfang@huawei.com>,
 <jonathan.cameron@huawei.com>, <shameerkolothum@gmail.com>
Subject: Re: [PATCH v2] MAINTAINERS: Update Shameer Kolothum's email address
Message-ID: <20250827125543.2ba8e56e.alex.williamson@redhat.com>
In-Reply-To: <20250827143215.2311-1-skolothumtho@nvidia.com>
References: <20250827143215.2311-1-skolothumtho@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 27 Aug 2025 15:32:15 +0100
Shameer Kolothum <skolothumtho@nvidia.com> wrote:

> Changed jobs and Huawei email is no longer valid.
> 
> Also, since I no longer have access to HiSilicon hardware,
> remove myself from HISILICON PCI DRIVER maintainer entry.
> 
> Acked-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: Shameer Kolothum <skolothumtho@nvidia.com>
> ---
> v1 --> v2:
>  -Change from personal email to new emp. email.

Congratulations!  Applied to vfio next branch for v6.18.  Thanks,

Alex


