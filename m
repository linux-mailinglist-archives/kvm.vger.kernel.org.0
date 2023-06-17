Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C67733D79
	for <lists+kvm@lfdr.de>; Sat, 17 Jun 2023 03:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbjFQBuA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 21:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbjFQBt7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 21:49:59 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8BF3A8B
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 18:49:58 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id 5614622812f47-39c873a5127so1094863b6e.1
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 18:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686966598; x=1689558598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f0aouI3DdNhfQmp4r40e0gBQGQY2MKk6L0dsEJY5MkQ=;
        b=J7OeJIZ8wEviVDqIZRl3Bl2hB7vfA673NwmzXNm6f4T7FEcD6i8KGymnPKa8rhhBYr
         X06AufW+zecDL+TxWQGF+LHMBvwx8YJCTrsTmOz4c4YPozhqSzKa+qwlgvyBtQkZA8rH
         yPZRdxOuJMswwTCo6hhihrohG+KBjItf0a05mggMxECoUmmzGcaNBrlZdMuY/ru+1feT
         7zV29Z8FYCpKqRfBl6MOSOlGJIyM+xBKNotAWdD7haqTcK65spHaQEiwrA5a3ESXyfwB
         UdsjLvpg27Kxujzzdd0+rTlgEJdgDjCo7bRNJwIKs/YJwlcylIArswWr1gNHHPXCQQ4u
         vh2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686966598; x=1689558598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f0aouI3DdNhfQmp4r40e0gBQGQY2MKk6L0dsEJY5MkQ=;
        b=RWmxRuakXKhAHga6JgpmOUf8NrACltGmSGeQ573bKjRJCZ7r+N57AwBPM0zggF/rva
         hMGFp82wcw3kV2oLF/0SpJiwv9GzEwTCOczELlD13KyJ8imD9NDwbOxO2PV1BmUrNlBV
         FbDbxpdV71xKh/gr2hiGftT0fXpIqvAzSkxokgObMsSOL5hlajp8BR02mfEglzTw0gWk
         L2IKmN6o5XS9sUJvCuFM82NR5X6DbsotEw36uRalVrZc7ElvgIElFG5/BjlT3s9IhFFU
         UH7EZ45EIjg5QK4j9L1H8/xZY5bObhe1kTrI9RQ4qo7qLGqOjqAXXrgTm+o4/950PcnX
         PzMA==
X-Gm-Message-State: AC+VfDxWcB9MhOffn1aNpHUBjPn60s53ncjtF0CnlZIfwRwa4yLGTLcN
        SNYih4AFfJ70TjsSyy4E97c=
X-Google-Smtp-Source: ACHHUZ6EdQMa4dxT/ZQbdcFF5Q/NvrnVakTMJuCcxJmrEe8+tW5IPfS5UGV69wVFmBIbGGLJ72iZjQ==
X-Received: by 2002:a05:6808:188d:b0:39e:5886:3dde with SMTP id bi13-20020a056808188d00b0039e58863ddemr4907310oib.12.1686966597435;
        Fri, 16 Jun 2023 18:49:57 -0700 (PDT)
Received: from sc9-mailhost1.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id 18-20020a17090a031200b0024dfb8271a4sm2114440pje.21.2023.06.16.18.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 18:49:56 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 2/6] lib/stack: print base addresses on efi
Date:   Sat, 17 Jun 2023 01:49:26 +0000
Message-Id: <20230617014930.2070-3-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230617014930.2070-1-namit@vmware.com>
References: <20230617014930.2070-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

Making sense from dumped stacks when running EFI tests is very hard due
to the relocation. Fix it by adjusting the address back to the original
address.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 lib/stack.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/lib/stack.c b/lib/stack.c
index bdb23fd..c3c7c24 100644
--- a/lib/stack.c
+++ b/lib/stack.c
@@ -6,13 +6,38 @@
  */
 
 #include <libcflat.h>
+#include <stdbool.h>
 #include <stack.h>
 
 #define MAX_DEPTH 20
 
+#ifdef CONFIG_EFI
+extern char _text, _etext;
+
+static bool base_address(const void *rebased_addr, unsigned long *addr)
+{
+	unsigned long ra = (unsigned long)rebased_addr;
+	unsigned long start = (unsigned long)&_text;
+	unsigned long end = (unsigned long)&_etext;
+
+	if (ra < start || ra >= end)
+		return false;
+
+	*addr = ra - start;
+	return true;
+}
+#else
+static bool base_address(const void *rebased_addr, unsigned long *addr)
+{
+	*addr = (unsigned long)rebased_addr;
+	return true;
+}
+#endif
+
 static void print_stack(const void **return_addrs, int depth,
 			bool top_is_return_address)
 {
+	unsigned long addr;
 	int i = 0;
 
 	printf("\tSTACK:");
@@ -20,12 +45,14 @@ static void print_stack(const void **return_addrs, int depth,
 	/* @addr indicates a non-return address, as expected by the stack
 	 * pretty printer script. */
 	if (depth > 0 && !top_is_return_address) {
-		printf(" @%lx", (unsigned long) return_addrs[0]);
+		if (base_address(return_addrs[0], &addr))
+			printf(" @%lx", addr);
 		i++;
 	}
 
 	for (; i < depth; i++) {
-		printf(" %lx", (unsigned long) return_addrs[i]);
+		if (base_address(return_addrs[i], &addr))
+			printf(" %lx", addr);
 	}
 	printf("\n");
 }
-- 
2.34.1

