Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA8AD99120
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 12:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732851AbfHVKmF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 06:42:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45816 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732064AbfHVKmF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 06:42:05 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9CCCA3007C5E;
        Thu, 22 Aug 2019 10:42:04 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8942D600CD;
        Thu, 22 Aug 2019 10:42:03 +0000 (UTC)
Date:   Thu, 22 Aug 2019 12:42:01 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        mark.rutland@arm.com
Subject: Re: [PATCH] arm64: KVM: Only skip MMIO insn once
Message-ID: <20190822104201.czgbse2ffww6vzvl@kamzik.brq.redhat.com>
References: <20190821195030.2569-1-drjones@redhat.com>
 <177091d5-2d2c-6a75-472c-92702ee98e86@kernel.org>
 <20190822092514.5opwahkjjpqbbayd@kamzik.brq.redhat.com>
 <bcf8fd9c-3784-5c03-bb34-d8e7fdcd9a06@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcf8fd9c-3784-5c03-bb34-d8e7fdcd9a06@kernel.org>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Thu, 22 Aug 2019 10:42:04 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 22, 2019 at 10:38:52AM +0100, Marc Zyngier wrote:
> On 22/08/2019 10:25, Andrew Jones wrote:
> > On Thu, Aug 22, 2019 at 09:30:44AM +0100, Marc Zyngier wrote:
> >> Hi Drew,
> >>
> >> On 21/08/2019 20:50, Andrew Jones wrote:
> >>> If after an MMIO exit to userspace a VCPU is immediately run with an
> >>> immediate_exit request, such as when a signal is delivered or an MMIO
> >>> emulation completion is needed, then the VCPU completes the MMIO
> >>> emulation and immediately returns to userspace. As the exit_reason
> >>> does not get changed from KVM_EXIT_MMIO in these cases we have to
> >>> be careful not to complete the MMIO emulation again, when the VCPU is
> >>> eventually run again, because the emulation does an instruction skip
> >>> (and doing too many skips would be a waste of guest code :-) We need
> >>> to use additional VCPU state to track if the emulation is complete.
> >>> As luck would have it, we already have 'mmio_needed', which even
> >>> appears to be used in this way by other architectures already.
> >>>
> >>> Fixes: 0d640732dbeb ("arm64: KVM: Skip MMIO insn after emulation")
> >>> Signed-off-by: Andrew Jones <drjones@redhat.com>
> >>> ---
> >>>  virt/kvm/arm/arm.c  | 3 ++-
> >>>  virt/kvm/arm/mmio.c | 1 +
> >>>  2 files changed, 3 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> >>> index 35a069815baf..322cf9030bbe 100644
> >>> --- a/virt/kvm/arm/arm.c
> >>> +++ b/virt/kvm/arm/arm.c
> >>> @@ -669,7 +669,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >>>  	if (ret)
> >>>  		return ret;
> >>>  
> >>> -	if (run->exit_reason == KVM_EXIT_MMIO) {
> >>> +	if (vcpu->mmio_needed) {
> >>> +		vcpu->mmio_needed = 0;
> >>>  		ret = kvm_handle_mmio_return(vcpu, vcpu->run);
> >>>  		if (ret)
> >>>  			return ret;
> >>> diff --git a/virt/kvm/arm/mmio.c b/virt/kvm/arm/mmio.c
> >>> index a8a6a0c883f1..2d9b5e064ae0 100644
> >>> --- a/virt/kvm/arm/mmio.c
> >>> +++ b/virt/kvm/arm/mmio.c
> >>> @@ -201,6 +201,7 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >>>  	if (is_write)
> >>>  		memcpy(run->mmio.data, data_buf, len);
> >>>  	vcpu->stat.mmio_exit_user++;
> >>> +	vcpu->mmio_needed	= 1;
> >>>  	run->exit_reason	= KVM_EXIT_MMIO;
> >>>  	return 0;
> >>>  }
> >>>
> >>
> >> Thanks for this. That's quite embarrassing. Out of curiosity,
> >> how was this spotted?
> > 
> > avocado has a guest execution state snapshotting feature. The feature
> > simply periodically uses QEMU's 'info registers' monitor command while
> > a guest is running. The monitor command kicks the vcpu to userspace with
> > a signal, and since avocado's snapshot rate was set relatively high that
> > increased the probability of causing a noticeable (weird things / guest
> > crashes) event during guest boot (when MMIO activity is also high). The
> > signals correlated with guest crashes lead me to this code.
> 
> Nice one. I guess I could try and reproduce it with the kvmtool debug
> feature that does a similar thing.

Since we don't even need the signals, we can just use kselftests to send a
few KVM_RUN ioctls. Here's one

From: Andrew Jones <drjones@redhat.com>
Date: Thu, 22 Aug 2019 06:38:26 -0400
Subject: [PATCH] KVM: selftests: Demonstrate AArch64 extra instruction skip

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../testing/selftests/kvm/aarch64/vcpu-skip.c | 40 +++++++++++++++++++
 2 files changed, 41 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vcpu-skip.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index ba7849751989..1b90b99bc351 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -28,6 +28,7 @@ TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
 
+TEST_GEN_PROGS_aarch64 += aarch64/vcpu-skip
 TEST_GEN_PROGS_aarch64 += clear_dirty_log_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
 TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
diff --git a/tools/testing/selftests/kvm/aarch64/vcpu-skip.c b/tools/testing/selftests/kvm/aarch64/vcpu-skip.c
new file mode 100644
index 000000000000..f3a747739d36
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/vcpu-skip.c
@@ -0,0 +1,40 @@
+#include "kvm_util.h"
+#include "../lib/kvm_util_internal.h"
+
+#define MMIO 0xb000000
+
+static uint64_t result;
+
+static void guest_code(void)
+{
+	asm volatile(
+		"mov	x0, #1\n"
+		"str	x0, [%0]\n"
+		"str	x0, [%1]\n"
+		"str	x0, [%0]\n"
+	: : "r" (MMIO), "r" (&result) : "x0");
+}
+
+int main(void)
+{
+	struct kvm_vm *vm;
+	struct kvm_run *run;
+	int fd;
+
+	vm = vm_create_default(1, 0, guest_code);
+	virt_pg_map(vm, MMIO, MMIO, 0);
+	run = vcpu_state(vm, 1);
+	fd = vcpu_find(vm, 1)->fd;
+
+	ioctl(fd, KVM_RUN, NULL);
+
+	run->immediate_exit = 1;
+	ioctl(fd, KVM_RUN, NULL);
+
+	run->immediate_exit = 0;
+	ioctl(fd, KVM_RUN, NULL);
+
+	sync_global_from_guest(vm, result);
+	TEST_ASSERT(result, "Skipped instruction");
+	return 0;
+}
-- 
2.18.1

> 
> >> Patch wise, I'd have a small preference for the following (untested)
> >> patch, as it keeps the mmio_needed accesses close together, making
> >> it easier to read (at least for me). What do you think?
> >>
> >> 	M.
> >>
> >> diff --git a/virt/kvm/arm/mmio.c b/virt/kvm/arm/mmio.c
> >> index a8a6a0c883f1..6af5c91337f2 100644
> >> --- a/virt/kvm/arm/mmio.c
> >> +++ b/virt/kvm/arm/mmio.c
> >> @@ -86,6 +86,12 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >>  	unsigned int len;
> >>  	int mask;
> >>  
> >> +	/* Detect an already handled MMIO return */
> >> +	if (unlikely(!vcpu->mmio_needed))
> >> +		return 0;
> >> +
> >> +	vcpu->mmio_needed = 0;
> >> +
> >>  	if (!run->mmio.is_write) {
> >>  		len = run->mmio.len;
> >>  		if (len > sizeof(unsigned long))
> >> @@ -188,6 +194,7 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >>  	run->mmio.is_write	= is_write;
> >>  	run->mmio.phys_addr	= fault_ipa;
> >>  	run->mmio.len		= len;
> >> +	vcpu->mmio_needed	= 1;
> >>  
> >>  	if (!ret) {
> >>  		/* We handled the access successfully in the kernel. */
> > 
> > That looks good to me. Should I repost?
> 
> Yes please. I'll try to get Paolo to pick it as quickly as possible.

On it's way

Thanks,
drew
