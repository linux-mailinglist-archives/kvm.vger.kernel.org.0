Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB3335589E
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 17:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346120AbhDFP6G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 11:58:06 -0400
Received: from mail-dm6nam10on2083.outbound.protection.outlook.com ([40.107.93.83]:35809
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232363AbhDFP6F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 11:58:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QG1N/m+a+UsFKezkBtkE93yeQbdOfi2TM45QYbbtYB/sM3wRI8BkZPI0Sbo2Pq5y/uHCfg0M/WTlup5N9EQZtD5qZAqRPxbvwFyHwUys1znCpMt58c6VDTlYIIO6Uu+4K0mXHBdaody+0djT60/Sh3SjaSEZUEU1M+KbrAMPbMPTfh5v6+dE5ve+9RNhpIuwSAH3lQAycF1NQRtWDCw7/q9dvNvp/5/ZIlthAJ/m+cboTE/HdFg/58MseTdY5snYWEnRSyjI9WkvyBIOljkAUVp6CHNGFVzBqXDQ3CqPNZTp0H8+Tx55TJbIQS0forQgJz8pktwqlD9IzImG2rDeTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CoM0K/4Ahnh4JmbdTsJi4PL9iRPS82VyiOqvv3oPOtw=;
 b=ddmeKG0v+ICbx1xr7YFdfLGnfmSdKRBSg/FkUJN+4ZpHNexZWzrAf/caxbSbsWY39UmBJYy4DEJub1l4QTIG0elzBqGjzQtZdpRUhxe641nEwmkMsNhFO86CM+NZMbNzDPmRCX9kH9H653sGHm03Tsl1Ozw0+qTF3YT5rLuDTJsC81OqsvgM5+L8V+E2FV5dbpQw311pUsh7YPniEh+Dk7Ar4vG0k0BFzS0YYCEU30LmIaFjPvvQOjf/+c918blW0cNorlB63XO8l+77A+n47IkQ4GNeEzGaj9oNDkJwmBpFvN/qleC08Jp2+JO9A7LM1T9S5GY6AfVUS683eag+MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CoM0K/4Ahnh4JmbdTsJi4PL9iRPS82VyiOqvv3oPOtw=;
 b=BUUXFcmG5U+H/vGPkdAKJHkQJ0MJIdH9PWbzVuHMDqgTUW76aXGqmYpFqto2dum4FRGY9o2q/+LTBGsP8g4CtKlYlWxYI/Dzco6pSW07jYiiywrupqudg7pJyS3Wwad76N90cZkF2qR16qxBJ6kp2pU8rRzak6ftfIT0JesKyJSRADCGVpHrvHqpHsOKoN9MCQcYMZkTcxQZAh5xh2/47mL+Rb2DCiFLuKwUp4hjRKtdE9N9PcF/1SeakqVIPPsVAOtsVV/PDFwGb1W2jsYTc2F2CdeHnU4IAdG4f0x4n4XSLj2d5PFFIVLBCF+S7HVpyPuetY0RCso8pu0r/MPW+Q==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4619.namprd12.prod.outlook.com (2603:10b6:5:7c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Tue, 6 Apr
 2021 15:57:56 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 15:57:56 +0000
Date:   Tue, 6 Apr 2021 12:57:55 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Jike Song <jike.song@intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: Re: [PATCH v3 00/14] Embed struct vfio_device in all sub-structures
Message-ID: <20210406155755.GA280925@nvidia.com>
References: <0-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR10CA0011.namprd10.prod.outlook.com
 (2603:10b6:208:120::24) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR10CA0011.namprd10.prod.outlook.com (2603:10b6:208:120::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 6 Apr 2021 15:57:56 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTo5T-001B9A-Ca; Tue, 06 Apr 2021 12:57:55 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 453fbe65-86c8-458e-ea7a-08d8f914be8f
X-MS-TrafficTypeDiagnostic: DM6PR12MB4619:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB46190E7CE9DCA4D41B1B13EAC2769@DM6PR12MB4619.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: os+Sa6+kRFfK2hr8FGiaR4P6yoYB1/qqcb8HihAUrXb3SETZYwwLUH2FLtUDYc9Nlkv2reUuRYo7b4BRJCs+46RIOCKuR38DFtuM4usr9Sdd5rLsUoWU6VMP6JYVY+v8OUR6/W6q6RV8VKlDyM6Et4fdKBJVf2OhKedhXQo5NyUWAgw8BergfOWVvDfz9tILZtFJWnJwrCQGq65zNvMjZYQ9oHdFiZsPbJpDDokIwK1n0iVilnvEMTyhMB85e0apYJlciLa/wPfeid8JXgOEPSwBs2o14rRYI79IWmHr4try7Mnv2mieYgz5IkvXR4m3lhhoZjqq806xXDdBh9I4pjQDuDZtaEo6x3Qw3zs0ZNyXWFsSkPFULA4Lu/n1ODGLf6dkOK/udGQ3BK871ZFzWTmdKQaxz0pv46a75gE1G0oRVGQqaXyUV7t/goApvf7kQ3rr0J3B7ds9DzQrn2znudMypUyJXhyp+NFBeQULOTBnT0ZVlEV7P0xPIk9e/qFU9xqeaaUazYg6JC9iiBQGeUYj7qw591xV3dzbbNbsqAVlvOBpdT/MIxWJ3rRPhSFD6a+wk2XeibkiTLxazdbw8x0/aHLVy0ZCR1UChidyA0nuxr9mzX4DmKjBEJJdtsyN1ihwWng93Qy3qD/Hf9HqT8HIBhx7mcOZ8aGoUIWFhePlZ0Kn6JIJAz59h8jKU7kP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(5660300002)(36756003)(4744005)(54906003)(66476007)(66556008)(83380400001)(38100700001)(26005)(186003)(1076003)(4326008)(2616005)(426003)(478600001)(33656002)(9786002)(86362001)(9746002)(316002)(110136005)(2906002)(66946007)(8936002)(8676002)(7416002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?SEsORJCuA3p8QGFTxXZ51mY74ytDdWeLkffD2u95yTJ+1RBQeG5LRyJ8rQPV?=
 =?us-ascii?Q?H10GPgQzrJB/iPyaLjTA0Oak3kgbFCkYrO/eXsHIjcXv1Q+8vnVc/W06itxC?=
 =?us-ascii?Q?COaaErfeC8MzA/Gy/Kb4ad2+KoD1Pc+PM1TxlytMsmGn58yvz/FQcqEIK6LW?=
 =?us-ascii?Q?NGdyQYRZ3zLmZrrje++Jt6NgU27NIg9Fi6ZcDI4kPmexwpcR6bGMHqpfuhtT?=
 =?us-ascii?Q?DG+CMUqzBjJEyT8e6RWDOhb/gOMfWu0iyAsum+mz7Unue+KxB+vpiyxp4iaa?=
 =?us-ascii?Q?RQJxWxeOIH+n/joGXbWWccdqhz/9HjnLrkktygYQbp+2qyOjAonDlfERLOcg?=
 =?us-ascii?Q?QujJ34CSDSbXKovIVXyeVNGq2iVExwcPSRsBP0nqBppwlR2E70P9mOV15nzO?=
 =?us-ascii?Q?ZcOS8NQLs+n068s/eN6jJHk0pyYz9jEvZgVWgCveLm6icpKWkQ8Tmy9RLiyP?=
 =?us-ascii?Q?exc8bSroHzGodO+ZAktLifl4tJwCEzYCyueEWVdZQJZI+GcNOm/AZJ+humrW?=
 =?us-ascii?Q?Mk65uIb95dCA/Ca3gSNEuUYxyP6myVx1HrTL0PMfvtUXbDkG/m6ctWwBYORw?=
 =?us-ascii?Q?AP5iQ0c3hLeUKT829t+ZrNqxOcIPCIuAvaJvf2IAZAI/NvYQvlMe5J/WFQvd?=
 =?us-ascii?Q?MMR1WIgIn7xHWPo8JDDuoj+KYHot4KqYQxmPw2UecO6Qz3jHPHvqrldrDDel?=
 =?us-ascii?Q?pzBkl+D7caAFEJ9T3bgVDfQdM9fOJI2+6JozbRKE8MQvnBXF2DpTVV+09SFw?=
 =?us-ascii?Q?oo1SKUHAV9yJa4IWGivICvURIoNkJcVh8pQ628MhOaIGCM6C3lS9bVXGCvdK?=
 =?us-ascii?Q?ypEhR1oQdA30mv/0yW2CLtm5f5ky0Tp7UytwH9pPq51G+i0bYrTGw32pmVC4?=
 =?us-ascii?Q?1WHzdXCflboWrhsmZCCmu/s0m9Akgcmn+BphNR/srqBwDo+UKL2U6JG9PvWn?=
 =?us-ascii?Q?fcdrI4SlWR33rsqwcLPoBn0R7J6Pqzzh6zuzFl2Yzv36fM7vCwO37sIZhkR+?=
 =?us-ascii?Q?Lk9qm35Ak1VK0iAQ37I7rs7Goj01YQLPSdyTFlCx6fzkdYjVAnmDFmW5muI8?=
 =?us-ascii?Q?zmcXGTn1xnSCUjHE2PJShrpBdfSG+Ew0rP/VfT/pDRnDftUrlYEBlEnLJv+n?=
 =?us-ascii?Q?1oBLFPtKR6r7ktDdrlI4yoFX4lrHsgHYs0WFq9GSNIzo/WI/MNo+CbQga8Lv?=
 =?us-ascii?Q?AH+kITTpk2fUITjM++R9W5x6sz5ULJkuNt6/PIns4ZLtXt/sJMGl+USxGh7h?=
 =?us-ascii?Q?IpglG6CNi36WqAUvB7hDK+WOWmlPm/SuMd1iTNnJLuVbui+BKpqMPR5aS76I?=
 =?us-ascii?Q?GrLEfp1SEVTjaOLLz2XyXJ69PwevOIZ0eOuvLOo4VtmgJQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 453fbe65-86c8-458e-ea7a-08d8f914be8f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 15:57:56.6209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ym6kWjLSteB1Hae9lSHaZ3PboFSDsIZqM9u57orq7YRYLN+H/qHMBARmuDdW3mbH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4619
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 01:14:52PM -0300, Jason Gunthorpe wrote:

> Jason Gunthorpe (14):
>   vfio: Remove extra put/gets around vfio_device->group
>   vfio: Simplify the lifetime logic for vfio_device
>   vfio: Split creation of a vfio_device into init and register ops
>   vfio/platform: Use vfio_init/register/unregister_group_dev
>   vfio/fsl-mc: Re-order vfio_fsl_mc_probe()
>   vfio/fsl-mc: Use vfio_init/register/unregister_group_dev
>   vfio/pci: Move VGA and VF initialization to functions
>   vfio/pci: Re-order vfio_pci_probe()
>   vfio/pci: Use vfio_init/register/unregister_group_dev
>   vfio/mdev: Use vfio_init/register/unregister_group_dev
>   vfio/mdev: Make to_mdev_device() into a static inline
>   vfio: Make vfio_device_ops pass a 'struct vfio_device *' instead of
>     'void *'
>   vfio/pci: Replace uses of vfio_device_data() with container_of
>   vfio: Remove device_data from the vfio bus driver API

Hi Alex,

Can you put this someplace to get zero day coverage? We are at rc6 now

Thanks,
Jason
