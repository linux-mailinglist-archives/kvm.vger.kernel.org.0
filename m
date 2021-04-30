Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56EC036FA01
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbhD3MTa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:19:30 -0400
Received: from mail-dm6nam10on2049.outbound.protection.outlook.com ([40.107.93.49]:15328
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232273AbhD3MSv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:18:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L17xyPNCvlN+ocaeSmriYwikV1OCZoXkXAN/g+aE3XYyW9R/5EtdXxHd2PScj4Pxz+QozHq2QLr+STLkR362b/kJP6yzd/O+RMKCCX/m93DmvIpx+egZZN8CoFGNjcHaHfs/qJCPCogzsC0T+PXY/2/iBgtXp2OfcQApTUVeM0wtx3a5xamrCwTJYaaXtvuwiTMf5+Mo9JsW1D7OBDlrZvZ1M9B/cMwUZg+jB7hoBDTHw1NlbpUt6nkZYpyy47XryLPaqhV/2KWrAuOpfHorVSJFX5AimYsYFWwkGv7ByjecJCCL33giNYSCHz4Dw6OyBNUKJ0Kd1r9QJoYFcaasig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D3y8np/vyihgst/wIPhlYTev8KJYmFQJS/5Dlv+0OwQ=;
 b=V0oS9CqV1Iqq91o7ty1gzFAIZEcV81AzIjDXf/L6/XSzftbUO3bWbZ+c068AA6Qqcyl2TAiCRlcD77WAkZRKdYwlweHVqGaKDH3UIT7xUwSBxuvlM5cPlFpjskBkywXPP8580YRnRDaClWm/F+zfddTr7SY10sS+Npb3mEQQpH6KclUsUsNGtT1/mVVWULqG+aGe6KNV1P22zNlzgVWjOxMlzPZb7FhqQf9+OdHF72HBN8cVX41H+Ny4dEfRFEZQbmLag1wrm1Rvz9wKdxT6aUMzOB8CWWoy36UCnaCXcjAL2QKMyRBqBRWK/zYbE8s7dNz/5RJkW/n12wpgBWN9Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D3y8np/vyihgst/wIPhlYTev8KJYmFQJS/5Dlv+0OwQ=;
 b=lUgJk/QiwbwXMIKcjBQM8Nbhu6lhx33eP8uvUfI/dap8CrrOIJdwy3f2kAX14FNyUhA0gV/BVf+AY/LuDSWpPRX0BOAYsMutBnEq2Yyt9uSzlRY04a/c7rSowSSl7gsqiNZ6NKGod49ToiUUO+jYSkeqg1dSKnPGUEj9tDTGOe8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2640.namprd12.prod.outlook.com (2603:10b6:805:6c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 30 Apr
 2021 12:17:04 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:17:04 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part1 RFC v2 19/20] x86/sev: Register SNP guest request platform device
Date:   Fri, 30 Apr 2021 07:16:15 -0500
Message-Id: <20210430121616.2295-20-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430121616.2295-1-brijesh.singh@amd.com>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0021.namprd04.prod.outlook.com
 (2603:10b6:803:21::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0401CA0021.namprd04.prod.outlook.com (2603:10b6:803:21::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 12:17:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 826b8dce-d1b9-41ea-7780-08d90bd1dbaa
X-MS-TrafficTypeDiagnostic: SN6PR12MB2640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB264039A3C1003E0EECD4D241E55E9@SN6PR12MB2640.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D/QcrCP1qVdV99NkDEjqaApYmATjLxO6/PKjp1RFvcBprPwugR6IyHGe1g8FaBmyFvE2lC6ilL01yZ6LODu/fI9TyEzPsmAPCfM9eLtWp5TEiVYUE4J5m/MtiFrXICOR6iLge/VsFyGB0k6mi/JTXIcM7sWw1V1ZHL9AFxwRjpRxXfeAE8E1gckbSrNg5uaophfzn+TyVNVgc5y3yQTnNb4gPjRfNri6XGT7SfOMGBHDBTMTq+gWbSBg4vYvpLjf7UZ17B3M10F8sa5GNHgfierFDq7seVVNHqXbpTY3+otrkuAQLxsq1xI8chgb04vh+t4V2lEoFtHTj/rdLgkkEyQiltjIM0ww1PYE6EbeXOKS4lj5v+YayTgzjIgkGMsRw8WWT01Exvawhhsnzcm6MMO7+cz/EZ93ZIz6ij3amNtpTNjwm3yKQcO5nk4hze5V14U2a7hCtv6fjI5qhmXBtLnqfpVN5rTGR/F/AQgO/Ie642pUmiVOEL9FHm4XP00aaLCmSdkJnCw24L/dgMZTF/qmYu7t+TXJq1nacf64Eb3AgwUVs7fBHBfPOZlVJ2/nEa4fYRIYWgGZ6RDKEDGvZRSvoQhO3DwLl6q1dIA+UtU/6IIUmAxzEb4jgo6Nqsd3OjF1dPNP/0+1Qkcm3B5JjV2V7YoF61kUd+nhSbeBw/g6Qi3Vqk78ZqVyeL1zfvEebr2Cu+KCB5wHn/40BjOoTxad2rUfNO8d1DxDm+o7qbw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(6666004)(52116002)(966005)(7416002)(316002)(16526019)(2906002)(36756003)(186003)(26005)(38100700002)(38350700002)(66556008)(66946007)(5660300002)(1076003)(66476007)(4326008)(83380400001)(6486002)(86362001)(8936002)(956004)(44832011)(2616005)(8676002)(7696005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?fo0gzcYdb0xjeeyXNmBCV9EGoZgAGyafDU3zSTiTGtVp9/ZcHWEir4UDwPvr?=
 =?us-ascii?Q?+Pb/1emDKzhnJNVo6lzyGhVjlvRLoYo6fujWlfL7NdEA+vwFXAGloBY8Pmg2?=
 =?us-ascii?Q?VLBZZKrDjG6dJ43u4ncr0mvlA6TJNJucl3OY/wdQhsEVK47VcXV6jiZVrJIq?=
 =?us-ascii?Q?QBtvH8cOynMr95WE0GRWSMV21Nf/LKzYYPmLeaGL/JViu+an0vMqiouTSOwt?=
 =?us-ascii?Q?CBDuKRGh4fWH+/VopYchBwQezXG01E8xWWyZlB8fqyK39IncRIxrLfPHTzkh?=
 =?us-ascii?Q?+UC8RqFCb7QTDZ6d8kDk+IQs5E0Q+e7ZbrDyJlDb2BKl1z1Ri6aVpelgcEJq?=
 =?us-ascii?Q?y5bGtv+6pyzh1Cc6BRGIdmOBw61iGSb3wc1NjBdB1Rrz380+ip1NmwXFLndo?=
 =?us-ascii?Q?6uhtJPDqJ3U1oRZfz41ZDYRmnLa/GyFDaWHiVkyDKso9+Z14Xa0NJEfRfzMD?=
 =?us-ascii?Q?szRqwPy6Ujxg7ZcSXaHu8iZgkmdPB8usYh8W6sDWoMOvmxjgSoMRQDxUxG23?=
 =?us-ascii?Q?Ub83DgogrC0VVR7UVIcyZ7rAiq18VHf0bIJSF0ZrnjkSjzOeqSPtNIr8965s?=
 =?us-ascii?Q?OHRz9gWCZ5+bqwh4jI68asO2NrgEk/0hKbHjnOfkVzo1Yzfy4v+sug6M4lou?=
 =?us-ascii?Q?hSa/u/b9II6ezKB0df6595cIg8YeC86+A6sCzslbxSmorCm7ItMkieZkmN6I?=
 =?us-ascii?Q?nHabgV4oPZssAoDQsLJZNPwbIuNGSzuZmJEkpBVBF0H3BL+xzUfdya/W/CRu?=
 =?us-ascii?Q?mjbFecXsRL4vdbWvwfvkAscMfdmXr8NEPSYYZlBT9riMKJ4GteoPy/nJfww+?=
 =?us-ascii?Q?FDFZsDAOPqEmH2CeFhx4kz7PwKNE+6OpZSzBbfpYeDvBjpecreoy3BlNdxs1?=
 =?us-ascii?Q?7cSRn22xF0gl9WgSt2sCRJmBW2ExJTaxP2Kw6jMC5xSJ6pVTv6gA2GyC+59+?=
 =?us-ascii?Q?uNC2z3e5LOxLil/yXfTSKMBCXa84uwPLi3vMw+SstoCNwAenH0pLMiL3UOsl?=
 =?us-ascii?Q?SN6hxggYCuxcS+Sj0djXoMnDXTD73Lgvw+GucS75skvOhmJ97xKBHWbABraj?=
 =?us-ascii?Q?vv0VarGif7hnNvzL7Bxpx7FjgC5wacymyyoFw/lloirELGVwnkz0wNNb/o9/?=
 =?us-ascii?Q?WOieoov+7ZqDkd2D8YXnZxEKpP5D4IE5hU3Z6FQuuosTO5lCn46TJrG6IT5I?=
 =?us-ascii?Q?HgUwDl56PBWJ8tjdWGG1WOTRAaQss7/i+gVqggrWXdySNB8G+T4B3MRbjG69?=
 =?us-ascii?Q?UmL+qakrDLHeO449LyjiQSeSHZDL1OuDWKd+ZjhtxguqtvPfhzoem2NbTGov?=
 =?us-ascii?Q?WpInJXvC/5Um2K3DpsvxpZ9x?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 826b8dce-d1b9-41ea-7780-08d90bd1dbaa
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:17:01.2447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Io6znElcLdLcYr69IcqO0FDIjtQRwh5FRBIvv91fyuPYFGvNMZs2ZXtL91cIBrp94DIuY/Yi8jVGbprb/Eb6yQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2640
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Version 2 of GHCB specification provides NAEs that can be used by the SNP
guest to communicate with the PSP without risk from a malicious hypervisor
who wishes to read, alter, drop or replay the messages sent.

The hypervisor uses the SNP_GUEST_REQUEST command interface provided by
the SEV-SNP firmware to forward the guest messages to the PSP.

In order to communicate with the PSP, the guest need to locate the secrets
page inserted by the hypervisor during the SEV-SNP guest launch. The
secrets page contains the communication keys used to send and receive the
encrypted messages between the guest and the PSP.

The secrets page is located either through the setup_data cc_blob_address
or EFI configuration table.

Create a platform device that the SNP guest driver will bind to get the
platform resources. The SNP guest driver will provide interface to get
the attestation report, key derivation etc.

See SEV-SNP and GHCB spec for more details.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kernel/sev.c       | 124 ++++++++++++++++++++++++++++++++++++
 arch/x86/platform/efi/efi.c |   2 +
 include/linux/efi.h         |   1 +
 include/linux/snp-guest.h   | 124 ++++++++++++++++++++++++++++++++++++
 4 files changed, 251 insertions(+)
 create mode 100644 include/linux/snp-guest.h

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index f28fd8605e63..6fd1f82f473a 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -9,6 +9,7 @@
 
 #define pr_fmt(fmt)	"SEV-ES: " fmt
 
+#include <linux/platform_device.h>
 #include <linux/sched/debug.h>	/* For show_regs() */
 #include <linux/percpu-defs.h>
 #include <linux/mem_encrypt.h>
@@ -16,9 +17,12 @@
 #include <linux/printk.h>
 #include <linux/mm_types.h>
 #include <linux/set_memory.h>
+#include <linux/snp-guest.h>
 #include <linux/memblock.h>
 #include <linux/kernel.h>
+#include <linux/efi.h>
 #include <linux/mm.h>
+#include <linux/io.h>
 
 #include <asm/cpu_entry_area.h>
 #include <asm/stacktrace.h>
@@ -31,6 +35,7 @@
 #include <asm/svm.h>
 #include <asm/smp.h>
 #include <asm/cpu.h>
+#include <asm/setup.h>		/* For struct boot_params */
 
 #define DR7_RESET_VALUE        0x400
 
@@ -101,6 +106,21 @@ struct ghcb_state {
 	struct ghcb *ghcb;
 };
 
+/* Confidential computing blob information */
+#define CC_BLOB_SEV_HDR_MAGIC	0x414d4445
+struct cc_blob_sev_info {
+	u32 magic;
+	u16 version;
+	u64 secrets_phys;
+	u32 secrets_len;
+	u64 cpuid_phys;
+	u32 cpuid_len;
+};
+
+#ifdef CONFIG_EFI
+extern unsigned long cc_blob_phys;
+#endif
+
 static DEFINE_PER_CPU(struct sev_es_runtime_data*, runtime_data);
 DEFINE_STATIC_KEY_FALSE(sev_es_enable_key);
 
@@ -1685,3 +1705,107 @@ bool __init handle_vc_boot_ghcb(struct pt_regs *regs)
 	while (true)
 		halt();
 }
+
+static struct resource guest_req_res[0];
+static struct platform_device guest_req_device = {
+	.name		= "snp-guest",
+	.id		= -1,
+	.resource	= guest_req_res,
+	.num_resources	= 1,
+};
+
+static int get_snp_secrets_resource(struct resource *res)
+{
+	struct setup_header *hdr = &boot_params.hdr;
+	struct cc_blob_sev_info *info;
+	unsigned long paddr;
+	int ret = -ENODEV;
+
+	/*
+	 * The secret page contains the VM encryption key used for encrypting the
+	 * messages between the guest and the PSP. The secrets page location is
+	 * available either through the setup_data or EFI configuration table.
+	 */
+	if (hdr->cc_blob_address) {
+		paddr = hdr->cc_blob_address;
+	} else if (efi_enabled(EFI_CONFIG_TABLES)) {
+#ifdef CONFIG_EFI
+		paddr = cc_blob_phys;
+#else
+		return -ENODEV;
+#endif
+	} else {
+		return -ENODEV;
+	}
+
+	info = memremap(paddr, sizeof(*info), MEMREMAP_WB);
+	if (!info)
+		return -ENOMEM;
+
+	if (info->magic == CC_BLOB_SEV_HDR_MAGIC && info->secrets_phys && info->secrets_len) {
+		res->start = info->secrets_phys;
+		res->end = info->secrets_phys + info->secrets_len;
+		res->flags = IORESOURCE_MEM;
+		ret = 0;
+	}
+
+	memunmap(info);
+	return ret;
+}
+
+static int __init add_snp_guest_request(void)
+{
+	if (!sev_snp_active())
+		return -ENODEV;
+
+	if (get_snp_secrets_resource(&guest_req_res[0]))
+		return -ENODEV;
+
+	platform_device_register(&guest_req_device);
+	dev_info(&guest_req_device.dev, "registered [secret 0x%016llx - 0x%016llx]\n",
+		guest_req_res[0].start, guest_req_res[0].end);
+
+	return 0;
+}
+device_initcall(add_snp_guest_request);
+
+unsigned long snp_issue_guest_request(int type, struct snp_guest_request_data *input)
+{
+	struct ghcb_state state;
+	struct ghcb *ghcb;
+	unsigned long id;
+	int ret;
+
+	if (type == SNP_GUEST_REQUEST)
+		id = SVM_VMGEXIT_SNP_GUEST_REQUEST;
+	else if (type == SNP_EXTENDED_GUEST_REQUEST)
+		id = SVM_VMGEXIT_SNP_EXT_GUEST_REQUEST;
+	else
+		return -EINVAL;
+
+	if (!sev_snp_active())
+		return -ENODEV;
+
+	ghcb = sev_es_get_ghcb(&state);
+	if (!ghcb)
+		return -ENODEV;
+
+	vc_ghcb_invalidate(ghcb);
+	ghcb_set_rax(ghcb, input->data_gpa);
+	ghcb_set_rbx(ghcb, input->data_npages);
+
+	ret = sev_es_ghcb_hv_call(ghcb, NULL, id, input->req_gpa, input->resp_gpa);
+
+	if (ret)
+		goto e_put;
+
+	if (ghcb->save.sw_exit_info_2) {
+		ret = ghcb->save.sw_exit_info_2;
+		goto e_put;
+	}
+
+e_put:
+	sev_es_put_ghcb(&state);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(snp_issue_guest_request);
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 8a26e705cb06..2cca9ee6e1d4 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -57,6 +57,7 @@ static unsigned long efi_systab_phys __initdata;
 static unsigned long prop_phys = EFI_INVALID_TABLE_ADDR;
 static unsigned long uga_phys = EFI_INVALID_TABLE_ADDR;
 static unsigned long efi_runtime, efi_nr_tables;
+unsigned long cc_blob_phys;
 
 unsigned long efi_fw_vendor, efi_config_table;
 
@@ -66,6 +67,7 @@ static const efi_config_table_type_t arch_tables[] __initconst = {
 #ifdef CONFIG_X86_UV
 	{UV_SYSTEM_TABLE_GUID,		&uv_systab_phys,	"UVsystab"	},
 #endif
+	{EFI_CC_BLOB_GUID,		&cc_blob_phys,		"CC blob"	},
 	{},
 };
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 6b5d36babfcc..75aeb2a56888 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -344,6 +344,7 @@ void efi_native_runtime_setup(void);
 #define EFI_CERT_SHA256_GUID			EFI_GUID(0xc1c41626, 0x504c, 0x4092, 0xac, 0xa9, 0x41, 0xf9, 0x36, 0x93, 0x43, 0x28)
 #define EFI_CERT_X509_GUID			EFI_GUID(0xa5c059a1, 0x94e4, 0x4aa7, 0x87, 0xb5, 0xab, 0x15, 0x5c, 0x2b, 0xf0, 0x72)
 #define EFI_CERT_X509_SHA256_GUID		EFI_GUID(0x3bd2a492, 0x96c0, 0x4079, 0xb4, 0x20, 0xfc, 0xf9, 0x8e, 0xf1, 0x03, 0xed)
+#define EFI_CC_BLOB_GUID			EFI_GUID(0x067b1f5f, 0xcf26, 0x44c5, 0x85, 0x54, 0x93, 0xd7, 0x77, 0x91, 0x2d, 0x42)
 
 /*
  * This GUID is used to pass to the kernel proper the struct screen_info
diff --git a/include/linux/snp-guest.h b/include/linux/snp-guest.h
new file mode 100644
index 000000000000..32f70605b52c
--- /dev/null
+++ b/include/linux/snp-guest.h
@@ -0,0 +1,124 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * AMD Secure Encrypted Virtualization (SEV) driver interface
+ *
+ * Copyright (C) 2021 Advanced Micro Devices, Inc.
+ *
+ * Author: Brijesh Singh <brijesh.singh@amd.com>
+ *
+ * SEV API spec is available at https://developer.amd.com/sev
+ */
+
+#ifndef __LINUX_SNP_GUEST_H_
+#define __LINUX_SNP_GUEST_H_
+
+#include <linux/types.h>
+
+#define MAX_AUTHTAG_LEN		32
+#define VMPCK_KEY_LEN		32
+
+/*
+ * The secrets page contains 96-bytes of reserved field that can be used by
+ * the guest OS. The guest OS uses the area to save the message sequence
+ * number for each VMPL level.
+ */
+struct secrets_guest_priv {
+	u64 msg_seqno_0;
+	u64 msg_seqno_1;
+	u64 msg_seqno_2;
+	u64 msg_seqno_3;
+	u8 rsvd[64];
+} __packed;
+
+/* See the SNP spec secrets page layout section for the structure */
+struct snp_data_secrets_layout {
+	u32 version;
+	u32 imiEn:1;
+	u32 rsvd1:31;
+	u32 fms;
+	u32 rsvd2;
+	u8 gosvw[16];
+	u8 vmpck0[VMPCK_KEY_LEN];
+	u8 vmpck1[VMPCK_KEY_LEN];
+	u8 vmpck2[VMPCK_KEY_LEN];
+	u8 vmpck3[VMPCK_KEY_LEN];
+	struct secrets_guest_priv guest_priv;
+	u8 rsvd3[3840];
+} __packed;
+
+/* See SNP spec SNP_GUEST_REQUEST section for the structure */
+enum msg_type {
+	SNP_MSG_TYPE_INVALID = 0,
+	SNP_MSG_CPUID_REQ,
+	SNP_MSG_CPUID_RSP,
+	SNP_MSG_KEY_REQ,
+	SNP_MSG_KEY_RSP,
+	SNP_MSG_REPORT_REQ,
+	SNP_MSG_REPORT_RSP,
+	SNP_MSG_EXPORT_REQ,
+	SNP_MSG_EXPORT_RSP,
+	SNP_MSG_IMPORT_REQ,
+	SNP_MSG_IMPORT_RSP,
+	SNP_MSG_ABSORB_REQ,
+	SNP_MSG_ABSORB_RSP,
+	SNP_MSG_VMRK_REQ,
+	SNP_MSG_VMRK_RSP,
+
+	SNP_MSG_TYPE_MAX
+};
+
+enum aead_algo {
+	SNP_AEAD_INVALID,
+	SNP_AEAD_AES_256_GCM,
+};
+
+struct snp_guest_msg_hdr {
+	u8 authtag[MAX_AUTHTAG_LEN];
+	u64 msg_seqno;
+	u8 rsvd1[8];
+	u8 algo;
+	u8 hdr_version;
+	u16 hdr_sz;
+	u8 msg_type;
+	u8 msg_version;
+	u16 msg_sz;
+	u32 rsvd2;
+	u8 msg_vmpck;
+	u8 rsvd3[35];
+} __packed;
+
+struct snp_guest_msg {
+	struct snp_guest_msg_hdr hdr;
+	u8 payload[4000];
+} __packed;
+
+struct snp_msg_report_req {
+	u8 data[64];
+	u32 vmpl;
+	u8 rsvd[28];
+} __packed;
+
+enum vmgexit_type {
+	SNP_GUEST_REQUEST,
+	SNP_EXTENDED_GUEST_REQUEST,
+
+	GUEST_REQUEST_MAX
+};
+
+struct snp_guest_request_data {
+	unsigned long req_gpa;
+	unsigned long resp_gpa;
+	unsigned long data_gpa;
+	unsigned int data_npages;
+};
+
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+unsigned long snp_issue_guest_request(int vmgexit_type, struct snp_guest_request_data *input);
+#else
+
+static inline unsigned long snp_issue_guest_request(int type, struct snp_guest_request_data *input)
+{
+	return -ENODEV;
+}
+#endif /* CONFIG_AMD_MEM_ENCRYPT */
+#endif /* __LINUX_SNP_GUEST_H__ */
-- 
2.17.1

