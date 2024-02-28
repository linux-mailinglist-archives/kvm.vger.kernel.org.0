Return-Path: <kvm+bounces-10184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7770A86A666
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 03:14:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BCCB1F23C87
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 02:14:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E97124C90;
	Wed, 28 Feb 2024 02:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0i0OrbSj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EAC23BD
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 02:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709086461; cv=none; b=uIwNMiheh/u5oiDGCTNk+Kk9elouqfsuucNBVrhpx01MjrkqwE5aegpLu3oM+Fa0u0kp38QdwUULGBbJUvimqjAnXSHQS3KB0C94i4cLgmDGBNnRz/r5pg0SrEbTw2dAga0Lp6S4+9ZGKXvpe+zF/6tywe39GqueZNzphNVhXOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709086461; c=relaxed/simple;
	bh=4nDFMVvXgmxDw5zoXxRPs5AqF78/zhUArZTZnzRWccg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GufP9lzs50bmwNQ534iMsDu6MmPHlqOxRfVRbWs7QimQP07zcsG2+47TxdD+jFfG6UjpotoX/MMTDVB9lIO0Q/8aVNfy8+8gtyk5hiAC57Z3JHkKeHw29jUTUO+gFzQSJvfLtOsUxLcfAnhbWbskMSVuw+3Hcx58eUBHMYqzMjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0i0OrbSj; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e54421b20eso1546666b3a.2
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 18:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709086459; x=1709691259; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uBsEB2bWKTc3gmkwF5a0wpcJFcu32yAcOr3T6FBTFEA=;
        b=0i0OrbSjBqJGow1/ZwpoGuASiWbNm3QqNm52ZsY/GtatRqoev6IheAKiHa/tXmxfit
         3feK+jFvfc+rGCUwrL+Y3EJWeyiZA9gKbjxBqalA/i48w/TSaotMVoi7tXL5vwnQfSFr
         aMXgGYmGKe104NFMH441mUGYqy6gnAw96vvXqoe777brPHtV7XDxTjpt8GUs77HrrLmZ
         7y2hBLjcCC5L5z19Y47DM7Txipaw26Xn/mUAzHtsfnf1+BRQCE/yEt75dXAPedBOU+En
         g4LHuMGjbzIyX1vrobVseSp4sF2o4ekurzar2Dk3eYjxWEKtcha4ESaNzHWvQqryBCT/
         HP1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709086459; x=1709691259;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uBsEB2bWKTc3gmkwF5a0wpcJFcu32yAcOr3T6FBTFEA=;
        b=O+kNYAKNpcC1jLQ1HWOUSLqRWPl4Jdc0hcWfdbtmt8IWrnd+r0+HIpsEgNS5YN3k8G
         Khmkrq3AfoMK+ViQ9ko7VzaFm31dz8Z+8ai9hebazNCF2sNwi/nEqtszZ4dBhDSHkUBE
         rD+2/7ypH7Ua7RAvrS4Sha1gia3bkCQR0ukSYWIAIDwFooaMIuEDChuycxY1qZiP4qGP
         JPDmyZs756tkJ4nf1P4R+IJUC+Dg0mJKnrcnClCuCOS1UYBCoaNJths9s0nW85rErD0H
         HC21FtoBCV1TotDwL/6pp7oezFmC0u1Md6av4I1iMBaA6d3zD2M3f2spyw7Xifx+ZSse
         D7Qg==
X-Forwarded-Encrypted: i=1; AJvYcCVl9PitLVZDF+gdwHJpFlc2kol+F4qm5bvebOiufzBShJH05QwsrqM4iveradiaGSrVXut0FZBEQZOaflLdD+AIVIsp
X-Gm-Message-State: AOJu0YysfNuHJVL+nDC7qn1MrXkVHHgHqqv1dxssQzTqxRlwPVH/sZbO
	NhjprZwMRFLSbvKqWW3LIU8+gNhLfEoeECdWLfRPzGITdeXv1y9YtWdmXo+peTgvobNkgwCTBZE
	tZg==
X-Google-Smtp-Source: AGHT+IFYdHs0nOixyFuzAGGcLeL7Rj9tGJMNICeXoHorG2gmVZn6HhKaMCuru1RrJZw7Y4EZLJOUpsKv49o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2349:b0:6e5:3554:7fae with SMTP id
 j9-20020a056a00234900b006e535547faemr69771pfj.1.1709086459143; Tue, 27 Feb
 2024 18:14:19 -0800 (PST)
Date: Tue, 27 Feb 2024 18:14:17 -0800
In-Reply-To: <20240227232100.478238-18-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240227232100.478238-1-pbonzini@redhat.com> <20240227232100.478238-18-pbonzini@redhat.com>
Message-ID: <Zd6W-aLnovAI1FL3@google.com>
Subject: Re: [PATCH 17/21] filemap: add FGP_CREAT_ONLY
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	isaku.yamahata@intel.com, thomas.lendacky@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 27, 2024, Paolo Bonzini wrote:

This needs a changelog, and also needs to be Cc'd to someone(s) that can give it
a thumbs up.

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  include/linux/pagemap.h | 2 ++
>  mm/filemap.c            | 4 ++++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 2df35e65557d..e8ac0b32f84d 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -586,6 +586,7 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
>   * * %FGP_CREAT - If no folio is present then a new folio is allocated,
>   *   added to the page cache and the VM's LRU list.  The folio is
>   *   returned locked.
> + * * %FGP_CREAT_ONLY - Fail if a folio is not present
>   * * %FGP_FOR_MMAP - The caller wants to do its own locking dance if the
>   *   folio is already in cache.  If the folio was allocated, unlock it
>   *   before returning so the caller can do the same dance.
> @@ -606,6 +607,7 @@ typedef unsigned int __bitwise fgf_t;
>  #define FGP_NOWAIT		((__force fgf_t)0x00000020)
>  #define FGP_FOR_MMAP		((__force fgf_t)0x00000040)
>  #define FGP_STABLE		((__force fgf_t)0x00000080)
> +#define FGP_CREAT_ONLY		((__force fgf_t)0x00000100)
>  #define FGF_GET_ORDER(fgf)	(((__force unsigned)fgf) >> 26)	/* top 6 bits */
>  
>  #define FGP_WRITEBEGIN		(FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE)
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 750e779c23db..d5107bd0cd09 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1854,6 +1854,10 @@ struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
>  		folio = NULL;
>  	if (!folio)
>  		goto no_page;
> +	if (fgp_flags & FGP_CREAT_ONLY) {
> +		folio_put(folio);
> +		return ERR_PTR(-EEXIST);
> +	}
>  
>  	if (fgp_flags & FGP_LOCK) {
>  		if (fgp_flags & FGP_NOWAIT) {
> -- 
> 2.39.0
> 
> 

