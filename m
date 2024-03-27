Return-Path: <kvm+bounces-12801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 19C2988DC6D
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 12:22:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C690F1F244CC
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 11:22:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 349D055E55;
	Wed, 27 Mar 2024 11:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bsapPDDT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3E818E27;
	Wed, 27 Mar 2024 11:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711538531; cv=fail; b=c8+76q73W36ZlE/3OEvi0bxvG3cVQ5CLIPjaVKRNslkI6w6rLwpvRMJuVFRN+1hx2UCedXZ5ZpCuIzNgelZQtWC5JyUzvCSRkUEXpKIHlsLDGQLmj/Q4iFUO26blDpMmfqfioO5p0ps+eosPU8FhumDpmROSlc+aQd70FcKg3LI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711538531; c=relaxed/simple;
	bh=rv2qqG+5phC1vy/RWl1rPDVRWWX1BOMuBPmrOUHLpaU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RRp1S8nwUCC9MO7fPqDvdrFEtJRBTR4CCqg9vybQTjHSIAWNHMXnAXnBJ/ONPZH+4pfDydIgMiyA2ASRMKfxrTIoWdPaBoTTYoO3jNLIKfIDDDqYs2E/spUzhzrLR5TQ5blm7Nr7+I5o+YipkeB22n8buFSYjUQ7yvw3ziHfMow=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bsapPDDT; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711538530; x=1743074530;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rv2qqG+5phC1vy/RWl1rPDVRWWX1BOMuBPmrOUHLpaU=;
  b=bsapPDDT+VwXKjMGmUm8rsvsb8yYLE5nIUlVG7ckDDf1wXdq81w4Qpnj
   P6yGHbwuRSjZtEMzlMZureLtWBYSqEkXnEHRRX0FkZIkBqvjKKvZ7SXGK
   tA/MBpflfWLymNq5Ca0fwFKdYlng/ZiL/AzoKOBnNFVArVWRwqErvaN5q
   KAT8dc3M4dCzwTUUe2PyUFDstCJEyYIKNt7mZK9szig4qfdLa8glbtP/v
   Zoo8U3XxXpbrTdzodm4nyj05XyIxskp/itLStiU2qBF/vY4evVgW4GONF
   2uyWD/KHRFA4N+G+Eqw1xm41YQOb1LmzBtua+0imipGV+20ac/9yX65kV
   w==;
X-CSE-ConnectionGUID: D6ZsxxbzRU+W8DcMIURHhA==
X-CSE-MsgGUID: 9f8e29+3T9miUC0Oo7bwhA==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="24122704"
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="24122704"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 04:22:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="16648160"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 04:22:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 04:22:04 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 04:22:04 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 04:22:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YLcUT0v7EjhbaS5WNmLd1qt9CwNN3MuXMGajSbS1otzye5vv3ivJXAyYZGrsmgTeUkKyaDBb6ifHIdkgBbmtgbfAizzqpro57hll2nlYKtrwRpRo6Htzrpi8aTLYMH2NEIYMXwRGkoANlaFRHsrYn9ZER7DpUQo6Cl1ec1aBawGyy8UoCF0Idd/Hy5kT4dIGVNIXh32FSbbyktJa7lcI167QtDnA/dhA9LZXPbJ8rvZCrPO8Ry/fiijOX3DFn4qk6Zxu90n89RpYASfG6Eqqz/9USYMB7usmvPWBbTI5ph43ws0xCKzKHcSFdXj7e/777UZZGK+12Awv69uXPyPTWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rv2qqG+5phC1vy/RWl1rPDVRWWX1BOMuBPmrOUHLpaU=;
 b=GrJORsBo1m3R2h6t/wnTkvtq+F57nH2W5n7YTWBB/6zPv3GJE71zdddJlJ1nJo1WT8gW9CeXAxrMFmIkEwF+C0Jukul9Fx03WHYMeCqwUby9gYRA99G2qkWVWkFr0sZ0/7eawtK45apTemIhCzCiJHkcLBoXyEXF0wqke3d6CtvCP2Bc7s901ovVomQUPbyuXKmS/P8HWiq5nUZubTpE9xwsND0F8ngdGwXazaPWo7vx8OWXsJMffkocla73iL00AtaVkRmBA3zFkcPZPw/ra+WCcixyWXJf7S82V4GJ5BmSB5BuejsrM8soygl/caolmliXDWBMOy0p7KsMoWoR+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB5814.namprd11.prod.outlook.com (2603:10b6:a03:423::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Wed, 27 Mar
 2024 11:22:01 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 11:22:01 +0000
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
Subject: Re: [PATCH v6 3/9] KVM: x86: Stuff vCPU's PAT with default value at
 RESET, not creation
Thread-Topic: [PATCH v6 3/9] KVM: x86: Stuff vCPU's PAT with default value at
 RESET, not creation
Thread-Index: AQHaccEQfYI+bhzm80q7JydWy7zoK7FLjnWA
Date: Wed, 27 Mar 2024 11:22:01 +0000
Message-ID: <3af366625c29cd6b0ae201d4f61e450245b0f7cf.camel@intel.com>
References: <20240309012725.1409949-1-seanjc@google.com>
	 <20240309012725.1409949-4-seanjc@google.com>
In-Reply-To: <20240309012725.1409949-4-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB5814:EE_
x-ms-office365-filtering-correlation-id: 8891891e-b4e5-4a68-c45c-08dc4e501f93
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rewuZjQVF58zsWodYghrwnjBOCfXKUJNcHvMiqSd2sr7oHsVIeOT4Sfh2Vq/tUQ6xV8thZrCr4nfn1OqeOMhPYt1ebpG2GLJSaNanOqd4Y21XYfmQUSn19F6jPlw8vEQ2TwwcGzeH/UgFeyGIcBJUvdGumLuSj/pssDKEtrFjfkhs5x6t3+BsDadr42yHMo7QGrWpvPVDQBnLyrpgaTkKcucieJUjysRrgPKTT8FL+RFMiOCFga2R+P2w8kiZKmVR/DkwSa0pDM3ptNUOxha6PAYj2/1y57uj54f7cpIyoeQNrwWEHzLbzYHY5CvsDysy+vtu/4Jjp7A0iXCobQ+S2blQu4oWyrSQRH9FaxwsJO6FhEbRdslPW14a8lO3S0CU/wWBFDMw2jLEp6TW5Uu5cnu92HmNWjlGtzJ1tu4DVOzHPa0HllYYo2O2QaeCxUVIuzDSOhJgEDxBKkFt6/OzUuX041SpjN0ABAQV02Lf2zGRzSmWllzdj9CReZs+3HyJRzEFLaxrD407rAlEF0y2WU2AfpuCiTAI66FL+9VYmMaVws4RoV4GTw9xR6028SBEZwVfUPV8GB8c80Ug9mi2HzUk45wT1r/UAGhT0E2il2auaXYLmJuRrVweHjWMXtn1iU40Sp+pJylnQfQVKOrM/fA4euaKXnAdn7m3zIRMmVIizIEQVjN18HqNEGk658LbE452BRAkjMNqSi9z4zsbRyoQNuvWHLzJZcAZpxvd1s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ym4wZlpYd3F2VHJTN3REVms3ZXVTT2pCUWhKbmc0TUtnVHo4TVU4N2FMNDZK?=
 =?utf-8?B?bjZ4UVM4K0RNQmdLWlVjQXRHNGtaREJZUlpVYjVzYW5vOUJtQkVSQTRocHRJ?=
 =?utf-8?B?MzhxWWVOSUw3NnV2ckdnWkwyaTVIQ0tkbFFmTDNKSm9sOEVyT3BnMFcxajAw?=
 =?utf-8?B?OVFqM2l3SFlSclVjNitXZDZXb1hQU0VBWHk4ZU0yenFraTg5ZGVzQkZLQkV0?=
 =?utf-8?B?d1p0SldtQnFHanYxNy9XMVRyUGsrRzRhVVpsVWNhWTdSbVRGQzlqc1JoR0Jv?=
 =?utf-8?B?ZDJiNzdmbHYrekpBV2ltbXJkVFFDZGxHUWdnUFhzNkdMRy9yYkc0NmQzbWRQ?=
 =?utf-8?B?SmtoeXYvd2RrR05pZjhTWUNXQ0o4bElKRlV3UUlGVk1uL1lxYlVEc2ZpNXV4?=
 =?utf-8?B?MEs5djhYR0pnRG4wcjc5R0FrZW9WRHpMQnJHbmZiYzI2SlB0ekhNL3QrNnFV?=
 =?utf-8?B?UVlwdXN5V2Nvbk1zcDNpZG14NkE0Q0REREZrSUJhRkZmYml2Yk1UUnA0RGND?=
 =?utf-8?B?WTd2VnBvcUNGQUZxb25pQkRZSy91OUdDb0JFQjh0T3A5VlNuS0xFSmdoQzQv?=
 =?utf-8?B?SDNtKytjdjR6TGlDS1Q5MkRiUWFXVHZ2STlSZ2dSZ0pSaG81Q2FkSHNIb2M0?=
 =?utf-8?B?VFBsdlNUd2JoQ09FWUJDZGNxelFERXZaL25NRmdPRUV4aGFVcFoxeWJYYlN4?=
 =?utf-8?B?UlB0elpPVFFyWlljRFBmdTVNcC9wOUYrRW9GNW9CNHV4T1hyMnQ3QksxY3kv?=
 =?utf-8?B?K0hpY1pxTGQveHRCZ2dMZWxIaURsUThqV0hYN1FDeWcwSHFXUCtMenFUSk5T?=
 =?utf-8?B?RUpkcTJPYk9zTXJJQmNPRDhqSStPNEUvWm10N3R6ZG9BOW9WdjJFK1I3allO?=
 =?utf-8?B?bTlaRnF0dG8vaEl4czNndXZiVW9xQWU3MGFpdy9scnkza0pKaFJ5TGpMY3Bt?=
 =?utf-8?B?Q2NsNU4zRGlTbzZOTjFUM0lOTk4xMFpNbHppSmhJaHcreldKSHVnY1lvMXFm?=
 =?utf-8?B?S0tYMldPNlBYbG5kVlhDdXZWRUM1Q016YVkzQmUyN2ptK0duNllVaEJVREh5?=
 =?utf-8?B?RWFKY3JJcW52RUp0STFKNW1xVGYxZUpISCtUNW9ROU1RenBZNUpwMXJXMmkz?=
 =?utf-8?B?cGVGRnMxbEdHT0kyN1dJRUdKT2xqeExaMmFuTXM1NGRGZUJoNGZ2LzM5b3FH?=
 =?utf-8?B?cXUyZmx4eVdYTktqQUh4ZVdIS2h3WVBwWmNwa3poVno3WnF5ZHEzcVZyRFF5?=
 =?utf-8?B?c2xjbXVLQVFGdDduZ1pMemZ1b0R4UzNWL09hNjhmQ1pjWk01TlFiZGVLbFRh?=
 =?utf-8?B?NmlIS3o1UmY1MkJ5ZXplTFBzWUEwOGdOSHdSOWhuaEdQOFlRTStyNWxRTHhu?=
 =?utf-8?B?YXhBUUdwSVE4WWVwOGdkRnBXd2R2akZlV3puRis2Q2xwaVh2V1NDbFJnclRz?=
 =?utf-8?B?ZnZLVHVsV3k1S0RNVnlETU43ZFlaUXJMTEZFYyt5bERzNFdacXdYSkxHYW40?=
 =?utf-8?B?cFJFTU50SHFka04wM2pXS0s1V0twbFZpMkxLVXFCMFJRdWJwK0lwMFQ3RGVG?=
 =?utf-8?B?S3UvTi9lN2JDRTZPMk8zbEphUWw2WXhCaXluQ0lDSkl6S25iaE5SanIrUHZG?=
 =?utf-8?B?WG5pYjd2MHpaQ3NPY3RpY3pVQ3BaZmUxdzdzZVdqTWFXQWdvMm13OHhOWVB3?=
 =?utf-8?B?NVZmVitSVHpSZ3doN1hxWjZmRUdWTW9jYXVXT3dqYUh6WCt5R0FDSzZnVjNV?=
 =?utf-8?B?RWtXcmsvQ0VaUjNPb1ByYW1LSlBsbVVBVlpIakVXd3pqdU9nSDhTN01DRWoz?=
 =?utf-8?B?d2R5S1ZoT3M4dEVZaG93NVNGcURjc0hiUFRNbloxRXpnUDFjR3BQOEljSFhj?=
 =?utf-8?B?VXR2U3QrRFBlcFhJMElTSjBZTDRSVTh4bTIyOXNMWVJROVFqdEI4N1ptT1RP?=
 =?utf-8?B?eCtZa3gwZVBKZWtkZjgybUFXd28zWUR6NzgrRzFWR0pkRWxWeWtKUnZoWmNO?=
 =?utf-8?B?KzNmQkl2RGpSaEZpRkI5K0x6NXZ4WGtNY2ZWeFdlQm52elB4cExzSlpPWWha?=
 =?utf-8?B?TWxvcTVVaFh1ZFZiT3E4c3Qwd09rRjU5czJVdHlSSU90dzk5cTg2ZzhDR1lH?=
 =?utf-8?B?dC9GRkhMZ2d0V0QxUDl4QnU0UTRaQTgwSWVmQTZITmRHOGdUMUtPbEdLWW5S?=
 =?utf-8?B?K2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <294CABE8A1E1F94F87EEB7E9CC063C42@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8891891e-b4e5-4a68-c45c-08dc4e501f93
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2024 11:22:01.3803
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NSDUV8AgsQo541zkn2O1wZ3QWoqh+GlBU2zRbB0tDIQ/fSDOzu8D7dNgojCdhiZ3LMs5S5/nSORlMajBq2+/vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5814
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAzLTA4IGF0IDE3OjI3IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBNb3ZlIHRoZSBzdHVmZmluZyBvZiB0aGUgdkNQVSdzIFBBVCB0byB0aGUgYXJjaGl0
ZWN0dXJhbCAiZGVmYXVsdCIgdmFsdWUNCj4gZnJvbSBrdm1fYXJjaF92Y3B1X2NyZWF0ZSgpIHRv
IGt2bV92Y3B1X3Jlc2V0KCksIGd1YXJkZWQgYnkgIWluaXRfZXZlbnQsDQo+IHRvIGJldHRlciBj
YXB0dXJlIHRoYXQgdGhlIGRlZmF1bHQgdmFsdWUgaXMgdGhlIHZhbHVlICJGb2xsb3dpbmcgUG93
ZXItdXANCj4gb3IgUmVzZXQiLiAgRS5nLiBzZXR0aW5nIFBBVCBvbmx5IGR1cmluZyBjcmVhdGlv
biB3b3VsZCBicmVhayBpZiBLVk0gd2VyZQ0KPiB0byBleHBvc2UgYSBSRVNFVCBpb2N0bCgpIHRv
IHVzZXJzcGFjZSAod2hpY2ggaXMgdW5saWtlbHksIGJ1dCB0aGF0J3Mgbm90DQo+IGEgZ29vZCBy
ZWFzb24gdG8gaGF2ZSB1bmludHVpdGl2ZSBjb2RlKS4NCj4gDQo+IE5vIGZ1bmN0aW9uYWwgY2hh
bmdlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdv
b2dsZS5jb20+DQo+IA0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwu
Y29tPg0K

