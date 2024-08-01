Return-Path: <kvm+bounces-22894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 69AF5944584
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:35:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F7121F232C3
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:35:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 772CA16D9BD;
	Thu,  1 Aug 2024 07:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hm6lqGrn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D62E49626;
	Thu,  1 Aug 2024 07:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722497697; cv=none; b=C0LKgxEEixIvmvrz2Z71vPPn+rE7jB9LdR4DycUbwMvTH06/gu4HiRrcpjk3UmRiYz+Et59qLPerbK/FMgxrX3o8xuc+wbh71TJdCmSMxItWN+D3HxDT67sIfOwtr7+fYM9C0O/OSY2wLnZ5pU2VA4NGbSFTlL1RirBNwXMYR8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722497697; c=relaxed/simple;
	bh=4fAL4cODCnjl0NV8qGw/Qqudnit/5hoHCsZrciMhbUs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=k5YpY4R0L2a3dtzCWqRnB773xA7F7htuHc5vID+7jZnEq6MkxZW+qSQzIdy50YMa4wXUnOP0Qd83IqLfYQwedCPAuQxxrx0/dAeA0CrSriyf1l8EywNnJAEh9BsXuqVJHS70NhnTqxbL1krEWKk+U1xrX6aY0+w7OG2FeyKEoSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hm6lqGrn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C540CC4AF0A;
	Thu,  1 Aug 2024 07:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722497697;
	bh=4fAL4cODCnjl0NV8qGw/Qqudnit/5hoHCsZrciMhbUs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=hm6lqGrnGLdGUt29ZxrQ9cGwGC5e/My8adr9xG8pGwOWvxzaIy2wVVZecHcsaS7MD
	 2vhxDp5qw6P6jWSVDdYpSlndt26lYMY/9L3hrdQVP6XL1jiOwA3de3PchwMF07I1N4
	 2YEHskiwTzLI1+iwXeDgxTjbuc9HN0GjQyrYNiG+t6NhVrrxrlXYCf8VJMbSS/9yNs
	 oHiP/3JEHHEyg0SbxiUkt+heXZ9wY3Uvo6jOHCc4TGv31tTJIER/7SKgCRJbrwGHtk
	 ninurOs1MqcQM+fogPcJEhZWkju/RfarTKElxrf4Eq/YQ9RcoW3WZjBJcrAerVNRjv
	 rukvhfzurLf/A==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
	David Stevens <stevensd@chromium.org>
Subject: Re: [PATCH v12 02/84] KVM: arm64: Disallow copying MTE to guest
 memory while KVM is dirty logging
In-Reply-To: <20240726235234.228822-3-seanjc@google.com>
References: <20240726235234.228822-1-seanjc@google.com>
 <20240726235234.228822-3-seanjc@google.com>
Date: Thu, 01 Aug 2024 13:04:43 +0530
Message-ID: <yq5aikwku25o.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> Disallow copying MTE tags to guest memory while KVM is dirty logging, as
> writing guest memory without marking the gfn as dirty in the memslot could
> result in userspace failing to migrate the updated page.  Ideally (maybe?),
> KVM would simply mark the gfn as dirty, but there is no vCPU to work with,
> and presumably the only use case for copy MTE tags _to_ the guest is when
> restoring state on the target.
>
> Fixes: f0376edb1ddc ("KVM: arm64: Add ioctl to fetch/store tags in a guest")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/arm64/kvm/guest.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index e1f0ff08836a..962f985977c2 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -1045,6 +1045,11 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>  
>  	mutex_lock(&kvm->slots_lock);
>  
> +	if (write && atomic_read(&kvm->nr_memslots_dirty_logging)) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
>

is this equivalent to kvm_follow_pfn() with kfp->pin = 1 ? Should all
those pin request fail if kvm->nr_memslots_dirty_logging != 0? 


>  	while (length > 0) {
>  		kvm_pfn_t pfn = gfn_to_pfn_prot(kvm, gfn, write, NULL);
>  		void *maddr;
> -- 
> 2.46.0.rc1.232.g9752f9e123-goog

