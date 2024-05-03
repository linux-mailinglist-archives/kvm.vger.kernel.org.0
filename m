Return-Path: <kvm+bounces-16482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EE97E8BA709
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 08:29:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4E0D281525
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 06:29:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A06E8139D14;
	Fri,  3 May 2024 06:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V4Pp82r2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171B7282E5
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 06:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714717750; cv=none; b=EwP5g1s25U977Bwx8gBoMn/n9oqH6OnXv0jjWBds4oOuKKjEmcUqh0MXdNEUuaSIqg8qUvlE1ympZPzJjkGosdrR03o+30c/St/GGmcx708M52Ytrko+xXyYZ4HD577c3UDAW3kCEPvit5YGlJvBgqPR+uzd+P5XfT9V4Bs91kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714717750; c=relaxed/simple;
	bh=kdnZ24BANz6GXJDYVJ6TWACJZpAb/u2ljJc0pRA3KBo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j9BKmfdYADGHj7EnhahWQJt5/HO4RnJtK5qQc9zmWciVRzakW8OqxcijOopm2nbS2voZY1WK1/lirINJIHIvkZNQl4egaB59qjvAtKIMfcx78kTt5LzKvG0sKtf2fWcv/roFLKULR/351a4G+/qbBLoU1WRfGFPXIwvqZCoawUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V4Pp82r2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714717748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=haUABqYb3WxUO7RYpzuTBpJl09cED3bLMxSRDZkomG0=;
	b=V4Pp82r2Hx6S9GvYYjuxX9EgixnowaT6kDhtyzo2tGaznBK0fyArWdcwAQWZkw9eRzofSI
	kgA3Veha8QzGL5jbT4fnMgkHCu/ynLQ7bT3KS9PYtIRMTZdCx88NQeYJa4kJcqltttmost
	YqAtykPNEnzwPsEIcqV3mGa7Akeo9wA=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-40g_p4h_MvCVMeRe2mZKuw-1; Fri, 03 May 2024 02:29:05 -0400
X-MC-Unique: 40g_p4h_MvCVMeRe2mZKuw-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-61b1200cc92so166931687b3.0
        for <kvm@vger.kernel.org>; Thu, 02 May 2024 23:29:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714717745; x=1715322545;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=haUABqYb3WxUO7RYpzuTBpJl09cED3bLMxSRDZkomG0=;
        b=UizofbPHsH8qCKFSvnwTP80OFn8VUnOgGFauuLS59W4hZ9jhdnDrNspbbvZcpGALiq
         aRhVWGJ1CGoh8W9JHVo9ZcNaJ+NxjAE0kH2ADlsYUerTphIAinKoEgnnXHodVuI1D/NV
         IhIB7FSBRzMoyKzBMCzfLCmwNGzcXI5cKanvBtRMpUzaLMdU/d8Q7qLyb/Jl8ddcWpn6
         Zmx+C7mN/gROwaswn16BJv4Lwx0a/MTKDabvPEACmpkbqh3m7vN5e0FO7D8VCiyq3mHY
         2+bMTYFBh1Md/uhTm4aOYE1fdwtyBdFQboquEBBFqm5OqR7jUC/tbv1pEOl0DhKir/io
         i4xQ==
X-Gm-Message-State: AOJu0YwjMoham0j6YC/IOKD0Iz3vuGiVFVB8YMQQztsdmoQxSZDFyrGK
	ix5DOaotaw1H2IOdzN+vM2sxzZTNYjSD3bSHBgN+8hlTvHzjZoizUy80FQQobx3c156HlQ+iH9A
	rWckj2jr3FT1fBsu0IJWCnrZ3aE0GRhYAKiy0LkZroeTz4c2ehzDwI7gNaQ==
X-Received: by 2002:a81:7b84:0:b0:618:6c25:b6f6 with SMTP id w126-20020a817b84000000b006186c25b6f6mr1513076ywc.39.1714717745343;
        Thu, 02 May 2024 23:29:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGe81SZUh5KG210b4lx2c/MT+qX24HEedkzElXWeuswInQAasNTj9HVpkpBXjGfP+beW/QhKw==
X-Received: by 2002:a81:7b84:0:b0:618:6c25:b6f6 with SMTP id w126-20020a817b84000000b006186c25b6f6mr1513069ywc.39.1714717745028;
        Thu, 02 May 2024 23:29:05 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-34.web.vodafone.de. [109.43.179.34])
        by smtp.gmail.com with ESMTPSA id kq16-20020ac86190000000b0043ae903ac61sm1235907qtb.75.2024.05.02.23.29.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 May 2024 23:29:04 -0700 (PDT)
Message-ID: <19c4ed32-1ca7-4ba0-bdda-44918c5bce4a@redhat.com>
Date: Fri, 3 May 2024 08:29:02 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH] Fix check-kerneldoc for out of tree builds
To: Nicholas Piggin <npiggin@gmail.com>, Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org
References: <20240503053612.970770-1-npiggin@gmail.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240503053612.970770-1-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/05/2024 07.36, Nicholas Piggin wrote:
> Search the source path rather than cwd.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
> I leave ctags and cscope targets not working, since I don't use those
> tools and so don't have a test at hand. Being dev tools maybe(?) they
> would only get used in the source directory anyway, whereas check
> targets are useful for CI, etc.
> 
> It should be trivial to fix them up if we want though.
> 
> Thanks,
> Nick
> ---
> 
>   Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index b0f7ad08b..5b7998b79 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -150,4 +150,4 @@ tags:
>   	ctags -R
>   
>   check-kerneldoc:
> -	find . -name '*.[ch]' -exec scripts/kernel-doc -none {} +
> +	find $(SRCDIR) -name '*.[ch]' -exec scripts/kernel-doc -none {} +

Reviewed-by: Thomas Huth <thuth@redhat.com>


