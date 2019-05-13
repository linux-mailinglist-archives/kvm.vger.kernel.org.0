Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C165E1BBBC
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 19:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731445AbfEMRUi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 13:20:38 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33424 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfEMRUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 13:20:37 -0400
Received: by mail-pf1-f194.google.com with SMTP id z28so7562763pfk.0
        for <kvm@vger.kernel.org>; Mon, 13 May 2019 10:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7vo529TtXtKFhricr79LWKl566r0oKZfuIAJy9bYXa4=;
        b=hH45lqXN0fFN95YXGa0UGGiWqx3DX4AKPkxvfSHCQBCSesrDo5tijzDT4mfjlaj1tA
         4+BmSTUZDajAe2gxifPWlLTQ85eEgjtGxOVyJNA36LFueeBbv3U28CSmG70S6JKxfzU4
         z0fQ1TOBCh/K5HpjavixrTDx2EkrMoUaPhaYKpS74GKjGat5NIzL3wf4GB0wTvZFeSoT
         64CtbdfDPlgYoMJKY2XBxi7Tl6af9YUXrAFGsmDaBNYMyHZt8nEfInWhh91q9u96mOsG
         GX3i4bEbuijpvAe3PJwFCq34KHI2SNHlxiEgXe4JDZKeAvFQAZVwWC0eCJSF8lMXhMiP
         Qlxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7vo529TtXtKFhricr79LWKl566r0oKZfuIAJy9bYXa4=;
        b=AjA6ULkA1bIWdSs+Y6QrCcF5OGkidtEjW7VU2DH1irJ83yTk/12C8ecf8TwD4j243/
         o0NYYnCAEAbxIGD5iTXF+q8U5nJID/OnDPGxpgDpagIRauG/P+ZW59956whv+3BVtX7D
         iKWoc9j4mDe4UeW5AaDOwJoJyGktAZwJafYoBLdyJYWmrUpP5wt9FSlRZulXxRRPSIkV
         bdXlqxzB76oKNefP1+7n2gx8h5hPblPiVF4BwihnOonwcMGKbH6u/iTw5nRvBeM3jf+v
         oIvOcIvca8uJyytCE6eULsDMPTVGBMfFQDqfzBKIPVlBpXs9OeGQVtxRVQD+pMKUTOdd
         j2tw==
X-Gm-Message-State: APjAAAXfd2xKvsIl8i1hzcOugg+W0aQHA9Ff/lt3+96JopHLwCKRJQ4J
        ezC4Sg7wS1dztpyUf4wjr9w=
X-Google-Smtp-Source: APXvYqx6DgBie4gE5C5F60EWAXn0CbnClhSz4giO4PSHjCc+yFsmbWCHoxYVWbFAn6hHdNSqRZgpBA==
X-Received: by 2002:a62:56d9:: with SMTP id h86mr36095712pfj.195.1557768036814;
        Mon, 13 May 2019 10:20:36 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id a26sm25565654pfl.177.2019.05.13.10.20.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 10:20:35 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com,
        Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH v2] x86: Halt on exit
Date:   Mon, 13 May 2019 02:58:28 -0700
Message-Id: <20190513095828.41255-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In some cases, shutdown through the test device and Bochs might fail.
Just hang in a loop that executes halt in such cases. Remove the
__builtin_unreachable() as it is not needed anymore.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 lib/x86/io.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/x86/io.c b/lib/x86/io.c
index f3e01f7..f4ffb44 100644
--- a/lib/x86/io.c
+++ b/lib/x86/io.c
@@ -99,7 +99,11 @@ void exit(int code)
 #else
         asm volatile("out %0, %1" : : "a"(code), "d"((short)0xf4));
 #endif
-	__builtin_unreachable();
+
+	/* Fallback */
+	while (1) {
+		asm volatile("hlt" ::: "memory");
+	}
 }
 
 void __iomem *ioremap(phys_addr_t phys_addr, size_t size)
-- 
2.17.1

