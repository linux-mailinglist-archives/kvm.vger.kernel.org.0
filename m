Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1FF32C618
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348042AbhCDA1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:27:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43897 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348200AbhCCNLA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 08:11:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614776972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kjwfGYFMDthCpViXHcPvQAxOlLkrIVsnB+USfHIfAQU=;
        b=cmbHvkbSO0nMuN9HYlDRODFODmkoI3Ugs5zzCQ1aJElRStPZkYoGSfAUcJUG3z2IpLHzft
        GuBPsAcU/jtQNPdVAwJT4PBmKHfzAC5qyzz6lnoUlOxQINfZl9/DhvHa5uWZ87U6p0GQOq
        fV4qT4aE0I2nQzEgxG8A07pdwEYY0kE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-3Q8pOU-XMDam6ia90MPz2g-1; Wed, 03 Mar 2021 08:09:31 -0500
X-MC-Unique: 3Q8pOU-XMDam6ia90MPz2g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA7A6801962;
        Wed,  3 Mar 2021 13:09:29 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-112-28.ams2.redhat.com [10.36.112.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 583FE60BFA;
        Wed,  3 Mar 2021 13:09:27 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Peter Xu <peterx@redhat.com>
Subject: [PATCH v1 1/2] s390x/kvm: Get rid of legacy_s390_alloc()
Date:   Wed,  3 Mar 2021 14:09:15 +0100
Message-Id: <20210303130916.22553-2-david@redhat.com>
In-Reply-To: <20210303130916.22553-1-david@redhat.com>
References: <20210303130916.22553-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

legacy_s390_alloc() was required for dealing with the absence of the ESOP
feature -- on old HW (< gen 10) and old z/VM versions (< 6.3).

As z/VM v6.2 (and even v6.3) is no longer supported since 2017 [1]
and we don't expect to have real users on such old hardware, let's drop
legacy_s390_alloc().

Still check+report an error just in case someone still runs on
such old z/VM environments, or someone runs under weird nested KVM
setups (where we can manually disable ESOP via the CPU model).

No need to check for KVM_CAP_GMAP - that should always be around on
kernels that also have KVM_CAP_DEVICE_CTRL (>= v3.15).

[1] https://www.ibm.com/support/lifecycle/search?q=z%2FVM

Suggested-by: Cornelia Huck <cohuck@redhat.com>
Suggested-by: Thomas Huth <thuth@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Halil Pasic <pasic@linux.ibm.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 target/s390x/kvm.c | 43 +++++--------------------------------------
 1 file changed, 5 insertions(+), 38 deletions(-)

diff --git a/target/s390x/kvm.c b/target/s390x/kvm.c
index 7a892d663d..84b40572f2 100644
--- a/target/s390x/kvm.c
+++ b/target/s390x/kvm.c
@@ -161,8 +161,6 @@ static int cap_protected;
 
 static int active_cmma;
 
-static void *legacy_s390_alloc(size_t size, uint64_t *align, bool shared);
-
 static int kvm_s390_query_mem_limit(uint64_t *memory_limit)
 {
     struct kvm_device_attr attr = {
@@ -349,6 +347,11 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
                      "please use kernel 3.15 or newer");
         return -1;
     }
+    if (!kvm_check_extension(s, KVM_CAP_S390_COW)) {
+        error_report("KVM is missing capability KVM_CAP_S390_COW - "
+                     "unsupported environment");
+        return -1;
+    }
 
     cap_sync_regs = kvm_check_extension(s, KVM_CAP_SYNC_REGS);
     cap_async_pf = kvm_check_extension(s, KVM_CAP_ASYNC_PF);
@@ -357,11 +360,6 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     cap_vcpu_resets = kvm_check_extension(s, KVM_CAP_S390_VCPU_RESETS);
     cap_protected = kvm_check_extension(s, KVM_CAP_S390_PROTECTED);
 
-    if (!kvm_check_extension(s, KVM_CAP_S390_GMAP)
-        || !kvm_check_extension(s, KVM_CAP_S390_COW)) {
-        phys_mem_set_alloc(legacy_s390_alloc);
-    }
-
     kvm_vm_enable_cap(s, KVM_CAP_S390_USER_SIGP, 0);
     kvm_vm_enable_cap(s, KVM_CAP_S390_VECTOR_REGISTERS, 0);
     kvm_vm_enable_cap(s, KVM_CAP_S390_USER_STSI, 0);
@@ -889,37 +887,6 @@ int kvm_s390_mem_op_pv(S390CPU *cpu, uint64_t offset, void *hostbuf,
     return ret;
 }
 
-/*
- * Legacy layout for s390:
- * Older S390 KVM requires the topmost vma of the RAM to be
- * smaller than an system defined value, which is at least 256GB.
- * Larger systems have larger values. We put the guest between
- * the end of data segment (system break) and this value. We
- * use 32GB as a base to have enough room for the system break
- * to grow. We also have to use MAP parameters that avoid
- * read-only mapping of guest pages.
- */
-static void *legacy_s390_alloc(size_t size, uint64_t *align, bool shared)
-{
-    static void *mem;
-
-    if (mem) {
-        /* we only support one allocation, which is enough for initial ram */
-        return NULL;
-    }
-
-    mem = mmap((void *) 0x800000000ULL, size,
-               PROT_EXEC|PROT_READ|PROT_WRITE,
-               MAP_SHARED | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
-    if (mem == MAP_FAILED) {
-        mem = NULL;
-    }
-    if (mem && align) {
-        *align = QEMU_VMALLOC_ALIGN;
-    }
-    return mem;
-}
-
 static uint8_t const *sw_bp_inst;
 static uint8_t sw_bp_ilen;
 
-- 
2.29.2

