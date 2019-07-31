Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C74157C641
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729775AbfGaPWA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:22:00 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36767 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbfGaPV7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:21:59 -0400
Received: by mail-ed1-f65.google.com with SMTP id k21so66073972edq.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c5WMXVoIZssEiK4OS2ZsI14EAD5bwwEyXB7tLs9S9Os=;
        b=GgMDYljgt69NuT2KJuOpsbtMf2bZflY04jkdcsb64J58gp3TxiHEEkOrT1ozLhakGl
         94A0Aqkr8JolguUGlRobFPi57btYrwT3g8MYH4q5fgBYWQAov6IpM5yec8GdWQhRD5tC
         0Ax6JsB0ooIwmT4n5nblwvmWo7thAMBxnFrHSP9RfZBW9LLERr65CaaolDQ48tv/CAKX
         l2OBdufhK2nJeUB9MMPZPdYfYOqpvH6oRpIZCUxqhsrsgYyEegj1/UXzCzFcS0ucxo4Z
         EdcRyeDiAndnOaS1LNOs83hgApICxD3lTMqnXM53LXOsfL7gbP+s6/BUFBXV4t3iCpQw
         uzGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c5WMXVoIZssEiK4OS2ZsI14EAD5bwwEyXB7tLs9S9Os=;
        b=K5RRvXwGlGAt3j/+Af0Q9DJPqrPtWa7lOeQlRazFG+RGZX0QGJ9K1+f8lBfKEoB/DB
         X9j7iwLEO92WidRzX+vx8hfkv7ttYxkAAuptSLbML5wglEr4JnwBLVRQp1x7WC0okPCO
         LB8ztVjnjZsnQfeyQY0xpccT2jj5YtpLEJrTeq43S/urrtmcV++RU972RsJ+M+zPCm/0
         fm/l+QcuXjIDr2xdiuUGk1JL6rmRq+QG9MEVysb6Gp3iVSVk3VJavppKUMyaOYx7sxkU
         EMmCwFzdPa3gTrSdVqp1CF5ZiQkb45TNu75qrB+qMn/fZbAGDNHfxjgtq0v6YRR9ZKzz
         BNXA==
X-Gm-Message-State: APjAAAX0c5rpkvvFr2YC94GrloiAye/CyXe4kedQ5pY+LSap3iCLiRRp
        ++QG6QkpsOMNSZrNyJNn+qg=
X-Google-Smtp-Source: APXvYqwYMqulY0Xx64lB5aqfOhV4++kQN1Oobfks3JeYhOF1doEtw6JzyLb48pAr8c5dYOSv/qswsA==
X-Received: by 2002:a17:906:e204:: with SMTP id gf4mr92542915ejb.302.1564586036461;
        Wed, 31 Jul 2019 08:13:56 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id d7sm16507912edr.39.2019.07.31.08.13.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:13:53 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id AA55A1030C2; Wed, 31 Jul 2019 18:08:16 +0300 (+03)
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
Subject: [PATCHv2 27/59] keys/mktme: Destroy MKTME keys
Date:   Wed, 31 Jul 2019 18:07:41 +0300
Message-Id: <20190731150813.26289-28-kirill.shutemov@linux.intel.com>
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

Destroy is a method invoked by the kernel key service when a
userspace key is being removed. (invalidate, revoke, timeout).

During destroy, MKTME wil returned the hardware KeyID to the pool
of available keyids.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 security/keys/mktme_keys.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/security/keys/mktme_keys.c b/security/keys/mktme_keys.c
index beca852db01a..10fcdbf5a08f 100644
--- a/security/keys/mktme_keys.c
+++ b/security/keys/mktme_keys.c
@@ -50,6 +50,23 @@ int mktme_reserve_keyid(struct key *key)
 	return 0;
 }
 
+static void mktme_release_keyid(int keyid)
+{
+	 mktme_map[keyid].state = KEYID_AVAILABLE;
+	 mktme_available_keyids++;
+}
+
+int mktme_keyid_from_key(struct key *key)
+{
+	int i;
+
+	for (i = 1; i <= mktme_nr_keyids(); i++) {
+		if (mktme_map[i].key == key)
+			return i;
+	}
+	return 0;
+}
+
 enum mktme_opt_id {
 	OPT_ERROR,
 	OPT_TYPE,
@@ -62,6 +79,17 @@ static const match_table_t mktme_token = {
 	{OPT_ERROR, NULL}
 };
 
+/* Key Service Method called when a Userspace Key is garbage collected. */
+static void mktme_destroy_key(struct key *key)
+{
+	int keyid = mktme_keyid_from_key(key);
+	unsigned long flags;
+
+	spin_lock_irqsave(&mktme_lock, flags);
+	mktme_release_keyid(keyid);
+	spin_unlock_irqrestore(&mktme_lock, flags);
+}
+
 /* Key Service Method to create a new key. Payload is preparsed. */
 int mktme_instantiate_key(struct key *key, struct key_preparsed_payload *prep)
 {
@@ -198,6 +226,7 @@ struct key_type key_type_mktme = {
 	.free_preparse	= mktme_free_preparsed_payload,
 	.instantiate	= mktme_instantiate_key,
 	.describe	= user_describe,
+	.destroy	= mktme_destroy_key,
 };
 
 static int __init init_mktme(void)
-- 
2.21.0

