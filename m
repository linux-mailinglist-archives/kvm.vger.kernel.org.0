Return-Path: <kvm+bounces-17495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FAB08C6FAA
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 02:53:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 79D3AB22AD3
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 00:53:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 431FA10FA;
	Thu, 16 May 2024 00:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QR+Le/qE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3221D79E4;
	Thu, 16 May 2024 00:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715820772; cv=fail; b=XdKfCn/tTEr0XdV/8ztHh9qZN1YmdGV1+T/BTc+tnT0sGmgZNpQEUaUkL05N4Cs77E9VzoOnXsZSm7yBB+ugkpX4k/VdgZ0/48AA8+nJ/zQc83PSAtRJFxHU2GdelBM+yxf8OQAUMicFkT75UujdPlo2bVItwX+YeZuY+GPC8ZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715820772; c=relaxed/simple;
	bh=ysYEr6x7/K+oNP2tDO4tJUDFcFMcsxmgbAgbKXSu7aY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sEXnuP/wxXIUTCaLlliPBUKkMXLh7CrhhGhmgsI6aYUva1Jexr2BX0FfEJJQEeVbOuwu1rt3CZnuLb8ncL0qvanrNHd+ZAoTVvCjGZjHQH5/cJMu7NSNQuWv/2go5olGSaFbTIjl3o2DBIJyZ1pxM1H/oDsvOYC66cKPDsYAuV0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QR+Le/qE; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715820770; x=1747356770;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ysYEr6x7/K+oNP2tDO4tJUDFcFMcsxmgbAgbKXSu7aY=;
  b=QR+Le/qE1Tn4P+j37e/4BEKhkxjT+NwmTrwp2TUOX0Aalz6+zwBe1IHG
   qgt0Z3+e6PDKKwz2MmATbugJ3sywIXqQLumac4yNmVz52cAynWFW58ndp
   SQEVzQpV4j6HtQCoqA2OyTur52O/dunNd3nrBR9wdUdVoHfjndyFuwbYD
   HJXCdGacPYQeUGLE5DToNTMExouhbqTQC5IM87dzRam6ZDMk/XESaSggM
   Fek9x0ATIo0BgvWEuLsYyk7sysVhCl4mlWYLD5L7KT9oXN7qtcApETibV
   WGcIjcbDwrFF91EyNvDFrYegsa9L4RQw4EGYWKuE7gPx2ZbYFhWX/Cf+P
   w==;
X-CSE-ConnectionGUID: 2Rsrb57cSUWzy7seUuV2KQ==
X-CSE-MsgGUID: djP6+AhHTZmVsHXeO++7Qg==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="12077766"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="12077766"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 17:52:50 -0700
X-CSE-ConnectionGUID: zdCHMe3UTPGOSQkkGkd02g==
X-CSE-MsgGUID: DS33lkfaRxWgS4r62sV4aQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="62444706"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 17:52:49 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 17:52:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 17:52:48 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 17:52:48 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 17:52:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D2uUve44JPj/2o+nacIsTyZ51WIOrpmD53ZnOzXPfwTdo8vMZQNpGtXbEDd9qMB5bwaZGwzEP3uCYyGiXovdHYo4B1vnc891AtxYPkbdG2De0Pnn3kCr/m/kpdnGHRf+hRU9FR0+t+UdUEKvgG/25+0ZCXLn+EK22zf6QUyiJoDT+WMh5HyRiFg9psMKgrtWJD3YmYAf6Mnc4FpwrVM+nom5TV1X+rNgJjhenQpiepJ6t9j7JJyuvQ0cLo+ougJ0ofehhQ4eUkEGAf0YJH+5TN5ww9OQxKOZ7uIiIYURj+4TUT8cXTxK90lUdZ8mkq83N2I9eadY+O5MMygRqrKrxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DGZc8pFmicf152WwPGKwkZN/9X9ODYmWCK6wq61puMw=;
 b=GIcIbUIIzid+NJrTZ/BDagcTxhrEBpfDuFzYA4gitkcBgtkqG/ew7bjd7jjA7y23R1Fnge6lYcd4wRT+YY969ApV/Hqbt/VQX6b2DvyKKo457ETsd53rVb5nEx6ym07bMBYTMSlc3Oqx4cQYftQsY/enfMsbvD5KOEBSXqmLzjFrfEaflBHHBCD40GNneDrS2Deq1Nvzqjb/hfetP1rqmFIz+ersGVWcWmAX5+oYnNb4sJtszJDlXh/o92cCmU50Tcs/PQFP4enjLr5SWp2cybJtIvdeka3IAeH6TptCYuIuFtAFckGew18rA2EkybNQhSWbGWx/51gewZqLrrPrcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ2PR11MB7520.namprd11.prod.outlook.com (2603:10b6:a03:4c2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Thu, 16 May
 2024 00:52:41 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.052; Thu, 16 May 2024
 00:52:41 +0000
Message-ID: <12afae41-906c-4bb7-956a-d73734c68010@intel.com>
Date: Thu, 16 May 2024 12:52:32 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <isaku.yamahata@gmail.com>,
	<erdemaktas@google.com>, <sagis@google.com>, <yan.y.zhao@intel.com>,
	<dmatlack@google.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0059.namprd04.prod.outlook.com
 (2603:10b6:303:6a::34) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SJ2PR11MB7520:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ff7b962-2d02-458c-eb71-08dc75427d42
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OHNtMzRVeS9mYzQrNGpURmE2czl1SktYblhlOVFCdjhsOEtIL2QrZ0dIdzZh?=
 =?utf-8?B?cE5UWUxhVHRZNnB6eFpMYmozQWM5MW1TVU1XS21PNXVWN1dIT2dGU3VLT2dv?=
 =?utf-8?B?ZUpZM1B0WExHMHZrY2dKclRCMlZtRDVtQnoreG5Pb3FrVy9KcGZjTkxuVFpB?=
 =?utf-8?B?alhRZ2ZJOUl0R0xtZmJnNlNrL1VtQ0pwMFI2clg4SkJrbzcvYi9id1JKc21V?=
 =?utf-8?B?RVdSYU9MN2ZJVW5tNmZlRExBamJYbmkxTTZmT3duQXdsdHZtUEVZc3BWK3l6?=
 =?utf-8?B?NnRzMXJEakY4Z0NZU20wdy9ZbWZOc2x3NERLa3E3TlIzMkh4WXEvN1MzWEJD?=
 =?utf-8?B?YXB3cmExaGFFTW9QTWdBOHVZSU1pcE1kR2JReE5XelpHMGRuWlRPbTZtMmNQ?=
 =?utf-8?B?QzREY2lsRmgxUm1HcWNVVVVqMUtvVDVJNnZvUmxRUDJHR2cyaldXNnM5WG1Z?=
 =?utf-8?B?Z3gxYmJEQnFtUm03ckJobkdwRlVhbXhlOElPeFlYVTRZdG1USkFxUXBwVS9X?=
 =?utf-8?B?cmI4U21DTWk1YklSQ0pDK0xKRm5BQ3JOUFR4UStYR1VCanV5RWdSM0dOR0ds?=
 =?utf-8?B?bXVTdlhhaTVPTnIrL3p3TmxScWc1U2laaDhmRXJiNkNjUHRlQkE1Mk1qZXU1?=
 =?utf-8?B?aFBtU3ZqQXIzT1cvc2RyVlRSY1NUR0hVSWJhelBDMjg0Vk5wWFFOVTgrUUpk?=
 =?utf-8?B?ZitIOGJIRXdTRHVnRVA1eEF2T1k3Z3d6dWFWeThBVENQS1ZEaGlDN01abXVR?=
 =?utf-8?B?VTcxMjhDbVlhTm9aU2JMRHpUbWlBcTM1Q3N1aTMyWUxQNVYrWndWYXlQTmoy?=
 =?utf-8?B?Lzk1SlhSUWxtQ1lmTWRmcVpzMHcyQ0ZnV2h5ci95dEU2NURxKzNJVUp0blVF?=
 =?utf-8?B?ZUtnTDVZUGU1K0JTYXloQ2ovOU1QQzNSQ1RVQXpSMk5UZjhIYUV4bUE2YkU1?=
 =?utf-8?B?OFZrQ1FFcjNlNVFZOE93Y3RWd3dkMWEwdW5UM0FLU0YxSCt3eWROSGJYSStj?=
 =?utf-8?B?c0d4OTZBaWJjZXBja2pVRkNVZFFOYW91UTdTa004aENIQ05yaVJUdVdoenAr?=
 =?utf-8?B?V1hNeU9CZVNCQ0E4dHdHdUJDNkZHU3RET0IvWjNYcGtzNUV0RUdjaEVSRkFl?=
 =?utf-8?B?SUxsK0FXMlkyTG5hMmpkZFduWWl2aHpybDdPdUJqcDZ5NDdDOEp4SVkzTVlv?=
 =?utf-8?B?b2J6YWV3ZVZDU2ZpZ1RyazNmMHRVWlhpeU04SFpieDF2aU05Q3hFWTk5di9l?=
 =?utf-8?B?WmZYYmhyc21XbXBqNjl4aWhYb1I4U0F0dmtubWhKalBMcitiek9VMjlueFFN?=
 =?utf-8?B?ZWdkTTFJSVhsWU9MS3dYOGZhZGoyNFVJZDVoeUlKTXdPUVZ3YjNRTzA1SmJq?=
 =?utf-8?B?aWVraFZYUFRWTmxYVGM2ZzJwdEszZnZYWjJmR3lXM3Nva1h0RXZyZ2Vla25R?=
 =?utf-8?B?aEQ1NDFWNmFhUnFGZFVRL3YyY1hmUzlBS3BMMXB6UHQ2cXRLb3lkdnNPZkgx?=
 =?utf-8?B?dURtNHhuRDZmN2ZBOVNHOVZnd1dxdTdRQXNGN0JPd3Bkb2p3a01QbEx1cmps?=
 =?utf-8?B?ZVo2K1JQUnlPb01IZ1E1S0pSWmFGblBldjBjaGh6U1lkNmRoTzNaZkdZakpG?=
 =?utf-8?Q?nEs4CjI43bIkeZ7y0BvvOodTsQMSjecOaqX9OAbNOu9M=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TEZ5djVBRVJSdDNyZmNaZktNa1gyZDc0MVhKR2Q4ZmErcm4rVUwvakpGcEtm?=
 =?utf-8?B?V3BCaGd4eWQrcXBTVks5VTd2UUdxYVFpajhnZFRKTm1XOFlKcEpud1AraStx?=
 =?utf-8?B?WlhhalUxL0Q2alEyYVpKZ2VsOE5TdnhTTmduTVBSM2REQ3BoOXNac2ZrZDRI?=
 =?utf-8?B?d0lna2pnUTZJdSs5dWtTY1VDYmN4QXBVbExwYy8rR21jZDQ3Qjk5RWd0U1Y2?=
 =?utf-8?B?ODJUenhtM216d3Zrenk2RUNJSVBGV0ZUcTdkSks0eU5RQ2RBOU4vcGVCTkdL?=
 =?utf-8?B?bmZUaFpLcjI4UUlFdG9IV2JORzNSdGhPdUZBMGMxaDNVVkYzUVR3KzM3YXlh?=
 =?utf-8?B?VG1MTVZMTktvWFVZcnNpTDh4bmlJRjIrejZqQ2o3amgzWFY0WDVRZldhbnlM?=
 =?utf-8?B?MmRpcG5FRGRyRCtNdW5qZ3lqbG1GSjZmajJNM2lGTXBNclcvOGgwWjUyTTZE?=
 =?utf-8?B?SmFBSmJnYTVPYVFIZFU1TituNkZKT2R6cUpKRUZTM2E1cWZ6R3JmSFVXcjVL?=
 =?utf-8?B?b3gvZ1o1UlpFa0JBdW9FbVQrY2ozUVVzd2FkYU1idDJURDJHcWtPYzE2cFEz?=
 =?utf-8?B?WUhFelpqVEtIMWFWclRMeFFCWndYQmtYNnUyejh0OGlYV1krWlRwbG1xWmo5?=
 =?utf-8?B?Q2V4Z3BYbk5Gek8veU85YUgzMHU2ajdxMWlYNFlvVUt3Qk8yLytUdmw0UDNR?=
 =?utf-8?B?UnE2SjV1ODJjM3hTdUZlNFhuamRZbGRQQUljZUs5blR1c3dkd1hVQy9ZbWRX?=
 =?utf-8?B?eCtpRUdJNzZLbi9HSGNSOVQ1WUl2Z2NNYW5BU3p6TCtjT3Z1elNwTWlsdkQx?=
 =?utf-8?B?dGdZaVNjN2lzbHZWa2hkMlF3cWpBdGVIOWZUamRKU0dSK05lOTRwSHhta2ZX?=
 =?utf-8?B?cGlRaFJ0VGlyRWkvejFwYU5wYVNkamQ3bDVaWUtMRUs1MFdGWktFSS8rVE9q?=
 =?utf-8?B?NUxmRStqT29JYW05WTJ0OEU4M0xLZHdvVEhMMllHallCRzF3R0RMRVE0Tkth?=
 =?utf-8?B?L2NpMHFyOExKSGpxN0N0ZlpTelFsY3ZRajc3KzdUZmk1bk1kWlhlUXBlMi80?=
 =?utf-8?B?dmd2bVZqc25HQnh0U3VXUmVwanE1YnQ4Y1ZFckg1WVVwdlZCaHNadHRnSUxB?=
 =?utf-8?B?UFUvSlNyUWVQTnh3YUR6czhKTWNrYmdhSWorYUZqWGR2K1k0ZFJzUkMzRlJE?=
 =?utf-8?B?VWpwUkZSTzlXRTFGYkFuakVSMy95TUVuRzFqZjFPaGo3d2p0VnhTcHF1UWZh?=
 =?utf-8?B?ZjY1emtFTUlUTmJseTBpSmpGZy85dllRQU5qSHZLendqSldWMFFaRHVpNEJj?=
 =?utf-8?B?MEgrUTNCM2N1Ryt4S1NFd081YTMxRG40cHFScXpIR0QwZXcwanZOaGRPNzBk?=
 =?utf-8?B?T3ljdFp6NzNYUVhKR21FQkZpVWRoMG5tYys3a1VhSG82UmphZ0xVN3pDbE4z?=
 =?utf-8?B?OG80MU9qZDBadUJrOHBhenJ1UVRHWStqRkdTMGhEeDZrNU1WS1NsWldFT01N?=
 =?utf-8?B?bmlrQmthQzduZmFXdWQ4cTM3T1Y5R3JrZVQxZXJmd1hDWVhvVHlXRE5xYnpQ?=
 =?utf-8?B?d0ErSnFmRzZGVlBadjNpNStTUVR3NGFiUTNVVFlQbmdLYmxyd0ZrNWxuTDQw?=
 =?utf-8?B?MUMyajhuWkFZRzlQZ3NJVkYrcjAwN1Q1M3BsNVZnQUJKTjJ1RjhyOXBEQXBI?=
 =?utf-8?B?WHZjZ1diUXlGNnR0K2c2TTkxSmJlSmVZK1pYcUhHWGd2c2xhLytZcGVzekcv?=
 =?utf-8?B?NVdWOWtyc1pQUUlRbkhRUXlNcVBBL3FtMW5JcXN4Um9PUDRWL3pmSEJnaVNz?=
 =?utf-8?B?bmsrWDYrK2h3bHFmSnZQTFNYWTRKSWdNWndLQ01ITmR1eTVEN2x0TkhvOVpj?=
 =?utf-8?B?SEMvQmhhUE10bDJzNGxEMVF3KzZJQnN6emlvWWlJcENhR0pFNm1QaG5paSsw?=
 =?utf-8?B?eUhyaXF2ZXYzZGh3Yjc3N3JCYlArYnVoV0hFMFVOeVhwSk1obFczNWNJWUds?=
 =?utf-8?B?RXVuUHBrbE5oMXNTVFd3S0pIQVJIbkZtVXhUYTZYdzhPSkowejE0UFlHR2pv?=
 =?utf-8?B?SlluQVQyVWMyRTdjNGJvMVR0eXFiNjJZS3JzcE5PbWNPVXFzNXhLa1RoOU42?=
 =?utf-8?Q?X7Fow1GvV2IRCjBCxglrnwNWA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ff7b962-2d02-458c-eb71-08dc75427d42
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 00:52:41.1003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4KbvVYbkhB661hFxoZnn7WcWYYwzdL2uDaRTppqc5/cUqgax+JyUbm/VSwpQXg09ht8A2KX3CRGF/4GF80lzKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7520
X-OriginatorOrg: intel.com



On 15/05/2024 12:59 pm, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Allocate mirrored page table for the private page table and implement MMU
> hooks to operate on the private page table.
> 
> To handle page fault to a private GPA, KVM walks the mirrored page table in
> unencrypted memory and then uses MMU hooks in kvm_x86_ops to propagate
> changes from the mirrored page table to private page table.
> 
>    private KVM page fault   |
>        |                    |
>        V                    |
>   private GPA               |     CPU protected EPTP
>        |                    |           |
>        V                    |           V
>   mirrored PT root          |     private PT root
>        |                    |           |
>        V                    |           V
>     mirrored PT --hook to propagate-->private PT
>        |                    |           |
>        \--------------------+------\    |
>                             |      |    |
>                             |      V    V
>                             |    private guest page
>                             |
>                             |
>       non-encrypted memory  |    encrypted memory
>                             |
> 
> PT:         page table
> Private PT: the CPU uses it, but it is invisible to KVM. TDX module manages
>              this table to map private guest pages.
> Mirrored PT:It is visible to KVM, but the CPU doesn't use it. KVM uses it
>              to propagate PT change to the actual private PT.
> 
> SPTEs in mirrored page table (refer to them as mirrored SPTEs hereafter)
> can be modified atomically with mmu_lock held for read, however, the MMU
> hooks to private page table are not atomical operations.
> 
> To address it, a special REMOVED_SPTE is introduced and below sequence is
> used when mirrored SPTEs are updated atomically.
> 
> 1. Mirrored SPTE is first atomically written to REMOVED_SPTE.
> 2. The successful updater of the mirrored SPTE in step 1 proceeds with the
>     following steps.
> 3. Invoke MMU hooks to modify private page table with the target value.
> 4. (a) On hook succeeds, update mirrored SPTE to target value.
>     (b) On hook failure, restore mirrored SPTE to original value.
> 
> KVM TDP MMU ensures other threads will not overrite REMOVED_SPTE.
> 
> This sequence also applies when SPTEs are atomiclly updated from
> non-present to present in order to prevent potential conflicts when
> multiple vCPUs attempt to set private SPTEs to a different page size
> simultaneously, though 4K page size is only supported for private page
> table currently.
> 
> 2M page support can be done in future patches.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Co-developed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> TDX MMU Part 1:
>   - Remove unnecessary gfn, access twist in
>     tdp_mmu_map_handle_target_level(). (Chao Gao)
>   - Open code call to kvm_mmu_alloc_private_spt() instead oCf doing it in
>     tdp_mmu_alloc_sp()
>   - Update comment in set_private_spte_present() (Yan)
>   - Open code call to kvm_mmu_init_private_spt() (Yan)
>   - Add comments on TDX MMU hooks (Yan)
>   - Fix various whitespace alignment (Yan)
>   - Remove pointless warnings and conditionals in
>     handle_removed_private_spte() (Yan)
>   - Remove redundant lockdep assert in tdp_mmu_set_spte() (Yan)
>   - Remove incorrect comment in handle_changed_spte() (Yan)
>   - Remove unneeded kvm_pfn_to_refcounted_page() and
>     is_error_noslot_pfn() check in kvm_tdp_mmu_map() (Yan)
>   - Do kvm_gfn_for_root() branchless (Rick)
>   - Update kvm_tdp_mmu_alloc_root() callers to not check error code (Rick)
>   - Add comment for stripping shared bit for fault.gfn (Chao)
> 
> v19:
> - drop CONFIG_KVM_MMU_PRIVATE
> 
> v18:
> - Rename freezed => frozen
> 
> v14 -> v15:
> - Refined is_private condition check in kvm_tdp_mmu_map().
>    Add kvm_gfn_shared_mask() check.
> - catch up for struct kvm_range change
> ---
>   arch/x86/include/asm/kvm-x86-ops.h |   5 +
>   arch/x86/include/asm/kvm_host.h    |  25 +++
>   arch/x86/kvm/mmu/mmu.c             |  13 +-
>   arch/x86/kvm/mmu/mmu_internal.h    |  19 +-
>   arch/x86/kvm/mmu/tdp_iter.h        |   2 +-
>   arch/x86/kvm/mmu/tdp_mmu.c         | 269 +++++++++++++++++++++++++----
>   arch/x86/kvm/mmu/tdp_mmu.h         |   2 +-
>   7 files changed, 293 insertions(+), 42 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 566d19b02483..d13cb4b8fce6 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -95,6 +95,11 @@ KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
>   KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
>   KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
>   KVM_X86_OP(load_mmu_pgd)
> +KVM_X86_OP_OPTIONAL(link_private_spt)
> +KVM_X86_OP_OPTIONAL(free_private_spt)
> +KVM_X86_OP_OPTIONAL(set_private_spte)
> +KVM_X86_OP_OPTIONAL(remove_private_spte)
> +KVM_X86_OP_OPTIONAL(zap_private_spte)
>   KVM_X86_OP(has_wbinvd_exit)
>   KVM_X86_OP(get_l2_tsc_offset)
>   KVM_X86_OP(get_l2_tsc_multiplier)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d010ca5c7f44..20fa8fa58692 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -470,6 +470,7 @@ struct kvm_mmu {
>   	int (*sync_spte)(struct kvm_vcpu *vcpu,
>   			 struct kvm_mmu_page *sp, int i);
>   	struct kvm_mmu_root_info root;
> +	hpa_t private_root_hpa;

Should we have

	struct kvm_mmu_root_info private_root;

instead?

>   	union kvm_cpu_role cpu_role;
>   	union kvm_mmu_page_role root_role;
>   
> @@ -1747,6 +1748,30 @@ struct kvm_x86_ops {
>   	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>   			     int root_level);
>   
> +	/* Add a page as page table page into private page table */
> +	int (*link_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> +				void *private_spt);
> +	/*
> +	 * Free a page table page of private page table.
> +	 * Only expected to be called when guest is not active, specifically
> +	 * during VM destruction phase.
> +	 */
> +	int (*free_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> +				void *private_spt);
> +
> +	/* Add a guest private page into private page table */
> +	int (*set_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> +				kvm_pfn_t pfn);
> +
> +	/* Remove a guest private page from private page table*/
> +	int (*remove_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> +				   kvm_pfn_t pfn);
> +	/*
> +	 * Keep a guest private page mapped in private page table, but clear its
> +	 * present bit
> +	 */
> +	int (*zap_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level);
> +
>   	bool (*has_wbinvd_exit)(void);
>   
>   	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 76f92cb37a96..2506d6277818 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3701,7 +3701,9 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
>   	int r;
>   
>   	if (tdp_mmu_enabled) {
> -		kvm_tdp_mmu_alloc_root(vcpu);
> +		if (kvm_gfn_shared_mask(vcpu->kvm))
> +			kvm_tdp_mmu_alloc_root(vcpu, true);

As mentioned in replies to other patches, I kinda prefer

	kvm->arch.has_mirrored_pt (or has_mirrored_private_pt)

Or we have a helper

	kvm_has_mirrored_pt() / kvm_has_mirrored_private_pt()

> +		kvm_tdp_mmu_alloc_root(vcpu, false);
>   		return 0;
>   	}
>   
> @@ -4685,7 +4687,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   	if (kvm_mmu_honors_guest_mtrrs(vcpu->kvm)) {
>   		for ( ; fault->max_level > PG_LEVEL_4K; --fault->max_level) {
>   			int page_num = KVM_PAGES_PER_HPAGE(fault->max_level);
> -			gfn_t base = gfn_round_for_level(fault->gfn,
> +			gfn_t base = gfn_round_for_level(gpa_to_gfn(fault->addr),
>   							 fault->max_level);

I thought by reaching here the shared bit has already been stripped away 
by the caller?

It doesn't make a lot sense to still have it here, given we have a 
universal KVM-defined PFERR_PRIVATE_ACCESS flag:

https://lore.kernel.org/kvm/20240507155817.3951344-2-pbonzini@redhat.com/T/#mb30987f31b431771b42dfa64dcaa2efbc10ada5e

IMHO we should just strip the shared bit in the TDX variant of 
handle_ept_violation(), and pass the PFERR_PRIVATE_ACCESS (when GPA 
doesn't hvae shared bit) to the common fault handler so it can correctly 
set fault->is_private to true.


>   
>   			if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
> @@ -6245,6 +6247,7 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
>   
>   	mmu->root.hpa = INVALID_PAGE;
>   	mmu->root.pgd = 0;
> +	mmu->private_root_hpa = INVALID_PAGE;
>   	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
>   		mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
>   
> @@ -7263,6 +7266,12 @@ int kvm_mmu_vendor_module_init(void)
>   void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
>   {
>   	kvm_mmu_unload(vcpu);
> +	if (tdp_mmu_enabled) {
> +		read_lock(&vcpu->kvm->mmu_lock);
> +		mmu_free_root_page(vcpu->kvm, &vcpu->arch.mmu->private_root_hpa,
> +				   NULL);
> +		read_unlock(&vcpu->kvm->mmu_lock);
> +	}

Hmm.. I don't quite like this, but sorry I kinda forgot why we need to 
to this here.

Could you elaborate?

Anyway, from common code's perspective, we need to have some 
clarification why we design to do it here.

>   	free_mmu_pages(&vcpu->arch.root_mmu);
>   	free_mmu_pages(&vcpu->arch.guest_mmu);
>   	mmu_free_memory_caches(vcpu);
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 0f1a9d733d9e..3a7fe9261e23 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -6,6 +6,8 @@
>   #include <linux/kvm_host.h>
>   #include <asm/kvm_host.h>
>   
> +#include "mmu.h"
> +
>   #ifdef CONFIG_KVM_PROVE_MMU
>   #define KVM_MMU_WARN_ON(x) WARN_ON_ONCE(x)
>   #else
> @@ -178,6 +180,16 @@ static inline void kvm_mmu_alloc_private_spt(struct kvm_vcpu *vcpu, struct kvm_m
>   	sp->private_spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_private_spt_cache);
>   }
>   
> +static inline gfn_t kvm_gfn_for_root(struct kvm *kvm, struct kvm_mmu_page *root,
> +				     gfn_t gfn)
> +{
> +	gfn_t gfn_for_root = kvm_gfn_to_private(kvm, gfn);
> +
> +	/* Set shared bit if not private */
> +	gfn_for_root |= -(gfn_t)!is_private_sp(root) & kvm_gfn_shared_mask(kvm);
> +	return gfn_for_root;
> +}
> +
>   static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
>   {
>   	/*
> @@ -348,7 +360,12 @@ static inline int __kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gp
>   	int r;
>   
>   	if (vcpu->arch.mmu->root_role.direct) {
> -		fault.gfn = fault.addr >> PAGE_SHIFT;
> +		/*
> +		 * Things like memslots don't understand the concept of a shared
> +		 * bit. Strip it so that the GFN can be used like normal, and the
> +		 * fault.addr can be used when the shared bit is needed.
> +		 */
> +		fault.gfn = gpa_to_gfn(fault.addr) & ~kvm_gfn_shared_mask(vcpu->kvm);
>   		fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);

Again, I don't think it's nessary for fault.gfn to still have the shared 
bit here?

This kinda usage is pretty much the reason I want to get rid of 
kvm_gfn_shared_mask().

>   	}
>   
> diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> index fae559559a80..8a64bcef9deb 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.h
> +++ b/arch/x86/kvm/mmu/tdp_iter.h
> @@ -91,7 +91,7 @@ struct tdp_iter {
>   	tdp_ptep_t pt_path[PT64_ROOT_MAX_LEVEL];
>   	/* A pointer to the current SPTE */
>   	tdp_ptep_t sptep;
> -	/* The lowest GFN mapped by the current SPTE */
> +	/* The lowest GFN (shared bits included) mapped by the current SPTE */
>   	gfn_t gfn;

IMHO we need more clarification of this design.

We at least needs to call out the TDX hardware uses the 'GFA + shared 
bit' when it walks the page table for shared mappings, so we must set up 
the mapping at the GPA with the shared bit.

E.g, because TDX hardware uses separate root for shared/private 
mappings, I think it's a resonable opion for the TDX hardware to just 
use the actual GPA w/o shared bit when it walks the shared page table, 
and still report EPT violation with GPA with shared bit set.

Such HW implementation is completely hidden from software, thus should 
be clarified in the changelog/comments.


>   	/* The level of the root page given to the iterator */
>   	int root_level;

[...]

>   	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
> @@ -1029,8 +1209,8 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>   		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
>   	else
>   		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
> -					 fault->pfn, iter->old_spte, fault->prefetch, true,
> -					 fault->map_writable, &new_spte);
> +					fault->pfn, iter->old_spte, fault->prefetch, true,
> +					fault->map_writable, &new_spte);
>   
>   	if (new_spte == iter->old_spte)
>   		ret = RET_PF_SPURIOUS;
> @@ -1108,6 +1288,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   	struct kvm *kvm = vcpu->kvm;
>   	struct tdp_iter iter;
>   	struct kvm_mmu_page *sp;
> +	gfn_t raw_gfn;
> +	bool is_private = fault->is_private && kvm_gfn_shared_mask(kvm);

Ditto.  I wish we can have 'has_mirrored_private_pt'.


