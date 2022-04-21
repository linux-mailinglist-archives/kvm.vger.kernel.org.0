Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C181509C1A
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 11:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387417AbiDUJQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 05:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351267AbiDUJQV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 05:16:21 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443B424BE5;
        Thu, 21 Apr 2022 02:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650532412; x=1682068412;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Zm6JKw9VGZgvPFi4mGcScGWwfeg01jOHMUUy+Un0/Q8=;
  b=iNycPMnxOQ/QM+Dx+qIGiNrBx1YoPW0jXnJeFjuoyBM6vmODCzgy/gQk
   yjYbTNJg17RMJ8GKxRU4BJS9Zg7Gy9QE2oTwy2EnFCG6ny9FrrrYIAsql
   SGhO8bs2I2931DxiEqfGGuI+Htts0U4w1QUywR3FdHr5kyLKolQxOwkWp
   GknG4XR/CbOvVdFBFgtcDkv0hxa/Fi29glqiDpsv8kb30Skl072sKrPY/
   MGvNcFerAL/29fWuDG9VUtpV/r0yb6zF6mtcJHQOGFOI98zJeFkS5rIID
   S/XmEa2MNFxFhvn8lNlYmgxjN0Ds4yrtLE1Zf/9xnERoV49JtWb7qZr4Y
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="327193515"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="327193515"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 02:13:31 -0700
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="532953305"
Received: from 984fee00be24.jf.intel.com ([10.165.54.246])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 02:13:31 -0700
From:   Lei Wang <lei4.wang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com
Cc:     lei4.wang@intel.com, chenyi.qiang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: VMX: Read BNDCFGS if not from_vmentry
Date:   Thu, 21 Apr 2022 02:13:31 -0700
Message-Id: <20220421091331.11196-1-lei4.wang@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the migration case, if nested state is set after MSR state, the value
needs to come from the current MSR value.

Signed-off-by: Lei Wang <lei4.wang@intel.com>
Reported-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f18744f7ff82..58a1fa7defc9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3381,7 +3381,8 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	if (!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
 		vmx->nested.vmcs01_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
 	if (kvm_mpx_supported() &&
-		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
+	    (!from_vmentry ||
+	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
 		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
 
 	/*
-- 
2.25.1

