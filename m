Return-Path: <kvm+bounces-48708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1879DAD1647
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 02:30:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B88AC168A9C
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 00:30:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 425101E521;
	Mon,  9 Jun 2025 00:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ElSWk85n"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001ABF510
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 00:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749428996; cv=none; b=DCAtqaSPqUTym16B2r98UoPtdvcZhNkhU0nfH1BZ8z87mdBDfIX687fx/fqU8pLPws+Ld4sIk5B3ySJtNvVFrkKgzs2fBTd/lRk8NsF1t2ZplJWflQr93Z26Lk9d9/dtDeoHyYwY3oar3gd1gWZCq8/33FZ/5TwqYTAhRYprMdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749428996; c=relaxed/simple;
	bh=DndXz279didVTDDBPj10bwY/XQ3srYBXtm7PwGKhlsk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dV8PS+RijP8oQYDvxgwF3by9176sVOBLDX/pUdC40N+RVGgy/D8fNwpDrvwfr21Df/CZr3GuzoFOA2YCMmcWxPdmPZs7/zRlW3ucbAhniYMVcuxuLgYc8gH/DLtcJPxheD20wYULkuKoATVWL6ICQEBjy7XoMP2UnFboHfdQdIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ElSWk85n; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749428993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zWLcc9JilgS7Cncp/Oc4IwhgNWLN/WG8IqO7PXvDI+0=;
	b=ElSWk85nk/FJZuR+KLJOs2QAtNLhL0/4dBWM3l8ZDoeDrBihzZQp59jacLGyT7JcoV5eWv
	VXVsqJyzQylNx2iBbdtuCKHyPgrm88ge1R5kVJkamIAcGf+TXbKy9jsJWxBE9NoxHjlOar
	1znvCUASfzQgiGfE2VT2mH6dyrhI0Zo=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-5Z8SpwiEMHOrGE4zT7Jolg-1; Sun, 08 Jun 2025 20:29:52 -0400
X-MC-Unique: 5Z8SpwiEMHOrGE4zT7Jolg-1
X-Mimecast-MFC-AGG-ID: 5Z8SpwiEMHOrGE4zT7Jolg_1749428992
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b26e73d375aso4191770a12.2
        for <kvm@vger.kernel.org>; Sun, 08 Jun 2025 17:29:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749428991; x=1750033791;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zWLcc9JilgS7Cncp/Oc4IwhgNWLN/WG8IqO7PXvDI+0=;
        b=lwFXdd/3xKQ3EQO8WQQwO66oOmKrNoamQyIp4wLw11oIPvScZUpf2DSKwSQDbMi7NF
         HVoBku6spWjOuXXARuanwG7GKnLYz0yiKCUtMs0Rk6Ytx9LERMJSG041pnxOwKmPjhRC
         e0I+7COTBdwE0CfUGD6h9iYQxNeZ2Pcij00xwUNajOB4qn3iMaGlwmcpc9oz4idxvw+Q
         IU9VWWZubb++U0XXl3dQebipNhiuI6BPHmKaGu3+5P3yk9xviKntYOPuBBsaV5G98TgJ
         tR+3eVKEUWPdgDFKVpZFD7spC66jwbaAA4LQTXrbLy9AHt0gwH5DbbCG0KJ85Dv5PfP1
         FzJA==
X-Forwarded-Encrypted: i=1; AJvYcCX0Ri1feKm7Cz8NHHFPpoKmzRqCJ9RaWTxfn6t+CLnlKRiPZ3upde9RUyAP/vV59A+y3RE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1DkJ+DV3GpTaZ1VI5bsbJ5rwcpRwnxirdVkD+7JpkulLqG1/9
	VtQZaf8kFRn4bs2MYodOHntePQlZnw5QlXGCsUNC/JRiD7DFuMmuwnXhM3lYov4AJC/g64PY53Z
	0dpi7w5TMDNsDS3C4CuATG871FOeMN02vMlzFXgs5uHc2eVepdEQFcg==
X-Gm-Gg: ASbGncsBD5dl5Hbs1w9f67zmhOg+P2r/Z2Uml6NM+Nj6rCMpYi/IPKaFgMdolP6mwEC
	xhsHQCO4gMlA/vG6DQHNQCbeCr/sZKQEQct/yF03kfSeqTuUlblDqHSdh91x4t3Qg+JJlsgueGx
	SjMdpXLYPLHxyA+uRG8jH1qPBZfhve6IM+Kfn1bhJXoOQjxP/kTxIgU6zYc0jg/zVlvEPuPqOcC
	edsisoNZGhHgTEj662eFvAetXJ2o0nFaJSExha5q7RzXjvOBgy2lSivhzTI7cX1w9J7+V0gUv6k
	uHGFbI+haczmEUFjduolS3QnvDndwONeVvN/7vc4KuLg/vxRFlmCpVMMs6EH4Q==
X-Received: by 2002:a05:6a20:1595:b0:210:4397:82a5 with SMTP id adf61e73a8af0-21ee68c8a34mr16623977637.21.1749428991497;
        Sun, 08 Jun 2025 17:29:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFINCLkeeM7uiQsUy2zEm0wbd522yAG1P7DJCZj34b2eGZNRzbL4+KX+dNqfXF3CZRxH1g4JA==
X-Received: by 2002:a05:6a20:1595:b0:210:4397:82a5 with SMTP id adf61e73a8af0-21ee68c8a34mr16623956637.21.1749428991023;
        Sun, 08 Jun 2025 17:29:51 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482af7ad57sm4659019b3a.65.2025.06.08.17.29.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jun 2025 17:29:50 -0700 (PDT)
Message-ID: <ea372927-08eb-4b07-b444-8985f7710894@redhat.com>
Date: Mon, 9 Jun 2025 10:29:29 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 15/18] KVM: arm64: Enable host mapping of shared
 guest_memfd memory
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
 <20250605153800.557144-16-tabba@google.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250605153800.557144-16-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/6/25 1:37 AM, Fuad Tabba wrote:
> Enable the host mapping of guest_memfd-backed memory on arm64.
> 
> This applies to all current arm64 VM types that support guest_memfd.
> Future VM types can restrict this behavior via the
> kvm_arch_gmem_supports_shared_mem() hook if needed.
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/arm64/include/asm/kvm_host.h | 5 +++++
>   arch/arm64/kvm/Kconfig            | 1 +
>   arch/arm64/kvm/mmu.c              | 7 +++++++
>   3 files changed, 13 insertions(+)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>


