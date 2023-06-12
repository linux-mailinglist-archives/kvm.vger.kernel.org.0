Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5BC72B921
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 09:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235885AbjFLHun (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 03:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235988AbjFLHtt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 03:49:49 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56A9E41
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 00:49:17 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 9FBCF2048A;
        Mon, 12 Jun 2023 07:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686556094; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NgaFjqc3Lyzhdj6Y6fighNx/tRbQ0dOwIcedgK4btVo=;
        b=LDZSdYCqto7oADqjs4gHtjHg4etnyVdWeguaQI8ClASQnG+T0UNLxtJ+Jd3rT9ZKtsh/VO
        fB9x+A5ueTFbdNCHkS8QkLYftD41Usahu/njunxTY8Fll7XnR+sXKAMcj4P2ywe0gmryLL
        tOjvmm8215B/XOuxA+N7NF8g+8zIBXE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686556094;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NgaFjqc3Lyzhdj6Y6fighNx/tRbQ0dOwIcedgK4btVo=;
        b=sIakf5OYKHFfdxeN8MbmjokC3aQC+KNK24GssakFzc/HPFD1Uo6h8QYRY3rrsp4ybGLTGI
        q/pJQJAdytTpk6Bw==
Received: from vasant-suse.fritz.box (unknown [10.163.24.134])
        by relay2.suse.de (Postfix) with ESMTP id 2A1192C141;
        Mon, 12 Jun 2023 07:48:14 +0000 (UTC)
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     pbonzini@redhat.com
Cc:     Thomas.Lendacky@amd.com, drjones@redhat.com, erdemaktas@google.com,
        jroedel@suse.de, kvm@vger.kernel.org, marcorr@google.com,
        rientjes@google.com, seanjc@google.com, zxwang42@gmail.com,
        Vasant Karasulli <vkarasulli@suse.de>,
        Varad Gautam <varad.gautam@suse.com>
Subject: [PATCH v4 03/11] lib: Define unlikely()/likely() macros in libcflat.h
Date:   Mon, 12 Jun 2023 09:47:50 +0200
Message-Id: <20230612074758.9177-4-vkarasulli@suse.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230612074758.9177-1-vkarasulli@suse.de>
References: <20230612074758.9177-1-vkarasulli@suse.de>
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

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
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
index f9f2103..487c12a 100644
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
2.34.1

