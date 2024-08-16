Return-Path: <kvm+bounces-24460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B6D599553CE
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2024 01:38:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D6391F22D02
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 23:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BED71482E1;
	Fri, 16 Aug 2024 23:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="acN0+rDe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FEC1459F7
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 23:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723851489; cv=none; b=YGTtUeB8f2P59OkCNQywy2lFYlqF0nznsN8Z5gAcmE5DfKRSJRlRb7KreCTEKJKNa7pHi1ZPLaFCzk3SH1lPZVMAz63KhXQZI2AmhI7IuoF2AI2yqb9r9OmdXjxaskB8kkOjwm6QuG+Dne5GbiO3BR2Dbs1vqbG3aQ3FBC1yUT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723851489; c=relaxed/simple;
	bh=Y/+GOpDSzsK+M2joesQEHhyTfRfgx6dQoGr2ckDIQ94=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NcULdOMczedLuDMABPja/6J2QOWkEtaqBhMt/mt3bHlnOKcSebsA+ZRVEqMG2sxN3owH1NtAFz4xjD42Smd5/8hLqkAsTtnmGmt0Ue0Kpd8bmNA9XCyAvPOPQyLYVTHFK+ll++AktxEvrbRmsyLoEg2+zRjscptbG4J9ULeIErc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=acN0+rDe; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-713d4a9a3ffso438013b3a.1
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 16:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723851487; x=1724456287; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RTcVp0/hDkDmdE0O3eFD0NUXBKlO6QGLbLpx53J90N4=;
        b=acN0+rDeHyPQwqte9lFiEDzfBe4n5PI4+eiTCqJy2n4t1vZ4RloBZDcOXG/C2Hoj/8
         6sjDDrtn4n7DEvFof7xqTjuWjAuSMRiWr1WwlvVcijOFN3QcYGDrrL3HmBLG7C+sej0S
         KTbUWC4VYNj73KtV2fevxaOV6r5pTyk4dlkLH0rpFirA9itUuY/kr9EyyJ4ETEZfCIzD
         eQu/lyEHS96a74RAv+R+ijE20Ni7Zr2b6pcwLCGu2s2Hv+gRWlZO3RVuHTKHQhgIwMcQ
         htmU2YQFEOb516JvwJUa2evWIDWF3RWiFZH+X1VCeGYBm22zz07vBiVQIUKrM9zVE4Gx
         QcmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723851487; x=1724456287;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RTcVp0/hDkDmdE0O3eFD0NUXBKlO6QGLbLpx53J90N4=;
        b=jSUsrjTw2olzshvaGwTQmkpzbsw6k/Hsa8xcWY+ESh79aUZzrt2bTs4iMQ2Qv1mx3v
         RtNseG6J3ng2m8Dg0cmd8whPfesKlihWtEZoVXpqA1NHonRGC5hIhs6/AQoGae6SNFwd
         SYvFO3q13rouh0xEiM9+mago0H+cqRYo/uW5vUQQ4nSw7xw5reknxhAaisd1Nmb2EmAn
         O34sZyf1q7y1SVblR8nKvSqgeo8aKJSk7BMtk3i//L+q+lrBqWs9KE1uCUq3zciKSj1+
         IzOD17SFt13/KcjhpYmQ4UabLlpqonKWV8VEgSlCe5uTfKy4/VrUjk1jBQr0lSxjVh3/
         HW/A==
X-Forwarded-Encrypted: i=1; AJvYcCX51c3+btnQ/PuJxKx/BHDiNIdSgvEGJgNs57H5/CafNBgAJLSxhKM2sm02HU9AjDotKsA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtqYMIlF9DgeHmgULEr/1VNgoAr9cUbKxfrYZG3IWt8P3/pgwo
	QFr4HJ2Q9sBKTCoPZrbgzZ6JpjusbaYJvguIoPNvJml85wwUOuRM8FVxTVj7Co6UrOljVmRKzeX
	XsA==
X-Google-Smtp-Source: AGHT+IFPiEjpU2pNJWwknUPhM6DoLa+l6jzczj/GbpouGqoqHH/veVZwucqHOJ6XnNZmWTfIdO/KC9mWQms=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9466:b0:70d:1b0d:a15d with SMTP id
 d2e1a72fcca58-7127719dd68mr86539b3a.3.1723851486760; Fri, 16 Aug 2024
 16:38:06 -0700 (PDT)
Date: Fri, 16 Aug 2024 16:38:05 -0700
In-Reply-To: <20240812171341.1763297-3-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240812171341.1763297-1-vipinsh@google.com> <20240812171341.1763297-3-vipinsh@google.com>
Message-ID: <Zr_i3caXmIZgQL0t@google.com>
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Recover NX Huge pages belonging to TDP
 MMU under MMU read lock
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: pbonzini@redhat.com, dmatlack@google.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 12, 2024, Vipin Sharma wrote:
> @@ -1807,7 +1822,7 @@ ulong kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm, ulong to_zap)
>  	struct kvm_mmu_page *sp;
>  	bool flush = false;
>  
> -	lockdep_assert_held_write(&kvm->mmu_lock);
> +	lockdep_assert_held_read(&kvm->mmu_lock);
>  	/*
>  	 * Zapping TDP MMU shadow pages, including the remote TLB flush, must
>  	 * be done under RCU protection, because the pages are freed via RCU
> @@ -1821,7 +1836,6 @@ ulong kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm, ulong to_zap)
>  		if (!sp)
>  			break;
>  
> -		WARN_ON_ONCE(!sp->nx_huge_page_disallowed);
>  		WARN_ON_ONCE(!sp->role.direct);
>  
>  		/*
> @@ -1831,12 +1845,17 @@ ulong kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm, ulong to_zap)
>  		 * recovered, along with all the other huge pages in the slot,
>  		 * when dirty logging is disabled.
>  		 */
> -		if (kvm_mmu_sp_dirty_logging_enabled(kvm, sp))
> +		if (kvm_mmu_sp_dirty_logging_enabled(kvm, sp)) {
> +			spin_lock(&kvm->arch.tdp_mmu_pages_lock);
>  			unaccount_nx_huge_page(kvm, sp);
> -		else
> -			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
> -
> -		WARN_ON_ONCE(sp->nx_huge_page_disallowed);
> +			spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> +			to_zap--;
> +			WARN_ON_ONCE(sp->nx_huge_page_disallowed);
> +		} else if (tdp_mmu_zap_sp(kvm, sp)) {
> +			flush = true;
> +			to_zap--;

This is actively dangerous.  In the old code, tdp_mmu_zap_sp() could fail only
in a WARN-able scenario, i.e. practice was guaranteed to succeed.  And, the
for-loop *always* decremented to_zap, i.e. couldn't get stuck in an infinite
loop.

Neither of those protections exist in this version.  Obviously it shouldn't happen,
but it's possible this could flail on the same SP over and over, since nothing
guarnatees forward progress.  The cond_resched() would save KVM from true pain,
but it's still a wart in the implementation.

Rather than loop on to_zap, just do

	list_for_each_entry(...) {

		if (!to_zap)
			break;
	}

And if we don't use separate lists, that'll be an improvement too, as it KVM
will only have to skip "wrong" shadow pages once, whereas this approach means
every iteration of the loop has to walk past the "wrong" shadow pages.

But I'd still prefer to use separate lists.

