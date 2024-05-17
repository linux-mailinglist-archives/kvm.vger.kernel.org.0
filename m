Return-Path: <kvm+bounces-17679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F7698C8B81
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:48:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A7611F2194C
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:48:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1247415350E;
	Fri, 17 May 2024 17:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PLaYV/Yt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207FA152536
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967638; cv=none; b=g2APzuY9DDrRmQcbFPWvtIBFN1EsFTrEeLwb5eBgaJTkv3W88HtlzBUOTOehdig7Ln3AmtOZNabkjBszF981/uQp24yrXv2cnugnLTIhwGwL7GuaYgi4r7o7geTJ39bMd+VQ2pzlEsiLjXfztpZBjTx9tMApXAaIqivG7Es3u1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967638; c=relaxed/simple;
	bh=MP3BojoyOHfE0eOIGMkQhT2nECUdHpDoHjRMy4FE9/c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nBpXfzzk+sejg7FHo626FhHxFkOfwLwiy/gdwbgeqdd+XC1fmL552pppg29NGjQDrUFOZKdwgDhnvm9gSgeWiD/sSs3nntt7NJ7e0wX86aMjGQQxBw4jDRYBPMuBeGPytDOt/z7cQtxjOK3JDFf0HvRxtuOjD2SU/EGiq8nE/4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PLaYV/Yt; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61bea0c36bbso187571937b3.2
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967635; x=1716572435; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RdXJF2LBYIp1MINsXWk2QfWIDNlEegsYL67SygmUdrU=;
        b=PLaYV/Yt4uZBmQU4+NSEchgo23qUYvmAIkclPwF3R4EHJNAZYUTEAglBPUu2r/ZKtq
         wzvcxkQXahkTUqecbTXq6yVrrGjUA9Kv9cJ2bxo2D3HoYy7PqsoJCQgAZ7zPGyF8t8Cr
         9GV67qmDQNuo8cKjP/XL0KPHQWlZmYrKGbSLwY6dfscsGoxn64YSpfxWgEM1YCtv/YFi
         LmSRXmN9p9bV8V88NgIHjpjLPMEueuJvsmV2LsgyAn0QsTXp/8FVJ5AIXcfCYy8Hb6RA
         i0I379KkQJy7FBxMwI6e7dQq2iZIu99y7RTNO4x/JjkE/tRpFtiq8EPAwfiC2ASbssgB
         EE0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967635; x=1716572435;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RdXJF2LBYIp1MINsXWk2QfWIDNlEegsYL67SygmUdrU=;
        b=BKRGz5FHa1Irr7/RSvzt19ZDNOnohPl+40Y2OP3mHyJxyhXLcLPdKgILeFYHYbJGqY
         Bv/+ZZqw1Th56SknqQkLtJF971fYjTbIDoeYIgVZRp7trRIBwGs8zBamEoxM6JNbxJap
         dnEtdYlBqcFPaubjPxR54QEdTl4GeyzeUDbUHEgfhNBrs2tzc08Cp+A1a9AqqgtD64aD
         ViGtHgRhj3Ju8HWUusOkBG8KYCDlL0bEctqJnnd6Rxuk2Zql1SaIgcTUS1OdbCKtGnXZ
         pyO/RrxE/pv3p0R5SBtx8/y7STP3EuidW9lGQrCN7iPccGVh18aEgFVqCmMbU83HN42h
         zChw==
X-Gm-Message-State: AOJu0Yy+ngWGTzcKuGhcV5Ieu6yVlekMlnKxadiwEG5H3DwHjM1cPZyn
	0hrIhfyJwi2ApuxFgdxtLyFaSY8S3QLAmhdVzTsGZGnLDKVkwR1TL0v3E3CphBQwGXX978giNr6
	uuw==
X-Google-Smtp-Source: AGHT+IEPO7Eaf/jeysyrL0b5SnzHzvQIj7fvXTUQGmsz6ZBVc/MZSwnDulbX7xYip0GIflrBHDNQtOc6I/w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6302:b0:61b:46e:62da with SMTP id
 00721157ae682-622affc63bfmr57504267b3.4.1715967635244; Fri, 17 May 2024
 10:40:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:39:04 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-28-seanjc@google.com>
Subject: [PATCH v2 27/49] KVM: x86: Swap incoming guest CPUID into vCPU before
 massaging in KVM_SET_CPUID2
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
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

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 49 +++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 33e3e77de1b7..4ad01867cb8d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -175,10 +175,10 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
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
 
@@ -369,9 +369,11 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
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
@@ -436,8 +438,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 					 __cr4_reserved_bits(guest_cpuid_has, vcpu);
 #undef __kvm_cpu_cap_has
 
-	kvm_hv_set_cpuid(vcpu, kvm_cpuid_has_hyperv(vcpu->arch.cpuid_entries,
-						    vcpu->arch.cpuid_nent));
+	kvm_hv_set_cpuid(vcpu, kvm_cpuid_has_hyperv(vcpu));
 
 	/* Invoke the vendor callback only after the above state is updated. */
 	static_call(kvm_x86_vcpu_after_set_cpuid)(vcpu);
@@ -478,6 +479,15 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
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
@@ -497,31 +507,25 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 		 * only because any change in CPUID is disallowed, i.e. using
 		 * stale data is ok because KVM will reject the change.
 		 */
-		__kvm_update_cpuid_runtime(vcpu, e2, nent);
+		kvm_update_cpuid_runtime(vcpu);
 
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
@@ -529,7 +533,14 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
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
2.45.0.215.g3402c0e53f-goog


