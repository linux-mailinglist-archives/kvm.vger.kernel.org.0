Return-Path: <kvm+bounces-23031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7010C945D99
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 14:02:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2568F283586
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 12:02:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 462281E287E;
	Fri,  2 Aug 2024 12:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SnNHX5nI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734AD1C2327;
	Fri,  2 Aug 2024 12:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722600130; cv=fail; b=Maj+1UQ0YUVZ+9vDNUA30J7lCAVzyzDb6Gnn0M8B66ErfG16Q0+UJ2NsDnMpsWTO4ZlKtwxkUjRkdH059jJaDlmhpMHRY7aGBrP5jUelID6hmH74mAkDrttIfBpnRg5t06OGH/uyOzApGH8bgwli2BKph8Ld4mnZulud315pJXA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722600130; c=relaxed/simple;
	bh=SBa8zq9slwCBSrCVR5dt28nr8H4NLhsnUhJp62b658Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kl/tmejiZgVZYY7BT3xd7lL8eD6duL1IJEl2cMb/mPc4r1y3GZBzXRVuEdYLVAY4TCKMVZkmfMUCBaLGHpw3wW3I8XDPVXu4bEBxGgXhJmxd/045k19ltXTowOgosgrjbiEx7TVZY5Gp6E0A7toia/cMCEOci+V8l+yNntVVZ9M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SnNHX5nI; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722600127; x=1754136127;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SBa8zq9slwCBSrCVR5dt28nr8H4NLhsnUhJp62b658Q=;
  b=SnNHX5nIY47y9kjKYL8c/wJUZGG1Xf5S4hFmUykZHYvNdj1y/yQoDZ8b
   XxBDjKA73vL7+oM552M+ePoe0wR3/yyVLDJN1Q6QjzeXYPd2Eo88Ec1eQ
   wblAtzhwteadZQGLg+0ZXHZELdBHRfuOjBNcPhAxqUyere834kwaKc0eE
   WhD5rbhg7+aii3kDtVs75Es1iVPWGY49q5W47igaL6BXej3vLO/sC3tRZ
   AMMJAMhzTxsXMJb01615DoSqsQvlLjEE4VTqYG4VhwsfpobKkdoUb6QIG
   xRU3t9zRmH/2TH7AR7+IMngHsHjVeT7N3ol6IhqXDdMMd5ONJ0tS97mmL
   Q==;
X-CSE-ConnectionGUID: RS75LQTTSTiECyFE6xMkyA==
X-CSE-MsgGUID: J4zWeUwuQGOw2cehfGGyrg==
X-IronPort-AV: E=McAfee;i="6700,10204,11151"; a="24382669"
X-IronPort-AV: E=Sophos;i="6.09,257,1716274800"; 
   d="scan'208";a="24382669"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2024 05:02:06 -0700
X-CSE-ConnectionGUID: 7lPNGGyuSlmtPi/OGimeZQ==
X-CSE-MsgGUID: 3wHBzpgcQmybzUZkknrH8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,257,1716274800"; 
   d="scan'208";a="86295031"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Aug 2024 05:02:07 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 2 Aug 2024 05:02:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 2 Aug 2024 05:02:05 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 2 Aug 2024 05:02:04 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 2 Aug 2024 05:02:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oSpeYp73NCyivy3vcmMSIkmcKinUBr0AMVoM/iRw2+Em7CQre55fL8USLMMamabejv1XT77DTpZWqeTVvI6K1DYdz1D2ZN9DwdA621ZGK6pT0xrl9yXnS1fCIH+blFOVfyFCljjYDVjmT7OveT4ChL9GLMWj4w16g3/kpBL5UVhFgzeVLMs4tVYHL/2sKM6I51qdLP2LnTn0uVJoDo1GKb2scFxUuga+SOi9RwgmuOyg9nwLLT5iMvs7kJ+EUPNDQi7/lGPk84TAUz7YId5OXbN/a3sm1p4WHKpAWY9z+fsfDCZnkTD6qyw47AFjdJPLLFNx4xG6Pgw30VcjyP37ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SBa8zq9slwCBSrCVR5dt28nr8H4NLhsnUhJp62b658Q=;
 b=I8td5gCPAe1N6+sppY/i6AJ8/ywXCemebHYzIDNuFMUPXDkO38YcZnecwNZwc1ii/wvLApafNzaRKBzYv/55lT23/DSK7bWj+JZyu23zZ7MrnjtV8frss92KyUG1T2o3q6M+E9uLOEKPLNYkc8B57Fe/RFHDC9c8bDbkOOW7HIn6HXayejX3Spj6sKgxOFruX6+3hEFpgauWOvJdyHf/tx1I7M2HVWWCizBWfFmnFPO9PJ00ojbR7RQnuzYyn8xTFZzcMsRkfko+fRr8TkDIqVRCjU99TANVzLIUip0yyvEjMYqkxPKxx7FcHSvXG16tkWpSKtL25Vv0efJYifVzrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.23; Fri, 2 Aug
 2024 12:02:02 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.024; Fri, 2 Aug 2024
 12:02:02 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Gao, Chao"
	<chao.gao@intel.com>
Subject: Re: [PATCH v3 4/8] KVM: Add a module param to allow enabling
 virtualization when KVM is loaded
Thread-Topic: [PATCH v3 4/8] KVM: Add a module param to allow enabling
 virtualization when KVM is loaded
Thread-Index: AQHauTfPMFWPSBOIHEiZJ+sXeeXGULIUNR6A
Date: Fri, 2 Aug 2024 12:02:02 +0000
Message-ID: <7e12a22947bdaf7fb4693000c5dbcf24a20e6326.camel@intel.com>
References: <20240608000639.3295768-1-seanjc@google.com>
	 <20240608000639.3295768-5-seanjc@google.com>
In-Reply-To: <20240608000639.3295768-5-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3 (3.52.3-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB4951:EE_
x-ms-office365-filtering-correlation-id: bc86b480-52de-4180-55a0-08dcb2eaebad
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZktYVmwwTnBJZVBJVkpITDUxdVlTMklNN0ZMY3FEM0dCUnJLUW84dS9vcGRR?=
 =?utf-8?B?OFA1aUVXajJOa0NuTmhiVGozWWx2WFhta2YyVXJWZnFJS0d0aExORW5wQ2Ji?=
 =?utf-8?B?L3U0TkZ1NjY4YjBuc3hWdTZxYlRtUnZsbktjSlBhZlZwSWRsWGovaVRxZFlD?=
 =?utf-8?B?TnFMYUM3cU1VcGlmV3E3djNYcWZDR2UxVERGNXZCSmpIMTY1bmZpQU5xVVBu?=
 =?utf-8?B?Qnh2dnJoTkpSS25FM1FMbThWQm5IWjV5a0g1U0NvRmVteG9rV1RmSXNVL0Vn?=
 =?utf-8?B?MG9WVFh2TkpzY0FTZEhaQVpNQmpXbFlvTjA4enFsTmo2VEk2K3QvNFJza0pz?=
 =?utf-8?B?SjRyQWQ4NVFjRlpHaThNdC9WWlEwVCt0bmdnbXgyM0pIUE9yaTgwWW5FWGxJ?=
 =?utf-8?B?SDVHK1BxRFVVL0dwZ2pTM0owSDRKcUloRFpEa0JWVmxXdjF2TEFSczRMY1Zl?=
 =?utf-8?B?TFprSUxmbTRsY1IwTWxMWFlGRUNwYUJQOEZTbjF3cGRBVFdJM1FuRTNzbU1Q?=
 =?utf-8?B?UXZneW5hL3FlMWJhTUlkbXd2UlFuRUY3eDQ3b096U09KY2tlbXlEVHpYMzZz?=
 =?utf-8?B?YzNuV2tHK2xnYWZHcjhZTjczUWlYZTErbkdjUnEvS1VMZWRqdkg2RW5ETnFt?=
 =?utf-8?B?RmNPZkkxdllOZ1hZbzBKL0ZQdVVubUs0V2tEUjcrWXgzc3RVUTJTcGRuTnRl?=
 =?utf-8?B?MHg0eTFDc2dEb002STRLVXRONnk2eEg2QlpVNUtFcVdIb1FzZ0l4eEx2NzZE?=
 =?utf-8?B?RkRka2F3UHQreFBmZDlXeVNGeUJCWGlrelVQZkFpREg3aU53V01WZll4Z0p4?=
 =?utf-8?B?L3ZPYlZnN2EzRURtVFV4WU9nTFdiSnFzQTJtMzZhYjlpbnVmSVNUcXc2YXlv?=
 =?utf-8?B?R0FrZzFjMkJxMkhQYTFhNWtYWkhTbmhZb0RML2hQZFEzOUpoVEsrMWdwc3RV?=
 =?utf-8?B?bWlUWlVIS3VXaGQ0VGFuQUNXZklvU3NtMnUrZFFTZk9zS3B4QUJpVG96NGVN?=
 =?utf-8?B?RmhCUnkrQjdURnVaYUlqaU1FM1JpRUlyRE1TSm1zam12Yjg2RStoWVFoVERH?=
 =?utf-8?B?bFhaempTWDJ2VVVZNE85N2RqV3hqUXgrQ2xRSjI4YkVlRHZpR2VHcWRSRU5J?=
 =?utf-8?B?Ykdza0Q3b2xjSHhEQ0FzZHlVMzBuWnhzYWFvNW80cFM3VUFKeGkzcmc1SHQv?=
 =?utf-8?B?L0hYU3FUM0NxUHZCY3JsRHQ1bUt2M3d3U3B6K1VMREVRdTBwdFpKbWNmMjB5?=
 =?utf-8?B?d3JzOEN4Q2NhTy9JQXFlOTNQVHVUeWJ6aXVBSE13QTlwYWIzVkVIYmpSSHpi?=
 =?utf-8?B?UndpZ2tCWUtWTi9jL0VYMC96d0dKY28zMlFqV1VMQzBEZzBTSU82eW9URlZN?=
 =?utf-8?B?S3poZ0NIZGFWUUR4YXZNcEppVUkvV1NZWUp3Tm5JZWdiRXI5TTd4OC9uUEx6?=
 =?utf-8?B?RXJDdHROUHNRMWFTTk5NT1RVazZmMjlvS3UxTTZvSEl5R2FtVlo2RGV2NXMx?=
 =?utf-8?B?NU1tWFA3cHZQVmJTNGtMSEtGUVV1czJZUFd1WTdCbmJuN0t2WHA0QzNxaVZD?=
 =?utf-8?B?NTBueUhqek1sWTR0WVdWU3FvY3BEUjdtZ2J4d2Jiak5VUHdSaEIvVjlDNS95?=
 =?utf-8?B?cnRKUmJLN1RqWnFGRElaa1FiZXFnUVlHSHdMWFVJODQ5Uy9EWE4wWjB4eWRy?=
 =?utf-8?B?Tkt3VmMrNHBpSkorSlNmWWpUVXFBdGhLRlJvNEt5RklxdHgrQ2FQNHpBaU5R?=
 =?utf-8?B?UG1xS0pINVJNV0JsQ0hLQ3h0WTNkM0g1ZGxvcHJSenI4eFhkbStnTjNVRzlJ?=
 =?utf-8?B?bWpYdSt5b3FWRENTcGtnZ00ycTArOXBudmJpa0FCMDc4dGZRQzZvakYrNWVI?=
 =?utf-8?B?VlpQRXA5QXNOWVZzOXFVWHloK2lKL2VwY09zWGhadDhCTUE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YjRHeDZGMmdHSEJYNCtadis4bElCa1gwNXNVeURZOFRmMTArWnRCM3F2VU45?=
 =?utf-8?B?WFhMcWY5VHFmbzRxWW5kMjZrSS9jQ0hCNGZaK3UzOUhYbDQwOFdYUUNKdlRH?=
 =?utf-8?B?KzhFRTV1aUN5eDRxNFJIUU1nRzFCYnorUTdjSTN5S3J6azEwN3JoTHBGRUY2?=
 =?utf-8?B?aGo4ZzNPM1dSR1RKU3pXZHkzLzdvaGYyQTdiVHNndHFld2hlQUJnc2N2cjhW?=
 =?utf-8?B?TTBnWWEvY0Rtd1k2ZW5ZQ3UrYXFiaXI1MEtvV2NBOW0zeUFlMnJIaUtZMUpB?=
 =?utf-8?B?UkV0UmFVOW9RTG1UeDhQTWlzZkJzdzFTM3ZGeVp5eEdHbUNqcTdaQnpVU3NG?=
 =?utf-8?B?bDNzZkd6MDV1WUZQbzdlZmpEdVl1TWtwWXBSd3NkdktqQWhYempXSmVFc3VX?=
 =?utf-8?B?TjJ0bjk1aTVUcENhUWd5TmllNGtlZ3dUZjNCSmdra1FxTVhmQ21VSWtGZ3Fh?=
 =?utf-8?B?VmZKT1dlVi9xRGE4WXptcnJaMDZsUElCNUNUNzE4M1pBUXVtaDdQVExjem55?=
 =?utf-8?B?YUxhVURIdTVydzE1a2ZSQnVpTGtmb0MrQXlubmxOQ0pIT3l0d2ZlOW5NRHlX?=
 =?utf-8?B?SmxCZnFnY09rYTVNVE1jKzVQVVpvMUtSL3BaMTRaaWxhelNBSjVmODFzNGxk?=
 =?utf-8?B?K0xQcTBKVkhjLzlMNVNNUjMyNzlLWktrTzFocGR6NEhYLzUyV1drWXdJWTJM?=
 =?utf-8?B?czlYbWxtR25NdzNhYjJ0OVRMRjExcFB4eVZrUEhwdU1MSXdYR3I2QmlPRFpn?=
 =?utf-8?B?bXVuMEVySFZGOUNza1JSWWdHRGcrRzFXWlZmSlV6V0tTK0dRYllFdlVtVDNm?=
 =?utf-8?B?ZjFMUENCS0tuNGJjUkhzY3A1UkZLeHJPNS9GVkptUTA4NUgwZEhqL0dKSWJQ?=
 =?utf-8?B?a20zb3VTY2tTNVlFajIvK3ptaWIyelhrcGxnRzNQTzNUcE00czFEU0FiQXlM?=
 =?utf-8?B?OERKMmxFQk00Ym1oQ0pwaTAzU0Ura2tvalpDcWZ2dmlLRzRiaENaZFY3ak5M?=
 =?utf-8?B?UHFHVmQxd3JUeDRkb3R5ZS9DOGRuS3c1WTJLR0IvYno2VUlDeXoxZHN1ZS9v?=
 =?utf-8?B?S1RtUG0raUdHYlkrVk56Ry9MSUhEZXVnVGkvZmRobURiaVVERDNRWTg4NHZv?=
 =?utf-8?B?N2swN3c3T09tYk1pRllaUnlMMXJvVTRySm1SeENLbWQ4dG5yQnl6U3kzNHJP?=
 =?utf-8?B?UDBlbnBCbXZ0WW50U0h5eHlqQlJxeVQ2MmJiOFpsaUVTTmpVUE1lUzNzRGFR?=
 =?utf-8?B?TUZ1ZGpHT3VEeHhhUmoxRzJ0RVlISXhJNUFYeTRmUUZzS2FpSFpPMjNGR0JF?=
 =?utf-8?B?VUtVZHdnQmJ4dCtlc3JhKzZ6d1MyUHRRK3N2ZUowemFjL1VwbXVGZmsrRi9Y?=
 =?utf-8?B?a3pidmZ3TFozSGEydEZEQ3RYTCtGWGg1TWNWTm04UnZpMlR2WXpGUDBhOHR4?=
 =?utf-8?B?VXQycFZubmdsbnd0VVBLd0IxZGV0bWpMMEtHQncwcnhDcUtqYnlyU1VQZjJo?=
 =?utf-8?B?eVBpNmlweGdMSEx3R1g3OUR3TmY3R0pVVlVNTUl4VlNPc2pKZHZTNXhJYWVR?=
 =?utf-8?B?NE1qaDk0aVpHaE9HK1hDaFFBYVZIMUZtaEJDQjE3cVBlUnVCSTE2VmExODQv?=
 =?utf-8?B?NVVIQ1dnd1ZPdVhOQzFBU0p1b2J4eUg5WlZLalQxOVoxekhkbkNkWjdyYkd4?=
 =?utf-8?B?dVdNS1pQZi82YTA5QlgzRWlwMzh0WU5kVWJRWWMvdHY5M3VLNTlQZFpNWlBo?=
 =?utf-8?B?b0dPZGJBL1dnVjdjQjY2S013U3phdGJaYlB5dndLN0FIVGYwVzhTQStjbXhM?=
 =?utf-8?B?Nkk4RUpzV3QyYmw1emM4OWtKWGFwY2pMbVBWTWlvNG1JWDBObWpUblltL3ZM?=
 =?utf-8?B?djlqR0JzamprM3R5Sk93Vm42Z0dsMzRCS0lmakh2d0pKZk9oNDhobFVaZjVV?=
 =?utf-8?B?Q3pJREJWejJqZ2xEajBPOHpxelFEZkZpSEcrblg4aVVvNUNmOTdBVzFOODk2?=
 =?utf-8?B?TnRtK1VSNmxHWnF0R0VVclZOS0FydWR5S3dnT2lCSThTTFMyMFR0Qnd4M3pT?=
 =?utf-8?B?REpxWHZDcVNtK0hKZTRwbkQxVXUzc0d0SEdBbnJ4dFBRUXgyTi9hNi9MWHVK?=
 =?utf-8?Q?XJ0iCHFi0ZrHKMoon+KP4MOod?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6F2D4D226B71FD4CA4C460E96388E2D2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc86b480-52de-4180-55a0-08dcb2eaebad
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2024 12:02:02.5483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H/baqnqr27kmh44eI9I28q90b+HjFfIcHNx1y1MdQXAhdHJvKvyVdJGSTl8182oidFI7D6N2wHqzUCBiePbIKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4951
X-OriginatorOrg: intel.com

DQo+ICtzdGF0aWMgdm9pZCBrdm1fdW5pbml0X3ZpcnR1YWxpemF0aW9uKHZvaWQpDQo+ICt7DQo+
ICsJaWYgKGVuYWJsZV92aXJ0X2F0X2xvYWQpDQo+ICsJCWt2bV9kaXNhYmxlX3ZpcnR1YWxpemF0
aW9uKCk7DQo+ICsNCj4gKwlXQVJOX09OKGt2bV91c2FnZV9jb3VudCk7DQo+ICt9DQo+IA0KDQpI
aSBTZWFuLA0KDQpUaGUgYWJvdmUgIldBUk5fT04oa3ZtX3VzYWdlX2NvdW50KTsiIGFzc3VtZXMg
dGhlDQprdm1fdW5pbml0X3ZpcnR1YWxpemF0aW9uKCkgaXMgdGhlIGxhc3QgY2FsbCBvZg0Ka3Zt
X2Rpc2FibGVfdmlydHVhbGl6YXRpb24oKSwgYW5kIGl0IGlzIGNhbGxlZCAuLi4NCg0KPiBAQCAt
NjQzMyw2ICs2NDY4LDggQEAgdm9pZCBrdm1fZXhpdCh2b2lkKQ0KPiAgCSAqLw0KPiAgCW1pc2Nf
ZGVyZWdpc3Rlcigma3ZtX2Rldik7DQo+ICANCj4gKwlrdm1fdW5pbml0X3ZpcnR1YWxpemF0aW9u
KCk7DQo+ICsNCj4gDQoNCi4uLiBmcm9tIGt2bV9leGl0KCkuDQoNCkFjY29yZGluZ2x5LCBrdm1f
aW5pdF92aXJ0dWFsaXphdGlvbigpIGlzIGNhbGxlZCBpbiBrdm1faW5pdCgpLg0KDQpGb3IgVERY
LCB3ZSB3YW50IHRvICJleHBsaWNpdGx5IGNhbGwga3ZtX2VuYWJsZV92aXJ0dWFsaXphdGlvbigp
ICsNCmluaXRpYWxpemluZyBURFggbW9kdWxlIiBiZWZvcmUga3ZtX2luaXQoKSBpbiB2dF9pbml0
KCksIHNpbmNlIGt2bV9pbml0KCkNCmlzIHN1cHBvc2VkIHRvIGJlIHRoZSBsYXN0IHN0ZXAgYWZ0
ZXIgaW5pdGlhbGl6aW5nIFREWC4NCg0KSW4gdGhlIGV4aXQgcGF0aCwgYWNjb3JkaW5nbHksIGZv
ciBURFggd2Ugd2FudCB0byBjYWxsIGt2bV9leGl0KCkgZmlyc3QsDQphbmQgdGhlbiAiZG8gVERY
IGNsZWFudXAgc3RhZmYgKyBleHBsaWNpdGx5IGNhbGwNCmt2bV9kaXNhYmxlX3ZpcnR1YWxpemFh
dGlvbigpIi4NCg0KVGhpcyB3aWxsIHRyaWdnZXIgdGhlIGFib3ZlICJXQVJOX09OKGt2bV91c2Fn
ZV9jb3VudCk7IiB3aGVuDQplbmFibGVfdmlydF9hdF9sb2FkIGlzIHRydWUsIGJlY2F1c2Uga3Zt
X3VuaW5pdF92aXJ0dWFsaXphdGlvbigpIGlzbid0DQp0aGUgbGFzdCBjYWxsIG9mIGt2bV9kaXNh
YmxlX3ZpcnR1YWxpemF0aW9uKCkuDQoNClRvIHJlc29sdmUsIEkgdGhpbmsgb25lIHdheSBpcyB3
ZSBjYW4gbW92ZSBrdm1faW5pdF92aXJ0dWFsaXphdGlvbigpIG91dA0Kb2Yga3ZtX2luaXQoKSwg
YnV0IEkgYW0gbm90IHN1cmUgd2hldGhlciB0aGVyZSdzIGFub3RoZXIgY29tbW9uIHBsYWNlDQp0
aGF0IGt2bV9pbml0X3ZpcnR1YWxpemF0aW9uKCkgY2FuIGJlIGNhbGxlZCBmb3IgYWxsIEFSQ0hz
Lg0KDQpEbyB5b3UgaGF2ZSBhbnkgY29tbWVudHM/DQo=

