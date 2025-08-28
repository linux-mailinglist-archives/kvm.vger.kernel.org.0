Return-Path: <kvm+bounces-56072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4791AB39912
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 12:06:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 064273659D5
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 10:06:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26BFC308F12;
	Thu, 28 Aug 2025 10:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bdu/+Evn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00803081C5
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 10:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756375583; cv=none; b=WULNofpGmFRMoq2eNxhhVFKLYSiPCSg2b32YoqkdfazCUoS4E+1k/02K2sdQ68z0vH8voCEx5fgC9NAnaqjxiwSn281YoGh8e6JGVM9aA02qL0POHQjTvJh6xPmSfI3pNyoYhYTbLpOtfD4jC2JzZcwvOR8fRXX65iH/NMDNJwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756375583; c=relaxed/simple;
	bh=ibgMcx0t2DMAR/JWdWYa3j0j+waNK81T6Ne/9aFD2pI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BxmIsCMnSe8BtzHhZeepWfEVx1L6n4mroUXgPvl2qNarPxLeHzXBU6ue1a9RJwbXdfetUjnZT5rRy7TU2S4iWsNId5QOeVjuhrCAJ74afFwistZ8FBu77ujR+JCIb+EgMekUOE5K3/JwAX9/HZVixww7ouOoY8z4B+1pe8imdtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bdu/+Evn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756375580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AIuF++MW+9cppH2LcogxBtVCMHjKY7lH5B9a+qhZ5nk=;
	b=bdu/+EvndH9UhyH0ZtPZs5gvfrDagRlK7thkh+a8MgwcZppz6adUqXtsr+qFWlkLn4jvMU
	EgIidaV4acS53iwtM/B3xPFcDBkU5MLOwg+h7+ghla/2hiMNZlD36tgYRMbIbryjMvFOUQ
	6e8LfP+6H+j7rqCWUMxQ7bYxZc8Fvp4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-332-l3xxpmuYMNiaoZBQ2pHyzQ-1; Thu, 28 Aug 2025 06:06:18 -0400
X-MC-Unique: l3xxpmuYMNiaoZBQ2pHyzQ-1
X-Mimecast-MFC-AGG-ID: l3xxpmuYMNiaoZBQ2pHyzQ_1756375578
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3c79f0a5ff1so310872f8f.1
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 03:06:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756375577; x=1756980377;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AIuF++MW+9cppH2LcogxBtVCMHjKY7lH5B9a+qhZ5nk=;
        b=S0Lx7hm8jg5KS51r/TrgXaDgNxA5a5wVLPlcVx0ncrWGQdacR/Y+6jwfewyVyyUV18
         F40t/90O0W2btX5cqhUAMPQROIYV8/Pou0BxBKAHRcYkQ6wnod4ft2GW39ds9rkbzA65
         0cfOtfc1fdtnDSNQk9UW6s6i/QrttQMOgz3OnkXGXM5T6hOl9/m3NbuulmCsn3dEApB3
         0y+8DaoBj5eREH8BzSxBCh3ezYbvd2pBwwe00Vp7GdDZnBzuJyzdSGf7Q3dsI5doALWZ
         dfZJQarHV+xNgzU/dWZHtbmvToyz0yq6PcFAQM+tZe5cPpaw91+E6Cuh/lBKPpY58ZFO
         9RLw==
X-Forwarded-Encrypted: i=1; AJvYcCV2wwkJiihRlFQzJhABZ37vvdT/6Tzro7oZaEJzIVpl/A+a6c5YMqdMwt+02ymhi8izV4I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKnwOLc5Klq+AyA5yiJKcfFCcDh3yinKen29Pwgz2budfStRg4
	UegSoOXP4kt0R/FDS07X0Z2hwXW7BW/lM8HBfP9OnMurUXt2GfFXsxHd5SdhpxE9IUxy6SUsFBZ
	nN+GaFkpScxwQj356zRdAT5xbDq2orQbaVqa1jlwDjFOU9a0am/08dA==
X-Gm-Gg: ASbGnctSZSB1u3p2hTy7dqYMx9zgk1XkaCyY5iJoqYnV4U1Pys8S0Zbc4eqyF57U30Z
	y18LdeXsOCG9adKmQ3rDA0WBC36qSCrTmoyfUDBwLJNY1DZ8sCcZXTSVwyWbFF9KdXbUJaFidnc
	HedqTJ12r7D2O8GI7cx+F9mbX9FENA021pF7S5UfYT++6BmIjQuq7FRk7lSfFrFZldunvQJuCAs
	isaZ184Z2cW53Ti4iRNqfuY2m9OpFUm2TlQwUCO715watEEryIa54/WuvWckUDWcc/lBJv2ACdE
	MIBmdl+tQ7HeX+DfIjqiL06Xc87LpJ9HPbqSKBO15B+Gf6yVhiy05vdOmmnr8oqQJ4dh2lfnD20
	zzEl5pzE6Hs7KbxB83bxCTKHTDnFG6yxRF+/eFJ9zg+YwZe6NhvPxRPaamkXtD0g0CwQ=
X-Received: by 2002:a5d:64e1:0:b0:3b6:436:b8ea with SMTP id ffacd0b85a97d-3c5da83c601mr15705098f8f.6.1756375577380;
        Thu, 28 Aug 2025 03:06:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHv6FDhe/e4+uPIRUaF8D2ckX5J+70BvRLKIj3J1sQm8lva6qxwVAKdzmfSmO9HiwptWSyrXw==
X-Received: by 2002:a5d:64e1:0:b0:3b6:436:b8ea with SMTP id ffacd0b85a97d-3c5da83c601mr15705026f8f.6.1756375576743;
        Thu, 28 Aug 2025 03:06:16 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c70e4b9f8dsm26199961f8f.9.2025.08.28.03.06.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 03:06:15 -0700 (PDT)
Message-ID: <4db9239a-efe3-43b2-b7b4-af497eb9ee28@redhat.com>
Date: Thu, 28 Aug 2025 12:06:12 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvm-next V11 4/7] KVM: guest_memfd: Use guest mem inodes
 instead of anonymous inodes
To: Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>,
 willy@infradead.org, akpm@linux-foundation.org, pbonzini@redhat.com,
 shuah@kernel.org, seanjc@google.com, vbabka@suse.cz
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, dsterba@suse.com,
 xiang@kernel.org, chao@kernel.org, jaegeuk@kernel.org, clm@fb.com,
 josef@toxicpanda.com, kent.overstreet@linux.dev, zbestahu@gmail.com,
 jefflexu@linux.alibaba.com, dhavale@google.com, lihongbo22@huawei.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 tabba@google.com, paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 pvorel@suse.cz, bfoster@redhat.com, vannapurve@google.com,
 chao.gao@intel.com, bharata@amd.com, nikunj@amd.com, michael.day@amd.com,
 shdhiman@amd.com, yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com,
 thomas.lendacky@amd.com, michael.roth@amd.com, aik@amd.com, jgg@nvidia.com,
 kalyazin@amazon.com, peterx@redhat.com, jack@suse.cz, hch@infradead.org,
 cgzones@googlemail.com, ira.weiny@intel.com, rientjes@google.com,
 roypat@amazon.co.uk, chao.p.peng@intel.com, amit@infradead.org,
 ddutile@redhat.com, dan.j.williams@intel.com, ashish.kalra@amd.com,
 gshan@redhat.com, jgowans@amazon.com, pankaj.gupta@amd.com,
 papaluri@amd.com, yuzhao@google.com, suzuki.poulose@arm.com,
 quic_eberman@quicinc.com, linux-bcachefs@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-coco@lists.linux.dev
References: <20250827175247.83322-2-shivankg@amd.com>
 <20250827175247.83322-7-shivankg@amd.com> <diqztt1sbd2v.fsf@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <diqztt1sbd2v.fsf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28.08.25 00:43, Ackerley Tng wrote:
> Shivank Garg <shivankg@amd.com> writes:
> 
>>
>> [...snip...]
>>
> 
> I meant to send this to you before this version went out but you were
> too quick!
> 
> Here's a new version, Fuad and I reviewed this again internally. The
> changes are:
> 
> + Sort linux/pseudo_fs.h after linux/pagemap.h (alphabetical)
> + Don't set MNT_NOEXEC on the mount, since SB_I_NOEXEC was already set
>    on the superblock
> + Rename kvm_gmem_inode_make_secure_inode() to kvm_gmem_inode_create()
>      + Emphasizes that there is a creation in this function
>      + Remove "secure" from the function name to remove confusion that
>        there may be a "non-secure" version
> + In kvm_gmem_inode_create_getfile()'s error path, return ERR_PTR(err)
>    directly instead of having a goto
> 
> 
>  From ada9814b216eac129ed44dffd3acf76fce2cc08a Mon Sep 17 00:00:00 2001
> From: Ackerley Tng <ackerleytng@google.com>
> Date: Sun, 13 Jul 2025 17:43:35 +0000
> Subject: [PATCH] KVM: guest_memfd: Use guest mem inodes instead of anonymous
>   inodes
> 
> guest_memfd's inode represents memory the guest_memfd is
> providing. guest_memfd's file represents a struct kvm's view of that
> memory.
> 
> Using a custom inode allows customization of the inode teardown
> process via callbacks. For example, ->evict_inode() allows
> customization of the truncation process on file close, and
> ->destroy_inode() and ->free_inode() allow customization of the inode
> freeing process.
> 
> Customizing the truncation process allows flexibility in management of
> guest_memfd memory and customization of the inode freeing process
> allows proper cleanup of memory metadata stored on the inode.
> 
> Memory metadata is more appropriately stored on the inode (as opposed
> to the file), since the metadata is for the memory and is not unique
> to a specific binding and struct kvm.
> 
> Co-developed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


