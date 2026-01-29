Return-Path: <kvm+bounces-69504-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SJi6FPjmemlk/QEAu9opvQ
	(envelope-from <kvm+bounces-69504-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 05:50:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BBD23ABBE4
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 05:49:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2FA6B301B71B
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 04:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 818852D2397;
	Thu, 29 Jan 2026 04:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V69I6N/7"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DDB1E5B63;
	Thu, 29 Jan 2026 04:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769662187; cv=none; b=n7wBrqsUNRLujWo+92cut4NlYAUd9KQCSoZl1BudjGwRqKwUlNKIXVuRs0QhUUkPTtCdUVHC0CldU2698fWT2ENFadpjzg6teuwc44JyOUyqxrRRVp0E2fjQvcECPrQrOo0h6ShDKC2KOOz4cJI1oRd0LDKSH9akWXAEXjfQahU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769662187; c=relaxed/simple;
	bh=xb1fwZd4ilqnTaBLLYUh8xH+V26qKIuPacDrWqOvWYY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=R36zkveOG300qfoPp/h5m0niTBXnHKLwmkpag7mWo9a8eQgLl8KXap4V2Hef+9Q3UoAYG64xOBSyNK9nvw1Kml3RW7ZxE3CvzBwmbT9K8zKD131nOsBlsJ2ikkbaova6HucflkTXsKc6FecTi5bxFk9pW197evwZxTOWw5F4ko0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=V69I6N/7; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yNr+14WAIKKE+qWrCubJeb4YGk57O/SiGwlTnAYtt50=; b=V69I6N/7y8SVqnglIXEqaSpbpk
	va4UYG1D6Bzn43JC7WXYga9mqPyGfv8OMy/eYrdZaxPt0jix/Ew0soUA4xYqdmb5MhbgmnvL/9jKB
	RcuBbH/3MzmzKIfP1KEnUKLvcQcgYJt/NCIMULIZqWbiEoKYbuu9Jwl3zvl+KI4ux6ohzZGB+Zhep
	r20H4BB4dvmFeTNaAi0bxAzVr7+jyyVX/gUOwQsyYkYp1O3zQB5C9iTGCPv7ZqvChmvm/Koqps2Nf
	mr3p7yZzgRk9+b61hvM6aSEL/E455IOQkugfmc2dZObh3n0PVtltW9H06wZhtlEQimBCYfqn0lTyh
	IASOSbeA==;
Received: from [2001:8b0:10b::4] (helo=u09cd745991455d.ant.amazon.com)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vlJy3-00000009nr6-0eI2;
	Thu, 29 Jan 2026 04:49:27 +0000
Message-ID: <83f9b0a5dd0bc1de9d1e61954f6dd5211df45163.camel@infradead.org>
Subject: [PATCH v5 4/3] KVM: selftests: Add test cases for EOI suppression
 modes
From: David Woodhouse <dwmw2@infradead.org>
To: Khushit Shah <khushit.shah@nutanix.com>, seanjc@google.com, 
	pbonzini@redhat.com, kai.huang@intel.com
Cc: mingo@redhat.com, x86@kernel.org, bp@alien8.de, hpa@zytor.com, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 dave.hansen@linux.intel.com,  tglx@linutronix.de, jon@nutanix.com,
 shaju.abraham@nutanix.com
Date: Wed, 28 Jan 2026 20:49:12 -0800
In-Reply-To: <20251229111708.59402-1-khushit.shah@nutanix.com>
References: <20251229111708.59402-1-khushit.shah@nutanix.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-XM1aDuSYUJFjYLXU6f31"
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-4.26 / 15.00];
	SIGNED_SMIME(-2.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=desiato.20200630];
	MIME_GOOD(-0.20)[multipart/signed,text/plain];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69504-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+,1:+,2:~];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_ATTACHMENT(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dwmw2@infradead.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[infradead.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amazon.co.uk:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BBD23ABBE4
X-Rspamd-Action: no action


--=-XM1aDuSYUJFjYLXU6f31
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Woodhouse <dwmw@amazon.co.uk>

Rather than being frightened of doing the right thing for the in-kernel
I/O APIC because "there might be bugs", let's add selftests for it to
make sure it behaves correctly. For both in-kernel I/O APIC and
userspace, exercise the following modes:

 =E2=80=A2 Legacy "quirk" behaviour (this test shows the same results on bo=
th
   old kernels and on kernels with this patch series in default mode).
 =E2=80=A2 KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST mode, both with the gue=
st
   enabling APIC_SPIV_DIRECTED_EOI and without.
 =E2=80=A2 KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST mode.

Testing quirk mode (no flags)...
  IOAPIC v0x11, LVR directed_eoi=3D0, SPIV directed_eoi=3D0, remote_irr=3D0
Testing explicit enable...
  IOAPIC v0x20, LVR directed_eoi=3D1, SPIV directed_eoi=3D1, remote_irr=3D1
Testing explicit enable (guest doesn't use)...
  IOAPIC v0x20, LVR directed_eoi=3D1, SPIV directed_eoi=3D0, remote_irr=3D0
Testing explicit disable...
  IOAPIC v0x11, LVR directed_eoi=3D0, SPIV directed_eoi=3D0, remote_irr=3D0
All tests passed

=3D=3D=3D Testing split IRQCHIP mode =3D=3D=3D
Testing quirk mode (no flags)...
  Split IRQCHIP: LVR directed_eoi=3D1, SPIV directed_eoi=3D0, got_eoi_exit=
=3D1
Testing explicit enable...
  Split IRQCHIP: LVR directed_eoi=3D1, SPIV directed_eoi=3D1, got_eoi_exit=
=3D0
Testing explicit enable (guest doesn't use)...
  Split IRQCHIP: LVR directed_eoi=3D1, SPIV directed_eoi=3D0, got_eoi_exit=
=3D1
Testing explicit disable...
  Split IRQCHIP: LVR directed_eoi=3D0, SPIV directed_eoi=3D0, got_eoi_exit=
=3D1
All tests passed

There didn't seem to be a way for selftests to use split irqchip mode
until now, so this adds vm_irqchip_mode modelled on the existing
vm_guest_mode enum.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selft=
ests/kvm/Makefile.kvm
index 148d427ff24b..01c59bf8b79f 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -122,6 +122,7 @@ TEST_GEN_PROGS_x86 +=3D x86/vmx_nested_tsc_scaling_test
 TEST_GEN_PROGS_x86 +=3D x86/apic_bus_clock_test
 TEST_GEN_PROGS_x86 +=3D x86/xapic_ipi_test
 TEST_GEN_PROGS_x86 +=3D x86/xapic_state_test
+TEST_GEN_PROGS_x86 +=3D x86/suppress_eoi_test
 TEST_GEN_PROGS_x86 +=3D x86/xcr0_cpuid_test
 TEST_GEN_PROGS_x86 +=3D x86/xss_msr_test
 TEST_GEN_PROGS_x86 +=3D x86/debug_regs
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing=
/selftests/kvm/include/kvm_util.h
index d3f3e455c031..c4eb0e95bae9 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -209,6 +209,14 @@ kvm_static_assert(sizeof(struct vm_shape) =3D=3D sizeo=
f(uint64_t));
 	shape;					\
 })
=20
+enum vm_irqchip_mode {
+	VM_IRQCHIP_AUTO,
+	VM_IRQCHIP_KERNEL,
+	VM_IRQCHIP_SPLIT,
+};
+
+extern enum vm_irqchip_mode vm_irqchip_mode;
+
 #if defined(__aarch64__)
=20
 extern enum vm_guest_mode vm_mode_default;
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/sel=
ftests/kvm/lib/kvm_util.c
index 1a93d6361671..4858c10f7530 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1687,21 +1687,34 @@ void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t =
gpa)
 	return (void *) ((uintptr_t) region->host_alias + offset);
 }
=20
+enum vm_irqchip_mode vm_irqchip_mode =3D VM_IRQCHIP_AUTO;
+
 /* Create an interrupt controller chip for the specified VM. */
 void vm_create_irqchip(struct kvm_vm *vm)
 {
 	int r;
=20
 	/*
-	 * Allocate a fully in-kernel IRQ chip by default, but fall back to a
-	 * split model (x86 only) if that fails (KVM x86 allows compiling out
-	 * support for KVM_CREATE_IRQCHIP).
+	 * Create IRQ chip based on vm_irqchip_mode:
+	 * - VM_IRQCHIP_AUTO: Try in-kernel, fall back to split if not supported
+	 * - VM_IRQCHIP_KERNEL: Force in-kernel IRQ chip
+	 * - VM_IRQCHIP_SPLIT: Force split IRQ chip (x86 only)
 	 */
-	r =3D __vm_ioctl(vm, KVM_CREATE_IRQCHIP, NULL);
-	if (r && errno =3D=3D ENOTTY && kvm_has_cap(KVM_CAP_SPLIT_IRQCHIP))
+	if (vm_irqchip_mode =3D=3D VM_IRQCHIP_SPLIT) {
+		TEST_ASSERT(kvm_has_cap(KVM_CAP_SPLIT_IRQCHIP),
+			    "Split IRQ chip not supported");
 		vm_enable_cap(vm, KVM_CAP_SPLIT_IRQCHIP, 24);
-	else
+	} else if (vm_irqchip_mode =3D=3D VM_IRQCHIP_KERNEL) {
+		r =3D __vm_ioctl(vm, KVM_CREATE_IRQCHIP, NULL);
 		TEST_ASSERT_VM_VCPU_IOCTL(!r, KVM_CREATE_IRQCHIP, r, vm);
+	} else {
+		/* VM_IRQCHIP_AUTO */
+		r =3D __vm_ioctl(vm, KVM_CREATE_IRQCHIP, NULL);
+		if (r && errno =3D=3D ENOTTY && kvm_has_cap(KVM_CAP_SPLIT_IRQCHIP))
+			vm_enable_cap(vm, KVM_CAP_SPLIT_IRQCHIP, 24);
+		else
+			TEST_ASSERT_VM_VCPU_IOCTL(!r, KVM_CREATE_IRQCHIP, r, vm);
+	}
=20
 	vm->has_irqchip =3D true;
 }
diff --git a/tools/testing/selftests/kvm/x86/suppress_eoi_test.c b/tools/te=
sting/selftests/kvm/x86/suppress_eoi_test.c
new file mode 100644
index 000000000000..ea14690b3116
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/suppress_eoi_test.c
@@ -0,0 +1,441 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test KVM's handling of Suppress EOI Broadcast in x2APIC mode.
+ */
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+#include "apic.h"
+
+#define TEST_VECTOR		0xa2
+#define TEST_IRQ		5
+#define APIC_LVR_DIRECTED_EOI	(1 << 24)
+#define APIC_SPIV_DIRECTED_EOI	(1 << 12)
+
+#define APIC_ISR	0x100
+#define APIC_LVTPC	0x340
+#define APIC_LVT0	0x350
+#define APIC_LVT1	0x360
+#define APIC_LVTERR	0x370
+
+#define IOAPIC_BASE_GPA		0xfec00000
+#define IOAPIC_REG_SELECT	0x00
+#define IOAPIC_REG_WINDOW	0x10
+#define IOAPIC_REG_VERSION	0x01
+#define IOAPIC_REG_EOI		0x40
+
+static uint32_t ioapic_version;
+
+static void guest_irq_handler(struct ex_regs *regs)
+{
+}
+
+static uint32_t ioapic_read_reg(uint32_t reg)
+{
+	volatile uint32_t *ioapic =3D (volatile uint32_t *)IOAPIC_BASE_GPA;
+	ioapic[0] =3D reg;
+	return ioapic[4];
+}
+
+static void ioapic_write_reg(uint32_t reg, uint32_t val)
+{
+	volatile uint32_t *ioapic =3D (volatile uint32_t *)IOAPIC_BASE_GPA;
+	ioapic[0] =3D reg;
+	ioapic[4] =3D val;
+}
+
+static void guest_code(uint64_t use_directed)
+{
+	uint64_t apic_base;
+	uint32_t spiv;
+
+	/* Enable x2APIC mode */
+	apic_base =3D rdmsr(MSR_IA32_APICBASE);
+	wrmsr(MSR_IA32_APICBASE, apic_base | X2APIC_ENABLE);
+
+	/* Mask all LVT entries to prevent spurious interrupts/NMIs */
+	x2apic_write_reg(APIC_LVTT, APIC_LVT_MASKED);
+	x2apic_write_reg(APIC_LVTPC, APIC_LVT_MASKED);
+	x2apic_write_reg(APIC_LVT0, APIC_LVT_MASKED);
+	x2apic_write_reg(APIC_LVT1, APIC_LVT_MASKED);
+	x2apic_write_reg(APIC_LVTERR, APIC_LVT_MASKED);
+
+	/* Enable APIC */
+	x2apic_write_reg(APIC_SPIV, APIC_SPIV_APIC_ENABLED | TEST_VECTOR);
+
+	/* Read IOAPIC version */
+	ioapic_version =3D ioapic_read_reg(IOAPIC_REG_VERSION);
+
+	/* Conditionally set APIC_SPIV_DIRECTED_EOI based on flag */
+	if (use_directed) {
+		spiv =3D x2apic_read_reg(APIC_SPIV);
+		x2apic_write_reg(APIC_SPIV, spiv | APIC_SPIV_DIRECTED_EOI);
+	}
+	spiv =3D x2apic_read_reg(APIC_SPIV);
+
+	GUEST_SYNC(ioapic_version | (spiv << 16));
+
+	/* Enable interrupts and wait for interrupt to be delivered */
+	asm volatile("sti; hlt");
+
+	/* Write EOI to trigger broadcast (or not) */
+	x2apic_write_reg(APIC_EOI, 0);
+
+	GUEST_SYNC(0);
+
+	/* If IOAPIC v0x20, write directed EOI to clear remote_irr */
+	if ((ioapic_version & 0xff) =3D=3D 0x20) {
+		ioapic_write_reg(IOAPIC_REG_EOI, TEST_VECTOR);
+		GUEST_SYNC(1);
+	}
+
+	GUEST_DONE();
+}
+
+static void test_suppress_eoi(uint64_t x2apic_flags, bool expect_advertise=
d, bool expect_implemented,
+			      bool use_directed)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct kvm_lapic_state lapic;
+	struct kvm_irqchip chip;
+	struct kvm_irq_level irq_level;
+	struct ucall uc;
+	uint32_t lvr, ioapic_ver, spiv_after;
+	bool remote_irr_set;
+
+	use_directed =3D use_directed;
+
+	vm =3D vm_create(1);
+
+	if (x2apic_flags)
+		vm_enable_cap(vm, KVM_CAP_X2APIC_API, x2apic_flags);
+
+	if (!vm->has_irqchip)
+		vm_create_irqchip(vm);
+
+	vcpu =3D vm_vcpu_add(vm, 0, guest_code);
+	vcpu_args_set(vcpu, 1, use_directed);
+
+	vm_install_exception_handler(vm, TEST_VECTOR, guest_irq_handler);
+
+	/* Map IOAPIC for guest access */
+	virt_map(vm, IOAPIC_BASE_GPA, IOAPIC_BASE_GPA, 1);
+
+	/* Configure level-triggered interrupt in IOAPIC */
+	chip.chip_id =3D KVM_IRQCHIP_IOAPIC;
+	vm_ioctl(vm, KVM_GET_IRQCHIP, &chip);
+
+	chip.chip.ioapic.redirtbl[TEST_IRQ].fields.vector =3D TEST_VECTOR;
+	chip.chip.ioapic.redirtbl[TEST_IRQ].fields.delivery_mode =3D 0; /* fixed =
*/
+	chip.chip.ioapic.redirtbl[TEST_IRQ].fields.dest_mode =3D 0; /* physical *=
/
+	chip.chip.ioapic.redirtbl[TEST_IRQ].fields.mask =3D 0; /* unmasked */
+	chip.chip.ioapic.redirtbl[TEST_IRQ].fields.trig_mode =3D 1; /* level */
+	chip.chip.ioapic.redirtbl[TEST_IRQ].fields.dest_id =3D vcpu->id;
+
+	vm_ioctl(vm, KVM_SET_IRQCHIP, &chip);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_SYNC);
+	ioapic_ver =3D uc.args[1] & 0xff;
+	spiv_after =3D (uc.args[1] >> 16) & 0xffff;
+
+	/* Inject level-triggered interrupt */
+	irq_level.irq =3D TEST_IRQ;
+	irq_level.level =3D 1;
+	vm_ioctl(vm, KVM_IRQ_LINE, &irq_level);
+
+	/* De-assert immediately so we only get one interrupt */
+	irq_level.level =3D 0;
+	vm_ioctl(vm, KVM_IRQ_LINE, &irq_level);
+
+	/* Guest receives interrupt and writes EOI */
+	vcpu_run(vcpu);
+
+	/* Check what ucall we got */
+	int ucall_type =3D get_ucall(vcpu, &uc);
+
+	/* Handle guest completion based on what it did */
+	if (ucall_type =3D=3D UCALL_SYNC) {
+		/* Guest has more to do */
+		vcpu_run(vcpu);
+		ucall_type =3D get_ucall(vcpu, &uc);
+
+		if (ucall_type =3D=3D UCALL_SYNC) {
+			/* Guest wrote EOIR */
+			vcpu_run(vcpu);
+			TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_DONE);
+		} else {
+			TEST_ASSERT_EQ(ucall_type, UCALL_DONE);
+		}
+	} else {
+		TEST_ASSERT_EQ(ucall_type, UCALL_DONE);
+	}
+
+	/* Check remote_irr after all guest EOI activity */
+	chip.chip_id =3D KVM_IRQCHIP_IOAPIC;
+	vm_ioctl(vm, KVM_GET_IRQCHIP, &chip);
+	remote_irr_set =3D chip.chip.ioapic.redirtbl[TEST_IRQ].fields.remote_irr;
+
+	/* De-assert IRQ line */
+	irq_level.level =3D 0;
+	vm_ioctl(vm, KVM_IRQ_LINE, &irq_level);
+
+	/* Check LAPIC LVR */
+	vcpu_ioctl(vcpu, KVM_GET_LAPIC, &lapic);
+	lvr =3D *(u32 *)&lapic.regs[APIC_LVR];
+
+	printf("  IOAPIC v0x%x, LVR directed_eoi=3D%d, SPIV directed_eoi=3D%d, re=
mote_irr=3D%d\n",
+	       ioapic_ver, !!(lvr & APIC_LVR_DIRECTED_EOI),
+	       !!(spiv_after & APIC_SPIV_DIRECTED_EOI), remote_irr_set);
+
+	if (expect_advertised) {
+		TEST_ASSERT(lvr & APIC_LVR_DIRECTED_EOI,
+			    "Expected APIC_LVR_DIRECTED_EOI, got LVR=3D0x%x", lvr);
+	} else {
+		TEST_ASSERT(!(lvr & APIC_LVR_DIRECTED_EOI),
+			    "Expected no APIC_LVR_DIRECTED_EOI, got LVR=3D0x%x", lvr);
+	}
+
+	/* Check IOAPIC version */
+	if (expect_implemented) {
+		TEST_ASSERT(ioapic_ver =3D=3D 0x20,
+			    "Expected IOAPIC v0x20 (with EOIR), got 0x%x", ioapic_ver);
+	} else {
+		TEST_ASSERT(ioapic_ver =3D=3D 0x11,
+			    "Expected IOAPIC v0x11 (no EOIR), got 0x%x", ioapic_ver);
+	}
+
+	/* Check SPIV and remote_irr based on whether guest used directed EOI */
+	if (use_directed) {
+		TEST_ASSERT(spiv_after & APIC_SPIV_DIRECTED_EOI,
+			    "Expected APIC_SPIV_DIRECTED_EOI set, got SPIV=3D0x%x", spiv_after)=
;
+		TEST_ASSERT(remote_irr_set,
+			    "Expected remote_irr set (EOI suppressed), got cleared");
+	} else {
+		TEST_ASSERT(!(spiv_after & APIC_SPIV_DIRECTED_EOI),
+			    "Expected APIC_SPIV_DIRECTED_EOI clear, got SPIV=3D0x%x", spiv_afte=
r);
+		TEST_ASSERT(!remote_irr_set,
+			    "Expected remote_irr cleared (EOI broadcast), got set");
+	}
+
+	kvm_vm_free(vm);
+}
+
+static void guest_code_split(uint64_t use_directed)
+{
+	uint64_t apic_base;
+	uint32_t spiv;
+
+	/* Enable x2APIC mode */
+	apic_base =3D rdmsr(MSR_IA32_APICBASE);
+	wrmsr(MSR_IA32_APICBASE, apic_base | X2APIC_ENABLE);
+
+	/* Mask all LVT entries */
+	x2apic_write_reg(APIC_LVTT, APIC_LVT_MASKED);
+	x2apic_write_reg(APIC_LVTPC, APIC_LVT_MASKED);
+	x2apic_write_reg(APIC_LVT0, APIC_LVT_MASKED);
+	x2apic_write_reg(APIC_LVT1, APIC_LVT_MASKED);
+	x2apic_write_reg(APIC_LVTERR, APIC_LVT_MASKED);
+
+	/* Enable APIC */
+	x2apic_write_reg(APIC_SPIV, APIC_SPIV_APIC_ENABLED | TEST_VECTOR);
+
+	/* Conditionally set APIC_SPIV_DIRECTED_EOI */
+	if (use_directed) {
+		spiv =3D x2apic_read_reg(APIC_SPIV);
+		x2apic_write_reg(APIC_SPIV, spiv | APIC_SPIV_DIRECTED_EOI);
+	}
+	spiv =3D x2apic_read_reg(APIC_SPIV);
+
+	GUEST_SYNC(spiv);
+
+	/* Enable interrupts and wait for interrupt */
+	asm volatile("sti; hlt");
+
+	/* Write EOI */
+	x2apic_write_reg(APIC_EOI, 0);
+
+	GUEST_DONE();
+}
+
+static void test_suppress_eoi_split(uint64_t x2apic_flags, bool expect_adv=
ertised, bool use_directed)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct kvm_lapic_state lapic;
+	struct ucall uc;
+	uint32_t lvr, spiv_after;
+	bool got_eoi_exit;
+	enum vm_irqchip_mode saved_mode =3D vm_irqchip_mode;
+
+	vm_irqchip_mode =3D VM_IRQCHIP_SPLIT;
+	vm =3D vm_create(1);
+	vm_irqchip_mode =3D saved_mode;
+
+	if (x2apic_flags)
+		vm_enable_cap(vm, KVM_CAP_X2APIC_API, x2apic_flags);
+
+	vcpu =3D vm_vcpu_add(vm, 0, guest_code_split);
+	vcpu_args_set(vcpu, 1, use_directed);
+
+	/* Set up IRQ routing so kernel knows userspace IOAPIC handles TEST_IRQ *=
/
+	struct kvm_irq_routing *routing =3D calloc(1, sizeof(*routing) + sizeof(r=
outing->entries[0]));
+	routing->nr =3D 1;
+	routing->entries[0].gsi =3D TEST_IRQ;
+	routing->entries[0].type =3D KVM_IRQ_ROUTING_MSI;
+	routing->entries[0].u.msi.address_lo =3D 0xfee00000;  /* Dest ID 0 */
+	routing->entries[0].u.msi.address_hi =3D 0;
+	routing->entries[0].u.msi.data =3D TEST_VECTOR | (1 << 15);  /* Level-tri=
ggered */
+	__vm_ioctl(vm, KVM_SET_GSI_ROUTING, routing);
+	free(routing);
+
+	vm_install_exception_handler(vm, TEST_VECTOR, guest_irq_handler);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_SYNC);
+	spiv_after =3D uc.args[1];
+
+	/* Inject via GSI (which routes to MSI) */
+	struct kvm_irq_level irq_level =3D {
+		.irq =3D TEST_IRQ,
+		.level =3D 1,
+	};
+	vm_ioctl(vm, KVM_IRQ_LINE, &irq_level);
+	irq_level.level =3D 0;
+	vm_ioctl(vm, KVM_IRQ_LINE, &irq_level);
+
+	/* Guest receives interrupt and writes EOI */
+	vcpu_run(vcpu);
+
+
+	/* Check if we got KVM_EXIT_IOAPIC_EOI */
+	got_eoi_exit =3D (vcpu->run->exit_reason =3D=3D KVM_EXIT_IOAPIC_EOI &&
+			vcpu->run->eoi.vector =3D=3D TEST_VECTOR);
+
+	/* If we got EOI exit, continue guest to finish */
+	if (got_eoi_exit) {
+		vcpu_run(vcpu);
+	}
+
+	/* Let guest finish */
+	int ucall_type =3D get_ucall(vcpu, &uc);
+	if (ucall_type =3D=3D UCALL_SYNC) {
+		vcpu_run(vcpu);
+		ucall_type =3D get_ucall(vcpu, &uc);
+		if (ucall_type =3D=3D UCALL_SYNC) {
+			vcpu_run(vcpu);
+			TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_DONE);
+		} else {
+			TEST_ASSERT_EQ(ucall_type, UCALL_DONE);
+		}
+	} else {
+		TEST_ASSERT_EQ(ucall_type, UCALL_DONE);
+	}
+
+	/* Check LAPIC LVR */
+	vcpu_ioctl(vcpu, KVM_GET_LAPIC, &lapic);
+	lvr =3D *(u32 *)&lapic.regs[APIC_LVR];
+
+	printf("  Split IRQCHIP: LVR directed_eoi=3D%d, SPIV directed_eoi=3D%d, g=
ot_eoi_exit=3D%d\n",
+	       !!(lvr & APIC_LVR_DIRECTED_EOI),
+	       !!(spiv_after & APIC_SPIV_DIRECTED_EOI), got_eoi_exit);
+
+	if (expect_advertised) {
+		TEST_ASSERT(lvr & APIC_LVR_DIRECTED_EOI,
+			    "Expected APIC_LVR_DIRECTED_EOI, got LVR=3D0x%x", lvr);
+	} else {
+		TEST_ASSERT(!(lvr & APIC_LVR_DIRECTED_EOI),
+			    "Expected no APIC_LVR_DIRECTED_EOI, got LVR=3D0x%x", lvr);
+	}
+
+	/* Check EOI exit based on whether guest used directed EOI */
+	if (use_directed) {
+		TEST_ASSERT(spiv_after & APIC_SPIV_DIRECTED_EOI,
+			    "Expected APIC_SPIV_DIRECTED_EOI set, got SPIV=3D0x%x", spiv_after)=
;
+		TEST_ASSERT(!got_eoi_exit,
+			    "Expected no EOI exit (suppressed), but got one");
+	} else {
+		TEST_ASSERT(!(spiv_after & APIC_SPIV_DIRECTED_EOI),
+			    "Expected APIC_SPIV_DIRECTED_EOI clear, got SPIV=3D0x%x", spiv_afte=
r);
+		if (expect_advertised) {
+			/* Quirk mode: advertised but should still broadcast */
+			if (!got_eoi_exit) {
+				printf("  Note: No EOI exit in quirk mode (old kernel behavior)\n");
+			}
+		} else {
+			/* Feature not advertised, no EOI exits expected */
+		}
+	}
+
+	kvm_vm_free(vm);
+}
+
+int main(void)
+{
+	int cap;
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_X2APIC_API));
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_IRQCHIP));
+
+	cap =3D kvm_check_cap(KVM_CAP_X2APIC_API);
+
+	/*
+	 * Test that KVM correctly handles the suppress EOI broadcast flags.
+	 * Note: The actual behavior depends on the kernel implementation.
+	 * This test documents the expected behavior per the commit messages.
+	 *
+	 * Quirk mode: Don't advertise or implement (legacy behavior)
+	 * Explicit enable: Advertise and implement
+	 * Explicit disable: Don't advertise or implement
+	 */
+
+	printf("Testing quirk mode (no flags)...\n");
+	test_suppress_eoi(0, false, false, false);
+
+	if (cap & KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST) {
+		printf("Testing explicit enable...\n");
+		test_suppress_eoi(KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST, true, true, =
true);
+
+		printf("Testing explicit enable (guest doesn't use)...\n");
+		test_suppress_eoi(KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST, true, true, =
false);
+	} else {
+		printf("Skipping explicit enable (not supported)...\n");
+	}
+
+	if (cap & KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST) {
+		printf("Testing explicit disable...\n");
+		test_suppress_eoi(KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST, false, fals=
e, false);
+	} else {
+		printf("Skipping explicit disable (not supported)...\n");
+	}
+
+	printf("All tests passed\n");
+
+	/* Test split irqchip mode */
+	printf("\n=3D=3D=3D Testing split IRQCHIP mode =3D=3D=3D\n");
+
+	printf("Testing quirk mode (no flags)...\n");
+	test_suppress_eoi_split(0, true, false);  /* Quirk: advertised in split m=
ode */
+
+	if (cap & KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST) {
+		printf("Testing explicit enable...\n");
+		test_suppress_eoi_split(KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST, true, =
true);
+
+		printf("Testing explicit enable (guest doesn't use)...\n");
+		test_suppress_eoi_split(KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST, true, =
false);
+	} else {
+		printf("Skipping explicit enable (not supported)...\n");
+	}
+
+	if (cap & KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST) {
+		printf("Testing explicit disable...\n");
+		test_suppress_eoi_split(KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST, false=
, false);
+	} else {
+		printf("Skipping explicit disable (not supported)...\n");
+	}
+
+	printf("All tests passed\n");
+	return 0;
+}
+


--=-XM1aDuSYUJFjYLXU6f31
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCD9Aw
ggSOMIIDdqADAgECAhAOmiw0ECVD4cWj5DqVrT9PMA0GCSqGSIb3DQEBCwUAMGUxCzAJBgNVBAYT
AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAi
BgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0yNDAxMzAwMDAwMDBaFw0zMTEx
MDkyMzU5NTlaMEExCzAJBgNVBAYTAkFVMRAwDgYDVQQKEwdWZXJva2V5MSAwHgYDVQQDExdWZXJv
a2V5IFNlY3VyZSBFbWFpbCBHMjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMjvgLKj
jfhCFqxYyRiW8g3cNFAvltDbK5AzcOaR7yVzVGadr4YcCVxjKrEJOgi7WEOH8rUgCNB5cTD8N/Et
GfZI+LGqSv0YtNa54T9D1AWJy08ZKkWvfGGIXN9UFAPMJ6OLLH/UUEgFa+7KlrEvMUupDFGnnR06
aDJAwtycb8yXtILj+TvfhLFhafxroXrflspavejQkEiHjNjtHnwbZ+o43g0/yxjwnarGI3kgcak7
nnI9/8Lqpq79tLHYwLajotwLiGTB71AGN5xK+tzB+D4eN9lXayrjcszgbOv2ZCgzExQUAIt98mre
8EggKs9mwtEuKAhYBIP/0K6WsoMnQCcCAwEAAaOCAVwwggFYMBIGA1UdEwEB/wQIMAYBAf8CAQAw
HQYDVR0OBBYEFIlICOogTndrhuWByNfhjWSEf/xwMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6en
IZ3zbcgPMA4GA1UdDwEB/wQEAwIBhjAdBgNVHSUEFjAUBggrBgEFBQcDBAYIKwYBBQUHAwIweQYI
KwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQwYIKwYB
BQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RD
QS5jcnQwRQYDVR0fBD4wPDA6oDigNoY0aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0
QXNzdXJlZElEUm9vdENBLmNybDARBgNVHSAECjAIMAYGBFUdIAAwDQYJKoZIhvcNAQELBQADggEB
ACiagCqvNVxOfSd0uYfJMiZsOEBXAKIR/kpqRp2YCfrP4Tz7fJogYN4fxNAw7iy/bPZcvpVCfe/H
/CCcp3alXL0I8M/rnEnRlv8ItY4MEF+2T/MkdXI3u1vHy3ua8SxBM8eT9LBQokHZxGUX51cE0kwa
uEOZ+PonVIOnMjuLp29kcNOVnzf8DGKiek+cT51FvGRjV6LbaxXOm2P47/aiaXrDD5O0RF5SiPo6
xD1/ClkCETyyEAE5LRJlXtx288R598koyFcwCSXijeVcRvBB1cNOLEbg7RMSw1AGq14fNe2cH1HG
W7xyduY/ydQt6gv5r21mDOQ5SaZSWC/ZRfLDuEYwggWbMIIEg6ADAgECAhAH5JEPagNRXYDiRPdl
c1vgMA0GCSqGSIb3DQEBCwUAMEExCzAJBgNVBAYTAkFVMRAwDgYDVQQKEwdWZXJva2V5MSAwHgYD
VQQDExdWZXJva2V5IFNlY3VyZSBFbWFpbCBHMjAeFw0yNDEyMzAwMDAwMDBaFw0yODAxMDQyMzU5
NTlaMB4xHDAaBgNVBAMME2R3bXcyQGluZnJhZGVhZC5vcmcwggIiMA0GCSqGSIb3DQEBAQUAA4IC
DwAwggIKAoICAQDali7HveR1thexYXx/W7oMk/3Wpyppl62zJ8+RmTQH4yZeYAS/SRV6zmfXlXaZ
sNOE6emg8WXLRS6BA70liot+u0O0oPnIvnx+CsMH0PD4tCKSCsdp+XphIJ2zkC9S7/yHDYnqegqt
w4smkqUqf0WX/ggH1Dckh0vHlpoS1OoxqUg+ocU6WCsnuz5q5rzFsHxhD1qGpgFdZEk2/c//ZvUN
i12vPWipk8TcJwHw9zoZ/ZrVNybpMCC0THsJ/UEVyuyszPtNYeYZAhOJ41vav1RhZJzYan4a1gU0
kKBPQklcpQEhq48woEu15isvwWh9/+5jjh0L+YNaN0I//nHSp6U9COUG9Z0cvnO8FM6PTqsnSbcc
0j+GchwOHRC7aP2t5v2stVx3KbptaYEzi4MQHxm/0+HQpMEVLLUiizJqS4PWPU6zfQTOMZ9uLQRR
ci+c5xhtMEBszlQDOvEQcyEG+hc++fH47K+MmZz21bFNfoBxLP6bjR6xtPXtREF5lLXxp+CJ6KKS
blPKeVRg/UtyJHeFKAZXO8Zeco7TZUMVHmK0ZZ1EpnZbnAhKE19Z+FJrQPQrlR0gO3lBzuyPPArV
hvWxjlO7S4DmaEhLzarWi/ze7EGwWSuI2eEa/8zU0INUsGI4ywe7vepQz7IqaAovAX0d+f1YjbmC
VsAwjhLmveFjNwIDAQABo4IBsDCCAawwHwYDVR0jBBgwFoAUiUgI6iBOd2uG5YHI1+GNZIR//HAw
HQYDVR0OBBYEFFxiGptwbOfWOtMk5loHw7uqWUOnMDAGA1UdEQQpMCeBE2R3bXcyQGluZnJhZGVh
ZC5vcmeBEGRhdmlkQHdvb2Rob3Uuc2UwFAYDVR0gBA0wCzAJBgdngQwBBQEBMA4GA1UdDwEB/wQE
AwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwewYDVR0fBHQwcjA3oDWgM4YxaHR0
cDovL2NybDMuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNybDA3oDWgM4YxaHR0
cDovL2NybDQuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNybDB2BggrBgEFBQcB
AQRqMGgwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBABggrBgEFBQcwAoY0
aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNydDANBgkq
hkiG9w0BAQsFAAOCAQEAQXc4FPiPLRnTDvmOABEzkIumojfZAe5SlnuQoeFUfi+LsWCKiB8Uextv
iBAvboKhLuN6eG/NC6WOzOCppn4mkQxRkOdLNThwMHW0d19jrZFEKtEG/epZ/hw/DdScTuZ2m7im
8ppItAT6GXD3aPhXkXnJpC/zTs85uNSQR64cEcBFjjoQDuSsTeJ5DAWf8EMyhMuD8pcbqx5kRvyt
JPsWBQzv1Dsdv2LDPLNd/JUKhHSgr7nbUr4+aAP2PHTXGcEBh8lTeYea9p4d5k969pe0OHYMV5aL
xERqTagmSetuIwolkAuBCzA9vulg8Y49Nz2zrpUGfKGOD0FMqenYxdJHgDCCBZswggSDoAMCAQIC
EAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQELBQAwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoT
B1Zlcm9rZXkxIDAeBgNVBAMTF1Zlcm9rZXkgU2VjdXJlIEVtYWlsIEcyMB4XDTI0MTIzMDAwMDAw
MFoXDTI4MDEwNDIzNTk1OVowHjEcMBoGA1UEAwwTZHdtdzJAaW5mcmFkZWFkLm9yZzCCAiIwDQYJ
KoZIhvcNAQEBBQADggIPADCCAgoCggIBANqWLse95HW2F7FhfH9bugyT/danKmmXrbMnz5GZNAfj
Jl5gBL9JFXrOZ9eVdpmw04Tp6aDxZctFLoEDvSWKi367Q7Sg+ci+fH4KwwfQ8Pi0IpIKx2n5emEg
nbOQL1Lv/IcNiep6Cq3DiyaSpSp/RZf+CAfUNySHS8eWmhLU6jGpSD6hxTpYKye7PmrmvMWwfGEP
WoamAV1kSTb9z/9m9Q2LXa89aKmTxNwnAfD3Ohn9mtU3JukwILRMewn9QRXK7KzM+01h5hkCE4nj
W9q/VGFknNhqfhrWBTSQoE9CSVylASGrjzCgS7XmKy/BaH3/7mOOHQv5g1o3Qj/+cdKnpT0I5Qb1
nRy+c7wUzo9OqydJtxzSP4ZyHA4dELto/a3m/ay1XHcpum1pgTOLgxAfGb/T4dCkwRUstSKLMmpL
g9Y9TrN9BM4xn24tBFFyL5znGG0wQGzOVAM68RBzIQb6Fz758fjsr4yZnPbVsU1+gHEs/puNHrG0
9e1EQXmUtfGn4InoopJuU8p5VGD9S3Ikd4UoBlc7xl5yjtNlQxUeYrRlnUSmdlucCEoTX1n4UmtA
9CuVHSA7eUHO7I88CtWG9bGOU7tLgOZoSEvNqtaL/N7sQbBZK4jZ4Rr/zNTQg1SwYjjLB7u96lDP
sipoCi8BfR35/ViNuYJWwDCOEua94WM3AgMBAAGjggGwMIIBrDAfBgNVHSMEGDAWgBSJSAjqIE53
a4blgcjX4Y1khH/8cDAdBgNVHQ4EFgQUXGIam3Bs59Y60yTmWgfDu6pZQ6cwMAYDVR0RBCkwJ4ET
ZHdtdzJAaW5mcmFkZWFkLm9yZ4EQZGF2aWRAd29vZGhvdS5zZTAUBgNVHSAEDTALMAkGB2eBDAEF
AQEwDgYDVR0PAQH/BAQDAgXgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDB7BgNVHR8E
dDByMDegNaAzhjFodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVtYWlsRzIu
Y3JsMDegNaAzhjFodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVtYWlsRzIu
Y3JsMHYGCCsGAQUFBwEBBGowaDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29t
MEAGCCsGAQUFBzAChjRodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVt
YWlsRzIuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQBBdzgU+I8tGdMO+Y4AETOQi6aiN9kB7lKWe5Ch
4VR+L4uxYIqIHxR7G2+IEC9ugqEu43p4b80LpY7M4KmmfiaRDFGQ50s1OHAwdbR3X2OtkUQq0Qb9
6ln+HD8N1JxO5nabuKbymki0BPoZcPdo+FeRecmkL/NOzzm41JBHrhwRwEWOOhAO5KxN4nkMBZ/w
QzKEy4PylxurHmRG/K0k+xYFDO/UOx2/YsM8s138lQqEdKCvudtSvj5oA/Y8dNcZwQGHyVN5h5r2
nh3mT3r2l7Q4dgxXlovERGpNqCZJ624jCiWQC4ELMD2+6WDxjj03PbOulQZ8oY4PQUyp6djF0keA
MYIDuzCCA7cCAQEwVTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMX
VmVyb2tleSBTZWN1cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJYIZIAWUDBAIBBQCg
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDEyOTA0NDkx
M1owLwYJKoZIhvcNAQkEMSIEIEE0SARrRzgx5rK+g2F6lxfptoX3QrCJAK1mCeSoGCJ5MGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAbzw/sGzIoC+i
qBOHIhLDQ97buWMIujP/XnP0k7frECp5em87FicOt58zNn/GzFJGoa2JIWGREN+va7/lmkV/4dSG
Mc/wGQ7UxlnheUHqlnmgsJxkeS/f3HNMMCmN2LYjsz3z5H05iYRC9FS5Q/yis6yjE/SH0Ii85+jI
ZRohz8QE4DJG+Kl/8PcqyNDN9h6YWdcAnRN6T5aXwTDfNEr/+5/1npu+feaXMhIT6dTUkVnuUHUT
07WP3vnmkVwtLp+kZQFkdfOilANLK1Dy4mr/2Bz808/7JRnyaT8iBK7o0cvOIB6fPnUWrN611WKe
kP04MdxidiTcsyIQjAesOKsne83Sqq8FVuPmJKCp9vrpiutIO4mrkQ1aUCW8ViGDImlJ2jyagWDt
cAlPk+K407dhVSZSekcndozX//mK/+YenNXHjfb/fC5WQkkpbkhiXLqHKIymjkx4kDYDLD390PvT
SvkCdJp1j+2Au2tJ9y3q+0LGj+Lc1ZzhEtZERMIfp8/MX21X6dD3aZOgAka/7GV7jvTuuNeElxyI
q4FJ/avdectDtAEpYGOTUHSO/O8mQm1DS5YwxpRUtBQJQErWfyLlWervnMkbMHjCZULnAqx7/Pxi
6iZBezxcKBFvyUd9WVu9Ch5G4y24Rugncu8zpEtkdOVaXbd6toL4LKxg4UOYiGIAAAAAAAA=


--=-XM1aDuSYUJFjYLXU6f31--

