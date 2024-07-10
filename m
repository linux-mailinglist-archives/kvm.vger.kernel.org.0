Return-Path: <kvm+bounces-21246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 22EDB92C7AE
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 02:45:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B126D282B37
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 00:44:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7E112CA5;
	Wed, 10 Jul 2024 00:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kEtlKAUp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74687A32
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 00:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720572294; cv=fail; b=QNQnSU6x16hi8IZ49BUOFzDlsvpYAyn8Z0tKcN92NcysunTEKTu1cqcTnh9JflusDuLiTaPH76JIbIei3c4xigqbOi+W4qPNuqNDVWKXcK5fA4rqJo/tk5lNnL5oGro3yc1OtS46ms+FY+uxyQXlvqgQ6nsuLYyaiRe5LRufGA8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720572294; c=relaxed/simple;
	bh=B+wzN87ozebEWDzLcJ7hH7tcgLLuLYOV4C3LeODOECc=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SBGpjtnxnY40PT6BSJaDsxWlyCXsDhcBmJe8M3Ix84MX8c1LnxjFfWNVKDoq5eqxeJ0xXCNJ3HhmBazOsCfkKR/Fz/HllAboUL/jw6k9OKPwP/Xnu8KPBPtF1dXTvAbUy1A6ceug1DxF1s2gP1bVdq8UpDjaM96kHf2awCGh2i8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kEtlKAUp; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720572292; x=1752108292;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=B+wzN87ozebEWDzLcJ7hH7tcgLLuLYOV4C3LeODOECc=;
  b=kEtlKAUptQNSaLWFI7zFJlX0BfvVZib9ZrpXYKzrqvldXuSUO9FuABe+
   2eNyouIZpq3s0zv0SXgPEi64oI/lzneL1FnNUZp25le24oepP7OdCFDcZ
   iOWTkazGk/LTqYuxd1cewKNxx772HQ3/azA7+KCwX/UqZcnY6goHRIThE
   xiOBkf9tK6zPsItSOJMLdPglv5UcDoL+lwVPdeKzQfrSCQ/WZ+z2HhTVi
   cljN+/x8zmZ8O5zsiCqVgM87sAOiLayzWbM2RV3856Jap4NpGWNGIu+D4
   bTEpolepVyMtdYkMBIVDdqHlTTl1fd9VpgTpZUIRlxcGi7d6lx/YuUFwa
   Q==;
X-CSE-ConnectionGUID: eXnmOMbqQGCqiqDSvbE/7Q==
X-CSE-MsgGUID: gwD88MqTRi29fSx6PPhAcw==
X-IronPort-AV: E=McAfee;i="6700,10204,11128"; a="35297107"
X-IronPort-AV: E=Sophos;i="6.09,196,1716274800"; 
   d="scan'208";a="35297107"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2024 17:44:52 -0700
X-CSE-ConnectionGUID: kWVm2MkqRo+UtGNeXuBRjQ==
X-CSE-MsgGUID: j3mRC6+rQFy1YecNUWaciw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,196,1716274800"; 
   d="scan'208";a="48481807"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Jul 2024 17:44:53 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 9 Jul 2024 17:44:51 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 9 Jul 2024 17:44:51 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 9 Jul 2024 17:44:51 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 9 Jul 2024 17:44:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IsjhQmvu8L3nB1KUJbBO6fdNpUcyAiZOqTLeECYL2/ElFk9i1jp98rJKhBMSaBcv137WX4WM1RSIXu0+Bq5tk09QNvQoGQzmJr5RBnxpZX0SILw4B/2JYHQYS/ocH/0ucNHEHF+J4U5MnQqkX6MrOJXHdNIcLkPS6LPZLOQD46skUFvKeEmMxuEwXWdH5Z543TVw4n/5tefdHsE5YQZEQywC+LKjoOSB3S10kogHCftH5537Qi9dzNV+4VqaVwdVqyuZhPK3yzX0URpiGZzuLV1LDbX06KDHBuHLV9Ypug2UpxXoCZikGmCPayyvhg4wyzAHVoU3qIZJHEmpl3IrKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=InKBajPmW5/LIdLzgn6XeEHU+EXItYLZrv8wiC0kEIA=;
 b=mi53gVybd4APuiB9hNBw3tg7QmcUU8iRv8tfPk6NerNdEBs07qoUfv7MHJJ3yN8wIpEsmktXwqrnTAJ4/hV9JOLKwMPK2bQo0gB49+oGssOINtITsW1Kh6IRJ5LiaPGnHi5m74GSYg7DMLQMrJqNaojU/iWAu63MrdobNCxqS1g58v6jr0zB/1l+TGttT9KhaT0cXACWjQKdff/oJdfv+efzO2HJlUYgw3LjkxHph2F6vo6D758T+BayhejnW3XqrxJtr8WpuluaL52diPkMuCqfX/xxmsWMdfzBZNnoTwEiHJAaCpgv+oyfURu2lQVFwfQOTE0pNNoVQbokiTx9kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB4983.namprd11.prod.outlook.com (2603:10b6:510:40::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.29; Wed, 10 Jul
 2024 00:44:44 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7741.033; Wed, 10 Jul 2024
 00:44:44 +0000
Message-ID: <573f9453-3a2b-4058-988e-b99f1f55d4b9@intel.com>
Date: Wed, 10 Jul 2024 08:48:41 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [Bug 219010] [REGRESSION][VFIO] kernel 6.9.7 causing qemu crash
 because of "Collect hot-reset devices to local buffer"
To: <bugzilla-daemon@kernel.org>, <kvm@vger.kernel.org>
References: <bug-219010-28872@https.bugzilla.kernel.org/>
 <bug-219010-28872-K77I1WzEsi@https.bugzilla.kernel.org/>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <bug-219010-28872-K77I1WzEsi@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0181.apcprd04.prod.outlook.com
 (2603:1096:4:14::19) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH0PR11MB4983:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dc0ea2a-1f14-4ae7-876e-08dca0797d5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NnRuaHdhY0J5aXN5SXVFSGU4VTlOWDJvN0hRdi8xTWhmM0tGWXM5SWM1OGNC?=
 =?utf-8?B?aU1ZYmNzTTRCQ3hlSjNYeWFWeXd1K1VGTmJKTU9zK1cra2NPcHYrenRLSkFu?=
 =?utf-8?B?SndpNDlndlk0SG11dENTeE5LYjVvcW5uNFVhMDJ0Q0gwQ2h2N2ZscUxZV0No?=
 =?utf-8?B?VUk2YTFXajUzNXA4cElJU2QraWdMODBiR0JzQVdGeEpPTk5DOEFPcXBXTkxH?=
 =?utf-8?B?Tjc2KzhMd0hEMUV2MERwWmpiOGFPbUZwdkpxMGtjcVl5b01Ua0J2UFBDSzgw?=
 =?utf-8?B?S1F5ZGlsMDhtaXoxZUtVcDNrUDZCTHc2ZmRHUzNUQ1RtbHduektMRjJnZ25T?=
 =?utf-8?B?eFFtM2YxcDBUOWVaeEM1VkdNTENZR3V3SUZlUkR3QXBHOS90WDRVYVdQSWJ5?=
 =?utf-8?B?SDVUWGNrTUxBaWs3NmlhcTMxcFZvdHpscWdHbm1Ra2ZoL0FSNWRCSGE0R01C?=
 =?utf-8?B?M3RmNmFVMS82MFBDUzlKVzRoWWh1REsxTFRxb2VQSUpkM0JhOUR2N0VXZHdX?=
 =?utf-8?B?WENuVk5aSldvd01RZ0dBbDM5VUFNNlAvZXc3QWdZYzh4ZGdQRVQzOXRPbko1?=
 =?utf-8?B?RHM3S3FEL2VZaWZUcWwwL2dHTGMzZHNBbE9iU3RnSHNSNWM0VWxIMXZrTWxT?=
 =?utf-8?B?T3hhWUtHR3ppb0l0VDVGZWo2aDZsZlFrVVQ0bTRLL1poM3hIblpReW0xNzlt?=
 =?utf-8?B?dlpCVHJHdlYzNEVWNWpuY3F5d3J6RTBSTmxKVUl4aE1WWnNLMmR3NTl2WW9l?=
 =?utf-8?B?a0ovSmlnMGNFZXR0REo4ZzdHTFFXTm1pQ2VMOE9UODJLYVRuaUxtMWk3L2VP?=
 =?utf-8?B?OVFES1JqQWorc1pETnFUeXpoRXk5cGltaVNRR3ZXUkVRVWdtNExybkFKdGVV?=
 =?utf-8?B?dTlIYjVHSkNxSnc5TWRGbkU1VHB6U0srNy9ISFdoUWViTTRWRURXdEZzYnJK?=
 =?utf-8?B?NEJCSEtCTzhkaFJ5K3IzeWFPaG03U0JkSGc2TkEwUHBjNXQ5U3lnanQ0QkpS?=
 =?utf-8?B?UkUyc2VXYlhNR2FLZHpyMytHNWVnYnpFR3hsSjh4c3RLdVlxTUFscXB4YWtB?=
 =?utf-8?B?N1kvVmJ3aTVMOEQxQTJjT0pKTW5UODFzdUFYQ0hJVC9yUU1adWpkTTBhMlpn?=
 =?utf-8?B?REt6RlpOdjl3Y3h6TUZsR2Z0eWJNNzhpVUp4ejh5VVgxeVpZa0xNRDJGSHhq?=
 =?utf-8?B?OW5WTUU1dHVsQTNYOXVTY2dTaVA3bHJYaDdMVG1LY2ZNdm94LzVkWSttT05u?=
 =?utf-8?B?N01xeUxobEZVcXJHTDlFUjdHekRxMWFJcmtFTnZXMzdKOXA0MGdnUlZsUmJu?=
 =?utf-8?B?MkNDMjNFaUNYWk5qYjZIR2ZoZ2YvNVBIY1pMbEtqOGczc3hSMHFSV0hXM2Jn?=
 =?utf-8?B?UUJzd0FMbGs1S0UvaXM4SDFCcnUwaTVMWE9WVXp4Zmh3WlR0WitwNW9TVURN?=
 =?utf-8?B?amoxUG53UC8zYmxrN2VocUtIV0JmY2xqNUx5UkFjNTJzRnY2R05TbWE4eUVB?=
 =?utf-8?B?OEZrd2ZNcjNCTW8zcHA1MXY2K0cyUlZPcHIvaXRxZkR1bDdORkRmWVlWQVow?=
 =?utf-8?B?WFB6dmluakx0eitDRWtMVGJLd0Y3bER3eTZzSlZWd0ROSHFpb0FjVUlkWTBl?=
 =?utf-8?B?WGhTK3BvaHFEeHdTdmpPWERWbVNMWXk1R3NHT2x2TE5SUUpVanpQdDRveEFv?=
 =?utf-8?B?cXk5UGpDUmljM2g1cmdCWlJzbWlhNjF4WENRaXNFYlJqRi9EcG5CZ29GYVRi?=
 =?utf-8?Q?T+AZFb5K3P41srbqIM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dHdRYUNEODFZdTdTSWZGWk10WGZBUEE0UEdGK0dtOWMrM0MxaWJmV094c3ZL?=
 =?utf-8?B?NW9hdjJHYUZDdEZDeUJSS0x1UGRmbGwvTEhtTUE1QkRMNGxZd3BTaEJrMHI3?=
 =?utf-8?B?dVpLdVM3T2NJWXh6RDdWR3ZEWXBnTnlNQ0g4QWxhM2JGeWhOa3lwdmpCaFNZ?=
 =?utf-8?B?c1NjMDJVK3VzZlpFcWljMGE3WGRJRDZ4SzgwREltQVp5aWE0NFI5MDh4QVRF?=
 =?utf-8?B?ZVJHeXBMRDJEVVJHYk50RjlwdXZXNWNmbVFwUUlqSnZsUENSZGNBeW9Nb2xr?=
 =?utf-8?B?OUh6b1MxUmlUamsvNFdJVTQ2bU9PWjhUbU5zZVlYa29zNlZFWS9GV0h6VFUx?=
 =?utf-8?B?ZlBuaEMvcDFYenVPSkw2N0ZuRUVpeGE3U016SE1uWGNTRmdkTzVsSlc3UGJR?=
 =?utf-8?B?dEhWMHZEbDZQZXhxRzg4LzFacllnRUhrRjF2LzNyeU9NK3ZPTlVEVFU3Znc4?=
 =?utf-8?B?WUpMdzFRbG5YMXFVaEtHRkIraDB5NDM1RENjTi9aSHlPWHFYKzNLWWJaWSty?=
 =?utf-8?B?bTAwZVRRUWEySklMTHdEZ2lvQVI2aHlKVzZIWlBIUHpaaHZLRUs3QmV6MUxI?=
 =?utf-8?B?R2N3T1lMY0hYUGxwMXRxYzBibC9qdVFRclpCRFZlOGo1aWoreVRJUGRKQUZt?=
 =?utf-8?B?QUh5Qk1ld0pZNHJ2bkU4aitSWVp6MWtDaXg5VFpIQU9iR1Z4TmlxY2ErK3U3?=
 =?utf-8?B?S1ltT0xuNVp5T1JwZkRFaFkzR3gwd0tQZFpJRk4yWkE4bzRZb1lwbEtTNENa?=
 =?utf-8?B?bXJXbTl3WlVGMHZJM2dtbkx0RnVMRVJFRGwzOHRlRHZFZ2VOckpHb2V6TklS?=
 =?utf-8?B?ZW1sUkh2SUs0SmloWUhmN0wzOGc5ckxabkcwTURpb3hSV0VPb2JpR1RvVHAr?=
 =?utf-8?B?U3BFRjA2cXhleEZUbzZpcEJaYzZLaFN0bUdIbWJWUy9WZTZDZzFBU2lKSVov?=
 =?utf-8?B?dVZleE5tVWNjcWNDZUROZFlVT0trTFhVeEJZdjhTK3FxdTQxSmZkNUZGU09J?=
 =?utf-8?B?dDJ6WTY0VXQxTlRsdFE3RjJ2cmdSbFFoM29tZmxCVnJ5cHZQUTZRUTZjWlhY?=
 =?utf-8?B?ZXR0WGRURGZkbnQrbVdGWDNSUktPcXFFRDJkWnF6bmE5c1RFTGRaVGxzS01v?=
 =?utf-8?B?RDhYa0w2a0xnQmJPeGs3NytFYVlWTUhsSlFTUFppZ0tTcTFod2tCOE1Uc0ZB?=
 =?utf-8?B?a2JUTjFVTDRTMWNnNTVnWGpFNHNuTWoyZjVZdm5VMFQrOTB0S0lUWXN0U0Zq?=
 =?utf-8?B?LzZEd1UrUm9idnY1OVN6MlB4c3dHdExoSW44dXBNRUlGbkxuUkVMWm43SlQ3?=
 =?utf-8?B?amNid3NPK2RXeVlYMU4wUDhBUERtcVhaZFBuM1pLWFo2SXV3a3lJMkNLbDVJ?=
 =?utf-8?B?dE1JcUlpZEpzL0Q0aE0welpUS1p2TklVcDI5c1Vtb2xOd3pabzRlQkdLOUJX?=
 =?utf-8?B?SmdETEM5MUlsQStXN3FMVVZxcDNmR1JHNFpqN3haVjVsWlJKeXU5QnN0VWpp?=
 =?utf-8?B?T25obWpVaUFyNFVQVjhseDNoVWo0MmxnNkN4a3h3RzlWSTZDOU5hQjRZRGtq?=
 =?utf-8?B?Q1dmaFA1V2tDdGIxOGRpSDRnYmVvRnFVQlYrcDNsZXZ1VXMzckFpQTNUWWJh?=
 =?utf-8?B?eTRwRDBnNjRGRUw0UEpxQXBXVGJjemZreE16OEluVzROU04vdGRLdnRDeEFV?=
 =?utf-8?B?SzlNQ2dmcmZ4dC9vR3VLMXprK1dEdEUwN1BUdTdEOXF5Rm5kcEZKcmlrNGdU?=
 =?utf-8?B?cjdmTGpFYU9BQ042NmhGUHBGN2RuQk1iV0NDa0F0b1puQTdvek00MmxIelI0?=
 =?utf-8?B?RjhZYjhxSzgwQmFkbUQwVUhrdTZZc2MxNmZnNnhlNU82R2JYUCtLMHBORm41?=
 =?utf-8?B?VlFFZ1A2cSt5K3EyeEV2R3FyLzFTT3pWb3lBaU1IS3ZVay92VUxFcldPOTNE?=
 =?utf-8?B?b0ZMdlVCOUExeUV2WCt4cEFtSHBXVkUvRVJDd1l4OTVoZ0pUTVR1K0tTWFZJ?=
 =?utf-8?B?VUhpRjZ4aDNLU3l0TXhEQ3o1NmtVTVVCZ1VGVTltcmE0TURmL3JBbzdYOWps?=
 =?utf-8?B?V2w1MEo3Y0FEamE5eWRuSFRNRzMwTW1ZcjR4eURWa0tqWDlLNWRKYXp6cm1u?=
 =?utf-8?Q?YeHFJ/nIJzhZN1768FILejpfT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dc0ea2a-1f14-4ae7-876e-08dca0797d5c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2024 00:44:43.8649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4L48PUXth5w9igr5oyn1OL7tF4gI3EJGL2aryjvxSTq4USAGrUTXerWE0XAeSgb4+tmfJUDQfs8PMd//dL39rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4983
X-OriginatorOrg: intel.com

On 2024/7/10 04:49, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=219010
> 
> --- Comment #5 from Žilvinas Žaltiena (zaltys@natrix.lt) ---
> (In reply to Liu, Yi L from comment #3)
>> It appears that the count is used without init.. And it does not happen
>> with other devices as they have FLR, hence does not trigger the hotreset
>> info path. Please try below patch to see if it works.
>>
> 
> Patch fixes the problem on my system.
> 

patch submitted to mailing list. Thanks, and feel free to let me know if
it is proper to add your reported-by, and add your tested-by.

-- 
Regards,
Yi Liu

