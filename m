Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A742F219101
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 21:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgGHTxv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 15:53:51 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53516 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgGHTxq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 15:53:46 -0400
Message-Id: <20200708195322.244847377@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594238024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=9PxuBq1MQRrVP8ij2gLQ9dAHF/Xo4jlxR3pn9ag8/Fg=;
        b=P9dTaoz7MtH8Mf9BlPEA/Np2F5RDHYXNLJeN902rXk8e2DzlHIqMkxZXfpL1rHXu3J/YAr
        YvLZRl2TrwYsEsy7+npviOOVpl4+U6Hi7Xyp5o4Mnm+qnWu/jmkteJEtbIFyOVyHrC6PCP
        H43sxNqnDBknmTOBFs6KBQrK62IVpuGRf/s4TP/1blWX/+cTXmX35VVJITHOhdcA3//5CM
        +ggUBJrhgW/hKniVLq6wOz3xSx5qfz0ITNamEbRD3EKg6AfLsZ++jxqUTSOofVe6AtN01d
        Fs7vEvcYN8ndmdvdIUb/zELpd+xgZcNQE2hnig76+kzNnygHfySR08jI8IxPJA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594238024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=9PxuBq1MQRrVP8ij2gLQ9dAHF/Xo4jlxR3pn9ag8/Fg=;
        b=iV0bcOZZ1ZslFnmqAldHOI5+5Hwb6lyylV7vGvWnMFPyBcqMehG8mfluBCxSTIVDzJBNtU
        EMXkEhA2Mv8mkfDQ==
Date:   Wed, 08 Jul 2020 21:51:59 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 6/7] x86/kvm/svm: Use uninstrumented wrmsrl() to restore GS
References: <20200708195153.746357686@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

On guest exit MSR_GS_BASE contains whatever the guest wrote to it and the
first action after returning from the ASM code is to set it to the host
kernel value. This uses wrmsrl() which is interesting at least.

wrmsrl() is either using native_write_msr() or the paravirt variant. The
XEN_PV code is uninteresting as nested SVM in a XEN_PV guest does not work.

But native_write_msr() can be placed out of line by the compiler especially
when paravirtualization is enabled in the kernel configuration. The
function is marked notrace, but still can be probed if
CONFIG_KPROBE_EVENTS_ON_NOTRACE is enabled.

That would be a fatal problem as kprobe events use per-CPU variables which
are GS based and would be accessed with the guest GS. Depending on the GS
value this would either explode in colorful ways or lead to completely
undebugable data corruption.

Aside of that native_write_msr() contains a tracepoint which objtool
complains about as it is invoked from the noinstr section.

As this cannot run inside a XEN_PV guest there is no point in using
wrmsrl(). Use native_wrmsrl() instead which is just a plain native WRMSR
without tracing or anything else attached.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/kvm/svm/svm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3370,7 +3370,7 @@ static noinstr void svm_vcpu_enter_exit(
 	__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs);
 
 #ifdef CONFIG_X86_64
-	wrmsrl(MSR_GS_BASE, svm->host.gs_base);
+	native_wrmsrl(MSR_GS_BASE, svm->host.gs_base);
 #else
 	loadsegment(fs, svm->host.fs);
 #ifndef CONFIG_X86_32_LAZY_GS

