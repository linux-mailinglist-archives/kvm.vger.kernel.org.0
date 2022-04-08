Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 106B94F9300
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 12:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234497AbiDHKdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 06:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233494AbiDHKdg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 06:33:36 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDED031BBA3
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 03:31:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 754E11F865;
        Fri,  8 Apr 2022 10:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649413891; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JVT6rMpMS7JTIgVegPzXLBoaBeG/chSVT/MF61xO2cU=;
        b=Y+l6/GKJJVMZeaSEr0/iCw748INrvmr2LSEg25OvwOU9oTXBjpTT8oit1X7psHzrcy8Ftj
        TX/EyJpTKr84DWc713VzO+a4gqTHlTkRc+zUAS5d4+V8X2F1oBadAHdYGIz1xt6qTrJ/4H
        NZ4d9P9RNuYkaUBH28p9vKc3TZncJJs=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 94537132B9;
        Fri,  8 Apr 2022 10:31:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id YP4BIgIPUGLIYAAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Fri, 08 Apr 2022 10:31:30 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH 9/9] x86: setup: Serialize ap_start64 with a spinlock
Date:   Fri,  8 Apr 2022 12:31:27 +0200
Message-Id: <20220408103127.19219-10-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220408103127.19219-1-varad.gautam@suse.com>
References: <20220408103127.19219-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since apic.c:apic_ops is not guarded against concurrent accesses,
there exists a race between reset_apic(), enable_apic() and
enable_x2apic() which results in APs crashing or getting blocked
in various scenarios (eg, enabling x2apic while disabling xapic).

The bug is rare with vcpu count < 32, but becomes easier to
reproduce with vcpus > 64 and the following thunk:

lib/x86/apic.c:
 void enable_apic(void)
 {
-    printf("enabling apic\n");
     xapic_write(APIC_SPIV, 0x1ff);
 }

Serialize the bringup code in ap_start64 to fix this.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Link: https://lore.kernel.org/kvm/20220406124002.13741-1-varad.gautam@suse.com/
---
Note that this is a C port of 20220406124002.13741-1-varad.gautam@suse.com
which is not present upstream. I can squash it into the previous patch once
the asm version is upstream.

 lib/x86/setup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 261fd9b..b08290a 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -16,6 +16,9 @@
 #include "asm/setup.h"
 #include "processor.h"
 #include "atomic.h"
+#include "asm/spinlock.h"
+
+struct spinlock ap_lock;
 
 extern char edata;
 extern unsigned char online_cpus[(MAX_TEST_CPUS + 7) / 8];
@@ -371,12 +374,14 @@ void save_id(void)
 
 void ap_start64(void)
 {
+	spin_lock(&ap_lock);
 	reset_apic();
 	load_idt();
 	setup_gdt_tss();
 	save_id();
 	enable_apic();
 	enable_x2apic();
+	spin_unlock(&ap_lock);
 	sti();
 	atomic_fetch_inc(&cpu_online_count);
 	asm volatile("1: hlt; jmp 1b");
-- 
2.32.0

