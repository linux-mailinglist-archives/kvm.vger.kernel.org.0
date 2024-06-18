Return-Path: <kvm+bounces-19900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 55ECC90DFDB
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 01:28:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0564282BCF
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 23:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57BF31849D9;
	Tue, 18 Jun 2024 23:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XGFCrxtg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA1218C3D;
	Tue, 18 Jun 2024 23:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718753327; cv=fail; b=g/0Me5csVm/nUvriqFk2yRUuiilSDHpgixmPAo3ptszV2gTG1IK/e2FC+N5FQXbdZEo3BtMpYrolmGed+6vd70GCg9Ne+r1DvxvifwwvMY7f4muQpYWehVXWdQwKqTzM9ZjT6HyBeKmJQj8RzCVDE0jgDPnwxpUFGIsBECWQhSk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718753327; c=relaxed/simple;
	bh=wAblY5iZajgLjsN/XdtBJDA+sdRfd6VZesn28GxBoqg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Yo1k/fpNDtiUvRuYuAVE/9BYe1WEUJfOqImENLJq70FBz6xRR5I2LL+F1aRELR4ZjL7zl4UIgMC8x4eWPuaZQWjSyQM0+MKnTP4+eimM5md4ky4JLl/0fJzUI624onSTM6lnmi9tIQzywu34zEzU9UuyASOroTBXKfMELjlvwhg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XGFCrxtg; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718753327; x=1750289327;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wAblY5iZajgLjsN/XdtBJDA+sdRfd6VZesn28GxBoqg=;
  b=XGFCrxtgFEUAbli4wHyKclNpo0YT1oJQavvOnI3YjKbRk7ay9Y+GfveO
   3Cy+xts+KH3/4jSb4JCcnQKqsxsSy4SB4aDGZWTxl+LK4ciIK2rQOr1sI
   z+jEwb3OIeVA6tXlteM0ou5Co8QpNRtm+MqnxW3ExXG97du+lnUsc3tuy
   ER/LgozlDETOn8IDJVX7aFEyTaPUjlblbtPdQiKyDIGZE7noRuYcCCzPy
   DQI/A2ud3VCx+AAaYUUMQy2W6kQACUQv3umYlRuF9D4aVEyQjB9YLPn11
   Tb8ouwS85sSndvmhrHIqZQmmdkXNsNC+pVBdQA+XRhgF4fGKw6ELR5Oyu
   g==;
X-CSE-ConnectionGUID: Y+MS0SwVRSafRtau4MzeCw==
X-CSE-MsgGUID: oaiyXPFXQKSsYEdIOoHDlg==
X-IronPort-AV: E=McAfee;i="6700,10204,11107"; a="38184514"
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="38184514"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2024 16:28:45 -0700
X-CSE-ConnectionGUID: Eo1g6DmjSlCmtAXIHgtlfw==
X-CSE-MsgGUID: 4hrNRrKQQnWlZLmsUlChWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="41815412"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Jun 2024 16:28:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 18 Jun 2024 16:28:43 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 18 Jun 2024 16:28:43 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 18 Jun 2024 16:28:43 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 18 Jun 2024 16:28:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUYWIiO8KmqpVS42WQjZBQSFZXmQc1AOuTxMtgX7nz6/rLf8YvEVG1FOHRTG9Lv8N7XQUhdCSJo6ShwiW9rFRe9UDqZQF1LX80YT9bx5oY80CHHopsAOThRSGtP6lykcIm9+A2nQI7CI2gFa0EQ8hG13EDk1EqVlR+JdewG9esHWNVvQdt4ZObczIREdfNoFBetKctdbS06OXG3XcotXDZm7YxE95F2Vcqls4/4Khu6Rv17nTgJEBFoUXMdxRuXagvJjMAnty2Mo0FCF5XrKYbvLXfyenPurgDoeG36C57syz4wc3sRIz21pN6v7PJb385SlG2DjwZuHL8DcXdq4hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wAblY5iZajgLjsN/XdtBJDA+sdRfd6VZesn28GxBoqg=;
 b=k6JVsC/tmV/oEa6wEYAsBAZZTtHSB7SIH5dZJPzyc0ZeM5HlQofSaWUaZFBaBCnElwGjKqprAysaEAuKDlJUk8spBmM0SvGfGrAw+eo3uOCt1fJozAeNfW8+BGvu3eDbhGv7wl9pMPOshkNaG30JpgxgGdOCKdcLZn5mnOpSoeQg2z+6I1lL+NTV0To3uxwDJWdpH8n3DsKRHW0Rm3NAmGk8G80IOyvaZPDGnLK85TvMo3V3BgeLlcQ/f7+0OQY3qk5RNVw/Ceeg5IqQ5bCvGhIlm8Fr/aTCFWeiMMFFwWDhnoCXww0aEdbAJX0X+DF3ouJ9eHqOEnI/aOVwC7cxOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ2PR11MB8298.namprd11.prod.outlook.com (2603:10b6:a03:545::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.25; Tue, 18 Jun
 2024 23:28:40 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%5]) with mapi id 15.20.7677.030; Tue, 18 Jun 2024
 23:28:40 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "seanjc@google.com" <seanjc@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 3/9] x86/virt/tdx: Support global metadata read for all
 element sizes
Thread-Topic: [PATCH 3/9] x86/virt/tdx: Support global metadata read for all
 element sizes
Thread-Index: AQHav+T8hZXUtwqQLUeTYP/hMhfNE7HNaVyAgADFVIA=
Date: Tue, 18 Jun 2024 23:28:40 +0000
Message-ID: <0f2e709dd19b175f7452a46fa45b25eb6b30b729.camel@intel.com>
References: <cover.1718538552.git.kai.huang@intel.com>
	 <210f7747058e01c4d2ed683660a4cb18c5d88440.1718538552.git.kai.huang@intel.com>
	 <a7552693-e0df-4225-9cbf-a5f482900626@suse.com>
In-Reply-To: <a7552693-e0df-4225-9cbf-a5f482900626@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ2PR11MB8298:EE_
x-ms-office365-filtering-correlation-id: d20cdded-712e-4e87-52dc-08dc8fee62f6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|376011|7416011|366013|1800799021|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?ZWJPK2dYcGl3aVFTdUQveWRST1FJN0o3Wkl1ZEw5M3gveUNJdGhpeVFUTXRi?=
 =?utf-8?B?OFlnRUJUTktsbGNMdXpsQlJTeFBXZ0dneUJGdHVmNDZrNmNvN3ZtQXMyVmRu?=
 =?utf-8?B?Z2pxd1JaWjhGc0xKZldCV0xTRkNNQmdPamJhNk5Cckk2OWIxbTJYeElZa0FO?=
 =?utf-8?B?WUNESnYvYTJ1dEV3T0U4SXM5djZPb3RiUnlVbDBjcUdTRTVtQVhaSmVRZ1lN?=
 =?utf-8?B?QXEvRWhDbExMWmRUeWtvTlo3Q1djMDFVMGlRTjkxSkpzNHhheWJNeTZPbCtQ?=
 =?utf-8?B?Wk5BU0FwL2JVZTZPVjhqV3dRKytjMU5oUGdPUUgyUG1FdU5CdkNlbmpxd3A3?=
 =?utf-8?B?Y0xkOHpaV1dTMUFQTDBsZS9QeC9yNjMyK2REd0M1WnowaWNyaVo1dzlsZ1R0?=
 =?utf-8?B?V1Y0azlYcFp1MTZsN1JlRW1KNVFpU0M1c1FNTVF2WFlYV1RncjdBaDZhV0FY?=
 =?utf-8?B?ZnRyTlZobFVVVHJIZG9KcjZ2cjZJQkhTV3N3RyttZCt5NkVQV05IRmp0OXBU?=
 =?utf-8?B?WnRaN0ZIZzhUajYyZmwxTkVmT1N5NkIrZ0kvR3g3UHlPOGcvV0s1UkFjTGpC?=
 =?utf-8?B?N3hrZGdBQ3cwRHRFYTJGSnNmTGxqeUFwYVJhZXNoMlZwUE85RnBmR3NjRUsw?=
 =?utf-8?B?aTI5UFJIRHVIa0tQVENLREhMMzE0aE43RHpWS1hteFQ2Mk05MGZmcUNsSWRL?=
 =?utf-8?B?YkRvQ2NXSXVzZldrd0RJY0hCSmxxUmVSaFlQS1VnSlBaMnk0MGNzSUpVSXIx?=
 =?utf-8?B?VkhJZWNNY2dxcG5aZWRUeDlhVjhuUzE2NEZQRXBJc1lReUR6UURNUjdncjRD?=
 =?utf-8?B?YXl4RFkzZGFOODZyVEhKdHRIZ3FKWElFSDd2YjZpSGx5NXZXZ3dseENXYm1Y?=
 =?utf-8?B?ZVorMTR1YnJEL3JZNXc0TUVOMWJLdktmNThCa3lmNkZnUDZqODBSOW1TbXBZ?=
 =?utf-8?B?ZWV1cGNiUk83NzlvSXJaelgzbGVJNVBQWkNPZjlFSHMrRVBJWjI4OWYraEM2?=
 =?utf-8?B?allEVWI0aWhoRk82S0xUOU9qbG5VU2IvUmwyT01HcFRqWVVQQ3pFUDZLM0RY?=
 =?utf-8?B?MUphaVBrdkdBeDNoOHFnb0lrbzAxR2NMNm96ajhWeGhMd0VUM3Y5UzBEN3ZN?=
 =?utf-8?B?OEFnSVFUdm9NWUExTXgzSnZpczhqb2liMldDVFhyUVlISXp6cGNhUFpUZHdj?=
 =?utf-8?B?RUFZUndQN1lLLysyTHhtMVRFaWJxOTEzMHBLQnNLaDhGNmRTV1FXa1I2Umh5?=
 =?utf-8?B?TGhRQzIzYnlSeUVhajg2V1pQN0Zia0NpQUMvSDNGcHMyRmtGODZabzBkWC9P?=
 =?utf-8?B?akJjbkc3YjdHS04zS2tPLzl2aHc0akxZMTg5bmN6SS9KbVVTOUFGc2p5NklX?=
 =?utf-8?B?eXZ4bHRhUkMzeno4cmV0N3NXUFNuM1EwYi9xY2lnampHUFp5V2ZZaHBSSEdm?=
 =?utf-8?B?U0lYeUszSTFMSUlZMDlRUy96RWk2SUpuNitic1N2U0JWOVFUbFQ2SzVCZjBv?=
 =?utf-8?B?UUNvZ1hOMFdhdHZIc1d0dHBBbEFHTi9xQlhXOXUvUkhuYXJaT2xTcUROQmN1?=
 =?utf-8?B?RGJScUtuSURNclplL0hqSWlBV3Z3ZDRVNnJPMU13NjIxWmZYV2gxb3E1czZN?=
 =?utf-8?B?WUpPNTNpNit6Tm5pQnR3QkxraEVzNWlNaFNDbVBCSTVhT2xZZ3RVTzUwUzFv?=
 =?utf-8?B?OWtTYVZWWkx5UmtRK3JjdzNCYXBaNm1YbkU3K2gySkloVk9lODJWZUMzSGs0?=
 =?utf-8?B?THFYOEtoTkUxczJJMHlMUld6WXJiQm9CajVJTVc0QnpYSkltR0hyaVFIWWFL?=
 =?utf-8?Q?Cp52qgI6Wb552RJqyJCweas5RauduBoYtUIho=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(7416011)(366013)(1800799021)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Nzk3RlRITmNvTXFlTVhSc1ZRRk5BZEZyS0Z3WC9FYyszdHNvQWhUQm5yTEpr?=
 =?utf-8?B?Y09SMUVtY0YrbGo1bmU5S0xiQ0svOXBiYmtINTdHbmRvampkYkZGVEFJNkJW?=
 =?utf-8?B?MytOcHE5ellCSkszTm45UVhYSWM1VEFVWVdaK2puRlE0OVV5NXhrQ2ZFOUxx?=
 =?utf-8?B?dzJZVi82SHdBbkp6NlhKV08zU21sQ2RSVEM3NkFGbFFFYW8wZEFhS3pCNnJ3?=
 =?utf-8?B?ZFFha1BBUTA3eUVJeVhSSjcrODNpK3hKSUFyNllZbEkrczU3Zm4wNVMyZ0Q2?=
 =?utf-8?B?UXcyWmVHUkFCYy9jNWZ0UGJCMlBOQ00rYllFTm5VSFhUTmYvcnBSa2VqWnhW?=
 =?utf-8?B?Y05FV2NSdG5VUUJDeExzVWRhTlJFY1BsOEpWZHJnZTR6d0E0RVFwUTZqOW1v?=
 =?utf-8?B?UVp1MlNXaWJCek5GRyt2Nnc3TWxqT2xTcXFZdzRneDNtVlZCOWx1V1JmY2R5?=
 =?utf-8?B?YlRRQVdSSitBRXkyY1RiaWQ2S0F5WFlkYXFEL3NrY1FBc3czeXpXVDJOMmVm?=
 =?utf-8?B?Tjk1RXNxVlVlSkp0aXhDYmhZYzUyRmlCYXFRL2hVckVFbHY4NkJRUFE1VjAy?=
 =?utf-8?B?T1hFUEJaRjY2Wm1pS2xUbm1ZU1NlTWlWYlg2bXovRHgvU1ZpNFNXQitrK0hr?=
 =?utf-8?B?Z3AyZit2NlVIVVBxME1EQUdiUXBKQi9NalJhNUdBMTczT2FyeE1ETml6dXNy?=
 =?utf-8?B?ajU5QTgvQ2J3bmRzU0RhUDg5M2lOUVhHYjZGQi9ZRVZZbktFZEIyRlBnT0F4?=
 =?utf-8?B?c0Y2dE1UZEV2VkpsQ092SzcvNVdjYzFRT2JlNE0wVFF2QWl5UW9ZMmMvWjNQ?=
 =?utf-8?B?dFBaZkdhcmU5dXJCSE5uamxzZVlobjlMNEdlRDVET203NUlwU1p5WnhzVUxE?=
 =?utf-8?B?ZERGQ1oyVnJPTm5PSTRzR0hmZ2ZDWlhpN2kxSld2Z3FFNVRLMklQcUdaaUZq?=
 =?utf-8?B?bWFRSHhURGZvOXpmK2sycTlVUTA5QlJiYXZIR2hyYW50djh4Uk4zbHNsUzVj?=
 =?utf-8?B?cDhVdEZSNWE3eU5Rc3FUODVYNHZCOE8ybmxYMlFydW1xT3NIaER4MERFMzY1?=
 =?utf-8?B?RldHeDhsenE5S2U2SU9IdytpU1MzVlFmN09qRjl2bjAydG8wNmFHN2NPVCtr?=
 =?utf-8?B?M0dKT1BBS0F6N1ZwRXZKWUgrV0lhRzZTWHZheFNaa0lsd0MwOElYa1ViaDRG?=
 =?utf-8?B?MUw1Q3ZNSUZpYXptbHQwUUNReDQvYi9Wbi9QVmo2OUVQeUw1NHljeThQeStF?=
 =?utf-8?B?UDFQbE55MzNWNUhQS2pOQVFweUlBNkk3K2g3bkoyQUFlYVdUYmN6aGdneUVI?=
 =?utf-8?B?Y0J2WWlUcWZBd2ZJbU9QdU0xV05XQ2Y5TXZDR0Npc0RLdlhZZURCazlsUEFX?=
 =?utf-8?B?OEpsaWxrT2xER1hOMFhyWC9TaEF5RVZOQkFNamJ0YnlEd3U3bjVCNSthTklh?=
 =?utf-8?B?aXpvNk1DQnhCTzZ3Y1pHTEIyMXBpdkVtckFNZWNkdDNUenRFRGtEQXJyRk1s?=
 =?utf-8?B?UWhZcTJmSG0zZW9KNndSREYxdjcwMFVWa0s2QnAxRVRpZnIrR2dLenZxRmFr?=
 =?utf-8?B?d2V0ZzVROHQzUDhjUkMwTjFWeEc0UDFzU084cllaSCtoVEN3OWZudFYweWRK?=
 =?utf-8?B?bm5uVURtZWZVMHNwQ0hqSnBkNU8vQmNsYzEyQjAxWnBMQ0RUbE5neUp5OFIx?=
 =?utf-8?B?bDl4RUdyQ25EVzUvdnI1Y0lvY1FUWkp0WHlaODlXODZFdjMrRXdtUnZRa0dJ?=
 =?utf-8?B?RkwrREZ2bVpDb1Jwek03T2ZzZ3RIblA2elFVdWtKSUhya2JIUllZSEpZelA2?=
 =?utf-8?B?QUpoWGQ0bDVUM0VOdmJjZExXUW1iN3ROZVZSNGMxTEdjMjlOSUdobm1jdUwv?=
 =?utf-8?B?MWwxNHAvKyt5ekR4MmlwSnBvQ0N2VjVNNThtMk03YVFkeWNoK0pPK2lFUEVO?=
 =?utf-8?B?eU45MVBnV0lWdHVjNXhUcjB0RFcyYWczMi9YU2lVTXIyZytEell4ZTE3UHh2?=
 =?utf-8?B?bjFSdlowb0huaGNnNklnK2lic2Z3bG45Q1E3bXZvMlBKSUZUK0xVYnF5Sy9N?=
 =?utf-8?B?QWZ3bGVQVTE5Z3ErakpwdFRlWHZjUVZMUVM4eEsrVCsvRXYxc3hUMkIrOXg0?=
 =?utf-8?Q?q3l7YuM4ZoEv8ZqHlBuRJAkRG?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C137BB145BFCA2469051A2A840691FE8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d20cdded-712e-4e87-52dc-08dc8fee62f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2024 23:28:40.4781
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hINCDTd4ckmi0Tn+fopUU0+tcRwzf8yJefNNJnFYOgzqMppZs5neA1Sk9c/oEMxVTdJVeeukWQKNYdPPy0dapQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8298
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA2LTE4IGF0IDE0OjQyICswMzAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+IDxzbmlwPg0KPiANCj4gPiAgIA0KPiA+IC1zdGF0aWMgaW50IHJlYWRfc3lzX21ldGFkYXRh
X2ZpZWxkMTYodTY0IGZpZWxkX2lkLA0KPiA+IC0JCQkJICAgICBpbnQgb2Zmc2V0LA0KPiA+IC0J
CQkJICAgICB2b2lkICpzdGJ1ZikNCj4gPiArLyoNCj4gPiArICogUmVhZCBvbmUgZ2xvYmFsIG1l
dGFkYXRhIGZpZWxkIGFuZCBzdG9yZSB0aGUgZGF0YSB0byBhIGxvY2F0aW9uIG9mIGENCj4gPiAr
ICogZ2l2ZW4gYnVmZmVyIHNwZWNpZmllZCBieSB0aGUgb2Zmc2V0IGFuZCBzaXplIChpbiBieXRl
cykuDQo+ID4gKyAqLw0KPiA+ICtzdGF0aWMgaW50IHN0YnVmX3JlYWRfc3lzbWRfZmllbGQodTY0
IGZpZWxkX2lkLCB2b2lkICpzdGJ1ZiwgaW50IG9mZnNldCwNCj4gDQo+IHJlYWRfc3lzdGVtX21l
dGFkYXRfZmllbGQgb3IgcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQgb3Igc2ltcGx5DQo+IHJlYWRf
bWV0YWRhdGFfZmllbGQNCg0KcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQoKSBpcyBhbHJlYWR5IHRh
a2VuLg0KDQpXaGF0J3Mgd3Jvbmcgb2Ygc3RidWZfcmVhZF9zeXNtZF9maWVsZCgpPyAgSXQgaW5k
aWNhdGVzIHRoZSBmdW5jdGlvbiByZWFkcw0Kb25lIHN5c3RlbSBtZXRhZGF0YSBmaWVsZCB0byBh
IHN0cnVjdHVyZSBtZW1iZXIuDQoNCj4gDQo+ID4gKwkJCQkgIGludCBieXRlcykNCj4gcy9ieXRl
cy9zaXplDQo+ID4gICB7DQo+ID4gLQl1MTYgKnN0X21lbWJlciA9IHN0YnVmICsgb2Zmc2V0Ow0K
PiA+ICsJdm9pZCAqc3RfbWVtYmVyID0gc3RidWYgKyBvZmZzZXQ7DQo+IA0KPiBBZ2FpbiwgdGhp
cyBjb3VsZCBiZSByZW5hbWVkIHRvIGp1c3QgJ21lbWJlcicsIHdoYXQgdmFsdWUgZG9lcyB0aGUg
J3N0JyANCj4gcHJlZml4IGJyaW5nPw0KDQpXaWxsIGRvLg0KDQpbLi4uXQ0KDQoNCj4gPiAgIA0K
PiA+IC0jZGVmaW5lIE1EX0ZJRUxEX0lEX0VMRV9TSVpFXzE2QklUCTENCj4gPiArI2RlZmluZSBN
RF9GSUVMRF9CWVRFUyhfZmllbGRfaWQpCVwNCj4gDQo+IEp1c3QgbmFtZSBpdCBNRF9GSUVMRF9T
SVpFLCBldmVuIHRoZSBNRF9GSUVMRF9JRCBtZW1iZXIgaXMgY2FsbGVkIA0KPiBFTEVNRU5UX1NJ
WkVfQ09ERSwgcmF0aGVyIHRoYW4gRUxFTUVOVF9CWVRFU19DT0RFIG9yIHNvbWUgc3VjaC4NCg0K
V2lsbCBkby4NCg0KSSB3aWxsIGFsc28gY2hhbmdlIHRoZSAnYnl0ZXMnIGFyZ3VtZW50IHRvICdz
aXplJyBpbg0Kc3RidWZfcmVhZF9zeXNtZF9maWVsZCgpIChvciB3aGF0ZXZlciBuYW1lIHdlIGZp
bmFsbHkgaGF2ZSkuDQoNCg==

