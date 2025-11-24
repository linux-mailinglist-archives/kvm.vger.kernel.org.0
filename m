Return-Path: <kvm+bounces-64307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 147C7C7EADD
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 01:28:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8A1E1343EAE
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 00:28:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 864BD70814;
	Mon, 24 Nov 2025 00:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pq7yVvhc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D455FCA5A;
	Mon, 24 Nov 2025 00:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763944100; cv=fail; b=r2IhfW4APnh2Tn3nwFWkLV6H7mmKV+Gqdb8ZTLmJ6SQxrfcgMozXr3GOqh9XcS5AbR7fbUx4M5Xo6wsOkIYv5xqEIemMtvbD5ryElQguOdr8FqFAYjyHMEFVFV/G5ib+H0U6TEaFOJdTeOOi/D2VTcbFMTWESIwlZdY9SxIbQ+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763944100; c=relaxed/simple;
	bh=ylFVpkrZSMfDzKEt8COCxyzBxofCgWsK9K+BFtm1fJA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=C9+fmhdws+D9Zn2t4G1Dv1Rt1R1OXDuTKRHQotYPssWBiPuUhdyz5fc/pKL6zQuNDAOA/hNSv5xta4KHnJbYAw+fnb2a1pLYVfVbcnGOwWFFSPkKyXXj/LCLqJMGB6Jj/2QLFnS9b6Zh7u32ccRp83pLN96BESNZiCvs0+1u0f8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pq7yVvhc; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763944099; x=1795480099;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ylFVpkrZSMfDzKEt8COCxyzBxofCgWsK9K+BFtm1fJA=;
  b=Pq7yVvhc47pgrNjzJTpIC0BdoUugb6KXm6neAuTd6VEydthWh69SeX96
   aw3CfPZq5X5vNssoLId7Wq4dq/IVPSkddOlNh6yfrk4WVotV8pyhSf1GT
   r6oh+h4MTeNnyT6/xfcXozD1vFai1SaSvWO6UoXgYx2J+t50ae1U2sVNi
   trXPFBflZV5t92i3yp7nBrI9xgqL2T/k71jKYUVWCa4cWhkHuJlPZgifk
   RNcpYZp4PqhY4Sfw63nzSAT7+EVaJ2nEgykSiXPHi3hY6BzR9wpQNuSBq
   wjWbWMY3Jh5l8E0f0Zh/qbnV+Shp3ccbzE6PnzzQIuLL+d6u67vMhMesp
   g==;
X-CSE-ConnectionGUID: Zwv62d3bSZy5RDzwtdN8dQ==
X-CSE-MsgGUID: 3BXyNXU0TACy50Yas6fcIA==
X-IronPort-AV: E=McAfee;i="6800,10657,11622"; a="69804552"
X-IronPort-AV: E=Sophos;i="6.20,221,1758610800"; 
   d="scan'208";a="69804552"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2025 16:28:17 -0800
X-CSE-ConnectionGUID: 8FUBMC8SR/G60tjFOJ2WyQ==
X-CSE-MsgGUID: ZR+2rrsmThyInt1w/GLrFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,221,1758610800"; 
   d="scan'208";a="223146032"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2025 16:28:17 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 23 Nov 2025 16:28:16 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sun, 23 Nov 2025 16:28:16 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.38) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 23 Nov 2025 16:28:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SEvxmjOwkRctqKG6fiimeRiTyWAIcU7vczpUEjYN+MqkFJaTNXRXsWNAC8iJN+qV1mDQF6VtPBU0rIaRAmiBZckoUWJ6T3OIu4E76C9Eu8abGSGxrucpyQ6utb6PsbS/AikQioEDbIcxyMluwJQtiXwFhngksD2cv3enQtzKGWWd1kwaLQ4uVJ4ZOCudDFaQXZfYulhZKVloDzZi43gqhL6NC9yNqh7YbRdzqzwe0aQKpjkk9F9AMVmjdBL+i3zHDDGhmwL6VZu4d2kt6+7kcJTwJiLbXVP0RoLsfecCa9iywXVtVly0+Ld0PAGzt5qY0vf6dPzjcIdo4kuuYSj4gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ylFVpkrZSMfDzKEt8COCxyzBxofCgWsK9K+BFtm1fJA=;
 b=UCDYPDdeB4+Fm1pr8Z54linwtQzsBCq0b5OofVoPcAAiZ2JsFYR1G+ongnaCHBmcRgE6Tj/DjJ64LDBhl9KfoghNluuanbt/Lf2p6I3qMEmRnKKNeavkdrj7lj94RkLe7mAS0DT5siHQGA1JnsIraQ9RYoOEdsGf3Raz1xDYUjaEDV8yPeAMc4lrhDovTM+IPOipgSRectX+d6+XwEaXZZ5mNtmgPSV07oQ4MR2fNuiP9E1L1msnqg7blg3IxzE6bfDIWGHFJHoh/SX1+GiV6uu0CPKbJmEDYI5IrRxzIigVyF4Mz9drWtBD84bKrv/eUoTw5MbExpbo0RB6AgHfAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM4PR11MB7254.namprd11.prod.outlook.com (2603:10b6:8:10e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.16; Mon, 24 Nov
 2025 00:28:14 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 00:28:14 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: Always reflect SGX EPCM #PFs back into the
 guest
Thread-Topic: [PATCH] KVM: VMX: Always reflect SGX EPCM #PFs back into the
 guest
Thread-Index: AQHcWzUVSDyJ16axTkeytixpe1aftrUA/AQA
Date: Mon, 24 Nov 2025 00:28:14 +0000
Message-ID: <4311158801c41117a13afe0136c2807f6d9afbcd.camel@intel.com>
References: <20251121222018.348987-1-seanjc@google.com>
In-Reply-To: <20251121222018.348987-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM4PR11MB7254:EE_
x-ms-office365-filtering-correlation-id: fe68adc6-e618-45c3-898b-08de2af05b80
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?U2o2Vzh1eWRsT0hQTHM1ZHZjRzJLWnFrVlEzUWNnNWk2YW5nbk9tWUhvK0ls?=
 =?utf-8?B?bUc3SWluYjBRZElydWZ6Zy9TL0ZVa2R5N1RxN3ZGNFdlTCthaFhyUWloN3d3?=
 =?utf-8?B?RHduMkFCRVNEU3BNZldyRUNPcWM0aStxdmt2cEVzazc0V1ZDL1JCeWhqVlI5?=
 =?utf-8?B?WFl3QXZVUzJBbVpNaXpKYm9xbVZHV2VDOW5ib1VFSDRuUXFRcFFuU3JjdFgr?=
 =?utf-8?B?THl2cllPeFVKNUgzY3VCSlNiWTVBMHdqTkpTOGRZQktjdlNGMXB0RTlBT3dw?=
 =?utf-8?B?QjFsUWtpdDBRQjBrSWRKbkZKeTVIN0hLODAyNFRiM2pZdGFRaThpb0pCVHZO?=
 =?utf-8?B?dG5mTDBnWnk1ZmlaajVmS05QTWxIU1hCOGN3emtuYXh1ZnpBVVhKNEVnZzNs?=
 =?utf-8?B?aEkySDU0UkpoVlZ2Y0pYUGFnQlpKUHM0dU5BaDNoQnVwWE5TVDRxQ2ptSGtu?=
 =?utf-8?B?QStlemdMOEZIb1BibWV5Y25aVzJmaG4zOENpNHBGOCtkQk9saG8zVVFuUFJi?=
 =?utf-8?B?WFUvTE5ubEJmbldCL2VTTTZWa0FsenI2NlBPVzlBZ2FwUWxIODAzREZRRy9Y?=
 =?utf-8?B?R3VTNzFPYW8vSlEyaUhVR1hMb3pjYktzeHVqWjJEclF3NVRkSEVHUFdLeXds?=
 =?utf-8?B?bjJTTGRraFBJWkUySHNvTm9kNWlNL2VSbTNlVzRUY3l3eGUxRlFmbWJvTHFx?=
 =?utf-8?B?bnN0dk9Fb3V5RU1pUjVodE9xa2hqbEg2VTd1d0NTOEtiZGpsVWpHcGQ4Nlpx?=
 =?utf-8?B?c0xYZ1hXS3RobUNjdlMvTTVqeGUzaEdKMlp4SHZMRGlidG5CckFEMmlRbCtw?=
 =?utf-8?B?ZFhnME5OdjdKQ0ZrYmEvWjNiczZCd1lqQ0EycjlBc1pidTFud2xUSDBBeDFk?=
 =?utf-8?B?VlFwWCtaNzR6aTgvaW12T0dEbTRYNTJuSzR0dDJjQnlWbWdjMzdrdWFTMWIx?=
 =?utf-8?B?VThXTjdiNlJEaWdVeGhMV2ttditvRG9NTldKLzZ5Q2FvRVMvY1RGZm9GRGli?=
 =?utf-8?B?SzY1NWtmdGMwK21vNWlZMmd2SW0xNjhlM1J6MnA1RzRmRTAwOHJ0OHNJbDZZ?=
 =?utf-8?B?OTVqa1pYR2NBWnQ2aW1nVHloNUJZQW9kNmJlSVd5MURUNlVHcHlnVzhXakhG?=
 =?utf-8?B?aUllS1hVODJDSGFUZXVuTUNjbk5iRjNaTEhKWjR2SFlsQU4raHJYVGN2VnV3?=
 =?utf-8?B?c0ZjMmFJbitoeVh5TGUySGY1dGh2ZEdKajI0eERkK0tRemtqcFJEcStBM2li?=
 =?utf-8?B?M284K1kxWkM3RVl1WkpQM2RwYUd0SlZXM1BrVVc5SGc3bHBEZlZSNDRxOXhN?=
 =?utf-8?B?Z0ExQ0c2dmE2b1ZjWWFhQ1BoeklFbnJxWXlxTGdWdkJUdGROZVlhSEJ3VlIr?=
 =?utf-8?B?TWtlT0Q2Sm91Y2M5WFVqanVSUDRGWXVsc0YwN1hJdXFScnh3UWQzQ0pQUlFH?=
 =?utf-8?B?UFlnQ2I1SG1UdzNWb0lZandIWWZuZjMxVXBrQVRhUkdYSWQxY2FCWk5HZVdM?=
 =?utf-8?B?czh4ZHNMQm40OU1oNExZQmwrcVRvY0NSTHRPSDVqSnZWZ2Jvai9rVkdwTGZj?=
 =?utf-8?B?c1lPdVgvNmd3VW1yWk0yRkxUMnI3T2RMeEx5MWwzWFJWaXhWUFcwRzI4bXl6?=
 =?utf-8?B?bXVhb3NzQnAzdmpBblJLMmZJenBQMytOOE1hNUZBRE1IS3kyZVZzTS8zK2pM?=
 =?utf-8?B?OE9XcFM3aXlZSlIxUUg3U3VLY0NhZk5YQnk4bWpwTlNFdE9JdUlNbWFWdWxC?=
 =?utf-8?B?UkR5OU0xUkp5MFZUUy9BUURkZm5PL2hZUWZQOERPYm1EZU1XQ1FnVG84YWY3?=
 =?utf-8?B?clpDMjZ1cDdwQnpVQ09pUE9JRkh0Uy8vVG5kd09lVkRSM0JuMFZZUGF3RFBy?=
 =?utf-8?B?MmI1SEtxT1Awa2JCYzk1clFVc3RaRWxTNzk4Ymw5WWhzbmpLeEJ2Rno5U1NH?=
 =?utf-8?B?bDdVVURKUzdmQnQ3ZXdHcWRkQ3h3aWV4TGxGb0NMRkZ6amU3aWtxalFDbVZL?=
 =?utf-8?B?Q1hidFBxSXNwN2V6S2JWZldwTTRKclF5Z2NkV0JyN0ladmthZWUxUE1EQzN3?=
 =?utf-8?Q?eh+isX?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K2ZZTTVFVndyblVhcis4b1A4NERzWFZnRnpCcFF6aEI3alMrSUYxajhnTWcr?=
 =?utf-8?B?OVZmRU03QytJRG10QWgvbDJTVzlZM0FjandCby9ZM0FWSUNLaHB3Q0JoNll5?=
 =?utf-8?B?Umw0UWYwMkoxOWtvMnU2ank1WWxWdG5qcFJLNTBvMEZWdFU0VTNRVWdia2Rp?=
 =?utf-8?B?ck9EUlNPQUM4M1VQWW11YlN1RGtxbnVwOVdtZDUzRW1JSlFrWUJZOGlzTGRN?=
 =?utf-8?B?aFR0aUpEQlpUSTRGK05HaHRkWG9GaXQyaElWNUIydldyYUN5WXdodE4wMDJX?=
 =?utf-8?B?ZEMyZ1Zhc2tESER5SEEzL1ltMmV3alRTSUhjd2c2c3hBYTNOWGhTL2U3RHpB?=
 =?utf-8?B?Ykw5dHE0UiszN2lkUFg1TFlZYjUwaWxpTUcweEE1TXNESVBuUmRZY0tiSHVP?=
 =?utf-8?B?cVpaNXk3UnpSZ3BhdXhzSm52MnhjQXoxTUZGV0p3NVhsdFI0QlZHSy93STQ2?=
 =?utf-8?B?OE9YYXBvRGtNMlF3OUlLR0ZhdUFoN2sybGFPOVBhMXI0bXk2US9YVWthU1A2?=
 =?utf-8?B?SkZLSUc4YmRkM0F1cnM4cEZVWEg4STU4bEVMM3cwcUgyVlNWNzJYMzVCck9N?=
 =?utf-8?B?c1ZOOGlmQ1hQai9HbERsQks1MDMwVjB3a2FGOFIzck5RTjQ1Q2N2OXZSOWNw?=
 =?utf-8?B?ajhNM0QwRzFCRFlDckdxZ1NrcnlkcDIrT0pxSHloOE1aNnBRMlM5OFR2VUg0?=
 =?utf-8?B?Z3FDREQ5L0tQTFRmYURmM1BKcDErK3c3K3g2SkZIbFRIT1d5bTVrTmt6am12?=
 =?utf-8?B?VU5tLy9uaUNMc0lmMmpjRHMxdkFQaVNSV2tCN0RZVW0rNjBOYXhXbVBhY3ZZ?=
 =?utf-8?B?OE9QM1dHUWVITjNDMHFZOFlNWFN0aDk4NXBleUlwQ0IzcnVzaGl6THVldU5n?=
 =?utf-8?B?Sld1WjNmSjcrUnRZUVFHOUw0Vm8wcXBCNVRrdlc3SkZoSlhtb0kxQTdzZERI?=
 =?utf-8?B?QWZkcjQwVVdnV0NydisrYjdOVU1yVUZ3L1drdWtwcnlJaWV5cWFtK3JtTHFw?=
 =?utf-8?B?aHkvMDFFL1haS3ozTVVIeUNVYkZWUG8wVEFEdXRJcUpCWkRidjEySndMQWxN?=
 =?utf-8?B?ZGFyaGV6MWEvb3JsK0JjNXJ6MWpFNEdxelcwS3NvRHAxMG1wWWRpR1JGTG1T?=
 =?utf-8?B?Y25CellkdklFZzZibFpsWjFGT3NtRHlwZXNxTGZWL01zUmRaWi9reWFlRVlK?=
 =?utf-8?B?YTJEVmtsMEJ3UlZBMUJJUVFZdXJ6ZXp1UUExN1FsWGJoTW5LQ2V6OEhOWFpi?=
 =?utf-8?B?aEg3dWc5elJpWGN6c3cyL0x4RlJLVmJRQjBoTmo2dSs0OEV3VE0zZHFiMTdZ?=
 =?utf-8?B?ZjdYblBIZmVGOTk4d3FwTHBpVlVqa3laSXcyeStZZFpTVit4Ni80OWJ0UDNt?=
 =?utf-8?B?Q2NMTld5ZmROeGhLRzVkRXVOR1N5NHIxNWU4dk1FVmtiSTlsZXJOSDBCTUVm?=
 =?utf-8?B?NUp6MEQxbGJzSk1lWWJnYm1QRzhiZ2xBdDIxRTkyb0RhMkNCdHh5YXF0eU9L?=
 =?utf-8?B?UVg3M09YMW9OS01DVzVjQmlOUWgzVjVsYzRsZVl2RjNPODNGRVBWakhkMDZK?=
 =?utf-8?B?QVhaY2ZEL2w4WkRzWHF4MHlVV1QreUdmbTJMRk9UQTk3TXc5d21LZWQvMnBP?=
 =?utf-8?B?V2poTENOYTZSMnFraGhrdGx0ZjVYcEgrUVA5K0VPOEwvVTdMOGRNZkZIRnBE?=
 =?utf-8?B?b3NpU055YzZDU08zUVBheWNUa21UdGFRT25WTWdTQndtaDN0QVZYalp5dE02?=
 =?utf-8?B?R3ZKTlhDNC8xTGdyYU9wY1dScmNxcW9SMWxuVmtqYmtnNDFWK1oxVWtvNnBW?=
 =?utf-8?B?RmxFQy8wVW1PR1JQOHRSR2l3UmRWYmt5cStuWU84SXNhSFRVSlRSSW1XamZV?=
 =?utf-8?B?STFaZ0hYVlVZZTNGZUFzQkxqOUJTMEdjZFBKejNDZlhpZE42RDJZVzFHMHBN?=
 =?utf-8?B?TUNkeGJiRWhHdjBZSnRES0luQW9QKzRIOXhvaDVIWGp5NktVbW1xaStpcFBp?=
 =?utf-8?B?ZGtnVTZIN1d4Wk50cktwRC9iMnpwYjd6N2JhZ1ZKR1VhSFA3V01RS0NVSVRZ?=
 =?utf-8?B?THYrUkM5cDlhUmVRN2JZTDdXeGpQZmY1eit5M0k3b1VGbXR2aCs1eXltREZJ?=
 =?utf-8?Q?ksn7C6ttY1QmXqAIn+LmmWYJl?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9D1CB6C369E05241B3DFC3D00301C98C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe68adc6-e618-45c3-898b-08de2af05b80
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2025 00:28:14.8359
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Od72aAxql5+nM7vowEkFKKDyTbJ5KHBOSQT+LjVmKh8XhYO9tINgM7beHlB75ZdmQcL3fiLqJm8Zzkq4G9M94w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7254
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTExLTIxIGF0IDE0OjIwIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBXaGVuIGhhbmRsaW5nIGludGVyY2VwdGVkICNQRnMsIHJlZmxlY3QgRVBDTSAoRW5j
bGF2ZSBQYWdlIENhY2hlIE1hcCkNCj4gdmlvbGF0aW9ucywgaS5lLiAjUEZzIHdpdGggdGhlIFNH
WCBmbGFnIHNldCwgYmFjayBpbnRvIHRoZSBndWVzdC4gIEtWTQ0KPiBkb2Vzbid0IHNoYWRvdyBF
UENNIGVudHJpZXMgKHRoZSBFUENNIGRlYWxzIG9ubHkgd2l0aCB2aXJ0dWFsL2xpbmVhcg0KPiBh
ZGRyZXNzZXMpLCBhbmQgc28gRVBDTSB2aW9sYXRpb24gY2Fubm90IGJlIGR1ZSB0byBLVk0gaW50
ZXJmZXJlbmNlLA0KPiBhbmQgbW9yZSBpbXBvcnRhbnRseSBjYW4ndCBiZSByZXNvbHZlZCBieSBL
Vk0uDQo+IA0KPiBPbiBwcmUtU0dYMiBoYXJkd2FyZSwgRVBDTSB2aW9sYXRpb25zIGFyZSBkZWxp
dmVyZWQgYXMgI0dQKDApIGZhdWx0cywgYnV0DQo+IG9uIFNHWDIrIGhhcmR3YXJlLCB0aGV5IGFy
ZSBkZWxpdmVyZWQgYXMgI1BGKFNHWCkuICBGYWlsdXJlIHRvIGFjY291bnQgZm9yDQo+IHRoZSBT
R1gyIGJlaGF2aW9yIGNvdWxkIHB1dCBhIHZDUFUgaW50byBhbiBpbmZpbml0ZSBsb29wIGR1ZSB0
byBLVk0gbm90DQo+IHJlYWxpemluZyB0aGUgI1BGIGlzIHRoZSBndWVzdCdzIHJlc3BvbnNpYmls
aXR5Lg0KPiANCj4gVGFrZSBjYXJlIHRvIGRlbGl2ZXIgdGhlIEVQQ00gdmlvbGF0aW9uIGFzIGEg
I0dQKDApIGlmIHRoZSBfZ3Vlc3RfIENQVQ0KPiBtb2RlbCBpcyBvbmx5IFNHWDEuDQo+IA0KPiBG
aXhlczogNzJhZGQ5MTVmYmQ1ICgiS1ZNOiBWTVg6IEVuYWJsZSBTR1ggdmlydHVhbGl6YXRpb24g
Zm9yIFNHWDEsIFNHWDIgYW5kIExDIikNCj4gQ2M6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVs
LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2ds
ZS5jb20+DQo+IA0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29t
Pg0K

