Return-Path: <kvm+bounces-70824-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GBH9M8kAjGlgegAAu9opvQ
	(envelope-from <kvm+bounces-70824-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 05:08:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B2F91211FF
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 05:08:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C8755303C4D1
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 04:08:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4825B353EC6;
	Wed, 11 Feb 2026 04:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PkTm/zuc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB22347BA8
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 04:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770782911; cv=none; b=IwT3icJufBiSGHjVD6jSKGrA7oTbzOWjLQOypQen9sSj+Wd6tU0QIZZPczbZ4SGnJJ47rfHUkQ74wX6Ifi8P+As9o0ZI+J0Vr7k2YvNec6QHpDdNUb7VTXBJ5TAVzLHLdztSvM/9KISTAabHla7K9upHX9QG7+zz4Q2W/haDBCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770782911; c=relaxed/simple;
	bh=1R8Olwe8WW0a7Auax0qYBxIfntxRddpyhnQ6vhfbV2k=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=h6R986Fm2SAlBPntzf47AiqtVUyuy5EAKPDncgVC/UShdwqCR05nEv9U8JiBSrGNFBYZSPeNV2tWkYByoAa2/+hcgCKD9IDGbD0Ff8i9n/fIOYvIBoNqemuphDvpr4GOcD9LUloODpHwUjv8Z4sA8HnOe89lBpnj/eyskZ83H84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PkTm/zuc; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-81f4f4d4822so743075b3a.3
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 20:08:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770782910; x=1771387710; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=D2eMYc+39p5sjw2VZLfFJ4kKNtq8lBxRgNa5raKSCaw=;
        b=PkTm/zuclbBADyxTa58bYcgQR7OkW22FnmOgvFPvkzrcihyQWK8vN6Kcc09QljzLgk
         mDdl7of+fjtFuhWYJT21Aj48pcH+oP52xNfpyX1NM1AYYUXao9PPfFh8teRJVsKn1ffH
         qd3HF3/w0ttYygLAG/Tyyw1ZEXRcSdUZHbKIxGxkcPfN708EZXlU2E88ZbisFVpCsyDP
         KfZkfM3MmVqMWKh/fhtu7Ix+Hb/nSppGHgrRCvc5Nq4V8aZX0zVtQcBpTXC5uoh3bE3f
         vnp73VX0KKysPXMyjWq2+yKd7gwEJsY7zAWnIbB/OE1xbRM3DKqiJPt0fE40Sasyo8Ec
         elYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770782910; x=1771387710;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D2eMYc+39p5sjw2VZLfFJ4kKNtq8lBxRgNa5raKSCaw=;
        b=aOeVRGaGCy8MiQdRDr0vuLhCV6OW2yEVxiXYEy5tRnaMsq0P/m701CmvyMsjIIqhgQ
         +3tiZZO5d5iaTzC/5LTgh0I7RMhsMEA087Xl+DnvF6dftFq4BQhHSq8mmwF42m+JSKNB
         QP1jJuqp4xhkWdf4VNWBddwAWCrHRQMPwsahEfSxblIX7e874DVGEZzhlH3fUJURxORL
         SD+YJLSi3suhzZa+Wxr7D9izWTNn5cCscjtMslFJPyoUU6Tf94Jh3Ld+SLAYxhrLqN1V
         iesU02Z/wH3zTn1FUqlE5WHx6VoZ8OutVfAECb5EA37zmbt2k2YONXFwbn9oQPeI8C6h
         hJcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQA3aRFmQFKO34MsH+noXKsqsIyGB/HcVUqprfI0mYVtZU8Vn3yQ5OSsjgk/RABB2AgzU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZ8k3VIbLg2Us1dPc7gduu1Qj/RUmouevN1cWoKFXQdkpbWw8K
	NAG8y2VycycCuWFfGtPqUQxDgegOX4NRP61XtJBFQ9KBfKchrx/PsZ5j
X-Gm-Gg: AZuq6aK1RzyACXIZKCHwDVueghe8GzT4XcBgKrh8id4WoWCZb3HZwi4VltcRqFFKnZy
	rs4LJXwVtOkT1ncOVEYwEa1K9ji+RW6f7f4IiOoJFyNl2uPlXTx3U6p8QZXuvanLzVGG6YM+8MU
	oigbrXb5DX1JuRfQuQHVwhdH5gTqjjkN4X7dz7KRwia3GMucCOPfMQeLILv8/2UtMeIWiIim3r8
	LDnOSwr/eVuNs8xa1fVOfYbSAJYRIkuqvBgSBCEVpXWQbhAgADsOkvifLsvI4Xt1NHaxQHptsJ3
	2bGf2FvglDH+AhQIpXy9HpHUjOz511l0Avm/vqF1k9qxoDsaBc+5s+m7yLNzl2zETUn+1fpC8q2
	qrY1AAzAf/yW/DijFg6LTETgK8BcuHQ6ZPugDpjpTsjouV9tqPexFxcxUAD2jlPWwwAaL60wi+N
	dtMh+raW/l97gnVrqt
X-Received: by 2002:a05:6a20:c995:b0:38b:ee34:24f4 with SMTP id adf61e73a8af0-393acf8d036mr17280014637.15.1770782909791;
        Tue, 10 Feb 2026 20:08:29 -0800 (PST)
Received: from dw-tp ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e7d5e7csm568794b3a.33.2026.02.10.20.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 20:08:29 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, surenb@google.com
Subject: Re: [PATCH 1/1] mm: replace vma_start_write() with vma_start_write_killable()
In-Reply-To: <20260209220849.2126486-1-surenb@google.com>
Date: Wed, 11 Feb 2026 09:25:51 +0530
Message-ID: <874ino0w8o.ritesh.list@gmail.com>
References: <20260209220849.2126486-1-surenb@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[35];
	FREEMAIL_CC(0.00)[infradead.org,kernel.org,nvidia.com,intel.com,gmail.com,sk.com,gourry.net,linux.alibaba.com,oracle.com,redhat.com,arm.com,linux.dev,suse.cz,google.com,suse.com,suse.de,linux.ibm.com,ellerman.id.au,kvack.org,lists.ozlabs.org,vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-70824-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[riteshlist@gmail.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3B2F91211FF
X-Rspamd-Action: no action

Suren Baghdasaryan <surenb@google.com> writes:

> Now that we have vma_start_write_killable() we can replace most of the
> vma_start_write() calls with it, improving reaction time to the kill
> signal.
>
> There are several places which are left untouched by this patch:
>
> 1. free_pgtables() because function should free page tables even if a
> fatal signal is pending.
>
> 2. userfaultd code, where some paths calling vma_start_write() can
> handle EINTR and some can't without a deeper code refactoring.
>
> 3. vm_flags_{set|mod|clear} require refactoring that involves moving
> vma_start_write() out of these functions and replacing it with
> vma_assert_write_locked(), then callers of these functions should
> lock the vma themselves using vma_start_write_killable() whenever
> possible.
>
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  arch/powerpc/kvm/book3s_hv_uvmem.c |  5 +-
>  include/linux/mempolicy.h          |  5 +-
>  mm/khugepaged.c                    |  5 +-
>  mm/madvise.c                       |  4 +-
>  mm/memory.c                        |  2 +
>  mm/mempolicy.c                     | 23 ++++++--
>  mm/mlock.c                         | 20 +++++--
>  mm/mprotect.c                      |  4 +-
>  mm/mremap.c                        |  4 +-
>  mm/pagewalk.c                      | 20 +++++--
>  mm/vma.c                           | 94 +++++++++++++++++++++---------
>  mm/vma_exec.c                      |  6 +-
>  12 files changed, 139 insertions(+), 53 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
> index 7cf9310de0ec..69750edcf8d5 100644
> --- a/arch/powerpc/kvm/book3s_hv_uvmem.c
> +++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
> @@ -410,7 +410,10 @@ static int kvmppc_memslot_page_merge(struct kvm *kvm,
>  			ret = H_STATE;
>  			break;
>  		}
> -		vma_start_write(vma);
> +		if (vma_start_write_killable(vma)) {
> +			ret = H_STATE;
> +			break;
> +		}
>  		/* Copy vm_flags to avoid partial modifications in ksm_madvise */
>  		vm_flags = vma->vm_flags;
>  		ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,


The above change w.r.t. powerpc error handling in function
kvmppc_memslot_page_merge() looks good to me. 

Please feel free to add:
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com> # powerpc

-ritesh

