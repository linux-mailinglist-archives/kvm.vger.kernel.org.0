Return-Path: <kvm+bounces-33468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC8499EC18C
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 02:34:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E223169A06
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 01:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6166E1ABEA1;
	Wed, 11 Dec 2024 01:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DDNCbXqQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D52319995B
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 01:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733880793; cv=none; b=nKIM9DQGDSjedBtVgqlI85bizR6UXGz9ZPhSnZ9u1kB7jzgBDZ5Khnwr/THoj9h87zUJQo6Cr/pdm48NB0GE7TN82JIuyyKWJSTsoSoHbnf5DX97OIpvF4+TepW/0cBa30zqTVcgOTfyxTd8v2wFzAUsmAOn+k++dOskD+v8nCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733880793; c=relaxed/simple;
	bh=pVN9X3/LQlagv85CHblFqLUrbHNMnt6biCo4ArBf60M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I1lJQ82jH8FiyGbE5E2Dli0YyoeM7udRDpyXYToJaxdctWM7m/H0uFVI3ocvd51PhBIgAz6T5/kKwdaNSluwJY9+oQNY5CXtRkGfO1191CwC5XB6Pfs1PrRrgkopXoSi7sCNBS0GetwppDXgLXjpK8zMsHCESw+vOl/vFWRhtZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DDNCbXqQ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2efc3292021so3501192a91.1
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 17:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733880791; x=1734485591; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=E9jKmjJGCtx++sJ0UBKZjnf35PeNXL0CwNPg/tsJ8RY=;
        b=DDNCbXqQRUjcixf2h6TjNxLqc8gx9s+2bEX/zK6vvOYIe+GO13tc/HJl+VEEnXwr17
         jmk5w/eyE6hHKVwHGXrsXiatgulUOg/Sp7EN0Ee5LBNc0qDTMQCVw+YwZ+kBtscdoJhW
         CALsUaCIl9iMauG2Vsozthb0+fbo3gI9ifpX5UthAlSReFyPN7/AHi031xTuo0rIehyS
         Loq8wiISmiWv6dtoLMerPtnzIhMFdBjzgguXbj3wo61fMcXhM/97vABQLOnzxMZdPxy3
         AYZxEkndz3fm4biCfDmk83LH+KpGXWlm/ibyLLdzok4Eq62PHhUmdOEtKE2ztFBsix16
         n3hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733880791; x=1734485591;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E9jKmjJGCtx++sJ0UBKZjnf35PeNXL0CwNPg/tsJ8RY=;
        b=abpnTqfiV+ozgE4lWy3FMSPN8KW+dB7EV0rUetg35IAn6FMqHhJrk8Q5Wq/yQ+nxF0
         euZjyouyYNNkhzL3B113qvx0Mjjl4EMoR/Rm4J3VqsNQBddXeRalOUWPXdtCtt/V+Hrb
         FS5V6wd9xIDe/e9tY2NlqqrPvmsnlxFTmxPI7jju5BcKmBtIuSMKz3c1BGHT2rcayXzx
         jni+pnmefOyoNMbbg6dXOwnOYiebXV7WjQZey8O3kqKhAFHTQDOktCOkPlVz2Ef0mjp3
         2TCchJ7BO+m6pIXydyx6EowVgzqfQsRkWCszhoGOIE+pEpH2jasJk/iKVfCImoqQF2c6
         +U2w==
X-Gm-Message-State: AOJu0YzCvuaSlti+ObYlAk2T+zTmRAimGsa/oe2PQz8ZhT07LNK2GYSC
	IWehlmdq+8njrtBJ4fIa5LPbxN1RHkh8/SxFkQBdCp/zwg4qeQ1Zp/2vwBmr2WlWoch3VoGmoAW
	DRw==
X-Google-Smtp-Source: AGHT+IG09HOqKskQ/NpzxWW95bfRUV0AChGHA0pVhWpnKemNkwgkww9Mg4Vap1JIsW27rzv5Znl+GPfsFg0=
X-Received: from pjbsw6.prod.google.com ([2002:a17:90b:2c86:b0:2ee:4b37:f869])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5111:b0:2ee:9d49:3ae6
 with SMTP id 98e67ed59e1d1-2f127fc46ffmr1820845a91.10.1733880791641; Tue, 10
 Dec 2024 17:33:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Dec 2024 17:33:01 -0800
In-Reply-To: <20241211013302.1347853-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241211013302.1347853-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241211013302.1347853-5-seanjc@google.com>
Subject: [PATCH 4/5] KVM: x86: Query X86_FEATURE_MWAIT iff userspace owns the
 CPUID feature bit
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Rework MONITOR/MWAIT emulation to query X86_FEATURE_MWAIT if and only if
the MISC_ENABLE_NO_MWAIT quirk is enabled, in which case MWAIT is not a
dynamic, KVM-controlled CPUID feature.  KVM's funky ABI for that quirk is
to emulate MONITOR/MWAIT as nops if userspace sets MWAIT in guest CPUID.

For the case where KVM owns the MWAIT feature bit, check MISC_ENABLES
itself, i.e. check the actual control, not its reflection in guest CPUID.

Avoiding consumption of dynamic CPUID features will allow KVM to defer
runtime CPUID updates until kvm_emulate_cpuid(), i.e. until the updates
become visible to the guest.  Alternatively, KVM could play other games
with runtime CPUID updates, e.g. by precisely specifying which feature
bits to update, but doing so adds non-trivial complexity and doesn't solve
the underlying issue of unnecessary updates causing meaningful overhead
for nested virtualization roundtrips.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 320764e5f798..dc8829712edd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2080,10 +2080,20 @@ EXPORT_SYMBOL_GPL(kvm_handle_invalid_op);
 
 static int kvm_emulate_monitor_mwait(struct kvm_vcpu *vcpu, const char *insn)
 {
-	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS) &&
-	    !guest_cpu_cap_has(vcpu, X86_FEATURE_MWAIT))
+	bool enabled;
+
+	if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS))
+		goto emulate_as_nop;
+
+	if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT))
+		enabled = guest_cpu_cap_has(vcpu, X86_FEATURE_MWAIT);
+	else
+		enabled = vcpu->arch.ia32_misc_enable_msr & MSR_IA32_MISC_ENABLE_MWAIT;
+
+	if (!enabled)
 		return kvm_handle_invalid_op(vcpu);
 
+emulate_as_nop:
 	pr_warn_once("%s instruction emulated as NOP!\n", insn);
 	return kvm_emulate_as_nop(vcpu);
 }
-- 
2.47.0.338.g60cca15819-goog


