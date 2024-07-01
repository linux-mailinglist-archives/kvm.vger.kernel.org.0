Return-Path: <kvm+bounces-20751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 09C5091D77D
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 07:40:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 711751F22AD1
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 05:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BB3D3770D;
	Mon,  1 Jul 2024 05:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aK+wUVOi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21A42F34;
	Mon,  1 Jul 2024 05:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719812411; cv=fail; b=bnxTDsDRe9V0rO6iMm6n85gG+/k5EZOc7E7lk2N8rC7/LBxYcl8myYhveJ9Y79lbupUcEGla7lD7EAYlJ+sTVT5JLuHUeShOjCVzOCfWvWiAmIH4hdVvliUoAr+5XpmkqTWJO8gmwGZJuY9thFYc8IWqLZVzqy7bNH5C/LFITrA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719812411; c=relaxed/simple;
	bh=/rcXpoyB0yp4pieUtJs8LagrLzbP1QcxyJPD74fTn9o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oKmHt+0EenKjYhfeEYY5lIyck4vq7a08pNlYbjTCY9McSeADIwa4OPB2rskwFCBEI5N3TxT0MrgUJFLnrvokmL+5+DE+BfCp5qj6TMWEbTb1vrFQd46xXetpoPitszWhITzxDfKOqfnxhKBfRfbKV/flowycHMVuVf5caeQgwyc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aK+wUVOi; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719812410; x=1751348410;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/rcXpoyB0yp4pieUtJs8LagrLzbP1QcxyJPD74fTn9o=;
  b=aK+wUVOi6tqDKDsj4/lrh7FLQffIsExIDC4BtuYqJuTbaisJq2g5guU5
   s44nUqoSjlAq5+9dLKM6Z0efAPZhJqTwVqcVi7WrM7Jcm5Cu0FS7+RVUV
   x5565vqvPIpC6TcmEXAS1RWSK3/EPMEu8GGHI+tPkTs6gD8X+R/XSAg74
   Azpf2HgrDHAjFNb7YVDj8+gAFOgAVJPbMeRWrb41LeJiQ/GJFMETHPgD0
   2W7Gm3vbBkG8p94T1nbce+RKtNRK4X/ws4tMr/mRSUfoHOb4rIPbFj9R1
   i18tM6xEOFA9eC/7xYc6u0RKzt1BjdzD4fyS0xquXQL+RK3KrBoKK77eq
   g==;
X-CSE-ConnectionGUID: VeY5CY4ZT4ygdOA8th98oQ==
X-CSE-MsgGUID: l+AmqwDpSA++WfHGmlWepw==
X-IronPort-AV: E=McAfee;i="6700,10204,11119"; a="17053542"
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="17053542"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2024 22:40:09 -0700
X-CSE-ConnectionGUID: t7mvbbafQEmmP9vC+tpmPg==
X-CSE-MsgGUID: b1Pey2MqSPOqPSqVZNLz4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="49988450"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Jun 2024 22:40:08 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 30 Jun 2024 22:40:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 30 Jun 2024 22:40:08 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 30 Jun 2024 22:40:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KA8lczLBZOiAwaeajdJpjZoBJrMdg19BfmSH2xFBsiJW5CbN+ikejSuxrNXbkpK71IM42jeAEUj0cN4SD6Wx/Mg6ma3NXDKrBhrZpjceNeLBBSuYUK7Fyp+7miYtakKZ8wsSbTGyzBUmWCGpI0c7WJ5cHMtgBg978AEqEecZhpbFO7ph9/cOMLWM++iimmKjJXFlRU/pLAr8w36JdAwTqECh1lmpOBn9c5aV9zFjgBEOeo+P/favZYM65rusyz/ih/zDx850N1jCEm/jD5U3suNmdkxd3fsKbP9SB7bMUOxU7h+bAWNDT3a5rVWjN/ls0WeKlWesjUDtjCWP14CnNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZX7lWmVX8Ldb61Tzs/W6WfeU2mxz34TjP3XUizUAWHM=;
 b=gidRwYTCjQ/AlKlqlnY9iZsFyMZU/0BSQLqbMqjme4knRrI8daKAdg4Vq4q68tQCzLEdrJz/SnapB5EZ1fq63+A/imsjmZ1veKS4IdYx5niuhboPfjsfRSSJgfN1qlWSVYmuRGieb4nK/bvb+V+G6odmd1qYA1MYsGVoPfluUMLSwwmxjBtwZYOA+5zuv5iI2TFluU5/RRWpBm1hV4uwsy5przOH/byPTBQKHVbG5v19zmPiQ/IgWlXxkRYZ/wLRr10MmAphW2wgefVYUeeeWZXHEEgqJJ6wgd80OciSg9XZCsuJc+8V6zm9tahkPrwRhg12G1gCQ/19yT6oxHKR6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BY1PR11MB8008.namprd11.prod.outlook.com (2603:10b6:a03:534::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.28; Mon, 1 Jul
 2024 05:40:05 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7719.022; Mon, 1 Jul 2024
 05:40:05 +0000
Message-ID: <e568a45a-4e1d-4477-ac10-103cd605eff3@intel.com>
Date: Mon, 1 Jul 2024 13:44:01 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio: Reuse file f_inode as vfio device inode
To: Yan Zhao <yan.y.zhao@intel.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "peterx@redhat.com" <peterx@redhat.com>,
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>
References: <20240617095332.30543-1-yan.y.zhao@intel.com>
 <20240626133528.GE2494510@nvidia.com>
 <BN9PR11MB5276407FF3276B2D9C2D85798CD72@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Zn02BUdJ7kvOg6Vw@yzhao56-desk.sh.intel.com>
 <20240627124209.GK2494510@nvidia.com>
 <Zn5IVqVsM/ehfRbv@yzhao56-desk.sh.intel.com>
 <cba9e18a-3add-4fd1-89ad-bb5d0fc521e4@intel.com>
 <Zn7WofbKsjhlN41U@yzhao56-desk.sh.intel.com>
 <f588f627-2593-4e89-ae13-df9bb64143c4@intel.com>
 <ZoIKwAhOkgkTYtyf@yzhao56-desk.sh.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <ZoIKwAhOkgkTYtyf@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0006.apcprd06.prod.outlook.com
 (2603:1096:4:186::19) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|BY1PR11MB8008:EE_
X-MS-Office365-Filtering-Correlation-Id: 777c171e-4c9e-4f16-f415-08dc9990427f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aWp6RHY0by9lMmJaUFFDZ0pQWHo5SThaSU9lSm9hMHdIdlRBbkhLWmNJdE9l?=
 =?utf-8?B?M2xLSHRDeHhJK3VCajRrcjFPUzZPK3VMOXBOQ21ybzhpT09SeSszV1dML2J4?=
 =?utf-8?B?K2lPU3V1WEJQc2xubUF1N1FKNldzTG5OT3hIMTUwc2Y4ODM5L2lYeE9pREwv?=
 =?utf-8?B?N3IxMk9GOUE1Rno3NjErcGFJRFBCV1lJZE53emFEd2t4SlJPVTd2Y0l2Wmdx?=
 =?utf-8?B?U3daSzhod1lCdkhKVEQ4K28reWlHbG02STBscEtib3hrSGFFRU9jNld6cFBB?=
 =?utf-8?B?WGVMQnREK1NRa2xzTDJEcUk1MWVONVdRZGFOVDAxK2c2bU52NGdYOVRzMStW?=
 =?utf-8?B?YkNNRk5IeDRuVERGZ2FpVWRKWU5MTWdsY3BoV1JsNjlneDBNVDFFTW11T0Zz?=
 =?utf-8?B?Mkoxd08xcFVGbXdXV3BMT3F2RE5nV3Z3OE1remczcVMzOHJSeWpVOHV0MW1l?=
 =?utf-8?B?MStDdkNwZyttTEwxMkI0QjUrRVRvdG90RTA4T0tPOXFVZEQxaVRsSVBZTnFT?=
 =?utf-8?B?eldLdmxNcFptZ3AwckVKQnVkclRnUTcyUXp3VFgyWExRb1l6aU5SeTFoTlk2?=
 =?utf-8?B?ZHpwdWdZWmVaT25JZmxtZVlyWEtkanUzM01xa1lPUnlPSklpYjNFT2ZDd3lV?=
 =?utf-8?B?RC9ONWhBRDQwS05qczJjbmJrUjdoTHNSbjZ6MUc0QTl1eGZyOXE5cVNGeHNs?=
 =?utf-8?B?c0NkMXJaZG5CZVNVZlU2Q3NHcDgwZ0c5TXZzQVlTdFhTWDByT0FKbWJTaTdB?=
 =?utf-8?B?YkROU0tpOU9qRXFsMkpKc1JuYVN3OWszYVJrZlBiY09yNGJON2ZZdDFBakZ0?=
 =?utf-8?B?eU9nR2dZT2RrTmQ2M1p4T3ROMFI0MXVjbUVjVWtkVUlrNHY5LzZPcU8ybnZt?=
 =?utf-8?B?NjVWSnA4MmEvQThwRUhOV1MxaXRiNUttZ3pUSHdQSDh4d2JvWnFBKytYbUZ3?=
 =?utf-8?B?SmRyMjZzdXBVUVR0OUwwYkJUOENSODVsT2ExbnVkWEQraTM0R2taeUMrcUNO?=
 =?utf-8?B?bWNpcyt1ZEJqWElQOTJsQ3EzWEFTVXBWV3c3dTZLZlV3cUpPb0pMNUFlaVp6?=
 =?utf-8?B?R1haZlkzRGpKbm5LaldNd0tFMkJYdzFtTENzcTc5YmJNRkR3ZUVoYS9KcjdW?=
 =?utf-8?B?L0pMamt5djcvVHFUNWVvakhVczVmOWFROVBBZ2tNWW53YlZIODZQaWxCZ2RM?=
 =?utf-8?B?Z0tSdFZWY3JOSlJPTE1NY0NSdCtyTjJ0SUFZcEJRcXg0YUJ2UXJtVlFYUWtt?=
 =?utf-8?B?RkxJaVNPb1YvMHhvSEtmbFBBNysrSHpobzdRcGFTa2ZUUVUzUmw2eU03WXdE?=
 =?utf-8?B?ZW5aMmtzek96MTh5RXR3SjE4cjhXcjVldWVhMllUZERkUWVCejkrQ3YrZm84?=
 =?utf-8?B?Wk1tVUFXSFlsZi94cHlFdmJYcW9DR3o0UzRjd0EzWGdqNndudHAwRDRXZDFN?=
 =?utf-8?B?S3VrYWIxRUxlWWRsRXA1Wk9XYU9LUjNtaVFSS2sxOFdCVy83azY2ZW90VWdu?=
 =?utf-8?B?VkJKRlFMUncrVXVYUWp1RGJrWkdEOXRMMElFQkZrU0JYOTB4ZTl1Q1VCY1Ez?=
 =?utf-8?B?aTh6UTZKYVA5MnZvUUtvRE5Vait6Qk5zaUM2NWc1ZDFzbXN1WW0vVzdVZXkx?=
 =?utf-8?B?QzJzUlpqSzM2YzhPdUhzcUtCdEppc2lkakt6eW9NYTRXeDExTFJFUFFJK1Zh?=
 =?utf-8?B?RzV6aVQ2VHdiaW1lS3czMHUzQUdmNk1IK0RkZVhwem04Unh6NWZadUpOSFBW?=
 =?utf-8?B?dWdTTWtuQmdqTTV1MzJiR3lFUUdVZGptbE01ckcwNEZLOTFJUWdSekpJRWUw?=
 =?utf-8?B?UXN6SFFSTWE0N1cwM1Q5UT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVplbExucjJEUzg4bTJIVWp3NWRGVTJiZ0VQZGxPSUVpK2R6M3BqeXlUQTFP?=
 =?utf-8?B?OHEzS1UvNkpUQUNxeGl6QUxSUUNySmJIQmxIWkUzMGNrUVcwYkZMUVQzWmx1?=
 =?utf-8?B?ZVdXMGlMRTBVUG16WW5XaXFKdnBzOTdVR1JOa1c5NTZscWljNWpKMk1qektx?=
 =?utf-8?B?QmZKaUxZc3A0VDhnaU9zYVhSbFlmcWRBT1cwS1FCeUtSTVBWOHorN0FHdEUr?=
 =?utf-8?B?ZXNSL3V3SU1Fb1pIdkpNZ0hkVHV4T1JUMk5OL3B3b1F0Q2E1YVM4OHFFamtW?=
 =?utf-8?B?cGM0R1R5dkYzL2hEbmsreU8zYjJTRzh6aWx4V0VCdmt4azdlYU12RmxRZ2sw?=
 =?utf-8?B?cE1sdERqVHliZHZMSXo0RXJodkRIR1N1S0V4blhpYk5tTW1UVkl5VXdadENW?=
 =?utf-8?B?SEtnMWpEa1JuaElaWjJoTlgvMTBTelVmeExEOE5TMnB0d2xaeE9Xb25WWEVR?=
 =?utf-8?B?T2pqVmthNHU5bFBSWVlGL0ZhcmxxOVExSmJiazkwY0dVRFZPeC8yck1xSVVH?=
 =?utf-8?B?RkZQekl4UENEOXE4blNwc1lkdnd6bUZwSnFkYmJFS1NlSU1wRCtBU3hDVkFQ?=
 =?utf-8?B?MVV1cGdKaEhjeXBKS3VQRVUxZy9wV3dGZlQzWHl1V1FQUUs3cUYzdTcyK1M0?=
 =?utf-8?B?R3JSL0hvU1pYdjRpS2tlbTQwSDUwcmF2dGZtYkZsTjBiT1BwaEtLQWlPS3RN?=
 =?utf-8?B?WWhIbGRCa2h4UEFCK1JOSzVOckZNRzViNlc1TEVTRmhzQXF3SlNyR3Jhcm53?=
 =?utf-8?B?Q2RDR1dVZEROdnVUNmNlSCtNMEJ1dVNRT1piRDlXSU1iMWZLZ21lZkt5LzJo?=
 =?utf-8?B?UzFrOTdpdFAwZG9LOUdSZXppaGlFaGlGTHQzVmx0UWh5RlZ5S0x2RnZUMkxF?=
 =?utf-8?B?T0xNTGFOOGZjY3ZjZWdPSHlMNTVLOVNROE1QaEJMb3pZb3g2aVJUeEY5NlBz?=
 =?utf-8?B?SFQwc2hSUEFBc2lETkl1V0RhUmlhck5lTGhkSEp6Wko4YklCVnJMM3M3SVRD?=
 =?utf-8?B?N2RNUHJ6ZVRKTk90Vlh0OCtiZTdJVEhoY1MvL2xSWlhlMElNcDVxQ21ITnNG?=
 =?utf-8?B?ZHlvUHozbHlmUVBOaGcrOW1ZU2tSR0NjS1kvSU9CNnpRU2lGM3F4dHhFRk5W?=
 =?utf-8?B?NklMQjlWL21vNlZiODJleVhjZDI3NEkwcFhmc2tXdHpqWGNldE1XM25haklp?=
 =?utf-8?B?bVVoZlNEUHpweGZJaXdaNVBPalB4dXo2d0owd2Zad1ZnZS9ja1hJa1dBUjND?=
 =?utf-8?B?WDhUalNPSUo4amllZlRpcTgrNWhOWTdMYzBBa0ExbVMra0V0VkcxREFRbSs2?=
 =?utf-8?B?N1NRVTFWbHArY3pSVGxxWEd0bnRPMzFDL21BY3JSdm9pWUNFRzE5Y1lESFZq?=
 =?utf-8?B?TDVJeTg2dllsR3RlWFlOaXNvRnpLNlBKNitNdDVlK1FUcjlMTlY4TGVJUGV0?=
 =?utf-8?B?SzE1bW5WbC9CL3R5NTJSM0xJZytpRFR6NE11Y1NUR01XR1poWE40MWtrRWFx?=
 =?utf-8?B?dDRwcVgwOHliTkx0VE1Rc0s0RjVHeDdCS2xuWDhSUGViSzZTQjRTZ3JsNEg5?=
 =?utf-8?B?NU0xWEo2OHl2cnpXVjA5ZDNNQzZkM1BpSWxEZlFJL05ucEpUczZ6N2tJMWlu?=
 =?utf-8?B?T3lNUGhORXNmSFh6VFdSNkZoY3VYTzk3ZlIxa2NQczhuNHI1aG9UMmNOVVR1?=
 =?utf-8?B?STUremFKd1NJYmw0V29vL3ZhL214ZzdybndMQU4vTnlwUlNra0JsMkdScUlT?=
 =?utf-8?B?anJWL2k1Zk1pTDdLVXNNNHdadFpKaXZJUjdkQWJKb2dFUDUrQk1NRWNkdmhn?=
 =?utf-8?B?YnowVFdjYk5HbDgwNGNRaGVqeWEwbG10SU5yRExkdGFtOXZkY0ovVUE4UGwx?=
 =?utf-8?B?OSszNXErdmg1SlBhUmxwQ1hWbmlQNzdSdmQxSkFPRjFaeFJMK1ZzWkdjUjE0?=
 =?utf-8?B?MEdBSGwrUnhiNHBpZUkzLzJiN0RPM05IWnNxdUxKaThjZmtvbXNac1VnYUsw?=
 =?utf-8?B?MFU4a0EyZHI1cHNyQVlGSGp5VHNUdzdoNGpCZGE1OE9HcVJnRGg4WEVFamFh?=
 =?utf-8?B?cTlTL0ZJVzNPaUw2K3ZZNVdjL29LSGpOQjA4RDhYUGNoZXIyK0VYTDFrWmtn?=
 =?utf-8?Q?iXPdhJKpozzjI0VK2VJI9ANJS?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 777c171e-4c9e-4f16-f415-08dc9990427f
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2024 05:40:05.2619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ca2h5b4+CJv51Ydu8wRLTA+1/G05Fth9ElBFn6LS0V0b8cMSD+YtPi5HDEj5w2bvpy42r4krpN5YTqOnlpCDIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8008
X-OriginatorOrg: intel.com

On 2024/7/1 09:47, Yan Zhao wrote:
> On Sun, Jun 30, 2024 at 03:06:05PM +0800, Yi Liu wrote:
>> On 2024/6/28 23:28, Yan Zhao wrote:
>>> On Fri, Jun 28, 2024 at 05:48:11PM +0800, Yi Liu wrote:
>>>> On 2024/6/28 13:21, Yan Zhao wrote:
>>>>> On Thu, Jun 27, 2024 at 09:42:09AM -0300, Jason Gunthorpe wrote:
>>>>>> On Thu, Jun 27, 2024 at 05:51:01PM +0800, Yan Zhao wrote:
>>>>>>
>>>>>>>>>> This doesn't seem right.. There is only one device but multiple file
>>>>>>>>>> can be opened on that device.
>>>>>>> Maybe we can put this assignment to vfio_df_ioctl_bind_iommufd() after
>>>>>>> vfio_df_open() makes sure device->open_count is 1.
>>>>>>
>>>>>> Yeah, that seems better.
>>>>>>
>>>>>> Logically it would be best if all places set the inode once the
>>>>>> inode/FD has been made to be the one and only way to access it.
>>>>> For group path, I'm afraid there's no such a place ensuring only one active fd
>>>>> in kernel.
>>>>> I tried modifying QEMU to allow two openings and two assignments of the same
>>>>> device. It works and appears to guest that there were 2 devices, though this
>>>>> ultimately leads to device malfunctions in guest.
>>>>>
>>>>>>> BTW, in group path, what's the benefit of allowing multiple open of device?
>>>>>>
>>>>>> I don't know, the thing that opened the first FD can just dup it, no
>>>>>> idea why two different FDs would be useful. It is something we removed
>>>>>> in the cdev flow
>>>>>>
>>>>> Thanks. However, from the code, it reads like a drawback of the cdev flow :)
>>>>> I don't understand why the group path is secure though.
>>>>>
>>>>>            /*
>>>>>             * Only the group path allows the device to be opened multiple
>>>>>             * times.  The device cdev path doesn't have a secure way for it.
>>>>>             */
>>>>>            if (device->open_count != 0 && !df->group)
>>>>>                    return -EINVAL;
>>>>>
>>>>>
>>>>
>>>> The group path only allow single group open, so the device FDs retrieved
>>>> via the group is just within the opener of the group. This secure is built
>>>> on top of single open of group.
>>> What if the group is opened for only once but VFIO_GROUP_GET_DEVICE_FD
>>> ioctl is called for multiple times?
>>
>> this should happen within the process context that has opened the group. it
>> should be safe, and that would be tracked by the open_count.
> Thanks for explanation.
> 
> Even within a single process, for the group path, it appears that accesses to
> the multiple opened device fds still require proper synchronization.

this is for sure as they are accessing the same device.

> With proper synchronizations, for cdev path, accesses from different processes
> can still function correctly.
> Additionally, the group fd can also be passed to another process, allowing
> device fds to be acquired and accessed from a different process.

I think the secure boundary is within a process. If there are multiple
processes accessing a single device, then the boundary is broken.

> On the other hand, cdev path might also support multiple opened fds from a
> single process by checking task gid.
> 
> The device cdev path simply opts not to do that because it is unnecessary, right?

This is part of the reason. The major reason is that the vfio group can be
compiled out. Without the vfio group, it's a bit complicated to ensure all
the devices within the same iommu group been opened by one user. As no
known usage of it, so we didn't explore it very much. Actually, if multiple
FDs are needed, may be dup() is a choice. Do you have such a need?

Regards,
Yi Liu

