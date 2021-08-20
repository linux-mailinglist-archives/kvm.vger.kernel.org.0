Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7BD3F30BC
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbhHTQD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:03:59 -0400
Received: from mail-bn8nam08on2080.outbound.protection.outlook.com ([40.107.100.80]:12305
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229952AbhHTQCM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:02:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lsIZCD+/VQzzW8rwM6mXLoPVBKHNNLpNhX2yPumLw0HOo513y/irzDpHu/IH1TvMl8WeUt7wkxf2ntqOoabwlXy7n/hsa0D6uYky4yoSl379WUleVGV/gB6oIN1R2ueMhKudN2qIGl6XZXOzEqyo83US2UjLo8/fXdpM/qJWFo6r7BLVzWhdKAk7dyN5hKi5QNxnFGa/cw8VyEnFC9CVwDkklzJFCFUuJykuXptG90tJeSdQW4nZovkyR/piINXvO6Tse8neUPnUQ8CU89aYFWS4U1pfSPNKAmRlI13B3nyiLGBByieXhwohhEV6eNfgfEtxZhmVdYPAYqAXDYfHNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L79AFbhiQ6X5AVDBIlBu3i93dO9GaVj+jpDJ+sw1X8E=;
 b=HGGcH2tiPwTi5wouoaisUbGaxmoiKOCvQo1fIna7bzfFw/loBp/gp2xJ70G32MG5fgo5Ew9yiyCHNWgLQpnJd3CFxMJj/us191eocK5QKYPiWcd8gdXK2BxpanrffWsPXW8k38onfCDvgXF9nu2FpTJq8cdYQFhV9UUukZyd0p3++42U5GlhusktPxr8I3QW62lOT1GeBxcMB8MF9QO0chleY+P4VHKSkvLWHK8UKrBxWLAcF+ujXjaLPAMIteLQlTOtZvSlna2CwWwHMRd+ilc/qnuu+e4Z0/dhguxqNXl1aoRKqKPdaQWVoI/tFKiKRP5stxD0xqQmas+Y0HbDDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L79AFbhiQ6X5AVDBIlBu3i93dO9GaVj+jpDJ+sw1X8E=;
 b=WYcaEJmOiEHcJKmtO6zIEjuanib0m4pbaFwo6QUlQmZKdlC2xk31mrfrNv1pSqElm63+mQGoWx35HcIeLgBkVVWuHp2WzuJJAiRvUQGlSBrP2n+mqRdYji7eJIM1z/25LlomWiY2Sb892zGI6Rly7XRh5jhR+Q6Le43I6R/0AtQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:00:06 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:06 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Brijesh Singh <brijesh.singh@amd.com>, stable@kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH Part2 v5 10/45] crypto: ccp: shutdown SEV firmware on kexec
Date:   Fri, 20 Aug 2021 10:58:43 -0500
Message-Id: <20210820155918.7518-11-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7011ff5-dcaa-4f15-5553-08d963f3942c
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB43842697E467CB477C3BE2FBE5C19@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:586;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dmLKuSul7jRFTiltDfV3sUjM42pSiAoRlXXafnA0uejri1pmGhbQ69Sf/b8NF2CVi7hXP9e3zIiu0eTMBY1PWqhy1AtmT7huJSdejQpoWOC7Z8ktGrN47QE2i8xdsQQi4oFuV+0SM4dfygIOW4RL7huQMSL58jrcifpU8NUro9Lo+kKorFPs5tqNc+LweXsvBwsG4lu9Tq5lk4cFIholklCM1ec4rXYgwtaBxJd5Cl9OVM7bzV8iKxwNksug8HLnwUxmTB0p83mF/OXN3E/woHlGNsgFVCypjNUVqGlz5uPeGC+PLY7MNzcRtBDkdhOkyx1peRu6oAGDjH84AbSHQIWz/uSiTOVxqHQXlh8ekxdGWGEtUi3kLaPvZsazHfd7tFluVMD1T+qo/HVX+jTClm2pSk+HALHGj63AfWgSyVC0Kb6HMGDRrnBLkbGUcZRBLgwEMZo7hHXtZVCTfJDH75cQptQrjO1lSVB3ORkoTieAs/RePOgfEwN3a5+/DTrxmwJhGfg/K+DButwFMtOoaxtfRMZPGWESWTUg63eLR9N3EZrCsaQTRb+VvijJc2UathHDpF/XvKSneWlbAyhdePcbLLCk/Yswx9APE8qNPHCWePWNb5yNe92+nc31XSptUQXtDVfKFPXDSof6jMFPEm928BKEcuWNyg3H0OfOl32IA6E0aBWlhCc8GGG0/SfdOHNuY/xkVSSbltNPt1BcPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(5660300002)(6666004)(52116002)(66946007)(44832011)(36756003)(7416002)(66476007)(7406005)(6486002)(956004)(8936002)(316002)(2906002)(186003)(4326008)(478600001)(86362001)(26005)(54906003)(38100700002)(38350700002)(7696005)(1076003)(8676002)(83380400001)(2616005)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9ow0L+vVsnFP50AztoHFCMDxC4zLfK7jsmTxhKUJTIY80rl/vzVRxHOGzeMD?=
 =?us-ascii?Q?yZpIN5XEcqUDZamH7t0HBE3UhP/+dlF9IV50nz5+Lf53LtUT9db2TD6Gck3S?=
 =?us-ascii?Q?47reGo/2zbUk5B2HQw9ByoUfE5r76QpOZGYTXSUNI5USSIQxZ3nKtkDisqGW?=
 =?us-ascii?Q?rq70kRcXQOg5rQGi3XWTMeNI11zyRRqMSL/zENyD5bKDOzQcNKpz6Vpiyd9H?=
 =?us-ascii?Q?CAfbG35dUo4DdtmbwK5lTbh2TXEUhd1qtghdOMo4BGej0+OLfKT4ra396K7X?=
 =?us-ascii?Q?6GmN7klQUBMBy7oXfexo2BT+tAL65XMTNkranYTH9X5Zd6M6XdOg8fLhR7CZ?=
 =?us-ascii?Q?2fXXtyhNCywbXXOnEgTt9k47ksXY7Z0xk9iMoKXpGTKZAK9Epl38VOGplP64?=
 =?us-ascii?Q?/QwB6ZiFRfCCLH8tnUj+btRfzvvIUh8O8OtQuh2+Ej6OHMZ/sC/q147DXEnS?=
 =?us-ascii?Q?egRTUC3PnL+2/URBmdRoYvJWaUfK9NS+daxLm6XCWUVDf+66SA9xU+lzYRLs?=
 =?us-ascii?Q?04jhrtR9+gGNRV9HEl156TpQ2XVWy1bnxcHQ2DSvWj2903xcmHrzefeuGviy?=
 =?us-ascii?Q?/4Tyn4c+PK/YxLAXmMfgZTjVhgb++YgDbzN9AW6xn70ncOdMWVJYmueLW25i?=
 =?us-ascii?Q?TlJxnSY582Ku/W9nJR3BA6P6EIfYEht5tsfgqQD7rVTWAx2SFwukbLp16w/e?=
 =?us-ascii?Q?hiCAe7NzW80bFcfFqDKAtKFTg9Jfv11+v6hvMC/WDaypxeqxtam/btDqN96h?=
 =?us-ascii?Q?qB67l3nnJxSQx9Vhz/CSU12MAIZz9MnRMtCvzsCZ3g60o8rONfMua7nMfDSq?=
 =?us-ascii?Q?R+dB02xVPC2NYJi31f5WXBRWaxH9mUTbT/W4b9nGm1wCModaC+ANAmkUd1mP?=
 =?us-ascii?Q?9KFAcc1Vd08Y+zst/fMKBADZJ8eDTkiLrh+XFVabpu93Zp3y7w3rm5JdhsxR?=
 =?us-ascii?Q?8oAchOxtiZcvj4gGcvwAyGQUldERYdH4P9G1LjtLx8TxGoOBxQA+S7KDDP53?=
 =?us-ascii?Q?Z5pl12VdW3xa9JkDqpjapugmhKqv6WI9RhSS94DZ4hoVeCCY+HZ2T/9tqVF+?=
 =?us-ascii?Q?bd8YSK35NjCkm2P9HEHSTw9vaeqYX7DLBBGBJK1zDZH/eYcSN+fwVvGE/kaA?=
 =?us-ascii?Q?XgTvDZA850czZUBXpQJ4oFnPYtTPS5d9DrYLplsMcd8TKKA+nIZQ9ypQeHVI?=
 =?us-ascii?Q?FIxp8B/ueGvhNGgSPaR6o87nNHy5LWtCObI7hChdLX8tg7Tf7oM4ktRBm2N2?=
 =?us-ascii?Q?z94p+nJ6KaPo+ngxo/nwoEFDAjbE6H2I1DHcztAouZtl6y9aPk5w9ZyLjkvX?=
 =?us-ascii?Q?tX41+CEb5+qI1t4ErcmbwLL/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7011ff5-dcaa-4f15-5553-08d963f3942c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:06.6280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QrQFT4yYjht3O/V3VpGXYU3Ue0d8yTa9FZgqKn+trBLfsnxQ6uCP8VATAQbvIqYh94CPlDGsxafHOvU01RpDSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The commit 97f9ac3db6612 ("crypto: ccp - Add support for SEV-ES to the
PSP driver") added support to allocate Trusted Memory Region (TMR)
used during the SEV-ES firmware initialization. The TMR gets locked
during the firmware initialization and unlocked during the shutdown.
While the TMR is locked, access to it is disallowed.

Currently, the CCP driver does not shutdown the firmware during the
kexec reboot, leaving the TMR memory locked.

Register a callback to shutdown the SEV firmware on the kexec boot.

Fixes: 97f9ac3db6612 ("crypto: ccp - Add support for SEV-ES to the PSP driver")
Reported-by: Lucas Nussbaum <lucas.nussbaum@inria.fr>
Tested-by: Lucas Nussbaum <lucas.nussbaum@inria.fr>
Cc: <stable@kernel.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 49 +++++++++++++++++-------------------
 drivers/crypto/ccp/sp-pci.c  | 12 +++++++++
 2 files changed, 35 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 91808402e0bf..2ecb0e1f65d8 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -300,6 +300,9 @@ static int __sev_platform_shutdown_locked(int *error)
 	struct sev_device *sev = psp_master->sev_data;
 	int ret;
 
+	if (sev->state == SEV_STATE_UNINIT)
+		return 0;
+
 	ret = __sev_do_cmd_locked(SEV_CMD_SHUTDOWN, NULL, error);
 	if (ret)
 		return ret;
@@ -1019,6 +1022,20 @@ int sev_dev_init(struct psp_device *psp)
 	return ret;
 }
 
+static void sev_firmware_shutdown(struct sev_device *sev)
+{
+	sev_platform_shutdown(NULL);
+
+	if (sev_es_tmr) {
+		/* The TMR area was encrypted, flush it from the cache */
+		wbinvd_on_all_cpus();
+
+		free_pages((unsigned long)sev_es_tmr,
+			   get_order(SEV_ES_TMR_SIZE));
+		sev_es_tmr = NULL;
+	}
+}
+
 void sev_dev_destroy(struct psp_device *psp)
 {
 	struct sev_device *sev = psp->sev_data;
@@ -1026,6 +1043,8 @@ void sev_dev_destroy(struct psp_device *psp)
 	if (!sev)
 		return;
 
+	sev_firmware_shutdown(sev);
+
 	if (sev->misc)
 		kref_put(&misc_dev->refcount, sev_exit);
 
@@ -1056,21 +1075,6 @@ void sev_pci_init(void)
 	if (sev_get_api_version())
 		goto err;
 
-	/*
-	 * If platform is not in UNINIT state then firmware upgrade and/or
-	 * platform INIT command will fail. These command require UNINIT state.
-	 *
-	 * In a normal boot we should never run into case where the firmware
-	 * is not in UNINIT state on boot. But in case of kexec boot, a reboot
-	 * may not go through a typical shutdown sequence and may leave the
-	 * firmware in INIT or WORKING state.
-	 */
-
-	if (sev->state != SEV_STATE_UNINIT) {
-		sev_platform_shutdown(NULL);
-		sev->state = SEV_STATE_UNINIT;
-	}
-
 	if (sev_version_greater_or_equal(0, 15) &&
 	    sev_update_firmware(sev->dev) == 0)
 		sev_get_api_version();
@@ -1115,17 +1119,10 @@ void sev_pci_init(void)
 
 void sev_pci_exit(void)
 {
-	if (!psp_master->sev_data)
-		return;
-
-	sev_platform_shutdown(NULL);
+	struct sev_device *sev = psp_master->sev_data;
 
-	if (sev_es_tmr) {
-		/* The TMR area was encrypted, flush it from the cache */
-		wbinvd_on_all_cpus();
+	if (!sev)
+		return;
 
-		free_pages((unsigned long)sev_es_tmr,
-			   get_order(SEV_ES_TMR_SIZE));
-		sev_es_tmr = NULL;
-	}
+	sev_firmware_shutdown(sev);
 }
diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 6fb6ba35f89d..9bcc1884c06a 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -241,6 +241,17 @@ static int sp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return ret;
 }
 
+static void sp_pci_shutdown(struct pci_dev *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct sp_device *sp = dev_get_drvdata(dev);
+
+	if (!sp)
+		return;
+
+	sp_destroy(sp);
+}
+
 static void sp_pci_remove(struct pci_dev *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -371,6 +382,7 @@ static struct pci_driver sp_pci_driver = {
 	.id_table = sp_pci_table,
 	.probe = sp_pci_probe,
 	.remove = sp_pci_remove,
+	.shutdown = sp_pci_shutdown,
 	.driver.pm = &sp_pci_pm_ops,
 };
 
-- 
2.17.1

