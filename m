Return-Path: <kvm+bounces-68414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E8BD4D389A7
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 00:17:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 775F13047AF5
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 23:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 005AE314D38;
	Fri, 16 Jan 2026 23:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EYmEKQKs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFB827A91D
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 23:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768605445; cv=none; b=MzIAjE5lf6g7Y85w6d71WK68F9i+M0n9V5ZZl5kszv/GS6TqBG5Q/yuiFmXiEimvIBIq2Zv86LNApbrkcP+6RQfn41AEYCWzEoPU4bfqcCmj9jKrpVdVFQCRi0Is84DOqN7Vaa4nLiiKC8+cO00Z1gBXkbOINwyTfnYdUdsBpu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768605445; c=relaxed/simple;
	bh=0qBlSbA0ChMdm/HuzI/7dU5XuaBntDrkKil/SdBVDFY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qgMYoW16VIMidQAJM7PNUvvN69qbTZwSvsERqQrCc4coj5h0NBVa02Uufe/yDjK/OYz8osnMemYBHHeRqWGBzWdFZFmgnkuxcM9JAYRRpXs8Qy9QMeanXK1TlZbBpmqDqe8ID2HTz0XsDRhJepDhSKztZwC8RhxLsLAF/JRygxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EYmEKQKs; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c37b8dc4fso4574551a91.2
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 15:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768605443; x=1769210243; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+UrL0diRZnQcyuy4C6t9WTvNDG8qIGeRluOfajJMlJk=;
        b=EYmEKQKsgNOrKWG4DVdke+efpFWrpgEgfnW2CGuG8ppOuqqiMvzzwJ/FzFtDsz79Ot
         MgdVlAih+MUkv8J1Gg5OzJmJQktDqnBTQIa7XkZBuDNVqQc51ECUZbjtyqwUpQDK5jEG
         pOHjzvcWl30WuJxUaV2+xShrIVI9QV9lxA88ZipTPYaGlaNvFH7Svqi1gMZ94TvUWzwg
         oZZkIhCfTttBOPfrXqKLU8rPOTZhqZ7TyO2hdw6WABWQYCf6D6cx8dTLfgR2253hPPek
         hWBfBAMrBP/hhHWkNu6/iYLRQHvWZ7gycgXIe2wklOr1IrjNi5bWY7cd4aSGvvRvWHXG
         dGWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768605443; x=1769210243;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+UrL0diRZnQcyuy4C6t9WTvNDG8qIGeRluOfajJMlJk=;
        b=EkrOHgi3NU+vEs5imyt7TssRkxtCHfbUX7iGPS+Q7QZ0APbRZBlRxVxhwzbHdC+6X2
         f8rdRRI7PtEOel2znG/GIqVwwEIGcK/EZ7qCn5xJijhKsFdhh505KbICWrDukslBxO5z
         AaGsQJAWkAb2iv7uuDPOeX3z1UgMUs2WmHMDxgmgVrzqAKRnSP+gEaH/zOqcQF+1FULB
         /70rtmjnFm8d7IGzfK2NBkDzMAI+C/mVmEg0lHW0C8rJliL02KkyBEwJkKPuD61P3EXa
         yvcBF711XD0vBGUhsTpXMNmoiCs3PhWTElUnhSTJoH98S3f/+1+YIxyq2gs2WdNnPnhV
         ekbA==
X-Forwarded-Encrypted: i=1; AJvYcCWv3Gn6lyepQKoj51j5J5/b08LCmQqBpuAih/waxhStKJ2Hk+Rr7GRWGjU4VI2hHkdVFks=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrLcujAYSCCRYafTsOwwKdpk6VW7oxjbGtRsZqp7rZlVOfsjK/
	yh1FuzAYv3q7xZF+jqiF84usAbp1Or+73KwJP07i0F+VHqB20xLLSzb6pVbiE5664fdH7KbnjK5
	ZrgQBCw==
X-Received: from pjqt4.prod.google.com ([2002:a17:90a:ae04:b0:34c:a015:9cb3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:dfcc:b0:340:ca7d:936a
 with SMTP id 98e67ed59e1d1-352732547e9mr3833971a91.18.1768605443403; Fri, 16
 Jan 2026 15:17:23 -0800 (PST)
Date: Fri, 16 Jan 2026 15:17:21 -0800
In-Reply-To: <20251121005125.417831-8-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com> <20251121005125.417831-8-rick.p.edgecombe@intel.com>
Message-ID: <aWrHAeMcjDpVnTBp@google.com>
Subject: Re: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
From: Sean Christopherson <seanjc@google.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: bp@alien8.de, chao.gao@intel.com, dave.hansen@intel.com, 
	isaku.yamahata@intel.com, kai.huang@intel.com, kas@kernel.org, 
	kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	mingo@redhat.com, pbonzini@redhat.com, tglx@linutronix.de, 
	vannapurve@google.com, x86@kernel.org, yan.y.zhao@intel.com, 
	xiaoyao.li@intel.com, binbin.wu@intel.com, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 20, 2025, Rick Edgecombe wrote:
> +/*
> + * Return a page that can be used as TDX private memory
> + * and obtain TDX protections.

Wrap at ~80.

This comment is also misleading, arguably wrong.  Because from KVM's perspective,
these APIs are _never_ used to back TDX private memory.  They are used only for
control pages, which yeah, I suppose might be encrypted with the guest's private
key, but most readers will interpret "used as TDX private memory" to mean that
these are _the_ source of pages for guest private memory.

> + */
> +struct page *tdx_alloc_page(void)

And in a similar vein, given terminology in other places, maybe call these
tdx_{alloc,free}_control_page()?

> +{
> +	struct page *page;
> +
> +	page = alloc_page(GFP_KERNEL);

GFP_KERNEL_ACCOUNT, all of these allocations are tied to a VM.

> +	if (!page)
> +		return NULL;
> +
> +	if (tdx_pamt_get(page)) {
> +		__free_page(page);
> +		return NULL;
> +	}
> +
> +	return page;
> +}
> +EXPORT_SYMBOL_GPL(tdx_alloc_page);

Note, these can all now be EXPORT_SYMBOL_FOR_KVM.

