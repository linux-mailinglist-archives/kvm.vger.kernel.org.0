Return-Path: <kvm+bounces-29925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E60F79B41C3
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 06:16:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 762121F22DB6
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 05:16:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A252201021;
	Tue, 29 Oct 2024 05:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cOoXT/NW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1633207
	for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 05:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730178986; cv=fail; b=k8lUu98ahCL+i7/czWO/IoQ6M0FwoUQPjvKOvBFvKyOoxIt+GgXoR77g+A+oUsiBq1n5q9rzwzaDejXY9E01QsOZh/LbaA5G2MxrMAd6W+ydC2y+QDhvK7fbMkWBVkeiCTAVd5sdcDVicaPtlDb1t2rm9sC+pfAkJ7rASjUcF/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730178986; c=relaxed/simple;
	bh=dD6MG9i4yPjyccgqBqbZ9vjNnh15ZbX1/15HMNEFpVc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DGHZpEiUwWfafEtbGSUPzPqfdC1xW5K+ntRIqwGz1DRF0zaF9L8cSPTFagcLyGVG66Y0M7LrDd3tXZqhT5zG7SZiQrJKba32YNQk9hP2+HatduJx+ZUQhor/M1EjZzAE9B9Nw2ahyONBKfuHXQN4poPX+/33keuMxzmQSKDvZNg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cOoXT/NW; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730178984; x=1761714984;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dD6MG9i4yPjyccgqBqbZ9vjNnh15ZbX1/15HMNEFpVc=;
  b=cOoXT/NWT6lf0QWNCLr0YYdpQWHY6SmLZkJMg1bJG/ondVtv+8lCIY9a
   bA10lJIUqls9ZGYWsst5hAJH901bXAAv5Dc4TFMfTeFZeEgTM0G+t2dzO
   rlEP1ERv33mmHTkGcm6gByusWgyk9Mf1Jrk9RRlmbFTU7cBFvyTF2hVSP
   x5AHGgiRTm/qwvvaVo6zy6xmA2DuQ/Hgh2dI4MyxMLV/RnEcPe+NyCoxn
   Sd1UTa1RSVP2vaieglEoB3ua82ldlr2LDUmqaNWGweuB1sCpenA6Oc8DC
   PkwJk+TwSi/tIH/2RazQTW54A1yJI6gxEUcdPO8xslAtfRob5xzKvH/cW
   g==;
X-CSE-ConnectionGUID: +T1UQzDqRcGx66he+aV54w==
X-CSE-MsgGUID: cI37di+hQPOYnuhi4eRarw==
X-IronPort-AV: E=McAfee;i="6700,10204,11239"; a="41163223"
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="41163223"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 22:16:23 -0700
X-CSE-ConnectionGUID: lpMSPYXsQNmhMJGabf4TYg==
X-CSE-MsgGUID: 520Jtp4NSauVWwUnkjvM3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="81460464"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Oct 2024 22:16:23 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 28 Oct 2024 22:16:22 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 28 Oct 2024 22:16:22 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 28 Oct 2024 22:16:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p/i+LMmXJhYdKXRSVz+rbp6HZ1cs4pmwd+VyllIBpL8HFNbgaXDzLQusF3BqYzmhIgBis51BxL8dhkukTjbLQb7XdRBdzyBXdMbuNHYGmePyNyiz7znlslTCnLQONq70bCK3FKgwE0y1W5Bzyv4pIKZ6M9pgY4VMXvRJZRX410DPhSxUk/5f26iBfPkpe7FghNvxjEbVHrZl6i8tXl5sloBR5jiwMcKGPlbR0LYjVUI1+2eLkl3RYFcNsCe9vHalYecjDIdFq2LMYlcVusKuRmuqS49IZGrp71ykH1+8zHdhENDATLxxFkS5KLDGhG+9C4945xCAbviZ2FXCXT7AGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kMVZSxGoAfWyWmRUxW+b7WRTheFh+58hdlVrIV6LaQY=;
 b=NMjoYPvAvQMRt2FyWu2Ux/3h6CiTbNP12213mP4oEbX8Lc56TY5TEMwaJzIh74hdumsnham9UtOTtNgzUjiisfa8AMuqyxE+6DJWoPen7/yrVBOXtj41vxWwUzvm3pWIFqx1KW62UXPsUyQu8eK/aECf1aYHrVb7dGgPXPDrmlkjYoHSAPoR6M5D9u6mMVgAnEENJICBkTfrp9AH3N36lWgeoFHEr/idj3rRvKwI9JMexvhQ1/BGgVd2NTE8hFy5clhZnaBSEoMg+WzXBvmMqnhN/ljKPE5lIKkRTNDOkzqMrrgnztXMerfBZrJ/rIdfCkAvCln0LGbf1Ly6a3HZQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB7014.namprd11.prod.outlook.com (2603:10b6:806:2b9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.23; Tue, 29 Oct
 2024 05:16:20 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8093.027; Tue, 29 Oct 2024
 05:16:20 +0000
Message-ID: <305bc6ba-13c5-4b3a-b3c0-284fc573a3ff@intel.com>
Date: Tue, 29 Oct 2024 13:20:55 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] iommu: Add a wrapper for remove_dev_pasid
To: Vasant Hegde <vasant.hegde@amd.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: <joro@8bytes.org>, <kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
	<will@kernel.org>, <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>
References: <20241018055824.24880-1-yi.l.liu@intel.com>
 <20241018055824.24880-2-yi.l.liu@intel.com>
 <20241018143924.GH3559746@nvidia.com>
 <9434c0d2-6575-4990-aeab-e4f6bfe4de45@intel.com>
 <20241021123354.GR3559746@nvidia.com>
 <91141a3f-5086-434d-b2f8-10d7ae1ee13c@intel.com>
 <e937b08c-4648-4f92-8ef6-16c52ecd19fa@amd.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <e937b08c-4648-4f92-8ef6-16c52ecd19fa@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGXP274CA0023.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::35)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SA1PR11MB7014:EE_
X-MS-Office365-Filtering-Correlation-Id: 45bc527d-dba9-4c47-f2eb-08dcf7d8d29a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VGxqbTdDNzB1aFlkR0VBb25ZMFB0dVU1NzBKeTBHVE5BdWtPZVhSQkpTSXI4?=
 =?utf-8?B?clZVekp5UlRNMm1SeDBUcWNtbnRMYnE1MVNsdDZCZzU0Q2RHY2RUMkgvMzlP?=
 =?utf-8?B?QVNFb2xyQmdyRjJ2RS96U1R3M2xoT3I0Qmpyb0RSM0V0Y3ZZUnNJVlBxSXdC?=
 =?utf-8?B?aE5mUVY2SkxoNEhjdFFiQy81SldORytzc1hjZEhTNkwxK1RXTzBLSFRkc1hR?=
 =?utf-8?B?ZzZnbFJyMnQ4KzloNTN6Y0tBZmVkMUVTc0Y4UVprRlVxd20zMFZMUWE3STJL?=
 =?utf-8?B?eWJvbzJuNGNxcXhIQ3M3RVdKR3ZvVGNYNDB1dmdKWHhRMG5qREJMc1l1Y29M?=
 =?utf-8?B?djIyT0l5RXc4em91VGQxbUdBZTRZNC91QkdubTdvaEtnbUVkZzdzbnM1dzF5?=
 =?utf-8?B?SmpmZWEyNlBpNmp5cnI0SXdydXg2ck81WE5UZExKWU44bmF6Q3BvOXE3OGc4?=
 =?utf-8?B?dGtDQ2xkYmV2c01INUxRUFUraXM1clhNQkpWbUpndmoxc2ZHZ1QxdlJJZS9O?=
 =?utf-8?B?WHBNYkdHVlVlNWdZRW82TXQ0elVJZHpDVVlYa096bWloYmE2NU1KUXdCTUxj?=
 =?utf-8?B?Vkc2Y2NHMXljSWx3VkxHdGV3a295MmNHdEpjOGhsYTVnd3A4YXl4RnZCUkxt?=
 =?utf-8?B?NGRNTDg0WGxmT1pvUDN5bUhIUXN1eWdLV1Q2WEVpL1BaR0xzQ3RaUE1RSHd0?=
 =?utf-8?B?VzZJMzhlRzhaWU42cVo2U2NmT2EyaEF0amVPaXFDUzVlLzJyam5VTmlIZ2dv?=
 =?utf-8?B?bXBZam1iREowcDVEMndYRHd0aDA2SlpMY0NkODY0RjFoWlU2cDB4RUo0YlJY?=
 =?utf-8?B?di84bHNMWHlMa1I2cG0xL045NjlBRmsycE4yeUFLd3dsU3ZqdmRjMkxaeWxn?=
 =?utf-8?B?d1Z5ZENRN2phcVI0c1NWRTJJU2Y5azAxNXVrckx3Sld0U3lsSVc2SjRuOUhK?=
 =?utf-8?B?Y0daZ3N1UG9sUVFHRTdzcjhyM21lajAza3NiZDRpZXRvSUl0dHV0aHFLbXl1?=
 =?utf-8?B?ZEN2WUF4dTU0QU52VHpObUNpdjVLVzhnWktsV04wUGFGdWNqZ2hIMUVyd254?=
 =?utf-8?B?UmhobUFMVEZuZkJNNWZtSmZ4L3h3cTNHbTdNWWptN0VCam9vNDUvVWpKQ0px?=
 =?utf-8?B?dlhoang4K1d3UUUzYi94azJMRVJ1VmF0dHZjR1BYaG8xUHFpWDhxN1ZlVFI4?=
 =?utf-8?B?YWROTVNLZEV0anZRQmtXNWVEQW1OZGVWU3BaRnBDYVl6aWlCQjJvTHFoV3Ey?=
 =?utf-8?B?KzhNa2FwYVRIVDRTSDhCRjRaNkJpVUk5Y09DL296TTA2T0RsOUtPT2IydnFQ?=
 =?utf-8?B?bVBJOFkwZXE4RlZBK2c1MzljMWk3STZRRXZPK2tuNEM3QlMwa1dqdlNkc05o?=
 =?utf-8?B?SEMzQ2RkS0kybDVIS3ZOdHEwU2FXTnFzMkU1MHJvUkR1YURmYkFLaWZyeXZp?=
 =?utf-8?B?UmxTZjdPZm9paWV0RlJHeFpibHZLZWpIYURqZ2lMVTkzZ1U5aFFzb1grU2Vt?=
 =?utf-8?B?UVJhNWlEbElnWXQrUk5wSVN0SmtBdGU1L1AzZmZBT2UwQTJNd3lNT3lCVzdP?=
 =?utf-8?B?MkdOOUlNNUFhZHlCNVFCWTI1TWdJRVJzaXREMCtvZW1lUGQ2TkRGVDl1ZmMr?=
 =?utf-8?B?NlpQaWw3ZTU1NHZsTytFTlZjeDU0MGVOWHoyUTByclkzeHh3alUwbnBFTnFq?=
 =?utf-8?B?UjVsNDYyOUxLU2ZBeUtBMytFVDYrZFdTdTJQc3l4VWxpb2tnaS9MaDg2RERl?=
 =?utf-8?Q?bQwMDOPL+f7LnZICDg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rmk5djVWMi9DUkp5UFpoKzZDUzRoODZKQ0FRc216Ylg1VW94WHN3dmVEODl3?=
 =?utf-8?B?Nzd3d3VLTGs2bnlpK0krS3dTWEt6OUsxSUcyOE5UblljOWtFZXV0WWVyQng4?=
 =?utf-8?B?TWVJRTE3V2pZTHluWkdGV0pZdmdxVjR5ZXFOWWx6VVMybXBLYTQzZFZBSnhx?=
 =?utf-8?B?UlZtRFVMRDk2aCt1cHBKUmlLSjB3TUJvN04wckN3eEMrR2o1MDRoVG5XV3ZO?=
 =?utf-8?B?MU83alEwVnF6R0pTTjlMN1pPZGt3Tjh2YzQ2NW1BMm1sRlRpM0JmRVlVbkMz?=
 =?utf-8?B?bVNhUEVpbEcxM0hldE4xSHJZNnlTTk43OWRCR0NlNzJLK1E1UWY3cGhKTXJT?=
 =?utf-8?B?a2FKZ29qMGdBQzR6L2dTcjl4c25MdURmSDUxb3ZoY1Evek4vWmZjdWszeHVZ?=
 =?utf-8?B?bDNyeVhFY0hhY1F1OTVRazJqMFBnNjZ5TEZaeVZDTTBLY3JRYklVemZMWmlI?=
 =?utf-8?B?U1JST1FCNXdoRnpMMGQva0tlVUUyQ0wwUVl2RXVYdXljVUNvLytXYWUxOEor?=
 =?utf-8?B?RkZ0VUVLcjBoZEEvaGVBVWRCbUs4dlJ5bUlXeEZPQ1RkTXViMGtpMzNicXdL?=
 =?utf-8?B?bEYvQmV2elVYdHh4dFdsWitWQXpZNmNoditFKzZQaEEza3ppUmlHT0xxWFIz?=
 =?utf-8?B?Zmp1WVk0bWVsSFVXUzdZVmYvUEJQUHIwRE9OeUFoT1U0akNxTTBWbHdoVVNE?=
 =?utf-8?B?dnBpd1VlV0pmeDY5L09MVTJ3RlNQVXhDZGY2Q0xzbnJXcVoxUmZ3a29qNFNn?=
 =?utf-8?B?WFdaYjVULzJGOXArK3lYTTM1QU9hRWg2aXlJK0ttU1JralhyOThGOHRIY05C?=
 =?utf-8?B?QVdMNUl2L3lQb2NSVEp4VFlURFVhbG16VlJHbUhjQ3JheUl2MDZNVnkwMUts?=
 =?utf-8?B?R3N0ZzJLMWYyUFVSR1NYZS8xUnMvVGlsQk9TSGhWZVlVSjFQZEt2U09SRkRP?=
 =?utf-8?B?YTRWOG9NVE80YmJrdGlrMnRnQ09Jb21hd2V1VzVmcG9XUzBZSlJENTRmcXZh?=
 =?utf-8?B?VGZXUnIyaGJHemZ2TGwxc01BdWo0ZUFhWFd6NHg1bXYydFN3VFN6TC9JazlY?=
 =?utf-8?B?dFhEOXRzb3RYY3dEU01raDBVdGZ3VE10dzZxZUVCR1hkODl0K05YUUV3aUxE?=
 =?utf-8?B?K0sxZWk3L2NsQTk5dzQrRUlFNUZkeU5zUTNJSkxJRlVsUjFxNGhZa2tGbDVM?=
 =?utf-8?B?bjJQZ2Z3K2tybUhuK2p4Zk9qWXZIdnp1QW5uMFRXc2Z6aTVIcjVDSlpRbGdT?=
 =?utf-8?B?d3ExRmZSMC9ZWmVHb3p3d0xIYmhwNWJicFBrblFaeG0vUll2THJiMXR5NDh1?=
 =?utf-8?B?TC9BUklpd05lRVVPQk5RbHZhM2Nqb1dBMnpBNS9QSlJZeTBzRGVhQnZLbjV4?=
 =?utf-8?B?a0NGcXlpU083bDBzVTRUOWhKOC82SVVOZ0QwMXp4SCs1U2cxa3cyeVZlbUtr?=
 =?utf-8?B?Wis3SGxMVnVTcUw1a1NmN0NvcDY5VHFpQkUyY0pwMHRnVXExUnNFNllTS3I1?=
 =?utf-8?B?OHZLZ3VFaDBrVmhPUjU3ajYrOVlwUURuSEtjMjBReG5UbXFzWXkxVXNtckZr?=
 =?utf-8?B?NlVncEZpT1AyZlo3VWo5RWNsRGFYdnJqS01NcEFSMWk2THBNYTE4TVFDemFt?=
 =?utf-8?B?cnNwYnUwWTBQclhnQWFmN1FwTHRjekZXMnQzbGZCQjE4aFhhZVQ4QStSQ1lm?=
 =?utf-8?B?SEtpNi9OUEl6SEpVZ3F6VUk3bnZrWXdmRkxQMmJXdjhNSGN5VC90VFBGakg2?=
 =?utf-8?B?RURhWHFtam1vckVyaGJLKzY4VFJJMUgvV0xIeG1rMjE2NzhiMkdGbzJkMXR3?=
 =?utf-8?B?aWRidUpENHZnT3ZBL2JzWk1jQUhOZmorTGYwY0VEZzJMOUpiT1RwVk1WaUJv?=
 =?utf-8?B?R2x0RmU0ZmV1ZlVLRkNHV0RIVzJocXBXdnJheWNJNVF6c2lpZTJpczM3S1ZT?=
 =?utf-8?B?SzJiZDY2U2JoS2J4b3lsczBPYk1NSDFTU3l5UmkwR3NCbUowcmxTZmZxSFBh?=
 =?utf-8?B?ZER1aWpJSERYVllONDF6c1BsR2lrb0NUQ1dGRXg0OVlscWU5N3E2V3JJTUx5?=
 =?utf-8?B?OXdoNVYzTWxsNm5vK3c4QVJUdkJ0L3FxUnE5clZ0bkU3cmxlTGh2cXR4THNQ?=
 =?utf-8?Q?nCpfNfaPfw8frKuxf6atdlvEx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 45bc527d-dba9-4c47-f2eb-08dcf7d8d29a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 05:16:20.1543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3VivJvFCM3YK3SH8vn7+308sZrC0O9x8J3/EQXGg9e9jp6kNjuRKJcsPFxDsrV40JpbKfu+0KXNjF7opv/01JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7014
X-OriginatorOrg: intel.com

On 2024/10/23 19:10, Vasant Hegde wrote:
> Hi Yi,
> 
> 
> On 10/22/2024 6:21 PM, Yi Liu wrote:
>> On 2024/10/21 20:33, Jason Gunthorpe wrote:
>>> On Mon, Oct 21, 2024 at 05:35:38PM +0800, Yi Liu wrote:
>>>> On 2024/10/18 22:39, Jason Gunthorpe wrote:
>>>>> On Thu, Oct 17, 2024 at 10:58:22PM -0700, Yi Liu wrote:
>>>>>> The iommu drivers are on the way to drop the remove_dev_pasid op by
>>>>>> extending the blocked_domain to support PASID. However, this cannot be
>>>>>> done in one shot. So far, the Intel iommu and the ARM SMMUv3 driver have
>>>>>> supported it, while the AMD iommu driver has not yet. During this
>>>>>> transition, the IOMMU core needs to support both ways to destroy the
>>>>>> attachment of device/PASID and domain.
>>>>>
>>>>> Let's just fix AMD?
>>>>
>>>> cool.
>>>
>>> You could probably do better on this and fixup
>>> amd_iommu_remove_dev_pasid() to have the right signature directly,
>>> like the other drivers did
>>
>> It might make sense to move the amd_iommu_remove_dev_pasid() to the
>> drivers/iommu/amd/iommu.c and make it to be the blocked_domain_set_dev_pasid().
> 
> I wanted to keep all PASID code in pasid.c. I'd say for now lets keep it in
> pasid.c only.

ok. If so, we may just let the blocked_domain_set_dev_pasid() call
amd_iommu_remove_dev_pasid().

>>
>>
>> diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
>> index b11b014fa82d..55ac1ad10fb3 100644
>> --- a/drivers/iommu/amd/amd_iommu.h
>> +++ b/drivers/iommu/amd/amd_iommu.h
>> @@ -54,8 +54,8 @@ void amd_iommu_domain_free(struct iommu_domain *dom);
>>   int iommu_sva_set_dev_pasid(struct iommu_domain *domain,
>>                   struct device *dev, ioasid_t pasid,
>>                   struct iommu_domain *old);
>> -void amd_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
>> -                struct iommu_domain *domain);
>> +void remove_pdom_dev_pasid(struct protection_domain *pdom,
>> +               struct device *dev, ioasid_t pasid);
>>
>>   /* SVA/PASID */
>>   bool amd_iommu_pasid_supported(void);
>> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
>> index 8364cd6fa47d..f807c4956a75 100644
>> --- a/drivers/iommu/amd/iommu.c
>> +++ b/drivers/iommu/amd/iommu.c
>> @@ -2437,6 +2437,30 @@ static int blocked_domain_attach_device(struct
>> iommu_domain *domain,
>>       return 0;
>>   }
>>
> 
> May be we should add comment here or at least explain it in patch description.
> Otherwise it may create confusion. Something like below
> 
> 
> Remove PASID from old domain and device GCR3 table. No need to attach PASID to
> blocked domain as clearing PASID from GCR3 table will make sure all DMAs for
> that PASID is blocked.

got it.

> 
> 
> 
> 
>> +static int blocked_domain_set_dev_pasid(struct iommu_domain *domain,
>> +                    struct device *dev, ioasid_t pasid,
>> +                    struct iommu_domain *old)
>> +{
>> +    struct protection_domain *pdom = to_pdomain(old);
>> +    unsigned long flags;
>> +
>> +    if (old->type != IOMMU_DOMAIN_SVA)
>> +        return -EINVAL;
>> +
>> +    if (!is_pasid_valid(dev_iommu_priv_get(dev), pasid))
>> +        return 0;
>> +
>> +    pdom = to_pdomain(domain);
> 
> This is redundant as you already set pdom to old domain.

yes.

>> +
>> +    spin_lock_irqsave(&pdom->lock, flags);
>> +
>> +    /* Remove PASID from dev_data_list */
>> +    remove_pdom_dev_pasid(pdom, dev, pasid);
>> +
>> +    spin_unlock_irqrestore(&pdom->lock, flags);
>> +    return 0;
>> +}
>> +
>>   static struct iommu_domain blocked_domain = {
>>       .type = IOMMU_DOMAIN_BLOCKED,
>>       .ops = &(const struct iommu_domain_ops) {
>> diff --git a/drivers/iommu/amd/pasid.c b/drivers/iommu/amd/pasid.c
>> index 8c73a30c2800..c43c7286c872 100644
>> --- a/drivers/iommu/amd/pasid.c
>> +++ b/drivers/iommu/amd/pasid.c
>> @@ -39,8 +39,8 @@ static void remove_dev_pasid(struct pdom_dev_data *pdom_dev_data)
>>   }
>>
>>   /* Clear PASID from device GCR3 table and remove pdom_dev_data from list */
>> -static void remove_pdom_dev_pasid(struct protection_domain *pdom,
>> -                  struct device *dev, ioasid_t pasid)
>> +void remove_pdom_dev_pasid(struct protection_domain *pdom,
>> +               struct device *dev, ioasid_t pasid)
>>   {
>>       struct pdom_dev_data *pdom_dev_data;
>>       struct iommu_dev_data *dev_data = dev_iommu_priv_get(dev);
>> @@ -145,25 +145,6 @@ int iommu_sva_set_dev_pasid(struct iommu_domain *domain,
>>       return ret;
>>   }
>>
>> -void amd_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
>> -                struct iommu_domain *domain)
>> -{
>> -    struct protection_domain *sva_pdom;
>> -    unsigned long flags;
>> -
>> -    if (!is_pasid_valid(dev_iommu_priv_get(dev), pasid))
>> -        return;
>> -
>> -    sva_pdom = to_pdomain(domain);
>> -
>> -    spin_lock_irqsave(&sva_pdom->lock, flags);
>> -
>> -    /* Remove PASID from dev_data_list */
>> -    remove_pdom_dev_pasid(sva_pdom, dev, pasid);
>> -
>> -    spin_unlock_irqrestore(&sva_pdom->lock, flags);
>> -}
>> -
>>   static void iommu_sva_domain_free(struct iommu_domain *domain)
>>   {
>>       struct protection_domain *sva_pdom = to_pdomain(domain);
>>
>>

-- 
Regards,
Yi Liu

