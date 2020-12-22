Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85BB2DD89A
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 19:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729995AbgLQSpj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 13:45:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbgLQSpi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Dec 2020 13:45:38 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7C3C0617A7;
        Thu, 17 Dec 2020 10:44:58 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id cm17so29727334edb.4;
        Thu, 17 Dec 2020 10:44:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a9fRIqvzJymHT2HZ/FU26JTBjEDUTwr5tEPTmXqVJpM=;
        b=MwjMOllUK0/NSsp+i51FRUdBQl1xYyWF180W81NE+Ll3OUdEyyhvKWcvoTFQT7idAL
         aAhOtYgN+59eBv7CDVMuRuYTkkl4OiJBQZEK8iTdp3SLX1oTgW6V+1rurF+BI4+i9CWp
         JKy3wYAyIYCrjOIWrtwK29weGiMXKfmI3hYqnaxwnoYYNXA0vtix3i1sRJ1jGkOndvdm
         +ALJH3T6vclBHkH9rei3Wo++kFHz2AmpMKxGDcGrO+gUNfTQ14oXBuyShBX67UKDzhVl
         GkbD8zzPWTBnsdtpZcIRa/hMyDCIrvMsajgmfG4PBP7yBCDvTijo//X9FduCgzxIfSSa
         xw/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a9fRIqvzJymHT2HZ/FU26JTBjEDUTwr5tEPTmXqVJpM=;
        b=PDtTCPjHi7s408g4TXSMtqfGQbbQBqKUymSJbc1RVMfAqIsGq8Fd9QnwS7AIRUwqn0
         n3FGMMVgVwrDH2RIiZ/+yn/kqLfeF9qnW1sEIHLwoMiBGC4b8I6h5M9Rwwy+hRCG/uLW
         3CF3qHR6v4jT1ibaKCbZqWeTXeeF+YCu0N2iLQ5l+cGCTZ6cMOBx0JI1J3ZesJTH5Ij4
         t3TQxpn3mDSlihJxwh2H122S/WCz4qBAWy9FXoPEqKOMyx1AFwhu2DqE90K0U1xLNZzi
         wHMAU1YojweGplh+a6WntxbqJKkT2CDMIlIPrEeHX0cLGkcHPM7i4nU1q3kQTE10Ply2
         uWFQ==
X-Gm-Message-State: AOAM533KXzM29Tb6Axl79zSeKoGT1F70G5bEfPPnG/evhsLdvSXjy1Fd
        hxLv6HYiusApI+JH6jn3o3Z9uZy9WznakA==
X-Google-Smtp-Source: ABdhPJxvQPAIj76o5mOi9AIT9d+pRI5J4Gg8nLlRTQcN/prDDqJGBUHEHS85KXt2kfGvCtmjpFt2YQ==
X-Received: by 2002:a50:fe8d:: with SMTP id d13mr738395edt.132.1608230696344;
        Thu, 17 Dec 2020 10:44:56 -0800 (PST)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id k3sm10849713eds.87.2020.12.17.10.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 10:44:55 -0800 (PST)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH] KVM/nVMX: Use __vmx_vcpu_run in nested_vmx_check_vmentry_hw
Date:   Thu, 17 Dec 2020 19:44:51 +0100
Message-Id: <20201217184451.201311-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace inline assembly in nested_vmx_check_vmentry_hw
with a call to __vmx_vcpu_run.  The function is not
performance critical, so (double) GPR save/restore
in __vmx_vcpu_run can be tolerated, as far as performance
effects are concerned.

v2: Mark vmx_vmenter SYM_FUNC_START_LOCAL.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Reviewed-and-tested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/vmx/nested.c  | 32 +++-----------------------------
 arch/x86/kvm/vmx/vmenter.S |  2 +-
 arch/x86/kvm/vmx/vmx.c     |  2 --
 arch/x86/kvm/vmx/vmx.h     |  1 +
 4 files changed, 5 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 89af692deb7e..6ab62bf277c4 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -12,6 +12,7 @@
 #include "nested.h"
 #include "pmu.h"
 #include "trace.h"
+#include "vmx.h"
 #include "x86.h"
 
 static bool __read_mostly enable_shadow_vmcs = 1;
@@ -3056,35 +3057,8 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 		vmx->loaded_vmcs->host_state.cr4 = cr4;
 	}
 
-	asm(
-		"sub $%c[wordsize], %%" _ASM_SP "\n\t" /* temporarily adjust RSP for CALL */
-		"cmp %%" _ASM_SP ", %c[host_state_rsp](%[loaded_vmcs]) \n\t"
-		"je 1f \n\t"
-		__ex("vmwrite %%" _ASM_SP ", %[HOST_RSP]") "\n\t"
-		"mov %%" _ASM_SP ", %c[host_state_rsp](%[loaded_vmcs]) \n\t"
-		"1: \n\t"
-		"add $%c[wordsize], %%" _ASM_SP "\n\t" /* un-adjust RSP */
-
-		/* Check if vmlaunch or vmresume is needed */
-		"cmpb $0, %c[launched](%[loaded_vmcs])\n\t"
-
-		/*
-		 * VMLAUNCH and VMRESUME clear RFLAGS.{CF,ZF} on VM-Exit, set
-		 * RFLAGS.CF on VM-Fail Invalid and set RFLAGS.ZF on VM-Fail
-		 * Valid.  vmx_vmenter() directly "returns" RFLAGS, and so the
-		 * results of VM-Enter is captured via CC_{SET,OUT} to vm_fail.
-		 */
-		"call vmx_vmenter\n\t"
-
-		CC_SET(be)
-	      : ASM_CALL_CONSTRAINT, CC_OUT(be) (vm_fail)
-	      :	[HOST_RSP]"r"((unsigned long)HOST_RSP),
-		[loaded_vmcs]"r"(vmx->loaded_vmcs),
-		[launched]"i"(offsetof(struct loaded_vmcs, launched)),
-		[host_state_rsp]"i"(offsetof(struct loaded_vmcs, host_state.rsp)),
-		[wordsize]"i"(sizeof(ulong))
-	      : "memory"
-	);
+	vm_fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
+				 vmx->loaded_vmcs->launched);
 
 	if (vmx->msr_autoload.host.nr)
 		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 90ad7a6246e3..14abe1e37359 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -44,7 +44,7 @@
  * they VM-Fail, whereas a successful VM-Enter + VM-Exit will jump
  * to vmx_vmexit.
  */
-SYM_FUNC_START(vmx_vmenter)
+SYM_FUNC_START_LOCAL(vmx_vmenter)
 	/* EFLAGS.ZF is set if VMCS.LAUNCHED == 0 */
 	je 2f
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 47b8357b9751..72b496c54bc9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6593,8 +6593,6 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 	}
 }
 
-bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
-
 static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 					struct vcpu_vmx *vmx)
 {
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index f6f66e5c6510..32db3b033e9b 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -339,6 +339,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
+bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
 int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr);
 void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
 
-- 
2.26.2

