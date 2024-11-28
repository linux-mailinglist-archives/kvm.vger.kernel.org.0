Return-Path: <kvm+bounces-32656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DBE329DB0CC
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:36:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 45D83B226CA
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:35:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D521313D8B0;
	Thu, 28 Nov 2024 01:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B+1ZUj7n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732DF1369BB
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757683; cv=none; b=prfxyyxj4KFjcFFE+usZ+/bsSqBekMVOQdRZIWElxxpc24FkRiC0tjUSjxcUVvYwNp/KOAFE9eV551sLARk22br1s4CMh4hyoQ982kk3NMfJpdyluUd4HTcRgvnYS3WrMbmhpVZh72JZoGg1AOgDJAV7cTps8Q5P8rTiQGENq/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757683; c=relaxed/simple;
	bh=0JfgxpdrupIaRnl7kC2dOFPwCk6+xhe6f1i1SPh5VQc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LIoh94UOLT57hLoJMtJy6v5A7IphbP7MkJgXtIeRmQ5CGABlmLCyZBgZXPpHT8hmnWONApDICv1ZF/lM1TaoA/sibVYu4Klxs8XQRDKJpO561HjjSJkO5Va5iKIZT4Ank8uT1tQdU6CzsNl5glUYiXfV+zz17OSbsch2me4Ne2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B+1ZUj7n; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-724f7c09c58so393749b3a.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:34:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757681; x=1733362481; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jXmvhxEmqHLmptmFrlYapwE2GXQS0ioWcRCpjRVCiP4=;
        b=B+1ZUj7nxYcQPdPxX6cIe8EQZmv3QiuKpXyoF7gQ7jOPhRJpJQcFUAIjjeX0prayIJ
         LYPOanroS7dG26Wz/p7NKGz228o8PgyyrhRYOHvy/efs4oeqg5e1E6FcntQDmpzsOzFZ
         Quy/9m5jzpRO6drQ0TzB0/7IAWrMjLOydXfeFXFETlyEKpiUvwVR/6ZFZkRXrKTkkVdb
         4wRYXrTfMLRVZrwVbn1hpLCbY4JKyvrjhydHaeNDAVt7AYrnWv2djd4qtU02mIjmOLSZ
         iIh5zRYyGKopORv1OL7GYdirYgzEH1oz50wNBXWSg9MFdRNnqEeCxSve1g6Wz61QlBc1
         roGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757681; x=1733362481;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jXmvhxEmqHLmptmFrlYapwE2GXQS0ioWcRCpjRVCiP4=;
        b=FvlAvFYYrhnAvY7DCMFAjBk7fEND2HHZs9LoMB9hcAgWqUswt3GLtN1G1tW5xGLB5P
         vbheZBtLgE1GZPxl/ceR1OCYbbtT3eWawiaIIKSEKexUxc6OB1kcaFzdM/ejTp1eMxma
         GeSx6sXAgxaunG2y3W909OT1DvhyVhHFMjKIXsZ4WHEnsaJMQnZK2aquXboS75rECrgc
         n/dm1FvHnz38akL9yzoxOTxoUsx75wfLk83GJ0UzbX39PYKXjhAXJat6UOt16+T9Gm73
         SSwkbZfwJdpYBosiIoopJqtTFsLMTNoHJqNmBkPtbhTG/ZET6EFhGlPOdigfPLeulhfi
         ejaQ==
X-Gm-Message-State: AOJu0YwNDJ9kOpToKI5JZDiNxSYf7nmPMWMWL+THWv/cWh23yY2kBRPk
	ZQZa5WFHd6EsGqnaNIk+DKPfTrWipQbn9CM+GIFVdsduiw2KbVaK2ZztM5GEYoP70CYam0sX10l
	Ylg==
X-Google-Smtp-Source: AGHT+IFQhFinpFVGMQCaQ+dyl10TAppaguaY+VdZfxJxAIk1wFY127FX/WZeqzKczEacxeO44YgSxWQsq5s=
X-Received: from pgbcv2.prod.google.com ([2002:a05:6a02:4202:b0:7fb:dc15:be43])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:39a:b0:1e0:c3bf:7909
 with SMTP id adf61e73a8af0-1e0e0b8d0ecmr7963436637.41.1732757680762; Wed, 27
 Nov 2024 17:34:40 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:32 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-6-seanjc@google.com>
Subject: [PATCH v3 05/57] KVM: x86: Account for KVM-reserved CR4 bits when
 passing through CR4 on VMX
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
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 7 +++++--
 arch/x86/kvm/x86.c   | 9 ---------
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 1944f9415672..27919c8f438b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -400,8 +400,11 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
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
index ca9b0a00cbcc..5288d53fef5c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -119,8 +119,6 @@ u64 __read_mostly efer_reserved_bits = ~((u64)(EFER_SCE | EFER_LME | EFER_LMA));
 static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
 #endif
 
-static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
-
 #define KVM_EXIT_HYPERCALL_VALID_MASK (1 << KVM_HC_MAP_GPA_RANGE)
 
 #define KVM_CAP_PMU_VALID_MASK KVM_PMU_CAP_DISABLE
@@ -1285,9 +1283,6 @@ EXPORT_SYMBOL_GPL(kvm_emulate_xsetbv);
 
 bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
-	if (cr4 & cr4_reserved_bits)
-		return false;
-
 	if (cr4 & vcpu->arch.cr4_guest_rsvd_bits)
 		return false;
 
@@ -9773,10 +9768,6 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
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
2.47.0.338.g60cca15819-goog


