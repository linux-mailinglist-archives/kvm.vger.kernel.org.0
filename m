Return-Path: <kvm+bounces-29251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BABBE9A5A77
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 08:36:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB8A71C21126
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 06:36:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A154199EAF;
	Mon, 21 Oct 2024 06:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZfPWd22Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFE1194A49
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 06:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729492559; cv=fail; b=lJqs9X++IcXFc/kW1+ofNPGPmtUsPDo+QoCdhNEtsV0OjqJPhAF4mAiHuUq1jjd6xNKvbWcDMydRthN8+y1lpTi4CTTpD8Hf0N4mbyVJgmjQtk4kvkMTooUuVY2BVjHYJ+KhSGYJFS3CPa7GMlL+k+6fe5sUOi4FO9M2ypLj5to=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729492559; c=relaxed/simple;
	bh=xtkC4GD5NSqSOyFPnYVlsSz8m10THyxzdz/DDqtE+v0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ANaENFdbXy1zXawcTwodMSxnMBmHmPlZmhbgokn//dpPe+o2dK4bt8LpU/nRPKJIEOtSFLackUueydiMpicLhMm319WWmWtyaYbnV9oz90n+oiKzdEJTA7nt7UK37oNRPILcq+SUXvcBOwF+fzh/1o0pZunq9JwkL460NbJBMuM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZfPWd22Z; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729492557; x=1761028557;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xtkC4GD5NSqSOyFPnYVlsSz8m10THyxzdz/DDqtE+v0=;
  b=ZfPWd22Z703mOC06Mks4rFM4Oddxot6tupPHzIt09SyO4b1nSFHmFLd+
   pDgFP5aW77uxO2wB+0FxtVsyiA9F3i5XV2eWqt6GZmW1TwW7WRyXPFIrH
   Q7HS9QCf43JUTjqVustP65xQlo3DIovdZ6EegSR8tmELhcVHQj4PlobW4
   zaERBn4x0iUgMoh2PnxMfZ1X2elh0nJyb9DiX1zBdMHLsGNSAuMD1YoeZ
   E1vXXbmeIKwIwroD79hmcoi23MIgs0lEwEFVRfqrBvidpNXnjt5ZdjPyj
   7PKEz/Rfw3syGLhXJWlRO9vgrKta8ht7RRlIv1YF7bNIVyw9g8nDNgATI
   w==;
X-CSE-ConnectionGUID: 1FnydUiYSJ6jWmp9SnBDxg==
X-CSE-MsgGUID: nKNVHe1nTViOBaKZrqbPoA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28838992"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="28838992"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2024 23:35:56 -0700
X-CSE-ConnectionGUID: TBjdNqHMSki3LeOqh0DtiA==
X-CSE-MsgGUID: dejeqCawSQyZnrywPEzL6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="102740745"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Oct 2024 23:35:55 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 20 Oct 2024 23:35:55 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 20 Oct 2024 23:35:55 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 20 Oct 2024 23:35:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wqrLDsOwZZGx/lGhbcSOA6BjYWrXceQkwPLTC/dK3diZTYG8l0LzPdR898NTXZUbLWnOUTZfY9KXwejmDbB4OuNoII+s0os31nHaTFBX+7A8wFg1OXpqJZ4odg1a1alJSIEjM/YdejUlI2x2hMM0e65z7WoZHHY2MmD/3rbp6NGzqbuoLMB70viwT8lFwCteEycNJfJNnWNlE4E5wuk3JE/ERIGrk36N3GHQB7oeQ6FwsfkRruisSXCvsBQz8z29lOB4lc1MbMvIdsgqj3xxSe5GirvySxkxl8ZF87HYqUhFDeZO7wnRbJxYpA2fbqrgFshiJCPVwroSrDeZvjCrbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hQwS0oDwOA5IiHXik3K394S7cy+AxUXFRKNOyEMK2Vc=;
 b=XVCL+9IZbOiIa4qjEZceOWOw1ANGTMLS7JfK66Ih3CN1uhg8vUh+7GWoFBwCjl61Tee0FKNKWDAPpg0rTP1WKhU5L7S9Sou5/A53jkuuE/gd1u72OVwX6P9DpYyUAs+3w2+cmF41+kWex7Vt/YOl5VACtKOjLqU41UM/vaCdDpVOmp84X79Z62N61DT13Qhb4MROWBUkvvwhl1gb55mv7RwiC8eZzhraffetvRfAe2PdedvadfChg8dspps+GkP1JjK3x87Ik48B0VRSB3kyMoTOSL6RMZv370yWso+Lek/Hyz5D7ZeQHINNNjSz8BbEy3BBF1nfouP1k4gvWiL2DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB7255.namprd11.prod.outlook.com (2603:10b6:8:10d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 06:35:53 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8069.024; Mon, 21 Oct 2024
 06:35:52 +0000
Message-ID: <fd9dbe4c-bac1-419d-9af1-adfa33408a9b@intel.com>
Date: Mon, 21 Oct 2024 14:40:27 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 9/9] iommu: Make set_dev_pasid op support domain
 replacement
To: Baolu Lu <baolu.lu@linux.intel.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>, <will@kernel.org>
CC: <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>
References: <20241018055402.23277-1-yi.l.liu@intel.com>
 <20241018055402.23277-10-yi.l.liu@intel.com>
 <17513727-c2db-4aea-a60a-d9bb8b8ac71c@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <17513727-c2db-4aea-a60a-d9bb8b8ac71c@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1P15301CA0054.APCP153.PROD.OUTLOOK.COM
 (2603:1096:820:3d::8) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DM4PR11MB7255:EE_
X-MS-Office365-Filtering-Correlation-Id: 296a9515-3260-4cdb-b142-08dcf19a9c15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Q2MybXhiVXVBRGd2akVoQnJuZHVMdWhGaWo0a1RlM2M0WCtNNXJteGt0a2o5?=
 =?utf-8?B?R3grWkU3K2o3c3lhRFY2c080MWFnSE94aWphczVyU0Z2VUN5eE5YUTVqdURo?=
 =?utf-8?B?ZGNsL1k0MDBDWnJXY3cxbURiWHprUWtCT2w0VHB5aWtQWHZrWkg0aGFTSlMy?=
 =?utf-8?B?aGFDNDhKbHlXczQ0V2lGV0c1NCtTazQ0TDdER3ZFZW1GUGtjemtwSW40V0pL?=
 =?utf-8?B?ZlNHMktjUUdhQjJJUFNUaHRlbWROSHFBTFJ5RkQyczdDeU80UTNTRWtDWnI5?=
 =?utf-8?B?Ny8vMStId1NnU05Hd2Fkclk0Myt5MzVUQnRaRFFxUHN4Z3ZNdjNwSFRSbEpR?=
 =?utf-8?B?L09OZHlsWUVaQkJCc0VqR1pGRFQrT1p6bEtkeHlVNDdhdGttVHlqcSs2cG5M?=
 =?utf-8?B?ZEhSZjYyU2pDaStrQ1RCVFN2UGFqbExjSWlZSHJNRmxCaUNud0ZaWmtkVWdI?=
 =?utf-8?B?RjJuS1V3Mkg3TkJpSGx3bjUreVR0bmZBMUNSSUhHeEhhQUc0UVBOeFc1eVBs?=
 =?utf-8?B?bXNweHY4OThFdDVNdStNdTZudVl0NkRSSlFTdmRhWXFJMEJEZmRRMCtuMzNy?=
 =?utf-8?B?TUVCNzlOU0krSHlPL1N1UUZqeExsMmdMbG9jUW1OVndKQUJlRldUenUyMXBt?=
 =?utf-8?B?bGVPQW1sQnQyTE9wNGpHK1lqOHNRaHRNZCthNTVLZVdiUkZHUGlzbFU5b1pD?=
 =?utf-8?B?STdqZTZMUWdtTU1Bc0kyeHlnQ0p6SWdIVitOclYxaXUrcXRVV2xYSEd1WDEv?=
 =?utf-8?B?SlNiRmZJRGFmQW51VGZaZEI1RHlqTlBZalllN0FjNkpZZUUweksrT2lXeFhp?=
 =?utf-8?B?enRsWnlzUElmV3o5TU9zS05NOGV6UXB2MytpN1cwWUkvRnZPeWFLeXJYSGZH?=
 =?utf-8?B?dWIxbndvWEZQWVpYelAvZkx4VFpjQ0txVEsvcE91OExGSTVtMStwVEMra1dj?=
 =?utf-8?B?TEZWNTF2WUZOTHovWk5VMjZKK2xPeXc0eUx5aGZuT2tycUR5bFN6WHN2LzZR?=
 =?utf-8?B?S1AyRFk5eUY3S3dmWjJWeEtkem5GTDNkb2xjSjRDZFBPVzhwMEl2TUIyZFQw?=
 =?utf-8?B?eGdwck5raW1GMm5LRnlIbUVGTGltV3dCUHU5czJ3N3hPdmMwMy9KcGV2R1lT?=
 =?utf-8?B?ZTBzWVlXQTZJRk5SVHVuYU5KZGp1SWR0NXB2cVU2LzdQeFRiTFNuVFhDSURF?=
 =?utf-8?B?cy91U2tER21BZ09PaGhYL1hZTjJ2ZVdYTlpwUW5YK3hzeU9vY2dQNldwMVBM?=
 =?utf-8?B?eEYxZ056cTljYXNnL25Hd3VGOGVMSVpmWGtEQ080Z1FQRnVySldvblR1VTdQ?=
 =?utf-8?B?MWthWlZxZ2VmTjBnYk1BUlBZSW41bWFnVVBTSE5xTEF2ZG5UaTNiblRJZ3VJ?=
 =?utf-8?B?dUFveTF4WUh1V3pGd25YdXJVdm9vSlRDQ29LM082WDlONUVTSGtCMGdyd0pt?=
 =?utf-8?B?NUg0bWhJMFFIU09BSkdrMThmdjU3NVUrYTlQRDVCN0NMYktHOGM5d1NyU2JX?=
 =?utf-8?B?UVVqS3k1cVVPK0E1bE1xZDI2Uk1rcXYyVEhjOCsrZ3JQMGNZd0wwZ1kxSER0?=
 =?utf-8?B?QUk4aFUyV2p2N2VvaEtwVXlGN2s5YjRTVElyRU9semptdlZkNnRiUHBLWnpF?=
 =?utf-8?B?TlFpSDR0cEkrWVo4eWJlMkxwN2g5WFlqTWRKbyt3SjFESjROdDZ0L1loMEp4?=
 =?utf-8?B?RURkK1c4QTVkZmZRdXdRb1VRRDBoQXgxVWFkcmRaT3NIaDhIT2lxY2dVVTcy?=
 =?utf-8?Q?SHPUHcvhfHrMQk/aZwkD8LSUG19yLUZ0LYW4Se+?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NlFOMGVYRUl6T2NnSnpXaFRoMFBMS2RnV21ObXcyMG9EQmpXTHZRWGZybERx?=
 =?utf-8?B?bmk5UUE5OEFWVHY3Zmp4bGt5aitraWZ6V2QydzRNTUpOMVFZMzdvRGRUakNZ?=
 =?utf-8?B?dm1YVzJVSHlvSitwMHJMZUFjY0EyeVdWb1lMckc3RDRreTVxU1RPcE1kbFBS?=
 =?utf-8?B?VEhIbFRDbTNUYjVERHZmMGxZOWlScExIeGZHenNERHBhQkVFa0RmQ0E1SEFY?=
 =?utf-8?B?cjJOWkxLU21FWGM3dGpyVnRlcVpnZWg3S3oza3RCamtHN0NmeFp4UUZCMXNS?=
 =?utf-8?B?Tm5vS3Y3RHp4NjVUd0VBYmdYL0k0YUM2UlQrKzFkdXV0cGhpMCs0SVU0RDA0?=
 =?utf-8?B?dzI3Vk4yRHg5SUs2aHUxR21yRzVxajlUT0FzckRZbkNOOHNSY3FMaUpHdGN6?=
 =?utf-8?B?ZUFMNDdXbG9HVUJVN1dwNW9kRnliVEw5Y29lZ01iRkR5V2gvQkU5RlBpRmwr?=
 =?utf-8?B?MHh4MkljR1BYODZaZng4QmR3QllEYzFTdDYwZUJncDFuSzRMNkR3Q2E5RmxS?=
 =?utf-8?B?THFQdjdBL0dzemZDZXU1NlpSZVN6RVpDcjVreEl0UmlhTTJ6clhmdDFmWENV?=
 =?utf-8?B?clRkTVMweFkvUzZCTnp5UlpJMlk2cGY3aTVZSEMramhKQ2xDWGRXQ1BtdVY4?=
 =?utf-8?B?MXpOcXNKbWNsdGtKeTNERUg4ZEkwejVERmNjeXNDUGdXTHNoWlZtd1QvR2Nu?=
 =?utf-8?B?RzczK2pPaFhVUTB5eVRYekFUSTl4Y3FlTzdlUEZQbmZuSkxuZjE3Z1NLRmo1?=
 =?utf-8?B?emdoN2pjSGh5cTRlb0ZrdGtwc1dlZGlPMDZLcXJaLzlmb0wySjN2M0xkdHNk?=
 =?utf-8?B?T1U2WVhzeVlYZTYxcCtEMWVVMmFOeUtOeWxKYVRzdGpxN3pUTWpWTnNhcTZr?=
 =?utf-8?B?ZkJpamZFbDJRQTBTZi9GUDNiY0h6bXUyTUlRZWxRZmVvRTlCUmd5VktMR1lP?=
 =?utf-8?B?V1FQQ2dWUU5waENNRVZyUzRLeHB5cU1jUFZmQWVVMnkweVEwYmh0WmkzZDlL?=
 =?utf-8?B?WDF6SDcwL3M2RG1Bb1BQdlRrZUJ4allZSVVzQnQzZVk3WHhkSEw0d0hvOGpz?=
 =?utf-8?B?Q2Y5SzFZRDNlOElyN2F2ZGhmWWJ1dnZ5bDVlaWh2US9aUlZtODNQZnpYNXds?=
 =?utf-8?B?c0Y3a0syNjJmSWY4MDFQa1FKQjExeU51ajNxemsxYklBbHFyZkt6VDVHRXpK?=
 =?utf-8?B?SU1lVTR6YnFYMUhFOW1QYnk4ZjdyNzFIUkFvY2RuVHErZmpPR05xdW9ieC82?=
 =?utf-8?B?UE5qZDVVVFl1ZnZydXpsY1c1Mk1ucS9jMzZPYmFGb3N3WXB0OTNiSDA4b0xl?=
 =?utf-8?B?a0RnUjZGS1J2N3RCR1UvMng2YXVRR0d6WFpJeEpmSyt1Wkd4N3RLY0VNeE1O?=
 =?utf-8?B?R2NSZUJUNHFnL29uVlZOaXErcTJyNk9jSFZUZnZXV1l0dkdEL2FaTHp2clFq?=
 =?utf-8?B?TGR5SXlNZndkRFR3RklSTzh0WW9VamUrVGhINzhGK252Q0NqYXZCaWY5cm9B?=
 =?utf-8?B?Q3JLaERJd1NMcDVyZkdJbitCSzc1TENmSVloL3RmM0lpbFZINGJvMU15clVE?=
 =?utf-8?B?Yzg3K1Iwb2ZtY3RCclp1bVh2ZEF4RS83bmlpdmZoa3k0UVdnUUZHRTJwYlpK?=
 =?utf-8?B?TDZWRHVXQjhkZitoeHliVE9lUGR0ZEFQV0p5YWhXSXdaQjVJUzIzUHJicWkz?=
 =?utf-8?B?dndadDBwcGdZK3NGMmREeEFWUWZJaVNaRFFMQ0tRanlTQXhVSVMrZkFIUnl0?=
 =?utf-8?B?SWtNVis4SjJEWGxhVE80d0s0QzFNaEFLMEFsc3RsMFRwYnRBM2ViRHJSK1Vq?=
 =?utf-8?B?eVMwR05xSWk0SUtuUUZDdVJDQzVsdytpQVVOYWdOQUtESEVWdENzaktJNlVT?=
 =?utf-8?B?THBXUzhHSytleHpGVXJvMU5pdkwvRG9sdnE1d0F2Q2NWejNGNGFveWE1NTBJ?=
 =?utf-8?B?Wng4ZmFuQmtQTGhkUDh4Z3FWR3lLTjhFaVF1UUhjc1N1YVI3eDh5VmNZQ3Jj?=
 =?utf-8?B?QW9NNFBZSUpFNkUwR2Y2dllUMjRHU0V6ZmFNdjZDd3hWS3dvcE05U01nM2Rr?=
 =?utf-8?B?bThVYTBwMUF6UDZzUHAzTGI4UlhscUg4T1U0MmFROVZpK3hJSFpKZWdVUlJ1?=
 =?utf-8?Q?aIvWfFjS6DlSr6+z93jaGBagD?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 296a9515-3260-4cdb-b142-08dcf19a9c15
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 06:35:52.8660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0KQCxSlSHVVfZNuWqZAfSWlVENrdPITtM20GUk3gbWMwfhgt9nJWwgErkTdb+Tf0V5YFoT8TTPnyi4TFUFskcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7255
X-OriginatorOrg: intel.com

On 2024/10/21 14:27, Baolu Lu wrote:
> On 2024/10/18 13:54, Yi Liu wrote:
>> The iommu core is going to support domain replacement for pasid, it needs
>> to make the set_dev_pasid op support replacing domain and keep the old
>> domain config in the failure case.
>>
>> AMD iommu driver does not support domain replacement for pasid yet, so it
>> would fail the set_dev_pasid op to keep the old config if the input @old
>> is non-NULL.
>>
>> Suggested-by: Jason Gunthorpe<jgg@nvidia.com>
>> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
>> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
>> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
>> ---
>>   drivers/iommu/amd/pasid.c | 3 +++
>>   include/linux/iommu.h     | 3 ++-
>>   2 files changed, 5 insertions(+), 1 deletion(-)
> 
> I would suggest merging this patch with patch 1/9.

If merging it with patch 01, none of the drivers is ready for the new
definition. With the current order, the new definition are claimed after
all the drivers are ready. So it seems more reasonable. Also good from
bisect p.o.v. is it?:)

-- 
Regards,
Yi Liu

