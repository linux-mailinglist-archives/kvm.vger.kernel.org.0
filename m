Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE1A36F9F8
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbhD3MSj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:18:39 -0400
Received: from mail-dm6nam12on2089.outbound.protection.outlook.com ([40.107.243.89]:57920
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232231AbhD3MSL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:18:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mMZ1jCk3Jye0sMQN8B0FilxQZy5Km/OV8bXZp3qf+rH78NmEMnPcs9bgfgGbkLrtwbhBe7/ra1tpxIG2SX7/bCNFL3+x4rle9MYwbmV2l0crSfu9EzI1fS9KCow4GSJzQX2CCg8WDDt3ZDFL45B6EUF+hin+LrTpRmf1B0tQVXxyhS0kp563hEyAThdJjjdqIsiSLD9lZBYO1y4YOrzPZuLM+DSu8Lrxii3m54AAmrXADh6bNm6oRrIx/5HmgrEAXHrm4DrOJGVtwn+n4VqRl8MVVJZ/TIfaSVizKXf2hjyMaUaBeKEdv59M2rDBY7NmkPQA6zMT9xULgBDtC/qL3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MVhIaxMpyujQL6Fvq0llLz3rx0U6cFhPx5ikqu42Q6s=;
 b=laOqCT1nR8CTGCQf7WB6m90+y2rmgOE5un40l6bvseRejYiJuY1KuGwbXpQFkgim61CIGHXQpHoolD3lqhsDVlP/Bng62zY+gS7+UcQyryf91FGMsed6pfetAoNSkzeqkhV+LhtSDbyv0fw/c32aJZzVXRSkdtM5cJ9RxsSnvLb5MvfjmYrY9obLmBBMif9RDfjknWNBknXMQswNF3d1idcXLWyX/yGGP2K2amZ0CJD7vsBPEItclt4ZVdESePY0yJCw95lI7KeYa9NZqaTSran9I9N8TAFMI6x8SxpqMERIPGL4NQ+wsoppOwICNTqTdpH4RcslTgP6SmfB5ePtag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MVhIaxMpyujQL6Fvq0llLz3rx0U6cFhPx5ikqu42Q6s=;
 b=VCTqrmZut/aoSXu2GxfnyJxW+KL6rUNIs7ua+TxMsRl+G3jQ9oTmwoGuBa68vZKL7U+JwnoTayObCP5mqaDGtPExcLdUCzu08QJ/5IgHqcuCUIi13jT1uwic60TQL9K5L/FuDBMUfGKsg+sOp+n3Ezh7ObzuVfhCmfKPsBwwS9U=
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
 12:16:59 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part1 RFC v2 10/20] x86/sev: Add a helper for the PVALIDATE instruction
Date:   Fri, 30 Apr 2021 07:16:06 -0500
Message-Id: <20210430121616.2295-11-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430121616.2295-1-brijesh.singh@amd.com>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0021.namprd04.prod.outlook.com
 (2603:10b6:803:21::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0401CA0021.namprd04.prod.outlook.com (2603:10b6:803:21::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 12:16:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 037cf877-1344-4478-c7c7-08d90bd1d7f3
X-MS-TrafficTypeDiagnostic: SA0PR12MB4431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4431A68989FABAEF25F6C13FE55E9@SA0PR12MB4431.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rcnKb8ErjtDTE+qNt7woAZFm0SarDh3LPTUlu9lOKy/CLko3NwnjYl9H6DZqQtmv6V11GNTQDC3try/Q9XnYYWo/P/4AdUnG8BSKGYkB0ICLiRLEfwuG9Qr5pHzzeKUNvwA6WO88SXS76rOCwNCZwOCG04Zvul1VxHGUeRySVpeU8SdZt6ElA+7fK1yg9u0QDs2Hsga3GA980uKXHGo43BrC0ptgbXwUova1mrAmTuKSFqOM4l+qxoqwPgSOuf/TJlvI6p06xTD9fH55Nf1+AiS5fHmAiIOm5PantMj7gS6DoCTxZ3Iu0bbgesuoW3/w7HoHslFgEvcZJgflybYN7BkNZx4a2GmtfKcHgpyl5CHHzp7+LCVXVpWaSAtS2cq7qUBKDaKbFdEIi6IMTgNTJM53Bl/vy+eOaJol5rsWWLo40vrNaIHvgHQo9YLcAwwKba8Q7b+rVNEu6sdx154Y7ltFZxqlzE6L4c0H36Ly+wkNe1TEGuMf0XuXjKbpgTVFNDlYUaY5lunoK1ZTAGPcuUU9xkA8LkSRQYVpRxDUeTln+YH6KycYDQ9KJp74MKGRS5U+BM2rsbbZFrz9G4FnXf6DKD3Zd9d57iYOyKkm2pmadVIfEBeciD30VsM4E2UZSvzOvByuKGxkMQe8FG4k8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(6666004)(2906002)(38100700002)(8936002)(316002)(5660300002)(38350700002)(478600001)(1076003)(16526019)(26005)(7696005)(7416002)(186003)(8676002)(52116002)(4326008)(36756003)(956004)(6486002)(2616005)(66946007)(66476007)(66556008)(86362001)(83380400001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MmxqblRVU3dVdURmRExTMmo5Y09EdWlObHgzbWlzNXhGQjVZOWF1bGFqSnhr?=
 =?utf-8?B?RldpSmZVaTJPMnkvV2tqUTl6dzhXYnUwZzlhcnRPWnNWb3FLSHhmaXNQTjhl?=
 =?utf-8?B?dCtLUUtpcTlsVFVDK0svYU1wTFVPUlJhMzkrMVJGNFQ4WjExbFBKdk5MbXpq?=
 =?utf-8?B?TDY0ZGU5SllSZW5KNHVkV3VFY3JYNzFqa1d5ZThENGhXaFR3Um9mMlQ0dUtk?=
 =?utf-8?B?dHZFNGx1TjJuMW9na0RKeDFLM0licm9ISTVDVkg0UUNmV3ZrZ3k2eGNhaGY0?=
 =?utf-8?B?TEJBKzlSUXBab0xGSUNtOEpWdHBpSHFoVThORTBTVG96OENtb1hXN0RHc0RC?=
 =?utf-8?B?ejFEb0krN1p2ZXVrbWR4SUplQUxlNUNVeVZIQjhBeUR4RnlOOHJhdnhSbER6?=
 =?utf-8?B?c2pBUzlyUS9OUVRsWFM1dDNiWVNadDVzeG5MMjRVbHVEWXZGNUtnWis2ajVB?=
 =?utf-8?B?TlNFejUzK25RN0VaTGFOYjVMejlRTDlvWi9iRjB5SUd0MWNKV21MaWJsL3Uw?=
 =?utf-8?B?c0RZby9OcGlaZzVBZEZTTjF6ZDFnME1mKy96Z3BaZWtkNWVtMGIvS3p2c2pn?=
 =?utf-8?B?WlVTc1RiZGxjM0xaSTNNZi9qNHdSN2VPeW16N0pNOEYrZWI5R2V3ZU1Zd1BF?=
 =?utf-8?B?NVdkK2ZsTU1PSnd4Q1lLemVnVmxJcFBWNmNLS2FyZ0c5YkEwd0lTcHlpRXNm?=
 =?utf-8?B?NVlWVjdvUmhlNGtUNDlWWXY5eERXSG5lc0toclg3S0tiT2JiNExHSnQvQnJY?=
 =?utf-8?B?TlN1YUZVOE9kOERJTGlQVndiRVMrbUFPYlJEWUd2Z05TZ1dGdHpkRW45cXYz?=
 =?utf-8?B?SXk4bHFCTnVDOVg2WndOdS8wQjErbEJOcGFPTzRQanhMeXB6cTBtRStiWVU3?=
 =?utf-8?B?Nm5CUkNBSlZmaFBuZlBnNXRTWnp2eXJ5MDhKaDBBM1B2QVBsa2IvZWorMmVP?=
 =?utf-8?B?bGNSaTEvOHJkekE3Rm5TbzQveHo3MGNQZThYTFBBL1VUNTJOUnRBWStLTHlD?=
 =?utf-8?B?U2c3ZFh0R0JjUVZIc2lEMitNeWVlOStmSzJITjY1ejMwWHBMVW5aczNnQ0ZF?=
 =?utf-8?B?UmlVZjRkVmY4enlNNDBtRjhpcEV0T1B3cDNybUVCYlphQ0kyWVRGODNMTnJC?=
 =?utf-8?B?T3Nsa1F1K3A2VkFEdnlxeWQ4NVRjbjQvdGNCeXl3SVJuM2p0V2RFNmJERW91?=
 =?utf-8?B?WnkxUlV3NnhDWDdySHBpSEtvN2tDb0k2Y2FlMXJRZWc5QkhvSVFEUlgzRnhK?=
 =?utf-8?B?MmJQckxRSGtnY2Y0UEVmRitwOGVTdUlLVVV3RS9DWlRYYzVxTU1ZT2JOUkt2?=
 =?utf-8?B?cGZac2dYdFRKeWhXaldncnFJSzVmR0hwNG5FNlRURGdaVVFXNHNEd3dBYS9R?=
 =?utf-8?B?d2FOSnJtZ3ZXTk8vdG5yVStUYlhSclQ4SDBTV1RWeWVsUGsrSnM2QWwyYXVW?=
 =?utf-8?B?MjcrUWlXZmVGcVc2QWV6Y1h3OU4yb1RBUTNPY1VUcER4QUhWWCt3VElRaSsz?=
 =?utf-8?B?QmJTamRKOUdHWGZ1ZklXeDk0bUhFQnZBTkZQaFpxd2ExM0tRRkozbU0xeWc4?=
 =?utf-8?B?ZlFVMHUybmRVcDBUVXZrZ3dVNkZLSHZla3JrUjB6eDdaVEdxRVJ2M1RlUHpR?=
 =?utf-8?B?YXlhL3ZpK2Q0cGdnaWM4am9qTmYxeHdnWGhQWEZjMzkvRFBvK3hoZnpjd2tn?=
 =?utf-8?B?MEV1MENjRzFhODNqOWM2T0IwdFFvYzNKMm9oYWxMeHppUTJROExuWTBXNmgz?=
 =?utf-8?Q?Swm2Cy5ZdDMu/shqkYpMszjJAcVyU3bn2IHilNc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 037cf877-1344-4478-c7c7-08d90bd1d7f3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:16:55.0772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q5/kk7nsvH3tW8H0lZAV1FxCUJfJV9ZSKrRiICnvOZiiVE+bKD+Xo8nUBUTzFp9YwlgGefCnL3eRrDojL/rNRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4431
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

An SNP-active guest uses the PVALIDATE instruction to validate or
rescind the validation of a guest page’s RMP entry. Upon completion,
a return code is stored in EAX and rFLAGS bits are set based on the
return code. If the instruction completed successfully, the CF
indicates if the content of the RMP were changed or not.

See AMD APM Volume 3 for additional details.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 134a7c9d91b6..48f911a229ba 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -59,6 +59,16 @@ extern void vc_no_ghcb(void);
 extern void vc_boot_ghcb(void);
 extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
 
+/* Return code of pvalidate */
+#define PVALIDATE_SUCCESS		0
+#define PVALIDATE_FAIL_INPUT		1
+#define PVALIDATE_FAIL_SIZEMISMATCH	6
+#define PVALIDATE_FAIL_NOUPDATE		255 /* Software defined (when rFlags.CF = 1) */
+
+/* RMP page size */
+#define RMP_PG_SIZE_2M			1
+#define RMP_PG_SIZE_4K			0
+
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 extern struct static_key_false sev_es_enable_key;
 extern void __sev_es_ist_enter(struct pt_regs *regs);
@@ -81,12 +91,29 @@ static __always_inline void sev_es_nmi_complete(void)
 		__sev_es_nmi_complete();
 }
 extern int __init sev_es_efi_map_ghcbs(pgd_t *pgd);
+static inline int pvalidate(unsigned long vaddr, bool rmp_psize, bool validate)
+{
+	unsigned long flags;
+	int rc = 0;
+
+	asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFF\n\t"
+		     CC_SET(c)
+		     : CC_OUT(c) (flags), "=a"(rc)
+		     : "a"(vaddr), "c"(rmp_psize), "d"(validate)
+		     : "memory", "cc");
+
+	if (flags & X86_EFLAGS_CF)
+		return PVALIDATE_FAIL_NOUPDATE;
+
+	return rc;
+}
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
 static inline int sev_es_setup_ap_jump_table(struct real_mode_header *rmh) { return 0; }
 static inline void sev_es_nmi_complete(void) { }
 static inline int sev_es_efi_map_ghcbs(pgd_t *pgd) { return 0; }
+static inline int pvalidate(unsigned long vaddr, bool rmp_psize, bool validate) { return 0; }
 #endif
 
 #endif
-- 
2.17.1

