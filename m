Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2446689BB5
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2019 12:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbfHLKjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 06:39:20 -0400
Received: from foss.arm.com ([217.140.110.172]:47986 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727323AbfHLKjU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 06:39:20 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A0EAD1715;
        Mon, 12 Aug 2019 03:39:19 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 250763F706;
        Mon, 12 Aug 2019 03:39:18 -0700 (PDT)
From:   Steven Price <steven.price@arm.com>
Subject: Re: [PATCH 9/9] arm64: Retrieve stolen time as paravirtualized guest
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20190802145017.42543-1-steven.price@arm.com>
 <20190802145017.42543-10-steven.price@arm.com>
 <5d763c8e-9c06-c448-2644-25bfa0e57e8c@huawei.com>
Message-ID: <07075994-3a32-8f20-23d8-1759ec2874e3@arm.com>
Date:   Mon, 12 Aug 2019 11:39:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5d763c8e-9c06-c448-2644-25bfa0e57e8c@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/2019 14:51, Zenghui Yu wrote:
[...]
> Hi Steven,
> 
> Since userspace is not involved yet (right?), no one will create the
> PV_TIME device for guest (and no one will specify the IPA of the shared
> stolen time region), and I guess we will get a "not supported" error
> here.
> 
> So what should we do if we want to test this series now?  Any userspace
> tools?  If no, do you have any plans for userspace developing? ;-)

At the moment I have the following patch to kvmtool which creates the
PV_TIME device - this isn't in a state to go upstream, and Marc has
asked that I rework the memory allocation, so this will need to change.

It's a little ugly as it simply reserves the first page of RAM to use
for the PV time structures.

----8<----
diff --git a/Makefile b/Makefile
index 3862112..a79956b 100644
--- a/Makefile
+++ b/Makefile
@@ -158,7 +158,7 @@ endif
 # ARM
 OBJS_ARM_COMMON		:= arm/fdt.o arm/gic.o arm/gicv2m.o arm/ioport.o \
 			   arm/kvm.o arm/kvm-cpu.o arm/pci.o arm/timer.o \
-			   arm/pmu.o
+			   arm/pmu.o arm/pvtime.o
 HDRS_ARM_COMMON		:= arm/include
 ifeq ($(ARCH), arm)
 	DEFINES		+= -DCONFIG_ARM
diff --git a/arm/fdt.c b/arm/fdt.c
index c80e6da..19eccbc 100644
--- a/arm/fdt.c
+++ b/arm/fdt.c
@@ -119,6 +119,7 @@ static int setup_fdt(struct kvm *kvm)
 
 	/* Create new tree without a reserve map */
 	_FDT(fdt_create(fdt, FDT_MAX_SIZE));
+	_FDT(fdt_add_reservemap_entry(fdt, kvm->arch.memory_guest_start, 4096));
 	_FDT(fdt_finish_reservemap(fdt));
 
 	/* Header */
diff --git a/arm/kvm.c b/arm/kvm.c
index 1f85fc6..8bbfef1 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -11,6 +11,8 @@
 #include <linux/kvm.h>
 #include <linux/sizes.h>
 
+int pvtime_create(struct kvm *kvm);
+
 struct kvm_ext kvm_req_ext[] = {
 	{ DEFINE_KVM_EXT(KVM_CAP_IRQCHIP) },
 	{ DEFINE_KVM_EXT(KVM_CAP_ONE_REG) },
@@ -86,6 +88,10 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
 	/* Create the virtual GIC. */
 	if (gic__create(kvm, kvm->cfg.arch.irqchip))
 		die("Failed to create virtual GIC");
+
+	/* Setup PV time */
+	if (pvtime_create(kvm))
+		die("Failed to initialise PV time");
 }
 
 #define FDT_ALIGN	SZ_2M
diff --git a/arm/pvtime.c b/arm/pvtime.c
new file mode 100644
index 0000000..abcaab3
--- /dev/null
+++ b/arm/pvtime.c
@@ -0,0 +1,77 @@
+#include "kvm/kvm.h"
+
+#define KVM_DEV_TYPE_ARM_PV_TIME (KVM_DEV_TYPE_ARM_VGIC_ITS+2)
+
+/* Device Control API: PV_TIME */
+#define KVM_DEV_ARM_PV_TIME_PADDR	0
+#define KVM_DEV_ARM_PV_TIME_FREQUENCY	3
+
+#define KVM_DEV_ARM_PV_TIME_ST		0
+#define KVM_DEV_ARM_PV_TIME_LPT		1
+
+static int pvtime_fd;
+
+int pvtime_create(struct kvm *kvm);
+
+int pvtime_create(struct kvm *kvm)
+{
+	int err;
+	u64 lpt_paddr = 0x10000000;
+	u64 st_paddr = lpt_paddr + 4096;
+	u32 frequency = 100 * 1000 * 1000;
+
+	printf("lpt_paddr=%llx\n", lpt_paddr);
+
+	struct kvm_create_device pvtime_device = {
+		.type = KVM_DEV_TYPE_ARM_PV_TIME,
+		.flags = 0,
+	};
+
+	err = ioctl(kvm->vm_fd, KVM_CREATE_DEVICE, &pvtime_device);
+	if (err) {
+		printf("Failed to create PV device\n");
+		return 0;
+	}
+
+	pvtime_fd = pvtime_device.fd;
+
+	struct kvm_device_attr lpt_base = {
+		.group = KVM_DEV_ARM_PV_TIME_PADDR,
+		.attr = KVM_DEV_ARM_PV_TIME_LPT,
+		.addr = (u64)(unsigned long)&lpt_paddr
+	};
+	struct kvm_device_attr st_base = {
+		.group = KVM_DEV_ARM_PV_TIME_PADDR,
+		.attr = KVM_DEV_ARM_PV_TIME_ST,
+		.addr = (u64)(unsigned long)&st_paddr
+	};
+
+	struct kvm_device_attr lpt_freq = {
+		.group = KVM_DEV_ARM_PV_TIME_FREQUENCY,
+		.attr = KVM_DEV_ARM_PV_TIME_LPT,
+		.addr = (u64)(unsigned long)&frequency
+	};
+
+	err = ioctl(pvtime_fd, KVM_SET_DEVICE_ATTR, &lpt_base);
+	if (err) {
+		perror("ioctl lpt_base failed");
+		printf("Ignoring LPT...\n");
+	}
+	err = ioctl(pvtime_fd, KVM_SET_DEVICE_ATTR, &st_base);
+	if (err) {
+		perror("ioctl st_base failed");
+		goto out_err;
+	}
+	err = ioctl(pvtime_fd, KVM_SET_DEVICE_ATTR, &lpt_freq);
+	if (err) {
+		perror("ioctl lpt_freq failed");
+		printf("Ignoring LPT...\n");
+	}
+
+	printf("PV time setup\n");
+
+	return 0;
+out_err:
+	close(pvtime_fd);
+	return err;
+}
