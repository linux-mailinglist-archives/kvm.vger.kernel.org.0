Return-Path: <kvm+bounces-48702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3877FAD15EB
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 01:42:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3422A3A448B
	for <lists+kvm@lfdr.de>; Sun,  8 Jun 2025 23:42:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D569265621;
	Sun,  8 Jun 2025 23:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XEAdgQ0Y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0A98BFF
	for <kvm@vger.kernel.org>; Sun,  8 Jun 2025 23:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749426165; cv=none; b=TFNlxXbKGFiTWT8m9MnCLswc8P5lB3xqL2R2KHGa/svVJlVflopIDzm5NdWYHZm5p8VmWSgm/p7/z89+TForPY4+dI4bEDbf/kgK6FBV/4LGg2Uz7cHh0a+BdogzsP5+62qGp+TapiwF4w8wt6Mv3ZJzThqOsnjGpc+M0B0uZC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749426165; c=relaxed/simple;
	bh=3BrPqick3GI480dewMt6lfWOE6CKi6PdWbeMGGqvCn8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z6N/0R5O9Gfo+RP5GY6sHa3u1HYGEwfnKvZjXhQ9XMsa7lZjEmy7Ydi4R/zH6N1hCv4KnZXGRIEamCmmyRXcV8ylcHJJrrjAzqCivbJOmpd1qcvhaSci6UjtjahMakvzgeHAqH4h8uXMDM1q0TgKXwVnPI2wa+NyEuzfZ2PqsPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XEAdgQ0Y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749426162;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BrhPYURkD84ucWukiI2OFvciF9PKhh9wNSV3UCxvffw=;
	b=XEAdgQ0Yd7sLbdcoPj59BFQOyjwPtdJibsFCaYF4X2/VGmGMc6AqEVme0+eVB6LxvFFndR
	jxROxGMxY1gn7o4zjJCZ7+nPBJYieHKJRZFswfPjRTRhoAuvhldeMiAic86pKWCd+2qEd0
	rHhipB4eUwTbha9bkR6N91pIAvGXiX8=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-2vC9Y-o6Mv-h_1-PQ1fEjw-1; Sun, 08 Jun 2025 19:42:41 -0400
X-MC-Unique: 2vC9Y-o6Mv-h_1-PQ1fEjw-1
X-Mimecast-MFC-AGG-ID: 2vC9Y-o6Mv-h_1-PQ1fEjw_1749426160
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-23536f7c2d7so58261975ad.2
        for <kvm@vger.kernel.org>; Sun, 08 Jun 2025 16:42:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749426160; x=1750030960;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BrhPYURkD84ucWukiI2OFvciF9PKhh9wNSV3UCxvffw=;
        b=KUlq5i/ArXf4gcZDLoFXEWPu5TxUxz8P4zIFbv50RFsjMl2/eQrONYj+14oZuy4pgI
         MaABeZCzFqTzTaM51+qpYbg/Yn0DETYioblBgOsPOIFsokp47k5B3WGZWVO7+SzXTYJZ
         8gprwPIgF8BXc9pNoeF7NTz9h0WflQhE+zhHy7UTE/X8bO9Y9JBYRS9AIxunII9mxPsS
         6cdGiY3R/9dKGinhF7wWGk+dRQ5m2CWRN3HfN9yQjraEEyo9gd572Z6gFJ05pCwu0mSx
         JLvNFXC+/OPuE560ME4luaGS2fnERDpxAxXwI3pmDIWj+zCoDYXIxLg5l207wTgqEtNM
         hP/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUyQ3q0+7kGDOYSRfNOytAFC2Zz5SC3rmqef4z1HhZzphkrpMVlpGslTQDdDN2MUwLUBbU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFpNL78QhEhbZVY/EPvKceujjTtzSokob4slCFId49a7snx9r5
	E4znDfXtrK8mIVXUFePhENRn57WEEFQ8xcuZzwd+FA6SL92A3IEEA3nPz4CsQhQ38+VQp2v6IpQ
	vf2ViF5J/ow3EnR2Wf97IGnAFChosz/bCBK7xx7idqPv6xOC4NmkJaw==
X-Gm-Gg: ASbGncudu4p+oO/5DccB+pm3LFQNEK90MgWen9Jjzysnt/6ll2GhBGzFBNAo9JCs/UB
	wCacdG8yPCuH9Klofn6f+Yz2bX2o3nG34qCjeunN3wGIUulokGtDsNmiprcTdYEOuchhLDieQDV
	bymx0vAzaS5U0LTqsIokoCO4Wis4NiUFZLJAhZLuMiks/WWpBTYMdKVgBjc6QRQ99IrpS4vu0RP
	R8aSdeSW6TgVhg3KuSy41D8OKpl50GKybk9dYqUiGlxKNQFBOUUGQFazWX483s6197BVhbRXX8F
	QGG1MGt0R3tQqAjZgl1mJnoZdRxlinu5RVt96yG7Qg7A27grnPoSU0+BV2SjJQ==
X-Received: by 2002:a17:902:d483:b0:235:e1d6:4e29 with SMTP id d9443c01a7336-23601dc0136mr171113795ad.36.1749426160466;
        Sun, 08 Jun 2025 16:42:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFhhqD14zLILdtjSL+nHgtl9T+hPRFKWMZ0ZPJay0gEN8OyStVlbzILHd0cwkG13OOqkgTWcw==
X-Received: by 2002:a17:902:d483:b0:235:e1d6:4e29 with SMTP id d9443c01a7336-23601dc0136mr171113545ad.36.1749426160106;
        Sun, 08 Jun 2025 16:42:40 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-236032fceb2sm43669945ad.96.2025.06.08.16.42.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jun 2025 16:42:39 -0700 (PDT)
Message-ID: <e37faba3-b0f6-4cb0-bafc-f99573fd4adc@redhat.com>
Date: Mon, 9 Jun 2025 09:42:17 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 08/18] KVM: guest_memfd: Allow host to map guest_memfd
 pages
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
References: <20250605153800.557144-1-tabba@google.com>
 <20250605153800.557144-9-tabba@google.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250605153800.557144-9-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/6/25 1:37 AM, Fuad Tabba wrote:
> This patch enables support for shared memory in guest_memfd, including
> mapping that memory from host userspace.
> 
> This functionality is gated by the KVM_GMEM_SHARED_MEM Kconfig option,
> and enabled for a given instance by the GUEST_MEMFD_FLAG_SUPPORT_SHARED
> flag at creation time.
> 
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   include/linux/kvm_host.h | 13 +++++++
>   include/uapi/linux/kvm.h |  1 +
>   virt/kvm/Kconfig         |  4 +++
>   virt/kvm/guest_memfd.c   | 76 ++++++++++++++++++++++++++++++++++++++++
>   4 files changed, 94 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


