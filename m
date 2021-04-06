Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1DE355C86
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 21:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245044AbhDFTp4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 15:45:56 -0400
Received: from mail-co1nam11on2060.outbound.protection.outlook.com ([40.107.220.60]:58624
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229890AbhDFTpz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 15:45:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sdg+JArtA1g98dclu/T1yvkZHZi55QM8LZUpBfIdv3SKeQrLU1Fr5BZ5vSUmvOnvN8nhOppI5aK0r4qe0IWiXKQXnau/+qqgK5VUjOc90ESmdUU/sB6ErJk6XRyd0l8lqpoiVIZ3Mh3qPWy2T5yN4Q6HSX7xVRZEiLH5noOVb9IXHBUKv6FHejJ9bNIRXg/APTbwfSfbpWvglt3BOR2aev8WJkuafDBiwr9f122I1Oc02gPWSryW6VGlt6PpHgsbBFvMTOv1ybL00KGJtp2ez1p1ru0mJ9SJHPneSSKPouMYJZ6S4P4RqTMK6Ixx3GtY32ZQr0YKtcDWYRZychoa5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=saHVH3jLUFMV86mw5wai897bClnVJfVjZkui6Ep9HPU=;
 b=AHZChWv6scmxhM6/Co5UnhvJrHbVPvZAX3WaOjFowms4Wik1krcPHoun8TTYvSoa2ak5tIVWUcIa7je83Pn6wJDvK8GUb2H0eov/1Bn6FyxiRwnvtysWT9deVLNfwgL6CdvcNTJKLRQzy6ptkLOt9/cBAvDsZ6/RGXjTKPpU8YJnzrO7Y9fsoP23L913Z9Y5E4JxCJk5rRbrw/g3ehZ1NNRlSHInCtIBtS4ClACsz1CSdOwcSSeAVqfvfIvLkCPL3RoIv9M/BXeryD6UPskXsCckX76W9ooqghJ8fAgOTMhgB+ndqIlKVdmzydiGxh8FumoVgSvu971M+UlOE8hFGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=saHVH3jLUFMV86mw5wai897bClnVJfVjZkui6Ep9HPU=;
 b=jU8QfmfPNUExt8UCCtggiFw7nIqvN3vOpdfVZzrj/PQSSyGa8BuRTayL8t84QY3KcwbwcOViSwgoSXHTWXlnSDCSbgQ1/XkmaWFhn/4E1iLxgIaD8kYL5cpzR1DQInCmh9tLCxKCSfK11SFhEgoWn4YZWMntDObFXmoS33U1NPZcC+0yoBDN2j+2F/2zbck8YAcf5tA3rB+X+0O6CbqETawh0edk1C2FOeKB8H8EhDkyOEzsE+w/N9CEp9vNdIaDx66gm0+CNb2UT5InVmBsE195TIgcccpP4nj3Ev02quIlXO7c8xQiWuMhPvmMyTq+mA+EU+kKpDqhCwFl9BZqrQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4137.namprd12.prod.outlook.com (2603:10b6:5:218::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26; Tue, 6 Apr
 2021 19:45:45 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 19:45:45 +0000
Date:   Tue, 6 Apr 2021 16:45:44 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, "Raj, Ashok" <ashok.raj@intel.com>,
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
Message-ID: <20210406194544.GF282464@nvidia.com>
References: <0-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
 <20210406133815.40cc1503@omen>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406133815.40cc1503@omen>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR18CA0002.namprd18.prod.outlook.com
 (2603:10b6:208:23c::7) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR18CA0002.namprd18.prod.outlook.com (2603:10b6:208:23c::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 6 Apr 2021 19:45:45 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTrdw-001mdj-7e; Tue, 06 Apr 2021 16:45:44 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de5fbc4d-4ac5-4ae9-6cf2-08d8f93491be
X-MS-TrafficTypeDiagnostic: DM6PR12MB4137:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4137389591A646BE7D7FB786C2769@DM6PR12MB4137.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Iq+KE8xhpUj2cbFRw1Dgbzd8K6sZZLjsrhbK6f25rqnwmQgURYFU9O6OBzRf3F3BuzSEL2aLcBUWkw5Ef1xTnt6M08EGMkMEcI5oHSl4S+BgcbTd4t7Oa9CXoaALYbmhYwQhR7SfJno2WLUu9370L2N3BASQQvcfdTQIJAJ3NIX6AyFeF+B+R9/RiTFApNIYfzEZoLt6+pVYALDJPU4UI1wPx6RMtUA8xPnG7oC3Lvt9R9Pbs/tPVwr+7E3p9ozfrnYLPABlVM+RXH1F7YLL00cYyAJdX+SqjO0u73yFyyzmCVxV2Yor1wT8wLwa2yLmwqJGZikFvEc7EBlQJ+KubbE7qM522XW0FIM113J8lx5cROq0ti0Rr+yS6vkVXRpckgnzc8nc9fXGHGYxnOBdDzbu0VKrns8FJCoLPHz0XxiEM8TOCVTQ7UQ4A/H33ZcuQTg3H4r3lSyC1E6FMdLZVpJngQW/sxfgacx1JDSt9h/8SP0mwiGnybgKwin5xcIl9SnjPW5fvzbLHjeQZL3h/Bfa9L2vVcVeClDgO3Mw/RCB9kRPHcckWeJIuE+cfx7BRHf/W8EujTtMCfZC2Olxzx1SoMA7313qa1CSTtsCQ8xNMwfa4xtN2zRxoUza63Wo7kYIJwiMhsQBsfDCafaNSElFnCnYZskZyULauY7oS4H5VqaryNnFJ+YHshQn3m8C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(478600001)(8936002)(6916009)(54906003)(2616005)(2906002)(9746002)(66946007)(66476007)(7416002)(66556008)(86362001)(9786002)(5660300002)(1076003)(36756003)(26005)(426003)(316002)(8676002)(186003)(83380400001)(38100700001)(4326008)(33656002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?y3LdB6WI16UVq03oMWICZbaPwuygebNfAe7exkfJAnJAnsz4HX6pCEAMC25c?=
 =?us-ascii?Q?+bB4cJiqE7NlZ8JftxWdS9vaR4UOYZp9s685WmajtjQQQPlg7Qg/EXJ1jvOR?=
 =?us-ascii?Q?+Ax62mLyrSef8ZABEAu9q/yuggBm6LdVYXd54FJgWqSspzP2KmrAsZqdTi3X?=
 =?us-ascii?Q?TsRbRrcQgPDnFrqzj4zva4CYdyxUKoXUmN6z03kqRpqELVKb5kubu6rurKdW?=
 =?us-ascii?Q?znO7ZZctz2Zzedl/P4P6rVOQBwuUpVqq5B9if9SShCPd+5wnTAmExRbIyYhX?=
 =?us-ascii?Q?V9GczfA7H4/H49uq64eUQg2wpGC9xWSowZJRMMS/BcUjKS1oqmasXRf0Cdqa?=
 =?us-ascii?Q?01Ns0gpFytVptD7Wvy0dSTyELJdE6N0Sq06EicLLz2aKypRv33yreoPL4qSR?=
 =?us-ascii?Q?RnpMLRKk4bs3wawNG0ongvBxoi1TSN20Er41qm05LrUrlAsEGD5PTnBleHSL?=
 =?us-ascii?Q?Xp3s62wwu77BfxyqDz/sUEVRTxMMfe/d5p00d7cXEHRuNMMQDRQe/EuUQdel?=
 =?us-ascii?Q?YWqRkgyIICiBaig4QIKUquF0J6i7GPElwsEOQVRoCwGkOOiuSZ9YAuXhfbWb?=
 =?us-ascii?Q?DlDtvGJ2ZOoAcw1rI60ga15hIpA3ToM7YPHnhgkGDBEfowi5Uy3NFGP39nm2?=
 =?us-ascii?Q?3VZ4EJ+WbXidgBP05LNYU2mFlJ/xe/xBxMs4GJYsH4V3L69ec2OBKJgIgrgn?=
 =?us-ascii?Q?yOJMDPqRVsXp4dmFtsS5ruKicYbeLS6KOm0ANHuae324biKa26u233ZeKEBt?=
 =?us-ascii?Q?vV++koYPesUewoJdWk4PXv8y13GV+xTuZC5+3ZMCd8RCKENgHkidq4xyIaKe?=
 =?us-ascii?Q?g/sCBNkHddJ02vi0UZYIl+91OIUfIV/KxzEItTUnUJwCvVoXCF8ICfQxmYaA?=
 =?us-ascii?Q?wNLcSFndHSis6fYwtxzSlNlxDGJWUTObqOzU8OkeM3Qe6KRsIESbLhKt4Jt2?=
 =?us-ascii?Q?+jvzsFmlGI+NvhdhOekBPUUSxDzFAeZq064aspSMuh7yj83me5Ha7K+SJ0p9?=
 =?us-ascii?Q?xrzo7U9N232wwvvV91mn0UqyPdsxdC/pKhxe3khSIfgVMwWKvFOtA2MMbezA?=
 =?us-ascii?Q?WQgf4PmDc6ibFCk6qFG52OE1VS6z88ZFZDr2jHvtmwrWrbVuYVLb9gRbSX89?=
 =?us-ascii?Q?q8hEaglbcL/szubUEGWScN3Jj/ZG1+pMZ0ow2zT25zhxjfT/BphoMrBKrQHk?=
 =?us-ascii?Q?ZvWoLyUvxIvqXqDABhRaclSsH2hP8IgyvALIIbwSXu0qC+W6Iht8wynglIFn?=
 =?us-ascii?Q?29tTpzOq0yEzT/5Fq9noJKxmylQkNyBfOAjwHYIF3ReVvbPgk5bA+0JbGuIp?=
 =?us-ascii?Q?FW8JRW3mGCQRPIOq/IBjMw5HxxXbnJESqDRuYuYZbW9xGQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de5fbc4d-4ac5-4ae9-6cf2-08d8f93491be
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 19:45:45.4275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ELh4Wevptv8hFxFyfNjXPz9CS7yQ8H9c0NPpvA1xkAzSThk6BmtGAEcU3IV1rm2c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4137
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 06, 2021 at 01:38:15PM -0600, Alex Williamson wrote:
> On Tue, 23 Mar 2021 13:14:52 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> > 
> >  Documentation/driver-api/vfio.rst             |  48 ++--
> >  drivers/vfio/fsl-mc/vfio_fsl_mc.c             | 127 +++++----
> >  drivers/vfio/fsl-mc/vfio_fsl_mc_private.h     |   1 +
> >  drivers/vfio/mdev/mdev_private.h              |   5 +-
> >  drivers/vfio/mdev/vfio_mdev.c                 |  53 ++--
> >  drivers/vfio/pci/vfio_pci.c                   | 253 ++++++++++--------
> >  drivers/vfio/pci/vfio_pci_private.h           |   1 +
> >  drivers/vfio/platform/vfio_amba.c             |   8 +-
> >  drivers/vfio/platform/vfio_platform.c         |  20 +-
> >  drivers/vfio/platform/vfio_platform_common.c  |  56 ++--
> >  drivers/vfio/platform/vfio_platform_private.h |   5 +-
> >  drivers/vfio/vfio.c                           | 210 +++++----------
> >  include/linux/vfio.h                          |  37 ++-
> >  13 files changed, 417 insertions(+), 407 deletions(-)
>  
> 
> Applied to vfio next branch for v5.13.  Thanks!

Thanks! I just sent v2 of the mdev one, there was not much to revise
there, it should be good if there are no comments in the next days.

I have to polish the 'create fails' workflow on the vfio_mdev.c
removal series then I will post it. Not sure I can make this cycle.

Jason
