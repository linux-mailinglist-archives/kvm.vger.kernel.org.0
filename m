Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 233747BFCF3
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 15:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbjJJNKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 09:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbjJJNKh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 09:10:37 -0400
Received: from outbound.mail.protection.outlook.com (mail-bn1nam02on2047.outbound.protection.outlook.com [40.107.212.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3DDA9
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 06:10:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OH13JPXSxkAgo87FQuIx9r0pFmrrQgaySfsNfpFDiDWgt0g7LaskNqMqgnhg+Xqfx8zqhJnY/7h1Z8HBKS4y06bdcujU7dFneCDeQ7D8D0mfyldrwO3lhhxd03Tl53fiqh+/A2mZi9nXfam8AHe1fWzuxRqvJ7oL34RY6PrupaDrOXjW4+3kJzPSuBflevszSterS71IxUpuxuCBZnznd1SK91cwEo5Nf1IKSPjnoUxhBgaOGYoFbmsZwTRrouTmNKqjC/Z/udndKROB7LW89tgTPO7bVlMKga01ynowK2EHsshirZXKJiPicYJtvY2nTMp8yPSBVhacTLQSuzVZkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mCTRYacsz9UwHuVtPR+slclQhXhTGGEzbKBks24qTEQ=;
 b=Z5Mjrdcm/9Sh6ushxofRB/WfLzGXL1x++gfJti0DvmEpP5un7vlaXhGhdqlUyg/N7dW3BBb5ED4mBaxNLMAWS+GiqZbGP46fQq5KAu044/X+lxl4Gz2mW8biYem0i62S29yl2HAmOPzFJhLf/jKiExNpXfsec8f23SXtgq+KQ6D0l8HNnxxIal8YWV8VVOTQLpM9uROY1JCPUDYkFKK94X0NSAA/NhUHg2ytEcOUhpYBh0C/IydeN2q2DegX88br8ssRYaK2GGp5jGI47SnRX8OBM2vD74cuklPRvpxwvDqsmkL8k3y3UtZlWGeDOALpgQPVKtaBg8O83Q5+pBvV9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mCTRYacsz9UwHuVtPR+slclQhXhTGGEzbKBks24qTEQ=;
 b=JOg3BCuG9gspK7WdqTtRtLKj6JdrftI4QNNcCHzdJkfg+e0h0ALRQi6ePGi0crRj9r/drOIQF4dOPiZPt0DJtgs/2csvl7Tqyv3p3MTdZW8OxEekrNan7FTz75zFrjkiXMe8xeG0T2WdcBbCI95Z4FjaPd8TSDu/lBWNKdkYCWM2Xj5BCWhc7yBJeoGFLWrJEGT6byZnCZzsb4xikCtQi0wE1EDWxPAJ9G4ywhD5GEV88/6qDPvxfXsOnSRxjbtxQzM4pJzeW/wRf2U7PVnhCVgCxvM7pMj6Iqu3uvMMOvvoDUXHFd4VNWZkW0oAV6A0un4EoXXmHsEghosG7q8Fdg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4903.namprd12.prod.outlook.com (2603:10b6:a03:1d6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Tue, 10 Oct
 2023 13:10:32 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.032; Tue, 10 Oct 2023
 13:10:32 +0000
Date:   Tue, 10 Oct 2023 10:10:31 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20231010131031.GJ3952@nvidia.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-11-yishaih@nvidia.com>
 <20230922055336-mutt-send-email-mst@kernel.org>
 <c3724e2f-7938-abf7-6aea-02bfb3881151@nvidia.com>
 <20230926072538-mutt-send-email-mst@kernel.org>
 <ZRpjClKM5mwY2NI0@infradead.org>
 <20231002151320.GA650762@nvidia.com>
 <ZR54shUxqgfIjg/p@infradead.org>
 <20231005111004.GK682044@nvidia.com>
 <ZSAG9cedvh+B0c0E@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZSAG9cedvh+B0c0E@infradead.org>
X-ClientProxiedBy: BL0PR02CA0031.namprd02.prod.outlook.com
 (2603:10b6:207:3c::44) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4903:EE_
X-MS-Office365-Filtering-Correlation-Id: c6fe4a8a-c781-49c2-e7c5-08dbc9924850
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n0EKEREPzMLdYu30LnTofr+fdZ1kOYO/jAhhLjePgcdmiFcsUDzvSORyozdWghqQ3NTnOEVCJIE72AzODda1hWG6ZeEQsgv/F43cLMvYFZXEPH6R/dnpL+SDIDBWIpSXaPwiRefZud4z7rYnpPIeXrYy2hnDGThaqreZl/OGN5HrLRgkXBZcNRUFjoPRG/pnxmePSQoNBM1yRMX3HfvoN7anc4e5WmShpTNKDmR25vnOKNpeR0fg5AOnfjZp2/5WoqXd4OCPGp2iessZPmFswZQjJZQ2JQCeiBgKIod+cASQ1ojC2WY2H1CkQpFzi2CKausFy7rh+KAfHjYZitQyVFftzOgQaQlTO3UqMZ3my685WBeYIEojb1MZiAhGf/8PcK3QKsladP7DJjLpd/DcTFWWo3/a4cUNRCI698FeT9IgUQlFoi9RmNfP2YCawfHE6TF9MkB0sCnqem5++VtCfGAqmji0I9NmouLMyo70ea1hxeE5pZvSso4vnxwL6hsR3Mk47/9wxYQ5JLCGeNtUh3Ymyxpa6U+qEVvIbTex3UCw4DvZfZZWS0JnmLV5Q40X
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(376002)(366004)(396003)(39860400002)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(66899024)(107886003)(1076003)(6512007)(33656002)(36756003)(86362001)(38100700002)(26005)(2906002)(83380400001)(2616005)(6506007)(478600001)(6486002)(4326008)(6916009)(8936002)(8676002)(41300700001)(316002)(5660300002)(54906003)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bbxMMLDt3OEA/U4JUKQxY2q+MOBbuyJcwr7tqg1bsqmxWSbCu5bseAX2HJbE?=
 =?us-ascii?Q?HOHtOu5vCJsPg91M0EUCM9ucCR18x4AjmcC6WLK5z0iFY+TVNF3gh1SC+omO?=
 =?us-ascii?Q?NiD+K6VQzgOwIZlkR4qkrdqpCYl0e0IWvgmTcDFfU+t6xfKfcdxUAJKDxHTw?=
 =?us-ascii?Q?eqdJVfw8qp+DSNQChnQTLKFr12YwteaOhR1dCzQjTUdjUt2V37r9lQYKQby1?=
 =?us-ascii?Q?kJHel7mm5pg8xn7jKuWOXT4VGpig4SeZfxTcZwsurOBVwYvFcF5t7GEiTIeS?=
 =?us-ascii?Q?yZkCjdyqtkgieFmuIAGcVfdUXwVrOaztjDf2qvFeeZcALSN16pvWLTU2a0Ll?=
 =?us-ascii?Q?DHqB9fJbmZiXKg+KdWBvBBDfIc7Y95jxYTt9EKXjrXNrM/5YITKL7pj4Xk0U?=
 =?us-ascii?Q?oAxMmnhQuFqlLMZ2J7USzz/ui0HZ8S0utvHgAXcn4s9ADl58YlbZPLUOJPXF?=
 =?us-ascii?Q?46330sUYaylxoEuqL/vlNihiO+qY3z1OQvDccj24IPz2SIVumtiXBJp1F9Wd?=
 =?us-ascii?Q?0W80hWcg6zujzGmQD1sRLiOlBu6X9JUolcBUIeD/wz8dplWYXTitm/K5nVbI?=
 =?us-ascii?Q?2AEj8Q24zbQCBvlzKZuWGDVUA+r5SuG7Rbtr6jFVaMWEBx7fRH+LdHLQx6WG?=
 =?us-ascii?Q?KmrYPeFAzsELyBx/xhZsMPo6CA/HRo+gJY0jOZgRCcp2HZXzZERmw4SaBhej?=
 =?us-ascii?Q?f+VC9HjLeHjRn54X7qV7/sHBgQW248y0l1wmgmvMw+8pvOqpegOfsRwZNbeI?=
 =?us-ascii?Q?1XFDolf8qjVaZAYAE506XUnyF+Xw+NiPFiuM8we46SW2rtE9w8KV9LtiJ98F?=
 =?us-ascii?Q?B4+ra4UIClRI2/fTeojg62q1Wt/HZb3kluc11t+Vj3M+jI3cU2qiFfw+ts7A?=
 =?us-ascii?Q?r0XE/hTL31AblI/PRUdIi6lejQeBUnRoFsm5cA5KHsYd3jKk3/gYoy0wTqbj?=
 =?us-ascii?Q?6hBP6CdhopeNGIX4EIlWfxgPp6aWh8NUYoI1uTzk+XcjILAmrrw6XsD6Hczg?=
 =?us-ascii?Q?6tqP7RCEIbOJ8BojEsWVvIFh7aVol8t+518wQRRcJjrUK47+ay0BrqM5yhJ5?=
 =?us-ascii?Q?ySIN/18qn0qJkQX3MU4C2Szu6qSGLy7JRJ6m/ko1hP39x9KWt2hBhjqVztNZ?=
 =?us-ascii?Q?iNKRc5HGDemWU9IxgKWAALPLk8U+N/tTE5FFISvDLnCJVgGBtzOeqC69aCb3?=
 =?us-ascii?Q?ZiOkxFNd3pNSaKLHjKQimfdVqOOEoKsUh/knSrw/FjpyWY6dzOZetyg0bjeS?=
 =?us-ascii?Q?0e0aZ9ohfMAuLEMOPsAJWblSl52BdAYq5Ywg5X3ZCL2kA2SLpiJeMsspJWVB?=
 =?us-ascii?Q?n4xYjRlmCoJuM5IcTYWuczIN08g/Yhp+Im1MtsU3ypavJ/AtbWKLsTUVe7zw?=
 =?us-ascii?Q?xA6cVOkxktf5HyGAMNi0WzGD1d+ooV2XhsDwpzie0W+ZX7kMCALWpYoxtCQ7?=
 =?us-ascii?Q?JBMz/4HLskHp+SBy/U/dFnQMgGg0hmMbX2hlzOmuBp8nsFo9cLO4CrzK7nyp?=
 =?us-ascii?Q?F7NZ6MBMdzk2xbt5XAFdl87IWgpbY0xBpFuQxRwY4jVBzO1hsEfuU0UOezT0?=
 =?us-ascii?Q?vyf2lOWhphTwXXk5cirxsTCLfB6IyA+D8O6pzTb9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6fe4a8a-c781-49c2-e7c5-08dbc9924850
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 13:10:32.1035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EzKNg1kUersB50M4H0dEfdA3PUFQ0YZnZ4GfqRIacrK8LpD1L4YlGAMj/k2BQcvB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4903
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_NONE,T_SPF_HELO_TEMPERROR,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 06, 2023 at 06:09:09AM -0700, Christoph Hellwig wrote:
> On Thu, Oct 05, 2023 at 08:10:04AM -0300, Jason Gunthorpe wrote:
> > > But for all the augmented vfio use cases it doesn't, for them the
> > > augmented vfio functionality is an integral part of the core driver.
> > > That is true for nvme, virtio and I'd argue mlx5 as well.
> > 
> > I don't agree with this. I see the extra functionality as being an
> > integral part of the VF and VFIO. The PF driver is only providing a
> > proxied communication channel.
> > 
> > It is a limitation of PCI that the PF must act as a proxy.
> 
> For anything live migration it very fundamentally is not, as a function
> that is visible to a guest by definition can't drive the migration
> itself.  That isn't really a limitation in PCI, but follows form the
> fact that something else must control a live migration that is
> transparent to the guest.

We've talked around ideas like allowing the VF config space to do some
of the work. For simple devices we could get away with 1 VF config
space register. (VF config space is owned by the hypervisor, not the
guest)

Devices that need DMA as part of their migration could be imagined to
co-opt a VF PASID or something. eg using ENQCMD.

SIOVr2 is discussing more a flexible RID mapping - there is a possible
route where a "VF" could actually have two RIDs, a hypervisor RID and a
guest RID.

It really is PCI limitations that force this design of making a PF
driver do dual duty as a fully functionally normal device and act as a
communication channel proxy to make a back channel into a SRIOV VF.

My view has always been that the VFIO live migration operations are
executed logically within the VF as they only effect the VF.

So we have a logical design seperation where VFIO world owns the
commands and the PF driver supplies the communication channel. This
works well for devices that already have a robust RPC interface to
their device FW.

> > ?? We must bind something to the VF's pci_driver, what do you imagine
> > that is?
> 
> The driver that knows this hardware.  In this case the virtio subsystem,
> in case of nvme the nvme driver, and in case of mlx5 the mlx5 driver.

But those are drivers operating the HW to create kernel devices. Here
we need a VFIO device. They can't co-exist, if you switch mlx5 from
normal to vfio you have to tear down the entire normal driver.

> > > E.g. for this case there should be no new vfio-virtio device, but
> > > instead you should be able to switch the virtio device to an
> > > fake-legacy vfio mode.
> > 
> > Are you aruging about how we reach to vfio_register_XX() and what
> > directory the file lives?
> 
> No.  That layout logically follows from what codebase the functionality
> is part of, though.

I don't understand what we are talking about really. Where do you
imagine the vfio_register_XX() goes?

> > I don't know what "fake-legacy" even means, VFIO is not legacy.
> 
> The driver we're talking about in this thread fakes up a virtio_pci
> legacy devie to the guest on top of a "modern" virtio_pci device.

I'm not sure I'd use the word fake, inb/outb are always trapped
operations in VMs. If the device provided a real IO BAR then VFIO
common code would trap and relay inb/outb to the device.

All this is doing is changing the inb/outb relay from using a physical
IO BAR to a DMA command ring.

The motivation is simply because normal IO BAR space is incredibly
limited and you can't get enough SRIOV functions when using it.

> > There is alot of code in VFIO and the VMM side to take a VF and turn
> > it into a vPCI function. You can't just trivially duplicate VFIO in a
> > dozen drivers without creating a giant mess.
> 
> I do not advocate for duplicating it.  But the code that calls this
> functionality belongs into the driver that deals with the compound
> device that we're doing this work for.

On one hand, I don't really care - we can put the code where people
like.

However - the Intel GPU VFIO driver is such a bad experiance I don't
want to encourage people to make VFIO drivers, or code that is only
used by VFIO drivers, that are not under drivers/vfio review.

> > Further, userspace wants consistent ways to operate this stuff. If we
> > need a dozen ways to activate VFIO for every kind of driver that is
> > not a positive direction.
> 
> We don't need a dozen ways.  We just need a single attribute on the
> pci (or $OTHERBUS) devide that switches it to vfio mode.

Well, we sort of do these days, it is just a convoluted bind thing.

Realistically switching modes requires unprobing the entire normal VF
driver. Having this be linked to the driver core probe/unprobe flows
is a good code reuse thing, IMHO.

We already spent alot of effort making this quite general from the
userspace perspective. Nobody yet came up with an idea to avoid the
ugly unbind/bind flow.

Be aware, there is a significant performance concern here. If you want
to create 1000 VFIO devices (this is a real thing), we *can't* probe a
normal driver first, it is too slow. We need a path that goes directly
from creating the RIDs to turning those RIDs into VFIO.

mlx5 takes *seconds* to complete its normal probe. We must avoid this.

Looking a few years into the future, with SIOVr1/2, the flow I want to
target is some uAPI commands:
  'create a PCI RID with params XYZ and attach a normal/VFIO/etc driver'
  'destroy a PCI RID'

We need to get away from this scheme of SRIOV where you bulk create a
bunch of empty VFs at one time and then have to somehow provision
them.

Jason
