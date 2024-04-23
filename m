Return-Path: <kvm+bounces-15724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 633188AF8BE
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 23:09:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 955051C23813
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 21:09:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 030A4143878;
	Tue, 23 Apr 2024 21:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bUzaaSqc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E13142E85
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 21:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713906568; cv=none; b=Envf+bLwWlPLIv7vcE0Q3ciZIMXkZmspnXwO6bVgaTOEJsVatuMSbCrsF8yFlJKcKZweXfObSHu1iTMbt2cLR09sfbyeolj8tbz+cJZQh+6rzHkKEewPDWWWo7OjnI79FLk86jwG6j8uu/srWH3j1bDw7TrknfpIHgdhPmqHiGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713906568; c=relaxed/simple;
	bh=kgbIHXr2bi9p5muvD86p6UwpsFB1QKcNggyDv0it32c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NIUMi3gmmJ+W+6IuOt8U+vNfqZ2k2/YWIRdBiGNMPt13RbHwA5O+rKxRJk8sjn312HtFC222vngQvQAVoPZnR5r/rjblPp6bmjQnuqeCECq0we2Dh3yTt3ZHaVO1p6wZgkucT/uzE2+DGwJQNFOPuoF8XMC9FORO1kLwdtpMt1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bUzaaSqc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713906565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iMgVwJPIk+SrJO1aUq+M0EnJvfj+z9S9X/zT3E0x9q4=;
	b=bUzaaSqcm72j/xoKVEden0YkUyDi50uJqvjTIJ8iY/z61aWKMoYeEWh6524fLzKVkHkyqN
	ezCeTZOCg0lSLHmu9QledK0koOAR8XzotFumU2NxwgYvjF8cq5MRebRCg31NrB+bziv+MD
	2+1rUA0SUhQnNtVYK1p3ZQP+D5dgGxk=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-6NcyiZgnPlepiNhrls5kmQ-1; Tue, 23 Apr 2024 17:09:23 -0400
X-MC-Unique: 6NcyiZgnPlepiNhrls5kmQ-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7da52a99cbdso515340839f.1
        for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 14:09:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713906562; x=1714511362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iMgVwJPIk+SrJO1aUq+M0EnJvfj+z9S9X/zT3E0x9q4=;
        b=f+K55x1AozpGsdRaASM8JMyuloWkhGQ+5guDsisEECnfPzkHI60HvY76fDGGCucSuO
         kDgs/li+Akm7nJTWfaYY52JjcnN/ZlraxrUIIpMDPwOZBt3dOvv/QQ3cjeSaAZ89BOB3
         idnsXnCkYpKtlzED58EZkap4p03eB3NRki4GW7Lc5Y3dsYUe6K2KCk8SHyWX6j068JbZ
         plNQeQaItXFdhUm2Dlk4XQF41BKXAO6649MNGK7K/+HucYxzIEYKlkPl3s+656INq1ZT
         6sKZv0gIE+EHreYAIYbIWgoIgnp/szDvjr6IC4jfref2QLxA3PH10gDLfU1ettPEYnEF
         M2Rw==
X-Forwarded-Encrypted: i=1; AJvYcCWRNiqsIlQ3HWSiBgNstbQNX84f0CaJliuImRpAuHSyDY3ZtW7OFt3wG4X7IEQzuUf6ohwhTYm53hjWlxhz3+ALnc+9
X-Gm-Message-State: AOJu0YwIiNEBt7uFu3fe3YY1LBYQF4AQpHA+vJKaI1DXnIjHKPDrfQGg
	AVu6YnkUY2t1DK5u3sXoS65Dp2gPSVpxfAVOaBjBHUza7zDHNSS/qDkBQ9DSREkX6DYcNViK5H7
	DGnQguzs3MUDoXbOTJvvoQ0en7m+/kK+76KTRIS1vuFDZtS2Mug==
X-Received: by 2002:a6b:f305:0:b0:7d0:8cff:cff3 with SMTP id m5-20020a6bf305000000b007d08cffcff3mr796376ioh.8.1713906562662;
        Tue, 23 Apr 2024 14:09:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEhZfKzdE79LNT40MJ4hobam5s8cfCvXR012CG0rzXeCrsxEVa+wKgAJcyxg+paPh2DT1g9lQ==
X-Received: by 2002:a6b:f305:0:b0:7d0:8cff:cff3 with SMTP id m5-20020a6bf305000000b007d08cffcff3mr796364ioh.8.1713906562382;
        Tue, 23 Apr 2024 14:09:22 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id x5-20020a056638160500b00484f72550ccsm2560741jas.174.2024.04.23.14.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Apr 2024 14:09:21 -0700 (PDT)
Date: Tue, 23 Apr 2024 15:09:20 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Nipun Gupta <nipun.gupta@amd.com>
Cc: <tglx@linutronix.de>, <gregkh@linuxfoundation.org>,
 <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <maz@kernel.org>,
 <git@amd.com>, <harpreet.anand@amd.com>,
 <pieter.jansen-van-vuuren@amd.com>, <nikhil.agarwal@amd.com>,
 <michal.simek@amd.com>, <abhijit.gangurde@amd.com>,
 <srivatsa@csail.mit.edu>
Subject: Re: [PATCH v6 1/2] genirq/msi: add wrapper msi allocation API and
 export msi functions
Message-ID: <20240423150920.12fe4a3e.alex.williamson@redhat.com>
In-Reply-To: <20240423111021.1686144-1-nipun.gupta@amd.com>
References: <20240423111021.1686144-1-nipun.gupta@amd.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 Apr 2024 16:40:20 +0530
Nipun Gupta <nipun.gupta@amd.com> wrote:

> SI functions for allocation and free can be directly used by

We lost the ^M in this version.

> the device drivers without any wrapper provided by bus drivers.
> So export these MSI functions.
> 
> Also, add a wrapper API to allocate MSIs providing only the 
> number of interrupts rather than range for simpler driver usage.
> 
> Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> ---
> 
> No change in v5->v6
> 
> Changes in v4->v5:
> - updated commit description as per the comments.

I see in https://lore.kernel.org/all/87edbyfj0d.ffs@tglx/ that Thomas
also suggested a new subject:

    genirq/msi: Add MSI allocation helper and export MSI functions

I'll address both of these on commit if there are no objections or
further comments.  Patch 2/ looks ok to me now as well.  Thanks,

Alex

> - Rebased on 6.9-rc1
> 
> Changes in v3->v4:
> - No change
> 
> Changes in v3: 
> - New in this patch series. VFIO-CDX uses the new wrapper API 
>   msi_domain_alloc_irqs and exported APIs. (This patch is moved
>   from CDX interrupt support to vfio-cdx patch, where these APIs
>   are used).
> 
>  include/linux/msi.h | 6 ++++++
>  kernel/irq/msi.c    | 2 ++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/include/linux/msi.h b/include/linux/msi.h
> index 84859a9aa091..dc27cf3903d5 100644
> --- a/include/linux/msi.h
> +++ b/include/linux/msi.h
> @@ -674,6 +674,12 @@ int platform_device_msi_init_and_alloc_irqs(struct device *dev, unsigned int nve
>  void platform_device_msi_free_irqs_all(struct device *dev);
>  
>  bool msi_device_has_isolated_msi(struct device *dev);
> +
> +static inline int msi_domain_alloc_irqs(struct device *dev, unsigned int domid, int nirqs)
> +{
> +	return msi_domain_alloc_irqs_range(dev, domid, 0, nirqs - 1);
> +}
> +
>  #else /* CONFIG_GENERIC_MSI_IRQ */
>  static inline bool msi_device_has_isolated_msi(struct device *dev)
>  {
> diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
> index f90952ebc494..2024f89baea4 100644
> --- a/kernel/irq/msi.c
> +++ b/kernel/irq/msi.c
> @@ -1434,6 +1434,7 @@ int msi_domain_alloc_irqs_range(struct device *dev, unsigned int domid,
>  	msi_unlock_descs(dev);
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(msi_domain_alloc_irqs_range);
>  
>  /**
>   * msi_domain_alloc_irqs_all_locked - Allocate all interrupts from a MSI interrupt domain
> @@ -1680,6 +1681,7 @@ void msi_domain_free_irqs_range(struct device *dev, unsigned int domid,
>  	msi_domain_free_irqs_range_locked(dev, domid, first, last);
>  	msi_unlock_descs(dev);
>  }
> +EXPORT_SYMBOL_GPL(msi_domain_free_irqs_all);
>  
>  /**
>   * msi_domain_free_irqs_all_locked - Free all interrupts from a MSI interrupt domain


