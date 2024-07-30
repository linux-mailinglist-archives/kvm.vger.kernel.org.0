Return-Path: <kvm+bounces-22712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D3149422FB
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 00:35:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6919284EF8
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 22:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 768481917DA;
	Tue, 30 Jul 2024 22:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VFm794Cu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE9118E052
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 22:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722378922; cv=none; b=ikeH4souXafq4JviZjhiXS+AhnbIN3Ggtlpi6NzvjhH6fH0jH7v0pPY2UIRto2jV0XZieTZWezHHDXPJtgm3+/893B8DwM+NqkTzo46ff+kS3NDeYBk1ZbGozoJonKg6Nj5pRwYSkdUshBxQ7xIr6m0PPrM/TMePo9IkNZGtD/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722378922; c=relaxed/simple;
	bh=YFDCChsqaB4UhHP0/2HzjxvaMXC55WBTMkh7IBQDDtE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hLnruuqXmgcT+lCthwUoJzN6RDzvDpBZwGDcRExiovUOWhNEEnsFppUNOy5wlPjKwvk1CJlh7z7bN+hfPss/NUhOEaNgfngfmaptaRsLcrKkPay1TdocOuWy/Umfwc7KLL0+NzgZwe8c8txAhd8RNooYtYzHRerflY2mGA7JXJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VFm794Cu; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70d188c9cabso4144935b3a.0
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 15:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722378920; x=1722983720; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eSOwPlC4K/K4c1NtKrHXJlP1TgjanOwgNCfxP6XzMYQ=;
        b=VFm794Cu4g1xmSVj5xxDIQ3U2TkQNpI93y1UzVMBC3NyvQsKPLGhWR09RVNvcrpKMI
         7SfUtm1/gqTJdPNvQdpFoP+kCkxKTgzwDl8unhOtxGXqfuahoOf0OYFETQfk1KGrOTqG
         cLRcUG3zkCf1rlPwowVhnQyGW5ht2n0SJrRjwBth6TnlTryrtiF4FCm+fGANTaEb5Heq
         MkwQ1oSW4ZQgmdML+HtzubjukNUDV0bWjVyL7fYwM9HQNmU7w9vdYTyUL6sZFNDErOyx
         fjKFurPNjJBPJCcVOLCIPMvVqZW6t+ylOnSPBHfe0qRhUU8lzY3iPYaJ8w3DxMes9Orl
         6zZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722378920; x=1722983720;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eSOwPlC4K/K4c1NtKrHXJlP1TgjanOwgNCfxP6XzMYQ=;
        b=u1ugZ8038V1s88zXs0/LAIRd9hvSykkB+xlhdYpjer5WEVNvRFrNhFVFV1knppRb57
         MdRfvZzVDmjGYxidzNnbqWUUESo6Zn+Xp866ezZeRPHxuA3oV8O6iY2X6f2Z10lqTd42
         bcq4uLiWwk14zWb0j0upFBop+0e5lV8f8Nx/7fC0CP9LW9VK0V9JhuF4SaZoGM1zer9+
         wOgRW8hpw08M0q6rK+aemFmXEHPshfhq4k8ZHJ20JUwMUYEH1VD0H/ZcFkk3dEosIPwg
         GEKUuGOxN10tfFOukRVq16ma48IEcGW+qROLyqyCBfPWKrOJFIovsPZSCUXLpnVYmVw/
         6qQg==
X-Forwarded-Encrypted: i=1; AJvYcCU1TT2CdAq5ULDGw40BGg/ULr+2g8s5+hUX8IkEGdd96Nj707omYDj9omEPlM0sA6TvZbO6bJfWs1hyUVETRXdZda7r
X-Gm-Message-State: AOJu0YzeMbbIVQZvdmsatQ4LZSsu+Gzh+O3cVHaCPevBV0cimMPfnIFM
	IYNCwwOU3UnCwOAfPyxlENCk6VpAAYUCyJoqeQ7HC7cG8hseDaHtl83BBY5UWdXR6MOvzpN6+On
	I1Q==
X-Google-Smtp-Source: AGHT+IFhvXMAoVFBOUzUOOlo2Rzlu+lOmmXT/AMKduASO9OrwvfaDw5U6qKsr5Vo6lwrA4+Cjt72+QiZt8Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:91c7:b0:710:4d08:e41f with SMTP id
 d2e1a72fcca58-7104d08e48amr716b3a.4.1722378920090; Tue, 30 Jul 2024 15:35:20
 -0700 (PDT)
Date: Tue, 30 Jul 2024 15:35:18 -0700
In-Reply-To: <419ea6ce-83ca-413e-936c-1935e2c51497@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com> <419ea6ce-83ca-413e-936c-1935e2c51497@redhat.com>
Message-ID: <ZqlqpjO0TiWnOEqx@google.com>
Subject: Re: [PATCH v12 00/84] KVM: Stop grabbing references to PFNMAP'd pages
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
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
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 30, 2024, Paolo Bonzini wrote:
> An interesting evolution of the API could be to pass a struct kvm_follow_pfn
> pointer to {,__}kvm_faultin_pfn() and __gfn_to_page() (the "constructors");
> and on the other side to kvm_release_faultin_page() and
> kvm_release_page_*().  The struct kvm_follow_pfn could be embedded in the
> (x86) kvm_page_fault and (generic) kvm_host_map structs.  But certainly not
> as part of this already huge work.

For kvm_faultin_pfn(), my hope/dream is to make kvm_page_fault a common struct,
with an arch member (a la kvm_vcpu), and get to something like:

  static int arch_page_fault_handler(...)
  {
	struct kvm_page_fault fault = {
		<const common stuff>,

		.arch.xxx = <arch stuff>,
	};

	<arch code>


	r = kvm_faultin_pfn();
	
	...
  }

In theory, that would allow moving the kvm->mmu_invalidate_seq handling, memslot
lookup, etc. into kvm_faultin_pfn(), or maybe another helper that is invoked to
setup the fault structure.  I.e. it would give us a way to drive convergence for
at least some of the fault handling logic, without having to tackle gory arch
details, at least not right away.

