Return-Path: <kvm+bounces-64014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AA666C76B6B
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:11:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0824D356712
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:11:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7088F126F0A;
	Fri, 21 Nov 2025 00:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GvAxDDO6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1E222301
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 00:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763683855; cv=none; b=l1acwWBE66RabgGAjbENN4XxuqaPQreTvjSs44FUniwk1rMqXmcxzNQ5XhQ8npIXVaFX/F5iZmWxUWPQ8egAPsmAjITg3jED25ZsGBbKmyOsx4wMkPmHWKHMTQaPlA6QB4KqDXBaUez5qDTT/tt0JOLK2QZQhh0ApXtii5CSvY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763683855; c=relaxed/simple;
	bh=GTAeV0/U1Id0rOZySfsnYuhPR+q8AtT1fLfd5vOB2yU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vz4SVaCcnBblPBgXj0Yv1QZzhglA4As4ioDswR0zW9ZQe9RUzt0rP5e4/8SogT7TaU/WSkRPu2kq1oD+Ogt6y2dshCYBJUoy6prrROCHYwoALEw0C6KUw/bagNAXk3gfKV9ieRfqMJolByLtuwI9R6xSc3pvaYig65VcMX1eqHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GvAxDDO6; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-295fbc7d4abso22895715ad.1
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 16:10:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763683853; x=1764288653; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H2Jg5eGCJ4JWQv22m6t6f8HAltv6vrVf9pXQ9eNKNVk=;
        b=GvAxDDO6Y/OVZM6HzuaQ7LpBw++gdi/hV2OlmszbvJj2EW4RGWkE/bs8artLtMEXaq
         S4BqEMMTxg3AVTzNy+9wymUmhHvGAWF3x+HBdeP1ZVwbYdx5iceRcJXFXpvSDguKgyvm
         DNSHgv0Mt1gRHTh9/cJI/xUO5tqH+/7c9m5Eb8tj1QYi9WwypFLdQxQ/lxmKTnkVc/+I
         W0SDISbznlDntHdbBIoHcFnnvNfcWCIqN/lK1YbAlFQCFXy3ATHc0ysM+saqEYGBlO6q
         kmnGKbGowimsAyduyYl7NOUy+RFHj+/Wd8+3u7oG4zzVnCgI39X0KPIPpJUqZ0JLs+hQ
         xlnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763683853; x=1764288653;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H2Jg5eGCJ4JWQv22m6t6f8HAltv6vrVf9pXQ9eNKNVk=;
        b=she/ultoU2nTZej7zmzvvXTaPitrSTIBgXMnOHpnliWIfnED5i+W4JTlBYNCH+zL3G
         Ok8FWNXX9jQNBcZnsoFBHDwvH1qUirFaHrG4tKivhhajVPGlXtYpa4RuCAU+ibAoaEAB
         UmAJaGlfyx5OL44kMw8ILl2hwcPWY+BGkQSwkmKGruogujyeX1KygFG4rkd1nn10GBbQ
         u1/uBNWqii2iPm+ftb+Dj283n5PUYvlduIW1p/VkjMegeS6j7VsHWzlwqs3Ff9siEs7h
         ViyJ2iBVkU15g7hUdPTnXtHaBTKyNXioMyVolpBUu8MDrAwGghDcio0meUGH179DqDOK
         XACg==
X-Forwarded-Encrypted: i=1; AJvYcCX3H/kfMQuD1seD6VxZhIDSGsI8ZnFbDuHlbr2PnXxmaBYQiEGJGsxjwCYYjxuDTyEawZI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzFwUnJjtVmdD7ZRItVRTmzkIAyFrBoqyrJPM3Ap58ZNDJXfB4
	gua6NOdXuUNbn9bWDdJbueG4Il6ug57xlkfeePYYQc679MMtAisBga6PVwBoj6MA5k2nj9JaGKd
	I4z0aEA==
X-Google-Smtp-Source: AGHT+IHQJw6u93572+5nYVgz+HVD5zQVNxdCoyv5uNHiLP4YNyDD01xIH8qaFDKeb3fG0eRan1ynFEUUq4c=
X-Received: from plbki15.prod.google.com ([2002:a17:903:68f:b0:293:de:a528])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:903:b0:295:9db1:ff4b
 with SMTP id d9443c01a7336-29b6be8b66dmr6127945ad.4.1763683853447; Thu, 20
 Nov 2025 16:10:53 -0800 (PST)
Date: Thu, 20 Nov 2025 16:10:51 -0800
In-Reply-To: <20251021074736.1324328-19-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev> <20251021074736.1324328-19-yosry.ahmed@linux.dev>
Message-ID: <aR-uC-afVZYKfdLC@google.com>
Subject: Re: [PATCH v2 18/23] KVM: selftests: Generalize nested mapping functions
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 21, 2025, Yosry Ahmed wrote:
> Instead of passing in a pointer to struct vmx_pages, pass in the GPA of
> the root of the EPTs, as that's the only member being used. Furthermore,
> only use ept_pte_masks for VMX, and use x86_pte_masks otherwise (which
> is what NPT uses).
> 
> This is in preparation of supporting NPTs as well.
> 
> No functional change intended.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  tools/testing/selftests/kvm/include/x86/vmx.h |  6 +++---
>  .../testing/selftests/kvm/lib/x86/memstress.c |  4 ++--
>  tools/testing/selftests/kvm/lib/x86/vmx.c     | 20 ++++++++++---------
>  .../selftests/kvm/x86/vmx_dirty_log_test.c    |  6 +++---
>  4 files changed, 19 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
> index 5aa14ceed050a..4429e83e1f52c 100644
> --- a/tools/testing/selftests/kvm/include/x86/vmx.h
> +++ b/tools/testing/selftests/kvm/include/x86/vmx.h
> @@ -561,11 +561,11 @@ bool load_vmcs(struct vmx_pages *vmx);
>  
>  bool ept_1g_pages_supported(void);
>  
> -void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
> +void nested_map(struct kvm_vm *vm, vm_paddr_t root_gpa,
>  		 uint64_t nested_paddr, uint64_t paddr, uint64_t size);
> -void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
> +void nested_map_memslot(struct kvm_vm *vm, vm_paddr_t root_gpa,
>  			uint32_t memslot);
> -void nested_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
> +void nested_identity_map_1g(struct kvm_vm *vm, vm_paddr_t root_gpa,
>  			    uint64_t addr, uint64_t size);

Ugh, "nested" is a bad namespace.  Running L2 doesn't strictly require nested
TDP, and the operations themselves are non-nested, in the sense that we're
modifying stage-2 / TDP page tables.

My vote would be to do a rename to either stage2_pg_map() or tdp_pg_map()

