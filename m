Return-Path: <kvm+bounces-17653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FE328C8B49
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:40:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 91A2A1F20F02
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:40:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FBB113E03E;
	Fri, 17 May 2024 17:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G82FhUxK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B06713DDCD
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967588; cv=none; b=rMmL3l5W9jqWO63pK7ZWs9x7KM/DEqe/wxYf70EfwWYaUS6gOpwN/B03UAO9AZueC5NFr28/Jmmnc66j9K4E14Yjcae1qK4rpoEIK73qp35oJC0TynEH/us1UaIEtG9wLxcML4db8Wvt9Y0p7dZkbslL6riu/vnQeQKeA6c+Hg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967588; c=relaxed/simple;
	bh=9p2+z3k+6TgyjKDlNleEqXcUN36cKZjmsbnwqvT7uZM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hFipAK5HnJgC0Eh8v+Ks0qY3u9CvzMZ93l7+6MUF+m9SyJpFtUOAuHm2SEDDHKs6f6/ITseeMeEZ1ne8igAjbILPHmBEdnLzaOONxcCVGrw603Npdq7MhunPUXYhurcVwuIKPIRxxCRXItWqk7eo55rVmeqWM97tVxS68bp4Hqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G82FhUxK; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1eea09ec7ecso94831265ad.2
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967586; x=1716572386; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=s4kTj1Xv//RX7ELH5Gm2ht5CFG6yTV867Y6JHJnZkTw=;
        b=G82FhUxKpm9broRf53twt3QSvC4AXORTQJ5id42ruXXt/uTqGvnU7KrnYmIWYixiof
         c7u/LkjvZuOJ/9QYoUhSn6VsXoAw7jafSMdIXtSz1gl5/0gHXcWtucN77ZXpnWZvtfQ/
         4iI9gzSSLfEWPFT7JLBp8m1n4u5D2BBcfzKNAuTFPnPnZ4KQ+Ze/PHN/uRWiZg0Ov+QZ
         D5Rc30Yq5IMl7qu0gJ+hIbTvCMxLdsb6FL5KDvvEjShAuYV4+Fq6BF7a4jL6UfYf2HNn
         VeWsTKLoAuQmee7BiKTLR7as0779C7jgWnyN1CtBlRZhl5BKodGNV+J14jYezkgo3FSb
         +TgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967586; x=1716572386;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s4kTj1Xv//RX7ELH5Gm2ht5CFG6yTV867Y6JHJnZkTw=;
        b=ZIPjw2fN+aoUOboFm2mKnCHpQa8XuhQdGh4kVDP8NQnRQ8AC1if6i6I0czIVHGFP1h
         zfu6Yi2mX5codBraqgzDkveEa7ohctkl1AnS2VBixr6zojKoPyKzLJPsWnrjewkBx5dB
         NPhToAdX8bz4ayHBjFBVI0C8hD6F6A4NP0irSDNQJqUqExUquysoPM88JWitzObbkSYS
         XuYkv9FkJjgABHe2OOWpqijzAmIBMOMz32VnYYUDx5BOaUQk8+UnfctIgs6Yy/0njOv7
         naXONaIJrpghXkY/MlhBMrmGvJYeka8bF9CtPcYnVoccSkOBkhwAtIiH4YYurumumMaJ
         kbBw==
X-Gm-Message-State: AOJu0YxlP101snOETEKbbBTfMFI5hOTUl/UVSu4Bq3vzRLs5nzOccE08
	PPjJmZjUM/oDrhUDi+sU+vkMB79oACBESJaZsxnFrCt73aUnHO1CoGYE14GhnHsSFL7Xm2eltpt
	l6w==
X-Google-Smtp-Source: AGHT+IFcafYI9QmJB1eHvPXT14ZAn2abKBNyzqvUSDNr31a0Ns45ESpeAxr0qlAqwCFA+PVsS05zj4sIjrA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1d1:b0:1eb:2fb3:fa0c with SMTP id
 d9443c01a7336-1ef43c13f0amr6903255ad.3.1715967586406; Fri, 17 May 2024
 10:39:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:38:38 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-2-seanjc@google.com>
Subject: [PATCH v2 01/49] KVM: x86: Do all post-set CPUID processing during
 vCPU creation
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

During vCPU creation, process KVM's default, empty CPUID as if userspace
set an empty CPUID to ensure consistent and correct behavior with respect
to guest CPUID.  E.g. if userspace never sets guest CPUID, KVM will never
configure cr4_guest_rsvd_bits, and thus create divergent, incorrect, guest-
visible behavior due to letting the guest set any KVM-supported CR4 bits
despite the features not being allowed per guest CPUID.

Note!  This changes KVM's ABI, as lack of full CPUID processing allowed
userspace to stuff garbage vCPU state, e.g. userspace could set CR4 to a
guest-unsupported value via KVM_SET_SREGS.  But it's extremely unlikely
that this is a breaking change, as KVM already has many flows that require
userspace to set guest CPUID before loading vCPU state.  E.g. multiple MSR
flows consult guest CPUID on host writes, and KVM_SET_SREGS itself already
relies on guest CPUID being up-to-date, as KVM's validity check on CR3
consumes CPUID.0x7.1 (for LAM) and CPUID.0x80000008 (for MAXPHYADDR).

Furthermore, the plan is to commit to enforcing guest CPUID for userspace
writes to MSRs, at which point bypassing sregs CPUID checks is even more
nonsensical.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 arch/x86/kvm/cpuid.h | 1 +
 arch/x86/kvm/x86.c   | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f2f2be5d1141..2b19ff991ceb 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -335,7 +335,7 @@ static bool kvm_cpuid_has_hyperv(struct kvm_cpuid_entry2 *entries, int nent)
 #endif
 }
 
-static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
+void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	struct kvm_cpuid_entry2 *best;
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 23dbb9eb277c..0a8b561b5434 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -11,6 +11,7 @@
 extern u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
 void kvm_set_cpu_caps(void);
 
+void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu);
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
 void kvm_update_pv_runtime(struct kvm_vcpu *vcpu);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d750546ec934..7adcf56bd45d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12234,6 +12234,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	kvm_xen_init_vcpu(vcpu);
 	kvm_vcpu_mtrr_init(vcpu);
 	vcpu_load(vcpu);
+	kvm_vcpu_after_set_cpuid(vcpu);
 	kvm_set_tsc_khz(vcpu, vcpu->kvm->arch.default_tsc_khz);
 	kvm_vcpu_reset(vcpu, false);
 	kvm_init_mmu(vcpu);
-- 
2.45.0.215.g3402c0e53f-goog


