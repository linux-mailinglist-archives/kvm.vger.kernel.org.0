Return-Path: <kvm+bounces-54387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FF1DB203D0
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 11:35:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC39E1621D6
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 09:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35D6321C190;
	Mon, 11 Aug 2025 09:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F4JVoGDQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D4D70808
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 09:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754904805; cv=fail; b=FFjODDfv5hP+g+8gEmVov5cNPcpC0fwcHsOAD42qTF9ZLZp5RidK7kP57ydJwOru5SGSKNqddg2Qrc0N6DaYk2DVNIssXO17e+23pR+fQYNc/MBJrNt9+OE924SAI3TWhC7xxiWYr60aZ7VnaRfE6k8nVmjO5fLjw377DR6QW2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754904805; c=relaxed/simple;
	bh=i2m5Jy0mN5m687BGlU8qN4smFJ7PLLy4TDC7pJbtUZM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=j22P5pfaK+RT56mKVW7HPWI4r6+JDGdB436/Ecp1Plolg0DoSRoZHl/fvt4/ssYOIlXNmjcRIoHSj2nhn2n92pfzD8jdL5YjUuLcFSlbnW61JeUrbsgubuAlpOFW1Ola8x7M+gDUy6MoW3W3WeFBFRwOezQzYzzXv7DfHiMfE68=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F4JVoGDQ; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754904804; x=1786440804;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=i2m5Jy0mN5m687BGlU8qN4smFJ7PLLy4TDC7pJbtUZM=;
  b=F4JVoGDQpdBwe0Q3JW+GCnAb4XIS9kPnylkn6GxroFOtbPcZpWNW0jZO
   Qpj6r+9+usohEd2S1C4uk2tv4zBgIfo+KmwjQ3fA2iT+PzQ//82vc2zLg
   r9pWgOFbIqmHum+ctveHX5BlVvCva7mK1oWn9r6oE/WEffHKCMB3klVY1
   r7rQN0YG7WxLPy9p4OYL0Kxcj7QQSV8pkWU+UICCVwC38h8ed/G0JrQ1v
   RkbTyyNRKfBWR6wI6d0ecR97KhroPzf5JSfecB5gDBQcPhDoFq7+QngEF
   K7b5EGCm0imY5eNME8HdEkqQjzeoeD19+I0M6Y0+rR8IhptHGGQaE9g85
   Q==;
X-CSE-ConnectionGUID: PTPkkrJFRzKBOLksB45vrw==
X-CSE-MsgGUID: Wa4jcpvrRsuvHCuRhbY+Bg==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="68522274"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68522274"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 02:33:23 -0700
X-CSE-ConnectionGUID: ChjIcq9uRiqfS25kma1ttA==
X-CSE-MsgGUID: fZV0D7leSkWPSnEuoLxk8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="165517896"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 02:33:22 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 02:33:22 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 11 Aug 2025 02:33:22 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.78) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 02:33:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hzWt0ApaFYatsqkodIX1/x5n2DJ++tXYAsJASW6A+7zr4hmwWfNJ5m1xsa19/IXv/W0L2OU9CEhXFtx2gND8LGMYToIue2cKMrxvDAf2lq9vjkDRZX3s/yNa7mRRSUJkiz1gJCJU+GvxQAm9hWfPhIJkCjYiktL/Yz2RNVDVDvlp40eBCbBeBbhHqaPCO98VGxhLFHpTq8TpUK6kn2iZgcX6trL7ORTSKLCLJIK3ogjXRn+M40SdnOsVjoHbCt55hDgg8+CVnuRy2oTSWF52+AIs64mmmaytxGor1COwgsPWNpkbfPkWBfjoca4LyLT+fzgF5BgspxnPdpq07KDYsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=51hevvZ6Vqk3rZwY1nERotVpDeJA5O9yGYk16WurQd8=;
 b=Fp5MEpVcm+DsDd64gXqva9+hEvJI6gUNlrG4Ng6yO7Esk/WL9DAOEuonCFYTp54ZwXsVEbJ3x79dfMsmOONCAegyS2fErJ0Mg2pna49ufSFNnMqWEG2mz2riF22tfxBxZxxUJDdEZqYECrsxyDpPw37WNjMQSYnKkEZbECiD1zAsQ69HiQzSfyaNBX8tr2NrqQwUkyfvQKwUBpy3bKVFEaqrig3SlmPcMGIMz0Fc0+NExUrqMgZpAdolH0THZ3sqj4AroEEUpuvcjjHVTBlXiPIuFDpXnbsIY7E0bA+dS4QWrX9dQXUaRz8Y/RpRxH/KK6HlTrIhm5bZPjjG57oJAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 PH3PPFFA27DACA6.namprd11.prod.outlook.com (2603:10b6:518:1::d63) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 09:33:20 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 09:33:20 +0000
Message-ID: <b1700dcb-7929-4973-a180-365c64711070@intel.com>
Date: Mon, 11 Aug 2025 17:33:13 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 2/2] nVMX: Test IA32_DEBUGCTLMSR behavior
 on set and cleared save/load debug controls
To: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>
References: <20250811063035.12626-1-chenyi.qiang@intel.com>
 <20250811063035.12626-3-chenyi.qiang@intel.com>
 <9f1ba406-7638-44e5-bf0d-8aa27be24a59@intel.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <9f1ba406-7638-44e5-bf0d-8aa27be24a59@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR01CA0157.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::13) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|PH3PPFFA27DACA6:EE_
X-MS-Office365-Filtering-Correlation-Id: 9079d0c8-6128-4ba0-5457-08ddd8ba1ba5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SWs3Z3NHOGlEVXlOYXhhbGpyTHV2VzFUZVFpK2JBZ0MxRkhkaVhscFltenpX?=
 =?utf-8?B?cEpzVHF3dTNnRytIbmQzS0JIalFmZTV2K0VFQUF3c0phWElRNFhUZFhXTjNU?=
 =?utf-8?B?eW1aWUc0WXFxZkU1SGNyZWFvRXZMbzdUVUc2S0dxOEV4bTF6b2p2NW8xWWxM?=
 =?utf-8?B?V3NXOThmQjRoVDBjdWFFWEkwOFZzUWFHQ2FkY1dGYkxrelNSY2huNVI4UUNm?=
 =?utf-8?B?eWZPcG5NRjdzTDVraHZZSThNVkw2dm01eEZZRUFUeHNXcXA1a2JPNng5QkFi?=
 =?utf-8?B?Ykt5YUFIZW9idTRTTzFzVnNleXhqZVFmSUlzYVdEQXdRWkZ1bGhBVDNvelZn?=
 =?utf-8?B?WUQxeEtzOHVYSlAvZWRxSnVkeVZvc1FLQ01XdmhrMVlKVkpsZU5UMFk0cTkv?=
 =?utf-8?B?dFNOUU16clJNcW1LdWNXRmhqaWxxRU5qTm1hcmNkU0IzN2pqRkJ4b0lmZkVP?=
 =?utf-8?B?WDZnQVIybmVqa3Y4WmxENDlqWkZFbjlpbWJZUjk1RktTVlQ4SzE1emxweXNW?=
 =?utf-8?B?RnlPMTAvdXBqQ3lTbGNvWWM1MC9XYnRmQTlEY0w1QUZ6MnVaSmxFVXRnb2dt?=
 =?utf-8?B?dWlBMStJaVoyV2hzaFp2QWhyelBIS1A0MHlycEJvRDM1VDJKYWIvcm5Ia0pF?=
 =?utf-8?B?eDdyZlNwVTU1ekU0WS9jaGNKNVY1WkRlaVNjbitaQkdhR0h1UVl2c3BTTGg2?=
 =?utf-8?B?VjJBQmlmTWpIZzllYldtSEwraVkvaFpGMHlkUHlqQVVJRDNBWUpNQ0htb21h?=
 =?utf-8?B?SDh6N2dydUhvaW9qK1Y4Sll3bGtqZUxpQWFDR1lVTXNuaFQwUStFRnFEbWxt?=
 =?utf-8?B?aGp5a0Fpd3ZSSENYMG9JMDRWWXNWWHFxM3IzaUlNdm51S2lWWTFvNkJRRTVG?=
 =?utf-8?B?eGp0aUpxdEx1Z21NSHdDVEtyeDdONFdtNlZLNGdsK2RZdWZ4VjdhMDdXbm9z?=
 =?utf-8?B?aFBzMndQNlMxQnFRUHNnTnNNWlZKMkNrYUdaV0dpNVdjZUd3NnlVRmdUVklx?=
 =?utf-8?B?SWJMeWloU2R1RWNZdjM3UUVpK2FuMHVXcWpZWDJ6QmVvWk52ZWIvYVQwcGZB?=
 =?utf-8?B?YUhXaXE0T05XYTZYNWloQy8wUm8rQzdwYVB3UW1xL09odG9KWWJzOEE0L2V1?=
 =?utf-8?B?WHpmNW55Q1hxRUVoSExLTnRXQ2lKQlRXRGwxQmxvalgxN2RtenV0ak1BWjVP?=
 =?utf-8?B?NG83M2UxMnNSakY1amdDbDBXeGxLUU96eGFTRTJhRWlaZDFxdkdLRG9LQytQ?=
 =?utf-8?B?WUwvOTBzaUsyMWYxRXZVTW1wVzZPcFhYbG44Z3dKbnVqemhmZDVVcXlRdFlN?=
 =?utf-8?B?SG9rWi9tbEFNUGtwQTlTTUhQTzNUVEpOWjVoVHByNnBPcDRJWjFmRWJKckdo?=
 =?utf-8?B?ZnJSY1RLZWZZM09sTWRKSm4yKzBWSGI3RWFLb1EvL0JrNHFSVkVvbUJKUjZw?=
 =?utf-8?B?ODhpbnN2M2IrM3pSdkh0L21EbHMxNHQvbjFSSWZIOFJXVzRiZ0hPRXI3UHNn?=
 =?utf-8?B?OUdWbGVlR2E1UEd3Y3d2M3NWV3VFN2JiZnExemw5V240K2RwMHZPaGd6eE43?=
 =?utf-8?B?Vmc4eXBzUUZuM0JYQUhQcHlNcGFuenRYQ0Q1dVdwUEtaMWwrNkhnT2d6czJK?=
 =?utf-8?B?enJYcHhoVXpJU0pYZy9FTHVBaUhJMStOUVIzTVVxdC9VUmlQNmhaZTB5Ulps?=
 =?utf-8?B?WEhMc1lIWjRzaDdxak40T3gvVnI2bTh1SVpjSlFtUHNKQ0JpSm5qbzQ2L25B?=
 =?utf-8?B?K25RaGlJM0xGUnkvaEFDb2dBMStMdXRLRkhiK2RTT1k5TmduS0psU0s5N09M?=
 =?utf-8?B?OW1TRHJVVk1KMGxmbExiK3RRbW1wdnYxVDF5Nm9ZUVNsSlZpdExad05CWWV5?=
 =?utf-8?B?bm11d1BXOEwvdSsyZDhOaHNrMTdUY2dFVUlZYXBuV2tId05KSUxRRWM4bS9h?=
 =?utf-8?Q?uhKAmZT9gUw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDNZV2ttQytjejF3VFU3a1JoZDVCQ2c5T0x0RFlST29QNDUvOWlwU1FzSHlK?=
 =?utf-8?B?UmF6a3NIaGxjOXRlSEQ3SXczYW5rM1F2azJvTzhUdkJ2RFpnbnY1U3hNSHVU?=
 =?utf-8?B?VHNvVEdUeVlvc3orZldrZDkvV3pZM0NyZEVsRHBzay95ajhUdysxYTgzZXY0?=
 =?utf-8?B?Q05qbkJ3OXNTRi9JT2l0bGtITjlIT0tPbVU2OElGR2NPai9UbG8za1BqS2lL?=
 =?utf-8?B?dW4vYUZDVnJxazFON0V6akpuVDN5OEtKclAyVGxlS2tnZi9TamlOSmUxS1I3?=
 =?utf-8?B?cUxSVmhXamZ6SHJNeHhZbVU4NklwNURUUENXaEpadHl2WkU2TDQrTmhJdGpN?=
 =?utf-8?B?ZTJaNEpSWkgreXVoMXU1RllTN3pOZzZEUzhKV2h6c0l4TDMxdzRvcEtRRUlB?=
 =?utf-8?B?VmZmSm5QRFJpZk00NlVPSCtrd1hkUXhXWVhkQlhrbThSeUsrQ1o5Y2laU05u?=
 =?utf-8?B?aVpaR3U2dm5yUms0V2Zma1lOajR6TktwUHhqUXVwMDNodW9MWXdqVk5UUmNK?=
 =?utf-8?B?V0dJTXhON1VGUXhwZ2xHdndTUUVHWXVic3ZZUDEydUdVdm51Y3VwSDVrQklv?=
 =?utf-8?B?ZDh3QXhSbEw2Ym5kSEsrSHlrbnlSU2U4NzAraVk3ckRwTEpNaTBMSmhrVmN2?=
 =?utf-8?B?RzBzYnV2aDhtcG44TDVEdUd6SzdlUG5YZHlrdnhQelE0empjTHE1czJHUXg0?=
 =?utf-8?B?WVJyamgwY0NXcHhEVlRaOEhEczBHVm55TDdhOFVEYXk5SkVMbWgySE0rQnN2?=
 =?utf-8?B?RW9yWG9wSDRIOXd0MUhqSDZGdE5WbTlTV3g2bGpFQldHeUNEWWdIMW9STFFz?=
 =?utf-8?B?OHA3T3RlVDRBZGw1ejBKT2dqN0FDaHI0SUo2V2Q1dG5MWWhaTmttR29qRGMr?=
 =?utf-8?B?aUZQd0hIT1hLeXlWQWVOZGhxYzEvaEJNdEV6THg4MGJRK0E0RXdLekhlZ0pz?=
 =?utf-8?B?OXUrZ0NHY2dQTWJ6bzVCWnViMEdLQno4TTBWeHRmcGZsYVVUMUJQRURIeGNW?=
 =?utf-8?B?endmUkpaL2pkWWVzSHN4Qm92ZGVqYzdMd2ZQS0MvbWlFemtzVnBvRnVGeHJM?=
 =?utf-8?B?N1pTUk90YXd4WEY2V0taeWtaSWhTZjB0aWFxdFBnbXRjaHZuNFZrc3lMMmZX?=
 =?utf-8?B?Y2hqVjFIa0d0cUxmZC9saHdrUmZvWEM3Rm5TYnZtVjFUMTJNQ1p6SmZObFpp?=
 =?utf-8?B?Y21MVFFoZmRTOVQ3K2ZqWFpnWFNPc1NkL3JpajY1OWRnWmhTQnF2R0RhTVZC?=
 =?utf-8?B?b0N2M3VsYXZ1MisvZDF4dnJzRWhsb05JRXRvaXN5aEdwZ3dtcTN1RmNQSHN2?=
 =?utf-8?B?Rkl2NitLTDYvUWdiNW9naWEyeVlVc2JLUC8wNlFPQ3kwOTM1MWJ1L0E2M1E1?=
 =?utf-8?B?aFpyUlFYYnVFc01YWEprRkFvRlJqYjV5dXFid25VNmdtQWtjejhQUkZoMEdx?=
 =?utf-8?B?R0JrbDVNd2ZRZGx5WXZPbUdQM3FCYkZzbUIybjJ3SXFFdkdMZ25kR2lVeU9M?=
 =?utf-8?B?dDFWd3NXbEh2WkJCcDBlb3VoZlcrL1hNV2pLNTcvVmxoZUNnUVlTWVBMeCtr?=
 =?utf-8?B?OG5kTTR6R0w0MUlkTWVLUVZxaktza0hnT0xuV2s4OURkOGF0UHJUUW5vUGFI?=
 =?utf-8?B?c0kvQU90UGRMeFFJNVNmM0pPUERXckdQeWtBdG1OdFJXaVZWa0duSDMxY0NR?=
 =?utf-8?B?M2NWNGNGZUdaTE9walFSaHJhNVREWldGeVdxbkNJZ3liTFJNeFNrM2FVS2NG?=
 =?utf-8?B?NC85aHpzSXhua3NOdXpWdkdPSVY0c1B6Y0VqRTlaa3V4azdMY3p5Y0xobWNC?=
 =?utf-8?B?c2R5eUw3YlFIRFBLeFdPOXpOS3pldW9rR0psM1d6QXMrL21lcHRzamMwWWNI?=
 =?utf-8?B?UXNnUHpaK1FiSUdXeEZOaVZFU1dEUThQYnkwVCtzcHExV29RaXNyVUN1N1pC?=
 =?utf-8?B?TzhhWEFUSWRCcm03MFFDTkF5ZHdzMEpxNnRXNDhSaVhvZkQ0NUdBMTAwb0xJ?=
 =?utf-8?B?ZEpOdFN5R2QxdU15MXVzMVdSalg2OHdad2tPVW03SWF1Qk9wUmFqcXlXWDMr?=
 =?utf-8?B?dmM5YUQ4ZGxIQTRwOXRPRU8rUHcxdjZ5SzYyNHdqUU9aVlI4VVVDemt0b3pI?=
 =?utf-8?B?MVZ2dE1BZTYwaERIckdKRU9BQW9iWVlwY2crTkRpdGdQeEJyeElPaEU5Y1E5?=
 =?utf-8?B?cWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9079d0c8-6128-4ba0-5457-08ddd8ba1ba5
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 09:33:20.0122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oHiTe3ASeeW+UuhdfzJiB+kSs06VUtu+A/BlfZ0CoZuYkHuaQgvI6OOOJ5g8pe8YpFCIHerAzJ44lNBLj1EBvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFFA27DACA6
X-OriginatorOrg: intel.com



On 8/11/2025 3:47 PM, Xiaoyao Li wrote:
> On 8/11/2025 2:30 PM, Chenyi Qiang wrote:
>> Besides the existing DR7 test on debug controls, introduce a similar
>> separate test for IA32_DEBUGCTLMSR.
>>
>> Previously, the IA32_DEBUGCTLMSR was combined with the DR7 test. However,
>> it attempted to access the LBR and BTF bits in the MSR which can be
>> invalid. Although KVM will exempt these two bits from validity check,
>> they will be cleared and resulted in the unexpected MSR value.
> 
> Initially, LBR (bit 0) and BTF(bit 1) have been allowed to write by the guest but the value are dropped, as the workaround to not break some OS that writes to the MSR unconditionally.
> 
> BTF never gets supported by KVM. While LBR gained support but it depends on PMU and LBR being exposed to the guest, which requires additional parameters to the test configuration.
> 
> On the other hand, DEBUGCTLMSR_BUS_LOCK_DETECT chosen by this patch doesn't require additional parameter, but it requires the hardware support of the feature. IIRC, it needs to be SPR and later. So it has less coverage of hardwares than LBR.

Yes, and DEBUGCTLMSR_RTM_DEBUG can also support in earlier platform but it becomes valid recently..

I looked at my test code again. It seems it loses some test scope. i.e. DEBUGCTLMSR: Save debug controls
I missed to do wrmsr(DEBUGCTLMSR) with a different value in L2, so it cannot distinguish if vmcs12->debugctl comes from the original one or the debugctls saved one.
wrmsr(DEBUGCTLMSR) to 0 is not appropriate because we need to check if VM exit resets the debugctl msr value.

Maybe swapping the value of vmcs_write(GUEST_DEBUGCTL) and wrmsr(DEBUGCTLMSR) is a resolution.

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 9a2e598f..6dd1735d 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1953,8 +1953,8 @@ static int dbgctls_msr_init(struct vmcs *vmcs)
 	}
 
 	msr_bmp_init();
-	wrmsr(MSR_IA32_DEBUGCTLMSR, 0x0);
-	vmcs_write(GUEST_DEBUGCTL, 0x4);
+	wrmsr(MSR_IA32_DEBUGCTLMSR, 0x4);
+	vmcs_write(GUEST_DEBUGCTL, 0x0);
 
 	vmcs_write(ENT_CONTROLS, vmcs_read(ENT_CONTROLS) | ENT_LOAD_DBGCTLS);
 	vmcs_write(EXI_CONTROLS, vmcs_read(EXI_CONTROLS) | EXI_SAVE_DBGCTLS);
@@ -1967,8 +1967,9 @@ static void dbgctls_msr_main(void)
 	u64 debugctl;
 
 	debugctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
-	report(debugctl == 0x4, "DEBUGCTLMSR: Load debug controls");
+	report(debugctl == 0x0, "DEBUGCTLMSR: Load debug controls");
 
+	wrmsr(MSR_IA32_DEBUGCTLMSR, 0x4);
 	vmx_set_test_stage(0);
 	vmcall();
 	report(vmx_get_test_stage() == 1, "DEBUGCTLMSR: Save debug controls");
@@ -1982,7 +1983,7 @@ static void dbgctls_msr_main(void)
 	vmcall();
 
 	debugctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
-	report(debugctl == 0x0,
+	report(debugctl == 0x4,
 	       "DEBUGCTLMSR: Guest=host debug controls");
 
 	vmx_set_test_stage(3);
@@ -2007,8 +2008,8 @@ static int dbgctls_msr_exit_handler(union exit_reason exit_reason)
 				vmx_inc_test_stage();
 			break;
 		case 2:
-			wrmsr(MSR_IA32_DEBUGCTLMSR, 0x0);
-			vmcs_write(GUEST_DEBUGCTL, 0x4);
+			wrmsr(MSR_IA32_DEBUGCTLMSR, 0x4);
+			vmcs_write(GUEST_DEBUGCTL, 0x0);
 
 			vmcs_write(ENT_CONTROLS,
 				vmcs_read(ENT_CONTROLS) & ~ENT_LOAD_DBGCTLS);
@@ -2017,7 +2018,7 @@ static int dbgctls_msr_exit_handler(union exit_reason exit_reason)
 			break;
 		case 3:
 			if (debugctl == 0 &&
-			    vmcs_read(GUEST_DEBUGCTL) == 0x4)
+			    vmcs_read(GUEST_DEBUGCTL) == 0x0)
 				vmx_inc_test_stage();
 			break;
 		}

> 
> I'm not sure the preference of Sean/Paolo. Let's see what they would say.
> 
>> In this new test, access a valid bit (DEBUGCTLMSR_BUS_LOCK_DETECT, bit 2)
>> based on the enumration of Bus Lock Detect.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>>   x86/vmx_tests.c | 88 +++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 88 insertions(+)
>>
>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>> index 1832bda3..9a2e598f 100644
>> --- a/x86/vmx_tests.c
>> +++ b/x86/vmx_tests.c
>> @@ -1944,6 +1944,92 @@ static int dbgctls_dr7_exit_handler(union exit_reason exit_reason)
>>       return VMX_TEST_VMEXIT;
>>   }
>>   +static int dbgctls_msr_init(struct vmcs *vmcs)
>> +{
>> +    /* Check for DEBUGCTLMSR_BUS_LOCK_DETECT(bit 2) in IA32_DEBUGCTLMSR */
>> +    if (!(cpuid(7).c & (1 << 24))) {
>> +        report_skip("%s : \"Bus Lock Detect\" not supported", __func__);
>> +        return VMX_TEST_VMSKIP;
>> +    }
>> +
>> +    msr_bmp_init();
>> +    wrmsr(MSR_IA32_DEBUGCTLMSR, 0x0);
>> +    vmcs_write(GUEST_DEBUGCTL, 0x4);
>> +
>> +    vmcs_write(ENT_CONTROLS, vmcs_read(ENT_CONTROLS) | ENT_LOAD_DBGCTLS);
>> +    vmcs_write(EXI_CONTROLS, vmcs_read(EXI_CONTROLS) | EXI_SAVE_DBGCTLS);
>> +
>> +    return VMX_TEST_START;
>> +}
>> +
>> +static void dbgctls_msr_main(void)
>> +{
>> +    u64 debugctl;
>> +
>> +    debugctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
>> +    report(debugctl == 0x4, "DEBUGCTLMSR: Load debug controls");
>> +
>> +    vmx_set_test_stage(0);
>> +    vmcall();
>> +    report(vmx_get_test_stage() == 1, "DEBUGCTLMSR: Save debug controls");
>> +
>> +    if (ctrl_enter_rev.set & ENT_LOAD_DBGCTLS ||
>> +        ctrl_exit_rev.set & EXI_SAVE_DBGCTLS) {
>> +        printf("\tDebug controls are always loaded/saved\n");
>> +        return;
>> +    }
>> +    vmx_set_test_stage(2);
>> +    vmcall();
>> +
>> +    debugctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
>> +    report(debugctl == 0x0,
>> +           "DEBUGCTLMSR: Guest=host debug controls");
>> +
>> +    vmx_set_test_stage(3);
>> +    vmcall();
>> +    report(vmx_get_test_stage() == 4, "DEBUGCTLMSR: Don't save debug controls");
>> +}
>> +
>> +static int dbgctls_msr_exit_handler(union exit_reason exit_reason)
>> +{
>> +    u32 insn_len = vmcs_read(EXI_INST_LEN);
>> +    u64 guest_rip = vmcs_read(GUEST_RIP);
>> +    u64 debugctl;
>> +
>> +    debugctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
>> +
>> +    switch (exit_reason.basic) {
>> +    case VMX_VMCALL:
>> +        switch (vmx_get_test_stage()) {
>> +        case 0:
>> +            if (debugctl == 0 &&
>> +                vmcs_read(GUEST_DEBUGCTL) == 0x4)
>> +                vmx_inc_test_stage();
>> +            break;
>> +        case 2:
>> +            wrmsr(MSR_IA32_DEBUGCTLMSR, 0x0);
>> +            vmcs_write(GUEST_DEBUGCTL, 0x4);
>> +
>> +            vmcs_write(ENT_CONTROLS,
>> +                vmcs_read(ENT_CONTROLS) & ~ENT_LOAD_DBGCTLS);
>> +            vmcs_write(EXI_CONTROLS,
>> +                vmcs_read(EXI_CONTROLS) & ~EXI_SAVE_DBGCTLS);
>> +            break;
>> +        case 3:
>> +            if (debugctl == 0 &&
>> +                vmcs_read(GUEST_DEBUGCTL) == 0x4)
>> +                vmx_inc_test_stage();
>> +            break;
>> +        }
>> +        vmcs_write(GUEST_RIP, guest_rip + insn_len);
>> +        return VMX_TEST_RESUME;
>> +    default:
>> +        report_fail("Unknown exit reason, %d", exit_reason.full);
>> +        print_vmexit_info(exit_reason);
>> +    }
>> +    return VMX_TEST_VMEXIT;
>> +}
>> +
>>   struct vmx_msr_entry {
>>       u32 index;
>>       u32 reserved;
>> @@ -11386,6 +11472,8 @@ struct vmx_test vmx_tests[] = {
>>           nmi_hlt_exit_handler, NULL, {0} },
>>       { "debug controls dr7", dbgctls_dr7_init, dbgctls_dr7_main, dbgctls_dr7_exit_handler,
>>           NULL, {0} },
>> +    { "debug controls msr", dbgctls_msr_init, dbgctls_msr_main, dbgctls_msr_exit_handler,
>> +        NULL, {0} },
>>       { "MSR switch", msr_switch_init, msr_switch_main,
>>           msr_switch_exit_handler, NULL, {0}, msr_switch_entry_failure },
>>       { "vmmcall", vmmcall_init, vmmcall_main, vmmcall_exit_handler, NULL, {0} },
> 


