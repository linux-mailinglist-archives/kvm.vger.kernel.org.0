Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B4723BEA0
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 19:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgHDRI4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 13:08:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47585 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729385AbgHDRIY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 13:08:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596560903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GjMHtQhvL1sbv3OPrIuLEgVyBCdc7KqG2tb49HDjHOA=;
        b=NpoAaq2Z+il/dIzDSPy2WX1NvaeUckkw/oQPWixaZGWOv3u4YUezUl9hwx48PBCTc7oewo
        YBy2BbHGP4QEdI2dTQVG8eWONhNvf6SQZXvjq5zfGaKRKNYG2m7Yc8k0OOAyt/1IyblMQj
        iWCS2yw1VwjGpAkogan/vXAeKraXuKU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-ATI4eqrrMpC36i-UE3qJeQ-1; Tue, 04 Aug 2020 13:06:17 -0400
X-MC-Unique: ATI4eqrrMpC36i-UE3qJeQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9C9518C63C1;
        Tue,  4 Aug 2020 17:06:15 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2817188D68;
        Tue,  4 Aug 2020 17:06:13 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, steven.price@arm.com, pbonzini@redhat.com
Subject: [PATCH v2 4/6] KVM: arm64: pvtime: Fix stolen time accounting across migration
Date:   Tue,  4 Aug 2020 19:06:02 +0200
Message-Id: <20200804170604.42662-5-drjones@redhat.com>
In-Reply-To: <20200804170604.42662-1-drjones@redhat.com>
References: <20200804170604.42662-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When updating the stolen time we should always read the current
stolen time from the user provided memory, not from a kernel
cache. If we use a cache then we'll end up resetting stolen time
to zero on the first update after migration.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 -
 arch/arm64/kvm/pvtime.c           | 23 +++++++++--------------
 include/linux/kvm_host.h          | 20 ++++++++++++++++++++
 3 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e21d4a01372f..1b65dfeb6fed 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -343,7 +343,6 @@ struct kvm_vcpu_arch {
 
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
index cf51b06a5edd..3ed6697763f7 100644
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
2.25.4

