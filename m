Return-Path: <kvm+bounces-51094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E3BDAEDB3B
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 13:36:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DDB2189B5FA
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 11:36:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D601625F97E;
	Mon, 30 Jun 2025 11:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P4u6Wfd0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5009E25F965;
	Mon, 30 Jun 2025 11:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751283346; cv=fail; b=D4atpD8+YYHMbWUm4QoM79PIiSc7eQIILKBSqLI7CeGZBTkz3+e8HIsRG4IR2exTM4R98XVRz/MYSvViAdBYfpFOVSQM6izLFaBJIb3hjAI+gUVTmErjM6/cqM2O/SusvTwvpmJH1KMV3C26waLmIw8oJ+OXx9/FWPCYff9nE/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751283346; c=relaxed/simple;
	bh=NschVKi9RIxAo2lLWIawS02FVRxeCxm5HlK2TwqX+DU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ePLxlsgIBeUIWNTCsUXKmoQVFQKu9IEE6HcIvTBW7Xd/MwZDSyA/zS96hexEEo6dKdHs5MmnkLFzgvN0ys3cFldWo5t7vhmXi127g6/YvwTTRKwlLCR+AJqncT6oGnbT45+KXjmAsloaDHl+AumjRqVvbhkkhTu8/GACkfKRIDQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P4u6Wfd0; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751283345; x=1782819345;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NschVKi9RIxAo2lLWIawS02FVRxeCxm5HlK2TwqX+DU=;
  b=P4u6Wfd0UHM3njQDi9Q8X0JMQRsoUZl9hlhL5MPnB6nH8Yem/tmmrHyS
   AV2vzhCkJvfF69VHktfsifNMFHUWi9isbtlR0l/TRR/VnKS2ERwx4lmsP
   U55TVvvxlGHlBX2X4X8VB20KbuR+CRMGSiCuchFHSfm4KZGcXsE2q0Znd
   SioXbzBIFP8XkSJkdpg9ByUqEwhfm5pqSffRh/gNfmE97Ob7H9wt2Eqaq
   W/RX40QOjoDCBoLjAvFqR3LZ00Rn4ZiDDtlU40VBI2d9N2Hx9wvKbJfCy
   pU+IxLo8uM08OxvSOGm25FFBstrsO7DAPn1r/igzfvMlDaFWbSM4W6W2a
   Q==;
X-CSE-ConnectionGUID: /g1iDVe8REi+XqyFiElcFQ==
X-CSE-MsgGUID: arCZau7AQKGvY0NYcxReYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11479"; a="53654408"
X-IronPort-AV: E=Sophos;i="6.16,277,1744095600"; 
   d="scan'208";a="53654408"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 04:35:44 -0700
X-CSE-ConnectionGUID: OEMS+63iQi+7ma98g+WJ5A==
X-CSE-MsgGUID: XOup3wuyRNi0x83ERCAzXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,277,1744095600"; 
   d="scan'208";a="153906734"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 04:35:43 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 04:35:43 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 30 Jun 2025 04:35:43 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.75) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 04:35:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vr4YoUv6OK5EFm5rGtBDgZy2VWxwDpkcyRmFPXXqnSQL+Ul1KSfhynIgEsi0PjRjk4SPnUalORudtIQwNBsED/ptKsEnEjhHOg+Y688eEVMXfnN38SBq2ffn7vGpcFyZFyg3hbpxJTiQEbTJK109mi9VyOqsrPLJvnjnoGdL6O+oIM44dQ8Gc4PQtUIPnKfOKxBecBlzdqBwhUtbeuPdWlzgZeVUtJQg66jXz1spWUfOG5j7+Ir4aYFntuO3kTAJSS5htYqTh8rjFwWAiXleuGkKNBF4YnFGWOAOmAziZyDLuExBCUInZ+/88zrqjN4+VMm+9ejuynsijmiNsvbTUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NschVKi9RIxAo2lLWIawS02FVRxeCxm5HlK2TwqX+DU=;
 b=sxCyVsZ/H5jMmk5JNRHiJn5qoz0xRqeHgNnCcP4eUMln1bGaNtOrmsUZOt4tItau/RS/J6uOvIYuwLw3UvuzS97iYAkCBGWH7f5pf0jvArgqm9UKpG8w2vCDGMcJhRXQJUIcR+lPZTYjFxErfR+Y4aMwPiM4gN8L9wIu5E7/IcSooCGfyvwAlncnr7eGYUvHWR0ApLeuhDJSF0tz3u2XGjhLw7KxXA6uTZp2f6deMWsfBuz/VTCHRh6DcCSw646LeHOgA60oJPKVDDXfkVvdEuC1zkPWkJ5J6+CwawqzzzUyBmNsiGSe9bDtsFE+AaPvOUWBvIa7m0DhwScYnc/6Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH0PR11MB5521.namprd11.prod.outlook.com (2603:10b6:610:d4::21)
 by DS4PPF382351574.namprd11.prod.outlook.com (2603:10b6:f:fc02::1d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.29; Mon, 30 Jun
 2025 11:35:26 +0000
Received: from CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814]) by CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814%5]) with mapi id 15.20.8880.015; Mon, 30 Jun 2025
 11:35:26 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "peterz@infradead.org" <peterz@infradead.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>, "sagis@google.com"
	<sagis@google.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>
Subject: Re: [PATCH v3 1/6] x86/sme: Use percpu boolean to control wbinvd
 during kexec
Thread-Topic: [PATCH v3 1/6] x86/sme: Use percpu boolean to control wbinvd
 during kexec
Thread-Index: AQHb5ob1Aej6jhsWsE288GxQicmcLLQXHYEAgAR7koA=
Date: Mon, 30 Jun 2025 11:35:26 +0000
Message-ID: <c7560c2ed08fdc67968f8e03075ff4bac037e1f1.camel@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
	 <b963fcd60abe26c7ec5dc20b42f1a2ebbcc72397.1750934177.git.kai.huang@intel.com>
	 <c0b8e728-f775-1023-055c-4f879bbd784a@amd.com>
In-Reply-To: <c0b8e728-f775-1023-055c-4f879bbd784a@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR11MB5521:EE_|DS4PPF382351574:EE_
x-ms-office365-filtering-correlation-id: 69182e6d-d901-4952-c603-08ddb7ca3571
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VWx4ZWthRDZYdzNxMUhOdW9QQUNVV3ZEMUEvdzZabDlGSnlsc3B2MnRnUTZ2?=
 =?utf-8?B?STY4d092dUgvSWVQRU03dExHTEdYcW9RQTRmY1pyWVgySGtTL29IczNsdUNK?=
 =?utf-8?B?cXJvQUZiNTBXVU5IeFZDQUh4UU1lcnpaVWNNeEFGTkcxZlRZUS9JcWd5cUQ1?=
 =?utf-8?B?U1Y4WFJKOXN3N1JFOGtpaStkaXh5a0NsN0k0NGV5VUZaZnhaNlU5MldMUXhO?=
 =?utf-8?B?OTVoTkhHQW10bG5SRzQzbC9HV3RHNy80Zm53WDEyUUZ4T3dLcUNMODZNQzcr?=
 =?utf-8?B?VUxUSUVILzlJbXllZ3BzbjI1dmlKNDlMcnhiSmFOaVhIeTdnUExldmVUbTVE?=
 =?utf-8?B?d285SFhvRzVzR3VnVUpBNS9ibE1jNmEwcU8xRlNLcTZKR05iNVF0MGo4Skwz?=
 =?utf-8?B?Rit2RlB0Y2ZCUE5tcHB1eGZ0VmEwUjl2cnpKNE4rdWR3SkRSeU1xNW43QTV6?=
 =?utf-8?B?T294Zm5ueW5xMXlkdVZFSjVaS0Q5dHJOWUhpUHJEYy9pbEM0d2ROdFVLV0VJ?=
 =?utf-8?B?aEE4ZDVlMENXbXNPc2ErVU1mWE1oeUtaZGlYMEJjZ2Fmd2pmYXBpT1ZsRTl2?=
 =?utf-8?B?OU5CRk5MYUxDQllTWkp4TGlPdVhmRGZRSlZPV0J4L01mOHBtMFhxSHhQR1ZD?=
 =?utf-8?B?VUJoem56aG5VcmFVNzRmbUFEUlluWWE0RTJkOXRGcmRYcGM4cG9aUjF0WmFP?=
 =?utf-8?B?N2RFbFVWUzZRMXR6aUFlWEdYdzkyUzdTNFdSNHNHVGNCblgxcFVMNlgxcGky?=
 =?utf-8?B?OStMWUVwTXgvaElwRFZ6SkhjdDJoeDNkLzdxaGhLVkNScnpERE5wMklGUWEv?=
 =?utf-8?B?R2JSa1dWRlk5cnJzSkhaTnVadXFDTW40M0JLQjdwS3VLckRieE8vQXFJWllQ?=
 =?utf-8?B?UHo3bEZ4US9LVkFFajVJV1BJTUtBVXRWZjc5cHBjU3A5RnFDU1hVd2I0WkxR?=
 =?utf-8?B?ZXhSVVVOa3lsMEZ6azR5OGl4eFp1Q2RpMzRPa2xJZktTQXZXU3B6UWZWQzMx?=
 =?utf-8?B?TXFXV2t5NUNwOTk3a3AxVmNYamtLNm0xZnh4cUpoNm9meEVmQXp2bm9QdlM2?=
 =?utf-8?B?T1BmUG1OOG9sK0JYWEYxUEVlVTltdUJINDJkSlliQ21DellieFRuY2pJRUVn?=
 =?utf-8?B?cWtpVnN1bEthU3ZGcUJiN1R4dkFMbUVhcEgza2JHM1RyNXJCWWthUm5LR08w?=
 =?utf-8?B?enRTZjhlSVVlU1ltUFNZK0JkcnVjNGRPQ0poYTl4SnhBVGw4WmdmUll2UXJE?=
 =?utf-8?B?VmM3WG1yVktqTVE4L1ZtdkUrQ08vZHVTTXRXYTN3V3llM3dGTGdER2RUQmVR?=
 =?utf-8?B?TEU3bk5aTEpFaXIzRnkwRDFFbzQ3SkZ1N0Y3TVRId1VoVHJpQXRZemQrSTFa?=
 =?utf-8?B?K05NRlhhZXBvS2NLL0ZMYmtnNzB3dUR6OHQxZEUvamJLczF5TlExYjFvcTNM?=
 =?utf-8?B?VFFLVm1tSDk2NzVsajhNZjBFQ2EwWmVuYWpIbzZ1ckFnMXY1UnhJN0JnSTd2?=
 =?utf-8?B?bFJpckVycWROMUtuSXhTK1I1UzY1NE1lRE9nQmQ5V2F0REY5b3AyWWp6RWll?=
 =?utf-8?B?N0ltNTNaKzhGdXB3NzlPWWt0UUxBdG9Ra29VUElPN2pVemJ5SVQyTzNDUWc3?=
 =?utf-8?B?dkIzZXV5Q0llbVpOTUZkT3NPb0trUXUvajJjUWxVK01tbnI1NlB0dFhxWlM5?=
 =?utf-8?B?bXQ1bC9VcXFVbnNNRzZVb2RUL1pHazJEYklrRG40T2QvWlQ0bGtWMVhVY3ln?=
 =?utf-8?B?bWxxVjVhTHVmOEQwTy9FWWtUejRwaHVGdE5UWmhCaVk5bU03akZLUXZlY3J6?=
 =?utf-8?B?ZEs4SWlPYVczanh4dmp2WE5HWXR0MExnUHpvZkNSWk84QmFqWmFhanNaV1Ir?=
 =?utf-8?B?V0s4c0JSUVdyazlTblFxWTRXVlkzV2FFZFdySnU3d1JMUnVxVDVPblpNeDU3?=
 =?utf-8?B?dFc4aU5XWEl1M3NOWUMxVnlnYi9Eckp4Rmp0b01XK3loZmZLWHdURE1hTks1?=
 =?utf-8?Q?xJdMv87pNcuYKQlncudcLZUfco58dc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5521.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cXR4cTJEWUtXY2p1ZTF2dXdDeGVPUFFrWnhZNkFFWjBWOXRxTEVUWlR3eWpO?=
 =?utf-8?B?MDZGZ2k2bmlQZTEyMHAydkFTMkJiRW9ENW5PTFYzUXN2S3BBQnhwcytCRVcz?=
 =?utf-8?B?VFZheUdCSk9tSG1qK0Nrd0NqUXpnRWxqUVpiZGZrN0YrazRmRnVGWXJQK2xp?=
 =?utf-8?B?TjZVM2gyWmFhd0pSdTBLVncrclJaRFB6L3diTGFLQnluVW9xZG8yREVGWTA5?=
 =?utf-8?B?SlNGRGVlWUdqcU9DaUZ1eDVVb1ZmOUQ1OWFWVlVmOGQxMzYrUS9vZmJQbUp2?=
 =?utf-8?B?elhXZGFqMGkxNUdjQ1dLeDkzcFUxSzhOS1ZtT0ZheTk1Y0NDcE5RQUdZWkNp?=
 =?utf-8?B?bG9aSk5aL1FQN2NVNlo3dnhDQ2VLazBUQ2I1bmtLNEVIeUFqL3RtVDJpMUto?=
 =?utf-8?B?YmVLTWhabTh6bGViVEl3UjMwcldiQjRRM1VwK3luTnZUTGFOR3JodkVWb1Zu?=
 =?utf-8?B?ek1aR1VNV3JxcnVCQjNHQ3BwWjc2M2JoL2xWbkJicmwvUDVOWlp0dFo2UXE5?=
 =?utf-8?B?V2x1dTF3N3dIVjZmd0VYZkY5Z1hteDc3emhOcTVYWXQ1UTVwZ09vZU5oWWtE?=
 =?utf-8?B?NWRCQ3h6NENFSHI0NGRjSzFrUFNMQitVL2wzL0p4OTh4eWhyMW5xTnQ3NXE5?=
 =?utf-8?B?L2w3cmpZcjcxV1QzS0VnZHlzaVl2MXl0dWRlWWVEbkRXOWpHb3IwMjBoVkJM?=
 =?utf-8?B?NExPcWduNUtqZDVQZ2p4WjJ5SjZOalRzRWx2UkR4bTJhOVRNdkRVWGhqRFcr?=
 =?utf-8?B?N3VRc1JCMmZzaUMzTUJkYXBoZ2hMbDB4UU5HblAwYm8rQ2V4anIwaFFKdGRl?=
 =?utf-8?B?VUxjNTlhRkhEa2tLVm1sWWZQTDBVOUR3dG9DRFd5N2NYekJRTXhOc0hZMm9P?=
 =?utf-8?B?UmQ1UW9PR1ZDejltako1WGl6TjlJdEkwMWlVdzRhTlhPcXJCTEhlS0hVZS9S?=
 =?utf-8?B?OE9nZWY0ekoyRXpQOTd2RElKbHpiQ20vczRKdkhoMDI3cGZHSldLMUJFNUFm?=
 =?utf-8?B?SjhQV2ZPcEp5N2M0NERCTHVldzRMdER4VENGN1hiZHVObWZBVVI2QUZPbUg4?=
 =?utf-8?B?ZHRsTCthYTkrTWxlWGZvYmpuWDNhNjBGcmxFK3JiU3NuNGZtT0UyemJxZmow?=
 =?utf-8?B?ZDVONEhSQkNTOHE4NkgxM1RQWVhsUmZ5VjNjUDNGa2Y4dFR5YnBJVDFOcmI0?=
 =?utf-8?B?OFprQzRPQnRQbUgwd0RNQUFCVGNnS3BGaWlHaEFuSFVJRGFEZEpTa2VEUmVD?=
 =?utf-8?B?UWI4WWFBTmwrQkEyUmtPNVQ4LzRNVWpZUmNUOHZNc25nOUlFRW9HQjN6U3dp?=
 =?utf-8?B?QUczTnA4eEpPSzhTZlFhVmFoMnRtcUJPenA5S1psUVova0wvNGwyTGMwMkU1?=
 =?utf-8?B?ZW54UnM0MzZlaHR2eG1VQjJhY0RVaTdyazlMaDBLUkZyQkM4enA3RmFrSXVP?=
 =?utf-8?B?NTc3b3VjbHJDV1RNZ0UxK1IvUmtScWQ5aDN1N3BEb2lBdzFSSVNXK1NXZm5T?=
 =?utf-8?B?cE92clVuQ2hmQ1VVYmo3S0NPM1Z0anVuelFaVTNuMnplQUxDblkrVW5wODQv?=
 =?utf-8?B?UkxzNFdmeWVlcDRDa0Z1N3ZQZExoTlF6K1o1aEFIZytrMU9oVjhCMUh2TUFt?=
 =?utf-8?B?WlZRQk4xc2ZaREt1TDdvbzZIUHV4ZEhVemQ3QmN6ZmlmVFpYVC8ydWRmcERQ?=
 =?utf-8?B?WFpCd2xUcDNyVEtWZTU3SlFPQ1NtVnNRa295OWJ0eUt2WGcyWkc3eGw2Yndm?=
 =?utf-8?B?d1ZpWmxZRmhzQzRWSHloUUl6OXRhTkJ2Y01qcGJvbGF0ZHRuTjlqMDQyVlhk?=
 =?utf-8?B?Vk5oTXlPejFSVWhGWEt1bDBUZFBCM2dxRWFOM3h2RGRZWXdSWFRwUDQwMlhl?=
 =?utf-8?B?YVptUEhLRVFjWXNzRlVHbGd1UnhxbXV5MWE1eWtYUzdNVlpyVlk1SjhPSUxC?=
 =?utf-8?B?VDNoS1dwTEtwYWtCL0RYeStVcUZTOEk0eElzTmZIc0gvbEVMNlV1RGZvZ0No?=
 =?utf-8?B?SXlQd05oZ3YxWW1TT3c3YVNabGpYV1N0OWZXN2pOR0d3VkJOVmpqK3Q2SWpY?=
 =?utf-8?B?L1FDeTFZa1g3eFcxc0pFTjQxb0ZkUHRCV1VXMVlXQjN4OXQ3KytYUTVHU1Y0?=
 =?utf-8?Q?YrudFsVhANWvFjL6nlsB2x4eV?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <573A9AC0D9978443A2989BDEC492DD16@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5521.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69182e6d-d901-4952-c603-08ddb7ca3571
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2025 11:35:26.3863
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OiQJCy199rYkBDACKsOaPc68K2oAXqZCHfjtgOBs85fj0mVUP34+eO0SOwHQduk2txv6eACer6vpIpz7OMsZdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF382351574
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA2LTI3IGF0IDEwOjA4IC0wNTAwLCBUb20gTGVuZGFja3kgd3JvdGU6DQo+
ID4gU2lnbmVkLW9mZi1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiANCj4g
UmV2aWV3ZWQtYnk6IFRvbSBMZW5kYWNreSA8dGhvbWFzLmxlbmRhY2t5QGFtZC5jb20+DQo+IFRl
c3RlZC1ieTogVG9tIExlbmRhY2t5IDx0aG9tYXMubGVuZGFja3lAYW1kLmNvbT4NCg0KVGhhbmtz
IFRvbSEhDQo=

