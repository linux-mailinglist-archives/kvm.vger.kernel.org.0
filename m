Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0806055D8
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 05:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiJTDQX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 23:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiJTDQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 23:16:20 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F494152013;
        Wed, 19 Oct 2022 20:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666235779; x=1697771779;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/duzIIr48yquYHPVShw/vjj6dlvWHbKZ3g4MXUDZw60=;
  b=J85kF6O97aDg3mA6lKgpVXa8lIBeNUNXc/V4zdXvcBago2B0f7kq3AuN
   5HZ+5g70fx2A53bXk46Z1sq4ktC6w8O97dPxiyOo9LpOf5KpviQCBIxXd
   VN8FXxRjXD5ZAkpzX10U0Be6hfJs4ASSuF65hm1tox50qTn8hRjB4x/eB
   gNlcJrOr0TNc7G6CXCr2FQDuoimqwmdjTpf8nq23/6zP3LwfHHgDqjf3r
   XKomwopB8p4ayd8asF9HaoY8gYefXYQ3eQCjw2fHTNDl+Ve3W+542AAFH
   s9MR2dWXKxVKmbtCjE1l70Rw6RFWOTIbzkDQCWeiFuyptQulxCsXiry4B
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="333155355"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="333155355"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 20:16:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="662783145"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="662783145"
Received: from lxy-dell.sh.intel.com ([10.239.48.100])
  by orsmga001.jf.intel.com with ESMTP; 19 Oct 2022 20:16:15 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH] KVM: x86: Fix the initial value of mcg_cap
Date:   Thu, 20 Oct 2022 11:16:15 +0800
Message-Id: <20221020031615.890400-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vcpu->arch.mcg_cap represents the value of MSR_IA32_MCG_CAP. It's
set via ioctl(KVM_X86_SETUP_MCE) from userspace when exposing and
configuring MCE to guest.

It's wrong to leave the default value as KVM_MAX_MCE_BANKS.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/x86.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4bd5f8a751de..ca8f4a3e698d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11801,7 +11801,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 					    GFP_KERNEL_ACCOUNT);
 	if (!vcpu->arch.mce_banks || !vcpu->arch.mci_ctl2_banks)
 		goto fail_free_mce_banks;
-	vcpu->arch.mcg_cap = KVM_MAX_MCE_BANKS;
 
 	if (!zalloc_cpumask_var(&vcpu->arch.wbinvd_dirty_mask,
 				GFP_KERNEL_ACCOUNT))
-- 
2.27.0

