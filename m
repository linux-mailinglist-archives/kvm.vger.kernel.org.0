Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9880712FDA
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 00:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244414AbjEZWR7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 18:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244359AbjEZWR6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 18:17:58 -0400
Received: from out-6.mta0.migadu.com (out-6.mta0.migadu.com [IPv6:2001:41d0:1004:224b::6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D2A1B5
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 15:17:48 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685139466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jl7tqSCVFx7zOldIdwysXkDVcfP8sJLW+ao/HQKNfwo=;
        b=GC3lYmN4MVOuodVaVt6JwjZL/EAk0RQG9yk1631ZNZPu3fRnshgTzb7iKSytDV0KLzFj0Y
        gnnZQE12ObYtECRHx8vGNfC4GWwepmaSWuDWJm1ey7G02dB4WKGyGEPwvbN1j94aCMlzWT
        gVn7VojLOmhtPzvfgeXDg2sKdFivn1Y=
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
Subject: [PATCH kvmtool 12/21] Add helpers to pause the VM from vCPU thread
Date:   Fri, 26 May 2023 22:17:03 +0000
Message-ID: <20230526221712.317287-13-oliver.upton@linux.dev>
In-Reply-To: <20230526221712.317287-1-oliver.upton@linux.dev>
References: <20230526221712.317287-1-oliver.upton@linux.dev>
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
 kvm-cpu.c             | 15 +++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/kvm/kvm-cpu.h b/include/kvm/kvm-cpu.h
index 0f16f8d6e872..9a4901bf94ca 100644
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
index 7dec08894cd3..9eb857b859c3 100644
--- a/kvm-cpu.c
+++ b/kvm-cpu.c
@@ -141,6 +141,21 @@ void kvm_cpu__run_on_all_cpus(struct kvm *kvm, struct kvm_cpu_task *task)
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
+	kvm__continue(vcpu->kvm);
+}
+
 int kvm_cpu__start(struct kvm_cpu *cpu)
 {
 	sigset_t sigset;
-- 
2.41.0.rc0.172.g3f132b7071-goog

