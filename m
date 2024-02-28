Return-Path: <kvm+bounces-10300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ED1B86B81D
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 20:25:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80DBF1C231AE
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 19:25:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B60715CD59;
	Wed, 28 Feb 2024 19:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FIrn+6lk"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852A534CDE;
	Wed, 28 Feb 2024 19:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709148280; cv=none; b=NyoHUBt+IRvP8HBSh7v8YUyn56Y4E3aJ/wq0RkbCl4g4x0s3nM/M4KILP0nnIsOjkH2FmSOizzXtaV0n+Mhk4sJxQ57lJ3P2G9u2p7dDYBV3TlwAmqyX0qZY6olCblEqTK4u98M7gAEnAZXyvoL9KEWOFUFnJ3w+b48s+6bhA70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709148280; c=relaxed/simple;
	bh=f+l8DJrmfXjiK3kQE6tA/3QdGLC1S52w7nzT8O7+o1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Llz62LDmGkUC31x8Abxn3hCjomTuwZvbMzDswu2RRbm1vCYQrqiYQmGkA5GdMqHx6TWAPJHUlVaZhgzPmqT+sKGuTidAgdQH9Jq0KYbMutLVAVljS/Yasn+duYPomsrvZZ+XM4P/BlKze7Xfcsvv0oYLS8Sssb8gPuUHOM7ESl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FIrn+6lk; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lauQg9NweZMJD88rVmzwykxUluRcd7xmKvqNQoxZSqQ=; b=FIrn+6lkOR56bbfxuGk6XHpMuz
	aqeJIT8URifZElVt7iK5SG66l2CJyV0vqOoyDRo4oaF3O7iZmpK+a5oTN+6QhvTY1NDHTHh2QH1NL
	1URxbtx9WFfvf9lLYJAN4gpIv8I5AlAZVHSmHbjYrAldM8Ol6Kh/Qonsdnxt8jL1GOSg6n21OyMsB
	0l8NmnxNTe5SCJhvo9R5UYD5ljRMsZGmGyT9eh6nysKdkKPaUJoE99LhaKSVEqO0YTkt48C+AXLlf
	lXPzNCN3in22uDpsYFpDzQ8B8Kz3DzOqFfAUuHqAR4j1ZCUCbJO1A6091aje2/Kh6tboxRwzWy+xF
	qiPDM7VQ==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfPXe-000000060Bl-3pCj;
	Wed, 28 Feb 2024 19:24:34 +0000
Date: Wed, 28 Feb 2024 19:24:34 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Yosry Ahmed <yosryahmed@google.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	michael.roth@amd.com, isaku.yamahata@intel.com,
	thomas.lendacky@amd.com
Subject: Re: [PATCH 17/21] filemap: add FGP_CREAT_ONLY
Message-ID: <Zd-Icopo09aUmOvT@casper.infradead.org>
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-18-pbonzini@redhat.com>
 <Zd6W-aLnovAI1FL3@google.com>
 <CAJD7tkapC6es9qjaOf=SmE9XYUdbh_fAperjSe9hy=_iqdB0wQ@mail.gmail.com>
 <Zd8x3w2mwyAufKvm@casper.infradead.org>
 <CABgObfZ9LFDrtLkMaT5LVwy0Z2QMk6SqJ104+D=w7o9i0gEu+g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgObfZ9LFDrtLkMaT5LVwy0Z2QMk6SqJ104+D=w7o9i0gEu+g@mail.gmail.com>

On Wed, Feb 28, 2024 at 02:28:45PM +0100, Paolo Bonzini wrote:
> Since you're here: KVM would like to add a ioctl to encrypt and
> install a page into guest_memfd, in preparation for launching an
> encrypted guest. For this API we want to rule out the possibility of
> overwriting a page that is already in the guest_memfd's filemap,
> therefore this API would pass FGP_CREAT_ONLY|FGP_CREAT
> into__filemap_get_folio. Do you think this is bogus...

Would it work to start out by either asserting the memfd is empty of
pages, or by evicting any existing pages?  Both those seem nicer than
starting, realising you've got some unencrypted memory and aborting.

> > This looks bogus to me, and if it's not bogus, it's incomplete.
> 
> ... or if not, what incompleteness can you spot?

The part where we race another caller passing FGP_CREAT_ONLY and one gets
an EEXIST back from filemap_add_folio().  Maybe that's not something
that can happen in your use case, but it's at least semantics that
need documenting.

