Return-Path: <kvm+bounces-58023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1707B8594E
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 17:27:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AC3217B11AC
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 15:25:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6076130CB41;
	Thu, 18 Sep 2025 15:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cjTRIokJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050EC30DD11
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 15:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758209219; cv=none; b=o2WgqUjbRkbqkmQHdn6x6X/cRAZW1Bq2Y7bYHtht1Gx/zZ04GVo8LusAhQ+GqxkFobn91lyxRcGoohNYrbpsBGQx66d7/feGv6tB5B8pp6amw9IS+uFS1rh7lsCO7gcf36k4TCAZq3GFjLgoADUekXgtc6eesWBjGi5/NqHjQRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758209219; c=relaxed/simple;
	bh=zqy4XWME9Al6Lq6iTcVkkgpbsqKbeHYZryhYiKlnWcI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YWLisb3CoRjrIM3GkA/onjQeh19tyO6hOle9Dbv1mTG0I8ocKmYKaqvdyBL2DeA1VLC6CLwBGJvSBF/05lDMc7jZl31CcT0R7CmvyuB6JWRRYWJeJeX0brrDI3tMN1vnOP4JnRiFVtnO7/vjaBHOLXvzqVfkMBzfV2y9UgAcDlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cjTRIokJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758209216;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KL5XphfGve3/sGWIcFqGeYJJAdQnhKsRbINuS8YWb0o=;
	b=cjTRIokJ1cvNz/BynNoI/S98IQAuxZfCnvG0OkzLT8gEFFiPiZ1vWVHCXP1bV1+DXGLW7h
	0SEjevT8s+DeRAKeZAOlSb3hQfHwPgsE6/fdrw8v1ZW7q2aUUUv7uL1cXBf2eJ7E7oNE0R
	yH1ZjtbfR9SP1ZX/DC/BP5wikv1yOgo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-230-GscIJ-SlPOW_6pAZRpY9hQ-1; Thu, 18 Sep 2025 11:26:55 -0400
X-MC-Unique: GscIJ-SlPOW_6pAZRpY9hQ-1
X-Mimecast-MFC-AGG-ID: GscIJ-SlPOW_6pAZRpY9hQ_1758209214
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b467f5173so9620495e9.3
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 08:26:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758209214; x=1758814014;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KL5XphfGve3/sGWIcFqGeYJJAdQnhKsRbINuS8YWb0o=;
        b=X3yqbEMORb8xWdnyIyM36eAcXab7JS4CUgq5RiFcRXU90+NwMg31urOy+JlSa8dgOx
         FxOP/dZDjZmc2fX9Ak2f8Fuu6PAUCebe+5e+HAQgF/gQj9bsq45EElZB1DbRhnblVSFL
         YEq+DgjYu/rXZQHkAZ8M/KaFHYMKciiFJrIOfwDkXmvBKJ/XLokz406tmGKqif1+vbJh
         cmt0cIf9YXrVqJgobKv9RhxTBS5sverxGMHyAUVq46uO6EFMXRYH5QBXF3Og2cRjR8uO
         EGK1yn6z9BNIvItETcklsjw+e85Jw+oI9GsJB9nUc0Rw3WlJyPbZA4wAdo8FuTuEFu6O
         0iRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXgTgorJwTBjWb65ne7tjHaF/jU3Ts9AueMe2pc9Bj1B/B8t4paPgEFipiQuaf8VsUKTA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAT/WE6HkJYGr5QLTMQr5t0vwDuHvP6cBj5qYg0dQRlHC0iWpp
	ljRttRVMJ0uM1Fp45Ga1A51Ce8rNWnkN+u1HBb6vtazIa5e+58b/+KKyoMlbLpQ43Wfdl1cGhcL
	cqvobsPEFd2HppYa5KNKc7ptY3yGOqeR8Ki8jj8dyWj6ccpyM8IRa0w==
X-Gm-Gg: ASbGnctWFyi2zT305OwHwn3+K06vclITlJgLcJAwC+uIBp4EYD4DtKJOhZaarBpbipC
	hpcr63V6wXUb5r5sql0k8VLkmqEbUV+LFt6cESiPlXVtcMd1mFJMKTvl8zExF2A/D2hg5P/dQMP
	/XjN+PEIM+DbaXEfd3juxP/uGz5dCH268c80X58qmLr1DuK+I9guzH8Ima1tA/8TGgPTL/RQDMr
	7oFnpIemiTtd/6bnIcNwKesGl0B7gHIkXMf7CmjvKeyrAkkqj+UmkKlg+emCIzsYvxKiFD9zmTs
	U3NJ7CfWHGq1VOxfe3YRdVAh4221mmpKfPTmtjb977NVDvO3+Klu3XX6+68u3nFcC2EFnN8sw7G
	M9FHsbATWW78=
X-Received: by 2002:a05:600c:19d4:b0:45b:8f5e:529a with SMTP id 5b1f17b1804b1-462031b1dfdmr63298595e9.14.1758209213816;
        Thu, 18 Sep 2025 08:26:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEAFdhxqAFtJ5xKzXqH5L+rh3q+f9wj0clvTRsPw0BM11XcNBfnHbnLBJBzjrN/jbBhLHWSaw==
X-Received: by 2002:a05:600c:19d4:b0:45b:8f5e:529a with SMTP id 5b1f17b1804b1-462031b1dfdmr63298295e9.14.1758209213397;
        Thu, 18 Sep 2025 08:26:53 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee073f3d68sm4154041f8f.10.2025.09.18.08.26.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 08:26:52 -0700 (PDT)
Message-ID: <6a4651a8-d6ea-4bcd-9f73-3e852f9904dc@redhat.com>
Date: Thu, 18 Sep 2025 17:26:52 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 1/2] target/arm/kvm: add constants for new PSCI versions
Content-Language: en-US
To: Sebastian Ott <sebott@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20250911144923.24259-1-sebott@redhat.com>
 <20250911144923.24259-2-sebott@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250911144923.24259-2-sebott@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/11/25 4:49 PM, Sebastian Ott wrote:
> Add constants for PSCI version 1_2 and 1_3.
>
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
> ---
>  target/arm/kvm-consts.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/target/arm/kvm-consts.h b/target/arm/kvm-consts.h
> index c44d23dbe7..239a8801df 100644
> --- a/target/arm/kvm-consts.h
> +++ b/target/arm/kvm-consts.h
> @@ -97,6 +97,8 @@ MISMATCH_CHECK(QEMU_PSCI_1_0_FN_PSCI_FEATURES, PSCI_1_0_FN_PSCI_FEATURES);
>  #define QEMU_PSCI_VERSION_0_2                     0x00002
>  #define QEMU_PSCI_VERSION_1_0                     0x10000
>  #define QEMU_PSCI_VERSION_1_1                     0x10001
> +#define QEMU_PSCI_VERSION_1_2                     0x10002
> +#define QEMU_PSCI_VERSION_1_3                     0x10003
>  
>  MISMATCH_CHECK(QEMU_PSCI_0_2_RET_TOS_MIGRATION_NOT_REQUIRED, PSCI_0_2_TOS_MP);
>  /* We don't bother to check every possible version value */
I would simply squash this in next patch

Thanks

Eric


