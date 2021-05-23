Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2637D38DD91
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 00:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbhEWWjn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 May 2021 18:39:43 -0400
Received: from mail-dm6nam10on2084.outbound.protection.outlook.com ([40.107.93.84]:15552
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231979AbhEWWjm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 May 2021 18:39:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C0zpKAJB+azVqtG7NhZyVH2Do+TrAckHJKLkBHI65/L39tPs3i8z3WC2a9U4BZbV/cEEIbPV5Co4pa866lssWsfawiuitYHhBwg0NgNkIoN3Mmaa6d+KBUnSP3nLUZG5MFq8UIacuWDHdZQY2hf30PdhA2WxFPGh+uB4Q25shPaMuuMXIU7oVjRQnkwf7AvdBIindCE9MnpVpOtShhxEUB59Ic4fP+Vu0ItTLfko0FUrB+rPwXYQNLejI0zpbILhZ4qssN6YfUO3VOh8f8RbX1dp/YiIcIjXubL+7cepompFxLtSHQqrbHRHULIdY03RwGNkHSjZCaB+pPMr+sFxeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hGjLrR1oU5RJAp81664VRQ3qIGr2BAEBIF7QTWtm9s4=;
 b=Anhhu8qe9TnE5wacbqyIMoBjYUDR4ePl58ykZkNy2AUILkBRqVg7kwnQ/ZeUKtwx0ptJLoBzGxvtnWc1IchWKWhRWgdOeFQ3nL3okQYPeOeIKCPV/AejNkK65a4fKmXMTMCxg50LegjP+3u6w72qP9y8k3BFTuSNWXSdPTnEdqsPDNIpM2TTWun50nJK76aSQwpWNCXV4rwaCqFC8/s5ZlzFBnO06Ja8KwWoUlEqI9U4CutipEjBDS3WK3hf294WsS7fX22W8vqGi8iUFT/vhJkfzhqHajdpbUDe0qa41LUuRFvX2rzApKTfZgw8KmA99e6mrZloytxMCxp9jk6TAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hGjLrR1oU5RJAp81664VRQ3qIGr2BAEBIF7QTWtm9s4=;
 b=J3HemywCys8quBLNr6vvZ5k+iZF1uzxrDixh2dkDWlVLubkq5sDNLPibItUPagTKLDGTrb7/YZXsmBXMqTPDrBTA3Wgex/I9Cv2hlCsN3QiLFcJaQntoKYl2Lpeu9MLtbZoxAerjQnFTxFcA30p63tATd+1nsvI3OVtvxY4Uvs1OOyBaLrkukGRsxaMZaasVNWh4T97AswIoU+Br/tRRYUDS8n25RgmwIaXkNa5RrRALno71gd+Wq1LFQbAzkwvXfhLQF6paYpw1UyNUvVjqMKByVMbunj5pLwvIDi6tSypQrvPiw7J4Y2CrJ9rM6f9OHISYmClF40N47ec50fzUqQ==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5318.namprd12.prod.outlook.com (2603:10b6:208:31d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Sun, 23 May
 2021 22:38:13 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 22:38:13 +0000
Date:   Sun, 23 May 2021 19:38:10 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dave Jiang <dave.jiang@intel.com>
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, megha.dey@intel.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 19/20] vfio: mdev: Add device request interface
Message-ID: <20210523223810.GE1002214@nvidia.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <162164286322.261970.2647654897518928545.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162164286322.261970.2647654897518928545.stgit@djiang5-desk3.ch.intel.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: YT1PR01CA0039.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::8) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YT1PR01CA0039.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2e::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27 via Frontend Transport; Sun, 23 May 2021 22:38:13 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lkwja-00DTik-VP; Sun, 23 May 2021 19:38:10 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff337c33-e647-466d-4aca-08d91e3b7316
X-MS-TrafficTypeDiagnostic: BL1PR12MB5318:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5318E78371A00A34B9C66669C2279@BL1PR12MB5318.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JnJ/IbLAm88Cw0cgWiSszGFcJK6Z79c0r4LcUAkMb4jpxODblGG54Fb/iSgIEzK8D0GeTuCzVWefuvwXi3jZkIn3Ly9uzYPSjUOQvk3aZpZzHHegx09YVJ91hNF/he3aC01vBUHykqTOXsECMsT8QjYy0POjPTHid5hlJyOPOa8K1rxweSx1QdvwREdtYAFFTHu6YC7s1xiTmD+fVKO60S/5H2s9I20nbIKNAsmZEsLVOqgw+qBBghDDDnVCEb1tmkf2TdJizvgKS73JZ2Y5yHdYZj60pjv8MpBP8dffH3LFp3svUCfvFSSiOcNtX96JvzjpF4KLi6ocamxlBKTQs8NTKO/VY4pBxDaVBh0RoEHOMmZUeSxwmRxluBVcIUgLbcqNxhtKsS/vKpbBoq1IQ4a8MRYptbcXpoiwDwL5Zwk/B1xSznMKbt9whK1AT/tQH21QuFKroTPiG1LUKX4vNJ1GZKahIwqqY6sP/UChltT688OU0xoKfI5RjO48By3z90tkPjTCWZhmd+zPkbiEioDTZseS1bpwfYG7ECG7tbqdXUWLBwrFNpvHoJwNldIXRLY3aHKCLtHdL2NERycgKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(366004)(396003)(136003)(346002)(478600001)(4326008)(2906002)(86362001)(7416002)(5660300002)(66476007)(66556008)(186003)(33656002)(316002)(66946007)(83380400001)(1076003)(38100700002)(2616005)(9786002)(8676002)(426003)(36756003)(9746002)(6916009)(8936002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?I6IQewYVbrvE7u1M2KuEUusypGO3HWGxvXtqSoJF0wp5epQ3MpOGBmQzh5Yh?=
 =?us-ascii?Q?qWs9pQYQ8MMs1Q/zgkMPa51B7Qz56s++nKKiVJuRVyW4rcBPV/tOUxseTMZk?=
 =?us-ascii?Q?lFeFUOVGrBfQdEB/pnZJ7WbPsI0T9D/8qlGX3eLk6ibYVv1ZjSCUi7QmEnyF?=
 =?us-ascii?Q?+4Wxyh+3qfPNLha8KV5f0BD6NRqgpn3iKRRw9gmdHHVMv0TsOeKLN7/fUi+h?=
 =?us-ascii?Q?+Xuai9kZ3G0F9XH76zENtAuH5kugzGdWycP/tY3FdB6Y6XJiPOodlJbDPdq7?=
 =?us-ascii?Q?qM5a8LN0SNlnPdWGsIhAXOfZeeaagdtGky8jxdBT+n3HFFMyikkXwewXEW7T?=
 =?us-ascii?Q?SyEbe4o+nndpD3z1WEGfb7OShzuo7e+Bx+vwV3EfACtp5lm8b3kd699Y09Ol?=
 =?us-ascii?Q?QiDqgqhTkO19yurTC5Cr9X4SZMi36++hdihfx/c9W+CwCfTMxdFQspE+P9jI?=
 =?us-ascii?Q?Ex6MHY5g8AEpcM5o2oBsBuOjXtV0y5PjXBXUBLkbnS/QnysQ0V0JVmWcBJWH?=
 =?us-ascii?Q?iddV6kfAw4RNSi9xXJ6+3/3+D5PFHKNHy2JWFnNS0ZyR6senKzsPnk+9IhZA?=
 =?us-ascii?Q?TsvdE846sblKIqDIIazZfJi0IwwAGvmSS4IxBw7egS+O95BcoIOzhgKUMCKJ?=
 =?us-ascii?Q?WMvA0ozu7PIMEFP/hIrC9XGnedCJbR4MvRh14Zp6Wwd05oSMFrmPIg5JLkhM?=
 =?us-ascii?Q?T3z4g5vU/MgZEzLWXKsn6NOkKx72WtSTObp277sfWDpqW61uhs409PCzL1mI?=
 =?us-ascii?Q?NfDFDpX44WOrc5KSAoqbeqhleJJlZc7PgP8VCE7S4FxZ66EvUnXlFB19pmUa?=
 =?us-ascii?Q?7GxW5JGFI9AdqQCz4qdD7AIfRowTkaYa1yBw61F8iAW6ZSggJqgfNB4+EMDI?=
 =?us-ascii?Q?2oT/YGWe1Toq0VnnCLyteeqkdxZN6d2ccFvduE+6lNTMXQbIWcRgSD6Eq6zl?=
 =?us-ascii?Q?NPZyXE6z72n6qxY+vpScVAan/1Mjo+n5tRrdIAl6/mQjbIYTCNSYtPr2gJvV?=
 =?us-ascii?Q?DKkF7yzkDf1C/HSOg0JecFRqjcVYZC0HtnwLZofkfMZdJ0d/b9hFlkgxAVs3?=
 =?us-ascii?Q?H6BOtIN+Mzv/QFRqx1R6qcVd6XSmXsJhjDctyqVH9xZuEbXHWfnbC62pO9MD?=
 =?us-ascii?Q?h/ioR8I7Y475k4cM1/qVwUMCNeGwcATYk+C+BJmabPWeyaeu2kPA2T20MqiF?=
 =?us-ascii?Q?TKQsDHtUHjGWgtJrNUnkXqVD/uFu3RNepnhuSbVjwnC1sv3/AzCocbRAklkB?=
 =?us-ascii?Q?eqouJbsau/8v7LTQ8H7KOG58Ho4prlL9S2HjBQeNEhJOEsmIfUJFdiGrvZav?=
 =?us-ascii?Q?hZC7Aq3zR3m5bKMk1f3r7woR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff337c33-e647-466d-4aca-08d91e3b7316
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 22:38:13.5347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PwQnlGxQw8o20QAerU6yuIO7qZYEhAWPFC5SwTl6+XTCU9+czsCJhrB96qXaiRlt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5318
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 21, 2021 at 05:21:03PM -0700, Dave Jiang wrote:
> Similar to commit 6140a8f56238 ("vfio-pci: Add device request interface").
> Add request interface for mdev to allow userspace to opt in to receive
> a device request notification, indicating that the device should be
> released.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/vfio/mdev/mdev_irqs.c |   23 +++++++++++++++++++++++
>  include/linux/mdev.h          |   15 +++++++++++++++
>  2 files changed, 38 insertions(+)

Please don't add new things to mdev, put the req_trigger in the vdcm_idxd
struct vfio_device class.

 
> diff --git a/drivers/vfio/mdev/mdev_irqs.c b/drivers/vfio/mdev/mdev_irqs.c
> index ed2d11a7c729..11b1f8df020c 100644
> --- a/drivers/vfio/mdev/mdev_irqs.c
> +++ b/drivers/vfio/mdev/mdev_irqs.c

and similarly this shouldn't be called mdev_irqs and the code in here
should have nothign to do with mdevs. Providing the special IRQ
emulation stuff is just generic vfio_device functionality with no
linkage to mdev.

> @@ -316,3 +316,26 @@ void mdev_irqs_free(struct mdev_device *mdev)
>  	memset(&mdev->mdev_irq, 0, sizeof(mdev->mdev_irq));
>  }
>  EXPORT_SYMBOL_GPL(mdev_irqs_free);
> +
> +void vfio_mdev_request(struct vfio_device *vdev, unsigned int count)
> +{
> +	struct device *dev = vdev->dev;
> +	struct mdev_device *mdev = to_mdev_device(dev);

Yuk, don't do stuff like that, if it needs a mdev then pass in a mdev.

Jason
