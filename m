Return-Path: <kvm+bounces-32682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F7229DB104
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:43:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8B77163A09
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:42:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 099351BD4E2;
	Thu, 28 Nov 2024 01:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vbkrKUYo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED301B85E3
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757729; cv=none; b=sIX6RrHw8EXhgthHZq9XRUQo8HZq8vX4/NeKfvgIk08M1aZx4IHHtwesAo2tqD9ShTyJu6pO7Fg6S4doC/KKGC8XYVzkHCETKOADhR1sqmFIhHi5LY86+m14aRnjyP+knLk5meKm2439F7ItpXq/e8vNSJOqCnlJjYjevezXsQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757729; c=relaxed/simple;
	bh=peSZjwp9N4GYyxZxJDmNcbV4lxAek6oYmW2aosAipq8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A8aqkkN0ZWAYKt/HoltOmtrYrQnQZ8WvJ83eWdyjigHJqntTBp0tUvD6RJTx5cBNrgcRgOJb3kxqkBKowlpyYyos6GvB/uAy0rVvHLUhsDM+w9OufWADP7j17JZkL0O1rGYQ5ilV/9SI2+II6D88whFpnnwMAHy0FGQ0Ul45o2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vbkrKUYo; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee21b04e37so404156a91.0
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:35:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757726; x=1733362526; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wsiqnlMyI9LsDoPx/20B2/eZF/hcCF3HsjWTeiF8Pvw=;
        b=vbkrKUYoYgyCc8QK9tUXR/MR1uXZ8wpqTxZcg3eYngNkAGT7NvWrcx4PSRgSUk0Jk9
         /Zh4QfVueFnkwW9RlQt2srVdV7gE/8b2pHy4AFFo+UT5uzb9dQ9MJsaD0S8bXkZkjU2X
         caQsKZiwLSqYwK1HF92aW5AvinnVMuppKERCr2SB+26SGxws7Ky3uqosdfs3CXBGqaQP
         SLN/05jHWJJ632VrYqu8zYJKk/ASrF+k0v5fEp7PwkKpKk+z8vlB8S3rq4iqoLmrCAPO
         Ov7FkiBSo+rL5asYGv5IWm1tr5nGa6cLiLUswBk5DvseUE0T3NiDXH5zM/ZiA10rhVEp
         Cgdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757726; x=1733362526;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wsiqnlMyI9LsDoPx/20B2/eZF/hcCF3HsjWTeiF8Pvw=;
        b=OcGfm5jPc2JUvpa9S2XIuabNc9VGIxQ7Qm6F8q2xWAoLgOudvfnWJXc/W3CpljYB+R
         SWnfQLGaJo8ZgcSeZVIf1qTQlog7OigYmN5sfGD1PH156QDEBH31BZyhvAANoOJAopet
         RVlC9DXjhp5BkrQqh7J1tI3pxqghI9A/cPkgyPDZQVJsbD5KxlWOlaIDB36aITcX8szC
         3G5AdwzEEiqunON0gXr0Z8KTYHUODar5IJUkwphKuT6fJ8avsAM47MVSkl/BZSJjK0qP
         iQhB3g1UJvPxzsIc3i9+QH7zYrmL9Rv6LrVz8L6GUBKUuaYl/VpsMuUfFm659ks97v3B
         5cpg==
X-Gm-Message-State: AOJu0YzKll/WbEqxa0HKJNaTWq66xL7oe5xOuEzUhZ5XVypYivJVXLAM
	pj8nCrVgL2OA7VJSCD3relt94KfLv3aonQz/UV4ju580i5aa5sptvpudkU73fGtWRtzUo8tu0tJ
	zIw==
X-Google-Smtp-Source: AGHT+IHNWaK/qErhB07E/52bf/qK2vcCbryuSp9yMaVb9Qldlu/FhFH2PFUyKXSVTHvAmvs9ISiqiOaumqA=
X-Received: from pjbcz13.prod.google.com ([2002:a17:90a:d44d:b0:2e1:87e7:ede0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38cd:b0:2ea:adaa:1a46
 with SMTP id 98e67ed59e1d1-2ee097e2045mr6112849a91.36.1732757726083; Wed, 27
 Nov 2024 17:35:26 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:58 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-32-seanjc@google.com>
Subject: [PATCH v3 31/57] KVM: x86: Swap incoming guest CPUID into vCPU before
 massaging in KVM_SET_CPUID2
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

When handling KVM_SET_CPUID{,2}, swap the old and new CPUID arrays and
lengths before processing the new CPUID, and simply undo the swap if
setting the new CPUID fails for whatever reason.

To keep the diff reasonable, continue passing the entry array and length
to most helpers, and defer the more complete cleanup to future commits.

For any sane VMM, setting "bad" CPUID state is not a hot path (or even
something that is surviable), and setting guest CPUID before it's known
good will allow removing all of KVM's infrastructure for processing CPUID
entries directly (as opposed to operating on vcpu->arch.cpuid_entries).

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 54 ++++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 83b29c5a0498..e8c30de2faa9 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -121,10 +121,10 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
 	return NULL;
 }
 
-static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
-			   struct kvm_cpuid_entry2 *entries,
-			   int nent)
+static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpuid_entry2 *entries = vcpu->arch.cpuid_entries;
+	int nent = vcpu->arch.cpuid_nent;
 	struct kvm_cpuid_entry2 *best;
 	u64 xfeatures;
 
@@ -157,9 +157,6 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
 	return fpu_enable_guest_xfd_features(&vcpu->arch.guest_fpu, xfeatures);
 }
 
-static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
-				       int nent);
-
 /* Check whether the supplied CPUID data is equal to what is already set for the vCPU. */
 static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 				 int nent)
@@ -175,8 +172,10 @@ static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2
 	 * CPUID processing is functionally correct only because any change in
 	 * CPUID is disallowed, i.e. using stale data is ok because the below
 	 * checks will reject the change.
+	 *
+	 * Note!  @e2 and @nent track the _old_ CPUID entries!
 	 */
-	__kvm_update_cpuid_runtime(vcpu, e2, nent);
+	kvm_update_cpuid_runtime(vcpu);
 
 	if (nent != vcpu->arch.cpuid_nent)
 		return -EINVAL;
@@ -329,9 +328,11 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
 
-static bool kvm_cpuid_has_hyperv(struct kvm_cpuid_entry2 *entries, int nent)
+static bool kvm_cpuid_has_hyperv(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_KVM_HYPERV
+	struct kvm_cpuid_entry2 *entries = vcpu->arch.cpuid_entries;
+	int nent = vcpu->arch.cpuid_nent;
 	struct kvm_cpuid_entry2 *entry;
 
 	entry = cpuid_entry2_find(entries, nent, HYPERV_CPUID_INTERFACE,
@@ -408,8 +409,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 					 __cr4_reserved_bits(guest_cpuid_has, vcpu);
 #undef __kvm_cpu_cap_has
 
-	kvm_hv_set_cpuid(vcpu, kvm_cpuid_has_hyperv(vcpu->arch.cpuid_entries,
-						    vcpu->arch.cpuid_nent));
+	kvm_hv_set_cpuid(vcpu, kvm_cpuid_has_hyperv(vcpu));
 
 	/* Invoke the vendor callback only after the above state is updated. */
 	kvm_x86_call(vcpu_after_set_cpuid)(vcpu);
@@ -450,6 +450,15 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 {
 	int r;
 
+	/*
+	 * Swap the existing (old) entries with the incoming (new) entries in
+	 * order to massage the new entries, e.g. to account for dynamic bits
+	 * that KVM controls, without clobbering the current guest CPUID, which
+	 * KVM needs to preserve in order to unwind on failure.
+	 */
+	swap(vcpu->arch.cpuid_entries, e2);
+	swap(vcpu->arch.cpuid_nent, nent);
+
 	/*
 	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
 	 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
@@ -464,27 +473,21 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	if (kvm_vcpu_has_run(vcpu)) {
 		r = kvm_cpuid_check_equal(vcpu, e2, nent);
 		if (r)
-			return r;
-
-		kvfree(e2);
-		return 0;
+			goto err;
+		goto success;
 	}
 
 #ifdef CONFIG_KVM_HYPERV
-	if (kvm_cpuid_has_hyperv(e2, nent)) {
+	if (kvm_cpuid_has_hyperv(vcpu)) {
 		r = kvm_hv_vcpu_init(vcpu);
 		if (r)
-			return r;
+			goto err;
 	}
 #endif
 
-	r = kvm_check_cpuid(vcpu, e2, nent);
+	r = kvm_check_cpuid(vcpu);
 	if (r)
-		return r;
-
-	kvfree(vcpu->arch.cpuid_entries);
-	vcpu->arch.cpuid_entries = e2;
-	vcpu->arch.cpuid_nent = nent;
+		goto err;
 
 	vcpu->arch.kvm_cpuid = kvm_get_hypervisor_cpuid(vcpu, KVM_SIGNATURE);
 #ifdef CONFIG_KVM_XEN
@@ -492,7 +495,14 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 #endif
 	kvm_vcpu_after_set_cpuid(vcpu);
 
+success:
+	kvfree(e2);
 	return 0;
+
+err:
+	swap(vcpu->arch.cpuid_entries, e2);
+	swap(vcpu->arch.cpuid_nent, nent);
+	return r;
 }
 
 /* when an old userspace process fills a new kernel module */
-- 
2.47.0.338.g60cca15819-goog


