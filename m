Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2993EC66A
	for <lists+kvm@lfdr.de>; Sun, 15 Aug 2021 03:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234718AbhHOBC1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Aug 2021 21:02:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59599 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235029AbhHOBCZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 14 Aug 2021 21:02:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628989315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hlWUwlGTC2lhBeDebVH1FbB0VMD3cF14uis9/f5ucXg=;
        b=EFeqoZDbCdLdACJQVGGU7KAvKFLfz4CWsWepFZOFGxdp/bC4yjdpr4I72sLmjNdsn9LgYr
        xogiurYDmRi60GAh+KJJtB+NLShzHlohSi5PUzOhxUf+QIbf3uJX9HJVnF82ba0KWMd4AG
        lnhCGpn9xLzgq05WkDIRwKpzVA0HVgE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-CTRJxKqWOgeshU6mec4SQA-1; Sat, 14 Aug 2021 21:01:54 -0400
X-MC-Unique: CTRJxKqWOgeshU6mec4SQA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 165DD1082921;
        Sun, 15 Aug 2021 01:01:53 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-103.bne.redhat.com [10.64.54.103])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2DF516091B;
        Sun, 15 Aug 2021 01:01:44 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        james.morse@arm.com, mark.rutland@arm.com,
        Jonathan.Cameron@huawei.com, will@kernel.org, maz@kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, shan.gavin@gmail.com
Subject: [PATCH v4 03/15] KVM: async_pf: Make GFN slot management generic
Date:   Sun, 15 Aug 2021 08:59:35 +0800
Message-Id: <20210815005947.83699-4-gshan@redhat.com>
In-Reply-To: <20210815005947.83699-1-gshan@redhat.com>
References: <20210815005947.83699-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's not allowed to fire duplicate notification for same GFN on
x86 platform, with help of a hash table. This mechanism is going
to be used by arm64 and this makes the code generic and shareable
by multiple platforms.

   * As this mechanism isn't needed by all platforms, a new kernel
     config option (CONFIG_ASYNC_PF_SLOT) is introduced so that it
     can be disabled at compiling time.

   * The code is basically copied from x86 platform and the functions
     are renamed to reflect the fact: (a) the input parameters are
     vCPU and GFN. (b) The operations are resetting, searching, adding
     and removing.

   * Helper stub is also added on !CONFIG_KVM_ASYNC_PF because we're
     going to use IS_ENABLED() instead of #ifdef on arm64 when the
     asynchronous page fault is supported.

This is preparatory work to use the newly introduced functions on x86
platform and arm64 in subsequent patches.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 include/linux/kvm_host.h | 18 +++++++++
 virt/kvm/Kconfig         |  3 ++
 virt/kvm/async_pf.c      | 85 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 106 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a5f990f6dc35..a9685c2b2250 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -298,6 +298,9 @@ struct kvm_vcpu {
 
 #ifdef CONFIG_KVM_ASYNC_PF
 	struct {
+#ifdef CONFIG_KVM_ASYNC_PF_SLOT
+		gfn_t gfns[ASYNC_PF_PER_VCPU];
+#endif
 		u32 queued;
 		struct list_head queue;
 		struct list_head done;
@@ -339,6 +342,13 @@ struct kvm_async_pf {
 	bool				notpresent_injected;
 };
 
+#ifdef CONFIG_KVM_ASYNC_PF_SLOT
+void kvm_async_pf_reset_slot(struct kvm_vcpu *vcpu);
+void kvm_async_pf_add_slot(struct kvm_vcpu *vcpu, gfn_t gfn);
+void kvm_async_pf_remove_slot(struct kvm_vcpu *vcpu, gfn_t gfn);
+bool kvm_async_pf_find_slot(struct kvm_vcpu *vcpu, gfn_t gfn);
+#endif
+
 static inline bool kvm_check_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 {
 	return !list_empty_careful(&vcpu->async_pf.done);
@@ -350,6 +360,14 @@ bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			unsigned long hva, struct kvm_arch_async_pf *arch);
 int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #else
+static inline void kvm_async_pf_reset_slot(struct kvm_vcpu *vcpu) { }
+static inline void kvm_async_pf_add_slot(struct kvm_vcpu *vcpu, gfn_t gfn) { }
+static inline void kvm_async_pf_remove_slot(struct kvm_vcpu *vcpu, gfn_t gfn) { }
+static inline bool kvm_async_pf_find_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	return false;
+}
+
 static inline bool kvm_check_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 {
 	return false;
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 62b39149b8c8..59b518c8c205 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -23,6 +23,9 @@ config KVM_MMIO
 config KVM_ASYNC_PF
        bool
 
+config KVM_ASYNC_PF_SLOT
+	bool
+
 # Toggle to switch between direct notification and batch job
 config KVM_ASYNC_PF_SYNC
        bool
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index d145a61a046a..0d1fdb2932af 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -13,12 +13,97 @@
 #include <linux/module.h>
 #include <linux/mmu_context.h>
 #include <linux/sched/mm.h>
+#ifdef CONFIG_KVM_ASYNC_PF_SLOT
+#include <linux/hash.h>
+#endif
 
 #include "async_pf.h"
 #include <trace/events/kvm.h>
 
 static struct kmem_cache *async_pf_cache;
 
+#ifdef CONFIG_KVM_ASYNC_PF_SLOT
+static inline u32 kvm_async_pf_hash(gfn_t gfn)
+{
+	BUILD_BUG_ON(!is_power_of_2(ASYNC_PF_PER_VCPU));
+
+	return hash_32(gfn & 0xffffffff, order_base_2(ASYNC_PF_PER_VCPU));
+}
+
+static inline u32 kvm_async_pf_next_slot(u32 key)
+{
+	return (key + 1) & (ASYNC_PF_PER_VCPU - 1);
+}
+
+static u32 kvm_async_pf_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	u32 key = kvm_async_pf_hash(gfn);
+	int i;
+
+	for (i = 0; i < ASYNC_PF_PER_VCPU &&
+		(vcpu->async_pf.gfns[key] != gfn &&
+		vcpu->async_pf.gfns[key] != ~0); i++)
+		key = kvm_async_pf_next_slot(key);
+
+	return key;
+}
+
+void kvm_async_pf_reset_slot(struct kvm_vcpu *vcpu)
+{
+	int i;
+
+	for (i = 0; i < ASYNC_PF_PER_VCPU; i++)
+		vcpu->async_pf.gfns[i] = ~0;
+}
+
+void kvm_async_pf_add_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	u32 key = kvm_async_pf_hash(gfn);
+
+	while (vcpu->async_pf.gfns[key] != ~0)
+		key = kvm_async_pf_next_slot(key);
+
+	vcpu->async_pf.gfns[key] = gfn;
+}
+
+void kvm_async_pf_remove_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	u32 i, j, k;
+
+	i = j = kvm_async_pf_slot(vcpu, gfn);
+
+	if (WARN_ON_ONCE(vcpu->async_pf.gfns[i] != gfn))
+		return;
+
+	while (true) {
+		vcpu->async_pf.gfns[i] = ~0;
+
+		do {
+			j = kvm_async_pf_next_slot(j);
+			if (vcpu->async_pf.gfns[j] == ~0)
+				return;
+
+			k = kvm_async_pf_hash(vcpu->async_pf.gfns[j]);
+			/*
+			 * k lies cyclically in ]i,j]
+			 * |    i.k.j |
+			 * |....j i.k.| or  |.k..j i...|
+			 */
+		} while ((i <= j) ? (i < k && k <= j) : (i < k || k <= j));
+
+		vcpu->async_pf.gfns[i] = vcpu->async_pf.gfns[j];
+		i = j;
+	}
+}
+
+bool kvm_async_pf_find_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	u32 key = kvm_async_pf_slot(vcpu, gfn);
+
+	return vcpu->async_pf.gfns[key] == gfn;
+}
+#endif /* CONFIG_KVM_ASYNC_PF_SLOT */
+
 int kvm_async_pf_init(void)
 {
 	async_pf_cache = KMEM_CACHE(kvm_async_pf, 0);
-- 
2.23.0

