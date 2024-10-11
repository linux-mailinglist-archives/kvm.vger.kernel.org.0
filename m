Return-Path: <kvm+bounces-28632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A649C99A594
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 15:59:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C2021F23F20
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 13:59:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF5042194AF;
	Fri, 11 Oct 2024 13:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FZMw6gz+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061.outbound.protection.outlook.com [40.107.243.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849C0213ECC;
	Fri, 11 Oct 2024 13:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728655160; cv=fail; b=EwGNaI6g7Gp53PSIHvJJOcidvMevMMfqYYIuCYBt6s+9QqLCJa0k3kCwpvRG2Tdj2X6DtLXTouc0y//hQpdIXLJOdhK518PGGKp4mk0yPZJ6M2YcouqkErbgX35u9KzVv3eYMMhOF0UNgdmugK34MfjpIvS90TYoZvgnTkV3h0w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728655160; c=relaxed/simple;
	bh=XLGuQoAp/+Q8J5Lcu+Lcwjhojt5+oDYhsF6CkljpXkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LjlFJjVTuNLZmPEtD7X4skdlfhZz27/WFzebKv3r/7Uoyrq067FfZ0b3JOpO/xbA+bJGkoasLfYAfS4jTEVfTK2SbVERAZ3bdL85CiXBjCTJZzfkfqb8g9vtHmEXK1bzbu/TCJM1satQWrgy0vrocRHOJ1fBkZ1gSDQY5zXgsEw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FZMw6gz+; arc=fail smtp.client-ip=40.107.243.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ks+yf398nizPIfGZYThLV/mti/fnW2bEjsKcj6fj3u84jYg9s+fsmVIwGOSf2KhaOxGlts8a4V79lKCYXa6m3fMfV+juFe2KnSXsmB2qSvHPaFiYQV2zQAm4xi+I6Vk4r5jPBPZD7eOJRaj/XtmtvOQt0gUtw7f8p7C0DY0bOWYGI0jt9MXuRZhGLWlwO68h9cjMbf3qTInqyV/V6m0zfQRQJZFkcnhc9+J4kWyJDAE1QE95Qbs1Z33ImaPxIfwfBvzXRCHc3hdOmcSq9msLfr56q3pNgXzgQTWJS2eUqKSCwQoAHENWEjtCYas4z73toGBIFoNsWk9k4a92ZL8i1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MAV3xzQ27ZopzbmeAVFpBX+f96I01VnQugTtkOCAYao=;
 b=CaTeZbFQsXXbo1FkuVSoh/TJzoSjep2qPFGPTNmXwy6q/tCn7WLkMHhWRt+jrR1YwXqSgLsBv2amj2C75V/HP5Skj4DygRnaue0Bj2p8NVXuW3VVK8aw54vn8Cudg1PNuuWsSZ9xSMPvg15yghq/YZ3GnMYfKw0Zd/WXquU/BqdO71nvN54IgZIG1q29Orzpt3NErMRbUPL0XjWQj7jNoC/lZ2CsJR+d7pK1nDXn6b6BPfnYsTD2laAdL6nGGljFrodC1bshBB46FA1vYF8h3UaVfn2wAd67DzMXfZB3Awxs1trV0nTGCA4Q+aK83aFayiOwpUou1qApi6csue1qFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MAV3xzQ27ZopzbmeAVFpBX+f96I01VnQugTtkOCAYao=;
 b=FZMw6gz+i2G152cTe5wia7aBbYOGgRMxcvFtjDFk8/v2gGCVkQNvUr3SWGn27pVYffPbuTmmnxl292bVvD5LSS7+A69m4+cQE0lg5IJAaaf/NjFAhDPN6/IuNgPDVciR5FdyxJr70YASNHyod6PLJq3EFU02w7UkFPyNRor9J3P9PHqV/LQARscpBYoMPO2sB9jmwYQerQz/+ojrdlzOYYHQLC5vSFeaYbzUR6UxV0OOis/7Bwb3Fzmvo4GISG4sGuZfdZg/5w73j921HBXJx1ukQvKbEBMx5+MaP1vmZ3zkMRoghph4BsDF1gpO+RJ82OqLj38X9ZOTTIT4+ypB4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH3PR12MB8994.namprd12.prod.outlook.com (2603:10b6:610:171::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Fri, 11 Oct
 2024 13:59:15 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8048.020; Fri, 11 Oct 2024
 13:59:15 +0000
Date: Fri, 11 Oct 2024 10:59:14 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
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
	Michael Shavit <mshavit@google.com>, patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v3 8/9] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Message-ID: <20241011135914.GA1652089@nvidia.com>
References: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
 <8-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
 <Zwa9DmEduyLjiB2U@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zwa9DmEduyLjiB2U@Asurada-Nvidia>
X-ClientProxiedBy: MN2PR22CA0026.namprd22.prod.outlook.com
 (2603:10b6:208:238::31) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH3PR12MB8994:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e4f2c84-1fc0-4f03-a3e1-08dce9fce459
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DrKO+T293DZK8HPxbEWyxiM1UD4Q1+ou0AwzuvgIr9ivtQMYryqF2i96hkVw?=
 =?us-ascii?Q?JjQvFhKsg+Eed3lxsForw2TSYcjWH9MId4FW3tY64Qlvifrj2wlKHpCrC3wW?=
 =?us-ascii?Q?+TofMNEciWbVd/YgAIQyUfK29URMAE4sVxOv1avqFCPFymxF//bhX+r7/FZR?=
 =?us-ascii?Q?wOvgLNdrqNjhWXVhvtTrSpfe4bQFw+PMUYlLZyulxeIgNAKb+b/fZ2yYHST/?=
 =?us-ascii?Q?YWCl7RYAAT6sOR4WKfbLSP3uIpeU22DktQFVuidOwIhx7FulzbZyGOBZg8+g?=
 =?us-ascii?Q?kunY1WAzAOSZYHcTVu235f2f8f1JKk2YS+REW1ZRmfFPCpTjBrxE6OAlqJjN?=
 =?us-ascii?Q?N8tw4h0wLOcrkG4xcvu8F2a2zkibjXpCc2DUwH4/fPMmPTS9vGAA4e21Cz0Z?=
 =?us-ascii?Q?baub2IBnFebBH9UZvAPYvJ45zGuh1VlH9llueFTiFmTr606I8FX9SVT0Nsmd?=
 =?us-ascii?Q?oMd2Isw4t/Xc0iM+u+X5UIdruIG1vo8d7pH/aG6mPlccpd9bU/7FC42gJ8kw?=
 =?us-ascii?Q?8631ic/H4Q5rZ2kqts8lAJFNuDZ7/QcEI4vVt/Qsfg/gjnPtt1B0DehUDAds?=
 =?us-ascii?Q?mho9fobwjMXQm6tuN/l+1lr+0voCmjeSfdlZ9Ukz9xXkCVX1DDB4sIz1Mvaa?=
 =?us-ascii?Q?COF1AbDTgBUWSRRKapx05FERhwASFxdehRdlmYxk65yR1TiLtGe+gEcAwFMv?=
 =?us-ascii?Q?ALq/vXJ2PLgf86X0yq7BM/9SBg4SbJMQGdrcQ8gQ1F6mhpyNYFlPApUvsl3u?=
 =?us-ascii?Q?ikzdBcs7HC6AcQfO2lx2cveTeZPaXKxQAHzrodT+CSv8u7JYNWSYQl9cC4vD?=
 =?us-ascii?Q?MmfwaFVQT6VcPNyHLVNX6B1Gj8p2BfVfwxKzz5hepKw+NMrPt9rpWy6i0QrZ?=
 =?us-ascii?Q?+EPdw0URtr/gncdJyP9Py2pabFPdAwKrbG3IE0YkmNJ6svqtEyNvZVMh2CDs?=
 =?us-ascii?Q?XHVAV1+T1Mqmb2wC7J5Mggoudp/6EGP7vItEbKAz9VH/v8HfeYbPI2tlJR4N?=
 =?us-ascii?Q?/744ZBmOA/dcKhNqf9zajRDvcandTpUn9uTyD0qOGl5u4Z1CiW3bmihsix0Q?=
 =?us-ascii?Q?f95LFH8nkdNQYzNENIZVOzkDZEZWBAPO3UJhdjc4O9axD4HzecV1EHT0Cj4G?=
 =?us-ascii?Q?55izA1XnF/r/ATyk0yjDoZzeJxopTDgvycbgO68XSGD9iRcV3G+twrYCnSKi?=
 =?us-ascii?Q?C7itGKgLJyeHZ2B4sqDSCYnmtNb5J4tz6Luij18kWrDIDgpmPyQutPrjyMlp?=
 =?us-ascii?Q?Mkh6CNNyHBL81S0MBIFHT9/pYFc8VCRuB+sOwHfAtw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Mpgg/0gD4OPnGxHX0Dn6V3wHXMktdcvH1cVpMgS61Blv2ezOmfiei4jENqIl?=
 =?us-ascii?Q?dnX2h4/hPftrjMbgxviRZL08d977X9FeF/1ei6VViwrOUT3b8D2ZgxMz4IZu?=
 =?us-ascii?Q?J8WhvXl9OGxQwDPltoheX4ZU8i5VPwZAeyVh0hA9zgDvmcPadrQ4L/vDU8ZE?=
 =?us-ascii?Q?kIYIfHd2GBNf30FjA9kZIMfr8M/QB1fq33D501aCi8RahyLB7H02O32nXKpF?=
 =?us-ascii?Q?OLY8b+5JVOQB80I+tnfQeFoHhDD3bb65ON265ogJHfWAlZOHZgfYcfQ7Ta4g?=
 =?us-ascii?Q?gquSvOWmLzPgbdPnu4QTIngRdrYkrnfE8ZYFfk69uEP5vqPxxZXkfPE+HiTe?=
 =?us-ascii?Q?S4gPL0JXildbhQ2cS9QGH3+JG4geL+UVehZ2wf5qoH2wPveQa0EJymJTZxV0?=
 =?us-ascii?Q?igLISKvnWzaZxmFuboF0ibzE8IXKgnsLURf47kRUWi32sMNGHGrYaq61ALnz?=
 =?us-ascii?Q?6fgcLJkt/GsbNTGEz1W7hwfllxC55eo4dhRbW1TsrV8jlg/9QgxOUmYMYvOS?=
 =?us-ascii?Q?wnhA4i6Fe0Kca0WvMnxGf2SZtAusgIr335jz3in13yLK7jnZhAHDcnLU0l8i?=
 =?us-ascii?Q?Ydai3yrwYXAumRBUxB1bD0GekfXCxE6fpmV6Jgv3j82g091aD1DzcSVrrlVR?=
 =?us-ascii?Q?KtDtbPf6Y76LhsJW2JCmnEARm+QHnyj5l0QD98CrMHRtkX0tF/H1rSj0T4+o?=
 =?us-ascii?Q?hFaAW1qk7hOIBsLhf3ScUtKZiRWKI4vD0hr/c0veh3ukcfpwAJ288ACoYTuJ?=
 =?us-ascii?Q?CM00cTSYOimfwzdm2Dy/g3jImbaVlRVwLARQ4Y8KKR4LVDP+TpvlmV96h3F/?=
 =?us-ascii?Q?A33QJeTctqVnRTH2yfzG/ni/flhYCQU84bLFsBF+eGTU2aXZ5fjQkCpufo8N?=
 =?us-ascii?Q?qKFvB68LLl7NEcnUvKOxog0pfN50QK/WHu/F/QfBq9EPhsVnSLaB9gUabVBC?=
 =?us-ascii?Q?s5ISST2dRYqW/401AO0S31B9zwoo4uiGj0m+CQoQKgmXkmLLJt4raP+bYSOk?=
 =?us-ascii?Q?2RNILuduMa5PTkp8nelHrIObl9+jWg4Y82gwpJ5RKS0pFLW+XNqWb0mmebu2?=
 =?us-ascii?Q?zrvS3c91VHafSFqWg3wIErMl0lMcd5CTj9igH0x6bqV5Hy28KdPmgT3gg6h6?=
 =?us-ascii?Q?QZwSfz5e7VE4UDRdZxyTZj8cLOWV0Wi6ADXvUJWksNXF+9GkZ1GsnxRsSbJg?=
 =?us-ascii?Q?5wP/6ZCaXTYE7i8SEYothA3Fv4u/nlHaCbsLCv3OiUt55hKqGJ2LiG3IO+kw?=
 =?us-ascii?Q?c+dwYPl2r0lR/KUX7DlOS6KuT7y537I8Pu/VSXiOpJIwFVGjLfTCujwc73Fx?=
 =?us-ascii?Q?cI+bpEApKiuhd5yR4fWpdnv1G1qFqy1ixCPi21xANe9yS5EzIpA37jWoAatV?=
 =?us-ascii?Q?39DtW5qwCarNyllJJRsbNO3DHd80RD5Sm/cOToRhOX555fV0wBxgNyOgPWDL?=
 =?us-ascii?Q?5F0TyBK5pHanTObr1g+OCyR0i2INJwp+6V2xxybIaJb0USeLtSsw9UQ3Ye4C?=
 =?us-ascii?Q?CJMyoTRT8dJvme+oVWOQ36poUBZ5hk6S8W/EhCEXrj1pZCLLlAsVi+M0LwUL?=
 =?us-ascii?Q?xwZ9XfmLS3suPNt1H9U=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e4f2c84-1fc0-4f03-a3e1-08dce9fce459
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2024 13:59:15.4664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gCkTGBJ+5Yey2LgRhAH6UEPlsYlmSJrWVB/MmhnTr6HKzynm5NfXZKBUXfeplUJf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8994

On Wed, Oct 09, 2024 at 10:27:42AM -0700, Nicolin Chen wrote:
> >  static struct arm_smmu_master_domain *
> >  arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
> > -			    struct arm_smmu_master *master,
> > -			    ioasid_t ssid)
> > +			    struct arm_smmu_master *master, ioasid_t ssid)
> >  {
> >  	struct arm_smmu_master_domain *master_domain;
> 
> Looks like we mixed a cosmetic change :)

Ah, it is undone in a later patch from moving some code around I fixed
it

Thanks,
Jason

