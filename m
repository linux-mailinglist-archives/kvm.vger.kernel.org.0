Return-Path: <kvm+bounces-53414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 78D5EB11438
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 00:41:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9AD7E16FD93
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 22:41:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7C5823BF9B;
	Thu, 24 Jul 2025 22:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KS27LQ3f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1D21E9906
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 22:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753396907; cv=none; b=Kh1z9dG8J4WKZBFj16s+bh6X9/uxNw2u4lVgWDf2AHkaqCwlSY0UBPqmVO8tZ7mqBP+bMFGd+bL4wYmXaYx6hC7Y+HTAwtaYeHzdNX4VKosQwFjnDq7L5sIu5vQZ8E1BxfVGvHmY9roFX/CWNP9O5tfMf3Asz1dG4lLoYtHdHog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753396907; c=relaxed/simple;
	bh=XP7SEwPZ4F56VY5lJapsTNraraT0bGVpygeXc7n5Ehs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uap2AfB7EckbE2RkeooR+YFsJSVDvby80n8+8DNQyyDqzbNKo5hxZIQSXMS/868SdW3/c2Mb/e5peBVq8bb42DvAxBpbK6624F1Og4kvhbH/DCL/1t44ChA6NT2e1J80oFodJaO/jLoilrIR1ruXvdCR15tGUxFO5JvQbfVFU5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KS27LQ3f; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b3928ad6176so1377465a12.3
        for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 15:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753396905; x=1754001705; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I++IEkZ6cfA0pom6sVbuAxnUAMPLwsrLQQjRsHcyFdk=;
        b=KS27LQ3f3FKMD9T7SbEidyVYV5giPgvAfbj2G7MzaZefYBdTaI/NR8BcegnM/pCT+i
         qWbPJ3HnwVm+zcoFZ3UaSdiu9Z8mkVFDC6znhPh1d/K/hdgCH7vjLN2em3oj2CusGdA/
         b7NNWzEQ4fGGRaVBopBCfrzkzgLKA3kS2hir/DFPua50JEmQ/CCG40AbcqKI4TYkFV9k
         pcSNdWoLrQvrOHQv5LSkSiWVOledAjc3jUVPRWtD9nQEjqo8y81EqGorUreLqiLAfBS6
         U5PqhAxBXaFwT9yAm1X9WhchLj64zEEBbzTjMmYCSsvibY3IWwGZQFpY4RS52M4Celgc
         +nlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753396905; x=1754001705;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I++IEkZ6cfA0pom6sVbuAxnUAMPLwsrLQQjRsHcyFdk=;
        b=kfBZY9Ku36g66zf8QGxpzIE7/+59ScD1AvDgwV/LDC2V6rH/CLKr52TL8dbgyZlVr6
         M8pnHfrQ/FbS5/nsrMLsZ8smovePLE3ZNra8Yfxs2uxANqsDyRhHVIWHLF/iaOKkHDNq
         fVbWsyGhQmx8xx+qjyOf5wcdPtZVayntCfSOP0iyV43pciS96qmYlVRPoLcTdbDVGt+U
         i4H+U6/FMJ+N3FVjeIZpnfT8E31i1QxbU7VC9/sp1PW90aRUua02rukDrTr+aE6bmIKm
         ru8DId8f5NwZuB81QWjX1Yst9zl9r0YmdC/X5MvEJoE+QIJnJ0Lr/G06DxnGI9FDdDd6
         0tuA==
X-Forwarded-Encrypted: i=1; AJvYcCUNdX6yObpp1GvvJm8m5c6tolNKnhxFIGlxc6hK0HZTRc2DuFDqgGCTo0Vmpu9sR5ujZeE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgJxIaxjTrhwKmqHLrkkEysKAJp7WVWy+SBblZ0JO3fMWfgHCl
	dyjhk3t96+Ab5mHm7QgXdrvskRKu5HjwIE4yq5FkZ5dRk0BYjAjpVypGfUUM0KaYeCmUvYyWxf7
	zg/urAg==
X-Google-Smtp-Source: AGHT+IGEPOlZq7owpGUQ0/mQoz/iYL0juCcDdQmikLBP7yLM7Njsl8AJeWnJbZK3d5L+Zszkhv9RTa/c8fM=
X-Received: from pjbee6.prod.google.com ([2002:a17:90a:fc46:b0:312:14e5:174b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4985:b0:315:af43:12ee
 with SMTP id 98e67ed59e1d1-31e507e27a7mr12941229a91.16.1753396904788; Thu, 24
 Jul 2025 15:41:44 -0700 (PDT)
Date: Thu, 24 Jul 2025 15:41:43 -0700
In-Reply-To: <a438c189-4152-4ad4-977e-6a5291a7dd40@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-6-tabba@google.com>
 <a438c189-4152-4ad4-977e-6a5291a7dd40@intel.com>
Message-ID: <aIK2p9TgiNeQOI4s@google.com>
Subject: Re: [PATCH v16 05/22] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
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

On Wed, Jul 23, 2025, Xiaoyao Li wrote:
> On 7/23/2025 6:46 PM, Fuad Tabba wrote:
> > The original name was vague regarding its functionality. This Kconfig
> > option specifically enables and gates the kvm_gmem_populate() function,
> > which is responsible for populating a GPA range with guest data.
> > 
> > The new name, HAVE_KVM_ARCH_GMEM_POPULATE, describes the purpose of the
> > option: to enable arch-specific guest_memfd population mechanisms. It
> > also follows the same pattern as the other HAVE_KVM_ARCH_* configuration
> > options.
> > 
> > This improves clarity for developers and ensures the name accurately
> > reflects the functionality it controls, especially as guest_memfd
> > support expands beyond purely "private" memory scenarios.
> > 
> > Note that the vm type KVM_X86_SW_PROTECTED_VM does not need the populate
> > function. Therefore, ensure that the correct configuration is selected
> > when KVM_SW_PROTECTED_VM is enabled.
> 
> the changelog needs to be enhanced. At least it doesn't talk about
> KVM_X86_PRIVATE_MEM at all.
> 
> If Sean is going to queue this version, I think he can help refine it when
> queuing.

My bad, I simply forgot.  How's this?

--

The original name was vague regarding its functionality. This Kconfig
option specifically enables and gates the kvm_gmem_populate() function,
which is responsible for populating a GPA range with guest data.

The new name, HAVE_KVM_ARCH_GMEM_POPULATE, describes the purpose of the
option: to enable arch-specific guest_memfd population mechanisms. It
also follows the same pattern as the other HAVE_KVM_ARCH_* configuration
options.

This improves clarity for developers and ensures the name accurately
reflects the functionality it controls, especially as guest_memfd
support expands beyond purely "private" memory scenarios.

Temporarily keep KVM_GENERIC_PRIVATE_MEM as an x86-only config so as to
minimize the churn, and to hopefully make it easier to see what features
require HAVE_KVM_ARCH_GMEM_POPULATE.  On that note, omit GMEM_POPULATE
for KVM_X86_SW_PROTECTED_VM, as regular ol' memset() suffices for
software-protected VMs.

As for KVM_GENERIC_PRIVATE_MEM, a future change will select KVM_GUEST_MEMFD
for all 64-bit KVM builds, at which point the intermedidate config will
become obsolete and can/will be dropped.

