Return-Path: <kvm+bounces-38092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3155BA34DE5
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 19:43:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C27A16C1EF
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 18:43:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C199245AEB;
	Thu, 13 Feb 2025 18:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PAT39G54"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBECF2063E2;
	Thu, 13 Feb 2025 18:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739472207; cv=fail; b=CfCbo0HZ8EQlijnSTE4Bl+5xP7ItLo0CgS1lipUQsnxSOaoPoziOagA0jxeXsJ4Ny84wgLIYHdMpEed/uReDIZXwvJBHFxlseeOl20QBfL+00o5pgr8Nlne7zPGBsJWpuEByABHhHWv4lZrPV1RwBNJR9GqwHW/bsMDleGRkd54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739472207; c=relaxed/simple;
	bh=/VFsCc47Epz7Cev6zQatyGsYQG12b8cI58xi+M8P1gA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pPyyo1xqY8r3TeCmiaN5lYqedWdhKBUDh0BxWCfQfrqjtDGqP8QTB4CqE3xbYN1pxfdZeve9B54KzCzBc/NTbOtXmIM1KZIsPjUvdj24ImqWq6z0qOlMain3sgJ7VlwkytdjgpdrOMUq0rCNMHp8X6AtmDWAoVRTzQx7PDH16Lo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PAT39G54; arc=fail smtp.client-ip=40.107.94.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MzI2v2V6d/vlUYf25vnJIf5P5tPLo01ck1tLI81R0ZR9u8f2PS7P4EslrjOminxgTMR8YtaJCuS72QjZNtInpjbXJwE76B0d1arJIv7B8Gq0Bbsb10fVyXNM/wElc+nnNqjuig4teW/EgYqfPDkjLJIkGMetkLI4GXsENo9qSa0OfcgP+h/EM48ymFKzNxMxAJK4SDmCspuNyk751v9YUedxWSO9WDVgJ+bNQxGv9koZOq7qHTPfFkusqQUdT2blfecVt2Y4q3x/YvDLGGFHH7xXoR2dW87IrtI6hvYVnOAlWEFupnCowteCo2eJ7aNfWiGfM1LNgx+EQSFtkCM6iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HmG88qnXRnDNQQWSUobb5oC5OQ+ReUikKWqPqfv37E8=;
 b=KCWJavkG57SxjfFp7G04SGfCu/KxwqVC67RRQkvs2dzNlXdUtfyQjnVi1brnFMatxU0YBRYFemNLxE4tdNAMalA5k4Uqo7wQhpQF0jBBZe2g9HQLx2enX6fjMLc6dMyhtbCHL7bUv9fTP2KzvnWb0S0yr6M3IYYgZjhzl1nTSYltKcxuo6TmYS82crVjUjOVD2BH+agiubheZJHurwjLCxjvXJKQu4drIQKvqrkMX2fXzO6P6N9DgYi7GJY1Lx/PFqgqX5MSACqKVPCzUJV3IMOMa/gBtVgz20pxQJfsLp7qFXkr2d0HvH0shWMDRZHVuNnXQq/vViQEpXRPoBb+JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HmG88qnXRnDNQQWSUobb5oC5OQ+ReUikKWqPqfv37E8=;
 b=PAT39G54D0YUYKCZCMDJEDQS9djWzZbwTJnEDS8M78Z0NAtqI6wsRyrSiOrYeZQnyLArPa+SbKDvyarVgO1C78qNi9i/zul1eN4I45H1lDSzE6gIAiCtrsJVMvaF+tYFkz5BMuWGeIoAWd+Bj67oKvmJcJhzi4qePnJnRbMsZ0slOvDD5acZYPmKuswDUGAJw0SQe/uXewntTPxIzdFMD4KTQ5OjpFIBIQDhO/kqwulwbM553NnGqmCAEYBzBUQNUZn4xU1cxMt9V7PZv9lHehySOj1f7NdI1uLCPofJc/AJJ6lh7zxd6nfUYA/RqHe4UznPluY3LpBiPuOp7YJtnQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB6637.namprd12.prod.outlook.com (2603:10b6:8:bb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.14; Thu, 13 Feb
 2025 18:43:19 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8445.013; Thu, 13 Feb 2025
 18:43:19 +0000
Date: Thu, 13 Feb 2025 14:43:17 -0400
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
Message-ID: <20250213184317.GB3886819@nvidia.com>
References: <20241112182938.GA172989@nvidia.com>
 <CABQgh9HOHzeRF7JfrXrRAcGB53o29HkW9rnVTf4JefeVWDvzyQ@mail.gmail.com>
 <20241113012359.GB35230@nvidia.com>
 <9df3dd17-375a-4327-b2a8-e9f7690d81b1@linux.intel.com>
 <20241113164316.GL35230@nvidia.com>
 <6ed97a10-853f-429e-8506-94b218050ad3@linux.intel.com>
 <20241115175522.GA35230@nvidia.com>
 <20250122192622.GA965540@nvidia.com>
 <284dd081-8d53-45ef-ae18-78b0388c98ca@linux.intel.com>
 <f7b6c833-b6c1-4154-9b77-13553e501f2b@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7b6c833-b6c1-4154-9b77-13553e501f2b@linux.intel.com>
X-ClientProxiedBy: BL1PR13CA0326.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::31) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB6637:EE_
X-MS-Office365-Filtering-Correlation-Id: 45ed8b08-5bda-47ac-9254-08dd4c5e48c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rYnudnKkjPzkfeJSVd5s3w69H1TXrZFzOgSBRwdRTAHHsXODrsddrDGYhSgT?=
 =?us-ascii?Q?bDN6uNaGJYqAywh8WeOt7wZxymMcGfHKoTIIU9y+wpdN1v4pn0WSN6fVtKAy?=
 =?us-ascii?Q?crT8D6xnvJCyaKvY9dFoTxMgwQrXwZ2RTBmb3jnHe217+3LV2EOFi3NX4kg6?=
 =?us-ascii?Q?xc6muEoUSiLZXRtbLGDJRt/H/tX7cp0qfHcRY3ReBToj6jEWAcIftly/5lMX?=
 =?us-ascii?Q?P3ZhOd0I3+FfdwT7PqrpQ+kdNl0dsF2NcosMJLQyOtRX6g7MJnyHPRyr6UOQ?=
 =?us-ascii?Q?jVrxfn8OlImxwsdcnteTLXthtoga/wprnneyn1pGNEgIiSGsaiVOLaQSqaXN?=
 =?us-ascii?Q?D3PmySWSxgp2BwgSwLttDgJIKnt5JGrwyPE9FLpGUS7KMalEDrwfRn98ewXa?=
 =?us-ascii?Q?JaozrsgiSaMoxkcT6PlLtxfHkmPggboZMMmrrDf5CoYVuX+eDOmu0rp2uqy8?=
 =?us-ascii?Q?efNZ9U4fdNxoOKVR8HVQ63XyXR+QixK0TbswUA7XXTC0DQppLEr25dkEv84C?=
 =?us-ascii?Q?zjWYvUDRgCaT6irKWzwyOLc9HlvxIp0hDT6foXFuaAd3BKRTQVvPdTBygvyL?=
 =?us-ascii?Q?LJy9+qr4VdvfJHl8nZG8BP0NSieAmHwVDreCZ2/Aq1hE9F54JISP5OsKatAT?=
 =?us-ascii?Q?zLNQJcUH0+yYeiU5lUo5YGD5sFzUzQiewsG8aNoOXWhaJzcZlcUP+7j5Vfw+?=
 =?us-ascii?Q?qS9JRXDS+v7HV/GNc0NJPN48/eKYPUXTAoRJZ95jimiWtHQRQV+s68RKyH2l?=
 =?us-ascii?Q?AqsdZ1jCfBiEuse/6L1G+vnx4HCOXwfM71NvKnP2s5VrFGpw+G3pRtGe6iQC?=
 =?us-ascii?Q?88kUDT9ZYO8+gqtYY0C9tSjbbQ2jYft1+lRvSb5knD1zJoQDhiCFNVTsGoBM?=
 =?us-ascii?Q?jsfMnXauAupHy8nSyA6NoiC4YJwd1y9o8VLSiPRWvOqrI5DH74VGI50nHH/a?=
 =?us-ascii?Q?C9wxwvc8NdDtuVjoermgL3NBl8a3Tgv9vYikRHpCggWD2vtM+3fiixxvfoYq?=
 =?us-ascii?Q?vWqBgkDKm/LPSvc9p0/4Q+hv+SIoBe9QLmEsgMUt+sn3OgeNsjME5Lc1LXYu?=
 =?us-ascii?Q?d8vB4/ezlvccTWDMidpm3CthC+o/qbkMmDlXt1tdcWyz0An/yTlNrwKw9tW2?=
 =?us-ascii?Q?cNfOgzW4WFomgkx0Q9SFUG7FkmnknN0ADzX12bw48e3rfJ9PFo4406oC/s58?=
 =?us-ascii?Q?3+frWd4fihRkegwcBPlv0mX7C2HfJYYdbgdHsV+7trTGQPEwptdTBONAz3g4?=
 =?us-ascii?Q?hnAijHpk23Pggss3u8vaTHuinJmn7rSns+GmYnlb6B9A8tT8ksP35BELvNKD?=
 =?us-ascii?Q?mAgv0FtejQsKYKOzaTcT/aoIfEdQQDo3p+ur61walBwJy4SUz4a6zJZX0WV7?=
 =?us-ascii?Q?dMdQzaRHEtj9jLPHcUr5WNC9DiAOI+XsuLzRNQivl3U40MspMw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AwuyfKmcDfUoAg1k3ljdFdXug7VyEpFr0uUl63z2+g179m9d01XbgS1Fl8IO?=
 =?us-ascii?Q?LtuPMiER99QPzVJK1D2wd0saMiNDwkMe9U2MqP+9YAaGp/LfPi39iSerrx9G?=
 =?us-ascii?Q?KLYhHJWHFXa6o4A+AcA4cIBltKyyo64x7AxXFR6TYQH0dPRap6Q8sbQUFYIJ?=
 =?us-ascii?Q?ebJSDtor5Xf7rGVuoNOH78osuJ0lIAOYI2oVgVi3zVwsOogtL6FbJwjBIJ9C?=
 =?us-ascii?Q?99BciPthXv9B30Z+Vqef+2BWuDbssKBMO1o6vxHH3jnTyY3Bss6tCC0VwZdq?=
 =?us-ascii?Q?mzNlSRoM6ck9DLyEHLex9SnRORv+jB2PlqhM2ZlRQNvfFrC64qfDVbMU6c9u?=
 =?us-ascii?Q?J2XneMntgThDEOeoQD32C6wwZGW87qcoeobAt0XhF1wwZZnCm1R+oociSpM1?=
 =?us-ascii?Q?az6sQA2vn5IhITa4CpiCnffotNFFwRl8WlrDsJOgX5sgKbqjZyX58BGulyZX?=
 =?us-ascii?Q?0/ysX0dQC0YsAsnueAlYmxJ7BIkgKLgK6IXHX1R2dzTlEFwOrHwi0LkKyp0s?=
 =?us-ascii?Q?PteB/Mr8N7ISsGm0pe/0jjzeMgjQOCSV/0bbzVubQbm/twPXgecGq1PPCIOJ?=
 =?us-ascii?Q?XfPruRKJWxf9q14XjF0ThVc2c8JK9vp9WU35hh0I0CfyNZsMsDPA3HCqVDUx?=
 =?us-ascii?Q?feck7qz4uBCIOt/MrwyPBCMJrb/TfdFq5JMLFlx0LYDuQzlDFKI1YlKhvKyW?=
 =?us-ascii?Q?FnaS27kdGJWnie3y75Ji97Fi53mVVlR2zr8Zg9qWGSwWZbiTMJfeoU9upxlL?=
 =?us-ascii?Q?LlnfaQdQW4U64pjo0yPrZGofm2zlSVGj4at5dBPNxg2R6PiGTPb6XF3CAvyh?=
 =?us-ascii?Q?wcJbDLUKdBL4Te4wBcTyIXviuJDllmGyVwCNc+rL5yZmpvYHBer2Rs0Zntos?=
 =?us-ascii?Q?Jyn0vXPo8uBXora9Cn7Hkf97sx5H4Z4u2abLScSGHfke02Rrvfh+EAdF11FA?=
 =?us-ascii?Q?16daH9IhQHw5loOavZvlq8pUvRtPwPpH5PFZ8We4XIJDeJLbW23oZEegnz8h?=
 =?us-ascii?Q?R+pT54Pzazdrlnb3u/ObV/2+t2XquKBo4DWOZaN7xkbd3cusDKlnbMwHBeCD?=
 =?us-ascii?Q?9Zao0NthYUQND9ySkpADvsDdG2CdVwcWCD8+zyot1VobmUnopkkwnM5kv6M/?=
 =?us-ascii?Q?nYm6vHZ2TVYXBHSq6SqjvMrR7e0zSFER00RpVrnrZ/d8EoriDTvLaGvrWZvD?=
 =?us-ascii?Q?vQtyqcDzCHi7C4xIWH/ML+qakXeefegxajRA+LSgaZadj3T1NB3lEpID5rhe?=
 =?us-ascii?Q?wsQoG5h8Iy4nIi3ARzMbzf0aC8TSMyjEGE/ZDsN0vKAKto3P7XDA7EkwWvAh?=
 =?us-ascii?Q?RSebx/eEcyF7cW8hFR9p7pZGM0AHEI/9bTtzMX1ao9USiYAZC10GD2YWUUt1?=
 =?us-ascii?Q?A/7t7pacIj8+6tza/We6CpOV0OUDGXinrjD5mv/dWEeNWUQ3TmY4qd9NNvtt?=
 =?us-ascii?Q?lAFb3qHNxwY1aOwtcn3cx2VfZDHjCl1Kv1OMN0mkyieePwYg8eeEKXaZpu3+?=
 =?us-ascii?Q?mO9DfKmSrtatUwo4wbcekBKSxZU/y9rw1127qWeX+0CUkVpxKKFFvM9vqF+0?=
 =?us-ascii?Q?k/ooUo0IWfGmkdRkOyVNObSmVc6bY8Q6AVuHORBn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45ed8b08-5bda-47ac-9254-08dd4c5e48c2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2025 18:43:19.0216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v2OdXkPqmClB0xlxldm7JBZIW0ASaYuzkeD6sHQrYrCkHryGLLBMtc2VrnTdZyNL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6637

On Thu, Feb 13, 2025 at 07:57:51PM +0800, Baolu Lu wrote:
> On 2025/2/5 11:45, Baolu Lu wrote:
> > On 2025/1/23 3:26, Jason Gunthorpe wrote:
> > > On Fri, Nov 15, 2024 at 01:55:22PM -0400, Jason Gunthorpe wrote:
> > > > > > I need your help to remove IOMMU_DEV_FEAT_IOPF from the intel
> > > > > > driver. I have a patch series that eliminates it from all the other
> > > > > > drivers, and I wrote a patch to remove FEAT_SVA from intel..
> > > > > Yes, sure. Let's make this happen in the next cycle.
> > > > > 
> > > > > FEAT_IOPF could be removed. IOPF manipulation can be handled in the
> > > > > domain attachment path. A per-device refcount can be implemented. This
> > > > > count increments with each iopf-capable domain attachment
> > > > > and decrements
> > > > > with each detachment. PCI PRI is enabled for the first iopf-capable
> > > > > domain and disabled when the last one is removed. Probably we can also
> > > > > solve the PF/VF sharing PRI issue.
> > > > Here is what I have so far, if you send me a patch for vt-d to move
> > > > FEAT_IOPF into attach as you describe above (see what I did to arm for
> > > > example), then I can send it next cycle
> > > > 
> > > > https://github.com/jgunthorpe/linux/commits/iommu_no_feat/
> > > Hey Baolu, a reminder on this, lets try for it next cycle?
> > 
> > Oh, I forgot this. Thanks for the reminding. Sure, let's try to make it
> > in the next cycle.
> 
> Hi Jason,
> 
> I've worked through the entire series. The patches are available here:
> 
> https://github.com/LuBaolu/intel-iommu/commits/iommu-no-feat-v6.14-rc2
> 
> Please check if this is the right direction.

Looks great, and you did all the cleanup stuff too!

The vt-d flow is a little more complicated than the ARM logic because
the driver flow is structed differently.

Do we really want ATS turned on if the only thing attached is an
IDENTITY domain? That will unnecessarily slow down ATS capable HW.. It
is functionally OK though.

Also, are there enough ATC flushes around any domain type change? I
didn't check..

I feel like we should leave "iommu: Move PRI enablement for VF to
iommu driver" out for now, every driver needs this check?  AMD
supports SVA and PRI so it needs it too.

Do you want to squash those fixup patches and post it?

Thanks,
Jason

