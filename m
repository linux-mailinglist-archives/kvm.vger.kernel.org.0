Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B972968A7DE
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 03:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbjBDCmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 21:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbjBDCmA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 21:42:00 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8075686E9A
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 18:41:58 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id ip10-20020a17090b314a00b002303f0e68b9so4714228pjb.6
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 18:41:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yKig0vjfTYuO47fr0RMiwa4iEAaNVUOtpbtuBUQfHMc=;
        b=LtupmW8Ff5jvfqLv1vPvuPNb0joReY2g7hk69icp1jpAX97zUbFPcSB9sGbw4CMgA6
         NmTQfFnT637bJY2ZaLJisqM1rIHEt/Od/b8F2woINex4KYZ2D5G/0LUN7yNh+quetIlx
         UWnvGEA0jhXv5Iu+9TCmgSo0yLnWYhdolQlia2LJNLU5/x/o5jqWwey/Sh7h4vVFMsvG
         MZrNLehZnk+WncUl+pLiqz1hBBUr/eXC7czqi/aLBNNmfbZjeFE2+MlSffoN/xgLTjbI
         y2HuNiofopMaGmZ8U/e2PPaRLIJPX3BAb3jgvUsmmVORpzYdzB2LK1jqo+8rXVa86g+O
         TZmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yKig0vjfTYuO47fr0RMiwa4iEAaNVUOtpbtuBUQfHMc=;
        b=QC/hEpZFnClmg9foYFxwMYQRBHcXx1+HJGpcudT3B+sdjysqsp3w0dnP+ibf3KalFP
         VVExGxpE0y+6UCeC1kvoviIoN0/vGSDac/WH8vrtntPfbp1WwBNkZZTwaxR1x+cRZuOe
         sabJ1CtYqEb2JJSxE6DoM1Pi8Tub8a2Ki+knBzfyt5zY2ec6+FMHf/ONLDFCe7Ajqww+
         XZP4eqZ8cWTTR62E1qo/DtyotOARSdnlINBQrEVBuicd0XbM9FyQsASTLTQHGqWYO26+
         TXy13KlUXQFRf5MqH6IFZQSwunfX16Mzr8MXhbfzbNTghn9/qZGpJy6rkabFNKs05JNv
         0CCw==
X-Gm-Message-State: AO0yUKXvBFAiChV7KcjtoHRaxgNSoO64wLRRGVk2U5UO3YV+u7dsUb6C
        PHwPxgl4FP70vo0cLo0f/PPtHC57kE8=
X-Google-Smtp-Source: AK7set+GastANbRQWUNsBSM1yNh87W0jU7lCKIwfhNQnZ7ejoI3Z3tHCYK4aK2tViQ5b81qKbARX3HZQtfo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ab4d:b0:196:21d8:fb05 with SMTP id
 ij13-20020a170902ab4d00b0019621d8fb05mr2915228plb.20.1675478517892; Fri, 03
 Feb 2023 18:41:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Feb 2023 02:41:49 +0000
In-Reply-To: <20230204024151.1373296-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230204024151.1373296-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230204024151.1373296-3-seanjc@google.com>
Subject: [PATCH v2 2/4] KVM: selftests: Add helpers to make Xen-style
 VMCALL/VMMCALL hypercalls
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add wrappers to do hypercalls using VMCALL/VMMCALL and Xen's register ABI
(as opposed to full Xen-style hypercalls through a hypervisor provided
page).  Using the common helpers dedups a pile of code, and uses the
native hypercall instruction when running on AMD.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  2 +
 .../selftests/kvm/lib/x86_64/processor.c      | 10 +++
 .../selftests/kvm/x86_64/xen_shinfo_test.c    | 63 +++----------------
 3 files changed, 21 insertions(+), 54 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 53ffa43c90db..90387ddcb2a9 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1063,6 +1063,8 @@ uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr);
 
 uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 		       uint64_t a3);
+uint64_t __xen_hypercall(uint64_t nr, uint64_t a0, void *a1);
+void xen_hypercall(uint64_t nr, uint64_t a0, void *a1);
 
 void __vm_xsave_require_permission(int bit, const char *name);
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index ff901cb47ffc..c39a4353ba19 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1161,6 +1161,16 @@ uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 	return X86_HYPERCALL("a"(nr), "b"(a0), "c"(a1), "d"(a2), "S"(a3));
 }
 
+uint64_t __xen_hypercall(uint64_t nr, uint64_t a0, void *a1)
+{
+	return X86_HYPERCALL("a"(nr), "D"(a0), "S"(a1));
+}
+
+void xen_hypercall(uint64_t nr, uint64_t a0, void *a1)
+{
+	GUEST_ASSERT(!__xen_hypercall(nr, a0, a1));
+}
+
 const struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void)
 {
 	static struct kvm_cpuid2 *cpuid;
diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 6a838df69174..1380947af1fe 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -228,15 +228,8 @@ static void guest_code(void)
 
 	/* Our turn. Deliver event channel (to ourselves) with
 	 * EVTCHNOP_send hypercall. */
-	unsigned long rax;
 	struct evtchn_send s = { .port = 127 };
-	__asm__ __volatile__ ("vmcall" :
-			      "=a" (rax) :
-			      "a" (__HYPERVISOR_event_channel_op),
-			      "D" (EVTCHNOP_send),
-			      "S" (&s));
-
-	GUEST_ASSERT(rax == 0);
+	xen_hypercall(__HYPERVISOR_event_channel_op, EVTCHNOP_send, &s);
 
 	guest_wait_for_irq();
 
@@ -245,24 +238,15 @@ static void guest_code(void)
 	/* Deliver "outbound" event channel to an eventfd which
 	 * happens to be one of our own irqfds. */
 	s.port = 197;
-	__asm__ __volatile__ ("vmcall" :
-			      "=a" (rax) :
-			      "a" (__HYPERVISOR_event_channel_op),
-			      "D" (EVTCHNOP_send),
-			      "S" (&s));
-
-	GUEST_ASSERT(rax == 0);
+	xen_hypercall(__HYPERVISOR_event_channel_op, EVTCHNOP_send, &s);
 
 	guest_wait_for_irq();
 
 	GUEST_SYNC(13);
 
 	/* Set a timer 100ms in the future. */
-	__asm__ __volatile__ ("vmcall" :
-			      "=a" (rax) :
-			      "a" (__HYPERVISOR_set_timer_op),
-			      "D" (rs->state_entry_time + 100000000));
-	GUEST_ASSERT(rax == 0);
+	xen_hypercall(__HYPERVISOR_set_timer_op,
+		      rs->state_entry_time + 100000000, NULL);
 
 	GUEST_SYNC(14);
 
@@ -284,37 +268,19 @@ static void guest_code(void)
 		.timeout = 0,
 	};
 
-	__asm__ __volatile__ ("vmcall" :
-			      "=a" (rax) :
-			      "a" (__HYPERVISOR_sched_op),
-			      "D" (SCHEDOP_poll),
-			      "S" (&p));
-
-	GUEST_ASSERT(rax == 0);
+	xen_hypercall(__HYPERVISOR_sched_op, SCHEDOP_poll, &p);
 
 	GUEST_SYNC(17);
 
 	/* Poll for an unset port and wait for the timeout. */
 	p.timeout = 100000000;
-	__asm__ __volatile__ ("vmcall" :
-			      "=a" (rax) :
-			      "a" (__HYPERVISOR_sched_op),
-			      "D" (SCHEDOP_poll),
-			      "S" (&p));
-
-	GUEST_ASSERT(rax == 0);
+	xen_hypercall(__HYPERVISOR_sched_op, SCHEDOP_poll, &p);
 
 	GUEST_SYNC(18);
 
 	/* A timer will wake the masked port we're waiting on, while we poll */
 	p.timeout = 0;
-	__asm__ __volatile__ ("vmcall" :
-			      "=a" (rax) :
-			      "a" (__HYPERVISOR_sched_op),
-			      "D" (SCHEDOP_poll),
-			      "S" (&p));
-
-	GUEST_ASSERT(rax == 0);
+	xen_hypercall(__HYPERVISOR_sched_op, SCHEDOP_poll, &p);
 
 	GUEST_SYNC(19);
 
@@ -322,13 +288,7 @@ static void guest_code(void)
 	 * actual interrupt, while we're polling on a different port. */
 	ports[0]++;
 	p.timeout = 0;
-	__asm__ __volatile__ ("vmcall" :
-			      "=a" (rax) :
-			      "a" (__HYPERVISOR_sched_op),
-			      "D" (SCHEDOP_poll),
-			      "S" (&p));
-
-	GUEST_ASSERT(rax == 0);
+	xen_hypercall(__HYPERVISOR_sched_op, SCHEDOP_poll, &p);
 
 	guest_wait_for_irq();
 
@@ -363,12 +323,7 @@ static void guest_code(void)
 	 * timer IRQ is dropped due to an invalid event channel.
 	 */
 	for (i = 0; i < 100 && !guest_saw_irq; i++)
-		asm volatile("vmcall"
-			     : "=a" (rax)
-			     : "a" (__HYPERVISOR_sched_op),
-			       "D" (SCHEDOP_poll),
-			       "S" (&p)
-			     : "memory");
+		__xen_hypercall(__HYPERVISOR_sched_op, SCHEDOP_poll, &p);
 
 	/*
 	 * Re-send the timer IRQ if it was (likely) dropped due to the timer
-- 
2.39.1.519.gcb327c4b5f-goog

