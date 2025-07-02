Return-Path: <kvm+bounces-51277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E6B8AF0FDB
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 11:24:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DFDBC189D5D1
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 09:24:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 023CA2472B6;
	Wed,  2 Jul 2025 09:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DTcBb83U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7509A246778;
	Wed,  2 Jul 2025 09:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751448170; cv=fail; b=SXlBrZfaEiECjJP0WlX2EiX5QJkzm+e2YNFjKhES/QrV2SArVkT2jF3CCqiD8gUyG5k70cOuNeKIkWB+HBUMqqSyPYU5kIUrGGVn7joa/kwN2RO5TDjBx1Ej9wK0VJ3PpLU3DO0uPcTIXtG2QZVK0Univq2+p/TreyqA9Z9RHmE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751448170; c=relaxed/simple;
	bh=q9LHw6OaigHAkZnsbEIMt0CmLZuoa2Uhh1Ts+DiiV3w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fFXmheFxAyV73zJs9w4Nhcb937UPNtURzEtLOquJmtsHb4vcdHpBtnnQzHKMP28hHMeAS86qZ3xsSvW8hqdHalmOdAjrGp+I2ABB3SOHtzfZo1FbHCwTEa6vmzXCSP9NWeL3/txyaHns7S1pZalFFBfqhWdVsuYcFFD1J+WTmek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DTcBb83U; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751448168; x=1782984168;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=q9LHw6OaigHAkZnsbEIMt0CmLZuoa2Uhh1Ts+DiiV3w=;
  b=DTcBb83UpOEX8I4iZpfQ0KEoKhqc4GnIW9ZpiV/+xIFw25byXrIIusfg
   zE8lbp6V19x3Sz1Iv4DNneQz2D9G7R37+bv4B6LBkjqJXvrHUp3tUNlba
   tdY7946LxjYc7VoYHQJXC+456lSGeU/KA8o6s2K+PnPGBFHu854fjCzes
   PUlN0dDd3A5KP/hkzV4WXJ8OVaA5FN06YNfvvCAllaZKP3ue2yk9ht6qo
   gfCUqiI11tfJkgftdIcXMegl2pSFnfUafX14DQmMXGxXnIym3KXfrP/sM
   9LfNQh8nZSApZqGDuFEWSRyolTwrwy50+b9IXOraV+7Y8eINIdcaGbL66
   w==;
X-CSE-ConnectionGUID: paPZTa4WRpqNQMmXN9lywQ==
X-CSE-MsgGUID: 20EN9BdPRNi5LjgVOGacPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="64428609"
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="64428609"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 02:22:47 -0700
X-CSE-ConnectionGUID: z4Eci0+OQbyl4XWjuby5NA==
X-CSE-MsgGUID: 6hOCusdkRhOvV07g8cXeXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="153796578"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 02:22:47 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 02:22:46 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 2 Jul 2025 02:22:46 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.79)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 02:22:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YIrThSe5CWwSAaFayWhtNE8qhaB5gaSAWFP+PXdNBkXWMIlaxfKzWyoCfkapDNqXlWS+iw87lDMKDZNnHbe0k65Hl+nv8AH83YKPVcmIGSfTIVd2P6fMAebIRnPkJs2u5rOOSnNIgh6ZLzHkrp6X9IyrE7I72HWZn9x8v67MoTqnKcfUKNPXsOVsRAwh7Qbyu4Egs2+GLPU38dCMPrHsr2dsmhZTUK3RxZ5991y2IC5V+n2ps/2eHcUZAn+uofzAq0e13Mbq5KGi42HBdZYVd+xJknznvS2jwEYGfVMC4WWKJmDH/Qna413WdeHu9Ri62qACpIvDaMKxN3o6TH0D0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q9LHw6OaigHAkZnsbEIMt0CmLZuoa2Uhh1Ts+DiiV3w=;
 b=HRLM7kKex+76mfFxbi8swkEWpJ3qwXAicWumn87ghtN84Rs3eSuYT2XFfbt1vPMOedEnHMKCMNQ29MDmc+N0MHbkaDh6n7rn2NDm1ruUwgNBofXfEESHNgW+vIzaXYRxmcULKaq+bjqsdCAQRfORBqbdcvqiPVgA2fYFTSYQ1GTjRy0/zF4RBZYAxWkGPNcLPLFdgh+CMEZNSVN2gExxHsgxkAmXueL+/kluJM6CKwsb4caFPCthXGxxjBPJJGMoMh+fp+22Ke7FTWEjaXb/SiS7E/+k8QwKL9CEhptLxnbjDgVQHt+ZU8Pz8TluaZj+rr90cLYaylJsGoyXpFwLHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA1PR11MB8280.namprd11.prod.outlook.com (2603:10b6:806:25d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 2 Jul
 2025 09:22:43 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8880.029; Wed, 2 Jul 2025
 09:22:43 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "sagis@google.com" <sagis@google.com>, "Chen, Farrah"
	<farrah.chen@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, "Williams,
 Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v3 6/6] KVM: TDX: Explicitly do WBINVD upon reboot
 notifier
Thread-Topic: [PATCH v3 6/6] KVM: TDX: Explicitly do WBINVD upon reboot
 notifier
Thread-Index: AQHb5ob2sxTequ6YNU2TEnElo1JBELQegCmAgAAYfwA=
Date: Wed, 2 Jul 2025 09:22:43 +0000
Message-ID: <1fee2f710a69ac678c17835519bed352e4224ff2.camel@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
	 <6cc612331718a8bdaae9ee7071b6a360d71f2ab8.1750934177.git.kai.huang@intel.com>
	 <aGTl09wV1Kt6b0Hz@intel.com>
In-Reply-To: <aGTl09wV1Kt6b0Hz@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA1PR11MB8280:EE_
x-ms-office365-filtering-correlation-id: d45a6104-4f3d-4dc9-7477-08ddb94a0004
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZlBLTkNLYmhFNTdZMW5ma2EvV0Zkb2Zjc2M3WFNEZGRLYS9NVGFqM09rYzFL?=
 =?utf-8?B?T0xOZHVBcjYwRUUzV2FsRlhDRitIT3BRNmExemQ1RnArZzZaWk92YkJWV3J3?=
 =?utf-8?B?aTU1ZjVIVklFQVV0YkM5NUFwM1RpcDlyWTFhcEdFT2dCTm5PVGJFOExNRllB?=
 =?utf-8?B?dTRLTjZROHNrMy94MlhadVpicVNydjJCbWI1dFlDSnlYa1pTOEJKaWFjbWlO?=
 =?utf-8?B?NWt2ay9ZNUhBeDdCUm9VeHpPejVjM25HenQ0Wmh4dGhxNHBVRU1BYTZpMG5S?=
 =?utf-8?B?NWQxcGxDVTZqU2ZJbU5VZ3E3UFN6SkVFUW9lU1VjSFJMTUtpZUhsR29DaUZ2?=
 =?utf-8?B?Yk82L3FtR0lXV01iVnJybUJTakw5Vkc0UGFvbFhIdWJkTUl3Nkhld1dObFNQ?=
 =?utf-8?B?M2EvRlBjY2tNdTAvaFJzbUNJZEtLcXNjMEUveDk2cG1GVVVxSUpob24zZVVF?=
 =?utf-8?B?MldxSHFBbTIwc20vWXRMeWtYb0htLy82RnJPelZkZHdhR3FYb1F6Y3Zxd3Ez?=
 =?utf-8?B?b1VEM3hXcVJhbGhSMHU0eGZLR0dNQWpEYlloVWoxM29wcUd5c0tsUjAvd29s?=
 =?utf-8?B?ZkF1WFVkZ3ZySS8xSXJWa1hQcUE1U3g4WGFTby9WOVFkVXMzbnlDTFZPMUdt?=
 =?utf-8?B?UkFWN0ZoVUk3OFhWdkp5U0RTcEgvOUpqU1Z2enZZR3JNNDhzcjgyNUN0R00z?=
 =?utf-8?B?Nm9SdERxNVdiM01CZFZieUFpWlJ1SXpYTmg1anpEM293Z2dGTTc4K3JNMUFG?=
 =?utf-8?B?VVJZWWJJa1JXMTdvanNMb0VtTTduVlIycFRVYmVhcFVuVXN4ZytSOHhteERi?=
 =?utf-8?B?SGxaZDkxVG92Uk1yejc1dytwSXlGWjR6YVhWWjc5TTNhZGI3NGxmS0xTejN1?=
 =?utf-8?B?QXg5bVVQUlJSd2hSR1M4bVg1NnZrMXZnSVZrZ3AwYzNOVWdFKzNVKzlJekRE?=
 =?utf-8?B?YnhkR2lueWZZeEpwWUFTckFpYXYyMWw1T1ArUVRFZThTMWR1Q1FnQ0xZOEEz?=
 =?utf-8?B?SEJFMG1TUlo5VzlmNzBtYzA2em8zMUtvTjlxb3p6ZmN3cTdCVWNhVWhJRytj?=
 =?utf-8?B?K0hpT1RxWHFoS1JySmlqMnRCZXU5NlpQNytBWGUzOUY4MFFXQk1tRmh5a2tP?=
 =?utf-8?B?dDBldnRlZkVlUVVoMFNDM0FORUpnOTlnYlRwQ2ZIQnZOdW5ndzQ4VTdTUG9w?=
 =?utf-8?B?NUVLTmNyT2ozWkNjand4SkJ1YW9oWW14d1pjTHZlOG5Bd0hiWkZIV0h4cHBE?=
 =?utf-8?B?S1pOWDZEM1o5b2ZzMUZxT2JYR01jcVlzK0UrUStSZ2syRStBVGIza0lxSy9K?=
 =?utf-8?B?RmxkOUFya1Bxd0FPTTQzeGxGSys0SHE2UkJObkFyQVZYNVZvS0dkbWFsU0V1?=
 =?utf-8?B?MHRKcXRqOE9RWnlHMGVxSkpYRXo0R2pGVE9CQ3F1UCtLRXhHS05IdStRWVNm?=
 =?utf-8?B?VndGZUZjZ3FlMEhzTDVhNzd2dzRTdm9FY1FTdVpyazR4V3dueVk2ZnU1SDFN?=
 =?utf-8?B?UVlZYlZHL2o2MGNsRTFGQkN6OTRMdDlrMEl5VEkzNThXNW5tSlBEZTc0eGdj?=
 =?utf-8?B?OS8rVTdDSEYwU2hwSkQ2bnN6MkkvbElKcXp2aWlhWTgxTUhCWUhneW1MTExM?=
 =?utf-8?B?N3FnTk0rWWpMMjZQS2N6YWVHMzNub3dhQ2M1WXBSMy8rWDY2c3hqYWVkVW0x?=
 =?utf-8?B?aWxKL1VMdks2Q2xjSFFiZm9aci9TZ01tbWRkNFdldnZxVDlnNTNpUEl2UVdv?=
 =?utf-8?B?c0dkSmROMm80VGdMWVp4NURkaEh2cFlEWXU1emVjMGU5b3RlaGhzWW8rREVK?=
 =?utf-8?B?bCs4SDBEZkNBVnZXa3pGbCtQTnNVR3FVY2FnVDl5VGtwVXR1MmhpN09tRkxZ?=
 =?utf-8?B?ZG91Y3c5VFZQMTlZNzVnN0FuN1duOTFDY2gwVzI1WnZvUWo3N0preklkTGFz?=
 =?utf-8?B?WVpOaEZ5cldZRlNLcmd2WFJjR2oxdVBic0YzeDJwbFNTVndmTkpBN2dIazk2?=
 =?utf-8?Q?Ga2m7Qn9IM0YsWz8D4SzzJmdonwMrY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eDNGQkQ4bFd4RldOemZOU1poVEJZaWFnc3BleWRmKzczVXRtVWlIb1JPcVlL?=
 =?utf-8?B?cnAvdG1MOXZIWHgwSWJ0SnRKVHhlSklnMGVrRk9paXBlNVUwaERIb1hLYm1n?=
 =?utf-8?B?RGJvcUpOcFVxS3VUTmVzR0U4NGJQZytPL0Jmdm5GTERkU3U1Q2NxNTNoS3dV?=
 =?utf-8?B?VDdYaHVhWXdnTEdHR1E5T0o1bHFrSmd4cnNLdWxQanNGNzIzZDlqNFRldEVY?=
 =?utf-8?B?MC9NcFhPbVZhNVhyTHNWUE5uNis5Z21DbWxDcGVFNFFjdGNRQ1pTUS9BMi92?=
 =?utf-8?B?dEJUOWY5REhpYlI5NkU4cmdkOFRtTVMwNm1yVU1YYzJaWDlVN3Rod01Ja2N3?=
 =?utf-8?B?NW1vZTZCWC9EaFczTDdJRmUrOUREU3RiU001Ulg2ZmUyMmhuNkdrejdxelZ0?=
 =?utf-8?B?aEZySmg3cE03K1hzU0IxY3hONjNxdFEwT2M3aC9YTmtJa1VWUENhdGZOYWxl?=
 =?utf-8?B?eDU5ZUdGUVRIM0pGRHA3ZUd3VGJFSUNUTTh3QTE5NHM0WkUvSTFPVEZ3Z2cy?=
 =?utf-8?B?aEhUVm1BT3dNRUJIbmJGbGQrLzdQOEVBSkFYTjZnc0JoT0dyU0xiQlFGZWF4?=
 =?utf-8?B?U2ROdzRaKzl6THhDV0J1MU5Wa0VGVlRLNmxEeUNYSVJoNGpERWJoODN0Mnc0?=
 =?utf-8?B?ZjU4dDBNclczeklDQkRRTS8vR1lwcllPU3RQK2NVbkRJM0VFRXYveXZZVGpH?=
 =?utf-8?B?ZFdCN3hsNVhXazNTaWw2L1dXZ1RzcFZQVW9BRVFyZnBGdjZKVDRrSmk1WVVl?=
 =?utf-8?B?cEtnblNieVR3bEp5MUkxZUpqNEt0b3dXWGtOdkxiN3FIblE0c1BEeXZ3Y0to?=
 =?utf-8?B?TUJGVmxtSzVMVTFGSUpJbzVDdFVLajF0UU04aVozVGYxZWd1Q1NOT2hVbU1y?=
 =?utf-8?B?Q2xray8zWnJGZWE1SFRpUGhSdk9IemN6MFFFMVdUL0RCbkU1Z3YvUGFxS3dJ?=
 =?utf-8?B?cmpHUG1ZbzhMMzZWbW1SQmhMRURTZ0J6RkgrelYwdzY3U3I1dW5kOE0vNDJz?=
 =?utf-8?B?bGpybzlVdEM1aE9SR0JoQ2I2MzJMV1RHSmFBc050MUNrOTA3dmhZSCtEaVBl?=
 =?utf-8?B?Y2UwQXFWOW93d2JTMUVVZHJ3TWR1bzlpRkE1dGtLZEMwZGQ5clBOeCs4Sk1m?=
 =?utf-8?B?ZjhSSzN6SGZCaXoxc1ByWndYamJRYWdMc0IvSk9EclluVG94MlhmWnE3Zmxv?=
 =?utf-8?B?QnkzSnRkQktoekpzNFd1NDYxUDVjdy9ob250bWQ4SlNXdFNMWGl5M0YvdU42?=
 =?utf-8?B?MlRTVzhKTnJYNmlBckRVcGw1VmtCUytEWWpQNUFYb2QzS1FBVWErOXNmd25h?=
 =?utf-8?B?Yks1SjMxamlVR1hsaVhtOG1PblIyNkZ5MFJ5RHQ3UkZNYlg4dDB6dWttQkVl?=
 =?utf-8?B?RlVLWThhV3M3Rk1jUUx2OG5ORDhMQ2lsVVhKTGNHNVd4dnpUQXpudXRiVTF0?=
 =?utf-8?B?Y09XSTVLanR5dWVnaW5sMEViQ2g4QUhON1RuSWlXWGowdnBJMTd2ZjZQYU5U?=
 =?utf-8?B?c0xaNWpkQ1ZHNTdHa2c3dUQ3cmhMRHNmVlFKNVNzd3hQMjYxdVQvSjI2NzdV?=
 =?utf-8?B?ZE9wTnliWHN4THNNelNHT0JENmxvdlFKaENsWmxVbTFuUHRJbmg4NDBnR0F6?=
 =?utf-8?B?Mk1yZzVJM2ZXdDVJTGRHb29vSjAxeDN0R2FxaStqQnBQOEdtNGZXcFVyOGJn?=
 =?utf-8?B?TWZqMVVNaUpDMmprUTcyaTlGRUpyL3l2S1UwYWZYekZsZDkwN0kyMm9Vd1pI?=
 =?utf-8?B?ZEU1ZDZuOTJ6djMyTzYzdm15bUlHM2h4Q0ZPajFSRGNlYlNqZ3pLZmhpL0wx?=
 =?utf-8?B?UU5uM3NQWlhWQll0OTcraDRLNGJwejFicWhGbyttQ2JuYVdKNTJIc0RFUFBT?=
 =?utf-8?B?dmZUUkd6MlhiK0NIaDFGNFU1anQ2VUp3NXBwdFl0RDdCb2Z3U25HdVZ0YXlN?=
 =?utf-8?B?Ymw0Ull3WkcyMGw1RGVnS2dhK00ybEdHTWw5VXRaRE9rc3pod2NKVmQ2M0l3?=
 =?utf-8?B?QlFSMzZDSC93NUhEREhkK0hhRzZxV2cydysvOHNQL2laY24rc3d5Y0lXWFlP?=
 =?utf-8?B?YS90TXU2eFBuVUoyVS9sN25vbUpKN2hHUTAyVXpoMkdscmx5ekNTL1VOVlVW?=
 =?utf-8?Q?8AUa95gT0na4/WBnMtN24cA8L?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7A9DAF59D687284CAFCED551EFE4AD9B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d45a6104-4f3d-4dc9-7477-08ddb94a0004
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2025 09:22:43.5312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N2wkI8PR5epu8tWJsZRkw/5Ho3t8vhGRWaIhS4nBivzDsjw+P5gtbdIYnW1RJebuPOZmg7c5OQhYq0IZlfxvjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8280
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA3LTAyIGF0IDE1OjU0ICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gPiAt
LS0gYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gPiArKysgYi9hcmNoL3g4Ni92aXJ0
L3ZteC90ZHgvdGR4LmMNCj4gPiBAQCAtMTg3MCwzICsxODcwLDEyIEBAIHU2NCB0ZGhfcGh5bWVt
X3BhZ2Vfd2JpbnZkX2hraWQodTY0IGhraWQsIHN0cnVjdCBwYWdlICpwYWdlKQ0KPiA+IAlyZXR1
cm4gc2VhbWNhbGwoVERIX1BIWU1FTV9QQUdFX1dCSU5WRCwgJmFyZ3MpOw0KPiA+IH0NCj4gPiBF
WFBPUlRfU1lNQk9MX0dQTCh0ZGhfcGh5bWVtX3BhZ2Vfd2JpbnZkX2hraWQpOw0KPiA+ICsNCj4g
PiArdm9pZCB0ZHhfY3B1X2ZsdXNoX2NhY2hlKHZvaWQpDQo+ID4gK3sNCj4gPiArCWxvY2tkZXBf
YXNzZXJ0X3ByZWVtcHRpb25fZGlzYWJsZWQoKTsNCj4gPiArDQo+ID4gKwl3YmludmQoKTsNCj4g
DQo+IFNob3VsZG4ndCB5b3UgY2hlY2sgdGhlIHBlci1DUFUgdmFyaWFibGUgZmlyc3Q/IHNvIHRo
YXQgV0JJTlZEIGNhbiBiZQ0KPiBza2lwcGVkIGlmIHRoZXJlIGlzIG5vdGhpbmcgaW5jb2hlcmVu
dC4NCg0KSXQgaXMgYXNzdW1lZCB0aGUgY2FsbGVyIG9mIHRoaXMgZnVuY3Rpb24ga25vd3MgdGhh
dCBjYWNoZSBuZWVkcyB0byBiZQ0KZmx1c2hlZC4gIEJ1dCBJIGNhbiBkbyB0aGUgYWRkaXRpb25h
bCBjaGVjayBhbmQgc2tpcCB0aGUgd2JpbnZkKCkuDQoNCj4gDQo+IEFuZCByZWJvb3Qgbm90aWZp
ZXIgbG9va3MgdGhlIHdyb25nIHBsYWNlIGZvciBXQklOVkQuIEJlY2F1c2UgU0VBTUNBTExzDQo+
IChzZWUgYmVsb3cpIGNhbGxlZCBhZnRlciB0aGUgcmVib290IG5vdGlmaWVyIHdpbGwgc2V0IHRo
ZSBwZXItQ1BVIHZhcmlhYmxlDQo+IGFnYWluLiBTbyBpbiBzb21lIGNhc2VzLCB0aGlzIHBhdGNo
IHdpbGwgcmVzdWx0IGluIGFuICpleHRyYSogV0JJTlZEDQo+IGluc3RlYWQgb2YgbW92aW5nIFdC
SU5WRCB0byBhbiBlYXJsaWVyIHN0YWdlLg0KDQpJIGFncmVlLiAgTWUgYW5kIFJpY2sgaGFkIHNv
bWUgZGlzY3Vzc2lvbiBhcm91bmQgaGVyZSBhbmQgdGhpcyBwYXRjaCBjYW4NCnN0aWxsIGJyaW5n
IG9wdGltaXphdGlvbiAiaW4gbW9zdCBjYXNlcyIsIGkuZS4sIHRoZSByZWFsIHVzZXIgb2Yga2V4
ZWMNCm5vcm1hbGx5IHdpbGwganVzdCBkbyB0aGUga2V4ZWMgd2hlbiBubyBURCBpcyBydW5uaW5n
Lg0KDQpUbyBtYWtlIGl0IGNvbXBsZXRlIHdlIHNob3VsZCBtYW51YWxseSBraWxsIGFsbCBURHMg
dXBvbiByZWJvb3Rpbmcgbm90aWZpZXIuDQoNCkkgc2hvdWxkIGNhbGwgdGhhdCBvdXQgaW4gdGhl
IGNoYW5nZWxvZyB0aG91Z2guDQoNCj4gDQo+IGtlcm5lbF9rZXhlYygpDQo+IMKgwqAtPmtlcm5l
bF9yZXN0YXJ0X3ByZXBhcmUoKQ0KPiDCoMKgwqDCoC0+YmxvY2tpbmdfbm90aWZpZXJfY2FsbF9j
aGFpbigpIC8vIHJlYm9vdCBub3RpZmllcg0KPiDCoMKgLT5zeXNjb3JlX3NodXRkb3duKCkNCj4g
wqDCoMKgwqAtPiAuLi4NCj4gwqDCoMKgwqDCoMKgLT50ZHhfZGlzYWJsZV92aXJ0dWFsaXphdGlv
bl9jcHUoKQ0KPiDCoMKgwqDCoMKgwqDCoMKgLT50ZHhfZmx1c2hfdnAoKQ0KPiANCj4gPiArCXRo
aXNfY3B1X3dyaXRlKGNhY2hlX3N0YXRlX2luY29oZXJlbnQsIGZhbHNlKTsNCj4gPiArfQ0KPiA+
ICtFWFBPUlRfU1lNQk9MX0dQTCh0ZHhfY3B1X2ZsdXNoX2NhY2hlKTsNCj4gDQo+IEkgd29uZGVy
IHdoeSB3ZSBkb24ndCBzaW1wbHkgcGVyZm9ybSBXQklOVkQgaW4NCj4gdnRfZGlzYWJsZV92aXJ0
dWFsaXphdGlvbl9jcHUoKSBhZnRlciBWTVhPRkYsIGkuZS4sDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
YXJjaC94ODYva3ZtL3ZteC9tYWluLmMgYi9hcmNoL3g4Ni9rdm0vdm14L21haW4uYw0KPiBpbmRl
eCBkMWUwMmU1NjdiNTcuLjFhZDNjMjhiOGVmZiAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3Zt
L3ZteC9tYWluLmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC9tYWluLmMNCj4gQEAgLTE5LDYg
KzE5LDggQEAgc3RhdGljIHZvaWQgdnRfZGlzYWJsZV92aXJ0dWFsaXphdGlvbl9jcHUodm9pZCkN
Cj4gCWlmIChlbmFibGVfdGR4KQ0KPiAJCXRkeF9kaXNhYmxlX3ZpcnR1YWxpemF0aW9uX2NwdSgp
Ow0KPiAJdm14X2Rpc2FibGVfdmlydHVhbGl6YXRpb25fY3B1KCk7DQo+ICsJLyogRXhwbGFpbiB3
aHkgV0JJTlZEIGlzIG5lZWRlZCAqLw0KPiArCWlmIChlbmFibGVfdGR4KQ0KPiArCQl3YmludmQo
KTsNCj4gwqB9DQo+IA0KPiDCoHN0YXRpYyBfX2luaXQgaW50IHZ0X2hhcmR3YXJlX3NldHVwKHZv
aWQpDQo+IA0KPiBJdCBjYW4gc29sdmUgdGhlIGNhY2hlIGxpbmUgYWxpYXNpbmcgcHJvYmxlbSBh
bmQgaXMgbXVjaCBzaW1wbGVyIHRoYW4NCj4gcGF0Y2hlcyAxLTIgYW5kIDYuDQoNClRoaXMgc291
bmRzIHByb21pc2luZywgYnV0IHRoZSBlbWVyZ2VuY3kgdmlydHVhbGl6YXRpb24gcGFydCBuZWVk
cyBzaW1pbGFyDQpoYW5kbGluZyB0b28uDQoNClByZXZpb3VzbHkgdGhlIFZNWE9GRiBpbiB0aGUg
ZW1lcmdlbmN5IHZpcnR1YWxpemF0aW9uIHdhcyBleHBsaWNpdGx5IGRvbmUgaW4NCnRoZSBjb3Jl
IGtlcm5lbCwgc28gZm9yIHRoaXMgYXBwcm9hY2ggd2UgaGF2ZSB0byBzY2F0dGVyIGNoZWNrcyBm
b3INCmRpZmZlcmVudCB2ZW5kb3JzIGF0IGRpZmZlcmVudCBwbGFjZXMuICBUaGlzIHdhc24ndCBu
aWNlLg0KDQpOb3cgdGhlIGVtZXJnZW5jeSB2aXJ0dWFsaXphdGlvbiBkaXNhYmxlIGl0c2VsZiBp
cyBpbXBsZW1lbnRlZCBpbiBLVk0gdG9vDQoodGhlIGNvcmUga2VybmVsIG9ubHkgY2FsbHMgYSBm
dW5jdGlvbiBwb2ludGVyKSwgc28gSSBfdGhpbmtfIHRoZSBzaXR1YXRpb24NCmlzIGJldHRlciBu
b3csIGlmIHdlIGRvIHdiaW52ZCgpIGluIFZNWCBkaXNhYmxpbmcgcGF0aC4NCg0KSXQgd2lsbCBn
ZXQgbW9yZSBjb21wbGljYXRlZCB3aGVuIG90aGVyIGtlcm5lbCBjb21wb25lbnRzIChWVC1kKSBu
ZWVkIHRvDQppbnZva2UgU0VBTUNBTEwsIGJ1dCBhdCB0aGF0IHRpbWUgVk1YIGNvZGUgc2hvdWxk
IGhhdmUgYmVlbiBtb3ZlZCB0byBjb3JlDQprZXJuZWwsIHNvIGRvaW5nIFdCSU5WRCBhZnRlciBW
TVhPRkYgc291bmRzIGZpbmUgdG9vLg0KDQpPbmUgY29uY2VybiBpcyB0aGlzIGFwcHJvYWNoIGRv
ZXNuJ3QgcGxheSBxdWl0ZSBuaWNlIHdpdGggYmVsb3cgcGF0dGVybjoNCg0KCWNwdV9lbmFibGVf
dmlydHVhbGl6YXRpb24oKTsNCglTRUFNQ0FMTCgpOw0KCWNwdV9kaXNhYmxlX3ZpcnR1YWxpemF0
aW9uKCk7DQoNCmJ1dCBob3BlZnVsbHkgVlQtZCBjb2RlIGRvZXNuJ3QgbmVlZCB0byBkbyBsaWtl
IHRoaXMuDQoNClRoZSBwZXJjcHUgYm9vbGVhbiBhcHByb2FjaCBkb2VzIGhhdmUgYW5vdGhlciBh
ZHZhbnRhZ2UgKGFsdGhvdWdoIGl0J3MgbW9yZQ0KbGlrZSB0aGVvcmV0aWNhbCBpc3N1ZSksIHRo
YXQgaXQgY291bGQgYmUgYWxzbyB1c2VkIHRvIGNvdmVyIG90aGVyIGNhc2VzDQp0aGF0IGNvdWxk
IGFsc28gbGVhZCB0byBjYWNoZSBiZWluZyBpbiBpbmNvaGVyZW50Og0KDQpodHRwczovL2xvcmUu
a2VybmVsLm9yZy9sa21sL2ViMmUzYjAyLWNmNWUtNDg0OC04ZjFkLTlmM2FmOGY5Yzk2YkBpbnRl
bC5jb20vDQoNCkknbGwgdGhpbmsgbW9yZSBvbiB0aGlzLiAgSSB3aWxsIGJlIG91dCBmb3IgdGhl
IHJlc3Qgb2YgdGhlIHdlZWsgc28gSSB3aWxsDQpjb21lIGJhY2sgbmV4dCB3ZWVrLg0KDQoNCg0K
DQoNCg==

