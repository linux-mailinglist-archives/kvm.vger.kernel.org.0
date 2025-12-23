Return-Path: <kvm+bounces-66620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 877D7CDAC1F
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 23:29:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C88D030341F5
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 22:29:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 021D0313E20;
	Tue, 23 Dec 2025 22:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ChYbKd4r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78E62EA171
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 22:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766528967; cv=none; b=RCRhC07MjFlgZfr46OZTN+ZZrfrC0Q5Bi53Z+pInIO5w0DZzWyKT4IMIm5PcKPbNv5d1quZLzZXMzDT9qK3G0c8FtfNVZAY9ktK/WFhVdolpkubUd8unrzqdP35NC7i6IO8ccGcb3I9rx5EB6uZYP8mSjrg9AAVatHhBwLxU+Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766528967; c=relaxed/simple;
	bh=OkyDThQbjU98Y48PTqWT0v4KhKIhS5MRAQxWjXA7sZ4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O3ZwyG14zbkogGOCjYT1Ygaz2YmybaXrybd6j36/SAlttK9zbOAROEu7GoROcUYNbadUe257U0RxPptjW7UpEWFefWjqwoXSPxB71LaKmHvClo6QnR9Li8eaMIh7gPbRwFSQR4G6+B5aDpShIXPppznl7gqws+Eqoe12jgb6iY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ChYbKd4r; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b6b194cf71so10063411b3a.3
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 14:29:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766528965; x=1767133765; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PIzYm1357PLBlwJSpJ9Q9Pnkpgmtjnd2X3PzBGc4u0E=;
        b=ChYbKd4rGlVos7N+6eXe4rdct6ZaUxDWBV0Oz3aseRQEHbx/0biUCLmsUu4WQqwXCp
         /NNH4U/6oxNYMnaERsNh7OSlAlzLB9hm7CKPf6SySdb00teMmGMfN/e5mDhMVpl6ZFgf
         k1UAv7e+dqbbC4ZWMoSew54Q9RhXPSLuwYNZwqvCY25djgOwUVHsJOY6u4C5ZbjkGHDw
         VEckazEpbmC0IO/1qhmcp6i4CjYCkx/7HsEdUFVmSrLFH1l9t4eD7yjfJHg9Tqe9EUef
         HywkgIRjinVHtVMNq0wSSwKC4rcdUC13V0OhoHLHnBv5rpskKLP4pvzvuzmYUfUT0DQX
         mLGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766528965; x=1767133765;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PIzYm1357PLBlwJSpJ9Q9Pnkpgmtjnd2X3PzBGc4u0E=;
        b=nlCYRxvUWEDxZmSd7iFyku/5/Hgn99b4m1Ww3uEyuAHcfjppcoIckDsjCEFLddDN+E
         Rg5f2qtjclBEbHNF558jk+r+MsW+6WVh6ix5gqYwZwhY0Zeesl3HYiqTAGJwpHFQK5ju
         FUkCAcxG+sXZeHMGIjYriejZeNAQtfc/4feQlHCSY1fZbCBYgCGbVz4SK19NtkvU5xvK
         C+Tj8tzX0xoR481pvkPBpLYmz4nLT//7BqdC/uWUnvVfG1718KsfG0SSsotrCwqsu8Ug
         C5xzfndeq5FLTqzGdM7LKao0/R+nh809B9Uso6b2RYTzQZqqlCupZxmBFlkUMRsfLMAG
         RRiw==
X-Forwarded-Encrypted: i=1; AJvYcCW2xL3lyNrVi+uKqsYJi/cLAFn1QroN0elfomQxjZylHECDNHWDmUNMhqifFjl9GvQKQOs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiIMqaEwDi8Ga6v+GvvyUjFhD4cDsYbGvkase9Ly1p0ohGcMN7
	G69r/3fwwPFm26XLXJvzFeZUScxcdwHPZJUO+/m/DutbMwsim7HxGEAvQKMfwCjI0XJhxBbgf30
	qMY4Lqg==
X-Google-Smtp-Source: AGHT+IEhDeR7Xm0mAYb+x0wfXfdsI2qgS00NPGQ3TSa3ZXT1lYGjl3a1TULge+FN3tNTpCcrJy4FLsEJhhk=
X-Received: from pgbdq13.prod.google.com ([2002:a05:6a02:f8d:b0:bc7:4ee3:3185])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a103:b0:35d:5d40:6d79
 with SMTP id adf61e73a8af0-376a88c7411mr15665035637.12.1766528965091; Tue, 23
 Dec 2025 14:29:25 -0800 (PST)
Date: Tue, 23 Dec 2025 14:29:23 -0800
In-Reply-To: <20251127013440.3324671-7-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251127013440.3324671-1-yosry.ahmed@linux.dev> <20251127013440.3324671-7-yosry.ahmed@linux.dev>
Message-ID: <aUsXw9m4g-Pn7LtO@google.com>
Subject: Re: [PATCH v3 06/16] KVM: selftests: Introduce struct kvm_mmu
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 27, 2025, Yosry Ahmed wrote:
> In preparation for generalizing the virt mapping functions to work with
> TDP page tables, introduce struct kvm_mmu. This struct currently only
> holds the root GPA and number of page table levels. Parameterize virt
> mapping functions by the kvm_mmu, and use the root GPA and page table
> levels instead of hardcoding vm->pgd and vm->pgtable_levels.
> 
> There's a subtle change here, instead of checking that the parent
> pointer is the address of the vm->pgd, check if the value pointed at by
> the parent pointer is the root GPA (i.e. the value of vm->pgd in this
> case). No change in behavior expected.
> 
> Opportunistically, switch the ordering of the checks in the assertion in
> virt_get_pte(), as it makes more sense to check if the parent PTE is the
> root (in which case, not a PTE) before checking the present flag.
> 
> vm->arch.mmu is dynamically allocated to avoid a circular dependency
> chain if kvm_util_arch.h includes processor.h for the struct definition:
> kvm_util_arch.h -> processor.h -> kvm_util.h -> kvm_util_arch.h
> 
> No functional change intended.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  .../selftests/kvm/include/x86/kvm_util_arch.h |  4 ++
>  .../selftests/kvm/include/x86/processor.h     |  8 ++-
>  .../testing/selftests/kvm/lib/x86/processor.c | 61 +++++++++++++------
>  3 files changed, 53 insertions(+), 20 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
> index 972bb1c4ab4c..d8808fa33faa 100644
> --- a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
> +++ b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
> @@ -10,6 +10,8 @@
>  
>  extern bool is_forced_emulation_enabled;
>  
> +struct kvm_mmu;
> +
>  struct kvm_vm_arch {
>  	vm_vaddr_t gdt;
>  	vm_vaddr_t tss;
> @@ -19,6 +21,8 @@ struct kvm_vm_arch {
>  	uint64_t s_bit;
>  	int sev_fd;
>  	bool is_pt_protected;
> +
> +	struct kvm_mmu *mmu;

No, put kvm_mmu in common code and create kvm_vm.mmu.  This makes the "mmu" object
a weird copy of state that's already in kvm_vm (pgd, pgd_created, and pgtable_levels),
and more importantly makes it _way_ to easy to botch the x86 MMU code (speaking
from first hand experience), e.g. due to grabbing vm->pgtable_levels instead of
the mmu's version.  I don't see an easy way to _completely_ guard against goofs
like that, but it's easy-ish to audit code the code for instance of "vm->mmu.",
and adding a common kvm_mmu avoids the weird duplicate code.


