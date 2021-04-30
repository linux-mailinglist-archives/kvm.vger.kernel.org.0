Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621F236F9E9
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbhD3MSG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:18:06 -0400
Received: from mail-dm6nam12on2089.outbound.protection.outlook.com ([40.107.243.89]:57920
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232113AbhD3MRy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:17:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QK08UBSyi4M7zocDpGeFPYnBU54xeyR76PoLhWC//X3YupNMrzZP53dbZY9dHuOOCVBu6K4IlmkSYrQrE8pvR5riMxmRBeAyZXimloZeFDNuJXNk/eLbjFwaZsPC+QzQssbD/rTmtnzpyN9+6gTbug0np7nY9xDiHkjufH/QYxDd/NeH7EV1yaPhdL8tcW9IcpMO30Xf+cLLx+HyrfOQ+/to3b5LkYWaxB7x27/CJQObD8H8sU/Ae4vgym99bLjufBCFWaiutjTBZ8HzxrgyUM9+zB8mj9t1bKnBGPK6iSIj7zraCCOro0UNC1Qg2uwyoiAZweD9ggaDmQd9GzNSDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+RndLtxGfWv7MpfveLrrmNpBHhrqUZ9RlDNGMg2W+XY=;
 b=nAleRbGeEWsfqpLP468yZWfHw4W6yGvsPiRmsNcce+62Mkul1lF7Xm/OS/QCkl3VWpo5y1k44s4JFzyHLKATDVjSgY3NQDvdx3kaOtlFq81l9ktge7AeZP4MJtmr4TlPU+fKCv2sUvarrqRHla5RHt1Y0q4RjOK9/1KQvGKY2Y7v1t68MUCOfB+0gtDiy0l1enUaIOQP/sWeELi8Il4asHKd3jdFb8K43z+rAD6kfqLqHGhFjs5W2RGgNeP6zDt4mDbVyKbIZvnk8Jh+NaGMtoOLqhPJrhubLkz8cfnTwWB845IeVwh79yrL+7tN8tAij+yTPdKc5woR3DJ/4iS+vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+RndLtxGfWv7MpfveLrrmNpBHhrqUZ9RlDNGMg2W+XY=;
 b=H/G3mz5To1F2clYVayG15Hzms5I3gDsyY8IrpJMPedoh9wCQAJdzJSKtVWIF82PHHhAQVYFlWUXjtf70dxEWbVz41+b9PaEcqBQgPT/0lsR6k7jWAYuRWRFr98p19uDZTu5izqifMz3q0Qv39dlF54rRLAv35MxObZh6sWbVfGk=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4431.namprd12.prod.outlook.com (2603:10b6:806:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Fri, 30 Apr
 2021 12:16:57 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:16:56 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part1 RFC v2 07/20] x86/sev: Define error codes for reason set 1.
Date:   Fri, 30 Apr 2021 07:16:03 -0500
Message-Id: <20210430121616.2295-8-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0401CA0021.namprd04.prod.outlook.com (2603:10b6:803:21::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 12:16:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0d8dac7-47e3-431f-c46f-08d90bd1d675
X-MS-TrafficTypeDiagnostic: SA0PR12MB4431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4431770588E270D9FA2B1C90E55E9@SA0PR12MB4431.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RJewmPIJdiIasZisxi+AgyYzD6buQqXkBGOjrvfmn03dSK5L4L9IL2WYuXW3EHy7OTBR8STQsV1/bOHu1waFbx0kKaKYlF/C50rM40E5hVJA/wmEecT2qvMSqiFQ1NlUxeuLPo3BidGtSghOpxwB1nCXBJ7zXJJP+MY/oFk9lAOAnA+9g2A72M0DBOFWmYzYYJNK5YEaIM5GZfpOBduXR/MabzD9U05pxyWLNNIbxOiQ5OKSdChmVJw1Ur3k4nWhOBrR3A4tbCJInHj4QxVfvFBiD0wBN6WxDDNA/2lUYwH49wPrSk32KyULs7oY1wKEwIg4rMFKnOAfUwNa2YjlEx5av21JCjYS/T9aqccoPWYq9abx1F2ALh+yVHwDG4/ncNyY8vL3/yD1Hu3YaDPyZNV0LnBHTL5pU6+RjI68f7/2io9Z6duT6nL08UjruR4Q2GuIKTkHXsnmByXVwfxhGNLg6/yFDVVlnqtEsHVxwBAzZBkxgD5BuierZJEfB1KDAeRqVjWbglR7XoSQpCiVYlV3h4sPFNj2Nfgc2LahotWQW6s0htnIvuSfAqBImjwqhzT8QC+Lst1W031MAt4dhOShIoy9B50jemCRLQHlw6s7XBRWCpRHA2jQT/WOCngwlBE4jG/8PE9CZIiW4jazAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(6666004)(2906002)(38100700002)(8936002)(316002)(5660300002)(38350700002)(478600001)(1076003)(16526019)(26005)(7696005)(7416002)(186003)(8676002)(52116002)(4326008)(36756003)(956004)(6486002)(2616005)(66946007)(66476007)(66556008)(86362001)(83380400001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?iJ6o20HmQA0By8FtcSkm+LApGxYX+QAaPH/V7+MPI1iJPGxK0/W8otZ/hGsX?=
 =?us-ascii?Q?ZqQBV0nMZhvNktA38FLE/rCpWGwTRg8tKYDm+OZvx5qa/DS0eIv7x7AnnaZi?=
 =?us-ascii?Q?JvExsTF1wk1EelXFHt0z86TblZSBLYHXsu3LMSQPh4vrqsVE7x+FMBN1Vk08?=
 =?us-ascii?Q?f5H+e7MLrqqFooi/QVb7S5nb9RZvxALZxGKmQk6GvhzS8SXE8u/XU75Gc88n?=
 =?us-ascii?Q?9mb7gU7VtmOwvB0I/lAi/5+CNkhKBXQOp+q57TFVzrpmNwHqCIVNj4Zm6Rij?=
 =?us-ascii?Q?8t59/3Z+7xtUu8loquCYzOb3TW9jgoe1X7bN/X/nHRL8UcCL7yZiK1T/25UZ?=
 =?us-ascii?Q?Dxx4xsF11Cf+/zR0JUvHkdjw1SM/sklT4I/dwIe6AyvmJEA06DaQseUs8UyT?=
 =?us-ascii?Q?Z0q0t/VK6qaG3QK8sf/4KNFOy0LXL+PeZ5Xm1jUXb7o3WDaEjBQjkSw2pIOM?=
 =?us-ascii?Q?sk0wlo4zXSFDlhnzOdbICO03kGam30D93oCLH7w71edPAUL/omurAdrXStF4?=
 =?us-ascii?Q?KcDcXKgtaTFAULstqzUTmO0YnaRB70ZFFlqLWcZQnF6WzJxkvLUtCTi9ceMb?=
 =?us-ascii?Q?oYv8f+frOauAp9URugz2gQmt5mxAMFyjx5erF56RrvO5ahLKwKwmU3An2BT/?=
 =?us-ascii?Q?1Wx9O9vDNfNjV+882IwGvjq2rj3uvgPeL0gvj509XDKpDpK32/8PIL7poHei?=
 =?us-ascii?Q?T/Q2k8mbX995tcagHqsbbn6cHCzjtYx9RebKuMuY5/oWSH3dPoA58C0FkIMD?=
 =?us-ascii?Q?81TxmELu8f58mc4NrZNx5wv9u8L0kWqAFVshE1Y0g9eLIr09M7KeW0TQmisP?=
 =?us-ascii?Q?DppHEViYBKW8pfDesa4UA3P4vFXUZEyANjuIPj79y7uTf4rV/yUL98q03u3s?=
 =?us-ascii?Q?dmAHrBp+2/4Rc02PkFaoIv+gh2RGG9OIBX7pSBR/Pf9UncthqskEil6ALi5H?=
 =?us-ascii?Q?Azx7K8XacKADEud/No2H4USmaObTYUXiktH2o5LuYEJvMZUMHnHgXCtRRcEV?=
 =?us-ascii?Q?4eGOZtM+IO4sJSnNnuwq337CAB7rYBG2Zf4XfC0MARwQ0yiRmCzEmLDzJdrK?=
 =?us-ascii?Q?tob6QFilYzzrc0OeMhVnU3Z5wsxRYxJ/lpVpMYnFkcCOeycFo+gPqzVuCH3M?=
 =?us-ascii?Q?r8IhfZtNi8jSwzv9SVg3veVEJVXjwP9tHi3gfXuK+pz4ym5zq0od2iCm5jOi?=
 =?us-ascii?Q?6x4CeAxqkHIDFolPqcAx4BCe/snR5KCNdsVVSvbLMZJ3COO7POczTi9Q+U96?=
 =?us-ascii?Q?SQQiNoO6CHka7Z/g0GwMzJrbKC4mer9c54CFNlnXKj8Q5wtps6HBQmHym8Ua?=
 =?us-ascii?Q?5QYsgrtePoTr6kmZlfIQfjPp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0d8dac7-47e3-431f-c46f-08d90bd1d675
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:16:52.5087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ja6hfLJvY1oGL1Utfp96xm+mqE7CgnGM+IdKN/uamoEYYHhiYyEjt3PmDc9/xo8n84G/90aYM/+tK7ZQJuGYYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4431
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

GHCB specification defines the reason code for reason set 0. The reason
codes defined in the set 0 do not cover all possible causes for a guest
to request termination.

The reason set 1 to 255 is reserved for the vendor-specific codes.
Use the reason set 1 for the Linux guest. Define an error codes for
reason set 1.

While at it, change the sev_es_terminate() to accept the reason set
parameter.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/boot/compressed/sev.c    | 6 +++---
 arch/x86/include/asm/sev-common.h | 5 +++++
 arch/x86/kernel/sev-shared.c      | 6 +++---
 arch/x86/kernel/sev.c             | 4 ++--
 4 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 670e998fe930..6d9055427f37 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -122,7 +122,7 @@ static enum es_result vc_read_mem(struct es_em_ctxt *ctxt,
 static bool early_setup_sev_es(void)
 {
 	if (!sev_es_negotiate_protocol())
-		sev_es_terminate(GHCB_SEV_ES_REASON_PROTOCOL_UNSUPPORTED);
+		sev_es_terminate(0, GHCB_SEV_ES_REASON_PROTOCOL_UNSUPPORTED);
 
 	if (set_page_decrypted((unsigned long)&boot_ghcb_page))
 		return false;
@@ -175,7 +175,7 @@ void do_boot_stage2_vc(struct pt_regs *regs, unsigned long exit_code)
 	enum es_result result;
 
 	if (!boot_ghcb && !early_setup_sev_es())
-		sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
+		sev_es_terminate(0, GHCB_SEV_ES_REASON_GENERAL_REQUEST);
 
 	vc_ghcb_invalidate(boot_ghcb);
 	result = vc_init_em_ctxt(&ctxt, regs, exit_code);
@@ -202,5 +202,5 @@ void do_boot_stage2_vc(struct pt_regs *regs, unsigned long exit_code)
 	if (result == ES_OK)
 		vc_finish_insn(&ctxt);
 	else if (result != ES_RETRY)
-		sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
+		sev_es_terminate(0, GHCB_SEV_ES_REASON_GENERAL_REQUEST);
 }
diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 07b8612bf182..733fca403ae5 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -128,4 +128,9 @@ struct __packed snp_page_state_change {
 
 #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
 
+/* Linux specific reason codes (used with reason set 1) */
+#define GHCB_TERM_REGISTER		0	/* GHCB GPA registration failure */
+#define GHCB_TERM_PSC			1	/* Page State Change faiilure */
+#define GHCB_TERM_PVALIDATE		2	/* Pvalidate failure */
+
 #endif
diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index 874f911837db..3f9b06a04395 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -32,7 +32,7 @@ static bool __init sev_es_check_cpu_features(void)
 	return true;
 }
 
-static void __noreturn sev_es_terminate(unsigned int reason)
++static void __noreturn sev_es_terminate(unsigned int set, unsigned int reason)
 {
 	u64 val = GHCB_MSR_TERM_REQ;
 
@@ -40,7 +40,7 @@ static void __noreturn sev_es_terminate(unsigned int reason)
 	 * Tell the hypervisor what went wrong - only reason-set 0 is
 	 * currently supported.
 	 */
-	val |= GHCB_SEV_TERM_REASON(0, reason);
+	val |= GHCB_SEV_TERM_REASON(set, reason);
 
 	/* Request Guest Termination from Hypvervisor */
 	sev_es_wr_ghcb_msr(val);
@@ -240,7 +240,7 @@ void __init do_vc_no_ghcb(struct pt_regs *regs, unsigned long exit_code)
 
 fail:
 	/* Terminate the guest */
-	sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
+	sev_es_terminate(0, GHCB_SEV_ES_REASON_GENERAL_REQUEST);
 }
 
 static enum es_result vc_insn_string_read(struct es_em_ctxt *ctxt,
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 9578c82832aa..97be0fe666ab 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -1383,7 +1383,7 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
 		show_regs(regs);
 
 		/* Ask hypervisor to sev_es_terminate */
-		sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
+		sev_es_terminate(0, GHCB_SEV_ES_REASON_GENERAL_REQUEST);
 
 		/* If that fails and we get here - just panic */
 		panic("Returned from Terminate-Request to Hypervisor\n");
@@ -1416,7 +1416,7 @@ bool __init handle_vc_boot_ghcb(struct pt_regs *regs)
 
 	/* Do initial setup or terminate the guest */
 	if (unlikely(boot_ghcb == NULL && !sev_es_setup_ghcb()))
-		sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
+		sev_es_terminate(0, GHCB_SEV_ES_REASON_GENERAL_REQUEST);
 
 	vc_ghcb_invalidate(boot_ghcb);
 
-- 
2.17.1

