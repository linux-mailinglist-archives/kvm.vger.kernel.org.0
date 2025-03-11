Return-Path: <kvm+bounces-40747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3550DA5B9C9
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 08:30:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C396116FDAC
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 07:29:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69C622222C9;
	Tue, 11 Mar 2025 07:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YohpLmJq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAA82206B1
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 07:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741678182; cv=none; b=eteEi6UUUjoTNEJJ0x6nvYOuQK2COonoBSnMdkIrohixxHCEEkOPTfeA+qS3RqG3hqjplVK1m8emPHJuKU/Pi0Ze+8OpG5JVqfmZny9f4Hfx61JMBhpIxPkFxWh+9k9V+0eFGaj7ZdTVu/6T7yi9oQyvXv8JaW/bPR5b3i8VIks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741678182; c=relaxed/simple;
	bh=djtabv/yEikm06t6xuiTJQLGcYqpMQk0WvQHmE5PWbw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jfIRm+kTG8YxxazFUZucIyamGMTbzxDDe3SoAXqY+ATcwknE9PQyp2iiausDXz6Y8HHRfiRyvZw4CigEMzJy7mZnZxwPaEiDVwg+MDRK5yD8Jk2/EwjffWEqjG3gt7Ts/Jtx6JcRCk24dImZlg5mY8YBtDu3MKewl2Acnjvc14k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YohpLmJq; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43cef0f03cfso14272545e9.3
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 00:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741678179; x=1742282979; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nhHodvfz83K8okGx6PVYNh8AahNsL56U7T1i1KJXP8w=;
        b=YohpLmJq3JVmdHvkfFqc5aMC47nGRDF5qWcsUgHs02mQ/S58il+vejbA5G3JJxtdDA
         +RLJ05ge13ykm4gOUiUAyXjfsh+X+6v64gsKwGCzYmtBmYF1SEPjpm8eJIz+My9Ump7W
         plpXkcPPMYpbDXoxFZzooowLoDGN/f9x79sgUiAi1iywZ/3UMdB2iAGRaHu/1Fh4YoPB
         GdO3qvosEarGj1ldv+PxChUvEO58lIQ7EGz2yPgqkfoJc39ujpEHWnD/hAMYy1ZH/Tlw
         ox668qhc3j/tQdMiyh0nahl9BHf68ry4aCS7iL8vpFO2bcCcfr5edeF5XPW+g8gI2OrE
         3f/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741678179; x=1742282979;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nhHodvfz83K8okGx6PVYNh8AahNsL56U7T1i1KJXP8w=;
        b=gX2sE/Ts1hzRRam/w7p3yKQOXNXydfPaZ/296lG1/kzKU4TtLH4LtgSzmrLf18uL4x
         B4Hcod6jFBziJJi8+UcNY5ytwcg8jDwhTCQn/mBGL2vNpu1gpcJtZhvu1yw27n6VyAfc
         NwxwsLm2EEi1yTBFRrTYsqQGiiKSnjGtyGhZIR00eQ9Vi/rlazuWDPsggIss8oa0oHbd
         0vSWbFYeDE46MwBqVBu/4axHGrkkyMrHyRlGflU1h87xU/bRPzoWwK94HbmD/g2glBBF
         pKZTYAE888rmyoKo7MzfrRk7tA3/am7rNihuhqr6QJLPZiTNNw7nPRaK5+jz2iciB8nl
         rhOg==
X-Forwarded-Encrypted: i=1; AJvYcCWmCOa0S+74rAhufaYN32mU7vjIMQm6DipKxtjWcwbekArTctDXTOespJHzE6taEwhiZVs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMUOfwi3jsUPHLyg8/ZaYOucFrYu/qkyej/6BSQYpfK4UJOFF6
	DRP8orDz+lwtFDMvHmRLv7urQp/ix3T3SZDsah1sXglUHhff/k39EO+enw3OZfE=
X-Gm-Gg: ASbGncvzU+0VJez25KnlTcnrpQsqlpn6d+nebciKzaqDPRW6YVp3HrWCGOZQ7eJkan5
	nUaQZqIN4Dupbbo3qlXHkgfOGVsWu1p5x3J78Z0msifTOPBp8kD2wcFQMc6dICQRHSM6MQ937pE
	cVtt18bdfGtau9S8vYmfLqrsQAr5fwDdD+Tv73pusp1PFwRlNrNHHcbLNaDhY7DFs2otgZ+iDzj
	8HyemaXRP7UmN3T/ZAPFFqKMxkEqUFeFN2lAcPk7uCQNzvY34m0mzyHUOY3PQNQu4KKhI3/xv41
	tPUud/YZIySPmGvqmueAr9GGah1SM9ibwY1UuHaHRbAwwwVkZkZz4hY2MYzJEjjatg2C0tjHQxI
	1lQR1VUqAwZAi
X-Google-Smtp-Source: AGHT+IGCQ0WPIofxeMF6qiP5Neb98oKIcffSaO1IosDf7UGuxLQbtl0ssdei0czfpoqguWEGtKCbYA==
X-Received: by 2002:a05:600c:3545:b0:434:fa55:eb56 with SMTP id 5b1f17b1804b1-43c5a600909mr128191755e9.7.1741678179189;
        Tue, 11 Mar 2025 00:29:39 -0700 (PDT)
Received: from [192.168.69.199] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ceed32e64sm89167575e9.5.2025.03.11.00.29.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 00:29:38 -0700 (PDT)
Message-ID: <2aa408e2-a412-4eb6-b589-1bc2f5ac145a@linaro.org>
Date: Tue, 11 Mar 2025 08:29:37 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/16] exec/ram_addr: call xen_hvm_modified_memory only
 if xen is enabled
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 David Hildenbrand <david@redhat.com>, Weiwei Li <liwei1518@gmail.com>,
 xen-devel@lists.xenproject.org, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
 kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 Alistair Francis <alistair.francis@wdc.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, alex.bennee@linaro.org,
 qemu-riscv@nongnu.org, manos.pitsidianakis@linaro.org,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Anthony PERARD <anthony@xenproject.org>
References: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
 <20250311040838.3937136-12-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250311040838.3937136-12-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/3/25 05:08, Pierrick Bouvier wrote:
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>

I didn't follow this direction because Richard had a preference
on removing unnecessary inlined functions:
https://lore.kernel.org/qemu-devel/9151205a-13d3-401e-b403-f9195cdb1a45@linaro.org/

> ---
>   include/exec/ram_addr.h | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
> index 7c011fadd11..098fccb5835 100644
> --- a/include/exec/ram_addr.h
> +++ b/include/exec/ram_addr.h
> @@ -342,7 +342,9 @@ static inline void cpu_physical_memory_set_dirty_range(ram_addr_t start,
>           }
>       }
>   
> -    xen_hvm_modified_memory(start, length);
> +    if (xen_enabled()) {
> +        xen_hvm_modified_memory(start, length);
> +    }
>   }


