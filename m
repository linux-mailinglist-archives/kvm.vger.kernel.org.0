Return-Path: <kvm+bounces-47203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3142FABE859
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 01:58:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C35A916888D
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 23:58:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 305AC25F7AC;
	Tue, 20 May 2025 23:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ljkggcda"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29A121147B;
	Tue, 20 May 2025 23:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747785490; cv=fail; b=nMOCF/A4c5R5GZ0xyuVMQuyAZPZIFVlvzySvbHyWiU2uAMgITlfZeOmxY+DyDcQD4LLqIMwNr7ut3mh5D9BuU5S+SOXqpH/D++bnNOj807QloRKkKf4jCtMZgJ8AuVnRnDKg0CqhYPJj5flr3BsvcHl2imjt0iKvAkLFnL6bSWc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747785490; c=relaxed/simple;
	bh=j8aUMa96LIuP5zs87veqww/7DkdE6qJYyB4B/lnurZI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SCb5APXmKDGXohaYp/KiqE4X3D9WPe8N4h/Jc6f/wcHcMz61N7gTuxplSndajSSOKXAs4Do4sxSSc1W653Uwt0KOzQEzNL+roO0zKvv3kJRYc5NjYcAIRe9gwaoOY59euAm9T3J91iIDCYvddlId8u6KOYt/yy8c1hKjw1eTU0s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ljkggcda; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747785488; x=1779321488;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=j8aUMa96LIuP5zs87veqww/7DkdE6qJYyB4B/lnurZI=;
  b=LjkggcdazYNNMtFpa+a/hiq5BQdmSViCrKchie12qHCB5oq1kB5S7pVd
   7jpjOohhqqTQaJAg7ZMI3m4Y2s5vpp8td3HeFTxp9/0Ho47bfJ7CMuwZU
   pqDGfJUNNsSawAOSBqgXmICR+W/fAl1GMyoX0R0aQ94XOyEsrmqBP3Ekh
   zbg+iKU/uAUwuVMVcCieByQn7MADO3Z+fjCMgjn2QuvYex5k9S5kG9E4k
   6ZuYyEU72e6hPbjScMG7FQkptllJeq58LSRIGh9shnoy6KCTDS3h4EtWr
   qXjmonGsvn3bobzmG76RavTUsRmUDScUjdBhoVcV6YLaN9GpXJB3lMIvW
   A==;
X-CSE-ConnectionGUID: cjkrRmkWR6yGn0IjccDmpA==
X-CSE-MsgGUID: 8H+cBxsuTSipq7NwU3lgtA==
X-IronPort-AV: E=McAfee;i="6700,10204,11439"; a="49617960"
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="49617960"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 16:58:04 -0700
X-CSE-ConnectionGUID: UfaIWWlqTmSL1AeAYxEi6A==
X-CSE-MsgGUID: 1Cr8FzvRQ9afAPxg4fOvZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="139751935"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 16:58:03 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 20 May 2025 16:58:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 20 May 2025 16:58:03 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 20 May 2025 16:58:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=flQSywYr6LDX24venzpj+WTGpnbC1e2bzCuY+uDg2DcXL7YZkkTij57vPxHD/2MWvjsV9y5aqaNo1xLB+vBDnoU43N3bk2PSytdQAx4SWZ6CIZtrCDOg+teynW3HQE0HKrRkG8FVZ+YfayzRha2IIYYfVAl8y9/cUkTanrABVIzbvDGAYGtxs+dc5zF96G/3kfwKdb4cFmUl80HZch1mTrPg+d6xJUQXpQBCNDKDBuICznGwAHb5DkafspZBcSnHUMY0TbzVd+MbDr/f3jUHO/AATKrGvwVd12jUgs2X/RoBSG8nTUHFcX17P1Q7c6sDhPYo2wWok7CSa0SjXZ0JIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j8aUMa96LIuP5zs87veqww/7DkdE6qJYyB4B/lnurZI=;
 b=gM/PSDhnGs8yo7LhiVdO2jjeMdxTZNMytNkgcEik7Dps4Vl0W6mfLj4neIf3mfpvcs5Dox5/3Dwz7TPP8SFp2rK4ZCbCLHWbcMZdP+BU+SPKthdfUGorJ78YCbV1zT2KLtYWwmnQI6o2PmvBdjPxPCRdURHzNc4AK+WYFriCpo86vTAP4QabTOhuz2wtNjuEDSoxyC5GRipLW0pkU1jvj3iTISBg07NEqpcHyGKer5EMGhV8IXaadnq3HGb0lQbodstV9ZDkusyZFPkxgDw+IYFCxO2JbaEz6HJUh0xQKbC/0ctrjuAawfI743P8a55OtfMxCmTtNZ3Dfsp+dZkjfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA3PR11MB8118.namprd11.prod.outlook.com (2603:10b6:806:2f1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Tue, 20 May
 2025 23:57:32 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8746.031; Tue, 20 May 2025
 23:57:32 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "vipinsh@google.com" <vipinsh@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] KVM: x86: Use kvzalloc() to allocate VM struct
Thread-Topic: [PATCH v3 2/3] KVM: x86: Use kvzalloc() to allocate VM struct
Thread-Index: AQHbxq0+OB9mwly9vEqEwiQpLwdhbLPWwyGAgANXzYCAAgqsAIAABhSAgAAM2QA=
Date: Tue, 20 May 2025 23:57:32 +0000
Message-ID: <5546ad0e36f667a6b426ef47f1f40aee8d83efc9.camel@intel.com>
References: <20250516215422.2550669-1-seanjc@google.com>
	 <20250516215422.2550669-3-seanjc@google.com>
	 <219b6bd5-9afe-4d1c-aaab-03e5c580ce5c@redhat.com>
	 <aCtQlanun-Kaq4NY@google.com>
	 <dca247173aace1269ce8512ae2d3797289bb1718.camel@intel.com>
	 <aC0MIUOTQbb9-a7k@google.com>
In-Reply-To: <aC0MIUOTQbb9-a7k@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA3PR11MB8118:EE_
x-ms-office365-filtering-correlation-id: 37fe306a-7ae2-46e4-5170-08dd97fa1625
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WEh2c1dnNktERTJwNXF2VTVnNHd3WUJwMjFsSmZuTzM0S1drUWVRd3VEYWJS?=
 =?utf-8?B?bnlqazFpc0l5TWhZY01IWURaZ1ZzZ3hmRVZtUVd2YWl4VVJWSHZ5eEdJVnpj?=
 =?utf-8?B?ZmhCU1lZNmk5Njdwdk1xTit0OWdScEp4bFRuY1RYZjFIZXYrWkwyUlVYSFJv?=
 =?utf-8?B?TWpuOVBrTmJNTWhLZlZ4RlZxNW5qWFpZdWJQTDExd2RoZjJCc3NtNGhpNHEv?=
 =?utf-8?B?YjZCK0dGbVFGUHgrZEJTRHp4TnRBVGxmeUdXUUQ0bWQvQXRBT2JUWkJpVTNp?=
 =?utf-8?B?SU9zUWhUc0ZMNjFKd212VTUvYzhyRVVod05aYjE1SDZuMFE3MTljSk05M3Rn?=
 =?utf-8?B?OVlEVlBGbFVwL0haaDFSTUZrZGlqY1lReTlSV204MlRDdzNmaE5nTzZTNklV?=
 =?utf-8?B?TVNnbEgwMU5UWHBkdVZ2aS90OHhCQUhlZXo1VGFhQVJtdjRpa0NuUTI0bm5x?=
 =?utf-8?B?UWhtVzUrT1VUTzhiNUIwcXVWS2ZjY0lPc01zaEdrUXp2c2M3TWp2OWxrVEJP?=
 =?utf-8?B?aXAwcjAxOTVDSlRiRE04SEk1bmpxcWhLZUJQVDdML0E4ZW50ZU1GbkR5dzZO?=
 =?utf-8?B?MGFYanJyZXNvL0xFZzJjcDQwNnpiTnhXRzRuc0hqdGczSUx0SzRtZDVoWVZh?=
 =?utf-8?B?OTF3N1k4LzJROUFMTU5welcyQnZHdTduS2p6dHA0Y1NEQzJweFJUV056SERX?=
 =?utf-8?B?ayt5VlVWS0d1OWFDTmw2bEV2RTAzQTMwMVU4VWpQQTZDYU8vQ3F0eG9PQzVp?=
 =?utf-8?B?OTZNL2ZidFJhajJpNkFSNG02TUY0anorQ3F5Y3RnRUJYekpoczlPTGQyMUlG?=
 =?utf-8?B?TnZlcjgySFJGZTVtNGZIaVg4c0hHTTcwT0Mzd0JYcWNZcWZRV0VFT3Vsc2dv?=
 =?utf-8?B?VmZBMDdBVDR3NmFURUJXOXNqSzNTcEY4RWpGVHhIbG9weVgrbE1mMU1vM2ZZ?=
 =?utf-8?B?dDIyODRhWmtjWTliTDVtU0dWa3FpeG9kY25OYW96SC9JL2FrNTJzR3JpSmNX?=
 =?utf-8?B?bFB1S2dKM0dCR2FabFBPVG9IK3V4S2FFbkh4R1BxZVlhTWRDZUJ6UXlnQ2N3?=
 =?utf-8?B?S05FR2NMU2RVQ2VLbnIybXZiWTFaODg1a2dFOUtTM3ZCNmF3SVdha3ZMN3pt?=
 =?utf-8?B?R2NwRHc1bVFLRGxUNjJyREdCZlRPeHpqOVdhL0M1U3FlbitxRS9GcFFPL25a?=
 =?utf-8?B?NzJVN1RZelFUZktkTEczb0VIeWVzekFIYnJVL0srYVIxRkJUckVoQVp0Tkdy?=
 =?utf-8?B?OE9RZTN6cnFWYkE1RTJwNC9zU0xvK2puMTZobGJzb3JVZm0wY0tVSFFZaDdp?=
 =?utf-8?B?OGNMd3JaODRQZEMyQ2Q5NE5vdWpIMVpRM1FjSVNrT0RueDNQVW1DYWlYckVF?=
 =?utf-8?B?SThNSU1GYlZlSE9TS1ZOWCtuVnVHakp6dXlyNVhDZlZXYVlXVEFCNW1SN1h5?=
 =?utf-8?B?RjhNbStvaEdma05TankrU2krMnh3alR3NmVZbmd2aDlhL3h3VjJiUzZCQjdz?=
 =?utf-8?B?WmN4c0ZsRlkrcVY0cDA0SDQ2ZlN2L3JMUDc0Mkl6cE9XaGxCd3hadlJ2TVl4?=
 =?utf-8?B?WlpGRUE3WDQwUEltelJWU1BLUm0wa2IybDdnWm9nMTNKMUM5a2lBbXNBa1pp?=
 =?utf-8?B?QlE0RitMSTlrTlZnbHJIWmJQSmtFcFY0ekdiY0dUOHphQkZrMWVTSUJSdFYz?=
 =?utf-8?B?VzkxamFvb0dvUzhWdkNXbWxYUlUwQ3NFOUNFZGpwS29OeXZNVjZLSnBrNUpY?=
 =?utf-8?B?L0UwLzhjcjF3NWFFSER6VXBITStDa2VkSm5KeGN2NFRXZ3krdGdxMk5WdEEz?=
 =?utf-8?B?VlBDMEV5TWhTMFJWQVRsa1k3OWphamZ5YjQ1eTM2eTBGVWZhdXBtaU04WDJK?=
 =?utf-8?B?Y2ViaWJaOE02ZEl0cE9XeXMyeVV2V3V0ekZVQ2JUNThGbUx2OFN3enJ4L2VT?=
 =?utf-8?B?RmFyeFhrTlcwVUd6UmhKUy9NSG9ic1NOR0VpRnV5cllmQ3I1VlpiZUVoa2NM?=
 =?utf-8?B?ZVB0SEtVb0ZRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NEpGL0tUN1k3ZW9qcnhldXdEaGJtTmE0V1B2dXdtV0RVcnQ0MytWcHFHdDhP?=
 =?utf-8?B?MDFGaHRhWDMvNE9mRWxhd201OTlNVDZkU1NRRE9DR3lBb29tTXVJa0pSZjF3?=
 =?utf-8?B?SzNEaVhJSEVNdXIxRVRkMnl3cTFqMEZCYWdmR0JVZnMvRklzUjFaUzFuZTU5?=
 =?utf-8?B?NzVmanozY2ZLc0cybWlsMmJLR0xhYW80SVZuckZzdmYveVgzbUtINWNLbzhG?=
 =?utf-8?B?ZzA1ZVB5WlhjeGFYaG1DQ2R0Mmtlc2R6WDAvVmthcU4yY1llS3NsK2RnM0ZG?=
 =?utf-8?B?WUp1SEVBNG45U3dNdWxqWHdJaTRFOEhDeGpsQk5rRSs0UkNIQk9mUG9zSDhY?=
 =?utf-8?B?RjcwaGxVMEdxbElJWXV4MW5kL3pmdGZxSVJjQkxDNXZJUFFuZE5mRE5wSVBE?=
 =?utf-8?B?Y3M4M2w4MDZWaFJxTkRGSVdjc2d6M25tWmx0bFpKUFNyWFg5WDVDck1sZmlS?=
 =?utf-8?B?UXpLeFpjY1lIVEFQMGxVdmtlRUQ2MUhWYU1OMjdrWDBNRGZJSnZ2NzNLMitY?=
 =?utf-8?B?UUxyQ1QvQlUvejdva0FMMWpkSk1ySTdHbWZ5eXVOZk1DOS9qeEMyQld0a1Zo?=
 =?utf-8?B?YmYvNmJEY1FOK3pBRUNrTlh3aldvSmExdzhwUGdQVTQxM2RNdWdObEFjb2hs?=
 =?utf-8?B?TGQzbEk3ZkNNWWluOGVFVkYyV3JkMFdITkFOL0J6TjRzaU5XVzg3alh3ZFlD?=
 =?utf-8?B?anBDTUNvN3RJaVJSajBtRHE3akFNZ2gwdnliWVY4R0ZkUXZ4VnJ0SnZYT0Rr?=
 =?utf-8?B?SGlHTVRvdC84bGNJRm1wZnh6UlRITHg4UTZQZmpsOUZwTE14LzhXY2w0NEVn?=
 =?utf-8?B?NGJtWlUxL2l6NmlFc1BqVlpnVjJLc012SzkyMVZCREY2OVZxaFJoUkRObDJT?=
 =?utf-8?B?Wkw4L2hsZVVPNzRyUWFxMUd1QzRQanp0eXQzd05ZejJZY2N0SEFCbzN2dWYx?=
 =?utf-8?B?Rk1TVlV6MDNDbU9TS1NnZTVEbGsxTEY2a1VNNmNEODkvTWYxbWo3RnJZaERF?=
 =?utf-8?B?OFRUa1B2MURzZnptYVoxWG1xNFJkZmFGUjdHODhrY0l3NmVHNTRXRS9tZjVY?=
 =?utf-8?B?R3hTUnV6R0dyeXUzblVlNmJ3WVgzTTNiYTJudFpRTFRMTUM2NnExMkplMnZF?=
 =?utf-8?B?MEUrZDY4OXRnVUpnRFhtWWNUek5GRE5IZ3oxVVZpWm9zSWhONzBxbE5ESnp1?=
 =?utf-8?B?NnNHQTNNdEljVzF6TnorQTE3ZXFOeGNVa1ZUcXJtRWdWK0pGTHpwbWdodUVM?=
 =?utf-8?B?MGRHQllnOG1WWkx5YVpISUtOeHVHbUtRSHBuZ20yaGxXTXFUemt6OEcvRkdD?=
 =?utf-8?B?clJURFJpaUwzS3JES251SS94V0p2L3dFclJMVyszS1ZQL0F2Z3A3Unp1V1hR?=
 =?utf-8?B?QmdHNXd3eW9uT29BQ3ErL2dpcnNkbE9LRS9ycHM1OTE2SUh0bUMra1k1aThJ?=
 =?utf-8?B?TDVTUGhGcEEvWkFnVXU1a0tyQUd3T25QZVRwVlNacEFPSnNYaHVOanRYZlB1?=
 =?utf-8?B?MVZ2cVpnNFZheU5YMXpyVXF2S0tpeDBxdy9OSlF5TVJWRXJkL1ZYSHhDR2ZZ?=
 =?utf-8?B?OW5lWjZ6QjRkYTBKZW5sa3J0cjlWVjl1NHVLZUlZSGVKWGpGclUxcGhZbmx3?=
 =?utf-8?B?QXJwM09SaS9MUk1qMWl6c1hxaTlkWlhxNVhSWDFYYkk4QmNvbi9DOU83ZGVs?=
 =?utf-8?B?S3ozN1NZdkxyc0NtNVR1aG1QKytNMVBQdXQ5Z1ZRMnFWOFBoditvT01lRCs3?=
 =?utf-8?B?ZzhEdWtuajYvYXRTdVZvSTBwSEpuRUdPdkNWWHJjS2owL3d4R0krZThjTzd4?=
 =?utf-8?B?QlVGMElFZmlOcW53ckFiaUtTaktRbnFUTkhBVWhuOFFybnJIa3ZCWjdibjM4?=
 =?utf-8?B?Q3Y5WFdyL0x1WHlJT0d5QkhkeUNzeVI0amhlOEdoMWFKQVV5OVErSWtyTGxX?=
 =?utf-8?B?a2cxdzA1M1ptY2JXZStqNDRQRUhaOEZJUGpLNGF5Vm1rdk9PM1hucWxIWDBV?=
 =?utf-8?B?WW1ybXExZU1xdm96MjhYR01MVUYwWUtjOUxCb2c3RW1CUUhKRURVN0I0V3p0?=
 =?utf-8?B?d0sxaUJkQnZJYlU4d0ZHVlJkSDA5WkMyTGNySVRMblpObFZsNzBYSEcvc3gy?=
 =?utf-8?Q?1l7ZgPFyGPpncr3SloRv5i7oG?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0857547545078645876FB51721F3EB8F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37fe306a-7ae2-46e4-5170-08dd97fa1625
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2025 23:57:32.5433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VJFzp31w2i/K3vaQGTrs6LO9NyRxnuPyCfFz/dRtS65ExRNdMuFHudQa+raV2d5m9jQh9amNNnts5/AAXOhEcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8118
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA1LTIwIGF0IDE2OjExIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIE1heSAyMCwgMjAyNSwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIE1v
biwgMjAyNS0wNS0xOSBhdCAwODozOSAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+ICtzdGF0aWMgaW50IHRkeF9zZXB0X3JlbW92ZV9wcml2YXRlX3NwdGUoc3RydWN0IGt2
bSAqa3ZtLCBnZm5fdCBnZm4sDQo+ID4gPiArCQkJCQllbnVtIHBnX2xldmVsIGxldmVsLCBrdm1f
cGZuX3QgcGZuKQ0KPiA+ID4gIHsNCj4gPiA+ICAJc3RydWN0IHBhZ2UgKnBhZ2UgPSBwZm5fdG9f
cGFnZShwZm4pOw0KPiA+ID4gIAlpbnQgcmV0Ow0KPiA+ID4gQEAgLTM1MDcsMTAgKzM1MDcsMTQg
QEAgaW50IF9faW5pdCB0ZHhfYnJpbmd1cCh2b2lkKQ0KPiA+ID4gIAlyID0gX190ZHhfYnJpbmd1
cCgpOw0KPiA+ID4gIAlpZiAocikgew0KPiA+ID4gIAkJLyoNCj4gPiA+IC0JCSAqIERpc2FibGUg
VERYIG9ubHkgYnV0IGRvbid0IGZhaWwgdG8gbG9hZCBtb2R1bGUgaWYNCj4gPiA+IC0JCSAqIHRo
ZSBURFggbW9kdWxlIGNvdWxkIG5vdCBiZSBsb2FkZWQuICBObyBuZWVkIHRvIHByaW50DQo+ID4g
PiAtCQkgKiBtZXNzYWdlIHNheWluZyAibW9kdWxlIGlzIG5vdCBsb2FkZWQiIGJlY2F1c2UgaXQg
d2FzDQo+ID4gPiAtCQkgKiBwcmludGVkIHdoZW4gdGhlIGZpcnN0IFNFQU1DQUxMIGZhaWxlZC4N
Cj4gPiA+ICsJCSAqIERpc2FibGUgVERYIG9ubHkgYnV0IGRvbid0IGZhaWwgdG8gbG9hZCBtb2R1
bGUgaWYgdGhlIFREWA0KPiA+ID4gKwkJICogbW9kdWxlIGNvdWxkIG5vdCBiZSBsb2FkZWQuICBO
byBuZWVkIHRvIHByaW50IG1lc3NhZ2Ugc2F5aW5nDQo+ID4gPiArCQkgKiAibW9kdWxlIGlzIG5v
dCBsb2FkZWQiIGJlY2F1c2UgaXQgd2FzIHByaW50ZWQgd2hlbiB0aGUgZmlyc3QNCj4gPiA+ICsJ
CSAqIFNFQU1DQUxMIGZhaWxlZC4gIERvbid0IGJvdGhlciB1bndpbmRpbmcgdGhlIFMtRVBUIGhv
b2tzIG9yDQo+ID4gPiArCQkgKiB2bV9zaXplLCBhcyBrdm1feDg2X29wcyBoYXZlIGFscmVhZHkg
YmVlbiBmaW5hbGl6ZWQgKGFuZCBhcmUNCj4gPiA+ICsJCSAqIGludGVudGlvbmFsbHkgbm90IGV4
cG9ydGVkKS4gIFRoZSBTLUVQVCBjb2RlIGlzIHVucmVhY2hhYmxlLA0KPiA+ID4gKwkJICogYW5k
IGFsbG9jYXRpbmcgYSBmZXcgbW9yZSBieXRlcyBwZXIgVk0gaW4gYSBzaG91bGQtYmUtcmFyZQ0K
PiA+ID4gKwkJICogZmFpbHVyZSBzY2VuYXJpbyBpcyBhIG5vbi1pc3N1ZS4NCj4gPiA+ICAJCSAq
Lw0KPiA+ID4gIAkJaWYgKHIgPT0gLUVOT0RFVikNCj4gPiA+ICAJCQlnb3RvIHN1Y2Nlc3NfZGlz
YWJsZV90ZHg7DQo+ID4gPiBAQCAtMzUyNCwzICszNTI4LDE5IEBAIGludCBfX2luaXQgdGR4X2Jy
aW5ndXAodm9pZCkNCj4gPiA+ICAJZW5hYmxlX3RkeCA9IDA7DQo+ID4gPiAgCXJldHVybiAwOw0K
PiA+ID4gIH0NCj4gPiA+ICsNCj4gPiA+ICsNCj4gPiA+ICt2b2lkIF9faW5pdCB0ZHhfaGFyZHdh
cmVfc2V0dXAodm9pZCkNCj4gPiA+ICt7DQo+ID4gPiArCS8qDQo+ID4gPiArCSAqIE5vdGUsIGlm
IHRoZSBURFggbW9kdWxlIGNhbid0IGJlIGxvYWRlZCwgS1ZNIFREWCBzdXBwb3J0IHdpbGwgYmUN
Cj4gPiA+ICsJICogZGlzYWJsZWQgYnV0IEtWTSB3aWxsIGNvbnRpbnVlIGxvYWRpbmcgKHNlZSB0
ZHhfYnJpbmd1cCgpKS4NCj4gPiA+ICsJICovDQo+ID4gDQo+ID4gVGhpcyBjb21tZW50IHNlZW1z
IGEgbGl0dGxlIGJpdCB3ZWlyZCB0byBtZS4gIEkgdGhpbmsgd2hhdCB5b3UgbWVhbnQgaGVyZSBp
cyB0aGUNCj4gPiBAdm1fc2l6ZSBhbmQgdGhvc2UgUy1FUFQgb3BzIGFyZSBub3QgdW53b3VuZCB3
aGlsZSBURFggY2Fubm90IGJlIGJyb3VnaHQgdXAgYnV0DQo+ID4gS1ZNIGlzIHN0aWxsIGxvYWRl
ZC4NCj4gDQo+IFRoaXMgY29tbWVudCBpcyB3ZWlyZD8gIE9yIHRoZSBvbmUgaW4gdGR4X2JyaW5n
dXAoKSBpcyB3ZWlyZD8gwqANCj4gDQoNCkkgZGVmaW5pdGVseSBhZ3JlZSB0ZHhfYnJpbmd1cCgp
IGlzIHdlaXJkIDotKQ0KDQo+IFRoZSBzb2xlIGludGVudA0KPiBvZiBfdGhpc18gY29tbWVudCBp
cyB0byBjbGFyaWZ5IHRoYXQgS1ZNIGNvdWxkIHN0aWxsIGVuZCB1cCBydW5uaW5nIGxvYWQgd2l0
aCBURFgNCj4gZGlzYWJsZWQuIMKgDQo+IA0KDQpCdXQgdGhpcyBiZWhhdmlvdXIgaXRzZWxmIGRv
ZXNuJ3QgbWVhbiBhbnl0aGluZywgZS5nLiwgaWYgd2UgZXhwb3J0IGt2bV94ODZfb3BzLA0Kd2Ug
Y291bGQgdW53aW5kIHRoZW0uICBTbyB3aXRob3V0IG1lbnRpb25pbmcgInRob3NlIGFyZSBub3Qg
dW53b3VuZCIsIGl0IGRvZXNuJ3QNCnNlZW0gdXNlZnVsIHRvIG1lLg0KDQpCdXQgaXQgZG9lcyBo
YXZlICIoc2VlIHRkeF9icmluZ3VwKCkpIiBhdCB0aGUgZW5kLCBzbyBPSyB0byBtZS4gIEkgZ3Vl
c3MgSSBqdXN0DQp3aXNoIGl0IGNvdWxkIGJlIG1vcmUgdmVyYm9zZS4NCg0KPiBUaGUgY29tbWVu
dCBhYm91dCBub3QgdW53aW5kaW5nIFMtRVBUIHJlc2lkZXMgaW4gdGR4X2JyaW5ndXAoKSwgYmVj
YXVzZQ0KPiB0aGF0J3Mgd2hlcmUgdGhlIGFjdHVhbCBkZWNpc2lvbiB0byBub3QgcmVqZWN0IEtW
TSBsb2FkIGFuZCB0byBub3QgdW5kbyB0aGUgc2V0dXANCj4gbGl2ZXMuDQoNClJpZ2h0Lg0KDQo+
IA0KPiA+ID4gKw0KPiA+ID4gKwl2dF94ODZfb3BzLmxpbmtfZXh0ZXJuYWxfc3B0ID0gdGR4X3Nl
cHRfbGlua19wcml2YXRlX3NwdDsNCj4gPiA+ICsJdnRfeDg2X29wcy5zZXRfZXh0ZXJuYWxfc3B0
ZSA9IHRkeF9zZXB0X3NldF9wcml2YXRlX3NwdGU7DQo+ID4gPiArCXZ0X3g4Nl9vcHMuZnJlZV9l
eHRlcm5hbF9zcHQgPSB0ZHhfc2VwdF9mcmVlX3ByaXZhdGVfc3B0Ow0KPiA+ID4gKwl2dF94ODZf
b3BzLnJlbW92ZV9leHRlcm5hbF9zcHRlID0gdGR4X3NlcHRfcmVtb3ZlX3ByaXZhdGVfc3B0ZTsN
Cj4gPiA+ICsJdnRfeDg2X29wcy5wcm90ZWN0ZWRfYXBpY19oYXNfaW50ZXJydXB0ID0gdGR4X3By
b3RlY3RlZF9hcGljX2hhc19pbnRlcnJ1cHQ7DQo+ID4gPiArfQ0KPiA+ID4gZGlmZiAtLWdpdCBh
L2FyY2gveDg2L2t2bS92bXgvdGR4LmggYi9hcmNoL3g4Ni9rdm0vdm14L3RkeC5oDQo+ID4gPiBp
bmRleCA1MWY5ODQ0M2U4YTIuLmNhMzlhOTM5MWRiMSAxMDA2NDQNCj4gPiA+IC0tLSBhL2FyY2gv
eDg2L2t2bS92bXgvdGR4LmgNCj4gPiA+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmgNCj4g
PiA+IEBAIC04LDYgKzgsNyBAQA0KPiA+ID4gICNpZmRlZiBDT05GSUdfS1ZNX0lOVEVMX1REWA0K
PiA+ID4gICNpbmNsdWRlICJjb21tb24uaCINCj4gPiA+ICANCj4gPiA+ICt2b2lkIHRkeF9oYXJk
d2FyZV9zZXR1cCh2b2lkKTsNCj4gPiA+ICBpbnQgdGR4X2JyaW5ndXAodm9pZCk7DQo+ID4gPiAg
dm9pZCB0ZHhfY2xlYW51cCh2b2lkKTsNCj4gPiA+ICANCj4gPiANCj4gPiBUaGVyZSdzIGEgYnVp
bGQgZXJyb3Igd2hlbiBDT05GSUdfS1ZNX0lOVEVMX1REWCBpcyBvZmY6DQo+ID4gDQo+ID4gdm14
L21haW4uYzogSW4gZnVuY3Rpb24g4oCYdnRfaGFyZHdhcmVfc2V0dXDigJk6DQo+ID4gdm14L21h
aW4uYzozNDoxNzogZXJyb3I6IGltcGxpY2l0IGRlY2xhcmF0aW9uIG9mIGZ1bmN0aW9uIOKAmHRk
eF9oYXJkd2FyZV9zZXR1cOKAmTsNCj4gPiBkaWQgeW91IG1lYW4g4oCYdm14X2hhcmR3YXJlX3Nl
dHVw4oCZPyBbLVdpbXBsaWNpdC1mdW5jdGlvbi1kZWNsYXJhdGlvbl0NCj4gPiAgICAzNCB8ICAg
ICAgICAgICAgICAgICB0ZHhfaGFyZHdhcmVfc2V0dXAoKTsNCj4gPiAgICAgICB8ICAgICAgICAg
ICAgICAgICBefn5+fn5+fn5+fn5+fn5+fn4NCj4gPiAgICAgICB8ICAgICAgICAgICAgICAgICB2
bXhfaGFyZHdhcmVfc2V0dXANCj4gPiANCj4gPiAuLiBmb3Igd2hpY2ggeW91IG5lZWQgYSBzdHVi
IGZvciB0ZHhfaGFyZHdhcmVfc2V0dXAoKSB3aGVuIENPTkZJR19LVk1fSU5URUxfVERYDQo+ID4g
aXMgb2ZmLg0KPiANCj4gTm90IGluIGt2bS14ODYvbmV4dCwgY29tbWl0IDkwNzA5MmJmN2NiZCAo
IktWTTogVk1YOiBDbGVhbiB1cCBhbmQgbWFjcm9meSB4ODZfb3BzIikNCj4gYnVyaWVkIGFsbCBv
ZiB2dF9oYXJkd2FyZV9zZXR1cCgpIGJlaGluZCBDT05GSUdfS1ZNX0lOVEVMX1REWD15Lg0KDQpP
aCBJIHdhcyB1c2luZyBrdm0tY29jby1xdWV1ZS4gIFRoYW5rcyBmb3IgcG9pbnRpbmcgb3V0Lg0K
DQo+IA0KPiA+IEFuZCBvbmUgbW9yZSB0aGluZzoNCj4gPiANCj4gPiBXaXRoIHRoZSBhYm92ZSBw
YXRjaCwgd2Ugc3RpbGwgaGF2ZSBiZWxvdyBjb2RlIGluIHZ0X2luaXQoKToNCj4gPiANCj4gPiAg
ICAgICAgIC8qDQo+ID4gICAgICAgICAgKiBURFggYW5kIFZNWCBoYXZlIGRpZmZlcmVudCB2Q1BV
IHN0cnVjdHVyZXMuICBDYWxjdWxhdGUgdGhlDQo+ID4gICAgICAgICAgKiBtYXhpbXVtIHNpemUv
YWxpZ24gc28gdGhhdCBrdm1faW5pdCgpIGNhbiB1c2UgdGhlIGxhcmdlcg0KPiA+ICAgICAgICAg
ICogdmFsdWVzIHRvIGNyZWF0ZSB0aGUga21lbV92Y3B1X2NhY2hlLg0KPiA+ICAgICAgICAgICov
DQo+ID4gICAgICAgICB2Y3B1X3NpemUgPSBzaXplb2Yoc3RydWN0IHZjcHVfdm14KTsNCj4gPiAg
ICAgICAgIHZjcHVfYWxpZ24gPSBfX2FsaWdub2ZfXyhzdHJ1Y3QgdmNwdV92bXgpOw0KPiA+ICAg
ICAgICAgaWYgKGVuYWJsZV90ZHgpIHsNCj4gPiAgICAgICAgICAgICAgICAgdmNwdV9zaXplID0g
bWF4X3QodW5zaWduZWQsIHZjcHVfc2l6ZSwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHNpemVvZihzdHJ1Y3QgdmNwdV90ZHgpKTsNCj4gPiAgICAgICAgICAgICAgICAgdmNw
dV9hbGlnbiA9IG1heF90KHVuc2lnbmVkLCB2Y3B1X2FsaWduLA0KPiA+ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgX19hbGlnbm9mX18oc3RydWN0IHZjcHVfdGR4KSk7DQo+ID4gICAg
ICAgICAgICAgICAgIGt2bV9jYXBzLnN1cHBvcnRlZF92bV90eXBlcyB8PSBCSVQoS1ZNX1g4Nl9U
RFhfVk0pOw0KPiA+ICAgICAgICAgfQ0KPiA+IA0KPiA+IEl0J3Mga2luZGEgdWdseSB0b28gSU1I
Ty4NCj4gPiANCj4gPiBTaW5jZSB3ZSBhbHJlYWR5IGhhdmUgQHZtX3NpemUgaW4ga3ZtX3g4Nl9v
cHMsIGhvdyBhYm91dCBhbHNvIGFkZGluZyB2Y3B1X3NpemUNCj4gPiBhbmQgdmNwdV9hbGlnbiB0
byBpdD8gIFRoZW4gdGhleSBjYW4gYmUgdHJlYXRlZCBpbiB0aGUgc2FtZSB3YXkgYXMgdm1fc2l6
ZSBmb3INCj4gPiBURFguDQo+ID4gDQo+ID4gVGhleSBhcmUgbm90IG5lZWRlZCBmb3IgU1ZNLCBi
dXQgaXQgZG9lc24ndCBodXJ0IHRoYXQgbXVjaD8NCj4gDQo+IEknZCByYXRoZXIgbm90LiAgdnRf
aW5pdCgpIGFscmVhZHkgbmVlZHMgdG8gYmUgYXdhcmUgb2YgVERYLCBlLmcuIHRvIGNhbGwgaW50
bw0KPiB0ZHhfYnJpbmd1cCgpIGluIHRoZSBmaXJzdCBwbGFjZS4gIFNob3Zpbmcgc3RhdGUgaW50
byBrdm1feDg2X29wcyB0aGF0IGlzIG9ubHkNCj4gZXZlciB1c2VkIGluIHZ0X2luaXQoKSAoYW4g
X19pbml0IGZ1bmN0aW9uIGF0IHRoYXQpIGlzbid0IGEgbmV0IHBvc2l0aXZlLg0KPiANCj4gUHV0
dGluZyB0aGUgZmllbGRzIGluIGt2bV94ODZfaW5pdF9vcHMgd291bGQgYmUgYmV0dGVyLCBidXQg
SSBzdGlsbCBkb24ndCB0aGluaw0KPiB0aGUgY29tcGxleGl0eSBhbmQgaW5kaXJlY3Rpb24gaXMg
anVzdGlmaWVkLiAgQmxlZWRpbmcgZ29yeSBURFggZGV0YWlscyBpbnRvIHRoZQ0KPiBjb21tb24g
Y29kZSBpcyB1bmRlc2lyYWJsZSwgYnV0IEkgZG9uJ3Qgc2VlIHRoZSBzaXplIG9mIHZjcHVfdGR4
IG9yIHRoZSBmYWN0IHRoYXQNCj4gZW5hYmxlX3RkeD09dHJ1ZSBtZWFucyBLVk1fWDg2X1REWF9W
TSBpcyBzdXBwb3J0ZWQgYXMgYmVpbmcgaW5mb3JtYXRpb24gd2l0aA0KPiBoaWRpbmcuDQo+IA0K
PiBrdm1feDg2X29wcy52bV9zaXplIGlzIGEgbWVhbnMgdG8gYW4gZW5kLiAgRS5nLiBpZiBrdm1f
dmNwdV9jYWNoZSBkaWRuJ3QgZXhpc3QsDQo+IHRoZW4gd2UnZCBwcm9iYWJseSB3YW50L25lZWQg
a3ZtX3g4Nl9vcHMudmNwdV9zaXplLCBidXQgaXQgZG9lcyBleGlzdCwgc28uLi4NCg0KU3VyZS4g
IFRoYW5rcyBmb3IgY2xhcmlmaWNhdGlvbi4NCg==

