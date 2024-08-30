Return-Path: <kvm+bounces-25556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC8029667C7
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 19:16:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 26EE8B277CF
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 17:16:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D37861BAEC8;
	Fri, 30 Aug 2024 17:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gizWebzO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2070.outbound.protection.outlook.com [40.107.236.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3B61B5813;
	Fri, 30 Aug 2024 17:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725038168; cv=fail; b=IIWWmX4o8NZlXS9/pDPuTsNRRR36nNsYqKDESxjH5/X0IqwXBH51gShCnXBydlMMVanYo2G+NhQMy9tL2hMSyXoIIjuZCB+iKlL1qaNMe4rmuiCPEc5QWrEli82boRF8Aa9Txnw0e33EVV6weq8qycBJ33XtsN0ypTFzhL3MmCc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725038168; c=relaxed/simple;
	bh=zIdos9Qoid//dnJDxUfnm8DrXIcbOt1v3IrofHM5k80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PIvAy8lbQSiH46sao010oVBSn8NQx44HTy3GHZWnK3jDA6HpYSVMskK/raoHyj6qmK4XIy2WqLQLUs0KONH8YbRuLSWkAJfY/t+KRLHBdB/bX3mQcDWdwXty1OxReBnembQdswWc5ycIHIgt2N91G0CXXNnAGEIL3HlQfxNDX3w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gizWebzO; arc=fail smtp.client-ip=40.107.236.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cwykvSGsIBl1hvMJsqHTyAsfNeVVx8HT9GTsiw5B/HihY1+bTaxylCmsPh1WqTxBupxRK7NVbn5z/dAzjwqNm09/TrtJxRI6qK4r1phBk+vrnQYl5NbDZkB0ZGlcBOZ12J43KPX23AVesX4r7etwu2ylQ4EzzHwSv9h0m8XbRSBDWLtZGLmRKxIOsgpf6GNqdNl5+geiW41MWuZ0JCEF+sr13nxAX9jK4ipG1J6Lh1sE+BV8hb7ka81FIACLkhxBg6oO+ahkEwdTQFTyEjB5bLMnXw5hGvQ5IhiIZrnGBQIZy/hCQ2/tGuHuUJcqJjUL2qX1bJUixFdMH5RF6375vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mStQqLxyi1GaGdOljMNeyLli2umQ+/mTws+AqcWarBI=;
 b=xM/u45zgE8ihrAClfh2Xv8z9vGBQyDrDIsT/fQGD2OmCvOWv3Re42tz/k4Baq4Lgia0l6fKuDMJUtdOsBDVqb6Fe7J0T9UJl746DW2n+TcKoIBRYIX5iwwwjMVfXhPfYZT8qhcuiuymZVOOh4fGPvV+e7vfVg9sk/vKTh0V1hWhMsFOsXuhvMVArt9O281HKkXSnwOWsZBGePts52uw5207dIGU+/YZcu2oQU7CFlBbZTybRE9YcKHTyvKH+RdIn4FW8BwGfhwSdMzzrlwHreQEIKbMo6pzpK6ZpMrjKNDNxDWkITxW/8lSjw45T+QfUCLjo5LI3EEsgmsfEPC8kWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mStQqLxyi1GaGdOljMNeyLli2umQ+/mTws+AqcWarBI=;
 b=gizWebzOpUBdYJZthkCTxa/qNtSz0PrvOoR/lEPORYVx8ohjVBj6N9+3NIrl3jtVB09mgwDMY/wxRaX7vvtExMPiGMnN/F/zA9T2Mc310Wu+hSVcOsUIIq8RJi+/ekmKFvaOBg72zCpyfzTrIDWvvnuxoz+QfLVVzCwz1EVUo1j7sXfPcs3k8657XBQ/l+/Fa3xRS6Ml+s1WtQW8PpchjXe0bRJxi1QS0oK0L/6ZlQD6ZDTE02eoEmOjn3Igu85rSEf4C3z/xoOFD3sScjBU8FOrM0y49hV+dnYJA21RI5G28P8qkobnSEqowvS5icIdCw2Q13vIvsb1chnq6NKnGA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by IA1PR12MB7760.namprd12.prod.outlook.com (2603:10b6:208:418::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 17:16:03 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 17:16:03 +0000
Date: Fri, 30 Aug 2024 14:16:02 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v2 6/8] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via
 struct arm_smmu_hw_info
Message-ID: <20240830171602.GX3773488@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <6-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHj_X6Gt91TlUZG@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtHj_X6Gt91TlUZG@google.com>
X-ClientProxiedBy: IA1P220CA0003.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:461::9) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|IA1PR12MB7760:EE_
X-MS-Office365-Filtering-Correlation-Id: d3f727e5-6e0e-4292-e4de-08dcc9176d1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pCR/0/eRJWftlamV5r0BI9BN6WwCxbg3jgGCojjXXdpL9fWFIeZTWG3HrAYA?=
 =?us-ascii?Q?UmZD1TUWEzzuMM7cHMoLWNZTqjC6O8kEDsY/9u6E7fwVntVMWKf2K8q1Fjqm?=
 =?us-ascii?Q?/74N4ysMmzrLgptow8zBJMcm7QoJzzl68xvz3rbBaaPVUOWjHKo5A3abz4a6?=
 =?us-ascii?Q?1Ch5NkYCrzDbJwadpeUaM2JOsBhiskP0R4ZO5xq2rxJEdKLXhLXFY4SmOLNg?=
 =?us-ascii?Q?DRRLzPcLg72LY3ZDETKufvM/vb2QoktI299MaHXtpekpOjAA42XbWHNlGpG/?=
 =?us-ascii?Q?lxBAtQhw/9onLMrndA8h2tnGSC/sIqpoRIL7QnclLkypWR8J+8GGkuBWC7/F?=
 =?us-ascii?Q?9K7BI146lpts+ilrVXlYbVB+35ZddkCeT7/xHVakJHX1GUggEUWfE/tUuzEJ?=
 =?us-ascii?Q?CQq0rILgDFD7oMwzpsiAUJZru5wNppE2l9DrekTHKC7hm18c3Uss2uDz/PKr?=
 =?us-ascii?Q?2pfVixT0adhD0bAsKvSRGJLIfntm5BXCHS0kaw3ZkJdO25SqnQVOhq1jpncX?=
 =?us-ascii?Q?zsCsPdc+DE2blZWQjtJZCJfyBwO5+YjJc8AgdAMqOheQv0uhfo4ZvK3XG2+w?=
 =?us-ascii?Q?POrqcodZLzGZ4F8KObu8oYKVkrZcp9aV1Wvv+UX6jUA1+ZWaiL4ef0zaYiBS?=
 =?us-ascii?Q?QKujcRZrA512e3wmBxog5J0LnbfU0YPeIGj1tv9fVqUJXa2Z6v+wONSHiOCG?=
 =?us-ascii?Q?33dWkbcDPCitPoEaZRzItS6XOAIqz12Dyj51Q4V8g+LAkiZOXqYZ9aKPxqvh?=
 =?us-ascii?Q?cHjzXB/w2oVyPyDbBLQRUdwzZlHJn7+ViprOROag/1uT6oatYM8Z0xiBXFAU?=
 =?us-ascii?Q?wK7dgKXKDIAwjWufFSnhA0oi6KQamxzK4v5aiiqmY8g/JjUszF+WrWBXinIK?=
 =?us-ascii?Q?iSb+aVhL6Jckp6PWI+kqqkkPAblUfkSgtOy6EYUlIrQjiTkU2TsyMfYXR3zd?=
 =?us-ascii?Q?EsxtSA+3qy1RIWBvb5R3e7o/SyDImX5G0oBtP9SG9gnIdKELoNSgNJFTnzG2?=
 =?us-ascii?Q?gADYBpTtHD6tqI9PVkeMtelwneTxNA1d/krAFW04QuJCEHnbIzvsKbGSc77b?=
 =?us-ascii?Q?13I7BvtfjE03KVvfmkJV/wB11P8wRH05lGkmbGlUPfCRWW5+yFsIcW3IOfWq?=
 =?us-ascii?Q?4l4d/2Gc5qoHEQBnrRNATcL6ERjsUtF8D3ti+UvodX6uOHzYlCdVhL7eF1LJ?=
 =?us-ascii?Q?1BNI4N6e1L6nQjRE87UB2N/BlQf9FI1J85HuTbZ8pdfP1Tic77qaqVgytqQE?=
 =?us-ascii?Q?hBOnqDU68ja5HCe4IuIbDPnJszW3O91OH1yY2mLTFAmLdDEkF9VOnDzcfidf?=
 =?us-ascii?Q?vT5uZKj668tozqiHYI45TjDGjBt+Q1fBqDasL+7Z8G7qrQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Yz/lbX9Y/lIdoVBRSBM3GTFa+1GuJVnIDdRkZuCArhydDObOidX+W9FBUflK?=
 =?us-ascii?Q?vjKOqZaHjlGjyT+mF/CwGxf8jvTX27Ba+VGxhK/CfOSCDycjP5arULHRbW75?=
 =?us-ascii?Q?BDgaRA2rI35UOKMn36/xowrM7tlmKQAH01i1dq7QRGXNU+J3cxwToCmzkBlI?=
 =?us-ascii?Q?KzVgy17qX19GrUzJrmYO1cqLkQXzSTsicZOmyuOxIP3ri+Vi8WaK6EHcaIj7?=
 =?us-ascii?Q?tTly7nURptnU6LI3AhMyZRI/TqaUAPwWn1zW6it/zml81llEVBBuhFLB8PdA?=
 =?us-ascii?Q?sMsWMRMI1xiq0BBG3moKulY2OQogC7Gb1ffkOtn/MIqtAPykI/QZOp+35Jnb?=
 =?us-ascii?Q?pK6vjN3BeDOoLpn6jxcBGSz5tg67P1Nck9XR7CIqC0qGVScvjMUINvBO3vOq?=
 =?us-ascii?Q?VEHMvLehGGx8p7UDvsECUlJnnw/YLVVjX2SXxQxCf7TXEcwdI0mxIBjTPr7+?=
 =?us-ascii?Q?Noiw2x6kc01RYG9rA6OTJFvt5TlPWB3qQa6uBCTeHa3cMVqXgirRps4efplV?=
 =?us-ascii?Q?C9y5ViBgp7yVjpnEVVSDEY06HVK5QBxbanv0nSCL37F553mgi2CUZ34RRD9n?=
 =?us-ascii?Q?10wZZbOxcrePdJL/1DR2ya9F74V/DfLm+wqJqJ+VZkVhFVxAgvgC67r2DSdK?=
 =?us-ascii?Q?1n0gNEL0nxWeV9o3sDj4tGeBWlc/KqmBt7jilA2i6rUCaWjhE230GquOlUA6?=
 =?us-ascii?Q?6sOTYfHmeIi/aTtP9wG8ohJAp7W8FxwDxcYsBttv802bAF3DbkIpIlIvBBRr?=
 =?us-ascii?Q?7CDAP2+MP6DY9+k8buRBJm5WvlP0RV0UBsD5OM/gzgZpMcVLpY6Zx01zEhDk?=
 =?us-ascii?Q?rXhcP+dP0a5nAVCCWuWi0yCxlvRz3d8Vim5LwoBR2XcVyu7AZd4XEJUdp9Wz?=
 =?us-ascii?Q?IpmUMz7GWsHFQHM9yPovikz6W3L941DDJEaj8tqj8pOe7VZjnpzUY/OpkP84?=
 =?us-ascii?Q?rDCL7E3gKoL7lbUtVveFF/gl8Yn2NAJnoe+0ATiDxg3EJb5Vdvs8jmT1Ouas?=
 =?us-ascii?Q?wzZhA5q7d5xOpL+7tQ91ODZdt6kK7slIozlvLTy8CvpJ1/A7iPKPLpwJaXVA?=
 =?us-ascii?Q?9jgguhTcB9L2UGqgw5qtblRnCtc8Q41LxiQvFya/Qktl0z4jRpCYI5yVHjD0?=
 =?us-ascii?Q?w3lIW/CjFD8pJ39l9lCq9nlRZb+w0jpSS0ITFQn6lRdS4693f65SCyly1X/K?=
 =?us-ascii?Q?kxL0D0NEA1EDrYCihWNx7blooAySFMIKPQGZdkr1vjk1XwIgdSzlg83QmI3C?=
 =?us-ascii?Q?7Ydbw0TPc48h9Cq9FrmnhYgOz58O8UqtmDqOC5ArRPDBR+DPrMmdpOU884PE?=
 =?us-ascii?Q?4twNl9v9cYcakAXtBlkESeK2KSgvFZFpWprSgAee+LSPZNvMecj79sZaWkNV?=
 =?us-ascii?Q?1yfwtU/jLzDtfy6aLLAtIIzeW8nyW3qRZsQU4IsaInHFspLW3CG4BeU6mJyO?=
 =?us-ascii?Q?B8J5ybHOae965+Y9FVEKOyN4YjQL0DSyChcQRBiYSEMSo4qTMBB4ZGZvJmYO?=
 =?us-ascii?Q?zSwEQTwVjCQmkmmzEEiDu3vhs/SKd7otlLY0pJeeXUWvbAzOjXT+7XtLOgJL?=
 =?us-ascii?Q?+Acgqz3tz+RFLWdENDettyliCcDwvgntyoz2gU5Z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3f727e5-6e0e-4292-e4de-08dcc9176d1a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 17:16:03.2847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ILBVqOO9gGZw3GHHeJjGZJwyDr01bZy9tPovB9T6+0t6Q8CNL3Lthc+cGr/34HD2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7760

On Fri, Aug 30, 2024 at 03:23:41PM +0000, Mostafa Saleh wrote:
> > +/**
> > + * struct iommu_hw_info_arm_smmuv3 - ARM SMMUv3 hardware information
> > + *                                   (IOMMU_HW_INFO_TYPE_ARM_SMMUV3)
> > + *
> > + * @flags: Must be set to 0
> > + * @__reserved: Must be 0
> > + * @idr: Implemented features for ARM SMMU Non-secure programming interface
> > + * @iidr: Information about the implementation and implementer of ARM SMMU,
> > + *        and architecture version supported
> > + * @aidr: ARM SMMU architecture version
> > + *
> > + * For the details of @idr, @iidr and @aidr, please refer to the chapters
> > + * from 6.3.1 to 6.3.6 in the SMMUv3 Spec.
> > + *
> > + * User space should read the underlying ARM SMMUv3 hardware information for
> > + * the list of supported features.
> > + *
> > + * Note that these values reflect the raw HW capability, without any insight if
> > + * any required kernel driver support is present. Bits may be set indicating the
> > + * HW has functionality that is lacking kernel software support, such as BTM. If
> > + * a VMM is using this information to construct emulated copies of these
> > + * registers it should only forward bits that it knows it can support.
> > + *
> > + * In future, presence of required kernel support will be indicated in flags.
> > + */
> > +struct iommu_hw_info_arm_smmuv3 {
> > +	__u32 flags;
> > +	__u32 __reserved;
> > +	__u32 idr[6];
> > +	__u32 iidr;
> > +	__u32 aidr;
> > +};
> There is a ton of information here, I think we might need to santitze the
> values for what user space needs to know (that's why I was asking about qemu)
> also SMMU_IDR4 is implementation define, not sure if we can unconditionally
> expose it to userspace.

What is the harm? Does exposing IDR data to userspace in any way
compromise the security or integrity of the system?

I think no - how could it?

As the comments says, the VMM should not just blindly forward this to
a guest!

The VMM needs to make its own IDR to reflect its own vSMMU
capabilities. It can refer to the kernel IDR if it needs to.

So, if the kernel is going to limit it, what criteria would you
propose the kernel use?

Jason

