Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F40003D7BF7
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 19:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbhG0RPC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 13:15:02 -0400
Received: from mail-mw2nam12on2079.outbound.protection.outlook.com ([40.107.244.79]:3689
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229453AbhG0RPB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 13:15:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LDQUVj2UJIzhS4UEInACtTgXJmH1h3Zx06YFjzia2mKORQnnT+D1sD6XBE2ib9fDTrd2hPsq7Yjt3bUKbzNEawASjpOGxK4mOl5fY6Pa7QULUUPVvYDw/O0kh7OPX3ZMAKhoe75txlXzY8nePN2R5SHAPx6MI1A6kSemQE61HWL8NmOv/RKnWF94XytJoGgmKp6TozMxdAViQRvsrRGyTR2CMCUO+T53nIGNmXRjEnc7BN3kLEhO0m3pgS23phDYQm9FVQQWKmnY4jzvY5PVxr3CIWaw515u7/7PQvDA8rozA0B/2m9AmcE/sBMEgUWUxlFOTF6638uqa0XzjtUExA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LUvuSk/ynSi0GkLj804YQ6ZYrNtWfiRAmK3CtwccfKw=;
 b=h8CCo63Sj9AjHUFQqHIBnoiLnw//Y5QBt982GdwRcy5GbisWG1kVWEfguXIP9+6pKofw8GP5sxIN4Kq23KRnJLC9XKlqzNdvdfDzmfRXHusuibf2rv7BqefYpJhMF7IsBDP7nEF28BhOlYhygib7m0InJy5S1O5pfsJ+9FGfYbuFXIO/jCMsM1huaFUVTJJaX9QDN6Yvj5cjfO/smzdJvDkLRinjLf2/FOB+Il4l8li8F7NZ72W5VHXyHV36PwEVDreu0FUAboGp3vwLI1Yb52XoYlVLuK7t7JgFIRcHP5vaHR0ciIaNunYqomxD3D3sbgfuHSTQVEuYckZuS4Ua5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LUvuSk/ynSi0GkLj804YQ6ZYrNtWfiRAmK3CtwccfKw=;
 b=R0jAjtxhWuMFsVIHNofNzOjUrF1HbubVK0bYri20Luwakd99ZTlg6WDa7e7ILQfTOdc1mbNrpL2e6TmMylMiv3NIuir/N17f+YQDWxm/bSdnO9x+AedJj/K4/qrdO83HbV1qOFTbtQAt8RD4XhPFSm1on+r/IFco2nhgYPXkaCobvK1U7EaovX8O8t4vZmsglXJv4T8GnPfQK3/iuqKhD425WyUcI89lVpXO7LCBGlYVLFO/e340dg1O1GhzzHeefX1ow0WQRmRDvkdjIEvy6M1r86gzIrC+XfjdAW2/RXOxoAYGDiTxpKq133dBTYaXqFeVaU2c8gKx4vZZNykVvQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5128.namprd12.prod.outlook.com (2603:10b6:208:316::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Tue, 27 Jul
 2021 17:14:59 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%4]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 17:14:59 +0000
Date:   Tue, 27 Jul 2021 14:14:58 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        corbet@lwn.net, diana.craciun@oss.nxp.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org,
        mgurtovoy@nvidia.com, maorg@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH 09/12] PCI: Add a PCI_ID_F_VFIO_DRIVER_OVERRIDE flag to
 struct pci_device_id
Message-ID: <20210727171458.GE1721383@nvidia.com>
References: <20210721161609.68223-1-yishaih@nvidia.com>
 <20210721161609.68223-10-yishaih@nvidia.com>
 <20210727103418.2d059863.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727103418.2d059863.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0357.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::32) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0357.namprd13.prod.outlook.com (2603:10b6:208:2c6::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 17:14:59 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m8QfS-0095iu-8A; Tue, 27 Jul 2021 14:14:58 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12f2d25c-cce2-47b5-6ed9-08d95122101f
X-MS-TrafficTypeDiagnostic: BL1PR12MB5128:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5128EDBF21D7339E8F4147BAC2E99@BL1PR12MB5128.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Fiq3HvQYnu3NuaZXiV38+7gF4WB7JPGOl0tmeeg4LxOlAQN66o08zyEz2es1SMt5q5GDUY8ArTSYHhSCgGigXOtElj1bZJvdNwAfyXQtsyM/sHf1Wx+ufoznEHIKXS99hGaTlxA0cFOFD0Ha+rSSxIe133c7/e7+yIKfxNF/jXBSqFWfzfyqOCju5rpUcp0O6zd+L7hTBtTdIQm90a4Lf6zW9f4SDoFpDqvY6rQg830YAnKXsNwe1E90LYk7TZmLFA1+HXvUxXfIl2i/fRr40krHUcWXXivIF2r88lIQ7CyRYp8KV2X3HnvHoy4uToLRepRFTcJcu/Ez1SZDy1u2TSLhGOEwtraq2tRExnoC/2vhfqAvTCet76ymBR9xayCZCm4i1ObYHXi+VmewFJm2Zug62jgBqVc87tutFdX37SD162qZ9dILkLUxCp+W0i621xfFZhpOMK/1B18TPf+PCFQ3sIvIQBtFzrHfErAS0LDrlrerYros5rwsLJ33JsqhpBP0QzB/E2fq4ON/CrvJkE/uiMNirooL2KmMWKqtao4lN0fKpfFJjYlEol7atNtU+qjmnrrF7WtygU5++wNbrkidFe4Zra69/zflfo5Jp37oeeGX5lpLoBljdSf+wRhn35r6XZhU6N8UdiLkd6LxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(346002)(136003)(39860400002)(66946007)(66556008)(66476007)(9786002)(9746002)(478600001)(2906002)(83380400001)(7416002)(6916009)(316002)(107886003)(5660300002)(2616005)(26005)(1076003)(426003)(8676002)(36756003)(86362001)(186003)(38100700002)(4326008)(8936002)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UrIy1tFRjlTHC54Wgd5p4oHEPLLu3GVUT8qg9eyH7s5zRqqLeedTZugGX2lP?=
 =?us-ascii?Q?AcxHu8hUmTOwC5/hJku+wmdcmk36jjS4tsVSmNkBvW+nSYeYAHGlM/z+xqC5?=
 =?us-ascii?Q?bdqG8hIIPKujLdETu/eHAl5LVnrzQKmGhCX/lNmwQkne3aP6N+avl/9HN2bD?=
 =?us-ascii?Q?MW7B/5Pp2+zrReg48McwgQAmd6RvKwBKIYoXEIcQhPcVTz4ZNK+uvCoPtvGD?=
 =?us-ascii?Q?x0/k44S74GqtX82Y/FutBz9Vyr6lDir5hZ2aQhTtTeO4PWvUSqa0h5If2WLz?=
 =?us-ascii?Q?KtaAjiOQgy+gdal7jVDvF71W3Zt+YOXT3cpH9mpE/lxCGSMuTDPQl4uyM6GU?=
 =?us-ascii?Q?6NuBVxEVqDHwqIW/k8GmNqE+/X1QsPzRjCLcAxBJ/TmYmIGJaQ76FG6UCx+K?=
 =?us-ascii?Q?vc/pbmcUFxTlBRG9aM7lmCThuOZveqtgrFBbh14nnBC6ixamaXyFs1wN0yj7?=
 =?us-ascii?Q?/++qFDqScFiBYMBK18alKea0YkJGa7raNiGR2D8b1AVHdVwbPy5kn2bs/g3k?=
 =?us-ascii?Q?Y0nKH5Xj3wqh2Aj8nUtcMNhCJxeAPlfS638kgfLYKotnC9ci3zRGnNqo75Ml?=
 =?us-ascii?Q?9t54+IDv1AleEnryWlORrK1O3U9s13O8bQDa6ZnzXYAvbN47/urZc+k1uyG7?=
 =?us-ascii?Q?/BkiAqI12GiXifT7GIYDOVJEcOReUlUMzZNab2xbX8RUxG9sS0HvVcKGnEvH?=
 =?us-ascii?Q?o16k2vN5mZUBKZIPiPRPEEyTV8GyQQDIaVDP5q/uYH5oYl8uVfrbDvWT7uB/?=
 =?us-ascii?Q?vU2mXoDhNtHarsFkSD3tmdw8aTzhcqAa4z0Va/cgi4U12b3hUoh2r/bhV9Je?=
 =?us-ascii?Q?L4rjElrIHQXIvNeJ1NHyjiGiur7RANUziBTho0rQ7Dd2858NgO6LS87yY36B?=
 =?us-ascii?Q?V4+AlKYJsyrZftlh/wkVVYg5Yp/gDaji/FDsophkf/B+VF6lSq2OG8jdIK1u?=
 =?us-ascii?Q?16VdFUZ8Zc/fwR+ehpHOcU2rlOFWMHniUL8lVFuxQ7RFzex2HU6z+Yq6Y9+1?=
 =?us-ascii?Q?+wZinDjePn1zCcrWmVt7OWBrNu9m2sKl1yva+/teWARQJaeaN9Gv0kjiTMgV?=
 =?us-ascii?Q?Av3gdDGIs4WaHCjitxxpSWbYqEjwLn2IbBEwcwbcy1oWm97JOVpVL4vLBthu?=
 =?us-ascii?Q?qmIQQ3kaT1neQeDRfJopkhRVyQGS0bnaxdOHPTkAnBsCLYflarSOTTElrCS6?=
 =?us-ascii?Q?OgJisE3RPn2mMTomu64wt0eZmXPhM/qS/1WgoDt7LY8Kx4LoGltCAkGI29Qg?=
 =?us-ascii?Q?eiwxoClx0SQU7g7FSA0x7ONCa+fE/hr4MV9Fb7WVYzDUsV1PA4Q7XLbD3k8+?=
 =?us-ascii?Q?PpvOqkUfsaM/Mr0QGHaRjMqA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12f2d25c-cce2-47b5-6ed9-08d95122101f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 17:14:59.3577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gtiDOciHSe3dnFI5RQKhiKZyG0aBR8ggFyNaBtWTG6N4JOTm8TR7eE0GZa6dQbCX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5128
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 27, 2021 at 10:34:18AM -0600, Alex Williamson wrote:
> On Wed, 21 Jul 2021 19:16:06 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
> 
> > From: Max Gurtovoy <mgurtovoy@nvidia.com>
> > 
> > The new flag field is be used to allow PCI drivers to signal the core code
> > during driver matching and when generating the modules.alias information.
> > 
> > The first use will be to define a VFIO flag that indicates the PCI driver
> > is a VFIO driver.
> > 
> > VFIO drivers have a few special properties compared to normal PCI drivers:
> >  - They do not automatically bind. VFIO drivers are used to swap out the
> >    normal driver for a device and convert the PCI device to the VFIO
> >    subsystem.
> > 
> >    The admin must make this choice and following the current uAPI this is
> >    usually done by using the driver_override sysfs.
> > 
> >  - The modules.alias includes the IDs of the VFIO PCI drivers, prefixing
> >    them with 'vfio_pci:' instead of the normal 'pci:'.
> > 
> >    This allows the userspace machinery that switches devices to VFIO to
> >    know what kernel drivers support what devices and allows it to trigger
> >    the proper device_override.
> > 
> > As existing tools do not recognize the "vfio_pci:" mod-alias prefix this
> > keeps todays behavior the same. VFIO remains on the side, is never
> > autoloaded and can only be activated by direct admin action.
> > 
> > This patch is the infrastructure to provide the information in the
> > modules.alias to userspace and enable the only PCI VFIO driver. Later
> > series introduce additional HW specific VFIO PCI drivers.
> 
> I don't really understand why we're combining the above "special
> properties" into a single flag. 

Currently I can't think of any reason to have two flags. We always
need both behaviors together. It is trivial for someone to change down
the road, so I prefer to keep the flag bit usage to a minimum.

> For instance, why wouldn't we create a flag that just indicates a
> match entry is only for driver override?

We still need to signal the generation of vfio_pci: string in the
modules.alias.

> Or if we're only using this for full wildcard matches, we could
> detect that even without a flag.

The mlx/hns/etc drivers will not use wildcard matches. This series is
the prep and the only driver we have right at this point is the
wildcard vfio_pci generic driver.

> Then, how does the "vfio_pci:" alias extend to other drivers?  

After the HW drivers are merged we have a list of things in the
modules.alias file. Eg we might have something like:

alias vfio_pci:v000015B3d00001011sv*sd*bc*sc*i* mlx5_vfio_pci
alias vfio_pci:v0000abc1d0000abcdsv*sd*bc*sc*i* hns_vfio_pci
alias vfio_pci:v*d*sv*sd*bc*sc*i* vfio_pci

This flag, and the vfio_pci string, is only for the VFIO subsystem. If
someday another subsystem wants to use driver_override then it will
provide its own subsystem name here instead.

This is solving the problem you had at the start - that userspace must
be able to self identify the drivers.  Starting with a PCI BDF
userspace can match the modules.alias for vfio_pci: prefixes and
determine which string to put into the driver_override sysfs. This is
instead of having userspace hardwire vfio_pci.

> Is this expected to be the only driver that would use an alias ever
> or would other drivers use new bits of the flag?

Not sure what you mean by "only driver"? As above every driver
implementing VFIO on top of PCI will use this flag. If another
subsystem wants to use driver_override it will define its own flag,
and it's userspace will look for othersubsytem_pci: tags in
modules.alias when it wants to change a PCI device over.

> Seems some documentation is necessary; the comment on
> PCI_DRIVER_OVERRIDE_DEVICE_VFIO doesn't really help, "This macro is
> used to create a struct pci_device_id that matches a specific
> device", then we proceed to use it with PCI_ANY_ID.

Fair enough, this is ment in the broader context, the generic vfio_pci
is just special.

> vfio-pci has always tried (as much as possible) to be "just another
> PCI" driver to avoid all the nasty issues that used to exist with
> legacy KVM device assignment, so I cringe at seeing these vfio specific
> hooks in PCI-core.  Thanks,

It is has always had very special behavior - a PCI driver without a
match table is is not "just another PCI" driver.

While this is not entirely elegant, considering where we have ended up
and the historical ABI that has to be preserved, it is the best idea
so far anyone has presented.

Jason
