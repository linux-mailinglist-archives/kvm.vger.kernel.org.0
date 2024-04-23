Return-Path: <kvm+bounces-15647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4ED28AE672
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 14:41:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 28093B2178D
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 12:41:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D22786621;
	Tue, 23 Apr 2024 12:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aMowKL8Y"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B90038DD8
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 12:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713875999; cv=fail; b=HuvZcFkAnjdOmMHSbzPD9J2mQWvO9yoCYPnN4b5gsP+Cx1hdXtaApQ7UDgVghNwZ4EjGwBYIOq1q0oztrOqrj66muyuJVRp+AubMDtGR553V4Vf/LSKAvHwlGglHCjoO9H6NrOarPXP1915sWH3LDKISQqRySR11NEhz/WTN0dE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713875999; c=relaxed/simple;
	bh=Eui3IqwyGDa+k5SYi6Bodg4S4FQ4NjxOxrJgasONMiQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DcJprl4uCU5QSyNuEIHQ7Y/GuzWpqVoF8wSC5RVNTMXerVmfRymDK7Dq+NCunxHAewlEUSlQxREj0AWHfIkbVL+l3QDx70mS48hqHSDi3LC0fTEiNQiyguq7jEycC6S8VaksAAvag0yF+6Mi9w8PPay61um6o3jPnS2dsSnGKGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aMowKL8Y; arc=fail smtp.client-ip=40.107.244.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DM9gAnVOG4R3d2CxI1ufiz0m2HiQ5CoMl2Sc3UHmZFhiu/nB6FIrKnK/MK444GqE/X8zqsxbCCeWor1raLMDc7lcgAFARm4us65o5wEfwFwWvvgMjKJ09+5ELzUrJyjj9u068yxgwhQ7tIEv3dHWZDbSRIVnTa0XieMdvBYCoXpWqnIXheiFdInUHaBOKwGsmjKZxi+s35O8VbhlOHpG8Vpm+3Cty1fqvHA3F8PXnfrXWmDbj8GZ+C9QIFtBx8QWMrmQPgtSryOCybVEGSnnR3/UISTzOF4Xaq0EePs6GTVoMZc5KO+7pClPzLzhzEKtNNosUaEMV1u85I4+tO7//g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eui3IqwyGDa+k5SYi6Bodg4S4FQ4NjxOxrJgasONMiQ=;
 b=VkN+1Sn3Gy17e8Wa3oZ1Ssg0Wo+TeRsNe+s1dtuUbI3dLqHgHdR6J+1dvI+I0p4EvtYJWv4sItCKgrgn8Pk0hfdBl2ZNt7xy6vQwfilOKSsa8DQCP0207KKp/b+Ygqqevvq0ACJKJGjHHuuU+a0k79KbBTT6sImjVx+XmBBr2ucnUybagyTxiBDfMNvK0d46EPhrfDnzcphVWctlgjuRe80lD9P+cQmE4UPtHiRl7zScSwAASHFVC6XqhBsxr1Ry2O3m008fvLhY10JFcKJaLSJsW6WiISd0KE730E0hbWc74DW1p67Pu3GHzYEVxDzqt+lsgHzzMRcn1yLzKmFbxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eui3IqwyGDa+k5SYi6Bodg4S4FQ4NjxOxrJgasONMiQ=;
 b=aMowKL8YqUwToJDph3MPa7njLCjJTHlicf3WYCkCPbS0tMX2AFTf01T1/HnkR8x1jKwoKlFNqUFfX7RkLw2w/RuoKxKrsAKrev4urhZjerGr2DLqGXZw03ZDE+EidmfBJKsTSNjtYmloQIyhWC59vcFsQO69JKuwKn0Uddyz2b5eWnTWeX7EKE+8tGPhNfZrwMx3taC5jGzmrriFMyohG37W45x7uPSKH/ZLHhH+2JI4ZaFSa/FrYVcqWIunVMPR8/l4PNqzVoaRPgl2y1qMvrumKNaVkTz2S4Eiu8hMTpwW4wKl1t/qQLmaWu6yqEZgFLpPwK3GE0eylWQD6dYc/A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by LV3PR12MB9440.namprd12.prod.outlook.com (2603:10b6:408:215::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Tue, 23 Apr
 2024 12:39:55 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.021; Tue, 23 Apr 2024
 12:39:54 +0000
Date: Tue, 23 Apr 2024 09:39:53 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
	robin.murphy@arm.com, eric.auger@redhat.com, nicolinc@nvidia.com,
	kvm@vger.kernel.org, chao.p.peng@linux.intel.com,
	iommu@lists.linux.dev, baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com, jacob.jun.pan@intel.com
Subject: Re: [PATCH v2 4/4] vfio: Report PASID capability via
 VFIO_DEVICE_FEATURE ioctl
Message-ID: <20240423123953.GA772409@nvidia.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <20240412082121.33382-5-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412082121.33382-5-yi.l.liu@intel.com>
X-ClientProxiedBy: BL1PR13CA0083.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::28) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|LV3PR12MB9440:EE_
X-MS-Office365-Filtering-Correlation-Id: 14755825-f0b2-44e8-001e-08dc63927a30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Mwqdf/ghrynccQZQz+tZmB/BhMeSY7rvPfD4NQVIfoBgzJ+O5LMh9QRtFVEu?=
 =?us-ascii?Q?Ietom3TKsUNNZffPSuc5qhOW/EUvltfQ43XU4Kjix6STWo86KOoi3ozdRY2P?=
 =?us-ascii?Q?969Z37xwfiqzamfnvdGwbguP+itPknbBhO5PpAY4dGB32acLeme86QgzlF/z?=
 =?us-ascii?Q?8o9fTIEtaYrIi55lCgOygCRveXFPrg/RuVT/EFSxtbvANp/jcnfTzL4H9I7c?=
 =?us-ascii?Q?EE7ZG58XhgvMNA0OXQPld6ZypHARzN/TMcHTLtqy2dmzAwQ3I1avLfO7EVj+?=
 =?us-ascii?Q?ecvT8MGy24KT8sltOq27MG5BOTzook9LslxSVgT0wxZtExsMve1bVHkh9iP9?=
 =?us-ascii?Q?v56a9NhS4RfcuqEpqmnB8HjgIT4mI5lbSDG49eI/dKzzdT6gaXR7EfgrkyXe?=
 =?us-ascii?Q?cp/qryZ/LtnA9fzMvXLdzwq70FXLFjQN42vCb/j7Oy6P2NJ9loJ46xyhkCak?=
 =?us-ascii?Q?kCGbBPr7SelmrPSNMCKn3cvn5+mOtUxlbjBM/eiT59wdI96waOhf0Cgh1rQN?=
 =?us-ascii?Q?UWnDiGlkj24leQQkWlE2qpHnx1hlSh4I0lhf+bE/Qfz44lH6fVM2757hvEKb?=
 =?us-ascii?Q?IIVxujrdrasbXUc8FpT5w4V6VfrnGHggv+XEcIKqdBUPQlbHihyhInhEEDiF?=
 =?us-ascii?Q?z+kHjFAU6+NS+NIgv9M2EuzonCz/dhkEh/RkWLEXXhfNXt+wLWwhNLvR8orc?=
 =?us-ascii?Q?WERpHCnJ0To3vM+VDCGU0R1W0Fk8OuOS2a1s16raxJ4m1inI0cqxe2XBEihO?=
 =?us-ascii?Q?e4Ga7CBUiev5hgLqTRLKzgQRHZO7W0qXDo4etEAb1cwRXxBqaOT+Xh0QCPvS?=
 =?us-ascii?Q?mPO+9ye/byXiYyuGfH1Jq2PCO9tg9eJSMP8QWUaKs+VNEifr2e+wXeSkaoCi?=
 =?us-ascii?Q?uJPlpm0DADtwNcCQVlRWJUDtdkLB7iHE7FJ+DA4ANlCiiPJRuR6TL3P5R5km?=
 =?us-ascii?Q?QIfyrhX7mwEnjKfVTd+o9wRgpTVa2JcyBfdyZfX7jqmeBupiugRalozrRl0P?=
 =?us-ascii?Q?FvZ33XA0n89/giMbZac+R8CR9UbV5aTzdMzwV4a2pLjdLKuPSrICcVaWjZ22?=
 =?us-ascii?Q?fvXkx+fGIozI2rag5AxI2K7nFL97Svwz0yrijrr4/F7GLa9rdrEkvSL0JXNS?=
 =?us-ascii?Q?cz/cx4E2lSvF4sTMc/Te/UtQ2/+Spig+t1T9deC9ffm1XUU+j9O3ZGKE3aMS?=
 =?us-ascii?Q?RsmqW2v/PLCwwa3g0wrbXbWlpLCj3LH2h7FFDrZIe+gfILi1Ywau4+KDYCSF?=
 =?us-ascii?Q?h0h5HA+b7SVJVeO19JwICDqDTObU+Yr6mSK4pDJ0zg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ztl9igCGj+ux6AQDcZCNc/ThQHE/259Qd/vc0iM9CbEC2CIUdHsY31zhBNKt?=
 =?us-ascii?Q?3T19hv34uSa5ylhgfszALpBYkWB2wPI8BC4elPJmEJdxn6Uy4KVSf5dU8Cm5?=
 =?us-ascii?Q?fXi5GHwVJLen2lrtFGrJmCzKSPGhNRijnvFZTvM+Q5y1vZcpogf0SGDr95dL?=
 =?us-ascii?Q?x0TuyUKNfTGLZP5DqAJQm3GkARdNcOLEn0uR0sZ8AYz+Bi00wAZfWUUsgJgN?=
 =?us-ascii?Q?Og4oK+UZ9hRNTJ+e1i8pC3tHSgfXUSg2hhXLJeTrqMF4HpYkLDDRuXCUyD/R?=
 =?us-ascii?Q?My5YsSTjGxatf8fluyHZSCtb1DVdnaegeQOXvaE9xwU6e1/6A7Ge2Ru1RZxC?=
 =?us-ascii?Q?Oplupt1qeXPEKCrKHL36T+WNQNqChBrIWvq1pQkIFhMRKnrRXu7kLbhVJVkK?=
 =?us-ascii?Q?WHuUdz5buObi1T5v2i6dieRIzwgSYMNPgzV0rNfGkwSp8prgMZJl30NMomPq?=
 =?us-ascii?Q?KNouz4Aty2Sn0N/hxY+3sotzeef+6am8lpK4hElDmtfRabOZgElIYZChNePB?=
 =?us-ascii?Q?LSRTjWRjdJeS1xoW1NUoGaUuZIbom4zND54UCpilgvWL0LKSlno+oHclpBLR?=
 =?us-ascii?Q?e6oPsHqX8Q2YGY9yOUwtmG2+/gQlbCL9uSZYBX/r9A8j7MQ0Rt1W8qedKOCy?=
 =?us-ascii?Q?VvqNvRH11X0Rs8PuL1JgFOiL8+4MvfWoy1WZHs8WL86KH1pNZeghSykJSj66?=
 =?us-ascii?Q?TDjsFVhU7TwUWTfbZx705wXsenvZfs51PIHp5Xp5m+Ae3wJpKWPJo8mr15JD?=
 =?us-ascii?Q?T/ngFOVnEnzfxDgCHXaVEOxp7HpeFwpEaUW0vUVc5b3G9WpT/oGBBoqSouTY?=
 =?us-ascii?Q?B1txMTnVOJTOAanK1gEJkKM7IDlx50/YsIHHy0BJW7cPivwRgb0mc5vAYF2w?=
 =?us-ascii?Q?nvk3qSMLtCZJA6tXYGRW8jToupV7nYQh92PLKP13FHCIFtTLJt/vRXXfvPpx?=
 =?us-ascii?Q?lzpQMdB0Jwopxx2Ke+4iwLa3h8hhArSZz5gAOz9lDw6i5iY1LaJ1/ZT+R30d?=
 =?us-ascii?Q?sFVeCvqDeAaqKh2wqEiTv8nR0rMBu6mfrbjb37MltRUPt8BtVa6RdWnmyz9g?=
 =?us-ascii?Q?N92moBm8/48eZv2yVmTYPzZgG8PqqrVr/pem7IjnDqGuXp/ox+fPkDNjZLaq?=
 =?us-ascii?Q?7Oz6/iMZ2KBFQgFvot/HiGmytPZ26ENg5Wy5ETDLy0RTINxioUJFppGuE3yl?=
 =?us-ascii?Q?GM0WveNqmKr7/C3iSjvAr5dTGfHXcLbMJHu6CRUUwYCfK0v5rzNsQKHYEFWp?=
 =?us-ascii?Q?EyZfcSGKbBia/TK9BV9KJFq44QLHcFnFiQ6IM+rVmfnWOH/GHJ5aJvQh4QRn?=
 =?us-ascii?Q?IyRzPScISQ2Y9MnDtK+BvijgJeYQ699VrlRJe5jhRv9P6C+ZZLirw9vN2M8V?=
 =?us-ascii?Q?4Ygxcy7jx14wxtjTmywuYjJyTefcCofcgwkRwzdq0uY+x2UJp1BwYjxA/O0f?=
 =?us-ascii?Q?6OzjoYL0sMZR82CDqqrL0hcVDmf56LsxXJH7mrx2Kr1BL1KOaFQPHyj5Wmkc?=
 =?us-ascii?Q?uxiLjkddrLxoRRddRtBMgZKMZIK0/zutvjsaWc91j+VYcZPKCFkCo+s4Ej0S?=
 =?us-ascii?Q?jx8C4L4QWx30RnYsf1aYpEr13ZG4bO/iEkFdGGjj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14755825-f0b2-44e8-001e-08dc63927a30
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 12:39:54.7496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7sTWvTPcaGfz86dBfyDBH3XgYN3GUmgPGA6VD1G/0MbwVRioF6SacJNLefy/i4P+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9440

On Fri, Apr 12, 2024 at 01:21:21AM -0700, Yi Liu wrote:
> Today, vfio-pci hides the PASID capability of devices from userspace. Unlike
> other PCI capabilities, PASID capability is going to be reported to user by
> VFIO_DEVICE_FEATURE. Hence userspace could probe PASID capability by it.
> This is a bit different from the other capabilities which are reported to
> userspace when the user reads the device's PCI configuration space. There
> are two reasons for this.

I'm thinking this probably does not belong in VFIO, iommufd should
report what the device, driver and OS is able to do with this
device. PASID support is at least 50% an iommu property too.

This is a seperate issue to forming the config space.

I didn't notice anything about SIOV in this, are we tackling it later?

IIRC we need the vIOMMU to specify a vPASID during attach and somehow
that gets mapped into a pPASID and synchronized with the KVM ENQCMD
translation?

Jason

