Return-Path: <kvm+bounces-15733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92B128AFC99
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 01:29:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CA9D6B22A21
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 23:29:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 281A03FB94;
	Tue, 23 Apr 2024 23:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="efM8NKe7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1465718B04;
	Tue, 23 Apr 2024 23:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713914987; cv=fail; b=lSvtG6UZVQt5nAAVfD9tU5AYx8rMn7E1bIX+zcsYP9dXVA+y9S/52DMtWaSP5h506jGhcZYdrGHccHMDlpt8Z/A5wDuG/eHSOB3Y0DAj5tQnyrXzyZjLH75206vWch+MVlxCQ5P8HLdwhKgKfTgLpPu2T+Vks9KKsRD+ir89060=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713914987; c=relaxed/simple;
	bh=CrnRBpD85kzgTLjhc8xboTCy+1WtG9KUbc5vhVIFriI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SgOfQAs9EX1MciOaG0ER5jCijUAYJDOgwtPJ5um3h4MM80VoCPLq8apVcEvgXKxS+oN4tXTPo3CBtf/CSfuI/HIfq60ueqiPm7NobI+GPRSulDxs91YXIUoHaiLve5oryp6TjHhytvBTIpJjZnOX0acTmRsX1m4eK9qu1KOhNeU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=efM8NKe7; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713914985; x=1745450985;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CrnRBpD85kzgTLjhc8xboTCy+1WtG9KUbc5vhVIFriI=;
  b=efM8NKe7iVC8dEvt3VeXOz6zFaDA8WJJU5vJuxKD5+L0KlqhZywaMjSt
   ew5ztUBMuPjH06FmSWdyEY8ItmwPjQDml2TNu7yJcGSQwbYv6c3EABhz8
   JsyPDpqc9GMscEmFK4T6rm1EEP3qGDTrSSLj1/zeBmxUGbWHPNCOx4ym2
   DJoKesdMiNhATF2griTusiEyHJFT2p/KUgZd+LHbeWbyyFExFg9Fr2tlO
   EZRX8IYcARTrhmgkoFHULSdB4+Xctf9LyzsIeRFAktKRhQLW7ofSvfel0
   +/upiKu1mYsKhy3RD75mmejcAVE0Tq15ymasYPp7tILNS3JAzvnI9tPfy
   g==;
X-CSE-ConnectionGUID: vWJwSe90TZiSwtIHUN9WlQ==
X-CSE-MsgGUID: KzHm1h1/T4y3Hh2giPJnAA==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="9743474"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="9743474"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 16:29:44 -0700
X-CSE-ConnectionGUID: iWSy69QTRoSh10A1Ghd7+A==
X-CSE-MsgGUID: GWLfqp3BSJm9d7AyVd7lPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="29317404"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Apr 2024 16:29:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Apr 2024 16:29:43 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 23 Apr 2024 16:29:43 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 23 Apr 2024 16:29:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ngWtRzFTbUjnJql91ncmS9slr1r0gKmuyIH0wnVu5wOiZwvJ+iMhu9xe9gJO/Q2FWSZtOKQCGoHCM9g3Bs4BIeq9y9UIVEiYf7N41xrWpQM4qhTJKLryhEXtOdVJ2MaPDo+aG3UCx8aUa3hds1P+QtoR7d6ZUAlHZ4h7IGSWo6y6efop6ZlNlai9EhS6bYm8slxBF95cKNnaGjO4pVexASGPgmAVBlp+Yo0RQjtwuexa8FpqIHmCeLR5/j5AWHXY3ajrV0F+vrr6t+VcyPmOFb9D4ZtLG90DbVCtmgGvOJKRLdq3d6Y+7SaDPAbDpFz71AdRy6OGDvbmeCCXvG7KOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CrnRBpD85kzgTLjhc8xboTCy+1WtG9KUbc5vhVIFriI=;
 b=FfHsNBLyCTGNwANYnDROVX2GLxG8hEdk0cM3dJ0fnPzAAFsY7f9/dsUrNjd+78ypUiopxyjBBb8eimgSsaakW90PgzNQlSfGI7tfZrxb53Y+vb0/4+eZUm6T0T85mtOcDAuSM6BDF6rdd3oPXKqAb0SzwzEnwZQFdMfoG/a5EkrUePI/5v7VMAtVgVJXWvVGZ8txDcqcp3d94Hvl3ouBkBJb5sWzshkOqa4GpQvVwBJZrfEujEVVKQSpB0xbtqlkexgAGMA0T5FZI/OM3ywovjVzAjj5XPTFr/pZHobnri7JG8npJhz5/zdUtBlwElGOvt4o71kJBz29X+qWyiZGjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by LV3PR11MB8768.namprd11.prod.outlook.com (2603:10b6:408:211::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.26; Tue, 23 Apr
 2024 23:29:38 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7519.021; Tue, 23 Apr 2024
 23:29:37 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHaaI2222Sa8TxUXk24fGddYGoigLFCUFIAgAIc5oCAHVMCAIAAJnsAgACCNICAAPghAIAAlYYAgAe6DYCAARI+AIAAFk4AgACOYoCAAAdQgIAAE+EAgADmKACAAJDvAIABMcMAgARpbwCAAEVEAIAAYpQAgAAWqwCAABgFAIAAAz+AgADiNACAAIG7gIAACF2A
Date: Tue, 23 Apr 2024 23:29:37 +0000
Message-ID: <9c6119dacac30750defb2b799f1a192c516ac79c.camel@intel.com>
References: <5ffd4052-4735-449a-9bee-f42563add778@intel.com>
	 <ZiEulnEr4TiYQxsB@google.com>
	 <22b19d11-056c-402b-ac19-a389000d6339@intel.com>
	 <ZiKoqMk-wZKdiar9@google.com>
	 <deb9ccacc4da04703086d7412b669806133be047.camel@intel.com>
	 <ZiaWMpNm30DD1A-0@google.com>
	 <3771fee103b2d279c415e950be10757726a7bd3b.camel@intel.com>
	 <Zib76LqLfWg3QkwB@google.com>
	 <6e83e89f145aee496c6421fc5a7248aae2d6f933.camel@intel.com>
	 <d0563f077a7f86f90e72183cf3406337423f41fe.camel@intel.com>
	 <ZifQiCBPVeld-p8Y@google.com>
	 <61ec08765f0cd79f2d5ea1e2acf285ea9470b239.camel@intel.com>
In-Reply-To: <61ec08765f0cd79f2d5ea1e2acf285ea9470b239.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|LV3PR11MB8768:EE_
x-ms-office365-filtering-correlation-id: 38771414-1355-4315-4fc7-08dc63ed3dd3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: =?utf-8?B?V2lyYzFaWklFMkFsZXFzTlZIODU4WGJqenArdzhFKzEyRXV0QlVwTXdLRS9t?=
 =?utf-8?B?dzEwWXJId3pUa2JMSElza2ZUd1JkcGdyd1FCd04yWGNXd0dUUThZcG9qNkRk?=
 =?utf-8?B?bldKdTNWd3NwQmh5bW1takhzTnEzRXBNSzFxTGpIZmwrTUY3czVKRkp6a2h5?=
 =?utf-8?B?TnB4NGIvY1hIYTlxNWpoSHZwQVlPQytiRGFZTW8rT0VVWkJRNGQ2Z0VVVkJt?=
 =?utf-8?B?dlZVL3I0S0s0TzVUOXp2a1Nkd29zK1Y0elZaaGtNdVE3K1BrRExCOVpNR3pr?=
 =?utf-8?B?U2ovVGRLTW1VQUpWbHVrZExPTGFMTDRLOCtHVHdBTm1FSWpOeG9ra1hBTFVp?=
 =?utf-8?B?b0JYZ3U4NVdhMExDTHlzSnUzcFpNYTYzWWNsOWlWRnJueGpkd3RrbEdZeFNE?=
 =?utf-8?B?emgwSFJnQVQ1aE5JMHJTeDk2bWtYVFV3QlpUN3I1eE02WEdGclZIeFRwbWFU?=
 =?utf-8?B?bDc1dk1GdDVhQ243SUxCazF3dnVCMW8yZUNqQWZKQzlsZFMwdUZuN21GaTg2?=
 =?utf-8?B?QzE3ajNjdHBLNWhWOXgyMkhTcU5WREhCM0ZFRE8xYmY0N3hDZjVKZi9WNDV0?=
 =?utf-8?B?aFdvQW9YL05FRythQUZsOUJvYTVudjNDaEVySmE5bEdxU3I0UkdOaFhJZWNG?=
 =?utf-8?B?dVg3Q0FTanlmS0pSd3BiOHVUdTk4YS9uMUhzMHI2d2o4SmZ0QThZRFNYcnY4?=
 =?utf-8?B?MWx3UXE1RVhDbkdVSEFVdW9naHNXdERTcnBLWGlzZmRyTUlZNzUxNXRhTW1k?=
 =?utf-8?B?S0EwU2dzdG5ISWhBbnUvRTNGVGtTZ0ZiSmdLejhBTFNpYlAvU0dYeWo0NFNs?=
 =?utf-8?B?MkwwQ3RqRERmWnovSUtWTTQvcGUzZVNycEppdU9HVlcxUHhPTWx0bFpEU2Vt?=
 =?utf-8?B?dzQ5V0JQODBORnZBeXd5VXFBQWJRYVVLcmF3VS9ZNFVRWURZUlNGb2tZb25V?=
 =?utf-8?B?Y1JtTWVoVHdiUi9qV3krMVBHNnllUGNTTDZDWWJZVVdDM1ZRQWtKRFhTRUlw?=
 =?utf-8?B?aFhWZFQ2Q0duWGNUVkRYTG80b0ZnckJZb2h0anpiL3NMc2l0WXB6WVR5ZzZl?=
 =?utf-8?B?NFM3OS9JVGFEbXFuRUdKMytYMlhnMDdCSjBwTFBaRDBHM0J5UGxaQjg0d3l4?=
 =?utf-8?B?WG5yN3MybWtCckxudEpKS0R5L1hkNUdUazZzL2dReC9kOS9CN0Z6WWpPOEdY?=
 =?utf-8?B?SWFEdDZYSHJ3aTJHRnBaK2k2YzNteU9TWFRSbWMvakQzN21vbnBYamxlYWxC?=
 =?utf-8?B?WW55TndaMlhFeFlOQWRWMDU5cVM4aFlpb2F1dnVtbHJqT2szeXY5T2JtUzBw?=
 =?utf-8?B?bmhKbnNBMWhCWUVRcHNlcTBLSFhHd0lrdFhuRGhubUFPYzRXVGNEZG9veDRh?=
 =?utf-8?B?SVpLTnpVV0owTkF5Y0xyb29CbzJnY2Q0TEFJSjI0MmFCSzlyclZIbWxVZVRK?=
 =?utf-8?B?cXMreVlKaU5NMFMxc0FqYnhlQ2JBNm5QM3lVVlFweFFHd215Y1VlOVJqZXJV?=
 =?utf-8?B?bWNQZkhMMXdqaDBhYkJhelVHSS9rcEZWS0ZEYUtiTklFaGxWSkxOT3c4L1FC?=
 =?utf-8?B?NmljVzc3Qy8rRDQzZ1VJbGlMU2hFa0VsZ1VyRjQ4TDFTazU5Ry9GTlAzQURj?=
 =?utf-8?B?TThqUG8wMGY2S1ppa0RaVXVCWjVuZ0dIRHM4dVppTlVEU3grWjNYNkVlMGcr?=
 =?utf-8?B?WEtwS2Vlam1zNytiVTl3OGJweXdFdStsVVVhVlBJYkJJSmVISUdnS0RjT3hU?=
 =?utf-8?B?QTJKZFIzZmdKR00wdnN5N0wzaFlwbHRSckFoTENyckVHdEZzZDFjZG9jM2RP?=
 =?utf-8?B?V2U2cnVhOTMwWXRLMjkxZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?emNRUXVaQ083cWxMNWJ0Umg1dFVhdGRFNGU4amlNY0FpSHlkZml3YVF5dWxL?=
 =?utf-8?B?YWRJVkllRFZnK2l0S0VhZmxJTm40MnE4Tm1FWjdRcm80dCt1RDJxQlFwYk9H?=
 =?utf-8?B?UDJMRUZzSTBBeVUrSlVpd1ZwejVuVlNRVm1UdzZVQWI2MmtCeURxQnkvdGMw?=
 =?utf-8?B?WWtuWHUrcG81cmlsZUYxaGMvTHNXV0VXbG55SHRZSXdSdVlOWnptSHF2cUI2?=
 =?utf-8?B?MzUxZ3lMb3VRemd2UUdMWGg0cUVwQ3pMN3FnRmhROVhvamRxdGJwTTZCd0lS?=
 =?utf-8?B?L3U2MW40YXVWaG52M21tTlFMSEhSMGZ4UUtWdVhOd2llSkNNWjQrQ0JDa2VC?=
 =?utf-8?B?aHVyOXZhRlU0WUxXTDZwOTl1SytCcTU4Y1FLc2x3RDE5RmdUSGJGeUNSdlk5?=
 =?utf-8?B?MEU3Vll1Vnh1N1dTL3pmY2ZtSEMxOGpVMU1wdENzS0tMb0hGcVc3TDBVbFlP?=
 =?utf-8?B?Z3FRdVVvUVNyN1lZZll0SnAycEQvcE53bTd1eGdFelJZRjdqTW16YmhSeWR4?=
 =?utf-8?B?YUNQeUlCMi9VS05UVDhZd0FVWFhOU3REWDVjQjYxVlFFcVV5NzJvM2dGNm96?=
 =?utf-8?B?NHJJMVNHTTVQYUNKOENxMS83dnVpWHY2ZVI3dXhsVGFvT3VuZVVwS0h6U0hP?=
 =?utf-8?B?ZE5QMllUTGN4NTlQUTRQOCthTlUzK2QvV2NCUVVwaXUxTjZwNlUzejRxQ09L?=
 =?utf-8?B?Qk85ZmhneVMyRkpRcGVRWWN0VEJvOE4vWHBtRHBTcUtKbHBwL0xHeTgvazUz?=
 =?utf-8?B?MzFLY1lpYW9MOEtYYTVHQjhzdklxMkhBa1ZPVGZrdy9BYjVNOURwZWpWd1JQ?=
 =?utf-8?B?Tk1XMURNS1dweHJlbXQ1Nmk5bXhqRE1RNDAycUlnMzA4eWFNbXJjTnFjNVBu?=
 =?utf-8?B?ZElpVG1tSmd1L3VJWnp4WWE1dGVxT21zVERpd3dXcFN6MTI2SHkzdW16WTJV?=
 =?utf-8?B?TUlKaG1KalFhMXR6UmNqaWZjK0lpclhGNjRtSDdkNDJlTHUySXVmdzFmREVh?=
 =?utf-8?B?dUd4RW56QVI3Mm5URmdsZEVPWmtDS2p5eE10OUIvazZkOXUrWTZ6T2ZuTitQ?=
 =?utf-8?B?U1VJOGhHZ3pKbmJLeXdPK3pVNW5qa0hYOWYva2xMVW90UVM1NUtZWVpaamU2?=
 =?utf-8?B?dkMxUzBTclg2YzFuWWw3UjFYUWZoRm84eThOcS9DZWNaaWl2TTg4UUcrdHhO?=
 =?utf-8?B?OUZLMDREaUh4c3g4WTQ3RVpNZ3pvdi9SMzFLa0RxaFlxZndZNk1VZmpPcG1H?=
 =?utf-8?B?MVMxNlA3N1FrYmlSZzRmaVFZUERPZVJZNm9xYTE2MnRmTngrRjBqcGNqL0Va?=
 =?utf-8?B?cXdMR0JsbXlnMXcxT2ZrZlhnRER6Rld6dExNMlpjU2tmd3J6QTVWTmxPNCtv?=
 =?utf-8?B?RGtwS2o0VS8zTDF1U1pFM040Ynpsd3ZZYU03SW1pMDg2RnBDdmlNOWFtNDFL?=
 =?utf-8?B?YUdEVnlJd2paYUw4WW5wcEZpdjZFVEJyWkQyeUthNTRRa3Z0a3dKUFZyNlF5?=
 =?utf-8?B?QUtGczRya3VQTnlIdG5ZKy9ZdWZRMjJQY3BtS0NxMlVjME5qSEY4eGdVbVEz?=
 =?utf-8?B?M05nSSt5OEZsM2FEVnR2T1pJSXZYZTQxZXZyUm95MkN2RVVyKzEyR1dUUzVH?=
 =?utf-8?B?ZWtsSjZFRzRDeTNCek9OUGhzZjJrL3kvNUhleHpaRUxQUUxQcmhiOWl5cXE3?=
 =?utf-8?B?Q0UwaFUrR21ZUGhNclVTTDhPdGQ5Nm9wUDA2NHpHWmlPaVcvUG9Pd042Q05L?=
 =?utf-8?B?cHlURWJkYWx4RjR3RlJmUlEyQnJqeWlQQXd5dEpyN2RLZUkrK0QvSWxaNUky?=
 =?utf-8?B?OUtJMG9NWG9OSFZualNUZFd4SHE2ZTJyMlF3ZWsvMGJ1UzVyUGpaN1krSWJJ?=
 =?utf-8?B?VzlOS3E2cXRibi9xMmVJZGRIK21TUHZVMTNyc0U1SXZ1c2l1emRLSURHZ1pI?=
 =?utf-8?B?WFVJaVAyaUx1azd6bWRYbDJoY1JRYUg4R3Z6UXAyRjBOV01RZHJLWGhiVk1Z?=
 =?utf-8?B?cmVMSWd1ZlpQWm5tVlh1U3dDM3JPS1p3MnNzamFGMVpnWFlnUllzTU9WMlRm?=
 =?utf-8?B?YStvRzlwZ2Qya0lPM2sxRnJnWU9Sb0V6c0l4Y0JVVEQ0WXcyN2ExK2ViUlNK?=
 =?utf-8?B?OStyUTRGK0xkMFlIcUhLYnU5WWlYTVh0aHBnbEY0eFBGTkhyWHFUdGFxUGFZ?=
 =?utf-8?B?Q3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <921D3C9EC7C17941AFF3BDAC47854323@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38771414-1355-4315-4fc7-08dc63ed3dd3
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2024 23:29:37.5331
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qXHAHC24WrHpLbUsPbPx5hhcgLi+ghssNt1VYQrz53k3ZKy2ysP3ZtdZTNJyn6SHVHD5GOE7HHSsPFZaxR9YCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8768
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA0LTIzIGF0IDIyOjU5ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
IFJpZ2h0LCBidXQgdGhhdCBkb2Vzbid0IHNheSB3aHkgdGhlICNVRCBvY2N1cnJlZC7CoCBUaGUg
bWFjcm8gZHJlc3NlcyBpdCB1cCBpbg0KPiA+IFREWF9TV19FUlJPUiBzbyB0aGF0IEtWTSBvbmx5
IG5lZWRzIGEgc2luZ2xlIHBhcnNlciwgYnV0IGF0IHRoZSBlbmQgb2YgdGhlIGRheQ0KPiA+IEtW
TSBpcyBzdGlsbCBvbmx5IGdvaW5nIHRvIHNlZSB0aGF0IFNFQU1DQUxMIGhpdCBhICNVRC4NCj4g
DQo+IFJpZ2h0LsKgIEJ1dCBpcyB0aGVyZSBhbnkgcHJvYmxlbSBoZXJlP8KgIEkgdGhvdWdodCB0
aGUgcG9pbnQgd2FzIHdlIGNhbg0KPiBqdXN0IHVzZSB0aGUgZXJyb3IgY29kZSB0byB0ZWxsIHdo
YXQgd2VudCB3cm9uZy4NCg0KT2gsIEkgZ3Vlc3MgSSB3YXMgcmVwbHlpbmcgdG9vIHF1aWNrbHku
ICBGcm9tIHRoZSBzcGVjLCAjVUQgaGFwcGVucyB3aGVuDQoNCglJRiBub3QgaW4gVk1YIG9wZXJh
dGlvbiBvciBpblNNTSBvciBpblNFQU0gb3LCoA0KCQkJKChJQTMyX0VGRVIuTE1BICYgQ1MuTCkg
PT0gMCkNCiAJCVRIRU4gI1VEOw0KDQpBcmUgeW91IHdvcnJpZWQgYWJvdXQgI1VEIHdhcyBjYXVz
ZWQgYnkgb3RoZXIgY2FzZXMgcmF0aGVyIHRoYW4gIm5vdCBpbg0KVk1YIG9wZXJhdGlvbiI/DQoN
CkJ1dCBpdCdzIHF1aXRlIG9idmlvdXMgdGhlIG90aGVyIDMgY2FzZXMgYXJlIG5vdCBwb3NzaWJs
ZSwgY29ycmVjdD8NCg==

