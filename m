Return-Path: <kvm+bounces-49526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 059D8AD96A5
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 22:50:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 670863BD43E
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 20:49:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A354D253941;
	Fri, 13 Jun 2025 20:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FhCqBzeA"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A436623D2A4
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 20:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749847812; cv=none; b=fnz1GX1BtguMDIRDgMtUOQmDXBC3k0wpHjXA4gvmi/j1lknffY5Qf8z6YrivEUi8/uCN0jpZd6hsbrv9Hvygnu5POv0akRCq4G3CH2qlbzB/3iJF9dpr1zjIaGVkNfAk3O9cnyntkrMxXO8a+mvHY734vaGdph32gL83Az0sj4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749847812; c=relaxed/simple;
	bh=rlp4as2PRO87GThqzQRdmrqwl1gpmCoEjWDxdIkx3Vg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mwam/txPhOoMSw4pTHaTnhI80s5cN5NQnPn8QcKwRE3oAbzgH4aKY44hgIgb98xqSU+KKRe9Wk2V9wb8nRHHW5scLs7JiL5QEyK6BashBZZUne3w521nVskXmyCXTJooR8w0HG8n2jN7UXul5w8yVks3vJ8WYhnocsmDp7Avn8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FhCqBzeA; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 13 Jun 2025 13:50:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749847808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I8Sut+fy8lfu7/XvMjml4eUjNedvlzjM8vX8iOh3OUw=;
	b=FhCqBzeAOonQAm/50ztUH2sE5JTslXDgXCcfs+hGcy47NGTjBpPPfky37vSgwj1uD0nT3g
	BJBHYE0HEaRuDzhBlKzYL2qF6h/Jd2aLZTgwi2ZxfSY2joUdPRuO64zBYIyeKzn/H0APC9
	3z3bxhA8fRMVhxeAk4sWJnUe0AVBnas=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Joerg Roedel <joro@8bytes.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, Sairaj Kodilkar <sarunkod@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3 33/62] KVM: Fold kvm_arch_irqfd_route_changed() into
 kvm_arch_update_irqfd_routing()
Message-ID: <aEyO-elphq6t1G7o@linux.dev>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-35-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611224604.313496-35-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 11, 2025 at 03:45:36PM -0700, Sean Christopherson wrote:
> Fold kvm_arch_irqfd_route_changed() into kvm_arch_update_irqfd_routing().
> Calling arch code to know whether or not to call arch code is absurd.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks,
Oliver

