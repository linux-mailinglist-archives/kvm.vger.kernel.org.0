Return-Path: <kvm+bounces-67249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 03370CFF043
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 18:09:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D3C9034D46C1
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 16:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ADF034253C;
	Wed,  7 Jan 2026 16:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="UMjGj3Sk"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DF737B3F1
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 16:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767803948; cv=none; b=Xp1LunxO/rrP84L+lSW1sUixrmyOONG785GwKyioaWCfHmX3tK4kuyJ/dnuLBUnCGSbs9WbJlmOM5zNIJH5+urClV+AS6l+VmEgWw+NP59myhNjWnGF/ej++xlj/5amZwRv5GPtGHN98sNJZ2ezbVPDqCxywenBM2UqkcRrRTDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767803948; c=relaxed/simple;
	bh=IJmDYrE8/Uk/o3s7aADyz+eYAyTHNj+vocj0+RyRnkI=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U/+7E9LBgI8jIRmJnK5oyCpggyjAIjOZacUCsojqb0g2wzOV5YW48oO0IqnNknOBJhhkL6d74phqyIIM8ps59zhDaZtYkL90B5B8A0owp+ZOeKPE5WQwKim14k5wEIOPYZc8b9gOfzcHRjyqmi/xenQhQB+mXY8sSpjJuowB0YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=UMjGj3Sk; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=IkZNkEWJiIzQP6nFkM8MXtoymSNqfy192edAVWu80uY=;
	b=UMjGj3Sk++uQFhfm7fbcP2jPPrx69x67g6ehTav5r/4BsndGjVpj6m9L9E69L6axgH1i21FJw
	qOh9/3bSdzrfQ0BOU7BhX7YED6hBuYn67uoASFz2m6gA4PDKVfx/egqsMX9toQrs5EASwjd2A+a
	NBh15YGvwXDPjcSY4tqK+6Q=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dmYZg0n9dz1P6gZ;
	Thu,  8 Jan 2026 00:36:26 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmYdH5RMWzHnGcw;
	Thu,  8 Jan 2026 00:38:43 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 3B31640569;
	Thu,  8 Jan 2026 00:38:50 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 16:38:49 +0000
Date: Wed, 7 Jan 2026 16:38:47 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd
	<nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Timothy Hayes
	<Timothy.Hayes@arm.com>
Subject: Re: [PATCH v2 35/36] KVM: arm64: selftests: Introduce a minimal
 GICv5 PPI selftest
Message-ID: <20260107163847.00000fe9@huawei.com>
In-Reply-To: <20251219155222.1383109-36-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-36-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500009.china.huawei.com (7.191.174.84) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 15:52:48 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> This basic selftest creates a vgic_v5 device (if supported), and tests
> that one of the PPI interrupts works as expected with a basic
> single-vCPU guest.
> 
> Upon starting, the guest enables interrupts. That means that it is
> initialising all PPIs to have reasonable priorities, but marking them
> as disabled. Then the priority mask in the ICC_PCR_EL1 is set, and
> interrupts are enable in ICC_CR0_EL1. At this stage the guest is able
> to recieve interrupts. The first IMPDEF PPI (64) is enabled and
> kvm_irq_line is used to inject the state into the guest.
> 
> The guest's interrupt handler has an explicit WFI in order to ensure
> that the guest skips WFI when there are pending and enabled PPI
> interrupts.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Hi Sascha,

A few comments inline.

> diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/selftests/kvm/arm64/vgic_v5.c
> new file mode 100644
> index 0000000000000..5879fbd71042d
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
> @@ -0,0 +1,248 @@

> +static void test_vgic_v5_ppis(uint32_t gic_dev_type)
> +{
> +	struct ucall uc;
> +	struct kvm_vcpu *vcpus[NR_VCPUS];
> +	struct vm_gic v;
> +	int ret, i;
> +
> +	v.gic_dev_type = gic_dev_type;
> +	v.vm = __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
> +
> +	v.gic_fd = kvm_create_device(v.vm, gic_dev_type);
> +
> +	for (i = 0; i < NR_VCPUS; ++i)
> +		vcpus[i] = vm_vcpu_add(v.vm, i, guest_code);
> +
> +	vm_init_descriptor_tables(v.vm);
> +	vm_install_exception_handler(v.vm, VECTOR_IRQ_CURRENT, guest_irq_handler);
> +
> +	for (i = 0; i < NR_VCPUS; i++)
> +		vcpu_init_descriptor_tables(vcpus[i]);
> +
> +	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
> +			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
> +
> +	while (1) {
> +		ret = run_vcpu(vcpus[0]);
> +
> +		switch (get_ucall(vcpus[0], &uc)) {
> +		case UCALL_SYNC:
> +			/*
> +			 * The guest is ready for the next level
> +			 * change. Set high if ready, and lower if it

Odd line wrap. Go to 80 chars.

> +			 * has been consumed.
> +			 */
> +			if (uc.args[1] == GUEST_CMD_IS_READY ||
> +			    uc.args[1] == GUEST_CMD_IRQ_DIEOI) {
> +				u64 irq = 64;
> +				bool level = uc.args[1] == GUEST_CMD_IRQ_DIEOI ? 0 : 1;
> +
> +				irq &= KVM_ARM_IRQ_NUM_MASK;
Can use FIELD_PREP in tools. Seems likely to be useful here.

> +				irq |= KVM_ARM_IRQ_TYPE_PPI << KVM_ARM_IRQ_TYPE_SHIFT;
> +
> +				_kvm_irq_line(v.vm, irq, level);
> +			} else if (uc.args[1] == GUEST_CMD_IS_AWAKE) {
> +				pr_info("Guest skipping WFI due to pending IRQ\n");
> +			} else if (uc.args[1] == GUEST_CMD_IRQ_CDIA) {
> +				pr_info("Guest acknowledged IRQ\n");
> +			}
> +
> +			continue;
> +		case UCALL_ABORT:
> +			REPORT_GUEST_ASSERT(uc);
> +			break;
> +		case UCALL_DONE:
> +			goto done;
> +		default:
> +			TEST_FAIL("Unknown ucall %lu", uc.cmd);
> +		}
> +	}
> +
> +done:
> +	TEST_ASSERT(ret == 0, "Failed to test GICv5 PPIs");
> +
> +	vm_gic_destroy(&v);
> +}
> +
> +/*
> + * Returns 0 if it's possible to create GIC device of a given type (V2 or V3).

Comment needs an update given you pass in v5

Maybe worth pulling this out as a library function for both sets of tests.
If not, rip out the v2, v3 code from here and the type parameter as that is
all code that will bit rot.

> + */
> +int test_kvm_device(uint32_t gic_dev_type)
> +{
> +	struct kvm_vcpu *vcpus[NR_VCPUS];
> +	struct vm_gic v;
> +	uint32_t other;
> +	int ret;
> +
> +	v.vm = vm_create_with_vcpus(NR_VCPUS, guest_code, vcpus);
> +
> +	/* try to create a non existing KVM device */
> +	ret = __kvm_test_create_device(v.vm, 0);
> +	TEST_ASSERT(ret && errno == ENODEV, "unsupported device");
> +
> +	/* trial mode */
> +	ret = __kvm_test_create_device(v.vm, gic_dev_type);
> +	if (ret)
> +		return ret;
> +	v.gic_fd = kvm_create_device(v.vm, gic_dev_type);
> +
> +	ret = __kvm_create_device(v.vm, gic_dev_type);
> +	TEST_ASSERT(ret < 0 && errno == EEXIST, "create GIC device twice");
> +
> +	/* try to create the other gic_dev_types */
> +	other = KVM_DEV_TYPE_ARM_VGIC_V2;
> +	if (!__kvm_test_create_device(v.vm, other)) {
> +		ret = __kvm_create_device(v.vm, other);
> +		TEST_ASSERT(ret < 0 && (errno == EINVAL || errno == EEXIST),
> +				"create GIC device while other version exists");
> +	}
> +
> +	other = KVM_DEV_TYPE_ARM_VGIC_V3;
> +	if (!__kvm_test_create_device(v.vm, other)) {
> +		ret = __kvm_create_device(v.vm, other);
> +		TEST_ASSERT(ret < 0 && (errno == EINVAL || errno == EEXIST),
> +				"create GIC device while other version exists");
> +	}
> +
> +	other = KVM_DEV_TYPE_ARM_VGIC_V5;
> +	if (!__kvm_test_create_device(v.vm, other)) {
> +		ret = __kvm_create_device(v.vm, other);
> +		TEST_ASSERT(ret < 0 && (errno == EINVAL || errno == EEXIST),
> +				"create GIC device while other version exists");
> +	}
> +
> +	vm_gic_destroy(&v);
> +
> +	return 0;
> +}

> +
> +int main(int ac, char **av)
> +{
> +	int ret;
> +	int pa_bits;
> +	int cnt_impl = 0;
> +
> +	test_disable_default_vgic();
> +
> +	pa_bits = vm_guest_mode_params[VM_MODE_DEFAULT].pa_bits;
> +	max_phys_size = 1ULL << pa_bits;
> +
> +	ret = test_kvm_device(KVM_DEV_TYPE_ARM_VGIC_V5);
> +	if (!ret) {
> +		pr_info("Running VGIC_V5 tests.\n");
> +		run_tests(KVM_DEV_TYPE_ARM_VGIC_V5);
> +		cnt_impl++;
> +	} else {
> +		pr_info("No GICv5 support; Not running GIC_v5 tests.\n");
> +		exit(KSFT_SKIP);
> +	}

Flip to exit early on no device.

	if (ret) {
		pr_info("..);
		exit(KSFT_SKIP);
	}

	pr_info(...);
	run_tests(...
..

	return 0;

> +
> +	return 0;
> +}
> +
> +

Bonus blank line at end of file. One is fine.

> diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
> new file mode 100644
> index 0000000000000..5daaa84318bb1
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
> @@ -0,0 +1,148 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +
> +#ifndef __SELFTESTS_GIC_V5_H
> +#define __SELFTESTS_GIC_V5_H
> +
> +#include <asm/barrier.h>
> +#include <asm/sysreg.h>
> +
> +#include <linux/bitfield.h>
> +
> +#include "processor.h"

> +
> +/* Definitions for GICR CDIA */
> +#define GICV5_GIC_CDIA_VALID_MASK	BIT_ULL(32)
> +#define GICV5_GICR_CDIA_VALID(r)	FIELD_GET(GICV5_GIC_CDIA_VALID_MASK, r)
> +#define GICV5_GIC_CDIA_TYPE_MASK	GENMASK_ULL(31, 29)
> +#define GICV5_GIC_CDIA_ID_MASK		GENMASK_ULL(23, 0)
> +#define GICV5_GIC_CDIA_INTID		GENMASK_ULL(31, 0)
> +
> +/* Definitions for GICR CDNMIA */
> +#define GICV5_GIC_CDNMIA_VALID_MASK	BIT_ULL(32)
> +#define GICV5_GICR_CDNMIA_VALID(r)	FIELD_GET(GICV5_GIC_CDNMIA_VALID_MASK, r)
> +#define GICV5_GIC_CDNMIA_TYPE_MASK	GENMASK_ULL(31, 29)
> +#define GICV5_GIC_CDNMIA_ID_MASK	GENMASK_ULL(23, 0)

If we are updating the sysreg.h ones, remember to add R here as well.




