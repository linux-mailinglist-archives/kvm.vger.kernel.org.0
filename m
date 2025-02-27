Return-Path: <kvm+bounces-39460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 76BE6A47163
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:41:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77DE318832B2
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:34:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C591215667D;
	Thu, 27 Feb 2025 01:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YlIK2f0e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47599145B0B
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619547; cv=none; b=S3Xo/Yu3d3MsQ5PWrGWz7oShD3Q/Kw3Dv97jR/oUAvzDAxe2UYi4dUGHI5RbWQKB6VHpBRhq93E5eqFIdA9AhHdDLYIfnY1ADrUjyanBWnEgwOgibGq6l7i8xiSMQEfxEvU7hc6RZOQ7ZPikj85Jc+5o9Lwa9F8weHtrUzowrVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619547; c=relaxed/simple;
	bh=kEAizSXrh46aeFhOp+VD1iskoyu83eS9VfMafXdoPyw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pc/Bdz+UV9R24NB9J7s/3sIa8KslXtaC6/5jivFmRz/gJfG5G21qqiMRdcXnZ1XarwRwUbKIyZA2KGZtkiKqbzQQQUZ3+TmUZMcDvPRv9rSWiS3c2choSz4qf9kdrSeurdunM1AuVGzWzwTEUjOEWaH7xT4Ua++DiRFSg745JVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YlIK2f0e; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fbff6426f5so924408a91.3
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740619545; x=1741224345; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WBxe6FmXCGOPrPFuVLhffc7/ElAQfUF91a/RZlH0SFI=;
        b=YlIK2f0ep01e3unET3wZ9cspamj371E0ovB/7pMWFyYyzcsx2b0dvYfYJg2J2/qVz4
         rcWLly3sQsO7/7Tm4yzQ+cDOmHrq1DwYFBpm75y03thRTCWzQiKDsKuIDjF4yuUkKql8
         A4jonxLdsvuTzuS+LUOzrJHhlaiKyG42XgwBzxjhSyuEj93lcv2lL2CketCFh3ET+4Ec
         u1ABhrE8qXWbFY2CJr3ju0HqyIOpREVCo0O56Cjua4kz4G9HA1BUckagflQfJxnn1Tl/
         2tf6z+1rRW3NxqBhyjf8EK94T08RlEpoxH2apQLWn9pb9qE9mrGWnk4Zw+6DMaCaMme0
         tFcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740619545; x=1741224345;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WBxe6FmXCGOPrPFuVLhffc7/ElAQfUF91a/RZlH0SFI=;
        b=kM+ipXDp9RrarK+ZnogHVrxLuUxiyR+wi3WAGMOXWAidGjPAkP//IdFcsirXsRBktQ
         mbEKTa5lVnwDG4rNf/i+VIayxKtpvYChMY2bfgMV2z+qoj/l07Wd9kmxqGZC5HulyjFJ
         0wFwxmCMUxsJYvhXlDvbU5kwpx/u4DC0JdwuHHmWr/Vdl9SvBKoo8c28/B+UfkE2Oen4
         GgdKBkJOHJZ+vF/g1kq0p/jG3ddIBTNB6ygllMBaPbKBhr17kmG3vci2X68z4abDKQJI
         goNfTcwKCeBZgHxkOTOR8zMsE6sZdCCPJGsMfzy4Joe0sHB69l4Q/+5KkatKPYcYKhEL
         G3+Q==
X-Gm-Message-State: AOJu0YxPdcs/enkLjCdeQroBAMUCBHr2YnZtkBz5i89FBGZH5J1GnU5T
	VP3+TZvyyY6hMLGR71TQ/etTBu/ZHVgs8lN+r6XgZRzaa/w34SzKeXHWzboTnoqaSBBfCfnNHc+
	DOg==
X-Google-Smtp-Source: AGHT+IFLLB2ah5LUDPH7+jBTjfbaA9q03uHcgdVTCPpDNBjOdpdUzsxjWAd40Su+shcjHt/50lC87iRJyZ0=
X-Received: from pjb3.prod.google.com ([2002:a17:90b:2f03:b0:2fa:a101:743])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ecf:b0:2ee:f19b:86e5
 with SMTP id 98e67ed59e1d1-2fe68ada443mr17254991a91.14.1740619545636; Wed, 26
 Feb 2025 17:25:45 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 17:25:32 -0800
In-Reply-To: <20250227012541.3234589-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227012541.3234589-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227012541.3234589-2-seanjc@google.com>
Subject: [PATCH v2 01/10] KVM: SVM: Save host DR masks on CPUs with DebugSwap
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Alexey Kardashevskiy <aik@amd.com>, 
	Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="UTF-8"

When running SEV-SNP guests on a CPU that supports DebugSwap, always save
the host's DR0..DR3 mask MSR values irrespective of whether or not
DebugSwap is enabled, to ensure the host values aren't clobbered by the
CPU.  And for now, also save DR0..DR3, even though doing so isn't
necessary (see below).

SVM_VMGEXIT_AP_CREATE is deeply flawed in that it allows the *guest* to
create a VMSA with guest-controlled SEV_FEATURES.  A well behaved guest
can inform the hypervisor, i.e. KVM, of its "requested" features, but on
CPUs without ALLOWED_SEV_FEATURES support, nothing prevents the guest from
lying about which SEV features are being enabled (or not!).

If a misbehaving guest enables DebugSwap in a secondary vCPU's VMSA, the
CPU will load the DR0..DR3 mask MSRs on #VMEXIT, i.e. will clobber the
MSRs with '0' if KVM doesn't save its desired value.

Note, DR0..DR3 themselves are "ok", as DR7 is reset on #VMEXIT, and KVM
restores all DRs in common x86 code as needed via hw_breakpoint_restore().
I.e. there is no risk of host DR0..DR3 being clobbered (when it matters).
However, there is a flaw in the opposite direction; because the guest can
lie about enabling DebugSwap, i.e. can *disable* DebugSwap without KVM's
knowledge, KVM must not rely on the CPU to restore DRs.  Defer fixing
that wart, as it's more of a documentation issue than a bug in the code.

Note, KVM added support for DebugSwap on commit d1f85fbe836e ("KVM: SEV:
Enable data breakpoints in SEV-ES"), but that is not an appropriate Fixes,
as the underlying flaw exists in hardware, not in KVM.  I.e. all kernels
that support SEV-SNP need to be patched, not just kernels with KVM's full
support for DebugSwap (ignoring that DebugSwap support landed first).

Opportunistically fix an incorrect statement in the comment; on CPUs
without DebugSwap, the CPU does NOT save or load debug registers, i.e.

Fixes: e366f92ea99e ("KVM: SEV: Support SEV-SNP AP Creation NAE event")
Cc: stable@vger.kernel.org
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Kim Phillips <kim.phillips@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Alexey Kardashevskiy <aik@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 74525651770a..5c3d8618b722 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4568,6 +4568,8 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
 
 void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa)
 {
+	struct kvm *kvm = svm->vcpu.kvm;
+
 	/*
 	 * All host state for SEV-ES guests is categorized into three swap types
 	 * based on how it is handled by hardware during a world switch:
@@ -4591,10 +4593,15 @@ void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_are
 
 	/*
 	 * If DebugSwap is enabled, debug registers are loaded but NOT saved by
-	 * the CPU (Type-B). If DebugSwap is disabled/unsupported, the CPU both
-	 * saves and loads debug registers (Type-A).
+	 * the CPU (Type-B). If DebugSwap is disabled/unsupported, the CPU does
+	 * not save or load debug registers.  Sadly, on CPUs without
+	 * ALLOWED_SEV_FEATURES, KVM can't prevent SNP guests from enabling
+	 * DebugSwap on secondary vCPUs without KVM's knowledge via "AP Create".
+	 * Save all registers if DebugSwap is supported to prevent host state
+	 * from being clobbered by a misbehaving guest.
 	 */
-	if (sev_vcpu_has_debug_swap(svm)) {
+	if (sev_vcpu_has_debug_swap(svm) ||
+	    (sev_snp_guest(kvm) && cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP))) {
 		hostsa->dr0 = native_get_debugreg(0);
 		hostsa->dr1 = native_get_debugreg(1);
 		hostsa->dr2 = native_get_debugreg(2);
-- 
2.48.1.711.g2feabab25a-goog


