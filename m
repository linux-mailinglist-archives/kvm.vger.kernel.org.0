Return-Path: <kvm+bounces-22931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E292E94490E
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 12:08:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D019282DE2
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 10:08:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96700183CA3;
	Thu,  1 Aug 2024 10:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dXl6XfVw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9497B174EEB;
	Thu,  1 Aug 2024 10:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722506875; cv=none; b=ZmExBWe5zAR+cOGlD15LpPLHtdtwyCr2eziKpeXPsQXpO3LFwGDoJrAGKevmrCpspPjalQ1jx9h9/HFkiRDBMQ+5e28ncU3CdJP/2NfU66WPw7n6L4slDCggakecQmsgvz1klbeut+mIoNWePWB2lOcOl6jntmwcs4IrEBiHgW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722506875; c=relaxed/simple;
	bh=1omcIl0ySlr8+5216FhuGPRNQkd7nfMr+PkPp6A7HmE=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IIKOpcMyG9xy3Fj9vvkPaF3lDgbgN9Qjk1MNP7rz35ILJcWhVPtcOv9B+vjmJzt2+I+dwCQcQWXYCOYA6CIih2vioIrx+eO+V+/KQ4kaQQHwmZwDSOwSKsLqvN9weqigqU17pn1+9Nu00xrU7EmnhvTaZPI5zaEpA50GaX//ito=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dXl6XfVw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F19EC32786;
	Thu,  1 Aug 2024 10:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722506875;
	bh=1omcIl0ySlr8+5216FhuGPRNQkd7nfMr+PkPp6A7HmE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dXl6XfVwOB9GlSLpifm4SQnLN1SxN9WD5f/MTtx+7gzr1ecINtOADxIOmr8sjVBL0
	 DVMXHY/qfYmEhNan55mGOmG6D7THyLOPd70VPVKIpK/4MAQ5E5HS45NyBgeC5R48+X
	 z9v7rywzNiMJ0Y3pLiLCJmKABr+FNbRPJFAyTyruso3jShF040qqp9MpwrWDsAtHKt
	 fWTz+yRtpK8TbmWmQV9Ovzo1U3O3+yf5d0a9Gg2dNbSlY68eZRNVapCcFH1FcVxKAs
	 Ludh8f3lr4RMdR6f7qJHOWB6bVOFl8ZRUulSkXqf7CV6Gn2MFS6IIw7ZvAl4rbJ8vr
	 zHK3gmvw2IfAQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sZSiv-00HLX2-08;
	Thu, 01 Aug 2024 11:07:53 +0100
Date: Thu, 01 Aug 2024 11:07:52 +0100
Message-ID: <86plqs1rpj.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
    Steven Price <steven.price@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
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
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	David Matlack <dmatlack@google.com>,
	David Stevens <stevensd@chromium.org>
Subject: Re: [PATCH v12 01/84] KVM: arm64: Release pfn, i.e. put page, if copying MTE tags hits ZONE_DEVICE
In-Reply-To: <20240726235234.228822-2-seanjc@google.com>
References: <20240726235234.228822-1-seanjc@google.com>
	<20240726235234.228822-2-seanjc@google.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/29.3
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: seanjc@google.com, steven.price@arm.com, pbonzini@redhat.com, oliver.upton@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, dmatlack@google.com, stevensd@chromium.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

+ Steven Price for this patch (and the following one), as this really
is his turf.

On Sat, 27 Jul 2024 00:51:10 +0100,
Sean Christopherson <seanjc@google.com> wrote:
> 
> Put the page reference acquired by gfn_to_pfn_prot() if
> kvm_vm_ioctl_mte_copy_tags() runs into ZONE_DEVICE memory.  KVM's less-
> than-stellar heuristics for dealing with pfn-mapped memory means that KVM
> can get a page reference to ZONE_DEVICE memory.
> 
> Fixes: f0376edb1ddc ("KVM: arm64: Add ioctl to fetch/store tags in a guest")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/arm64/kvm/guest.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 11098eb7eb44..e1f0ff08836a 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -1059,6 +1059,7 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>  		page = pfn_to_online_page(pfn);
>  		if (!page) {
>  			/* Reject ZONE_DEVICE memory */
> +			kvm_release_pfn_clean(pfn);
>  			ret = -EFAULT;
>  			goto out;
>  		}
> -- 
> 2.46.0.rc1.232.g9752f9e123-goog
> 
> 

-- 
Without deviation from the norm, progress is not possible.

