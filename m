Return-Path: <kvm+bounces-57201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 13B13B51806
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 15:37:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 155F3188993C
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 13:37:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDE47315785;
	Wed, 10 Sep 2025 13:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e/49O4VN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067514A1A;
	Wed, 10 Sep 2025 13:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757511413; cv=none; b=fwzfVXnZGr7ixmUK+qVgr5m2Wcf6yg2YWz3RvB2dTKuvBAbJ6pT15VGDAEsnhrVhhWXoOLK3WuhgyjcOtnEFHjtZVxJ7i+Rw1fo0hR0blNBFlTOOMp8T+BVV9SDBQ2TQRSt6YD7KLko9D869bTQAlGxL9sdgAMWD1vKtOtFX3BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757511413; c=relaxed/simple;
	bh=7Wwh4dWJ4kd1y6JrFld/PSEmpOQhwY3hnN2xoW5xdqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ETURE8XXVxdTm8UXET2o1RNdFbOKOAlrjRC2wIO5a2K9n/E5sQQUUeKnpOxmhe9ekZDTpmgvWlNVKA4ariMPKAJg73GCeW5Oool3W8ZYdMdfOBZDgGrXHalNrmR9sHXAlKBtAmff2kgZ49RjaDUGT6qs1OPZCTHOfbCHwcOu8Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e/49O4VN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17EF1C4CEF0;
	Wed, 10 Sep 2025 13:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757511412;
	bh=7Wwh4dWJ4kd1y6JrFld/PSEmpOQhwY3hnN2xoW5xdqo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e/49O4VNHyDNK1ZcH4D00hS+DWWGb1eZLoKF/C6a90jObZ462rU0vZ2IDiUZ5e9Mk
	 z6xXWrWJwX3cLIsM9elzIdisAol9EhW3YbJxOcazfZpB+rQA6QSZwuantwHbQ1ExGq
	 plPqb607Se+ryZxVGEK+ypwR4MG3O0SmRZUe9bBfsmf1V+9lOKixp3fTM+iB1UFM7z
	 nU4gqwqJD7nUNZ1MM8zzI4AgYqwVFrvtyYw7Bl/X7k++adCOVexgqXlUU+Z9A64trs
	 xPp1RKUuuzbVU5Zntgjjkq0BGC+6TAJVm4XKjU3opnNtEi82HIAmkAyEFv3yRkh7mi
	 gmWas7poS0gkA==
Date: Wed, 10 Sep 2025 19:03:38 +0530
From: Naveen N Rao <naveen@kernel.org>
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>, Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] KVM: selftests: Test TPR / CR8 sync and interrupt
 masking
Message-ID: <ck4k7g7pd77ojfptkp4yg6qz66queg2n6eo4o54ezhdbv4rvgn@mpuss5twpxhi>
References: <cover.1756139678.git.maciej.szmigiero@oracle.com>
 <a5efbf76990d023c7cf21c5a4c170f4ad0234d85.1756139678.git.maciej.szmigiero@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5efbf76990d023c7cf21c5a4c170f4ad0234d85.1756139678.git.maciej.szmigiero@oracle.com>

On Mon, Aug 25, 2025 at 06:44:29PM +0200, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> Add a few extra TPR / CR8 tests to x86's xapic_state_test to see if:
> * TPR is 0 on reset,
> * TPR, PPR and CR8 are equal inside the guest,
> * TPR and CR8 read equal by the host after a VMExit
> * TPR borderline values set by the host correctly mask interrupts in the
> guest.
> 
> These hopefully will catch the most obvious cases of improper TPR sync or
> interrupt masking.
> 
> Do these tests both in x2APIC and xAPIC modes.
> The x2APIC mode uses SELF_IPI register to trigger interrupts to give it a
> bit of exercise too.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> ---
>  .../testing/selftests/kvm/include/x86/apic.h  |   5 +
>  .../selftests/kvm/x86/xapic_state_test.c      | 265 +++++++++++++++++-
>  2 files changed, 267 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86/apic.h b/tools/testing/selftests/kvm/include/x86/apic.h
> index 80fe9f69b38d..67285e533e14 100644
> --- a/tools/testing/selftests/kvm/include/x86/apic.h
> +++ b/tools/testing/selftests/kvm/include/x86/apic.h
> @@ -27,7 +27,11 @@
>  #define	APIC_LVR	0x30
>  #define		GET_APIC_ID_FIELD(x)	(((x) >> 24) & 0xFF)
>  #define	APIC_TASKPRI	0x80
> +#define		APIC_TASKPRI_TP_SHIFT	4
> +#define		APIC_TASKPRI_TP_MASK	GENMASK(7, 4)
>  #define	APIC_PROCPRI	0xA0
> +#define		APIC_PROCPRI_PP_SHIFT	4
> +#define		APIC_PROCPRI_PP_MASK	GENMASK(7, 4)

These can probably be simplified with get()/set() macros. Something like 
this:
#define	GET_APIC_PRI(x)		(((x) >> 4) & 0xF)
#define	SET_APIC_PRI(x, y)	(((x) & ~0xF0) | (((y) & 0xF) << 4))

>  #define	APIC_EOI	0xB0
>  #define	APIC_SPIV	0xF0
>  #define		APIC_SPIV_FOCUS_DISABLED	(1 << 9)
> @@ -67,6 +71,7 @@
>  #define	APIC_TMICT	0x380
>  #define	APIC_TMCCT	0x390
>  #define	APIC_TDCR	0x3E0
> +#define	APIC_SELF_IPI	0x3F0
>  
>  void apic_disable(void);
>  void xapic_enable(void);
> diff --git a/tools/testing/selftests/kvm/x86/xapic_state_test.c b/tools/testing/selftests/kvm/x86/xapic_state_test.c
> index fdebff1165c7..968e5e539a1a 100644
> --- a/tools/testing/selftests/kvm/x86/xapic_state_test.c
> +++ b/tools/testing/selftests/kvm/x86/xapic_state_test.c
> @@ -1,9 +1,11 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  #include <fcntl.h>
> +#include <stdatomic.h>
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
>  #include <sys/ioctl.h>
> +#include <unistd.h>
>  
>  #include "apic.h"
>  #include "kvm_util.h"
> @@ -16,6 +18,245 @@ struct xapic_vcpu {
>  	bool has_xavic_errata;
>  };
>  
> +#define IRQ_VECTOR 0x20
> +
> +/* See also the comment at similar assertion in memslot_perf_test.c */
> +static_assert(ATOMIC_INT_LOCK_FREE == 2, "atomic int is not lockless");
> +
> +static atomic_uint tpr_guest_irq_sync_val;
> +
> +static void tpr_guest_irq_sync_flag_reset(void)
> +{
> +	atomic_store_explicit(&tpr_guest_irq_sync_val, 0,
> +			      memory_order_release);
> +}
> +
> +static unsigned int tpr_guest_irq_sync_val_get(void)
> +{
> +	return atomic_load_explicit(&tpr_guest_irq_sync_val,
> +				    memory_order_acquire);
> +}
> +
> +static void tpr_guest_irq_sync_val_inc(void)
> +{
> +	atomic_fetch_add_explicit(&tpr_guest_irq_sync_val, 1,
> +				  memory_order_acq_rel);
> +}
> +
> +static void tpr_guest_irq_handler_xapic(struct ex_regs *regs)
> +{
> +	tpr_guest_irq_sync_val_inc();
> +
> +	xapic_write_reg(APIC_EOI, 0);
> +}
> +
> +static void tpr_guest_irq_handler_x2apic(struct ex_regs *regs)
> +{
> +	tpr_guest_irq_sync_val_inc();
> +
> +	x2apic_write_reg(APIC_EOI, 0);
> +}
> +
> +static void tpr_guest_irq_queue(bool x2apic)
> +{
> +	if (x2apic) {
> +		x2apic_write_reg(APIC_SELF_IPI, IRQ_VECTOR);
> +	} else {
> +		uint32_t icr, icr2;
> +
> +		icr = APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED |
> +			IRQ_VECTOR;
> +		icr2 = 0;
> +
> +		xapic_write_reg(APIC_ICR2, icr2);
> +		xapic_write_reg(APIC_ICR, icr);
> +	}
> +}
> +
> +static uint8_t tpr_guest_tpr_get(bool x2apic)
> +{
> +	uint32_t taskpri;
> +
> +	if (x2apic)
> +		taskpri = x2apic_read_reg(APIC_TASKPRI);
> +	else
> +		taskpri = xapic_read_reg(APIC_TASKPRI);

Rather than pass x2apic flag to all these helpers, it might be better to 
have a global is_x2apic, and helpers for reading APIC registers.  See 
tools/testing/selftests/kvm/x86/apic_bus_clock_test.c for an example 
that we should be able to adopt here.

> +
> +	return (taskpri & APIC_TASKPRI_TP_MASK) >> APIC_TASKPRI_TP_SHIFT;
> +}
> +
> +static uint8_t tpr_guest_ppr_get(bool x2apic)
> +{
> +	uint32_t procpri;
> +
> +	if (x2apic)
> +		procpri = x2apic_read_reg(APIC_PROCPRI);
> +	else
> +		procpri = xapic_read_reg(APIC_PROCPRI);
> +
> +	return (procpri & APIC_PROCPRI_PP_MASK) >> APIC_PROCPRI_PP_SHIFT;
> +}
> +
> +static uint8_t tpr_guest_cr8_get(void)
> +{
> +	uint64_t cr8;
> +
> +	asm volatile ("mov %%cr8, %[cr8]\n\t" : [cr8] "=r"(cr8));
> +
> +	return cr8 & GENMASK(3, 0);

Why mask off the remaining bits? Shouldn't they all be zero?

> +}
> +
> +static void tpr_guest_check_tpr_ppr_cr8_equal(bool x2apic)
> +{
> +	uint8_t tpr;
> +
> +	tpr = tpr_guest_tpr_get(x2apic);
> +
> +	GUEST_ASSERT_EQ(tpr_guest_ppr_get(x2apic), tpr);
> +	GUEST_ASSERT_EQ(tpr_guest_cr8_get(), tpr);
> +}
> +
> +static void tpr_guest_code(uint64_t x2apic)
> +{
> +	cli();
> +
> +	if (x2apic)
> +		x2apic_enable();
> +	else
> +		xapic_enable();
> +
> +	tpr_guest_check_tpr_ppr_cr8_equal(x2apic);

Would be good to confirm that the guest reads a zero TPR here on 
startup.

> +
> +	tpr_guest_irq_queue(x2apic);
> +
> +	/* TPR = 0 but IRQ masked by IF=0, should not fire */
> +	udelay(1000);
> +	GUEST_ASSERT_EQ(tpr_guest_irq_sync_val_get(), 0);
> +
> +	sti();
> +
> +	/* IF=1 now, IRQ should fire */
> +	while (tpr_guest_irq_sync_val_get() == 0)
> +		cpu_relax();
> +	GUEST_ASSERT_EQ(tpr_guest_irq_sync_val_get(), 1);
> +
> +	GUEST_SYNC(0);
> +	tpr_guest_check_tpr_ppr_cr8_equal(x2apic);
> +
> +	tpr_guest_irq_queue(x2apic);
> +
> +	/* IRQ masked by barely high enough TPR now, should not fire */
> +	udelay(1000);
> +	GUEST_ASSERT_EQ(tpr_guest_irq_sync_val_get(), 1);
> +
> +	GUEST_SYNC(1);
> +	tpr_guest_check_tpr_ppr_cr8_equal(x2apic);
> +
> +	/* TPR barely low enough now to unmask IRQ, should fire */
> +	while (tpr_guest_irq_sync_val_get() == 1)
> +		cpu_relax();
> +	GUEST_ASSERT_EQ(tpr_guest_irq_sync_val_get(), 2);
> +
> +	GUEST_DONE();
> +}

You don't necessarily have to do it, but it would be good to have a test 
where the guest updates the TPR too -- as a way to confirm that V_TPR is 
kept in sync with CR8 and TPR.

> +
> +static uint8_t lapic_tpr_get(struct kvm_lapic_state *xapic)
> +{
> +	return (*((u32 *)&xapic->regs[APIC_TASKPRI]) & APIC_TASKPRI_TP_MASK) >>
> +		APIC_TASKPRI_TP_SHIFT;
> +}
> +
> +static void lapic_tpr_set(struct kvm_lapic_state *xapic, uint8_t val)
> +{
> +	*((u32 *)&xapic->regs[APIC_TASKPRI]) &= ~APIC_TASKPRI_TP_MASK;
> +	*((u32 *)&xapic->regs[APIC_TASKPRI]) |= val << APIC_TASKPRI_TP_SHIFT;
> +}
> +
> +static uint8_t sregs_tpr(struct kvm_sregs *sregs)
> +{
> +	return sregs->cr8 & GENMASK(3, 0);

Here too.. do we need to mask the reserved bits?

> +}
> +
> +static void test_tpr_check_tpr_zero(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_lapic_state xapic;
> +
> +	vcpu_ioctl(vcpu, KVM_GET_LAPIC, &xapic);
> +
> +	TEST_ASSERT_EQ(lapic_tpr_get(&xapic), 0);
> +}
> +
> +static void test_tpr_check_tpr_cr8_equal(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_sregs sregs;
> +	struct kvm_lapic_state xapic;
> +
> +	vcpu_sregs_get(vcpu, &sregs);
> +	vcpu_ioctl(vcpu, KVM_GET_LAPIC, &xapic);
> +
> +	TEST_ASSERT_EQ(sregs_tpr(&sregs), lapic_tpr_get(&xapic));
> +}
> +
> +static void test_tpr_mask_irq(struct kvm_vcpu *vcpu, bool mask)
> +{
> +	struct kvm_lapic_state xapic;
> +	uint8_t tpr;
> +
> +	static_assert(IRQ_VECTOR >= 16, "invalid IRQ vector number");
> +	tpr = IRQ_VECTOR / 16;
> +	if (!mask)
> +		tpr--;
> +
> +	vcpu_ioctl(vcpu, KVM_GET_LAPIC, &xapic);
> +	lapic_tpr_set(&xapic, tpr);
> +	vcpu_ioctl(vcpu, KVM_SET_LAPIC, &xapic);
> +}
> +
> +static void test_tpr(struct kvm_vcpu *vcpu, bool x2apic)
> +{
> +	bool run_guest = true;
> +
> +	vcpu_args_set(vcpu, 1, (uint64_t)x2apic);
> +
> +	/* According to the SDM/APM the TPR value at reset is 0 */
> +	test_tpr_check_tpr_zero(vcpu);
> +	test_tpr_check_tpr_cr8_equal(vcpu);
> +
> +	tpr_guest_irq_sync_flag_reset();
> +
> +	while (run_guest) {
> +		struct ucall uc;
> +
> +		alarm(2);
> +		vcpu_run(vcpu);
> +		alarm(0);
> +
> +		switch (get_ucall(vcpu, &uc)) {
> +		case UCALL_ABORT:
> +			REPORT_GUEST_ASSERT(uc);
> +			break;
> +		case UCALL_DONE:
> +			test_tpr_check_tpr_cr8_equal(vcpu);
> +
> +			run_guest = false;
> +			break;
> +		case UCALL_SYNC:
> +			test_tpr_check_tpr_cr8_equal(vcpu);
> +
> +			if (uc.args[1] == 0)
> +				test_tpr_mask_irq(vcpu, true);
> +			else if (uc.args[1] == 1)
> +				test_tpr_mask_irq(vcpu, false);

Having wrappers around that will make this clearer, I think:
	test_tpr_set_tpr()
	test_tpr_clear_tpr()
or such?

> +			else
> +				TEST_FAIL("Unknown SYNC %lu", uc.args[1]);
> +			break;
> +		default:
> +			TEST_FAIL("Unknown ucall result 0x%lx", uc.cmd);
> +			break;
> +		}
> +	}
> +}
> +
>  static void xapic_guest_code(void)
>  {
>  	cli();
> @@ -195,6 +436,12 @@ static void test_apic_id(void)
>  	kvm_vm_free(vm);
>  }
>  
> +static void clear_x2apic_cap_map_apic(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
> +{
> +	vcpu_clear_cpuid_feature(vcpu, X86_FEATURE_X2APIC);
> +	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
> +}
> +
>  static void test_x2apic_id(void)
>  {
>  	struct kvm_lapic_state lapic = {};
> @@ -230,10 +477,17 @@ int main(int argc, char *argv[])
>  	};
>  	struct kvm_vm *vm;
>  
> +	/* x2APIC tests */
> +
>  	vm = vm_create_with_one_vcpu(&x.vcpu, x2apic_guest_code);
>  	test_icr(&x);
>  	kvm_vm_free(vm);
>  
> +	vm = vm_create_with_one_vcpu(&x.vcpu, tpr_guest_code);
> +	vm_install_exception_handler(vm, IRQ_VECTOR, tpr_guest_irq_handler_x2apic);
> +	test_tpr(x.vcpu, true);

Any reason not to pass in a pointer to x similar to test_icr()?


- Naveen


