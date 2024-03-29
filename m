Return-Path: <kvm+bounces-13099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92BFD89200B
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 16:16:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C084D1C293A9
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 15:16:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66F7B13A888;
	Fri, 29 Mar 2024 14:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KN+hgUaX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2122.outbound.protection.outlook.com [40.107.220.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42A4208BB;
	Fri, 29 Mar 2024 14:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.122
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711723930; cv=fail; b=m/fMN3w0AComs1exlEEOBQ13SRB+VAThnM7+hToTQFdAengMbARnqmWSD8XVBypVqNRdJcyfERtqjKmycJUcaMfSr8SrKcy9nLOd6Nge0fTDCtRT4BZsZtHNjiJC7jHBVbIvpji5UNOCvqUrwpXVXSE9vZZxzOwDc33h8U+9WsE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711723930; c=relaxed/simple;
	bh=DxXMQ+4eWStsTOeJYK73kVreKikiElicsKpVQy6o76E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=i9Gsfa4KfKQCmeWnT7dZ0GLp5nJnTLTuO4wWTuVnlTHIdLb7QY0akNgBgbUhGmSGO7T4jdoT8MAY+nG8bev/uitZFG9i/ErgS8Ttu41y29FAeyZ3rBc6j7x5jSjfzU2/BhredW3Um/0GfpKL6m/wzCc9Rfhn7RmloTo4J0rkGMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KN+hgUaX; arc=fail smtp.client-ip=40.107.220.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yy36rZrrKF6QfpUSDn9tbURj5eCQ5LXqFRrER+2/Dfw5/96528FvURmTdCZ2QugswWgqWT0w3QU08b8uKS/8n0F2mEXUgtNcfB+VYHTjtIkOflzJBBR+lh/pZjmCE6vr6WzpUBIBCitIeC/65qX5WdUqSjjKWOJEv/EoZKcLt4YaVU4NDMi5zx78qQfa7HnTJyFzSUdfyFgei7WRd7cB5ssA0LLKXr4I4bzj4rKHwrCmveiUBSo+LE2YFvYo2Wn5hFoL+4bUDT/l/1M7YOiGahFfY5iWftEz42iOjYYTVBRg/KZgijH+DZPzGrIAw083Ix1TgTqHDzgDxRbHUQgtTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bLnm+/CBhcSYSDBLmhIqvyAUn2Q6nanFymJuPH8hESc=;
 b=fO1z4zJSAkrD9h4MbSA4nKqWCrOE7VIHEMOOL321uNqSpQcXSU3ZtzZgFD7MmGdBog+R8XcVS4KPgniF9YtJMyU1KGxhRnPBb1Agfyuam0oiTsk2SIJTrSmmkNp1lF+CkFIxVgxxPWC8N3COqNbdOhaF8J+NwTJgU4oldtBFV6Q1CvlGEVkKMu+A6pwY3OzHFmFoxogo1aiMlhXYPjB/qEsIIdB2Fbx03Z/NY+swqLMSIL3oEjo+Wucxfq4t/RqEVtaGeRN5S+/S3sl0O9Wwm6iptd4vFAwtw1CTy+iMVZtV+D27fH/iRTGO3QcaWndHrIEd++BClVsYY4iWOUbfXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bLnm+/CBhcSYSDBLmhIqvyAUn2Q6nanFymJuPH8hESc=;
 b=KN+hgUaX30fQLfulFfiuwckVIx0f6P24pZ9JAFlRmct2Id0dHjkcWb8GElMoXs4EfpbmQzAvjPMH3Y6hjgIPuDNa+wZ2KPyAaRtNhzBYFLSnuFjuItAyU1MBVr0qJL4YXPMLeQRqrfURkDMDLT7akbVDTt38ITbAtcndBkYq26o=
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by PH8PR12MB6794.namprd12.prod.outlook.com (2603:10b6:510:1c5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41; Fri, 29 Mar
 2024 14:52:04 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::1032:4da5:7572:508]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::1032:4da5:7572:508%6]) with mapi id 15.20.7409.031; Fri, 29 Mar 2024
 14:52:04 +0000
Message-ID: <1e0e0f42-950a-6971-dc12-a7beed7efdc8@amd.com>
Date: Fri, 29 Mar 2024 09:52:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 5/5] x86/CPU/AMD: Track SNP host status with
 cc_platform_*()
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
 Ashish Kalra <ashish.kalra@amd.com>, Joerg Roedel <joro@8bytes.org>,
 Michael Roth <michael.roth@amd.com>
References: <20240327154317.29909-1-bp@alien8.de>
 <20240327154317.29909-6-bp@alien8.de>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240327154317.29909-6-bp@alien8.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0106.namprd12.prod.outlook.com
 (2603:10b6:802:21::41) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|PH8PR12MB6794:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	xf6qKfDME5geecNofVOoI97lWDJYkfoXENFfmmFJtvgiO350a1LjtrNfUPdrZbgT0sz+2ffOjst2FgwdQsFXwwXZzeRyejNzWp7NBVM6UVXBt9HLXEDSqZNAlX4qE9R2q9Uqv0jfB/IdhGPvl4CnhaCIxy1fcA+Z6Kj6ARbUfkRsf52x99QiTO2FD7pQeGO8pkQlEIoqhtAwTO59i/j0Hmo4z1CXsGl/GcOWlxHe2r1dRDTWPQTgGKEP7TxbmCufB+NQWv6gU5Pi6lmzlumo1kOpiL9bASItKpa4/8Flbg5yOADBS7wr+JpZTe53gBvO7XhNJASJ1SyxmXLx7/ASfB+yYJtN4vG7GP3swjCw9tftXj9gxeY9lciji3XrEaqRbCsg2+fpBTyFeHuPxsjOhkcbjG5MlAF61qtEx9gBS22D0SFYrXB0g5mtIA/N3cUNmoh2VOcLI8+7px2nrA1zY1IVLhL5RzitryrOBlyReAYZc4Tms05qMwZcjBAnTy3WoBLQTM4Xa/FE6X5YDvU6c28tMlOW8WiXiRAZVBFGpvggAaPATiwttOAddS6BEv/6KLSBdgHCyM4ii/hZra2DgcvTKYOzOHYlHEjfPcKcsUkZQICUuNi3JYwVdVo0cKg0rkFLPdjJq2caBvT4cyy71+jlTgBrwbHs30D8OtV88lg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QlhtdkdGL1VtSHgxVk5xRzAvUHJiT0tFVEtGUG90RTJGako4SHVtdy80Nk5G?=
 =?utf-8?B?RkdSQXU4WDZNaEI2V0Y0VWZqbXN2QUNiVHJPRmFFWjBWaHQ5ZGtBaE9Tazd1?=
 =?utf-8?B?QURJd3lQTXp4Y2lTbDJpYkttOG82Qk5PZUtPNFBUdTdzQkMrWkUwMXkxRWgw?=
 =?utf-8?B?Nm1uZ2dzUTNON3Qya3pHVkdRMTcyUnpYSlkvTTBKdnR3SzdWMndBK3ZMelNo?=
 =?utf-8?B?NUUzSjhWNEdlcmtwWXEreVA3VVpwQVhTZEFNbkxGRkkySTcrVS9zUmRDL3Vo?=
 =?utf-8?B?ME41WHZQQkdlSWVQbWgrR0ljUUJhQTBid1FlQlN5OXFsQXJ1Um1sKzR1bUIx?=
 =?utf-8?B?dEVRcWdMOEZueGdhQlNTZ05KeXczZWk0dHp2UW92R1I2N3ByLzloZ1lCUjRj?=
 =?utf-8?B?d0EvNGlQVmEzSnliMnZWWmVIUlVqL04yQnp6QlF4Q25uVC9jNkpWRjJIbzRR?=
 =?utf-8?B?L2hkY1FvZ1dEbEtPN0hXWFhEeVVYbCtjSXV6am9aYUdQQjBIZXpxb3pKMXE1?=
 =?utf-8?B?N2g5RC8wYTJmd1RTTTNtMTVPTk55REdobVkwYVI2NlJWWkY4RkhpTHIrdzY2?=
 =?utf-8?B?c3NCSkNBNXhtSnF6ODRndStwMzl1UGFGNW0wTnUwZWY0eSswT3RUeVdWenV4?=
 =?utf-8?B?OUJlWGhiOU10Sld5Y2g0allwRGM2cnFJZUxkdWYwcUkrME42aCtWcU50MTVm?=
 =?utf-8?B?T0tyQUpZOTJpMGw4WmlrVGhYSC9OMExQYWtJb1VIRUFNQ04vcGdVY2w0REZq?=
 =?utf-8?B?alF4ZDc2eW50SEVJVmJXOWR0am1rb0VnbkhiNTM3MFJ2azI0ZTFxTjFNYWd3?=
 =?utf-8?B?RGZCdXIxMFh3cUhqc3pqYzRBOTNXMEw4Nlp0K2xpeDJGZXRJeU5XcEgzSzRX?=
 =?utf-8?B?dDZiM28vVlJKSU1mRXNVbW9uZ1NKU05LK2ZCTGlBd2ZZNDBCYzAwdk1CTHNB?=
 =?utf-8?B?MzFocXZzMU9tS255UXBzK1VBR2hlR3BvbGsyTTl3R1ZlazRUcUtYRlB2K0FL?=
 =?utf-8?B?K2hSSjE1ZGlwMmJDT2g5Yk5KRnBxYWZtRHdmbTRNTVZSbCttUTBJSVF5bkVD?=
 =?utf-8?B?blluSzU4SU1NQ1JYblBsQWFiSytYNGltRFdxU1E5dk9DbDh1ZEJNeEx0cVRK?=
 =?utf-8?B?QXB0TDlEUWozMHlHYWVOQ2dkY2p1SEhBMlViMlI2K2hTaitBZVdzZ0UxOTU1?=
 =?utf-8?B?Uk9Zdm9nTXcvZnhrM1NKT1c3bm5zdTNoTHRvazQ5ZHNhTTdWYkJOaE9ud3ZC?=
 =?utf-8?B?M24zandNRjJOYUsvUnczWml6ZXZsSSswKytKWEdEU3BoK2RsU1VpbG4vWUJQ?=
 =?utf-8?B?emtkUjRqZnFhSHRqMFY4UUlKelBJTk9Pb2kxZXpzVHRoZjh1c2VtbHJYRkN5?=
 =?utf-8?B?OG9WdFlnYk1TT1hNNTViNzFaZm5MTmxyd2gwcThZSjBlb3lTLzFVLzZsdEZj?=
 =?utf-8?B?R1FUNDhOSXlWYVg4cHBCVDlnMUlUMEx3M0djMld6cDhUZWNCNWZkTFFtVlgr?=
 =?utf-8?B?YUc5d2RuZWZJbHcvRWt5QmV1SWxZNEdERVArZHluQjhCS2h5cEp0YzVqekpH?=
 =?utf-8?B?ZVhnRkttVXpWNlVQOFZXUG96SUZoZllFQU1HTzhtaXYxbXIvU2Z0TVRYcEt1?=
 =?utf-8?B?TTdINzJPZndNTVlIZHF0bEc2TFRlS2E0em4rMmJhaElLNmJocmxYMzFHYTE2?=
 =?utf-8?B?cHFNT25iTHc1ZVFtMTZrMnFwK1JlNUE1Z0JRM2FrTzErNEo1cm5jUnVxalVD?=
 =?utf-8?B?NTdhTnVHZVV3OUF6WVZXWlR6ei9xbTByRTFMMTB4bFBuaytVZEFRR1oxNWZD?=
 =?utf-8?B?TjZ3NWQwbzFNM09Rcmx5alJHRmVVckN3ajVJUEVTeEJEeXFybWVpMFMwOGxp?=
 =?utf-8?B?eW42L1dhOVlQY3hjamdXc3Z6OUo0ZW1lU1Nzam4wZklJWVRVaVEyOFE0NjB6?=
 =?utf-8?B?TDFlOG1UNWYyS1JLSmxJZzl1eS82a0VhTzlVaG5EVFJzdG12K0dLYTBNUldj?=
 =?utf-8?B?enVHcGk4UERMU3pyNThyb1FDRXdqaThsWTdSRWVzeVFIRXdOYWlVbm1lOFMz?=
 =?utf-8?B?WlNHMklKMjRvT0FaczdSenIzeEtybm14Yk9BeGdFZUtsUG5aM2RGSFVTMHov?=
 =?utf-8?Q?jYGq2LTDkzEdsKgfidFw6+clN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6427c88e-db45-4af3-d3fa-08dc4fffcc93
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 14:52:04.8425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aN+W1v7R6tUiSqXbgCeOhWY9AWb2vpzSwpfkPsmmlRpbgMhspMWVOEB3xjAaHb9/2ZNXh3sVyexaUXXoq7ZCag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6794

On 3/27/24 10:43, Borislav Petkov wrote:
> From: "Borislav Petkov (AMD)" <bp@alien8.de>
> 
> The host SNP worthiness can determined later, after alternatives have
> been patched, in snp_rmptable_init() depending on cmdline options like
> iommu=pt which is incompatible with SNP, for example.
> 
> Which means that one cannot use X86_FEATURE_SEV_SNP and will need to
> have a special flag for that control.
> 
> Use that newly added CC_ATTR_HOST_SEV_SNP in the appropriate places.
> 
> Move kdump_sev_callback() to its rightfull place, while at it.
> 
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>

If late disabling of CPU feature flags is ever supported in the future, we 
should come back and possibly remove this. But until then...

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/include/asm/sev.h         |  4 ++--
>   arch/x86/kernel/cpu/amd.c          | 38 ++++++++++++++++++------------
>   arch/x86/kernel/cpu/mtrr/generic.c |  2 +-
>   arch/x86/kernel/sev.c              | 10 --------
>   arch/x86/kvm/svm/sev.c             |  2 +-
>   arch/x86/virt/svm/sev.c            | 26 +++++++++++++-------
>   drivers/crypto/ccp/sev-dev.c       |  2 +-
>   drivers/iommu/amd/init.c           |  4 +++-
>   8 files changed, 49 insertions(+), 39 deletions(-)
> 

