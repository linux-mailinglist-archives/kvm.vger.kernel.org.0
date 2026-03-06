Return-Path: <kvm+bounces-73082-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +Bm+ByX0qmkvZAEAu9opvQ
	(envelope-from <kvm+bounces-73082-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 16:35:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BF82223E4D
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 16:34:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 099E33059735
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 15:31:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 418703E3DA3;
	Fri,  6 Mar 2026 15:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NoF4well"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B99E3E5EC4;
	Fri,  6 Mar 2026 15:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772811057; cv=none; b=jtQKFF6+m0RrWxQ4VZHm6DinZUCxshoyFE2xnBqwbqg/ggd8UXjqx/CzQSv8m07csWVGdCcfhVheWNFxCz0LOvsc5B5QPN2IOIzuRJsGdojIw+CHmS3cwhn+6FqJBOoCUkclp3pPpjsw1YcpYGmrAitzsVoXUIF48wobIQxCvno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772811057; c=relaxed/simple;
	bh=FI8J0CjY0WXJD6/7B/GSNXzO95+rzP9IqNX3Ca1r71Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rOKgsaph4t7iuQ9tLNqnVLSmFMViFKGVTWTQC0f2FHPE2AYA68usyf38HwHKLMYFKlJAYp+b5KczkdtxlE6wpbXVy3PJm/W0nrcALAHKmpCWaYggmQZj9bbbwF67JWuushtoHc/nmKT0l69DDv3qw7pu/UitRh2jc6bBrVQOYXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NoF4well; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C18C4CEF7;
	Fri,  6 Mar 2026 15:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772811057;
	bh=FI8J0CjY0WXJD6/7B/GSNXzO95+rzP9IqNX3Ca1r71Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NoF4wellfs0vfiQzzobsNQGra3x4pLi0cJws1pr+x30i0RlpCqJKZZQVnD5XctHLE
	 g4y/n6YSj8XujqnVBpKz31Y7JnvL7UdCI++Y0SE/oEzTSRkMPbe7ByH7OH4D3BASg+
	 CBo1HJsAMYGWlG30XfhhShBCL7RW1zdWCcyOy3irWZwJ1a3rHtXW66CQ3+CBkdx13c
	 bA2kvLRek/KpwCumfN4HNI3bTSoGzTxTXr9CpyY/7TbPZphiKH/pcruk7h3JU8hnnU
	 eRuhStXyC+hP6o+ghWOC/UBwAHjRz2QPAFfMVpGkg1hsRmeOSLZmW9rqScbJlP7Ohl
	 8c5r5taPhJVdA==
Date: Fri, 6 Mar 2026 17:30:45 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v1 0/4] mm: move vma_(kernel|mmu)_pagesize() out of
 hugetlb.c
Message-ID: <aarzJeKhv9S9QOnW@kernel.org>
References: <20260306101600.57355-1-david@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306101600.57355-1-david@kernel.org>
X-Rspamd-Queue-Id: 2BF82223E4D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kvack.org,lists.ozlabs.org,linux-foundation.org,linux.ibm.com,gmail.com,ellerman.id.au,kernel.org,linux.dev,suse.de,oracle.com,google.com,suse.com,redhat.com,intel.com];
	TAGGED_FROM(0.00)[bounces-73082-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-0.965];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rppt@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Mar 06, 2026 at 11:15:56AM +0100, David Hildenbrand (Arm) wrote:
> Looking into vma_(kernel|mmu)_pagesize(), I realized that there is one
> scenario where DAX would not do the right thing when the kernel is
> not compiled with hugetlb support.
> 
> Without hugetlb support, vma_(kernel|mmu)_pagesize() will always return
> PAGE_SIZE instead of using the ->pagesize() result provided by dax-device
> code.
> 
> Fix that by moving vma_kernel_pagesize() to core MM code, where it belongs.
> I don't think this is stable material, but am not 100% sure.
> 
> Also, move vma_mmu_pagesize() while at it. Remove the unnecessary hugetlb.h
> inclusion from KVM code.
> 
> Cross-compiled heavily.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Jann Horn <jannh@google.com>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> 
> David Hildenbrand (Arm) (4):
>   mm: move vma_kernel_pagesize() from hugetlb to mm.h
>   mm: move vma_mmu_pagesize() from hugetlb to vma.c
>   KVM: remove hugetlb.h inclusion
>   KVM: PPC: remove hugetlb.h inclusion
> 
>  arch/powerpc/kvm/book3s_hv.c |  1 -
>  include/linux/hugetlb.h      | 14 --------------
>  include/linux/mm.h           | 22 ++++++++++++++++++++++
>  mm/hugetlb.c                 | 28 ----------------------------
>  mm/vma.c                     | 21 +++++++++++++++++++++
>  virt/kvm/kvm_main.c          |  1 -
>  6 files changed, 43 insertions(+), 44 deletions(-)

For the series:
 
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> base-commit: f75825cdfc4c5477cffcfd2cafa4e5ce5aa67f13
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

