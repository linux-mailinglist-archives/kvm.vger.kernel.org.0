Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C874E63412A
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbiKVQPU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234189AbiKVQOe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:14:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE2673B8A
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669133526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Ty0ykKCINpxLikA5IoLsCdzdm1Owy75wCUWVVvYrmk=;
        b=YsyYmBZLCNoul5rc/ieABJdEv/44CSGqJAYsyQoQ1RFMyoU/lJ3eXMl9DZMhCtkt8nAz+C
        pf91lRkZmZ5fBMqzcdhd6ip025nX+Ny/oPn3ntADzQAgrAnBPskvM+nzAGW1dQSfIhyBXe
        we8OQ/o7Ho904f5kXiBYyRcCEECfd70=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-u3THUi5dPjWVlhDqaSxg9w-1; Tue, 22 Nov 2022 11:12:04 -0500
X-MC-Unique: u3THUi5dPjWVlhDqaSxg9w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1F403C0DDD4;
        Tue, 22 Nov 2022 16:12:02 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B75FF1121333;
        Tue, 22 Nov 2022 16:12:00 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Nico Boehr <nrb@linux.ibm.com>,
        Cathy Avery <cavery@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v3 03/27] x86: add few helper functions for apic local timer
Date:   Tue, 22 Nov 2022 18:11:28 +0200
Message-Id: <20221122161152.293072-4-mlevitsk@redhat.com>
In-Reply-To: <20221122161152.293072-1-mlevitsk@redhat.com>
References: <20221122161152.293072-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 lib/x86/apic.c | 38 ++++++++++++++++++++++++++++++++++++++
 lib/x86/apic.h |  6 ++++++
 2 files changed, 44 insertions(+)

diff --git a/lib/x86/apic.c b/lib/x86/apic.c
index 5131525a..174a8c28 100644
--- a/lib/x86/apic.c
+++ b/lib/x86/apic.c
@@ -256,3 +256,41 @@ void init_apic_map(void)
 			id_map[j++] = i;
 	}
 }
+
+void apic_setup_timer(int vector, u32 mode)
+{
+	apic_cleanup_timer();
+
+	assert((mode & APIC_LVT_TIMER_MASK) == mode);
+
+	apic_write(APIC_TDCR, APIC_TDR_DIV_1);
+	apic_write(APIC_LVTT, vector | mode);
+}
+
+void apic_start_timer(u32 value)
+{
+	/*
+	 * APIC timer runs with 'core crystal clock',
+	 * divided by value in APIC_TDCR
+	 */
+	apic_write(APIC_TMICT, value);
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
+	// enable interrupts for one cycle to ensure that a pending timer is serviced
+	sti_nop_cli();
+}
diff --git a/lib/x86/apic.h b/lib/x86/apic.h
index 6d27f047..7c539071 100644
--- a/lib/x86/apic.h
+++ b/lib/x86/apic.h
@@ -58,6 +58,12 @@ void disable_apic(void);
 void reset_apic(void);
 void init_apic_map(void);
 
+void apic_cleanup_timer(void);
+void apic_setup_timer(int vector, u32 mode);
+
+void apic_start_timer(u32 counter);
+void apic_stop_timer(void);
+
 /* Converts byte-addressable APIC register offset to 4-byte offset. */
 static inline u32 apic_reg_index(u32 reg)
 {
-- 
2.34.3

