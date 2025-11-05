Return-Path: <kvm+bounces-62109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 59ADAC37951
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 20:56:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A13164E5D0D
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 19:56:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03B503446CB;
	Wed,  5 Nov 2025 19:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dF03gt7m";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dCPUd4wU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F236342CB6
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 19:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762372603; cv=none; b=T06pZIfUDFSlQ/ezVNe50C1XnKC+TWhIQYKWS2qeTS1JUPlq+isubWbvOqsWcsza2oZI2B8oEgPpNofi7T4pzWfYTelB3YVztwfsJ933Juxtf7FsFkhqbM/FhHqRasm/4tVSI3xICyUVsixyUIncAmUl7uI2o8SMOwfLVEF9DXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762372603; c=relaxed/simple;
	bh=y0djx7SaSKxrg38g7Mq/6kY7uEuPs6Y4jirNJDxy4Uo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TuhRO6gqG1lqvJ/rIzuibHXMUrax6iiKKcDN2qYXMz2O7VR5K5RYxr4wx0naPpYw8+ntq1ciI8Ue0H++SdFxNmQCyGVsl4vYmFEv/s6CnRLF7dmYMtpbJKGPM1Zw1UFlWSAAYyGO/dQms3LJyceJi7ZVYKnGxwCmNMR9c3qlYe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dF03gt7m; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dCPUd4wU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762372600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RfRdq0AOLjAvRpFgewWvnXKqu09Gq6WPLf3shQQBn6o=;
	b=dF03gt7m4v2LFDVNmqva+6rkm0YhCFMPsx8wBni/J2D4U1RLdlMbX0NaRrTheAR+bgutxe
	+9nqWqBrNJ1kiXdQgeG6eWuhF91HF23ejjMU92gl0mfZw+WY21fiUgQBElhLBGssEzA6jQ
	D4o130VTH5JSUw32jVW2JPEkUpHiuRo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-8cIU4yjbMaWdb5EM-myrwg-1; Wed, 05 Nov 2025 14:56:39 -0500
X-MC-Unique: 8cIU4yjbMaWdb5EM-myrwg-1
X-Mimecast-MFC-AGG-ID: 8cIU4yjbMaWdb5EM-myrwg_1762372598
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47761eafd18so1024925e9.3
        for <kvm@vger.kernel.org>; Wed, 05 Nov 2025 11:56:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762372598; x=1762977398; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RfRdq0AOLjAvRpFgewWvnXKqu09Gq6WPLf3shQQBn6o=;
        b=dCPUd4wUDwoikIXTihkjC5+8ZLU9JgtloI7GLZ+q64xLT0biQ8j0HLtCqsfcgEdv2C
         Brg2q9FoCDZ75vOlnPaGiWxMrqroASjcmmEGay9Lgbzml7QJg5z9EsOvVLPzPb0/Zxcz
         csRp2rNYObE104mkvvIXsyGV695Rk7inc2VRtxADfH0wkaUJEPHutcSO+6hxqzjtA3po
         CbFi8+/1Z/F24+2Mu7wOuV0bZ5FWr2uMhZUm40z6JypB9rQbdXJQOOyBUatFq3DDJhHv
         0OPyqzoRFeq7Pu5eRWr8RZo7Zk2Jgxmpoaa2ArF1JEmYk3Ksq+3mAZuwchWByKmuJy82
         N+ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762372598; x=1762977398;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RfRdq0AOLjAvRpFgewWvnXKqu09Gq6WPLf3shQQBn6o=;
        b=ChPOqDKn1LgQ7IAOxuvXWSgmzxDdlyxXsi8+jHmPQOhp2DC4Sg7Ch0GoLy+CJC45HM
         fj5JhGovvYKw6YUGDRNyBRUAOQZ9kmIAU4SIXbGWKuXT1m9pfOoKvnx65Wmnfz7Gcocw
         eo7lOpc7U6xPuFypCLhJ7DLKbDWuIo88IZ1VCpVi3GtbXHdxObqisG7ggMRWusxbQaeP
         eMc1Q6/FKU6urfwccOC6+3MY9j2t4zB6wbiY0Rnw7ihAxA8D7Vw6imi+NjV9Mkof1jTN
         9E+Z+sFTxSuisk14dTJQYoOGJ5ec0xLL15HE/krp5Tn/bj5AInGO9s0Yoqm/gwS+l7ob
         eAAA==
X-Forwarded-Encrypted: i=1; AJvYcCWpE2az+JlLTe0TBaJ0jiyYUH+SXPj4rb5FB7aXuO/wiZthwDpE0e/G38h6YhdbnuiwriU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWMk09068rSs4mXtBLm52h6BUAClNblvCLgZ1nlkZMQa3B27oi
	T+AlFx9v0zO2sNatonwiMcUOV9msPIYhQ2/XPZc1CnswHdkMNMWMrRAY8y8wStMRTukn4r2FSG4
	akxO5RKxfG4LpkZwR9LZ8+Du61PJJm4ToRZQDcv6bjGsS0dpHgLLZ5g==
X-Gm-Gg: ASbGncvEkHxFzBABszpOGMzmqwy3Ogrn3t30nACR7KeQIfjL/4t1NwiO0YnA+nm0ABM
	pX3I1M8S9TyqSSM6gmerUXBdR2rhewIrZ28kHAumCMMg+Y9LN90nAGV0R/RxaONQwMd6p7FV9yI
	duoB5hbLxD6X+AeOVwU1HGh34NdUTm4Fw1ZoDXhhviPYCRMDzZ4+MHb7iMRCrF3qi/eulzg5pLL
	ZegsPgjHT+4+YOB47eRjX5CczG/Clj2tvxEAEldSs2LYq02JDcXeNDntNMBhE3nD5PljRNG0hq9
	JX07k+Q64vvysUXwMmxxZDnv5HKiWyuR232C4k3w2KA3mju2U8COvXSPDrpn071ngDRT5BJiktg
	EhpV+D6bTqrvZ8BpK0tfXOqt4ZECvUFlMR1RunrXdUDHVTcqATLS03Yt97IzBiH2qGPMWGNyo7P
	WBO9n+EFsVmdMdEVC5dO99Kw==
X-Received: by 2002:a05:600c:348f:b0:46f:b43a:aee1 with SMTP id 5b1f17b1804b1-4775ce2c7eemr29950125e9.38.1762372598044;
        Wed, 05 Nov 2025 11:56:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHK7yLH47QUN086LZNyuRAD2Zw/GPvRFlywAZeFx22RAaEduz3ojwl4v/Mo8ax5jk1OZayf5g==
X-Received: by 2002:a05:600c:348f:b0:46f:b43a:aee1 with SMTP id 5b1f17b1804b1-4775ce2c7eemr29949845e9.38.1762372597551;
        Wed, 05 Nov 2025 11:56:37 -0800 (PST)
Received: from ?IPV6:2003:d8:2f30:b00:cea9:dee:d607:41d? (p200300d82f300b00cea90deed607041d.dip0.t-ipconnect.de. [2003:d8:2f30:b00:cea9:dee:d607:41d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4775cdc33bdsm64219765e9.1.2025.11.05.11.56.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Nov 2025 11:56:36 -0800 (PST)
Message-ID: <c8f4e753-836d-4ca4-8a94-c54738b7db45@redhat.com>
Date: Wed, 5 Nov 2025 20:56:34 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/16] mm: introduce leaf entry type and use to simplify
 leaf entry logic
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Gregory Price <gourry@gourry.net>
Cc: Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
 SeongJae Park <sj@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Pedro Falcato <pfalcato@suse.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-arch@vger.kernel.org, damon@lists.linux.dev
References: <cover.1762171281.git.lorenzo.stoakes@oracle.com>
 <2c75a316f1b91a502fad718de9b1bb151aafe717.1762171281.git.lorenzo.stoakes@oracle.com>
 <aQugI-F_Jig41FR9@casper.infradead.org>
 <aQukruJP6CyG7UNx@gourry-fedora-PF4VCD3F>
 <373a0e43-c9bf-4b5b-8d39-4f71684ef883@lucifer.local>
From: David Hildenbrand <dhildenb@redhat.com>
Content-Language: en-US
In-Reply-To: <373a0e43-c9bf-4b5b-8d39-4f71684ef883@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.11.25 20:52, Lorenzo Stoakes wrote:
> On Wed, Nov 05, 2025 at 02:25:34PM -0500, Gregory Price wrote:
>> On Wed, Nov 05, 2025 at 07:06:11PM +0000, Matthew Wilcox wrote:
>>> On Mon, Nov 03, 2025 at 12:31:43PM +0000, Lorenzo Stoakes wrote:
>>>> The kernel maintains leaf page table entries which contain either:
>>>>
>>>> - Nothing ('none' entries)
>>>> - Present entries (that is stuff the hardware can navigate without fault)
>>>> - Everything else that will cause a fault which the kernel handles
>>>
>>> The problem is that we're already using 'pmd leaf entries' to mean "this
>>> is a pointer to a PMD entry rather than a table of PTEs".
>>
>> Having not looked at the implications of this for leafent_t prototypes
>> ...
>> Can't this be solved by just adding a leafent type "Pointer" which
>> implies there's exactly one leaf-ent type which won't cause faults?
>>
>> is_present() => (table_ptr || leafent_ptr)
>> else():      => !leafent_ptr
>>
>> if is_none()
>> 	do the none-thing
>> if is_present()
>> 	if is_leafent(ent)  (== is_leafent_ptr)
>> 		do the pointer thing
>> 	else
>> 		do the table thing
>> else()
>> 	type = leafent_type(ent)
>> 	switch(type)
>> 		do the software things
>> 		can't be a present entry (see above)
>>
>>
>> A leaf is a leaf :shrug:
>>
>> ~Gregory
> 
> I thought about doing this but it doesn't really work as the type is
> _abstracted_ from the architecture-specific value, _and_ we use what is
> currently the swp_type field to identify what this is.
> 
> So we would lose the architecture-specific information that any 'hardware leaf'
> entry would require and not be able to reliably identify it without losing bits.
> 
> Trying to preserve the value _and_ correctly identify it as a present entry
> would be difficult.
> 
> And I _really_ didn't want to go on a deep dive through all the architectures to
> see if we could encode it differently to allow for this.
> 
> Rather I think it's better to differentiate between s/w + h/w leaf entries.

(Being rather silent because I'm busy with all kinds of other stuff)

I agree :)

As Willy said, something that spells out "sw leaf" would be nice.

-- 
Cheers

David


