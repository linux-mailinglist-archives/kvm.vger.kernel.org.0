Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D172154254
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 11:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbgBFKrq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 05:47:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60444 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728319AbgBFKrp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 05:47:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580986065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ewpivZESotMD79J0VWILRYzsWscgyt+xFYuSgg9jkN4=;
        b=QJRLoi7SrjEROXln3phXJfEphoZzVJgNoHJZWO+1AVPvmKqf5h9f2jaqW32vMiG4KTHZG7
        Ak+XbHJreEXErfc3cf+9syF1WW5HCVr9JsDYKC9lr/mcLQYpfy9YUYeykkKjWPZNnBePbB
        R5K7EiPzrVe97gpvCI2LfDbc2YcYVG0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-0Ns3quFKMgOTftDJ9BlpkA-1; Thu, 06 Feb 2020 05:47:40 -0500
X-MC-Unique: 0Ns3quFKMgOTftDJ9BlpkA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E056D1922961;
        Thu,  6 Feb 2020 10:47:38 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B7D28E9EA;
        Thu,  6 Feb 2020 10:47:30 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com
Cc:     thuth@redhat.com, drjones@redhat.com, wei.huang2@amd.com
Subject: [PATCH v4 3/3] selftests: KVM: SVM: Add vmcall test
Date:   Thu,  6 Feb 2020 11:47:10 +0100
Message-Id: <20200206104710.16077-4-eric.auger@redhat.com>
In-Reply-To: <20200206104710.16077-1-eric.auger@redhat.com>
References: <20200206104710.16077-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

L2 guest calls vmcall and L1 checks the exit status does
correspond.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

---

v3 -> v4:
- remove useless includes
- collected Lin's R-b

v2 -> v3:
- remove useless comment and add Vitaly's R-b
---
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/x86_64/svm_vmcall_test.c    | 79 +++++++++++++++++++
 2 files changed, 80 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftes=
ts/kvm/Makefile
index 2e770f554cae..b529d3b42c02 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -26,6 +26,7 @@ TEST_GEN_PROGS_x86_64 +=3D x86_64/vmx_dirty_log_test
 TEST_GEN_PROGS_x86_64 +=3D x86_64/vmx_set_nested_state_test
 TEST_GEN_PROGS_x86_64 +=3D x86_64/vmx_tsc_adjust_test
 TEST_GEN_PROGS_x86_64 +=3D x86_64/xss_msr_test
+TEST_GEN_PROGS_x86_64 +=3D x86_64/svm_vmcall_test
 TEST_GEN_PROGS_x86_64 +=3D clear_dirty_log_test
 TEST_GEN_PROGS_x86_64 +=3D dirty_log_test
 TEST_GEN_PROGS_x86_64 +=3D kvm_create_max_vcpus
diff --git a/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c b/tools=
/testing/selftests/kvm/x86_64/svm_vmcall_test.c
new file mode 100644
index 000000000000..6d3565aab94e
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
@@ -0,0 +1,79 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * svm_vmcall_test
+ *
+ * Copyright (C) 2020, Red Hat, Inc.
+ *
+ * Nested SVM testing: VMCALL
+ */
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "svm_util.h"
+
+#define VCPU_ID		5
+
+static struct kvm_vm *vm;
+
+static inline void l2_vmcall(struct svm_test_data *svm)
+{
+	__asm__ __volatile__("vmcall");
+}
+
+static void l1_guest_code(struct svm_test_data *svm)
+{
+	#define L2_GUEST_STACK_SIZE 64
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	struct vmcb *vmcb =3D svm->vmcb;
+
+	/* Prepare for L2 execution. */
+	generic_svm_setup(svm, l2_vmcall,
+			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	run_guest(vmcb, svm->vmcb_gpa);
+
+	GUEST_ASSERT(vmcb->control.exit_code =3D=3D SVM_EXIT_VMMCALL);
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	vm_vaddr_t svm_gva;
+
+	nested_svm_check_supported();
+
+	vm =3D vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
+	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+
+	vcpu_alloc_svm(vm, &svm_gva);
+	vcpu_args_set(vm, VCPU_ID, 1, svm_gva);
+
+	for (;;) {
+		volatile struct kvm_run *run =3D vcpu_state(vm, VCPU_ID);
+		struct ucall uc;
+
+		vcpu_run(vm, VCPU_ID);
+		TEST_ASSERT(run->exit_reason =3D=3D KVM_EXIT_IO,
+			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
+			    run->exit_reason,
+			    exit_reason_str(run->exit_reason));
+
+		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		case UCALL_ABORT:
+			TEST_ASSERT(false, "%s",
+				    (const char *)uc.args[0]);
+			/* NOT REACHED */
+		case UCALL_SYNC:
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_ASSERT(false,
+				    "Unknown ucall 0x%x.", uc.cmd);
+		}
+	}
+done:
+	kvm_vm_free(vm);
+	return 0;
+}
--=20
2.20.1

