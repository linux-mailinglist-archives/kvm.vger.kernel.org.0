Return-Path: <kvm+bounces-33762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E1E389F1562
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 20:01:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71425188E8C0
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 19:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5912118B47C;
	Fri, 13 Dec 2024 19:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aNBd8VZp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C671D13EFE3
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 19:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734116451; cv=none; b=G5ZVlYurF0yTx1Uqa7+zgzfx8pP7wrGBzvd/1MD3MTQcAnZvK69Se07Srl2sHBX595KD5u0lUYfRqWdUA5Mio6NISqaeEbCNIcCZHN0W6BaqIz3HBNCMKhj9fQtD4jwR6YVoQoNVycxZBNLIDP+O0OZ5xvvF1jtNjPbiTkYp1s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734116451; c=relaxed/simple;
	bh=0lujD/MUSwnvlBmGwslECvBzigIFk8P9A9OdGCCEGck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QYABozWFHFWBZBUKlAB1mwc/MfCktQhiF15eYCN2YD07M8whBdasqhrbnIAUpuPSNapQd27oEHfcUIYg48NKmUuMEYh7+cZ1DLG8ho7bbw5q1EriUxTo/WtqHTJCRpYyYzYfYLU6zsQs6dyzP46pCNGa173yu5YEyiGyKRPzxcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aNBd8VZp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734116448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Hysh4G6LZrqgtBW9bf9kFNZmoNJmDm01ucGkIcE/z0g=;
	b=aNBd8VZpGV93im/1VNy12IpXHExhZh8JuWG6vDuHQzb7mPjKkl11MzahWVrNeNN6DL8vrM
	gPohArE/z7hIa/zU1sFkWO/f095uoYJyx7cnxvHa6eBOjNG77ByF46YIke38nl4rBVvbV/
	Eni4TzSYzSg4ElyuODQSx/1HFd3CYsE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-a4CXeujcPxSsj107E_qu8A-1; Fri, 13 Dec 2024 14:00:47 -0500
X-MC-Unique: a4CXeujcPxSsj107E_qu8A-1
X-Mimecast-MFC-AGG-ID: a4CXeujcPxSsj107E_qu8A
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-385fdff9db5so367646f8f.0
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 11:00:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734116446; x=1734721246;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hysh4G6LZrqgtBW9bf9kFNZmoNJmDm01ucGkIcE/z0g=;
        b=QQsCzKv6gXIRNCcsDFGtqmSKMDHcOM6k0Ptg4rr0bSMV+R3ikyQNEiMBC8rzffumTv
         TldS7BCQc5MMHMWZdghMW4KX3nzfD4H2rbVT7xJPglTH8EBxWmybVkXTGDRus741ClJW
         YepG2lGY7Oicwh8LX8fcuaopSAjf+g0CiKWqwCZWoyxFT/qrOQiBFgl4sTlOjzzTGNGi
         +NK4SVoVgwSaJzMjfCLVGqtshQpjdjlQ+WdvZtKv8aO0327rU5O8qbPocH5B63h3aRv4
         VZcHXKP/Vbn92DaoeHyQY0NnNSXIlXNCdTFI2e/zqpsToZgWYXneYsu1OOXcOKnRFP+c
         2fmQ==
X-Forwarded-Encrypted: i=1; AJvYcCUr7akmkicr/QV+I/LGMaVAPzLjbclgAxc+8JIC2XVDYwVVuHp0n1HWehIlCTD0xh0tJP8=@vger.kernel.org
X-Gm-Message-State: AOJu0YytsPOZ95RDYicoYKb/R+JOTMUVaUSSodBqDkscDq/oeGwlHfsa
	Fv6XBopkmi8uogeJY9AHrFKGsr9rhheiwO5Psy8zCfb2uOoyvuqt+KEG7c+65WUKJCB7/U+Lx1H
	AiC86LkVxeeBgOd43p/lmbdTbfu3q8RTUoCiHYGwVHQLm5NbvbUrffqummQ==
X-Gm-Gg: ASbGncuB3ea5Gl0L1tG/PThKNiu9kB4mCR20DUfNYxoiL8WKo8EQUL+j5q/OXn8+ghH
	A6MZueyUYG5gHc059yXiSrgNpYB6JhbB1JepbB9YzZpJl8QWnVgB3QrHF2ekFr996MP0VCM7O/c
	/tM85vknGL5bvny7ABHNHTY59LUq7LordCZC3wLgavY5csMd1OmUb8KJcvv+OtsK35UE9u6lFYX
	Xv7YdexP4Cx1nuudNYH4zX4t4Xy6cSJfqnaq3SOnzaVcLjtxDpO01VbRQc=
X-Received: by 2002:a5d:6d0e:0:b0:386:1cd3:8a0e with SMTP id ffacd0b85a97d-3888e0c06demr3587774f8f.48.1734116446025;
        Fri, 13 Dec 2024 11:00:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHMH7LHX8WyO4OyUiDC3F6CeTLqdILBLsfBgGhgRF00YfuJYsdMc4uonnm76mxzCZ6tmKlPlw==
X-Received: by 2002:a5d:6d0e:0:b0:386:1cd3:8a0e with SMTP id ffacd0b85a97d-3888e0c06demr3587756f8f.48.1734116445672;
        Fri, 13 Dec 2024 11:00:45 -0800 (PST)
Received: from [192.168.10.3] ([151.81.118.45])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-388c801ace1sm286162f8f.60.2024.12.13.11.00.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2024 11:00:45 -0800 (PST)
Message-ID: <98b25b36-7a19-452a-87e6-a78ae238716f@redhat.com>
Date: Fri, 13 Dec 2024 20:00:44 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] KVM/riscv fixes for 6.13 take #1
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt
 <palmer@rivosinc.com>, Atish Patra <atishp@atishpatra.org>,
 Atish Patra <atishp@rivosinc.com>, Andrew Jones <ajones@ventanamicro.com>,
 KVM General <kvm@vger.kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)"
 <kvm-riscv@lists.infradead.org>,
 linux-riscv <linux-riscv@lists.infradead.org>
References: <CAAhSdy35NO2fUrgER57qgOHRSZYbGLvmKDPjdfpXOP04C1AhMg@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <CAAhSdy35NO2fUrgER57qgOHRSZYbGLvmKDPjdfpXOP04C1AhMg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 16:43, Anup Patel wrote:
> Hi Paolo,
> 
> We have just one fix related to the HVIEN CSR update
> for the 6.13 kernel.
> 
> Please pull.
> 
> Regards,
> Anup
> 
> The following changes since commit 40384c840ea1944d7c5a392e8975ed088ecf0b37:
> 
>    Linux 6.13-rc1 (2024-12-01 14:28:56 -0800)
> 
> are available in the Git repository at:
> 
>    https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.13-1
> 
> for you to fetch changes up to ea6398a5af81e3e7fb3da5d261694d479a321fd9:
> 
>    RISC-V: KVM: Fix csr_write -> csr_set for HVIEN PMU overflow bit
> (2024-12-06 18:42:38 +0530)

Pulled, thanks!

Paolo

> ----------------------------------------------------------------
> KVM/riscv fixes for 6.13, take #1
> 
> - Replace csr_write() with csr_set() for HVIEN PMU overflow bit
> 
> ----------------------------------------------------------------
> Michael Neuling (1):
>        RISC-V: KVM: Fix csr_write -> csr_set for HVIEN PMU overflow bit
> 
>   arch/riscv/kvm/aia.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 


