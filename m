Return-Path: <kvm+bounces-32655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38D6C9DB0CB
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:35:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E467D280CF8
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:35:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15BBD1304AB;
	Thu, 28 Nov 2024 01:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sLkVuo8i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8F812C7FD
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757681; cv=none; b=rMi9/H4mLdg1V3E5JruzN8DRLHM0+XstojzSMmzymkFCEuX2d0nWk0X7fXX71WRDCCxEU3O7v/zbd230FYmZOnc57DTf98XSK2um1PKCR2Qcih1wV/g6OdNBwnzqtKV8CWkyKSLlEg97PkmA+j/nOQeOFKHfNbS1GBGmWm421Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757681; c=relaxed/simple;
	bh=xkgHLYKOgc9UOjDkFsxZNP4UICj4tKyQOB3cA2N7sag=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R2FGUt8NhzYpLhpbpBSH5cgqqWMPDm13aKAapZXMYRpCwVdVR8nCKIjHrLDONc+IXtcVMfNMoTykeQl5EbmsabasELnthfMEHDPLJFbfKvU6OlLJdHisEtXmxjcW6YPv6wTPH3XrxTkdGcyb4oRmWnJQcBBZiB/Bx6gFUx4iDLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sLkVuo8i; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2edba08c89bso388362a91.1
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757679; x=1733362479; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=63aSip+cazQDf8K6M+lsqKQSUHfXVn0zrx6IJYV6OTo=;
        b=sLkVuo8i5Q4B5VLb2cTXJTIdk3JQGUGYxMhf9Yc1zQiPTG/k1YGrJDXipePSDT8ZJ4
         oPkD2+8l+vlmopaG01wobMdLbOdUA6avTOttz+Ee8GZodI5m67lddPQllQjZ2I37tn2k
         3PYhOrzEFQVeCNdsa4bk0+sKKDEApVS3CNlL9JKfC6JTmoAC8VVgm8neXg91ojAu7sgn
         FIKs513b0N25iiQPEjm3WZucrSWTcWqvfEFd99pBWcNwkUnC4EqqxHf4IBVbVZ+fgHvp
         LREcvQ5Dta5/OqbPJrdZ2PaOJLb8S/LM/td+tHkjvixmFFGjn6I7i8Zutr6UbDEoGxvL
         dEWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757679; x=1733362479;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=63aSip+cazQDf8K6M+lsqKQSUHfXVn0zrx6IJYV6OTo=;
        b=rpHATyJoPJ2jdH22EqYafgFWusk0UwBkyxRRLwMNiT0wxUEi6XGwbRIt02qkzBr5nk
         8E9N52uBAPavfULo7gCPTzcab9BPHYSq4FUh0LitthXrMTjxcAP5oJP6ZhYCEZFWC1fr
         8yZFLgbdkHqW6hmVHxvfn5blUs5+4QUcU2DQRmQJrjYR6LkpXkbxzFJK8kVz1ZEWB5NW
         08DEwWiM4GJqgXM+HrNpqzR6prMo6rbsm+NJclhimAa4q77Tv/dNDX79+WR8GAzlEwCL
         1dJZ5WMKvsoxDcfVOWwF6ZGYACVR7d0+nLTMs1t1V7ymbyU63nIEwhVjFZhORa24jh21
         JUsw==
X-Gm-Message-State: AOJu0YwbsNfg1907ny05ckNAbfjmXKc25tL1DNaCs9P9PLMRdYUDQfdH
	UbGTtd2awe+X2I2E+wNBXLdSwJBrOtM1Jlhd3Av/jA9ho+a1A27cRzS2aoxBdTFvn0Ik6HGi8J8
	DrQ==
X-Google-Smtp-Source: AGHT+IHAKYyva2OQ2qZQzRH4TY78SgPHtJqed37fmibnibVOLNekS1q+MnqBaVU8gqhPocMC9s980/Kf1V4=
X-Received: from pjd6.prod.google.com ([2002:a17:90b:54c6:b0:2ea:7174:2101])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c42:b0:2ea:4480:e3e5
 with SMTP id 98e67ed59e1d1-2ee08ed4488mr5835622a91.22.1732757679026; Wed, 27
 Nov 2024 17:34:39 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:31 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-5-seanjc@google.com>
Subject: [PATCH v3 04/57] KVM: x86: Explicitly do runtime CPUID updates
 "after" initial setup
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly perform runtime CPUID adjustments as part of the "after set
CPUID" flow to guard against bugs where KVM consumes stale vCPU/CPUID
state during kvm_update_cpuid_runtime().  E.g. see commit 4736d85f0d18
("KVM: x86: Use actual kvm_cpuid.base for clearing KVM_FEATURE_PV_UNHALT").

Whacking each mole individually is not sustainable or robust, e.g. while
the aforemention commit fixed KVM's PV features, the same issue lurks for
Xen and Hyper-V features, Xen and Hyper-V simply don't have any runtime
features (though spoiler alert, neither should KVM).

Updating runtime features in the "full" path will also simplify adding a
snapshot of the guest's capabilities, i.e. of caching the intersection of
guest CPUID and kvm_cpu_caps (modulo a few edge cases).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b9ad07e24160..1944f9415672 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -157,6 +157,9 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
 	return fpu_enable_guest_xfd_features(&vcpu->arch.guest_fpu, xfeatures);
 }
 
+static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
+				       int nent);
+
 /* Check whether the supplied CPUID data is equal to what is already set for the vCPU. */
 static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 				 int nent)
@@ -164,6 +167,17 @@ static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2
 	struct kvm_cpuid_entry2 *orig;
 	int i;
 
+	/*
+	 * Apply runtime CPUID updates to the incoming CPUID entries to avoid
+	 * false positives due mismatches on KVM-owned feature flags.  Note,
+	 * runtime CPUID updates may consume other CPUID-driven vCPU state,
+	 * e.g. KVM or Xen CPUID bases.  Updating runtime state before full
+	 * CPUID processing is functionally correct only because any change in
+	 * CPUID is disallowed, i.e. using stale data is ok because the below
+	 * checks will reject the change.
+	 */
+	__kvm_update_cpuid_runtime(vcpu, e2, nent);
+
 	if (nent != vcpu->arch.cpuid_nent)
 		return -EINVAL;
 
@@ -348,6 +362,8 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	bitmap_zero(vcpu->arch.governed_features.enabled,
 		    KVM_MAX_NR_GOVERNED_FEATURES);
 
+	kvm_update_cpuid_runtime(vcpu);
+
 	/*
 	 * If TDP is enabled, let the guest use GBPAGES if they're supported in
 	 * hardware.  The hardware page walker doesn't let KVM disable GBPAGES,
@@ -429,8 +445,6 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 {
 	int r;
 
-	__kvm_update_cpuid_runtime(vcpu, e2, nent);
-
 	/*
 	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
 	 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
-- 
2.47.0.338.g60cca15819-goog


