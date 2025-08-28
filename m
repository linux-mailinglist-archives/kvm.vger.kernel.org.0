Return-Path: <kvm+bounces-56078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E5E37B39A09
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 12:34:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1C547C12E7
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 10:33:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47A052E7F30;
	Thu, 28 Aug 2025 10:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aedpnBTO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA62121D00E
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 10:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756377224; cv=fail; b=frNqlKliatdzGo0MRZVoJxFMCdWU+xCgpWqCacIJWyjqPwl95uPQnOBNwySh0O6jhEd7QiUqfg73xboxu5mu9w5BsaIrpfGqO/87UUbUT1Yi+VbIhJjfWBsUIKTmm5REbPMILt+jOqZioGuDuGR1XzSmPesk2WuqT4fFWtusmvk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756377224; c=relaxed/simple;
	bh=ZC6txhlMH+POPII7SXfqDh1jQ3vLL7BgPvQBJxUWJdg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=naK1K6jqmKEaBFuZkBwfWAzdxbrJXG5kvLqbs1qPmg4I9myhfPs1xWRlRL5vnIYvFnZ9vznMGwX2EwMQ0qqBNnQcMqOalo5xQXc/+E9Ycsn/uesIzgX8mEHLyAzRHPpyP/2E1hXKuLXgQ5nUQXmg8098/81vw4B52LJCDT/b/vI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aedpnBTO; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756377223; x=1787913223;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZC6txhlMH+POPII7SXfqDh1jQ3vLL7BgPvQBJxUWJdg=;
  b=aedpnBTOLJFTiNoUejhvwCWTH02ys/MBYe7ktKkMlbRyzv5sSy+TvoR7
   Oh2ExUxAqpyGIHe6v6AtU5C9pYCNwCf1yXUyGqOktcyIPZq2eNbDqdpKA
   vjB9eoRwC+J+E3wiZwg/5CdElM5UyKLMwVuwqiMyDoCDZmb0wz5vO/RRx
   YJ2K9xYrI3rEC0JC7EfFWeNSDMXLJT4fSTyjZAbwykfI7WaPQBzIFCqT7
   82CQeK3CDy0y2yy3AWLEkMFIJaDSeZRtQFJhE/5UjpPsWaqD+kG7in8jp
   9j01mFMN+qyygsIAHc89szptuEhFemJkkZD9j2pNTZuqXyE7ITSZy+rI6
   w==;
X-CSE-ConnectionGUID: c05AbZzSSfC66OG3nJ4ShQ==
X-CSE-MsgGUID: xnCB6ADhQGamNSedTo/Tgw==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="69349538"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="69349538"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 03:33:42 -0700
X-CSE-ConnectionGUID: 3ljb8pzoQRSIhna/euxYCg==
X-CSE-MsgGUID: Sr0A0JnpRduwLgUxNzTtzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="169374138"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 03:33:42 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 03:33:41 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 03:33:41 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.51) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 03:33:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d4d2N/ozFPMZUGyOaU7Y278FzicDBOkoZtBlR8SwXHrSHztK3AxgwIEMdh3QUiL8RU217psVY4mEURFWH5RLNPPBf9iafr/ZkqW9AtcN0RI79b5h41Dpbzfh4VIpZazes6AQHUL6NzZHvxR7PR8e4mUp4ROo6BrrPpjAb9p/gsin/kHtxlhjjER7TMOv3Eet7e7ZpNz24VnDqpAvge8hQD2Akfhc6okeV9rdAoBeIEBhmWWpRdNvCoKNklPCaI0n7eFWSDD6k3ULsRIfwet9H353aAa0TiyKGF71zRURvdqo/wZShTmfK8OYIE8kBBY8VNj2HJoar90xW7nvF8X4TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZC6txhlMH+POPII7SXfqDh1jQ3vLL7BgPvQBJxUWJdg=;
 b=MfHMbe6MfpgU8F3t/hND4YIoIuv+ibbdCXLUwPx67ICE0KKxHsR/ZOKkIBGDdnlRoDLS84YJDfoI6wAcF74gWoB2r9rg+Vae8fbpfZqlDe5GO4wXlrfblSkZ3ax4B1Utn1CKIFI119FPqRCsBVgxr4xLHKz8GaikYWFwfV8V1CEHWS8O4853bI54RDLIIqzES+Trh2Mc8sFbanqn7PEvpEsAqa/CEpC767GCyJ2DuL267i96k9HQeUrZIJNnA0xM036SmFmTncghTODbqO85V84r2JlQzSc90QNYS1WrBthUzdZhhFZ4w6K+Wwcp4qHkMmw6rpUEdLlp4cMkG98o6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SN7PR11MB7089.namprd11.prod.outlook.com (2603:10b6:806:298::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.16; Thu, 28 Aug
 2025 10:33:29 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.9073.016; Thu, 28 Aug 2025
 10:33:29 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "nikunj@amd.com"
	<nikunj@amd.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [RFC PATCH 4/4] KVM: SVM: Add Page modification logging support
Thread-Topic: [RFC PATCH 4/4] KVM: SVM: Add Page modification logging support
Thread-Index: AQHcFdP/eGfeNpsxKkei0uEsxdMRfrR3LX6AgABzVoCAAEHjAA==
Date: Thu, 28 Aug 2025 10:33:29 +0000
Message-ID: <9e214c34f68ac985530020cef61f480f2c5922c9.camel@intel.com>
References: <20250825152009.3512-1-nikunj@amd.com>
	 <20250825152009.3512-5-nikunj@amd.com>
	 <fb9f2dcb176b9a930557cabc24186b70522d945d.camel@intel.com>
	 <86c883c4-c9a6-4ec8-b5f3-eb90b0b7918d@amd.com>
In-Reply-To: <86c883c4-c9a6-4ec8-b5f3-eb90b0b7918d@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SN7PR11MB7089:EE_
x-ms-office365-filtering-correlation-id: 3fdb741a-11a3-483e-b18d-08dde61e5464
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?V09MM0pHcWpoTk5JKzlWTXpZUkxpSGl1TEpoQjI5UDJrTldHK3hPZDlZK1Rw?=
 =?utf-8?B?MGRhYXFXZXUrK2ZxT2NzdXA1cFdIWlBBVUhEQ0NxTVQveTNXWEovMkhWZU1O?=
 =?utf-8?B?dU1XbkZEeVNPa2o5UGcrZHRRcGM3eDdGMEtMVGhXVXpLMVFvOXVWVjgzNnVT?=
 =?utf-8?B?YnZ6ZEo2bjRjVVJWb1Zic2ZCUUJkR0svMmZaNTNNUWhnY2VJd3Jpb0lUaXVY?=
 =?utf-8?B?OUg5UVVnVVVYa3FZOUFMU05MeWh2VmZmdDVmM2VlbU1mbkJMWVYyUHJiQkla?=
 =?utf-8?B?b2hKVXc2WnI3emZHMEI3REg0SEVJSWV2ancwaHZtVHFEZFUyUHlXM2MwZkVM?=
 =?utf-8?B?U1g3UzFGTjVvbjFWU3p4RWd4cEJKbXltRVNxZzNQTHJIZXd2RHlpR1FGOHRD?=
 =?utf-8?B?cUM0Q1B0VytLS3dGQStwQVRoZ0N4VW1lSGxMNmlUZm0zTTc1Z0lJVEJMMHhL?=
 =?utf-8?B?ZERaaU1yNWtxcUFtTVFodW50cmFEdjh6a2JJdWdJaWk0K0RjeXRjOUdUVXFW?=
 =?utf-8?B?RVdieTlteENXMWhndjhjdlNYN2ZDbXFpNFMyZHZ3c3ZOMXFKeFduT2hidExQ?=
 =?utf-8?B?anJ2cUNnYTV5VjJpbkljUUdUUW8wSGV1b2dQU2wxdlBLWDdqbnh3QlRHN3Rt?=
 =?utf-8?B?TCtXSHFKY1FSUXkyaXFpTEM0MEU2bnlmbzBKSW5xczhqRW0zMDlUK0RlMjg1?=
 =?utf-8?B?V0FoRWlGNS93djluZUg1UkNNenU0RmlhUFlUK1lGSGRnUkRPd2lYQlNYU3pm?=
 =?utf-8?B?c3RaYzFQcmtudXpwY0x3ZzhQa0pJZXA2aDVGaXVnZE9jNm5KK213VHJ2YmhV?=
 =?utf-8?B?U2ZhRy9oY1grUWx2akpyWUttZ0VpWGNXcXNCYzJaRXNWS1BBemEwVGcvQUVZ?=
 =?utf-8?B?M2t4c0pkYnZRc2h6WjFCeGRqei9YcXQ2ZysyMWpaaEVvK0pPSHBTK09kR2VG?=
 =?utf-8?B?OGROYnBkeHUrSUhneVkrSDVENmttMWJnS0dFR2ZJbUFOVEI3WGNkcHhaUm11?=
 =?utf-8?B?cUNpdUtuK1AvYnZpT0I4N0pGTW4xS1lWWFRmaVJkVnpONjl3NzhQYnRBbEdL?=
 =?utf-8?B?dDY3VFVodGlqK3VwRjk0NUx5UWQ0TGRDZXlMaVU3UElnNDFtZytSbWJkcUJJ?=
 =?utf-8?B?cWlhalJhWVRndGIvNExGSTBjVGtYRWxIbGJrQWdyUHo5NW5yaEVCR2o2YUVH?=
 =?utf-8?B?RGVZVW5TOTVudURxc3JQaFJjTDYvQm5KYVRjY2V3N2JKd1hUbDVqSXRhMXZK?=
 =?utf-8?B?Nm9MZDMwYmFWQkhlZGtCaUJVOEwxZTIzOTVwdFd1Q21CTjQzSmRnNHdGNDNm?=
 =?utf-8?B?YWk5OUJWWVZWQmtLd1RpUEdVQ1I2cWlySkp0S3FSR0lSU28xdm5SV01BMGhi?=
 =?utf-8?B?NWtyYnJ0Q0lHdTVtTHVCUmorNnRBelQ2VUwzcXZCMCt5WTcyRktRZDBINlJQ?=
 =?utf-8?B?bU1LRDlYR1BnREJwQll4U2MrSjlWVm42K1VpZVNuU1hYR0xDcE1ydGQ4MHEr?=
 =?utf-8?B?Y2gxVVBqQnNNSklkaWlYNUZuQzRCU1lPdmEwbS9ZdzdrMmtibk9EeDIrM0dV?=
 =?utf-8?B?U0F1SUlqbW9HQWRkV0VHWkkvUlFSQ21LZjlDM2dhQXFwWG9DWGtJT1NmM2xF?=
 =?utf-8?B?bDZ5MDV1d3V6MkJVbVA1TDlOUEpZWmloR09DbzhKVGt5N3RabXNBbFQ4dmRv?=
 =?utf-8?B?OXZPK0ZoNENOZForRUlsd1NqaG1VMHJuVVNGTFRmenpBd2JJaDJlWDE2UXpr?=
 =?utf-8?B?TzFpVHB4YjZpT25ES05vV0Z3bFhPMkFsUTZXbHZSUW1FRFNlWVhvUWNNUVE4?=
 =?utf-8?B?R0tsaUs4T1hqYzB0NnoxSnFaeXpXbjhyT0JaS2ZVZzdCcVcwTkplb00ra1Fk?=
 =?utf-8?B?bjZVZ1V4R0lrSkl6eGtVVkRsVDMvTXg1TCtsQktHRnhjdXgwZ1g4cnNxTEVr?=
 =?utf-8?B?MEhQcVNlR3d5QTdPVFdxQ211VEZyV1ROWldabEl4OXAxZ21SN25HWFNCNmoz?=
 =?utf-8?B?UU5GMzM1a1ZnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K2wvMjRmWlc5cWNuYkY0a3BHbitPL1pHWXpzdldjOE4yR2VOT0tlOVF6V0dC?=
 =?utf-8?B?b0lWTmhVZjZEQXhpUzZmNlN6OHNkdzdjV08reGJTR0lGOTJSTHdxL21lRXRj?=
 =?utf-8?B?Q21sTFZSL1BXSjluMkExTEJIaVN2T2Npei8yZ2xPMjJxNEExb211c3NyWTVa?=
 =?utf-8?B?WVFRUGRaOE1rUlhzODNmQkFGT1A5REJPeVJkOFducjBzK3lwRVFKdlRmZjg5?=
 =?utf-8?B?STlrbDJtQmxGNmJhb0I0bithUFZwZy83Z2RhdnFLMlJvaS82cGMxU1RobURB?=
 =?utf-8?B?ajlNb1A2YW9MKzZ0TEF2aXlGbks5WEhCU0t5TEUrWVNVazQ1THlZcFBLVVVC?=
 =?utf-8?B?REtnOGVrSms2RnVMMC9Za3YwT3JqUjV0TGlJekkxQngrVVl6VjFnT09ZWCtG?=
 =?utf-8?B?YUErUDF3VlBWUkR6dzc4RjhHa09PNHdNaE5rZ1RkOW5lZ0ZqWkNrMTFDZkpE?=
 =?utf-8?B?WGdnWHRzZHgwYVNrakZDbFJBdTk2Slp5MkVDUUpxM1h4SGN1QXExVU1tVFNC?=
 =?utf-8?B?RTR1Skwxa1RDOTZ1bWpxcEZnaDE2WjdPYUN4M0tvdVRyQzhWNkcyYkJLVEo2?=
 =?utf-8?B?S0xQZTZLZ3RUeWI4ZXE1NFh6RzlIWCtCejFUSGNPdXl2YlpOcEZiRWxOeFZY?=
 =?utf-8?B?MlpwWTN1dkYxMCsvVVQrVUl0elc5QmF5VFBkbHlrY2pWN0NnNmlvaWZTNmFI?=
 =?utf-8?B?RkhEaUVXRysweUxhdGFOazdpODBMNlhQWmR6cUJwUnM2ajFqeVhZUzJUbnN3?=
 =?utf-8?B?a3FJcHZnOXdpUDNJdytUeHNFQ002T2l6OU5naU4yUkZhQWR6azlpYkp2TzVH?=
 =?utf-8?B?cG5qbTBHc0F2dG9OVm5seFF1ZmFCUXpKcU90UGJ1aStINHBBUWFCYjFaMXI1?=
 =?utf-8?B?MEkyYm5tdm1mV3dLNFZ0M1pDTTltanZWMEd1MVNrbUFPVHJXeFZxSk43WDJn?=
 =?utf-8?B?RGRjdnpVOTM1M0I3Sjh3V1Q5S0wzbGVBRW1XTzk4RkE4dXI0NVlUbGlGUWt5?=
 =?utf-8?B?QnZ6eFNHdGlocThHWlU1ZXhYa2V6R0Q3UktleGczRFdQS211QU51eWxmUWNX?=
 =?utf-8?B?TmJEVTZxSWlTSXZNUjRydVMzbEZzQ1lGa0Qrdm5EQ1JQNzVLSjBBUjFnOS9a?=
 =?utf-8?B?UlRRSFhWanJnNm85b2lDZURNSzJwUWNNaFFMSE9PSEFjUFJWWjhGcGM1aGZl?=
 =?utf-8?B?L2ZQNWNJL0JXSUdhQzlkUEJDL1hpNndYOUJlQVZqVWZOd2tlLy9sMnp2MXVz?=
 =?utf-8?B?SXYvaVJzV1dFOGMzcTA0M2ZMQW1YSUUzb2ZzZklpOGE1MU5ocjlwN2w2WFF3?=
 =?utf-8?B?UTd5M3pnNVhzZjE1eVZJbWlndVpmd3pVdzdnYVZjL0lNZUM2aWM2eGx1NStO?=
 =?utf-8?B?eGJjbE91d1ZoN0U4bmtZMXJsaE84aFpMVGZlaksrcEFFbFJvZ0RIbytvYXhL?=
 =?utf-8?B?czFNK0tJWHJ6MVd2SzJtM1A5WWpPNHcvdmwvaS9hTjRSdzBGbTc4Ym9IY3lX?=
 =?utf-8?B?Z2xwUlJCbWZPZm5OYWVuakIvNFV5Y3hXWG9aVGFnWDdiZm44Z0xxdzg0TG1G?=
 =?utf-8?B?QklnK1JGdmdmcHpRWkxPNyt2emVzQmtTbEFBWkZBSUtsOWtKYnNqSzFDbjNR?=
 =?utf-8?B?Y21sZ0h6ZlpPZjZjeldXR0loS1BrQ0NDaHRlQ1NOYXFMaUFqWjhrMWZsYjdB?=
 =?utf-8?B?WkU3ekcvNUpON01SUVpuMXhOalpHUkpMTUJPZUxHM2hGV0dlV3JxVHBUL2Zu?=
 =?utf-8?B?bmhhdC9tdmk0dWQrNEQ0VjJEeklRbm81aUhFSGgvSVIvYlJLZHFjZHFpVStJ?=
 =?utf-8?B?QzAzT3FuUTFlSXhCWWRML0lDOER0WERTOEM3VUR5SEplTFdzM0pRU1RwWGl6?=
 =?utf-8?B?VEFyVzVsMHF2YmVYcnlXZmNVUTJVSUlJL3A5cXdVbnd3Ny85R0puendhSzBH?=
 =?utf-8?B?WWtwNWNyb2FQMkc1L3cyTHVRalBoK0ZGT2NyeDRPTjBZbHp2TWJNQitNdVNu?=
 =?utf-8?B?SGJtcjNwbHcwKzk3UlVhUnlIQnJSSnR2VUIwNnNkNm15M3NUejBLK1p6ZFRE?=
 =?utf-8?B?bFNMZjBncHd6eXM5bndTdU5QNFAxb213aXphQlJzRUczN1pjRUFiWmRPTFZZ?=
 =?utf-8?Q?Hk6EN6mXSYVM4eERQe8q1G/4L?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <01B2F69FDDE8824B994EE99D7DC8A9B2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fdb741a-11a3-483e-b18d-08dde61e5464
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 10:33:29.5644
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xj4I9s9/FsB7+npbmZikEHwLVWukrOKz0YWx5Ax15oj7eDcUtgiLKScvsS0TpozodUguaX5cDcbtF1knI0LXHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7089
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTI4IGF0IDEyOjA3ICswNTMwLCBOaWt1bmogQS4gRGFkaGFuaWEgd3Jv
dGU6DQo+IA0KPiBPbiA4LzI4LzIwMjUgNToxNCBBTSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBP
biBNb24sIDIwMjUtMDgtMjUgYXQgMTU6MjAgKzAwMDAsIE5pa3VuaiBBIERhZGhhbmlhIHdyb3Rl
Og0KPiA+ID4gKwlpZiAocG1sKSB7DQo+ID4gPiArCQlzdm0tPnBtbF9wYWdlID0gc25wX3NhZmVf
YWxsb2NfcGFnZSgpOw0KPiA+ID4gKwkJaWYgKCFzdm0tPnBtbF9wYWdlKQ0KPiA+ID4gKwkJCWdv
dG8gZXJyb3JfZnJlZV92bXNhX3BhZ2U7DQo+ID4gPiArCX0NCj4gPiANCj4gPiBJIGRpZG4ndCBz
ZWUgdGhpcyB5ZXN0ZXJkYXkuICBJcyBpdCBtYW5kYXRvcnkgZm9yIEFNRCBQTUwgdG8gdXNlDQo+
ID4gc25wX3NhZmVfYWxsb2NfcGFnZSgpIHRvIGFsbG9jYXRlIHRoZSBQTUwgYnVmZmVyLCBvciB3
ZSBjYW4gYWxzbyB1c2UNCj4gPiBub3JtYWwgcGFnZSBhbGxvY2F0aW9uIEFQST8NCj4gDQo+IEFz
IGl0IGlzIGRlcGVuZGVudCBvbiBIdkluVXNlV3JBbGxvd2VkLCBJIG5lZWQgdG8gdXNlIHNucF9z
YWZlX2FsbG9jX3BhZ2UoKS4NCg0KU28gdGhlIHBhdGNoIDIgaXMgYWN0dWFsbHkgYSBkZXBlbmRl
bnQgZm9yIFBNTD8NCg0KPiANCj4gVG9tPw0KPiANCj4gPiBWTVggUE1MIGp1c3QgdXNlcyBhbGxv
Y19wYWdlcygpLiAgSSB3YXMgdGhpbmtpbmcgdGhlIHBhZ2UgYWxsb2NhdGlvbi9mcmVlDQo+ID4g
Y29kZSBjb3VsZCBiZSBtb3ZlZCB0byB4ODYgY29tbW9uIGFzIHNoYXJlZCBjb2RlIHRvby4NCj4g
R290IHRoYXQsIGJlY2F1c2Ugb2YgdGhlIGFib3ZlIHJlcXVpcmVtZW50LCBJIHdhcyBnb2luZyB0
byBzaGFyZSB0aGUgdmFyaWFibGUNCj4gKHBtbF9wYWdlKSBidXQgZG8gdGhlIGFsbG9jYXRpb24g
aW4gdGhlIHZteC9zdm0gY29kZS4NCj4gDQoNCklmIEFNRCBhbmQgVk1YIFBNTCBjYW5ub3Qgc2hh
cmUgUE1MIGJ1ZmZlciBhbGxvY2F0aW9uL2ZyZWUgY29kZSwgbXkgZGVzaXJlDQp0byBzaGFyZSAn
cG1sX3BnJyBpcyBiZWNvbWluZyBsZXNzLCBidXQgSSBndWVzcyBJIGtpbmRhIHN0aWxsIHRoaW5r
IGl0J3MNCmJldHRlciB0byBzaGFyZSB0aGUgYnVmZmVyIHBvaW50ZXIuIDotKQ0K

