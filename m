Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9265A3062E0
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 19:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234670AbhA0R7y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 12:59:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42278 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344092AbhA0R7O (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 12:59:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611770268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yjWhEYxtdtW/nAud/lMESXboNCqr4x4MvFiUIVGZ9TE=;
        b=UGhieZCrCsrCH6X6d/d1YvquDpNFMy384fc+/uA1x45fjU4LKvPOR6IKMu4VILd2/kwMX0
        bzI9LEo80881lQIVP6K8ndxaiq6SiXNmN2bbpWfxxOJr9rwAndhzPvJCx85QnA9NFlaHGt
        LIQNZ4Qsgd+bA2g9mCzgY5DqhOY+yek=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-JwirBN4YMDG8fU2ANKeOgQ-1; Wed, 27 Jan 2021 12:57:43 -0500
X-MC-Unique: JwirBN4YMDG8fU2ANKeOgQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A027107AD37;
        Wed, 27 Jan 2021 17:57:42 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 159D260854;
        Wed, 27 Jan 2021 17:57:39 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Subject: [PATCH 2/5] KVM: Raise the maximum number of user memslots
Date:   Wed, 27 Jan 2021 18:57:28 +0100
Message-Id: <20210127175731.2020089-3-vkuznets@redhat.com>
In-Reply-To: <20210127175731.2020089-1-vkuznets@redhat.com>
References: <20210127175731.2020089-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current KVM_USER_MEM_SLOTS limits are arch specific (512 on Power, 509 on x86,
32 on s390, 16 on MIPS) but they don't really need to be. Memory slots are
allocated dynamically in KVM when added so the only real limitation is
'id_to_index' array which is 'short'. We don't have any other
KVM_MEM_SLOTS_NUM/KVM_USER_MEM_SLOTS-sized statically defined structures.

Low KVM_USER_MEM_SLOTS can be a limiting factor for some configurations.
In particular, when QEMU tries to start a Windows guest with Hyper-V SynIC
enabled and e.g. 256 vCPUs the limit is hit as SynIC requires two pages per
vCPU and the guest is free to pick any GFN for each of them, this fragments
memslots as QEMU wants to have a separate memslot for each of these pages
(which are supposed to act as 'overlay' pages).

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h   | 1 -
 arch/mips/include/asm/kvm_host.h    | 1 -
 arch/powerpc/include/asm/kvm_host.h | 1 -
 arch/s390/include/asm/kvm_host.h    | 1 -
 arch/x86/include/asm/kvm_host.h     | 2 --
 include/linux/kvm_host.h            | 5 ++---
 virt/kvm/kvm_main.c                 | 1 +
 7 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8fcfab0c2567..1b8a3d825276 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -30,7 +30,6 @@
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
 
-#define KVM_USER_MEM_SLOTS 512
 #define KVM_HALT_POLL_NS_DEFAULT 500000
 
 #include <kvm/arm_vgic.h>
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 24f3d0f9996b..3a5612e7304c 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -83,7 +83,6 @@
 
 
 #define KVM_MAX_VCPUS		16
-#define KVM_USER_MEM_SLOTS	16
 /* memory slots that does not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS	0
 
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index d67a470e95a3..2b9b6855ec86 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -28,7 +28,6 @@
 
 #define KVM_MAX_VCPUS		NR_CPUS
 #define KVM_MAX_VCORES		NR_CPUS
-#define KVM_USER_MEM_SLOTS	512
 
 #include <asm/cputhreads.h>
 
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 74f9a036bab2..6bcfc5614bbc 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -28,7 +28,6 @@
 #define KVM_S390_BSCA_CPU_SLOTS 64
 #define KVM_S390_ESCA_CPU_SLOTS 248
 #define KVM_MAX_VCPUS 255
-#define KVM_USER_MEM_SLOTS 32
 
 /*
  * These seem to be used for allocating ->chip in the routing table, which we
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3d6616f6f6ef..a6547dc9191a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -40,10 +40,8 @@
 #define KVM_MAX_VCPUS 288
 #define KVM_SOFT_MAX_VCPUS 240
 #define KVM_MAX_VCPU_ID 1023
-#define KVM_USER_MEM_SLOTS 509
 /* memory slots that are not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 3
-#define KVM_MEM_SLOTS_NUM (KVM_USER_MEM_SLOTS + KVM_PRIVATE_MEM_SLOTS)
 
 #define KVM_HALT_POLL_NS_DEFAULT 200000
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0033ccffe617..754020140f37 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -425,9 +425,8 @@ struct kvm_irq_routing_table {
 #define KVM_PRIVATE_MEM_SLOTS 0
 #endif
 
-#ifndef KVM_MEM_SLOTS_NUM
-#define KVM_MEM_SLOTS_NUM (KVM_USER_MEM_SLOTS + KVM_PRIVATE_MEM_SLOTS)
-#endif
+#define KVM_MEM_SLOTS_NUM SHRT_MAX
+#define KVM_USER_MEM_SLOTS (KVM_MEM_SLOTS_NUM - KVM_PRIVATE_MEM_SLOTS)
 
 #ifndef __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
 static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a78e982e7107..5adb1b694304 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -755,6 +755,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	INIT_LIST_HEAD(&kvm->devices);
 
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
+	BUILD_BUG_ON(KVM_PRIVATE_MEM_SLOTS >= KVM_MEM_SLOTS_NUM);
 	kvm->memslots_max = KVM_USER_MEM_SLOTS;
 
 	if (init_srcu_struct(&kvm->srcu))
-- 
2.29.2

