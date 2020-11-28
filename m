Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BE82C7451
	for <lists+kvm@lfdr.de>; Sat, 28 Nov 2020 23:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgK1Vtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Nov 2020 16:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728509AbgK1SA2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Nov 2020 13:00:28 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C254C02A1A5
        for <kvm@vger.kernel.org>; Sat, 28 Nov 2020 06:21:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Mime-Version:Content-Type:Date:Cc:To:
        From:Subject:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=AeBJc+e8OUEXilt5ZFeyUNpkWH7vDGBtJ9JMBH6p/5U=; b=ueo0x5db9XtswDUJrMFxScOiUw
        77V1IECJXVrq0PE2ieDs0nqwT2tExN+cNGJYDX+54v+7A3Zsp5GAQ2DMugmvof7bMyIDvBOuXtXJU
        yXZzHvqxN/9hPxmb2Pq4cArnr22kEAANC07FxejJO7SP1RSbcEmNOQ2XxwMrQhWsiQHT6Z7jO5kpJ
        VCdJqmfleGLqa6/htcUigc/bUrl6GUwIMYt6LF5xrujXKv84wPH+LlRiagKtXI1hpvGA9UI51ySTP
        AVxoiXNn7i5rszrNkEfdktW26EgHlsfN0wCz6DTF85DZR51lRdemBhKfJkmV6ZxVVxzqOL4P8XKu/
        EM+AoJXw==;
Received: from 54-240-197-236.amazon.com ([54.240.197.236] helo=freeip.amazon.com)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kj15v-0005WU-Rb; Sat, 28 Nov 2020 14:21:00 +0000
Message-ID: <1bde4a992be29581e559f7a57818e206e11f84f5.camel@infradead.org>
Subject: [PATCH] KVM: x86: Reinstate userspace hypercall support
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date:   Sat, 28 Nov 2020 14:20:58 +0000
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-CoAmMQw36mtebGJXAOO2"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-CoAmMQw36mtebGJXAOO2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Woodhouse <dwmw@amazon.co.uk>

For supporting Xen guests we really want to be able to use vmcall/vmmcall
for hypercalls as Xen itself does. Reinstate the KVM_EXIT_HYPERCALL
support that Anthony ripped out in 2007.

Yes, we *could* make it work with KVM_EXIT_IO if we really had to, but
that makes it guest-visible and makes it distinctly non-trivial to do
live migration from Xen because we'd have to update the hypercall page(s)
(which are at unknown locations) as well as dealing with any guest RIP
which happens to be *in* a hypercall page at the time.

We also actively want to *prevent* the KVM hypercalls from suddenly
becoming available to guests which think they are Xen guests, which
this achieves too.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
Should this test work OK on AMD? I see a separate test which is
explicitly testing VMCALL on AMD, which makes me suspect it's expected
to work as well as VMMCALL?

Do we have the test infrastructure for running 32-bit guests easily?

 Documentation/virt/kvm/api.rst                | 23 +++--
 arch/x86/include/asm/kvm_host.h               |  1 +
 arch/x86/kvm/x86.c                            | 46 +++++++++
 include/uapi/linux/kvm.h                      |  1 +
 tools/include/uapi/linux/kvm.h                | 57 ++++++++++-
 tools/testing/selftests/kvm/.gitignore        |  1 +
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/x86_64/user_vmcall_test.c   | 94 +++++++++++++++++++
 8 files changed, 214 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/user_vmcall_test.c

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rs=
t
index 70254eaa5229..fa9160920a08 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4990,13 +4990,13 @@ to the byte array.
=20
 .. note::
=20
-      For KVM_EXIT_IO, KVM_EXIT_MMIO, KVM_EXIT_OSI, KVM_EXIT_PAPR,
-      KVM_EXIT_EPR, KVM_EXIT_X86_RDMSR and KVM_EXIT_X86_WRMSR the correspo=
nding
-      operations are complete (and guest state is consistent) only after u=
serspace
-      has re-entered the kernel with KVM_RUN.  The kernel side will first =
finish
-      incomplete operations and then check for pending signals.  Userspace
-      can re-enter the guest with an unmasked signal pending to complete
-      pending operations.
+      For KVM_EXIT_IO, KVM_EXIT_MMIO, KVM_EXIT_OSI, KVM_EXIT_PAPR, KVM_EXI=
T_EPR,
+      KVM_EXIT_HYPERCALL, KVM_EXIT_X86_RDMSR and KVM_EXIT_X86_WRMSR the
+      corresponding operations are complete (and guest state is consistent=
) only
+      after userspace has re-entered the kernel with KVM_RUN.  The kernel =
side
+      will first finish incomplete operations and then check for pending s=
ignals.
+      Userspace can re-enter the guest with an unmasked signal pending to
+      complete pending operations.
=20
 ::
=20
@@ -5009,8 +5009,13 @@ to the byte array.
 			__u32 pad;
 		} hypercall;
=20
-Unused.  This was once used for 'hypercall to userspace'.  To implement
-such functionality, use KVM_EXIT_IO (x86) or KVM_EXIT_MMIO (all except s39=
0).
+This occurs when KVM_CAP_X86_USER_SPACE_HYPERCALL is enabled and the vcpu =
has
+executed a VMCALL(Intel) or VMMCALL(AMD) instruction. The arguments are ta=
ken
+from the vcpu registers in accordance with the Xen hypercall ABI.
+
+Except for compatibility with existing hypervisors such as Xen, userspace
+handling of hypercalls is discouraged. To implement such functionality,
+use KVM_EXIT_IO (x86) or KVM_EXIT_MMIO (all except s390).
=20
 .. note:: KVM_EXIT_IO is significantly faster than KVM_EXIT_MMIO.
=20
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index f002cdb13a0b..a6f72adc48cd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -984,6 +984,7 @@ struct kvm_arch {
=20
 	bool guest_can_read_msr_platform_info;
 	bool exception_payload_enabled;
+	bool user_space_hypercall;
=20
 	/* Deflect RDMSR and WRMSR to user space when they trigger a #GP */
 	u32 user_space_msr_mask;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a3fdc16cfd6f..e8c5c079a85d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3755,6 +3755,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, lon=
g ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_LAST_CPU:
 	case KVM_CAP_X86_USER_SPACE_MSR:
+	case KVM_CAP_X86_USER_SPACE_HYPERCALL:
 	case KVM_CAP_X86_MSR_FILTER:
 	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
 		r =3D 1;
@@ -5275,6 +5276,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.user_space_msr_mask =3D cap->args[0];
 		r =3D 0;
 		break;
+	case KVM_CAP_X86_USER_SPACE_HYPERCALL:
+		kvm->arch.user_space_hypercall =3D cap->args[0];
+		r =3D 0;
+		break;
 	default:
 		r =3D -EINVAL;
 		break;
@@ -8063,11 +8068,52 @@ static void kvm_sched_yield(struct kvm *kvm, unsign=
ed long dest_id)
 		kvm_vcpu_yield_to(target);
 }
=20
+static int complete_userspace_hypercall(struct kvm_vcpu *vcpu)
+{
+	kvm_rax_write(vcpu, vcpu->run->hypercall.ret);
+
+	return kvm_skip_emulated_instruction(vcpu);
+}
+
+int kvm_userspace_hypercall(struct kvm_vcpu *vcpu)
+{
+	struct kvm_run *run =3D vcpu->run;
+
+	if (is_long_mode(vcpu)) {
+		run->hypercall.longmode =3D 1;
+		run->hypercall.nr =3D kvm_rax_read(vcpu);
+		run->hypercall.args[0] =3D kvm_rdi_read(vcpu);
+		run->hypercall.args[1] =3D kvm_rsi_read(vcpu);
+		run->hypercall.args[2] =3D kvm_rdx_read(vcpu);
+		run->hypercall.args[3] =3D kvm_r10_read(vcpu);
+		run->hypercall.args[4] =3D kvm_r8_read(vcpu);
+		run->hypercall.args[5] =3D kvm_r9_read(vcpu);
+		run->hypercall.ret =3D -KVM_ENOSYS;
+	} else {
+		run->hypercall.longmode =3D 0;
+		run->hypercall.nr =3D (u32)kvm_rbx_read(vcpu);
+		run->hypercall.args[0] =3D (u32)kvm_rbx_read(vcpu);
+		run->hypercall.args[1] =3D (u32)kvm_rcx_read(vcpu);
+		run->hypercall.args[2] =3D (u32)kvm_rdx_read(vcpu);
+		run->hypercall.args[3] =3D (u32)kvm_rsi_read(vcpu);
+		run->hypercall.args[4] =3D (u32)kvm_rdi_read(vcpu);
+		run->hypercall.args[5] =3D (u32)kvm_rbp_read(vcpu);
+		run->hypercall.ret =3D (u32)-KVM_ENOSYS;
+	}
+	run->exit_reason =3D KVM_EXIT_HYPERCALL;
+	vcpu->arch.complete_userspace_io =3D complete_userspace_hypercall;
+
+	return 0;
+}
+
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
 	unsigned long nr, a0, a1, a2, a3, ret;
 	int op_64_bit;
=20
+	if (vcpu->kvm->arch.user_space_hypercall)
+		return kvm_userspace_hypercall(vcpu);
+
 	if (kvm_hv_hypercall_enabled(vcpu->kvm))
 		return kvm_hv_hypercall(vcpu);
=20
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 886802b8ffba..e01b679e0132 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1056,6 +1056,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
 #define KVM_CAP_SYS_HYPERV_CPUID 191
 #define KVM_CAP_DIRTY_LOG_RING 192
+#define KVM_CAP_X86_USER_SPACE_HYPERCALL 193
=20
 #ifdef KVM_CAP_IRQ_ROUTING
=20
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.=
h
index ca41220b40b8..e01b679e0132 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -250,6 +250,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_ARM_NISV         28
 #define KVM_EXIT_X86_RDMSR        29
 #define KVM_EXIT_X86_WRMSR        30
+#define KVM_EXIT_DIRTY_RING_FULL  31
=20
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -1053,6 +1054,9 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_X86_USER_SPACE_MSR 188
 #define KVM_CAP_X86_MSR_FILTER 189
 #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
+#define KVM_CAP_SYS_HYPERV_CPUID 191
+#define KVM_CAP_DIRTY_LOG_RING 192
+#define KVM_CAP_X86_USER_SPACE_HYPERCALL 193
=20
 #ifdef KVM_CAP_IRQ_ROUTING
=20
@@ -1511,7 +1515,7 @@ struct kvm_enc_region {
 /* Available with KVM_CAP_MANUAL_DIRTY_LOG_PROTECT_2 */
 #define KVM_CLEAR_DIRTY_LOG          _IOWR(KVMIO, 0xc0, struct kvm_clear_d=
irty_log)
=20
-/* Available with KVM_CAP_HYPERV_CPUID */
+/* Available with KVM_CAP_HYPERV_CPUID (vcpu) / KVM_CAP_SYS_HYPERV_CPUID (=
system) */
 #define KVM_GET_SUPPORTED_HV_CPUID _IOWR(KVMIO, 0xc1, struct kvm_cpuid2)
=20
 /* Available with KVM_CAP_ARM_SVE */
@@ -1557,6 +1561,9 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_X86_MSR_FILTER */
 #define KVM_X86_SET_MSR_FILTER	_IOW(KVMIO,  0xc6, struct kvm_msr_filter)
=20
+/* Available with KVM_CAP_DIRTY_LOG_RING */
+#define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc7)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
@@ -1710,4 +1717,52 @@ struct kvm_hyperv_eventfd {
 #define KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE    (1 << 0)
 #define KVM_DIRTY_LOG_INITIALLY_SET            (1 << 1)
=20
+/*
+ * Arch needs to define the macro after implementing the dirty ring
+ * feature.  KVM_DIRTY_LOG_PAGE_OFFSET should be defined as the
+ * starting page offset of the dirty ring structures.
+ */
+#ifndef KVM_DIRTY_LOG_PAGE_OFFSET
+#define KVM_DIRTY_LOG_PAGE_OFFSET 0
+#endif
+
+/*
+ * KVM dirty GFN flags, defined as:
+ *
+ * |---------------+---------------+--------------|
+ * | bit 1 (reset) | bit 0 (dirty) | Status       |
+ * |---------------+---------------+--------------|
+ * |             0 |             0 | Invalid GFN  |
+ * |             0 |             1 | Dirty GFN    |
+ * |             1 |             X | GFN to reset |
+ * |---------------+---------------+--------------|
+ *
+ * Lifecycle of a dirty GFN goes like:
+ *
+ *      dirtied         harvested        reset
+ * 00 -----------> 01 -------------> 1X -------+
+ *  ^                                          |
+ *  |                                          |
+ *  +------------------------------------------+
+ *
+ * The userspace program is only responsible for the 01->1X state
+ * conversion after harvesting an entry.  Also, it must not skip any
+ * dirty bits, so that dirty bits are always harvested in sequence.
+ */
+#define KVM_DIRTY_GFN_F_DIRTY           BIT(0)
+#define KVM_DIRTY_GFN_F_RESET           BIT(1)
+#define KVM_DIRTY_GFN_F_MASK            0x3
+
+/*
+ * KVM dirty rings should be mapped at KVM_DIRTY_LOG_PAGE_OFFSET of
+ * per-vcpu mmaped regions as an array of struct kvm_dirty_gfn.  The
+ * size of the gfn buffer is decided by the first argument when
+ * enabling KVM_CAP_DIRTY_LOG_RING.
+ */
+struct kvm_dirty_gfn {
+	__u32 flags;
+	__u32 slot;
+	__u64 offset;
+};
+
 #endif /* __LINUX_KVM_H */
diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftes=
ts/kvm/.gitignore
index 5468db7dd674..3c715f6491c1 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -18,6 +18,7 @@
 /x86_64/sync_regs_test
 /x86_64/tsc_msrs_test
 /x86_64/user_msr_test
+/x86_64/user_vmcall_test
 /x86_64/vmx_apic_access_test
 /x86_64/vmx_close_while_nested_test
 /x86_64/vmx_dirty_log_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests=
/kvm/Makefile
index 4febf4d5ead9..c7468eb1dcf0 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -59,6 +59,7 @@ TEST_GEN_PROGS_x86_64 +=3D x86_64/xss_msr_test
 TEST_GEN_PROGS_x86_64 +=3D x86_64/debug_regs
 TEST_GEN_PROGS_x86_64 +=3D x86_64/tsc_msrs_test
 TEST_GEN_PROGS_x86_64 +=3D x86_64/user_msr_test
+TEST_GEN_PROGS_x86_64 +=3D x86_64/user_vmcall_test
 TEST_GEN_PROGS_x86_64 +=3D demand_paging_test
 TEST_GEN_PROGS_x86_64 +=3D dirty_log_test
 TEST_GEN_PROGS_x86_64 +=3D dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/x86_64/user_vmcall_test.c b/tools/=
testing/selftests/kvm/x86_64/user_vmcall_test.c
new file mode 100644
index 000000000000..e6286e5d5294
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/user_vmcall_test.c
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * user_vmcall_test
+ *
+ * Copyright =C2=A9 2020 Amazon.com, Inc. or its affiliates.
+ *
+ * Userspace hypercall testing
+ */
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+#define VCPU_ID		5
+
+static struct kvm_vm *vm;
+
+#define ARGVALUE(x) (0xdeadbeef5a5a0000UL + x)
+#define RETVALUE 0xcafef00dfbfbffffUL
+
+static void guest_code(void)
+{
+	unsigned long rax =3D ARGVALUE(1);
+	unsigned long rdi =3D ARGVALUE(2);
+	unsigned long rsi =3D ARGVALUE(3);
+	unsigned long rdx =3D ARGVALUE(4);
+	register unsigned long r10 __asm__("r10") =3D ARGVALUE(5);
+	register unsigned long r8 __asm__("r8") =3D ARGVALUE(6);
+	register unsigned long r9 __asm__("r9") =3D ARGVALUE(7);
+	__asm__ __volatile__("vmcall" :
+			     "=3Da"(rax) :
+			     "a"(rax), "D"(rdi), "S"(rsi), "d"(rdx),
+			     "r"(r10), "r"(r8), "r"(r9));
+	GUEST_ASSERT(rax =3D=3D RETVALUE);
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	if (!kvm_check_cap(KVM_CAP_X86_USER_SPACE_HYPERCALL)) {
+		print_skip("KVM_CAP_X86_USER_SPACE_HYPERCALL not available");
+		exit(KSFT_SKIP);
+	}
+
+	struct kvm_enable_cap cap =3D {
+		.cap =3D KVM_CAP_X86_USER_SPACE_HYPERCALL,
+		.flags =3D 0,
+		.args[0] =3D 1,
+	};
+	vm =3D vm_create_default(VCPU_ID, 0, (void *) guest_code);
+	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+
+	vm_enable_cap(vm, &cap);
+
+	for (;;) {
+		volatile struct kvm_run *run =3D vcpu_state(vm, VCPU_ID);
+		struct ucall uc;
+
+		vcpu_run(vm, VCPU_ID);
+
+		if (run->exit_reason =3D=3D KVM_EXIT_HYPERCALL) {
+			ASSERT_EQ(run->hypercall.longmode, 1);
+			ASSERT_EQ(run->hypercall.nr, ARGVALUE(1));
+			ASSERT_EQ(run->hypercall.args[0], ARGVALUE(2));
+			ASSERT_EQ(run->hypercall.args[1], ARGVALUE(3));
+			ASSERT_EQ(run->hypercall.args[2], ARGVALUE(4));
+			ASSERT_EQ(run->hypercall.args[3], ARGVALUE(5));
+			ASSERT_EQ(run->hypercall.args[4], ARGVALUE(6));
+			ASSERT_EQ(run->hypercall.args[5], ARGVALUE(7));
+			run->hypercall.ret =3D RETVALUE;
+			continue;
+		}
+
+		TEST_ASSERT(run->exit_reason =3D=3D KVM_EXIT_IO,
+			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
+			    run->exit_reason,
+			    exit_reason_str(run->exit_reason));
+
+		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		case UCALL_ABORT:
+			TEST_FAIL("%s", (const char *)uc.args[0]);
+			/* NOT REACHED */
+		case UCALL_SYNC:
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall 0x%lx.", uc.cmd);
+		}
+	}
+done:
+	kvm_vm_free(vm);
+	return 0;
+}
--=20
2.17.1


--=-CoAmMQw36mtebGJXAOO2
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCECow
ggUcMIIEBKADAgECAhEA4rtJSHkq7AnpxKUY8ZlYZjANBgkqhkiG9w0BAQsFADCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwHhcNMTkwMTAyMDAwMDAwWhcNMjIwMTAxMjM1
OTU5WjAkMSIwIAYJKoZIhvcNAQkBFhNkd213MkBpbmZyYWRlYWQub3JnMIIBIjANBgkqhkiG9w0B
AQEFAAOCAQ8AMIIBCgKCAQEAsv3wObLTCbUA7GJqKj9vHGf+Fa+tpkO+ZRVve9EpNsMsfXhvFpb8
RgL8vD+L133wK6csYoDU7zKiAo92FMUWaY1Hy6HqvVr9oevfTV3xhB5rQO1RHJoAfkvhy+wpjo7Q
cXuzkOpibq2YurVStHAiGqAOMGMXhcVGqPuGhcVcVzVUjsvEzAV9Po9K2rpZ52FE4rDkpDK1pBK+
uOAyOkgIg/cD8Kugav5tyapydeWMZRJQH1vMQ6OVT24CyAn2yXm2NgTQMS1mpzStP2ioPtTnszIQ
Ih7ASVzhV6csHb8Yrkx8mgllOyrt9Y2kWRRJFm/FPRNEurOeNV6lnYAXOymVJwIDAQABo4IB0zCC
Ac8wHwYDVR0jBBgwFoAUgq9sjPjF/pZhfOgfPStxSF7Ei8AwHQYDVR0OBBYEFLfuNf820LvaT4AK
xrGK3EKx1DE7MA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUF
BwMEBggrBgEFBQcDAjBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEDBTArMCkGCCsGAQUFBwIBFh1o
dHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3Js
LmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWls
Q0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKGSWh0dHA6Ly9jcnQuY29tb2RvY2Eu
Y29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcnQwJAYI
KwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAeBgNVHREEFzAVgRNkd213MkBpbmZy
YWRlYWQub3JnMA0GCSqGSIb3DQEBCwUAA4IBAQALbSykFusvvVkSIWttcEeifOGGKs7Wx2f5f45b
nv2ghcxK5URjUvCnJhg+soxOMoQLG6+nbhzzb2rLTdRVGbvjZH0fOOzq0LShq0EXsqnJbbuwJhK+
PnBtqX5O23PMHutP1l88AtVN+Rb72oSvnD+dK6708JqqUx2MAFLMevrhJRXLjKb2Mm+/8XBpEw+B
7DisN4TMlLB/d55WnT9UPNHmQ+3KFL7QrTO8hYExkU849g58Dn3Nw3oCbMUgny81ocrLlB2Z5fFG
Qu1AdNiBA+kg/UxzyJZpFbKfCITd5yX49bOriL692aMVDyqUvh8fP+T99PqorH4cIJP6OxSTdxKM
MIIFHDCCBASgAwIBAgIRAOK7SUh5KuwJ6cSlGPGZWGYwDQYJKoZIhvcNAQELBQAwgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTE5MDEwMjAwMDAwMFoXDTIyMDEwMTIz
NTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBALL98Dmy0wm1AOxiaio/bxxn/hWvraZDvmUVb3vRKTbDLH14bxaW
/EYC/Lw/i9d98CunLGKA1O8yogKPdhTFFmmNR8uh6r1a/aHr301d8YQea0DtURyaAH5L4cvsKY6O
0HF7s5DqYm6tmLq1UrRwIhqgDjBjF4XFRqj7hoXFXFc1VI7LxMwFfT6PStq6WedhROKw5KQytaQS
vrjgMjpICIP3A/CroGr+bcmqcnXljGUSUB9bzEOjlU9uAsgJ9sl5tjYE0DEtZqc0rT9oqD7U57My
ECIewElc4VenLB2/GK5MfJoJZTsq7fWNpFkUSRZvxT0TRLqznjVepZ2AFzsplScCAwEAAaOCAdMw
ggHPMB8GA1UdIwQYMBaAFIKvbIz4xf6WYXzoHz0rcUhexIvAMB0GA1UdDgQWBBS37jX/NtC72k+A
CsaxitxCsdQxOzAOBgNVHQ8BAf8EBAMCBaAwDAYDVR0TAQH/BAIwADAdBgNVHSUEFjAUBggrBgEF
BQcDBAYIKwYBBQUHAwIwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAwUwKzApBggrBgEFBQcCARYd
aHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwWgYDVR0fBFMwUTBPoE2gS4ZJaHR0cDovL2Ny
bC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFp
bENBLmNybDCBiwYIKwYBBQUHAQEEfzB9MFUGCCsGAQUFBzAChklodHRwOi8vY3J0LmNvbW9kb2Nh
LmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWlsQ0EuY3J0MCQG
CCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAC20spBbrL71ZEiFrbXBHonzhhirO1sdn+X+O
W579oIXMSuVEY1LwpyYYPrKMTjKECxuvp24c829qy03UVRm742R9Hzjs6tC0oatBF7KpyW27sCYS
vj5wbal+TttzzB7rT9ZfPALVTfkW+9qEr5w/nSuu9PCaqlMdjABSzHr64SUVy4ym9jJvv/FwaRMP
gew4rDeEzJSwf3eeVp0/VDzR5kPtyhS+0K0zvIWBMZFPOPYOfA59zcN6AmzFIJ8vNaHKy5QdmeXx
RkLtQHTYgQPpIP1Mc8iWaRWynwiE3ecl+PWzq4i+vdmjFQ8qlL4fHz/k/fT6qKx+HCCT+jsUk3cS
jDCCBeYwggPOoAMCAQICEGqb4Tg7/ytrnwHV2binUlYwDQYJKoZIhvcNAQEMBQAwgYUxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMSswKQYDVQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRp
b24gQXV0aG9yaXR5MB4XDTEzMDExMDAwMDAwMFoXDTI4MDEwOTIzNTk1OVowgZcxCzAJBgNVBAYT
AkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNV
BAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAvrOeV6wodnVAFsc4A5jTxhh2IVDzJXkLTLWg0X06WD6cpzEup/Y0dtmEatrQPTRI5Or1u6zf
+bGBSyD9aH95dDSmeny1nxdlYCeXIoymMv6pQHJGNcIDpFDIMypVpVSRsivlJTRENf+RKwrB6vcf
WlP8dSsE3Rfywq09N0ZfxcBa39V0wsGtkGWC+eQKiz4pBZYKjrc5NOpG9qrxpZxyb4o4yNNwTqza
aPpGRqXB7IMjtf7tTmU2jqPMLxFNe1VXj9XB1rHvbRikw8lBoNoSWY66nJN/VCJv5ym6Q0mdCbDK
CMPybTjoNCQuelc0IAaO4nLUXk0BOSxSxt8kCvsUtQIDAQABo4IBPDCCATgwHwYDVR0jBBgwFoAU
u69+Aj36pvE8hI6t7jiY7NkyMtQwHQYDVR0OBBYEFIKvbIz4xf6WYXzoHz0rcUhexIvAMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMBEGA1UdIAQKMAgwBgYEVR0gADBMBgNVHR8E
RTBDMEGgP6A9hjtodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDZXJ0aWZpY2F0aW9u
QXV0aG9yaXR5LmNybDBxBggrBgEFBQcBAQRlMGMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9jcnQuY29t
b2RvY2EuY29tL0NPTU9ET1JTQUFkZFRydXN0Q0EuY3J0MCQGCCsGAQUFBzABhhhodHRwOi8vb2Nz
cC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEMBQADggIBAHhcsoEoNE887l9Wzp+XVuyPomsX9vP2
SQgG1NgvNc3fQP7TcePo7EIMERoh42awGGsma65u/ITse2hKZHzT0CBxhuhb6txM1n/y78e/4ZOs
0j8CGpfb+SJA3GaBQ+394k+z3ZByWPQedXLL1OdK8aRINTsjk/H5Ns77zwbjOKkDamxlpZ4TKSDM
KVmU/PUWNMKSTvtlenlxBhh7ETrN543j/Q6qqgCWgWuMAXijnRglp9fyadqGOncjZjaaSOGTTFB+
E2pvOUtY+hPebuPtTbq7vODqzCM6ryEhNhzf+enm0zlpXK7q332nXttNtjv7VFNYG+I31gnMrwfH
M5tdhYF/8v5UY5g2xANPECTQdu9vWPoqNSGDt87b3gXb1AiGGaI06vzgkejL580ul+9hz9D0S0U4
jkhJiA7EuTecP/CFtR72uYRBcunwwH3fciPjviDDAI9SnC/2aPY8ydehzuZutLbZdRJ5PDEJM/1t
yZR2niOYihZ+FCbtf3D9mB12D4ln9icgc7CwaxpNSCPt8i/GqK2HsOgkL3VYnwtx7cJUmpvVdZ4o
gnzgXtgtdk3ShrtOS1iAN2ZBXFiRmjVzmehoMof06r1xub+85hFQzVxZx5/bRaTKTlL8YXLI8nAb
R9HWdFqzcOoB/hxfEyIQpx9/s81rgzdEZOofSlZHynoSMYIDyjCCA8YCAQEwga0wgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA4rtJSHkq7AnpxKUY8ZlYZjANBglghkgB
ZQMEAgEFAKCCAe0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAx
MTI4MTQyMDU4WjAvBgkqhkiG9w0BCQQxIgQgLZReSoYH3BLiwzmgjAJ7Tt+Jj5o3g8GMen/eVpux
BWAwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAH0YfuHUbAFvNkeL/Y2LYPyjK0Jaa7HDGVOWn/qBcGmu17rZEQkxZf3X7/s8nES8
Qu+3vJXBIEX7H+R7Xe55QRwdbEkiqyIY7qw/DnnyQxI1Qz5uFWPmSNt8btGoblsEuaMOq7peRVZU
M1k6KsBR/BoPpHbP+KAk74SBqFu4jRCUv4BcF3Pl0QUhY/NPjhCo7+jfpoe9lDE4dREO9kTBKfQc
mEA0PNMKT1vWHGQurwBxAtrujnzCPJiOxTO3P/XsDed6+togcxWwLkojA7OMDbp/gV65URJv2CBM
/CQQyFg4NyWIkP90N3ntUKWSPemKRDnaRfZwjCl6SC4C/gx51Z8AAAAAAAA=


--=-CoAmMQw36mtebGJXAOO2--

