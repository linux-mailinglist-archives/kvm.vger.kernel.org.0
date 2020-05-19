Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07EA91DA345
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 23:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbgESVNe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 17:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727905AbgESVNc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 17:13:32 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30FFC08C5C2;
        Tue, 19 May 2020 14:13:31 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jb9YA-0001zE-GS; Tue, 19 May 2020 23:13:22 +0200
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id D60D6100D00;
        Tue, 19 May 2020 23:13:21 +0200 (CEST)
Message-Id: <20200519211224.753841434@linutronix.de>
User-Agent: quilt/0.65
Date:   Tue, 19 May 2020 22:31:34 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch 6/7] x86/kvm/svm: Use uninstrumented wrmsrl() to restore GS
References: <20200519203128.773151484@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


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
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>


diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 35bd95dd64dd..663333d34c84 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3353,7 +3353,7 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs);
 
 #ifdef CONFIG_X86_64
-	wrmsrl(MSR_GS_BASE, svm->host.gs_base);
+	native_wrmsrl(MSR_GS_BASE, svm->host.gs_base);
 #else
 	loadsegment(fs, svm->host.fs);
 #ifndef CONFIG_X86_32_LAZY_GS

