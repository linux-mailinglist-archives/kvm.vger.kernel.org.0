Return-Path: <kvm+bounces-56077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B07B9B399DB
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 12:29:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73B431C80FF9
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 10:29:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C04A30E0DC;
	Thu, 28 Aug 2025 10:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UPnguX3h"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0435330BBBF
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 10:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756376831; cv=none; b=MQ6pcDd5tj3d9YLWG0je6vrQ+mMCKNmUsBs+MO3pbspu1cZQmR143zmQ9kux5ttL3Z5duOJbs5yXHmTo/7H27Vhm14PnYkDCnXQ0oynIUGJF7Z5ZZMbzBnmrO1zYysjNaIo2WSFmOZwCIntO3UXa3dFp8+tg5IGM92jqwmaUx1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756376831; c=relaxed/simple;
	bh=V2DQ1K7o0rWRHZ5T0jHAqrTGbpQITG7eIK38E8u8zGI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c6Ph1egSxBAke0cMTAi8G3tmbW1ZBiGE6PauN4rJOtEHPBksQXR0CS3yMbaFMnJBnDn5gXJy152kSRw0tjEBuozx7uFoU2XVDy/pZsCQyj+AStx70HIwnH8WUSYGlJO8U+XPMHOlV5nrpHYq0tJGN1cKENymsUS8e8NJQTfYYG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UPnguX3h; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756376829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+boQAII1rVe8mjF/ARYqXtwP6OIEQU1CeV61LbixoDI=;
	b=UPnguX3hB+fk9knLQ7iwTvDuE6fyxQQILTzvlMLnmgOo3WmCa6yhZC7PYxhg/fxozhiXOQ
	JgWl6EdWrEu5Yy6E7EnK5G4oQOu4Jcdem/TivJsFPH3J7oRq1Xo4IXNdm3umGre3h2KZFO
	eG8GrAlp7Sx6niF714/JA78qzTbQRVw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-43-2O_ST4fSPO-04yGxoqFPvg-1; Thu, 28 Aug 2025 06:27:07 -0400
X-MC-Unique: 2O_ST4fSPO-04yGxoqFPvg-1
X-Mimecast-MFC-AGG-ID: 2O_ST4fSPO-04yGxoqFPvg_1756376826
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b612dbc28so5380545e9.0
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 03:27:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756376826; x=1756981626;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+boQAII1rVe8mjF/ARYqXtwP6OIEQU1CeV61LbixoDI=;
        b=mEky1NYwgO04IuElqUxp4UXno18v65hzK6MIjrMbdMF8l0J1GROd1eDgFLeFkzN43G
         q9QYxnUl3CwGXUsbkhSKOu8gNyqdbozrnJSIvjOzYaNHjdi7c29qMIegZUkEK2RGeRA5
         /oh98NcCUyJeUL9DArzsVl3vXFP6E9GyOfiMCd7WpADiCZx5XzOlpnp6lG3GI/4TwN6v
         WDYsrjJxSyaApU9YjYZ28eZusD57/n4glP0GgCV7yzQ3VsRG14gPEfm4JfEUFqvkH/sT
         j1S8r1sp+MhHfSiPhoCrPzp7ER4e9dAgK0IV+HN1SsgFtxQdQKx8FYlps2rWg0BwiiVo
         tbRA==
X-Forwarded-Encrypted: i=1; AJvYcCWd8z28hB4vUxDL/ZHx6Cvl7ItpnQOgLihA8UgrQGJhSKMkpJCn4C+BaiX8Y2ZNyMx1n5Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6KsV3F6G0SiqdlFAT1h/BnPSW8IG9xNkBYJal6H+7VTOJCpGy
	eFo25KcSGlfQqrBJ+nWzYCZVUGilrRn9czDbjcunNjLczxRs3/MaYYqXER9yGjNTFI3n3Xc17Bf
	aVe7GEYrovollsu810WixyYTTrWKiuuqtPKJk6rQetHhUfaTj81JeSA==
X-Gm-Gg: ASbGncuPhIBPpHF3Q0e01Z2xwy+gzuG/HntuVDwQLXi7a43iSOKY0hLYFR6uVMQPDAD
	Djfo86LQobqiqUxAW7Q/8XILkuZBkytaXrI5iX3QKz6+lsfNrBiuTQJKaGlN8DKr5PV/SMPwnvc
	bX8gqhSn7UfwCQTb0VLZSTUTyC6pBJBHCYUdfT1QQTu/OSWf6Ynina8IHMO+Hmqh2FGnzBSi7V1
	wWonP2A3l68L3OC3njPs+OVwAWSRKzYU8ewkqE2MXOENR8UL8LKEC7SOSoJI0hCMK3L7MWPkpVJ
	wtKc9l7asUqtdYnZnPX/GKgC0waxNazHWsKUeclDdLHKVbeMWBTcj023PSxGLfyAWE/2K+Lmxy1
	3eITClxGfG0PdjqfgpioOgxGF+qzIoX1hn8CSHrjbPF0SFmvCrVn8aNLuHgHG8/E16f0=
X-Received: by 2002:a05:600c:154f:b0:458:6733:fb43 with SMTP id 5b1f17b1804b1-45b517c552dmr175226175e9.19.1756376826330;
        Thu, 28 Aug 2025 03:27:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGPPKlRhmhqihhHf2b6I8uk2qPvwY6WU+Zs5Jt8nlR70umt1Km4fvCsG1mTvTrW6wkpR7QnGQ==
X-Received: by 2002:a05:600c:154f:b0:458:6733:fb43 with SMTP id 5b1f17b1804b1-45b517c552dmr175225815e9.19.1756376825801;
        Thu, 28 Aug 2025 03:27:05 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b79799c4fsm25881455e9.3.2025.08.28.03.27.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 03:27:05 -0700 (PDT)
Message-ID: <786503d6-e58d-412a-a17b-f5e4e481c3fe@redhat.com>
Date: Thu, 28 Aug 2025 12:27:04 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/12] KVM: Documentation: describe
 GUEST_MEMFD_FLAG_NO_DIRECT_MAP
To: "Roy, Patrick" <roypat@amazon.co.uk>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "tabba@google.com" <tabba@google.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "rppt@kernel.org"
 <rppt@kernel.org>, "will@kernel.org" <will@kernel.org>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
 "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "Thomson, Jack" <jackabt@amazon.co.uk>, "Manwaring, Derek"
 <derekmn@amazon.com>
References: <20250828093902.2719-1-roypat@amazon.co.uk>
 <20250828093902.2719-6-roypat@amazon.co.uk>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZoEEwEIAEQCGwMCF4ACGQEFCwkIBwICIgIG
 FQoJCAsCBBYCAwECHgcWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaJzangUJJlgIpAAKCRBN
 3hD3AP+DWhAxD/9wcL0A+2rtaAmutaKTfxhTP0b4AAp1r/eLxjrbfbCCmh4pqzBhmSX/4z11
 opn2KqcOsueRF1t2ENLOWzQu3Roiny2HOU7DajqB4dm1BVMaXQya5ae2ghzlJN9SIoopTWlR
 0Af3hPj5E2PYvQhlcqeoehKlBo9rROJv/rjmr2x0yOM8qeTroH/ZzNlCtJ56AsE6Tvl+r7cW
 3x7/Jq5WvWeudKrhFh7/yQ7eRvHCjd9bBrZTlgAfiHmX9AnCCPRPpNGNedV9Yty2Jnxhfmbv
 Pw37LA/jef8zlCDyUh2KCU1xVEOWqg15o1RtTyGV1nXV2O/mfuQJud5vIgzBvHhypc3p6VZJ
 lEf8YmT+Ol5P7SfCs5/uGdWUYQEMqOlg6w9R4Pe8d+mk8KGvfE9/zTwGg0nRgKqlQXrWRERv
 cuEwQbridlPAoQHrFWtwpgYMXx2TaZ3sihcIPo9uU5eBs0rf4mOERY75SK+Ekayv2ucTfjxr
 Kf014py2aoRJHuvy85ee/zIyLmve5hngZTTe3Wg3TInT9UTFzTPhItam6dZ1xqdTGHZYGU0O
 otRHcwLGt470grdiob6PfVTXoHlBvkWRadMhSuG4RORCDpq89vu5QralFNIf3EysNohoFy2A
 LYg2/D53xbU/aa4DDzBb5b1Rkg/udO1gZocVQWrDh6I2K3+cCs7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20250828093902.2719-6-roypat@amazon.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28.08.25 11:39, Roy, Patrick wrote:
> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
> ---
>   Documentation/virt/kvm/api.rst | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index c17a87a0a5ac..b52c14d58798 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6418,6 +6418,11 @@ When the capability KVM_CAP_GUEST_MEMFD_MMAP is supported, the 'flags' field
>   supports GUEST_MEMFD_FLAG_MMAP.  Setting this flag on guest_memfd creation
>   enables mmap() and faulting of guest_memfd memory to host userspace.
>   
> +When the capability KVM_CAP_GMEM_NO_DIRECT_MAP is supported, the 'flags' field
> +supports GUEST_MEMFG_FLAG_NO_DIRECT_MAP. Setting this flag makes the guest_memfd
> +instance behave similarly to memfd_secret, and unmaps the memory backing it from
> +the kernel's address space after allocation.
> +
>   When the KVM MMU performs a PFN lookup to service a guest fault and the backing
>   guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always be
>   consumed from guest_memfd, regardless of whether it is a shared or a private

WARNING: Missing commit description - Add an appropriate one
WARNING: From:/Signed-off-by: email name mismatch: 'From: "Roy, Patrick" 
<roypat@amazon.co.uk>' != 'Signed-off-by: Patrick Roy <roypat@amazon.co.uk>'

-- 
Cheers

David / dhildenb


