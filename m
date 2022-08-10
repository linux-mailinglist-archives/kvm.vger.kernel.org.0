Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA0858F076
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 18:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbiHJQdh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 12:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232741AbiHJQdU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 12:33:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4EE6D82773
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 09:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660149198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=hb75NAZceQx6eWwtD7RWmVxQSgiFbxhxAQC8UFBs3s8=;
        b=DmjWBrHObMwKgWgSMSsnvylih7Mhiud0Dhf/KuUGRKK6ZUBx9Av6wjxDAg9eqr9FmQItim
        Nnk+CrKUEQHW/1FqbZPypep2rftJOuP90LmTL4x+mYg2g5YnmTLmUcDOJxDRm6VLG9pBNb
        ABSdlvqcn4aU3Z5NgZwEPmKagZpwEEg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-47-3dOtdr5HOWuIndUkJGFMyA-1; Wed, 10 Aug 2022 12:33:17 -0400
X-MC-Unique: 3dOtdr5HOWuIndUkJGFMyA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D462F3833283
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 16:33:16 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C235B9459C
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 16:33:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] ioapic: poll for completion of other CPUs in level-triggered SMP tests
Date:   Wed, 10 Aug 2022 12:33:16 -0400
Message-Id: <20220810163316.55454-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The IOAPIC does not do anything if a level-triggered interrupt is asserted
while its REMOTE_IRR bit is set in the redirection table, and this can
cause a race condition between test_ioapic_physical_destination_mode
and test_ioapic_logical_destination_mode.  If CPU 1 is still running in
ioapic_isr_85 and has not sent the EOI, while CPU 0 has already reached
the set_irq_line(0x0e, 1) line of test_ioapic_logical_destination_mode,
the interrupt is dropped and the test hangs.

For some reason, this has started to occur about 20-30% of the time with
a 5.20-rc0 debug kernel.  With this patch, the ioapic test has survived
100 iterations without failing.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/ioapic.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/x86/ioapic.c b/x86/ioapic.c
index 7cbccd7..4f578ce 100644
--- a/x86/ioapic.c
+++ b/x86/ioapic.c
@@ -6,6 +6,12 @@
 #include "isr.h"
 #include "delay.h"
 
+static void poll_remote_irr(unsigned line)
+{
+	while (ioapic_read_redir(line).remote_irr)
+		cpu_relax();
+}
+
 static void toggle_irq_line(unsigned line)
 {
 	set_irq_line(line, 1);
@@ -214,6 +220,7 @@ static void test_ioapic_level_tmr_smp(bool expected_tmr_before)
 	report(tmr_before == expected_tmr_before && g_tmr_79,
 	       "TMR for ioapic level interrupts (expected %s)",
 	       expected_tmr_before ? "true" : "false");
+	poll_remote_irr(0xe);
 }
 
 static int g_isr_98;
@@ -402,6 +409,7 @@ static void test_ioapic_self_reconfigure(void)
 	set_irq_line(0x0e, 1);
 	e = ioapic_read_redir(0xe);
 	report(g_isr_84 == 1 && e.remote_irr == 0, "Reconfigure self");
+	poll_remote_irr(0xe);
 }
 
 static volatile int g_isr_85;
@@ -429,6 +437,7 @@ static void test_ioapic_physical_destination_mode(void)
 		pause();
 	} while(g_isr_85 != 1);
 	report(g_isr_85 == 1, "ioapic physical destination mode");
+	poll_remote_irr(0xe);
 }
 
 static volatile int g_isr_86;
@@ -461,6 +470,7 @@ static void test_ioapic_logical_destination_mode(void)
 		pause();
 	} while(g_isr_86 < nr_vcpus);
 	report(g_isr_86 == nr_vcpus, "ioapic logical destination mode");
+	poll_remote_irr(0xe);
 }
 
 int main(void)
-- 
2.31.1

