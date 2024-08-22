Return-Path: <kvm+bounces-24822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E55B695B84B
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 16:24:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F744B27546
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 14:24:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B00FD1CBEA8;
	Thu, 22 Aug 2024 14:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ozyO7lH5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD83017C216;
	Thu, 22 Aug 2024 14:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724336659; cv=none; b=PsdEo35pCvEGf/PAvLkmoa+9D9rSpuaHE/z4Xd2eo++rDqsyrmDP5m9mVDE1VAO2tuRtThSpsZpakLO9Ru1paC+oLw0AFJuh76qUV+utO/beHFg4IHYXYti1Y/Iw2bzqzW1T4HvOOSPxZC6Tlej2JGnnkiM3CEu8wQh1x/8AJLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724336659; c=relaxed/simple;
	bh=0qohOtlUlbQ+S7qqgBywKvuqNp39ChdhI74mz8dd2Dw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nGgmEB/vGxBpcfO7d6JgoInQV9kGvnoxItRkOrx4+7rANzNkjnZkFDCHfsmud8Ol5Yjeb/90UMTO1I0B8o+pGCQwW8+mjAvqmmj4OlKJRlumkeHEnDxypzfsIZyqfWEiMQ9reZw7p1Ykgfr0sK7kfl6FXG9ERzPPYz+IbYS9BBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ozyO7lH5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3890DC32782;
	Thu, 22 Aug 2024 14:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724336659;
	bh=0qohOtlUlbQ+S7qqgBywKvuqNp39ChdhI74mz8dd2Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ozyO7lH51LENj0pz8yJ9fFnASqP4aSjXxFuKZyH76eEZfApci5B9okfoLmHxgZvRl
	 kmY9knEHycx303qDiMZFMJsfJpqn6tVYWhMcbpsPdtqyR08wW7dGyBdAsKT/SPSplB
	 fsLLGJh7rF1T+sOm5wl9+C8L1ISbJpzVAWk59zSHzqRq0uD/9uvelRrd7eTZKAPmsX
	 EE6ZTNoCRSU4stcONEEC1E2/aGmZZLiutDtV3jSzJnNIXTcN7FHtjLNHbi+zf06rbl
	 jcQwthABEVYJa5D5/i7LiPEJzJe88IgPhkFgJFPF1dhSGtFvraxCKRnGO8MM55oKVU
	 JebJWUwYL2VmA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sh8jY-005yPd-K8;
	Thu, 22 Aug 2024 15:24:16 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
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
Cc: kvm@vger.kernel.org,
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
Subject: Re: (subset) [PATCH v12 01/84] KVM: arm64: Release pfn, i.e. put page, if copying MTE tags hits ZONE_DEVICE
Date: Thu, 22 Aug 2024 15:24:11 +0100
Message-Id: <172433664067.3702537.13271681605926473288.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240726235234.228822-2-seanjc@google.com>
References: <20240726235234.228822-1-seanjc@google.com> <20240726235234.228822-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, oliver.upton@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, seanjc@google.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, dmatlack@google.com, stevensd@chromium.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 26 Jul 2024 16:51:10 -0700, Sean Christopherson wrote:
> Put the page reference acquired by gfn_to_pfn_prot() if
> kvm_vm_ioctl_mte_copy_tags() runs into ZONE_DEVICE memory.  KVM's less-
> than-stellar heuristics for dealing with pfn-mapped memory means that KVM
> can get a page reference to ZONE_DEVICE memory.
> 
> 

Applied to next, thanks!

[01/84] KVM: arm64: Release pfn, i.e. put page, if copying MTE tags hits ZONE_DEVICE
        commit: ae41d7dbaeb4f79134136cd65ad7015cf9ccf78a

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



