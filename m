Return-Path: <kvm+bounces-32927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B2949E1FED
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 15:48:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 58F32B64408
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 14:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF7611F666B;
	Tue,  3 Dec 2024 14:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="N6WUcbOn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A691E4A9
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 14:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236216; cv=none; b=cmn0q+6997FTa9Slvnq9EIzr2DZTZ4QYNEL9oO0kWBJldlfipdyyW49/Allt1U3xWA36yDXqrKMR3BwyrxL7/Iz+zFVSWinEvECyDRtF8liO2MUxNAWq2lRhVK2cGWaDzrIwZLTqG0WDgskbO12xGbWTqDeBWhB6FAd1xCZWEdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236216; c=relaxed/simple;
	bh=rGhFjgaT9iY5cA8iRW+qva8sE0JbDy3heY2HVbFcvFU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TCh567h6vcFm5mkwAaevfvrXfa5jhEQwYe8X/pWgy4CLRxm9Qttp381kWZHEgt8BALEXe2NK41gJ7o5JKGFLWtZNXwBIKoylysrZVUSSwrKpHg6quTTZeEAj4oL3NGKYsu7Fj1Lx8fOFRSVm7dj/a7XsxYmencpuc3WJLD4iQLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=N6WUcbOn; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-385df53e559so3160791f8f.3
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2024 06:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733236211; x=1733841011; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jH1wDfSwrqnpiRpVRmWuhaDo0LUKD1u9ndEwybYSX/8=;
        b=N6WUcbOn5zHRa6tsa76uEdDK/KdbyBVnOWS4UeHyn6ibnL4kUpA0OpIKwJrQeufJIc
         XWmcl+P+rlfDeW0ZMOkCrqDARKQdn6jiVLDF8g4H3TItl4KInusqs3NsoeaGfXGFkeG/
         XLVa+B7WYDeKxyHHWFlshxTXM602kn5//mePnbzeq3QuqcNc39wuGtZw90+OQY6QFin1
         B+ttXNy8cnA5T7+Gf1VkYnTG3QOqnzQjA0l31evU/0cP1OSm5krI3H6m1bUzlIqmTUj2
         Da/i7fk2b864wVQbSnq4y06yUzboGG5+dTL9SDy5XGK/Fv9/+CFubOFBX1+rAHs3+rKN
         EUuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733236211; x=1733841011;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jH1wDfSwrqnpiRpVRmWuhaDo0LUKD1u9ndEwybYSX/8=;
        b=vPjStKjDBnyUZ0o2976PAeIqGYvXmLcu9G+EoaThRVPbmy7KTWZeo6WWeznjXVxcVg
         eTdpgisn89t1kOD22Tzxeuoj7WZBuv6O/8zQRa7GIhyoeHnacpziPWBA7tCdL78IrIeo
         r1dQUXrLazWGWC6RgJUCVNy2pzz7o89PFNNt6hGSfttD47WzOrkgPy/DaYEOZXMUuWrA
         wBAFxnENT8BcVNu7m5iZCdB+8SPJ3CPvsx/Egt7fsHN4xysbghEj+C73KWUcynyQckmV
         K+1h7dUDhQQvf6PuFFoGybjLpJF5pam330m/Spf6eq0Q0yEZIfGOzkRflVTUHUW4anmI
         n+EQ==
X-Forwarded-Encrypted: i=1; AJvYcCWiFJA3X3ouBGl4hUJMDNd1pTrJ1QdUdGPc3HfWTBI+JAyFwu1aWZtvz1hBeyzoo7KlNYI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzwGX24Rgsns4+vK6I+0B3Y3qMxHRABNkvBQwPpZktxxkuYE00
	mHKuitGNGb0Xjhml0GQf4v66EE1AQtOgCBUPjyskCe2QuQd0KuwWl4PLq6XTQTE=
X-Gm-Gg: ASbGncsHmMfRAQShCioZw8TihUJk2BtjYyODKhGiCGHwvmqagSL3fOiStAlx0vKaonP
	1s10TdDzaIoY53owi7l+7iG93TD7E4eG8/D63nd0i1UXJs7s7XVEX4jKDa2gRB3BBSR9bNfO3Rj
	m5kf3Zs88Vv2lQSAhsOUOGKGT6/duT2awU2JnNkfTjnSBS43BF1ZXzfNf/Qr7/vVAulT/+bZu/V
	BYKnBqGb63X/I2/oxfOsnwYuFreE8qVg9v5mxIcJyhAt/y2bIxU/F7pI06twJ30KhR8v9VQ1w0=
X-Google-Smtp-Source: AGHT+IENAyfwuNFf6REPxs6hH3ur11j36rdkKcaMOs2F9u8bNyL6Z8dBI2oVPX4waJYwrvr2phFspQ==
X-Received: by 2002:a5d:6485:0:b0:382:d7a:315b with SMTP id ffacd0b85a97d-385fd3c699amr2274561f8f.11.1733236211089;
        Tue, 03 Dec 2024 06:30:11 -0800 (PST)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [85.187.217.62])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-385e940fef3sm9325106f8f.42.2024.12.03.06.30.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 06:30:10 -0800 (PST)
Message-ID: <be306052-4f7b-4964-9169-8faa5ee7bb55@suse.com>
Date: Tue, 3 Dec 2024 16:30:09 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] x86/bugs: Adjust SRSO mitigation to new features
To: Borislav Petkov <bp@kernel.org>, Sean Christopherson <seanjc@google.com>,
 X86 ML <x86@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Josh Poimboeuf
 <jpoimboe@redhat.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
 KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 "Borislav Petkov (AMD)" <bp@alien8.de>
References: <20241202120416.6054-1-bp@kernel.org>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <20241202120416.6054-1-bp@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2.12.24 г. 14:04 ч., Borislav Petkov wrote:
> From: "Borislav Petkov (AMD)" <bp@alien8.de>
> 
> Hi,
> 
> here's the next revision, with hopefully all review feedback addressed.
> 
> Changelog:
> v1:
> 
> https://lore.kernel.org/r/20241104101543.31885-1-bp@kernel.org

The series is pretty self-explanatory. So:

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

> 
> Thx.
> 
> Borislav Petkov (AMD) (4):
>    x86/bugs: Add SRSO_USER_KERNEL_NO support
>    KVM: x86: Advertise SRSO_USER_KERNEL_NO to userspace
>    x86/bugs: KVM: Add support for SRSO_MSR_FIX
>    Documentation/kernel-parameters: Fix a typo in kvm.enable_virt_at_load
>      text
> 
>   Documentation/admin-guide/hw-vuln/srso.rst      | 10 ++++++++++
>   Documentation/admin-guide/kernel-parameters.txt |  2 +-
>   arch/x86/include/asm/cpufeatures.h              |  2 ++
>   arch/x86/include/asm/msr-index.h                |  1 +
>   arch/x86/kernel/cpu/bugs.c                      | 16 +++++++++++++++-
>   arch/x86/kernel/cpu/common.c                    |  1 +
>   arch/x86/kvm/cpuid.c                            |  2 +-
>   arch/x86/kvm/svm/svm.c                          |  6 ++++++
>   arch/x86/lib/msr.c                              |  2 ++
>   9 files changed, 39 insertions(+), 3 deletions(-)
> 
> 
> base-commit: 40384c840ea1944d7c5a392e8975ed088ecf0b37


