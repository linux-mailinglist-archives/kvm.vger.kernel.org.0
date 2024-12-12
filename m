Return-Path: <kvm+bounces-33536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FE779EDC85
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 01:31:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F0F716734A
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 00:31:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89581BA42;
	Thu, 12 Dec 2024 00:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E7l5k1Cs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2F563B9;
	Thu, 12 Dec 2024 00:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733963508; cv=fail; b=TR49yozn15RoF/DfplUqtCo9TTSh7kFI6j2naVEeiMmGnZfOnQbilP1Q1bLHIC5G+y5E0ClI8CBDGcVYNiDjU7bzbfBuUG4zZynuvb6h3KztNjxqSRcGFZMkh3HX9ozal00fuDVRwTxrBSDc9LZuiMwKbNI9qkz/D/odN/XCQts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733963508; c=relaxed/simple;
	bh=8b/RiCY+xXw3Q3Q/fDKZQy73SMM9NhW85+n61wWt/U0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=POyHoAaKijJQTFuvWZrjiXroZo395qmq2XSCNsGrkIFcAgqU2ImXfYXgRNDZRvJFrASUCJtoCD+sCO+NbZly5p20KiBByUDyVw9MWKoaJ2sku803guSZ5j7fEGO2KYtbneTrc4wZ6hYKN9MNDm1GTJ93o0sN7hVjfUbsYvdiTgs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E7l5k1Cs; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733963506; x=1765499506;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8b/RiCY+xXw3Q3Q/fDKZQy73SMM9NhW85+n61wWt/U0=;
  b=E7l5k1CszglZJ2Fk2ej9aCJIVgWmh/0/a53Pd5FQzKu7Ur2DlEy9Brps
   VK0r4Z2IdmPaZp70v2lF7UGloZDukzlc5pLMQ5yadIDSbRUAbPIkb7d1z
   z9uY9OyZFTV6DBU8+yLMr2ZGAitOT6jyiJT3fBlabrmiR5uMen/UDzlj/
   6u+2z5r53tV+QVxdafV8wyJhMGGQp4xDxa+uIkW4ziFt1xEl57mP6KHGY
   e7N0S050rwtfS4OO411jHb05Vx8h2qYmuHY5GkjiCS0je3SMp9at1eA7+
   KhKgTHyLgCi0QxKkA3n8jZfTXmBdiNWf4eKDeTKcu3kEa7aYyRzom1K/p
   g==;
X-CSE-ConnectionGUID: eHrcr05OTRezbeD0K8z51Q==
X-CSE-MsgGUID: HNn1GTwqQ3i7BKFeJecRow==
X-IronPort-AV: E=McAfee;i="6700,10204,11283"; a="45041523"
X-IronPort-AV: E=Sophos;i="6.12,227,1728975600"; 
   d="scan'208";a="45041523"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2024 16:31:43 -0800
X-CSE-ConnectionGUID: rrYTdLMtT7Gji5pcF5gkMw==
X-CSE-MsgGUID: KrKlpMoOQlKdeuhOhHrtXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,227,1728975600"; 
   d="scan'208";a="126845341"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Dec 2024 16:31:42 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 11 Dec 2024 16:31:42 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 11 Dec 2024 16:31:42 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 11 Dec 2024 16:31:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wnTFOqhRwuwWB9rvLNLG+xQgdXBaSlHBqr7GVMDqgFxt6JcJMFUUW7K0sy8S7HhYywGe09tRqao4udJXd6QvyHPIGjpkJJJiAMEwwmk9QQSDgVqKDcxySb5GZ8FheTkOmGygHJRDal9vGbYAnQrTV0sNSo9KfKxogrcF5teVroylJDZ1OC+HLGyPut7C2TvB2BNNH8VxjJ1qASwyP2dNrwqavl8CK2cVmcI+szkox2IjnfWjEaBIyQlcppU1w0E/5CVhb88eRPQb5TS3+P/+dPeLtSi+qHr4Mvszy1fhGsHIICD7utYo9dXzCk7RMldPKNWQpTHERu9ta4lbwTMV0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8b/RiCY+xXw3Q3Q/fDKZQy73SMM9NhW85+n61wWt/U0=;
 b=QHtHfGnrItp3Pkp57ZIyhA8S4pSkvGGiKBYaF2y4ofuU4J+3HoD1/AM1Tgk6v+Fubvj0oaFGaRKXQfqhEju8O0LnpmXyhbYoFpnXvxBo0wBNrxIWT4yRK17OUl5X67C+gZA6NBAQeFK3NxmupghVgr25HAJR70Td9H0uUFQUju7F3efYHNvQZwdDZYMoNXUqxq58XyH/E8FLQVAYR5i/XhDbItFPKUDnSrQTxob4bE2jYSGfrY6/Xxj94Nhvvh4vYxAJ+64LpXSZJ7nBFAymAviPvPFHujzo2B8pttXrI6BTNfAmpwpxz4FVMYe8Tlmm6Fj1ykcCLPYUb4WlIeSMLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB8479.namprd11.prod.outlook.com (2603:10b6:510:30c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.14; Thu, 12 Dec
 2024 00:31:24 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.8230.016; Thu, 12 Dec 2024
 00:31:24 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>
Subject: Re: [PATCH v2 03/25] x86/virt/tdx: Read essential global metadata for
 KVM
Thread-Topic: [PATCH v2 03/25] x86/virt/tdx: Read essential global metadata
 for KVM
Thread-Index: AQHbKv4/jC3ItGsFskCZLMjP4qvKdbLZHhwAgAB/kQCAAAMCAIAAf0eAgAfkZYA=
Date: Thu, 12 Dec 2024 00:31:23 +0000
Message-ID: <811f95884b46c2b715f02377cee83352d26f437f.camel@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
	 <20241030190039.77971-4-rick.p.edgecombe@intel.com>
	 <419a166c-a4a8-46ad-a7ed-4b8ec23ca7d4@intel.com>
	 <47f2547406893baaaca7de5cd84955424940b32b.camel@intel.com>
	 <11479069-6f1d-42b8-81b6-376603aea76f@intel.com>
	 <BL1PR11MB5978299D3FE0EA6DA0DAD0AEF7322@BL1PR11MB5978.namprd11.prod.outlook.com>
In-Reply-To: <BL1PR11MB5978299D3FE0EA6DA0DAD0AEF7322@BL1PR11MB5978.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB8479:EE_
x-ms-office365-filtering-correlation-id: 8374791f-621b-45e9-d4bc-08dd1a444ee1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Yi9WakVjRENwMkdCRklBSkZFL1FMUi96NExwalJDeGZsak5td2J4YkZRdGRR?=
 =?utf-8?B?eTJTSHlBZUM3bmxHWFhpdXhOektYdDFybTRUaWFWeUFQRjNSYUphMVZLbDAy?=
 =?utf-8?B?cWd6dEdWYXNLUUxlSTZORVRuQ0NVY2xzaVpvRkpWN0c0OVZ3b0V3U0hHS2lj?=
 =?utf-8?B?RjBqamxuZDFaS0VBU0pkTE9NdkNUSWdYc1ZyYUx3Sk9ZQUF4V1BxOS9Sd1I5?=
 =?utf-8?B?c0hWWmx4V3VVNFFGM25sdDEza1U5czJ0RnpFdjRLdkFaTjVvRjRia0dtRXNJ?=
 =?utf-8?B?anVMUHlZc2V6VjdsSkxtS2ZRY2FNRDc4YUh6VGR4RmtsamN4Mmo1YXpsZ09D?=
 =?utf-8?B?TklKa0ZGR2ZsTnJoT1AvUWp3aThNWmJrMThNN2RrSytCcVFGeTBwRm0zK2Jy?=
 =?utf-8?B?RU40RUs2Y25NRGNaR2VtV0tkTUdzeHhrQWdTZkZBdEpFbHVuMVJMZi8yVk8y?=
 =?utf-8?B?eXBwWi9kL2h4dFl6S0NlTW4rMVM5OUFGRGEyU3FHL1dYK1ZlWmV0Wm9OYmhr?=
 =?utf-8?B?OW5XUlNtUGFRcC8xMUJpNlFBRVovUVM3Q3oyVncxUlJUdEVmemJwbXlBTE1i?=
 =?utf-8?B?c3d6Nk80NldFeVkwa3o5clY2cm5oWFdmOEtrVUxFbzA5TzdLVXc1VitNMGxB?=
 =?utf-8?B?UkRuMjdpVncycmVIejAvS2dXeDVNT2NtT3VhRlhxdTlZSlhYQXpsU2JuYjJz?=
 =?utf-8?B?bHFHbkxjdEM1MkFoZUtXVjlzUlByOVBkQ09OcFpyQW9zL0NqNTFqeTcvSUVK?=
 =?utf-8?B?OFRXZSs2dmNRc0tYak1Yclc3cGlTNHJJNXdyU3pUVWZ4Q1NhY1JDeEcrcmEv?=
 =?utf-8?B?Q2VGOGdZSzFlMk04TGtCNEM1NWdQZ1U0bzZudGVHV05VbEh6US9vR2grZjFh?=
 =?utf-8?B?WkpublFnbUJNSE10TjBpOUJoMElZZTRXRWRRSEh5cGZaUlE1ZCtscC9rb2pI?=
 =?utf-8?B?bnhJMnFWeDJFdTFaeDNwN1F2anNPTGNKaUYxWHVlZEk2enp2UmFiTEdta0Zx?=
 =?utf-8?B?MG1jQnhMdTNDZmxUOVFiZ1BkTkM0TG0vKzlsbEo5dXFpTXQrVVR4WkJJNFZw?=
 =?utf-8?B?UmlBZ09oZW4wdVBCQzBuMmVKSUZCdGdxUW05ZVUwQmh2RW9UTWFJL1pZRzdx?=
 =?utf-8?B?aVdZdUtBTFBQQmdseTY0ZnlPV3BDamZFRWNmRXhzZEwzdHk2VkRSUXBtSzNQ?=
 =?utf-8?B?WkpiMU1BRWVBbDdUN1VCNTc5TDBJZnArMHd3NENtV3NXdXZWSXRCVEUvSi9t?=
 =?utf-8?B?R0xwL1ZjNkFqT0doSzBFY2tWS1p1VHBnMEplMmo0bU9yUW14ZGh4S1lDa1ZP?=
 =?utf-8?B?MVRXZ2NtWWRLVVFIUXNiNlJIYjBxUVJxQW81emJOUTlRcTFhOTFyVU0rOVRq?=
 =?utf-8?B?ZkpoMjB2VVpVeEd6SzFINHVBbmZmSWh5Zk14TkRHcW9JNldJR25LdjFPUmEv?=
 =?utf-8?B?YmFGV0VXb09QMjI4MVhpSS80R1hGZjEwVUVhaDBnbDNQVmJRYTg1ZWhzeTR2?=
 =?utf-8?B?NXpsVFVMQ0ZndnlZN05kYVUvMWoxOTJGWHkzOEN3RExHbjRiZ3lOMXZCdmE1?=
 =?utf-8?B?clpxZzJ2Zy9nRlVGaUF0M2IzRWJzUXJwc3NTd2lRaXd5cjBsSWFHcjZDVDVm?=
 =?utf-8?B?Y3crdWRSK29janNhelNCWWVyenpZSjZHTG5FTmNpVi9WU1JKd0dvQXIwNHQ4?=
 =?utf-8?B?T0VPdkhIa1NHeW5mYkxxTWFuNVVWM0F0TU9kNkJ0T2hkY2hwTG5USk8wZmZS?=
 =?utf-8?B?MDdEbVhGRXA4R2x4MEhTckMrTFd1ZjhiSXZQNGRjQ3dxbGwyWnVHVS9sYlVQ?=
 =?utf-8?B?VEw0WHVqbFFrV2UyWjhOK2xPK1BGNVNPUG5Qa0Q3bldVUVpmZDZiQ2tIeEZp?=
 =?utf-8?B?Njk4cmN5VnE4TjJaNGJlYXFOclN5TGR5L0FCREtQQm1KSE03OC9lR2hRWEhz?=
 =?utf-8?Q?V6AAboVHcuU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OHpOT0xHZlZaemUvMEJEV1p6R21YUVI5bHE3UjVHd29seWVBWkloRWxlYlFt?=
 =?utf-8?B?U3kxU2ptOXFOYVRib3NGdUxaeDZJelJ1YTdUYWE4VUdTYnRHZDhRREt2eW1D?=
 =?utf-8?B?UmhBQjF4TEE4UTVhQ09jUDVJT0p1eVBzSFF2bUcvbGRla3hhT2x1K1Q5QWRV?=
 =?utf-8?B?Vm03NWFrNlh1RlZsRzNzL1RKUzMxQWVhVWtlYkU0czRxT3U5S0tqd091ZUxl?=
 =?utf-8?B?bzBFSHBRQXlkamVha01rUVFSNU9tZjhWSjM0ZmlCRm9XUUgwYmN3WkUwS3F3?=
 =?utf-8?B?azlzanFCWmw5SnhjY2VxZ3VQSjZWVjVKUzVMSms5azJHNGYxZC9helRPeTdX?=
 =?utf-8?B?ek5CTlh5WTlxRkkzVGthS0NhYkZ3V01lN2EvZ3dkRmJjZjNheFZpSjRaUEZE?=
 =?utf-8?B?aTlZNUJObE9kTXVXejlCWkJIblFLTjhiQzJGZ2kyYmZnejFYTUFrclBpeGlF?=
 =?utf-8?B?cThnWXFBdmV4bW5tZ2d6TVFoWmlFUGl0VXRGc0hkN0hDMDFkTVl0aGx0QVpV?=
 =?utf-8?B?eXZzbkFzSmp5aFpKZUNoa0dvTW1MVHBUckMvbXZMNlFpenZuRUVxdFBzY2ty?=
 =?utf-8?B?MTJiSjkycS9RUU8vcW15cStHd2JmbWlNZDBveWhEV3cydm92K0g4Y05zaDE5?=
 =?utf-8?B?Z3BGdmdGaXlPY0E0V2JjaHBmLzlNY0UzanJCN094bnI5VUFqOU9rUnBPVXh4?=
 =?utf-8?B?dmNScXF5ZndTNlJBMmJRd09JUWlkNGsyZjNCd24yYVVkRnFFdWVvc1hFODNM?=
 =?utf-8?B?N0l2VGZTRWJoUURvd2tLdnlRR1Rkd2hNaUZpVTY2MGJjUXFpdHU4WHMxVkFF?=
 =?utf-8?B?c1pHbGtYQkxBc1hsaklsU1lsTS9PVitiblNjQjd2Ym9LZXVLTVpVSkVVOHJ1?=
 =?utf-8?B?WXVnYlR6RDZiaG9VbzRpZG4wYzBtTkdibk9YU0lQT1FEYmFFbnZJZVl0bkJk?=
 =?utf-8?B?MmVXS1BYeTFFK1hDNVdZWmJyS0RPRnlEdWhoUnM1aEZtbG5TUTN1b21CaWFC?=
 =?utf-8?B?elpqdUVRaGd0bUtVMnlzOVM2b1krdHFyUVhVSzlncEMyQUp4K3d5R3BPc0dz?=
 =?utf-8?B?cmVsb0Q3YytlV2MzY1JpV01sU2dmZVNhQXlYK1NMeVZEc000VUZuQm5qRDJD?=
 =?utf-8?B?bFZVT0ZJdTE2aGZqSFhUd1V1U2RyM1hWbU5tL1VnS2xTY1JYQkFlZ05hZ1R4?=
 =?utf-8?B?czgxVzFnTEp2U29KbmtOZVozYi9VSEo1dlcvN21CMXF0ZHVzU2NrVm5aLzdK?=
 =?utf-8?B?QnhTZXBpMVlxbXlJMWNSVjltRGNMejhPdHNTUVpocWdyUngzczlxamFJUWp5?=
 =?utf-8?B?bzd4TTVQTGp1eHk2NW1HeTNMZXJPNVZKeXlITkNlc2NhMmlnQk5WN21FMFp6?=
 =?utf-8?B?RUlSeGNkSi9MRU5wL2tGVkJTVWtndnZBU083MENIMFZmVENQMXBCM3FFYkhE?=
 =?utf-8?B?dG5NTWtHWXhnb2hhRGNadjdma2RPVVQ4Nm0yVjFYKzFrenFvdktaUmxOOSs0?=
 =?utf-8?B?WjBnTnhpMW1lY1N3TDFpZEhXV0xrUElqVk9Ceit4OHUwL0E1WVdpcGpiWXZW?=
 =?utf-8?B?Q0V5YTMwblhtMDY3T1M0aVpINnNsOWx0aytkRlZpMWZFN1BlZ0Z4cEkzNFpw?=
 =?utf-8?B?dGJLaXJ4Z2RZQ0pNai9QZjdnN1Y3L1FpU0tKRElZbXI3SndqNVIwbHNvUHVI?=
 =?utf-8?B?U2x5NFJaanAvU2pxUDZFWlEvbzkrVElMaVgwVG5uRjVrZTBmeks2cytKbzFk?=
 =?utf-8?B?VnFWQXY4L2YrWTZ3NGpMeWl1TXlmOEVlYjNwUG1qbEFPMy9PYlNZaTZpN0Nt?=
 =?utf-8?B?RDAxdm1jS1NJRWJFTmZETHZzclNYZ0NrLzRIZEVQWGJOY0ExSVlUdWsvWU5R?=
 =?utf-8?B?RVN1b2NVOTJwRnVvWTRNcEU4aDY3RHFpUkF1UGhjcktFNktpN1ppWUUvVUcw?=
 =?utf-8?B?UDJyalRvL05sTmxqQmE4c0F3Vmh4U245TWZpN2k1OXE4ZXFWTEp3VHA2MWNP?=
 =?utf-8?B?d01lSGRjczJVdjlCb2tyRUdnTVJvbEUra2VtMCtxc0pvRk41Tnp3bVVvK2RC?=
 =?utf-8?B?V3VOZ0Y5bEVlazNMeFQ3U3lmeGE4N1ZESmlJTmpPZys5M0RBYnM2WG9mcHV3?=
 =?utf-8?B?N0xPTHVXeUNFQkpGUTRISnJTOE43UElhQWQ4N2dIaTliM1BvMldOR0FXcldk?=
 =?utf-8?B?ZFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FDCEB7ADF4755B4193AD647A07806A9E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8374791f-621b-45e9-d4bc-08dd1a444ee1
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2024 00:31:23.9699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4AQTGutLtP3SRSqJzm/vh4jIwqJZIcrSgfgGd0UxzuRIsyRxNKv0pIbNdNlldRJFfj+ildB5/SLxDP2lJQm4O/xMrCjr1soWckYJE0GYAnQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8479
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDI0LTEyLTA3IGF0IDAwOjAwICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
IE9uIDEyLzYvMjQgMDg6MTMsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gPiBJdCBpcyBub3Qgc2Fm
ZS4gV2UgbmVlZCB0byBjaGVjaw0KPiA+ID4gDQo+ID4gPiDCoMKgwqDCoMKgwqAgc3lzaW5mb190
ZF9jb25mLT5udW1fY3B1aWRfY29uZmlnIDw9IDMyLg0KPiA+ID4gDQo+ID4gPiBJZiB0aGUgVERY
IG1vZHVsZSB2ZXJzaW9uIGlzIG5vdCBtYXRjaGVkIHdpdGggdGhlIGpzb24gZmlsZSB0aGF0IHdh
cw0KPiA+ID4gdXNlZCB0byBnZW5lcmF0ZSB0aGUgdGR4X2dsb2JhbF9tZXRhZGF0YS5oLCB0aGUg
bnVtX2NwdWlkX2NvbmZpZw0KPiA+ID4gcmVwb3J0ZWQgYnkgdGhlIGFjdHVhbCBURFggbW9kdWxl
IG1pZ2h0IGV4Y2VlZCAzMiB3aGljaCBjYXVzZXMNCj4gPiA+IG91dC1vZi1ib3VuZCBhcnJheSBh
Y2Nlc3MuDQo+ID4gDQo+ID4gVGhlIEpTT04gKklTKiB0aGUgQUJJIGRlc2NyaXB0aW9uLiBJdCBj
YW4ndCBjaGFuZ2UgYmV0d2VlbiB2ZXJzaW9ucyBvZiB0aGUNCj4gPiBURFggbW9kdWxlLiBJdCBj
YW4gb25seSBiZSBleHRlbmRlZC4gVGhlICIzMiIgaXMgbm90IGluIHRoZSBzcGVjIGJlY2F1c2Ug
dGhlDQo+ID4gc3BlYyByZWZlcnMgdG8gdGhlIEpTT04hDQo+IA0KPiBBaCwgeWVhaCwgYWdyZWVk
LCB0aGUgInNwZWMgcmVmZXJzIHRvIHRoZSBKU09OIi7CoCA6LSkNCg0KU28gd2UgaGVhcmQgYmFj
ayBmcm9tIFREWCBtb2R1bGUgZm9sa3MgdGhhdCB0aGV5IHdlcmUgdGhpbmtpbmcgdGhlIDMyIGNv
dWxkDQpjaGFuZ2UgdG8gYmUgbGFyZ2VyICh0aGFua3MgS2FpIGZvciBjaGVja2luZykuIFdlIG5l
ZWQgdG8gY29udGludWUgZWR1Y2F0aW9uDQp3aXRoIHRoZW0gYXJvdW5kIHdoYXQgS1ZNIGlzIGRl
cGVuZGluZyBvbiBhcyBURFggTW9kdWxlIEFCSS4gQW5kIHdlIHNob3VsZCBnZXQNCnNvbWV0aGlu
ZyBjbGVhcmVyIHRoYW4gdGhlc2UgSlNPTnMuDQoNCkJ1dCBpbiB0aGUgbWVhbnRpbWUsIHdlIGNv
dWxkIHRlbGwgVERYIG1vZHVsZSB0ZWFtIHRoZXkgbmVlZCBhbiBvcHQtaW4gdG8gY2hhbmdlDQp0
aGlzIGZpZWxkLiBXZSBjb3VsZCBhbHNvIGFkZCBhbiBhY3R1YWwgY2hlY2sgdG8gZmFpbCBjbGVh
bmx5Og0KDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeF9nbG9iYWxfbWV0
YWRhdGEuYw0KYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4X2dsb2JhbF9tZXRhZGF0YS5jDQpp
bmRleCA0NGMyYjNlMDc5ZGUuLjc0NDU0OWJkZjFkZCAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L3Zp
cnQvdm14L3RkeC90ZHhfZ2xvYmFsX21ldGFkYXRhLmMNCisrKyBiL2FyY2gveDg2L3ZpcnQvdm14
L3RkeC90ZHhfZ2xvYmFsX21ldGFkYXRhLmMNCkBAIC05Nyw2ICs5NywxMCBAQCBzdGF0aWMgaW50
IGdldF90ZHhfc3lzX2luZm9fdGRfY29uZihzdHJ1Y3QNCnRkeF9zeXNfaW5mb190ZF9jb25mICpz
eXNpbmZvX3RkX2NvbmYNCiAgICAgICAgdTY0IHZhbDsNCiAgICAgICAgaW50IGksIGo7DQogDQor
ICAgICAgIGlmIChzeXNpbmZvX3RkX2NvbmYtPm51bV9jcHVpZF9jb25maWcgPg0KKyAgICAgICAg
ICAgQVJSQVlfU0laRShzeXNpbmZvX3RkX2NvbmYtPmNwdWlkX2NvbmZpZ19sZWF2ZXMpKQ0KKyAg
ICAgICAgICAgICAgIHJldHVybiAxOw0KKw0KICAgICAgICBpZiAoIXJldCAmJiAhKHJldCA9IHJl
YWRfc3lzX21ldGFkYXRhX2ZpZWxkKDB4MTkwMDAwMDMwMDAwMDAwMCwgJnZhbCkpKQ0KICAgICAg
ICAgICAgICAgIHN5c2luZm9fdGRfY29uZi0+YXR0cmlidXRlc19maXhlZDAgPSB2YWw7DQogICAg
ICAgIGlmICghcmV0ICYmICEocmV0ID0gcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQoMHgxOTAwMDAw
MzAwMDAwMDAxLCAmdmFsKSkpDQoNCk9yIHdlIGNvdWxkIGR5bmFtaWNhbGx5IGFsbG9jYXRlIHRo
ZXNlIGFycmF5cyBiYXNlZCBvbiBudW1fY3B1aWRfY29uZmlnLg0KDQpJJ2QgbGVhbiB0b3dhcmRz
IHN3aXRjaGluZyB0byB0aGUgZHluYW1pYyBhbGxvY2F0aW9uLCBiZWNhdXNlIGl0IHdpbGwgYmUg
Y2xlYW5lcg0KYW5kIGxlc3MgY2h1cm4gZm9yIHRoaXMgYXJyYXkgZXhwYW5kaW5nIGluIHRoZSBm
dXR1cmUuDQoNCg0K

