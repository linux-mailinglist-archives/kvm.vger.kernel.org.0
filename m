Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5151417C0B
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbfEHOou (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:44:50 -0400
Received: from mga07.intel.com ([134.134.136.100]:33088 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728352AbfEHOor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:46 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 08 May 2019 07:44:41 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 5EB75BC1; Wed,  8 May 2019 17:44:30 +0300 (EEST)
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
Subject: [PATCH, RFC 34/62] acpi/hmat: Determine existence of an ACPI HMAT
Date:   Wed,  8 May 2019 17:43:54 +0300
Message-Id: <20190508144422.13171-35-kirill.shutemov@linux.intel.com>
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

Platforms that need to confirm the presence of an HMAT table
can use this function that simply reports the HMATs existence.

This is added in support of the Multi-Key Total Memory Encryption
(MKTME), a feature on future Intel platforms. These platforms will
need to confirm an HMAT is present at init time.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 drivers/acpi/hmat/hmat.c | 13 +++++++++++++
 include/linux/acpi.h     |  4 ++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/acpi/hmat/hmat.c b/drivers/acpi/hmat/hmat.c
index 96b7d39a97c6..38e3341f569f 100644
--- a/drivers/acpi/hmat/hmat.c
+++ b/drivers/acpi/hmat/hmat.c
@@ -664,3 +664,16 @@ static __init int hmat_init(void)
 	return 0;
 }
 subsys_initcall(hmat_init);
+
+bool acpi_hmat_present(void)
+{
+	struct acpi_table_header *tbl;
+	acpi_status status;
+
+	status = acpi_get_table(ACPI_SIG_HMAT, 0, &tbl);
+	if (ACPI_FAILURE(status))
+		return false;
+
+	acpi_put_table(tbl);
+	return true;
+}
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 75078fc9b6b3..fe3ad4ca5bb3 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -1339,4 +1339,8 @@ acpi_platform_notify(struct device *dev, enum kobject_action action)
 }
 #endif
 
+#ifdef CONFIG_X86_INTEL_MKTME
+extern bool acpi_hmat_present(void);
+#endif /* CONFIG_X86_INTEL_MKTME */
+
 #endif	/*_LINUX_ACPI_H*/
-- 
2.20.1

