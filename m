Return-Path: <kvm+bounces-53146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B0D2B0E046
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 17:20:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B34FA7AC2B0
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 15:19:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A61F260590;
	Tue, 22 Jul 2025 15:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hoHEsi/6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF87425E47D
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 15:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753197632; cv=none; b=E2DDa80ApNTloiubQBi3LpEKj2cbcoPv5L26fkJMGCXSyv1w1D86b3VXc6a8xq5/X8wZ9/im7xvHDuqXivvlF1Ss3hjJD+kHHJrf4PPL1xIyJudRmzeMpv8FnnSWnV6K909wXastiZtyENqSa5jOk1ZrV+6duugPBq1jyX5uglU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753197632; c=relaxed/simple;
	bh=EgrrwcZ6j7CSJT5s0hlrma2bExgZWXc7DwZ6upbMXg0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IZWXzuWg09Cl9X7nS7uCoNrGRg/lBbOkdqvzUl6Wmr2tthtTBeyG79z/o60KNDlj7X7EJQuphKlSeum02+i8w+Cl0jQMngMp0/1vNET+7Ye29FL7HJr7OnUe2ewP9Zmg2rko94E1gEuMnD+C5jwKulmMoSaRV+uvX/XtJme2Q6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hoHEsi/6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753197630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UR686UB6W95T3RcYAhWHnco9tSypYtrsdOEb8UEkv7E=;
	b=hoHEsi/66pffmkvxXXf03JMlFY38CKwJH+nWsdaHsZWNrgXOMXuFMgjdSlDifZJs/7j6pQ
	ZZMdcQUEaqb8r2Z6+ON+UYRPNnsPDNMtENIiXul2zovCyhNxL+M77NyoU0yUVeKnmTbzoQ
	wU3v3WjPePjV/BdMjyHGKTUBM7BN6ek=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-513z2dkqNKu0WZyKV4L6Gg-1; Tue, 22 Jul 2025 11:20:28 -0400
X-MC-Unique: 513z2dkqNKu0WZyKV4L6Gg-1
X-Mimecast-MFC-AGG-ID: 513z2dkqNKu0WZyKV4L6Gg_1753197627
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-454dee17a91so48276255e9.3
        for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 08:20:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753197627; x=1753802427;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UR686UB6W95T3RcYAhWHnco9tSypYtrsdOEb8UEkv7E=;
        b=s7w2SWJHN93Lb2MuLUVZkEoOISqwbrzNmM6kukSb2FEozyBaAvjbgP+8pR5KXGnrYS
         8Sc4ef6LyDswvhgkMJg1dpZ4A6hV2RqI7OOIwADhF0dJgx3phcNdEayPf6viJan/zyG2
         wVm/Dq1UocbNS78s+UsrR5of2x0tOetA/B+GU/EJqlaELP1Cv6zZg6v78vr0STRq2n9i
         77y40jL28n/mZJNVVmJdt19sb58U4KRfh7c3JOlIB0gPvLiY9mChxV1YkBxIX15hK5vE
         UGxuDHHhXmOUp4Qkj/bj+kfOyFHFcUtoP665QByLtKcoKzLCFqjVkFdgkaNKdvi1XKJv
         TNUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOPHl94FK5j//taTv3PMObWGmQKqGcswS9jpiupDbXxTG20NHhI+3iCd9efVFuNEVWoQA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzW2AUe+gK3i2KfsitIqORinqWUyeZUO911IcP7eikp8h7y/BuM
	8vnjne2wiQJTIMAGyZgT5t579NwkxT1NwQsd65MGFsR63lOP3IAKjdXHQq9Ci3cxdJ0dDSex1cE
	+aZEWC5m60cSl/34/nr5M/XzeVfy08lI7QiDzZ3lXha/SB+Pkrokq1Q==
X-Gm-Gg: ASbGnctEVPeNyU5H3EhGlYTZwNhXGCGRtifC/6jA5wdNudw2Lh+GhM7wufw7+r8v1lR
	WqEIAmR9f0GVdTXGNeUmrblbrOq63Dq3DX+3+pUcHolzLG79xjJ610szjPGsw8nQCYEuKoEGiov
	wdWV20If7gDUkdlxEulaOj9Sskr/lgAOHTRC9ftQgS/3MmA6wa/WAtFPrQ/d37bTFMNi7vJ/J6A
	RczbZGex6FHhgifxcjQxUySqA527I/b8ASnfUvrdEkE3rS/A5i+i+IBsVv586k7LMjzeO+82Rqt
	1EdlKNLVFl8o6PU0wy+w8x9zPvIsFVaR1855D6gOssUxlSNyIqpHyt5G6WCJicV//sZ4pRO0+ef
	c8cNW1mp6dDBD8LaDyWCYHkKtFfNWpZ3sK6yA51v7Ztl4EqoWyTPzWiSkXI8c79rZfww=
X-Received: by 2002:a05:600c:4f4b:b0:450:d01f:de6f with SMTP id 5b1f17b1804b1-456340160d3mr221374985e9.15.1753197626712;
        Tue, 22 Jul 2025 08:20:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHa43nqfLMQERCC1j/wmVHQ7UtK8l0NZCMFbPH2YHsoDOoAl1UMnjReWSKUBgR3S4TG9WNPmw==
X-Received: by 2002:a05:600c:4f4b:b0:450:d01f:de6f with SMTP id 5b1f17b1804b1-456340160d3mr221373905e9.15.1753197625794;
        Tue, 22 Jul 2025 08:20:25 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:de00:1efe:3ea4:63ba:1713? (p200300d82f28de001efe3ea463ba1713.dip0.t-ipconnect.de. [2003:d8:2f28:de00:1efe:3ea4:63ba:1713])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4586144f80asm38163855e9.1.2025.07.22.08.20.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 08:20:25 -0700 (PDT)
Message-ID: <2dae19aa-7913-4350-b031-38d00a20057f@redhat.com>
Date: Tue, 22 Jul 2025 17:20:22 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V9 2/7] mm/filemap: Add NUMA mempolicy support to
 filemap_alloc_folio()
To: Shivank Garg <shivankg@amd.com>, seanjc@google.com, vbabka@suse.cz,
 willy@infradead.org, akpm@linux-foundation.org, shuah@kernel.org,
 pbonzini@redhat.com, brauner@kernel.org, viro@zeniv.linux.org.uk
Cc: ackerleytng@google.com, paul@paul-moore.com, jmorris@namei.org,
 serge@hallyn.com, pvorel@suse.cz, bfoster@redhat.com, tabba@google.com,
 vannapurve@google.com, chao.gao@intel.com, bharata@amd.com, nikunj@amd.com,
 michael.day@amd.com, shdhiman@amd.com, yan.y.zhao@intel.com,
 Neeraj.Upadhyay@amd.com, thomas.lendacky@amd.com, michael.roth@amd.com,
 aik@amd.com, jgg@nvidia.com, kalyazin@amazon.com, peterx@redhat.com,
 jack@suse.cz, rppt@kernel.org, hch@infradead.org, cgzones@googlemail.com,
 ira.weiny@intel.com, rientjes@google.com, roypat@amazon.co.uk,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 kent.overstreet@linux.dev, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 chao.p.peng@intel.com, amit@infradead.org, ddutile@redhat.com,
 dan.j.williams@intel.com, ashish.kalra@amd.com, gshan@redhat.com,
 jgowans@amazon.com, pankaj.gupta@amd.com, papaluri@amd.com,
 yuzhao@google.com, suzuki.poulose@arm.com, quic_eberman@quicinc.com,
 aneeshkumar.kizhakeveetil@arm.com, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-coco@lists.linux.dev
References: <20250713174339.13981-2-shivankg@amd.com>
 <20250713174339.13981-5-shivankg@amd.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250713174339.13981-5-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13.07.25 19:43, Shivank Garg wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Add a mempolicy parameter to filemap_alloc_folio() to enable NUMA-aware
> page cache allocations. This will be used by upcoming changes to
> support NUMA policies in guest-memfd, where guest_memory need to be
> allocated NUMA policy specified by VMM.
> 
> All existing users pass NULL maintaining current behavior.
> 
> Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


