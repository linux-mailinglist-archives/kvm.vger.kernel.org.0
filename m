Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E031933C9B1
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 00:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbhCOXIS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 19:08:18 -0400
Received: from mail-eopbgr750080.outbound.protection.outlook.com ([40.107.75.80]:15223
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230325AbhCOXHu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 19:07:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g00hdstqczY99lVV+AITqoQv4SAaqcRTdJqRLtr6gkX04cg262YYPYV+EONFo49x+cT+4D52zjTNgRBqE9MImdUd+tAjV6dQlJdF339GlZGVY3345i67bCx+KCaODo18HLlsONShBROYNK21B2OYynGEd7kFOoGOg08u4pRuak7/UlCGa2nb2lQslISXRvXd+jVVyRPhCwsqU+IAOxOvkCAWkxbS9qi9d2rkxjoFJ/MccSzMIoIHpQilF6vpx/KQDm9qNHQFaZXM3hPV3JMSBY2HZq/S4+1qHFXp2I1p9fpEIZCnx5mQhj3qqhjHr9sKaxYMMoWbDGfNBysGQWNOKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iQIdYXSquEb/HPivdPlfv2/Xn0JRYd2Uxhby9soc8yc=;
 b=jRyBRXw4AC1TVFOC9mzcW2XQY9QGo9Roe/Y8OQ62P4FA0toJGfnIV4Y/fM9H3s/plmh0Vuk3h+XZyLDfhs0fddhYGa82lLsNBiSs1/+gr6g5out186GKXDVniNf7ay4AXyS1SsDnERKg627K3lXqwUVSocihXtq4GUQvDKgsWaCcmpwtyV8PsO6MKdvI3yBVryv9ajfIqJhPl40O37IkPNt2BTR3d3ZFTMGfuzNePhsFczksj21yhN8lL9OWmfBmbjbMIrz6MQrz9Yz2SxHnV6gcMoYVKOq8HA25137Tw3J4cALZDzp8niH4uHyLP4qwwwHHW97943HNdMEdcBpM3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iQIdYXSquEb/HPivdPlfv2/Xn0JRYd2Uxhby9soc8yc=;
 b=s1wsLbd666sf7fLOutLQMpS2uK3sM+o8d3AynREgQlm48Ua6ypyERxkAR5i0KC+6tdeNwAXq70DMhkhLuIN+wvOGTJzSG87vHOBzpnGzF59JjDKd30E+URMI36cSuZsnlS8a7WhKEirNMOOruGhUZv7epSZmsJWUq/QkHFbC6vFos7wMpYCRgGsXBUAF8NJYcdCBbItCK6+AZQqrY0Tl/yKIlXLM9bDlln039ZRagPuSzu3qcs0HD8Sz0avBl3gzEMUUT9WiMbSwkaShjkxnS3VrtffW7xRNQ+nOefoECbGdIU2d2ATpHYxFiIwqt0ITkbHfhAU3A05i7IRhDXFd3Q==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3116.namprd12.prod.outlook.com (2603:10b6:5:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Mon, 15 Mar
 2021 23:07:48 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 23:07:48 +0000
Date:   Mon, 15 Mar 2021 20:07:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 07/14] vfio/pci: Move VGA and VF initialization to
 functions
Message-ID: <20210315230746.GJ2356281@nvidia.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <7-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <20210315084534.GC29269@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315084534.GC29269@lst.de>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR0102CA0050.prod.exchangelabs.com
 (2603:10b6:208:25::27) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR0102CA0050.prod.exchangelabs.com (2603:10b6:208:25::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend Transport; Mon, 15 Mar 2021 23:07:48 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lLwJO-00FWFh-Ti; Mon, 15 Mar 2021 20:07:46 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b12e51d-df51-40a0-729f-08d8e807267d
X-MS-TrafficTypeDiagnostic: DM6PR12MB3116:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3116902AC8DE5A5CE99D868DC26C9@DM6PR12MB3116.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3ZeaTQ+1J6bi7uiP5SESIxQEs2er8noEJ9uthkBoXoBrY5cJ4FX+/X4eCL16vrMQHtfUYGvtR3FaqiMJ7TImdTO/uSpyhE5K2mu8c8dU+Nkr/uXl4TbF2hHzPd/IyJnpPEwPOn06Tn9uBBgmUuJM1e7weyO1JuREyHWtPnrtyYNKhsB88DOA76M8+k55WWo+kmoEtp4RIBKIxW2IayaNJVBA2r6oSbVRsBbPc88mNVY3SNbCqxbHLf2TkUFxXcuwztY8nprWY0Xu3HRylAII04JU06KJNFHEKjSerdBSwIZhDZXuuVxDwW2ojETPNatiAKsjjrjAXe+LrQuIEGWMa69PAyV4cCUuC1cahqBIeO+uyqfQ9+kS14Q/lm7awQ9faM0f8oWpsyGV8sdJeRXv9So42UDI0M7PHP/hhy49nPYpM/5msEOl9qVdeHRv+KaGDbmsdGxym/UJI+fXNz1IlbFvxZtbnnvlNG1I0HSEUQocmrByBph8y+xze+nZMChY2vKYorUWAoWCNBQ27MJGOFAauzO988ODtdMtba+khIWwGldhxymuSPa1dRDUBC/J
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(366004)(346002)(54906003)(2906002)(83380400001)(5660300002)(9746002)(316002)(86362001)(478600001)(2616005)(1076003)(33656002)(8936002)(9786002)(426003)(6916009)(8676002)(107886003)(4326008)(36756003)(186003)(26005)(66946007)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?oNjP3R0XVk98NACw4DwblkCYvVkWY9x4RU2zyY8d70HxuN5UPezAettphfwx?=
 =?us-ascii?Q?swxlKMpGGxy7uOaSzv69FAjKudIU4PmEJa39qm0llxXz3uJgPe4xPTTeA1OG?=
 =?us-ascii?Q?X6+VvioA5wEDa6s5kM/W4R4XRz4+yBFwOqwppoGy/mRCOyfoIr41NL85+PqM?=
 =?us-ascii?Q?Xgq8NEwWZvlCXhs/waG/p+AzGBvCWUboQJQCrgmXKGSPCVrVhYCf/GF7/QQl?=
 =?us-ascii?Q?sA74VI0Mqk3KS72N5oNrYnMFIl/8hF/Kf2yMWibLThd7eOPLkPnKjcwZy+Oz?=
 =?us-ascii?Q?GFhBCdKxkUnoF0128ss8j0kJcODNZVLBV5kMgmD/+pqB4/49NO+/PYRDZsGb?=
 =?us-ascii?Q?irsC/Wd03AlX/wGzLW84eJt+ah+MxNRN3QHr/izR0I5dRM84d5p3ZT99AqcS?=
 =?us-ascii?Q?bf9p2YnVL86kTMphSpTHvYTad3yFInXDrX8wvKXYQeBeCbSO2EhV2ip7Jq2D?=
 =?us-ascii?Q?CMeJPNpfOxCoMs8JyoWTdphIanNS0/uP5vz6lDEVJ37ZahCxo82FkIPHZ6Fm?=
 =?us-ascii?Q?9Z/HpDy9WoGQcrR1QKvxYUX5iMac58A1+oBHzfUOP84Vgb/XU4UnLRQS8rAr?=
 =?us-ascii?Q?Q7DNcJzzPbnEsjVeuizRhfCddEpWjOCEy+JTzZU0JG/qbP2YFRIpkeY90g/5?=
 =?us-ascii?Q?IG0ytyt+M/EUGP/2UMuoWboJIGl30Ey2p/jicQDgLF43iuq09912qfZS0KGb?=
 =?us-ascii?Q?NSZUqPJCi6JTEa69V37op78EYmveIkZs9c2Wc/6mrbd6b5nXVU2e5CWYt3ZQ?=
 =?us-ascii?Q?3/AQ230JXa8CvQTexCyZEi9rWSFTSalET60CWXm+pJSPSx5ADMZLfDJNTgLB?=
 =?us-ascii?Q?118tWqMHsUamgPHZvpMv1FZlegEgdmt2IcLQZsIep6xQQSOYYF1Gy6k1tA0w?=
 =?us-ascii?Q?yxTzK9D/D47eT7n/El8sLrJPrw9REg8NUBMGyFnBCtwYtYf2xkgmvCjKalBn?=
 =?us-ascii?Q?GxTcfFbhSLXUSeXsjFS5BfsuCAYy4GzBDYXvCNQ+m/pmmtcFVEvEwv7oRAT8?=
 =?us-ascii?Q?zvym4wUJN2wXUjzUO8a4rWMLrzIzFA5nHj2IXVCWS3iymfmX9acWyJqW9MTs?=
 =?us-ascii?Q?5ihEzURFijysrOXGhjWhG6nu45H8zrYL/Thagx+2AHq1w5wfioK390wuH2+K?=
 =?us-ascii?Q?wzWYC0aFTOG+oXNyLjqwJl7Wny7vYPfg7oADeNjvCyvBjGDDAOg5YGnTkINQ?=
 =?us-ascii?Q?um1FG4FCXMCaUchO5FKjLK5fc/YuAhnlmJCswZZBlAoxk/Tn7uav86pCykpE?=
 =?us-ascii?Q?+cr1oE45YsBnlmcjj5zHaMRbX1AoNVulaEv/qX3E+GVPyNJcpv9Qo/9/+RoK?=
 =?us-ascii?Q?nBi8JVbBCmFdibGigmhbU4LP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b12e51d-df51-40a0-729f-08d8e807267d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 23:07:48.3884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TcG7qr+DoMEL7+x8Rmf4Q669qxbMRn81nWcIbA1CdjfpinSVX0SIOYS2WIZAbAZR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3116
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 15, 2021 at 09:45:34AM +0100, Christoph Hellwig wrote:
> > +static int vfio_pci_vf_init(struct vfio_pci_device *vdev)
> > +{
> > +	struct pci_dev *pdev = vdev->pdev;
> > +	int ret;
> > +
> > +	if (!pdev->is_physfn)
> > +		return 0;
> > +
> > +	vdev->vf_token = kzalloc(sizeof(*vdev->vf_token), GFP_KERNEL);
> > +	if (!vdev->vf_token)
> > +		return -ENOMEM;
> 
> > +static void vfio_pci_vf_uninit(struct vfio_pci_device *vdev)
> > +{
> > +	if (!vdev->vf_token)
> > +		return;
> 
> I'd really prefer to keep these checks in the callers, as it makes the
> intent of the code much more clear.  Same for the VGA side.
> 
> But in general I like these helpers.

I'm here because I needed to make the error unwind tidy before I could
re-order everything in the next patch, as re-ordering with the
existing unwind quickly became a mess.

It ends up like this:

out_power:
	if (!disable_idle_d3)
		vfio_pci_set_power_state(vdev, PCI_D0);
out_vf:
	vfio_pci_vf_uninit(vdev);
out_reflck:
	vfio_pci_reflck_put(vdev->reflck);
out_free:
	kfree(vdev->pm_save);
	kfree(vdev);

I'm always leery about adding conditionals to these unwinds, it is
easy to make a mistake.

Particularly in this case the init/uninit checks are not symmetric:

 +	if (!pdev->is_physfn)
 +		return 0;

vs

 +	if (!vdev->vf_token)
 +		return;

So the goto unwind looks quite odd when this is open coded. At least
with the helpers you can read the init then uninit and go 'yah, OK,
this makes sense'

Thanks,
Jason
