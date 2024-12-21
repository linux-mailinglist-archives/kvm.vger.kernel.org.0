Return-Path: <kvm+bounces-34269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 17D149F9DA8
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2024 02:18:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0008D188571A
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2024 01:18:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C284025745;
	Sat, 21 Dec 2024 01:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f+grSubC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE221096F;
	Sat, 21 Dec 2024 01:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734743907; cv=fail; b=HgvihRXX9MeFhFwahMRBzI3R3vlildM5ghj2sefFCSka6OAcMxq90s+kxVRMju7Dx0f9MgzDLaw1Ztl9jLaxLQqoeJMHjMDYt+TyoKZkYMApuLfqnxHhmHC1eiKhkeOhKIVhC9Doxj557GMtsCayrvecPwBNvA5/cZaMnHGsQoc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734743907; c=relaxed/simple;
	bh=l3+hakR5INzdBwpX7fc2YI5yO9x6hVHA9DIcZoUMZ10=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YRncp5J6wsTXa8iBd9uBiY6WPr521m63zUs578mm9mkHOMuzHqhoLr6HW6JqGpqgZA0sh41w5UtriLj0wPAXjJgwv+Sy9V/nFd6Mq4lU0rxoFZICsSLJVtr708QMhrsFYoXlhTc+X1MD40R5jNPEF6bK8L6/ylT76gnqcRXrJhc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f+grSubC; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734743906; x=1766279906;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=l3+hakR5INzdBwpX7fc2YI5yO9x6hVHA9DIcZoUMZ10=;
  b=f+grSubCtmWUx81UD4qUEkkN9wPHyLY6L9Y4NGSI/KTu6iCxwo/EQcYq
   FY8nYzE+aVklFPCPl6JjXok7J0Gk+PI8i25V2agej0jbxEQGHtBv7qvNF
   ga2Zrdm3089nRJGfYlON6Up+0pVWGYs/qDHoRluwK1a1iM9kHy5kqutLs
   x2MOZk4yU0DiNc+w7RWvyvD4eQ6qD0GpoFrYO4pCcGkF2UXppvHT0g4kh
   w9cM/pPmIX4e5g7XgcElmhlaGZ9bNKIHRBzdYwqql4IGmKk7+43NBgxG/
   2U45EXsTnI7etDYC5Zv+ioBUMAtGCRG9eL15y85oadUJYxoHx9qA5/AWJ
   Q==;
X-CSE-ConnectionGUID: FlwkQgzoROGumvClqHgWYA==
X-CSE-MsgGUID: YmIXF0mtTW+jxiURjy9gYw==
X-IronPort-AV: E=McAfee;i="6700,10204,11292"; a="46307700"
X-IronPort-AV: E=Sophos;i="6.12,252,1728975600"; 
   d="scan'208";a="46307700"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2024 17:18:26 -0800
X-CSE-ConnectionGUID: +zIx0McRSaeIS7oflDn25g==
X-CSE-MsgGUID: LkRoLVhoSDqBKfB+PPanzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,252,1728975600"; 
   d="scan'208";a="103521581"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Dec 2024 17:18:11 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 20 Dec 2024 17:18:10 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Fri, 20 Dec 2024 17:18:10 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 20 Dec 2024 17:18:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XkSjHnT2AIMWIH4Wnde0Yqkw5zCSRnL5y1NRuhZoFvRu8l0dHFEKdTfi7NBfKZO/P6iJ2OEgkq3T1Tjxw638uHzz2SOtlKEBs2092wFQSxoDvEIJFzDkYSzm9ogMV8lDD/YH6tTnlc6BTPeYoLZCiSZG6LwW9/M9ClKp0R25oRvxlmrdDmmVdCIG0g0cvcsfPwtElu8tLPmOvvHu0wP8X+G/PjBqMHLY+vWXmPRJthBPVfH8oJmqVXG2k+2JG+tl//KLZKKcvQQcKIGBfYC7K7iaWXxYBeoiAinnKo4JU4aPWHoe4Xf7/ojQy2kCSfgEtf7KAq1/Q7MLsj+LkJk7ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uqwizangALF64TKHkltZKPpQRnwqPCbqCjFcKGK8iM0=;
 b=AuGMvWoo58rugzALfxCopq30StDDa+91ZgYaA/vBBkM7B5pmUJXXSXJApMW8lhYSpb3eS9M89LTCOH+VansTTSLNZmwhDaM2mNC0GtbEiGg0Abp2URFClLCspqZBWcOM/fPgoTGaXUimQGSmkxy4P8cW+vchRjr8ctZhXmYi/Cfvt2804W4wt6jXJqRRMixSHxG6Dj2NcCO+zBbmktAdl3XeEKipeivXSavwRigldMeZAcEBjRSqfhtvTbAQURJn5z3e5DfpO9s72xl6Jc74If+0MdcIoU/Lpqf3jUBD6tMSFbBYJy+w3/JGrN8B9AicIUZJ/W2VE2J0KHxGn7Is9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB7591.namprd11.prod.outlook.com (2603:10b6:806:32b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.14; Sat, 21 Dec
 2024 01:17:22 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8272.013; Sat, 21 Dec 2024
 01:17:21 +0000
Message-ID: <55f97ca1-8f32-4e33-96fb-d82ed2109f9a@intel.com>
Date: Sat, 21 Dec 2024 09:17:11 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/25] x86/virt/tdx: Read essential global metadata for
 KVM
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <20241030190039.77971-4-rick.p.edgecombe@intel.com>
 <419a166c-a4a8-46ad-a7ed-4b8ec23ca7d4@intel.com>
 <47f2547406893baaaca7de5cd84955424940b32b.camel@intel.com>
 <11479069-6f1d-42b8-81b6-376603aea76f@intel.com>
 <BL1PR11MB5978299D3FE0EA6DA0DAD0AEF7322@BL1PR11MB5978.namprd11.prod.outlook.com>
 <811f95884b46c2b715f02377cee83352d26f437f.camel@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <811f95884b46c2b715f02377cee83352d26f437f.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR04CA0009.apcprd04.prod.outlook.com
 (2603:1096:4:197::8) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SN7PR11MB7591:EE_
X-MS-Office365-Filtering-Correlation-Id: 910a6ecf-da46-4c71-a355-08dd215d380c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Vk9haWFFaWxzQVFCSi9uUnFFNHlscmlTZzNpeHdVMUtmMSsrOVlsSkVuRFNQ?=
 =?utf-8?B?ZjB3TDFRQmhaOTBCNU1CVzNPQU5tT1I0RVIrVmZxd3FPK3VrdW9vUTFuTFFz?=
 =?utf-8?B?aEkwMmRiNnRtdWl6emVCdnBWaDRsTFFheGhHKzdiRU0zMzNlYzJKWUw0Z1V2?=
 =?utf-8?B?Nmo4RFNjNHFBS2M2UWx2TzM4algyNlFMQnFoS3RsNTU2M1hxNFNKQU9uc1RR?=
 =?utf-8?B?Ymh0U3l4N1gxUjB0Yi85STVjeVRrNUdhMjg0RVFsVHh4dmlBMEdKQ1dlZWNx?=
 =?utf-8?B?ZXRmWDdVTi9Pa2lQbkJMbEFJT3d6YkhsZzJXR2ZzQUxZZWVrOG9Ra2xSdkRu?=
 =?utf-8?B?RjJ1NlY1aWp1ZWV0em1tdnZ1YW91VFFiMG84OGN1OXBFUVNrZ0J5M2ZCTVI1?=
 =?utf-8?B?Y2tsWmlOOFZCVE9TVWZNbVZSWjBjN296WDc2aE5BeUNFanFNenJlOVRBSGRi?=
 =?utf-8?B?RVFJa0lObVV3UmpCV2p2VDU5aGJ2SXlEMGtYNEdneFhVN2lXREIydldvdkNG?=
 =?utf-8?B?TWFaaDg5T09CZFhwaFBTZmw3dzVvSzUrREduazJBcFFCVC9EYTVFdEJhTjlL?=
 =?utf-8?B?ZHhZRTR3S1Fqc2RkMGRKaGdSRWhzWmdVYktKbXVaT0tWZWduT2R1NlcySFNj?=
 =?utf-8?B?L2c2blN4WEYwVzZPR1JMZENtVGMza2JBQ2E5c0Z2ZjZUOUxFMUE5QkRlbWlO?=
 =?utf-8?B?WVJ3UXpFUVJjV0ZoSXNBQVNWM1RPNWFiVW9lTVA3WjJxalFVQWt1aEhNLzZj?=
 =?utf-8?B?VmZjbi9FNDZleGtGTk8wVUpYVGNLOXkxZkFvR0JCV3pwUTdBamh3UHVBSXR0?=
 =?utf-8?B?aitsV3c2cU0wTnEraVhQR3I0dTFrQnZoNktRejVqcnduWlpEMXVDUXA2SXUx?=
 =?utf-8?B?R1ZQQWpjVWFzaU5XalcvQ0dQMm45bzBTWGNicnAxdDRDNVFuRnNGUmpJR2Nk?=
 =?utf-8?B?Y2RvSW56VlhNYm1JVVZyemMzMGp2SDlRUDRDVEw2RDJ6bkE2VC9ZNnBXeWRp?=
 =?utf-8?B?bHNIT1hzYlQ4alRXT2ZHcTY1eDBWY01US1RNbWdtVXN6NitJTGd0dDc1S0cr?=
 =?utf-8?B?cHRhMVNjTnpVZ3RKcWlScWZQNDFSdVlLQmNLVDd3b21iQTdwWk5aNEtzZm03?=
 =?utf-8?B?bzY3b29FL213M2xmbkoycXNuTlh2cndIY2hWSlNQZnpSbWFmTktLaTQwbWYr?=
 =?utf-8?B?MUt0REprOVJOOFR6L0tKT1RHUUxDYTNIWEE3dlcxOTA0TC9EbnBRNnhsZHgw?=
 =?utf-8?B?OXFNZHoyUFJxYzJJaElUKy9sbHJpMDZWdmxXdWxkbHZJOTNCWUhDdXd1V1ky?=
 =?utf-8?B?RXhQZUNaUDlZN0VvNkRjcy93ampiMm1YMk9JL25JNE5zTUJpLytrU2tZZEto?=
 =?utf-8?B?WXFZMUZudXVhSk1JN0dIcjhOaG9MNXBBUk9MUEdoeEExRmNZSE96a2diY1hv?=
 =?utf-8?B?RFRhRmZOYk5KNVBzVzQ4ZTgwaVpsQ3dUR1hDQTM2bTBSNHNsN3FvYnp1Ukhr?=
 =?utf-8?B?WlVXdExMaVlabG1LNEVHeFJldG9JYnhCZzVKV0NyNUh0NVZJMWtScDVibHZ6?=
 =?utf-8?B?QU9UTG50WXF0TGtSbVdtMmZSVnYxak9POHlNWG0yamdZcmo0Wk5Xd0FhRUhV?=
 =?utf-8?B?ajdmMWV0L0xuSmY4VW1xemo0V0NwVkEwaDVrV29yRTh4ZXhVeExic1JjZExm?=
 =?utf-8?B?eDdUelFSQnNBNWFtVmwyQzZrWDFsOHhyZzdwdTk0aVU4Q3FLVEdJN0Q3ejA2?=
 =?utf-8?B?NWFlTFZyZmJFZ2t0UXhGWmlpWUhRZlVQY3ZJcXd5ampFRXNXdEx4SUtmbm8z?=
 =?utf-8?B?YnF3Mmw3U1VISmpkOExIY1ZhTHNBeG9SdEdROU1OdVNtMk1nOUlaNUVBME0v?=
 =?utf-8?B?R2VwOUVvRS9DQkhCb0dhMHRoMUEwMVZ5blUrZGRXVm1XVkNTeGhwamFxb1Zk?=
 =?utf-8?Q?UmiUknMLCdc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b3dhbGZWZ01SODZWbGQ5dmdnenBjVmhST0Fmb2lSZ25mUitBaUVHY2JJUGFZ?=
 =?utf-8?B?cWVmNlhYNUwxdlIreC81NlBXRDBPSThWaTY5TjFSWVRVcTJoMEVjUkI0dU0y?=
 =?utf-8?B?R01oMGlmazdJdVBrRWdBbHpwS0owTUI1bXI4YmNrNjNpbjYzMXhObXMzOW9q?=
 =?utf-8?B?NHh1UGRWMk52d1BTcGllSWVONWowOTZYYVFId1RkamVRc1RYSHBDVkc1RW5J?=
 =?utf-8?B?ODU5RjE4WC90cm40WFVwSmtFSlp4dWRuMXBLWUhHalZzT3NrZWN1c2J6cC81?=
 =?utf-8?B?NlUxNE1WWTRTWHZoK054SjJ2MGdUUUFURlNKTVdITk43dGI3b1U3OU8rQisr?=
 =?utf-8?B?aEMyMXlsNGE1T1p5eGtDQTlZNTh0dVhkdVpJclEwV0lKOHo0RDlmL1FNTW1O?=
 =?utf-8?B?TFF5TmZnTk96c0hPQUtnZXZzdGtIQmo3aFhCUnZFZ25abWJzK2MwbDlkWDlI?=
 =?utf-8?B?VmJzZm95NFhYMFFvdTIrQUtYcmVVVGpSbEVWK2srTm0zRnVBcW1GR1dNOC9o?=
 =?utf-8?B?KytNbnpOUVMza05tVERMMmd4SElFMVVvZU1Hd0lyYmhKbkpMZFZrTXZFNzd4?=
 =?utf-8?B?MTVqR1BCNlIzNDlMeitsdFc0NmcvRk02ZjkrcUwxSURXNUJ6TmxXQm9yam16?=
 =?utf-8?B?dXlNNnAxOW9xNXdIT2FjYklsczc1ZloydW5WdTdVTVV4b3plQWszRjg0Z1Vx?=
 =?utf-8?B?R0tJYlRrQmhkdFhocW16Uk96RVhiSk93MkpCc25oQWNqMExuQ0FxZ05kbm5V?=
 =?utf-8?B?T0NrS3B0enhWdnI5ajE3b1QvNjdORDkvMXpYQjlMTTVCc3RpSU45TW8vWTI2?=
 =?utf-8?B?MlNnK3dqcXRrbEtTdXJrS1htK1p3WXdRT2xmWUFCTUxJdWdCNXBOTG5yMWFV?=
 =?utf-8?B?bWdlSnpVa3BvV1BXWEFVaUZMS3NBWkRrelJxWEQvb3ZWWlNvMkt2UFhCN1N0?=
 =?utf-8?B?eEhBNHduRmFUdUduczdCTWZDTnJUaXQ0VmVId2xNOVFKL1oxQ2Q4cXBKRTZQ?=
 =?utf-8?B?UWMrYzl1dEdiNkVyV1lpeGFDQ3pBTk1VU1E3Sys3d2hsREJhVGRQMDJ6UFlP?=
 =?utf-8?B?MVVyRG1Yd2dkZWNBOWJMWkJaRzhXWXFCMFFqV2wyVjVWMDlSdHZWWEQ3L0xX?=
 =?utf-8?B?SzZEUXpXUUZDL0JhS1lzRnkrTEZ1Y2dxR1Rnd2ZuMFV5Nm1NRXcwWVV2dHVx?=
 =?utf-8?B?RmdKR04rRzNDdC9sQzFOc0p0eXpzSG0wN1lJS050R0g0OXNEUnV6cW5oTUZF?=
 =?utf-8?B?bDZDQ2g3NU9DQU1EaDdRYkJRUEtIOTE3T0ZHcThyUFpDSHRrMXZnRVlUMkwz?=
 =?utf-8?B?MXpnc1oxRkZjOUtqT2ZmQytFYjNHL3h2R1cxUjdUbEhmYTRZWXdtZnpEZFB2?=
 =?utf-8?B?WUlvZ1IxR0I4WVRWMFlOQTdYcTJySlNCR0hWUjNubmVTM0ZuWk1pYTFObTlQ?=
 =?utf-8?B?NVZXdXZuUnlRUDI2TXFQKzFRME1GbHZNUmhGQ3JDT0huNzZHck94dnZOTnRV?=
 =?utf-8?B?ek0xWTg5Z3FlckVqaWJaSE9Yc0RaN1gyZGxVdGJvYXh6TGtEcGRlSG1BTnZi?=
 =?utf-8?B?amxPVStOaG1hZnNEeUdnb3BQVnVGQU90WnhHQnlFOTd1ZWZKUERja0ZuVU54?=
 =?utf-8?B?VG95dGJSSkxsRWhBWW94VEJ5dkNZY0lMUTRwS2NyZllFbkdaMlNRb1NUQzNp?=
 =?utf-8?B?NVRwYVd5MmNpMDkvTjJ1MG90REdqMEtEZ2g5bjRWRlcrc251SDl5V3o0MjB3?=
 =?utf-8?B?N09ESEdGTnRKWWVJeTRUd0E2YWYrUHE5VUcrT0NkNzNkVTVxVWx3UTBaaUw3?=
 =?utf-8?B?bHNVRENUZ2RnR0IzRmpHdVFZWEFRNlJWa3Z1MUlFSEJUNUIwKzRGUGFNVm1h?=
 =?utf-8?B?R3VYajZ4V3cwaFFYM1hZZyt6NkRqSkl3bFk3K1Y1cXl6WFdSQ0N5c3RqZ3kw?=
 =?utf-8?B?K0QwODBFS3V6Q25qajNhTXZvYU1CRDF2bzVBczBtSjNuVDY1QVRmNjE2OENu?=
 =?utf-8?B?TWwyVWszOFZwYjdzRTdGK3RnQmRkenkzOVNmeU9jeUVqa1pKQ0huWEE5Slly?=
 =?utf-8?B?KzV2OGVtbzBOY3pYcGJLYzVwbWxzSXhNdXNUZ1hwbU8vaWJ2bHV5WDhnTFFx?=
 =?utf-8?Q?bw2rF5liJtMhDsViVWD+7Gdcl?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 910a6ecf-da46-4c71-a355-08dd215d380c
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2024 01:17:21.5840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h4hmXUufPebQa6EQqT6s1LOu3OoqivffZkQXF8ZDDuEqYUZ0uIB6jTOBoO1PM80/mqZq3rcjWmuqGq7WISRE3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7591
X-OriginatorOrg: intel.com



On 12/12/2024 8:31 am, Edgecombe, Rick P wrote:
> On Sat, 2024-12-07 at 00:00 +0000, Huang, Kai wrote:
>>> On 12/6/24 08:13, Huang, Kai wrote:
>>>> It is not safe. We need to check
>>>>
>>>>         sysinfo_td_conf->num_cpuid_config <= 32.
>>>>
>>>> If the TDX module version is not matched with the json file that was
>>>> used to generate the tdx_global_metadata.h, the num_cpuid_config
>>>> reported by the actual TDX module might exceed 32 which causes
>>>> out-of-bound array access.
>>>
>>> The JSON *IS* the ABI description. It can't change between versions of the
>>> TDX module. It can only be extended. The "32" is not in the spec because the
>>> spec refers to the JSON!
>>
>> Ah, yeah, agreed, the "spec refers to the JSON".  :-)
> 
> So we heard back from TDX module folks that they were thinking the 32 could
> change to be larger (thanks Kai for checking). We need to continue education
> with them around what KVM is depending on as TDX Module ABI. And we should get
> something clearer than these JSONs.
> 
> But in the meantime, we could tell TDX module team they need an opt-in to change
> this field. We could also add an actual check to fail cleanly:
> 

Hi Paolo/Sean/Dave,

TDX module team has acked changing 32 to a higher value in future 
modules is a breaking of ABI.  They also promised 128 is the maximum 
value they reserved for CPUID_CONFIGs thus won't change for all modules. 
  They will update the JSON to address.

I just send out an updated v2.1 of this patch to bump array size for 
CPUID_CONFIGs to 128 and add paranoid checks to protect kernel from 
potential TDX module breakage on this.

Appreciate if you can help to review, but for now, wish you have a 
wonderful Christmas :-)

