Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69C1398C0F
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhFBOOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:14:40 -0400
Received: from mail-bn8nam11on2088.outbound.protection.outlook.com ([40.107.236.88]:32416
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230359AbhFBONj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:13:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZD4KV6sga9O3iiXNC5qMp52yANHwPombGqFEdq0glQkE5Etu/Nhf04sIaz3cwTqKRcTMA025HgbzOWCk11bY4Eizye2rl4uE53nAurMuvjCvbOU/7znJ+HJ6SkxYU2ezScCBfSCmqoGPvTq/fLndU2pzajRg5RNNtDR1q8JTF22iZqIxg1Baz1RvRRvpEIytS9IowAEas8b+pAgyzfC+mYh7URuLF6DLLIsPOj2AXWiZxSBmxcbnT8mqslbB26yM0vw/YpE3+wHpnqzmECZewmkZGICp44OHTHODnK7AWpGFMtWr1I3zS/0qPYlkpQpgMDfCySwzEGGZdfuXH00hcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZEZwO4zibzF6XLvhJ7uKSuP2o00KS+r4CawKQPuRyXY=;
 b=O+w2aEu1DtCvVGu4UGCAcqQK+gfjbuZ73wgLDDPRCo+ApXJuy1A973xXJ3OU2RtwlINE8VCDtOyhvCU8d+PnTZHbH2CpySimzaNPo7IfZTLpBlGutoxpBbRi0DOOvWM/twac5MflXjJ1yC5VZ1z1DWNqCQXDqX/t7WKvPikh46tmJGFdNgPrxOSUlus5WBAtYMtdJ1mccxtYL7CNwWl9Fncedsv9B4P/OCMpVxn6PbCHbD9lJjio74nyOnfM+ox7hH5hONRXWLNS9RgsiSO0X8k4Np9pX9DwA3WhSLXv4RS+MtGMeB1DR1V2iT65F8n2Ozd6gGVqf5qHsCb0MI7GBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZEZwO4zibzF6XLvhJ7uKSuP2o00KS+r4CawKQPuRyXY=;
 b=jcHpo5VJwxfteSnrCEHR7H582g9PFyUdAf1iZRtfcsNechPrBNJfFRwrcJ5CfLnMorzH9NwdaKXpOGt2j/wPylFi/wLIx9gb3ewazaoPD05pXwv4tjK14qfqMhxCde6KXpjMqea/dSKN3P/hfgWEnpol+R85UWoXbig79K+9gYI=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2368.namprd12.prod.outlook.com (2603:10b6:802:32::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 14:11:35 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:11:35 +0000
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
        David Rientjes <rientjes@google.com>, tony.luck@intel.com,
        npmccallum@redhat.com, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v3 06/37] x86/sev: Add helper functions for RMPUPDATE and PSMASH instruction
Date:   Wed,  2 Jun 2021 09:10:26 -0500
Message-Id: <20210602141057.27107-7-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210602141057.27107-1-brijesh.singh@amd.com>
References: <20210602141057.27107-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:806:d0::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:11:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4f81cf1-c079-443a-e46b-08d925d054cd
X-MS-TrafficTypeDiagnostic: SN1PR12MB2368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB23681B303BB434839F27564FE53D9@SN1PR12MB2368.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n0PdiE+PI8sRpNXh37+n8vC1R5eI2biR3DO2ggUDUtwGNB9DesdcZwj+gkIT1QXxXMAeAswmI8COZyMQd+9KZ6PTD0oHPLyejtsEHDDV5F3kUtluwDxhSLKxtIHNKRvD02HzinmT3N6drXZJ1b5Yw2vqeD95GxG9dg7TqTFy641OafXZ8EZ7B+H12Q5oa/t+QhREcyT92QLtYFT5gU7UgO+lHwwUQ8/XERVjQv0C4uJXWVDksBFwSUfcWnV1v9Nc95RmATRPLcmKyPDRFYDu0Z0wyDR4eglqgTCVQ00gCr7mH/e+wg1f6/55dCmqxZ3gUXcPBaHzKU5odQvZ76yTu6FNf8nRSTDwWMuwM0PMXyhmP2W/DOL12viu69g7n5XbZvNmZHiev8lSpVu92tsuVVqbN+R/j6VV2hSgVXSlYwEkzgzRLtfDCkWCJtnbXspmwBH5VJsmifcS1T0ELLvohRj1g8I/qaG7SHMokOM7egUAYOpyO/AGOK74dL42q48yYbqCAcc2AvNTtTo4LsDFHw6r0OdpqDW8t3oGnKbNQqKX6X7lmh9Ut1a0ddp43S1252evYTiUZFMGqtUKGxbrgbx+UtXENMkIodLh5oUrh7onjs1vhCJBEE3ZyYlHqXUt7LQGTenakGs+3WotDwIDLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(5660300002)(86362001)(6486002)(52116002)(7696005)(44832011)(38350700002)(38100700002)(956004)(2616005)(1076003)(8676002)(7416002)(8936002)(478600001)(186003)(316002)(4326008)(16526019)(26005)(66556008)(66476007)(2906002)(36756003)(54906003)(83380400001)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?MSvZ2usGucY5aialo4Ut3ykid2ymAuBy8EOAPR4I0524oQR9/bJuVVX8Vb6V?=
 =?us-ascii?Q?Neb5gnjRjlwaWwWojMVDxAFWQ8/Lf6rO52oxJFA9iVDZD920DbxCiaUVg0HB?=
 =?us-ascii?Q?ICysRHu3/OkcS6sr9zneVJDxyD0RlHH203WNZVKZtI7PO/u8nS7dI/f+JB1m?=
 =?us-ascii?Q?e5QXY7UYNBa1qoAknXP2u4F/z79pd56vFHeOwJNdcie1G3tmP1WC/7fGnbNU?=
 =?us-ascii?Q?8xxNCjALYMldxU+sjJ5k+evnw/iA4owLkrNxpBXQCOqlTZz0wejortZhSVqK?=
 =?us-ascii?Q?Vliko2/U79MITU4W6dr2mH3hMO+UVaVeUfMSmxQEIsdf0V+HfYd/p7+WhBot?=
 =?us-ascii?Q?aN/PldRiAuPPvkLjSKF0fA1GYjce4lg6dvP0z6koDMvJBN2fINil9QdO4frA?=
 =?us-ascii?Q?Sou63411AfdIbfE9LtdEejOAOJ7RVzHYqrd0jFr3mzL11pz5kFypnoD6PQyA?=
 =?us-ascii?Q?Q2VQmm4jdqZByDB6a19D40zl/hbu2yLCalKg6+uyqpftlJ9mpYCx1d0xE2/j?=
 =?us-ascii?Q?1uDeVc1fjLFM72qsscZJOrHzX7TAdkfMPSVqbRNyQCn042PgcVDSXoy2LqEL?=
 =?us-ascii?Q?5nwH8NmJYokCSgqZQ/moSMwzlhKYKLFMl54iD+SAs0kbvGJ15nToOzPOe1fv?=
 =?us-ascii?Q?NLmqw50F2szFT5gYEHnByr5r9omp72QsVrsXDAXDYpq5jqcT1VIIWLMhrYkV?=
 =?us-ascii?Q?KyYMH8vP85aF+l12IeNSmFwKKza9yHbzRsxBUyLjudh6OXEB1kZ+G9G3Qnlw?=
 =?us-ascii?Q?marUTr3kOGPCnnyzaWUOPfzpMD8IXYB38vWGJvZX8Wk5T3I6JLIx4V9AG9zE?=
 =?us-ascii?Q?6YM/g3/3otbiOSvCUQ7DLKOq/m8gL23QQoxOin7dpCd37XIi/p8bEbkMQGEs?=
 =?us-ascii?Q?LBuJ019aQnp3NjPSOa5dBqq6WVGHjifZSyhgH4+zclbIxBkL1tTtAAwHCie3?=
 =?us-ascii?Q?zWgcAos6uWVRpWK8po6tQKFWZZV4ljaIRvNCpmm1dKULo0GCJ9J2cHknrwwk?=
 =?us-ascii?Q?4BcPH5oH9rfmSAHQLCNc2HLLiIR8du7vBN/js0NY6aMDA8J75KV3ZEVxV8KN?=
 =?us-ascii?Q?1t+HxfCpobLeUDU2TpvsEBNSqd9BffqXwljzkW755c9nmcL476hdPShnRHFm?=
 =?us-ascii?Q?3wlgAZunaRAvhwtRV8V9I/hFtXUkiPN4mNxpgcjyY6V2/vb0fqoz8r9Xnzzl?=
 =?us-ascii?Q?D06JWoEZy2P2OdwHu7Qrx//BZ4sJZgujTxL08EP1bzYYTGbEglGmvkoywwb5?=
 =?us-ascii?Q?ZPcNKtgfZHj5mD5GPAW6MNT3qcC4bAWEYAsvIm6fdosew4ElWqUgJfUJpBMo?=
 =?us-ascii?Q?tS46oSwRJPuS3GZubJHFDmhX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4f81cf1-c079-443a-e46b-08d925d054cd
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:11:35.7429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JteIB1gYKxV7PXgV08DHYqzZ5pxH34wYuYMsIMy3l8Hhvz49Fx+XG2LoNgab+OKdUCcoZ/HyjeVVVKe70BMXwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2368
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
 include/linux/sev.h   | 20 ++++++++++++++++++++
 2 files changed, 62 insertions(+)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 51676ab1a321..9727df945fb1 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2226,3 +2226,45 @@ struct rmpentry *snp_lookup_page_in_rmptable(struct page *page, int *level)
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
+	} while (ret == FAIL_INUSE);
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
+	} while (ret == FAIL_INUSE);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(rmpupdate);
diff --git a/include/linux/sev.h b/include/linux/sev.h
index 83c89e999999..bcd4d75d87c8 100644
--- a/include/linux/sev.h
+++ b/include/linux/sev.h
@@ -39,13 +39,33 @@ struct __packed rmpentry {
 
 #define RMP_TO_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
 
+struct rmpupdate {
+	u64 gpa;
+	u8 assigned;
+	u8 pagesize;
+	u8 immutable;
+	u8 rsvd;
+	u32 asid;
+} __packed;
+
+
+/*
+ * The psmash() and rmpupdate() returns FAIL_INUSE when another processor is
+ * modifying the RMP entry.
+ */
+#define FAIL_INUSE              3
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

