Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE4F97C5BE
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388609AbfGaPJX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:09:23 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:45707 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388591AbfGaPIa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:08:30 -0400
Received: by mail-ed1-f66.google.com with SMTP id x19so60096080eda.12
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LSpLd4hZuC7djly8qH62+kJZqlzlyenE+/UQYliczqM=;
        b=GZAidz/YZr5AJC6YjcivhC/xqBVAms+Bun6/vc7F/gyEggHe0hZuW419LPz4dWQdJT
         vjHvZ3FQT2pTLNYI8+diNtZJ4Mxf5qQsCaz8bhGx2tJou3Mvi7Xln9rS3xcAAjGFrppw
         gW+UH+S5g+sAHB/UB1hV0L34nZqdQDFvZLBbqH54Bn/Rwmq9aj94nYVe/7QXryCOhcoD
         vwwLv3UG02KHn4tO4cYfAr/TC4lta3wpVG9Dtv+I97XG9iONckyaqQzJX2KNv21wwD/S
         NQJW0wh9O3kxFRnoNJn38/KJX15ote/7R4K6CnTOCcK6umCWPj89ZozJSoXMwY2epZJk
         nulg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LSpLd4hZuC7djly8qH62+kJZqlzlyenE+/UQYliczqM=;
        b=gCFJJBEuqQy85mBpsRZnj2LitfDo/vuXtTGEg3a5pfDXN9jRZ2+opJUBtUhUSw8Qml
         IWCmgVTWALrNlsJdwkBvcP7nCtokHDbuuV/6L4RYG/tOeGGeSUKSX82Vn12BQbG0pBKz
         6e5k44t+OM5pYo9mG+6MCG+biezAmU+9hRvOvepoFBGGrq4gdk0z8QEa64yAaJsmXJOl
         +dUne7fE+SqOpAdpmNLpumjO1TR0H/+7WHBVOIdEOFKlgg17lIsThtFjACEGElXkKBiX
         yVVSDqN/0k0DyAv9U2yN/Q0bKYY6D0xWGbTXq+G2ZU+etsiXl2Eo9w02UzSgbbC/IjnY
         bIGA==
X-Gm-Message-State: APjAAAVhU9H3DScRSTnCvfoHN2q+lya0KVL6Ez7If5t/09fm/RtSYlFP
        L4dGenKUYdNnU8vpBhEg8Zo=
X-Google-Smtp-Source: APXvYqxfkW3YmNbFSguKjUSffCBIjlvJw7vj1+8RS/D77djY6uAKTxwgECDWxNVy5ZuTfly0BeWccg==
X-Received: by 2002:a50:c35b:: with SMTP id q27mr108087273edb.98.1564585708851;
        Wed, 31 Jul 2019 08:08:28 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id k5sm12233535eja.41.2019.07.31.08.08.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:08:28 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id A370B1030C1; Wed, 31 Jul 2019 18:08:16 +0300 (+03)
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
Subject: [PATCHv2 26/59] keys/mktme: Instantiate MKTME keys
Date:   Wed, 31 Jul 2019 18:07:40 +0300
Message-Id: <20190731150813.26289-27-kirill.shutemov@linux.intel.com>
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

Instantiate is a Kernel Key Service method invoked when a key is
added (add_key, request_key) by the user.

During instantiation, MKTME allocates an available hardware KeyID
and maps it to the Userspace Key.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 security/keys/mktme_keys.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/security/keys/mktme_keys.c b/security/keys/mktme_keys.c
index fe119a155235..beca852db01a 100644
--- a/security/keys/mktme_keys.c
+++ b/security/keys/mktme_keys.c
@@ -14,6 +14,7 @@
 
 #include "internal.h"
 
+static DEFINE_SPINLOCK(mktme_lock);
 static unsigned int mktme_available_keyids;  /* Free Hardware KeyIDs */
 
 enum mktme_keyid_state {
@@ -31,6 +32,24 @@ struct mktme_mapping {
 
 static struct mktme_mapping *mktme_map;
 
+int mktme_reserve_keyid(struct key *key)
+{
+	int i;
+
+	if (!mktme_available_keyids)
+		return 0;
+
+	for (i = 1; i <= mktme_nr_keyids(); i++) {
+		if (mktme_map[i].state == KEYID_AVAILABLE) {
+			mktme_map[i].state = KEYID_ASSIGNED;
+			mktme_map[i].key = key;
+			mktme_available_keyids--;
+			return i;
+		}
+	}
+	return 0;
+}
+
 enum mktme_opt_id {
 	OPT_ERROR,
 	OPT_TYPE,
@@ -43,6 +62,20 @@ static const match_table_t mktme_token = {
 	{OPT_ERROR, NULL}
 };
 
+/* Key Service Method to create a new key. Payload is preparsed. */
+int mktme_instantiate_key(struct key *key, struct key_preparsed_payload *prep)
+{
+	unsigned long flags;
+	int keyid;
+
+	spin_lock_irqsave(&mktme_lock, flags);
+	keyid = mktme_reserve_keyid(key);
+	spin_unlock_irqrestore(&mktme_lock, flags);
+	if (!keyid)
+		return -ENOKEY;
+	return 0;
+}
+
 /* Make sure arguments are correct for the TYPE of key requested */
 static int mktme_check_options(u32 *payload, unsigned long token_mask,
 			       enum mktme_type type, enum mktme_alg alg)
@@ -163,6 +196,7 @@ struct key_type key_type_mktme = {
 	.name		= "mktme",
 	.preparse	= mktme_preparse_payload,
 	.free_preparse	= mktme_free_preparsed_payload,
+	.instantiate	= mktme_instantiate_key,
 	.describe	= user_describe,
 };
 
-- 
2.21.0

