Return-Path: <kvm+bounces-63069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C317C5A6F3
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:59:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 180A64EDFF6
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 22:57:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69F10329E6E;
	Thu, 13 Nov 2025 22:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nsxT1APJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC68C32939A
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 22:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763074600; cv=none; b=Ohl7If9/lpGJlvi06p+BmMl4rjwolbiwBv4M+3Vxbjq+o7UdZ1cNCvGVnESYs0CgxhOLKeJY7aFKkqSB/EZiYYMcsdfANUO7hxzTEhxlEK0e3kSZuVrFLKNR73YgyJ8i3HUlkRu1I+XMVO5pF1nwaAfZVFPSRgJ5q+wCGpuGh94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763074600; c=relaxed/simple;
	bh=FrLYypfXkWMF/B8MfR9jtaa3rG5AmOBlRcsStUH+QyM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sXtFukvqNq0Y2nCIM4F2PASnpyvnqU9tK6gTdUqiEn7U71TFhJpmOTS6BvVWUKtYTT3yZJx7Tmk+WTP+Mll7NCN5+A2bEGMKzUsDeg1ZbQeRBuB5tEptEz4r6oBUJTW/nudWs0/nM7PS1VQsZkYOcwfZ+QUARVX/AN1XPdOKDVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nsxT1APJ; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b6ce1b57b9cso1322941a12.1
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 14:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763074598; x=1763679398; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ib2v7Ui/fjE5+JdRUXnMPJd5ZodcfqQQWSBde2U7kt4=;
        b=nsxT1APJPbPY9mIax9OUsn18Tm0M9Ngn/se9QKH9CwWg7uWFE1s044R9j41eZdSwtH
         4K1vczGCXRdmY90Djpew9ZCOKCMpRsuLuEbL6CHKB/gzAK1RFfsCovMiTP3p1tj0fpc3
         HdRUwo49eAtMPz7GvL8NguTftXnpbVXMr4ziutJM0/H6iCLB9gUkKiGts5hYfWWjGZLT
         2sKF27+hpsryMIHN/oYTKan8BbwvA/VPSIJvgmWRjLsee1NylUA/BQbzap85bnnr/V/2
         Asd1OwGLcndnvQGlpNGDfBTDt37XDuhcGtbpaHXHl05hO/DDYc5Y214P7HbfBBD915yh
         HQGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763074598; x=1763679398;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ib2v7Ui/fjE5+JdRUXnMPJd5ZodcfqQQWSBde2U7kt4=;
        b=BUHjscNhLTyLrNgu6pn4KQ2eHVOy8EyljJGmrgmDvmIjAw1FX4h/AgqrzuqXJCh9lf
         vmp1fbsHjiuxwcTUsZ2ROCMgu8FsQ3OXJJZkYNi953CyNHJ4ufWCEXmCAxfJQwihR+L1
         g6Zns2R3wrR9pxmw9vA8fhs0ucAtWWKmgc6NxdMoplGVtAoV497fCWPi+psSrypryHEP
         UzZ2Rntcd/wrX5mZUF0eA4H0uE6PWRVlSwBGp+zbZCd/Af2PSX59dwZghiWRZ9Zdw8i/
         YJHLblCmVfs26hjVFbttyUDRXR6MK4/m+KdPqsKBJnFncKRGN3fq80UTmuP6vQZtpaDa
         p7QQ==
X-Gm-Message-State: AOJu0YyIqcBumHp8XWtNPfdn17utc9XVkFg6kRTy99D+9SqAlvPpf2Zg
	M24gv/TQ2MzqqbhtwcU/pvVzvKcsFq5UVTCch4ymlgvnl9p+4u76T1GBC8qAKQgzKo7i8S1BdZI
	Us98P9A==
X-Google-Smtp-Source: AGHT+IH8IA3FWekt1ULXu2lSks3XBHqEUS4FhRpMQVG9SUdbxMomw9Nt9TFp3kJLPvjiS9a6PESnoKZm6yQ=
X-Received: from pgcv11.prod.google.com ([2002:a05:6a02:530b:b0:bac:a20:5ef9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:50b:20b0:35b:cc61:680
 with SMTP id adf61e73a8af0-35bcc610d4emr550460637.9.1763074598407; Thu, 13
 Nov 2025 14:56:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 14:56:18 -0800
In-Reply-To: <20251113225621.1688428-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113225621.1688428-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113225621.1688428-7-seanjc@google.com>
Subject: [PATCH 6/9] KVM: SVM: Filter out 64-bit exit codes when invoking exit
 handlers on bare metal
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>
Cc: kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Explicitly filter out 64-bit exit codes when invoking exit handlers, as
svm_exit_handlers[] will never be sized with entries that use bits 63:32.

Processing the non-failing exit code as a 32-bit value will allow tracking
exit_code as a single 64-bit value (which it is, architecturally).  This
will also allow hardening KVM against Spectre-like attacks without needing
to do silly things to avoid build failures on 32-bit kernels
(array_index_nospec() rightly asserts that the index fits in an "unsigned
long").

Omit the check when running as a VM, as KVM has historically failed to set
bits 63:32 appropriately when synthesizing VM-Exits, i.e. KVM could get
false positives when running as a VM on an older, broken KVM/kernel.  From
a functional perspective, omitting the check is "fine", as any unwanted
collision between e.g. VMEXIT_INVALID and a 32-bit exit code will be
fatal to KVM-on-KVM regardless of what KVM-as-L1 does.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 202a4d8088a2..3b05476296d0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3433,8 +3433,22 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 		sev_free_decrypted_vmsa(vcpu, save);
 }
 
-int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
+int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 __exit_code)
 {
+	u32 exit_code = __exit_code;
+
+	/*
+	 * SVM uses negative values, i.e. 64-bit values, to indicate that VMRUN
+	 * failed.  Report all such errors to userspace (note, VMEXIT_INVALID,
+	 * a.k.a. SVM_EXIT_ERR, is special cased by svm_handle_exit()).  Skip
+	 * the check when running as a VM, as KVM has historically left garbage
+	 * in bits 63:32, i.e. running KVM-on-KVM would hit false positives if
+	 * the underlying kernel is buggy.
+	 */
+	if (!cpu_feature_enabled(X86_FEATURE_HYPERVISOR) &&
+	    (u64)exit_code != __exit_code)
+		goto unexpected_vmexit;
+
 #ifdef CONFIG_MITIGATION_RETPOLINE
 	if (exit_code == SVM_EXIT_MSR)
 		return msr_interception(vcpu);
@@ -3461,7 +3475,7 @@ int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
 
 unexpected_vmexit:
 	dump_vmcb(vcpu);
-	kvm_prepare_unexpected_reason_exit(vcpu, exit_code);
+	kvm_prepare_unexpected_reason_exit(vcpu, __exit_code);
 	return 0;
 }
 
-- 
2.52.0.rc1.455.g30608eb744-goog


