Return-Path: <kvm+bounces-60568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C0E76BF3460
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 21:47:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EFEBE1888781
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 19:47:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B229432F74F;
	Mon, 20 Oct 2025 19:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="gxjJWtBk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AE76BFCE
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 19:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760989636; cv=none; b=AuNPuCFDL7vQpUEvwYUPyIKKwPpFgZkSDAFmPxsteXmCeLmaoh9MtFENRtBUlfeDq/zaH+2kmXhRNzAeStz2YdPiXyumbJmww2z3mdGUyf+ThcUrR89gjHSxJbwad9BSnpVDAlMNPBYie/fmq9Ini5lIlBq6S+O7pXWVeO/LIcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760989636; c=relaxed/simple;
	bh=Zd72u21sHnlUwvSbRt1SRLx/FrPMlp6pbPmb7VSQ83c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cO4s0vLRGVZgJMNYiP/y8FZTYLF5G3dLVEfZ7M9NOmeXoqw9Iz/Zjxbfrqz39vyWomMguhXURZNYbxgicdfIZ1REl+2m6vldB/E9bTf1kUO2pLosRi3V3G1nWOoUx60Sojuun3QADbYMJqNX2iLd7fdQ3/YNBUAEuDhgwMKEx5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=gxjJWtBk; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-33d463e79ddso3816088a91.0
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 12:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1760989635; x=1761594435; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T29G72fExJyk8VtqV3YJi7ZBrueGLIkeAq2lMcMuWYA=;
        b=gxjJWtBkv9h62mXNGbPkAETR5GCr3tKT7oGl1/DPsBs5nIeDklzevp4EsweRibDrKu
         LTb2NWDqmVKxonrJFWiJrxVp8zFBS/v+ein4l4/8z1iHzQ/8pmcT9EqgGlzHnFsZ2yK2
         gUzzyEQh2DgdF6RP+Kmn6lXP8AliuAt3tUbjO+G6KH44pn+r2vh7fpXwlTRIR8exHh01
         2Zu0XcslntC1f7hLcAjLoiee36cwY2OR5n4IGpnp0FXWEOOYAOaNUzzVpBNW414eb8MC
         sbrF85Kn7n1oMJzbxito5cV0BdlwgfM+NsfjbFrM9z4m4dC8LcjxX3b/g56QWRRT6hxS
         HQrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760989635; x=1761594435;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T29G72fExJyk8VtqV3YJi7ZBrueGLIkeAq2lMcMuWYA=;
        b=h1/y5IQ4a4cu3JbsFkK9DOlxX/nHG0/a7DkrtgKgBNj6IWw8puflxYbU+XzOPmJmPZ
         cKdi5EGl2F2OvZBi/BF8cN8ZKCOZc7+di4ApZszwxYExpBq9ADFG7gveNBO0BWSFH1dg
         0pxVFP9ZSb3lF8L6Umw5WXo0yeh8uuLtQlF5OpQC+Qw8MsewA4Z6JcXdtEfEyQj1kn+s
         xsgysvTsO768OFkoDrFEVxzRGWnPV6DPYQ/RySAt6pZ33jDem0Qij0KDbiq6HGKMbSDF
         eYQ6/ntdh4gs41k+QVAWgI+UEcpNVfRPz8Jxklnrqlv0vIHF8bFjjrSMM9hv+gc6irzX
         wyBg==
X-Forwarded-Encrypted: i=1; AJvYcCX6kkyk7utuFKFmNKB5xoAQ+9bLGAHmuF8Mhp/J/e2A0WnSe6V6hJL3yrx0pvFDNB2Aq48=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBfxbMcQx7FhpUFWTP5wCw42U9Ss+nYkoZdVGhNO1VX+0ctlcp
	5Pwzo9kuFUW7BXW0/98KdtXswNx3keQyZF6zptBLUVKShRnWQ2xIT13pcsZyCigWaeQ=
X-Gm-Gg: ASbGncv/GzspBKk7+p39lBKA7/1oIsqrj3J1zFpa96uNWVt0HkeSEebJVgYLmrqS+Zb
	9x6CsaYS4Xpd6JPbNIInHL7SPyyXHrxTe4F67xfCgq5tR3P3+BFPn5LWiR1yNVxU/PEmXucUlm1
	L/oDKc9PjvGO59/ImGl62PAOCKY8v9U+odTxQwq2/z2ZQtZx1FuO1aR06r9V1TL+5X+y4at0fcH
	Hg028nOjC/4wRUVoFt8jORRrZeEeGzHOHrnhvlLTawagqfYdqoRtYyjZpysqm4febAxCS0nK/mP
	MpHldwDn2pDmnIwbI34k63TzWkXmEs7hCre51KLX2X/Nck3MxO5Rp2KP+nDMKhfPfmmTd3ibxAZ
	DyKdmVXkDY/zHPJ9ARvp7TlYGwR+enwE23ZPGJ3rMADjrF6dab+KSJKI3IU3lL34F5xd3rH04v8
	dZUDPy3hiIROR3+HOpVUcNqHWYLXVh420EdxISo6I4uhVjyijkag5G9DZz4nECiyGi
X-Google-Smtp-Source: AGHT+IHbuqXK1u6LquvMt8XAnfwihmyV2uHtYn9qEdWcAtI1wb6x8mv/e+BQVy3+n2euvz+X557SNA==
X-Received: by 2002:a17:902:e88e:b0:290:a3b9:d4be with SMTP id d9443c01a7336-290c9ce63cbmr161125965ad.24.1760989634647;
        Mon, 20 Oct 2025 12:47:14 -0700 (PDT)
Received: from ?IPV6:2804:7f0:bcc1:8cb8:dfc4:4af0:d7c6:a030? ([2804:7f0:bcc1:8cb8:dfc4:4af0:d7c6:a030])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29246fd5d76sm88303565ad.39.2025.10.20.12.47.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 12:47:14 -0700 (PDT)
Message-ID: <4d1e8b55-e404-466b-a2d6-b189de910637@ventanamicro.com>
Date: Mon, 20 Oct 2025 16:47:07 -0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 18/18] DO NOT UPSTREAM: RISC-V: KVM: Workaround
 kvm_riscv_gstage_ioremap() bug
To: fangyu.yu@linux.alibaba.com, ajones@ventanamicro.com
Cc: alex.williamson@redhat.com, alex@ghiti.fr, anup@brainfault.org,
 atish.patra@linux.dev, iommu@lists.linux.dev, jgg@nvidia.com,
 joro@8bytes.org, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
 palmer@dabbelt.com, paul.walmsley@sifive.com, robin.murphy@arm.com,
 tglx@linutronix.de, tjeznach@rivosinc.com, will@kernel.org,
 zong.li@sifive.com
References: <20250920203851.2205115-38-ajones@ventanamicro.com>
 <20251020131218.68932-1-fangyu.yu@linux.alibaba.com>
From: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Content-Language: en-US
In-Reply-To: <20251020131218.68932-1-fangyu.yu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Drew,

On 10/20/25 10:12 AM, fangyu.yu@linux.alibaba.com wrote:
>> Workaround a bug that breaks guest booting with device assignment that
>> was introduced with commit 9bca8be646e0 ("RISC-V: KVM: Fix pte settings
>> within kvm_riscv_gstage_ioremap()")
> 
> The root cause of the guest booting failure is that an HPA is obtained
> in the kvm_arch_prepare_memory_region.
> 
> Here [1] might be the correct fixes for this issue.
> [1] https://lore.kernel.org/linux-riscv/20251020130801.68356-1-fangyu.yu@linux.alibaba.com/T/#u

This patch fixes the issue we've been seeing with device assignment inside a
kvm guest. I suggest folding it into this series and dropping this workaround
patch in the next version.


Thanks,

Daniel


> 
>> ---
>> arch/riscv/kvm/mmu.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
>> index 525fb5a330c0..994f18b92143 100644
>> --- a/arch/riscv/kvm/mmu.c
>> +++ b/arch/riscv/kvm/mmu.c
>> @@ -56,7 +56,7 @@ int kvm_riscv_mmu_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
>>
>> 	end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
>> 	pfn = __phys_to_pfn(hpa);
>> -	prot = pgprot_noncached(PAGE_WRITE);
>> +	prot = pgprot_noncached(__pgprot(_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_READ | _PAGE_WRITE));
>>
>> 	for (addr = gpa; addr < end; addr += PAGE_SIZE) {
>> 		map.addr = addr;
>> -- 
>> 2.49.0
> 
> Thanks,
> Fangyu
> 


