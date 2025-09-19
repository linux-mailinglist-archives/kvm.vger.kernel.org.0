Return-Path: <kvm+bounces-58253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CBAF6B8B829
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:40:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDC203B01C9
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:40:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B3782FBDF3;
	Fri, 19 Sep 2025 22:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qf6XfOFd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6972F83A7
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321232; cv=none; b=JyFJLlduKZeVciOHT3EHeS87lgWXZDwVU+4eld4QNAq9pojPUBkQBFJeDzqQkWjpe40Prb7FeSyCDx7w2Jx2MRp+FQx6YRWCQu8dsV4FUGZLnzgVCEJXKJF672/okZmtBBpSHqdNpZvCEGExdEOSZunQcdXdVdhhCCr8k3momV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321232; c=relaxed/simple;
	bh=wv7lXNgVXI4fQTSq3s9gMycF70a9TxUw41cJRljoKaw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IRMLwvBg3OY/0L5sujWhtH7PWNQxA6N346pSVxtKTsFyj4swsTOr7FFxdlABPJG/ml0l8oPGtxR8tySIJqHcufp7ipyZmLGEfrSnrshCdXzlIPz76uJh5oJxoIjCxc3bAsDu5q2mHMN4kSiWX49yP9PJpKlOxArSCRtip68ar4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qf6XfOFd; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b4f8e079bc1so1801694a12.3
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321229; x=1758926029; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=w/iGcLBCIDmuuGH4TifEpczWER6MZ2hzrzutZDTwD2M=;
        b=qf6XfOFdvKE4Eh41F71fXqatOU8VOjVv/1ycwd83DbGY97LsCUWCNSOuANGzBJPhBa
         GXufSlfjk7Rq0IGdRPJm9cDDyaOE92orl3QJdVimqgLvdUT+9MdE8+xefBMsp+z0dpRa
         M2755SNZRlzUTYSJsK+wPHPoYyfYuaCKqFgUhblEL16LJ/KIctXT8vLJA1dIOYuGwXU8
         5GUxgaVt1xn6J0C7zvqExr6ida+nIdVpYaYFd6ejwG2SK5EbEMHp7D8L7ZZ3z+VMm8Gh
         n6H/RIaVknlNFw0qNINwuBoeNL1uAQkx7dTGuOjbZTukPDDlN/HqdZSZfpjQ5IUrZRig
         qH7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321229; x=1758926029;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w/iGcLBCIDmuuGH4TifEpczWER6MZ2hzrzutZDTwD2M=;
        b=ZzMRTX8427SKfQQjAYvJ949kMll++TXo8KPOAgJR5WWjYpb/3Gdi7DmbgAYbbmAlom
         6lva+oYQM1rV36qaXW5dtzSzRERGhlCJMS6RoK3P93d1Lv7LvyMRiTIqFo5g70Mgxmxe
         Yb1sKjTQdDYXygPvouxxtYTwZaBtTtfTVCt6xtMB/lby6Srd8PCsb+PPcY/kghCjTWOn
         yKBc80Zn81ti0RJAGEed/jjpwljjK+PIal6neAuYyYekMDEo+HGqi3yEuDQwJyDPdJqO
         clK/6Fm4GjJk0RW7APSi2TfbM+tbk3P109RqTHQxTsFNRCzYGsGQ58B7JBcQB9Ixyi78
         ZaEw==
X-Gm-Message-State: AOJu0Yyko79bctsMmuvH4V1rqsRsLAGbYcefIhPMKkUaZbccAbn/NSMr
	rPHKgWyzCFtZjKzJ3DDCpFlO4X9gJxcFoi8Oha1GhaJqusMqy6x/q0uLgc9hvV8yLU+zjhaVaMw
	63A8xEw==
X-Google-Smtp-Source: AGHT+IFLpZ19sMUVPW7XTee4GCwUM+fUepgiPmhknZvL7FVi33FmwxD0JTaLQPmdhcW+I9E7s5Uh5DAQkxc=
X-Received: from pjbqx3.prod.google.com ([2002:a17:90b:3e43:b0:330:793a:2e77])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7347:b0:243:78a:82bd
 with SMTP id adf61e73a8af0-292764cd565mr7126926637.55.1758321229259; Fri, 19
 Sep 2025 15:33:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:32 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-26-seanjc@google.com>
Subject: [PATCH v16 25/51] KVM: x86: Add XSS support for CET_KERNEL and CET_USER
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

From: Yang Weijiang <weijiang.yang@intel.com>

Add CET_KERNEL and CET_USER to KVM's set of supported XSS bits when IBT
*or* SHSTK is supported.  Like CR4.CET, XFEATURE support for IBT and SHSTK
are bundle together under the CET umbrella, and thus prone to
virtualization holes if KVM or the guest supports only one of IBT or SHSTK,
but hardware supports both.  However, again like CR4.CET, such
virtualization holes are benign from the host's perspective so long as KVM
takes care to always honor the "or" logic.

Require CET_KERNEL and CET_USER to come as a pair, and refuse to support
IBT or SHSTK if one (or both) features is missing, as the (host) kernel
expects them to come as a pair, i.e. may get confused and corrupt state if
only one of CET_KERNEL or CET_USER is supported.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
[sean: split to separate patch, write changelog, add XFEATURE_MASK_CET_ALL]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 40596fc5142e..4a0ff0403bb2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -220,13 +220,14 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
 
+#define XFEATURE_MASK_CET_ALL	(XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)
 /*
  * Note, KVM supports exposing PT to the guest, but does not support context
  * switching PT via XSTATE (KVM's PT virtualization relies on perf; swapping
  * PT via guest XSTATE would clobber perf state), i.e. KVM doesn't support
  * IA32_XSS[bit 8] (guests can/must use RDMSR/WRMSR to save/restore PT MSRs).
  */
-#define KVM_SUPPORTED_XSS     0
+#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_ALL)
 
 bool __read_mostly allow_smaller_maxphyaddr = 0;
 EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
@@ -10104,6 +10105,16 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		kvm_caps.supported_xss = 0;
 
+	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
+	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
+		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
+
+	if ((kvm_caps.supported_xss & XFEATURE_MASK_CET_ALL) != XFEATURE_MASK_CET_ALL) {
+		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+		kvm_cpu_cap_clear(X86_FEATURE_IBT);
+		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
+	}
+
 	if (kvm_caps.has_tsc_control) {
 		/*
 		 * Make sure the user can only configure tsc_khz values that
@@ -12775,10 +12786,11 @@ static void kvm_xstate_reset(struct kvm_vcpu *vcpu, bool init_event)
 	/*
 	 * On INIT, only select XSTATE components are zeroed, most components
 	 * are unchanged.  Currently, the only components that are zeroed and
-	 * supported by KVM are MPX related.
+	 * supported by KVM are MPX and CET related.
 	 */
 	xfeatures_mask = (kvm_caps.supported_xcr0 | kvm_caps.supported_xss) &
-			 (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
+			 (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR |
+			  XFEATURE_MASK_CET_ALL);
 	if (!xfeatures_mask)
 		return;
 
-- 
2.51.0.470.ga7dc726c21-goog


