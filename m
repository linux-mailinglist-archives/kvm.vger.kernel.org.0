Return-Path: <kvm+bounces-43972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF535A99364
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 17:57:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 017DA7AA131
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 15:55:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D52A28EA4E;
	Wed, 23 Apr 2025 15:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mOQ4yyOr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F007625F7AD
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 15:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745423057; cv=none; b=HBI698MczlwfmtJFcNUi7q6M36ECe+FeoEYbEJD5XkPzE9wxhJzorvrAH+pjx2mHm2bI0TVWaivhxp92xMXDpFQL+q093MwRGVVjgVk+8//6MpYK28zU1Lmf1TsiCAGdTX7hCHKCcek68TLqXfLAbvwQwaEzOgdHLUx/0pkr40g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745423057; c=relaxed/simple;
	bh=PTgTXbiqBZbLrDvwU4F+5aFy0KIW3wzX+95atzxzKbA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M5f8MHNpNwbz0B+ED8wuPyi6s5JExBqfIelp/pefdkHviDP12VxFdpy0UughLlD9pV+PM+ZzW8WSuhE3g22+AGsiKdxwGlJ8rEFp1qvojuO9ngtyOtlsXvv7pv41giLIcwqw5IZF7+W/e98wPrEnzsw1dTVi9heEl1aoMdrx7CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mOQ4yyOr; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3032ea03448so6778099a91.2
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 08:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745423054; x=1746027854; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xPhgwd63apwbZo6TL59hfQlqDly5iGnPFF4jLyqPwhs=;
        b=mOQ4yyOrnUzvbqmyr6oY/g9TCACDLTHTNMncaFJuZ35sps44FmIEQ3KJtl6hHpnRrU
         5TAJQvfxG/ccara+f5N6I/cvkOt8fNx7hqFBq5PYTNd3a7Xm41x0bB7Myko2W4sG3nSm
         /17CYN3GuhCrhTMTIt1QmDfahqVN+EIwWl5EMQXn3FKPi4hwq/lUNR/4Du4jduePbf7+
         w3SsyZFkuC2Ogk7YA6QAJAXgmJ9qDgLiZnwEyH2GZ4kLLocM1IlDo6klw237/1f8XPPY
         8dUmerUbBk0L6SpucHGtGQdqIQK+yinNaZtEnZvpSj0c0Wmf0ptX8zbdoa0/EM87qCba
         NFFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745423054; x=1746027854;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xPhgwd63apwbZo6TL59hfQlqDly5iGnPFF4jLyqPwhs=;
        b=tYUInHF5FGq1vEx6KdOR5XUtBWTzAT4VkxdSa9Up/0y5WByvTcUiO0iWWVoFZId/JF
         qPurgkiYd6LJL49hZa9NVukVUEhnPbQ87YvBSpAU1G619LUBo0Iy839l/oxuq3oPLzz6
         3mOlXFP09FCPnqhJnOxNuEJZrETJ7RhJw9nibZta64dL8HReSUF9IBvhCNv5FA0yGNRv
         P2rpoXiQlxDqy3yjNkpQHAIYJie+qJDYA1xWBSL/1G0xy2SjurHjEbDjwqXU8iRqyRwV
         A637aj7BXr1B+SwmpH/DIxYsD/jlGzEktUp1HQIJn1+1/zC54XSCWWI2f3c6YEmDJ/5Z
         3/3Q==
X-Gm-Message-State: AOJu0YwlXW0ZR4TTGUiQffG6kxTy/PtQ9O7moSNhw1H8JRc8u1Ga1bU3
	GTgL3RnyvAwoohNbccQvg4/MQJHFD/Z87S0k9NJNjV6DXnSeIP13I21rjpYUkjmiLKInsf741Mr
	Vbw==
X-Google-Smtp-Source: AGHT+IHSkI6Mn0oDpHpElbO32DnQkfEefLjjNmyGwYzoz4thjAq+r46reZVQvyh0CS2WtBzQW2wRRZTNpuA=
X-Received: from pjbkl15.prod.google.com ([2002:a17:90b:498f:b0:2f9:c349:2f84])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:dfc5:b0:2fa:1a23:c01d
 with SMTP id 98e67ed59e1d1-3087bb6bcaamr27998226a91.21.1745423054216; Wed, 23
 Apr 2025 08:44:14 -0700 (PDT)
Date: Wed, 23 Apr 2025 08:44:12 -0700
In-Reply-To: <20250324130248.126036-5-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324130248.126036-1-manali.shukla@amd.com> <20250324130248.126036-5-manali.shukla@amd.com>
Message-ID: <aAkKzEpNXDgC9_Vh@google.com>
Subject: Re: [PATCH v4 4/5] KVM: SVM: Add support for KVM_CAP_X86_BUS_LOCK_EXIT
 on SVM CPUs
From: Sean Christopherson <seanjc@google.com>
To: Manali Shukla <manali.shukla@amd.com>
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, pbonzini@redhat.com, 
	nikunj@amd.com, thomas.lendacky@amd.com, bp@alien8.de
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 24, 2025, Manali Shukla wrote:
> +	if (vmcb02->save.rip && (svm->nested.ctl.bus_lock_rip == vmcb02->save.rip)) {
> +		vmcb02->control.bus_lock_counter = 1;
> +		svm->bus_lock_rip = svm->nested.ctl.bus_lock_rip;
> +	} else {
> +		vmcb02->control.bus_lock_counter = 0;
> +	}
> +	svm->nested.ctl.bus_lock_rip = INVALID_GPA;
> +
>  	/* Done at vmrun: asid.  */
>  
>  	/* Also overwritten later if necessary.  */
> @@ -1039,6 +1069,18 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  
>  	}
>  
> +	/*
> +	 * If bus_lock_counter is nonzero and the guest has not moved past the
> +	 * guilty instruction, save bus_lock_rip in svm_nested_state. This will
> +	 * help determine at nested VMRUN whether to stash vmcb02's counter or
> +	 * reset it to '0'.
> +	 */
> +	if (vmcb02->control.bus_lock_counter &&
> +	    svm->bus_lock_rip == vmcb02->save.rip)
> +		svm->nested.ctl.bus_lock_rip = svm->bus_lock_rip;
> +	else
> +		svm->nested.ctl.bus_lock_rip = INVALID_GPA;
> +
>  	nested_svm_copy_common_state(svm->nested.vmcb02.ptr, svm->vmcb01.ptr);
>  
>  	svm_switch_vmcb(svm, &svm->vmcb01);

...

> +static int bus_lock_exit(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	vcpu->run->exit_reason = KVM_EXIT_X86_BUS_LOCK;
> +	vcpu->run->flags |= KVM_RUN_X86_BUS_LOCK;
> +
> +	vcpu->arch.cui_linear_rip = kvm_get_linear_rip(vcpu);
> +	svm->bus_lock_rip = vcpu->arch.cui_linear_rip;
> +	vcpu->arch.complete_userspace_io = complete_userspace_buslock;
> +
> +	return 0;
> +}

> @@ -327,6 +328,7 @@ struct vcpu_svm {
>  
>  	/* Guest GIF value, used when vGIF is not enabled */
>  	bool guest_gif;
> +	u64 bus_lock_rip;

I don't think this field is necessary.  Rather than unconditionally invalidate
on nested VMRUN and then conditionally restore on nested #VMEXIT, just leave
svm->nested.ctl.bus_lock_rip set on VMRUN and conditionally invalidate on #VMEXIT.
And then in bus_lock_exit(), update the field if the exit occurred while L2 is
active.

Completely untested:

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index a42ef7dd9143..98e065a93516 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -700,13 +700,10 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
         * L1 re-enters L2, the same instruction will trigger a VM-Exit and the
         * entire cycle start over.
         */
-       if (vmcb02->save.rip && (svm->nested.ctl.bus_lock_rip == vmcb02->save.rip)) {
+       if (vmcb02->save.rip && (svm->nested.ctl.bus_lock_rip == vmcb02->save.rip))
                vmcb02->control.bus_lock_counter = 1;
-               svm->bus_lock_rip = svm->nested.ctl.bus_lock_rip;
-       } else {
+       else
                vmcb02->control.bus_lock_counter = 0;
-       }
-       svm->nested.ctl.bus_lock_rip = INVALID_GPA;
 
        /* Done at vmrun: asid.  */
 
@@ -1070,15 +1067,10 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
        }
 
        /*
-        * If bus_lock_counter is nonzero and the guest has not moved past the
-        * guilty instruction, save bus_lock_rip in svm_nested_state. This will
-        * help determine at nested VMRUN whether to stash vmcb02's counter or
-        * reset it to '0'.
+        * Invalidate bus_lock_rip unless kVM is still waiting for the guest
+        * to make forward progress before re-enabling bus lock detection.
         */
-       if (vmcb02->control.bus_lock_counter &&
-           svm->bus_lock_rip == vmcb02->save.rip)
-               svm->nested.ctl.bus_lock_rip = svm->bus_lock_rip;
-       else
+       if (!vmcb02->control.bus_lock_counter)
                svm->nested.ctl.bus_lock_rip = INVALID_GPA;
 
        nested_svm_copy_common_state(svm->nested.vmcb02.ptr, svm->vmcb01.ptr);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ea12e93ae983..11ce031323fd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3333,9 +3333,10 @@ static int bus_lock_exit(struct kvm_vcpu *vcpu)
        vcpu->run->flags |= KVM_RUN_X86_BUS_LOCK;
 
        vcpu->arch.cui_linear_rip = kvm_get_linear_rip(vcpu);
-       svm->bus_lock_rip = vcpu->arch.cui_linear_rip;
        vcpu->arch.complete_userspace_io = complete_userspace_buslock;
 
+       if (is_guest_mode(vcpu))
+               svm->nested.ctl.bus_lock_rip = vcpu->arch.cui_linear_rip;
        return 0;
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7a4c5848c952..8667faccaedc 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -328,7 +328,6 @@ struct vcpu_svm {
 
        /* Guest GIF value, used when vGIF is not enabled */
        bool guest_gif;
-       u64 bus_lock_rip;
 };
 
 struct svm_cpu_data {


