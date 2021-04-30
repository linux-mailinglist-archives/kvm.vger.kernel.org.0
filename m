Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B266436F9DC
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbhD3MRq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:17:46 -0400
Received: from mail-dm6nam12on2089.outbound.protection.outlook.com ([40.107.243.89]:57920
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229911AbhD3MRp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:17:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hCabVYrfn+hs3ijvn0By5ILuKftxKcAOQaFZY2xt6ALqpiporcVM7OmcatZQYjXofJqLhTXyGK3160YcRbpvY2l78XUSMCG+axtWy5SpTjG+eDa7Jj3A7s+dCTSUFX+uET8lib7CO+TO3Xb6Z6JYWqnmX9O9UljlCR8S2FYCFLQJ/Gefo8tl5h55HvGH8p1LBKAengABMsu2110i/fnXXhaXbhE/j2T9wGZRiyOd+w9m1ObcznCAQTinyj4Y01/RMx+azhs7utqjkJwZHd0YcGlELZO+8VVjdjNgU4OBM8OlvsOwZR8t8icuOH6D6ncYGsXy8CaTl7VvUaExOnr18g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zRVYhLZBqj1xKwl38ZnDywFRFMEAhqjsIGNTZYQHLWc=;
 b=SfgNeChpu0KalKC160/E1Jeh5TJsEPxN2rUWQLKVi/yx3TadpYA7YT7nEOX515c2v2+KmLYtqAXlh7eKQtRL66k++An5CGhG02pEkgb8CASxx/tPiemylpEFQG+c+QVtQXydQxTOi7zhWIYzyBMeeYlJI7Q44BX12+sKyc3/cG7BBdbQmVIU7xpBtQUpZ8CKJ5ztXaKdNHamWOXnKBcefarT+ARmsY1gHCABsi/ldXOT3JCLj6F7614jRP3Akax6mZUlaXzJi1IyFLx1OwNm4MU1C916Ns+ioOCiAkKOqoQvCsCiZFujB37NPdR2aqfT5oA/3tHQi7OneAMcMBB2tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zRVYhLZBqj1xKwl38ZnDywFRFMEAhqjsIGNTZYQHLWc=;
 b=yOrM4ZXeCvzbchZajeKrzh6IxeLlBsiHemxMdc82ek5hWoUJFyFty+H48kjB8plErUE+7MVbKEDimTxGF4MgKBM6zE1gofPMxWbKw1YXaMgF557Fr9I7mCmehLqpFtFRMIVK9dLwXLRE70BLZN03HLzCWJswy2IVbC8vY7rPvac=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4431.namprd12.prod.outlook.com (2603:10b6:806:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Fri, 30 Apr
 2021 12:16:50 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:16:49 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part1 RFC v2 02/20] x86/sev: Save the negotiated GHCB version
Date:   Fri, 30 Apr 2021 07:15:58 -0500
Message-Id: <20210430121616.2295-3-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0401CA0021.namprd04.prod.outlook.com (2603:10b6:803:21::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 12:16:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06b90175-7336-4106-ce73-08d90bd1d477
X-MS-TrafficTypeDiagnostic: SA0PR12MB4431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4431F3EE5CEC2924D5EC6A28E55E9@SA0PR12MB4431.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zYL85bEBVyi1u07nzQrSGwUBQ/1tJhd48lXyDGbOnsTkZpbyj5h/EwQ1vBG06TnDptzuXPZ+ZD9wNVw0VOJCrQdbhQhgDHiViJrbFdKsvEk8rXB+F7WodYKId4vXpjmYcfW4FpEyCg6KUePpi9Wk/wlYtOGAKlUU0PqEZSQzXKclud3klAgmzCxftGTiH0pbLC4V4hSPdJG8d/yeFP/PYKYjI/bT65L/avQy1auMcFWV0GvycxHse2eCBtgkSfauoO7P0fMyAygbPp6XsUrhCCavlqUywwHZOv5Zfra6NRopD10Fci/VROGBahaQz6sn1w+4OT45OdAI4gWGhDe6NITdh4RcV/tzq2rvyG7pwZdfhwkHQfqSosmZed0944AxKgOC3WybRcUXRUar+YMApOJsVli3H7kPYIYyVcuDuW93xRn2wTehqg/rBZeiv550uj5ukd0fK3qoyGjfMmS5YED9fDIgsIz1Gs1vB1R1NRyJbpPHlq3ei+tD2uxIXlZSCi5OfAJqEfTW0k7uKqq/BRZiAJtz/8UP9s/LWRz/rUARmhJP+HrijhpSfRDR58+2i3zn8VTEMrAF9Vb61Bn2lo25tdlsc83+/GktFxmvztiyhG+rqLu1RznT8QZkUUHEXTn0dhUHHkUuWek0fIygBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(6666004)(2906002)(38100700002)(8936002)(316002)(5660300002)(38350700002)(478600001)(1076003)(16526019)(26005)(7696005)(7416002)(186003)(8676002)(52116002)(4326008)(36756003)(956004)(6486002)(2616005)(66946007)(66476007)(66556008)(86362001)(83380400001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?BvpYWQ3X5kJt9Q0HF05F3gnXVjuSn8GvWyQXW6/JUfgOdt402OeWRONMi+Cn?=
 =?us-ascii?Q?khi+M2YnV5urTcALsUnWbkoo4H6tuIBWdr9MeMX/+VALeX9PhdCxtxQx8VbE?=
 =?us-ascii?Q?G46w45xwM6YD8BzrPa692pzsAXpNLMbrnoLwkE/o0QYHDqE52Hdy+n0TV4pn?=
 =?us-ascii?Q?gZMilrMQypEJ9Se2vE8MIfC3xb64zqPUgoSI4HM+faopToCoP0uNXcA/GjLB?=
 =?us-ascii?Q?IG4TGiGuo+czwzDr+GqjPOdd/Rj9XoJzK/AI9G5PRjJA4FGnmmv0BXdVA0Dj?=
 =?us-ascii?Q?Mu9G3//yHkYkHPdCZc7unVmB5caO+BUORBrktSu+8G3f5/S0POwi4dARxbsp?=
 =?us-ascii?Q?IkM3cUqrzLLGyQQVQmTcwNHLpuFLDL5Cr95pvQu7JP26/h8O/l7zJE9fhQj2?=
 =?us-ascii?Q?p32kAjufbve8CXzR9PYeSfMpQB78iiATEHePS/JXYd4e2sJiPvfVG2/xysGR?=
 =?us-ascii?Q?aDDi3npev6JYxBxYwZk5wvdzrEJrzVPKrvs6pzMBm8lWdoihEWWN55zZ7Gfw?=
 =?us-ascii?Q?jWmYP40cTmCgK1nYRbkuuQ0snLubuRdN3Aw+4OrUux3IqWwnfEteQ2sOXFCn?=
 =?us-ascii?Q?gUCOc7oCe5Sgn2uF8kZINfB8nyU6YPt2YFMvsDaiqcrfwTo7P1KARKvUJpvH?=
 =?us-ascii?Q?jbyV+5OnaHmHFk9/pn4BkwrLJwfaXkws5aDM8zy31IyuwFF7c2xySrKihMMa?=
 =?us-ascii?Q?Pb849jQM2Zr7Dd8eBZu4IBbh5SVbz0DG/mSK2Vl2RCkUz2p3jzDcPAwL/55F?=
 =?us-ascii?Q?ECPMnpSaBpo8iyxdIyR7VWhP+89KXUTC/BYweR5xKC8lkPoJbZjCZa2oyu8T?=
 =?us-ascii?Q?Pn8afZoPE3YXyUg0P1asyA28Abjvh1HdlL9ZHNUxyhqKMD0vMPKQbjaXQbFg?=
 =?us-ascii?Q?I4zFIakMPqykDmxuLFnsR+jbglshd7kXOc05rG3Sp/mwiBRpVnAjamkaWkle?=
 =?us-ascii?Q?ApD5AtF77jVh0dsEMppMQqyYqKNFZLodQ5JiPQMFxG34/C9Qrpm8pAjLGKaE?=
 =?us-ascii?Q?vwBuEiFjxKBqFVleQCDiMZ1b6vjy9+ngOBUqbt7RanpLKYQbXVJOh++yGO1P?=
 =?us-ascii?Q?Fz+M24axAMowc+RPsQ3HQ1ju05qemp6eupdHEKApUW4F1thz2u4z2ECH/BLU?=
 =?us-ascii?Q?dWD/jRFnZp5QdNvtrPFXb+EeaM6RKY7r7GDZ+gZfY5RQw0JK+yA9l+72G6Oo?=
 =?us-ascii?Q?ohVAY/GWR+mBqqAfMtL+c+me+qqXiqDvONvMIfwELt1AS173Met2Z3lz9XB4?=
 =?us-ascii?Q?J6KlUg0DMwivZn72YgToaqYCKPic4/vPVvNpOGX0KRep+gPmNGqPuPFydKgm?=
 =?us-ascii?Q?xhVq6Qa9Q+BbyezM6vfcKifN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06b90175-7336-4106-ce73-08d90bd1d477
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:16:49.1546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j3xpKmv14Z9KjXKGl6sZb/bL7knAr/qdmo5+6xVd7RUI2jXo0wIK9NEOuptNQW5CRVDlZ74i8ren4JVLQ7lUvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4431
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SEV-ES guest calls the sev_es_negotiate_protocol() to negotiate the
GHCB protocol version before establishing the GHCB. Cache the negotiated
GHCB version so that it can be used later.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev.h   |  2 +-
 arch/x86/kernel/sev-shared.c | 15 ++++++++++++---
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index fa5cd05d3b5b..7ec91b1359df 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -12,7 +12,7 @@
 #include <asm/insn.h>
 #include <asm/sev-common.h>
 
-#define GHCB_PROTO_OUR		0x0001UL
+#define GHCB_PROTOCOL_MIN	1ULL
 #define GHCB_PROTOCOL_MAX	1ULL
 #define GHCB_DEFAULT_USAGE	0ULL
 
diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index 6ec8b3bfd76e..48a47540b85f 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -14,6 +14,13 @@
 #define has_cpuflag(f)	boot_cpu_has(f)
 #endif
 
+/*
+ * Since feature negotitation related variables are set early in the boot
+ * process they must reside in the .data section so as not to be zeroed
+ * out when the .bss section is later cleared.
+ */
+static u16 ghcb_version __section(".data") = 0;
+
 static bool __init sev_es_check_cpu_features(void)
 {
 	if (!has_cpuflag(X86_FEATURE_RDRAND)) {
@@ -54,10 +61,12 @@ static bool sev_es_negotiate_protocol(void)
 	if (GHCB_MSR_INFO(val) != GHCB_MSR_SEV_INFO_RESP)
 		return false;
 
-	if (GHCB_MSR_PROTO_MAX(val) < GHCB_PROTO_OUR ||
-	    GHCB_MSR_PROTO_MIN(val) > GHCB_PROTO_OUR)
+	if (GHCB_MSR_PROTO_MAX(val) < GHCB_PROTOCOL_MIN ||
+	    GHCB_MSR_PROTO_MIN(val) > GHCB_PROTOCOL_MAX)
 		return false;
 
+	ghcb_version = min_t(size_t, GHCB_MSR_PROTO_MAX(val), GHCB_PROTOCOL_MAX);
+
 	return true;
 }
 
@@ -101,7 +110,7 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
 	enum es_result ret;
 
 	/* Fill in protocol and format specifiers */
-	ghcb->protocol_version = GHCB_PROTOCOL_MAX;
+	ghcb->protocol_version = ghcb_version;
 	ghcb->ghcb_usage       = GHCB_DEFAULT_USAGE;
 
 	ghcb_set_sw_exit_code(ghcb, exit_code);
-- 
2.17.1

