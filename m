Return-Path: <kvm+bounces-17681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7201D8C8B88
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:49:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C7660B24750
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:49:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D0CC153BD7;
	Fri, 17 May 2024 17:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fsbHYPZ+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01ED6153820
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967641; cv=none; b=jwklrtEiGYZS8HD1HpNI0pJaMNsxZ21drLY/aYZi7UXNCCidr6J/MzLG2rHNUhHhCmC1NhqcYOtzJ7Tau0ZNCSa5RPC5foUh+3mOYL8ChVTZv65jwyeQwNlyg4KV+zB4jotBGCqVpsuGNk94tcsrkweaqWADuuwgnzuJ4mRLPKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967641; c=relaxed/simple;
	bh=q6H24XTOw5jOHO1mRplgtF7Ho2CCrC831sb6N2j+gE4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jVUiQESdjnyzHU81DLwJzfmJ2VbHnE068HbgBGZEFeMLUXjkaBnkymntfbJWKI7DEoX6QQhEYnr0H5SN9SdXfhp/CU6AZtgY3J9PIh0dymharrRcxCXV9MhHh+VbIiurWVJ6F37eBEOAw2KrZObPM8l7hyf4roYmQBYPH8sR+NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fsbHYPZ+; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61be23bb01aso199167597b3.2
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967639; x=1716572439; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lNzeyIHxwW/+xXRnTMfyELju+tot5aIGCckb2dIAUSc=;
        b=fsbHYPZ+kQu/V2Fug9aey7tMUbw57I0lMJ0hxmzKDdL29wEn4E2XR485jhrCO0YjsH
         eE+3JzFYXMBSvRsZnIoydPqCEbCG4P3XT33Ej5jxvNNkFu77InibCmRRScYg9W4IbqOS
         DegDEEa39aS2cw169phg3hvVTQmSPF1LNF4qMrdJ2SwckQv4zG5qFP7UcI/X20x5Ogzp
         2NIEZA60qIl52ID7cD+PZvwM30P2oW5crKtJ87SkBCqgdCD4ZrpwnRHFObzEbp8yKZGw
         2aECr7V298M1Z5NfNrrii4oz6StxNClRJyG120bPRwHp32BTeXot39VgDmorcQMzH5tx
         lbIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967639; x=1716572439;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lNzeyIHxwW/+xXRnTMfyELju+tot5aIGCckb2dIAUSc=;
        b=PAA1EHswRyAFp1svn0K+V/Iv6KR0hKL5yOBSAxNobMKaG2baG56FWhKnbQ5im8hEWF
         W+2ERfHIkwkHqhXEC79vV44lRI6DLc2xB+dpyKMK/6PB7kg/FwKO8pkrmEDgutFwLRpg
         0ZMi2FRGsA+TkkpNVP2OJUBuhVLXicXTLenwrcz/4cEschNeU02Nacm+BzczB+khoe/R
         GwYaHKafHPrF4QA7jkm1G17V9grXCwRML/TwwtCF9Mj1WqlR4RMJz5lthhsbt7nRbeqs
         MXtizA2oJMixoDu5f89UdyP9ENcvqeNJesR1x3y09YnJS5GERzHPOPvTzr8/ri97DKHI
         4Trw==
X-Gm-Message-State: AOJu0YxTNvDUc25JMZ8Y61HZmZcCnBgkOGq3RkcL2eiAc3EZw6iQQpPu
	L+jihzVch2ncD4TZG3ZuCj1zBM/BCaTnn8VaiD5lJQ1SBpkwMxXFz6Sbq0Ah0CMz592QrPUeaaB
	NnQ==
X-Google-Smtp-Source: AGHT+IG8S/rP43H8qvhLiLuEJigMPjzRCWNnOJIra1Y0oWmyqZEO9qjoY5EvLJ6WB8E9FVJIcdoIf5CRXvA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d8d5:0:b0:627:7cac:6afb with SMTP id
 00721157ae682-6277cac6b6cmr11324997b3.9.1715967639056; Fri, 17 May 2024
 10:40:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:39:06 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-30-seanjc@google.com>
Subject: [PATCH v2 29/49] KVM: x86: Remove unnecessary caching of KVM's PV
 CPUID base
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Now that KVM only searches for KVM's PV CPUID base when userspace sets
guest CPUID, drop the cache and simply do the search every time.

Practically speaking, this is a nop except for situations where userspace
sets CPUID _after_ running the vCPU, which is anything but a hot path,
e.g. QEMU does so only when hotplugging a vCPU.  And on the flip side,
caching guest CPUID information, especially information that is used to
query/modify _other_ CPUID state, is inherently dangerous as it's all too
easy to use stale information, i.e. KVM should only cache CPUID state when
the performance and/or programming benefits justify it.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/cpuid.c            | 34 +++++++--------------------------
 2 files changed, 7 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index aabf1648a56a..3003e99155e7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -858,7 +858,6 @@ struct kvm_vcpu_arch {
 
 	int cpuid_nent;
 	struct kvm_cpuid_entry2 *cpuid_entries;
-	struct kvm_hypervisor_cpuid kvm_cpuid;
 	bool is_amd_compatible;
 
 	/*
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 93a7399dc0db..7290f91c422c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -269,28 +269,16 @@ static struct kvm_hypervisor_cpuid kvm_get_hypervisor_cpuid(struct kvm_vcpu *vcp
 					  vcpu->arch.cpuid_nent, sig);
 }
 
-static struct kvm_cpuid_entry2 *__kvm_find_kvm_cpuid_features(struct kvm_cpuid_entry2 *entries,
-							      int nent, u32 kvm_cpuid_base)
-{
-	return cpuid_entry2_find(entries, nent, kvm_cpuid_base | KVM_CPUID_FEATURES,
-				 KVM_CPUID_INDEX_NOT_SIGNIFICANT);
-}
-
-static struct kvm_cpuid_entry2 *kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcpu)
-{
-	u32 base = vcpu->arch.kvm_cpuid.base;
-
-	if (!base)
-		return NULL;
-
-	return __kvm_find_kvm_cpuid_features(vcpu->arch.cpuid_entries,
-					     vcpu->arch.cpuid_nent, base);
-}
-
 static u32 kvm_apply_cpuid_pv_features_quirk(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpuid_entry2 *best = kvm_find_kvm_cpuid_features(vcpu);
+	struct kvm_hypervisor_cpuid kvm_cpuid;
+	struct kvm_cpuid_entry2 *best;
 
+	kvm_cpuid = kvm_get_hypervisor_cpuid(vcpu, KVM_SIGNATURE);
+	if (!kvm_cpuid.base)
+		return 0;
+
+	best = kvm_find_cpuid_entry(vcpu, kvm_cpuid.base | KVM_CPUID_FEATURES);
 	if (!best)
 		return 0;
 
@@ -491,13 +479,6 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	 * whether the supplied CPUID data is equal to what's already set.
 	 */
 	if (kvm_vcpu_has_run(vcpu)) {
-		/*
-		 * Note, runtime CPUID updates may consume other CPUID-driven
-		 * vCPU state, e.g. KVM or Xen CPUID bases.  Updating runtime
-		 * state before full CPUID processing is functionally correct
-		 * only because any change in CPUID is disallowed, i.e. using
-		 * stale data is ok because KVM will reject the change.
-		 */
 		kvm_update_cpuid_runtime(vcpu);
 		kvm_apply_cpuid_pv_features_quirk(vcpu);
 
@@ -519,7 +500,6 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	if (r)
 		goto err;
 
-	vcpu->arch.kvm_cpuid = kvm_get_hypervisor_cpuid(vcpu, KVM_SIGNATURE);
 #ifdef CONFIG_KVM_XEN
 	vcpu->arch.xen.cpuid = kvm_get_hypervisor_cpuid(vcpu, XEN_SIGNATURE);
 #endif
-- 
2.45.0.215.g3402c0e53f-goog


