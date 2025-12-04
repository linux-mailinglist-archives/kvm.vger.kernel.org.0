Return-Path: <kvm+bounces-65299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FFC2CA4B8A
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 18:16:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2B648305BC7E
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 17:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E5442F5308;
	Thu,  4 Dec 2025 17:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IBNYVque"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CEB2EC579
	for <kvm@vger.kernel.org>; Thu,  4 Dec 2025 17:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764868227; cv=none; b=ibGlvpby4zOMU+ssuk1fRoc3eC+3ePtuiGRu3e6vWVrdRbBE6Wan9lqY0996vh4vGNvQTsB/AT5LG1tY3RV+IodBNlUeRH7Ah+BmW2salyykTfmwg1h1B8z00qjGOLl4Ee9D+yOnBMUjB8EFd+pPo4YAnITuEF7N4Ug6zASKgCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764868227; c=relaxed/simple;
	bh=fg+g6GFNORH7zMvHPOKkpLR846cTm7vqA+27Ou1RBgg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oUKxUblpSsPXNy7Nk45QPLro/W9Y6Oj8+gg/np0vW9TFzUJ0iwciWtfd3jq5CB8LNEFoITpxxpZ2W2ap1V4sqdITeg2zpNQ7blSgGeVczsRIEVoMtV8gHBFwQNcqDuXfcka0F1egQYMzb5CSp30m0GkicoqFYHhG1XK7Ouz6XXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IBNYVque; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4775ae5684fso6495295e9.1
        for <kvm@vger.kernel.org>; Thu, 04 Dec 2025 09:10:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764868222; x=1765473022; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lrqJ+EIWHNmzugBhniJ6bKF8SnPZuGUPv5c4ZJP5nKk=;
        b=IBNYVqueHb9vV7prjfYm27YLI5zcpeWIlxTxNCCt7EBehRB3oNCrInreYsRljLr5NV
         EdREt81YEWD559ce6dltr1NsbzgCpFYB5TgkUZaP0BayzBKlpGrisnLLjHBrT3i7Iqle
         S7mReWn37l7fSJMNQ1y9tqza/BZuwS+HiPLUa9CapOopYMbhMUJawJ8dZ5M/LoeoONlw
         H1PLOlofpidZrfa3fVGzSMNg+MYLAxuSZGd1w7y+Z5qIUX0P7qy7HDCk/76FV8aMqsxE
         yX/gEm+SxF+UKIZjd5Ut8ZfOW/igHrSzJ3XPzsACUylHBgJhi17l35X6HG//GoHGYPDu
         34MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764868222; x=1765473022;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lrqJ+EIWHNmzugBhniJ6bKF8SnPZuGUPv5c4ZJP5nKk=;
        b=JbdrlBSf+AWIDc5jcxuvHG/+auPtzsTnHzV7z82gHSuTVaV3ujw7M7p0/0yEjBWnxp
         n9vsU/2TSkEJ4CRv00Sy+ZHUNz5XcaodtaSKpH5fA87MvUkrfExIeyCK8Yv+IYgMugQQ
         WvWEsXzLSNit9Xsp4NUfO1KPd2GweggITrktKApQrHziqn3oRev5W4Z43mSfUrYjWwd6
         3mJxn57Cl/aXG5xFWLqDrZv1yVw7EQJXmKhLALI+z8xSByEVAiINdd5rr5wiSWKNSQCS
         AJ1FyWeOdHcN6OJq4SubdcOf8o3V5l+bqhDtMAucQDtb9zBwykpE7ekKE4Z8Ofvpt0dD
         GCQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWiRN0WDbPSiyeYa+mMN+EG5jlYqG+vT+ONMBDdHj6Gq8RDaNPkxaEVNJ0hoRrPKigUtjM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyS1nnuEiW9SYc43sRp2qWMGYrBmFF4QWBmqMAMfD96ROP+XpUO
	cbUKwuy30x2IileidVTT5Y9aQM1QtcG/eYWGE0ekE37f/JgAugWBr1UvfwUTQnCwVx0=
X-Gm-Gg: ASbGncsgg9bGzIJ1BoxmihC5wZsfwbFtWNslA4zV7i8EpT8cjTxqZiWaqz4VlCC9sVQ
	xSfwBkWd0ekxOR+noc/ZGB4jHqvpYiAhWymF9Bwpl5ijvux2hM/gFF7dgnFK65tGXliL1IjTEFo
	1gp0/O/ytysu+1ZuLY2+CNkl2Sasvx7HseLx6HHFORMdfVy8eKr1xSeBdcn87ANs7i/M7XHkY7m
	ef6dWT0AsOCgvuIRcQ5NqGHjfC2+r+i6KrU9m4HFaNigtRkfRkCsxhm7V4P8PMvrna34gpW/aZI
	9fyZMpD2RW/yIM4PiYU/6/eaO4lvOBrYQdNCKR3pnJCiMqg5iF4UEFSbqQRNCLYmnO8nHhZSeKD
	cG2BAramAvUieMnnY4bc8/nkcm2lq8wlojXyFWObbFbpt71EVm2aneQgzRrEU9sV42Wnk2s8Bs0
	CWcGpBR6oj+H+XPWq0ZAas1hg2IUqcLXku2kPJ5Drn4hBYn0dgc7fIiQ==
X-Google-Smtp-Source: AGHT+IHc4OsHmI+o7Tz3HaO6+iyC0gT1XhBcDYrEz9OCS56uEsWE/T/ZuM/2+s362E51rlzaEpoUmw==
X-Received: by 2002:a05:600c:1d23:b0:46e:4586:57e4 with SMTP id 5b1f17b1804b1-4792af34a51mr86690425e9.24.1764868222083;
        Thu, 04 Dec 2025 09:10:22 -0800 (PST)
Received: from [192.168.69.213] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d331092sm4213202f8f.30.2025.12.04.09.10.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Dec 2025 09:10:21 -0800 (PST)
Message-ID: <79d812c8-0e09-451b-84ed-376249a7eff7@linaro.org>
Date: Thu, 4 Dec 2025 18:10:20 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] target/ppc/kvm : Use macro names instead of hardcoded
 constants as return values
Content-Language: en-US
To: Gautam Menghani <gautam@linux.ibm.com>, npiggin@gmail.com,
 harshpb@linux.ibm.com, rathc@linux.ibm.com, pbonzini@redhat.com,
 sjitindarsingh@gmail.com
Cc: qemu-ppc@nongnu.org, kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20251202124654.11481-1-gautam@linux.ibm.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251202124654.11481-1-gautam@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/12/25 13:46, Gautam Menghani wrote:
> In the parse_* functions used to parse the return values of
> KVM_PPC_GET_CPU_CHAR ioctl, the return values are hardcoded as numbers.
> Use the macro names for better readability. No functional change
> intended.
> 
> Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
> ---
>   target/ppc/kvm.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)

Nice cleanup, thanks!

