Return-Path: <kvm+bounces-49863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76E45ADEA8A
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 13:43:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E27FB177F5F
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 11:43:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B972C2DBF53;
	Wed, 18 Jun 2025 11:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B5tyc3Ed"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F932D9EF1
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 11:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750246936; cv=none; b=olDdXbSYazjkAp/HLF8i8HoA9zX+R3c07svFt4KRW2N4zmC2fWgVZFSvGVUelLioJsPA2jL53eOBQKPVdVYTg2bXkwtDJk8c/UpSYeIxJGw4fcAHo85ZfKenKwCB3C9qdzHx0LlOf5crWJaCsD1fUrDMCghPFavc2Ql1HNLHUM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750246936; c=relaxed/simple;
	bh=E1giQX77ba02sWSwCkkARDMrzYpmUpAr3+wQ3d5rEew=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=iDExG5QCS9bJEQHgEYaJpTqr/5CXShOpBUszg1zrSTbP/9+nbBC/ub0CBsq2tfp5h5xSXCUCw9em/3G1dLF0gkstRDA2bUussbVFE/exETfQKfCqimbeat0Atpra7gueaclogZZal04WWprHEaEXP4tO4vZCwyuB5negv+0+8U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B5tyc3Ed; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750246933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HcMpr3Clw+S+n70QqzmCOKA4fXzf7c01Cd7kiaYINh4=;
	b=B5tyc3EdQgZ4IWskqOmrg+zuODAUt+xwPb6dei4VQo/xmm1TJ8g4L9XpCMS3rNp4IdGNaW
	kJ5qxpR+2C1nVT0Dn05BYLkd6u6LQaNEWN1PWFIEKIc7fz9w/mh3AMranGSjqeBlCtjh0/
	5Bbxet60oUjVTT0Zh1ySNDsp8KgeuoQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-424-RUq0vwGdPx6FlL_WJIzSnw-1; Wed, 18 Jun 2025 07:42:12 -0400
X-MC-Unique: RUq0vwGdPx6FlL_WJIzSnw-1
X-Mimecast-MFC-AGG-ID: RUq0vwGdPx6FlL_WJIzSnw_1750246931
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4f7ebfd00so3070508f8f.2
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:42:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750246931; x=1750851731;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HcMpr3Clw+S+n70QqzmCOKA4fXzf7c01Cd7kiaYINh4=;
        b=jUxTKW+gNUDlH1JGzEdqyHkABLPdv18fJxCHRN4Qn2sIyu1migzMmQu2gnHxzvzMEa
         IpUiHg+l5TausGt0iGoileFdl0OdUO53IJNxDtcYmAkqb0fAYXQ+e/TFZjWJQB54oz+Z
         979iJV4LT8KXhYlqkRCgjd+2KAiH3PMCUIhFwWvd8RjMzl60JdslPQudul17wU1Vj99Z
         U7PiMO91sm5kQKsmd/hgLyk64QAFIrT++E648lybGzAlIZLkwiEsrdU6IyLlIqVvormw
         uT55j9ygrdl8s4AdAlFjfzTRTb5RCNteEP50bDMdrmt04K2yfIDXXheIpDex2/xi2bpX
         dZWg==
X-Forwarded-Encrypted: i=1; AJvYcCWXTMyVeoDJaBB0nkxuHrOpj43p1d8ViA0+A/i2fs8nQnJiqI8SnTyHbXhg/dbGVWn+4TQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLytujmZzXhoRg5gmwdjYgDV3yH1rpz+gAeI/GRz8XgQCpQRI0
	fkhkUOc1ywx0YjQ4PCB07cASsZlxZp64N8J/O7WMgF3dUZXaAwd7xkN1j7DSAaTFiwD5MJjP7EM
	LE5qNVG9IDftAsf1A2IRs/Iyc3XDHbB3KW2Pmrls+BIQqAOVt53jHpQ==
X-Gm-Gg: ASbGncvfmmdaCcMuI+Nf5pGGvZGJZ+sWQmMo1C7jhR6I1PeuLhV7a6cxztiwGwomuoV
	7hClBAvVwfx1UF+1ScYBg1MaFexVjlDg+0QoNiYjaZgvsDMJdWg7sIba/0kE7zj4dUA5y8InP7S
	HNTg86ednlY8LHKGzQ49HG+Y1iriIVXyuzE2JPQwDmnJ2CylpGXiMMW8Od59tAkidf8WmQMwvTF
	ZIE5vr1SuK5joTtfrTbkrMEz+xYhkVEbP7tvaAHUDRlaRdoSuED5KZ4/S8hFFtrhvvWw/38yLEo
	Ox+M5IEmVAbmwVQHAZM393JVfvy2q3enm+L5FL+8yo/yqN6fZpiw97qc3bm7GUwjJ/XAXhicV+b
	fO+uTzH0paLLb5tXdXqLtSak9g6YaPwqJ/O0q24N0Q+CuSIE=
X-Received: by 2002:a05:6000:4387:b0:3a5:2d42:aa23 with SMTP id ffacd0b85a97d-3a5723720aamr11943772f8f.22.1750246931306;
        Wed, 18 Jun 2025 04:42:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJ0iaVW+p+ARhd57eIQcZrYtRK4jtysJExYXd7VW0dHvY8EIJAcZSkukTfU1LzsnuL7unx5Q==
X-Received: by 2002:a05:6000:4387:b0:3a5:2d42:aa23 with SMTP id ffacd0b85a97d-3a5723720aamr11943745f8f.22.1750246930779;
        Wed, 18 Jun 2025 04:42:10 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2d:2400:4052:3b5:fff9:4ed0? (p200300d82f2d2400405203b5fff94ed0.dip0.t-ipconnect.de. [2003:d8:2f2d:2400:4052:3b5:fff9:4ed0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568b1bc97sm16813645f8f.68.2025.06.18.04.42.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jun 2025 04:42:10 -0700 (PDT)
Message-ID: <a1d62bf1-59e5-4dd5-926a-d6cdddf3deb5@redhat.com>
Date: Wed, 18 Jun 2025 13:42:09 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] gup: introduce unpin_user_folio_dirty_locked()
From: David Hildenbrand <david@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, lizhe.67@bytedance.com
Cc: akpm@linux-foundation.org, alex.williamson@redhat.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 peterx@redhat.com
References: <20250617152210.GA1552699@ziepe.ca>
 <20250618062820.8477-1-lizhe.67@bytedance.com>
 <20250618113626.GK1376515@ziepe.ca>
 <9c31da33-8579-414a-9b2a-21d7d8049050@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <9c31da33-8579-414a-9b2a-21d7d8049050@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18.06.25 13:40, David Hildenbrand wrote:
> On 18.06.25 13:36, Jason Gunthorpe wrote:
>> On Wed, Jun 18, 2025 at 02:28:20PM +0800, lizhe.67@bytedance.com wrote:
>>> On Tue, 17 Jun 2025 12:22:10 -0300, jgg@ziepe.ca wrote:
>>>> +	while (npage) {
>>>> +		long nr_pages = 1;
>>>> +
>>>> +		if (!is_invalid_reserved_pfn(pfn)) {
>>>> +			struct page *page = pfn_to_page(pfn);
>>>> +			struct folio *folio = page_folio(page);
>>>> +			long folio_pages_num = folio_nr_pages(folio);
>>>> +
>>>> +			/*
>>>> +			 * For a folio, it represents a physically
>>>> +			 * contiguous set of bytes, and all of its pages
>>>> +			 * share the same invalid/reserved state.
>>>> +			 *
>>>> +			 * Here, our PFNs are contiguous. Therefore, if we
>>>> +			 * detect that the current PFN belongs to a large
>>>> +			 * folio, we can batch the operations for the next
>>>> +			 * nr_pages PFNs.
>>>> +			 */
>>>> +			if (folio_pages_num > 1)
>>>> +				nr_pages = min_t(long, npage,
>>>> +					folio_pages_num -
>>>> +					folio_page_idx(folio, page));
>>>> +
>>>> +			unpin_user_folio_dirty_locked(folio, nr_pages,
>>>> +					dma->prot & IOMMU_WRITE);
>>>
>>> Are you suggesting that we should directly call
>>> unpin_user_page_range_dirty_lock() here (patch 3/3) instead?
>>
>> I'm saying you should not have the word 'folio' inside the VFIO. You
>> accumulate a contiguous range of pfns, by only checking the pfn, and
>> then call
>>
>> unpin_user_page_range_dirty_lock(pfn_to_page(first_pfn)...);
>>
>> No need for any of this. vfio should never look at the struct page
>> except as the last moment to pass the range.
> 
> Hah, agreed, that's actually simpler and there is no need to factor
> anything out.

Ah, no, wait, the problem is that we don't know how many pages we can 
supply, because there might be is_invalid_reserved_pfn() in the range ...

-- 
Cheers,

David / dhildenb


