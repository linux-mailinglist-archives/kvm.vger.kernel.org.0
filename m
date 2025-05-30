Return-Path: <kvm+bounces-48117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E55B1AC95D7
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 20:53:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D9DA61C20941
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 18:53:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E463D2367D6;
	Fri, 30 May 2025 18:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="llTV347G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC3F189513
	for <kvm@vger.kernel.org>; Fri, 30 May 2025 18:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748631174; cv=none; b=cYu3hl0UL2aJY4ghLhhW3xAw0qY/MNPG9GAmLiC1xZX9uCSWnhPJYNjUhfZf1oxZGjTVehhyhjSlmxMKV4nYC2fXtUyxUpn6Z5zbF1gHQJpgJpKYUXoWOJMd39jbe1PIwV4dkBIPjQY6QYZppyEZtuEEYZUywoFTAyZuX0UqDbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748631174; c=relaxed/simple;
	bh=9N7GPALbliydFCbK3hpQ2CRhxsq5NHxBiR+n7tWS/0s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GGYhq3pEvzddLg1hZlWzSWEb0SXwzyMCQrC71vuf5Dflx5HHYskDO811VlLl1An3MHSXpd6S5wMJ69Xhz/aBwnt7zoTpeH/Q1FhSfxD3cWGlGvkqWhYGOPqedsV3rEAqNyPtXzQW3CVh/Ib0kCCCPi9a37arSRrcXoLMe7AGbSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=llTV347G; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311ae2b6647so1991971a91.0
        for <kvm@vger.kernel.org>; Fri, 30 May 2025 11:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748631172; x=1749235972; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wsem6FS+PM3bxBHh8NW9Zw6YYHvZLyt09vacNObz8Kk=;
        b=llTV347GW4aIYXAXEUeRnCr/IDn1xps8anM5aCrMwVb2auG/KC8YMYHNSfMEuQyHOV
         wpMb8L7ehYla0BRJt0AzRfUMrMIOuh8mSVwVIn7FLTOqvLg9LCxL41pMrc2159h96UBT
         J1z2fWbKKI+V3jt/qHU9idLofVitj7h3fTyfXwnGhhHXs2Xp5lqgwM2/zH2D41fS+zEA
         bk6bWkWMXdgc4SPcMi5uU2MJbVkpJvR8GLw+UQnNCRZ4TpWWksTpcIAlRbPrV4ykgYHj
         rbbacsdQouBF57HXRo/QskKgmy82v5w+hXh3n0sLb7uO+v5B9bWFqD7r7hywTT6RzL3Q
         0e+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748631172; x=1749235972;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wsem6FS+PM3bxBHh8NW9Zw6YYHvZLyt09vacNObz8Kk=;
        b=AnF2KD8OYtBpneY5l7NCNSUrsyBukmaZrdQfVNoo6ydEmlkCIG1OuC/s3K6ehOib6/
         aoYLQANcTnkfS+WB+ox7QhGxtcUfEvyKHLVI4HoXmb5/AjjHki0QUWnb+hXmIY8v7I+b
         07J0l7jwGTIGjpJZc63E9Rvwsc+R5OcBOVDhsZWDwYoLwcaa4K0JyFg2Cr3QHGe9A2wn
         g44X/jgBn9cQAk/96cmKXyqbXFGqArQ074phNKZRsyIUOMmZc/zzwgY2oDwG++T1PBtM
         sAwc8SR9fmHmz4yGphvU5ld5HhKVWoFIppwU3FK6uGCtJvm5Vj0MyG0dkIdIjGOiefWG
         f81g==
X-Forwarded-Encrypted: i=1; AJvYcCWII/Nj3e/kWGhX+mBJZcH6qoOYCnmyuZqo5YeCZsZPV0uVdYR+skiVCrMGpY+HXHH+9lc=@vger.kernel.org
X-Gm-Message-State: AOJu0YznsH3xqFjKI5l+Z8ESYcJ/0oF1aBF0EfWjxdkpeJjhaMvKNSEv
	wFVfFilLw77I1Dnyypj/8KreK40TMKzEDdwcjUSyk1mbRm0ZkD7Mm9uvWxaip3fCoCKKYV7+oYj
	3PMOot+xx8BmFww==
X-Google-Smtp-Source: AGHT+IFf7MqqMfOKOjix7RpuNvyJUwtvvuOnvE9h5W5zVtYWyLuoC3her9u9EPzEnX4PAanpaT0+GNcigKf8KA==
X-Received: from pjbpd3.prod.google.com ([2002:a17:90b:1dc3:b0:311:df47:4773])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3505:b0:311:b5ac:6f6b with SMTP id 98e67ed59e1d1-31250368f94mr4817373a91.9.1748631171880;
 Fri, 30 May 2025 11:52:51 -0700 (PDT)
Date: Fri, 30 May 2025 11:52:23 -0700
In-Reply-To: <20250530185239.2335185-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250530185239.2335185-1-jmattson@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250530185239.2335185-2-jmattson@google.com>
Subject: [PATCH v4 1/3] KVM: x86: Replace growing set of *_in_guest bools with
 a u64
From: Jim Mattson <jmattson@google.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Store each "disabled exit" boolean in a single bit rather than a byte.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +----
 arch/x86/kvm/svm/svm.c          |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 arch/x86/kvm/x86.c              |  8 ++++----
 arch/x86/kvm/x86.h              | 13 +++++++++----
 5 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 67b464651c8d..fa912b2e7591 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1390,10 +1390,7 @@ struct kvm_arch {
 
 	gpa_t wall_clock;
 
-	bool mwait_in_guest;
-	bool hlt_in_guest;
-	bool pause_in_guest;
-	bool cstate_in_guest;
+	u64 disabled_exits;
 
 	unsigned long irq_sources_bitmap;
 	s64 kvmclock_offset;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ffb34dadff1c..6d2d97fd967a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5102,7 +5102,7 @@ static int svm_vm_init(struct kvm *kvm)
 	}
 
 	if (!pause_filter_count || !pause_filter_thresh)
-		kvm->arch.pause_in_guest = true;
+		kvm_disable_exits(kvm, KVM_X86_DISABLE_EXITS_PAUSE);
 
 	if (enable_apicv) {
 		int ret = avic_vm_init(kvm);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b12414108cbf..136be14e6db0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7619,7 +7619,7 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 int vmx_vm_init(struct kvm *kvm)
 {
 	if (!ple_gap)
-		kvm->arch.pause_in_guest = true;
+		kvm_disable_exits(kvm, KVM_X86_DISABLE_EXITS_PAUSE);
 
 	if (boot_cpu_has(X86_BUG_L1TF) && enable_ept) {
 		switch (l1tf_mitigation) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 570e7f8cbf64..8c20afda4398 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6605,13 +6605,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			pr_warn_once(SMT_RSB_MSG);
 
 		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
-			kvm->arch.pause_in_guest = true;
+			kvm_disable_exits(kvm, KVM_X86_DISABLE_EXITS_PAUSE);
 		if (cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT)
-			kvm->arch.mwait_in_guest = true;
+			kvm_disable_exits(kvm, KVM_X86_DISABLE_EXITS_MWAIT);
 		if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
-			kvm->arch.hlt_in_guest = true;
+			kvm_disable_exits(kvm, KVM_X86_DISABLE_EXITS_HLT);
 		if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
-			kvm->arch.cstate_in_guest = true;
+			kvm_disable_exits(kvm, KVM_X86_DISABLE_EXITS_CSTATE);
 		r = 0;
 disable_exits_unlock:
 		mutex_unlock(&kvm->lock);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 88a9475899c8..0ad36851df4c 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -481,24 +481,29 @@ static inline u64 nsec_to_cycles(struct kvm_vcpu *vcpu, u64 nsec)
 	    __rem;						\
 	 })
 
+static inline void kvm_disable_exits(struct kvm *kvm, u64 mask)
+{
+	kvm->arch.disabled_exits |= mask;
+}
+
 static inline bool kvm_mwait_in_guest(struct kvm *kvm)
 {
-	return kvm->arch.mwait_in_guest;
+	return kvm->arch.disabled_exits & KVM_X86_DISABLE_EXITS_MWAIT;
 }
 
 static inline bool kvm_hlt_in_guest(struct kvm *kvm)
 {
-	return kvm->arch.hlt_in_guest;
+	return kvm->arch.disabled_exits & KVM_X86_DISABLE_EXITS_HLT;
 }
 
 static inline bool kvm_pause_in_guest(struct kvm *kvm)
 {
-	return kvm->arch.pause_in_guest;
+	return kvm->arch.disabled_exits & KVM_X86_DISABLE_EXITS_PAUSE;
 }
 
 static inline bool kvm_cstate_in_guest(struct kvm *kvm)
 {
-	return kvm->arch.cstate_in_guest;
+	return kvm->arch.disabled_exits & KVM_X86_DISABLE_EXITS_CSTATE;
 }
 
 static inline bool kvm_notify_vmexit_enabled(struct kvm *kvm)
-- 
2.49.0.1204.g71687c7c1d-goog


