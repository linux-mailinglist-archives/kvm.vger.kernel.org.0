Return-Path: <kvm+bounces-41789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87CC5A6D669
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 09:41:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0AC43166A2E
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 08:41:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46BB325D544;
	Mon, 24 Mar 2025 08:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="bwXhBRvA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C11FC1D
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 08:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742805667; cv=none; b=bYabGfN7gWbdnXZDUGHa2wAbjkk2S23SikTRDUs/ZdveWJIi/pAQMiD755uaLBYacLeAeuC262qJcwGH7h7ZXEsmIFm/zHEKG4t7RNdeEYwpM6AmPU+5+pyL8E6JAQPsNmhy2Q92/SZxk5o3JtyhEXga7LsGdvCABu0IiqiDa0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742805667; c=relaxed/simple;
	bh=EQ9AC539GNhH9+gAeB++MkWZFfFNy+69yprAeYh9KIc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e5ikINh4CkgrlG9q0nieSyhQu9fsxRPxL02J4oiHBQvTvUalAQR07F6ujBU05hHh/oD5NpOuXg/DkbeYSiMvuiy7YuMkn3TjhzmXo1RpSzXt/FTiGx5kn1Hyg6JvEQDX4EgTU6SOkweFfl4UjweA2uDnw+fnwL85Y6c2RzfHyF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=bwXhBRvA; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3031354f134so3820891a91.3
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 01:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742805665; x=1743410465; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v3uw5Z9jtzCHbHI92vRIdMw4q+7D7K0HGUyXcM2dV4I=;
        b=bwXhBRvAoKa4MAAG4vnJUhGtJu1xELwfNspOFDUlfvx5arD2LoIuyDM9xVjqrn501v
         5ucnIRJagTy9JP4hFnFdAyUoc7WOXeHTYHc3Ghffoj7ukUqkyWY9RvBVsM1k3yL8W8f4
         5VHhFlg40Tv465RbSJoZ7unU0g/ixI69rr0ZKmsl0GLjf0MJnCikPfcj7kZBMQzxqs8I
         QJp7OFD6UKG+hMmajx/hNoHF7mN2ykV7Pry5lpd5mN00iio9P3k+vWF/Ve1FB3cEAjfx
         Rhdys8hcd0k0PhZYy53BsDBDnYBG7LdFNllpQZnh+3M/E5zr8ty5ws0SP7QQVQnP1cxq
         MTvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742805665; x=1743410465;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v3uw5Z9jtzCHbHI92vRIdMw4q+7D7K0HGUyXcM2dV4I=;
        b=VqFsjODYfBi4zo99pd5l8gi7yFsmKgUHQWzxkAada/qJzr7n/AmXoAM2iwtkfm7euX
         jApyJu5WO+aKtrwCFKJIinyjbCwECreKMvPYsncr5B7ii/yYeEROjUs7o5draT2uYDcW
         WNVjnv27+taERkJ6FvI9vfJ+H5hXRv0IGjWIn6ls8fYBFq2zHKiU0d1QPHJgShhrBiM7
         Fgp8k9RhEdjEvKruDXEI+CDMA/Y6ogMPCmj9NrWH1Z40rREbF2NyYTLSvbOybFaZZ2SW
         yVfjjl8ngx8gf5Xamci9Y32MxLf028nWQRQgGArO7EWH+QOx4TpEw5mfqMykoYj91clD
         0A+w==
X-Forwarded-Encrypted: i=1; AJvYcCUP4eHWcmnMduYTygwDunIbId6fhr4ToLX1TdBHTTGqs+cYfhKNPyiOJIJEbkWbuIWIA8E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyj5JEK7HLffG5M6Abs16z48W8fqrKTVSyn+xvJlvOMgnwyr5Jf
	Eb+TwCQI0nc7x3cFhSeg3G6rAGLGC+nQ70F09TeFD8S8KaP2umgcNzGsTwmmuLw=
X-Gm-Gg: ASbGncvxvJNmPXzYb72b/2dNFmwgOdCZ1uEIVvTrqo0vAyspx2T7FolaJboq+BTf1yk
	+mFIvPNfM7hVKFko/iNmoQJhJcTk3y2T+8rbgYfcqQZI17MoRnAOeP5ZFGOBBRikQ+A5tiTkUCI
	Hn/REpVxh/ho2nR/JA+nK3T5w7fK/UZrsYv360RDrXxD+auHx+zQlQEJi1yYQGKLxtDEaNztbic
	RdSLmKCE4SOQFb+lucUwdjBldsMeKRNjKFmsndXQFMbZ2sb9MFJ8lsAiGZjURYNJRXn+dKGohHa
	wpTvhqYQHrGobV5GEbhlFZi+e6EEjeX2LyP7RxwOfmGR3wRdIuJwwkltz/SuUf+PzGaRCseELRi
	rJIkHKzOvSCVJ/w==
X-Google-Smtp-Source: AGHT+IH+xgozTyBMkBlyP74TERrNWkyYdKcQs55orpOAP7tn2ARvtV/+JWl6ctnTGkBpb3mEArC3yQ==
X-Received: by 2002:a17:90b:4d:b0:2ee:db8a:2a01 with SMTP id 98e67ed59e1d1-3030ff00e7bmr17510813a91.30.1742805664916;
        Mon, 24 Mar 2025 01:41:04 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3030f7e9bbasm7435204a91.39.2025.03.24.01.40.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Mar 2025 01:41:04 -0700 (PDT)
Message-ID: <0597da6f-cc28-497f-a49e-3f1c99a4e6e1@rivosinc.com>
Date: Mon, 24 Mar 2025 09:40:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/18] riscv: sbi: add new SBI error mappings
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Samuel Holland <samuel.holland@sifive.com>
References: <20250317170625.1142870-1-cleger@rivosinc.com>
 <20250317170625.1142870-3-cleger@rivosinc.com>
 <20250322-cce038c88db88dd119a49846@orel>
 <779c137d-5030-4212-b957-3d2620448ea9@rivosinc.com>
 <20250324-5d1d09fc9e50d2276ba56b6f@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250324-5d1d09fc9e50d2276ba56b6f@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 24/03/2025 09:38, Andrew Jones wrote:
> On Mon, Mar 24, 2025 at 09:29:33AM +0100, Clément Léger wrote:
>>
>>
>> On 22/03/2025 13:06, Andrew Jones wrote:
>>> On Mon, Mar 17, 2025 at 06:06:08PM +0100, Clément Léger wrote:
>>>> A few new errors have been added with SBI V3.0, maps them as close as
>>>> possible to errno values.
>>>>
>>>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>>>> ---
>>>>  arch/riscv/include/asm/sbi.h | 9 +++++++++
>>>>  1 file changed, 9 insertions(+)
>>>>
>>>> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
>>>> index bb077d0c912f..d11d22717b49 100644
>>>> --- a/arch/riscv/include/asm/sbi.h
>>>> +++ b/arch/riscv/include/asm/sbi.h
>>>> @@ -536,11 +536,20 @@ static inline int sbi_err_map_linux_errno(int err)
>>>>  	case SBI_SUCCESS:
>>>>  		return 0;
>>>>  	case SBI_ERR_DENIED:
>>>> +	case SBI_ERR_DENIED_LOCKED:
>>>>  		return -EPERM;
>>>>  	case SBI_ERR_INVALID_PARAM:
>>>> +	case SBI_ERR_INVALID_STATE:
>>>> +	case SBI_ERR_BAD_RANGE:
>>>>  		return -EINVAL;
>>>>  	case SBI_ERR_INVALID_ADDRESS:
>>>>  		return -EFAULT;
>>>> +	case SBI_ERR_NO_SHMEM:
>>>> +		return -ENOMEM;
>>>> +	case SBI_ERR_TIMEOUT:
>>>> +		return -ETIME;
>>>> +	case SBI_ERR_IO:
>>>> +		return -EIO;
>>>>  	case SBI_ERR_NOT_SUPPORTED:
>>>>  	case SBI_ERR_FAILURE:
>>>>  	default:
>>>> -- 
>>>> 2.47.2
>>>>
>>>
>>> I'm not a huge fan sbi_err_map_linux_errno() since the mappings seem a bit
>>> arbitrary, but if we're going to do it, then these look pretty good to me.
>>> Only other thought I had was E2BIG for bad-range, but nah...
> 
> Actually, I just recalled that there is an ERANGE, which would probably be
> a better match for bad-range than EINVAL, but I'm not sure it matters much
> anyway since this function doesn't promise 1-to-1 mappings.

Yes, but ERANGE description is actually "results are too large", but at
least it's name is more descriptive. Let's go with it.

> 
> Thanks,
> drew
> 
>>
>> Yeah I also think some mappings are a bit odd even though I skimmed
>> through the whole errno list to find the best possible mappings. I'd be
>> happy to find something better though.
>>
>> Thanks,
>>
>> Clément
>>
>>>
>>> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
>>>
>>> Thanks,
>>> drew
>>


