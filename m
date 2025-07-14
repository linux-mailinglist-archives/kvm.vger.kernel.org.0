Return-Path: <kvm+bounces-52310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 88AE1B03D4D
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 13:25:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E5403AEAAC
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 11:24:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AC80246BAF;
	Mon, 14 Jul 2025 11:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JXqzOilt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4077623C8A1
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 11:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752492293; cv=none; b=jmdSsq/UXwyUmpOBWjT4BnROakULdT5A4Oz7Up1Mh1qD90oWwYJnwTTXHQhzTzj6yOaon3xG4VSnenTo826IAcoZ8x1EsAxz51ONOKyLekBLeM4opmaxb19jaEkZ3KvhIy7kiyGRez/CQf2HC/C05WOrON6/6J45KA/qsKro8oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752492293; c=relaxed/simple;
	bh=iYT44WElK5mienuaO/HbMHbwDQsz8DHTN4KSmVPDCUY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K6OXD0E+ovE05H8dqWOKwCvofFLO5sVVtXPkSWu5QoQzlFlLLnBwMbWAZ9R7TsIaNOl+O4d86rowqLChgo2YCqoH+81Ta48uZQs7BaRszMscMrEl0dkmsSFZRSnWSDZvstJXF/SUh0tjY9lpzT3LLZKyRcthEeSfADAU8ke9T0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JXqzOilt; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ae0dad3a179so713625366b.1
        for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 04:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1752492289; x=1753097089; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SJSCkH8SXulB8gzjVSl7ssENLumIeAgZx3lJnpZRwXA=;
        b=JXqzOiltTEZYwe7MXvGM27DzyF8fO9VGbZK9k2Wed5CpYT/tqzQWXMyCY4xox9dtFT
         FSfbPM7FvH+zHCOtWleAKcp2blpAf5g+n+0Ne0dMVNC2oBBF3jYt+M7Dicl14Q+Lo8ri
         iNWZ2s7K6Y65SRG8pd6sneUxh+L2omVYa8xLoonF6iZGDc2VGvc2ijOTczw2N0Zyf9MX
         kVA81ZD7p7rPAXVNdolxfmwBSM7rMiVEKWPnKeDA43nAQ0MyUjhN2Q9iZpp6lqlcX+pR
         tfHnZQrh1n/bZelwNIFCDGSfOk0F9HviD9+Z7IKTyK90OyfWbJx+vpcazUSpiE740DKV
         50jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752492289; x=1753097089;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SJSCkH8SXulB8gzjVSl7ssENLumIeAgZx3lJnpZRwXA=;
        b=MSXVgGTgf1nr2MF+el2KZfCA4eqxjyDr7voPJYtK0jEHtbMr2SMRB2nP/IgSqDCkmz
         MrVcMnkIKQGVE2ko4on6bwVYRh3xZ40bJ/JMeGbfrW8rXNsnKOVEngEiL8XtkxfNFVIk
         JE4oOgBzz8WYWjMjwxpV7FagmRvZoGRjkyiZr1UL69gTTrdASgNn668a8BJA0KWe3jpT
         uYB1K1zJf0nZoyaXP9QCIkKx/sOwhio5dWAqp67uPgcZvr2XYhgzVE7XXHtlN/NZSfOK
         fzD3bi601qWiC/Df0/jjhqSfGOGYD06sOwNR8LKHQyhpfvPxj+Vls0wDdjzQFwX2DmNT
         W1Xg==
X-Forwarded-Encrypted: i=1; AJvYcCUJq0rIdBspWxZDAKooqdlluEaQh15eUGz2bjIajLUQRmbFRxn0f2KOiy5zvRyzpmAjqM4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMs9QgjVkOopNRSucIs1H1KXNR9apsljpSdonL6DjvJwKP6Bmw
	/LxvQY6owDjArSuhEXw0xLjWvzVH1KJ28uoCLek/EZ86GBUt9t3C4xRDZrfd6tcHFtM=
X-Gm-Gg: ASbGncvVqFmikwuvqevl09ltyEem77ulyjo+GUDu3iP5dQT2YRqMxtrF04dgZsKtSwp
	9UlJ2aZX7DwhiGDx3McnYT21Tiw7cP0o3y/kLi9neO5PeunbA3FEzwvio7umex9DdqBazZRX9I+
	UENEIuAJapKHRkdF8hfO3p4wrqF/dQb7Le6mZUIdT/46haYiDYcvxp+81wVYIVmzboeIeOPqM+U
	07ZlSfjlEKV2cfEul5AyZa55LAuurfmrOMgwySmGek/OVn8kbDRd7Oz501+bfq5RdFjyYQOoqm6
	7NXdbWLQAf4Q5DsvaBW8H/t1oF6R+1jLqOw9mCO2dQr2fhDIv8R6pnSBsOAYieigyCaOXJOUjcF
	6nbRUNRSm3R0zMgx91h4/4NA=
X-Google-Smtp-Source: AGHT+IF3OdEhLF0fZL6hcJiMrcz+5YZmdSpgfvxDQhaRSMdHTHJDqIPKAzb8nI/Qck+gtO90Oq46SA==
X-Received: by 2002:a17:907:1c13:b0:ad5:7bc4:84b5 with SMTP id a640c23a62f3a-ae6fc0f4e38mr1399528866b.57.1752492289444;
        Mon, 14 Jul 2025 04:24:49 -0700 (PDT)
Received: from [10.20.4.146] ([149.62.209.4])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e8293fe7sm794929866b.123.2025.07.14.04.24.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jul 2025 04:24:49 -0700 (PDT)
Message-ID: <4acfa729-e0ad-4dc7-8958-ececfae8ab80@suse.com>
Date: Mon, 14 Jul 2025 14:24:42 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
To: Binbin Wu <binbin.wu@linux.intel.com>, Jianxiong Gao <jxgao@google.com>,
 Sean Christopherson <seanjc@google.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Dionna Glaze <dionnaglaze@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
 jgross@suse.com, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ingo Molnar <mingo@redhat.com>, pbonzini@redhat.com,
 Peter Gonda <pgonda@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <CAMGD6P1Q9tK89AjaPXAVvVNKtD77-zkDr0Kmrm29+e=i+R+33w@mail.gmail.com>
 <0dc2b8d2-6e1d-4530-898b-3cb4220b5d42@linux.intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <0dc2b8d2-6e1d-4530-898b-3cb4220b5d42@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 14.07.25 г. 12:06 ч., Binbin Wu wrote:
> 
> 
> On 7/10/2025 12:54 AM, Jianxiong Gao wrote:
>> I tested this patch on top of commit 8e690b817e38, however we are
>> still experiencing the same failure.
>>
> I didn't reproduce the issue with QEMU.
> After some comparison on how QEMU building the ACPI tables for HPET and 
> TPM,
> 
> - For HPET, the HPET range is added as Operation Region:
>      aml_append(dev,
>          aml_operation_region("HPTM", AML_SYSTEM_MEMORY, 
> aml_int(HPET_BASE),
>                               HPET_LEN));
> 
> - For TPM, the range is added as 32-Bit Fixed Memory Range:
>      if (TPM_IS_TIS_ISA(tpm_find())) {
>          aml_append(crs, aml_memory32_fixed(TPM_TIS_ADDR_BASE,
>                     TPM_TIS_ADDR_SIZE, AML_READ_WRITE));
>      }
> 
> So, in KVM, the code patch of TPM is different from the trace for HPET 
> in the
> patch 
> https://lore.kernel.org/kvm/20250201005048.657470-3-seanjc@google.com/,
> HPET will trigger the code path acpi_os_map_iomem(), but TPM doesn't.
> 
> I tried to hack the code to map the region to WB first in tpm_tis driver to
> trigger the error.
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 9aa230a63616..62d303f88041 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -232,6 +232,7 @@ static int tpm_tis_init(struct device *dev, struct 
> tpm_info *tpm_info)
>          if (phy == NULL)
>                  return -ENOMEM;
> 
> +       ioremap_cache(tpm_info->res.start, resource_size(&tpm_info->res));
>          phy->iobase = devm_ioremap_resource(dev, &tpm_info->res);
>          if (IS_ERR(phy->iobase))
>                  return PTR_ERR(phy->iobase);
> Then I got the same error
> [ 4.606075] ioremap error for 0xfed40000-0xfed45000, requested 0x2, got 0x0
> [ 4.607728] tpm_tis MSFT0101:00: probe with driver tpm_tis failed with 
> error -12


The thing is we don't really want to get into the if (pcm != new_pcm) { 
branch, because even if it succeeds there then the mapping will be 
wrong, because we want accesses to the TPM to be uncached since that's 
an iomem region, whereas this error shows that the new_pcm is WB.

Also looking at memtype_reserve in it there is the following piece of code:

if (x86_platform.is_untracked_pat_range(start, end)) {
      7                 if (new_type) 

      6                         *new_type = _PAGE_CACHE_MODE_WB; 

      5                 return 0; 

      4         }


So if is_untracked_pat_range returns true then the cache mode will 
always be WB.


> 
> And with Sean's patch set, the issue can be resolved.
> 
> I guess google's VMM has built different ACPI table for TPM.
> But according to my experiment, the issue should be able to be fixed by 
> this
> patch set, though I am not sure whether it will be the final solution or 
> not.

