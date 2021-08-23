Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38673F4C5C
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 16:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhHWObb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 10:31:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59267 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230177AbhHWOba (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 10:31:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629729047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wq3GtJnJ0UcnS9tRpeI+vww4phaIYcteU9bLlmRBJQw=;
        b=EpoMxETy+QrxL5qU/thIJ+phgmfr5g4K+d94k6vaj2i/7FTClOtYSr+JOGVAtRy0jhvIc/
        MdKwpkRRtBVX4dPQhBQWOX8YHkDwfXjhZozpB6+5eRAzT5mqt7CPavvn89i+OFvmh+J9LC
        Du9AZ2mu+Z5o+wiWtpS/iONxrbjzqS0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503--guwZZ_nMUOC-VfR-27R4Q-1; Mon, 23 Aug 2021 10:30:45 -0400
X-MC-Unique: -guwZZ_nMUOC-VfR-27R4Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D7DF87D545;
        Mon, 23 Aug 2021 14:30:44 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E31A99BD;
        Mon, 23 Aug 2021 14:30:42 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] KVM: Optimize kvm_make_vcpus_request_mask() a bit
Date:   Mon, 23 Aug 2021 16:30:27 +0200
Message-Id: <20210823143028.649818-4-vkuznets@redhat.com>
In-Reply-To: <20210823143028.649818-1-vkuznets@redhat.com>
References: <20210823143028.649818-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Iterating over set bits in 'vcpu_bitmap' should be faster than going
through all vCPUs, especially when just a few bits are set.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 virt/kvm/kvm_main.c | 83 ++++++++++++++++++++++++++-------------------
 1 file changed, 49 insertions(+), 34 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 82c5280dd5ce..e9c2ce2d273f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -257,49 +257,64 @@ static inline bool kvm_kick_many_cpus(const struct cpumask *cpus, bool wait)
 	return true;
 }
 
+static void kvm_make_vcpu_request(struct kvm *kvm, struct kvm_vcpu *vcpu,
+				  unsigned int req, cpumask_var_t tmp,
+				  int current_cpu)
+{
+	int cpu = vcpu->cpu;
+
+	kvm_make_request(req, vcpu);
+
+	if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
+		return;
+
+	/*
+	 * tmp can be NULL if cpumasks are allocated off stack, as allocation of
+	 * the mask is deliberately not fatal and is handled by falling back to
+	 * kicking all online CPUs.
+	 */
+	if (IS_ENABLED(CONFIG_CPUMASK_OFFSTACK) && !tmp)
+		return;
+
+	/*
+	 * Note, the vCPU could get migrated to a different pCPU at any point
+	 * after kvm_request_needs_ipi(), which could result in sending an IPI
+	 * to the previous pCPU.  But, that's ok because the purpose of the IPI
+	 * is to ensure the vCPU returns to OUTSIDE_GUEST_MODE, which is
+	 * satisfied if the vCPU migrates. Entering READING_SHADOW_PAGE_TABLES
+	 * after this point is also ok, as the requirement is only that KVM wait
+	 * for vCPUs that were reading SPTEs _before_ any changes were
+	 * finalized. See kvm_vcpu_kick() for more details on handling requests.
+	 */
+	if (kvm_request_needs_ipi(vcpu, req)) {
+		cpu = READ_ONCE(vcpu->cpu);
+		if (cpu != -1 && cpu != current_cpu)
+			__cpumask_set_cpu(cpu, tmp);
+	}
+}
+
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 				 struct kvm_vcpu *except,
 				 unsigned long *vcpu_bitmap, cpumask_var_t tmp)
 {
-	int i, cpu, me;
+	int i, me;
 	struct kvm_vcpu *vcpu;
 	bool called;
 
 	me = get_cpu();
 
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if ((vcpu_bitmap && !test_bit(i, vcpu_bitmap)) ||
-		    vcpu == except)
-			continue;
-
-		kvm_make_request(req, vcpu);
-
-		if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
-			continue;
-
-		/*
-		 * tmp can be NULL if cpumasks are allocated off stack, as
-		 * allocation of the mask is deliberately not fatal and is
-		 * handled by falling back to kicking all online CPUs.
-		 */
-		if (IS_ENABLED(CONFIG_CPUMASK_OFFSTACK) && !tmp)
-			continue;
-
-		/*
-		 * Note, the vCPU could get migrated to a different pCPU at any
-		 * point after kvm_request_needs_ipi(), which could result in
-		 * sending an IPI to the previous pCPU.  But, that's ok because
-		 * the purpose of the IPI is to ensure the vCPU returns to
-		 * OUTSIDE_GUEST_MODE, which is satisfied if the vCPU migrates.
-		 * Entering READING_SHADOW_PAGE_TABLES after this point is also
-		 * ok, as the requirement is only that KVM wait for vCPUs that
-		 * were reading SPTEs _before_ any changes were finalized.  See
-		 * kvm_vcpu_kick() for more details on handling requests.
-		 */
-		if (kvm_request_needs_ipi(vcpu, req)) {
-			cpu = READ_ONCE(vcpu->cpu);
-			if (cpu != -1 && cpu != me)
-				__cpumask_set_cpu(cpu, tmp);
+	if (vcpu_bitmap) {
+		for_each_set_bit(i, vcpu_bitmap, KVM_MAX_VCPUS) {
+			vcpu = kvm_get_vcpu(kvm, i);
+			if (!vcpu || vcpu == except)
+				continue;
+			kvm_make_vcpu_request(kvm, vcpu, req, tmp, me);
+		}
+	} else {
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			if (vcpu == except)
+				continue;
+			kvm_make_vcpu_request(kvm, vcpu, req, tmp, me);
 		}
 	}
 
-- 
2.31.1

