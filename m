Return-Path: <kvm+bounces-41086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87479A61765
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 18:21:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27A1A880C9C
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 17:20:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9C632045B5;
	Fri, 14 Mar 2025 17:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eBPAKLfh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A03202F8B
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 17:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741972834; cv=none; b=PxnawNnRogk2aBeBoI7LQeROAQZvcga2k4Q+1ysZlPlzhx8SXmT8JWPz1FtUp1MiyGSeJ5xnLYSiaMTD5c2yEK20DivT4l42VXcbCn+wEjNso0+eqvXiKkwEMZuc/lqwcws+Qa+9XYo1qUFz0V1FfGTv1b9pvRfB5Kj3HrleBN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741972834; c=relaxed/simple;
	bh=a5uI9l6UCKskW9i73TdQVph6R+fkIHS1QDQcdT6ZCI4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ukRR14o2DYLJjveu31o7vrek88aNy7foZMDbmN6CGPfXrLDVawVizwi+Wy8zJWsXluYqC2smfg3nAgHxxBF4jRam0l5cds4U+QHjeSHwJXunPAomuGOJhghjR5Ey931wn6ou91jnTtrCUQHQPm6chr8oGzNOAo8KsvDJbHQFHaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eBPAKLfh; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-300fefb8e06so4169003a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 10:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741972832; x=1742577632; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3Z8Ejyf5gVIQB49egYugEEvIlbhLo/s2/9aU/7U8kVY=;
        b=eBPAKLfhDY4QC3gOyBTPnTnoNfVAszg+FOGFcbT47xbDYPG1ID9A/ZepsmnzkLwx65
         eCkeZkfn3FnyhnB1A0kGPwSImRfBUjD/XAM5GuGAvia/JurX2SxVQO6GpO57we/dyYJB
         QU0sdtQePOdS9+ANNMyAqMTCpTQN+vSE43mikNg0OwRb3tqOzQnJc6o+sea5IEpkfws+
         WIlFOepEys+rM2XnPIyysbRuS52IrOwBl+RVGW5aYXzxAJT1nqfKkiYZThAUkkmfzYda
         da1VPMAeUzTD4uIpULmzda7/Fzhd7mFuMJS2Swp+6ofXekKb9cUbhezUAMIiMWWwZJgy
         NHCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741972832; x=1742577632;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3Z8Ejyf5gVIQB49egYugEEvIlbhLo/s2/9aU/7U8kVY=;
        b=P4G4xBwsdm2v0Bu/h428b2aZlHBnDKNobruFf3l2jyj9dBfmYwpmqbOc3uZnt1i1xL
         PPVQaM8xktfT0eq4wSQ3hho7ZBqEccvnNIN3ostmG7Wq4Ypcqk72TsuoBfY98Tnz1pAE
         hDqxVfJqJDlzexbJBtwihZ8FoLEJRDFAY0tJuYZ1Fzq+/mywpo+X77U9A44fdd1z76aN
         Z/g0r9EXy9ed2T6Piv61x26XPdcxNmHwojzHOhRA2f71MhJ9JvAcmMLPVQ4dec11/xk8
         XVJGWe+7wJJzf86E+2wnw6wt6WkzkJsPzWcgJ4fRuRm1fN9BE5Xa27fA/qSe4qoLKSuv
         8P5A==
X-Forwarded-Encrypted: i=1; AJvYcCXzNzCdIOuxxZxyZt147ZGWz6DUncvoeKQnQr2fub3QR1c8OWAXYaWqQ306qeCiEohifdo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3UG9jCaDjh4uHuvC/1EowcpzGyjnp49KXJ3yGbVUbkFR8dKhL
	zNtFbT80DUmi1hN5tSUVEbUWdZ20EN1nOTrzoYKJWZcZfNOJBvTo7Ap19eQZZGM=
X-Gm-Gg: ASbGncuAICK0UWTjml8+NU5/aLVkCO0Pe+tJOtQ/IlfTiyVtmhVruV+Pm2lparDw0e7
	rFS1qSXF51UFDY7UA63Tk3wRDCpAhZ1WujL9Xup2CXJehze91mV5FgLGZXtxoTc32Qx8Eh96PAj
	nMOgAk5ad2j6kY4MuPOjv0sSg9kKaqHzXktow4hf8xm8I6xu175zw9KhhouxToP8wJrByr4Bssm
	zsosRcN645uUbHywmuZBOzK2FUovA46oy7mqIVd9unStQQdudswVIbk6zU0bAgR8wLUjC/Qd35W
	6BeQs+sh9iksab6yCg0Jmm2olxS7JLPoK3THIose1qAndhEJ/umOYgyVB6Almd7jKM8J
X-Google-Smtp-Source: AGHT+IH14/vkNdOBVlHqTbsYx0wGv8KV3ghiAEvAGkec1UsA+oGhZP9+b0le8JVQuRL27/WBey/Lyg==
X-Received: by 2002:a17:90a:da87:b0:2ff:5e4e:861 with SMTP id 98e67ed59e1d1-30151d9d4d8mr119507a91.24.1741972831743;
        Fri, 14 Mar 2025 10:20:31 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301539d40a1sm1393009a91.1.2025.03.14.10.20.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Mar 2025 10:20:31 -0700 (PDT)
Message-ID: <a04d4b3e-c2d6-4193-a95b-b8f61645dc27@linaro.org>
Date: Fri, 14 Mar 2025 10:20:30 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 12/17] hw/xen: add stubs for various functions
Content-Language: en-US
To: Anthony PERARD <anthony.perard@vates.tech>
Cc: qemu-devel@nongnu.org, Paul Durrant <paul@xen.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 xen-devel@lists.xenproject.org, Peter Xu <peterx@redhat.com>,
 alex.bennee@linaro.org, manos.pitsidianakis@linaro.org,
 Stefano Stabellini <sstabellini@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-ppc@nongnu.org,
 Richard Henderson <richard.henderson@linaro.org>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Weiwei Li <liwei1518@gmail.com>, qemu-riscv@nongnu.org,
 Alistair Francis <alistair.francis@wdc.com>,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Nicholas Piggin <npiggin@gmail.com>
References: <20250313163903.1738581-1-pierrick.bouvier@linaro.org>
 <20250313163903.1738581-13-pierrick.bouvier@linaro.org>
 <Z9Qwg4PC_1bEaOLK@l14>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <Z9Qwg4PC_1bEaOLK@l14>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/25 06:35, Anthony PERARD wrote:
> On Thu, Mar 13, 2025 at 09:38:58AM -0700, Pierrick Bouvier wrote:
>> Those functions are used by system/physmem.c, and are called only if
>> xen is enabled (which happens only if CONFIG_XEN is not set).
> 
> You mean, 's/is not set/is set/'?

Right, I'll update the comment.

>>
>> So we can crash in case those are called.
>>
>> Acked-by: Richard Henderson <richard.henderson@linaro.org>
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>> diff --git a/hw/xen/xen_stubs.c b/hw/xen/xen_stubs.c
>> new file mode 100644
>> index 00000000000..19cee84bbb4
>> --- /dev/null
>> +++ b/hw/xen/xen_stubs.c
>> +
>> +void xen_invalidate_map_cache(void)
>> +{
> 
> Is this stub actually necessary? xen_invalidate_map_cache() doesn't
> seems to be used outside of xen's code.
>

You're right again, I added it by mistake.

> In anycase:
> Acked-by: Anthony PERARD <anthony.perard@vates.tech>
> 
> Thanks,
> 


