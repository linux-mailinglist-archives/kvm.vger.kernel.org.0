Return-Path: <kvm+bounces-71847-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SH3MMcsln2mPZAQAu9opvQ
	(envelope-from <kvm+bounces-71847-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 17:39:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6396B19ACB0
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 17:39:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B2F9131AA446
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 16:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCEE93D7D9A;
	Wed, 25 Feb 2026 16:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EANYxbX/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9A638F959
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 16:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772037256; cv=none; b=VmaeEeCWCxmeeMXAlZndEa3RPBDFpFB4Ah/kJ8vcKSqcyzOGdv8Y85TZ7a+53c97cFoXvUeOf9ZFJc3bxDal4Bwkf0s6Z1o99/jbNBA+f5s7HYqkJYA/OGmlLaJghOHH5JGPWXhMGhRRIxC2jNY7gPvmW2HIIuRNAZLETYcKQzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772037256; c=relaxed/simple;
	bh=k8xUH6KnzUO8LukhVtZK3pIrtW0DcE2p1znkvkDtwW8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hbkc3jFiYTj1CMKXUgxLreYBFre4KdgHFamzRzzR1SqTpFUkRstEOwNXLGU8Gub0K3Kb4jAeN/G7YVKWk5sDjLSYgQAyKcdRbgQrb4Rekw8UiYsA3AkORALVmd8yOUsAjk9FoHeRz50i083hRjH6f5F07jTQ6Ikgl/5uEDbPjec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EANYxbX/; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-436356740e6so7182533f8f.2
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 08:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1772037254; x=1772642054; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ErNFB4fWo3erpLz6CQwnamsPRtYALrLm1VQrrV4Tt64=;
        b=EANYxbX/Yk01YtBSMbSya7HSlRrCCGanu4mRmmoZa0tGqDK35XYAMVkSk4vAv037Ov
         aol9OMryAHsNZMJxvzMQNIOXVqpzVFtvVCJ9xrwB7vJlzlf+e0ivsQfZW+063wZXfQy7
         lRMX4ODRoOZVUBq4gLs/lSkHMOqn/SJpEGruCdKM0Vn8SauihrEpDfy+dEbimdORfa95
         ZQknmGiPRNVf6ELRROFZQp+ckXj7VU20ga4XAhfNUEixPykMp8j9dnm6EYkshDkbwXxO
         gsWxbczjvF5Xotv+VC0e5mdV0Yf8YQalJU2rMjv/BQtyoOL5diCi9UW9MDmFyRw5UBHm
         Tw8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772037254; x=1772642054;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ErNFB4fWo3erpLz6CQwnamsPRtYALrLm1VQrrV4Tt64=;
        b=UlGMZwhRUVY2wPberFrPM7f4EcVdAbw/GJxbrvwI23flUMpuVtX2g4OFCE6uC2ajJh
         84QV8SQzwlE8aK3tLJB+rwmYoRJ8zJYCmuNOaa9gkmNvdggFLAiwkGQPbcSBuc/cKDTB
         TurO8yVBrqSCDgj4Q1GqsIhh1nkk4kCWD7W9dhDhZEveZy5S9vCUJxZxGOf63s0B2w4M
         Anp9WdqDc2L+0ZYKkQuWvdKDB13K/zfhGN3zZya6m2D1sBnleY0+QONLwNVvXzxs/XdA
         mZ5oUWknbvKXwSByU+9UCJpAGIKaijC6iZqJdKlqLK9D3fwjS/uYUbIwkvvvHlYmRmnL
         oByg==
X-Gm-Message-State: AOJu0YwSiAhHjKCD6CBFwCgvFAzFDJFy6stUaIhf9ag5Wye+F/FqfkjM
	nNkXJObGe4ruEuaHcS7sBufh2/2tUqu8nzc5Acovj5V5KstsNsR4TCaKhGjzPHXtNnI=
X-Gm-Gg: ATEYQzwLuD7Kis+Cy6rThcIWfdP2Hf0UbE+ZXSVc0KVYf+w4zlrqG9fKe+Z/aM1sVYa
	VGm4A0n3jS/EXdq81x5BxlArpbKa0S4pfDoTOZRCaHr9DlpXdQZx/EF7N/XBDbWpxd4zYAMlIKM
	Yv9vLZSIAYwb7cGUdnqiLjsTqLLWPdGc/tV62GovVd39qaFVV29PMhVMICxcbrTkDedWOUcfo1C
	HmEncrb15SsB+QbHyXDfGPl2Qj8T1libU6OBSJgsS6AIInf7b3+mI9ItwQPu99T4EgXge40Fv9+
	b63SRTZO2wtdtMEq425fcPDNVUSMPsX4m8ubbZzGcOquSKRvlQfb3/RVxyIMo9KvYPicFJUMtox
	R7GHkCCIK4zpPrHy3LclEtnkCeTir8FDmfrR97OT7V09n3w5GmEYPpLNFV6B47/05cTEvfU553y
	vWA8q7TOX3gbMlSDnk3P5S9ryTniRuM/cTHgd0wLX7sBlQIP5p/Kw0kRgOkPhiuNDbyQ==
X-Received: by 2002:a05:6000:2511:b0:435:e440:f518 with SMTP id ffacd0b85a97d-439942fddd2mr2165857f8f.54.1772037253543;
        Wed, 25 Feb 2026 08:34:13 -0800 (PST)
Received: from [192.168.69.201] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4398bb96b90sm10671635f8f.9.2026.02.25.08.34.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 08:34:12 -0800 (PST)
Message-ID: <0cf4a5e6-0e29-48e9-8e99-e86b4de42996@linaro.org>
Date: Wed, 25 Feb 2026 17:34:12 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] accel/hvf: Build without target-specific knowledge
Content-Language: en-US
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, xen-devel@lists.xenproject.org,
 Cameron Esfahani <dirty@apple.com>, Roman Bolshakov <rbolshakov@ddn.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>
References: <20260225051303.91614-1-philmd@linaro.org>
 <20260225051303.91614-5-philmd@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20260225051303.91614-5-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71847-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[philmd@linaro.org,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linaro.org:mid,linaro.org:dkim,linaro.org:email]
X-Rspamd-Queue-Id: 6396B19ACB0
X-Rspamd-Action: no action

On 25/2/26 06:13, Philippe Mathieu-Daudé wrote:
> Code in accel/ aims to be target-agnostic. Enforce that
> by moving the MSHV file units to system_ss[], which is

s/MSHV/HVF/

> target-agnostic.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   accel/hvf/meson.build | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/accel/hvf/meson.build b/accel/hvf/meson.build
> index fc52cb78433..6e2dcc4a5f0 100644
> --- a/accel/hvf/meson.build
> +++ b/accel/hvf/meson.build
> @@ -1,7 +1,4 @@
> -hvf_ss = ss.source_set()
> -hvf_ss.add(files(
> +system_ss.add(when: 'CONFIG_HVF', if_true: files(
>     'hvf-all.c',
>     'hvf-accel-ops.c',
>   ))
> -
> -specific_ss.add_all(when: 'CONFIG_HVF', if_true: hvf_ss)


