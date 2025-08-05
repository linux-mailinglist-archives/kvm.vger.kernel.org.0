Return-Path: <kvm+bounces-53997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BF1CEB1B4CB
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 15:22:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB17C1882B27
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 13:22:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2F80274B32;
	Tue,  5 Aug 2025 13:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e/BfRAfm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7665F2749C4
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 13:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754400132; cv=none; b=q9S36ltKlMDTzBSS5PB5Rc0sn42MBvr2HYUxJxHOX3dudf7tE4ExsrQOxsPPdn6VhhB27iQ9OXXr2bidLMJ9NXGHAJfxjMEj5zLWnGw+akZMEH8+5WT1085/uzw8bcDv5EInSjcsag5hhicKaXAqeDCjE+iVz3ygM4FLhwZ1IHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754400132; c=relaxed/simple;
	bh=Byl/nL13FsRUyOv55gfHnHsItiTLelhTKmvqqbOAt0k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ddoTI2oIwteup7pLylBGrm0wyB0HzSK9CQ20HRZGL3DXyEoM96OYk5TKsOdgDC+5OXO+Gf/3JYwRhMsaz+tJrepNgMpaZDdcENmicWA2Gays42iHoyU4B1y49Bqv25nXza7uilg0KQvqJP8xEd67mOLx7lZ4/fzy8eqiW+aZ23g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e/BfRAfm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754400129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5fwb6/daib0qsKP6ENXvqmzAK5HWFVCh16mUj7WQsrM=;
	b=e/BfRAfmQurJjI0RSB2812i3v+Okpl4g0UlVUVQOArH/z63pznAZRpA9xvsmv3nHYJ0WPU
	7SWBUajSC7P4BryZfE0VOrPGJRwRv7rrn6NI2Giy5poEGGTT7p98Gb9YxAXVv3RMZI8XLY
	wh2rt+XIo8pbl0v4Gi1KACTjgl5qlO0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-343-WwZl38tTNLWYSLTI5gd7Zw-1; Tue, 05 Aug 2025 09:22:07 -0400
X-MC-Unique: WwZl38tTNLWYSLTI5gd7Zw-1
X-Mimecast-MFC-AGG-ID: WwZl38tTNLWYSLTI5gd7Zw_1754400127
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-459de8f00cfso6901165e9.2
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 06:22:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754400126; x=1755004926;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5fwb6/daib0qsKP6ENXvqmzAK5HWFVCh16mUj7WQsrM=;
        b=RidFWn84qjwYtImlrmL3c9yGgmNd7veycbO4IgD6ySRy/BmI/BBmkQuWj221CzZHkf
         ZUCy4ba3evxjl+ZTNiKaX2ydHb7Ir69nB2BPNF1V9KYaWyOi95QyFaMmA1ZjG3zQ3piI
         2brlCNYUA7KxzqlizYfWpLzlCsUgYWqQTsdmvt95JE9vsFtF6+dfgD6VQIN4fA7AqGat
         Iry6bjH6fV0rcVEcBwYu0vWft7jCW6V3vjpU6ZToyjw8f7uMGeplxlDWBztnEPkPtUmq
         W8Ie+CDSq9eXI/oTg02qxx/j//iYGYVd5tbJVDASQXZCAyRd8YbS5wNNHtQbH9Le9XW+
         VC/A==
X-Forwarded-Encrypted: i=1; AJvYcCWOPG5GloUIAnKcdc9r30wZ6ONp4c3fYMyUl6tSmyOp7acFuVpajy6Cz7W/xhmtfKRazyY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGEg3g4LFHpMWrQVMekOd20svuSu1Z/9jOm/hLgi3qzEPiAwUa
	jHQxNgOPLoyE6issGO01VUW4fn7vobpIQS6WZQeOJfZHQcm8A3SaMoZkvJ8kKSpogMAZH1/5yzN
	4h49L2HZfxqRMMX1NeMaODhiY2bQhYF1496OXXxi16tgNLEyVr7t/Hw==
X-Gm-Gg: ASbGncvJz/ePZqyGluNpcGo54crn8L0HA23kPjkC/RvpB2saLSjssPsKllKB7bUgKA4
	1JPNtO4LHTGoubrl3z7lItd8ZjF1C0GpT1hU8dYCyT+sysx5jEZX9d0RaA+ANnlNinHshikiFwg
	jM8FXJI9JCOKDiDg0ZVZLQIepb85yelSO3YeK4010/L84TwHDWBWU7/TdvT321pJ68Bu6pFbN5u
	G7QJ/fypoglmi9QD5Py0g7UKuOk/TRcSod46IQ8O9YQoJaWpwELVf+5mzgLUWsh3//+K9cSa4lO
	QMhG1TLU+wkOKksNcJEDoQkHOHYe6RvZlOSN/EXBj4WPS/ooprfSiPhsZIcag+sYr5VBpGM=
X-Received: by 2002:a05:600c:8b61:b0:459:dde3:1a27 with SMTP id 5b1f17b1804b1-459dde31ef4mr54719405e9.26.1754400126595;
        Tue, 05 Aug 2025 06:22:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQ5z71kBdTOm3vKI1raiUutHNjtrO4k9neXdCPoHWjzHt02qOZBq3U9ZmkSrWR5dIkmUgMig==
X-Received: by 2002:a05:600c:8b61:b0:459:dde3:1a27 with SMTP id 5b1f17b1804b1-459dde31ef4mr54719115e9.26.1754400126161;
        Tue, 05 Aug 2025 06:22:06 -0700 (PDT)
Received: from [192.168.3.141] (p57a1a26f.dip0.t-ipconnect.de. [87.161.162.111])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e075805csm44029665e9.4.2025.08.05.06.22.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 06:22:05 -0700 (PDT)
Message-ID: <c96a97bc-4638-4910-ba27-262fb6cedc96@redhat.com>
Date: Tue, 5 Aug 2025 15:22:04 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "lizhe.67@bytedance.com" <lizhe.67@bytedance.com>
References: <20250804162201.66d196ad.alex.williamson@redhat.com>
 <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
 <20250804185306.6b048e7c.alex.williamson@redhat.com>
 <0a2e8593-47c6-4a17-b7b0-d4cb718b8f88@redhat.com>
 <20250805114908.GE184255@nvidia.com>
 <9b447a66-7dcb-442b-9d45-f0b14688aa8c@redhat.com>
 <20250805123858.GJ184255@nvidia.com>
 <db30f547-ba98-490c-aaf7-6b141bb1b52a@redhat.com>
 <20250805125643.GK184255@nvidia.com>
 <a18a9b55-b3f0-466f-abc8-39b231c04bb1@redhat.com>
 <CAHk-=wiQ=9g=+A8LPWhPj9yRXFzf=tJKw1Cy-wpj1N9FKu-65w@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <CAHk-=wiQ=9g=+A8LPWhPj9yRXFzf=tJKw1Cy-wpj1N9FKu-65w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.08.25 15:15, Linus Torvalds wrote:
> On Tue, 5 Aug 2025 at 16:05, David Hildenbrand <david@redhat.com> wrote:
>>
>> So I don't like the idea of micro-optimizing num_pages_contiguous() by
>> adding weird tweaks to the core for that.
> 
> Seriously - take a look at that suggested sequence I posted, and tell
> me that it isn't *MORE* obvious than the horror that is nth_page().
> 
> Honestly, if anybody thinks nth_page() is obvious and good, I think
> they have some bad case of Stockholm syndrome.
> 
> This isn't about micro-optimizing. This is about not writing complete
> garbage code that makes no sense.
> 
> nth_page() is a disgusting thing that is designed to look up
> known-contiguous pages. That code mis-used it for *testing* for being
> contiguous. It may have _worked_, but it was the wrong thing to do.
> 
> nth_page() in general should just not exist. I don't actually believe
> there is any valid reason for it. I do not believe we should actually
> have valid consecutive allocations of pages across sections.

Oh, just to add to that, 1 GiB folios (hugetlb, dax) are the main reason 
why we use it in things like folio_page(), and also why folio_page_idx() 
is so horrible.

-- 
Cheers,

David / dhildenb


