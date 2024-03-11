Return-Path: <kvm+bounces-11579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CE2A878642
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 18:25:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0D871C22454
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 17:25:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 304E452F8C;
	Mon, 11 Mar 2024 17:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1WKsd2Za"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43D5524AE
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 17:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710177894; cv=none; b=jAJqwaocR1h2uBamPu95b1SLmcFOib1RU7Rwn0rdYVQSaFbJDEpUtnpy2QcJd0dnKYGkkEkpPkzH7t8FCewnVfvaq5Ae8U7IFnoD8aJ7R9Bipe3NCNUF819f/DzP7VCzKmK8ZBk36RIFG1gjwx9r3eMc25diLcJBAI7fQ8NI5Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710177894; c=relaxed/simple;
	bh=XWEi7LHXquSIEQW89Dhsaa+W0TGVTzrGxEyKMs1bzG4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HZrZ0u6KEZmbw1rZVLK8CO7KQP02KZxSiTBheGqjlS9n1ItGdTlTq2/p2nL8FTR676pEnKfFxR4AB7SDGCvNeGO3t7j2vb3U1xLPh3J09ePJX2+YkzCsL7OYzSPptLRmUycudT5R7KIgDxkAufJFm+NIjbIPjOL6zVPH/cVbT00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1WKsd2Za; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60a01d0a862so45866557b3.0
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 10:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710177892; x=1710782692; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UmZfmbMNljhd7xsF5ugG1U7e5cDaKYSiE/Ydm7nW5VY=;
        b=1WKsd2Zadb2P7qkoBWxQ8e6ubhBzBjbK+mJ+ra/wHpq0aMhuYFw0IR+psLxXgmJ4h5
         5dqU4/oF7BN91pHLZULM6uvyjkwMUtZn+i0tlfwM3iYCjP9VL/R9Y/mnx5RPtzkSbzwm
         P6MVSYNB0kbnkvQcbDQU+JhSlP9+FfO5d4hsgp7PyK0csYG0Kozoeny5fYrrCB6rjjFM
         TFqgYQdMYHLkBLT3uYVvurtGYOEjRKSHPQNQao/D6vwz+xpfiEnAxeBKl9oU7JklQSTT
         7r/H0U9gArmGsVDFzFwgRoeJrJZdOLJRsVykhx76TUBVxi04vtMP8B+4dJaYbOBATKgO
         JdLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710177892; x=1710782692;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UmZfmbMNljhd7xsF5ugG1U7e5cDaKYSiE/Ydm7nW5VY=;
        b=QNWVFsXxaebQX+o2U8HR82lSVnNPs1JgOIZh8q2a3djgU0BO8waMPctDUkGa+a8oJt
         W5t1yuPrHU6I6T5dbF7zNqi2vtocn9cIHiGJNNgDbYIoPeAQcQuvWUC6261yASJeAmw6
         yRmKoO6FxwhCDrkOW+KVjF9lMZqKBFfAivomeV1teYeEmgCwQIvpZkFTcEtXzhQsDbJn
         qoUGVGV0QSmGIaLWCtpr1WQVS/PWmt+KeGv+G7ChpHFNaeYXeSR1P0Ny7zjjzH9BuNj+
         OxTh24RTnO71I3zGEmw8lppQWMS/bP43h7azrzvr6znVCkm7Srp07XkuHSpO7b3PgtdT
         Yt3Q==
X-Gm-Message-State: AOJu0YxRI7ubBjEUr+SB6+4IEms5gUiFb2w9yBdfmnAZ1WAh9Qt99ToF
	rpIhP6STpGEydLbPOutGSlFNjJPe/LpzekPchgEL5zxkLRuXDg/b7IxUG4m0/FT1wdGapBmBMTG
	1Pw==
X-Google-Smtp-Source: AGHT+IEVABktm40UKplc5dvcVtUQCh7R9y4g+7NzZVc1b+OisYBlVH4NzjyvZqhtI9Sfa389xEFRhrFGQDE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:18cc:b0:dc7:82ba:ba6e with SMTP id
 ck12-20020a05690218cc00b00dc782baba6emr389686ybb.7.1710177891972; Mon, 11 Mar
 2024 10:24:51 -0700 (PDT)
Date: Mon, 11 Mar 2024 10:24:50 -0700
In-Reply-To: <b045dc17abd4f1330406964528ade5722ab63aa1.1709288671.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1709288671.git.isaku.yamahata@intel.com> <b045dc17abd4f1330406964528ade5722ab63aa1.1709288671.git.isaku.yamahata@intel.com>
Message-ID: <Ze8-YlvprcKou-Ho@google.com>
Subject: Re: [RFC PATCH 3/8] KVM: x86/mmu: Introduce initialier macro for
 struct kvm_page_fault
From: Sean Christopherson <seanjc@google.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, isaku.yamahata@gmail.com, 
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Michael Roth <michael.roth@amd.com>, David Matlack <dmatlack@google.com>, 
	Federico Parola <federico.parola@polito.it>
Content-Type: text/plain; charset="us-ascii"

On Fri, Mar 01, 2024, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Another function will initialize struct kvm_page_fault.  Add initializer
> macro to unify the big struct initialization.
> 
> No functional change intended.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu_internal.h | 44 +++++++++++++++++++--------------
>  1 file changed, 26 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 0669a8a668ca..72ef09fc9322 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -279,27 +279,35 @@ enum {
>  	RET_PF_SPURIOUS,
>  };
>  
> +#define KVM_PAGE_FAULT_INIT(_vcpu, _cr2_or_gpa, _err, _prefetch, _max_level) {	\
> +	.addr = (_cr2_or_gpa),							\
> +	.error_code = (_err),							\
> +	.exec = (_err) & PFERR_FETCH_MASK,					\
> +	.write = (_err) & PFERR_WRITE_MASK,					\
> +	.present = (_err) & PFERR_PRESENT_MASK,					\
> +	.rsvd = (_err) & PFERR_RSVD_MASK,					\
> +	.user = (_err) & PFERR_USER_MASK,					\
> +	.prefetch = (_prefetch),						\
> +	.is_tdp =								\
> +	likely((_vcpu)->arch.mmu->page_fault == kvm_tdp_page_fault),		\
> +	.nx_huge_page_workaround_enabled =					\
> +	is_nx_huge_page_enabled((_vcpu)->kvm),					\
> +										\
> +	.max_level = (_max_level),						\
> +	.req_level = PG_LEVEL_4K,						\
> +	.goal_level = PG_LEVEL_4K,						\
> +	.is_private =								\
> +	kvm_mem_is_private((_vcpu)->kvm, (_cr2_or_gpa) >> PAGE_SHIFT),		\
> +										\
> +	.pfn = KVM_PFN_ERR_FAULT,						\
> +	.hva = KVM_HVA_ERR_BAD, }
> +

Oof, no.  I would much rather refactor kvm_mmu_do_page_fault() as needed than
have to maintain a macro like this.

