Return-Path: <kvm+bounces-15876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 557A78B1633
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 00:33:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 80A3CB23E0A
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 22:32:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 649D216E89C;
	Wed, 24 Apr 2024 22:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I6OJygM0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B80916E86B
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 22:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713997953; cv=none; b=dHVsxaXfTmDhlBcscbD0R0uYe6YrdYJnWRxAzDNvAHKoAH57R5J7yH2cScIRlWdKSOSjikeKuZCKAsIJG4MeOV6XfALxuiRpN4I5DpJyDcjJwFRXqxbmG9L2JdUoI40sgl4Dl6tmCF/zhJ0X8z7ParPAO63SKHOG49W0QqHVPgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713997953; c=relaxed/simple;
	bh=J+DEJmdO809x/feSfhv8NrKQjz9zBpNYGJ6iMTXQyQ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Nr2gnQzJkmM6tUVILA+taDPDS/ZDk3clQxNmNZS/xZ5VKC7gwBL4SwSQ2aCihdMfQUDV7GQjXQs6+mysKfXKDjL2K7P72kt4uRlrg7hUVJqeEe8BHVYIMQbNEQ47meo8czeR2++EUTfRLL6HNnK5mA/gu+BP0CgeGwJiQKE0MIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I6OJygM0; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5d8bff2b792so368084a12.1
        for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 15:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713997950; x=1714602750; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fbHAzOJmO400UI3EbfnqZCQHux+va8GoDnejftzSERA=;
        b=I6OJygM0dvXTS84Rm4hvHf0M+VGW+ZccLj+K9JZ0Ml82+64YguCZ9FTBIWLO5jNUrW
         8FX+BY2TDePQ1HCIE9lnSfeXQ64DR94Fkw9SYXzdlBrLZpdz9mqY4yz97aFA9tOgmpzQ
         3XE5eajnOcelZp8vo+5CikilW85po1HjiJMK+E6FSeflE066JkjhDVU9eX3d4RL8YfHo
         bgSGkWR8Vyr9t+V9MJPKIzVhlfiBkOSksZ8+8p5GnAMztN4OTkktbFpkOqd9NepfgU3B
         YKwKSVHZY3b93dS0f+dH8saAn58oLtxwA9Kn2ncSJ7KGlPboPBcUk/A5+P6NtrL2JgRs
         q0IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713997950; x=1714602750;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fbHAzOJmO400UI3EbfnqZCQHux+va8GoDnejftzSERA=;
        b=j5ZamLf58Ml9uwTVAartX/cXAUziCaENqbEZHLoiLVc4aDuo4P6UPxlxgDNDJxZjny
         h0EA4ZSJkdLClRdx8Oyw2wxMxfh1q3IPgkJoghgv283OvN341t3lL1wuAOZGsOQzIpby
         GdlUhFyVP2Ab8eDuY515Na8DWUjmZWFrrny9CwVDt8U7WEHb6UilWNSKymtSHsC9fEjJ
         h8iY5pLceGQS7p5emywSck6IitHn0n651g5rLdyICLvo4/Wh7F59qY/OrBMbSyuI2RYq
         etkcgE464wVKcVydnCPmnOTgH54zz8WFy9LkIBJ61sbh4LSLqN7p06uumeq/mWMUeRpB
         ZKOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUiJZ4cYESPa0HYsIxO8gm9Rk9+U3HS5zrmzrBZjbyhJv5+jLKI40Cbek+H4kne6Ffzq9sICRtfwRnwIDJDh+Fqul0r
X-Gm-Message-State: AOJu0YxzRA47k0ZgueBtqaiUCofejkOCDtbgXIVOWZlXxZh0wfyw9eY8
	/ARFqoNBI9hsNm94KB9cdAgP3hHaPV6nU3iVG+Ig6pcrzFbmzTXbbzC6Amt1MNtwOuCf8Z6txko
	6iQ==
X-Google-Smtp-Source: AGHT+IHVH74OpMP/nUdHkgxN9kdOGAEK7F25vK4oYMnoHDkLL1BvoFE0EekEgncSt0FuF51T/8OKIw4h+PI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:4714:0:b0:5db:edca:d171 with SMTP id
 u20-20020a634714000000b005dbedcad171mr56373pga.6.1713997949952; Wed, 24 Apr
 2024 15:32:29 -0700 (PDT)
Date: Wed, 24 Apr 2024 15:32:28 -0700
In-Reply-To: <20240404185034.3184582-10-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240404185034.3184582-1-pbonzini@redhat.com> <20240404185034.3184582-10-pbonzini@redhat.com>
Message-ID: <ZimIfFUMPmF_dV-V@google.com>
Subject: Re: [PATCH 09/11] KVM: guest_memfd: Add interface for populating gmem
 pages with user data
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	isaku.yamahata@intel.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 04, 2024, Paolo Bonzini wrote:
> +long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
> +		       int (*post_populate)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> +					    void __user *src, int order, void *opaque),

Add a typedef for callback?  If only to make this prototype readable.

> +long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
> +		       int (*post_populate)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> +					    void __user *src, int order, void *opaque),
> +		       void *opaque)
> +{
> +	struct file *file;
> +	struct kvm_memory_slot *slot;
> +
> +	int ret = 0, max_order;
> +	long i;
> +
> +	lockdep_assert_held(&kvm->slots_lock);
> +	if (npages < 0)
> +		return -EINVAL;
> +
> +	slot = gfn_to_memslot(kvm, gfn);
> +	if (!kvm_slot_can_be_private(slot))
> +		return -EINVAL;
> +
> +	file = kvm_gmem_get_file(slot);
> +	if (!file)
> +		return -EFAULT;
> +
> +	filemap_invalidate_lock(file->f_mapping);
> +
> +	npages = min_t(ulong, slot->npages - (gfn - slot->base_gfn), npages);
> +	for (i = 0; i < npages; i += (1 << max_order)) {
> +		gfn_t this_gfn = gfn + i;

KVM usually does something like "start_gfn" or "base_gfn", and then uses "gfn"
for the one gfn that's being processed.  And IMO that's much better because the
propotype for kvm_gmem_populate() does not make it obvious that @gfn is the base
of a range, not a singular gfn to process.


> +		kvm_pfn_t pfn;
> +
> +		ret = __kvm_gmem_get_pfn(file, slot, this_gfn, &pfn, &max_order, false);
> +		if (ret)
> +			break;
> +
> +		if (!IS_ALIGNED(this_gfn, (1 << max_order)) ||
> +		    (npages - i) < (1 << max_order))
> +			max_order = 0;
> +
> +		if (post_populate) {

Is there any use for this without @post_populate?  I.e. why make this optional?

> +			void __user *p = src ? src + i * PAGE_SIZE : NULL;

Eh, I would vote to either define "p" at the top of the loop.  

> +			ret = post_populate(kvm, this_gfn, pfn, p, max_order, opaque);
> +		}
> +
> +		put_page(pfn_to_page(pfn));
> +		if (ret) {
> +			/*
> +			 * Punch a hole so that FGP_CREAT_ONLY can succeed
> +			 * again.
> +			 */
> +			kvm_gmem_undo_get_pfn(file, slot, this_gfn, max_order);
> +			break;
> +		}
> +	}
> +
> +	filemap_invalidate_unlock(file->f_mapping);
> +
> +	fput(file);
> +	return ret && !i ? ret : i;
> +}
> +EXPORT_SYMBOL_GPL(kvm_gmem_populate);
> -- 
> 2.43.0
> 
> 

