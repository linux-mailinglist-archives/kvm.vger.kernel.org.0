Return-Path: <kvm+bounces-53838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF43FB18300
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 15:57:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8ADB35A0348
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 13:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11B04261388;
	Fri,  1 Aug 2025 13:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VluKO3C9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BEC246BB4;
	Fri,  1 Aug 2025 13:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754056614; cv=fail; b=ZYoKlnjTA5d9usk2rKrMBfkI28K3IG+33aEMymLyZP9ErUoMRo70hIxeapoQ79olxvAFel8Zbjck6QhX98WlsNeO4V7gqVuNf0wwK3eGB51zL5BfYWgo4pnUPEQp1apJpTIUwlGslTuGXfLfl9Pej617lJBslMPU2Ujq4kYaIkE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754056614; c=relaxed/simple;
	bh=XQFhPmTkv9NFaczvFPVXHtFpmFuWAVAt7Hxr3h9DoJY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QjXag1+N4adFScy3UpptZ5wJz9nBpQKcZc5mrdf6eaD5o3VVpv35FGcg8BK25hQnreCfhYlUKqKlsos3WP3MdJouNU777ddsIjeTH5KQRnIrJj4V7WtvdgFcTFoZZwBOY5nSj/pob+51G8XI3cBkBsrA3hEbmYyVh0T2xSCIeJk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VluKO3C9; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754056612; x=1785592612;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XQFhPmTkv9NFaczvFPVXHtFpmFuWAVAt7Hxr3h9DoJY=;
  b=VluKO3C9LWgn4DV6hhTn9g/9ZBv5McbYLeN3dp70U6sxVu0QEYnq2cF1
   nB83a+L1gOU+tditvPZhePioaGBAR31nRCx7PeiEb2648Cxagu5cbNXSm
   yu0wtxcvYJTdOLMOZDIma+LZXs/FV2HAewxQRuPHQV5xw2iNUbgM3uoQW
   kAdUousDFEsQD+2vuCfoG+gLp6k9yDxf6fA03p7ZzagQ21BjRK637bwnT
   72hLDTKtOvoGR6XgUS05iaS06nag3W5oE9xyWOyJCYjKNkeWDEZiHH99s
   1cSnYOV17fItlpUBmZU3kRS7s9RXcIi01ZMttsNuMUfTK43baOt3Pe8aK
   w==;
X-CSE-ConnectionGUID: vINlodq/TFujIB6Iq7pn/g==
X-CSE-MsgGUID: vUfu2oZ6QdyQ1NyjdiVa5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="56270046"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="56270046"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 06:56:52 -0700
X-CSE-ConnectionGUID: mbWEqMjdQNKyuB/9J/LgjA==
X-CSE-MsgGUID: HpthI29WS9yTOdiA3c7E4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="200728245"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 06:56:52 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 1 Aug 2025 06:56:51 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 1 Aug 2025 06:56:51 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.53) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 1 Aug 2025 06:56:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TN7F3TUXz+8vZVjK1OGBf3g5K744NUxYtlmvUo9/s4x1BSu0T4HSpQP3ZiXLxogEg33CosHmaEwjn1gQfuzfQApB1YdqyH9j3vZddoaSzZMl12TgIAaZIBUvGfVs+UWkP9WgStkv2HxvMSOCNcRAqYZUzCwj9bWtJVAmRlVJEa1jRCwf8LQyGwOg3kfvn+6hjulpEbmI+a5ytxxwP8kvTvZ7RE/UlqmoYxgiesg1dm4jALbv8+CnzdBiIVpHQG1PW4Vrg2O0O64qNv9iT7JbGze0UQBAV64EelsZteBe9hfR75ZyDMRQBS1wHwDIQlXRnVAiP3hkr/Xyxklr2Z10Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gr3ca7+ceYJe3s7/J77zpG69lWP7ynnK0TNyl6hSMWk=;
 b=onlN0YooRLii9+0emr055ahQY6U9VYPNqlqXTXcy9XskElEI0TIR9FvHfKrVGnz++ZkvxL4I1razu8iwXqKJaE5/7f+DaBy3aT/xWSM/FtpQozyKSZx9jFDDo+iuDzNNRfnlMriPHccduLP5PVhEOQhikFDvXWrDiQlronKdyI+TOzeXEviAMwpTJA+FkZXd49hUvhRx5EQ+MxtKpvmE7UDNdwQCCNapU14Gpeo66l9m8IoIxXnTw0GhdnOQ20baHYN0isuoM2TBmkPFhw5HQ2DflZlA7871fdJawS6qckuq+5jpu9VquKvxiHP/qsXeQe5EP9al6hYDmJ97OcY0rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by MN0PR11MB6035.namprd11.prod.outlook.com (2603:10b6:208:376::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Fri, 1 Aug
 2025 13:56:42 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905%5]) with mapi id 15.20.8989.011; Fri, 1 Aug 2025
 13:56:41 +0000
Message-ID: <b27f807e-b04f-487d-be13-74a8b0a61b42@intel.com>
Date: Fri, 1 Aug 2025 16:56:36 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Vishal Annapurve
	<vannapurve@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>, Nikolay Borisov <nik.borisov@suse.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
References: <20250729193341.621487-1-seanjc@google.com>
 <20250729193341.621487-6-seanjc@google.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <20250729193341.621487-6-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DUZPR01CA0246.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b5::12) To IA1PR11MB7198.namprd11.prod.outlook.com
 (2603:10b6:208:419::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|MN0PR11MB6035:EE_
X-MS-Office365-Filtering-Correlation-Id: 52a24159-c648-4605-1f5f-08ddd1033e1f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?R3kwUUE5RmwzN0QrazVxa241SEc2SlRJbGllcGRCNzk5d3BXa1ZHaUszK0x1?=
 =?utf-8?B?TEY5cld0bEFaMEtjQlpsZXhmNUgya3pZMGxGcXl4NjNxMlVPeHNrYURwbkV4?=
 =?utf-8?B?UkVMNHdqWFNiNDhPSzhjT3hFNEhWaEpNSW9EK3huMFcyNjVLTGdjK0crSVpC?=
 =?utf-8?B?Y0lqYTVjQ01wdjIxYVFIa1dDRG9OYUJQYVYvWmJyWGE0akphR0FtczVlWUhH?=
 =?utf-8?B?d3RqVzh2U1oyNEFPeDNPaWRuaTZERnZ2eG9CZ3R1STBudTc3cU9iOURqUHF0?=
 =?utf-8?B?dldxYU82N2RzcUlpVVUzMEkyUjdvTjllU3dGNmlWTmd6YVI5YzBubURTaGJ0?=
 =?utf-8?B?aFdLa3c2aDV2RldhTzA4c1VXSUROa25IUW51RmVMUGVsbzIxYlJsS08vcGM2?=
 =?utf-8?B?WHBueEZaQlZXQlkrbjdXcHRSYSszL0FZbjlYcUEvVEZpUTJtN0tKemtkVUM2?=
 =?utf-8?B?VHZ3YjFuMTlLNlljb0Q1YXBROUlTUDBMOFhGMFZBS3J1b1lxREdnN01WUnRy?=
 =?utf-8?B?cGxtYi9LN3FxY3U0K1dSSFpjKzY1NHUxZTZDMGg4eDF3N1h1VVJveWlUVDBC?=
 =?utf-8?B?MVBMeGJONVZLWmJTTmdWU2t4eTR5VWQ5dUhnZzZHT3oyTzRWQllKM3p2K2dN?=
 =?utf-8?B?Vm40Rnd1QjU3UWVnYjRrRmpXTnVWejNoLzNIRi9XTWFlV1pHZ1pwRzQwWTFs?=
 =?utf-8?B?UHh3M0dhVWhFa3Fua1dIVldBSXdSRDV3S2JnWW1zVGEyY3Jsd2NIamVncFdn?=
 =?utf-8?B?ZmlzbFNhWWVlRXlxM05kQ3NyM1VmMzYrT2pzL0R4UnRsckJtZkZ1VjdFbUpj?=
 =?utf-8?B?YzdxREtKN3lwYXVEOHhneW1YQ3l6MHkzdVdCd2dtTE92enJzcEt5Yi9Jb2Fz?=
 =?utf-8?B?amI0L3V2Y0dqRlNnbmwyalBqRzBSQURTSUNpUXlOdklKeTB4V2UzUHg0dHd4?=
 =?utf-8?B?Ykd6ZXdUSUJrd1phNHJJVmpONXY0ZG1uMEtLT3piUjNZSUlFMFR0VWJHaUJN?=
 =?utf-8?B?V0trcDNHcjZDb0tmTnR3RmZTbnhoMEROa2JmcUpjS3JpNmxjdFUvRzVDNC9T?=
 =?utf-8?B?TTB4RU4vS3ljaG1TOEw3TDIxYkNXays3YnAyRXFiRSs2b0o3WFpjRWJNYUpQ?=
 =?utf-8?B?SGxIckdjaktJUS9TQUtQY0NKemZsd2N5ZTE5cHo2VnZpZjQvRFdkTzRpMFNr?=
 =?utf-8?B?YU91NUtJeGdmMndSbTdXQ2tkMmV0S0FBaERZckl5dWkwMk9RTHAyRXRDeEVK?=
 =?utf-8?B?TzQ4RG51bUl5cndpdFpYMjJUOCtpQktMbzBDeC9pdnYrV3VJTVd5WnpleGx2?=
 =?utf-8?B?ZFZLZDR5NHVaUW9KMVltR0JUbWhMS0VYdC9BcmZLcHVvY1hUdDMvT3k0RGRq?=
 =?utf-8?B?cUFyR2NoN2tZNG1zdGUwNkNnRk9yMW82SmNOWXdFMnl3Q0x0bFNwVGxCbmp2?=
 =?utf-8?B?V0lDSWdMRDVaTnMvVW8rR3BsTzRLMUtPWTNKT0JLSU82UE1oTXc5enJuMm1C?=
 =?utf-8?B?emJla1hPYjRoRUtHckhOdHZzeEppZGxmczMxYU8yMHl2YWJjaWpsQytPc2ZL?=
 =?utf-8?B?WnZiSFdOT0JwNytLcGxuTFRRUkk4Z1M0ZmkrakRrK3Y4aGhjNEZ0aXFXZTJE?=
 =?utf-8?B?MWl0Mk9tRjZtaWFZVVhtVFljWnUwbWpMY29iQ2dodmhLSVE4VkZBeWhjdkZm?=
 =?utf-8?B?cUxRSWxIa0ZYY1pYb09MZkFLaEtOM2ppRGYvN2hjTHRZNktDT0I1eHFmb1dT?=
 =?utf-8?B?ZWU1OVM1bXRoVzY2ZGtuS0FmMy90TXlyYVhkSVhYeXJKczJzWHdXL0o1MThL?=
 =?utf-8?B?TlVzdEx5dFIzWlBDd1dIRW5LeGw0cG9qb081Mll6cHpHT01rTHNYaWEwaklB?=
 =?utf-8?B?ak56OFZoa2luWUxIY2NNSCtIc0RaNTBwb1B1MlhUT2E0TUE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YnE4eVpXYWRzeUhlZFJiK3h1a3JuSkMyMHgyL0VCYnVGRzBGWGpIQnJnWTVS?=
 =?utf-8?B?a04ydHJoeERNSjVrbWJNVllrSTBLMCt3Z1BlM1hDZ1dyejRGOUw2QmI5R2o4?=
 =?utf-8?B?WTIzODBiU1c2QjM4c3Yyd2I5OVZsRDFKVGpjcTQ2d0ZXSmhuTTl0UlVsVGlp?=
 =?utf-8?B?VG1BbzZtb09nYUVEOGxkMXJ1dXVTMURrcVd0RGJDVzlqck16TTJ5ZytscnFL?=
 =?utf-8?B?MlFWMXhWNXVPdVUwOFhYaXVxbStEcXdkL012ZFUrVU9Gc1FqanpsNDl3dERK?=
 =?utf-8?B?NGVtTi9kWGNOTUVxT1VWNTN3K0s0YUxTenFlS0tmQklIMGRMTVZSVCtZR0lF?=
 =?utf-8?B?RDRwdXY2OEFCNXN6VzBVV0hadlRyazBxdERBNXRmT1g0aE92blczdk0rSVdO?=
 =?utf-8?B?ZmRNZU5Rd1Z0SzNaUnc0L0QyclJSVjFlc3dNU2UzWW5oRFJSdFVXbmNKMDdO?=
 =?utf-8?B?NEpsU1liMFQ1bWQ4VkFzYWtFK0pLazVlTWR5UXhtV1pMeHdQUTBLUStwZ3o4?=
 =?utf-8?B?Wlg2ZDFacnB0WWk2MXdyeklaRzJRSVRYeGdFY2xMaHBMak9DK1JGTDVzR0dN?=
 =?utf-8?B?SURRcXlpWVRENDJqZTNoM0tJYncrNDBQejhVbUtsdGlzVmwvbzAwYVlqR0Nm?=
 =?utf-8?B?bjIxbnJSNkFkcEV2Wm0wYTR6YnpuYzdBTDl6dGVJd202dU5EYm8yVEsyMVc0?=
 =?utf-8?B?QlBuL2gxalpTWFBJUFJDZjNzR0JxWlN5cHQ2NkhDamkyd0JITk5xQkRnZXJq?=
 =?utf-8?B?RG54YkdqTVd2Z0ZFRU9veHlCRkxXajNGSTB0eW02Q0E0aXFRUHFSd2hrUHVp?=
 =?utf-8?B?ZHFBQWlIdnI4ZzNsQzE2WDdWMlYrMEhSSkpyVFlxT0hiMkJ6Zjc5VVAzbExZ?=
 =?utf-8?B?TldCWE9WdUFDZFZ1bUVsZEVDbVJCcEFBZUhoNjZRV1RUSWI2a2x5RmNjZDhW?=
 =?utf-8?B?dERUWnRlRmFCenFOSnI3NG9sMGpKbWhTWlRqeEdzaGo0bEUyUE5QWHBTVzUr?=
 =?utf-8?B?YWdFU0phWllPalNkU1BodEM1ZUxnc29GL0lIRlh3aGZ1TzdZZjdEc2krSGVX?=
 =?utf-8?B?WXZ3SUJpSGFORWN2U3h1YlkxbVlLVjJyR3JKWXdhRkQxZ0M5emljcTBEQncy?=
 =?utf-8?B?UHh1Yit1T2dmY0RZRFVOem1hOEd0bFNmTXl3TXU0Mk5wWkxGYndZZHAzYnJl?=
 =?utf-8?B?dTlWY1pTdUd6YVlQbHMweWpLcXd1UTJvVDVSQXdaWk1scVgyR3QyTzV4N05i?=
 =?utf-8?B?S2dMWnRMb29WbWF4Sm9HVUcvOHNLOVJ0YXA4ODFEbVZWSk5GQzA1WEtNMmlw?=
 =?utf-8?B?U0pWNE1uVzMrVnR3TnB0MlB1UkFvbkw0L21kaytnTFZYekxSUU1jRHovVmRr?=
 =?utf-8?B?SnVqbXorOWo4MmM4M2xlcjVYYXdMMDEzclQxSkw2UUluVUF4WTc4SHErdjZq?=
 =?utf-8?B?cE04ZzBwb0twaEJYbzcxY1hiTzZLdGdoOW5OM21vQ3lqcnpiVGNubzRFaVp1?=
 =?utf-8?B?Mzd3N0JOQTEzaXIyYmRiNUVLYlBVaWJSUnpSa29NVlZvQUgycU56MUs4NEJm?=
 =?utf-8?B?VHBoS1FDQ29BdXhkbnd0dExPYkd0cnJrVkVpVWk0QTQ2bUpOYUJGNFFxczBE?=
 =?utf-8?B?cE1kKzhjTVFBSHNmaWpBMmRmZ2pkQkRXR0FtVU5WaWIydzFmamlaUExEVXlx?=
 =?utf-8?B?bFhVSEFycklIVHQ1NzBwZXhrSlBtRFNIZEJHcVdTbytreFNsblpMQzhVdkE0?=
 =?utf-8?B?eng1VlRQa3ZvaU0wM3I3cVVGUXVQYkhNUjU5RVZtUktHbS9oNXdUM3NkQnBr?=
 =?utf-8?B?S3R4M1hSUHZqcEp6eXVmbDV5R1poTVpEQ09oTXlMSDhmSFNUbllwOGVTUVlq?=
 =?utf-8?B?UlkrVEJKcEVwYldDWE04ejZtbVgvbWxpVmVFRHBiUXdSODJha2VVTHBhbUhS?=
 =?utf-8?B?ZmxxTTR2QURLbTV0V1kveVdZSzVnaGNMQzV3MHhWc1pqTENMSkhKdGtoNENa?=
 =?utf-8?B?K295amdGMDlBVXdPWkJ5OXdCb05iaFNjOWVGdjlHZHp0UGl1dkE3MTBIai8v?=
 =?utf-8?B?U0duN1pzYURHdVpxbXJrNUtLdzdhTW4ySmNmQ1laN2tjQzkzR3pFazA5aHp4?=
 =?utf-8?B?Yi9vam9WbWpjbDFGK1ZQdm9jUGpreEIwQjM4T2RXWnhXL1UrcVJSNy9BZG0v?=
 =?utf-8?B?RUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 52a24159-c648-4605-1f5f-08ddd1033e1f
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2025 13:56:41.8024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3v4iH0f3X5+tIRMTRO4BSP2PbistgZykIBghxC1huWvVHIBAI5jbFZ37B9rMI7Njwh13KNxSxXRVtSa8os4UJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6035
X-OriginatorOrg: intel.com

On 29/07/2025 22:33, Sean Christopherson wrote:
> +static int tdx_terminate_vm(struct kvm *kvm)
> +{
> +	if (kvm_trylock_all_vcpus(kvm))
> +		return -EBUSY;
> +
> +	kvm_vm_dead(kvm);
> +	to_kvm_tdx(kvm)->vm_terminated = true;
> +
> +	kvm_unlock_all_vcpus(kvm);
> +
> +	tdx_mmu_release_hkid(kvm);
> +
> +	return 0;
> +}

As I think I mentioned when removing vm_dead first came up,
I think we need more checks.  I spent some time going through
the code and came up with what is below:

First, we need to avoid TDX VCPU sub-IOCTLs from racing with
tdx_mmu_release_hkid().  But having any TDX sub-IOCTL run after
KVM_TDX_TERMINATE_VM raises questions of what might happen, so
it is much simpler to understand, if that is not possible.
There are 3 options:

1. Require that KVM_TDX_TERMINATE_VM is valid only if
kvm_tdx->state == TD_STATE_RUNNABLE.  Since currently all
the TDX sub-IOCTLs are for initialization, that would block
the opportunity for any to run after KVM_TDX_TERMINATE_VM.

2. Check vm_terminated in tdx_vm_ioctl() and tdx_vcpu_ioctl()

3. Test KVM_REQ_VM_DEAD in tdx_vm_ioctl() and tdx_vcpu_ioctl()

[ Note cannot check is_hkid_assigned() because that is racy ]

Secondly, I suggest we avoid SEAMCALLs that will fail and
result in KVM_BUG_ON() if HKID has been released.

There are 2 groups of those: MMU-related and TDVPS_ACCESSORS.

For the MMU-related, the following 2 functions should return
an error immediately if vm_terminated:

	tdx_sept_link_private_spt()
	tdx_sept_set_private_spte()

For that not be racy, extra synchronization is needed so that
vm_terminated can be reliably checked when holding mmu lock
i.e.

static int tdx_terminate_vm(struct kvm *kvm)
{
	if (kvm_trylock_all_vcpus(kvm))
		return -EBUSY;

	kvm_vm_dead(kvm);
+
+       write_lock(&kvm->mmu_lock);
	to_kvm_tdx(kvm)->vm_terminated = true;
+       write_unlock(&kvm->mmu_lock);

	kvm_unlock_all_vcpus(kvm);

	tdx_mmu_release_hkid(kvm);

	return 0;
}

Finally, there are 2 TDVPS_ACCESSORS that need avoiding:

	tdx_load_mmu_pgd()
		skip td_vmcs_write64() if vm_terminated

	tdx_protected_apic_has_interrupt()
		skip td_state_non_arch_read64() if vm_terminated



