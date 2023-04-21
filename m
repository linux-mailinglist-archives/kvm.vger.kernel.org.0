Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04336EB143
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 19:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjDUR6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 13:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjDUR6G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 13:58:06 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D800E7C
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 10:58:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dGPDkCX9MyStpDscznW+sy49jyOeNHaKIqUi7EGAW/EJbEm2hRr9Sc70BySRfw5YQqgILIB8rEFZNTGOLdK3u+txdTMOaaVtRzR/TIrasYu9GbgxOhtZS/1yfM9Nqn6Pjy8PLG4BUu3VSK3Yj5V96oh5jgMifWK4RPfhlcsNqeukSTjArjlIYdMUSSFrNoNAU3DbxVpxXlauIAlyWf5j7TBYaQGD2nmzwqDddnV+b3kREbTTn4cvNcJQgG/q+T+blHxcD0E7qeVK1Tk9SdymRpg/IfL4crfxWdJ7jQ1DbH2I/UYHQN+oxb2z12MjmzK+KkrT/bMrzBFyjjy0jrAg3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YoCrO3lAY+t8V7kdDsuC29/G3oAH8jLebAz5a6Q9NLU=;
 b=ZGCIxfeH9kMHp6nIJlRDkqRjwoQ7Qd8bCdshxpBh4xTiFjmUsERhvSzbhy/xxqK6yeGQ2FBwDzENToR/mWowfYn9CM0lhzC7Ohe4qqURY8hFzu3fW/YiUZtUbcqtIpGIE5hc1HUbZ4lfYkA87YNVQOub3kqyhkCXMlh5b4QMTsXZtFB36RHwrABHOoHWSCaTSYm8Tv7sYyPBJBeZwTTKQxHp5AaOG84z5h3D/zZkr/cpguPMVFxl76e4aaaS5nqbVT92vYFS+o+uyKJ8RSibEnZXVVskMmzHIHN5l+UjJ5PdEnIahywMmrUFc1vJDc9PZmmhgUjAX0EKYsYhYWgMgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YoCrO3lAY+t8V7kdDsuC29/G3oAH8jLebAz5a6Q9NLU=;
 b=FD2NuV9zTA/abC6hD9zv4QiaLxCkUFu3M1w3kvY+qkSHVgUu8Hz7LJIl3HC17gFoHVuyMnK0ArKJR6QCV4yAMbFlxUOSF0IbxhX8qfy3hzPrJhlSfUbVjI2AWLfuqyDMgvhk4C463tVRP5YJjhQe8SprUH+MprTB3GR8Idp0/3WsaJKGUJSnvyoBbAraL1l/zVjQ/NSEr/O+IyGmqxlOVnqah9vqYHiHMhbp6vymsRDvChANnwo5B4ITje8CAoGmbtJxRgQj7k3Pxdl+GYlNcbPpL5IFOpY+uXj8dghhY8Il2IBiNa7WfNFpjteZ3zJGC9N1ZyrQ2DFTbdQDPWbuJw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5246.namprd12.prod.outlook.com (2603:10b6:5:399::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 17:58:02 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6319.020; Fri, 21 Apr 2023
 17:58:02 +0000
Date:   Fri, 21 Apr 2023 14:58:01 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: Re: RMRR device on non-Intel platform
Message-ID: <ZELOqZliiwbG6l5K@nvidia.com>
References: <BN9PR11MB5276E84229B5BD952D78E9598C639@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230420081539.6bf301ad.alex.williamson@redhat.com>
 <6cce1c5d-ab50-41c4-6e62-661bc369d860@arm.com>
 <20230420084906.2e4cce42.alex.williamson@redhat.com>
 <fd324213-8d77-cb67-1c52-01cd0997a92c@arm.com>
 <20230420154933.1a79de4e.alex.williamson@redhat.com>
 <ZEJ73s/2M4Rd5r/X@nvidia.com>
 <0aa4a107-57d0-6e5b-46e5-86dbe5b3087f@arm.com>
 <ZEKFdJ6yXoyFiHY+@nvidia.com>
 <fe7e20e5-9729-248d-ee03-c8b444a1b7c0@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe7e20e5-9729-248d-ee03-c8b444a1b7c0@arm.com>
X-ClientProxiedBy: MN2PR20CA0065.namprd20.prod.outlook.com
 (2603:10b6:208:235::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5246:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f7e753c-cbf4-4c59-38d3-08db4291f337
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mgMwIybTlJABzfzl3d+hzS1ZfGdgXi31g4MBvWllmNdVhYlsjIbkhFX5xql49iRAYB5A7ZwN//TnrNcWA1smk4QYKQh8T7yLYlOvYe/LZUQW5NgI4Kr8r/Yn0hZQDl9Gr2hbVD/5H0D8IrOccTRhd/btDQCpMBRhOO04FMufby264y8m2e04CcgwO3z8QN2JfgnwBcII1FlEjw8exVeOblp09Xm/nc+kqaQpQxDgSN8D/w39b9ryBUHqv2CG/aJnz3gtEXKN6iKxYsaC//QkSIdd/1/bEDF0tbU+bE39VviKweylDDwkbazMZIuh6KHb8uvyERg+GusQN9cKiYuyWtlUCUgbTSri2HHnhIzeLnE58dzPHE7khiPZZoJGa4chi+c3OH+30bQxroiFb4e1MeVuhLF73LFYKgOcrVS/kguyR3EtQcYYreGnC2rzuPZkmenR4HBkyDak2nZSxdxoYDodTchO/uylfCbyHIiwNCBN2bkYqEjyCLC/DrLkZ7sfqEM2khzFWxqDUbk1Am405O1ztw9xoQxuTzVTWRQs4xM997t1ySAXvGqewujTG7rR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(451199021)(110136005)(2616005)(6512007)(26005)(6506007)(36756003)(83380400001)(478600001)(54906003)(6486002)(86362001)(66556008)(6636002)(316002)(66946007)(66476007)(38100700002)(4326008)(66899021)(41300700001)(8936002)(8676002)(186003)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XoXHV/g+Kmc/ZT2J8hBIsDmKk04ZZi5HtdGWhnfTZQiYkjZ04nhYJp///hIf?=
 =?us-ascii?Q?sRxOPcH92SSTVA00dLBqtSr0qNs07L7IrxvSkbJzTxCUW05yVia3OyzRV+4f?=
 =?us-ascii?Q?M1yYHzke65zu3O2PO3gEVuFFtQdKdeTivvxiLLSfrQi93kr+Us4yaAFOIqJN?=
 =?us-ascii?Q?RSBDeF2Znkc2O6MoADcy2LLBpSQbs6dYD5xXzd8JwBOKE6TbINQQr9Xf2CUI?=
 =?us-ascii?Q?/UCl0PyI4VywIepUKAw2Ol1nh/rG/5ZWV9QHHWDuVXfBlx/riw4IupZE5VZx?=
 =?us-ascii?Q?k/t28ZPjJDotZXcA84YaLK5zFV/N/yY2qrkjUkGgnKO2gBrsvGVZQFDjeYpH?=
 =?us-ascii?Q?5JkJPT4kOL0Eb+6izVM7P7+VKtgRYwwYsIb9QGsr22/XcMsddW8Wa0ln2FZP?=
 =?us-ascii?Q?GP3rzdoZrlmSWfA8iNjtbwepyN4F4vPWicGRd+6g7PKpAt5arK9DqPaMUgHt?=
 =?us-ascii?Q?udXl9Ofpy0aw66jvhuvUKxK3tB9eKtjPlUIYJtETKfiByO4PMGCF5RYYSN2S?=
 =?us-ascii?Q?82962Lng9TIzo3e1OevH8roLDqc79Vwt6pXATDozPt8Aou7FISTFVWVh2Szj?=
 =?us-ascii?Q?tNDqMMYsdQwdiAK99J56SSelSXQ1XjcnuKI2dB/UEjyDhyPtpxSXvNop4QK4?=
 =?us-ascii?Q?utaaynTw2FVntrcRYc19ilSROVthEJJW4gWtQkh6wdrV1raOuNHQICzHq2qi?=
 =?us-ascii?Q?WBUNBNT6X7LejdZDSU3cs/a2GJDbbWkXQfSMW6ran31HQbgkzvjIe8fCo6UT?=
 =?us-ascii?Q?mT50eB7DXKdLgx7+kWbP8NgUsiBb10PMoDErzF59el9qslwajFKBPuwm3NUT?=
 =?us-ascii?Q?Y+cthJsucz77rVC3cJhrpONsNEDWXa46FNumygePJtHBYsinK2fg76Asvi7O?=
 =?us-ascii?Q?nI+MG63eCal2i4SCAMFwASZ6aFJHTVztr1TVvS0mI3NHvpz4+gMbeAQttPJt?=
 =?us-ascii?Q?qJoRAeF6tGh0Hx+GEpIIsm+7B6oU+tDnX8ViqiaTr5FBtZ3b7oIXmj3gsc3q?=
 =?us-ascii?Q?03QBB8VKQViqhjxRKn/SE+PxTWNiXETv524CWqqeJhkKy/EaC0qUdg9gfyv2?=
 =?us-ascii?Q?mtkH/N6HTBeoYagk9evd1NOsDD+9p3XUec3ApR1wW2CMd8TVoWywKFedZgrG?=
 =?us-ascii?Q?0cJ+8Kd4goOupsIjie8swwZzsPcNPJNXnF5vXTG9YR2Fu9WKvBONSijpRXT6?=
 =?us-ascii?Q?k5RhKHIFfa39L54vabh9zFrrsOW/JosYN8gp0NO8g5PPesiNGHa1EfdthjFj?=
 =?us-ascii?Q?q5k2/+AFdq74//dKzgUs82Vzgq4cK/BPsK/C90CjklXNSD7tWJJqfa6s5Lpl?=
 =?us-ascii?Q?esMWiBtSiUSOJmsaYCBZS1mNIhQOYI1P09+C6tShfqJ6WkdX2nExkrn8og5z?=
 =?us-ascii?Q?6g+TRGEy8wk4j8BClOkpFWbtKCPCS+kuVz0YYlymJLiOPWWGSpbLkMGkVddh?=
 =?us-ascii?Q?N0pdVmdBNaeQ/KW/RbucS1JB0E0fsttwp+ZqYD512vb4aHnwlUNR72aOjnxF?=
 =?us-ascii?Q?mbNvFRlNbf5Jqqx2oGKryI8SU3P5W5nYT5fvP4mn4WY2yHKHsc4r5eFzE4mu?=
 =?us-ascii?Q?3txztcxckTaACKAxbGVK3FIxL9d6aDcL3vOAIpPX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f7e753c-cbf4-4c59-38d3-08db4291f337
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 17:58:02.2905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uHt8LNanRML3KoU0fg1EJ11SwlPa7yzIAgagduegEIs7wK6Y8CYaQUznabxSoz4p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5246
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 21, 2023 at 06:22:37PM +0100, Robin Murphy wrote:

> I think a slightly more considered and slightly less wrong version of that
> idea is to mark it as IOMMU_RESV_MSI, and special-case direct-mapping those
> on Arm (I believe it would technically be benign to do on x86 too, but might
> annoy people with its pointlessness). However...

I'd rather have a IOMMU_RESV_MSI_DIRECT and put the ARM special case
in ARM code..

> > On baremetal we have no idea what the platform put under that
> > hardcoded address?
> > 
> > On VM we don't use the iommu_get_msi_cookie() flow because the GIC in
> > the VM pretends it doesn't have an ITS page?  (did I get that right?)
> 
> No, that can't be right - PCIe devices have to support MSI or MSI-X, and
> many of them won't support INTx at all, so if the guest wants to use
> interrupts in general it must surely need to believe it has some kind of MSI
> controller, 

Yes..

> which for practical purposes in this context means an ITS. 

I haven't delved into it super detail, but.. my impression was..

The ITS page only becomes relavent to the IOMMU layer if the actual
IRQ driver calls iommu_dma_prepare_msi()

And we have only these drivers that do so:

drivers/irqchip/irq-gic-v2m.c:  err = iommu_dma_prepare_msi(info->desc,
drivers/irqchip/irq-gic-v3-its.c:       err = iommu_dma_prepare_msi(info->desc, its->get_msi_base(its_dev));
drivers/irqchip/irq-gic-v3-mbi.c:       err = iommu_dma_prepare_msi(info->desc,
drivers/irqchip/irq-ls-scfg-msi.c:      err = iommu_dma_prepare_msi(info->desc, msi_data->msiir_addr);

While, I *thought* that the vGIC in ARM uses

drivers/irqchip/irq-gic-v4.c

Which doesn't obviously call iommu_dma_prepare_msi() ?

So while the SMMU driver will stick in a IOMMU_RESV_SW_MSI, and
iommufd will call iommu_get_msi_cookie(), there is no matching call
of iommu_dma_prepare_msi() - so it all effectively does nothing.

Instead, again from what I understood, is that the IOMMU layer is
expected to install the ITS page, not knowing it is an ITS page,
because the ACPI creates a IOMMU_RESV_DIRECT.

When the VM writes it totally-a-lie MSI address to the PCI MSI-X
registers the hypervisor traps it and subsitutes, what it valiantly
hopes, is the right address for the ITS in the VM's S1 IOMMU table
based on the ACPI where it nicely asked the guest to keep this
specific IOVA mapped.

I'm not sure how the data bit works on ARM..

> was the next thing I started wondering after the above - if the aim is to
> direct-map the host's SW_MSI region to effectively pass through the S2 MSI
> cookie, but you have the same Linux SMMU driver in the guest, isn't that
> guest driver still going to add a conflicting SW_MSI region for the same
> IOVA and confuse things?

Oh probably yes. At least from iommufd perspective, it can resolve
overlapping regions just fine though.

> Ideally for nesting, the VMM would just tell us the IPA of where it's going
> to claim the given device's associated MSI doorbell is, we map that to the
> real underlying address at S2, then the guest can use its S1 cookie as
> normal if it wants to, and the host doesn't have to rewrite addresses either
> way. 

Goodness yes, I'd love that.

> that the nesting usage model inherently constrains the VMM's options for
> emulating the IOMMU, would it be unreasonable to make our lives a lot easier
> with some similar constraints around interrupts, and just not attempt to
> support the full gamut of "emulate any kind of IRQ with any other kind of
> IRQ" irqfd hilarity?

Isn't that what GICv4 is?

Frankly, I think something whent wrong with the GICv4 design. A purely
virtualization focused GIC should not have continued to rely on the
hypervisor trapping of the MSI-X writes. The guest should have had a
real data value and a real physical ITS page.

I can understand why we got here, because fixing *all* of that would
be a big task and this is a small hack, but still... Yuk.

But that is a whole other journey. There is work afoot to standardize
some things would make MSI-X trapping impossible and more solidly
force this issue, so I'm just hoping to keep the current mess going
as-is right now..

> > > MSI regions already represent "safe" direct mappings, either as an inherent
> > > property of the hardware, or with an actual mapping maintained by software.
> > > Also RELAXABLE is meant to imply that it is only needed until a driver takes
> > > over the device, which at face value doesn't make much sense for interrupts.
> > 
> > I used "relxable" to suggest it is safe for userspace.
> 
> I know, but the subtlety is the reason *why* it's safe for userspace. Namely
> that a VFIO driver has bound and reset (or at least taken control of) the
> device, and thus it is assumed to no longer be doing whatever the boot
> firmware left it doing, therefore the reserved region is assumed to no
> longer be relevant, and from then on the requirement to preserve it can be
> relaxed.

IOMMU_RESV_MSI_DIRECT is probably the better name

> >          unsigned long pg_size;
> >          int ret = 0;
> > -       if (!iommu_is_dma_domain(domain))
> > -               return 0;
> > -
> >          BUG_ON(!domain->pgsize_bitmap);
> >          pg_size = 1UL << __ffs(domain->pgsize_bitmap);
> 
> But then you realise that you also need to juggle this around since identity
> domains aren't required to have a valid pgsize_bitmap either, give up on the
> idea and go straight to writing a dedicated loop as the clearer and tidier
> option because hey this is hardly a fast path anyway. At least, you do if
> you're me :)

domain->pgsize_bitmap is always valid memory, and __ffs() always
returns [0:31], so this caclculation will be fine but garbage.

> > @@ -1052,13 +1049,18 @@ static int iommu_create_device_direct_mappings(struct i>
> >                  dma_addr_t start, end, addr;
> >                  size_t map_size = 0;
> > -               start = ALIGN(entry->start, pg_size);
> > -               end   = ALIGN(entry->start + entry->length, pg_size);
> > -
> >                  if (entry->type != IOMMU_RESV_DIRECT &&
> >                      entry->type != IOMMU_RESV_DIRECT_RELAXABLE)
> >                          continue;
> > +               if (entry->type == IOMMU_RESV_DIRECT)
> > +                       dev->iommu->requires_direct = 1;
> > +
> > +               if (!iommu_is_dma_domain(domain))
> > +                       continue;
> > +
> > +               start = ALIGN(entry->start, pg_size);
> > +               end   = ALIGN(entry->start + entry->length, pg_size);

Which is why I moved the only reader of pg_size after the check if it
is valid..

Thanks,
Jason
