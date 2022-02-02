Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC8D4A6E1F
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 10:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245622AbiBBJwO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 04:52:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36794 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245593AbiBBJwM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Feb 2022 04:52:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643795532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cgFGsxOGcMBf4PqRbP0oxIU+SDHKdwycOOwCjyolYBo=;
        b=Dydz3n/33+BPmZKu9zx+Z8OXVRFRVP2ARMNUghFOwzD1lJipzVDkXAGdoqR/0anUjj5RH5
        BP4IxHcre+SqxjOyZZhYnwYCGhSsRVrUdPgqwVwtCtBc4t2/OpAk+WDZSWP2HpBjSUlG9P
        6HIp854INut7mnUnnkhp7vLi7+A8uzQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-k3_kMoBfPWi5WEEYou2aIg-1; Wed, 02 Feb 2022 04:52:09 -0500
X-MC-Unique: k3_kMoBfPWi5WEEYou2aIg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1BB3363A4;
        Wed,  2 Feb 2022 09:52:07 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CACC2752AA;
        Wed,  2 Feb 2022 09:51:48 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] KVM: nSVM: Split off common definitions for Hyper-V on KVM and KVM on Hyper-V
Date:   Wed,  2 Feb 2022 10:50:59 +0100
Message-Id: <20220202095100.129834-4-vkuznets@redhat.com>
In-Reply-To: <20220202095100.129834-1-vkuznets@redhat.com>
References: <20220202095100.129834-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation to implementing Enlightened MSR-Bitmap feature for Hyper-V
on KVM, split off the required definitions into common 'svm/hyperv.h'
header.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/hyperv.h       | 35 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm_onhyperv.h | 25 +----------------------
 2 files changed, 36 insertions(+), 24 deletions(-)
 create mode 100644 arch/x86/kvm/svm/hyperv.h

diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
new file mode 100644
index 000000000000..7d6d97968fb9
--- /dev/null
+++ b/arch/x86/kvm/svm/hyperv.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Common Hyper-V on KVM and KVM on Hyper-V definitions (SVM).
+ */
+
+#ifndef __ARCH_X86_KVM_SVM_HYPERV_H__
+#define __ARCH_X86_KVM_SVM_HYPERV_H__
+
+#include <asm/mshyperv.h>
+
+#include "../hyperv.h"
+
+/*
+ * Hyper-V uses the software reserved 32 bytes in VMCB
+ * control area to expose SVM enlightenments to guests.
+ */
+struct hv_enlightenments {
+	struct __packed hv_enlightenments_control {
+		u32 nested_flush_hypercall:1;
+		u32 msr_bitmap:1;
+		u32 enlightened_npt_tlb: 1;
+		u32 reserved:29;
+	} __packed hv_enlightenments_control;
+	u32 hv_vp_id;
+	u64 hv_vm_id;
+	u64 partition_assist_page;
+	u64 reserved;
+} __packed;
+
+/*
+ * Hyper-V uses the software reserved clean bit in VMCB
+ */
+#define VMCB_HV_NESTED_ENLIGHTENMENTS VMCB_SW
+
+#endif /* __ARCH_X86_KVM_SVM_HYPERV_H__ */
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index c53b8bf8d013..c787c032f68d 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -7,35 +7,12 @@
 #define __ARCH_X86_KVM_SVM_ONHYPERV_H__
 
 #if IS_ENABLED(CONFIG_HYPERV)
-#include <asm/mshyperv.h>
 
-#include "hyperv.h"
 #include "kvm_onhyperv.h"
+#include "svm/hyperv.h"
 
 static struct kvm_x86_ops svm_x86_ops;
 
-/*
- * Hyper-V uses the software reserved 32 bytes in VMCB
- * control area to expose SVM enlightenments to guests.
- */
-struct hv_enlightenments {
-	struct __packed hv_enlightenments_control {
-		u32 nested_flush_hypercall:1;
-		u32 msr_bitmap:1;
-		u32 enlightened_npt_tlb: 1;
-		u32 reserved:29;
-	} __packed hv_enlightenments_control;
-	u32 hv_vp_id;
-	u64 hv_vm_id;
-	u64 partition_assist_page;
-	u64 reserved;
-} __packed;
-
-/*
- * Hyper-V uses the software reserved clean bit in VMCB
- */
-#define VMCB_HV_NESTED_ENLIGHTENMENTS VMCB_SW
-
 int svm_hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu);
 
 static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
-- 
2.34.1

