Return-Path: <kvm+bounces-48231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F932ACBDC0
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 01:45:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 477B17A811C
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 23:43:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97EB220D4E1;
	Mon,  2 Jun 2025 23:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QbxieQHD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFA318B47C;
	Mon,  2 Jun 2025 23:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748907898; cv=fail; b=ZVXKC6EI+qWGJHfffizKfV86ab3IPVtMeRAaO3PDrP0kyNhDJ5CT7abnU6tsD9G9d5oMXBONS/yqZkKaIVm4b//SVEoje+/GzscLBWRk2j9d4CS77Nz9tNO1bm07jPFWreG/9Rx0XkuoVtvlJivYAKQ8ge6NcpA+P0+WXYEZJEg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748907898; c=relaxed/simple;
	bh=jNY2StSrKgxAT1ro1Ltzpddtxwx7FZ30beCOKOh8SIg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Fi7dV74BWgBx/VScKKMyeka91LkqgVFSC9fk1kRvVZR7rKkHabhGAlfbVAz52GCq5scuIUq6AQLLFTLmTSgQQEHJ4S4wVxnsXKGmwgjWU6Ux3AYrMKsTDKNq27izYK5SecpJxulEE4ee02jkDcJ5Ll6s4Ad78hEvAKcePZoSK9Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QbxieQHD; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748907897; x=1780443897;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jNY2StSrKgxAT1ro1Ltzpddtxwx7FZ30beCOKOh8SIg=;
  b=QbxieQHDS80FObeyrqyz2+ACcx8X7Exk+tZopPuTdv0IUKv2jmIDi/JO
   qPwdgeKmXwShu7/gkv8xWyMLu7QkMIBiIGNH/eCisMd/75ezcGbVG8G9P
   3IC1G7DKefmX0q30QLHJsd+oS2pEBZhr6Srhw7YBT3hRhm4A0WIAzERHq
   VkJS2GFxmq0skgPy3eauKxl2SffttOzn0SjmaLLWWZnCX0gN31L5nKyak
   JPg/bxC3SzZHaUNRFYRbLxRLx2pwWSncCbHOh024Ntn92PqZDa1I3YfJK
   lMPw9zDYSIt0WPbL5Jer3LFVwr5zKoWEWEl+6XPUCXj3pSnfTcNim/12N
   g==;
X-CSE-ConnectionGUID: Tc8I2G3tSvOWn2KYZlTVLQ==
X-CSE-MsgGUID: +WCyY16hTgmTQ+jtyFIbjg==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="61188417"
X-IronPort-AV: E=Sophos;i="6.16,204,1744095600"; 
   d="scan'208";a="61188417"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 16:44:56 -0700
X-CSE-ConnectionGUID: e53MKc8+Sr2vduwZCmGTAA==
X-CSE-MsgGUID: SvwGwdQ2REiwsQgmGNBbUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,204,1744095600"; 
   d="scan'208";a="145611091"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 16:44:56 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 2 Jun 2025 16:44:55 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 2 Jun 2025 16:44:55 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.53)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 2 Jun 2025 16:44:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kWou9cy6eh31OABgGKxabkeX8SYMRk8+vWIT7mj2BCe9hWsuDEbJADmZ9EHuc5pYBaop44q88c/IWMv6ZLadFYjGaYeYwRsmvSFbxH4huD1CPMO3Zb11IsLKm/GoBUalEXbKhMz5QbO/s60en5IqbFwf/qUk8KyLWOpmv+gcPKe/y4dsb2U2/bKGbCYN2OLbdF00SFXFbWQbhMaaKSV/x5Ojervh35XbsMKUXBNYHrEOWTut4b+Yum20/ElwheuDwzM0bqXNa7OFpiRzmUwak7Wy+FaxrSQ3JP+/wF9UHs+8/JW7PK3Kk/KpymNdKgkVjAOtphpFbOtJ/9AUoyHudg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jNY2StSrKgxAT1ro1Ltzpddtxwx7FZ30beCOKOh8SIg=;
 b=cCO66Wenvgu+KCtHz/3flsk7R54SoNa32Iiz5f61lC/2SuBjg1yKCkCXt9rtUZT2RBirMUgz5G8Gehkf0C5IvqoC+mpMIudvbqWTq/QRRh6WC1gpVxEwLJSgyFj4GR/9pjLdP2oS8IVANNmgEt3/K4ogdPqOKY+dQF+lep7AL4DjzHkRg0+5GzQ3R/ry8nkjNvbuQ2YK+wpAnQUGZ2giJNfEVHHpQGufU+0XZ772iNAZYSqxfyxCfYErjRf0XqU37bvbwMeL7Os48gGAyZvH8T3YKq0f0kOTXbKZ08TAs/oY5xanWbE6V2uM2hmMZavXaTnJx3XNfwW4aPTXnIV7yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DS7PR11MB7833.namprd11.prod.outlook.com (2603:10b6:8:ea::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.37; Mon, 2 Jun
 2025 23:44:53 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8792.034; Mon, 2 Jun 2025
 23:44:53 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "Dong, Eddie"
	<eddie.dong@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Reshetova,
 Elena" <elena.reshetova@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "Chen,
 Farrah" <farrah.chen@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Williams, Dan
 J" <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 01/20] x86/virt/tdx: Print SEAMCALL leaf numbers in
 decimal
Thread-Topic: [RFC PATCH 01/20] x86/virt/tdx: Print SEAMCALL leaf numbers in
 decimal
Thread-Index: AQHby8iKEFv13b5gokOLaefXvu8HtLPwmRaA
Date: Mon, 2 Jun 2025 23:44:52 +0000
Message-ID: <49701fa54f8410b3705f4046e80833d7824983f0.camel@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
	 <20250523095322.88774-2-chao.gao@intel.com>
In-Reply-To: <20250523095322.88774-2-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DS7PR11MB7833:EE_
x-ms-office365-filtering-correlation-id: 6778d1da-d762-4736-a503-08dda22f78cb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?amxFR3JRQ3MrVld3Wm1RSGFZREVNTDU2Z0xYSXhvU1Vxbk5uS09LRE5WemRO?=
 =?utf-8?B?S1Y3cXlzb1RwTk93R0dEWi9PVWU5NnpBVm5VbEFyelc5U2RPVllXSVNMWUxC?=
 =?utf-8?B?NzVBaDRjenBUY0QvbmozWjZjUkR5aElUL1dhdTFaaE5oOXpGVXZaMzZzbGUv?=
 =?utf-8?B?ZDVTZzlNY3F4Uy8rQjEzdHpXQVg2VUhLS1I3ZDB5MjNzY1dFaEJYOGcyMTVn?=
 =?utf-8?B?Z0Fsa2dXeDBLVWp4dkYyT2dQeUZLeTNVbVdVSjlaa3ZPTm1lSERSTlRWdmd3?=
 =?utf-8?B?a1hvN0d1TGZxT0xYM3Jlc3hRK25jZDYyNzhObjdRSUNVTUtuKzdjRVZtQ2tJ?=
 =?utf-8?B?K002ZEhNQ3RlMlA5VG15b2tsUVZ5WWhqVlkwRFVZOTV3SGpUVXhaeXp2OFNl?=
 =?utf-8?B?RHdwUEpLTU52UG5sdHZFTitjQS8zemVhYUZVeEVjek9hd0hLb3dnSnBRUjBl?=
 =?utf-8?B?b3RUb3RNZk5vZzcxR2hQM2wxWXRSck1RS3Zzb0svdHdFVGhuTkkyNFIybHl4?=
 =?utf-8?B?OTJXTnZMQ050YWFVWGNITzRtZTFPNTJzSU9pU1ZIb1JIMkxDbnBjdUZJV3Fa?=
 =?utf-8?B?VmZPYnY2dzBEOXdtRTZISHUxZjlsK2E2YVhLMlMrbzFDTXFPVGs2NWs5NjBx?=
 =?utf-8?B?VlU0WWMrVk9jWUJaSGtqeTNjT3N4QlhDMXlITDNXVXJESkVJbkVGeUthUEdF?=
 =?utf-8?B?dDNkeTR3WjRiZ3dpeGpDWGJKT0tJL294d0wxaDQ0ZExzazBhYmVtNkFOY2ZB?=
 =?utf-8?B?RXA5MU5pZXR4czA4Q2xrN1pla1FIek15dXBBaU5qL2ZsQ3JWUDkrelcvWGFp?=
 =?utf-8?B?WW1Sa1ZFQ1NQU0gyaU93ZjJSUVBOQ0xGdkd6SXRMMEVaL3JydGpXMElFT2l2?=
 =?utf-8?B?ODJSVWNnZkVlRlRiM1UzRi9HOUVhbHFFRkRIZEs4cGFKQWdUa1o1QzlhdFpy?=
 =?utf-8?B?WmVwRTBPYjJDaitTWFg4OGdxWTVCUVRQL0FTUStDNnNYWGdRY0l3dXFIYXFP?=
 =?utf-8?B?d2paYStwa2hoRVFlbHhwR09lVU1GOXl1NE1iYUJFMGtYZGhmYWlwdHBROElm?=
 =?utf-8?B?dEN0emJnNm00Q1VBclpYMFFzTUdtL2gwbmtBeWpQN0s1K0FhdDRUbWFLaHB6?=
 =?utf-8?B?YmpRaER1eHJOV3FiU053VWlEbURjOWhxeUFRSXZIQ1V4SzJ6MXhCMU9vcEtC?=
 =?utf-8?B?ZWxQZk1kUW4vQTZSM3JIMnZ2VzN4bnpvVk8yQUFFaXIrZW9ZZTE1UmtVUHNU?=
 =?utf-8?B?TjhaZnl1aFBFdmlxRklCN1JycVpCR2p1bHV0RmFGc2JtcmkvMkV1UzlTR1dV?=
 =?utf-8?B?VVk0b3RKaE5UY2RVYkFHeGo5UVV2bWp3a1hEMjVIV0F4cGVHYSt0dklPRWZ3?=
 =?utf-8?B?QlAraGduS1JlWnNNeU9qVnJRbXBNN25URi9OYUU2SHJScENCTC82NEY2V0E1?=
 =?utf-8?B?VHV0T2p2cFVjQkx2N3Q3cjJZY1NsN3pXRmxqSmVBUTlSK2diWkdkbWlKQndR?=
 =?utf-8?B?NzM4T3dlVVl3YXM2UWtYMU9scFE1V29UUTRKeFFtZUNhcjZaTjZyNWFoRkNj?=
 =?utf-8?B?K1BFUmEzWDNUZm5LZ00wWkhScHBJTFFDUm1Gd1h0QVA5N2NTQ09Ob2RhQWIr?=
 =?utf-8?B?ZFk4dzdLc3JocGJJdkIvSFAxUjBqT1U3aFZQWFdmVGRSVEcrTVJ3SWEvSWdz?=
 =?utf-8?B?azFSVUxEL215NkRwcnRMQjNNc3RMSmhlSFMzUmZRYXBrQzFmVTlZeEhzdkI5?=
 =?utf-8?B?VVBIcUtJS25QYU1qcXpWZldwZ2hlYzdsVnRnYjIxTkUwYkVnb3IyTjhFY3hY?=
 =?utf-8?B?NTJFRHBWbGc1SnlZeDBObG5JUjBlMnBiUWNqYjlxc3hidWpoVTdkQUVsQkh1?=
 =?utf-8?B?OWU5M0FvbkVyUFk3a1pNSTZBT3NYa0pOY1ZwNWZ4cC9xMXZGUGE2M01HZWxu?=
 =?utf-8?B?R2oyVm5Sa293SDlRUm5UWGxtMGN2SzdWRUYvVmRsTHFDYnRnWkhUNFdTV3l2?=
 =?utf-8?B?dGRmQXprcTl3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z2tTTjNNU0JEU25DOEoyYUVkaEppR0NtTFZPM2pEaHEvSnRVMHZNS1dlUFli?=
 =?utf-8?B?T0c2TjhROWxuRW5Ma0NmMTRwZjdQL0xGS1dFL0hsbTdSWUlTVEdId2xLTVNy?=
 =?utf-8?B?WHhmQnNFeDViOExCN3FrT0RjV0IwS09OQnJuKzg1NytvWHVBbmZjR1pCU1ov?=
 =?utf-8?B?QlJtMWdnUVlYS2l3UjY2UVBYQkcwR08xWG1PeWdzY2xWUDRHUVJKMWpoSkZv?=
 =?utf-8?B?OFZWbFFldzJOT1hEd2hHTFVDMTI2ZzhTNG0vSUhEY29KdVFvcmdLb1QxeFJP?=
 =?utf-8?B?NDZsUDgySHdHVmtVMTdSZ016d0hEQ2JZSDh4NmZkelpKT2hMVlN6ZzVmUGcy?=
 =?utf-8?B?MlFQcUpvczVLQzdqVkFQSEpKQzZJamNCOGRlK2xaLzAzVTU5Mm9uRTUySC83?=
 =?utf-8?B?d0JMY0NYdUpjcUovVXZENFpPN3F5WDcxbDI0T2RPN2RvQTVIdk96Nm5IakRQ?=
 =?utf-8?B?aitWN0VhZmpzdFUwOU4zSkZETEJvVXhkL3lIQkoxM0FsQTMvalFCejByenlr?=
 =?utf-8?B?cVhRY2VodlVyTjlERmZ1djBHbXk3SVRDYy91MW56Z2ZnaGJZNlBLQmhNekI4?=
 =?utf-8?B?Zi9MelhxZHN6VXJvaHpIWUpzenE5RUhHOHQrUHI0T0ppQ0JDbGJveHZhME5N?=
 =?utf-8?B?cnRWWDkrV0o5bnBwaHByVTQzc1ROS3FGaFlxV3hwajBSVE8zaStQTUJab04v?=
 =?utf-8?B?c0gxaXZURDF2WWRHN1BuaTVoZDNxYXVMNHdyWFA5eGtaSWJadU9ueXpLbEZv?=
 =?utf-8?B?UVNxL3oxM1Q3WFJPemNML2orZk5NNE1rN1JIbW1nbXNJL25WYVVNL0JBL1BS?=
 =?utf-8?B?UjlYWnc0ZzJBYVI3MzE0ZFlIbkNmN3NaU3o1K0Vkb240a1hBbmlBU0lEUEhR?=
 =?utf-8?B?R2pUekN2WjZKSTdRbGxJeGk0Wm00ZlFoUXhMcTAzbTVuUmw3VUVnZjRmQkEv?=
 =?utf-8?B?UUorUTFVeWdMQUg2T3hFQit2cnpuL2xLYm9GSWNyWnRFZmNQZEg2bG9uK2hM?=
 =?utf-8?B?ajQ2QjloajV3U25jakd3Q3N5eGJIczBhMjFCTXRyZWtnN0RnV281S0ZjTldL?=
 =?utf-8?B?N2ZvMmRlMmFsaGp4SEZpVnBRRnlSaHd3cUR3dDQvQlg4NVJoOVJwM1BhWXlY?=
 =?utf-8?B?VENKUFRpbnhzWm5YSTVnd2ZOYnAvY2p2d2IzOTBrS2YwWUlZZFNQMGkxVUNt?=
 =?utf-8?B?cHQ3YXlsRHdreVhsY1U3eWdXaUhQdFpCWGNoeE9JSXRFdUZMcEhacWxaWmYr?=
 =?utf-8?B?WG9PZ21DVnljZW96bUpQemVpTnlRU1FNOVZKUWhhSzJMVXdvV3NEcE4rd25K?=
 =?utf-8?B?dEdVVk9sMndnTEU4T056ZW82eXdFb3BtS1VWeDMzR25iRVAvdnRuTG5RYlF6?=
 =?utf-8?B?SmxCbTJuc3o0dytYRXdPOWQwSkJIMnBMeWVhQ2YxUmtNYnFtK2ZRUTFKRTJq?=
 =?utf-8?B?M0IvcmJnbDl0dThzd3JYOTY2WFZISWJKakZSUVdoRkhvMzl6ZzJ4RExWZEp4?=
 =?utf-8?B?VW1xcVZDTzM3cldtV1NhcitoeTNSWXIxWjY2MVVGQ3hNK2hkMHh1MkRSYjhK?=
 =?utf-8?B?QU9yc1JIamJ3MFZSZTZXczRTd0d6Z0RaR1pUbjhicXNKUFltUWtEcks2dndI?=
 =?utf-8?B?RGo0RFluSHd6bStNVlQ3VTFad3h5TXM2ZzNpUEN3aG5JKzJ6bks2L01jWkwy?=
 =?utf-8?B?U05XT0Naa3lOeEh4RjBIbEU0My9MV0VMUCs5bFpJZk5zUW1oTUhjYjN0MWs5?=
 =?utf-8?B?SnVjWDJNcGdWQUtBcVYrT0ZMcjRwS2dGSmo1dXFORTBFelhwdlZXWG1SQTNz?=
 =?utf-8?B?ZjlNeml3ajljNGc5Y0RybFl1b2NlczQ4dU1rMGxOUWY2a3FUTy9XQ0Q0TDJ2?=
 =?utf-8?B?dkNGS2l6VU1WREI4SVh2UjdzNHZ1RllLYk5ianZOanVTWDNkVmtPL3c4L0xn?=
 =?utf-8?B?Zm1hb21rVEhYc2d0cXFjQUpBUGdTWmNUa1F2eUtKKzFZSCswbkQ4Rk80R3JE?=
 =?utf-8?B?cFpGU1hKOXRJRHlEb3FuSGpoWjNVZDRWeFVVbDcrbFBXMDVoYUZpSDQ1MEFX?=
 =?utf-8?B?MzROTVR0bVYxQk9iYS9TSGg3aTFBbWxJOVFMWG1DZXFoTmpsZldUY1ppaEho?=
 =?utf-8?Q?dGGL74evwoteYvuAL14XYS7L2?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <891608589B661B459DBA685FF1E68D1D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6778d1da-d762-4736-a503-08dda22f78cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2025 23:44:53.0113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qJg3CmEuwO87IqHwi/sQa/r422aMhWaIJQdXwdrp/EaBISWMr5lW9l/KhHqEUjNwUAoPEuZhKGksH6WBFm8PKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7833
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA1LTIzIGF0IDAyOjUyIC0wNzAwLCBHYW8sIENoYW8gd3JvdGU6DQo+IEJv
dGggVERYIHNwZWMgYW5kIGtlcm5lbCBkZWZpbmVzIFNFQU1DQUxMIGxlYWYgbnVtYmVycyBhcyBk
ZWNpbWFsLiBQcmludGluZw0KPiB0aGVtIGluIGhleCBtYWtlcyBubyBzZW5zZS4gQ29ycmVjdCBp
dC4NCj4gDQo+IFN1Z2dlc3RlZC1ieTogS2lyaWxsIEEuIFNodXRlbW92IDxraXJpbGwuc2h1dGVt
b3ZAbGludXguaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBDaGFvIEdhbyA8Y2hhby5nYW9A
aW50ZWwuY29tPg0KPiBUZXN0ZWQtYnk6IEZhcnJhaCBDaGVuIDxmYXJyYWguY2hlbkBpbnRlbC5j
b20+DQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQoNCj4g
LS0tDQo+ICBhcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMgfCAyICstDQo+ICAxIGZpbGUgY2hh
bmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9h
cmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMN
Cj4gaW5kZXggZjVlMmE5MzdjMWU3Li40OTI2N2M4NjVmMTggMTAwNjQ0DQo+IC0tLSBhL2FyY2gv
eDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiArKysgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4
LmMNCj4gQEAgLTYyLDcgKzYyLDcgQEAgdHlwZWRlZiB2b2lkICgqc2NfZXJyX2Z1bmNfdCkodTY0
IGZuLCB1NjQgZXJyLCBzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzICphcmdzKTsNCj4gIA0KPiAgc3Rh
dGljIGlubGluZSB2b2lkIHNlYW1jYWxsX2Vycih1NjQgZm4sIHU2NCBlcnIsIHN0cnVjdCB0ZHhf
bW9kdWxlX2FyZ3MgKmFyZ3MpDQo+ICB7DQo+IC0JcHJfZXJyKCJTRUFNQ0FMTCAoMHglMDE2bGx4
KSBmYWlsZWQ6IDB4JTAxNmxseFxuIiwgZm4sIGVycik7DQo+ICsJcHJfZXJyKCJTRUFNQ0FMTCAo
JWxsZCkgZmFpbGVkOiAweCUwMTZsbHhcbiIsIGZuLCBlcnIpOw0KPiAgfQ0KPiAgDQo+ICBzdGF0
aWMgaW5saW5lIHZvaWQgc2VhbWNhbGxfZXJyX3JldCh1NjQgZm4sIHU2NCBlcnIsDQo=

