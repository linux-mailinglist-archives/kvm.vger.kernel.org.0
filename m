Return-Path: <kvm+bounces-10497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DF38A86CA65
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 14:36:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 834981F2211E
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 13:36:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 800D48626B;
	Thu, 29 Feb 2024 13:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Yf7Fif6n"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510867E0F8;
	Thu, 29 Feb 2024 13:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709213800; cv=none; b=AYve3ZacbMMU+3UgAaZk2XDXRr7yAxY8lrsHHOBwMRTtKD9dLFJI0L0/XMLAUq4t1ssh5tSICZabIY6Ep5boaXeG0v4O844AwH3QccQfrVWPavXlet5JABucWuj8aJCNsziR9bJcSDjnQDFdPE2MkOK+Ap9LC8nF4xBxGUydZCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709213800; c=relaxed/simple;
	bh=OLeINhUfZtPKoUaRZ8erFl7pF5Trs9Ph8RVF20T1Ib0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m0TxetqLe7pf9sek+5gVYmWrRQGRufT3jTHjxKLmrQ0nkrfMTOiO6NqanprAMN7QtwZrqSq2yDqHtyICIjgPDQI9Ld+Aj5R+iAjWHVbCGnsyUVkCvRXEeNswKddXsirNJDqB3LaJI56yiMmIFytjqlQUjPsVjVIgNUF+BXH9qb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Yf7Fif6n; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OLeINhUfZtPKoUaRZ8erFl7pF5Trs9Ph8RVF20T1Ib0=; b=Yf7Fif6nPkaaSVI/xvdE9mfbMP
	QdXu1MI+7vjxb2/wVe6xYz9eGlekFdNKWlsb6XlxrTRBZT2g7FKFxqVDoyyqIB0ik5aTlAUzCCnMj
	w3+EgQRz9ZF0vQWhPcPJ6emIWXt+IRFHjvZcSaCgxNajY4Dx96dcSdfelJ35PBkCllfDYqgXDt+LG
	TBgXppz8RkhtOMnBOAIuar5QspnqqzGMAWI24QNbbi5TaWXBP+uyTn+6MW7Xpg2LDPJADlSkaR9Ix
	ilKUVP0Va8iES5XdVMr1T/lDU5dSowDIZbY50JWsvGngswAJXTyy83fHYHf2L1b91Ftk8w75kvxSU
	gDzDaUwQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfgaN-0000000Dgvg-2sfO;
	Thu, 29 Feb 2024 13:36:31 +0000
Date: Thu, 29 Feb 2024 05:36:31 -0800
From: Christoph Hellwig <hch@infradead.org>
To: David Stevens <stevensd@chromium.org>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
Message-ID: <ZeCIX5Aw5s1L0YEh@infradead.org>
References: <20240229025759.1187910-1-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240229025759.1187910-1-stevensd@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 29, 2024 at 11:57:51AM +0900, David Stevens wrote:
> Our use case is virtio-gpu blob resources [1], which directly map host
> graphics buffers into the guest as "vram" for the virtio-gpu device.
> This feature currently does not work on systems using the amdgpu driver,
> as that driver allocates non-compound higher order pages via
> ttm_pool_alloc_page().

.. and just as last time around that is still the problem that needs
to be fixed instead of creating a monster like this to map
non-refcounted pages.


