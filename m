Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA39D8F57A
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 22:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732239AbfHOUJp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 16:09:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:43467 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730338AbfHOUJp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 16:09:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Aug 2019 13:09:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,389,1559545200"; 
   d="scan'208";a="171213182"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 15 Aug 2019 13:09:32 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: VMX: Fix and tweak the comments for VM-Enter
Date:   Thu, 15 Aug 2019 13:09:31 -0700
Message-Id: <20190815200931.18260-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix an incorrect/stale comment regarding the vmx_vcpu pointer, as guest
registers are now loaded using a direct pointer to the start of the
register array.

Opportunistically add a comment to document why the vmx_vcpu pointer is
needed, its consumption via 'call vmx_update_host_rsp' is rather subtle.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmenter.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 4010d519eb8c..751a384c2eb0 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -94,7 +94,7 @@ ENDPROC(vmx_vmexit)
 
 /**
  * __vmx_vcpu_run - Run a vCPU via a transition to VMX guest mode
- * @vmx:	struct vcpu_vmx *
+ * @vmx:	struct vcpu_vmx * (forwarded to vmx_update_host_rsp)
  * @regs:	unsigned long * (to guest registers)
  * @launched:	%true if the VMCS has been launched
  *
@@ -151,7 +151,7 @@ ENTRY(__vmx_vcpu_run)
 	mov VCPU_R14(%_ASM_AX), %r14
 	mov VCPU_R15(%_ASM_AX), %r15
 #endif
-	/* Load guest RAX.  This kills the vmx_vcpu pointer! */
+	/* Load guest RAX.  This kills the @regs pointer! */
 	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
 
 	/* Enter guest mode */
-- 
2.22.0

