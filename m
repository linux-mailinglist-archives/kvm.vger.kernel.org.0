Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC1D3F09A7
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 18:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhHRQ4g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 12:56:36 -0400
Received: from mail-co1nam11on2077.outbound.protection.outlook.com ([40.107.220.77]:7008
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230078AbhHRQ4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 12:56:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=maYWntuqxnHXo9Pwlkflbsaosq9jgqYY0wwBZCxwbABd+fAdXjUmVxjRWBxq7L1RYJEKjS+kcHjCQGOWOM5jmlS6j4Hzf46FNaALNa/UgrL+IWQhC6NTPAiOaC/ZZkC0ZRTNsMsczS204chVcyg5uVhqcVnTMp8+jDsRtOz/AYZ20xd99y2MMCTwiD6lPIvdkoJrHptcI4+SfK2bqfUqi9l+hl/q/gF6H/xqOWozZ/k0hTCoInIfuzR5N/vAN0jSsfuf9F2osmoOpjMROdCCFV/fWH+kWt6rj4ZTqsP79HzaKICPx37hFdoPQunXnY05+7by2Y7gp+X9WY8itJ2xWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EAwOmpqPk6CDd9byR6AQqb4CdN/o0bpvmXQlTiKHXpI=;
 b=KNIenGk8TOACD42MKOb9TeQCd4k6OD8+xqr8O3FedfyYJEOyobD3GRYOjXRNjps6hV9S1Rb2jktgKP6xGZ7ZbNXAuarbzkf5/BiKKBZ9HX9BdO7na24bAddKS/1mpRQ9F97jnrC57joXjwJred3RY834HlqpJmxqYRxiqY+U3/qPRX4TTx8mHSqB/iNV0N9tCHZXP0+ZT4Pk/LzjJYjSRtNSfPGBsxsSYx/r50cLfpN8R+Q0iiygiXrnnZK5ckQx9z9JS0EpXwXGj9J1CDfkQgcjy4xEycdguMqlHQXM6X1bAMm5DQnFRUO6xQvslGxKzph+h+30US2KsNfoaowgsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EAwOmpqPk6CDd9byR6AQqb4CdN/o0bpvmXQlTiKHXpI=;
 b=zct/2cwwDmwyJnNkT2nURNA9WUN1o5BPmN+j5KdPvbhD9LJYvZ7VGNoDpQVLxgKLdiXt7739nQpKmiH5CyFdjIcBjza14QdSQN78cBkkuOtDt1YU/my+f6Pd1f8iBxll+pgw1ATe7mSqDQEa7dNTb+M/APnYIngyJcOT1mIhbME=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com (2603:10b6:4:5b::21)
 by DM5PR12MB2487.namprd12.prod.outlook.com (2603:10b6:4:af::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.22; Wed, 18 Aug
 2021 16:55:56 +0000
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d]) by DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d%6]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 16:55:56 +0000
From:   Wei Huang <wei.huang2@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        wei.huang2@amd.com
Subject: [PATCH v3 0/3] SVM 5-level page table support
Date:   Wed, 18 Aug 2021 11:55:46 -0500
Message-Id: <20210818165549.3771014-1-wei.huang2@amd.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR12CA0006.namprd12.prod.outlook.com
 (2603:10b6:806:6f::11) To DM5PR1201MB0201.namprd12.prod.outlook.com
 (2603:10b6:4:5b::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from weiserver.amd.com (165.204.77.1) by SA0PR12CA0006.namprd12.prod.outlook.com (2603:10b6:806:6f::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 16:55:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a366df9e-2c67-481b-3f8e-08d962690bcd
X-MS-TrafficTypeDiagnostic: DM5PR12MB2487:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2487CB777E324E1444E7C2C6CFFF9@DM5PR12MB2487.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kfpN/DiAb+wlO9RwLUNZ89aWNqmPO03L97gAyauDgtUp5WLRCvxv5b0vYhH9BmgiNBP4IbpKVNE219QTdaweVVCI6LD9R3yO8AycaES0YkTEpQZXQUCXjABLXXZhdNbhlKdz7eQYijmAzgoe3ER1vTL35U4zvnQ/7/xINkV53Kd6adP6ZPGPz7+dE8kDBDnBI7BmcjkjBaqTWby9RbZXFrVGR5J+XX9kmzfuJ6X/nV7WdfQ92L5UVCkPhuAGOlUdd9xCnwRUdofvyGj0CbPvRLTLFOVOawRzrhFvXQjF55D2BFdgpdNENc7WDM0R89Whb4BBC6agMS+YU4OIGlgkj187zYWFQY6yRE/RsHmNLWuqOluDt0QFNV/mQeloTmtZy0g/rHZGcy/0HW3mKci85UgNbGM2k3X8l1GpS1hPNhqGGfKGXgNPnOxx4le4VfbkE98FD2GznJll6oCoYgj+hD7CxIMCeXnXHJ4gvlk/5s6nUUpYjeSPMOWA/pk0PQ8W1W3TnsYS9Y46846zUWNFoeLoS/c8IbY+ZezYzaMEXHsva+m7dtrwumYmFft3SPGJE5sYyQ29LCof+1XaI8URE2KT8VV2izAp+c0YldN5wwYSJOcmYiIkRIX+v0JfHw5+PW7loTD1Vt7pOIH/UA8myUvf9Tw1eV7IObGZgI7X5II3wp1nvz0zXpQVgc7lNEz2KeNJxBtHNf6fHoOkhHyYWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(39860400002)(136003)(376002)(478600001)(26005)(38350700002)(52116002)(66946007)(66556008)(66476007)(7696005)(4326008)(6486002)(38100700002)(2906002)(6916009)(6666004)(36756003)(83380400001)(2616005)(1076003)(956004)(8676002)(8936002)(7416002)(86362001)(316002)(186003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u5pnAkydxuq1i0kgTWm/l1xCzmIAOlhE1Z7YXa4HDg8zWJuHRtB5FwqoXqS2?=
 =?us-ascii?Q?J2tG+oRHLsGeNe8kcXJVRSzQwgT94Iycmc6LsNFkRDHzKZxpjJAExq+9VRMX?=
 =?us-ascii?Q?IxiKh1Ad9gdSChTZL/QNDnQXeCptq9+sgrRmbY/QHk93WGALSwEBnPFUFwjW?=
 =?us-ascii?Q?qpz52nEAm0N3xN0UrvGV6ki9DCGvTHuGHyEqcZXDxn2EjW+77HYWsdVyM5tB?=
 =?us-ascii?Q?GaZHgIMBi+zuu3RJC9kwBMLMbA8Ivn5VJiWeknQiM9ujdb8NdqVSTN6cmviH?=
 =?us-ascii?Q?52xVVCsL/vIArPLhLuJkUY1NTAAjwS6xdbzNUD+Cc+hrgQvJ55nc/NnRGVpD?=
 =?us-ascii?Q?UhOFuRVbvzvoKeRpI+TbOWoufaBC3iWYFg6PDaGIZ+vdWbUGLGYaGSnH+Ik4?=
 =?us-ascii?Q?PtZLF1GxqwItmYQwdB0/U8VKbXcNTvLCOvADmmsL+f2j0NOx/9Ia1XY7cxlb?=
 =?us-ascii?Q?exHzezZQ3F8dSaCx9qRTZxNMrRdrBOVrkMI8s4aY0uKjQZbxm21W2OwtZk3z?=
 =?us-ascii?Q?0N4aQe9PHU51MDUSUZf3e2qtoNtDMhozkp2U9gM41CC4C3c8H3oPr7Xje6V4?=
 =?us-ascii?Q?aJvzeukHTIn5hceRTBsRJdDrAJ5GMerWOE70rOdTbhHI8ovXO3SUPwJIqCLp?=
 =?us-ascii?Q?vQnx/B/8OYY4aDdA/BhSjh+JG7eDKWdOfYH021tV2fh0S91Wn6kJRs8YdFe6?=
 =?us-ascii?Q?prYlA/eTXhfv4ocv1tpO54OR5/8axMCrXShr7Qggj3ZTLY+PKGoY76DfSunO?=
 =?us-ascii?Q?/aUvYzSkyFHlZRkLPzJ94I9aKSGIecR3GTnNWCnQHu4zlaWUMFuPSOsWv1wv?=
 =?us-ascii?Q?yf5wajf+k5cxZURoq4gzghX1aN44RkB42b2Rxx9mhA87b9KVWuc0IOP9zCVe?=
 =?us-ascii?Q?RAD48/JkWJkUJjf9w2/+WrOq4PYSHCN5PebcNDhkZ8tawewUmlnrAqwmpj9c?=
 =?us-ascii?Q?mxZGu/csN9V7UwEOjdnpj9vt8Jab1oOBgLokVM0MeiwOm4p+RON0/ZlqwgGn?=
 =?us-ascii?Q?dCA7l65mSifCmH7O9n9cggagitGToFOgcAtM4kPbmTLTakgLKbntPmGvCT2B?=
 =?us-ascii?Q?/ah2OKpnCK7MTwfOzd844C/1ZMVKfqB4wiRCmRpueaob1IywaqsKsJNJJcu1?=
 =?us-ascii?Q?JKSXLSrFPIL2ZL9sq7bmjAHtJ8+Iezsi8l1ju6KepOaSwOW2UXZ3XDIKTZyY?=
 =?us-ascii?Q?R4gilwFAQhdqJNiwUVlfw2QnDkAPlWypKpIRIAwWqO3K/5nKZNkaPUdUn58l?=
 =?us-ascii?Q?M2l1k7Jo82JYMRzb9m+PKtzhROzwTFDbYsHDh49r0M1lJneZJ/DlCF9i0KMF?=
 =?us-ascii?Q?JyHbxWv9bXhvgecXMdtYXBtp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a366df9e-2c67-481b-3f8e-08d962690bcd
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 16:55:56.0113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T7p7jUCktwbkAcg+es6a++2HQxehRw72oonAkQlJakSMHp2qXplCXBt5PeJ3ymZy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2487
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch set adds 5-level page table support for AMD SVM. When the
5-level page table is enabled on host OS, the nested page table for guest
VMs will use the same format as host OS (i.e. 5-level NPT). These patches
were tested with various combination of different settings and test cases
(nested/regular VMs, AMD64/i686 kernels, kvm-unit-tests, etc.)

v2->v3:
 * Change the way of building root_hpa by following the existing flow (Sean)

v1->v2:
 * Remove v1's arch-specific get_tdp_level() and add a new parameter,
   tdp_forced_root_level, to allow forced TDP level (Sean)
 * Add additional comment on tdp_root table chaining trick and change the
   PML root table allocation code (Sean)
 * Revise Patch 1's commit msg (Sean and Jim)

Thanks,
-Wei

Wei Huang (3):
  KVM: x86: Allow CPU to force vendor-specific TDP level
  KVM: x86: Handle the case of 5-level shadow page table
  KVM: SVM: Add 5-level page table support for SVM

 arch/x86/include/asm/kvm_host.h |  6 ++--
 arch/x86/kvm/mmu/mmu.c          | 56 ++++++++++++++++++++++-----------
 arch/x86/kvm/svm/svm.c          | 13 ++++----
 arch/x86/kvm/vmx/vmx.c          |  3 +-
 4 files changed, 49 insertions(+), 29 deletions(-)

-- 
2.31.1

