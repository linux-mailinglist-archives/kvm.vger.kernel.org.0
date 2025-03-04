Return-Path: <kvm+bounces-40007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7739EA4D932
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 10:50:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A3EE3B460B
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 09:44:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B837F1FCFE5;
	Tue,  4 Mar 2025 09:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="biyDFNid"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701811F4CB0
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 09:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741081425; cv=none; b=QM8tkfNsa1GY2QXira7+0oMQg75fZf0PLyxhawRJMrZOcWcMGTpzBzJDVBScyT5X71P1nZEnUmWZ11ZCxI3A5iP+uIKyQqDBPJrr7wAdxcZqcn8HZtyIFQW3UG1+/AOt8l463MG6Cci0XvH/LrFHiQSOWjm0RQDp7C/dQnGE9Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741081425; c=relaxed/simple;
	bh=rXfaZT0b3I74f9Y/bkIZiNcCzuewnRMvpL2vIs0IFhI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bcv/BadFmRvRfS+iwj9/x7twHAtB22NIfzbvWWjs+it5tXAVfYZFNNJVlK9bSXyG1fpYzWlZVthPXaESwJokpqXkhxmu6qe47HyLpLIXT0sRowmRGzEUz0btyK2S2wMlaEjcisoNK/zbyuOdFUQz0UMvZzRXz5/dh3LRMxIyAhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=biyDFNid; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741081423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xcB5AlBL0CvxeH1tTmF1m4r2t4soM28ZFM3akt0yuwo=;
	b=biyDFNidFgzYzubvJnhAEQJoIdxdpM8EjOwxYR4KGbEaoHyZeYLMD5P64uUymyrNWLFfwo
	eDmkiOngD0t6k4XScPbMRVMRBPPgWoA+XkK2Lx/t8h1KN5rftyx+3fQa14fV4XDqDC6ivD
	HnKl8xx4FVdcCPjHILU5+4s4iFipX04=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-287-1qzN7ydiPUGK91CaQiHkpQ-1; Tue, 04 Mar 2025 04:43:32 -0500
X-MC-Unique: 1qzN7ydiPUGK91CaQiHkpQ-1
X-Mimecast-MFC-AGG-ID: 1qzN7ydiPUGK91CaQiHkpQ_1741081411
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43bcc04d2ebso3825815e9.1
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 01:43:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741081411; x=1741686211;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xcB5AlBL0CvxeH1tTmF1m4r2t4soM28ZFM3akt0yuwo=;
        b=XRRb6taYTVgsYroO/42UEps+/4ALLdBnJgSwlpJhQtY42e7AbUAZwBIjDC6PuLvlvs
         qCZSUTwqqwX4Tb579sB8rgk/VLxfWmqzKjfLYKZwq0oh04xR7Dqs27aQobqXVMODTKTh
         Kntr6/R02+e57Gg7I8grcS3ga9VMsSeG/ghcbntuRRrQRWn//cJ3N9bpI2GpOMH26+LX
         QSNRrbqXp1Eo5sigAHkVCtC/1czHzbc8t52jDfzVO6ShPUXW+zNsttzUXUUi2FKGI7CP
         ElQn0k8/DRZPx9p1dS23dAoBYoSIzPaidjVQknoc5ygdlUv/1ZoyjiQ/qUf2GmxLDIxc
         Nu6Q==
X-Gm-Message-State: AOJu0Yw9s0tvziGuEdt8VpO3x9DpIeneN0UgQoyeVYGuBee6xykf2Iwk
	Zr+Hs1INPOcvopRa0udTbboSZemyLWS0yPgFzvb18w/FloFWn8tgQY3I8IEqIZxeBQzMgQXgPEH
	nHHdcfuo8WbHIMLSIiOUmPS+Gg81hpdaBy5q2GeaauZf9ztJLcQ==
X-Gm-Gg: ASbGncuoPV3xy6PvKR+enDAP7hEXy2Esms7m0holz5g3PLHunTWTIcaq9rCDd87t7nN
	oPzoGTykVxC0lHI5JtyhbEdiWIcZR7f4Qj0yBl8WR8Jcsvudnl7QXNy1qaMxhkzUA+4R9o1AeO5
	uR5Oz43SfHcePX8i5TfAb/hxAP8sDrxPWiyisty8lHOcPUL/g37/+CRkdnTzE+PzWXuUpftPdSS
	zg+b3ic/h+KgQXofuGM/QuCstMxmOXDD6Yi4eN8Tml5tdi5g67/GAX6C1/XMRmYwfu990ePTt+u
	ftPB4eqr/lTp1S1TPhd/Ij1sKzo0MrblkrX/LYSh1QaDMKLRhxYI92lOXTvKbu4Cfc0qbd2tL8J
	MgRLgjvSx/s3QxI1o/lSkIDq0lrcmQgzXIEyoGGToZqM=
X-Received: by 2002:a05:600c:3b27:b0:43b:cf12:2ca1 with SMTP id 5b1f17b1804b1-43bcf122eacmr2631775e9.10.1741081410535;
        Tue, 04 Mar 2025 01:43:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEf07g49YF7edwBwnu5q9VN9CFepKmjU92h615Ki4i7JutZ6qqjb8AYAgkEbdipqsP1no48+Q==
X-Received: by 2002:a05:600c:3b27:b0:43b:cf12:2ca1 with SMTP id 5b1f17b1804b1-43bcf122eacmr2631365e9.10.1741081410167;
        Tue, 04 Mar 2025 01:43:30 -0800 (PST)
Received: from ?IPV6:2003:cb:c736:1000:9e30:2a8a:cd3d:419c? (p200300cbc73610009e302a8acd3d419c.dip0.t-ipconnect.de. [2003:cb:c736:1000:9e30:2a8a:cd3d:419c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43b7370372dsm187477415e9.11.2025.03.04.01.43.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 01:43:29 -0800 (PST)
Message-ID: <fee6d061-4a04-41ba-ae59-a24a2439c575@redhat.com>
Date: Tue, 4 Mar 2025 10:43:27 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/9] mm: Consolidate freeing of typed folios on final
 folio_put()
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, suzuki.poulose@arm.com, steven.price@arm.com,
 quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com
References: <20250303171013.3548775-1-tabba@google.com>
 <20250303171013.3548775-2-tabba@google.com>
 <re7ecgfu4x4arh47tjojse33qvc2dt2qrjznemphdwphe2rmzh@2vbm6zto3plc>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <re7ecgfu4x4arh47tjojse33qvc2dt2qrjznemphdwphe2rmzh@2vbm6zto3plc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.03.25 09:45, Kirill A. Shutemov wrote:
> On Mon, Mar 03, 2025 at 05:10:05PM +0000, Fuad Tabba wrote:
>> +static inline int page_get_type(const struct page *page)
>> +{
>> +	return page->page_type >> 24;
> 
> This magic number in page_type code asks for a #define.

As Willy is about to rewrite most of that either way (once the page type 
is stored elsewhere), I'm not sure if that define is really valuable at 
this point.

-- 
Cheers,

David / dhildenb


