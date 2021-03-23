Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A353464B3
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbhCWQPg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:15:36 -0400
Received: from mail-mw2nam10on2048.outbound.protection.outlook.com ([40.107.94.48]:9569
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233150AbhCWQPS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 12:15:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SG9/x9hYoOJ0/xNupuWdfabBoefOG0pEMzNBrCsJaU22KflYkhbz80QDKdKdD1J+ozTtK/X5q4ghrSDPGkyikmkIbSKcJ+39EhDKvdPOK69pklq3vdRm2toTpm9laHF/mwD3v2vpmczhFLJGaYdz2yHrP6gMZmjqrCZoGAv81BUImfGLHMpdUXLze9zN0UUbj9mdK6cq+m3KBj9mX66G8ixvt0L4GQOiqds4fVWCjf869b9s8u7fEqhoadLpOjJr3PnTdd5q2U3TfaSeC6wUu2M/id7Nr681dvEQt++1Jawym+63CJVwsvjbSjRF0TdqtpPbBIBlCwvtRIRimbN8jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g9rRaFUnfrzInfeeGjSlCXiYHZN1FE0H55cc18pQRL0=;
 b=bvA2BKPs46RrPt37oLTG/3hDnekrxKRvmLJdOtTmxJXCUm4BLQIQ0VQM3K9K4XFcPdsZvcZsrTu4dsCcqy/fcUYcvkxEQTYOhPeP7CBO0vFZZVmoQ5UAYJiE+bR1DdSwbCUBMKoVJIvD5HWvnQmJPeAsFRXoP8prA6URPCRa62C58uU6hUhLYUgu7LVCyBrfYLHgvQ4+ePdEd2vA8DrCQXLaDU5HKHKfVAiDVLVJcqvJYIlsLeiG+rvyGEJGEZV1b82Va4ihlHk5Y60N3ZGMLsyHnQb1GNYdviFzzf4ME8wy87LiRWSg34s/8hQ8YI/nfx3uVGzQ70XtQEAiUzbi0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g9rRaFUnfrzInfeeGjSlCXiYHZN1FE0H55cc18pQRL0=;
 b=AECHw4kUDLRxsR/EWTHN/sbAc2ejYPg+GZhujHAjfL/9HZWUshjLx/17HRcF5e0GTgLzg3zH2Se0ZgViLjmac61mbq92wUE97YLgmDpigwThx1dVhfbPdq1r2hWXaJztIAqORT4pdDsLubLmXu80prlS9iE9eNjvItTGCekK5136NAaUdeNcb339O/l+6K1W0JeK9AhVjFKpA9NZfI1R7Y6ftNboHKfdjDshjo91t4/ZpxJD1/SGs/mCHU8Wzjw9pw1KcHwW9KdwahjDgJdejVGP5cjBxYBdR5SrgDAlbmYQTGkR/UpEZCBMPHG3KRaJu9gFGrGAo/GUlXjJF15jgw==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2440.namprd12.prod.outlook.com (2603:10b6:4:b6::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 23 Mar
 2021 16:15:09 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 16:15:09 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Jike Song <jike.song@intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: [PATCH v3 11/14] vfio/mdev: Make to_mdev_device() into a static inline
Date:   Tue, 23 Mar 2021 13:15:03 -0300
Message-Id: <11-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: BL1PR13CA0188.namprd13.prod.outlook.com
 (2603:10b6:208:2be::13) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by BL1PR13CA0188.namprd13.prod.outlook.com (2603:10b6:208:2be::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Tue, 23 Mar 2021 16:15:08 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOjgQ-001aD4-Q6; Tue, 23 Mar 2021 13:15:06 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8dc0427-e4d3-4465-7c7a-08d8ee16d3e7
X-MS-TrafficTypeDiagnostic: DM5PR12MB2440:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB24406DB62018780481DC97C8C2649@DM5PR12MB2440.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: amvSfpd+PPCy8fu9bBWLyM/offMPY59bk3EUFHOcdouBoFHhhLN4b5PgPSHKS91NOMHWUi/CHXIjpCXc4fjKyw7gDp1syUtXNG557F6K4wQM04u9KLAyn9cQtJaV5gbWS+bfqv48zyIGk1k0XTX9JdEAiSFomyg7gzjy/2ascZiSrgBcvDW04/ohiI25YPqYesAGpXhNMGf2vaMUPRqCV/vPCvifKQ2dzh6CxyUZxrXQjkpAWvz066J7oer8I7csez+tDlezpzfQX3cc95D28yIEV5dA1fNNzFl7THP1x6l+TPm5hVzG6g0po50ZYrpFUhOIkSbMWEg2+wK9jeHggwfuodOf6BgM8amWqqUSEAYP6n2GnxD5VXrrVCnXRF0EC6OhWIbuD02glgCStBAWf7Voe1L+EdypLxHqaopNL6xro2Pl3qHCzfWSKuNq1IbobGhSa3qtxbVp9R+vWGO3bZuSeyL5ec6biimTFfoT2F4t1WG1jVdndGZgU+VEYCZlhiUs3b10HxO4Y99sjjZJkPmy8QRqlVrw3HrnD5b5EGFprSW/ysgJk7HYnS0kLvzk/jyVTUf7p5L0aZb/v5VQa3Dv4XxQl0Xyv4YHb6zyYcW848QMC1pZmZK6lS68iJ9ZmtOEAIL6j9kEQ+9YJJXZLvPv+tsqx9G9oXapjA2f3uk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(66476007)(66556008)(186003)(37006003)(36756003)(6636002)(6666004)(86362001)(38100700001)(66946007)(4326008)(7416002)(8936002)(54906003)(9746002)(26005)(478600001)(426003)(8676002)(9786002)(83380400001)(2906002)(316002)(6862004)(5660300002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DBhsbxzpLc41nvUu0zQcVQbGdWDZR4jHEg3+OXxdLqA+n6qHYFAHlf1hNmfb?=
 =?us-ascii?Q?JrFm0J5dZtiY30Uzk/4J50Ljw5QJYeUFLvD7SbkrFVEDOa+qzKWbH08yDfXX?=
 =?us-ascii?Q?8P1PbbLlme8mhHb2jhJjaSwV71yS41vNlazOafjQCGJIXyhCLF6ux2QZTaSH?=
 =?us-ascii?Q?W/xMqBcEJVAb9/GafChFyrdn5+AoJK2FcIpW+8kDSVb7Z8Gb+2+EjC/qV8zx?=
 =?us-ascii?Q?cBgfUgAtwxYOLonobMAjIU+/0D3ZOtP+1tuNEtKFqxauEev9Y/D+gsrpXwxB?=
 =?us-ascii?Q?i1hAsQOvMy5yMAMyUtLOcRiUW/uC0/qvXOLD995FAs9TOwQ6H/4s2/OUWIQP?=
 =?us-ascii?Q?IYcNlVqLLPEgvdl/krTakBAb31gtXP8LNgSin2VJe3cbRW6KRmy8ue2csPQS?=
 =?us-ascii?Q?g5avR8TA2BCA3fyduuz2SvwwNNsbcVgz+ERG92+6GIFdrQkpplXjh+f5p45c?=
 =?us-ascii?Q?PxfjOPitE50iLWLNuEX5BHnKPoml0ycwhQ4rd4NdnZCtAnabhKrbyMtqAhz4?=
 =?us-ascii?Q?AXeOBWCLt5HX7nGOfamx+U0kh86KNox9DNaHO1wTsly033pOBlJ3YTadPCYT?=
 =?us-ascii?Q?rT7eAJkFdk+DtJ0p1diLT6aK+oMi/fqA7Gd94dhi5r7xkOAH3pmo3T75hy4M?=
 =?us-ascii?Q?3OmsvvWxrIrHzSsrRCi5GZczikgmna+uFvMdSH3U/qiaG7/JzNEUHe/i5FTX?=
 =?us-ascii?Q?Eu+YisdmNR6t0vugzJwlYpttE118o0EoFW+Yy5e1jx3pZTD5D9IBTbIT+6lA?=
 =?us-ascii?Q?o97OXvHFz0f1mx3SpkqdKVnIBfZHpTkFIgOcDGu1/CP+Zsq02p57lhd7fKTW?=
 =?us-ascii?Q?0LMXRq3W64Q8cEyjw8ulgft3jwPINn8RYq58PM4QeIskwBWFCC2qu5reiC8X?=
 =?us-ascii?Q?rTv0LXg5oQlYoN8nnflBzFcOMxmQHWqODyZT5jh9AKptQbb3dDzZ9Csrgor5?=
 =?us-ascii?Q?rCGYaYq0ssTV33OgESYq9SnTh4amsVbg34R8zm1sw5WPjzini3zvF093wiH4?=
 =?us-ascii?Q?0FmVuGcVif0CB3LFkT/PO8gvquIBeAUuSKc1+AiO/gqWQ6ASUCZLwqdjrjY7?=
 =?us-ascii?Q?+yYMSPoIHnB94lYwKy5RWSvBcFzYTpG1LD+ZYaN8hUHHk8aVzPRGRgEMBclE?=
 =?us-ascii?Q?B0QU6gnsBAn61nLXwVWjHxcJ8Nf1x+0PmHZI9KUGb7lqtULzPBHV5EMhTkR7?=
 =?us-ascii?Q?kabilFfFeXVogylsyckVjd5dbAcJ7AruK14B3ggTCpKd24MlzHKRHJ63PS5R?=
 =?us-ascii?Q?Itmr/IirlMMieGnZyErPGALvp23gk5lFRQ0AVVOQfSfTqTo9+IwUBkp6lC/o?=
 =?us-ascii?Q?/dGKoXRO3wYE4aWSHHy6faFf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8dc0427-e4d3-4465-7c7a-08d8ee16d3e7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 16:15:08.7218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lFA1VsnPBhIWtE3mGEhxBYyyo3SCW0Ml+H/5n1s4Xx/vkMYAmCLMjeunFedQWVdt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2440
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The macro wrongly uses 'dev' as both the macro argument and the member
name, which means it fails compilation if any caller uses a word other
than 'dev' as the single argument. Fix this defect by making it into
proper static inline, which is more clear and typesafe anyhow.

Fixes: 99e3123e3d72 ("vfio-mdev: Make mdev_device private and abstract interfaces")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/mdev_private.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index 7d922950caaf3c..74c2e541146999 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -35,7 +35,10 @@ struct mdev_device {
 	bool active;
 };
 
-#define to_mdev_device(dev)	container_of(dev, struct mdev_device, dev)
+static inline struct mdev_device *to_mdev_device(struct device *dev)
+{
+	return container_of(dev, struct mdev_device, dev);
+}
 #define dev_is_mdev(d)		((d)->bus == &mdev_bus_type)
 
 struct mdev_type {
-- 
2.31.0

