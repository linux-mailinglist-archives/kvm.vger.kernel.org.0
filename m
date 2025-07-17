Return-Path: <kvm+bounces-52793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A9FCB0951A
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 21:40:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87E81177F64
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 19:40:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 680692FE36F;
	Thu, 17 Jul 2025 19:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RY/BBTxk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61C21A314E
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 19:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752781222; cv=none; b=cT1XYL0islJ16eU0QyIdn6iWbOtB4jrrWwvF9YJ8G7H/5JC+g8LxkBsOUfAyB1fMnv3P0bISC3GabIUE+z2/6kep1skg/3IASQ6y12QUSxNUVEgTWfMvTLpvO4LXc5yTnhcD5gxTl+f9NLzZMRcAW3+ZfLy14KD9XGkE0w/42aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752781222; c=relaxed/simple;
	bh=AliCz80P40/+u4uyNacd4d5aJesJDRNV1iyzNivQibw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=krrP2XwCAhL0Ys5Y5r7p7S2q0ZeG/5wT7lvJQUge6kh3U6uYWiaN2An2xkEQeiYpBprBSn5+2EqMzXcoF6zy7SlPM3jx8HzaTIDoRYJ8R4Y/c32r5eskzkmSXlmkcOE54WXdgc2bmi7NsJ+u690SHzi3oRLh4U6bpIK3uyhjUjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RY/BBTxk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752781219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z/2+uUVHwQq1KQQUsEuaD+AV1NGVtRzgW4E0uexw5t0=;
	b=RY/BBTxkGBRnxJ2vccJqRZMg1HdHGrUJ+YoT/++9YiOAzCjZjJAmraNIMKcqp/0i1iY77u
	WMtgJs0r/rFq0BHwEgxyCs+tZoz+gth3w7gCzK76nrX+LQieuR+yVEXEvB1lR7VXAGKdiu
	Z9xYp/248D1MbPCA57nwKOOZmEWMyBE=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-HZlnA-yTPwKs7Fbt6oCQ_A-1; Thu, 17 Jul 2025 15:40:18 -0400
X-MC-Unique: HZlnA-yTPwKs7Fbt6oCQ_A-1
X-Mimecast-MFC-AGG-ID: HZlnA-yTPwKs7Fbt6oCQ_A_1752781217
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3ddd689c2b8so1542735ab.1
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 12:40:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752781217; x=1753386017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z/2+uUVHwQq1KQQUsEuaD+AV1NGVtRzgW4E0uexw5t0=;
        b=jLIdOd/SuWiH0YE6knVTFlAAAw3e2OOML0dABIxIdV3f7NPZmVZ5cgAp8OORwS4kbh
         YHOJlPUe2dDH/4+nzoRvvwOz69lpHM9f4iKshgUg7MZuWoVPoySrwdcd7eDewPagzJht
         zztdHD/+nke6Sl/kELTT8Iq0DSD87R8RKQL01PnRgs7One7EUo5EkpD7ufMChekaZILs
         OSrim+SZG1TN5KgE324swikco77aAF8hwrOvmx+TEAWR9VWt6DiVP+LhsmUOQQIwbtkV
         9H7DKeeloom+ysanIj96pRSNjV+ZMjyuXFWzKmflotcaDfY9W0VugmFBFBvza0KDDa6C
         OE/g==
X-Forwarded-Encrypted: i=1; AJvYcCXyNAJ9T6bx+2hYFc/DhMLMsOhJAE+fdL7waCaQ4ccuxXo9xCtcQR9+Uc00dbKxrdrho/I=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPOvqUWDLOH2ncQVUBhrKCVfdbSqoPAYVLj7aZc9xjlqm3lCYj
	IRuesbFFW9+Esep2eAxk7exgd0mwnVoicrONWQiIdXLOKKFJeXtq3x92lL7sKzFOQ23bnO9Ox5F
	GKxR2Al+X1NCRVrEcL64kKOwtz7MYlUCAq6hyNw13bQ1MmgONHem+dWdxTinm6g==
X-Gm-Gg: ASbGncs1u0/JyQoJWwe6CTc8zDG/abRNfJiJHTLZjyjDfRXmof0sZHJ08YoR6Hwdut0
	/g9DupE1U1GpUHr451JnZ9PsNx1YSRWGtJFyhyg9C14L/U4bRxQvqFYcx6nL4HVryS7nzzEwRbv
	2cH1Bu71tDUF0gP03TAhnc/j1MBBdHhOpLJsBf6wGc+LJTGwdW9WUPvosjniMtWbc9IHzijNrLq
	TT+wlBDG+qZl8QxE9KXO+CpMPFOpTDNp+Xav0HCwRqbf5Tw448SzlMhXnOLcmXWRi/JSDrJ+RTK
	1XO7Mex7ZTQl4XtR6nGKbMVVJ2gfea8mXIyDy87PHjY=
X-Received: by 2002:a05:6e02:3113:b0:3dc:87c7:a5a5 with SMTP id e9e14a558f8ab-3e28245f8e8mr24903995ab.5.1752781216868;
        Thu, 17 Jul 2025 12:40:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGV+0O7JW3kdwf9CMHiAKbvK9a8rLbbPPt/Na4CzthvG+duCf1EvXTna86WdjzvTwHw9uYkCw==
X-Received: by 2002:a05:6e02:3113:b0:3dc:87c7:a5a5 with SMTP id e9e14a558f8ab-3e28245f8e8mr24903925ab.5.1752781216429;
        Thu, 17 Jul 2025 12:40:16 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e2462299c0sm53651965ab.48.2025.07.17.12.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jul 2025 12:40:15 -0700 (PDT)
Date: Thu, 17 Jul 2025 13:40:14 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Nipun Gupta <nipun.gupta@amd.com>, Nikhil Agarwal
 <nikhil.agarwal@amd.com>, Pieter Jansen van Vuuren
 <pieter.jansen-van-vuuren@amd.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
 stable@vger.kernel.org
Subject: Re: [PATCH] vfio: cdx: Fix missing GENERIC_MSI_IRQ on compile test
Message-ID: <20250717134014.16b97da5.alex.williamson@redhat.com>
In-Reply-To: <20250717091053.129175-2-krzysztof.kozlowski@linaro.org>
References: <20250717091053.129175-2-krzysztof.kozlowski@linaro.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Jul 2025 11:10:54 +0200
Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> wrote:

> VFIO_CDX driver uses msi_domain_alloc_irqs() which is provided by
> non-user-visible GENERIC_MSI_IRQ, thus it should select that option
> directly.
>=20
> VFIO_CDX depends on CDX_BUS, which also will select GENERIC_MSI_IRQ
> (separate fix), nevertheless driver should poll what is being used there
> instead of relying on bus Kconfig.

This seems like a recipe for an explosion of Kconfig noise.  If the bus
fundamentally depends on a config option, as proposed in the separate
fix, I don't see that a driver dependent on that bus needs to duplicate
the config selections.  IMO this is sufficiently fixed updating
drivers/cdx/{Kconfig,Makefile}.  Thanks,

Alex
=20
> Without the fix on CDX_BUS compile test fails:
>=20
>   drivers/vfio/cdx/intr.c: In function =E2=80=98vfio_cdx_msi_enable=E2=80=
=99:
>   drivers/vfio/cdx/intr.c:41:15: error: implicit declaration of function =
=E2=80=98msi_domain_alloc_irqs=E2=80=99;
>     did you mean =E2=80=98irq_domain_alloc_irqs=E2=80=99? [-Wimplicit-fun=
ction-declaration]
>=20
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Closes: https://lore.kernel.org/r/4a6fd102-f8e0-42f3-b789-6e3340897032@in=
fradead.org/
> Fixes: 848e447e000c ("vfio/cdx: add interrupt support")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  drivers/vfio/cdx/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/vfio/cdx/Kconfig b/drivers/vfio/cdx/Kconfig
> index e6de0a0caa32..90cf3dee5dba 100644
> --- a/drivers/vfio/cdx/Kconfig
> +++ b/drivers/vfio/cdx/Kconfig
> @@ -9,6 +9,7 @@ config VFIO_CDX
>  	tristate "VFIO support for CDX bus devices"
>  	depends on CDX_BUS
>  	select EVENTFD
> +	select GENERIC_MSI_IRQ
>  	help
>  	  Driver to enable VFIO support for the devices on CDX bus.
>  	  This is required to make use of CDX devices present in


