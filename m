Return-Path: <kvm+bounces-35388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADBA7A108B8
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 15:11:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26CED16ACE2
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 14:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB9BB146A79;
	Tue, 14 Jan 2025 14:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tp9gPtHS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A67B1369AE
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 14:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736863789; cv=none; b=YE8dca6ehZbpsH8MDiA8XYCLwg42oV0rnhXPd/Y5zILR6RxKPzJcbIOtoekHiTEd32F3WyBB4UHyOtBLzkb6NpbsLYNvk4LGwx6/h5pRbUiwOcxi/8CqSHLINsdUUPimlmHeKDkNwsibe8+lOBwiBDG0fCK++5Frko8AKfCQcV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736863789; c=relaxed/simple;
	bh=jN6hTm5L1X77lWhDNTJGjQfwNAStLyPRmW1i3PsxkDQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tLItnoYuTH82g3/u0yV2tRATPaFi61T1tPoehfOxgU+V/yYjWdNRl6mTd+XY8TlTQQMdP4R++JC6LFASV6+esX03pQX+yrD8xLYiCpjEv6JbM3SV2Wonh/AJuCye07aE+Xt3A5jaZ3c7UZkJC/3BsFQ+442EBx9Lrsc2Yrb8EmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tp9gPtHS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736863786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YtFP9pQtyoWXgcTFBJgS77jtXl6lTbOzCPS/O8U2TSM=;
	b=Tp9gPtHS/Yl3qU740kngH4rzwaHk3+dHLeUm+bxQb9EsUoUSX1qXKCIcewlUMzoYRg4QVd
	ysDuM8pNUnHoBZx5zNtfm8We2Zz5ALAX36j1h3nK0LKvd8K7aJrRNbIZ+Bj5Z64bYAzVlw
	gilZAYz9i5XmTPbiml4+VIc7WJhS39E=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-39-TNkGwPpZMXut9Uy085CiIA-1; Tue, 14 Jan 2025 09:09:45 -0500
X-MC-Unique: TNkGwPpZMXut9Uy085CiIA-1
X-Mimecast-MFC-AGG-ID: TNkGwPpZMXut9Uy085CiIA
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4361efc9dc6so30239175e9.3
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 06:09:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736863784; x=1737468584;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YtFP9pQtyoWXgcTFBJgS77jtXl6lTbOzCPS/O8U2TSM=;
        b=qhxiXSYeZPt27OfiaHhvdBVub/79n4/24PxwbeG+MYpGSLdBzOFueKHskF5Rem+iEj
         ItIl6sG/63zqGgrILt5mJrbp9yLZXmL7TbbLdUY69E8tqH1j6a+BG9PVehOYHQVoacSy
         4lISK7wGndjiHrrMxTJ3kJU3YNvaugeDhwtiYPRfUwZ9TMHiCuaxlRK8xtZLfLWxJ9vS
         dsRgR7ZiTDN8WUD4XnagCr0zy9dP/a+5SEZcqRdMl/dQ6ZP3dkT4BGuuLsrnu5ZySJjz
         9Fq1j1Fd827CTysmVafarLke/uZDxB/w4+WUtgDrBzFnLNvkSwqGAydvU1KGg45ehMgp
         hSkw==
X-Forwarded-Encrypted: i=1; AJvYcCXXdJeR6TvYgmKTSPwO9/3eWBkDBJGeBZ+Eoc73nXV3XTh8Y068AWWnLTvIi0rtSGtMoaY=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywu4md+33wp6PR6lrPBNjIdZXc0YFDzo2YPbiFNsaVtDrirv85I
	yBiKXEXR3B3rHJcQ1lKU0UtTdZymQh/FN/19ZgTu/Pu9OgyQIqTnYi14ldGZtiRPeJ+ftBuHl0W
	WowtYlXWR+nezB2acKukCyHv7tDRzeTBQQiq0g1FSUJ1V2jsHKg==
X-Gm-Gg: ASbGncuZ9c7Q+lGS1cAUJlOsVIqiI8Ff1pI7Odhi5xMYRNpa5JiFoB0tOJMjV2UxcZV
	VnaLj3S4GwAIplErkWQENcfuHY7dPKeqXNuwKGHdvUVxHyQ1nMgGB1L5u3SHBIODlfw+BFPjFaa
	5LDnwYdEsPC/rMTJ0KhTfQeuXzhAC6/lT7gmCHjbtkove5qVlb44U1lyAoHoh0/Q2XZTsT8uXoI
	dZkzngbObr8r805PmMpbRW7rwXQ+qPts/C8jJyVFoutWiPjoJBWBp76N/HyxLAa5taGJmjtVtZH
	NjigMl+98JUcGvAevN5pyAIhPh0ZVfh4s29GQrQFi1NxEdqlVlbA76Y8k/j3wnTtuPMurfqKxSn
	f6abMyNOh
X-Received: by 2002:a05:600c:1d01:b0:434:fec5:4ef5 with SMTP id 5b1f17b1804b1-436e26b6f51mr256244155e9.14.1736863783737;
        Tue, 14 Jan 2025 06:09:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGWgBcIVdI6gQFT8JyK2JjUepf09D2Q7KNXgK0Ji2rsye7aHM9jrIvCewzQgzJesG/qFABPCw==
X-Received: by 2002:a05:600c:1d01:b0:434:fec5:4ef5 with SMTP id 5b1f17b1804b1-436e26b6f51mr256243805e9.14.1736863783347;
        Tue, 14 Jan 2025 06:09:43 -0800 (PST)
Received: from ?IPV6:2003:cb:c738:3100:8133:26cf:7877:94aa? (p200300cbc7383100813326cf787794aa.dip0.t-ipconnect.de. [2003:cb:c738:3100:8133:26cf:7877:94aa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e9dc8802sm175247615e9.10.2025.01.14.06.09.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 06:09:42 -0800 (PST)
Message-ID: <39b26b64-deaa-4c52-8656-b334e992c28c@redhat.com>
Date: Tue, 14 Jan 2025 15:09:40 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/6] accel/kvm: Report the loss of a large memory page
To: =?UTF-8?Q?=E2=80=9CWilliam_Roche?= <william.roche@oracle.com>,
 kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20250110211405.2284121-1-william.roche@oracle.com>
 <20250110211405.2284121-4-william.roche@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250110211405.2284121-4-william.roche@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10.01.25 22:14, “William Roche wrote:
> From: William Roche <william.roche@oracle.com>
> 
> In case of a large page impacted by a memory error, enhance
> the existing Qemu error message which indicates that the error
> is injected in the VM, adding "on lost large page SIZE@ADDR".
> 
> Include also a similar message to the ARM platform.
> 
> In the case of a large page impacted, we now report:
> ...Memory Error at QEMU addr X and GUEST addr Y on lost large page SIZE@ADDR of type...
> 
> Signed-off-by: William Roche <william.roche@oracle.com>
> ---
>   accel/kvm/kvm-all.c   |  4 ----
>   target/arm/kvm.c      | 13 +++++++++++++
>   target/i386/kvm/kvm.c | 18 ++++++++++++++----
>   3 files changed, 27 insertions(+), 8 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 4f2abd5774..f89568bfa3 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -1296,10 +1296,6 @@ static void kvm_unpoison_all(void *param)
>   void kvm_hwpoison_page_add(ram_addr_t ram_addr)
>   {
>       HWPoisonPage *page;
> -    size_t page_size = qemu_ram_pagesize_from_addr(ram_addr);
> -
> -    if (page_size > TARGET_PAGE_SIZE)
> -        ram_addr = QEMU_ALIGN_DOWN(ram_addr, page_size);
>   
>       QLIST_FOREACH(page, &hwpoison_page_list, list) {
>           if (page->ram_addr == ram_addr) {
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index a9444a2c7a..323ce0045d 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -2366,6 +2366,8 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
>   {
>       ram_addr_t ram_addr;
>       hwaddr paddr;
> +    size_t page_size;
> +    char lp_msg[54];
>   
>       assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
>   
> @@ -2373,6 +2375,14 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
>           ram_addr = qemu_ram_addr_from_host(addr);
>           if (ram_addr != RAM_ADDR_INVALID &&
>               kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
> +            page_size = qemu_ram_pagesize_from_addr(ram_addr);
> +            if (page_size > TARGET_PAGE_SIZE) {
> +                ram_addr = ROUND_DOWN(ram_addr, page_size);
> +                snprintf(lp_msg, sizeof(lp_msg), " on lost large page "
> +                    RAM_ADDR_FMT "@" RAM_ADDR_FMT "", page_size, ram_addr);
> +            } else {
> +                lp_msg[0] = '\0';
> +            }
>               kvm_hwpoison_page_add(ram_addr);
>               /*
>                * If this is a BUS_MCEERR_AR, we know we have been called
> @@ -2389,6 +2399,9 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
>                   kvm_cpu_synchronize_state(c);
>                   if (!acpi_ghes_record_errors(ACPI_HEST_SRC_ID_SEA, paddr)) {
>                       kvm_inject_arm_sea(c);
> +                    error_report("Guest Memory Error at QEMU addr %p and "
> +                        "GUEST addr 0x%" HWADDR_PRIx "%s of type %s injected",
> +                        addr, paddr, lp_msg, "BUS_MCEERR_AR");
>                   } else {
>                       error_report("failed to record the error");
>                       abort();
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 2f66e63b88..7715cab7cf 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -741,6 +741,8 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
>       CPUX86State *env = &cpu->env;
>       ram_addr_t ram_addr;
>       hwaddr paddr;
> +    size_t page_size;
> +    char lp_msg[54];
>   
>       /* If we get an action required MCE, it has been injected by KVM
>        * while the VM was running.  An action optional MCE instead should
> @@ -753,6 +755,14 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
>           ram_addr = qemu_ram_addr_from_host(addr);
>           if (ram_addr != RAM_ADDR_INVALID &&
>               kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
> +            page_size = qemu_ram_pagesize_from_addr(ram_addr);
> +            if (page_size > TARGET_PAGE_SIZE) {
> +                ram_addr = ROUND_DOWN(ram_addr, page_size);

As raised, aligning ram_addr_t addresses to page_size is wrong.

Maybe we really want to print block->idstr, offset, size like I proposed 
at the other place, here as well?

-- 
Cheers,

David / dhildenb


