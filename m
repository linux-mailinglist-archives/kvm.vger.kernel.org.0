Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0661B7371C9
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 18:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbjFTQf3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 12:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbjFTQei (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 12:34:38 -0400
Received: from out-58.mta0.migadu.com (out-58.mta0.migadu.com [IPv6:2001:41d0:1004:224b::3a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB1510A
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 09:34:38 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687278876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3gzht6CT1X9IZD7roVpf6k8MHtu0w2z5eWGk4eof8mU=;
        b=jzkqbC7lHAGbYcCiWYHbOnQJM6LZ7fRWroB49gh9fFxVZ/vL3q6rmNoxc6W94uR0nkK4tk
        QNFLQD/4a0j6riMSpz6CUWljTdCNX9kRQAtDDZaKfRmti5TqHcQej4kbtWIKYuTfakaiS0
        5Az+pR6AFfRi07v/tZfF3XUoCMXO2Uk=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 11/20] Add helpers to pause the VM from vCPU thread
Date:   Tue, 20 Jun 2023 11:33:44 -0500
Message-ID: <20230620163353.2688567-12-oliver.upton@linux.dev>
In-Reply-To: <20230620163353.2688567-1-oliver.upton@linux.dev>
References: <20230620163353.2688567-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pausing the VM from a vCPU thread is perilous with the current helpers,
as it waits indefinitely for a signal that never comes when invoked from
a vCPU thread. Instead, add a helper for pausing the VM from a vCPU,
working around the issue by explicitly marking the caller as paused
before proceeding.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 include/kvm/kvm-cpu.h |  3 +++
 kvm-cpu.c             | 16 ++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/kvm/kvm-cpu.h b/include/kvm/kvm-cpu.h
index 0f16f8d..9a4901b 100644
--- a/include/kvm/kvm-cpu.h
+++ b/include/kvm/kvm-cpu.h
@@ -29,4 +29,7 @@ void kvm_cpu__show_page_tables(struct kvm_cpu *vcpu);
 void kvm_cpu__arch_nmi(struct kvm_cpu *cpu);
 void kvm_cpu__run_on_all_cpus(struct kvm *kvm, struct kvm_cpu_task *task);
 
+void kvm_cpu__pause_vm(struct kvm_cpu *vcpu);
+void kvm_cpu__continue_vm(struct kvm_cpu *vcpu);
+
 #endif /* KVM__KVM_CPU_H */
diff --git a/kvm-cpu.c b/kvm-cpu.c
index 7dec088..0fc1efe 100644
--- a/kvm-cpu.c
+++ b/kvm-cpu.c
@@ -141,6 +141,22 @@ void kvm_cpu__run_on_all_cpus(struct kvm *kvm, struct kvm_cpu_task *task)
 	mutex_unlock(&task_lock);
 }
 
+void kvm_cpu__pause_vm(struct kvm_cpu *vcpu)
+{
+	/*
+	 * Mark the calling vCPU as paused to avoid waiting indefinitely for a
+	 * signal exit.
+	 */
+	vcpu->paused = true;
+	kvm__pause(vcpu->kvm);
+}
+
+void kvm_cpu__continue_vm(struct kvm_cpu *vcpu)
+{
+	vcpu->paused = false;
+	kvm__continue(vcpu->kvm);
+}
+
 int kvm_cpu__start(struct kvm_cpu *cpu)
 {
 	sigset_t sigset;
-- 
2.41.0.162.gfafddb0af9-goog

