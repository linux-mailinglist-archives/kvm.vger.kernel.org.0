Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5AC25D6D0
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 12:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730105AbgIDKss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 06:48:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729751AbgIDKqE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 06:46:04 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7291208B3;
        Fri,  4 Sep 2020 10:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599216364;
        bh=hmTzNCRw9Bnl08lfTQaej6KTlWoJiiEpQDkEk/c0Aks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dGtTdZ/9CM6hJODWnwcEqiJArtoqasldXiXtf/KhBCObWCtKIaelb3FVWAnyqq/Kz
         e37h4QTJzk6nFQlrj4WjKYd7t4JtRHCV5g7gh5RUfhT+3y51mudhEcuH0gkwomC5lB
         ywzTlIhDlD8/2a6zMXOW+K99rzOdVDNfLeGpGQ+A=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kE9EI-0098oH-Bg; Fri, 04 Sep 2020 11:46:02 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Steven Price <steven.price@arm.com>, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 4/9] KVM: arm64: pvtime: Fix stolen time accounting across migration
Date:   Fri,  4 Sep 2020 11:45:25 +0100
Message-Id: <20200904104530.1082676-5-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200904104530.1082676-1-maz@kernel.org>
References: <20200904104530.1082676-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, drjones@redhat.com, eric.auger@redhat.com, gshan@redhat.com, steven.price@arm.com, kernel-team@android.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andrew Jones <drjones@redhat.com>

When updating the stolen time we should always read the current
stolen time from the user provided memory, not from a kernel
cache. If we use a cache then we'll end up resetting stolen time
to zero on the first update after migration.

Signed-off-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200804170604.42662-5-drjones@redhat.com
---
 arch/arm64/include/asm/kvm_host.h |  1 -
 arch/arm64/kvm/pvtime.c           | 23 +++++++++--------------
 include/linux/kvm_host.h          | 20 ++++++++++++++++++++
 3 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 65568b23868a..dd9c3b25aa1e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -368,7 +368,6 @@ struct kvm_vcpu_arch {
 
 	/* Guest PV state */
 	struct {
-		u64 steal;
 		u64 last_steal;
 		gpa_t base;
 	} steal;
diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index 241ded7ee0ad..75234321d896 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -13,26 +13,22 @@
 void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
+	u64 base = vcpu->arch.steal.base;
 	u64 last_steal = vcpu->arch.steal.last_steal;
-	u64 steal;
-	__le64 steal_le;
-	u64 offset;
+	u64 offset = offsetof(struct pvclock_vcpu_stolen_time, stolen_time);
+	u64 steal = 0;
 	int idx;
-	u64 base = vcpu->arch.steal.base;
 
 	if (base == GPA_INVALID)
 		return;
 
-	/* Let's do the local bookkeeping */
-	steal = vcpu->arch.steal.steal;
-	vcpu->arch.steal.last_steal = READ_ONCE(current->sched_info.run_delay);
-	steal += vcpu->arch.steal.last_steal - last_steal;
-	vcpu->arch.steal.steal = steal;
-
-	steal_le = cpu_to_le64(steal);
 	idx = srcu_read_lock(&kvm->srcu);
-	offset = offsetof(struct pvclock_vcpu_stolen_time, stolen_time);
-	kvm_put_guest(kvm, base + offset, steal_le);
+	if (!kvm_get_guest(kvm, base + offset, steal)) {
+		steal = le64_to_cpu(steal);
+		vcpu->arch.steal.last_steal = READ_ONCE(current->sched_info.run_delay);
+		steal += vcpu->arch.steal.last_steal - last_steal;
+		kvm_put_guest(kvm, base + offset, cpu_to_le64(steal));
+	}
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
@@ -66,7 +62,6 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
 	 * Start counting stolen time from the time the guest requests
 	 * the feature enabled.
 	 */
-	vcpu->arch.steal.steal = 0;
 	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
 
 	idx = srcu_read_lock(&kvm->srcu);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 84371fb06209..05e3c2fb3ef7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -749,6 +749,26 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 			      gpa_t gpa, unsigned long len);
 
+#define __kvm_get_guest(kvm, gfn, offset, v)				\
+({									\
+	unsigned long __addr = gfn_to_hva(kvm, gfn);			\
+	typeof(v) __user *__uaddr = (typeof(__uaddr))(__addr + offset);	\
+	int __ret = -EFAULT;						\
+									\
+	if (!kvm_is_error_hva(__addr))					\
+		__ret = get_user(v, __uaddr);				\
+	__ret;								\
+})
+
+#define kvm_get_guest(kvm, gpa, v)					\
+({									\
+	gpa_t __gpa = gpa;						\
+	struct kvm *__kvm = kvm;					\
+									\
+	__kvm_get_guest(__kvm, __gpa >> PAGE_SHIFT,			\
+			offset_in_page(__gpa), v);			\
+})
+
 #define __kvm_put_guest(kvm, gfn, offset, v)				\
 ({									\
 	unsigned long __addr = gfn_to_hva(kvm, gfn);			\
-- 
2.27.0

