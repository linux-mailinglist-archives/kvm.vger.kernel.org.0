Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6986D62BB46
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 12:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238775AbiKPLSD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 06:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239163AbiKPLRi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 06:17:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CDE2E9FB;
        Wed, 16 Nov 2022 03:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QyKiutDikhqtS5evWJD5nb7g0g7xU4H4zTVUxJYpfM8=; b=K6uhjY9gwFNHqXVdDbhpIEUdLR
        jZRDd+XKhIeALbMBKjreKK/oKfKOULj7trqauk/XtRdJ86A+Loh6GwSb3iwJ9IDCAvchKzSwK16J9
        PcZg0m+r2fApfkx9TKxQHwexAK/Y4m72EMRlgf3RJ6lJ03PMk/kjDe2juQ9aK9AxLutmEPKXO0qoA
        PSp7SoIteknW9c6ZY8hPceu0P9/m4Ike4w7AbOlIqVNm9hkoezH4+42F6NSSt8ZrgGIksHWicgCzL
        b+y7yA+SGJM5wfdVQFspnWK8GrJyAECimgvts4fKBDM1g1HVDmuBf/ORW4cxKhLSXXkXGnFy9LEkg
        Dlk40q8g==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ovGE1-00HJpL-Dn; Wed, 16 Nov 2022 11:05:01 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5203530002E;
        Wed, 16 Nov 2022 12:04:53 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3B052201079F4; Wed, 16 Nov 2022 12:04:53 +0100 (CET)
Date:   Wed, 16 Nov 2022 12:04:53 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v2] x86/paravirt: use common macro for creating simple
 asm paravirt functions
Message-ID: <Y3TD1R9BOb4avCWp@hirez.programming.kicks-ass.net>
References: <20221109134418.6516-1-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109134418.6516-1-jgross@suse.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 09, 2022 at 02:44:18PM +0100, Juergen Gross wrote:
> There are some paravirt assembler functions which are sharing a common
> pattern. Introduce a macro DEFINE_PARAVIRT_ASM() for creating them.
> 
> Note that this macro is including explicit alignment of the generated
> functions, leading to __raw_callee_save___kvm_vcpu_is_preempted(),
> _paravirt_nop() and paravirt_ret0() to be aligned at 4 byte boundaries
> now.
> 
> The explicit _paravirt_nop() prototype in paravirt.c isn't needed, as
> it is included in paravirt_types.h already.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Reviewed-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
> ---

Seems nice; I've made the below little edits, but this is certainly a
bit large for /urgent at this point in time. So how about I merge
locking/urgent into x86/paravirt and munge this on top?

---
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -737,7 +737,7 @@ static __always_inline unsigned long arc
 	     __ALIGN_STR "\n"				\
 	     #func ":\n\t"				\
 	     ASM_ENDBR					\
-	     instr					\
+	     instr "\n\t"				\
 	     ASM_RET					\
 	     ".size " #func ", . - " #func "\n\t"	\
 	     ".popsection")
--- a/arch/x86/include/asm/qspinlock_paravirt.h
+++ b/arch/x86/include/asm/qspinlock_paravirt.h
@@ -54,8 +54,8 @@ __PV_CALLEE_SAVE_REGS_THUNK(__pv_queued_
 	"pop    %rdx\n\t"						\
 	FRAME_END
 
-DEFINE_PARAVIRT_ASM(__raw_callee_save___pv_queued_spin_unlock, PV_UNLOCK_ASM,
-		    .spinlock.text);
+DEFINE_PARAVIRT_ASM(__raw_callee_save___pv_queued_spin_unlock,
+		    PV_UNLOCK_ASM, .spinlock.text);
 
 #else /* CONFIG_64BIT */
 
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -802,6 +802,7 @@ extern bool __raw_callee_save___kvm_vcpu
  "movq   __per_cpu_offset(,%rdi,8), %rax\n\t"				     \
  "cmpb   $0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax)\n\t" \
  "setne  %al\n\t"
+
 DEFINE_PARAVIRT_ASM(__raw_callee_save___kvm_vcpu_is_preempted,
 		    PV_VCPU_PREEMPTED_ASM, .text);
 #endif
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -40,8 +40,7 @@
 DEFINE_PARAVIRT_ASM(_paravirt_nop, "", .entry.text);
 
 /* stub always returning 0. */
-#define PV_RET0_ASM	"xor %" _ASM_AX ", %" _ASM_AX "\n\t"
-DEFINE_PARAVIRT_ASM(paravirt_ret0, PV_RET0_ASM, .entry.text);
+DEFINE_PARAVIRT_ASM(paravirt_ret0, "xor %eax,%eax", .entry.text);
 
 void __init default_banner(void)
 {
