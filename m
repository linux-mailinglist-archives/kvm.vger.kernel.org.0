Return-Path: <kvm+bounces-32473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 420539D8D05
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 20:51:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03A7128BB48
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 19:51:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D86C1C3F0A;
	Mon, 25 Nov 2024 19:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IMlQi+5/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585F81BF804;
	Mon, 25 Nov 2024 19:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732564230; cv=fail; b=O8MPybgsYYSVX7J83vJOXMpnsMqwtgqZZgF+vx7059yCrb2z+m5flpauOe5P13/KZnssXbkV1UMsVHLvFbcpajiv97dE/QrZexSFRuk8RpyOXaZs/9T+Qb7yNo7xmRUIs7v0a8fASB7x6Cbxf9iVnbbtbOtaU8Ic+iBltjUOErg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732564230; c=relaxed/simple;
	bh=E0u7weB+pNiXIdcMqGl4K3qOLB1Svq9Hl6ujKuEv6nY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ym0VZffmrFcLUFPZ2EtLuznm2qnDDDPhgeUn4bDCu1lgP5WsvjFkTBrTGwG4fJL0Jee6cg5HIn6n492KoKuE9T7nb1t/2AWNB6VCiyX0GB7ILEQtlGtjOz2WTYP6KuM3dn+DAD70S2KXmjktWZ8RaY0XuP+OwHT2A2iPpAOM+9Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IMlQi+5/; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732564228; x=1764100228;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=E0u7weB+pNiXIdcMqGl4K3qOLB1Svq9Hl6ujKuEv6nY=;
  b=IMlQi+5/raDrMkuTQVc+Qv/QkN1SoCwXznqx1TB4IBJWmtyHN0WS+1bw
   N4lzDfiGT7Y6gl2dppkk0yr9vj8+Xe272NZhmZupMcCoowQH6YVKzVY1z
   MnM9Ie1HkbwNzTch0/fzMbLjxIaAYRLmsOg7N+D6Il4nbFRZLs0SImjSH
   IKSiCTzyekdcGmcZvLwP++bDwpD2gM9nfsLnu66dMICwr85m+dYGDfi/u
   i+YCKzr1zXnFeCocMNWpwpl8eqXKva0aJ1mRtfdCZacdX2Hcz6vCc5PqV
   rP/Gsg+Or7nPBlJz7lCg+OFrpyrGzWUyZhhfB7L3b9Gk/r1bQ4WqqOm8w
   w==;
X-CSE-ConnectionGUID: WtzebKeCQ0uZmNbuDebeaQ==
X-CSE-MsgGUID: d7ZWjGr7RXalnn5fnGw+yg==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="43351709"
X-IronPort-AV: E=Sophos;i="6.12,183,1728975600"; 
   d="scan'208";a="43351709"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 11:50:27 -0800
X-CSE-ConnectionGUID: Pm7av3gxQH2NosNBBy1JIw==
X-CSE-MsgGUID: RofgvCakT0qR/0WmV8TsdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,183,1728975600"; 
   d="scan'208";a="91831431"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Nov 2024 11:50:27 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 25 Nov 2024 11:50:27 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 25 Nov 2024 11:50:27 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 25 Nov 2024 11:50:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RUO081HchaDIVLEaGyiSfQed35/j/QCUM9184GdkWSKWS/0dumnqBnqfvo6mEgN9NC7lkGsgmZoNoK/Pmd0N0T8eMi+BDqmSgIOAOOsM0HQ2UsT2VYBraJzU1VAjrV3osYE7tOp2TZPvy1MsrzUqU7jCmSLG5hZK7Ehi+b2Wlbzj2kRbP73lbDkwvT9vPnYrQF5IDLBy7VgKu3dPMh1NCSTt5pU97WYJsjESjAVIlEsxtF7oAY74h1JjoBmOswRGFhOT1FlEsZbikLYo19TgxbuZp2zpUKx/vAA5rYhsU8FP79s7qPQuDG/EbFaoOk7PxyRmySTFRaFmfLL/b/bigQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E0u7weB+pNiXIdcMqGl4K3qOLB1Svq9Hl6ujKuEv6nY=;
 b=dTpecPxwpdjtSiBZcX5yIn593Gz0O71GhEaZtSE8ytq0ARaQ198o9rMKJjVJ4iE9Bctw0EmP8BUBvHfoBfIHAKWOltjIraWl7SKzJALFpz7NoCyw5thDunIYZ2dNWa971u9N/BCsDm8Xz8d86Bu+uUVSD74QqVyEHASlRvDoHD2rY4+uaJWmhXXBbQbxSb0HlhUpMsjfKCNpq2QuW4VqTjviHgwoveDOeZv93kP1KUvu1C8hOXA3+w2LMyOxg47L13MmuQLlVN6jEv/ekdeuCMoHBSWmRMdfzEzHCvmAFnxgXzSWNzf3PJCidBJpy7oDz6wSo5csb5JGQcF4bQY4Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW3PR11MB4633.namprd11.prod.outlook.com (2603:10b6:303:5b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.20; Mon, 25 Nov
 2024 19:50:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8182.018; Mon, 25 Nov 2024
 19:50:24 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Yang, Weijiang" <weijiang.yang@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, "Gao, Chao"
	<chao.gao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 0/7] KVM: TDX: TD vcpu enter/exit
Thread-Topic: [PATCH 0/7] KVM: TDX: TD vcpu enter/exit
Thread-Index: AQHbPFIlIBknYlpwZEWiEupj6OInArLHOU8AgADo4YCAAEuvAA==
Date: Mon, 25 Nov 2024 19:50:23 +0000
Message-ID: <735d3a560046e4a7a9f223dc5688dcf1730280c5.camel@intel.com>
References: <20241121201448.36170-1-adrian.hunter@intel.com>
		 <86d71f0c-6859-477a-88a2-416e46847f2f@linux.intel.com>
	 <Z0SVf8bqGej_-7Sj@google.com>
In-Reply-To: <Z0SVf8bqGej_-7Sj@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.1 (3.54.1-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW3PR11MB4633:EE_
x-ms-office365-filtering-correlation-id: 3ce4b133-44db-477d-050d-08dd0d8a66e7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cVRIcWpBQTk2aFVvbHI4WUI3MUxHZnVPQXc1NnFmYUFGSFgxRmYxNWphalRX?=
 =?utf-8?B?YWdKdjZNaTIwWjBUdnlGQW9RVnRhU3VrRnZ4dFdHUG9pYWZvdW5mZ3AvQnVs?=
 =?utf-8?B?TzFHVDA5TXBhb0FxVndiZGIzcm9JMDV3bnJPZ3lkdnBXN1k0dWN6bHc5WjNL?=
 =?utf-8?B?c1ZVK3RFUkR4UkZwV211VERWWjU0Wk11bGxpNVNDdHhWSVlhVS9yRVJFdm80?=
 =?utf-8?B?RzVKQ2tMVXRydC8ydlFTL3RIMTg5Tlo5M0xSWjdZU2RjL0JMak8rNnRRanA1?=
 =?utf-8?B?UkZDalloQkRBQjYvcjF3RDA1RFZsckoySTV3R0sxMWxHU0Q0NGxIc1pvMUZy?=
 =?utf-8?B?dzZTVVlnMmZEZGlCbU1WOGpDVGpqQmxYT25kQVpvT0RDZVNFbGNUenJSL1or?=
 =?utf-8?B?NU1lU2dmS0VaWjVUSkplL2lBc1A1ZHRINkErWWVNWlhpWWJyQTRHbFZhQm1t?=
 =?utf-8?B?d2NvTC9xUzF6TjB6dzNiSE1QM09oemJPRzVBemZFRXNPd0RwTHFLVjV5UjhW?=
 =?utf-8?B?QzkxbjNaSlhGOWdyZjlONm5xTGRGMGhUa1MvODI3em5qa1I5S3FabHBaaDNh?=
 =?utf-8?B?OFZFa0IrdENKSHZGbmcvL1R1VG4zNTVqa0JXY1R2aTJQakViNnRsbmN4aUlX?=
 =?utf-8?B?YUo4SCtEY2JsQzc2U01IR1dMMU0vd3BaTHFVeStHN0dhcnVYcGVjZHZMdzdz?=
 =?utf-8?B?czM2blQxZWlEMVgrNlVURDI0QmYrZUZCS0Y1aWxnNTEzNXVXRCtnMXczSkhN?=
 =?utf-8?B?Znc0R2lLcDZyVzFmbExjY0dobytMMGs1TTJFdURUdndrS2NnSURLVVlNTmVa?=
 =?utf-8?B?cnhBcEhjdVFJNm1jaGVOMkhYc0NNYjBzc0lIdWRmRUwwMU8zUUdxV00zelNm?=
 =?utf-8?B?ZFI4NTZFODd1aXNiRmswQ3JKM092MGVmbjFhcVlrS2JxZ24yd291ZmdrT0hi?=
 =?utf-8?B?NkptUVVkTnZnWmhpV1FSdTFuVGhuY2VuY0hPVWZWbitOYTc5cHgwQVB1enF3?=
 =?utf-8?B?ZUtKSjdsakRDWGdxYVd1cXB5SndkZ2hhTWd2eDhyS1RsRjl1NFJCd29FT0hi?=
 =?utf-8?B?N1VqOXJ6ZkdaOERaWlg4SjlGWXAxTVRoZERVdFpRZ0dDc1lDcE9XckNsQ29J?=
 =?utf-8?B?Q1YrbXR6YXR5cEQzNEIvb2VHSVFoZnlObXl1cHZteDZKaGpOMXJVWUpsdTcr?=
 =?utf-8?B?RjhOdk00K3JPRy9WSStxdE8yVFhvaWFIUkZpbkFRUTJxV2lPZGhsTGx6MlFE?=
 =?utf-8?B?Y0xwSFJBMlhQZzFkSEdQYjJKL1k3QkRRR0FWWlIrdXhnMkdkWThDbUJ3aHlP?=
 =?utf-8?B?UkRkTkphZ2V6cTIvSnZKUW4wVTNzVzhMZ1pLQ1EzNXpFa0dqUkR1WU1wTXZH?=
 =?utf-8?B?bzBsWmN6aG9za2JoOXNVcWR4eURCQkpCK0NsRVM0dmZGbk5ScEMyY2dtdHJv?=
 =?utf-8?B?cGlPclYxV1dpTnF0S1RVcVE0dkF4WFJmRlZUZ2FZcmVuTXVMRENhUVA3cVpl?=
 =?utf-8?B?S05qMi9lTTdPbmF5cTUzc1FUVWE0YUx0aytybkJRS3ZoeWxGZEZSZTV2VWhv?=
 =?utf-8?B?VGxHU3l0SWg3UzlOeGZUdlR2ZnpZVUdkRlZDSUJTMnEvSGt5Zjk4OWxldGV0?=
 =?utf-8?B?TEs0NVkvb3d1cUhacU55OGxYcE9VN0FHRU9VcWxpdEVpKzVxY1I2QXNXdk9s?=
 =?utf-8?B?aktVNWNPd01uK1FKcmZydXJXeWx2bitGbU1EbytpbExmQ0ZFWmo1OGhERjRD?=
 =?utf-8?B?b1I2OERBNVM2eTk3WEJwWldZYU14S0taeEh0c0QxWWMxNzIrZS9sNG82Y3dS?=
 =?utf-8?Q?jFkapKcoysh2bMttomR6kbZ5HEElakbj02UoU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aHpHcnVNQ2x1ZE1BbW1UblZvR0d1MHgyS2R3bzErU01xaEZwV3I3QmJURDls?=
 =?utf-8?B?b1ZWcGVNSzRjUnVUVzJiQjBjak05MGRrcnJKMENRWGV0MTJIY0QrR0J0YVAv?=
 =?utf-8?B?RXNEQjM4b2VWYnlmVUN0ZVN0aWxOdnNuMnZzODVUNnFDQWNKQXhNblNFWGtY?=
 =?utf-8?B?ek4xbU9CSzJXZlpZV1pTNE5VVkswVDFkUkJoK1l2SEJmRm1waVZWQ2wwVkwy?=
 =?utf-8?B?NmNEN0l3a2YzS21wdFZGTHhXY05QWlliajRtVWhibkM1NzBoN0NFTXFFdDZk?=
 =?utf-8?B?OHFlMlpkTjRIVUhCYklqWFlCMmx4ZFlZeE9RZ3JvY2YzYjdXNWlZUy9hNDVz?=
 =?utf-8?B?Ky9HUDgxQ1pRY2ZBbUtkQmJJQkN2NG1DcVBCa2dsSlFvSzVaVElUNWk2N2pW?=
 =?utf-8?B?OUsvVXU4ZFhDQ1d5UnZUbzhhSzFQVWRYRUxKNnZQMC90WVhlQXpPd3VDSWJp?=
 =?utf-8?B?eGdMZzJpWXN4cFBwcDhvazF3NEFyL29WQ1IraXI4Zy9kNUM4RzVsdkRMc3k4?=
 =?utf-8?B?QXlDWVVOUnpxcjNLRHovbzcya0xGbHNMQ1hzMVQwbXNvNGMrYUZKQU5TRUpk?=
 =?utf-8?B?UVFNSUo5Z3NIOXhjdEhRTXM1bjdjaEpENjd4TjJMd1FRd2thUWhpdC81WkR6?=
 =?utf-8?B?QmJGRnZhZUlVZEw1KzNtY3BkNmFheW56cHhUR1ZyREU5a1pHdGErRGk3QzRS?=
 =?utf-8?B?ejl1Sm9EdTU0amVhMGtMbmd5RHJDZDlFUXNKVDVaM1J4YlJjL094S1hnSVkz?=
 =?utf-8?B?YWcwc21iUnFuQytmZXQ3bUVJM1hRb0hqV0lDaW9NZk1JK0dCOE1JTlBCaGY1?=
 =?utf-8?B?Zjh0eklXbEVOQ0ZXRlRRNE5XZHBtVzl6Q1o2aHdHV3Iyd0FXOG5qN3gwNDJl?=
 =?utf-8?B?aU1hdzFudi80S3hPTU1rSWRtUHlaWUdtQWI2QTBnQkpGMUc5NzBOWWZ4MlZJ?=
 =?utf-8?B?RnFEYzl2VjB5dE43R2V0cmhQU2R0WXMrRzVTZnNuQnNRYlh6YU5sSlVTS2pM?=
 =?utf-8?B?VG1hRUkvNTJpU1hoN2FsTEtDMGNGZFo5SlZHem1ON1FxWUQ0aVA0QXhoNEh1?=
 =?utf-8?B?ODlpdS9OZGFIdDIyWnVwYXlkc0o1VElDd0htbTdkZ1ZIUUowSGp5dWZGdGVk?=
 =?utf-8?B?a0puYTQ2NHpXODNQTUM1SFB1eGJSUWRFMDdrY0p1ZlJjUkhTZmJqMVZKRG5m?=
 =?utf-8?B?eE5MRzlCTGZMWDRMUkVSNVhJL0Z3dnZzSzBndTlQSDVHa05BVHB6OXVvY2Vv?=
 =?utf-8?B?S3RGQkI0cklmNDc4SGd2cVRwaHI3QkZsenVibEhCK0xoejZmcWtJcGpRanA0?=
 =?utf-8?B?LzYzSXZESG10YmRMb3g2Q0cxQ0NUa0JSd0d5OFpEc2M5azM1R3lhc0V3VklF?=
 =?utf-8?B?QjRmWVArSGtLcitBTllkZ3ZiblYxU2t2UGZYUHljZklOZ3ArWjBjODVRYWJp?=
 =?utf-8?B?WXJIcVo4T09WMktDQ0ptaTUwTEtmaWZsZlRUQ3l0NERwYWRPQmgyL2x5VTNJ?=
 =?utf-8?B?ZUFlSW5Mcm51bWpPemVsbEVNMzhLVjhOSlFCdXpKWGphc3VsMWdxeTNmeXVL?=
 =?utf-8?B?cSszMFYzdHRiUjMzdVpiekVydXlST2w5Rmo0MGtaMm5LOCt1VU5RQnYrL2FC?=
 =?utf-8?B?UjcxS2JLNXVybFV6cVA5Q0NHTCtDb0IxY3M5SSt3RmFFTTF0a1NIRXgxN3N5?=
 =?utf-8?B?Zm5QZWZidEdxY1lMODFlWWJmNWowK2p2S2JzVENXS1JaQXkvcG0yQTRadUc3?=
 =?utf-8?B?VmxxSjNpc1hVOWxmZHN0aFZjVjJkNzFHMG9KRmUyZmtXZ05MMDdKekVLaGlF?=
 =?utf-8?B?ODdRUGtDdWhvb2ZpVEx0cHAvU01FYXdva2hwa2ZxdFVLVWZWdHY3SXRibUVy?=
 =?utf-8?B?a2Z5bTJSdzQ2QmpsRWd5YkkrS0NxM0Q5R3NzNkRsSXZMK3JpZ21UWW9hUkpz?=
 =?utf-8?B?QklreEZxMUxtcmtsZnE4Z0Q2NDhqSk9HeEYvbWIwVDNYS3puTlhDNTVyU0Y3?=
 =?utf-8?B?Z3VJU0lTeTcwNGV0NWd0TCtNOEk4b3plUG1ZUFBZbkVMbTJyVkVpaVI4a3Z3?=
 =?utf-8?B?Y1E4RmtCWGE1V2Z3VS9HNllRSHc2NEhLK29acDBUbU5vSVR4TVdvN0p6U2pW?=
 =?utf-8?Q?iypgvKX+SXv5hKma2XVSqMAxA?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B43CF5DDD3F94F4E9D76210549C1C4C7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ce4b133-44db-477d-050d-08dd0d8a66e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2024 19:50:23.9454
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uK+Tt0NXBDmj8NKMGahJTJpQuBk45lgNsM8zfvW8PgfeKBbb0aEUVUn/leEOMhXKa/5VOFq4P1EG3b7d6tFXiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4633
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTExLTI1IGF0IDA3OjE5IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBNb24sIE5vdiAyNSwgMjAyNCwgQmluYmluIFd1IHdyb3RlOg0KPiA+IE9uIDEx
LzIyLzIwMjQgNDoxNCBBTSwgQWRyaWFuIEh1bnRlciB3cm90ZToNCj4gPiBbLi4uXQ0KPiA+ID4g
ICAgLSB0ZHhfdmNwdV9lbnRlcl9leGl0KCkgY2FsbHMgZ3Vlc3Rfc3RhdGVfZW50ZXJfaXJxb2Zm
KCkNCj4gPiA+ICAgICAgYW5kIGd1ZXN0X3N0YXRlX2V4aXRfaXJxb2ZmKCkgd2hpY2ggY29tbWVu
dHMgc2F5IHNob3VsZCBiZQ0KPiA+ID4gICAgICBjYWxsZWQgZnJvbSBub24taW5zdHJ1bWVudGFi
bGUgY29kZSBidXQgbm9pbnN0IHdhcyByZW1vdmVkDQo+ID4gPiAgICAgIGF0IFNlYW4ncyBzdWdn
ZXN0aW9uOg0KPiA+ID4gICAgCWh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC9aZzh0SnNwTDl1
Qm1NWkZPQGdvb2dsZS5jb20vDQo+ID4gPiAgICAgIG5vaW5zdHIgaXMgYWxzbyBuZWVkZWQgdG8g
cmV0YWluIE5NSS1ibG9ja2luZyBieSBhdm9pZGluZw0KPiA+ID4gICAgICBpbnN0cnVtZW50ZWQg
Y29kZSB0aGF0IGxlYWRzIHRvIGFuIElSRVQgd2hpY2ggdW5ibG9ja3MgTk1Jcy4NCj4gPiA+ICAg
ICAgQSBsYXRlciBwYXRjaCBzZXQgd2lsbCBkZWFsIHdpdGggTk1JIFZNLWV4aXRzLg0KPiA+ID4g
DQo+ID4gSW4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL1pnOHRKc3BMOXVCbU1aRk9AZ29v
Z2xlLmNvbSwgU2VhbiBtZW50aW9uZWQ6DQo+ID4gIlRoZSByZWFzb24gdGhlIFZNLUVudGVyIGZs
b3dzIGZvciBWTVggYW5kIFNWTSBuZWVkIHRvIGJlIG5vaW5zdHIgaXMgdGhleSBkbyB0aGluZ3MN
Cj4gPiBsaWtlIGxvYWQgdGhlIGd1ZXN0J3MgQ1IyLCBhbmQgaGFuZGxlIE5NSSBWTS1FeGl0cyB3
aXRoIE5NSXMgYmxvY2tzLsKgIE5vbmUgb2YNCj4gPiB0aGF0IGFwcGxpZXMgdG8gVERYLsKgIEVp
dGhlciB0aGF0LCBvciB0aGVyZSBhcmUgc29tZSBtYXNzaXZlIGJ1Z3MgbHVya2luZyBkdWUgdG8N
Cj4gPiBtaXNzaW5nIGNvZGUuIg0KPiA+IA0KPiA+IEkgZG9uJ3QgdW5kZXJzdGFuZCB3aHkgaGFu
ZGxlIE5NSSBWTS1FeGl0cyB3aXRoIE5NSXMgYmxvY2tzIGRvZXNuJ3QgYXBwbHkgdG8NCj4gPiBU
RFguwqAgSUlVSUMsIHNpbWlsYXIgdG8gVk1YLCBURFggYWxzbyBuZWVkcyB0byBoYW5kbGUgdGhl
IE5NSSBWTS1leGl0IGluIHRoZQ0KPiA+IG5vaW5zdHIgc2VjdGlvbiB0byBhdm9pZCB0aGUgdW5i
bG9jayBvZiBOTUlzIGR1ZSB0byBpbnN0cnVtZW50YXRpb24taW5kdWNlZA0KPiA+IGZhdWx0Lg0K
PiANCj4gV2l0aCBURFgsIFNFQU1DQUxMIGlzIG1lY2huaWNhbGx5IGEgVk0tRXhpdC4gIEtWTSBp
cyB0aGUgImd1ZXN0IiBydW5uaW5nIGluIFZNWA0KPiByb290IG1vZGUsIGFuZCB0aGUgVERYLU1v
ZHVsZSBpcyB0aGUgImhvc3QiLCBydW5uaW5nIGluIFNFQU0gcm9vdCBtb2RlLg0KPiANCj4gQW5k
IGZvciBUREguVlAuRU5URVIsIGlmIGEgaGFyZHdhcmUgTk1JIGFycml2ZXMgd2l0aCB0aGUgVERY
IGd1ZXN0IGlzIGFjdGl2ZSwNCj4gdGhlIGluaXRpYWwgTk1JIFZNLUV4aXQsIHdoaWNoIGNvbnN1
bWVzIHRoZSBOTUkgYW5kIGJsb2NrcyBmdXJ0aGVyIE5NSXMsIGdvZXMNCj4gZnJvbSBTRUFNIG5v
bi1yb290IHRvIFNFQU0gcm9vdC4gIFRoZSBTRUFNUkVUIGZyb20gU0VBTSByb290IHRvIFZNWCBy
b290IChLVk0pDQo+IGlzIGVmZmVjdGl2ZWx5IGEgVk0tRW50ZXIsIGFuZCBkb2VzIE5PVCBibG9j
ayBOTUlzIGluIFZNWCByb290IChhdCBsZWFzdCwgQUZBSUspLg0KPiANCj4gU28gdHJ5aW5nIHRv
IGhhbmRsZSB0aGUgTk1JICJleGl0IiBpbiBhIG5vaW5zdHIgc2VjdGlvbiBpcyBwb2ludGxlc3Mg
YmVjYXVzZSBOTUlzDQo+IGFyZSBuZXZlciBibG9ja2VkLg0KDQpJIHRob3VnaHQgTk1JIHJlbWFp
bnMgYmVpbmcgYmxvY2tlZCBhZnRlciBTRUFNUkVUPw0KDQpUaGUgVERYIENQVSBhcmNoaXRlY3R1
cmUgZXh0ZW5zaW9uIHNwZWMgc2F5czoNCg0KIg0KT24gdHJhbnNpdGlvbiB0byBTRUFNIFZNWCBy
b290IG9wZXJhdGlvbiwgdGhlIHByb2Nlc3NvciBjYW4gaW5oaWJpdCBOTUkgYW5kIFNNSS4NCldo
aWxlIGluaGliaXRlZCwgaWYgdGhlc2UgZXZlbnRzIG9jY3VyLCB0aGVuIHRoZXkgYXJlIHRhaWxv
cmVkIHRvIHN0YXkgcGVuZGluZw0KYW5kIGJlIGRlbGl2ZXJlZCB3aGVuIHRoZSBpbmhpYml0IHN0
YXRlIGlzIHJlbW92ZWQuIE5NSSBhbmQgZXh0ZXJuYWwgaW50ZXJydXB0cw0KY2FuIGJlIHVuaW5o
aWJpdGVkIGluIFNFQU0gVk1YLXJvb3Qgb3BlcmF0aW9uLiBJbiBTRUFNIFZNWC1yb290IG9wZXJh
dGlvbiwNCk1TUl9JTlRSX1BFTkRJTkcgY2FuIGJlIHJlYWQgdG8gaGVscCBkZXRlcm1pbmUgc3Rh
dHVzIG9mIGFueSBwZW5kaW5nIGV2ZW50cy4NCg0KT24gdHJhbnNpdGlvbiB0byBTRUFNIFZNWCBu
b24tcm9vdCBvcGVyYXRpb24gdXNpbmcgYSBWTSBlbnRyeSwgTk1JIGFuZCBJTlRSDQppbmhpYml0
IHN0YXRlcyBhcmUsIGJ5IGRlc2lnbiwgdXBkYXRlZCBiYXNlZCBvbiB0aGUgY29uZmlndXJhdGlv
biBvZiB0aGUgVEQgVk1DUw0KdXNlZCB0byBwZXJmb3JtIHRoZSBWTSBlbnRyeS4NCg0KLi4uDQoN
Ck9uIHRyYW5zaXRpb24gdG8gbGVnYWN5IFZNWCByb290IG9wZXJhdGlvbiB1c2luZyBTRUFNUkVU
LCB0aGUgTk1JIGFuZCBTTUkNCmluaGliaXQgc3RhdGUgY2FuIGJlIHJlc3RvcmVkIHRvIHRoZSBp
bmhpYml0IHN0YXRlIGF0IHRoZSB0aW1lIG9mIHRoZSBwcmV2aW91cw0KU0VBTUNBTEwgYW5kIGFu
eSBwZW5kaW5nIE5NSS9TTUkgd291bGQgYmUgZGVsaXZlcmVkIGlmIG5vdCBpbmhpYml0ZWQuDQoi
DQoNCkhlcmUgTk1JIGlzIGluaGliaXRlZCBpbiBTRUFNIFZNWCByb290LCBidXQgaXMgbmV2ZXIg
aW5oaWJpdGVkIGluIFZNWCByb290LiDCoA0KDQpBbmQgdGhlIGxhc3QgcGFyYWdyYXBoIGRvZXMg
c2F5ICJhbnkgcGVuZGluZyBOTUkgd291bGQgYmUgZGVsaXZlcmVkIGlmIG5vdA0KaW5oaWJpdGVk
Ii4gwqANCg0KQnV0IEkgdGhvdWdodCB0aGlzIGFwcGxpZXMgdG8gdGhlIGNhc2Ugd2hlbiAiTk1J
IGhhcHBlbnMgaW4gU0VBTSBWTVggcm9vdCIsIGJ1dA0Kbm90ICJOTUkgaGFwcGVucyBpbiBTRUFN
IFZNWCBub24tcm9vdCI/ICBJIHRob3VnaHQgdGhlIE5NSSBpcyBhbHJlYWR5DQoiZGVsaXZlcmVk
IiB3aGVuIENQVSBpcyBpbiAiU0VBTSBWTVggbm9uLXJvb3QiLCBidXQgSSBndWVzcyBJIHdhcyB3
cm9uZyBoZXJlLi4NCg0KPiANCj4gVERYIGlzIGFsc28gZGlmZmVyZW50IGJlY2F1c2UgS1ZNIGlz
bid0IHJlc3BvbnNpYmxlIGZvciBjb250ZXh0IHN3aXRjaGluZyBndWVzdA0KPiBzdGF0ZS4gIFNw
ZWNpZmljYWxseSwgQ1IyIGlzIG1hbmFnZWQgYnkgdGhlIFREWCBNb2R1bGUsIGFuZCBzbyB0aGVy
ZSBpcyBubyB3aW5kb3cNCj4gd2hlcmUgS1ZNIHJ1bnMgd2l0aCBndWVzdCBDUjIsIGFuZCB0aHVz
IHRoZXJlIGlzIG5vIHJpc2sgb2YgY2xvYmJlcmluZyBndWVzdCBDUjINCj4gd2l0aCBhIGhvc3Qg
dmFsdWUsIGUuZy4gZHVlIHRvIHRha2UgYSAjUEYgZHVlIGluc3RydW1lbnRhdGlvbiB0cmlnZ2Vy
aW5nIHNvbWV0aGluZy4NCj4gDQo+IEFsbCB0aGF0IHNhaWQsIEkgZGlkIGZvcmdldCB0aGF0IGNv
ZGUgdGhhdCBydW5zIGJldHdlZW4gZ3Vlc3Rfc3RhdGVfZW50ZXJfaXJxb2ZmKCkNCj4gYW5kIGd1
ZXN0X3N0YXRlX2V4aXRfaXJxb2ZmKCkgY2FuJ3QgYmUgaW5zdHJ1bWVuZXRlZC4gIEFuZCBhdCBs
ZWFzdCBhcyBvZiBwYXRjaCAyDQo+IGluIHRoaXMgc2VyaWVzLCB0aGUgc2ltcGxlc3Qgd2F5IHRv
IG1ha2UgdGhhdCBoYXBwZW4gaXMgdG8gdGFnIHRkeF92Y3B1X2VudGVyX2V4aXQoKQ0KPiBhcyBu
b2luc3RyLiAgSnVzdCBwbGVhc2UgbWFrZSBzdXJlIG5vdGhpbmcgZWxzZSBpcyBhZGRlZCBpbiB0
aGUgbm9pbnN0ciBzZWN0aW9uDQo+IHVubGVzcyBpdCBhYnNvbHV0ZWx5IG5lZWRzIHRvIGJlIHRo
ZXJlLg0KDQpJZiBOTUkgaXMgbm90IGEgY29uY2VybiwgaXMgYmVsb3cgYWxzbyBhbiBvcHRpb24/
DQoNCglndWVzdF9zdGF0ZV9lbnRlcl9pcnFvZmYoKTsNCg0KCWluc3RydWN0bWVudGF0aW9uX2Jl
Z2luKCk7DQoJdGRoX3ZwX2VudGVyKCk7DQoJaW5zdHJ1Y3RtZW50YXRpb25fZW5kKCk7DQoNCgln
dWVzdF9zdGF0ZV9leGl0X2lycW9mZigpOw0KDQo=

