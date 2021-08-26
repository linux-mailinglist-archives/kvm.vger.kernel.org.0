Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90563F8756
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 14:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241286AbhHZMZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 08:25:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29718 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241096AbhHZMZw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 08:25:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629980704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/L+EAQK+m06QlJhA/k12O+BjGgcPNFgtPOHYl0R7XqA=;
        b=Aon37DrU+yHl4DUmVTMiGi4FdTuKM0OWapzc7jKz/3S896bLtSCAe8sY6+nks9ZGAbaQsl
        YVmZTIb11XEkT2ZHoQU7zFFGEwa+aw2cQIeZTl7b/uE15FqensmHL9ivEIBiwiKNr/LR5F
        gUPsz/HC4zEBk0FXFqWFfIHd0z/Eiu4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-Xe1AtePuMPKfw_qNbHVV0A-1; Thu, 26 Aug 2021 08:25:01 -0400
X-MC-Unique: Xe1AtePuMPKfw_qNbHVV0A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10212801AC5;
        Thu, 26 Aug 2021 12:25:00 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9694060936;
        Thu, 26 Aug 2021 12:24:57 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/4] KVM: KVM: Use cpumask_available() to check for NULL cpumask when kicking vCPUs
Date:   Thu, 26 Aug 2021 14:24:40 +0200
Message-Id: <20210826122442.966977-3-vkuznets@redhat.com>
In-Reply-To: <20210826122442.966977-1-vkuznets@redhat.com>
References: <20210826122442.966977-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Check for a NULL cpumask_var_t when kicking multiple vCPUs via
cpumask_available(), which performs a !NULL check if and only if cpumasks
are configured to be allocated off-stack.  This is a meaningless
optimization, e.g. avoids a TEST+Jcc and TEST+CMOV on x86, but more
importantly helps document that the NULL check is necessary even though
all callers pass in a local variable.

No functional change intended.

Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 virt/kvm/kvm_main.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 786b914db98f..2082aceffbf6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -245,9 +245,13 @@ static void ack_flush(void *_completed)
 {
 }
 
-static inline bool kvm_kick_many_cpus(const struct cpumask *cpus, bool wait)
+static inline bool kvm_kick_many_cpus(cpumask_var_t tmp, bool wait)
 {
-	if (unlikely(!cpus))
+	const struct cpumask *cpus;
+
+	if (likely(cpumask_available(tmp)))
+		cpus = tmp;
+	else
 		cpus = cpu_online_mask;
 
 	if (cpumask_empty(cpus))
@@ -277,6 +281,14 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 		if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
 			continue;
 
+		/*
+		 * tmp can be "unavailable" if cpumasks are allocated off stack
+		 * as allocation of the mask is deliberately not fatal and is
+		 * handled by falling back to kicking all online CPUs.
+		 */
+		if (!cpumask_available(tmp))
+			continue;
+
 		/*
 		 * Note, the vCPU could get migrated to a different pCPU at any
 		 * point after kvm_request_needs_ipi(), which could result in
@@ -288,7 +300,7 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 		 * were reading SPTEs _before_ any changes were finalized.  See
 		 * kvm_vcpu_kick() for more details on handling requests.
 		 */
-		if (tmp != NULL && kvm_request_needs_ipi(vcpu, req)) {
+		if (kvm_request_needs_ipi(vcpu, req)) {
 			cpu = READ_ONCE(vcpu->cpu);
 			if (cpu != -1 && cpu != me)
 				__cpumask_set_cpu(cpu, tmp);
-- 
2.31.1

