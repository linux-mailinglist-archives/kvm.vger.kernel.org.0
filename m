Return-Path: <kvm+bounces-53748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E467B16648
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 20:32:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 81EAD7AC948
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 18:31:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F31B2E0B59;
	Wed, 30 Jul 2025 18:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Oo2fTt4e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801F72DFF3F;
	Wed, 30 Jul 2025 18:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753900344; cv=fail; b=ZGFZtEj96h/IYr0NByAV6Tv0Fx599ScZdl/9/dz6w8I7cFJuKc1hu7VkJDZed5+naqetc0Xe525wI12HddTpCtXKLW6XYZjMbjrgj9m0eXs8gugeX0ZhcGk+hSFfJOucxOeorWzfNKlrgioDKnHrWX2xfRIOWD0ALTCBruCIkzk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753900344; c=relaxed/simple;
	bh=PBeGcX4IuAFV6/PnZiho0y9vI0W0qfRR5kfcOkOijSg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=vD45i6G6Qpas0ddWlPan6dlfqpz4zONjsNs9Yff+ifA8iJHEs57K837l93PNtzydX8RrCBPdqAnm84Obz5tDtExfzcDLaIkpTiLr32f4jg/nfBlfu70UJ4Jlfxwz2rcBj5fmUzJMxQHkqxEyMhftt0YDR/Zl4bjR9g5zriVlFzM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Oo2fTt4e; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753900342; x=1785436342;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PBeGcX4IuAFV6/PnZiho0y9vI0W0qfRR5kfcOkOijSg=;
  b=Oo2fTt4e0TL3Hjnxn6S2n5v9YIOj78igFFq0FVrSpRwSNkAs6wkI0SCL
   IHj4Vt5vnM31IXMo282VVN7Ikyd1gfl6Sinl8ON0CY1LCAtTLWXF+gVF5
   Q3ZH1JTbfZ0zHrXcu1UPiNfcYGtlepBiBrJzpguvWqtNMEeqdjS4DQbte
   IyAEKoa7GkXP5eD08suhbnnsCW2ZvK8Sk7xqKCPnap5MMTdEcpbFWSSk/
   AD0QyqA5UCSqTSHJhJHJt9rsv4OawbniYnKw53tC7JaelGtXisbJVD2hn
   024JuQ6zo38sDDQjEna5doALfNpn+ImbpeJ9qej6FN75gNBZwt4TSybw7
   Q==;
X-CSE-ConnectionGUID: zmx7jYBXRnuZer/Dy2xJfQ==
X-CSE-MsgGUID: vX4QpdbIT+CTUe06eW7+EQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11507"; a="66777296"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="66777296"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 11:32:21 -0700
X-CSE-ConnectionGUID: +huEid/3RzWAQPhKJukYQg==
X-CSE-MsgGUID: j55wD8OLSQuabnVoZzvRpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="162338034"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 11:32:22 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 30 Jul 2025 11:32:21 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 30 Jul 2025 11:32:21 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.52)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 30 Jul 2025 11:32:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OJqnXNZRym2eY/HjZxmltLARYC27R7CKi4gMVmda56EvIOVQ3WpUwP8RDydP6oCII0oJbX+QsroL/RYgBVY16p+QfuEURwg1VsMhMjsrRWxFPFW5oEYFbfJ/Kcxpst1Yn/VlNhPbXMehxUORAWWo892F8J4LNN1M5/hItPMdbv/sFJLlqNnV2cubCSAsjVy2VDWNFVcItdFnHOVPNNJ0/3eIrv69dmVBkGl/U0sOVk9GdNx4QBHM5XxrmTU6dH3b5//4TEZ74c3aM4uU4fib8gWX4zcx/T1b+jymXYHlPcGhUPwmvEnUDcLW4Phowfa1jhKzlP5etyxyGjBIMnNbzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PBeGcX4IuAFV6/PnZiho0y9vI0W0qfRR5kfcOkOijSg=;
 b=Lgqg7b6IX5C2GqZqnVB4f9FAVdt+s+mS4DsJmVpydqp2eTsAPQooFDO246Ub2zqU9fTD/9mn4F83V1DSF1s7edo69O5I9u6poH9ZsdaLYE7Mth5NvqeVGb78GmI9TTRxSAOe014wPd+BxQxhJHzOpoUL6JRB+sLg3wuDcLPX+s5xdKGAbATR11PUpnlgXNd8h//ywlXoqpxHImPnUlra433wNAqWDrJXFS7H6Jt1YsljYstDCQwaYN1c4zlLWmHQ1m4iITQLtxe8d1acl0Yz0b8JbPJNuqvl8tg1djyV4V+GwYzyMaIfWMPVYUDRHnvax3OBH8z4Sj6HcGsOeimdXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA3PR11MB9352.namprd11.prod.outlook.com (2603:10b6:208:575::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.25; Wed, 30 Jul
 2025 18:32:17 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8964.025; Wed, 30 Jul 2025
 18:32:17 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Huang,
 Kai" <kai.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCHv2 01/12] x86/tdx: Consolidate TDX error handling
Thread-Topic: [PATCHv2 01/12] x86/tdx: Consolidate TDX error handling
Thread-Index: AQHb2XKrlmf/Zzss+E+nUDEbBxD0tLQUQqeAgAAyUwCAAAf/gIAAyKeAgABZzICAABIZgIAAEweAgDWJGwA=
Date: Wed, 30 Jul 2025 18:32:17 +0000
Message-ID: <70484aa1b553ca250d893f80b2687b5d915e5309.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
	 <20250609191340.2051741-2-kirill.shutemov@linux.intel.com>
	 <5cfb2e09-7ecb-4144-9122-c11152b18b5e@intel.com>
	 <d897ab70d48be4508a8a9086de1ff3953041e063.camel@intel.com>
	 <aFxpuRLYA2L6Qfsi@google.com>
	 <vgk3ql5kcpmpsoxfw25hjcw4knyugszdaeqnzur6xl4qll73xy@xi7ttxlxot2r>
	 <3e55fd58-1d1c-437a-9e0a-72ac92facbb5@intel.com>
	 <aF1sjdV2UDEbAK2h@google.com>
	 <1fbdfffa-ac43-419c-8d96-c5bb1bdac73f@intel.com>
In-Reply-To: <1fbdfffa-ac43-419c-8d96-c5bb1bdac73f@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA3PR11MB9352:EE_
x-ms-office365-filtering-correlation-id: 0acfd11b-16ad-4a22-3a88-08ddcf976992
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?czhDNWlwZ2g4T1hjTDlkc01oK1NvKzN3bGlTL01CMG9MTjVYWWx4SlJzRk05?=
 =?utf-8?B?azJLc0hPVnlqSWEzckJsRm1pN0xQZ1NkWDZSQzc1S2MvU0hLSjZoZVB4RE1s?=
 =?utf-8?B?aC9xc2JHcXdnUHpSa3JHS0QyU0U1WlpQVkhlcllmQnNsKzkvVXRwa2N5cFlo?=
 =?utf-8?B?dGJYdG5jMUF4OUEyM3R0QmN2VDRYU1pIU1dPU1ZUa1R4NldVWDV0SWtQVjBI?=
 =?utf-8?B?alhnL215Z1NlaU1jaUZIWW00enNjNWhCL2VVL3dNeEIrZ29IR3pEOGpROCsx?=
 =?utf-8?B?cFdPU1RrQjdBV2IzcG1hREovN0dJS2VRcXhIVDdhOEVSSkYrMW51clRYdUZQ?=
 =?utf-8?B?NnV4VzQ3bFIwclpsOGN3cGllbGNoWnJFSnQ4RndGZ0xqN1Z2Q3FSc1M0NWpT?=
 =?utf-8?B?MmhUQzAyaEg2c3N0THl5YXlJTkdRMENNT0dWQVdWcURXZG1PZU1EdVRkaUR2?=
 =?utf-8?B?emo3R3NqYnVad0FEaVVvOTlLWUc4WVRlLzh3TDNTYitINXdIZ2xCbE1GOWVJ?=
 =?utf-8?B?OUY0MVY5S2dMTE5ra3pPWG54QkhjL0FCdVJFaGtCV2NtYUFYSlZHNk1SaUpm?=
 =?utf-8?B?M2lIRG01a2lUZnZ4aEM5WllnQlpRdVhPcHBCWTBXT1N4Nmdhc2Q0K214dXlV?=
 =?utf-8?B?SDVWNlBaUzlBajlqY0JucE9lRlJEalVBRVpDUDRxNnVJWS9XUzV6MVB6bUg1?=
 =?utf-8?B?bWxOZkNNYVh5bHR1YkRCdjN6clppRzBSRE1PTFREazNJN2VZVitqeTdMcXpD?=
 =?utf-8?B?c1dYQVRnZStxL2dWQ2ZMSU94allCRlJYcUJKR21ReTYzNGFUOEtMZTBDZVhz?=
 =?utf-8?B?Z043b3VWSC9JaWRzazhqQ2VLNkhzRDVSTTZNek85c3dYeFNTZjAvQzlQbE96?=
 =?utf-8?B?WXQ5bVczQXlnRWpQbEo0ZU9OTmlhV09nKzc0aDF0Y0RibkFxdHdWaHVkWjBL?=
 =?utf-8?B?TXpEQ2plU05yR2NuVjRLQ21uVUJJcG5UQmpUa3VEcG9IZUdCS1d0bVdlV3cz?=
 =?utf-8?B?SG5FbEg3YUdUK1VEZEQ4eEtFYVJkWUtFWmU3US9IaHZYVUp3TXFLRkYvUHRX?=
 =?utf-8?B?aUVpTkJBRXhES1FONUQ3M2pmcTJmcWhRU25BcGpQTXBLZ0d5VUFacUFyWFRP?=
 =?utf-8?B?bmJ0Qnl3S2hTWng3T2VkUlZUcVh2aUJzTE1KZUEwVG0wcTFCckFzaHVsYVk1?=
 =?utf-8?B?eUJmNGRYa0xOU0lZemdKam9LVFNoaURxbndyclZRV3BSWWdjNE5YL3pkdWFi?=
 =?utf-8?B?MEYrZlJUcm9wRHRUOTFPbDZxU0s5VWRRYXFvR0cwbnhjOXhkLzc1Tk1jS2lN?=
 =?utf-8?B?UUtlallOVkt1UGY1N1lMZlplaDVTWXhHZHRCQXBrRXE5bWVScGpWNWNsQXkv?=
 =?utf-8?B?WU5obUc3NFJUaTJCUUhkRS9mWmlzOXgyZGRIRERMNWVKbHBBSkZBbG5RSHVX?=
 =?utf-8?B?OEl2ZUNwSU9TRkhVNlU2cGdJYlhONlkxUnhwRThVNGV6elpIU1ZGR0w3ZmxM?=
 =?utf-8?B?V1JRd3R2eHcxUDZPMlo1cjdVQjFmRVg0K0N6VTFlRUF0dVFUa0Q4ZGNRSHlR?=
 =?utf-8?B?WUgyaEo2Y2hxMVFKd3NTbnBlS1d3QmRWTEhrd0hZaVJsN0dGR0diK25jdHhj?=
 =?utf-8?B?UVlYUkc4VkE4ekNkdXRxZWtOVjlxczJpTTdvOWJCellMR2dFRm5HY1pnYkVl?=
 =?utf-8?B?cEJ4TUtIRm8rV0lKM2VicDdySkJjQ1ExYmtmdm1yQjRqREFMUEVsQnpYbWtk?=
 =?utf-8?B?eDhXbkdlUFdFZmtaempKRFRyeTJ3cUJ4elRaRFN5YUJGYVRxQWg3cUFwQVl4?=
 =?utf-8?B?U2JEM2lzSGtCUFhmK1hPd1RzMGo3cHRkWUNIQU5wNDFFZnpUSUhYZFZtdldv?=
 =?utf-8?B?VnJLUU56TDZtZEl4S051L3cxR0p0VHNxM25DY3l6N3FqUDQzNndxT05FNVlJ?=
 =?utf-8?B?dkpMOFRFRk5lQkpnL3FCR21LZkFpWkc5bVVGeGdhbjNQYVZmcU1GQU1YZHlP?=
 =?utf-8?Q?fCCZdD+ima4g8/F9tuxJmnNMqHZrSI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K2puYXlNOU9XQnozSFJLeUFOcXlkdDVzYmVWNmlUNWRSdUNTS3JEYXFDMDgv?=
 =?utf-8?B?aStuL0lCL0N1alNrRVh3ellaeWxWdlU2Q2VUV0hRaGhUQmxWM3VpMWpPeVcr?=
 =?utf-8?B?VXd3NUZGdjVRUDVIbWs5bkg3dkNnWUtQUkxlZGNidGMvdnltYTc1WllJYWhk?=
 =?utf-8?B?TmlFdzFHN1cwRnJsRW9peUlWRGs2blZLRUt4RmtZRWk1NXJtUm5Ic2lPMzVy?=
 =?utf-8?B?cGliVDE0MmcySUszMXVaQnBaYXdrLzJJZ2tiZmpveWY0NFh6TUp6WkRDUHQr?=
 =?utf-8?B?ekwzNkJ2dDdKcDhlcCtMTFA5cXRhK2h5NjJaUFZxRUJCcE9nalBVQzhvWU93?=
 =?utf-8?B?N0hQVWdTV3ErQ3h5ZFBLVmdPRlNPQlJxZ3hWZlROVEtEMHZ6Q0pZSG11VjFy?=
 =?utf-8?B?V1JnbE9nZ05PTTJVVXFVZzU5V0c5VkFFSEJudjRaNGhEaWJUakVRSWRHZW5z?=
 =?utf-8?B?N2hBd093cWNJbWlBUEVHdEl3TmRIc3FiWUdaMlAvdnA0QVZzY1hCWlczdlBT?=
 =?utf-8?B?OUhPRFBYbmlDNm1uVjZzbGUvZlJmVExkUzdnOWovS3JVcmVEQWF5aVZVNzRL?=
 =?utf-8?B?YjQ0cW5EMWFLaHR1a1Z1MEZEdTIvdlB1YnUxL0x5MVUvdG9uQ2Vrc1IxRWlC?=
 =?utf-8?B?SmUwOWxUTG9OU25iZVExOFFpbm9ibDNvVkx4UW90NXBrcFhMWjY3M2tWQkxL?=
 =?utf-8?B?VHZ4VUUyZTdLeVIyQzI5YVhmb0dSVVNnVHIzdlJQUEpib1hGVm1Jaml2eDVG?=
 =?utf-8?B?NkkyNzFPYlZZMG5MYWlwbjZLUndOdXBST2RJa3dTTTRua1RiT0NNV3JjdE0x?=
 =?utf-8?B?cmgzd3BzcEFGTGFRRmZ2YXAyNjREdWJITFZhYXA5OXBCNWUxOXBSRmJyZEVG?=
 =?utf-8?B?ZzYxbHVVQzFYcFpDcnppZHRxeXducm1RN21nOGNmQTJHZFAybVNRaW9MeFQ0?=
 =?utf-8?B?bUNWNDFKd3Y0Tk9MSUljU3c0OGJpTVc5M1UzOGFucHJTNzNhRWlQeDQ4Yk0w?=
 =?utf-8?B?eGplZDF5RE95dkFIUHdkVHB5Z3BxR0xZWlZrZ2luNFk4dXoweW5oaVRjOW9s?=
 =?utf-8?B?b3plL1c2WnJRdTI3NUxRYlB0SHBVUU9RWVZFdFR5bXNHT2J1ZVc0UjNjN2Zq?=
 =?utf-8?B?RWk3aXR3TGI2d056SmpnKzQ5RVp5NHd4UHUybkpRTTNITjkydk5CaXcxcDcz?=
 =?utf-8?B?STRETEVFVGVueXdicDZjRXBIckZyaUoyRCtOVms5blFKYlBDQWZBeWFJdGpN?=
 =?utf-8?B?Sk9jOFg2OHBxVHZPYkhCT1RzVkNRL3N1WTNPdmt5MXVnNU1razRQRUYrNHph?=
 =?utf-8?B?dWc5ZWZLUFNUNWVOM3loaFJlYy82MFIrYlJ5SFZFckc3K3QzVE1zSENzTVkv?=
 =?utf-8?B?VHhOKzd5cDBHZnh0STB0TWVVMG5oT0JXVGlxZGNuWkdITGRQTTFBWXl5UU5q?=
 =?utf-8?B?bGNCaytIWmJ6L2U1MjRtaEFqTTFHZjhuNHRXVHlJMHJhMy9ZQnVsZjR0Yk5F?=
 =?utf-8?B?TjduWDVvVzgreFB5dGVKWXBMWEdFMkFzRlFKL2ZXTEthYXhNcWJDNWFOeStD?=
 =?utf-8?B?azVON3lONVEvY3dKSVBUczYzRnZIWFVIbnFpVnRkWEdpVitLd0Q3cmNuWUcz?=
 =?utf-8?B?UVlDZHpZT3RFckwwdFZMbXBCSk9Sc24zQ0hHSG9mUHl6YWRFN29udmhzUndm?=
 =?utf-8?B?SlBadUFUTkdEZm50T2NPZk5SR1pDUGh5anp4aHNxajhrRERhL1dVb1BOVW44?=
 =?utf-8?B?NnV3OW9UTWt5czIycUErdVlDbEYxaGM0eHpRNTJwWitQTHRtVWQ4RnZJcTZt?=
 =?utf-8?B?Q0RxWDR1alRLYzJKbFdGdEE0UXhubGlLYkM2YW1rNW9ScGV3MHRlMlMzRkxs?=
 =?utf-8?B?U1l6WHNSUGdJeEdEUmI4Y2RqdEd0L2l6VmRyQ2tvcjlOcktUbkw1M04zVFN3?=
 =?utf-8?B?QXFBYXQ2UzZ3QlE1YTRMdFRXVDU4cDF6dGdjS2N4MTVGeWMwWFNyanp4VGVY?=
 =?utf-8?B?VXkxREhxZXAvNFNXbHJYc1F2SENyQjRlSlR0NTJaeVJ3dlJJandiRXM5MXls?=
 =?utf-8?B?V1pReHMzOGFDeHpPUUxpOG1QdVJQRnpDM2tmU0luanQwcTJJT1BRUkhJU2Nj?=
 =?utf-8?B?NzlScXlwL2Vtbm8vVm00TXBlcEN4L3YrakVJWW51RE5lZDRFaHNxN3NINmR4?=
 =?utf-8?B?QUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5E103044BF8D214C9B9C7526E2C4F13B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0acfd11b-16ad-4a22-3a88-08ddcf976992
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2025 18:32:17.4561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rTfvyuBLquy+2bZEgzLSbEEk89e1+Q6qDjyM7nAn3aikdP/+iiAU9QsCdKA/39bxRVBb9rIaWAstUFHMASMlpnO4OycDQv9nytxJn94yC1U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9352
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA2LTI2IGF0IDA5OjU5IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gNi8yNi8yNSAwODo1MSwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gPiBObywgSSB3
YXMgdGhpbmtpbmc6DQo+ID4gDQo+ID4gwqAJaWYgKElTX1REWF9FUlJfT1BFUkFORF9CVVNZKGVy
cikpDQo+ID4gDQo+ID4gZS5nLiB0byBzbyB0aGF0IGl0IGxvb2tzIGxpa2UgSVNfRVJSKCksIHdo
aWNoIGlzIGEgZmFtaWxpYXIgcGF0dGVybi4NCj4gDQo+IFRoYXQgd291bGQgYmUgYSBtb3JlIG1v
cmUgY29tcGVsbGluZyBpZiBJU19FUlIoKSB3b3JrZWQgb24gaW50ZWdlcnMuIEl0DQo+IHdvcmtz
IG9uIHBvaW50ZXJzLCBzbyBJJ20gbm90IHN1cmUgaXQncyBhIHBhdHRlcm4gd2Ugd2FudCB0byBh
cHBseSB0bw0KPiBpbnRlZ2VycyBoZXJlLg0KPiANCj4gSSBraW5kIG9mIGhhdGUgYWxsIG9mIHRo
aXMuIEknZCBraW5kYSBwcmVmZXIgdGhhdCB3ZSBqdXN0IHNob3ZlIHRoZSBURFgNCj4gZXJyb3Ig
Y29kZXMgYXMgZmFyIHVwIGludG8gdGhlIGhlbHBlcnMgYXMgcG9zc2libGUgcmF0aGVyIHRoYW4g
bWFraW5nDQo+IHRoZW0gZWFzaWVyIHRvIGRlYWwgd2l0aCBpbiByYW5kb20gY29kZS4NCg0KSGks
DQoNClBpY2tpbmcgdGhpcyB1cCBmcm9tIEtpcmlsbC4gQXQgYSBoaWdoIGxldmVsIERhdmUgc2Vl
bXMgdG8gd2FudCB0byBlbmNhcHN1bGF0ZQ0KdGhlIFREWCBlcnJvciBjb2RlIHN0dWZmIG1vcmUs
IGFuZCBTZWFuIHdhbnRzIHNvbWV0aGluZyBtb3JlIGxpZ2h0d2VpZ2h0LiBUaGlzDQpzZWVtcyB0
byBiZSBwYXJ0bHkgYSBzdHlsZSBkaWZmZXJlbmNlIGJldHdlZW4gYXJjaC94ODYgYW5kIEtWTSwg
YnV0IGFsc28gYQ0KdGVuc2lvbiBiZXR3ZWVuIGhvdyBtdWNoIFREWCBpbnRlcmZhY2UgdG8gd3Jh
cCAoaS5lLiB0aGUgU0VBTUNBTEwgd3JhcHBlcg0KbGF5ZXIpLg0KDQpCdXQgYXQgYSBjb2RlIGxl
dmVsLCB0aGUgaGVscGVycyBoYXZlIGJhc2ljYWxseSBpZGVudGljYWwgbG9naWMuIFRoZSBkaWZm
ZXJlbmNlDQpiZXR3ZWVuIElTX1REWF9FUlJfT1BFUkFORF9CVVNZKCkgYW5kIHRkeF9vcGVyYW5k
X2J1c3koKSBzZWVtcyBtb3JlIGFib3V0DQp3aGV0aGVyIHRoZXkgbG9vayBtb3JlIHJhdy4gU2lu
Y2UgS1ZNIHNpZGUgaGFzIG1hbnkgbW9yZSB1c2VycyBvZiBlcnJvciBjb2RlDQpwYXJzaW5nLCBJ
J2xsIGxlYW4gdG93YXJkcyBTZWFuJ3MgcHJlZmVyZW5jZSBvZiB0aGUgYWxsIGNhcHMgbWFjcm8t
bGlrZQ0Kc2lnbmF0dXJlLiBTaW5jZSBEYXZlIHBvaW50cyBvdXQgSVNfRVJSKCkgb3BlcmF0ZXMg
b24gcG9pbnRlcnMsIEknbGwgZ28gd2l0aA0Kc29tZXRoaW5nIGVsc2UuIFREWCBkb2NzIGNhbGwg
dGhlc2UgIkNvbXBsZXRpb24gU3RhdHVzIENvZGVzIiwgc28gbWF5YmU6DQpTVEFUVVNfT1BFUkFO
RF9CVVNZKCk/DQoNCkFzIGZhciBhcyBsZWFraW5nIFREWCBiaXRzIG91dCBvZiB0aGUgU0VBTUNB
TEwgd3JhcHBlcnMuIEkgZGlkIGNvbnNpZGVyIHRyeWluZw0KdG8gY29udmVydCB0aGUgZXJyb3Ig
Y29kZXMgaW50byBlcnJubyBjb2RlcyBhdCB0aGUgd3JhcHBlciBsZXZlbCwgd2hpY2ggYXJjaC94
ODYNCnNpZGUgYWxyZWFkeSBkb2VzIGludGVybmFsbHkuIEkgdGhpbmsgd2UgY291bGQgbW9zdGx5
IGRvIHRoYXQgZm9yIHRoZSB3cmFwcGVycw0KdGhhdCBLVk0gdXNlcywgYnV0IHRoZXJlIHdvdWxk
IGJlIGZldyBjYXNlcyAoVkNQVV9OT1RfQVNTT0NJQVRFRCkgd2hlcmUgeW91DQp3b3VsZCBoYXZl
IHRvIGxvb2sgYXQgdGhlIGNvZGUgdG8gc2VlIHdoaWNoIGVycm5vIG1hdGNoZXMgdG8gd2hpY2gg
VERYIGNvbmNlcHQuDQoNClRoZSBvdGhlciBwcm9ibGVtIHdpdGggdHJhbnNsYXRpbmcgaXQgdG8g
ZXJybm8gd291bGQgYmUgdGhhdCB3ZSBwcmludCBvdXQgdGhlDQpURFggZXJyb3IgY29kZXMgaW4g
YSBsb3Qgb2Ygd2FybmluZyBjYXNlcyAoS1ZNX0JVR19PTigpLCBldGMpLiBXZSBhbHJlYWR5IHdl
bnQNCnRocm91Z2ggdGhpcyBzb21ld2hhdCB3aXRoIHRoZSBURFggZXh0ZW5kZWQgZXJyb3IgY29k
ZXMuIFRoZSBiaXRzIG9mIHRoZSBub3JtYWwNCmVycm9yIGNvZGUgY291bGQgYmUgdmVyeSB1c2Vm
dWwgZm9yIGRlYnVnZ2luZyB0b28sIGFuZCBvbmx5IHRoZSBLVk0gY2FsbGVycw0Ka25vd3Mgd2hl
dGhlciB0byBwcmludCB0aGVtIG91dCBvciBub3QuIFNvIHdlIHdvdWxkIG5lZWQgdG8gcmV0dXJu
IHRoZSBURFgNCmZvcm1hdCBlcnJvciBjb2RlIGFueXdheSwgYW5kIGF0IHRoYXQgcG9pbnQgdGhl
IFREWC0+ZXJybm8gY29udmVyc2lvbiB3b3VsZCBzZWVtDQpsaWtlIHN1cGVyZmx1b3VzIGNvbXBs
ZXhpdHkuDQoNClNvIFNUQVRVU19PUEVSQU5EX0JVU1koKSBzZWVtcyBsaWtlIGFuIG9rIHRoaW5n
IHRvIHRyeSBuZXh0IGZvciB2MyBvZiB0aGlzDQpzZXJpZXMgYXQgbGVhc3QuIFVubGVzcyBhbnlv
bmUgaGFzIGFueSBzdHJvbmcgb2JqZWN0aW9ucyBhaGVhZCBvZiB0aW1lLg0KDQpUaGFua3MsDQoN
ClJpY2sNCg==

