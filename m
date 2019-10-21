Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A36F2DF8AE
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 01:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730197AbfJUXdl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 19:33:41 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:54359 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730172AbfJUXdl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 19:33:41 -0400
Received: by mail-pf1-f201.google.com with SMTP id s139so12126325pfc.21
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 16:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FxHWH9WHOYfix4ipoMgnxczdcgS6Ll1BonHQMMcZbcI=;
        b=eQr7p4wWpbPes8YnEiuWfmPhqC5whefI/NT3aBzElrbZiEJYDaFEc6jKaw9CgoI69t
         EBPTyWaXOm9lDcbLdkR+qebHMG7Ee/DjdZDD6DQiuxOYAI8/NwqE+Qj6q1rc+Ua7go49
         7eo/o4CAXQPfDCF780CPrSWm/mnCk5BM1ndwwgmmOQUicVtnId2jTtfxh0VwWxBYeQDI
         8yXQbb/CS4SKqYjDBj6S+QgzjklTfWpNrT/XrlDncCpjmsRssTZKsIvDSugLStLAnniZ
         oD3+i4tctl2AH/sP/fiIjz1hkrzCsLlzyVvkHIkp3APcx+vGvFD5lI2tK8MdnnCU4gjc
         gtYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FxHWH9WHOYfix4ipoMgnxczdcgS6Ll1BonHQMMcZbcI=;
        b=JbtBdPkhN37qVmqZm4oU702ZI6c+GupP4294r2DKs8Wm6vN0CccccR4W/Gt81sBjLr
         VB/TnoSenY6E2sub3ePRQsgYWL0HhzEAgZGb2rDdHiBBhc7+Ilf7FmCW7WLkV4i8I2fo
         DPNWJ94esZuwipkIcnRCO7RquB4IG7cQ9D9kK5nJgKsN5OghaiERSisfEA812Qs4uAMK
         7h3AkEy79CCvN9sJNr+YBW1DJykH5ReC4C/L7sUTqWbbjX/aeil9L8kNZ0PDzU4fBOfg
         vcFYs1U2Ft8pM1yI6AX/QrH/hXCL2KjkKee/msGxFgmdefm862AyDG7zL+UJip1ARAJP
         DOzg==
X-Gm-Message-State: APjAAAVs3ja+Ua29MpdxwNcjbTp8BL9fjoZt9iSDwuo71Itj3wsDsIDU
        ruNvPIx55aWKTaHkdB1+X66yty+tP0sRYU68
X-Google-Smtp-Source: APXvYqwI3DSyd247UHYdwXcO/kQxZ8NowEk8vvSHY1E4LqQNLR2QuBgBcQr1J2ZSw044GF6w6V8UpWBVvyDsHf9E
X-Received: by 2002:a63:3853:: with SMTP id h19mr435519pgn.55.1571700819063;
 Mon, 21 Oct 2019 16:33:39 -0700 (PDT)
Date:   Mon, 21 Oct 2019 16:30:21 -0700
In-Reply-To: <20191021233027.21566-1-aaronlewis@google.com>
Message-Id: <20191021233027.21566-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191021233027.21566-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH v3 2/9] KVM: VMX: Fix conditions for guest IA32_XSS support
From:   Aaron Lewis <aaronlewis@google.com>
To:     Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Volume 4 of the SDM says that IA32_XSS is supported
if CPUID(EAX=0DH,ECX=1):EAX.XSS[bit 3] is set, so only the
X86_FEATURE_XSAVES check is necessary (X86_FEATURE_XSAVES is the Linux
name for CPUID(EAX=0DH,ECX=1):EAX.XSS[bit 3]).

Fixes: 4d763b168e9c5 ("KVM: VMX: check CPUID before allowing read/write of IA32_XSS")
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Change-Id: I9059b9f2e3595e4b09a4cdcf14b933b22ebad419
---
 arch/x86/kvm/vmx/vmx.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 34525af44353..a9b070001c3e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1821,10 +1821,8 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		return vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
 				       &msr_info->data);
 	case MSR_IA32_XSS:
-		if (!vmx_xsaves_supported() ||
-		    (!msr_info->host_initiated &&
-		     !(guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
-		       guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))))
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
 			return 1;
 		msr_info->data = vcpu->arch.ia32_xss;
 		break;
@@ -2064,10 +2062,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		return vmx_set_vmx_msr(vcpu, msr_index, data);
 	case MSR_IA32_XSS:
-		if (!vmx_xsaves_supported() ||
-		    (!msr_info->host_initiated &&
-		     !(guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
-		       guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))))
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
 			return 1;
 		/*
 		 * The only supported bit as of Skylake is bit 8, but
@@ -2076,11 +2072,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data != 0)
 			return 1;
 		vcpu->arch.ia32_xss = data;
-		if (vcpu->arch.ia32_xss != host_xss)
-			add_atomic_switch_msr(vmx, MSR_IA32_XSS,
-				vcpu->arch.ia32_xss, host_xss, false);
-		else
-			clear_atomic_switch_msr(vmx, MSR_IA32_XSS);
+		if (vcpu->arch.xsaves_enabled) {
+			if (vcpu->arch.ia32_xss != host_xss)
+				add_atomic_switch_msr(vmx, MSR_IA32_XSS,
+					vcpu->arch.ia32_xss, host_xss, false);
+			else
+				clear_atomic_switch_msr(vmx, MSR_IA32_XSS);
+		}
 		break;
 	case MSR_IA32_RTIT_CTL:
 		if ((pt_mode != PT_MODE_HOST_GUEST) ||
-- 
2.23.0.866.gb869b98d4c-goog

