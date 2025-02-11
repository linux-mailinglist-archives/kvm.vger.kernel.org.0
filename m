Return-Path: <kvm+bounces-37897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C6C9A31232
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 17:57:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A3A818824C3
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 16:57:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F955254B16;
	Tue, 11 Feb 2025 16:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="riPTPQtr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E0C260A22
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 16:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739293055; cv=none; b=ONPo+ygXb4ZL/ZQwHoZLmmeIkmkIeK7mONTUiV2wrGbLGaqupp+cnSe1Gr7ZTyJxSHfioHvtkwQYqjVflbnlDN0rb4NmW1pWVWd/mdofhV9Gh+AZA1MtBusfa8IVP9k0kTrlSvfNDcVKmFvcNjt7g5EUnwMF5wtNZQBbKaIfms8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739293055; c=relaxed/simple;
	bh=xskn39v99O+DiTeeJhrlMEKE14ladxm2WDwo3FSn8N4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UJr/93WYGzsIK9qEMYjTk8kFz886ck4bIEWg0/LxgkQmz4sMvYUGezdwHwYcB3XHJeuVRuphZbitAU9PXSfv7584lVv23XjTMOpKod8yZQWVIoblnRIPo8JMNeqUOZz/aphZHxxxoChjH/cYl8N9rYT2oW+A00nbHOcIJMiwLOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=riPTPQtr; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5de84c2f62aso3963338a12.2
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 08:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739293052; x=1739897852; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ITTWQB6rCRgMy4jz77x7qgpeW2xyYXF+QL7wz+KsG0Y=;
        b=riPTPQtrck9ghK1YjlYNCtR4hYqmSLuK0VcXr0YZgcClQRXSN3CJDThsTres4JZ/Wt
         yHPreb2oiDuh7mHVsbr0QHjybg2+x1FzbZbkSbpMLLHyKLysZyOrs2MThV1XEuXQcIDn
         F723LFLWgxCPTwdaDNko1Ngzt1ZbNeHVrPnbMmsz8K00RENwru5NK8/0u/t/3JrOM10I
         f7UYwLWMwhSyBbrSe8lVSbNk0vWnfqPTgV0hOtoDcpMNPpQnQkAty1ixd2E9icYzxPbN
         gmiLLO3HT5FX3/UBpX6utLbgiQIqaLeogozQfWtgg8NYjcfwDyBvZBU4O/1JV2RCGTJ0
         3mqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739293052; x=1739897852;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ITTWQB6rCRgMy4jz77x7qgpeW2xyYXF+QL7wz+KsG0Y=;
        b=BRQlLKJz21KZhAZoBBmIFFoL2MB2xHn2wCejXytSUJkkY+IjEC7NBG+ozWmrNc91gM
         KOw0v8lB5YCvBRxyZfetZwL4L1I1fLmU+mzNtuVLQPiHB4y507PBm2FSklwXfl9N2Qpr
         Od1xcT8Pty8MQkqZUsU+rGZxgb4uQmVJT1Xm97uoK411XXAX27Brh69Rc9a8NnJxATxG
         10KQzRyZy8ZLweUHbP+5Pm7WS2RQxzpmh1nlczlignjCSVxG5GTI1mt8TZK54djS64F4
         Zulmr/LX6vXDNxeq87vPQ7vRgeiG/3JeAS14rPlbRrczdUGNakofHi8xb2W3D1f9e0wJ
         kFMw==
X-Gm-Message-State: AOJu0YydZaV42T3VOsvbcve5eUIXnt8molwqtm3Zrpj0K3K9hV/DwaBq
	XvATFy7mDm68+PmK4PqEAvPy/rAh0zUXZkjJY6iSzegNmekS0x+hwvqh8sa9bw==
X-Gm-Gg: ASbGncvdxfPWh0BcB+uJdsXuqWRjaAKyTShdT7qwvHFhqljbI3vSK2VIdGNX6IRoywK
	EG1W2c3yA7qOIsWcXGKNChPENNCIpyr8UJ67NIRrCN4Cjz+kugKZQ4GT5zDAFHkXDC67sae4HQk
	7BT1nxRc7pAwA4Mo4PlLB+dEK72XeAJjlHP5SKJluJpi/yN7/QAbRSOzE3YeQp+ojsJyb6wfpk0
	rA75h8rbbi0NtfZhGH8MmJuuoHn++sQRBlVmIq4Hdf19G41aiLQHuOVTiLF/TGZPpcgAiPiHMor
	5bFOsTZi6C8O6B1/atAr9ZeIBCB+pwryFrBoScXqCRZPnx4lL075
X-Google-Smtp-Source: AGHT+IFUs3jK4RIVQ4CQAOv86F0kyLMNTuS8WIFx7I3ccayQfZmTMdyBqNyfcfDIo0b7kmJTS6fEGw==
X-Received: by 2002:a17:907:2d24:b0:ab2:ea29:b6 with SMTP id a640c23a62f3a-ab7f01cc9bemr45031066b.35.1739293052108;
        Tue, 11 Feb 2025 08:57:32 -0800 (PST)
Received: from google.com (229.112.91.34.bc.googleusercontent.com. [34.91.112.229])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7be7ac8a9sm459262466b.39.2025.02.11.08.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 08:57:31 -0800 (PST)
Date: Tue, 11 Feb 2025 16:57:27 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
	xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, yu.c.zhang@linux.intel.com,
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
	vannapurve@google.com, ackerleytng@google.com,
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
	wei.w.wang@intel.com, liam.merwick@oracle.com,
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com, steven.price@arm.com,
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
	quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
	quic_pheragu@quicinc.com, catalin.marinas@arm.com,
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
	maz@kernel.org, will@kernel.org, keirf@google.com,
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org,
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com,
	fvdl@google.com, hughd@google.com, jthoughton@google.com
Subject: Re: [PATCH v3 08/11] KVM: arm64: Handle guest_memfd()-backed guest
 page faults
Message-ID: <Z6uBd-L_npR_VqVY@google.com>
References: <20250211121128.703390-1-tabba@google.com>
 <20250211121128.703390-9-tabba@google.com>
 <Z6tzfMW0TdwdAWxT@google.com>
 <CA+EHjTy3dmpLGL1kXiqZXh4uA4xOJDeTwffj7u6XyaH3jBU26w@mail.gmail.com>
 <Z6t6FSNwREpyMrG3@google.com>
 <CA+EHjTyU5K4Ro+gx1RcBcs2P2bjoVM24LO0AHSU+yjjQFCsw8Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTyU5K4Ro+gx1RcBcs2P2bjoVM24LO0AHSU+yjjQFCsw8Q@mail.gmail.com>

On Tuesday 11 Feb 2025 at 16:34:02 (+0000), Fuad Tabba wrote:
> > Sorry, yes, that wasn't clear. I meant that kvm_mem_is_private() calls
> > kvm_get_memory_attributes() which indexes kvm->mem_attr_array. The
> > comment in struct kvm indicates that this xarray is protected by RCU for
> > readers, so I was just checking if we were relying on
> > kvm_handle_guest_abort() to take srcu_read_lock(&kvm->srcu) for us, or
> > if there was something else more subtle here.
> 
> I was kind of afraid that people would be confused by this, and I
> commented on it in the commit message of the earlier patch:
> https://lore.kernel.org/all/20250211121128.703390-6-tabba@google.com/
> 
> > Note that the word "private" in the name of the function
> > kvm_mem_is_private() doesn't necessarily indicate that the memory
> > isn't shared, but is due to the history and evolution of
> > guest_memfd and the various names it has received. In effect,
> > this function is used to multiplex between the path of a normal
> > page fault and the path of a guest_memfd backed page fault.
> 
> kvm_mem_is_private() is property of the memslot itself. No xarrays
> harmed in the process :)

Ah, I see, but could someone enable CONFIG_GENERIC_PRIVATE_MEM and
related and get confused? Should KVM_GENERIC_MEMORY_ATTRIBUTES=n
depend on !ARM64? Or is it KVM_GMEM_SHARED_MEM that needs to depend on
the generic implementation being off?

Thanks,
Quentin

