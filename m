Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54A8396798
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 20:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbhEaSKz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 14:10:55 -0400
Received: from mail-bn8nam11on2064.outbound.protection.outlook.com ([40.107.236.64]:43233
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230288AbhEaSKy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 May 2021 14:10:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P+cD8K8ey2D2adIEWPY1SA+SyIgh3WlErskV+2knTcwTwt2vTN73c1/FBB1i31w/1QVIEczeQtRBGajBfL2JHNsgfh8Ax6NEV/XY93yRbE9awpy3oMtXUMgqVBSv+xF0tQzQVqVnNFndrl4BXW8jQPc9Ps3/PhQ3riGLLy/3xGYTKFmmRx1fQPBl9j2AXti3qaHM6hJn2VfhdMky1hvnSGhOzyx8zCW4hQOOuwhNnltWAjm08VIbJ79coAQNDruYEBpEddRxT5Vwm/ACWZXFDkg3wcGUM7ggfAuIczgVVmDhR5V+6cnldsGArCEoH3w2cISl50rFaH0bQN6F8cm3fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NdRQbeK3JZGKBqmPI+0ciKIAVpaPAYYFIpEt9SlB9vE=;
 b=X2b2/sS5sKpZsw9poKHRTw9VMxS59JlSXzX7bcbRdArzrZWaMr2j3WFkwj6J0w0lcCRSMWYekYiJAl+bJ5vva18fFoQdZ3JpueAPzGsI6Xgq9VYfz/nf6Xkzqvww/KLbCzbHAVcpc22F3UWacT3UErJg/T7+3KE08BmYxQl462HKZakPafhDmFvE+Drrvh3dcst7dV+OeZHxk2ItljRg2BAMZJMJqJ2/9cUP59bEOgztpzF8T1vCaDPfK4mUdD6xnNI3uhSwMgp7mvPdy3kWCEkjwO6pvEaiCSXhjojWeIQObNvJglJN90/n61GDsTcJMrNaxkQtcFNZ9pfC35lz/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NdRQbeK3JZGKBqmPI+0ciKIAVpaPAYYFIpEt9SlB9vE=;
 b=b2AIiji/2zeC+pKv6BKHI72ADHiXqUjSQhDF4B/hAsg4Q3jcCnBLkEorGwA9gZMPaGfKoWx/YM6ozCMUXybDrcxUHheNKJ96n3SDFE4FzAPYVHlG7x9Plt9WGMLMU5jMlWs1VAO1bwkpFzsQUk2Q0LKRpwTaOqefFjKo1412OfSSxmUqNeFtrSPgen8EVaX2UV8rPVhTJecCymtFmWRowvjxdg+55ULHjuvELPKVdsIJShEnM7oD8ZLoDtAQFNxrUPiiAr5V/1rt0V2IegsWQsXmk277kqdDD2mOtBQPOSiNmrFxwyaBTY5mGOj1lynHbZwKXvls+zdWjPiJzSoiyg==
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Mon, 31 May
 2021 18:09:12 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4173.030; Mon, 31 May 2021
 18:09:12 +0000
Date:   Mon, 31 May 2021 15:09:11 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Liu Yi L <yi.l.liu@linux.intel.com>
Cc:     yi.l.liu@intel.com, "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Jiang, Dave" <dave.jiang@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210531180911.GX1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528233649.GB3816344@nvidia.com>
 <20210531193157.5494e6c6@yiliu-dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531193157.5494e6c6@yiliu-dev>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0232.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::27) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0232.namprd13.prod.outlook.com (2603:10b6:208:2bf::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.9 via Frontend Transport; Mon, 31 May 2021 18:09:12 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lnmLf-00HD1I-GL; Mon, 31 May 2021 15:09:11 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0cabc7f-f046-4694-79bf-08d9245f3198
X-MS-TrafficTypeDiagnostic: BL0PR12MB5506:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB5506FA6717CB775B609E9D88C23F9@BL0PR12MB5506.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g7DnMjaVkkHIIGoty9PosiFDXi8s02q5RQP41MRFOO5v6yUGViinl7JAlSxeNzByxFCx1GVeIUqZSa4qF6QVGNxmW09qSbraf1iRf4RVYwoQ9i4iwQ4YYleClaKgTBqFG9ChYul7APQMTXXHb0ceaHlWhnVy/7cJJ7WquYG13rXfnCT3Y2vFHNqFGomeeBSbihdWgenT+OCnFn75vVSmDapEy1HiLRK99FC0RGBxQc+q1SdqDj6WQO5apOiL1IdAeIoGLQs6nZhjhj1GYiqlWuGah0yNrNYMxMEypubo7MUhHX94OKU0ejmgaipttO/AGJmx4U7+NPqsG903kmkTwpwvAcrlOY5TOMg7NLYlqfbZiqcQZXVFWY8vXbSCyecTqBSTka0FuhkoC8/2HbvTPiP23sRZ0RrQLq4xcdn+ABzzcozsG282HPAh3AhQ/ISTE2N9sabuDnZwUt0UC9bGTVc8jLML6qxC5z/VCDNZdZ4btipbgoEp72pae40dPOFXbWAyRoOkWfFK5CslnafKuejdbnGMBh9oPOU4dH/A9hAR/R7WlHAzip4Xf+ldFW1MkheZsPk9KWB4gr2XRgGRl5qPPWoQPbhYbpDOnqA8ATc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(66476007)(54906003)(26005)(2616005)(38100700002)(8676002)(83380400001)(1076003)(6916009)(9786002)(86362001)(186003)(9746002)(316002)(66556008)(426003)(66946007)(4326008)(36756003)(478600001)(5660300002)(2906002)(8936002)(33656002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IAnH8y6ghx1HA+e50OzD1mc3sMpMk+BSDrgl927fjCHLMBVqCo512iasHSWg?=
 =?us-ascii?Q?iGc2ogZ6DB7XSqOI+h57Hyhq13VaOJaIyet0j0Y7GOim/wGpqttrztcmGhLR?=
 =?us-ascii?Q?CvSwaDEDd4UNdAz6Tl2CwITTFL5N/fKXffFhfUVEIJarn0j2uS2muWT+iit9?=
 =?us-ascii?Q?n6ngXHu/4dWbS9A0YQHiXMFR/3IswF4648uUgl8NVV8/1vOAv2KxVE63ariU?=
 =?us-ascii?Q?DqTLxhr8HC2pQhQ4CwUfrP6kpHECzSNCyI2cMrpfl66SxG59ZAwhB9pgeaC/?=
 =?us-ascii?Q?6N2L/wHWQVr1k64Drc56bTbrI7oIb2KEZJA8W6gpO/GUhiPPRRjkKoazyYl6?=
 =?us-ascii?Q?CzVb7R/pPVgrei9hYWY75/ghVozIH5e5ldgu/Dy33nkM7HZmd6jQQ9rUsiDJ?=
 =?us-ascii?Q?DFOmm7rlX+1uvqCRfBQI3tk6/t/JKst28Dj8yQtw64615DoenWyqn4uZfB55?=
 =?us-ascii?Q?BoxDyucZBkbhNEEvd/bVKMGmWT318VV5Lg2tOB33wuZNtCjDbWZOykVxDiMj?=
 =?us-ascii?Q?s/wwMTjogxwRRQKs7w3skZqoOf6N2NbzjI0ARKbdx0wdDAbXps6NDArr0Ewv?=
 =?us-ascii?Q?QBYGQY2sINBVpqQjd4/rMIct97pTAg1mzpC0N+eaiJ92s4g7TYhg22xs00S1?=
 =?us-ascii?Q?Bxv2cowlOXKn+vP9wsfU5D46nZ+pP6InN1ZH3OKYR96f2liyrDp8Ec4hQpAP?=
 =?us-ascii?Q?8GQPQZqzD8ZCGnZOa77t7lbZCHMpiLm1y4iHtDaVfn1sXwW0rEaVWiMCFLeB?=
 =?us-ascii?Q?4kP2hT66YyaP63TENOlIekHvVI696NTWPCRiafbDbGROqfUTrMESKRK+7i+g?=
 =?us-ascii?Q?pICur3p3S955xzaH58BBjBU06SHPdiyIr3K0bgOg7Vx8AiQwulQ1HZKyIOjN?=
 =?us-ascii?Q?JtDKH+0cQ0vZfhDR1p/NVnZQRLw5qLvChQYXAbMjh6H5t58zTOjlede7ZOzd?=
 =?us-ascii?Q?/gHNQHL4bWnLYL6IVEIEBq9166DMh//XMoWXl5CjAw5ZX1zS1878yD0Y7YYc?=
 =?us-ascii?Q?IlE6snizGvKjHf9C4dI/+pwQm2lSIrxjRSf+fafZaPg7rYI+6R0dgDOSTPvf?=
 =?us-ascii?Q?DlMgjnQtw9mBx4Vaac5mdig1wlvZN80nzhlMnT/dqpowTs7jV9yHmVnvDBwT?=
 =?us-ascii?Q?4WMsq5P/DVOi2rPYJL6/oYSRUioyZhvNY2t44P5Wg9k0bP3UsquwYUis5crK?=
 =?us-ascii?Q?4XxcKh9CEHf5t4AFt4xSv22nF+teaVOOKkLe5DlpD+tZ5JRcox93ctCI+7Iv?=
 =?us-ascii?Q?qP4h3QN05ZqSVthVUhXCf8DKRBX3j4yJAgTNBL0fCyvfb0/canVFS3TFaw7g?=
 =?us-ascii?Q?W5ZS3pLMRu2o/DD5n8zE2dvy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0cabc7f-f046-4694-79bf-08d9245f3198
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2021 18:09:12.4206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s9PUO/8UDASyIo929hB4RTpLCb0X7TjfPVTpVjyvNwki5Zct1CUEEOk1LLW9+PJt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5506
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 31, 2021 at 07:31:57PM +0800, Liu Yi L wrote:
> > > /*
> > >   * Get information about an I/O address space
> > >   *
> > >   * Supported capabilities:
> > >   *	- VFIO type1 map/unmap;
> > >   *	- pgtable/pasid_table binding
> > >   *	- hardware nesting vs. software nesting;
> > >   *	- ...
> > >   *
> > >   * Related attributes:
> > >   * 	- supported page sizes, reserved IOVA ranges (DMA mapping);
> > >   *	- vendor pgtable formats (pgtable binding);
> > >   *	- number of child IOASIDs (nesting);
> > >   *	- ...
> > >   *
> > >   * Above information is available only after one or more devices are
> > >   * attached to the specified IOASID. Otherwise the IOASID is just a
> > >   * number w/o any capability or attribute.  
> > 
> > This feels wrong to learn most of these attributes of the IOASID after
> > attaching to a device.
> 
> but an IOASID is just a software handle before attached to a specific
> device. e.g. before attaching to a device, we have no idea about the
> supported page size in underlying iommu, coherent etc.

The idea is you attach the device to the /dev/ioasid FD and this
action is what crystalizes the iommu driver that is being used:

        device_fd = open("/dev/vfio/devices/dev1", mode);
        ioasid_fd = open("/dev/ioasid", mode);
        ioctl(device_fd, VFIO_BIND_IOASID_FD, ioasid_fd);

After this sequence we should have most of the information about the
IOMMU.

One /dev/ioasid FD has one iommu driver. Design what an "iommu driver"
means so that the system should only have one. Eg the coherent/not
coherent distinction should not be a different "iommu driver".

Device attach to the _IOASID_ is a different thing, and I think it
puts the whole sequence out of order because we loose the option to
customize the IOASID before it has to be realized into HW format.

> > The user should have some idea how it intends to use the IOASID when
> > it creates it and the rest of the system should match the intention.
> > 
> > For instance if the user is creating a IOASID to cover the guest GPA
> > with the intention of making children it should indicate this during
> > alloc.
> > 
> > If the user is intending to point a child IOASID to a guest page table
> > in a certain descriptor format then it should indicate it during
> > alloc.
> 
> Actually, we have only two kinds of IOASIDs so far. 

Maybe at a very very high level, but it looks like there is alot of
IOMMU specific configuration that goes into an IOASD.


> > device bind should fail if the device somehow isn't compatible with
> > the scheme the user is tring to use.
> 
> yeah, I guess you mean to fail the device attach when the IOASID is a
> nesting IOASID but the device is behind an iommu without nesting support.
> right?

Right..
 
> > 
> > > /*
> > >   * Map/unmap process virtual addresses to I/O virtual addresses.
> > >   *
> > >   * Provide VFIO type1 equivalent semantics. Start with the same 
> > >   * restriction e.g. the unmap size should match those used in the 
> > >   * original mapping call. 
> > >   *
> > >   * If IOASID_REGISTER_MEMORY has been called, the mapped vaddr
> > >   * must be already in the preregistered list.
> > >   *
> > >   * Input parameters:
> > >   *	- u32 ioasid;
> > >   *	- refer to vfio_iommu_type1_dma_{un}map
> > >   *
> > >   * Return: 0 on success, -errno on failure.
> > >   */
> > > #define IOASID_MAP_DMA	_IO(IOASID_TYPE, IOASID_BASE + 6)
> > > #define IOASID_UNMAP_DMA	_IO(IOASID_TYPE, IOASID_BASE + 7)  
> > 
> > What about nested IOASIDs?
> 
> at first glance, it looks like we should prevent the MAP/UNMAP usage on
> nested IOASIDs. At least hardware nested translation only allows MAP/UNMAP
> on the parent IOASIDs and page table bind on nested IOASIDs. But considering
> about software nesting, it seems still useful to allow MAP/UNMAP usage
> on nested IOASIDs. This is how I understand it, how about your opinion
> on it? do you think it's better to allow MAP/UNMAP usage only on parent
> IOASIDs as a start?

If the only form of nested IOASID is the "read the page table from
my process memory" then MAP/UNMAP won't make sense on that..

MAP/UNMAP is only useful if the page table is stored in kernel memory.

> > > #define IOASID_CREATE_NESTING	_IO(IOASID_TYPE, IOASID_BASE + 8)  
> > 
> > Do you think another ioctl is best? Should this just be another
> > parameter to alloc?
> 
> either is fine. This ioctl is following one of your previous comment.

Sometimes I say things in a way that is ment to be easier to
understand conecpts not necessarily good API design :)

> > > #define IOASID_BIND_PGTABLE		_IO(IOASID_TYPE, IOASID_BASE + 9)
> > > #define IOASID_UNBIND_PGTABLE	_IO(IOASID_TYPE, IOASID_BASE + 10)  
> > 
> > Also feels backwards, why wouldn't we specify this, and the required
> > page table format, during alloc time?
> 
> here the model is user-space gets the page table format from kernel and
> decide if it can proceed. So what you are suggesting is user-space should
> tell kernel the page table format it has in ALLOC and kenrel should fail
> the ALLOC if the user-space page table format is not compatible with underlying
> iommu?

Yes, the action should be
   Alloc an IOASID that points at a page table in this user memory,
   that is stored in this specific format.

The supported formats should be discoverable after VFIO_BIND_IOASID_FD

> > > /*
> > >   * Page fault report and response
> > >   *
> > >   * This is TBD. Can be added after other parts are cleared up. Likely it 
> > >   * will be a ring buffer shared between user/kernel, an eventfd to notify 
> > >   * the user and an ioctl to complete the fault.
> > >   *
> > >   * The fault data is per I/O address space, i.e.: IOASID + faulting_addr
> > >   */  
> > 
> > Any reason not to just use read()?
> 
> a ring buffer may be mmap to user-space, thus reading fault data from kernel
> would be faster. This is also how Eric's fault reporting is doing today.

Okay, if it is performance sensitive.. mmap rings are just tricky beasts

> > >    * Bind a vfio_device to the specified IOASID fd
> > >    *
> > >    * Multiple vfio devices can be bound to a single ioasid_fd, but a single
> > >    * vfio device should not be bound to multiple ioasid_fd's.
> > >    *
> > >    * Input parameters:
> > >    *  - ioasid_fd;
> > >    *
> > >    * Return: 0 on success, -errno on failure.
> > >    */
> > > #define VFIO_BIND_IOASID_FD           _IO(VFIO_TYPE, VFIO_BASE + 22)
> > > #define VFIO_UNBIND_IOASID_FD _IO(VFIO_TYPE, VFIO_BASE + 23)  
> > 
> > This is where it would make sense to have an output "device id" that
> > allows /dev/ioasid to refer to this "device" by number in events and
> > other related things.
> 
> perhaps this is the device info Jean Philippe wants in page fault reporting
> path?

Yes, it is

Jason
 
