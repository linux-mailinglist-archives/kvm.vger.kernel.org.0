Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 249A917C1A
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbfEHOrs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:47:48 -0400
Received: from mga06.intel.com ([134.134.136.31]:57660 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728425AbfEHOov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:50 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga006.fm.intel.com with ESMTP; 08 May 2019 07:44:43 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 78815BD3; Wed,  8 May 2019 17:44:30 +0300 (EEST)
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
Subject: [PATCH, RFC 36/62] acpi/hmat: Evaluate topology presented in ACPI HMAT for MKTME
Date:   Wed,  8 May 2019 17:43:56 +0300
Message-Id: <20190508144422.13171-37-kirill.shutemov@linux.intel.com>
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

MKTME, Multi-Key Total Memory Encryption, is a feature on Intel
platforms. The ACPI HMAT table can be used to verify that the
platform topology is safe for the usage of MKTME.

The kernel must be capable of programming every memory controller
on the platform. This means that there must be a CPU online, in
the same proximity domain of each memory controller.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 drivers/acpi/hmat/hmat.c | 54 ++++++++++++++++++++++++++++++++++++++++
 include/linux/acpi.h     |  1 +
 2 files changed, 55 insertions(+)

diff --git a/drivers/acpi/hmat/hmat.c b/drivers/acpi/hmat/hmat.c
index 38e3341f569f..936a403c0694 100644
--- a/drivers/acpi/hmat/hmat.c
+++ b/drivers/acpi/hmat/hmat.c
@@ -677,3 +677,57 @@ bool acpi_hmat_present(void)
 	acpi_put_table(tbl);
 	return true;
 }
+
+static int mktme_parse_proximity_domains(union acpi_subtable_headers *header,
+					 const unsigned long end)
+{
+	struct acpi_hmat_proximity_domain *mar = (void *)header;
+	struct acpi_hmat_structure *hdr = (void *)header;
+
+	const struct cpumask *tmp_mask;
+
+	if (!hdr || hdr->type != ACPI_HMAT_TYPE_PROXIMITY)
+		return -EINVAL;
+
+	if (mar->header.length != sizeof(*mar)) {
+		pr_warn("MKTME: invalid header length in HMAT\n");
+		return -1;
+	}
+	/*
+	 * Require a valid processor proximity domain.
+	 * This will catch memory only physical packages with
+	 * no processor capable of programming the key table.
+	 */
+	if (!(mar->flags & ACPI_HMAT_PROCESSOR_PD_VALID)) {
+		pr_warn("MKTME: no valid processor proximity domain\n");
+		return -1;
+	}
+	/* Require an online CPU in the processor proximity domain. */
+	tmp_mask = cpumask_of_node(pxm_to_node(mar->processor_PD));
+	if (!cpumask_intersects(tmp_mask, cpu_online_mask)) {
+		pr_warn("MKTME: no online CPU in proximity domain\n");
+		return -1;
+	}
+	return 0;
+}
+
+/* Returns true if topology is safe for MKTME key creation */
+bool mktme_hmat_evaluate(void)
+{
+	struct acpi_table_header *tbl;
+	bool ret = true;
+	acpi_status status;
+
+	status = acpi_get_table(ACPI_SIG_HMAT, 0, &tbl);
+	if (ACPI_FAILURE(status))
+		return -EINVAL;
+
+	if (acpi_table_parse_entries(ACPI_SIG_HMAT,
+				     sizeof(struct acpi_table_hmat),
+				     ACPI_HMAT_TYPE_PROXIMITY,
+				     mktme_parse_proximity_domains, 0) < 0) {
+		ret = false;
+	}
+	acpi_put_table(tbl);
+	return ret;
+}
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index fe3ad4ca5bb3..82b270dfb785 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -1341,6 +1341,7 @@ acpi_platform_notify(struct device *dev, enum kobject_action action)
 
 #ifdef CONFIG_X86_INTEL_MKTME
 extern bool acpi_hmat_present(void);
+extern bool mktme_hmat_evaluate(void);
 #endif /* CONFIG_X86_INTEL_MKTME */
 
 #endif	/*_LINUX_ACPI_H*/
-- 
2.20.1

