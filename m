Return-Path: <kvm+bounces-49964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EA2EAE033B
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 13:16:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E94A1165EC3
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 11:16:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD83A227B87;
	Thu, 19 Jun 2025 11:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NpjDXNnv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F258822756A;
	Thu, 19 Jun 2025 11:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750331773; cv=none; b=Cn02xStyC0hyHXZB+tSkdHRBQVntTkFf5GIobq//SVIyYhOYWwJVgVlFob1QbAOe5wYqMNx48N2qDpGbLAU67ZMEiKUN4cIotu52VPOavYMAjxKZx0lq27+SXJMzPFmU+9FySKVHmhvlFZfJQknq1Gk64UVhpGRJR+mUcFq2w0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750331773; c=relaxed/simple;
	bh=jea73dDCsJTbDnvK9qLSZgHnRvFrbqUdo+tNLbeXebg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pSk8nsCAUPl63ktknm1zTf4EtcIlVPDA285sDsARt75LFA+MlXnAuTvUxxbGYeehoKzd8u6YRn5Uhe/GYmKWHwkTw8QciCpG8VsH4rIjcTWjk/EhHR3/87aXOOtkmu2BqQSd2JPf0EODDvBlF6CzdhXVFIUjk/3TN8/tY58qRbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NpjDXNnv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4900C4CEF2;
	Thu, 19 Jun 2025 11:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750331772;
	bh=jea73dDCsJTbDnvK9qLSZgHnRvFrbqUdo+tNLbeXebg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NpjDXNnvhgyelNAPwYMk/Zg6boRmLZoy4OsyTJJvgCN53kEJ9bOHRqd5nFt+KWe5A
	 Jzx9eI/IHaFsxchjXd5uRkht7+rd0bI3lHnzNGwivbQnlb4LKJBZg0eEGvGOWoB3+t
	 xzA5+CHkxoUeF6quvSATgOx0jdlJDhrqNDB3nLr8AAthJO+mv/t8757yq3HiOmgamE
	 eBZm0yFwN+Awj17xBCsdjw3mTq0pMD6WTc5r+McIlDma/9a8i62AwBcpfydl3NEh39
	 XdXxlzenW3/Oa+qXV+ktyUCxWwRwEkWoqRlblB8ZU6MBUUD7bHrRENd5Vd39PcEkSQ
	 EKtChBTGgVlow==
Date: Thu, 19 Jun 2025 16:39:37 +0530
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
Subject: Re: [PATCH v3 15/62] KVM: SVM: Drop superfluous "cache" of AVIC
 Physical ID entry pointer
Message-ID: <bknceu6nswhlz2c6lx3zc4afnrmq63dsriqctexincvs5jjk6v@7wlm2lf4czlh>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-17-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611224604.313496-17-seanjc@google.com>

On Wed, Jun 11, 2025 at 03:45:18PM -0700, Sean Christopherson wrote:
> Drop the vCPU's pointer to its AVIC Physical ID entry, and simply index
> the table directly.  Caching a pointer address is completely unnecessary
> for performance, and while the field technically caches the result of the
> pointer calculation, it's all too easy to misinterpret the name and think
> that the field somehow caches the _data_ in the table.
> 
> No functional change intended.
> 
> Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
> Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 27 +++++++++++++++------------
>  arch/x86/kvm/svm/svm.h  |  1 -
>  2 files changed, 15 insertions(+), 13 deletions(-)

Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>

- Naveen


