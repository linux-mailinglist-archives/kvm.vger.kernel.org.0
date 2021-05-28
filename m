Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF21C394687
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 19:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbhE1RhS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 May 2021 13:37:18 -0400
Received: from mail-sn1anam02on2054.outbound.protection.outlook.com ([40.107.96.54]:38624
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229450AbhE1RhR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 May 2021 13:37:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fBOS0AwABgiI7Jo4g7MyKSn8ThbH0aEVoGpFFCWvLi6N+dh1ImRvAqor1i+W4akExIWiggsPHGpL7YFjr7BHAuZn7NR6fTn4SfPCRt4iO9uadW8+kesX+s9umgBXA7yBUgToZxtcZGcLMWp7YDYnGdI6hRXjE8iUCflmLbP+epc1GcvE6BoWeb637VfEjL4d29DHZTZRtA+vHi6z6aFaSEfKQ3fE6LSJDI+jaWYk5vggwtIaX5jZ44cYCa5y4FAX1G6/WDBD5EYKh0U5H254kHt5VHOeKn3+ZnAxt8AjW8bG3Dg8KPLRBQ9hT4mOiWA9O/KQCI27QZ904290zDO6bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g1GxCsOlmDcybySU1GhVwM/cUZwthjtqnrELfctAmjY=;
 b=OwYLBEd2uubQKvPA4pqY+0a0LbAZpgweLdDTB/q1QDoHZz5Fu6zNxGRnRU0xC01zYR0yvx9eUdPrQcqHjOF7yhZZ1qrfRZ16mnu8Itbn6g2YRd9LwEXWPk2EWIUQZkxfWrBJiDIEz2aHVmxNu+g3uKgL9XDJ+Wrzu/qw5YNM43MI5BMfxBSkGiv1INtuR47mHw/i15pfI33wh8J+IjC5jluLWTPavnEz9RiXqg+rTMuCjasI9PBMxlC/Q7nQ+AcoqjDySQocmm+fbO/YrHN8fLOOt9WbNncs49Tgxh12MBu3bUatN6LG/3v4h7DMVBXRnQctxePEXBCBQFbawZ/l6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g1GxCsOlmDcybySU1GhVwM/cUZwthjtqnrELfctAmjY=;
 b=Zqa22SW+WFc9dgGn2YAqHOJ2vPrfB4h372gexaZqxZ96qeGpDry82Wzn8hJVBhot///fMfdu4zYtBtk3R5jw/R1cNyHVv7gbdrdr5KgDYh2EcUAHBI9VPJvtoYDjVLnJcPmNTy6rweKs5ojOkqdvpaXA5zL/doneDmIwUzsFAM7rRsvBcRO0j15RljqIdq7W8bv+bWeUGpKzUCa88mnxznLmg92eiy+pRDzL4VVuQWLkCilPKOKTfzS89vqAKUc48M/KZm5wqgc/SSsfEcMmmJnnLWnP6YWxtfswH+eZnJQgjixh2Lhp7To0GuVxtJb5Gp057HHKP2Zi6104GjdvJg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5318.namprd12.prod.outlook.com (2603:10b6:208:31d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Fri, 28 May
 2021 17:35:40 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4173.023; Fri, 28 May 2021
 17:35:40 +0000
Date:   Fri, 28 May 2021 14:35:38 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210528173538.GA3816344@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR02CA0014.namprd02.prod.outlook.com
 (2603:10b6:208:fc::27) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR02CA0014.namprd02.prod.outlook.com (2603:10b6:208:fc::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 17:35:39 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lmgOY-00G1IX-R9; Fri, 28 May 2021 14:35:38 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 883a4c7f-c8a9-4bd3-7803-08d921ff02e0
X-MS-TrafficTypeDiagnostic: BL1PR12MB5318:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5318B54767BA64A18AA50BF6C2229@BL1PR12MB5318.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pDjvlvOUjU4pdkgXqCpvtCHKu08KQw0DUZICRVgDTRNfLeOX0YWpFNEzK7T63MomxL6/ab+tAfExxgjpBqcYP44AzoE1wTp96f4kc6dPzVaFn1DbM1tk98qpFoLhDoEzJ3+dJcz/QGdrX79Wu5rXeqW0odlvHSPZA9Ds6HdYBBdaO5NtCwaBGsow0fQBZXfVzHBNE8jpBv9RwKwdJ5XdzK+Ykcdh7JMuZbjN9m2ldAKHLpxVDFeRPUjPof0oaUkux7Nthn4czYBMXgXyv8Rxnh/KpudFWXMBolUgTL3IS9RZf0EP60hD82/TA3fqUTgafEA7exCL/RjVZPyrXUzpAuFPsTBIyz/x9p9BadR050GHJpUouNm+gsjbNg2SvAsSyVM7EfwAvs73ObFszeRxvJTWqxAI6QKIrDteoLmxYqRIeEmzpkIuDD54b4MTpmMa7jONzAsDv6AtTaRjOIfoORBTgGb9m+UzW0Ix+HNbAeJv/DCo8x1vk7itStyz0BUC3Utgdeu3v0z+qdzBTAQoLQv8zYUi2923VEmMBFIozirAC2jbWNhoRLslbII6M2bF0tfxpmqCtxyVEcyotIuKD4Ivd/2zUry3WWowERJe7TI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(366004)(39860400002)(83380400001)(66946007)(26005)(66556008)(33656002)(66476007)(7416002)(9746002)(86362001)(9786002)(54906003)(316002)(8676002)(186003)(478600001)(2906002)(4326008)(6916009)(426003)(1076003)(36756003)(38100700002)(8936002)(2616005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?NSok02vfYdtES0ORAUi829zGMeo2bqE4R0BK1nhoiN8wcJghadaH+cIIWSjk?=
 =?us-ascii?Q?s0aE2tDU8RBrmdADXA8IFPhJHvjmC22Cxo2olqKW4U6f96CH1L6ENPEgRroR?=
 =?us-ascii?Q?LReUznggT2VdDXB8NQKsEVWAPrJp2m4okOFAM/X5yr3CbqeaXglzG6ZvnivP?=
 =?us-ascii?Q?lAn/mmOfLOE9pIpsNhj2z+CFpTSx74WQfbXAMES1mECJY6FIAlU5/3CEQYc2?=
 =?us-ascii?Q?frQATSmZdjXa3Rca+AdLvvNT1Z+AkV0N9cXajhcBiXrN3f2+l6JRPJ1P9d0B?=
 =?us-ascii?Q?ZXlRk8iVeMdz2Jy5DGT1yvTcIAsASGKcI5F4h7KF+8/0FLwJK9UA2lmT8jDc?=
 =?us-ascii?Q?IRlD6vY54v5uSXQWP5qQwsadt0Lc0t5MAZzb6Xj0PAPfylkn+RLDMX0kaR4r?=
 =?us-ascii?Q?tuh+3AtaUS+JTlqBD2RU+nGXL51cFjqQehig6w6iTYQTKK+qjelnUZb2lOX3?=
 =?us-ascii?Q?RScyXhsSteaiWBr/I3iPsH80sHuepO3V41CtpgSApAaUFaek78VHo0UTpKD7?=
 =?us-ascii?Q?8yWNTU71ZQw1UeiQGWqL46AkhcOvh1OLes2IhBJgNmXCp2nNytS4/aBiqIMz?=
 =?us-ascii?Q?pVQcEM6BHa2PPinsXnEUuYwY/8fjIhatw+o8hXZfI9kgm/na2uWHwcDIMZ/Z?=
 =?us-ascii?Q?WZAdCkRSEQnv6p1HW1NVcR/ig47R7Zn+tGNPAOMV9o+NOunbiqYzS1kpJfke?=
 =?us-ascii?Q?9zFYIaJB/2/IUaM1Naoh1In7Fd7w5oqFpB8ykDI8W5KQwKgUPhN2UIZ4CS1c?=
 =?us-ascii?Q?tSuBSoQv6ZWMlzOqsbT8RzBGvqWLqzHGdEuLaJWue5xfdkogluDarJ8HdwWq?=
 =?us-ascii?Q?iJpLYfKZTo/G8u9AfhNP0qHwU6teC8EG96SnEwpnu0cqZLW4yrac95xSakAj?=
 =?us-ascii?Q?Q3g3HNVFU3UJlm1cYfkIlDe7SyMJqbg69AhiDcv9Vbd9rI2ZsW/OpmWMAyTW?=
 =?us-ascii?Q?m2GIuVjcyLASxl581nuvaDVWyw60kXFJGLz3Xp9J1YH3QrbbSTiOSdF7q6oa?=
 =?us-ascii?Q?ZngJXvYE19eogStg6gamfrsqMr51D3wg4PV4UCkjPtoPPqf+H6+sy6GEJ3wE?=
 =?us-ascii?Q?/lQq9RsOtIFxdkk7Jy0QAyZcaZapRq9t46iJsdYyH4Ihs69o4miDB86pwDMF?=
 =?us-ascii?Q?0jM+FFT3wh6GVQJeqZAd6DyVFCFS0+ec7KWN31IhbClS5K3X+lpjZt94uym0?=
 =?us-ascii?Q?iFFHO6sdDt0waxLZpq/qTiOjPQfebGfXLHIvv+3118ocO/skUtjIS13Y6fDr?=
 =?us-ascii?Q?Np8J8MB/p+GyNrdJePoDspx/son8iL0gwjZriiZudij+KyJRTLrsiFnEaJjX?=
 =?us-ascii?Q?KhquS6/35wmMj2HHdHyyPwIN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 883a4c7f-c8a9-4bd3-7803-08d921ff02e0
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 17:35:39.9751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U1Hq5IdhFP8eIKUBnmWdE3xO+iloM+CNqyg1i8NxjuRvTLTpHlUltr5WSCQzsSKQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5318
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 27, 2021 at 07:58:12AM +0000, Tian, Kevin wrote:

> IOASID nesting can be implemented in two ways: hardware nesting and 
> software nesting. With hardware support the child and parent I/O page 
> tables are walked consecutively by the IOMMU to form a nested translation. 
> When it's implemented in software, the ioasid driver is responsible for 
> merging the two-level mappings into a single-level shadow I/O page table. 
> Software nesting requires both child/parent page tables operated through 
> the dma mapping protocol, so any change in either level can be captured 
> by the kernel to update the corresponding shadow mapping.

Why? A SW emulation could do this synchronization during invalidation
processing if invalidation contained an IOVA range.

I think this document would be stronger to include some "Rational"
statements in key places

> Based on the underlying IOMMU capability one device might be allowed 
> to attach to multiple I/O address spaces, with DMAs accessing them by 
> carrying different routing information. One of them is the default I/O 
> address space routed by PCI Requestor ID (RID) or ARM Stream ID. The 
> remaining are routed by RID + Process Address Space ID (PASID) or 
> Stream+Substream ID. For simplicity the following context uses RID and
> PASID when talking about the routing information for I/O address spaces.

I wonder if we should just adopt the ARM naming as the API
standard. It is general and doesn't have the SVA connotation that
"Process Address Space ID" carries.
 
> Device must be bound to an IOASID FD before attach operation can be
> conducted. This is also through VFIO uAPI. In this proposal one device 
> should not be bound to multiple FD's. Not sure about the gain of 
> allowing it except adding unnecessary complexity. But if others have 
> different view we can further discuss.

Unless there is some internal kernel design reason to block it, I
wouldn't go out of my way to prevent it.

> VFIO must ensure its device composes DMAs with the routing information
> attached to the IOASID. For pdev it naturally happens since vPASID is 
> directly programmed to the device by guest software. For mdev this 
> implies any guest operation carrying a vPASID on this device must be 
> trapped into VFIO and then converted to pPASID before sent to the 
> device. A detail explanation about PASID virtualization policies can be 
> found in section 4. 

vPASID and related seems like it needs other IOMMU vendors to take a
very careful look. I'm really glad to see this starting to be spelled
out in such a clear way, as it was hard to see from the patches there
is vendor variation.

> With above design /dev/ioasid uAPI is all about I/O address spaces. 
> It doesn't include any device routing information, which is only 
> indirectly registered to the ioasid driver through VFIO uAPI. For
> example, I/O page fault is always reported to userspace per IOASID,
> although it's physically reported per device (RID+PASID). 

I agree with Jean-Philippe - at the very least erasing this
information needs a major rational - but I don't really see why it
must be erased? The HW reports the originating device, is it just a
matter of labeling the devices attached to the /dev/ioasid FD so it
can be reported to userspace?

> multiple attached devices) and then generates a per-device virtual I/O 
> page fault into guest. Similarly the iotlb invalidation uAPI describes the 
> granularity in the I/O address space (all, or a range), different from the 
> underlying IOMMU semantics (domain-wide, PASID-wide, range-based).

This seems OK though, I can't think of a reason to allow an IOASID to
be left partially invalidated???
 
> I/O page tables routed through PASID are installed in a per-RID PASID 
> table structure. Some platforms implement the PASID table in the guest 
> physical space (GPA), expecting it managed by the guest. The guest
> PASID table is bound to the IOMMU also by attaching to an IOASID, 
> representing the per-RID vPASID space. 
> 
> We propose the host kernel needs to explicitly track  guest I/O page 
> tables even on these platforms, i.e. the same pgtable binding protocol 
> should be used universally on all platforms (with only difference on who
> actually writes the PASID table). One opinion from previous discussion 
> was treating this special IOASID as a container for all guest I/O page 
> tables i.e. hiding them from the host. 

> However this way significantly 
> violates the philosophy in this /dev/ioasid proposal. It is not one IOASID 
> one address space any more. Device routing information (indirectly 
> marking hidden I/O spaces) has to be carried in iotlb invalidation and 
> page faulting uAPI to help connect vIOMMU with the underlying 
> pIOMMU. This is one design choice to be confirmed with ARM guys.

I'm confused by this rational.

For a vIOMMU that has IO page tables in the guest the basic
choices are:
 - Do we have a hypervisor trap to bind the page table or not? (RID
   and PASID may differ here)
 - Do we have a hypervisor trap to invaliate the page tables or not?

If the first is a hypervisor trap then I agree it makes sense to create a
child IOASID that points to each guest page table and manage it
directly. This should not require walking guest page tables as it is
really just informing the HW where the page table lives. HW will walk
them.

If there are no hypervisor traps (does this exist?) then there is no
way to involve the hypervisor here and the child IOASID should simply
be a pointer to the guest's data structure that describes binding. In
this case that IOASID should claim all PASIDs when bound to a
RID. 

Invalidation should be passed up the to the IOMMU driver in terms of
the guest tables information and either the HW or software has to walk
to guest tables to make sense of it.

Events from the IOMMU to userspace should be tagged with the attached
device label and the PASID/substream ID. This means there is no issue
to have a a 'all PASID' IOASID.

> Notes:
> -   It might be confusing as IOASID is also used in the kernel (drivers/
>     iommu/ioasid.c) to represent PCI PASID or ARM substream ID. We need
>     find a better name later to differentiate.

+1 on Jean-Philippe's remarks

> -   PPC has not be considered yet as we haven't got time to fully understand
>     its semantics. According to previous discussion there is some generality 
>     between PPC window-based scheme and VFIO type1 semantics. Let's 
>     first make consensus on this proposal and then further discuss how to 
>     extend it to cover PPC's requirement.

From what I understood PPC is not so bad, Nesting IOASID's did its
preload feature and it needed a way to specify/query the IOVA range a
IOASID will cover.

> -   There is a protocol between vfio group and kvm. Needs to think about
>     how it will be affected following this proposal.

Ugh, I always stop looking when I reach that boundary. Can anyone
summarize what is going on there?

Most likely passing the /dev/ioasid into KVM's FD (or vicevera) is the
right answer. Eg if ARM needs to get the VMID from KVM and set it to
ioasid then a KVM "ioctl set_arm_vmid(/dev/ioasid)" call is
reasonable. Certainly better than the symbol get sutff we have right
now.

I will read through the detail below in another email

Jason
