Return-Path: <kvm+bounces-24865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C43D195C4DA
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 07:25:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A35A285D89
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 05:25:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EA395466B;
	Fri, 23 Aug 2024 05:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dAzfT0HQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D027CEAC0;
	Fri, 23 Aug 2024 05:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724390735; cv=fail; b=ZazgLFIBuJa576Bf87UnNlMysbQz7Ojtc3eV72HZDWX2MGLcw/gFX9S0flAKA0e3fevYhkIU/Kx47PE3NgcneEJSdBnVgSPLIbBhArnlchKzaXaxRQmSAQ7SerEYKhsF+5dDh4JxA5jpyY5wgYIBSIh8mY7QPjHMNfdpayMH33E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724390735; c=relaxed/simple;
	bh=dlZoDkN4iHv5TTcQNJ6eAuCyp8zVHsjTb2/GTUI+62c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IHAC50HeLlIZ2TSmFzT6nxJlpwxyr8FkKL0wt0YGPiiiiEnvzZnJ7SFiB2MiDOi2YsEWXEkk8A2MMgK1PyYJ/YBSqmvCCANp9KCfBvVBRXsmawgIrAYt3HRmil/c6LbKS/9RydItLSYo4hnCwYhEJ7vHwWbXFaLh/s3OYphgSAM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dAzfT0HQ; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724390734; x=1755926734;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=dlZoDkN4iHv5TTcQNJ6eAuCyp8zVHsjTb2/GTUI+62c=;
  b=dAzfT0HQ4dcluCh3biRL7Z12uPhccCstYJ5I7ljtF+n8/omZV9+LarCP
   zg+Rmk5BTNtzP8yNKI8k5auQoc+bw3MBnPvbQEIWwqHYPIlhZSvo30+Zz
   kf1w5BDZ9WvhamZYHgD8AnsDvx7J1Isqf4b9fXX01e/ZtmZizBKbXaTi8
   /3pGp/nI2jcda3H2GL8VMvywoEaN9WO8scd9WRUeG8eXIdqAOG46rkAUx
   VtkJCJQAWg7RgBYhwAHeWe9HTRqLDO3xo+wmbvUiJJiDsnBGrWZfcaeFI
   ScGWT8oQQmW6QBR68T6WB0I3l8k5u6VvtwGmxWiiPgkfe0de57VTyAYM5
   g==;
X-CSE-ConnectionGUID: +wwaBfDCQPuMjR/cIBEixA==
X-CSE-MsgGUID: /6+C4F5iTzCfoJFzqUxd+A==
X-IronPort-AV: E=McAfee;i="6700,10204,11172"; a="40307742"
X-IronPort-AV: E=Sophos;i="6.10,169,1719903600"; 
   d="scan'208";a="40307742"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2024 22:25:33 -0700
X-CSE-ConnectionGUID: BG2QnTT4TBCcPICmQCEgkA==
X-CSE-MsgGUID: 53TfDEgKTxW4kcr+10Am0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,169,1719903600"; 
   d="scan'208";a="92471636"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Aug 2024 22:25:32 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 22 Aug 2024 22:25:31 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 22 Aug 2024 22:25:31 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 22 Aug 2024 22:25:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nDwZ+yMPpmxs2mHbaClPelsvt6KPGirrAWUgwudIyCvNKmQ5/tyop1cBQcuKp5lFVaE9ZfV3f8z9IJulrPLVXlJK3Id0oxCBVhA62/u4VF97Y1gloD2bSM363ZaDmB98wgRKHJUz6NTOHxIbK2UDIBdqZzkvltMVZovm5Ea+aQZWeiTyfAl5rJ/r2rw3TwLRDrNtLssxCK7FAQ1bSuM7oNJIRla1TsKHJEmeE9K5MQXIjTSywFA2s8fWs+riPM0ZJKWE1TYZHo3WrdUBxXoaNi9MIdeBXkfp8IdqvQIRgQDNLAruG+wGQ8RviNmKyaFTFQP6hwtJPbkBahh8H60grw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=16qaNp/2lwYX+32zC/JQV3832ELug8Py/SXbsXiXOMI=;
 b=SKJRXGUYGpvIJXiZbyg8y21G5CcwWTAohjnzTgXFSof0ZuCS/p7+6IXyMly3C0F2ZYQCdZEbBvnsv5vihhZLzIhv1CTCS8907YM9vzL03FycFOf+gi19LNOEq5WF2QwtRZlY9ekzYSx/LKEhJy4W7UJ9qy8Mk8P35VLGmWHP0NAx0KNFJhM6AyROiGFhjMFu+OKxrLIaFFI00bvhRsBb4YTWqirIlp2kWHxNUlGUDC5t/D2PexZMdkEmqdYaiBhJUI8VZhehaLwGloaHnwezu0HmhYKfS8loToAF5WzcoUZ/T+Qh9a1O4IBgy1YyLXPwkqBN3iLue5vDXX2P7t4KeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS0PR11MB8205.namprd11.prod.outlook.com (2603:10b6:8:162::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.29; Fri, 23 Aug
 2024 05:25:29 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.7897.014; Fri, 23 Aug 2024
 05:25:29 +0000
Date: Fri, 23 Aug 2024 13:25:18 +0800
From: Chao Gao <chao.gao@intel.com>
To: Suleiman Souhlal <suleiman@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ssouhlal@freebsd.org>
Subject: Re: [PATCH v2 2/3] KVM: x86: Include host suspended time in steal
 time.
Message-ID: <ZsgdPljClmKrGIff@intel.com>
References: <20240820043543.837914-1-suleiman@google.com>
 <20240820043543.837914-3-suleiman@google.com>
 <ZsWJsPkrhDReU4ez@intel.com>
 <CABCjUKCBQq9AMCVd0BqOSViPn=Q3wiVByOvJNhNpHvqx=Ef-4g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABCjUKCBQq9AMCVd0BqOSViPn=Q3wiVByOvJNhNpHvqx=Ef-4g@mail.gmail.com>
X-ClientProxiedBy: SG2PR06CA0200.apcprd06.prod.outlook.com (2603:1096:4:1::32)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS0PR11MB8205:EE_
X-MS-Office365-Filtering-Correlation-Id: 90023dfb-fb02-4a53-a6a7-08dcc334005c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WkwzODdmWUZSNFp1Rm1tMEFQMXZkZE9kcm4yRE5hL1NRM25PVGRIVWxCU0Rj?=
 =?utf-8?B?M2s1QmRBeDFRV1J3YmVseDBrbW5OY3luVkRBRXVKQ0tQUk1vOWhWN2luL0x6?=
 =?utf-8?B?b2lBM2hjOWdYd0lPZ1VUS0hSNzVwOGN1cHRLeForN3ZWaHN5bE01UzY4NElx?=
 =?utf-8?B?b0FuZWMvdXZLNGxvR2lXcEFhc2ZKZGk4ZUlVbnNzOTk4ZStVSjhwZDZFc0Nh?=
 =?utf-8?B?akZqYTY0b3ZsQXBEQ1dVSWJZODh3VGF3aGRxVHBWaWxsQ0pRYmVjSWlZNExY?=
 =?utf-8?B?VjVuZ2FIZ2E0R1VTdEtQUHk1cTNta2NJTHNRcndRTFVUWFJrNG5JQ2hNZENy?=
 =?utf-8?B?TnA3b0JkOWszSnJVTElOMEI0L2M1NWJuWUxiMFFkRmJVbjdSemRUZmsxWVF1?=
 =?utf-8?B?bHd1M3crZS9uV2hnakNUbVpxRzQ4SGVwVWU0c1d3dkJwaWJNRUsyZHc4ZFJv?=
 =?utf-8?B?bXVVVE1YNWVYcjhNeDdxRm9TSitLZ0craXZFYzVKQjNaTHZhZFE3YTh3SjRF?=
 =?utf-8?B?WUJNVjcxbXdBM2NlSDBOYjkzK2o4b1NreERSL3RyTnJDRy9UTGFHUmFGZ0Y3?=
 =?utf-8?B?ZTF3OFo3cFczcUZSNzNqVTVhbjdlMjhNeVBXb2hWUjgyVVdKWWRLWWR1WEI4?=
 =?utf-8?B?L2twTVJzdkppRVA5M1gzeWFWK09NNnMvd3ZzVW9RNCs1YWU1c3dUa3dKODI5?=
 =?utf-8?B?aHF4cnhPMHRPSGVIM2YyclIvdEhlUkhYRzFjRmlIeGhEMVQzOFNkQnFCNnht?=
 =?utf-8?B?NjBueGNPdm9zOTZKbGt1U21aTTZuakxONGQ2VVQ3TWRLOFpzditTR0VBSnpQ?=
 =?utf-8?B?cEJyQitidXNqTEtBUGJrZFl1YWZIOFNhVUhmN2VPTTNZMjB6eUg2YjE4MUVK?=
 =?utf-8?B?TVdJY2Z2R01pWHNueVZvNitSSkdjZUxmdER6V1owTGdWTlhGM3pUc0VrSlRs?=
 =?utf-8?B?NGJxdVFVbUl0NVBJeC9aY3RzNDc2VWVFY2g2S2Q4T2lWSU1GblZUVFJxdlE4?=
 =?utf-8?B?NWtNMnZGRWF2L3VWK3c5dis5dW1XMXdpaytmK1U2SGpuNllLc2djcjVINk43?=
 =?utf-8?B?c3V2M2JIU2hvTjE5cTN2ZlZsdU15WC9Qa0c2a2pxV1lqY1NucUNyWStPRCtE?=
 =?utf-8?B?WTljZWRCbW5DUWNZSkRqR3h3enR6Y0E4OHRmOTB6Zlc0WE5EUVVsRDRObGZX?=
 =?utf-8?B?VmFITVNzNDdEdVBXVWc0K0V6NFdNNVZFOWxnNFlBbVlabnl3cTZoWWFKMnkz?=
 =?utf-8?B?OGs3UDkxQVFNS1Q0bkRmMWtjZG82NnZRTlZScFIvcFhSMnNTVTJkUTVVazFP?=
 =?utf-8?B?Y2ljNXowWlB6YVBJcGl5cURFOW4zUGF5KzUrY0Y4eGFzMUtCY3FXUVlJZnpS?=
 =?utf-8?B?NmpidW5Kc0MzREVEcHJrRldUSjlvVy9pNTVycUc4L0ZkeWt2TkM3M0xlS3Nw?=
 =?utf-8?B?TGJzWVZVdGdvUFBTd012U1BxQWhPV3VDdDZIS3lWV3F4anpscmNDd1RKVk5N?=
 =?utf-8?B?WUNibmduMU9hVGRhY3FudmhqWnc4dGxzenhEaTF1bUZma1JzVC9jajhiekNL?=
 =?utf-8?B?NFoyMFc1SE5hQVp5WUVnZGQrdmJScXVOYjN0LzF0UXprRE8zOUV3RXFLeUl2?=
 =?utf-8?B?dXJEUXFIa3F1Y2RQc1M3WlZLOXRBLzEycWM1alZENWZqRnBBRDJaSGRaaFV2?=
 =?utf-8?B?dnVSUmt0bG5SdzBZczhGVnBDdkZyS3NraG1qN2kyY3Njb2RjZmRHcnVsMWtP?=
 =?utf-8?B?NzRlRy9FTWQ1dWU2eStoYm1jZHZJL2FPTWVySG9nS0pxWHY0aG5tV1dFc0tR?=
 =?utf-8?B?WVhxajliWHg1enhBTUttdz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmlmOFpnSmpDS0dNYjZJNWxHQmlhbjM2QktTWWtzZXNUNU9rUGdjTjlxOXR5?=
 =?utf-8?B?VmJMSVlzZ2VuM1lia3BXand2cUJnWndtYm5WZFBKcE1UaTBqQzBaemVES1hS?=
 =?utf-8?B?NFNRUEQ3ZnlUbFNLcXhtbUkram83cXBTcWJITFVuUGpQT0wxMmhPcUJBRTlm?=
 =?utf-8?B?NU55SmRKQzFaeVE3Wk5uZHZjT0tWQjVhS2ZqNU9RNC83UG41TVAvZmVrTGw4?=
 =?utf-8?B?MXQ5TTlqRk5VbzFqVW1XU2o1Rm9iQkhhWWw4Nml4MXNqU2xMT1VNMU1OV0RD?=
 =?utf-8?B?TkNGcFdZQXNXOXg4eE0walFqRkNWc1IwNm9RSisvRUZsb1dyblk0aW5sa1Rp?=
 =?utf-8?B?SnZqYkNURzJSQmU3OWNoL3VOWGRYL2JKTm9ieUc1U2xIUVJhc3dRZnZZUUVQ?=
 =?utf-8?B?OHBieXYyUTc1VUFDVzVYN1VZd2VTdHFFaGtXKytjemlvNE5OeU84UFdhVzJL?=
 =?utf-8?B?bWJYOXpHalBoUTZ6OGxPektoL2NxMHpDYUJIOVlMekY2eFp4NnBNMDdKWEc3?=
 =?utf-8?B?UC85dDY3ZHV0L2VPR0Y2cEF4RjhJbDlsdUFjZmozeUdLNXNtM3pZSnBLQUJE?=
 =?utf-8?B?bm5hUUF6dkFkVm9LMVo1ajlqS0NqTW1IWnR6Uml6a1gxTHY4ZnkxMnlwYzlK?=
 =?utf-8?B?N1FodDlSc3FhejNlUHo2dmNweU9QUEhaY2pYODgrZUlIM2pRVFFMRkU1blFa?=
 =?utf-8?B?ZUFQamh0T3IrS0lZQi84UG43eGFuZDM5SWtWV0U3c0JOSjFEd1AycC9kdEZB?=
 =?utf-8?B?SkpJZG5KenJ1YWlmd3lhSkxvWGtyRG1OWnhBUWRsWm5hOGRTWjlEMHQwWVhP?=
 =?utf-8?B?ekVNUjlTclplK2FWZjBReWtkTktlczhzU3BxNmZBYmJHSUZJQzFDWVIwNk1P?=
 =?utf-8?B?M3RjbXVLbTVYS2U5a0dlN24zNzM5aDBZeTlRbG9rZUljSnF2NTNqWG1VaXNE?=
 =?utf-8?B?S2x0aEhLYzdXMEVSZytNdGVmK1FFMjhKNXlkeDQ3emhobFRHZEpzZndlODBE?=
 =?utf-8?B?NXVVbGNxTkNnMFVrMzdrY2Y3RDhaSUlZcmVVdzZVRlFRV0RkTzdiNm5rb2E0?=
 =?utf-8?B?R1VlMXRHeEorejhWbGo1MnZYaks3cUhWSDRIcjVYWS9iNjlUTyt6MUU2V05X?=
 =?utf-8?B?OThrRVhOQU81Y0tpdlJVVCsyREVHMDdweWxyNktXL1R2Nm1iYWNvaUR2R1A1?=
 =?utf-8?B?R29BMUtlYStQQlQraXhsU0JuSTMvbTNsanljZFFZWEdjQnFKc05VN2ptSThH?=
 =?utf-8?B?dTBXN1lObHVuSlJTK2xjc05pRUF4N0dzUWgzcGhXYzZ4bjBOMzE5emNveWVs?=
 =?utf-8?B?dFowUTJkVkVDcVNDajZCQUZjZUNvUVVqWmJqUVZPdDNUSmQyR1lEdFpSV3BT?=
 =?utf-8?B?czJNa1J0Tm9Ed2dWQmhuNURLVHFNQmROYWQ0SXZtaVBVSVFzekxUZFFhWFNN?=
 =?utf-8?B?YVR5eHFOL1VWSnowdlRXUTlGNWs1QjQvNGxqSXpCdGtzOC9INDgyVXdMRFVH?=
 =?utf-8?B?TzJ0cnJrNmtVOURSUGZwT0hmU3h2NDJzOW16dDlzS2sydDhJb1dkSy9JNHhS?=
 =?utf-8?B?anczTmtUQmRaR3h3SW91RTZMVFZ3dGlZYzhxRFZPVWJDUEc1SVhvbEtFUENw?=
 =?utf-8?B?emJzelJ5M1JibDRIVjM4T0FuYm5XZzBEc0FHZ3hPTDdmOHpQTGZJbUNQOVNx?=
 =?utf-8?B?a2dIcUtGUjlGTy8xblQxVmdicis5UisyN2NSS2ozMGszOWNSMkhMOEJMb2l2?=
 =?utf-8?B?MEZMWlIwUFVMTFZ6ZkQ5RGJrLzJqeFM2WGU1RWcreWZtdnhlU2dVclZVaDgy?=
 =?utf-8?B?b2NNQUllY1ZzZzR4Y3lqMHJ6cFJ2NzZGbXNkRWp5SkxzdkM2aUkzZm1ReGZl?=
 =?utf-8?B?TUdTTzd6aDVZbXQrN2R6Q2Zpc1RBTUJVNjFibjY3OHI0TGhnaEtRMFh0RTdW?=
 =?utf-8?B?ZmxCYmlraVBKcDJEZDU1d2c3cmxkREdIaHJqNW4wYXAxb2FwUUovSEYwUEUz?=
 =?utf-8?B?TzgvbmVtckwyMU43SmV0aFQyZ2VESldnNmxvcko2MndVVENOR1d3Z1F4UGRq?=
 =?utf-8?B?eWw4VFc3SFVrV3ZrSEtURFNFR01Jd0Y3V29OOS9CaTZqZU1rTFVDemlxNytl?=
 =?utf-8?Q?Db/KCwZN25/k6pv0UJUSxFwEp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 90023dfb-fb02-4a53-a6a7-08dcc334005c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 05:25:29.5157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FOG7hjd1CfOHdiTbGYQm+41/5rcTsFFRSXt7L4tB3KDC7jYI9wGdKCONpD90tvL4heSstTAVl3v1e20ixXO7tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8205
X-OriginatorOrg: intel.com

On Fri, Aug 23, 2024 at 01:17:31PM +0900, Suleiman Souhlal wrote:
>On Wed, Aug 21, 2024 at 3:31 PM Chao Gao <chao.gao@intel.com> wrote:
>>
>> On Tue, Aug 20, 2024 at 01:35:42PM +0900, Suleiman Souhlal wrote:
>> >When the host resumes from a suspend, the guest thinks any task
>> >that was running during the suspend ran for a long time, even though
>> >the effective run time was much shorter, which can end up having
>> >negative effects with scheduling. This can be particularly noticeable
>> >if the guest task was RT, as it can end up getting throttled for a
>> >long time.
>> >
>> >To mitigate this issue, we include the time that the host was
>> >suspended in steal time, which lets the guest subtract the duration from
>> >the tasks' runtime.
>> >
>> >Note that the case of a suspend happening during a VM migration
>> >might not be accounted.
>> >
>> >Signed-off-by: Suleiman Souhlal <suleiman@google.com>
>> >---
>> > arch/x86/include/asm/kvm_host.h |  1 +
>> > arch/x86/kvm/x86.c              | 11 ++++++++++-
>> > 2 files changed, 11 insertions(+), 1 deletion(-)
>> >
>> >diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> >index 4a68cb3eba78f8..728798decb6d12 100644
>> >--- a/arch/x86/include/asm/kvm_host.h
>> >+++ b/arch/x86/include/asm/kvm_host.h
>> >@@ -898,6 +898,7 @@ struct kvm_vcpu_arch {
>> >               u8 preempted;
>> >               u64 msr_val;
>> >               u64 last_steal;
>> >+              u64 last_suspend_ns;
>> >               struct gfn_to_hva_cache cache;
>> >       } st;
>> >
>> >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> >index 70219e4069874a..104f3d318026fa 100644
>> >--- a/arch/x86/kvm/x86.c
>> >+++ b/arch/x86/kvm/x86.c
>> >@@ -3654,7 +3654,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
>> >       struct kvm_steal_time __user *st;
>> >       struct kvm_memslots *slots;
>> >       gpa_t gpa = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
>> >-      u64 steal;
>> >+      u64 steal, suspend_ns;
>> >       u32 version;
>> >
>> >       if (kvm_xen_msr_enabled(vcpu->kvm)) {
>> >@@ -3735,6 +3735,14 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
>> >       steal += current->sched_info.run_delay -
>> >               vcpu->arch.st.last_steal;
>> >       vcpu->arch.st.last_steal = current->sched_info.run_delay;
>> >+      /*
>> >+       * Include the time that the host was suspended in steal time.
>> >+       * Note that the case of a suspend happening during a VM migration
>> >+       * might not be accounted.
>> >+       */
>> >+      suspend_ns = kvm_total_suspend_ns();
>> >+      steal += suspend_ns - vcpu->arch.st.last_suspend_ns;
>> >+      vcpu->arch.st.last_suspend_ns = suspend_ns;
>>
>> The document in patch 3 states:
>>
>>   Time during which the vcpu is idle, will not be reported as steal time
>>
>> I'm wondering if all host suspend time should be reported as steal time,
>> or if the suspend time during a vCPU halt should be excluded.
>
>I think the statement about idle time not being reported as steal isn't
>completely accurate, so I'm not sure if it's worth the extra complexity.
>
>>
>> >       unsafe_put_user(steal, &st->steal, out);
>> >
>> >       version += 1;
>> >@@ -12280,6 +12288,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>> >
>> >       vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
>> >       vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
>> >+      vcpu->arch.st.last_suspend_ns = kvm_total_suspend_ns();
>>
>> is this necessary? I doubt this because KVM doesn't capture
>> current->sched_info.run_delay here.
>
>Isn't run_delay being captured by the scheduler at all time?

I meant KVM doesn't do:

	vcpu->arch.st.last_steal = current->sched_info.run_delay;

at vCPU creation time.

>
>We need to initialize last_suspend_ns otherwise the first call to
>record_steal_time() for a VCPU would report a wrong value if
>the VCPU is started after the host has already had a suspend.

But initializing last_suspend_ns here doesn't guarantee KVM won't report a
"wrong" value because a suspend can happen after vCPU creation and before
its first VM-enter.

