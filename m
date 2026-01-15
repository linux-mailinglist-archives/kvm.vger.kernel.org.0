Return-Path: <kvm+bounces-68277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id CB250D294F3
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 00:43:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2A1F43015A4F
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 23:43:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 044C2332901;
	Thu, 15 Jan 2026 23:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JuG5GIad"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47CD330B31;
	Thu, 15 Jan 2026 23:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768520594; cv=fail; b=ejwLGYpa1YfBy6TUbbSkgI0t491rk+FVdPIsqDbo5Sp5qWNhmMSaETTm5Oer9XmLz6qoSnCjqVUBlMD281HO4Y9TGyAKgLP7WqNCckwDWtToyhkwy46lLMSchTGFl6eKAZoxT6jl6HQchEd54Dzv4k1BkIw+GX6o3WEPqbyPX1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768520594; c=relaxed/simple;
	bh=Imlo5kgq/aQY4wlCjyiZWXAuMaKuKGmbXS9r1PUrt7M=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=E6fou3np/NxPUyeAElmIaXqvPUB7jSTO1KycFrKHYhA3LRd2T7vyJAPj3liFPZCUd5CFL6CREGAXgrGtymu1wEvJsFFbSn+y86dUeyOGDzY7RNHkPlR7g6dRK64lwrKl0N6sKYqcRPkTBeYZFpWfJWbZsvjj28ByVrMiHRpT36E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JuG5GIad; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768520593; x=1800056593;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Imlo5kgq/aQY4wlCjyiZWXAuMaKuKGmbXS9r1PUrt7M=;
  b=JuG5GIadzygK7zQ1gs/99z/oR4xr//UvHMpxcWMOQitFfnj0WMfm2fI5
   Mzd5FPGPnudXYXpnd53K8b2rUnDolGJ/1XJU8p35K5j+d/Rw8JH5FgyXh
   RUesHJirNVteHa1H1e5untTb4HZIu0gS1LOse95IBy41lpI1wTH9Svrkd
   NEGRADBZG7/kcD4svzpzKL0B+x6ksh/Y5sZOrztQVDUFU29vPwuKHI0Y1
   VJjXuzrzSVWazA7DUHCGQrqkEqdG+ew/Nv1fXC27Lv44KrjWjlzBWOj3l
   CM044LMWo9Ka1/wGDVuC1Opypov0VkppIEGspdiHi8HSwb4ge2XKyF8WN
   w==;
X-CSE-ConnectionGUID: DSavM+vcSB+dP43Qu65u0g==
X-CSE-MsgGUID: OK+Vew0iTNi3/avYodlw4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="69570101"
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="69570101"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 15:43:12 -0800
X-CSE-ConnectionGUID: czLYZrueS4+zRPg/LWuJBA==
X-CSE-MsgGUID: tRsD4OaJSX+GHV2bYVAW7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="209573195"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 15:43:12 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 15:43:11 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 15 Jan 2026 15:43:11 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.8) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 15:43:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dmzm3RVZ6n4aNHC9gFOq24LvKsHAdKgTyes6TnOTHOjnCSserkftUwmXx0XtvC64dXjWUvuTyJUENyeZm5Gm42IwhTenhqqz5K6XHpvbwGfavVw756LTBmMeIIlGcjBXPHX9g2xdUlCC6xvDEdWzw/hgxjzZDRfCC/2CYAtv79gt3pO+ogVvq65FXhOgB3QL4i+/lTc3lOIutaUiJ1+0CR4txZYnIyLoac80PcP0n7wyZQD1z89zy0ywDGmNoBvbm9HlLuJP75RAXvhQWqNLjr164CxS+rFbPNAXkRFeqk9UhzGQxPmNDG8x7K+btnyth0kUZzMoyUZzKNET1KabFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ounn6VZ5s018YkUglHNh9JP/x42mP5xqaR9BxU61lHg=;
 b=k+umyEOxDupjp9LJAZPjCegjebht6m75zxUygBfvvjKCDT3NFFh6FLpnOT0Q7aQx2gzVaXbk/2Tr/vdtSm7001fIo9fRmnFwXKDjjEMFmUbD1Crn1wpVkCJkkeoF1kzbxBIhTfVIh35EoT+vw0jdoN6PRpks3MNDRdH7KKseyZvA8WmeIrYz/mF4DdFOFmYhNZmWXmZonGL++Jg/eSrnkTsphLzfjsMIgIXlADDph1QlZjjTu1te/Swilo2Ixbk7Nj+QRqkF+IZBHzyYCYiOVT3hhceEuiWNLdeF+pnX8QxKJS8OaWdnpX7V8ibewMgznsO9slvWYTbvz0F0yBUEng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 DM4PR11MB5248.namprd11.prod.outlook.com (2603:10b6:5:38b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.7; Thu, 15 Jan 2026 23:43:08 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::60af:89a0:65dc:9c84]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::60af:89a0:65dc:9c84%3]) with mapi id 15.20.9520.005; Thu, 15 Jan 2026
 23:43:08 +0000
Message-ID: <c0651275-b233-42c3-b6ee-aee5ddcc0a05@intel.com>
Date: Thu, 15 Jan 2026 15:43:06 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] x86/fpu: Clear XSTATE_BV[i] in save state whenever
 XFD[i]=1
To: Dave Hansen <dave.hansen@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: <seanjc@google.com>, <x86@kernel.org>, Thomas Gleixner
	<tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>
References: <20260101090516.316883-1-pbonzini@redhat.com>
 <20260101090516.316883-2-pbonzini@redhat.com>
 <cd6721c7-0963-4f4f-89d9-6634b8b559ae@intel.com>
 <8ee84cb9-ef6d-43ac-b9d0-9c22e7d1ecd8@redhat.com>
 <f130ac18-708a-4074-b031-9599006786d3@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <f130ac18-708a-4074-b031-9599006786d3@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0070.namprd02.prod.outlook.com
 (2603:10b6:a03:54::47) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|DM4PR11MB5248:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f7e6b99-82d1-4d5c-8670-08de548fd625
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UCsyRWFBSkptSXJQeWVFcmNka3ArTFJ1N0R1NlZCK0FRdE1zSE41UUVJNUo4?=
 =?utf-8?B?WU53c1phak01MC84SzNlRjVqbU9DQ2Qyd0xmWnZWVE5IMEI0ZlhJeDVJY3VT?=
 =?utf-8?B?M3ZTYmZEbE9zd2kybzF1ck4rcHlZTTZvMlVUU1pIczVRc0IzYjJkYWcybFo2?=
 =?utf-8?B?Z2RuR1p3UVRBeFNkVm44MkIrakFibUxDNFhlRmYwMnlRa25QMEpQOFk5ZkQ0?=
 =?utf-8?B?WDNNVnZqMFc0RDlZeTNTeXlOQVYxWFYyTHRLbTc3b1hiOHowN2lrWEQyM0tZ?=
 =?utf-8?B?RzgzYVA1cUZoWC92YmlSWlRxUENTKzhkck9WbTlFeVBYUWxMUzhCa2VBZHQx?=
 =?utf-8?B?Y0ZGRGp3NnIzOVFwU3dhZDRqVU43ZnBKR05NRnlaVzUzMGxRUEd4dE1rcERx?=
 =?utf-8?B?OTcrOXRrdzZmSWwrdEhqSEg3aXQrcGZ5eWxZQ0lMcFNCSm9lSUVnQWs3RjE0?=
 =?utf-8?B?TEtaaTh3ZGZUalVyOXN1anllTmozK3lqRjh5UzdKcllWL3FrSDFwaEMzdndW?=
 =?utf-8?B?bzB1SUFhTTN6dXRnSlEycGM2Ynhkb0pjQTcyN3BoM1pMK0h3MGZBMEYyYzg2?=
 =?utf-8?B?R2gzejdMUXdsTkRzV0dXNlAva0NiajFRb3VhcHI5Z0J4Qno0UWZFdERWOXd3?=
 =?utf-8?B?TnZiS09RVlFQWDJJcGdtVEFIWmZ4cEJtQlpzVUdIWklUREtwcENweTgwOFAx?=
 =?utf-8?B?cWVCa0diSzFWUWtuM3h1TGRpbGFCckpWdGJXR0lBZkh3aSthOER6Mko0c25n?=
 =?utf-8?B?bUdCS1NDcVNwMG5JWWQ5dTFXcFpFZ0Q1NmFMVTBwNjZPRURaY0w5Wk03aDl3?=
 =?utf-8?B?MENtaHQ3bXFQd29haVlJdEdVQ3BoS01JQUxWdjRlbVE4eEJXbStCQXMrWWVL?=
 =?utf-8?B?T3dkU1VTT0xLTmY3K1ZzYlY5UmtEYzVFSWV4cE05QkJxeVFIeDRTdktTUkJx?=
 =?utf-8?B?WTZzRUZtNEhjWElqSnY0a2FLeDdYaFJWQ2JtWi9yRWZBRnhzWkgvYVNocUZm?=
 =?utf-8?B?MW5ydnRyeXVRa3o1Z2duTzE4QlV1Mzk0bzZlbThxbjhjUUgwSVc5aXFlUjA3?=
 =?utf-8?B?akpiNmRuTUJHMWdHOSs2eExRYWxPNTF1OFdIK0ttS1JzaGJZY3RDYUc5T1hF?=
 =?utf-8?B?MFgzMHJBU3cxK2w5V1dUTWNTdjRqNzVQaTBWRzJoZzVzUVVHaXVlYUpJbnJI?=
 =?utf-8?B?VkNoTmVxU0pJeFFJZi9nWlZ6U0JRU3Fybk9sajUyeFVwcVA3OU95bUl3M2hp?=
 =?utf-8?B?ajRicGhMcC9EazRNTE5FL2VZL210OFdMTjVHaW9JWkVMNkdrbFlNS0dJaWYx?=
 =?utf-8?B?T2xjQjZOTjJTdTZCelpBaVhYazE2K1lvUU5zaXcrUExrZ3luZnR3ajFWc3BH?=
 =?utf-8?B?TXA3V2JDWVZqdFJaTVkrb1hXVm1CaHhNTzBSczNxeW1USXFTVHdEa3NyRjFC?=
 =?utf-8?B?OTBPb283dHJ3MWIwS3h4RzJuUEZ2TmlTWmw5TVZ3aEdUTHZYL1d0WVlmZnRl?=
 =?utf-8?B?N3o2cDBDNDBsOWcyUmttUEdXdDZETXRkaHZYSGZ2WU5jdFVMVkJnbmxMeE5x?=
 =?utf-8?B?dkI5d2RGU1FEZm9TTWZ2STdkZkFYZUpRRXozL0p6SEtIZXhrWjF3N1QzQ3dZ?=
 =?utf-8?B?aVZlZ0xwUmk4aEtlY2hPazFHY3B6RFRxK2FrNFNjbW9ML2NFUWErUEYrY3JN?=
 =?utf-8?B?ZHJpcXNxcW9tUTkyK29TemJRNndtMlB3NVhDZ2prL1kwME41NDhNVkFFV2xU?=
 =?utf-8?B?WWtyTVdhaE8reE8yYVNzL3RLdjl1QjJ1OHZqYjJGL0N3bHFKdDZHL3NWb3dE?=
 =?utf-8?B?ZnZ3clc4b2NtZEVNQ1ZpUE82Z2RzRVI0ZUNmRVpReTllSDZ2YWxjNExFWlJv?=
 =?utf-8?B?Um9veElPZUczTE94REFKb0t1aUd4VlJjZHVUZVJJOFYreFc1Qnk4SVI5Q1VH?=
 =?utf-8?B?V0VnM20xK3N5RkNoL2NRb2NobXlhMHdRVTB1MkdCdjFXbEpNZ3ozMExpcFFq?=
 =?utf-8?B?WkQrb0h4ME14WFU5K2lxRHQvMWg2ajMzOWRPSVAwSVhOMllxbklQM2pUZGFo?=
 =?utf-8?B?UmNLQWtXWXp3MWRRdGorcmZGdUF2ZXJBU29EYWN2eXZDYlFSZmV4QXIzQjRM?=
 =?utf-8?Q?sDMA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OFNGYUw0eFEwRTZFNHQ1THNETjBnTGNiYXAzQVNnb3B0ZnE0cE5kb1MvWG9C?=
 =?utf-8?B?elJIR2xpYmtlNzl2b2hzbXFEeVN0VU0zSVB4R1pyekxvV0xWWnA3djNJVXY4?=
 =?utf-8?B?L2dqcnJwMURVdzlkUUY3ZWFDRVdQNGpIUHl6L2NkQkJOVUViRWg2dE1XSzdn?=
 =?utf-8?B?V1ZaT3RZbWlVbytCanVrcHJjcmlzNGFJaFdYRHh1R2tBWERFMnc4U3JXTkIx?=
 =?utf-8?B?d0tRcUVncExFQ3ZyTENFWXlKRk1ockQzeXhUa20yakNmK0p2aUNCeHBQeXo2?=
 =?utf-8?B?VVE3ZkUxUURIRjI0TG5JZk9PSWM1emZkQVVUUHhGUmdERTMxbjBYQytKeHZU?=
 =?utf-8?B?NktCZ01LVzN1YkhUWm1jYmlDSE5pY2Nsc1d4N1E5TGNLUzBvYTZFL0lUZzhY?=
 =?utf-8?B?TENxcWl1Nll2Q1kyNjNrQVdZMEFiZDE1c1l6TitoZVlPV015RjcxUHFIUkV4?=
 =?utf-8?B?d0ovdWpMbEhyaGxmbHdNdUJrQzRFUkV4aEh6Y3dvZTR3MHpGemZCREVxTGpa?=
 =?utf-8?B?V1psZTF4NUVsK0hDT2F0RFh4MXpHUmlrWFlzWnBCeVpqbnN5OXp5bW5RQjYy?=
 =?utf-8?B?MDh2TUtjZktPUUpSNVJCV2lKbUJ6aEh6RWh1UW8yZzBhdkliM0RVZUkvL1c5?=
 =?utf-8?B?SXJIb0ZOSmpDL1F1STl3aE42NHZ6U2gvbHdsWWZ6b0l6ZmhjS1Z0OVRHdWNB?=
 =?utf-8?B?eXNkSGVCdEl5VnFmRVNoVXFHNTdZTERLUGQ4V2x1ei84b21Ybk5tcnU3U1VT?=
 =?utf-8?B?T3JER0dMaDJmemt6VTVuaHVzMmZPYUJQMzBBQlNiSHgxTW5SL1Jxak95RlZi?=
 =?utf-8?B?bkNHQ0NIdzlGNGVUS08xMXNDcWpjNVdDTEhTemhIT3NDZFg2QUt6T0xlYXRw?=
 =?utf-8?B?dGc0d2dLUU1RclUxaXFZZ1RPemQ0aWFMVTgvdE8vRUhwSFIxMlN2US9ySUJM?=
 =?utf-8?B?MG1iWStrNklyT1VEbWhkS05jVEl4ejdKNGZlQWV4d0VHZXVpUlBXa2Q0cWFZ?=
 =?utf-8?B?dW1rRTBCVi84dE93dGcvYlduQkhqWkZLUXBVNlByNnhuWEdnQ0xDVnl6Wi9T?=
 =?utf-8?B?bFJDc2JpQ2xrcGZOQVI4WUhFQ3hzcks4S1kxMzNIQVNSZUxOUVpJTkZHN0pu?=
 =?utf-8?B?NnBGcTZzbldNa2l3MzlzTktxN2NscUhwNzROdXBoSEpabVJtUnFrKzA1YnVJ?=
 =?utf-8?B?L2JXbFAzaERscktEN0xxTUU0NVhwWUlxUy81Q0t2NDJWVjMrVTljVVgwdHQ0?=
 =?utf-8?B?NlJ6RjZmYXBPTGhkK0NVdURZNkc3Zm5QSS9VRjk0TzZKM09nU3U0Z1F6WG1w?=
 =?utf-8?B?OVVFNEJRNkVmdHIzQjB0Slo2VkxnTVBVR1NjcXpwbVo1cEYxOGdZN25aNkNh?=
 =?utf-8?B?TXQwZVhhNExVRFZwRWZDNzhHU09RQ2VkZHdBa0doNFo0TklUckZYeEJNM1hS?=
 =?utf-8?B?bmxsNEZhcnFCTjZyelBTaUVseFFodEhQeUVTRG92S1h2cFdjdG4zcFkxa0JH?=
 =?utf-8?B?bHZxVXcrdDVYTDQySU1wRUd0SjZ6ZXU1NUhCZGsrWS9TTWRTOVU2bjhPZnMw?=
 =?utf-8?B?amY0MDA4bUUrVjduaUptQmlHSDYyemVZdExoKzR3NTF3YWNDdUVmV1ljY1lF?=
 =?utf-8?B?QlNrRDVYZk9TT05QT0JOVUpKM29YNTd0VzZJTDhtc0xPYzdSQ3pCdVVtbDV3?=
 =?utf-8?B?eDM0aytGczc5eGVyd2NXdllqRzlEQ2hTK1k4Ty94Slpuakx6Zmc2bUd1aWts?=
 =?utf-8?B?MUZGNkRwL3Y5TGN1cTM0cklJZjFESVd6ak04VUI5dFJNc3BscXpzY0ZTalRG?=
 =?utf-8?B?eUZjczA5ak9wbHpWbDFsRU5GdWlEbGRLQWVVYTRadG02VEtDTVRJYUY3eFlC?=
 =?utf-8?B?ZDVJNlZqL2ZuOWllUmVzcmU3RHVFQWdabWh2UDNoeDByRVBxN2wwZ05xN1VU?=
 =?utf-8?B?ZXBGYURld3JTbldGNjQ1SHI3dnFWN2pPL1lMa1dUdDAxNkRQd0ZFK0ozcG1V?=
 =?utf-8?B?cGFPU3VrQUZUMTg5VzRoL0E5SUs4amFXcFpWeExuWG5ybUR1NytjaFFOa21i?=
 =?utf-8?B?eG5ZK1luQm5ON0ZNQmFoOWg3b1RQK01xRTIxcUY3cm52MWhDSXNXREgxOU9L?=
 =?utf-8?B?ZTRmNDJITWVUSHdZZlZHYjYwWnQ0Wi94ME5tRDM4NHdLVjMrOTV0UEs3M3cz?=
 =?utf-8?B?RFd6TWtrYmJybkFEMDdBSWNEaTZBL0RudC9hYVY0UmRQSDZGS2VoNVpiSE5E?=
 =?utf-8?B?QzBUMTh4bjdlY2ZHZ0ZxQjJpNWlVclp5TVU2OHM4OTJLMG4wdU1YZ3FXNldq?=
 =?utf-8?B?QnJhS3lGblpaZG1uQ20vd1RpYXJlMHp3Uy8yK0R5OGxhZjRwNFJrZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f7e6b99-82d1-4d5c-8670-08de548fd625
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 23:43:08.6045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vkv2CGHDVWTFjgjawmvrVy1/Zyh3m5u5Y+RWRmqHL5lwoQdZeYDJNJKf9S21DV0Xpy7YQyoXjX8P8v7uKlCGrM94/4/PK/Cef4yxtldGnq0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5248
X-OriginatorOrg: intel.com

On 1/15/2026 10:19 AM, Dave Hansen wrote:
> 
> What would folks think about making the SDM language stronger, or at
> least explicitly adding the language that setting XFD[i]=1 can lead to
> XINUSE[i] going from 1=>0. Kinda like the language that's already in
> "XRSTOR and the Init and Modified Optimizations", but specific to XFD:
> 
> 	If XFD[i] = 1 and XINUSE[i] = 1, state component i may be
> 	tracked as init; XINUSE[i] may be set to 0.
> 
> That would make it consistent with the KVM behavior. It might also give
> the CPU folks some additional wiggle room for new behavior.

Yeah, I saw that you quoted this sentence in the XFD section in your 
other response:

	If XSAVE, XSAVEC, XSAVEOPT, or XSAVES is saving the state
	component i, the instruction does not generate #NM when XCR0[i]
	= IA32_XFD[i] = 1; instead, it operates as if XINUSE[i] = 0 (and
	the state component was in its initial state)

Indeed, I do applaud the idea to clarify this behavior more explicitly 
right there.

Thanks,
Chang

