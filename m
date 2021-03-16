Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F5E33E200
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 00:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhCPXTo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 19:19:44 -0400
Received: from mail-dm6nam12on2086.outbound.protection.outlook.com ([40.107.243.86]:40800
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229517AbhCPXTj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 19:19:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cf9lQVEmz9/3NUolRpTxgSUcnuIAU6me9W4rznj2oQqnCVVfYzYdTTsAzSb7HzkK6wtLFKLlXzyBoFKAi2j9Km64ULDIBV+1Sbm/mA5w6og3GBMq1J4IyAMDRU8MBxYdMnV2Bto0GC+Ldc2tGHmjHSuZ5i+WYFBc2wdI4Aj15YbqrbHqhcNE1o2B9ai6UfJv31/vquucmRGlIdbBZ5kaBGKpcKXPPR2UBX/DPr0LWpLF+67q2QvUkUPAWmiTgda3wfDLhNIfVaafL8KOVtehFQrLjN/Tu6uj8hK/r7Oa6E4bMcLFkzlK8iZ+yFMF5lcmSyddaG2ImGmT7FJ4LpV0SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=POtQvrpIQnHpefltMpYNxUG+PthtFJsQZiO37NuSc48=;
 b=leTBcDHFxRuYmr+U3HtGRN7SYQm46n/AFZD9oOQikfNRf5TdRAkYTjLt7VrJxmjcyLj/mRLap7NcXSAiyk6QmPbCNKHujZ4twngserM3gb6JsOkG7hWS+r85fbp8GCwQ4jSsqyOCbcVm+bSzM1oqMDJNWxSQpUYPtk0RzaPxiZYLuF45nqkkkCB/84MQcNBNqxKT1xN05rC1NB2pDwFNMheQdAfRSGD5uUJxvvkpDTqQCMxTN8C0CV2RT2sCnKyXQvaN7atZUeS8OZmiXoTDeIPjnxbW+YWk89VZXx47Tzk9OyPNKhwJCxnEtezEBhYVG6N+0s5W/qdG1HU964I/cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=POtQvrpIQnHpefltMpYNxUG+PthtFJsQZiO37NuSc48=;
 b=S1Jc2VbgiRJN/wn/4VcqLRnyVtsZaO1RMoSSOfTS2Oy+MAJCbWuNmIM0jGejtqqjhy1TtqypTaIgzlOc/LUqv2I2mG9BhZimkxHLEkR7i85XwKsb8mCyxhnAqGJ4iF1zXH3sovDjuiTDWsamDbjy8GWJT1FFXdgAnoEAwwOOzNWex0rIF0GbU3SCMf7+K4X55LtoLYFhJJMIlgFqQI7a4o/6eA0lkqkjhp18Aig/TO1UmndGWzzxGsnkLO+T3UGZKu7BljPZpyZLkVFGUllqkT1AUqPrT2RevYLOuVh7U32V+6KBvNhwOU0Gg43b32AYISOYtgQdLrCI3NHiUj9Syg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1147.namprd12.prod.outlook.com (2603:10b6:3:79::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 23:19:37 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.033; Tue, 16 Mar 2021
 23:19:37 +0000
Date:   Tue, 16 Mar 2021 20:19:35 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 10/14] vfio/mdev: Use
 vfio_init/register/unregister_group_dev
Message-ID: <20210316231935.GE3799225@nvidia.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <10-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <MWHPR11MB18869E91B6DCC8A74A30E3B68C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB18869E91B6DCC8A74A30E3B68C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BLAPR03CA0127.namprd03.prod.outlook.com
 (2603:10b6:208:32e::12) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BLAPR03CA0127.namprd03.prod.outlook.com (2603:10b6:208:32e::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend Transport; Tue, 16 Mar 2021 23:19:37 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lMIyN-00FyQy-Re; Tue, 16 Mar 2021 20:19:35 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cbb839e-367f-4d82-1c3d-08d8e8d1f782
X-MS-TrafficTypeDiagnostic: DM5PR12MB1147:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1147D62D399665E9EA3CE2D2C26B9@DM5PR12MB1147.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mu2ZK3GWw8ei4KOZn0yomIiBDGSSlP847PkDdC43G8sz2GnRRq4d+/uUWFHFG+wqRociSeZvVlVCdRCGL2aG34NRCH++lhziBhc8CleKNLO7tZq+etUabZ+pO53x/qEA0bZe16DBOohq9mLneML8TBILwp5tGRdUWZ8pu6dXTLP7TQy/SV1kjnXhaEiQS9oU10uhFc8n3b2s5sdpn08fn20/ZDiEAtFcO5tsUsWuYzJ6NO96HwwYPWQ4i48eKyTrczzJ9SPYN/Pbc0pU7ika5B9DWXVOheQKnRJQbMc+J8AdB9mEd5JZvZ5W6ALd7O0LOqXNkezXzIkDZkK1ivTpNWAc1KAS+bQfz0VyuHuyJ/uPr9d/DomrgbweD9YYo1Kelt2i2SDQLwLuIh7xk/aj5J54EqtNZLuo5/YG0doQTdF7ybc9XubkTwORNAi+C07lCT4rCvVFp0yrN6oeDiJ1EMoc0Xc9bQ6CiI78RSHSxtT2QklQRn24ZsMTYZip7F9lpn9p5n8cZwD7xKj9/bi8Y9Y9wGgZyMM3lSA4p72IiUMie3mdsG3noIPy8a1vxmq0cmVu1RbRZ6jLGt7e54EcP4I/3/zpoIyhJh83LqfjRBU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(346002)(39860400002)(136003)(26005)(1076003)(9746002)(9786002)(8676002)(6916009)(2906002)(83380400001)(8936002)(33656002)(4326008)(54906003)(316002)(36756003)(2616005)(66946007)(66556008)(66476007)(5660300002)(86362001)(426003)(478600001)(186003)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lJnsVC1RzUaKp/3vmxsWBskZ2N7sG4Ci4Yh/LCMRQCQZrwrZt+of7r8eX9a6?=
 =?us-ascii?Q?G02ToMGIyoywkFj2MPCJHcsHBgWoIR9PIz2S37GSVLBUDcvLm8LlfZHTAJp3?=
 =?us-ascii?Q?a7X2OnIxXh4XPYlSOoDTXG3nAZyV3IT4G0Xs3GCGmnbE0qB9/NLCskpvIH59?=
 =?us-ascii?Q?OSc6gSUmEiS8kkiVtaejhQh6KKoMrC8eEiU9N7KS+g3zIOKgIl6bf83OL8B+?=
 =?us-ascii?Q?BEMG9paQ6aXvrYIhr6cdDklByhihfhCJQ1d66b8/jSgIORrJ1SW5V2fiBtTQ?=
 =?us-ascii?Q?lI46hhfuxubcuVlzJpT3np+v+Ws89K+BxEFJaw9rZFEbA7fmmEkZ+8REI3qv?=
 =?us-ascii?Q?IjDJb++z+WRi9XYRwk1pT/7157NsUZ2SgMj1imoUR6jSO1RvqyBMnNc5wqci?=
 =?us-ascii?Q?xqewu8bmUHyRZpZ2aro9DWxD4YMUUc4wtwkPVy6BezRDpC26OjDQfS0Is2N3?=
 =?us-ascii?Q?F+oZ3nQmDJb2ADlKRXiTP4VPb6uH2+1JHyOVz+lo+u5L1o9KqPWVESFN2taO?=
 =?us-ascii?Q?gpn6FsfprPQFfy1Fb1Gb+Kl/ZQtZbfqTY/BP30FCY+g1uKG8AZ7eVEMcZHk7?=
 =?us-ascii?Q?gDq1OBjU/KmqRYaVUfO4tgvmX1lMvzJXOeWOv0kCIrianmpgbM1zoe7QdkOo?=
 =?us-ascii?Q?2vOgPwN/rDoRtygrL+tvehQtCAJbWSUTBr/lWpd+x7h8+war6RvYyrgXRPZ+?=
 =?us-ascii?Q?34OltrV3CB7vn4EVNZZ8Um+K2MC6s9oLvtjT/MPQkIp+stza7WjpqWtZ3Q5g?=
 =?us-ascii?Q?BHI76qPGD5cC+k25w1Mljp1TsYNoYgt2t+cr1A8wlmRY/OrEYUNbFhS3F7lA?=
 =?us-ascii?Q?+QAZEBKmIqCVgKllfDypoEhFf8EH4qjsvnc2h5+MW+f8XWt9RqnFNh6pyqSQ?=
 =?us-ascii?Q?wB34mGAEvncXEWBgHwrZGumdIiqVgxpM9s/4NpA1+wp93UPDH9KI3vDtMWeq?=
 =?us-ascii?Q?/lQ0X2N+XaAnNiu71GR2rGDg4bKJ4y7038E1h5KNpvkb7le/BnUDvLhBRUBb?=
 =?us-ascii?Q?nF4Bf8xpPO4R4Sxh+GPHWlc9RT2BCEd4fALPS8cVHAnKLTN34lKapKyc1HLA?=
 =?us-ascii?Q?O7kFogwTwXaqP/ji1wy8eoXYMXgbpRvHwILzZYQHREj8S3BeQn/2yXW2mj2y?=
 =?us-ascii?Q?J3Gha1uNlQSVmGVbjnD7kyVjZVmZ8M94s/VhQwZ1ycxVd9dx7WMmEjqLTIj7?=
 =?us-ascii?Q?Pkph3v5Tztyo/lOYbWIDBs5dxQfaKPtedRINJ6SWh+IvodeJqCPRq8aCSBvi?=
 =?us-ascii?Q?JI2eXt7pHepBMgV6zz2I+xEqRIFPonl4wBMRiMDoJ+iBgWkXpWR0vbem5bsn?=
 =?us-ascii?Q?oJ1cX/nZoz9PZ0JqKHXm+Kog4/OYZzM04UCRGVFqdnUB0g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cbb839e-367f-4d82-1c3d-08d8e8d1f782
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 23:19:37.2772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tZvyeTl57snKLxK8z3On/iDsU/gEmLD+H1ThiLap82uVKp88lfOa3ppx0Wm+LfCD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1147
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 08:09:19AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Saturday, March 13, 2021 8:56 AM
> > 
> > mdev gets little benefit because it doesn't actually do anything, however
> > it is the last user, so move the code here for now.
> 
> and indicate that vfio_add/del_group_dev is removed in this patch.

The "move the code here" (referring to the deleted functions) was
intended to cover that. I added some words:

    mdev gets little benefit because it doesn't actually do anything, however
    it is the last user, so move the vfio_init/register/unregister_group_dev()
    code here for now.
    
> > diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
> > index b52eea128549ee..4469aaf31b56cb 100644
> > +++ b/drivers/vfio/mdev/vfio_mdev.c
> > @@ -21,6 +21,10 @@
> >  #define DRIVER_AUTHOR   "NVIDIA Corporation"
> >  #define DRIVER_DESC     "VFIO based driver for Mediated device"
> > 
> > +struct mdev_vfio_device {
> > +	struct vfio_device vdev;
> > +};
> 
> following other vfio_XXX_device convention, what about calling it
> vfio_mdev_device? otherwise,

Right, but let's delete it as Alex suggests.

Jason
