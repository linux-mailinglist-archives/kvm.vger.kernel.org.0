Return-Path: <kvm+bounces-55199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08D4EB2E273
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 18:36:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 10B5C7BA26E
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 16:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B54D3314BD;
	Wed, 20 Aug 2025 16:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SwUhNrri"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844AD32C325;
	Wed, 20 Aug 2025 16:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755707723; cv=fail; b=M3d32NJOg/ZzKPYMtJIu6VNVa88jFDnIYpD8ajfpX8zSez6SYS4sIIJwydGiHOZCcue3g8G9qcSeD6b2z2DfHxLErV7HljP9y3zZN4Sm2PMLMR+026SqIJcvotHr54ImT62fyfC3ve0UqWnlJN8q7kEfnFzpPVVw0RlBuQmhP64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755707723; c=relaxed/simple;
	bh=59dLzvDUGdNU91GREt7pmokEtNhzAZgsRoPeEsdp1Us=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RHur2JTyZODnb5uxheMqp8Gzp7Gg284zfhqB/Cxc75//4OYERId+wzqV2K/VixpbwFaDQzaH/7atrpRaRc8a4h/v9vP71WiZ0+e7iYIdU13RKO+3TD7QHw9y9voDBzvP+28AgnmxcvbpMvBVcuW4Or26UCfNiISKpmkifKoj7zo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SwUhNrri; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755707722; x=1787243722;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=59dLzvDUGdNU91GREt7pmokEtNhzAZgsRoPeEsdp1Us=;
  b=SwUhNrrikO2r4AvJkGhKzHhYIsewslzul1bp7+/hGwwPu+AivRKwAe+p
   l1YzeBVfn970Q/NIJgrJ5RTIeJe72khuWtPMLbWHnb/vZTgOCMIpojrVT
   aQ+yD8y6Zhrdv/HhxuctDMEsSjcWWUgalI2wZzk8rtaNVmZfOG63paU0l
   N530/ua0eKbtXC3/vBZ4kdY3tkxqzf5wa17DT9ZirX7JL1LzB+M5yiUcq
   IuUd90r1z6XeFP7GHFrxtCz88QTL2zCMnANfnr4B6iiu2a8ykDcmT0WN5
   USsoNnx2PTwOzMrHSkIv9b4YEDM4s8kZiKN8/fc+chns3O4ic+kkOPmH/
   A==;
X-CSE-ConnectionGUID: CepOVAohRPOZ0Hrc8txVAg==
X-CSE-MsgGUID: RzzGD75PRM6BU8OoJ4hhTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="57897778"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="57897778"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 09:35:21 -0700
X-CSE-ConnectionGUID: C6Ndj7JFRzGz3SAvNdOLRQ==
X-CSE-MsgGUID: m8KhHuwuRe+bSQ6HwUYtHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="168091661"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 09:35:21 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 20 Aug 2025 09:35:20 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 20 Aug 2025 09:35:20 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.79)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 20 Aug 2025 09:35:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jgxqP+89cQKFE69FRU3VOG0W20KnWJNVwruf01jrjj6akxLFGbYfTpevnz0QRWCTtNUOhhKPzFg7P2BwN3hlqe4foFoN3m2AA2dmLMMPh7FO6LsP1qEgDcB0WjboUn8vrqIGksRVGDGVQSyFCFg6qnhv11zOX8M1tlVH4IUT9tfriFU5fX7WQ3Doa0uY2j9YZCJxXUHrFggCEDnXk5tTzEovrP/9cw/wuke4KAWOFyHGztWJiZB8sHsJng3iNT0prPr/xKHX9m5fA5Kx6WggyOtijwwrJ7EREupCd0VkKTT1wbqzHROHcuihTj4xXjvcnzDVck61OJmebgLUhd+tCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=59dLzvDUGdNU91GREt7pmokEtNhzAZgsRoPeEsdp1Us=;
 b=G9+JG+RLe5ln8TFPWgZn81EjHJMq97lp6kh1CHLnxjKT0qp6EBkjAPj7sqWgYrpwcj/yTtm+ytLTfpDvALDi2yh4XM1N7PetjJEH5MpM07vBkF6e9nt8nLSsmR4khiTNPqOAQ+hRIQSVSyFfx/AVnx44ZCsnl7mIF+7YZvKb8O0mE0EJlK/gy6Wuza+xkz0td6HZBnImB88SkXq0vpjLaZ2yU9WWAWb1wrEvVGFg5T295+muTHNKiUGYzZpMYcxOHUqv/T6UZvj0efMsH8l+pW0fYF9HqxiXrsIPu8RVBuKlMoZMvyl1jSJS/60hC+E3Wgrn102O7F2wEl6/EH38eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA0PR11MB4720.namprd11.prod.outlook.com (2603:10b6:806:72::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Wed, 20 Aug
 2025 16:35:17 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9031.023; Wed, 20 Aug 2025
 16:35:17 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "kas@kernel.org" <kas@kernel.org>, "bp@alien8.de"
	<bp@alien8.de>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"x86@kernel.org" <x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Thread-Topic: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Thread-Index: AQHb2XKrCJQDYmgN9EmkL7mVJaZZf7RZwqaAgAOdgICAAQwrgIAAOwMAgALtSQCAAA1HgIAADA+AgACzLoCAAOzGAIAIzjKAgAAR1IA=
Date: Wed, 20 Aug 2025 16:35:17 +0000
Message-ID: <9db1e2a404f12bfb0f41259caf64b068939d556b.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
	 <d432b8b7cfc413001c743805787990fe0860e780.camel@intel.com>
	 <sjhioktjzegjmyuaisde7ui7lsrhnolx6yjmikhhwlxxfba5bh@ss6igliiimas>
	 <c2a62badf190717a251d269a6905872b01e8e340.camel@intel.com>
	 <aJqgosNUjrCfH_WN@google.com>
	 <f38f55de6f4d454d0288eb7f04c8c621fb7b9508.camel@intel.com>
	 <d21a66fe-d2ce-46cc-b89e-b60b03eae3da@intel.com>
	 <6bd46f35c7e9c027c8a4c713df7dc73e1d923f5b.camel@intel.com>
	 <rxtpzxy2junchgekpjxirkiuu7h4x4xwwrblzn4u5atf6yits3@artdh2hzqa34>
	 <dd58cf15476bac97b28997526faf9ff078d08b21.camel@intel.com>
	 <aKXqUf9QBpLOeB3Q@google.com>
In-Reply-To: <aKXqUf9QBpLOeB3Q@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA0PR11MB4720:EE_
x-ms-office365-filtering-correlation-id: 2440ec85-4a54-41ec-1689-08dde0078c3d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TG4vVjRPR1J0RTRuMTdCNWxvZFRPR2FBKzhEeDFQR1RrUFREZ3FjYmhmYU5Q?=
 =?utf-8?B?NXBxdFZBbFluYjQxU2RvdkZBZWs0bEpFWW45NnhKWW4razkxcnZTTStiYjVM?=
 =?utf-8?B?WkFpUDlDbklrWTY0NkV4VlRDaCt3NitsZlBCWTNpRHVVWWZjbkNPT2t2OW1F?=
 =?utf-8?B?Z1o1TFBMTUkwVVdqSkZ6WXM0SmFjL1JkZHpQa01lT3NsZlJXRHlvaFh5WUdv?=
 =?utf-8?B?SThMNWp5NXdGakwxQnlEaDlpd0FncjhLaVlqQm1wYVNpd1JzNTZGZk1mbHZO?=
 =?utf-8?B?dGoveHdLNmNOMDdUNjZsajlna1NleWJCMnpnOVg2TW5rTVl0YmdCTTJMMkZP?=
 =?utf-8?B?clp2cElQdHNjajl4VmhmVTI5N1JaVU9STGlKVnhYaGdjeXU0NTFqUXQwcHZI?=
 =?utf-8?B?OXRNU2FhSjlUNUFqWUh3dWJTRVRFdzNBdHFVeHZvcEhEeUt4eGZqeWdieXlr?=
 =?utf-8?B?Wnoxd0wxa2ltWjU1cmhySHQ3dHhGN3JNUjBlUi9rTmN3L0dRTjlSSFRFd09G?=
 =?utf-8?B?RFlvUUlUenpoZzE5b2RMVUlaVXg2Qld6eHpCemk1Tk5sR2VHbEFuZWFmZU0r?=
 =?utf-8?B?MlRpcWgxQVRuSzhMMGwvZmpyblV6R2s0ZWZ4dm5JaUc4Tkc2NHBWbVo5TjZS?=
 =?utf-8?B?NEN4cnB6amFaeFhUejVtL0pCd3l2bzBKUVFRSm5DRm5kY0hoak85UFVzYTZH?=
 =?utf-8?B?UVlFTUYvRE0wbnpONkpILzZYR3laWnFHYy9jSkU0ZnRONUpKU2krSTdSNkpr?=
 =?utf-8?B?MkpJVXphT1RFcmZQbkhXWVVHNFcwSVZzYXFyQmJsZ1R0Y3JZS1BkTHlXTk5z?=
 =?utf-8?B?MWxoWFMvM0R4dmdXYlF2WS9qeDVaOWlaN0Exc0hwcktFcTRQM25iQWxIZ3Qv?=
 =?utf-8?B?TUJ3WHhvWGpmTlU3M1dsbElIcGtrQ3FIYkZNTXN2czRwWTZXaHFqaXRXKzBF?=
 =?utf-8?B?ZXdkaTVJZEZmNW5CZWtyZ252SGJKTVZxTktJaThWV3Z6aFdtbEswdzZIQjJh?=
 =?utf-8?B?R1RJajBzYlRQclc3UVV0RjF3Wmw4bEpLNVkvYmIxSmNkU1FLQkJmb3BYYkFG?=
 =?utf-8?B?SUhZdnpVdVpSL1pMYWRWWkZBTGFiWFIzNzRTeU5GNFJpVEdjaWxQc0p4ZEsv?=
 =?utf-8?B?N1JxTVF3RXhYczdxWng3TzhRalR2d0VKUlFhTTlhbGxrL0ViT2l0VnN2eUFh?=
 =?utf-8?B?cjBhNmZjVEVJWm4yVkdHU0phVFZ2L2JaLzQ2dFJlWnRxUVpjYkhWWXZOL0RS?=
 =?utf-8?B?YjFROFNwMjRXVUFFOHN2WTFzSGhVSUhGdVhSdFNqVHhPbFlYcm9qdmg3K1pu?=
 =?utf-8?B?aFhQN2VFRVlsR1lDMm1oTEVkTG54cE92M1lpdDhBVkdBc3Vidkt6SUZlVHR6?=
 =?utf-8?B?UGQvek9qWXdUZ1NTUVVvcDhONGNaUDZUL0trRjd0KzFnZUVIWlozN0VRVnVn?=
 =?utf-8?B?UXFobEljdVhaL20rQjVOdHdLbVVIbjBnOXJGQk5BdDVOYml2aGNRU0FoVm1I?=
 =?utf-8?B?YjBGSlFsSlRQM3VMSEFjcmNOWnVKalpkSjZReGV3U0svVEV5R0l2Zk4vZ1Zk?=
 =?utf-8?B?UGpRei9jcjdGWEdkbnJFMFpaZmI3eGZOZUFIVFN0aVB2UDdHQkIzWG5FRWQ4?=
 =?utf-8?B?NnJNTjZrVGtYbmJSL3FxNXNYSngyYVJHYzBEcnpFSjZqTXBmYmJmN1RjckhY?=
 =?utf-8?B?RWN5Y2M1bnE3Q0NPZ0dhRzYwMm9OalNpVyswNG8vR0N3V0E3dnloa3lxemwz?=
 =?utf-8?B?VWxmSlkzekFRTWZUc0QraTdmMnV2OVRqWTUrNVVlSE1BOFM2cThOUmFBOU05?=
 =?utf-8?B?MGwrVkNFeXRsb0NpSjd1RS9PbWhjMW5yWng1YlZISWlOVGtOb0dqSDlCelFM?=
 =?utf-8?B?T1pyWlh0a3BISlQ2T1pNQndLdXZOQzdwYTJYZHdOM3d2bXJnWnhEcDJvbjJk?=
 =?utf-8?B?eFUvbWZ5NjNVbXZrUy9vMWU0MjV3TjBITUZMQUx4a05zbzNvRUZvUlV2Zzdp?=
 =?utf-8?B?TjM5QmF0N0hRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmpRZ2x0NzFTSTY5NFNyQVFqZFViWi8vRUhxc09mVzhvZzhHNWZ3dWhLamND?=
 =?utf-8?B?MkM1bmhobVBuMDNsTU5tUUxIWTJtcmlCNzFDOHVLZTBwVjdYOFpmTGxyVW50?=
 =?utf-8?B?VC9kRmtYcTc5eEh6UUlaVjdERmZVZndOeVhZY3lGajA5a0xLd0s3TmliOG5t?=
 =?utf-8?B?eVcwMExBQytsOFlMNGp6djlmQzhQZWZaTEM2WHFueE1nOEZWS0VLTUhUYlR3?=
 =?utf-8?B?NkNoSDlUa2VCdnVCcWpXWHd6QllaM09jeDZqZGlsd3NRdHhHRFp5TjhibmFP?=
 =?utf-8?B?VXBUaDNEMlduZzVWblZuR2EvTDRJdDN0MVpoYWhhV3ZkNDBndFN4YmZSVGVO?=
 =?utf-8?B?SHRhYVoyeHV6VFZIT0UzMG9WZnBuTkZ4TjlKSS9rSjVKamFUdEUweG83MXBO?=
 =?utf-8?B?VXZYV0o0R0xzMjFmTFZJajBIdXRtUTlQdVk4UGRuQUk2bnlzUzJVSzF3a3Z4?=
 =?utf-8?B?MzFWTlZrL2h5eTVBclVKYjhlZk16a05hUnBib0xCV3pBRGdnbFhoRnhYa0JQ?=
 =?utf-8?B?Y3FvWVZ0OVA0R2FjVlVWUnVZdWFSaXZZSWpUOUtFdzdidzZVWFlmeXFaeld0?=
 =?utf-8?B?SlAwN3BsbzRDNFZHdHorRXRDTXRXdnU4UHNYb1B0bDIzTzJEV2UwNTAvWFBz?=
 =?utf-8?B?VlVEMzdEczlYTlZ3SmhobHk5cWpEc0xyQUladlppU0M4T3NORFV6Q3ByYkpU?=
 =?utf-8?B?RUpDb0Vqa1ZGUXJOb1B6M3JFTEpmVHhqSHVkMSsvSzRKTCtrV3NyTXEzekVR?=
 =?utf-8?B?OWVvR09Ua3VUT0pURzF2d1YvWGVxR2VodTEwaWQ0VFU5b3VNL0FvbFFkZTlF?=
 =?utf-8?B?RFJmMzJ1VWowaTVBS1VpeFgvaS9FdHJOa1NlSEVFMzh0REpQdDBRdFRidnF3?=
 =?utf-8?B?UGs4dW01TkdzNzczbk5mbjZ5M2Fpc3dIM2pSV3hIS2lleGlsbTBJY1B2M3Fj?=
 =?utf-8?B?TVRZaGxhY2ZsTXZVRStRbmJHSEhiUnh5VmZTUkIwTHE0cGZObi9Ta2tVYmRY?=
 =?utf-8?B?Q3h0TnZMbE8ySEU2NmZMWG40eTVlSFVVY3FZVFgydWoyemtZTmpFRHZMUVRT?=
 =?utf-8?B?VFZQN01XaytTWkwrdFFLOFRnOFc4M0lLZ2NFdkUzTXA4QkF0UldpRXRYcXVF?=
 =?utf-8?B?YnkvS0IyTk5vVEg2UTh6Si9UNGRUR3VRT0s2cWZwMUFjcHVKOUdzWjliMm92?=
 =?utf-8?B?ckxBLzZYd0J0N1N0Y01kTUxHaGZzR2M3REk3bkIrc1ZwQTJSZWJRM3BMVCs4?=
 =?utf-8?B?VzJMeHFzT2RaUnBFL2RlMWZjNjhXMmVrYkdHRDdLRndLOEFQbDFWZHkySnda?=
 =?utf-8?B?djJZVitMSUVTK0kzMUJBNmtaNWFFQkF6RkNyTEhjdE5wMnpWSVRiUUduMkhv?=
 =?utf-8?B?akdRc3VEYVF5M1hYb2l4SWlJV05XemF4Qk9oZFZQR2xMd0lJMHR5OEFiNy82?=
 =?utf-8?B?UWRCc2dUdHJqL3BGU0VSL1RCY3pFR1Z3Z1ZHSWdHZk84em1IdnlSYjcxNytk?=
 =?utf-8?B?UjdDN3RNMFFlL3R0ZW50QmQ4UldXSEZtNTlrY3FqbFkzRGVNdEJ1bU9JWlhT?=
 =?utf-8?B?NzBXS1duSUt4Q1oyQXROZkUvaUcrQjNvNFo2cWJGVG1GbzVlM3hXUmJwN1JB?=
 =?utf-8?B?N3BJc2FrdSs3V3NCRStTNXRIN2hUZWx0S2tBTnJBeGRsaEo1S2drY1ZGYnNG?=
 =?utf-8?B?VEhlYlAyaW1vMW5teU42V1FUazhpcFBIN2NHcjVsR09nRGxlUUczWnRIRnB1?=
 =?utf-8?B?aUNrSW9pNFdrRjAyUmF6SlhuU2k1NzlQQS9ZdjA0NWV2dU1mT1d2U0VUbngy?=
 =?utf-8?B?cUoxK3E4UlREWFlMQzQyN1BTUFQyOVk2ak16eWFFVUFDM2lRaGsydmQwMTJO?=
 =?utf-8?B?NWZMYVQvc2J5SmRNSGExQTY4UGdjRW9xeTBuZHh4QXRpK3NZcjg2SS9yK2hO?=
 =?utf-8?B?Z053OVpyVVlJc3FkZ0xFdGFHT0N2MFB4VTRXQzJ6N1JxQjF1b2FpL3Y3VWoz?=
 =?utf-8?B?NUlIdjdQeExCbjVwNTZlK0VtWk1wamN1ZSsvVkxnelc5NHNhM28wNDVOYXNy?=
 =?utf-8?B?WDgvYVNqQ2xZamE0M1JESW9rZ3pXMmRGQURQc2QvRkVJOHRmU1B6eVNqQU5U?=
 =?utf-8?B?OEdhSy9rQVg1Y3Z3VXhkaG52V2h3TzIwS2wvbkttYVQzM2NkQnpiU2h3SFg4?=
 =?utf-8?Q?kRODq0ifffcuV1O8FhKlY+c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4CCCDCD05A1F414C88CD96360CC4D9AD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2440ec85-4a54-41ec-1689-08dde0078c3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2025 16:35:17.8369
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eF4Rdeo5r8Wj4XkWtyIzJXMmUyMcJ8b3eHinzMDG+aulGeDvoiaje9aU4Gkugk8nncAh1duWJY3YSXJ5GgywBpUTwU3nOvmG8/pL3UPaulo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4720
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA4LTIwIGF0IDA4OjMxIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEJ1dCBtYW4sIHRoZSBudW1iZXIgYW5kIGNvbXBsZXhpdHkgb2YgdGhlIGxvY2tz
IGlzIGdldHRpbmcgYSBiaXQgaGlnaCBhY3Jvc3MNCj4gPiB0aGUgd2hvbGUgc3RhY2suIEkgZG9u
J3QgaGF2ZSBhbnkgZWFzeSBpZGVhcy4NCj4gDQo+IEZXSVcsIEknbSBub3QgY29uY2VybmVkIGFi
b3V0IGJvdW5jaW5nIGNhY2hlbGluZXMsIEknbSBjb25jZXJuZWQgYWJvdXQgdGhlDQo+IGNvc3Qg
b2YgdGhlIFNFQU1DQUxMcy7CoCBUaGUgbGF0ZW5jeSBkdWUgdG8gYm91bmNpbmcgYSBjYWNoZSBs
aW5lIGR1ZSB0bw0KPiAiZmFsc2UiIGNvbnRlbnRpb24gaXMgcHJvYmFibHkgaW4gdGhlIG5vaXNl
IGNvbXBhcmVkIHRvIHdhaXRpbmcgdGhvdXNhbmRzIG9mDQo+IGN5Y2xlcyBmb3Igb3RoZXIgU0VB
TUNBTExzIHRvIGNvbXBsZXRlLg0KPiANCj4gVGhhdCdzIGFsc28gbXkgY29uY2VybiB3aXRoIHR5
aW5nIFBBTVQgbWFuYWdlbWVudCB0byBTLUVQVCBwb3B1bGF0aW9uLsKgIEUuZy4NCj4gaWYgYSB1
c2UgY2FzZSB0cmlnZ2VycyBhIGRlY2VudCBhbW91bnQgUy1FUFQgY2h1cm4sIHRoZW4gZHluYW1p
YyBQQU1UIHN1cHBvcnQNCj4gd2lsbCBleGFjZXJiYXRlIHRoZSBTLUVQVCBvdmVyaGVhZC4NCg0K
SSBjb25maXJtZWQgbWF0Y2hpbmcgdGhlIHBhZ2Ugc2l6ZSBpcyBjdXJyZW50bHkgcmVxdWlyZWQu
IEhhdmluZyBpdCB3b3JrIHdpdGgNCm1pc21hdGNoZWQgcGFnZSBzaXplcyB3YXMgY29uc2lkZXJl
ZCwgYnV0IGFzc2Vzc2VkIHRvIHJlcXVpcmUgbW9yZSBtZW1vcnkgdXNlLg0KQXMgaW4gbW9yZSBw
YWdlcyBuZWVkZWQgcGVyIDJNQiByZWdpb24sIG5vdCBqdXN0IG1vcmUgbWVtb3J5IHVzYWdlIGR1
ZSB0byB0aGUNCnByZS1hbGxvY2F0aW9uIG9mIGFsbCBtZW1vcnkuIFdlIGNhbiBkbyBpdCBpZiB3
ZSBwcmVmZXIgdGhlIHNpbXBsaWNpdHkgb3Zlcg0KbWVtb3J5IHVzYWdlLg0KDQo+IA0KPiBCdXQg
SUlVQywgdGhhdCdzIGEgbGltaXRhdGlvbiBvZiB0aGUgVERYLU1vZHVsZSBkZXNpZ24sIGkuZS4g
dGhlcmUncyBubyB3YXkgdG8NCj4gaGFuZCBpdCBhIHBvb2wgb2YgUEFNVCBwYWdlcyB0byBtYW5h
Z2UuwqAgQW5kIEkgc3VwcG9zZSBpZiBhIHVzZSBjYXNlIGlzDQo+IGNodXJuaW5nIFMtRVBULCB0
aGVuIGl0J3MgcHJvYmFibHkgZ29pbmcgdG8gYmUgc2FkIG5vIG1hdHRlciB3aGF0LsKgIFNvLCBh
cw0KPiBsb25nIGFzIHRoZSBLVk0gc2lkZSBvZiB0aGluZ3MgaXNuJ3QgY29tcGxldGVseSBhd2Z1
bCwgSSBjYW4gbGl2ZSB3aXRoIG9uLQ0KPiBkZW1hbmQgUEFNVCBtYW5hZ2VtZW50Lg0KPiANCj4g
QXMgZm9yIHRoZSBnbG9iYWwgbG9jaywgSSBkb24ndCByZWFsbHkgY2FyZSB3aGF0IHdlIGdvIHdp
dGggZm9yIGluaXRpYWwNCj4gc3VwcG9ydCwganVzdCBzbyBsb25nIGFzIHRoZXJlJ3MgY2xlYXIg
bGluZSBvZiBzaWdodCB0byBhbiBlbGVnYW50IHNvbHV0aW9uDQo+IF9pZl8gd2UgbmVlZCBzaGFy
ZCB0aGUgbG9jay4NCg0KT2ssIEknbGwgbGVhdmUgaXQgYW5kIHdlIGNhbiBsb29rIGF0IHdoZXRo
ZXIgdGhlIEtWTSBzaWRlIGlzIHNpbXBsZSBlbm91Z2guDQpUaGFua3MgZm9yIGNpcmNsaW5nIGJh
Y2suDQo=

