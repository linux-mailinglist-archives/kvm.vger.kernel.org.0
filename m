Return-Path: <kvm+bounces-52054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D864B00AF2
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 19:59:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6832C7BEFA1
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 17:57:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB0B02F5481;
	Thu, 10 Jul 2025 17:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="XHBQaFvP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3742F1FC2
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 17:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752170342; cv=none; b=HCGEJepVvhULvA8wmaPCxXRug/Ohfhyz17AeVVXAOcI91ZCdy1lybjqNrOsk9aQOHcAegWPhCjVHVY7Zw6xw0o/4bzQGnhJNczAPaMSvQeI/iHMhhczZtittQUfTBELZ1Uw10SKguwMSiPkPhgTQ9fPKp/GifRSeD5ui/8gCpZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752170342; c=relaxed/simple;
	bh=gLPvs5+RdTSlZIaCs47AFBkItVYL7SyZ9thIkYN5Zw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bkup011v7NvUa7DLKdEvgXvxUrcvj9P0PvZcrVStj6QGtR9WAHfj2U2/aqghtP2nIiuZb0nA/vOMEXxapCxOFD8vhpfPnObrKw0s5rvKiq5df8sf7uib3JFxhy30Re8IMKBK69R7+/bvgM6TN0B6hkoB2mEsLe1LP8O1ax+U1uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=XHBQaFvP; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-23636167afeso11293935ad.3
        for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 10:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1752170340; x=1752775140; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gLPvs5+RdTSlZIaCs47AFBkItVYL7SyZ9thIkYN5Zw4=;
        b=XHBQaFvPWERoQNfUPE+zxG7PgAD5HW3hss1V6nZjJt0bzQA92vJEQ/ZMRDorl++IhT
         V2OziG+V7hGucwRj+W5gFxEfaTFE7cODtwJJeFe0f7SEf2G7000yhXnsPdS2O8fWUdJ5
         8U/RhKqGk0AytqKMCenGYM6weZR5p5NLINSjlHHltuBe91skLJBceuMkOh7C2U0XjIdk
         jh43jvpb03KqG4hxugNurUxsA5FguOZ4L7sCHaUKWfljiEuCJ40bpDkyuqUSK3IopeGc
         H4+9nGmqHnTlIpcLH9K2LP8pSpiqTMfYihmNuQDF/y5f4pLeOMi5L5VLFmBfkDi/7KRJ
         tiwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752170340; x=1752775140;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gLPvs5+RdTSlZIaCs47AFBkItVYL7SyZ9thIkYN5Zw4=;
        b=h9GSEw/98JIYXBF8OqBrpP0GAMyy6fMDOlH+5/V1aDhTxXieR4EQaOcmETCwqsy6KQ
         /CmuUQDAWAy6S/BiVbD+shVRlLs0pUy8iBeEsPCZVIiSdHoA+vUvwdnqMS3NvQTm2cFU
         DCI3dfRdbquZGhGZISY13x2d7O6OgFMx567F/bFrMlP9ipnahgEgW9VdSTrvj+z21Ftc
         edlBfdNX59avgTlgucQHR+xZ2InvebKAZeZIcWVBI3af0YOKjrklJ+3Hnppg67uW5PdW
         xmfsDn4ktrKL/9+3GDzS02cZm96ddMUnRKkHtPzdMIqyrQwEdgQMR/Mi8GBtlVQjZiw2
         nNow==
X-Forwarded-Encrypted: i=1; AJvYcCV0DNPdDIQp0Dd7TmwiZ7A5eF46YZQ/vGtRgFV+9TQibXMS//97ez+4f2vQxVuA6rQFh/A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/jCISi293rME/TUVftaMkeJ/9+atIV3mSVMYJLqGW3FotutDR
	eKXtQmQp9hiOfoeDuEND4I8QEEYDzxPD49z3zeydHQG78mY5E5SJYDj1jC7GtIKJmBE=
X-Gm-Gg: ASbGncumlctAb4ZX66QZLpW+mCVO+7/iFainOkHEHsdhGdYXt/79Oz8H9ca/vHaWZQ+
	3VNTM7K30I8MePpjP3S7xMEA4y/XGrydRSZnTEwd+XTyKmUYF1qnq4vwckE/1SIoVfFI5w4mBoX
	zDcy9CcBPFKNP+TlltbhaSFjhnsLIuUrLWAY3aCqriymxO7N2Bv1TcW6HBHfY7j9a5ojL9HBytg
	aFCAs1SP8uh99+fLMwFRwQFDVGJLlB0aJwZ4sLCX+PqrPYXp7/0XydCpA3zJ/+hGSagH8sgixi6
	d3a6wea24nvFzXp6R5fDlR5XCJWgvCZcwOkm
X-Google-Smtp-Source: AGHT+IGsdYCi7RfWhcH25FuRFcSoC6JS2JrRDFNCNj7y5398JhpEwT92bbA8QjM5IB5UpkxovQPYtQ==
X-Received: by 2002:a17:902:e78d:b0:234:a139:1215 with SMTP id d9443c01a7336-23dee28fa46mr823515ad.35.1752170340041;
        Thu, 10 Jul 2025 10:59:00 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23de42aef8fsm29025605ad.76.2025.07.10.10.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jul 2025 10:58:59 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uZvXu-00000007x6B-22YZ;
	Thu, 10 Jul 2025 14:58:58 -0300
Date: Thu, 10 Jul 2025 14:58:58 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Vishal Annapurve <vannapurve@google.com>, Fuad Tabba <tabba@google.com>,
	Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	linux-fsdevel@vger.kernel.org, ajones@ventanamicro.com,
	akpm@linux-foundation.org, amoorthy@google.com,
	anthony.yznaga@oracle.com, anup@brainfault.org,
	aou@eecs.berkeley.edu, bfoster@redhat.com,
	binbin.wu@linux.intel.com, brauner@kernel.org,
	catalin.marinas@arm.com, chao.p.peng@intel.com,
	chenhuacai@kernel.org, dave.hansen@intel.com, david@redhat.com,
	dmatlack@google.com, dwmw@amazon.co.uk, erdemaktas@google.com,
	fan.du@intel.com, fvdl@google.com, graf@amazon.com,
	haibo1.xu@intel.com, hch@infradead.org, hughd@google.com,
	ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz,
	james.morse@arm.com, jarkko@kernel.org, jgowans@amazon.com,
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com,
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com,
	kent.overstreet@linux.dev, kirill.shutemov@intel.com,
	liam.merwick@oracle.com, maciej.wieczor-retman@intel.com,
	mail@maciej.szmigiero.name, maz@kernel.org, mic@digikod.net,
	michael.roth@amd.com, mpe@ellerman.id.au, muchun.song@linux.dev,
	nikunj@amd.com, nsaenz@amazon.es, oliver.upton@linux.dev,
	palmer@dabbelt.com, pankaj.gupta@amd.com, paul.walmsley@sifive.com,
	pbonzini@redhat.com, pdurrant@amazon.co.uk, peterx@redhat.com,
	pgonda@google.com, pvorel@suse.cz, qperret@google.com,
	quic_cvanscha@quicinc.com, quic_eberman@quicinc.com,
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com,
	quic_pheragu@quicinc.com, quic_svaddagi@quicinc.com,
	quic_tsoni@quicinc.com, richard.weiyang@gmail.com,
	rick.p.edgecombe@intel.com, rientjes@google.com,
	roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com,
	shuah@kernel.org, steven.price@arm.com, steven.sistare@oracle.com,
	suzuki.poulose@arm.com, thomas.lendacky@amd.com,
	usama.arif@bytedance.com, vbabka@suse.cz, viro@zeniv.linux.org.uk,
	vkuznets@redhat.com, wei.w.wang@intel.com, will@kernel.org,
	willy@infradead.org, xiaoyao.li@intel.com, yan.y.zhao@intel.com,
	yilun.xu@intel.com, yuzenghui@huawei.com, zhiquan1.li@intel.com
Subject: Re: [RFC PATCH v2 04/51] KVM: guest_memfd: Introduce
 KVM_GMEM_CONVERT_SHARED/PRIVATE ioctls
Message-ID: <20250710175858.GB1870174@ziepe.ca>
References: <CA+EHjTwjKVkw2_AK0Y0-eth1dVW7ZW2Sk=73LL9NeQYAPpxPiw@mail.gmail.com>
 <CAGtprH_Evyc7tLhDB0t0fN+BUx5qeqWq8A2yZ5-ijbJ5UJ5f-g@mail.gmail.com>
 <9502503f-e0c2-489e-99b0-94146f9b6f85@amd.com>
 <20250624130811.GB72557@ziepe.ca>
 <CAGtprH_qh8sEY3s-JucW3n1Wvoq7jdVZDDokvG5HzPf0HV2=pg@mail.gmail.com>
 <31beeed3-b1be-439b-8a5b-db8c06dadc30@amd.com>
 <CAGtprH9gojp6hit2SZ0jJBJnzuRvpfRhSa334UhAMFYPZzp4PA@mail.gmail.com>
 <8f04f1df-d68d-4ef8-b176-595bbf00a9d1@amd.com>
 <CAGtprH-KhEM6=zegq-36yomZ8PX22EmaZpMPkLnkyzn51EF25w@mail.gmail.com>
 <09db374e-fa7d-4c1d-bf03-aaaafd93bd01@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09db374e-fa7d-4c1d-bf03-aaaafd93bd01@amd.com>

On Thu, Jul 10, 2025 at 04:57:25PM +1000, Alexey Kardashevskiy wrote:

> Currently I handle this from the KVM with a hack to get IOPDE from
> AMD IOMMU so both 2MB RMP entry and IOPDE entries are smashed in one
> go in one of many firmwares running on EPYC, and atm this is too
> hacky to be posted even as an RFC. This likely needs to move to
> IOMMUFD then (via some callbacks) which could call AMD IOMMU which
> then would call that firmware (called "TMPM" and it is not the PSP
> which is "TSM), probably. Thanks,

Wasn't the issue with the iommu that it needed to have a PTE break
whenever the shared/private changed in the RMP? Because the HW can't
handle an IOPTE that crosses more than one RMP entry? Or do I
misunderstand the problem?

If this is the problem I was expecting the page table code that
translates the guest memfd into the iommu PTEs would respect the
shared/private conversion boundaries and break up the PTEs
automatically.

I had thought there were three versions of of how to copy from guest
memfd into the IOPTEs:
 - HW must never have a private physaddr in an IOPTE
 - HW must have IOPTEs entirely private or shared
 - HW handles everything and IOPTEs should be maximally sized

Is this right? Is AMD #2?

Jason

