Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14F5D143B9F
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 12:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgAULFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 06:05:32 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35983 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728748AbgAULFc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 06:05:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579604731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iNuoGr5oPJiuWEZoZePQ9BsL70DcUB2WguHzKK55cpE=;
        b=i0oIASQjfC6SBaFXZjprEgIgMac0ULh3WqCuwtSVQRYkPUq+B19KLe8Qp9LTDizcZTK1dq
        0AJLDanTkQ8HxJjD4xB4JG9CgJrfjkDTVFBBGfgp3EU9dXrw+m5bd9TH1SApnfTrVHBkGD
        tMsCO68DyKzJAVa4+KdaAnYZFOWXr6s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-JQqfRcGaOUKmLMIdFS6tiQ-1; Tue, 21 Jan 2020 06:05:29 -0500
X-MC-Unique: JQqfRcGaOUKmLMIdFS6tiQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 363F6DBA3;
        Tue, 21 Jan 2020 11:05:28 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-38.brq.redhat.com [10.40.205.38])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 13C98811F8;
        Tue, 21 Jan 2020 11:05:21 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-s390x@nongnu.org, David Hildenbrand <david@redhat.com>,
        qemu-ppc@nongnu.org, Eduardo Habkost <ehabkost@redhat.com>,
        Like Xu <like.xu@linux.intel.com>,
        Markus Armbruster <armbru@redhat.com>, qemu-arm@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PATCH v2 09/10] accel: Replace current_machine->accelerator by current_accel() wrapper
Date:   Tue, 21 Jan 2020 12:03:48 +0100
Message-Id: <20200121110349.25842-10-philmd@redhat.com>
In-Reply-To: <20200121110349.25842-1-philmd@redhat.com>
References: <20200121110349.25842-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We actually want to access the accelerator, not the machine, so
use the current_accel() wrapper instead.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
v2:
- Reworded description
- Remove unused include in arm/kvm64
---
 accel/kvm/kvm-all.c | 4 ++--
 accel/tcg/tcg-all.c | 2 +-
 memory.c            | 2 +-
 target/arm/kvm64.c  | 5 ++---
 target/i386/kvm.c   | 2 +-
 target/ppc/kvm.c    | 2 +-
 vl.c                | 2 +-
 7 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 1ada2f4ecb..c111312dfd 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -164,7 +164,7 @@ static NotifierList kvm_irqchip_change_notifiers =3D
=20
 int kvm_get_max_memslots(void)
 {
-    KVMState *s =3D KVM_STATE(current_machine->accelerator);
+    KVMState *s =3D KVM_STATE(current_accel());
=20
     return s->nr_slots;
 }
@@ -1848,7 +1848,7 @@ static int kvm_max_vcpu_id(KVMState *s)
=20
 bool kvm_vcpu_id_is_valid(int vcpu_id)
 {
-    KVMState *s =3D KVM_STATE(current_machine->accelerator);
+    KVMState *s =3D KVM_STATE(current_accel());
     return vcpu_id >=3D 0 && vcpu_id < kvm_max_vcpu_id(s);
 }
=20
diff --git a/accel/tcg/tcg-all.c b/accel/tcg/tcg-all.c
index 1dc384c8d2..1802ce02f6 100644
--- a/accel/tcg/tcg-all.c
+++ b/accel/tcg/tcg-all.c
@@ -124,7 +124,7 @@ static void tcg_accel_instance_init(Object *obj)
=20
 static int tcg_init(MachineState *ms)
 {
-    TCGState *s =3D TCG_STATE(current_machine->accelerator);
+    TCGState *s =3D TCG_STATE(current_accel());
=20
     tcg_exec_init(s->tb_size * 1024 * 1024);
     cpu_interrupt_handler =3D tcg_handle_interrupt;
diff --git a/memory.c b/memory.c
index d7b9bb6951..854798791e 100644
--- a/memory.c
+++ b/memory.c
@@ -3104,7 +3104,7 @@ void mtree_info(bool flatview, bool dispatch_tree, =
bool owner)
         };
         GArray *fv_address_spaces;
         GHashTable *views =3D g_hash_table_new(g_direct_hash, g_direct_e=
qual);
-        AccelClass *ac =3D ACCEL_GET_CLASS(current_machine->accelerator)=
;
+        AccelClass *ac =3D ACCEL_GET_CLASS(current_accel());
=20
         if (ac->has_memory) {
             fvi.ac =3D ac;
diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index 876184b8fe..e3c580e749 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -26,7 +26,6 @@
 #include "sysemu/kvm.h"
 #include "sysemu/kvm_int.h"
 #include "kvm_arm.h"
-#include "hw/boards.h"
 #include "internals.h"
=20
 static bool have_guest_debug;
@@ -613,14 +612,14 @@ bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatur=
es *ahcf)
=20
 bool kvm_arm_aarch32_supported(CPUState *cpu)
 {
-    KVMState *s =3D KVM_STATE(current_machine->accelerator);
+    KVMState *s =3D KVM_STATE(current_accel());
=20
     return kvm_check_extension(s, KVM_CAP_ARM_EL1_32BIT);
 }
=20
 bool kvm_arm_sve_supported(CPUState *cpu)
 {
-    KVMState *s =3D KVM_STATE(current_machine->accelerator);
+    KVMState *s =3D KVM_STATE(current_accel());
=20
     return kvm_check_extension(s, KVM_CAP_ARM_SVE);
 }
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 7ee3202634..eddb930065 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -147,7 +147,7 @@ bool kvm_allows_irq0_override(void)
=20
 static bool kvm_x2apic_api_set_flags(uint64_t flags)
 {
-    KVMState *s =3D KVM_STATE(current_machine->accelerator);
+    KVMState *s =3D KVM_STATE(current_accel());
=20
     return !kvm_vm_enable_cap(s, KVM_CAP_X2APIC_API, 0, flags);
 }
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index b5799e62b4..45ede6b6d9 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -258,7 +258,7 @@ static void kvm_get_smmu_info(struct kvm_ppc_smmu_inf=
o *info, Error **errp)
=20
 struct ppc_radix_page_info *kvm_get_radix_page_info(void)
 {
-    KVMState *s =3D KVM_STATE(current_machine->accelerator);
+    KVMState *s =3D KVM_STATE(current_accel());
     struct ppc_radix_page_info *radix_page_info;
     struct kvm_ppc_rmmu_info rmmu_info;
     int i;
diff --git a/vl.c b/vl.c
index 71d3e7eefb..a8ea36f4f8 100644
--- a/vl.c
+++ b/vl.c
@@ -2812,7 +2812,7 @@ static void configure_accelerators(const char *prog=
name)
     }
=20
     if (init_failed) {
-        AccelClass *ac =3D ACCEL_GET_CLASS(current_machine->accelerator)=
;
+        AccelClass *ac =3D ACCEL_GET_CLASS(current_accel());
         error_report("falling back to %s", ac->name);
     }
=20
--=20
2.21.1

