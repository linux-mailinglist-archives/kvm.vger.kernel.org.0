Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8277BC1179
	for <lists+kvm@lfdr.de>; Sat, 28 Sep 2019 19:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbfI1RX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Sep 2019 13:23:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54328 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728787AbfI1RX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Sep 2019 13:23:26 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 180FAC051688;
        Sat, 28 Sep 2019 17:23:26 +0000 (UTC)
Received: from mail (ovpn-125-159.rdu2.redhat.com [10.10.125.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D3C3E261B7;
        Sat, 28 Sep 2019 17:23:25 +0000 (UTC)
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 12/14] KVM: retpolines: x86: eliminate retpoline from vmx.c exit handlers
Date:   Sat, 28 Sep 2019 13:23:21 -0400
Message-Id: <20190928172323.14663-13-aarcange@redhat.com>
In-Reply-To: <20190928172323.14663-1-aarcange@redhat.com>
References: <20190928172323.14663-1-aarcange@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Sat, 28 Sep 2019 17:23:26 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's enough to check the exit value and issue a direct call to avoid
the retpoline for all the common vmexit reasons.

Reducing this list to only EXIT_REASON_MSR_WRITE,
EXIT_REASON_PREEMPTION_TIMER, EXIT_REASON_EPT_MISCONFIG,
EXIT_REASON_IO_INSTRUCTION increases the computation time of the
hrtimer guest testcase on Haswell i5-4670T CPU @ 2.30GHz by 7% with
the default spectre v2 mitigation enabled in the host and guest. On
skylake as opposed there's no measurable difference with the short
list. To put things in prospective on Haswell the same hrtimer
workload (note: it never calls cpuid and it never attempts to trigger
more vmexit on purpose) in guest takes 16.3% longer to compute on
upstream KVM running in the host than with the KVM mono v1 patchset
applied to the host kernel, while on skylake the same takes only 5.4%
more time (both with the default mitigations enabled in guest and
host).

It's also unclear why EXIT_REASON_IO_INSTRUCTION should be included.

Of course CONFIG_RETPOLINE already forbids gcc not to do indirect
jumps while compiling all switch() statements, however switch() would
still allow the compiler to bisect the value, however it seems to run
slower if something and the reason is that it's better to prioritize
and do the minimal possible number of checks for the most common vmexit.

The halt and pause loop exiting may be slow paths from the point of
the guest, but not necessarily so from the point of the host. There
can be a flood of halt exit reasons (in fact that's why the cpuidle
guest haltpoll support was recently merged and we can't rely on it
here because there are older kernels and other OS that must also
perform optimally). All it takes is a pipe ping pong with a different
host CPU and the host CPUs running at full capacity.

The same consideration applies to the pause loop exiting exit reason,
if there's heavy host overcommit that collides heavily in a spinlock
the same may happen.

In the common case of a fully idle host, the halt and pause loop
exiting can't help, but adding them doesn't hurt the common case and
the expectation here is that if they would ever become measurable, it
would be because they are increasing (and not decreasing) performance.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index de3ae2246205..2bd57a7d2be1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5846,9 +5846,29 @@ int kvm_x86_handle_exit(struct kvm_vcpu *vcpu)
 	}
 
 	if (exit_reason < kvm_vmx_max_exit_handlers
-	    && kvm_vmx_exit_handlers[exit_reason])
+	    && kvm_vmx_exit_handlers[exit_reason]) {
+#ifdef CONFIG_RETPOLINE
+		if (exit_reason == EXIT_REASON_MSR_WRITE)
+			return kvm_emulate_wrmsr(vcpu);
+		else if (exit_reason == EXIT_REASON_PREEMPTION_TIMER)
+			return handle_preemption_timer(vcpu);
+		else if (exit_reason == EXIT_REASON_PENDING_INTERRUPT)
+			return handle_interrupt_window(vcpu);
+		else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
+			return handle_external_interrupt(vcpu);
+		else if (exit_reason == EXIT_REASON_HLT)
+			return kvm_emulate_halt(vcpu);
+		else if (exit_reason == EXIT_REASON_PAUSE_INSTRUCTION)
+			return handle_pause(vcpu);
+		else if (exit_reason == EXIT_REASON_MSR_READ)
+			return kvm_emulate_rdmsr(vcpu);
+		else if (exit_reason == EXIT_REASON_CPUID)
+			return kvm_emulate_cpuid(vcpu);
+		else if (exit_reason == EXIT_REASON_EPT_MISCONFIG)
+			return handle_ept_misconfig(vcpu);
+#endif
 		return kvm_vmx_exit_handlers[exit_reason](vcpu);
-	else {
+	} else {
 		vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
 				exit_reason);
 		dump_vmcs();
