Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DCD394929
	for <lists+kvm@lfdr.de>; Sat, 29 May 2021 01:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhE1Xia (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 May 2021 19:38:30 -0400
Received: from mail-dm3nam07on2065.outbound.protection.outlook.com ([40.107.95.65]:22081
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229500AbhE1Xi3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 May 2021 19:38:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R+ymdu4vCnUA7KJ0Lq7tCNEfHSa9oU74kx2G6tL8RXf5gFaGNP7zDTu9bppxSOEdOUHPyQe1xE8Cg6jJVRdsojNyr4ogfULkwTMyiCD5fTDBDSwbyB0tTfcRjmwh3gj7WpT50fhJMZlxiSjINkQLQvD4zoSq5O9ygMn6jox0RTvgWQ/4v5G3emhzEavxMYhSFkaXLI5tmg9SO8ZdDg7OCShqgp2jLQmGdpKi/XanaTgTbl3PF9jKf4kPo5FTnW0gwYkP0CuKSGoc57wY5irHoALZSCFvS7ndt0XBfr7/yWpzu52C30NzLkNefcYtDuQ0IcpHXyW9K6NqK1MNRyJhYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VuW7QaepbLrrpk66HYKCuX+aFGairZ3NyDd11m97VUk=;
 b=HqA2KnWTJ0b/rI4L1sCCAMtxuVBPzkvXcHMPul3q1iGI7o0eSi9fCnNvCajZTDi4b4Gpa8y82GFeRIMuBLp3bXXJi9xukQ5+vkx6f8U43Czk65VWOnwwnpSColhVLRZxZ2toA2o7BAlXKb80t7myXrae44/D/Ma41JmMDCXRxUPoXqpQLoPsU+ViHDMa6soVmtuGr3scApfWgbBfQm+VGMac4dg6sChtvmr2VX1p3ytaYGfIAromEbTulzqx/syMM0jSvFSqUIyTW0PpAE1Qjut7H9D9bAKTHJKPeZ7Zjm64sPXLAKnhO1+BvNLvJ6AfjArz+KHSNhJOscpR++Ieiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VuW7QaepbLrrpk66HYKCuX+aFGairZ3NyDd11m97VUk=;
 b=ttsszplEheZ1zuGeW7xEgfSf8A+MizlIl1lW8fve7Eg2M31PryuPaLqEysEa+2QlADczqyg60OT1jOhKESPVG+yOnLlaUUuJJom3MPzS+4HIw1yoV1x9o54FEwGlcKl4JXj95uLTDAcLktpyBg6JURREFUCbh6X7jWt/HxQ/SbYGC3Hjp064I18L1398kfeQcnP4j/hmUe7HWfAaDGXu0YuyB5Xbo4wUf7DgaYEXynuKugO44Cf970Phx12KWj55BEJcU5RvPYdafSYMhcSKwtL/Nxe1cgGjWKrfnU00jFceP8Z1QFFX/7nr4a8MApe9gcQlVoUEtc7O+FAhUfE8EQ==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5159.namprd12.prod.outlook.com (2603:10b6:208:318::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Fri, 28 May
 2021 23:36:50 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4173.023; Fri, 28 May 2021
 23:36:50 +0000
Date:   Fri, 28 May 2021 20:36:49 -0300
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
Message-ID: <20210528233649.GB3816344@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0369.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::14) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0369.namprd13.prod.outlook.com (2603:10b6:208:2c0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.9 via Frontend Transport; Fri, 28 May 2021 23:36:50 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lmm25-00GDog-5S; Fri, 28 May 2021 20:36:49 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05735405-27e1-4859-5bdc-08d922317762
X-MS-TrafficTypeDiagnostic: BL1PR12MB5159:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5159E5D7376372ED76ADC69DC2229@BL1PR12MB5159.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QSKCVneVLgXmSdibXkNJ1yE7VXfT5zclyTnPMgbhAKg8pqqvQCBY8mbzPhOLv8WO9DTja0j/krKfUCYJ1SRlj182S5V1R0fzP7BVCe+uXS3ts+FhtOvZ/QsxOGATMYMQ0k+wfr1/+GaRCkXUDE1RF75QY5nndpU+srm1J7b6+Vc0hAY3sUIg6fxOTWrd+K7cGFWf6VTF7PiY9aJamO9Ay4Uc1FymLjXqsH2hLBlQDtRxzYStluNrGkMCM/vECArSrjyskjN/5xQ7Ibk1B/YFZvmkCfjRVmHCVMw/hDhKCDVe++0Q1K4xBV9vRNFt8ksq3V2xOR0BDRCMlwwkdkQJ+SMAm13z6O4q3uY5PQp1Yo2eILZPqsxFVwSTSYASZhvn/pWOs3fswIY/3zSRzCShfFR3WB9NeOpvC0BXQzYVzXFDepXeJMoz6mCGeTv9utkYGBbZV82jhkYZ1mN3/NsS19rbhhpjSqiAqo1YVuLYd+Kirhsgw4880JWYAxRNX+UTJrPLEVkBFV24Ha7x4ftqoncYha2hy65wFbGTogBPj2kyFlJ/mHIywcu4C9BmbAeobuVkdg/VRebDqAcROM/WvE1EUDqlea+vxLdpQFTC7Yg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(39860400002)(346002)(396003)(86362001)(83380400001)(8676002)(6916009)(316002)(2616005)(186003)(2906002)(30864003)(426003)(1076003)(66556008)(66476007)(66946007)(26005)(5660300002)(33656002)(38100700002)(9786002)(9746002)(54906003)(478600001)(4326008)(7416002)(36756003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hrj4BuqYqQitHmneZ08DazhXfC8iF6HZdPCCgaZzhXwkj+58MeS5ebhZBGOU?=
 =?us-ascii?Q?hezC6UV9Th/8CrqE+8Usj+pmSK5H160YLD+lKOAugLrskL7O7zOnfazOLIL8?=
 =?us-ascii?Q?tbzgPC/aqoMZX3wrTOzpYZ6vopaYKocwn/FSHpDbq/p7h9IutnlERpbHZ1jO?=
 =?us-ascii?Q?YX8I5D4bDE2ufyTAGyd2pngjkj+GVEQ19RrM2yMUxSiyl9hlW/+Zl3uL2l/p?=
 =?us-ascii?Q?NA6ts2IaAoRkFJm7TnX+fGmLXkYq0dlF3W0zo++zbHTFFGNg89dWKYzA4EQR?=
 =?us-ascii?Q?PY/+IQ3CLahN96nJZIldWrXgRYqnizkTyTZa4keHB/uqQC65KKLc/rSdQP9x?=
 =?us-ascii?Q?4aEvnOh7XmljUkOlGmi74i1FaB84gylsYuZgFVB7lPRMefSxl3W0bAGUZFhQ?=
 =?us-ascii?Q?k6H1hxstKgOEqCmyzre/+nzxvaNMhcIovSMXrjexcUeKt6KGm6cKqO26Z70E?=
 =?us-ascii?Q?DouzQ6g5z8w9A2xOPD7J31PjQFur1LOmo8T8nCGhMYPiTdR4SA15hVDRjgYR?=
 =?us-ascii?Q?WAB+u/CzSv+VsQXTL7+uk4ckX5fO4lY4BrLyLDvvOvcM/xIs2xtcuacBjYN4?=
 =?us-ascii?Q?fzDMRZnKtuXfap2fGvBq/VL/1IZUgRCFszT/IvyTnr2akmK1SV06aU3SYGAG?=
 =?us-ascii?Q?3z+F+R9a3Oj2pAlOnH5Es2XZg9Y8+WhnZV/NkiZcqhx4oyCLAqtzBBJ0ftfF?=
 =?us-ascii?Q?z2ROBSU/6WOHhsCnjuJErLj5zq/+3zgBVExmbpKIvkxERhCWy+mJR9/4F40e?=
 =?us-ascii?Q?dWSf3dTJ+YjclFdG3edKpKXoS4rLi659gvJOAE0yBdcsx9Cmurv8JCH03CkN?=
 =?us-ascii?Q?hJbK4MFxIcn/T3/g+65aYmRawp+2KnRpmZ0xd6T/Zug3j/feBR54f4DlP0dJ?=
 =?us-ascii?Q?9pKK5VHi9Vcnu3Adw0bpWbdQoTaSkEPzNcSQY1ZJtxQMWRlemlzntYawjxVt?=
 =?us-ascii?Q?m7riuw5REO7RkZDFkw741ENALbZ5mY9518RdIIgkAju/hqbBFUcZKUxzMpK2?=
 =?us-ascii?Q?wGr2mmlQTo9ZAGpIfLsf21U6G4qgMRtG2ZXbMULs8r0MoINhjfpcgRz0wb3f?=
 =?us-ascii?Q?+X8hefrBg2si+SoApLH9gCzcvxftwoR+atZuP2sSKv+gSHmGJ8dZmrkmNzus?=
 =?us-ascii?Q?OHXgZua8ij/5GuTgSASWUW7nKHrsJph4QY+ZHB4fuiApq0Jzv7dVM6ml2ghr?=
 =?us-ascii?Q?xE+GvBEPUX2Gefz0Pkdum1uA5tQZX+FtjkHwYse9jAH8T4hMAUbTGb/+SYdg?=
 =?us-ascii?Q?LYTLDMJGY0X8aSeFIdJJmH0zlhNWQk3TZ3x1ZmuBmznGtM0Xde08PImr8LhJ?=
 =?us-ascii?Q?0Gpblvtpr4jWY3ByU1QHaaP+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05735405-27e1-4859-5bdc-08d922317762
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 23:36:50.3224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fO+EHp2AvczxXk41rwjRIbWMIMrAlzhE6Bve2elZp/adOjGTPv3hZS3eCqtpqGnz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5159
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 27, 2021 at 07:58:12AM +0000, Tian, Kevin wrote:

> 2.1. /dev/ioasid uAPI
> +++++++++++++++++
> 
> /*
>   * Check whether an uAPI extension is supported. 
>   *
>   * This is for FD-level capabilities, such as locked page pre-registration. 
>   * IOASID-level capabilities are reported through IOASID_GET_INFO.
>   *
>   * Return: 0 if not supported, 1 if supported.
>   */
> #define IOASID_CHECK_EXTENSION	_IO(IOASID_TYPE, IOASID_BASE + 0)

 
> /*
>   * Register user space memory where DMA is allowed.
>   *
>   * It pins user pages and does the locked memory accounting so sub-
>   * sequent IOASID_MAP/UNMAP_DMA calls get faster.
>   *
>   * When this ioctl is not used, one user page might be accounted
>   * multiple times when it is mapped by multiple IOASIDs which are
>   * not nested together.
>   *
>   * Input parameters:
>   *	- vaddr;
>   *	- size;
>   *
>   * Return: 0 on success, -errno on failure.
>   */
> #define IOASID_REGISTER_MEMORY	_IO(IOASID_TYPE, IOASID_BASE + 1)
> #define IOASID_UNREGISTER_MEMORY	_IO(IOASID_TYPE, IOASID_BASE + 2)

So VA ranges are pinned and stored in a tree and later references to
those VA ranges by any other IOASID use the pin cached in the tree?

It seems reasonable and is similar to the ioasid parent/child I
suggested for PPC.

IMHO this should be merged with the all SW IOASID that is required for
today's mdev drivers. If this can be done while keeping this uAPI then
great, otherwise I don't think it is so bad to weakly nest a physical
IOASID under a SW one just to optimize page pinning.

Either way this seems like a smart direction

> /*
>   * Allocate an IOASID. 
>   *
>   * IOASID is the FD-local software handle representing an I/O address 
>   * space. Each IOASID is associated with a single I/O page table. User 
>   * must call this ioctl to get an IOASID for every I/O address space that is
>   * intended to be enabled in the IOMMU.
>   *
>   * A newly-created IOASID doesn't accept any command before it is 
>   * attached to a device. Once attached, an empty I/O page table is 
>   * bound with the IOMMU then the user could use either DMA mapping 
>   * or pgtable binding commands to manage this I/O page table.

Can the IOASID can be populated before being attached?

>   * Device attachment is initiated through device driver uAPI (e.g. VFIO)
>   *
>   * Return: allocated ioasid on success, -errno on failure.
>   */
> #define IOASID_ALLOC	_IO(IOASID_TYPE, IOASID_BASE + 3)
> #define IOASID_FREE	_IO(IOASID_TYPE, IOASID_BASE + 4)

I assume alloc will include quite a big structure to satisfy the
various vendor needs?

> /*
>   * Get information about an I/O address space
>   *
>   * Supported capabilities:
>   *	- VFIO type1 map/unmap;
>   *	- pgtable/pasid_table binding
>   *	- hardware nesting vs. software nesting;
>   *	- ...
>   *
>   * Related attributes:
>   * 	- supported page sizes, reserved IOVA ranges (DMA mapping);
>   *	- vendor pgtable formats (pgtable binding);
>   *	- number of child IOASIDs (nesting);
>   *	- ...
>   *
>   * Above information is available only after one or more devices are
>   * attached to the specified IOASID. Otherwise the IOASID is just a
>   * number w/o any capability or attribute.

This feels wrong to learn most of these attributes of the IOASID after
attaching to a device.

The user should have some idea how it intends to use the IOASID when
it creates it and the rest of the system should match the intention.

For instance if the user is creating a IOASID to cover the guest GPA
with the intention of making children it should indicate this during
alloc.

If the user is intending to point a child IOASID to a guest page table
in a certain descriptor format then it should indicate it during
alloc.

device bind should fail if the device somehow isn't compatible with
the scheme the user is tring to use.

> /*
>   * Map/unmap process virtual addresses to I/O virtual addresses.
>   *
>   * Provide VFIO type1 equivalent semantics. Start with the same 
>   * restriction e.g. the unmap size should match those used in the 
>   * original mapping call. 
>   *
>   * If IOASID_REGISTER_MEMORY has been called, the mapped vaddr
>   * must be already in the preregistered list.
>   *
>   * Input parameters:
>   *	- u32 ioasid;
>   *	- refer to vfio_iommu_type1_dma_{un}map
>   *
>   * Return: 0 on success, -errno on failure.
>   */
> #define IOASID_MAP_DMA	_IO(IOASID_TYPE, IOASID_BASE + 6)
> #define IOASID_UNMAP_DMA	_IO(IOASID_TYPE, IOASID_BASE + 7)

What about nested IOASIDs?

> /*
>   * Create a nesting IOASID (child) on an existing IOASID (parent)
>   *
>   * IOASIDs can be nested together, implying that the output address 
>   * from one I/O page table (child) must be further translated by 
>   * another I/O page table (parent).
>   *
>   * As the child adds essentially another reference to the I/O page table 
>   * represented by the parent, any device attached to the child ioasid 
>   * must be already attached to the parent.
>   *
>   * In concept there is no limit on the number of the nesting levels. 
>   * However for the majority case one nesting level is sufficient. The
>   * user should check whether an IOASID supports nesting through 
>   * IOASID_GET_INFO. For example, if only one nesting level is allowed,
>   * the nesting capability is reported only on the parent instead of the
>   * child.
>   *
>   * User also needs check (via IOASID_GET_INFO) whether the nesting 
>   * is implemented in hardware or software. If software-based, DMA 
>   * mapping protocol should be used on the child IOASID. Otherwise, 
>   * the child should be operated with pgtable binding protocol.
>   *
>   * Input parameters:
>   *	- u32 parent_ioasid;
>   *
>   * Return: child_ioasid on success, -errno on failure;
>   */
> #define IOASID_CREATE_NESTING	_IO(IOASID_TYPE, IOASID_BASE + 8)

Do you think another ioctl is best? Should this just be another
parameter to alloc?

> /*
>   * Bind an user-managed I/O page table with the IOMMU
>   *
>   * Because user page table is untrusted, IOASID nesting must be enabled 
>   * for this ioasid so the kernel can enforce its DMA isolation policy 
>   * through the parent ioasid.
>   *
>   * Pgtable binding protocol is different from DMA mapping. The latter 
>   * has the I/O page table constructed by the kernel and updated 
>   * according to user MAP/UNMAP commands. With pgtable binding the 
>   * whole page table is created and updated by userspace, thus different 
>   * set of commands are required (bind, iotlb invalidation, page fault, etc.).
>   *
>   * Because the page table is directly walked by the IOMMU, the user 
>   * must  use a format compatible to the underlying hardware. It can 
>   * check the format information through IOASID_GET_INFO.
>   *
>   * The page table is bound to the IOMMU according to the routing 
>   * information of each attached device under the specified IOASID. The
>   * routing information (RID and optional PASID) is registered when a 
>   * device is attached to this IOASID through VFIO uAPI. 
>   *
>   * Input parameters:
>   *	- child_ioasid;
>   *	- address of the user page table;
>   *	- formats (vendor, address_width, etc.);
>   * 
>   * Return: 0 on success, -errno on failure.
>   */
> #define IOASID_BIND_PGTABLE		_IO(IOASID_TYPE, IOASID_BASE + 9)
> #define IOASID_UNBIND_PGTABLE	_IO(IOASID_TYPE, IOASID_BASE + 10)

Also feels backwards, why wouldn't we specify this, and the required
page table format, during alloc time?

> /*
>   * Bind an user-managed PASID table to the IOMMU
>   *
>   * This is required for platforms which place PASID table in the GPA space.
>   * In this case the specified IOASID represents the per-RID PASID space.
>   *
>   * Alternatively this may be replaced by IOASID_BIND_PGTABLE plus a
>   * special flag to indicate the difference from normal I/O address spaces.
>   *
>   * The format info of the PASID table is reported in IOASID_GET_INFO.
>   *
>   * As explained in the design section, user-managed I/O page tables must
>   * be explicitly bound to the kernel even on these platforms. It allows
>   * the kernel to uniformly manage I/O address spaces cross all platforms.
>   * Otherwise, the iotlb invalidation and page faulting uAPI must be hacked
>   * to carry device routing information to indirectly mark the hidden I/O
>   * address spaces.
>   *
>   * Input parameters:
>   *	- child_ioasid;
>   *	- address of PASID table;
>   *	- formats (vendor, size, etc.);
>   *
>   * Return: 0 on success, -errno on failure.
>   */
> #define IOASID_BIND_PASID_TABLE	_IO(IOASID_TYPE, IOASID_BASE + 11)
> #define IOASID_UNBIND_PASID_TABLE	_IO(IOASID_TYPE, IOASID_BASE + 12)

Ditto

> 
> /*
>   * Invalidate IOTLB for an user-managed I/O page table
>   *
>   * Unlike what's defined in include/uapi/linux/iommu.h, this command 
>   * doesn't allow the user to specify cache type and likely support only
>   * two granularities (all, or a specified range) in the I/O address space.
>   *
>   * Physical IOMMU have three cache types (iotlb, dev_iotlb and pasid
>   * cache). If the IOASID represents an I/O address space, the invalidation
>   * always applies to the iotlb (and dev_iotlb if enabled). If the IOASID
>   * represents a vPASID space, then this command applies to the PASID
>   * cache.
>   *
>   * Similarly this command doesn't provide IOMMU-like granularity
>   * info (domain-wide, pasid-wide, range-based), since it's all about the
>   * I/O address space itself. The ioasid driver walks the attached
>   * routing information to match the IOMMU semantics under the
>   * hood. 
>   *
>   * Input parameters:
>   *	- child_ioasid;
>   *	- granularity
>   * 
>   * Return: 0 on success, -errno on failure
>   */
> #define IOASID_INVALIDATE_CACHE	_IO(IOASID_TYPE, IOASID_BASE + 13)

This should have an IOVA range too?

> /*
>   * Page fault report and response
>   *
>   * This is TBD. Can be added after other parts are cleared up. Likely it 
>   * will be a ring buffer shared between user/kernel, an eventfd to notify 
>   * the user and an ioctl to complete the fault.
>   *
>   * The fault data is per I/O address space, i.e.: IOASID + faulting_addr
>   */

Any reason not to just use read()?
  
>
> 2.2. /dev/vfio uAPI
> ++++++++++++++++

To be clear you mean the 'struct vfio_device' API, these are not
IOCTLs on the container or group?

> /*
>    * Bind a vfio_device to the specified IOASID fd
>    *
>    * Multiple vfio devices can be bound to a single ioasid_fd, but a single
>    * vfio device should not be bound to multiple ioasid_fd's.
>    *
>    * Input parameters:
>    *  - ioasid_fd;
>    *
>    * Return: 0 on success, -errno on failure.
>    */
> #define VFIO_BIND_IOASID_FD           _IO(VFIO_TYPE, VFIO_BASE + 22)
> #define VFIO_UNBIND_IOASID_FD _IO(VFIO_TYPE, VFIO_BASE + 23)

This is where it would make sense to have an output "device id" that
allows /dev/ioasid to refer to this "device" by number in events and
other related things.

> 
> 2.3. KVM uAPI
> ++++++++++++
> 
> /*
>   * Update CPU PASID mapping
>   *
>   * This is necessary when ENQCMD will be used in the guest while the
>   * targeted device doesn't accept the vPASID saved in the CPU MSR.
>   *
>   * This command allows user to set/clear the vPASID->pPASID mapping
>   * in the CPU, by providing the IOASID (and FD) information representing
>   * the I/O address space marked by this vPASID.
>   *
>   * Input parameters:
>   *	- user_pasid;
>   *	- ioasid_fd;
>   *	- ioasid;
>   */
> #define KVM_MAP_PASID	_IO(KVMIO, 0xf0)
> #define KVM_UNMAP_PASID	_IO(KVMIO, 0xf1)

It seems simple enough.. So the physical PASID can only be assigned if
the user has an IOASID that points at it? Thus it is secure?
 
> 3. Sample structures and helper functions
> 
> Three helper functions are provided to support VFIO_BIND_IOASID_FD:
> 
> 	struct ioasid_ctx *ioasid_ctx_fdget(int fd);
> 	int ioasid_register_device(struct ioasid_ctx *ctx, struct ioasid_dev *dev);
> 	int ioasid_unregister_device(struct ioasid_dev *dev);
> 
> An ioasid_ctx is created for each fd:
> 
> 	struct ioasid_ctx {
> 		// a list of allocated IOASID data's
> 		struct list_head		ioasid_list;

Would expect an xarray

> 		// a list of registered devices
> 		struct list_head		dev_list;

xarray of device_id

> 		// a list of pre-registered virtual address ranges
> 		struct list_head		prereg_list;

Should re-use the existing SW IOASID table, and be an interval tree.

> Each registered device is represented by ioasid_dev:
> 
> 	struct ioasid_dev {
> 		struct list_head		next;
> 		struct ioasid_ctx	*ctx;
> 		// always be the physical device
> 		struct device 		*device;
> 		struct kref		kref;
> 	};
> 
> Because we assume one vfio_device connected to at most one ioasid_fd, 
> here ioasid_dev could be embedded in vfio_device and then linked to 
> ioasid_ctx->dev_list when registration succeeds. For mdev the struct
> device should be the pointer to the parent device. PASID marking this
> mdev is specified later when VFIO_ATTACH_IOASID.

Don't embed a struct like this in something with vfio_device - that
just makes a mess of reference counting by having multiple krefs in
the same memory block. Keep it as a pointer, the attach operation
should return a pointer to the above struct.

> An ioasid_data is created when IOASID_ALLOC, as the main object 
> describing characteristics about an I/O page table:
> 
> 	struct ioasid_data {
> 		// link to ioasid_ctx->ioasid_list
> 		struct list_head		next;
> 
> 		// the IOASID number
> 		u32			ioasid;
> 
> 		// the handle to convey iommu operations
> 		// hold the pgd (TBD until discussing iommu api)
> 		struct iommu_domain *domain;

But at least for the first coding draft I would expect to see this API
presented with no PASID support and a simple 1:1 with iommu_domain. How
PASID gets modeled is the big TBD, right?

> ioasid_data and iommu_domain have overlapping roles as both are 
> introduced to represent an I/O address space. It is still a big TBD how 
> the two should be corelated or even merged, and whether new iommu 
> ops are required to handle RID+PASID explicitly.

I think it is OK that the uapi and kernel api have different
structs. The uapi focused one should hold the uapi related data, which
is what you've shown here, I think.

> Two helper functions are provided to support VFIO_ATTACH_IOASID:
> 
> 	struct attach_info {
> 		u32	ioasid;
> 		// If valid, the PASID to be used physically
> 		u32	pasid;
> 	};
> 	int ioasid_device_attach(struct ioasid_dev *dev, 
> 		struct attach_info info);
> 	int ioasid_device_detach(struct ioasid_dev *dev, u32 ioasid);

Honestly, I still prefer this to be highly explicit as this is where
all device driver authors get invovled:

ioasid_pci_device_attach(struct pci_device *pdev, struct ioasid_dev *dev, u32 ioasid);
ioasid_pci_device_pasid_attach(struct pci_device *pdev, u32 *physical_pasid, struct ioasid_dev *dev, u32 ioasid);

And presumably a variant for ARM non-PCI platform (?) devices.

This could boil down to a __ioasid_device_attach() as you've shown.

> A new object is introduced and linked to ioasid_data->attach_data for 
> each successful attach operation:
> 
> 	struct ioasid_attach_data {
> 		struct list_head		next;
> 		struct ioasid_dev	*dev;
> 		u32 			pasid;
> 	}

This should be returned as a pointer and detatch should be:

int ioasid_device_detach(struct ioasid_attach_data *);
 
> As explained in the design section, there is no explicit group enforcement
> in /dev/ioasid uAPI or helper functions. But the ioasid driver does
> implicit group check - before every device within an iommu group is 
> attached to this IOASID, the previously-attached devices in this group are
> put in ioasid_data->partial_devices. The IOASID rejects any command if
> the partial_devices list is not empty.

It is simple enough. Would be good to design in a diagnostic string so
userspace can make sense of the failure. Eg return something like
-EDEADLK and provide an ioctl 'why did EDEADLK happen' ?


> Then is the last helper function:
> 	u32 ioasid_get_global_pasid(struct ioasid_ctx *ctx, 
> 		u32 ioasid, bool alloc);
> 
> ioasid_get_global_pasid is necessary in scenarios where multiple devices 
> want to share a same PASID value on the attached I/O page table (e.g. 
> when ENQCMD is enabled, as explained in next section). We need a 
> centralized place (ioasid_data->pasid) to hold this value (allocated when
> first called with alloc=true). vfio device driver calls this function (alloc=
> true) to get the global PASID for an ioasid before calling ioasid_device_
> attach. KVM also calls this function (alloc=false) to setup PASID translation 
> structure when user calls KVM_MAP_PASID.

When/why would the VFIO driver do this? isn't this just some varient
of pasid_attach?

ioasid_pci_device_enqcmd_attach(struct pci_device *pdev, u32 *physical_pasid, struct ioasid_dev *dev, u32 ioasid);

?

> 4. PASID Virtualization
> 
> When guest SVA (vSVA) is enabled, multiple GVA address spaces are 
> created on the assigned vfio device. This leads to the concepts of 
> "virtual PASID" (vPASID) vs. "physical PASID" (pPASID). vPASID is assigned 
> by the guest to mark an GVA address space while pPASID is the one 
> selected by the host and actually routed in the wire.
> 
> vPASID is conveyed to the kernel when user calls VFIO_ATTACH_IOASID.

Should the vPASID programmed into the IOASID before calling
VFIO_ATTACH_IOASID?

> vfio device driver translates vPASID to pPASID before calling ioasid_attach_
> device, with two factors to be considered:
> 
> -    Whether vPASID is directly used (vPASID==pPASID) in the wire, or 
>      should be instead converted to a newly-allocated one (vPASID!=
>      pPASID);
> 
> -    If vPASID!=pPASID, whether pPASID is allocated from per-RID PASID
>      space or a global PASID space (implying sharing pPASID cross devices,
>      e.g. when supporting Intel ENQCMD which puts PASID in a CPU MSR
>      as part of the process context);

This whole section is 4 really confusing. I think it would be more
understandable to focus on the list below and minimize the vPASID

> The actual policy depends on pdev vs. mdev, and whether ENQCMD is
> supported. There are three possible scenarios:
> 
> (Note: /dev/ioasid uAPI is not affected by underlying PASID virtualization 
> policies.)

This has become unclear. I think this should start by identifying the
6 main type of devices and how they can use pPASID/vPASID:

0) Device is a RID and cannot issue PASID
1) Device is a mdev and cannot issue PASID
2) Device is a mdev and programs a single fixed PASID during bind,
   does not accept PASID from the guest

3) Device accepts any PASIDs from the guest. No
   vPASID/pPASID translation is possible. (classic vfio_pci)
4) Device accepts any PASID from the guest and has an
   internal vPASID/pPASID translation (enhanced vfio_pci)
5) Device accepts and PASID from the guest and relys on
   external vPASID/pPASID translation via ENQCMD (Intel SIOV mdev)

0-2 don't use vPASID at all

3-5 consume a vPASID but handle it differently.

I think the 3-5 map into what you are trying to explain in the table
below, which is the rules for allocating the vPASID depending on which
of device types 3-5 are present and or mixed.

For instance device type 3 requires vPASID == pPASID because it can't
do translation at all.

This probably all needs to come through clearly in the /dev/ioasid
interface. Once the attached devices are labled it would make sense to
have a 'query device' /dev/ioasid IOCTL to report the details based on
how the device attached and other information.

> 2)  mdev: vPASID!=pPASID (per-RID if w/o ENQCMD, otherwise global)
> 
>      PASIDs are also used by kernel to mark the default I/O address space 
>      for mdev, thus cannot be delegated to the guest. Instead, the mdev 
>      driver must allocate a new pPASID for each vPASID (thus vPASID!=
>      pPASID) and then use pPASID when attaching this mdev to an ioasid.

I don't understand this at all.. What does "PASIDs are also used by
the kernel" mean?

>      The mdev driver needs cache the PASID mapping so in mediation 
>      path vPASID programmed by the guest can be converted to pPASID 
>      before updating the physical MMIO register.

This is my scenario #4 above. Device and internally virtualize
vPASID/pPASID - how that is done is up to the device. But this is all
just labels, when such a device attaches, it should use some specific
API:

ioasid_pci_device_vpasid_attach(struct pci_device *pdev,
 u32 *physical_pasid, u32 *virtual_pasid, struct ioasid_dev *dev, u32 ioasid);

And then maintain its internal translation

>      In previous thread a PASID range split scheme was discussed to support
>      this combination, but we haven't worked out a clean uAPI design yet.
>      Therefore in this proposal we decide to not support it, implying the 
>      user should have some intelligence to avoid such scenario. It could be
>      a TODO task for future.

It really just boils down to how to allocate the PASIDs to get around
the bad viommu interface that assumes all PASIDs are usable by all
devices.
 
> In spite of those subtle considerations, the kernel implementation could
> start simple, e.g.:
> 
> -    v==p for pdev;
> -    v!=p and always use a global PASID pool for all mdev's;

Regardless all this mess needs to be hidden from the consuming drivers
with some simple APIs as above. The driver should indicate what its HW
can do and the PASID #'s that magically come out of /dev/ioasid should
be appropriate.

Will resume on another email..

Jason
