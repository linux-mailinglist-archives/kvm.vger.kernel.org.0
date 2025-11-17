Return-Path: <kvm+bounces-63406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EFF3C65B98
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 19:30:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C06F8351E68
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 18:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65453314B9A;
	Mon, 17 Nov 2025 18:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cgay6iP4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8D42D24BD
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 18:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763404243; cv=none; b=Oz6UUVMIAhUy/Tx1VhG5TfjAzmoItq7kW8F9bf82lrgA6Yh3AjBGpLK8ihfb4vGTEcvUmRZ5Bx/jPWH39hIVA+ZZG57AlFvOJtF/c1TJ1tWuxTmRXcRVSYcG2nDWrwbocTzDZ3UPGOGT08qMyjD/LOLoMHnfNXwTQzjQ+3utRX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763404243; c=relaxed/simple;
	bh=crBrVMcARTLN+tszMn7sUtzu6jZSkSuiZqTLZkZwlwI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LEIULgDG4IyMiHRBY7/+tG14VzOWegzmHcUYzoMgXCOkcLpqRPymMpqgISn4khEYR0xJ0LgWIjJsNAJx3RCLp9/C9PPItFam6Nc51j5oKL6VZ4tPoRXfEnqyFn1Ek+5aWUsmqvfFrpC4P6+CdPoqSc6oUV0NnBzwYKZ/t13ZGzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cgay6iP4; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-29848363458so126462805ad.2
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 10:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763404241; x=1764009041; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PqN8C9clzsOl1ksbgrNP+zoJl87PgEGW12GrGJzU/bU=;
        b=cgay6iP4D5YSGNE07nhv/2MkkmbLXOHPlV6z4TCsQtc9aqOJbj0nK5O+MwI4GcJcmA
         +IZvXrb8uzv2FIztPOolswiVTEf5/hbqYr+TqbUUgm6W5Cy3ON5PrWD32EnxiiqMZBPr
         IKcuT6ioKLOC/FhzphQoEQ1nFZ1D1ZfTOhW7SzWgy+1DGhHwgXA9yZQWOgUoDOUlalB8
         OENOy/EdbmPA4vSiTTwVQkMYcgHk7JvMRttRSogQngzgX3l/U+Gm+7WRB46Q0KCzlF7D
         XoftVJnlLMS+gmT+/7/zBbzdCG2g6XkCyHEPzxOq5jz5fv4acA9476Ik8nXYLv31o4FT
         DVvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763404241; x=1764009041;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PqN8C9clzsOl1ksbgrNP+zoJl87PgEGW12GrGJzU/bU=;
        b=NBfVhi5Jl0iJAXzkIcMlVEzg86oli/MA+rBlE5NylG7gT6v2ZSZ4w9S4peeCskn83N
         KxcUiidaPynDzpVUeek25dRHXjcA2D8sfzMAsvSV7IZodV1frubcH1ryB7v2wHUaxBEE
         eNIwJew2UY//xQk5acK5hMQKzhFhRJK4/YB+O3LSCfvAQlBAxS7YzSSyvAgPM2Ghvm0X
         FRG0RrVug/TVye1veukY9tuaK6mpv0mRFdjjYzPc2g0PcLHjRr+vCrAV3Ogv7xC+JCxc
         iUAsCsa06AoQe6J9cmgx1DgRA9RBnu9p/1bvi28TM4QkSwdUNaCUSAM5aoHTItBao8jh
         X1KA==
X-Gm-Message-State: AOJu0Yygc6+RNiIB32emdPd5WgT2o9CxHRGhLmIjfntPA6BIW5Bnt19t
	Png+QMwuKtY6wsXmXZwEygX5sXTRsyWrpoXeUuz2NfxV3B/XHLfYA9vQvSAjT5J+0RIyrzsBG7q
	OxNXpTg==
X-Google-Smtp-Source: AGHT+IGtAKWzla+LvbUBQljGRDvgZ19CjPQfJCV2x2B7bJDCN6LWQOMTZOFXtvrJxDcDv+gwLBUffZ6dcPg=
X-Received: from pgbcr8.prod.google.com ([2002:a05:6a02:4108:b0:bc3:57f1:bc8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ce8b:b0:282:eea8:764d
 with SMTP id d9443c01a7336-2986a741ac5mr137317915ad.35.1763404241048; Mon, 17
 Nov 2025 10:30:41 -0800 (PST)
Date: Mon, 17 Nov 2025 10:30:39 -0800
In-Reply-To: <20250910085156.1419090-1-griffoul@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250910085156.1419090-1-griffoul@gmail.com>
Message-ID: <aRtpzxkVfY1g-Llp@google.com>
Subject: Re: [PATCH v2] KVM: nVMX: Mark APIC access page dirty when syncing
 vmcs12 pages
From: Sean Christopherson <seanjc@google.com>
To: Fred Griffoul <griffoul@gmail.com>
Cc: kvm@vger.kernel.org, Fred Griffoul <fgriffo@amazon.co.uk>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 10, 2025, Fred Griffoul wrote:
> From: Fred Griffoul <fgriffo@amazon.co.uk>
> 
> For consistency with commit 7afe79f5734a ("KVM: nVMX: Mark vmcs12's APIC
> access page dirty when unmapping"), which marks the page dirty during
> unmap operations, also mark it dirty during vmcs12 page synchronization.
> 
> Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
> ---
> v2: Fix commit ID to use 12 chars instead of 11 (checkpatch warning)
> 
>  arch/x86/kvm/vmx/nested.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index b8ea1969113d..02aee6dd1698 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3916,10 +3916,10 @@ void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu)
>  	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
>  	gfn_t gfn;
> 
> -	/*
> -	 * Don't need to mark the APIC access page dirty; it is never
> -	 * written to by the CPU during APIC virtualization.
> -	 */
> +	if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
> +		gfn = vmcs12->apic_access_addr >> PAGE_SHIFT;
> +		kvm_vcpu_mark_page_dirty(vcpu, gfn);

Hrm, marking the page dirty in vmx_complete_nested_posted_interrupt() is
unnecessary, because that function is marking the vAPIC and PID pages as dirty
because it explicitly writes those pages.  Not the end of the world, but I think
we can clean up another over-dirtying issue at the same time.

If nested_get_vmcs12_pages() didn't actually map memory into the guest, there's
no need to mark the gfn dirty, as the underlying page is unreachable.  If we add
a helper too fix that flag:

static inline void kvm_vcpu_map_mark_dirty(struct kvm_vcpu *vcpu,
					   struct kvm_host_map *map)
{
	if (kvm_vcpu_mapped(map))
		kvm_vcpu_mark_page_dirty(vcpu, map->gfn);
}

then we can have vmx_complete_nested_posted_interrupt() mark exactly the pages
it writes as dirty (which for me is more about documenting what the code is doing
as opposed to caring about spuriously marking a page dirty).

	kvm_vcpu_map_mark_dirty(vcpu, &vmx->nested.virtual_apic_map);
	kvm_vcpu_map_mark_dirty(vcpu, &vmx->nested.pi_desc_map);

Ugh, and looking at the details made me realize __kvm_vcpu_map() is buggy.  It
uses gfn_to_memslot() instead of kvm_vcpu_gfn_to_memslot().  Luckily, it's benign
as __kvm_vcpu_map() isn't reachable while the vCPU is "in" SMM.

I'll send a v2 as a small series, i.e. with this as the final patch.

> +	}
> 
>  	if (nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW)) {
>  		gfn = vmcs12->virtual_apic_page_addr >> PAGE_SHIFT;
> --
> 2.43.0
> 

