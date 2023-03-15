Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3D0F6BAD60
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 11:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbjCOKR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 06:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbjCOKRV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 06:17:21 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACF21514D;
        Wed, 15 Mar 2023 03:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678875416; x=1710411416;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VWNqHs9ua5Ie808babVZfwmYokVLpeUXUA0Ei2stTFA=;
  b=CH86WlRYfBxINL9xZGHRd0jDERjRCQ07vHRRwScVR5lv03MhTDyp5WOK
   A+y1Yt2ZhvM+4jsNyd1kSunjSn8BtrjYM22pRB02mh2tPos9JcRu9u44y
   jCG5Xn5DFoBH9A00vbFXZ3uHb/xzdVhTvMetTj+JQk0gr7JmI3bwCI5FP
   TgSGOjgbWcD5Xijp2fCu/sPc/k8TxDkdlmmrwiJEMD0jVv5hVAvmBL4VV
   lAfsiSFuA1NhKMAvCAlI78WM3B51ZutheiuoOA+GSl5VSzMJWgTQu0Tx4
   1IqpwcesRWebz3B+1+qm+XVAlbY92BwKiSV7A6bx8gKJHeZjvWYQiONE8
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="402534597"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="402534597"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 03:16:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="768440895"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="768440895"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Mar 2023 03:16:08 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH RESEND v2] KVM: move KVM_CAP_DEVICE_CTRL to the generic check
Date:   Wed, 15 Mar 2023 18:16:06 +0800
Message-Id: <20230315101606.10636-1-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
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

Link: https://lore.kernel.org/all/20221215115207.14784-1-wei.w.wang@intel.com
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/arm.c       | 1 -
 arch/powerpc/kvm/powerpc.c | 1 -
 arch/riscv/kvm/vm.c        | 1 -
 arch/s390/kvm/kvm-s390.c   | 1 -
 virt/kvm/kvm_main.c        | 1 +
 5 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3bd732eaf087..96329e675771 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -202,7 +202,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = vgic_present;
 		break;
 	case KVM_CAP_IOEVENTFD:
-	case KVM_CAP_DEVICE_CTRL:
 	case KVM_CAP_USER_MEMORY:
 	case KVM_CAP_SYNC_MMU:
 	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 4c5405fc5538..185efed23896 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -526,7 +526,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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
index 39b36562c043..7b097b5253ca 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -556,7 +556,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ENABLE_CAP:
 	case KVM_CAP_S390_CSS_SUPPORT:
 	case KVM_CAP_IOEVENTFD:
-	case KVM_CAP_DEVICE_CTRL:
 	case KVM_CAP_S390_IRQCHIP:
 	case KVM_CAP_VM_ATTRIBUTES:
 	case KVM_CAP_MP_STATE:
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d255964ec331..71cc63640173 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4523,6 +4523,7 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #endif
 	case KVM_CAP_BINARY_STATS_FD:
 	case KVM_CAP_SYSTEM_EVENT_DATA:
+	case KVM_CAP_DEVICE_CTRL:
 		return 1;
 	default:
 		break;
-- 
2.27.0

