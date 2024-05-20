Return-Path: <kvm+bounces-17752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 53BF48C9A98
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 11:44:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77A4A1C21999
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 09:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37B5536134;
	Mon, 20 May 2024 09:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jpE/gLHW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DA02D7A8;
	Mon, 20 May 2024 09:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716198252; cv=fail; b=PT+8XG45cipRlA7YZ4nUBYVJih8/BUcwlApnUuwYfAs1Pveek65YIVFXktNul9hH+Fi7QeyEaPAa8ND7JHQxDIyKgIJTwvTigIej0aevMM3bcrvSDrUfTeeaNT6YQffOSu9mkkP1Rf74dspKcJgFJEFT/CYi7LZdcLNoSjbDrwc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716198252; c=relaxed/simple;
	bh=ryPme657vXR27p806+EB53aLok0sG7UHi0X0A0HNr/c=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eGnFCJhQYhOUpLSWdGEDCNewDTuYjX57UzUFGgL6cwhC870vndGxc6YtPKkTrjoRYkWLp2ww4QVYvCOAk+EtpcDDPMGr6TEnvPp5425XX2Re2z5Chs5ZGPvSMpkqF8BXmhKrenzC4irSYc667S5KG2sfaqsKYtSWS0WeVHIJQFE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jpE/gLHW; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716198250; x=1747734250;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ryPme657vXR27p806+EB53aLok0sG7UHi0X0A0HNr/c=;
  b=jpE/gLHWQoPYhTJcprPI0dDMytTBCg/ZoVgnolQ2cee6M5cJPXaGs2G+
   e30MZhrlsKXqFSEqu2Hq/0xz6DBxZENL741Tlrc0Ew7gb0abW/kUrhrgd
   yhyLDDA0IHEi54k99QCeOwYW5knbfzoFzhKwkUmdXOQUmDR/Q2hGSnDuI
   UlME0iUVtMPZjVyNtpdPNtXHv25iIYOkqLuA5aN8Sfs1qINsupEJSuyYA
   phsHURQto3gCAukHw3GKVDAirSW7K/LAJl87FAo8plGVZb/cZ37hCydXt
   I3el+R/IXszMpgP6y5qfIBW/GButQVxm+cYTBZTDZmI2HGt2K32xSRZCh
   w==;
X-CSE-ConnectionGUID: NllJSBX7RRWZaFVgMJgbnw==
X-CSE-MsgGUID: YNZbX4TwQfCSgcifhGrwcg==
X-IronPort-AV: E=McAfee;i="6600,9927,11077"; a="34830070"
X-IronPort-AV: E=Sophos;i="6.08,174,1712646000"; 
   d="scan'208";a="34830070"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 02:44:09 -0700
X-CSE-ConnectionGUID: 8kNz3GC4RO+G4pqztgr1iQ==
X-CSE-MsgGUID: QTGQ8MBZTEGBLKGpJrc8nA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,174,1712646000"; 
   d="scan'208";a="33046601"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 May 2024 02:44:09 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 02:44:08 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 02:44:08 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 20 May 2024 02:44:08 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 20 May 2024 02:44:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h+t9Ws9BWEMuzkFNX4D6/zl/whdVAHFSYIwX7a80cjnJAKo3OaIECn+yonkFZ8A2WZ9/UG84O1ZdosQKGxazFP3Y56/0Zui4ll8z3o9XxGlxktUzZix/NC1IZeF7t6G3LpaRha+EoHdbHPFC54unwX2hguooFmyX+wz67hDdKYnjvAM9GkxKwc59yE7fTfvA/jaGvsnAHH2WtYeGbUnx6mcU0JNZlAFYf1ra6t7m/TKYQH7d4szHwpbPuR0+JalkJ5xwFsLKyq0fRDgoaFbbN4iesUkRcA+GSPT61ihI5NnMZGTvR6GdUGXUc7bdZ2Hz+Ig8qVcnXsglQDv464uBqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qpy2tWlPYoI+JbXzQuA/96eiaKCWEjIPD5coPplaHg4=;
 b=NKffTYyHJRQNCUEhJ0O/VuztwuWkmMBRh8yaySmJHlS1Tp8WtYLOMOBW0J+xdsIfwTDFER40aaH/xAyRvpPupR/RtosOP/uB2T3GLkRqaY3+8SFvS63bhQlsBCr4hhHQEXLNYBa8qZB4h+ngcLce2t2pwjF6WZKyXRkOF8o0Eh4hesIepDzhOsAXLZzeyFs6h4PwbFg/qFF5MAwuF1pCAYKKWz/LhPcfrbXlTcBUypJUKEbA/eEdBXuqSDQbSP1qVQYeceqjuz0Lc27tozNC397PEqNubP55yYzGxZrvI/bFVz3wA+PSGyErC30MmTsQ9tyIs+mP5XZt7xGURNLtvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by MW4PR11MB6863.namprd11.prod.outlook.com (2603:10b6:303:222::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Mon, 20 May
 2024 09:44:01 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%7]) with mapi id 15.20.7587.028; Mon, 20 May 2024
 09:44:01 +0000
Message-ID: <a170e420-efc3-47f9-b825-43229c999c0d@intel.com>
Date: Mon, 20 May 2024 17:43:51 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
To: Sean Christopherson <seanjc@google.com>, Thomas Gleixner
	<tglx@linutronix.de>
CC: <rick.p.edgecombe@intel.com>, <pbonzini@redhat.com>,
	<dave.hansen@intel.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <peterz@infradead.org>, <chao.gao@intel.com>,
	<mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-25-weijiang.yang@intel.com>
 <ZjLNEPwXwPFJ5HJ3@google.com>
 <39b95ac6-f163-4461-93f3-eaa653ab1355@intel.com>
 <ZkYauRJBhaw9P1A_@google.com> <87r0e0ke8w.ffs@tglx>
 <ZkdpKiSyOwB3NwRD@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZkdpKiSyOwB3NwRD@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1PR01CA0064.apcprd01.prod.exchangelabs.com
 (2603:1096:820:5::28) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|MW4PR11MB6863:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f309934-c4e1-4e9e-f8ed-08dc78b160dd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Ky9BTkNzVjV0Q2lKc1c2TjFQQjVIS2w0eGZzbE9qSktRZU56Y3dNUm5acFkw?=
 =?utf-8?B?WTdQYThsVENPV2ZlYWd6cTB3NFBuNWdVTEZNWWx5MGtyc3NpcGhVR2VFTHF1?=
 =?utf-8?B?T1NDMVZxdjBzbEc2SXdYVzJ2bTFtQkVOaGR4VG4wcnFwTzl1bzhmMDF6a0ts?=
 =?utf-8?B?SnNjREVRUmk3NHovR3VBS2pYZjNHcjZBVTVlbHFzNDBVaUZuOFBoSXBkT3U2?=
 =?utf-8?B?WXpUUVYyNnBuOHJwREVVYndadVBoa29GK2lYYjNtVHZLUDlodWNVYlJSakJi?=
 =?utf-8?B?dWdjZHQ3QTFZb3FFY2d1ckRucWtESmdrRzlpdkU2K3pJcFdVNWpOWFptVVhq?=
 =?utf-8?B?enoxeTNEb3V1a0ZReGNoVnU1Mzh4RmxGTkZJckJoSHRwS29WTUJ2ZlBnSXk3?=
 =?utf-8?B?NXVRNXh3WDBlREI4S2g2UGp2eXVCUW0zbUhpckR4WlpaSkc1MzBuY29iNmJp?=
 =?utf-8?B?NDF4ZHNxeWczdndaa08vQlhDUEZTekh1WWx3a1RaQXh5b0VTZ0FpWVN5ZHg2?=
 =?utf-8?B?OUxRWlpoeld2SkxSWktyK21SclR5Ti9TT0lUZWEzR0FXa3F2NVdLVVVhT3Fo?=
 =?utf-8?B?em1oU3hJbDRXenNlUmYxaTNGK00xbVdLMUNvTnVMNFpqU0lUdFJ0VnRvRzhx?=
 =?utf-8?B?Sk5ZcHl0V29pZVpJQXk5R09POGIrSUY2UFd5NkkzNXdPU29XZVVKTkdSTTNC?=
 =?utf-8?B?aHBBSUU2aHNza2piN1cwUENIckR0cTVqSjBPUWRXRnZ6WGxmVCt4QUNEaEJD?=
 =?utf-8?B?NkE1ZHhHM3dBZER5T2Q2VTZtbkp4aUlmWVlzZmZkUFA3ZDFEaU14YTRpVkl4?=
 =?utf-8?B?TDRYMUIwZmlvSGJoNXJnVWgveWNoVUt2elRENFRoN1FjamdnbzhJTGVyK29C?=
 =?utf-8?B?NkNyQlFrMW1iNHp6VTJmZUNkVXpzOWszZCtyTVFnQ1hoU0toTTNQdG5UK1d1?=
 =?utf-8?B?R2grMktYOXFjTTNjZXRreGMzcDhMUWtGU0cxbUUzejBma0NJNm0vQnJqQ3la?=
 =?utf-8?B?NktEYXdmSVZRenlsU25IWXdqSDFIcGhhV3Eray9ZMzI3cWVTTU53K2lZZE5Y?=
 =?utf-8?B?ZFJ2R2NCWXRVNytUeVFVbDJlTS9KeW1MOFFEd3R2RE5QaUxHcXB6VHk3ZEVM?=
 =?utf-8?B?M1hXL2JJcjhzNi9rSVY1d1ozSWZuOWtQZmFvbXBmOExjeFdxMnd2alVFUld5?=
 =?utf-8?B?aytsRHREMmNZYTh4Sjl0MzVQQ3dKMFBRY3ZpZTQ1ZDhDZHAybUxuYVhxYkRF?=
 =?utf-8?B?Rm9QTFVQa3YzQWV0bnZOWlBXbVNOQUJzdERvbERXR1V4MVR6cDQ5cXJ0Vm5Y?=
 =?utf-8?B?dlBOOC82MlFNME5TZjdlb0ErTlVVdDlvN3ZaT25QZ2hYY3NCTE9Pc1l0a3du?=
 =?utf-8?B?R0x5ay9xK2NqS1BlMGhZb0JtMldiQ1pybU1SMlZPRUQzMm9BR2MvdkpXVHdX?=
 =?utf-8?B?ckJIZVRITkx5WWY4d3lxZDJIcTd3YmY0L1QyY0RHSEVtQXBZcTRaN0ViT2Jn?=
 =?utf-8?B?UzZZZnB5b3VnWmR1ME9kQkxKMUhVaUhWTkxEd1hHSGZmT1RtRTF5cjVmbHNy?=
 =?utf-8?B?ZEM1UTZlZXg5SFhNT1Bjckk5aVJGcEFNLzdpWjlZbUxGR1hzSkVJL2RQVCtX?=
 =?utf-8?Q?NR4Zn4pZD33sCDnrq1dfK6yk8ygE9mc5333cdwEpR4NQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akZveXovbHY1ei93T2pVbFBROVFHbzhGb09wNS9hL1hwMEIwY3hGdUpmbmc2?=
 =?utf-8?B?dmJDQ1QzTUhwSHVnNVRBQWNxdDFUM3U0SlkwdWNjVis0WWJOc0N4Q3BCRmJ1?=
 =?utf-8?B?bmVicjY1bFFXbXBPQjhTZGNTc2l2NUFFYzhvMTFYUHR1dE14aXlJbFFyajF1?=
 =?utf-8?B?alY2V3JvdVJ2cmVSVWd4ZHQ2YXRBcnRycTNlT1phZTc4ZGtTSTlxMGFzc3h1?=
 =?utf-8?B?UlpsdG5NNW5IcXoyS3dKaExXdVZYT2xZYllZRkluWmlLWHA3M21Yc0NDTTY3?=
 =?utf-8?B?WWdWc01BQWdGbEtXbEovUWx5UGtwZk5aUWh0OHVRbTFKc1R2TTBvNEpybkxO?=
 =?utf-8?B?T09raFNxa2dzY2RraUp5NGg4Mlp5cjdxcE44Y3hKUkFNOHB2S1pZZll1TEhi?=
 =?utf-8?B?UVQ1emxUVktSU25POE51NHFMOTY3U2o0OGNlVVNucFVvZ2tmSVp5RTdRY0VL?=
 =?utf-8?B?MUpjeXFyd1hsZjlKWGorYmRLb2djTGp4bUdFSGhXdkxtblFRTWNjazhWMkYw?=
 =?utf-8?B?WDdQNGhiQ2VLRUNFeW12dm41bmhNZFBVZVZ1cFZ6YmZFeERZSVJJRm5Yb1F0?=
 =?utf-8?B?RUx2TituRFI4VXpzS0JMcloweHFKY3lTN09CdEFRUC9NK3RvR1p2WU5ML0RI?=
 =?utf-8?B?alQxT2JZbUxkVmU1SWFiaGFRRWVSNjBVK2NaRjVPKy8vVTFBMTQ3ZlhHZUxO?=
 =?utf-8?B?SFFIbiswbHJzL0cxYmlrUVdZbWpqajZNdFZBSEp0aXloNmNqTldWTGl6TlFK?=
 =?utf-8?B?Q0pJNk91OU1CdFBtOUpaV0NXaGVJa0FnbUZrVUtVSnJuRDNpTWg0TEtCQXUv?=
 =?utf-8?B?RmdBNUxZQTNxQ3NxL0diTmNwQkpzK1lNdUdGNWNGMWM0YUh0ejZDdHJpU2Fp?=
 =?utf-8?B?ZGI3ZVc3eDU2N2s4RDRhaC92cWFxTlRpNDlNQ2xIREFyTzZETmFTOFJqajJl?=
 =?utf-8?B?WDFidDZxVkQ2Y2Q2azZZVTh4Und2dzZta1hmM2Z4MWluVjBockVNWHdoa045?=
 =?utf-8?B?ME1qbDNUTDNpRUIza0Y2RGxNaTIrakNmSjZKSGhWM0RDcXZhZUh5bkZOSnl4?=
 =?utf-8?B?WlViMU5kRW5DRnoveWpGSXR2ekRGN0hjMkNuNjl4TVJyemNXUlR3dXNleGFw?=
 =?utf-8?B?MVVpRGJ0bUlKcmZ2cEZFMlhXNG5SMmVaMEQxMmVDdmRDNTFHbTNidkYvUEdE?=
 =?utf-8?B?TlZZekl3OUViMTZLQjFJdHpyYlNTTzFaOUVJMHhvbHBnZzhpN3ZubGlXaURC?=
 =?utf-8?B?bGV5VE9oYjFtZmFvV1NUdGpRWnNtWkhmTC9MNjBUL3NtUmJqK3Z0dXRQNFVa?=
 =?utf-8?B?S0UxZUtBeUhmUGhwOEhHbXlLMHUzdjF1bDBsbFgrU25lRC90MklDcm5BTXJV?=
 =?utf-8?B?ZkRLYXl0RlFiYktsU1Q4M2ZWdEVoWHhxZWZlRy9DTjcycmdaZk8zeURwQ09U?=
 =?utf-8?B?VWE0Um5VeUZUcWFBRUdpZFZsc1djWUduQ3lkTjhPMytWVS84c0UyZ3BxMUFT?=
 =?utf-8?B?WEJjbXFLQUF4L2xqWmR4ZnYrbWhtYW5LWGlkdVVLTlByQlVjQkljV1o5TllC?=
 =?utf-8?B?THV4bkVqT25mWnlxZ3ZsMTBoRm8xb3lqN3Z6VXJscmttM3QrU091ZWxiWDEr?=
 =?utf-8?B?NDlNeVNmdERNVngyZ0ZFUkpQNmlvT2ZnTGQ2UElzTWI4RmF6TGZoYkVTTTVK?=
 =?utf-8?B?VWVvRnpoc05Zd1JqY3kvd0xtZFpLakZJUUpodzNjNHJiVW93blMzYnhJS1RB?=
 =?utf-8?B?VWh2TXcwMVlUdWJMYitmcDhkNk92MjZtY096NWJ6Q0lyT3hMSnVEQmI4c0hJ?=
 =?utf-8?B?ZGpZQVZhYjhHbmpBa3AwSWRuNDd6eGpzRk5SampFblFvOENPM2ZVcVYreUt6?=
 =?utf-8?B?Y1BLQVQxU1dxY3RjeXh2KytheXZWSWNSU3lLaDRYTmRMZTROUHVicUVHNXJG?=
 =?utf-8?B?ZEt6VEtsOFE3U3hFOW5Gd0Y1SkRTeUVIL0VhVmlFMTBtOGFISUx6QWU4NmZL?=
 =?utf-8?B?WE9UdndxQTFWdjBvTTl2THIvMUd5MGFBenpod1lvZzZSd3hzenIreWhDTEdR?=
 =?utf-8?B?SWIyMFI4V1p3QmtEQzgxbFJJVTh5VVJ0dzVORlNTdmg5WlUxaGRSUmlzdVJR?=
 =?utf-8?B?eHZPWHJKTnE1ZDJ5aytmUnIyd25iMjJzMWhPM1BNcnAvUGhLb1hnZStjS0VL?=
 =?utf-8?B?U3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f309934-c4e1-4e9e-f8ed-08dc78b160dd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2024 09:44:01.3190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fSuoqoz902kXX2KlpZ5P8/nPlK09hrXofweBt7KiBX0GmnMREJK/q9QYy9gyrD8FVaqTbdz4gk8EjgKKlW/4mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6863
X-OriginatorOrg: intel.com

On 5/17/2024 10:26 PM, Sean Christopherson wrote:
> On Fri, May 17, 2024, Thomas Gleixner wrote:
>> On Thu, May 16 2024 at 07:39, Sean Christopherson wrote:
>>> On Thu, May 16, 2024, Weijiang Yang wrote:
>>>> We synced the issue internally, and got conclusion that KVM should honor host
>>>> IBT config.  In this case IBT bit in boot_cpu_data should be honored.  With
>>>> this policy, it can avoid CPUID confusion to guest side due to host ibt=off
>>>> config.
>>> What was the reasoning?  CPUID confusion is a weak justification, e.g. it's not
>>> like the guest has visibility into the host kernel, and raw CPUID will still show
>>> IBT support in the host.
>>>
>>> On the other hand, I can definitely see folks wanting to expose IBT to guests
>>> when running non-complaint host kernels, especially when live migration is in
>>> play, i.e. when hiding IBT from the guest will actively cause problems.
>> I have to disagree here violently.
>>
>> If the exposure of a CPUID bit to a guest requires host side support,
>> e.g. in xstate handling, then exposing it to a guest is simply not
>> possible.
> Ya, I don't disagree, I just didn't realize that CET_USER would be cleared in the
> supported xfeatures mask.

For host side support, fortunately,  this patch already has some checks for that. But for userspace
CPUID config, it allows IBT to be exposed alone.

IIUC, this series tries to tie IBT to SHSTK feature, i.e., IBT cannot be exposed as an independent
feature to guest without exposing SHSTK at the same time. If it is, then below patch is not needed
anymore:
https://lore.kernel.org/all/20240219074733.122080-3-weijiang.yang@intel.com/

I'd check and clear IBT bit from CPUID when userspace enables only IBT via KVM_SET_CPUID2.
And update related code of the series given the implicit dependency.

Thanks!



