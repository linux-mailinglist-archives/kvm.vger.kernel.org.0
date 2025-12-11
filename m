Return-Path: <kvm+bounces-65797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 847D1CB7204
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 21:11:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7FF753018431
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 20:11:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 234FE31AA93;
	Thu, 11 Dec 2025 20:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t+MNRw80"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346E5229B38;
	Thu, 11 Dec 2025 20:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765483881; cv=none; b=F0p2N+P4yQqwfv+RgkXW0nre4Da5TZXaW3rc4Z77KV9V11cxQW8+h0JfUk7/yVoqp9NOcZL41ZgG5RcCilkYYDo/S2HWhXMiDBHCsMNNd9E4//stXoF9r0bQ4l+ZA6l8/a3Z40IEPLerxs5QF99Zl+joqiMlnkiJC/tgKWV0kz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765483881; c=relaxed/simple;
	bh=hvv30Ubhv2ost49RLGAz7UHR7RNidRTm8ejb5Fnwvcs=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=bLhGQNHi8DWZShDhBlSC4unER4pBS8kgS3nd99Jt1xPiO751z0PkQO+uCQhBlL3E4c9LNYjU2x+B0CLYjzHofdrcYK6+COHVbHVLw1bJwn9X7p90bTmIInClSxlleGb9EWPCw3mG10uoyBkhR0Uz+A63iH54QM66Ay64soVXwgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t+MNRw80; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9772C4CEFB;
	Thu, 11 Dec 2025 20:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765483880;
	bh=hvv30Ubhv2ost49RLGAz7UHR7RNidRTm8ejb5Fnwvcs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=t+MNRw800my4MEFowljyIIUObRxfxjqrgwieAoFEvcCzoYUJJZsGwjXxC+IANhjBy
	 MtltwwlP37apbn4K2x4NXEnCVDz9cQbUoq75lE/DtLsLjahHv6yuae2TRBqyiIogi6
	 Jx1xttCkWrA6C/ZbI6NpswyVnusFemqXqFdlzo3w=
Date: Thu, 11 Dec 2025 12:11:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: <ankita@nvidia.com>
Cc: <vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
 <jgg@ziepe.ca>, <skolothumtho@nvidia.com>, <alex@shazbot.org>,
 <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <cjia@nvidia.com>,
 <zhiw@nvidia.com>, <kjaju@nvidia.com>, <yishaih@nvidia.com>,
 <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH v1 0/3] mm: fixup pfnmap memory failure handling
Message-Id: <20251211121119.0ebfd65ed69b5d5f6537710a@linux-foundation.org>
In-Reply-To: <20251211070603.338701-1-ankita@nvidia.com>
References: <20251211070603.338701-1-ankita@nvidia.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 Dec 2025 07:06:00 +0000 <ankita@nvidia.com> wrote:

> It was noticed during 6.19 merge window that the patch series [1] to
> introduce memory failure handling for the PFNMAP memory is broken.
> 
> The expected behaviour of the series is to allow a driver (such as
> nvgrace-gpu) to register its device memory with the mm. The mm would
> then handle the poison on that registered memory region.
> 
> However, the following issues were identified in the patch series.
> 1. Faulty use of PFN instead of mapping file page offset to derive
> the usermode process VA corresponding to the mapping to PFN.
> 2. nvgrace-gpu code called the registration at mmap, exposing it
> to corruption. This may happen, when multiple mmap were called on the
> same BAR. This issue was also noticed by Linus Torvalds who reverted
> the patch [2].
> 
> This patch series addresses those issues.
> 
> Patch 1/3 fixes the first issue by translating PFN to page offset
> and using that information to send the SIGBUS to the mapping process.
> Patch 2/3 add stubs for CONFIG_MEMORY_FAILURE disabled.
> Patch 3/3 is a resend of the reverted change to register the device
> memory at the time of open instead of mmap.
> 

Strictly speaking, [1/3] is suitable for merging in the 6.19-rcX cycle
because it fixes a 6.19-rcX thing.  But [2/3] and [3/3] don't fix
anything and hence should be considered 6.20-rc1 material.  Yes?

So unless I'm missing something, I'll grab [1/3] as a 6.19-rcX hotfix. 
Please prepare the other two patches as a standalone series for
addition to mm.git after 6.19-rc1 is released.

Thanks.

