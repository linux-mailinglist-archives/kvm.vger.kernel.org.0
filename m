Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC77F3F96DC
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 11:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244739AbhH0J01 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 05:26:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47349 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244723AbhH0J0Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 05:26:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630056333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/L+EAQK+m06QlJhA/k12O+BjGgcPNFgtPOHYl0R7XqA=;
        b=L2/WaYoiE1TrGhUx7EFITvmIiQsoajLL2NP3YsBbbosvC8+vkaQgt0qlzF6soKA9LC5sw3
        ykz2UWlr5Y2iF3KKCdu0/Qv0up9rD9BLPj8WFS8Ncq8ur6ZVVaP8lEcPGxpW3bNznWbjWq
        W3TTr5ckLOTbyi68vtTqKyWW0rqpdyU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-BbHVQ9PqOAC_duWp3pnJ1g-1; Fri, 27 Aug 2021 05:25:32 -0400
X-MC-Unique: BbHVQ9PqOAC_duWp3pnJ1g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0BB3E100806F;
        Fri, 27 Aug 2021 09:25:31 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2FE8860C5F;
        Fri, 27 Aug 2021 09:25:28 +0000 (UTC)
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
Subject: [PATCH v4 2/8] KVM: KVM: Use cpumask_available() to check for NULL cpumask when kicking vCPUs
Date:   Fri, 27 Aug 2021 11:25:10 +0200
Message-Id: <20210827092516.1027264-3-vkuznets@redhat.com>
In-Reply-To: <20210827092516.1027264-1-vkuznets@redhat.com>
References: <20210827092516.1027264-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

