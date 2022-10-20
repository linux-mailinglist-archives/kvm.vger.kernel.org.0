Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E64E60644D
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 17:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiJTPYT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 11:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiJTPYO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 11:24:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3DB31C2084
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 08:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666279453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XDKOXzKX6xterI+VKY8jIocIj9cS4q1kWjatCPJHH1k=;
        b=PKGE/FFuv1rf9UyZLLXc7ibj2u9Yr6r9NE44Z8EMKac4NRuzkkNt4kQ8TvalerI3U75Al9
        omkPYdwVLhUJRZx6ksYG5j4IIMWQlzlsCVle5aErRKTmzPfNtqdw4LcG3Rg1PLlGgIttpn
        DXzfS75/pS2fCouLzi5dRJ0RhbqNZ8o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-VK2w9ZN7MYyJg8gW76PJGA-1; Thu, 20 Oct 2022 11:24:11 -0400
X-MC-Unique: VK2w9ZN7MYyJg8gW76PJGA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 515B1101A54E
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 15:24:11 +0000 (UTC)
Received: from localhost.localdomain (ovpn-192-51.brq.redhat.com [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F5D02024CB7;
        Thu, 20 Oct 2022 15:24:09 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 02/16] x86: add few helper functions for apic local timer
Date:   Thu, 20 Oct 2022 18:23:50 +0300
Message-Id: <20221020152404.283980-3-mlevitsk@redhat.com>
In-Reply-To: <20221020152404.283980-1-mlevitsk@redhat.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a few functions to apic.c to make it easier to enable and disable
the local apic timer.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 lib/x86/apic.c | 37 +++++++++++++++++++++++++++++++++++++
 lib/x86/apic.h |  6 ++++++
 2 files changed, 43 insertions(+)

diff --git a/lib/x86/apic.c b/lib/x86/apic.c
index 5131525a..dc6d3862 100644
--- a/lib/x86/apic.c
+++ b/lib/x86/apic.c
@@ -256,3 +256,40 @@ void init_apic_map(void)
 			id_map[j++] = i;
 	}
 }
+
+void apic_setup_timer(int vector, bool periodic)
+{
+	/* APIC runs with 'CPU core clock' divided by value in APIC_TDCR */
+
+	u32 lvtt = vector |
+			(periodic ? APIC_LVT_TIMER_PERIODIC : APIC_LVT_TIMER_ONESHOT);
+
+	apic_cleanup_timer();
+	apic_write(APIC_TDCR, APIC_TDR_DIV_1);
+	apic_write(APIC_LVTT, lvtt);
+}
+
+void apic_start_timer(u32 counter)
+{
+	apic_write(APIC_TMICT, counter);
+}
+
+void apic_stop_timer(void)
+{
+	apic_write(APIC_TMICT, 0);
+}
+
+void apic_cleanup_timer(void)
+{
+	u32 lvtt = apic_read(APIC_LVTT);
+
+	// stop the counter
+	apic_stop_timer();
+
+	// mask the timer interrupt
+	apic_write(APIC_LVTT, lvtt | APIC_LVT_MASKED);
+
+	// ensure that a pending timer is serviced
+	irq_enable();
+	irq_disable();
+}
diff --git a/lib/x86/apic.h b/lib/x86/apic.h
index 6d27f047..db691e2a 100644
--- a/lib/x86/apic.h
+++ b/lib/x86/apic.h
@@ -58,6 +58,12 @@ void disable_apic(void);
 void reset_apic(void);
 void init_apic_map(void);
 
+void apic_cleanup_timer(void);
+void apic_setup_timer(int vector, bool periodic);
+
+void apic_start_timer(u32 counter);
+void apic_stop_timer(void);
+
 /* Converts byte-addressable APIC register offset to 4-byte offset. */
 static inline u32 apic_reg_index(u32 reg)
 {
-- 
2.26.3

