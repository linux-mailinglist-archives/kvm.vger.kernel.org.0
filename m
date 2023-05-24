Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4242E70EAF5
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 03:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239048AbjEXBrt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 21:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbjEXBrs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 21:47:48 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DF5184;
        Tue, 23 May 2023 18:47:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U+kwTUz6DI9duXVNyaE7fYHGfbJ5MQASbhkyHG19lKMIToqIS702wFEg7AQEJ6Tj7TXI+i68xbDdGiNIFNFm0pW9KsSJkgdvitZEhIbXn4ZQXwHtpdklU3N6z5rS/1juenYQUGwQUcDNsi4m6Ds/MSZsBAxnzbabwK+BetCE5x1EfqHrWkkVZUgaAv4OFRzNrwjoeZsBLA/6yWdZMwTSM+ys1KVeMXXB3gyVJOtz1xFWCOUXhkZierMH5ai3F1v/JiJaNSImrIcAWcJOe7977BSt7Daqm2OMtfr5vti7Q3LrESx9XzS3RXYhh4GfzEI1DEE/xSP5m6Xt2hP6ZwcSEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qgJbIcZKx5v84WwaaAM08aQe3wh+Sms6OGgmvrl2w3s=;
 b=UIB7IbvLJMU8YFG37dadNldFyBGWUk/QlnIydC5MaLkr0mXwTmlOszrelMfMWUSAjSX0kmFTMG/yOJrcZWWWsJSQGZ2TOxRfI62EOd+pvSS2vXJbb3S22tKGyM06NkySCjFNX9vAcCyeeBsSad9u8XUEzy1pXT67H4lM9KUQTzPNYW8u1dxI98DXVyPSFu2dwGdfJeNM0rtkKlvmNOsE8tGb+dPphTiLUbT5T9qHIbyNYiCZMOp0pgGYrINL5argURm9KRgC7IbDlhQsLlUxqfaAkqOx8JwGZu0GVK+EksO7mu83qgG/0YsVdsVL/OEKjJUQAIv+8V3P5xv7cgf87w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qgJbIcZKx5v84WwaaAM08aQe3wh+Sms6OGgmvrl2w3s=;
 b=g2uGb6WGtw3C6wRd4u2QWlwdZqrXpX6O8bS01j4Sj5Hu8JpX01bt47qqAfAEZ6Ocl5EB/zgbgHBQ+JhkW8mDR0emmf+BD458pMt9SHxkYZXeQQypcDN3R/h7pff2ZG+jE7eNbHXGa44in0nblVDGvronvHwg6cEqldC2dAM7+FC6T14a5OX/QZwbkIcbXRq4M7iinFIS2Z8mXNmsS4+P/6nGN4mdRSE2r9WIwc6ibteROAlZJn3t/koUTqXxJ8O7pULzO/Ir298UavTtltYE6IFstvWBLMv7Yr5bElo7F5WOEUyhz7SUxBk08FHC0L0VLz8ek96Ix33Jq66BFikZhw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3181.namprd12.prod.outlook.com (2603:10b6:208:ae::27)
 by CY8PR12MB7492.namprd12.prod.outlook.com (2603:10b6:930:93::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.14; Wed, 24 May
 2023 01:47:43 +0000
Received: from MN2PR12MB3181.namprd12.prod.outlook.com
 ([fe80::f0b5:271f:a7dd:9e2f]) by MN2PR12MB3181.namprd12.prod.outlook.com
 ([fe80::f0b5:271f:a7dd:9e2f%5]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 01:47:43 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        catalin.marinas@arm.com
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        robin.murphy@arm.com, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        jgg@nvidia.com, John Hubbard <jhubbard@nvidia.com>,
        zhi.wang.linux@gmail.com, Sean Christopherson <seanjc@google.com>,
        Alistair Popple <apopple@nvidia.com>
Subject: [PATCH 1/2] mmu_notifiers: Restore documentation for .invalidate_range()
Date:   Wed, 24 May 2023 11:47:28 +1000
Message-Id: <3cece716fc09724793aa832e755abfc9d70a8bb3.1684892404.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.39.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SYXPR01CA0146.ausprd01.prod.outlook.com
 (2603:10c6:0:30::31) To MN2PR12MB3181.namprd12.prod.outlook.com
 (2603:10b6:208:ae::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3181:EE_|CY8PR12MB7492:EE_
X-MS-Office365-Filtering-Correlation-Id: 296ad4dd-298e-4f03-37cd-08db5bf8dd9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D0OENjXts2es4bMNlg2aFE+gZ4jCjkAXHmoalV76JqMzGBYHMgECf0yOUKSjl/UV8FOYB0cdYJx48EID53jQATtNZh6W90WEOXQDUyia3apKoaSAc2MPaUIfN70kCJVuhMutz0KIsZBkjphqqwN1LfJtuDdCXozTv+tIALZJbRMLXC8gAnbEfqXlFvBhrl3rsLC9ITPGEMEZHWk/TIxI80jxJgZ+AtXgBQJao0WNEH9IuEtex3S3bpHxFjosONrq4DgwNK+tjnZYGQolBjH1WTOMQjCkeHBRbDChO/qu6fxrlWdRjoz9WKuEPJT7MgaTRns1b0rqKzSGFqzDLTZyZNZSaOaf3Cog4t0npC3ghj1qa/a01MmyerwRLYkwF36H8dN1q7e6R5H0MYhv0/FYpBvD6nEMYWZDibEaBiKR2OO3phJqw7Uzql818Ava/diXPu3Q24YFUBNaw1biAC74XMOWILdDNTS6JWsq0mskEeWQVqFJYrOhKKUfbfkcBWKaupWLeKlIuzzSmdGPtKK+eWZi1y7WGlvfoSH/OhNRYMOEnLrr92P/7TqpqqZXZc2Aqi7wSaxZVfZy/VOP73AmXw1nRTFkvwima8L+sefTi7uCRVhMPUQDZOwew09nKiM9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(451199021)(8676002)(8936002)(5660300002)(7416002)(186003)(83380400001)(107886003)(26005)(6506007)(6512007)(38100700002)(86362001)(2616005)(41300700001)(6486002)(66946007)(66556008)(66476007)(4326008)(6666004)(478600001)(36756003)(316002)(54906003)(2906002)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tl4A7wJneCaa4i0pkAyAA72UG0+OEGzvuvwm7SCqnucodfDKxvb2dZtkehKg?=
 =?us-ascii?Q?rfG9FetBUZtIy1iq9CtkK8TpSTbS9YgonJIcAEQzi5WK56K62thkYhPCc0gX?=
 =?us-ascii?Q?6FJw3ScThBxBXi1o1tOe+GCoIXLOflvfw8ToKWwj9QTGpFf7qwjRRwj5Z2kF?=
 =?us-ascii?Q?ysZutmYp2GavjPmkAG0R+yl4KwPMdRTBIRDfMzAwZjtqEYyXxQy58nizg3oC?=
 =?us-ascii?Q?ng0SyUQNFuFgbtWXRVyH+OLT4EyP5OYCmRDe3hEBmjfGm7N7EZ6L6TBtbWwA?=
 =?us-ascii?Q?OEB19/BnpyhX4cB9KcS/izYbavohOXnesdHazj5polC7s5sT+GCPpQANy17C?=
 =?us-ascii?Q?70vulZy2qgwGcWIimTa1r7U+D6bwtHItMxcXtCAN0ged0q/GQH5n65K5zyfG?=
 =?us-ascii?Q?/NLvB6MCeKujg0R6opF2UvwRfzS6bzqQdxWpHT3K6etb4ei5UKuGukZESWRV?=
 =?us-ascii?Q?++ac6kA0umy7nAJH78z+h3O0KYdz7XffUliDuUYukGZzXDvLKiCSi0l/cl6+?=
 =?us-ascii?Q?2aT3txhxtU7sn1JBAeOUIidF+Rkb9n+cKbtAZSzG3Z1N81axUE8tzBjO4FzU?=
 =?us-ascii?Q?IM5MtJN4yKCu8qXRTeWGx7sH7VKFWNLexfk45kPORLf3qbbydna63FaR9FSj?=
 =?us-ascii?Q?oRMVfAusgVeXcFgVGVQdwhBW6kGvkPbFYg7LjP9YWfu9aEhJDTAw5FFhtvZ4?=
 =?us-ascii?Q?A+qKFbKQ7haBy3X7XZ4rkd+++lyiuKZuQ82CIELpY+dx7lFoqOxgHlvoVvv7?=
 =?us-ascii?Q?cB4F9ERTnA59qPeyt/gEsXzGtut6+qg4jLTwYbD2+HxJyl6g2xjtCvJ9rkCN?=
 =?us-ascii?Q?fmwjhBS5wJtG4/T99DO6HHln1K/45tv5MLX90kmJpNHO6/Tywh5Gc/gWlKNI?=
 =?us-ascii?Q?z6qzxM8+zo1m0vtChm5UakqoowempNSOe//w4MeDmNU/yy5kvt9nLC90yalE?=
 =?us-ascii?Q?wzkTrjWhRDPsst5APCWZmBpHTG+t7aRCGVxUyrhvwVzMxu4gLRhl+0s283Pw?=
 =?us-ascii?Q?6vs/ZzQoSmJDoBCrbVMtwhnRDrSEisHFypqpuEVZSVzUwNTi3JexY81D9PUl?=
 =?us-ascii?Q?3IizYE1083evc9fivyLzZwo71Ysgo2ACztur8wXFrfv4sJDf3WEkS7xsCg1B?=
 =?us-ascii?Q?W3FVNJOSIfw9+iSmpKnuYx+BGwreYY8gB0/OPNmo7DmhOYonHMGR7/+bsEWo?=
 =?us-ascii?Q?CKHshVw9FeEwRI4MfrKfvSgjwSUTGOMrkHydJH1LgOFDyrZaE7dFa6sLVfQw?=
 =?us-ascii?Q?vuuKn4lKgxsZyOE4GmlbGEwEFFCFrZm3V0CVommIGC3zyYEroV1156QZg+xM?=
 =?us-ascii?Q?arsrWovLAI/zhYwUmfvGsSpAszDIOBLWoBv5B/huPV7FViZICHvOwXg4wJT9?=
 =?us-ascii?Q?Nur+duMaXwyKiQlAZ+8Miv0fYavh22zQEll1i3qdeCFGsFNtE/nNpR1rR6eN?=
 =?us-ascii?Q?6HIheVAPU92GDmER2gVeLlHXoN0pt4HAqxE0mU4NXP6LNtSkQ9QhlgXzMpUT?=
 =?us-ascii?Q?vLQi2Av0oXZIefkSQuqrdD8xvXQgWgmZ8AnpHrzNDiGW4QJXlLBje31a1hxu?=
 =?us-ascii?Q?8OiDzirVSIUqjOHYU0Pm662N4Tk98j6LHYlZ7aQy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 296ad4dd-298e-4f03-37cd-08db5bf8dd9c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 01:47:43.3322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o8nzlMl1N86IZpbrrpOE23VRaBtxSTgVMaTXhzqKgky2yc/PjvPLZPmIznMHUzOSmTQ3/JiAcmcxMvDwkw90uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7492
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The .invalidate_range() callback is called by
mmu_notifier_invalidate_range() which is often called while holding
the ptl spin-lock. Therefore any implementations of this callback must
not sleep. This was originally documented when the call back was added
in commit 0f0a327fa12c ("mmu_notifier: add the callback for
mmu_notifier_invalidate_range()") but appears to have been
inadvertently removed by commit 5ff7091f5a2c ("mm, mmu_notifier:
annotate mmu notifiers with blockable invalidate callbacks").

Restore the comment to make it clear that .invalidate_range()
callbacks may not sleep.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 include/linux/mmu_notifier.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 64a3e05..447d757 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -200,6 +200,9 @@ struct mmu_notifier_ops {
 	 * external TLB range needs to be flushed. For more in depth
 	 * discussion on this see Documentation/mm/mmu_notifier.rst
 	 *
+	 * The invalidate_range() function is called under the ptl
+	 * spin-lock and not allowed to sleep.
+	 *
 	 * Note that this function might be called with just a sub-range
 	 * of what was passed to invalidate_range_start()/end(), if
 	 * called between those functions.

base-commit: 44c026a73be8038f03dbdeef028b642880cf1511
-- 
git-series 0.9.1
