Return-Path: <kvm+bounces-16687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C5E6A8BC918
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 10:05:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38E581F228F3
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 08:05:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DEC014198A;
	Mon,  6 May 2024 08:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YLbOZjMY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC1D1411DE;
	Mon,  6 May 2024 08:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714982724; cv=fail; b=q1AWa1h4RYEOUf/A05FBgOIXueHRUAVIUSk/9xaqXCd2tUueZJDUFy+Vds6DxQytTLJIN5xxPsWWmOGnVWqOa+9vVCmH8AD0XbHqoqHni9/zk8UZ8hvgvVHRWOS8Bat2cKgI23CqbKrvWMwlfLYIcKCtA9uByPrBBXlnE3zPc18=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714982724; c=relaxed/simple;
	bh=GwFvKoYeUMkbBBK1SWBIbmdAbNXrMuESB/zgvEK4CvA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XgQY7UjOtJ542S+ct48tSjc9MUqd/oSlazaeiAH/xD2H8bAvtotb0COF+UGU6S1LJR9xgvl9lqsNIi13Zgwo2wxddbyAjFXT7LFBM5bQjEHlfbz7w44HtX/sR+nsUrh0T4viMFdMFOGLPvu9Lw8h0/Dz/B7llN010p4SFjMS8aA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YLbOZjMY; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714982723; x=1746518723;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GwFvKoYeUMkbBBK1SWBIbmdAbNXrMuESB/zgvEK4CvA=;
  b=YLbOZjMYlNpY2KZwxg006Lzyg8Rn/czeyfCPIxjWwp/vc8DzcD7oo72k
   SH7/6simokBMfutM6Dr3w9Q+D54Z44bFWWXy7WkqMyPnRV3N+r6Gk0JbY
   3hTzDJ2TvglUYDTVE0ngDyZHeIMDeiOZZ849RF+5otI4pLZx0U0/KP19M
   /ylrV+dZFXXhKROvkJP1d+NVeFSSgATbeRSi+YNDrGXRU/wZblkNfiQmC
   eAUn6YOpTgcGooQxaXZ/BAZzmfBVjYL/t82zeB2PRNOfI/NPmN+sFlMep
   MKwOsw1W93O9Ow9X6CImkrrMXpIttJmkyOwJVu8PH/SG5iDw+3Jum6JZv
   A==;
X-CSE-ConnectionGUID: OfmoOzqKSny9Bhf57mtASw==
X-CSE-MsgGUID: Hyfi3l2QSpCAL+4Vg4Crmw==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="36105316"
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="36105316"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 01:05:14 -0700
X-CSE-ConnectionGUID: wdgLcM9oR/C1wRz7ZOkELw==
X-CSE-MsgGUID: KNsI8N4QQ8yQBGPac6mqYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="28600977"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 May 2024 01:05:15 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 01:05:14 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 01:05:13 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 6 May 2024 01:05:13 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 01:04:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AGOcxCbZN2CnW0eGrawqJncCP/693EG9TpE65OvIfD/2QjIGSdqH6ZGLcsuRqUpb+jHXOvkyGW/5Sq45ndT1mvkP6iMOosUzTHyPtUeOBKFBGJyo69swKb4PTMdbvzHG37IIa+O6MZ4aX+rrjoCwsta/GJVJQPT6XXQ0mwTzIIV01SVPlcVA++Y0+KC6+4TPg75bnysfA85IpzfEHwzZkSHXk4My8LdY+71V/jn3IcBeZEN8e0UklIEBhBygrO696y2xAjU7jRdO7zxxlWlKjl4TjQigCLi0a7A3iBuNa/09ju4m7nCr5FJQVNGZKlikDhzJS58HxuOIyUTQM+OKVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GwFvKoYeUMkbBBK1SWBIbmdAbNXrMuESB/zgvEK4CvA=;
 b=frHAP2pUF7rUfcdEbK4WDwLJrXxtmXSN3gWl+tvNhBLACQyy9Xlre7ppRr1UO4qkqQ1eSUajGUqGFsUXvSkH6MFusmLY6nAakGIr+ppAgVbJkJtUklYNwAMFQk4/TAZid0HH+E+ys0rtPPuIK7XmcCp2IBbzBefhdJlB/42vYsWuBs4ebTSjUqwL3zEXaKGs8XFMmzstCjPEM2BJC5d77AObsELkWjoDe0lc/gGKymj0opeNwBQVA9NMMGPMynOfrSQfFglfTkzbTgo/2JNjvldk+fzuGz2WDSiJ8erVOCVj4eWHfw6pqLm/HiaKCqUAJygkAg3QvbQqUAn1/XKnBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CYXPR11MB8663.namprd11.prod.outlook.com (2603:10b6:930:da::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Mon, 6 May
 2024 08:04:51 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.041; Mon, 6 May 2024
 08:04:51 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "jgross@suse.com" <jgross@suse.com>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de"
	<bp@alien8.de>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 2/5] x86/virt/tdx: Move TDMR metadata fields map table to
 local variable
Thread-Topic: [PATCH 2/5] x86/virt/tdx: Move TDMR metadata fields map table to
 local variable
Thread-Index: AQHaa8I+8d+IE3gw2UmktbgHk9eDW7GGDs+AgAQxzQA=
Date: Mon, 6 May 2024 08:04:51 +0000
Message-ID: <aeccabf25c5c4e5e721f0ee5a83892061a6b2d76.camel@intel.com>
References: <cover.1709288433.git.kai.huang@intel.com>
	 <41cd371d8a9caadf183e3ab464c57f9f715184d3.1709288433.git.kai.huang@intel.com>
	 <b78a383d-27bb-43e3-8e61-f8a6b25b2708@intel.com>
In-Reply-To: <b78a383d-27bb-43e3-8e61-f8a6b25b2708@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CYXPR11MB8663:EE_
x-ms-office365-filtering-correlation-id: d94efb0c-8379-4bd6-c042-08dc6da334d3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?QStOQjk3dzQ4ZldZSHBmdC9uSFNjaE9kSHhBajZ5SWI2R3BOTWlLeWhFNDZR?=
 =?utf-8?B?OEFZUHlRNGhvWE9YZThEdENXRzRmQTB1N21HMlZBcjVhMFJNcWVpLy82T2Zi?=
 =?utf-8?B?elpMcGJSZ3d5cmdkRUgvVGJmdUt5aWdERmhoUk9rOHoydGJlb3dVa3NhTTlu?=
 =?utf-8?B?M1VyVHNFNldhUUZzS3VXdjNsVTZZVW1yNmNRdEZnZlU1aTE4YVAySEdSdndS?=
 =?utf-8?B?TnV3eVN6dXc0TjAvaEw4Rzdhcy9IYTZEUnNUMkg3emNIbHY0OEkzcUM2b2Ix?=
 =?utf-8?B?bXpDWXVlMllpa3pWSzlDbHRqSWxySXd1am5DckpLK2lyam80eU43YXVDVlhC?=
 =?utf-8?B?YnZYQmtyM3d4aU5VMktRZG5kR2NjdzM2b0czZ3BEM1dHQmhkdE5VL3B2eXVl?=
 =?utf-8?B?SVB3MGZOanVzdmVGSG1qMmpMelZZTHBoWFRqNTNwRUFnSUhUNjJ5dmJlSE9C?=
 =?utf-8?B?WXhaSUxJKzVWTC9menRXVkswcFBLanVNYXhQeWUwS1g4ekRXMkp5ZDZGb2cr?=
 =?utf-8?B?K3ZTNUtKVTUyaFpsOW14SVR1bTU1Mmx6SGVhUE5sdkJLUDhrQ1Q5VGVhV1Rr?=
 =?utf-8?B?ZDM3K2F6cVp0THdsc2hnNHd6YlJXcDlYazVoZ3NKZEZhbjd4NVVtWTRXTlps?=
 =?utf-8?B?Ym1EZDlHd0NNWGNvaVVKNWhFc2JhQWFBcVNwU3BKSkpTOFZqTURkb2FpL1BM?=
 =?utf-8?B?WG1jbWxLR2R4SlFweG1tUXlDeVo0S3RCZFJSQmRKNUI2dkYzOTRJVFNPUjFR?=
 =?utf-8?B?RnZJUy9oQVBUaURVWVZoR2dyU1RVTldMcHB2ZzJ1SFJJUy9YbGViWXZ0eGtY?=
 =?utf-8?B?OS9JQThabHRNa1VzMzN0eHhEYVA4S1dnL1RGa25ZNzFCOTJkL3UxVituOHlV?=
 =?utf-8?B?UTFDOHRMN2NpaFJZTEJsMzg1TW0rUEVteXlhbitHSHI0TG9uU01RSEsyRnZ1?=
 =?utf-8?B?THdhYUdqL3E2ZjFNeEphSjlOVm8xUWxCSzZMaTRqK2JnRGViN2d0ZUQvTEJU?=
 =?utf-8?B?YlRMMi9LR2RwVmxEMksvSTNWZzRUQVp0MmtmYkFEQ0hPTFZ6VERxckMrdTBS?=
 =?utf-8?B?ekp3RzBSbU1ZUnFuakx4eE1KQVZXSWlsbkRmUzhnSnVUMGVYNnpRL01nSnla?=
 =?utf-8?B?WHpoZG1PMXdoWWJLZmpDT2IvUDlmcXVXUHM3aTdSTUFwTDJwOWVTVCsyRng1?=
 =?utf-8?B?Y3plZ0pJQU1ra0N3LzBuOGhJL0pRZGJRT0J3czl0eVNzNFhIcnEyTGFSYmJO?=
 =?utf-8?B?NFMvelFuSUE0RnRFclZ5OUpVRU5TZnBVSHRxc3VLVVlHaVZHZzdwdzZwMHhX?=
 =?utf-8?B?azZqSGM5a1pGOUowY3lMUUpNMWpuaG10TFdBbEJxTVVWTTByeDlsdXlVbXd6?=
 =?utf-8?B?RGtjUDJrZFhUYUUwcDh2Y0tOekpLdGVnM0xaSlBrMDlBWHlEdkFrVnEvblpQ?=
 =?utf-8?B?bzdDV1dubjZHMkIyU1d2eElodjJqLzR0alY5VmI4VzRhODFoeTZLZXpEU1lP?=
 =?utf-8?B?TzJCTHdkUnFqY00vNjdZcHBHSnJ2TzZXTWNaWEtOR20rQThBTmdLSXRDTUoy?=
 =?utf-8?B?T1BxQnk2dDRXdnRSdVBjTmpCckFWNHhCVE9mYVYyMmlyNUNtU1M5QzVBNXIv?=
 =?utf-8?B?S2hZTTNMSWFia084QmxVMlo3UXRsUDdmN0NUY2xKODhBenlCWTNkd3RXb3lX?=
 =?utf-8?B?N2FCdHh6QUZGOE5aVUh3UDR3MHFaeEQwT0Nnc1hhSUFzN1g5TnZyMC96Y1pJ?=
 =?utf-8?Q?VF7zN2dkB33rdC098puZ5e7vg/6PJRW416Fh0V8?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?elF6bGFaaCsydnczR2NPRjFoREJYWkRuUVdaMCtiK2xmMjBIWjBJSXMxTEJQ?=
 =?utf-8?B?N2l4NU1uQ2tIMmdBNUhVNWlCU1BsRXViVXVOOHE4Z29XamM0M3U2VFMrQmUy?=
 =?utf-8?B?Vkc1SkR2VldERWtVQlNKYkNlQ2dxbTVwQ3NaM3JkcUFza2RiNW9ucmtPOXUx?=
 =?utf-8?B?eXZOTnh3NTlxcSt5amFCWWZuWG1BYU1KeGVHaW1aV3NnTUlTR2ZUbHdKL3F2?=
 =?utf-8?B?dzhUN1JhK05IV1M3clNIa1pRaHU2SUlncEljMjR1bmttcXhpb2wvYm9uYndi?=
 =?utf-8?B?S0hMNVo1bERiUDhlMFd6YjQ1dVVoZGtiOWtzMjVQUzJUbXQrenQ2anNOTWtR?=
 =?utf-8?B?REdZQzRndHo2dFN5WEU1dVQxRURkZ3luTk9EYWFUWFhOYm9memhuKzVPUEV5?=
 =?utf-8?B?VXVKb3V2VzZISWV6WjhtMG91R3NxRFZLNlJxdjdaK0plV3NFYWpyd01vRXBY?=
 =?utf-8?B?amlIZEhUZjdMQ2tHMGdVdUpicUUxYldMbFlIYXpXRWFLV0Q3UGgwOE5lRVNW?=
 =?utf-8?B?bVFDaGlWZUE1TEdOZTA5V0Fsb090TVVwYmNIMmw2Q0VVa2hjL3hFWG9IUWdl?=
 =?utf-8?B?dy93SG5HSDkrMXRPR002Q0FlWHIxRzIrb2VYcVBDdmdJcXJWamRnZVBlNnAz?=
 =?utf-8?B?dUsyaDhOUXVtU3FmS1dKMGQ1dXJsenFGOWFsc3haZ3cvWlpGY0ZJVlU1MWZt?=
 =?utf-8?B?Y1RvakQ3M0M1NFllRnZyKzlad2xqbllPVDh5Mnh5bmQxbDNhRUltYmpkZk1I?=
 =?utf-8?B?MmRUSWxxbTRjenFEZXhNbUhzT3NITFJpUm04dEs5OXNxMm9PNVNjYW9UNkxa?=
 =?utf-8?B?UHpzdWVCSGRhdysxVEkrcWpWOS94SDBkTU9kaEJBTFpudGRVV1VyNi9lR3U1?=
 =?utf-8?B?d0tWUmpYeU1qdmpLSllicmRmYWwwUmUrOThlaG5xbjY0K3JuQjVhTElyT0l0?=
 =?utf-8?B?OGVtQ1BUQXhOSHdCZ0VhT3BhTzk0VTIyakh1UENVaTNnY2pwc0dYWnhRN0FF?=
 =?utf-8?B?VitOa28zRHhUZTVKc1FQOWhKN2ZmQzBuR2tXcGROMDhrdnpka0w2bVl6OS8w?=
 =?utf-8?B?dWFPR2pFZDF3VEFYaWRWNjBpeHdIY3VsWFdzVlF3eGJOY2gzKzVTNVJ6RnVS?=
 =?utf-8?B?cGorbjBkQ3JtRC9UTHJkZEFUTWhTOEJWdHg1VE5QWFFmTWk5TEJRcURiZDcr?=
 =?utf-8?B?SFNzMjF5RThWLzVtYVQ3MndybnR5eXhTZG5PS2lTcXpLTVA5VGNaRzkzSnZp?=
 =?utf-8?B?UjFhT2N6QkRTOGxVbkNHSEplUXlIbW1yT09HVVVKN2ZFck1STVRTSG9ZVmZx?=
 =?utf-8?B?NUFZYWlzM1I0T1hWWHgxb1Vhb0ZQNXFmOTFiTTFSak40ZEVtMDJiYi8wbVNs?=
 =?utf-8?B?RTFpdThERTIrUVpLczNZUmdVNHVBN1lPRExKL2ExNG9CTkNISlJZSFhqU1BT?=
 =?utf-8?B?MS80U2pxejQvQm13dWdibEsyWk5ORmMyMVVIeU9aYnBVOURuSUdFQVdFcmV5?=
 =?utf-8?B?SFJYdXJLRGpueXQwK1BTSkMxRHpoS0dxaXg4NUtickVwVUFscHBZZktWVVVi?=
 =?utf-8?B?bWRuMWNyVXc3bXloWXk1SGUxbW1UL3pwdldzcEhQSGdmTGt4RDFlaVRaMlBl?=
 =?utf-8?B?ZUFFVFk1SjdmVmlFVVVYMk1RenVOODVQeE1sZkFzeFJCQWFob1JJaHp5eUxU?=
 =?utf-8?B?RU9vWElUb0F6RStBSk5Rbk9RNmFpU2UrTXk4REEvcTZ4SkdycnZIaHk1bkhC?=
 =?utf-8?B?NTBweXlDZDRobmpNYWZpUXJnYTYzMFNneUd0YWtMV2l3RjZpQTNCOUZsRlBI?=
 =?utf-8?B?eWZTamt0eDN1dnF0a3M1YXg5NlNGNkJGMDAra3BqOHlQM09WVFhEcjNlUDY5?=
 =?utf-8?B?d3orS3JXZ2x1MDA3L3hCRWNzOWdBOUxiVGZCdTJ3dkZHd0RLMkRRYUdpc0hF?=
 =?utf-8?B?TDhSVlV1azZUcHVxTW9mOFRKSHZIMU1vVFVreGMxTlRXdThOSlBwNHhEelJk?=
 =?utf-8?B?cmRjMVBjUmNYTTdCM0lSQ2FoVEdtOEQ2cDY2V3AwNVF2RWRvK2xwbUZOVVdm?=
 =?utf-8?B?QzQ4Mi9aUit5ZjAzem1XT2pUZm1XMUozZnpuSi9lRFRPVFVNTmt5ejJnenM0?=
 =?utf-8?Q?KfDGunZXJ2nAj5Pq6ElrlpsKu?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AA38B57444AEA4408E094CB3F0D477CE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d94efb0c-8379-4bd6-c042-08dc6da334d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2024 08:04:51.3085
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: falGyJ/eB5dbxeej4DAiahRtRDvhthPc0IbgzDyDEpiY69NQknTnVJK8UjtauCL0Wck5QNcSBJhF0lEL7nWyrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8663
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA1LTAzIGF0IDA5OjAxIC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMy8xLzI0IDAzOjIwLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gVGhlIGtlcm5lbCByZWFkcyBh
bGwgVERNUiByZWxhdGVkIGdsb2JhbCBtZXRhZGF0YSBmaWVsZHMgYmFzZWQgb24gYQ0KPiA+IHRh
YmxlIHdoaWNoIG1hcHMgdGhlIG1ldGFkYXRhIGZpZWxkcyB0byB0aGUgY29ycmVzcG9uZGluZyBt
ZW1iZXJzIG9mDQo+ID4gJ3N0cnVjdCB0ZHhfdGRtcl9zeXNpbmZvJy4NCj4gPiANCj4gPiBDdXJy
ZW50bHkgdGhpcyB0YWJsZSBpcyBhIHN0YXRpYyB2YXJpYWJsZS4gIEJ1dCB0aGlzIHRhYmxlIGlz
IG9ubHkgdXNlZA0KPiA+IGJ5IHRoZSBmdW5jdGlvbiB3aGljaCByZWFkcyB0aGVzZSBtZXRhZGF0
YSBmaWVsZHMgYW5kIGJlY29tZXMgdXNlbGVzcw0KPiA+IGFmdGVyIHJlYWRpbmcgaXMgZG9uZS4N
Cj4gDQo+IElzIHRoaXMgaW50ZW5kZWQgdG8gYmUgYSBwcm9ibGVtIHN0YXRlbWVudD8gIF9Ib3df
IGlzIHRoaXMgYSBwcm9ibGVtPw0KPiANCj4gPiBDaGFuZ2UgdGhlIHRhYmxlIHRvIGZ1bmN0aW9u
IGxvY2FsIHZhcmlhYmxlLiAgVGhpcyBhbHNvIHNhdmVzIHRoZQ0KPiA+IHN0b3JhZ2Ugb2YgdGhl
IHRhYmxlIGZyb20gdGhlIGtlcm5lbCBpbWFnZS4NCj4gDQo+IEknbSBjb25mdXNlZCBob3cgdGhp
cyB3b3VsZCBoYXBwZW4uICBDb3VsZCB5b3UgcGxlYXNlIGV4cGxhaW4geW91ciBsb2dpYw0KPiBh
IGJpdCBoZXJlPw0KDQpJIHRoaW5rIEkgZmFpbGVkIHRvIG5vdGljZSBvbmUgdGhpbmcsIHRoYXQg
YWx0aG91Z2ggdGhpcyBwYXRjaCBjYW4NCmVsaW1pbmF0ZSB0aGUgKHN0YXRpYykgQGZpZWxkc1td
IGFycmF5IGluIHRoZSBkYXRhIHNlY3Rpb24sIGl0IGdlbmVyYXRlcw0KbW9yZSBjb2RlIGluIHRo
ZSBmdW5jdGlvbiBnZXRfdGR4X3RkbXJfc3lzaW5mbygpIGluIG9yZGVyIHRvIGJ1aWxkIHRoZQ0K
c2FtZSBhcnJheSBpbiB0aGUgc3RhY2suDQoNCkkgZGlkIGV4cGVyaW1lbnQgYW5kIGNvbXBhcmVk
IHRoZSBnZW5lcmF0ZWQgY29kZSB3aXRoIG9yIHdpdGhvdXQgdGhlIGNvZGUNCmNoYW5nZSBpbiB0
aGlzIHBhdGNoOg0KDQpiZWZvcmU6DQoNCglmaWVsZHM6DQoJICAgICAgICAucXVhZCAgIC03OTk4
MzkyOTMzOTE1MDMzNTkyCS8qIG1ldGFkYXRhIGZpZWxkIElEICovDQoJICAgICAgICAubG9uZyAg
IDANCgkgICAgICAgIC56ZXJvICAgNA0KCSAgICAgICAgLnF1YWQgICAtNzk5ODM5MjkzMzkxNTAz
MzU5MQ0KCSAgICAgICAgLmxvbmcgICAyDQoJICAgICAgICAuemVybyAgIDQNCgkgICAgICAgIC5x
dWFkICAgLTc5OTgzOTI5MzM5MTUwMzM1ODQNCgkgICAgICAgIC5sb25nICAgNA0KCSAgICAgICAg
Lnplcm8gICA0DQoJICAgICAgICAucXVhZCAgIC03OTk4MzkyOTMzOTE1MDMzNTgzDQoJICAgICAg
ICAubG9uZyAgIDYNCgkgICAgICAgIC56ZXJvICAgNA0KCSAgICAgICAgLnF1YWQgICAtNzk5ODM5
MjkzMzkxNTAzMzU4Mg0KCSAgICAgICAgLmxvbmcgICA4DQoJICAgICAgICAuemVybyAgIDQNCgln
ZXRfdGR4X3RkbXJfc3lzaW5mbzoNCgkgICAgICAgIHB1c2hxICAgJXJicA0KCSAgICAgICAgbW92
cSAgICAlcnNwLCAlcmJwDQoJICAgICAgICBzdWJxICAgICQyNCwgJXJzcA0KCSAgICAgICAgbW92
cSAgICAlcmRpLCAtMjQoJXJicCkNCgkgICAgICAgIG1vdmwgICAgJDAsIC00KCVyYnApDQoJICAg
ICAgICBqbXAgICAgIC5MOA0KDQoJCS4uLi4uLg0KDQphZnRlcjoNCg0KCWdldF90ZHhfdGRtcl9z
eXNpbmZvOg0KCSAgICAgICAgcHVzaHEgICAlcmJwDQoJICAgICAgICBtb3ZxICAgICVyc3AsICVy
YnANCgkgICAgICAgIHN1YnEgICAgJDExMiwgJXJzcA0KCSAgICAgICAgbW92cSAgICAlcmRpLCAt
MTA0KCVyYnApDQoJICAgICAgICBtb3ZhYnNxICQtNzk5ODM5MjkzMzkxNTAzMzU5MiwgJXJheA0K
CSAgICAgICAgbW92cSAgICAlcmF4LCAtOTYoJXJicCkNCgkgICAgICAgIG1vdmwgICAgJDAsIC04
OCglcmJwKQ0KCSAgICAgICAgbW92YWJzcSAkLTc5OTgzOTI5MzM5MTUwMzM1OTEsICVyYXgNCgkg
ICAgICAgIG1vdnEgICAgJXJheCwgLTgwKCVyYnApDQoJICAgICAgICBtb3ZsICAgICQyLCAtNzIo
JXJicCkNCgkgICAgICAgIG1vdmFic3EgJC03OTk4MzkyOTMzOTE1MDMzNTg0LCAlcmF4DQoJICAg
ICAgICBtb3ZxICAgICVyYXgsIC02NCglcmJwKQ0KCSAgICAgICAgbW92bCAgICAkNCwgLTU2KCVy
YnApDQoJICAgICAgICBtb3ZhYnNxICQtNzk5ODM5MjkzMzkxNTAzMzU4MywgJXJheA0KCSAgICAg
ICAgbW92cSAgICAlcmF4LCAtNDgoJXJicCkNCgkgICAgICAgIG1vdmwgICAgJDYsIC00MCglcmJw
KQ0KCSAgICAgICAgbW92YWJzcSAkLTc5OTgzOTI5MzM5MTUwMzM1ODIsICVyYXgNCgkgICAgICAg
IG1vdnEgICAgJXJheCwgLTMyKCVyYnApDQoJICAgICAgICBtb3ZsICAgICQ4LCAtMjQoJXJicCkN
CgkgICAgICAgIG1vdmwgICAgJDAsIC00KCVyYnApDQoJICAgICAgICBqbXAgICAgIC5MOA0KDQoJ
CS4uLi4uLg0KDQpTbyBsb29rcyB3ZSBjYW5ub3QgYXNzdW1lIG1vdmluZyB0aGUgc3RhdGljIGFy
cmF5IHRvIGZ1bmN0aW9uIGxvY2FsDQp2YXJpYWJsZSBjYW4gYWx3YXlzIHNhdmUgdGhlIHN0b3Jh
Z2UuDQoNCkkgdGhpbmsgdGhlIHBvaW50IGlzIHRoZSBjb21waWxlciBoYXMgdG8ga2VlcCB0aG9z
ZSBjb25zdGFudHMgKG1ldGFkYXRhDQpmaWVsZCBJRCBhbmQgb2Zmc2V0KSBzb21ld2hlcmUgaW4g
dGhlIG9iamVjdCBmaWxlLCBubyBtYXR0ZXIgdGhleSBhcmUgaW4NCnRoZSBkYXRhIHNlY3Rpb24g
b3IgaW4gdGhlIGNvZGUgaW4gdGV4dCBzZWN0aW9uLCBhbmQgbm8gbWF0dGVyIGhvdyBkb2VzDQp0
aGUgY29tcGlsZXIgZ2VuZXJhdGUgdGhlIGNvZGUuDQoNClRoZSBtb3JlIHJlYXNvbmFibGUgYmVu
ZWZpdCBvZiB0aGlzIHBhdGNoIGlzIHRvIG1ha2UgdGhlIG5hbWUgc2NvcGUgb2YgdGhlDQpAZmll
bGRzW10gYXJyYXkgYmUgb25seSB2aXNpYmxlIGluIHRoZSBnZXRfdGR4X3RkbXJfc3lzaW5mbygp
IGJ1dCBub3QgdGhlDQplbnRpcmUgZmlsZS4NCg0KVGhhbmtzIGZvciB0aGUgaW5zaWdodC4gIEkg
aG9wZSB0aGUgYWJvdmUgaXMgYWxsIEkgbWlzc2VkLCBvciBhbSBJIHN0aWxsDQptaXNzaW5nIGFu
eXRoaW5nPw0KDQpBbnl3YXkgYXMgcmVwbGllZCB0byBSaWNrIEknbGwgZHJvcCB0aGlzIHBhdGNo
IGZyb20gdGhpcyBzZXJpZXMuDQoNCg0KDQo=

