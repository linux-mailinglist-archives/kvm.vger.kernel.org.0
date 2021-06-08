Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB5D39EB19
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 02:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhFHA5w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 20:57:52 -0400
Received: from mail-mw2nam10on2041.outbound.protection.outlook.com ([40.107.94.41]:6904
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231278AbhFHA5s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 20:57:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OVlkVhRF0HldTeAGok4gPVy/2rWJLo40bsTz3NOSg0Jz+7XUA6tTv3SnN8Q3Ar7SKXDoPAXldOab6Pijs9p4J0wCDkZg/PheYuB4qBFGOwrg424UKFGZixLlRQQX0aWD6fgGjRyVrG4k7d3TbDxVhqiTa5lD++kn3AuqxsPEzne5l4vRfVZM5T21xGjKdU7uCJ0O4Xq1PhhxFymgj/sQjMWuSpG5DqjaoRe7+4xC3rFVPQVm5LXfaiMFJ+R2nXxCZVFjuRtLWk3xjr/t6fardMBqrRti1FDeo4FNEo4+7iABk3s1i6h4F3rOr/6xGeq+Bewq93FDhH5FyBApFkwkZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HHtG1v4SqkIDAudWISprU490krVZpy6TNBLpeMuNLyk=;
 b=k4z1GkhLIwBA1XkxQntGsmnY+CVM1SuW5WDSMEJ8vlzImqXGuvx5yela1UjjvJXQBjZwjrPjqfL+cRthcvMe8SEH9TOYYOv1ECnrnnqhs1i0h0K5D9QQ4BKP3bGTac1oxj7Ac4wM6WfUNCCW4CLY0RhOGQ1lcPiA2b4pIcilr5MqtbZxKn87pkMvfs7HaoM3kHgQECGOUNfjYWo08bHu034HP+r2ZmH/Z29VAfeDCne0/VLRy9QGoPWSKPuAVq+2eElRP3AypD7RBa4LVxYYWn98Gxd2YQSu+tveCLe1kzwcRLwSyaPXIjcjRI96Q6ZnaKIyOCaCZ/aBK9Y4TgVGHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HHtG1v4SqkIDAudWISprU490krVZpy6TNBLpeMuNLyk=;
 b=p9H5tiZ8SGVqsLJqaqHiS4EKBryDodot4dvN3HrBuh2oIexD4B6ySz8QEoZmgKpaeUYPxE4U38LcV+m5spb11p7lZ5obenfsy3e9HFB7L4R/cWq8OsyOYEkLZO5rc7wXUz/YYcdDRplKGqwyhg/qD2EE5mYlszJijYqco1zBzxNpStzZo6aVTgz4gXuFWkRz0JbsEAMMu6YiGpMSHpY5seILO3q2IqFjTJYPB/XKNjwC/IGygmpdD6dT4cH0qK5i3X2iAhM5chsxy//60xyIC8UJqc9eauiBZMyv7xYdEwxn79RFtGSpCOzs6IAAif5I14TfvZsNpW6dw/mlN6UucQ==
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5095.namprd12.prod.outlook.com (2603:10b6:208:31b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Tue, 8 Jun
 2021 00:55:56 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 00:55:55 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>
Subject: [PATCH 01/10] driver core: Do not continue searching for drivers if deferred probe is used
Date:   Mon,  7 Jun 2021 21:55:43 -0300
Message-Id: <1-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
In-Reply-To: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR12CA0027.namprd12.prod.outlook.com
 (2603:10b6:208:a8::40) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR12CA0027.namprd12.prod.outlook.com (2603:10b6:208:a8::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Tue, 8 Jun 2021 00:55:54 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqQ24-003eKK-EI; Mon, 07 Jun 2021 21:55:52 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32df214a-5582-4c7f-79c6-08d92a182b3c
X-MS-TrafficTypeDiagnostic: BL1PR12MB5095:
X-Microsoft-Antispam-PRVS: <BL1PR12MB509557AAE6776739B3CEFBBBC2379@BL1PR12MB5095.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:595;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pi4ZpU3EM8CZLNfiKXT74QE8Bt1E8weECxwgiB86ZXt00pWfp3nKfnGuH96k3jQxZp64aAfvr73Wrz2aKb1vbX1bGJqNWZEmotiJ/LMpv1blb2riB3YnndAA8hve1irWCCrcqC55Tdyo4SPW+f1x/hwwNLFgfDWdF6Z33Ejxm/H3cExII04RUPMrRjnnzUz8yZVdGXAjiB5FSYgjC7sS6lIyck8GrCxLgCLz2AfIIIFvohBZsNcAvDkUnvdbKS16AGSn019xGV8XIPOSWsKuivuUie3/9t+kxfUH7cc4xDxa/5lPr/kGTDm9bKy7A47qqdbeGWLf5DIh/psUcq1pewirwNWo+indiy09Kwaa+r1iubCs8mUXP4TjOOluCt2rtn0VEDYlI1AXPQTJMHBi9LoYKvAgLq5HAKFJUR368vfBstAGPhDtiAyti+PT+71VuK+2phVvP5aP17YF4Hl8gpq7uO0H4XksJneVA26XPtB2ZnHcC/nIV4DgJ8CWaF0wTy61il0U9Rk9fEhc81ZrYioIoP/APQTtAqbvOIvS7rk9CRAKM1QM7Ihwlz6pUWmg6phGFk5IuOToWQPogknktBPY1qTLSFrG+GQnKeNrhcxkLl3GP+Jcy3g8XkbPvxRSYC9NTmG5iCJr4g0T5EXTOtssd4fHSDoqLsVYpU+N/m8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(346002)(366004)(396003)(110136005)(2616005)(86362001)(9746002)(66556008)(2906002)(36756003)(186003)(9786002)(478600001)(426003)(66476007)(83380400001)(8936002)(8676002)(26005)(66946007)(5660300002)(316002)(38100700002)(6666004)(4216001)(51383001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uiYmmLq1D1GdVHElxBbhOO9foh87swFGLf62U1l4yORIV0srz/J3zPuo0/WY?=
 =?us-ascii?Q?x+++aHMtimnHvBkxFt/AWCLOowO6LMwkxYjvYGXOFZMRPdujV8NPTYasKtBM?=
 =?us-ascii?Q?gke9LL/iwinme+sbPyqw5WU0drJoqrjF2s/iDpiXyU+mKf1Q+H8PTd95Z/+W?=
 =?us-ascii?Q?ceDmzYcFvGzSlkooo64WTL2Wa0N6CDrB/7zJU65XVOQ2QtZAT4pY22B4G5uG?=
 =?us-ascii?Q?zKeNqpNJmATn/T/gWsyKXDdG8FXWccF3ZfbRqHBOuoBu5Krqp5Dk72TcFo++?=
 =?us-ascii?Q?VkGJQPwMk9zj7bwSRb12nYycEEbKxfcBE1UPhZBrWjRXfvVdQq65nI1Cazr2?=
 =?us-ascii?Q?mHvjyR4CX73Ufvs/xvlWWRyn2C6e4sZzer3z9dR1+3VlCf0Axz/IAe/XOSn/?=
 =?us-ascii?Q?K1ejQ1SInDrFtW2oHF7PceGQ32kO5a7OThpbJH2IWKd6gaVbB8FkE3MvPSsG?=
 =?us-ascii?Q?0FMKoRzM1/uU7wFpUK/fLmbYLCZkqgNx/tCJAtmvNvEAHfyvQvpnSt6M1Td8?=
 =?us-ascii?Q?hBDGq18DslwpVnEACtpoS56kzLKZYih6lwWoJgEM424Gg4JEN/BcoHwx18aD?=
 =?us-ascii?Q?k6MV4xjrkFwTz0a/+63M4zV7kKsrmcoQ9oIyP3TTmkDY20LrDKkAA5x98mN8?=
 =?us-ascii?Q?UyTs+HA9la3gW6kXo2yElXnmCuzi+iTY0v1SgBmrDgAhmVBvsOwF4jVUfClT?=
 =?us-ascii?Q?UEXlRAbsc20jDyt3KidxpH8aM1buvVeFDW4maUheXXu7GKq3y09+6pt1PNqE?=
 =?us-ascii?Q?3R8FOGgANAjbJLGpvwRsGoDPtHtoIpb9cmH2kCzSgdN+CFMxCNZUxlh/MxG4?=
 =?us-ascii?Q?LOZrzXOJ+P7ZcAp4AkAjmBAKHvleQkYMvUwKmW2ruBXhCMndc7np+sLtwUvu?=
 =?us-ascii?Q?8OuBEHA2Hz2V31aG7uQ9LdWfAFjTeMTcpGjE8hVp0X2dxxQALXTXI0/HwvQw?=
 =?us-ascii?Q?E7iBIqrOpEBS7aNJdaaK0iX8vqiNz1O2YNG0/jWG0NiAbY3zCHTqIpTl0P9T?=
 =?us-ascii?Q?UwjnwT/6vFkBNKiKvqYoi0/Zy03sRNSu4faM59mAA1CDDGvh/KJZclzaVDOu?=
 =?us-ascii?Q?B+LzvHqo6CB5ysgRExeyIBFuZ4/igwbLbp1zTRAKWEXmwj6qlgRHJ/qHHJ9c?=
 =?us-ascii?Q?Jm1wSosiX6MTYzm82W9lVru8+y/saf/fzkhy3bRv0x/HASH37TiqTFP5rpAk?=
 =?us-ascii?Q?9575eb+iICMiz8ZwpWyDFOFddztBiPvdtiDaz7Mck3Q4zWe2qivAJkhn7Wv6?=
 =?us-ascii?Q?3cQz1sVWwBWXyx+VhGq9JubloTbtO3Zve6pPmCvoyJ8Cgj+Ath7O9bkhKsuw?=
 =?us-ascii?Q?Mjwd2WgSvx4D6TiXvZUEiKAQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32df214a-5582-4c7f-79c6-08d92a182b3c
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 00:55:54.4642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fpdv0zCe7y8PAawg/rApjscDsiJang5VvWw+Cj+EKWjJq0sLvh7POk9s/phvktZV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Once a driver has been matched and probe() returns with -EPROBE_DEFER the
device is added to a deferred list and will be retried later.

At this point __device_attach_driver() should stop trying other drivers as
we have "matched" this driver and already scheduled another probe to
happen later.

Return the -EPROBE_DEFER from really_probe() instead of squashing it to
zero. This is similar to the code at the top of the function which
directly returns -EPROBE_DEFER.

It is not really a bug as, AFAIK, we don't actually have cases where
multiple drivers can bind.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/base/dd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index ecd7cf848daff7..9d79a139290271 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -656,7 +656,7 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 		/* Driver requested deferred probing */
 		dev_dbg(dev, "Driver %s requests probe deferral\n", drv->name);
 		driver_deferred_probe_add_trigger(dev, local_trigger_count);
-		break;
+		goto done;
 	case -ENODEV:
 	case -ENXIO:
 		pr_debug("%s: probe of %s rejects match %d\n",
-- 
2.31.1

