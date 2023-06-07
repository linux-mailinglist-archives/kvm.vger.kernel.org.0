Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A690572510B
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 02:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240207AbjFGAOR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 20:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234406AbjFGAOO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 20:14:14 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2076.outbound.protection.outlook.com [40.107.237.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA501985;
        Tue,  6 Jun 2023 17:14:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ASDUT18JA0NaOgQxhgPFWr+uNWw4C3IIxtVpPJAtJIbH3wFDuR15z1WHHqBeP33KU7E80xdrh7waV8RZA9IXqXZW1YvsP7I33OaJzRrLeDo7BGppX1d/kPvT6xtVUHz2Df7R98QqXPfoCjLVxTMmc+I8n+ajW9pYcyy/bEdculhatpHYuLHwB4BDWrSk5V9ffQ1snjjPTlz+a2Z1sDqDt5+Yp530rIO3cq5S5I3TsB+kv025xohzepBH6h+UVerUPUQQhregSzKWzj8qfjaF3x5S8pJP8EeALOEVKhHGzd9bwpuZ1+k9hAAmLIOE/RHTgFUzLWRowMJ9UKuM6gYzcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EkA0ZXgXUhw8k5/HQYhWoTz4BCw7kv6aq4g3D+rrJfM=;
 b=oU8FvhhTno277tpG8z7S8Bgg4owYXk0CoZrwkWXGtp3aKlyIyewX2lEYCJXyRXIerd6FSdpKSjJJsxxBWtkoupz3B0TrfquzaHFYt1s//XwVK4C+T89uAo/f8HuiK9hdGsNw1A816O4lGIhtJFyifPTi0A+gnrUNvdymwCOWReCOQJSfqGC7XIue51kAj2M7nVi7RLNsnDne4CgQoYEkrjj8aCYQH9iCAzaFbetpjzvxvRPtyw8vbm2nV+oKdHrQVVTOigF9RG3Oh7S+QUnD26oqoeBbVtSW5+bM9LvS4zIMAa4kNlCdTjfsi9nYcGe0zYbnsMlZlQXCCyVuzn4Ldg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EkA0ZXgXUhw8k5/HQYhWoTz4BCw7kv6aq4g3D+rrJfM=;
 b=nZe+iFjF8d3LvKWzQInMmZg2myHjegzP/kVWHhGMEljMH0DO2T8ZtdR3M/hh2g21JZurE5TaHfNwX6uTd4dXEqyWqV/IgP000rX6quPwbgIodfDdrGv67PVVW62j3BNuPTGfWA4V/tma0Ojw+MsndEC9aETviXmresidjmDGghAgz1RKS5fHFTyh1SEA+8Cwzrwlg1vxyOgNWlQ+p6732DRf+DPUp1xARRdvly0NQLt1b4X5tszK7Sllp7Gdm6mloFC58YhWwlxUCb2HX/y4usPVQkju0hmdcFRKyYiPJqcQWmwBuUa8lvfGIheLtgo1UUDc2XQqbrwMg+XIdoouPg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5859.namprd12.prod.outlook.com (2603:10b6:208:37a::17)
 by SA1PR12MB7344.namprd12.prod.outlook.com (2603:10b6:806:2b7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.27; Wed, 7 Jun
 2023 00:14:11 +0000
Received: from MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::a03a:9b2b:92f2:ff69]) by MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::a03a:9b2b:92f2:ff69%6]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 00:14:10 +0000
Date:   Tue, 6 Jun 2023 21:14:07 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     ankita@nvidia.com, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Message-ID: <ZH/LzyF/uttviRnQ@nvidia.com>
References: <20230606025320.22647-1-ankita@nvidia.com>
 <20230606083238.48ea50e9.alex.williamson@redhat.com>
 <ZH9RfXhbuED2IUgJ@nvidia.com>
 <20230606110510.0f87952c.alex.williamson@redhat.com>
 <ZH9p+giEs6bCYfw8@nvidia.com>
 <20230606121348.670229ff.alex.williamson@redhat.com>
 <ZH+DdVIyZ6hHCDaK@nvidia.com>
 <20230606153057.4cbc36a0.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606153057.4cbc36a0.alex.williamson@redhat.com>
X-ClientProxiedBy: SJ0PR13CA0136.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::21) To MN0PR12MB5859.namprd12.prod.outlook.com
 (2603:10b6:208:37a::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5859:EE_|SA1PR12MB7344:EE_
X-MS-Office365-Filtering-Correlation-Id: a4f117f5-f235-4b6c-b1b1-08db66ec1de1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RjAYY4/nPT/dMOYieXT2ZqW4gZSa78lsxnXNgNCFSVLavScy7tkSddbUr7CmXQxSzsqJ4sp/wdcgvX9MdNBMeySDruBZvIkmDTyN2qzlPi20iRudxOYV26zhP368t8TaZFunE3b0Huy7eIiTPif7dXg2MS0dCpON/hoMmQfKBFydbzoID7qIl9oPh5kfb4LXOGvwL+j5mxp9T3uUG/2zdjy3939ZemszYNXAG1uDYD1bInvzd+VJDtRZP/vFFXpS0HUUREkQlgCINj5X+J4I1POO1jsBTa8tYCYV8Q0RgGIrAf/XjIUdulaEa2iQAQOFRu4XwtFq4Zz1znepqdJsVgRCethml38svdCWTojFfDaF+dR7QtlkRvPj+tj6i3k5IRRVdLuGTZZ/zc/ZSieZnwpD6YrXUl+i390jFvUA6vxUoKcpDsLzIfR/GysqEiPck2TU+t9FDT/lUghOfauwct83i2ruirE8vmMu/0yQ8Q5mzNHEx9J2Nk3IG8ngY1rTJ1Td96JreWgwAfuizOvHVyFGo264U/b1VVJwtbF7DLzPUtZ+WvRE3LAfn4nbie8A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5859.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(376002)(366004)(39860400002)(346002)(451199021)(8676002)(4326008)(66556008)(66476007)(6916009)(5660300002)(66946007)(8936002)(316002)(41300700001)(66899021)(2906002)(478600001)(26005)(38100700002)(6512007)(86362001)(6506007)(186003)(36756003)(6486002)(2616005)(83380400001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YLjdq7rzCHu7jst5sHq1LeyXE9n3x0oCdOFs3gKKejpe9VO4ukPBcZu3uR++?=
 =?us-ascii?Q?5AfYYArr3M0lwq7adLEy02wnlT+wWfH6EQYIqDpMIkQr7J0MljXM7sokUvSP?=
 =?us-ascii?Q?wpaE5LCP1/8+OE1AuB+AjFJ6Q7FEQTiZ6SgspfuIrRD+3PxyRzWYj4JOYjWk?=
 =?us-ascii?Q?ZuHORmG1nDmebvZUn8twixDVqA3Ced/hOjqBPRtyN36HNZB/o4zCjQ3XOWIX?=
 =?us-ascii?Q?+fQRZdTNViXWEwUY9Z1Jq0e0cYXjb4LciLsc2gS8nhbuQ2Fv/9dtdoSTqJK6?=
 =?us-ascii?Q?QQeTgjuld0QwmSLUH3Onw4tImRiYEZGrGZHa5Fgd8iPdIbLAiYaFYm6ghRm5?=
 =?us-ascii?Q?DDIEdNgmYi2Hqr0Y154wJYqSlarezICWEbeVpMT3ym/p4qfGngTUb1CAgWD1?=
 =?us-ascii?Q?nZrjPDxr6BZtFMo/63RHIj4XTDroboO4StQLcADviUNTNCAdEma9gS+e8FKj?=
 =?us-ascii?Q?u6zsqMIJeFldahpvGHwyg+VJ9V1Y7mcxvcvnPe62WIeWlFdn8xDV9hZsjpub?=
 =?us-ascii?Q?Jjy19WIGq5TIIRiAY7CriY3AdxCIeqmODcjPhrAUr/M0AGYgy1MJSHSKtRWZ?=
 =?us-ascii?Q?gGJXiiHhsOs2s8KeooCvlzn5XzNtoux7qeHHpxT7TY40gGDR/MJ0LIJS3rh7?=
 =?us-ascii?Q?uKP7uciKLTOY4JldAjh7z0D/6BJMWrwdCMZedgOOQt4yXWdSGp1IoYXgNIlj?=
 =?us-ascii?Q?E+qhrS2qUdTy4GQmeLn5mXUZ0VAHv5WHGyF6mQG8IM0n4BRdbdPUwCy5vZyv?=
 =?us-ascii?Q?f3ALxkTQLfw+DwEREZrN9b2upJlsnYq7bknJpSdzeJvJOgDt0T9r8u2H41Bj?=
 =?us-ascii?Q?HASYjSrd7e2BKmuavaxmCQfkUEkyccxlY0yO0Xe1cHaarg23qi6UI1kXrSIV?=
 =?us-ascii?Q?SO41NTSCw4YiFV75d1xoHJYjlxfiIHceiD9XVZKWD8zqiIdT5p4d55hK8K2t?=
 =?us-ascii?Q?BAj4/Xhs9PLuHJwB+fqhwkfV7NdjAd86bdA7iHjftrf3Q7HMntsO4BJcwxN+?=
 =?us-ascii?Q?qLyARGI08hGiVnwtokdstoQij5cZWST+NwdrvLV1VVqIY25Y0EBSQCVZu8eW?=
 =?us-ascii?Q?DW/b+BQVWmam7bUNSJYEjG/EOUVn38e+RW5I2mdvDYdc7kGWM7pfLmtmIJ4w?=
 =?us-ascii?Q?XFKCv5SONtRUK5MG9gCDUSUVzIt71Y+sBzjxaPuFGoXl57zbeYQzQQYdpQy1?=
 =?us-ascii?Q?jhE3pOxZGDJdd0JCyveAMy0mZYokfp3DuN/qncpo00WpQu9YeGEzFb+4SPLh?=
 =?us-ascii?Q?hGW/FJjFDOPWeO8uafs89UHTIs/Ae4/G/IwBEXkun6nXKKxTSarsNqiXAWAQ?=
 =?us-ascii?Q?+m8hYpifkGvYbxWKH6zuQRoIHYG8qNejNF16JxHEaC7hlDtBtKBR7Cq2VeEH?=
 =?us-ascii?Q?VdcpFoIrHjDmL24z8OFadBvpwpSCO6Ri88aIz4T9ixl2H0okTFLaWpEYikGS?=
 =?us-ascii?Q?odIUGQ1BTKD941nFe3i5+aCzrpLjfiCy/72btPurSVe6L4aW1Y9zdbvBXJ3U?=
 =?us-ascii?Q?jzA+IldXxAVMX2wg7462YUEByVaNBHXmpVd7q1slSxUb3o13fz5o2fVPAc5N?=
 =?us-ascii?Q?lgCl0KkEOxr9MT5jjiOv9wuAquK+XUtkChp3FOCb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4f117f5-f235-4b6c-b1b1-08db66ec1de1
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5859.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 00:14:10.4376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: maPFa0d5j8ihPwWkrcGywPDI1q2VsnA0oX/NpfaF//eb9F3pWjXV2FaRHL4IZ7ZD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7344
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

On Tue, Jun 06, 2023 at 03:30:57PM -0600, Alex Williamson wrote:
> > To emulate PCI, someone, somewhere, has to fix this mismatch up.
> > 
> > So given choices
> >   1) Qemu sees a special NVIDIA thing and fixes it
> >   2) Qemu sees a VFIO_PCI_BAR0_REGION with an odd size and fixes it
> >   3) Kernel lies and makes a power-2 size and it fixes it
> > 
> > 2 seems the most forward looking and reusable.
> 
> What?!  It's not just a matter of fixing it.  The vfio-pci uAPI should
> never return a BAR region that's not compatible as a BAR. 

Why? But OK, if you don't like then then let's call it
VFIO_PCI_BAR0_REGION_NOT_POW2. Not seeing that it really helps so
much..

> It's incorrectly sized, it does special things with mmap under the
> covers, and it doesn't honor the memory enable bit.

The mmap attributes stuff is not uAPI visible, so it doesn't matter.

Normal vfio-pci devices will SIGBUS on memory disable, this could do
that if it was really important (I don't think it is)

So we are left with.. The size is weird. Someone has to provide the
fixing to fit that into the PCI config space world because we are
emulating a real PCI device.

The fixing is generic, a generic function does not elevate to create a
vendor uAPI IMHO.

> And then QEMU goes on to ignore this peculiarity when setting up all
> the ACPI features, instead relying on the PCI vendor/device ID when
> it could be using a device specific region to initiate that support.

We really should not rely on vendor regions to trigger device specific
VMM behaviors for a variant driver. If we want to do this better than
vendor/device ID we should have a VFIO ioctl report which variant
driver is running the device so userspace can do whatever.

> > I definately don't think this is important enough to stick a vendor
> > label on it.
> 
> How high is the bar for a device specific region?  This certainly looks
> and smells like one to me.

I would say if the thing that is showing up on the VM side is not PCI
then maybe a vendor label might make sense.

> > Broadly, we are looking toward a way for the kernel VFIO variant
> > driver to provide the majority of the "PCI emulation" and the VMM can
> > be general. It is not nice if every PCI emulation type driver needs
> > unique modifications to the VMM to support it. We are planning more
> > than one of these things already, and there are industry standards
> > afoot that will widly open the door here.
> 
> Meanwhile every VMM needs a hook to extend non-compliant BAR sizes,
> assuming the kernel will fixup mappings beyond the region extent,

Yes! It is a basically a new generic VFIO ability to allow this size
adaptation. If you don't like this version of the uAPI then lets tweak
it, but it still needs the same basic operation where the kernel tells
userspace that a certain mmap is to be placed in a certain BAR config
space.

> pretend that none of this is a device bug?  It really is a very small
> amount of code in QEMU to setup a MemoryRegion based on a device
> specific region and register it as a PCI BAR.  The non-standard size is
> a factor here when mapping to the VM address space, but I'm a bit
> surprised to hear an argument for hacking that in the kernel rather
> than userspace.

Well, I'd rather do it in userspace.

> > The only special bit is emulating the weird Grace FW ACPI stuff.
> 
> And a device specific region seems like the ideal jumping off point to
> create that memory-only node for this thing.

It really has nothing to do with the regions, it is something that is
needed if this variant driver is being used at all. The vPCI device
will work without the ACPI, but the Linux drivers won't like it.

> > So lets find a way to give these things appropriate generic names at
> > the ABI level please..
> 
> What is the generic feature that "these things" implement?

As far as I can see, non-power-2 size is the thing the VMM needs to
worry about.

And maybe a generic way to detect which variant driver is running.

> There's a lot of vendor specific things going on here.  Not only is all
> that "weird Grace FW ACPI stuff" based on this region, but also if we
> are exposing it as a BAR, which BAR index(s) for a given device.

The kernel decides the BAR indexes, not the vmm, because broadly we
want to have the kernel in charge of making the synthetic config
space.

The ACPI is not related to the region. It is just creating many empty
NUMA nodes. They should have no CPUs and no memory. The patch is
trying to make the insertion of the ACPI automatic. Keying it off a
region is not right for the purpose.

> If "the industry" does come out with a spec for "these things",
> couldn't QEMU optionally plug a device specific region into the
> implementation of that spec, potentially along with some commonly
> defined region to make this device appear to honor that new spec?
> Versus with the in-kernel variant driver masquerading the BAR, we're
> stuck with what the kernel implements.  Would future hardware
> implementing to this new spec require a variant driver or would we
> extend vfio-pci to support them with extended regions and expect the
> VMM to compose them appropriately?  

Look at Intel's SIOV document for some idea, I expect devices like
that will be a VFIO driver (not a variant PCI driver) that largely
exposes the vfio-pci uAPI with the purpose of creating a vPCI device
in the VM.

There is no real PCI function under this so all the config space and
so on will be synthetic. It is convenient if the kernel driver does
this so that it works on all the VMMs generically.

Non-power-2 BAR is desirable in this world because address space is
precious at high scale and power2 scaling gets wasteful.

Further, I would expect there will be a generic CXL driver and generic
CXL related ACPI someday.

This device is sort of in the middle where it does have a real PCI
function but it is also synthesizing some config space. We have
another VFIO driver in progress that is also doing some modification
of the config space..

Jason
