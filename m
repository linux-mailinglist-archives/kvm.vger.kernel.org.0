Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96BF27C0DA
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 11:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgI2JSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 05:18:10 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14710 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727836AbgI2JSK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 05:18:10 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A7ECDD523EC78719281F;
        Tue, 29 Sep 2020 17:18:07 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.174.187.69) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Tue, 29 Sep 2020 17:17:58 +0800
From:   Jingyi Wang <wangjingyi11@huawei.com>
To:     <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <will@kernel.org>, <catalin.marinas@arm.com>, <maz@kernel.org>,
        <james.morse@arm.com>, <julien.thierry.kdev@gmail.com>,
        <suzuki.poulose@arm.com>, <wanghaibin.wang@huawei.com>,
        <yezengruan@huawei.com>, <shameerali.kolothum.thodi@huawei.com>,
        <fanhenglong@huawei.com>, <wangjingyi11@huawei.com>,
        <prime.zeng@hisilicon.com>
Subject: [RFC PATCH 4/4] KVM: arm64: Add trace for TWED update
Date:   Tue, 29 Sep 2020 17:17:27 +0800
Message-ID: <20200929091727.8692-5-wangjingyi11@huawei.com>
X-Mailer: git-send-email 2.14.1.windows.1
In-Reply-To: <20200929091727.8692-1-wangjingyi11@huawei.com>
References: <20200929091727.8692-1-wangjingyi11@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.69]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zengruan Ye <yezengruan@huawei.com>

Add tracepoints for TWE delay value update

Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
---
 arch/arm64/kvm/arm.c       |  4 ++++
 arch/arm64/kvm/trace_arm.h | 21 +++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 989bffdcb3e9..c3d7a326bf1b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -80,6 +80,8 @@ void grow_twed(struct kvm_vcpu *vcpu)
 		vcpu->arch.twed += 1;
 		vcpu->arch.twed_dirty = true;
 	}
+
+	trace_kvm_twed_update(vcpu->vcpu_id, vcpu->arch.twed, old);
 }
 
 void shrink_twed(struct kvm_vcpu *vcpu)
@@ -90,6 +92,8 @@ void shrink_twed(struct kvm_vcpu *vcpu)
 		vcpu->arch.twed -= 1;
 		vcpu->arch.twed_dirty = true;
 	}
+
+	trace_kvm_twed_update(vcpu->vcpu_id, vcpu->arch.twed, old);
 }
 #endif
 
diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
index ff0444352bba..5081266399e8 100644
--- a/arch/arm64/kvm/trace_arm.h
+++ b/arch/arm64/kvm/trace_arm.h
@@ -367,6 +367,27 @@ TRACE_EVENT(kvm_timer_emulate,
 		  __entry->timer_idx, __entry->should_fire)
 );
 
+TRACE_EVENT(kvm_twed_update,
+	TP_PROTO(unsigned int vcpu_id, unsigned int new, unsigned int old),
+	TP_ARGS(vcpu_id, new, old),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	vcpu_id		)
+		__field(	unsigned int,	new		)
+		__field(	unsigned int,	old		)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id	= vcpu_id;
+		__entry->new		= new;
+		__entry->old		= old;
+	),
+
+	TP_printk("vcpu %u old %u new %u (%s)",
+		  __entry->vcpu_id, __entry->old, __entry->new,
+		  __entry->old < __entry->new ? "growed" : "shrinked")
+);
+
 #endif /* _TRACE_ARM_ARM64_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.19.1

