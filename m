Return-Path: <kvm+bounces-12799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D2F588DC29
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 12:13:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 824B4B251B3
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 11:13:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C17FE55C3F;
	Wed, 27 Mar 2024 11:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JzoJ/jbl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58B355C07;
	Wed, 27 Mar 2024 11:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711537996; cv=fail; b=AvYDnSpvbQAfuvy7uWKnR7n2nrz1BraKPMYJgIE6/23KMtmv7XZOsLk1jjbn3qg6KoXHT9CjY9AvOQiLJ8W+FQJQYEl926m47u2PozT9yZ9j11/iN+pyLYTvjyU14Y6ZPSxpynYkKDDcx8c5pGyWTX1nlI5HMlt09Nh2duY1WCI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711537996; c=relaxed/simple;
	bh=aQbrBq9m77YttoBDuGDvFiZqy45iQ/FU1vyj8cVLMKU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NVC1u1QygdfFr4/0FPfvKoKYaw9WdrgNsDdXuAY28iwb5ym1DUIE3TrR3vxAYsZr0U4ICLaZbmGbqiGrIg7MyKYpT6Qx8adeIT653xbCKwBpitKaIiDb1aL4xibOB//1IRf9HSMDhyA3XYjMntuhe9V/6qsQ4kRWhPB76rqOSvU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JzoJ/jbl; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711537994; x=1743073994;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=aQbrBq9m77YttoBDuGDvFiZqy45iQ/FU1vyj8cVLMKU=;
  b=JzoJ/jblZXvk8ngDPe4YTNCUNsSHadcNmZ1JdTJQRiiFGR/3MlL05cW2
   jbm5aGDgU9MzvXU7X2aNnpE4a7wCalI/2RTFpRfryRLgv0ZIGdBYcYQYD
   /a7h7hX1Anm0RFXuJg2p6CQbRo4Hp3V1IX8wte0A0yetr2Fo0D9xK/5Sb
   ReeBv5oJW3lDM+Jha6Nx6Ni9NixuI0iReFWDSoWH4DxHaG0fQAfkOoH/A
   LV3LL7OJP5dxavNWKSUupfkHSkCqiLSUzGdRmv4vZmWkvHYKBzfS+iYhZ
   rw/AnngxNCP9IwJssl6YirYycPIjHXK7PKBkQPnNfqpRx3TTrU+uXPLDn
   g==;
X-CSE-ConnectionGUID: J2a6z7ezSHiTj3SIvCLuwA==
X-CSE-MsgGUID: J5cwtKa6QbaAyLnA4dPqbA==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="6523244"
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="6523244"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 04:13:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="20970505"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 04:13:13 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 04:13:12 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 04:13:12 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 04:13:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bvanirGKYC+eaLE0AtYhmyiwkqPDOAJQFbbrFDxK70V09UykelvYHMuUwYsN8LzrHyIquo7/8pwICbpawzYT63+dImGRjCK487xn1R9ftWa2lonv3PSHiXRWv49b8k4VCoXguJhfjlLCLCJ3oZyaPilhKImJ4ej383LO0n7mnFTVp3X/PYUWGKJMXq68cIWUXxUqFRtSgviAOkE/HlmQFUDWjNx1Kk2gp1ks72Z8dxn/KomEY379S6AfEgFcmalFZvS9WhbEc6XSaepl9HXfnnkx6X5r2CeLVdcnkCaoqNXPUz0O2y3UKjWubF3q3luOkyJcDljmLe8/+OUTRNal+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aQbrBq9m77YttoBDuGDvFiZqy45iQ/FU1vyj8cVLMKU=;
 b=nK6dhmWWyQL+IEah1RVbMkVCGyXz+dj+etQDpeITRr5a2V+Gpjf9SkdT3gOkBdJzUb/ZlyQ7YQ+CnLSZ2QpheqsZhHQjCWO7IYApUaMOX2YhbgrNy22Cecqp3C3m+CDF6vOwQFTGpY/hnI46ApMew2iEge3ceOA60VEXJby63eLHYgcMlI7YNEmSj8aq5e30mD1phubIgZ/3IPpOEmvGqCZHgNi4nNKbqhWVYOu3aX6SP+7nq0bQbaGy6wuCgLyPa2Yzi6H3QLaXBuy6DAIyDR6/a0/E5sIvvHtyRo4R1GUqs4JchbeO4Wbgy4l8Of107wilzztFm//NDsrZqqRdkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB5814.namprd11.prod.outlook.com (2603:10b6:a03:423::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Wed, 27 Mar
 2024 11:13:09 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 11:13:09 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "luto@kernel.org" <luto@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "Li, Xin3" <xin3.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Kang, Shan" <shan.kang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 1/9] x86/cpu: KVM: Add common defines for architectural
 memory types (PAT, MTRRs, etc.)
Thread-Topic: [PATCH v6 1/9] x86/cpu: KVM: Add common defines for
 architectural memory types (PAT, MTRRs, etc.)
Thread-Index: AQHaccEQdgxGATua3EGAVgDMMDxTBrFLi/kA
Date: Wed, 27 Mar 2024 11:13:09 +0000
Message-ID: <2a369e6e229788f66fb2bbf8bc89552d86ba38b9.camel@intel.com>
References: <20240309012725.1409949-1-seanjc@google.com>
	 <20240309012725.1409949-2-seanjc@google.com>
In-Reply-To: <20240309012725.1409949-2-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB5814:EE_
x-ms-office365-filtering-correlation-id: e4b9c927-660a-4c75-dd80-08dc4e4ee2a4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SnTmbwcLMUzM8A0Iaccr3CzCl7VIrhnMSSrQKqIYnCTTaHcWfmMEhFmblaeRh5aMUpL7V/jf5RrMO4sqZt++3kl4MNA8QEpMNXl2FzkjR//X0qjHe4tHnqtZeh0Jj43tPMV3QARe76k0f8zKvm+qWKnkncHMrqmue156F3eCuqmdX5mqeOtPfxzycTB7Uqi9g52y66t72Tiusn175uBTDPCWSCqiFffFglYdf//2GsXkTHcQfbPoIyHd9iTqepyvFBUsemQ6SuTNFa06KSdAmj+5MbMosjDfp0iLgl6hvMZf4wX4v5EzVXXmUdPLsrOWrfVkn20ps72XuYY0B4Jk3kRwCRTbU70Gn111gq3wZ9lM2DrZ2sPOqzjidq1HXllvSSy4l3L6ynE5zI4Fez2udipWOYaVORHRrPPb5E/pfwni/o3CnttIZFx/4mMZzdyEtWyeNDPLqxZjYwCb7r+nhloESgTolf1C/3T72rJsXXhySgi7CdQrRX32HTEKlA+nzEnrFldI5MMrJDg/9B1QC2Ir8uUfcHafNZUKVDi0rHNgw8teaOZdnfOENGrU1j758jaBpMP0ZWA0IN82ry/XfefcemxNI+i7COnXX01tEP93DCpJOYAvgQQVVRQvYNT9dJnhq4GknB8WTbYLZzUwJBZwL+9/P7LKE4QkNCxkqfolYpD+BQ6wA3rsKqb6ElfEeSGr2FhshKv69qwH3XSg7rpXpt9+bujDeU0WAIsC9e4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TmVaOVdlL3M0REtCN0t2RDZsVnlodEZuNXhKeVZRdXgySUZhdWwxUFVRRWdm?=
 =?utf-8?B?bVAzMkl3WFUzWVRmTm43SGlrY0Rpc2U2OU1FSGJOMVZpc2o0U1pwRU11UUVH?=
 =?utf-8?B?V1hmOXBGdk1QbE84eVVYcWdtTk5MbXV4VjJkOEFGaDN6Lzk5aGRpSWthWkQr?=
 =?utf-8?B?NEsxZ20xTjMxUy9uNXFnRy9PUFFRNk5oT3hmdXpnM3ZxVkZySGw0akVNTFNX?=
 =?utf-8?B?Kzk2RUJIeWwxaisvK1IvaHIyZXNPRmEzbTVQNTBrd28vRmVTTzdUZ1EybDhh?=
 =?utf-8?B?c1pXMUpkRnk0a21iVmNYVkFMSVhxcVd0REk4M1lzOExmVGJ6Y0s2RWpCcHV1?=
 =?utf-8?B?WjdEb0NTVVRPNkRDYlFMNzdtZXVRZkpZU0RHa0xiQ3RRTUE0eXZrTkgwVXlD?=
 =?utf-8?B?UG5LNnUrYVpkMUZwL0o3ME04OTE2aDZZanF0R3MvMDU2NEVZVTBKWEVQTXd3?=
 =?utf-8?B?K1hHZjIzVFdjVWx6SHBoVlhTek1QUmFXditJdy84Rkw5ZnMvby9BTDk4Skw2?=
 =?utf-8?B?c1kzZkZBaktUeTJJYUZER0RTU1pPZXM3aG5oSUZhSUljZmtBWVBpd0Nlb1BB?=
 =?utf-8?B?MGgrRlJab0JDeGVXOUZHeThyOUt2ZWM2dXRiVDY5M0xtOWtZVlBmYWk0TTR4?=
 =?utf-8?B?RldYUmJFRGJ6bTdSb1VhY2w1WlJoU3lyUXhmK3BXV2RWaDNSVHBPUlAyV2NG?=
 =?utf-8?B?eGFxQjJqM2x3bkdiV2JMeDYyYloycmRsamJuL2I4TFN1YitQLzAxcjVSaWpr?=
 =?utf-8?B?UGF3dEtRdzU1RkpEbnNpRkVVTm13aE5XeU9tbEpMRFZ1RFRYdlA1SVcvNkxO?=
 =?utf-8?B?aVA4TmpDRmkrZktySkxkWUM4SjlqNktwc215V0hxWXhrMERQV3Jic1ZtWUhq?=
 =?utf-8?B?VGRoakVmb0w4eGlZUUkvdDh3TTRSdTZacHBJNzlCNEZBQmNoamVXSXV2U04v?=
 =?utf-8?B?ckt2YkVkMHd4K3I0QjRDWG1GcGZBN3plS3dYRkt4L1A5aFdoQ3lScWNmUTlP?=
 =?utf-8?B?dGJ4QitnY1hhNXdlK1NVVlJFVG8vMWJHbjBydFlWeGFiY1lJb3BxVkdrMWhB?=
 =?utf-8?B?eEVEelJSQU4yYnRNRWdDNE5wMnh4K2c4ZmlQTUpjNWNmOUxLdWxmb3k5V05E?=
 =?utf-8?B?M04wendTZlMwS1RMV29OR0xOU0NMellEeExhYkNaSDdVRE1sMmZzVlJrR1Zw?=
 =?utf-8?B?U2lmTGREVzFNbytRWmlDaHk3WUQyVlE5WXZxWFhnWFA2RCtoTHkxb0U2Q3NU?=
 =?utf-8?B?aDNCSUc2VWduUm1yeUg4UFByanpmSXFkeFhkWkVhc2FqKzdaUjBXNWVha0Jr?=
 =?utf-8?B?N3gxOFZNbkpNVWE2dWgxR1VVRHB0WVlPMW8xNUsydVZWMmdVSml3ZFVpRnht?=
 =?utf-8?B?b1o1YjJsV3RobDdxb3FFblZtOUNlQUc3UE9QWXBWaXNsemJPOXNEcWR5R2E0?=
 =?utf-8?B?YUMxc0V6OWUzRFBYd3dyYTI1bEhKbCsyWWpWZFFZTmpVekRqUmx5a3ZoSFpD?=
 =?utf-8?B?b2p3MkF1bllnSkRqSE14R2g2dGUyWnQ3R3NhZVNnbCthOG9ydGM4cjlBOG1x?=
 =?utf-8?B?eDFqMWp6YXJGQ2I5Znpma0tLVmM2dXpqeGRMeXh4OWExQlovQ0pkaXBZaVBl?=
 =?utf-8?B?bTkrNVpBNjFZTjJGKzRQd0Jsc3Zvc2xEOFpmcVpRTVRGeWkzWVlwMk1kUUwx?=
 =?utf-8?B?RUMrWHB4QlMyVjM1WnI2d0FoNHRXSThhV3oza01Bcklza1RYRXdRcUt2TVZh?=
 =?utf-8?B?d0V6K2RwZDFXQjE2ZzdIb3JPMDJDN0FoMXNrcU9EbmFiWGU1VGFZMisrYkRI?=
 =?utf-8?B?NGtIZzJSOWxmTERQdHFYcWt4M0k3Uk55dEJFclRZbDB1SmVOeGdrR2hFVkxT?=
 =?utf-8?B?Tys5Z29hWVh3VkRMbTJjbTF3dGVzK0U4SlZSdjZVdW1haStLZ0U1MkVzbDNt?=
 =?utf-8?B?V0Z4dUYyWm92ZS81UEwrMDkzMW8yM3hFTVczelJGQkVQcEd5SzRrSnRFcVBP?=
 =?utf-8?B?L2lnSmtOTWExUkRLWUpPKzRaaUd2cDhwZkdqUkVkc2dFVDVYTks4YThtbnVy?=
 =?utf-8?B?OWMvTlJaWUJNckdoM1g5THYyREpiUnhWMm1nSml1bC9KUXUwTGFLeERPWGFV?=
 =?utf-8?B?U3RpRkRQMnpPYSs2Um03dkk0aUtQMllBNUhhLzlNaSswcTdmS1o4cmpJV3Zj?=
 =?utf-8?B?NVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D460E68958F7BD42A16E862649A27FC9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4b9c927-660a-4c75-dd80-08dc4e4ee2a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2024 11:13:09.6012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UabM6S1Yfi3BFYt243BdAPcPSWkT2bOmoVfDQUIccOMI/BGgz/Rw3cQEaSYDA/2Z9Bp+i8OgmOYQpu4cENc/xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5814
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAzLTA4IGF0IDE3OjI3IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBBZGQgZGVmaW5lcyBmb3IgdGhlIGFyY2hpdGVjdHVyYWwgbWVtb3J5IHR5cGVzIHRo
YXQgY2FuIGJlIHNob3ZlZCBpbnRvDQo+IHZhcmlvdXMgTVNScyBhbmQgcmVnaXN0ZXJzLCBlLmcu
IE1UUlJzLCBQQVQsIFZNWCBjYXBhYmlsaXRpZXMgTVNScywgRVBUUHMsDQo+IGV0Yy4gIFdoaWxl
IG1vc3QgTVNScy9yZWdpc3RlcnMgc3VwcG9ydCBvbmx5IGEgc3Vic2V0IG9mIGFsbCBtZW1vcnkg
dHlwZXMsDQo+IHRoZSB2YWx1ZXMgdGhlbXNlbHZlcyBhcmUgYXJjaGl0ZWN0dXJhbCBhbmQgaWRl
bnRpY2FsIGFjcm9zcyBhbGwgdXNlcnMuDQo+IA0KPiBMZWF2ZSB0aGUgZ29vZnkgTVRSUl9UWVBF
XyogZGVmaW5pdGlvbnMgYXMtaXMgc2luY2UgdGhleSBhcmUgaW4gYSB1YXBpDQo+IGhlYWRlciwg
YnV0IGFkZCBjb21waWxlLXRpbWUgYXNzZXJ0aW9ucyB0byBjb25uZWN0IHRoZSBkb3RzIChhbmQg
c2FuaXR5DQo+IGNoZWNrIHRoYXQgdGhlIG1zci1pbmRleC5oIHZhbHVlcyBkaWRuJ3QgZ2V0IGZh
dC1maW5nZXJlZCkuDQo+IA0KPiBLZWVwIHRoZSBWTVhfRVBUUF9NVF8qIGRlZmluZXMgc28gdGhh
dCBpdCdzIHNsaWdodGx5IG1vcmUgb2J2aW91cyB0aGF0IHRoZQ0KPiBFUFRQIGhvbGRzIGEgc2lu
Z2xlIG1lbW9yeSB0eXBlIGluIDMgb2YgaXRzIDY0IGJpdHM7IHRob3NlIGJpdHMganVzdA0KPiBo
YXBwZW4gdG8gYmUgMjowLCBpLmUuIGRvbid0IG5lZWQgdG8gYmUgc2hpZnRlZC4NCj4gDQo+IE9w
cG9ydHVuaXN0aWNhbGx5IHVzZSBYODZfTUVNVFlQRV9XQiBpbnN0ZWFkIG9mIGFuIG9wZW4gY29k
ZWQgJzYnIGluDQo+IHNldHVwX3ZtY3NfY29uZmlnKCkuDQo+IA0KPiBObyBmdW5jdGlvbmFsIGNo
YW5nZSBpbnRlbmRlZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPg0KPiANCg0KWy4uLl0NCg0KPiAgDQo+ICAjaW5jbHVkZSAibXRy
ci5oIg0KPiAgDQo+ICtzdGF0aWNfYXNzZXJ0KFg4Nl9NRU1UWVBFX1VDID09IE1UUlJfVFlQRV9V
TkNBQ0hBQkxFKTsNCj4gK3N0YXRpY19hc3NlcnQoWDg2X01FTVRZUEVfV0MgPT0gTVRSUl9UWVBF
X1dSQ09NQik7DQo+ICtzdGF0aWNfYXNzZXJ0KFg4Nl9NRU1UWVBFX1dUID09IE1UUlJfVFlQRV9X
UlRIUk9VR0gpOw0KPiArc3RhdGljX2Fzc2VydChYODZfTUVNVFlQRV9XUCA9PSBNVFJSX1RZUEVf
V1JQUk9UKTsNCj4gK3N0YXRpY19hc3NlcnQoWDg2X01FTVRZUEVfV0IgPT0gTVRSUl9UWVBFX1dS
QkFDSyk7DQo+ICsNCj4gDQoNCkhpIFNlYW4sDQoNCklJVUMsIHRoZSBwdXJwb3NlIG9mIHRoaXMg
cGF0Y2ggaXMgZm9yIHRoZSBrZXJuZWwgdG8gdXNlIFg4Nl9NRU1UWVBFX3h4LCB3aGljaA0KYXJl
IGFyY2hpdGVjdHVyYWwgdmFsdWVzLCB3aGVyZSBhcHBsaWNhYmxlPw0KDQpZZWFoIHdlIG5lZWQg
dG8ga2VlcCBNVFJSX1RZUEVfeHggaW4gdGhlIHVhcGkgaGVhZGVyLCBidXQgaW4gdGhlIGtlcm5l
bCwgc2hvdWxkDQp3ZSBjaGFuZ2UgYWxsIHBsYWNlcyB0aGF0IHVzZSBNVFJSX1RZUEVfeHggdG8g
WDg2X01FTVRZUEVfeHg/ICBUaGUNCnN0YXRpY19hc3NlcnQoKXMgYWJvdmUgaGF2ZSBndWFyYW50
ZWVkIHRoZSB0d28gYXJlIHRoZSBzYW1lLCBzbyB0aGVyZSdzIG5vdGhpbmcNCndyb25nIGZvciB0
aGUga2VybmVsIHRvIHVzZSBYODZfTUVNVFlQRV94eCBpbnN0ZWFkLg0KDQpCb3RoIFBBVF94eCBh
bmQgVk1YX0JBU0lDX01FTV9UWVBFX3h4IHRvIFg4Nl9NRU1UWVBFX3h4LCBpdCBzZWVtcyBhIGxp
dHRsZSBiaXQNCm9kZCBpZiB3ZSBkb24ndCBzd2l0Y2ggZm9yIE1UUlJfVFlQRV94eC4NCg0KSG93
ZXZlciBieSBzaW1wbGUgc2VhcmNoIE1FTV9UWVBFX3h4IGFyZSBpbnRlbnNpdmVseSB1c2VkIGlu
IG1hbnkgZmlsZXMsIHNvLi4uDQoNCg==

