Return-Path: <kvm+bounces-23178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D992C947065
	for <lists+kvm@lfdr.de>; Sun,  4 Aug 2024 22:31:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1743F1C2083C
	for <lists+kvm@lfdr.de>; Sun,  4 Aug 2024 20:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 674831384B3;
	Sun,  4 Aug 2024 20:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="NmAki8m5"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EE717BAF
	for <kvm@vger.kernel.org>; Sun,  4 Aug 2024 20:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722803487; cv=none; b=B6ZOqyFnlaLEVxIAkh4uP8zc9Dcq86+LwH+HeslX/GwqWHSr9XU/69L1ubPBYwr7hbft6HFxt+fltHil/9A/Y5yq52UC3oKVKfRd3wSPJm7N8TVIG2n+QUgDjr9mzIflwCpOfey4tiHW6FTqL9eV32oggjC7iWhdXgDPj9B/USE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722803487; c=relaxed/simple;
	bh=uCNoB8DQco0PHTw2EPGdis203+HLDvhXj0PSS2jaS7k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G4ZF8Xni0ZwgWYLk/ewCpkeD9HI6deIl4eX1phdZgTedFvSXrXF7wxMz3l7+AZWCadWHVss8kX8gSOplxF8A6zBCaiaUIbqv6tZEexO9hEtuNiNQmorTMIS7xLXPUcSGwx5FuUk2hpJBNjjgb6a9/sv8h+bZtM0x6SMTAYd2kPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=NmAki8m5; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1sahsj-008uMd-E0; Sun, 04 Aug 2024 22:31:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=XTf+fXHW3IlWBE1bwsGtE6/YH5VNklVhWfZczpPwRMY=; b=NmAki8m5tOG1TPc7xnIgmgZAmN
	bH5x1QcLwmTWBOuWP+Lqsbj/1d3nVK8kUcU4XuzWgY70FBh9TMifbzu9twOIFi/+gWoRr80bmTem6
	K/iPQlA2wbyUUFAeJgZAt4AOit/5DGA6uWgI5TV9o3ZTfnCKGE/cFjVLi29StsznJA4gPqe6P2StZ
	awZL3Qbe1OKA+ir62RDDGuZtyBqrG86s2uRtac7b7UOHmu36mcoxsFZlZDFdinQY9rgUG7s4jO9IB
	29mrDiVXK0M0t/QB/bS+DsdDMCY0STQuNez7ju/e156/dVvfkYenmJHBMrxHMdEztOfFK4tBE3LVO
	fsdLMeag==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1sahsi-00072X-K7; Sun, 04 Aug 2024 22:31:08 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1sahsS-00Ctww-R0; Sun, 04 Aug 2024 22:30:52 +0200
Message-ID: <eaa907ef-6839-48c6-bfb7-0e6ba2706c52@rbox.co>
Date: Sun, 4 Aug 2024 22:30:51 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: x86: Make x2APIC ID 100% readonly
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Haoyu Wu <haoyuwu254@gmail.com>,
 syzbot+545f1326f405db4e1c3e@syzkaller.appspotmail.com
References: <20240802202941.344889-1-seanjc@google.com>
 <20240802202941.344889-2-seanjc@google.com>
From: Michal Luczaj <mhal@rbox.co>
Content-Language: pl-PL, en-GB
In-Reply-To: <20240802202941.344889-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/2/24 22:29, Sean Christopherson wrote:
> [...]
> Making the x2APIC ID fully readonly fixes a WARN in KVM's optimized map
> calculation, which expects the LDR to align with the x2APIC ID.
> 
>   WARNING: CPU: 2 PID: 958 at arch/x86/kvm/lapic.c:331 kvm_recalculate_apic_map+0x609/0xa00 [kvm]
>   CPU: 2 PID: 958 Comm: recalc_apic_map Not tainted 6.4.0-rc3-vanilla+ #35
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.2-1-1 04/01/2014
>   RIP: 0010:kvm_recalculate_apic_map+0x609/0xa00 [kvm]
>   Call Trace:
>    <TASK>
>    kvm_apic_set_state+0x1cf/0x5b0 [kvm]
>    kvm_arch_vcpu_ioctl+0x1806/0x2100 [kvm]
>    kvm_vcpu_ioctl+0x663/0x8a0 [kvm]
>    __x64_sys_ioctl+0xb8/0xf0
>    do_syscall_64+0x56/0x80
>    entry_SYSCALL_64_after_hwframe+0x46/0xb0
>   RIP: 0033:0x7fade8b9dd6f

Isn't this WARN_ON_ONCE() inherently racy, though? With your patch applied,
it can still be hit by juggling the APIC modes.

[   53.882945] WARNING: CPU: 13 PID: 1181 at arch/x86/kvm/lapic.c:355 kvm_recalculate_apic_map+0x335/0x650 [kvm]
[   53.883007] CPU: 13 UID: 1000 PID: 1181 Comm: recalc_logical_ Not tainted 6.11.0-rc1nokasan+ #18
[   53.883009] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.3-1-1 04/01/2014
[   53.883010] RIP: 0010:kvm_recalculate_apic_map+0x335/0x650 [kvm]
[   53.883057] Call Trace:
[   53.883058]  <TASK>
[   53.883169]  kvm_apic_set_state+0x105/0x3d0 [kvm]
[   53.883201]  kvm_arch_vcpu_ioctl+0xf09/0x19c0 [kvm]
[   53.883285]  kvm_vcpu_ioctl+0x6cc/0x920 [kvm]
[   53.883310]  __x64_sys_ioctl+0x90/0xd0
[   53.883313]  do_syscall_64+0x93/0x180
[   53.883623]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   53.883625] RIP: 0033:0x7fd90fee0d2d

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 48d32c5aa3eb..3344f1478230 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -129,6 +129,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/amx_test
 TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
 TEST_GEN_PROGS_x86_64 += x86_64/triple_fault_event_test
 TEST_GEN_PROGS_x86_64 += x86_64/recalc_apic_map_test
+TEST_GEN_PROGS_x86_64 += x86_64/recalc_logical_map_warn
 TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/x86_64/recalc_logical_map_warn.c b/tools/testing/selftests/kvm/x86_64/recalc_logical_map_warn.c
new file mode 100644
index 000000000000..ad3ae0433230
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/recalc_logical_map_warn.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * WARN_ON_ONCE(ldr != kvm_apic_calc_x2apic_ldr(kvm_x2apic_id(apic)))
+ * in arch/x86/kvm/lapic.c:kvm_recalculate_logical_map()
+ */
+
+#include <pthread.h>
+
+#include "processor.h"
+#include "kvm_util.h"
+#include "apic.h"
+
+#define LAPIC_XAPIC	MSR_IA32_APICBASE_ENABLE
+#define LAPIC_X2APIC	(MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)
+
+static void *race(void *arg)
+{
+	struct kvm_lapic_state state = {};
+	struct kvm_vcpu *vcpu0 = arg;
+
+	/* Trigger kvm_recalculate_apic_map(). */
+	for (;;)
+		__vcpu_ioctl(vcpu0, KVM_SET_LAPIC, &state);
+
+	return NULL;
+}
+
+int main(void)
+{
+	struct kvm_vcpu *vcpus[2];
+	struct kvm_vm *vm;
+	pthread_t thread;
+
+	vm = vm_create_with_vcpus(2, NULL, vcpus);
+
+	vcpu_set_msr(vcpus[1], MSR_IA32_APICBASE, LAPIC_X2APIC);
+	vcpu_set_msr(vcpus[1], APIC_BASE_MSR + (APIC_SPIV >> 4), APIC_SPIV_APIC_ENABLED);
+
+	TEST_ASSERT_EQ(pthread_create(&thread, NULL, race, vcpus[0]), 0);
+
+	for (;;) {
+		_vcpu_set_msr(vcpus[1], MSR_IA32_APICBASE, LAPIC_XAPIC);
+		_vcpu_set_msr(vcpus[1], MSR_IA32_APICBASE, LAPIC_X2APIC);
+	}
+
+	kvm_vm_free(vm);
+
+	return 0;
+}


