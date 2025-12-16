Return-Path: <kvm+bounces-66057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AB4BCC06CE
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 02:14:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5B61C3022FC0
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 01:14:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAD63244670;
	Tue, 16 Dec 2025 01:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3ari1B+D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB35A2040B6
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 01:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765847667; cv=pass; b=GFDbqX0kMVxbwn1oZ4rrxVCHjhY8hrxx/OGsYeEi0m1N0tepySM1uL+gFdCUVsItaF9lWOFaw5Onjb7qSS6GiqhkYu1jjO9mOXetUptWhSx7h0a0lfPA9JNUT0RgnKDMEz7T06V1yEI73/NLOMa4ZeV8pCmk3tQGmL6C50rAcAw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765847667; c=relaxed/simple;
	bh=RYQZPJfFMxqkp+1nngNLsMaHBFm6+xCUj4KkP21+dYM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OCHi/BaYcJZLDG1Wz9wGmsJMErDEHQEO3a80tuPpFUGoaZlqtfdFk3VLfpWg074WoEa1JwwVHuWejuCexjkjQ5k72+gnHNZ07H9DLckweuPSUqKcKgY8zd1yEwEVibBJUBqZ/4WZdlrqHUTaS9za2vlhtM57cm+zQHsdyCh/aGw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3ari1B+D; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ed67a143c5so152391cf.0
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 17:14:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765847663; cv=none;
        d=google.com; s=arc-20240605;
        b=MQ31HM6C3pzACgRDGepojpiKBWjxqbowp3wiUCCeFY4KQkSQ5Vcq7bGCuP3se9PiMq
         BCilh4ekuAgZTSxV+PEPBZ5hhJ6B+7QWRJ1joD1Y7FmkgBtVG35XmPOJklzkmQAJHCWO
         Jzmg+7EhHNqhT0CYd3i7K8NKeOCOowSTDdZPrHbZlylC/QJ+QC//b9sGRO+K2f3UIoSj
         DfJTJUk+yrxFuLT/MqRoPhDquea/bunRGBLeEc1dyCtIWFttwC/AJUsrqOjTJ/EWBFMD
         PfXbsCo2D/ObBvRHjku5pG+6JGl9tmZyZSxoMfcpQwzqpHdcmTCtNZyA+6T8PfrF4dtf
         7YFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nNRSgDqjGCHm0cCbv9mH9lJK6eTAVlNyMNzHMF8cYvc=;
        fh=2hgtUdEJvhgc98mPkypp54v6FhYFPYlad9vqxHg8l4k=;
        b=LqAvc0nhwMk/S2h1TA22h4Tw3HKsk1xLgvSCPM1X//fvfpsQYUEZNHQd5k73OCjHgv
         IkAr1YKFngF/gMY6f78QaaojOyuV2Li7BaE5/xYTgYK8EVsHRY82YsCf2eVu4vBQboTh
         HxcsSEqAgHq8i2dfBJlVyNbZpLzz46mc0lRa/lQ/V27w49R/bUKXSCzWd5kJ4sosVdHC
         zhlGPC7nm07Asr1NOK/mWrr4toQ6B5QGOHD9CwGEZh6v3FMbTCoFs00rQPYQ8Z8xxJxR
         cCijTCVV9x1kU3LWmPjmjnKoVgXVzMv6DZxVdK4gxx5nCLbXvQ0EbDVkb+eRL9JIt2b7
         aJFw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765847663; x=1766452463; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nNRSgDqjGCHm0cCbv9mH9lJK6eTAVlNyMNzHMF8cYvc=;
        b=3ari1B+DFeL77dgRqQXsmkwyt3RpD5yA/XqttCV8veBhDTk0MUnXiBVw2Ka7+3hlsv
         VCY/3P8wYJlCxLpohyYwMLEQOPeSCAYbDV5tjZmS7qnzRhMkAlDsbSdeE3SuVy1fwIc8
         lA5NHOCM5dN6iBptDP/Np5epV8nrLcRkPk066yRGIc4OhzyHlea71C5x+1oq2Wr9COyG
         x3GNW9+tN8N8H8Ui056BJG3Ma/F/hiP9CP6YYrSqkgzIVtB+3vjiIIIhx90AKBiK3MT6
         7bpDrHk0oYwU2KQ5XzO5+XNO9qeugqgUZPYQ/XQ0I+QVY+GmD9JYYC6zfLTXi4IAeeH2
         Kw5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765847663; x=1766452463;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nNRSgDqjGCHm0cCbv9mH9lJK6eTAVlNyMNzHMF8cYvc=;
        b=myOg9HEtTHbCRqnVvmRdjOOoZx6+UxMpRHacEN2K/V1qHCGU7GxL/3C8SUUaMpNiii
         QkmvZcvzJEEMtnlKV77q8S7cWjuDtiYjUD2Epk9JgS5MtzNSqg1lxDlCL8dDYmnCACYb
         pCo8sHw07ToJyaMYhPQdGM07pOLXqIwEK7goAAdV9MmrR2TSzkty2iacpihyeCjYUyuE
         y3r56JGbyJSrjdJXkfWWHfL0VijUk8s/skpP13sa/lINKHseNFO9n7NmV5XiPWkYuEvw
         6ySKyveKDbiY0MsLu3KgYTeeyYt6YMfr88MGrP/eQPQYJrb/z/8sqrZQjLRoRQ//QVO3
         Hyug==
X-Forwarded-Encrypted: i=1; AJvYcCUPBagQeCIxYYQKMacLx7EtglmxhAPCdGHWZtOfIDr31Pb5TPbrD8BBvB30KW7+9I2Iy+s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRLC9jhx6N56sAAtlgH+VQX8HWnbR06IuBkrBw3oMb65rWp8mx
	wffzLoUVjV2UDGDVChtabKLL26RDwTd4tQwBHT1NzXn2tuZO/rZ+tbBCLdWduYCkPKKc0dDt/sF
	MJvYDEN0c1kEVqQayZlLup0x+ivLk39TH0WGTvtdf
X-Gm-Gg: AY/fxX6zWCuKoIHZxwiZnK7JfnTuy/rkCNjR1iC/ElF0bTVa1L3Go4FSX1DKq6z5614
	ml30WSgEUSGVkXOEJuIAmhMvkQu1bSCK2nm6h/LUiWhUyEJ4xpKGs4UTBgnNeKTZve//VN3492R
	6LJs/Bg7QB13fgsRtUdm9wc7AvN62U7RLSdikZsdqjEKmKJLtGk8d5KpgSYM4X7PWf1Bqe+xj/T
	namUitW0CeQXm1K3I5s5pBslD0+4KN2A2c4hEkMLJ9ea78WIPPqaOMukKPTyPBeESkMrgjgnqxz
	KoJOV3lwSJUXUUttMKk1LpGoIQ==
X-Google-Smtp-Source: AGHT+IHDK9Nx0ZJG9GA2+hWOGyWZ73qxIXF4H8RaWSuD2ofLYKrM3Tu07Foy0ZrKHXYTXOo9Ba7m6bZ0z05T+81FVJI=
X-Received: by 2002:a05:622a:8a:b0:4f1:9c3f:2845 with SMTP id
 d75a77b69052e-4f347f93f08mr1579311cf.9.1765847662514; Mon, 15 Dec 2025
 17:14:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1765834788.git.nicolinc@nvidia.com> <cb38f91526596f4efd0cd1cffa50b4c1b334f7a4.1765834788.git.nicolinc@nvidia.com>
In-Reply-To: <cb38f91526596f4efd0cd1cffa50b4c1b334f7a4.1765834788.git.nicolinc@nvidia.com>
From: Samiullah Khawaja <skhawaja@google.com>
Date: Mon, 15 Dec 2025 17:14:10 -0800
X-Gm-Features: AQt7F2pGryc6oZ72KleXBeas9fEej802hxD59J2edZO4aLe2-OI0GRs2t7Q1jUY
Message-ID: <CAAywjhSzKM_bEm_VbPZFffY9sR3-p==gbVppSL+555D1kPg_3Q@mail.gmail.com>
Subject: Re: [PATCH v8 1/5] iommu: Lock group->mutex in iommu_deferred_attach()
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, afael@kernel.org, 
	lenb@kernel.org, bhelgaas@google.com, alex@shazbot.org, jgg@nvidia.com, 
	kevin.tian@intel.com, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, 
	linux-pci@vger.kernel.org, kvm@vger.kernel.org, patches@lists.linux.dev, 
	pjaroszynski@nvidia.com, vsethi@nvidia.com, helgaas@kernel.org, 
	etzhao1900@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 15, 2025 at 1:42=E2=80=AFPM Nicolin Chen <nicolinc@nvidia.com> =
wrote:
>
> The iommu_deferred_attach() function invokes __iommu_attach_device(), but
> doesn't hold the group->mutex like other __iommu_attach_device() callers.
>
> Though there is no pratical bug being triggered so far, it would be bette=
r
> to apply the same locking to this __iommu_attach_device(), since the IOMM=
U
> drivers nowaday are more aware of the group->mutex -- some of them use th=
e
> iommu_group_mutex_assert() function that could be potentially in the path
> of an attach_dev callback function invoked by the __iommu_attach_device()=
.
>
> Worth mentioning that the iommu_deferred_attach() will soon need to check
> group->resetting_domain that must be locked also.
>
> Thus, grab the mutex to guard __iommu_attach_device() like other callers.
>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Tested-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/iommu.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 2ca990dfbb88..170e522b5bda 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2185,10 +2185,17 @@ EXPORT_SYMBOL_GPL(iommu_attach_device);
>
>  int iommu_deferred_attach(struct device *dev, struct iommu_domain *domai=
n)
>  {
> -       if (dev->iommu && dev->iommu->attach_deferred)
> -               return __iommu_attach_device(domain, dev, NULL);
> +       /*
> +        * This is called on the dma mapping fast path so avoid locking. =
This is
> +        * racy, but we have an expectation that the driver will setup it=
s DMAs
> +        * inside probe while being single threaded to avoid racing.
> +        */
> +       if (!dev->iommu || !dev->iommu->attach_deferred)
> +               return 0;
>
> -       return 0;
> +       guard(mutex)(&dev->iommu_group->mutex);
> +
> +       return __iommu_attach_device(domain, dev, NULL);
>  }
>
>  void iommu_detach_device(struct iommu_domain *domain, struct device *dev=
)
> --
> 2.43.0
>
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

