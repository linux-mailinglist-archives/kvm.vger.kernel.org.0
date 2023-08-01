Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3746B76BBD3
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 19:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbjHAR61 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 13:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233358AbjHAR6K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 13:58:10 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FE110E
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 10:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=TwC+F4ydhuXrkNHt7b/Hhr/+kOh8ohhvIWctCDUtK4I=; b=Qt3rCsA30DX1+kbWhXQ0fonYeF
        PXmKfajm5KBjMLscB8oG3R8cVxMWcADrOWWkGTiHnLZejcLIJJcgq1Aq8dVhMomEfIqS5rgq55/pD
        o24Dl03ege34a3xAcB/7e7aQx1iXtEVdQazQrWfHqCDHazEMs5svrdwKbLiol1BOOpKtmBR3EcytZ
        QUcEZvW3qMJW0o1iJ+MrxgAXByT9m15kDY8+yw9JrUJHy+y8AKog/QINKcliBCIdAfH+1FPgD+s+1
        l0K4ELAa74rrQZBdH7tHPvFxW7vDDpsb7iKf5pq9tGcOtz4RB4PeTbfoVjJq+Yq54vLiljKzIe7Pc
        Wsbfpfww==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qQtd2-00EpEN-0q;
        Tue, 01 Aug 2023 17:57:52 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qQtcz-000bxj-1V;
        Tue, 01 Aug 2023 18:57:49 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     qemu-devel@nongnu.org
Cc:     Paul Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Anthony PERARD <anthony.perard@citrix.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH for-8.1 2/3] i386/xen: consistent locking around Xen singleshot timers
Date:   Tue,  1 Aug 2023 18:57:46 +0100
Message-Id: <20230801175747.145906-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230801175747.145906-1-dwmw2@infradead.org>
References: <20230801175747.145906-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Coverity points out (CID 1507534, 1507968) that we sometimes access
env->xen_singleshot_timer_ns under the protection of
env->xen_timers_lock and sometimes not.

This isn't always an issue. There are two modes for the timers; if the
kernel supports the EVTCHN_SEND capability then it handles all the timer
hypercalls and delivery internally, and all we use the field for is to
get/set the timer as part of the vCPU state via an ioctl(). If the
kernel doesn't have that support, then we do all the emulation within
qemu, and *those* are the code paths where we actually care about the
locking.

But it doesn't hurt to be a little bit more consistent and avoid having
to explain *why* it's OK.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
---
 target/i386/kvm/xen-emu.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
index d7c7eb8d9c..9946ff0905 100644
--- a/target/i386/kvm/xen-emu.c
+++ b/target/i386/kvm/xen-emu.c
@@ -43,6 +43,7 @@
 
 static void xen_vcpu_singleshot_timer_event(void *opaque);
 static void xen_vcpu_periodic_timer_event(void *opaque);
+static int vcpuop_stop_singleshot_timer(CPUState *cs);
 
 #ifdef TARGET_X86_64
 #define hypercall_compat32(longmode) (!(longmode))
@@ -466,6 +467,7 @@ void kvm_xen_inject_vcpu_callback_vector(uint32_t vcpu_id, int type)
     }
 }
 
+/* Must always be called with xen_timers_lock held */
 static int kvm_xen_set_vcpu_timer(CPUState *cs)
 {
     X86CPU *cpu = X86_CPU(cs);
@@ -483,6 +485,7 @@ static int kvm_xen_set_vcpu_timer(CPUState *cs)
 
 static void do_set_vcpu_timer_virq(CPUState *cs, run_on_cpu_data data)
 {
+    QEMU_LOCK_GUARD(&X86_CPU(cs)->env.xen_timers_lock);
     kvm_xen_set_vcpu_timer(cs);
 }
 
@@ -545,7 +548,6 @@ static void do_vcpu_soft_reset(CPUState *cs, run_on_cpu_data data)
     env->xen_vcpu_time_info_gpa = INVALID_GPA;
     env->xen_vcpu_runstate_gpa = INVALID_GPA;
     env->xen_vcpu_callback_vector = 0;
-    env->xen_singleshot_timer_ns = 0;
     memset(env->xen_virq, 0, sizeof(env->xen_virq));
 
     set_vcpu_info(cs, INVALID_GPA);
@@ -555,8 +557,13 @@ static void do_vcpu_soft_reset(CPUState *cs, run_on_cpu_data data)
                           INVALID_GPA);
     if (kvm_xen_has_cap(EVTCHN_SEND)) {
         kvm_xen_set_vcpu_callback_vector(cs);
+
+        QEMU_LOCK_GUARD(&X86_CPU(cs)->env.xen_timers_lock);
+        env->xen_singleshot_timer_ns = 0;
         kvm_xen_set_vcpu_timer(cs);
-    }
+    } else {
+        vcpuop_stop_singleshot_timer(cs);
+    };
 
 }
 
@@ -1059,6 +1066,10 @@ static int vcpuop_stop_periodic_timer(CPUState *target)
     return 0;
 }
 
+/*
+ * Userspace handling of timer, for older kernels.
+ * Must always be called with xen_timers_lock held.
+ */
 static int do_set_singleshot_timer(CPUState *cs, uint64_t timeout_abs,
                                    bool future, bool linux_wa)
 {
@@ -1086,12 +1097,8 @@ static int do_set_singleshot_timer(CPUState *cs, uint64_t timeout_abs,
         timeout_abs = now + delta;
     }
 
-    qemu_mutex_lock(&env->xen_timers_lock);
-
     timer_mod_ns(env->xen_singleshot_timer, qemu_now + delta);
     env->xen_singleshot_timer_ns = now + delta;
-
-    qemu_mutex_unlock(&env->xen_timers_lock);
     return 0;
 }
 
@@ -1115,6 +1122,7 @@ static int vcpuop_set_singleshot_timer(CPUState *cs, uint64_t arg)
         return -EFAULT;
     }
 
+    QEMU_LOCK_GUARD(&X86_CPU(cs)->env.xen_timers_lock);
     return do_set_singleshot_timer(cs, sst.timeout_abs_ns,
                                    !!(sst.flags & VCPU_SSHOTTMR_future),
                                    false);
@@ -1141,6 +1149,7 @@ static bool kvm_xen_hcall_set_timer_op(struct kvm_xen_exit *exit, X86CPU *cpu,
     if (unlikely(timeout == 0)) {
         err = vcpuop_stop_singleshot_timer(CPU(cpu));
     } else {
+        QEMU_LOCK_GUARD(&X86_CPU(cpu)->env.xen_timers_lock);
         err = do_set_singleshot_timer(CPU(cpu), timeout, false, true);
     }
     exit->u.hcall.result = err;
@@ -1826,6 +1835,7 @@ int kvm_put_xen_state(CPUState *cs)
          * If the kernel has EVTCHN_SEND support then it handles timers too,
          * so the timer will be restored by kvm_xen_set_vcpu_timer() below.
          */
+        QEMU_LOCK_GUARD(&env->xen_timers_lock);
         if (env->xen_singleshot_timer_ns) {
             ret = do_set_singleshot_timer(cs, env->xen_singleshot_timer_ns,
                                     false, false);
@@ -1844,10 +1854,7 @@ int kvm_put_xen_state(CPUState *cs)
     }
 
     if (env->xen_virq[VIRQ_TIMER]) {
-        ret = kvm_xen_set_vcpu_timer(cs);
-        if (ret < 0) {
-            return ret;
-        }
+        do_set_vcpu_timer_virq(cs, RUN_ON_CPU_HOST_INT(env->xen_virq[VIRQ_TIMER]));
     }
     return 0;
 }
@@ -1896,6 +1903,15 @@ int kvm_get_xen_state(CPUState *cs)
         if (ret < 0) {
             return ret;
         }
+
+        /*
+         * This locking is fairly pointless, and is here to appease Coverity.
+         * There is an unavoidable race condition if a different vCPU sets a
+         * timer for this vCPU after the value has been read out. But that's
+         * OK in practice because *all* the vCPUs need to be stopped before
+         * we set about migrating their state.
+         */
+        QEMU_LOCK_GUARD(&X86_CPU(cs)->env.xen_timers_lock);
         env->xen_singleshot_timer_ns = va.u.timer.expires_ns;
     }
 
-- 
2.40.1

