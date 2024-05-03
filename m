Return-Path: <kvm+bounces-16484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 986258BA719
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 08:31:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FBF6282D93
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 06:31:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08438142E76;
	Fri,  3 May 2024 06:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZZOgSxBe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C0F142907
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 06:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714717913; cv=none; b=oTPHVobVbJgZMDRH/hg8cDAcvo/Dnw9gLEX47PBH5If5PUYGBwm/iWr7E/YDwuoR9dNjo/t5wHvyX59jCEXg8iPLGuhS7tbGAKOxnIgbceq+sde5Yen/6VxPe884tO+I7fl7VcckrFuuxMUnP5tsREm/HgThhQMshEhIMu2j4XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714717913; c=relaxed/simple;
	bh=HoEfS/fKJbeOLdatJy+clZ2T2MSVRJNzWdxRRquB17s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AEPu0AmK/Br9W8GN9W3D685MkG/DiEDU/OWxBXu5FjqCuWLPM7cr60754I7nDHlKZCjaS0PjkQuAKgujQlTt/TPmOmYObeBTgdeffhogKSmjdGDbC7SnLJCj5HQxnCaAD12E6OF9lzuG3MP9DQuzBuz2N5djHfBJY4pdGDBmX/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZZOgSxBe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714717910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=H/4JzxjFS5yM+QQaQ2wyXNUf6vebIQcarghqSatrFbI=;
	b=ZZOgSxBe3WxU/ofY7MXxsMYxJRLorRcchWXfXUkzJEyXyq/4y8IUDodpfCDiLd0b57lIHG
	LaHrW7+rbyKLM7xYJwbDEyYRGz0W5oZsithvQj0bh4oRRh6FIFMXKw4f8Ug6a/NeAmtdex
	yCmXYt6Q7bIl4HEG/HU7G/zPWyI6XBU=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-385-jypljNJfORSfXiNdTC-FTA-1; Fri, 03 May 2024 02:31:47 -0400
X-MC-Unique: jypljNJfORSfXiNdTC-FTA-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-43ca9049597so32479401cf.1
        for <kvm@vger.kernel.org>; Thu, 02 May 2024 23:31:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714717907; x=1715322707;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H/4JzxjFS5yM+QQaQ2wyXNUf6vebIQcarghqSatrFbI=;
        b=CL7wHE9Qo0LNdfL40MAXcaGkBYavp8XtzmKbKuL2eat6NEBO03UoX6glwf8GvDXbOq
         bd9j9ZGD8vQE4dNAP6mP670AZguAgkhhitrzGdsdSRZfx9P3FJMSBL9pqOUIO0lhGkWc
         9DACNvBqqvcYO7pJ7hnI+JLPSPqAWpCrqSpPIrW0coaWt5aNdL59i73yD2Wt4JNds7tn
         mHF+ySvWhTPoAi0oRC3VMK2nDgkvlIK7SpuEb6KwJXjbJJWTaaT44K9nzrwnmB0WWsQu
         sAnmmi0+BeGCXHEgCeYGe5YQ+LrIAUGTZ3nt9j3mDW2OduESMxVOyYdGgomPMvIatxlH
         7YAw==
X-Gm-Message-State: AOJu0YznE0sBL5uDpf1FCYtQ7Fha6v7vKJvc+o/Wo6Y5E+8Iox+x1Rwn
	vAIJYFcKsehAOHThHuKB6ms6g6t3kNaRFViPtY22cvisU8eb4yysMkLeKYF83xTTARXs91uhWnv
	t/z3a3NRJ9NTTvI+DR8YWlRbuT5J+LYVjdWJP9+Fc4szL54NYYw==
X-Received: by 2002:a05:622a:5497:b0:439:de9d:620c with SMTP id ep23-20020a05622a549700b00439de9d620cmr8311301qtb.20.1714717906896;
        Thu, 02 May 2024 23:31:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGxYjIBoQqRFApj/utkACB3cLNgejVeONEXGUl38X6XQTMqMD5LmarHnVDzza6cjtPuw2WYWA==
X-Received: by 2002:a05:622a:5497:b0:439:de9d:620c with SMTP id ep23-20020a05622a549700b00439de9d620cmr8311287qtb.20.1714717906543;
        Thu, 02 May 2024 23:31:46 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-34.web.vodafone.de. [109.43.179.34])
        by smtp.gmail.com with ESMTPSA id bz6-20020a05622a1e8600b00439c1419553sm1249735qtb.44.2024.05.02.23.31.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 May 2024 23:31:46 -0700 (PDT)
Message-ID: <b6f3bebd-e530-4fe7-acfd-c04fb85628d9@redhat.com>
Date: Fri, 3 May 2024 08:31:44 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 1/2] shellcheck: Fix shellcheck target with
 out of tree build
To: Nicholas Piggin <npiggin@gmail.com>, Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org
References: <20240503052510.968229-1-npiggin@gmail.com>
 <20240503052510.968229-2-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240503052510.968229-2-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/05/2024 07.25, Nicholas Piggin wrote:
> Prepend source directory to script names, and include source directory
> in shellcheck search path.
> 
> Fixes: ddfdcc3929aef ("Add initial shellcheck checking")
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 6240d8dfa..b0f7ad08b 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -143,7 +143,7 @@ cscope:
>   
>   .PHONY: shellcheck
>   shellcheck:
> -	shellcheck -a run_tests.sh */run */efi/run scripts/mkstandalone.sh
> +	shellcheck -P $(SRCDIR) -a $(SRCDIR)/run_tests.sh $(SRCDIR)/*/run $(SRCDIR)/*/efi/run $(SRCDIR)/scripts/mkstandalone.sh
>   
>   .PHONY: tags
>   tags:

Tested-by: Thomas Huth <thuth@redhat.com>


