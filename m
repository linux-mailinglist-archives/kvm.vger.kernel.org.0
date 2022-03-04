Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25A34CDDA9
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 20:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiCDUAQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiCDT7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 14:59:11 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7274A20E588;
        Fri,  4 Mar 2022 11:50:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423439; x=1677959439;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lypC3uUOGooQHeJmscl9pX6joEn90C93v0AgpuIlWgk=;
  b=h5zbNQrbGjNJ9Jk/RwdvoEbSDdslszwyd349mGXJ8mP5GxrQDsF87Xyh
   71QhcnKSVYA3Ft0irmFznmZLo7qozZt9m+TN8OcQqS5Pc0iamyVACYRGK
   cHX9isJy4A6ZJayzIwKxMLhN4XoWVxAuM9m8CQb31PGqQzDxQQ24r7ESn
   AYFUrghNB0gUT2wfo7HbGx5LU93BhWWzIbqsoLjorSsq2kJW6JZxzQAVn
   uR6HkUkjYk2Rq0DbhKhBeocj7X63/nfedCvwdYPQV9FX+iW8FumnnrWR8
   LT1V27rxTGKXlGw5Wl84Lbj5l3o3i0aOCo57Zew5XBFUkb6FIblfc6S4N
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253779629"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253779629"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:37 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344500"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:37 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 077/104] KVM: TDX: Use vcpu_to_pi_desc() uniformly in posted_intr.c
Date:   Fri,  4 Mar 2022 11:49:33 -0800
Message-Id: <ee7be7832bc424546fd4f05015a844a0205b5ba2.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yuan Yao <yuan.yao@intel.com>

The helper function, vcpu_to_pi_desc(), is defined to get the posted
interrupt descriptor from vcpu.  There is one place that doesn't use it,
but direct reference to vmx_vcpu->pi_desc.  It's inconsistent.

For TDX, TDX vcpu structure will be defined and the helper function,
vcpu_to_pi_desc(), will return tdx_vcpu->pi_desc for TDX case instead of
vmx_vcpu->pi_desc.  The direct reference to vmx_vcpu->pi_desc doesn't work
for TDX.

Replace vmx_vcpu->pi_desc with the helper function, vcpu_pi_desc() for
consistency and TDX.

Signed-off-by: Yuan Yao <yuan.yao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 2 +-
 arch/x86/kvm/vmx/x86_ops.h     | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index aa1fe9085d77..c8a81c916eed 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -311,7 +311,7 @@ int pi_update_irte(struct kvm *kvm, unsigned int host_irq, uint32_t guest_irq,
 			continue;
 		}
 
-		vcpu_info.pi_desc_addr = __pa(&to_vmx(vcpu)->pi_desc);
+		vcpu_info.pi_desc_addr = __pa(vcpu_to_pi_desc(vcpu));
 		vcpu_info.vector = irq.vector;
 
 		trace_kvm_pi_irte_update(host_irq, vcpu->vcpu_id, e->gsi,
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index aae0f4449ec5..0f1a28f67e60 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -147,6 +147,9 @@ void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void tdx_vcpu_put(struct kvm_vcpu *vcpu);
 void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 
+void tdx_apicv_post_state_restore(struct kvm_vcpu *vcpu);
+int tdx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector);
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
-- 
2.25.1

