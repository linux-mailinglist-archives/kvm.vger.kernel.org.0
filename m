Return-Path: <kvm+bounces-9347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3BC585EEDD
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 03:06:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C53AC1C21A13
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 02:05:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23FAB14291;
	Thu, 22 Feb 2024 02:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cVYzlEJT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C245C14016
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 02:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708567552; cv=none; b=pOwQXk1VijJNvAYJBgZX+jEGhBlEhC38ahH4ODd9GhLnHPLlnnL+9Ut+ODRaB4wZQLg+wmzKNSY3qmIYd1lmxNc6u4yygYcX0hh518XjUIuyW+bg1rnrOq6qGRqTx7qzi9bKPiv8/GA15Mznbdu8fHng+Wlecb86wSbhnczoZVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708567552; c=relaxed/simple;
	bh=ozCZhRUwbru42YhRIa9D6DyDB6aCfOEQUSg9R1xBB10=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DPLfQMoIsH/F60N+wmDdBnBNkmIh9i+EcPEE4/0JA1zwuwRVHMpPhj9uwUGoSb1MPuNtt4S3mDBe9rnkOWRfyP5/eUO/Ye9rBGMuUyfj2A6yJ5SvK5F2y8BAcuzHE/TmUbA+N8+JLG+CQ357EfEEEYt1kN2vwFY6WzsGII97XhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cVYzlEJT; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc746178515so12217288276.2
        for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 18:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708567550; x=1709172350; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wYRM8eOs48YYKU37Y3bVOmsx2y3KEiVB2XVZoknd41E=;
        b=cVYzlEJTdhrtb28wLvzhrntIuzRcvWlBiSAeZZnOCZyT2NEeYQ4kJBX7V+um3fKswu
         YjUyO7gChTG+/z8ZuKHxPtPwwySBAqYwVAPSom4+sT2ssnEXpXRMakA/AP/5rDSc9Ggw
         64UKDDqjdbNKoQZ0mIVp2SU94fkQMB3jV5QDO1Gwz+TQEHHbnnLaWuReROBbOG0t8APu
         zY4hD6RYL69F8nnrdoLmU+Tla3SoMinsOtbcc5rl6s/RBNUX7hQbzarG7s6jj8pahwSc
         IBZdJzCQXhSW8dNWA2YFFhi+zWKhiRj3LOm8dZ8IjDsrHBzba/tBGtv83gl8suopIBB+
         jDvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708567550; x=1709172350;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wYRM8eOs48YYKU37Y3bVOmsx2y3KEiVB2XVZoknd41E=;
        b=YZzPY0RBVZDYuClFyOe41QZ0oLt/+6tz1V9JPL7H8Vgc9KdIRKtGbvFpnAvaoI+fRT
         KsE+/pHhHAX6N95IxaC/rt0j288IKRV7XB6GLs/EuDNTRkjIV/shz3ubqyY5QjL05lPF
         Sy5qa8e/f2O/8Mrpo15zF7jEXVrbXkLTlRw40u/Nnzny/2eVMK62tGU4qRf5xQAlaVts
         IawcxieuLPh/bpxZsYuU7g/HdMRAzFRL0RMbjQUTo74NsGVQKy/ilpAa5th0NuSXYedU
         Cf9Oy6uPljZOjOY3zkXjFXSkEAtVWNC0gKnI+4kfUVtAhlbAtRRPamqm3IufV8m7FnHN
         tm3w==
X-Forwarded-Encrypted: i=1; AJvYcCWNfddNcEInsXMG1z4ZFigzZjYa45GGMpJGRbBRRX7NJm60pOXKTunlG6qO/cGa+a+SKZv0woyOs6MHOa0QoZtDQ2Oi
X-Gm-Message-State: AOJu0YyEK1H2C1ZdCssELK0DpXbxBaIKnDdBc98a1pvT2JKkCVvzoUNF
	bA93iiQvR/ebvnVnOPZqH7+QWu5uWigavLrjp+4GkP8BtsLL8MTuFmBV0qYq9fwPgpYZ/ZHx84v
	6Vw==
X-Google-Smtp-Source: AGHT+IGLZRXp0J9qN8JJcoB3W0uf+vPPo31BgwKOSu3YKTJjr76LRxvOfOEDc1mZvTNorZoF2DnNDi6XZz8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:134d:b0:dcb:e4a2:1ab1 with SMTP id
 g13-20020a056902134d00b00dcbe4a21ab1mr276046ybu.11.1708567549779; Wed, 21 Feb
 2024 18:05:49 -0800 (PST)
Date: Wed, 21 Feb 2024 18:05:48 -0800
In-Reply-To: <20230722005227.GK25699@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1689893403.git.isaku.yamahata@intel.com>
 <f474282d701aca7af00e4f7171445abb5e734c6f.1689893403.git.isaku.yamahata@intel.com>
 <ZLqSH/lEbHEnQ9i8@google.com> <20230722005227.GK25699@ls.amr.corp.intel.com>
Message-ID: <Zdar_PrV4rzHpcGc@google.com>
Subject: Re: [RFC PATCH v4 04/10] KVM: x86: Introduce PFERR_GUEST_ENC_MASK to
 indicate fault is private
From: Sean Christopherson <seanjc@google.com>
To: Isaku Yamahata <isaku.yamahata@gmail.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Michael Roth <michael.roth@amd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, Sagi Shahar <sagis@google.com>, 
	David Matlack <dmatlack@google.com>, Kai Huang <kai.huang@intel.com>, 
	Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com, linux-coco@lists.linux.dev, 
	Chao Peng <chao.p.peng@linux.intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Yuan Yao <yuan.yao@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 21, 2023, Isaku Yamahata wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> Date: Wed, 14 Jun 2023 12:34:00 -0700
> Subject: [PATCH 4/8] KVM: x86: Use PFERR_GUEST_ENC_MASK to indicate fault is
>  private
> 
> SEV-SNP defines PFERR_GUEST_ENC_MASK (bit 32) in page-fault error bits to
> represent the guest page is encrypted.  Use the bit to designate that the
> page fault is private and that it requires looking up memory attributes.
> The vendor kvm page fault handler should set PFERR_GUEST_ENC_MASK bit based
> on their fault information.  It may or may not use the hardware value
> directly or parse the hardware value to set the bit.
> 
> For KVM_X86_SW_PROTECTED_VM, ask memory attributes for the fault
> privateness.  For async page fault, carry the bit and use it for kvm page
> fault handler.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

...

> @@ -4315,7 +4316,8 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  	      work->arch.cr3 != kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu))
>  		return;
>  
> -	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true, NULL);
> +	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, work->arch.error_code,
> +			      true, NULL);

This is unnecessary, KVM doesn't suppoort async page fault behavior for private
memory (and doesn't need to, because guest_memmfd() doesn't support swap).

> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 7f9ec1e5b136..3a423403af01 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -295,13 +295,13 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		.user = err & PFERR_USER_MASK,
>  		.prefetch = prefetch,
>  		.is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
> +		.is_private = err & PFERR_GUEST_ENC_MASK,

This breaks SEV and SEV-ES guests, because AFAICT, the APM is lying by defining
PFERR_GUEST_ENC_MASK in the context of SNP.  The flag isn't just set when running
SEV-SNP guests, it's set for all C-bit=1 effective accesses when running on SNP
capable hardware (at least, that's my observation).

Grumpiness about discovering yet another problem that I would have expected
_someone_ to stumble upon...

FYI, I'm going to post a rambling series to cleanup code in the page fault path
(it started as a cleanup of the "no slot" code and then grew a few more heads).
One of the patches I'm going to include is something that looks like this patch,
but I'm going to use a KVM-defined synthetic bit, because stuffing a bit that KVM
would need _clear_ on _some_ hardware is gross.

