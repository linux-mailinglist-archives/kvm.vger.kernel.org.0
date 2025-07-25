Return-Path: <kvm+bounces-53456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 916E3B1206B
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 16:56:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADB861C27C36
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 14:57:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA2C8247DF9;
	Fri, 25 Jul 2025 14:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IfG++rx9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2EB228CBE
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 14:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753455400; cv=none; b=HPe7KHeeGDgZyJOWuKbP4Vs5OWkbT9wPPdHYghgTFXEzBGNZ7YDzDFTSHTazKcbxHRszEeaW2Gq9O4/sjmWOBvHIR7DHzg/tFeCs3TQwsj7bowZE1N/4jX+33eRT8CUb+k5NvA18H/iM9z+NSYJBoC9n9FU15/VvmcNyDq7okWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753455400; c=relaxed/simple;
	bh=K3fLhkRTCvPWFzXF+RTlvEpWsEqZfAX/VnDQbwLix5I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HcdlS3Wp64v0hEbqoPUixAMXCZxQymjmIqnFQ027UkVrNX7XO6+bycoJ6F76eF0rckE8lwtYAyBjFfJKf12pOpzA0/20URT3XDQ6T85OKGkpvYn+ALTMgQU7I2tUPY0IpotEtxZDhAXcXcwCUSAWsuXY/1vHzS6lQwACiPNuFEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IfG++rx9; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-23692793178so25983755ad.0
        for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 07:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753455398; x=1754060198; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M11ZItqJowsXWKLvHpygzI/Vvsnt9QVCd1UdBgcxgdM=;
        b=IfG++rx9mo0WTcUki63Z5od0ct/dQMREXtbeVJCoPlDezWNoidrHwxSXpS7irpH6n6
         r3WjyYSP48AkgqyQxoqhrBevHaobMsHd3UgtR/JVWuFBx7wxa6W1dj7Cz/6LjLFNXBq7
         XvrDAPC5YTQToE8L2nRUiCA+Q8L2dAH1AOPbLIiuNhyRbewkuFON0aGzxw0qbIIiy51e
         syyib0AcuwrEecEkratzEsfoSpm7q98c5iKwtZfoevv0hl0GnrrKMXmAQJvVCywIXE2O
         NoeXj6QvmTBAjQRDHUG8Mt8keDzDvLGSTjb5ZZ5uQFonAgI0JJzjFDWPMLK/RpkqVGMq
         Yhkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753455398; x=1754060198;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M11ZItqJowsXWKLvHpygzI/Vvsnt9QVCd1UdBgcxgdM=;
        b=Y0Nq4yFWwQkWP4YNf+UZT3kmmZg0+cXveADaH432kK8HMlFZd7GN7Uo9dVh03k7u9I
         pPIHLMetrqrHBPsI5wB/UwccWuCqzBDiPxKdSfUayv2jiGUMZq8ZufFmCqta8QHHpFCb
         yB1rDoOP/+QZPOgmMtL/mT0yyjvoAUxjaMFXObn5tXFs0YIOKitCfw5txt5wRdhXzTI+
         xAArVbu2MxXFIBsy4Gc4qGwLGFCcQ7cue7c0bD7vN1y/Sc8By3OUvy39DHbi2WFvK7tC
         NGNRfR1oGjo8D00LtoMq5IDtwbiIhXT6L/ob2XA1sex5BwRBXQxMmv/go+eEAvn3M+o6
         +8Gw==
X-Forwarded-Encrypted: i=1; AJvYcCXdiXkbsygowWfPH2cj9PNzBOi6mJDCgu5ieLr2OTJC1dSPsFmVwb2kHEksKpXP7O5Ovb0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+d/cJ33Jw6MlDPULswDBQzI+iw7FeCnav5O34mrEzJ8L2zzd4
	+PaOfbZ7380dcffQoA+Xpduc5Ke6Tvrs79NlSA4socdrYUfSWnoewhDfk0uGUj78OJSGQriokYf
	pXDC0mw==
X-Google-Smtp-Source: AGHT+IHSdqHbxeeeIonkSh5BY2m83Kk+wImCtE785oBEw0uVpGh4sf1S5Bqzy2yOyFZqFe/ReQAn+EAhx5g=
X-Received: from pjvf3.prod.google.com ([2002:a17:90a:da83:b0:312:ea08:fa64])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ca8d:b0:23f:b954:eee
 with SMTP id d9443c01a7336-23fb9541174mr15170785ad.35.1753455397682; Fri, 25
 Jul 2025 07:56:37 -0700 (PDT)
Date: Fri, 25 Jul 2025 07:56:36 -0700
In-Reply-To: <diqz4iv1dudx.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <diqz4iv1dudx.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <aIObJH439LQWjnqq@google.com>
Subject: Re: [PATCH v16 00/22] KVM: Enable host userspace mapping for
 guest_memfd-backed memory for non-CoCo VMs
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 24, 2025, Ackerley Tng wrote:
> Fuad Tabba <tabba@google.com> writes:
> 
> [snip]
> 
> Did the patch [1] for x86/mmu that actually allows faulting when
> kvm_memslot_is_gmem_only() get dropped by accident?

Ah shoot, it did get dropped.  I have a feeling Fuad read "drop the helper" as
"drop the patch" :-)

Faud, given the growing list of x86-specific goofs, any objection to me sending
v17?  I'd also like to tack on a selftest patch to verify that KVM can actually
fault-in non-private memory via a guest_memfd fd.

