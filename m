Return-Path: <kvm+bounces-49529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69C9DAD96D5
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 23:03:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A297F4A145C
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 21:03:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C01525DAE8;
	Fri, 13 Jun 2025 21:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Kc8nPVhl"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC2525BEFB
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 21:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749848597; cv=none; b=Z+RaDgaoB3TsaZ2EJWRNKlL/lUGF8y+rLu9Uv3ddVxSorOJIs9nclk0pUWMCyO04rcCZhuEO20D7oZAEAkIovZQvXc5gBzOG/la7vAXE7Qmiy9wE8MpIFISMWLBQZV6gKksaa/LrO/p0w55uRr/CnDDSz3Fnlze/KEOKplUlfCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749848597; c=relaxed/simple;
	bh=RvoNgZOWtd0BxznLOG4DnK82GZ7oKsETmKcwAOzz4qs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tqp6nhRqdUniB9d19eiEXFxhwyQwsKHYIZDSBhJihFZkoDwoueVtHxgYgtEAGrUcjr7hnhVntQHIH1IZSHbJP3cQgv7WtyCGNf1PZ7k5oK40ZNbKFa+W7wdVi1MPbA/K1rxNEhJs5yWt+TX+sC6e/5OmYuh0wup8sRUFiM0OPZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Kc8nPVhl; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 13 Jun 2025 14:02:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749848582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UYPjxyG6Lkdruehl3Wfp/fvOgutsisDdZvGlZZakKgQ=;
	b=Kc8nPVhlXgf6TePD1ArgM60c5dmNUT/R1JjVbnGxN7TexwkvkpcVz2WLId55A9oZ/CDUE5
	FbP2i2FSaWw7NAS2SkcnbcgK6HWEZ0xCShW/gxdnuC/LY4NPQptRcXYiWmJk0yYg54tCZA
	FkggVzxEL64vxvaUGTfILfyirGgdhDI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, Anish Ghulati <aghulati@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 0/8] KVM: Remove include/kvm, standardize includes
Message-ID: <aEyR_bixN696F1sP@linux.dev>
References: <20250611001042.170501-1-seanjc@google.com>
 <125bfa5b-4727-4998-a0da-fb50feec6df6@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <125bfa5b-4727-4998-a0da-fb50feec6df6@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jun 12, 2025 at 06:56:53AM +0200, Paolo Bonzini wrote:
> On 6/11/25 02:10, Sean Christopherson wrote:
> > Kill off include/kvm (through file moves/renames), and standardize the set of
> > KVM includes across all architectures.
> > 
> > This conflicts with Colton's partioned PMU series[1], but this should work as
> > a nice prepatory cleanup for the partitioned PMU work (and hopefully can land
> > sooner).
> > 
> > Note, these patches were originally posted as part of a much larger and more
> > agressive RFC[1].  We've effectively abandoned upstreaming the multi-KVM idea,
> > but I'm trying to (slowly) upstream the bits and pieces that I think/hope are
> > generally beneficial.
> > 
> > [1] https://lore.kernel.org/all/20250602192702.2125115-1-coltonlewis@google.com
> > [2] https://lore.kernel.org/all/20230916003118.2540661-1-seanjc@google.com
> 
> Marc, Oliver, I'd like to commit this to kvm/next sometime soon; I'll wait
> for your ack since most of the meat here is in arch/arm64.

Let it rip, just to get ahead of potential conflicts can you push out a
topic branch?

Acked-by: Oliver Upton <oliver.upton@linux.dev>

Thanks,
Oliver

