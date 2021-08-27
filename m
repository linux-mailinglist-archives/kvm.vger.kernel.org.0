Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F6F3F96E6
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 11:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244781AbhH0J0q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 05:26:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37230 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244783AbhH0J0m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 05:26:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630056353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oL/sSJ7KOMkMsGgoKXL3kcjYM8/sEuHSEz7AUxAR0as=;
        b=LugfmaQrndI3/wfsvrV72PmxtS6KVxSynxwr7Aw4CaK67wInwkRIRaO1jjjIEyv/jiWIyx
        oXtWGvz++gBzrdh88ekkxo6R1xqOLodWG/PexEpFgzlQKzOTfpI+o1fBD7ZWGJZPW6XbYv
        8BDjqhkQCbkw61RJLRYzAHNCq6Xu3Ac=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-0VCAWsNTMT2skqAX0r6r2Q-1; Fri, 27 Aug 2021 05:25:52 -0400
X-MC-Unique: 0VCAWsNTMT2skqAX0r6r2Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8B11C7401;
        Fri, 27 Aug 2021 09:25:50 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 233F060C04;
        Fri, 27 Aug 2021 09:25:47 +0000 (UTC)
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
Subject: [PATCH v4 7/8] KVM: Pre-allocate cpumasks for kvm_make_all_cpus_request_except()
Date:   Fri, 27 Aug 2021 11:25:15 +0200
Message-Id: <20210827092516.1027264-8-vkuznets@redhat.com>
In-Reply-To: <20210827092516.1027264-1-vkuznets@redhat.com>
References: <20210827092516.1027264-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allocating cpumask dynamically in zalloc_cpumask_var() is not ideal.
Allocation is somewhat slow and can (in theory and when CPUMASK_OFFSTACK)
fail. kvm_make_all_cpus_request_except() already disables preemption so
we can use pre-allocated per-cpu cpumasks instead.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 virt/kvm/kvm_main.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2e9927c4eb32..2f5fe4f54a51 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -155,6 +155,8 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm);
 static unsigned long long kvm_createvm_count;
 static unsigned long long kvm_active_vms;
 
+static DEFINE_PER_CPU(cpumask_var_t, cpu_kick_mask);
+
 __weak void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 						   unsigned long start, unsigned long end)
 {
@@ -323,14 +325,15 @@ bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
 				      struct kvm_vcpu *except)
 {
 	struct kvm_vcpu *vcpu;
-	cpumask_var_t cpus;
+	struct cpumask *cpus;
 	bool called;
 	int i, me;
 
-	zalloc_cpumask_var(&cpus, GFP_ATOMIC);
-
 	me = get_cpu();
 
+	cpus = this_cpu_cpumask_var_ptr(cpu_kick_mask);
+	cpumask_clear(cpus);
+
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (vcpu == except)
 			continue;
@@ -340,7 +343,6 @@ bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
 	called = kvm_kick_many_cpus(cpus, !!(req & KVM_REQUEST_WAIT));
 	put_cpu();
 
-	free_cpumask_var(cpus);
 	return called;
 }
 
@@ -5581,9 +5583,15 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 		goto out_free_3;
 	}
 
+	for_each_possible_cpu(cpu) {
+		if (!alloc_cpumask_var_node(&per_cpu(cpu_kick_mask, cpu),
+					    GFP_KERNEL, cpu_to_node(cpu)))
+			goto out_free_4;
+	}
+
 	r = kvm_async_pf_init();
 	if (r)
-		goto out_free;
+		goto out_free_5;
 
 	kvm_chardev_ops.owner = module;
 	kvm_vm_fops.owner = module;
@@ -5609,7 +5617,11 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 
 out_unreg:
 	kvm_async_pf_deinit();
-out_free:
+out_free_5:
+	for_each_possible_cpu(cpu) {
+		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
+	}
+out_free_4:
 	kmem_cache_destroy(kvm_vcpu_cache);
 out_free_3:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
@@ -5629,8 +5641,13 @@ EXPORT_SYMBOL_GPL(kvm_init);
 
 void kvm_exit(void)
 {
+	int cpu;
+
 	debugfs_remove_recursive(kvm_debugfs_dir);
 	misc_deregister(&kvm_dev);
+	for_each_possible_cpu(cpu) {
+		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
+	}
 	kmem_cache_destroy(kvm_vcpu_cache);
 	kvm_async_pf_deinit();
 	unregister_syscore_ops(&kvm_syscore_ops);
-- 
2.31.1

