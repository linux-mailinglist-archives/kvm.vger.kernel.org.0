Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 516E37C633
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbfGaPVb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:21:31 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:33371 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbfGaPVa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:21:30 -0400
Received: by mail-ed1-f68.google.com with SMTP id i11so2564085edq.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1BQJGkT0s+shkdXKpDMkrADfSTioqQt/ZZz1bLqTUmQ=;
        b=F0MT0AnrCovBczYaK6YHDuFLb0wBcNajj6NHjl7jAd1Y6o1sz/pNiCycggcpbm6sR3
         dDEawPYmizqxf+941dOmoLsE0S6Q6h1HQDO131T53iZuuKNPHzVa3IPL9WD/cAQThRxW
         19GfKEGA+MvSm2zoe3KKZc/IX3XQ6h9saIaqsaf2Cv3IGGslYpWhz/Y2aQxDBt3NfhUb
         w/gBHQa/MfFXThu2xMpIdQZhfx6ijjecuKQ3SRFmAoT48fh5DVqlO0eNkdkALj71DjZx
         huhf1zc3aR8yYQEOtkcgzJ7LoEXxQCLmXSefv3Umpu1K5rbidj3HWE72bSF4c6y4iBlq
         mv+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1BQJGkT0s+shkdXKpDMkrADfSTioqQt/ZZz1bLqTUmQ=;
        b=cIGOBMmzvqAlUAIj3DOTVprJjcFr4bZRbPPyJ1GqnRPlt8r/R4xOT9jstZInCjWcit
         VpcbriIL+0Hhq/ixBVP1gMM8Y8X67NhNLlt+ReD3RVFGdbjs5ko2jv6wk/7bZjh6CjV4
         pOswybRAhRkmxv/zkzaY3bN9zTP1goK9YPQ4kOeDcWmb3A8dCNMkVpdWaNRDwOM/EmAY
         hxSWDuKTLNUSl7tQFJEegz5RmVYe/Ofd4s/+Ytm1+UVOmSfIOgSbruAE5rKKgsygW/Ws
         XyyiBVWhKkuGmEguMGiTpgfrcFzuW6UEQ5e0XTUPYsxVL6pA70qDMZKXiX6l5x/Mzhx1
         CxiQ==
X-Gm-Message-State: APjAAAUdMgqrkSCeiCt5NVvTbUFCxfgOqdVXvwa3RWDaA0C1OAhYaLBR
        oGnjEIOF0S4hjerxyrgsamw=
X-Google-Smtp-Source: APXvYqy+sAZ1XO5Dthl6XVadxh27450cRd8oWJweimgbdsPH0ca3T6NWosb4Y5aumCe01jgo510kdA==
X-Received: by 2002:a17:906:2555:: with SMTP id j21mr96482359ejb.231.1564586030314;
        Wed, 31 Jul 2019 08:13:50 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id s2sm5404851ejf.11.2019.07.31.08.13.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:13:47 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id B152E1030C3; Wed, 31 Jul 2019 18:08:16 +0300 (+03)
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
Subject: [PATCHv2 28/59] keys/mktme: Move the MKTME payload into a cache aligned structure
Date:   Wed, 31 Jul 2019 18:07:42 +0300
Message-Id: <20190731150813.26289-29-kirill.shutemov@linux.intel.com>
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

In preparation for programming the key into the hardware, move
the key payload into a cache aligned structure. This alignment
is a requirement of the MKTME hardware.

Use the slab allocator to have this structure readily available.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 security/keys/mktme_keys.c | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/security/keys/mktme_keys.c b/security/keys/mktme_keys.c
index 10fcdbf5a08f..8ac75b1e6188 100644
--- a/security/keys/mktme_keys.c
+++ b/security/keys/mktme_keys.c
@@ -16,6 +16,7 @@
 
 static DEFINE_SPINLOCK(mktme_lock);
 static unsigned int mktme_available_keyids;  /* Free Hardware KeyIDs */
+static struct kmem_cache *mktme_prog_cache;  /* Hardware programming cache */
 
 enum mktme_keyid_state {
 	KEYID_AVAILABLE,	/* Available to be assigned */
@@ -79,6 +80,25 @@ static const match_table_t mktme_token = {
 	{OPT_ERROR, NULL}
 };
 
+/* Copy the payload to the HW programming structure and program this KeyID */
+static int mktme_program_keyid(int keyid, u32 payload)
+{
+	struct mktme_key_program *kprog = NULL;
+	int ret;
+
+	kprog = kmem_cache_zalloc(mktme_prog_cache, GFP_KERNEL);
+	if (!kprog)
+		return -ENOMEM;
+
+	/* Hardware programming requires cached aligned struct */
+	kprog->keyid = keyid;
+	kprog->keyid_ctrl = payload;
+
+	ret = MKTME_PROG_SUCCESS;	/* Future programming call */
+	kmem_cache_free(mktme_prog_cache, kprog);
+	return ret;
+}
+
 /* Key Service Method called when a Userspace Key is garbage collected. */
 static void mktme_destroy_key(struct key *key)
 {
@@ -93,6 +113,7 @@ static void mktme_destroy_key(struct key *key)
 /* Key Service Method to create a new key. Payload is preparsed. */
 int mktme_instantiate_key(struct key *key, struct key_preparsed_payload *prep)
 {
+	u32 *payload = prep->payload.data[0];
 	unsigned long flags;
 	int keyid;
 
@@ -101,7 +122,14 @@ int mktme_instantiate_key(struct key *key, struct key_preparsed_payload *prep)
 	spin_unlock_irqrestore(&mktme_lock, flags);
 	if (!keyid)
 		return -ENOKEY;
-	return 0;
+
+	if (!mktme_program_keyid(keyid, *payload))
+		return MKTME_PROG_SUCCESS;
+
+	spin_lock_irqsave(&mktme_lock, flags);
+	mktme_release_keyid(keyid);
+	spin_unlock_irqrestore(&mktme_lock, flags);
+	return -ENOKEY;
 }
 
 /* Make sure arguments are correct for the TYPE of key requested */
@@ -245,10 +273,15 @@ static int __init init_mktme(void)
 	if (!mktme_map)
 		return -ENOMEM;
 
+	/* Used to program the hardware key tables */
+	mktme_prog_cache = KMEM_CACHE(mktme_key_program, SLAB_PANIC);
+	if (!mktme_prog_cache)
+		goto free_map;
+
 	ret = register_key_type(&key_type_mktme);
 	if (!ret)
 		return ret;			/* SUCCESS */
-
+free_map:
 	kvfree(mktme_map);
 
 	return -ENOMEM;
-- 
2.21.0

