Return-Path: <kvm+bounces-14805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 431748A71F8
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:09:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65BF71C210AC
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 17:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 347C81332BE;
	Tue, 16 Apr 2024 17:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lvj6IuLo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B881311AE;
	Tue, 16 Apr 2024 17:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713287373; cv=fail; b=MyXsM+vDLa+Nrk1f4vV29rIosBnKvbHkD40qGnnMrX22ESC69OjFQqafBzL7Toe140DILmMYcfHEdcgtf60FEMe9F1UaRslGJJPSetz832OVtXTGtGNijx3iCYGeGizmI/3NhfHe8SC4cOW0zAHnxe/SJF6RcnTgQsZe9VuQpoY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713287373; c=relaxed/simple;
	bh=OVZ76Aiynj8Ta+kR5P6i7hEj0Un8v0yIIab27on1vfQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YxWAIFWLNRfUNdrNSIHRl3MtRu+Cqgt34fLs09GaVwBx6BkZA/ob55pitGYmFYt8uPR8ZrIdGvG8A73eyg1GFgzY7DsuShSxJU5/fbdGBz5+HfZT05pr0kpVftmlAJ7t0to7hplFjA4aSBEmlUnNTHuS7APg6roP9cgj9F7thvs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lvj6IuLo; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713287372; x=1744823372;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OVZ76Aiynj8Ta+kR5P6i7hEj0Un8v0yIIab27on1vfQ=;
  b=lvj6IuLobs9A5Uj4NxTcgQPp37CGn24xeDrZR9z5s/FotqKzn0TfaCV1
   32i9LTy2ZfR+wsSGoHeHOq3bvKUJEeFf8pu+jy6Ic/yGwoZ0X2Lyt8Pao
   uU3LZq2g5OOtuIZzgaJnMav8dcGDNw6g0vynpPbT1N5D6MT36cy1St9EY
   HOdAjdOx/no/n32ylt9vCzNRJVl+NIXzpUeF9O5iWkZOhHqp0QPPeZ0Fq
   7ZNtL8Oi15cyyP0/fyhMLNCWOXtzIoi2jRnqYz4nhG4I2u6s45HoP52vV
   ZQhrU9EriFAEuY8gD0fZWeam3/dUlPwVfRNBo6tYgEAYjr/BJ7HCrajrd
   w==;
X-CSE-ConnectionGUID: 6WplKzDgSrCdp7qQBA4zUQ==
X-CSE-MsgGUID: G8d1MOlMQ02SmsH1C0wpIQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="31224574"
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="31224574"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 10:09:29 -0700
X-CSE-ConnectionGUID: sM4cjRyHTT2Z6+YcgiNASg==
X-CSE-MsgGUID: oHI7nODLSX2uM+6NVHhbyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="53309729"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 10:09:27 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 10:09:25 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 10:09:25 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 10:09:25 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 10:09:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EXGADQ9wnS0nUm6bGjnxS5FTc6Huvi4sOCa8u4iW/Gh0e3eLbJT5JSsooxpK7DxHwR0dE0MlixZTXZo7VJRyv1bNojQWfsrD6M6aw+t0lGUR+SdLnnFY8zNt78I2YQQ6QE5lKlqIZx7JU3NZ2wx73K08ansmLYyAPcppoJoo7eTAG6p08fEzMLS+TnJTWPHTcLDR/X2WAXWzqL7LNbfNthffcMZolu24paRSvoQWanIwD5jvX3WLE4GcfUaksKh0NhLd8T+FQVBkaNlk3XO931avVXb750GeBE2Htct6MTrGliYF4Zytg1SsnJrkGwDN33HL0HIlKmC50uER1U5Q4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OVZ76Aiynj8Ta+kR5P6i7hEj0Un8v0yIIab27on1vfQ=;
 b=dwFLnEd5g+4ctIYTSVf0rplNDRG5+9aBoc4xS8PYu9I1FkLBzfyFnvsQah+D1T1JNlt/le77WAHezrAStLmc4KnlSIdSUrgwlPbVFwTjMX2tTeLXIbOD57MMZKIi8e6HnwO7HdZ2x5yKwduTgcm1Vd9AsCBg99iBGsLz01oUfLyvAPfMgawQfqFb1fp+2BNxXJRyldD+dJ5/aqRxuBTtcvFEv1AycCer+aAsb8QDMaVKTcYQ2/Alb/zwLf84wssXjRRaE74N9PgQOiUdrvQWohIzRblGKCV9lD7l9U2liBddaXIB8961Ps7WoIfwFm+Y8zeoHh5pV1+se/QQNcqJ0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB6099.namprd11.prod.outlook.com (2603:10b6:208:3d5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.29; Tue, 16 Apr
 2024 17:09:18 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7472.027; Tue, 16 Apr 2024
 17:09:18 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "jmattson@google.com" <jmattson@google.com>, "Gao, Chao"
	<chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Chatre, Reinette" <reinette.chatre@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4 0/4] KVM: x86: Make bus clock frequency for vAPIC timer
 configurable
Thread-Topic: [PATCH V4 0/4] KVM: x86: Make bus clock frequency for vAPIC
 timer configurable
Thread-Index: AQHae64tVrLEvOd2BUmbFm4CAYtKL7FrSkSA
Date: Tue, 16 Apr 2024 17:09:18 +0000
Message-ID: <6fae9b07de98d7f56b903031be4490490042ff90.camel@intel.com>
References: <cover.1711035400.git.reinette.chatre@intel.com>
In-Reply-To: <cover.1711035400.git.reinette.chatre@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB6099:EE_
x-ms-office365-filtering-correlation-id: f1a32054-2efa-42d2-7460-08dc5e37f381
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FhRwYjfylpL6uw0DhMXVuA5VVP2TKQXj+HaHexH7l/oE0K8jpKIHGdecCMRu09pLSQtetzbKycfWdOvgisCJhOpgi2+FvwCu/k7O6PRaqFFfSZZpNypjQedLWFKQMXLOdu+VHPdaPqRUgylI/QusisMqHSxC52FmS1nxrl0IkqukSKUtVgTEBkALvuM6CnWxWoZhI+5/LQGB2PLsmPXoRPtIk0fhc7Z+dFJSLV1znxJKZWpq1QePjr7HHADLvw46FZSW+topZsJJ4Clw7mR9swEuDyO8WPr6E9uv6SRlafdyANuJ46t/zPsh5zaSr3DRW6flYza+w7JzxSVTdtwY8BZdZPhEs2qcSX7AJjXL+k6kpmeK3A+OKw5ort4J5TbkX/zYlfGn4bkStfVLDfgMMkdNzqlgCRMQRFpfFT9cklXCQQPcXXmRYLCGc+PkTaipvJv3kQiVuAoYRY6z3qMUDlkCZsIHcTktQwPQ5nohUbAl3aX+nvv3VyxGIMvswlAyH1RMfX0Ay26AzQlh2tnGo7sk8WSxk0D28PpCfTIU0tTV3AbEZocH1jie9/c4TDYzyqDiGqUckekBAm3p3jSvaBmHpb+BiM8VGXZ/vQrl0NoOEyoCUB7W5Gk9YDStwjYjvQXjT2xot+a+1P5u8hTOvjJDptFdlVnz5zMhsNcRPDyHu8H8aqPcJo92Evzf2jiaQooRhpylU+6G7Be7/90FvLAgIomOh9UgLuj1BT8asc4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(921011)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZW93eHpXOGlWNVlvUTRhOFdqc2VKV0NrdHJSRklnVWEvVXBkR2YwZUxxRkR4?=
 =?utf-8?B?V0xVYXRaWFNtWGQ3UVBZS1MzQ0lJSFY3ZjFuYm5hZ1hIM254QTZiNVdrMTVv?=
 =?utf-8?B?QTE1T005KzJxaW8yY2hGU0NDM0dQVnRaOW5xeS82ZVd0eThES3N0a21zelhj?=
 =?utf-8?B?endTRzd5NU1ENXVRdVd5Wk5vM0syWFJlRXBsbW52eHA3blViZC9UVHFiNTQ1?=
 =?utf-8?B?Z21SSDlLVTZmQWc3N0lqWG1TTW16QUg2Z1MrNy9BMW5kcEVWN0FYeXNFWk1x?=
 =?utf-8?B?V0tqMnZ5TU4rYjFvUUxKTTBEUlZOcEZ0Yk55Z0dRV0JjQStIbnlxNU8zMmxY?=
 =?utf-8?B?dy81Nks2K0lueno1WkduelNjNDNPQk00aW16ZFlERjN6ekk4VDNsK2ZnbWxm?=
 =?utf-8?B?NU9Xa0QvOFpjZ1M3UGJ0QkVHSWVHQ2NOYnVUdzJMVEN2V2ozaUpmVzBhcmVK?=
 =?utf-8?B?aTZjSzQ2RkowMTFyaitac1FhL05pWjJBdXZ5dG5QaldtM2wzblczWEE0dSsw?=
 =?utf-8?B?TkJVZ3o5bEdwcmxCUnBGNVFzUDZaRmtYTzBZdGhIRU4reFJ5RDJ6NHRBQlZJ?=
 =?utf-8?B?K3ljYlQrY2ZiMnppVlpWREVybmEvenRBS1R4TEJiZG5YZmNtMFd5eGZ0K2RP?=
 =?utf-8?B?dkpLbG40MHphd09Va29aeVFmSWdON1ZqcGlSeVRHWGhGb3lmMTNMTkFQMW5v?=
 =?utf-8?B?M2RWdU9NU1VOb0R3WVY3aHJXajlLS1F2M0lkcEJGOThzVVBBRlJUbURSN2lV?=
 =?utf-8?B?TkhyNW4xaHpLMWtlY1M0eEJFQWc1SWlZRy9ONVQzRUJEdEk1dGZBc1V6ZFlC?=
 =?utf-8?B?cm9OTjhHalFWVTBHbWRXcFlyYU9TRXNrM1YrUk8xeEJNdk4wckNGN2NsYzQ0?=
 =?utf-8?B?Yi9GckpDcFFFZWVsZGduQk9PanlyRVY0Z2FneG0rRk95L25uOTRuaXFmNjZi?=
 =?utf-8?B?dzBLamQ0YmhwSzFaTWN4b2NxN0g1bFFkNmhXRmJVdkNpdGhGcUF0Mm1HaXFu?=
 =?utf-8?B?SE1ZZU12SmpsTWlrL3VkWThFNU05YVZWVERyUW1OVU1JWVR4eHlTRnBIUTFk?=
 =?utf-8?B?S3YzdWVnNkszcGI0ZWxsMjFvak96NlMweWVyeEVqNmdzUXhqZWhtNDJYWHp2?=
 =?utf-8?B?SCs0RGc5WGJZaTJhSzZZR2hBWDJ3MDliR09wWGdOZVczZjNXTWVHdldYUDhS?=
 =?utf-8?B?RUpDdnRkUzVDZUhUQy9TUnIzZ1dLaTk2MFU1Vk1UMmdSajRGMmN2dXAwME1D?=
 =?utf-8?B?WHg4R1ViRTJKUFh1TTMrVTFOQWpFell2MER0MmZ4aVRBWWhpUExkczFGcnhU?=
 =?utf-8?B?S3ltZXRtUzE4SWRqNFZGWXpSbUdqcHZrdVF0WnFJbG1qQWdFbXRqQ09JRkRD?=
 =?utf-8?B?TUtPbjQxQ2FKQURpOXNSTVJYU3dEcEJ4UjNlQnhzNDVqWXV2L2h2SXpDcmNF?=
 =?utf-8?B?VU9leHd4WEhyWXZKMitTUjB2aDN0RENkWjB5dFNEZXJjYXZtcCtrQUYrTStC?=
 =?utf-8?B?a2FvZk9TTGFUcEMzcFNRUlNMT2xKNGdaamNwOXVUbk1oY01YV00zaFgreFgy?=
 =?utf-8?B?WUVTL0Q1R3JJNGlXSWg0eWx4RVlBbmxjOXQzakgyK2htcUswdkVSano2d0VV?=
 =?utf-8?B?M29xYnVFN04xT1p1TXZFV3NYT2lqUzVXaTR1cm1jbkNveDBtOUlXdkdwZEcw?=
 =?utf-8?B?dVpWMGxrOW13djhIOFlOY1g2WkM5UUVoazhRNWFvaE9GTEdKNG9OejRxUmZl?=
 =?utf-8?B?QmJkRzI4SUpSWlp0VHhUZGRTYXFtZmg4dlFqNE5KYzRtTDY3cDNJejZabkNl?=
 =?utf-8?B?a3haZDZVR1podmUvR2c4TlIyc0FQNGJ3KzlPaU9hV0xUZEdjSytiZnpHdU5r?=
 =?utf-8?B?ZXNZZFpKK3dDSHg2cHFRbDY0eU1lYXNGdXh4Rjc0ekI1NmdNNnBqbUkydVpE?=
 =?utf-8?B?NHVLTlY0QjRkZ0NXbW1KdGQvdmRQSVpMaVdFVE14eUFTL0k0S0gzRURrbWVz?=
 =?utf-8?B?eVErSDlOeWRjZ1djQUFpcExxakFUY1BzUHZnYXFrREwxWG9Oa1ZPSHFhR2ZV?=
 =?utf-8?B?VHFiK3NxeWk3eWYxNnQ3MEN1ZjlMVC9rWFozdiswdlpvYm4zOXR4eFJidVh1?=
 =?utf-8?B?LzZXVExsZnl2WVEzWDhoU0NjM3VqSDBnbHo1VVFRTUZPQUJCbEVnWHE5a1No?=
 =?utf-8?Q?/M53RFg9XrD+Y20xI02dp1U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F28CC98DFF2BCA4D88AA0BA2889B415D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1a32054-2efa-42d2-7460-08dc5e37f381
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2024 17:09:18.0929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A9lENzML24O1W/4F6DxBquBHMHbjJzIPp4dQJWIqO8VmSLb/9HA5m6edRN0+PjBj2PxCU5PsbdZFdPCB0WP4AqaYVYZsbihTSvpJds8q/hU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6099
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTAzLTIxIGF0IDA5OjM3IC0wNzAwLCBSZWluZXR0ZSBDaGF0cmUgd3JvdGU6
DQo+IA0KPiBTdW1tYXJ5DQo+IC0tLS0tLS0NCj4gQWRkIEtWTV9DQVBfWDg2X0FQSUNfQlVTX0ZS
RVFVRU5DWSBjYXBhYmlsaXR5IHRvIGNvbmZpZ3VyZSB0aGUgQVBJQw0KPiBidXMgY2xvY2sgZnJl
cXVlbmN5IGZvciBBUElDIHRpbWVyIGVtdWxhdGlvbi4NCj4gQWxsb3cgS1ZNX0VOQUJMRV9DQVBB
QklMSVRZKEtWTV9DQVBfWDg2X0FQSUNfQlVTX0ZSRVFVRU5DWSkgdG8gc2V0IHRoZQ0KPiBmcmVx
dWVuY3kgaW4gbmFub3NlY29uZHMuIFdoZW4gdXNpbmcgdGhpcyBjYXBhYmlsaXR5LCB0aGUgdXNl
ciBzcGFjZQ0KPiBWTU0gc2hvdWxkIGNvbmZpZ3VyZSBDUFVJRCBsZWFmIDB4MTUgdG8gYWR2ZXJ0
aXNlIHRoZSBmcmVxdWVuY3kuDQoNCkxvb2tzIGdvb2QgdG8gbWUgYW5kLi4uDQpUZXN0ZWQtYnk6
IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4NCg0KVGhlIG9ubHkg
dGhpbmcgbWlzc2luZyBpcyBhY3R1YWxseSBpbnRlZ3JhdGluZyBpdCBpbnRvIFREWCBxZW11IHBh
dGNoZXMgYW5kDQp0ZXN0aW5nIHRoZSByZXN1bHRpbmcgVEQuIEkgdGhpbmsgd2UgYXJlIG1ha2lu
ZyBhIGZhaXIgYXNzdW1wdGlvbiB0aGF0IHRoZQ0KcHJvYmxlbSBzaG91bGQgYmUgcmVzb2x2ZWQg
YmFzZWQgb24gdGhlIGFuYWx5c2lzLCBidXQgd2UgaGF2ZSBub3QgYWN0dWFsbHkNCnRlc3RlZCB0
aGF0IHBhcnQuIElzIHRoYXQgcmlnaHQ/IFdoYXQgZG8geW91IHRoaW5rPw0K

