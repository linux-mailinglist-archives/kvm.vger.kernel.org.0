Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 069FE1502FD
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 10:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgBCJJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 04:09:34 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58268 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727599AbgBCJJd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Feb 2020 04:09:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580720972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F6gihr51hzrmDVnwI47jvfr4fHpjoQrzs19cP1GQvt0=;
        b=Kfdsiqm6n94DAKxFjzIJ1/GFM4exAALVdva6qAPpYiT5IpoHQf5erVKijpLBXO7wIu4gOB
        E0jiNLT5jwTGbMDKs3jnMmmYbX1Bb8WOb0nvUhypMlIJy9qB/WHC++IsYW3qB1wtIExnDd
        8Tf1ObpaIyLH8xdajL7PMFiKWr5Fqf0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-_GTXD0wlMx2wGAeyYBW4EA-1; Mon, 03 Feb 2020 04:09:31 -0500
X-MC-Unique: _GTXD0wlMx2wGAeyYBW4EA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41C4B8017CC;
        Mon,  3 Feb 2020 09:09:30 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D72819C58;
        Mon,  3 Feb 2020 09:09:25 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com
Cc:     thuth@redhat.com, drjones@redhat.com, wei.huang2@amd.com
Subject: [PATCH v2 2/2] selftests: KVM: SVM: Add vmcall test
Date:   Mon,  3 Feb 2020 10:08:51 +0100
Message-Id: <20200203090851.19938-3-eric.auger@redhat.com>
In-Reply-To: <20200203090851.19938-1-eric.auger@redhat.com>
References: <20200203090851.19938-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

L2 guest calls vmcall and L1 checks the exit status does
correspond.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/x86_64/svm_vmcall_test.c    | 86 +++++++++++++++++++
 2 files changed, 87 insertions(+)
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
index 000000000000..75e66f3bbbc0
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
@@ -0,0 +1,86 @@
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
+#include "svm.h"
+
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include "kselftest.h"
+#include <linux/kernel.h>
+
+#define VCPU_ID		5
+
+/* The virtual machine object. */
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

