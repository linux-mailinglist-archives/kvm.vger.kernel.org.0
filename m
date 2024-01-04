Return-Path: <kvm+bounces-5691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B1B7824AE2
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 23:30:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A1672831F8
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 22:30:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9C2E28E16;
	Thu,  4 Jan 2024 22:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Og67/N+n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F7D2C6A3;
	Thu,  4 Jan 2024 22:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704407401; x=1735943401;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=og1gtU8THIkCiwXlsRagVpWNVoAnE7upUuzZ3URRDBA=;
  b=Og67/N+nmTWNXqi171bj5IFRaFbm28R/2xre+qlI1C1j115v321W3PJK
   5wnvsnn/ELaQ3AvQqu8kfYdfxsf8WFT/6CEspCXOvGYmRHmyFeOlltEyn
   Ku08RCDYRVSwDs3LTAECutPPxH2ZVNbB1yOTN7jdAo0u/D81NEo5bTqsB
   LnNxzgKhMYF/fVzyGGB8grWJX4/ciVTXbwkM+S1ILq6if8sRIX2IIZM1f
   Ar2Uskj0WfygGfxorpqFWBihviW37RKSFeM2y3noFs1Lj2rbxEPIY5Wjz
   wYiysxUe21MFs2srkdNmtet8hEZpJ5KBP2Bp36Nftw2QsYNNZOYqrc6zH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="4748249"
X-IronPort-AV: E=Sophos;i="6.04,332,1695711600"; 
   d="scan'208";a="4748249"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2024 14:30:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="871067901"
X-IronPort-AV: E=Sophos;i="6.04,332,1695711600"; 
   d="scan'208";a="871067901"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Jan 2024 14:30:00 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 4 Jan 2024 14:29:59 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 4 Jan 2024 14:29:59 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 4 Jan 2024 14:29:59 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 4 Jan 2024 14:29:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VpPoOaMEK/ccuCAJLeYENrW1aCQMd2s0JG/Ccm8qn1LOMWOJQT1XsGK/W5CdqYcJaELq2BoxUA94xw50foBA8sQRhAc3CxChinKdEL7Bzvg/ww0kAm1F+ht7YZRjmMirRdj0cLGpyi86iELJiq1TNZtddUteBzSDfteXEHeTzdJInpBzWJhl5Bf2U8RbDTCVVcnkmpFDLHDregI/3uy1GDsMZp6lUa/X8W6FJU15M/EXP+++hutyU31KocXrmTujIK5uLa69F0lcT5/M8dbErw6p3EQlzyBn7+2y7f4slb8Dzk5IGQeBG+MFyCYXyV4AwwGsGgjWFQVxrERUDnpMvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=og1gtU8THIkCiwXlsRagVpWNVoAnE7upUuzZ3URRDBA=;
 b=lq/+k4JdSsaUCc1tA0JVvtGRrH4uju76/CiuaM1VIUrZU8aB5RuKyN0DC7zKLKHK/jixbZR5rqh+feOPK+OmzRkHuRBUFkBMmD850GNucSGoYJqrNidXAY89dFIJKCJssO0QkRPMwrBS0Fm0oINOGx/52y8poQS83YAIs0IPH/O9XEqcvso/8U3WDxlTLWDkbmjbyGMDmpyKGEqGqU6/wJj6EO9jF34M5Fouww4ZMJd4ZOA3T9SbpB2KeQAxWHWyw0Fz6ZS0+cMGV8DGmIPlcTjCXwKutPv5K73EWL7/Bg0UouxeM52+0QuLtW7cr7Af4SQVoTItU07WcYJLjQSADg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB7062.namprd11.prod.outlook.com (2603:10b6:806:2b3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.25; Thu, 4 Jan
 2024 22:29:57 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93%4]) with mapi id 15.20.7135.028; Thu, 4 Jan 2024
 22:29:57 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yang, Weijiang"
	<weijiang.yang@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "john.allen@amd.com" <john.allen@amd.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Gao, Chao" <chao.gao@intel.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>
Subject: Re: [PATCH v8 00/26] Enable CET Virtualization
Thread-Topic: [PATCH v8 00/26] Enable CET Virtualization
Thread-Index: AQHaM+ybd3H3II6aZU6KWHt3rvxkNLDKUz6A
Date: Thu, 4 Jan 2024 22:29:57 +0000
Message-ID: <be3fb18cd3ce074e7ee425db271c8e47f09ef42f.camel@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
In-Reply-To: <20231221140239.4349-1-weijiang.yang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB7062:EE_
x-ms-office365-filtering-correlation-id: 9c85480e-14e6-4dbe-7e91-08dc0d74aeb1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ogi8J9EclwRG9GplMEpGCMj0Tefq+NHN2UDyOjfzfuG/pI+ehzn3btxqfNrzWkPtQgHppe2iI1G8ee7v+VrgVpuZfJy6D6hjvGgqL6KIpkHzjBBMEaQaLGWPW2oIR51L57PN4FOs4HeCSKJNGjqf+zmfArFj0dalyfIjl5zZ22BUfL5H3jIsEZ+pa14cF+BJ5bFutPC6kkZdo+9EMjyas74HiM1HnxrhCRGG3a3uPtToU56wGKIT2L4XmLzm6rSiHP9tDx/UjcB9jKa9EEJiATMIVyxWwVn57fYf6TX/0ar7SR0sFq9otJb+MOPSFVoXiglLFim8TNMoSgc0GXiGUDDoVrw2SreWAVfFkBu9QjzrH2sKh+318wQLzVwzttbWGJV2Q+uL/eYAkAIulEE7aTWdENn183ghs2m8wgFBmaUzxxDTzNlSQvR6GIqErJ/fJGC4LPyAvaPPMmqxXM5Mpve899DmYKiZFFxtSU1N3+NmqsreMT65zss2QuwBjRVMps4kdI3Etfuu/CkHgcaVfLpvMtrImjIZg0DVf+Jtl6K0Rpkv2todgM5pd/Gb1ogexcEGhdd4NpMwHGRcZuqOyJ7JnuWpfiM7xF6M/NrQx1YVuo7OX4urKgn/zryyi+n4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(396003)(136003)(346002)(376002)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(76116006)(4326008)(478600001)(6636002)(8676002)(316002)(110136005)(66446008)(54906003)(8936002)(66946007)(6486002)(66476007)(64756008)(66556008)(91956017)(71200400001)(6506007)(6512007)(2616005)(26005)(5660300002)(4744005)(4001150100001)(41300700001)(2906002)(38070700009)(36756003)(122000001)(38100700002)(82960400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d1NPSmVVei9QQmVzU0ZkMGY3T2Q3a0xTVUQxcEhybnlUUmZQLzRLRVpxMERM?=
 =?utf-8?B?QVAzdGN1dEZWQTByajNYcTVZTlNQTk9LOFhydnZJdU9aUi95M25qN09aemo1?=
 =?utf-8?B?RnlrMEMzVU42R2swVTlYZURRdU42U2FGcEYwRG1nMmZGeDVxRGVxWUFNQzJk?=
 =?utf-8?B?cUd3RUVyM0MvYk1WNmtNZ2VQVFMyRHMxVTNUemhuY2t3eVlETHFtbGlEVHhS?=
 =?utf-8?B?aFNsMEtQWUJPZU5SajFiclltNmkvS0VIbEVvMWtDMGUya2NrNzd5ZHZmbXBF?=
 =?utf-8?B?cmVYUlRhTTV5eVdFcGQwQUxHZXBRd2RlY0tIRW5ONGRJTnByaDJLNXdIK0Z2?=
 =?utf-8?B?V0tta3lEeklNN0pEckRJdk9naHJZREFnWkZTbTUzSjVSbWVFaE02RkFqQWFj?=
 =?utf-8?B?eEUxOG14M1RSU3ZHMFRuZUpUSEpvUXRSRDhWb0I3cTJwalc3QURITG5RQ1Na?=
 =?utf-8?B?OC9mUkltdER4S25jYTRkOW83ekJSOWE3dFI2OFBjb09lZXJNZThwS2RpQ2RW?=
 =?utf-8?B?K1BDN3hzZjBNeTI5Z0g4RGk4QzNDdnBqYmFRWjZEakxjU2lVUjUvYU43anNn?=
 =?utf-8?B?ZEdqYVFISlNFYnlNVk5EamxLRDdkY0tNTGhwcE9ZcFlPUmxlcktneXRublVE?=
 =?utf-8?B?RUtQckNxNzF6dGxVWVh4bzNwQUIxQzM5YjM1OGtpYVNpeFB4NWtEUlNHM2Ex?=
 =?utf-8?B?OERnRmVRU082dXlFNjJoeU1yMnhZbDF0YnhJSXNrYW91UDB3bWNFdDN2b2Z5?=
 =?utf-8?B?UmI5SWVEU09GZWhIQVBiM0xCYXFpRTJsVlZsbjRiNWdUcHkyNy85dlJXNjVp?=
 =?utf-8?B?MkZJT3M2Si93aHdCdjltTmZXSzRaeStiUUhKY2VVa1JXaDhGck1kYzlPeXBa?=
 =?utf-8?B?bVNCZ3cvWlFoNmNtdTNjR0VQUE0zWjRIK2dVRVJlNjFCcTU2b1JTV3p1cDJw?=
 =?utf-8?B?cEZkbENjUG9tYVBlaE1aRUhGRC94Q05kTWpveSt1anV4c3NGeDNraFpYNnRw?=
 =?utf-8?B?ck1JdGtsamhkNkdGOEhYSmxyVEJXZGtwN1JENzFMSkFzdFAvR25XTThJcElW?=
 =?utf-8?B?aUpKbFRBc0VYeklZK3JHK1A0NG14QkFBTzk2V2djMmFQRFNramNtZjdPVFYr?=
 =?utf-8?B?cWpDMC9vZTdTOVJ4NEMyMi9VdGpXelh2bGNVY1E4dG8wUXI0K0hOd0oyaGVY?=
 =?utf-8?B?RG1JYzdMVklYYkNXbkF5OGNoVmprYjNsUTRSUUdCUEZGNkJPUzhaR0txWkll?=
 =?utf-8?B?bWJYSDlOOVJDMUdNVG5yTlpBQnZ2VHpubEZ5cHJ4d3lOUHpxRkVDUnNQQnZy?=
 =?utf-8?B?bEQ4cGh6S0lqL2RlaEhsdVFzMUMwT2dKNmZ5eHJjSy9zRjlrYVRsZUFDZ3hk?=
 =?utf-8?B?VzFheUpOcTVtVHhQTjZtV2NaTGVFZ0RrYXo1eWlGQVE2SEdQTE1wL0JVUFZ0?=
 =?utf-8?B?aHh3dWhQMFBMbDN3eXVYN25tK2RURU44WmMvNUNVd3QrU01XWEthb1BDc0d3?=
 =?utf-8?B?eCtRK3Aza3ZueldLcWtvazNVN1ltNm5yNFRQbloybU9MU2Q1QXlMSC9HQVFa?=
 =?utf-8?B?dnJXY0NMQTJaanlGcE80RU9pRHJ6QkpJanVuMVFvb2ZKcVFBa05VT3BzMlpu?=
 =?utf-8?B?Q2o3QWxYZHVHK2VpQnNYcUtNbDAzMmN1MktKbk5ua0hDaGpZMitOZXJVREJj?=
 =?utf-8?B?bmxuZGNxMFFRYWcxN2VjTnJLaDllNFhXVnlBa0tjYkx0ME5DQWhUVUZPVVB6?=
 =?utf-8?B?R1h0cU5aRWxWci95NGY5SWdmeTQvRS84K05ESUhGcjBEQW5lRkZabWhEd3gx?=
 =?utf-8?B?MDNmSE4wRFYxeGdpSjFPN3hQbzRkeUZWbWd1dy9UcENxTlFXSVdra1FCZk1l?=
 =?utf-8?B?RjRwR0MxVG8ray9LTW9iNWRydUdxZ0kyK1JLRUNLcDlPVXpUVkgzc0Nscjc0?=
 =?utf-8?B?RnZxSi8xRzRLaEdFSnRydjVJd2lwREJBV0Q5RktDQlBMdk1PNFFGSC80eDNE?=
 =?utf-8?B?SFZuTW5ucnhoQTNhUHEyaXVpTUlCZXVzYjEvdjNLM2JVVVcwb2lQWitHZ3JH?=
 =?utf-8?B?NWo5KytWbTR3ZS9ScnlKM1RjL203WTErNVZlaWd5dzBXS0hVVnF3ei9ReUw2?=
 =?utf-8?B?R2NsK2FWdjlZa2c2YUZWYXdmekdqYlo0cStieEdwaGpNWmowTDM3RWx6V1U1?=
 =?utf-8?B?N1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C16D8536C349794F89A1F24648BADB58@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c85480e-14e6-4dbe-7e91-08dc0d74aeb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2024 22:29:57.7582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IPpLLlOXVAIjlk5Mxgu5p96KZZvYZSsfEp6swOCb8HX7xfTtJhmYHu8mLAx7FVbRQqfKWk/jSh7/N8J/1GbmuChe5dXM9gRuGe4h3nbFbo0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7062
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIzLTEyLTIxIGF0IDA5OjAyIC0wNTAwLCBZYW5nIFdlaWppYW5nIHdyb3RlOg0K
PiBUZXN0czoNCj4gPT09PT09PT09PT09PT09PT09PT09PQ0KPiBUaGlzIHNlcmllcyBwYXNzZWQg
YmFzaWMgQ0VUIHVzZXIgc2hhZG93IHN0YWNrIHRlc3QgYW5kIGtlcm5lbCBJQlQNCj4gdGVzdCBp
biBMMQ0KPiBhbmQgTDIgZ3Vlc3QuDQoNCldpdGggdGhlIGJ1aWxkIGZpeCwgcmVwcm9kdWNlZCB0
aGUgYmFzaWMgSUJUIGFuZCB1c2VyIHNoYWRvdyBzdGFjaw0KdGVzdHMsIHBsdXMgdGhlIENFVCBl
bmFibGVkIGdsaWJjIHVuaXQgdGVzdHMuDQoNClRlc3RlZC1ieTogUmljayBFZGdlY29tYmUgPHJp
Y2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0K

