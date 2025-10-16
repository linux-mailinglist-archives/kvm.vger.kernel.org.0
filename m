Return-Path: <kvm+bounces-60178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C0782BE4CD9
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:15:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 02FAD4E4C01
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:15:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E13073346B5;
	Thu, 16 Oct 2025 17:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YuZKRtx9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFEF334695
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760634896; cv=none; b=byb4rqZ3ydh+PttS9LyEb+nBoSl0Utu0IavbUE7/qIZ+GndMmm59rylvrVaVgsXu8FRlDjv8FxUooPUYsI5FhSapm0aKW9KYlUOOeakcCN8ZJqo+beac77zEUCUTn3Kkq8jWlb4MCrCsHjGqnO9hrhvDTc+ZDUzBpPMRrVqFi5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760634896; c=relaxed/simple;
	bh=ZVT0FUA2ySfAFojzoxxwDLkOFBjP06wCKzzAcmPFlYY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=reM7BBI3mjyL5J9fiZZ8Q1n9dm/8cd9B39BeEYVt/Zk5hnsSgwb1/3C8TWcphR32NuIp5u/K6ATtDQt6BTE8KW3laJKQHxa2o+9WzIP0Gs5TYFwLq+o8MLIPeSTPkUShMOCQOGiQFWcXcM91mKFv6B2A/kzuiADgM1yWkH0MkmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YuZKRtx9; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-33bbc4e81dfso802572a91.1
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 10:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760634894; x=1761239694; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ci/F42ux1jJkTEQXrgFt6RzYeTgODsZDi7fkjO1JtVo=;
        b=YuZKRtx9vpq0ORtROPWyre/fNi/AwsjL4oQUUkj+RlamWOGrFhbL3rFOWdkkb8/3XW
         uZs3xLmH4tAA3Ol1VRG0TAG2FbZjfbme5shl40bWSiXBGa/e2CnNfPeWG4u63ZyS7+xK
         vJ0ehDMT5iZ0Ic4qt9rF0fvCk1T8c5/kaa8ES6hPlYng8VHb+xw2aQByeLCo0H/cMqxL
         mi9bybWIukZaUaKqlgxS1M9WEiFsXTLIiDRzFDyzowc/RI1moJrm2IO+SfxIvRK2QOvr
         +7l+Jc+6VLRZR5uMh1vaozfMIcg/F7ih3WFi0M/7AZz2/U1AVCTkqULpJnEEC24B2tZF
         E5dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760634894; x=1761239694;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ci/F42ux1jJkTEQXrgFt6RzYeTgODsZDi7fkjO1JtVo=;
        b=RbuTHn9Ex105zH4rO77UyELBGXgauHpcj1jDYZ5MuQph/Uu1Nlk2BOAc++u+0wbPZg
         4ULRCJhx4eydVLuJvB9OJD5WRXdCjXNAb6gcwrm12iw0M60UnyF+9X7q3f7ekEjxl80x
         7LL2mG11jkMsHmVSbYcjaNROcGh8P7cIfDtnDJTKdbNJtHR57RLQp7oKTqQnQ2kEsOl2
         YoIWe7XFi7J3fpQAyifZYNn5mL9/4NmMsShG1/9dT3LrlSiIwUMRVGP7DkwFGd96PyFY
         vdBikpoz6U7VxxCxkBcII6CkzjA5zE/gqwN2q3SKvjHWElCihHVGSiScqJPhyUDZ0Oh2
         z8IQ==
X-Forwarded-Encrypted: i=1; AJvYcCVsS3uqa5DiOazV0k1BxGNLuTDXOmnnCIJErq2Y16M3+hdExwHT+mXrKLI9jEyutGW54Tg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPzsKEGOLRxqj5gSrbSQ8hnvZcEef6qPGtljcQAzvJ5IEvJ0L1
	QA78vNdKSBm4TyBDEvQKKiDvE9zLVAzVjSmgzS2kwMh0qCw4xGdnjh5oq1p9fLC1BoU=
X-Gm-Gg: ASbGnctnE8qM7YAKBbjkrVIQQsoc2GG6sDDfV7IvQMqDknTNhNWlaX0tP7vrXXkBJbG
	XEGFa6DGxjZHmIiWaOTIF4tKsZdMD6WxpfXgIqRVRFecDrSSv6bkml/0zzAlkvqU/5qgELBRvFo
	W8fajtaOlQQymKoTm29X24dx5aYRlrdCh40YDLlDxYq3FgrMCXQvLsSACI0PyVX4HxU6CMXJlWC
	ZZFH0UWOMyAClL4or7hNnwuefwole8au2WFB2uPoMBUaDg40u7lEjmZGdXBQot++Wkrq9I9f9RG
	qzxD3HMdWANWWeOUKtaSVsA9Qr2bUgPHbuRQ8ob9D1RGM9uFEtCgFeeboM2yY9fS5PSWFIIY6Zs
	gJtJWqf4ga5sz8fR+5DUwba5VK2QALDMSWdIH4KvrJgYx+QfFWI11aBtA33qcwvBSss7FiVwSz7
	dt/MKJymDKAYwc
X-Google-Smtp-Source: AGHT+IESHVS5zp8LjiBu3X4lB7NPHFDhxojp46lSTxY7yZ18tWMQWxkehHD36yDCKsmzvWqqfozA5w==
X-Received: by 2002:a17:903:19f0:b0:28e:9a74:7b58 with SMTP id d9443c01a7336-290cb94784dmr8453135ad.31.1760634893676;
        Thu, 16 Oct 2025 10:14:53 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29099397d3dsm36335125ad.52.2025.10.16.10.14.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 10:14:53 -0700 (PDT)
Message-ID: <f0780d08-7487-421c-be4a-a5c5664f1507@linaro.org>
Date: Thu, 16 Oct 2025 10:14:52 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 22/24] whpx: enable arm64 builds
Content-Language: en-US
To: Mohamed Mediouni <mohamed@unpredictable.fr>, qemu-devel@nongnu.org
Cc: Alexander Graf <agraf@csgraf.de>,
 Richard Henderson <richard.henderson@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, Mads Ynddal <mads@ynddal.dk>,
 qemu-arm@nongnu.org, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Ani Sinha <anisinha@redhat.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 Eduardo Habkost <eduardo@habkost.net>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Yanan Wang <wangyanan55@huawei.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Shannon Zhao <shannon.zhaosl@gmail.com>, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>, Zhao Liu <zhao1.liu@intel.com>,
 Roman Bolshakov <rbolshakov@ddn.com>
References: <20251016165520.62532-1-mohamed@unpredictable.fr>
 <20251016165520.62532-23-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251016165520.62532-23-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/25 9:55 AM, Mohamed Mediouni wrote:
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> ---
>   meson.build | 20 +++++++++++++-------
>   1 file changed, 13 insertions(+), 7 deletions(-)

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>


