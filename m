Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64C7659EFA4
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 01:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbiHWXXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 19:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiHWXXt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 19:23:49 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF649895F9;
        Tue, 23 Aug 2022 16:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661297028; x=1692833028;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=m4heacHRUEykxc4MTv3dAtibo6fP1VGs//v25aaWABg=;
  b=QxxSMcZrWqpkMBdDJ0JhopIzN9XBrtbgMYXdcwjaP2EFVQXPEfPSe5iF
   GMKDeDYTbYgH1xOw3+VeNHp/xX4KfZ//opXQG6Gg+/pWUnHaOPbg/mqse
   olcZ4uFJ8kpy1nSQkj/rh7QIrK2oc+JcVf1ijSgA8sOXORJRRE01mxxAB
   e96vbi6ibWBY1Rb3TBPbt7Qbn7h/K5hCCT9WacP4CaWAn744ZI8pmGveh
   3fsq53IYs4ft+KOs1JApZRwlwxJoc0dfILk5NlX32JAIWNuJKu48N24eQ
   47xKzGYKI39ep1u96Nq28Qk+MNM5cJf5y+ubj4vz2qNLbWP40YsvPVaOn
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="355547571"
X-IronPort-AV: E=Sophos;i="5.93,259,1654585200"; 
   d="scan'208";a="355547571"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 16:23:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,259,1654585200"; 
   d="scan'208";a="605831219"
Received: from chang-linux-3.sc.intel.com ([172.25.66.173])
  by orsmga007.jf.intel.com with ESMTP; 23 Aug 2022 16:23:47 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     linux-kernel@vger.kernel.org, yang.zhong@intel.com,
        chang.seok.bae@intel.com
Subject: [RFC PATCH 1/2] KVM: x86: Add a new system attribute for dynamic XSTATE component
Date:   Tue, 23 Aug 2022 16:14:01 -0700
Message-Id: <20220823231402.7839-2-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220823231402.7839-1-chang.seok.bae@intel.com>
References: <20220823231402.7839-1-chang.seok.bae@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

== Background ==

A set of architecture-specific prctl() options offer to control dynamic
XSTATE components in VCPUs. Userspace VMMs may interact with the host using
ARCH_GET_XCOMP_GUEST_PERM and ARCH_REQ_XCOMP_GUEST_PERM.

However, they are separated from the KVM API. KVM may select features that
the host supports and advertise them through the KVM_X86_XCOMP_GUEST_SUPP
attribute.

== Problem ==

QEMU [1] queries the features through the KVM API instead of using the x86
arch_prctl() option. But it still needs to use arch_prctl() to request the
permission. Then this step may become fragile because it does not guarantee
to comply with the KVM policy.

== Solution ==

Introduce a new attribute: KVM_X86_XCOMP_GUEST_PERM, and make it available
via the KVM_GET_DEVICE_ATTR and KVM_SET_DEVICE_ATTR APIs.

The implementation needs to use the established fpu_xstate_prctl()
extension for guest permissions. Export it via a new function
xstate_req_guest_perm() that KVM may use.

[1] https://gitlab.com/qemu-project/qemu/-/commit/19db68ca68a7
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Yang Zhong <yang.zhong@intel.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/include/asm/fpu/api.h  |  1 +
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kernel/fpu/xstate.c    |  6 ++++++
 arch/x86/kvm/x86.c              | 31 +++++++++++++++++++++++++++++++
 4 files changed, 39 insertions(+)

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index 503a577814b2..e4670d56b695 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -133,6 +133,7 @@ static inline void fpstate_free(struct fpu *fpu) { }
 extern void fpstate_clear_xstate_component(struct fpstate *fps, unsigned int xfeature);
 
 extern u64 xstate_get_guest_group_perm(void);
+extern int xstate_req_guest_perm(unsigned long idx);
 
 /* KVM specific functions */
 extern bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu);
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 46de10a809ec..6ab9a2b38061 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -461,6 +461,7 @@ struct kvm_sync_regs {
 
 /* attributes for system fd (group 0) */
 #define KVM_X86_XCOMP_GUEST_SUPP	0
+#define KVM_X86_XCOMP_GUEST_PERM	1
 
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index c8340156bfd2..ac365cb96304 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1687,6 +1687,12 @@ u64 xstate_get_guest_group_perm(void)
 }
 EXPORT_SYMBOL_GPL(xstate_get_guest_group_perm);
 
+int xstate_req_guest_perm(unsigned long idx)
+{
+	return xstate_request_perm(idx, true);
+}
+EXPORT_SYMBOL_GPL(xstate_req_guest_perm);
+
 /**
  * fpu_xstate_prctl - xstate permission operations
  * @tsk:	Redundant pointer to current
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 205ebdc2b11b..f4a1e94117d6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4514,12 +4514,34 @@ static int kvm_x86_dev_get_attr(struct kvm_device_attr *attr)
 		if (put_user(kvm_caps.supported_xcr0, uaddr))
 			return -EFAULT;
 		return 0;
+	case KVM_X86_XCOMP_GUEST_PERM: {
+		u64 permitted = xstate_get_guest_group_perm() & kvm_caps.supported_xcr0;
+
+		return put_user(permitted, uaddr);
+	}
 	default:
 		return -ENXIO;
 		break;
 	}
 }
 
+static int kvm_x86_dev_set_attr(struct kvm_device_attr *attr)
+{
+	unsigned long idx = (unsigned long) kvm_get_attr_addr(attr);
+
+	if (attr->group)
+		return -ENXIO;
+
+	switch (attr->attr) {
+	case KVM_X86_XCOMP_GUEST_PERM:
+		if (!((1ULL << idx) & kvm_caps.supported_xcr0))
+			return -EOPNOTSUPP;
+		return xstate_req_guest_perm(idx);
+	default:
+		return -ENXIO;
+	}
+}
+
 static int kvm_x86_dev_has_attr(struct kvm_device_attr *attr)
 {
 	if (attr->group)
@@ -4629,6 +4651,15 @@ long kvm_arch_dev_ioctl(struct file *filp,
 		r = kvm_x86_dev_get_attr(&attr);
 		break;
 	}
+	case KVM_SET_DEVICE_ATTR: {
+		struct kvm_device_attr attr;
+
+		r = -EFAULT;
+		if (copy_from_user(&attr, (void __user *)arg, sizeof(attr)))
+			break;
+		r = kvm_x86_dev_set_attr(&attr);
+		break;
+	}
 	case KVM_HAS_DEVICE_ATTR: {
 		struct kvm_device_attr attr;
 		r = -EFAULT;
-- 
2.17.1

