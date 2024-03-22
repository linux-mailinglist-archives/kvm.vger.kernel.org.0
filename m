Return-Path: <kvm+bounces-12472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD794886758
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 08:11:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A6221F24E5A
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 07:11:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16F2211714;
	Fri, 22 Mar 2024 07:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aGQ3VF3v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E952125AB;
	Fri, 22 Mar 2024 07:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711091457; cv=fail; b=hP2CyBuz0Zk56jyoJ9qvSQpBUw/ROKMibgweBy/Kbj9NvhQy1Mr+//wUxeSh7M/uRzxaE6+lshCxQUt+JpLydTCqzABzWtVyv9yxynd3+t6HhP9cUsyEEeHNvrfmhuOeerTC9GAB0/JCWVUoW0Z9Q1QLDCe3mBkw7a1luowAqMw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711091457; c=relaxed/simple;
	bh=+VtlsGOrHbE1TCSW+x4bqC6ggwV0L9rYo2nGoupVBJw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qePAfl4l08gHQr4ByJVdRXbE9vUqUMAVopziqN1WFsiSG0SIthuKv1aJ4XMcuzxdblktjxhYBDPH+9BdjPzHEkmCmmSWjmnB/Uecj/RanlZy+Z/PFKGZnR/B4JtOnDF3R3ddw0ptEvybUDleuT5AWx6Sl1Ux33RNNzjXC43OwYU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aGQ3VF3v; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711091456; x=1742627456;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+VtlsGOrHbE1TCSW+x4bqC6ggwV0L9rYo2nGoupVBJw=;
  b=aGQ3VF3viG8BZMHzu7tDUmnVDzDcH7JsacK3vK6sqnBuOXjXz6/C2LoQ
   4PudRmQ6gI2bu5OwBBjUlQZL3Q8qMSNpv1sc2bL4610jLxOlfo9y7DkYA
   DByhxEUoaKRXztJsRGmQ9cufqa1UBZAvAnIQphyFiW/Dg5GxXOYU8yJ7R
   +6vVbSydJqOr3LiJpaFPFPFCLYiz0FcDDn7lha0YrqUIIFwwlIm2VcNBO
   gzgpO6w7PmdyVcxdBGsR+v3y5ixcpdKCO93fVhZS9+uesaxhOyHusBDnt
   31pP/W0Gb9E0oopi/NNRJMGfA7BKhhms9vTNj35YKZPKC1skR/WlBTyfn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="6250513"
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="6250513"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 00:10:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="45791481"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Mar 2024 00:10:54 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 22 Mar 2024 00:10:54 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 22 Mar 2024 00:10:54 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 22 Mar 2024 00:10:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNiqTUtgULZHuIGZH9B6e//2AIbk83Q19GPlRYsXZ8RYff8Mk2pn2L9aFEGiJFwv+8rzfxz09kNIGA9nn/t7ok8j59E/e2BAfZYtUptwpLM5vHRDqnyTnb5g7SrsOJr8KktexUFyAqAryDT5QOv2ZKeQ+u+W+ccA5aoX7ooiC1Ydz1WHKG/MuHPbydMDDHv5x1aZ0T3NHdNNcf8iVOp2HiQUHrweB+NFw+xsgkR4unjavoiLcG+KFHTR7JH15a4XUqilWnScZZyYFUUaBsKdbBQKgCXgI+l74hG9zE8S4tjEn3MYiYcukCbX22PvzREleG1Gs/CQT6Tv9UFxCGORlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+VtlsGOrHbE1TCSW+x4bqC6ggwV0L9rYo2nGoupVBJw=;
 b=OtrNQcGDyq3kQxBmRk6wY/pU+D77hJVLhbu10sdYF0yaJ91M70Ls0AoqPApwLs9KoHqSThudSn9yaDhnTDaIKFB1hU7/VJZHImSqN643YbbEBnUzQL3nQ9mNHOyduWG/LXXecVKpPuiqn/OgTdf0iK5+TxjBD8NhtMlhpQRVRcrVNi4VH+PKZm5Cj42DvVJkRU4c4Af/RMQ1tnf56Z+WmPsxWGeCrmwpo/E6aA1FL5krDg30i4jkS+3LCV/yPm/u3O1bXSaqFrBoEH7mZHu97IKP6pFBNPFlGiIy4zpTYE1fYJfjkGstkm38zkk3LUt4uUOGEekTI7jFKOkh0lM0bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB4942.namprd11.prod.outlook.com (2603:10b6:a03:2ac::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.12; Fri, 22 Mar
 2024 07:10:43 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.010; Fri, 22 Mar 2024
 07:10:43 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v19 130/130] RFC: KVM: x86, TDX: Add check for
 KVM_SET_CPUID2
Thread-Topic: [PATCH v19 130/130] RFC: KVM: x86, TDX: Add check for
 KVM_SET_CPUID2
Thread-Index: AQHaaI3pGtqdMwRKM0+4jyn/TYFtbbFC+UEAgACFugA=
Date: Fri, 22 Mar 2024 07:10:42 +0000
Message-ID: <cfe0def93375acf0459f891cc77cb68d779bd08c.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <d394938197044b40bbe6d9ce2402f72a66a99e80.1708933498.git.isaku.yamahata@intel.com>
	 <e1eb51e258138cd145ec9a461677304cb404cc43.camel@intel.com>
In-Reply-To: <e1eb51e258138cd145ec9a461677304cb404cc43.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB4942:EE_
x-ms-office365-filtering-correlation-id: 760e092f-73db-47da-1831-08dc4a3f300b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ii1S4x0c8yjsuxBEQFcRi809KroFsk0baX9C5LH3/wFemL0I1D/IU59HgM2MsKkLFV7BG3U4lWdQd5iMHI40XLk7XGFMN/pk2yOS7NhwTyUoT/MzKlkEOM3O7pIegV2hiU1jjHPxrmjk89aiBSsy/3u0iN/rowQMLoQfQzPm+3dmzDQ8LdQ2N9Fv7NCCsY76fdyASJWROoKXwj7YyedDVk95NLAPcj04f7fFWFAmqv/QvQwQbxkVwjcXsFtd1VjyxOdGc+S9ejYnfpPQmn/1QLbIIsZGlF508qhrYkreia35hn43iQAM5atdDzGP883aoYBwn73aZt8wZUm/i8PWwr2uRzZ7w7P1ebuGh7jgc8+O4LpOHrjocJbrg7cbOae9qTsEwJSMoYVdvULQf+oy1xdy+dkyHFBF3U9dNNShRwv0yR+Kprt2kOEzwHk9sjWh0ztqxDnxxg100NZdVoSjtKP/baYmKIcGgO95SPglqALZavipzIH7UOF4v/Ps7zZwflnzHIwr9MERUnJefy/uyZD5AwMQ2iIc8sNu0I5EUEcm+xPlMO5QHYni+HIj2h/6rIArEwrTv23Gvw1H65pi+dVPMLVupi9I4oclp7KFZjYrneHkgBhAKHFFAytXHy+p5RNUSV5r8zrosMT4UtJ85g+2zAuzHJllzgM8SI+8WVk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bGZTUElFcWVJU1RDUWJZSGcvUnpqOGxGMnR4b0dIdEg5eklLVzdNaEVLVXFT?=
 =?utf-8?B?ZERnVWdmd0s0bXRSeTdmdGRnbTJUQk9STVJsUHU1QmRQWVR1SXpTcW5GdEN4?=
 =?utf-8?B?ZlcxUU5vODZybks2V2NiUjBVSHdTS3lnbHh5OFc0aUVQWExFdFZ3QWRxaW1O?=
 =?utf-8?B?L0RFOVVMbEJUUmdDOUU5alk0WUZyUllYRUFwQjFaeHhyQ2FSd1dCZ0Y4YllS?=
 =?utf-8?B?dWgya3BWMjJiQ2Qzd2haZ2JMbzdlc2hkSVNyRFN3QTVBZEhmMUVZY1lCSWRz?=
 =?utf-8?B?b2o5ZGJ4czJ1SS9mcnJQejl3LzBBSkUrbktpOXZVZjJzdURLUlpPNGE5VUFR?=
 =?utf-8?B?RkRRQW9WYzdQVzJEdXlUOVIwRDNPV2orcVJuZE9rcVhDS0wwb2JjMGlvbDRC?=
 =?utf-8?B?MU9IeVBFRDU4OWlTTlg3MDc3MlJ0ZlBJNVBhdmRNWTFOZjIyNnRQdGdwWm96?=
 =?utf-8?B?MnlyUElIb3o1TzVVR3NTa3pBQnFZS2xUeGx3YXhFb2NrWmd1MlVnNGhxSU9I?=
 =?utf-8?B?UllJclQxNDZDeHQ0bTZ2aUVmbnlCUW9lcUNaM2lpYjJFYzRxWXN1NDZuUXAx?=
 =?utf-8?B?TGNVYi9yK1BGamRsOFhSMFU5RVZZakw0WHk3OGE3UU56Wm1qQnUrMmw1czRQ?=
 =?utf-8?B?Yk9uUTR2UjFUU1p4MDdKaXQwQUI4emt4RDhFdjdYMXZIQ1BBRDhEbmx2QjQ5?=
 =?utf-8?B?SHQrYXE0azl5dlR2SmtNdjZvak0ybFpvVjRFNkdpMWZ5eC9tcitoM29kY01N?=
 =?utf-8?B?WjlOMTRadk5MaFRXRUwrWmpQYTNsTngxbGlCejRLSmhQYytURmEzVzUwMmRy?=
 =?utf-8?B?eXg4U3ZwanBBVzNmNzdOSlZqNnUzaWk2QXhMN1VhNVc0SkVaeENrRzYya0I1?=
 =?utf-8?B?VStKWmdXRktSYkVDYVRlcWpQUzZ1d3A1SGpRNm1Zd3cwdUx4Qk1rVk8ycWFC?=
 =?utf-8?B?eEdTQS9waXNycGNJUXVUT1hEdzYybThnV3VRR0V0UVZ5blMvR3Q5clE1a3Fq?=
 =?utf-8?B?WnZqQjV1YmhPQkI3N0pNM0JpNUtCS1dkSEFPWTd5Z0IzMzVLb1h5ZVdPUWFU?=
 =?utf-8?B?Z01pbmpXclpTTEpDdStHbFd3Y2dSYzdCQndUbTU3TVgzRkZNRTIrU0VFZFJm?=
 =?utf-8?B?MWxJRWcxeU05VDZHT0M0TlBhOXhNNlFUUDZrSDZaaTlISWRIRnRyWmQwdkhM?=
 =?utf-8?B?Uk1KOHlMdzlJSXFEODIrcFd0WFBoYWozZWhsUFN6K01aUEFUaVhFWFVHd1Ro?=
 =?utf-8?B?aFNKR0pMS1VxdEltTFNiM0N0dFcwQzhpeEhzbHRSYUxFaDlQK0VENDlEYU04?=
 =?utf-8?B?UWtnOEV6bnJZZStKVytnN3dDYVNzdmRsSVphTVZqOG5ocXUwVnZVSGxDUk5C?=
 =?utf-8?B?eE5uSUxsays3ZkNueFc0ZWxkK285S3gxc0V1VmVJRFJzeWpKZFl3d2FzQU9o?=
 =?utf-8?B?dkV0T0VXVWE4S2l6NlNqcUE5L1dYeUM4RkQvdEgvNDdCZ0E1b1NucDUwTWlZ?=
 =?utf-8?B?V3hEb3NEM0NSeFdxQkloaDZ3T0RLbUpNVWY3bkFmeWFuNUdwcVFuVGF5ZXdB?=
 =?utf-8?B?Mjg3VHplWFprUmtWR1paMmpBczJ3YWNTUWthU0FpWSswRllXWGhkSnpmOUlC?=
 =?utf-8?B?RUdjSjlsQTFjYUlHV3BCb2RTL2Z6cCtyeWNwS2dCUkk3T3NVRnRWbWNOcFU5?=
 =?utf-8?B?MDA1UDlHVUluQUtybUx0RTBhbngvUENuTm5ZbUo0NThlWEVlM1p1c2xKQzhm?=
 =?utf-8?B?Rm9FM2dQbEIvK01NQWFSdEhERXQyRXdUN0JpVWZDWXh4eWZUVTA5VlFUWW10?=
 =?utf-8?B?WkwzeElGN0dUekszQVYzbjRmMWJ1V25YQXBKK1h3RWdOYzNUdHdzZ0dSMnJF?=
 =?utf-8?B?Z2NyVVB5eEU2WnVrQXVIRDd4c0Z4Z0Y4QWlhT0w1OThrWERHVWpRcEM2NXRl?=
 =?utf-8?B?c2VBT2s3blNKZ1VQa3QwUGlvTGp6ekhxaUlGaGtHdVp6UWNCRWJ4bXVyNnVD?=
 =?utf-8?B?enEwYnU0dTdBQWV1Yk5XWVpXZjBmTVRxL0tFcTduZUg4VllrQ0FVdk0zYWRE?=
 =?utf-8?B?eFhTNkJaU1d5QTh5Z1AvcjBmRldialUrY2g5MG5BblltN0N6TTA0Q1A4cDBu?=
 =?utf-8?B?eXRaTmRlUlRZSTFtdWNQT3VqS0VBQXJyY1ljNStyWVVLQ0UrOFoxb0pvR3FF?=
 =?utf-8?B?dXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EE72B15C4985B347BA0FD19108F4B2C6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 760e092f-73db-47da-1831-08dc4a3f300b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2024 07:10:42.9024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VgH3xWf+fQ2ZhVjZtO38T3NnuAbGcqUG0N9LbpxylgOr7VaW61qc9dU+MwYBbjjLS0iNl/uC9nl31dRmZX+UkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4942
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTAzLTIxIGF0IDIzOjEyICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gTW9uLCAyMDI0LTAyLTI2IGF0IDAwOjI3IC0wODAwLCBpc2FrdS55YW1haGF0YUBp
bnRlbC5jb20gd3JvdGU6DQo+ID4gSW1wbGVtZW50IGEgaG9vayBvZiBLVk1fU0VUX0NQVUlEMiBm
b3IgYWRkaXRpb25hbCBjb25zaXN0ZW5jeSBjaGVjay4NCj4gPiANCj4gPiBJbnRlbCBURFggb3Ig
QU1EIFNFViBoYXMgYSByZXN0cmljdGlvbiBvbiB0aGUgdmFsdWUgb2YgY3B1aWQuwqAgRm9yDQo+
ID4gZXhhbXBsZSwNCj4gPiBzb21lIHZhbHVlcyBtdXN0IGJlIHRoZSBzYW1lIGJldHdlZW4gYWxs
IHZjcHVzLsKgIENoZWNrIGlmIHRoZSBuZXcNCj4gPiB2YWx1ZXMNCj4gPiBhcmUgY29uc2lzdGVu
dCB3aXRoIHRoZSBvbGQgdmFsdWVzLsKgIFRoZSBjaGVjayBpcyBsaWdodCBiZWNhdXNlIHRoZQ0K
PiA+IGNwdWlkDQo+ID4gY29uc2lzdGVuY3kgaXMgdmVyeSBtb2RlbCBzcGVjaWZpYyBhbmQgY29t
cGxpY2F0ZWQuwqAgVGhlIHVzZXIgc3BhY2UNCj4gPiBWTU0NCj4gPiBzaG91bGQgc2V0IGNwdWlk
IGFuZCBNU1JzIGNvbnNpc3RlbnRseS4NCj4gDQo+IEkgc2VlIHRoYXQgdGhpcyB3YXMgc3VnZ2Vz
dGVkIGJ5IFNlYW4sIGJ1dCBjYW4geW91IGV4cGxhaW4gdGhlIHByb2JsZW0NCj4gdGhhdCB0aGlz
IGlzIHdvcmtpbmcgYXJvdW5kPyBGcm9tIHRoZSBsaW5rZWQgdGhyZWFkLCBpdCBzZWVtcyBsaWtl
IHRoZQ0KPiBwcm9ibGVtIGlzIHdoYXQgdG8gZG8gd2hlbiB1c2Vyc3BhY2UgYWxzbyBjYWxscyBT
RVRfQ1BVSUQgYWZ0ZXIgYWxyZWFkeQ0KPiBjb25maWd1cmluZyBDUFVJRCB0byB0aGUgVERYIG1v
ZHVsZSBpbiB0aGUgc3BlY2lhbCB3YXkuIFRoZSBjaG9pY2VzDQo+IGRpc2N1c3NlZCBpbmNsdWRl
ZDoNCj4gMS4gUmVqZWN0IHRoZSBjYWxsDQo+IDIuIENoZWNrIHRoZSBjb25zaXN0ZW5jeSBiZXR3
ZWVuIHRoZSBmaXJzdCBDUFVJRCBjb25maWd1cmF0aW9uIGFuZCB0aGUNCj4gc2Vjb25kIG9uZS4N
Cj4gDQo+IDEgaXMgYSBsb3Qgc2ltcGxlciwgYnV0IHRoZSByZWFzb25pbmcgZm9yIDIgaXMgYmVj
YXVzZSAic29tZSBLVk0gY29kZQ0KPiBwYXRocyByZWx5IG9uIGd1ZXN0IENQVUlEIGNvbmZpZ3Vy
YXRpb24iIGl0IHNlZW1zLiBJcyB0aGlzIGENCj4gaHlwb3RoZXRpY2FsIG9yIHJlYWwgaXNzdWU/
IFdoaWNoIGNvZGUgcGF0aHMgYXJlIHByb2JsZW1hdGljIGZvcg0KPiBURFgvU05QPw0KDQpUaGVy
ZSBtaWdodCBiZSB1c2UgY2FzZSB0aGF0IFREWCBndWVzdCB3YW50cyB0byB1c2Ugc29tZSBDUFVJ
RCB3aGljaA0KaXNuJ3QgaGFuZGxlZCBieSB0aGUgVERYIG1vZHVsZSBidXQgcHVyZWx5IGJ5IEtW
TS4gIFRoZXNlIChQVikgQ1BVSURzIG5lZWQgdG8gYmUNCnByb3ZpZGVkIHZpYSBLVk1fU0VUX0NQ
VUlEMi4NCg0KDQpCdHcsIElzYWt1LCBJIGRvbid0IHVuZGVyc3RhbmQgd2h5IHlvdSB0YWcgdGhl
IGxhc3QgdHdvIHBhdGNoZXMgYXMgUkZDIGFuZCBwdXQNCnRoZW0gYXQgbGFzdC4gIEkgdGhpbmsg
SSd2ZSBleHByZXNzZWQgdGhpcyBiZWZvcmUuICBQZXIgdGhlIGRpc2N1c3Npb24gd2l0aA0KU2Vh
biwgbXkgdW5kZXJzdGFuZGluZyBpcyB0aGlzIGlzbid0IHNvbWV0aGluZyBvcHRpb25hbCBidXQg
dGhlIHJpZ2h0IHRoaW5nIHdlDQpzaG91bGQgZG8/DQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3Jn
L2xrbWwvWkRpR3BDa1hPY0NtMDc0T0Bnb29nbGUuY29tLw0K

