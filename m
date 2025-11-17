Return-Path: <kvm+bounces-63310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 10D1DC621BE
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 03:40:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7378835B89A
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 02:39:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C487261B75;
	Mon, 17 Nov 2025 02:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wd0cD6fg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02744248F72;
	Mon, 17 Nov 2025 02:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763347113; cv=none; b=fbKAlANVAL7yF2gYN3f8NqMuYR5JMpEhjoocFxUfMnOycYojGIm5Jcu4evv6X/I1P7ob7gg7FN7/hZ51IRlptbkr8ebRIJi0OkOU3ZuDbkMAyPbbQ/5C4zAGMIQMchEZlMFTBxAfO+DXhBDSMBKYciVw9R0Hcuvw4E+2YKaFo/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763347113; c=relaxed/simple;
	bh=cUVzmdp7s5O7Kq9OFELb7WFkBEJDxI8/T6XQV9RLD4c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PuPPPk8Wq0ddj1YK86J+aZSKFqMj7NHIl3f7fWb5Qpe/NJM1NYU/gcz6abtTpil8IPeIsoPQvxzjWyh2grA8dvMQOqMTiMzds+DyPEfuIh7sVeCdSqdNSZo2OkcRxt9MdhjQPyopJoh4NyARGTVnGexDtNSMJ+l72lvABJG2RXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wd0cD6fg; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763347112; x=1794883112;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cUVzmdp7s5O7Kq9OFELb7WFkBEJDxI8/T6XQV9RLD4c=;
  b=Wd0cD6fggwKa49oelMHaycF6U0ZpVsCOc3NiCmusfOXfHIOz99lSuuHd
   5NWeFuxdSaj64S9jOGJKYBCCNVxFrjV65llbQDVwsJhPIJ7NBuDBJbjw/
   qOI05SKggdqKMC4WAjhB7HSiWCwr8V7g6DuX5iooGh2I5XBEGDUisE2aS
   aG2yMojY8fbnLf1BxuFIJy599Mkx8gDqjyvaTio78eYSduGjCrM1Uxy2x
   FxxKnZGkl/gev3L66R1elBd4a+kaz/7uj9ZwUoGWNgc/X/D9eDBFT1Agp
   who9giRLnCUYNMp9yfJ6cUJrQqiWGRXUxNvJ2/n3WNMH4layALA0XFezA
   Q==;
X-CSE-ConnectionGUID: x4a3n/BqQlqr+t8X1lwoPQ==
X-CSE-MsgGUID: 1jbBzMUHSEavcBdpHlfqDA==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="82729535"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="82729535"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 18:38:32 -0800
X-CSE-ConnectionGUID: I5nQK0CFRAWL4GPhBp5yjg==
X-CSE-MsgGUID: xqBqPQ+QSSiwS/2cZMwSbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="227658265"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 16 Nov 2025 18:38:28 -0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: linux-coco@lists.linux.dev,
	linux-pci@vger.kernel.org
Cc: chao.gao@intel.com,
	dave.jiang@intel.com,
	baolu.lu@linux.intel.com,
	yilun.xu@linux.intel.com,
	yilun.xu@intel.com,
	zhenzhong.duan@intel.com,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	dan.j.williams@intel.com,
	kas@kernel.org,
	x86@kernel.org
Subject: [PATCH v1 10/26] acpi: Add KEYP support to fw_table parsing
Date: Mon, 17 Nov 2025 10:22:54 +0800
Message-Id: <20251117022311.2443900-11-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Jiang <dave.jiang@intel.com>

KEYP ACPI table can be parsed using the common fw_table handlers. Add
additional support to detect and parse the table.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Co-developed-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/acpi.h     |  3 +++
 include/linux/fw_table.h |  1 +
 drivers/acpi/tables.c    | 12 +++++++++++-
 lib/fw_table.c           |  9 +++++++++
 4 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 5ff5d99f6ead..3bfcd9c5d4e4 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -234,6 +234,9 @@ int acpi_table_parse_madt(enum acpi_madt_type id,
 int __init_or_acpilib
 acpi_table_parse_cedt(enum acpi_cedt_type id,
 		      acpi_tbl_entry_handler_arg handler_arg, void *arg);
+int __init_or_acpilib
+acpi_table_parse_keyp(enum acpi_keyp_type id,
+		      acpi_tbl_entry_handler_arg handler_arg, void *arg);
 
 int acpi_parse_mcfg (struct acpi_table_header *header);
 void acpi_table_print_madt_entry (struct acpi_subtable_header *madt);
diff --git a/include/linux/fw_table.h b/include/linux/fw_table.h
index 9bd605b87c4c..293252cb0b7e 100644
--- a/include/linux/fw_table.h
+++ b/include/linux/fw_table.h
@@ -36,6 +36,7 @@ union acpi_subtable_headers {
 	struct acpi_prmt_module_header prmt;
 	struct acpi_cedt_header cedt;
 	struct acpi_cdat_header cdat;
+	struct acpi_keyp_common_header keyp;
 };
 
 int acpi_parse_entries_array(char *id, unsigned long table_size,
diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
index 57fc8bc56166..4162386d9672 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -299,6 +299,16 @@ acpi_table_parse_cedt(enum acpi_cedt_type id,
 }
 EXPORT_SYMBOL_ACPI_LIB(acpi_table_parse_cedt);
 
+int __init_or_acpilib
+acpi_table_parse_keyp(enum acpi_keyp_type id,
+		      acpi_tbl_entry_handler_arg handler_arg, void *arg)
+{
+	return __acpi_table_parse_entries(ACPI_SIG_KEYP,
+					  sizeof(struct acpi_table_keyp), id,
+					  NULL, handler_arg, arg, 0);
+}
+EXPORT_SYMBOL_ACPI_LIB(acpi_table_parse_keyp);
+
 int __init acpi_table_parse_entries(char *id, unsigned long table_size,
 				    int entry_id,
 				    acpi_tbl_entry_handler handler,
@@ -408,7 +418,7 @@ static const char table_sigs[][ACPI_NAMESEG_SIZE] __nonstring_array __initconst
 	ACPI_SIG_PSDT, ACPI_SIG_RSDT, ACPI_SIG_XSDT, ACPI_SIG_SSDT,
 	ACPI_SIG_IORT, ACPI_SIG_NFIT, ACPI_SIG_HMAT, ACPI_SIG_PPTT,
 	ACPI_SIG_NHLT, ACPI_SIG_AEST, ACPI_SIG_CEDT, ACPI_SIG_AGDI,
-	ACPI_SIG_NBFT, ACPI_SIG_SWFT};
+	ACPI_SIG_NBFT, ACPI_SIG_SWFT, ACPI_SIG_KEYP};
 
 #define ACPI_HEADER_SIZE sizeof(struct acpi_table_header)
 
diff --git a/lib/fw_table.c b/lib/fw_table.c
index 16291814450e..147e3895e94c 100644
--- a/lib/fw_table.c
+++ b/lib/fw_table.c
@@ -20,6 +20,7 @@ enum acpi_subtable_type {
 	ACPI_SUBTABLE_PRMT,
 	ACPI_SUBTABLE_CEDT,
 	CDAT_SUBTABLE,
+	ACPI_SUBTABLE_KEYP,
 };
 
 struct acpi_subtable_entry {
@@ -41,6 +42,8 @@ acpi_get_entry_type(struct acpi_subtable_entry *entry)
 		return entry->hdr->cedt.type;
 	case CDAT_SUBTABLE:
 		return entry->hdr->cdat.type;
+	case ACPI_SUBTABLE_KEYP:
+		return entry->hdr->keyp.type;
 	}
 	return 0;
 }
@@ -61,6 +64,8 @@ acpi_get_entry_length(struct acpi_subtable_entry *entry)
 		__le16 length = (__force __le16)entry->hdr->cdat.length;
 
 		return le16_to_cpu(length);
+	case ACPI_SUBTABLE_KEYP:
+		return entry->hdr->keyp.length;
 	}
 	}
 	return 0;
@@ -80,6 +85,8 @@ acpi_get_subtable_header_length(struct acpi_subtable_entry *entry)
 		return sizeof(entry->hdr->cedt);
 	case CDAT_SUBTABLE:
 		return sizeof(entry->hdr->cdat);
+	case ACPI_SUBTABLE_KEYP:
+		return sizeof(entry->hdr->keyp);
 	}
 	return 0;
 }
@@ -95,6 +102,8 @@ acpi_get_subtable_type(char *id)
 		return ACPI_SUBTABLE_CEDT;
 	if (strncmp(id, ACPI_SIG_CDAT, 4) == 0)
 		return CDAT_SUBTABLE;
+	if (strncmp(id, ACPI_SIG_KEYP, 4) == 0)
+		return ACPI_SUBTABLE_KEYP;
 	return ACPI_SUBTABLE_COMMON;
 }
 
-- 
2.25.1


