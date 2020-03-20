Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27B6418DAD3
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 23:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgCTWFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 18:05:38 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37487 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgCTWEP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 18:04:15 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jFPk7-0004aL-4A; Fri, 20 Mar 2020 23:03:51 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 1D5C61039FD;
        Fri, 20 Mar 2020 23:03:48 +0100 (CET)
Message-Id: <20200320180033.790597451@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 20 Mar 2020 19:00:10 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Paul McKenney <paulmck@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Brian Gerst <brgerst@gmail.com>,
        Juergen Gross <jgross@suse.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [RESEND][patch V3 14/23] x86/speculation/mds: Mark
 mds_user_clear_cpu_buffers() __always_inline
References: <20200320175956.033706968@linutronix.de>
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

Prevent the compiler from uninlining and creating traceable/probable
functions as this is invoked _after_ context tracking switched to
CONTEXT_USER and rcu idle.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/nospec-branch.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -319,7 +319,7 @@ DECLARE_STATIC_KEY_FALSE(mds_idle_clear)
  * combination with microcode which triggers a CPU buffer flush when the
  * instruction is executed.
  */
-static inline void mds_clear_cpu_buffers(void)
+static __always_inline void mds_clear_cpu_buffers(void)
 {
 	static const u16 ds = __KERNEL_DS;
 
@@ -340,7 +340,7 @@ static inline void mds_clear_cpu_buffers
  *
  * Clear CPU buffers if the corresponding static key is enabled
  */
-static inline void mds_user_clear_cpu_buffers(void)
+static __always_inline void mds_user_clear_cpu_buffers(void)
 {
 	if (static_branch_likely(&mds_user_clear))
 		mds_clear_cpu_buffers();

