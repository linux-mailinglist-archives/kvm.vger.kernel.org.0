Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEB768A7E2
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 03:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbjBDCmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 21:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbjBDCmC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 21:42:02 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB7984B7B
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 18:42:01 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id i3-20020a170902cf0300b00198bc9ba4edso3421961plg.21
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 18:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=JzV72uoeNq80UM7OKhdHXgB95u2p87EaKt4gs2oZB3E=;
        b=pvhvYDNt9wdjXspGnvwhRXUXTLK8KIxBl7aNw7cQh0RPhczlS8PQZJtMpNTDkWgjil
         12DyywF3+EpqZrXSOW9pNuG4YAUKQUpo9JqQ4N1nMgLy4w5Nj++c+w0w82hA7Qjxduc4
         t0sD1kLvxu+tn5HCdppz3V352NlqDMYqLPVtIe9KlnDElXwkSuo+lEM85fEsIZLBB3Iz
         N9Guxpzcy0V5uQSIjuv7oyYBEXeJzVf2z+5sFGJpiF1VU+1x6WmbHORXglobDgHPePpl
         urk+P+FsMLyU1dsjFgKv3KYLosAubHQAuL1Vogwu6HbfIXROUsLwQqSkMehknI1zqdJX
         wdxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JzV72uoeNq80UM7OKhdHXgB95u2p87EaKt4gs2oZB3E=;
        b=hfX2K70kYThycziGJaT9hXJEkp72IveegqIHuFju8ARt/ICRw5ZcQ6m0YocrGdkB4s
         nuKAFHryJk1IdM9clLfz25t9jW48/KGn5jOAMjlTsF73rFN/AMDDKYw6L9Mf+kXD93J5
         DfaTXQk6RGgT1gRBGbQPMr2RYRJ1CvTplbje4RfEZRMQAuSr/mwwvTu8ROcsOFq2WfES
         uMso4WTAVPsO4hqgfvFMtUXcwzxJWGC24n5mVHHM4XeGMfjvjg0gjG7VWEDksEVeMsMB
         ei1VE9UTPWHtgNIM2iIRKbCapituFTTaBLrw9nMONRzsQekzAFMtZIau8MMAYMbutE03
         hwHA==
X-Gm-Message-State: AO0yUKW/W/dU8Wpoc7Cpv9QtYM52TL+MJN9ECXpaK7lL40PdSEQZq39P
        j0m5NEMe2iE3Zm7LM1+Y8oCd+HkTWM0=
X-Google-Smtp-Source: AK7set9Z+PeZsosodDGYy/PLiy6QchHZuuXIvtkT/7erfdlE5ZvTw+15S3T3xWHkiv0F5L7nC3pgZmkiq6g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:a583:b0:196:5cd3:d88a with SMTP id
 az3-20020a170902a58300b001965cd3d88amr2992679plb.12.1675478521156; Fri, 03
 Feb 2023 18:42:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Feb 2023 02:41:51 +0000
In-Reply-To: <20230204024151.1373296-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230204024151.1373296-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230204024151.1373296-5-seanjc@google.com>
Subject: [PATCH v2 4/4] KVM: selftests: Add EVTCHNOP_send slow path test to xen_shinfo_test
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

From: David Woodhouse <dwmw@amazon.co.uk>

When kvm_xen_evtchn_send() takes the slow path because the shinfo GPC
needs to be revalidated, it used to violate the SRCU vs. kvm->lock
locking rules and potentially cause a deadlock.

Now that lockdep is learning to catch such things, make sure that code
path is exercised by the selftest.

Link: https://lore.kernel.org/all/20230113124606.10221-2-dwmw2@infradead.org
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/xen_shinfo_test.c    | 27 +++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 0459126365c9..f8baef107a1b 100644
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
@@ -263,6 +267,16 @@ static void guest_code(void)
 
 	guest_wait_for_irq();
 
+	GUEST_SYNC(TEST_EVTCHN_HCALL_SLOWPATH);
+
+	/*
+	 * Same again, but this time the host has messed with memslots so it
+	 * should take the slow path in kvm_xen_set_evtchn().
+	 */
+	xen_hypercall(__HYPERVISOR_event_channel_op, EVTCHNOP_send, &s);
+
+	guest_wait_for_irq();
+
 	GUEST_SYNC(TEST_EVTCHN_HCALL_EVENTFD);
 
 	/* Deliver "outbound" event channel to an eventfd which
@@ -755,6 +769,19 @@ int main(int argc, char *argv[])
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
2.39.1.519.gcb327c4b5f-goog

