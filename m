Return-Path: <kvm+bounces-28297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EE1059973C1
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:50:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA4BE287910
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 17:50:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 553081E1328;
	Wed,  9 Oct 2024 17:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N5HEqYxZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D809E1DFDB0
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 17:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728496210; cv=none; b=UfECz7fMQ79lpE4SFy2mXd4malXC8xv3GPYctJrqLTN0IitsNhKqsliolzOjix3SanVHVrEC+VNJ3P3b1rHfsaLBds/1a5btfs1EusZiY+dcJa4KvRnjPOxsTxkXFyUJ46RxBafn/HGUPmYdo6oIQiCHUesXxWrkNEpJahVxmxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728496210; c=relaxed/simple;
	bh=85MiJbPlCBRn8NQoDRwLJneffyaGCs2FYkZSdoqVaQA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nXii5cZ6E2ZpJqrCVG6dGXBKJZHzRChxznD284nL4/0R0TbxixfL8zbg2SGU9u2tkt0txR9fgqwTdj74tgPq/A//xgeac5xqwwWl4XP/clpC7hoGw4vw+VL7uTwjVMsdWxAUJhFJAh8JxDTU3J9tY0rvQ53q9cFVWfMDNVzZSMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N5HEqYxZ; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e165fc5d94fso10938876276.2
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 10:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728496207; x=1729101007; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=h1Tp88JPCtGmNT2zJzXG5vNGkuLUQ/egYckqu51pEoA=;
        b=N5HEqYxZj7o+TMT6o7IV6U7driZqs089vpxrEhnW9INh7hvo0r/TRkA2YjKpLhKt7h
         6euGU2N9dcMmxHcLzYUVbA/sUlFk5KjrhZOs2EoUZAkJpug364sGUEpl7rDSppxyPz1D
         5k2ZgPZTD8sVNlGOAm1UVt+TEJXNSchomT94NWVzQpQMetG387b4LPtW/72Zpg2wpmgP
         +vZsyt2zHissmzqQIKBIGL4sE8fMgxMfaIUO6lbZVBGJg4+hJedb7K1/DtHjKoMmUPwY
         JDo+h6e6PMZIOtFyncEOgqYmWsTMF9gpPUBgRCsQVs72D94Jo6mkfNDdE6mNzz88umOL
         SH/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728496207; x=1729101007;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h1Tp88JPCtGmNT2zJzXG5vNGkuLUQ/egYckqu51pEoA=;
        b=bWanLM2/9sBC0brzdjlvVE9ktPQMor9sOeCBdJngKp6e9H6vIM1R/4zN31ps8EE6X5
         hmdtn4SeFpHFMSjfhsJJzXVvBevIcdD2Cy/Ysety64QJKQHdtYT42qczQF2Bu/iO8FD+
         lVoscK+JBikMfJy3WOUVdUdlAtm5ZwF8Mzpg/OK9bhMrbthGqFUT4WffmnuWnLdvAX4x
         MZjpj+ji1JMlJp8GYoT19urNwRLBNyEho0EfkMG3ZBSCx+5nJmO72GQ9HzE49MrO7ftQ
         a0m4q2qtnEi7S7nD9E/WD0CYM5dq3bCxT5Z7kHSr1UEWric6o+602VgjR67Mfm+RFij7
         nI8w==
X-Gm-Message-State: AOJu0YwJyst9POH5XzfJmAQBMllraKQtjyKjN1o1MBMiqNWB/0glWZNi
	mMjoW+1Bt/L78s+A7fVfpaC/+k6PPv7pvzhUV2diJl+4GI9ElMhe7zmI+wyH6gHHwzfxYJewaF9
	+cA==
X-Google-Smtp-Source: AGHT+IH7ulc/vjxbXlOiyHtWgK/BgxYqcqGjypCpU7Kt/4W3UcUFzu3+iDcaxEbKWDJ7lNvWET3UroG6PwA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a5b:94c:0:b0:e28:ef8f:7424 with SMTP id
 3f1490d57ef6-e28fe44d418mr29001276.11.1728496206718; Wed, 09 Oct 2024
 10:50:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 10:49:59 -0700
In-Reply-To: <20241009175002.1118178-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009175002.1118178-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241009175002.1118178-2-seanjc@google.com>
Subject: [PATCH v4 1/4] KVM: x86: Bypass register cache when querying CPL from kvm_sched_out()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

When querying guest CPL to determine if a vCPU was preempted while in
kernel mode, bypass the register cache, i.e. always read SS.AR_BYTES from
the VMCS on Intel CPUs.  If the kernel is running with full preemption
enabled, using the register cache in the preemption path can result in
stale and/or uninitialized data being cached in the segment cache.

In particular the following scenario is currently possible:

 - vCPU is just created, and the vCPU thread is preempted before
   SS.AR_BYTES is written in vmx_vcpu_reset().

 - When scheduling out the vCPU task, kvm_arch_vcpu_in_kernel() =>
   vmx_get_cpl() reads and caches '0' for SS.AR_BYTES.

 - vmx_vcpu_reset() => seg_setup() configures SS.AR_BYTES, but doesn't
   invoke vmx_segment_cache_clear() to invalidate the cache.

As a result, KVM retains a stale value in the cache, which can be read,
e.g. via KVM_GET_SREGS.  Usually this is not a problem because the VMX
segment cache is reset on each VM-Exit, but if the userspace VMM (e.g KVM
selftests) reads and writes system registers just after the vCPU was
created, _without_ modifying SS.AR_BYTES, userspace will write back the
stale '0' value and ultimately will trigger a VM-Entry failure due to
incorrect SS segment type.

Note, the VM-Enter failure can also be avoided by moving the call to
vmx_segment_cache_clear() until after the vmx_vcpu_reset() initializes all
segments.  However, while that change is correct and desirable (and will
come along shortly), it does not address the underlying problem that
accessing KVM's register caches from !task context is generally unsafe.

In addition to fixing the immediate bug, bypassing the cache for this
particular case will allow hardening KVM register caching log to assert
that the caches are accessed only when KVM _knows_ it is safe to do so.

Fixes: de63ad4cf497 ("KVM: X86: implement the logic for spinlock optimization")
Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
Closes: https://lore.kernel.org/all/20240716022014.240960-3-mlevitsk@redhat.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/svm/svm.c             |  1 +
 arch/x86/kvm/vmx/main.c            |  1 +
 arch/x86/kvm/vmx/vmx.c             | 23 ++++++++++++++++++-----
 arch/x86/kvm/vmx/vmx.h             |  1 +
 arch/x86/kvm/x86.c                 |  8 +++++++-
 7 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 861d080ed4c6..5aff7222e40f 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -34,6 +34,7 @@ KVM_X86_OP(set_msr)
 KVM_X86_OP(get_segment_base)
 KVM_X86_OP(get_segment)
 KVM_X86_OP(get_cpl)
+KVM_X86_OP(get_cpl_no_cache)
 KVM_X86_OP(set_segment)
 KVM_X86_OP(get_cs_db_l_bits)
 KVM_X86_OP(is_valid_cr0)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6d9f763a7bb9..3ae90df0a177 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1656,6 +1656,7 @@ struct kvm_x86_ops {
 	void (*get_segment)(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg);
 	int (*get_cpl)(struct kvm_vcpu *vcpu);
+	int (*get_cpl_no_cache)(struct kvm_vcpu *vcpu);
 	void (*set_segment)(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg);
 	void (*get_cs_db_l_bits)(struct kvm_vcpu *vcpu, int *db, int *l);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9df3e1e5ae81..50f6b0e03d04 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5031,6 +5031,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.get_segment = svm_get_segment,
 	.set_segment = svm_set_segment,
 	.get_cpl = svm_get_cpl,
+	.get_cpl_no_cache = svm_get_cpl,
 	.get_cs_db_l_bits = svm_get_cs_db_l_bits,
 	.is_valid_cr0 = svm_is_valid_cr0,
 	.set_cr0 = svm_set_cr0,
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 7668e2fb8043..92d35cc6cd15 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -50,6 +50,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.get_segment = vmx_get_segment,
 	.set_segment = vmx_set_segment,
 	.get_cpl = vmx_get_cpl,
+	.get_cpl_no_cache = vmx_get_cpl_no_cache,
 	.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
 	.is_valid_cr0 = vmx_is_valid_cr0,
 	.set_cr0 = vmx_set_cr0,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1a4438358c5e..12dd7009efbe 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3568,16 +3568,29 @@ u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg)
 	return vmx_read_guest_seg_base(to_vmx(vcpu), seg);
 }
 
-int vmx_get_cpl(struct kvm_vcpu *vcpu)
+static int __vmx_get_cpl(struct kvm_vcpu *vcpu, bool no_cache)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	int ar;
 
 	if (unlikely(vmx->rmode.vm86_active))
 		return 0;
-	else {
-		int ar = vmx_read_guest_seg_ar(vmx, VCPU_SREG_SS);
-		return VMX_AR_DPL(ar);
-	}
+
+	if (no_cache)
+		ar = vmcs_read32(GUEST_SS_AR_BYTES);
+	else
+		ar = vmx_read_guest_seg_ar(vmx, VCPU_SREG_SS);
+	return VMX_AR_DPL(ar);
+}
+
+int vmx_get_cpl(struct kvm_vcpu *vcpu)
+{
+	return __vmx_get_cpl(vcpu, false);
+}
+
+int vmx_get_cpl_no_cache(struct kvm_vcpu *vcpu)
+{
+	return __vmx_get_cpl(vcpu, true);
 }
 
 static u32 vmx_segment_access_rights(struct kvm_segment *var)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 2325f773a20b..bcf40c7f3a38 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -385,6 +385,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
 			unsigned long fs_base, unsigned long gs_base);
 int vmx_get_cpl(struct kvm_vcpu *vcpu);
+int vmx_get_cpl_no_cache(struct kvm_vcpu *vcpu);
 bool vmx_emulation_required(struct kvm_vcpu *vcpu);
 unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu);
 void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 83fe0a78146f..830073294640 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5094,7 +5094,13 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	int idx;
 
 	if (vcpu->preempted) {
-		vcpu->arch.preempted_in_kernel = kvm_arch_vcpu_in_kernel(vcpu);
+		/*
+		 * Assume protected guests are in-kernel.  Inefficient yielding
+		 * due to false positives is preferable to never yielding due
+		 * to false negatives.
+		 */
+		vcpu->arch.preempted_in_kernel = vcpu->arch.guest_state_protected ||
+						 !kvm_x86_call(get_cpl_no_cache)(vcpu);
 
 		/*
 		 * Take the srcu lock as memslots will be accessed to check the gfn
-- 
2.47.0.rc1.288.g06298d1525-goog


