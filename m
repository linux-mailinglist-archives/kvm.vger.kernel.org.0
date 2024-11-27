Return-Path: <kvm+bounces-32619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11D939DAFB0
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 00:05:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C784F282384
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 23:05:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 292BE2040A3;
	Wed, 27 Nov 2024 23:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ar2CR/rk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F0E202F88;
	Wed, 27 Nov 2024 23:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732748693; cv=fail; b=D08O7r7x52KdJhboHH5pAwmEf67mTd1D1SmGfkF56dqbmG/JYT5g9MjKUuxR21L8mpCh+Zam13wtv7cofr0D4aIvw8WVK2AhvB9JRidlLM3pQTbPuvUM1+bxQSS4T5ouYqw9EAQ0dpai82QbOYNb/YiIkV5wxnfL58+1Y7J0JBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732748693; c=relaxed/simple;
	bh=HavjZ86u3YaeWFU3LBRp9cI88KIOW/cimD5iDAWPiIk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ip6FLpHRTAbu9xxgzaZRZIVFAovuIbO0mwODDMDvYbZoFhK/p5PQK+TcqJjXTwEfZxSbXrNk7tvan17TvaaKudSZQs1MlsZezfKAYIQdtF1n7jVdjUhXWel4N6foeraLddZ6I2PLFvhG2IU1zhFIP/1j3bnXilnN3hLtz2nl6PI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ar2CR/rk; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732748692; x=1764284692;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HavjZ86u3YaeWFU3LBRp9cI88KIOW/cimD5iDAWPiIk=;
  b=Ar2CR/rkkehX3My47VgIihLBoPWI3rYLQjCQj6tAPa/+w6pR0XIKLSAv
   795Vxbrb3gglS1gvP/AbTFfk6fRPck8MYYZhs2DbOVhvTj2oo1uEb8ZaW
   GVbHoByTqkhYs1WSnr2RaPk0hS4jJdLbQQQsa6l4rtgACkJWIker2xdsD
   TgTWDKwHM1WKNlLE1x12sk/uGK41tzg1XkF+A+oipNrU7x97TlXnuc9S1
   +ejPqnwVTcHcIDuiIHdq9jx3pGBSq7A1np/2SoiChwuUqqB77X3II9vze
   JhcDcfcGebMvpH3TBKr5VW46PE7fm7L7Z7nXncKP9yPBdZtJjjeaZm94W
   w==;
X-CSE-ConnectionGUID: HY3xpE+QRkGgZ3KvSGPsJw==
X-CSE-MsgGUID: GP93PNLXRL+/YBYS2FoooA==
X-IronPort-AV: E=McAfee;i="6700,10204,11269"; a="43633967"
X-IronPort-AV: E=Sophos;i="6.12,190,1728975600"; 
   d="scan'208";a="43633967"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2024 15:04:51 -0800
X-CSE-ConnectionGUID: CHRWoZkTTNG2P5DG/Y+bCg==
X-CSE-MsgGUID: y+NxYvAHR0i1myQyFgQwig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,190,1728975600"; 
   d="scan'208";a="122894960"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Nov 2024 15:04:51 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 27 Nov 2024 15:04:50 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 27 Nov 2024 15:04:50 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.47) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 27 Nov 2024 15:04:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zl9O5GRUplCBSuWMYwpk7V2z/ArgGSMFoUdkEMjdu3FTgMnqtlBX3ugI9X5YzEKBTYvo3QLCoeMP+kxUgYJYHHiZYkcIUp7tPtoNbRP7u7wB00d/R/diccHcB1TZXHOkL4yDEKPKR4jEwB4sQpWFw7YoFDvS6l6qXdS0k29zQhU6nWF5CGDDnm6fp+K5vuDLDqLrJhkGSmzuT9L4YOpP8gVAARMSomUB4ox7vVp48OzNe8D5YyZjPG0ym6LZDgwOfKhRVthl4fD3zleaxrM3NZJYI18ygHP1rMSvSLHuIIWkOHQxErFPTPUDhRyxr/IE1b3eCnJ+4nWZ+yXXrY3aRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HavjZ86u3YaeWFU3LBRp9cI88KIOW/cimD5iDAWPiIk=;
 b=soZ7TUR+nDmQGBMoO+O2DC+d99xpd/Llho52qbpc9HIByvkcwcwgSmAziTO4zsY+MA9MPQ2++jxVoys+OdJ+VKWh2zMFuHjIGbS4v1DuGMYbsT20uZkTSMVwz5oYaYkfLMJH/Ma/JOniodnrrZpEYO5UPj/0weV7hGF5szIchrZnpmihvjSdGqyw5li4u+KvTFd0cXQsn6OwTBJ1T59E5KUasUyeo80nHQC5lx/yBxWBcDXyqjZswq4bKYiyWYoV3UzvkkAqENnQhk+sJlwQpa5yDL6XBbEZJ07g62lK1ITLVZZIxXiAN5k6+PozV0XjiCVaEidZVJAMKyJFTW1LBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ2PR11MB8540.namprd11.prod.outlook.com (2603:10b6:a03:574::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.13; Wed, 27 Nov
 2024 23:04:47 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.8207.010; Wed, 27 Nov 2024
 23:04:47 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"yuan.yao@intel.com" <yuan.yao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>
Subject: Re: [RFC PATCH 1/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX KeyID
 management
Thread-Topic: [RFC PATCH 1/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 KeyID management
Thread-Index: AQHbN5vgtMhvA2xrukuV6jMhm30vmLLDop8AgABiGwCAAAO6AIAAIO+AgAdYNoCAAFCwAA==
Date: Wed, 27 Nov 2024 23:04:47 +0000
Message-ID: <447532e67e834f44c59beabe0bb2efba82644550.camel@intel.com>
References: <20241115202028.1585487-1-rick.p.edgecombe@intel.com>
	 <20241115202028.1585487-2-rick.p.edgecombe@intel.com>
	 <30d0cef5-82d5-4325-b149-0e99833b8785@intel.com>
	 <Z0EZ4gt2J8hVJz4x@google.com>
	 <6903d890-c591-4986-8c88-a4b069309033@intel.com>
	 <92547c5fea8d47cc351afa241cf8b5e5999dbe28.camel@intel.com>
	 <0835f21a-c0b1-429c-a107-d7d0a2838194@redhat.com>
In-Reply-To: <0835f21a-c0b1-429c-a107-d7d0a2838194@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ2PR11MB8540:EE_
x-ms-office365-filtering-correlation-id: d0e440c5-4af5-4159-b052-08dd0f37e3d7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Qkk4RTk2Qk9EZHgzUkR5TlVhYlVjUWgvSHQzMW9nRjYzd2lxNW1TeXNzcG5Q?=
 =?utf-8?B?SG90T2FpckVQVlRxWWhiSzQxZytCeFZURGNnck5weDROdVp2WVJwS2JIRmFT?=
 =?utf-8?B?Q3VpdDkxcTZaa3hnN0JYanU1a0s2RTZpbVJ6QUE4N053dUw0bHc1aUk1ZTlj?=
 =?utf-8?B?NmpOUmRMOUt6RUZNZW5yR0FGeTVxQmxoMUdxckFJUHVNWGpjeEFDWVYvc3Zl?=
 =?utf-8?B?dU11blpWTVZmY3AvZnNwTVYxSVRITXlTQ05FK3ZHc1Z4RGt0eE0rUHRvNmcz?=
 =?utf-8?B?MVh2YXdxaVZTVXdSVm0ycXAzTlBVd3N5VGx0c0NncGcrZld3WWpZVkUwV1hO?=
 =?utf-8?B?ZnovdXBzVHhaMEU3YkdPQ01DbnNLeE04aXZMTmMvTlBVc2pIUCt6bHVoa1NC?=
 =?utf-8?B?Q3FiaTFMQ0VITUhvVnpGSHpJK2ErZHdDSlFxRU1XeCtuMmx5OGhTYVN1VUpw?=
 =?utf-8?B?SnVyUzhkOTlDdkhmUnNVS3FsSnlLR0h6T2MxMFcxYUhIK1NJWS9kUm5PUEla?=
 =?utf-8?B?aEJZb2hWVU9WZHlKaWU2cTdnT1Vqd3FISXZuRkdmV0hZSkxEVDdmeS83SE1u?=
 =?utf-8?B?Z0MvTVVZQkFXT0I1QytCLzFqbXRRcU0wZVlnVVhSRUplQTAyTHI5ZWYvMnpD?=
 =?utf-8?B?MVhNem1Mbmd1VFNmUXlLV1NPNGJzS1prM2JTUWE4YU91OTcyUEdyaXBrNmMy?=
 =?utf-8?B?SUVLOEx0SENiQldUTytUczI2ZjNiTlh5Q2QvYThqc1RlNWFEdlFNT1pSSjZz?=
 =?utf-8?B?N0VyeTNzZGlhU1RlUGd0VjdxVC93V295cWhTYUtTaHZHZXR1TGMzVUE0cTc5?=
 =?utf-8?B?MkNiQkwyVnNFRlRrMkhad2FKeFJkaGVWdVllamFPcCtueUt0aVh0dmtRTUIw?=
 =?utf-8?B?ZFZqVlpLdXZMbFV5eCtTS3o0T2NDbkNlWU8xc1psSG9qU1MrZVZOYkZlZ29Y?=
 =?utf-8?B?NzNWczBFZUVBL0ZhbWpVcHF6TkxySG11K3Z1SmhFR0o3ZWFudGRxOHZBd3gz?=
 =?utf-8?B?aytzSW9VL2tYSUVKM0xaWWJldXBYQllIVHMxamY5TElZTktXWEJTbVNEMjBk?=
 =?utf-8?B?eFkveVVhTWZ3eC9MUlRwNFFwd2Jha3NIMVNJaExZSDRDMFlOY0pIMi9iTm5N?=
 =?utf-8?B?S1g5ckg0dWRJd25JVXFpUFFrS3djZWd0SXFPalZqcVNyUkpncVljOEE1Vjh5?=
 =?utf-8?B?dDVOdTFJdWZGcUg4ck1BcHdWRWN3R3VPc0R0MHJpZlBjL1FHdUxGU3ZHNWEy?=
 =?utf-8?B?S1ZGQmNNK1dBMWFwaEFJTWNkejF0cHNHUFZqbkRwZmQ5MFJPcDgwN2lyM0NC?=
 =?utf-8?B?M2lycTRPZlFrVGw3bXcvZGcyZ25uZkdsWnl4QVhWeFVMV1VjVU1UcGxVNGVo?=
 =?utf-8?B?ZU8vYU1SRlRFaHhPelJkV3JZaHNvYXZNZFdqTjlsQ1ZFbVlRQ2xUZkRzMW5l?=
 =?utf-8?B?dGJ2eWxHdDc1OUozdkVLVTZVVjhMbDJWOFVMU1FiUFRrSzY2Q3FzcDJtbGQw?=
 =?utf-8?B?WlphUHpwQ0NSSSt6TnpqRXpadkZRWG0zdjQ2WmhMODduV3p5Qzcrc3NibjQ0?=
 =?utf-8?B?QmR2ZzhVaHJXSHZEdVgva2tQYnhXNjFPU2dsb2h5elhGbndpb0RkeDYyNjFV?=
 =?utf-8?B?YWtZM3dvWlZGU1FoSENvQnZaS3dwNWVIZUltQ0dXZGZhODNmUUdNM1JXZ3Ew?=
 =?utf-8?B?cUs1cWpReE5NOXpoWWhhanBYMnVsUVI0QzMwOU5OVVlTTGhuWkl0NXVCWHkw?=
 =?utf-8?B?WDVBbnJqZzRWcEdPQkUzT0FNUGtpakVpU01Yd1NjOG0xVmxSUzZrdUpLMnlh?=
 =?utf-8?B?b29kYkU1Tjd1UmtwdzJDaTZ5WUxLVkRLSHB0SlRPTS9CLzBhOVJnRDNKaS8y?=
 =?utf-8?B?V0plZXdmYVdKdnhmbU1hOEFIeXJZVjJSa3BGUE41QVhKQlE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K05sUkVZZHNKdFZMRzdRdWJzWkpScUlycUlOT1NSQjZYZmo4OWtWQ2srUDJa?=
 =?utf-8?B?WVI2T0EvWHpXL0NMUFpUR0ZwL2gxSUlHcyt3U1JhR2ZqSGMrVlZKUTRxYnE0?=
 =?utf-8?B?bitxejJkbmJtSjJuRzdFemJwOWJvZy81TVo3bUlZUGJsNE92cjlOUzFwbVdh?=
 =?utf-8?B?SkZ2aklxS01KSlh2Vi9rQVRTZzF2alNlNW9mbzVJdmJWY1VZZU1UMUEwK3Ns?=
 =?utf-8?B?RWoyM2pzVW8rY2NCQXhDSjNDTE5TejQ1bU0vMGtXV293SElPdHRyWmhUZHN5?=
 =?utf-8?B?aWcxNW81Y05jdU01ZlVGNGx5MGRBbzFrcC9Bc2xnL2JBUGF2RmF4STlIc1J5?=
 =?utf-8?B?YUh3eFZDMkN5TU93S0JneTR3Q0xqZzR5T1BaMlZQUUpPZHFacmEycVhiVHZH?=
 =?utf-8?B?L0swSC94a1ZiYUNmZ0JrdThCUkE5V2hOd0ZEZmcrdDdXR1pHRHZ4YnJwUDVr?=
 =?utf-8?B?TnZKWE10a0FVbnVHZGROVkhqQWRtMXBsMkpOelY5SFhqV0hOUGtTM0J4Mmd6?=
 =?utf-8?B?WEF3UzZuaHJwM1lrWDRaOC9iSzIyUi9QWGpwdUkwUVk4ZW1pMjVmWm1qb2k5?=
 =?utf-8?B?WVpvckR4Smw1NlFEWC94L1JZVW1QdmpzV0R4UzdSakhQSCtSd0I0ZFAveXp6?=
 =?utf-8?B?VU1hRWdMdE9uUll5NTQrcXAwek8yR3Z2cEtnUnlwdndjRm1oazlkTnd4eUpF?=
 =?utf-8?B?clRlMVgrdEppU2FmckZvR1kwaE1HaTcyNStZeFEwTFVubU94RUhYcTFabldo?=
 =?utf-8?B?MG9jLzJqRGxqQmhwOWZWUWFzVXhGWFVSYUFlYTdpRE9ZTEJXRDl3a293V3NQ?=
 =?utf-8?B?VC9RWE1yU21yVmZWWWJ5c1hlU2I2Y1RpYkM5VlB1dVZKdDVqc3o1VXBzcWtL?=
 =?utf-8?B?WVRRU2RENkloRFZrWWVJN2dScGUxY054dmxDS0ZRVFZoNjMzZlBFNlU3Z2tC?=
 =?utf-8?B?NVczaFFUZmFjb0dPamlkU01ubm5uaHVNZjUrU2g0WDUwTTRkbU5sZ2JHWDJq?=
 =?utf-8?B?bzhNZ3VQc0xTa0N6UitReVhJa1ZzMEFHT2dZeTMvSEFoR1JuSW5MMUp2czcr?=
 =?utf-8?B?VG1nWTVXUmhhbjdGN2p2NkhtREZIZXdmeGNxQXJ4a0cvc0RYZjExNDQ1enV1?=
 =?utf-8?B?VnFleDd1TU40bXpWSlN4c3kyeWhQQWIrMHFPUjVjZmpUNzNKU2dIVEppblVK?=
 =?utf-8?B?M0tybWhZMVVVa2hVTklSazNONHRxNTlpOXVRcngzQUJJZ3duaWNxblBxRFJZ?=
 =?utf-8?B?OExZQlBQTDc0R0xzdDdUNHBVcE96MW5hZGl6Y2NkUmVUSXBuWDgxamxUQjRK?=
 =?utf-8?B?NnpnNUJHZDRRdGN4bmw2ajU4emtPK2FtTVFCNmt4SHNRS0h3U0dvajg4anFi?=
 =?utf-8?B?cGZnbTRKUHRyb2IzWUx5MTByUVEweVgwUkt6R2VUQmFuK3NLMkdZcWR2Z2lt?=
 =?utf-8?B?TVFNd1dGdTVQbTR2MHJOZXlEdHRackdHVHFnemxSQ1NuSGtFZjEzdzRhdFZT?=
 =?utf-8?B?K3Q3WGFHdHkrVUE5S0RxRE41RE5USFNTbGpoQjRDUE9lSU1DaEp0LzdOWXZW?=
 =?utf-8?B?dWdzMjBnZXh6dlJGWlZoUUhEUjFucGFSdDNWemJlTy85MGtRT3FkRFBTSGxY?=
 =?utf-8?B?akxqT0VhWXNIVHB0WlhCQVRaVXdoMUZOOHpsTUZwUnlCKzk5RERodUV1Nmlu?=
 =?utf-8?B?QWlBUjhsTEZUWXIyU0NiaXIrQWhRNFlJSDBNZkpJMHRxZDJKeGNwSVRIeHE0?=
 =?utf-8?B?L2ZNeG5weVZFRWVqYm1PT01SUUJ3djR1YVBDaVZhR2RYUDZBQjJIQjVwQkh6?=
 =?utf-8?B?Nmsrd004VHJFQlpXM3MvZWJBdmNQbTJTOGxNWG83dkRSRjlBSGsrekswNDEr?=
 =?utf-8?B?cFMwMlNRSkhkNGdVdUtXb0NSSGoyUXRCZC9aalUyOGhnejFVaWs3UUtJYnlk?=
 =?utf-8?B?WlhJU2ZwVm9sWHNveFhsL1YraWNxVGlEZTN1OXAraTJVekJ4MUdFK1ZtbjN2?=
 =?utf-8?B?cjJlbUV5SmZJNlZKaWZDVTRmN1cvN2s1TVBJRVBRTFJDSk1FN20xcXZ6WFlT?=
 =?utf-8?B?OWs3M09xMTJ6aUhJUGNDbGhDbENCWVZtTmt5WktoMmtpQzZpY2pwd05ldjNS?=
 =?utf-8?B?MzB3d2lua1duVGZuVkxOdUpyNkRsNTJOZTBXVC9RUGJuTzBZM0Z0OVJiT3oy?=
 =?utf-8?B?MUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BB872A329BEA974281BF1078BDFC9F1E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0e440c5-4af5-4159-b052-08dd0f37e3d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2024 23:04:47.6147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /ktaCwHiiKtJITZHpsPHfoXIXGCrHXdOACF+0p5EBSEHXK/DAbfdL2o79DI0l+9EmIc4QS1YLf+NILStfyuhc0AlmVjLsw8usM8a9FoyjLY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8540
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTExLTI3IGF0IDE5OjE1ICswMTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiA+IFdoYXQgaWYgd2UganVzdCBtb3ZlIHRoZXNlIG1lbWJlcnMgZnJvbSBocGFfdCB0byBwZm5f
dD8gSXQga2VlcHMgdXMgb2ZmDQo+ID4gc3RydWN0DQo+ID4gcGFnZSwgYnV0IGFkZHJlc3NlcyBz
b21lIG9mIERhdmUncyBjb25jZXJucyBhYm91dCBocGFfdCBsb29raW5nIGxpa2UgYQ0KPiA+IHNw
ZWNpZmljDQo+ID4gYWRkcmVzcy4NCj4gDQo+IEZvciB0ZHIgSSBhZ3JlZSB3aXRoIERhdmUgdGhh
dCB5b3UgcHJvYmFibHkgd2FudCBhIHN0cnVjdCB3aGljaCBzdG9yZXMgDQo+IHRoZSBzdHJ1Y3Qg
cGFnZSouIEN1cnJlbnRseSB0aGUgY29kZSBpcyB1c2luZyBfX2dldF9mcmVlX3BhZ2UoKSwgYnV0
IA0KPiBpdCdzIGEgc21hbGwgY2hhbmdlIHRvIGhhdmUgaXQgdXNlIGFsbG9jX3BhZ2UoKSBpbnN0
ZWFkLCBhbmQgDQo+IF9fZnJlZV9wYWdlKCkgaW5zdGVhZCBvZiBmcmVlX3BhZ2UoKS4NCj4gDQo+
IFRoZSBvbmx5IGRpZmZlcmVuY2Ugb24gdGhlIGFyY2gveDg2L3ZpcnQvIHNpZGUgaXMgYSBidW5j
aCBvZiBhZGRlZCANCj4gcGFnZV90b19waHlzKCkuDQoNClRoYW5rcy4NCg0KPiANCj4gQW55aG93
LCB3aGF0ZXZlciB5b3UgcG9zdCBJJ2xsIHRha2UgY2FyZSBvZiBhZGp1c3RpbmcgaW4gdGhlIEtW
TSBwYXRjaGVzLg0KDQpJJ20ganVzdCB0aHJvd2luZyB0b2dldGhlciBhIHYyLiBXZSBoYXZlIHRo
ZSBVUyBob2xpZGF5cyB0aGlzIHdlZWssIHNvIGl0IG1heSBiZQ0KTW9uZGF5Lg0K

