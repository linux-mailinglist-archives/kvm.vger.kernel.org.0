Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A19271434B
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbjE2Edq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbjE2E3P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:29:15 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1381C19B0;
        Sun, 28 May 2023 21:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334336; x=1716870336;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ukB0MOnbifHNJMo+YwBnBra66saHsNIV92Ld8qPAd2s=;
  b=Jcd0r/T5MW2pa8+HCN+noYpZ0tIVQu+TzyR/Lgo7HGqDQNEIfgKcCcSl
   w4sSaLF+LrdUo8voZ5CgMohCY9UdKtS6cfheBLTOiAdBTqB/wAvaiBl0r
   FmqTTsdYn5n+SdTvXVH2gtMK0mbq4VtOZ4ySF2EWLPcmiG3Kc6QVSsQJT
   ywKY6gAmOnKv7+DA8/3r+RFqwsI70bmWm0KiQxa8jfbKePIBnH8/wEw0h
   09CnWBY4iEKUHdJe5pQqkwe2dghWoanV6UWvA08KWR43y4mwQbrPw1ena
   ia4EM5QDOy8hdoRmyMVuHisWX89v3C8hSBGvZjqQQO/hgTUqPj91K+HkJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="334966213"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="334966213"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="775784494"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="775784494"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:31 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v14 080/113] KVM: VMX: Modify NMI and INTR handlers to take intr_info as function argument
Date:   Sun, 28 May 2023 21:20:02 -0700
Message-Id: <b1144547a3224325b0439f24ad61a4c2e6cb3891.1685333728.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1685333727.git.isaku.yamahata@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

TDX uses different ABI to get information about VM exit.  Pass intr_info to
the NMI and INTR handlers instead of pulling it from vcpu_vmx in
preparation for sharing the bulk of the handlers with TDX.

When the guest TD exits to VMM, RAX holds status and exit reason, RCX holds
exit qualification etc rather than the VMCS fields because VMM doesn't have
access to the VMCS.  The eventual code will be

VMX:
  - get exit reason, intr_info, exit_qualification, and etc from VMCS
  - call NMI/INTR handlers (common code)

TDX:
  - get exit reason, intr_info, exit_qualification, and etc from guest
    registers
  - call NMI/INTR handlers (common code)

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3186c702100e..480dc1af602e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6841,24 +6841,22 @@ static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
 		rdmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
 }
 
-static void handle_exception_irqoff(struct vcpu_vmx *vmx)
+static void handle_exception_irqoff(struct kvm_vcpu *vcpu, u32 intr_info)
 {
-	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
-
 	/* if exit due to PF check for async PF */
 	if (is_page_fault(intr_info))
-		vmx->vcpu.arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
+		vcpu->arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
 	/* if exit due to NM, handle before interrupts are enabled */
 	else if (is_nm_fault(intr_info))
-		handle_nm_fault_irqoff(&vmx->vcpu);
+		handle_nm_fault_irqoff(vcpu);
 	/* Handle machine checks before interrupts are enabled */
 	else if (is_machine_check(intr_info))
 		kvm_machine_check();
 }
 
-static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
+static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu,
+					     u32 intr_info)
 {
-	u32 intr_info = vmx_get_intr_info(vcpu);
 	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
 	gate_desc *desc = (gate_desc *)host_idt_base + vector;
 
@@ -6881,9 +6879,9 @@ void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 		return;
 
 	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
-		handle_external_interrupt_irqoff(vcpu);
+		handle_external_interrupt_irqoff(vcpu, vmx_get_intr_info(vcpu));
 	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)
-		handle_exception_irqoff(vmx);
+		handle_exception_irqoff(vcpu, vmx_get_intr_info(vcpu));
 }
 
 /*
-- 
2.25.1

