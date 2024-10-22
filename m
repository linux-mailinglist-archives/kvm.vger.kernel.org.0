Return-Path: <kvm+bounces-29448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 16ACC9AB8EC
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 23:42:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 70B43B25520
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 21:42:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 485D81CDA16;
	Tue, 22 Oct 2024 21:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NskoVBnA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAD01CDA04
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 21:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729633081; cv=none; b=tQGGVFXdy6RnDkO8oPEAGvIPqcBN2mT5wmbGOG60/hUwtpHLCjRi4/3YrSBhUEO4d9VS/ju1xX7JExryy7MN7IAQWCUFHz1pLwHJuP+cU1uAmbQ8jfQdM+cTyuuJQaIxqmCMst5eWJL6E4v8E5Ke002U2f5hJSHaLpUECMqze8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729633081; c=relaxed/simple;
	bh=3xv/RECQ7TjvypUtuFM/q0loM08x3odgTJyugInVOtc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q7i/TMeQTOLFTUdZYKV8z/epZzQ/UcaTEDRFgDtWxg6Yt8N7wzQ5Hyudtfq3A9w84qdr3bSdnp25IEGKPTlQ5R/kkSi1x5dGPXz456ubJcYiBMvZJi2F5/3RBpjSzZWEmzZiGs3uYRQwppYNtZLCbgKFhEwkteW1UcvHfgLw2/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NskoVBnA; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-20c803787abso2050555ad.0
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 14:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729633079; x=1730237879; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VUKVknCSlFqFsBqoQ9goFiTR4ArnZOnvNU99XEHFp3w=;
        b=NskoVBnAnJA+NYRr0M4MedmtKKhGk26EeKkW7dqoUsSlvVg7uS7mNi+iBFB5UtwiA0
         bFTHP2UlDoPerl3UYn7/w8e+Z65EsfVcU2dFC8ZSwcyi5tzY/IqbIUV0bC1VJp2Sp9b8
         Zty9nkSwoBvWY/qXHd4mPVKGHD3fniB0/W2YpskdIkKiViqM54dIj5Qk/0ecY85+NhZH
         ODt/IhSiKN6rUJtpc0VQs404ZuvOevTCU+0sr+pYvquuovWXGv0F6cP+obaDxZYSqCiM
         1Qj6BDrzMCBo5ig2A24QK5uJwatFYGWsv/y91hwusQ+CjStb8Z4iKVlSk7gQ5vBwMIrL
         bAjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729633079; x=1730237879;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VUKVknCSlFqFsBqoQ9goFiTR4ArnZOnvNU99XEHFp3w=;
        b=bAGmUJRqb8/GAv97HR1pyPrpkiyKTYJgJzxATYb36Q+8froakdnNbnzA9M1QZ0W4cq
         MAxyTx/JP9IXU91TKZtigIH0IONlV19jM3rQwktp6TyLAQVL3MtXnVR8iZmsqzxcgDXf
         18O2UoXYvSwPpwqI9wT4+7bEU27DZaPNtDZnF4GX5F/Nd9enefAL0hjNgsIxQuxZh081
         UCvgRN/OkR1c5PORsUDqo8NhgkYQlgHelIZuYg+Wh9ipmwdb04R2NeLeLolR4BWnRD7x
         ZaNa/KxhUkKSA9PACLMKX2t6OnqRYyYFdUQ9wM8FNRtEXO41+CvLKsPq0OSDHLWExx0q
         A3Cw==
X-Forwarded-Encrypted: i=1; AJvYcCXKK76IzHURwYhnZB9WxhuI0OvZSN6/zxTZXegQKzlzAo3689mDAfcI5P7QwJZqZyUXIIs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8VPLKk6PJPYT3k9m8XZR9xGaUnVWnv8Mtp/0tB/A1wWgG4bvg
	ruZMdxwtMN4f1cUF/2enuS5ENhUg1lGoDa/308URy5a5Ijdr4aCJWqgUTle3HpQ=
X-Google-Smtp-Source: AGHT+IHlm9BqHLU0sWEdynV1vM6Mhq6aFCZddq4VYJowPs+Wt47y1RjJ8GqOZOi7QgCpTbYANdT30w==
X-Received: by 2002:a17:903:40c8:b0:20c:62af:a0f0 with SMTP id d9443c01a7336-20e96ebc90emr70643225ad.7.1729633079139;
        Tue, 22 Oct 2024 14:37:59 -0700 (PDT)
Received: from [192.168.100.49] ([45.176.88.171])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7ef152d3sm46951595ad.117.2024.10.22.14.37.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2024 14:37:58 -0700 (PDT)
Message-ID: <79577df9-fe51-46e6-9b70-01ae03ef4dae@linaro.org>
Date: Tue, 22 Oct 2024 18:37:51 -0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/20] tests/tcg: enable basic testing for
 aarch64_be-linux-user
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
 <20241022105614.839199-14-alex.bennee@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20241022105614.839199-14-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 22/10/24 07:56, Alex Bennée wrote:
> We didn't notice breakage of aarch64_be because we don't have any TCG
> tests for it. However while the existing aarch64 compiler can target
> big-endian builds no one packages a BE libc. Instead we bang some
> rocks together to do the most basic of hello world with a nostdlib
> syscall test.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> 
> ---
> v2
>    - fix checkpatch complaints
> ---
>   configure                            |  5 ++++
>   tests/tcg/aarch64_be/hello.c         | 35 ++++++++++++++++++++++++++++
>   tests/tcg/Makefile.target            |  7 +++++-
>   tests/tcg/aarch64_be/Makefile.target | 17 ++++++++++++++
>   4 files changed, 63 insertions(+), 1 deletion(-)
>   create mode 100644 tests/tcg/aarch64_be/hello.c
>   create mode 100644 tests/tcg/aarch64_be/Makefile.target


> diff --git a/tests/tcg/Makefile.target b/tests/tcg/Makefile.target
> index 2da70b2fcf..9722145b97 100644
> --- a/tests/tcg/Makefile.target
> +++ b/tests/tcg/Makefile.target
> @@ -103,9 +103,14 @@ ifeq ($(filter %-softmmu, $(TARGET)),)
>   # then the target. If there are common tests shared between
>   # sub-targets (e.g. ARM & AArch64) then it is up to
>   # $(TARGET_NAME)/Makefile.target to include the common parent
> -# architecture in its VPATH.
> +# architecture in its VPATH. However some targets are so minimal we
> +# can't even build the multiarch tests.
> +ifneq ($(filter $(TARGET_NAME),aarch64_be),)
> +-include $(SRC_PATH)/tests/tcg/$(TARGET_NAME)/Makefile.target

ifeq and include once? Anyhow,

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

> +else
>   -include $(SRC_PATH)/tests/tcg/multiarch/Makefile.target
>   -include $(SRC_PATH)/tests/tcg/$(TARGET_NAME)/Makefile.target
> +endif


