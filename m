Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3006A7C651
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730128AbfGaPWM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:22:12 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:46326 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727962AbfGaPWI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:22:08 -0400
Received: by mail-ed1-f65.google.com with SMTP id d4so66102150edr.13
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PzedmcWsRc3DhudY/wiWcVyq0AAagaASN0DGAs1EUfk=;
        b=oLYDLyPe+JzY2m1J7wjX7AgBe2E4rUQv0fXNMOTxiG0nu3Kabo9U15Ufg7K6WUQgmi
         RNNtxu0DlWJ+voFj2zV59ecQN7UXfIGdJz6l2QQg7hl1DF1htbBcFoFM/zAI2mPjcI1U
         l3fEHvv0/1gka708wHD2qXwLZrc051+nm/YjhW0tIhCa72L/Tien3Zer+cqAIsJMVqNK
         L0WPnYRQdIixCyrAGbQRcVHhSuhtXWLR41Rx6IQOFrIz+x0hmONqrQ/gZtqcXxab8960
         yeuaFiFWFODRPxwK1POFLi1ZUqFHAQQefGlgCb9xVI6pv/BL6bFoNByecBEofA/OdSSY
         7nrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PzedmcWsRc3DhudY/wiWcVyq0AAagaASN0DGAs1EUfk=;
        b=aVmaVQsTCDqmPWRz8nvjnoKLlnRRnlWoDJNDEGykyzUtP/yChh2VZvSiRS0YG+cfAy
         d1bRjLmsIMpd6DlpZNQ1DkOIYsjTxXBBP6Z7HnRQUQbxKU2N32w/asy4HBwFOrybP6wE
         X2BB8XAfiZwtzUk9VSqXaKOTunGtPdcfspRg7dqFfJidEdfR8ZfCfD+0eb18tyBupIRr
         2jp0AKDYt7YedFKgDmW51B9jma4lE2fQW0lHZJGYntLwo2GmQM31X3vge8bf0bgM3qFk
         SZZ6ErnlScAGRqq3x6lfQaLidM2EL+bpLhX9gcagp0QJsmAiMcsS5Jx6o8uAioD4JR6i
         4vPQ==
X-Gm-Message-State: APjAAAULttjD0jF8yujh8VehuJPu+M+zsQmVSKdpQC0jRJU9mNsUALvv
        3aF4Wbs/Tr+pBy3TcXu4Arg=
X-Google-Smtp-Source: APXvYqzcJGczjYcDRUjZLltV4/L8von3YErmNZFFERlXjz5jyiPEJ/PtKIEf2ACHSo4AM9+ctzEY3w==
X-Received: by 2002:a17:906:c2c9:: with SMTP id ch9mr2839424ejb.167.1564586028666;
        Wed, 31 Jul 2019 08:13:48 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id a18sm9661518ejp.2.2019.07.31.08.13.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:13:47 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id BF3F9103FDC; Wed, 31 Jul 2019 18:08:16 +0300 (+03)
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
Subject: [PATCHv2 30/59] keys/mktme: Program MKTME keys into the platform hardware
Date:   Wed, 31 Jul 2019 18:07:44 +0300
Message-Id: <20190731150813.26289-31-kirill.shutemov@linux.intel.com>
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

Finally, the keys are programmed into the hardware via each
lead CPU. Every package has to be programmed successfully.
There is no partial success allowed here.

Here a retry scheme is included for two errors that may succeed
on retry: MKTME_DEVICE_BUSY and MKTME_ENTROPY_ERROR.
However, it's not clear if even those errors should be retried
at this level. Perhaps they too, should be returned to user space
for handling.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 security/keys/mktme_keys.c | 92 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 91 insertions(+), 1 deletion(-)

diff --git a/security/keys/mktme_keys.c b/security/keys/mktme_keys.c
index 272bff8591b7..3c641f3ee794 100644
--- a/security/keys/mktme_keys.c
+++ b/security/keys/mktme_keys.c
@@ -83,6 +83,96 @@ static const match_table_t mktme_token = {
 	{OPT_ERROR, NULL}
 };
 
+struct mktme_hw_program_info {
+	struct mktme_key_program *key_program;
+	int *status;
+};
+
+struct mktme_err_table {
+	const char *msg;
+	bool retry;
+};
+
+static const struct mktme_err_table mktme_error[] = {
+/* MKTME_PROG_SUCCESS     */ {"KeyID was successfully programmed",   false},
+/* MKTME_INVALID_PROG_CMD */ {"Invalid KeyID programming command",   false},
+/* MKTME_ENTROPY_ERROR    */ {"Insufficient entropy",		      true},
+/* MKTME_INVALID_KEYID    */ {"KeyID not valid",		     false},
+/* MKTME_INVALID_ENC_ALG  */ {"Invalid encryption algorithm chosen", false},
+/* MKTME_DEVICE_BUSY      */ {"Failure to access key table",	      true},
+};
+
+static int mktme_parse_program_status(int status[])
+{
+	int cpu, sum = 0;
+
+	/* Success: all CPU(s) programmed all key table(s) */
+	for_each_cpu(cpu, mktme_leadcpus)
+		sum += status[cpu];
+	if (!sum)
+		return MKTME_PROG_SUCCESS;
+
+	/* Invalid Parameters: log the error and return the error. */
+	for_each_cpu(cpu, mktme_leadcpus) {
+		switch (status[cpu]) {
+		case MKTME_INVALID_KEYID:
+		case MKTME_INVALID_PROG_CMD:
+		case MKTME_INVALID_ENC_ALG:
+			pr_err("mktme: %s\n", mktme_error[status[cpu]].msg);
+			return status[cpu];
+
+		default:
+			break;
+		}
+	}
+	/*
+	 * Device Busy or Insufficient Entropy: do not log the
+	 * error. These will be retried and if retries (time or
+	 * count runs out) caller will log the error.
+	 */
+	for_each_cpu(cpu, mktme_leadcpus) {
+		if (status[cpu] == MKTME_DEVICE_BUSY)
+			return status[cpu];
+	}
+	return MKTME_ENTROPY_ERROR;
+}
+
+/* Program a single key using one CPU. */
+static void mktme_do_program(void *hw_program_info)
+{
+	struct mktme_hw_program_info *info = hw_program_info;
+	int cpu;
+
+	cpu = smp_processor_id();
+	info->status[cpu] = mktme_key_program(info->key_program);
+}
+
+static int mktme_program_all_keytables(struct mktme_key_program *key_program)
+{
+	struct mktme_hw_program_info info;
+	int err, retries = 10; /* Maybe users should handle retries */
+
+	info.key_program = key_program;
+	info.status = kcalloc(num_possible_cpus(), sizeof(info.status[0]),
+			      GFP_KERNEL);
+
+	while (retries--) {
+		get_online_cpus();
+		on_each_cpu_mask(mktme_leadcpus, mktme_do_program,
+				 &info, 1);
+		put_online_cpus();
+
+		err = mktme_parse_program_status(info.status);
+		if (!err)			   /* Success */
+			return err;
+		else if (!mktme_error[err].retry)  /* Error no retry */
+			return -ENOKEY;
+	}
+	/* Ran out of retries */
+	pr_err("mktme: %s\n", mktme_error[err].msg);
+	return err;
+}
+
 /* Copy the payload to the HW programming structure and program this KeyID */
 static int mktme_program_keyid(int keyid, u32 payload)
 {
@@ -97,7 +187,7 @@ static int mktme_program_keyid(int keyid, u32 payload)
 	kprog->keyid = keyid;
 	kprog->keyid_ctrl = payload;
 
-	ret = MKTME_PROG_SUCCESS;	/* Future programming call */
+	ret = mktme_program_all_keytables(kprog);
 	kmem_cache_free(mktme_prog_cache, kprog);
 	return ret;
 }
-- 
2.21.0

