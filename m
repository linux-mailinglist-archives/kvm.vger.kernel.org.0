Return-Path: <kvm+bounces-49419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 495AAAD8EB1
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 16:09:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A93F3BA324
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 14:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01962293C73;
	Fri, 13 Jun 2025 13:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X8Z0v0mu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96941293C57
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 13:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749823043; cv=none; b=etBfnuwOo5+5nsUiPEkQwsaQ7ciL6uWc9uCi6KuRi05qR+dA6ntf9gF0W+Zcx0thoMviQkaVXiFarkgLb88PywIvIp+QgrW76zd2ecsSELTZim8LVLvT4ok1sxWNAfwWbvOQNaOzD7VkizWVTqOxL0z4fep98fsYVCp14w2iXs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749823043; c=relaxed/simple;
	bh=j/eRngj8H8ZbdpnO0fFDIsk8hiEYRjMNb+L170l84M4=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=puAj14ufZ9Fbdojk+GfIQgNCnAoQooWY+vRpI6Zq7tf7r8cPbR07LbSyRsd9YYtM99eLAvuk6i5z/8oWB8rXlIG7ZuP13cy593LzSBuuw7cLvplg7UjYZFIeyyK9TZPrB/ybSUb9KnQY92uYohYdm4yGNPUGZL/Jouh0BEVl0Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X8Z0v0mu; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-234dbbc4899so30989565ad.2
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 06:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749823041; x=1750427841; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dkuRqqw31HUjS3f3ozaxg1qfTggthracEAgq5uGUxWg=;
        b=X8Z0v0muSm9FeaciRmmNfzkGS8MGD/ZGdfGo5SPwY+sTZvcOHtAAzWo7VNDIdWrccG
         XhsUOk+F2IzbD1pojA+1vfz7iDoh++r81B91RZJmnSLp9+J6Kdkgu1ug8G642qj9t2rV
         7HLE36fvR9GDMKmfc7OBl4ouvp/KpRmaQyIph4qWelCw4O5Zh9gdY4U12tkAy+yrmhUU
         aI/I2+9fYjvbi6sBw1oFbhKPLP02f4h4DT9i7ZRKs7tej6RAxaOcvf1QRtuXPoqDHUXf
         HnrvR6VCxTAck/rTZf08IEQ1nf+kOP9BgZjj56BO9F6x0Bin8XHThz6fm6Yz5b6SFV6g
         jiPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749823041; x=1750427841;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dkuRqqw31HUjS3f3ozaxg1qfTggthracEAgq5uGUxWg=;
        b=Ilk4x7EDmG+5m46rvVqfh0cAPWw5KQuFq0hbIFPjKYVcTSNnC1I/tj2rKMDrEaEIaY
         pqEOjeWPMkdJdGwJ9P7B6Vm058/WFEh+bJpHVvh/L2AUCQchpKN83oIhWi7pXyA5Nbf6
         DZWxrr0bqMXTbCXPsBKUfr3/rGcLdM5qJUh66J0zesekBDXoGcQpkA4Lr/MNMvIwAyb+
         /nbDk6+i4jhl0fY1f2t4ON5B2TmQzVcbApR4n74eG/jVabLgmPvUg7kNrZ0z0An4gPvk
         SMp/FUQLUbRl7It488YR1Zu+6JJbhgYFeJloh7ic7B2EBEFeXcSsClD7uCkK0njgF48D
         eb9g==
X-Gm-Message-State: AOJu0YxKi/fbet+AOPuQHq1YQi/4sHyQvUa9L9vaIPAfySAsRG2qZe8s
	Z+bL3EprxpAPA4yRfLRxt1E1jVXW5lNdF+yCdt8xo/kbNG24hY6wcGqzNHHtCtUk1+l9lgXhZBK
	2fbeAkeN73ehBxrNFt3vHyh4IQg==
X-Google-Smtp-Source: AGHT+IE4pdDA+YU0xuWw2bZwqNNa/bw6PDc1eh7mNKACvMbud4eEJ6Hw9B3p1LPkjrd3WQIzMQtFfcUKJ8Y+9UsC3w==
X-Received: from pgbfm22.prod.google.com ([2002:a05:6a02:4996:b0:b29:82be:c692])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:fc44:b0:234:c549:da14 with SMTP id d9443c01a7336-2365dc0d163mr46118995ad.29.1749823040963;
 Fri, 13 Jun 2025 06:57:20 -0700 (PDT)
Date: Fri, 13 Jun 2025 06:57:19 -0700
In-Reply-To: <20250611133330.1514028-5-tabba@google.com> (message from Fuad
 Tabba on Wed, 11 Jun 2025 14:33:16 +0100)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzv7ozvj5s.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v12 04/18] KVM: x86: Rename kvm->arch.has_private_mem to kvm->arch.supports_gmem
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
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
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fuad Tabba <tabba@google.com> writes:

> The bool has_private_mem is used to indicate whether guest_memfd is
> supported. Rename it to supports_gmem to make its meaning clearer and to
> decouple memory being private from guest_memfd.
>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shivank Garg <shivankg@amd.com>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 4 ++--
>  arch/x86/kvm/mmu/mmu.c          | 2 +-
>  arch/x86/kvm/svm/svm.c          | 4 ++--
>  arch/x86/kvm/x86.c              | 3 +--
>  4 files changed, 6 insertions(+), 7 deletions(-)
>

This [1] is one recently-merged usage of arch.has_private_mem which
needs to be renamed too.

[1] https://github.com/torvalds/linux/blob/27605c8c0f69e319df156b471974e4e223035378/arch/x86/kvm/vmx/tdx.c#L627

[...]

