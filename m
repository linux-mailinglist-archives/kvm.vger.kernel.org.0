Return-Path: <kvm+bounces-31952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C0DE29CF3C3
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 19:17:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 044F6B3B2A1
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 17:55:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A94761D89E9;
	Fri, 15 Nov 2024 17:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aoYtLkik"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2052.outbound.protection.outlook.com [40.107.223.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331E51D5ADB;
	Fri, 15 Nov 2024 17:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731693331; cv=fail; b=iV8TaJ0LH6ni3VBCWXPMAbOtG/NzBFlreiEpw4epygCFtSoGY6uUSNMWv9HLAsz5A8OL6Kwi+GJSPljz6ARCZRc+K1GNTvdqowGV5uBjnntFeHL03dxYIAV//1KDdlSXZ8+lTbpahWru+zo5RIDUHiARtTqOxumBLUTvF5HZgoM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731693331; c=relaxed/simple;
	bh=b79WYDYD47DuJDVuPLoMc0OMVn+z+z1A70V7s1GaPxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MNR5IcbHdE9e7tzgZJFrw/OzYlJN8ERmkFeTzQsHtN0Seaw1xjJdpCty8QOg/zFhvFHliJkE4cmw7+HNDv3IvxVecDfbFzDsgDb3O5Xd9TUC4LTk7syXPnpteEDiZ8zO4pru/q2RMmQ1TMALXIkH9W0rhVHTK8L84bGqEkwD18M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aoYtLkik; arc=fail smtp.client-ip=40.107.223.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y5Dm2MtCe66WUlbIBkjD3Bz1oH/qau96g0xVKEOaqINLmY8p2MsxG7YNE8af+T3GgtoGe40mMu8vvm7b1BPqY/KIP3oBknvOglaNqYuOp3FRmnKEtWRjZgjZSvaDSUdyrvfU8a8dZU0Wy7ZA9nva/YM9+JWEF6APxnljD1uUGlVG5MhunSfxjaTG7rLd551a0OeF1ZurAKXdkMMNyKbHWPiVFpOClqDXYNvTLK2MRBmvEOOrlzeY+RKLjSKOCJcIRkyrqRS3LhJbCgPFtghy4VUz9/sKuSSoJv5DEJn8s0mxy3q+ULPj9uij3ofKJFC6g7YjRvKRR0hxMsV33lkWVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lE8VoHLIWRB4ibsLC9j/Wnt/YktLXTPLTZmciV+yDMI=;
 b=q0/AtyZJ+k3bwxKqYfycuh7xhdFKat4LzoJkyZMKd0xA+CJOJBzf6OTNiCYIkdIV+y8P4mB4RKTetsBM2u3EcB5TzL161GFCImuw63pAD61uN++A0FblyoEB15lmJVmVBwwRXawaaSdZCuvr10klBgshTNIC32g7JaoPaLlUbglZn632jOSne7Mxpub8ikI9DwiwTJFjZpG3Ioxi34wIYr7r8jztm4mtqz5LgyL/edlZH+jysGk82eycCsjz/hHS6poUwHFGBM8aOGQdHx/wxP5e4xkRrJxqRr00OPU44tc+uTmWO0MOOwt3YPCMV1o+MrcQQSCNqOINjH9shzUFJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lE8VoHLIWRB4ibsLC9j/Wnt/YktLXTPLTZmciV+yDMI=;
 b=aoYtLkikxOluR61jq+mjAvXzLaj5VhaUTjiW8CL3dJXJfDvwawfpNySaeUq5abSH7E6EB5Gn48A7nPF0tJZxnKuBLsPUMlvDPSwlVNS4/GH46w+hw3A9aIgOgs9Pt4VQn2F4qThFrMbSHKx9+iCSTp6okH66GmNGQOHvvWzV7FS4ie+03QxTSZjCvnAKcDN3wiM7FYPGoIPkAW0mFDfZNiH0h1GqMj8zviNHpq2BJsZtYtx+qEvrmKEHT4cS1H/6qk9jQ8jun11ivZA67qhKvzOw0/pvnHQThsuV7vY/d2oDxMDmZ1+UoauIkrDKkNqRGIdxyiFXx0iYBjXaEH0adw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB8663.namprd12.prod.outlook.com (2603:10b6:303:240::9)
 by CYYPR12MB8752.namprd12.prod.outlook.com (2603:10b6:930:b9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Fri, 15 Nov
 2024 17:55:23 +0000
Received: from MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f]) by MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f%6]) with mapi id 15.20.8158.019; Fri, 15 Nov 2024
 17:55:23 +0000
Date: Fri, 15 Nov 2024 13:55:22 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Zhangfei Gao <zhangfei.gao@linaro.org>, acpica-devel@lists.linux.dev,
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
	Donald Dutile <ddutile@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
Message-ID: <20241115175522.GA35230@nvidia.com>
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <20241112182938.GA172989@nvidia.com>
 <CABQgh9HOHzeRF7JfrXrRAcGB53o29HkW9rnVTf4JefeVWDvzyQ@mail.gmail.com>
 <20241113012359.GB35230@nvidia.com>
 <9df3dd17-375a-4327-b2a8-e9f7690d81b1@linux.intel.com>
 <20241113164316.GL35230@nvidia.com>
 <6ed97a10-853f-429e-8506-94b218050ad3@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ed97a10-853f-429e-8506-94b218050ad3@linux.intel.com>
X-ClientProxiedBy: BN9PR03CA0335.namprd03.prod.outlook.com
 (2603:10b6:408:f6::10) To MW6PR12MB8663.namprd12.prod.outlook.com
 (2603:10b6:303:240::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB8663:EE_|CYYPR12MB8752:EE_
X-MS-Office365-Filtering-Correlation-Id: 960e9745-0ad5-4ba7-f22c-08dd059eadbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mbxJjowsLnZ8zHTgcI7P2yvZzlRzGcs396HiH68FJ5z+6YRTfBbU/WxY0j1U?=
 =?us-ascii?Q?ee0hy3QrIUdwA/EVq11ELyhK86VrwbU3X9LApYsNzJVo2V8lNgSUxpr3/sBG?=
 =?us-ascii?Q?H9GfjcOVTlDBdgAAqYqUdgPHXf53/76+0Cvhl0u9ocNVRfYoQX5VMVY4feiw?=
 =?us-ascii?Q?5jlj4ERPcArOZoRiWi0KM9QzBwJUaZlkfz8cN/U+nKqlTAUnMEa9S2LrFJGT?=
 =?us-ascii?Q?75GmD/QTYEX0CXJL9OD7oZpeXcUhjxcxpCZc7VJE4B5WCnSSW+LAZ8GVLw+x?=
 =?us-ascii?Q?KHB/c/3OrMOioW4ZKgccXd8BHxobQJCZFXkYUeAYS8Z7cZEylwMoG1isigy9?=
 =?us-ascii?Q?IpRVM/RYlQGnT0+Ul0qem8us0oKXBDf+JXx22hiUSUzCp3map99DOB5eqAaY?=
 =?us-ascii?Q?zudXKqGCIBUqGum4Vo4W2rqzLVJvq5jN+Cm0BU51wjmxUUMMg+RId/lHWTKw?=
 =?us-ascii?Q?aU2+SLt9rBCHfzV0j3a3eRcsmymC7rIOd9u/kLHglZ9aOs5M6pJcPau6zBd2?=
 =?us-ascii?Q?mLD9hcZthZo/1huz+2BDBQqVJpkjKBABl4twEIXDW5nq5oUA3cMnDBkgel0E?=
 =?us-ascii?Q?pq/VNvmNCFMA996JLjnrNsQ89f+WeF3VmhEjkxmnqOawxXrdnygICBC/ooPa?=
 =?us-ascii?Q?+9DdxmhqfTiMfPo4++FoSt3LsZ5ss8Fa6OxDyRHZXFDaZav6rVLB5n3lHHDd?=
 =?us-ascii?Q?fX/afm47kZs5j/4NXbKqtuHRaCjlkw80QDGUweF8Xd1wK2zH03ie10VgKPZ2?=
 =?us-ascii?Q?xxlByjU9+87DA0cZe09xFgonJmLKNcBiuhVk1U0xElRBTX+CgTmgkWtUkXm8?=
 =?us-ascii?Q?zs7ATww0DgvvUjJ7JSMBeZw2nwKXkB0iNvr32gANbTLXMo+dr6PVMGjOPjvd?=
 =?us-ascii?Q?mDmKc0INi5japg1BJvsHaGhJxPFVXibAGq9uA7i99/8PN8iyaAEerbUAesje?=
 =?us-ascii?Q?repeuuatnoTrbhCU/mJEYfybWFe6u8zMBDxKUa2ATIYPqKdNpbZIEyAQUbIs?=
 =?us-ascii?Q?sRZ3C6kMQj/3bkEVztqHLlgBbhDOsYxx3x+zjpGnv6w7j45TpnzjueDM8o2n?=
 =?us-ascii?Q?Vl5xyp/N58UEjipOfKzpbbDZBJ+Fl1T+B+4M4xVhZdZPG6JuRmi+x/l32IMy?=
 =?us-ascii?Q?1GZ4Vd+sFaNhy44W0FbBmGSt7X3dDQOn1it3kl2UMrKX1HypdT+AP199EGlq?=
 =?us-ascii?Q?H3teLyZEVLj/KjSfQ3o0Ee1B5rsPki/ZwOhSzd6y89N+/oCYzzFMZchnTLgq?=
 =?us-ascii?Q?s1FIDwoYp2P4IK93KSQrEoRAe+OENvLLGnxSj+j7R9NmqGrMBA2UozHzyux3?=
 =?us-ascii?Q?EHb9AnhO/xS8yijMhPnotwva?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB8663.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?V7tKoSvmOgXEOdU9Cl2dG2FnQmINMsJsmau2Th0VknkMoeI0JmwRR9Xkl8gk?=
 =?us-ascii?Q?sKb8hi5SqJtQc7Eld6xIFrE4+eeOfMiRMPRqPmcJBVDFWs5Qf7rnflts2G7H?=
 =?us-ascii?Q?Fc7RlCN9TtDzSFV9laaBFrPs1JoAe1LEl5PMxViPuC5wRE+B3rxvknPZTesn?=
 =?us-ascii?Q?EsmBpA5lFoldMd3tO+0upiYSPiXRo9K3kGtFAH/6rxIz7uQRzX2x+km0AK7u?=
 =?us-ascii?Q?/CCobAfRzslWrS8WbljNeSTbjHA+8YKYTtvSoi3JrrC+cMZqBUwSfXdSUWGc?=
 =?us-ascii?Q?XNfprZXKQS9OoIHw43Z95A4Ym0ng0Wi+7/FtmG88QVm3jbqVBqcrJuYDQUA4?=
 =?us-ascii?Q?FcE8P0tiJch/Bagn9HMTYw660h4gTAXu+qAjaUgon13jNAJ+IsWx8MCkpuDI?=
 =?us-ascii?Q?53ktvkI4M81hQ0A5xl8eS8xBS4FjYAo5ZO1YmwWWYLXGGFcm9+i1tVVU2LjB?=
 =?us-ascii?Q?oVS8dV5fxuU+1jrIqcyRSDVDoLe6HExqrrRzLPZiH1W1zHulP+BB37qOsyj9?=
 =?us-ascii?Q?kTXuzAUVAijxZJHJGJu6ITB0GDglh6oHGZiz5cIDOE/QvpJXWdpvT44EWZoi?=
 =?us-ascii?Q?MB1OEa0C6QAodmkZ0y8UU64ruEPdtVmgw4F8Ygr/5lOEg42/0/byd/QaSGPe?=
 =?us-ascii?Q?PNphNi3Oozrj77sjEypedwQE32mkgZaOVTjx297OqZiwLZEq79RXFuUfHj4M?=
 =?us-ascii?Q?Sv7pEtDVfkzjwxvI2WVfKQ4atXFmYYOESTw+3a0iq0K42BdECZj6F88wy+Ey?=
 =?us-ascii?Q?vcxnUPCH6SFm+eSvLA5hir811AcW92G7If026UYW9B/zHaUeYox/zPPuDEgD?=
 =?us-ascii?Q?UFYW4sVj9afJpx8+xdx3vmZ6WogfWKQey7VbcfNO9kqj8mMzauVH14lzBsCX?=
 =?us-ascii?Q?Z5/wCpWR9MSJZioRy1tCZ0ThsBBelThFS3ZcCKiMOd2FdqmhYH0stnAgQySQ?=
 =?us-ascii?Q?UnsXVdj3uJOg4Qfkk7ZAbaptpfzqUH/ThanD3RtzmMogUdmseQZfdK43OJpT?=
 =?us-ascii?Q?qBLm3R9wAoxQNXyekt8iigmyutJ09ErD7NRM6xROn2MB1/bg9YuUzSW7V7ZB?=
 =?us-ascii?Q?ZhnIvUr9ZKh8k5ZPjZiaka9XC4FZreM36WD4Pb4TqZ5heO8FkafaItbTi5II?=
 =?us-ascii?Q?Fm7TzEhkqY1bflEEt5h/Omvl9oBGf7FmTEtmeL6kccGFT/F/K9EfUdWUn5Gp?=
 =?us-ascii?Q?Y6iuEi2hAByzyNCMrlDx1ceqK4pFEsje/ojMk209N7Sq5nttOpxa+P4OjA8E?=
 =?us-ascii?Q?9826PjSTEi2H4evaR5iF6/9CkzFnsTlKedZQU0ONvej/fGQSqGkeXEyXoSfX?=
 =?us-ascii?Q?YCmBmoYUwdC+vK12w7mvjnYYJh0NbNZxFBHbngmRhCCG7YtDGCJgXSNmyrl4?=
 =?us-ascii?Q?QbTwPKv3S31STBalpTdtP6n14oE1JhymKs7cUlsfX+fxJ/Ak+Z3fSn6ZAgDq?=
 =?us-ascii?Q?oVyy90JT8FtALcvPU0bxTEoIw4IBrClTF5pFodNPPNVyZ7bYQ3G9HAfZbVzh?=
 =?us-ascii?Q?7ZeMCi3GkogcZrFXOgm6dSdV+0HD/xT7T/4ZfPn3TKalayWM92MkQFAM/ItN?=
 =?us-ascii?Q?aVMEm0ETRu16FNMMmL8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 960e9745-0ad5-4ba7-f22c-08dd059eadbb
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB8663.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 17:55:23.6182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ADDYgfLVKWdM12Z/bDc9HTHPH7LNOShfVZI4K2HdWxb3zc6+drPW60AholDfnfHq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8752

On Thu, Nov 14, 2024 at 08:51:47AM +0800, Baolu Lu wrote:
> On 11/14/24 00:43, Jason Gunthorpe wrote:
> > On Wed, Nov 13, 2024 at 10:55:41AM +0800, Baolu Lu wrote:
> > > On 11/13/24 09:23, Jason Gunthorpe wrote:
> > > > > https://github.com/Linaro/linux-kernel-uadk/tree/6.12-wip
> > > > > https://github.com/Linaro/qemu/tree/6.12-wip
> > > > > 
> > > > > Still need this hack
> > > > > https://github.com/Linaro/linux-kernel-uadk/commit/
> > > > > eaa194d954112cad4da7852e29343e546baf8683
> > > > > 
> > > > > One is adding iommu_dev_enable/disable_feature IOMMU_DEV_FEAT_SVA,
> > > > > which you have patchset before.
> > > > Yes, I have a more complete version of that here someplace. Need some
> > > > help on vt-d but hope to get that done next cycle.
> > > 
> > > Can you please elaborate this a bit more? Are you talking about below
> > > change
> > 
> > I need your help to remove IOMMU_DEV_FEAT_IOPF from the intel
> > driver. I have a patch series that eliminates it from all the other
> > drivers, and I wrote a patch to remove FEAT_SVA from intel..
> 
> Yes, sure. Let's make this happen in the next cycle.
>
> FEAT_IOPF could be removed. IOPF manipulation can be handled in the
> domain attachment path. A per-device refcount can be implemented. This
> count increments with each iopf-capable domain attachment and decrements
> with each detachment. PCI PRI is enabled for the first iopf-capable
> domain and disabled when the last one is removed. Probably we can also
> solve the PF/VF sharing PRI issue.

Here is what I have so far, if you send me a patch for vt-d to move
FEAT_IOPF into attach as you describe above (see what I did to arm for
example), then I can send it next cycle

https://github.com/jgunthorpe/linux/commits/iommu_no_feat/

Thanks,
Jason

