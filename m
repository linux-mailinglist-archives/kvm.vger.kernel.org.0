Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07FC20A02E
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 15:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405075AbgFYNnx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 09:43:53 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:60012 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404890AbgFYNnx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 09:43:53 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 429DA41853EE28F8554D;
        Thu, 25 Jun 2020 21:43:50 +0800 (CST)
Received: from A190218597.china.huawei.com (10.47.76.118) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Thu, 25 Jun 2020 21:43:41 +0800
From:   Salil Mehta <salil.mehta@huawei.com>
To:     <linux-arm-kernel@lists.infradead.org>
CC:     <maz@kernel.org>, <will@kernel.org>, <catalin.marinas@arm.com>,
        <christoffer.dall@arm.com>, <andre.przywara@arm.com>,
        <james.morse@arm.com>, <mark.rutland@arm.com>,
        <lorenzo.pieralisi@arm.com>, <sudeep.holla@arm.com>,
        <qemu-arm@nongnu.org>, <peter.maydell@linaro.org>,
        <richard.henderson@linaro.org>, <imammedo@redhat.com>,
        <mst@redhat.com>, <drjones@redhat.com>, <pbonzini@redhat.com>,
        <eric.auger@redhat.com>, <gshan@redhat.com>, <david@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <mehta.salil.lnk@gmail.com>,
        Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH RFC 0/4] Changes to Support *Virtual* CPU Hotplug for ARM64
Date:   Thu, 25 Jun 2020 14:37:53 +0100
Message-ID: <20200625133757.22332-1-salil.mehta@huawei.com>
X-Mailer: git-send-email 2.8.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.47.76.118]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes to support virtual cpu hotplug in QEMU[1] have been introduced to the
community as RFC. These are under review.

To support virtual cpu hotplug guest kernel must:
1. Identify disabled/present vcpus and set/unset the present mask of the vcpu
   during initialization and hotplug event. It must also set the possible mask
   (which includes disabled vcpus) during init of guest kernel.
2. Provide architecture specific ACPI hooks, for example to map/unmap the
   logical cpuid to hwids/MPIDR. Linux kernel already has generic ACPI cpu
   hotplug framework support.

Changes introduced in this patch-set also ensures that initialization of the
cpus when virtual cpu hotplug is not supported remains un-affected.

Repository:
(*) Kernel changes are at,
     https://github.com/salil-mehta/linux.git virt-cpuhp-arm64/rfc-v1
(*) QEMU changes for vcpu hotplug could be cloned from below site,
     https://github.com/salil-mehta/qemu.git virt-cpuhp-armv8/rfc-v1


THINGS TO DO:
1. Handling of per-cpu variables especially the first-chunk allocations
   (which are NUMA aware) when the vcpu is hotplugged needs further attention
   and review.
2. NUMA related stuff has not been fully tested both in QEMU and kernel.
3. Comprehensive Testing including when cpu hotplug is not supported.
4. Docs

DISCLAIMER:
This is not a complete work but an effort to present the arm vcpu hotplug
implementation to the community. This RFC is being used as a way to verify
the idea mentioned above and to support changes presented for QEMU[1] to
support vcpu hotplug. As of now this is *not* a production level code and might
have bugs. Only a basic testing has been done on HiSilicon Kunpeng920 ARM64
based SoC for Servers to verify the proof-of-concept that has been found working!

Best regards
Salil.

REFERENCES:
[1] https://www.mail-archive.com/qemu-devel@nongnu.org/msg712010.html
[2] https://lkml.org/lkml/2019/6/28/1157
[3] https://lists.cs.columbia.edu/pipermail/kvmarm/2018-July/032316.html

Organization of Patches:
[Patch 1-3]
(*) Changes required during guest boot time to support vcpu hotplug 
(*) Max cpu overflow checks
(*) Changes required to pre-setup cpu-operations even for disabled cpus
[Patch 4]
(*) Arch changes required by guest kernel ACPI CPU Hotplug framework.


Salil Mehta (4):
  arm64: kernel: Handle disabled[(+)present] cpus in MADT/GICC during
    init
  arm64: kernel: Bound the total(present+disabled) cpus with nr_cpu_ids
  arm64: kernel: Init cpu operations for all possible vcpus
  arm64: kernel: Arch specific ACPI hooks(like logical cpuid<->hwid
    etc.)

 arch/arm64/kernel/smp.c | 153 ++++++++++++++++++++++++++++++++--------
 1 file changed, 123 insertions(+), 30 deletions(-)

-- 
2.17.1


