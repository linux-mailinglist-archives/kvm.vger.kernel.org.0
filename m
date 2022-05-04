Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3EB51ADCE
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 21:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377512AbiEDTd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 15:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235621AbiEDTdw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 15:33:52 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2059.outbound.protection.outlook.com [40.107.243.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F253B8
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 12:30:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GnZjKbgqwS/JduKQRolqwSctICvhN1iw3nvsHKys6TIx2fpGtfZOTQmxjck8vTUh0doKtv0zc5YjtlbN/00gqOPtJoXyuLZX2ACNRHdq+eY+ImZZQ14mcQk7nl1UHLieRZFy31yffQPFKJFnAF9m15zTXdM59FgTE7n/yi44/VonuSsA1CsW1EK7U5ZlUGC0xmnx/H8xxyimMtv/lHWH5+eu9dsmhY7OhX7q6iIRwmSyaJxVJs+MVGDN4Xspimb2RPmX3VjcdjlWnhox24zlBAIKvgdeHfmyAsmaOnD/rzRZjSRE/66CiPAcffvOp/0gqpRJSrGKu89z6VS/5FrZww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iDdCSIxUeDNN683BBTGwfEfGNOi/bxpgdMZ15pyTk88=;
 b=WdY3+22BfTnGOK5/tsqwYfKVNNOStyvdizEWVws2NefrGvJSCBrmqJRxq5CH54ol9iKISdp3b1JPQAAQbcWX5s/x3Z4fhR/VZ15LYmrJv2U0l9Y0yYCaKf8i31lCnP2rBJDYULc1lDpX6lN9tGt2a2065waBKQQcKCR92KaEnhU2PuM92W478jDPWUBHMSagiZu+wIduZZsyeumx88yQxo2T1YQoUlo9bvRgAJ9+7ArSkX5gFRU9e/+XIoPnHhNNaeVOuGZ9Os8la6+cW5YEtQ9K3kSGygJvie0XqZ3Ap/g4QVg3KODwsOy1BPp9OMPDABOyaiXovV4Eb/D/G1qZ2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iDdCSIxUeDNN683BBTGwfEfGNOi/bxpgdMZ15pyTk88=;
 b=dwL3qOWsbpy61zzVg9qgnSevHqAp/Ak5W2asvmAXAtqTSckrqF9vOZoTr3vYp44QL77Ka4q69Uw98maGndseq/uy+qJ+2iaEkufNMEjUJ8mY4lya8QjtWg3ZhOp7RjSJsCJvFwRweoqmr/FW5hFTAoTtMKmXe4RvcZiom2gh0OuwsHkLA9ze3PM8RN+FTVUMqOp7m7wuU5igdy6OOmwEH/ecToV7MD3+QJMwjGuqwSEBt5ltrnnUNQcYB3HqjzvX/BDUEQqEMbx8ZqQQWB5yKjsEaoBH3o+WNSOA4ibXg7Xs9yKtgQrJXNQLAgcm+cG15ByueyTU5alpbqh1wOnqGA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4563.namprd12.prod.outlook.com (2603:10b6:5:28e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 19:30:12 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 19:30:12 +0000
Date:   Wed, 4 May 2022 16:30:11 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Cc:     Abhishek Sahu <abhsahu@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH v3 0/2] Remove vfio_device_get_from_dev()
Message-ID: <20220504193011.GA134430@nvidia.com>
References: <0-v3-4adf6c1b8e7c+170-vfio_get_from_dev_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v3-4adf6c1b8e7c+170-vfio_get_from_dev_jgg@nvidia.com>
X-ClientProxiedBy: MN2PR10CA0006.namprd10.prod.outlook.com
 (2603:10b6:208:120::19) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9910599-7b7c-4563-1985-08da2e0481e6
X-MS-TrafficTypeDiagnostic: DM6PR12MB4563:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4563171E784229DFF70C6505C2C39@DM6PR12MB4563.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S7cKpVEhWJGpJNX4KIqyqk4Uauy9VfCztixP7HlAVMbyOSMPs/72H0TUC6c8Nuq0QRIwZ6pF57Jc9eAmgA8kzSFiFo1qEw9+NkPRX3rte0KKo5GULTb2QAxJ1MhGA+aUvIwDIL2Gsr2ee2gvSwF3k51+O/Kwdc7zb+SHT7O1g3ZEReJ/OOzQGmE73Ve804q8En6LICaKHv11ERgg81R88i4baQ9e/CoTF6uY6ZaNoTYyPcWvJMXIaepDi7m72a0W1NToyiIw+qSOFdz06klepyPFeP7dwiiMDnTXVFMxx8bUYo5vJ0R7lR1MIlqZq4E+vqe/sCfVQNxFQ2MmdKItbFGr+fTA3CtrBGdkMK4SCaeAxBrX6etGRSxO5BHkOwC8vbxHCzUgJkvv+/n6rOSUNX4oPP6QfQ1ar59Yv5q86rvQ8Cc60G02fzPeNm8VaySjRFQpFgf6RviU+YZKo0IhP8eO2uCqgf0GSp3QEn3aAc4ZAidm3Ip3+f8u4SODi3OdiNTvnGmLjhDy5Oo3Mxdyw3DwPtW0TtiAqapQLOEV7z5qUceJo12s1egVWsV2k/PnS5NfWjkuPrrZPa6v2y7ooH4QZ2G0GWhvGew95LSz3j4yVOMzPTB8E4UjJi39ZtPlOHYBPrCF6jWsa4Tnrh4n25/9hzqVf6f9m3R/ZMGt5VlylsO3SFTR/omlMDIi7Mr6xkJdk/D7KX8C3A3n64WlyjM7WrKVALZNj7G+An6NT9EaFHhuEhi77GLSxcSYQBVsCqQheu4UIANM07+ZPvNW0ZiyfeMZk/81GwKRxlh55eA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(1076003)(107886003)(38100700002)(83380400001)(8676002)(66476007)(66556008)(66946007)(4326008)(36756003)(2906002)(186003)(8936002)(316002)(33656002)(5660300002)(6486002)(508600001)(6512007)(26005)(966005)(6506007)(6636002)(54906003)(110136005)(86362001)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xpegJNmUigzif13ZS4YJW2wTjgSCyWdVakXLrMMy+4EZiSoWv6RoPabOK2mg?=
 =?us-ascii?Q?qw4Hwu+SjgH744mg9WdUl0cKQE5VfUL/Pno0iyeZ8QP7VZvBb9vVdeBsTSKQ?=
 =?us-ascii?Q?mGX+hBwktBzduFjH1kRo5cQdzg2dLmQ3oKveIvU8x4WeTTNrDAz21u5a7qWR?=
 =?us-ascii?Q?ZM4uesDa+ikSNXlRj+ejCaeezk3QqkNl/Ez45w0W7yX700VJk3kitHJOiits?=
 =?us-ascii?Q?vTjCoJjhOHmWQynLe1xVj3accLbV4aGZ9Q2XeZECjkK5RLOKhP2DWx4p1f9H?=
 =?us-ascii?Q?MKhTzBWwUz2v2g0UfSc9Vxh3ulFIbgCY+7DCih5wXJfnMn+7zVBCP1nWPLWP?=
 =?us-ascii?Q?Xplmzfl2Ea4MdW3/5IaBO/TJleBzNgQm9urkb5eFMgHg7Y/zGarJM4iaqfVp?=
 =?us-ascii?Q?+GXeNqg/3WCk2LBH3vEY/ZfHsHv6z9wwJg2uXJExri3D7K3e1e8IKNVobnk/?=
 =?us-ascii?Q?uVac31+y/1PLPhLSh+tsuOrpl7kETL5REZ4zhdvlijTv62qylQ4jh0ZqzJ1S?=
 =?us-ascii?Q?dKJyogRDmPv3SsEJFghPUZojjBSkpJfKkKs2nUCD2ZfrBTGzBUyr8FL2Ssvh?=
 =?us-ascii?Q?se5xnImszTJ9sqBNS5rghXbdFW5MYO7kOZjEV5lpp/LEwyu9WLZEKyydbcHf?=
 =?us-ascii?Q?Gb4CoRu4ZDaoKLEh0kJhuDVaLqD9annmhd3bSx693whWbGos0bsegVf2jE81?=
 =?us-ascii?Q?WLm2R2NV0gS8iXuMo/35DQl4/12yIULWGMs+cWNjgEv8+/g0iglpFymIO78o?=
 =?us-ascii?Q?cfRXjc54CX8BToJ6EovimtWpmFUHgPXsNshHTzr6iOa4A4ItkrD/aI3JyxXt?=
 =?us-ascii?Q?VUieRGKeeKqFGa6UD2TX4xc1k9FE9XnIkcVNcqPGFZfwrPREROh9mWIOQKn1?=
 =?us-ascii?Q?Qrp2MYJ/H77oc5Ka340gEda+g850ad5WrlPvlQOzvnkE4gMLwNnF1JW4oVDy?=
 =?us-ascii?Q?fwNt8egs/ExXHlKLH9rkiDAazcUNYHHMr8c9s37NobG1vlkexbclqtghrOWN?=
 =?us-ascii?Q?RtXaD9PgozaWEkQiqGCYf7RM7CY+InRGPXCBGQuHsTFP2OKW5FuXgjfMS8B9?=
 =?us-ascii?Q?yLVbovS3xl9dzmzD81qgxpfDW9QQRPAksC/n8bgPW9Qcq9fZcx4gqJaRK11T?=
 =?us-ascii?Q?cpRF4JYMGFs8kwGYFpNTxbp1iHjDK1BzY4siZMiOuBRQkLR1jeyru/Sn+HCp?=
 =?us-ascii?Q?gjvSbDdeq+8EHimwE2SDG/AmtPYu62xWF4eLOoezuIdsWTegALu2cf52gFoX?=
 =?us-ascii?Q?uV9YVPcDLc+piL4VxYzdqZn25l6uMICqaMIkbWIT6eDpVODRNQkgdl+gvBWx?=
 =?us-ascii?Q?eRfTbnmgCIyNCF0rryx75aKVcdCgNQGzWehYkUzzsRPB3dCV+qKbd0UsKQPS?=
 =?us-ascii?Q?vaOIyvdH7FjXbSbaXaU3MDmffnUJAJcpAUgTQ54imK/i2TWl8ibfZ8Qv/fvy?=
 =?us-ascii?Q?del8SukSluMW1lWFQjRqeiG63hOdyzjyTt3BsBZxKjWGqWE9HUxwmiKcgiN0?=
 =?us-ascii?Q?15xRvkf06EExn5HoJlU6a6Azw5SAxNeBsJ8iDw8KDtjOVyxXxjbnHBMPnP93?=
 =?us-ascii?Q?vUTM+i6/hllLkT2UcB0LMzd8IgQwIvKtTNmMieZ7rCAM1cc36iLCzVFgKBLX?=
 =?us-ascii?Q?jYjX5/BJX0A/GR+tO7F2klLTNXlVnjpcAKo0qqny1Cf9Q5pKKGs4tM3XC6te?=
 =?us-ascii?Q?A0uiWW9oJTsbMI42Ky7SZgMyIwxFxrFevYxcgWAUypbQaTjr3o5kJ8zIOlXe?=
 =?us-ascii?Q?VCbUA4yX5g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9910599-7b7c-4563-1985-08da2e0481e6
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 19:30:12.1527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FPi38SGZ8y69wnKKoCdgQWZfeHR2aaaFqOb7OkAeuMVJda1By32qDsceJnNTC7d6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4563
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 04, 2022 at 04:01:46PM -0300, Jason Gunthorpe wrote:
> Use drvdata instead of searching to find the struct vfio_device for the
> pci_driver callbacks.
> 
> This applies on top of the gvt series and at least rc3 - there are no
> conflicts with the mdev vfio_group series, or the iommu series.
> 
> v2:
>  - Directly access the drvdata from vfio_pci_core by making drvdata always
>    point to the core struct. This will help later patches adding PM
>    callbacks as well.
> v1: https://lore.kernel.org/r/0-v2-0f36bcf6ec1e+64d-vfio_get_from_dev_jgg@nvidia.com

Hum, I fumbled this a bit when extracting the old version. It is
rebased on the wrong thing, and this is indeed v3.

Alex, I can resend it, or if you want to take it then this hunk from
v2 is needed to put it on top of the mdev group removal series:

@@ -444,21 +444,6 @@ static void vfio_group_get(struct vfio_group *group)
 	refcount_inc(&group->users);
 }
 
-static struct vfio_group *vfio_group_get_from_dev(struct device *dev)
-{
-	struct iommu_group *iommu_group;
-	struct vfio_group *group;
-
-	iommu_group = iommu_group_get(dev);
-	if (!iommu_group)
-		return NULL;
-
-	group = vfio_group_get_from_iommu(iommu_group);
-	iommu_group_put(iommu_group);
-
-	return group;
-}
-
 /*
  * Device objects - create, release, get, put, search
  */

Sorry,
Jason
