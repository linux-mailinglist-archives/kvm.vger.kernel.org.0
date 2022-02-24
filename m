Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 928964C29FA
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 11:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbiBXK4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 05:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233613AbiBXK4i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 05:56:38 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ECF427C206
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 02:56:07 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 94BB81F43D;
        Thu, 24 Feb 2022 10:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1645700166; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hE6nt7W7JjTmRvVRO3u6R7ppQcKxDm8IBTTiSWRVaro=;
        b=QG9fa6+hB5pZfVZQJ3mzkO7GQHu5WNTKSLEkVxXFMD9szjCtTKTT++zuh5gmkhgCS4Q+kQ
        DRRHZyFpJoQ+rERQ4Q1mJoSQ0EcD2llpayyX5f++Vt3V+tHcpw5TYpllTn0WI70g7j0WQc
        q0NN+oNPoo4BhEluh5N/SCWcUcNb19Y=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0A19513A79;
        Thu, 24 Feb 2022 10:56:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id oCslAEZkF2KYSgAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Thu, 24 Feb 2022 10:56:06 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de,
        varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH v3 03/11] lib: Define unlikely()/likely() macros in libcflat.h
Date:   Thu, 24 Feb 2022 11:54:43 +0100
Message-Id: <20220224105451.5035-4-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220224105451.5035-1-varad.gautam@suse.com>
References: <20220224105451.5035-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

So that they can be shared across testcases and lib/.
Linux's x86 instruction decoder refrences them.

Signed-off-by: Varad Gautam <varad.gautam@gmail.com>
---
 lib/libcflat.h | 3 +++
 x86/kvmclock.c | 4 ----
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/lib/libcflat.h b/lib/libcflat.h
index c1fd31f..0cfd1bc 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -166,4 +166,7 @@ extern void setup_vm(void);
 #define SZ_1G			(1 << 30)
 #define SZ_2G			(1ul << 31)
 
+#define unlikely(x)	__builtin_expect(!!(x), 0)
+#define likely(x)	__builtin_expect(!!(x), 1)
+
 #endif
diff --git a/x86/kvmclock.c b/x86/kvmclock.c
index de30a5e..cae867f 100644
--- a/x86/kvmclock.c
+++ b/x86/kvmclock.c
@@ -5,10 +5,6 @@
 #include "kvmclock.h"
 #include "asm/barrier.h"
 
-#define unlikely(x)	__builtin_expect(!!(x), 0)
-#define likely(x)	__builtin_expect(!!(x), 1)
-
-
 struct pvclock_vcpu_time_info __attribute__((aligned(4))) hv_clock[MAX_CPU];
 struct pvclock_wall_clock wall_clock;
 static unsigned char valid_flags = 0;
-- 
2.32.0

