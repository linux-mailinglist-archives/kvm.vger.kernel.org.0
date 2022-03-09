Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6082A4D3121
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 15:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233597AbiCIOkB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 09:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233595AbiCIOjz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 09:39:55 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E1EF127D52
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 06:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=xaDR8A9c9TbRir36wnHWDSicZ6tSveigPVUUdduYloA=; b=IPCTz0v09nn56lr0cid283Gxjs
        tqA9depUTzMOy+8fITEjByOKn8mPnxlit/elOPZPT4XXRVcE5t4sHNtKkFOx9Ie7BVgBo7ssyDKnh
        q9hd+LQNG/L0ng37mCwCJJRfMC3UPVIeWyw54wTbaY6mXi4TDmXVkcwBad81TVjTUEkySxKt0Or0l
        AuoSsP/vDLuFNXBNxKYh2qwWdK8ckGMrdWmwl6yR7WdRtbxFEo/xTQoOPkEdP0/3/udKbH00ygzzF
        JVAPez423srEFYuCsByOhbrI8T/z12qLWxwEjoZu3mGnXj2gn7VcrPT3Rh3CSued196+6MDBo/KQq
        AFDHhQ5A==;
Received: from [2001:8b0:10b:1:85c4:81a:fb42:714d] (helo=i7.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nRxSX-00HCef-Vt; Wed, 09 Mar 2022 14:38:38 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nRxSX-00143k-5d; Wed, 09 Mar 2022 14:38:37 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>,
        Paul Durrant <pdurrant@amazon.co.uk>
Subject: [PATCH 2/2] KVM: x86/xen: Update self test for Xen PV timers
Date:   Wed,  9 Mar 2022 14:38:35 +0000
Message-Id: <20220309143835.253911-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220309143835.253911-1-dwmw2@infradead.org>
References: <20220309143835.253911-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Add test cases for timers in the past, and reading the status of a timer
which has already fired.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 .../selftests/kvm/x86_64/xen_shinfo_test.c    | 35 +++++++++++++++++--
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 63b0ca7685b0..d9d9d1deec45 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -325,6 +325,11 @@ static void guest_code(void)
 	guest_wait_for_irq();
 
 	GUEST_SYNC(20);
+
+	/* Timer should have fired already */
+	guest_wait_for_irq();
+
+	GUEST_SYNC(21);
 }
 
 static int cmp_timespec(struct timespec *a, struct timespec *b)
@@ -746,6 +751,7 @@ int main(int argc, char *argv[])
 
 				tmr.u.timer.expires_ns = rs->state_entry_time + 100000000,
 				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &tmr);
+				alarm(1);
 				break;
 
 			case 19:
@@ -753,15 +759,38 @@ int main(int argc, char *argv[])
 				if (verbose)
 					printf("Testing SCHEDOP_poll wake on unmasked event\n");
 
-				tmr.u.timer.expires_ns = rs->state_entry_time + 100000000,
-				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &tmr);
 				evtchn_irq_expected = true;
+				tmr.u.timer.expires_ns = rs->state_entry_time + 100000000;
+				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &tmr);
+
+				/* Read it back and check the pending time is reported correctly */
+				tmr.u.timer.expires_ns = 0;
+				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_GET_ATTR, &tmr);
+				TEST_ASSERT(tmr.u.timer.expires_ns == rs->state_entry_time + 100000000,
+					    "Timer not reported pending");
+				alarm(1);
 				break;
 
 			case 20:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
-				shinfo->evtchn_pending[1] = 0;
+				/* Read timer and check it is no longer pending */
+				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_GET_ATTR, &tmr);
+				TEST_ASSERT(!tmr.u.timer.expires_ns, "Timer still reported pending");
+
+				shinfo->evtchn_pending[0] = 0;
+				if (verbose)
+					printf("Testing timer in the past\n");
+
+				evtchn_irq_expected = true;
+				tmr.u.timer.expires_ns = rs->state_entry_time - 100000000ULL;
+				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &tmr);
+				alarm(1);
+				break;
+
+			case 21:
+				TEST_ASSERT(!evtchn_irq_expected,
+					    "Expected event channel IRQ but it didn't happen");
 				goto done;
 
 			case 0x20:
-- 
2.33.1

