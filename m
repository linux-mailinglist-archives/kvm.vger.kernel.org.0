Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFC797C5BC
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388655AbfGaPJV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:09:21 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34521 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388602AbfGaPIa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:08:30 -0400
Received: by mail-ed1-f65.google.com with SMTP id s49so31197763edb.1
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2C449KSjT4bbSwYYn5oh0t+GvJgUUHqBrjpFSTJaVMM=;
        b=BRLtr4tgYn50QM+JIDHN/iYJHDA/eYrOUmJYvQptXTzwrBNdmFzt8zjJULLektK/VA
         AL/NZPGusMjazLlBev7xe67PdKIfQ1ifpZNsX3n6tVVOa4ud/9OwxtjEEiXleT0dww34
         btnUPhOQ9ej+n+IZzfuH/c2u7wLSynBdGbkIYgwm/zx9aTR7AirSR8kauZtQI1eG36ut
         GrY5WSOyefYNkH38KCUyy7rpU+qfA4Tow+UQHZI/00wFfW7zf53dLyFQhYvsbF2QDkKz
         HwKhJkV1eHDK+DsnsDoJNeFWLsnZIxfo/PjZHwoQIcsO8/FwvmZXcMuwGCHQNeY7A0V3
         GE2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2C449KSjT4bbSwYYn5oh0t+GvJgUUHqBrjpFSTJaVMM=;
        b=bQlRShkhCsu9aQiOX3Dtz3xyoCrWzF72bdsTsYG+7q6+ZKlYN7xCIJV61S3Ku2UIDq
         5A417d1NWbRadz8BIWyfDqGxEZFAfuLN78gVUoHQqHciOPZybyiaUvr22UB46Db6Njts
         SWSQzwMtKFYSyHNtQxHiIM5zJUSvKukjvsWt7qbO//+i7KDpg3Q4D6Iue5MfyNZDQzeF
         XT5/EC5ALGuK6EHx5esxhC75IS4h0Arz3V0cnFOLEXYS2mQ7Gi61NOxkiCCdfsoCnrEx
         UFuzZSzlGjME1bDTi84IjqYKrxPnwZeRre5NBOn/FXZCHeehbQupEwDpbzKGGlwnQ5cy
         sX+g==
X-Gm-Message-State: APjAAAXobCf4vxtHKh6nekIOjTnLQPWX1YHIaBU6/rqdFy99cd9ed2an
        tifVzY4uCU7HEQ5U0xmX9eQ=
X-Google-Smtp-Source: APXvYqxMBwDpewyfIfpy++jLBpP8UloTaXPGrZ8I/eqCpEpkmrEfDx2SZR3u/YrZv24UsUCPRBrhkw==
X-Received: by 2002:a05:6402:28e:: with SMTP id l14mr42072938edv.11.1564585709289;
        Wed, 31 Jul 2019 08:08:29 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id jt17sm12600191ejb.90.2019.07.31.08.08.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:08:28 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 8E3561030BE; Wed, 31 Jul 2019 18:08:16 +0300 (+03)
To:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2 23/59] x86/pconfig: Set an activated algorithm in all MKTME commands
Date:   Wed, 31 Jul 2019 18:07:37 +0300
Message-Id: <20190731150813.26289-24-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alison Schofield <alison.schofield@intel.com>

The Intel MKTME architecture specification requires an activated
encryption algorithm for all command types.

For commands that actually perform encryption, SET_KEY_DIRECT and
SET_KEY_RANDOM, the user specifies the algorithm when requesting the
key through the MKTME Key Service.

For CLEAR_KEY and NO_ENCRYPT commands, do not require the user to
specify an algorithm. Define a default algorithm, that is 'any
activated algorithm' to cover those two special cases.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/include/asm/intel_pconfig.h | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/intel_pconfig.h b/arch/x86/include/asm/intel_pconfig.h
index 3cb002b1d0f9..4f27b0c532ee 100644
--- a/arch/x86/include/asm/intel_pconfig.h
+++ b/arch/x86/include/asm/intel_pconfig.h
@@ -21,14 +21,20 @@ enum pconfig_leaf {
 
 /* Defines and structure for MKTME_KEY_PROGRAM of PCONFIG instruction */
 
+/* mktme_key_program::keyid_ctrl ENC_ALG, bits [23:8] */
+#define MKTME_AES_XTS_128	(1 << 8)
+#define MKTME_ANY_ACTIVATED_ALG	(1 << __ffs(mktme_algs) << 8)
+
 /* mktme_key_program::keyid_ctrl COMMAND, bits [7:0] */
 #define MKTME_KEYID_SET_KEY_DIRECT	0
 #define MKTME_KEYID_SET_KEY_RANDOM	1
-#define MKTME_KEYID_CLEAR_KEY		2
-#define MKTME_KEYID_NO_ENCRYPT		3
 
-/* mktme_key_program::keyid_ctrl ENC_ALG, bits [23:8] */
-#define MKTME_AES_XTS_128	(1 << 8)
+/*
+ * CLEAR_KEY and NO_ENCRYPT require the COMMAND in bits [7:0]
+ * and any activated encryption algorithm, ENC_ALG, in bits [23:8]
+ */
+#define MKTME_KEYID_CLEAR_KEY  (2 | MKTME_ANY_ACTIVATED_ALG)
+#define MKTME_KEYID_NO_ENCRYPT (3 | MKTME_ANY_ACTIVATED_ALG)
 
 /* Return codes from the PCONFIG MKTME_KEY_PROGRAM */
 #define MKTME_PROG_SUCCESS	0
-- 
2.21.0

