Return-Path: <kvm+bounces-21837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A39E934D74
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 14:51:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D94C1C22701
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 12:51:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76C9F13C9CF;
	Thu, 18 Jul 2024 12:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MC+8vaS9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0333913AA26
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 12:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721307065; cv=fail; b=sKVqtp11rwEZXhO6iKSGhsyLXjgzW08nOzDu/Pcz2OpT219AHbNYVm2WUO29FAZS0zonky2kQRm0wUliNSC9hS5f1/gVS1gIf7WvTRnLiT7gNxl8AtoWbH5LnIn4ckCj1j3aFQmr+M842tiSCGNXbIFVoWs3FcC/Ys8WaH4Yv1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721307065; c=relaxed/simple;
	bh=O/hPqNPuzdE3hn1gtiG9ydZcQiw7SIMG9zTH4VEwm18=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jd1AeVbr5s+HqhpUPoj3fGniBmgkX0Fvj+JQsj4t+QTuIIvmQ5mKn4ubgU3MYAAgrgYTSDk5AucujNlbH1UCdgRwjACMeMo2SmrX71jRX6RZRO0MUgv4ZviPyFkH/2lOdeWhe8KHgZyFs3M18/qCRugKgRYdFVJ/G0pRFQIgiiQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MC+8vaS9; arc=fail smtp.client-ip=40.107.220.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ss/9zzLvYnWQ9lY+AseM79pCuYCuOq3e0pW+R5BjDbGVL+ccNzYmExKw5Ci8l4xOPR5ymg9606XpNRxhHWsnOlIeINwo5TmT+2Hi8oGasJmkv2PHHIi53VjSmR3dBG29oUSJYkaSrxASDrl5suPnkTsWXCo93IPW784LgXUdvH8YB9fVPDJu0lnKRCgfH/YfRTfuuGZpYPQ7BuHiRCmIaFFrBrALkfRXnkzFzzfaolM6ELNNkMmC0w7MooqApTnwpt/YDLsBBzyov1JizBm+eNK/W3xWDipqGSbPrIQqPspCBylfJ+dW5w1AFLJqdNRQO3V2BNvoq/drkp7mLVSqaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1s6RcU7yWa2V8E3iS/OPfVJLP/py0/GnvZfqRaUghCw=;
 b=TtSmaLPEVEHdRMQoWulEXmq99DEw7fGq/OCcnsSJHA7sbIhQPwcA53TTo7wLv4S546TtqVdes5/aL4hvW8/31umUGQRhoCZJSY0OPhZb3rTV2/kJgZvkETxIau8EWTvrbueb+fuKGAjBr/8qntwT09Jr3grDBThUaUA0+b3DX7kulrNmSv99zpAvBbvAxMlaIM35Ojs5Z+OsayGX8MpPCbxaKiSFZ2/KP6ShRn/iOHQ8lxuP5w6BppNImSrRY0hRraXTp7vEK/fg4ortDdtUji+QPm3EHjsDDNcfs8hRSNQMn8XTkqlpzgTl9Ot0Y5Q+nQZpYrUtU7W2ceWvScLF7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1s6RcU7yWa2V8E3iS/OPfVJLP/py0/GnvZfqRaUghCw=;
 b=MC+8vaS9PskJeQ2wh16RtXxpukSmorW2TTexyKp18T4K9CKpETTR10CeAlJBAl035DMjBahtwrjr45VdBV+4mwNo/i3xvijrCl8FjC9dcomQzewyzXyEcEMvoE8Alv7RCgflXGrZN5jvCUgj+eVkjK+pHm0Kw0MfQBPJDfa5Bmc=
Received: from CH0PR13CA0041.namprd13.prod.outlook.com (2603:10b6:610:b2::16)
 by DS0PR12MB7679.namprd12.prod.outlook.com (2603:10b6:8:134::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.14; Thu, 18 Jul
 2024 12:51:01 +0000
Received: from CH3PEPF00000018.namprd21.prod.outlook.com
 (2603:10b6:610:b2:cafe::a0) by CH0PR13CA0041.outlook.office365.com
 (2603:10b6:610:b2::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.18 via Frontend
 Transport; Thu, 18 Jul 2024 12:51:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000018.mail.protection.outlook.com (10.167.244.123) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.5 via Frontend Transport; Thu, 18 Jul 2024 12:51:01 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 18 Jul
 2024 07:50:59 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests PATCH v2 06/16] x86 AMD SEV-SNP: Add tests for presence of confidential computing blob
Date: Thu, 18 Jul 2024 07:49:22 -0500
Message-ID: <20240718124932.114121-7-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240718124932.114121-1-papaluri@amd.com>
References: <20240718124932.114121-1-papaluri@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000018:EE_|DS0PR12MB7679:EE_
X-MS-Office365-Filtering-Correlation-Id: c9d9067d-1ef0-405b-e35b-08dca728473e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/+azbJ1tRu/xI7hFuVJd36pET5sjJjWQ3rId0h2QyNz0zPGkpRjCXShk1VYR?=
 =?us-ascii?Q?dG82Vz6Tu0jBnbzCROrB8KJ8pcJymkuLySCUFMh2aUQgoicVre35k0B715D6?=
 =?us-ascii?Q?tg5HZb80IfrHCbn1yqdSNW8ODlhEU2NJUg2UQlphXycq5Yrd06F6YruV1sKc?=
 =?us-ascii?Q?FUQBekQJpvd6FNQyoQctdWWj2Ok8VMCYgu7jMKzN3ctrbqX3n60fYuEzgmKV?=
 =?us-ascii?Q?NhkTI6frScvSR35Q9ut2sf53Tv7Yv/77TeEs+y1ljouSF9VcsZT/ezUWu66l?=
 =?us-ascii?Q?a6nANfLlzt1PNx6N5D47FGlguJPfjR41TS8pZdE+qopctZaOeGkTMEpxqazm?=
 =?us-ascii?Q?NB/I4k56qYg+z5rFa15QaHHAlS/qjeUlv1+cnS/xGUaXvbry7Lf0ezlh6VEo?=
 =?us-ascii?Q?ufpyNXGicEXKOgVhU91vSYSF9DiH4CP37h14TdUJYld6lhHTMTUurQvKpouf?=
 =?us-ascii?Q?6OIIlWqR0ZKyLtfujvSeuqDK5+iOTtHmkdYP2FmeSLf0TSKPOLpnOrSXus9c?=
 =?us-ascii?Q?2NBZfv9cOtkiBvJ0pngoSI42wWHOrM0JWU2at111IDr/Bg+Q3ae0+TANf34r?=
 =?us-ascii?Q?iYktO4nbO/6A7CuSE9sscKGPL+Spsk3cXJvj3AbW7t2DuWTa4fGHP6qH6bzw?=
 =?us-ascii?Q?WFIa1LiuGv5mLgkxf2jQDy6chCKTt8WUrvt45LzaD/KRQ6pLIlx0iP7wJgQb?=
 =?us-ascii?Q?XWnYHchoXiW6JLB7lhnjCghsmhI6SX1FG2vFLLPrrK8QhucZD0ZNrS7c/Kn9?=
 =?us-ascii?Q?eoerI+3JIWF4Dehnn5Vy2KHqHbaHV4QJCa75FMntMUXXe4BtrmL3sVAsXh3K?=
 =?us-ascii?Q?k6FyaJhWakIGgk9Cy2S8NZSeMFPZQ68DlHTguU6yYLdDuL+Q54m9LpBDLz/u?=
 =?us-ascii?Q?3JBhCK9Ec66bZSNvwrMdmzH732+u19X6vBJb+yLFrZZjmcC3lTf8gGQ2zuOh?=
 =?us-ascii?Q?ER264fbqkXbl6CUEMJMtnFEFmDlghUk1s8bWl6k2njYOWI/YfZmSLUhbL+pp?=
 =?us-ascii?Q?XHhQ8Z9gYoWA4uytFeEjL74pBMDKsJHEZmZOzsXPPUjJSlatV2y0E/giQvWQ?=
 =?us-ascii?Q?C9fKIfg/jSyTz+kUv4SbZO2iNYK5tLSUuQnaq8POklnstFPrQy+BrimyNLEN?=
 =?us-ascii?Q?SsrPON2j8HfK9sJFY2HB+kTY06nye6chteMSYfyGXQISFTxmx+wrxJlNMCR4?=
 =?us-ascii?Q?/3NGfhQAzadBYf04lCuNUTqI7GBeFRDZXADEr1WV+sDVVxDOl5wy972BJ144?=
 =?us-ascii?Q?eZhnwlRrBfucUHAQQF9E6Qe4bkcY6m/ULhcrE5fVGCqzyfgHgWdBFR/Rtl9t?=
 =?us-ascii?Q?bxe1tqe+mCY8WMPcfTe3F0TaN/AHPzzYqADC1Mu/UbDHiTvoaZMgW0ozo485?=
 =?us-ascii?Q?bQXvITf+b2/zbTWj2JGoYWqpRbArd/PHhDfA9hbS6OpLETS7bg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 12:51:01.4820
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c9d9067d-1ef0-405b-e35b-08dca728473e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000018.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7679

Add support to enable search for confidential computing blob in the EFI
system configuration table for KVM-Unit-Tests.

The SEV-SNP Confidential Computing (CC) blob (GHCB spec, Table-5) contains
metadata that needs to remain accessible during the guest's lifetime.
The metadata contains information on SNP reserved pages such as pointers
to SNP secrets page and SNP CPUID table.

Having access to SNP CPUID table aids in providing CPUID #VC handler
support. Also, Determining the presence of SNP CC blob in KUT guest
verfies whether OVMF has properly provided the CC blob to the guest via
the system configuration table.

Put out a warning message in case the CC blob is not found.

Import the definitions of CC_BLOB_SEV_HDR_MAGIC and cc_blob_sev_info
structure from upstream linux (arch/x86/include/asm/sev.h).

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 lib/linux/efi.h   |  1 +
 lib/x86/amd_sev.h | 18 ++++++++++++++++++
 x86/amd_sev.c     | 30 ++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+)

diff --git a/lib/linux/efi.h b/lib/linux/efi.h
index 8fa23ad078ce..64323ff498f5 100644
--- a/lib/linux/efi.h
+++ b/lib/linux/efi.h
@@ -69,6 +69,7 @@ typedef guid_t efi_guid_t;
 #define DEVICE_TREE_GUID EFI_GUID(0xb1b621d5, 0xf19c, 0x41a5,  0x83, 0x0b, 0xd9, 0x15, 0x2c, 0x69, 0xaa, 0xe0)
 
 #define LOADED_IMAGE_PROTOCOL_GUID EFI_GUID(0x5b1b31a1, 0x9562, 0x11d2,  0x8e, 0x3f, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b)
+#define EFI_CC_BLOB_GUID EFI_GUID(0x067b1f5f, 0xcf26, 0x44c5, 0x85, 0x54, 0x93, 0xd7, 0x77, 0x91, 0x2d, 0x42)
 
 #define EFI_LOAD_FILE2_PROTOCOL_GUID EFI_GUID(0x4006c0c1, 0xfcb3, 0x403e,  0x99, 0x6d, 0x4a, 0x6c, 0x87, 0x24, 0xe0, 0x6d)
 #define LINUX_EFI_INITRD_MEDIA_GUID EFI_GUID(0x5568e427, 0x68fc, 0x4f3d,  0xac, 0x74, 0xca, 0x55, 0x52, 0x31, 0xcc, 0x68)
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index 4c58e761c4af..70f3763fe231 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -106,6 +106,24 @@ struct es_em_ctxt {
 	struct es_fault_info fi;
 };
 
+/*
+ * AMD SEV Confidential computing blob structure. The structure is
+ * defined in OVMF UEFI firmware header:
+ * https://github.com/tianocore/edk2/blob/master/OvmfPkg/Include/Guid/ConfidentialComputingSevSnpBlob.h
+ */
+#define CC_BLOB_SEV_HDR_MAGIC	0x45444d41
+struct cc_blob_sev_info {
+	u32 magic;
+	u16 version;
+	u16 reserved;
+	u64 secrets_phys;
+	u32 secrets_len;
+	u32 rsvd1;
+	u64 cpuid_phys;
+	u32 cpuid_len;
+	u32 rsvd2;
+} __packed;
+
 /*
  * AMD Programmer's Manual Volume 3
  *   - Section "Function 8000_0000h - Maximum Extended Function Number and Vendor String"
diff --git a/x86/amd_sev.c b/x86/amd_sev.c
index 3e6e9129cfaa..4c34a5965a1b 100644
--- a/x86/amd_sev.c
+++ b/x86/amd_sev.c
@@ -69,8 +69,35 @@ static void test_sev_es_activation(void)
 	}
 }
 
+/* Check to find if SEV-SNP's Confidential Computing Blob is present */
+static efi_status_t find_cc_blob_efi(void)
+{
+	struct cc_blob_sev_info *snp_cc_blob;
+	efi_status_t status;
+
+	status = efi_get_system_config_table(EFI_CC_BLOB_GUID,
+					     (void **)&snp_cc_blob);
+
+	if (status != EFI_SUCCESS)
+		return status;
+
+	if (!snp_cc_blob) {
+		printf("SEV-SNP CC blob not found\n");
+		return EFI_NOT_FOUND;
+	}
+
+	if (snp_cc_blob->magic != CC_BLOB_SEV_HDR_MAGIC) {
+		printf("SEV-SNP CC blob header/signature mismatch");
+		return EFI_UNSUPPORTED;
+	}
+
+	return EFI_SUCCESS;
+}
+
 static void test_sev_snp_activation(void)
 {
+	efi_status_t status;
+
 	report_info("TEST: SEV-SNP Activation test");
 
 	if (!(rdmsr(MSR_SEV_STATUS) & SEV_SNP_ENABLED_MASK)) {
@@ -79,6 +106,9 @@ static void test_sev_snp_activation(void)
 	}
 
 	report_info("SEV-SNP is enabled");
+
+	status = find_cc_blob_efi();
+	report(status == EFI_SUCCESS, "SEV-SNP CC-blob presence");
 }
 
 static void test_stringio(void)
-- 
2.34.1


