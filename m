Return-Path: <kvm+bounces-17655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EC898C8B4E
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:40:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 91F58B22EDC
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:40:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50C0913F45B;
	Fri, 17 May 2024 17:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b8vFcjUm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7AB13E405
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967592; cv=none; b=iMPHWtI+xXSsyOMnqckUIcArpIDGW+QiKEh9GxbL3818YDxF9h2jDMLTWPxvJ4RyrTB2eltR93xqTseIet7v9Gw7CBfCq9HhmQ4BYa2WCA4Vaei3Jt57PAbdllTKgVyJeWej3SjbQcI0pmDdJR7XfgWRQPZy/S6EiMTbWU4qJ00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967592; c=relaxed/simple;
	bh=yJ7yoQ46+ikgBB4YUSYaYBLYdJQqlTgwjLY29ql4oU4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m7L/6sribwZG1mpV/EfDGcsrBSEdwSDw8XhOfIj4xBtc1pUS111s3X36RIY+wLAzL2cTRXAudxfUjdVvJL7wYcMHs9Y7Oz1galp9UlW/TtmT12x3aZyAC4QhsJoim6h5aEzEgQO8sQeF+XPpy6YqIbcB1UiyJhaibBRJ3dS/shw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b8vFcjUm; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6f44ff14c17so5108245b3a.3
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967590; x=1716572390; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cfmfXHZBd0ZTsF1DMwqCXJ74F8JrVm657Z2BUBSAqP8=;
        b=b8vFcjUmuuviYqXuo8R1hKgaO7lwcI/Gt/oDYXpwwooe/ENaZiOmiReu49GAvO/0P/
         QoTZgaOH7UUIyhUHCdru9YloSrS5fIRzM91NVQgI8kITJJj90shsS5yQuUm2S+0cxgHw
         0N332S033yHRMYjDm9KmalNbYKR7aJl0mme2A16z+8vb/esu/ImOemMD5ahkSMJopGzY
         GRx6Yff9I8rr0sQP8XPhHkHr21LzT9axbgvsgtvE9KqVrw+mjhs7vEQdn0hAf6w1Q9v+
         bo3AxtX+wfm5bERbg4RpbVrvyBBP0TocKyBu3RD5BA/v0H0XDY8aQ8Sbi1vgMAcIwanU
         jGCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967590; x=1716572390;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cfmfXHZBd0ZTsF1DMwqCXJ74F8JrVm657Z2BUBSAqP8=;
        b=qm9diWAZKcevUxC/Sv3zlPM6BunQW4NTCYFjhXJuVUfVTYxB9Vx3drxFRPJZvMp+bg
         aQTFgvXXjqg4xBQVkXFQfHa6N43glnzPORAQ2no45NHCp6JYYJzLyQ8eDGEu9bV9jrUX
         Pm9DDML5fin41NPwLtw0IwZV57cW3AiGpAvhFhdTfBt6d59XJ/E8ZYeQbTq/CLbG5Fh+
         Rwm+/ZcDbLSWm1BGUTQW+kreHmqWXLubsiRVg4i8K3uOLYvCHX3hNT/ZsAFFbteAlJa6
         mCGYQmrG0VTpkTZ4PlJVwOuc/PX2HzWsB5l6eIknq40WzYdmwxKawcln/HoYR3penZal
         jbPg==
X-Gm-Message-State: AOJu0YzUsoZ3HKVW82kQk27ZSBeZp6hGFoIEIwaxRR8c+qSNTAl5E0W3
	YOjwuzmaAitvAFGsCnP+EP2C+eKgDkUXiDtN2MYZXlgvZvm7BIU7KUZrHeC/OgrNDavK0vjmRIb
	jaQ==
X-Google-Smtp-Source: AGHT+IHdUhDuHlxg7kGHAWQh42RkIE8DOIuZh/v/XW9DfznBUffcQfMmifYR6F2zQ6Ywl/c3GzSh5FGpTP4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:23c8:b0:6ea:bc68:7354 with SMTP id
 d2e1a72fcca58-6f4e026a5c9mr235519b3a.1.1715967590161; Fri, 17 May 2024
 10:39:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:38:40 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-4-seanjc@google.com>
Subject: [PATCH v2 03/49] KVM: x86: Account for KVM-reserved CR4 bits when
 passing through CR4 on VMX
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Drop x86.c's local pre-computed cr4_reserved bits and instead fold KVM's
reserved bits into the guest's reserved bits.  This fixes a bug where VMX's
set_cr4_guest_host_mask() fails to account for KVM-reserved bits when
deciding which bits can be passed through to the guest.  In most cases,
letting the guest directly write reserved CR4 bits is ok, i.e. attempting
to set the bit(s) will still #GP, but not if a feature is available in
hardware but explicitly disabled by the host, e.g. if FSGSBASE support is
disabled via "nofsgsbase".

Note, the extra overhead of computing host reserved bits every time
userspace sets guest CPUID is negligible.  The feature bits that are
queried are packed nicely into a handful of words, and so checking and
setting each reserved bit costs in the neighborhood of ~5 cycles, i.e. the
total cost will be in the noise even if the number of checked CR4 bits
doubles over the next few years.  In other words, x86 will run out of CR4
bits long before the overhead becomes problematic.

Note #2, __cr4_reserved_bits() starts from CR4_RESERVED_BITS, which is
why the existing __kvm_cpu_cap_has() processing doesn't explicitly OR in
CR4_RESERVED_BITS (and why the new code doesn't do so either).

Fixes: 2ed41aa631fc ("KVM: VMX: Intercept guest reserved CR4 bits to inject #GP fault")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 7 +++++--
 arch/x86/kvm/x86.c   | 9 ---------
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e60ffb421e4b..f756a91a3f2f 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -383,8 +383,11 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
 
 	kvm_pmu_refresh(vcpu);
-	vcpu->arch.cr4_guest_rsvd_bits =
-	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
+
+#define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
+	vcpu->arch.cr4_guest_rsvd_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_) |
+					 __cr4_reserved_bits(guest_cpuid_has, vcpu);
+#undef __kvm_cpu_cap_has
 
 	kvm_hv_set_cpuid(vcpu, kvm_cpuid_has_hyperv(vcpu->arch.cpuid_entries,
 						    vcpu->arch.cpuid_nent));
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7adcf56bd45d..3f20de4368a6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -116,8 +116,6 @@ u64 __read_mostly efer_reserved_bits = ~((u64)(EFER_SCE | EFER_LME | EFER_LMA));
 static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
 #endif
 
-static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
-
 #define KVM_EXIT_HYPERCALL_VALID_MASK (1 << KVM_HC_MAP_GPA_RANGE)
 
 #define KVM_CAP_PMU_VALID_MASK KVM_PMU_CAP_DISABLE
@@ -1134,9 +1132,6 @@ EXPORT_SYMBOL_GPL(kvm_emulate_xsetbv);
 
 bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
-	if (cr4 & cr4_reserved_bits)
-		return false;
-
 	if (cr4 & vcpu->arch.cr4_guest_rsvd_bits)
 		return false;
 
@@ -9831,10 +9826,6 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		kvm_caps.supported_xss = 0;
 
-#define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
-	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
-#undef __kvm_cpu_cap_has
-
 	if (kvm_caps.has_tsc_control) {
 		/*
 		 * Make sure the user can only configure tsc_khz values that
-- 
2.45.0.215.g3402c0e53f-goog


