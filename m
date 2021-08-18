Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD91A3F09AD
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 18:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbhHRQ5N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 12:57:13 -0400
Received: from mail-co1nam11on2054.outbound.protection.outlook.com ([40.107.220.54]:7872
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232664AbhHRQ5I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 12:57:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JgFpUiVlRRXGsqZcZfyJyC3b3N6+MS+jQ3Dzgj7uOHo+GHGbx2hdF42XbobKajmcNjw3O/JyWyCiMa08gBJOCdpxXs6yyDcMkozRtZxooqpLweou8PIrGssXOWAemWp24TO5OMIjG6Uh/H7oovrybK1UYAalu4dBsmNYeU0jcyt7xwXOX9iZPUnxQmG+wTyvJRX9i5hjW+gvNwKDKRZl5jeCtO15UCK1YojEkJ/tPzSAafXcITGI8QFB/UchXqhcSZmICQk8axIn4kKXeRBf5Ju/XtW+I/J3jbsaAiBgXKYSp/xi8jT1cNznOByaRh8InCNgq8wlXSC/HCJzINbLNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eV15EehFu6GU+KiNcR8ttKkX40eVc9//eWCc4Lfm1B4=;
 b=bXoB2KaXY4KFrWUsLtnA8FgpkpBlxGfRaeT7PmC5CEF/lOVDsHhOa7rKaFFaRR65+JgOs6IX/jTPpu2Z1QUDx8uEMfGc27OFYQaCJtoGKLLbyYU3CTZDoQ4ul7pNkkNw+CR5R3zgVaNPk3PvN9G7PjETb4TFbT/VvQsu0PTvHy7gVri73cGV2fFDxZ0plH5KRYuHtg7cc+ydrJdMds79ObR5/y+kjryJIdBPWA3rFR59cWrYR86gf1VNXgx6CGMjpPJCd3Zt9MBfVmfJFbYSyDiHQmZxZoJvKRZhl+XiZyrumRZA0qgSezxPG/65vEtTCQFoZ7VfiBD07aPVnzdDcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eV15EehFu6GU+KiNcR8ttKkX40eVc9//eWCc4Lfm1B4=;
 b=WK9h2BrpNuuCeHKDg2k4IJx9qJxxngNJ5roYrTazokoEaltlbp79DESRD9xzpBto9auIOL+qICG7CEjvkQUzLHqrFGdPnFqhnyo6cqoC28BAc5YMsRj3NShYq3Apjhmb5puUMIiakoLXCngdPmm/UjmVn8WaRShdYK85E/UAk7E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com (2603:10b6:4:5b::21)
 by DM5PR12MB2487.namprd12.prod.outlook.com (2603:10b6:4:af::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.22; Wed, 18 Aug
 2021 16:56:32 +0000
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d]) by DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d%6]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 16:56:32 +0000
From:   Wei Huang <wei.huang2@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        wei.huang2@amd.com
Subject: [PATCH v3 3/3] KVM: SVM: Add 5-level page table support for SVM
Date:   Wed, 18 Aug 2021 11:55:49 -0500
Message-Id: <20210818165549.3771014-4-wei.huang2@amd.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818165549.3771014-1-wei.huang2@amd.com>
References: <20210818165549.3771014-1-wei.huang2@amd.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR12CA0002.namprd12.prod.outlook.com
 (2603:10b6:806:6f::7) To DM5PR1201MB0201.namprd12.prod.outlook.com
 (2603:10b6:4:5b::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from weiserver.amd.com (165.204.77.1) by SA0PR12CA0002.namprd12.prod.outlook.com (2603:10b6:806:6f::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 16:56:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d919a1c6-b6d0-4e66-bce1-08d962692182
X-MS-TrafficTypeDiagnostic: DM5PR12MB2487:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2487C354410DD7264A83FB53CFFF9@DM5PR12MB2487.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9RywPpRySR+l6dogadRdIA3TYkph3ukuc1UgBF5LTQ+lepGvaXWQfRrvWxJ9n8jxumcvYBzx4o2JW0LAp6k+v9HHXrp+7KkN7hKAcEj7pe3e4NtqSmmYpi/Notje59tx87JJP1sk9l7wJ5VB/njFEkzDWVjMei2eBAIodPKp/L8x6QOObVhir3hvnKOLgIC1DQIW4E+HFGC0tzbIXn/XZ391dmvHC8LHK6wVqY5o1sV3u8bQ3wQc8R6iTj2rYyikCxB5s6vcgglnM0Uk7z6/zoWK2f2IEdJE7nYmDt7d+87nokzQpewHf5RziOYARfVVDaIgOswJ/wsOGRCHHTk9f/9YqEMoNL7T9E8bSW3B/WHX3doV+ztTG48Qrs8X5iMUEkSk7jFDjDMK1vJY4gB497VpMz9OnnQCHF2NCpTvptCVJdliEG81qJbUKJgX999D8UfYZ4IV5ZtG9PyW47rqE7gfARN74/ETwbuR3Tl0T3Y0H85VeXWx3UHXhXD4809y9gcyQqSufNKiy+XHGKJornwaZZMejn4yMv3Hno+6Lhl6Iyj/9A0Ifdcf/APFds3Sg2jLOqSoogvoElU1ByoXlWwtrKvXGtH0k6dC/rc4nV8MmnUQ2h5HiKzu37idOyQwHj8aewK9LY+o5uTrGeyJ1+f0Ta1JrJTKvd9lE+8Oe1EwLdvYKVNe05trBqThsKJ9ctHv2dAoXfpulDkGyPJddg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(39860400002)(136003)(376002)(478600001)(26005)(38350700002)(52116002)(66946007)(66556008)(66476007)(7696005)(4326008)(6486002)(38100700002)(2906002)(6916009)(6666004)(36756003)(83380400001)(2616005)(1076003)(956004)(8676002)(8936002)(7416002)(86362001)(316002)(186003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HN4pJ6vhSDqIraNuQwzpRHyEuGHvZHANgE0SUUXQS4T/Wpt/imZvylWTUTEE?=
 =?us-ascii?Q?m1BNffAT0uq+fS2jSDxONYT8gxj4gKK7xIAyRRLJQuZnhTLl47chtCVKD87k?=
 =?us-ascii?Q?aNVJxymV3OykrGA7nbSbO1Bfb6HVH3eqePjyYGaOnF4Fx5Q6o7MrTi+cI35G?=
 =?us-ascii?Q?tKOGGOTFVP1YoqNYfZrT9EK1HDJ4jYUZQwoSJemO+JlmN2wH0LHAJczRH3A+?=
 =?us-ascii?Q?ajIlH3nZ9wLYQIBT5KfzjDwaVdW4sheo1kv6Ari2jfMrJY3tOepgFmOuw9o/?=
 =?us-ascii?Q?EHFcOqexKBmVbcY5eqJP+bgjEjga8miKfgIawWy5pGbXzMs6u7fOuovN8EF6?=
 =?us-ascii?Q?m6+t6GZV0p2kZLbfycvZuk+E55kIW+NhrVdHFElpdjjmnpJWn59lbci9ghI0?=
 =?us-ascii?Q?TGn+U3bPSSxeRKZndJakJ5eUOwkkpkpH13Hc3f4qcDrrpkD+bj8Ng6iVNWNT?=
 =?us-ascii?Q?PiFqiR1IQ8VG42QTfr4Q1w/MS1CNmdfHuPueDWsQudxJnkePEZtHy7OXPra8?=
 =?us-ascii?Q?72Js9ZDWxl2hfvdiFiaa0G+zeeYHTYtrK+UcXflQnY/gbrDW/dYrMhKcqtcn?=
 =?us-ascii?Q?U6pJoA94fYInqopsBzFlc8+dcLzy/0xPd6cMj4CXej7gekgWnPNWWTmiuMcQ?=
 =?us-ascii?Q?KjZFnOS6R/7x7xU63angBoUBJcHf6XN+FYXZhZeTopxX21IPy7kvJ3ufwbuw?=
 =?us-ascii?Q?6LzCnXDiHusQ06s0wjp7uYn8hfUwojAAEJNZ9C+hzB6dEHhY817MZ3EBqyXn?=
 =?us-ascii?Q?o51cRpV0gZuX3yUl7FHP1mVgDcGcwWxuLPP21KpzfLHuaFoxaCSitCKATnU6?=
 =?us-ascii?Q?HMeBoqAU4euh1BxK3qKCKB2JgISk8D9+qTpXf0Vqq55bP9E7tPF/0Ln1NdM8?=
 =?us-ascii?Q?u7o8csy1vHfP8wfhFKFb+/wGr25QLw47D97DprQNBp01PfDXUb/hlxe7/pri?=
 =?us-ascii?Q?bnsTCzwV7aDKnhpVvWlaCpdb1Feyk82gl5QpvhjtnOzjNovrT6+HfZ9qPPI0?=
 =?us-ascii?Q?Ce60bYWjUorTIA8SQD6VplFSrblvHeGFpHWMPoKVrtvIWFqlTA8Si7ROg6Il?=
 =?us-ascii?Q?VMt0QB8d5eQM+HP8GQ96nskRl6QdwwHU48gQ8gV8Cj+KfspaRlFsvWyjSzX9?=
 =?us-ascii?Q?ptH+NxOLFvdeC+JST2rBxo3cQ+574Atxla6a1iMiPODiAfQX1R+OnETsm2re?=
 =?us-ascii?Q?Xq78/i7fVw+KBededwjkWI3AzzMHyLOl9bDs+MGkdYQHGvNxa/P5YGCLfXcg?=
 =?us-ascii?Q?cuAFAJwuGl2RN+fOcnpf6+qKaxaH8Ud74r7JB6OLml5dnfLIM3m/0nqtRsni?=
 =?us-ascii?Q?ZMyA1ae86uzTAJ990O39HaC0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d919a1c6-b6d0-4e66-bce1-08d962692182
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 16:56:32.4739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rq/U3JetW78lvJnjwWqwUCweD2L+w2z1/53fiUJJWTFK20St9nCzBhqkGQoSB61W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2487
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the 5-level page table is enabled on host OS, the nested page table
for guest VMs must use 5-level as well. Update get_npt_level() function
to reflect this requirement. In the meanwhile, remove the code that
prevents kvm-amd driver from being loaded when 5-level page table is
detected.

Signed-off-by: Wei Huang <wei.huang2@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b34840a2ffa7..ecc4bb8e4ea0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -261,7 +261,9 @@ u32 svm_msrpm_offset(u32 msr)
 static int get_max_npt_level(void)
 {
 #ifdef CONFIG_X86_64
-	return PT64_ROOT_4LEVEL;
+	bool la57 = (cr4_read_shadow() & X86_CR4_LA57) != 0;
+
+	return la57 ? PT64_ROOT_5LEVEL : PT64_ROOT_4LEVEL;
 #else
 	return PT32E_ROOT_LEVEL;
 #endif
@@ -462,11 +464,6 @@ static int has_svm(void)
 		return 0;
 	}
 
-	if (pgtable_l5_enabled()) {
-		pr_info("KVM doesn't yet support 5-level paging on AMD SVM\n");
-		return 0;
-	}
-
 	return 1;
 }
 
-- 
2.31.1

