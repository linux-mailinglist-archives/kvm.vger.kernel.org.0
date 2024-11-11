Return-Path: <kvm+bounces-31521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59A079C45DB
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 20:31:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 270D5B22871
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 19:31:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72B4F156C5E;
	Mon, 11 Nov 2024 19:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GMPRIxUd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAB41BC4E;
	Mon, 11 Nov 2024 19:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731353456; cv=fail; b=sggiQTwz+rIL7NpKKbHIDFy7SkiG+LwRmS0Vy549TDxZCzgrpV+oHSo7M/JWNmmx9zbn9zJOViyDQY95qy6lr9pvzmOsLV5qX5bBp0Ks1jMQA0WZ4bA47hNhonqnS6+UOKYUhTyjDDJqienBSVoXLDFlX6Bq3YkxPxdtx8/wBu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731353456; c=relaxed/simple;
	bh=UhKeAnH686SnXclASgBgnomzjV2fLza/i7EMZSSU948=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sGNbOnpuLqzbbV4Hc+BPMu5HHFFTOmJQVVFhnra/5MeBj7XuosikrNBPCh1F8+DBRysh8wGTcgbvDOxu8wHLG4EX5L2BRZyIPGe6DugQR8vRHZtNZvMZ7C9wpTh5UIjFC9pvLguHiQxZ7ufczORQ/7MjImvLgxwBa4EwX5kMp6U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GMPRIxUd; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731353455; x=1762889455;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UhKeAnH686SnXclASgBgnomzjV2fLza/i7EMZSSU948=;
  b=GMPRIxUdiIb6wR4DzzAkP84R6adtsIU5706H+LXHviHdHrs+W1m0ML7E
   yYaOJeigSGzU2gvPi2uVvquGYfMmW+Rx41I57cmWG+jKEWb9AaNp+P8y6
   WoVhenkpCr2bYXUn5PRK+3/Lsxq5wzwv3wsEkPi00kQVL78nBriUhehEW
   hLHVi90DgxKNgcNnlxELTqDlQueAWv5GxCLv7N1AN4nXZ91apORWeCXtx
   JQ9aqevdwMkvqVNq9AaMCfo8kh8UcN4N+s33bSa94TiYkeXq8vdBCjDUB
   R3FCCCF3T5v5lnMO7j7+SLTrE1R31m1E733KhNbGZUa+xAe44H1b7B8b6
   A==;
X-CSE-ConnectionGUID: qKe6FEF9TGqDZVbVEoENlQ==
X-CSE-MsgGUID: aH1mFdQtT8KgmmxUPWBcjA==
X-IronPort-AV: E=McAfee;i="6700,10204,11253"; a="30579230"
X-IronPort-AV: E=Sophos;i="6.12,146,1728975600"; 
   d="scan'208";a="30579230"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 11:30:54 -0800
X-CSE-ConnectionGUID: 9ktSoJ98QkyNombAugVGIA==
X-CSE-MsgGUID: AR8l1BFQTd26av7QFFUBdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="92019868"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Nov 2024 11:30:53 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 11 Nov 2024 11:30:53 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 11 Nov 2024 11:30:53 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 11 Nov 2024 11:30:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yvCwSup/+lbZ1T+i0LDL3m1qAOBV3VN/MrQLyDKiXsWDVl46g110OukFa88Aj07oeUOymoUEQRnddOel/XOabgB4PWeMaMqbM4aB38AcAsCUKPNtX7v8UKhHQuxUFb1J7WLCSOds+s9XVFGtK2CeAWBVhmuHsEn+MV1Solf4/UdeQ+N6E3kbgvOMsI/dof98hW0BpDLDR7trBt0QzC0z2wfa8qx+Xodqr+0YHtIe9ueR3bnZxIlzPUlJ8URBVJLRo/86UoR/PeOETpaJSW4D2tq4VLJU5c3EgrnvAqCZyTwHgTRpLGsNhgxAiQQvI9y6Ht+Ns7m1jLNV+ifkLRFVTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UhKeAnH686SnXclASgBgnomzjV2fLza/i7EMZSSU948=;
 b=CZt2D98pUguWM4E9zV2O0Jchy3dUqhYf4AKBTtjN3Xzjc9TKOBzMxv03NKu5HS4on2aANnn19RWzcR5rbguTCwHcS1euDPkiJUdZxrRHOpMuqfn6+i/A/iJ7GHguYhAdgUlfvb8lehaeFJrG+jYQEeDTidLT2fKdi8DqsUvD/RiucGOtPgC1fsiXHObStl1gwcHUBESvnpkgOar6Rb/41/Ahx7AX51LtB0g3I5A53t4b6Kf5c5EFpMLBwKzq4yW0xvivCQE1qy9/1AzvNETcTebKD9qDTKFcWXuwH/TkZYw/AegUco5DAho7tKCMtALWOIYkW/5m7E3vD3v39arb4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by PH8PR11MB6707.namprd11.prod.outlook.com (2603:10b6:510:1c6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Mon, 11 Nov
 2024 19:30:50 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad%4]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 19:30:50 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v7 07/10] x86/virt/tdx: Trim away tail null CMRs
Thread-Topic: [PATCH v7 07/10] x86/virt/tdx: Trim away tail null CMRs
Thread-Index: AQHbNCV8bUyZjDEZMEejbJ+ipXVHSbKyRkmAgAAx1oA=
Date: Mon, 11 Nov 2024 19:30:50 +0000
Message-ID: <14b2cfb9017acd89d31d94dde39c48f2a2781418.camel@intel.com>
References: <cover.1731318868.git.kai.huang@intel.com>
	 <fba5b229f4e0a80aa8bb1001c1aa27fddec5f172.1731318868.git.kai.huang@intel.com>
	 <46f58028-9787-4363-96b9-e9b2b3122396@suse.com>
In-Reply-To: <46f58028-9787-4363-96b9-e9b2b3122396@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|PH8PR11MB6707:EE_
x-ms-office365-filtering-correlation-id: 62fb74fc-3f78-426a-477a-08dd02875996
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?VkdZWWdNYlFPWWR0ZEZwajRPWVpyaWtnaE93NmhjTGIrelRDZ2llT3Z3Qjdp?=
 =?utf-8?B?V1pyK0xpY21EMlp0V0dhWE5UVC9CYWEreVk0Q01wemVYMENJVkpzTU93bEhq?=
 =?utf-8?B?azQxWlJ0WCs0QWZXaFhIZTlUQTVuejYxSklLV211RzdsMmZ3QUwxWEo5L3J3?=
 =?utf-8?B?bVRlVE55aEpEUEsrVllpVyt5WGdwaGVFT2ZhdjM3UHR2Njc2RVJnTkZaT1l3?=
 =?utf-8?B?MTE4R1IybDYxSlQxWmp6RXB2SEVIU3plUFl1cjNZRTJjcWt3UGR0bVZkL3k0?=
 =?utf-8?B?V1l0aGVxVmxzdXplN3ZBaEJIb2lUYWJIYU85bk9iYlk3SmozbE5HSzVheVVT?=
 =?utf-8?B?WmcxNUwrOHgzMWFBbDhGcDZpanFBSmxyZmYzUHZieTA1aFBKNm5KSFBWQ0px?=
 =?utf-8?B?NXcxRjB5QTF2cmRMVjJrUkNqNmNHdjU1ZWdScmRERk14REFRRVZzNnJEUUlm?=
 =?utf-8?B?ZWhBMHFoSjUxSlkrb0s5YURQV3hjeUVWVTdKbjkxTDBDcThBVlZHLzg1Qzl4?=
 =?utf-8?B?a1B5REIxQXBiSFp3NFZxbmhOTzdQZGQwL0Fhd2RnS3Fmenk1bDBDeGxudnhK?=
 =?utf-8?B?QW1haVM4ZmEzQUp5SmxTVG81U3k5RGhGaENwaVNVWVZleEdwbWJvVGJ3TkNM?=
 =?utf-8?B?M1NQZWs2SEJZUlN3bkNrcXNNK0x0RzNPNGJVRDVCMGx0cnNERDZqZWkzMVQ3?=
 =?utf-8?B?UnJNMm9iSWNSVUlqOStXelU4SGZBbyt1RHpNVzBTa2taNTVqSjUxUnlMNDEy?=
 =?utf-8?B?bnN6VFJ2VnNQNHZnNUJsS216bEM1L2w1OVJobEM4SWVOODkyTHB4VjhaOVFJ?=
 =?utf-8?B?Z3BFcWpxMC9ZNmw4emF1c2NBZWlhRllJUHZZc0pBQi9PQzd4WVloUXQ1T0tG?=
 =?utf-8?B?S2h2QWlURFhRQ2ZYQTNTY3VLa3dZZCt5YmZOclBGSkYxY0pvOHhDRHdhRWN5?=
 =?utf-8?B?RjVhWEhkSWd6eWhJb2xWN2ErVUdIaCtwU1M0TW9mSzh2UG5sYUp4YjBKMTdO?=
 =?utf-8?B?V0c2S0IyeEpLUkM0WmtjT0xzNHFuYXZ2dkZDbDk0SU56K1QyZDNSYmF0WlBB?=
 =?utf-8?B?TzFxZXpVd2V1cEllNTVtUTdQSGFxTkxKVHI0ME8ra1dYZVBPeDg3bE5qL20y?=
 =?utf-8?B?UjFyTldDVkdEcGZGMGk4MnJZajRsMXpxU1dIdlEzMk5MU1NxNG11OXNEcWJn?=
 =?utf-8?B?M21EZkVhN1NKVFQzc1pnbW1iTjNXUDFxV2d6NG5FL0dGbkM2aWl3Z0JlWGZ2?=
 =?utf-8?B?WlpGa0JFSXpKUFVKb1d5cjBNbXdVNmhVN0Q0aXVrMERVUWl0OXBIL1hZOUZ3?=
 =?utf-8?B?WXcvckozcWhTMVNGNEVyY3VVc0VCVzZCd2tCSkxYM243ZjFxaGxXeVg5ekp5?=
 =?utf-8?B?REdCQzdEMk9DZkRKa2NFanRlUFRBZ2pCdlhpM3JBeDkvZk94RXMyV3F1NFgr?=
 =?utf-8?B?L1hHMUlqL2JPOERBOXFUUmJlU1RvSksxc001TitrUjVGZ01oUEZicVFPR2pQ?=
 =?utf-8?B?L2phb2FkdUVCeGIzb2RrTis4cWltaitqTWcvbTRCK2tSTTNqWk1BMzhKQ0pT?=
 =?utf-8?B?cEFQUEtudXJPNVZuK3d2bWpKREZFT2wyZmducldkQnRKNjlBWEI4VGI0aDVr?=
 =?utf-8?B?bnY3Q1FHZjdjQnBmM285elZ0K1VySVNTSzZFMFNXUHFFRVIrdy8vVW5INk41?=
 =?utf-8?B?RGYxYVhrc0tGWkh4N3BFQk12cjAyZU04cXZzOXF6YXVnMmZVVVI4WHFpUFpD?=
 =?utf-8?B?elN2UmlEYzJtSXdxWS9jNVZMK0hnQVhjU0NWMzZLNWE4dEdXUllZZkg4YTVL?=
 =?utf-8?B?SndxQzQwRTB0ekJNbkdVeUtubXJkNVB6WHNyQ2FmbXlvazNUR1hxK0VpTVZB?=
 =?utf-8?Q?XdbS+ys97wnoa?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R3BPckFDaDdUdFNYYitVQTVNSUxRNk5CMEg4aXpRSlJEcFFRMjFubHRxZDdl?=
 =?utf-8?B?Qm5DTWZvOXN6dHJaMkZPUCttYTg1TUZFTnF3bWtWVmJJYnlzWmdleTI2THZk?=
 =?utf-8?B?V250MDRHYWVQZkxFVVpDWEY0dnJMN0gyRmtVdjUrRE1iVlUyRmU3cGNtMXNJ?=
 =?utf-8?B?SWZiczAwNk9wM0ViWDJmU3cySDV2NWpDV1ZpdnlwUFkzL25IcFUydkdSb21k?=
 =?utf-8?B?d0pXck5iTWZ1RFVMblJCYjdmY1AvbVZPWVBldytJRGRDYjFZbjRHNnNPTHcv?=
 =?utf-8?B?Z1IvenJaMTBiNzNoZFVjOVBYNExBS3huZHVzalJud0VPUXJjTkExYjRqUi9E?=
 =?utf-8?B?QmNwRVdUY1d1a2pxc0VCZjZpU2lGb01MQjdGRkFYRGNaSW1IM2ZvVUZBYXV1?=
 =?utf-8?B?VWN0WHV3cnp0MHZidWtiZkZhdWkzKzc0L0x4cTFnQ2FycGEyLzNMWUduSE1U?=
 =?utf-8?B?UnhwZjk2Z29LYWJ6V3hMb21EaFNtQWs0eENJdmt1NmhWaFlzakFIZ0kxaDVW?=
 =?utf-8?B?S2dQN1RxWjNSOWpqZGsvYVV5ektHdkgvK3ZwNjNVSEFoSFdlNjA5cFpQV0Ro?=
 =?utf-8?B?cjBOTVhWa2piZG8rckJjek9LRGFJRktxQXlFWHhTNmJWMGVLeDMxZFdTZDZj?=
 =?utf-8?B?Z1A4ZFQyQnZOWDFicHZJTnFjeW5mUWJ2clNkT3VTYklOSVdnYU1SQ1F3VDBz?=
 =?utf-8?B?REZqemVuSXhZS3pJRmtMYWtFR21WUGgvTDl6TklUcUVVcWd0NVBYRkg1dGFp?=
 =?utf-8?B?OEtwNUkxZWJHeURwU3ljdzdxbmdYc0haY0k2anhFdU9BL0c4Tmh0RWhJOU4y?=
 =?utf-8?B?amN1S2E3Z2NSV0FiL3l3TzNMVE13UldTNmsxSFFURFUydmt2a2RqWEt2Zk53?=
 =?utf-8?B?V3ZYL1hGT2I5TzFYWVNTOW5iTGE1NlFqZUIzK0J6aVZmQzFRTTIrKytIVmM3?=
 =?utf-8?B?QXdnbWM0S05CSzU3Y0JIUTgxMHk5Z25mRkhBSlYwQ0ZLN1RrYlJqajcyTm1S?=
 =?utf-8?B?aFFqTWFuMFJDRU94NEUxWklxTEt3SkVPWktJOTFiWlF2alpZRzAvWTRrdWRo?=
 =?utf-8?B?Qkp6bVhyMGUxT1plN0pEeWZMdHFGdlFTOHVNdmYvN1NrK01FK0paeEdqb3hI?=
 =?utf-8?B?RDJ6VldsL0dXVXhTNXU3eTRsd2pyUFovY3huTGJHK0ZNU1kyU1ozd0dQWmtS?=
 =?utf-8?B?MkxHQmlEMkc5NWx2a0NwUkVPMmwvb1BwSEpIR0xRSUx3WitENDg4VjkvQUpP?=
 =?utf-8?B?dlpVTkNTTWxpdjhyaGtXY2RWQ0VuVlB6MFBnWmJSakE2ZERnZVcyQXRUMldx?=
 =?utf-8?B?OFdneGVGM3RCWHNTZE1wM1JtVERLSmViS0VXbnVibTdGMkJRRWw3S3hvQW1G?=
 =?utf-8?B?VVpqUlQraDV2UWlVSGRDWkgydWFjV3BHNytOVjNuaDBxR1lMWmgzWStVR2pN?=
 =?utf-8?B?a1Q0dGdGT0tCa0xMVlRQcHhrOWwrVHVsc3dyQ3RuNWg5RDJsZTZZYWRNZGt1?=
 =?utf-8?B?aDJYQm5tTGZibVN1bjNHNlkxbFFheW1WNDZNUzFocGxyTGl2QVk1eXJuMGJO?=
 =?utf-8?B?cmlNZ0RPNTFIVXdlcjVEd2ZMY20zQklvTTM3dGl2RkVDYUdPS2trU3BOL0ND?=
 =?utf-8?B?K0dpVUd4WVRXd1NLU1JWQ0kvYnVqcGpUQ2hvNUc3OTU5ZlREc2lhV0h2NXFX?=
 =?utf-8?B?aHpNbGpCeE42MFR1NmEvbFJ3YjdwZ1kwWTh6TkQ3dnlKS1NwZ3dRTjdEelFt?=
 =?utf-8?B?N1lqOG94WHhsanpLbndrQWYwai9ncENDK2ZhRVRGTUpVQUo0WjJtT0M5L25D?=
 =?utf-8?B?MVVvVmVkNzlYTmgyVFlKdnV3b01GUDNPNzBEbUxxVWR4ODFDb0tSbGEyMGJs?=
 =?utf-8?B?c1p1WHRURVQ3alYxNjhhRUY0a2MwUG5QakRTSWlhV0wvNlBRbWlCTURqVTBk?=
 =?utf-8?B?RXJrK3RMaUQ3MzFSNXdQc0hGR2tGcWxjQ2N2L25VOGxuNXRIcGhVWDhVdVg2?=
 =?utf-8?B?WEhMbTJrQ2dDMWoxb0tMQVFzaG1VcTIzN1hLWHhsMmJaTXNrcjdWMXdLbUxo?=
 =?utf-8?B?aUlOK3ZTTHRjL0Z6T2NxcWw2bjI2ZmY1NU9Gdkg3Ry9QU3YvL3pzYXVEK3JG?=
 =?utf-8?Q?mUDlVM63SfWICvudYJKywEyE+?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <60968DDAA13AFA49B95B50CCE961D160@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62fb74fc-3f78-426a-477a-08dd02875996
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2024 19:30:50.2982
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i/cyfqBxsDOW4ta6QUniO4diJJvwSMFon5mMa/kkjJTbClKIH8PTPkTfGeNneGidV+YMAbRSHuc6VEeYt3m84w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6707
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTExLTExIGF0IDE4OjMyICswMjAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+IA0KPiBPbiAxMS4xMS4yNCDQsy4gMTI6Mzkg0YcuLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4g
VERYIGFyY2hpdGVjdHVyYWxseSBzdXBwb3J0cyB1cCB0byAzMiBDTVJzLiAgVGhlIGdsb2JhbCBt
ZXRhZGF0YSBmaWVsZA0KPiA+ICJOVU1fQ01SUyIgcmVwb3J0cyB0aGUgbnVtYmVyIG9mIENNUiBl
bnRyaWVzIHRoYXQgY2FuIGJlIHJlYWQgYnkgdGhlDQo+ID4ga2VybmVsLiAgSG93ZXZlciwgdGhh
dCBmaWVsZCBtYXkganVzdCByZXBvcnQgdGhlIG1heGltdW0gbnVtYmVyIG9mIENNUnMNCj4gPiBh
bGJlaXQgdGhlIGFjdHVhbCBudW1iZXIgb2YgQ01ScyBpcyBzbWFsbGVyLCBpbiB3aGljaCBjYXNl
IHRoZXJlIGFyZQ0KPiA+IHRhaWwgbnVsbCBDTVJzIChzaXplIGlzIDApLg0KPiANCj4gbml0OiBJ
cyBpdCBzYWZlIHRvIGFzc3VtZSB0aGF0IG51bGwgQ01ScyBhcmUgZ29pbmcgdG8gYmUgc2VxdWVu
dGlhbCBhbmQgDQo+IGFsd2F5cyBhdCB0aGUgZW5kPyBOb3RoaW5nIGluIHRoZSBURFggbW9kdWxl
IHNwZWMgc3VnZ2VzdHMgdGhpcy4gSS5lIA0KPiBjYW4ndCB3ZSBoYXZlIDoNCj4gDQo+IA0KPiAx
LiBWYWxpZCBDTVIgcmVnaW9uDQo+IDIuIFpFUk8gQ01SDQo+IDMuIFZhbGlkIENNUg0KPiANCj4g
U3VyZSwgaXQgbWlnaHQgYmUgYSBkdW1teSBhbmQgcG9pbnRsZXNzIGJ1dCBub3RoaW5nIHByZXZl
bnRzIHN1Y2ggQ01SIA0KPiByZWNvcmRzLiBJbiBhbnkgY2FzZSBJIHRoaW5rIHRoZSBtZW50aW9u
aW5nIG9mICJ0YWlsIiBpcyBhIGJpdCB0b28gbXVjaCANCj4gZGV0YWlsIGFuZCBhZGRzIHRvIHVu
bmVjZXNzYXJ5IG1lbnRhbCBvdmVybG9hZC4gU2ltcGx5IHNheSB5b3UgdHJpbSANCj4gZW1wdHkg
Q01SJ3MgYW5kIHRoYXQgc3VjaCByZWdpb25zIHdpbGwgYmUgc2VxdWVudGlhbCAoaWYgdGhhdCdz
IHRoZSANCj4gY2FzZSkgYW5kIGJlIGRvbmUgd2l0aCBpdC4NCj4gDQo+IEJlY2F1c2UgaGF2aW5n
ICJ0YWlsIG51bGwgY21yIiBjYW4gYmUgaW50ZXJwcmV0ZWQgYXMgYWxzbyBoYXZpbmcgIHRoZXJl
IA0KPiBtaWdodCBiZSAibm9uLXRhaWwgbnVsbCBDTVIiLCB3aGljaCBkb2Vzbid0IHNlZW0gdG8g
YmUgdGhlIGNhc2U/DQoNCkl0J3MgZGVzY3JpYmVkIGluIHRoZSBjb21tZW50IGluIHRoZSBjb2Rl
Og0KDQorCSAqIE5vdGUgdGhlIENNUnMgYXJlIGdlbmVyYXRlZCBieSB0aGUgQklPUywgYnV0IHRo
ZSBNQ0hFQ0sNCisJICogdmVyaWZpZXMgQ01ScyBiZWZvcmUgZW5hYmxpbmcgVERYIG9uIGhhcmR3
YXJlLiAgU2tpcCBvdGhlcg0KKwkgKiBzYW5pdHkgY2hlY2tzIChlLmcuLCB2ZXJpZnkgQ01SIGlz
IDRLQiBhbGlnbmVkKSBidXQgdHJ1c3QNCisJICogTUNIRUNLIHRvIHdvcmsgcHJvcGVybHkuDQor
CSAqDQorCSAqIFRoZSBzcGVjIGRvZXNuJ3Qgc2F5IHdoZXRoZXIgaXQncyBsZWdhbCB0byBoYXZl
IG51bGwgQ01Scw0KKwkgKiBpbiB0aGUgbWlkZGxlIG9mIHZhbGlkIENNUnMuICBGb3Igbm93IGFz
c3VtZSBubyBzYW5lIEJJT1MNCisJICogd291bGQgZG8gdGhhdCAoZXZlbiBNQ0hFQ0sgYWxsb3dz
KS4NCg0KSSBkb24ndCBzZWUgd2h5IGEgc2FuZSBCSU9TIHdvdWxkIG5lZWQgdG8gZG8gdGhhdCwg
YW5kIHdlIGhhdmUgbmV2ZXIgc2VlbiBzdWNoDQpjYXNlIGluIHJlYWxpdHkuICBJTU8gd2UgZG9u
J3QgbmVlZCB0byBiZSB0b28gc2tlcHRpY2FsIG5vdy4gIElmIHdlIHNlZSB0aGlzIGNhbg0KaW5k
ZWVkIGhhcHBlbiBpbiB0aGUgZnV0dXJlLCB3ZSBjYW4gYWx3YXlzIGNvbWUgdXAgd2l0aCBhIHBh
dGNoIHRvIGZpeC4NCiANClsuLi5dDQoNCg0KPiBSZXZpZXdlZC1ieTogTmlrb2xheSBCb3Jpc292
IDxuaWsuYm9yaXNvdkBzdXNlLmNvbT4NCj4gDQoNClRoYW5rcyENCg0K

