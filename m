Return-Path: <kvm+bounces-11721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB6DD87A445
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 09:52:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A18FC282495
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 08:52:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEC221CD22;
	Wed, 13 Mar 2024 08:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DO6jtQNy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEC918EAD;
	Wed, 13 Mar 2024 08:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710319944; cv=fail; b=eEJok3MURZiKB5xME0P/QizrGi0sKigB/DsSi4mv7qyN1XxGKN9dVaqwo75d2cDhL7kOXkCuO/ASDakAF/noeK20Q4A0X5ztCx7JgjshuupAjD50e3Yy79KiBNDBRHGMgaIC7+gfcrsM0IHVxqRx0MDMFKQHp6+PvPBZomDFhIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710319944; c=relaxed/simple;
	bh=eAewEni7Zi925+x2tDggleSpBLl//Jig/A9iZHLCxFY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=t38OqblMS6/M/KtmG3wN7wJuOQVdIH0qQl9Mrl4GFZqAj6qDALWNRwd5k8cCQZFgT2FeCJl17SuA/mQJR8ppN39C7UbKwvTJo/44mbVAxwquyoRJV/Z81UeA9f9hxZjirbsDNDFqSbyu/KSbbZdTEW+7L9y/GIQvRZraGH0Ly2Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DO6jtQNy; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710319941; x=1741855941;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eAewEni7Zi925+x2tDggleSpBLl//Jig/A9iZHLCxFY=;
  b=DO6jtQNy42+B7KT6MhSsLmrSOUSLfLU8ooJhbl6lZkAB8H0HrEkTwx38
   p8k7ruDkQQC7/W2eViu0OphW9sr/Gwf2IXu56S8t4J6KZZwkrI44rIKLP
   wuIZRV7ukkFFdVpk0SkhFdQfnNubKRlwtnmnxaI1gVFj+jMPjp239MXHg
   6vfdJj3AzQ61ikT2bywPKAKhdCyL0nX2acfrNguFvXCFXImkIw+hbcLF3
   lBfNZSr4i3QVtK2/j/d48Ia39Y5WDFMeYS/Hk5c1sAy44ucCZRm/GnhcX
   ggEN/CKFpQTUNT4H9uxFRP8DSbnJVtUX/EB+7Jlx7AN3FvzOANFv7Qk1n
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11011"; a="16472561"
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="16472561"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 01:52:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="42784400"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Mar 2024 01:52:20 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 13 Mar 2024 01:52:19 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 13 Mar 2024 01:52:19 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 13 Mar 2024 01:52:19 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 13 Mar 2024 01:52:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Di3EgmIY8rnG+lOx4VoUOsQaPm/tmwFDYZRtEFid4uAuwnZ26Er8MGVIjxGSWqWQKszZR8jDabA19oGMQFap5gYGCxTu+DQtKJIWlvbIFy8zFZYLYB4d5nXKVv0lUU0NaIhhd81gv0a1NHsKs2iwsvI9EmRL5VjwcGz6P1i7jU+68ahP3Tol4nCnIvcVh6bb5nFUvSDbEHwKzRdJj0Y5AxKxEeD7TCrkJpuTVIw5LEIkNSQnP5uwn/N76pVKLdGgU9eVxWWlAVyZudds1e2Flpck4inSylgVMJKbiS5DhpWrnE3lQYB9U2xSGldGbX3njICBJpU+zjX2aIf0c7t8eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eAewEni7Zi925+x2tDggleSpBLl//Jig/A9iZHLCxFY=;
 b=j6eIqns3baPHCNXkwb8g+bBDx64OVReh9RMmOKersuFcNoFClyd2b8JVwSwRq1wqSFbxtmtS/LV/eG+y3WBrq01ptEgkXOhqrGTgQrkFsGX9q4CbfKTDdeGvoRvugqX1+brPi5FO5M+6ry378z4Wi2FmARGU2rul6CHl22OK771KNo06qfpMtAqwlHbI/GF66OysrROJM7MJh62b3Ow90iPUSD7Lf95uJ2oAqgYQlts29twvttHGeE99U+uENAoKV7BOpnxsTztloasAQxbMvDTBYr9TiFt7Qz6NXmOMsosxp66UuWDaui83YkL3BYZ/zEtNg07fC5JDFa6BMkF/FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB7078.namprd11.prod.outlook.com (2603:10b6:303:219::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.18; Wed, 13 Mar
 2024 08:52:16 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327%5]) with mapi id 15.20.7386.017; Wed, 13 Mar 2024
 08:52:15 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>, Sean Christopherson
	<seanjc@google.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Lai Jiangshan
	<jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, "Josh
 Triplett" <josh@joshtriplett.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yiwei Zhang
	<zzyiwei@google.com>
Subject: RE: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that support
 self-snoop
Thread-Topic: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that
 support self-snoop
Thread-Index: AQHacb6EgZkVEFvOhE+zvGbU+mYd9rExwA6AgAGEHICAAGu9EIAAm0qAgACaIQCAAHOBEA==
Date: Wed, 13 Mar 2024 08:52:15 +0000
Message-ID: <BN9PR11MB527688657D92896F1B19C2F98C2A2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240309010929.1403984-1-seanjc@google.com>
 <20240309010929.1403984-6-seanjc@google.com>
 <Ze5bee/qJ41IESdk@yzhao56-desk.sh.intel.com> <Ze-hC8NozVbOQQIT@google.com>
 <BN9PR11MB527600EC915D668127B97E3C8C2B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZfB9rzqOWmbaOeHd@google.com> <ZfD++pl/3pvyi0xD@yzhao56-desk.sh.intel.com>
In-Reply-To: <ZfD++pl/3pvyi0xD@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB7078:EE_
x-ms-office365-filtering-correlation-id: 80c53809-43fa-4a03-ba11-08dc433ae20b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VOe59Y6E9xVOxFMWrZqddsCcV/fcjL+ukjzSKwLRo/rY9+bu90Lg7D9IYqO6Fie9gLHPuKO4s6Q4oQpdTCuZ3WlFhN5m8vLGOogmGCbGZVoZGwKZKeVuh21Trm0RHF4ImXYcI8lag/Fv0NZ7hLrieraCqH4kJ3VJKrLIzbBoNYL+Z+4CNNfH77Ksg4WZNbPWhFBi9rFbmyMO7wY38hvdqTroeXlRSdvKtFFABXnY/1C/ePcWZaqV/ZG6YnJw2kFXZlSM9BIP5Cj6QIb+xRtqcVdmRM+VrJowuaB3sA7mO7HMd/2rnQV05CECu1K+twRYyFV2hu+4/0wm08WEcClAnc53U1XRVFu7lCVbGkowQRTvd5ZWmLad1x6K4rCmLALhYugeYUQMZEMzGP58x7DUMyTsBr3BQuh5DHhQOcEqWmQWVzY8v3YjJiQRU57JFnBcFr4cWyUjIb5uijbSUWpptcZ56dowKFKl95cvBHTP8v76OjT7PYp1T+35CZg3sG59vUE5cwq4Wai3o3QyJDeHMk0g79nhMPXbJI9PmSrRzQVwSTLGLjpF0OmCL7LQFuLsFSFofXkggbkupeS7KH6CMku7L1VrJwRI0jMjWifgrdjnSJjZI1SR7CyZ2xkQ4ybsw/njfv//GGSq91irZP3twmkoI2IxGkrn1xJcE/CSFsI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SWtJVjBlNGFsNGNqTU44elpLSXpVTWZWdG8rZzVNbU9tdGNJalM0anhaY2pH?=
 =?utf-8?B?czdjTDR3UFN2dkIrZERZUHBpWVE3LzZNRXFINTFSQituWk5wWHZRcmp5eHhX?=
 =?utf-8?B?emtob3BxMUJNSmJQdXFHWFh1Qy9OdmROK1Bya25NcENWY21raDdlZlBtTlhr?=
 =?utf-8?B?cGtHcVl0L0d2VDdMNW1sRyswM2hMU1R2cXphU1EweklLenkxUzNSWHhKejJa?=
 =?utf-8?B?bmxqRXNyWFZiQVpWY0QrRGMrTS9zUW1NVkRyYnVucitzYjJjRTZONmJBcnI2?=
 =?utf-8?B?YVpmL3o4a05IQmtJVDZ3bTREQUpmSERhaG03WHlmY0Z5MG01dHdKMG96em9Y?=
 =?utf-8?B?cFcwZXh2eGNnU3RmR3paRk9McytuUHJmeTRZam1EN24xeWlxNnBoZEZyeVRU?=
 =?utf-8?B?TnJRZ1QvSjZTZWZJZk9lZGNLYm02V285b0t6WkNSTC9nbzg3VDBjNnRLOTYw?=
 =?utf-8?B?SFkvS2lFWFRKdk5QL1hRbnl0Q1FacFpxaGFHT25HVm5wSFFDek9Qek85VG4v?=
 =?utf-8?B?UFcxTytXSFhFQ0h4VGdpbGFmRlV5WUkwd3lXNTFsN0U1VkRHTThWeDB3YTBi?=
 =?utf-8?B?b2JMaEFIa3pGTktyUUlKRThCZklTSWNSVUpPQWxabVczaEhJdS9KZ2h4akNC?=
 =?utf-8?B?c05zdnc4ZWFzU3dSOE5EL1pVTWUzdzVuRGF5QXF3QzlEUEV5UkhPdTl2SzU2?=
 =?utf-8?B?MjBoQzBRZ1JQNUtPZnoyWE96RzlibXd2NEtXVTFlTkhOdnRkeGR0cnJVWVNs?=
 =?utf-8?B?Q1VrVVFkazlKZW5qanpLTnQycno5VkVtWkFYbS9nN0xlZHhSSjF4dWxXNWE5?=
 =?utf-8?B?TkZXd21vb0F0Vk55Y29ISmZ6OHRScVNNZEo4bExWdUdqNEJEQUFPRktUcnpC?=
 =?utf-8?B?emVCcy9XZk5lL2VaRzZEMlZEWklPL2NHV2I2Z0x4L014aTg4ODBzR1hzOThR?=
 =?utf-8?B?Y1V5NFZwN2ZSTkthaVVCbUlCZmNoMXhsQ3NXVktkVzJLU2lCaGJpK2FaNklN?=
 =?utf-8?B?Zm5kY0xGZUE4M3BVc1UzaHV0RVNkQlVFYWlyUlRQSkszank5MEdZNlhGLy9D?=
 =?utf-8?B?NS81QWltbmFIaW1BalJjU05rV3B3ajdBV05BNjU0cHpobk9oUFZzNm44c1Qz?=
 =?utf-8?B?ditXYTAyUzFTaC9ja3lYZEpGOG1DaUJ6L2lHUW51bkNNOUg1cWFTSXBMQlpL?=
 =?utf-8?B?dXdyaGpPVXdJcmp4ckRJVENpZnJ2UVdNa29DR1RVbnI0UXV5T09leEZGOTBD?=
 =?utf-8?B?K0pZdlFNRFZ6cEQvQVJTT1hKOVZkdVRUZjRsNGlwbVJPaWxHNnVJbzV5UkxZ?=
 =?utf-8?B?Z2tjeVNxT1JyTFlMellMT01PWHIzOWFFcWc2bVNBYUw2WDliMEdOWSt5MG13?=
 =?utf-8?B?KytPaks1Tm9WbVh3dFJmL1F3RGFORVRKd0EyVVZ1ckJrV0djWjVQV0xnamo3?=
 =?utf-8?B?MU9IbEprTExaUTIwQ3ZzUEMwMll1Yi9UQngrd1RScE5uS1J2cnptdERFeXhz?=
 =?utf-8?B?Ull5QlEyNmRxSFVKaXEzQlR2NUpUdkRDK0pmSnNLS0hUSG5qcmpXdnB6TVZZ?=
 =?utf-8?B?ZllDNTJTbHFVVXhGK2FFQnZpV29WT0xnL1NrYmtsMWQ3K1BiUXZubE01S0E0?=
 =?utf-8?B?YTZObUplVE0vSkY2MUpUWXVWRFhxSXROek9vSmlOdmxoMFlxaVpqdDRLYkw3?=
 =?utf-8?B?ZVpqYytpakt3b3M2RVlyUG1TKzVDMkdTYUVPZ1B1bkQrZzdhb1VGVXd4b3RQ?=
 =?utf-8?B?Vm55YjN0QW1saUQzS0R5ZnpJVDZwZWRvaG9RMGR3SGFiWmR1ekJPSEhRcjAw?=
 =?utf-8?B?VUNxOU5Uc3VCZEI1c1d5OVo4cEowNmY3TGVvQ1I4dWtESmVURlEvWEZEY3Ey?=
 =?utf-8?B?VTh3ZmVtZ0Z0ak52cjlWMXlnN29BZytFbndZbVNsY3hxU0g4Q2V5MU13UVkz?=
 =?utf-8?B?blFFY3VKWVUyT2h5L3dadHJFQ3hFZzlYYWtCUURhSHRJL0duZ1poMmszNnND?=
 =?utf-8?B?a3dJMnhTaFZHQlhOaEQwLzYzaTZ1L3JIaUE2eE1paDc5OTEvRXhMYkdwZWph?=
 =?utf-8?B?K0E5Z2hwNy9oYnJvNTNHbnd2UG9VOU4yc1pRdVZOYUpjZnpZeVB4VVladUtt?=
 =?utf-8?Q?GsVBBWBEoLmGOpzOqRit3jakM?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80c53809-43fa-4a03-ba11-08dc433ae20b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2024 08:52:15.9165
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uJeVF37wE8+47Nil4xTRdX/mKM8hVK8368HCE22FxW7gMQb9FqW73jVIkNzKlg9yfOnx2JeI1NUjnXG758YQcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7078
X-OriginatorOrg: intel.com

PiBGcm9tOiBaaGFvLCBZYW4gWSA8eWFuLnkuemhhb0BpbnRlbC5jb20+DQo+IFNlbnQ6IFdlZG5l
c2RheSwgTWFyY2ggMTMsIDIwMjQgOToxOSBBTQ0KPiANCj4gT24gVHVlLCBNYXIgMTIsIDIwMjQg
YXQgMDk6MDc6MTFBTSAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gPiBPbiBU
dWUsIE1hciAxMiwgMjAyNCwgS2V2aW4gVGlhbiB3cm90ZToNCj4gPiA+IEkgc2F3IHRoZSBvbGQg
Y29tbWVudCBhbHJlYWR5IG1lbnRpb25lZCB0aGF0IGRvaW5nIHNvIG1heSBsZWFkIHRvDQo+IHVu
ZXhwZWN0ZWQNCj4gPiA+IGJlaGF2aW9ycy4gQnV0IEknbSBub3Qgc3VyZSB3aGV0aGVyIHN1Y2gg
Y29kZS1sZXZlbCBjYXZlYXQgaGFzIGJlZW4NCj4gdmlzaWJsZQ0KPiA+ID4gZW5vdWdoIHRvIGVu
ZCB1c2Vycy4NCj4gPg0KPiBXaGF0IGFib3V0IGFkZCBhIG5ldyBtb2R1bGUgcGFyYW1ldGVyIHRv
IHR1cm4gb24gaG9ub3JpbmcgZ3Vlc3QgZm9yDQo+IG5vbi1jb2hlcmVudCBETUFzIG9uIENQVXMg
d2l0aG91dCBzZWxmLXNub29wPw0KPiBBIHByZXZpb3VzIGV4YW1wbGUgaXMgVkZJTydzICJhbGxv
d191bnNhZmVfaW50ZXJydXB0cyIgcGFyYW1ldGVyLg0KDQpOb3Qgc3VyZSB3aGV0aGVyIHN1Y2gg
cGFyYW1ldGVyIGhhcyBhIHJlYWwgdmFsdWUuDQoNCklmIGl0J3MgZGVmYXVsdCAnb2ZmJyB0aGVu
IHlvdSBicmVhayB0aG9zZSAxMHlyKyBzZXR1cHMgYW5kIGl0J3MgdW5hY2NlcHRhYmxlLg0KDQpJ
ZiBpdCdzIGRlZmF1bHQgJ29uJyB0aGVuIHNhbWUgZWZmZWN0IGFzIHRoaXMgcGF0Y2ggZG9lcyB0
aGVuIEknbSBub3Qgc3VyZSB3aG8nZA0Kd2FudCB0byB0dXJuIGl0IG9mZiBhZnRlcndhcmRzLiBT
b21lYm9keSBhd2FyZSBvZiBzdWNoIGxpbWl0YXRpb24gY2FuIHNpbXBseQ0KYXZvaWQgYXNzaWdu
aW5nIGRldmljZSB3LyBub24tY29oZXJlbnQgRE1BIGluIFZNIGNvbmZpZyBmaWxlIGluc3RlYWQg
b2YgDQpmdXJ0aGVyIGdvaW5nIHRvIHRvZ2dsZSB0aGUgbW9kdWxlIHBhcmFtZXRlciB0byBwcmV2
ZW50IHNvbWV0aGluZyB3aGljaA0KaGUgYWxyZWFkeSBrbm93cyBub3QgdG8gZG8uDQoNCj4gDQo+
ID4gQW5vdGhlciBwb2ludCB0byBjb25zaWRlcjogS1ZNIGlzIF9hbHdheXNfIHBvdGVudGlhbGx5
IGJyb2tlbiBvbiBzdWNoDQo+IENQVXMsIGFzDQo+ID4gS1ZNIGZvcmNlcyBXQiBmb3IgZ3Vlc3Qg
YWNjZXNzZXMuICBJLmUuIEtWTSB3aWxsIGNyZWF0ZSBtZW1vcnkgYWxpYXNpbmcgaWYNCj4gdGhl
DQo+ID4gaG9zdCBoYXMgZ3Vlc3QgbWVtb3J5IG1hcHBlZCBhcyBub24tV0IgaW4gdGhlIFBBVCwg
d2l0aG91dCBub24tDQo+IGNvaGVyZW50IERNQQ0KPiA+IGV4cG9zZWQgdG8gdGhlIGd1ZXN0Lg0K
PiBJbiB0aGlzIGNhc2UsIG1lbW9yeSBhbGlhc2luZyBtYXkgb25seSBsZWFkIHRvIGd1ZXN0IG5v
dCBmdW5jdGlvbiB3ZWxsLCBzaW5jZQ0KPiBndWVzdCBpcyBub3QgdXNpbmcgV0MvVUMgKHdoaWNo
IGNhbiBieXBhc3MgaG9zdCBpbml0aWFsaXphdGlvbiBkYXRhIGluIGNhY2hlKS4NCj4gQnV0IGlm
IGd1ZXN0IGhhcyBhbnkgY2hhbmNlIHRvIHJlYWQgaW5mb3JtYXRpb24gbm90IGludGVuZGVkIHRv
IGl0LCBJIGJlbGlldmUNCj4gd2UgbmVlZCB0byBmaXggaXQgYXMgd2VsbC4NCg0KSGF2aW5nIGNh
Y2hlL21lbW9yeSBpbmNvbnNpc3RlbnQgY291bGQgaHVydCBib3RoIGd1ZXN0IGFuZCBob3N0Lg0K
DQpTbyBpbiBjb25jZXB0IGZvcmNpbmcgV0IgaW5zdGVhZCBvZiBmb2xsb3dpbmcgaG9zdCBhdHRy
aWJ1dGUgb24gc3VjaCBDUFVzDQppcyBraW5kIG9mIGJyb2tlbiwgdGhvdWdoIGluIHJlYWxpdHkg
d2UgbWF5IG5vdCBzZWUgYW4gdXNhZ2Ugb2YgZXhwb3NpbmcNCm5vbi1XQiBtZW1vcnkgdG8gZ3Vl
c3Qgb24gdGhvc2Ugb2xkIHNldHVwcyBhcyBkaXNjdXNzZWQgZm9yIHZpcnRpby1ncHUgY2FzZS4N
Cg0KPiANCj4gDQo+ID4gPiA+IEkgd291bGQgYmUgcXVpdGUgc3VycHJpc2VkIGlmIHRoZXJlIGFy
ZSBwZW9wbGUgcnVubmluZyB1bnRydXN0ZWQNCj4gd29ya2xvYWRzDQo+ID4gPiA+IG9uIDEwKyB5
ZWFyIG9sZCBzaWxpY29uICphbmQqIGhhdmUgcGFzc3Rocm91Z2ggZGV2aWNlcyBhbmQgbm9uLQ0K
PiBjb2hlcmVudA0KPiA+ID4gPiBJT01NVXMvRE1BLg0KPiBXaGF0IGlmIHRoZSBndWVzdCBpcyBh
IHRvdGFsbHkgbWFsaWNpb3VzIG9uZT8NCj4gUHJldmlvdXNseSB3ZSB0cnVzdCB0aGUgZ3Vlc3Qg
aW4gdGhlIGNhc2Ugb2Ygbm9uY29oZXJlbnQgRE1BIGlzIGJlY2F1c2UNCj4gd2UgYmVsaWV2ZSBh
IG1hbGljaW91cyBndWVzdCB3aWxsIG9ubHkgbWVldCBkYXRhIGNvcnJ1cHRpb24gYW5kIHNob290
IGhpcw0KPiBvd24NCj4gZm9vdC4NCj4gDQo+IEJ1dCBhcyBKYXNvbiByYWlzZWQgdGhlIHNlY3Vy
aXR5IHByb2JsZW0gaW4gYW5vdGhlciBtYWlsIHRocmVhZCBbMV0sDQo+IHRoaXMgd2lsbCBleHBv
c2Ugc2VjdXJpdHkgaG9sZSBpZiBDUFVzIGhhdmUgbm8gc2VsZi1zbm9vcC4gU28sIHdlIG5lZWQN
Cj4gdG8gZml4IGl0LCByaWdodD8NCj4gKyBKYXNvbiwgaW4gY2FzZSBJIGRpZG4ndCB1bmRlcnN0
YW5kIHRoaXMgcHJvYmxlbSBjb3JyZWN0bHkuDQo+IA0KPiBbMV0gaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvYWxsLzIwMjQwMTA4MTUzODE4LkdLNTA0MDZAbnZpZGlhLmNvbS8NCg0KV2UnbGwgY2Vy
dGFpbiBmaXggdGhlIHNlY3VyaXR5IGhvbGUgb24gQ1BVcyB3LyBzZWxmLXNub29wLiBJbiB0aGlz
IGNhc2UNCkNQVSBhY2Nlc3NlcyBhcmUgZ3VhcmFudGVlZCB0byBiZSBjb2hlcmVudCBhbmQgdGhl
IHZ1bG5lcmFiaWxpdHkgY2FuDQpvbmx5IGJlIGV4cG9zZWQgdmlhIG5vbi1jb2hlcmVudCBETUEg
d2hpY2ggaXMgc3VwcG9zZWQgdG8gYmUgZml4ZWQNCmJ5IHlvdXIgY29taW5nIHNlcmllcy4gDQoN
CkJ1dCBmb3Igb2xkIENQVXMgdy9vIHNlbGYtc25vb3AgdGhlIGhvbGUgY2FuIGJlIGV4cGxvaXRl
ZCB1c2luZyBlaXRoZXIgQ1BVDQpvciBub24tY29oZXJlbnQgRE1BIG9uY2UgdGhlIGd1ZXN0IFBB
VCBpcyBob25vcmVkLiBBcyBsb25nIGFzIG5vYm9keQ0KaXMgd2lsbGluZyB0byBhY3R1YWxseSBm
aXggdGhlIENQVSBwYXRoIChpcyBpdCBwb3NzaWJsZT8pIEknbSBraW5kIG9mIGNvbnZpbmNlZA0K
YnkgU2VhbiB0aGF0IHN1c3RhaW5pbmcgdGhlIG9sZCBiZWhhdmlvciBpcyBwcm9iYWJseSB0aGUg
YmVzdCBvcHRpb24uLi4NCg==

