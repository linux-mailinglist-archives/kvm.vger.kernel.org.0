Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00C2394797
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 21:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhE1UAU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 May 2021 16:00:20 -0400
Received: from mail-sn1anam02on2075.outbound.protection.outlook.com ([40.107.96.75]:28160
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229493AbhE1UAS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 May 2021 16:00:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oDt9tdlgtzuOjVvD9rE9OfH5ctXXV8t3vpFBttii6odLefhb5c6oYmyAr9Om1GVut1YFVp77yz2enB5rsUmFFtZs1g06mEx5AlUpx4HPn4Ub9gp+Ir0kFQX2nE3cb0+rqBqnQJ3QJrHJk9WW5CHo4apahjOiESuvXRs/aAtMANhMgB3Wy3Siu7ZSF3ySTHAAPNRwcKszIPWOwGFV4GlGTVfpXnJbVb2uAvoE/36gkm0ymsikPKNDNr4SnYY040/F6u/hOapI/BMN38bKUmcyyU5C2sSOYJD+CyzFX/B6dS2NG4VttVeCLXmViZPkIWmJFuGfuTTYAVhSKo5YajXN5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ANet5rJH82MQKxGTYj7TvT4yoLTu6sCaTdCuia2nuHI=;
 b=mvXWYTCgnObqbPVlX00dPrMFSD5Watc1CObUXVfBkqZ+N0uuyyyItNqB6HcmM7wYV1zFvSiyQRSxDBes4n01deTK6bqwi5zWt0DMZPdEBu7bu89+gznssjDTM8XTelHfo3JhNo5hT5mRJtkE/nfetlLD1LTvWv1QQpIT0nzjfXl/lIsS7N+ux8rISWhhjSKvx3k0wp1kpir/h+HXZvm3rXqiVsgr/nweucXkgYleveySXXfn+8P/c875+e7kBupqQ6o+OwaTQXaEsMPO+PAdZdLe2VNTaeqUHWnvccb7jLXjsqW5ZuthPnQS00S+nDpex1CDzR4phR5+IFWbFt2fWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ANet5rJH82MQKxGTYj7TvT4yoLTu6sCaTdCuia2nuHI=;
 b=ifaMHAD5cB2zsG9lhaGrf/njuzCLzUNDTFjIUnrRpk3MT2MUThXzvG/67XgBUydRFQ9T8os9EjOxdJxhvENbLyWZJBaBjYe+pcT5EHNW4/E1mkYlNuUsJjCehcNd9yuqpTtrSeXvWMuXG/oSUPE8XwvBq9B71gSrUl81ztXPnw+6Fh8A0a88qmfSc/UpEdEU1YsczxE684DfPETRrHxZMfUOgyC+kHw5NHQ5MZHmiv2sscePaOxUUldnc/J0lwco2hbuhGcaVPFZPnUvrzehp84rSnLITYqpwnHW2RY1oskLGxFeberXV6Q72i+IVFYcMGVDSqj5BJ3tUg2PBvFzfA==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5078.namprd12.prod.outlook.com (2603:10b6:208:313::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Fri, 28 May
 2021 19:58:40 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4173.023; Fri, 28 May 2021
 19:58:40 +0000
Date:   Fri, 28 May 2021 16:58:39 -0300
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
Message-ID: <20210528195839.GO1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0200.namprd13.prod.outlook.com
 (2603:10b6:208:2be::25) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0200.namprd13.prod.outlook.com (2603:10b6:208:2be::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.12 via Frontend Transport; Fri, 28 May 2021 19:58:40 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lmicx-00G3pi-A4; Fri, 28 May 2021 16:58:39 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55cc9e1c-e64d-4c83-3b17-08d92212fd24
X-MS-TrafficTypeDiagnostic: BL1PR12MB5078:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB507807E6D9F4C3677C5915DFC2229@BL1PR12MB5078.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cn8sW7322V7zF3KHY6JkJ/u9Iespgc05BJSYLUdgqjbNyiKsjE1DT3FN6YmXOP/eXPrWd4wLuWsvaSDXEgf5+SqJJIePFOrslFGvbisjxL/7oKrooSto6oVaW14E2PTzal5ZvnMdSMZ4MIiFeX4oWZSQnJKY5OwdhpGeiXZm5EuBtVe6krFX/kb66j8c8aX4POJ2O+wsgeLB+PSVDdqCnQ2wuL5JE/e3FxvH/6/SmS8T6fgJvsf7QvUHlmXnVvtMPRMIAWncKqw1QiKcN7sFHHHuBgoXMM94uJweFpxIpppz0Y4MNrYEcH/g2DNwswIjYUR3Lx8919ujJjFW4P95BDChowJvBItsY4ACgEDmPdyv9Bh/Ymxm3Fh/K72qyZub3ZwdXl9CWrzRFmLHTf5qyJm9cX+yplpM/pOukGegawD8qKB+eDoHPOleRzMmGAyQNjksIhYfiYL35tYPzJySb+l+1PLA1daeWaMGszEVkGhkykNeXhLtZPoBuvvVP8ZX/srElyKe7DPqhsn6WvqcFokHJpCggt1+kCr1lWhzIGrKMVl0xgupMtbA6gYnJCvOcYtUjBk3LGsFe11WuJKJTGySp2rsa5/kUw0G1LhsQgA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(136003)(396003)(426003)(36756003)(7416002)(186003)(8676002)(33656002)(83380400001)(9786002)(9746002)(2906002)(2616005)(8936002)(316002)(4326008)(1076003)(86362001)(54906003)(66556008)(66946007)(66476007)(30864003)(6916009)(478600001)(5660300002)(38100700002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?m0DNZQe+exZzGKMu0OSvkiRZ78zmtsiyT7wbezgx1L2VrAEQnri9PptRjrLP?=
 =?us-ascii?Q?x7km02pOcPCmAMnsZvhOBhCSteYJjjCX0jJtUXoGldTdSgru6WSUPwVhfejp?=
 =?us-ascii?Q?jUFydhqksOzACtA+Hyajx8pElkzj7PJXYP6hIJnhdNtP0xa7Z5kQmE6N2n5w?=
 =?us-ascii?Q?N5yUFJckHNG3njc6S0x7W/dpGkmS1ipn3o0ps7Smfyq465VfZqyp6latC7aW?=
 =?us-ascii?Q?taKDkEpUYjwTawFmtNzeCOq7+WeCKsnVUgfbgPoY8OdglW7fk2DhLeFWW6GX?=
 =?us-ascii?Q?ZwHRV6szKrN9Xpbp4Grx5pPXGRXBW9rIZH6/646lQm+PjkbS++Z0cZ6HNPSS?=
 =?us-ascii?Q?xFQoBBRY6QhmYELNnGy+9ywuUpwRRpruzMQf/n9tQ9NhDfchqp1LhKSAIR9C?=
 =?us-ascii?Q?q46X+AqPeiUYkBymYkm1aCUrpzH8l4v0chc3VyqH5/xc3APKg4hIA4vNATOM?=
 =?us-ascii?Q?JHs4nBu6vbhR12tAH3zR2S8hcqBEc8gWQmZIVh+zKIV4egVlIcz9SWznLpl1?=
 =?us-ascii?Q?v+sU8Ujdiou4+IAfEYqpYq+jKCF7Wur+OmRam1KwIepBilIQTcrVwuFw3Ycy?=
 =?us-ascii?Q?9ZVOF7KtuiMJKlBmIID0qT0IFmIJ9upuYfklygM/W5k3m03vmCxWgey/p+mj?=
 =?us-ascii?Q?UVbkj8WYU5rAdxczJ1KplYlPtxQr/5XGp7zOzNQnK7uYjbrTDgdc6C3JVFFL?=
 =?us-ascii?Q?ATRpqnOLKgppO46t5VXpoaUoqaHOsJRMNZVeoM5F3DA1J97AwZ4ncPYFcWjk?=
 =?us-ascii?Q?KSu2F7Yt86tXwu4cw1hQ2kc3efYoLw0qWG5I6Gycd0bpX4k2PE+pRtzejHS7?=
 =?us-ascii?Q?uA0yHcvkC/v+5MKtjLY6WjSqerebIsc2NN0gSBo/jlovPfMMzJSMbWQCJ1gR?=
 =?us-ascii?Q?Sc/gDii00kW4Q1iW+wDZLvu6Bt1Zpu3gXUCIthDwM7UVIG5O0RKgt5ftCLm6?=
 =?us-ascii?Q?EfDz2bNYEXAkj9QafO9uJvq4zZGNdB009ghwEbQBwUGfknFQbwPHBvBcMMK9?=
 =?us-ascii?Q?5TTv6J6KAU2IlPtZeDOyUfuRivydxEkp2NwwVcabkNX9JDsHMoZl3xbyiWgo?=
 =?us-ascii?Q?Y1+IyH9TXlA4lQEd+l53Db5LBt4bXwvbPCcl4EeN81y1C+cxXYHYRzflcb0o?=
 =?us-ascii?Q?LNdPjA8kRKkEFkhdbTzfSr6cI3NTF5n0TnikIN8Cs+HkDWu8LDP9Ow8XMW7W?=
 =?us-ascii?Q?xGgIkalfXVU5AD+hkZC6j7MGRM9EZwSsHoWs4DDIaSOBh0THjy+5E5EZlSGf?=
 =?us-ascii?Q?my+ZpLsyheWCpcAudJpklLIZ4SAuNeXxDxfmOD/TAGsrYfLGqxPb6ZXLK3wE?=
 =?us-ascii?Q?P5vDSxi0ylFacRBaXoI9NWB6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55cc9e1c-e64d-4c83-3b17-08d92212fd24
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 19:58:40.6011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iYOTRnU1Pdp0a9OWq59wesX9yTixbDfnX9nl14wMWt7Vmr3Zyc+3jvLO9BnBFBzf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5078
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 27, 2021 at 07:58:12AM +0000, Tian, Kevin wrote:
> 
> 5. Use Cases and Flows
> 
> Here assume VFIO will support a new model where every bound device
> is explicitly listed under /dev/vfio thus a device fd can be acquired w/o 
> going through legacy container/group interface. For illustration purpose
> those devices are just called dev[1...N]:
> 
> 	device_fd[1...N] = open("/dev/vfio/devices/dev[1...N]", mode);
> 
> As explained earlier, one IOASID fd is sufficient for all intended use cases:
> 
> 	ioasid_fd = open("/dev/ioasid", mode);
> 
> For simplicity below examples are all made for the virtualization story.
> They are representative and could be easily adapted to a non-virtualization
> scenario.

For others, I don't think this is *strictly* necessary, we can
probably still get to the device_fd using the group_fd and fit in
/dev/ioasid. It does make the rest of this more readable though.


> Three types of IOASIDs are considered:
> 
> 	gpa_ioasid[1...N]: 	for GPA address space
> 	giova_ioasid[1...N]:	for guest IOVA address space
> 	gva_ioasid[1...N]:	for guest CPU VA address space
> 
> At least one gpa_ioasid must always be created per guest, while the other 
> two are relevant as far as vIOMMU is concerned.
> 
> Examples here apply to both pdev and mdev, if not explicitly marked out
> (e.g. in section 5.5). VFIO device driver in the kernel will figure out the 
> associated routing information in the attaching operation.
> 
> For illustration simplicity, IOASID_CHECK_EXTENSION and IOASID_GET_
> INFO are skipped in these examples.
> 
> 5.1. A simple example
> ++++++++++++++++++
> 
> Dev1 is assigned to the guest. One gpa_ioasid is created. The GPA address
> space is managed through DMA mapping protocol:
> 
> 	/* Bind device to IOASID fd */
> 	device_fd = open("/dev/vfio/devices/dev1", mode);
> 	ioasid_fd = open("/dev/ioasid", mode);
> 	ioctl(device_fd, VFIO_BIND_IOASID_FD, ioasid_fd);
> 
> 	/* Attach device to IOASID */
> 	gpa_ioasid = ioctl(ioasid_fd, IOASID_ALLOC);
> 	at_data = { .ioasid = gpa_ioasid};
> 	ioctl(device_fd, VFIO_ATTACH_IOASID, &at_data);
> 
> 	/* Setup GPA mapping */
> 	dma_map = {
> 		.ioasid	= gpa_ioasid;
> 		.iova	= 0;		// GPA
> 		.vaddr	= 0x40000000;	// HVA
> 		.size	= 1GB;
> 	};
> 	ioctl(ioasid_fd, IOASID_DMA_MAP, &dma_map);
> 
> If the guest is assigned with more than dev1, user follows above sequence
> to attach other devices to the same gpa_ioasid i.e. sharing the GPA 
> address space cross all assigned devices.

eg

 	device2_fd = open("/dev/vfio/devices/dev1", mode);
 	ioctl(device2_fd, VFIO_BIND_IOASID_FD, ioasid_fd);
 	ioctl(device2_fd, VFIO_ATTACH_IOASID, &at_data);

Right?

> 
> 5.2. Multiple IOASIDs (no nesting)
> ++++++++++++++++++++++++++++
> 
> Dev1 and dev2 are assigned to the guest. vIOMMU is enabled. Initially
> both devices are attached to gpa_ioasid. After boot the guest creates 
> an GIOVA address space (giova_ioasid) for dev2, leaving dev1 in pass
> through mode (gpa_ioasid).
> 
> Suppose IOASID nesting is not supported in this case. Qemu need to
> generate shadow mappings in userspace for giova_ioasid (like how
> VFIO works today).
> 
> To avoid duplicated locked page accounting, it's recommended to pre-
> register the virtual address range that will be used for DMA:
> 
> 	device_fd1 = open("/dev/vfio/devices/dev1", mode);
> 	device_fd2 = open("/dev/vfio/devices/dev2", mode);
> 	ioasid_fd = open("/dev/ioasid", mode);
> 	ioctl(device_fd1, VFIO_BIND_IOASID_FD, ioasid_fd);
> 	ioctl(device_fd2, VFIO_BIND_IOASID_FD, ioasid_fd);
> 
> 	/* pre-register the virtual address range for accounting */
> 	mem_info = { .vaddr = 0x40000000; .size = 1GB };
> 	ioctl(ioasid_fd, IOASID_REGISTER_MEMORY, &mem_info);
> 
> 	/* Attach dev1 and dev2 to gpa_ioasid */
> 	gpa_ioasid = ioctl(ioasid_fd, IOASID_ALLOC);
> 	at_data = { .ioasid = gpa_ioasid};
> 	ioctl(device_fd1, VFIO_ATTACH_IOASID, &at_data);
> 	ioctl(device_fd2, VFIO_ATTACH_IOASID, &at_data);
> 
> 	/* Setup GPA mapping */
> 	dma_map = {
> 		.ioasid	= gpa_ioasid;
> 		.iova	= 0; 		// GPA
> 		.vaddr	= 0x40000000;	// HVA
> 		.size	= 1GB;
> 	};
> 	ioctl(ioasid_fd, IOASID_DMA_MAP, &dma_map);
> 
> 	/* After boot, guest enables an GIOVA space for dev2 */
> 	giova_ioasid = ioctl(ioasid_fd, IOASID_ALLOC);
> 
> 	/* First detach dev2 from previous address space */
> 	at_data = { .ioasid = gpa_ioasid};
> 	ioctl(device_fd2, VFIO_DETACH_IOASID, &at_data);
> 
> 	/* Then attach dev2 to the new address space */
> 	at_data = { .ioasid = giova_ioasid};
> 	ioctl(device_fd2, VFIO_ATTACH_IOASID, &at_data);
> 
> 	/* Setup a shadow DMA mapping according to vIOMMU
> 	  * GIOVA (0x2000) -> GPA (0x1000) -> HVA (0x40001000)
> 	  */

Here "shadow DMA" means relay the guest's vIOMMU page tables to the HW
IOMMU?

> 	dma_map = {
> 		.ioasid	= giova_ioasid;
> 		.iova	= 0x2000; 	// GIOVA
> 		.vaddr	= 0x40001000;	// HVA

eg HVA came from reading the guest's page tables and finding it wanted
GPA 0x1000 mapped to IOVA 0x2000?


> 5.3. IOASID nesting (software)
> +++++++++++++++++++++++++
> 
> Same usage scenario as 5.2, with software-based IOASID nesting 
> available. In this mode it is the kernel instead of user to create the
> shadow mapping.
> 
> The flow before guest boots is same as 5.2, except one point. Because 
> giova_ioasid is nested on gpa_ioasid, locked accounting is only 
> conducted for gpa_ioasid. So it's not necessary to pre-register virtual 
> memory.
> 
> To save space we only list the steps after boots (i.e. both dev1/dev2
> have been attached to gpa_ioasid before guest boots):
> 
> 	/* After boots */
> 	/* Make GIOVA space nested on GPA space */
> 	giova_ioasid = ioctl(ioasid_fd, IOASID_CREATE_NESTING,
> 				gpa_ioasid);
> 
> 	/* Attach dev2 to the new address space (child)
> 	  * Note dev2 is still attached to gpa_ioasid (parent)
> 	  */
> 	at_data = { .ioasid = giova_ioasid};
> 	ioctl(device_fd2, VFIO_ATTACH_IOASID, &at_data);
> 
> 	/* Setup a GIOVA->GPA mapping for giova_ioasid, which will be 
> 	  * merged by the kernel with GPA->HVA mapping of gpa_ioasid
> 	  * to form a shadow mapping.
> 	  */
> 	dma_map = {
> 		.ioasid	= giova_ioasid;
> 		.iova	= 0x2000;	// GIOVA
> 		.vaddr	= 0x1000;	// GPA
> 		.size	= 4KB;
> 	};
> 	ioctl(ioasid_fd, IOASID_DMA_MAP, &dma_map);

And in this version the kernel reaches into the parent IOASID's page
tables to translate 0x1000 to 0x40001000 to physical page? So we
basically remove the qemu process address space entirely from this
translation. It does seem convenient

> 5.4. IOASID nesting (hardware)
> +++++++++++++++++++++++++
> 
> Same usage scenario as 5.2, with hardware-based IOASID nesting
> available. In this mode the pgtable binding protocol is used to 
> bind the guest IOVA page table with the IOMMU:
> 
> 	/* After boots */
> 	/* Make GIOVA space nested on GPA space */
> 	giova_ioasid = ioctl(ioasid_fd, IOASID_CREATE_NESTING,
> 				gpa_ioasid);
> 
> 	/* Attach dev2 to the new address space (child)
> 	  * Note dev2 is still attached to gpa_ioasid (parent)
> 	  */
> 	at_data = { .ioasid = giova_ioasid};
> 	ioctl(device_fd2, VFIO_ATTACH_IOASID, &at_data);
> 
> 	/* Bind guest I/O page table  */
> 	bind_data = {
> 		.ioasid	= giova_ioasid;
> 		.addr	= giova_pgtable;
> 		// and format information
> 	};
> 	ioctl(ioasid_fd, IOASID_BIND_PGTABLE, &bind_data);

I really think you need to use consistent language. Things that
allocate a new IOASID should be calle IOASID_ALLOC_IOASID. If multiple
IOCTLs are needed then it is IOASID_ALLOC_IOASID_PGTABLE, etc.
alloc/create/bind is too confusing.

> 5.5. Guest SVA (vSVA)
> ++++++++++++++++++
> 
> After boots the guest further create a GVA address spaces (gpasid1) on 
> dev1. Dev2 is not affected (still attached to giova_ioasid).
> 
> As explained in section 4, user should avoid expose ENQCMD on both
> pdev and mdev.
> 
> The sequence applies to all device types (being pdev or mdev), except
> one additional step to call KVM for ENQCMD-capable mdev:
> 
> 	/* After boots */
> 	/* Make GVA space nested on GPA space */
> 	gva_ioasid = ioctl(ioasid_fd, IOASID_CREATE_NESTING,
> 				gpa_ioasid);
> 
> 	/* Attach dev1 to the new address space and specify vPASID */
> 	at_data = {
> 		.ioasid		= gva_ioasid;
> 		.flag 		= IOASID_ATTACH_USER_PASID;
> 		.user_pasid	= gpasid1;
> 	};
> 	ioctl(device_fd1, VFIO_ATTACH_IOASID, &at_data);

Still a little unsure why the vPASID is here not on the gva_ioasid. Is
there any scenario where we want different vpasid's for the same
IOASID? I guess it is OK like this. Hum.

> 	/* if dev1 is ENQCMD-capable mdev, update CPU PASID 
> 	  * translation structure through KVM
> 	  */
> 	pa_data = {
> 		.ioasid_fd	= ioasid_fd;
> 		.ioasid		= gva_ioasid;
> 		.guest_pasid	= gpasid1;
> 	};
> 	ioctl(kvm_fd, KVM_MAP_PASID, &pa_data);

Make sense

> 	/* Bind guest I/O page table  */
> 	bind_data = {
> 		.ioasid	= gva_ioasid;
> 		.addr	= gva_pgtable1;
> 		// and format information
> 	};
> 	ioctl(ioasid_fd, IOASID_BIND_PGTABLE, &bind_data);

Again I do wonder if this should just be part of alloc_ioasid. Is
there any reason to split these things? The only advantage to the
split is the device is known, but the device shouldn't impact
anything..

> 5.6. I/O page fault
> +++++++++++++++
> 
> (uAPI is TBD. Here is just about the high-level flow from host IOMMU driver
> to guest IOMMU driver and backwards).
> 
> -   Host IOMMU driver receives a page request with raw fault_data {rid, 
>     pasid, addr};
> 
> -   Host IOMMU driver identifies the faulting I/O page table according to
>     information registered by IOASID fault handler;
> 
> -   IOASID fault handler is called with raw fault_data (rid, pasid, addr), which 
>     is saved in ioasid_data->fault_data (used for response);
> 
> -   IOASID fault handler generates an user fault_data (ioasid, addr), links it 
>     to the shared ring buffer and triggers eventfd to userspace;

Here rid should be translated to a labeled device and return the
device label from VFIO_BIND_IOASID_FD. Depending on how the device
bound the label might match to a rid or to a rid,pasid

> -   Upon received event, Qemu needs to find the virtual routing information 
>     (v_rid + v_pasid) of the device attached to the faulting ioasid. If there are 
>     multiple, pick a random one. This should be fine since the purpose is to
>     fix the I/O page table on the guest;

The device label should fix this
 
> -   Qemu finds the pending fault event, converts virtual completion data 
>     into (ioasid, response_code), and then calls a /dev/ioasid ioctl to 
>     complete the pending fault;
> 
> -   /dev/ioasid finds out the pending fault data {rid, pasid, addr} saved in 
>     ioasid_data->fault_data, and then calls iommu api to complete it with
>     {rid, pasid, response_code};

So resuming a fault on an ioasid will resume all devices pending on
the fault?

> 5.7. BIND_PASID_TABLE
> ++++++++++++++++++++
> 
> PASID table is put in the GPA space on some platform, thus must be updated
> by the guest. It is treated as another user page table to be bound with the 
> IOMMU.
> 
> As explained earlier, the user still needs to explicitly bind every user I/O 
> page table to the kernel so the same pgtable binding protocol (bind, cache 
> invalidate and fault handling) is unified cross platforms.
>
> vIOMMUs may include a caching mode (or paravirtualized way) which, once 
> enabled, requires the guest to invalidate PASID cache for any change on the 
> PASID table. This allows Qemu to track the lifespan of guest I/O page tables.
>
> In case of missing such capability, Qemu could enable write-protection on
> the guest PASID table to achieve the same effect.
> 
> 	/* After boots */
> 	/* Make vPASID space nested on GPA space */
> 	pasidtbl_ioasid = ioctl(ioasid_fd, IOASID_CREATE_NESTING,
> 				gpa_ioasid);
> 
> 	/* Attach dev1 to pasidtbl_ioasid */
> 	at_data = { .ioasid = pasidtbl_ioasid};
> 	ioctl(device_fd1, VFIO_ATTACH_IOASID, &at_data);
> 
> 	/* Bind PASID table */
> 	bind_data = {
> 		.ioasid	= pasidtbl_ioasid;
> 		.addr	= gpa_pasid_table;
> 		// and format information
> 	};
> 	ioctl(ioasid_fd, IOASID_BIND_PASID_TABLE, &bind_data);
> 
> 	/* vIOMMU detects a new GVA I/O space created */
> 	gva_ioasid = ioctl(ioasid_fd, IOASID_CREATE_NESTING,
> 				gpa_ioasid);
> 
> 	/* Attach dev1 to the new address space, with gpasid1 */
> 	at_data = {
> 		.ioasid		= gva_ioasid;
> 		.flag 		= IOASID_ATTACH_USER_PASID;
> 		.user_pasid	= gpasid1;
> 	};
> 	ioctl(device_fd1, VFIO_ATTACH_IOASID, &at_data);
> 
> 	/* Bind guest I/O page table. Because SET_PASID_TABLE has been
> 	  * used, the kernel will not update the PASID table. Instead, just
> 	  * track the bound I/O page table for handling invalidation and
> 	  * I/O page faults.
> 	  */
> 	bind_data = {
> 		.ioasid	= gva_ioasid;
> 		.addr	= gva_pgtable1;
> 		// and format information
> 	};
> 	ioctl(ioasid_fd, IOASID_BIND_PGTABLE, &bind_data);

I still don't quite get the benifit from doing this.

The idea to create an all PASID IOASID seems to work better with less
fuss on HW that is directly parsing the guest's PASID table.

Cache invalidate seems easy enough to support

Fault handling needs to return the (ioasid, device_label, pasid) when
working with this kind of ioasid.

It is true that it does create an additional flow qemu has to
implement, but it does directly mirror the HW.

Jason
