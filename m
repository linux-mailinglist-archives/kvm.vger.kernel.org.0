Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01DC3F96E0
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 11:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244721AbhH0J0e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 05:26:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48957 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244751AbhH0J0a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 05:26:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630056342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Tiw01wWN6JRDSyw0sf82RYPDuQBRq4dxgbJdxcHI68=;
        b=HV2p8zaH/PwTVFGhfDAvG6JqbckFU14JccIhSocJRoIRVsvvwDDLTOjJ1/kAm7n4kkMSDA
        ZyvPv8Tt4+KJRr686pQkcoJrtqTctHS7UmiJ6+4pdE/LcjAhEVMiTonmWDweUSfOU5pt+N
        pTalnXiF+vOToGPoElB5WNXCDYoTaKQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-dH47_44oOECsbxz_tHHLUg-1; Fri, 27 Aug 2021 05:25:38 -0400
X-MC-Unique: dH47_44oOECsbxz_tHHLUg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74C4F18C8C05;
        Fri, 27 Aug 2021 09:25:37 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E0A760CC6;
        Fri, 27 Aug 2021 09:25:34 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/8] KVM: Optimize kvm_make_vcpus_request_mask() a bit
Date:   Fri, 27 Aug 2021 11:25:12 +0200
Message-Id: <20210827092516.1027264-5-vkuznets@redhat.com>
In-Reply-To: <20210827092516.1027264-1-vkuznets@redhat.com>
References: <20210827092516.1027264-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Iterating over set bits in 'vcpu_bitmap' should be faster than going
through all vCPUs, especially when just a few bits are set.

Drop kvm_make_vcpus_request_mask() call from kvm_make_all_cpus_request_except()
to avoid handling the special case when 'vcpu_bitmap' is NULL, move the
code to kvm_make_all_cpus_request_except() itself.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 virt/kvm/kvm_main.c | 88 +++++++++++++++++++++++++++------------------
 1 file changed, 53 insertions(+), 35 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2082aceffbf6..e32ba210025f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -261,50 +261,57 @@ static inline bool kvm_kick_many_cpus(cpumask_var_t tmp, bool wait)
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
 	struct kvm_vcpu *vcpu;
+	int i, me;
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
+	for_each_set_bit(i, vcpu_bitmap, KVM_MAX_VCPUS) {
+		vcpu = kvm_get_vcpu(kvm, i);
+		if (!vcpu || vcpu == except)
 			continue;
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
-		}
+		kvm_make_vcpu_request(kvm, vcpu, req, tmp, me);
 	}
 
 	called = kvm_kick_many_cpus(tmp, !!(req & KVM_REQUEST_WAIT));
@@ -316,12 +323,23 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
 				      struct kvm_vcpu *except)
 {
+	struct kvm_vcpu *vcpu;
 	cpumask_var_t cpus;
 	bool called;
+	int i, me;
 
 	zalloc_cpumask_var(&cpus, GFP_ATOMIC);
 
-	called = kvm_make_vcpus_request_mask(kvm, req, except, NULL, cpus);
+	me = get_cpu();
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (vcpu == except)
+			continue;
+		kvm_make_vcpu_request(kvm, vcpu, req, cpus, me);
+	}
+
+	called = kvm_kick_many_cpus(cpus, !!(req & KVM_REQUEST_WAIT));
+	put_cpu();
 
 	free_cpumask_var(cpus);
 	return called;
-- 
2.31.1

