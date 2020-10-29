Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3972729ED42
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 14:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbgJ2Nmd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 09:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgJ2Nmc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Oct 2020 09:42:32 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D959AC0613D3
        for <kvm@vger.kernel.org>; Thu, 29 Oct 2020 06:41:50 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id v4so3126142edi.0
        for <kvm@vger.kernel.org>; Thu, 29 Oct 2020 06:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iwibPJxeDmGnHQbnigiBzcULAYXQt3uTqFbHqr06h6g=;
        b=P9SZ8r3MgSXoP5asOTto/xazlIYsr/rQCL7CmXnICDGMbfbR/hB1pPlFwNo3dtyKhT
         sy10py2hMH4u8OQnEyFN37S0tvFA8N/pGe2vCqzS9aBKcCaeRFESmxLr116sg2g2/O6j
         jqBThR+hPNQwUlu0shmquwW+7WRQtUMbZE7loywZDa0ddZdstNANiPyRwYLYu3Y3l8Ia
         SgAaw4PUH7U6CGrBNfv9eN6IoylbCnQZzifNi8rjfKWQMKVJD/99KsjRoxdFJiENT8Iv
         a3y8/Nj9KtXl//WJ9KcXzEy1TqtJet4yoIhwggjYvdM2VoH7DTocXs2rBrVJ6GfDHVE0
         3eUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iwibPJxeDmGnHQbnigiBzcULAYXQt3uTqFbHqr06h6g=;
        b=O91TGwN6m9x01dmuk9/Th1rwDRBdlSKCIauNkGRMKa5h4OcL/Ldto4PtBUzWJUrSh6
         L/j+EHdexazYPmVulWEWlAeCmbFT/2RRizrs1p6sbA9X57deftpvI1wM4zzjm3Tu8p6N
         w7bXkT06kc4VZSO97QHbXC8ONDFDFDfufzd4vfJt/CiHwv073AHMdzZQ9MPaWcQKPNc8
         tGWmouliUV3yawvjXn+wRU7K/eCifIsO8cB8+XjLC/MZ+gLMhdJQV08xqjMWrnJz+TMo
         OA+AUK4utqBI0dK64N9pycX+rtiuKEaPQ8nvu0OekjPS4qPPGPkkhsj/eit4BAv/89kW
         bV+A==
X-Gm-Message-State: AOAM530nurdxZjRgws3nJOvKX04PSQbRQCAmU56n732OFhR0CDbOKAEX
        SFercqF0BuVgnXpeTGyOV5HiavBFfFpwJQ==
X-Google-Smtp-Source: ABdhPJzRtm4iV5bUSOGpNtq9Oh0riLDfgOMeb4SijPgCz5JCXklMECGm4sA01JfwNWHs24+DlcKU9Q==
X-Received: by 2002:a05:6402:b87:: with SMTP id cf7mr4180523edb.137.1603978909105;
        Thu, 29 Oct 2020 06:41:49 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id z20sm1525837edq.90.2020.10.29.06.41.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 06:41:48 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] KVM/nVMX: Use __vmx_vcpu_run in nested_vmx_check_vmentry_hw
Date:   Thu, 29 Oct 2020 14:41:45 +0100
Message-Id: <20201029134145.107560-1-ubizjak@gmail.com>
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

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/vmx/nested.c | 32 +++-----------------------------
 arch/x86/kvm/vmx/vmx.c    |  2 --
 arch/x86/kvm/vmx/vmx.h    |  1 +
 3 files changed, 4 insertions(+), 31 deletions(-)

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
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d14c94d0aff1..0f390c748b18 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6591,8 +6591,6 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
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

