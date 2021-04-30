Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05DB936FA7C
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhD3MkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:40:00 -0400
Received: from mail-bn8nam12on2044.outbound.protection.outlook.com ([40.107.237.44]:33505
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232397AbhD3Mjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:39:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVPMB4ykkDehJdpYNohv8TbcJptETbi1iMCURmFBx1A0DSpITQ4+WsqrSfimCFUdJx1EJAyHtY7E+tkLBdJYnL8nahvW47BF3vO+JRQKphe3H0UjQeh2VHGOpZHw9TtEvw4c0wg4D9V1uGHuf8mEz2u4ZvtEe3wkayOnrdfogfNa8/PX4d+vPXSNSayoMXLANZJYTd+HUNLFd9SHbIjYl+E/KWE/mHJUJT3PHh6Orl6vAQE36w2JuFK4muFu0rQtjjxFQQdVqE/uhctSKByva1sWK+FaUKPuUuLLIwnVTMHLlgUAgZD7o9mlUNx8cbBu4ZMVCT2lfDbX8WfpBqjD5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JeW0iUxCla5zCPXAA/b5F+0o0ibUx8HqC8wxQINKewU=;
 b=SK4cAdnLG/J3JfB+5prGIrkmVfskNHLMZEhVXi6oSNpl5grImEPAAL8WlAWhZY/AGUoN0hphZRIKVMgVFj0xeXMNB/x23J+iF0u//Lau2M/Q4NIcssES1bKrMiMB5a4d2RxORJk44CtVKiuMVL44RMEzkykT8PEAL3okuDUd7jhcpDA8jvhQLGE8ZHFxzyzj180cPpvOehluI+oREGGEevvA71cXnJonWCoRw6vwrkkdfEZkAS5mYUVDCdky1URN/IqQkQ5cumCdPeeSjNzGtzQRU87uQ0h5pzhKYE+QgUMc1fpRNi+ZW9d/CbZg1xWC872Qr0Q3JEJD5sYn50XysA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JeW0iUxCla5zCPXAA/b5F+0o0ibUx8HqC8wxQINKewU=;
 b=zyTsjN7WzzGno/GhPh0xwYnPwbIKc3/7O1zkhLmcWvkn2qmHbP7A8WKWi680BeShKsgiN09Cd8X+ijjBRabhxqC/ONwMegbMq5XNI3LZYoW470Z2djjauMXCiEVuDVyvF6HGoP9x3WN4z+5Bqm5CwI29AK03yS3EApMlY4aH0ak=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2832.namprd12.prod.outlook.com (2603:10b6:805:eb::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Fri, 30 Apr
 2021 12:38:58 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:38:58 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 07/37] x86/sev: Add helper functions for RMPUPDATE and PSMASH instruction
Date:   Fri, 30 Apr 2021 07:37:52 -0500
Message-Id: <20210430123822.13825-8-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430123822.13825-1-brijesh.singh@amd.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0089.namprd05.prod.outlook.com
 (2603:10b6:803:22::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:38:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6126d84-5735-47ff-e4e6-08d90bd4ecf6
X-MS-TrafficTypeDiagnostic: SN6PR12MB2832:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2832295D107F43C9ADDB77D0E55E9@SN6PR12MB2832.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UGaP8pCVw3O1OV1zVfEnTAgJPB1wJz04SkjRR4jUqhie6FsS94G6kCUFosCByOVs4ecye3saLHN17xCeuaP1Tc1NDOjUAcmbRiKpKZGFNlPIp586MtfggOQkwsrMDj3Rsb27G1w69JD3Mjf5vuXpkQF1+A2J8y5wDlVa13w5+H9tWq6eELXiayPLz2fprs+tZVeMYnassE3CovyWZSeyBUVA1So1qAel/qpYjLLuJ2ydWj+f/uqtoRfDZdpAP4TrbQJDgXbq0ta2B8e8bqALdUauzxlqn5rw8Ae6jxeBT4FS3QWauh2Cw3uIAZ2naR+3zcgBHR8Ka6MHev7XgPC/AJ4hbtNaJNwv21TNdE1dHF2l0v88JjAm2kDqQIpJYlmJgtmb78isRuKqHblw/Jw5w+TRv8weKjY5xZ5ff64WkLcOQtuu9IR8VkDsH0bbylWjHisLHVoFuqKmn3oSAsBj1ArSJIHgK7jjzXJ1zJCbV9S13gU7Zoi0lQeW977WSsctsb8ggL6NnzK27XppHqYYb5sb5boAF++NQVHTpSSAdWtDtfGjOhYarpqGISxohVGWxeOiyKr0Njq+IsfEaoZUe6YYa0VJa8QJ8hMvkYDv3X2eKRKmdu3rGU7cxbFzt8IcaxI9zDcuMk+krKHFD5O1UQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(66556008)(956004)(7696005)(66476007)(6666004)(2906002)(7416002)(66946007)(1076003)(52116002)(38100700002)(186003)(16526019)(4326008)(2616005)(6486002)(5660300002)(44832011)(8676002)(26005)(316002)(8936002)(36756003)(478600001)(83380400001)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?NxUYVi0TnSV4OStFNv3xI3nF1vreHOpCwkalGZaSzqCsO8BIctIvAa8Mjj+r?=
 =?us-ascii?Q?cZrLACxXSFU2HYSN/3TfP2w+xcaYC6Md9iF6Ua1/akZFUEjt1h7DwzOVhXvU?=
 =?us-ascii?Q?ta5EUQ8juIE7fJCCYymkjqtvSzZCniXE8KRoU+wrjiO0fBXviJGoJJrMjG9d?=
 =?us-ascii?Q?GR1NWHMonUng4CG7BAu3zZv4zzScaSRzNgpBrKU9HOzLueGL+lJ+4XHwopdX?=
 =?us-ascii?Q?Ps4tfl9Gt1gX6JOSFCi22e487G5GiIRn5TrTsEBt/GA+Lil8D32RHaU2OVN1?=
 =?us-ascii?Q?b4EQ2gS9oP4qBcnWvxIrYkzIiysAVwKG6KKNYoYOTn5YQeffcMK1Kb+Cb3Ez?=
 =?us-ascii?Q?o5P8/pVAVICwcVroW6uUfz0ZlkzSSp7zji2cYZxKez1/ovoxjsanzCFGUtBW?=
 =?us-ascii?Q?WNpNT8a6VbcWB/y8t7VHv0u4rAPtHmlapvrehA2tURoDSkiw54I97IC9YnZE?=
 =?us-ascii?Q?E+oCMzfitKP63TlexKR+Ipv6TM2oOK0r1DCF3rZ4knxDNL2Pt0zpTc7BYXqO?=
 =?us-ascii?Q?Ol2jKmuXUMSBNISHQUzw2P9JDPQKxWu7p9GR/8VzV3w0KGond6DDAhCK+01b?=
 =?us-ascii?Q?qCuuhl7QzcHi3ZDPPaTgvuuVj+JU6AXLvF1ratge9JJYW36+wyRmMmD8m2/e?=
 =?us-ascii?Q?oiEwulG3lok1NWKljugYG7jU6pcrkGdukqjb3RgLiyoAmncDohnICRgbEcxw?=
 =?us-ascii?Q?TD6OKMVixsYiBh6YrnkLNEzS6jhYjz7mZ3bi2OfcOz9H9Ko/7hVM2bhtiDNl?=
 =?us-ascii?Q?eDhpOzpnaFsDUmLwMa4vSZqhlA3stq/5Ano8U385fKts983qOgX76DHfJ5UI?=
 =?us-ascii?Q?fs7hWd+l2c5hpmj6bfMKLjKlB1aRHPbSLCpCT3Y87Dk+rqs0E0mH/xwrY2K8?=
 =?us-ascii?Q?8T+0YR1Ipby3dVXUZwzpB2onXGbFJnxomYIRtPXpOTlSgklhYyciV2viutan?=
 =?us-ascii?Q?bupjsCysJv7r7ArQBzjJ2AmU4dIqRHJohr8fXJNibErl8DEDiNX1pmX1+zUR?=
 =?us-ascii?Q?tsOFvc6lmn21lwob2tKP7bAzm/he0BZ3/j9U25ofYHoz4fHADhrnkR8l3fPS?=
 =?us-ascii?Q?lDU9r0eBS6zC69qUf4HX+GJ/0DW53FF9ZZBJKWF/0HL6fwcO739nk+g6Iu92?=
 =?us-ascii?Q?txG71FNgr+L0SRvXvDZR7oqXuOF66sMSnrdR1w0v9I7z2EetepdvS3LXCp+i?=
 =?us-ascii?Q?+q++m6D9ciRs1gz/zffBoL5DQP1kZNQMzGD/KevGi10STBWe+5hTWElwkspd?=
 =?us-ascii?Q?QpNvgAvy5yM9ODzpai6XtIqQCUSv3QUqMqrZDEYGIlGh3K8KUVsrO4dxsjvi?=
 =?us-ascii?Q?3GQCx27n4hGtffAMykbS0ReW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6126d84-5735-47ff-e4e6-08d90bd4ecf6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:38:58.7880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VOz2b5Agcu+5PRjkgPNj9hwuMSo4VnC3bHCqY2XFQNpl3NYGB9SeVrBTBZ+0g+oyTcGkglopgsPErZUvRRRWdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2832
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The RMPUPDATE instruction writes a new RMP entry in the RMP Table. The
hypervisor will use the instruction to add pages to the RMP table. See
APM3 for details on the instruction operations.

The PSMASH instruction expands a 2MB RMP entry into a corresponding set of
contiguous 4KB-Page RMP entries. The hypervisor will use this instruction
to adjust the RMP entry without invalidating the previous RMP entry.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kernel/sev.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/sev.h   | 27 +++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index dec4f423e232..a8a0c6cd22ca 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -1901,3 +1901,45 @@ struct rmpentry *snp_lookup_page_in_rmptable(struct page *page, int *level)
 	return entry;
 }
 EXPORT_SYMBOL_GPL(snp_lookup_page_in_rmptable);
+
+int psmash(struct page *page)
+{
+	unsigned long spa = page_to_pfn(page) << PAGE_SHIFT;
+	int ret;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return -ENXIO;
+
+	/* Retry if another processor is modifying the RMP entry. */
+	do {
+		/* Binutils version 2.36 supports the PSMASH mnemonic. */
+		asm volatile(".byte 0xF3, 0x0F, 0x01, 0xFF"
+			      : "=a"(ret)
+			      : "a"(spa)
+			      : "memory", "cc");
+	} while (ret == PSMASH_FAIL_INUSE);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(psmash);
+
+int rmpupdate(struct page *page, struct rmpupdate *val)
+{
+	unsigned long spa = page_to_pfn(page) << PAGE_SHIFT;
+	int ret;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return -ENXIO;
+
+	/* Retry if another processor is modifying the RMP entry. */
+	do {
+		/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
+		asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
+			     : "=a"(ret)
+			     : "a"(spa), "c"((unsigned long)val)
+			     : "memory", "cc");
+	} while (ret == RMPUPDATE_FAIL_INUSE);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(rmpupdate);
diff --git a/include/linux/sev.h b/include/linux/sev.h
index ee038d466786..9855e881e542 100644
--- a/include/linux/sev.h
+++ b/include/linux/sev.h
@@ -42,13 +42,40 @@ struct __packed rmpentry {
 #define X86_TO_RMP_PG_LEVEL(level)	(((level) == PG_LEVEL_4K) ? RMP_PG_SIZE_4K : RMP_PG_SIZE_2M)
 #define RMP_TO_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
 
+/* Return code of RMPUPDATE */
+#define RMPUPDATE_SUCCESS		0
+#define RMPUPDATE_FAIL_INPUT		1
+#define RMPUPDATE_FAIL_PERMISSION	2
+#define RMPUPDATE_FAIL_INUSE		3
+#define RMPUPDATE_FAIL_OVERLAP		4
+
+struct rmpupdate {
+	u64 gpa;
+	u8 assigned;
+	u8 pagesize;
+	u8 immutable;
+	u8 rsvd;
+	u32 asid;
+} __packed;
+
+/* Return code of PSMASH */
+#define PSMASH_SUCCESS			0
+#define PSMASH_FAIL_INPUT		1
+#define PSMASH_FAIL_PERMISSION		2
+#define PSMASH_FAIL_INUSE		3
+#define PSMASH_FAIL_BADADDR		4
+
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 struct rmpentry *snp_lookup_page_in_rmptable(struct page *page, int *level);
+int psmash(struct page *page);
+int rmpupdate(struct page *page, struct rmpupdate *e);
 #else
 static inline struct rmpentry *snp_lookup_page_in_rmptable(struct page *page, int *level)
 {
 	return NULL;
 }
+static inline int psmash(struct page *page) { return -ENXIO; }
+static inline int rmpupdate(struct page *page, struct rmpupdate *e) { return -ENXIO; }
 
 #endif /* CONFIG_AMD_MEM_ENCRYPT */
 #endif /* __LINUX_SEV_H */
-- 
2.17.1

