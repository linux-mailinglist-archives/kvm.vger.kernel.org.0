Return-Path: <kvm+bounces-57460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F4E5B55A1E
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:29:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D31D1D634B6
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:29:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 142C6286D71;
	Fri, 12 Sep 2025 23:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iY/b/ioY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D212D8773
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719437; cv=none; b=RpBYyW2rSFJOOPloW2qMH3CGWSO0vuoZ+xq55WanhYSFnuKazAOtrg03N0KoOXpF8l/Cb3gCBAtZy0PPuznKuCHHigW7X/5/EUeWGkNLlGQxZoBmr2RqTG0z5yHHaC0pO4I6hSg4zcmdSdb27cQiL6gi8d304sTgADK5mJLRWWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719437; c=relaxed/simple;
	bh=M1nWD2E0HDgANYcBPl2Wswzs3ho+0obMQ5NM0tyPxik=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=diDPFrU8v9KB9oQ1z79eG1sc0l5MtJ+LeFDMAe4y0EL8rYuekkXXK3G7ID2spAjYF6LqIIqCts0ZGQC1pfsIGRY7U/RzeoW5mQvf9eLDVN71UqBSgLXRqMg1/3KPIwftqHA/dx9B7qYyVG1NV5AHoP+RFaoUSDaOMD9GYvXOmGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iY/b/ioY; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b4f86568434so1844288a12.2
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719435; x=1758324235; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lhwMt9LM9CKgLgMN4tyJKQAo1uPkwcDcwQkAMTCyBHE=;
        b=iY/b/ioY5xhE2gA4mXtUbV7kHb/KlhibDRkQJrgGh3WxNVAqQRKE0J0kW+Qh0FDwFa
         xlaKjP9OeAzs1yxROgb5CxR1a4o046eE2SaEXuBTzhrVh70dE0+GIwZjVpo0IWLMollE
         yQMBGSWaCXVKOonLsFA01cTUxrHKRbOKp6W/XePgqysuHxddh3+CLA0yh4dLirKVACfe
         RNVst1L+3yPUKUK7rLn2w17nPTGxBtQgwBo/VjT+Q6EGilQhztYtyPji7ccU5uQiwKAP
         uNalmsLc9d8MK3Etj++tKCI7e+yye0kmGDAcK5j34no+l9iZgm19d7Vd2cPPEUu32H5b
         qmxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719435; x=1758324235;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lhwMt9LM9CKgLgMN4tyJKQAo1uPkwcDcwQkAMTCyBHE=;
        b=pun/fiZv2iZMVYYDw4TrU2zrYIotzvTdibkHudsf5LjacLWfoMnbnui+tHIeEIfbeQ
         Y81cWBhBsU6E19vT/ey7tzHsH6fqFI6yUWTlhylmEa8hrWg8PYAP/ddIXdPY/rJSaleC
         Vr9gKextU5kiH7X9g8YxDqgFPCDSvWmHDS5IA3gYd3f/0UPnLepJ9fCuX/2y6g+xjY1A
         Kvx0niQrYWzZaDTtjSyNvoLSyn4shMIymJjHAai3M1yzU01plf/GemkoESM3kSGbQTTa
         OTG4npf2Wujjr3k9bTDjXqU6NkK3Eid42TjC0JLDWjpGXEl1PzSSLWQEy4VtXXl9jJFM
         2TXQ==
X-Gm-Message-State: AOJu0YzFfTcVTmzC6yRI7YPHYoMNiQsrvcC3SCoBMU3XQF1fRPDQk5LY
	rE2EDd2JKCbxYwUoUaSMnxNd5ky3TAOyJY71CSuIPje0gNB88YdAnPSBjGscJuEjHGqY9Hx/rx6
	U1Skk9A==
X-Google-Smtp-Source: AGHT+IHxkFxqerPWrQF0fOHehya6YiGIU7WRAKwhJooJuxvebVGbmgb5kjeZ64kLBkd5ltC5qsu0JkICYXk=
X-Received: from pjbqo14.prod.google.com ([2002:a17:90b:3dce:b0:32d:d8df:e3c2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ccd2:b0:24a:9344:fc9b
 with SMTP id d9443c01a7336-25d273360efmr56569695ad.57.1757719435182; Fri, 12
 Sep 2025 16:23:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:22:55 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-18-seanjc@google.com>
Subject: [PATCH v15 17/41] KVM: VMX: Set host constant supervisor states to
 VMCS fields
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Yang Weijiang <weijiang.yang@intel.com>

Save constant values to HOST_{S_CET,SSP,INTR_SSP_TABLE} field explicitly.
Kernel IBT is supported and the setting in MSR_IA32_S_CET is static after
post-boot(The exception is BIOS call case but vCPU thread never across it)
and KVM doesn't need to refresh HOST_S_CET field before every VM-Enter/
VM-Exit sequence.

Host supervisor shadow stack is not enabled now and SSP is not accessible
to kernel mode, thus it's safe to set host IA32_INT_SSP_TAB/SSP VMCS field
to 0s. When shadow stack is enabled for CPL3, SSP is reloaded from PL3_SSP
before it exits to userspace. Check SDM Vol 2A/B Chapter 3/4 for SYSCALL/
SYSRET/SYSENTER SYSEXIT/RDSSP/CALL etc.

Prevent KVM module loading if host supervisor shadow stack SHSTK_EN is set
in MSR_IA32_S_CET as KVM cannot co-exit with it correctly.

Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
[sean: snapshot host S_CET if SHSTK *or* IBT is supported]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/capabilities.h |  4 ++++
 arch/x86/kvm/vmx/vmx.c          | 15 +++++++++++++++
 arch/x86/kvm/x86.c              | 12 ++++++++++++
 arch/x86/kvm/x86.h              |  1 +
 4 files changed, 32 insertions(+)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 5316c27f6099..7d290b2cb0f4 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -103,6 +103,10 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
 	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
 }
 
+static inline bool cpu_has_load_cet_ctrl(void)
+{
+	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_CET_STATE);
+}
 static inline bool cpu_has_vmx_mpx(void)
 {
 	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_BNDCFGS;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index adf5af30e537..e8155635cb42 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4320,6 +4320,21 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 
 	if (cpu_has_load_ia32_efer())
 		vmcs_write64(HOST_IA32_EFER, kvm_host.efer);
+
+	/*
+	 * Supervisor shadow stack is not enabled on host side, i.e.,
+	 * host IA32_S_CET.SHSTK_EN bit is guaranteed to 0 now, per SDM
+	 * description(RDSSP instruction), SSP is not readable in CPL0,
+	 * so resetting the two registers to 0s at VM-Exit does no harm
+	 * to kernel execution. When execution flow exits to userspace,
+	 * SSP is reloaded from IA32_PL3_SSP. Check SDM Vol.2A/B Chapter
+	 * 3 and 4 for details.
+	 */
+	if (cpu_has_load_cet_ctrl()) {
+		vmcs_writel(HOST_S_CET, kvm_host.s_cet);
+		vmcs_writel(HOST_SSP, 0);
+		vmcs_writel(HOST_INTR_SSP_TABLE, 0);
+	}
 }
 
 void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0b67b1b0e361..15f208c44cbd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9982,6 +9982,18 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		return -EIO;
 	}
 
+	if (boot_cpu_has(X86_FEATURE_SHSTK) || boot_cpu_has(X86_FEATURE_IBT)) {
+		rdmsrq(MSR_IA32_S_CET, kvm_host.s_cet);
+		/*
+		 * Linux doesn't yet support supervisor shadow stacks (SSS), so
+		 * KVM doesn't save/restore the associated MSRs, i.e. KVM may
+		 * clobber the host values.  Yell and refuse to load if SSS is
+		 * unexpectedly enabled, e.g. to avoid crashing the host.
+		 */
+		if (WARN_ON_ONCE(kvm_host.s_cet & CET_SHSTK_EN))
+			return -EIO;
+	}
+
 	memset(&kvm_caps, 0, sizeof(kvm_caps));
 
 	x86_emulator_cache = kvm_alloc_emulator_cache();
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 076eccba0f7e..65cbd454c4f1 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -50,6 +50,7 @@ struct kvm_host_values {
 	u64 efer;
 	u64 xcr0;
 	u64 xss;
+	u64 s_cet;
 	u64 arch_capabilities;
 };
 
-- 
2.51.0.384.g4c02a37b29-goog


