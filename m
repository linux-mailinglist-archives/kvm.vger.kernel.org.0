Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322D44A829F
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 11:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245097AbiBCKqg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 05:46:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:20993 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244599AbiBCKqd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Feb 2022 05:46:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643885192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HIGCUS8bQgERjLHfTgr1bNSCzwGExT4QqZtXy2iYyz4=;
        b=VbnkJaIrYZ/qoWKQeqJ3wr93h6G3RqOwipM0891ywhHYXD+I//BXOBbCKDOracmKMT7sVr
        RIWwFUuxjK656epLzHmTENsS2fqDkFZWSQCgdals53aa9Yb+wN6YbW5UDcLz/o9sUeMzrq
        0fHRiiNHIV2ANTStV9LvKgCljmQPnac=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-iA1wsGRmP9mbkop-du_aIg-1; Thu, 03 Feb 2022 05:46:31 -0500
X-MC-Unique: iA1wsGRmP9mbkop-du_aIg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 814DC1091DA0;
        Thu,  3 Feb 2022 10:46:30 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A15F9108B4;
        Thu,  3 Feb 2022 10:46:28 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] KVM: selftests: nVMX: Add enlightened MSR-Bitmap selftest
Date:   Thu,  3 Feb 2022 11:46:17 +0100
Message-Id: <20220203104620.277031-4-vkuznets@redhat.com>
In-Reply-To: <20220203104620.277031-1-vkuznets@redhat.com>
References: <20220203104620.277031-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a test for enlightened MSR-Bitmap feature (Hyper-V on KVM):
- Intercept access to MSR_FS_BASE in L1 and check that this works
 with enlightened MSR-Bitmap disabled.
- Enabled enlightened MSR-Bitmap and check that the intercept still works
as expected.
- Intercept access to MSR_GS_BASE but don't clear the corresponding bit
from 'hv_clean_fields', KVM is supposed to skip updating MSR-Bitmap02 and
thus the consequent access to the MSR from L2 will not get intercepted.
- Finally, clear the corresponding bit from 'hv_clean_fields' and check
that access to MSR_GS_BASE is now intercepted.

The test works with the assumption, that access to MSR_FS_BASE/MSR_GS_BASE
is not intercepted for L1. If this ever becomes not true the test will
fail as nested_vmx_exit_handled_msr() always checks L1's MSR-Bitmap for
L2 irrespective of 'hv_clean_fields'. The behavior is correct as
enlightened MSR-Bitmap feature is just an optimization, KVM is not obliged
to ignore updates when the corresponding bit in 'hv_clean_fields' stays
clear.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../testing/selftests/kvm/x86_64/evmcs_test.c | 59 +++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index 655104051819..d12e043aa2ee 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -10,6 +10,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <sys/ioctl.h>
+#include <linux/bitmap.h>
 
 #include "test_util.h"
 
@@ -32,6 +33,22 @@ static void guest_nmi_handler(struct ex_regs *regs)
 {
 }
 
+/* Exits to L1 destroy GRPs! */
+static inline void rdmsr_fs_base(void)
+{
+	__asm__ __volatile__ ("mov $0xc0000100, %%rcx; rdmsr" : : :
+			      "rax", "rbx", "rcx", "rdx",
+			      "rsi", "rdi", "r8", "r9", "r10", "r11", "r12",
+			      "r13", "r14", "r15");
+}
+static inline void rdmsr_gs_base(void)
+{
+	__asm__ __volatile__ ("mov $0xc0000101, %%rcx; rdmsr" : : :
+			      "rax", "rbx", "rcx", "rdx",
+			      "rsi", "rdi", "r8", "r9", "r10", "r11", "r12",
+			      "r13", "r14", "r15");
+}
+
 void l2_guest_code(void)
 {
 	GUEST_SYNC(7);
@@ -41,6 +58,15 @@ void l2_guest_code(void)
 	/* Forced exit to L1 upon restore */
 	GUEST_SYNC(9);
 
+	vmcall();
+
+	/* MSR-Bitmap tests */
+	rdmsr_fs_base(); /* intercepted */
+	rdmsr_fs_base(); /* intercepted */
+	rdmsr_gs_base(); /* not intercepted */
+	vmcall();
+	rdmsr_gs_base(); /* intercepted */
+
 	/* Done, exit to L1 and never come back.  */
 	vmcall();
 }
@@ -91,6 +117,39 @@ void guest_code(struct vmx_pages *vmx_pages)
 
 	GUEST_SYNC(10);
 
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
+	current_evmcs->guest_rip += 3; /* vmcall */
+
+	/* Intercept RDMSR 0xc0000100 */
+	vmwrite(CPU_BASED_VM_EXEC_CONTROL, vmreadz(CPU_BASED_VM_EXEC_CONTROL) |
+		CPU_BASED_USE_MSR_BITMAPS);
+	set_bit(MSR_FS_BASE & 0x1fff, vmx_pages->msr + 0x400);
+	GUEST_ASSERT(!vmresume());
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_MSR_READ);
+	current_evmcs->guest_rip += 2; /* rdmsr */
+
+	/* Enable enlightened MSR bitmap */
+	current_evmcs->hv_enlightenments_control.msr_bitmap = 1;
+	GUEST_ASSERT(!vmresume());
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_MSR_READ);
+	current_evmcs->guest_rip += 2; /* rdmsr */
+
+	/* Intercept RDMSR 0xc0000101 without telling KVM about it */
+	set_bit(MSR_GS_BASE & 0x1fff, vmx_pages->msr + 0x400);
+	/* Make sure HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP is set */
+	current_evmcs->hv_clean_fields |= HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP;
+	GUEST_ASSERT(!vmresume());
+	/* Make sure we don't see EXIT_REASON_MSR_READ here so eMSR bitmap works */
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
+	current_evmcs->guest_rip += 3; /* vmcall */
+
+	/* Now tell KVM we've changed MSR-Bitmap */
+	current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP;
+	GUEST_ASSERT(!vmresume());
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_MSR_READ);
+	current_evmcs->guest_rip += 2; /* rdmsr */
+
+	GUEST_ASSERT(!vmresume());
 	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
 	GUEST_SYNC(11);
 
-- 
2.34.1

