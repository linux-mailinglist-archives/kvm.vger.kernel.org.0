Return-Path: <kvm+bounces-23375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D9C894929A
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 16:05:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C4B12813C8
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 14:05:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 446A818D626;
	Tue,  6 Aug 2024 14:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pvFSeODq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2063.outbound.protection.outlook.com [40.107.236.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DBE18D627
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 14:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722953145; cv=fail; b=NmW7StsBwHklg47v2jmOzAPKoo2e2lESvvB+86bSL+XV/j5TlKw4M4okDzxKkArztenVchPt6YzHS5TJFrs/UHBxhk7ietJ2g+ARX9WYVG8vj3GVuo+rwEsfQyGpUJjYxr/dkooK+v2unrf5NhO6T57H5W5NAHB4FSvc2MkF8HY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722953145; c=relaxed/simple;
	bh=tXHVU+RjtBxosSgnlFHob8KCpCZxvko0cDgGofS+4tY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iFyIVlvZ6ziqFLyoZF5ZraWKIWjxJXPQcJrtNCWgFaaH91TFMM9zdaXls1LjUBkyfW77UB8R4l0giDTB3zijUEJxFsiH1x1d8meoEgz7xv/M2ymBwt9DrSfbZvtFqKj5f0249lN9XFUzxHlEzIW5eN6/zHjJEo76vyuiQBqFoPo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pvFSeODq; arc=fail smtp.client-ip=40.107.236.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KcPcUQZLkbIDyfGyEd5mOZ/g02oGvHyZYE2XprK7l1fplPpby4jm7ohP5CcfuM5LWbhgp1F7AvKnkhyHaRmLmJILCNavsgFKIYVj8YmMHQyzExjeBmrGR51Fvdz7D5A22gB1CxyzS6gRjLSGhKEoHPS0g+Sf67bFahKfJGgGVANVXALJk0D5NOtZC7EbQONBtJGx2Ha5oIGOha+9Nbnrj6WA18DHVnqi/1m0vFnnSXuuCkbOEM18lQZQct3nuEbrnP+mHJvfnLmGldh+oxaGXnhKsSmxcxeyROUTlcPYefJnhgCMwZzxEe0nIaJQiQouTi+iZewStDDtzzPWnEPwDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UDVQyemReTm7xfYbJvItIT5A55v3ufSjVqez1axdKo0=;
 b=gMoaDhV7hRQ5HoQZ4mxTocd2EnLi6wg3JxRUjAW3KvhO+B0Pe/exSFotvmOJOElUhKZ5lmNBEVHDQUBD8muFD2FmYQ/CYZ1EBz0TktArHsxgXlUXkNfXLTfH9e6x3wKVOiSNpyydmaCYvRKQapv/IOMzRyv0v06wcJ2zkcf08dKujt5UryqsWlcE5g+llyE+TvFFAr178ifzKJlu25QGjEODBFUj1CpNEctld6tDCwwX7Zam3pp17oUMgDqMKlFwb3+CL87BHpNVXQXQlUwpo3Qqkw72DuPsI9vXOl/eiWSG85PZvLGcJwQSZhe7jh7TpdCTBfd8OB7jkWzx3FEUJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UDVQyemReTm7xfYbJvItIT5A55v3ufSjVqez1axdKo0=;
 b=pvFSeODqAj6mgm4VdxHaPSN+Wt8pQj+UUXZNBZk85pFc3lhLRjDbpxmb43bG7RJrCxGwchVuTDQUWxlncZM3QXXBRZ56tio0xTeVhDS03QsdvlNUO2BZ4nsR1zcMVXYkDZJ/8FLcA48WUzq/O9Nh0+FqWDnlgtjh7F6C7UL5CfBf7VSiKrGsCwc/co6Qh+zfXNWeNIfwwMduG80wNBOogITxy/T9N1dsS/SAhShaTB9aPweuJAggZvOo1kL3ImVojrwCPeayT5WSSmSCqdCY8TpKxfdv9AkjVhUejfZSPE/cEcvBrG9YjOE9gSrEIs59HfGpuSBX5VXhy2GV7CoOiA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by BL3PR12MB6572.namprd12.prod.outlook.com (2603:10b6:208:38f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.13; Tue, 6 Aug
 2024 14:05:39 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 14:05:39 +0000
Date: Tue, 6 Aug 2024 11:05:37 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>,
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Message-ID: <20240806140537.GM478300@nvidia.com>
References: <20240424141349.376bdbf9.alex.williamson@redhat.com>
 <20240426141117.GY941030@nvidia.com>
 <20240426141354.1f003b5f.alex.williamson@redhat.com>
 <20240429174442.GJ941030@nvidia.com>
 <BN9PR11MB5276C4EF3CFB6075C7FC60AC8CAA2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240730113517.27b06160.alex.williamson@redhat.com>
 <BN9PR11MB5276D184783C687B0B1B6FE68CB12@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240731110436.7a569ce0.alex.williamson@redhat.com>
 <BN9PR11MB5276BEBDDD6720C2FEFD4B718CB22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240802122528.329814a7.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240802122528.329814a7.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR07CA0018.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::28) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|BL3PR12MB6572:EE_
X-MS-Office365-Filtering-Correlation-Id: a8aed63e-c51f-4dd9-0b8e-08dcb620d99f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Eo2sXk3ms4qbZizTdH4iXMJtbJQmVXdc3Ttex4LvDgt6U52dJD0NXONSdYCN?=
 =?us-ascii?Q?HECJrnSmGSI4BZ7BUxDnM+pmW4Cr/NZltT2ejlso2iOSjQ7bFpRQ2KLNRNqt?=
 =?us-ascii?Q?kW6uH0QN5NQNnMNc6KjQaElAoKbkaYX9MGVxYnhxBmxnRmKf4nbkkwNGvrqP?=
 =?us-ascii?Q?blmeOe05CNZgZHZevwjhj418rXTw+60bOci0Dlc5eIfFjp2dc3z7/A99tgKB?=
 =?us-ascii?Q?zneQLH8DOz+QXW0Qfeja/on/OEVOKWEy6TFD/MWu28ZDgfp60IubmGl3uwzW?=
 =?us-ascii?Q?qAScKZnH4IjscJ9YTIkANOgq5v3BULHA2U8FVqrmS3Kaavpoo0Khf6PjbaGR?=
 =?us-ascii?Q?GihkLh1RewP3zYUEe0nMCKs9jyrevS2qpBMlAeELV040cbjGHC05CKwO5RYM?=
 =?us-ascii?Q?YLnxUD47tC9fWAUujSmq4lhBE8UmEMqBBd1Df9dAhTmRajuiixqtVc92RfDL?=
 =?us-ascii?Q?uv49R7iP3fM5vesoIIjR8dA9W5PJMVxTrfMauYeWCnN5/vwRdN/9DB5vd/aT?=
 =?us-ascii?Q?6jFm8WpHaxQByZzO2OZa3AfEcLepxqa2MATEw4QLiKu8r8lQQM+4gtL9Dxeb?=
 =?us-ascii?Q?NXhj5vifehQHSC+vtbM1ykzdM5oJ/n2zqlVIiOWeZZqqsoTS7v6zUy+79MJO?=
 =?us-ascii?Q?XabGsqsiGz1f4wmaLPBVjwGlu5yHHdxfOiD3W7Ghl+x3RfnLYtJzz6LhnpN1?=
 =?us-ascii?Q?OQjImJUQ8TthbiZGMxB7TbYL9wJ1Q7ZbiCOmjaMB/W8neQQXQQXcp2VW0zPQ?=
 =?us-ascii?Q?eXxNam0zKJtYjyu+fPI+CsW8uP9ybexvObXwmbgQdpMmTu50zQDZEll9s1HA?=
 =?us-ascii?Q?n0eDGupcqAe6rI1iQ84guniGpPXosUhbDTajss/0eXOsMOw+PfN00FDETUgz?=
 =?us-ascii?Q?CZQUsODwrp4hs5CQtf7+3qba8ocM/pj+MEyDHbGqkAmDVi1j6uD2oIJHr7fV?=
 =?us-ascii?Q?9ylOXmFU+fwXmq5TN7RU2ZFLgs42tIwtTgEo6JIv+otesUVjxH0QRYnmm7IP?=
 =?us-ascii?Q?s/LoFdxauaQeZH3I1DzfQjtA/fi0YXXHMTLGEiBdJhgpMs+hPeB9ZHv9JOyz?=
 =?us-ascii?Q?ia39bxFTNHA2Z/reywfO0yeI70ZAQKLiXiX+aCztp1fALzXxBe83M4EFGql9?=
 =?us-ascii?Q?CCgJIeo2qnsY5dUSqHHv9DT0xSzqtK5+oy7P8iNCS5lc+T/3iuioMB4xvRRf?=
 =?us-ascii?Q?ZmANSADsXu5NzTYVHYFhFxd6meZkY5iELA1a9Pm09FLlxUscaNcR5aYo5psB?=
 =?us-ascii?Q?lRY6WS5GFBKODjsJZuxNJJJMvfVQ3MuvOz5yjyxOpWEbsnXYnfoEBys6xY3p?=
 =?us-ascii?Q?4O/ZDu8gVuPN7wo/zsV60tVZ+ZAQUTVjMxeNcL+SMmRozA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?l72gPe1aoT68kfba+oQOrHbYUjRgOS07THTK5ASHTO0XYwwrLO0AFW/wpTur?=
 =?us-ascii?Q?tyGajsnUPA/MRAp3675Opx4v4JAFb0pOuR28RJ+fz5wLUQIYW9xeRKyyktmK?=
 =?us-ascii?Q?seIbWyOpkjl6Q7LGOh8bLFiBJQGHkeM8GlWVQdOkC54O7mnYC6xRepfmZmAq?=
 =?us-ascii?Q?Kl6D7dJBCBGUQox3NgM029SSpxorcm4qsN0TBa44PqsLLxpPDN6IQkdbKLlt?=
 =?us-ascii?Q?XLxagm7WOgHLB4uikVYCce267uDhnOr/x+PCGpxIwz6fIMXbNqpsmNFYal3t?=
 =?us-ascii?Q?mhA/ULc4+1DGyAa3Vp7EnBIWIzOV7jVXxbcymsvdyfGrsru0s653XFmnPcPP?=
 =?us-ascii?Q?ll7LptBwMWiMz3vtYGDNmdpRZqPQX4makrhK4FTwlKCkeBeI40vwuUk7ZaqD?=
 =?us-ascii?Q?VNwIkRFqAu4U/pTZculjfWW0R69RQWhb/QcDMhVVAVr2lA1Pq0umlMo4+rN3?=
 =?us-ascii?Q?/stHxv04w9l13rKZB2TrD4+tSIb5JBnAcyowEa1yix/9XIGY9C9MPbXOG7lx?=
 =?us-ascii?Q?UwQbgnNB/KXcaJSPMu6Nr6oWCIxpwinjCeFXicw+aI4/3OXv1QIOwDgNRl44?=
 =?us-ascii?Q?P1KDD92ALD20L7Qs6JOsbJgomRqa6HxJXVLKOdonqrzOQeTKw/tz91qEewrB?=
 =?us-ascii?Q?X3FnMwAIJz9WpeMDHDj56/t5SlgKSMeRM/NQHNodVCs9p7H13RYG2easjSop?=
 =?us-ascii?Q?kCiMZWu8mxFyeHbf3FBCSwh6Bcij04pNtX2qyPafi5AGj8Ga8OZkk7ksfHK1?=
 =?us-ascii?Q?GrfrXZJVfnhVvocO5PLH4XAc4pFR9hXc8NKSKmJAL4O3CaQSvULdd22KRaOv?=
 =?us-ascii?Q?pIsfMxbaKdRcMF3wn3ujtCAOvQOe/ulyMKPyEIiU1kkEgMlhpEiSvGRLbLE+?=
 =?us-ascii?Q?zeZ8l+Eg/n5flVpL7F1uzOSqbtG69Wt9f9tqjqZ+ezYy/bjBUTSSgVgku2nr?=
 =?us-ascii?Q?4B5jhnwUXSb9E8vmaXB5LhFFP6Maz0nk0MRFTGjeET3kK6b2q0r7UuZ+1Lzx?=
 =?us-ascii?Q?l67jfzkSFAwadihOUDSP7sVKqJ2zuEuJREC2/cRA3kdVE6zymkCAQkrMp3iC?=
 =?us-ascii?Q?trpS545bw1VJmxCxUyRWd6AqhK3Gtb+8bXm4Ik7s0/Q32aiSsC9dZ3A1Pmeg?=
 =?us-ascii?Q?y2eZqwEd8EE/P/SBuh06OB0uq5UanBY/hYe6xErJDHejU1ofslopWqSBUKyp?=
 =?us-ascii?Q?gS4uc/x6AGo3hpctPlNFL9O4RLvbWe/zpuAhJboi2GlNN4q8gh1zQW6LR8O2?=
 =?us-ascii?Q?d4sY056HGZsD27Rb31xCcfHx1VRg5XJF2o5FCfLikvMzhliSdQXf7s/Xbcjv?=
 =?us-ascii?Q?o9HOrMqar8NPhGnsIyP7Asc2YMqvfwAp4t1YKVwbIFyZybIa6yxnmctnVOb1?=
 =?us-ascii?Q?QE/AzLJ+4flRC4RRJ/Hoh5GMZBVkFK8JUhrTF9xQ4MRpGx+F25/6zq+RQrSr?=
 =?us-ascii?Q?Cub0jMxoIVEaXWUbNXaLwu9GTSMA7K4ICf4oEW/QtPjLgw6i9UumxMtammkG?=
 =?us-ascii?Q?qZ4t4bz28y0CfMUoBg9Ngy3Cq2pkojbjX2Qv4RA6dIn5NS+/2f0Zq95sEPEE?=
 =?us-ascii?Q?AS5Ub4GiZzY84UV1ZEo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8aed63e-c51f-4dd9-0b8e-08dcb620d99f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 14:05:38.9786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nSKMBjELXcCxP4rLBekpbZ8nxQ7IihlqyGxILSonWWXI1ww4wXC4cH8kWWwGziYL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6572

On Fri, Aug 02, 2024 at 12:25:28PM -0600, Alex Williamson wrote:

> > I envision an extension to vfio device feature or a new vfio uAPI
> > for reporting virtual capabilities as augment to the ones filled in
> > vconfig space. 
> 
> Should ATS and PRI be reported through vfio-pci or should we just turn
> them off to be more like PASID?  Maybe the issue simply hasn't arisen
> yet because we don't have vIOMMU support and with that support QEMU
> might need to filter out those capabilities and look elsewhere.
> Anyway, iommufd and vfio-pci should not duplicate each other here.

ATS and PRI are strictly controlled only by the iommu driver, VFIO
must not change them dynamically.

Effectively they become set/unset based on what domains are attached
through iommufd.

PRI is turned on when any fault capable domain is attached, eg the
HWPT uses IOMMU_HWPT_FAULT_ID_VALID. I'm not sure I know the full
story here how this will work on the qemu side, but I would guess that
PRI changes in the virtual config space will result in different
nesting domains becoming attached?

ATS, at least for SMMUv3, is controlled by a bit in the vSTE from the
guest, the virtual PCI config space changes should not be reflected to
real HW. There are data integrity/security concerns here. ATS must
only be changed as part of a sequence that can flush the cache.

Jason

