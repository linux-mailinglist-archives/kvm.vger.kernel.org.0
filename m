Return-Path: <kvm+bounces-49428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 04A57AD8F6D
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 16:24:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4766F188DE9C
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 14:21:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0CB9188CC9;
	Fri, 13 Jun 2025 14:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ve6FZ8Al"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0132E2E11CD;
	Fri, 13 Jun 2025 14:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749824434; cv=none; b=ZpovKod8C1WYMNinYJoLABNSkh1CrTh6K1ttxVgi8+UsobdCYJH8ZvUTYEh6OsYzLRzO528yJiJAVSQ587aWxZA9RzjJbN93d4YoSKFxk+qnLrx26EEL09LO21YYgA5Y0eD5JB+KrFpiXMpnyAB2gIiKUCtbvGLMHTo9s/tR0AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749824434; c=relaxed/simple;
	bh=EPKHkNW/pWvGSKzvuK+zaYdXAKILaYuidguqxeIk4Yw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ya/jATSekTqHmbFZiKIQ4xVTjBQo3jYMxUeOVsyi4uWuqMZEXzyNUeU1mYjmjHb9zWpC95/OwE3rJjDwkLAikuibzaAK5yRdqAXWYhmShh6FGMdzOIVG0NK8SpP1Gc1MbtIK/llzt1ObYRS0wkpXpEi90yqsnN1g0yHGEqbWk48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ve6FZ8Al; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B14C4CEED;
	Fri, 13 Jun 2025 14:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749824433;
	bh=EPKHkNW/pWvGSKzvuK+zaYdXAKILaYuidguqxeIk4Yw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ve6FZ8Alf9SI1sYrlPynorHq3vd7XO0hctfD/FwFi1Yr570jgszY/sWUWJFbKLuPM
	 nQu71s/Hul7EmxbxouGX5T+wjrRTxgKeiFEW+bs5rkJCsFxcwHU759DXQlTabuPT5G
	 PxDjtDGhNA7kvKkd2UzQA8HlsRM8T/eu+E+TSoKOFPtdjGyfJ5fxBxWqQP/vDzNKLr
	 oD0dnXeWr2CjqBr5qLfbFaASn2OOi+AW791J7XUTflq3fgp8foITPixPCD2A4VIN4d
	 G1byFjPOeultEOPjaOsp5MWi85kGbs7/Mu2645Oib8V07SqMlETiiDgfkafiy09YOZ
	 U5tjo5xm+nn/A==
Date: Fri, 13 Jun 2025 19:45:10 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, Sairaj Kodilkar <sarunkod@amd.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Joao Martins <joao.m.martins@oracle.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3 08/62] KVM: SVM: Drop pointless masking of default
 APIC base when setting V_APIC_BAR
Message-ID: <7kz6bvwpnsbth4puaivtygdzygqmcippdgkihieqcy5ua5rlpr@biu2qjtzraxz>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-10-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611224604.313496-10-seanjc@google.com>

On Wed, Jun 11, 2025 at 03:45:11PM -0700, Sean Christopherson wrote:
> Drop VMCB_AVIC_APIC_BAR_MASK, it's just a regurgitation of the maximum
> theoretical 4KiB-aligned physical address, i.e. is not novel in any way,
> and its only usage is to mask the default APIC base, which is 4KiB aligned
> and (obviously) a legal physical address.
> 
> No functional change intended.
> 
> Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/svm.h | 2 --
>  arch/x86/kvm/svm/avic.c    | 2 +-
>  2 files changed, 1 insertion(+), 3 deletions(-)

Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>

- Naveen


