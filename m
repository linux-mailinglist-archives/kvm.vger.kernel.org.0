Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946715B917C
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 02:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbiIOAFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 20:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiIOAFS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 20:05:18 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0B41CB04
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 17:05:10 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 133-20020a62198b000000b00540c0148c95so9904531pfz.14
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 17:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=VuGMu9KefmyqggOIb8+6b807AZCZLCiLPgbgKLQtbrg=;
        b=J1nVhlMnXZ1DpLHMM7P54DQ0isb5j+fwUWjtzHYgJQrw12+CNbm2umPpgAhPFrGzr+
         oI/eNFfmDwPTbpK1hmu9ejIKig1lPufMvGy70Lpui6ulazQWjBxj8gOmHqcChSbvbCgt
         l6CE+bSu0XA9BQoAIWofM3MmaPcEZGm/3w/58oPCSmtepDrH6HHxuLQq4JJJMdXaYc0/
         EVvs2B/ZpVMNZO4l1ITqhNZvhHW9rEBSNSutb6NBCB/Sn9MjvNhHzxxu1egVysk8mm7T
         Mhp8wAnzY8L8VChogte06baw2mJW5gXvGxJJYWtAs0u+di4QrJMsuUoVc+lzEGjrlNdo
         QXgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=VuGMu9KefmyqggOIb8+6b807AZCZLCiLPgbgKLQtbrg=;
        b=Vgcq1p//NdYEWi5vr5+np7MN7whLdj2Lwf142/8PIdkvWBEIotZvzfqkmU8LGGDPwZ
         3lGEMk2lA5J44AV59EkuHufb/4z5yXMXKMUlUWaq/sRSFMYF46vMpMe5OtlC8AscXNzD
         qSIzcVvjdNbdfCPO+QCzx+iPXG7a1l0AYM+a/qyRh5Uj6TC9/g/dnk3jgg8GZuMfDyFG
         UI+NUgRptar+nQxcyrz72R+aTNuPJQhZt0G4HSXt8YclPY+DoHWM4qUmvLhojRYDKCnF
         BFj+LH11gDJhVwL/k5mq/VODvPUSlSNa+IWaziNOdUwAtYJh2G8XPPDpE5rYWe6fcPx9
         eKoA==
X-Gm-Message-State: ACrzQf3f9rcxUuLglxWcKUR3nzky6WtVDZJYbpYYd1ULT+ISUE46WgMa
        rtYGiVx8y8KsyzetiCup21CpAeKwtNq0eFhK
X-Google-Smtp-Source: AMsMyM6OElpGuFNQtEUj0prB/t19M02Jd8yvrXuYDoyqbkNPWUazfGaW2kr67T9YfCE+r5BgbHpNF4h2v5map84w
X-Received: from vannapurve2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:41f8])
 (user=vannapurve job=sendgmr) by 2002:a17:90b:4b05:b0:202:b76e:a274 with SMTP
 id lx5-20020a17090b4b0500b00202b76ea274mr7496906pjb.59.1663200309463; Wed, 14
 Sep 2022 17:05:09 -0700 (PDT)
Date:   Thu, 15 Sep 2022 00:04:48 +0000
In-Reply-To: <20220915000448.1674802-1-vannapurve@google.com>
Mime-Version: 1.0
References: <20220915000448.1674802-1-vannapurve@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220915000448.1674802-9-vannapurve@google.com>
Subject: [V2 PATCH 8/8] KVM: selftests: x86: xen: Execute cpu specific vmcall instruction
From:   Vishal Annapurve <vannapurve@google.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     pbonzini@redhat.com, shuah@kernel.org, bgardon@google.com,
        seanjc@google.com, oupton@google.com, peterx@redhat.com,
        vkuznets@redhat.com, dmatlack@google.com,
        Vishal Annapurve <vannapurve@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update xen specific hypercall invocation to execute cpu specific vmcall
instructions.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
---
 .../selftests/kvm/x86_64/xen_shinfo_test.c    | 64 +++++++------------
 .../selftests/kvm/x86_64/xen_vmcall_test.c    | 14 ++--
 2 files changed, 34 insertions(+), 44 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 8a5cb800f50e..92ed07f1c772 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -145,6 +145,23 @@ static void guest_wait_for_irq(void)
 	guest_saw_irq = false;
 }
 
+static unsigned long vmcall_helper(unsigned long reg_a, unsigned long reg_di,
+	unsigned long reg_si)
+{
+	unsigned long ret;
+
+	if (is_amd_cpu())
+		__asm__ __volatile__ ("vmmcall" :
+			"=a" (ret) :
+			"a" (reg_a), "D" (reg_di), "S" (reg_si));
+	else
+		__asm__ __volatile__ ("vmcall" :
+			"=a" (ret) :
+			"a" (reg_a), "D" (reg_di), "S" (reg_si));
+
+	return ret;
+}
+
 static void guest_code(void)
 {
 	struct vcpu_runstate_info *rs = (void *)RUNSTATE_VADDR;
@@ -217,12 +234,7 @@ static void guest_code(void)
 	 * EVTCHNOP_send hypercall. */
 	unsigned long rax;
 	struct evtchn_send s = { .port = 127 };
-	__asm__ __volatile__ ("vmcall" :
-			      "=a" (rax) :
-			      "a" (__HYPERVISOR_event_channel_op),
-			      "D" (EVTCHNOP_send),
-			      "S" (&s));
-
+	rax = vmcall_helper(__HYPERVISOR_event_channel_op, EVTCHNOP_send, (unsigned long)&s);
 	GUEST_ASSERT(rax == 0);
 
 	guest_wait_for_irq();
@@ -232,12 +244,7 @@ static void guest_code(void)
 	/* Deliver "outbound" event channel to an eventfd which
 	 * happens to be one of our own irqfds. */
 	s.port = 197;
-	__asm__ __volatile__ ("vmcall" :
-			      "=a" (rax) :
-			      "a" (__HYPERVISOR_event_channel_op),
-			      "D" (EVTCHNOP_send),
-			      "S" (&s));
-
+	rax = vmcall_helper(__HYPERVISOR_event_channel_op, EVTCHNOP_send, (unsigned long)&s);
 	GUEST_ASSERT(rax == 0);
 
 	guest_wait_for_irq();
@@ -245,10 +252,7 @@ static void guest_code(void)
 	GUEST_SYNC(13);
 
 	/* Set a timer 100ms in the future. */
-	__asm__ __volatile__ ("vmcall" :
-			      "=a" (rax) :
-			      "a" (__HYPERVISOR_set_timer_op),
-			      "D" (rs->state_entry_time + 100000000));
+	rax = vmcall_helper(__HYPERVISOR_set_timer_op, (rs->state_entry_time + 100000000), 0);
 	GUEST_ASSERT(rax == 0);
 
 	GUEST_SYNC(14);
@@ -271,36 +275,21 @@ static void guest_code(void)
 		.timeout = 0,
 	};
 
-	__asm__ __volatile__ ("vmcall" :
-			      "=a" (rax) :
-			      "a" (__HYPERVISOR_sched_op),
-			      "D" (SCHEDOP_poll),
-			      "S" (&p));
-
+	rax = vmcall_helper(__HYPERVISOR_sched_op, SCHEDOP_poll, (unsigned long)&p);
 	GUEST_ASSERT(rax == 0);
 
 	GUEST_SYNC(17);
 
 	/* Poll for an unset port and wait for the timeout. */
 	p.timeout = 100000000;
-	__asm__ __volatile__ ("vmcall" :
-			      "=a" (rax) :
-			      "a" (__HYPERVISOR_sched_op),
-			      "D" (SCHEDOP_poll),
-			      "S" (&p));
-
+	rax = vmcall_helper(__HYPERVISOR_sched_op, SCHEDOP_poll, (unsigned long)&p);
 	GUEST_ASSERT(rax == 0);
 
 	GUEST_SYNC(18);
 
 	/* A timer will wake the masked port we're waiting on, while we poll */
 	p.timeout = 0;
-	__asm__ __volatile__ ("vmcall" :
-			      "=a" (rax) :
-			      "a" (__HYPERVISOR_sched_op),
-			      "D" (SCHEDOP_poll),
-			      "S" (&p));
-
+	rax = vmcall_helper(__HYPERVISOR_sched_op, SCHEDOP_poll, (unsigned long)&p);
 	GUEST_ASSERT(rax == 0);
 
 	GUEST_SYNC(19);
@@ -309,12 +298,7 @@ static void guest_code(void)
 	 * actual interrupt, while we're polling on a different port. */
 	ports[0]++;
 	p.timeout = 0;
-	__asm__ __volatile__ ("vmcall" :
-			      "=a" (rax) :
-			      "a" (__HYPERVISOR_sched_op),
-			      "D" (SCHEDOP_poll),
-			      "S" (&p));
-
+	rax = vmcall_helper(__HYPERVISOR_sched_op, SCHEDOP_poll, (unsigned long)&p);
 	GUEST_ASSERT(rax == 0);
 
 	guest_wait_for_irq();
diff --git a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
index 88914d48c65e..e78f1b5d3af8 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
@@ -37,10 +37,16 @@ static void guest_code(void)
 	register unsigned long r9 __asm__("r9") = ARGVALUE(6);
 
 	/* First a direct invocation of 'vmcall' */
-	__asm__ __volatile__("vmcall" :
-			     "=a"(rax) :
-			     "a"(rax), "D"(rdi), "S"(rsi), "d"(rdx),
-			     "r"(r10), "r"(r8), "r"(r9));
+	if (is_amd_cpu())
+		__asm__ __volatile__("vmmcall" :
+			"=a"(rax) :
+			"a"(rax), "D"(rdi), "S"(rsi), "d"(rdx),
+			"r"(r10), "r"(r8), "r"(r9));
+	else
+		__asm__ __volatile__("vmcall" :
+			"=a"(rax) :
+			"a"(rax), "D"(rdi), "S"(rsi), "d"(rdx),
+			"r"(r10), "r"(r8), "r"(r9));
 	GUEST_ASSERT(rax == RETVALUE);
 
 	/* Fill in the Xen hypercall page */
-- 
2.37.2.789.g6183377224-goog

