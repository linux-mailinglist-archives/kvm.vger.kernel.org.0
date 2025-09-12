Return-Path: <kvm+bounces-57463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 80845B55A23
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:29:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A88301D63537
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EAB12DA759;
	Fri, 12 Sep 2025 23:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="baJdx66k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCDC28726D
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719442; cv=none; b=obYImMNxNyeHW+pyf6d0D65G/UuuBkOP7nC9LBbZ8Kz+1u0QJR3g+iPtAopdxslJbm7l3ugQS193SNgOsFVGFMgUH4Jx14bcqr6aDa0KkeugzIUCSnOlzX2GiAXvSOSa2kllaWx/nMthSeeEl836qjnCPKYxj72cxLp99E6sucE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719442; c=relaxed/simple;
	bh=58vGBcmh8JU+yxaCgvebVlHWxJLTvD5JodeHEZVxsf0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H0vYa2+WevwYEvK6yIu0hz/5Bm1ytr8Vr+dB/yBnZvL7zszrayLcco1yMs1ErYo2ScBM5B7F/g+S9XRbir+9uk84TpNVztvzmEopdFy00Oh0Q/RR7yJhtIQABvcThLmDUbwm7UEx+gZYAyLzb1xLRx6uDhZ4zhpZG/fB6BeXPoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=baJdx66k; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7761dc1b36dso1363550b3a.1
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719440; x=1758324240; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2CBYwO5s/sEwZ0rYysRg2EQeeHLFNySc966ViHHu28Y=;
        b=baJdx66kkW/uCAK3OLgA+5qJz0hKRIGbsUH1Tet3c2dC26rOaCgHQpIrj/YTa/qy5h
         9tkl7WTfH5jiVNZO6hfQ/yugcv7hx/wLzejOwcwTpghqbV0tSheK0/KjYdLJD0YtcNz7
         RzlGywHCl+WvSZnB2pN/d7rOdpI5yrthLFfqQMt58hnushPoin+BrqXvscgEoDKP4J9I
         zTcj8yIn4yF6GEMThO5e2onTcuzgJFTA1vO6xz1ET+3zC8thQwGIyBuVSz01bAQ1oFXS
         HXlCMN986WKjXkS35+x5atj4lHpAFTDeJy5Zkxr6veqQqOibFga71w8eDRjlgEpBJ2mw
         Zg/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719440; x=1758324240;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2CBYwO5s/sEwZ0rYysRg2EQeeHLFNySc966ViHHu28Y=;
        b=DUGQfWayGKjwKfONWrq5qTZdU1jwfBPH0Xqt9Upvkz9OSI4Js8lBUyvFm7JjwyDo5J
         HUiqa0LC6pz9w/HDnx8ZT5jom3VOz/lyWdIxOeGpFNB58ClKlfQ+AM9uxFx9u0gnSTsP
         c6y7NSXOkHCDSYJypPamDdfTcq1yjk4h/y5qU+tnU75SrWRS3lTwYwqX7Cu2/RX8O6aF
         gwuE/2+Kk2wJmzw2RnIf1Z4EomdVc1sSV/L52CANnK+mUSoX1ppuFg5uNWnT8f3q7i0J
         mKFOpntBrXUadtFc9ZTM9KcEHsdG1635fgR1yJPDlnc6jd+Wttye4jDLRuYlxJJiN8ID
         nGzA==
X-Gm-Message-State: AOJu0YwcFHtV0GSKBHKW9Nm3mo/G2+D5S45NMrHDc0Uuv1LG/eq6LxD/
	dfGS8b9ZftvYRyZHMI6yGZhsbmSlApjogKUU/4wfceZ5VnolpU8VoSOTpihiEoaOvb5aOQTDByq
	ff//STA==
X-Google-Smtp-Source: AGHT+IHL7k4i2bjik2Fv/iBm2UAr3okgWwEa8q4cQMjTGLOBrHMjoeKLTBHZSsGGU0+pX4MwBSDOppvs8b0=
X-Received: from pjbqa14.prod.google.com ([2002:a17:90b:4fce:b0:321:c2a7:cbce])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:33a9:b0:253:2fae:5282
 with SMTP id adf61e73a8af0-2602bb593bbmr5648471637.28.1757719440164; Fri, 12
 Sep 2025 16:24:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:22:58 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-21-seanjc@google.com>
Subject: [PATCH v15 20/41] KVM: nVMX: Virtualize NO_HW_ERROR_CODE_CC for L1
 event injection to L2
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Yang Weijiang <weijiang.yang@intel.com>

Per SDM description(Vol.3D, Appendix A.1):
"If bit 56 is read as 1, software can use VM entry to deliver a hardware
exception with or without an error code, regardless of vector"

Modify has_error_code check before inject events to nested guest. Only
enforce the check when guest is in real mode, the exception is not hard
exception and the platform doesn't enumerate bit56 in VMX_BASIC, in all
other case ignore the check to make the logic consistent with SDM.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 28 +++++++++++++++++++---------
 arch/x86/kvm/vmx/nested.h |  5 +++++
 2 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2156c9a854f4..14f9822b611d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1272,9 +1272,10 @@ static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
 {
 	const u64 feature_bits = VMX_BASIC_DUAL_MONITOR_TREATMENT |
 				 VMX_BASIC_INOUT |
-				 VMX_BASIC_TRUE_CTLS;
+				 VMX_BASIC_TRUE_CTLS |
+				 VMX_BASIC_NO_HW_ERROR_CODE_CC;
 
-	const u64 reserved_bits = GENMASK_ULL(63, 56) |
+	const u64 reserved_bits = GENMASK_ULL(63, 57) |
 				  GENMASK_ULL(47, 45) |
 				  BIT_ULL(31);
 
@@ -2949,7 +2950,6 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 		u8 vector = intr_info & INTR_INFO_VECTOR_MASK;
 		u32 intr_type = intr_info & INTR_INFO_INTR_TYPE_MASK;
 		bool has_error_code = intr_info & INTR_INFO_DELIVER_CODE_MASK;
-		bool should_have_error_code;
 		bool urg = nested_cpu_has2(vmcs12,
 					   SECONDARY_EXEC_UNRESTRICTED_GUEST);
 		bool prot_mode = !urg || vmcs12->guest_cr0 & X86_CR0_PE;
@@ -2966,12 +2966,20 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 		    CC(intr_type == INTR_TYPE_OTHER_EVENT && vector != 0))
 			return -EINVAL;
 
-		/* VM-entry interruption-info field: deliver error code */
-		should_have_error_code =
-			intr_type == INTR_TYPE_HARD_EXCEPTION && prot_mode &&
-			x86_exception_has_error_code(vector);
-		if (CC(has_error_code != should_have_error_code))
-			return -EINVAL;
+		/*
+		 * Cannot deliver error code in real mode or if the interrupt
+		 * type is not hardware exception. For other cases, do the
+		 * consistency check only if the vCPU doesn't enumerate
+		 * VMX_BASIC_NO_HW_ERROR_CODE_CC.
+		 */
+		if (!prot_mode || intr_type != INTR_TYPE_HARD_EXCEPTION) {
+			if (CC(has_error_code))
+				return -EINVAL;
+		} else if (!nested_cpu_has_no_hw_errcode_cc(vcpu)) {
+			if (CC(has_error_code !=
+			       x86_exception_has_error_code(vector)))
+				return -EINVAL;
+		}
 
 		/* VM-entry exception error code */
 		if (CC(has_error_code &&
@@ -7214,6 +7222,8 @@ static void nested_vmx_setup_basic(struct nested_vmx_msrs *msrs)
 	msrs->basic |= VMX_BASIC_TRUE_CTLS;
 	if (cpu_has_vmx_basic_inout())
 		msrs->basic |= VMX_BASIC_INOUT;
+	if (cpu_has_vmx_basic_no_hw_errcode())
+		msrs->basic |= VMX_BASIC_NO_HW_ERROR_CODE_CC;
 }
 
 static void nested_vmx_setup_cr_fixed(struct nested_vmx_msrs *msrs)
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 6eedcfc91070..983484d42ebf 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -309,6 +309,11 @@ static inline bool nested_cr4_valid(struct kvm_vcpu *vcpu, unsigned long val)
 	       __kvm_is_valid_cr4(vcpu, val);
 }
 
+static inline bool nested_cpu_has_no_hw_errcode_cc(struct kvm_vcpu *vcpu)
+{
+	return to_vmx(vcpu)->nested.msrs.basic & VMX_BASIC_NO_HW_ERROR_CODE_CC;
+}
+
 /* No difference in the restrictions on guest and host CR4 in VMX operation. */
 #define nested_guest_cr4_valid	nested_cr4_valid
 #define nested_host_cr4_valid	nested_cr4_valid
-- 
2.51.0.384.g4c02a37b29-goog


