Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66EA917C3B
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbfEHOta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:49:30 -0400
Received: from mga06.intel.com ([134.134.136.31]:57660 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728350AbfEHOor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:46 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga005.jf.intel.com with ESMTP; 08 May 2019 07:44:41 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 51199B86; Wed,  8 May 2019 17:44:30 +0300 (EEST)
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
Subject: [PATCH, RFC 33/62] acpi: Remove __init from acpi table parsing functions
Date:   Wed,  8 May 2019 17:43:53 +0300
Message-Id: <20190508144422.13171-34-kirill.shutemov@linux.intel.com>
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

ACPI table parsing functions are useful outside of init time.

For example, the MKTME (Multi-Key Total Memory Encryption) key
service will evaluate the ACPI HMAT table when the first key
creation request occurs.  This will happen after init time.

Additionally, the table parsing functions can be used when
_HMA objects are evaluated at runtime. The _HMA object provides
a completely new HMAT, overriding the existing table. The table
parsing functions will come in handy for those events.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 drivers/acpi/tables.c | 10 +++++-----
 include/linux/acpi.h  |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
index 3d0da38f94c6..35646b0fa7eb 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -47,7 +47,7 @@ static char *mps_inti_flags_trigger[] = { "dfl", "edge", "res", "level" };
 
 static struct acpi_table_desc initial_tables[ACPI_MAX_TABLES] __initdata;
 
-static int acpi_apic_instance __initdata;
+static int acpi_apic_instance;
 
 enum acpi_subtable_type {
 	ACPI_SUBTABLE_COMMON,
@@ -63,7 +63,7 @@ struct acpi_subtable_entry {
  * Disable table checksum verification for the early stage due to the size
  * limitation of the current x86 early mapping implementation.
  */
-static bool acpi_verify_table_checksum __initdata = false;
+static bool acpi_verify_table_checksum = false;
 
 void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
 {
@@ -294,7 +294,7 @@ acpi_get_subtable_type(char *id)
  * On success returns sum of all matching entries for all proc handlers.
  * Otherwise, -ENODEV or -EINVAL is returned.
  */
-static int __init
+static int
 acpi_parse_entries_array(char *id, unsigned long table_size,
 		struct acpi_table_header *table_header,
 		struct acpi_subtable_proc *proc, int proc_num,
@@ -370,7 +370,7 @@ acpi_parse_entries_array(char *id, unsigned long table_size,
 	return errs ? -EINVAL : count;
 }
 
-int __init
+int
 acpi_table_parse_entries_array(char *id,
 			 unsigned long table_size,
 			 struct acpi_subtable_proc *proc, int proc_num,
@@ -402,7 +402,7 @@ acpi_table_parse_entries_array(char *id,
 	return count;
 }
 
-int __init
+int
 acpi_table_parse_entries(char *id,
 			unsigned long table_size,
 			int entry_id,
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 7c7515b0767e..75078fc9b6b3 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -240,11 +240,11 @@ int acpi_numa_init (void);
 
 int acpi_table_init (void);
 int acpi_table_parse(char *id, acpi_tbl_table_handler handler);
-int __init acpi_table_parse_entries(char *id, unsigned long table_size,
+int acpi_table_parse_entries(char *id, unsigned long table_size,
 			      int entry_id,
 			      acpi_tbl_entry_handler handler,
 			      unsigned int max_entries);
-int __init acpi_table_parse_entries_array(char *id, unsigned long table_size,
+int acpi_table_parse_entries_array(char *id, unsigned long table_size,
 			      struct acpi_subtable_proc *proc, int proc_num,
 			      unsigned int max_entries);
 int acpi_table_parse_madt(enum acpi_madt_type id,
-- 
2.20.1

