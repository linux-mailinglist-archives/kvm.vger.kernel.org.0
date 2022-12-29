Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452F0658CB9
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 13:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbiL2MeJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 07:34:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbiL2MeF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 07:34:05 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E23313DD4;
        Thu, 29 Dec 2022 04:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672317226; x=1703853226;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zHreUtqmKvOEGxfPmwFyAvdSxxzgj/SeSN1QmXbCurY=;
  b=kZLTBsk2Qi0hYJvbUKDC9pkUDY+5f+V2IeQbuPDFRp2bS4tKvjSqAFa8
   /6BsSgkW//kneHdQebAJ6gY0oGtHrby+nTATDl1AhJ96uXfrM/tNRlxBL
   0LNi0RYV8Q/BHD8gq1b7hLRLrPKA2sCAAtzZJtdxtMB9Q8EM5rnli/aIp
   oF34sRZfNghBnric+yZHTv70/IuJecUnV4g17RQVBv7WnCc5CPedo4Mrb
   /VgkTeiD7YXsPy0Eyp8JVH1OF3mdoxywdudtfpT+IOJrC8Gokdfg6B8E0
   hvGapkDG1p0KEN6tc+raKxpkpXswbWfRCIKKG6ctOxvP5BYMPuUludij4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10574"; a="300720474"
X-IronPort-AV: E=Sophos;i="5.96,284,1665471600"; 
   d="scan'208";a="300720474"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2022 04:33:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10574"; a="684195741"
X-IronPort-AV: E=Sophos;i="5.96,284,1665471600"; 
   d="scan'208";a="684195741"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by orsmga008.jf.intel.com with ESMTP; 29 Dec 2022 04:33:43 -0800
From:   Wei Wang <wei.w.wang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v2] KVM: move KVM_CAP_DEVICE_CTRL to the generic check
Date:   Thu, 29 Dec 2022 20:33:38 +0800
Message-Id: <20221229123338.4142-1-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_CAP_DEVICE_CTRL allows userspace to check if the kvm_device
framework (e.g. KVM_CREATE_DEVICE) is supported by KVM. Move
KVM_CAP_DEVICE_CTRL to the generic check for the two reasons:
1) it already supports arch agnostic usages (i.e. KVM_DEV_TYPE_VFIO).
For example, userspace VFIO implementation may needs to create
KVM_DEV_TYPE_VFIO on x86, riscv, or arm etc. It is simpler to have it
checked at the generic code than at each arch's code.
2) KVM_CREATE_DEVICE has been added to the generic code.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 arch/arm64/kvm/arm.c       | 1 -
 arch/powerpc/kvm/powerpc.c | 1 -
 arch/riscv/kvm/vm.c        | 1 -
 arch/s390/kvm/kvm-s390.c   | 1 -
 virt/kvm/kvm_main.c        | 1 +
 5 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9c5573bc4614..190e9c3b10a7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -212,7 +212,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = vgic_present;
 		break;
 	case KVM_CAP_IOEVENTFD:
-	case KVM_CAP_DEVICE_CTRL:
 	case KVM_CAP_USER_MEMORY:
 	case KVM_CAP_SYNC_MMU:
 	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 04494a4fb37a..21f9fbe96f6a 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -541,7 +541,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ENABLE_CAP:
 	case KVM_CAP_ONE_REG:
 	case KVM_CAP_IOEVENTFD:
-	case KVM_CAP_DEVICE_CTRL:
 	case KVM_CAP_IMMEDIATE_EXIT:
 	case KVM_CAP_SET_GUEST_DEBUG:
 		r = 1;
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index 65a964d7e70d..6efe93b282e1 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -57,7 +57,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 
 	switch (ext) {
 	case KVM_CAP_IOEVENTFD:
-	case KVM_CAP_DEVICE_CTRL:
 	case KVM_CAP_USER_MEMORY:
 	case KVM_CAP_SYNC_MMU:
 	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index e4890e04b210..191d220b6a30 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -567,7 +567,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ENABLE_CAP:
 	case KVM_CAP_S390_CSS_SUPPORT:
 	case KVM_CAP_IOEVENTFD:
-	case KVM_CAP_DEVICE_CTRL:
 	case KVM_CAP_S390_IRQCHIP:
 	case KVM_CAP_VM_ATTRIBUTES:
 	case KVM_CAP_MP_STATE:
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 582757ebdce6..84073464aea0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4524,6 +4524,7 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #endif
 	case KVM_CAP_BINARY_STATS_FD:
 	case KVM_CAP_SYSTEM_EVENT_DATA:
+	case KVM_CAP_DEVICE_CTRL:
 		return 1;
 	default:
 		break;
-- 
2.27.0

