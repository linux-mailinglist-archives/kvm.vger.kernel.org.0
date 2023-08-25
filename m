Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6595D7883F1
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 11:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244332AbjHYJhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 05:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244463AbjHYJh3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 05:37:29 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5501E1FD5
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 02:37:18 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RXFFm2sJ8z67n5j;
        Fri, 25 Aug 2023 17:36:28 +0800 (CST)
Received: from A2006125610.china.huawei.com (10.202.227.178) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Fri, 25 Aug 2023 10:37:09 +0100
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <maz@kernel.org>,
        <will@kernel.org>, <catalin.marinas@arm.com>,
        <oliver.upton@linux.dev>
CC:     <james.morse@arm.com>, <suzuki.poulose@arm.com>,
        <yuzenghui@huawei.com>, <zhukeqian1@huawei.com>,
        <jonathan.cameron@huawei.com>, <linuxarm@huawei.com>
Subject: [RFC PATCH v2 7/8] KVM: arm64: Add KVM_CAP_ARM_HW_DBM
Date:   Fri, 25 Aug 2023 10:35:27 +0100
Message-ID: <20230825093528.1637-8-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.202.227.178]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a capability for userspace to enable hardware DBM support
for live migration.

ToDo: Update documentation.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/arm.c              | 13 +++++++++++++
 include/uapi/linux/kvm.h          |  1 +
 3 files changed, 16 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f623b989ddd1..17ac53150a1d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -175,6 +175,8 @@ struct kvm_s2_mmu {
 	struct kvm_mmu_memory_cache split_page_cache;
 	uint64_t split_page_chunk_size;
 
+	bool hwdbm_enabled;  /* KVM_CAP_ARM_HW_DBM enabled */
+
 	struct kvm_arch *arch;
 };
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fd2af63d788d..0dbf2cda40d7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -115,6 +115,16 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->slots_lock);
 		break;
+	case KVM_CAP_ARM_HW_DBM:
+		mutex_lock(&kvm->slots_lock);
+		if (!system_supports_hw_dbm()) {
+			r = -EINVAL;
+		} else {
+			r = 0;
+			kvm->arch.mmu.hwdbm_enabled = true;
+		}
+		mutex_unlock(&kvm->slots_lock);
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -316,6 +326,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES:
 		r = kvm_supported_block_sizes();
 		break;
+	case KVM_CAP_ARM_HW_DBM:
+		r = system_supports_hw_dbm();
+		break;
 	default:
 		r = 0;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f089ab290978..99bd5c0420ba 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1192,6 +1192,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_COUNTER_OFFSET 227
 #define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 228
 #define KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES 229
+#define KVM_CAP_ARM_HW_DBM 230
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.34.1

