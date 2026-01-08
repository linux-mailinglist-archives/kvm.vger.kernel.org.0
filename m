Return-Path: <kvm+bounces-67464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id A342BD06067
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 21:21:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D559A3010D70
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 20:21:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CE9732E733;
	Thu,  8 Jan 2026 20:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nb0hDW1W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695F2318ED9;
	Thu,  8 Jan 2026 20:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767903668; cv=fail; b=GYVCvEXhOcxL1Sb773qkd8HRi+XaHRzWc7GfX0aBgSkqx57ItSMtrTgWc+ndBNFktX9BlS7DOOAjqISQGo7TEnz21t23/EIKjEUObIkBSteaEF37rpJGadc1F5/1mckpoAQxr8zr5UP8sZD6kATnJ8ljZEK1CER0EwKG2HNYWo4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767903668; c=relaxed/simple;
	bh=eJiOMY9igpdSm0lCf6nsQdUDKdQlGK3KVupzjg35HzU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=k78T6RzcjDY2IMT5rj4rL37yoWtvGSnStb+wCNmppWZVK4D/R9/ELWYAGPVBLlPDMS6+oDxvnk7nLJTxv84QXKxV4sQ/IPYj9xmizzPKyftuJP9ilIz37QATw8RvDtNMZNQJOjhDFGQNInYZpByItoQYCN1rspt8AZLxV/VKkp0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nb0hDW1W; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767903666; x=1799439666;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=eJiOMY9igpdSm0lCf6nsQdUDKdQlGK3KVupzjg35HzU=;
  b=nb0hDW1WKos3nElQt2I0zi0kF6SoUfTnratssjQ8izNbNiIM7ukxde5b
   pvib8z+D1qHSm5v1RVvyiQOwVgaTC6PUekmZaql4eSl0uFpV7c1aUVzYK
   yV7+rIrIJS9DhdIM+fjEADkeFhx6rq0jpguHYkDbMpmGSaUcIdUAfDW0j
   3LQKeVLAiePtFJohqp6HUp9v4j3Bx38GyGM0OEzHTqBBnzuqMO4KZPOZX
   ZFN/RAdmVh7/ssO7Oh8cKfNX+NLxM1UCYwpP5n+hFMAjRbp6DPJJ3TclT
   DyypLW8JW51FJ3ep32WQ/XcIiFux7iw6XYDr6nEjEH1vs1GCVmwOiHI4d
   w==;
X-CSE-ConnectionGUID: HAdfX85AR/O29AdHo5lwqQ==
X-CSE-MsgGUID: UWwBtXvRSo27USl+aMy89A==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="56847776"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="56847776"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 12:21:05 -0800
X-CSE-ConnectionGUID: 2tvUdSAVQzGvndNnR0NU9w==
X-CSE-MsgGUID: SMATZYdsTUGvI8IrRyzmSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="203573978"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 12:21:05 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Jan 2026 12:21:05 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 8 Jan 2026 12:21:05 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.10) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Jan 2026 12:21:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CLthHOQmnXXUI5zywX6vpqe82PGNMxq/A5bV6pQMTkBcXfkwQC3TEN+KMG2nPAwbvUeOzmUfnM2x7RhMpmtGCwcL43yPolDKtSXZFgw01KRDWCoAn/HFZ2Qrt0SYNQwQ2L/PhVAWfp3Qdo4Wto/UBdsKmQy+WJDRIhH4RKhQKUkF6/CP04QNGqkPnGl1tqWObyHno/KM9hFKx0DiBxDxXsA5nXzjlhu0C1GMjlQK9jOZ8DOiK+gAmOvEWPsFRA/GEIqIi6/6kFISr571V7MnEKuQa+vyZx38Wue1SCa0iC+QZPn7MN8kqSkRvzVjqpsYx2hrVf3rJDlGo6S03HaFBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eJiOMY9igpdSm0lCf6nsQdUDKdQlGK3KVupzjg35HzU=;
 b=DQyVuY6m2yuhIO05iIIv4WYEriUB548zBnp4r82iAeGAWJJ0Ccn8K7lf2PZad6CmDLRCvirVIM4/mO81pczuUghEgTHAZALp2Ikze0+Gl5eGc+M72NImGp3lt0rky9ehCjGmu5CqCapMZqW6yP7Nd92iN5VTbvYJjWuaZKHdAgeday6Nf8nR8xWuL1D+TU+Kt3AKAtCQurVOvZPtcbzsT3xuqgyeunrBZW/p9DAWLQjqKvcKPue3sNUBXc1/qIzn8AYuYkH+hQ7FYkVWb3H64TsXofvQ6644v6kDvums2oYRPRmKGA9eVkTIzW0WsHuKRt8U2UM8Yjek53dg/035cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB7721.namprd11.prod.outlook.com (2603:10b6:610:12b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Thu, 8 Jan
 2026 20:20:55 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 20:20:55 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "kas@kernel.org"
	<kas@kernel.org>
CC: "Gao, Chao" <chao.gao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: [PATCH 2/2] x86/virt/tdx: Print TDX module version during init
Thread-Topic: [PATCH 2/2] x86/virt/tdx: Print TDX module version during init
Thread-Index: AQHcgDYy/ai2v5cOskehiugVnnJnEbVIGL+AgACDLACAABw8AA==
Date: Thu, 8 Jan 2026 20:20:54 +0000
Message-ID: <aaeda226c7e2d0d81e5b0f767475330e6d9d8bce.camel@intel.com>
References: <20260107-tdx_print_module_version-v1-0-822baa56762d@intel.com>
	 <20260107-tdx_print_module_version-v1-2-822baa56762d@intel.com>
	 <orjok4cskwinwuuqkyovqu7tkfygdkiqlxc2sbdvi2jicpygi4@dgg76ojxkhak>
	 <261b253ff5bcf593adbddbc34f7a5b4befaa4c21.camel@intel.com>
In-Reply-To: <261b253ff5bcf593adbddbc34f7a5b4befaa4c21.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB7721:EE_
x-ms-office365-filtering-correlation-id: eaa6b8e3-7a33-4b61-6b88-08de4ef36d43
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?RGd0bHdPK0VtbGJEbFBxVk9ORUlTRnVCU0Y1Y0V3L2RnVFRpMDBpMzR6aEpZ?=
 =?utf-8?B?aVdUb1o4WStaci9FZTRBUTk2dGdHRlJKUmRWVHVGVHVma0svMUVCaVRHM3pZ?=
 =?utf-8?B?KzRNTUlrR0JWdkR6aE9JaytzRnVvQ3RKNFk0Rm9DQzhobXI1OGpBSk9NdnJ5?=
 =?utf-8?B?bDh4eC9WWXowcjdzVng2aVg1TU1sckxNWnFSRXZ3OFpGRE01Y1dTT0pKdHU2?=
 =?utf-8?B?MVBsYVVmeWd5YWdONno5bWkzRXE2cHdzcCs0Z3pqZ2ZuS1h0d1lWb0I2bUQ0?=
 =?utf-8?B?RG9tVTl1ZzhRMXIvUVVXMDJkR0ppZHFob04vbktXSjZDdzVtWlo3ZU13Wk0r?=
 =?utf-8?B?QnZFZGRNL2FFT1k0TUt5b0hiQ2VReGZOSUhsK3hlSjRmOG51bnFHbUd4SmFk?=
 =?utf-8?B?Q04wblk4UCsyQUVyQURqcnZlYmNkRFRDQ041T2dqTE9ObkNrcllVZW1OWGZD?=
 =?utf-8?B?UlhmRS8zd0RCdExRSDJoZzZWc2RSTU0rWXF4UnhzYjQ4R1NTU0pWQ2VhYmQz?=
 =?utf-8?B?TGdLMllMM1ZVSCtDK3kya3A2TTRhSlFFaWZrelREZ2xXYWxoNGU4Zk1lQVN1?=
 =?utf-8?B?UXp5L3dUWmFvZDRUZ21BZ0t3K3RYUnkwVVFvS2tmWXVlQUJ4NGZ2TzEyRFFT?=
 =?utf-8?B?Rk5SMm4xRGVJNlZEVkJYQnV5K3BpQzFnNDdXT2ozeHZKOFUyN0xGTXh6OUhQ?=
 =?utf-8?B?YzUvZWJRZE9jMWNKaDJZekgrNkRlWTd3ejh3dHJ4M0ppaU1tYnB0QmtCRWps?=
 =?utf-8?B?bjRaVERnYktBa0ZLWFQ0NmZvVXNvS1F2WS82NWFNejZtaVRWaC9sa3Y5bkM1?=
 =?utf-8?B?bTlFbERjTmtxZncyR1RvL0hZRmtUNE1iMjR5elNxZ2FWWjZZbzBGMzVqNmk3?=
 =?utf-8?B?enZIY2t0Mi9kdHBFcTY2SjQvaGVjV21VbXVidGlSa0JXN2hTbDYrRnhuR0NT?=
 =?utf-8?B?TzhhR1R1a0p6Z2JGTGxoQStEeWtYQ3FjSlFCM3kzbGdoTGMvUXFmMkZ6cllK?=
 =?utf-8?B?bFVmR0tUWDFMRW12SVdvTUJyV2E1MC9nT0RCbTZQdGJkUWlBaWVlejI1dFF3?=
 =?utf-8?B?MTNNRTdzaCthRHU0UmZ2aEwvUlVBd1Y0ZGlnRXY5d3VaM1dpTHQ2L2h3QlBP?=
 =?utf-8?B?RWxFTUU1SENFSjhHK2x1MWVZd0N4TjlWMHppK3BHemg4dkhTTSt0WTZ1ckZt?=
 =?utf-8?B?b1gwY0FNczhXcWJ0aXNPQi9ETVU1WHNZUUo4RFFUVFZTMWF4MWZhRGpHb3gw?=
 =?utf-8?B?WDVFNFdLcGJvdGxWdDloOVNjREttak0vUmk5MUs3M0FoZ3Q2cnY4MHZuYzBp?=
 =?utf-8?B?ODg3SUdFeHQvd3hKamlUZW1NWFhST1J5L0daOHFGOUlsSkNPSDV4VUZSenhU?=
 =?utf-8?B?bUJITGExSkFlWEsrK3dqZmgvQmZQVzE5TEpwUUVIYTVHcVNIMlVOMWNTRWJw?=
 =?utf-8?B?U0Z5aDZqeDBRK25JeDBoeHpmcjJaZDZzUzNOT3hpbTZBV2hOdWh4R2hBR1Fy?=
 =?utf-8?B?L3VkNk4vRkVTcTR4MjEwNWFsLzQwTFVMYk9idm5rUWJnaW01RmpCcGx1b2tQ?=
 =?utf-8?B?MnUyZ3RoejdqK3Z3UVVYYlRWQ0xJN3REYWxucUR4cWZIay9Tdzk2Nm1IdzE3?=
 =?utf-8?B?d0x2RDNsMVJQT2VlRXArMzR5SVFBc3FZWFd6dDlBNG1FTFBBM1VNcWV3bEU3?=
 =?utf-8?B?dFRGTTA2YTFybVo4Q3ZQQnd6cUJKZFN1b2Y0UEdkVmRSRGZiRTU3YTBNMGoy?=
 =?utf-8?B?bDYwUm5acnhML0ZOZWdHZUJtNTRBMjFacDRoWXJvU2kyaStVaW1aN01mS0ta?=
 =?utf-8?B?eEtBbVRNZENiWWJ3UWdQM3h4K1VpMWx4RUloWGJ2TXN2dkRHMTM5RXc0UjBu?=
 =?utf-8?B?dTFsRVAyTGU5ODFhakRmLzlnSjJrcFM2SVVjSmg3eFNrTkRoUHNld1JyNWhu?=
 =?utf-8?B?M2loQzIyRDJuL3hhc0JIdURZbDJZNC9hdUJldndRRVAxZWxLZFo4UC84aVJO?=
 =?utf-8?B?dDlKblM3c0M2NjdNTEVNMlI1WkVCM2hUditha3l3SkhINVhVTXdJN3J3NFY2?=
 =?utf-8?Q?MAUtM4?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M1dNV2xrR3MzRjN5b29XVE03eFF3cEg0VllGUVlIRHR2Nk41R3FHM29RWjFW?=
 =?utf-8?B?QmtCbTJmZERDTXJhZTY4M2ZHbDBveXg0dUhTMW1PN0x0RTJVK3ZWOGtZSEFy?=
 =?utf-8?B?bEtIcHE3QWR5MUYyVXNiNVE0WGdSNlZEcUhUOXo5V2VWVXJkZURjeUI0RFVZ?=
 =?utf-8?B?NnNSMHBmS3NnU0JZamdZOGJMK2g3MEVpLzE2YnlLSTB2bTB6d3BpVjJWWFk0?=
 =?utf-8?B?eFQ2Vit2VVNydmwxS3ZHZGcxVlVlbEJMaXRvNDhNSzRGSXpDQTBKK2RzY1Y5?=
 =?utf-8?B?OUtGMVkyRnFwdk1KL3VKL2JkZGZwaTBGTzNCTzZQU0RYQVFxM1BvU2hXVXpw?=
 =?utf-8?B?NE1pem5DUjJ4bWs2UFFjdC9jRk00QklKK3NrQ1FqRVBzSHNqVjZsdndKVHI1?=
 =?utf-8?B?MzRDakh5cGRtblJBYmdXQlNMNXBqei9FS3BPVUJnMkZnbHNsalBsdnFYUG0x?=
 =?utf-8?B?M2xVR3Rob3VIRXFBc25KU0xoOWN6K2lmanNDZDVTTThUNThKQ3o2TkFmalph?=
 =?utf-8?B?djI5L0l1ZHF4S3NlTTExWnF4ZDY0VEhXS3pHcmtYcEJ2NDdXb2JTcXNNcU9i?=
 =?utf-8?B?d1p5RGhDcEVCUVVOVzFTQXkrY0piTTJUbERyR0NNOHdFd0NvR0Iwd1EvTU00?=
 =?utf-8?B?dWpFekJtQkhGaWlkRFNPYy9LMEhKdldsNGxBMzNLVUptNlkvaC83U1FiektR?=
 =?utf-8?B?NDAyRWV5dFZhWnZ6NzhwRi8wYVh1YWE3bHU4b1JwcEt5a2plellHYVo0UTI1?=
 =?utf-8?B?OTBkcDVQTVhWaVJHaFVOMHdxZnFpeTNITDJWZXBLcnM2c0NVaXN5Tk56aWRH?=
 =?utf-8?B?VVVGTExHemUrZVQyeVBmN1Jvdm9YOE9Vb2lRZ0lBK0N1V0hyYUFZK0ZOUit2?=
 =?utf-8?B?Z3kwT3ZMSTlLYVhRNUo2YTFFNnpwdklpTVZtZXROZDRZNTJycHZ1WEFiUDdI?=
 =?utf-8?B?VWM5RmJTTnA5VzdISVFnenFITDNnSlhRWGFISmF5RklNWm80d1d0RGtHZm9K?=
 =?utf-8?B?dmJqNE1pUHZjdnlZS1pBUWdhRzBFaTlCVytvaWRSZU5XZGFQUjJ6aEg2a203?=
 =?utf-8?B?MlQ5b0lpa2FSR2NjSmRNd0tySDZZd3JyZ1BUb0s5bjI2V2YzSWVLWFhjempw?=
 =?utf-8?B?NDBIdTZ6WEltcjByMGVWcDhIMEE0Znd2blZhZk1NWlpPeGIwdEpWM3AwNVp6?=
 =?utf-8?B?ZFI5VmNRR2theUtKcXhiTGR2TmtXRUhScmh3SVAyaG9vUHRtZE5ENlFybUhD?=
 =?utf-8?B?OFROSFg4bWNJU2tvWUZyZmJVNTUwUnJpRXJUUWJ6bkwrRVJRNjd4OG03V01x?=
 =?utf-8?B?eHZKZ0ZDVWk2d3lrcHlDdTR2OEFrWmNqK3VQQmF1eFhRK1BSSjRrWDAydlNU?=
 =?utf-8?B?dFhBcVd1Nm01TUcxUDE0bXBmYkJ3b21xZlVzcWVsRXV6UVFkSDNEdFFpeXhh?=
 =?utf-8?B?RGxnYnIzZ2JjUnBLQi9RREpEanBWVjRybnBqZnRkMGMvY0FmZ01mVStWZ20y?=
 =?utf-8?B?QjN4WTRUejB1bkZIaS9tU3k5c1dYN1hLek9OaHBuT3RJTTNIU080VDc5V0Rp?=
 =?utf-8?B?VTFRNjVIQzNxWTZZSW84cGZYVWNQMFFjSC9qQlVmM1IzcnNtUVdmaWhuTDcw?=
 =?utf-8?B?dHBVOVY4aEhNQXFzOVVqczhqNnR2c0dUbXJ6UStOWUlOZGZHSm02aFRjaGhB?=
 =?utf-8?B?NHFTVndINFBJbHBwS0FpQmVYTFYxVHdUcVFialp2QTNpOGZ5ampPMEtGTzdX?=
 =?utf-8?B?djZJQU1IeVFySzFJU1RPU0FsQjZhZlFpd202Z0NxYSs5NXljRDRlZGNkQ3Rt?=
 =?utf-8?B?TDdhdkRLUzhxekRvNEQ4OWNhdi85SGpENmRPYmdzQTNtYnY2UWhMTnFPeXBO?=
 =?utf-8?B?ME1rSWNSNi9DdjM4QUVWRjhtRUsveVNxQldkYWFZZGgrdmNybk1KTEV2UUhz?=
 =?utf-8?B?US9YQnAwczY5YnZGS0pBL1NIQ3M5YjA1WlVINzBFSVJJUUh3MWNjaEZUVW9H?=
 =?utf-8?B?SHNGL1I5M3laVGVLTTFRVXowSHF1aTVLbTR3aVRJTkNzdVBvN3NsRTh6VG5t?=
 =?utf-8?B?a1ZwSUtEVVpRWHN5WkRoNDlLei80UDY0QlFqY0MxejlMU0tXSVNJbmR6M0Zr?=
 =?utf-8?B?Z3cwdE0wZkpyOWNTZVA5eDMxWTNtUXpKa1RzdFpRa1NMaHFEeWNveGh2QUd4?=
 =?utf-8?B?V1N2RkRqZDVrcjhGV0tPSXEzakNMZ3IzWlM4Z0hZcFRGZ1hkQ3kzeW5KdSt2?=
 =?utf-8?B?RzFFSnVDZStUVmpJWGRxbWd2c1BPUngwNnFrdVJoNHZpZ3JaeGxJblh4Y1lx?=
 =?utf-8?B?NERXVkdFTE9CVUlkT0I1MngzRVR4NWF3VG90SHlpRGJqcDB1aUNyQ21McUpG?=
 =?utf-8?Q?9zsFyKeBTv3pXrmA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF610A002983AE439CD556422B658986@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eaa6b8e3-7a33-4b61-6b88-08de4ef36d43
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2026 20:20:54.9500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4CIXC942ksfwcKfnLlMtshmRQgGPWgz8gCK3obN6jU3x0S6F0dm6zWD7kGYYBxNIjcs+WEM8HefZFP0m7yGSI4wT6QbdnIcFU/f4IOlq+jQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7721
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI2LTAxLTA4IGF0IDE4OjM5ICswMDAwLCBWZXJtYSwgVmlzaGFsIEwgd3JvdGU6
DQo+ID4gSXQgY2FuIGJlIHVzZWZ1bCB0byBkdW1wIHZlcnNpb24gaW5mb3JtYXRpb24sIGV2ZW4g
aWYgZ2V0X3RkeF9zeXNfaW5mbygpDQo+ID4gZmFpbHMuIFZlcnNpb24gaW5mbyBpcyBsaWtlbHkg
dG8gYmUgdmFsaWQgb24gZmFpbHVyZS4NCj4gDQo+IEdvb2QgcG9pbnQsIG1heWJlIHNvbWV0aGlu
ZyBsaWtlIHRoaXMgdG8gcHJpbnQgaXQgYXMgc29vbiBhcyBpdCBpcw0KPiByZXRyaWV2ZWQ/DQo+
IA0KPiAtLS0zPC0tLQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90
ZHguYyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiBpbmRleCBmYmEwMGRkYzExZjEu
LjVjZTRlYmU5OTc3NCAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5j
DQo+ICsrKyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiBAQCAtMTA4NCwxMSArMTA4
NCw2IEBAIHN0YXRpYyBpbnQgaW5pdF90ZHhfbW9kdWxlKHZvaWQpDQo+IMKgwqDCoMKgwqDCoMKg
IGlmIChyZXQpDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gcmV0Ow0K
PiDCoA0KPiAtwqDCoMKgwqDCoMKgIHByX2luZm8oIk1vZHVsZSB2ZXJzaW9uOiAldS4ldS4lMDJ1
XG4iLA0KPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB0ZHhfc3lzaW5mby52ZXJzaW9u
Lm1ham9yX3ZlcnNpb24sDQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHRkeF9zeXNp
bmZvLnZlcnNpb24ubWlub3JfdmVyc2lvbiwNCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgdGR4X3N5c2luZm8udmVyc2lvbi51cGRhdGVfdmVyc2lvbik7DQo+IC0NCj4gwqDCoMKgwqDC
oMKgwqAgLyogQ2hlY2sgd2hldGhlciB0aGUga2VybmVsIGNhbiBzdXBwb3J0IHRoaXMgbW9kdWxl
ICovDQo+IMKgwqDCoMKgwqDCoMKgIHJldCA9IGNoZWNrX2ZlYXR1cmVzKCZ0ZHhfc3lzaW5mbyk7
DQo+IMKgwqDCoMKgwqDCoMKgIGlmIChyZXQpDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni92aXJ0
L3ZteC90ZHgvdGR4X2dsb2JhbF9tZXRhZGF0YS5jDQo+IGIvYXJjaC94ODYvdmlydC92bXgvdGR4
L3RkeF9nbG9iYWxfbWV0YWRhdGEuYw0KPiBpbmRleCAwNDU0MTI0ODAzZjMuLjRjOTkxN2E5YzJj
MyAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeF9nbG9iYWxfbWV0YWRh
dGEuYw0KPiArKysgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4X2dsb2JhbF9tZXRhZGF0YS5j
DQo+IEBAIC0xMDUsNiArMTA1LDEyIEBAIHN0YXRpYyBpbnQgZ2V0X3RkeF9zeXNfaW5mbyhzdHJ1
Y3QgdGR4X3N5c19pbmZvICpzeXNpbmZvKQ0KPiDCoMKgwqDCoMKgwqDCoCBpbnQgcmV0ID0gMDsN
Cj4gwqANCj4gwqDCoMKgwqDCoMKgwqAgcmV0ID0gcmV0ID86IGdldF90ZHhfc3lzX2luZm9fdmVy
c2lvbigmc3lzaW5mby0+dmVyc2lvbik7DQo+ICsNCj4gK8KgwqDCoMKgwqDCoCBwcl9pbmZvKCJN
b2R1bGUgdmVyc2lvbjogJXUuJXUuJTAydVxuIiwNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgc3lzaW5mby0+dmVyc2lvbi5tYWpvcl92ZXJzaW9uLA0KPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBzeXNpbmZvLT52ZXJzaW9uLm1pbm9yX3ZlcnNpb24sDQo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN5c2luZm8tPnZlcnNpb24udXBkYXRlX3ZlcnNpb24pOw0K
PiArDQo+IMKgwqDCoMKgwqDCoMKgIHJldCA9IHJldCA/OiBnZXRfdGR4X3N5c19pbmZvX2ZlYXR1
cmVzKCZzeXNpbmZvLT5mZWF0dXJlcyk7DQo+IMKgwqDCoMKgwqDCoMKgIHJldCA9IHJldCA/OiBn
ZXRfdGR4X3N5c19pbmZvX3RkbXIoJnN5c2luZm8tPnRkbXIpOw0KPiDCoMKgwqDCoMKgwqDCoCBy
ZXQgPSByZXQgPzogZ2V0X3RkeF9zeXNfaW5mb190ZF9jdHJsKCZzeXNpbmZvLT50ZF9jdHJsKTsN
Cg0KSXQncyBhd2t3YXJkIGJlY2F1c2UgaXQgZG9lc24ndCBjaGVjayBpZiBnZXRfdGR4X3N5c19p
bmZvX3ZlcnNpb24oKSBmYWlscywgZXZlbg0KdGhlIHRob3VnaCB0aGUgcmVzdCBvZiB0aGUgY29k
ZSBoYW5kbGVzIHRoaXMgY2FzZS4gSSdkIGp1c3QgbGVhdmUgaXQuIExldCdzIGtlZXANCnRoaXMg
YXMgc2ltcGxlIGFzIHBvc3NpYmxlLCBiZWNhdXNlIGFueXRoaW5nIGhlcmUgd2lsbCBiZSBhIGh1
Z2UgdXBncmFkZS4NCg==

