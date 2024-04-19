Return-Path: <kvm+bounces-15283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A18308AAF6D
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 15:34:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4205D1F23D01
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 13:34:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A3B3129E6B;
	Fri, 19 Apr 2024 13:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HRdw3bsn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2070.outbound.protection.outlook.com [40.107.95.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB62128366
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 13:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713533668; cv=fail; b=W3qRkhvhqKk9YRk0uHspE5HyHRVMqgfWbPb/BUbVHQYUWR8C2qzR5X5/HS0q6T5V+i36HJ6F1e9VkqfN8ILU2WNNwYZ7n4dMTvp/DNBrULYGV8imjP8FUp4iwe85F35S5C6IDHtPH11C5QLHwu6ESUs5Xkq3N+iwbwmYEyO1/Yk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713533668; c=relaxed/simple;
	bh=qgyW/v19Pv2CQnJ05T6AiUE5KdJbS7uiIo3Bf01ySp8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aIrDjcPjCNJg9j4qsF80JRVbF1LFfd/kOmo6ZyG8v6Vi6wGn09xj1isqTMzhXLketUMIQT5KWiug1u8nbnEt7lSY+CMSM/7lgDXd1qP4Dz4/dgjaY5BbCloJ2q1o0emDvazlTpnzLbWilvcKqEi2S9ecJ3Q5PPHmCA70m079N6U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HRdw3bsn; arc=fail smtp.client-ip=40.107.95.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FDDLLNd7tbcbyVCSDnI6bmPNNd3p7I+FRvmDSctbJVxzLquhRYK2SBvT568wqp883QvZGyIUJod0pQgWFnHJwtqZ+28CpUTMqZXTSRTAirB/5Ta5iIqKMiiYWjfKzunqwvZtcSmE8rerWXPDuXXQ8GLhRb+bpgzlz+mThmqN5Mb0f+Fu/c74FsZu1G/IqrdFRjSmHoi4ix6CCac3+ObF5aQ5Xm5/0vPSaUXMIkIFQPI3N727toEtPUkTI6XdF23TssXPrAodg42zvltj+mYp7op5euKJ7yUoUyMOX8IJJPJQYvRmumZ4C9tb4cg+pQgRuitsQYlNyh2MajTrv+JOfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pUpJspw1hxvmfjxoKTjbl3S/uNuijPL/uDzK+Vyt1ho=;
 b=oK1x5ytcwsDhci/KhGX4+qqGpLHbrUtLsRq8/Q+nY0kjTAeRd3hTHrxBXtZMJoS13WGi56XenwSG1V9usG0nomBOuHIvigrsEPGcE2wjFW/BZrCI/6rxa+eQ9Sbz/gYW+kcADrvDtVED3sy3eeA4up5LmiC+bKbLH7ZqrxrAB2pCXJAKO9xkB4fsYTUPKsxl2RySUa3bTb5WdSQNW8IhGuGM82Sw8y92z/e20jif1l6X75dffEBfmob1DSxn3KBxJoVUHswBRI3AlgNzYp0VHByHr03I2fEl+4DBpJgOBQzl8Kn7kBNTDDE3565ZKEwZsK08T0s4YSbhXJkE02avAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pUpJspw1hxvmfjxoKTjbl3S/uNuijPL/uDzK+Vyt1ho=;
 b=HRdw3bsnn+0pQZgzwfvdVHqFMqkZ+fBr7Szdo0r+A1mWN1w8Bt1ZJQ6KmhJjpZxoCkdClqSDK+E+lpXksrhVJ0JBj9lfee3GhOakkByDCUUoK/2dHix9Z+0ATR7RgBckTKsMbE87+6rDmUyhMhJuwxSxzta4p4QXqoDtjkw+k8ixnZ1PxWXESyvj7wceYXA1knAnZM6gDeNzUSxZEkX+fX7cnATmE9FDK4vIA97tFiqPYWOOfMmNnMViANyJSLD+OABIrlbJSeYfjdFmL7I3QDOwu9x94jpY9oFF6yKivHO6S4dkqHlH5orP7unAo2d4t6n11ZISyxPft2Zmx5AwLg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MW4PR12MB5665.namprd12.prod.outlook.com (2603:10b6:303:187::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.42; Fri, 19 Apr
 2024 13:34:21 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7472.044; Fri, 19 Apr 2024
 13:34:20 +0000
Date: Fri, 19 Apr 2024 10:34:19 -0300
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
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Message-ID: <20240419133419.GD3050601@nvidia.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <BN9PR11MB5276318EF2CD66BEF826F59A8C082@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240416175018.GJ3637727@nvidia.com>
 <BN9PR11MB5276E6975F78AE96F8DEC66D8C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240417122051.GN3637727@nvidia.com>
 <20240417170216.1db4334a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417170216.1db4334a.alex.williamson@redhat.com>
X-ClientProxiedBy: SA1PR04CA0011.namprd04.prod.outlook.com
 (2603:10b6:806:2ce::18) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MW4PR12MB5665:EE_
X-MS-Office365-Filtering-Correlation-Id: 691c6b0d-996d-433b-47e3-08dc60756b3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dkPcHTvVr7hzFHzh7QfFbEtuCF+uUPIWwHsk6XW2CD1qEY/WTZ5+vxKSFJnd?=
 =?us-ascii?Q?CVXH/cK5xDMxd9O+qJlTsKTkb4Dkll+CzztQd4HQMMZd6lcPO8ZOyjvb+Esh?=
 =?us-ascii?Q?lP/NLqM5TbsOxsA0YbdhCtIUNGxnTZ3v+Ph5eCOQD1OtyJQuWfWxmcC6vhoG?=
 =?us-ascii?Q?1nnvx6EJ1X7gZ9+rCmTVQey3NI+CnT19C4UAH+dEsaXNJQXIx+PdedbQ57Lq?=
 =?us-ascii?Q?bEFYGFRyffh2r52PrrT8QQk7Bhs6fSu8pm8JM/oK2xpPjdI7q+QPGFw0uNeR?=
 =?us-ascii?Q?zwcqH6sNvi8DYc+s7FlNQ2FelPauFlmkWkrghG27052oaM1zzZ1Y6v+aGYUG?=
 =?us-ascii?Q?6YG9kxWl/Zhi80bObybE+rcyggzWLJbjBuWeuO4lw20mnD0GWpyuA+UKInec?=
 =?us-ascii?Q?Hfl2aOtw7jWDo7tOL7hinjdl0obPX7W9AcPvvcZzhQQtUvm+p2+FpaDOixi1?=
 =?us-ascii?Q?6ic5poFlrroCUGOiwwWQxz8z56NdXA1EHIsj6F237JcvJkKviuzsIlwqYRaQ?=
 =?us-ascii?Q?PSwHQbruFiICu+wWZzvsguDDPWc/5lTgay9MENgn7kOopQaxi5cGJAh76NsP?=
 =?us-ascii?Q?5E8FRQWk7BankRVjflySz+OTZU4FUczK91XybmHpo53iPAdHAg4tCjnh7YgE?=
 =?us-ascii?Q?AnuwZCq42dvEsWBII3pgrmwBd4PMVStMqmJeXRkctwFV1NlL36tBwBIb3EJt?=
 =?us-ascii?Q?FtdKgrUjJ+W1+AQHcp20ROL/ymEc4ukNp7nMm3axCXC9+bvXnF5Xz0Nxwvcc?=
 =?us-ascii?Q?IHdSepjypSgZhHEcWgbMv8uD95P5M0h+T4wBPCrrhnYjukVVKRvafUg/CGC2?=
 =?us-ascii?Q?iRCTmybohCnMFyAaN5IeF9TZ7ab6TofgGN4tc6S5mJYJ/UITMoR7+II26bne?=
 =?us-ascii?Q?ghFO3h4G+yNDmOLOn1M2yHWYv8LWA/CaNZ/F/5U2duBY3n2L1TVVyDo/eWoJ?=
 =?us-ascii?Q?C/DllP6SEL6MZS5eGQrqIKA/tnJKQD/wS1wF7Ws72Xdo/+aoatyxUa6AD2Rv?=
 =?us-ascii?Q?ZyVkCmcaBoteWZ1xxMajhxfyPcnvj3fZigNx4iozGtPPAapSRWCRHyn2CEV1?=
 =?us-ascii?Q?TbT7CgLYocYs09wunXelDxefS7nmn3XOEy/IDwK8105kSfAnWNd9vq0m1kjd?=
 =?us-ascii?Q?aJuTJc07AnjrFXOpLeW0vb4e6Pz/QCw0m4JlaExEUz1IDga+uCUth7Pc85j9?=
 =?us-ascii?Q?gmbS+VbpgXVU1JgNsNrqt2oic0C+l5BKvtE6kIPpTMH1xHpLKM/ZoXjpKeTA?=
 =?us-ascii?Q?R2SWP1SV7DDGUES0afyLFFSO6EPOVA8Quf8S65iNVQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/WxaAkErYVKWOAEMlEM1jajEJtqsN9yfEyOXQPELo8Zw71DwQJWyaUwV6olx?=
 =?us-ascii?Q?a9ux3zhAfm4cvjwTDIOnvJwgHFlQLjf7hkhrMacP8Lmc1URdYiRDcydwT0GY?=
 =?us-ascii?Q?Q1jo1/W8g150oUjxk4qTyroHC2qUhqHrYXXAVEDSZ1vpfEtyWzwPRiv0SWn4?=
 =?us-ascii?Q?PSWG+XYVTY4RKYTcXjiZjO3baafnrxm4n80ZV1qaW49V0tg3NFON+0V7DL9P?=
 =?us-ascii?Q?tbVhgdk5f7pUMON8Jq6NizFQay0serubFrbKdDp65D5KP92DT0rVvEi08lKv?=
 =?us-ascii?Q?HFLBj08s3v+wLdi8ySn2N955Ez23qRjlnyKCc6SVmvfRtT1ANuf8uuWfPzuE?=
 =?us-ascii?Q?OZ8RhZPsXVGnU/rr7boEyF/RhrSBE54Rd1h9c/4dZnZcxF91rzUcoF/DUUNV?=
 =?us-ascii?Q?bIKRGBlcHp/XCak6ioWwYSsVZtchaQpsFo6T8SZhfHG99aEdGQFbDHJiLA01?=
 =?us-ascii?Q?c5nz/mnfWDKsWcEO0Nx+K9hwUOrG5DFtui8d7i0032vchrlwKLdZjyYivqXd?=
 =?us-ascii?Q?f+4uY3UiHpVhlC/wR5RVp/cxnwmbAgp+HK7iV9Bh09zvuYSwgyGu6I3o3K1w?=
 =?us-ascii?Q?T9+qYBViT0h9u9P7F469BayfFihpTpLUTzf9Lwt330PjV77LpblnNfZC3fRZ?=
 =?us-ascii?Q?mW1Ui7HZciFO+KXfdPKloqEVQo0MeXQfedrguM13wHBWTrhiKnQIbY24zDxp?=
 =?us-ascii?Q?XZrCeKtHPcyYTnFmgho0DWIH/8eSGBNAtmWB/JH+P4Jqe/oLQEuRSoSNGXiS?=
 =?us-ascii?Q?tKrt97sF7YJluQeWNCrNP67OzXMb7zcCxuJVzgbjVzoFjs9BUd5AmpiqsWyT?=
 =?us-ascii?Q?czf+chSebGk78GetYYqbUCEJyeVO6CgXxbpgdy5U0TpHAnifu/F83wkuxWXA?=
 =?us-ascii?Q?9WJ3fxbuI5PjZQ1x38XZ/8wg33tx/G38grN99ihFpLhxQ0t829Lxzc4WGhIo?=
 =?us-ascii?Q?fCA8A9P9B3fHhXRb+kqhRQl2pqG/nSgCXHkcUZboweKKqMoDZ9BaZkXbxXAe?=
 =?us-ascii?Q?s1zWbZcO4uRldhRR5vzueCwPFuw/a8xWJe8VyWiDT2ve2pgyhZy8XQcHGLhZ?=
 =?us-ascii?Q?rHrgSn0NqXTsT5L0ZqcyMXzsWuir0H8A3/VUhX9xezrO/d1vpR8N0baiFTN7?=
 =?us-ascii?Q?ju3W9Ftlny8vdmoxaCs/jIQHfg0qRPmIMcVj8w0DV8gT26NImfapZnpgXzBc?=
 =?us-ascii?Q?LP7IdM+13G+2W0hiDIOiSMdYyLly/ZMdZpgtrDKySj/HDo7cKuKtpe7sPVy8?=
 =?us-ascii?Q?45I8v6NeivSCiwOFFxTIDImvK9ZV1tHtPddElrh43fAaRaYyxWqOv55F7LrN?=
 =?us-ascii?Q?YsbHVFXqwL1CrMq1lM179HfcLCGClcbyCxqXz4rX48G3AXRutXaV9GOoAFLg?=
 =?us-ascii?Q?zrvPXpmX6VeWBf3j++wsZ2PLbbLuLjDcIuapibMeggXxdBhZDSHz9zKbvrSf?=
 =?us-ascii?Q?VDnmLh1QeYKDjfICuZZGgogec1TK82SG9MEqCCTUwrm1IQHjTaRPFxsHKFcc?=
 =?us-ascii?Q?gzHf2iaS3a0rWtZ+EtZpN9+vS3ZcVwUzYg1Ujcc3TSSR+8xu5oDTEebatb41?=
 =?us-ascii?Q?C6qYZ6A/0/jkaseugMQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 691c6b0d-996d-433b-47e3-08dc60756b3b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 13:34:20.8002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bXHYdSd68KL7XFDhD3n4iBmtVa8h8xhwChSv2OZCvYg1FJR3dWtW8ZmfWk3pDEPf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5665

On Wed, Apr 17, 2024 at 05:02:16PM -0600, Alex Williamson wrote:

> > > sure but we at least need to reach consensus on a minimal required
> > > uapi covering both PF/VF to move forward so the user doesn't need
> > > to touch different contracts for PF vs. VF.  
> > 
> > Do we? The situation where the VMM needs to wholly make a up a PASID
> > capability seems completely new and seperate from just using an
> > existing PASID capability as in the PF case.
> 
> But we don't actually expose the PASID capability on the PF and as
> argued in path 4/ we can't because it would break existing
> userspace.

Are we sure about that argument? Exposing the PF's PASID cap to qemu
shouldn't break qemu at all - it will just pass it over into a vPCI
function?

Ultimately the guest will observe a vPCI device with a PASID cap. This
is not really so different from plugging in a new PCI device with the
PASID cap into an old HW system that doesn't support PASID.

So does a guest break? I'd expect no - the viommu's created by qemu
should not advertise PASID support already. So the guest can't use
PASID - just like an old HW system.

Is there a known concrete thing that breaks there?

> > If it needs to make another system call or otherwise to do that then
> > that seems fine to do incrementally??
> 
> With PASID currently hidden, VF and PF support really seem too similar
> not to handle them both at the same time.  What's missing is a
> mechanism to describe unused config space where userspace can implement
> an emulated PASID capability. 

Yes, sure the unused config space is a great idea. I thought we were
talking about doing the fixup in userspace, but a kernel solution is
good too.

But also if we are set on the dvsec, in kernel or user, then we can
move ahead with the core PASID enablement immediately?

Jason

