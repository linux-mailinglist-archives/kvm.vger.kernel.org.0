Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB793656F7
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 12:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbhDTLAF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 07:00:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51971 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231415AbhDTK75 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 06:59:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618916366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=T/UowxEhrgES9Z8e890ShmFG6Jnrs7CSOo/ni1CNTGY=;
        b=SbTOQMJoK1s/jO1+doA5xsDbRhpGyiSLrON6QNDPyL93eSMUZPXG8a/ICmlnzXmw6pqnqO
        Ih18pfdIHBOVIlz3ztQWJlLdS0n/LUR3IfW5aDcBflKw1gKp98RhN7ntFQ33IL2HiiN2j+
        3bWrqCsXF8ztBiYTEsPqynMtGSBplrI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-27crLentM5Wiw6DBkRVYuw-1; Tue, 20 Apr 2021 06:59:24 -0400
X-MC-Unique: 27crLentM5Wiw6DBkRVYuw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75814107ACC7;
        Tue, 20 Apr 2021 10:59:23 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35B5063BAF;
        Tue, 20 Apr 2021 10:59:23 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: x86: add MSR_KVM_MIGRATION_CONTROL
Date:   Tue, 20 Apr 2021 06:59:22 -0400
Message-Id: <20210420105922.730705-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
 Documentation/virt/kvm/cpuid.rst     |  3 ++-
 Documentation/virt/kvm/msr.rst       | 10 ++++++++++
 arch/x86/include/uapi/asm/kvm_para.h |  3 +++
 arch/x86/kvm/x86.c                   | 14 ++++++++++++++
 4 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
index c9378d163b5a..15923857de56 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -99,7 +99,8 @@ KVM_FEATURE_MSI_EXT_DEST_ID        15          guest checks this feature bit
 KVM_FEATURE_HC_PAGE_ENC_STATUS     16          guest checks this feature bit before
                                                using the page encryption state
                                                hypercall to notify the page state
-                                               change
+                                               change, and before setting bit 0 of
+                                               MSR_KVM_MIGRATION_CONTROL
 
 KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
                                                per-cpu warps are expected in
diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
index e37a14c323d2..691d718df60a 100644
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
+        the guest.  The bit can be set if KVM_FEATURE_HC_PAGE_ENC_STATUS is
+        present in CPUID.
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index be49956b603f..c5ee419775d8 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -55,6 +55,7 @@
 #define MSR_KVM_POLL_CONTROL	0x4b564d05
 #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
 #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
+#define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
 
 struct kvm_steal_time {
 	__u64 steal;
@@ -91,6 +92,8 @@ struct kvm_clock_pairing {
 /* MSR_KVM_ASYNC_PF_INT */
 #define KVM_ASYNC_PF_VEC_MASK			GENMASK(7, 0)
 
+/* MSR_KVM_MIGRATION_CONTROL */
+#define KVM_PAGE_ENC_STATUS_UPTODATE		(1 << 0)
 
 /* Operations for KVM_HC_MMU_OP */
 #define KVM_MMU_OP_WRITE_PTE            1
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 36d302009fd8..efb98be3338d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3258,6 +3258,14 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.msr_kvm_poll_control = data;
 		break;
 
+	case MSR_KVM_MIGRATION_CONTROL:
+		if (data & ~KVM_PAGE_ENC_STATUS_UPTODATE)
+			return 1;
+
+		if (data && !guest_pv_has(vcpu, KVM_FEATURE_HC_PAGE_ENC_STATUS))
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
+		if (!guest_pv_has(vcpu, KVM_FEATURE_HC_PAGE_ENC_STATUS))
+			return 1;
+
 		msr_info->data = 0;
 		break;
 	case MSR_KVM_STEAL_TIME:
-- 
2.26.2

