Return-Path: <kvm+bounces-49303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 13E23AD7935
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 19:39:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 937E33A25D6
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 17:38:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 191C529C33C;
	Thu, 12 Jun 2025 17:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ohnz0bHb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31E24C85
	for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 17:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749749949; cv=none; b=sfutxGGobz3ZTn+I+340LdZ0CaMIEBcYWGnh61Jw6NutBW7rwJbopfNmvmyxJO/Zqz0oLfvEEAwOqB/QdZYqH7fQL1OlIzzRGNcL63dw+/LN9+3HnRM6s2RM4azSDRXV4uVNxyU1YpxXkhaIJS5ICC9C8sjEJhiUY5GOil8T5ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749749949; c=relaxed/simple;
	bh=htmKjBw3yxstB41esrtvXr81VHNm7ow+PpovEBzF02U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VXagdvu92sOK08FZcPdhMdVo+/n1F9Ky3LhP8aBIMkMEuf9tb4WmBOP2MB22Q/wgCCoKNw8foknRgJs3sJuvtZOYyTGlOcacdWYdXzFKlPBFBMXCXKwZx9vLVzx2BWbyhCflFBFuu7HwdHJ/ukXVu3grDp7MTS+NCdwolxzENog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ohnz0bHb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749749946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8jkr1vunW5l4QoCKJxi6IrvRVyLhU3+PFJ//nLy1Cps=;
	b=Ohnz0bHbGPeVGga1Xj05V+1oulMIL2BGXlf0046EyKS2MyBsSm+GwSTbLmwtw9WHelgn5W
	POVR785IG5eNDrNiQxdGs6dWmC3ghZEVR1gliacAQAmipMxei2UgzobhoJ7uJ7JslasWFL
	QwLzAVGFF+SiWqpGzDLVWG5W/cDUhsw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-xgDAE9eYMUqZjo4odB1_-g-1; Thu, 12 Jun 2025 13:39:05 -0400
X-MC-Unique: xgDAE9eYMUqZjo4odB1_-g-1
X-Mimecast-MFC-AGG-ID: xgDAE9eYMUqZjo4odB1_-g_1749749944
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-450de98b28eso10984795e9.0
        for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 10:39:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749749944; x=1750354744;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8jkr1vunW5l4QoCKJxi6IrvRVyLhU3+PFJ//nLy1Cps=;
        b=WZTNY9IL215uniHxcqw7ltD4iagmYy2upe7ld+72sOAYihx8RKP+nc5ePaohcFFZgM
         z7ye2ddDOi7zKKEs4OEgdy2FPuBzOQtBNoNZLJQmBJuRziwfA0no/wpKWy7r2K8JWM/H
         zejGzXAKLotzgYHFRDnXXDBNq/CTosxGpfKlOhobsNIXoWKNQsDQTM83Zh1f3Gw8J9G1
         VeMkmrBtYSqGaRzCTJjktZre04aGslyMsec1MpBj3aYHp6cRZ6FaAJxVzfzKAgRXZg2b
         TywAYUoUTvJGs+e+C2OrgKjliwCVvis6sxnQPSOMnYcSvG45K1GUDz/CmToo4cTdTsbw
         HL/A==
X-Forwarded-Encrypted: i=1; AJvYcCU/sr7VLYcSZacBlQ+np80MBZkDhVNaSR9lfbixVab+Vwb73Rs9Nymc8Xd9PYastdmSGoY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWxmg9+11LDKmHqvjNoIetk6KTc0N8f1mqf+emlcXSXFFrbv+f
	UjqRWJuP1bUBJBb5X/6flvzH76SY+LmMPUaEXPIarMtIpqRchniUNYFwdmDBIVR85fENjofn95b
	6M2xTrsKr0xx7eCrEE0pqZ0cM7VTuuEgqScrETqeZk9q/cskloxDe5Q==
X-Gm-Gg: ASbGncujSMar1swpkkzayjLfPYv6OtZpR79ylHDNAU2Lbs6Zzm9V3803lerDDzHuIh2
	zBMx4ZdlSoDxpqnJsQc+dAz/9IX43COrqMo21b2Us5OoHWnR4rw+Zrtu+DMa//RbviHN/UfJPrd
	ExGemzfS5qDQJLnqxvz65M2J1YWsAaWEbGO5J9J0h1/T+0GWv6ju+l2gLoQk7pyML5OBAhYAtit
	hN9xlJajjWJeKeuLUzoN59I1CXLgMquvbtAMVu7goX8E8C9B2fQ8d7R56vThASMnK3+FFERGZna
	lvjpZHORcLoS52q8GE9wCaecscCjkgNuGSlWI2E+4CxRnpMh6n+hTpCFdn0tk30jv1XoGg32RWd
	5xiUmOCm87zamjMua7whrbi/eRz1++uxL3hjZoOPQMRzTz9No0A==
X-Received: by 2002:a05:6000:22c4:b0:3a4:f722:a46b with SMTP id ffacd0b85a97d-3a5607fa691mr3605459f8f.15.1749749944082;
        Thu, 12 Jun 2025 10:39:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGRLoaK04RK2BYkhZT4etRYoZyIEx1qjVBjHJm95jmASsKkTB71kuklaJTyeOnu9kKWd5q5Zw==
X-Received: by 2002:a05:6000:22c4:b0:3a4:f722:a46b with SMTP id ffacd0b85a97d-3a5607fa691mr3605415f8f.15.1749749943564;
        Thu, 12 Jun 2025 10:39:03 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2c:1e00:1e1e:7a32:e798:6457? (p200300d82f2c1e001e1e7a32e7986457.dip0.t-ipconnect.de. [2003:d8:2f2c:1e00:1e1e:7a32:e798:6457])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532e2449f1sm27719925e9.23.2025.06.12.10.38.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jun 2025 10:39:01 -0700 (PDT)
Message-ID: <80e062dd-2445-45a6-ba4a-8f5fe3286909@redhat.com>
Date: Thu, 12 Jun 2025 19:38:57 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 00/18] KVM: Mapping guest_memfd backed memory at the
 host for software protected VMs
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250611133330.1514028-1-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250611133330.1514028-1-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11.06.25 15:33, Fuad Tabba wrote:
> Main changes since v11 [1]:
> - Addressed various points of feedback from the last revision.
> - Rebased on Linux 6.16-rc1.

Nit: In case you have to resend, it might be worth changing the subject 
s/software protected/non-CoCo/ like you did in patch #12.

-- 
Cheers,

David / dhildenb


