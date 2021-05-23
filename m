Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7383638DE2D
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 01:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbhEWXvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 May 2021 19:51:54 -0400
Received: from mail-bn8nam12on2072.outbound.protection.outlook.com ([40.107.237.72]:28832
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232021AbhEWXvy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 May 2021 19:51:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fbHEPBzMxxHq1Q5srzdG1TxjqpU/7D/l4hgo5TnPx7+hJyb49Owr8oCHZ63fzC8+P6VWtDWiT273+tdEKRlH4daklTWVOP1LzHiHm/TyMgHeRIFBVe15wCjDb9WBkhauGhUmS868dPD/zIOMowrQBPId/KB1ZDONWmnAgtCaWe2IBS7ErNCQRi/j+KtgUf/H3FzG8n9n4+NwqsdQccaZgEVe/okUDRNl2Ol/jaT1cooCONJnPQRcrxd74N8hDN8YJ/iaDWoAfHWjVHSLBJ2Ff2KvQqqv88yPbYGOQA4zLMvm+Uq0thsCwXtQ5orwwAuri1rPngl6vYXlXFLY4fUO9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OizVID9a2GgPqO+Nuh1jEJa0shpthBBczexqGXWdaaw=;
 b=Xij4ut4ueXn+kHBz7abhjaLKtq0KbBrqZoQhOBJEslThAZ9YBfTym1TSc7oh716Qzo5GRPM+RtH4JikjFE1Zw2yfZ8nmwlLsC4U0Xxn8SfYGVQa7u8v+xlP4aDy8zzGHWFd/MJt8EtbvW7JBQq9gbgSCajzhhIkWKXue2dZ/Tp/iEMG4bp6K8CmMNXS13XZIRlIXJQjlPvJhmxCEyW6lKDvoB+pFrGT8I+85CoTgpPpg9iOHeaaFvlGLjdhp5uhZY5kt9dD0JUVhHAn0vLrIM7LXlhx878JZ4yYuL+bhOnIdXT6KVPy+i+7lEkjbU5Dwy5JySYAWbYoCOapSh+fg7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OizVID9a2GgPqO+Nuh1jEJa0shpthBBczexqGXWdaaw=;
 b=SUrwO+X7RYJlrK8AB8Mz3/g8MLMeD8Ti4bDJZJBHvAV9XIISo5dKycZ+Iq8j5tMNivtIxoDYra0BfxfKRrb1O3s5ifkHz/8DTNyRQyMmJlz4UzXGBJA1IsfYODzsqCRFC7HWT9aqIDD203GzWlr0JQlJC8jq53aJ4y44Fe7MCsU0ZSPnUFspzILIP8Gcmr3VPgRFDhfGRkz3iTRi8RfTUAI6UTopu+VdRYD5FzDkd9UCjIMyjIfb7e74hn0zV67w3p6PR+tLL2wVr8NxM+D93aBCQug1LJurGxfPCkQ7v6cK+bG+NF5VtSj4wdCs0StgKlO5gmvzitcVzpB+/5ZY2Q==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (52.135.46.150) by
 BL1PR12MB5063.namprd12.prod.outlook.com (13.101.96.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.23; Sun, 23 May 2021 23:50:25 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 23:50:25 +0000
Date:   Sun, 23 May 2021 20:50:23 -0300
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
Subject: Re: [PATCH v6 15/20] vfio/mdev: idxd: ims domain setup for the vdcm
Message-ID: <20210523235023.GL1002214@nvidia.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <162164283796.261970.11020270418798826121.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162164283796.261970.11020270418798826121.stgit@djiang5-desk3.ch.intel.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: YTBPR01CA0027.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:14::40) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YTBPR01CA0027.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:14::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27 via Frontend Transport; Sun, 23 May 2021 23:50:25 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lkxrT-00DV1j-OZ; Sun, 23 May 2021 20:50:23 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a3386bf-6e3d-4c10-9615-08d91e45895c
X-MS-TrafficTypeDiagnostic: BL1PR12MB5063:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB506352A59258254EE1D43C44C2279@BL1PR12MB5063.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:196;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ph+bLuJYHw9geYEFta/nHRDhnt7kU4WHmYSpwxvouwcfi9i0rKDz2sURBzXvpfXKiwYnWq8p5RoNsb+dl+kE1xrVPNlUQ8fqLkSGlMm0+6UMiYImQya8phUFw/1Z8UHWKcv/e4QJRX2+h6qy9BDvk920kF2mPMNUQlrmYjOTOV5at3TRTF+nAg/c+1Xh39gvgRXMMU7IJnv7LY3YutuMRSQbsul5PNRm/PiRQrAB/8S/z71R/lon9l9TkzOblE4tHw5/nggyvqMbjEZ/SZGl7rm+w1xAbGDuGqVsce6b0B7GiBSXzGDOcBcVUGVeye7EicrHy9vVzE+Vmiuw40L/PM0WlPuRhLDaP2CCyhfauA8xZAOb+P08050r3BJC8z7OQgE/7zaEyfyoy/JNphOzhrTWVGTCILF48HrO6p4VbDL8xQClJqbKo5E/x6jxskTbyVUfp95/5oU7/VWmnz3XBMJeaeP8qipfxCel9E9FEegOxhwBHr3IsGKeqqhCNW6IaFtwpIkhVLqJZCeyFKpsAsktwnmcjpSjcJ9tXDJuGLb8Jrr2YIFVYPiUEekwEBhQuXfIoNVp+xd14MYdgU5bMKLiWSrRBbfi0mcEitv53BI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(33656002)(86362001)(2616005)(38100700002)(426003)(8936002)(2906002)(186003)(4326008)(9746002)(9786002)(316002)(6916009)(478600001)(66556008)(66476007)(8676002)(26005)(7416002)(5660300002)(66946007)(83380400001)(1076003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?KQObtdSaL93AZaqvQPEsF5Vc9PwCAlSoGaExy1b1Tqs4sJUowFoust4Px4xM?=
 =?us-ascii?Q?a6IBCwQm6uWva4gXlkvLvvlorKijHQ/9fZhQjoQ2dNns+TQqtTGMrrmQY9z6?=
 =?us-ascii?Q?gWdIR3E+krfuqmlOrxIkDWUhweVH778Owd+1POhlHDM7kG8DcRdaqS3ZOUOa?=
 =?us-ascii?Q?TU14/Hvy2hV3yzXxKoppXBilEiLzYteeHO61xHw+uRnLrm9oMaGtn6rQWzca?=
 =?us-ascii?Q?lKx//pi/ZBWrYJUJY0RljN6EC/l5fJHyBErAKHGd3095eeF5EdkqtPtgiZUs?=
 =?us-ascii?Q?P236l0JpW11/RZ/HiEu8O6F3+7EFEpCH5dBjXIvEEIuYkyIFiTeSphO2yVV3?=
 =?us-ascii?Q?2P31m+5GhNRQIZxgZB1hkhOctoAAokB6R7Ka3BYR5cTZuY/BeE2vCkZjDc2z?=
 =?us-ascii?Q?Z4sg/4xcsM9jWlkb7h80T8SQJjiTXskCANLAPdQznW+dcA3BJ6utod5N5gyu?=
 =?us-ascii?Q?Qyh47KVlzrrR97qY8MicOTGACnS9bBtvUQF5q7JKEfSUj8P2OWy5c74hLEGz?=
 =?us-ascii?Q?tLUczPdw+EqqMs6Uyd65yWcNI4Lz06+SsPZZ3c5ChjfunUIn1L9el/v05Tdq?=
 =?us-ascii?Q?SpqRMxDhDK6Na323sXuvC9IpTrhirqjeCY1JuLFC1N1AP/uBTmcuYJB2saM2?=
 =?us-ascii?Q?Q8zHNnM+MbDZRY1/xpDZqjuC0slFK8CbBpHDwn8skdr2jhhrUgjaOH9+S1kZ?=
 =?us-ascii?Q?JwMA2Abr1D8LF9QLZptK04+fC1Sv10RXKsiLBzzyaqmYlcOWs+S9S8DVBZMP?=
 =?us-ascii?Q?guGmf4NXEMGK9xEt95EUYDfVHf0lG7dqSGfie5Hg5yUtzcxiAPbocYt7Hvs6?=
 =?us-ascii?Q?ptKTJEN9JPY7HUUV9Wx0Jft8LcMLIOAaWcgHn6S6zaAdEzyqGiAaIr6EwK6N?=
 =?us-ascii?Q?ohAPapSytNS0iH+phAYcnpCW4Rko9a15/C1OohqWiUL9wvpABn62fIDsroak?=
 =?us-ascii?Q?hFLkWB6IwAb8rlIKnjfxGDtz3zqrAcYwAzh/6pVjDW8pX1WdkTTKBok8V+0s?=
 =?us-ascii?Q?tF6Zm4ViLwkprpIqO8OSsUja/8aKpEZ6bn5A9Sx5SIlL8QfqMs9VZjtfJY8K?=
 =?us-ascii?Q?Y8vsBx24A1BUZ/bIZe+BeEf970kDe/ZpRQ83axMwSYgycBegvUjHAtXeHomC?=
 =?us-ascii?Q?QacS8LXRQZA7ZfCauWBwcunKF9qTT7NlOMkYHYw5OvZ1Rs8xFliJFJoK5LKu?=
 =?us-ascii?Q?OWBEJ5l39TvuJzAIM19hthRU+zqq+TBm4+ja/5DOAgfxUdbexEbbZV3Zt1lb?=
 =?us-ascii?Q?3zZIKh44KHdydbvCa23xZJ2ZTzvWjbt/5JoTx/KF16yJsJpdHWrTa+sRt0X6?=
 =?us-ascii?Q?3x46NQ9dDGU4IykRv4epuBFp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a3386bf-6e3d-4c10-9615-08d91e45895c
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 23:50:25.7182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MiZqSr+nICfnwR30r+WLMtKq1xq+A+uwaf1XchGcJOnqVLjr2RHqfpKc7HLWbO1r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 21, 2021 at 05:20:37PM -0700, Dave Jiang wrote:
> @@ -77,8 +80,18 @@ int idxd_mdev_host_init(struct idxd_device *idxd, struct mdev_driver *drv)
>  		return rc;
>  	}
>  
> +	ims_info.max_slots = idxd->ims_size;
> +	ims_info.slots = idxd->reg_base + idxd->ims_offset;
> +	idxd->ims_domain = pci_ims_array_create_msi_irq_domain(idxd->pdev, &ims_info);
> +	if (!idxd->ims_domain) {
> +		dev_warn(dev, "Fail to acquire IMS domain\n");
> +		iommu_dev_disable_feature(dev, IOMMU_DEV_FEAT_AUX);
> +		return -ENODEV;
> +	}

I'm quite surprised that every mdev doesn't create its own ims_domain
in its probe function.

This places a global total limit on the # of vectors which makes me
ask what was the point of using IMS in the first place ?

The entire idea for IMS was to make the whole allocation system fully
dynamic based on demand.

>  	rc = mdev_register_device(dev, drv);
>  	if (rc < 0) {
> +		irq_domain_remove(idxd->ims_domain);
>  		iommu_dev_disable_feature(dev, IOMMU_DEV_FEAT_AUX);
>  		return rc;
>  	}

This really wants a goto error unwind

Jason
