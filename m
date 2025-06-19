Return-Path: <kvm+bounces-49956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 23480AE01A6
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 11:26:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 72D60189AB11
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 09:26:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EC53265637;
	Thu, 19 Jun 2025 09:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="c3aw0hUu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFAC21A931
	for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 09:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750325175; cv=none; b=MMCpVha2RUOz9h6IAC5DYIiOjAM+UY8uSCtElYTpdR55YaCkJaq2eTx8qYxjHulpFwpeFMJOZIq38MxyCpo6x2yKBrWfgzrNrL6jNV88kqnCB2jeVkaOjLrgPWeeZl5GT2Rr5Ifiua0MUSRHSVaVLxMCJMzfSgY6Y9sZZO8peK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750325175; c=relaxed/simple;
	bh=oePC2rsrL/0s5r5IT9EMpK1hS6g3c56JLYbSqtIXBgQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T5aMW/TXmcbdzu3TPTEH1DNfH3HB7oPmNjnaE4dPsTp79+kDaFxY8bBY28x93WJa4E67f9AexUmjIbmwiBvW0s+YlGrWqh1ab9CZ8Hsg5O6xZkmE2gQ3Q5A30/tHG9Gk8PZ9Et6wVhGMbQeJhP//454aMtTwaXnTKi+OtZiHGBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=c3aw0hUu; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4532ff4331cso1521855e9.1
        for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 02:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1750325171; x=1750929971; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=xFduEnhXUsatH/EJNhRFobWfktSYom6XTIV/7I7xFnQ=;
        b=c3aw0hUurqqU9eqQgInBKNIeeXwf/+BZzmTAq3n1bBVxZ0jhpeaxzlqyjBI+KG/6hu
         gFmggOJ2+aE/orW8WgqKu5+8rRzVfgDq1T75j5xfhPUr1D5HKUbBRpU4v2Xdx+8OwEuW
         Z1RGJKwooHcvJaO4Z+ufwtEzYa72lA3DipI0FN4cyzi6MCedtRMp0fsMwBeIpvgPyII+
         e0oSI5YQcaSs0zwHAPBYzXEHU0dnY/Y/llLSjICv9JoaoVt85zW6H+YVhl1Dh+ztZAPo
         N1LKDim4kR8opAkzzyBxZCMplE+4v2woPJoboYCnEirtR+G0u0mqPk8ibYkXVv51kq5L
         OEZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750325171; x=1750929971;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xFduEnhXUsatH/EJNhRFobWfktSYom6XTIV/7I7xFnQ=;
        b=bHxWK+v5wn9r9yJmclnh0VhYNSNCZ9RSIrLkXLLKIkqv3BWhpwynuMvd28qxhkjFBc
         ky45aMXumCEbCsEfaqzCP4KBZIl/queGeQRne266RugdZW1GuzOa8WOd524GLkurkFo+
         vJCCE7sIsCJOZJDkzSjaChPSNL5u1f7k0BWOqNTrFeC4PnGsqQxE+IPT6pPlPpVqF8A7
         oL9r/5TtiMNngn/kW0UB3Q1ZY6B9kym8EGMvqeRe4110zy+6iO1auY1k84xAXng8CUjK
         agQR+X/SdAAr7CmbDeGio9d7j2ZtP3iTyEy/hVHKBu6i/BRMw9KLij1ZgeC9MT8Po5D0
         yx5w==
X-Forwarded-Encrypted: i=1; AJvYcCXtb3hWYw3MEkpePYQnDHk5Q0JIfHappcXIm9Md1JMcnzVefrmKjJ4tYGIOkRVCJ2X4xq4=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywvm6nvDAQzQ/K4ts2mh5e4KjKEvxZM/ZcKfgCXflDmfTvWtgwq
	6xb4CMszSdRzvcfmPdfadlAlsmiSbrxy7ybNZBZ4FiW9bw7OicvWvFBrbVBY+2niyJA=
X-Gm-Gg: ASbGncud53KJp6Yl1uqZAdTOOjPZMp3A0xONnLLrhawzUQuhKpu2jCddV9HrewuHBRR
	RcUxK59e4HWu2NCHupLAEsZ5TcvjNbdiHfKm6Y5OR1aAeQQ1bqFhN8TLHbVa1nPrVIupyGqinAv
	EjHNNVAj3G+B+aigf5Br+BGuk2FvVSB9KBFDpRNSlRWELnDS3jNsCEG5xKScJPXoM7clB6ZW4vd
	GBtBlvmFBX1wkizx6IcNeYx1ks/Cgnc2+w4qDlaqp0aBTCYZYY4Uv610rDzc0qobir2UCx0kYTv
	8aOQGZ+3hWM8ulUy0Jbiw3DuGfEyD7z2Wp2cJA6JreiWebnx4BRIZoaR4ga0rJ+6gg==
X-Google-Smtp-Source: AGHT+IH+rSLelUbOCvaoicNNF/CyY7wjSjbi8eWu3dGQSyY9nlmw7zz/AphopgWm6bwj3NGMdFfUkQ==
X-Received: by 2002:a05:600c:3f07:b0:442:f4a3:b5ec with SMTP id 5b1f17b1804b1-4533ca7a34bmr206457105e9.4.1750325171411;
        Thu, 19 Jun 2025 02:26:11 -0700 (PDT)
Received: from [192.168.0.20] ([212.21.159.38])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4535e9844c3sm23119385e9.11.2025.06.19.02.26.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jun 2025 02:26:11 -0700 (PDT)
Message-ID: <9376b309-8561-4fcc-9e71-3bd03fd8f9d0@suse.com>
Date: Thu, 19 Jun 2025 12:26:07 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/21] x86/virt/tdx: Enhance tdh_mem_page_aug() to
 support huge pages
To: Yan Zhao <yan.y.zhao@intel.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>,
 "Shutemov, Kirill" <kirill.shutemov@intel.com>,
 "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
 <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
 "tabba@google.com" <tabba@google.com>, "Li, Zhiquan1"
 <zhiquan1.li@intel.com>, "Du, Fan" <fan.du@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "michael.roth@amd.com" <michael.roth@amd.com>,
 "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "Peng, Chao P" <chao.p.peng@intel.com>,
 "Annapurve, Vishal" <vannapurve@google.com>,
 "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
 "pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030428.32687-1-yan.y.zhao@intel.com>
 <a36db21a224a2314723f7681ad585cbbcfdc2e40.camel@intel.com>
 <aCb/zC9dphPOuHgB@yzhao56-desk.sh.intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 xsFNBGcrpvIBEAD5cAR5+qu30GnmPrK9veWX5RVzzbgtkk9C/EESHy9Yz0+HWgCVRoNyRQsZ
 7DW7vE1KhioDLXjDmeu8/0A8u5nFMqv6d1Gt1lb7XzSAYw7uSWXLPEjFBtz9+fBJJLgbYU7G
 OpTKy6gRr6GaItZze+r04PGWjeyVUuHZuncTO7B2huxcwIk9tFtRX21gVSOOC96HcxSVVA7X
 N/LLM2EOL7kg4/yDWEhAdLQDChswhmdpHkp5g6ytj9TM8bNlq9I41hl/3cBEeAkxtb/eS5YR
 88LBb/2FkcGnhxkGJPNB+4Siku7K8Mk2Y6elnkOctJcDvk29DajYbQnnW4nhfelZuLNupb1O
 M0912EvzOVI0dIVgR+xtosp66bYTOpX4Xb0fylED9kYGiuEAeoQZaDQ2eICDcHPiaLzh+6cc
 pkVTB0sXkWHUsPamtPum6/PgWLE9vGI5s+FaqBaqBYDKyvtJfLK4BdZng0Uc3ijycPs3bpbQ
 bOnK9LD8TYmYaeTenoNILQ7Ut54CCEXkP446skUMKrEo/HabvkykyWqWiIE/UlAYAx9+Ckho
 TT1d2QsmsAiYYWwjU8igXBecIbC0uRtF/cTfelNGrQwbICUT6kJjcOTpQDaVyIgRSlUMrlNZ
 XPVEQ6Zq3/aENA8ObhFxE5PLJPizJH6SC89BMKF3zg6SKx0qzQARAQABzSZOaWtvbGF5IEJv
 cmlzb3YgPG5pay5ib3Jpc292QHN1c2UuY29tPsLBkQQTAQoAOxYhBDuWB8EJLBUZCPjT3SRn
 XZEnyhfsBQJnK6byAhsDBQsJCAcCAiICBhUKCQgLAgQWAgMBAh4HAheAAAoJECRnXZEnyhfs
 XbIQAJxuUnelGdXbSbtovBNm+HF3LtT0XnZ0+DoR0DemUGuA1bZAlaOXGr5mvVbTgaoGUQIJ
 3Ejx3UBEG7ZSJcfJobB34w1qHEDO0pN9orGIFT9Bic3lqhawD2r85QMcWwjsZH5FhyRx7P2o
 DTuUClLMO95GuHYQngBF2rHHl8QMJPVKsR18w4IWAhALpEApxa3luyV7pAAqKllfCNt7tmed
 uKmclf/Sz6qoP75CvEtRbfAOqYgG1Uk9A62C51iAPe35neMre3WGLsdgyMj4/15jPYi+tOUX
 Tc7AAWgc95LXyPJo8069MOU73htZmgH4OYy+S7f+ArXD7h8lTLT1niff2bCPi6eiAQq6b5CJ
 Ka4/27IiZo8tm1XjLYmoBmaCovqx5y5Xt2koibIWG3ZGD2I+qRwZ0UohKRH6kKVHGcrmCv0J
 YO8yIprxgoYmA7gq21BpTqw3D4+8xujn/6LgndLKmGESM1FuY3ymXgj5983eqaxicKpT9iq8
 /a1j31tms4azR7+6Dt8H4SagfN6VbJ0luPzobrrNFxUgpjR4ZyQQ++G7oSRdwjfIh1wuCF6/
 mDUNcb6/kA0JS9otiC3omfht47yQnvod+MxFk1lTNUu3hePJUwg1vT1te3vO5oln8lkUo9BU
 knlYpQ7QA2rDEKs+YWqUstr4pDtHzwQ6mo0rqP+zzsFNBGcrpvIBEADGYTFkNVttZkt6e7yA
 LNkv3Q39zQCt8qe7qkPdlj3CqygVXfw+h7GlcT9fuc4kd7YxFys4/Wd9icj9ZatGMwffONmi
 LnUotIq2N7+xvc4Xu76wv+QJpiuGEfCDB+VdZOmOzUPlmMkcJc/EDSH4qGogIYRu72uweKEq
 VfBI43PZIGpGJ7TjS3THX5WVI2YNSmuwqxnQF/iVqDtD2N72ObkBwIf9GnrOgxEyJ/SQq2R0
 g7hd6IYk7SOKt1a8ZGCN6hXXKzmM6gHRC8fyWeTqJcK4BKSdX8PzEuYmAJjSfx4w6DoxdK5/
 9sVrNzaVgDHS0ThH/5kNkZ65KNR7K2nk45LT5Crjbg7w5/kKDY6/XiXDx7v/BOR/a+Ryo+lM
 MffN3XSnAex8cmIhNINl5Z8CAvDLUtItLcbDOv7hdXt6DSyb65CdyY8JwOt6CWno1tdjyDEG
 5ANwVPYY878IFkOJLRTJuUd5ltybaSWjKIwjYJfIXuoyzE7OL63856MC/Os8PcLfY7vYY2LB
 cvKH1qOcs+an86DWX17+dkcKD/YLrpzwvRMur5+kTgVfXcC0TAl39N4YtaCKM/3ugAaVS1Mw
 MrbyGnGqVMqlCpjnpYREzapSk8XxbO2kYRsZQd8J9ei98OSqgPf8xM7NCULd/xaZLJUydql1
 JdSREId2C15jut21aQARAQABwsF2BBgBCgAgFiEEO5YHwQksFRkI+NPdJGddkSfKF+wFAmcr
 pvICGwwACgkQJGddkSfKF+xuuxAA4F9iQc61wvAOAidktv4Rztn4QKy8TAyGN3M8zYf/A5Zx
 VcGgX4J4MhRUoPQNrzmVlrrtE2KILHxQZx5eQyPgixPXri42oG5ePEXZoLU5GFRYSPjjTYmP
 ypyTPN7uoWLfw4TxJqWCGRLsjnkwvyN3R4161Dty4Uhzqp1IkNhl3ifTDYEvbnmHaNvlvvna
 7+9jjEBDEFYDMuO/CA8UtoVQXjy5gtOhZZkEsptfwQYc+E9U99yxGofDul7xH41VdXGpIhUj
 4wjd3IbgaCiHxxj/M9eM99ybu5asvHyMo3EFPkyWxZsBlUN/riFXGspG4sT0cwOUhG2ZnExv
 XXhOGKs/y3VGhjZeCDWZ+0ZQHPCL3HUebLxW49wwLxvXU6sLNfYnTJxdqn58Aq4sBXW5Un0Q
 vfbd9VFV/bKFfvUscYk2UKPi9vgn1hY38IfmsnoS8b0uwDq75IBvup9pYFyNyPf5SutxhFfP
 JDjakbdjBoYDWVoaPbp5KAQ2VQRiR54lir/inyqGX+dwzPX/F4OHfB5RTiAFLJliCxniKFsM
 d8eHe88jWjm6/ilx4IlLl9/MdVUGjLpBi18X7ejLz3U2quYD8DBAGzCjy49wJ4Di4qQjblb2
 pTXoEyM2L6E604NbDu0VDvHg7EXh1WwmijEu28c/hEB6DwtzslLpBSsJV0s1/jE=
In-Reply-To: <aCb/zC9dphPOuHgB@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 5/16/25 12:05, Yan Zhao wrote:
> On Wed, May 14, 2025 at 02:52:49AM +0800, Edgecombe, Rick P wrote:
>> On Thu, 2025-04-24 at 11:04 +0800, Yan Zhao wrote:
>>> Enhance the SEAMCALL wrapper tdh_mem_page_aug() to support huge pages.
>>>
>>> Verify the validity of the level and ensure that the mapping range is fully
>>> contained within the page folio.
>>>
>>> As a conservative solution, perform CLFLUSH on all pages to be mapped into
>>> the TD before invoking the SEAMCALL TDH_MEM_PAGE_AUG. This ensures that any
>>> dirty cache lines do not write back later and clobber TD memory.
>>
>> This should have a brief background on why it doesn't use the arg - what is
>> deficient today. Also, an explanation of how it will be used (i.e. what types of
>> pages will be passed)
> Will do.
> 
>>>
>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
>>> ---
>>>   arch/x86/virt/vmx/tdx/tdx.c | 11 ++++++++++-
>>>   1 file changed, 10 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
>>> index f5e2a937c1e7..a66d501b5677 100644
>>> --- a/arch/x86/virt/vmx/tdx/tdx.c
>>> +++ b/arch/x86/virt/vmx/tdx/tdx.c
>>> @@ -1595,9 +1595,18 @@ u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u
>>>   		.rdx = tdx_tdr_pa(td),
>>>   		.r8 = page_to_phys(page),
>>>   	};
>>> +	unsigned long nr_pages = 1 << (level * 9);
>>> +	struct folio *folio = page_folio(page);
>>> +	unsigned long idx = 0;
>>>   	u64 ret;
>>>   
>>> -	tdx_clflush_page(page);
>>> +	if (!(level >= TDX_PS_4K && level < TDX_PS_NR) ||
>>> +	    (folio_page_idx(folio, page) + nr_pages > folio_nr_pages(folio)))
>>> +		return -EINVAL;
>>
>> Shouldn't KVM not try to map a huge page in this situation? Doesn't seem like a
>> job for the SEAMCALL wrapper.
> Ok. If the decision is to trust KVM and all potential callers, it's reasonable
> to drop those checks.
> 
>>> +
>>> +	while (nr_pages--)
>>> +		tdx_clflush_page(nth_page(page, idx++));
>>
>> clflush_cache_range() is:
>> static void tdx_clflush_page(struct page *page)
>> {
>> 	clflush_cache_range(page_to_virt(page), PAGE_SIZE);
>> }
>>
>> So we have loops within loops...  Better to add an arg to tdx_clflush_page() or
>> add a variant that takes one.
> Ok.
> 
> One thing to note is that even with an extra arg, tdx_clflush_page() has to call
> clflush_cache_range() page by page because with
> "#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)",
> page virtual addresses are not necessarily contiguous.
> 
> What about Binbin's proposal [1]? i.e.,
> 
> while (nr_pages)
>       tdx_clflush_page(nth_page(page, --nr_pages));

What's the problem with using:

+       for (int i = 0; nr_pages; nr_pages--)
+               tdx_clflush_page(nth_page(page, i++))


The kernel now allows C99-style definition of variables inside a loop + 
it's clear how many times the loop has to be executed.
> 
> [1] https://lore.kernel.org/all/a7d0988d-037c-454f-bc6b-57e71b357488@linux.intel.com/
> 
>>> +
>>>   	ret = seamcall_ret(TDH_MEM_PAGE_AUG, &args);
>>>   
>>>   	*ext_err1 = args.rcx;
>>
> 


