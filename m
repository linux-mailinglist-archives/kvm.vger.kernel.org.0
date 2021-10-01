Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF03841F828
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 01:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhJAXYN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 19:24:13 -0400
Received: from mail-dm3nam07on2074.outbound.protection.outlook.com ([40.107.95.74]:3872
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231211AbhJAXYL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 19:24:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IA8FGOOiSKvHzUKED82+Q+g4IX6dInXlghd1hwqE8Nx2SYzA/vVu2d51Hq8j5oDJ71/zQT2zwYh0HgnGkMxJDwjDmoKbTS8fSbXhDgEBBdqeLz9c+gw6h/VCf8IDp3tY5uxW+9nssa5e7C2iKfHWyFmB1lolrYa1aw707GHpPXDijhTvRd01IMLn27ZRqg7BfZR/8DTbG27Uv8Yn29uear3ezvXuO9XbymjxV2hTfR1anSbALij1lHVI8lnSO/N7kKCUw+eDg+QLwxMT0RrkQUnMobdDbMEhtSLlfNq+6Zn7z0XYr8Hk1TVkKLLCEeHOoxgJ8LrkHqHewclZJM/k8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rXN0/XniiLOuL5RsdWxMqgjwdlXXHSs4czcmIJiCGEg=;
 b=bTE0uh5YOF4YL9KJEurSx8DqjL59nlCRZ6suUWHc3K4InVMOadGpp0ZeRSMognG8WL/ARAYj+fMXvNtCc/eBZNu3SJbYEdHlcTMuH4J/EJkYRqVwmGiIgTg6KnE5YRUnbD5pTiABd7ieW6MiU8+SGr8ANUd2P9Nt1bLtKoyzbEB/KH9pkGfe3VGfbtagLeXXptX2q/G0C62gluwKt+CQE3Lqc8ECxbfaIHIwf9KwMNaZfVxmOEDlG6HeVwU+iUx35tdfb1lMzzvAEdZ1ZVN5cZ3t1ORHw1K9Mpf4CgG8p44xMHSUwpOxGn9owlPb5GDzeDWOJll18JsrK5HXaxOTsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rXN0/XniiLOuL5RsdWxMqgjwdlXXHSs4czcmIJiCGEg=;
 b=WTi6nldvMUSt3jW96wiPQ1DrcnTjbzs/Qm+GSPHrZlPZI3IT8SYcnzsffyvcs1K2lGQDwnusco7Be0fJkm+dANRMuGngEMt03xwuq9sr3jhrgJucLrJLt2vITbZYsG38DL0EjEac6txOj2CCszQzwhySf3eO0c3WLC9DrKM0LE1WcSwlQGn0HX1oy00vx7so63IKBAQQI8UZlZ3lkJKJPqy+SNWO/eDGgSWW2KrpVzxUN7p5nAEoj9ht6hYJU8ko4gwzykDEq5ANjItqADLgvefAWSwWClIsBOG7x+JzRGDPt2LlOM7/4ENFgUyNaJFLWsP1oUGtKKVpb7p+rJ+PdQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5362.namprd12.prod.outlook.com (2603:10b6:208:31d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17; Fri, 1 Oct
 2021 23:22:25 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.019; Fri, 1 Oct 2021
 23:22:25 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: [PATCH 0/5] Update vfio_group to use the modern cdev lifecycle
Date:   Fri,  1 Oct 2021 20:22:19 -0300
Message-Id: <0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0439.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::24) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0439.namprd13.prod.outlook.com (2603:10b6:208:2c3::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.9 via Frontend Transport; Fri, 1 Oct 2021 23:22:24 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mWRrE-009Z5N-6R; Fri, 01 Oct 2021 20:22:24 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f151909d-0b97-45a5-3b30-08d9853253c6
X-MS-TrafficTypeDiagnostic: BL1PR12MB5362:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5362446B8B0AFE01BB6A9941C2AB9@BL1PR12MB5362.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: klrIZOElZrzL8NyWgfeJTjwXBrTQkpfW5aIKdRlbxiu5uo1m+t5IeDBYy0W700OUTuals0VAhP823x1LV8mHvcwUhixy1bDxCKAN3AF9osaPfiw3RbD659+YkqFli3X0Q25N1uzvLj5XTOm8BeVsSYdptcUnIUJsKjOr+sNne/4Rgzhw2jZ5tsfBG93IQinVCbls1V7DlEq38ROM8DkRurBWMkoscGPja0/pZDhRTNy6CDNwXJtFD5EppAuJkfR1Oq3mHVdZ1w+p0nH9a18BtHOVJ9JQaK/5DlYMU3XuarIte7cq0wMc8SYZw0a3DOPOixUQb79XQcb3eA+OnCkB/n5b174cVch1T1PHSfIAzxmThvEM1+Pb3sFlgGB8vODYjLdUlzqprEUqB2SByAo8brVqyu3EQIHEubULAvVVhlyV/++ghKfy2gC8009jfRi16HAsq5H9qCEZuFtWVj+JY3kZFciA+NmjsEY9E8l7O4O0rdHCcExalcxNB6xnsZBAHlTG3k+N7kvXiyuH+PiFwamTlnQfGo8ZrtnShsESjSgkJo2ss2IfXhjBees+tiqFunDEh6MMjE7dk/5KnXHnwE14nlRO7qcr3trHAvbQBz0t5GW8HxWc1+bD970R3WoGgkul8B3mOnsWrT5d9ZHIKyw01OpKxf+U+JMdcHz5RyGbjOJENlHTzmEfPPgo1eF0CB5hPCyPVwhPFTBYDdATC7rXmESeGIj32cCHb6Hj2lSYUbzVS0bcwc4OYiCTu1sJuCMropsj0EGwuQb8nLTc0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(966005)(9786002)(2616005)(5660300002)(426003)(38100700002)(4326008)(186003)(6666004)(54906003)(4744005)(26005)(9746002)(86362001)(66556008)(508600001)(66476007)(83380400001)(8676002)(36756003)(2906002)(8936002)(316002)(66946007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MSD7ZjDTyjGAiAroq93wIDrhLex5MhYmat6MFxnus8VFETDJcPLVKEExJn5V?=
 =?us-ascii?Q?UKGT5JZ5+UROiR20QFnMaVH/YAZxajd+YSldRIfPfMgdCaXu+ZA/I+w9fXnQ?=
 =?us-ascii?Q?KWJMe06J1ogiH4nwKJzsv7CtbCMy4hI9gW9QbaLRNogPolZfQ5xQBe1ORMxc?=
 =?us-ascii?Q?/7OMAxRVAjNH2qon0sAlTNZgLMSwyVunfsuFJLcGDdHzyQTVXlG8QS4GDAd1?=
 =?us-ascii?Q?GC0Lu4iQMGVy5nrXN60ky2S5KObZYD0EqrM8o1hlldpYNERLzjTikTIj9AN5?=
 =?us-ascii?Q?MZEPu1RuGg/Uq/RtbORP7qXO9kiGcnoORiSALcqHiZ2e5mFRniiwgWf+s0Rg?=
 =?us-ascii?Q?PUPCedRgajZoMcCJUNrv10bnsMjVPs4Px5E+6WMiggEDnraoYgX2cCFOEloV?=
 =?us-ascii?Q?0mDOr01RwLLKpyiCL5QosvZjT9MveT33W5FnDtmOs9Rs5xg+iM/sMouuB84e?=
 =?us-ascii?Q?QHfBHx5XBU4Y43/cWV6K+PzVmj60Ceff7Bb9vQDabsfZtFwZKYecc9GPsk2C?=
 =?us-ascii?Q?Hj/c/F75bIWCOOzvP0FPp3w9MEuyYRp9xPO8YfdD8axFfwu6fdl88T4Tf2Jv?=
 =?us-ascii?Q?UDIssEQKGm74Od3zcxP+1KMZwhpFxsC1Zb8oH09Z3aU94bshN7XbiAQ3WHqQ?=
 =?us-ascii?Q?13djuDl9/bb3x0gW5Two0Ur95CqmwiyCWQwvh1zlF3uMba1/+qnZ+iqu4U6C?=
 =?us-ascii?Q?guHgWgjx5ntb+u8qCl4nE7t2IgGki4aaGq32c0wY8zTFp6Q5Ko9qy7xTzh7M?=
 =?us-ascii?Q?9UJi3udsulVXR5i3LcZN9VkottMBb2+LFxDSPhLLtk0CU7D3xkdT55Z7ErNO?=
 =?us-ascii?Q?wsz1hPruu6Jo5xwHyMNCFn/kojNdy3k/+mpVyNR7tpTZQDMLmdvmeodjoRFR?=
 =?us-ascii?Q?ywZV0G/l6EIr4BvMZz6sQ7NDL/lkKHFhPj+1H5fvJeUPGRpORbxWgsMU8Ugo?=
 =?us-ascii?Q?Pf6wTT0z6rUgbJLXhFf6N3yLMI5k91/zDRFU57d/7bhNA3UdAte7Iw+Js0tX?=
 =?us-ascii?Q?wdrKucfNPqt3Mi52lvDCKVF12caC3nPQ+lfj0jIQAuohhO4cj82wQCTsj3ux?=
 =?us-ascii?Q?vHpWljW4P4FqoaKEEpeDB7fNsTRTwSf5DxwOLc3wdUwYfaq+2sGrSmIFdQtl?=
 =?us-ascii?Q?xozUaWmw8yzO5Be6GK3wT88YK5AVa60CsG+Ko9gzWO+pbIGzLHIsg1dDbKA0?=
 =?us-ascii?Q?jpvaG+6+h7eRCib1+5xj2Nti/radjnginzkcD1tgtBm/bJSfgAv+hnkHfI7y?=
 =?us-ascii?Q?2/O5OpNiowzVw6/cC8QLx3faD+bOrEkmyuqAshR7oYv9WB80n+lao8f0IshV?=
 =?us-ascii?Q?M5NHTpcjDt3oeUHV0wNmAEpE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f151909d-0b97-45a5-3b30-08d9853253c6
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 23:22:25.1777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JRrdYlRWr2A4GT4KnoNP6+z0TuKIN09d+Cd6J3hK6thOoFjwMnyYln9InPrsuB4H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5362
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These days drivers with state should use cdev_device_add() and
cdev_device_del() to manage the cdev and sysfs lifetime. This simple
pattern ties all the state (vfio, dev, and cdev) together in one memory
structure and uses container_of() to navigate between the layers.

This is a followup to the discussion here:

https://lore.kernel.org/kvm/20210921155705.GN327412@nvidia.com/

This builds on Christoph's work to revise how the vfio_group works and is
against the latest VFIO tree.

Jason Gunthorpe (5):
  vfio: Delete vfio_get/put_group from vfio_iommu_group_notifier()
  vfio: Do not open code the group list search in vfio_create_group()
  vfio: Don't leak a group reference if the group already exists
  vfio: Use a refcount_t instead of a kref in the vfio_group
  vfio: Use cdev_device_add() instead of device_create()

 drivers/vfio/vfio.c | 363 +++++++++++++++++---------------------------
 1 file changed, 140 insertions(+), 223 deletions(-)


base-commit: d9a0cd510c3383b61db6f70a84e0c3487f836a63
-- 
2.33.0

