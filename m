Return-Path: <kvm+bounces-56950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10804B4691D
	for <lists+kvm@lfdr.de>; Sat,  6 Sep 2025 06:50:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD3163B5EC6
	for <lists+kvm@lfdr.de>; Sat,  6 Sep 2025 04:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E37AC27A103;
	Sat,  6 Sep 2025 04:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aUdL5oOL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741272797AE;
	Sat,  6 Sep 2025 04:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757134207; cv=fail; b=Ho2Ji9oLz2KuardWxrLBtGjt8yX6NBnI0d22I53BX772CmX9mg5ytXuDjO9d+bdFVMr7X62sULGQm7CjEuIIwCuerMRb82BrQozl2sk9/nTLgRJibFyI6teh+6nJFPSPuPxj2gKnwkNggDQhBBcyt/6ekACAZ6um5W9NrRKjJ0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757134207; c=relaxed/simple;
	bh=f000DXFLRiVdT+O8sOqnYEwbjvZ4Kd0on29kY4+E4eo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WHcNZC7XEeHvJvNX5+9gQqb5a5OXW9+KRatLLkhbPzpOEKFLbpkB35Wv9Zbi5Nsda3ensVkLFj6xtznT3opXH8O2dIrqudFUM6HKNwdyipQORby2vceniAnfOBaA1Gfs9RpHZiKTQmAbgwAAYzD0wxi31Lo9uLYdYhdiWLuqths=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aUdL5oOL; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757134205; x=1788670205;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f000DXFLRiVdT+O8sOqnYEwbjvZ4Kd0on29kY4+E4eo=;
  b=aUdL5oOLRe2z9pDxdHIU7o1ClzxzEsyPUaxLScVIaUn3YotXFM4tDlS+
   JhahVKHDCKRWUYf/dQnxqRY0+MLbHwAR/72Ln4mQGDuugrGA08fmOe4Gw
   z8NLI4LA0j9SS9oQ6qWb+0w1OYrqU0LM6NzsQzo4JwL8yT35OTbXuDIeV
   3ZlmyFN6NHQOv2WrqTmKse/wVRQxvy8kl8ijhrXaTpYX3cSqdLmXjyRXB
   Z2pQmBL2hdJ3JFb0FzSjcQ8ox+RJkl9l5YJM1t9SOrGElrULilvbNeiAZ
   /BU8S3SCCSTAv3PrC4aplF6pPXeG7aB5acV2dM+76wqjHcyM5aCEK/2b5
   g==;
X-CSE-ConnectionGUID: 4DROM9kzRs6lIPkVjLB8hw==
X-CSE-MsgGUID: CTpXmUOlQYi7mWo76vG7+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11544"; a="47050382"
X-IronPort-AV: E=Sophos;i="6.18,243,1751266800"; 
   d="scan'208";a="47050382"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2025 21:50:04 -0700
X-CSE-ConnectionGUID: iRkge0ipQDOvYtKS+hBEvA==
X-CSE-MsgGUID: 9PCrFtkFSAecvc+UNcMSgg==
X-ExtLoop1: 1
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2025 21:50:04 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 5 Sep 2025 21:50:03 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 5 Sep 2025 21:50:03 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.73)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 5 Sep 2025 21:50:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X+K0VAvdDHiCDFRzTRHW5SGNqQ6+kA3weySl7W381KhNQ4fRaL+9wL8AszFk6qpz27aC1txDdXgYNEmrovItrPBzEcViVErmJCvv6UPgz64qyHZvAvmZU4ipBsWH6Dk3N5qWr6SnH3O/QFuP6pggc6lqcrYDTT9yQSiUMARfy9tvUdfUcsCLe5W3qrFPX0P5OWqJ8tq0+VDc5rrxeI5r/l6IqbN9IqJw+3LhIIRwe6PaK5pcfMuczQgI1sXpvDiEF5zjG5vMxn3r52KpCqvr1+p1V4a7qqkLXHew6uF5d+7oGmVe3r+7B4YkbSYwePzPO5HXBwxhf9PZjsrC7nAyFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dF9wcEWY4FrwzfzR6ZLtbXphTrm3pp6md0vq+gBliUY=;
 b=H11rjY4HpeyS8U+oePc4flflu4pIC9t47RtZu66JvQVkBewEYQWgrE489Z4CN5Q0AYPyHfixEmo1YLR48MKvx0wYZ3FQd3/8safTI4Erdn+2evU3PUBUqzQjIHixCMlCemrcjiU1KOLOBTHK7V0SJuQy4MO0hx6MGCXSn3DYiWGEMD6gHfsqw5/EeuP2HS0Ea9pMbZmBx8zQ9E1A4if5cv50H4/8RAmpujCTDwuadzW4IwWBocLOMslgu7xCWVkBvWIGYkEcxgCXgV8EJo4OBn4oZxzvQ81Yhq9N7kffllnkttaPSNe9I2XHc9v93oVC0UL4dtf1g/RQKtpTWvTo2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS4PPF46B98A11D.namprd11.prod.outlook.com (2603:10b6:f:fc02::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Sat, 6 Sep
 2025 04:50:01 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.016; Sat, 6 Sep 2025
 04:50:01 +0000
Message-ID: <a34a2f1a-6383-40dc-a85c-a82e6a69b1e5@intel.com>
Date: Fri, 5 Sep 2025 21:49:57 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 28/33] fs/resctrl: Introduce mbm_L3_assignments to
 list assignments in a group
To: Babu Moger <babu.moger@amd.com>, <corbet@lwn.net>, <tony.luck@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <frederic@kernel.org>, <pmladek@suse.com>,
	<rostedt@goodmis.org>, <kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>,
	<seanjc@google.com>, <thomas.lendacky@amd.com>,
	<pawan.kumar.gupta@linux.intel.com>, <perry.yuan@amd.com>,
	<manali.shukla@amd.com>, <sohil.mehta@intel.com>, <xin@zytor.com>,
	<Neeraj.Upadhyay@amd.com>, <peterz@infradead.org>, <tiala@microsoft.com>,
	<mario.limonciello@amd.com>, <dapeng1.mi@linux.intel.com>,
	<michael.roth@amd.com>, <chang.seok.bae@intel.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>,
	<peternewman@google.com>, <eranian@google.com>, <gautham.shenoy@amd.com>
References: <cover.1757108044.git.babu.moger@amd.com>
 <fdcb23bc9061a9e1b8d99e922b234c02db561ff1.1757108044.git.babu.moger@amd.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <fdcb23bc9061a9e1b8d99e922b234c02db561ff1.1757108044.git.babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR2101CA0021.namprd21.prod.outlook.com
 (2603:10b6:302:1::34) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS4PPF46B98A11D:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d109478-9f03-4227-39ed-08dded00d650
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Y28rNjF5MmMyVkIxZm03SzA1ZFdqUEFUOVB5SzBoQ3NucTRnV3Qza2tIK2Vo?=
 =?utf-8?B?RnprMC80bVZQaHBJbTBaaS9mSHl1ZDA1eHZYY3NVN2hQN3FSM0VsNzJPVXAz?=
 =?utf-8?B?MGZWL2d0VTBlZXVodVJXTWFQTkprWU9LSmFOKzVPQUs5MHpKbmUrYmdzUlJW?=
 =?utf-8?B?YjRYZi9EVzdiMFU2N2ViQ2lLZ0RNMUJaaWcrM1VmMkhKR2tJUk5WdnNWbDlk?=
 =?utf-8?B?WGdhVDdDR1BZYUIvcGtCbG5aSEMzbW1xT2RZcnR5djVwUmk4ZGp6Um5BNEcr?=
 =?utf-8?B?OXVLdC9wbDU2enhFOG5JZS9OTUZuYlUzWHdwUWZDejhueWdlS3NpTlVCSnZ2?=
 =?utf-8?B?V0RTQWxPNlRLS1IwWWd5UWJvKzA3THVSN3lIQ1JGVlo0MDBXbk44dVl5cE5k?=
 =?utf-8?B?aWE0dTdsVnlJK3NZTjluS3RIMVhhSzArKzNEVFNJK1M4cWp0aTM5anlqTXRl?=
 =?utf-8?B?cUs3dFo4VGdXZHIrcUZ6eWhpRTBVeE9PRHJudHUrUWtDVHJkWFdWQnM1SHZ3?=
 =?utf-8?B?Z2NyeXhXTW9Cdm56bFpWa3U2bzI2YlVyN1VEWHg5QkJnckJNRldRS25QU2xF?=
 =?utf-8?B?Mk9mOUR4ZUtJcXpCN0pzeUZFL1R6b2daQmM5SzY1SytaN2xJZmxHOS9Jb2dE?=
 =?utf-8?B?dHNQdjNVRFFKUXdNUDVjMnpaM1diNFVCMk5tR09XNjFmQzNIZGxGbytBRXZF?=
 =?utf-8?B?ZmZ3Tm5ZcUtxbmpmNkYxamNBZnJjTVk2WXZpMEpUWUtqNFZRQmxNajBjclNt?=
 =?utf-8?B?NlBNbG1Kc1laMDZFWjJmN3dUYnJFMFhqRm8wODhzc2wvWVhKMWVwc3VqZ1gr?=
 =?utf-8?B?bHBDaWRjMmZjRkNCK21kRXRIL3B1VWkxZ0lWcWloUDFKQ3d3WGNpSjRNdmVS?=
 =?utf-8?B?MVVBSk5ON0xQR1BFc0U4ZWcxNGY0TTBlMVBVcVNxNzZ0YWFxVlRiOFdVNVhZ?=
 =?utf-8?B?RXRrRHpESlpCZzY3NHVINWFaY3dmd1NsZmlFRElsU2ppb0ovZnBtSWFUVVpn?=
 =?utf-8?B?d2tNMUZGTS9vTm1OaWxOeXZ3UWJ1VjVSMlhQd3BERWdoc282eUYwa0NjM2Z4?=
 =?utf-8?B?aFdqbUlLNTc0cm5ldUtqVklWV1dpV1UrQzBLejBQNmxnci9HTlNRcmpiV2k1?=
 =?utf-8?B?U09ZckNpMFB1RWxXcW52ZC9xbFdBajFJT2N0a00vcHFaSXdkTU1MMzZidnNu?=
 =?utf-8?B?MTlEeDh2eVZSZ3VwUWxxMkc4c0tIQ3YyTXNRUWp6T0NDdDkzRU9xMEdnaDQ5?=
 =?utf-8?B?VTNzK2h4elJ5dlFOVG5xTTdlNm9nNURCMTZhWnpKYkdRaXNTY0RBcHFTeXg4?=
 =?utf-8?B?cDZjUkIvSElTSmJoLzNlWTdqbC9TdFUzcjRVOTIrMEtWR3FrSzJxZzJFbDRR?=
 =?utf-8?B?RExoZjJmR1RNcFgwV2E5cmEyUlZ4RlRkZkU0TlpYM0pmMFdLM2FGSy8zVmlC?=
 =?utf-8?B?QW4zUjRBNm1WSVlObU4yWjdFVDN0cStQdU9Tcyswa2NTb3NXT0dsdlV0RGo4?=
 =?utf-8?B?bnJjSWxvWGI1MVRJajdpNWgzSTQ3WjlpaUlrbFpXZnRTUjdsL1JJYWc5dk5H?=
 =?utf-8?B?NG16SXdVME1qbmFkS3J6MUgvcXZERGVsdFhtT2pSNTJRV3diQ2hTY0JySUJy?=
 =?utf-8?B?ZkZtRXR3UHkvRnlCUFRNMkVna3lvN1c1UUQvc3FGdGNKTkhmd05ySGVuVDc5?=
 =?utf-8?B?YjBIM0VyeVVqN0VtM0drR2x5UEVjOVQwZWlMVjdoemc0WEpzSC9XQ2N5ei9u?=
 =?utf-8?B?anZrNlJ5ZjBHMGh0aFRJT2lwc3g1dnF1aVlNYXRGd3lDakxCbk1WZmxwaVN4?=
 =?utf-8?B?YVo3TGc3QTJrV3Y4eU9pODlqMzVWR0tRZS9DbE5vNGpiWGxaZHlrNkhMZGdR?=
 =?utf-8?B?M0NKS2dkOVFkNllQakdsZ0l2T3NQUEduUHltdE9FZzdPdCtwNHhNb25TbjUy?=
 =?utf-8?Q?wRS4gYSAIfo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N1N6SHo0by9veGE1MVkvY2Zrdzh2QWNyclMxQkR6OUh2NjE5d0p6VjZNVldO?=
 =?utf-8?B?REtGNDFBZDZYNW5BNlFETGNtSHFBanh5QVNmNW80cXJkZ1FFZXlUSU1WU2VO?=
 =?utf-8?B?SHRodmQ1WXFsQUJ1YUlPY01YQ3RXSGJDUUJodVdVR0RWTEw4QW41WFpGbjg3?=
 =?utf-8?B?aXBFcEFnd1BLUGxhdDJSVTFDMlF5STFqblNXR2lkdTZqN2trOS9KeFlSaVBM?=
 =?utf-8?B?K3RxaFhJbmpJVHFKUENQT1lxekNSVUFCbDFtQXpVVjdKbXVPRXgzenZLZjhk?=
 =?utf-8?B?NVo4cHRjT3RnTnp0ZTdEaXlDV3dPRVNVTEFvbVgxcVVOZXM2SmtFWFA5aUhD?=
 =?utf-8?B?UHEyUGZTQ1B4Vmp1OWlBdXhMZU4zYS9NdldKTS9rMEpJRzBKTmNKK25ub0Ju?=
 =?utf-8?B?TGlUV042MnpzQTFWUlVzSzNvWVV5NEYxNWdkYXl2UEpydnZUL2Q4UVdMY2pV?=
 =?utf-8?B?Z0I4NkFwVzhVU3VIMEpaOEp1OVhDWU5tTCtjdWJCcDU1SlRPVnRZWDd4Ykty?=
 =?utf-8?B?MTBzdWMrRVNhYjRITno1M1BaWElwYTQ2YVFHdTBrWVRyRHNMTzZUczFITUFN?=
 =?utf-8?B?VjhzZjcxZHZuL2F3ZVR1MlBubUNUa2k4dEg3Q2s3U1pzZnowdjhjRmExVXdP?=
 =?utf-8?B?Tm9TcjYxOE5vRExsS0xWKzB5SXhsbkxESVBGWlozd0xCSzA4b2hyNWpzK3dT?=
 =?utf-8?B?cEJhTDEyUCsyaHRieE5BQ3p0Um9JbXU2R3E3bG8vNkZMa2hCdEpYMmNNdDVZ?=
 =?utf-8?B?ai9aZEV2dmtaV3N0S3AxSE5ZN0RqZUFoSnpFMUJZb1FNdVpGYi9lM1R4WGJE?=
 =?utf-8?B?NFk2ZEFKT0xOemlvZlJMSlEzbVNZWmcwWjdoaUZaMHRzR3RMaFNaVmJYczBZ?=
 =?utf-8?B?K2JhdTZoSFVIY0dUZkJvQ0QzU2RPYStVdnN0S25KQVhKVzdqOWxiV0lKUTFt?=
 =?utf-8?B?SFJJR1BqaTdSNmt4eUFaNG1jSFRNNlpmVkRKb0g0NGZzMWRqZThlekl6U0c2?=
 =?utf-8?B?cGU5TGtjeDFlajFkNHFHY1VNQzBCaXc5TWZKKzFlL2gyZk1rMnRMVDRqcDhW?=
 =?utf-8?B?Zkt0dlozaElxWnRGeXBIb3dVZUk3WVRFZ0ZJaWlsMjBWZ0FoNjAzUGNuN2lK?=
 =?utf-8?B?Ym1xMlMzZDRJL2IyUGh6ck9qRldvVSsvY2hzV2VJTVA1Y2szUHlZOWoraEFF?=
 =?utf-8?B?MG50MitNUjQwTG1JRUFxdkMwTW5NSHNSb2lKU2c4emF4S1gxK1d5NHlqU0d1?=
 =?utf-8?B?NHltUmVtRXpOaDZzOXJlcU9UQ1duWDlTMk9yZVhIdlZwNW5MTHk3aW8rQ1BR?=
 =?utf-8?B?Q2M4ZzhrNFVvNnAzZGJITmJMQzM5dW1Fd2k2VU9zWnhPeEwzY2EybExrRDha?=
 =?utf-8?B?Yis4Y1c4clV4OEUvNnJPbjhYZzlmNDhHMU1TLzNIUjlzS2dzdnhjeDV3Lzlu?=
 =?utf-8?B?Mjl6SWVranFMbE5Bam9IbmtZb0RaUTZFSmJmMmtoU3FRME9wK2NzRS9WNjgv?=
 =?utf-8?B?QkxaaUJvMmxJdmsvTUJ3dzlXWXNQYnE3Njlick5QLzUyS2doWGJhVy9YL3Na?=
 =?utf-8?B?OEdZZUpGUGlKNEc5RmhXeGovRFhaZE5VS0FDcVkybUJWTnhLNVFQdnhTMkhW?=
 =?utf-8?B?U2VkZ2NMRkRaVmYxdXNRQTFzQStxMUtUdjFWWEw0ZFJaTEN4MXZYVFpBQlZK?=
 =?utf-8?B?MGRERXdKSXlnRGlBaVpmTGdPS2RZbEM5UE5qVHlpYjNIY3lHdkpNZU9MT25J?=
 =?utf-8?B?R2ZSWVE0ODQvUjh6YVBZNlUyc3pIOFNGTXVDbTVJOFhNRk9nck00NmZ5Zldr?=
 =?utf-8?B?TWhTWStqTFpTUlorLzB6R1JPV0ZYNDJQWW5NaTFmRFJvY2Y1c0E5WnljV1JG?=
 =?utf-8?B?V21CSzBSTGFXc1dDUGFoTGNxRzdmblY3NW03RVY3aTNOblpDL2dBY3RIUHUv?=
 =?utf-8?B?SkZBQkN4MDkvUFoveFN2anJnQVBIVGJNRFhxVk11V2RQZWlwTW54VUVEeFdS?=
 =?utf-8?B?azJlcndsb1VqUEFSL2I5TUdGeXpzWWlCUHhURXVIdGhCK1dMa0RJUThOMGJ0?=
 =?utf-8?B?SkNnaGtMTEcvTThOOEVTREpCVThsNEZpN2xhUld4dzNHNm5UbDNXZzlvVDhm?=
 =?utf-8?B?NHdxU1JnbFdXcDFaSlUraGpjY3lXSUUxRzkzSEtiWG5mM0FRVmZTc0tIdkRy?=
 =?utf-8?B?UkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d109478-9f03-4227-39ed-08dded00d650
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2025 04:50:01.0278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ooZtFzBhbOFyM51sD19zQ3AvkjA7WJyWtFFIxmtfzOIISSWHUzgTB/N6swIcrkhBRxTbEp66JeLVi2GGY9fvS3yjq9y7nMM4qrvKCpyb0bE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF46B98A11D
X-OriginatorOrg: intel.com

Hi Babu,

On 9/5/25 2:34 PM, Babu Moger wrote:
> Introduce the mbm_L3_assignments resctrl file associated with CTRL_MON and
> MON resource groups to display the counter assignment states of the
> resource group when "mbm_event" counter assignment mode is enabled.
> 
> Display the list in the following format:
> <Event>:<Domain id>=<Assignment state>;<Domain id>=<Assignment state>
> 
> Event: A valid MBM event listed in
>        /sys/fs/resctrl/info/L3_MON/event_configs directory.
> 
> Domain ID: A valid domain ID.
> 
> The assignment state can be one of the following:
> 
> _ : No counter assigned.
> 
> e : Counter assigned exclusively.
> 
> Example:
> To list the assignment states for the default group
> $ cd /sys/fs/resctrl
> $ cat /sys/fs/resctrl/mbm_L3_assignments
> mbm_total_bytes:0=e;1=e
> mbm_local_bytes:0=e;1=e
> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette


