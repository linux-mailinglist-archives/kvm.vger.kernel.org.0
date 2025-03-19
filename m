Return-Path: <kvm+bounces-41523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EB36A69BFA
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 23:22:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D21A18A4D58
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 22:22:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 685C721C9EA;
	Wed, 19 Mar 2025 22:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i12ijldI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBD821B9FE;
	Wed, 19 Mar 2025 22:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742422928; cv=none; b=APglaSnUvj6pA7cLT9uXssXXfRE5fWsg0cSEzOoMDc9SsLXvKlQgXTVLFsjiZbEr7O6VIquCN82gGsegvCye1PjI2T2PH6tM4UazMlqdBopjeAn/hnTEMH/DiNNDJH2M7RKl7MueWP/8e/zoDSLsO6K2VoG0jXPCDGDotuHmA28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742422928; c=relaxed/simple;
	bh=xqfK+KqTEmnvRkw96spNfhu/mnuaNMYujybAAL7pUSE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HqDOo6UJrPEtLt+ARFri+0XDEzrvOWXy3Scwku5aP5Trl0yLbmEyF3pVNTOIPU+AwWP0mjHYosH0QvuVsvPzEfDtHnsWR82txTM2NBMsvsZW5SIsIxtEKAd/TT79j7f52Vhd1Vjd2oGiHuhL17tHk5Dn6x2K4UWP38cfK0k/9I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i12ijldI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6922DC4CEE4;
	Wed, 19 Mar 2025 22:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742422928;
	bh=xqfK+KqTEmnvRkw96spNfhu/mnuaNMYujybAAL7pUSE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i12ijldI5N0ICNvlgfikLn9YZT+PfpoaQYGzVCqV5QVQakxF/kzqU2Lqv2CAB6IHV
	 oukxy6WIyS2CbLWL7kxfJdMzkQu7gqAxRZOAa1p2mfOrX+2GDDmeDGZqVjp/kO/OLY
	 lwEEla+OizUzPM7ncFgeV1l4jIsIX4q4G8RT1EJZzEiZKhwLbsiVu+L39WLQHfLziX
	 5bZhlsYi0RShAQ0VdBbdCe0vn/QJAWYr/WEw/0VnTz19eLmx/UXR9f4QnnLZ+9C87U
	 7MKDh9fs6qsNuxlXnfxJaI1+lKuR+cSMWr2KN6CCJDgb4WPeN3wUpXKgXYd3V8OUrd
	 1bYWGngG+fTXg==
Date: Wed, 19 Mar 2025 16:22:04 -0600
From: Keith Busch <kbusch@kernel.org>
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>, Borislav Petkov <bp@alien8.de>,
	Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
	David Hildenbrand <david@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 18/19] mm/arm64: Support large pfn mappings
Message-ID: <Z9tDjOk-JdV_fCY4@kbusch-mbp.dhcp.thefacebook.com>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <20240826204353.2228736-19-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240826204353.2228736-19-peterx@redhat.com>

On Mon, Aug 26, 2024 at 04:43:52PM -0400, Peter Xu wrote:
> +#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
> +#define pud_special(pte)	pte_special(pud_pte(pud))
> +#define pud_mkspecial(pte)	pte_pud(pte_mkspecial(pud_pte(pud)))
> +#endif

Sorry for such a late reply, but this looked a bit weird as I'm doing
some backporting. Not that I'm actually interested in this arch, so I
can't readily test this, but I believe the intention was to name the
macro argument "pud", not "pte".

