Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6B26225AC
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 09:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiKIInF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 03:43:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiKIInD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 03:43:03 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9131C17AA5;
        Wed,  9 Nov 2022 00:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667983382; x=1699519382;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SoYhyfo94w1nT1vEoyUdWmnY7U+YGAK7DqCmILxRuR8=;
  b=bMCbtw6+DCLyWCH3pGCdHcXCvat4mYZo1K+mF0Qi2QxfJ2ZS5DbI2oho
   krRMYOXC50r7c6Bc4o4BNDTOyL6CPIIV0IAbiMcJfj9g77T+3az/MyvsW
   yKyee7j+HAf/IZy5KA9IwuFjCKlGaSKfOX+Q56R0AMHnrrJKdFU+57+ee
   mKwYk9LZxAzNZD3qTXU8odjosxZ/NEpqsKvw1ryXIaQITzZPHZfR6RhfG
   TE4GsPUYVVbtbvJ3885Pz4Qi9f5nJbi1WCHj7iPWpRWM7rjYv5QUPMgfP
   WeqkU/qMe7cwxUUwxusaYZRIGGh0Amiw9iftxJ4yBIw1/pNVuaYbiFIcV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="308544193"
X-IronPort-AV: E=Sophos;i="5.96,150,1665471600"; 
   d="scan'208";a="308544193"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 00:43:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="631182816"
X-IronPort-AV: E=Sophos;i="5.96,150,1665471600"; 
   d="scan'208";a="631182816"
Received: from skxmcp01.bj.intel.com ([10.240.193.86])
  by orsmga007.jf.intel.com with ESMTP; 09 Nov 2022 00:43:00 -0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] KVM: VMX: Do not trap VMFUNC instructions for L1 guests.
Date:   Wed,  9 Nov 2022 15:54:12 +0800
Message-Id: <20221109075413.1405803-2-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221109075413.1405803-1-yu.c.zhang@linux.intel.com>
References: <20221109075413.1405803-1-yu.c.zhang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, although KVM does not support VMFUNC for L1 guests,
it still traps the VMFUNC instructions. This is done by setting
SECONDARY_EXEC_ENABLE_VMFUNC in the VM-execution control and 0
to VM-function control. And then in the VM exit handler, a #UD
is injected to L1 guest.

But for non-nested, KVM do not need to trap VMFUNC at all. According
to Intel SDM Volume3 25.5.6.2, "General Operation of the VMFUNC
Instruction", The VMFUNC instruction causes an invalid-opcode
exception (#UD) if the “enable VM functions” VM-execution controls
is 0.

So just disable SECONDARY_EXEC_ENABLE_VMFUNC in VM-execution
control for L1 guests.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
---
 arch/x86/kvm/vmx/nested.c | 12 +++++-------
 arch/x86/kvm/vmx/vmx.c    |  7 ++++++-
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0c62352dda6a..1acb81c2be11 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5793,14 +5793,12 @@ static int handle_vmfunc(struct kvm_vcpu *vcpu)
 	u32 function = kvm_rax_read(vcpu);
 
 	/*
-	 * VMFUNC is only supported for nested guests, but we always enable the
-	 * secondary control for simplicity; for non-nested mode, fake that we
-	 * didn't by injecting #UD.
+	 * VMFUNC is only supported for nested guests. Executing VMFUNC
+	 * in non-nested guests shall receive #UD directly, instead of
+	 * trigerring a VM-Exit.
 	 */
-	if (!is_guest_mode(vcpu)) {
-		kvm_queue_exception(vcpu, UD_VECTOR);
-		return 1;
-	}
+	if (KVM_BUG_ON(!is_guest_mode(vcpu), vcpu->kvm))
+		return -EIO;
 
 	vmcs12 = get_vmcs12(vcpu);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 63247c57c72c..5a66c3c16c2d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4487,6 +4487,12 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 				  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
 	exec_control &= ~SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE;
 
+	/*
+	 * KVM doesn't support VMFUNC for L1, but the control is set in KVM's
+	 * base configuration as KVM emulates VMFUNC[EPTP_SWITCHING] for L2.
+	 */
+	exec_control &= ~SECONDARY_EXEC_ENABLE_VMFUNC;
+
 	/* SECONDARY_EXEC_DESC is enabled/disabled on writes to CR4.UMIP,
 	 * in vmx_set_cr4.  */
 	exec_control &= ~SECONDARY_EXEC_DESC;
@@ -6004,7 +6010,6 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_RDSEED]                  = kvm_handle_invalid_op,
 	[EXIT_REASON_PML_FULL]		      = handle_pml_full,
 	[EXIT_REASON_INVPCID]                 = handle_invpcid,
-	[EXIT_REASON_VMFUNC]		      = handle_vmx_instruction,
 	[EXIT_REASON_PREEMPTION_TIMER]	      = handle_preemption_timer,
 	[EXIT_REASON_ENCLS]		      = handle_encls,
 	[EXIT_REASON_BUS_LOCK]                = handle_bus_lock_vmexit,
-- 
2.17.1

