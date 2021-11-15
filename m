Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6731645159D
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 21:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352270AbhKOUoS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 15:44:18 -0500
Received: from mail-dm6nam11on2084.outbound.protection.outlook.com ([40.107.223.84]:44001
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347703AbhKOTmL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 14:42:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBgStXQs+hg5raCpp6UFyoLfao2b1rSGEQvdk7jL7DHH3YQKx2lCedSC16uJZDcaIn/T1ebpPR5b7/Wn9+QO+P3YvF+0Gna8TrQpglD2S6Y7xAmGJhTXWp75O4CmvR/2jngklvZLdYHuDAD5q2EbKWbArXtwU5KPO8A8MIARgCdNaw7IvfHc2bFPhKhJJWP/71NpKyfXgvHuSqp04R+qlY8fsmbL/B/zr9FhTOLUSs4MBtijqRXdJKaVfQczIC+/zHMmiCUeHOESixZmZXIdtPWjP8/M0c7AHL8y5mU5qux3vYm6Rfyyu9GiDOto2PymIZJtc3GW7OBcOpjHHCl7BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B8FTuhLUPmJHFaNk2K5EKK+jWVFEwqM6X0wnRUAxAh4=;
 b=h/lze092usChIm89MJ83ZiqvjQUk8uSNAhi3880wcDBvyPQjwSKyNjccSXr3bRzDSgJr6tuHeB3YCHLp/nP4/wUkyMkmo427Rek6gU3HYxPN1s7WiQWWlnqax5Fx1pbHmgBAG92r9eeTkCqnRXiZRslRuheDMUjpD2ewp3b/r+yCn6+fvDcnqhslDu2QlaS30qHoeB7Fgdjl0k97aqdFJnI8JkZdQrjkjPYHLw9jyD5wa3QUIOkBX03KZ+ZGB09sRouXHqVtwjPImX8XTLKaHHMp/lAiiAx8xOLuHMB5WyHMG+QH7Qa3z/tTEdD3B38WMhNVbjpgytwupVZjJxU78Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B8FTuhLUPmJHFaNk2K5EKK+jWVFEwqM6X0wnRUAxAh4=;
 b=iHx0zrTFwEQV+s7mBm9sZHnZO3g2Yf47bDZ/tjuW/1SJ4fM/3p2XxUBuO8zJojIKboLqZ6j+gDZeo2LqhqNf5FXeG31eKvSDUD+6jBJCN/0kqdS+fdcCdBQC3HFXMHr+wir/Z9rrLSkx9FlYQeSTPkXmXvprN/Ohr2RVC+6Ivd7z5/H2xz3IDRVq+kRgQb/As3kZGB+2twxo7TNqGamASlWVCyS8CEOFDSheh84/k7EGbzr+qEDo+Ha8pwVaC5hhJG3tO8RVxUBwwZSBFpVopuT/dG2QSZpIvEjcNk1dSHpha2sG08MlwJjN0hqMR03OBgpNSPC/vri86R+uxt3s0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5540.namprd12.prod.outlook.com (2603:10b6:208:1cb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Mon, 15 Nov
 2021 19:39:07 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 19:39:07 +0000
Date:   Mon, 15 Nov 2021 15:39:04 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        rafael@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will@kernel.org>,
        Diana Craciun <diana.craciun@oss.nxp.com>
Subject: Re: [PATCH 02/11] driver core: Set DMA ownership during driver
 bind/unbind
Message-ID: <20211115193904.GR2105516@nvidia.com>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-3-baolu.lu@linux.intel.com>
 <YZJeRomcJjDqDv9q@infradead.org>
 <20211115132442.GA2379906@nvidia.com>
 <8499f0ab-9701-2ca2-ac7a-842c36c54f8a@arm.com>
 <20211115155613.GA2388278@nvidia.com>
 <cc9878ae-df49-950c-f4f8-2e6ba545079b@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc9878ae-df49-950c-f4f8-2e6ba545079b@arm.com>
X-ClientProxiedBy: YT1PR01CA0056.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::25) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YT1PR01CA0056.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Mon, 15 Nov 2021 19:39:07 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mmhom-00AaRI-Ud; Mon, 15 Nov 2021 15:39:04 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca5fa9ed-71a4-448a-b0d6-08d9a86f9699
X-MS-TrafficTypeDiagnostic: BL0PR12MB5540:
X-Microsoft-Antispam-PRVS: <BL0PR12MB55400D886EA1167DA703946CC2989@BL0PR12MB5540.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OBFEyklosTAo7vGT2P/H1J+Vdb2fkgTpI1g3vQPnV241X1at0JsWHaGbA+gfuL52WcuxHcEtFCjRKKO7fD47LPnWMRhbXg2GCZyTvTSrEvdXmSHaCY+x6pTpUtDHqUl2dc+12EfB438EX0hvywYYMDsfdXbCo28fcdeHFQgrifa7L9DDt8FxXXT/RV9jxF+YN+00qw6c2qAVrpLJMzZYdpejpsQf+sE/qPRgV9xmGUpoNZcP6Akx04P5Na70KA/goGfebakqcFGPLeB84pPGQQLJ5b1Dq543Eowsx4k9ZqBhepXuAf9l2WR1tn/7BYYyb4Js0f9oYUPjnVBfyb0UnH9VeQ8esrB/iaGKqO8n2gkQomUeC9qNWOxrn4IWg6SzH8AlJbimaPvEMVhxYmZ1josE3c5fpEQL2DjZ/taNPbOVttLMFtCWYc2n7wvLJwo83LC5QgD5EPxYTNwaS7dAXN4OGvKG7kBGwoI1PSeglbs63aLDhxuBabwgkNs2//bvQiXZDV4gJddWgS1oEnReiSdqYzGSBbErBa/3LDzm4AO+cau/+4Ul+CFmceqHpM4rpafgKmXZvFw2VpH6HFvhrRmpaLf1ysldLbtnTL2TVxpAiTvz24DZ0FqBE7IkPDVo2MbtkYX5YQ7nFZ3OzbqNVGAQdmaOBIoA8pvXcezFHrPZqgCtD0nQTYT++H7rluE9+PAdtp/8fhkpTKYpelUxsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(6916009)(8676002)(33656002)(9786002)(508600001)(26005)(66946007)(1076003)(4326008)(186003)(2616005)(426003)(86362001)(7416002)(53546011)(316002)(66476007)(54906003)(66556008)(9746002)(8936002)(5660300002)(38100700002)(2906002)(4001150100001)(36756003)(357404004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I0STsbckh+CcCzdoSNy2pTxRkilOA3A54RegRn3z3SSifGq5Rb0a9yr2h4Nt?=
 =?us-ascii?Q?+ciNluIStZSEmhx9oQISXQMoEuobidPDB045ZxDsxhlk9cw9t+F89LrI6rtf?=
 =?us-ascii?Q?BOvo7/KZ9DHHEsTVWicAR1nyme/J04YrHjn5l/J9uIWzKSN6YmZVghaL0xOS?=
 =?us-ascii?Q?5/bRqeX8yjEnLcmrrGnhd59l5WiF96wT4AhwqL8mUMHm3V3++b4jwUXD8Jmu?=
 =?us-ascii?Q?R+dE+j2xgEaTAezHiWPa33eZIMPWSzZ4GPuFrJg6HT5PmVbsLOrGrR3+1EIy?=
 =?us-ascii?Q?GaTU9mD5bMWoN7W5AQS1KaVcnxyUnhnKGOOjqQd5JfwRZsrdlFUEe6E0tU35?=
 =?us-ascii?Q?erjYSm66vLvJl+RfdoQzKivgd6ztK6RKrQNIzYfMoROfz75W46VsmlgK8dgp?=
 =?us-ascii?Q?D0ybrg5dpAh2XJFu++lI9rKIvrvPBBbChJTjCqWEYLWGXlWTLye8nekUjFyV?=
 =?us-ascii?Q?st4pvGlrBDBcgo6nQ4OJ2WvrUCD/MvXRRsvLSjjO0ROS/ongiLju2L68dmqH?=
 =?us-ascii?Q?RdCltKj5kxMmid/xE1eI7+gIeGlC4R/pnSfjnRqqQXF8gOV+xagNbUikYsGc?=
 =?us-ascii?Q?sNw5oG4IWGbwwyLIycg4tJfeKskrGFnqNZIRaHZBlhYxOEANBAnMARqIbs8Z?=
 =?us-ascii?Q?YH5CRSRdV86yzSiDqLXbxXIOQthPL/E7oTeprPwJz+5xD2l1sJCsZeS40oIF?=
 =?us-ascii?Q?g+XT50D+mcz3m2l3uWCNAfTS0SOVoBc3CwQUiRRv+LG4nAk3ER4W8bSFGzg7?=
 =?us-ascii?Q?aglIz9TZZSdbsdWNmvm6cA6z/SGflWHu6Pmn1YpLNrnsL0w16m+o57BFCcUm?=
 =?us-ascii?Q?9tSlOmc5Wjge0jKzRertCE6AfHFhZNDnbjZjb0a4mrB5GWtLTvTZDCYPmyIR?=
 =?us-ascii?Q?Bjk3OXdkaKbR3Q4sKvN1k+HjqFvY6t0cVclxCNT9Z/6dO/ijna9YnRj4TQls?=
 =?us-ascii?Q?KtmrWst+k8I7LESzUjcjErbLdvoDHceH75v/NeaFJ3yQiAsRR9Cr3DQySK77?=
 =?us-ascii?Q?pWNP5Etpa884MTTVmPeQGmPw2W8MRxBG+fwTy+8TUQpVWy0tOHv1VG3DT7ZJ?=
 =?us-ascii?Q?GQZ1tWIzSLIhD0aNxsJHkw8a8TsThezaF7UczqhBq3tgl2S30YV6C4z5W9gb?=
 =?us-ascii?Q?tBdQQP5XMCxtfH9HYgxYhOW6y5yFzzPyS8iu53GlpTt3gs6mJ9AoW1hdLImD?=
 =?us-ascii?Q?2dF5m5jljJ1C3AALl3M7R1wpGXki1LnApNea6N6AKfnERv6Tctw64wPKpEGB?=
 =?us-ascii?Q?R3SxHA60W7+genaFJRmxYqAGYKbnxXiss/5tsHrmonfH8IeQoP4E2uE2eb3l?=
 =?us-ascii?Q?AQrneCTmtO7ik6TBW6/MkzwhLvNdDf4MuHvHL548Mb+COgNXzDcGc4u715s6?=
 =?us-ascii?Q?wTNzByEsFyTnUNEjTrntjbP4oI3CZ8WtPDnYxDNZJn5hzu9RzW/Cc4lSOiwi?=
 =?us-ascii?Q?0w3Sex1TEywQCq/j5CZfk7E8yTjlzw+yKZyJmyOMap7eAhNpEqXVRlmCyuDB?=
 =?us-ascii?Q?B/g/s8q20yfnsXCN6yxhJwHt7QAPEnJ7+c16Qxf6X886OhP3WIXj3aEpYZM1?=
 =?us-ascii?Q?PmefmwKd147ts4+HeOk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca5fa9ed-71a4-448a-b0d6-08d9a86f9699
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 19:39:07.2122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tTwpz3njiqjw6thj9xXo812HFX56IHU9ZXGmicHu3JvQvAcThJuX8Fxe7K8eK0ER
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5540
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021 at 06:35:37PM +0000, Robin Murphy wrote:
> On 2021-11-15 15:56, Jason Gunthorpe via iommu wrote:
> > On Mon, Nov 15, 2021 at 03:37:18PM +0000, Robin Murphy wrote:
> > 
> > > IOMMUs, and possibly even fewer of them support VFIO, so I'm in full
> > > agreement with Greg and Christoph that this absolutely warrants being scoped
> > > per-bus. I mean, we literally already have infrastructure to prevent drivers
> > > binding if the IOMMU/DMA configuration is broken or not ready yet; why would
> > > we want a totally different mechanism to prevent driver binding when the
> > > only difference is that that configuration *is* ready and working to the
> > > point that someone's already claimed it for other purposes?
> > 
> > I see, that does make sense
> > 
> > I see these implementations:
> > 
> > drivers/amba/bus.c:     .dma_configure  = platform_dma_configure,
> > drivers/base/platform.c:        .dma_configure  = platform_dma_configure,
> > drivers/bus/fsl-mc/fsl-mc-bus.c:        .dma_configure  = fsl_mc_dma_configure,
> > drivers/pci/pci-driver.c:       .dma_configure  = pci_dma_configure,
> > drivers/gpu/host1x/bus.c:       .dma_configure = host1x_dma_configure,
> > 
> > Other than host1x they all work with VFIO.
> > 
> > Also, there is no bus->dma_unconfigure() which would be needed to
> > restore the device as well.
> 
> Not if we reduce the notion of "ownership" down to "dev->iommu_group->domain
> != dev->iommu_group->default_domain", which I'm becoming increasingly
> convinced is all we actually need here.

The group will be on the default_domain regardless if a kernel driver
is bound or not, so the number of bound kernel drivers still needs to
be tracked and restored.

> > So, would you rather see duplicated code into the 4 drivers, and a new
> > bus op to 'unconfigure dma'
>
> The .dma_configure flow is unavoidably a bit boilerplatey already, so
> personally I'd go for having the implementations call back into a common
> check, similarly to their current flow. That also leaves room for the bus
> code to further refine the outcome based on what it might know, which I can
> particularly imagine for cleverer buses like fsl-mc and host1x which can
> have lots of inside knowledge about how their devices may interact.

bus specific variation does not fill me with confidence - there should
not be bus specific variation on security principles, especially when
the API is supporting VFIO and the like. 

How can we reason about that?

Jason
