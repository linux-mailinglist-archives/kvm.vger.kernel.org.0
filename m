Return-Path: <kvm+bounces-3288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CC51802AA0
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 04:56:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 689AFB209B9
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 03:55:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8E9F468B;
	Mon,  4 Dec 2023 03:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GUxLCuiB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E21B6
	for <kvm@vger.kernel.org>; Sun,  3 Dec 2023 19:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701662145;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I92/j60TSCBakqaPEVVxZt4pRYRkf7RLD6d2CKY7eKg=;
	b=GUxLCuiBO9KNeuKJPRGUDT67kN706zD+gCZuzhePoTONe07tJi/1LsiqDT+n42kSs0j4Rh
	Xa2u00RRB9/v264iEylJAn0CaV40+obX8mfQFxatjKy6CPcadCiS3M8CCuMC2kRA9fc8a2
	32Aj0GG6d1GegmD7FlQH5eMSPU1zZAE=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-nGTwcJcFMDKLe39Pd7Z13w-1; Sun, 03 Dec 2023 22:55:43 -0500
X-MC-Unique: nGTwcJcFMDKLe39Pd7Z13w-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-5c5c8ece6c4so1362617a12.0
        for <kvm@vger.kernel.org>; Sun, 03 Dec 2023 19:55:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701662142; x=1702266942;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I92/j60TSCBakqaPEVVxZt4pRYRkf7RLD6d2CKY7eKg=;
        b=EPLDvuek5YWcT6NsaE4JjAZKA4pI3uhMusm+Wd/8MyeZsBTVmxT/aQgLjOMnuXXhdn
         ZcfgQHfkj0h2xkC6r7sI8HO6ywmBEjh+lWWLSvYxZFyaxyc0fWPm1n2yKEj+TuUld/cl
         57dnHccz99IvdJbIAb64LH5IkTZSyYDCjb1HrRBgIU7NgE1tUFeXs7lVNoWvw7sYUTtc
         6hdggKN20YyJdIqVKmjcjuUN3BjAFW7eZEpL/7Pj/xp0zKX50aAiEqUwhzAB4q4ekVn4
         a2ZZ4O0qLxrvPmVsrITBwajpk884eiR/KQEmf8p2V7SEcOgwS0rYS6x75mkBDmGJF+Ew
         qoFg==
X-Gm-Message-State: AOJu0YyoaUpKUEWRc5aJ3ebuX+TYyLBwnBdhhMwpFcZ60ofnuMKSizBI
	u+Ntzx5i75Th4dj/RomC0+7M173xCfSDpQA+baxRqi9yAcnIzH77pjarBW5uSo74cGK7YcnBV7u
	Q3bwpKFdFmDgw
X-Received: by 2002:a05:6a20:8f17:b0:18b:480:a0f3 with SMTP id b23-20020a056a208f1700b0018b0480a0f3mr1532930pzk.4.1701662142752;
        Sun, 03 Dec 2023 19:55:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFhPF3oPRXbMnAtkDjUbXHkfL5W0i+4xqobScQM6+3X2VUXFr1vLfh6ARsSLBh3Wt2EQ7rX1g==
X-Received: by 2002:a05:6a20:8f17:b0:18b:480:a0f3 with SMTP id b23-20020a056a208f1700b0018b0480a0f3mr1532921pzk.4.1701662142460;
        Sun, 03 Dec 2023 19:55:42 -0800 (PST)
Received: from [192.168.68.51] ([43.252.115.3])
        by smtp.gmail.com with ESMTPSA id s16-20020a170902ea1000b001d0855ce7c8sm2105952plg.252.2023.12.03.19.55.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Dec 2023 19:55:42 -0800 (PST)
Message-ID: <fb66d460-b995-427e-b5f6-702ce651a06e@redhat.com>
Date: Mon, 4 Dec 2023 13:55:39 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.0 2/2] target/arm/kvm: Use generic
 kvm_supports_guest_debug()
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20231201143201.40182-1-philmd@linaro.org>
 <20231201143201.40182-3-philmd@linaro.org>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20231201143201.40182-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/2/23 00:32, Philippe Mathieu-Daudé wrote:
> Do not open-code the generic kvm_supports_guest_debug().
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/arm/kvm64.c | 9 ++-------
>   1 file changed, 2 insertions(+), 7 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


