Return-Path: <kvm+bounces-47683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C002EAC3BDF
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 10:42:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 729FA174F0C
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 08:42:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 706411E5B88;
	Mon, 26 May 2025 08:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WiBe1lCr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12108158DD4
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 08:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748248930; cv=none; b=a4zMt8uRaHcBstuxsf4M/bXqihaKiCd30cY8LHw/gmp8uisI224M5T6XyZQBRoSraCGVh9ewPqnKJci8XTLXYDt+hwH+T1n+7A0ScNQV+j2umAiC9khl9T0C6iYs/4sgXWPNrhM4eAwUxagyKYiwb0v9NAgnE2PW0bWwF94/xTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748248930; c=relaxed/simple;
	bh=3oGPJDRJqFKfyLapo/BpmbZZz/LQDtE9HYxr5Bv7qPg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JlFX5bNv1696QJ+oRx9cL+/uSqXUsqOjl/391noE+M9aWsYuRqDBPuiy008RiFP835FTdgWCFR2rx9ogN4n9NEzh46dT8xJeBh+IsStZ/S5OqWWjvSWiwqtWz0Uk5lQvzHAZN03VOxHIP5PT03E7PQ+XsKnHu6nQRdK4MI897j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WiBe1lCr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748248927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=97kbZtlgIExA4qKYGRP1ynOk/EWcY3gmjZBtZIIcE1E=;
	b=WiBe1lCrkENIHDOAWeMkvWrzbGPEZNujyO7CXH2D4LpaStBbLbC6NJJ5AFjrqJ4BRLuNYY
	AXNjmCdN05BY/yXJQ6imUCFrf6XfMLwdNeDvK4XvkPa+VPiH8HJRyfAqhf14D8Po97mqiU
	kk9kU1eEd6d86oEq9p4KgCuHpd7Vf9I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-hoDHDDGuNUa_VWVDUSPH_w-1; Mon, 26 May 2025 04:42:06 -0400
X-MC-Unique: hoDHDDGuNUa_VWVDUSPH_w-1
X-Mimecast-MFC-AGG-ID: hoDHDDGuNUa_VWVDUSPH_w_1748248925
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-442dc6f0138so9135765e9.0
        for <kvm@vger.kernel.org>; Mon, 26 May 2025 01:42:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748248925; x=1748853725;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=97kbZtlgIExA4qKYGRP1ynOk/EWcY3gmjZBtZIIcE1E=;
        b=EeL7/TGqTaqLVjWlBXZwrSk9tG34z6ZAyXIZ7ZiKXj4QzUTK0i8+nzEzZRr9Vu85FJ
         4H9zoIXYYeZUW9F+tM2WhQx1wxLkY3EMjxs/OFaN6NEjP21I1K0H6o66vjmxzAxH73qH
         v/iml2DzDOjCyTGSw5Esm4sFdVc6rcokm7upIEUkTqxEIz/FGFgtHCy3SKL1a2SX0081
         MEYpDKIfmRARk5qDHr2LobmrazInnQYSAvUW8EJKfBh/oDEGOXqXuiDoHzli4JAs1pxP
         yX6JCDJy4NGGZFA0jjKqXH8Z3Ikzdvv+yoiu2XWSGeqUyLRD772uObTopZrE2IkwcIzZ
         uOJw==
X-Forwarded-Encrypted: i=1; AJvYcCUDyVJiBRRR+B5GIhNRKo0kR8G8pwP7DUyowhJORDSSRrO2To0jzciBDhomiR9NrnTOsek=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/tUhJ3Fz8N347gQ4cBc4gmwxQHyS+YIv3ZgVrtoqn7n4h0JHg
	lq+RHNxIbmCOzyN+blqxirfHIrFTuF+LJKCZBYHJspiFB8xksqdK5tFtXTboD8PH6K0m51Ob7n/
	a1ly+A8DAGYGCsJ5dAs9WH36aZdlsZv/Sq614/nPa9q4Y9kBI04hppg==
X-Gm-Gg: ASbGncvnhAe+W1NP+m1ONqoH+IU1kSyknLDuq28BAYKVHOOyf/V1pgRuQTwKKTEbZiM
	0zuL4JoFrk5wJ85FE1oL93+edduG3+4T0DUrybwFE0iucoMvSdRqfNI9yEufdGht92aiB7a/Zx/
	Cplkbjmmq1lOfBablYT+d1DmjnGitKJdyCQsDWCEmyhnIgiXuatHyb3DOWLE6SgfL3dVD9yVN0K
	NVWY0okj2Q4o8GDk60klnqu/YU7Z3NL8uGegKFO/pmqCElXoaKtj+W53hWAj/bnjFWN6ONYbMug
	dhCGnWDCyjwWxqPkKJ61KYxy71eQXjn0k8qat73JTA6xdxCEYqdyaHfrXWBzm+v63FXhjwtjTwL
	nVUR8021Irbdq8/82k65K0RM+Eldu+17mpTB73Ao=
X-Received: by 2002:a05:600c:3c84:b0:442:f4d4:53a with SMTP id 5b1f17b1804b1-44c9151293fmr82089725e9.2.1748248924818;
        Mon, 26 May 2025 01:42:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+4zjh0O/r8X0NQKFOR2Y6GHPZFlzGjvoXiENYfVluXT0XK1FAhn8FH2HkNN46fQhcZ46RPQ==
X-Received: by 2002:a05:600c:3c84:b0:442:f4d4:53a with SMTP id 5b1f17b1804b1-44c9151293fmr82089345e9.2.1748248924369;
        Mon, 26 May 2025 01:42:04 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f19:6500:e1c1:8216:4c25:efe4? (p200300d82f196500e1c182164c25efe4.dip0.t-ipconnect.de. [2003:d8:2f19:6500:e1c1:8216:4c25:efe4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f3dd9c21sm234863005e9.38.2025.05.26.01.42.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 May 2025 01:42:04 -0700 (PDT)
Message-ID: <7f10e5e8-9585-4323-96d5-760e6652db1b@redhat.com>
Date: Mon, 26 May 2025 10:42:01 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/10] memory: Unify the definiton of
 ReplayRamPopulate() and ReplayRamDiscard()
To: Chenyi Qiang <chenyi.qiang@intel.com>, Alexey Kardashevskiy
 <aik@amd.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
 <20250520102856.132417-4-chenyi.qiang@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250520102856.132417-4-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20.05.25 12:28, Chenyi Qiang wrote:
> Update ReplayRamDiscard() function to return the result and unify the
> ReplayRamPopulate() and ReplayRamDiscard() to ReplayRamDiscardState() at
> the same time due to their identical definitions. This unification
> simplifies related structures, such as VirtIOMEMReplayData, which makes
> it cleaner.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


