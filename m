Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94DE3486F0B
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 01:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344398AbiAGAsa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 19:48:30 -0500
Received: from mail-co1nam11on2048.outbound.protection.outlook.com ([40.107.220.48]:57148
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343865AbiAGAs2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 19:48:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dcnObL3XDoiz54QihZ8/YKn9yI4IZA7sUQ3MZ9rhQ85LDkDg6ltu4FRFybAzYf45J32eqrbW2rZx0gpJPtYaCt4Edctu7hjwQqySL9BSd8pPQlycT5wN0N3FoTD4tlm7an7aKBEVH1YS9wrMzGZeQBqpGVMcvDm7eMMzTpvkSr74/6+PVB1dFMYKjQli4Xu5YEgCTOmg88bOWpgiKOwR7nbGNGdjRos+7E/WBiNU22whslfy/BW4f8SiY0tSieQbhqdoSIe7krqdF5mbZZUA69X1mHnp9wGsmp4y0r8FsuitHQSLbMj9UjkL5WCe+h1F+/R6WMbgoVNl0iM+eJmu+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U7Zo0oFWiU67oBUvM2a9TAC5dPweGhL4tajPyOOM5dQ=;
 b=Cq1gFymuF9PxL55O/UROtDaocJqMZaeGYZ2FeR/vLmle/s3Ab3vnlZJ69KqW+w6XxC1Gc9c1kxUy1bdKmq7v7dWYFbjbqtv7Rl0VwiWYqVrsu2nT4FhgXfNAIz5+xyrvyclHBYNIn+Rc29XKoIMJCjz35aOluz5bYFe4tr4OE7qv8+wfMODFQ2zJkqRyeYXjPBnYi9ti+EbIx0gt7HpyQP+wrCYvIodrokWaB47ACHbhFBFVGV4encrs9BFiAE9eKCrqktF5wOOPCFoxYt1ny2QKk6KeG/DC39rRwFvxurUBh69tFbsoXDOA+fHNGbvYKvYh2hGfjyXfeh5Pp5zdaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U7Zo0oFWiU67oBUvM2a9TAC5dPweGhL4tajPyOOM5dQ=;
 b=D8CncgIBMnmPC1vUG1Ev2K57QUbWSv7amYDJqVffXbHOfKvC+ALpkonVW5TJ+3dr9QqdvEvHOZDVm1BQtleV2Xoojz/J3CTLfxB7kSy+0RqlBmktq3IqIXtJYYbD20H4YLa5vr5cAP+pcXPm+2Uu6KRZWDBEXMlYMj90IODmW2txAH1UKtGrGVYReCzvyCS809aVyg4L14YbkQFh3JUhucVvH6mF54y7wr0icP/XJnMMaFtFZaTyU7apzTLoxlH0vRiJJqKC/D642g8TmcGDbFu50VVfqmkrZEhpdzrzPHNrVB5VccoxgF9pK/gs+8Oa9tK+od/rQ6QfhcFCWSt6hA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Fri, 7 Jan
 2022 00:48:26 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 00:48:26 +0000
Date:   Thu, 6 Jan 2022 20:48:25 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 6/8] gpu/host1x: Use iommu_attach/detach_device()
Message-ID: <20220107004825.GP2328285@nvidia.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-7-baolu.lu@linux.intel.com>
 <20220106153543.GD2328285@nvidia.com>
 <2befad17-05fe-3768-6fbb-67440a5befa3@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2befad17-05fe-3768-6fbb-67440a5befa3@linux.intel.com>
X-ClientProxiedBy: CH2PR19CA0006.namprd19.prod.outlook.com
 (2603:10b6:610:4d::16) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0db06e5-8d50-466d-c481-08d9d1776a28
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB50628F0084E41BED60FA4B42C24D9@BL1PR12MB5062.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M9+ieWSucidEe2uwHlErPN6cOVz4WcCG/60OepQ+jkrS1AQ0abKjy/RZmNShje3EZE+aXlSAmDjOeOCj7wjDXIsmkYuPRnKzGP+TVq9LVKrxi3Peb7Loc4k6P5IPZ0jDxnIUTSAX4FXRpMsjxyGxXj8NqZmxzCOHS8fFqmrOt3peVIBltZItzOT690e2ii4rDE9IUGp4vRGRH63mfVh/Io11VZITTIMjJskzu3xKAbLzMFvi7BdyutPvs92lRO02dVTPj6tvtWjC+k5/pW3Ea8B1V87/+Vjmi2ew/Ol8XeE9YLLOc1Vc+tIbeQMwq2n6LEGb0Er/hgpVRlgahyNIOJMffB/VILoTWYIJJzSCUWNC0JW2ybGrD6fjtAEitfqktwOb38H/+Ff7YEYdg1nugKwHLdB4W9AGEt5yF1l2GSwlTkzr42gdoWvu6TjawiV+H8nas4jKsczV23AseLC+VLODq6zJsCqgXrp6qh9w9mJ5xGsA7Qf/jRYJLQ2IKVrM7rc4P+fOkPEakkwhAuNry7j6pPDjJHK/sfGShTdI5oh7PNQB25Ea8ewwM86sd2CF3t5w/h+KVpMIcrKOpd66uQl+hnqJdvtdBqwRLeGtEpp4UZo5YjcH+gv1rw5mO7n3wl8pAxC1sM+Z0AqWpZw6fe6+mxynYD9G+6hluFGfZJeqt2rteav+6cn4F1NqdkpGR0SAze2S4O2wEG50nAiLfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(6486002)(6512007)(2616005)(86362001)(508600001)(66476007)(26005)(83380400001)(53546011)(4326008)(186003)(33656002)(66556008)(6506007)(1076003)(6916009)(8676002)(7416002)(38100700002)(5660300002)(66946007)(36756003)(54906003)(8936002)(2906002)(357404004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mEgAArPOLZR37MxcZgAfFo/0W0L/uX1JPXUaeqxob+xu42obubDbQWP3CCsf?=
 =?us-ascii?Q?76I6lcTnNDCGFTFkLfu5UYpp32QkEIJAKbILINNDD80zkokgm7MDB7guJY9e?=
 =?us-ascii?Q?k/SZNJUCU2NlLinc2oOU7rjS8HmNGOq21vXZjE172OR9Eekdtv9D0/9BgqQo?=
 =?us-ascii?Q?Jth8rszDfCM1JwRv0T+YU/YKr24dFMka2qEB6sRJcIO41fCuaqR3+hRq1mNS?=
 =?us-ascii?Q?8AbH34D48zeNZWF0te1VJaW6aGzJu+nsg6lPx/qMHjFBtvsEFa4YdCR0Wty1?=
 =?us-ascii?Q?9knX5ZK1ceW4oBFrljYzG0uaSQplaSj1ADWNgu3IPEc+1YRrGaTiDJhOEjne?=
 =?us-ascii?Q?Bs/zBXV0+iTN2FzXJ6dSBw6R7vVVzCcsVfww7JN9vxD/nPc6JYY1MjPIUiPh?=
 =?us-ascii?Q?6CGxfU9fpO1kocuRxvpuB9IcXE+2nYDl2PlSU+Y3Z5qVX3X4L04Lx19qmHCD?=
 =?us-ascii?Q?W2s0kjHRIkdAmuibQOe6SFKSwQb7T2s4jypKFrmCI0l5KKbihatTYIovP5sk?=
 =?us-ascii?Q?HjshdkxTH78D52uyOwDT9zNjdJphOQjq+qJjsyWFlgxSuGcoavOXsEcvc4fp?=
 =?us-ascii?Q?z7rvoDvQLTSUo0HfUe/5W5Xui5Qc3DZJmGhbLULlxG/VOlMAwEyPNkdcOS/3?=
 =?us-ascii?Q?gdsu1wPehA++mkFhjCBlAzakodNzHh2b4A/JHlaPl94KTXfjEoNxfcHT6e4J?=
 =?us-ascii?Q?8hnf4RRLOblU/y0V63oxdMcuzqJ+NKuOacyUTz89Id+TgyIZiXw8Nx0rkr8F?=
 =?us-ascii?Q?C+UmwlGK1d2e7abl7evcgTrQajSm1yFpbhVeO+pGtc2/1wALXvSCNLkKXAI5?=
 =?us-ascii?Q?NADJyXvX2TXczlDp4G3G4YfGm4PDKIoDMQKkcHSXs9hvdf6YWjON0H32gP74?=
 =?us-ascii?Q?GHsbXbGzE4lKf9DPfa/Qiaa2YEK7/XLiIESLj9p68Ddd6r6rE9vlmij1B2eu?=
 =?us-ascii?Q?n0ZpMpdFPwuQqi57azDAPCR7pw7/u+6+ugj0hu1p66AKgOlcnY7OKh9uWwpI?=
 =?us-ascii?Q?dmZ8l/z7ocBAuhFsPgFf8eh8CgvBM3xJsCCElJV+QpYDr1uLGCfvQI8EITnB?=
 =?us-ascii?Q?0SsKfzwX+YRdCHH1pL9MlxYF3edMMz3jSVobVhPzbz9v7ms4nXs2X4+rRGKl?=
 =?us-ascii?Q?sVlL22IKcMUeIMhRNBIWDz3W3VZm3mKEEDejLzn3Tz+zw7/4yBsjqxo4AyQS?=
 =?us-ascii?Q?FRSGQoWZt6KKicW2sHHA+j4GyLRxpauNrspoF6ZG8Ga2ksLoHf5YJ1yEZ2mq?=
 =?us-ascii?Q?5L82HUZdlh+TfVRzgmife7K8W2d22CgGi0gF/zch7gLeOJ4i+zOOSnTKjovU?=
 =?us-ascii?Q?AFdjXOKBFV67i9uYdV503Oi2pllhoDwI+WT8oBSad7it0Izj5HyEYXoAmZs8?=
 =?us-ascii?Q?zBIwewhe3AwYJkFploDfwuvE+Gb3w0BF+EkE+t2A+GK98OHyzLM6fsrlEqHH?=
 =?us-ascii?Q?4uoGGBJftGmWcAA2rSa8OECF60kqLMdfClSsZJmzspzorq3xNrgGRin7wlM2?=
 =?us-ascii?Q?ZvlMvbQczNSUHq6re/B+WNi6JC9NpA5uY96IZcoauluQ0itIzfF0Gdjpll3z?=
 =?us-ascii?Q?OF/WQnKEIXcR5Oh792A=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0db06e5-8d50-466d-c481-08d9d1776a28
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 00:48:26.4036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q8By8bQi5JZPsSGNl/sMrw7lrDpr3u4Clq74/hapl/2dsKFIa08be39wKBmZMIdk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 07, 2022 at 08:35:34AM +0800, Lu Baolu wrote:
> On 1/6/22 11:35 PM, Jason Gunthorpe wrote:
> > On Thu, Jan 06, 2022 at 10:20:51AM +0800, Lu Baolu wrote:
> > > Ordinary drivers should use iommu_attach/detach_device() for domain
> > > attaching and detaching.
> > > 
> > > Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> > >   drivers/gpu/host1x/dev.c | 4 ++--
> > >   1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
> > > index fbb6447b8659..6e08cb6202cc 100644
> > > +++ b/drivers/gpu/host1x/dev.c
> > > @@ -265,7 +265,7 @@ static struct iommu_domain *host1x_iommu_attach(struct host1x *host)
> > >   			goto put_cache;
> > >   		}
> > > -		err = iommu_attach_group(host->domain, host->group);
> > > +		err = iommu_attach_device(host->domain, host->dev);
> > >   		if (err) {
> > >   			if (err == -ENODEV)
> > >   				err = 0;
> > > @@ -335,7 +335,7 @@ static void host1x_iommu_exit(struct host1x *host)
> > >   {
> > >   	if (host->domain) {
> > >   		put_iova_domain(&host->iova);
> > > -		iommu_detach_group(host->domain, host->group);
> > > +		iommu_detach_device(host->domain, host->dev);
> > >   		iommu_domain_free(host->domain);
> > >   		host->domain = NULL;
> > 
> > Shouldn't this add the flag to tegra_host1x_driver ?
> 
> This is called for a single driver. The call trace looks like below:
> 
> static struct platform_driver tegra_host1x_driver = {
>         .driver = {
>                 .name = "tegra-host1x",
>                 .of_match_table = host1x_of_match,
>         },
>         .probe = host1x_probe,
>         .remove = host1x_remove,
> };
> 
> host1x_probe(dev)
> ->host1x_iommu_init(host)	//host is a wrapper of dev
>      iommu_domain_alloc(&platform_bus_type)
>      iommu_attach_group(domain, group);

The main question is if the iommu group is being shared with other
drivers, not the call chain for this function.

For tegra you have to go look in each entry of the of_match_table:

        { .compatible = "nvidia,tegra114-host1x", .data = &host1x02_info, },

And find the DTS block:

        host1x@50000000 {
                compatible = "nvidia,tegra114-host1x";
                reg = <0x50000000 0x00028000>;
                interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>, /* syncpt */
                             <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>; /* general */
                interrupt-names = "syncpt", "host1x";
                clocks = <&tegra_car TEGRA114_CLK_HOST1X>;
                clock-names = "host1x";
                resets = <&tegra_car 28>;
                reset-names = "host1x";
                iommus = <&mc TEGRA_SWGROUP_HC>;

Then check if any other devices in the DTS use the same 'iommus' which
is how the groups are setup.

I checked everything and it does look like this is a single device
group.

Jason
