Return-Path: <kvm+bounces-48705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B09C9AD15F2
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 01:44:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68846169981
	for <lists+kvm@lfdr.de>; Sun,  8 Jun 2025 23:44:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0676266B77;
	Sun,  8 Jun 2025 23:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G5tkuIEz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AAB186284
	for <kvm@vger.kernel.org>; Sun,  8 Jun 2025 23:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749426253; cv=none; b=bbWWXBgOJloxzcZKRhb32F1P3Uss3vIgRE/OX5UTl8poho+YHy9n/EvWdgZ9BChTTGUH3PaQHBomoRmGSFaYbs6/+9oVLfxa6zB5yN6EQiep8kEl1nDt83aXxs0RcRwpa7Xa5kFI1NO7OFj9tODlCn/vq8U+lbGKcA4ZOoKh0Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749426253; c=relaxed/simple;
	bh=KEewk9e5U1qq2kwEdiMoGkLuuuW/JkAzS/DTU1PoK8k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZjGHZ25h3C4HJhAhD8FbKGU319LvfEnVdgDld2L6mjOr7qvA6IsgzS8qLgDsq77B9495GXPyJ87MK6/7l2Jr2UpKyHI+l3/DRAb1mcgqlADQFSx3n8mTTphY15Tgck8DBL6mXuuMwXMnAcbCwFL1pQb62N8VhHFK9I8KDZFaITc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G5tkuIEz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749426248;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RulDiaiDU+rd4MVUsTg3W37W6/YZMu9uoDiqrxmqIRc=;
	b=G5tkuIEzmtNnCz00iMGrCMRde0S8jK5662AzubJaZOJHW/mZ8Gi9t/zGrnRAmpr+Rhaxy9
	5ETsnyvKQZfKP/M/pUFQJHJuZ7QkpyieGSh5HM6mGg7cDO7PXa0SQOKKexrwUCSAfK4dbE
	fZdMA/Bacpg1ZXVKzJeDFpKz0IabejI=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-NeuiH0yfO0uFCpEOvVi5YQ-1; Sun, 08 Jun 2025 19:44:06 -0400
X-MC-Unique: NeuiH0yfO0uFCpEOvVi5YQ-1
X-Mimecast-MFC-AGG-ID: NeuiH0yfO0uFCpEOvVi5YQ_1749426246
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b26e4fe0c08so2353572a12.3
        for <kvm@vger.kernel.org>; Sun, 08 Jun 2025 16:44:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749426246; x=1750031046;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RulDiaiDU+rd4MVUsTg3W37W6/YZMu9uoDiqrxmqIRc=;
        b=bh499N6aklSW//h42Rhqpi+GOnZbQVvaGOwwGCElDk6Am94r1Kv5f+DrUjM7h05EB+
         RiTXrPPNHMQZWlQf+wYRAdOzKj8cR7KtRGYo2Yi+WuSbm8eOoVnxP/OGKC57DJ6xTTCy
         NnQ70JDxFqliiVn1vPiml8bt9l2CwQCcV8hzxoffO6T2aDXaWEsP/RMFpXW+QGDqPeXk
         EjD+WO33hQyIfHUhJCQKJnHv8dHW1hxie6to9DHUqdUK82BCU38owDf1sp/AALYzf41k
         CEdCjuEydRarYZRZn/iL7TNcXFJUlSE00n9MLgFe6vCkOfnSIaB7blfDgukBdTH7W39x
         ZE6A==
X-Forwarded-Encrypted: i=1; AJvYcCVtNYY7EsnVJVD50JSPv0AlnjJ06ZsAUcsptjMzDIChVx0ENlbEnSLNEF31C44iWhW30Pc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yya+ml0ab8GyLC5rMyrEBPX9g0Rl+GJdK7D9qdfSRvi9EFcMeFh
	mvB0x6JjVC/nfihOI+QnkAUS9nqSwRaSUDblv21f3m3KsuMr8cO3zRSZelTBIgSOwRiKVcCCE51
	eBDDRoNyAzB/tQIdXejeBHBS/w1Y80CONfrNi8bxNp5ExJu/YbcpaMQ==
X-Gm-Gg: ASbGncvhpwqri/hk8Jp7/7rnXjJjFZc3TY06MF2tP3vo+p3X3U+fdZRSTDWlWLzoBVm
	kLRoqxNeYBeEL4SPcuCsRQCunza2QoZ/nniM+wVZsSaHgo6OBMBkWTtsd1XB9o3WxUoFvfl/M6V
	hfFsqATSMYbPWRKFytO9+TQ8iDmICNNBYXAG/rOa8974+6dsWeTjV/27g4kmSGm9E8m1nIU60f7
	owt/L+xdxtuBegKgnl96Fp4ncsOxAPlK5jfuD3M7KuqP2S2diMbCRWYPGvuRyaeXRDL/dHiklUj
	TonuBuh5edJZk2tkVE2F5zbmupEL4cIQGzpu9Y6hY0IyBU4WKXQ=
X-Received: by 2002:a05:6a21:a344:b0:203:c461:dd36 with SMTP id adf61e73a8af0-21ee257b955mr17179962637.6.1749426245875;
        Sun, 08 Jun 2025 16:44:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFSuWxYIxACJhhIZOfyC0tVrvvkBmEX9Mrq9tGz97R7mDt20pYUiPHkPZlAQCJkoa3KcF5ACA==
X-Received: by 2002:a05:6a21:a344:b0:203:c461:dd36 with SMTP id adf61e73a8af0-21ee257b955mr17179903637.6.1749426245541;
        Sun, 08 Jun 2025 16:44:05 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2f5f782283sm4196986a12.54.2025.06.08.16.43.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jun 2025 16:44:05 -0700 (PDT)
Message-ID: <df4bfc32-d395-4f0b-8664-5c65e05f5af0@redhat.com>
Date: Mon, 9 Jun 2025 09:43:43 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 18/18] KVM: selftests: guest_memfd mmap() test when
 mapping is allowed
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
 <20250605153800.557144-19-tabba@google.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250605153800.557144-19-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/6/25 1:38 AM, Fuad Tabba wrote:
> Expand the guest_memfd selftests to include testing mapping guest
> memory for VM types that support it.
> 
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   .../testing/selftests/kvm/guest_memfd_test.c  | 201 ++++++++++++++++--
>   1 file changed, 180 insertions(+), 21 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index 341ba616cf55..1612d3adcd0d 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -13,6 +13,8 @@
>   

Reviewed-by: Gavin Shan <gshan@redhat.com>


