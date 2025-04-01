Return-Path: <kvm+bounces-42389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B8051A7814A
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 19:17:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2F703AD31D
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 17:16:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC55420E703;
	Tue,  1 Apr 2025 17:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gc96HOFM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731EC79FE;
	Tue,  1 Apr 2025 17:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743527820; cv=fail; b=ehq92YSnks745yn54iPzSOxwhls/nxs3VlS7aFBfC3bRpLmQka6eDmiSFUuz57/0jy2VBEcFy8ZouhX0oWNkH1oOO5Homt3eJR9UqYgiS4LS9UH5KVfDgCldTFfWJw0f6HywYjmN65/+8cpUZhBjLa5T1PLPjBvg2fJ9LFxNwmY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743527820; c=relaxed/simple;
	bh=7z4ixqY6RKGj+/Yfdg5K5kzeL+hJXKYLNkYbC4tZCnE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WXDLz2qIxSdddm4iAS9cwFIhMW1fcd+PkyS3295kbFibkL7cbcF350LA0EQzmbWT4C2JyLJzJNQCKOLuArUSZ+lUTbJ3yuu/0ETiHDgs83wwpk/bhioarZzw2nvgG2Sn6EZ/d5xeCtQ1fhyruN60RNh2PqwrjDhpLgABf38Vpsc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gc96HOFM; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743527818; x=1775063818;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7z4ixqY6RKGj+/Yfdg5K5kzeL+hJXKYLNkYbC4tZCnE=;
  b=Gc96HOFM1+lNuYO85bxUrM+n4fzquU/JXIgSOGLCttKuir030QNNLgsh
   z6JQKqjr5hsMb1jSlicZCNfPaibxcE5pxht8TxqKdz3AHPe/eg0R4oFLT
   I8yY4G8nFiYS12pUcASve3DcCO1wvYKlbTUxV967T0WhNJzy84eXy+hi5
   2bB+p4Kk61njrX6tPFufRdmKHQUWzu842MdP6OTqthy3c47Qu1k5dyNLf
   4LlQB5fI3s8EU+liH+f8aEIJ7BDKWbUvNq4u2rCc3u/eIbICnP5Mtveli
   5suod1vG9x2/kIwTElzrgHWpZiRhHEAR3QMTLBxrj25c2atLyrZP0jAww
   Q==;
X-CSE-ConnectionGUID: +VtiaxBLTRee6tT9nxDGZw==
X-CSE-MsgGUID: dN3mEjzYRoWZ/SPEmMK9nA==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="62265574"
X-IronPort-AV: E=Sophos;i="6.14,293,1736841600"; 
   d="scan'208";a="62265574"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 10:16:58 -0700
X-CSE-ConnectionGUID: nuBnG1TPS++X5JP20gPFlg==
X-CSE-MsgGUID: IEu5RIa4TQidCw5nj/NSlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,293,1736841600"; 
   d="scan'208";a="149625072"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 10:16:56 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 1 Apr 2025 10:16:55 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 1 Apr 2025 10:16:55 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 1 Apr 2025 10:16:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=excFEyBDmFUlOEi4WhQrzIx/Ybsc40TzlDFrlVu+Ktb32uecUvsP2GgoCgWPNpOo2XDWS+vmgUlxc57poZf02Y4m0875CSzdBDBMM7mNn5fLe9ICfwcA/dazNRYzhRDfWrtJyr7lr6ZWjJvuGFGbfPUZoQ4sr7yL5z/hNKsJ403rHirpRoD+SXSgSKT382iLJPWXzAWBBtEBt0GYJOBTEHB2Kjb/FnrqR8k96mUlkj5e4gOyWvOl2dEXQvUIQKNoea/DptcNptyyiYjnhNU7+BgXOTo7Wr8p812RQq1yLn8zu3EFnmHUQMbwqc80w5hG7YFwKIXOQfd1kexjEYJNPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=csaXIl7RfVfy1Aa1rIEvKUcD0HeQP6bIA5wCHRbLM70=;
 b=rcP29e9Ff+Cl/QHHRZxkMI7Y+x/+Y4mKgptynZlqh/YfDMawurF33re8w4UDtEpol4SdVeZAXRojQXE/hb6j8orUnu7b8J+SJp3KRQF9DR2r4sh1z6u5nMIvapQSbhWX8SM5n+I+EsZUdpovtbfw6TR4gKDHI/11etw5NcWsbGw65cQmHkGL1FIPOW0L1DS3Cx4Gy8QyNyP4fHHowLnRz6jJvi8Pc91QBDEra6uZhgglvwU9cPP+nsTfNtR/s2L469GM5w2W59F4C0sCmsAnISB5V7aqbcXmcnZ+ExYQqJ0EHhGa5Ai/umPOXdezSc7C5T3um1wKf3VKzCu79qE4Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 PH8PR11MB6926.namprd11.prod.outlook.com (2603:10b6:510:226::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Tue, 1 Apr
 2025 17:16:51 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.8534.043; Tue, 1 Apr 2025
 17:16:51 +0000
Message-ID: <e7ef5294-26da-4a4b-9c6b-f5c0f293a56b@intel.com>
Date: Tue, 1 Apr 2025 10:16:47 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/8] x86/fpu: Drop @perm from guest pseudo FPU
 container
To: Chao Gao <chao.gao@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <tglx@linutronix.de>,
	<dave.hansen@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<xin3.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, Ingo Molnar
	<mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter
 Anvin" <hpa@zytor.com>, Samuel Holland <samuel.holland@sifive.com>, "Mitchell
 Levy" <levymitchell0@gmail.com>, Stanislav Spassov <stanspas@amazon.de>,
	"Eric Biggers" <ebiggers@google.com>, Uros Bizjak <ubizjak@gmail.com>
References: <20250318153316.1970147-1-chao.gao@intel.com>
 <20250318153316.1970147-3-chao.gao@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20250318153316.1970147-3-chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0130.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::15) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|PH8PR11MB6926:EE_
X-MS-Office365-Filtering-Correlation-Id: 182bd4dc-7a58-44d3-0561-08dd7140fe35
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?d2QzTnhBa2F6U00rWGFjMTUxOHoybmEyWWpRQ2ZQNVAvZm9JaFRDRXY1Nlpn?=
 =?utf-8?B?WVZlSjNZb204aUUwMGJiUDMwc0U4WHN2eHdtRWJieWVOYk8vQ0pSZzdtVExH?=
 =?utf-8?B?cXNxcTU4eWIvdStPR215YVorK0dBajg2ZDYrTE0wUWs3WGZJZzNWNEs4VHhR?=
 =?utf-8?B?aVN3QklwUjdDQnlObk00ZFl6NjlYdmdXWnZLWkY0UFBwQ0puQzlRYUxaclRr?=
 =?utf-8?B?TWtuRngwb1ZKM2FpZWNVRFp5VWJhNHBEd1REMGpvdjdNSSs0TnRVVWlGR05k?=
 =?utf-8?B?K0JRcitIMmVZZ1JXeXZCZ1hrNjhxVytjS3hPNEdScG83SFM0N09SSWdPRDBq?=
 =?utf-8?B?ZEN1QUhyTy8wZ0Rmc0hNZFpTUThEbkpjdnZORFprTldhY0NOU0dMa09zRHdu?=
 =?utf-8?B?ckpyRVcrZC93azFMUVd3UW9zOFhwQm1wcExBb29rMWc0bDhiMzVJWi9NS255?=
 =?utf-8?B?QTlnclA4ckE5aEtPdmt5QVZxTkR1dDIrODJabU0wa2Rxbm1vSU80OTg1S2FO?=
 =?utf-8?B?NnU2ZTZ3bkkvZWNwOTR4VkMzbWc0YnlVTVRXYkZhNVcydGhFR01LaWlYREIw?=
 =?utf-8?B?dXhsSmV6YzA5VTBVZEhzd1B2cWY2V042czc0VEtiRWxFQi9LYjd1MjJPZWhi?=
 =?utf-8?B?NC8wUENON0tTYzJaZFRMVFBMVVdiZ2NxQlJ0TXNsbTJ0c2lORzJqNEdDMmlJ?=
 =?utf-8?B?REhWMm1VVHBxM2M1dmJ1MVlCSHJBV1B4bkpSa1BBTmxHbVVZYXRyUVMyRS9Q?=
 =?utf-8?B?MFhENXZjeFgxRy83cnZhVUFIRWp4TER5QzFHMEI0NVdtVjRCWFFYVjNNSjh1?=
 =?utf-8?B?YzBHNUdjSVRqZzE3U2NPSlg4Q3Y1THFpanF3UXFtOGlwQnFJWmJ1WjVnZWll?=
 =?utf-8?B?SGVSY0djWnQzVDh6UFBTTXNnRkVIQzRNUVlCOHlCZFpLbENUc1pNdG5zTG9a?=
 =?utf-8?B?bk8ySmFYWTkrV2M3WW54SXlIdkYzNEpRaWRLUFRhWkpFZE5Sa042TjFEZjZ1?=
 =?utf-8?B?amkvcVpZd3pWUFpqR2l4ZW5UZUd0ZFI3QStUd1ZLY3JpV2JiakxrOTk4T1Zv?=
 =?utf-8?B?K0oyUWlURk9SRUNCMTBUdVY5RUp1eHJkVFI2U2lBTDFyQlFjS0h3dk1yVEls?=
 =?utf-8?B?eDdGU1NCMTA3NHI4ZmlhMlhPd0NqOE1LTkNVSUNlcnQ4NFZIb1p2Z2hLN0xR?=
 =?utf-8?B?WWJtMWQxMnBPVy96ZlhrQVpJckVMTDV6Z2ViQldjWDNvUXR0M1NMWWRRM1hN?=
 =?utf-8?B?eEgyQ3VWMFJTMEtveTlnNlYvbm11NytreEFPSnM2QmJWbGdFUGdFWG5YekY5?=
 =?utf-8?B?ZHVqcFU3Mk1zb3RPR1NKVXNtbTdwOS9RQ1V5Ui90TzhnaHBIb1VBdDBsOE45?=
 =?utf-8?B?VlU1Znl2clBXY250MEJET0F2QTVIVnFpeVNBcGQrd2hLbmNZTExLTDB3dVRp?=
 =?utf-8?B?TEVsbUp6aS9QTmp3V1ArY2tVYmlhSmNGWDF0aHp4d1ROb1I4UnNLbDJOSWRE?=
 =?utf-8?B?bXI2YkNUYkk0c2ZlOTZUMUhRUXJSV2RuTW5uTkZmcGI1cnc2SUlBK1FmcDc2?=
 =?utf-8?B?YmFGTDN6UkdrcEZ5T0VsbkN5NHJnMWRmM3p5MlpadmJGdEdFVmN5Tyt3UHB2?=
 =?utf-8?B?L1daZm9IUE5Lb1ltOUNMMXRwb1JpcXloaWdMcDl3SmxTTklVWUc5U0hYbk4w?=
 =?utf-8?B?S1FnNkltZC9lMVZ3cFNHM2JhZ1pyUUZpTEFLMXZYWGwzNWM3NUEzRFYzMGJN?=
 =?utf-8?B?ZUQ5L0QrVzJ0V2RpNGdVV0RvclZjVkRJVVJBZndCQjc3ZzFaekpDMHVGdGIx?=
 =?utf-8?B?NVpDNk9NR3pCR1QrWUc5VlN4WHp5OXd5bzB0cFliOTlNNjJVbXVtNVVLNGUy?=
 =?utf-8?Q?x6nk4j7zFJVf/?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UCtNVWk4Z1NibXRpbnFzZWRMZCtNYTIzQ1pXcFBQYyszZ2pHUDM3VkRZMW9o?=
 =?utf-8?B?SnRIZkZXSmhFcWFQVFhKTFlnZ1l5VFo2UllZbFNpOGM1QjNrWHVTTUJob0hz?=
 =?utf-8?B?cUx5S0x5Y3ViU09oYkErNjZtWnB3WmtaU25BY0VNV3dKVnN6T2tjcUIxN0p2?=
 =?utf-8?B?UnZqSi9zQjBQUTBSekcyVW9paXNiNlNML3B1U1loeXFtOWY4UUdsZ0dxOUVG?=
 =?utf-8?B?cDdqS3VEdWlGb1lycGxXakRBQ3orNEloaWpyUVpHejJyRjRKblIxYU14amc4?=
 =?utf-8?B?bnZlUDVqN0p4c0JmZlRzZHltNS9KNnIvbUF4RlNaU1laTURQWlBTZzZSSkRX?=
 =?utf-8?B?enhYeDFMOVZlTEF4UnV4enNGRGEwcFV6SngxOXdsaTNmSWRXcE8vWEJUcmJU?=
 =?utf-8?B?UVU2UWlwS05TeXpwcExFcHlBbTQ0WjR5cHBxRytlVGxxUkltNFQzYk5JWUdP?=
 =?utf-8?B?dWtVNjZnQXhDZWJIMkF6d0RTZUI1a0tlTkM3Wjl3WnhCaFFsM1U5UlRiSFll?=
 =?utf-8?B?WHBYZnZhaitIZGFPc0xNV3FWUEMzZFNQS0p6UXU5akt1ZGJaOHlyZzc0WDRG?=
 =?utf-8?B?UU9hWU1zcEIvYjRJb3NIVjhTSEVFbG93ZC9GT2gyUGt0VEE0R04yQlVsaU5r?=
 =?utf-8?B?SHUxMEQxTjNxSFA5cXhueGtXeE9UOVZXNkhDc05BQmd5QzJSSUhSMDU1WWxX?=
 =?utf-8?B?VjhnRDZPeks4NVBXa3RUT21XK1k0aStTZzZ0bUpYa09YSFIvMGJJUGtiaDRF?=
 =?utf-8?B?ZDRqaERrZXVDK1hvNHhjbHhSRHlqKzNJd2YvMDF5NFg0SDJmK2FSSTFXZzRo?=
 =?utf-8?B?UVpuTUlxWno0NjhwWW1EL1k2ZVU1eGk0b0k3V0tGOVBKQ2ZWbFA0NWUxR0Ji?=
 =?utf-8?B?QU5PZmVxMGE0WHJ1anZFV1ZEZENSOHNhcGdoWEp4VnpLSXNJdkpPRnhwbmdy?=
 =?utf-8?B?ZUhJNjhqbmRLQjdzMERBUTdyWTBxQkNkdXNnRFlQOGpvRHdLS21vMFcrSEZh?=
 =?utf-8?B?c2tOUzZBdyt5RDgrNjRpdFlMOFpMWEhtT1ZmWHlGNzVndFRTaFBna1dHNDVx?=
 =?utf-8?B?YzdJM1djei9FUFNXT0Y2OEdlTC9xQU1FQkxUcUk2Qmk0bkhONy94dEUwZ3p2?=
 =?utf-8?B?SFlhcmNGdmZRUkJta2lQQklpTzk3UWdhWmx4UitxYnVQbkdpWjRuL3dNV09i?=
 =?utf-8?B?SU84Zzl3MkFBQzdhai95empMcHU4RGIxcW9uU0dsUzRxT2t4dTlGVWVwTG14?=
 =?utf-8?B?SWpXVXQrUkZaM2RKNGZnNm1QemY3TzV2ZFZvcEN5QlVwOTB1K1lnUmlmSVk1?=
 =?utf-8?B?NUR0a0F2WXpIeHpwRzVBckVtM202RVRCQ200Yk1UaW14bjdUNG8vRjFNRTlY?=
 =?utf-8?B?U3l5Mm8yTVRqWGp5d0ppd0FoclRnU29ZNXI5bzBpRS9ROVFjdGE1Yi9waFJD?=
 =?utf-8?B?eHVuVkJIVXdPRDRGRXgzTGNsMHpIN3pUcHJxODhVRlRja2hPdFBqeHhDSEo0?=
 =?utf-8?B?aS82QVkydTBXbk5WV3NFQWgrWlNEYVZDb2F2Tnd6STNYb1J6NVZpK042dWRX?=
 =?utf-8?B?dWsya2puRXcvQ2tLTGUxeXZpZEJ5MkFZdFp6MVJHa2ZpUGtDR2ZpOWJXZmZT?=
 =?utf-8?B?cUZTTU4xNUxFSTBoeWE0dHJaOXU5Y1ljZEo5MUxSZDkranBacmRGWTRoTlow?=
 =?utf-8?B?U0F1T3FTRmIvbGRZU0h3bXhOUXZWelFqZnAwU1JQZjlUNWlSR2pUZE4xZVEw?=
 =?utf-8?B?SklBZS9QSjFKTVcwcTVwNitsNTF4Y0tLVktISlRNNG1pZnhzM0tRMTZDWW5u?=
 =?utf-8?B?TnFGVGl5YU41VDQ2OW5lbjRTN0ZKYlRYQmFXYmJSZkd0V0JtSU81N3pZbnpw?=
 =?utf-8?B?ek9yckVuZkJweHNWYmtjVk9IUlQ2RlBVUGdjY1JxbE1URjNDc2dkRTJxWjlX?=
 =?utf-8?B?L0ZUallwV1YvVkc2d1VqMnJyTlFYYVIvQWJrM1d4WXVTS1dEbmwxeklETU1r?=
 =?utf-8?B?SDhTVXJFa1FFQ2VHNjhmcWYvSEgrZE5GMDVUODQ3Vk9hMzZhRVdTdU9yVTRG?=
 =?utf-8?B?RGc4eXplY211R3ZmZ29WLzNKSkxNdUhPN2pLZFlTWkdqWmVMSHRJNXd0Qits?=
 =?utf-8?B?YUpKdVpUM3Z5U2FVRUhoa1FmYU1CcFVjb2ZRWEFUZ09KV25EaE1yQ3VVSmQ5?=
 =?utf-8?B?VFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 182bd4dc-7a58-44d3-0561-08dd7140fe35
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 17:16:51.4784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GAp9xPrnatOTufUQy3iOsGTjohV3NZj2pYfQIKBTXBFI/3thtKaJzVsxPDRhnTVCmbqpqRA+L2Pk7xkWKA4/xP5gFt3PszYUlDj8x9maDrA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6926
X-OriginatorOrg: intel.com

On 3/18/2025 8:31 AM, Chao Gao wrote:
>   
> -static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
> +static void fpu_lock_guest_permissions(struct fpu_guest *gfpu)
>   {
>   	struct fpu_state_perm *fpuperm;
>   	u64 perm;
> @@ -218,8 +218,6 @@ static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
>   	WRITE_ONCE(fpuperm->__state_perm, perm | FPU_GUEST_PERM_LOCKED);
>   
>   	spin_unlock_irq(&current->sighand->siglock);
> -
> -	gfpu->perm = perm & ~FPU_GUEST_PERM_LOCKED;
>   }

With the removal, the function no longer requires a struct fpu_guest 
argument as it now operates solely on the group leader's FPU state.

Thanks,
Chang

