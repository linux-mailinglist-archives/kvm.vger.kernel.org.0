Return-Path: <kvm+bounces-29442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 217E09AB8CD
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 23:40:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D21EE284CB7
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 21:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF22E1CDFD8;
	Tue, 22 Oct 2024 21:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GwUaFlTj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611211CCEEF
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 21:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729632919; cv=none; b=fW6U3SStGJJZi7mH8q+INUv9cfQHZ9RcG8+TwIRq/o3Y8aGXEKL/9CxwZncKP3pCpkzhzQfBoRqofTVkK/+jsxXOugOTYok/3OvJkwuFqmKL4qisM/opQloy9t+EEduUshSQ1fpEt9n0MiOQmD74UwjD/yIOrKzElsVP1UA2mH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729632919; c=relaxed/simple;
	bh=pD5LrCdEU0DJjza3fe4Butfhayfbn+qk7Feiyoxj6zc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R0JAoPvFX3MELPsXeUg9pEvHN0mbZg8Nc3IWEujKhC8qJsgxWqzDTSISU085PQEqN7bf3rdL1hn3uJgsthAJjBzgxxSBrOJpZERxGC9T2Vh5Xr74B3byPIhgYtgQQvnNsFKrBHb4ptmxVqJQgV0zAblypsssMs8n6m2nQ+oKyAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GwUaFlTj; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-7e9e38dd5f1so4592323a12.0
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 14:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729632916; x=1730237716; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vrjd+awV4p1X85NUzivqgfpDIpXkjLSWu5ANEGZU2Nc=;
        b=GwUaFlTjUInynkhas4et4oxA0dd7fhAD1LUUiZAzLqG4/5/hvFYnS22sClFdWmNKcP
         wLFkfws2Xc3dWWowUnOO2B2Mg1fPOMFP6YTlgPUQVjt5yIRQpiWf8o92u1g3rC2UFtZ/
         7s+Tb6Y/moUaeE6kyIU2LLeQqC8dU166ZirdKU4KPD3VBiyT0O+kgGy9E7F2pE1CVMRk
         9caGbpJAQmlseYwaQ8ctS/Xw10wXzStJH2N2qaQvj5shQ/ltIwoL2Xye22qH1bh81lAa
         t49awr5WuBiPeQklpS4/S2VV5abprByxkqR6bnw3nKtn96waHVzEhhZFQ+HXhZkZ5wn0
         bCYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729632916; x=1730237716;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vrjd+awV4p1X85NUzivqgfpDIpXkjLSWu5ANEGZU2Nc=;
        b=rybTo4k93zr+clhU7iZKUIH1Zpw4W8aHcuZFhesJnDeVUocr+qGyrd2cFg4UADd8/m
         YvOvB2UGqW9dzIjETgH0lWtNu0WNoUj8uAzzF1ZJlEQacjJdu0njqKsezYsf+Lp34NuW
         BLCazyxcTtObZP5YQBTEHDiKwM5VL/vMlnwaCFxjqtiqgzr76rYKIc8oCTfe8Wgi2cfz
         PXQhyCkZq1AxrAl8TB1qRoj52wktOan72x+IyxpMvIBkQkblxYZKqJKy2Wi63IwW+o8E
         rPlnQ6Got+fhqZSY65cU6Gzyt/DIpIoYRfisUETgBzG3Rmc3c8u4h2LQZBh7R69CY8Dp
         mXxw==
X-Forwarded-Encrypted: i=1; AJvYcCUBsFpd86d4QrXWUlkE8ig/cn3W1BnaAYdjMuD2E/dytWugysVz8RX/FQ+z3XDVngav5aE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZ1xuWdh17ES22VaAjphTaaE4BSNK6ce17pSZSCuAPWKQCi8yn
	OoEGBTwtUq9DuldcxhLV+isZEr+MGNGIeK7NKmckCSiJLQLgaDVFByQ40I21n64=
X-Google-Smtp-Source: AGHT+IHwvFEbSklJvPoqvUT2KermREbxK98wEJFbsYF3kmhEawq+YoepuIPGAXgjJxZwB3YiPbaqXg==
X-Received: by 2002:a17:90a:cf93:b0:2e2:c6b9:fd4a with SMTP id 98e67ed59e1d1-2e76b5fee60mr394865a91.18.1729632916590;
        Tue, 22 Oct 2024 14:35:16 -0700 (PDT)
Received: from [192.168.100.49] ([45.176.88.171])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad4ee3b0sm6714339a91.42.2024.10.22.14.35.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2024 14:35:15 -0700 (PDT)
Message-ID: <361bd240-5203-4671-b201-e3814c8aef81@linaro.org>
Date: Tue, 22 Oct 2024 18:35:07 -0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/20] MAINTAINERS: mention my gdbstub/next tree
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: Beraldo Leal <bleal@redhat.com>, Laurent Vivier <laurent@vivier.eu>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Mahmoud Mandour <ma.mandourr@gmail.com>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>, Yanan Wang <wangyanan55@huawei.com>,
 Thomas Huth <thuth@redhat.com>, John Snow <jsnow@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 qemu-arm@nongnu.org, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
 devel@lists.libvirt.org, Cleber Rosa <crosa@redhat.com>,
 kvm@vger.kernel.org, Alexandre Iooss <erdnaxe@crans.org>,
 Peter Maydell <peter.maydell@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 Riku Voipio <riku.voipio@iki.fi>, Zhao Liu <zhao1.liu@intel.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20241022105614.839199-1-alex.bennee@linaro.org>
 <20241022105614.839199-12-alex.bennee@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20241022105614.839199-12-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 22/10/24 07:56, Alex Bennée wrote:
> Make it easy for people to see what is already queued.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>   MAINTAINERS | 1 +
>   1 file changed, 1 insertion(+)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>



