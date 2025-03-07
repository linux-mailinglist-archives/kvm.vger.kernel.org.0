Return-Path: <kvm+bounces-40429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 44E53A5732A
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:57:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B96A51898C04
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:57:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AE92257452;
	Fri,  7 Mar 2025 20:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LaMJfSjs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75EC23E23D
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 20:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741381009; cv=none; b=G6caj4DVGxg3uM9QSxiAU0J/H+KPoykqJ4k8nwxFo2AKZepsxQu8PeDyZAsDDrxDRn/x6SEaiQf4IhOt+0dSJ5RPxhhJhsDC5aaYXKVkjdgu4Qgia/v5JES9ZMfeZ3AfGWA41N/e8pQ5WfvaPzjcIyIGxX6wqcGSFM0uhYzgBDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741381009; c=relaxed/simple;
	bh=AlVIEO/pMhDJI9iKhokLTkmiDYUSorVT3rQi/uCahJw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BK4wQjtqlR1GJPzvyQ1+EdngojX+x4xejJZLCD8mAeAYxaKhrU++xhTgOoGWgwnilcXJUXaTjqyljybjMjGtc0bFLdQlMZZNuKxx43Me8ABP7ep09I8ihOC3AvFXRj8CzocjmWac0MHSO5fLL2AP4DtuQNmcXofvXtbkfZhIEqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LaMJfSjs; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43bd45e4d91so14066555e9.1
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 12:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741381005; x=1741985805; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pYmb7QD/baHmzIh4UjdaMdQDVuT+bDgfSsNtQGMxdOQ=;
        b=LaMJfSjsnz8taCZgTE5cDeb/iGSn+wL3HYexF98Uq74mDPHwQ6/0pfExbbPBUMyeGQ
         AyxJP3RK+ZZkoya2uvR7S/kZ9Y9dyyqy62AKqiivKIhuj2qWt9OSQ2y13VZdfwvtu/p8
         4PZ5Ho3e16DROuFPAOuRrUqInnCuuHLX38sqnW8dYNQrmPmFE3HrtH3x8Rqp4/m3klok
         kbEa1ucSJc8NfaEHzHWSEkZ0/BYhGtZVIpBnofMgjnRLoc7zicNGs771ckA5YTpjHwwa
         r3PnLy7MkhDePcO0uClklNdbEtsJ1QBrFU47LVP7dSMAIVrQLRLmL4Q/6YicxFpWH8BA
         smSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741381005; x=1741985805;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pYmb7QD/baHmzIh4UjdaMdQDVuT+bDgfSsNtQGMxdOQ=;
        b=fyIfqdEhkHCs04mLvPKh7Gs3He4E6stK+bkqRzJB3t7YZZFTFzfrWBO+fO9sEtDecA
         0gREFn6LXgCuQdmxd5qVq69/SS1KRL1jryf5d3Cf+7TUmHFtSqePejkk6Im/QK+XBkV4
         ckvQeBbVZPHPJ/jTijmmXE/vJ96W8nL4QO0KlhAwRgy+WOZ5gyqojhVBH+mMfUHaFhee
         CLMyzRPpaqUHOWrgQX+MddKg036NJfzoc8V6xCUY/T8D9j3XhYFJj0W81mxMrYyioRz8
         DdNctlsAMDXi9DjDTw+/4PGARmQM6Y0dn1yYYYbOylQ6lcxB0b+K9NKF1M7mMVsp04Gw
         2Hfg==
X-Forwarded-Encrypted: i=1; AJvYcCU//pINRSOUY1vbsO08ZVjzKPG1wrBwZQKrDatQtVn3qy6CwhrqslYodoOGkONwu5InbCc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMLcWzOtvVEWicgZoKKBxTuCttTbVwDX3quIhqkoyGIiQH4BRB
	wwRLrJmCBDgvqxlflPEBHNOCqW65atX7y4hlrmrjqH8vVxp73ORrCk1ybid73lQ=
X-Gm-Gg: ASbGnctELnj6Qpc0h8/eJ4Q0AOiUStDJHW1qaPycPd37K4SpWIf1ehTzcbEfK4JMGcD
	rTP7Aknt4Vq40m8yZ1DOyKiG7S4MTnRyXJoM/RvczwaoJR1kb8Bf/eH8UkYZRfOFNJgQOpVEbgL
	RONCyXudna5/bFZaxDxu4Y1acJDqVlMGaDMIGc8HsHLnzcMxHhG413l1druhZooLKE3S/a+21Zz
	6xqWBJ53M7oc5A1hsrYkrzyOBYtNOUU5HUeTxXTQaHHjSfqc0ziFw0d9gdevCmWDAAfCVim8sx+
	3pUNScIwwzuR52KcLSu+ogbRVVZ1O0FG4tIIkXGs2q29SC5KbN0Z8/KqpW4PNx3GyZDBH6OBtss
	j5D6i3xTB7H6X
X-Google-Smtp-Source: AGHT+IFhARMjA9i8ahOKmVDivdHXzngn0JUxaGhcVWhPJIbs9KAbK3fApFsmdd+EPEtEgWHIvyEhPw==
X-Received: by 2002:a05:600c:a15:b0:43b:c824:97fa with SMTP id 5b1f17b1804b1-43ce4dd6711mr5969265e9.14.1741381004841;
        Fri, 07 Mar 2025 12:56:44 -0800 (PST)
Received: from [192.168.69.199] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c01de21sm6548214f8f.59.2025.03.07.12.56.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 12:56:43 -0800 (PST)
Message-ID: <0e40276f-c9e6-47e1-b70b-5a8b5f8fb30b@linaro.org>
Date: Fri, 7 Mar 2025 21:56:42 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/7] hw/hyperv/syndbg: common compilation unit
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: alex.bennee@linaro.org, kvm@vger.kernel.org,
 richard.henderson@linaro.org,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 Paolo Bonzini <pbonzini@redhat.com>, manos.pitsidianakis@linaro.org,
 Marcelo Tosatti <mtosatti@redhat.com>
References: <20250307193712.261415-1-pierrick.bouvier@linaro.org>
 <20250307193712.261415-6-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250307193712.261415-6-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/3/25 20:37, Pierrick Bouvier wrote:
> Replace TARGET_PAGE.* by runtime calls
> We assume that page size is 4KB only, to dimension buffer size for
> receiving message.
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   hw/hyperv/syndbg.c    | 10 +++++++---
>   hw/hyperv/meson.build |  2 +-
>   2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/hw/hyperv/syndbg.c b/hw/hyperv/syndbg.c
> index d3e39170772..0ec71d9bfb8 100644
> --- a/hw/hyperv/syndbg.c
> +++ b/hw/hyperv/syndbg.c
> @@ -14,7 +14,7 @@
>   #include "migration/vmstate.h"
>   #include "hw/qdev-properties.h"
>   #include "hw/loader.h"
> -#include "cpu.h"
> +#include "exec/target_page.h"
>   #include "hw/hyperv/hyperv.h"
>   #include "hw/hyperv/vmbus-bridge.h"
>   #include "hw/hyperv/hyperv-proto.h"
> @@ -183,12 +183,14 @@ static bool create_udp_pkt(HvSynDbg *syndbg, void *pkt, uint32_t pkt_len,
>       return true;
>   }
>   
> +#define MSG_BUFSZ 4096

(4 * KiB) is more readable, but, as a matter of style, I won't
object if you insist.

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


