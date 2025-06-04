Return-Path: <kvm+bounces-48359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F6CAACD538
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 04:15:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20CFA3A6FF0
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 02:15:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4A2727462;
	Wed,  4 Jun 2025 02:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n06hZEwW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C553D6D
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 02:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749003340; cv=fail; b=ES5hG/HWWxJWZJRhayjXp1rlA7uw4sb4PWtQyr8sxtq/GMvOTMgd+qTZEByb48U6u/fCH4/BolsoEKdPV/9JJhDzy1swoGoR6cpbrEPiuxQvUIretLGsL/paAoMecFrVVcKSweKmXnfjSJiq8y5ptyANPuEP9NDHD3mUz3cP2+Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749003340; c=relaxed/simple;
	bh=X2w178QMxL3GRu5UHG4f5klQCA7ioMdMjplUNF8qI4k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tysBTPUuNyMFoomacQPRxK3F/kmJQXPoKC7ukEavyklcGWX7P8cO/nHpcKUTASwrzL3xZLpIVRBTbudKCBbKjW9DfCpejjfQ+AJszid7+cVch5KV3XGFwnn7qR6av3qB5daGf9HQ9ystTM2kDc9sIhRAl6ce0iBFN/aw+mfIkyk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n06hZEwW; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749003338; x=1780539338;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=X2w178QMxL3GRu5UHG4f5klQCA7ioMdMjplUNF8qI4k=;
  b=n06hZEwWMb7B28IB0NyMlDE1H7CZqQ3GLzlOHGSrF3roUcfRY1bSOJd6
   WeuB151va0+FN2IK/pkZp/nG1Ifob5Nf6AMhboOK+Pyihoc971jWMID8o
   Nu2WJtZGUytoC4WzblTYqzETNZ1AxXRNufXk9x2q1Lqsl+1+Tr8ffH8UZ
   /JlT4F3yfMnro1axYAQaXbuWoV8Cnjdz10eFsDnRsH1aRD4dWrJG+wyd3
   VwgXZQ6afKBJAfyaUyFM3cVoOzF7/+2sFAyDHE7fp0iC4sqXB22fwEwXe
   s/L2AAOLJCY0jQtquFn+kZKYvS9wYfb4Ri7n5Aez6QbVkpxJZHj8FBtEb
   Q==;
X-CSE-ConnectionGUID: nI40qRYDS2qmdbo5KVXMmQ==
X-CSE-MsgGUID: LGyyeyaLQWWp2avGrJtEMQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="51206196"
X-IronPort-AV: E=Sophos;i="6.16,207,1744095600"; 
   d="scan'208";a="51206196"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 19:15:37 -0700
X-CSE-ConnectionGUID: lWfN9ulvQt22aeSKraEqEA==
X-CSE-MsgGUID: XaDZS4GVRn+WdjTJjI4W8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,207,1744095600"; 
   d="scan'208";a="145987224"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 19:15:37 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 19:15:36 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 19:15:36 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.58)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 3 Jun 2025 19:15:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b+pLA5Qb23adLx9eBAtF5m+spaCB7VVzwiAVFIknpLbWpyAg8c6OcxVGxzuzoRDwVrCwl/A/ycKAukVSV+EyNIpfWzTSXAAxBiNynRiQ7s1Ss6xPBPPxBF4GzrI8WF0sjOt2IPl1kU4Y+Qzf2ses4uBfFYrMO6NXWbMUk60Ux3H5nAMFun9LoRocGC9NGdOYUtWWI/r0eMAQD7FrFqI5/8S+Mwtm5N9Xtc0wRlGLipnZl+8Qbj9Uc+pi3Pcwb9L5ytFveq3lI7vXpqYcd6BDFWGUdLPev0AUsYPqw8QStaPie6hZj0CiIOe9SVWdpLII/rYfweAH8URDWgA6iaU3pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n0b7Bf1eCZrtZTnRyuyMQppXjjuBWrdmsZkM/P1lf2o=;
 b=n7RIX+4Z5OnGFG+6ZMAMaVb1f8qFKQszRQQfDz3iaiH8EPIEjjvHgPe6Mde8DkQqaKmgJ+DWqutlNNqfh7hM/SiOiKgreAF+xbhgbjU1/s3OADlC/GD7CLIdjEn3ejSZLGD5EygNhMIWy4/ftEE/myAufUfXeskWIB+oLqzJOCQ3UyZlSh6Yd9N9QbFOYm2qP2/7CCGtvoPWv3Ey+C15gIxjTIYBNcmKyQiQy0V683+21a2o9DBl9RNDbYzvUXuVRR1tJdKamcC+7FrNaF7NgjgVIO99GWZUSqeWUEKQhZlWGL9YFSmpKzXEIDkcD4vbVhUqGE1ATagDo8VoP/FL0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 DS0PR11MB7788.namprd11.prod.outlook.com (2603:10b6:8:f5::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8792.34; Wed, 4 Jun 2025 02:15:28 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8813.018; Wed, 4 Jun 2025
 02:15:28 +0000
Message-ID: <917b478e-14f3-437f-a748-0fdf423e9db7@intel.com>
Date: Wed, 4 Jun 2025 10:15:21 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH] nVMX: Fix testing failure for canonical
 checks when forced emulation is not available
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>,
	<kvm@vger.kernel.org>
References: <20250523090848.16133-1-chenyi.qiang@intel.com>
 <aD-DNn6ZnAAK4TmH@google.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <aD-DNn6ZnAAK4TmH@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0054.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::23)
 To DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|DS0PR11MB7788:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fa2039a-29e6-43a7-e08d-08dda30dac7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Umx4R1JoVy9oeVQrcDhsUEp6ejZwNXZnNDNTU2Nxd3BFakhYdVNJREV0R0My?=
 =?utf-8?B?WEV0RGxTRVBjMzZvZ1hBa1MyNWlXbk54WVI1NG5mY0I0ZWp0UTFaamc2eS84?=
 =?utf-8?B?Q05ONzJLa2FWVXYyTjRiZE1ZSkdjZGVrQkRkWWdTbTdGQW1ZVGdJdkkrWWNC?=
 =?utf-8?B?K3pndVJuM3F2aFdxam5SZCtabWwzdWNsRnhwSWJxeDg0bXFCN0hsSUUvdE9u?=
 =?utf-8?B?VnhlNUhESlFkOTlQUjBmMjI5WTVKQU9WYkVtd0NQbkFHc1NvZCszQWNwUGtu?=
 =?utf-8?B?cDJodjlQbm0wYW9rUmV5TVprUU4zTDdEaFdLSDhwWk1hQXhtbFdxekpKTDVh?=
 =?utf-8?B?eVlWMkVaaTRuWG93NHlyenJTczkxd0FUZmVGc0dKVm1LRCtVeUNIRlIwcjNm?=
 =?utf-8?B?R0xlaFpFdlFNL2lVekl6Y3U3ZEN5cnM3RTEzSUtVb0UvNWFJNkNTNWVlUlZs?=
 =?utf-8?B?SE9GSDhjUnVnWnI2b0U3a2ZFbEVKdm5IUFJrdEltVFB2dHhjMkdobDZyT0NN?=
 =?utf-8?B?aVJ4Ry9jWnZUU01TZDFuSTEvYUhsS25pQ0VMTThFTVY0YThZVDRic3lBaldX?=
 =?utf-8?B?Yk9sNXBiNFBQRHI5dTJRNW5qQmR4aVNxZVJPNFRGT21GZjYrUkNBeXFKR1BF?=
 =?utf-8?B?VGpJMmY0Q01mOWNXc1B1YVk2K2lyN3hyc0lndHZDb1hCT3pIV0dOUlp4d2l5?=
 =?utf-8?B?dUhFcS9SZFovaXNGMFhjSnkrNGtXSUJrVVhkZU1tc3drTCsyQ0lMNmZOYXg0?=
 =?utf-8?B?WWtpbm5uQWRkVlo2dm44a0crYk95RjI5S2RkUjVpTHppTDFKdm5zTEJmV2d3?=
 =?utf-8?B?L2VDYllWWkw0OHdhSmVuV3RCNXpPc2kvVkJOT0dwd3d3QVBUaTlFLzBoMTJo?=
 =?utf-8?B?WE9OZHhNaS9OU0p4ZStBSzlQOEszV0llSE95RjJOTk83Q3hDdC85QkoxR2c0?=
 =?utf-8?B?ZnE5ZXBEQVZpRUxxZm5IUWZkS2hpSXcrb3VSTFdTZEVHazdDVFZLK2FaOW5I?=
 =?utf-8?B?NElmTkcxd1o0cXFrWWhFTm1jakt3YVRLN3JiOEl6RlBnSkVlRXpmVkRZb0tO?=
 =?utf-8?B?VXdoVmpRL2VKUnpWc2F6UXRkRFBVak1IdWk4S3hDNnlJMlVkNm9OdkFjWWxl?=
 =?utf-8?B?eE5nckdxUVJGUi9FY2ZsZy9pTHZhL09XTkNoaUlmWG83OW80UFdIVitWZmJM?=
 =?utf-8?B?cEZmcFQ4b3lEbmJzOUhjSlpnZUxaLzdUaHEwR1B6bEphdXNpRlRieHlUN2Ry?=
 =?utf-8?B?VGM3UUVqTytYV2djbnR0TGJEcnc4UjVFNi9UR09FVmovQVZTUDFYb2xnNElX?=
 =?utf-8?B?N2ZUejhFaEtGSnJweFNvNTlMMGxEWE9rY0ZPTjduM1NKWXlSZGI4eWw4eFhx?=
 =?utf-8?B?cVFVVVk3YS9Gd3ZhNlVPSUlMSHcyYnczT1UrVkk4WUVFM1hvNUJ2UGxNSTFt?=
 =?utf-8?B?ZVFjUVRjS294Rk51NGJ0ZFdybGpLdjJxRlBUTHdpaXdNbXlJVE1UbFBSTG9j?=
 =?utf-8?B?dDhTZ1k2SnJFTVVNZ1BGVjZGVllKKzFJV0YrVDBLd1JwbzEyMWhsbkd2bUE3?=
 =?utf-8?B?c0RwNXFOMzNGNzVHb0t0N0M3WlJ6Q1c0d2kxdFlHWm1PRmVqRnRuUktrNUFy?=
 =?utf-8?B?UXo4NWFhV2JMUDRNMjJDWTNDOGIxQmsvdkRrd1k4K2dJN1d1SDJCRGpTYXlj?=
 =?utf-8?B?bU15bEtZY3RDV2RDWXFrU1MzbStBbm9TM2MzbXV1c25kS29QM1dFSm43UUZN?=
 =?utf-8?B?WmtBSWltTlg0SFI0Y1VEUDZqTnhSM2wvN0xBWUgvSE9KSGdvNldDbnpKT1ZE?=
 =?utf-8?B?RDhBYXRXR3dGcVY5L3NVejZZRlpaQTRSRVFNN1RtaW9XMVpQZk9wTmZnRkxz?=
 =?utf-8?B?QkFPTW5iZEM5QVVTY1AwVU5ubU85YzNNWUZNMlZnUEpuMU1LdmI3QXRsOEtN?=
 =?utf-8?Q?Hsg9X0shY6I=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OWFrMDR0U1lJVDVLNVRTNFdOL055dzljRjlyRmdJRzB3V2J4eURnQjEyVGxE?=
 =?utf-8?B?OUE1ZEZBakg5N2dpeGlraDF3ekNTcGZyZDgxUUlsRFN0S2M0ejVsSytqOCtW?=
 =?utf-8?B?eVdnMC9JcG9EaEZuQVpYUDZkZmJxZkRIOTN3VHBkYS9RcGpINFRUQU9aRVN3?=
 =?utf-8?B?TERWcmF1WmhvaWdJUHo0a0c2M3NkNmo0QXlZODNJdXNmU0xFQWt3TnF4enRN?=
 =?utf-8?B?amlmdC9aRVZDQzhEUW1BSXEwUXQ3emFZdmIwcGNWcHQ2VXZxenhTZTR6ZEFK?=
 =?utf-8?B?OUJDeHNqZEhFNEt3ZkpuRWVVbGJwOEFOaWVMN2FiM2JENU40MWxRUmM4R2Jp?=
 =?utf-8?B?Vk9BZG13aE0wVk81WXFkQ0ovdWIzdkhzejJGNzBvb0dDR1N5N2drcUxlV1NG?=
 =?utf-8?B?Q3BtSDdxNmlZdmtIL2NPNEdqMXpqZWN6OXJVZEhpSzg5R3IxeFVxWDUxcGp2?=
 =?utf-8?B?K241b0pvQ3pxZDJoR3BYNXExRGFLOXBNcTBZT292WDlaNUVQZTBlbU9wR2NY?=
 =?utf-8?B?T2ZKNzBJMGkvUW1zUkpjRk82UFd3Q3FZYVk5T3ZyNU5tb1Y2cmFTdm1ETHc0?=
 =?utf-8?B?SXpWd25yeHh6S0NwZnJ2NUtmcUNiY1VyOWlTZ0h2Q1VOTmM0dzJCeUZIVXMx?=
 =?utf-8?B?TXI0M09TL2JDb3BGSmc5R0g5eHNiMnlWNzkvcVRISWttaGdpTVA4UE1vYnlz?=
 =?utf-8?B?SlV4UmczaW1RSkxDTUdEZ0lIb0dOK2laOWRpaUUyeVA0Y1lmcW1vTEwwSnRJ?=
 =?utf-8?B?TXdocXBwaVdTVWt6aWMvb0NLbmRMajkxenNDSkZOSmN2VmQ2aXN3RHFiSW5l?=
 =?utf-8?B?YjJkazdxMkpMRGhTV0FqY2NuRVNybnVBNnhUVjd6WFZzeVJMYVMxUG5PTFdh?=
 =?utf-8?B?Si9rR3B3eDRQUlphc09sRlhyK0NJdGJDMy95bmU2TDh5NUNrc2UzTmhqVm9w?=
 =?utf-8?B?aFVvT0dEYlZBOGFxSnd6MnltSDUxRTFZZDc3c2FMb29OM3YxQnRwUDE2OUhO?=
 =?utf-8?B?UEZqZDlFdEtxNU9pQ3AvZHZkSEhQMnRDZEVMZmJNV1V3WWZ5TFhzR2dxSUkv?=
 =?utf-8?B?ZW55RXp4U2ZuUVlZQzdKTWozcDRaSUZEZ3lWaGlYVEpZR0I1K0hDRzZBeW41?=
 =?utf-8?B?UFJYL2RXMWp0UlRZM1NId0k3UFlMb0paeDlnYlZxQlV0ODFwaDFOcmJmK1dv?=
 =?utf-8?B?L2Q2SEloaEVxNjVXdGx4NGxRTFVrbEZ6cFZOU1RQYXhKN21aenpOUmJhdkVz?=
 =?utf-8?B?YlRQWS9na25TUmRQczFkV1U2am43d2plODFtcU0zZGhyNFM0eWhGblRwNFVo?=
 =?utf-8?B?aGFOekdTUWwvT0xmV1paekZxVlBtN2IwVnM2N29DaUF3anBMOVFqckRyNFQy?=
 =?utf-8?B?dFY3QmNvZUpxOTRUdkZrdjlOeDUwRmx4T0F4Z1FsSEF4TjV5RHJyd3ZFR0s1?=
 =?utf-8?B?YkJEMS9FRGcvRnFiWVdpelpUV1hYZkphZHJoeG1Sck1yY0dxbGlmZVJ0YjdP?=
 =?utf-8?B?TGNuOTlpZFhmQndnQkxFNmFyTGxPcnRpYUVnV1Mvb3hFUUlRR3JvUVprYU5u?=
 =?utf-8?B?ZlZra25QMk1CdEhyUnpEczJXVTlSSm44TzFJeFJlM0ZVcGI3YmhIYUt5N0tQ?=
 =?utf-8?B?cEhXNVptU1lvUVZYc25RUFF5ei9FbUxkM3Zpa0xhcGtSVWwrRTVKdXNJTTRo?=
 =?utf-8?B?bzR2REszYzZxSG15ZmxUSjdrcEZScC9qQkhVQUF5TEhmYlBDRFd4aDdjY3p0?=
 =?utf-8?B?dXBGL3lGSGlKSHBxMjN3L1Q4WEJTOUdtTGszU3V3czVtQ1BBM1VjWHluN1Za?=
 =?utf-8?B?bUdCZ3ZpYU1hNDBmUFZSR3hFMGdWcHllU2QwUUE4SDdYb3dqN29rLzhIaGNM?=
 =?utf-8?B?ajNVcFk1QkdJRlRtdUlFNmxzU1NvR25tV1Q4aktqMDk2b2o4NUJJWm5RNjc1?=
 =?utf-8?B?d0Z2SHIweVF5c010RkhyeWpGTy9BVmMzc0Z3MmZXSUNGVjJadHVwUitJaUhK?=
 =?utf-8?B?VEczWU5LWUhrcklXMzl6ZGhvTGFXRG9FeldoYm5OR1crYjhRMjJ0MzdSUmgy?=
 =?utf-8?B?b2t2eWkvcHMwSmZranpXNkVFcWVsdG03MFpDQjJOaDk1bXdyWnE5clE0em5v?=
 =?utf-8?B?bUxHM2NtQkxNVXB6WFdycGZscDZUcTBrODluYUxPZTZWWlIzMk0zRkYrRzBI?=
 =?utf-8?B?aGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fa2039a-29e6-43a7-e08d-08dda30dac7a
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 02:15:28.1551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5PJvJRoXwidLMX8CueNtyUOodvBxZCdXCEtDgRIqPPcHFyxYd7T29OaabNVr8LtVfUDR7aU9LbjYIxufWoajrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7788
X-OriginatorOrg: intel.com



On 6/4/2025 7:20 AM, Sean Christopherson wrote:
> On Fri, May 23, 2025, Chenyi Qiang wrote:
>> Use the _safe() variant instead of _fep_safe() to avoid failure if the
>> forced emulated is not available.
>>
>> Fixes: 05fbb364b5b2 ("nVMX: add a test for canonical checks of various host state vmcs12 fields")
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>>  x86/vmx_tests.c | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>> index 2f178227..01a15b7c 100644
>> --- a/x86/vmx_tests.c
>> +++ b/x86/vmx_tests.c
>> @@ -10881,12 +10881,11 @@ static int set_host_value(u64 vmcs_field, u64 value)
>>  	case HOST_BASE_GDTR:
>>  		sgdt(&dt_ptr);
>>  		dt_ptr.base = value;
>> -		lgdt(&dt_ptr);
>> -		return lgdt_fep_safe(&dt_ptr);
>> +		return lgdt_safe(&dt_ptr);
>>  	case HOST_BASE_IDTR:
>>  		sidt(&dt_ptr);
>>  		dt_ptr.base = value;
>> -		return lidt_fep_safe(&dt_ptr);
>> +		return lidt_safe(&dt_ptr);
> 
> Hmm, the main purpose of this particular test is to verify KVM's emulation of the
> canonical checks, so it probably makes sense to force emulation when possible.
> 
> It's not the most performant approach, but how about this?
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 2f178227..fe53e989 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -10881,12 +10881,13 @@ static int set_host_value(u64 vmcs_field, u64 value)
>         case HOST_BASE_GDTR:
>                 sgdt(&dt_ptr);
>                 dt_ptr.base = value;
> -               lgdt(&dt_ptr);
> -               return lgdt_fep_safe(&dt_ptr);
> +               return is_fep_available() ? lgdt_fep_safe(&dt_ptr) :
> +                                           lgdt_safe(&dt_ptr);
>         case HOST_BASE_IDTR:
>                 sidt(&dt_ptr);
>                 dt_ptr.base = value;
> -               return lidt_fep_safe(&dt_ptr);
> +               return is_fep_available() ? lidt_fep_safe(&dt_ptr) :
> +                                           lidt_safe(&dt_ptr);
>         case HOST_BASE_TR:
>                 /* Set the base and clear the busy bit */
>                 set_gdt_entry(FIRST_SPARE_SEL, value, 0x200, 0x89, 0);

The call of is_fep_available() itself will trigger the #UD exception:

Unhandled cpu exception 6 #UD at ip 000000000040efb5
error_code=0000      rflags=00010097      cs=00000008
rax=0000000000000000 rcx=00000000c0000101 rdx=000000000042d220
rbx=0000000000006c0c
rbp=000000000073bed0 rsi=ff45454545000000 rdi=0000000000000006
 r8=000000000043836e  r9=00000000000003f8 r10=000000000000000d
r11=00000000000071ba
r12=0000000000436daa r13=0000000000006c0c r14=000000000042d220
r15=0000000000420078
cr0=0000000080010031 cr2=ffffffffffffb000 cr3=0000000001007000
cr4=0000000000042020
cr8=0000000000000000
        STACK: @40efb5 40f0e9 40ff56 402039 403f11 4001bd

Maybe the result of is_fep_available() needs to be passed in from main()
function in some way instead of checking it in guest code.



