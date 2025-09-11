Return-Path: <kvm+bounces-57355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EDA09B53C05
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 21:00:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 10E8218874E3
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 19:01:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0832424DCE2;
	Thu, 11 Sep 2025 19:00:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from vps-ovh.mhejs.net (vps-ovh.mhejs.net [145.239.82.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C8B2DC77C;
	Thu, 11 Sep 2025 19:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=145.239.82.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757617249; cv=none; b=W5OHC/hv0J7jtlsZhHVzMs+M0eyCdBLe4228y80AMrbc4b51i7ioBmqAGFOhfF4i7IOo9nt91UETBCHisYXRlDPAUX05mq2Jpln6yZbpfFMe3vaVhambcuuHryCIZByWZbOl8CGLu3Mqe5pFdjCSmbOfypo5O5PnZIlD6JcJQR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757617249; c=relaxed/simple;
	bh=bfsMRE1n8bCmcMd24jI8o9ZdZ/6D3p7i3S2yV/v7qZU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YNvULKHRzpTLNKblCu+WvM+ynMOaI4uKEpvnajJEuterjZ06QHQC0SZhZISp7mlpqVH3LDwYUFKE7xJ/KkBjTfnrVBz89m1BXVFOl+6xyUrnwP3TQ83INdbM9p9Je+GotG+zT3p0mliiydQ40LOc3z/5MgEySzbRSddX0Kc26Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name; spf=pass smtp.mailfrom=vps-ovh.mhejs.net; arc=none smtp.client-ip=145.239.82.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vps-ovh.mhejs.net
Received: from MUA
	by vps-ovh.mhejs.net with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <mhej@vps-ovh.mhejs.net>)
	id 1uwmX2-00000002drh-0A1a;
	Thu, 11 Sep 2025 21:00:32 +0200
Message-ID: <bddbbb71-fa9e-4998-940a-64e2f09977ba@maciej.szmigiero.name>
Date: Thu, 11 Sep 2025 21:00:26 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] KVM: selftests: Test TPR / CR8 sync and interrupt
 masking
To: Naveen N Rao <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Maxim Levitsky
 <mlevitsk@redhat.com>, Suravee Suthikulpanit
 <Suravee.Suthikulpanit@amd.com>,
 Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <cover.1756139678.git.maciej.szmigiero@oracle.com>
 <a5efbf76990d023c7cf21c5a4c170f4ad0234d85.1756139678.git.maciej.szmigiero@oracle.com>
 <ck4k7g7pd77ojfptkp4yg6qz66queg2n6eo4o54ezhdbv4rvgn@mpuss5twpxhi>
Content-Language: en-US, pl-PL
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Autocrypt: addr=mail@maciej.szmigiero.name; keydata=
 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
Disposition-Notification-To: "Maciej S. Szmigiero"
 <mail@maciej.szmigiero.name>
In-Reply-To: <ck4k7g7pd77ojfptkp4yg6qz66queg2n6eo4o54ezhdbv4rvgn@mpuss5twpxhi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: mhej@vps-ovh.mhejs.net

On 10.09.2025 15:33, Naveen N Rao wrote:
> On Mon, Aug 25, 2025 at 06:44:29PM +0200, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>
>> Add a few extra TPR / CR8 tests to x86's xapic_state_test to see if:
>> * TPR is 0 on reset,
>> * TPR, PPR and CR8 are equal inside the guest,
>> * TPR and CR8 read equal by the host after a VMExit
>> * TPR borderline values set by the host correctly mask interrupts in the
>> guest.
>>
>> These hopefully will catch the most obvious cases of improper TPR sync or
>> interrupt masking.
>>
>> Do these tests both in x2APIC and xAPIC modes.
>> The x2APIC mode uses SELF_IPI register to trigger interrupts to give it a
>> bit of exercise too.
>>
>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>> ---
>>   .../testing/selftests/kvm/include/x86/apic.h  |   5 +
>>   .../selftests/kvm/x86/xapic_state_test.c      | 265 +++++++++++++++++-
>>   2 files changed, 267 insertions(+), 3 deletions(-)
>>
>> diff --git a/tools/testing/selftests/kvm/include/x86/apic.h b/tools/testing/selftests/kvm/include/x86/apic.h
>> index 80fe9f69b38d..67285e533e14 100644
>> --- a/tools/testing/selftests/kvm/include/x86/apic.h
>> +++ b/tools/testing/selftests/kvm/include/x86/apic.h
>> @@ -27,7 +27,11 @@
>>   #define	APIC_LVR	0x30
>>   #define		GET_APIC_ID_FIELD(x)	(((x) >> 24) & 0xFF)
>>   #define	APIC_TASKPRI	0x80
>> +#define		APIC_TASKPRI_TP_SHIFT	4
>> +#define		APIC_TASKPRI_TP_MASK	GENMASK(7, 4)
>>   #define	APIC_PROCPRI	0xA0
>> +#define		APIC_PROCPRI_PP_SHIFT	4
>> +#define		APIC_PROCPRI_PP_MASK	GENMASK(7, 4)
> 
> These can probably be simplified with get()/set() macros. Something like
> this:
> #define	GET_APIC_PRI(x)		(((x) >> 4) & 0xF)
> #define	SET_APIC_PRI(x, y)	(((x) & ~0xF0) | (((y) & 0xF) << 4))

Seems reasonable, however I am not a fan of manually encoding
masks like 0xF0 - will use GENMASK(7, 4) inside these macros instead.

>>   #define	APIC_EOI	0xB0
>>   #define	APIC_SPIV	0xF0
>>   #define		APIC_SPIV_FOCUS_DISABLED	(1 << 9)
>> @@ -67,6 +71,7 @@
>>   #define	APIC_TMICT	0x380
>>   #define	APIC_TMCCT	0x390
>>   #define	APIC_TDCR	0x3E0
>> +#define	APIC_SELF_IPI	0x3F0
>>   
>>   void apic_disable(void);
>>   void xapic_enable(void);
>> diff --git a/tools/testing/selftests/kvm/x86/xapic_state_test.c b/tools/testing/selftests/kvm/x86/xapic_state_test.c
>> index fdebff1165c7..968e5e539a1a 100644
>> --- a/tools/testing/selftests/kvm/x86/xapic_state_test.c
>> +++ b/tools/testing/selftests/kvm/x86/xapic_state_test.c
>> @@ -1,9 +1,11 @@
>>   // SPDX-License-Identifier: GPL-2.0-only
>>   #include <fcntl.h>
>> +#include <stdatomic.h>
>>   #include <stdio.h>
>>   #include <stdlib.h>
>>   #include <string.h>
>>   #include <sys/ioctl.h>
>> +#include <unistd.h>
>>   
>>   #include "apic.h"
>>   #include "kvm_util.h"
>> @@ -16,6 +18,245 @@ struct xapic_vcpu {
>>   	bool has_xavic_errata;
>>   };
>>   
>> +#define IRQ_VECTOR 0x20
>> +
>> +/* See also the comment at similar assertion in memslot_perf_test.c */
>> +static_assert(ATOMIC_INT_LOCK_FREE == 2, "atomic int is not lockless");
>> +
>> +static atomic_uint tpr_guest_irq_sync_val;
>> +
>> +static void tpr_guest_irq_sync_flag_reset(void)
>> +{
>> +	atomic_store_explicit(&tpr_guest_irq_sync_val, 0,
>> +			      memory_order_release);
>> +}
>> +
>> +static unsigned int tpr_guest_irq_sync_val_get(void)
>> +{
>> +	return atomic_load_explicit(&tpr_guest_irq_sync_val,
>> +				    memory_order_acquire);
>> +}
>> +
>> +static void tpr_guest_irq_sync_val_inc(void)
>> +{
>> +	atomic_fetch_add_explicit(&tpr_guest_irq_sync_val, 1,
>> +				  memory_order_acq_rel);
>> +}
>> +
>> +static void tpr_guest_irq_handler_xapic(struct ex_regs *regs)
>> +{
>> +	tpr_guest_irq_sync_val_inc();
>> +
>> +	xapic_write_reg(APIC_EOI, 0);
>> +}
>> +
>> +static void tpr_guest_irq_handler_x2apic(struct ex_regs *regs)
>> +{
>> +	tpr_guest_irq_sync_val_inc();
>> +
>> +	x2apic_write_reg(APIC_EOI, 0);
>> +}
>> +
>> +static void tpr_guest_irq_queue(bool x2apic)
>> +{
>> +	if (x2apic) {
>> +		x2apic_write_reg(APIC_SELF_IPI, IRQ_VECTOR);
>> +	} else {
>> +		uint32_t icr, icr2;
>> +
>> +		icr = APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED |
>> +			IRQ_VECTOR;
>> +		icr2 = 0;
>> +
>> +		xapic_write_reg(APIC_ICR2, icr2);
>> +		xapic_write_reg(APIC_ICR, icr);
>> +	}
>> +}
>> +
>> +static uint8_t tpr_guest_tpr_get(bool x2apic)
>> +{
>> +	uint32_t taskpri;
>> +
>> +	if (x2apic)
>> +		taskpri = x2apic_read_reg(APIC_TASKPRI);
>> +	else
>> +		taskpri = xapic_read_reg(APIC_TASKPRI);
> 
> Rather than pass x2apic flag to all these helpers, it might be better to
> have a global is_x2apic, and helpers for reading APIC registers.  See
> tools/testing/selftests/kvm/x86/apic_bus_clock_test.c for an example
> that we should be able to adopt here.

will do.

>> +
>> +	return (taskpri & APIC_TASKPRI_TP_MASK) >> APIC_TASKPRI_TP_SHIFT;
>> +}
>> +
>> +static uint8_t tpr_guest_ppr_get(bool x2apic)
>> +{
>> +	uint32_t procpri;
>> +
>> +	if (x2apic)
>> +		procpri = x2apic_read_reg(APIC_PROCPRI);
>> +	else
>> +		procpri = xapic_read_reg(APIC_PROCPRI);
>> +
>> +	return (procpri & APIC_PROCPRI_PP_MASK) >> APIC_PROCPRI_PP_SHIFT;
>> +}
>> +
>> +static uint8_t tpr_guest_cr8_get(void)
>> +{
>> +	uint64_t cr8;
>> +
>> +	asm volatile ("mov %%cr8, %[cr8]\n\t" : [cr8] "=r"(cr8));
>> +
>> +	return cr8 & GENMASK(3, 0);
> 
> Why mask off the remaining bits? Shouldn't they all be zero?

The remaining bits of CR8 are reserved and while they
are all zero in the current CPUs they in principle could
be used for something else in the future.

>> +}
>> +
>> +static void tpr_guest_check_tpr_ppr_cr8_equal(bool x2apic)
>> +{
>> +	uint8_t tpr;
>> +
>> +	tpr = tpr_guest_tpr_get(x2apic);
>> +
>> +	GUEST_ASSERT_EQ(tpr_guest_ppr_get(x2apic), tpr);
>> +	GUEST_ASSERT_EQ(tpr_guest_cr8_get(), tpr);
>> +}
>> +
>> +static void tpr_guest_code(uint64_t x2apic)
>> +{
>> +	cli();
>> +
>> +	if (x2apic)
>> +		x2apic_enable();
>> +	else
>> +		xapic_enable();
>> +
>> +	tpr_guest_check_tpr_ppr_cr8_equal(x2apic);
> 
> Would be good to confirm that the guest reads a zero TPR here on
> startup.

Will add such check.

>> +
>> +	tpr_guest_irq_queue(x2apic);
>> +
>> +	/* TPR = 0 but IRQ masked by IF=0, should not fire */
>> +	udelay(1000);
>> +	GUEST_ASSERT_EQ(tpr_guest_irq_sync_val_get(), 0);
>> +
>> +	sti();
>> +
>> +	/* IF=1 now, IRQ should fire */
>> +	while (tpr_guest_irq_sync_val_get() == 0)
>> +		cpu_relax();
>> +	GUEST_ASSERT_EQ(tpr_guest_irq_sync_val_get(), 1);
>> +
>> +	GUEST_SYNC(0);
>> +	tpr_guest_check_tpr_ppr_cr8_equal(x2apic);
>> +
>> +	tpr_guest_irq_queue(x2apic);
>> +
>> +	/* IRQ masked by barely high enough TPR now, should not fire */
>> +	udelay(1000);
>> +	GUEST_ASSERT_EQ(tpr_guest_irq_sync_val_get(), 1);
>> +
>> +	GUEST_SYNC(1);
>> +	tpr_guest_check_tpr_ppr_cr8_equal(x2apic);
>> +
>> +	/* TPR barely low enough now to unmask IRQ, should fire */
>> +	while (tpr_guest_irq_sync_val_get() == 1)
>> +		cpu_relax();
>> +	GUEST_ASSERT_EQ(tpr_guest_irq_sync_val_get(), 2);
>> +
>> +	GUEST_DONE();
>> +}
> 
> You don't necessarily have to do it, but it would be good to have a test
> where the guest updates the TPR too -- as a way to confirm that V_TPR is
> kept in sync with CR8 and TPR.

Sure, but this self test is supposed to prevent regressions with respect
to the AVIC TPR sync issue so further extensions will probably have to
come later.

>> +
>> +static uint8_t lapic_tpr_get(struct kvm_lapic_state *xapic)
>> +{
>> +	return (*((u32 *)&xapic->regs[APIC_TASKPRI]) & APIC_TASKPRI_TP_MASK) >>
>> +		APIC_TASKPRI_TP_SHIFT;
>> +}
>> +
>> +static void lapic_tpr_set(struct kvm_lapic_state *xapic, uint8_t val)
>> +{
>> +	*((u32 *)&xapic->regs[APIC_TASKPRI]) &= ~APIC_TASKPRI_TP_MASK;
>> +	*((u32 *)&xapic->regs[APIC_TASKPRI]) |= val << APIC_TASKPRI_TP_SHIFT;
>> +}
>> +
>> +static uint8_t sregs_tpr(struct kvm_sregs *sregs)
>> +{
>> +	return sregs->cr8 & GENMASK(3, 0);
> 
> Here too.. do we need to mask the reserved bits?

As above, I think they should be masked for future-proofing.

>> +}
>> +
>> +static void test_tpr_check_tpr_zero(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_lapic_state xapic;
>> +
>> +	vcpu_ioctl(vcpu, KVM_GET_LAPIC, &xapic);
>> +
>> +	TEST_ASSERT_EQ(lapic_tpr_get(&xapic), 0);
>> +}
>> +
>> +static void test_tpr_check_tpr_cr8_equal(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_sregs sregs;
>> +	struct kvm_lapic_state xapic;
>> +
>> +	vcpu_sregs_get(vcpu, &sregs);
>> +	vcpu_ioctl(vcpu, KVM_GET_LAPIC, &xapic);
>> +
>> +	TEST_ASSERT_EQ(sregs_tpr(&sregs), lapic_tpr_get(&xapic));
>> +}
>> +
>> +static void test_tpr_mask_irq(struct kvm_vcpu *vcpu, bool mask)
>> +{
>> +	struct kvm_lapic_state xapic;
>> +	uint8_t tpr;
>> +
>> +	static_assert(IRQ_VECTOR >= 16, "invalid IRQ vector number");
>> +	tpr = IRQ_VECTOR / 16;
>> +	if (!mask)
>> +		tpr--;
>> +
>> +	vcpu_ioctl(vcpu, KVM_GET_LAPIC, &xapic);
>> +	lapic_tpr_set(&xapic, tpr);
>> +	vcpu_ioctl(vcpu, KVM_SET_LAPIC, &xapic);
>> +}
>> +
>> +static void test_tpr(struct kvm_vcpu *vcpu, bool x2apic)
>> +{
>> +	bool run_guest = true;
>> +
>> +	vcpu_args_set(vcpu, 1, (uint64_t)x2apic);
>> +
>> +	/* According to the SDM/APM the TPR value at reset is 0 */
>> +	test_tpr_check_tpr_zero(vcpu);
>> +	test_tpr_check_tpr_cr8_equal(vcpu);
>> +
>> +	tpr_guest_irq_sync_flag_reset();
>> +
>> +	while (run_guest) {
>> +		struct ucall uc;
>> +
>> +		alarm(2);
>> +		vcpu_run(vcpu);
>> +		alarm(0);
>> +
>> +		switch (get_ucall(vcpu, &uc)) {
>> +		case UCALL_ABORT:
>> +			REPORT_GUEST_ASSERT(uc);
>> +			break;
>> +		case UCALL_DONE:
>> +			test_tpr_check_tpr_cr8_equal(vcpu);
>> +
>> +			run_guest = false;
>> +			break;
>> +		case UCALL_SYNC:
>> +			test_tpr_check_tpr_cr8_equal(vcpu);
>> +
>> +			if (uc.args[1] == 0)
>> +				test_tpr_mask_irq(vcpu, true);
>> +			else if (uc.args[1] == 1)
>> +				test_tpr_mask_irq(vcpu, false);
> 
> Having wrappers around that will make this clearer, I think:
> 	test_tpr_set_tpr()
> 	test_tpr_clear_tpr()
> or such?

Will do test_tpr_{set,clear}_tpr_mask() since the test isn't
clearing TPR to zero but to IRQ_VECTOR / 16 - 1.

>> +			else
>> +				TEST_FAIL("Unknown SYNC %lu", uc.args[1]);
>> +			break;
>> +		default:
>> +			TEST_FAIL("Unknown ucall result 0x%lx", uc.cmd);
>> +			break;
>> +		}
>> +	}
>> +}
>> +
>>   static void xapic_guest_code(void)
>>   {
>>   	cli();
>> @@ -195,6 +436,12 @@ static void test_apic_id(void)
>>   	kvm_vm_free(vm);
>>   }
>>   
>> +static void clear_x2apic_cap_map_apic(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
>> +{
>> +	vcpu_clear_cpuid_feature(vcpu, X86_FEATURE_X2APIC);
>> +	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
>> +}
>> +
>>   static void test_x2apic_id(void)
>>   {
>>   	struct kvm_lapic_state lapic = {};
>> @@ -230,10 +477,17 @@ int main(int argc, char *argv[])
>>   	};
>>   	struct kvm_vm *vm;
>>   
>> +	/* x2APIC tests */
>> +
>>   	vm = vm_create_with_one_vcpu(&x.vcpu, x2apic_guest_code);
>>   	test_icr(&x);
>>   	kvm_vm_free(vm);
>>   
>> +	vm = vm_create_with_one_vcpu(&x.vcpu, tpr_guest_code);
>> +	vm_install_exception_handler(vm, IRQ_VECTOR, tpr_guest_irq_handler_x2apic);
>> +	test_tpr(x.vcpu, true);
> 
> Any reason not to pass in a pointer to x similar to test_icr()?

test_tpr() does not need the remaining members of that struct
so passing just the struct kvm_vcpu part essentially enforces that.

> 
> - Naveen
> 

Thanks,
Maciej


