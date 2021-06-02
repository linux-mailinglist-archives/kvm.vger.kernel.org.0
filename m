Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8246F398C60
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbhFBOR5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:17:57 -0400
Received: from mail-dm6nam10on2044.outbound.protection.outlook.com ([40.107.93.44]:27560
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232143AbhFBOPw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:15:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VPdqkmGf8Bv6R2gQPjtFOzawv6nzj9cOxKg5uMWJoQyXKDVhdy6ZDSq7KWVwk8zXEr1Slm5uOkTpMgkabYd7LB2rHfDEEF74bJ1kYVJikQUfd7dX/ymipiEnfu61RjLEdPIqiDhiL9eR0I2won6537OwlOGTZUcKt91RiIeD/wiHmhSYPI3VhNrVcIytJqfaagFZz4DeyfuPk91MNaqW5wuKZu2j4BSGRptN9ywExCa9pJOBkO4v65kyKxGa5skh0rh+I2080HfJvdGiDX1oDMo8cgNeRpKKs8Qmw0E3rbtw8LyLkWtEK3AQl4dnZVkfDzQw8NG3w3TLAWfmMwR7vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zuQ6jECD770ybRkBmH8s+erhZW7p02EbJr+4zvD24f0=;
 b=JHHAdHokNMFPCUrxXryCDj1I15RmKV+E0TgOQf2ox0vz83dJhQLV/ZgyJasPetlrsjgFoYQpcvN9ct0TGqx0AjDCNxr+EyH46Kd+l51SWoAv6Fo6vBMztA9Yb3vcYjxdepPfF/7LruPy7rpXwaVuh3MBiBq9945wsRZPN2KM9P7t3o8/uwIQhjUC1JeTKf1nHmj30inNnl1nP21lsBjBF8d2PwXHpDNBFPAY4E8mxD3eQG7n6mj1Rm+LWXshgqtyuKaBEtBulitMwExR/b6LYq3qQbY1bn+h46LaArTuV/C18fQ96ifIEPNQqKGQAkPjsuGU6ZSIzddUKeoShKrqMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zuQ6jECD770ybRkBmH8s+erhZW7p02EbJr+4zvD24f0=;
 b=VYVq/0NvSi0FF1Jf6xl1hotB9jfCpf+9JnBXnGS1hYc+rouWaDfQIN/e1mq5tA3nmot+oStQSlZNXAXC2+nnpir3Zll5+V9xjaWEhOUngCom3/PxNG+7n0M2x1sTRfkbPv7MzQAtmWHelXlEM8i72sUqqJFZjAfTlP8OcwL3FWU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4592.namprd12.prod.outlook.com (2603:10b6:806:9b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Wed, 2 Jun
 2021 14:12:03 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:12:03 +0000
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
Subject: [PATCH Part2 RFC v3 27/37] KVM: X86: Define new RMP check related #NPF error bits
Date:   Wed,  2 Jun 2021 09:10:47 -0500
Message-Id: <20210602141057.27107-28-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:12:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 909b0bb4-8862-4a60-e981-08d925d0654e
X-MS-TrafficTypeDiagnostic: SA0PR12MB4592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4592AFD26B1819154925BABFE53D9@SA0PR12MB4592.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JLSwBGon0GZqzEXT9VEkPA6MqHMnvRyHbOm7Abgt/r6h48MPmwj8601n2Q/GezcEF7Ze1g43HPCJhV8xeSLPBPjy2/+0m+36qP4OKonUAABBTMsMsMaRg/HRFvTg/WxsOtf2UtWU/e1oRCcfg7CKq+0JuCIil+Lik/xT7Wfm3ALEzbsWEyAgra9yHyg4X62E+d9NxEjAg1BtyiK92hVcPCcKvDnLuG9fw1s0mxltN7t0lkBVUhjsPVVpRSmb0Nm5xOt9jM3m0nJHvPpdbGtTDsrmssAXo759zaVHcyjw1RPlAT24Igu+QCYuEIh2FeTW/3BpFqFyM1nThrrTgn0Bj+8VM7LUfs4DA0D8rRHegcyRYB8hDOtvWrOQGkQiu5UvyIHfaGkLqOv3RYq6pNYK6950mX3uBVrrvFGiS6qkrzLJchvKzLpURvoZu8UhoR8pvHU0y936YrWVZ6vNWZzikQo4xMhpae7C6p8d6f1ZW+hzc3fIz6SplM3d7X5JkAi91i3E5VCyOAhJcIMF19kozMAqIvwhf4zuRjCzjZfCyHjnE5OLfvyUkVqop86syC5v/xIhTicw7m45QiKDfsnQK+g6qlnmgUaNjdbbO1loR0gIVMvWosFhoPSKy2Vl0edlt2h//gdIv53vphvaFcSmcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(956004)(8936002)(8676002)(36756003)(478600001)(54906003)(83380400001)(1076003)(44832011)(2616005)(6666004)(38350700002)(38100700002)(5660300002)(66476007)(66556008)(2906002)(66946007)(4326008)(26005)(86362001)(186003)(7696005)(52116002)(16526019)(6486002)(7416002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?k5CMy81fzO4vzgRZ6B1aRtVer7W+71KfcB6wNY5CDuQ2rFaU0wTVWDiBEiSD?=
 =?us-ascii?Q?uVRzr3xFkM0u2nS56221TWZ5LLzyG1CO1Siuqpd+cPSJHSfZTxm5Y0Z6Th2K?=
 =?us-ascii?Q?p+4mgQaPJXpeg8MFPmD5y6w/I4LaAN/wrranrNxvUBJKzEUvFGl/a/yaPe2u?=
 =?us-ascii?Q?XYFwjMhj7lj1+Mgl9+ojNv93SBlJZl09pdgqvVz4zsbE2T9e4MsTtQUGYfda?=
 =?us-ascii?Q?5K935vUMkyNmiOxEoiZAXSc4nPtHDK6/8DHizddLQ91lIvJpM0RVCG2tJKRy?=
 =?us-ascii?Q?zOxqO+wUvogTHyRUN2kNuBZDR+j7DAZFPUtJLmyn260r/eDtWzXPoEnGidHn?=
 =?us-ascii?Q?dfwbRFQF/Ch999M/CJDgmYKDy5IQicLsRf5x7CzVYA/MiskAqQWvFXCU9u7u?=
 =?us-ascii?Q?GBb9pUi9YY/jxi5b6UttyLKM/gxVRQ9QBbo8AZ3R0n2U3M3ukmozVmDlL9ig?=
 =?us-ascii?Q?e3+SoY4yD8h6G8xIUVHaF+ZgIbn5deQy7mtWNuypuxmiS6LjG5k7yy2s093m?=
 =?us-ascii?Q?Z0Dckj/DXtp9uKnWmD7HnlthCXUlgq5L0JENPHIBtmrlfwqmb/ZiXY/UpfQx?=
 =?us-ascii?Q?AtQta2MLX/nBg5uX4sVDfFOzfKNRmnlOPPwCyJArXCalrFbDqpphNUKm9s9u?=
 =?us-ascii?Q?2jeDv/YLHIfd/dLST/dy/4u8SPAI+r6QMAYOvKidQ8V2W2qQIGitu8M5uZXf?=
 =?us-ascii?Q?KVguDqoXgN9T9v6dHC92bFpL7IPdRUm5fU91GNoYSs1InWih2HNT71Zo16GI?=
 =?us-ascii?Q?OkHeftBYw0+JV8zhUxpGHzkvYKsDbHpkzFMAfqXHa7TPup/9urZbrYYwyT8t?=
 =?us-ascii?Q?HtU6VyjnQn6dCzGkjggw25yeCI773UB6/2Y8ICNB4fVQFo/xTwlgvmzAjvYH?=
 =?us-ascii?Q?xIOIpNPg6dXytrAzXOiO5qj+zVXjJKY+X2trOQx/kK5GtgXcKNL1YwM79hTu?=
 =?us-ascii?Q?ycNGTssGZYfqbWBCA/ooxZeM25gvG0O9dtPjqjRIx/eD8khTpLHWZlCp8rsd?=
 =?us-ascii?Q?oF4V5TpkdtVNR70w/YdrkJeaeJcEY1dhe1hq094AMX7uvJUd6f8J2wdgEBEV?=
 =?us-ascii?Q?L1DF1yO4mMpqbi18OQS5pItCEo8pZvQ0ITtmJ2Ce6aqRmbksd1954h7bO9MQ?=
 =?us-ascii?Q?X0Br7jbeLO0tvsbjDOe8JrsEqVGMTO3t4RmnVb3PxuAKCikI/YQN8BdNU2f8?=
 =?us-ascii?Q?7Mwe6t7vXptzOLd6PZD2Y/fIkuc84cOA+ITf5CVpThBXdSiDGj0ZCAASj+ev?=
 =?us-ascii?Q?e3u9ArNnjkyeTuZdizOX3aCEI4YJmoGm6aAJ9Za3oEt8AkMhDQGwJp0L/F3F?=
 =?us-ascii?Q?ympGaVps1Q6s/zDvfrLNCjS4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 909b0bb4-8862-4a60-e981-08d925d0654e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:12:03.5519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +2EnkUdcbBZc9Pr94GXBMBJwbvkbHO6dGSm4T86jgcoBNBt74cGoKMaat1cHIl/xKymbI9NS/yXBH424Yvbhzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4592
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When SEV-SNP is enabled globally, the hardware places restrictions on all
memory accesses based on the RMP entry, whether the hyperviso or a VM,
performs the accesses. When hardware encounters an RMP access violation
during a guest access, it will cause a #VMEXIT(NPF).

See APM2 section 16.36.10 for more details.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cd2e19e1d323..59185b6bc82a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -239,8 +239,12 @@ enum x86_intercept_stage;
 #define PFERR_FETCH_BIT 4
 #define PFERR_PK_BIT 5
 #define PFERR_SGX_BIT 15
+#define PFERR_GUEST_RMP_BIT 31
 #define PFERR_GUEST_FINAL_BIT 32
 #define PFERR_GUEST_PAGE_BIT 33
+#define PFERR_GUEST_ENC_BIT 34
+#define PFERR_GUEST_SIZEM_BIT 35
+#define PFERR_GUEST_VMPL_BIT 36
 
 #define PFERR_PRESENT_MASK (1U << PFERR_PRESENT_BIT)
 #define PFERR_WRITE_MASK (1U << PFERR_WRITE_BIT)
@@ -251,6 +255,10 @@ enum x86_intercept_stage;
 #define PFERR_SGX_MASK (1U << PFERR_SGX_BIT)
 #define PFERR_GUEST_FINAL_MASK (1ULL << PFERR_GUEST_FINAL_BIT)
 #define PFERR_GUEST_PAGE_MASK (1ULL << PFERR_GUEST_PAGE_BIT)
+#define PFERR_GUEST_RMP_MASK (1ULL << PFERR_GUEST_RMP_BIT)
+#define PFERR_GUEST_ENC_MASK (1ULL << PFERR_GUEST_ENC_BIT)
+#define PFERR_GUEST_SIZEM_MASK (1ULL << PFERR_GUEST_SIZEM_BIT)
+#define PFERR_GUEST_VMPL_MASK (1ULL << PFERR_GUEST_VMPL_BIT)
 
 #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
 				 PFERR_WRITE_MASK |		\
-- 
2.17.1

