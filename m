Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4424D215611
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 13:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbgGFLFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 07:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728697AbgGFLFf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 07:05:35 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 767952073E;
        Mon,  6 Jul 2020 11:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594033534;
        bh=pNwXVAMDXVJlIpm6TO8om9y6iGboItUmVHhsv43zIi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YbQDW/lcnduuDKC8kaeWjsU5cTyH+Qwz4b/f+LWIOMadaiDAfbAp4ayIwKyy1YEF+
         QdSct6GVOwoeY4bmBgshAH0xCERJ6xxWC9IYm8v54KK1OtR9PX4iDw/PRh1zCf2ffZ
         6yCXO9WnwIVZ6AOCNmbzMAnSc44UxpbkSrkZ/zXM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jsOwG-009Qgb-UX; Mon, 06 Jul 2020 12:05:33 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Scull <ascull@google.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/2] KVM: arm64: PMU: Fix per-CPU access in preemptible context
Date:   Mon,  6 Jul 2020 12:05:20 +0100
Message-Id: <20200706110521.1615794-2-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200706110521.1615794-1-maz@kernel.org>
References: <20200706110521.1615794-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, ascull@google.com, amurray@thegoodpenguin.co.uk, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 07da1ffaa137 ("KVM: arm64: Remove host_cpu_context
member from vcpu structure") has, by removing the host CPU
context pointer, exposed that kvm_vcpu_pmu_restore_guest
is called in preemptible contexts:

[  266.932442] BUG: using smp_processor_id() in preemptible [00000000] code: qemu-system-aar/779
[  266.939721] caller is debug_smp_processor_id+0x20/0x30
[  266.944157] CPU: 2 PID: 779 Comm: qemu-system-aar Tainted: G            E     5.8.0-rc3-00015-g8d4aa58b2fe3 #1374
[  266.954268] Hardware name: amlogic w400/w400, BIOS 2020.04 05/22/2020
[  266.960640] Call trace:
[  266.963064]  dump_backtrace+0x0/0x1e0
[  266.966679]  show_stack+0x20/0x30
[  266.969959]  dump_stack+0xe4/0x154
[  266.973338]  check_preemption_disabled+0xf8/0x108
[  266.977978]  debug_smp_processor_id+0x20/0x30
[  266.982307]  kvm_vcpu_pmu_restore_guest+0x2c/0x68
[  266.986949]  access_pmcr+0xf8/0x128
[  266.990399]  perform_access+0x8c/0x250
[  266.994108]  kvm_handle_sys_reg+0x10c/0x2f8
[  266.998247]  handle_exit+0x78/0x200
[  267.001697]  kvm_arch_vcpu_ioctl_run+0x2ac/0xab8

Note that the bug was always there, it is only the switch to
using percpu accessors that made it obvious.
The fix is to wrap these accesses in a preempt-disabled section,
so that we sample a coherent context on trap from the guest.

Fixes: 435e53fb5e21 ("arm64: KVM: Enable VHE support for :G/:H perf event modifiers")
Cc:: Andrew Murray <amurray@thegoodpenguin.co.uk>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index b5ae3a5d509e..3c224162b3dd 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -159,7 +159,10 @@ static void kvm_vcpu_pmu_disable_el0(unsigned long events)
 }
 
 /*
- * On VHE ensure that only guest events have EL0 counting enabled
+ * On VHE ensure that only guest events have EL0 counting enabled.
+ * This is called from both vcpu_{load,put} and the sysreg handling.
+ * Since the latter is preemptible, special care must be taken to
+ * disable preemption.
  */
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu)
 {
@@ -169,12 +172,14 @@ void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu)
 	if (!has_vhe())
 		return;
 
+	preempt_disable();
 	host = this_cpu_ptr(&kvm_host_data);
 	events_guest = host->pmu_events.events_guest;
 	events_host = host->pmu_events.events_host;
 
 	kvm_vcpu_pmu_enable_el0(events_guest);
 	kvm_vcpu_pmu_disable_el0(events_host);
+	preempt_enable();
 }
 
 /*
-- 
2.27.0

