Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2897A43B8BE
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 19:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237996AbhJZSAF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 14:00:05 -0400
Received: from mail-bn8nam11on2062.outbound.protection.outlook.com ([40.107.236.62]:57056
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236745AbhJZSAC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 14:00:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KM/dBmweed9r6oqE8LC6K7DWegMpGvhV14JtA1markeaKZmskbvPHBtid5K3AuUvBa0gP9xSO25e5aVLFRpige0geewpxanC7/0XyNSeoc9SudBjElIG+iqll5g96fw3MGIsW98mOCBh6FiD5R2hcBgagl7vzVRTsCDnmgyECeFMtmQYMZNk9RyA5f219L3zrWm0ZCfWL8uKvdiFOqZG89gZkegHBthInv28h4AH57KgkFqUo6ciaq7fVDg281Bf5HMoOCXvK4OFhXfQPsdw5JjM72aLWIKI+yR4eN2L4jfPDlmzEfKzAxoLQf0fcmeiY/4nsiVepDXY/lNTgS0Fng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QC3K0ZTNLQY2XuYTQ4Y6FNyW26O+62P1rFjKjED6bQs=;
 b=jlxfY1N8sbjmikjHXXFnBqcaBStl48jILjalhDrY+vF+64BtB3ooiGoJtSjmbZlDAB1dqfkhhO45v1lbIaaz1Dp8DFam8hyvPbZg7tgT0Q6B4oRg0Y44jEBko1Qs0D3jk+W1KkTI3EE6WV83jBp48Kio+L9+GTzI/KNfkGT6EDrex/0WEK7yq3OQfY1JTL4Y525G0uSjPjjV262UwBXTq0iUqYRtONNF6e8abwWbZVZziNXwrfWifWFctYTPlw45sVyJXS3TmvyjLT4Y4Nu9QEWlaA888CpctFeRLErwHuSuIUyM3Vj09mkzmWEqgAKeYnpx/nPjhGeIhxduHRLB7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QC3K0ZTNLQY2XuYTQ4Y6FNyW26O+62P1rFjKjED6bQs=;
 b=cRQzs2cAtIfu9K5e86MrYsk14CxskKkTAx4LJn7Rc3MRdwoBGdAT6optOAML8ifUsL4s+j7owRK7sUY14+L16mP3ow1oKl1cHyDyUQgkAzFHOCgObysu8cy3VW+Bg6HQ5bZ/b86vPnuqQL5UAnAIjkj0FUZwrHLdVDKuc7FvByDbPEnOKqLr71OIqYmUE/jDqaL4mToHBchbt64FRFVC0ml7KK80scpha+CUNmOMztmC8nrn9g9kRVGuYIdl5Lrj7sXAlY0YC5MNNU5pX+kuTLtgPR47OWI+EPA9bOK1gSHbVsunhPm1+JYIEuWLfcRUsKdpLh9kTYLwAzH2wSis4A==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5048.namprd12.prod.outlook.com (2603:10b6:208:30a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Tue, 26 Oct
 2021 17:57:35 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.014; Tue, 26 Oct 2021
 17:57:35 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4 1/4] vfio/ccw: Remove unneeded GFP_DMA
Date:   Tue, 26 Oct 2021 14:57:30 -0300
Message-Id: <1-v4-cea4f5bd2c00+b52-ccw_mdev_jgg@nvidia.com>
In-Reply-To: <0-v4-cea4f5bd2c00+b52-ccw_mdev_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0103.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::18) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YT3PR01CA0103.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:85::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13 via Frontend Transport; Tue, 26 Oct 2021 17:57:35 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mfQhZ-002BJs-Fe; Tue, 26 Oct 2021 14:57:33 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6e5bcc2-6dac-4077-4ef1-08d998aa1735
X-MS-TrafficTypeDiagnostic: BL1PR12MB5048:
X-Microsoft-Antispam-PRVS: <BL1PR12MB504813B6A4B1B3A11A653355C2849@BL1PR12MB5048.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w92Z+Vj+XmodbK8ft0CyKFtruTTkzHm2SGoB1ix+peeyJiWhK2TeLEe4D8lc0sq3AGsLyjYz2ZKGhITI8PIT88YNVXeZnebrv0xMmyhWyrFngHYxNrt5keaSN4cZxTTuubc2AhFRufSH/QmK+4PhxgFqPCWxMCcyjDydsaKphNBybFH6XOl3cwNUBOEz2KQ+JATm8S8DjIz6NaP9gXvcp8FS4vfytzTVBEIU+fE21dHZKhaUxdu0/ljyR6t/wNjve+Cvp/Ge3M2iPyJHeEyxF6jwWhQLdS7cWkp4jHCTaB3yfzvtAOoWR0jsXPtI3hmGrAg7rjwGoL0qo9kXIDaZ5Td6Ek9PpHTHgXA8Z3l1dyX0NMZTnce6SC7w70sLVKPguDpizyrkEExmqPgMvZ90WxBYi7+Iz0y6x3O6p/ml91Jm73TasGe9sHvZnH5asF62W04slEDrZ1LAjTRuKYSBmuL9hSk5WZtomTsSGTMmgns3Qql6qookFr9wzKJT6sGTpEM2sPuMItWNYMFkdcLHviS5qUV2yiA6OLYz8D4xsy+CJVdv3BT1CrEpuJp32k1ghf9Q1MtfVTpZ4YwxmkL+nBtFjAvw2rO1lFT9sLw/pAepUYXfYntLby94rQqqyRattjV69WITcdyZrkMHqV3o2rtFs8rScbYRrBEPbhRIrNTk8g6vyOYzVV2GQJrzmBZCJqjw1X+LkMYQTqfSoiw/QTEfiBUnZaJ79258xixAAiE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(54906003)(2906002)(36756003)(508600001)(2616005)(9746002)(316002)(921005)(426003)(4744005)(8676002)(66556008)(83380400001)(8936002)(86362001)(26005)(5660300002)(186003)(38100700002)(66946007)(4326008)(66476007)(9786002)(7416002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aS1nV1OYizwRwYa05I0yOiLTIbBRBeo0/LWUqd5ICmswe5oy+JEFfM6U9sra?=
 =?us-ascii?Q?cliAdlepHeyBzd5AJKmmErBTxwgbQGd0YRlZc34dvkUFb/mcj3ZJ/QlzuMWh?=
 =?us-ascii?Q?KOsfHrAAR7mEurwbVBAEoSgG7wZDMrrzKGNfxGYN7qS+S4Cc07hWTX8dGRmq?=
 =?us-ascii?Q?M1zkGq0L63tzNs4WmI2yyk0gQ5spY5s63IZHCzV+Ap1AbiaRRvRRqgRGBZEY?=
 =?us-ascii?Q?3R2CJJEfnk1Ci+Rv4uLB2B9rsRWa9KoBtyAu/mRyJ8KPtDNKa1fWR1m0BVb5?=
 =?us-ascii?Q?MOq/RpgEQBJS4AJH/FzPVhqi4so/bPtF+QpjT2HjABJp51+cYj71DAdLA2/P?=
 =?us-ascii?Q?xK62qCf2JFPGzf6QTxnznBl/03jWfvMyjzZNdY0Dl244dpP9UKqcKQFjBwhF?=
 =?us-ascii?Q?+JLu1/m82Ebb/v/cmDtQB8wTTfVvY1Yl6X+4aARIWGkCKI+1hHtn27LtCD7z?=
 =?us-ascii?Q?1q5bbzg3SaZ48XlBcoDwWe8mku0nBJ8zXjAabH+xNHkmUweX2v9ENi575km9?=
 =?us-ascii?Q?MCqbOLpGArNWMckJj6IgQYksIg1hXZeD4R5ByTEQflWLRNnRydU2fWGBkjV2?=
 =?us-ascii?Q?wP7D64QXLm1GRtQqgVPNE4sZ7bbmAVpKSaIwpyBWfLkKU7dPd7wK22bLQ97V?=
 =?us-ascii?Q?9SjmWTNA7VLAHegXSgbYAbMX7byDX1rRi23fcAzxtXKzN/6CayL76rsRtI8/?=
 =?us-ascii?Q?xv6nWsHu/1m9889t4BVOGKOkxfoZ6Jb3IxoTUqk7AZHVbpcohA30cVlHaaHY?=
 =?us-ascii?Q?XsTxBLfknhMNo4KOyTA+8BRMSZRmJcbkLUCoTY+g8G4ZB/+DpgxEPIzPs4ru?=
 =?us-ascii?Q?CPwAMmyXMFoO9UzfPJPzqpcSjX1goZXrOtk4BlvRiD2PFLdVxQHncGOyWg0w?=
 =?us-ascii?Q?CqfiVXubYxnlHRyWqzoS8C4vTF0MlNQnd/1oL/LUvJwFYIxlC6ln8vK1/EQj?=
 =?us-ascii?Q?yVM7ZTWjR4/FWdd0ZaNhEJpmGCcWOiLwcoDPW4zKE08QlJBNJ1HnOeQ9lZqP?=
 =?us-ascii?Q?94FYXZguoDDRnIhlgVfI+mBSq/ceESC4hRjwOj1rBBUu6sioUX440lpleIhD?=
 =?us-ascii?Q?MDlyjjOfW3OwQFzfJrs4iT5PHhaOg/zNq2s1v/nbpKz9ExLw9QiKHXwM4sKn?=
 =?us-ascii?Q?JkzqOvrNwcP+CEiMu8OIzztNm2g6Px2j1u9bzEl+Y5fR7FHRvbHdArOhnAqM?=
 =?us-ascii?Q?kjCysGZijgpPP6rmO0dpecAztm2nTCsG1LEqLZFXqQumcTP5QpSGfUuGSLNw?=
 =?us-ascii?Q?ubiLBbL0675TVDLKnY0rYCfoSdnrYzvgH+FIxvk+ds4xOpJPO53A+CC5FrXR?=
 =?us-ascii?Q?IwS4PHH8q6gbvKW+x0p13C8+3BZ2soreMqPf1A65L5D8Va7B3ln+dKWN0NO1?=
 =?us-ascii?Q?xZF/Ym3L88vOzLynmc3DaPZUnXs7m9x45PT3L96c38K+5hoL5ag/zXNUuHtE?=
 =?us-ascii?Q?c+ZWsOQpdWTlV7Ez9YNUmN0mmEpk2Sqx+AfdItx+SKNmYgEigHwGZFFk81mR?=
 =?us-ascii?Q?lzmtdatBoRXdfCyTeRw8FtMyutRAbWjkFAKXz5JWdUjLvUqYCTQwxiaLB/eS?=
 =?us-ascii?Q?L03+d+ijAVPROqKbUhg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6e5bcc2-6dac-4077-4ef1-08d998aa1735
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 17:57:35.2819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PN5MzekhUioanBAonF8E9VjDr20WZhIx9u1xZTPoHwWpamEuSup5m3h0P4ctQ86H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5048
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the ccw_io_region was split out of the private the allocation no
longer needs the GFP_DMA. Remove it.

Reported-by: Christoph Hellwig <hch@infradead.org>
Fixes: c98e16b2fa12 ("s390/cio: Convert ccw_io_region to pointer")
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/s390/cio/vfio_ccw_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 76099bcb765b45..371558ec92045d 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -161,7 +161,7 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 		return -ENODEV;
 	}
 
-	private = kzalloc(sizeof(*private), GFP_KERNEL | GFP_DMA);
+	private = kzalloc(sizeof(*private), GFP_KERNEL);
 	if (!private)
 		return -ENOMEM;
 
-- 
2.33.0

