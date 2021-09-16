Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA7140EA31
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 20:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243370AbhIPSrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 14:47:31 -0400
Received: from mail-mw2nam12on2065.outbound.protection.outlook.com ([40.107.244.65]:60385
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244016AbhIPSrV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 14:47:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZDUAGZIoWKqvtmrhVIPGuLvaYrBG9gMs+5PxHamioHTN360tO9gc6xmWNi4jaYmPutF/ud0sB87m3pRIOHJL5hz8g1BRpL26zabRVkgBMUrUsLLn1leIiLi6qJIlBBc6lOfRxr7/+RBWzFYmcxcs9HoBwsje8UrfCfqFxvc7wW0WPUEEAdlH5iHEIcdH2HW0rzqxhukvyxqqC4feFfVJ5afEgPY3Ftebb7EdHM4mwyRJHwCf/UFyHrlMFesKi6HGRmnSHem1TC9rC7swin4lQ9rSdglXPzsrefFltwKNuT1pKk7S131EveD/e+wOkSwGRcQfcQjAenybvR+LKLwzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=qPuZG36Kti3W8VsYNTZpWcXj+t2hlsvveW0wrHdM7FE=;
 b=lsljcxgNv76xxUwTuavMkY12sd/cRSb2RVFGfzXANshh5slwi7sPS1yNgb8scqP+K70C2/BL3u9eu51ukeWy09ZCrHKCpaHMiCVKPbgsu7VFdWwMZyYujijh8YkMgR7WJq0jQF1vLrsWJnUvpeq3DktJFSgxWmwLJzyyN6u8aciruUkQeUXochjC2Sbo7/2u2NkhRmOug9Mo4u2IAkCHaBaXSNHG/omBmazn1zEspZ9lXzlZ+o89mpKCZrR0KZqapmxx87AQ5Wv1Qq5R98XbrSOb2Vom29EwyMClgesdPIovAnR7NrKatFFFTbvVt5azwsR3HyskgApoDTIgkvVvzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qPuZG36Kti3W8VsYNTZpWcXj+t2hlsvveW0wrHdM7FE=;
 b=Nx+35AKWDUYhUQRcqWujWzXBYTSPo9ESG3/kSBg+7c1VAlS3LaBT6AngvI/8j1S94ZNMMi6iTU2Sq0rcUKcsyibCpgryEqvbgGi+xKV5E21/ZdY4CIYFi70gVyjHKSVFSkmtaze89IzNRzmKjGJc2ULBfLpn5ymj9s4TaxkJJOE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com (2603:10b6:4:5b::21)
 by DM5PR1201MB0204.namprd12.prod.outlook.com (2603:10b6:4:51::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Thu, 16 Sep
 2021 18:45:58 +0000
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d]) by DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d%6]) with mapi id 15.20.4500.019; Thu, 16 Sep 2021
 18:45:58 +0000
From:   Wei Huang <wei.huang2@amd.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com, drjones@redhat.com,
        wei.huang2@amd.com, babu.moger@amd.com, krish.sadhukhan@oracle.com
Subject: [kvm-unit-tests PATCH 1/1] svm: Fix MBZ reserved bits of AMD CR4 register
Date:   Thu, 16 Sep 2021 13:45:51 -0500
Message-Id: <20210916184551.119561-1-wei.huang2@amd.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: SN7P220CA0027.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::32) To DM5PR1201MB0201.namprd12.prod.outlook.com
 (2603:10b6:4:5b::21)
MIME-Version: 1.0
Received: from weiserver.amd.com (165.204.77.1) by SN7P220CA0027.NAMP220.PROD.OUTLOOK.COM (2603:10b6:806:123::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 18:45:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6b75e12-c92a-4060-53b6-08d9794238de
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0204:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB02043853DBC767CDC5F73387CFDC9@DM5PR1201MB0204.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JKiGVWURSGy7o+EI3eEupTVh+iEpo8fhmB96a9Ri8F2a4VKpjYJJjAyRyDQdbP/IiaSR5586eUSGd0mTk7UPs79Q+YSgL7wIVGWPmMS/sXLBKliK1sb+f/TDGDYQDfDyg508fHX/XM/Igq761pIDYwUoNSvAvjlRzBb1HS84WiSPqUcmi1faf/+gRk21AHTtChem2+NQKDR6H1O21yt/B2R37kEYAKkaNY6iKYcTAMrrPu3g8O4+NOZaDt5BlrULtRchuFce6eCJ7G9yj8/4StxSuW6mRFOaR6oZ0rxeu5f0m2yn3SQft0a/PM3XeG5iIt6pdNlSMNZmr2d8yZ1wHKCagEnhEV5jmhS9B2HfcyxJ43TE1XdaMkxthJpXoZd2koZaluZdUveQDWVZC6wyUtB8izxdSc1OG8VNQZi00huxCLkA/O/W9XejljBZglyT+SlzatKKnJ+q/TT82p3NqLVd4INzpwjhM1d1GfrJ8QICqGLuWrSA2iQGEs0i/aeaISM8y4e0qYV+XNvH8TYWUd9GdGV62w9458jknnZcWdkggu2M7rDbs8JAmPzsFDINWHhGfijBX0oTqGX3ETUcBVYmy807osarpVX4Mc3YJS7o7rXEYWHAIapJ9KpMvnQjs1+lUi1Ln7YGBAQQfRltCRRfYQ8WrczU4WsRuynw6Z2ny0KCcJI23MB1QSQjJt08uHjfKYfJ/Cm2lUpqQRKnGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(186003)(7696005)(38100700002)(38350700002)(36756003)(8936002)(26005)(2616005)(6486002)(508600001)(83380400001)(8676002)(1076003)(4326008)(956004)(2906002)(6666004)(6916009)(5660300002)(66556008)(52116002)(66946007)(66476007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aq5vSohs9MbRHQZyZExUCZfaeVp3WWPYnz6JhyD69p6C0XJD8Hq2MgyZgKEo?=
 =?us-ascii?Q?qPGSN1s+VAq6JIVLcakmmiGAsHjC5rC5jtvYhGLeaZSL9g39ykWA4AS2D4zv?=
 =?us-ascii?Q?UQ5at6lDYbQayXZZODuue0ASCBSAM5BdkZ+/iPyh927bzcoo048c7kc1oaOZ?=
 =?us-ascii?Q?g1fJjYDT8If48ydgZy/hA79/plocEzPua3nmD1fBmt+z052NdmAl3+LJW7yJ?=
 =?us-ascii?Q?bjSsOI2/c8fWSrli/2bzsaJ94okvxd52vir28yTpaaeQBJGaR90I6fazfyEw?=
 =?us-ascii?Q?XnVX6YG1KCYu3cyPQQBSgV3IGra3kve4zf9bUMxXJIZQrXzU3eAsB83bjl38?=
 =?us-ascii?Q?oig3FD9PX9O6kDlFO5HPShUOJnqOuv3dy6VQ78ybmoYwWImhvM88P1KB3RzJ?=
 =?us-ascii?Q?aRybGFAbf5o9ilBq0ACujLCw3mlfq7EL2txj80EdvRoLXMQY30U7eguO9l7j?=
 =?us-ascii?Q?0CzSrcUJ76Rcq264sgV42IPajs/BwaFvxuBYVCdP2nu66QhrpHsL2S10N/dY?=
 =?us-ascii?Q?5aotRokN5tXQaVuGl+/w87uOtk5xj78854X0d9DDzTDs2qLDLhsjN4j8WS4l?=
 =?us-ascii?Q?1CVpMpME1XIreuz+4WYz7CmqTED8x41AJzVdxykPHaL8iCtAmZcgCGrNVFt7?=
 =?us-ascii?Q?FmrSKNMCPBenkG2AlmcngTA6QPj6bq9HUNqMzOa1oaxaeR3gWqFQ86hPN9Ra?=
 =?us-ascii?Q?4Q0chDzZVc++tjE3lWMPfqnzyubZmoFTnqe12qz2GlMNVxPYTfnJA6jCH/cr?=
 =?us-ascii?Q?BIaDMwwSWFR2JGhvOmWF1Gs2uQ0l8Dac/Bno/IDR3Z89H2MBBPXXUROruK7w?=
 =?us-ascii?Q?ifrOO+7R1SUHfLoFnGKqpndYwX00NdskF85V40Zl0gLFD6MZJdHzAl1IKAQr?=
 =?us-ascii?Q?i7QRqgSF1G3louY7vL1/6lR3Ey5vCgqf7oifGY8Q9dCkZPY7H8f3WNlITjnW?=
 =?us-ascii?Q?Q9fyEABQaPvFwzjyssEMaLqlr2fY0IZVpu+oQp5WpbBN/CkzrTZ6S2xJsSdb?=
 =?us-ascii?Q?dt/qewawq8CioO9oFzDRxf9RiFGjJLMmk1uQfk5lzbSirXW3681FSm83j+gl?=
 =?us-ascii?Q?cg6sTvbo7vdTAdRWm0v9/0EqTKucCTyFB1IIphovTgA+QU92dfNVC8KtMyfa?=
 =?us-ascii?Q?IryJLU+N9/Ib6mlHAUzvQhcrTZc9ui+gigdYrJ+OMixZljSzqujCRT1fZPn0?=
 =?us-ascii?Q?2f2EjnfUUizT4ZLB+ChUovKe68X3QuNQ7SpMT7pE9gLATsWYpqrDCl0INGoI?=
 =?us-ascii?Q?4XcTHMECS4Dkbgyxgb2x2qMqnuKybZ1ui/qmwTy3+9/gQQaOMqoUCUdqd+fw?=
 =?us-ascii?Q?hav9EEua94vL+MI8fa6+AZcU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6b75e12-c92a-4060-53b6-08d9794238de
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 18:45:58.0032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yoOISmv4QcFU7cbe5iI0gnBu++x7D5/alIWSG9jp9QPZpMKCgYQg6YlTs3xtsAaL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0204
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to AMD APM, Volume 2: System Programming (Rev. 3.37, March 2021),
CR4 register is defined to have the following MBZ reserved bits:
  * Bit 12 - 15
  * Bit 19
  * Bit 24 - 63
Additionally Bit 12 will be used by LA57 in future CPUs. Fix the CR4
reserved bit definition to match with APM and prevent potential test_cr4()
failures.

Reported-by: Babu Moger <Babu.Moger@amd.com>
Signed-off-by: Wei Huang <wei.huang2@amd.com>
Tested-by: Babu Moger <Babu.Moger@amd.com>
---
 x86/svm.h       | 4 ++--
 x86/svm_tests.c | 6 +-----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/x86/svm.h b/x86/svm.h
index ae35d0844788..f74b13adb068 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -352,8 +352,8 @@ struct __attribute__ ((__packed__)) vmcb {
 #define	SVM_CR3_LONG_MBZ_MASK			0xfff0000000000000U
 #define	SVM_CR3_LONG_RESERVED_MASK		0x0000000000000fe7U
 #define SVM_CR3_PAE_LEGACY_RESERVED_MASK	0x0000000000000007U
-#define	SVM_CR4_LEGACY_RESERVED_MASK		0xff88f000U
-#define	SVM_CR4_RESERVED_MASK			0xffffffffff88f000U
+#define	SVM_CR4_LEGACY_RESERVED_MASK		0xff08e000U
+#define	SVM_CR4_RESERVED_MASK			0xffffffffff08e000U
 #define	SVM_DR6_RESERVED_MASK			0xffffffffffff1ff0U
 #define	SVM_DR7_RESERVED_MASK			0xffffffff0000cc00U
 #define	SVM_EFER_RESERVED_MASK			0xffffffffffff0200U
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index b998b247d87c..547994df065a 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2383,13 +2383,9 @@ skip_npt_only:
 	vmcb->save.cr4 = cr4_saved;
 }
 
+/* Test CR4 MBZ bits based on legacy or long modes */
 static void test_cr4(void)
 {
-	/*
-	 * CR4 MBZ bits based on different modes:
-	 *   [15:12], 17, 19, [31:22] - legacy mode
-	 *   [15:12], 17, 19, [63:22] - long mode
-	 */
 	u64 cr4_saved = vmcb->save.cr4;
 	u64 efer_saved = vmcb->save.efer;
 	u64 efer = efer_saved;
-- 
2.31.1

