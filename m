Return-Path: <kvm+bounces-47796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08DBBAC5243
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 17:42:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3712616BA1C
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 15:42:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5739927CB1A;
	Tue, 27 May 2025 15:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fyWLGxtn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A2027AC22
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 15:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748360562; cv=none; b=g0EVhr1WPn0fRzddvNvr9iXNHneczCJn4kDeWpm+X94/e3nCTZMfftknp8qq7aqC/Oq0HE5SE5hGLfe2YHgy0xqcWGXHY+7BaoxUlK19aSL+Q7ui5oH4ZdXpzBgS6s/4Xx9IdwAq8HLBBma4JaVEUsUingB4TA0je5ibMuOhyYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748360562; c=relaxed/simple;
	bh=GSg/k2f/qylUwlRyZi86GomfDTD43zp+xmhJiVZfTog=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qNMB+kCex52Z4qIPeRkTmVIRdV0EPoFyTTpy55d22qvWK3slZpIdQy9z+4IvyUq79126AvOzyHBBTot/MWXU1zgEG07YGqInfCZP0Wr0+msmiD2o2xGua0Yk2dh++2moZ1of7l9hrhoSEAA3seUtRhsWxx8qh4ybJILGOGfS3LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fyWLGxtn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748360559;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GYjzf1at/wubZxWng6gwod5nngx9YBoemHxwSWxJDjU=;
	b=fyWLGxtnjYV7jXDdIRUyDYUmxGwMa7DwUuw3RsGHMtTDN3ZN4xqbFpYCVaVYGMs3NmQfVr
	VsTanfIASwcZGMOmkotRlHxm95esp5/txvQ95K0Bw481ohrWMH4sj57qnPEAJsWfgP7wIs
	zUQd1o+9Pt9doOJ8eKMVHi5SQd/+gYg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-225-QqV21LB1MMO67Ldjxyj9mg-1; Tue, 27 May 2025 11:42:37 -0400
X-MC-Unique: QqV21LB1MMO67Ldjxyj9mg-1
X-Mimecast-MFC-AGG-ID: QqV21LB1MMO67Ldjxyj9mg_1748360557
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6045875e52fso2105685a12.2
        for <kvm@vger.kernel.org>; Tue, 27 May 2025 08:42:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748360556; x=1748965356;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GYjzf1at/wubZxWng6gwod5nngx9YBoemHxwSWxJDjU=;
        b=UWE/8ncfscZ33iuVFSeya7cD6Wl93D7ql3fWbIlBS/brRJ/WrlBXk4KauofTVkfmJ2
         WZH58DhIBkm9FnGdDgTDlZBHs/7UGU6C++/0A32egJPvXZOM0eEaVT7rp9/3kMbwHIdf
         y3/vOSbC4Im63cVNzufzpmKdxnq5nF4EJg8nIxv8RoivdyF6Ll/1bXuL1vGVFlHxE11v
         XKkrYAtfYyUcNL8cPtw+upEHKLLOA3SKPLVYAeTe63wNQ+lxK88/1WjmGKZMCdfq97C1
         9GWkEmrQdGJAVO5BkmnCMo1zmtOhttriHx8Dgn05ghTEY5yT91O62o92IBBSe8dumI1S
         hPKA==
X-Forwarded-Encrypted: i=1; AJvYcCW75XNURr3buQVZQDbmfk3TdRylyYwk0RI1FiGaOLTlr4ob9rzyGRmI1Q4XsBtp8grDvaU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkrP0Pn78qHXBPraGiN9p+prwV2bHLDYdySmd2ZqTcBzVaM9Oj
	oWcCrx/auU2P7n+RTQkaq+BrDcKx3viWhjmJ5LzPuz7KVRagckL9bRaEfXbsxr9HFz11/Bl0PRW
	rM0TOzoqQ1YkFSKU72hYp21cVnlp/bKMk/9W59gvQjQlmVBazPYd58g==
X-Gm-Gg: ASbGncuYUvKCMATXRb/WpdtblalWKzZZt8XzhyD4SzJChvpnohOk7gakiMjv0PvYgtz
	IPb0ee+0NG+M3k/BK6mN26C468SrQLRDMwz+eTJKAcVmQWaYQdFBJfDkJj8NsTJZmKvmr8a6pxR
	vLoP351WynF1Yt6yY8wbiPb0gFs+mmKe1y5/VO5FcQ0aMTae2j1IZuapatpxWRcarxUDwu+TSey
	G2bzqiEhOnpzp/v/VNxbEYdeE7vVWup9JTYl5QTV4w5ayXqdeMqlriUgBT2iOJEhnt2bMNCYpmi
	W0DQ4h8mlBaqTw==
X-Received: by 2002:a05:6402:26c1:b0:601:d9f4:eac6 with SMTP id 4fb4d7f45d1cf-602da407b05mr9682387a12.21.1748360556435;
        Tue, 27 May 2025 08:42:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEegxgAG/pZUT5UobRfnKytKcy4UOj5G7CA/Z5+y7WjCTMgwf4Db1IDF2kQYfIv6uzrtVUh/A==
X-Received: by 2002:a05:6402:26c1:b0:601:d9f4:eac6 with SMTP id 4fb4d7f45d1cf-602da407b05mr9682369a12.21.1748360556004;
        Tue, 27 May 2025 08:42:36 -0700 (PDT)
Received: from [192.168.10.27] ([151.95.46.79])
        by smtp.googlemail.com with ESMTPSA id 4fb4d7f45d1cf-6045b95d2d1sm4498742a12.24.2025.05.27.08.42.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 May 2025 08:42:35 -0700 (PDT)
Message-ID: <1a5cfe89-f7e2-4e3a-862b-5d5f761e145d@redhat.com>
Date: Tue, 27 May 2025 17:42:34 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/6] target/i386: Update EPYC CPU models for Cache
 property, RAS, SVM feature and add EPYC-Turin CPU model
To: Babu Moger <babu.moger@amd.com>
Cc: zhao1.liu@intel.com, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 davydov-max@yandex-team.ru
References: <cover.1746734284.git.babu.moger@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <cover.1746734284.git.babu.moger@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/8/25 21:57, Babu Moger wrote:
> 
> Following changes are implemented in this series.
> 
> 1. Fixed the cache(L2,L3) property details in all the EPYC models.
> 2. Add RAS feature bits (SUCCOR, McaOverflowRecov) on all EPYC models
> 3. Add missing SVM feature bits required for nested guests on all EPYC models
> 4. Add the missing feature bit fs-gs-base-ns(WRMSR to {FS,GS,KERNEL_G}S_BASE is
>     non-serializing). This bit is added in EPYC-Genoa and EPYC-Turin models.
> 5. Add RAS, SVM, fs-gs-base-ns and perfmon-v2 on EPYC-Genoa and EPYC-Turin models.
> 6. Add support for EPYC-Turin.
>     (Add all the above feature bits and few additional bits movdiri, movdir64b,
>      avx512-vp2intersect, avx-vnni, prefetchi, sbpb, ibpb-brtype, srso-user-kernel-no).

Queued, thanks.

Paolo

> Link: https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/programmer-references/57238.zip
> Link: https://www.amd.com/content/dam/amd/en/documents/corporate/cr/speculative-return-stack-overflow-whitepaper.pdf
> ---
> v7: Rebased on top latest 57b6f8d07f14 (upstream/master) Merge tag 'pull-target-arm-20250506'
>      Added new feature bit PREFETCHI. KVM support for the bit is added recently.
>      https://github.com/kvm-x86/linux/commit/d88bb2ded2ef
>      Paolo, These patches have been pending for a while. Please consider merging when you get a chance.
> 
> v6: Initialized the boolean feature bits to true where applicable.
>      Added Reviewed-by tag from Zhao.
> 
> v5: Add EPYC-Turin CPU model
>      Dropped ERAPS and RAPSIZE bits from EPYC-Turin models as kernel support for
>      these bits are not done yet. Users can still use the options +eraps,+rapsize
>      to test these featers.
>      Add Reviewed-by tag from Maksim for the patches already reviewed.
> 
> v4: Some of the patches in v3 are already merged. Posting the rest of the patches.
>      Dropped EPYC-Turin model for now. Will post them later.
>      Added SVM feature bit as discussed in
>      https://lore.kernel.org/kvm/b4b7abae-669a-4a86-81d3-d1f677a82929@redhat.com/
>      Fixed the cache property details as discussed in
>      https://lore.kernel.org/kvm/20230504205313.225073-8-babu.moger@amd.com/
>      Thanks to Maksim and Paolo for their feedback.
> 
> v3: Added SBPB, IBPB_BRTYPE, SRSO_USER_KERNEL_NO, ERAPS and RAPSIZE bits
>      to EPYC-Turin.
>      Added new patch(1) to fix a minor typo.
> 
> v2: Fixed couple of typos.
>      Added Reviewed-by tag from Zhao.
>      Rebased on top of 6d00c6f98256 ("Merge tag 'for-upstream' of https://repo.or.cz/qemu/kevin into staging")
> 
> Previous revisions:
> v6: https://lore.kernel.org/kvm/cover.1740766026.git.babu.moger@amd.com/
> v5: https://lore.kernel.org/kvm/cover.1738869208.git.babu.moger@amd.com/
> v4: https://lore.kernel.org/kvm/cover.1731616198.git.babu.moger@amd.com/
> v3: https://lore.kernel.org/kvm/cover.1729807947.git.babu.moger@amd.com/
> v2: https://lore.kernel.org/kvm/cover.1723068946.git.babu.moger@amd.com/
> v1: https://lore.kernel.org/qemu-devel/cover.1718218999.git.babu.moger@amd.com/
> 
> Babu Moger (6):
>    target/i386: Update EPYC CPU model for Cache property, RAS, SVM
>      feature bits
>    target/i386: Update EPYC-Rome CPU model for Cache property, RAS, SVM
>      feature bits
>    target/i386: Update EPYC-Milan CPU model for Cache property, RAS, SVM
>      feature bits
>    target/i386: Add couple of feature bits in CPUID_Fn80000021_EAX
>    target/i386: Update EPYC-Genoa for Cache property, perfmon-v2, RAS and
>      SVM feature bits
>    target/i386: Add support for EPYC-Turin model
> 
>   target/i386/cpu.c | 439 +++++++++++++++++++++++++++++++++++++++++++++-
>   target/i386/cpu.h |   4 +
>   2 files changed, 441 insertions(+), 2 deletions(-)
> 


