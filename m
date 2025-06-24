Return-Path: <kvm+bounces-50590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F8C0AE733E
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 01:32:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33F881BC2CF8
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 23:33:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0342326E6FD;
	Tue, 24 Jun 2025 23:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2TC6O+zQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A785626E140
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 23:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750807868; cv=none; b=ZyveRamxJjK9zuLO+yhclHIBMtYJbvjD4EWyUoH9tJ1RGbbSn3pmWjlRTRllRiruadkBGXmY0xBN7PxbhMKVFyjKfpodmF7f/QrLafcG2U1LeWn/3A9yPhyY1gTOh6hbI8qYR6WmHgKZg7qmBq/ntb+Fj5JXNax9wd7S+C/4tRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750807868; c=relaxed/simple;
	bh=nX0YHqLfleKwgIkQRR7zhOtfTngLBmfTmLBeKNNNlEE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iAxEqNBzlYQSuy49qFPFoLumE1uADoA/lTgfZAjr/CO2tyYDayegpfjqRFtHt+Ce9POkspMvOvgAXyHWo4+l9/VL0dKa0bsK2wa+wNpymSrdSWAJ6sF6QOWGYXhwW0TvPfQVP2a4cv4JEmsEVPlq26ha/ddwyL1qL6weyh1lsIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2TC6O+zQ; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b31ca4b6a8eso613315a12.1
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 16:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750807866; x=1751412666; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O/hcbVM3hgEz99lahHzlfgB8IEMKnnphGvT38Gwa/j0=;
        b=2TC6O+zQBDMKTLEHc7NlNjSwCu4fdZiDiuopWC1IHdW9W19w2bwNtvSvbDOm8DJpV2
         r4BZ9pQTRmWWiRNx/xpKy7PgUS6RUq1EMBDIRLb6rYOih+9STBxvHjIGwinq+/Sbnwwi
         jfsWXR62O2TZiVl9BevkMRhS51wcIE2CvKG5XjhNhnuuq9nJc+UhYqqgJ6+Zwap7D0pr
         8ipYIV9R/xVhT6tau2XiWQSWCEFhqX3yXzSuZnonwYmAgtRjTeTQQxuIue81LucGcly3
         AfviJrrPPUb2W2WqbvmkNyBB34+fGUX+QNxHgEgW4+fRjLutxkU5xqdfG+nUEwZDjwgy
         LmZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750807866; x=1751412666;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O/hcbVM3hgEz99lahHzlfgB8IEMKnnphGvT38Gwa/j0=;
        b=tTg0cPPdYMW9YxZuTVovxfjvmlL3kBZ9KjBC9yPGTJJBnf/Ptu+A0ogZtXhjqOOLTi
         g1trAIxIchczUDvfKXgbRXCkVkCYL+lihJZ8wdypm8IULOTW3GPX2SbA1ckDAOKthLUK
         eYSX9qw2+Jt9BfS+Fq+5Dl15YtlViIEKZAeBc3d6Dfqhs3eGi/AJrunHbRMqve93pH95
         nSN7AMR6HTaH7rBkUb5l8p8JGJ7mJHoEEgdNCEsxKcmnsv0tEOTfTHFz3tZdKKOtPufi
         8kdIMH8sZkYJjNn6JGIaBeDThHVsj8pEpIwJ/qyvL4FVdrUK7Oekl+LSEygdjWavZxOO
         fgPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVA7LYjIRq0aGtRQu3LHFkS8ufWZZQVFW0Kv3U8I+vPNVnWqxaQ/QQS6f8TG6+keVsqshw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz36cvXwXS94DZJ8TS3LTddHoeqaLMiO5p7KWOkxzgrOSmuJycm
	Nk3O5UdEazcCYrFHih5GLBwwqIaeGR5oh3JwgVcuhMdNxjpg3NASOmJpg3zQIG2h+eUJBraByj7
	VGf08eQ==
X-Google-Smtp-Source: AGHT+IFOA5I0fytY1fxsbAPIcxCuXX1tMxsiYvby57eByHBNqJwSR1UKppPsacZEWlYJTkj1qwxGne4E8Ak=
X-Received: from pjbhl6.prod.google.com ([2002:a17:90b:1346:b0:311:e71e:3fb9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d008:b0:312:1b53:5e98
 with SMTP id 98e67ed59e1d1-315f26c401fmr891263a91.34.1750807865998; Tue, 24
 Jun 2025 16:31:05 -0700 (PDT)
Date: Tue, 24 Jun 2025 16:31:04 -0700
In-Reply-To: <20250530185239.2335185-3-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250530185239.2335185-1-jmattson@google.com> <20250530185239.2335185-3-jmattson@google.com>
Message-ID: <aFs1OL8QybDRUQkF@google.com>
Subject: Re: [PATCH v4 2/3] KVM: x86: Provide a capability to disable
 APERF/MPERF read intercepts
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, May 30, 2025, Jim Mattson wrote:
> @@ -7790,6 +7791,28 @@ all such vmexits.
>  
>  Do not enable KVM_FEATURE_PV_UNHALT if you disable HLT exits.
>  
> +Virtualizing the ``IA32_APERF`` and ``IA32_MPERF`` MSRs requires more
> +than just disabling APERF/MPERF exits. While both Intel and AMD
> +document strict usage conditions for these MSRs--emphasizing that only
> +the ratio of their deltas over a time interval (T0 to T1) is
> +architecturally defined--simply passing through the MSRs can still
> +produce an incorrect ratio.
> +
> +This erroneous ratio can occur if, between T0 and T1:
> +
> +1. The vCPU thread migrates between logical processors.
> +2. Live migration or suspend/resume operations take place.
> +3. Another task shares the vCPU's logical processor.
> +4. C-states lower thean C0 are emulated (e.g., via HLT interception).
> +5. The guest TSC frequency doesn't match the host TSC frequency.
> +
> +Due to these complexities, KVM does not automatically associate this
> +passthrough capability with the guest CPUID bit,
> +``CPUID.6:ECX.APERFMPERF[bit 0]``. Userspace VMMs that deem this
> +mechanism adequate for virtualizing the ``IA32_APERF`` and
> +``IA32_MPERF`` MSRs must set the guest CPUID bit explicitly.

Question: what do we want to do about nested?  Due to differences between SVM
and VMX at the time you posted your patches, this series _as posted_ will do
nested passthrough for SVM, but not VMX (before the MSR rework, SVM auto-merged
bitmaps for all MSRs in svm_direct_access_msrs).

As I've got it locally applied, neither SVM nor VMX will do passthrough to L2.
I'm leaning toward allowing full passthrough, because (a) it's easy, (b) I can't
think of any reason not to, and (c) SVM's semi-auto-merging logic means we could
*unintentinally* do full passthrough in the future, in the unlikely event that
KVM added passthrough support for an MSR in the same chunk as APERF and MPERF.

This would be the extent of the changes (I think, haven't tested yet).

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 749f7b866ac8..b7fd2e869998 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -194,7 +194,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
  * Hardcode the capacity of the array based on the maximum number of _offsets_.
  * MSRs are batched together, so there are fewer offsets than MSRs.
  */
-static int nested_svm_msrpm_merge_offsets[6] __ro_after_init;
+static int nested_svm_msrpm_merge_offsets[7] __ro_after_init;
 static int nested_svm_nr_msrpm_merge_offsets __ro_after_init;
 typedef unsigned long nsvm_msrpm_merge_t;
 
@@ -216,6 +216,8 @@ int __init nested_svm_init_msrpm_merge_offsets(void)
                MSR_IA32_SPEC_CTRL,
                MSR_IA32_PRED_CMD,
                MSR_IA32_FLUSH_CMD,
+               MSR_IA32_APERF,
+               MSR_IA32_MPERF,
                MSR_IA32_LASTBRANCHFROMIP,
                MSR_IA32_LASTBRANCHTOIP,
                MSR_IA32_LASTINTFROMIP,
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c69df3aba8d1..b8ea1969113d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -715,6 +715,12 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
        nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
                                         MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
 
+       nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+                                        MSR_IA32_APERF, MSR_TYPE_R);
+
+       nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+                                        MSR_IA32_MPERF, MSR_TYPE_R);
+
        kvm_vcpu_unmap(vcpu, &map);
 
        vmx->nested.force_msr_bitmap_recalc = false;

