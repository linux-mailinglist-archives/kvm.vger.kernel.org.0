Return-Path: <kvm+bounces-53003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 644D7B0C753
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 17:17:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 555623ADA6F
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 15:16:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3930B2DCC13;
	Mon, 21 Jul 2025 15:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HQ/5wZNe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190D82BE02C
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 15:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753111025; cv=none; b=tbRpuCzG+3eo2Ld8cctYEO1QtdWc+c7lkPVBylsR9lg2xPkxL4XLapzlQuX39rM+4cQVFN9DBJV7vGbtRR6HdSvbAISCx6W4KFKZ84FNqXTbwuaY0WNhM+9nUxjmmx7Av/UMBbTSFHUx3IyO/M1T0NaLb7YoV8CWA3f4hndwN1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753111025; c=relaxed/simple;
	bh=DdMAoLnDt3BZqGC3/MH1e4CmgEmvQhr8zC+TrEQ8g/A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F9K1+Vk2I2RdQtn9lntF+s4N4ik6ZdaLHjVso5reY2fCOe2W1gY1IQo03DeWw3NvTnhpyvXRhEuQOdj/skTKwjtcygI0liZemrUprfyXg/anRaxWerbe5M8clWgA0yVoflk9v0wl4/1WVBSOSl3AjJm5kpjRkehFQStAFRe4FBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HQ/5wZNe; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-234906c5e29so50836745ad.0
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 08:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753111023; x=1753715823; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eZhvDkWg2vIcqb5h1LaFmsKpUFQK58z+6ZtJpc5qCi4=;
        b=HQ/5wZNe0ugMTkFrd3AT5aXuR4m23sQv9I7gvdSYhH+ikcQ/bWG5PU2bxXLFC6YxCd
         CYUa+RYuxKZ1OrBNOMlVH5ttMEHKCivXSzkyw35jkN6Z3xfcZEDSD+dARUIBB5jOhFLg
         LmYC/kWvu3RYkmSDgN+EQTryHcenaUFoCgwqTGvF9K7QF9NFUNP3IXkBQhOnTtSqG0RA
         a4fNY7ETIxSBi9sQOSJlUHRpGKBRuAeMX6L/DH0/B0IafTLQDalqiSNABKfE3HLvgYBJ
         wtdIL9VWf3LbERswmF+EmE+Rkh/HN76Kwdn1X81epP08RgSjX5cEL5hXb0HJCMFZJADj
         UG3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753111023; x=1753715823;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eZhvDkWg2vIcqb5h1LaFmsKpUFQK58z+6ZtJpc5qCi4=;
        b=khTzXFakZU+WmXktKJRl8rgBfX3niR0j4N1ceNysu1TtYAUX5aS/VP5zsBFS2thAOJ
         sVhD1znS4phk5T76eRJqjizfo/HIrFvYhzSSbiU5uR32pzo0sp1hbSWU33A3xrrNvrGX
         rOdeXdR5VLGPjBM5ifTZ5Hmd0hIIKM2OSVV0ARkkyj1Zjxcf+LBBcWaMZLVgVvqv6Yu5
         olck4yBtc03G61Hp76PhAgc77lwqi4g3wMwGda3PfyonDDOhKxx9yLdbyEvKeAEzAC+k
         upeLoOk2r4XQb7bjyof1N3IqNpCSaQT0gBhb3VkexIePnsx+sugw7R0RkRzrGPp/hhIM
         hGwQ==
X-Gm-Message-State: AOJu0YzzcklamE0yh5CquTJrC01yogb2QgI19QEomgVm3lbP/SVV9YZv
	a0a0jP+r/y/7abwq9OkperLzajRyR7kA7fDCGaOkTK1CgZSSkfJ/4OExJ/h14OcXh8dE4cMo4Cc
	7nBTKWw==
X-Google-Smtp-Source: AGHT+IEOUhgoKLdh5nmcOUZ5zQQMJ+il7P7YZIA288keFVcRXhlFL8IRxQfYB3qVxDFSK42KaGDwW30OvDY=
X-Received: from pjbqo12.prod.google.com ([2002:a17:90b:3dcc:b0:31c:2fe4:33ba])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d50f:b0:234:eb6:a35d
 with SMTP id d9443c01a7336-23e2572af2dmr282186375ad.27.1753111023196; Mon, 21
 Jul 2025 08:17:03 -0700 (PDT)
Date: Mon, 21 Jul 2025 08:17:01 -0700
In-Reply-To: <20250717162731.446579-2-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-2-tabba@google.com>
Message-ID: <aH5Z7edFZSPzmJ5w@google.com>
Subject: Re: [PATCH v15 01/21] KVM: Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
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

On Thu, Jul 17, 2025, Fuad Tabba wrote:
> Rename the Kconfig option CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM. 

Please name this CONFIG_KVM_GUEST_MEMFD.  I'm a-ok using gmem as the namespace
for functions/macros/variables, but there's zero reason to shorten things like
Kconfigs.

> @@ -719,10 +719,10 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>  #endif
>  
>  /*
> - * Arch code must define kvm_arch_has_private_mem if support for private memory
> - * is enabled.
> + * Arch code must define kvm_arch_has_private_mem if support for guest_memfd is
> + * enabled.

This is undesirable, and the comment is flat out wrong.  As evidenced by the lack
of a #define in arm64, arch does NOT need to #define kvm_arch_has_private_mem if
CONFIG_KVM_GUEST_MEMFD=y.  It "works" because the sole caller to kvm_arch_has_private_mem()
is guarded by CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES=y, and that's never selected
by arm64.

I.e. this needs to key off of CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES=y, not off of
CONFIG_KVM_GUEST_MEMFD=y.  And I would just drop the comment altogether at that
point, because it's all quite self-explanatory:

#ifndef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
{
	return false;
}
#endif


>   */
> -#if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_PRIVATE_MEM)
> +#if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_GMEM)
>  static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>  {
>  	return false;
> @@ -2527,7 +2527,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
>  
>  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  {
> -	return IS_ENABLED(CONFIG_KVM_PRIVATE_MEM) &&
> +	return IS_ENABLED(CONFIG_KVM_GMEM) &&

And this is equally wrong.  The existing code checked CONFIG_KVM_PRIVATE_MEM,
because memory obviously can't be private if private memory is unsupported.

But that logic chain doesn't work as well for guest_memfd.  In a way, this is a
weird semantic change, e.g. it changes from "select guest_memfd if private memory
is supported" to "allow private memory if guest_memfd is select".   The former
existed because compiling in support for guest_memfd when it coulnd't possibly
be used was wasteful, but even then it was somewhat superfluous.

The latter is an arbitrary requirement that probably shouldn't exist, and if we
did want to make it a hard requirement, should be expressed in the Kconfig
dependency, not here.

TL;DR: drop the IS_ENABLED(CONFIG_KVM_GMEM) check.

