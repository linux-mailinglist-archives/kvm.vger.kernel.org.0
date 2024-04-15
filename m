Return-Path: <kvm+bounces-14698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 191918A5CFE
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 23:36:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C27EE284915
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 21:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41E54157481;
	Mon, 15 Apr 2024 21:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O36KQy0O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92B2823CE;
	Mon, 15 Apr 2024 21:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713216979; cv=fail; b=jkQf/+7/lfF1VmBz/gdlaztjgRPk2l4X4KZTK9x3ejStmiOgHkS3+0yt3BAO99KoEl4Oyk/Rpyci2qWRttQ9DKZB4Rb+6tPYj9BiE6n7/oFDvp6ucmQm4YM+AK9JznVX6pu6nZMvAODIrDtfkIRe5+zOwWKHBCYQmkKKlRDdYrI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713216979; c=relaxed/simple;
	bh=rnJdfItZIM0SkSi3VRfAWsmNuU6htUs5EkzAodTOJgw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=at5ubHWInv+3A+2c/alxtHpN6/WCVlPJr7ReOLgb75uTOXTz1rCyPSIQtmuNWf6dLcbJGpPeJO2qgFfyUdlGnz7/WO0YpwqbOEddIuKDd8VzrSkH41eIFBz05el0FJzouTlPmgpSwB6HbhuG+CN3iMzBtreUOlJ8kkCMK6+zDvU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O36KQy0O; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713216977; x=1744752977;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rnJdfItZIM0SkSi3VRfAWsmNuU6htUs5EkzAodTOJgw=;
  b=O36KQy0OB2yl7/QlzGRfCzujpozmVuD0scm7YmJXArAathF91ID7kq78
   fb6xBc+wKReEEgj2MWjQ68aYJ/SpIXZe9Yh4TeF8rG/jMM/Z/ELW4eVWK
   a8vHvI9M8BodPt9lXX7HO7LvG7NkaatxbaOaABiIvj2Zt6d/r+lwZEpAp
   kXkTmvmBoXwGL9y8clImS21rAAD3RHK44iFguwGWKuRuZf2Z+f7Odgdfq
   J+v189UfCv7mBKlXbOykEkvboKXUI4Aw2RR5NxrlrPanqWCyYCq6vvctL
   4ZVs0JA9+oeQSJBxO1jfDkI2Rq6UpjyElDi8vi/BW9Kb/CZ7R5oEV9hnt
   A==;
X-CSE-ConnectionGUID: WgkI0F3dQeq+ahKVZ8FwFg==
X-CSE-MsgGUID: NCHM+QkPQfeGexbVpgOAUA==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="9182705"
X-IronPort-AV: E=Sophos;i="6.07,204,1708416000"; 
   d="scan'208";a="9182705"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 14:36:16 -0700
X-CSE-ConnectionGUID: b+5BnZUrSBmnvK/i6pTGyw==
X-CSE-MsgGUID: k/zG8Jx1Spqe51N8ucbK0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,204,1708416000"; 
   d="scan'208";a="22113154"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Apr 2024 14:36:15 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Apr 2024 14:36:14 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 15 Apr 2024 14:36:14 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 15 Apr 2024 14:36:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RxJcB1VDU79yJqIKIno7uFmydKO0eEznYVcZI8Y9oyIDZcf9bo4PD3UiJMQQGKPZ+jJOM6BZC2c9x3rZ023f26NTznRQL4Zn7tozJwPmhoqf+UfN52+kIRXYdMO+CO8SXbtR+XSS78hBD0JjQisWEptBEApSK/QfMhX3oaCl6mk9Z2SaMh9NhpIj91NdnUIDBUK4aWDi+tjFMvUBcbENsci7za8rxfBIyVox5ERtkoseN32d7kB2lSqPVJ+cdkOY7hYhwISMlmsah1C7T3JDZ8ybkg1WdhWYrLeM86cfKvUkoy0IjdgXkLaSWFKsfsc6mid+pikhEsLVk2SlTGKkZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rnJdfItZIM0SkSi3VRfAWsmNuU6htUs5EkzAodTOJgw=;
 b=RouNoD8QMSaz6EernCSNCRtYFsdu8s22tjgpjI2fjAa+IrWNQkHVwEErWGueljcjLGUFBDlfVRFnrpeUHX95XbA/9iC17TCPxqVrb9Xj+59gpUi67fb9faHCBlzGh4kJg8uU5tFMy2T874ObRgFQgOHD3QpyyWbZhb9HAvYNOeoctrnGW969dOfrGcGLLbB4cdoWHznk0XJkVC97xRIJQWKbvKSDBnvvaHfatABOLTdc4dq5c094G0qdSibiNHRTho/6RdzWtyK6FRO63elZLAx0vUObU1sDCLBCBlgK878MylSKBhU/sTSmdXprnl/1yizwQcIL0F0tkAqXbg3BXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB7771.namprd11.prod.outlook.com (2603:10b6:610:125::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.26; Mon, 15 Apr
 2024 21:36:11 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7472.027; Mon, 15 Apr 2024
 21:36:11 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "federico.parola@polito.it"
	<federico.parola@polito.it>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>
Subject: Re: [PATCH v2 07/10] KVM: x86: Always populate L1 GPA for
 KVM_MAP_MEMORY
Thread-Topic: [PATCH v2 07/10] KVM: x86: Always populate L1 GPA for
 KVM_MAP_MEMORY
Thread-Index: AQHaj2jO+VEgNlPf0Eipl86WfDYsqLFp1bIAgAAFWQA=
Date: Mon, 15 Apr 2024 21:36:11 +0000
Message-ID: <8959c330e47aa78b97bdca6e8beae11697c15908.camel@intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
	 <2f1de1b7b6512280fae4ac05e77ced80a585971b.1712785629.git.isaku.yamahata@intel.com>
	 <116179545fafbf39ed01e1f0f5ac76e0467fc09a.camel@intel.com>
	 <Zh2ZTt4tXXg0f0d9@google.com>
In-Reply-To: <Zh2ZTt4tXXg0f0d9@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB7771:EE_
x-ms-office365-filtering-correlation-id: 1ebfda53-3875-445b-a6c2-08dc5d9411f0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2of9Wt9HlnIVNuHAhMe3Y0bqXsRXLZt9UHcsUJPOzpX7anfdCt1MUZE0STxMsIVf6fqd8YLzCU/9GQ04n+6y+itPiWjwZEfC3iUrQbshsCOjkezEY625kmIyWccvy0T20Lbo3+U1pBz+20KSKaB3oK66U2NuZoUidfu3iuEexCXb7MCi5cLzpfPncVpLaM8Y4HNgcEjM0YpMxf2h319GE/MXjeqQ6pdm42UOLV8dXMZbM3f0wYyfeE0jDYkXISpcZzj9pG3PZtRirrTq10wYf46ZgqLn8/ItD9OeOFe3Wiuk8GWmMze4eLrBlHtxZuBLcIfdnbdH7ZKl1Fob9/O9zze1wDiLPWVqeS9GtiKgU1q6ad7wn0eUjpu7DPFKgtfi7/o/tG8cAjUO8Jlr23FPl0dctM9md9JaOr5T8AxMvkEnnCyrywgbeHBGv/fi24uHRZH4ms2sF0t2UZRBr4W9iL6sG5vvQKR1iWBojajTQtUpLJNWPhpL7a1sfIrL2M30o0Z04n2Fd6dTcxbIAoPmaMFM+8sqBe0J6i9mdJObzyWmrt6+NltvDGpFMjaaup8uVUN8mrwBbeHFzADpySP30VHjNFz/w1mcGvvBadKP6lrzz1iAjcEjw+6uw3QZ8o8cKSowejvwoT3vubIqn91IJ/nVp50m9DGoqRwwagpfP4ltuwbqyLMRNWfyVpTCUFHWVVENuTgq0kgQwGMpa6mFN/YHQj1jZO5j484LAjt9QRw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N2J6b0I4L253a3RkdFZBVy9Tb0F1dWwyd0hXYysyeVUySUc0T2xqUkhrMlpk?=
 =?utf-8?B?OFFIVWtNcWpUa1lVcEQyZGI4L3lnbVpBb0lOUmhEZXUvWVdxOGlUVG90V2Vw?=
 =?utf-8?B?T2VtQVBMR2VvM0h6VGM1ajJCQm1CL0xBWG9rdCtpVGRjZFVteW1wOXNlWW8x?=
 =?utf-8?B?eXhlVEU0R0xaWnVBSTFRNG1iS0NPUlBXb1lBTDUzU3NFRFZmSzJBaXZCRS9q?=
 =?utf-8?B?UzBQeFREQ3hXNWRVRUVIUURTUU1EU2pKS1dlN1VXalcxd0lNQjFnMmRDazBx?=
 =?utf-8?B?bml0dGpWaEc1TmRaS3JQTTgyVmJPcTdnTWorb1NYY1RMTjN0c25nVmNHRGtY?=
 =?utf-8?B?dkMxZVRockRFVlFrVDI4eHZzT2ZaWkpUYmdwaFF6aHRwc0U2RWllYlBCM0l2?=
 =?utf-8?B?ZHJwa3MvaXZJbGRMS3grNW0ycFlYaUswd0E4a3ZEczdsMnk4ZlVEWGNDdEVq?=
 =?utf-8?B?Zmo1cWFvVUkzZGwxekwxcGN0clYrTVdFRjcvcTRzVGYyZjRKV1doKzVLbmZ3?=
 =?utf-8?B?WGw4K05DMGMyVzJNdDFYTFN4WDNHaGEvZXRVeDVlU0ovc0xuOW5scDlDOWJM?=
 =?utf-8?B?Wm51U2c3NXZZeGtWSEdLZHBBR1p3WWlvM1RrY241Z0YzTmk0a2t0bUw0T093?=
 =?utf-8?B?VXRxNjdBRWFzTzBaaWIyd3ZUWmw5bktjTkwrV3VSQ0dWOGZTQXhaUTFORzZm?=
 =?utf-8?B?YVUxd2ZJM2VnYlpkWUR0TEhhRzU1YjhGMFZZd0ljMVFBcjduVzNaMG5sMjJl?=
 =?utf-8?B?Z0hHaXExd2plc3hPTzZZTmI5dVVjemYvVHR6Y3J2d2ljZmh2bGVwTHBnc3RF?=
 =?utf-8?B?a3RiZ2ExUXpac0xYaFpYcnZrczhycEhPUUVuUnJTMENqVElDUXdwZGlnZFNu?=
 =?utf-8?B?T1V0MnNXdSs3WUxFYjRKRTBBNUdJeHB6KzVQc0IvTVFEQjZKaTFlcjVaUHI5?=
 =?utf-8?B?a0dHZmVQaTk5aVh3eSs5TnprcFE3N3MwSzdVUWpDTXJ4R0lCN1hNSkMwMFEz?=
 =?utf-8?B?L3QzcFR4M3JUdElDaHNGeHhUa3E4RmtCNDVNMjA5MVB4UitrR3Vwb2xPUG5P?=
 =?utf-8?B?UHZlV1JWUDlnamRBWVZ2bUdNTmV4Y2tFTFJHSVNiYnpwYkY1ekhpOGg0N0Rv?=
 =?utf-8?B?M1NFZUhaNFl5NjZackZXYVhtdHdMNkE4ZzZvN21KaE8vaCtXQW82eXFrNmpG?=
 =?utf-8?B?RUpFUTRsS0FpcDlaa3ZsNTRpcVhNRXNKMDNONllHTWtzc2hqY0RjWFltSEVl?=
 =?utf-8?B?UGJTVG53d28vbmZtRGh3REsvaVgwR0Q3YllidVQzcDcveFpPWlp4R1k5MzRE?=
 =?utf-8?B?Y1hxV3AzNUtQSFMxVVpkbHhsSitHU2dhNEhZUmlVYUs0MFhUdVVvVmwyeDdn?=
 =?utf-8?B?YlpDUEM2NU1KM0FEWERLNVhDeHMxL1MxOUl2ZkhER1ZQb05Ld2o3cENaWndr?=
 =?utf-8?B?Nnp6STNyZmh5bUZMZkxiNFZpYTkzRCswYVlOOWt6Ui95UG1MU0QyMkR3Skxm?=
 =?utf-8?B?UlN0VUNmSTUwU1poVjg5ek5PQ0xoOTIwZG5MbHVsZGtieCtiK1prL3lqWUx0?=
 =?utf-8?B?TmFUQmd4bXd2NFcvNlFYUXpldHJndGNIUXdLRFZoeEFaYjZ6VS9QTTRNeG9S?=
 =?utf-8?B?NHJYdmwzL3k3RU12cWNTcnVsSk8zN0ZGK3lkc1lTUHBNTjI0MllJVFpkSkNF?=
 =?utf-8?B?ZHBlMUNUU2lTSjdrTzBtWnJJN0hoeVRWUk9DYU9vZGFhczNhR2dRQk1icEpH?=
 =?utf-8?B?MEdRbytlVEJYZlNMM1dTMVBjdzZwTnVuL3VqdktyZm9tMTZteXZPOTMrbFUr?=
 =?utf-8?B?Y2pQUW5sT0oxc0Ztc2d1K1g5QTlHRkxPakNaWXVPY3ZnOW5sbW9IeSswTmNa?=
 =?utf-8?B?UEMweVNQRkI4MHJnYWVjc3F0eHlUMDhDVis0Uy80aWl0bVpmclhtWHByTXFk?=
 =?utf-8?B?R1lobmhwVzRXMXIvRnlzTUFGNTQzMWgrZzRuZFVuaW5tdVF5RGpkMlNMTDc5?=
 =?utf-8?B?Q3dnSlg1L1lobVhJYkhiRFhmL1pySUFEREJPbHV5ZDcralFRS0g1VS9CSTF0?=
 =?utf-8?B?RzVTejdDb2FUdG5mQi8ycU5ZOWVDV0dNYkhzV2l4bkhUK3E0NEtVS28xYlhD?=
 =?utf-8?B?UXFUQlRPbFEzRjR3S3hxcUZ0RHpjcEZ0YnJBbzQ3TmJZZTJFQ0wyV1RyUjdR?=
 =?utf-8?B?UEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F104F4A73F176C40AF6478843D6DCDCB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ebfda53-3875-445b-a6c2-08dc5d9411f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2024 21:36:11.7130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ClE+amnObtpg9BnxqJq/y6LblwxHGlV8V8+mInXnUpx4JR0VmIlBg86bki/f0pMI1b5XERkeJOFTtXya2Un3/MFq68Ug20QXM8TO87S0rAU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7771
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA0LTE1IGF0IDE0OjE3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEJ1dCBkb2Vzbid0IHRoZSBmYXVsdCBoYW5kbGVyIG5lZWQgdGhlIHZDUFUgc3Rh
dGU/DQo+IA0KPiBJZ25vcmluZyBndWVzdCBNVFJScywgd2hpY2ggd2lsbCBob3BlZnVsbHkgc29v
biBiZSBhIG5vbi1pc3N1ZSwgbm8uwqAgVGhlcmUgYXJlDQo+IG9ubHkgc2l4IHBvc3NpYmxlIHJv
b3RzIGlmIFREUCBpcyBlbmFibGVkOg0KPiANCj4gwqDCoMKgwqDCoCAxLiA0LWxldmVsICFTTU0g
IWd1ZXN0X21vZGUNCj4gwqDCoMKgwqDCoCAyLiA0LWxldmVswqAgU01NICFndWVzdF9tb2RlDQo+
IMKgwqDCoMKgwqAgMy4gNS1sZXZlbCAhU01NICFndWVzdF9tb2RlDQo+IMKgwqDCoMKgwqAgNC4g
NS1sZXZlbMKgIFNNTSAhZ3Vlc3RfbW9kZQ0KPiDCoMKgwqDCoMKgIDUuIDQtbGV2ZWwgIVNNTSBn
dWVzdF9tb2RlDQo+IMKgwqDCoMKgwqAgNi4gNS1sZXZlbCAhU01NIGd1ZXN0X21vZGUNCj4gDQo+
IDQtbGV2ZWwgdnMuIDUtbGV2ZWwgaXMgYSBndWVzdCBNQVhQSFlBRERSIHRoaW5nLCBhbmQgc3dh
cHBpbmcgdGhlIE1NVQ0KPiBlbGltaW5hdGVzDQo+IHRoZSBTTU0gYW5kIGd1ZXN0X21vZGUgaXNz
dWVzLsKgIElmIHRoZXJlIGlzIHBlci12Q1BVIHN0YXRlIHRoYXQgbWFrZXMgaXRzIHdheQ0KPiBp
bnRvDQo+IHRoZSBURFAgcGFnZSB0YWJsZXMsIHRoZW4gd2UgaGF2ZSBwcm9ibGVtcywgYmVjYXVz
ZSBpdCBtZWFucyB0aGF0IHRoZXJlIGlzDQo+IHBlci12Q1BVDQo+IHN0YXRlIGluIHBlci1WTSBz
dHJ1Y3R1cmVzIHRoYXQgaXNuJ3QgYWNjb3VudGVkIGZvci4NCj4gDQo+IFRoZXJlIGFyZSBhIGZl
dyBlZGdlIGNhc2VzIHdoZXJlIEtWTSB0cmVhZHMgY2FyZWZ1bGx5LCBlLmcuIGlmIHRoZSBmYXVs
dCBpcyB0bw0KPiB0aGUgdkNQVSdzIEFQSUMtYWNjZXNzIHBhZ2UsIGJ1dCBLVk0gbWFudWFsbHkg
aGFuZGxlcyB0aG9zZSB0byBhdm9pZCBjb25zdW1pbmcNCj4gcGVyLXZDUFUgc3RhdGUuDQo+IA0K
PiBUaGF0IHNhaWQsIEkgdGhpbmsgdGhpcyBvcHRpb24gaXMgZWZmZWN0aXZlbHkgMWIsIGJlY2F1
c2UgZHJvcHBpbmcgdGhlIFNNTSB2cy4NCj4gZ3Vlc3RfbW9kZSBzdGF0ZSBoYXMgdGhlIHNhbWUg
dUFQSSBwcm9ibGVtcyBhcyBmb3JjaWJseSBzd2FwcGluZyB0aGUgTU1VLCBpdCdzDQo+IGp1c3Qg
YSBkaWZmZXJlbnQgd2F5IG9mIGRvaW5nIHNvLg0KPiANCj4gVGhlIGZpcnN0IHF1ZXN0aW9uIHRv
IGFuc3dlciBpcywgZG8gd2Ugd2FudCB0byByZXR1cm4gYW4gZXJyb3Igb3IgInNpbGVudGx5Ig0K
PiBpbnN0YWxsIG1hcHBpbmdzIGZvciAhU01NLCAhZ3Vlc3RfbW9kZS7CoCBBbmQgc28gdGhpcyBv
cHRpb24gYmVjb21lcyByZWxldmFudA0KPiBvbmx5DQo+IF9pZl8gd2Ugd2FudCB0byB1bmNvbmRp
dGlvbmFsbHkgaW5zdGFsbCBtYXBwaW5ncyBmb3IgdGhlICdiYXNlIiBtb2RlLg0KDQpBaCwgSSB0
aG91Z2h0IHRoZXJlIHdhcyBzb21lIGxvZ2ljIGFyb3VuZCBDUjAuQ0QuDQoNCj4gDQo+ID4gPiAt
IFJldHVybiBlcnJvciBvbiBndWVzdCBtb2RlIG9yIFNNTSBtb2RlOsKgIFdpdGhvdXQgdGhpcyBw
YXRjaC4NCj4gPiA+IMKgIFByb3M6IE5vIGFkZGl0aW9uYWwgcGF0Y2guDQo+ID4gPiDCoCBDb25z
OiBEaWZmaWN1bHQgdG8gdXNlLg0KPiA+IA0KPiA+IEhtbS4uLiBGb3IgdGhlIG5vbi1URFggdXNl
IGNhc2VzIHRoaXMgaXMganVzdCBhbiBvcHRpbWl6YXRpb24sIHJpZ2h0PyBGb3INCj4gPiBURFgN
Cj4gPiB0aGVyZSBzaG91bGRuJ3QgYmUgYW4gaXNzdWUuIElmIHNvLCBtYXliZSB0aGlzIGxhc3Qg
b25lIGlzIG5vdCBzbyBob3JyaWJsZS4NCj4gDQo+IEFuZCB0aGUgZmFjdCB0aGVyZSBhcmUgc28g
dmFyaWFibGVzIHRvIGNvbnRyb2wgKE1BWFBIQUREUiwgU01NLCBhbmQNCj4gZ3Vlc3RfbW9kZSkN
Cj4gYmFzaWNhbGx5IGludmFsaWRhdGVzIHRoZSBhcmd1bWVudCB0aGF0IHJldHVybmluZyBhbiBl
cnJvciBtYWtlcyB0aGUgaW9jdGwoKQ0KPiBoYXJkDQo+IHRvIHVzZS7CoCBJIGNhbiBpbWFnaW5l
IGl0IG1pZ2h0IGJlIGhhcmQgdG8gc3F1ZWV6ZSB0aGlzIGlvY3RsKCkgaW50byBRRU1VJ3MNCj4g
ZXhpc3RpbmcgY29kZSwgYnV0IEkgZG9uJ3QgYnV5IHRoYXQgdGhlIGlvY3RsKCkgaXRzZWxmIGlz
IGhhcmQgdG8gdXNlLg0KPiANCj4gTGl0ZXJhbGx5IHRoZSBvbmx5IHRoaW5nIHVzZXJzcGFjZSBu
ZWVkcyB0byBkbyBpcyBzZXQgQ1BVSUQgdG8gaW1wbGljaXRseQ0KPiBzZWxlY3QNCj4gYmV0d2Vl
biA0LWxldmVsIGFuZCA1LWxldmVsIHBhZ2luZy7CoCBJZiB1c2Vyc3BhY2Ugd2FudHMgdG8gcHJl
LW1hcCBtZW1vcnkNCj4gZHVyaW5nDQo+IGxpdmUgbWlncmF0aW9uLCBvciB3aGVuIGp1bXAtc3Rh
cnRpbmcgdGhlIGd1ZXN0IHdpdGggcHJlLWRlZmluZWQgc3RhdGUsIHNpbXBseQ0KPiBwcmUtbWFw
IG1lbW9yeSBiZWZvcmUgc3R1ZmZpbmcgZ3Vlc3Qgc3RhdGUuwqAgSW4gYW5kIG9mIGl0c2VsZiwg
dGhhdCBkb2Vzbid0DQo+IHNlZW0NCj4gZGlmZmljdWx0LCBlLmcuIGF0IGEgcXVpY2sgZ2xhbmNl
LCBRRU1VIGNvdWxkIGFkZCBhIGhvb2sgc29tZXdoZXJlIGluDQo+IGt2bV92Y3B1X3RocmVhZF9m
bigpIHdpdGhvdXQgdG9vIG11Y2ggdHJvdWJsZSAodGhvdWdoIHRoYXQgY29tZXMgd2l0aCBhIGh1
Z2UNCj4gZGlzY2xhaW1lciB0aGF0IEkgb25seSBrbm93IGVub3VnaCBhYm91dCBob3cgUUVNVSBt
YW5hZ2VzIHZDUFVzIHRvIGJlDQo+IGRhbmdlcm91cykuDQo+IA0KPiBJIHdvdWxkIGRlc2NyaWJl
IHRoZSBvdmVyYWxsIGNvbnMgZm9yIHRoaXMgcGF0Y2ggdmVyc3VzIHJldHVybmluZyBhbiBlcnJv
cg0KPiBkaWZmZXJlbnRseS7CoCBTd2l0Y2hpbmcgTU1VIHN0YXRlIHB1dHMgdGhlIGNvbXBsZXhp
dHkgaW4gdGhlIGtlcm5lbC7CoA0KPiBSZXR1cm5pbmcNCj4gYW4gZXJyb3IgcHVudHMgYW55IGNv
bXBsZXhpdHkgdG8gdXNlcnNwYWNlLsKgIFNwZWNpZmljYWxseSwgYW55dGhpbmcgdGhhdCBLVk0N
Cj4gY2FuDQo+IGRvIHJlZ2FyZGluZyB2Q1BVIHN0YXRlIHRvIGdldCB0aGUgcmlnaHQgTU1VLCB1
c2Vyc3BhY2UgY2FuIGRvIHRvby4NCj4gwqANCj4gQWRkIG9uIHRoYXQgc2lsZW50bHkgZG9pbmcg
dGhpbmdzIHRoYXQgZWZmZWN0aXZlbHkgaWdub3JlIGd1ZXN0IHN0YXRlIHVzdWFsbHkNCj4gZW5k
cyBiYWRseSwgYW5kIEkgZG9uJ3Qgc2VlIGEgZ29vZCBhcmd1bWVudCBmb3IgdGhpcyBwYXRjaCAo
b3IgYW55IHZhcmlhbnQNCj4gdGhlcmVvZikuDQoNCkdyZWF0Lg0K

