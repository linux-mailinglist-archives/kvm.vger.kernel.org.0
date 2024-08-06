Return-Path: <kvm+bounces-23358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 53655948F71
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 14:48:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D5ACE1F23021
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 12:48:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC61C1C5782;
	Tue,  6 Aug 2024 12:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hM13NUuh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66EF1BDA83;
	Tue,  6 Aug 2024 12:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722948492; cv=fail; b=TUPQ+mJE/t/Q7EA3OOD7w7ieQYmKgyZoHXImmcR2zHTYkzGUH4kvzgO4988xLv48rU3UoHQVrSmYzvTtioiYC4YGhp6PIhspfNhQxmtgG3skzWWmnwTTujzBnjp01Ud5JRpCC0TDmPanbL0MfXAfd1/zZp4pII8blPxS/5Hdlsk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722948492; c=relaxed/simple;
	bh=yQWO/cUmVKHfluARUj7QN0aYVBj2StqXajYLWg5r5sM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WPPkudyJiEBEGuf+5oPlfMCvVGfF1s8mI8VqajcBmtd/VLLpjFuvDPDke7mQDIQIeIR1bkQ5efjYwBjFWC5CJMQOcXfWKeRm6KAX86y4aCbhXKEayJVP8RA3be3PTO9te2E2E1tPnKD0N5s7roYCtROePPgnRCVruULba/5j0fM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hM13NUuh; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722948490; x=1754484490;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yQWO/cUmVKHfluARUj7QN0aYVBj2StqXajYLWg5r5sM=;
  b=hM13NUuhhVqZvH7Pm46Idfx3aMB3qYljbQruy4rMuIL9TQTnqdNGE6XR
   tedaAzXclsEzu1q87dvaP380pZGqusziF91k205mRgSJ7HYlaJEvx1qow
   gLzO/01Jjv6FR4ZLqhxVzAVGJV8Un1/DnJt28cjS7uiaa95/cj9RSA4Rv
   WW/46P0XlDYE5SFSgfkOOhqLpTSv7RrJ2mmhSNoyFsV3ZuhI8yGYP0ywM
   RrJiKfSORPN22+7DNBzRYf1zDVcbFF7ueBw4aBIYrL/M7XINENQi+6HUU
   Sy6E9Od1zD90Pu7aYoawxKyufLdN7hP+93YhtOKIU/h4QNio/QdCdZbhS
   A==;
X-CSE-ConnectionGUID: TZgFBStSRCCMaYAoUHFz+w==
X-CSE-MsgGUID: cRka/uiXRyKcCOWHB7Ec8A==
X-IronPort-AV: E=McAfee;i="6700,10204,11156"; a="24751127"
X-IronPort-AV: E=Sophos;i="6.09,267,1716274800"; 
   d="scan'208";a="24751127"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2024 05:48:09 -0700
X-CSE-ConnectionGUID: wXjVYHVlR9ujDV9koQkgLQ==
X-CSE-MsgGUID: L+yizZ5rRfyS8ri59j25/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,267,1716274800"; 
   d="scan'208";a="56432668"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Aug 2024 05:48:08 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 6 Aug 2024 05:48:07 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 6 Aug 2024 05:48:07 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 6 Aug 2024 05:48:07 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 6 Aug 2024 05:48:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iXhMkLAa1BEZdrfD7mjrO5GsDoQF5fFZE1bRgllvb8BFGqXpw0R44eL5V/CxP/ho9fUwVh1hVjpxIHtW2J5pkpK6xO4KlcnpUUE2mL0kgSsL3B3NUpgLsa25zyXvLJbENUu5s5L+qoAT6ZsUs3uifrk+/K136SUmK2Lj7I+F6NeXvB72DY47jpeP95ocXa47k+UWHYhyCVv8vhdyVGnmiVUsg6bg33LNEbZJL5x8PqkNn3CsHqUFQk4+jobe0ei1qRX87rdomQTbQ7Se79J1LvI4tAiODoAd4b1lKIZrZnk3F4S5tk7jQEI2JN/FL0x2bt/VhwfcYAJJddLrIaNGBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yQWO/cUmVKHfluARUj7QN0aYVBj2StqXajYLWg5r5sM=;
 b=FYQbYln/5oYSjEOwEE/mln6TYt1FbvdM95jnUdY1WJad3I5sHCcbX5GbOlBpvFC6xLlp2NAxkwXzPHNaxQB5QhSZTrnGyj/1SlotVlsSiSLxLTjGaZLF/UO3hOwb82HwuFqYINBEpTuxm6ZVs0267V0wdGKOb4mrEeL//YLX2dpc/aHphnO4ZfgBCetojUD8xDCF9MwwBM/IQvxAknyS3l1/nacGjT5dzPu2gfMMWRMxzdghlrVUUNb9qJq1qsli9gWBRGh2zzec0bSZ05SeOlhnckZvniUZ4cMZg5+gjlGt1JTlp34CuwtMK9AlfyxbyDWLpBHVEI/ocs5UbpF5ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB8361.namprd11.prod.outlook.com (2603:10b6:610:172::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.24; Tue, 6 Aug
 2024 12:48:04 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.023; Tue, 6 Aug 2024
 12:48:04 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Gao, Chao"
	<chao.gao@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 08/10] x86/virt/tdx: Print TDX module basic information
Thread-Topic: [PATCH v2 08/10] x86/virt/tdx: Print TDX module basic
 information
Thread-Index: AQHa1/rIRlz/jvOVzUGBp7cF8OmbMbIZv6EAgAB+OoCAAA/sAA==
Date: Tue, 6 Aug 2024 12:48:04 +0000
Message-ID: <ab89f15ab0497e4d609a5cd843a3e64e736def14.camel@intel.com>
References: <cover.1721186590.git.kai.huang@intel.com>
	 <1e71406eec47ae7f6a47f8be3beab18c766ff5a7.1721186590.git.kai.huang@intel.com>
	 <66b1a44236bf8_4fc72945a@dwillia2-xfh.jf.intel.com.notmuch>
	 <ccf6974cb0c0b30cd019abf195276c2e1dff49a2.camel@intel.com>
In-Reply-To: <ccf6974cb0c0b30cd019abf195276c2e1dff49a2.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3 (3.52.3-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB8361:EE_
x-ms-office365-filtering-correlation-id: 39008797-e608-481a-6f7f-08dcb616034d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?azNkVGxQR0dWWWNtU2ZETU1GM0V4RzRYL1FQY2VHaDJrdCtOcHZXMHl3Skhs?=
 =?utf-8?B?dHBWOG8wbkI1bm52aUpHYnNSVkIyOVd0ODRrYUlhNFlJT3pGMUg3NGVUNkw0?=
 =?utf-8?B?MzQzU1laa2diY2RCNTR2Y0t3KzloM2RtYkpGNWtNTjNMek5yM1R2QXZaRFBC?=
 =?utf-8?B?V3lEaG5Db0lLQ3dLT24rS0g1eVd0ZDNqQmdDNzR4dXRXYUdmbnMxcWdJTnQz?=
 =?utf-8?B?VUVLNDFqNVY5ZkFNR1VHVVpRdk1VMnB6OTMxZVE4UG81ZGt3dko3UFIwUFhP?=
 =?utf-8?B?RitYdDY2dW5BZ3M1MjQ0b0JIQ2xFWThrYUovU2VYVG82cjluNGY3cjNtdWJv?=
 =?utf-8?B?UkxYWUFNNU9LRmF4b0FudkxBejhQdjNSbEdLcnRrV2tLRmVaZ25RME5Td1dI?=
 =?utf-8?B?aWNNbkZ6MkxUQzhyTjF3cHJMTU9KUWpwdGpLOEVkQ1RlTlNPUTVkaE5VNXFP?=
 =?utf-8?B?SWJPc2lTQlJmdGY0eFdJVzVhb1ZvS1JWTjBhcHovSU12NkIxM08rTSs2em16?=
 =?utf-8?B?OE5ETGNxdHppVDgxWjd1YlRmcFpkQTRaS2oxcnhZcHpyUHpoT0R2RU40dXo0?=
 =?utf-8?B?SjlHOGpjeE9OUW5yVnBwOEl0T0dPUG12Nk01aytKMmo5amw1cUZ5eXVpWHVy?=
 =?utf-8?B?bjgxTjFJM1lmQ0tzMVVGbTVjRWxtU0pKUWxCWW9JSEN1eGdyQ1NFUEJDTjRC?=
 =?utf-8?B?aE1zOTRJRCs0dFRkMEN5NS9ZQ0NVZnloQWdPai9aUU13MW5VbmU3cVRzMnYy?=
 =?utf-8?B?eEZjSThYN1hRd2tRRnpRZ1pjMjlKdXBnaVdBbTdMeXBwUm1JUVdESXFkWVFH?=
 =?utf-8?B?RzhuZFZlTVRKSnNFQ3VYNWVGbFFnV2pUNGZzMVZiSy8xTXpyaldrbG8wMnEx?=
 =?utf-8?B?QjIrWUV4aFY2RmQzZ1poL3JUVSt3SkQvblZKRWZjWDc5WFg4T0ZScEZJaTdI?=
 =?utf-8?B?WjZOSSs1YzMxdy9tOTg4Vmw2Y2R5MnRDVmlGOHFjNGlMMnBQUit0UTdwL3Jk?=
 =?utf-8?B?M0hXZm8yL0J5b0VodzIrNW8yTUFEaWxUaFZLTHVtNVZmZDQ3K3d4WmhRVm5n?=
 =?utf-8?B?WW1NMnRORCtyc3NtY0dJdGJWUWZxSkJGMDEwZXVBbTdlUThBTmVxbTg0Yjh1?=
 =?utf-8?B?QlVvUnlrWW8wL3AzK2pYQWJnd0VhSFNvRGRsT1ArRVRDSFdBMmVHZEZtczhV?=
 =?utf-8?B?QUkybTkyQmdiQ01GV1NYbnViNnZPVGMwdml3QmRRWHg2aFZza3RkUWtTN0Nq?=
 =?utf-8?B?c1owVlVPUGhETmxSSGtnNUU0a25WQWpjYXZFWTJXU0JPNjZDbTllMTlHL3Jv?=
 =?utf-8?B?amh5N0hyc2g0NStpL1J1aDgzSzdvWXB0ZzhSYmdYVHAxNnJTa3VqUHRyWE9u?=
 =?utf-8?B?U1lJSFY2ZnM1SmVnbUZ1M1dEQWJQM3o2cmJQaGN5cmtYcnNhNldUa0NZNU8x?=
 =?utf-8?B?MitBb0hxbGc2QW9YVGlab0FqQ1E4ZEt5WGlTS1lzdWJaRDNWRVF5bXRRNGgx?=
 =?utf-8?B?UldHa3p3OVk5ODk2b01iSkdhN3pPNzZja3NFdTlvYnoyN29yaWh0TUh6dXBN?=
 =?utf-8?B?WmhiWUNRSEVnMGkrUGdNS2dKYVBPb3EzdnBMbm5icjBVVUZQOStKcFNvK0lh?=
 =?utf-8?B?WnV5N2dDNElISzB3WXlSTnZ0cEhkYTRWbnRaenNpSFYzWHlmcnFzc2h4Yngx?=
 =?utf-8?B?MVFaV1hWdDBtYWYwOGpHT0lUVFM2QWd5dmc1ZHMybXFzZVVXeUE2ZzBtUlRO?=
 =?utf-8?B?U1Zva0V0c0JWdW0zL1pqaCtTZUZuQmNqSDNLdEZLYVRVempDVnh6U25oZW1Y?=
 =?utf-8?B?VGRBUm0ybVFYWVl0d1paY3Z0U0FhT0M5RGdma096c0ErbGE5SGw5SnRuY0Ro?=
 =?utf-8?B?L2tqM2Rpd0NZRElvZ3BvblhmTVg2Rm1EWDVPM3BWbDBYNmFram9UTG5IcWhW?=
 =?utf-8?Q?0ve9V3nw5q8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L0NZQ2s3NnRiTVl2Q2pUcy94N2g3c0dJdzhZbVlzbXRma3d2aEhHSmxITkIr?=
 =?utf-8?B?VmMwRG9GZ1FHaVJiRG1jMlhZNWhVM2RWS0VGR2xha0JxUWpTbmwzTjIyTUIx?=
 =?utf-8?B?MG0weFhOOU9yeno5cnlhTVhMRFgveUc4d3RYT1J0MHdmalZ5ZUtyb1Uvc1Fj?=
 =?utf-8?B?K1pEVldlWUpOU2xWcnR3WE53SktmT2NQd1VsaldjZDduN3hObXBYM2FzMUoz?=
 =?utf-8?B?NkFHZmJBN0pCRFJtVGdwYjVjQUFXcjlyUWZxYnNJY3lUWDFoTHNCcTc4dXNN?=
 =?utf-8?B?SWE2SkhSZUR4c0Y1OWxzaXVyMWR3cGN0Z2J5K1NGY3lUQ0hBZHJJc0kvRVQw?=
 =?utf-8?B?MlQxelp3V3dIemdGOXh3V0treW9JMkNNall2dFRQOHRTek9MaklBa2htMFo4?=
 =?utf-8?B?QnNrVis2MXhTaU9XS3htSGJpVFpENlcwSExGYW9EMmhtQ1FnMlpBaGp4eFlF?=
 =?utf-8?B?M3hHME94a2cxOGU0Vit5bTNMS3NkaXlkdFU0QzB4YldJblZaVmwrdjNlNDlq?=
 =?utf-8?B?Y29tMkhTM216UmY2SjBwS24xWDAweGpBaGRtMEpXZ041QWdMVFNFT0xLZElJ?=
 =?utf-8?B?SmxaaHI5VDJHK0Vkb0NHUHBtckJYSy8rY1ZiMXlGaVlQYVFiQndtckU3aEpQ?=
 =?utf-8?B?WTY2VWw5U3l4Y0JGNWgrY0ZpZWN4Sm40TXR5T1hKV1BJUjJhRTZ3MHRmam4z?=
 =?utf-8?B?enVhNXUrRWpOSllocStNQjN4RGNSRGlwdVJrS3lqNUtHVUlNdVlxbUw1cHFZ?=
 =?utf-8?B?bG5BSUZ2MGZadFhqTkV4ZDRpUlB6RmdBSDhibElPdVBieUxJUHpwdU1hUGdD?=
 =?utf-8?B?SVpkWGdTaitiVmdleEhxK09lMEowMWlVVVo2bUFYMVl5U1V4OUhWZU03UElu?=
 =?utf-8?B?WldOQ2F6amlqOHZHNERna1l6MzRnK0VHc21GZ0ZhNVI0Nk1wd3ZFSGtHV3NH?=
 =?utf-8?B?ajdBSThhcWh0MkhDUTdLYmg5Nk83UVlMcTJUUUpQNDU0anRvOW9QMmpLeE9B?=
 =?utf-8?B?NVRjblhBTzBtMG9QWVJwbFNCR29jZ3VWdGI4MHJnaXgrTlZYd0V0Z1ZXWisv?=
 =?utf-8?B?WloxZDlZQVdlWlprMERCN0Q1RWltQzFTVC9OdlBNdE56RWVHRFJmWVJGNXZQ?=
 =?utf-8?B?Sm9EY2J6SnZPYmJWOXBqQXFic2JyQTIvL0lKaWJ5UW53YlFLeVFQemEvNzJD?=
 =?utf-8?B?Z3NVTFRmZDlzcEpmdmd3cnhSWGRWbnRFQXhtUWljeThTd0daVjdRT0Y4aU1R?=
 =?utf-8?B?S0hVV3dKemErQzAyZXp6ajc0d2UrbFBpVUNselFMR252VEJTVkQ0czB0YzIz?=
 =?utf-8?B?TTQwTlZESS84T3RtZmtHdzJxYTJNWmx4ZHRDMk5lK0ZzMTZZTnAvT1NWRVh4?=
 =?utf-8?B?K1dSRWhYTCtld0ZIRFBtOGdQWmVmcGttMkZySUFEUUNXK3RvV1VCSnRVbnlS?=
 =?utf-8?B?dVhrNkFSYkVuTjRodVZ4NGhKLzVUc3MzY2VhemRJQ3hnTjVwN0FWTVpPY2Jw?=
 =?utf-8?B?T0NzdVZGNU1zNGUrZzVXQ005RENlME5jL0lLQXIrL0lvMHFZMWppaS9Dekdp?=
 =?utf-8?B?dE1ZZW1oaFRTSXJhemdra25ESDNQcDJwWGdpV1duVWduWTJwNXpCWG9tT25P?=
 =?utf-8?B?dXNUNGxsV0tia1BXRFNNaXBjTW9iWm02b1RXc1hyakQzblBqcC9XQnpkSEhU?=
 =?utf-8?B?U2FVZ3k5THQxVDdSU1B4ekRqWkc2MG1UY09WL1ViV2l2elRkRUtmeU1zMWhm?=
 =?utf-8?B?SGpqWVNOSm9IM0FiWm11cnhXZEdNNHJYekdrTEhvcVV4anBDT0pWZVBxRDFQ?=
 =?utf-8?B?Z1luVEszNERBWVBFSHM0WHBla3VFbEJQaEVQMitKV201NUtBZzRWRXVFTmlT?=
 =?utf-8?B?YVdjajlFdUwwYVFkUkJ4QjFCWVFGc0pUcVhLSE1QSTNBTXkvcE5NMUhUSlVD?=
 =?utf-8?B?SXFBTUY0QnNqd1d2ckhnNEZzczcwL05ucEh5L0FiOFdSaWNyQVNsRU9MTzVt?=
 =?utf-8?B?elJRZnlscnFIVEFsNFh2akhnSG1rNm54b0w4RWV0ZndDWGk1Qy9xbXBTNzFK?=
 =?utf-8?B?N0lLcFh4ampBQ0VuSzhleE9qTHhWRU1JbkRseDBUdzRJNDJSSDV0VXNmcnpj?=
 =?utf-8?Q?C9Mm1YIWYxiSsxqVaiXHGxoeO?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8AC753FA886CA149AA83C2780A3F7E1B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39008797-e608-481a-6f7f-08dcb616034d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2024 12:48:04.0151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kp8iztY/nEmrr2zHwcm48ZfRoc8zbDPgzw6/FX82M6cs7LZ0D1WYazm74iZ4KPDp1A8yiXvKceHtKattqTCM2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8361
X-OriginatorOrg: intel.com

DQo+ID4gPiAgc3RydWN0IHRkeF9zeXNpbmZvIHsNCj4gPiA+IC0Jc3RydWN0IHRkeF9zeXNpbmZv
X3RkbXJfaW5mbyB0ZG1yX2luZm87DQo+ID4gPiArCXN0cnVjdCB0ZHhfc3lzaW5mb19tb2R1bGVf
aW5mbwkJbW9kdWxlX2luZm87DQo+ID4gPiArCXN0cnVjdCB0ZHhfc3lzaW5mb19tb2R1bGVfdmVy
c2lvbgltb2R1bGVfdmVyc2lvbjsNCj4gPiA+ICsJc3RydWN0IHRkeF9zeXNpbmZvX3RkbXJfaW5m
bwkJdGRtcl9pbmZvOw0KPiA+IA0KPiA+IENvbXBhcmUgdGhhdCB0bzoNCj4gPiANCj4gPiAgICAg
ICAgIHN0cnVjdCB0ZHhfc3lzX2luZm8gew0KPiA+ICAgICAgICAgICAgICAgICBzdHJ1Y3QgdGR4
X3N5c19pbmZvX2ZlYXR1cmVzIGZlYXR1cmVzOw0KPiA+ICAgICAgICAgICAgICAgICBzdHJ1Y3Qg
dGR4X3N5c19pbmZvX3ZlcnNpb24gdmVyc2lvbjsNCj4gPiAgICAgICAgICAgICAgICAgc3RydWN0
IHRkeF9zeXNfaW5mb190ZG1yIHRkbXI7DQo+ID4gICAgICAgICB9Ow0KPiA+IA0KPiA+IC4uLmFu
ZCB0ZWxsIG1lIHdoaWNoIG9pbmUgaXMgZWFzaWVyIHRvIHJlYWQuDQo+IA0KPiBJIGFncmVlIHRo
aXMgaXMgZWFzaWVyIHRvIHJlYWQgaWYgd2UgZG9uJ3QgbG9vayBhdCB0aGUgSlNPTiBmaWxlLiAg
T24gdGhlDQo+IG90aGVyIGhhbmQsIGZvbGxvd2luZyBKU09OIGZpbGUncyAiQ2xhc3MiIG5hbWVz
IElNSE8gd2UgY2FuIG1vcmUgZWFzaWx5DQo+IGZpbmQgd2hpY2ggY2xhc3MgdG8gbG9vayBhdCBm
b3IgYSBnaXZlbiBtZW1iZXIuDQo+IA0KPiBTbyBJIHRoaW5rIHRoZXkgYm90aCBoYXZlIHByb3Mv
Y29ucywgYW5kIEkgaGF2ZSBubyBoYXJkIG9waW5pb24gb24gdGhpcy4NCj4gDQoNCkhpIERhbiwN
Cg0KQnR3LCBpZiB3ZSBhaW0gKGVpdGhlciBub3cgb3IgZXZlbnR1YWxseSkgdG8gYXV0byBnZW5l
cmF0ZSBhbGwgbWV0YWRhdGENCmZpZWxkcyBiYXNlZCBvbiBKU09OIGZpbGUsIEkgdGhpbmsgaXQg
d291bGQgYmUgZWFzaWVyIHRvIG5hbWUgdGhlDQpzdHJ1Y3R1cmVzIGJhc2VkIG9uIHRoZSAiQ2xh
c3MiIG5hbWVzLiAgT3RoZXJ3aXNlIHdlIHdpbGwgbmVlZCB0byBkbyBzb21lDQpjbGFzcy1zcGVj
aWZpYyB0d2Vha3MuDQo=

