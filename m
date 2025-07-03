Return-Path: <kvm+bounces-51488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F31AAF75F4
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 15:41:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FB0C189AB6A
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:41:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 228B82D3226;
	Thu,  3 Jul 2025 13:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Pv2TvrJ/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8878723D291
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 13:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751550074; cv=fail; b=JcCofmLmTCMqpzfUcDT/a3BU62pAQFI0sLS6sdtaTbepN2RCIe7g35OyULRZe0Wjn8rZYTceqpmSKy0F8+db61NtMlZE7Z0L36CdABaQyNcsVNBFN8Lsyo5TBnMA8l9dtgJ0OA+WGblW7N0wGXiTlGI/I1rYlzlUTbIHW1EEOxg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751550074; c=relaxed/simple;
	bh=0Tl2VDqS2PK7O76f1UstEcHxHPwEfJ6B0xc+6WV/tqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KCHB8AfmjJpG4XN6teyDy8hbnGvg5VR2a/9IqXcZ3aSPGm6F+qRHGwK/kBtaLs3ety8CgNsEVMR9XhdOsaAmtAhohipetL/5LDSJy/cA3qRzk6+qwpkz3Ndapj6+D9p29Bm2jLwjbI5IokqZdsL5Lcxk1xFfKALhHaoS3jt4kQk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Pv2TvrJ/; arc=fail smtp.client-ip=40.107.92.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RgBWFhku2lwcStMDQTITiUsecGGC4r3mW8Z/T1A3I/ddSYJ1N7mQffKJmAbpih9xnkCX1rdbUCpcG2B9BM6hfS0SmhhYITmVsAQ2vZH72TFTB7NaiYfIAmCTTRzn0r7LgoaF1edTmZcf+WmVVy852b1Vl6I4gsM6ZjyS3TtXvYjYcldhDhB3agb4ioKHGq/EpmdZjp5HO1BYmReMKZfGfPd9gm33tsl335JikpdPXkYLyWpa9DJk4FBRke7UkW0Db273qIT1DsMJNkxbBeDGk1peu2ip5fJJCyRwTInkyn38bjN8Qhk8CyIuHUjFnf/xv7hs43QMP1bKfB8y/aeDXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5enDP/biIb+QolT5EteFCwG4OVh1SOQScvyXKNO01yg=;
 b=kaFlYhurMd3+3oTFqGYnIpaz7r2WJ4ptMf7LnH3dtKxcOX9eNt+qwRe9Rtsw5/jOHsRJDuFOwsvaQy+o6/5K+JHug6vjmw5qzuAyiet2a3BrqJYuDpVjzJITVt4oeqq+35hMZDalhbXr2eKuF8dCSk6qWG7BUaXll6Ozjb0InbDxKNo60IRYnueUmIVR2CVqdCTk2yS+JbDmWWOtS0apQtHkgsGSAWDUGsaFKWZ2vq05aeeDS+zjp67wBH+Alm9XQwvMxy1vkcRolitB/xBD9aQz+1Sd2ApJNAHi+3ADPItbwqqvLg+POkSF/nCeAiGwREPftCcVV2/2WToGujw5Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5enDP/biIb+QolT5EteFCwG4OVh1SOQScvyXKNO01yg=;
 b=Pv2TvrJ/T3hMBA1gUKKdTWeLLFHrKsFXt12tVHn3TUrXktAPEEgPbGO7p3vhOJ9gWZd6idwIBCCtWvURKmCwUaxmUSIMLLm9TWncXbTskpSTtbCukdHpu93rrhO1VB/ShH9XDyKPG1ZGYFaRTzAhM2P9543ruHJXCYxMJq0v9VXHYGEBX55BTMjOu2WnTtrRndWi6TjoV5db9oM6iJ4HggvB4Otv7iOjShCPl6sq5T7nNk7cMrCIlj8LZ8Lrq6IBURzPBjbFC2xgxTIYj7QCxVKGeC14sKe6d0h7w1bprf2924AbfHYIcHBC+pdt+UKT5ekuzSWUeH6fftqokumMSg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY1PR12MB9649.namprd12.prod.outlook.com (2603:10b6:930:106::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Thu, 3 Jul
 2025 13:41:09 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Thu, 3 Jul 2025
 13:41:06 +0000
Date: Thu, 3 Jul 2025 10:41:02 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Ankit Agrawal <ankita@nvidia.com>,
	Brett Creeley <brett.creeley@amd.com>,
	"Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Longfang Liu <liulongfang@huawei.com>,
	qat-linux <qat-linux@intel.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"Zeng, Xin" <xin.zeng@intel.com>, Yishai Hadas <yishaih@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	"Xu, Terrence" <terrence.xu@intel.com>,
	"Jiang, Yanting" <yanting.jiang@intel.com>,
	"Liu, Yi L" <yi.l.liu@intel.com>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: Re: [PATCH] vfio/pci: Do vf_token checks for VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <20250703134102.GD1209783@nvidia.com>
References: <0-v1-8639f9aed215+853-vfio_token_jgg@nvidia.com>
 <BN9PR11MB5276CD6181F932C70CBC800E8C43A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276CD6181F932C70CBC800E8C43A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: PH7P220CA0054.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:32b::11) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY1PR12MB9649:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b2bce12-bcfb-47e5-b959-08ddba37425e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mCWlb5A4F3K5KtNwODHMtQ8xdW4NSzS2Nnn8zpe1ZX3Xtyp8aRFLdFDOSSJx?=
 =?us-ascii?Q?om/jDtjjOht5rdVgUAYJ8LSPDB10yMjeYzgZ2VKVjqZlKS4MRLukv/ISLvL4?=
 =?us-ascii?Q?nVPUowixeqHR3yINelOXr1Cf9O4coZWJW8+Fs/aS/St/QeHkNd3PlwnKcMGd?=
 =?us-ascii?Q?5GHHue4SUVmj3d7D857WLxxhhZgal2FR0nqJAuEP8PAR/PvfRGnJP101J2US?=
 =?us-ascii?Q?rXpCD5xxPtlXJUyHeXKsZb9735LUB7+tCRUdIt8cBWWeio1zhmC82bykUB1w?=
 =?us-ascii?Q?8bnXtvRLjoCls1U1zBca4HjeBd/lDLxmSx1AaK4x6qicAxLyjcT4zQPrRvqp?=
 =?us-ascii?Q?1i6wZduOmSl4O4tw/eK56k/PQduKPZ8Vef1CEYumBuwtFz//Q2NheaJcdHcW?=
 =?us-ascii?Q?5Zgsm4/EpfptrNQcYtrTGMyyDKxX7v78kjKuhnqTOZRJ0beZe6u8HnvuFYKN?=
 =?us-ascii?Q?7Yks/8oKfrOgbm014WIFXkYamlgNnJkb+V7qpT6CQYkvSdB4aD6U0k7CVvcw?=
 =?us-ascii?Q?rsnyBmNkieK1WznkzFe7qP4SSngPdhPLd3vn75yqAQiac0cy8W4+ZYZURKhP?=
 =?us-ascii?Q?04H4QIrN7VZpvaepHVQcyeu/MGwVVBiRQePeOa3r6/ZIU6P4A6D6P5R7Wfdf?=
 =?us-ascii?Q?wmm9khWO6sPae13KPuHGP9i+o0/+7Mf6OelSxI+G6SY5HrcnFngG+eC8dB+l?=
 =?us-ascii?Q?GCMRafuTZvJvNI1Qut7Ph7x8YKdmSFdnEERNTxOArc5wCDDeFrMk5naSYsfC?=
 =?us-ascii?Q?Opcaq2SFENe3rOOoRNtmefA4k1XDBDzA5PpTFR2/iLRGOiE3+ykAISOyOJb7?=
 =?us-ascii?Q?jD17P22Z8OMotA1/wcq/bzQ0Nt6rPeXTHNT4kPHU3YyvbygD8IMHKHUgcaGX?=
 =?us-ascii?Q?8s/PFVJPTWKHWwH27FSq95VfGTOmXGI6zAVPmaWmWjTRXOq51rm+pOWFjm5i?=
 =?us-ascii?Q?WiTH2NQy/HG8t8BAsD/Nod2IsOUr57IqOnfSguIlJbFjM/T1Rhbzmjdv5jpq?=
 =?us-ascii?Q?PKZ6ugg4PogkXCFx6lfiAPT035tR4OkybYreDG2SWSM0JSfCxojHVkbDb++e?=
 =?us-ascii?Q?osdoqUMJEq6slIsHz2P68RyeyYMArbosa7ym2I0uII7cOheU3YQCuFr0kT0A?=
 =?us-ascii?Q?0MCO6BVZyEV1UzpZJbBor94UA2bCFMl3Nbi9Wy/hu8nduSa6YX2qot+RBwtp?=
 =?us-ascii?Q?a6dx8N69U0R+gytFW5jze3w2l2pgq7Mqtr0dRbuPHR65kZBvn97npX1JPOdj?=
 =?us-ascii?Q?v+NDLZuJ9iGLgHMSCNvYPCE4jZExwxfqsmbIVVD4JKoS7KcHb/lL/IFnyEnk?=
 =?us-ascii?Q?vAYeE5fnj6GLzZ8lwH4Ni6Jr3pYoszJ9MAsv5WwfxVn2rNohHiGotGD7ZoiR?=
 =?us-ascii?Q?BC5Bf5xbBTFvGNvvNc0kZnUv21dEjX5qflaNZH5Ao7rvtNxMSwMlyFUBEIxX?=
 =?us-ascii?Q?USyLMv14v5w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oT6R92tF/xqvro9WkcJUcCC0ZboeLaF8uHfy85n5YxP187Syd6TKmbmJs+JO?=
 =?us-ascii?Q?DhO1+9wUpD3n728xqg2n/UGrTTs8d3FjFFqsMg9GVQAFF0QAvpm90bFapeU7?=
 =?us-ascii?Q?btK57Eg87vctD2kTdW+2ZbqFTag4iCqmcQymoh3Cuu2aOWBj1NMVQGI9s/Jd?=
 =?us-ascii?Q?j0DOPSqfYFtUT/R/iCfvYRSeXSV6tjA2eS5BVHFCSL8C/+tdGQU9gp3kqfRu?=
 =?us-ascii?Q?cC+YqImRODPf2vC7yuBnYf9BkLX/G0HwYDwyTkYD8+OcV6liKtK6/qn4EmpC?=
 =?us-ascii?Q?b0I+XZseRiiyQ00vZcjIt9/m5ngUilFA0OWt7W3L7OXwoDXm3J3Qe69iHsDj?=
 =?us-ascii?Q?GNCnDIMnL6RMEHrjxtG5GZ4D8Nyye9N7PtI4n40GnNwRGa9YidtmDeq4hJy+?=
 =?us-ascii?Q?Doiv2d1ivxZpPhBmRWsPXdJNeSFOcO5RnAQvzsZiIEScFeQC3wWYsDgrIElV?=
 =?us-ascii?Q?DG+oYFbBgCKmhBP88O/wVX1FJOYjtrCkyIwDslF5XJJHOmGugkkMH/nKufp3?=
 =?us-ascii?Q?DR95PnG60U8/g5Hnlgqyq/SK04ssCEKw/eLDScrWzm2ISautxMtBq2gg6hZ3?=
 =?us-ascii?Q?8Pt9fDJb6aSE2i5j40EAQfpSzafdwgkj2Ll/nXK395BfJ7Pm10UxQ1lZjQcg?=
 =?us-ascii?Q?RyTL5MUeGXSciQ1dxsHQrQZI89iKgE3wJr3GuG8MFvCB341LOjBMpuEpJCfa?=
 =?us-ascii?Q?aIMaLWR3JDxZwxL/2LXyD8bA8X0cexl5K7SH56yWz2oBMXDc8AynAwoLwZ54?=
 =?us-ascii?Q?vVcOAMBnvyx1e3xIiTGHtQ0xN/+3WbFuJh/XC12YLc2+6tPvMCQYxOuV6+Gg?=
 =?us-ascii?Q?aLQiP+7zt5kK1mUJ+mrkICwebn9U6SmbrfADFQ3EkA6ldor6PORTu9HSU1Ka?=
 =?us-ascii?Q?NGJnFZKaSCWgTiUh3GmxM5l96yTRbBbteOIbXPfHWV8fv6YiQsX7bYPMMj2i?=
 =?us-ascii?Q?sujYvNds1VS+mUW3unKJamm7m4U+jBgCzMDa0GYr7Np8mAAiESHz44IIZdQv?=
 =?us-ascii?Q?wj6o6Z13fqDZFidqzs4xOEiU/ipjVFf9T3wrAvvonz8BLnd0GemtQXthNOgf?=
 =?us-ascii?Q?SdoTZWPZUgWP+QShn1LsRK2REohEs5cPpUfEO8RywRrdJyjEpIjiHZuXrRhK?=
 =?us-ascii?Q?FBeNsxP05/MYMuIa/v/Dha+oKhHpxX3ug3xW6Cf5MbPGC6KeKuVF6P0OjiC0?=
 =?us-ascii?Q?NVJBI4HlOppxbACoJfycM+NNo9mmH418Mqf9WUM9j2pvyxEkuv0sPuK6Zoqa?=
 =?us-ascii?Q?7LxuD7aBEbh3bsw9yi2MCY7hAYzqo20B5wsazMcsDCsoU/ZpCRP9ydyJVF1f?=
 =?us-ascii?Q?RDcW0c08KD92pgPSFjJ4sTBBJ5pAE9a1VAbYlf+8d1T4EyIKYxlKF8BKUa/v?=
 =?us-ascii?Q?tWVvSE79uUHd2cq0NOJAHjvQcvXHU1WtrXO9k/9qjBKPBNWSFnRqRDSwbSb2?=
 =?us-ascii?Q?GcI2zyALqRPfh6TQn1/CNUnG+L4ZmsYcbOjcnaqChhHH/SWPq8c2/HlsQaTw?=
 =?us-ascii?Q?kYh908O68pTx5ZC2iWHIA9O6l/M+O2wyD03s4uofKJpCxqRa6JbwS7Ug/ULy?=
 =?us-ascii?Q?yr8sd+q95vM/FWZhuJu8kq1qTg8DfnEnq0ZJJayy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b2bce12-bcfb-47e5-b959-08ddba37425e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2025 13:41:06.0445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: laruOSexSz+JPdAnJ9wh8WCxcTKHCJr0lbjjp8+nyCjF/XFn5fYg1lI7k8KX6IMX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9649

On Thu, Jul 03, 2025 at 06:40:48AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, June 25, 2025 2:35 AM
> > 
> > This was missed during the initial implementation. The VFIO PCI encodes
> > the vf_token inside the device name when opening the device from the
> > group
> > FD, something like:
> > 
> >   "0000:04:10.0 vf_token=bd8d9d2b-5a5f-4f5a-a211-f591514ba1f3"
> > 
> > This is used to control access to a VF unless there is co-ordination with
> > the owner of the PF.
> > 
> > Since we no longer have a device name pass the token directly though
> > VFIO_DEVICE_BIND_IOMMUFD with an optional field indicated by
> > VFIO_DEVICE_BIND_TOKEN.
> 
> not a complete sentence?

 Since we no longer have a device name, pass the token directly through
 VFIO_DEVICE_BIND_IOMMUFD using an optional field indicated by
 VFIO_DEVICE_BIND_TOKEN.


> > Only users using a PCI SRIOV VF will need to
> > provide this. This is done in the usual backwards compatible way.
> 
> and PF also needs to provide it when there are in-use VFs:
> 
> vfio_pci_validate_vf_token():
>          * When presented with a PF which has VFs in use, the user must also
>          * provide the current VF token to prove collaboration with existing
>          * VF users.  If VFs are not in use, the VF token provided for the PF
>          * device will act to set the VF token.

Too complicated, I'll just drop that sentence.

> > @@ -1583,6 +1583,7 @@ static const struct vfio_device_ops
> > hisi_acc_vfio_pci_ops = {
> >  	.mmap = vfio_pci_core_mmap,
> >  	.request = vfio_pci_core_request,
> >  	.match = vfio_pci_core_match,
> > +	.match_token_uuid = vfio_pci_core_match_token_uuid,
> 
> this matters only when the driver supports SR-IOV. currently only
> vfio-pci does.

Hmm, sriov_pf_core_dev requires sriov_config, but the normal vf_token
happens for all vfs and there is a little debugging related to it:

			pci_info_ratelimited(vdev->pdev,
				"VF token incorrectly provided, PF not bound to vfio-pci\n");

So maybe we want to keep it. Otherwise it sounds like you are
proposing to remove match from most of the drivers since they don't
support sriov_configure? Which ever direction I think match and
match_token_uuid should be together.

Jason

