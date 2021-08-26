Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFB23F8762
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 14:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234381AbhHZM1B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 08:27:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54198 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241003AbhHZM1B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 08:27:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629980773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S+Sat3y8UXxpfnh9XHhnKb0JrTjNlFz93a/rQHz2hnA=;
        b=EOBhHZShWa+BYcOkImcVpT6aB/Ctqnc3njxm8wgvsUd7ulxSpTvAzFQikzoiBHjew03rtE
        R5SwED6trYAKqN0O/HCLTKF2S9XVOe8a0kLiugmhR4//8x4FbV44/hKnc860AryVUOh49S
        PZyqFc1dGTxP1fKCC5j0RxAnI5ny18w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-QOCx3-xGPV2EIvDk0cMz8A-1; Thu, 26 Aug 2021 08:25:07 -0400
X-MC-Unique: QOCx3-xGPV2EIvDk0cMz8A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA3691008066;
        Thu, 26 Aug 2021 12:25:05 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 671E060936;
        Thu, 26 Aug 2021 12:25:00 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] KVM: Optimize kvm_make_vcpus_request_mask() a bit
Date:   Thu, 26 Aug 2021 14:24:41 +0200
Message-Id: <20210826122442.966977-4-vkuznets@redhat.com>
In-Reply-To: <20210826122442.966977-1-vkuznets@redhat.com>
References: <20210826122442.966977-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
index 2082aceffbf6..5d2b1f0fafaf 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -261,49 +261,64 @@ static inline bool kvm_kick_many_cpus(cpumask_var_t tmp, bool wait)
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
+	 * tmp can be "unavailable" if cpumasks are allocated off stack as
+	 * allocation of the mask is deliberately not fatal and is handled by
+	 * falling back to kicking all online CPUs.
+	 */
+	if (!cpumask_available(tmp))
+		return;
+
+	/*
+	 * Note, the vCPU could get migrated to a different pCPU at any point
+	 * after kvm_request_needs_ipi(), which could result in sending an IPI
+	 * to the previous pCPU.  But, that's OK because the purpose of the IPI
+	 * is to ensure the vCPU returns to OUTSIDE_GUEST_MODE, which is
+	 * satisfied if the vCPU migrates. Entering READING_SHADOW_PAGE_TABLES
+	 * after this point is also OK, as the requirement is only that KVM wait
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
-		 * tmp can be "unavailable" if cpumasks are allocated off stack
-		 * as allocation of the mask is deliberately not fatal and is
-		 * handled by falling back to kicking all online CPUs.
-		 */
-		if (!cpumask_available(tmp))
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

