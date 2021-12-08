Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC5A46D3D3
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 13:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbhLHM75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 07:59:57 -0500
Received: from mail-mw2nam12on2053.outbound.protection.outlook.com ([40.107.244.53]:43232
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229534AbhLHM75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 07:59:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIbVunckKPa28LeVCQFQj7y3r+NESta0ODk9DUO72Iaol1TxT860ncALohPG+R+JiGwvBn9k+JVhNO0eJZ1QERohLafc64W6RG+luuM8OmlF8QwkNoSoW3tnR9NMv5+i0wndjoDstSYaEigTHYoYNHM0vb2Cdv62O2RMeg5JQEo7M2t3KJD3Ess1r4a0zf779xnQdRzuwSz+rGsqvn2VLjsRBdmhvKqx+EZtXHJVE2+RhyuY7itrW+ZAAph77J1vzV/rXRzU8Dv029JuXD7QC8fj7ZyGST+2Tt8o96BiGcjSCYoZe4yPep6t1R5Ox9aVrb+znyMm7F7Q2VRd6BU7Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MW/nNdFZuZ7IvlRvNTo8icfrO+jKXCS/ewjI60GXteo=;
 b=kMs/b/QlOImivCkY9tBhbC8tZCzXtZe9oQac5zMSVhqw25AvXpab/PDKhCdD5S0DdvJj5eRakVpgwmqQpxZl74VSJx46ajeDZrTJhLscPNEofH0AWAzTFNZgNFBesE6KgUdQ0thUfNCbjqgoOR95QqJCEtPUvvhE6RV76PF7iLOl0/eL3Jyq2Rfcb3cu0CmpYInZ60mAiaSMW8GnkBw+ZvRBkc9Gy1LayPGdrAqgP+o75J2Iil+NZUGaaihNNDu6NGJ04lJ2hkj9YaV273sL8ar9iAgsZoiQUHI2iMgkSyJxrmlNlb7coArehDi3Bb5QZBv3D3n2lQ3G3ZtAJr2c4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MW/nNdFZuZ7IvlRvNTo8icfrO+jKXCS/ewjI60GXteo=;
 b=cGl2nY2ygNWmhDggJiNPSNMhLd9Gvc5r9zZk6v+xCScfK/g+aK1BWtL5QGYLXpcqwFQdzkbDWhJCijELJNIhS1129Ta50j1+EJxKwPc2mi32ukoJaj7wv3hI0HcoDMjWgjn6nMFV1W/ORbT3qw4od8zyqRux+SZX+O7shV1kjsfzLnbbyPXnfMIABuANXUtw14LzC0c+LrKEZuGck8ILkpqCGCtV/UQWMRQ48wAMjdgXyZJ31df5QaT/eYI5CMxsv8rdBJOAXOPrv8NCxThVGsA+aXEk9hNPmCvfjvbHmk2mQr7HwPyoURafROIPgYKljubaDxht1EfOHPz/gtRcXw==
Received: from BL1PR12MB5318.namprd12.prod.outlook.com (2603:10b6:208:31d::20)
 by BL1PR12MB5064.namprd12.prod.outlook.com (2603:10b6:208:30a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.28; Wed, 8 Dec
 2021 12:56:23 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5318.namprd12.prod.outlook.com (2603:10b6:208:31d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Wed, 8 Dec
 2021 12:56:22 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%7]) with mapi id 15.20.4778.013; Wed, 8 Dec 2021
 12:56:18 +0000
Date:   Wed, 8 Dec 2021 08:56:16 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, peter.maydell@linaro.org,
        kvm@vger.kernel.org, vivek.gautam@arm.com,
        kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com,
        jean-philippe@linaro.org, ashok.raj@intel.com, maz@kernel.org,
        vsethi@nvidia.com, zhangfei.gao@linaro.org, kevin.tian@intel.com,
        will@kernel.org, alex.williamson@redhat.com,
        wangxingang5@huawei.com, linux-kernel@vger.kernel.org,
        lushenming@huawei.com, iommu@lists.linux-foundation.org,
        robin.murphy@arm.com
Subject: Re: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
Message-ID: <20211208125616.GN6385@nvidia.com>
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <20211027104428.1059740-2-eric.auger@redhat.com>
 <Ya3qd6mT/DpceSm8@8bytes.org>
 <c7e26722-f78c-a93f-c425-63413aa33dde@redhat.com>
 <e6733c59-ffcb-74d4-af26-273c1ae8ce68@linux.intel.com>
 <fbeabcff-a6d4-dcc5-6687-7b32d6358fe3@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fbeabcff-a6d4-dcc5-6687-7b32d6358fe3@redhat.com>
X-ClientProxiedBy: YTXPR0101CA0038.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:1::15) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5bc2534f-fdc7-4769-6c9e-08d9ba4a207a
X-MS-TrafficTypeDiagnostic: BL1PR12MB5318:EE_|BL1PR12MB5064:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5318790FDF5C4F5181284D9BC26F9@BL1PR12MB5318.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FTOWXrzL9pegxtxBcdSXTgUQUN+w1f72NZoO6T3ollx94nOyGZhEUOrTvyZ43Z/LqTHxg6c9H4afPyYQasqzZfUSpign+W7aq5tpZqSYXSXwlCBhtcS6BLFy/sohbFgSGeEpx3EGDRzOPoJWdcGSHywnZnReLn3xhcsv78cxyZwWgX13zoHYQSmA7+yDHS54vyTfhJJG1EDhqAbIpej/9mVY3ZGMAuwW19eYIdQmnNrDK3BOKj87U61trN5V+seKKsDHQs10S8PqnmhE920UZOahZJM1E/QguQ1C2RmXczBnxRaomTQt4MtlaofCoZsO8j4pV8iSlRyFDbyO1ptzyM9A5QKStC4+O6cotAmr08VMAgPqKOJPfqForDwp21fdLysRyQbbVkoFM1OjwoZPT6UY+xRM4h6u2SdcHNXEfuQhyllEzZhVV+81TElXIY7IyirhWUSMdkWJDiKyBowbyB9qawyY9p0pbcv2XkCjWsk46UwjpvE15xSqj6hlMrAkf78mU2xqGOI/G8ktcCPC64BB9vzsuOVSP1TAHqxpYLerrLdQyZQG6s9OpPgofjUzegHhlTcxlKhY0gLTq1oJ/Bqw6Vfk7KY2bjfd29FvNteVZ5Acoor9wHXL4j76QwotQEMc8RRaqvCSN4WWn3X9LnSTFZPwYTN3SRYWIu8DudJ3RpQKqUkdewr272QG7SNgGYwyMZVQTVAThebfURt84Pt66E3Wn88xe9NcwBDJPgoWvR5QTxSFh75XDAMKRzdKNzn9gerwuF3s0MqvXv5IUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5318.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(316002)(4326008)(7416002)(33656002)(8936002)(8676002)(6512007)(186003)(83380400001)(86362001)(2616005)(6916009)(2906002)(66476007)(6486002)(508600001)(5660300002)(36756003)(966005)(66556008)(1076003)(66946007)(38100700002)(6506007)(26005)(53546011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RWNjekFsd1F6V3dsRUk4NmNGMk5zdVFMTE93SzZ3dWxzS1hLU21halJXSmVq?=
 =?utf-8?B?dFViMjgzU0YyMk1pdTVqell3L3NweklaM2x4RWNCTjEycmgxSUJLZHRRbzNH?=
 =?utf-8?B?WlFWQzlWSzgwTDl1cmhXR2Y1VTZtUTYzNjVSVDVkcHB6aklUYnh3Ny9ORkp0?=
 =?utf-8?B?dTN5bExRTjZGU1hhM0tvcC96QWMrZ3J6SVUrNXkyOGl2OFkyYWVkOWpmNEZh?=
 =?utf-8?B?Y1J2L1Yrc2ZSbktoWHQxTEppRGJGNnllaGVPY2x0TUdKaWladmJGYnZ0RzZ3?=
 =?utf-8?B?R2hQMUl0cU8rTFpZTGJ0Rll5VXVOQkppUHVLdDlHdC9CUkNhS1htLzBuM1NU?=
 =?utf-8?B?ek5hdVVpM2w2QWplU2ZMeDhLZWxuRjVXeHI4VDRwMnJpcVpiTko1cWVqekdN?=
 =?utf-8?B?V0FqdzY3b0piR2ZDRVNIb0pGUkNoU1JpVkdEMEhIc203dzNKT1BRcUw4M3A1?=
 =?utf-8?B?T2JWWWxjWFVGankxTFpIRzJCL1M1QU4yUnV3R1hES01wRXp2S2I0RTZ5cFd2?=
 =?utf-8?B?QWF1SE92VkV1MkxtdjI3dmRBbVhtamtZeUY3TTVqL0tQK2o0WklPV2h2QVRK?=
 =?utf-8?B?UUllVEpDZVZoSCtpKyttdlliaTc5bndreUlleXJSZVZDbXduKytBUVpYOWlp?=
 =?utf-8?B?VzZDMk5VMXpkSHVnaFU0S0dNK2VaS3FCOEpHSUk4WTgrcnZFTGFtZnE4dGFq?=
 =?utf-8?B?ZVh4ZGNQRWgyczluRU9uWEdBTHd1SjluNko0dHA1OE9MWmpZZGlpa3BYeEl1?=
 =?utf-8?B?YUgyMUdmSVJVMVpCL25VM2p0WWdpZVpBUlpoVFd5cWp0US9ocmdhUjVyRktX?=
 =?utf-8?B?dXJDN2thREd2aEw3VGtOdEZlM2xSWHNvekhPT2dxUEtOenp0bkgrNHZFZ0c4?=
 =?utf-8?B?cUcrd21XSktzOHFxeXJITWUyekpwMzNmSUFVTFQ1TmloY1p5VnNVUFlaZ0dv?=
 =?utf-8?B?OC9xY1h4QTJtYVRVR0RWUVNKeDVEc1hLZG1Dd09HWklEUWlxOFMvOVdNS0Vs?=
 =?utf-8?B?VlQxZXZBcE1FN25XZlZEcXphVTVGWmg2dnFueU1xbVNwZVBOaTlmOCtobW9k?=
 =?utf-8?B?TW1vVGJwa0wxWTliR2pkM3BMNWhQR3pOK0RVMktBa3o1S1I3dTdDM3pIdC92?=
 =?utf-8?B?T1dFaTFuVWt1NW16d1NsbldYVHRWbzcrK2VkZm5Gc1FtK09MWXFEMDFmeHZL?=
 =?utf-8?B?RmtnOEhaTnMzeWZJcDVWRk96YWpvM2xPNzloZUZXQXdmelEreTZyNnlGZEdM?=
 =?utf-8?B?Ymx1WU43SmJqeFZXcW8xSytXNWU2WXhHWUxoaUlXZjZlNUJtb2kvM0EyK1Bj?=
 =?utf-8?B?V250SnVscDVUTGVDU3Rib3RaQURqT3NNMzd1d252bG03dkp0R28vd3ErQk5t?=
 =?utf-8?B?OTljalNSazc1eGE1S1NYbmd4dEFlcTdxUi9QM1dxM2tIUmVTeCtvVXRJMzEw?=
 =?utf-8?B?bnNtQWgycVhUekM3aW9IT2dtVExTNnIzUTlsZmpSNlk5M3lSemZnQTJ1WmFQ?=
 =?utf-8?B?N1gvR0kwV01CbUpqdldNcXRKYUd5QjVmOG1jWHREaGpsVG1XenNNbytkampK?=
 =?utf-8?B?cm5FNFpjRy85b0M0NUN2UVR3a0VjY0dTc1VzRzVBNnV0MDNoRDZlLzdFWUww?=
 =?utf-8?B?WExvaGJzV1Q1ZHlDVm5INUo0Nm1BekxtU0QxYVZhdGV3WlFDRHVqT0dCTzJs?=
 =?utf-8?B?SmY1Rnc4UUVkclVGak9DM3VSQXk1SzZwN2dFeXdzbVZUL0VWSHkyM3c1d0dv?=
 =?utf-8?B?RHlMcU1CRXV5b053ZjRLNUt4bnZsUFlBRnpqcHNxVWd1V2RVRTVlNlk2N1BT?=
 =?utf-8?B?QXRZcEFtVGZjY2VVQk5YdlE0ckhyZTEyUXhTekhzb2E0dExLMThMZFRzbFM1?=
 =?utf-8?B?cFdJbFNkVk5mdThtczF3U1k0QjNUWEdPUWw4ZWZ1bW94VnZwMEc4Mkk5MDVE?=
 =?utf-8?B?UVpSa3BFN0lhQ1huWFBOdE1CSUk0d255OGppY3BUOS82amRLYVJHa3BGaWE5?=
 =?utf-8?B?VGdwSDNBOG1zM0NKakJpMXg3ZDY2OVVxRElPMWFpV3F3bUhVOVlZT3lFZ081?=
 =?utf-8?B?ang2L2xzR0szZnNqYUpYbGZmZFRJdUEzREU0bG1mWTd5Yzg5UXk4QWNBck1v?=
 =?utf-8?Q?nuM0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bc2534f-fdc7-4769-6c9e-08d9ba4a207a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 12:56:18.7688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EHk2qywAppr9lYzU02HL2Of0ONvf54e1j/Fy/VKREL33Cx5FhvuGw1vNi1mdm6Uo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 08, 2021 at 08:33:33AM +0100, Eric Auger wrote:
> Hi Baolu,
> 
> On 12/8/21 3:44 AM, Lu Baolu wrote:
> > Hi Eric,
> >
> > On 12/7/21 6:22 PM, Eric Auger wrote:
> >> On 12/6/21 11:48 AM, Joerg Roedel wrote:
> >>> On Wed, Oct 27, 2021 at 12:44:20PM +0200, Eric Auger wrote:
> >>>> Signed-off-by: Jean-Philippe Brucker<jean-philippe.brucker@arm.com>
> >>>> Signed-off-by: Liu, Yi L<yi.l.liu@linux.intel.com>
> >>>> Signed-off-by: Ashok Raj<ashok.raj@intel.com>
> >>>> Signed-off-by: Jacob Pan<jacob.jun.pan@linux.intel.com>
> >>>> Signed-off-by: Eric Auger<eric.auger@redhat.com>
> >>> This Signed-of-by chain looks dubious, you are the author but the last
> >>> one in the chain?
> >> The 1st RFC in Aug 2018
> >> (https://lists.cs.columbia.edu/pipermail/kvmarm/2018-August/032478.html)
> >> said this was a generalization of Jacob's patch
> >>
> >>
> >>    [PATCH v5 01/23] iommu: introduce bind_pasid_table API function
> >>
> >>
> >>   
> >> https://lists.linuxfoundation.org/pipermail/iommu/2018-May/027647.html
> >>
> >> So indeed Jacob should be the author. I guess the multiple rebases got
> >> this eventually replaced at some point, which is not an excuse. Please
> >> forgive me for that.
> >> Now the original patch already had this list of SoB so I don't know if I
> >> shall simplify it.
> >
> > As we have decided to move the nested mode (dual stages) implementation
> > onto the developing iommufd framework, what's the value of adding this
> > into iommu core?
> 
> The iommu_uapi_attach_pasid_table uapi should disappear indeed as it is
> is bound to be replaced by /dev/iommu fellow API.
> However until I can rebase on /dev/iommu code I am obliged to keep it to
> maintain this integration, hence the RFC.

Indeed, we are getting pretty close to having the base iommufd that we
can start adding stuff like this into. Maybe in January, you can look
at some parts of what is evolving here:

https://github.com/jgunthorpe/linux/commits/iommufd
https://github.com/LuBaolu/intel-iommu/commits/iommu-dma-ownership-v2
https://github.com/luxis1999/iommufd/commits/iommufd-v5.16-rc2

From a progress perspective I would like to start with simple 'page
tables in userspace', ie no PASID in this step.

'page tables in userspace' means an iommufd ioctl to create an
iommu_domain where the IOMMU HW is directly travesering a
device-specific page table structure in user space memory. All the HW
today implements this by using another iommu_domain to allow the IOMMU
HW DMA access to user memory - ie nesting or multi-stage or whatever.

This would come along with some ioctls to invalidate the IOTLB.

I'm imagining this step as a iommu_group->op->create_user_domain()
driver callback which will create a new kind of domain with
domain-unique ops. Ie map/unmap related should all be NULL as those
are impossible operations.

From there the usual struct device (ie RID) attach/detatch stuff needs
to take care of routing DMAs to this iommu_domain.

Step two would be to add the ability for an iommufd using driver to
request that a RID&PASID is connected to an iommu_domain. This
connection can be requested for any kind of iommu_domain, kernel owned
or user owned.

I don't quite have an answer how exactly the SMMUv3 vs Intel
difference in PASID routing should be resolved.

to get answers I'm hoping to start building some sketch RFCs for these
different things on iommufd, hopefully in January. I'm looking at user
page tables, PASID, dirty tracking and userspace IO fault handling as
the main features iommufd must tackle.

The purpose of the sketches would be to validate that the HW features
we want to exposed can work will with the choices the base is making.

Jason
