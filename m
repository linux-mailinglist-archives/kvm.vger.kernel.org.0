Return-Path: <kvm+bounces-37020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D276A2461A
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:15:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 777D8164319
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:15:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E179A13E02E;
	Sat,  1 Feb 2025 01:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mOiooC+F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829B2139CEF
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738372454; cv=none; b=sKsuCgnBnWhPrf86Q472H6VRUSC7Wj6YYAzaoCTBsyJGRwhrBWaeD/w2IB9kpM1m3KV0efXse+W/EnQ4SMLAm1wk+VUaCcvxi5dSRmsxKgnWrmZt+6nIGPdPV80DYjwB2xnrlxCg6ka0S1POqf2EbcNJrgE208QxoDVkVdjHAmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738372454; c=relaxed/simple;
	bh=gmfQBBKbtVIQGUfDtmdL7tTLbIrBQrlYCQuHcr8oi38=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NPz55qHGAsWI8z3X8Dqo8lga39POdH9O42a3Jhu6g0++MllLzKkNQBlx1NcHVOJ1qC+qFbBABDZGNwdE9++XuJvMEfQt9mOV/md6lKckmqTsdkCNue3Tg3fpEF5iDVfgBK7lLkdu/ADOwAOk80DDQIP3WLUiWwZPED7lxRj+HIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mOiooC+F; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f129f7717fso5027883a91.0
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738372452; x=1738977252; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zo8e7usXx7CJFB7yvSC/9n7CtYEg74QEVFvX1f2FIKc=;
        b=mOiooC+F6LD7cXPyt8cHYkjWj4SAbkEdtNSp0U9C9DfsIrX6PgCisrhWP16TFHUSAP
         CyLRKcCNSO0pXBvwgDEjK/sRGeAiZgQBHfUh0ac+1LBpH8njBdIKiTDas9LewPfafxJB
         +pGh/BAxqfAtqEXhRib7OIhQclxHyQRODDcpa5mGyI4zESUFfhkUojKgkm7N1ev2ocuP
         CNm/CQC0nIjTLEit4KFdrnVX3l71LNz4tV/2+QAmrRivbAZYKRzjB54mBSff3qP3vZrF
         SwQKjokPTdnE7Zbc6HONRfONynSKRdofXs5A3LI4LV0scgFYUN/etH/A0ror941dvAM/
         YwBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738372452; x=1738977252;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zo8e7usXx7CJFB7yvSC/9n7CtYEg74QEVFvX1f2FIKc=;
        b=MO1t084C5NO3LTlAjedg7fbq9cWNaIYjRu61rPsPYuVB5eCaHSPu9AEm0+jCENGOGu
         D61x6HBlkvahLBbuiotPjGNZgwVnYnhBilcYX4AxTFsxV6r2z+LxjHWRmOLEQVAwUiiy
         8gPvQkc4Uf9vLZ9dgD2snhM4qP4OBYJxjJ6adtf4u+YS/2dgQMYuiYS684Z0vG01kApM
         Ks0afew7M8QlViRC+Df59rEed4Wop48SS0nRkaVhrVgncCJwY+uCuRxnq5dfZRlVv6gj
         KbOvkl7rS09hgWuWPY5QPr7uQDGW6MzNSivB2L4E1grrAH525K+bTK9WzcVP+Kb79C85
         IeDA==
X-Gm-Message-State: AOJu0YyDLPdhNB6JILpr36q0ihvtLW6h76axql0WsAZ5J7RaxxNwO+vU
	qytYGyUazIMV3qn3k6L+eMl+5ySF29GWaQ+ZKH6ButIlzVUJGBvDTz1M0uozbHNwQD4SKvNc21k
	3QA==
X-Google-Smtp-Source: AGHT+IE9nZyv3byQJztPPuSt3eQgyUGggpNKDLxk0FqIQjZbmzSHUbiIVphoViaHsQTXXXDXmLBCD6n4DDU=
X-Received: from pjbsb15.prod.google.com ([2002:a17:90b:50cf:b0:2ef:701e:21c1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:534b:b0:2ee:48bf:7dc3
 with SMTP id 98e67ed59e1d1-2f83ac00cd3mr19713341a91.15.1738372451786; Fri, 31
 Jan 2025 17:14:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 17:14:00 -0800
In-Reply-To: <20250201011400.669483-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201011400.669483-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201011400.669483-6-seanjc@google.com>
Subject: [PATCH 5/5] KVM: x86/xen: Move kvm_xen_hvm_config field into kvm_xen
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+cdeaeec70992eca2d920@syzkaller.appspotmail.com, 
	Joao Martins <joao.m.martins@oracle.com>, David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"

Now that all KVM usage of the Xen HVM config information is buried behind
CONFIG_KVM_XEN=y, move the per-VM kvm_xen_hvm_config field out of kvm_arch
and into kvm_xen.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/x86.c              |  2 +-
 arch/x86/kvm/xen.c              | 20 ++++++++++----------
 arch/x86/kvm/xen.h              |  6 +++---
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7f9e00004db2..e9ebd6d6492c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1180,6 +1180,8 @@ struct kvm_xen {
 	struct gfn_to_pfn_cache shinfo_cache;
 	struct idr evtchn_ports;
 	unsigned long poll_mask[BITS_TO_LONGS(KVM_MAX_VCPUS)];
+
+	struct kvm_xen_hvm_config hvm_config;
 };
 #endif
 
@@ -1411,7 +1413,6 @@ struct kvm_arch {
 
 #ifdef CONFIG_KVM_XEN
 	struct kvm_xen xen;
-	struct kvm_xen_hvm_config xen_hvm_config;
 #endif
 
 	bool backwards_tsc_observed;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f13d9d3f7c60..b03c67d53e5f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3188,7 +3188,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	 * problems if they observe PVCLOCK_TSC_STABLE_BIT in the pvclock flags.
 	 */
 	bool xen_pvclock_tsc_unstable =
-		ka->xen_hvm_config.flags & KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE;
+		ka->xen.hvm_config.flags & KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE;
 #endif
 
 	kernel_ns = 0;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 35ecafc410f0..142018b9cdd2 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1280,10 +1280,10 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 		 * Note, truncation is a non-issue as 'lm' is guaranteed to be
 		 * false for a 32-bit kernel, i.e. when hva_t is only 4 bytes.
 		 */
-		hva_t blob_addr = lm ? kvm->arch.xen_hvm_config.blob_addr_64
-				     : kvm->arch.xen_hvm_config.blob_addr_32;
-		u8 blob_size = lm ? kvm->arch.xen_hvm_config.blob_size_64
-				  : kvm->arch.xen_hvm_config.blob_size_32;
+		hva_t blob_addr = lm ? kvm->arch.xen.hvm_config.blob_addr_64
+				     : kvm->arch.xen.hvm_config.blob_addr_32;
+		u8 blob_size = lm ? kvm->arch.xen.hvm_config.blob_size_64
+				  : kvm->arch.xen.hvm_config.blob_size_32;
 		u8 *page;
 		int ret;
 
@@ -1334,13 +1334,13 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)
 
 	mutex_lock(&kvm->arch.xen.xen_lock);
 
-	if (xhc->msr && !kvm->arch.xen_hvm_config.msr)
+	if (xhc->msr && !kvm->arch.xen.hvm_config.msr)
 		static_branch_inc(&kvm_xen_enabled.key);
-	else if (!xhc->msr && kvm->arch.xen_hvm_config.msr)
+	else if (!xhc->msr && kvm->arch.xen.hvm_config.msr)
 		static_branch_slow_dec_deferred(&kvm_xen_enabled);
 
-	old_flags = kvm->arch.xen_hvm_config.flags;
-	memcpy(&kvm->arch.xen_hvm_config, xhc, sizeof(*xhc));
+	old_flags = kvm->arch.xen.hvm_config.flags;
+	memcpy(&kvm->arch.xen.hvm_config, xhc, sizeof(*xhc));
 
 	mutex_unlock(&kvm->arch.xen.xen_lock);
 
@@ -1421,7 +1421,7 @@ static bool kvm_xen_schedop_poll(struct kvm_vcpu *vcpu, bool longmode,
 	int i;
 
 	if (!lapic_in_kernel(vcpu) ||
-	    !(vcpu->kvm->arch.xen_hvm_config.flags & KVM_XEN_HVM_CONFIG_EVTCHN_SEND))
+	    !(vcpu->kvm->arch.xen.hvm_config.flags & KVM_XEN_HVM_CONFIG_EVTCHN_SEND))
 		return false;
 
 	if (IS_ENABLED(CONFIG_64BIT) && !longmode) {
@@ -2299,6 +2299,6 @@ void kvm_xen_destroy_vm(struct kvm *kvm)
 	}
 	idr_destroy(&kvm->arch.xen.evtchn_ports);
 
-	if (kvm->arch.xen_hvm_config.msr)
+	if (kvm->arch.xen.hvm_config.msr)
 		static_branch_slow_dec_deferred(&kvm_xen_enabled);
 }
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index 1e3a913dfb94..d191103d8163 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -53,7 +53,7 @@ static inline void kvm_xen_sw_enable_lapic(struct kvm_vcpu *vcpu)
 static inline bool kvm_xen_msr_enabled(struct kvm *kvm)
 {
 	return static_branch_unlikely(&kvm_xen_enabled.key) &&
-		kvm->arch.xen_hvm_config.msr;
+		kvm->arch.xen.hvm_config.msr;
 }
 
 static inline bool kvm_xen_is_hypercall_page_msr(struct kvm *kvm, u32 msr)
@@ -61,13 +61,13 @@ static inline bool kvm_xen_is_hypercall_page_msr(struct kvm *kvm, u32 msr)
 	if (!static_branch_unlikely(&kvm_xen_enabled.key))
 		return false;
 
-	return msr && msr == kvm->arch.xen_hvm_config.msr;
+	return msr && msr == kvm->arch.xen.hvm_config.msr;
 }
 
 static inline bool kvm_xen_hypercall_enabled(struct kvm *kvm)
 {
 	return static_branch_unlikely(&kvm_xen_enabled.key) &&
-		(kvm->arch.xen_hvm_config.flags &
+		(kvm->arch.xen.hvm_config.flags &
 		 KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL);
 }
 
-- 
2.48.1.362.g079036d154-goog


