Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B737736F9ED
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbhD3MSL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:18:11 -0400
Received: from mail-dm6nam12on2089.outbound.protection.outlook.com ([40.107.243.89]:57920
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232302AbhD3MR5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:17:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ns/zAey+dms9wRqIN68H9mersQq44SUJ4+TMSXcrabQOezOlSQYUTGEfPkUeIFa55o06WMiKMCZEEYYU5UVQ6h7KtKnuY60dhiHeEeF4zcbHc9Z4kIoKgA2JcNyNUKqmDGAxF19ivITXUrNClpjzJjYasCF34jS4JbmVQ43BnHS613frqKLcJV6jmvLcPO9qE8H4xAFEJWe5KDueJiCYJxtMhg2Uc+NCjnOVhXMfa7E7a9cfj3WWzwkW60NnesGN52UAZyjJhNzvx+HP2/DBIyEscEUlY2ui3GY89K0t74u32PH87BXsFjzgR3sLAqXF2jxzjw7QY0oO0W4R+A8BVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T3/seJpLH8bUBap5nBKRnPVgl50Lw9RBaA3jY3pl18A=;
 b=QUEjC9d5osAx8MOJBkuew/Y5D0D/Ha9c+H/jZE/XGBK9BlhWsJhioKHsw/ZWCctdEJA5yxEyDdPJU32CnAZeBPlHbZCUT/OMq3W0R1pQkR/iu2ZNd0tD7dcoEFIXkCJsWsxnfitdVngOdop0auilCQ/tQGFu5stgLqOG9q4BJW5RJpKFTfVxXvSQpAlExrxgTDSNpP++vtgSct9gsWEk2s1JoJsv1WqVs17bkMl0rJELlRfWeUOwo1v2iie+pUll2Xd+u5ja9AD3gH+1BGDmMpLcY3uo81nHHqKFqyPNSlIOIW5ko+iSx4FpMTb0LY9zyvYML10jCqNUZKAg/1fJ6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T3/seJpLH8bUBap5nBKRnPVgl50Lw9RBaA3jY3pl18A=;
 b=RLr/Nc3twrhNcqInI0oYRrie8lOiOYcxqrxIaAx2dUebGGuyhOREiYXfHSge8yCxAu9BgYdkHn/Cv5Ai3eG4r/pa/gMn4Wp2zLs+jsrFkNXyDQmp+2mJihKw6fDmz0+cX1IGQdkrB60beJ5RNJUq3YJBuKFB0qXrckBPp35Ut9U=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4431.namprd12.prod.outlook.com (2603:10b6:806:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Fri, 30 Apr
 2021 12:16:59 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:16:58 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part1 RFC v2 09/20] x86/sev: check SEV-SNP features support
Date:   Fri, 30 Apr 2021 07:16:05 -0500
Message-Id: <20210430121616.2295-10-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0401CA0021.namprd04.prod.outlook.com (2603:10b6:803:21::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 12:16:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2cfa8eba-fba4-4483-3b95-08d90bd1d78c
X-MS-TrafficTypeDiagnostic: SA0PR12MB4431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44316507E7F6C49E217D240CE55E9@SA0PR12MB4431.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t2sG/ifTKUJ52DMtw2+bw4lg/E7rC0356M62TDJs2pmT0ZchB0FUouX0aVLIsrkFlX/v7vNaMIFxVTQFQfj1wYioGy/OeAgtOY9oPHosfgS3A+pDvFsdH/7ULQiYjL1u8Ww6xxbKRqyxUFQrV9rFcaTexVnkaqzjNk0qHPKfiozp+fv+JcFdcvUYBDdYgseSbhZEfPLikPUXq4aKUQzYm2054k02L9hYgaBRRbcA98LlKq9aKsbp9itxBCF5GvK4QI2HCS1I7B6xXD2Ng1WvHmiQu/c3+8TGo8NJwUI1RXVUblA+sRJePWSPpWfsJ4pKzh7iLVmUJCj412F5qN3Rei46sYTcOz/6NxXzjHrAPelXL8VGw5fPxMCdmi2O0r1uX9eB95btvxDJu8OHD86w3CaNWM86/FIJfCGdQAVpK/RDMyXjIRYiimCwCMJIwNEMpYMJotVFj73eqHHdMSirinFOl7PwbdSUwN95pPy9w4elVvPWxPEXxsVA8wUOSxQiPfjuvFqv2R5jujGxR6LhRn408OHq8K4f+xaBpP5DtsWn9GlwQBBlE57g8oqkPlEbVpkoMpLpdR8a1VRzy+xBFLXKgHXjvnjCQV3WZfuaFAcn7zM/3tmssHh3hU0Ja47h8KXqPr+uI6iZkblOSX+ZpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(6666004)(2906002)(38100700002)(8936002)(316002)(5660300002)(38350700002)(478600001)(1076003)(16526019)(26005)(7696005)(7416002)(186003)(8676002)(52116002)(4326008)(36756003)(956004)(6486002)(2616005)(66946007)(66476007)(66556008)(86362001)(83380400001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?O7P/6K0HW9z5bbhErFQMet3UkGJh/ew1l4QAx3GADqs3gFYY60Cm3zUkYfb8?=
 =?us-ascii?Q?lr6Kei+32dqiI4sqkgVafgxKEAOWXlN4yA26IKNXlEebCDtEAkr7/T7oXoux?=
 =?us-ascii?Q?rkezt9p4z3Xo0T0ZmgGcWhw2xSUWlLvpFuA950rPpb6jhOiL24Da0+vSQ+E/?=
 =?us-ascii?Q?JFV177L8h9xC0vEFntHiqeKACA/RS4mp+Xbon0DXQ00k8sDKPQrAlmOQ1vOY?=
 =?us-ascii?Q?vKnuKZ6IYOe9HXN0DeQ2YtiW44HvXzl/35bxGaRXq1M1VMmd4MIu102SfzEw?=
 =?us-ascii?Q?U+sNeV6q3ebMTrwgdWyucFz9v6lJ8j74luI1YK+bGoDwVHp6daZQFxA4aYHQ?=
 =?us-ascii?Q?BNefrXD4OEDZSiBnwLtNbhIEcgnSN8G5qJFczsSZyVzNnLFB2n2BZHorCNTU?=
 =?us-ascii?Q?lQyt6jnYJsV9PKUkXPVn2F8OS//crcfxvBbGaL+ItMWaWqjY6TQnbAL0ANDc?=
 =?us-ascii?Q?tOrunGli/4XUCujbOqYCn65H0teuhLrcIjXIndCMg+SmGBPp+ltj72AMt+qk?=
 =?us-ascii?Q?dRu5gKka24HzHPsNCbdzdCy6em+lQhiOE6lpCKRabdNbB7ZM0safYiwTP/n8?=
 =?us-ascii?Q?3xGBaXviGOlPbcN7qSylq3LFCDkf5FiI6lHBd747H4PpTi1y+bm7eGizcNqK?=
 =?us-ascii?Q?WBP8b+7IsdIaBkXr48zRiZbIfzawTqRprODguXVtuRHKrQ43GSc1mQTvEkOn?=
 =?us-ascii?Q?1b917mPu6WNo0IlGMjAszExLkiXg1Mhw61cDxRx+dx12dqMLXahb4V4VTG5i?=
 =?us-ascii?Q?6cMd/8uOKfYfG1Vw+hdVWppod53EV8ZNXbIuffgyTeImDpS+xMPrFXptCqz0?=
 =?us-ascii?Q?7k0iBGZELA8hoeVJknLeprgekQ8g/00CA9KJG26LJ1tm5rZ+q0ZpXZqoUe1s?=
 =?us-ascii?Q?d+oBWQddzdlqiVngLuRmpz3L8zdhePC96g5ELHkaWNBG7L+2KemhDhVWRh6Q?=
 =?us-ascii?Q?Zq5gSQsjCqB30vRGG2nzQlktmzHBWYrBlSgdSF7mKC0RBYixzLfzebf+6XB8?=
 =?us-ascii?Q?IhL9iinHH4V9Ci9iMiACZUgmDnmQ2Bg9iSf+cjBPil4SWir7Sdk1L9cVWTZv?=
 =?us-ascii?Q?gJ1yMA3oFFVVTWLRGR18F+yKVWsQSbhoBfx68YOhVzDP0KPdwH9aJhscbLML?=
 =?us-ascii?Q?aGpX8LlZ6ipDC7SZ+eP2WEf/xxeSCsJ+qZu+gB+5kdz1A6aUxsXM5gE6LtO+?=
 =?us-ascii?Q?q/0q5JCi2ry6WKhZx156ywBEqNQNlJlfYnJCCtgfYh/lDUfAwdF/7BtcAtfO?=
 =?us-ascii?Q?6gjicov3VFPjok0SJpj97tQzbzpbfNMLUWOLD6xZ83hcrA8VOEbRr8XRvwrA?=
 =?us-ascii?Q?HWc/yadNImOT/HtSQIAR9pnK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cfa8eba-fba4-4483-3b95-08d90bd1d78c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:16:54.3577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pjB3qh7VDQXo5jWPBnZ286kREQ15+1j7nZmICz3lot5Yt0+zFFVp2LrViSAuOOwRgindpv/rJEPa2x+1ekYWNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4431
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Version 2 of the GHCB specification added the advertisement of features
that are supported by the hypervisor. If hypervisor supports the SEV-SNP
then it must set the SEV-SNP features bit to indicate that the base
SEV-SNP is supported.

Check the SEV-SNP feature while establishing the GHCB, if failed,
terminate the guest.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/boot/compressed/sev.c | 21 +++++++++++++++++++++
 arch/x86/kernel/sev-shared.c   | 13 ++++++++++++-
 arch/x86/kernel/sev.c          |  4 ++++
 3 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 6d9055427f37..7badbeb6cb95 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -25,6 +25,8 @@
 
 struct ghcb boot_ghcb_page __aligned(PAGE_SIZE);
 struct ghcb *boot_ghcb;
+static u64 sev_status_val;
+static bool sev_status_checked;
 
 /*
  * Copy a version of this function here - insn-eval.c can't be used in
@@ -119,11 +121,30 @@ static enum es_result vc_read_mem(struct es_em_ctxt *ctxt,
 /* Include code for early handlers */
 #include "../../kernel/sev-shared.c"
 
+static inline bool sev_snp_enabled(void)
+{
+	unsigned long low, high;
+
+	if (!sev_status_checked) {
+		asm volatile("rdmsr\n"
+			     : "=a" (low), "=d" (high)
+			     : "c" (MSR_AMD64_SEV));
+		sev_status_val = (high << 32) | low;
+		sev_status_checked = true;
+	}
+
+	return sev_status_val & MSR_AMD64_SEV_SNP_ENABLED ? true : false;
+}
+
 static bool early_setup_sev_es(void)
 {
 	if (!sev_es_negotiate_protocol())
 		sev_es_terminate(0, GHCB_SEV_ES_REASON_PROTOCOL_UNSUPPORTED);
 
+	/* If SEV-SNP is enabled then check if the hypervisor supports the SEV-SNP features. */
+	if (sev_snp_enabled() && !sev_snp_check_hypervisor_features())
+		sev_es_terminate(0, GHCB_SEV_ES_REASON_SNP_UNSUPPORTED);
+
 	if (set_page_decrypted((unsigned long)&boot_ghcb_page))
 		return false;
 
diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index 3f9b06a04395..085d3d724bc8 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -32,7 +32,18 @@ static bool __init sev_es_check_cpu_features(void)
 	return true;
 }
 
-+static void __noreturn sev_es_terminate(unsigned int set, unsigned int reason)
+static bool __init sev_snp_check_hypervisor_features(void)
+{
+	if (ghcb_version < 2)
+		return false;
+
+	if (!(hv_features & GHCB_HV_FEATURES_SNP))
+		return false;
+
+	return true;
+}
+
+static void __noreturn sev_es_terminate(unsigned int set, unsigned int reason)
 {
 	u64 val = GHCB_MSR_TERM_REQ;
 
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 97be0fe666ab..8c8c939a1754 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -609,6 +609,10 @@ static bool __init sev_es_setup_ghcb(void)
 	if (!sev_es_negotiate_protocol())
 		return false;
 
+	/* If SNP is active, make sure that hypervisor supports the feature. */
+	if (sev_snp_active() && !sev_snp_check_hypervisor_features())
+		sev_es_terminate(0, GHCB_SEV_ES_REASON_SNP_UNSUPPORTED);
+
 	/*
 	 * Clear the boot_ghcb. The first exception comes in before the bss
 	 * section is cleared.
-- 
2.17.1

