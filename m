Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10293F2C62
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 14:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240553AbhHTMoq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 08:44:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32057 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240373AbhHTMoo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Aug 2021 08:44:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629463446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Tv5qi40eLMbo4zSMM9UWSwuDMOHZ6NnJZ4bVmrBwXiE=;
        b=Z0o7gi2jlGiE0an+JjwGxA51BjJTZnOfNsLxP0WjivYGtwyNRYq4/PxQMl7YAc8Kcnkirw
        AP0uHYyQWoMKTdnr+nzbQNcx/gdoN0yTOiteOoj+KC9ntrOgzbzXBXHRS23sd7vWZNvADX
        YuR/afYRnHzm0YhgoMxdsqW+ZZ/bumc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-HYzNmTkGM_efCnKX-f_XAA-1; Fri, 20 Aug 2021 08:44:03 -0400
X-MC-Unique: HYzNmTkGM_efCnKX-f_XAA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEEF4875054;
        Fri, 20 Aug 2021 12:44:01 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B5DD15C25D;
        Fri, 20 Aug 2021 12:43:55 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: Optimize kvm_make_vcpus_request_mask() a bit
Date:   Fri, 20 Aug 2021 14:43:53 +0200
Message-Id: <20210820124354.582222-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Iterating over set bits in 'vcpu_bitmap' should be faster than going
through all vCPUs, especially when just a few bits are set.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 virt/kvm/kvm_main.c | 49 +++++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3e67c93ca403..0f873c5ed538 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -257,34 +257,49 @@ static inline bool kvm_kick_many_cpus(const struct cpumask *cpus, bool wait)
 	return true;
 }
 
+static void kvm_make_vcpu_request(struct kvm *kvm, struct kvm_vcpu *vcpu,
+				  unsigned int req, cpumask_var_t tmp)
+{
+	int cpu = vcpu->cpu;
+
+	kvm_make_request(req, vcpu);
+
+	if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
+		return;
+
+	if (tmp != NULL && cpu != -1 && cpu != raw_smp_processor_id() &&
+	    kvm_request_needs_ipi(vcpu, req))
+		__cpumask_set_cpu(cpu, tmp);
+}
+
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 				 struct kvm_vcpu *except,
 				 unsigned long *vcpu_bitmap, cpumask_var_t tmp)
 {
-	int i, cpu, me;
+	int i;
 	struct kvm_vcpu *vcpu;
 	bool called;
 
-	me = get_cpu();
-
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if ((vcpu_bitmap && !test_bit(i, vcpu_bitmap)) ||
-		    vcpu == except)
-			continue;
-
-		kvm_make_request(req, vcpu);
-		cpu = vcpu->cpu;
-
-		if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
-			continue;
+	preempt_disable();
 
-		if (tmp != NULL && cpu != -1 && cpu != me &&
-		    kvm_request_needs_ipi(vcpu, req))
-			__cpumask_set_cpu(cpu, tmp);
+	if (likely(vcpu_bitmap)) {
+		for_each_set_bit(i, vcpu_bitmap, KVM_MAX_VCPUS) {
+			vcpu = kvm_get_vcpu(kvm, i);
+			if (!vcpu || vcpu == except)
+				continue;
+			kvm_make_vcpu_request(kvm, vcpu, req, tmp);
+		}
+	} else {
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			if (vcpu == except)
+				continue;
+			kvm_make_vcpu_request(kvm, vcpu, req, tmp);
+		}
 	}
 
 	called = kvm_kick_many_cpus(tmp, !!(req & KVM_REQUEST_WAIT));
-	put_cpu();
+
+	preempt_enable();
 
 	return called;
 }
-- 
2.31.1

