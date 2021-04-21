Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0B5367174
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 19:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244779AbhDURiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 13:38:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59639 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244777AbhDURiA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Apr 2021 13:38:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619026646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kcj0BxIds39pKf4Y/6SgEUiTuwVXhlAX55Wjn1Rv4og=;
        b=eLlZ91Ih3dkwp+ju6qW6aC/JpbeEptNzY0KuJOZQLvpYo9jlmIQJsJKz6dsyrzI5vUBn00
        8KOYopwoJwN8DXotI5GC+NUwxI9KqrOM/kjVXzI6OYCdIL/289AEQEoqhiC8c/+hSh4agr
        yIVoTpNdi8B/Qp7/Ih6rYRctar1mI+U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-QFRSmfvYNnS1OLHiWLYfEQ-1; Wed, 21 Apr 2021 13:37:24 -0400
X-MC-Unique: QFRSmfvYNnS1OLHiWLYfEQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EEC75100A608;
        Wed, 21 Apr 2021 17:37:22 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5274E1001B2C;
        Wed, 21 Apr 2021 17:37:22 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, srutherford@google.com, joro@8bytes.org,
        brijesh.singh@amd.com, thomas.lendacky@amd.com,
        venu.busireddy@oracle.com
Subject: [PATCH v2 2/2] KVM: x86: add MSR_KVM_MIGRATION_CONTROL
Date:   Wed, 21 Apr 2021 13:37:16 -0400
Message-Id: <20210421173716.1577745-3-pbonzini@redhat.com>
In-Reply-To: <20210421173716.1577745-1-pbonzini@redhat.com>
References: <20210421173716.1577745-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new MSR that can be used to communicate whether the page
encryption status bitmap is up to date and therefore whether live
migration of an encrypted guest is possible.

The MSR should be processed by userspace if it is going to live
migrate the guest; the default implementation does nothing.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/cpuid.rst     |  4 ++++
 Documentation/virt/kvm/msr.rst       | 10 ++++++++++
 arch/x86/include/uapi/asm/kvm_para.h |  4 ++++
 arch/x86/kvm/cpuid.c                 |  3 ++-
 arch/x86/kvm/x86.c                   | 14 ++++++++++++++
 5 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
index c9378d163b5a..906d32812ab1 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -101,6 +101,10 @@ KVM_FEATURE_HC_PAGE_ENC_STATUS     16          guest checks this feature bit bef
                                                hypercall to notify the page state
                                                change
 
+KVM_FEATURE_MIGRATION_CONTROL      17          guest checks this feature bit
+                                               before setting bit 0 of
+                                               MSR_KVM_MIGRATION_CONTROL
+
 KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
                                                per-cpu warps are expected in
                                                kvmclock
diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
index e37a14c323d2..3917fd57314e 100644
--- a/Documentation/virt/kvm/msr.rst
+++ b/Documentation/virt/kvm/msr.rst
@@ -376,3 +376,13 @@ data:
 	write '1' to bit 0 of the MSR, this causes the host to re-scan its queue
 	and check if there are more notifications pending. The MSR is available
 	if KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
+
+MSR_KVM_MIGRATION_CONTROL:
+        0x4b564d08
+
+data:
+        If the guest is running with encrypted memory and it is communicating
+        page encryption status to the host using the ``KVM_HC_PAGE_ENC_STATUS``
+        hypercall, it can set bit 0 in this MSR to allow live migration of
+        the guest.  The bit remains set to 0 (but WRMSR does not fail) if
+        the host is not interested in page encryption status.
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index be49956b603f..f66b3ad35f97 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -34,6 +34,7 @@
 #define KVM_FEATURE_ASYNC_PF_INT	14
 #define KVM_FEATURE_MSI_EXT_DEST_ID	15
 #define KVM_FEATURE_HC_PAGE_ENC_STATUS	16
+#define KVM_FEATURE_MIGRATION_CONTROL	17
 
 #define KVM_HINTS_REALTIME      0
 
@@ -55,6 +56,7 @@
 #define MSR_KVM_POLL_CONTROL	0x4b564d05
 #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
 #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
+#define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
 
 struct kvm_steal_time {
 	__u64 steal;
@@ -91,6 +93,8 @@ struct kvm_clock_pairing {
 /* MSR_KVM_ASYNC_PF_INT */
 #define KVM_ASYNC_PF_VEC_MASK			GENMASK(7, 0)
 
+/* MSR_KVM_MIGRATION_CONTROL */
+#define KVM_PAGE_ENC_STATUS_UPTODATE		(1 << 0)
 
 /* Operations for KVM_HC_MMU_OP */
 #define KVM_MMU_OP_WRITE_PTE            1
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2ae061586677..b488c77bd429 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -887,7 +887,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			     (1 << KVM_FEATURE_PV_SEND_IPI) |
 			     (1 << KVM_FEATURE_POLL_CONTROL) |
 			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
-			     (1 << KVM_FEATURE_ASYNC_PF_INT);
+			     (1 << KVM_FEATURE_ASYNC_PF_INT) |
+			     (1 << KVM_FEATURE_MIGRATION_CONTROL);
 
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c2babf70a587..4cc849f2a048 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3258,6 +3258,14 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.msr_kvm_poll_control = data;
 		break;
 
+	case MSR_KVM_MIGRATION_CONTROL:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_MIGRATION_CONTROL))
+			return 1;
+
+		if (data & ~KVM_PAGE_ENC_STATUS_UPTODATE)
+			return 1;
+		break;
+
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
@@ -3549,6 +3557,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
 			return 1;
 
+		msr_info->data = 0;
+		break;
+	case MSR_KVM_MIGRATION_CONTROL:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_MIGRATION_CONTROL))
+			return 1;
+
 		msr_info->data = 0;
 		break;
 	case MSR_KVM_STEAL_TIME:
-- 
2.26.2

