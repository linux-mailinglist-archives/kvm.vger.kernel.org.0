Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA7A347EC7
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237406AbhCXRGN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:06:13 -0400
Received: from mail-dm6nam11on2061.outbound.protection.outlook.com ([40.107.223.61]:33120
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237068AbhCXRFR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:05:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YpITB7/XgkT4CAoQKdTX+erCps0VhunE+vgipuTpDp23m3JRk53fAN8k1WpPzhRRtvKR3RLA+aN4VS+Lte/s/6gGpnwVUcLq/pIq+KGxpMzgPZWG9po0TuioKD7rHJWlYSpBHsl2AeO3bYgLU+H5lGpNe1TW/lJxtfiApPCCt8GnTrqkmnEAQrgxrwyY8wOFH9IT/b+COapbR92wM9/lqHAj2C1Ujaf4qkHpf6kSVFOYyGVheMSv/LpfS14vKXk26nl0tu7v3m8Bfi37Mrf8ZTM+pIXJwDWS2htmTF9uXoQ80UeHlcjV5t+g145MLX4vsSkjxoNYKXZpWQUXjJ0EXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6Oqw9HC1lruIFm7FhqWvtud3iXExTAuuTQZCcScbxs=;
 b=eO1OSSHx3Qq6/XuZ1y4pB7oA5e/RIM1AZyjF+o3jJCMskC0RG3RFiQNQtiWeHyFrJskFToFgFIi/Pbgi9V+0ENAyy03NklE/KysFBNpArM5TN0M6U9qdeua0duSLLQL0FN7p9cv3ZWSfYjREnpwql2oOdXVymcrKZ7jvNp5Is5WxyAW5/KjVy1CSYQ35tlZGAgcXK/e3QwuhfOwmgzRMAedQ0xZQNqK6agTppK/6LGxKfgN0I+XI7lZ3uy7k2P8ZSgBeZhWumOZ+epRZCLPYptDTZHTgaJDBQVKtBxBisKzL3wzJSg/BcVeKSfGEgJhC499kq89Og8ivNdqebLUDWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6Oqw9HC1lruIFm7FhqWvtud3iXExTAuuTQZCcScbxs=;
 b=4sX5dnM6spWD6zExsbJ6h7pYlgXakCLL2QMfyRc5qaF4JdJqazYmMqbfTkSKWIjM8AztfwY5iYo+SSPVAQ9QbmNOLD53xtHBGTWPnLdVmi5YRIYeColOQXbUlZ3qdPHC6F02xbRMvafdIDQgDEFa8OBiUZrXYQtq1BAgLhT/R3k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4382.namprd12.prod.outlook.com (2603:10b6:806:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 17:05:15 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:05:15 +0000
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
Subject: [RFC Part2 PATCH 29/30] KVM: X86: export the kvm_zap_gfn_range() for the SNP use
Date:   Wed, 24 Mar 2021 12:04:35 -0500
Message-Id: <20210324170436.31843-30-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:05:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0651ad6b-d5c7-45c1-9aa9-08d8eee6fe68
X-MS-TrafficTypeDiagnostic: SA0PR12MB4382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4382432698656D1199C66128E5639@SA0PR12MB4382.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NncvWd+d40Orx8eYWtneAdMp3yBxlSQG8OB3v/Dgava0CU4GU+pfd9hrnYO7JimHS0zMjHCQfqZVj2u9lTAoDIz/BKkhRFhSA1SbWN/wVBDKmbcxjQug/s2ZcWq1aBmAcysEu5dFOL5hFKIyHRJSJ5ZoTIJ99/50iHgImnUSh1AWBa8sHBPO3idCIlhqmM0pVwwUtoJZPF7VPZKGXIWulxkbVl2pIlwN4bk6QqPrF/G6lyK9yC2IxErN7UEcZRcNj0HgZTF2TWi+Jfzo2eHVOEBd2iGlKqBCi6jVp0yNzhjRn+C7Kr1o7GcObZJyMTsaeRjCq3TKSGg3gxEgRt0iWojU5kj9OAcO9WJvnSi2zHGYKekFDJf8iRxlLlztNaCaBWlIWhBOrQnusVnuGpLqUwYCRuj/FbFjKbKh/0k0V25YAM5O0S1tIKZW3IzK5lXYSLcmjCnmymogR88znOfgxGUVYlD0+IK5zVAN8Kqyk2bGcXYWrY0Y0MJKjoiiALhvIkpAuI9bPywE5wRz1bDBPlTVgzmzTJTYw9vcvEnpno9BUVCqhspuvpnTrZNTfQDjl63bgCaLirFP/VNel84Hosu3lcFnrbK5V+/jOcYF9qixXlT8dhIBFiJJdDVx94kSDnXoh91BM8FmnnBlHYLXVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(6666004)(44832011)(66946007)(1076003)(66556008)(66476007)(956004)(36756003)(478600001)(2616005)(83380400001)(8676002)(2906002)(8936002)(26005)(86362001)(5660300002)(52116002)(7696005)(38100700001)(4326008)(54906003)(7416002)(16526019)(6486002)(316002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?os+Y8FLO3XADUNNqty1YBQ+GCeC7ZXU7r7jbUxFbkqWJtIRcJe/Qfevqk2hc?=
 =?us-ascii?Q?ypBuFwG7RATHHtuB2mLou0VviQVxz88mITYHQwRPr2YfjsF2owM3XB/vJhA5?=
 =?us-ascii?Q?462jUH9xfB5QtxuUeD/ontZbwaaGTW5b55QB0tBXg6Y9yyk7mz+hjnRCM5c3?=
 =?us-ascii?Q?06QvHpH1IalRcTlnWAs8gozRsxqj85GIFfMNbnNoqiBIXanmE2LJu2A8yh/w?=
 =?us-ascii?Q?LyM9oIkWBGRKHBdDPTfU0xTDwlDbqyeg80OXr0Gf4B7chaAcJ9/uJKEW9y+g?=
 =?us-ascii?Q?IqL2uqakUzTOtcr8ZokshGyPRCt/RPMkiJH2KE0FJ6mptB9yIXtck2gaox23?=
 =?us-ascii?Q?7N1PbVlGvFIEr9YhGFLfrutEoDaMtXOR4XwIXf+M7ATnrKucqIPsK156khZe?=
 =?us-ascii?Q?Y0uI3p5dxUl+Wag4C3pp/fu2KOurJO9H//ZEVis79nAyrrMkNxbWhdo73RUd?=
 =?us-ascii?Q?2k0L3iXDg0Pei5B3xkDMsPFpz0q7u89mB8gAjfx/wBUyRdDXqSr49Wn2w4WX?=
 =?us-ascii?Q?mQdTwmNYpZaPTGhYg9BzyHqz/x+svEZjKuyZJDSNXvY2EZKUERy5zeoF5j5D?=
 =?us-ascii?Q?6SKwNxLq4Wx5wBwH9GZQmYnKVGLrMxfteQg7N2jzUSo93aYxFK8nuWlQJfAB?=
 =?us-ascii?Q?4mMBxlSDKQtjHk+F3FKm/jkVar8kNoxPWL6T4MOaWHTSXtVrVGnju04SeixC?=
 =?us-ascii?Q?Ovz7mybVb2wuL8pQcueI+6m44v5UfePEdbO0H+j6m2sMQiq6YHYlofvaDP4e?=
 =?us-ascii?Q?FJx5Z9aJchjWq4nwapKwR+bSBMTCsJIPEvEH3ti4vzTEodDQZGrLQ8ywwG4w?=
 =?us-ascii?Q?/tkHt36qZQS/XGLe0yfeTJn/s8Y3rmdEVMVP0g8wH5wL2orInokn9JujDG3j?=
 =?us-ascii?Q?a/LmhnslqRZu/tz32I9fIzMRnMHZEuSjmmORsS4LK+eq0Mn4gas9uNtUIkK1?=
 =?us-ascii?Q?fHlOvcYg65vOsaA1eynPT0KBD232NIo1cAWzbmOMt0Buka0tM5Q4szGUIqh9?=
 =?us-ascii?Q?CxOaPzAxXi3gNrtPFSYB2gw+X/XtaZ78LWNuvk8WowrzXUdFelBS4LtIxZSD?=
 =?us-ascii?Q?1KIbXcgQ5frQK2TNvOizXUJfUDG3vxJvy8Qh/4MAnb3bNyfaqfDTXvnqwV9X?=
 =?us-ascii?Q?xDB+fcRyXCAi1vsWHqayGGSNDOHIatUH2pZUg9xEHwAEhgmwPiIvQkt0mZW4?=
 =?us-ascii?Q?16HQX+mk3F28ollyq6hNrpg9cNcSmhaCW025WfuLG9D1dU4UFHOEF5WCCJw5?=
 =?us-ascii?Q?IbqMoH0OKI2Vpbkspcoy3+tM6DrvziRtOiSzZRdQbXKrzq3ogCAOeDDIZX7G?=
 =?us-ascii?Q?N3kXwqmgDZ9VCeyB5z7+mGZi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0651ad6b-d5c7-45c1-9aa9-08d8eee6fe68
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:05:15.2891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pkg7MU5mERkMI9RdzSBiUhrkQGdHtou8YHc65vKOkZBd0nBGx9n+O21iDmzEa/nuVFmQ9izJTXPdJ696yPgLOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4382
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While resolving the RMP page fault, we may run into cases where the page
level between the RMP entry and TDP does not match and the 2M RMP entry
must be split into 4K RMP entries. Or a 2M TDP page need to be broken
into multiple of 4K pages.

To keep the RMP and TDP page level in sync, we will zap the gfn range
after splitting the pages in the RMP entry. The zap should force the
TDP to gets rebuilt with the new page level.

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
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/mmu.h              | 2 --
 arch/x86/kvm/mmu/mmu.c          | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 074605408970..5ea584606885 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1397,6 +1397,8 @@ void kvm_mmu_zap_all(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
 unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
+void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
+
 
 int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3);
 bool pdptrs_changed(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index e7c4e55215bf..5f7ebe4afd63 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -223,8 +223,6 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	return -(u32)fault & errcode;
 }
 
-void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
-
 int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_post_init_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 147f22bda6e7..1e057e046ca4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5569,6 +5569,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	spin_unlock(&kvm->mmu_lock);
 }
+EXPORT_SYMBOL_GPL(kvm_zap_gfn_range);
 
 static bool slot_rmap_write_protect(struct kvm *kvm,
 				    struct kvm_rmap_head *rmap_head)
-- 
2.17.1

