Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A70DA17C2C
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbfEHOos (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:44:48 -0400
Received: from mga07.intel.com ([134.134.136.100]:33085 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728305AbfEHOoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:45 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 08 May 2019 07:44:40 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 1BE06B26; Wed,  8 May 2019 17:44:30 +0300 (EEST)
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
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
Subject: [PATCH, RFC 29/62] keys/mktme: Program MKTME keys into the platform hardware
Date:   Wed,  8 May 2019 17:43:49 +0300
Message-Id: <20190508144422.13171-30-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
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
index b5b44decfd3e..f70533b1a7fd 100644
--- a/security/keys/mktme_keys.c
+++ b/security/keys/mktme_keys.c
@@ -102,6 +102,96 @@ struct mktme_payload {
 	u8		tweak_key[MKTME_AES_XTS_SIZE];
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
 static int mktme_program_keyid(int keyid, struct mktme_payload *payload)
 {
@@ -127,7 +217,7 @@ static int mktme_program_keyid(int keyid, struct mktme_payload *payload)
 			kprog->key_field_2[i] ^= kern_entropy[i];
 		}
 	}
-	ret = MKTME_PROG_SUCCESS;	/* Future programming call */
+	ret = mktme_program_all_keytables(kprog);
 	kmem_cache_free(mktme_prog_cache, kprog);
 	return ret;
 }
-- 
2.20.1

