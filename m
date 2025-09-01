Return-Path: <kvm+bounces-56523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4571B3EFCD
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 22:41:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78A1F2062B5
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 20:41:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFD1D272803;
	Mon,  1 Sep 2025 20:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f3top7J8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B31A26CE3A
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 20:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756759251; cv=none; b=cWo5lpfWg5WvNx7R//2inG05s+D2VLgakCvwScmBVd313a6LcOcE/Z8UnnVPrl2V+c4YVwLNefiFLECaUyIN9VZ9piun1+zZoKbl3YnmzackOhPuWj3zEhovKi3Gf6ocE0If9LWuTIBI2xIxnaz2pRvNqP4ULwIwTK26WoaV6LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756759251; c=relaxed/simple;
	bh=5n34Vy3SJGpIBzxpUQYczMFS+9WatvVkOg5dSEsG9O8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tr2kuagRP/XHFLFFTA2zs/09z/JHNHqGaYwHhRkGNIDN4T6XR9tgYx1RGyxz7mg97cZUvEnzRSThQjPygubQaJqmTm2b6Fv8XebtJOgPWOf2njqxFtfpuzPTwqBwHvFcHktgD0H/4ZJCJ1fchCt6WnwOxn4wd1W6ybMwfWPZiHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f3top7J8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756759247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+B9VAsu0RKzYj0L0AfU6O0ugzD+pX5xv1/kXNBRGfIw=;
	b=f3top7J8EOYt4Rm08mYnH3IHKUxa9/phgNItwPRpn0ZA8w5oS9H7uBFjw4VRMLuzb/0iE7
	tSyK0c0s135PDHyt2iY9qFKLUPNOOK/SW+Q7ieY3YhNFuCGlgC+93jEVE8tzHRJFjtkftX
	Arb7Q0IEm4KJc8Fp6AKxaCjoXHveP0U=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-iE9HEV35PBaLTcBP-GVybQ-1; Mon, 01 Sep 2025 16:40:46 -0400
X-MC-Unique: iE9HEV35PBaLTcBP-GVybQ-1
X-Mimecast-MFC-AGG-ID: iE9HEV35PBaLTcBP-GVybQ_1756759246
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3f65568da43so833165ab.3
        for <kvm@vger.kernel.org>; Mon, 01 Sep 2025 13:40:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756759246; x=1757364046;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+B9VAsu0RKzYj0L0AfU6O0ugzD+pX5xv1/kXNBRGfIw=;
        b=i77V0MGf1wBRmpqUgmFMDnBk1zq+9KaQoJqnvDw1O7tbR6P31eQ+R5PK9uifPzzPTj
         RZGE+kAsmTdbHm9fDWVYuGi9kqlWFB5hAKpDS9mgKrHL794C1LLF/8hI0QUdM5U2Ahbt
         C0JfGox+4Tepo4gopTxIGQ7kZz0EAGauqDf3aVVDGxyejIWTzHLE6/8K7+EP3rG3fRr9
         JGPtNs4wKZaGDRjgMBBfEkH4w6WR1doymlRwj6kKKCEVrO75APrMXgciXk142B7exFtr
         YcXZdTWY4HWnzs7evoPxnXITTKs15ENbPpJnkZ4GQyakAwiZwhu/VIgQHqIDRe8qVmHv
         V++A==
X-Forwarded-Encrypted: i=1; AJvYcCVanS2Udm5ir0DVRggHcHsHtSuflYWKqycMvFinRq9/kQZZWVTNG5Hs69U4KeCW70f8qRM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxonMc2LSJiIaNOVb5VjJjVX9m9rbIBVpTEIpBeOSF5kxzWh2Ge
	7ffRCS4UNNJG5ruo1IMIxudI9MS0lEvNgP0k8o2S/1ddFkik7sB2eN5ktq7cItaBtVNF5mR2Usi
	mehMbWLJBc/+6Zt5HDhWJtDvVCPATtC6y+JqWiwHNdBdMAlg4QUUMUg==
X-Gm-Gg: ASbGnctYLW/mMXRcIR/7TUgsvFo6ru+3U2rPEQBIue0wbK83aBGWj05bUL4xqbAETcq
	ETdD1ZsbNXj39l9inBDY4qFajhDCoW/JncwFsGjCUJK3Lu4bkevY7HBu2vi+e4AjarFPkSPSuHk
	eE9sOw09jZxskHzcHEHXgQUGAD0bo3jOaPadSkirG7BKenj4eWNMzfPPTiIx8oYcLfqfSQak9RT
	uvOXMIJWJxkADkJnaXPIEd0g76Vkij4mCB0AL8gVWsMJ/pEVjZ/Z675H/D6NPsG7C2yCQt5iivi
	JsIDiP18PIohnJ/uozgnKu374ZG1MlH7j9m9Kf1rRac=
X-Received: by 2002:a05:6e02:1a45:b0:3e5:4844:4288 with SMTP id e9e14a558f8ab-3f3247c6570mr87671245ab.6.1756759245914;
        Mon, 01 Sep 2025 13:40:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGDCjj9eJz63KAon0nZj1U3iZU1nYx18LdGI9Q8LOi5kKaPZkcCjO1mvqyzR7bme00h+xlmOg==
X-Received: by 2002:a05:6e02:1a45:b0:3e5:4844:4288 with SMTP id e9e14a558f8ab-3f3247c6570mr87671145ab.6.1756759245503;
        Mon, 01 Sep 2025 13:40:45 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50d8f361038sm2501739173.56.2025.09.01.13.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 13:40:44 -0700 (PDT)
Date: Mon, 1 Sep 2025 14:40:43 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Eric Auger
 <eric.auger@redhat.com>, clg@redhat.com, Mostafa Saleh
 <smostafa@google.com>
Subject: Re: [PATCH] MAINTAINERS: Add myself as VFIO-platform reviewer
Message-ID: <20250901144043.122f70bb.alex.williamson@redhat.com>
In-Reply-To: <20250901191619.183116-1-praan@google.com>
References: <20250901191619.183116-1-praan@google.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  1 Sep 2025 19:16:19 +0000
Pranjal Shrivastava <praan@google.com> wrote:

> While my work at Google Cloud focuses on various areas of the kernel,
> my background in IOMMU and the VFIO subsystem motivates me to help with
> the maintenance effort for vfio-platform (based on the discussion [1])
> and ensure its continued health.
> 
> Link: https://lore.kernel.org/all/aKxpyyKvYcd84Ayi@google.com/ [1]
> Signed-off-by: Pranjal Shrivastava <praan@google.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 840da132c835..eebda43caffa 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -26464,6 +26464,7 @@ F:	drivers/vfio/pci/pds/
>  VFIO PLATFORM DRIVER
>  M:	Eric Auger <eric.auger@redhat.com>
>  R:	Mostafa Saleh <smostafa@google.com>
> +R:	Pranjal Shrivastava <praan@google.com>
>  L:	kvm@vger.kernel.org
>  S:	Maintained
>  F:	drivers/vfio/platform/

This would be all the more convincing if either of the proposed new
reviewers were to actually review the outstanding series[1] touching
drivers/vfio/platform/.  Thanks,

Alex

[1]https://lore.kernel.org/all/20250825175807.3264083-1-alex.williamson@redhat.com


