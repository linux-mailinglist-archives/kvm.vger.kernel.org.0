Return-Path: <kvm+bounces-65787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A60CCB6723
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 17:22:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5EC703002520
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 16:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCACF3148B1;
	Thu, 11 Dec 2025 16:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e640muRJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A484E278E5D
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 16:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765470138; cv=none; b=M4A3AzOgAlN4+iXFC39Hb4z8kCRoG6uEfwYy5dGsQURmXteylsXI/KUNXjdwEYXYtBzawj3IGs2rhdmDASSsocy3uSAPcMOrfxXpQvDXZ9E7QKgveExSAJ+dz9Z2LAj8qjZrH5rFLUR0xl95O/4XOxhYAX6RmdH0tXxesvBZTAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765470138; c=relaxed/simple;
	bh=AVBpNeQYjs+NT4n83hvwVghqzCFaq0io8le1Mkf64JA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RsZZIT7UjUa4UHy9sJje9WpAx3XTyIfy7d/xTqSffwL/rkGGZLQZtg5Ht9xhDYrL7YTH+6LEZK1cdckspjba5W8eL3Uzr7uGbboauAYaNsOzVfnWvHndz6pdM2AnIkCnyuc+CaPtKvNs+vyYVKdIPg5CrEv47fg1gqio3QnDNn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e640muRJ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-29848363458so4309405ad.2
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 08:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765470136; x=1766074936; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gbznK5gDAlYZkkIu8L5egA3M/d4oKKfYrWTkNbjwXso=;
        b=e640muRJce+N7yJVB/LrEjddGbdCRbOsvI9Rrvy6jcH1i1VZo8k5Y8y7sAVTuuuseC
         9/gK/G7gIgL/+72pbK0ItbE7phQG+9vCWLHooPLa9ZQ0FEMjExjrUr7q0kxv3bmfuQRL
         z78uvK7ZRHxB2VhX+EgT+1czZrFU34qHhqmBN/dzHOYD5KEmyGKcmY8xC+63CYyMLZ4p
         GK64ixaQIrE6drARlwQ1SwfpMYhC2a0F8KLqFl/l96BubmowRYWKujKDN06W00e8jw7b
         trna30dzqoQDP85BJXwIP+dzxeH1P8p2VLuugv7oW1AJzdP88WfDbSCFoTG77R98e9v4
         J3nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765470136; x=1766074936;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gbznK5gDAlYZkkIu8L5egA3M/d4oKKfYrWTkNbjwXso=;
        b=pKcXNBAXBddiZfURqXGcLmYDn7cYHaPHsDIpNdHli/ZzsVe5W8tzbndMAUTStRnBw4
         bDnTuKewx5IvHjPwAhOSrG9f38bpwl02HF9PznG9S6uP+qWPnc6PtK0zq6hh7trpwtN/
         +O7FVnk0tMgIf6sxHD6kVsX57YooB69K14bK1SAPa5B9iYtd7JGa5UJTZMz38qZqJ8Lr
         poHKyN9SNse3CXqsqcZva3PdAF40Vo6IULCijWPJt9vGOM+ziGADIvKEk1zGg5wuomqg
         THUEVeBt/oUqSH0CpbfafAu5nPlM/hD9y1vpQqNIzP86BVbenFQYKtFK7VvVjLGpSpfM
         VihA==
X-Forwarded-Encrypted: i=1; AJvYcCWHEG7ukOXfd7myGbfIgg2upnaxfcyex6fONHrSfwOoBUF7fwOfqX/5DqXCTj3bu7C1bMs=@vger.kernel.org
X-Gm-Message-State: AOJu0YysTeLKnjl9+EXmRN6VnjHHzGklUKhjAJkY/thEckKLhpLKQqM7
	oq4cfm5Y9a4NGED5FgeiC4BxA0+Pznbm5lI3i3myd/nhLT0HORoYD7zgjtwU35DgOsSfaOr18jz
	Bt/GGqA==
X-Google-Smtp-Source: AGHT+IHI7ROMcRsrNQzPom6/VYzonXyvisOL0S8wsTs9tzRFtEIEK/B9lkVJMuoCc8kWSzEhtQWgCIjH2dc=
X-Received: from plou4.prod.google.com ([2002:a17:903:1ae4:b0:29d:5afa:2d9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:904:b0:29e:fd60:2cf1
 with SMTP id d9443c01a7336-29efd6034a3mr15656765ad.21.1765470136002; Thu, 11
 Dec 2025 08:22:16 -0800 (PST)
Date: Thu, 11 Dec 2025 08:22:14 -0800
In-Reply-To: <20251211022935.2049039-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251211022935.2049039-1-xiaoyao.li@intel.com>
Message-ID: <aTrvtszjqUFu4Svk@google.com>
Subject: Re: [PATCH] KVM: x86: Don't read guest CR3 in async pf flow when
 guest state is protected
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Farrah Chen <farrah.chen@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Dec 11, 2025, Xiaoyao Li wrote:
> ---
> For AMD SEV-ES and SNP cases, the guest state is also protected. But
> unlike TDX, reading guest CR3 doesn't cause issue since CR3 is always
> marked available for svm vCPUs. It always gets the initial value 0,
> set by kvm_vcpu_reset(). Whether to update vcpu->arch.regs_avail to
> reflect the correct value for SEV-ES and SNP is another topic.
> ---
>  arch/x86/kvm/mmu/mmu.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 667d66cf76d5..03be521df6b9 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4521,7 +4521,8 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu,
>  	arch.gfn = fault->gfn;
>  	arch.error_code = fault->error_code;
>  	arch.direct_map = vcpu->arch.mmu->root_role.direct;
> -	arch.cr3 = kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu);
> +	arch.cr3 = vcpu->arch.guest_state_protected ? 0 :
> +		   kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu);
>  
>  	return kvm_setup_async_pf(vcpu, fault->addr,
>  				  kvm_vcpu_gfn_to_hva(vcpu, fault->gfn), &arch);
> @@ -4543,7 +4544,8 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  		return;
>  
>  	if (!vcpu->arch.mmu->root_role.direct &&
> -	      work->arch.cr3 != kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu))
> +	    (vcpu->arch.guest_state_protected ||
> +	     work->arch.cr3 != kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu)))
>  		return;

Protected guests aren't compatible with shadow paging, so I'd rather key off the
direct MMU role.  '0' is also a legal address; INVALID_GPA would be better.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 02c450686b4a..446bf2716d08 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4521,7 +4521,10 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu,
        arch.gfn = fault->gfn;
        arch.error_code = fault->error_code;
        arch.direct_map = vcpu->arch.mmu->root_role.direct;
-       arch.cr3 = kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu);
+       if (arch.direct_map)
+               arch.cr3 = INVALID_GPA;
+       else
+               arch.cr3 = kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu);
 
        return kvm_setup_async_pf(vcpu, fault->addr,
                                  kvm_vcpu_gfn_to_hva(vcpu, fault->gfn), &arch);

