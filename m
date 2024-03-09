Return-Path: <kvm+bounces-11435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEF04876E96
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 02:31:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63A99286F18
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 01:31:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE673DB86;
	Sat,  9 Mar 2024 01:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YK90p5J5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD673AC08
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 01:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709947670; cv=none; b=jw7ZTRuePhKKBjPPCT0NIjy2/BMMg6quz68jBoeI4ft/k6gWXpqqJIJ7fujBKiuwxlgRiIqknqVGZDmLDlpjgSI3aFi512RL9iF2Ad54L3caCg8Rt/APT7bqHcY8BV+qdr8LBkCNTm1oLLQMkJlCSbcsTzYOgWROJio88bHL0Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709947670; c=relaxed/simple;
	bh=3RB5ybb2eWpxvWqhePHFkoyZ4DVvi7cGA85H74hezaE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=scFlfIuYkF1sAzDaNWmWMcsH87t5lWttBqpw0p7EETnTaxGxgoNFGjWKClVuFUIEAZiXagJobOwA6NihUvdpXuQeWggUiAaVW6pO9MvMOPsxbAxyoQ/JNVJVWlhNskOT7N2Syl638IfUYDjFDtt9DGEmDNpyRnIRC7c0W3dYeWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YK90p5J5; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e62136860eso1259941b3a.3
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 17:27:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709947668; x=1710552468; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PaASkSwAWfMjl4NBiq05b1lXThMlN3vSRBX1XjjeH98=;
        b=YK90p5J5vNtDrnM0FcqgUm4DVGGNSX2ISZ9v8TsPAGelJTpKv6H7wWyWT9haJFvRMN
         SJ20rVLUPaWXboYVMXl9nvKXCPWXiyI6yKWcS+Rdm/d9sm9RD8XGLraae+4tMRPfaoWv
         1mkz0S8imx37mTaSjlo45m2JScfQ9DowpwF+J182eLATqzUa8aG/s8dLHrrgPRTdN8xy
         fKahl9V9jXo/x2rzh4qwSHDwQuLDWP7adiSLpo2rRiJZB+ccDxAZ2VPWO5ax9FuQXvF7
         9UNa7PIVE0goTmyB0me0rEvNQBNeV2uAkIr7CgiD+U6kmdEGiZqUKmy6voqT3W7OC/Wt
         3aqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709947668; x=1710552468;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PaASkSwAWfMjl4NBiq05b1lXThMlN3vSRBX1XjjeH98=;
        b=JG3pcP2tXAhxjAX/atvSa6iHMKZz9z8YbvQ8TUJjserLko1gRWInrtJ2MCiIwluAll
         PuPFtMbqFJYlDrgFeJxy4G/ocAu3C2nF79zQ+nzg+AsiW8Y6GkvWpiLZv7UuqFrZDOV6
         1VQ7yJh75zkqsPZT6cKEm2y0yGDihCPQPH1lDPM/do59KOfZ2v+hQKSVNTOEqPqd1g5D
         /yQGajQ3HZtXaivLQ/F4ma9LXbSqOTRKB4WGisjPgKu6H0gc9hExmzTzEgxiHkiRhVfb
         o1sSlDzw7nETBN/OE73JywAbazMuJDChWm2r5fRL0VXTT8CiLjl9z0e5LLcUwhdx2BZw
         UWZA==
X-Forwarded-Encrypted: i=1; AJvYcCWuGkw5uniZ0fHF07ta/NetES9PwW5lsNLUnCkqis1CNMUoGSaSTLvwOhQWNyn5snZjnxkr9JJYMHEzr0oFNgmdwkFn
X-Gm-Message-State: AOJu0Yw3cDHuMj11xCwGgA3v6CEcw/XKGp6FXzLN9LhNSeQ+QFIQ2cGx
	A7TSZ2aeXf/vP/XazVeg3k8flDud5qyVMZk+4mJym4s9EzMBKB28mLqIBLKsquu8JYfM2b9G5Vf
	A7Q==
X-Google-Smtp-Source: AGHT+IECrHtNs6BgHJfPn5W88AEGOjcbjO3YQOnM3DErPQrq0yT7XiAUw/mEaCIWPLmtk4712WYOVZyywRg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1389:b0:6e6:691f:42f5 with SMTP id
 t9-20020a056a00138900b006e6691f42f5mr47078pfg.0.1709947667900; Fri, 08 Mar
 2024 17:27:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  8 Mar 2024 17:27:25 -0800
In-Reply-To: <20240309012725.1409949-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240309012725.1409949-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240309012725.1409949-10-seanjc@google.com>
Subject: [PATCH v6 9/9] KVM: nVMX: Use macros and #defines in vmx_restore_vmx_misc()
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Shan Kang <shan.kang@intel.com>, Kai Huang <kai.huang@intel.com>, Xin Li <xin3.li@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Xin Li <xin3.li@intel.com>

Use macros in vmx_restore_vmx_misc() instead of open coding everything
using BIT_ULL() and GENMASK_ULL().  Opportunistically split feature bits
and reserved bits into separate variables, and add a comment explaining
the subset logic (it's not immediately obvious that the set of feature
bits is NOT the set of _supported_ feature bits).

Cc: Shan Kang <shan.kang@intel.com>
Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
[sean: split to separate patch, write changelog, drop #defines]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 06512ee7a5c4..6610d258c680 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1322,16 +1322,29 @@ vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
 
 static int vmx_restore_vmx_misc(struct vcpu_vmx *vmx, u64 data)
 {
-	const u64 feature_and_reserved_bits =
-		/* feature */
-		BIT_ULL(5) | GENMASK_ULL(8, 6) | BIT_ULL(14) | BIT_ULL(15) |
-		BIT_ULL(28) | BIT_ULL(29) | BIT_ULL(30) |
-		/* reserved */
-		GENMASK_ULL(13, 9) | BIT_ULL(31);
+	const u64 feature_bits = VMX_MISC_SAVE_EFER_LMA |
+				 VMX_MISC_ACTIVITY_HLT |
+				 VMX_MISC_ACTIVITY_SHUTDOWN |
+				 VMX_MISC_ACTIVITY_WAIT_SIPI |
+				 VMX_MISC_INTEL_PT |
+				 VMX_MISC_RDMSR_IN_SMM |
+				 VMX_MISC_VMWRITE_SHADOW_RO_FIELDS |
+				 VMX_MISC_VMXOFF_BLOCK_SMI |
+				 VMX_MISC_ZERO_LEN_INS;
+
+	const u64 reserved_bits = BIT_ULL(31) | GENMASK_ULL(13, 9);
+
 	u64 vmx_misc = vmx_control_msr(vmcs_config.nested.misc_low,
 				       vmcs_config.nested.misc_high);
 
-	if (!is_bitwise_subset(vmx_misc, data, feature_and_reserved_bits))
+	BUILD_BUG_ON(feature_bits & reserved_bits);
+
+	/*
+	 * The incoming value must not set feature bits or reserved bits that
+	 * aren't allowed/supported by KVM.  Fields, i.e. multi-bit values, are
+	 * explicitly checked below.
+	 */
+	if (!is_bitwise_subset(vmx_misc, data, feature_bits | reserved_bits))
 		return -EINVAL;
 
 	if ((vmx->nested.msrs.pinbased_ctls_high &
-- 
2.44.0.278.ge034bb2e1d-goog


