Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6053E3C86
	for <lists+kvm@lfdr.de>; Sun,  8 Aug 2021 21:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbhHHT2G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Aug 2021 15:28:06 -0400
Received: from mail-mw2nam12on2086.outbound.protection.outlook.com ([40.107.244.86]:7744
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232512AbhHHT2B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Aug 2021 15:28:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oODMt1TUDUWjX6qCzxlSaQBzOWl1HFKSIJ60LvVqC+DBSBNl08ugLRhNEgNyr9ucPsOD9M0Xd37caelptdwiRGT8zF8M81wftSUiym8cpxp6CuW5/YVgs1pG3rOO7r1/ithLxA+1fa3akHIfmW8EFbrJbxp+gqaJoV0iX0Lc1TUQaqO+DtkPMBt/mSCKdO4MoAPxwCH2Gt/YDrLKEcPz9hwSLkL1juDWZHqSZbiK20JCDnRyGmWX8e24rQlwPgNSA7b8g4J+DROGwTZ/ws00edx1DF4CuIxUp1PILyw6DvkTG5VuctkfwpM1liyI4yWZwpkodU09iIn3gAmL4utLvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=suaeuw0WhDhX59QF9PkszMqhn1lSiqzEurIUweovBHE=;
 b=aoul8fcG66+ia4a/zCJ64KxJndhbdunrFJTsS+YhUjowahttUyhv67wPxUymWG9oJtUTZwuDqEYSWl/+yvNRcO2fRl5l8c3phrDaAOmbejxIcQ6EnKTrHszWUWo8t/KoqtD580d3WZo2P5T0P2H71PPMSr0kxS0kIsVtKmfd4D9HChAt2ZFhf77EZYh7GRkbvB0lRuQmAj0iWNxfkdz4rbzDwnauZD8Z9ehbnuj9pl7JpPB6nwwdzjqo5DnIheUfG20eqOw+IK57Lu6QYSwHYy49Rcqs9n0Pky0VZjFD1umlqw+6bY3NgKzP88vqtDmR1vfLhaABE+LFzU3Uj4GVag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=suaeuw0WhDhX59QF9PkszMqhn1lSiqzEurIUweovBHE=;
 b=YpS3JhVADB+TrRbry4Rw8F7sh07hk9zU/mQyoMU9bNbnKQsqqUL/T1eDSQEbreC06lcYtJ4HMRIs9oMuTQcHAias3qwKLLzdRADc0mnFXI+pdZlWNujg1+6WXU9Qzm8TqEm60zlf+99bSx506Gmga9OGSQVpYKT6LoWi6ef5uTo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com (2603:10b6:4:5b::21)
 by DM5PR12MB1434.namprd12.prod.outlook.com (2603:10b6:3:77::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Sun, 8 Aug
 2021 19:27:41 +0000
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d]) by DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d%6]) with mapi id 15.20.4394.022; Sun, 8 Aug 2021
 19:27:41 +0000
From:   Wei Huang <wei.huang2@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com
Subject: [PATCH v2 3/3] KVM: SVM: Add 5-level page table support for SVM
Date:   Sun,  8 Aug 2021 14:26:58 -0500
Message-Id: <20210808192658.2923641-4-wei.huang2@amd.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210808192658.2923641-1-wei.huang2@amd.com>
References: <20210808192658.2923641-1-wei.huang2@amd.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: SN6PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:805:de::20) To DM5PR1201MB0201.namprd12.prod.outlook.com
 (2603:10b6:4:5b::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from weiserver.amd.com (165.204.77.1) by SN6PR05CA0007.namprd05.prod.outlook.com (2603:10b6:805:de::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.4 via Frontend Transport; Sun, 8 Aug 2021 19:27:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ba058ba-d4fe-48cb-6969-08d95aa296e3
X-MS-TrafficTypeDiagnostic: DM5PR12MB1434:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB14340CB991AFE5CA5887796ACFF59@DM5PR12MB1434.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v/r/M+X4tqrRRcWbJ0N+zRai6KfOsglfCN1xstJ3iLSurXoP3p1gSC2CBXT4WDKK08TIyXZ4OAOJY7Ekxsh3oqHlM6JGewvYVIIK85tev67bFvJsVqzr1VoPmxNMvVw7bVG9lILI7X/qSatApB4pKP4ucR9dJvbJZG8gppZMXKtZPBhiZBC34YD8JMN8t/lT4Q6mj5S4F/8Ntlu8N0RjjXEdcLHeBcxaMwzxfyajcqnRNmPj/lMx2WTwsn65nRVAXo2cE9m33tDWtZzIe3ALojs7Q8v8yKGFdpGt3h1lkzeM0wtJ615t58dsRIc9amYjFOLaHj5lbrm1H4YcWtCJe7c3/MkVU+/eBoLvvoHv3txTZoaDLbrtplZn+R074NwXgqKACKRSfrTB1xtQOKCbVhixn1ah0BTEhuooME1Tfwo+DwsAEOhIs/dQKspZJV5RdLBzxA6E9eixrOvJqtYaboCrCUEcKsC8q0uQwCuMwxCCe+tLDe/cyLFgbwBWYPMTK567cKiTWWStv7ESJraJafYAYZen6LesGursARDYjaVKyrCjMN3Fj0h/abevl5zb7QfxUPaZLIu9RSx/O+AdyMIshjNuGhehQ0rwxAG9tfRQ5cF/GOYzQE9z89dstuAK/kARY4Z3iCEne6m7Do8e4sEJUme476v/AGVXk+JCbF3NlCZX2aeTrUcQNzRgK4W8Y0iBZzdRroqwtI//vjbsYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(6666004)(186003)(86362001)(83380400001)(4326008)(7416002)(6916009)(5660300002)(1076003)(8676002)(38350700002)(38100700002)(8936002)(66946007)(2616005)(66556008)(66476007)(52116002)(7696005)(956004)(2906002)(316002)(478600001)(6486002)(36756003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fUvwuOUJIP2Px2itG6usAecDsyGGIgvGWxEhg3f1M2gau8KE7FQtPQVTZPfG?=
 =?us-ascii?Q?LndKQjET55uR6kV/4+mf8QEQ84juLFdJVUfP8sGn7aSXn3Wa6ylecHLKq79v?=
 =?us-ascii?Q?AcUsdJ+oPb/mkujgbUVaSlQDeqTzB3Z1UoPI3dNw3eC8UeUAR/3xBiPw0rYO?=
 =?us-ascii?Q?s1WdomFL+M5wgVyqpYtZ3Nss/TQ7TRKfF1oGsN3gD2yHSyikzUoPAK9onMFG?=
 =?us-ascii?Q?zeybZuo0nqxMExzZHPGk6q2eY9KLfAshAOem2EIBz01ogKBtD1teZ1+75wlV?=
 =?us-ascii?Q?23sjUKYU8Q9vUXACaanJ0KAaR9QpTrqB1IdfHfNWvSZiHJF8Y9L1K7a13f5a?=
 =?us-ascii?Q?+unoaqF1lkzRtC7a/q5bprcfWKztJmZIsRqz5DU9JzeIwcwvkUb4DI6V8q8W?=
 =?us-ascii?Q?Kd+/JmkGxI5J6xbOzdyHWeNv1az64DbP6ryFvE86nX19phibYiBNTH/8Bzc3?=
 =?us-ascii?Q?oxbYgC3j1qXyrWvL9Ab3AtbFXVJU0jTZpO40wyHQO7er0ixxvsAmOyLFb+RI?=
 =?us-ascii?Q?ODhoXdI+urja/VF7g9MpVa4KcXPll9Qd2D2hAmbMqXwoUzqvr015SFnXEN4d?=
 =?us-ascii?Q?tpGKEmIL+KbUj7+hBStrg0i/iL3DNpS02yNBqsuxntjU310LmKbXun59b2zU?=
 =?us-ascii?Q?rfghhIXX88oqwVFu9yegLoSIC5flU53FmmeRP6Bxq4IbDcJ2ezHPmeemSsgr?=
 =?us-ascii?Q?nwHjVxEzA4qMWSfsWe3qnPAoWn/zKD94V8FjY3GFHnEra6wZn/eEx5DIX94V?=
 =?us-ascii?Q?ujokevialYh04TIMFjGUnazNDkOecjguVaL9VqogHiGQmcjtWm/WeFXO0irh?=
 =?us-ascii?Q?v8NgHtdseqqf06umjvdcprS2Ue7F50MIkVHzmOVjYIcDaFpLEBOpNn79lBdP?=
 =?us-ascii?Q?G2XiThVBGvV1dYINMKiH3Ic5FWp0HzBoBvIFdWpawQY879PVPGvagBAjPy3v?=
 =?us-ascii?Q?+XeTMDvbjHbUK37JaAwSovPyNRQWBagvs3VGPtjEkMFBmCjGbIPfnBvIGLEj?=
 =?us-ascii?Q?X5Wa3sI4WIVb+8fe7KHVa7xZXKJd5jPC6ISvvFPyRrIGBU87gYKK+y4vsrmE?=
 =?us-ascii?Q?0pgmhfNRpS4oXfNsV6VwNTv2l/Gj9qwMzTeynzKLLoTAKNeawksm29o+GZwP?=
 =?us-ascii?Q?c4T0VvcOGAqjZMea211lHryvz+UwJIhic4AqDnVPqwkeJIqQhhR89iP0cHH6?=
 =?us-ascii?Q?SoMufz69rES7M7SOfg+Hh7M7JoRqhW488yegt8+eGtw/f2f+XW54Wd4GueO8?=
 =?us-ascii?Q?vlLKUOrW0OWcYTW90J33rwEBfaJQZHYuBf6+ut/GQVnzZAkkdUnuGbkbPChn?=
 =?us-ascii?Q?pR9+QHWMmH+91JVC2QQPL44R?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ba058ba-d4fe-48cb-6969-08d95aa296e3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2021 19:27:41.3922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wkaTCujOfzZq454JrFI8U+YNsBTz9JKF8yzQyAk1IxBCHnkRGoToHJ1cjLcAAA9P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1434
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
index f361d466e18e..dfb864f2674b 100644
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

