Return-Path: <kvm+bounces-49978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 35788AE060F
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 14:37:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC57B189958D
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 12:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C1F2242D63;
	Thu, 19 Jun 2025 12:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c1Y/hTGy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E21023E33D;
	Thu, 19 Jun 2025 12:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750336569; cv=none; b=mGTMSG3BuA2psz81howi1myt+3/ZGiCxuIKCgeiqakQ6b4ML5Z9Trs/RFwuzwdnhs6iuSYVBcHpvroHceRRNIab1Kysl3PLMv3/ICw86JGagQdn9S1soV773tPahiH7lGIA2swbRleIM68pETmvQnBc1MDHwMw4ng4VDwyqq0zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750336569; c=relaxed/simple;
	bh=/VJpImzxCawSJoEGcFeP8vUU7BIQ4dI0KhLFtoTx7bc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IXrzHpB/P8PIjbN/a4UWqyAzgBdHRBAGVz/Yic35gb1cIpiOPrXDKhVP8MKpT1Zo9EVSUE9jvhu+RdvT0lbwJSvnWGgHp2zgtAR6MD62YZpjbsSPNtKwflb62tzby6A4Cx9ameXzr2L7lVBsqw/Qe+Kov+raQG4rnaTEVdjz9/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c1Y/hTGy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E63BAC4CEEF;
	Thu, 19 Jun 2025 12:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750336568;
	bh=/VJpImzxCawSJoEGcFeP8vUU7BIQ4dI0KhLFtoTx7bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1Y/hTGyqUZJGUEUZUgtVqR3Lm17+BC5/oGuq7U0MY9mRxFOpx8TksxBQFWzwj+wt
	 jEy76Nl7yxYCsizm6p1ACyoakPYuXbaHyea8vjawdVUwUEXB67cLo2mywRNSRPnZZR
	 jLvvtZc3noD9GTNNvl/P2i9D4sEs9Glcc1Hos1IRliawpbMyMzUncJM2dRGOg1R+wi
	 WDyRAmJPSXOpjxL5i1hijcLxC1hQjvyrbcSxVaD0s8v3p9iR2sytHkUnZOi7d/HRBt
	 0JzkIRCsINQ33XXUgJXpOXUCnrVVnQMN3OBk33vSIgVcw/c7e0wtYxln1z+nKqk7J2
	 Hp79FJ1Q3IldQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uSEUw-008Fdk-8C;
	Thu, 19 Jun 2025 13:36:06 +0100
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joerg Roedel <joro@8bytes.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Sairaj Kodilkar <sarunkod@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	David Matlack <dmatlack@google.com>
Subject: Re: (subset) [PATCH v3 01/62] KVM: arm64: Explicitly treat routing entry type changes as changes
Date: Thu, 19 Jun 2025 13:36:02 +0100
Message-Id: <175033652435.3069576.5168060744496766238.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250611224604.313496-3-seanjc@google.com>
References: <20250611224604.313496-2-seanjc@google.com> <20250611224604.313496-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, pbonzini@redhat.com, joro@8bytes.org, dwmw2@infradead.org, baolu.lu@linux.intel.com, seanjc@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, sarunkod@amd.com, vasant.hegde@amd.com, mlevitsk@redhat.com, joao.m.martins@oracle.com, francescolavra.fl@gmail.com, dmatlack@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 11 Jun 2025 15:45:04 -0700, Sean Christopherson wrote:
> Explicitly treat type differences as GSI routing changes, as comparing MSI
> data between two entries could get a false negative, e.g. if userspace
> changed the type but left the type-specific data as-
> 
> Note, the same bug was fixed in x86 by commit bcda70c56f3e ("KVM: x86:
> Explicitly treat routing entry type changes as changes").
> 
> [...]

Applied to fixes, thanks!

[01/62] KVM: arm64: Explicitly treat routing entry type changes as changes
        commit: 1fbe6861a6d9a942fb8ab8677ddf1ecb86b1af60

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



