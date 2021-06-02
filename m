Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89822398BFA
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbhFBONl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:13:41 -0400
Received: from mail-bn8nam11on2088.outbound.protection.outlook.com ([40.107.236.88]:32416
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230475AbhFBONU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:13:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OngY6rbT0wypgMLP8aysX4zw1vmiqV6M+fl80cwoEnIpTX/Zm4pfDtGukZzouGCNoA7Zo97OnzbRU9MzJbIsj1gCZLrd9x18dVYvF0FwgkJQMAzuBz2qKVSHw5fKF+x0jk5VpYKMFzlJj5lVseLj+ivaYmPz3DpffRMYcwe8TnhyDNd4PKQUa4S6qwMgt3BBVgL1hChXdA1mTNxZy6eQnVFNl+WbpUKk4cbV/eOHsZ0pmZYkUOVWFfQkMD1CY60Or1L6Ag2A+DwwDgtbLuvBiT9fEDmBIxsvilWR68JLEfUbORaSj4bEiAH+4oLycY+mDR4A7pnXrac1mENFRWo/Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b7OcioCq+8o2r70L9N0hO5CldAYJzBAXRKvcHyOO4Vk=;
 b=WwlM16I8VM6iLv+PfMlal21ZXShZq3AtGaB1SxxMZvGUihdqeeG0V4Tgq+auz9qjczd8H3XVYfvhmBXFAsmJF1O9UhnoZrG5yPnhNpFponUw1hSoi5qpVfJYTKnFO9YhwLfH5v2HGcAlVI711mvs63Yarnd3Wn5yJoNN8dbJgO0sDV30KjyAXhvsRnPFbwvlmFDrF3VeR88aXfLpd+Zk9XtuJPkgfXmkWo0hNe80NPFldHoJZd8k0bgwi78myHk6dUXMH0349SkzbVw+nfMjFrbZ9L/1JMrmd4UwFw5LQJ00xxoVWhwSPpOhssSSjhoRJQFe4jKNbk83B8AqjIka8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b7OcioCq+8o2r70L9N0hO5CldAYJzBAXRKvcHyOO4Vk=;
 b=D41kZAffHmqIGfImSfUIeJbQTurmH3OeO/rPeRJO2sFRST6KHYzWf2y8Wm5JILIlEHY/vvqQCvXvvaeFX1rCp6BgWK5dfGtaHOWBWE528td14Ypv0yZTjvkclP4V3b+3rNJjev2Lg6dh3WrPO5aW0Yp0PQEfFT99vH5a1SSnrnE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2368.namprd12.prod.outlook.com (2603:10b6:802:32::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 14:11:34 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:11:34 +0000
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
Subject: [PATCH Part2 RFC v3 03/37] x86/cpufeatures: Add SEV-SNP CPU feature
Date:   Wed,  2 Jun 2021 09:10:23 -0500
Message-Id: <20210602141057.27107-4-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:11:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a896f7b-c3de-4879-a4d4-08d925d052cd
X-MS-TrafficTypeDiagnostic: SN1PR12MB2368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2368B2AA0BB682967CC006BEE53D9@SN1PR12MB2368.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XFtAUz7dNHfIKvIYaty1za8+kv4PhI8I8/sR6eF80kVnTgqE0WZpU8ImGjIFVTConJO82RokHNdD7EXyBkFW+0iS4C2shKdDvQlXoEUm5r3BeFQLbhkBaak7zPRBGoTVqYVDOAUunZhRPxjO/dO6IuQ19S5In8ohw6aWvxRf/O4H6D3gugIVDASvRAMfQtIRz3iiOBJBEcw8UMukdmDcUXRYo+bfKU/cYyUMKGp4z1x1fnxgwPPpxJkuX/A7W4CsAIvAbC0//GPajue63mGcRKBMVy5zTdL0+4GJ71JMJoUCKKTwnwOWeshPTOJvelmCwKtFqECy+Cg4erj+bFZ8eQhlxQDew+P4spp8Kjc4OwH0M9wP0vGSQCBqUCBtus8FOMYWiFE1Wnl6RiBIi5sqBjSTeiPYiAKwYhjv20mdtdojGJHS7YhcvvNnHEfbEBk6U8B4LteP1ktN8la6b5LNnFm2EltSgzfX3Rp2yM/gWs4ToYjGK6P9/77TdoVJ1Snjh73DUPW/xe8ZcIphfutMVMfcgyc9LPeDItj/TjeYxhZbTlqaI/aseYRVpwbwFmdciCOaHknnLmJ9bP4WfM+P45rIDv7Nokqvod3ELB7XRUo/LKNvUtuSx0l5hWuit8YxLkefapfUdMHxW7HQHpkxLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(5660300002)(86362001)(6486002)(52116002)(7696005)(44832011)(38350700002)(38100700002)(956004)(2616005)(1076003)(8676002)(7416002)(8936002)(478600001)(186003)(316002)(4326008)(16526019)(26005)(66556008)(66476007)(2906002)(36756003)(54906003)(83380400001)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vtvrakr1FW6s83Go0DSwwGeyF3mRP+p+2hgnPQkvF+EXJ/QDKydOip7vXJ0A?=
 =?us-ascii?Q?V/n2j54AqcLt/xnuVd1vlGlv2ZLXPj6sIQot+t6mpoJn68IPaWU7Bun6oL2M?=
 =?us-ascii?Q?SwlmcGT2XNkmTtW5REiVxMcob/aXqcKdtguDKi4FjgEnIFGQVXBOxSqSCCrC?=
 =?us-ascii?Q?K0VyZQmXqa0D4EosJQCIfVOjwti4hWTQUVTr53EgzaDggVvBi7RwGqkn7rLQ?=
 =?us-ascii?Q?4B6W4oinVHfwrQpUb/8iYI2vSQoYF83Vl+4q4rlBwQPzRqC1WslBy6CTzN5G?=
 =?us-ascii?Q?MnuPknLSzvuC15s4+f9GiLn4HYteA2LcuVhrnT7ckIIBjccEwI/emoquUvit?=
 =?us-ascii?Q?IzlRG2DZ8YchqZTyXPbzcJG51zP/lkmuHmEp9aL4bm5hFfYpEYfIq/8TBizP?=
 =?us-ascii?Q?HVbjeZwRX2nB2S1OjTTAHC0u3KWrumCvU+pJgNZEI4XPieBDM1XFCrrMB6//?=
 =?us-ascii?Q?fDUIkFvfJI3Zs2TmoXqXjRsbtpy+yKcdUeSlv8LRI/0aLYYO70mW7gIl6lsY?=
 =?us-ascii?Q?sFfmMLiGRlxLNEvNbTMbOONdNg6SVoLb4WhFhUoSDOMnYtMA8dC7+3EA4U6T?=
 =?us-ascii?Q?8GCeibnbYbosTLgHaBr37NbGSJufSd16Yva3/CvUdx1rtPAoHs6yQbiE/Vvb?=
 =?us-ascii?Q?+5sPeH+hV//tS9SEp5PhqiADVUzxP4E4mTxuQ1dHMDLoIyJX+chp1+qrVDD/?=
 =?us-ascii?Q?ao7v6xpEE7VMm1K12Bk8hjS0RqlQFN90FtjRcdRmWtnEhsDf6CDlgbBFvrJ5?=
 =?us-ascii?Q?Zj3LR5EvRZ2tbqAsppTQ9biZco/GEkfXTIws1M9aZ1NLhr6zRDzEyKSvpiXo?=
 =?us-ascii?Q?RnTc/HCmUgWCIdosYectMEpM5VjjKK93qwC6KOGmw6t4ErEX/Gq382JjPigI?=
 =?us-ascii?Q?OdgMyPvMAHgK5kCoXUI+niUARNELqpM246/cVH0gaLdBHLu6VqDAYo9YggYb?=
 =?us-ascii?Q?/US3QvCUIqAQDCwURVsQuzkhR4EPP2eELIFuIv3jNqLHKoNEgVykBMuyUouB?=
 =?us-ascii?Q?3ZE5enf7uzgGs4h3i9DgIWM0TKscTEICyt50kevA2oFMHQ/9z18Xx1B20lAa?=
 =?us-ascii?Q?bTBGYVwWZM0rmuKiYBSwYroWfrsvWNKn7gGKxjjOU6FzqKHD5095f3H28cJs?=
 =?us-ascii?Q?DuSMUB4TexdCjUgoH1vCtNxbeoUEKJhiIw4Q0HpIUDwjJ6IKGZ77BC39KsKh?=
 =?us-ascii?Q?CnP03249wc2+99dQ0ovI+aWJT0HR4onZD1mLOPmdyKiTj5/oL7m7kcx3omc5?=
 =?us-ascii?Q?F49pc2OeUiECqMR7TS8vKPZDpAWEzZ4uCnDyG8Z0X946MLFFknihwN33+P5h?=
 =?us-ascii?Q?zecuvNE8udyYPwjhub69va0q?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a896f7b-c3de-4879-a4d4-08d925d052cd
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:11:32.4178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AB/Mf7eSNU/c9AgfTggRoFxD5RW8XWWy3pJDshAYsb6GKIu9Uy+IAd1AeZ4bdgXxEEFnpj+IIgY2nsw3k7Di4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2368
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add CPU feature detection for Secure Encrypted Virtualization with
Secure Nested Paging. This feature adds a strong memory integrity
protection to help prevent malicious hypervisor-based attacks like
data replay, memory re-mapping, and more.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/cpufeatures.h       | 1 +
 arch/x86/kernel/cpu/amd.c                | 3 ++-
 tools/arch/x86/include/asm/cpufeatures.h | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index ac37830ae941..433d00323b36 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -397,6 +397,7 @@
 #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
+#define X86_FEATURE_SEV_SNP		(19*32+4)  /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 
 /*
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 0adb0341cd7c..19567f976996 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -586,7 +586,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 	 *	      If BIOS has not enabled SME then don't advertise the
 	 *	      SME feature (set in scattered.c).
 	 *   For SEV: If BIOS has not enabled SEV then don't advertise the
-	 *            SEV and SEV_ES feature (set in scattered.c).
+	 *            SEV, SEV_ES and SEV_SNP feature.
 	 *
 	 *   In all cases, since support for SME and SEV requires long mode,
 	 *   don't advertise the feature under CONFIG_X86_32.
@@ -618,6 +618,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 clear_sev:
 		setup_clear_cpu_cap(X86_FEATURE_SEV);
 		setup_clear_cpu_cap(X86_FEATURE_SEV_ES);
+		setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
 	}
 }
 
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index cc96e26d69f7..e78ac4011ec8 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -390,6 +390,7 @@
 #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
+#define X86_FEATURE_SEV_SNP		(19*32+4)  /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 
 /*
-- 
2.17.1

