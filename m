Return-Path: <kvm+bounces-47392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1541EAC1296
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 19:48:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 79EE81BC858D
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 17:48:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0063B19CC3C;
	Thu, 22 May 2025 17:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xTLosbmO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC9926AFB
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 17:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747936067; cv=none; b=edftGR2mMLnaiKRqy6ho4AdBcj4f8imTdhxrmsTuDZu80KpwiZJzCioSrXSxPM7gRkyafVUmYC/wAmapGZle9XcgsHWawmSXBLgkvcdR6RCHDJygOFZ8hD9lsmpGbgydkNWdbdaiVez90+VIyG+DHW1umS14fWPkYq0hDZb7DZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747936067; c=relaxed/simple;
	bh=9TCcLMKCfCi3v37I+6cMTCVnR65cZTJsCK6Ao0BuT8M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lB/GAb9rCcyz8etCyYh0wAR8ktg7MzisebdPFdJkTW7rhzxbkMUu4yKdgNd0bUPvNnPcSZDA4J0SNFoYx+D+Qo7Nvh6O7AaIG3EykcsT+nsO8MD1AF+I4he+leIvK0QkCLW+syEzubdL1Myj8U/4LMiQ7/qbMESziNyRkGagwOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xTLosbmO; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30ed0017688so4557828a91.2
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 10:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747936063; x=1748540863; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Nui8gTSevfIigrGuHShq/RvE2jnQwHLezywqPF+zYbg=;
        b=xTLosbmO4MO2mTB86RBCL+kmvxasc2lkSr3I7sPTlwgHz4Eem6h5POAB7nnogn4ks8
         JowgZIrQkuzywp2aq1MYu1zKEcEo77op4QqfXwliagD3J8Q6f8C2uNJsfXubqgivLuPu
         pSdtv4q+YRnMNL8AuRgn9CUyGqjBOukx2AkeCMfd6n/HLm5YK2Yb6o6OEmE0sjCQwlcS
         +kUifkPmJB16M3EMpLxIEkylLJP6xLK4ppBRbcfnQRgXTFHBkjDX9ycVmLodTIqlopRj
         IlMorSacgvMY9/b3N1l88PbyDEAJ3M3cql6yyW85LraCNjoIFaoj3+4jUnO33FUytAjg
         oS5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747936063; x=1748540863;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nui8gTSevfIigrGuHShq/RvE2jnQwHLezywqPF+zYbg=;
        b=lgsoSoAy7upBdxg+F2S52U6DNNBs4y5nlUEowmHDzWfwr0xtgdcgT/Wf2uXn0q7jK0
         aXsxREU7AeacNiGIg9NwVRJ8kFjHXMjkSunxFTIST02ORvt1p9GpDhIg67p0V5V6m8m1
         FzLDCPgpTRuDptdzRGyZ5bBExnhRBKBsIN3F5NLSEz+25uKXnZ3eaXBUkqsTB/JxjX05
         97oi4tLgMSIWNMmIL/mX36QrQE7/4oH8RVhAylhuouZzAtJNAP6G7zsSMIrNPN5r/yBk
         e511twVskfdb3l30NFWXY7tSjKeRhvy8TpdZimb2dzMM4zf5bk6t2EwIhxY7nBbn8dWb
         EMkA==
X-Gm-Message-State: AOJu0YzZmhxs0hwbvfFmZQQSZbhNw+TbseRiG7OLmhjMZn1clwKFJTpj
	+RNX02pSPvyoFPZmxS0V56imsjTR3t3zzf29g9/1/6FjNWvsgbA4W83HPoFsnGy/KLjiozBmzph
	E9zhQCg==
X-Google-Smtp-Source: AGHT+IG3YI0ycq9rZ9FsYkUnUURw/fDosRLaCP5tJGdqjf9xjAyHL2I7UTe+BkztbzyysLlI5JD9NkJOjJg=
X-Received: from pjbqn14.prod.google.com ([2002:a17:90b:3d4e:b0:2fc:201d:6026])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d44e:b0:2f8:b2c:5ef3
 with SMTP id 98e67ed59e1d1-310e96c5f78mr139536a91.14.1747936063496; Thu, 22
 May 2025 10:47:43 -0700 (PDT)
Date: Thu, 22 May 2025 10:47:41 -0700
In-Reply-To: <20250522005555.55705-5-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250522005555.55705-1-mlevitsk@redhat.com> <20250522005555.55705-5-mlevitsk@redhat.com>
Message-ID: <aC9jPd25Jf2vU5h7@google.com>
Subject: Re: [PATCH v5 4/5] KVM: VMX: wrap guest access to IA32_DEBUGCTL with wrappers
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

This doesn't just wrap guest access, it wraps all access.

On Wed, May 21, 2025, Maxim Levitsky wrote:
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 00f2b762710c..b505f3f7e9ab 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2653,7 +2653,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  	if (vmx->nested.nested_run_pending &&
>  	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS)) {
>  		kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
> -		vmcs_write64(GUEST_IA32_DEBUGCTL, vmcs12->guest_ia32_debugctl);
> +		vmx_guest_debugctl_write(vcpu, vmcs12->guest_ia32_debugctl);
>  	} else {
>  		kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
>  		vmcs_write64(GUEST_IA32_DEBUGCTL, vmx->nested.pre_vmenter_debugctl);

I think it makes sense to use the accessors for this case as well.  Conceptually,
pre_vmenter_debugctl holds the guest value.  The fact that it holds the combined
value _as written_ is rather subtle, and could change for the worse, e.g. it'd
be quite unfortunate/hilarious if someone converted the read path to use the
getter, and in doing so introduced a bug.

