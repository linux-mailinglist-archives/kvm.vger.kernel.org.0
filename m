Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380B23F30B0
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbhHTQCo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:02:44 -0400
Received: from mail-bn8nam12on2072.outbound.protection.outlook.com ([40.107.237.72]:45024
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238236AbhHTQBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:01:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mIDro/KC6Y3I/JQaptr/pLOpoqEhVnP9YmFZ7IIcGY+cGniJwRxVck6hVTQ26CDXQpFppxVySq4k3C4UOoeQ1IfKfA85EsHeBF4vtnp75FUBNm7a7mykrIEMY6xvr/enFXX7hs1PJ4OXZB0pLYBG8JZNsAszuwq1G7tSwgW4bTMcwW2sP2RRCZ1by2FKExLb02uKGdlTS9coSY3yEigxX2iZLLR2WRJ8ncL99bXNa0044fkRRYDjznNei+I2cHSH6y4PplBoxKIdvogQnguMMEUEbMufwJycnBJDszMm4plfXdJdAhZxKD9P1mFnOMMUk+tqLGC4x//2XiVW0cOCTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ss4ZiIEv6xO6y05eHHgwn5Z4J27VjjFqzE1gAjS/mN8=;
 b=VMahWh3Se0ntzw+FiGZeW6AwHdP86K6WDH0T2j6wKb6h/du2MWnlQ4/7B3rbmfwiADH7JmHewU7ub4V9H+EnaPl+KY3KQmWAcN1qMOsB7ENRx4KRK/B9NExI5OXS5Ojjy3UEyIXQ3F8g2JAdUYJXcXHq3f5H7XRkzTaTHwcFSiYXNwEgZpU1LP/cye9gitj+u+sDuF7sHSc777uUZ4JGgMAKF2YKQNTtn9/ytj9Cr400yRZYTI5BS9mKN3UyQ1SjKHqG9VECjKR71IM+waXm1AWxLm+gRX/+zylkjlIIrqWimBTPA2piKHEl1ZBrslzmGJCG/fNb81HLSbJBQHrXiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ss4ZiIEv6xO6y05eHHgwn5Z4J27VjjFqzE1gAjS/mN8=;
 b=3kvJSLMa5dWlD+w4YxnVmZWFxRZUXROJL9lirB06mHp7m769imv0lbNbu80fk35g/xH/uWcCIkSzf1N1ScjCrUh3BeWK5hyTHc/QPpbANzaidCZqZ4oalpklpDqrB/cfGbHcbrusQubOG8EYhvFqoviWWgT4IAmQl+TVxpSVbOQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:00:34 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:34 +0000
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
Subject: [PATCH Part2 v5 32/45] KVM: x86: Define RMP page fault error bits for #NPF
Date:   Fri, 20 Aug 2021 10:59:05 -0500
Message-Id: <20210820155918.7518-33-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63b48cce-01a7-4dfd-5e7d-08d963f3a4fa
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45091FB4EA780632E060032CE5C19@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L4h4VLMAnN1R8i6hRQFGUp+kA3raKp05IyCIzA0QSLCwLVgOqg7Q2M9Oib+PxOo256irCJdq6d4oCU0TpDAokaKi6EbUoC9zu2wtFzU5vHFnLeylJfBjYoxlvzZShxrEioK6dYFt+2sQZdWua5hgazG2ephSHEdssUKleXf02SDBh1NFkEXTmeoCzdXCX4tMZCHOc7lSeudfKmQNadx1Xoa6vCIQKkLnozfU1GdrgV+My/Z/eGIHp1BqL0mAD0jf1uzyBNFxXWln3oQ7ct6RjE8DKPPj7YjKBwGo2zJZB48DrEmlNP2o78OqYbBnwIVRely5zYeGk9NcnA791Yy+7CimmmXopahddn+O3oVXn515mwTJbecYerKKkEKQaTENzpFW91hTTfjqz23LMc2QQ2UJuXoTkuiK5ivDk2qk1AXuMRCCvJ/okGhsE+cHeB0kq/3yT3u5th9pDuWP47mSNUgoTL2GKo6FGkaWlHPd3FLmehwJY1PMU21pbPS1tNUpm1Sh4TrIJbe/7V7i/1u56/eTJudQ8TJKBOl0lv6PKtEQura7jFTiJ5D3eq8ePVsMn2i3ZdDZi3IGtXFch88HmtDgNATW3aQ49nskkIvuz/LP7dDFWiNRo+J7hoGkKBRfl5zSbr4X8FicMZihDawXNi6RVOSwMjkCSTC+7XRCtV4q/NhCwX1eluqGuKWTtM7c0HsA05FCdXHuk4+uJMjKcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(4326008)(36756003)(7416002)(44832011)(54906003)(316002)(66946007)(66556008)(66476007)(86362001)(7406005)(956004)(6486002)(2616005)(2906002)(83380400001)(38350700002)(38100700002)(186003)(5660300002)(8936002)(52116002)(1076003)(7696005)(8676002)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bp38a1QRVIFgwtw/QCWoWYQ9TrwPHvF5V77xalo1QWurAPjLWvPY/aGb4eFb?=
 =?us-ascii?Q?h/Upi17Cvi9f+PtiSX61ctLcYidtUbocrrkHFXeoyOaqaccKmLVtYiOJo3eG?=
 =?us-ascii?Q?RZINEi3lFjzmZTjAncC0IGw3xQN/zPWvXHPzwmGO8611mFQw+Ajl+QHmj/La?=
 =?us-ascii?Q?+qd+s1spgLzzbACoeorJkJ0v2nNlkBpnlDhOZ1BUqJS/aWol6WPo9FThkSEH?=
 =?us-ascii?Q?EYeN9edu31ltcDlLGjXVIc9tw8BjosUXKeU+oEbCvS2MbOhnBS0RQxkk3mkb?=
 =?us-ascii?Q?aiee4hODmG19Jocb9APqzpifkEbWxVy0gyODdt5qPDzYQfwvPLsAuxKnqpln?=
 =?us-ascii?Q?nQQFu+0hoYeGgjNChFQ0FggvfQAzgQaLb86cV0OshWQ+mE8Q6vnJaDTsN/Sj?=
 =?us-ascii?Q?zr2sJGkanNuIW44b7o7H7HiVVNwUgpVqnj6KzTDitIBwwE7JVjGKkvosYrkL?=
 =?us-ascii?Q?AweKJlEUtRZW9VCYcdi5A+J6I6ImNi/jLsgD6Rmn67fPGNkbdB/zAmchPnc9?=
 =?us-ascii?Q?NaiYLZyLBTrAfoSFt2tW45PMlMoUB0JhCjOa15OF7bdVxDn8ooVH1odsOofP?=
 =?us-ascii?Q?OSIJzjiaF06VdAsG2gDIt+Pj7S4uMOOwx5ymbR+VmIRuNAkWaHl53OUii+Xo?=
 =?us-ascii?Q?d/LzoL9iQGvIwoCjU9oBhFAeX5HXkjMZE82uzSrhBhVHGE75bCW9Z9vejvm4?=
 =?us-ascii?Q?8iCIM/rv0bBxvunUDrrbh+W7iXKk6nLvCdWJjIZvXhaxgsO9l6UXTSFp1O60?=
 =?us-ascii?Q?IhZkVMZX3thIoonulIhIcHqNuWgZl7Pj19nf5kJqGMzfc/jEnh/zv9MUa4c3?=
 =?us-ascii?Q?qePnytQHmu5YrsiN2lsuzHVXf9ZN/Gd3H2E0c3PEo/aNEhRre+Tru3dQR60Z?=
 =?us-ascii?Q?elRGV1HHe49PzKijvL90i/z3LjsHM2OPF4pDgoUMDQl2CDW+pHRtXhsj1Cvi?=
 =?us-ascii?Q?rU84PygyTYtR+X9vDZEvaQCZ45hbPOWg7PY9lMbpMtiLrLvhyDRj5M3gWWhJ?=
 =?us-ascii?Q?oNRVSrMcQzaH4+Mfifxy0QVTmlGrBmsaU4xB7VQAzG+WZtmiBy0xffxnylfF?=
 =?us-ascii?Q?dMo+Kcx2I3iLal0zQZHNRFBzntBMfsqeaqvFFXGu3NNZNpS8H/eFF4IGxX9w?=
 =?us-ascii?Q?8bbFJhtKdwDYxShAEcXCMy9MNWglOc/iIckelcoeu2IhEct5eKLNC7QQhfZW?=
 =?us-ascii?Q?yDUupcwF2GIBMIw11p5Tq8rcn2PpcFBV0Xi4ZCHHNuHSimkWC1Xrpk7yphjc?=
 =?us-ascii?Q?Sx9rEarJ47YHjX1LN76KCx8k1WdXmlxuZ6Y7CuWxcwL1fVhhEWx66PMArkRb?=
 =?us-ascii?Q?GAZ2EtFNBfPUXv5VoqGDZtZQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63b48cce-01a7-4dfd-5e7d-08d963f3a4fa
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:34.7649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: btxH0VHaj8Q58SnThL7T13Hbwt/OV0WynbwEjegM5Cx1j2altdCCAOib6dnhtsqvRM9ClfzJwdAG0kKkOFGgXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When SEV-SNP is enabled globally, the hardware places restrictions on all
memory accesses based on the RMP entry, whether the hypervisor or a VM,
performs the accesses. When hardware encounters an RMP access violation
during a guest access, it will cause a #VMEXIT(NPF).

See APM2 section 16.36.10 for more details.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 109e80167f11..a6e764458f3e 100644
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

