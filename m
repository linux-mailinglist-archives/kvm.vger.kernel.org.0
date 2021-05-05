Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0036374AC3
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 23:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhEEVtU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 17:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbhEEVtS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 17:49:18 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B5BC061574;
        Wed,  5 May 2021 14:48:21 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620251297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=DwnDbRYPGOB6QSqiEY7AuTKE84++kwmlDEV1tcogAv0=;
        b=IcbSGt/aNAWDrw7qHp4Wt8BC0pn3AjDcHV/mHlqw2N2CyjBBYWo68W2MyuGT4p1O9zkz/f
        zbXaj21XFjY1WP1sUbezCn9QsRTJLfRG97KxkwF0kfZPgHFdnxOQGgRXEi52Bbnb1N168T
        WUNxiGfmhyuUkFmsJYh/sdTMSD+5+GfIOZ7BHfJrIQh0LbvxGTRThHscV+EseE1+AlHeJA
        3LAv4i1pkq4MiCT0Rms7FFIzNmxpPxjplHP4NDibsWxaN4vo8Vk5mr2vQ89k1561mMj34n
        7PRVnrNEk4c1Y/UGrlFkViwJ+Z3xFyKCqXqxXYRAMw3KCKE+vdF7X5gxLKabmg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620251297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=DwnDbRYPGOB6QSqiEY7AuTKE84++kwmlDEV1tcogAv0=;
        b=DCbmaGOAWxbh7gginzBuFNGOZA2b1+9xNNptOuadeawYHzdDig1Ftb6TFP/0JRINV4+FZW
        bkJWphTAQQeN6NAg==
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: KVM: x86: Cancel pvclock_gtod_work on module removal
Date:   Wed, 05 May 2021 23:48:17 +0200
Message-ID: <87czu4onry.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nothing prevents the following:

  pvclock_gtod_notify()
    queue_work(system_long_wq, &pvclock_gtod_work);
  ...
  remove_module(kvm);
  ...
  work_queue_run()
    pvclock_gtod_work()	<- UAF

Ditto for any other operation on that workqueue list head which touches
pvclock_gtod_work after module removal.

Cancel the work in kvm_arch_exit() to prevent that.

Fixes: 16e8d74d2da9 ("KVM: x86: notifier for clocksource changes")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
Found by inspection because of:
  https://lkml.kernel.org/r/0000000000001d43ac05c0f5c6a0@google.com
See also:
  https://lkml.kernel.org/r/20210505105940.190490250@infradead.org

TL;DR: Scheduling work with tk_core.seq write held is a bad idea.
---
 arch/x86/kvm/x86.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8168,6 +8168,7 @@ void kvm_arch_exit(void)
 	cpuhp_remove_state_nocalls(CPUHP_AP_X86_KVM_CLK_ONLINE);
 #ifdef CONFIG_X86_64
 	pvclock_gtod_unregister_notifier(&pvclock_gtod_notifier);
+	cancel_work_sync(&pvclock_gtod_work);
 #endif
 	kvm_x86_ops.hardware_enable = NULL;
 	kvm_mmu_module_exit();
