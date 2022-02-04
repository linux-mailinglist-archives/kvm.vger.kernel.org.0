Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54B0D4AA3FB
	for <lists+kvm@lfdr.de>; Sat,  5 Feb 2022 00:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377883AbiBDXHz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 18:07:55 -0500
Received: from mail-bn8nam11on2070.outbound.protection.outlook.com ([40.107.236.70]:50113
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1377870AbiBDXHx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 18:07:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hSQgSgRBdrdsCOieSkjV0HkSft0N6fHCj+X5uTsI07vMdM5r+lFvJMK+zJBByO+7M1oiR2jjIvEe/WmF/TEoqSKECRtCIIlgUnjSIxjkkimSpEHju4mRcVtysVkV6aAsw2pI1pfCeiU2j+Zvy7RJJUnt7ZscpM1ZY+WOuxUdxtL3YrS6xx14BgiO7y1xKuDNb6RXcnEi9wm97lMmftKPb04eJdEeQAThIx6gD52ELho+fjKQd8rAfgC70pfIQQ+FzuIMoxlgEs5dGVKRjEvO2yQnP8q7Ie7JAxNB4NsjvH6xUEcj+EkKdbS7zfqdapGfVGJuZDxAEnyNbUYSlUABqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Brnn+Oyi7kiZwhPWQMTmZ8mRJS9il/Ut0vUBF1C7x1A=;
 b=YGHpn/DkeR76+pFFqZQ2i55PBDPTeT+cQ8xeBWFfkxVc19CtQYOx5ai8BA3fVQ5x7VWVOU3pVSJ+ugyw/yJdr14aaTlrYdXqaMJFzBjyqtb+ZvwY7vPlLQMXfPhacYFCkb5PVKoZf9A5i56fF9cJVQW6slKN6RHojYdtKNEH5+Kkq885KP6q0mTfqMCkTr1rReC3Rj42uc9eA9EHGYVTtKg0xcYVSwjYlwPZ+N+bXuYZ5SCpcqOZLhJLot+Kv2jzlWnpNmvy62sJuNjTdW7jA4dkLJc8DlH+Axn0cE4WGuDDeR2B7DPIZ7h5kX9pgM8vJFeKzOpcAE61CdKKhcFSVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Brnn+Oyi7kiZwhPWQMTmZ8mRJS9il/Ut0vUBF1C7x1A=;
 b=XSA4y2DNIdfBj/uYYZyv31jmewGXOm5IF6a6aN3aJTVEQrSoYTAmNHUKAetxUO902CeH1eM3CIjcQOSuBUl2vh9cHhXtMScSkfPYuO6PjQl+ZYcCj48L1PrXyZf4J5X/ieCF+v09JpJMLQKK4f5XHTRjv8lqoiO9MtYh72BhsbLYLdcke/lurOQo9V3j9jCt9RS27fI+qKaNMCXcoaP6EASqlgBRJ0iH7bqYJVGCLYA7agbuPw5itThr+Ke4oG7KomIvIWBG6nYtx4mUFIurn+iux1PcwDR+PvCaW0s+/gCjUeeu+SVbc4lnadhDEdg2xtDVMTL50tuja8GF80vPrQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB5182.namprd12.prod.outlook.com (2603:10b6:5:395::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Fri, 4 Feb
 2022 23:07:51 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4951.016; Fri, 4 Feb 2022
 23:07:51 +0000
Date:   Fri, 4 Feb 2022 19:07:50 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
Message-ID: <20220204230750.GR1786498@nvidia.com>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
 <20220202131448.GA2538420@nvidia.com>
 <a29ae3ea51344e18b9659424772a4b42@huawei.com>
 <20220202153945.GT1786498@nvidia.com>
 <c8a0731c589e49068a78afcc73d66bfa@huawei.com>
 <20220202170329.GV1786498@nvidia.com>
 <c6c3007e-3a2e-a376-67a0-b28801bf93aa@oracle.com>
 <20220203151856.GD1786498@nvidia.com>
 <e67654ce-5646-8fe7-1230-00bd7ee66ff3@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e67654ce-5646-8fe7-1230-00bd7ee66ff3@oracle.com>
X-ClientProxiedBy: BL0PR0102CA0065.prod.exchangelabs.com
 (2603:10b6:208:25::42) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 862db495-7993-48a3-7150-08d9e8332b0b
X-MS-TrafficTypeDiagnostic: DM4PR12MB5182:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB51827F3A1F63B3605E4049A9C2299@DM4PR12MB5182.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MUbSJ3yShiHO8kK5id7KNlXbKq4QjDBlw7efUO7ZtNX7FDKAOgw5iCPdrvYNaDHG/vY7f254f705sqSeV9WahBJJlSOMDnkC1aiYbEoNRfh5HdbLYmoIsF0JBdzSthl17nI90Ne2zWqaNY0RK0tFhDoRs+hwE5p6/GkFv/FUI+CRwl0JO3yDlc2pAWGxI4vU695p51yJalgnHHREtOOtaKLiDRBmiu60D29j/ve1gW4UiG6hJCCFuY8BCj1mRILarOtfRQ9E8L4V9k1Vv2CDOwBxWsbGKX6hxMtmnNNQdP+OruwGQyx2Ak3UtQOmoKQ7/1fYQekpCszc1zyypDqhlIEQkRU2Cvtf4gG2tEub3hgR+6vnsz5ZAlCLEoLenIro/yZEYRBIZUYKdVE3d0G0oKsTqHyGXbNGwvwYqyLzFI+hRS1ZJDgqHTaIGPtn1EX2kmVmf5JxDYkO96rTv6VGGJdq5nFPq+PYgT288X6FUhjgicR4UDWImhtakij7VRAtcG0V29cRYxj9ws5TLW9kulDi95wFU8gdg7Zl1X0OYyB3ssQW6jKQo34xRet3bt11qiu9sJW7bPIe1jx+8lOqQQucdY1pNnGENRhmwQgzXoTwN+l3qHzI62gVDR0oG3reY2A5RkV1XTjNh+fBY1vg2Gxcr5hH1ALi2IH9QBQAcwmxCdIOXPPGwmi8RcNKC3Zyy0P9qd+dxQDnU2ffYWVySQWxvE30ar2NorfwCCr78o4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(83380400001)(66946007)(8936002)(8676002)(66476007)(66556008)(5660300002)(6486002)(7416002)(38100700002)(2906002)(53546011)(36756003)(508600001)(86362001)(316002)(6512007)(966005)(1076003)(2616005)(186003)(26005)(6916009)(6506007)(54906003)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mgMdgSmf2Y8YAXDRYX1cM4fNh5PEWpKu2XWgKqBFVWK+UZLUqjLxc+qOVhIi?=
 =?us-ascii?Q?8Ew2K0ndz9pZIqqgxcOXBuqqFIhHzEhmFUVPSI6vM4CoxvHZxnQCNdOFf+pm?=
 =?us-ascii?Q?xagL3BOFsa4A+GOlnHseXT5DURH6AA6MEbJFL+UP6snc+i+rI7cOa/9DEEGa?=
 =?us-ascii?Q?2FFj5Lgdhu0tX3s5fGVVvayBYkvcdp8fA+oEeQaYHTukK7aWFASRcH3+olEv?=
 =?us-ascii?Q?OfpzlCmcBas0qjlV+wJVEcTgVTfKDViHw1+yiXxswn7W6XJ3b1U61kgW5/SC?=
 =?us-ascii?Q?xzjlP+C5RlP9dnS2xO+wRhwIgCfKjpd9bVsTSfEQgObiN8d4KYTPOnJ/ck7D?=
 =?us-ascii?Q?PHX9QVKXHbUyQEH25WzvzEgkNxiElUMp/TNbh6LZhQP7RQR+tMvCXkWvuHGJ?=
 =?us-ascii?Q?zDJHQfpQXqQ1XN0xTBPSZipzDcl3y2AdnXFmyBF++yv3bPfKMTmAxJqgTDDC?=
 =?us-ascii?Q?T2f/T6kyKNhUfaHdBgL4Ld1xHgGn+zEB9I9hBAmBdnVreZWSW1ClpS+3A0ol?=
 =?us-ascii?Q?RCCS2dfPzTZPNAOWNJiw3gHX4HJhlTWNL/slXA6o2MQgJz8+S4GkEZCGzRmM?=
 =?us-ascii?Q?SYlyfLkgER6y6a2KzPI36gxDO7rV1PFP/zjdyVlLEjx4643WBjqhr9dz4Kga?=
 =?us-ascii?Q?Tq0eWa9bwdeGSRehjeaqx1WmXHCJRtM3RimTeyHARVcFC7DRZz6Z6sNxEGYl?=
 =?us-ascii?Q?5FTkaCwJEPbX7yvc/rNmLeTwSZYPtO27jf70selLEbzpCeLnEX87CtdxzFFW?=
 =?us-ascii?Q?yYjJJ55v0JceFoPJdgmyRM8+OJ35iRt574lmcbY4w4SjNUyW8hLQfmbDscwl?=
 =?us-ascii?Q?124xHjWb3n9YfBpTke/wtL58Z/s34LcUlX45bHdT3KV57s/OmJBMU8Sp+IJd?=
 =?us-ascii?Q?thjyFMkJmTMPPAd1UOtruyGJuRzAC/paXwMfndvjK46+v3KwlB72ME5AqBkc?=
 =?us-ascii?Q?9khC5PsA7CUXdDt4wuTU5JMKbPif4CoKARLWU5uHOI3Du9IBNQq/kkxjeBo+?=
 =?us-ascii?Q?yIRXNrBaTcy0RFQ45qfoOSsDbA0xRoftrxSqgmx0oMdbdroQKawDmRSBFmxE?=
 =?us-ascii?Q?Sxw0tAoEuD2g9omJYsKg4fHMMsxtPmete7h5/UeLWqej8gmugFzgVf/dezEy?=
 =?us-ascii?Q?oAn+cXa8FTXWNdr48pc5/ojzKujSIUoQSm+uqmbgZnaGK/dDash4xp0Ruwi9?=
 =?us-ascii?Q?qeODqYiPIwZhSXzZ8aSYXOGUotnGu3iEjor202GMRIYOMxq7bp7l64BFPUsL?=
 =?us-ascii?Q?w7teqgXB/rrNL8Ai1GwfSF3YVB2pKrIlnRQEVRUSyMkSPWznTThrdeD62ZiB?=
 =?us-ascii?Q?G2j7uhBScwdo9ke2NXTtkMWqZ1NaTwyGAP1pCo3StfEi3/pLFJnSnAD/+oOu?=
 =?us-ascii?Q?o7iyBUHWUcU/haxYv5Bns23TkYzVuvCGPXKmLTDOT3qulsG3NW7dHJrBXdjS?=
 =?us-ascii?Q?dZ94ipRSkBT7fUPPsNrB4UmN5vUeFYqDJXzJxbGa9wvKjP4j0FhxGnbkawsV?=
 =?us-ascii?Q?GH3SogOvZLzd2X6a5/e8HzNsjCy+W0kpg5acYgh6d8KAlZn0JZvS8DGCJudx?=
 =?us-ascii?Q?t+YJFZDGm16t2s30lPE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 862db495-7993-48a3-7150-08d9e8332b0b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2022 23:07:51.5594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AEBx87RxTpLC37JNTVCztSPdLc4s12EGNY9d9kRn3CMAYVdDRTfPXw2hmoduR5PD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5182
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 04, 2022 at 07:53:12PM +0000, Joao Martins wrote:
> On 2/3/22 15:18, Jason Gunthorpe wrote:
> > On Wed, Feb 02, 2022 at 07:05:02PM +0000, Joao Martins wrote:
> >> On 2/2/22 17:03, Jason Gunthorpe wrote:
> >>> how to integrate that with the iommufd work, which I hope will allow
> >>> that series, and the other IOMMU drivers that can support this to be
> >>> merged..
> >>
> >> The iommu-fd thread wasn't particularly obvious on how dirty tracking is done
> >> there, but TBH I am not up to speed on iommu-fd yet so I missed something
> >> obvious for sure. When you say 'integrate that with the iommufd' can you
> >> expand on that?
> > 
> > The general idea is that iommufd is the place to put all the iommu
> > driver uAPI for consumption by userspace. The IOMMU feature of dirty
> > tracking would belong there.
> > 
> > So, some kind of API needs to be designed to meet the needs of the
> > IOMMU drivers.
> > 
> /me nods
> 
> I am gonna assume below is the most up-to-date to iommufd (as you pointed
> out in another thread IIRC):
> 
>   https://github.com/jgunthorpe/linux iommufd
> 
> Let me know if it's not :)

The iommufd part is pretty good, but there is hacky patch to hook it
into vfio that isn't there, if you want to actually try it.

> > But, as you say, it looks unnatural and inefficient when the domain
> > itself is storing the dirty bits inside the IOPTE.
> 
> How much is this already represented as the io-pgtable in IOMMU internal kAPI
> (if we exclude the UAPI portion of iommufd for now) ? FWIW, that is today
> used by the AMD IOMMU and ARM IOMMUs. Albeit, not Intel :(

Which are you looking at? AFACIT there is no diry page support in
iommu_ops ?

> then potentially VMM/process can more efficiently scan the dirtied
> set? But if some layer needs to somehow mediate between the vendor
> IOPTE representation and an UAPI IOPTE representation, to be able to
> make that delegation to userspace ... then maybe both might be
> inefficient?  I didn't see how iommu-fd would abstract the IOPTEs
> lookup as far as I glanced through the code, perhaps that's another
> ioctl().

It is based around the same model as VFIO container - map/unmap of
user address space into the IOPTEs and the user space doesn't see
anything resembling a 'pte' - at least for kernel owned IO page
tables.

User space page tables will not be abstracted and the userspace must
know the direct HW format of the IOMMU they is being used.

> But what strikes /specifically/ on the dirty bit feature is that it looks
> simpler with the current VFIO, the heavy lifting seems to be
> mostly on the IOMMU vendor. The proposed API above for VFIO looking at
> the container (small changes), and IOMMU vendor would do most of it:

It is basically the same, almost certainly the user API in iommufd
will be some 'get dirty bits' and 'unmap and give me the dirty bits'
just like vfio has.
 
The tricky details are around how do you manage this when the system
may have multiple things invovled capable, or not, of actualy doing
dirty tracking.

> At the same time, what particularly scares me perf-wise (for the
> device being migrated) ... is the fact that we need to dynamically
> split and collapse page tables to increase the granularity of which
> we track. In the above interface it splits/collapses when you turn
> on/off the dirty tracking (respectively). That's *probably* where we
> need more flexibility, not sure.

For sure that is a particularly big adventure in the iommu driver..

> Do you have thoughts on what such device-dirty interface could look like?
> (Perhaps too early to poke while the FSM/UAPI is being worked out)

I've been thinking the same general read-and-clear of a dirty
bitmap. It matches nicely the the KVM interface.

> I was wondering if container has a dirty scan/sync callback funnelled
> by a vendor IOMMU ops implemented (as Shameerali patches proposed), 

Yes, this is almost certainly how the in-kernel parts will look

> and vfio vendor driver provides one per device. 

But this is less clear..

> Or propagate the dirty tracking API to vendor vfio driver[*]. 
> [*] considering the device may choose where to place its tracking storage, and
> which scheme (bitmap, ring, etc) it might be.

This has been my thinking, yes

> The reporting of the dirtying, though, looks hazzy to achieve if you
> try to make it uniform even to userspace. Perhaps with iommu-fd
> you're thinking to mmap() the dirty region back to userspace, or an
> iommu-fd ioctl() updates the PTEs, while letting the kernel clear
> the dirty status via the mmap() object. And that would be the common
> API regardless of dirty-hw scheme. Anyway, just thinking out loud.

My general thinking has be that iommufd would control only the system
IOMMU hardware. The FD interface directly exposes the iommu_domain as
a manipulable object, so I'd imagine making userspace have a simple
1:1 connection to the iommu_ops of a single iommu_domain.

Doing this avoids all the weirdo questions about what do you do if
there is non-uniformity in the iommu_domain's.

Keeping with that theme the vfio_device would provide a similar
interface, on its own device FD.

I don't know if mmap should be involed here, the dirty bitmaps are not
so big, I suspect a simple get_user_pages_fast() would be entirely OK.

> > VFIO proposed to squash everything
> > into the container code, but I've been mulling about having iommufd
> > only do system iommu and push the PCI device internal tracking over to
> > VFIO.
> > 
> 
> Seems to me that the juicy part falls mostly in IOMMU vendor code, I am
> not sure yet how much one can we 'offload' to a generic layer, at least
> compared with this other proposal.

Yes, I expect there is very little generic code here if we go this
way. The generic layer is just marshalling the ioctl(s) to the iommu
drivers. Certainly not providing storage or anything/

> Give me some time (few days only, as I gotta sort some things) and I'll
> respond here as follow up with link to a branch with the WIP/PoC patches.

Great!
  
> 3) Dirty bit is sticky, hardware never clears it. Reading the access/dirty
> bit is cheap, clearing them is 'expensive' because one needs to flush
> IOTLB as the IOMMU hardware may cache the bits in the IOTLB as a result
> of an address-translation/io-page-walk. Even though the IOMMU uses interlocked
> operations to actually update the Access/Dirty bit in concurrency with
> the CPU. The AMD manuals are a tad misleading as they talk about marking
> non-present, but that would be catastrophic for migration as it would
> mean a DMA target abort for the PCI device, unless I missed something obvious.
> In any case, this means that the dirty bit *clearing* needs to be
> batched as much as possible, to amortize the cost of flushing the IOTLB.
> This is the same for Intel *IIUC*.

You have to mark it as non-present to do the final read out if
something unmaps while the tracker is on - eg emulating a viommu or
something. Then you mark non-present, flush the iotlb and read back
the dirty bit.

Otherwise AFIAK, you flush the IOTLB to get the latest dirty bits and
then read and clear them.

> 4) Adjust the granularity of pagetables in place:
> [This item wasn't done, but it is generic to any IOMMU because it
> is mostly the ability to split existing IO pages in place.]

This seems like it would be some interesting amount of driver work,
but yes it could be a generic new iommu_domina op.

> 4.b) Optionally starting dirtying earlier (at provisioning) and let
> userspace dynamically split pages. This is to hopefully minimize the
> IOTLB miss we induce ourselves in item 4.a) if we were to do eagerly.
> So dirty tracking would be enabled at creation of the protection domain
> after the vfio container is set up, and we would use pages dirtied
> as a indication of what needs to be splited. Problem is for IO page
> sizes bigger than 1G, which might unnecessarily lead to marking too
> much as dirty early on; but at least it's better than transferring the
> whole set.

I'm not sure running with dirty tracking permanently on would be good
for guest performance either.

I'd suspect you'd be better to have a warm up period where you track
dirtys and split down pages.

It is interesting, this is a possible reason why device dirty tracking
might actually perfom better because it can operate at a different
granularity from the system iommu without disrupting the guest DMA
performance.

Jason
