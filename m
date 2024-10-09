Return-Path: <kvm+bounces-28298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BCC159973C3
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:50:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC3EB1C24C47
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 17:50:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E53AB1E1A15;
	Wed,  9 Oct 2024 17:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N+OLYdhF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDC01E0DFC
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 17:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728496211; cv=none; b=r+pjb6/8vuXjykg1OeQ+wV/m+xtUjyoaU//0HNPCYwTt69p9a22ZxyMYCcL3gU29D0J5BAtwk+slAoztTPvfpFRx/sPygq5sP3GHurcpMbRDnXt+yw/jtjuFN28mm3hj5uoGNs4TpB6nFN2KAEy/iVODtZW/tIvTnhSspwf+dIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728496211; c=relaxed/simple;
	bh=XGN8QmzWeMv16qVKiSYSJZttp2ea5qDKnmkRDQ95LS0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lqSndvucfBHyTVx9CiRNTZOyOH/kPxhJcjfoqzuEkie+Smt2hWQVd2H1KkvxqFGTevjbDrYf+CIIMSjEjE6m8KBGUbxqTjJXcNvFTkPOdDxfAN/uMziNiCGEF1nyYqGqvEEridWIS8dKJZ4TCTjXJXwlwXX9+JvOSzYU9l4gGVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N+OLYdhF; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71df07ac9faso61726b3a.1
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 10:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728496209; x=1729101009; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+KKX3lXTCaUFVYVr2zKh6PXHZREG1pYDrjz48FgujYw=;
        b=N+OLYdhFhjRpVAneqIR7aaUH0cdtto9w74D2lARz0jNhD92MZ1YJsTBhyyzA0lCT1m
         1mKfCDaVNCi4C0ObUyw0cIEPNxAWk4BJHbZ7mLoNbs1a8+edDg+Fvva+6N9kd3GCAYZy
         Zd0ulDwrRn0D4P4VjL6gRkf2HBMsHWnRX3QOXAvNsLXCJEVfCMXI4kLDJ76vDUA9odlN
         f4svU1Vm3TD+LWGX5vdAibGjHqLS76AdQwTPfp751Q+iuKvQGu0KqvmK4TmLtUcm2jHF
         cr2vAgVZ8EpwKk8Y4kDCOksD8Zi9I1ldVyf1Z4U4csZEDQDGE2FiP70GHbgkmt8/MkCC
         zMxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728496209; x=1729101009;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+KKX3lXTCaUFVYVr2zKh6PXHZREG1pYDrjz48FgujYw=;
        b=q+VbsiOy6uo9WNnENEsa3ihAXOeUODiSTmxYETI3oTrw5FkE83XID0kadKym6peQEt
         Agoh2WVYbLyc/ZjzPy/C9SFgdo+4w3o5PXZXZPKDLlDpO6QRMMxQyjg5qEvy118EfnAM
         29Q7eEyZCXiIW+E3ufp0PQ38e+Wb+qr1+z7Rny1IDRt3HbEy1qJhGRPvyA36rJEXWrJb
         BjHTfe68U7Pfo1OBC7dYQV9DX9lTSynTqyztE+1RyK+d47f+WJ/Q/VR+21929sJ6+d3h
         tdPn8YCcw03qarCGWo6oYfITWNVz4gVY99s28oHRND9u1E0gBPbp+NpRDfJfyvPVP6KZ
         RPAg==
X-Gm-Message-State: AOJu0Yyb8eT98vlIO7nikESC1jOw1XUo3L3omU+pqncV8X+ksHWHp4x2
	AZjfldRAatbS7+i5Cs+V14JgWjqWTCpWjpqiQksL/9n6d2Gaj/hSqQR8p0S06nNssHDX9pYo/4z
	UVw==
X-Google-Smtp-Source: AGHT+IEVGupj+lzuaWgALZWozBmfxi8I2JGdBW0Fd7qPciWqwQBnx+E5KfqkSKSPrS5ywaRa+QgHUrupAV8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6f44:b0:71e:268b:845e with SMTP id
 d2e1a72fcca58-71e26e53c16mr1169b3a.1.1728496208598; Wed, 09 Oct 2024 10:50:08
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 10:50:00 -0700
In-Reply-To: <20241009175002.1118178-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009175002.1118178-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241009175002.1118178-3-seanjc@google.com>
Subject: [PATCH v4 2/4] KVM: VMX: reset the segment cache after segment init
 in vmx_vcpu_reset()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

From: Maxim Levitsky <mlevitsk@redhat.com>

Reset the segment cache after segment initialization in vmx_vcpu_reset()
to harden KVM against caching stale/uninitialized data.  Without the
recent fix to bypass the cache in kvm_arch_vcpu_put(), the following
scenario is possible:

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

Invalidating the cache after writing the VMCS doesn't address the general
issue of cache accesses from IRQ context being unsafe, but it does prevent
KVM from clobbering the VMCS, i.e. mitigates the harm done _if_ KVM has a
bug that results in an unsafe cache access.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Fixes: 2fb92db1ec08 ("KVM: VMX: Cache vmcs segment fields")
[sean: rework changelog to account for previous patch]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 12dd7009efbe..a11faab67b4a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4901,9 +4901,6 @@ void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmx->hv_deadline_tsc = -1;
 	kvm_set_cr8(vcpu, 0);
 
-	vmx_segment_cache_clear(vmx);
-	kvm_register_mark_available(vcpu, VCPU_EXREG_SEGMENTS);
-
 	seg_setup(VCPU_SREG_CS);
 	vmcs_write16(GUEST_CS_SELECTOR, 0xf000);
 	vmcs_writel(GUEST_CS_BASE, 0xffff0000ul);
@@ -4930,6 +4927,9 @@ void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmcs_writel(GUEST_IDTR_BASE, 0);
 	vmcs_write32(GUEST_IDTR_LIMIT, 0xffff);
 
+	vmx_segment_cache_clear(vmx);
+	kvm_register_mark_available(vcpu, VCPU_EXREG_SEGMENTS);
+
 	vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
 	vmcs_write32(GUEST_INTERRUPTIBILITY_INFO, 0);
 	vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS, 0);
-- 
2.47.0.rc1.288.g06298d1525-goog


