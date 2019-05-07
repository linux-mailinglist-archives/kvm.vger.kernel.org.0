Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 036FB16B20
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 21:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfEGTSR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 15:18:17 -0400
Received: from mga06.intel.com ([134.134.136.31]:55701 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726457AbfEGTSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 15:18:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 May 2019 12:18:06 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga005.jf.intel.com with ESMTP; 07 May 2019 12:18:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [PATCH 07/13] KVM: nVMX: Don't reset VMCS controls shadow on VMCS switch
Date:   Tue,  7 May 2019 12:17:59 -0700
Message-Id: <20190507191805.9932-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507191805.9932-1-sean.j.christopherson@intel.com>
References: <20190507191805.9932-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

... now that the shadow copies are per-VMCS.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 5 -----
 arch/x86/kvm/vmx/vmx.h    | 4 ----
 2 files changed, 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 007d03a49484..23be882e3365 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -252,11 +252,6 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
 	vmx_vcpu_load(vcpu, cpu);
 	put_cpu();
 
-	vm_entry_controls_reset_shadow(vmx);
-	vm_exit_controls_reset_shadow(vmx);
-	pin_controls_reset_shadow(vmx);
-	exec_controls_reset_shadow(vmx);
-	sec_exec_controls_reset_shadow(vmx);
 	vmx_segment_cache_clear(vmx);
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 2c367011df98..c12c0aec13a5 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -375,10 +375,6 @@ static inline u8 vmx_get_rvi(void)
 }
 
 #define BUILD_CONTROLS_SHADOW(lname, uname)				    \
-static inline void lname##_controls_reset_shadow(struct vcpu_vmx *vmx)	    \
-{									    \
-	vmx->loaded_vmcs->controls_shadow.lname = vmcs_read32(uname);	    \
-}									    \
 static inline void lname##_controls_init(struct vcpu_vmx *vmx, u32 val)	    \
 {									    \
 	vmcs_write32(uname, val);					    \
-- 
2.21.0

