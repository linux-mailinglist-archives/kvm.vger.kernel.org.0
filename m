Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6170C3A9692
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 11:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbhFPJy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 05:54:58 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4948 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232328AbhFPJyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Jun 2021 05:54:54 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G4gQ91274z70PJ;
        Wed, 16 Jun 2021 17:49:37 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 17:52:46 +0800
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 17:52:45 +0800
From:   Yanan Wang <wangyanan55@huawei.com>
To:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        "Quentin Perret" <qperret@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Gavin Shan <gshan@redhat.com>, <wanghaibin.wang@huawei.com>,
        <zhukeqian1@huawei.com>, <yuzenghui@huawei.com>,
        Yanan Wang <wangyanan55@huawei.com>
Subject: [PATCH v6 1/4] KVM: arm64: Introduce cache maintenance callbacks for guest stage-2
Date:   Wed, 16 Jun 2021 17:51:57 +0800
Message-ID: <20210616095200.38008-2-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210616095200.38008-1-wangyanan55@huawei.com>
References: <20210616095200.38008-1-wangyanan55@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To prepare for performing guest CMOs in the fault handlers in pgtable.c,
introduce two cache maintenance callbacks in struct kvm_pgtable_mm_ops.

The new callbacks are specific for guest stage-2, so they will only be
initialized in 'struct kvm_pgtable_mm_ops kvm_s2_mm_ops'.

Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index c3674c47d48c..302eca32e0af 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -44,6 +44,11 @@ typedef u64 kvm_pte_t;
  *			in the current context.
  * @virt_to_phys:	Convert a virtual address mapped in the current context
  *			into a physical address.
+ * @flush_dcache:	Clean data cache for a guest page address range before
+ *			creating the corresponding stage-2 mapping.
+ * @flush_icache:	Invalidate instruction cache for a guest page address
+ *			range before creating or updating the corresponding
+ *			stage-2 mapping.
  */
 struct kvm_pgtable_mm_ops {
 	void*		(*zalloc_page)(void *arg);
@@ -54,6 +59,8 @@ struct kvm_pgtable_mm_ops {
 	int		(*page_count)(void *addr);
 	void*		(*phys_to_virt)(phys_addr_t phys);
 	phys_addr_t	(*virt_to_phys)(void *addr);
+	void		(*flush_dcache)(void *addr, size_t size);
+	void		(*flush_icache)(void *addr, size_t size);
 };
 
 /**
-- 
2.23.0

