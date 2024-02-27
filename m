Return-Path: <kvm+bounces-10093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8B3F869991
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 16:00:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8272F291E20
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 15:00:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67FCC1468E7;
	Tue, 27 Feb 2024 14:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lmaIYYKc"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E72146007;
	Tue, 27 Feb 2024 14:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709045788; cv=none; b=gvBjPUsPjXmmvYtUyUNN+HJJxP58UWEZB0H/tUtNhNAnQIybQneQqEnJZaimrr9FXNAHWHyUprG1LGzmeYLtjU8V5pDP9l6fgt5l1gUJKENt1P5d9z86uCRtBeLjQheHVUDRtuJrSY2qlfrk9oPypJqmTiQ0PFx61AKxNmTHjeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709045788; c=relaxed/simple;
	bh=jkvS5IEUlexLMzi9YaTCofuaeiGGJdulU1sw+B33Fp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eTX1tUsmyoaGaAXF2u4Xb4kFU/X64l3eUoqbv6T3unKhlruFeGIenZ2ImsnEQCoVT8CtpBQoLzMVMricg/KpfSM/BLkyYgoJ7rSe/FVehx3tVZMsdp+UuQ5IZQ42Nt99FNCI0XuHmSKi1vlRMG4mYdLrCWrYwmXqv92tDwlhTXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lmaIYYKc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hLM3ZYcMVlAYK7EAgbT5vu/7Bnt6Qc68h0caJ544S1I=; b=lmaIYYKcm7hShVWhaoiTl29tlr
	nMNxuJ9C0IriMQ/cfayoh4pzizUWpSK43m3u3GXusl3oVNx74ueZyKkbtZag7nX3XFF/9Bw2YV5lB
	SWwTpmFKecHojxXFkEufjkGsZ507jCvbYzC/mo8BUXxoce5GJqK0C/CLAfDb2zaFtX+hprYArHlVm
	KbBJGVZWk3vN+BkDchH8pCJZ+gdoejci7ezKCP92FlC5aFfwHjcWxCZe9/GQysmDYLIq9M0CJbQVI
	c6RLTIaI/vQDvKmfOld+Ol0ohlI1/LEne+MEoqk11Jgc+1uxJJo+b0vst3F8qH/vuI0PhDWp0dB9K
	SIEw4Dbw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reysa-00000005fTH-3S62;
	Tue, 27 Feb 2024 14:56:24 +0000
Date: Tue, 27 Feb 2024 06:56:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org, Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org
Subject: Re: [RFC PATCH 15/73] mm/vmalloc: Add a helper to reserve a
 contiguous and aligned kernel virtual area
Message-ID: <Zd34GHtHlnpPtg5v@infradead.org>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
 <20240226143630.33643-16-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226143630.33643-16-jiangshanlai@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Feb 26, 2024 at 10:35:32PM +0800, Lai Jiangshan wrote:
> From: Hou Wenlong <houwenlong.hwl@antgroup.com>
> 
> PVM needs to reserve a contiguous and aligned kernel virtual area for

Who is "PVM", and why does it need aligned virtual memory space?

> +extern struct vm_struct *get_vm_area_align(unsigned long size, unsigned long align,

No need for the extern here.


