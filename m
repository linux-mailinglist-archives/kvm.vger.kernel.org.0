Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC328608E3A
	for <lists+kvm@lfdr.de>; Sat, 22 Oct 2022 17:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiJVPso (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Oct 2022 11:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiJVPsd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Oct 2022 11:48:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4830124F78C
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 08:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666453710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6dbzyM+9g9fjSLtaxfcxeYNDxW4iMiSOGFthjgPIStQ=;
        b=Q1dYe+WdgBk2b4o8JNxkwubBA25Jy5Oa8y3H36chpn0rnXKGGrn4n1PCGzRYAAFrI2t9Wp
        RBFgU5Wp9DJfkBOaP+H+/KaaCgcn4+XWlcWhfd8caCVTSkcZG0fuhVry1tULDNl73uVH76
        6bUT60O90EvDW5amcOnWOek9HUe+q+w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-UIIhHk5sP4-sgGnYe7LgDA-1; Sat, 22 Oct 2022 11:48:28 -0400
X-MC-Unique: UIIhHk5sP4-sgGnYe7LgDA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2EAA5811E75;
        Sat, 22 Oct 2022 15:48:28 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CEC8140C6E14;
        Sat, 22 Oct 2022 15:48:26 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [PATCH 2/2] accel/kvm: introduce begin/commit listener callbacks
Date:   Sat, 22 Oct 2022 11:48:23 -0400
Message-Id: <20221022154823.1823193-3-eesposit@redhat.com>
In-Reply-To: <20221022154823.1823193-1-eesposit@redhat.com>
References: <20221022154823.1823193-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These callback make sure that all vcpus are blocked before
performing memslot updates, and resumed once we are finished.

They rely on kvm support for KVM_KICK_ALL_RUNNING_VCPUS and
KVM_RESUME_ALL_KICKED_VCPUS ioctls to respectively pause and
resume all vcpus that are in KVM_RUN state.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 accel/kvm/kvm-all.c | 50 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 645f0a249a..bd0dfa8613 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -178,6 +178,8 @@ bool kvm_has_guest_debug;
 int kvm_sstep_flags;
 static bool kvm_immediate_exit;
 static hwaddr kvm_max_slot_size = ~0;
+static QemuEvent mem_transaction_proceed;
+
 
 static const KVMCapabilityInfo kvm_required_capabilites[] = {
     KVM_CAP_INFO(USER_MEMORY),
@@ -1523,6 +1525,38 @@ static void kvm_region_del(MemoryListener *listener,
     memory_region_unref(section->mr);
 }
 
+static void kvm_begin(MemoryListener *listener)
+{
+    KVMState *s = kvm_state;
+
+    /*
+     * Make sure BQL is taken so cpus in kvm_cpu_exec that just exited from
+     * KVM_RUN do not continue, since many run->exit_reason take it anyways.
+     */
+    assert(qemu_mutex_iothread_locked());
+
+    /*
+     * Stop incoming cpus that want to execute KVM_RUN from running.
+     * Makes cpus calling qemu_event_wait() in kvm_cpu_exec() block.
+     */
+    qemu_event_reset(&mem_transaction_proceed);
+
+    /* Ask KVM to stop all vcpus that are currently running KVM_RUN */
+    kvm_vm_ioctl(s, KVM_KICK_ALL_RUNNING_VCPUS);
+}
+
+static void kvm_commit(MemoryListener *listener)
+{
+    KVMState *s = kvm_state;
+    assert(qemu_mutex_iothread_locked());
+
+    /* Ask KVM to resume all vcpus that are currently blocked in KVM_RUN */
+    kvm_vm_ioctl(s, KVM_RESUME_ALL_KICKED_VCPUS);
+
+    /* Resume cpus waiting in qemu_event_wait() in kvm_cpu_exec() */
+    qemu_event_set(&mem_transaction_proceed);
+}
+
 static void kvm_log_sync(MemoryListener *listener,
                          MemoryRegionSection *section)
 {
@@ -1668,6 +1702,8 @@ void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
     kml->listener.region_del = kvm_region_del;
     kml->listener.log_start = kvm_log_start;
     kml->listener.log_stop = kvm_log_stop;
+    kml->listener.begin = kvm_begin;
+    kml->listener.commit = kvm_commit;
     kml->listener.priority = 10;
     kml->listener.name = name;
 
@@ -2611,6 +2647,7 @@ static int kvm_init(MachineState *ms)
     }
 
     kvm_state = s;
+    qemu_event_init(&mem_transaction_proceed, false);
 
     ret = kvm_arch_init(ms, s);
     if (ret < 0) {
@@ -2875,6 +2912,19 @@ int kvm_cpu_exec(CPUState *cpu)
     }
 
     qemu_mutex_unlock_iothread();
+
+    /*
+     * Wait that a running memory transaction (memslot update) is concluded.
+     *
+     * If the event state is EV_SET, it means kvm_commit() has already finished
+     * and called qemu_event_set(), therefore cpu can execute.
+     *
+     * If it's EV_FREE, it means kvm_begin() has already called
+     * qemu_event_reset(), therefore a memory transaction is happening and the
+     * cpu must wait.
+     */
+    qemu_event_wait(&mem_transaction_proceed);
+
     cpu_exec_start(cpu);
 
     do {
-- 
2.31.1

