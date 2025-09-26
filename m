Return-Path: <kvm+bounces-58841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2547BA2362
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 04:30:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B79F17737E
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 02:30:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6477425F98B;
	Fri, 26 Sep 2025 02:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oCI4StjH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06CE25F7BF;
	Fri, 26 Sep 2025 02:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758853809; cv=fail; b=DgNQnKRhGyOOmNsGZb9Jy3K6EV/yb+Nri/rvlMQdC/cL/3kXQUHw3AC4HcVG4ieSA759aJ6p/Ai7O2029tX4O65HJqa7EWUqjh/PBGs2GkoHwvQlu5oV40682EVu9345SMIJpSkX+897YHagj/3glDZmSmt/0hO57FlSjzgXavw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758853809; c=relaxed/simple;
	bh=sMouQ+W7S/lkI3qgGCM3skHpGfMhcJeO0+/EKkvZIcw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TPwt2GIMAhq8fIrgXAYsvCKTza5fby0aR2WcS6sOgrr3x3uDpgCXhO7msYZmxJ2AX4FviG223US1wIVVC1GU+Gt3Z0QZG2PYeHybsHoNyrYigp2GTFO9WKIoYIyR1bREHJyHJHA/v1Ka+zwqpLOaIrxa3eK3TlZpksND/RtESmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oCI4StjH; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758853808; x=1790389808;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=sMouQ+W7S/lkI3qgGCM3skHpGfMhcJeO0+/EKkvZIcw=;
  b=oCI4StjHDuWxrg427o6sQhb3LMC95hR47nOqc80AA41pAo8KDnP0NKkK
   tsU7g/5F6mb38XhQIs20Rf/Za+389OR/+l/kOV5PCdkieOM2JpoXf3dIo
   Zaxyflw2mvFrCprPLk+sx7HebySgj1WOg9FU70s0w00B54EKsfRHdIHIk
   2jQPqGQ752p/9ytg20IcW7GCUeQp4jDgZrMqpY3f2c80nT7VjuWnPhvGu
   wz19We8yWTh3MSNimSlbxk4LGM+PuNQvb2HfTPzWGURjdLohVOPDwjZj2
   Rvjzb70EBGFJ7yf2NI7fmNXiE7avSWc3cF9A3jCEIVAXUOXGSj4FEe4lo
   Q==;
X-CSE-ConnectionGUID: wVmX6M40SMeNaDKSwFI2Pw==
X-CSE-MsgGUID: HE2t/USuTaSOX2YaaLONAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="64815611"
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="64815611"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 19:30:07 -0700
X-CSE-ConnectionGUID: 8Bk7QItHRmKTvmUnw2147A==
X-CSE-MsgGUID: 1MGDZ9KcTN28ctogkBBXwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="208218379"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 19:29:58 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 25 Sep 2025 19:29:56 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 25 Sep 2025 19:29:56 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.15) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 25 Sep 2025 19:29:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OlYent92N7EXeakFE+iRGoYS/vJMsgfOkBjoDY7HvbAjQ1NnBBpXhh/8Kli28uO3xEdh1kIgMsGgpx0qzICyIcxeke7YYK2M01YN+sW5l3E50uBuBcXMALuiGIkOIYrU+DqXwzmaftI5FECfuTEg3QZVmMMtwTNl29fqrLIpF2iOKjBEWCigTEzGTW1KmloYLFqvnM2UIZVbaz46dyTqQKpbaXmoVk3Tk7yS+wVpJhAeyin5kUwqInQ7coFynyMAscIERjPwJfWDzGG/OfQaIS1dJy69/FxgF4rhcOBlER0Bz6TTBIe+jh/BeTAIGZj29dSSdnNrzEFd53DaY39x6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PFKx8nYahSQ5jK4kcA81nCX/6t+iukvFQaX9GBz99xs=;
 b=KIEsfKuCi9Vov8m57HnXR6xUnrTvLKv3iU6OjyDEvy0K2RRGAqQ7vsKA/gwSX0+dQSdolQy7q2XeikTV3iJ/6q/HpXU9beNMf06xu/033Ry1eSYsh+ntj8rVAcPI0PZeHX1hklGptaHJlNEX/cMXfFgQnb2MLSWeG365wmZiZKk7yFNxGSHhktJWPDZHF3ZD0XMuRU3RzfFO3J+kQSLT+LeSkKdSCs7IHzUCqwhhHgwxX2sBQl1I9ouIQAschbX47G9j66F5JJu+GrY+tNmcIPjMA3/T4Hgjh31SapbNmZ9Nwy2WoYEia6j9x7M0Em75YH56jlhdwWtAAcbmu2sNSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB8155.namprd11.prod.outlook.com (2603:10b6:610:164::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Fri, 26 Sep
 2025 02:29:48 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 02:29:48 +0000
Date: Fri, 26 Sep 2025 10:28:39 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
CC: <kas@kernel.org>, <bp@alien8.de>, <chao.gao@intel.com>,
	<dave.hansen@linux.intel.com>, <isaku.yamahata@intel.com>,
	<kai.huang@intel.com>, <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <mingo@redhat.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <tglx@linutronix.de>, <x86@kernel.org>,
	<vannapurve@google.com>
Subject: Re: [PATCH v3 00/16] TDX: Enable Dynamic PAMT
Message-ID: <aNX6V6OSIwly1hu4@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
X-ClientProxiedBy: SI2PR04CA0009.apcprd04.prod.outlook.com
 (2603:1096:4:197::8) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB8155:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c4babbc-8d3e-4939-be0e-08ddfca49041
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cWVKUHFrY0VLZDVXZ1NZN2gwNTExa3psdmhNR091aitzYzQ4aXRId2tkUG1B?=
 =?utf-8?B?OGVLYnBpNjdabkNyREtsQ093RXFaaURHRUlVcWp1WCt5b2Y2Z3VSQXlyRWlU?=
 =?utf-8?B?M3grODNDbzRWckkxUmZxMDlrdk9DRi9OdGZBV2ZnVURrUWlSenJqc1FXRGdh?=
 =?utf-8?B?aUQ3VmFKNVE2bTh1TS9tRUxKcG9PbUN4bFRESERHRXdNajFUTGk5aDk1UWNM?=
 =?utf-8?B?UmdMdkdBUXlacFFnVHlsZDZ1OU9RMVI2aGs3VXZIR20vaytKeGlyblhaT0xv?=
 =?utf-8?B?Q25pS3phMXQ1U3dXZ1lRL2JXYjBjMzZ6QkVIMEVCeTVxV3NUZ3J2TnZhUFcw?=
 =?utf-8?B?S3BXVVorcVY4U0k4ZWwza0NGTUMyYlk5ZzhrcnArT2FUeGp3eXRhVE83aUhq?=
 =?utf-8?B?REg5amdDMVQ4dmpUZm9ya2xjMVFQVzNiSzkxRTAwdzIxZDRwc0hmR09xRkFH?=
 =?utf-8?B?Q3BHNnl4bzdqN24zOWVVYm1DbXlyS2xpaGtsQkdGVHRSWDVhelZKcjNpaWdG?=
 =?utf-8?B?cGcrYnkyWUF1TVVRQ0toL0E5NDVGUjhHQVljQjlGOVY1SFlpbHd6ckdZK0FB?=
 =?utf-8?B?a0FjSUc2a1BqUGtrRFNpczBEcnQ1UFcrTWk3UFRocFo0eTJHSmxjT2ZLWlcv?=
 =?utf-8?B?QVVhSmtUcFd6MWwyMVFsUEE1WWVrbWdaNmFGVnBxN0tLeGVJR05ieHB1TzQy?=
 =?utf-8?B?TUNJOTZtQ2xNV216eko4RHpXdWJjOFpybVJkSXd4aWxGSlkwdkx4a1dUcjgw?=
 =?utf-8?B?VlNSVkhFMWxONVV2d0lwZHZzckVma0pGUTkvQ2VxTHZFdGFUZEd5b2loWXhF?=
 =?utf-8?B?WEREOFZOTHAyS0xQalRmOURja0VqVExMR1hmd3NwMEYzb0s4bmtkTGtxMUNT?=
 =?utf-8?B?cmxvMmdBczZneklWUXF3VXRmWWtrRFoxY2gzSWRQQmZQRHBQOG9oMDNxOHg4?=
 =?utf-8?B?a25adkluMXFhWDRsYk1ReHMrOWloT0FQQmRPMHB6V09UclhkSWsyRUx0ZEo2?=
 =?utf-8?B?Um5YbTFXQkFuNDg1QkRjaTgydXRidkhHdmpLS1k1NnZIVXRFV0tzZnhISXNp?=
 =?utf-8?B?L3R0alp0d1ZmWkhSNkZBeWN5MG5Odlh0a0YycGhzSy91MXUwQTNwSEhFdGFv?=
 =?utf-8?B?UG8zcjJUVGRTenBONjM2enFxOFBxSkY1NHR4QTFXYkwwT0RyUENxR1A5YmFR?=
 =?utf-8?B?ZjZjL1p0VlcveXEyeEhyM3hzLzc4eHl2d2t2ZFlMZWpCcWdtUDkvSTVoY0pR?=
 =?utf-8?B?SXJ5enVhbDF3L2JxVUNVaE5sZjNZTW1lcnVPUDJxcUFIMG9jY0VsVS9yWm5X?=
 =?utf-8?B?aHR1TGhTY29OWXdITVljUWc1TUlpTUxvcGxFVmQ5VTdNcmkzM3ZLQ0JWcnE4?=
 =?utf-8?B?TmpqaFVJSVhqY0c2MmttYXZjSjU2NUlWWGZhNDUzdEtwRXlvdTBCUlZjTlRV?=
 =?utf-8?B?aytoOVFPZVdETXluR2VSV3MxWFBIeTFESHpwbUd6Vm5Ba25hWEd6SXpROXlj?=
 =?utf-8?B?YnZFTlg2YXZOa1JVaVlSTnc0OERFOWdaR1NxdWkxZHJDeEJaNHhXQWpwMkFv?=
 =?utf-8?B?d2RuMlkzaWlOL3liN1U3V2dDV2YyZUJwMGtmTkljc2MxeTlqdnpvZ1pCL0Rk?=
 =?utf-8?B?NE5reGc3Q1RVckUzak9zKzZZWlpqNzBXd3dpejk4NlMzLzI4SmZ0VFhCWVpK?=
 =?utf-8?B?OFU0aDI2L3Y5YVNXV2ZQRVkzUkNsTkRQMFdjN2srbHBrcEIvRXRPbmNjWDNC?=
 =?utf-8?B?V3pQaVFyTENNMnZpQ3pSUy85ME1RakMySjBHb3ZoOVkzZVE1VnFGS2sxeDkv?=
 =?utf-8?B?NVA0VEtMOEZrVDZSTmRjZnhscnk2QTY3cE5ORWZ0ZUVLNXE1SVBYOEh6cjZC?=
 =?utf-8?B?MjhmTDNoV3lzSmVVZm5lK1lmajZnd0JQU0l1SWkwTjQycEJCdzlhRmM5YWky?=
 =?utf-8?Q?NoIGBn21esg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cDVNNFF6bk9aR1RhY2tQTGJtYU1NUHZlTit3U2theGpKdVN0ekNPN1FPUzlQ?=
 =?utf-8?B?ckhURUpxdWFqcmVYeHFwSE5qanFlU1I1VmkrM3pOb2lHYjFDM3lzY29aOWV0?=
 =?utf-8?B?U2ZZcWVYK0dMdDlOa3gvNURwODVoa3RCaFI4VUgrWnlpM04vSkovU2hBYlIz?=
 =?utf-8?B?RjNYTFljSDRhL1kvZk1menhIclEyQUNES21MT0RhQTZUU2diOGZySGxpYmJQ?=
 =?utf-8?B?NnU4bHl3STNtSHNWOFdXMC9rRG1SNUdvUzFGK1RhODZUb2dmYjdXek80TWd4?=
 =?utf-8?B?MkR5MGxteVlIT1lOYmFlNGVtdG9lWElHb1pjM0lYYmR5VzJseTNENjVBMmE1?=
 =?utf-8?B?dGI2RDl2eVVDcmc4SUZQYTNMZzA3eFphcjN5YTRBQlFTLzU3dlJqdGxNZFB1?=
 =?utf-8?B?ZWUwVWljYlB1dm5hNjdZUjZtZDFib0ZQR1haTkxoU3VCTk8yZ3EvRm5US2tD?=
 =?utf-8?B?N0lmZllPSHB3bTFaR0ZRcWFqa0Fpc0M4ZHcrSzc3a3BBaUxMd25ablN3T3ZK?=
 =?utf-8?B?UkZUTUVEdURhMS84aFgzeGN1ai91RWYxa1FUSGNoWm1Yc3RRbFpycmY2N2tR?=
 =?utf-8?B?NEFvcWxRRWU3RDdzanpWWGNIVEJoUzl1TC84UG9JYWF4bHJJUkpOcWdRWldt?=
 =?utf-8?B?SVZNQXZySm9LZWE1UEpieS84M2l3bTV1N3d4NjNWYk00MGhkNTQxeHZjbCs3?=
 =?utf-8?B?OXF1Y1N2ZGYvdnpXVnFIdXprd0FoL0JmUm1zUEhaZUhPeHFHSjdvb0tEa2d6?=
 =?utf-8?B?ak9EUkxOODZRUUVxRU1FTDNFZG1hSHNGUTNXZUFuQkFrYktwc0F5QnZiUm1n?=
 =?utf-8?B?c0QwWTRlZm8zN1JVTzdvV2prWDg0Z3o4ZlArMmZHbE1jam5YV1hBNjhJRFFi?=
 =?utf-8?B?VFkva1d0MFZDejE3dHBxakV3TUozV09rWlNKeERMTW96ODl1MGFNcVJtTVdF?=
 =?utf-8?B?MDdZRjIxNy92bzNFeEJaN3JRcW1NSTJhc2ZVSFA1VUZ2Y1dSTzRYQ0pTTkJr?=
 =?utf-8?B?WTFkTnBSQzBObXZWVW9XOVJZY2NqSXd5N2NXdE9haXNVS1VncUczdVZrcUhH?=
 =?utf-8?B?K2QvS3dSZmZ4c082cjlLV2ExYmNCRm5UR3Z5RmpzQnRXcldRY24wNWt3a0N2?=
 =?utf-8?B?ZS9pZlpIMVROdjduL2RLNXVMN3JEN2Z0ZDI2Vnh4bGtNYlJhUHJCM2RPN0U5?=
 =?utf-8?B?QktwZ1hxM295TERYVE9HT2NHcXhOTlQ1ZUNQL041c3RmZjJ0UndkT1dBME0z?=
 =?utf-8?B?b0JMRFh5NjI0bW1BS1VRRWExcTA4OWJub1NsUnMxVjlKRTM1NXBPdFhQRG9X?=
 =?utf-8?B?aXdybVFKYjl2eHYwL21iUy85S1oxYnVxNy8rekphZnowWVc2WmVkOWVSZEh0?=
 =?utf-8?B?WGZMOGN5M1FEbFQzN3E0aHExazdPL01aOWcyazBtc1NERlNKVmgwSm53YUZn?=
 =?utf-8?B?RnI1YmtSWkZjT3VqQndFbU9WYjRJRm9sbHFtZzZxbGxPUndtWEp3QmhLOEti?=
 =?utf-8?B?cHN5eVJ5a0IvT1FVQk03emxoTUh4alh3d0FXT3U0NE45eDJrei9PbVlWaVll?=
 =?utf-8?B?ZlowdGhvNUo4Y2pVdTFYVlRWdGpocGpxeE1xOHJ5dW0xZC8rK29ya1grRXNL?=
 =?utf-8?B?NHBVMVZLRmVNVERYcFVzSE1PempYcEpFWVdlbmV3RFBrNXozQ0lITWsvQ1JT?=
 =?utf-8?B?azM3VlJwdCtrZkRTMC9oMTl6UXV1VEdON2htYjJMZWdqS2htQnRGRnJYNHd2?=
 =?utf-8?B?ZUt4NWRzN1NxSkNBckNvUFBySmNUemE0Y2hwNitUSlpIT21aUGlrVS9RK3VU?=
 =?utf-8?B?UXQ3ZWY5b1V3RG13TmNSeWVTUi9aY3grZEZ2dzBhS1VqSXFFaGJ4dkl0eEJo?=
 =?utf-8?B?T21vZlVwQWlxYlF3dm5zZlR3QXBKMGtXTDFPRS9WbDlBT0NJNjJydU13OGh5?=
 =?utf-8?B?Z0R0OEJvNUNXa1BuMlBJZ282MjFKYTFvRFRZM2ZaMHYwMm04M3JsTEN4NVRW?=
 =?utf-8?B?SFJ4emJkZnkrd3BPeHZFMnRvZGJkRmpzOU83VDFWWWZtZE0zb0p2QjU5bUQ1?=
 =?utf-8?B?RTl6b0FlYjJCRjkvSlNEVUtlOXhCZVUxSmttSmJ4M3ovT3ZhQlppOVp1RUM2?=
 =?utf-8?Q?e3zLWq3JmuQpOHow2FsbKcbcI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c4babbc-8d3e-4939-be0e-08ddfca49041
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2025 02:29:48.3466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gTYvcgCSOQtU+rRpjbtsdCneaVhdFxeme8jPJRyN6u1k6YXw63XMQ37ADfGlRD7UsVRgTIt1Q4zwhv8DReBTyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8155
X-OriginatorOrg: intel.com

On Thu, Sep 18, 2025 at 04:22:08PM -0700, Rick Edgecombe wrote:
> Hi,
> 
> This is 3rd revision of Dynamic PAMT, which is a new feature that reduces 
> memory use of TDX.
> 
> On v2 (as well as in PUCK) there was some discussion of the 
> refcount/locking design tradeoffs for Dynamic PAMT. In v2, I’ve basically 
> gone through and tried to make the details around this more reviewable. 
> The basic solution is the same as v2, with the changes more about moving 
> code around or splitting implementations/optimizations. I’m hoping with 
> this v3 we can close on whether that approach is good enough or not.
> 
> I think the patch quality is in ok shape, but still need some review. 
> Maintainers, please feel free to let us go through this v3 for lower level 
> code issues, but I would appreciate engagement on the overall design.
> 
> Another open still is performance testing, besides the bit about excluding 
> contention of the global lock.
> 
> Lastly, Yan raised some last minute doubts internally about TDX module 
> locking contention. I’m not sure there is a problem, but we can come to an 
> agreement as part of the review.
Yes, I found a contention issue that prevents us from dropping the global lock.
I've also written a sample test that demonstrates this contention.

    CPU 0                                     CPU 1
(a) TDH.PHYMEM.PAMT.ADD(A1, B1, xx1)      (b) TDH.PHYMEM.PAMT.ADD(B2, xx2, xx3)

A1, B2 are not from the same 2MB physical range,
B1, B2 are from the same 2MB physical range.
Physical addresses of xx1, xx2, xx3 are irrelevant.

(a) adds PAMT pages B1, xx1 for A1's 2MB physical range.
(b) adds PAMT pages xx2, xx3 for B2's 2MB physical range.

This could happen when host wants to AUG a 4KB page A1. So, it allocates 4KB
pages B1, xx1, and invokes (a).

Then host wants to AUG a 4KB page B2. Since there're no PAMT pages for B2's 2MB
physical range yet, host invokes (b).

(a) needs to hold shared lock of B1's 2MB PAMT entry.
(b) needs to hold exclusive lock of B2's 2MB PAMT entry.

