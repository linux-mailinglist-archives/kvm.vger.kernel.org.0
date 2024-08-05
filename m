Return-Path: <kvm+bounces-23290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E666D94865E
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 01:53:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5A1B6B23065
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 23:53:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 988ED14C5A1;
	Mon,  5 Aug 2024 23:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HWG7qDtB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED2415F330
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 23:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722901984; cv=none; b=LMklmYTHtqkVzREncyq8Zjw5tKPmj80i7mXc9mQs8Ik4K3k9SFKMx5pgUTozDJtkejH2CJonBMXA6DdhBZRW4S4jQRreA5Xlva6erIXFo8Aluc9Xs9hMFSGJ/F11xiTaYkdjz9HvjUB7HkQH55mf747QwUaoclrdpLRn2Chy4hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722901984; c=relaxed/simple;
	bh=XE64EO9QsKUjNS+RxiZtVEDU63XJXco52ktIOyCusQg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UVJBJM3jEdF/YclJyroYlBdGR8f1RELkkNSVM5xQ0uYzvrclN2LvKzPDpTl6hcj8OGibu30rJNcw26NtjLdMczsK96Nnnxiftt0wTRKjFFjcfR+hlprdRm1D5sx0zdOGNDey3H27zjoXzPvy91Ok5yrqMNgEGqndOCO+CF/q+0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HWG7qDtB; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-666010fb35cso5218247b3.0
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 16:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722901982; x=1723506782; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8tNxfozveIy4KhK+t6BTSFuKqZ3CnwWBfLDeoqvVNkU=;
        b=HWG7qDtBK8WeSQMHtwUEupXj8gn9AEcZD08pNgDO3ybTv7hBLCG4DnciwNe/jThvmS
         hC0z0hAcALBHp4MQAq3sGyL9udO6NTOi3aDTgMEWq5DwbV7bMG7ltOPSwaS4VIXyNLUn
         /rIbvJQ1Xl2Dz9mHHFh6QaAwuoH/18GsIrax37fnOHu1pcncOKNxz3DRcLi2CHsXDU5B
         0VMv62EFYUqz50XJcTZ1lAAmi0N+j6qU1pVjBTHBi3dn3CtSJYvtgveaowrc97q7m/ZF
         SoLH8cW8bFo2DYUOow+fGwaYCKpJRhsCHRpi2RnCammMNdlP3z8+mlulhkxyeT2L/sFd
         QZRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722901982; x=1723506782;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8tNxfozveIy4KhK+t6BTSFuKqZ3CnwWBfLDeoqvVNkU=;
        b=UvDqKDXVUtV2EtZjzddIOCqEBFDDLyXk2QOhk/xc9TLMv6B2iNBf0LzTSgr4nfjnb7
         VLslnWo5qM/S5NEFoFcUet1F991MchPipGUW6bwU62PxX5/KsaAOa/u46z/U06TX97rg
         BNXmPcoBWuy3oWYI4/YjtQUU0i+vT+PZaZxv2LKedIY+gUumX0aEhlHG9ZdOTyrOb1Lv
         BPDGlPAct1VfNnTFE+0xAUBNXEjDxS3ksRjotIZB+VhL5nbK8+ga4DIO7iyEFg3shSM2
         8YWN/MqYvbboJ+CAUF9/PtfoRUfTnWf4coTvdf4yJI1by+EmqQ2SGzDLWcyXOiOiXXDJ
         YBag==
X-Forwarded-Encrypted: i=1; AJvYcCWNQtuD/Fxgly3R97Lgf15cdMux7ZbqmYbKaq+3Df2C+94TDCJ87WaBa/JW6x+KeW0EUpVMsy+EB4t29vxO84S3q3J9
X-Gm-Message-State: AOJu0YwsRkqUN9jDBHgNZ/6HIW8NSIPS8RWEn09nVNI3uGBalsmWUce9
	6ohk9oiwWPB+o+pKYntI4Y3Ne1umAjciN1SkxAig24CBdzEThZwfzZpv4o8XKtSBEIKzhQ9xUCZ
	PrQ==
X-Google-Smtp-Source: AGHT+IHjgF0Ca8ethUSfrozdkFUFp0o0AUPtEhLPgrNZWa8lbUZ7qZQp3Z7lR+cNHb6EVM2g/AygpE/k1/Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:f16:b0:691:a38c:a61d with SMTP id
 00721157ae682-691a39bf26cmr3721507b3.3.1722901982364; Mon, 05 Aug 2024
 16:53:02 -0700 (PDT)
Date: Mon, 5 Aug 2024 16:53:01 -0700
In-Reply-To: <ZrFfvjy_-Tyx4xUV@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com> <20240726235234.228822-55-seanjc@google.com>
 <ZrFfgzRbiqT-Zi2O@linux.dev> <ZrFfvjy_-Tyx4xUV@linux.dev>
Message-ID: <ZrFl3faiGHQ5oLjf@google.com>
Subject: Re: [PATCH v12 54/84] KVM: arm64: Mark "struct page" pfns
 accessed/dirty before dropping mmu_lock
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 05, 2024, Oliver Upton wrote:
> > > ---
> > >  arch/arm64/kvm/mmu.c | 10 ++++++----
> > >  1 file changed, 6 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > index 22ee37360c4e..ce13c3d884d5 100644
> > > --- a/arch/arm64/kvm/mmu.c
> > > +++ b/arch/arm64/kvm/mmu.c
> > > @@ -1685,15 +1685,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > >  	}
> > >  
> > >  out_unlock:
> > > +	if (writable && !ret)
> > > +		kvm_set_pfn_dirty(pfn);
> > 
> > I'm guessing you meant kvm_release_pfn_dirty() here, because this leaks
> > a reference.

Doh, I did indeed.  Alternatively, this could be:

	if (writable && !ret)
		kvm_set_pfn_dirty(pfn);

	kvm_release_pfn_clean(pfn);

It won't matter in the end, because this just becomes:

	kvm_release_faultin_page(kvm, page, !!ret, writable);

So I guess the question is if you prefer to make the switch to an if-else in this
path, or more implicitly in the conversion to kvm_release_faultin_page().

I made the same goof for RISC-V, perhaps to prove that I too can copy+paste arm64's
MMU code ;-)

