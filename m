Return-Path: <kvm+bounces-61196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B9DA1C0F7D4
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 17:59:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B4BE3BC3D2
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 16:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56E9D314A9E;
	Mon, 27 Oct 2025 16:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p0SE22xG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E33312815
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 16:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761583977; cv=none; b=Q+oukf9bUH1bjD64+oXanWxpmVlyMFbQzpcwc9kbG2Vo4BMi0/QUSqL5BjFHCXdJ9DKCkMkw1IbZf5qj+RPixnhP4Pp8aB7uyJQ2Rg1ta0i3pC24ufi+K5pF3TyW3Fo7J6BKmMLImkQrfS3b3XoazGDMjbSnLbAZeRbYPMvTeFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761583977; c=relaxed/simple;
	bh=QmotaY3r0h035ni9QQnUzfLBB1F8gP8eFddY8fyI+JQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WvPZjS6J4cpmLIv1+/YEEy5QOVNID0qsmKameQ4NzPEF39fPNSz1XgqTK+N/sQt6fAlqeZ9gSdpD/WgUFjHsbqqWcT7a8YDUmb8LuoN3mi3Gn+qQ8C2r1AT2tLT4LMlIW1tDtPxtPnXdqJqNFuJqKIjaAELRc7yqnuivFAHS4SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p0SE22xG; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-336b646768eso5178181a91.1
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 09:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761583974; x=1762188774; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nci3vD9+uQYKkn0RLtYJrNDkeeIN+3Boy1aojm3SBYc=;
        b=p0SE22xGt+VlAqWqlPOzUOHNnUjZgdlYbBVPMP5DXsTAv+lzkAfm8mVdY0Y5bsVomT
         YLsBQn/M7Gg/S9yUJbgUwhPSHXaPQ9ge5F4IwIwA2cqB6vsSIV97ilQ79sIkOD/2oBIx
         FywvfoaV3ANnzp7qCS7+P+qn1w051c/A4JO4X5kde5HNg2Gr/RJM7Fg+jitb0Dz5al36
         /ALVx32L1UxiTj+wz9BbnVvNdEmW0kxbIg20kclmL8dU0F2Ql9E9rq5OMDCYiisNg9Rc
         gQaD5TgcD232lQnHpf9lIZuSebijfIV00eFtCs+AhyAZhuzilNerFGURy4AMUVp9dDrT
         UAnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761583974; x=1762188774;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nci3vD9+uQYKkn0RLtYJrNDkeeIN+3Boy1aojm3SBYc=;
        b=Yco7l21zYB1xZt0siDCtkeQ7nQ5S9IwgVoDRCL6YS0HQHbNIInhJ55MhswlsglIVI2
         wIt2/8bFw6xKZsSrL30G6B5btOMLVzrwpSyNyzhGkFpqsZ0bGgcHFtawvFoDlZ0eJFeu
         l+1pRNkQajryVYReneIs5/rGHX0dG7umfyG8ASjw/Szsevf8QrMGrKJITAzRajZD5L8c
         Smj8wYtfZnHL+I/5vlHgCiDb0i5v7CXRNpheKFTHFQ+wsW4tgY/NFlRufqUnFIovzKro
         UTW1hQXVaprbkMGAER5ay2pmYnfod1+DOiIe2053RHYJx8dGfnbUuyL/10ZPeusgEqFC
         nweA==
X-Forwarded-Encrypted: i=1; AJvYcCUAszEjJd8qk6T4vON7zM2+u8Kd2XsPs+UNEA8LnbpkLDdcS00x3MGzOPXnjlXdYBP2Wq4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIOAKBBxaRiM3SIRAx2T+iWFJ2xOm7lh+2ollGl2deVkhhCth6
	SZuvXfU0kfCknXHEuw12M9M364zawgouiuKyCwtyHE06KBum1P8ht3SN1+49J9RRlTbGDlxLcYQ
	HxWAV3w==
X-Google-Smtp-Source: AGHT+IFcqiR+FzM+C6QnC6le2s5MaEaeD2bzjCHYTABVRUvKH+HTCSUhlvM0hPFJOWEAvlnisl+RfK7Q2jY=
X-Received: from pjyd7.prod.google.com ([2002:a17:90a:dfc7:b0:33b:be14:2b6b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1a89:b0:327:f216:4360
 with SMTP id 98e67ed59e1d1-340279f2bf7mr578346a91.8.1761583974543; Mon, 27
 Oct 2025 09:52:54 -0700 (PDT)
Date: Mon, 27 Oct 2025 09:52:52 -0700
In-Reply-To: <20250912222525.2515416-3-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912222525.2515416-1-dmatlack@google.com> <20250912222525.2515416-3-dmatlack@google.com>
Message-ID: <aP-jZOVdrIVB_qaV@google.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Add a test for vfio-pci device IRQ
 delivery to vCPUs
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 12, 2025, David Matlack wrote:=20
> Add a new selftest called vfio_pci_irq_test that routes and delivers an
> MSI from a vfio-pci device into a guest. This test builds on top of the
> VFIO selftests library, which provides helpers for interacting with VFIO
> devices and drivers for generating interrupts with specific devices.
>=20
> This test sets up a configurable number of vCPUs in separate threads
> that all spin in guest-mode or halt. Then the test round robin routes
> the device's interrupt to different CPUs, triggers it, and then verifies
> the guest received it. The test supports several options to enable
> affinitizing the host IRQ handler to different CPUs, pinning vCPU
> threads to different CPUs, and more.
>=20
> This test also measure and reports the number of times the device IRQ
> was handled by the host. This can be used to confirm whether
> device-posted interrupts are working as expected.
>=20
> Running this test requires a PCI device bound to the vfio-pci driver,
> and then passing the BDF of the device to the test, e.g.:
>=20
>   $ ./vfio_pci_irq_test 0000:6a:01.0
>=20
> To run the test with real device-sent MSIs (-d option), the PCI device
> must also have a supported driver in
> tools/testing/selftests/vfio/lib/drivers/.
>=20
> This test only supports x86_64 for now, but can be ported to other
> architectures in the future.

Can it though?  There are bits and pieces that can be reused, but this test=
 is
x86 through and through.

> Suggested-by: Sean Christopherson <seanjc@google.com>
> Link: https://lore.kernel.org/kvm/20250404193923.1413163-68-seanjc@google=
.com/
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile.kvm      |   1 +
>  .../testing/selftests/kvm/vfio_pci_irq_test.c | 507 ++++++++++++++++++

Please break this into multiple patches, e.g. a "basic" patch and and then =
roughly
one per "advanced" command line option.

There is a _lot_ going on here, with very little documentation, e.g. the ch=
angelog
just says:

  The test supports several options to enable affinitizing the host IRQ han=
dler
  to different CPUs, pinning vCPU threads to different CPUs, and more.=20

which is rather useless for readers that aren't already familiar with much =
of
what is being tested, and why.

>  2 files changed, 508 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/vfio_pci_irq_test.c
>=20
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/sel=
ftests/kvm/Makefile.kvm
> index ac283eddb66c..fc1fb91a6810 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -148,6 +148,7 @@ TEST_GEN_PROGS_x86 +=3D rseq_test
>  TEST_GEN_PROGS_x86 +=3D steal_time
>  TEST_GEN_PROGS_x86 +=3D system_counter_offset_test
>  TEST_GEN_PROGS_x86 +=3D pre_fault_memory_test
> +TEST_GEN_PROGS_x86 +=3D vfio_pci_irq_test
> =20
>  # Compiled outputs used by test targets
>  TEST_GEN_PROGS_EXTENDED_x86 +=3D x86/nx_huge_pages_test
> diff --git a/tools/testing/selftests/kvm/vfio_pci_irq_test.c b/tools/test=
ing/selftests/kvm/vfio_pci_irq_test.c
> new file mode 100644
> index 000000000000..ed6baa8f9d74
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/vfio_pci_irq_test.c
> @@ -0,0 +1,507 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include "kvm_util.h"
> +#include "test_util.h"
> +#include "apic.h"
> +#include "processor.h"
> +
> +#include <pthread.h>
> +#include <ctype.h>
> +#include <time.h>
> +#include <linux/vfio.h>
> +#include <linux/sizes.h>
> +#include <sys/sysinfo.h>
> +
> +#include <vfio_util.h>
> +
> +static bool x2apic =3D true;
> +static bool done;
> +static bool block;
> +
> +static bool guest_ready_for_irqs[KVM_MAX_VCPUS];
> +static bool guest_received_irq[KVM_MAX_VCPUS];
> +static bool guest_received_nmi[KVM_MAX_VCPUS];
> +
> +static pid_t vcpu_tids[KVM_MAX_VCPUS];

s/tids/pids?

> +#define TIMEOUT_NS (2ULL * 1000 * 1000 * 1000)

The timeout should be configurable via command line.

> +#define READ_FROM_GUEST(_vm, _variable) ({		\
> +	sync_global_from_guest(_vm, _variable);		\
> +	READ_ONCE(_variable);				\
> +})
> +
> +#define WRITE_TO_GUEST(_vm, _variable, _value) do {	\
> +	WRITE_ONCE(_variable, _value);			\
> +	sync_global_to_guest(_vm, _variable);		\
> +} while (0)

These belong in a separate patch, and in tools/testing/selftests/kvm/includ=
e/kvm_util.h.

> +
> +static u32 guest_get_vcpu_id(void)
> +{
> +	if (x2apic)
> +		return x2apic_read_reg(APIC_ID);
> +	else
> +		return xapic_read_reg(APIC_ID) >> 24;
> +}
> +
> +static void guest_enable_interrupts(void)

This is a misleading name, e.g. I would expect it to _just_ be sti_nop().  =
If the
intent is to provide a hook for a potential non-x86 implementation, then it=
 should
probably be split into guest_arch_test_setup() and guest_arch_irq_enable() =
or so
(to align with the kernel's local_irq_{dis,en}able()).

As is, I would just omit the helper.

> +{
> +	if (x2apic)
> +		x2apic_enable();
> +	else
> +		xapic_enable();
> +
> +	sti_nop();
> +}
> +
> +static void guest_irq_handler(struct ex_regs *regs)
> +{
> +	WRITE_ONCE(guest_received_irq[guest_get_vcpu_id()], true);

Hmm, using APID ID works, but I don't like the hidden dependency on the lib=
rary
using ascending IDs starting from '0'.  This would also be a good opportuni=
ty to
improve the core infrastructure.

Rather than use APIC IDs, vm_arch_vcpu_add() could set MSR_TSC_AUX if RDTSC=
P or
RDPID is supported, and then make guest_get_vcpu_id() a common API that use=
s
RDPID or RDTSCP (prefer RDPID when possible).

Then tests that want to use guest_get_vcpu_id() can do a TEST_REQUIRE().  R=
DTSCP
exists at least as far back as Haswell, so I don't think it's unreasonable =
to
start depending on MSR_TSC_AUX.

Hmm, or we could steal an idea from the kernel and use the LDT to stash inf=
o in
a segment limit as a fallback.

> +
> +	if (x2apic)
> +		x2apic_write_reg(APIC_EOI, 0);
> +	else
> +		xapic_write_reg(APIC_EOI, 0);
> +}
> +
> +static void guest_nmi_handler(struct ex_regs *regs)
> +{
> +	WRITE_ONCE(guest_received_nmi[guest_get_vcpu_id()], true);
> +}
> +
> +static void guest_code(void)
> +{
> +	guest_enable_interrupts();
> +	WRITE_ONCE(guest_ready_for_irqs[guest_get_vcpu_id()], true);
> +
> +	while (!READ_ONCE(done)) {
> +		if (block)
> +			hlt();

		else
			cpu_relax();

> +	}
> +
> +	GUEST_DONE();
> +}
> +
> +static void *vcpu_thread_main(void *arg)
> +{
> +	struct kvm_vcpu *vcpu =3D arg;
> +	struct ucall uc;
> +
> +	WRITE_ONCE(vcpu_tids[vcpu->id], syscall(__NR_gettid));

Please add wrapper in tools/testing/selftests/kvm/include/kvm_syscalls.h.

> +
> +	vcpu_run(vcpu);
> +	TEST_ASSERT_EQ(UCALL_DONE, get_ucall(vcpu, &uc));
> +
> +	return NULL;
> +}
> +
> +static int get_cpu(struct kvm_vcpu *vcpu)
> +{
> +	pid_t tid =3D vcpu_tids[vcpu->id];
> +	cpu_set_t cpus;
> +	int cpu =3D -1;
> +	int i, ret;
> +
> +	ret =3D sched_getaffinity(tid, sizeof(cpus), &cpus);
> +	TEST_ASSERT(ret =3D=3D 0, "sched_getaffinity() failed");
> +
> +	for (i =3D 0; i < get_nprocs(); i++) {
> +		if (!CPU_ISSET(i, &cpus))
> +			continue;
> +
> +		if (cpu !=3D -1) {
> +			cpu =3D i;
> +		} else {
> +			/* vCPU is pinned to multiple CPUs */
> +			return -1;
> +		}
> +	}
> +
> +	return cpu;
> +}
> +
> +static void pin_vcpu_threads(int nr_vcpus, int start_cpu, cpu_set_t *ava=
ilable_cpus)
> +{
> +	const size_t size =3D sizeof(cpu_set_t);
> +	int nr_cpus, cpu, vcpu_index =3D 0;
> +	cpu_set_t target_cpu;
> +	int r;
> +
> +	nr_cpus =3D get_nprocs();

Generally speaking, KVM selftests try to avoid affining tasks to CPUs that =
are
outside of the original affinity list.  See various usage of sched_getaffin=
ity().


> +	CPU_ZERO(&target_cpu);
> +
> +	for (cpu =3D start_cpu;; cpu =3D (cpu + 1) % nr_cpus) {
> +		if (vcpu_index =3D=3D nr_vcpus)
> +			break;
> +
> +		if (!CPU_ISSET(cpu, available_cpus))
> +			continue;
> +
> +		CPU_SET(cpu, &target_cpu);
> +
> +		r =3D sched_setaffinity(vcpu_tids[vcpu_index], size, &target_cpu);
> +		TEST_ASSERT(r =3D=3D 0, "sched_setaffinity() failed (cpu: %d)", cpu);
> +
> +		CPU_CLR(cpu, &target_cpu);
> +
> +		vcpu_index++;
> +	}
> +}
> +
> +static FILE *open_proc_interrupts(void)
> +{
> +	FILE *fp;
> +
> +	fp =3D fopen("/proc/interrupts", "r");
> +	TEST_ASSERT(fp, "fopen(/proc/interrupts) failed");

open_path_or_exit()?

> +
> +	return fp;
> +}

And all of these /proc helpers belong in library code.

> +static int get_irq_number(const char *device_bdf, int msi)
> +{
> +	char search_string[64];
> +	char line[4096];
> +	int irq =3D -1;
> +	FILE *fp;
> +
> +	fp =3D open_proc_interrupts();
> +
> +	snprintf(search_string, sizeof(search_string), "vfio-msix[%d]", msi);
> +
> +	while (fgets(line, sizeof(line), fp)) {
> +		if (strstr(line, device_bdf) && strstr(line, search_string)) {
> +			TEST_ASSERT_EQ(1, sscanf(line, "%d:", &irq));
> +			break;
> +		}
> +	}
> +
> +	fclose(fp);
> +
> +	TEST_ASSERT(irq !=3D -1, "Failed to locate IRQ for %s %s", device_bdf, =
search_string);
> +	return irq;
> +}
> +
> +static int parse_interrupt_count(char *token)
> +{
> +	char *c;
> +
> +	for (c =3D token; *c; c++) {
> +		if (!isdigit(*c))
> +			return 0;
> +	}
> +
> +	return atoi_non_negative("interrupt count", token);
> +}
> +
> +static u64 __get_irq_count(const char *search_string)
> +{
> +	u64 total_count =3D 0;
> +	char line[4096];
> +	FILE *fp;
> +
> +	fp =3D open_proc_interrupts();
> +
> +	while (fgets(line, sizeof(line), fp)) {
> +		char *token =3D strtok(line, " ");
> +
> +		if (strcmp(token, search_string))
> +			continue;
> +
> +		while ((token =3D strtok(NULL, " ")))
> +			total_count +=3D parse_interrupt_count(token);
> +
> +		break;
> +	}
> +
> +	fclose(fp);
> +	return total_count;
> +}
> +
> +static u64 get_irq_count(int irq)
> +{
> +	char search_string[32];
> +
> +	snprintf(search_string, sizeof(search_string), "%d:", irq);
> +	return __get_irq_count(search_string);
> +}
> +
> +static void kvm_clear_gsi_routes(struct kvm_vm *vm)
> +{
> +	struct kvm_irq_routing routes =3D {};
> +
> +	vm_ioctl(vm, KVM_SET_GSI_ROUTING, &routes);
> +}
> +
> +static void kvm_route_msi(struct kvm_vm *vm, u32 gsi, struct kvm_vcpu *v=
cpu,
> +			  u8 vector, bool do_nmi)
> +{
> +	u8 buf[sizeof(struct kvm_irq_routing) + sizeof(struct kvm_irq_routing_e=
ntry)] =3D {};
> +	struct kvm_irq_routing *routes =3D (void *)&buf;
> +
> +	routes->nr =3D 1;
> +	routes->entries[0].gsi =3D gsi;
> +	routes->entries[0].type =3D KVM_IRQ_ROUTING_MSI;
> +	routes->entries[0].u.msi.address_lo =3D 0xFEE00000 | (vcpu->id << 12);
> +	routes->entries[0].u.msi.data =3D do_nmi ? NMI_VECTOR | (4 << 8) : vect=
or;
> +
> +	vm_ioctl(vm, KVM_SET_GSI_ROUTING, routes);
> +}
> +
> +static int setup_msi(struct vfio_pci_device *device, bool use_device_msi=
)
> +{
> +	const int flags =3D MAP_SHARED | MAP_ANONYMOUS;
> +	const int prot =3D PROT_READ | PROT_WRITE;
> +	struct vfio_dma_region *region;
> +
> +	if (use_device_msi) {
> +		/* A driver is required to generate an MSI. */
> +		TEST_REQUIRE(device->driver.ops);
> +
> +		/* Set up a DMA-able region for the driver to use. */

Why?

> +		region =3D &device->driver.region;
> +		region->iova =3D 0;
> +		region->size =3D SZ_2M;
> +		region->vaddr =3D mmap(NULL, region->size, prot, flags, -1, 0);

kvm_mmap()

> +		TEST_ASSERT(region->vaddr !=3D MAP_FAILED, "mmap() failed\n");
> +		vfio_pci_dma_map(device, region);
> +
> +		vfio_pci_driver_init(device);
> +
> +		return device->driver.msi;
> +	}
> +
> +	TEST_REQUIRE(device->msix_info.count > 0);
> +	vfio_pci_msix_enable(device, 0, 1);
> +	return 0;
> +}
> +
> +static void send_msi(struct vfio_pci_device *device, bool use_device_msi=
, int msi)

IMO, this helper does more harm than good.  There is only one real user, th=
e
second call unconditionally passes %false for @use_device_msi.

If you drop the helper, than there should be no need to assert that the MSI=
 is
the device MSI on *every* send via device.

> +{
> +	if (use_device_msi) {
> +		TEST_ASSERT_EQ(msi, device->driver.msi);
> +		vfio_pci_driver_send_msi(device);
> +	} else {
> +		vfio_pci_irq_trigger(device, VFIO_PCI_MSIX_IRQ_INDEX, msi);
> +	}
> +}
> +
> +static void help(const char *name)
> +{
> +	printf("Usage: %s [-a] [-b] [-d] [-e] [-h] [-i nr_irqs] [-n] [-p] [-v n=
r_vcpus] [-x] segment:bus:device.function\n",
> +	       name);
> +	printf("\n");
> +	printf("  -a: Randomly affinitize the device IRQ to different CPUs\n"
> +	       "      throughout the test.\n");
> +	printf("  -b: Block vCPUs (e.g. HLT) instead of spinning in guest-mode\=
n");
> +	printf("  -d: Use the device to trigger the IRQ instead of emulating\n"
> +	       "      it with an eventfd write.\n");
> +	printf("  -e: Destroy and recreate KVM's GSI routing table in between\n=
"
> +	       "      some interrupts.\n");
> +	printf("  -i: The number of IRQs to generate during the test.\n");
> +	printf("  -n: Route some of the device interrupts to be delivered as\n"
> +	       "      an NMI into the guest.\n");
> +	printf("  -p: Pin vCPU threads to random pCPUs throughout the test.\n")=
;
> +	printf("  -v: Set the number of vCPUs that the test should create.\n"
> +	       "      Interrupts will be round-robined among vCPUs.\n");
> +	printf("  -x: Use xAPIC mode instead of x2APIC mode in the guest.\n");
> +	printf("\n");
> +	exit(KSFT_FAIL);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	/* Random non-reserved vector and GSI to use for the device IRQ */
> +	const u8 vector =3D 0xe0;

s/random/arbitrary

Why not make it truly random?

> +	const u32 gsi =3D 32;

Ditto here.

> +	/* Test configuration (overridable by command line flags). */
> +	bool use_device_msi =3D false, irq_affinity =3D false, pin_vcpus =3D fa=
lse;
> +	bool empty =3D false, nmi =3D false;
> +	int nr_irqs =3D 1000;
> +	int nr_vcpus =3D 1;
> +
> +	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
> +	pthread_t vcpu_threads[KVM_MAX_VCPUS];
> +	u64 irq_count, pin_count, piw_count;
> +	struct vfio_pci_device *device;
> +	cpu_set_t available_cpus;
> +	const char *device_bdf;
> +	FILE *irq_affinity_fp;
> +	int i, j, c, msi, irq;
> +	struct kvm_vm *vm;
> +	int irq_cpu;
> +	int ret;
> +
> +	device_bdf =3D vfio_selftests_get_bdf(&argc, argv);
> +
> +	while ((c =3D getopt(argc, argv, "abdehi:npv:x")) !=3D -1) {
> +		switch (c) {
> +		case 'a':
> +			irq_affinity =3D true;
> +			break;
> +		case 'b':
> +			block =3D true;
> +			break;
> +		case 'd':
> +			use_device_msi =3D true;
> +			break;
> +		case 'e':
> +			empty =3D true;
> +			break;
> +		case 'i':
> +			nr_irqs =3D atoi_positive("Number of IRQs", optarg);
> +			break;
> +		case 'n':
> +			nmi =3D true;
> +			break;
> +		case 'p':
> +			pin_vcpus =3D true;
> +			break;
> +		case 'v':
> +			nr_vcpus =3D atoi_positive("nr_vcpus", optarg);
> +			break;
> +		case 'x':
> +			x2apic =3D false;
> +			break;
> +		case 'h':
> +		default:
> +			help(argv[0]);
> +		}
> +	}
> +
> +	vm =3D vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
> +	vm_install_exception_handler(vm, vector, guest_irq_handler);
> +	vm_install_exception_handler(vm, NMI_VECTOR, guest_nmi_handler);
> +
> +	if (!x2apic)
> +		virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
> +
> +	device =3D vfio_pci_device_init(device_bdf, default_iommu_mode);
> +	msi =3D setup_msi(device, use_device_msi);
> +	irq =3D get_irq_number(device_bdf, msi);
> +
> +	irq_count =3D get_irq_count(irq);
> +	pin_count =3D __get_irq_count("PIN:");
> +	piw_count =3D __get_irq_count("PIW:");

This is obviously very Intel specific information.  If you're going to prin=
t the
posted IRQ info, then the test should also print e.g. AMD GALogIntr events.

> +	printf("%s %s MSI-X[%d] (IRQ-%d) %d times\n",
> +	       use_device_msi ? "Triggering" : "Notifying the eventfd for",
> +	       device_bdf, msi, irq, nr_irqs);
> +
> +	kvm_assign_irqfd(vm, gsi, device->msi_eventfds[msi]);
> +
> +	sync_global_to_guest(vm, x2apic);
> +	sync_global_to_guest(vm, block);
> +
> +	for (i =3D 0; i < nr_vcpus; i++)
> +		pthread_create(&vcpu_threads[i], NULL, vcpu_thread_main, vcpus[i]);
> +
> +	for (i =3D 0; i < nr_vcpus; i++) {
> +		struct kvm_vcpu *vcpu =3D vcpus[i];
> +
> +		while (!READ_FROM_GUEST(vm, guest_ready_for_irqs[vcpu->id]))
> +			continue;
> +	}
> +
> +	if (pin_vcpus) {
> +		ret =3D sched_getaffinity(vcpu_tids[0], sizeof(available_cpus), &avail=
able_cpus);
> +		TEST_ASSERT(ret =3D=3D 0, "sched_getaffinity() failed");

!ret

Though this is another syscall that deserves a wrapper in kvm_syscalls.h.

> +
> +		if (nr_vcpus > CPU_COUNT(&available_cpus)) {
> +			printf("There are more vCPUs than pCPUs; refusing to pin.\n");
> +			pin_vcpus =3D false;

Why is this not an assertion?  Alternatively, why not double/triple/quadrup=
le up
as needed?

> +		}
> +	}
> +
> +	if (irq_affinity) {
> +		char path[PATH_MAX];
> +
> +		snprintf(path, sizeof(path), "/proc/irq/%d/smp_affinity_list", irq);
> +		irq_affinity_fp =3D fopen(path, "w");
> +		TEST_ASSERT(irq_affinity_fp, "fopen(%s) failed", path);

More code that belongs in the library.

> +	}
> +
> +	/* Set a consistent seed so that test are repeatable. */
> +	srand(0);

We should really figure out a solution for reproducible random numbers in t=
he
host.  Ah, and kvm_selftest_init()'s handling of guest random seeds is flaw=
ed,
because it does random() without srand() and so AFAICT, gets the same seed =
every
time.  E.g. seems like we want something like this, but with a way to overr=
ide
"random_seed" from a test.

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/sel=
ftests/kvm/lib/kvm_util.c
index 5744643d9ec3..0118fd2ba56b 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2310,6 +2310,7 @@ void __attribute((constructor)) kvm_selftest_init(voi=
d)
        struct sigaction sig_sa =3D {
                .sa_handler =3D report_unexpected_signal,
        };
+       int random_seed;
=20
        /* Tell stdout not to buffer its content. */
        setbuf(stdout, NULL);
@@ -2319,8 +2320,13 @@ void __attribute((constructor)) kvm_selftest_init(vo=
id)
        sigaction(SIGILL, &sig_sa, NULL);
        sigaction(SIGFPE, &sig_sa, NULL);
=20
+       random_seed =3D time(NULL);
+       srand(random_seed);
+
        guest_random_seed =3D last_guest_seed =3D random();
-       pr_info("Random seed: 0x%x\n", guest_random_seed);
+
+       pr_info("Guest random seed: 0x%x (srand: 0x%x)\n",
+               guest_random_seed, random_seed);
=20
        kvm_selftest_arch_init();
 }


> +	for (i =3D 0; i < nr_irqs; i++) {
> +		struct kvm_vcpu *vcpu =3D vcpus[i % nr_vcpus];
> +		const bool do_nmi =3D nmi && (i & BIT(2));
> +		const bool do_empty =3D empty && (i & BIT(3));
> +		struct timespec start;
> +
> +		if (do_empty)
> +			kvm_clear_gsi_routes(vm);
> +
> +		kvm_route_msi(vm, gsi, vcpu, vector, do_nmi);
> +
> +		if (irq_affinity && vcpu->id =3D=3D 0) {

Please add comments explaining why affinity related stuff is only applied t=
o
vCPU0.  I could probably figure it out, but I really shouldn't have to.

> +			irq_cpu =3D rand() % get_nprocs();
> +
> +			ret =3D fprintf(irq_affinity_fp, "%d\n", irq_cpu);
> +			TEST_ASSERT(ret > 0, "Failed to affinitize IRQ-%d to CPU %d", irq, ir=
q_cpu);



> +		}
> +
> +		if (pin_vcpus && vcpu->id =3D=3D 0)
> +			pin_vcpu_threads(nr_vcpus, rand() % get_nprocs(), &available_cpus);
> +
> +		for (j =3D 0; j < nr_vcpus; j++) {
> +			TEST_ASSERT_EQ(READ_FROM_GUEST(vm, guest_received_irq[vcpu->id]), fal=
se);
> +			TEST_ASSERT_EQ(READ_FROM_GUEST(vm, guest_received_nmi[vcpu->id]), fal=
se);

These won't generate helpful assert messages.

> +		}
> +
> +		send_msi(device, use_device_msi, msi);
> +
> +		clock_gettime(CLOCK_MONOTONIC, &start);
> +		for (;;) {
> +			if (do_nmi && READ_FROM_GUEST(vm, guest_received_nmi[vcpu->id]))
> +				break;
> +
> +			if (!do_nmi && READ_FROM_GUEST(vm, guest_received_irq[vcpu->id]))
> +				break;

		received_irq =3D do_nmi ? &guest_received_nmi[vcpu->id] :
					&guest_received_irq[vcpu->id];
		while (!READ_FROM_GUEST(vm, *received_irq))
			if (timespec_to_ns(timespec_elapsed(start)) > TIMEOUT_NS) {
				...
			}=09

			cpu_relax();
		}

> +
> +			if (timespec_to_ns(timespec_elapsed(start)) > TIMEOUT_NS) {
> +				printf("Timeout waiting for interrupt!\n");
> +				printf("  vCPU: %d\n", vcpu->id);
> +				printf("  do_nmi: %d\n", do_nmi);
> +				printf("  do_empty: %d\n", do_empty);
> +				if (irq_affinity)
> +					printf("  irq_cpu: %d\n", irq_cpu);

vfio_pci_irq_test.c: In function =E2=80=98main=E2=80=99:
vfio_pci_irq_test.c:469:41: error: =E2=80=98irq_cpu=E2=80=99 may be used un=
initialized [-Werror=3Dmaybe-uninitialized]
  469 |                                         printf("  irq_cpu: %d\n", i=
rq_cpu);
      |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~
vfio_pci_irq_test.c:332:13: note: =E2=80=98irq_cpu=E2=80=99 was declared he=
re
  332 |         int irq_cpu;
      |             ^~~~~~~

> +				if (pin_vcpus)
> +					printf("  vcpu_cpu: %d\n", get_cpu(vcpu));
> +
> +				TEST_FAIL("vCPU never received IRQ!\n");
> +			}
> +		}

		TEST_ASSERT(guest_received_irq[vcpu->id] !=3D
			    guest_received_nmi[vcpu->id],
			    "blah blah blah");

		WRITE_TO_GUEST(vm, *received_irq, false);

> +		if (do_nmi)
> +			WRITE_TO_GUEST(vm, guest_received_nmi[vcpu->id], false);
> +		else
> +			WRITE_TO_GUEST(vm, guest_received_irq[vcpu->id], false);
> +	}
> +
> +	WRITE_TO_GUEST(vm, done, true);
> +
> +	for (i =3D 0; i < nr_vcpus; i++) {
> +		if (block) {
> +			kvm_route_msi(vm, gsi, vcpus[i], vector, false);
> +			send_msi(device, false, msi);
> +		}
> +
> +		pthread_join(vcpu_threads[i], NULL);
> +	}
> +
> +	if (irq_affinity)
> +		fclose(irq_affinity_fp);
> +
> +	printf("Host interrupts handled:\n");
> +	printf("  IRQ-%d: %lu\n", irq, get_irq_count(irq) - irq_count);
> +	printf("  Posted-interrupt notification events: %lu\n",
> +	       __get_irq_count("PIN:") - pin_count);
> +	printf("  Posted-interrupt wakeup events: %lu\n",
> +	       __get_irq_count("PIW:") - piw_count);
> +
> +	vfio_pci_device_cleanup(device);
> +
> +	return 0;
> +}
> --=20
> 2.51.0.384.g4c02a37b29-goog
>=20

