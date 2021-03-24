Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53870347EC0
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237303AbhCXRGB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:06:01 -0400
Received: from mail-dm6nam11on2071.outbound.protection.outlook.com ([40.107.223.71]:41848
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237063AbhCXRFM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:05:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+/2k2gb3mWVNdfDrfABA2eYD0UKZfuJ8t6g4B6dyAJWiZ6WLJGBoOI1Fe1TZov7KJWtro4fk2WfFiEHfej/kKZ2jcx8EVsHAghJhhZxLL7WXTnQs4cuP8Bq2wKrHJgNFBil2TE125SGjXknLnBTASkLGK6J+ips2304XRJjXbFqSkZJSZYFsybdDAmjvG3+wcmw7/2kTZO89dyC+Ewm2Wbs0znNlJ+K5knnndpnBySyyJBWBfgf2/6h7MwQZjZfkT/my63iTAYVQS9aGVJ0ft3q7lJIgdzScALA0LyUkUsIcIr3vKGlMmxcT73nKp0FFMfU9SUzXWoSZbnz4PrpwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zs710fNLbqRp3/buPF9DtwxvV6+8m/Tb/z97SaRom2U=;
 b=By8vuOuoNNZlzP67In6kQ13x/NOA+O4dEllQafoJcmm1R775QinMQm8BY+XVoWD7KOAZ0G1EMPolG91r5HXw47lsqnP8a9kyA7Ym1Y8/B7TNI9HnTIABGA3dStqbPAH9txiKwsqasXu2rLI439lgR8DnKdmkTnFaazkWisLfJap7EXJIeh3mylNHOkdxaw8+rGsFhiHkPZejRMkeRaRWmAvZYiyG2Am2Wrwu7bE53A4AzxkprgLMInP/09dNj4W7Ghp7qKqw04wm+HW0iLyVDSxirXKCzFP1ErLHT61gFhNkktoKr4+caZVMcrxu8mJg1Ck/WNmlZkz6AIaGjVtUiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zs710fNLbqRp3/buPF9DtwxvV6+8m/Tb/z97SaRom2U=;
 b=XDLnRY1hToMW5S3NWf5z84gO/9/QUpQL58aGy7xecJTm70wQsYiCbBavlxvSODYnZDBD1Z+nr7pHY6tWcyfbxUdPd85qhnYshQvSPmNRaa1vbZlImGm4W9qEPjfmeeLVcwUGg8ZjYZyrRcGNpKTVwYKjxwgxF+SA5nk8lc2UYaI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4382.namprd12.prod.outlook.com (2603:10b6:806:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 17:05:10 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:05:10 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     ak@linux.intel.com, herbert@gondor.apana.org.au,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [RFC Part2 PATCH 23/30] KVM: X86: Introduce kvm_mmu_get_tdp_walk() for SEV-SNP use
Date:   Wed, 24 Mar 2021 12:04:29 -0500
Message-Id: <20210324170436.31843-24-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324170436.31843-1-brijesh.singh@amd.com>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0210.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:05:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dde0f0c5-b118-4612-6212-08d8eee6fb4e
X-MS-TrafficTypeDiagnostic: SA0PR12MB4382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB43821DBE54668AAA538E5607E5639@SA0PR12MB4382.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nFTVFu+Hm2tfpSIKax+V9qs3u6ZOm5Qrkpz76f6f7X0cE0nti/vm8Tof95aoRYcSlhV+RU/AbTdYsBqoCfNgNehA8MD3ra1FClmXCJR49BNbjjvdFFnvB+ihWqOpkRcvemRHmz/dtLKKFZPt4++323s0zfaFbhWc5QcNwUGy2BRnU8ccukm8itwyoUwZInRl3CH2qYZfNOdJwdr01a9ipZTl4tyLnPov+RaCRvNFljwyK8ypVkA/IrLArppBtnuYEcKYT/2GX0DvJzccObOHd+jWnET5yJcCGH9xSiOsxoYexLnv4vQUz7ccajJ+CRrF3QRSLPiTK/VjfGbeJ180xgPGOtqXwZjpErkNrR/e64h79o+a7prAUYSyBvgQn1idYosyUnLhsLwdlWvqZ5mWo4NbAL4Wee8uwdtM7epFhOiciYt+oKkdcjKvkC2F6UKVA3JAvjmp2VzeKH7CiMk4NS8uuN9b3cI1aLsghJkD7bKMZuGC+hi3sfQQ5Z8Yv2KC62j7Asj6UPWBUIqAqiJLajBqApaHvKPA/LFjfBtCmOLCEkNPnPvZoIR8142b8Gz4jbnnYXyj/vOfO8QatnAf4Zehc7oiIN5S9kGGyQfRqf/jLSduusS9zj5dfk01/dHoX9nuFcbruOiPN5Oi07a4bQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(6666004)(44832011)(66946007)(1076003)(66556008)(66476007)(956004)(36756003)(478600001)(2616005)(83380400001)(8676002)(2906002)(8936002)(26005)(86362001)(5660300002)(52116002)(7696005)(38100700001)(4326008)(54906003)(7416002)(16526019)(6486002)(316002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?75UguT9FVoQRHZUhxLfC9hiRsnR9DUUGM/xpTG4sbYimyyrVkwpl3fHHqrXe?=
 =?us-ascii?Q?e0lZEyHJEMeXDbUBhtNTPd5Y5xcUZfqFdaxTGO0q/hkTBaMkha7dD0F0hdnx?=
 =?us-ascii?Q?lZHbZCaw0zPh7dTg4WsFmDApQXXTguvM/5cal+G50PY8Ak++ygqjfqoXfXON?=
 =?us-ascii?Q?KmMhSQUSbm45iLGJW80fBVdZBsVmoxXSfKLPTnuZmvhgXFvWJ4VvsPCjGrcJ?=
 =?us-ascii?Q?FGD3Vnc5Q4yCHbfrnIcvSjj90pWriBOYVWVpubG7b10SOCUIOm7faaEdZ9su?=
 =?us-ascii?Q?U98kOGT9Y5Icu8xdClh0FIg1GWYIEQMRYodJdbJAjKv6y+0gDc+ghSYJN6+y?=
 =?us-ascii?Q?N4P4OrIdbSwlJJcvxsmn4uIqVTKErrSTtyEfWxFD6Iq41R+vhLLLD+KtEmbE?=
 =?us-ascii?Q?ZvAe79FeuMabH7rgOVyJoDSKxcQcSbk45yUT96SEHsXG3qcKMGSZUdd7KQDd?=
 =?us-ascii?Q?PojPR5L+9gWxcJWfueSbUuA+LxNRhPBjPBUaE3sv9QHWuVXbtjyqnqXN9kNT?=
 =?us-ascii?Q?/TeERkYIJugU4zVc6BEwd/PeDshC8WSAiUtSmFcC2cpXsgDQHlKnPrv2vFqw?=
 =?us-ascii?Q?WrBF0FVmXrD0FKGKyh+YgiE0gWgu5+l3p1hY1dHuXgvtUa5Klm3ZRkXlGDBN?=
 =?us-ascii?Q?J5mXskD6XOHSNvTfqps32T4rvmZUMvZcgYny4MbICNxehvMq7RTc2/2e+zq6?=
 =?us-ascii?Q?43Vjl6Ywsz6rMK5521RYS8t4jMVZTkyOOw6uEDbXYBxoszhDnEHW7uVZoP93?=
 =?us-ascii?Q?o/juXcrVxs7ve6AElfSsxNaw9f/p826+dlOWI/u80rWZkZYWRl6llHMJaSyz?=
 =?us-ascii?Q?i7XdW41G/LS+HWpCqDhDbJVqVB4ywN8LaYuI7lnVBVu712RUfzAOeYSiDcjh?=
 =?us-ascii?Q?laOD7zo62GYNNdPk0B4Ba21PKqkv/pCvgz++8dsJ65XDfXItyYFVPRjWinpD?=
 =?us-ascii?Q?cor96EPhzr2x3HARULGHnDnsgU7HpfrIufa26E+n/vuuExqkntaFhqc/Z1Yn?=
 =?us-ascii?Q?6nCsPNOxvPCQXGXx/W3mpKx2/OsWjbKRuWgRuOaZQUWIlcHdbtuM00K53smv?=
 =?us-ascii?Q?a4gmKy1USEJAukL2jOF+YM5N3PeHY7mmVZQIbMISd4QkpgJuDLOUBBJCyDE0?=
 =?us-ascii?Q?cdHbjUzi/cJE7MP9yenrSfhg/hRMGalhArbUFVIvWX6/OJxXCWQU1n7D/nCM?=
 =?us-ascii?Q?AszPyijGXqsKxxcex9xOXpQpC8cTNN3RN/OBKpn9kAFHQVjTAW25Cwvp2ri1?=
 =?us-ascii?Q?k65w9ZbASd7HVPfiZ95eG9jP8n2LLdGVlgnWIAzFK6r53QvZZQM/SnFxA4LF?=
 =?us-ascii?Q?aiEBVEZiOctVt5elulbUQ1Jb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dde0f0c5-b118-4612-6212-08d8eee6fb4e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:05:10.1010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J0pVuxeA1o2eF/Zz4RBpJCm+WnNxASHpTnAGZysMMdx66R0HPBdhS2q0KKbnjSrDX4gCkl9V/P0iO8XUO9g3RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4382
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SEV-SNP VMs may call the page state change VMGEXIT to add the GPA
as private or shared in the RMP table. The page state change VMGEXIT
will contain the RMP page level to be used in the RMP entry. If the
page level between the TDP and RMP does not match then, it will result
in nested-page-fault (RMP violation).

The SEV-SNP VMGEXIT handler will use the kvm_mmu_get_tdp_walk() to get
the current page-level in the TDP for the given GPA and calculate a
workable page level. If a GPA is mapped as a 4K-page in the TDP, but
the guest requested to add the GPA as a 2M in the RMP entry then the
2M request will be broken into 4K-pages to keep the RMP and TDP
page-levels in sync.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/mmu.h     |  1 +
 arch/x86/kvm/mmu/mmu.c | 29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 70dce26a5882..e7c4e55215bf 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -110,6 +110,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		       bool prefault);
 
 int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code, int max_level);
+bool kvm_mmu_get_tdp_walk(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t *pfn, int *level);
 
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 					u32 err, bool prefault)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 33104943904b..147f22bda6e7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3828,6 +3828,35 @@ int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code, int m
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_map_tdp_page);
 
+bool kvm_mmu_get_tdp_walk(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t *pfn, int *level)
+{
+	u64 sptes[PT64_ROOT_MAX_LEVEL + 1];
+	int leaf, root;
+
+	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
+		leaf = kvm_tdp_mmu_get_walk(vcpu, gpa, sptes, &root);
+	else
+		leaf = get_walk(vcpu, gpa, sptes, &root);
+
+	if (unlikely(leaf < 0))
+		return false;
+
+	/* Check if the leaf SPTE is present */
+	if (!is_shadow_present_pte(sptes[leaf]))
+		return false;
+
+	*pfn = spte_to_pfn(sptes[leaf]);
+	if (leaf > PG_LEVEL_4K) {
+		u64 page_mask = KVM_PAGES_PER_HPAGE(leaf) - KVM_PAGES_PER_HPAGE(leaf - 1);
+		*pfn |= (gpa_to_gfn(gpa) & page_mask);
+	}
+
+	*level = leaf;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_get_tdp_walk);
+
 static void nonpaging_init_context(struct kvm_vcpu *vcpu,
 				   struct kvm_mmu *context)
 {
-- 
2.17.1

