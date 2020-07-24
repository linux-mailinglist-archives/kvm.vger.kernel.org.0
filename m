Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D897422C0E7
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 10:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbgGXIfl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 04:35:41 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38759 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726753AbgGXIfl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Jul 2020 04:35:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595579739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=InBwq/6ekQfs5RfXLsv/seuvSyx3UpGVDS5FZpmQ+jQ=;
        b=VtOVNcKLyCdazojxp5oR2wS21+QRB95KPoQJeKK39Fn31YwCqMkyX54rU88Gsr5/X8FAC0
        GTJ320j1zoNPIRS6Es93C8XOQ9hfqyh/a0wf6CWE52Q6pzwZnsWN3asVYA0VHTKsdFMAoc
        v2Pk9xsZ3nIR2dEWXwcHK8sd4W51Sr4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-fQzOSTIOOkiInjhslgAVeA-1; Fri, 24 Jul 2020 04:35:37 -0400
X-MC-Unique: fQzOSTIOOkiInjhslgAVeA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8644D80183C;
        Fri, 24 Jul 2020 08:35:36 +0000 (UTC)
Received: from thinkpad.redhat.com (ovpn-112-21.ams2.redhat.com [10.36.112.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D9162DE73;
        Fri, 24 Jul 2020 08:35:34 +0000 (UTC)
From:   Laurent Vivier <lvivier@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-ppc@nongnu.org, Laurent Vivier <lvivier@redhat.com>,
        npiggin@gmail.com
Subject: [PATCH] pseries: fix kvmppc_set_fwnmi()
Date:   Fri, 24 Jul 2020 10:35:33 +0200
Message-Id: <20200724083533.281700-1-lvivier@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QEMU issues the ioctl(KVM_CAP_PPC_FWNMI) on the first vCPU.

If the first vCPU is currently running, the vCPU mutex is held
and the ioctl() cannot be done and waits until the mutex is released.
This never happens and the VM is stuck.

To avoid this deadlock, issue the ioctl on the same vCPU doing the
RTAS call.

The problem can be reproduced by booting a guest with several vCPUs
(the probability to have the problem is (n - 1) / n,  n = # of CPUs),
and then by triggering a kernel crash with "echo c >/proc/sysrq-trigger".

On the reboot, the kernel hangs after:

...
[    0.000000] -----------------------------------------------------
[    0.000000] ppc64_pft_size    = 0x0
[    0.000000] phys_mem_size     = 0x48000000
[    0.000000] dcache_bsize      = 0x80
[    0.000000] icache_bsize      = 0x80
[    0.000000] cpu_features      = 0x0001c06f8f4f91a7
[    0.000000]   possible        = 0x0003fbffcf5fb1a7
[    0.000000]   always          = 0x00000003800081a1
[    0.000000] cpu_user_features = 0xdc0065c2 0xaee00000
[    0.000000] mmu_features      = 0x3c006041
[    0.000000] firmware_features = 0x00000085455a445f
[    0.000000] physical_start    = 0x8000000
[    0.000000] -----------------------------------------------------
[    0.000000] numa:   NODE_DATA [mem 0x47f33c80-0x47f3ffff]

Fixes: ec010c00665b ("ppc/spapr: KVM FWNMI should not be enabled until guest requests it")
Cc: npiggin@gmail.com
Signed-off-by: Laurent Vivier <lvivier@redhat.com>
---
 hw/ppc/spapr_rtas.c  | 2 +-
 target/ppc/kvm.c     | 3 +--
 target/ppc/kvm_ppc.h | 4 ++--
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/hw/ppc/spapr_rtas.c b/hw/ppc/spapr_rtas.c
index bcac0d00e7b6..513c7a84351b 100644
--- a/hw/ppc/spapr_rtas.c
+++ b/hw/ppc/spapr_rtas.c
@@ -438,7 +438,7 @@ static void rtas_ibm_nmi_register(PowerPCCPU *cpu,
     }
 
     if (kvm_enabled()) {
-        if (kvmppc_set_fwnmi() < 0) {
+        if (kvmppc_set_fwnmi(cpu) < 0) {
             rtas_st(rets, 0, RTAS_OUT_NOT_SUPPORTED);
             return;
         }
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 2692f76130aa..d85ba8ffe00b 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -2071,9 +2071,8 @@ bool kvmppc_get_fwnmi(void)
     return cap_fwnmi;
 }
 
-int kvmppc_set_fwnmi(void)
+int kvmppc_set_fwnmi(PowerPCCPU *cpu)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(first_cpu);
     CPUState *cs = CPU(cpu);
 
     return kvm_vcpu_enable_cap(cs, KVM_CAP_PPC_FWNMI, 0);
diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
index 701c0c262be2..72e05f1cd2fc 100644
--- a/target/ppc/kvm_ppc.h
+++ b/target/ppc/kvm_ppc.h
@@ -28,7 +28,7 @@ void kvmppc_set_papr(PowerPCCPU *cpu);
 int kvmppc_set_compat(PowerPCCPU *cpu, uint32_t compat_pvr);
 void kvmppc_set_mpic_proxy(PowerPCCPU *cpu, int mpic_proxy);
 bool kvmppc_get_fwnmi(void);
-int kvmppc_set_fwnmi(void);
+int kvmppc_set_fwnmi(PowerPCCPU *cpu);
 int kvmppc_smt_threads(void);
 void kvmppc_error_append_smt_possible_hint(Error *const *errp);
 int kvmppc_set_smt_threads(int smt);
@@ -169,7 +169,7 @@ static inline bool kvmppc_get_fwnmi(void)
     return false;
 }
 
-static inline int kvmppc_set_fwnmi(void)
+static inline int kvmppc_set_fwnmi(PowerPCCPU *cpu)
 {
     return -1;
 }
-- 
2.26.2

