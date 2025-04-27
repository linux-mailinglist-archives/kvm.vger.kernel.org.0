Return-Path: <kvm+bounces-44473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79EEBA9DEA7
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 04:27:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF23017F5FC
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 02:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABE6A1DF252;
	Sun, 27 Apr 2025 02:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hd8gMzAn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982CE10E0
	for <kvm@vger.kernel.org>; Sun, 27 Apr 2025 02:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745720833; cv=fail; b=XzApSg5sSQsnDxPE1rafQn8UpJxaTPycJ8SplOv05OO7YBJl96H6vheNe6XnJOSleIfKE0J5yPQaxQ/RymM++82BEEV+1EcmFIGBo/0s72kntMrVWLzj3Dc0aixc0Fy2Mn1pavIDwJ1kzRvBzsQEUsHPqOCpgqpbf/2e1QuSzmw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745720833; c=relaxed/simple;
	bh=ohGhC4nxkgvliUvalrALSM916H+Cc9KP45Xe3ht205k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aySTsawSpy1kWnDRyeQpTVJ26dqtqiHKFEB87qWXFiugJrCs6g8qVcVPc6HeoxCi23ivZFEatKOXD3eJeipVW/CaPhzitMF7+Izc7SC1xuzyTse4lWo4avVkyfooqJt5msEA3sxJsBQoTgEXCZ64ndLII8lXG31uIWbyvGzjlpQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hd8gMzAn; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745720832; x=1777256832;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ohGhC4nxkgvliUvalrALSM916H+Cc9KP45Xe3ht205k=;
  b=hd8gMzAnQUocLIXxeNtFWLBjUf309pRgNUQ8bTduc+TRhyYIsnSWVwkK
   IfTEYLjNJ/Lz6imSi9CGpRqV3CaeAaIoeNNAPhgRQCWEObD9hp9krhtvz
   +6YwgTZlBN/kERzmHVl8A5EZszdG36fUat5m7zynNcm5HjjP9QQnSKOSl
   jb0Z9wODX3Sz2zWf9rIHL+52v5qMIyQFhJBoXUIuzXBOO8Qwn5k3QG2ZS
   DZ1UuNsWY73PDTqAGaTenc9PyWJOdBPdW6Gyr3IN328SAjiyoPYG2buGD
   nV/v3SR39X/DbPKtvTCkbKWghTHXhO4XWfhNeNLtn50FOSTZ/Vc8qEsUd
   g==;
X-CSE-ConnectionGUID: ywhPFGrYTVexR7zi1eO1Cg==
X-CSE-MsgGUID: ppzFz3VqQh6c66oMxq63zw==
X-IronPort-AV: E=McAfee;i="6700,10204,11415"; a="58700666"
X-IronPort-AV: E=Sophos;i="6.15,243,1739865600"; 
   d="scan'208";a="58700666"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2025 19:27:11 -0700
X-CSE-ConnectionGUID: V/ajIFOmSBy0cidPwfC/Mw==
X-CSE-MsgGUID: ZZ1M2G7UTZqG7dvZmAWNxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,243,1739865600"; 
   d="scan'208";a="138364799"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2025 19:27:11 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sat, 26 Apr 2025 19:27:10 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sat, 26 Apr 2025 19:27:10 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sat, 26 Apr 2025 19:27:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PV7O6sfPDJN1xtHLm19EuxtHcADOOe+0o8uArRWsgUZ8O03YF0eMnrxDoH1XasIYEEJNntmImpsDKf2aQJYfdtPV4AkLCi5FkRKyBICHCuQpa1Eqj4hKvW59fFj+kAl/wKrRwZYOi0VFgfdEcHUYUjAJIPo5W0CaOK3pctYzmLAVJW0vCE4o45Bs5e/gtSsEsg/u/iwi+L15jY924Qg2exgleUFhXwV+2KGF4Jz6i0McNNuMs/3xiV5HjiGPbsbalEhzy/4ck5r+lP3AvT7D4BtZvO58d0yuRF+PRBeRe011jOz+YP3AXVYoQzjkw6j3LO8HFAL2JdR0iayy2a8y2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sH1btQOxBPI7BRTvmWiXQRmZWnVFSZDyPGSOVBbTmgc=;
 b=UGCEcayUDw6wRErSRotNfuRru8vdKbMcsHcqbBZK/vsf3Z1jVhcyXyaQuEJfPCQC2htv6lkcOkrofxtMFq2DHPeeKtl1tTtfg8CZ7pcmRQOsDZiogvhOtMKI4B3ApmM6xqkBG9JRFKLzWBV/lbgpyOb3YhfB5192aBHQp8ntw5OzGC7B9whS3yektBdaEMwP16b3JOmBuNDU3YTr5Sp4zLC6orX31VwLbgeoPg6vX+Xh80/em9ZnYTJ9w91sHYz/46u2QoxuKPiXNqlE/76s4wgRwnYHze3B1qGtjUX3uQlrBlOcKmeaM8HgpEML9FRTeVZlox7xgF+y0Uip63mkZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 IA0PR11MB7862.namprd11.prod.outlook.com (2603:10b6:208:3dc::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8678.27; Sun, 27 Apr 2025 02:27:02 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8678.028; Sun, 27 Apr 2025
 02:27:02 +0000
Message-ID: <c7ee2562-5f66-44ed-b31f-db06916d3d7b@intel.com>
Date: Sun, 27 Apr 2025 10:26:52 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/13] memory: Change NotifyStateClear() definition to
 return the result
To: David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-11-chenyi.qiang@intel.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <20250407074939.18657-11-chenyi.qiang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KU2P306CA0031.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3d::17) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|IA0PR11MB7862:EE_
X-MS-Office365-Filtering-Correlation-Id: 65b5215c-f317-405a-2982-08dd8532fe56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UWw4SHdET3JhSG9aeHFrT09CZmRhVFBUcDhiaTNvektVTDl4bW04aCtIZTNw?=
 =?utf-8?B?WDk4dmNMT0NTVkxVaHRPMURqd0dOYmFnRWRXV2V4bUIrcElLbUpyZzU2Q1NJ?=
 =?utf-8?B?WXp5dDBpbXdaaEJMOTNEWkRSczZpSk5UZEVxbldqZDBRbThMYmgxTnlmSnZq?=
 =?utf-8?B?TUpGNG1WVEVsK2dPRkNIR3oxcVhISWRadDA2eE1DQXNYdzZkcGd4VklYY2Zw?=
 =?utf-8?B?VmI4MzlNSithZm9TMGxBL0xvbC9GZGFMTGJnK2FraytoeE9sN1I0U09CcFRh?=
 =?utf-8?B?ZDFYSlhxbnplUTFydHNUZWU3V0ZHMDZVYkljcXp0ZXEwRlJWbXdueHREaGN0?=
 =?utf-8?B?RFcwaWsrZWZwd0YxbXhpQldBMkdjbVVqS1hkTVZQUDU4M1FrK092MnliSk5l?=
 =?utf-8?B?ZUNTc05TcDBzSyt1Tmd5N1k4UUx5SEYrTklscXNENSt2VkM1VXozNXJ4dVB5?=
 =?utf-8?B?S1Q4d3NNRi9NR0lPby9SNHZ2ZG1FUWxNU3YwMEJWdTYwZE9QZHRpZ1ZwSUU5?=
 =?utf-8?B?K0VHZDdyL0xiU0E5Unl6UVpYM1BWa1g1MzQ2T1U2b1IxRHVzSTcwWUJkL1Ez?=
 =?utf-8?B?dldLTFBLRElEdFNkREM0NjFRZmF6ekt1UDIwWGExYzN4UVBad0lrZWt6Vy9j?=
 =?utf-8?B?RjYrS3FSemJIR1pKakdvL3FKTWl0a0l3ZExhVjZMTFFJUUlPMWI5a2puSEhW?=
 =?utf-8?B?aHdob1F3VktubHhGNi9VWGYrMm04ZjBiVTNHUC9hbkpMNkkyQnNiOWhhekcv?=
 =?utf-8?B?bi93YkpsZDJvZ01PYmEyZ1lqbEJYUG5IYTE0dmtrRmhnWkJaZ25qSndUbWd3?=
 =?utf-8?B?N2o0dEVUVStvdXplRFRDYXJQMzZZeWluTEpMVnVGTDZRaUdLWXpFa29rMnV6?=
 =?utf-8?B?QUNPa09vM2JJTXMzRkRJeFgzaWdnVmduWDRieU0wUUlSMkZUWHVnM1RTMnB6?=
 =?utf-8?B?U1JTRStyMzZnOC9ZUjliTjhIS1RmTDUrb1FUdEdzRGdLbTlnMlZDUkx2ZzFS?=
 =?utf-8?B?aHR2RUFxSVBnY2ExS3Y4b3NIeXAxVm9ld3ltVnFwWVVoWVVaYnBnb3JRcG04?=
 =?utf-8?B?NUZ5ZStWSGtlUHBwZDR4aFVwMmp1czN3eGVWbE9CY2ZZOGZOSXV0Q2h1RnBV?=
 =?utf-8?B?QXBiN1lObTJ2bDUwS3U0cUh3Q1J5MXlJbjl4Zi94N1BTLy94alJqT2tCN2Jx?=
 =?utf-8?B?bVFwWXBsbSt5NTI5WXpkNWF2alVLRUFqVnk0WmIzdU9UdHJJYTk5d2NJUWM4?=
 =?utf-8?B?ZzRFaXJ1blU0Mko3UUFUNjJYRVVLZUlBV1VxcUhqcTl3a0xUUWNxNmc3UDd0?=
 =?utf-8?B?VVg4UFZmdHYzcnpKNENGb0xtNng5bVo4VGF3NFlSMjFZTllpTzVnWFFaSGFy?=
 =?utf-8?B?Qks4QmV1Y3VFaWxDeFZzNVpYM1pTb1hQZ0R5ZlJvYTd1UEx6SmVRR3g1TnVz?=
 =?utf-8?B?eFI5VUxJRWlFVnpWaDIzNklaems0aitUVHRxbWtneE0rbmdIcWVUN3hSQ1ZY?=
 =?utf-8?B?aGprZHZrVWhyU2JCZVJzQVR4Z0tCNkZ5ZDRUSmRWNkEzZytsOEJselh1WWps?=
 =?utf-8?B?RnJmQ3M3c1dOWjgzenZacmpvb3ZUZ0hXSmFWKzN6MUoydVVNejFNOUtaYVE4?=
 =?utf-8?B?QWtuTEFLbnhLbFl5MGxWM09pSmNNM3dBZWhSaldlbXJvaHhhRTIwSTZoYWNq?=
 =?utf-8?B?Mzc4SHhJTnB4NmtHU1RKcEw5Y3dBeVhkVk0yVGtrVjNIY2xxVk9ZQnRESDEv?=
 =?utf-8?B?TXZMT2FlekJLQXhIWUdRVnUvSFRnSGtaell4VXdNbjYvZmYrNEdZV2dDY0wz?=
 =?utf-8?B?aVBSU2hvNEw4WTIvNVo2NlIwbUhPdy9wdWpKdElUME14cEM3LzRueGxXc0lj?=
 =?utf-8?B?M1hYWjFIVW1lQ0VOTzRCeXhNQXlwSCtBbzdvTE8vV253U1BzU05KTGg0dnN4?=
 =?utf-8?Q?dXq4oFOoGdA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFBjMVlpQ003YTlNRTJCQXR0M0ZNdWx6RnM4L0ZMMHgxSmhRWDN4d2xjSjM0?=
 =?utf-8?B?dkZMdTBET016YnBJVVF3UUV3WFYxelYyYlFYTGUxVFF6Nk1TMWhXVmJKbHpC?=
 =?utf-8?B?ekxHQlN1UldHUWE3VmlLeW5RMkxxQ0NJM1ltUDJ4bEZSd1ZGSnJ5b2UyTmRt?=
 =?utf-8?B?dGRSUFRHd0J4b1lvUzVlU3hLUk5VQzFGT2VaaTR2TElMREkzbVprNjg2eFV5?=
 =?utf-8?B?ek5zZHAzc2NpODVBR1hEdU53cjIyS0RBZkJRdlpydGZyNVk1NHVKU0xpRmNW?=
 =?utf-8?B?WG1zMnBaOVFFLzRoR256aFF5RTR1VDhjU29YeXRCK3NJaG56QThVMFVMVk44?=
 =?utf-8?B?NjR5RDIrajVGNHRoMHJJa2RzdUNCWmtRNW1nQVlSTU5HbDZhcklIUU5JU0RB?=
 =?utf-8?B?UjdmMEZMaE1mdUErYytsb3d2Z0dxQTdsNUFUZUxpU0U1L1B3YnRqVDJrd3Vy?=
 =?utf-8?B?dHlJSFVhZE9GNklMMU5qeDRoV2RmV1lKaWtoQ0p4N0g1QXRJWXBlOG5PUElH?=
 =?utf-8?B?TzRGQWdQaU9zcGptZzF2TWw5OTNnZStxMm1RMHNsTUNsNmNKYmpibCtac1Rj?=
 =?utf-8?B?aFg5MEFCM3UxckgreTBuYnFRbGU0MFdwK29rQkJhM0FMQ3Q5Wmtia0pqRFFQ?=
 =?utf-8?B?UWpKZVEzb1MwUXFLUDVWKzc4WTRpRlU4a1pGWlkvWGo2eHFncTY1TnRROGwr?=
 =?utf-8?B?U2dGeWJKN0ZveWs3SlNKV2x6K3dPbVU0QUlQZ0lRRWJ1Qk1nYm5QdTU1OFha?=
 =?utf-8?B?RTE1UVE4VFBtRXRtUFlQd1B5RmJMSDRyd0JQRVZWSUVMTHU1Z2ZBWnZhZG9D?=
 =?utf-8?B?MDh1azNwSkZrRFg3Y3VjOFRlbFFnTmo4T1pQTTUyL2ZBTEQ0U1ZqWlBmTm1L?=
 =?utf-8?B?WTlzYzlsdjJ2NDBhUFI0d2ZWL2N1bU5iaTEvQlcyaVgxZy9VUzFnTmNZVVVl?=
 =?utf-8?B?eHYwMExjZE5xVThKTXZFOTMyRjhIaTQxRnFyRmJzU0hOZ1grSVpVTTVnQWQ0?=
 =?utf-8?B?Y09BTkNHbVdmSTFRWno5Mk05ajZtSDgybWlwTlBrQkxhQ3l5MkpPRTV2aHlS?=
 =?utf-8?B?MHROSUV0OHRuTm10T2dQZTVuS0w4Q3BJN2tSQUtFMVdUZERNejNPTjkxMU1U?=
 =?utf-8?B?UXk4QmVSelZsQSt6bU5ZRGkwL2o1WFpzdldTN1owUXY1dWVVWkFwb3RpRGwy?=
 =?utf-8?B?eWVjdTJvWDRCanNlMU9ZeSsrR0xNUUFBdXlROFBGK050T2VLVlk2VmNBaVdT?=
 =?utf-8?B?VEdIU3FaTTVEZEllZTJ4N0tSU0d3UFhuVWRCd09sN1V5NllITGJMdUtqRUpr?=
 =?utf-8?B?MDFPVGo0OWRqM1ZhUk96bjhPUnQ2ckhseVg2dUlNQVpELytEMW45Qm5pMDRr?=
 =?utf-8?B?c01YZXpxQTFxV3g0dktrSEtlb2J2K1ZsRVRmT2NXbEZxUHNMSy81SWRRaVk3?=
 =?utf-8?B?eFEzQlBlVnBUZGIxT2ducS9ZaGlHb2ZoQVE5MmNJcHN2SUIzNlRPZjYvbGFD?=
 =?utf-8?B?blduVjFidGJob3pLdWdFMmcwTjIzRHBRNUlLMFpETERhNzhjclNxbkwzeVJp?=
 =?utf-8?B?eTFNbE85cDdkQm1Hb3dJTTh2ZEJNRXVlSFVpNHZ4ZWN0ZkJaTitWNzBkdDd2?=
 =?utf-8?B?L2svTkp4VnQweUtsN1JYanpoYmlBWGIwRXpHb0poTUhGZ1lHT05ZUWt1cU1X?=
 =?utf-8?B?S0lPUllkNjlxSTZCbktqVHIzNytBNTZJY2Z6MVlpVWtxL0wrbXhrbk9wSTZ5?=
 =?utf-8?B?bnRaMUVhanRzNVdoQzVXOGhqRFdBMHBienV3OVNMN3grbktTUGpMYVpLZ2tY?=
 =?utf-8?B?TUljbVZUaVNUQVJpallTdFdSbUpNQWZzU00vK0NzQlR3OE1mUFIvcTNHeDZW?=
 =?utf-8?B?cU53cFVncDRMYW0wZzlLZlJyY0s3SGo4OWtBckgrUUdWSmIwU2w4M1k1Vkg0?=
 =?utf-8?B?ak80eDU1UDNwSFBvdTlPZWo4SjExeDF4ZG9oM291UVp5c21LcCtWeHg5VGt0?=
 =?utf-8?B?QVk4NEJ1T2xSdFVQbWIwQTJBeHBGdGxJUzVqaHg2Tk9JQVFYU3B5ckMzWXNG?=
 =?utf-8?B?NVZjdUx5dXk4V2pWbW5QeHlzeVIwUHN2Z21jM3NaSnZqQTFZQjJpc0NLanY0?=
 =?utf-8?B?WlBKVWZKNXM2K1ZYRWpYSUtBR3N6WkRIVG13alRWZnM4SzRpYS9mSCtCZk8v?=
 =?utf-8?B?QWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 65b5215c-f317-405a-2982-08dd8532fe56
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2025 02:27:02.1796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2McVCyZtgE04HccnW1MnY4JZlvQevLk7OA9c+R/9ZBtCTXxGrsN70hJOjj1YGjWbyeDkXZxS/vWXHM4ABMDnyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7862
X-OriginatorOrg: intel.com

Hi David,

Any thought on patch 10-12, which is to move the change attribute into a
priority listener. A problem is how to handle the error handling of
private_to_shared failure. Previously, we thought it would never be able
to fail, but right now, it is possible in corner cases (e.g. -ENOMEM) in
set_attribute_private(). At present, I simply raise an assert instead of
adding any rollback work (see patch 11).

On 4/7/2025 3:49 PM, Chenyi Qiang wrote:
> So that the caller can check the result of NotifyStateClear() handler if
> the operation fails.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v4:
>     - Newly added.
> ---
>  hw/vfio/common.c      | 18 ++++++++++--------
>  include/exec/memory.h |  4 ++--
>  2 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/hw/vfio/common.c b/hw/vfio/common.c
> index 48468a12c3..6e49ae597d 100644
> --- a/hw/vfio/common.c
> +++ b/hw/vfio/common.c
> @@ -335,8 +335,8 @@ out:
>      rcu_read_unlock();
>  }
>  
> -static void vfio_state_change_notify_to_state_clear(VFIOContainerBase *bcontainer,
> -                                                    MemoryRegionSection *section)
> +static int vfio_state_change_notify_to_state_clear(VFIOContainerBase *bcontainer,
> +                                                   MemoryRegionSection *section)
>  {
>      const hwaddr size = int128_get64(section->size);
>      const hwaddr iova = section->offset_within_address_space;
> @@ -348,24 +348,26 @@ static void vfio_state_change_notify_to_state_clear(VFIOContainerBase *bcontaine
>          error_report("%s: vfio_container_dma_unmap() failed: %s", __func__,
>                       strerror(-ret));
>      }
> +
> +    return ret;
>  }
>  
> -static void vfio_ram_discard_notify_discard(StateChangeListener *scl,
> -                                            MemoryRegionSection *section)
> +static int vfio_ram_discard_notify_discard(StateChangeListener *scl,
> +                                           MemoryRegionSection *section)
>  {
>      RamDiscardListener *rdl = container_of(scl, RamDiscardListener, scl);
>      VFIORamDiscardListener *vrdl = container_of(rdl, VFIORamDiscardListener,
>                                                  listener);
> -    vfio_state_change_notify_to_state_clear(vrdl->bcontainer, section);
> +    return vfio_state_change_notify_to_state_clear(vrdl->bcontainer, section);
>  }
>  
> -static void vfio_private_shared_notify_to_private(StateChangeListener *scl,
> -                                                  MemoryRegionSection *section)
> +static int vfio_private_shared_notify_to_private(StateChangeListener *scl,
> +                                                 MemoryRegionSection *section)
>  {
>      PrivateSharedListener *psl = container_of(scl, PrivateSharedListener, scl);
>      VFIOPrivateSharedListener *vpsl = container_of(psl, VFIOPrivateSharedListener,
>                                                     listener);
> -    vfio_state_change_notify_to_state_clear(vpsl->bcontainer, section);
> +    return vfio_state_change_notify_to_state_clear(vpsl->bcontainer, section);
>  }
>  
>  static int vfio_state_change_notify_to_state_set(VFIOContainerBase *bcontainer,
> diff --git a/include/exec/memory.h b/include/exec/memory.h
> index a61896251c..9472d9e9b4 100644
> --- a/include/exec/memory.h
> +++ b/include/exec/memory.h
> @@ -523,8 +523,8 @@ typedef int (*ReplayStateChange)(MemoryRegionSection *section, void *opaque);
>  typedef struct StateChangeListener StateChangeListener;
>  typedef int (*NotifyStateSet)(StateChangeListener *scl,
>                                MemoryRegionSection *section);
> -typedef void (*NotifyStateClear)(StateChangeListener *scl,
> -                                 MemoryRegionSection *section);
> +typedef int (*NotifyStateClear)(StateChangeListener *scl,
> +                                MemoryRegionSection *section);
>  
>  struct StateChangeListener {
>      /*


