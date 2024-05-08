Return-Path: <kvm+bounces-16951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 689708BF3FC
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 03:20:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9047C1C21598
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 01:20:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C87B8F6C;
	Wed,  8 May 2024 01:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZpObGbaN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C50D8BE7;
	Wed,  8 May 2024 01:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715131194; cv=fail; b=pW2BAjF59tfkhLoB2aPE/5i1zfiG0zkULa5LIVcAy1AP8PRQ4VIRUFiTEQ7EObMVfGD9jmOMhnERpnKhWptAJSuUcTw7Gb+OioMxR0N9B4yvJ3EPOszR5GO79yfU6qNXVr7P5g+hx9e1QvRIAqMSOhQBK3850CqTe+UgL2884Iw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715131194; c=relaxed/simple;
	bh=J/2AiWA85qVhiSzGzNvPC98RaEvwYd7KS56RoABdL44=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r5tX2K37CdpeN7Ia8YTnu/K+Vii8HFrWK/o67bB/SlPHvN1XuUxEsVhRTAHlD5Tys8TDtqBHfepQeUZKhitjYDJ1Q/F3TsG96TwqzRYuh1OGPi5wfsiucHSc1CzgAJUhV44iT6GJhjF8bpHNTshMez7GQVlb+CgyG3CdUpzcVt4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZpObGbaN; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715131193; x=1746667193;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=J/2AiWA85qVhiSzGzNvPC98RaEvwYd7KS56RoABdL44=;
  b=ZpObGbaNkwMaxZAGhte/Zyfy3V8NVYstjvwFAdxoFJYN/4Z43S4jFgnG
   xe1DPEuaQ6TfxH5yUrXMq5U+XIygkoEr2pU+mbSOi3DQIbROlj4X5ZHfI
   fWd4DbA37K2IiDSgXQ96Ftg3QKf7cne5F2e0RQoSjvCwSosAzlZ3ZBrRp
   05R5MkW8bde0qIvYWYE0z1AjY6A8FjYd4Ps4fCJ2Q10L3A5QtMXla2dQQ
   DyZ6C8l6z9ekD1Lba3umb+U4b0+yLp8QGL2j0SPDWDiyBDd5MCoa3WPi/
   N3Jwnlvk6qnTZYRxYuLzqZ08o3JaeD+nguULC0OVq8EyJyeGfW2hKIQjn
   Q==;
X-CSE-ConnectionGUID: LhNV1OuiRz6Hd0Q4F7UpOg==
X-CSE-MsgGUID: g3p8PbiISISX8XcT/6AbbQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="10903186"
X-IronPort-AV: E=Sophos;i="6.08,143,1712646000"; 
   d="scan'208";a="10903186"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 18:19:53 -0700
X-CSE-ConnectionGUID: Q2yz2K0JTPuzdEs0+98U5w==
X-CSE-MsgGUID: w5NNU/VnTP+8d914llYszg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,143,1712646000"; 
   d="scan'208";a="59559852"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 May 2024 18:19:53 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 18:19:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 18:19:52 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 7 May 2024 18:19:52 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 7 May 2024 18:19:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oNmQDNSZNxJV60s2WkRFB+Tuov+hepjwbtgD0RAtIFE7lXDJlRORl5dCYgW5o7E/wxah95gcW2J+sWISKm4oOsSrckmn2f672tpLpY6wmc50v8n3QxN42qt6kQxEaaT7XEkcB7acwjzZ9q87BBkv6XUXRwVKw2aM+7XiDCesYwquVASoIk/+L9pz6Vdomtj5BgV+Y6qkZWTPXy41TyXNo9llEVX5Fj9jPZ8cIQCUiUxWng1goL/jmdrV+GE608K1N33aGwqyzXL6SpolcqFzqWnnKoEj95xsLrCIQlgONc9YhN/ptGsB0rLV9OAyCmuCPChUP5uXvaA1h6Nak30bRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J/2AiWA85qVhiSzGzNvPC98RaEvwYd7KS56RoABdL44=;
 b=kQl6cSeWABZlO9+lyTKCEXCbcPd9M1Ct6+WyCJ+cyCl+1VaSDbL9jGmLuMQ+KE/CPHC8fLnkgLVBX0c6rnVBzo5tv/Y/0NFRZq8YdNNZi6c3Xb/LiJSG5hqfsg+nKyEfmxzqGh0er61ro/aTb/25Ku40kccu5is88RuwRRupxHYJzlYZuQqKMNA5oWnFhYVXKgjHjAfv8L0HyHXWGIUNMgpwSSSsNkj1y5J2gb/PFF5DQvqAxD+5mb8G4Vwuu55wfMXTo6CAvjlAOb+fh9Rlsp/yC5rp8fNQXIqMaLOXB7Gzyw94q/RM6JXB3SXACTiDF2YeTgSeKMfBQy1TSJfUgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CO1PR11MB4962.namprd11.prod.outlook.com (2603:10b6:303:99::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.39; Wed, 8 May
 2024 01:19:49 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7544.041; Wed, 8 May 2024
 01:19:49 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH v5 07/17] KVM: x86: add fields to struct kvm_arch for CoCo
 features
Thread-Topic: [PATCH v5 07/17] KVM: x86: add fields to struct kvm_arch for
 CoCo features
Thread-Index: AQHah60wsHP29hDi6kKJ9JlK2WL9i7FfKRuAgC1sloCAABYrAIAAEG2A
Date: Wed, 8 May 2024 01:19:49 +0000
Message-ID: <2c8cf51456efab39beb8b4af75fc0331d7902542.camel@intel.com>
References: <20240404121327.3107131-1-pbonzini@redhat.com>
	 <20240404121327.3107131-8-pbonzini@redhat.com>
	 <43d1ade0461868016165e964e2bc97f280aee9d4.camel@intel.com>
	 <ZhSYEVCHqSOpVKMh@google.com>
	 <b4892d4cb7fea466fd82bcaf72ad3b29d28ce778.camel@intel.com>
	 <ZjrFblWaPNwXe0my@google.com>
In-Reply-To: <ZjrFblWaPNwXe0my@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CO1PR11MB4962:EE_
x-ms-office365-filtering-correlation-id: 6b53202b-dd8f-4b4a-cbc6-08dc6efcf4d6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?RWtFekRXQTQyT3lrV3R4NVpmdUtaQXkyT242aGhsV1haSWlLOCthajRZcEg4?=
 =?utf-8?B?TG5tMW9oK1BESEQvS1RZbm1CZjI0ZHgyaHZoTGdidDJpdDdyU1dncS9KdjhF?=
 =?utf-8?B?TmxNYzNPdTNOM3RaeWlwUkhGKzR2UXBuQyt4UGw4bEY4bkVWcDlPbXdMQWJ1?=
 =?utf-8?B?Y1NmTzNVdUtsVWU1NlVaYUpmSDk5WHhnY3hUL0NscVJxZVBIZDhDN3VpNkNS?=
 =?utf-8?B?ZjZuUENHdGhCeUFnT1NNQzc0cXduSmZaM1B2QXpFWEErMVZWT3VwanMyYmUv?=
 =?utf-8?B?ME1iMTlYdjZ2b2FNQzZTSXRkZ1k1Qjk0cFE4TW5UajlIeFRsbEZpWkZ3eFZJ?=
 =?utf-8?B?NTZIMXJTN0dCcFNMYVRWakJBenRIZTZYSWtJYUYrTXE0d3lBenVVWnY5R050?=
 =?utf-8?B?RW5oeEhQbWZCWkduaDRSbXFjbHZ1NjBVNE8vUmF0emZ3OWRCOThPL2dhQVp6?=
 =?utf-8?B?K3RmalhVY08xTkNSUU5iSnRLSDk4RzR0SjMxUkV4c3hjajFQT0hwSUhwa2RH?=
 =?utf-8?B?NGkrYTM5UGU4em9Zakthb282dGw2d2pXTW5ZWkpXemtTZHl0Q05xRkcrcEd1?=
 =?utf-8?B?S055bnZYUlpXRDhEd3g4aFpDb0htdUlvWlJ0d3pDVkh5L2ZZa2pGdnpCeGl0?=
 =?utf-8?B?UW1YL0R5SXNMMWlKQUpjYTRDZW1VZjJNdmU3SndsMWNEd2VpUTFGSlF6a1A1?=
 =?utf-8?B?d0pFblQ3YllXNU0rckorTEZzVzdnS2JFTU05bTFzL3MzV1RZMHBsZmJxSnQ1?=
 =?utf-8?B?RzAyaStiampmbE5IWFB4TnhPTUxHQ3VjUlRpRVU2eVJYU0lUTWpUZDlFa0I0?=
 =?utf-8?B?WFNNMU9Ua1E2SFREWHFadVVORWdRdzBxS2trUWpWMzBSb3pUM1RacWZnTmZ0?=
 =?utf-8?B?LzRldzZRTkZsbTlIQ2x6U0lYRkc0Q0lvZ0hIK1FFVUpwT3Awd1k0M3RDN2ZK?=
 =?utf-8?B?QUFYYlBwN25xRW16NVdZdE5UdVNmamZMMi9XV0tSVXkrM0NzbmhjMU9iOFN3?=
 =?utf-8?B?Y2trYStBcUF2OVo5N0ZkNFFLSGMzTStHZXd0SGtnV3l4TnFWWDBLZmdDbzJi?=
 =?utf-8?B?MnVyM01LOWYvUEV3alMyKyttSWI1NlRQa0VvZFcyOENqbEZuTkVnYzRTdFRD?=
 =?utf-8?B?WmJxeStQM0RIaVlRMUszK2xnZnpZUnpKMGVZZzBkSWVMQjJFSVZaM2JZMGds?=
 =?utf-8?B?UWd0VUs5OFpRR2lCZnd4WS9lVVJHcUVTU3BjM2FNK3IzVUZCTG0yVG94bk4w?=
 =?utf-8?B?dGJ1ZHZEM2s3ZzQ5V09QRUVEVFRyU2o2NUl3eGtuYTR5U2JyNlNDVU96c1ZB?=
 =?utf-8?B?dHNmRjFWRnVSWkFjQS9xWXFRbC9ucHptUklQN0JaTnBqZWEzQTJZRmRQM1Ri?=
 =?utf-8?B?cHdVSDJWVTZIOU91amVXSXZIdjdHMURhMTVvZ20rUFM5SGlXa1Rza1M3Wkxh?=
 =?utf-8?B?WEtVWGtRNzY0ZXBWWmRlZkcycmFZSzdFdHRUTHZhRjBmZFFMeTRsQjc0K21k?=
 =?utf-8?B?bHRHTkdKc1J2UHdZMk5VdUROYmVOZm9MeW5Fc2NtN2RvSnQ3ZDVzZWhBUWwr?=
 =?utf-8?B?dXZqdTNtTGxiSjU3OTRNWm5nN2NHVFhPU3lsaTcxdjQ3a0t0SXM2d3lLVGpj?=
 =?utf-8?B?eVg2QUxDNG0zUDBWWXJLcUN0NTZXWGp2Tnh0SzlaVk1sOWFLZzkxekZ4bkdq?=
 =?utf-8?B?SE1BOHRTbkhBZTRrSitWWHdDM0ZZd2Y4aTFqT2dCYTA1UlluT1k4ODBhTmFH?=
 =?utf-8?B?cmlHNzVRRVc5M3Bsc1BHUE9nUEh3ZVZEcWgvRE9MbVFYK3NSYmlaRW5IUXRw?=
 =?utf-8?B?dHVWNkRJM1IzRVRPeGx6QT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YWRNZjJZb0RISVlObDQ1SmhLRk1kRWwzREtjSXcvRFA3bFZ5UlU5RXVaYlFI?=
 =?utf-8?B?YXhQUmhBQnE0Tk1WZ3ppWUg2dyt5UFhEb2lyZFZYdm8yR3gvOXgwWEVFRGJj?=
 =?utf-8?B?bkhvOEh2dTl6c0VxQkx6SkF6YlE0RlQ5U2ZGdHhySnoxbC8rUUNvWnR0MUlY?=
 =?utf-8?B?UENwdzB1YkUxT3hqZVRrV1F0WFFXajdDZG1uOVp6NjVwdlRJa1VFMzBGdUFi?=
 =?utf-8?B?eXlVd0tVVzI1QTRvd0lwb2tTS004eGxVWklQa2Z5bUUzbGc3VERnOHN1MWlt?=
 =?utf-8?B?dWRuU1orQ1MxKzU2Q25NZGFhdzBuSFY1alV3RnlJN2Q3WEN6eWR4SGVLTDBS?=
 =?utf-8?B?cklobFlWbWVrK3FlSEhrZUd3K29uSzdRWW9IRkpmMnNnc0ZqaVh6VGl3RjRs?=
 =?utf-8?B?NnZDTGVzK2JtTk5WaDZ4VXBqZkdTRlNCeGkvQnBJSzVUMzkrZ2NQZlp6WWxD?=
 =?utf-8?B?a05OME4wbmlSaG9GQVVNRVk2K2Z4cDliL3JQc2ZZMWRDeks0Um1pK2M1d3A5?=
 =?utf-8?B?NEZ0QmhhRXNoWitMbmN0ajh5akJvdmJRVVhXS3RCVVRGOGJXZURRTjdzY3FT?=
 =?utf-8?B?dnJ5dktxNlpPL1pUd0pSWGdFT2NhUGkwSkwwOU16blVudFMzWEw2VEtFcEVR?=
 =?utf-8?B?SU5FK3gwMXd6bWNvVUx2YjNEeDlZWUl4ck1pRGlNT0RZQzhIYlVlSEtVNS9h?=
 =?utf-8?B?bytydmlSYmdWZlRKNTFncVhPZ0dseHg3K2ZEWS9Ha3dxN1h5RHBCb1l0TDd6?=
 =?utf-8?B?NkExM3hCaG5YaHQwcDI0TWt0UTA0VGZycWpBcWQrWEo5dEZYcnpJeENtQ1ZP?=
 =?utf-8?B?YWpKOUJOU3d1QXBnakxHemNJSHpwZ09ZWGVzWDRKY1dyR1hiSnVUbGJkOWoz?=
 =?utf-8?B?cm1tQ3Brem9jeEViOEUrWnFNUk9qdnN4MDhGRENKMnV3R3ZkZ0hmTzRQMUR3?=
 =?utf-8?B?N0dZVnEvaDdyMVBKcEVKZUo5N2pIQXFLN0NkNWZManpFVS9Wck85K2NKQ2I3?=
 =?utf-8?B?djVTYXFjZkpSUkRGSVRva2hUcWVUaXlVVG00L3ZncGN4NnE0cnBzQnQrV2FW?=
 =?utf-8?B?RE9qVDJqdzlCaHNoWFI2RTZZSjhpeDBQa1dqd2ZMNDRtWHRPY21jMVU2bDMz?=
 =?utf-8?B?SDMwNGxPV1IwNFJsWWRWKzV3bFhXNzVMeWkrM21qbGh4Q1dhR0xLZ3NFdkVn?=
 =?utf-8?B?OVRueXViSEcyR3p3MEIvYlpySXpvWlZRbHJmS2krWUgyTEM1bVBtbGczOVlF?=
 =?utf-8?B?VlRsRyt1ZVFuN2pqak5oOFAvU01vZVRzTXBqb3hDR04wTDZBZWZLU3lEOUJa?=
 =?utf-8?B?RjRqdGJDVzZlcHJRM0g5b0xMTWQ0Mmt2OEZEc0RMbUZya0pmZVV4ZkJqd0Ji?=
 =?utf-8?B?MmN3eGp5aUJCbFlkbHM2OUZ5TFVxeGd1WEhJT2pSYTQzSFFIMDJDdGxnSHNm?=
 =?utf-8?B?U2F3bWVJZW1NTlZvMzJGSjdpazI3NUNrSlZWenpHcTRvUy9uWm1YQ04rZTZE?=
 =?utf-8?B?OEYyVE5jdlYvMkdHcDI1enBKVzFQS2N3N1ZGYldiNS9iR3B3VTlWaWtKZzZ6?=
 =?utf-8?B?c0hMWEJFdEdWUnYxTUhmak5Qaitpa1NJU2RPVXNQSDB1dkM4R3JTL0hYZGda?=
 =?utf-8?B?anRnaHhySlc2TXowY1A0V1hBTS9HdkdtMUMvVXB1RGJQN2poUi9sRDg4WlBY?=
 =?utf-8?B?dVd6VlR2S3JsZmtXYlJWT3Baenl2NzlrZUg1elBpQ3JzTGdLS05tc2FCTDYz?=
 =?utf-8?B?QmJZWTdSdmlXK2tlVmptVHprNjFwL2krMDlUZ2ZaWW1PeTlkbnYzQWhDMGFJ?=
 =?utf-8?B?bWJlRzlpL3hQaUFmbzI3VDI1aCt5L09hOUgwWWR4TUs5R2FQa3JIZFVWUDJq?=
 =?utf-8?B?by9XbkdNSHZLakZMcXM4Qm5NWlRreDR4VXREc2J3TGViYmwwOERLODJVbm42?=
 =?utf-8?B?cWJ5cUdqN1g2S3k5WUxNMHVhRWJyTnl3enhuZzYzTnBTRHVqcWh1dktqSnVZ?=
 =?utf-8?B?UFFzTzdsRm9uY096c2tMUS9sd29YU0xPaXRicG5PNWo3Z3ZZbHJwZXp6cEI0?=
 =?utf-8?B?bUtMbGtzT1ljSm01RDlOZEVCK040T3Y1REtmYnMyc0JBWDVURVdLU3lNZU1J?=
 =?utf-8?B?Q0tRdUZzUEFPSURQcnZBbFJ6SjNNaHpMRlZJcDBuRi9Zc3hka21nL2NGWDl6?=
 =?utf-8?Q?yWRO4gr8wGCV2ixdEtMwF74=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <68B16DE26760BF4F8A33324DDAED6B49@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b53202b-dd8f-4b4a-cbc6-08dc6efcf4d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2024 01:19:49.8020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eHdU/VjdTyogshRqOReXiU7FoP3MXZd3nL0rDZ6uUkTtb1AS/2etFUJVQ3pyO27NglhNTnetI5vYxriKRBhusJPdrNSSCupywTLSs7dO3Ng=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4962
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA1LTA3IGF0IDE3OjIxIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IENhbiB5b3UgZWxhYm9yYXRlIG9uIHRoZSByZWFzb24gZm9yIGEgcGVyLW1lbXNs
b3QgZmxhZz8gV2UgYXJlIGRpc2N1c3NpbmcNCj4gPiB0aGlzDQo+ID4gZGVzaWduIHBvaW50IGlu
dGVybmFsbHksIGFuZCBhbHNvIHRoZSBpbnRlcnNlY3Rpb24gd2l0aCB0aGUgcHJldmlvdXMNCj4g
PiBhdHRlbXB0cyB0bw0KPiA+IGRvIHNvbWV0aGluZyBzaW1pbGFyIHdpdGggYSBwZXItdm0gZmxh
Z1swXS4NCj4gPiANCj4gPiBJJ20gd29uZGVyaW5nIGlmIHRoZSBpbnRlbnRpb24gaXMgdG8gdHJ5
IHRvIG1ha2UgYSBtZW1zbG90IGZsYWcsIHNvIGl0IGNhbg0KPiA+IGJlDQo+ID4gZXhwYW5kZWQg
Zm9yIHRoZSBub3JtYWwgVk0gdXNhZ2UuDQo+IA0KPiBTdXJlLCBJJ2xsIGdvIHdpdGggdGhhdCBh
bnN3ZXIuwqAgTGlrZSBJIHNhaWQsIG9mZi10aGUtY3VmZi4NCj4gDQo+IFRoZXJlJ3Mgbm8gY29u
Y3JldGUgbW90aXZpYXRpb24sIGl0J3MgbW9yZSB0aGF0IF9pZl8gd2UncmUgZ29pbmcgdG8gZXhw
b3NlIGENCj4ga25vYg0KPiB0byB1c2Vyc3BhY2UsIHRoZW4gSSdkIHByZWZlciB0byBtYWtlIGl0
IGFzIHByZWNpc2UgYXMgcG9zc2libGUgdG8gbWluaW1pemUNCj4gdGhlDQo+IGNoYW5nZXMgb2Yg
S1ZNIGVuZGluZyB1cCBiYWNrIGluIEFCSSBoZWxsIGFnYWluLg0KPiANCj4gPiBCZWNhdXNlIHRo
ZSBkaXNjdXNzaW9uIG9uIHRoZSBvcmlnaW5hbCBhdHRlbXB0cywgaXQgc2VlbXMgc2FmZXIgdG8g
a2VlcCB0aGlzDQo+ID4gYmVoYXZpb3IgbW9yZSBsaW1pdGVkIChURFggb25seSkgZm9yIG5vdy7C
oCBBbmQgZm9yIFREWCdzIHVzYWdlIGEgc3RydWN0IGt2bQ0KPiA+IGJvb2wgZml0cyBiZXN0IGJl
Y2F1c2UgYWxsIG1lbXNsb3RzIG5lZWQgdG8gYmUgc2V0IHRvIHphcF9sZWFmc19vbmx5ID0gdHJ1
ZSwNCj4gPiBhbnl3YXkuDQo+IA0KPiBObyB0aGV5IGRvbid0LsKgIFRoZXkgbWlnaHQgYmUgc2V0
IHRoYXQgd2F5IGluIHByYWN0aWNlIGZvciBRRU1VLCBidXQgaXQncyBub3QNCj4gc3RyaWN0bHkg
cmVxdWlyZWQuwqAgRS5nLiBub3RoaW5nIHdvdWxkIHByZXZlbnQgYSBWTU0gZnJvbSBleHBvc2lu
ZyBhIHNoYXJlZC0NCj4gb25seQ0KPiBtZW1zbG90IHRvIGEgZ3Vlc3QuwqAgVGhlIG1lbXNsb3Rz
IHRoYXQgYnVybmVkIEtWTSB0aGUgZmlyc3QgdGltZSBhcm91bmQgd2VyZQ0KPiByZWxhdGVkIHRv
IFZGSU8gZGV2aWNlcywgYW5kIEkgd291bGRuJ3QgcHV0IGl0IHBhc3Qgc29tZW9uZSB0byBiZSBj
cmF6eSBlbm91Z2gNCj4gdG8gZXhwb3NlIGFuIHBhc3NodHJvdWdoIGFuIHVudHJ1c3RlZCBkZXZp
Y2UgdG8gYSBURFggZ3Vlc3QuDQoNCk9rLCB0aGFua3MgZm9yIGNsYXJpZmljYXRpb24uIFNvIGl0
J3MgbW9yZSBvZiBhIHN0cmF0ZWdpYyB0aGluZyB0byBtb3ZlIG1vcmUNCnphcHBpbmcgbG9naWMg
aW50byB1c2Vyc3BhY2Ugc28gdGhlIGxvZ2ljIGNhbiBjaGFuZ2Ugd2l0aG91dCBpbnRyb2R1Y2lu
ZyBrZXJuZWwNCnJlZ3Jlc3Npb25zLg0KDQo=

