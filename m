Return-Path: <kvm+bounces-50925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B43EFAEABCE
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 02:38:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDE3C1688DB
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 00:38:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A4FA13AC1;
	Fri, 27 Jun 2025 00:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X5ts+M8E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE54259C;
	Fri, 27 Jun 2025 00:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750984673; cv=fail; b=qoZVh9CCc+td4XYJq64njCUghyA667eyum/niJgXCHHHIBsmz1oV2lDKYtry+mz3xRlAR8DgXugWoOM/HalzyRDKB0XTnSaHYAVqf1veMQUUDsbHSMeRTwI3RCS/Io5fm/YZtcNsdHqQBlzlz7eGNlcTCQYlquypZywN5153PE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750984673; c=relaxed/simple;
	bh=8xHec7wGircTVoRyQTMBW42Tit4tNMMQsQ3hR0tXHqY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TOkLUzp7UuYXAOTo9/yIcizplpr6jpGz5DbaURMvycm3AS//MvreIvmXJ9A2OHJJFII4KsawCfcgvPOLu3y3JpFmXa7J/ZvQcdht/qbLw1Ax6GctPLaXPmlTX+SLdncL1/608yqKQdVk0Yk1SwQGxmH1HfSS4f6iD7GxsE8tlMo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X5ts+M8E; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750984671; x=1782520671;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8xHec7wGircTVoRyQTMBW42Tit4tNMMQsQ3hR0tXHqY=;
  b=X5ts+M8EBPyKmzbrAoJNPF7EHuziAmL9dYqZciO1evNJDHT18F5qzmVf
   Jf6ySJD21SdzX7E4qnRouyyw2bZ423e8UbccTzkIYgwd/E4swc8BRp7Fh
   BZHp5P+6UXEcPFULbIXG0MtnDDjUO2jXssF2BpNK+Ces0dgmDjzTcEBel
   b50v/7SuCNxSgeCundJw3cQ4v20bMIVlHaHiKALZI/f2R4FKJx/gKL179
   T4O9HM4gHy9ng8U66kvUkp2WvZm6IVtJftY4/CWoKSN+WGZaS/O/F36pW
   OXdduqTvA8XabHXTSYylEel/ZWec0O4feb/Lqieqb8dt55z8MU/+MqHs9
   w==;
X-CSE-ConnectionGUID: sGAemMEkQkyeBQoxsms5qQ==
X-CSE-MsgGUID: ZnAM/jBmSsa/vvXF4wanug==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="64356158"
X-IronPort-AV: E=Sophos;i="6.16,269,1744095600"; 
   d="scan'208";a="64356158"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 17:37:51 -0700
X-CSE-ConnectionGUID: xTe09AeWQ1Odjd7DED2elg==
X-CSE-MsgGUID: k9ZfnQPrTGecYREoD2PGYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,269,1744095600"; 
   d="scan'208";a="156958217"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 17:37:50 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 17:37:49 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 26 Jun 2025 17:37:49 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.43) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 17:37:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r3swTXmUNpxcKRPfZBCHR6QQMtzf7KNE0aQnpHANy6pgwdRyRlUzFhD6N58heqcyEZutEB71zM9zoNJmYVKZeEtcGykRvbocdxNws6X7rAtRKOHSuL6CCt+Hh7lFLqB5MULcH9sOoHnr7XCDpjWIW72JjZs+GxoTekCvzFwjIWMMl8vyiglTW0oYAzMZWRPn8fkStfdCwWEUzsR6aquQjwu9rM51jRQbBESoG5iroldiv1N7dtTH5o+imvSFUyNk8dsC+Bia9p8+rUC/B9kciqCcRmA1YizKh3etHwn3swpaipWWRfCaNhB07PPiGIX0hYn38eHW4s3/VEeRjFd3hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8xHec7wGircTVoRyQTMBW42Tit4tNMMQsQ3hR0tXHqY=;
 b=OtYEEmWl9obdmRl89qyr2UcPEVrhdDqXMK2Tbeg5RRwr+AxLFxkeNhQ8ex03oL4CgWxw9RzzVBb/GUGKf8ENsItI6Qx8fmbIcIpI2cUHq0GqwuY5qn9MTSFVtF5cDEWVrcA7RzD5wOx9E+Bu+YlXt6mYp7sDjHGHuOCBnU3i79Jxe+W/5coB6wUBsMh6+4tjoHwghgGGi7ThRodpcxLI9RJoNBH/c2J8JMW5FYDyTjHOgpg0i+RWCiXRNAlo5/q2BSHb5j30sa2kb4Qgz/Nae6hgUwflr6gKwrvoBfVbIqu/KDjMrAuKBTObUxMJyEVfoIupcFJwi1TtCx8NUVuWtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CH3PR11MB8546.namprd11.prod.outlook.com (2603:10b6:610:1ae::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Fri, 27 Jun
 2025 00:37:45 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8857.026; Fri, 27 Jun 2025
 00:37:45 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"peterz@infradead.org" <peterz@infradead.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
CC: "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org"
	<x86@kernel.org>, "sagis@google.com" <sagis@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>
Subject: Re: [PATCH v3 1/6] x86/sme: Use percpu boolean to control wbinvd
 during kexec
Thread-Topic: [PATCH v3 1/6] x86/sme: Use percpu boolean to control wbinvd
 during kexec
Thread-Index: AQHb5ob1Aej6jhsWsE288GxQicmcLLQVuwOAgABvTgA=
Date: Fri, 27 Jun 2025 00:37:45 +0000
Message-ID: <065b56f9743a18aa1866153a146a18b46df9ef8f.camel@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
		 <b963fcd60abe26c7ec5dc20b42f1a2ebbcc72397.1750934177.git.kai.huang@intel.com>
	 <ffcb59ff61de9b3189cf1f1cc2f331c5d0b54170.camel@intel.com>
In-Reply-To: <ffcb59ff61de9b3189cf1f1cc2f331c5d0b54170.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CH3PR11MB8546:EE_
x-ms-office365-filtering-correlation-id: 08d86166-8ab4-47f4-e154-08ddb512d592
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UnNJemQ1a0VIUCt4Z0Z2YnVUenFxVmQvQkhrYUtkRCtPSC9oeFpYTDFWZE1z?=
 =?utf-8?B?aXZWUTJQM0xCTnhHWDdyUjFrdVczSkdzZXdqZnJ5ZXUxd1BGc1lnQ2dnMWZW?=
 =?utf-8?B?N1NEaWc1R3NjRElFY0txRGxhWGhQN0Q0MUFrZVJtTHN1Rktjem5nd093Wjll?=
 =?utf-8?B?YlZqT2V1OStzSjV0VXZxWmp3Rkc4VnZQTmFkUXRKc0F4YWJ3ellYSEZBMGNs?=
 =?utf-8?B?ZW9mc3UzQll0N3BiRzVTQlBuNTFET3JkYUZqOE04Z1NkYkx0NFlpQWVXc29Z?=
 =?utf-8?B?UGU4ekg5Y0dpZzNtVTFFeEtUMnVzRFlyS3FUYnFaeWxRUjFhQXlHaVhYdFdH?=
 =?utf-8?B?Zm5ZdENad2hoT1RIOUJORWRScDNQWnhZR3lFZDJKdHc3UHh5SUxyUGJVQldQ?=
 =?utf-8?B?ZzlSbHppQzZJWWlSSXorVnI3bk5lQUFmWTZXaGdoYk9vbHhla0NsaWUrbDhB?=
 =?utf-8?B?ZlJaN2NaMUFhcjJoWjhHU1ZEamtaVU52NldpbFVINzVteStlRStvOHVHMS9Y?=
 =?utf-8?B?RUVDUHhmYlBwVEJKblRpSEhEd05xeDRQcjh1OW5EWER3UmFYRHo4Y1hUSkM3?=
 =?utf-8?B?TnMydFhwcVVYc3NnZGJNSTZVbHJ2U0Q4SHRxRythdVpabWNTbEJ0c1FUazUw?=
 =?utf-8?B?TzJOcVVHdFI1MkQzdnJpbmNxRWJLZXo3T1VwbWpoaFBWTU5QMzAySWtuNXZP?=
 =?utf-8?B?RSsxcGNKL2tyMWtQVmVFUERKbEs4SWlsZ1pvWVp1Vm02dXlyN0NRT2haemdo?=
 =?utf-8?B?RTFMTjFYeVVPYTRodVBPRGY4ZzNqY2lzTXlmS1k3WUVUSjJaREdsY2lBd0Nk?=
 =?utf-8?B?aG5zVHBRa2hsSGJXVGxsYXRtYXZIcDhKeUNHNXgzMlpaZWttWWh0NTBjRjVx?=
 =?utf-8?B?bTJLWE13cFZvbUl4MmVoUWNUWmQ4TXp1SzVqYUZySVNFVytjdGhKanpUQ0xn?=
 =?utf-8?B?a0o3TEpPRVU5dVR5bGFLaEtJQUVlMTdKMnVlSVVzTzZEbzRVenRWVVNLS0pM?=
 =?utf-8?B?c3BveWY0c1hIcE8vV3c3UndPV2RxZ1E0Z0ZrTHFVZzRIU1hyTEdJQXRodHZi?=
 =?utf-8?B?V2tJTVhLNUhhd2lxbUFteEczTkI4TytkcytVNFhkZnhVdVBxeDYxMEhsSWFQ?=
 =?utf-8?B?a0k4UysyMHJYa2dDa3MvUWEwQXN5Q2xkblN0dk4zUnlnekZ6RUhRcFZuUXEx?=
 =?utf-8?B?UW45bzFjTERIV0k0YmlJOXpSVVZLR2ZUR1FhcVQvRDdjbW9xM3VlREVRV0pJ?=
 =?utf-8?B?Zm9RZ3V0elRuSGEvZGxhM1ljQ3ljY1k3TkQzSE83ckI0UTBPZDltZnp5c2pZ?=
 =?utf-8?B?bDJjczdMdU56blJuZGlJM3JOVEFQNjJ6Z005a1FuaE12YUxKM3FXYXdJNkMv?=
 =?utf-8?B?NGEwSkFYbVY5bWpCbzVROTZtY2NnemtnRGQ5RVMySVZ4Wk83RXd6TjZRZjBw?=
 =?utf-8?B?MDlLeGxvMk1OR01sQ2lGRDhSeVY5NDVjdWIzcURjY1RSNW5NWElvRkFMV0VV?=
 =?utf-8?B?dkRPOVVXVnVmeEYwZlJ0Ulcva0ZxM0l1T1MxQTR6bHJuQjZMZmQyZDExYjVN?=
 =?utf-8?B?V213MG9rdXkyNGNBNTExQW9NRUc0SUMxTjloVk9uYWluWUw2VDNoTXNaYyt3?=
 =?utf-8?B?TUdJMUhreVlaUVJnWkdIaDRLVWZHUUZrN3daVjlYL1ZsaTFpa1FCQUpERVdQ?=
 =?utf-8?B?anZwbWlPY04yS09kZlY1a1dxd2F5dnQrYUM5V2xQUUZrUkZpRmUyVGpaT29S?=
 =?utf-8?B?d1FGYzZrTTdueUk4dkVxZ2dYRWRCdWRETXBuaUd1VmlUd2Y1ajU2dGpCcDYw?=
 =?utf-8?B?QUU2bXduMXlaYjVYVEh2aGRJV1hYVnZBYWFXUHV5UjUvVUFHQk9sMEhDWE1J?=
 =?utf-8?B?MlRVeFVnUXBhMy9RTG9aZ3NqS3ZhNTl4cTBIdWpQc3pqbTJTNXA5amEvM3FL?=
 =?utf-8?B?aDlMWVNkanhUck1oMFBKMEMzVkNGV1UwUCtaK0VnNi85bnBMaUdSMUZsQlF1?=
 =?utf-8?Q?MM/vAwKxBLP0dF2xhqL2I7MtIuqSAM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QUlQVkYyVjBwYis3U2krVmNiYzd6Nml1dmI5Ymxsd1VadEJSOExuWVpsa3h0?=
 =?utf-8?B?cTlnVVpxTG5ILzQ1ZlRvNWVNV1B1bStPZ3VTQUVrby9MRmJRQkxhbmFqem9L?=
 =?utf-8?B?SklWTjh2Z0lOZEdFQlJqV1Y0MVFqVzA1MktLQzVQd0Z4eHZzYldObEdNUDRl?=
 =?utf-8?B?RlNJZ0kyb0VEdmdOc0U2UURWTHpRSHAvTGRjUVUzT1U4aG1HTUlGdTIxQmxn?=
 =?utf-8?B?UTZwZEMwcmRodkI5K3dmVDIxL0tDUXdNbkxlSmg1RGZocE9Qa1cxcklRK3Nr?=
 =?utf-8?B?SEVqUGUyRnB6V0JNZDBaZ2NnVEF2UUQ3NHM3UGFjUFRjZU5mY2dJaUdwZTJI?=
 =?utf-8?B?anQzVVdIK3orekJvSkJaNXNTbjlNQm1YTGRnUDY5U3ZOME1PeGxqRWkyaHYz?=
 =?utf-8?B?SjJ3bDhXdzd0MW95b3FvanZZekVvaDdxTytVYkdXNGtUOTJjeSs0QlFUdk5I?=
 =?utf-8?B?SXhWVmdnMWlEQStuYlZ3OHlvSzhOVTg5Ri9jM3VJejVZZU5lYksvU0VZVGFy?=
 =?utf-8?B?TXdkZ1lCUzdvUU9NRjhXeDk2YTRVUXBVZURaUnFBNks1TWd1dmd2SzF6VUlS?=
 =?utf-8?B?ZERPRDY0cHd6V1E0YzM1RlBUTnVkRGlSVyt0anF4MGVMa1pxelhFRmIrd3NX?=
 =?utf-8?B?MGlmMitreFQ5aVRoeTFxdVNMZlVLOXFKVmZGSCtnVThjbWtmbkxJNzhIcDdn?=
 =?utf-8?B?MGdqQWROZTk0dTNOam9aS04vS0hMUFR6L014K1ZzRnFLejB2VEc0OVdJaHY5?=
 =?utf-8?B?K1ZxUlBhdUJ2Wkg2YmZ1eGx3bXcrMHRvQ1BtWU1ZQTU0OVRhSVB5N3lTWDBi?=
 =?utf-8?B?bXZNVVlZQndOUWVGTGZHbkgzOWdNWVVITDZzYVdQQk5QY0RPWi9Yak8rYW0r?=
 =?utf-8?B?YURnaktRRXVsSnp5SnlHM2ZpWmpLS2RnZnE4aEtBczkrdXF3SjJ1d1lBVFh6?=
 =?utf-8?B?citVWEFUMGk0L0RGWnI4SkxLaUxJV2JJYzNMRGNhVFFjd1QxbHNjQStaZ28r?=
 =?utf-8?B?YTVXK2RaZFV6VldXb1dlVk15d0kxUmFiSmZyVkNzcWo0Q05vZk10Z21TbStG?=
 =?utf-8?B?bFp1K1Y2R2c4azFSTy9tOTBSMzNpdHVweS9KZDJyUldmMERPRXppWW1ZTDcx?=
 =?utf-8?B?LzRZc3VnTDc1UUhUeG4rcTVXVXJIdndGQy85NnpaczRQTEVMNVhwQkpzdHFI?=
 =?utf-8?B?WVZYNFR5RFZOVVRLaDVoeDZNVHRQbHhMVm85aTY3dDdMeHQ5dng0cmttakFi?=
 =?utf-8?B?bGVmOW83L3pRZXoybHJ1dzVQdHNLK0JDSUV5azRCeHhsVkpPcThHNWtOWXJh?=
 =?utf-8?B?OCtZQzNnSlV0dEZnWGI5YytuUUlmTlhSanppNWZ5Q3I1QnBWNjBXcDhtbzRp?=
 =?utf-8?B?SGlpUDdPU3c5N0tpM2V4MUlOZzlMcEJYVnRMWDR0Uld0V1J4UzNBeFRGdXVF?=
 =?utf-8?B?RWhpbXZQamNGQ1A5cmw4MDhWL3pPeXE2ajRkUE1pNEpHZHdmSXFJWHpTMFBm?=
 =?utf-8?B?VjRRZWg2OVhXNTgyMGhvVWNjZENkUGkxays1QTZwQlRWZExhMjdKejNGbjBD?=
 =?utf-8?B?TjlNNWppOXh5Y0NBQytRZXBoaFRuaUFKQ0Z6SC9TSEdkUmtTbElDTWNJRkZx?=
 =?utf-8?B?WVJRcFFnRUkvZWpodnRVMXJBdUVFZG5MZDRtd2pKbzNEUEJ2WW81aDhUUmRX?=
 =?utf-8?B?WDYzOFdtRTBGVDNCbW1TQlVMSTlvdGVqeFN5WjI2YklDVDdsYzZVNm16NUZO?=
 =?utf-8?B?TTlNQ3ZTRjluTkJReHNlRjdYVU5RL1VFbWdJb1VkdXhxRWNRY3U0WjFRcUMv?=
 =?utf-8?B?d2lZSUpKeFQwakVZZkNKQkppVVRjcE5qc0RmS0EvSzdoVHVhaFlIRDkxcUFO?=
 =?utf-8?B?bU1KZjBIclF4cnBjZWV3Q1h5Ni84eDJVVkltNzR5N01kdzhTU2xDb3hYUUsr?=
 =?utf-8?B?a0VFZG55cFNwVG90eXRORWl4R3MzcTZveDVMZWhxNzBqSDA4aEVQMElvUDdN?=
 =?utf-8?B?ZEZuR2xhSzhES2NlbXFFeTFWczhLYzZyc25NT1hQd3E0YVVqdjhacFRuZnhv?=
 =?utf-8?B?cGp1c291Q0tidmx6UWY1aXpmUmhNRWEyYW12Nkt5eDFDSmJZYlhpNUZBNjFL?=
 =?utf-8?B?Z3NhM1hBZThkb1BlNHBxUEF2dDNTdC9YdFB6ck91SjBXbWRxZVY2YnRGakNl?=
 =?utf-8?B?cUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <777D2270B0F6354BB9D65A9399142DF2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08d86166-8ab4-47f4-e154-08ddb512d592
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2025 00:37:45.3512
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OmtvNxPZMfqouEt15aTvioo4FfIRsCbo9IpcAVxb4WHQ+LYavbLHMCiOeNvArN3d0DLCiXkEQ/4kNR6CAnsKPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8546
X-OriginatorOrg: intel.com

DQooSSdsbCBhZGRyZXNzIGFsbCB3b3JkaW5nIGNvbW1lbnRzLCBhcyBhbHdheXMuKQ0KDQo+ID4g
VG9kYXkgdGhlIGZpcnN0IFdCSU5WRCBpbiB0aGUgc3RvcF90aGlzX2NwdSgpIGlzIHBlcmZvcm1l
ZCB3aGVuIFNNRSBpcw0KPiA+ICpzdXBwb3J0ZWQqIGJ5IHRoZSBwbGF0Zm9ybSwgYW5kIHRoZSBz
ZWNvbmQgV0JJTlZEIGlzIGRvbmUgaW4NCj4gPiByZWxvY2F0ZV9rZXJuZWwoKSB3aGVuIFNNRSBp
cyAqYWN0aXZhdGVkKiBieSB0aGUga2VybmVsLsKgIE1ha2UgdGhpbmdzDQo+ID4gc2ltcGxlIGJ5
IGNoYW5naW5nIHRvIGRvIHRoZSBzZWNvbmQgV0JJTlZEIHdoZW4gdGhlIHBsYXRmb3JtIHN1cHBv
cnRzDQo+ID4gU01FLsKgIFRoaXMgYWxsb3dzIHRoZSBrZXJuZWwgdG8gc2ltcGx5IHR1cm4gb24g
dGhpcyBwZXJjcHUgYm9vbGVhbiB3aGVuDQo+ID4gYnJpbmdpbmcgdXAgYSBDUFUgYnkgY2hlY2tp
bmcgd2hldGhlciB0aGUgcGxhdGZvcm0gc3VwcG9ydHMgU01FLg0KPiANCj4gU2luY2UgdGhlIHJh
Y2UgaXMgcmVsYXRlZCB0byBzdG9wX3RoaXNfY3B1KCkgaXQgZG9lc24ndCBhZmZlY3QgaXQuIEJ1
dCBpdCBkb2VzDQo+IG1lYW4gdGhhdCB0aGUgYnJpbmcgdXAgQ1BVIG1heSBub3QgZmx1c2ggdGhl
IGNhY2hlIGlmIHRha2VzIGEga2R1bXAga2V4ZWMgYmVmb3JlDQo+IHRoZSBwZXItY3B1IHZhciBp
cyBzZXQ/IE9mIGNvdXJzZSB0aGUgZXhpc3RpbmcgbG9naWMgZG9lc24ndCB0cmlnZ2VyIHVudGls
DQo+IGNwdWluZm9feDg2IGlzIHBvcHVsYXRlZC4gV2hhdCBpcyB0aGUgY29uc2VxdWVuY2U/DQoN
ClNlZSBhbm90aGVyIHJlcGx5Lg0KDQo+IA0KPiBBcmd1YWJseSB0aGUgc3VwcG9ydGVkL2VuYWJs
ZWQgcGFydCBjb3VsZCBiZSBtb3ZlZCB0byBhIHNlcGFyYXRlIGVhcmxpZXIgcGF0Y2guDQo+IFRo
ZSBjb2RlIGNoYW5nZSB3b3VsZCBqdXN0IGdldCBpbW1lZGlhdGVseSByZXBsYWNlZCwgYnV0IHRo
ZSBiZW5lZml0IHdvdWxkIGJlDQo+IHRoYXQgYSBiaXNlY3Qgd291bGQgc2hvdyB3aGljaCBwYXJ0
IG9mIHRoZSBjaGFuZ2Ugd2FzIHJlc3BvbnNpYmxlLg0KDQpJIGFtIG5vdCBhIGZhbiBvZiBzcGxp
dHRpbmcgdGhlIG5ldyB2YXJpYWJsZSBhbmQgdGhlIHVzZXIgaW50byBkaWZmZXJlbnQNCnBhdGNo
ZXMsIGFzIGxvbmcgYXMgdGhlIHBhdGNoIGlzbid0IHRvbyBiaWcgdG8gcmV2aWV3LiAgWW91IG5l
ZWQgdG8gcmV2aWV3DQp0aGVtIHRvZ2V0aGVyIGFueXdheSBJIHRoaW5rLCBzbyBhcmd1YWJseSBw
dXR0aW5nIHRoZW0gdG9nZXRoZXIgaXMgZWFzaWVyIHRvDQpyZXZpZXcuDQo=

