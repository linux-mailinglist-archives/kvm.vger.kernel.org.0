Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459CB3F4C64
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 16:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbhHWOcd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 10:32:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35325 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230290AbhHWOcc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 10:32:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629729109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/WbznmYSWXy3CwdDh9G5nMXx6sTahDe95v+6YXmfShI=;
        b=JpN7qj4OYj2c/htc75vIkWUpGZ/teAkwLVhaQy+tyHPBD959DR/UEUz8yW45ZlA4sZSyEo
        jDz7V37tbZmCGsdDUuZ33/a9cvqsBo96vtIBCRgBjJqweHo2EA5qZXTjKTWi081zBiDn8O
        NckR3mTfVwjOKwPYkpdF+c6sMQp3jiA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-EA4ViK-VP-iBsqhJwEhxlw-1; Mon, 23 Aug 2021 10:30:43 -0400
X-MC-Unique: EA4ViK-VP-iBsqhJwEhxlw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E2D5190B2A9;
        Mon, 23 Aug 2021 14:30:42 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 200342707F;
        Mon, 23 Aug 2021 14:30:39 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] KVM: Guard cpusmask NULL check with CONFIG_CPUMASK_OFFSTACK
Date:   Mon, 23 Aug 2021 16:30:26 +0200
Message-Id: <20210823143028.649818-3-vkuznets@redhat.com>
In-Reply-To: <20210823143028.649818-1-vkuznets@redhat.com>
References: <20210823143028.649818-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Check for a NULL cpumask_var_t when kicking multiple vCPUs if and only if
cpumasks are configured to be allocated off-stack.  This is a meaningless
optimization, e.g. avoids a TEST+Jcc and TEST+CMOV on x86, but more
importantly helps document that the NULL check is necessary even though
all callers pass in a local variable.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 virt/kvm/kvm_main.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 786b914db98f..82c5280dd5ce 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -247,7 +247,7 @@ static void ack_flush(void *_completed)
 
 static inline bool kvm_kick_many_cpus(const struct cpumask *cpus, bool wait)
 {
-	if (unlikely(!cpus))
+	if (IS_ENABLED(CONFIG_CPUMASK_OFFSTACK) && unlikely(!cpus))
 		cpus = cpu_online_mask;
 
 	if (cpumask_empty(cpus))
@@ -277,6 +277,14 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 		if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
 			continue;
 
+		/*
+		 * tmp can be NULL if cpumasks are allocated off stack, as
+		 * allocation of the mask is deliberately not fatal and is
+		 * handled by falling back to kicking all online CPUs.
+		 */
+		if (IS_ENABLED(CONFIG_CPUMASK_OFFSTACK) && !tmp)
+			continue;
+
 		/*
 		 * Note, the vCPU could get migrated to a different pCPU at any
 		 * point after kvm_request_needs_ipi(), which could result in
@@ -288,7 +296,7 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
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

