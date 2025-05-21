Return-Path: <kvm+bounces-47232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 98336ABECE8
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 09:17:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B4CB4A64DE
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 07:17:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1AB723535F;
	Wed, 21 May 2025 07:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JQYQrOTc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EB922D9E0
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 07:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747811816; cv=none; b=OdSoQ7l0YYQWekLo4XO2EnPesYeZOCc2UBGKdAg7aysVWoMmViA+43JzKVMK1GPMKaOdKUH6QsRsmzIpBhwX8laNx0M+3Iygtwn9cigVTmTln2XG9zWaQCFZrSH4VVDuRWccf0Z+vtwq6u1oJi5ttjwIBp/WsIv9ddV6MpuuOGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747811816; c=relaxed/simple;
	bh=nlkbXinOjzB/xrsP6yQTWg5BI750WHLMRDlsM7d04x4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iffURwrvZRcixQqj839hBNp8FkjpL1rsZYIVN7FeR8ZAfzfj5WUJJdiCsYQ2lzN+rsrP3OD+OE4fW4g0ONEcVzdALVW8bcCC0NVOA7Huj5GiEup4Im71nasjQDhGp5ntdYUz43DiF47J5/FL7X8GAj809WVPzbCK1geeOfTdm50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JQYQrOTc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747811813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4+Ru9EDbsALsMtXdnHj90bVzgkjcy1FvneBRalBh/w8=;
	b=JQYQrOTcrUB2mchu+Bkv+ZQZON5HVc6A6PASTn/zvU1eWSd9eegoUOIBkzG7p2HXinSys8
	QK5yKRZS+Wu1QFIlnnG6o6LIB9TSj3yage3DYCAU/pzZtvAS8dOvDLH8dOW7yCajWHoNJz
	4Bo3KW6ckRRRhP77MF36rZqXPgRPD/w=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-DG_ZfHfOPKirRL-tZ2Xg_A-1; Wed, 21 May 2025 03:16:51 -0400
X-MC-Unique: DG_ZfHfOPKirRL-tZ2Xg_A-1
X-Mimecast-MFC-AGG-ID: DG_ZfHfOPKirRL-tZ2Xg_A_1747811811
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-231d4e36288so48574725ad.2
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 00:16:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747811811; x=1748416611;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4+Ru9EDbsALsMtXdnHj90bVzgkjcy1FvneBRalBh/w8=;
        b=rUCPYvE+62PFnWpeVVhRR2YI0aicty0+Rj5ZD98Pun2pCUfTl6uxnXv/KEkCQfC5RI
         i7CgGa55nHTerJ3N2IjoH+uaANZ7AWs7Be8iwLMBIKnK0CSOLcXUIAo5IzIUDc+cbPrw
         l1omoA1aFM6rxN3WOJZh147/9e4EYzKdvs8oOOvL8Kp9YS0ib1hy4eNlQcp936JHLYkj
         xnxgnLrLXMPP38aujOKvxfW2eKkbpqXz6fdyOsvwJFXhFDuURTYS/gM9PzjSWICv5Ppx
         a+ab5DoMMamcbcvemNbSamJHzdC+JTuMD4s9yoSQ8tsPZBI0F7TtUejGW4MSMOGrfu6K
         JveA==
X-Forwarded-Encrypted: i=1; AJvYcCXXj1BrkOzke9qZXf7Op4+8zV/g79nuiRzBa+RCh4jIZKClpnZUHROquxWtqh1n12CvTQQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJMcIXpLoFfG7b4NY/urq+Jh2Vhm7iMOwd+upN8G49/bgK/8+P
	AoehePzDJ1ETD5rFt22fsH9RjBuU9+8mgjmbq+L4CxPQSp8IHDeHbE/56k9daH7eAq+3l5LU+Ta
	AU3UuWAD3TkX1XcoTzliIo0Fl4wIq7Ns5bv+RCJnk8fh8vKlvQ3xocw==
X-Gm-Gg: ASbGnctbJJMPsHGTx5Sd/FOVqUA5NTZ7JFvv68CQH/oyac38gE5iWGWUoYSXsdjYPlX
	gyYi58Cjr+/1sktTvz6GmGRTRVWzzVdLFcmo8aerbO2//Md7y3akTKQsznUgoydZY8J7bDH/g6E
	y2rn34p39rpC+CkdBOJ2DJrVvTPCgfIzNgm/u0Sctw89oY8wo2FmBblfemqvoq4HzDfLAThqSEL
	FgT9r26e2pRnZezQUD1wMkAogKkNjxpIFe+6g5hjgIGqCtEzbMCFNNPVPPBh4mcKtIb+YJ4v3ZW
	n00h6MA3iqMV
X-Received: by 2002:a17:902:ea0a:b0:220:fe50:5b44 with SMTP id d9443c01a7336-231d45420a8mr274301055ad.31.1747811810766;
        Wed, 21 May 2025 00:16:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGKtOvYj5TPFsGR1ANsFXDB27zGV36X3ObZ2CL/NKN84gcl9M8LlCEvqKva7FWbmrONkck+0w==
X-Received: by 2002:a17:902:ea0a:b0:220:fe50:5b44 with SMTP id d9443c01a7336-231d45420a8mr274300545ad.31.1747811810347;
        Wed, 21 May 2025 00:16:50 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4e97db8sm87525345ad.110.2025.05.21.00.16.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 00:16:49 -0700 (PDT)
Message-ID: <db7aeedf-7230-42be-b82c-62524bae188c@redhat.com>
Date: Wed, 21 May 2025 17:16:29 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 05/17] KVM: Rename kvm_slot_can_be_private() to
 kvm_slot_has_gmem()
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250513163438.3942405-1-tabba@google.com>
 <20250513163438.3942405-6-tabba@google.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250513163438.3942405-6-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/25 2:34 AM, Fuad Tabba wrote:
> The function kvm_slot_can_be_private() is used to check whether a memory
> slot is backed by guest_memfd. Rename it to kvm_slot_has_gmem() to make
> that clearer and to decouple memory being private from guest_memfd.
> 
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c   | 4 ++--
>   arch/x86/kvm/svm/sev.c   | 4 ++--
>   include/linux/kvm_host.h | 2 +-
>   virt/kvm/guest_memfd.c   | 2 +-
>   4 files changed, 6 insertions(+), 6 deletions(-)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>


