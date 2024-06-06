Return-Path: <kvm+bounces-19033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 271B48FF490
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 20:23:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4E8F9B2917D
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 18:23:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4AD4199395;
	Thu,  6 Jun 2024 18:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="VIdnjx6Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56333198E77
	for <kvm@vger.kernel.org>; Thu,  6 Jun 2024 18:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717698210; cv=none; b=gRgpjoaEJqJOoHKaOvlKHUf/ZkCgAY9wMyzR3xyko0mcLjG6qgGsAPHhMMmxlIma44nVPcNdOj+6juIirLl73SD9FjGB2VRsbb+MqCcPZ0ySmND2Ej4WvWkhEjMf24YXJHV2+eHpLJskZKo97AycKn/GkKmXvwXXAzmCw0/DGCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717698210; c=relaxed/simple;
	bh=COg7mACk0YSITVHTyoFCGF730Egikx0dA5F042BGlfs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=QlPKmY7Sv7tC4v6oESaSQMDhjkqH2NCZNRztvtULF4EYt5DXM9psgdTRNMIGV0tFsYueq+K+w28TN5z8b7MXM9+OkeVRxXZ5bLXukQXoY7fBj+6+wxYb0VnfNlTjdQQPh+q2xVUdn3wPX5QO+Fj9OgKRaKWOX3XsFur9iX25Gi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=VIdnjx6Z; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-57a44c2ce80so1510226a12.0
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2024 11:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1717698207; x=1718303007; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Hcd9+3fFAtOysFdTmMQPBTWScxbXFQ8Myt3EA8QbxNg=;
        b=VIdnjx6ZYrZvbKmSWWWytKrwUhFpw1WuIpvwFUOYaA1Vfd3J1/JbzTIQNJEZxCi4L9
         0JriVFoH0FbWNjbfSEP9n4RByGVsJk5JcR7k2cYSD0Phu00yiUYblEXkmlyNH40SplSi
         P/bqF2vHH/iN+ii9WqWjOX6KI1HiC3yKKYywBDl3toAocQFli+aYVPG/h6BniNTGkMg+
         PiDaJGbtothN/uxLZmOAerMNfBkZpiNn3tePTPGloKugwDZGYek7MnZVw7z3ko4+xcka
         VqU1y2QjhwEIEdgy85pazVT9MCCkS1vwtSBc3GROLFzBMJDlsPXtU5fk6x+H0P23fTlu
         EIYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717698207; x=1718303007;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hcd9+3fFAtOysFdTmMQPBTWScxbXFQ8Myt3EA8QbxNg=;
        b=whD5T9ufIRRTNWWKCSmxt/kLV3S8kN3+o3w4y0z/iUi8g2C4YU6Mlo7bkZiM9qdRLe
         JzckPUJ6Wx+PFuRdvJAoylMn8ddK3kt3vh+fG34Q2lXi/fFj5T+AL4N2OnO1uuqRwFOO
         nP0pg3NhTsL1emnWnvPfZtcZkw6EjKToLNc4N/+bp1kM/xf5cDC32dgns0sxHraEH7Gn
         hW/9z5TyFwCO/X1hyT/vyIUnJQ8ixUeTXM9LivQNg2jLrp3LgNM64ws9JMAsnVl4uC2M
         EwtBdGFjjkfffSU8mKdL1UkJE8PKneJOtqSETgda0DFqYBt5pryNrMYr7GCMTsnXxxGC
         MA8w==
X-Forwarded-Encrypted: i=1; AJvYcCWOAEu7zNuE2Of765pWfxjAXhdfEqA9luy8Mgtb6etMJxvHOWfDQcw2qbRibIgAv5nN/jvUwgaQUFlo17bmp4cbPeRY
X-Gm-Message-State: AOJu0YxKKO0udcEtpwQirZmpDs9eF6xI5LbwXJBPObwJhu8G+lCCL7mZ
	/tN5dvfK5C6htJ3oJjQb8wY62x2IU8Y13OSoqMukUIigjJ5z2e+sCdc4SpUcbuDsvuy2dM8XBCu
	t
X-Google-Smtp-Source: AGHT+IGre+3Dnxxwlh1w+yJc7gfJNncd/xYIbM3EQ7wp5ufM3tlPSH6iFl2zAQZTn/pejA6MSLLz8Q==
X-Received: by 2002:a17:906:c254:b0:a68:67e4:7f0d with SMTP id a640c23a62f3a-a6cd561b41bmr23954566b.2.1717698207490;
        Thu, 06 Jun 2024 11:23:27 -0700 (PDT)
Received: from ?IPV6:2003:f6:af22:bc00:4b8d:639a:480e:4db? (p200300f6af22bc004b8d639a480e04db.dip0.t-ipconnect.de. [2003:f6:af22:bc00:4b8d:639a:480e:4db])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6c8070e96csm129049666b.174.2024.06.06.11.23.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jun 2024 11:23:27 -0700 (PDT)
Message-ID: <284499d7-4e59-487a-adc6-11263b64fe70@grsecurity.net>
Date: Thu, 6 Jun 2024 20:23:26 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: Reject overly excessive IDs in KVM_CREATE_VCPU
From: Mathias Krause <minipli@grsecurity.net>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>
References: <20240605220504.2941958-1-minipli@grsecurity.net>
 <20240605220504.2941958-2-minipli@grsecurity.net>
 <ZmDnQkNL5NYUmyMN@google.com>
 <0ef7c46b-669b-4f46-9bb8-b7904d4babea@grsecurity.net>
 <ZmHN3SUsnTXI_71J@google.com>
 <516b4fd8-e1fd-43ec-a138-f670cc62a625@grsecurity.net>
Content-Language: en-US, de-DE
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <516b4fd8-e1fd-43ec-a138-f670cc62a625@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 06.06.24 20:11, Mathias Krause wrote:
> +   /*
> +    * KVM tracks vCPU IDs as 'int', be kind to userspace and reject
> +    * too-large values instead of silently truncating.
> +    *
> +    * Also ensure we're not breaking this assumption by accidentally
> +    * pushing KVM_MAX_VCPU_IDS above INT_MAX.
> +    */
> +   BUILD_BUG_ON(KVM_MAX_VCPU_IDS > INT_MAX);

And yes, I'd rather like to write the above as something like below to
account for type changes:

    BUILD_BUG_ON(KVM_MAX_VCPU_IDS > typeof(vcpu->vcpu_id)::max());

But, unfortunately, C is not there yet. One could try to implement
something based on _Generic() but, meh..

>     if (id >= KVM_MAX_VCPU_IDS)
>         return -EINVAL;
> 

