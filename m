Return-Path: <kvm+bounces-67974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 417C5D1B034
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 20:21:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B16173032701
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 19:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EF1536C0C3;
	Tue, 13 Jan 2026 19:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a5YCTcbt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5033E34F26F
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 19:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768332092; cv=none; b=FvqFHmeG9qj9rXZxi+SZ3+gdDcw7wzu1c+vdmlxBRwGzlIcjdEomH1GLEsZIQ42KogYmwE10Hs1k1s4tFwvYzboE1mkuJRdNKrGgVzcf9p6ZK2PCV8O5Q/uZBSW6aDfvx8prfwF+FEa4hSyVsp/+4+lE1qhrc5jyLouYPoSJ7ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768332092; c=relaxed/simple;
	bh=7Cta7CaeBQalDzt6VDM5OOi0esSeOHB4X7bUzLxzlJc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dxe4Zwu7/OmVzeZfA74Eb9s/log+i405r7gsSUCBpGninU7VmVWGeI3Tjes5eO2TdSRDYMyeWK8AAOc+B7CaG7XrMAWdI9wg94ymzvF4PJQ3/vhJ2Ka2yaSk6A04BScbgKxIuApFMxqX8bGxuVAseKTuqOEphDIS8TeYUKDx8Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a5YCTcbt; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c37b8dc4fso15039121a91.2
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 11:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768332091; x=1768936891; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cd9IICRIq3DTaCVl8VXn5p++y32sGJCFM6gcMQfVFro=;
        b=a5YCTcbtSlJlrGPv6ATxohSHN6KIpK/kTXRZERJCL4mxRp4gYZWRkdOCesGESbqqce
         x0lfUJA+/5SK8RHipWpdcxwuSRRhT8UNUpANHFFV8h8SxlbCxYTBh/KdgHtjDJdGHcIV
         k83bDIM/Sd9MWWs1fkqQGHFlNlPZjwN88dA3dElfrxVJJIyNKWgPLh99T4Uw7fk+0YAG
         Wzps1O9xgbHvbqPcLIzZ6bZjJLb9ftU3dmBpfxa0oXPZrrLAGGeU8Y92RX6jQgMzFTTy
         WNgzYW0nTnuWmHjJMKY+D27Rx6vwiX1G77bdRW+9R7G2wzXqTsD/IBpIwnr1AHAUcP4u
         GjYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768332091; x=1768936891;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cd9IICRIq3DTaCVl8VXn5p++y32sGJCFM6gcMQfVFro=;
        b=OEZm3k9PZoK2p9pzyTackhD6oVXwBpjsalKJmkLxuZetODQrxxdmGMJ8HTNIZ3zfTe
         z3lLiYe/8y/RykfgMYZ5XsLatB2yA9tm0yzNFAQbeBChJjfLeOiTuedkYBK9rgMDp/pL
         6NedReYFdJQAWg9R8cuq1wNRDP/OosZJbF1lg1KUvsNZpDjjcAKyKlmw0BROvurBGf5s
         Acd54wpXKnhiyugUjcjpAULLHIf6Pw8jxWWARfYLYET2JMd7XPE9VpEYCnoRmuP9SQA9
         LWEZNfKPeYS2h9iOKtG3Q9XOufdtsE6KVf94eZ2NQ+8EH3mP3nMaVJ8S5TnL0srnZN8a
         237w==
X-Gm-Message-State: AOJu0Yx65/D2RQOpwWKJoleTLLy2sZHeZ6knNrFrRhAuVMf6T++VTlJM
	cZHqW1LWUHj1U6Rv+Baf0uQ8R5vNsUphIinw4faeHLhxrcvHd49iGUMTpCqn++fa99jwqvEAVKV
	ci72d9g==
X-Received: from pjut11.prod.google.com ([2002:a17:90a:d50b:b0:349:3867:ccc1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d50:b0:341:8ac7:39b7
 with SMTP id 98e67ed59e1d1-3510913cc0dmr105362a91.25.1768332090565; Tue, 13
 Jan 2026 11:21:30 -0800 (PST)
Date: Tue, 13 Jan 2026 11:21:29 -0800
In-Reply-To: <20260108214622.1084057-7-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260108214622.1084057-1-michael.roth@amd.com> <20260108214622.1084057-7-michael.roth@amd.com>
Message-ID: <aWabORpkzEJygYNQ@google.com>
Subject: Re: [PATCH v3 6/6] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, pbonzini@redhat.com, 
	vbabka@suse.cz, ashish.kalra@amd.com, liam.merwick@oracle.com, 
	david@redhat.com, vannapurve@google.com, ackerleytng@google.com, aik@amd.com, 
	ira.weiny@intel.com, yan.y.zhao@intel.com, pankaj.gupta@amd.com, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 08, 2026, Michael Roth wrote:
> @@ -842,47 +881,38 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  	if (!file)
>  		return -EFAULT;
>  
> -	filemap_invalidate_lock(file->f_mapping);
> -
>  	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
>  	for (i = 0; i < npages; i++) {
> -		struct folio *folio;
> -		gfn_t gfn = start_gfn + i;
> -		pgoff_t index = kvm_gmem_get_index(slot, gfn);
> -		kvm_pfn_t pfn;
> +		struct page *src_page = NULL;
> +		void __user *p;
>  
>  		if (signal_pending(current)) {
>  			ret = -EINTR;
>  			break;
>  		}
>  
> -		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, NULL);
> -		if (IS_ERR(folio)) {
> -			ret = PTR_ERR(folio);
> -			break;
> -		}
> +		p = src ? src + i * PAGE_SIZE : NULL;
>  
> -		folio_unlock(folio);
> +		if (p) {

Computing 'p' when src==NULL is unnecessary and makes it hard to see that gup()
is done if and only if src!=NULL.

Anyone object to this fixup?

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 18ae59b92257..66afab8f08a3 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -884,17 +884,16 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
        npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
        for (i = 0; i < npages; i++) {
                struct page *src_page = NULL;
-               void __user *p;
 
                if (signal_pending(current)) {
                        ret = -EINTR;
                        break;
                }
 
-               p = src ? src + i * PAGE_SIZE : NULL;
+               if (src) {
+                       unsigned long uaddr = (unsigned long)src + i * PAGE_SIZE;
 
-               if (p) {
-                       ret = get_user_pages_fast((unsigned long)p, 1, 0, &src_page);
+                       ret = get_user_pages_fast(uaddr, 1, 0, &src_page);
                        if (ret < 0)
                                break;
                        if (ret != 1) {

To end up with:

		struct page *src_page = NULL;

		if (signal_pending(current)) {
			ret = -EINTR;
			break;
		}

		if (src) {
			unsigned long uaddr = (unsigned long)src + i * PAGE_SIZE;

			ret = get_user_pages_fast(uaddr, 1, 0, &src_page);
			if (ret < 0)
				break;
			if (ret != 1) {
				ret = -ENOMEM;
				break;
			}
		}

		...

