Return-Path: <kvm+bounces-11697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 363B3879D96
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 22:41:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6EB61F224C0
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 21:41:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D830114374C;
	Tue, 12 Mar 2024 21:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="exWmKvuS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9143E13B2BF;
	Tue, 12 Mar 2024 21:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710279687; cv=fail; b=FKjD0zARYWDIuR9VViMLJXmNC/Xnvky1AB7P4y/WTqP9s/UK90zopjiWXevAfOBlbmFkWBgAYPbvoha5RQOk7PCLfuN4q3NlBovJHJXz99St04RxmSV+/I5nvXvklTJtwNbC0pvzgMbfTBxaX9rH7nrpr3Uu5VogguM7/llwhaY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710279687; c=relaxed/simple;
	bh=yp1FsAIYMQg5mtWNuUPFteSRu7tKeRqYIk00S2yN9v0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HtDKuedbRmEMZq1xdEodeG3afkwecpzFQU3xm/H0eKJTq9KbyTYej4ZPciGd+3MXL0bHTgoi3SyuGzb5Pxajk/EJteORK5H9VkhU/hzHWTYM1lqB0ga2Krdbpk5cbtdeGZJQGELsh4+PoOThz1Q9Zvw7JnRZ8cuhHO2Ifbe1mTE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=exWmKvuS; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710279685; x=1741815685;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yp1FsAIYMQg5mtWNuUPFteSRu7tKeRqYIk00S2yN9v0=;
  b=exWmKvuSu4QdM0FLeGf0FAy0OIFLRe+b4Vn4sfzBa3sV5iSRBGz7NaLp
   wr428drluM1b47mBA5sa6V5B3FlkfQyGWkQUV+PlvVag1pnoIRvowDxwj
   SgPCG6RvBl2Pr5xpDBrWKO6WhQYQa4z1BdCjUN/8aB2pX/xryHC6y/ErN
   Yuf5cqGzSRi1O/5FdgU9Q5KGTrBS6pFcmJRS4NtfcHmjKPMhWElisHZ8D
   mYKD+5/BS9mrpJ7j+rAW+ZU4RaKrb9zicZmUAmM7PcYWvOlBkjT/XrcVT
   4cXW3GmqTM4zZVoG8bqig6AOm51Asoc58HIV9LuCgGFO2fhR55ru60pem
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11011"; a="8830794"
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="8830794"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 14:41:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="12143287"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Mar 2024 14:41:24 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 12 Mar 2024 14:41:22 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 12 Mar 2024 14:41:22 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 12 Mar 2024 14:41:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EtzVBiuLFIpj9Wczlr2rsOFlpaSPlgz4VXEOlDkw7abijgYQmDNZ4ET8h/PCHahU4OgS/Z9QzUtLn39NpfymKuS4ZggdbkO9bvCRKpFXpYJeDsOBGl9wcdhcQXFCZCHggo75IJbqARmIRTiSC7BFs1GSpDjEcvcKY1XvYnecARQU+zg/ZOdr2eqCNBMudj0xvHKY9JdTl0uXs2R/NEROGNoLnqKDTUkfr6O81K8nklGjji/cEWWlltzGVctAwgCVyH22360JUY9jUpGZQr/nmCfr7ZRL6dnaYOsVdmNCR2jc8Zm1upkgb0kEGuwIOpkDX08GRJug+g84XCd6sYz0MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yp1FsAIYMQg5mtWNuUPFteSRu7tKeRqYIk00S2yN9v0=;
 b=aup16H9X1oA1SE9GzUyYwh8sQGPLw+aI14M7TrYcihRARp+mkF4/vSI6VwqkEH8iI13GhGu7Q4UpZW6ErGBqO8jGygkRZWgpau4UeS6Sx76cVKO9ao2qA54O1pODTbk07ADLAJgrB31AHAAilfZBVkAUg/XL8vZ5Dbp+nRlUx+bacyuN5hfYa8d0XxSUWfC5/59LjSI93Vl7T0aDEAHrvH2guG+0OVjyhR5WuUwrFHgDxX99gyT+BWk5w0ks6txXa8FDtuaw1cFQJE1ZTuQjjSHGOjzl2i82fMZHN9QgBdDyMOfePGxrphQEOnT/DCMseoAelsmtEPW6fyjxJy9swQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB8018.namprd11.prod.outlook.com (2603:10b6:8:116::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.18; Tue, 12 Mar
 2024 21:41:11 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7386.015; Tue, 12 Mar 2024
 21:41:11 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "dmatlack@google.com" <dmatlack@google.com>, "federico.parola@polito.it"
	<federico.parola@polito.it>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 6/8] KVM: x86: Implement kvm_arch_{,
 pre_}vcpu_map_memory()
Thread-Topic: [RFC PATCH 6/8] KVM: x86: Implement kvm_arch_{,
 pre_}vcpu_map_memory()
Thread-Index: AQHaa/6D7nn573Vr+E2nz60+bAfcD7EzPxoAgADdMoCAABx4gIAAezgA
Date: Tue, 12 Mar 2024 21:41:11 +0000
Message-ID: <3c840ebd9b14d7a9abe0a563e2b6847273369dcd.camel@intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
	 <66a957f4ec4a8591d2ff2550686e361ec648b308.1709288671.git.isaku.yamahata@intel.com>
	 <Ze-TJh0BBOWm9spT@google.com>
	 <6b38d1ea3073cdda0f106313d9f0e032345b8b75.camel@intel.com>
	 <ZfBkle1eZFfjPI8l@google.com>
In-Reply-To: <ZfBkle1eZFfjPI8l@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB8018:EE_
x-ms-office365-filtering-correlation-id: 11391cef-7dc8-43f8-1dde-08dc42dd225c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mr3KDsPAFFdJf7MeziofdSTIlnWkEfD6XKJOW3lTiUGx4V+VYRS13HNCYEqN7or1dRTi3tzmnmrycAsWPBl403c9pPTD86dTM7auO9syKKgH7aM01m+e+YlfqZWx2FqxlrNDYEH/gwL9Sj8tFFU9XVUJ8LJ6sWfD2i+aR7DOuCg9UMEPcgtzLcXGvuf2X/iH68q4WKAKRmbdD/Z8vHxSDOLyTgZBJXCXiIDEoDJo+iV6kpfKCsQYSFeN2dOZPK/xd4owHFB1gnd1SNLho9iFPncc8t1VdXUM3FWEEmdUay610F7ZKKrvH9GLg+XJxh8N8S/iDlTaBa+92+C8aDT08wTpwEJG8iyupzuu+XAX4dKhspoGTTh4HKG/n51DcYScZaqxQ61TFFgI+opkjfxeyMMShXwEeIyKapxciM4uoRZxX9JXz8sekfobLLQEqaoW049pK4bNnkqC1C+lGWQdQLWlhW6LS09JYz0JG28oEDUI04ads9G1tzyRHmhSfZRwb63CI4G8hIWVXZGGEVtT0v+WCgItZUYNuR/NnvB8i5c+U5RairDdVGKFueNmv1rThhD179Dyd859lTQwXnt0Lozevc/lrN29/P5usuyUA3+HBYA+ZKGqgn1cuBAjjtRbmpgjqhkefGVURcGQze5hR6sEuVijjyBf5kH1WWiR9IA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NmxQQS9YdDY0ZFhPbDRZNmszZDhMbHlPTDE5eFI0ZlZWZ05PZHRlQWxFNDZO?=
 =?utf-8?B?cmZnTEJBa0V2OFFzTFZxTEpOM2ZDSkFlOUQwWXFzTnZhTzA3R1NzWlMyS0NW?=
 =?utf-8?B?R1Vac1lmRE9JZDFOZGpRSFJwSXNRaDRMbzl4N1BsQzI1bXRJU29BWVlxb21n?=
 =?utf-8?B?and2YkxkRDFCN1VseEFYQ0ZORlJqY1dtbk56MFFkYWE0a1Y2ZFhzYlFzc3lS?=
 =?utf-8?B?dmtEU1l1K21LMWJlT0FtRkpMVTNwRXlXMS9JaTFwQzBMSS9uREJUbnVNR3Iz?=
 =?utf-8?B?Q2hkZzdFdEJYNVhvdGcxMXFpT0FZVFpxc25pUmQ0a0FLRzRoR2JXNHMva1h3?=
 =?utf-8?B?aHF3b1V0VGJ5aXo2OU55WkdFSXNKczh5SW9tNi94QmdHRlFmSGlsVkp3ODRM?=
 =?utf-8?B?c1pzK2ZnZmVGRENzMnZ4S29OUUpNQmZLN1Z3K3oweS8xZmx3Q3N1bGsvNUsr?=
 =?utf-8?B?VjBqSFJ1d0dxSjZGWnBSL3JrSEhTQklFMlAzY1d3aWNWZ01VVzZJa3lPdldx?=
 =?utf-8?B?eTUyM21TZEdUdGFEY001alF3N2lqL0RNTElnaXl3TEtqZUxKRUZZRUdlVndq?=
 =?utf-8?B?eFh4WUJYRjlzNDAvSEFOUDFqdCtUWFBVM2xQWitrcFlleHh0b2pRRGVJYThR?=
 =?utf-8?B?VXJOTDNQU0RpVmNLMThpaWdWeUhpMVRXb21pcWNLZ1VRUUZaNjNDek5vbFI0?=
 =?utf-8?B?NmQ3Qnh4MVgwSlphQXI2VkVsdVJwb1pldjBQWWtpUUg5Sit0YTdKd2RqaXpQ?=
 =?utf-8?B?MzgxbzFmek0rdk9DT3BZOGFHcEdrSW1PdFY0OGRmN2pwZlJuWGV5TGFZNG41?=
 =?utf-8?B?K3JXVnF2Y2phd3A2eDVjQ2FmeFlnRlg4ek10N01HelNBTmFOT1BaU3hseTFu?=
 =?utf-8?B?dysydElOSVJINHFPUS9pVWoxbTI1ZkQ0REF2WUxoMGdwaWsyc0pKL0xlaWhG?=
 =?utf-8?B?a3dqS1YzVllqMlZaeWI2Q2FuRHdKcUlHWW5WMnVwY0ZJci82SjZSTjVXYTM0?=
 =?utf-8?B?cjBRMTU2T3k2RG4vNExadENyOFNyUU9BV2JvUW1EUFAyUVZ4a3I5Rmw4L09h?=
 =?utf-8?B?WU9zU0x6NUlodGQyOVpMRDltZUZiRkRKNXV5a2FYeVVvQVhkNUk1dk0xTldW?=
 =?utf-8?B?YmRNaHJZV2lEOWhqbVI5WHhIZnRDYXF2VDBTa3kzNVNTMUJKOWo0Tm55RE9I?=
 =?utf-8?B?SGtxOTNIN3IxKzVJOU1WUVU1UWtpWTR5d3IwY0FoczlqZmlNNmpOVzh2OVJu?=
 =?utf-8?B?L0NIUnUvNkI5ejJtSGxpMU01UWZhWTJsYWY4TklvNlJJV2hJU3JPdHZNWFF6?=
 =?utf-8?B?R0lwVjNhQURLeDI3V0wrVkhVcVk0YUhUMkl4TFJxWFpGMjNsbnV6eUNWZkZx?=
 =?utf-8?B?bllXYUc4Zlk3TzVSZjNjL1RibEI0ZzM5SkttclhBODhHK1NJMUQ0NitPd1ZB?=
 =?utf-8?B?bG81WmhqMTZZVHNQUkN5T3VtTTFONG1xOEptd1Bsa2pWd3h4VVgrM0VvNlFr?=
 =?utf-8?B?ZWVpSzhLUzA5QU5tYm5XQ0pOMWNVYkNVVjFzL2w5RkFUejlSb0JuWllIeTRn?=
 =?utf-8?B?SnhZNStzeHhDZHlLQnh0L01WeFQxeUVUMjJGSWticDBKWjRIV1pOcW43WlZl?=
 =?utf-8?B?MFhwOHFEN2ZWeXlCNDlUcXNNK3NydWg0Z2xZNWVFdHE5T3JiVlVtcDN3TjEw?=
 =?utf-8?B?Y1lHV0h0WVNsdUpjMjByM1JnNWxsUFN1Q1d6bDU4elUxZmM3R01PQUtWRWNm?=
 =?utf-8?B?dnFrOEJtUFZ0aEdaQ0hYY0lzcFo0WElnYm43dGdoUzhKMWlDYmpvNHJLNkpO?=
 =?utf-8?B?ZENqUFl5YmRxbE9xLzdkSjNKY282VWx5VXpMd2hnZ1RHY0traElZQXpMMEY4?=
 =?utf-8?B?cHB6NmlXZHNua2RwWXR3YU9FQmNBVm9EWVBYbGdrSElYQ1JsQVorWDJzM3ZE?=
 =?utf-8?B?WDV0dEh1cVBHajArQkNVanEzdTNLR2xxcmQ5MnZVNHNrbHV1K29oOFJ0aTVG?=
 =?utf-8?B?NVh4MHJGSzgrZ0wwQUxrcVgzL0tXVFdIQzU3Zjl2WlErRGptQmVCREhHbGtR?=
 =?utf-8?B?dzhXNDlEck83cmVDdUZZc0VneDJKWnMyTFFyUWUxUGZ0VWtPQ1hTRlZPbEo0?=
 =?utf-8?B?b1JJRGViQ0ZxYjFoenJKMHg5U3NiNWdGdXkyVk1ReU1VNFFORkNDbmRoNHk5?=
 =?utf-8?B?TUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4BF04090E30CDA439C244EC955555E82@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11391cef-7dc8-43f8-1dde-08dc42dd225c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2024 21:41:11.0955
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P2nb05d3Vx2X5w/juroHKbHJGqiFbNvG/s+ge5Ybtz58FSPuhgbT90aVJYvMltZjJ5Zx0qKY+Cn7y3H+4EiD2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8018
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTAzLTEyIGF0IDA3OjIwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIE1hciAxMiwgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+ID4gV2Fp
dC4gS1ZNIGRvZXNuJ3QgKm5lZWQqIHRvIGRvIFBBR0UuQUREIGZyb20gZGVlcCBpbiB0aGUgTU1V
LiAgVGhlIG9ubHkgaW5wdXRzIHRvDQo+ID4gPiBQQUdFLkFERCBhcmUgdGhlIGdmbiwgcGZuLCB0
ZHIgKHZtKSwgYW5kIHNvdXJjZS4gIFRoZSBTLUVQVCBzdHJ1Y3R1cmVzIG5lZWQgdG8gYmUNCj4g
PiA+IHByZS1idWlsdCwgYnV0IHdoZW4gdGhleSBhcmUgYnVpbHQgaXMgaXJyZWxldmFudCwgc28g
bG9uZyBhcyB0aGV5IGFyZSBpbiBwbGFjZQ0KPiA+ID4gYmVmb3JlIFBBR0UuQURELg0KPiA+ID4g
DQo+ID4gPiBDcmF6eSBpZGVhLiAgRm9yIFREWCBTLUVQVCwgd2hhdCBpZiBLVk1fTUFQX01FTU9S
WSBkb2VzIGFsbCBvZiB0aGUgU0VQVC5BREQgc3R1ZmYsDQo+ID4gPiB3aGljaCBkb2Vzbid0IGFm
ZmVjdCB0aGUgbWVhc3VyZW1lbnQsIGFuZCBldmVuIGZpbGxzIGluIEtWTSdzIGNvcHkgb2YgdGhl
IGxlYWYgRVBURSwgDQo+ID4gPiBidXQgdGR4X3NlcHRfc2V0X3ByaXZhdGVfc3B0ZSgpIGRvZXNu
J3QgZG8gYW55dGhpbmcgaWYgdGhlIFREIGlzbid0IGZpbmFsaXplZD8NCj4gPiA+IA0KPiA+ID4g
VGhlbiBLVk0gcHJvdmlkZXMgYSBkZWRpY2F0ZWQgVERYIGlvY3RsKCksIGkuZS4gd2hhdCBpcy93
YXMgS1ZNX1REWF9JTklUX01FTV9SRUdJT04sDQo+ID4gPiB0byBkbyBQQUdFLkFERC4gIEtWTV9U
RFhfSU5JVF9NRU1fUkVHSU9OIHdvdWxkbid0IG5lZWQgdG8gbWFwIGFueXRoaW5nLCBpdCB3b3Vs
ZA0KPiA+ID4gc2ltcGx5IG5lZWQgdG8gdmVyaWZ5IHRoYXQgdGhlIHBmbiBmcm9tIGd1ZXN0X21l
bWZkKCkgaXMgdGhlIHNhbWUgYXMgd2hhdCdzIGluDQo+ID4gPiB0aGUgVERQIE1NVS4NCj4gPiAN
Cj4gPiBPbmUgc21hbGwgcXVlc3Rpb246DQo+ID4gDQo+ID4gV2hhdCBpZiB0aGUgbWVtb3J5IHJl
Z2lvbiBwYXNzZWQgdG8gS1ZNX1REWF9JTklUX01FTV9SRUdJT04gaGFzbid0IGJlZW4gcHJlLQ0K
PiA+IHBvcHVsYXRlZD8gIElmIHdlIHdhbnQgdG8gbWFrZSBLVk1fVERYX0lOSVRfTUVNX1JFR0lP
TiB3b3JrIHdpdGggdGhlc2UgcmVnaW9ucywNCj4gPiB0aGVuIHdlIHN0aWxsIG5lZWQgdG8gZG8g
dGhlIHJlYWwgbWFwLiAgT3Igd2UgY2FuIG1ha2UgS1ZNX1REWF9JTklUX01FTV9SRUdJT04NCj4g
PiByZXR1cm4gZXJyb3Igd2hlbiBpdCBmaW5kcyB0aGUgcmVnaW9uIGhhc24ndCBiZWVuIHByZS1w
b3B1bGF0ZWQ/DQo+IA0KPiBSZXR1cm4gYW4gZXJyb3IuICBJIGRvbid0IGxvdmUgdGhlIGlkZWEg
b2YgYmxlZWRpbmcgc28gbWFueSBURFggZGV0YWlscyBpbnRvDQo+IHVzZXJzcGFjZSwgYnV0IEkn
bSBwcmV0dHkgc3VyZSB0aGF0IHNoaXAgc2FpbGVkIGEgbG9uZywgbG9uZyB0aW1lIGFnby4NCg0K
SW4gdGhpcyBjYXNlLCBJSVVDIHRoZSBLVk1fTUFQX01FTU9SWSBpb2N0bCgpIHdpbGwgYmUgbWFu
ZGF0b3J5IGZvciBURFgNCihwcmVzdW1ibHkgYWxzbyBTTlApIGd1ZXN0cywgYnV0IF9vcHRpb25h
bF8gZm9yIG90aGVyIFZNcy4gIE5vdCBzdXJlIHdoZXRoZXINCnRoaXMgaXMgaWRlYWwuDQoNCkFu
ZCBqdXN0IHdhbnQgdG8gbWFrZSBzdXJlIEkgdW5kZXJzdGFuZCB0aGUgYmFja2dyb3VuZCBjb3Jy
ZWN0bHk6DQoNClRoZSBLVk1fTUFQX01FTU9SWSBpb2N0bCgpIGlzIHN1cHBvc2VkIHRvIGJlIGdl
bmVyaWMsIGFuZCBpdCBzaG91bGQgYmUgYWJsZSB0bw0KYmUgdXNlZCBieSBhbnkgVk0gYnV0IG5v
dCBqdXN0IENvQ28gVk1zIChpbmNsdWRpbmcgU1dfUFJPVEVDVEVEIG9uZXMpPw0KDQpCdXQgaXQg
aXMgb25seSBzdXBwb3NlZCB0byBiZSB1c2VkIGJ5IHRoZSBWTXMgd2hpY2ggdXNlIGd1ZXN0X21l
bWZkKCk/ICBCZWNhdXNlDQpJSVVDIGZvciBub3JtYWwgVk1zIHVzaW5nIG1tYXAoKSB3ZSBhbHJl
YWR5IGhhdmUgTUFQX1BPUFVMQVRFIGZvciB0aGlzIHB1cnBvc2UuDQoNCkxvb2tpbmcgYXQgWypd
LCBpdCBkb2Vzbid0IHNheSB3aGF0IGtpbmQgb2YgVk0gdGhlIHNlbmRlciB3YXMgdHJ5aW5nIHRv
IHVzZS4NCg0KVGhlcmVmb3JlIGNhbiB3ZSBpbnRlcnByZXQgS1ZNX01BUF9NRU1PUlkgaW9jdGwo
KSBpcyBlZmZlY3RpdmVseSBmb3IgQ29DbyBWTXM/IA0KU1dfUFJPVEVDVEVEIFZNcyBjYW4gYWxz
byB1c2UgZ3Vlc3RfbWVtZmQoKSwgYnV0IEkgYmVsaWV2ZSBub2JvZHkgaXMgZ29pbmcgdG8NCnVz
ZSBpdCBzZXJpb3VzbHkuDQoNClsqXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvNjUyNjJl
NjctNzg4NS05NzFhLTg5NmQtYWQ5YzBhNzYwOTA3QHBvbGl0by5pdC8NCg0KDQoNCg==

