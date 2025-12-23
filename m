Return-Path: <kvm+bounces-66609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DFDFFCD8777
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 09:40:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 37D7830334CA
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 08:40:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 059162F12BA;
	Tue, 23 Dec 2025 08:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JoHh6Hqh";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OgQ3rFtS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8098431E0F7
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 08:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766479206; cv=none; b=iWNi00CCakdxMvKCrZjhqlShWJ8m19q2UgLg9tG6vdOPpniVBOPseTJ/42Go35OPtg2JNJNdW16uiUOfeZ9zqnFjPZ6WzI1GB/ALNe1Ql6NrufV83Olu7/H/X134Ry2kzZ9jCCzpZVst5ujTksTKrzRzIl9OtspG+1a6KqZneQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766479206; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmcR/ARH4f2ol0CO96nvWN2KB1GmR24hr2T0v9FV8vBggdtDL/BBvdsV7ZRkbYZCJvXvlEQTlplKqj3FGYlzJZ2us38f4zpcjc3WRgotauOA+2glha+3Fxtk5MFZIy5lXq7oLgneGv+mGD/bAqm4ZWg9adr/ess99hKf3ECTK+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JoHh6Hqh; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OgQ3rFtS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766479203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=JoHh6Hqh3EmLq0dsTzpuTdqOuumy8F8soynzRZeIs3YSWkGqmb28Vddnc8j/rSDKV2hdEB
	i/s8aJalLMPQBvIGJ6AR/GPPfe8zPtrIsT1lKrwHzWK6fT90+cufsVre4W2f079kLBpP9l
	v4Q1bjra52KLcM8s2xRI5//CLHp1zNk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-Wv15Gl-4MRmGZuD6_VQbOw-1; Tue, 23 Dec 2025 03:40:01 -0500
X-MC-Unique: Wv15Gl-4MRmGZuD6_VQbOw-1
X-Mimecast-MFC-AGG-ID: Wv15Gl-4MRmGZuD6_VQbOw_1766479201
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-430fdc1fff8so2283081f8f.3
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 00:40:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766479200; x=1767084000; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=OgQ3rFtSq7C+1816HGTlm1Z8ewcKMw4FyKxX5wocEoPEqfHZaGo8pSX2l3SGjWaxa6
         BxiBUjxx+ojGwqIlRHkUiED+qMkfazGnCteKBvLieGu3HAr92PTw7sTCprmq/Sefg3J+
         IsD9mE9XHJiDSBKUqQM+fjtJ5eVia9sAmQrgVZ2acPooLD8BogMoQhAB7DlG2i9Bo54V
         mQvlFnICeFEKKWV/qkaxF4Fh/j689BZ6iFRNiI2HrM/jhYxC54tConD0BA9mkdMYg3zf
         UpimhnTTRD9g+ucBPy69tY13XRwim87zHvMikRv2RGUR6G7UGP2FPIwjeqQDsg1Js+Q7
         wFbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766479200; x=1767084000;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=oiY8UWo1oXqrTYamLIPgU7mTBNu9XDxAcihHYKC3y3M+un2gUfx28eB/8vzS94G4PX
         gyAa5fWNQ1BLiy17OgkYs5qO/8Z+OXE47zGBRv6R9uLY/7npQi03+SGfb8T2cCMW1PFe
         WXq9h76sU2wV6UZZ0w7J0suKhj82c7427v+UdkeE7DfS0QpAeCK15D3/OwInnYIxNuW2
         fi43nS0xtTgWEFR08zrEtf5ASZAlWnOUkKT9ZUtigB1QOgNmJiR//fnkF6GVGlMm3vE/
         H5j0+u/m43J8K9caSCsmtdEP6ZpggLMulsoB1sC5BRXQdGIZVeS1mPAB61JKAurOuxPy
         1Wcw==
X-Forwarded-Encrypted: i=1; AJvYcCVcKvdNzeHtCZ3Iwxix7grL5RY+aG5yRFMrXx6s+iauW05H22iAb7HgbqZeddwMD9OAdYo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxgFx0iGTSESae8JjusE5RnI/mRe+SwsVrfE06HCCLecQny+AD
	HpARshAF0GfTuSZgeh625hRU0okrnhBwR/eAJmGDg6nHFURAWEyqhjp8zxDsBS5/27L3DJn2cwo
	iiHATigGvRJT2smXR6cdu+JVeDpv2HneKgz7V8WtbGwOo9HCtr2WwHQ==
X-Gm-Gg: AY/fxX7tPrBu60ulN4kw6tx+vKISaGG0e2d8CxvZ2f/QViTY/yTNmH7p0smLWKYoK6m
	NO56Uzp1C0uFcTBw6gyatiaWAMHUF5V4yKTLZKj+j3Z1NLicnxgDe17Z6Arx6e9nFY4MQ9fT9AS
	DV6whNrNqisbLPR0IXN+4wYox8XDytvpSNyV5vaGoSSArkvZiqaa8jgnprKRUJrmoIS5wp3D4E5
	RJLMf+9YBKgSXjSiYix2ngTOXOapaVaEw7b9NU0vtpQcuR4mFtD/Im+cHjaecY9MvsP0etoBkJf
	44GKi21nB2fZiRz8z/1dNUkFZ5JjxDd0FPJkxRd2+CL4WScLdLsjGZof2KyM7UKWtb7hbMkZpzt
	tjf2pSKO7z8vowGEN3EmhjBfHcgHHVHmeOIVpOrIp3fOBjOyLDXN41OwJX3tMxZrnXm2rvgFqug
	lah5Ir2D9LajleUfM=
X-Received: by 2002:a5d:5f47:0:b0:430:f7bc:4d0a with SMTP id ffacd0b85a97d-4324e4d31cdmr14427945f8f.28.1766479200653;
        Tue, 23 Dec 2025 00:40:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHwDTMr5wp5xvEWfyQz62PQbAd6PQZsRofi2qgKCYcIlLqRxTkWwW2f9t1a5RIfTPptK9dD+Q==
X-Received: by 2002:a5d:5f47:0:b0:430:f7bc:4d0a with SMTP id ffacd0b85a97d-4324e4d31cdmr14427932f8f.28.1766479200276;
        Tue, 23 Dec 2025 00:40:00 -0800 (PST)
Received: from [192.168.10.48] ([151.95.145.106])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea2278dsm26828644f8f.18.2025.12.23.00.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 00:39:59 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Ryosuke Yasuoka <ryasuoka@redhat.com>
Cc: pbonzini@redhat.com,
	vkuznets@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86/kvm: Avoid freeing stack-allocated node in kvm_async_pf_queue_task
Date: Tue, 23 Dec 2025 09:39:57 +0100
Message-ID: <20251223083957.878510-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251206140939.144038-1-ryasuoka@redhat.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Queued, thanks.

Paolo


