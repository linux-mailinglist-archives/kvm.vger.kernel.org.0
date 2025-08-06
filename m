Return-Path: <kvm+bounces-54206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D53DB1CF15
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 00:29:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B00A174544
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:29:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFB45236451;
	Wed,  6 Aug 2025 22:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y1d/ZbHS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435852343CF;
	Wed,  6 Aug 2025 22:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754519365; cv=fail; b=pOoea6MFPHoOjvij+NfSj83t6XQ26SC5vw4hRVCY3bNSPLe+mP99hINBVCToGsL1ZKQCRqfX3tocJSh9a+cy2T72sTW//AB8M34N3wo27y7eB/oouTK9/o9nhDH+2Ip3vQDjE+sCACh7On7+gJHBIZI4YB8tpOyZpnnjy8sxDB8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754519365; c=relaxed/simple;
	bh=UkBmPNs5To2/+NJsWFFtqwbQ94/cMQ6dxXSI0UPDL5o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=W1FgDndcOuCpztdzfIvLSwCeZxMWfMV4Y3eLaXGRr9Rg5z9oOsouvyQ6kvyfCs2nl57F8KRoCuLDzB/+9SNiQ+C75YRFkEktHaAyv/ArbRg5YqeHGaP72ccnno3YDs63VCGg7Udpy6W/yo/HEKq2UV1hvcAstCMoHZAUZXlGiT0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y1d/ZbHS; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754519363; x=1786055363;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UkBmPNs5To2/+NJsWFFtqwbQ94/cMQ6dxXSI0UPDL5o=;
  b=Y1d/ZbHSqy08nVlFb5j9xwIQ7wHwbn76KTPX9OPVnCypVFBoWO7xU5Vk
   tVZkmcOm7xcmR+J3GBHhR1Ef2B0ocaJhJ7/zCOhqgjXNKKBhNIFBKp90k
   icIPZ89wY1Aese7VSmFmVihxzm/by+1x3rA+tmzPQLAuSzD+U6N4JR5OO
   pBep+81dsQ/euwpgU7ye6tYaIlTYkOMOp9hUgDx9DOV8CVXG6xLMRxebV
   wwuzbMo+UvJNqETYm+yat+osSzAJWum7vTOywUse1/B4z1ST+ySTlTl2O
   tgm7SImHGk2BR4zR32hVuyG5rlyxNCAixSNNRgZ+XUXEoNEDh2ra4J1Ul
   Q==;
X-CSE-ConnectionGUID: cvqWyl98QzKSA3meeyd0Sg==
X-CSE-MsgGUID: b6VdomfcS9eekk9JvNearw==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="56928429"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="56928429"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 15:29:23 -0700
X-CSE-ConnectionGUID: cEV+3gOiTz6x/V5QIJQ0SA==
X-CSE-MsgGUID: /Un7zplwTl62Z+4XeJElWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="188561616"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 15:29:22 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 6 Aug 2025 15:29:22 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 6 Aug 2025 15:29:22 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.73) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 6 Aug 2025 15:29:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fKh54V3NVvQY3F9i3OQRDZDANbIyQvuFxSAcvhdVOVX1iAUqyM5a99XpmaPU6C8SZcGGc31C5FzeNfUxyucPJ0ZOLXiPz8FucN6c8uXGZY17aFJGLJS5Ht+aOTvLuLhwxS5L8F3/p9sGWdE7hB5zmmfqbomtAGdoqVk3xyElhzrRXib5cgGiTwfnb3OlJc6KsbaeGyL096VoArdb1Oan+qrhjkp+vr86TtCkBcKg2JmfHSlaP7C5iCu36N/2AkLaf2o0ZtWcivxlMdz0JoDddat+6qxz0YyPeetZxXCZ35kqFPic/4o9zyblN6aAf4W39YeiJGIqXKKJ+avhrolGDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UkBmPNs5To2/+NJsWFFtqwbQ94/cMQ6dxXSI0UPDL5o=;
 b=HL9ZCKm0A/i+WywQb5cy9KbrfKRdnYzugCeBkHJbI0x1a+AZRUFQEwB/nhQo58g1WjhmSTrRQ5okvGGn+I9ubv6eXhI5+VT6hucDJMbqURGl5FPjYv9TSuNyeufwpe1pXAumH/FgljYWoPOAphI+QkegcdCl2KUMK8g4UE1P+QUhNmK/VYKZW/9yburEiKVTmFbgGFH88hMHkiDKQ9uzM2sb5XINmCeJ36rM011xPuiqwIQjF9EIVrBgkfw8MfQabeVQeJZgsHP9/dQtlveCjghJy7an2EUi3ZckiVzIPeHVlSjSmhTDJ4vLxQq6GsrJvgewzSI4zzXwKEW7Z15cZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SJ0PR11MB4912.namprd11.prod.outlook.com (2603:10b6:a03:2ae::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Wed, 6 Aug
 2025 22:29:19 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8989.017; Wed, 6 Aug 2025
 22:29:19 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "peterz@infradead.org" <peterz@infradead.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com"
	<hpa@zytor.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
	"sagis@google.com" <sagis@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v5 1/7] x86/kexec: Consolidate relocate_kernel() function
 parameters
Thread-Topic: [PATCH v5 1/7] x86/kexec: Consolidate relocate_kernel() function
 parameters
Thread-Index: AQHb/7MPM7l1KGi+i0Oo+RI0T45w3rRVPjSAgABmqgCAAJ7QgA==
Date: Wed, 6 Aug 2025 22:29:19 +0000
Message-ID: <f900255ba4ea57cc2095790c2d14b0bcb3487da1.camel@intel.com>
References: <cover.1753679792.git.kai.huang@intel.com>
	 <48b3b8dc2ece4095d29f21a439664c0302f3c979.1753679792.git.kai.huang@intel.com>
	 <d3c5417d5aaf0b02fb67d834f457f21529296615.camel@intel.com>
	 <4d761b2d-cdce-1aa7-d138-59dee82e730c@amd.com>
In-Reply-To: <4d761b2d-cdce-1aa7-d138-59dee82e730c@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SJ0PR11MB4912:EE_
x-ms-office365-filtering-correlation-id: 0b02da56-e328-4bcf-8155-08ddd538afa8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cm43V1d4VVBxOVJjU0VVSDRRUlhCLzUxcEtBbkFpeWY4bXV5Q1FlaStpUWl0?=
 =?utf-8?B?Zmo3aEJseUh0ZWJTakpYVU5qbnJFbUZQUzQzRlhwUjNaV3hDbzk1ZnhDZ1Ry?=
 =?utf-8?B?VkZJRkR2S250R1ZUaTdNb2dydStrdzJNQlhZcW5uY1FUY01HZGtndEJydFhO?=
 =?utf-8?B?V0JvaUZXT2RJQkVCdGNCSDNMZVU1a3d5TVpOR3FCMG9lV2Jrc3JtMFIzUTZZ?=
 =?utf-8?B?blpJTmdCd3pJOHFYSkVtRnkreFprSVFVWlBpZjFZTGE3STY0U0VxODhBSXJQ?=
 =?utf-8?B?MU9uc05nTVltaVpZbFRYQy8yOXVvLytTY1IzVU5qcW9ZcnQya3dud2ZtcXJY?=
 =?utf-8?B?KzBXUzY0a0JuQ3hiZ2IwVXVzWkJ5d1Zvem1MZjR4SHpVM01ZbzhReFV0cDF1?=
 =?utf-8?B?aUF6ZTRTRGJaTEFQenR2c2FZZXVqRjFWd0VYZ29MRTg5R0tQMmFrOXQ4UGYz?=
 =?utf-8?B?WGpGelVoNU1jSEt5S1JJRzVKUFEyV0pPVEZIcXp3dFFBcXJrYkpTNjBSVzVD?=
 =?utf-8?B?NzRaWDI1blEzZGpIeFpDNkVjS25MT1B4Y3FHVllqbzRPVzB3WmlMOUsySm1H?=
 =?utf-8?B?dlV4UWQxM2VUWHJVQjZTcVplTnVDb2ZDeUQ0VmpWbU5KclFHbnJGVkU5eUda?=
 =?utf-8?B?S1p1WWFkOGZpQnN6TURwQTZsMlE0dnBsY0dmTkJIYVk2YmY2NHhycDBWMzFV?=
 =?utf-8?B?Z1VmUXZGYzRYbDYxWHg4U0FsemRBTzU4dDNCeXJ2bCt2dTg3S0ZFNFJvZjZO?=
 =?utf-8?B?MmkvSWtRT29SVThmK05qeENXZ2dYUjFWZ0Q0cW9tTlZCWldXVytpKzQ4OG5G?=
 =?utf-8?B?SkJSRGxaTmpWSlNHamxXNVlxRkRYd1BVSEFlWDBmVGpjaTQrL04wM3pqZ0lD?=
 =?utf-8?B?d1FwL0FyKythV04zQk81Q1lCRjQxbUY2MUo3cGlQTW1JUjhVNzVXTGduSWJG?=
 =?utf-8?B?VmhvTU1adUlCTFdkYmZOMjNreTFPVVREMGhEa3R5SkJxU2ZXWGZhS0pxajMv?=
 =?utf-8?B?eXE2d24vNHovbHhic3RlUVRWeWVtYmhZTFFZYjhQVnN5dzZ1bWdpTk1jQ29Y?=
 =?utf-8?B?cG1wbERUbFZOYXJNa0lDTWFJNUcvdGcyTVJ2NTE5b1FTM05OQ0ZoV3BGZTd4?=
 =?utf-8?B?aUtHckNVWG5pNUwxT0gzYjh5MDZCSkV2eURWTkpHMjlMZTdjTFhTcGJqVE5M?=
 =?utf-8?B?ZURHQ3F4THFHTm1ORllPV2dEYTliUlRGVENVb29NUm0yY0w3ay9SUDBJT1l2?=
 =?utf-8?B?OTN0VWRhRFNjR2tIay9QdElWYnE3aVJXT3MrQ2xMYzZKY0NYU0RadS9DcTNR?=
 =?utf-8?B?RkhlRVM3WDVDdGNIdlJUSy9iV2dUY0UrRjJJSk9pNzRhOXJMeCtqL1JJdDBr?=
 =?utf-8?B?aXdJaFF3M2F0djlaRDI0THg0MzNXUnhsWnlYYTkvNzR6ckRDR1ZBR2Z6ckVM?=
 =?utf-8?B?c1kwalpxbEZyZTRrL3cxb2cvUTFLaHd4bWNKWTZxMGlPR05PVys4NUdYaHgv?=
 =?utf-8?B?Z1JnQzNPTFN6Q2ptYm15LzZJZWwyK0oraFhYSGpsSThUWVB6NlVRTHA1a2Ro?=
 =?utf-8?B?S2Z4RlV3QU5uMG9aelFtbnkwWDlncE5CdmVLZDRmOWFMYWpXc2F4T0JPbnJa?=
 =?utf-8?B?WUtiaWh2dW5yQlpnTVVRUWhYNElVbjlZd0tlTERDQzlpY1VUQXQ4anZyV0hH?=
 =?utf-8?B?ZzVpOEF6TXl2UkNYNjVjZy9Yc0Roc21JRkhQd0NRck84RGpyLzg2OFdUOXZj?=
 =?utf-8?B?bnhVZy9MTUxYLzkycUovclp6QTV2T3NwM1gzYzIyc29seWhCclF4b25nc1Qr?=
 =?utf-8?B?T3lXY0VpaDg2V3A1djA1MitTbHR3LzI5L3JxQjlKUkExa2JVbWtjK1VZT3l2?=
 =?utf-8?B?MG10Yy9UT21NMkpVb2hzUXdQRHJ2dXFEM1NmL0hyK2paaytIMHk2eTVadU9i?=
 =?utf-8?B?Wlo3bE9JRnl2dmZrV2lQelV0ZS9HTDV6NENacmVLeFJ5Ung0V2Y0dlJiVEMv?=
 =?utf-8?B?V0Q2RDczV2xnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TzlYaUJoUVBRekdDRnZoL25mbTJodGFRNlpUL3dyQ05tN1Vla3VZS2xmbS8x?=
 =?utf-8?B?S243c3RGSGlMVllVZVFqY0ZLc05VdlI4UktsaEN0UC9nbklaM3lJL0Nwdmg4?=
 =?utf-8?B?Z1JyYWVjTFNNWFRXY3NnaDdXRzBCRExyWmZ3T1hQdm9jbXdhU1hCSmlHTlBj?=
 =?utf-8?B?VkJFOFYwOTRQRDBLR0VPR2xFUkFjY0l2SWwyNGVZeVZFbk0zQ3B0djZhb3Vl?=
 =?utf-8?B?ck12RWlFZ2dkeFhjWk9Ic09HM0JLYWJzQjJobXkyb1VaMnpDQUlScndaeXB6?=
 =?utf-8?B?ZVREa1JZMllEcS9JaEYzUkdFNitXbjd5WFU5ZWhsTGVPVmxuckIvQVdWZ01D?=
 =?utf-8?B?dFlWZ0ZQd1YxaWRqNlE4eUNsVS96U2wrcHRrWnZhNitTUXdDcXN2ZStnM0Rv?=
 =?utf-8?B?bE9zTDZCZHdPM0w3VU5nclg4Q2NlMzBDSnZOVS9DbDNxa0V2cTc4RGZ3a2Y0?=
 =?utf-8?B?UU0xdUVDQlViMTkvSCt6VFE1Q3dibVk1MmJSeTVuNUxkelNRZnFpeDAzcFVV?=
 =?utf-8?B?b3RNaVBTQWpuSUdCRVp1c1FhWXNHdTI2amxMMEZxbjIySlFsUnlVbDI1bTVo?=
 =?utf-8?B?eFlUdkt6cFJvOGI0MjhZU0VMZjB2ZXhUSVhRbjV3bTlWenROWC9qS2pkQmls?=
 =?utf-8?B?U1Q1MDZQYkp4YURhK0hBT2J1R3owWmhYNFZleFhoK0V4VDh4L0NVSk8rZzVq?=
 =?utf-8?B?N1YwU1RtNnNTSHo4d1B3N2lBNVdWeFl4N25DQlAzeXhmS2gwMzdFekFacFUw?=
 =?utf-8?B?Qzk5cFNpSDVzanBsQmUyVzR0eEtNdGJiK2tLQ3hGVnVBS1gzWjZudjF5Rlo5?=
 =?utf-8?B?WlRrT0NHRjNVWHVyUDFMWDZXVnUzRkRpTExrcXAvNEcyQ0s5d3hnUzZmdHJz?=
 =?utf-8?B?SnlUUmFzZ1M5S2c4UUZaMmZrSGYrK0QxQWdvaGJVM2dnRFhCMWwzSTFoY3l0?=
 =?utf-8?B?L1g1Tjdib1hra3NaRVJTdEtSb0JHMFJ3aHhzV0VyamxmMHpLVzFORlhqRHl1?=
 =?utf-8?B?d1BLQzFHN3lvT1BsVkZtckJsbzR4T2xwc2J6N3NWYkIwbWdIdWpLM1lMK0Vm?=
 =?utf-8?B?L0tQTkVVbTF2amxvYmtocHUxeEpDdzVCaUQvQUVGNlBnSmVVSFd6eFlUaGN4?=
 =?utf-8?B?dHVUTjZLVzZNSmthdjlNWC9hNWQ2UTZ5UzdQbm8xWU9URlVNNmVLam1BWnVO?=
 =?utf-8?B?QW5vNDM1aFJXOXMzVGxYTWEybmt2U0hzSFdTdFA0T003RVNaQjY5QkJSa3Bp?=
 =?utf-8?B?ODJBVjFMMWZuWTRRN2VHMjdWRzE4UUZPTmdQM3I2ZVVuNE92bGhKbnVXYVZF?=
 =?utf-8?B?VDB6NWI3clgzZG5ES2ZLdmZ6aXNIZkxCV3JHM3dTMVN5WHd1T3hSUkZITXg5?=
 =?utf-8?B?RW52QzFUTVBaL0xXclp0NkpRWE1MamZVMUdQbS8zckhiK2NOZlBZc0xuRGVY?=
 =?utf-8?B?bXRvSHZVNy95UXBPY2ZnTm1LeWZseEluL2FFZlBQbUsvbG91UjJ2VFh5K1pF?=
 =?utf-8?B?ZUNrdVJMNW5PSGwvVnQ0ZE9KcDBtTlAzOU9BT2dGazRDbzZjV0h6MjRDMWtQ?=
 =?utf-8?B?dXI5K1ZscUFuWnhrUFZwTmx4RVNOZVRSa2J2dlJzbTlaWEcwWnBhMGMrVnVY?=
 =?utf-8?B?OStQbUhpeEM2RmxsSWdKNnNBRG9mSkFMSGFhMTl6VDE2Y2dWZVB3bjR1ZkpL?=
 =?utf-8?B?VzlDOWF3TWh1SXBEMXFWNWtXMWlXTHc0b2NPUlpoSHNML3VGejVQRE5uRUVD?=
 =?utf-8?B?dzNQYWhVVzF3ZkgvN2N0eS9Sa3Qwa3BTdEVTTzVtMTZ5ZXgyZXcySy83RmhP?=
 =?utf-8?B?YWJHdWJTdVNVNDd0Rk9UQWxLOFJXK2RGNEpNbHdabVNSSmo4QW9TZmFUc0RO?=
 =?utf-8?B?REQ3OTVIeGpvSisvZExHR0VsdGROODdoL0xxbWhaSldFdTJxTDVuS1ZSbEsr?=
 =?utf-8?B?YTBhaGVmdTQ0SFV1SzBLTWg2OVFTeFZmL283N2ZaRXlISThqU0JiUTZLemY0?=
 =?utf-8?B?WWxQLzFDUk4rVEdrREhRZW0xNjRYS3lUOVVjOTNIYnZ2ZjhaTDNCVG9zL2hB?=
 =?utf-8?B?SGdQUTJ4TlAyMDBsU3JCQU9OMWZBdWNPaDFLWGc1aDg5MEVpcHduN3hPV3pm?=
 =?utf-8?Q?4xniPhgMnIiOL+VG1keq3qLzu?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C25E5BB928F0AD41889D7D7B290EA267@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b02da56-e328-4bcf-8155-08ddd538afa8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2025 22:29:19.8228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cK9HE++9Rw3u53ulcxvJisK7y3T3JT+DBwefIlFyOuZGNtQJm56RQUZlVBkT7A2aOPL7qMaWySD2diXIlGjKUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4912
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA4LTA2IGF0IDA4OjAwIC0wNTAwLCBUb20gTGVuZGFja3kgd3JvdGU6DQo+
IE9uIDgvNi8yNSAwMTo1MywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBUdWUsIDIwMjUtMDct
MjkgYXQgMDA6MjggKzEyMDAsIEthaSBIdWFuZyB3cm90ZToNCj4gPiA+IER1cmluZyBrZXhlYywg
dGhlIGtlcm5lbCBqdW1wcyB0byB0aGUgbmV3IGtlcm5lbCBpbiByZWxvY2F0ZV9rZXJuZWwoKSwN
Cj4gPiA+IHdoaWNoIGlzIGltcGxlbWVudGVkIGluIGFzc2VtYmx5IGFuZCBib3RoIDMyLWJpdCBh
bmQgNjQtYml0IGhhdmUgdGhlaXINCj4gPiA+IG93biB2ZXJzaW9uLg0KPiA+ID4gDQo+ID4gPiBD
dXJyZW50bHksIGZvciBib3RoIDMyLWJpdCBhbmQgNjQtYml0LCB0aGUgbGFzdCB0d28gcGFyYW1l
dGVycyBvZiB0aGUNCj4gPiA+IHJlbG9jYXRlX2tlcm5lbCgpIGFyZSBib3RoICd1bnNpZ25lZCBp
bnQnIGJ1dCBhY3R1YWxseSB0aGV5IG9ubHkgY29udmV5DQo+ID4gPiBhIGJvb2xlYW4sIGkuZS4s
IG9uZSBiaXQgaW5mb3JtYXRpb24uICBUaGUgJ3Vuc2lnbmVkIGludCcgaGFzIGVub3VnaA0KPiA+
ID4gc3BhY2UgdG8gY2FycnkgdHdvIGJpdHMgaW5mb3JtYXRpb24gdGhlcmVmb3JlIHRoZXJlJ3Mg
bm8gbmVlZCB0byBwYXNzDQo+ID4gPiB0aGUgdHdvIGJvb2xlYW5zIGluIHR3byBzZXBhcmF0ZSAn
dW5zaWduZWQgaW50Jy4NCj4gPiA+IA0KPiA+ID4gQ29uc29saWRhdGUgdGhlIGxhc3QgdHdvIGZ1
bmN0aW9uIHBhcmFtZXRlcnMgb2YgcmVsb2NhdGVfa2VybmVsKCkgaW50byBhDQo+ID4gPiBzaW5n
bGUgJ3Vuc2lnbmVkIGludCcgYW5kIHBhc3MgZmxhZ3MgaW5zdGVhZC4NCj4gPiA+IA0KPiA+ID4g
T25seSBjb25zb2xpZGF0ZSB0aGUgNjQtYml0IHZlcnNpb24gYWxiZWl0IHRoZSBzaW1pbGFyIG9w
dGltaXphdGlvbiBjYW4NCj4gPiA+IGJlIGRvbmUgZm9yIHRoZSAzMi1iaXQgdmVyc2lvbiB0b28u
ICBEb24ndCBib3RoZXIgY2hhbmdpbmcgdGhlIDMyLWJpdA0KPiA+ID4gdmVyc2lvbiB3aGlsZSBp
dCBpcyB3b3JraW5nIChzaW5jZSBhc3NlbWJseSBjb2RlIGNoYW5nZSBpcyByZXF1aXJlZCkuDQo+
ID4gPiANCj4gPiA+IFNpZ25lZC1vZmYtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNv
bT4NCj4gPiA+IC0tLQ0KPiA+ID4gDQo+ID4gPiAgdjQgLT4gdjU6DQo+ID4gPiAgIC0gUkVMT0Nf
S0VSTkVMX0hPU1RfTUVNX0FDVElWRSAtPiBSRUxPQ19LRVJORUxfSE9TVF9NRU1fRU5DX0FDVElW
RQ0KPiA+ID4gICAgIChUb20pDQo+ID4gPiAgIC0gQWRkIGEgY29tbWVudCB0byBleHBsYWluIG9u
bHkgUkVMT0NfS0VSTkVMX1BSRVNFUlZFX0NPTlRFWFQgaXMNCj4gPiA+ICAgICByZXN0b3JlZCBh
ZnRlciBqdW1waW5nIGJhY2sgZnJvbSBwZWVyIGtlcm5lbCBmb3IgcHJlc2VydmVkX2NvbnRleHQN
Cj4gPiA+ICAgICBrZXhlYyAocG9pbnRlZCBvdXQgYnkgVG9tKS4NCj4gPiA+ICAgLSBVc2UgdGVz
dGIgaW5zdGVhZCBvZiB0ZXN0cSB3aGVuIGNvbXBhcmluZyB0aGUgZmxhZyB3aXRoIFIxMSB0byBz
YXZlDQo+ID4gPiAgICAgMyBieXRlcyAoSHBhKS4NCj4gPiA+IA0KPiA+ID4gDQo+ID4gDQo+ID4g
SGkgVG9tLA0KPiA+IA0KPiA+IFdvbmRlcmluZyBkbyB5b3UgaGF2ZSBtb3JlIGNvbW1lbnRzPyAg
VGhhbmtzLg0KPiANCj4gU29ycnkgZm9yIHRoZSBkZWxheSwgTEdUTS4NCj4gDQo+IFJldmlld2Vk
LWJ5OiBUb20gTGVuZGFja3kgPHRob21hcy5sZW5kYWNreUBhbWQuY29tPg0KDQpUaGFua3MgVG9t
IQ0KDQooSXQgc2hvdWxkIGJlIG1lIHRvIHRoYW5rIHlvdSBzbyBkb24ndCBiZSBzb3JyeS4gOi0p
KQ0K

