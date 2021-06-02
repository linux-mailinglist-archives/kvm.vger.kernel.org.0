Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A057A398C58
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhFBORp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:17:45 -0400
Received: from mail-dm6nam12on2070.outbound.protection.outlook.com ([40.107.243.70]:49033
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231694AbhFBOPn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:15:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vhj7V1Yerck7avwwPVslEbgGGVx9J4DmaVfeo3LTPL/ai5nbcvzx+XqKFhYZ+Q8HQ/012RYRu96/nSTl7Do46pURi4VPu1/YhN4MAeac9uqVu8687FXY6GNN/1lEq9DULwcHTqRv1nJ/6QeGRTryCXNj7+aEjmqUzC/vc/RZglWSM8vVZkwgmdD8knXOVTJcNXpk2uI78G1pYAcsjPHbAgcHJvQkklt6Zw80wtHlJxD/ilf6OU+Bg2OiF+/RtbS69/V5DY7tOgMinr5SK9huaCYxTDQYW6vm53xJmZ1viQWX/NDZAhAULJ4AwmJ1k5c1VIxRZWElIbe4weS+NmR/dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7T/72aP4MqlEHsa4nqhnFTAbPsOy6kaWC23U4dSfW6o=;
 b=khMH1nsdwIxR6ua8yCMK7rNHC0wDzhhrWHrZQeYQLGvuX0Tk8pe9F/7b0brpepdAMMbbmrgUCzCcHU6dsauH6TiMB5/45yeSBYV8+35lFq5G29v+4Y0Pzzq/zLWSHIvoUGQs4dpLypD1poFOi3HU2+z4aXSFfyVkP/kJ+EaAtytQOets6piO1jmHNnwCJb2SSQs3BrsqgnLXEXdg8Pfq5xW+mJj9y9fakhlLRjp9ckAbVcQgXhKlNzUVHN/4svm0snZw16poiaZyB9LCkUG7ogzHfBdblimo93Fwga5eJ6A+uUrfzl1VrbRjU7zQMxozKZLqtRc74V4ubqspQVWCtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7T/72aP4MqlEHsa4nqhnFTAbPsOy6kaWC23U4dSfW6o=;
 b=c11byFiTTDiDICuLKYDqLGwyP0Tu5zWnF6TnMeHXjq8ogQl4iJXQf4Qr6m5g9e5UNAzTr+oQ9uTIuMV4+RpTF10ohsnGW9iZksaJnYlgasZFWuGJAta2K2nVfxuGy6yvLVZ1Y+9n4/V63M/C2bJawxt6lajuBu0egHfeEG/UIxQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4592.namprd12.prod.outlook.com (2603:10b6:806:9b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Wed, 2 Jun
 2021 14:12:02 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:12:02 +0000
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
Subject: [PATCH Part2 RFC v3 26/37] KVM: X86: Introduce kvm_mmu_get_tdp_walk() for SEV-SNP use
Date:   Wed,  2 Jun 2021 09:10:46 -0500
Message-Id: <20210602141057.27107-27-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:12:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ee46e39-6774-47e4-c8bf-08d925d0647a
X-MS-TrafficTypeDiagnostic: SA0PR12MB4592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45922F33D3ED1E9E801AFBF8E53D9@SA0PR12MB4592.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6MdempsK8iG04LR1WMt6mF13uvVQpoyrtUM1NENiE3o9o9bphpHL58afDaczoow0cngBSJXCv8hSP0zWkGsj+SXLr3ZJrapcxU83W3F91pYO34BT0fgdPeBLfGrkLvmMNEaUNKQAMyabjUkAzWK5ympOiDhZvHBeMx8VIk891PIaRPwJSCjqhS0kk5RVefxSluN1zoalUIPJw9o3hYebDM0PoUtZOlsytfwPkFkpymYeeIH+/G0MMotb0gyVR21Vk/cCHMLWQolGx0NhEvAYVfFyNO7r9iNkrN3XHqRRKdcetFT65CO6MoyMzaO6TY0S8TSf0P2jj4G/M1SiSkRqBmrjbJjcwoiaUgRO31D/GE/+xFS7qjdEuQY2YzgP47QodaeOAPqVa5+rSAqZ1vgmb/78Y7zjfRSCt7e/2H9mw1DjykMeW/7kbJ6Z6smp9Rc0n2e9cN3KQy04L0XumJKzB2+jJEoBr/+A8ediSTg96Z41WmDUNlKwK5KN+idvoES4zbi4rwwDdfUSXrl6U3eal6jW3zjO8mBlCZNupN5dX/qV16hDmIAnUhdEDYohpp4BgPqq7Ihnvngj45w6X0lD5StTS9l/K4GbfLGbWm0wXqwJkkCURq2d7HrfMxcGOwPyDX6VMs4T8by+rHvXdgRhGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(956004)(8936002)(8676002)(36756003)(478600001)(54906003)(83380400001)(1076003)(44832011)(2616005)(6666004)(38350700002)(38100700002)(5660300002)(66476007)(66556008)(2906002)(66946007)(4326008)(26005)(86362001)(186003)(7696005)(52116002)(16526019)(6486002)(7416002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?j0oCJpLRKJijMMoQ/ktEIWazTxAnfn63y23AYNuY+4qbLaZBG80raoq8lgSB?=
 =?us-ascii?Q?jMyH8u0jWaRfhoEjxrOckaXIG0ATZ955o8gUmoiY3b3AOcUMo1zuNk2rn+5X?=
 =?us-ascii?Q?F7BFg1r3xVMgckSV0VFErUw4NZ1OIEC6JPCFzOYZcFTMP3I8d90IZMA6qAgk?=
 =?us-ascii?Q?zVOU+3MfwNnWyUJAov6vDkMjgeNm1l1NTiFaDCmvsJk58uLZwkKeVe5ijic9?=
 =?us-ascii?Q?1nD5Wxsy9pVZAPiUqqpEQ0nGEJhn/Lgg4NxZoxs8e6oxMkycxLhKEc6Qg7Sw?=
 =?us-ascii?Q?ynwoqEF5n1qx5gvZdgzPDOgNuxC93FFnza6SeoWH7H9V2mZj5x23dfXFYb7p?=
 =?us-ascii?Q?aToeWPJRgby8peV9nVncWV3gvG2iBVfrEUSeVclBRduTFlPn1rBIA3FoZa91?=
 =?us-ascii?Q?GRIqH331Ij0t3gGRzxBAT1rgszSzIRyOqbyZNgoq7lZQm73KPEFaUhIl1Hxc?=
 =?us-ascii?Q?+/RVdbFVPG2DYhdfmrNzex5XD6jpv5/Ye1jLiAMWV50iE1gJcO7JUqcSkaH9?=
 =?us-ascii?Q?UyiYpqgWzYkJ1PkPrRhrSsC/4syNtoaS1LnnNCaTiywzG1TtV4GT4V1vivtN?=
 =?us-ascii?Q?zooTKaU1qvRwqfXAWCzU8dxQtW5/PW5Wgwef64M7Awqhft3MtM+/CzCJuQ1s?=
 =?us-ascii?Q?5X2hllqNvFcmetHK3qJiMU9+1f9Wi+y4Tp+mlHEBkJFgib8cPa6uwaYzSjjj?=
 =?us-ascii?Q?im6g8V+SBlyfY5rXgxmSM3n+O2fOh5mII0WPsimj4Q6NyfQh82+3pEg3kJdp?=
 =?us-ascii?Q?9x3Ofn2O9X3Z59kZup54fgdgrQx/VFnYoIn7qgDjiyOUVdS4Fye7sldR48fH?=
 =?us-ascii?Q?lPJM/yLToEg5eKT+3mfTtjAtXGzeGFjXP/X3eBuunD/rildia3HrlQ2/gKMI?=
 =?us-ascii?Q?6L+DGBc4xQ06QwAGvijGlJID+3HUqAvjhGWfEWjdz1Cy+GIw0fkfmNgFo5pU?=
 =?us-ascii?Q?zl2uh+GkOVZe7pQ6ZFx8Ae9AQo9PG67W2JnaTUp/5fnYFQMucUFnzs4VYEaZ?=
 =?us-ascii?Q?wzVzj3T/VWRfs4PyAub2fbTOyuOpt2I4BftEnWq2lY7ER01kxzaFNDkDd5ao?=
 =?us-ascii?Q?utiJcMGClnxib9mGwNMWBjwTt3fxPOpytgY/nKREY7x366AtDeH3hYdkTmq9?=
 =?us-ascii?Q?LLKV4037/Xd0r7RqKorMzCcANkVkheWXPOgEY7cTqWz/fB7fp2mPQa56MkU5?=
 =?us-ascii?Q?JLem9Rz1e1SpeaStCTnYWDPO8SF8iHn/9Yse5G4uIxfrAVIJ3vKMGx1zZvKW?=
 =?us-ascii?Q?aN672F12Aa/8B3knRiN7AUIJ0kKxLAesRlEeMdmnQtmvJRAsgGMUSUvLJWV0?=
 =?us-ascii?Q?fR74EIrOZTX097wEw+Topl/z?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ee46e39-6774-47e4-c8bf-08d925d0647a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:12:02.2947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EmmnNDUwYLF6qydD+UsGYbcLeT7rvGpcon2SOilhBd6IRgA6uG3dG46FybZ8W0xGfE50AiJh3+A7HvPXDmNhqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4592
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

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/mmu.h     |  1 +
 arch/x86/kvm/mmu/mmu.c | 29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 005ce139c97d..147e76ab1536 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -115,6 +115,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		       bool prefault);
 
 int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code, int max_level);
+bool kvm_mmu_get_tdp_walk(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t *pfn, int *level);
 
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 					u32 err, bool prefault)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index df8923fb664f..4abc0dc49d55 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3862,6 +3862,35 @@ int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code, int m
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

