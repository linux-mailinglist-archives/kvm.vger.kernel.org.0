Return-Path: <kvm+bounces-37599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C1D4A2C6A3
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 16:12:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0A903ACEEC
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 15:12:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BD8E1EB1A4;
	Fri,  7 Feb 2025 15:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M/Tk/r+P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE08C1EB192
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 15:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738941128; cv=none; b=h4B7zcJMUYnBeDpO9TWj3T6jy/mrvMyCAqZ+2sdk3gbG8OstV/WBc5v3VOsVNnw+AklhFbYAwcjKtG4QDr/YFdkkYCP92jAoj0R0Sc4r7K9SlwX3jruR49SqII4M3oNjp1rdgEliLxMF/cHd0fthtfC35vkO3/iici+F/jBGRvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738941128; c=relaxed/simple;
	bh=7WeBIy2sejYk+BR4w9p25NFRkBTZIswmq3mry9An0iw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oRuDGPPSscO/EC9oIvC544wEvzI5X9j0f/s2BdoYNdoDo7w70i7tjbVqckbBXLQGR4tToVr23jHjDrQSvOXH6QC9VVmYFOPkGOW41quWsDaZwXKw0IgaarwSbWa8awAqKckG3TLLs1/vxBYI7OlxGIob2ky2TYCAQxNwwhUq8Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M/Tk/r+P; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fa32e4044bso873210a91.0
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2025 07:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738941126; x=1739545926; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LxVXEzr2oQzIGSnyax9BmL0hTrsx3WZN3f0e41uCa0k=;
        b=M/Tk/r+PPIisRQBBW2/p+0l7LRkGjGwrCUiizFkYwTEZ2nC+Pwruubw8KKEke4lO6J
         VzsJXYFOGxI4c89CzbMYIAdzaQ7EGNmkdV0K2kdIxBI3w9z96U/0SwhO5OrLe+w9NV7I
         shq6baIghdCk5CkeRDALH4Fy6M7IZqkTbn6b/FjvJ6MWxRoU5ZzOUM5Rr63VrQ1lf/O9
         xR+JuFTWuGCeqnHwgnU7ErAuqQvWWE1Nz0R9eUgLzMFs/FM19F8ty3VpWtrb5wZVTTn+
         T3K+QJBDlfrOZh1r1uuY8KdpFSepD0abZWAmRoNxZr3+j8UPBoIjAuncs+VvGAlxouoC
         A1Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738941126; x=1739545926;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LxVXEzr2oQzIGSnyax9BmL0hTrsx3WZN3f0e41uCa0k=;
        b=JWrIj++FrjIsRCqZUdvDHTeZnXnuIcru4vohWLujTT43zZaeIlyk3zGQqjCsKzoldb
         XGGpO9HdjjbEhQ4pMOeCW9OYlilQq214ITw2dxeaHLmtz4JNvV+Xp50Svja8Jk/2uUgJ
         UGTALmKv04jaEF1fjMOfDoQ77ET9S0ys70cCv0hclrBp3bVjn03MVFnC9G0sVntsHsde
         kFwSZguN8kKShWT2p2ltIcsI/C/xy9iDS6qcn3u63+ScXMbpqzAI86NLBUNLX7lKMrwq
         G9Pst7h44daNDsNU/C7Krir7vZUbmNY8eFXdHvx7/8JM8u+L83yyV3po+iVt46wFXwfx
         X/YQ==
X-Forwarded-Encrypted: i=1; AJvYcCUd3GlL/Qzfue4jcRvuTWMDjrLkKUvr9C/zHAbie/1jht6mHiQKQx7qw9vFb8S9nmO7ERA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPPLFHDMvbzH8nq6ytKXTljDDqBqTNhFWz1a0J1hERQdniKk7K
	EQVfKNzHbpcq2FBBNzz3G1QQzvZ8UK8JypZgeU9Fs6PXIswzWUpM/krQ/CSJppAc013NnZrMhGa
	6ZQ==
X-Google-Smtp-Source: AGHT+IFGLXHzNrNOdKG1czY4jTF73FsqIGqlSCN04qJ3RgdhuYV6jC13Lajj/ww4zk3yzh9N7Wq07gYnLLg=
X-Received: from pjbee11.prod.google.com ([2002:a17:90a:fc4b:b0:2f2:e97a:e77f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e41:b0:2ee:a583:e616
 with SMTP id 98e67ed59e1d1-2fa24064ed1mr5606353a91.9.1738941126259; Fri, 07
 Feb 2025 07:12:06 -0800 (PST)
Date: Fri, 7 Feb 2025 07:12:04 -0800
In-Reply-To: <20250207030931.1902-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250207030640.1585-1-yan.y.zhao@intel.com> <20250207030931.1902-1-yan.y.zhao@intel.com>
Message-ID: <Z6YixPh_j517vqcP@google.com>
Subject: Re: [PATCH 4/4] KVM: x86/mmu: Free obsolete roots when pre-faulting SPTEs
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, rick.p.edgecombe@intel.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 07, 2025, Yan Zhao wrote:
> Always free obsolete roots when pre-faulting SPTEs in case it's called
> after a root is invalidated (e.g., by memslot removal) but before any
> vcpu_enter_guest() processing of KVM_REQ_MMU_FREE_OBSOLETE_ROOTS.
> 
> Lack of kvm_mmu_free_obsolete_roots() in this scenario can lead to
> kvm_mmu_reload() failing to load a new root if the current root hpa is an
> obsolete root (which is not INVALID_PAGE). Consequently,
> kvm_arch_vcpu_pre_fault_memory() will retry infinitely due to the checking
> of is_page_fault_stale().
> 
> It's safe to call kvm_mmu_free_obsolete_roots() even if there are no
> obsolete roots or if it's called a second time when vcpu_enter_guest()
> later processes KVM_REQ_MMU_FREE_OBSOLETE_ROOTS. This is because
> kvm_mmu_free_obsolete_roots() sets an obsolete root to INVALID_PAGE and
> will do nothing to an INVALID_PAGE.

Why is userspace changing memslots while prefaulting?

> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 47fd3712afe6..72f68458049a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4740,7 +4740,12 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  	/*
>  	 * reload is efficient when called repeatedly, so we can do it on
>  	 * every iteration.
> +	 * Before reload, free obsolete roots in case the prefault is called
> +	 * after a root is invalidated (e.g., by memslot removal) but
> +	 * before any vcpu_enter_guest() processing of
> +	 * KVM_REQ_MMU_FREE_OBSOLETE_ROOTS.
>  	 */
> +	kvm_mmu_free_obsolete_roots(vcpu);
>  	r = kvm_mmu_reload(vcpu);
>  	if (r)
>  		return r;

I would prefer to do check for obsolete roots in kvm_mmu_reload() itself, but
keep the main kvm_check_request() so that the common case handles the resulting
TLB flush without having to loop back around in vcpu_enter_guest().

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 050a0e229a4d..f2b36d32ef40 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -104,6 +104,9 @@ void kvm_mmu_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 
 static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
 {
+       if (kvm_check_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu))
+               kvm_mmu_free_obsolete_roots(vcpu);
+
        /*
         * Checking root.hpa is sufficient even when KVM has mirror root.
         * We can have either:


