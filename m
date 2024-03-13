Return-Path: <kvm+bounces-11766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C918E87B2B6
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 21:17:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7539C288D7A
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 20:17:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B94904F1FE;
	Wed, 13 Mar 2024 20:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lazOI9yN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D4B4D595;
	Wed, 13 Mar 2024 20:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710361050; cv=fail; b=LJQokPx0aMLPgVYenR1vFaOt1M/48LEu/ItJwDRAgbsAH4t7q8HYOMrBv6HNWiObrGDyPyOGMbmsM+4oHfLYsHgbe1RHzUGfKMMxFOlnjYUmvQMa1kjEAJPqj26St46i2sBEw0jIPS0RcYup7+g03Ga1+q0Il8iYZ5CprE/S+Ss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710361050; c=relaxed/simple;
	bh=UCaEUZwcWAMTN1vldAm+KhbHdr2znbGgxdyx43HmtbY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T2uIyu7tpBbuX9BC21gRZ7OYWWLnIESryiiQzzdlGYjN0MsMnlO3uvOw2iEIy+noDjeADKiIIjFezyOoQ2L6KbpcrtmdRZjNuJ2qBRSJzmQeYYNduVjZURY4G29Fsjo9i02wZbwRAmVpFFAe4EBDqN3aUH5LkairnIAftstHIPw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lazOI9yN; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710361048; x=1741897048;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UCaEUZwcWAMTN1vldAm+KhbHdr2znbGgxdyx43HmtbY=;
  b=lazOI9yNd7WFclilb4PYZatDBpg97xK9N8JSIHZIdM+RICgNj2nxJKcc
   thG1/6xZE+oSK2JTZPlxsUkUpdkkgOwsw0IH/UTFKisPEw40JSJH6HgUS
   RjN06DgeKB5tgyPzJ3SOemuKCJLKLfe/QsDgfQzwqOxQvBuUGy13WpPrc
   tUDR8FJO9kp6YRfp0JqhmhkPHjpUv3klf8t9Z7GIeo0a50fMzIM6yLAuF
   2DdfSKlfrqW3ThLZKFBZMLlD0d7Lc6XzWKsYJYqRTLaGlMrHq+0ME/OUy
   ef9tTJ0iy3BGBc8491n7VQIklukEyq4Affx7IC8mU1rZ5rckLMAyB75Sj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11012"; a="16549811"
X-IronPort-AV: E=Sophos;i="6.07,123,1708416000"; 
   d="scan'208";a="16549811"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 13:17:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,123,1708416000"; 
   d="scan'208";a="16644715"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Mar 2024 13:17:27 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 13 Mar 2024 13:17:26 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 13 Mar 2024 13:17:26 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 13 Mar 2024 13:17:26 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 13 Mar 2024 13:17:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q2QaxZSOhies4MGzAg857iiPysDXN4fRYOfInnLhF2gR25Be8/IsFrMx9D3nSfXAU6OSIc98NnkRH+vxcUPDkLLSP4SAtshA2+fITlQ4kBWJg8tzfeVSmC2jJjulYogt/gqeGgOadNKWb5wnzkg+BmOp/hC89+fqnCjmY+oH03gFk43ZxwaZ4/wUWAJcqXIw4yK0tMg5ZZfntAvuNzTcxghWv9ek3UDaDH+7L6K6eBqWLmo26AAGQydwGDFzlbSnBWVgSjl6gInGu2dIJTP385mwJuPXnp8ag+ujSfucRByvDtu63lpcxLCN0l4XulCckIua45WPlIZ+g1ChsZBo4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UCaEUZwcWAMTN1vldAm+KhbHdr2znbGgxdyx43HmtbY=;
 b=mDUhmOy/ed96MUf2fgq5N0W1TRTzuLbmWqtrXl9wzUM4/9QD6CcgG+xzgpnkXDAnAUDS9OWCmpmQARfnNUkw4lJw3Zfc93C8Cko7woS6frq1skXh6weRmAKlNCw6Gs29+WntjzN1zglr1MOLIYK95wo7arJsX6E/tUSIQVO3TInvu1pRcrZvckdCiqCfqvpAQL5PM62XT27tdrwdMGAWGjgtB1dUgrK9fNTx3GDEeRGceo0Ib7xYgv5XzKvwjsTU1ZQ8RsEJl/5irOVrTQc8UtFJQCv6tlQeWDtdmWPAJbeW2ODrO9m2b3AdNpv6GMtfkJRMySEaJ60lqRBSe/0L9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY5PR11MB6438.namprd11.prod.outlook.com (2603:10b6:930:35::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Wed, 13 Mar
 2024 20:17:18 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::fc9e:b72f:eeb5:6c7b]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::fc9e:b72f:eeb5:6c7b%5]) with mapi id 15.20.7386.016; Wed, 13 Mar 2024
 20:17:17 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "hao.p.peng@linux.intel.com"
	<hao.p.peng@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: x86: Don't overflow lpage_info when
 checking attributes
Thread-Topic: [PATCH] KVM: x86/mmu: x86: Don't overflow lpage_info when
 checking attributes
Thread-Index: AQHadKN4OH6SmKEpJ02B1g4zIHBBnrE2F2IAgAAGOoA=
Date: Wed, 13 Mar 2024 20:17:17 +0000
Message-ID: <a5fd2f03c453962bd54db81ae18d3c2b8b7cf7b1.camel@intel.com>
References: <20240312173334.2484335-1-rick.p.edgecombe@intel.com>
	 <ZfIElEiqYxfq2Gz4@google.com>
In-Reply-To: <ZfIElEiqYxfq2Gz4@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY5PR11MB6438:EE_
x-ms-office365-filtering-correlation-id: 5ef94f36-96cb-4cb5-24ba-08dc439a94bd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yA5FZOHxGoI2jOQMc124miD7DaxkcHRHUSkp6TfWq8o+onnkotOQ3fPTGsJF0ex/8h0d0ohlObh9QBE/B1aH+8aFqG8CtsUiYJ+zS1uRjhqZsUTwc9odT4PzVSAqQElmR6UoN69EtzxYGsR15S6rXt0TPGs7pgmAnxNsH1fnstGwEsRnwfGGrd2KxbgeNeJqcCWz39kbv4KbjSkvJR96ar73RQ+k3a0N+siSQPk7BsU9gzsjK3v9aDkVWG8U7VmeKE8JFraQPwMbwQ2faW8+BvoJrjAHFyDFZFmDeR43Kk2uRy0I1UmorPX4bVavmmebJb6OHZpU1DaLDp0oHvL/5K+u63qrgB6JOWjz4RvOyHulV/OLb2JG6j661O+7wfz3x4hQoZdy1QhaGYUFMtL8/pIuR/w78SvE9QqsqwiPiCfdx/59siKacp9Gzdx4/MUxIMcf8i+HsMF3eZbu+TtTlFLEqNvt/rl4M17FdKNUgMSZq8EYf7bkduEXAen34WHa4NRCX1fpourkKmqhihbaC/Tf8XlX1tW0iPyqZewN+Xg6sO8tObEhhx/4eTUGha1O2GcRkxmF8QrzBSOc5U0oGsyefWsfMfQaQZAF0QBdPGQDxucB3Dyvpqa907pAuw8BMjmOQ3zIJG2zQoOm7zGWV6OXpGCCPcLeyITAu4k/HFMmNzwZzijCuLDeeLOjk22rMKaR+9ykmbsq1QCznIfORhKYmmNTe56bz0OsOhGDM8Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cWViVDlDMnNYT0QzRkZvZXRmM3d3RHRQRFVlRXRwcW10QWFYZVo3Y3lOSmRw?=
 =?utf-8?B?OE4rUVVGWkJkVlJXSnprTmhZc1FjcnJDVXY5cWw0QnNlNGpLcHBNRUQvMnZC?=
 =?utf-8?B?R3MybldIVWFHNnRLWUdrLzJxMHBvYnZHSjJDMHZPNGlkTmN6MUpQSmNhb00x?=
 =?utf-8?B?ODBIN3owL2hVc1pvQWppclExQWZZNkpsdThxVTgwQmR3RjhkbnljTW4xSnVP?=
 =?utf-8?B?L3BlVUxGWkNDWVJ0WjA1a0hqMU4wcldaditjTHZRQ0s3MnRWRFpSMzA1cHI3?=
 =?utf-8?B?TFc5bDFhVG5Yc2lMMWp6SHNlczVPU1o1bHF3Tks2UENoWHA0MXJOV0FQaHZN?=
 =?utf-8?B?M2tDS2tob1dXT2haZElERTdVMS9hbHAxZ3lDN0dJajdwZ3pLcmYxSmowTUp3?=
 =?utf-8?B?Tm1TTGlpa3E0MEFuNG9TOXNSUkQ1VHhCK1l0Z1BGOWozcFErMzA3OFEySUtS?=
 =?utf-8?B?QmRwWUs3a1VTTU9SZTlIcHZhM2pTbXo4cTZrampaZVpoeW9ZcmQvSmVkQ2la?=
 =?utf-8?B?SGJ5UkNQeGJqZUNRdnZmR1YxNzZhdUwwOGhwcldrbjhaUGNoRFNEQVlsZFRI?=
 =?utf-8?B?ZVJzM2JxSERtcHp0Umkwd0I4dnRwTlZtcnlJMzRPaitGZ1R1Rjl5SlRDYktW?=
 =?utf-8?B?bllRRnJjb2JSNUw1ZHVBQ0Z2bFRPc3RzNXBPT3B6VlRWMmdVK203eXl4b2c2?=
 =?utf-8?B?SnNEUzNIZnRuYWZJdXFDbzl4NUhXb3I5OUdPMStUZHJBR1hZaUwyelg2Q2tX?=
 =?utf-8?B?SS9pRmNLZUJ6UEczamlNZ0JiL2daVUdnT3gvbWhOb1dPZTZDdHF2QnNaemVF?=
 =?utf-8?B?S09aTllDRFhiS3VqcFoybDJJN1Y3ME5DT254RkpiS1hkdjFPU3cxWFlMNTAy?=
 =?utf-8?B?cGEwRytMSjlHTGtKcGRDYTNpYjFXNk82K2RIVzYyN2ZsdFdRWklFNCtRSTgv?=
 =?utf-8?B?Wk1abHc5QVdVblR0NDNPN1d3M21rcjFNTEpNclZWSXIrdUI0WWhnbXROWFRn?=
 =?utf-8?B?bWdYZytJUmhjQmQzd0VaOTRYbkFhTndjWmhHc2Y1YWFxSE5LUUloaElYcHFa?=
 =?utf-8?B?bzFrbFdwckVoaEVkaFZCWGxDNklpNGRqT01TS1lLeFJMNU5BVmRPRkNYaVNS?=
 =?utf-8?B?Q0tYV0p3VzNLYkp5WERyRXhYdGZEZ2loS2UwVXQ5RmgxamJoM0NYU1hYaThm?=
 =?utf-8?B?VVpZL1dCR0syaDRHYUpFSytUQVQ2RitIVEoreUhNVXJLTHFQdnliZVVZajUw?=
 =?utf-8?B?MVhONXV1L2YrSldLYlVMOW8wNi9tZUc4YUl6SlU0dk9pV05udm9xdkZsVlln?=
 =?utf-8?B?S2l2WlRoZlZ6WUlQakk4dExMV0FOTjJMNG5hZmNiQnIyR01LQ1NWU3h4T20w?=
 =?utf-8?B?UTFjWmZJYWVQSUNSazk3c2gzdU1PNENwY0pXZzlqblpuTWFXTGhodnY1UjZo?=
 =?utf-8?B?ODNGbVk2NFF4WHR2THFjc3AyenJITjE0UU9Da0dKb3F6aFlWTyt0NUVUaTJE?=
 =?utf-8?B?cytiRU5FWGdSOHFPVEgrTWRQdzZRNW5tM042cUFWYzMrTys0WHU1SXB2Q0tL?=
 =?utf-8?B?UjBaWnRQWThxN25uaFdIVlhsdE1sVFFFQ1NVYkZkYXpsNkV1SGhyZStFQldJ?=
 =?utf-8?B?MGYyNnBERnF5b2k5OGFSUGJXU3J4MTA1NVE2NmtPYVVYUm41YWFvSkhpTGtr?=
 =?utf-8?B?Uk1hNFFNb1QvSjM3UHpuM0lBeVpqRm1RNzExV1NaZktPNzV0RGJrVHdwWHI0?=
 =?utf-8?B?dThjOFUrZVAzRXBXTjlXKzduSzZJT04wU29LdmU2cXlrUGE4VmNJVnZ3dmEy?=
 =?utf-8?B?aVd6dzBEOUNGUEIrMGtzM2ZLZnZRRW9NdVVKbnBUT0lrRHROUnQvSjlkdE1i?=
 =?utf-8?B?QjkrOWZGaFZhUkt3Tm0wTjM1V1dyaVBJNlp0VHhJTko4Z0QvWDF0cENseTNU?=
 =?utf-8?B?em43eU16K2JMR1dkRjRaMkt1M2NEeFp5YUdxSkFHZlMxTzczeUdKYXVqdXJs?=
 =?utf-8?B?UVV0ZUFzbHdobkRyUUR2bnEvc29WbW1ZZWE2UjBmMndXKzFVYXFxZ2RZNW9K?=
 =?utf-8?B?bElSZTVXRm5MbXJTUmtvUUhDZTlPMitDZ3A3NUlKRm5Mb0Y5N3BTbVlYSnpx?=
 =?utf-8?B?ZHh0VUJPSW5JYjBLWkdPcW5oQlhnQmdmWkV2R0krM0dTYnpuY1NoMmxmeEp0?=
 =?utf-8?Q?ADiwOrTExdMOtzJFmo3cF9g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <33032C06D2E8A84C9E7DD56EB8D9B04F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ef94f36-96cb-4cb5-24ba-08dc439a94bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2024 20:17:17.8771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VMP64HvF16AVsSZAe6jizGQV3Z6oXSsNsZnGqu09+bCS8GlZllDmI6rfLQSfSKQGcqwwcFjIPibKJeq5vzVwTFbaEl7bdJItNNlmpZEuuLA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6438
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTAzLTEzIGF0IDEyOjU1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBOaXQsIGl0J3MgdGhlIGhlYWQgcGFnZSwgbm90IHRoZSB0YWlsIHBhZ2UuwqAgU3Ry
aWN0bHkgc3BlYWtpbmcsIGl0J3MNCj4gcHJvYmFibHkgYm90aA0KPiAob3IgbmVpdGhlciwgaWYg
eW91J3JlIGEgaGFsZiBnbGFzcyBlbXB0eSBwZXJzb24pLCBidXQgdGhlIGJ1Z2d5IGNvZGUNCj4g
dGhhdCBpcw0KPiBwcm9jZXNzaW5nIHJlZ2lvbnMgaXMgc3BlY2lmaWNhbGx5IGRlYWxpbmcgd2l0
aCB3aGF0IGl0IGNhbGxzIHRoZQ0KPiBoZWFkIHBhZ2UuDQoNClllcywgdGhlIGJ1Z2d5IGxvZ2lj
IGhhcHBlbnMgb25seSB3aGVuIGl0IGlzIGEgaGVhZCBhbmQgYSB0YWlsIHBhZ2UuDQpFdmVuIHRo
b3VnaCB0aGUgZW5kIHBhcnQgaXMgdGhlIG92ZXJmbG93LiBJJ2xsIHVwZGF0ZSB0aGUgdmVyYmlh
Z2UuDQoNCg0KW3NuaXBdDQo+ID4gQWxzbyByZW5hbWUgaHVnZXBhZ2VfaGFzX2F0dHJzKCkgdG8g
X19zbG90X2h1Z2VwYWdlX2hhc19hdHRycygpDQo+ID4gYmVjYXVzZSBpdA0KPiA+IGlzIGEgZGVs
aWNhdGUgZnVuY3Rpb24gdGhhdCBzaG91bGQgbm90IGJlIHdpZGVseSB1c2VkLCBhbmQgb25seSBp
cw0KPiA+IHZhbGlkDQo+ID4gZm9yIHJhbmdlcyBjb3ZlcmVkIGJ5IHRoZSBwYXNzZWQgc2xvdC4N
Cj4gDQo+IEVoLCBJIHZvdGUgdG8gZHJvcCB0aGUgcmVuYW1lLsKgIEl0J3MgKGEpIGEgbG9jYWwg
c3RhdGljLCAoYikgZ3VhcmRlZA0KPiBieQ0KPiBDT05GSUdfS1ZNX0dFTkVSSUNfTUVNT1JZX0FU
VFJJQlVURVM9eSwgKGMpIHByZXR0eSBvYnZpb3VzIGZyb20gdGhlDQo+IEBzbG90DQo+IHBhcmFt
IHRoYXQgaXQgd29ya3Mgb24gYSBzaW5nbGUgc2xvdCwgKGQpIHRoZSBkb3VibGUgdW5kZXJzY29y
ZXMNCj4gc3VnZ2VzdHMNCj4gdGhlcmUgaXMgYW4gb3V0ZXIgd3JhcHBlciB3aXRoIHRoZSBzYW1l
IG5hbWUsIHdoaWNoIHRoZXJlIGlzIG5vdCwgYW5kDQo+IChlKSB0aGUNCj4gcmVuYW1lIGFkZHMg
bm9pc2UgdG8gYSBkaWZmIHRoYXQncyBkZXN0aW5lZCBmb3Igc3RhYmxlQC4NCg0KT2ssIEknbGwg
ZHJvcCB0aGF0IHBhcnQuDQoNCkFzIGZvciBub24tc3RhYmxlIGJvdW5kIGNsZWFudXAgSSB3YXMg
YWxzbyBub3RpY2luZzoNCjEuIGxwYWdlX2luZm8gaW5kaWNlcyBzaG91bGQgYmUga3ZtYWxsb2Nz
KCkgYXMgbXVsdGlwbGUgcGFnZSBhbGlnbmVkDQp2bWFsbG9jcyBhcmUgd2FzdGVmdWwgZm9yIHNt
YWxsIG1lbXNsb3RzLCBhbmQgZXZlbiBub3JtYWwgc2l6ZWQgb25lcyBhdA0KdGhlIDFHQiBsZXZl
bC4NCjIuIGxwYWdlX2luZm8gZG9lc24ndCBuZWVkIHRvIGtlZXAgdHJhY2sgb2YgdW5hbGlnbmVk
IGhlYWRzIGFuZCB0YWlscw0KYmVjYXVzZSB0aGUgdW5hbGlnbmVkIHBhcnQgY2FuIG5ldmVyIGJl
IGh1Z2UuIGxwYWdlX2luZm9fc2xvdCgpIGNhbg0Kc2tpcCBjaGVja2luZyB0aGUgYXJyYXkgYmFz
ZWQgb24gdGhlIHNsb3QsIEdGTiBhbmQgcGFnZSBzaXplIHdoaWNoIGl0DQphbHJlYWR5IGhhcy4g
QWxsb2NhdGluZyBrdm1fbHBhZ2VfaW5mbydzIGZvciB0aG9zZSBhbmQgdGhlbiBjYXJlZnVsbHkN
Cm1ha2luZyBzdXJlIHRoZXkgYXJlIGFsd2F5cyBkaXNhYmxlZCBhZGRzIGNvbXBsZXhpdHkgKGVz
cGVjaWFsbHkgd2l0aA0KS1ZNX0xQQUdFX01JWEVEX0ZMQUcgaW4gdGhlIG1peCkgYW5kIHVzZXMg
ZXh0cmEgbWVtb3J5LiBXaGV0aGVyIGl0J3MgYQ0KdGlueSBiaXQgZmFzdGVyIHRoYXQgYSBjb25k
aXRpb25hbCBpbiBhIGhlbHBlciwgSSBkb24ndCBrbm93Lg0K

