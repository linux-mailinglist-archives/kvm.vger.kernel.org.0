Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACE157EA21
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 01:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236514AbiGVXC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 19:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236724AbiGVXC4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 19:02:56 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9FBE8C5B2
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 16:02:55 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id p10-20020a170902e74a00b0016c3f3acb51so3281966plf.16
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 16:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=93pRDb/hhCi6rn7HrzOWCC1IRMMdq/ahH9HJBQp/dJg=;
        b=EUvosg4JwWCErsar9boMExIxd60trxESqOUvfC4H7XMTC55998ES0+6EaKk32Yx4YJ
         BOBys09yAI3hZK/BjMEiyUcHPvh3D/BXi7DAVvAtcpu2eWLQZ0YkhcHrVH3zSNksmjKa
         cuVHaBmIQBHZpy4oogMHMpxdPNPhaxDBwnziDcvMiUoorLSx2LhPnOt7FYv6EaWca+ez
         Y/FTlRddDDLDb7zJzq6+XHgGQXg+9b5hiVjj/0Fcy3KETz7WmM8GLsLL1ztkAz95DHtj
         eIAqRvf41WwdGlp4bo6xZeEhzPCDhUlTAQhDeVquikPqpyxtqTg+RZbFo4aaTuztDRD/
         9F6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=93pRDb/hhCi6rn7HrzOWCC1IRMMdq/ahH9HJBQp/dJg=;
        b=P229tOFWLsWrsm0cl/S+dy9/fuyYcnf3aIpUfCxyBUEEqwA3Ozu9AalpLu1QiTBUH9
         E4SevuLTLZ5YHl2L2a+1UHePNBXelEqBDff0OENjoD94dq1MjnXakq+V0nYkEMVWkFjm
         zFpQat8HFNpn3Ml1VpPTe7DRvLyyjeSG0mi3jDNZ04RoOYvPEkw2BAmbWlGgUJ5HrDzM
         xjZzbBaOPcqJQ1vWD+p47m8mQ8OsSGDUyu2CxWOJd92eqNWLatZN+BCTfvoJI6dQozxv
         wIic+sPhy+0IXv4fL+hoePcwmarDlUez588zRKAfnDr+TuYqBTsk6v1pxLNDggKeyQFb
         MYKQ==
X-Gm-Message-State: AJIora9PxA/6V2/Mkq5nIAUjHtZ+NmsdH4zpvbf3xL9KdS6H1innytPb
        J6gKy4daO/AnQZOgK5Zt9JWrW2XwpH8=
X-Google-Smtp-Source: AGRyM1tuB8T8+TDU+/wEL8IXih3eYVfU3anj1QMIw6F2QkJkLQSIMsTOL2fMQGKvm9YOxs+SKE2f668OjKA=
X-Received: from avagin.kir.corp.google.com ([2620:15c:29:204:5863:d08b:b2f8:4a3e])
 (user=avagin job=sendgmr) by 2002:a17:902:cf0e:b0:16d:2517:845 with SMTP id
 i14-20020a170902cf0e00b0016d25170845mr1737227plg.62.1658530975445; Fri, 22
 Jul 2022 16:02:55 -0700 (PDT)
Date:   Fri, 22 Jul 2022 16:02:39 -0700
In-Reply-To: <20220722230241.1944655-1-avagin@google.com>
Message-Id: <20220722230241.1944655-4-avagin@google.com>
Mime-Version: 1.0
References: <20220722230241.1944655-1-avagin@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH 3/5] KVM/x86: add a new hypercall to execute host system calls.
From:   Andrei Vagin <avagin@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrei Vagin <avagin@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jianfeng Tan <henry.tjf@antfin.com>,
        Adin Scannell <ascannell@google.com>,
        Konstantin Bogomolov <bogomolov@google.com>,
        Etienne Perot <eperot@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is a class of applications that use KVM to manage multiple address
spaces rather than use it as an isolation boundary. In all other terms,
they are normal processes that execute system calls, handle signals,
etc. Currently, each time when such a process needs to interact with the
operation system, it has to switch to host and back to guest. Such
entire switches are expensive and significantly increase the overhead of
system calls. The new hypercall reduces this overhead by more than two
times.

The new hypercall allows to execute host system calls. As for native
calls, seccomp filters are executed before calls.  It takes one argument
that is a pointer to a pt_regs structure in the host address space. It
provides registers to execute a system call according to the calling
convention. Arguments are passed in %rdi, %rsi, %rdx, %r10, %r8 and %r9
and then a return code is stored in %rax.=C2=A0

The hypercall returns 0 if a system call has been executed. Otherwise,
it returns an error code.

Signed-off-by: Andrei Vagin <avagin@google.com>
---
 Documentation/virt/kvm/x86/hypercalls.rst | 18 +++++++++++++
 arch/x86/kvm/x86.c                        | 33 +++++++++++++++++++++++
 include/uapi/linux/kvm_para.h             |  1 +
 3 files changed, 52 insertions(+)

diff --git a/Documentation/virt/kvm/x86/hypercalls.rst b/Documentation/virt=
/kvm/x86/hypercalls.rst
index e56fa8b9cfca..eb18f2128bfe 100644
--- a/Documentation/virt/kvm/x86/hypercalls.rst
+++ b/Documentation/virt/kvm/x86/hypercalls.rst
@@ -190,3 +190,21 @@ the KVM_CAP_EXIT_HYPERCALL capability. Userspace must =
enable that capability
 before advertising KVM_FEATURE_HC_MAP_GPA_RANGE in the guest CPUID.  In
 addition, if the guest supports KVM_FEATURE_MIGRATION_CONTROL, userspace
 must also set up an MSR filter to process writes to MSR_KVM_MIGRATION_CONT=
ROL.
+
+9. KVM_HC_HOST_SYSCALL
+---------------------
+:Architecture: x86
+:Status: active
+:Purpose: Execute a specified system call.
+
+- a0: pointer to a pt_regs structure in the host addess space.
+
+This hypercall lets a guest to execute host system calls. The first and on=
ly
+argument represents process registers that are used as input and output
+parameters.
+
+Returns 0 if the requested syscall has been executed. Otherwise, it return=
s an
+error code.
+
+**Implementation note**: The KVM_CAP_PV_HOST_SYSCALL capability has to be =
set
+to use this hypercall.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 19e634768161..aa54e180c9d4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -81,6 +81,7 @@
 #include <asm/emulate_prefix.h>
 #include <asm/sgx.h>
 #include <clocksource/hyperv_timer.h>
+#include <asm/syscall.h>
=20
 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -9253,6 +9254,27 @@ static int complete_hypercall_exit(struct kvm_vcpu *=
vcpu)
 	return kvm_skip_emulated_instruction(vcpu);
 }
=20
+static int kvm_pv_host_syscall(unsigned long a0)
+{
+	struct pt_regs pt_regs =3D {};
+	unsigned long sysno;
+
+	if (copy_from_user(&pt_regs, (void *)a0, sizeof(pt_regs)))
+		return -EFAULT;
+
+	sysno =3D pt_regs.ax;
+	pt_regs.orig_ax =3D pt_regs.ax;
+	pt_regs.ax =3D -ENOSYS;
+
+	do_ksyscall_64(sysno, &pt_regs);
+
+	pt_regs.orig_ax =3D -1;
+	if (copy_to_user((void *)a0, &pt_regs, sizeof(pt_regs)))
+		return -EFAULT;
+
+	return 0;
+}
+
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
 	unsigned long nr, a0, a1, a2, a3, ret;
@@ -9318,6 +9340,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		kvm_sched_yield(vcpu, a0);
 		ret =3D 0;
 		break;
+
 	case KVM_HC_MAP_GPA_RANGE: {
 		u64 gpa =3D a0, npages =3D a1, attrs =3D a2;
=20
@@ -9340,6 +9363,16 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		vcpu->arch.complete_userspace_io =3D complete_hypercall_exit;
 		return 0;
 	}
+
+	case KVM_HC_HOST_SYSCALL:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_HOST_SYSCALL))
+			break;
+
+		kvm_vcpu_srcu_read_unlock(vcpu);
+		ret =3D kvm_pv_host_syscall(a0);
+		kvm_vcpu_srcu_read_lock(vcpu);
+		break;
+
 	default:
 		ret =3D -KVM_ENOSYS;
 		break;
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 960c7e93d1a9..3fcfb3241f35 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -30,6 +30,7 @@
 #define KVM_HC_SEND_IPI		10
 #define KVM_HC_SCHED_YIELD		11
 #define KVM_HC_MAP_GPA_RANGE		12
+#define KVM_HC_HOST_SYSCALL		13
=20
 /*
  * hypercalls use architecture specific
--=20
2.37.1.359.gd136c6c3e2-goog

