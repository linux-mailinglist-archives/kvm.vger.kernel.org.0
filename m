Return-Path: <kvm+bounces-30697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 574D49BC799
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 08:57:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A64FBB225B3
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:57:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C04EC1FF025;
	Tue,  5 Nov 2024 07:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ek/tAt2j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02837282F1
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 07:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730793422; cv=fail; b=htiQbjrqehmfaAK1LuqqFXZ0PkOp88egNWchuBH3dECSDHlvYXsRYJabWff43rTAGy+Y1Fmf6TZwfewyJTH8vQ76BMk4QzsjG6gYLaPmSKeKOQp2uNq1QWcl6QmZBVbNhSUJ9tWzgDCgRfvIDAASzaSXgyxYCEHmUYaYN60ZOvw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730793422; c=relaxed/simple;
	bh=w23aPR40E4hZPai0/TM7VPqyAIfpYL5ne3+TACNIq5k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JaeK9x88DiPDvpBMxknpgg5DKxNGtqL+5yGjlf7Va/d+7x2etCbDtxMuATgWpOU91Tq+JMFFACxHL0yV7Y16MeGKmCJ1+UmjcMXDDUeiOXR0aLKjRvKquDpxejtqWwOetyqJbIicVf1fOg0agJSRg8PwZkOt2RDsuB2ZDEoFTrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ek/tAt2j; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730793420; x=1762329420;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=w23aPR40E4hZPai0/TM7VPqyAIfpYL5ne3+TACNIq5k=;
  b=ek/tAt2j1Lrc6ckg1exwBJURDFugPKoHtOWHwwlOYuRtnzxzyLHmNiFS
   cqd3BmXtCgGkeJLqikAdavi3EsiN7G4z2JF8NXARvqZfE/+2Clck+5Y3b
   SL+olPJDw+bM4Kas2dB9keQDUSf9YEuoZx9vTcMUQNPLhqhkC7zq8STec
   9iyDqMgeiEvm9kDlhjnW+3ufFr50rjZW9v1PqzjBwc8FBJ74b/666PwPh
   0ktOrVz9HT7tUyMP8g9C5U6bQU8mZHDAqkpqsKBxhxX//nyte+hZS25l6
   jQBzQu4CrNG/ixEzR7ofZz4Kz4BzzjIdRIgnYJAmwkTN2Plk8N40XDIrN
   w==;
X-CSE-ConnectionGUID: qls5Rd+bRNyPDK6h8wD2Og==
X-CSE-MsgGUID: /+fwdYkhShGA/kfCdoBcGA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="53089695"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="53089695"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 23:56:59 -0800
X-CSE-ConnectionGUID: TKrskqaBRZSWXGKafPmYBA==
X-CSE-MsgGUID: bvTUugQWRWOpFouKgILKLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="84318837"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Nov 2024 23:56:59 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 4 Nov 2024 23:56:58 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 4 Nov 2024 23:56:58 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 4 Nov 2024 23:56:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sUDhy/mZD7VSql8agR3+9lt6JY8NZZFC8Ic2RVaTEX/jQ19p8SF3ULCkvK4A6YGkUCSSq9+sLhbnrcct9UYoSMhKbHoQSyg/GsVc7ljpMvRbDT0WxmyfhugFhnis++fXkRohletZcQ3OaXxpiWXMJ5vLfzjvnyNEvVeFq207tBOyCUZB6rQitP1bFtJs4h8TZPMD7SwzTmUnfbBiQsFvpR0pM3MUDeqgkEoBeXGvbfC5xsxbDxwW4wmbeD77XB3XjLLFhEkXbVlpLBDLIqiDHjWe1ey2Ioz+8LCxJLBdGlQKjqS8gm/Wy9SwB242DV1sQdjZUFhD2UMYl1dj00v1ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dCg+dk9LVCCAWEXT1lA05O1+gmBXjtzDThMPBszA2B8=;
 b=D8pNxvJVg2s64vmTs1VVUWG/AjTGabE9cqWXIrR3fz9AxyARHJZA96e6R4g5mv7o/VDkq+ZZ6WF3r7caTlta2PZ0eOU5WSKeG0WxSBdcDC7qx9lH4lR9hN8YvJTRL7ahzH1rbhiSzKp8oQjD9XLLjfXCfRb1wd+q3kjIlfiepTR84MXcLu7L3/lSiL5xd/qEaI350KmoJZ3DDqBeBUlZ+0Qr+ZyLyp+mqMRD78ZSUMrwyTXZG/2nVkXD353t61iSfARnUgXZjlzruxgbXWVhrGZDmoH7Ez+PrseMi4IeWQryRwezpaeB4+avIuHtBMlATiN+kXxhJexDIhcO1mYG6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by CH3PR11MB8153.namprd11.prod.outlook.com (2603:10b6:610:163::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31; Tue, 5 Nov
 2024 07:56:49 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::399f:ff7c:adb2:8d29]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::399f:ff7c:adb2:8d29%3]) with mapi id 15.20.8114.028; Tue, 5 Nov 2024
 07:56:48 +0000
Message-ID: <2d1b8ce9-e0b7-41de-b404-d90ee77d44b1@intel.com>
Date: Tue, 5 Nov 2024 16:01:24 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/12] iommufd: Move the iommufd_handle helpers to
 device.c
To: Baolu Lu <baolu.lu@linux.intel.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>
CC: <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241104132513.15890-4-yi.l.liu@intel.com>
 <41de13f5-c1c3-49a3-a19e-1e1d28ff1b2f@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <41de13f5-c1c3-49a3-a19e-1e1d28ff1b2f@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0001.apcprd02.prod.outlook.com
 (2603:1096:4:194::10) To SN7PR11MB7540.namprd11.prod.outlook.com
 (2603:10b6:806:340::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7540:EE_|CH3PR11MB8153:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cfef797-f9b8-4df0-436a-08dcfd6f66a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TTBEU0xjcjl5UnVNRUVxay9QUU9taWpadkZUNmg0WjBxcC8va2hIZUU4N3Js?=
 =?utf-8?B?RnlJVTY3UEw1L1A4U3VLK1lHLzhxSnhaTHl0ZGg3UnNBbGtOY24zRE9DSTYy?=
 =?utf-8?B?N0F2OFltSGx0K0hXbSt4MCtkZTNrNjZjSGdncHlTMnUzUExyWEE0a1F3anRP?=
 =?utf-8?B?a2hOTkNFRGlPMDk4WU95RlN4dTliRjhmcEcrczJxVWxKTE1MczJ1ZzdTdmo2?=
 =?utf-8?B?TjlxQSsvY3J6a1BGYm5qOUwyZGx4WEtwYzJYY0YyeXlxVjEvZTBWamNCR1dp?=
 =?utf-8?B?QjJCS092aEZuL1lVZnNwbW1MRXV0MDFqNnJuTDFmZ2RrbjZoNnRzNTNzMDIx?=
 =?utf-8?B?L0Z3TGswV2IwYjRjWlkvK1pQS09tYzRFTmpxdEhwMkhqZVJ6WnNBZlIyazJx?=
 =?utf-8?B?R2FFM1B0aVA0UmNGMXF6bldlR1ZJYlNBZ0pKLzdiRjNRTjJjNkl6UWdwVWdw?=
 =?utf-8?B?a1ZaYzNlVGdGQThUaGVnVEw0WHdTQWNZOElnRWN5aGNSRHRZZEhrM0VCUmRu?=
 =?utf-8?B?Qkd5SHhFeE1jWEQ0bXRqSENuOG9VMmdVRWVTOE9xV0FxVGNycDhZZjVXanlo?=
 =?utf-8?B?b3lSaUJmQWQ1ejJoZ1AzWWFQRFNMUFBhN3plS0pQTHVoVnRLTTFLUkdrNFRw?=
 =?utf-8?B?WitCR2xuejZSRDVqbU92bzhybTN6d09nMG1LUk8rT2FvN0lra2poNTFRM3NJ?=
 =?utf-8?B?RURoYnJScFI2S01raXVHemNPWWpPV3ZxbElmWWpDeEhsK2ZaM29pQzhuS29F?=
 =?utf-8?B?TVRxamJ1VzRDZ1ZkeHhReTNOR0RTT3cvcFFhbm91YkdmeHhIeWpJdzdxZVpq?=
 =?utf-8?B?b3F3d2xVRWNEVGsyRWl3RHA4Z2dnclRsV2VEN1Zua0lCZ2dwc3JrMmNOQmdY?=
 =?utf-8?B?dE5Ib2cwMXFoQnhJRUsyNmE1eFpqRkRYakVWbjQyNnJBZWQrQzFSdmJ6cnJW?=
 =?utf-8?B?d3BlY2RmVjV2KzhFd2FFUlRFc1lkMU5RUzVHT1huVkdvRWg5QmpOYXBhUCtu?=
 =?utf-8?B?U1NjOE1FYnkvQW5lOXE2RldRcld3NDFYT2lsSXQydTYyQko0eEcrcXdPZmdJ?=
 =?utf-8?B?cncwblhkVTM0eWhNTjMzclZObTBGc2U3ZlB3ejV0NlBTcnNoeTgyYUdKNjhU?=
 =?utf-8?B?S0FIa29jNFJzWTFoeXNNYWJpckpLMVV2cjFWV0t1bGJiQmVwZHRORzlEcTFG?=
 =?utf-8?B?WFVjc3ZMM0JrT0JrS1d0L2hHNE1KaDZXbVJkRzBOOWE3Z0pxa1Y1enhvY0Ry?=
 =?utf-8?B?NzRuWTNvV0g5TU5wamVwVVRVSHpiNHNRUnVhQ2l4SkFXamY1ZFhJRXozTFd1?=
 =?utf-8?B?S2V0THcwenp5UE9IbjRqRCtqWGhpaEJBbU55OXp1dk8xdW82VEhnaU96MWFH?=
 =?utf-8?B?SjlhVWxlSXl0WklCOVlRM2xJVVV3d1ZJK296aGNNaDNVQ01nSGNBMEt0d0Fs?=
 =?utf-8?B?b1lnK2dVV1pLTUdFSm42UnRlOFlmN3N3RkZ0OHc2WlBBWjAvK29hMmFBRVRH?=
 =?utf-8?B?N3cwL3hPMUc5Z0lmU28zdTlOZlBkYWJQUXRmR3U1R1Z0Y2RLYnFJU1NzOXg3?=
 =?utf-8?B?VytXU2lFZk5XMnRJZjFpU0dncnNLdzZwSHBrVXAyU0ZXSmV0TmZiQW9QcFpI?=
 =?utf-8?B?YmR1ZzlyZlFDWUQzN0ZtcVNuUGRTSnlrckgzMEpVUUxkc29tYzdtMU5FeXdL?=
 =?utf-8?B?cmdWZlBUVEtXM3VDalRHOHM4Sm1aY1NQQm0yS2JXZE5FTUxtbVhDTDJZNUhy?=
 =?utf-8?Q?OyYclbS/eVKLjalVoUbfTD2Az7fpoUMhA37le/I?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dlg2KzFUdGxEb3VGSSt1MS8yM2NTYWVqYmRHcTNGTHhtNlFKVitWa010d09C?=
 =?utf-8?B?TEhPS0taL2IxSllLSGxDVW9KZ2tkcUFJOUxnVEhyTUJBTElHTXg2UGRYdjhs?=
 =?utf-8?B?NHg4dG1BcTdaZTBmSmRLRHZPemNaSml4RVdYQ3FnOENYWXZoK1dyekwrNWh2?=
 =?utf-8?B?S2VqR2RNRjhSZW1xTk4zeUJpbGw2aEkvdXFQcTFaTWJMaG0yTUtKeWs2Tkc0?=
 =?utf-8?B?Y2c1ditkQi9wYXVLREhjeDFSb3phRldPbGg0czhUYVBpaG5wbWpBZHRESGJC?=
 =?utf-8?B?eWEwVllCRHl3YTFzelc3WmVId2ppRFRDSHJJZjF0NFMybk50dkRxZE14dVNh?=
 =?utf-8?B?cEd6NHJGcU9yS0QyZUlqVDQzZTFnbDJMaS90K01hS2dDMXF0a2dFQjczNEZr?=
 =?utf-8?B?SW9ycDRNZnFadFlSSnlhbWFNemJIR2dEbW5YM3U1WGQxaUVCdk5sU01FcVZF?=
 =?utf-8?B?ek1sRHBzc2VMNU9oeHAweUgvdXFSRnk0MVZ3WlM4c1V0Mk5GZ2E4bTFLU085?=
 =?utf-8?B?bTZtUjdUeDRoTlNTeGNESUgrYUxmNzUxUmplQ3VRWm5aTVd6b2tNNFFRUWdB?=
 =?utf-8?B?R2M4NytTOWd6Y1BXY3JRRityNGwxM1pmTVlqNUF4T2FNbjF0WWFxMnpia1Qy?=
 =?utf-8?B?MFhzMmhPS3I1Q2twZ2pmRWI2SHE1b2RuL296akZ1UVg0bW5iVUx3T0JORzlG?=
 =?utf-8?B?RnAyV04vUG5iVVNYQ3BoOEpEOUtlL0d6dXpUaHg3WjZXckVocDFCdkprcTFh?=
 =?utf-8?B?S2s4UjM5a21XeU83VjhKby96c3lYODVjcXdqaHpDbVhwV3dReG9CWSt1QzBS?=
 =?utf-8?B?ZUYycDNxR1E2Z3IzaXVONncxT3JlRW9rb0Jidm5KZ1FLdFRSQitCalUvQ1dz?=
 =?utf-8?B?SFg5RzVuSXBERlBmZFczQVBnd0xmc0Z6bm5VMnYySElBZWRjeHUvUlNxWkYr?=
 =?utf-8?B?Um9GTUdRMVMrTjAySlZ6b0RpRVZjNGNMOHVsZXdPdkUwQWJRK0xkUElDOGoy?=
 =?utf-8?B?czNhTjVvMW44eUlXVkNWMnMwZmRYYWh1ZWcvaTV6MGpmSVVCYVp2aHg0YkhD?=
 =?utf-8?B?aEphcTlmK0ZHZEtIaTdFQUNVMGg3TzlxNzhRdG1Ga0d5bG81YmdPVHZFT0Nz?=
 =?utf-8?B?MHNHeWoyNHJXUEtZZy9sREh3Q2UxRFdhZUxuTUtVZWY0NlJYSU1vNWxnVnBX?=
 =?utf-8?B?VkM3Q3BwRDMzbUM0MjYrOSt6ejR4cFM5aUhuYnYwU2lPRzZmUElPRzduajh2?=
 =?utf-8?B?bGxCeWIwcXRPc2R4d3d4d0JtZEhKb1JVb0NUWnM1YytuMkhDUHltMkhNSUZF?=
 =?utf-8?B?MTJ4TEZMNmV5cHlMU0dOMk50dlJBcGl6WC9FL01PaXdiU0NYU0RIcVZ1ZEM4?=
 =?utf-8?B?MDVIbno2TlhoOVovVmxhQ0h4NFdBRmdGVm9IRlQ3WWZTcmtpaW9LOVZiMmRU?=
 =?utf-8?B?OGp6TFF5NzNJSW9kTzVmdUZyUXcvUmI0ZTlDSUxiN29TaGlyTEJCOFZIUzNY?=
 =?utf-8?B?UTcyS0hGZFJYSkRYd254NWErelNMaUJNN0hMRmlnRXdhaGtkZ2ZXcWE3czF4?=
 =?utf-8?B?RkZkc1FxeHRseWovTzQwTUMrUzdWbVJQSjQzNlZYenBhVk5IbE9YaGE3Nm9O?=
 =?utf-8?B?dkZnSldiZ1ZRSnI3NVFWRW9QaktLZWVsKytuSTEzcXQ1cmhTK1dza1VxYnI1?=
 =?utf-8?B?ZEFNbmdBZEhWbWNnL1FxckcvclJmdTJEcVI5SjA2dXM2NGw2dDRZc3ZYU3Ry?=
 =?utf-8?B?VnduQ0p6SXZpcXVuQmRvT0MwKy95MlB3TDZkTlVBL0VPSVdBRU0wR3FDY3M1?=
 =?utf-8?B?ZmRxUTdNR1BDSUtkY3BKZG8vZWxESTB6bmVjQXdseWkzdVZLaUFPRlVVM2lw?=
 =?utf-8?B?aHdtTUJnbDdmK3FyR2FMUDlxRHBwdmRMeldHRG1UWkdRcDFOR2w1K3ZBZjJZ?=
 =?utf-8?B?SFNHekxCNWpmK1Jtb1M3TFJ2M0lvU1pHSzRiL2VGaDdsRTJTeXFUK2JtdU5Y?=
 =?utf-8?B?K3I3R1A4aklkako4T1BPemx2ajVhOHo0OHJXT2hWejMwd004WjBuam12WU4v?=
 =?utf-8?B?WDZ1LzRhNHV3WnNVLzlJUEVhVTBnZjZtVXp4SEJsUTBSQzlQa04vVGE5MnhQ?=
 =?utf-8?Q?Kgx9pOO4epA5kJqxQBLMMm32E?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cfef797-f9b8-4df0-436a-08dcfd6f66a5
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 07:56:48.8026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T6yJbyGzr9sBVMyEcGdbF9EohLNieX53D0cT7yy0GNs5RRZX8UmR5ffqiTu/baCpXq1V+mUZhWzqRp6/75ZP1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8153
X-OriginatorOrg: intel.com

On 2024/11/5 13:21, Baolu Lu wrote:
> On 11/4/24 21:25, Yi Liu wrote:
>> The iommu_attach_handle is now only passed when attaching iopf-capable
>> domain, while it is not convenient for the iommu core to track the
>> attached domain of pasids. To address it, the iommu_attach_handle will
>> be passed to iommu core for non-fault-able domain as well. Hence the
>> iommufd_handle related helpers are no longer fault specific, it makes
>> more sense to move it out of fault.c.
>>
>> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
>> ---
>>   drivers/iommu/iommufd/device.c          | 51 ++++++++++++++++++++++
>>   drivers/iommu/iommufd/fault.c           | 56 +------------------------
>>   drivers/iommu/iommufd/iommufd_private.h |  8 ++++
>>   3 files changed, 61 insertions(+), 54 deletions(-)
>>
>> diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
>> index 5fd3dd420290..823c81145214 100644
>> --- a/drivers/iommu/iommufd/device.c
>> +++ b/drivers/iommu/iommufd/device.c
>> @@ -293,6 +293,57 @@ u32 iommufd_device_to_id(struct iommufd_device *idev)
>>   }
>>   EXPORT_SYMBOL_NS_GPL(iommufd_device_to_id, IOMMUFD);
>> +struct iommufd_attach_handle *
>> +iommufd_device_get_attach_handle(struct iommufd_device *idev)
>> +{
>> +    struct iommu_attach_handle *handle;
>> +
>> +    handle = iommu_attach_handle_get(idev->igroup->group, 
>> IOMMU_NO_PASID, 0);
>> +    if (IS_ERR(handle))
>> +        return NULL;
>> +
>> +    return to_iommufd_handle(handle);
>> +}
> 
> I would suggest placing this helper closer to where it is used. Because,
> there is currently no locking mechanism to synchronize threads that
> access the returned handle with those attaching or replacing the domain.
> This lack of synchronization could potentially lead to use-after-free
> issue.
> 
> By placing the helper near its callers and perhaps adding comments
> explaining this limitation, we can improve maintainability and prevent
> misuse in the future.

with this comment, it seems better to put it in the header file. There are
two files that has referred this helper. the fault.c and iommufd_private.h.

-- 
Regards,
Yi Liu

