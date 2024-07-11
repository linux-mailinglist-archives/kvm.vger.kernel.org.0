Return-Path: <kvm+bounces-21437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C383E92EF08
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 20:41:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F4DE1F22D4F
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 18:41:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B39C16E876;
	Thu, 11 Jul 2024 18:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FhvhAMjO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2084.outbound.protection.outlook.com [40.107.102.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05E116DEC8
	for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 18:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720723287; cv=fail; b=D70DMYxeoYuLcXJuVh5B6aHc4Urx9CiGDNLwW0Vnrr/8uVh9uAb7OKhdz5RmHYJt1jTcbBt7u+hO7j17EdTI6pK16t+ws4S9WJVda/c3QMG0/c5abmntQgcJqGAVk9Bg5SLj6RXpxZwNhxZCkJwVyFf/+KdMINauUHJh4hxMg6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720723287; c=relaxed/simple;
	bh=uM+PG4Q1CJS9/N5O0j+Ubpzz4Ine5oCqwxJzIAaQJc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dhgwi3iH93ZLPM2G2CnBmAo/NPNC6LCmSApOUIytY5VrscR7Pvo7Uqi3NFfNHk6SNwl4gWCPaYZh5aSz02sj+W/3geL6fotaMfgdunlC/WcT/yqQT76Ks0fC8fKf7TpvVZQxf8eiyrKj6UnzkkblaWMmHdn2KHWDhhRJ/vAFSYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FhvhAMjO; arc=fail smtp.client-ip=40.107.102.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jqxWUOtGkgEzNWA4PfQ2yWdwhnmN6wYFKfXnRfKH4qCoG9PfMvNuSTN/12nBDIdy9Lrb1Xym6381pqhPGaquPBdIcuzO2kS3DFBud4r5CSv8Jqc+thFm8V8sHAOICAXCIJdjR5B3aJFjdFGPC+9T2d+rJUwm46eUzvlzrTfL6ubjV1svjhFg2XrSHr8YUQVsXTRLW45Eyn5Ou2Dam3dWdh44NKxpzCcb+uiErwDztbb6qd6tXboOa35y5WwkYnbAhj77gnZ5ic1m72rb/xC8gaOZD+6CnPgy6NFZzvXKajoAcTDXQvEjTnw8coEtm9WvY3K0tONEsg0x3JB22bfRqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8oEWO9LBPE7cq2DydO7oLF//BgwmwlgCZD6vgvh4R28=;
 b=YnKVFyX6TX4p8VSIRf2np6o0wCulY7XJnQg3g95BRaS1qNs7421syFrFx/e3MGNRuNqgTSIkHykikpp5LnzVpKOTaeWPAfGL78wbQpEShLiu+kGSgHJAvZugYdSj5BQQwaB/rP5j5BCWj01UzEGPOO8oyBVOcnI8Ub/zRdI35R0Ah7Umt7KEs6EPR6ErYKvDvTGe5xw1Gx4iwIyHuy6BjG3/AWPGZ47UGqIJw0ZR85p83tt3a1EZ9mKW/5imuomThzO50d7FsBnQ7SSFqqKJmdkedQjyrzCPDHDgzWssVCkam+/uWTsYC8bLv3bJyQM8smESuQgC7GDXmdUPOA2qRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8oEWO9LBPE7cq2DydO7oLF//BgwmwlgCZD6vgvh4R28=;
 b=FhvhAMjO4QLHQWww6OMiFdQZ68PbjBce3UyX91Xng9opIfGLKNBNqV4okE/0eRr+DspHyfoqfP1tQThi3PtlEWhXAL6Ku/Bv12v9RpxGmVDEfbD6SENHABwjxiYKMCmEYNQv2S3BnL+7Lsb9aogEbztBK7BnD69ed+ZpLKwHIicrAxX0y8jjcfCIxSPausjo9OWuQVXGRxoy94qTIpwzDtV0YpLbsjavQl8iU8CmLl+weEC7+VxUegFYUjZojbjct1V+twAnJ4GWk9k5+Utch/RdyiL98rJ0jQkB8ZLOx0uMSXlRfqki0xSIQv6ql71eZSagbl5Vq0sKwB+ZjTxKkQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH0PR12MB7981.namprd12.prod.outlook.com (2603:10b6:510:26c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.20; Thu, 11 Jul
 2024 18:41:21 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%5]) with mapi id 15.20.7741.033; Thu, 11 Jul 2024
 18:41:21 +0000
Date: Thu, 11 Jul 2024 15:41:19 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: Re: [PATCH 0/6] Make set_dev_pasid op supportting domain replacement
Message-ID: <20240711184119.GL1482543@nvidia.com>
References: <20240628085538.47049-1-yi.l.liu@intel.com>
 <BN9PR11MB5276F74566E3CBE666FCD3BB8CA42@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276F74566E3CBE666FCD3BB8CA42@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1P221CA0012.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::6) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH0PR12MB7981:EE_
X-MS-Office365-Filtering-Correlation-Id: 641816f6-ed82-4851-3ad4-08dca1d90ee6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2RSZhi8lMKrJPlqqI4qyX6gROZXtPPQXwyRpfD7u8/7XJUm5BRiXoNPjGTK2?=
 =?us-ascii?Q?pcm/f9sINadrI+8YRQo37TKUVxKtpqgu6FZXMYaVyzD4nEXUkicREByp57BJ?=
 =?us-ascii?Q?YKzrWoaQI7FYxoC8p/r03ZdovUc3H+NrOeCO00QrpFj7Xv+0lxxiMGpheKJ2?=
 =?us-ascii?Q?QmSiCvUwfRUDlNnyybKvBzg1f3hzbgaC9syckhbiOL8mTjQFBEexn1Us0ckV?=
 =?us-ascii?Q?Etf2Uj7smDr8F+y6PkrYOpZEwFgO6o1WBPEf+TeKSy/Er5/vlozMHzsA8Ycj?=
 =?us-ascii?Q?V8i4snC2pf1lm1M7/GpPPS7BiKd1kodaYvtafoZ+rMayLPU/O8oxpYd1AePK?=
 =?us-ascii?Q?aZ+3psmhbnImQYB0J/aMlXKjKb8zCYd5L/p2gQkAdYpGihKYtnXvc1SzGkTp?=
 =?us-ascii?Q?wEABTohbY0z6VaZgg37LCbsvnPfVez0DBnAZW1AUFTsuTYdNXJktW+LfxjUS?=
 =?us-ascii?Q?sQJD02PCi8aW4GAuOo8xiSmEAxqL5wg5bNiRYc4ARn+545oJ/9zuND2rOpOj?=
 =?us-ascii?Q?aBMRKDoqCzhDVgNk4aA4E008/KkmYjgcVnwD1P0x9nWvxkPz3jYsYqpxzueQ?=
 =?us-ascii?Q?p+pGoghI4RmnC6uo7AOBPIMYUeNAs/90xBqQQsI21E4KxVv0I5o2TASNV+4P?=
 =?us-ascii?Q?qoLeHt+Rdjm66OHxS+WZKe7UbQYzLYq/aUU36gUc2GETiD0DbjNWDSkXDTOo?=
 =?us-ascii?Q?Hp0a/X3pMo5emPrqgvK1iWvbOgM6FBKaQaFvXx8WuoEUudh612/KOkkK5OiJ?=
 =?us-ascii?Q?Ubwkvnv6vFtfQeOXFmi+UPHZLKbGJ7tm66ZHfUBxg7Z+k1hUU+SDEyOBdU3F?=
 =?us-ascii?Q?7m1YvG3hVV8U3s5+dkEuB6rDHYDGBkqHcLFva1p/AxQYGFkVqZt+7fbJXRz2?=
 =?us-ascii?Q?fTsF7SB9bf/SJljA7u5XrEGKGS3abJrDGzfsCSavu4j9oRnDTtRnEFmZzZQu?=
 =?us-ascii?Q?fKT6oVap1dyzzfvVKd5rRbg28KH2fXEcyU71Gxa4FmRMUfGOkIlmzL0YUQTH?=
 =?us-ascii?Q?uPHlyHKe9JgdxNLKRD6hiWOOXf8gcD6Yc6kJhxYpol1nl7m0c+Gyh1yYOGBR?=
 =?us-ascii?Q?2rWf1SYoORRoTcdOFDpVHX/eTb/2VTyF+IDjnCw0C0FLLVz2XP75pwiGFkCm?=
 =?us-ascii?Q?OpIrPEy1m/LSpHSwCwiqIMMy28I/AOw2r3VPFGdv5pib5ynqz/XnmdIKKB2Q?=
 =?us-ascii?Q?vwIjL/e3oo631oevmV8ctsbOn2JoieaFonAbzXxwIvmMgdSo126h7qXMq9qC?=
 =?us-ascii?Q?L3OAhU7VcU23shsScEOpPobklBQxUexnGgavxQgwDABWY4jRtFWwjRPtLZjp?=
 =?us-ascii?Q?Y7vOhIidztA56ctfRSnanvbzLhvzD3qexxFSqqpdal6FKQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YjAqlrexx5ES3s5Rto779ba7/CFhevKSQ5Esli2VrgQUy3y2JIz5RoaQN0X8?=
 =?us-ascii?Q?iHahi16HY+o//JCVeFv61tFY+ONueeoahvGrRPyGU8JBEoTR7iprqdFxaBFl?=
 =?us-ascii?Q?tSah+ritBYZgIvgOxZHPPm2eqlOHMOGffK8obcE2gRZkruUusVWxgc8xhRmj?=
 =?us-ascii?Q?Ip/Ngekcn3KujtO0tj5xG3nkF1Q+ovkOjDR+uf/2luzS1OOsTcVQXaNpRfVu?=
 =?us-ascii?Q?f32EATEbEoWnivWhcss0g0Pu2h78MeP1QIA380dIRX6QpGLvBIVgBW8UT2gn?=
 =?us-ascii?Q?aSifMzm25UxFS9zohD4W0Dv6OQXkequsC5Ozc4AEEzuQ6brTjEaey/eA/jqM?=
 =?us-ascii?Q?ZJ63ZOvWBwcsrGzcbq7H5nsPwOk09cWSMlOE00pyQ9QzErRXQ5PHcAe9mHNO?=
 =?us-ascii?Q?bZBbjvPOHiuY9ADy6adE/QwM4Ndr8ZAJdY5NtV4qrQp6Uc1LxeNhtzegFNAy?=
 =?us-ascii?Q?5c24PeHfzYEXMTzh0Y50NPk8TONgyEhaYrhqjmaCuyOB5P0Mh1332HQdPxtB?=
 =?us-ascii?Q?ZkbeFx2R/vcBZofgGXiDkVgFdJ1S36iwLfaZ8DRKfbd4Mi3IbwKpWwtP4YBp?=
 =?us-ascii?Q?LXxyjy0PjSjt/XzFNjdvCpUEJdRTVuH7WZoube1ykPGrh6pW9Haj6DA5wZwk?=
 =?us-ascii?Q?XGVNPzsz4rMaGgTUDnttb1jUKOC/e0dnAAcO4sgvei96DbA2i7t305YXL2N7?=
 =?us-ascii?Q?FNV6qBWHXEeHmharJGAxjAzj9A6nFQRriiVDRjmG/TlPJlaYDP+IKqpgIiMB?=
 =?us-ascii?Q?sG7Pp6b9dko1QPV0pKf1aR8m2/FCuICY9vtWSSGzWR31hJAjcacJBdblKIGL?=
 =?us-ascii?Q?Yvh1c1aXwRB0UjbIW/eysIWpZXzahfhqqkI0/sNDORUSa7Bf/ZltyR0K02hH?=
 =?us-ascii?Q?FKvfk6pDmApt3jLFPxB9mlvtUth7ofNykoAA4ZMrVx9Anz7Y4yKIYckmJv4T?=
 =?us-ascii?Q?geAKtoItvWadimsuF6Szd3xIQsVnON8lAbW7cydUD5PMdi6Xd22Z9g6fjFJd?=
 =?us-ascii?Q?FSQxQUlNh7/zasz1GkrSqN8+3NjDX64FLj1+83qEKZF/6HLXMsTuLMjU/1g3?=
 =?us-ascii?Q?aw0dkMYNIjQFQDO/glaGWtd47gRWiDqQB1xyvsJNYaW80uotFy+vxXtShd/2?=
 =?us-ascii?Q?BfXfVYUaEbPyuX40umeXG5dSwljc9rTVYcdxSMJrRyGH/+jRs17WbVyw70oA?=
 =?us-ascii?Q?SSnYSbk7Z3ByeiJouAitz+2w12bhqE4ZSXYz9B/ajInC0q6qIWPHqzl+TK/S?=
 =?us-ascii?Q?tsu7hgsC505rqxKWIJUb7Bq+HZjHNHvWDymHd/bKW11octI5XJxYNUNelZED?=
 =?us-ascii?Q?upJpdFhQlqyA1lBG8lh/j00JTf9z8WgJvLHJAern8qTVxunhNRGiHLvmEKy8?=
 =?us-ascii?Q?hxukGUaAn4Rv4wR/k0X6q2UDxowwM3LVFYbSsDP0eNbYXfobqe6FahWqhswP?=
 =?us-ascii?Q?faiWfr2QoRZATtxNOCFbeg/rgkGoKCUSYJKy7pScI9Yab0DDMaTPRjMOaeP+?=
 =?us-ascii?Q?vFAPkTMVXG/dh/mOxfMCunh/KRq1lyYOkviGQ8REx3YeY9WfbbfE6uJYbiIt?=
 =?us-ascii?Q?XOEjSDUnV3rkXsr957g=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 641816f6-ed82-4851-3ad4-08dca1d90ee6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2024 18:41:21.0767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LWiWyWHHrPfOJ4h5E9sAWkDiILnBqAKVRPZEGT9MJk21AYYF5kfzNvhyeEnaeq7B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7981

On Wed, Jul 10, 2024 at 08:24:16AM +0000, Tian, Kevin wrote:
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Friday, June 28, 2024 4:56 PM
> > 
> > This splits the preparation works of the iommu and the Intel iommu driver
> > out from the iommufd pasid attach/replace series. [1]
> > 
> > To support domain replacement, the definition of the set_dev_pasid op
> > needs to be enhanced. Meanwhile, the existing set_dev_pasid callbacks
> > should be extended as well to suit the new definition.
> > 
> > pasid attach/replace is mandatory on Intel VT-d given the PASID table
> > locates in the physical address space hence must be managed by the kernel,
> > both for supporting vSVA and coming SIOV. But it's optional on ARM/AMD
> > which allow configuring the PASID/CD table either in host physical address
> > space or nested on top of an GPA address space. This series only extends
> > the Intel iommu driver as the minimal requirement.
> 
> Looks above is only within VFIO/IOMMUFD context (copied from the old
> series). But this series is all in IOMMU and pasid attach is certainly not
> optional for SVA on all platforms. this needs to be revised.

I feel like we should explicitly block replace on AMD by checking if
old_domain is !NULL and failing.

Then the description is sort of like

Replace is useful for iommufd/VFIO to provide perfect HW emulation in
case the VM is expecting to be able to change a PASID on the fly. As
AMD will only support PASID in VM's using nested translation where we
don't use the set_dev_pasid API leave it disabled for now.

Jason

