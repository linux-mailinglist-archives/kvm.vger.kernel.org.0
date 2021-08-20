Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D48753F310A
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236028AbhHTQGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:06:47 -0400
Received: from mail-bn8nam12on2059.outbound.protection.outlook.com ([40.107.237.59]:3905
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236451AbhHTQEp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:04:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hwXKuvmY58bwTogxvAxV8YSvQGnrXdInFQ1g1xodGPB3xkMW724t0rlciyxP+VOR0WYTX8dVK/23DN9tuW4ntARFeSn7HyqtWoygD4pnayKr/8Yi4RehiTvz+eJo56YkOQD7rajIfyk6VL2MQxFCmEq7WfNddAGwOdeL34qH973tVr9aoVr1F/H7K4U8tRynxPpkuvRWK8L7zMttJcK8rvw10iLkasOW2ZgZ78DigF9g2kNLVcne8txooiaCmeLnyLkbh7KBKehww3wqnbiZTslmEw/Cxn3mbEFWlVo/DrrdSJfIhfDbOHjjcCp79s0EeXxC2ErGYqifyxats4/xGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pNxh+iPFc7gj7fjVPpyPybIIus+xmeFB09nTxgEXS4M=;
 b=Y3+oSAtDGOlwSPb00L7YHiJ4B6OWPbw+aeLmqepqEBqedS7Aebsxd3khgcvyxDZWtXRKcSBQwzbh0gh/IBcscHPrtdBg55ROiYgXJ5tj/X+rkPGCJ4XrYlQgApymFs3DSBqe+rYwUU1qlF+7iycwmr0+n8Ud6rCVKVIx+Mqhv69WdG1k+VLxgfizV8RK2BCbMpzHPVG9I5LFV+kA/6FTDz923zSnGlD/XfJbPmIDzGLaQpMz4iTGrSr2xLKifXEb9chqOIqy2EX11vIpQI8wCXBQJTZ7psIp34ZqfpjFjqpeo+vj+d/rzb5/UxRfhzhyBQtWPD5Y+AIdE3AfhIDo2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pNxh+iPFc7gj7fjVPpyPybIIus+xmeFB09nTxgEXS4M=;
 b=pMtrgCBlDIh7WeOiDqcuO17PlFCi5eQb0z/ffQuV60agO1QlAkVek1gNkCCBxGjKrHBD1EjhU3mOkyuUiNmw5XTndCbyLRfBtncQJ+cF5Z6c8eUbBuYwcNKGE8/DyA/Udj4ew5NuxiN4gY+vqNXz7C5eAiCIAgtiF/Pzcx7uwoI=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:01:11 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:01:11 +0000
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
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 v5 45/45] KVM: SVM: Add module parameter to enable the SEV-SNP
Date:   Fri, 20 Aug 2021 10:59:18 -0500
Message-Id: <20210820155918.7518-46-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6b9b0f6-6fac-40ad-672b-08d963f3ae99
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45091F561EF5BEAB08D8EC5CE5C19@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2V5HZHsADss/CtDzuwParXtu4Njee156SYo3atFQcEuIllRtvF27AOLXlduRr6Kp7a+itH61EF8b2NvlXSlrgKzmEwgq4sdPuJ7lBBzTHOYRqCeQvJGGykkBkeVS3pdz4EJc6MIB663Jqh6SXSfC/d/mZVhAWZe3o3AcgocL1KoZ70AXQQkyEBsTmFlJ9ZxXVh5Tr4cOVMBsBLSfnff5KqUWFvngJ4QvuM2w4z/YG2kLC1ghC9ynN5HZNcKll1QVCZ7Xl1K3jLezvseSNSeZ09Wv/0Q08gUQqQdKqLc6gMuzhtJy5Ar95R4dqYmokHBWZUrjMrY4qcapvWnpszg6PKZWz1XoSALGGdc0N8XwzQjRNrMqa4L0+NUdNL+n9dtEvBXdYtarsdXxM6Dd1JJTzqsJZm1lF7tyougqDgkdAS3ecl2NKT7xzM5CNRKAmhteA4igmNT58mhSSMooGimoZCBvnbJKoTvlz9zrjbfpQk2Abu9pr3HXfUqm5zI8X2B6SCichJmHovs5tQSBogY0Itjq8dOQhKF2DKOsWOUNjdxfyfTmv6hqitUN5osqrfr6qJq+Z0YrqaeXuvrDzZ4Wj4VssfVTf3k0PUkieWDsvzWMlJq19Ommg5aEkQgRPBzgFW4de1pzA+DneXAocf1S1ozZ+Cbx3ewchtIFv5wN+niPz8nkJ117tFQQcTBI/PlwKmdEfxQvHgNncIBbh1eKXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(4326008)(36756003)(7416002)(44832011)(54906003)(316002)(66946007)(66556008)(66476007)(86362001)(7406005)(956004)(6486002)(2616005)(2906002)(83380400001)(38350700002)(38100700002)(186003)(5660300002)(8936002)(52116002)(1076003)(7696005)(8676002)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tVGClb7fi0ufWF6CVKpJ/q7AaishPnuj+lu8Tuwhuz5h8UTOBLl9PBDdNOnW?=
 =?us-ascii?Q?+h5jhHXjqUmF9W4WYvHe3eqSXGz0wB2eJpCPleKn8VfrRdjouSoNdVF9N3Na?=
 =?us-ascii?Q?wWWieuAtRk45c2N8bbUAj/UV3SEa1nKiN+lZrk4k3CjnMgJYVrP/7Ug1VWVc?=
 =?us-ascii?Q?aLK+wk+rebXS9zxcmUjoVC0v5KU6LYx6G0ZE/JeroqfAesPDJxp1CM+wibcn?=
 =?us-ascii?Q?vVYUp3mIg5QP8Fg7CCKn+ktoco8rpGazDWjhAOJxNIFSHFTSBX4A8qSAgpYU?=
 =?us-ascii?Q?5j3urtx1lJWkosCWZzSDG0FmY0UK3s48/ZeogeOpSQDqO7f4nY4kd6370nIH?=
 =?us-ascii?Q?aXVt47C879y9dm5fJSfi8bsU3lBcPL0h6h151CkUhUsNZTZjfIdPK9EWysqC?=
 =?us-ascii?Q?GKWg8gv6x8canjgTWIllBq7JmYQGg4LaX6H8D0z1UgjhaFANJEyr/v7yT1VM?=
 =?us-ascii?Q?uItG2Olcxs11rHvi6BixYe0NqVeoHBH+69qQAKiTzRmVQahmAgQjjAA5w020?=
 =?us-ascii?Q?RgujRkTjyHVTnaXjjjwczA/pqrnAMPOYu1yumncyHVgdVduZAQCWeHT2nVqb?=
 =?us-ascii?Q?7Lmq8OzgSK6lbDYBW6Z+iQ7rHa3AqdXNwQLwUHQnDE2euYSb2FpXog2s5RZp?=
 =?us-ascii?Q?3b2S8oa7gph46/U+vknHnBOZwt5STZWv1WGm9d8fRmNGlT/yBfucXc9SKLOx?=
 =?us-ascii?Q?fwsj2EH6cii0eUFxZ7PF4C/1qi7zPvm5LTDX+LewCnG/SW2N5ziP3Z/XaB/j?=
 =?us-ascii?Q?rqvMsSA6t/m9um7+/kcqOZHpKiJK6vhgYzSxDE4INB2KynnZQJk8rtdqFCuD?=
 =?us-ascii?Q?AZRpp2Wiu6faplcljv96vCZkXsmfiXOpdGTuKm5DBpN7AtJQlcq5+2wBd2GN?=
 =?us-ascii?Q?ybVfxtczwzVtKcowRfBPZXgWLeiDJgOkwPjD+xcf8xIvbXNsmRKrujo7H1TF?=
 =?us-ascii?Q?oNEIqjuKMcyflnJedgedmdVYfvXe/2fPTPkEA8+UnfDAmz54otQKrXrR880l?=
 =?us-ascii?Q?bjETULXYARtsEXlc8ywaOJrWvuRlI1wdSbuIq86A4oMdyg++7CIqUPHhYqWW?=
 =?us-ascii?Q?Hqunby40/jQQvXapsJDImflaxxwVLvIzzqycmeP5FPn0zi8dghYF9BAJTyxm?=
 =?us-ascii?Q?u7O6SC3yO9L6rgdzP+vC6nG+tto8leRnBb2u/uvG907xeDUW6qVJeAV4ScvS?=
 =?us-ascii?Q?HCyxMgEikZ7vdeUXYp3+CEsNkj8zxUiOVe6R3xNZKC4jYWEXRLYpSh6wCngs?=
 =?us-ascii?Q?hTDatuiR+v1A+eIroyM3zZ1AhKsRRw0qp5OsJ7sRy7+/cdcrqSgQ4qbLbEGK?=
 =?us-ascii?Q?pNfd+uFGYSycuzLHWUf1ZSTa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6b9b0f6-6fac-40ad-672b-08d963f3ae99
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:50.8956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ISmLP5CVBlVwdJssJYG77YIYuAI0jrytQsWay2HGyE8Fiy5HLU8bbk44onWX+5LWbjhUKD3XmoC/THCMh1nWxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a module parameter than can be used to enable or disable the SEV-SNP
feature. Now that KVM contains the support for the SNP set the GHCB
hypervisor feature flag to indicate that SNP is supported.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c | 7 ++++---
 arch/x86/kvm/svm/svm.h | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 151747ec0809..0c834df3f63c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -59,14 +59,15 @@ module_param_named(sev, sev_enabled, bool, 0444);
 /* enable/disable SEV-ES support */
 static bool sev_es_enabled = true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
+
+/* enable/disable SEV-SNP support */
+static bool sev_snp_enabled = true;
+module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
 #else
 #define sev_enabled false
 #define sev_es_enabled false
 #endif /* CONFIG_KVM_AMD_SEV */
 
-/* enable/disable SEV-SNP support */
-static bool sev_snp_enabled;
-
 #define AP_RESET_HOLD_NONE		0
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 59044b3a7c7a..9d6c51e92a79 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -608,7 +608,7 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 #define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
-#define GHCB_HV_FT_SUPPORTED	0
+#define GHCB_HV_FT_SUPPORTED	(GHCB_HV_FT_SNP | GHCB_HV_FT_SNP_AP_CREATION)
 
 extern unsigned int max_sev_asid;
 
-- 
2.17.1

