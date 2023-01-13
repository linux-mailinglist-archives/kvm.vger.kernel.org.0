Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5D76697E0
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 14:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241476AbjAMNAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 08:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232818AbjAMNAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 08:00:22 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6325687F29;
        Fri, 13 Jan 2023 04:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=oROQ5EhPcADKkRL2Rfifft9KU9gKCo4Ch5f3HILY9EU=; b=kuGaoVJ9CO+qeVGEzmqDWg1q/r
        OPat1qM3uTjRAuHrK4UFNkO+E6ecuSNaHqqxJ9A5mixAwq+Cxn/Ii2hcSADQbADm5Lx3KGZR+Zrn+
        367gEIapAnL50AMA8IDUSbgNLt3eYTfSEK+21NGu1pDyJL5xzPkjJLHs6adOWIdrLLmwdMBIr6Mwe
        BJWZQuLxY4Jj/5uMJO8hSG4nqBYT+pbGmPud5jxV57IuCsTu0F91SNl5jcR1L94zdD0FIsb9HtlPr
        mHZRzSnze9Cbfzor4AVyymHco67Pez0wCotqxfjKRtpA8sINJmDBbxp6uMka0X2cKWpjKO8LRAITt
        PuFlX0jA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pGJRd-004Mi0-0z;
        Fri, 13 Jan 2023 12:46:05 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pGJRl-0002jr-Ip; Fri, 13 Jan 2023 12:46:13 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Boqun Feng <boqun.feng@gmail.com>, linux-kernel@vger.kernel.org,
        rcu@vger.kernel.org, kvm@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
        Joel Fernandes <joel@joelfernandes.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 3/3] KVM: selftests: Add EVTCHNOP_send slow path test to xen_shinfo_test
Date:   Fri, 13 Jan 2023 12:46:06 +0000
Message-Id: <20230113124606.10221-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230113124606.10221-1-dwmw2@infradead.org>
References: <20230113065955.815667-1-boqun.feng@gmail.com>
 <20230113124606.10221-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

When kvm_xen_evtchn_send() takes the slow path because the shinfo GPC
needs to be revalidated, it used to violate the SRCU vs. kvm->lock
locking rules and potentially cause a deadlock.

Now that lockdep is learning to catch such things, make sure that code
path is exercised by the selftest.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 .../selftests/kvm/x86_64/xen_shinfo_test.c    | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 644d614a9965..3adc2e11b094 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -29,6 +29,9 @@
 #define DUMMY_REGION_GPA	(SHINFO_REGION_GPA + (3 * PAGE_SIZE))
 #define DUMMY_REGION_SLOT	11
 
+#define DUMMY_REGION_GPA_2	(SHINFO_REGION_GPA + (4 * PAGE_SIZE))
+#define DUMMY_REGION_SLOT_2	12
+
 #define SHINFO_ADDR	(SHINFO_REGION_GPA)
 #define VCPU_INFO_ADDR	(SHINFO_REGION_GPA + 0x40)
 #define PVTIME_ADDR	(SHINFO_REGION_GPA + PAGE_SIZE)
@@ -57,6 +60,7 @@ enum {
 	TEST_EVTCHN_SLOWPATH,
 	TEST_EVTCHN_SEND_IOCTL,
 	TEST_EVTCHN_HCALL,
+	TEST_EVTCHN_HCALL_SLOWPATH,
 	TEST_EVTCHN_HCALL_EVENTFD,
 	TEST_TIMER_SETUP,
 	TEST_TIMER_WAIT,
@@ -270,6 +274,20 @@ static void guest_code(void)
 
 	guest_wait_for_irq();
 
+	GUEST_SYNC(TEST_EVTCHN_HCALL_SLOWPATH);
+
+	/* Same again, but this time the host has messed with memslots
+	 * so it should take the slow path in kvm_xen_set_evtchn(). */
+	__asm__ __volatile__ ("vmcall" :
+			      "=a" (rax) :
+			      "a" (__HYPERVISOR_event_channel_op),
+			      "D" (EVTCHNOP_send),
+			      "S" (&s));
+
+	GUEST_ASSERT(rax == 0);
+
+	guest_wait_for_irq();
+
 	GUEST_SYNC(TEST_EVTCHN_HCALL_EVENTFD);
 
 	/* Deliver "outbound" event channel to an eventfd which
@@ -801,6 +819,19 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
+			case TEST_EVTCHN_HCALL_SLOWPATH:
+				TEST_ASSERT(!evtchn_irq_expected,
+					    "Expected event channel IRQ but it didn't happen");
+				shinfo->evtchn_pending[0] = 0;
+
+				if (verbose)
+					printf("Testing guest EVTCHNOP_send direct to evtchn after memslot change\n");
+				vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+							    DUMMY_REGION_GPA_2, DUMMY_REGION_SLOT_2, 1, 0);
+				evtchn_irq_expected = true;
+				alarm(1);
+				break;
+
 			case TEST_EVTCHN_HCALL_EVENTFD:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
-- 
2.35.3

