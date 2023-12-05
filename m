Return-Path: <kvm+bounces-3633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E3613805F7C
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 21:33:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DC97281FB3
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 20:33:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B5E36ABBC;
	Tue,  5 Dec 2023 20:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ebc5+BuT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9035FD44;
	Tue,  5 Dec 2023 12:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701808398; x=1733344398;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ltv78nJ1gHwN6Cy47Q5UlREQsMl+gDID4+c84UPm2Dk=;
  b=ebc5+BuT0nqmjgkLSZOd05KhNI5ubbY+pqak9ozyfqeJljh/Ml448NKJ
   zwfOu+G5TIc+IUWmYQwCgyF6MZDCM0RNn08BVLfAWxBvPgIA+Cy4ItXbC
   ZEADnSAYq80wj2guh5qo+/vQxegRwvKqGxpCKZiZlz45xPMMXDKtCKzSf
   NIafJ/aMC92IJxnkS8bUVi1LjUFOobnhG3QVb6H8A91ja5+ZY5O0kXyrF
   8wfecT/ZA2wdDPAxu6bl9OH4VlsmGyD54g5s7swhORNOU7KobD7mis9el
   YJwa2Va0Mrct3wpZJj6jK/zhhttYQxpCl8J2BhdzhHjAkHsu+M+EWa+XP
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="1043031"
X-IronPort-AV: E=Sophos;i="6.04,253,1695711600"; 
   d="scan'208";a="1043031"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 12:33:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="764457808"
X-IronPort-AV: E=Sophos;i="6.04,253,1695711600"; 
   d="scan'208";a="764457808"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Dec 2023 12:33:17 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 12:33:17 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 5 Dec 2023 12:33:17 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 5 Dec 2023 12:33:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jPX8WKh4apIXjlUFNodURLrTMK2aOZvF8ryCKH+C8jPwEPjgH0613QzacDEYlibDBiqmbTRofzKLPn/5vuXcgvt/bkIUyXlniIkKnwos483yZkl2C6I2nrtIgv4YUkUNtroF9gawKzhVhQ0qHiCA8a8QHJznD/LxDOhYVca/B3ABB2ZhA8c8feyF/rc/zYqCo+MDvqhM1eIIDlXmED5arvddeMt7Q1Bf7DvwZLtN2diTvYVkP/a76WrJJNRN+7j/ctGxlvXArxcGzwK0ggxmUZnSxU160/PAO+VXnMCvX6mFmZK82V4AyvUb7bDhcoMoR6M4LQAeMZG6YQTYv29jbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ltv78nJ1gHwN6Cy47Q5UlREQsMl+gDID4+c84UPm2Dk=;
 b=DuZlRvpAvYLl0eVagwyKY/lBhr4QR6WaRQk6JbP9UngFeYVbdQ44eAS19YaMyvFUIuXUQc1WzrK8yBvhG75noUC4qmVzllXJU45EroTlnUj7XH60Gk4ge0q0WCrkacE9lNlGH157jARIgvboaFMv3/6qCVZS/IBbq7U1AsiLOZGSnwbA84fUlQV7/uA+hopDY6L2AKDfWZwmgTIijgV3V7+bN+xhtCzBFyGAohLL6wFkxfObDpoEAx/NQFn2WMjzBq+o41d7B+7k7981P9TYjnB4Gz+5tj/dQ/LzLVgEEFswZPkfeNqCOyFpfCuECxkVJAaEEKKapnAU51+2lxQM7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB5107.namprd11.prod.outlook.com (2603:10b6:303:97::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 20:33:15 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6%7]) with mapi id 15.20.7046.033; Tue, 5 Dec 2023
 20:33:15 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "bp@alien8.de" <bp@alien8.de>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Brown, Len"
	<len.brown@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "bagasdotme@gmail.com"
	<bagasdotme@gmail.com>, "ak@linux.intel.com" <ak@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Luck,
 Tony" <tony.luck@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "imammedo@redhat.com"
	<imammedo@redhat.com>, "sagis@google.com" <sagis@google.com>, "Gao, Chao"
	<chao.gao@intel.com>, "rafael@kernel.org" <rafael@kernel.org>,
	"sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "Huang, Ying"
	<ying.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Williams, Dan J"
	<dan.j.williams@intel.com>
Subject: Re: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Thread-Topic: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Thread-Index: AQHaEwHtT+sYH5Rms0yY5S8b++o88LCa57iAgABYYQCAAAQygIAAA1GAgAAF3ICAAAEJAA==
Date: Tue, 5 Dec 2023 20:33:14 +0000
Message-ID: <0eca4ddc74bc849b68d2ee93411be9b7d6329f0e.camel@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
	 <9e80873fac878aa5d697cbcd4d456d01e1009d1f.1699527082.git.kai.huang@intel.com>
	 <20231205142517.GBZW8yzVDEKIVTthSx@fat_crate.local>
	 <0db3de96d324710cef469040d88002db429c47e6.camel@intel.com>
	 <20231205195637.GHZW+Add3H/gSefAVM@fat_crate.local>
	 <2394202d237b4a74440fba1a267652335b53b71d.camel@intel.com>
	 <20231205202927.GJZW+IJ0NelvVmEum/@fat_crate.local>
In-Reply-To: <20231205202927.GJZW+IJ0NelvVmEum/@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO1PR11MB5107:EE_
x-ms-office365-filtering-correlation-id: 41ef78e9-72fd-4110-9e96-08dbf5d16809
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h4OfDOYXLAbLfH2UBnYvxTPWGCabI+7E/vF8cmcFxL7Rqgg3VFq/W996NMptD35y8S53/qaEu4KIvDYhy1zxwVxFXy3DZJjJPLnroJ+SWInayqz1qVSNJI5WnyE2Rw2xpNHvu+RKK6x0GEhPOyLwPAq6A79ctY/b6zk2odw9MGS08Bf21qCjIOqUlOz9sQBttM23p3kV/bFoy543T7uc0F+aevAXhq3poT4EaJCmAWjM5sA2TmkVkDDcA+qYaynZm1kNxqsZPCCH9d7gaSDyFdPmXgV11ILdHa3JmcbtYy7W9kKCf3r5JAX94Ppel6VYCDdZ+KRbB0wiDHY2SjsNOBcOiNcmwg5gT507M9567GoIi/HVbHxs1KdDWawefBtNV/bu+okeBbZHL4UptS3TZH83f77HvCHGUitX3vIuRDg5TltHvg2GrucoKNzddwH0cUrz8McFjw97v5OE4ikMWJ39eEkDjcXnMds3xI5xSkSKQWPTli1OMdB8jIkNRHQYzVTfBvxfCrpoLi+LNnWZx7PNVwFGt4R+XKtw/X+0Pr6cy14OdSMtuNVe+/ItTtr6+GxnaiW+bAMZFT8cuwT36ZPG8JQgwCXSbP0sWrNJLBr4nsyW51QjOkeixEuaRz9g
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(39860400002)(346002)(396003)(376002)(230922051799003)(64100799003)(1800799012)(186009)(451199024)(2906002)(38100700002)(7416002)(5660300002)(82960400001)(4744005)(41300700001)(86362001)(36756003)(6486002)(2616005)(8676002)(26005)(478600001)(71200400001)(4326008)(8936002)(316002)(6916009)(66946007)(66556008)(66476007)(66446008)(64756008)(54906003)(91956017)(76116006)(122000001)(6512007)(6506007)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NFMzUVZaYllaUm4yUWNkR1JnQ1dNQ1h5VnFkOEhzUCtxLzZld1pvZFk3Q1ZN?=
 =?utf-8?B?OTlOR0tLT1ZPL011SlJJMjYyUWpySjlWSy9QNmhaZ2h0WG01b3RvWkFYNG9H?=
 =?utf-8?B?NzlrdEdleG4xNjlGU2xFeTNTbU45TklEQ2NidDZRRUxFZjNRK3ZKeFdHb29r?=
 =?utf-8?B?anUrS0pGR2ptdE9DTHB5V0pEOUF1Y1RrbElLMGloelQ5MHFaL1lWRjhJZDYx?=
 =?utf-8?B?bzV3SUJGRlN1U3R3R2ptd1VBWHpIK2tZQktJVk11V3NpM0owSEhjc05UNlBH?=
 =?utf-8?B?MnRMWFFEWGQ4dnB4QmJoSm5Jd2wvU1Nvc01pdWFRKzRMVHJYZnhIeGcwa0tn?=
 =?utf-8?B?VktqMzB3dWd2ME5TdGZNdkUzVkozZU5Jdy9pckY1VDBuSEk4eWtYbzgwSEZh?=
 =?utf-8?B?a2JxdXhuNjQyaDZ3clE5bFdaUjFmaDhya3B3MEUwYTJFQ0o4OUhjMzJFRnZ3?=
 =?utf-8?B?RlV6MUw3UjIreVdaZzNOeXZHU3RxN1dicnRHdFFwZWhJYjFETkxvWVdES2t6?=
 =?utf-8?B?ZUc4QzBxbU5pbEs0N0pTZEFjUlFCQ2JGcHViQmhiSFpxblpGTW9oUS9PT20z?=
 =?utf-8?B?cm1nRjRJRlBLUkd6YkJZSlpiV21zWFc5RnZmZWxKSGp3aFJ5bjA3UVljWmRD?=
 =?utf-8?B?WlFvTkIrU0l0U2czcUtnbU5aaFNuQ1lpR01BOEpWMi84bnV1UnB0SFVOZlRW?=
 =?utf-8?B?TzZ5TFFjb3RhUWFHNFFxK2hqTVlqSSs5aTZUVitwcG9FUHVlVlpsUXQxaVBp?=
 =?utf-8?B?OHhLQmtNUHp2bEY3eWJhVXpXZEJtTVByMFB2U2hNRTdaMmNSL2FLemZ3aHFK?=
 =?utf-8?B?RHZ4OXhLcHpxRHoyOG1sZkdlWElUbnR2SUE1U2VrZmI3eVdmUHgvc3Z0V2JE?=
 =?utf-8?B?ODRaeHFUWk1VZTFjNmtLWVVqbVl4ZTlCbGtINnd3bmNIckthOVBRNEgxdmhs?=
 =?utf-8?B?SFdhREJpOVBkMXEwWUZCQUgwYWJYQlNCdWVOM1d1TDliZ0JhS3F5QmEzdUdx?=
 =?utf-8?B?STFxMk5zZVRFZDJjWHhpclZITklQYXVVNnlXL2VxaGpPVk1BU2xmazdtMW44?=
 =?utf-8?B?NFFaU3YxK2dKaC9OT1E1ZDlnUlVHQ2c4M3c3V0QwT2lQZTRVTHJLSmt4Vk4r?=
 =?utf-8?B?ME9iUzdpWTVzTlVBZHh5djFNakNNQzI4QStvN3NyaUpFMElkdG1xR05yNitY?=
 =?utf-8?B?c01TL1RoOThJWUN0ZVVRd3c0ZXprTWI2djBUOUNPck9ndkx4OU03bzlJN2NJ?=
 =?utf-8?B?Ym9jRXZZQmlDdGZHNitlNGZIN0FUUFJqWEgrSk8yRy9pS3JsMkdVb1QxMWMw?=
 =?utf-8?B?UlZzRG4zTjZpeHRXdEF1VmI5QVBlbmM5NEh6VitjZkg4a2Z4YkN1RDBYZEF1?=
 =?utf-8?B?QnBsTE9pOFgvL0RGazFjUTJMaVhHYnFzaTZYengrZU5XUXA0VUxSeDhKT3Jv?=
 =?utf-8?B?OGhDeW50Ynp3VVdFREh2N0o3N0Z1V3diZWJ6MXdWYWpEN2ErMVJGUWlCRjUz?=
 =?utf-8?B?V2MrSHVTbzBRL0Mvcldvc1ZJUDNPTE4zNjVkMWVBRnV3b2x4OGhtNVdGTkM1?=
 =?utf-8?B?TjhIbk1hV1BQUFcxN3Y0NEdHd2VTTzRMeWw4OFhRMkU5V0tSU21EYkttM09Y?=
 =?utf-8?B?Tko3ak1jNkVWZzd4eTlIYWhQSmJ1ZGtqNlkxTWpuV2hhL09RUDFrYUFHbTdS?=
 =?utf-8?B?NldmQk02Z05mWUtzbkVwZngrL1ZFTTNSSHpZeXRzeHd4bDNsTXpIcUw1Rzlm?=
 =?utf-8?B?dkJObXFRb1ZFdFBrTGptSEVOcmZ3dFBtTUJ6ZWwzNko0Vi9sRUZTVTJqYy9r?=
 =?utf-8?B?dE5LSmEwWFpmVFoxbDdqb2VKeXNsRmtWaU80VVM3N1NVRHdrRHJjeE9DZXd6?=
 =?utf-8?B?K1BPLzFDT2NpaEpvUURudmozRVZpNGJGQ0JmTzVpTjNka1FVRldjb2M1Q1pQ?=
 =?utf-8?B?ekFRQTRYUllSaXhZclN6dFhXNVJueDlCUzd6c1RSblN1UmdmeEFwcUNyVDda?=
 =?utf-8?B?UklTSTVZRGhsS1BkY0JlUHpqeVN0dXhNcVZmVzREcmUzK0JOQVBqOGJpSlAx?=
 =?utf-8?B?Z1Q5UkY3SGpHRTh2QTA2b1YyYnRjUFQvTkJNd2t3MHpNdExzbzREOHZ6aCs0?=
 =?utf-8?B?azk2Yk5jb2ttL3RmTGZJcUxCUlRYL2xqaXpCK0NsT1NwdEg1ZkRqTEw3bGtQ?=
 =?utf-8?B?ZkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F0F7C9206A92934AAF18E022ECE7BFE1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41ef78e9-72fd-4110-9e96-08dbf5d16809
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2023 20:33:14.4894
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EuMMA80myrDyFF2FVlxe4EYHvkLzP9suKDlUyywNgXA4gcw+Zk3rvZswklESaHFGGnXm+B0qJnDy35yGkKm3Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5107
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIzLTEyLTA1IGF0IDIxOjI5ICswMTAwLCBCb3Jpc2xhdiBQZXRrb3Ygd3JvdGU6
DQo+IE9uIFR1ZSwgRGVjIDA1LCAyMDIzIGF0IDA4OjA4OjM0UE0gKzAwMDAsIEh1YW5nLCBLYWkg
d3JvdGU6DQo+ID4gVGhlIGRpZmZlcmVuY2UgaXMgZm9yIFREWCBob3N0IHRoZSBrZXJuZWwgbmVl
ZHMgdG8gaW5pdGlhbGl6ZSB0aGUgVERYIG1vZHVsZQ0KPiA+IGZpcnN0IGJlZm9yZSBURFggY2Fu
IGJlIHVzZWQuICBUaGUgbW9kdWxlIGluaXRpYWxpemF0aW9uIGlzIGRvbmUgYXQgcnVudGltZSwg
YW5kDQo+ID4gdGhlIHBsYXRmb3JtX3RkeF9lbmFibGVkKCkgaGVyZSBvbmx5IHJldHVybnMgd2hl
dGhlciB0aGUgQklPUyBoYXMgZW5hYmxlZCBURFguDQo+ID4gDQo+ID4gSUlVQyB0aGUgWDg2X0ZF
QVRVUkVfIGZsYWcgZG9lc24ndCBzdWl0IHRoaXMgcHVycG9zZSBiZWNhdXNlIGJhc2VkIG9uIG15
DQo+ID4gdW5kZXJzdGFuZGluZyB0aGUgZmxhZyBiZWluZyBwcmVzZW50IG1lYW5zIHRoZSBrZXJu
ZWwgaGFzIGRvbmUgc29tZSBlbmFibGluZw0KPiA+IHdvcmsgYW5kIHRoZSBmZWF0dXJlIGlzIHJl
YWR5IHRvIHVzZS4NCj4gDQo+IFdoaWNoIGZsYWcgZG8geW91IG1lYW4/IFg4Nl9GRUFUVVJFX1RE
WF9HVUVTVD8NCj4gDQo+IEkgbWVhbiwgeW91IHdvdWxkIHNldCBhIHNlcGFyYXRlIFg4Nl9GRUFU
VVJFX1REWCBvciBzbyBmbGFnIHRvIGRlbm90ZQ0KPiB0aGF0IHRoZSBCSU9TIGhhcyBlbmFibGVk
IGl0LCBhdCB0aGUgZW5kIG9mIHRoYXQgdGR4X2luaXQoKSBpbiB0aGUgZmlyc3QNCj4gcGF0Y2gu
DQo+IA0KDQpZZXMgSSB1bmRlcnN0YW5kIHdoYXQgeW91IHNhaWQuICBNeSBwb2ludCBpcyBYODZf
RkVBVFVSRV9URFggZG9lc24ndCBzdWl0DQpiZWNhdXNlIHdoZW4gaXQgaXMgc2V0LCB0aGUga2Vy
bmVsIGFjdHVhbGx5IGhhc24ndCBkb25lIGFueSBlbmFibGluZyB3b3JrIHlldA0KdGh1cyBURFgg
aXMgbm90IGF2YWlsYWJsZSBhbGJlaXQgdGhlIFg4Nl9GRUFUVVJFX1REWCBpcyBzZXQuDQo=

