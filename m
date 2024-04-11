Return-Path: <kvm+bounces-14204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 921018A0559
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 03:14:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23ACB1F22A45
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 01:14:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AABB60ED3;
	Thu, 11 Apr 2024 01:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bw6VTPVi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4E29454;
	Thu, 11 Apr 2024 01:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712798030; cv=fail; b=ljBPKUReuwy2uso66CzNMLXdOenPfZy4QAqa+ZlR0c5MZf6IgmGNsdVSVzV5DfHIjopxPadJrpd8uZ53J8QBT6wk1exjw/9ImZpm11vI4oa0HuiV8HQzja1U39UqBvSzCaQzs2N/ZX/COeGhQ9Ooju3oO81+3/iySwfZgAmD+Hw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712798030; c=relaxed/simple;
	bh=v/Whk8TosVUsghdewvSRzOuXuFAmhJJU+zWH1qxHjVg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pLJh82iT4ruOcdT6m5TP4KzaV7OEy77aJvThcN4Y0jxlOMxV3SEoUe5GqlWKwTExUbRpMuOzEHLaMgTHgrWl7j77jHOTD6AqBvwBOVFAkPGXDaKsj8xlPHdjyCG3ouZUfnoLW4X4Q77po21x9c++slZ+DoegAnF+7w1RzAB8V14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bw6VTPVi; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712798028; x=1744334028;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=v/Whk8TosVUsghdewvSRzOuXuFAmhJJU+zWH1qxHjVg=;
  b=bw6VTPViPWWTJJSeH4imIgFSI9AIrC+khzlXRu9m9olz4lulr4unIYVx
   S+SWOCOndMY0PRPh0AOwkns++L6Pr02Y8vsRGsRPowTnihxBZ99qDrzHF
   OHUbLNDq0epPgnjdG3OZXPl0G0JjTntCAOs4rOOVH6Y7Ax22caWmvQ2wb
   hDDk5KTzPD7E+KsOHuC797GPKJEHXkxot76aFoPAJpDaq7EGdYQgwL64I
   03I+wlreme6c5uplHIi61O2vVNFTOcsvNlSpCMDpuhON3UfbhwGS3UCbZ
   2nqSy9XRafE/19+xtIaI/swcYz76/wfCCqfQER3O2VS/krmd33YFamQ/F
   Q==;
X-CSE-ConnectionGUID: tHz/F79yTn+ZzQ8ZKvHNHA==
X-CSE-MsgGUID: hBnmSbK3RE62q1djA4mu3A==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="33591480"
X-IronPort-AV: E=Sophos;i="6.07,192,1708416000"; 
   d="scan'208";a="33591480"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 18:13:48 -0700
X-CSE-ConnectionGUID: bN8QPqvKREWW45CZPKyT7w==
X-CSE-MsgGUID: AAolugxUS/yg5KKctlgGag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,192,1708416000"; 
   d="scan'208";a="20719573"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Apr 2024 18:13:47 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 10 Apr 2024 18:13:47 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 10 Apr 2024 18:13:46 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 10 Apr 2024 18:13:46 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 10 Apr 2024 18:13:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jCvRvNl9ygyWL/c4wQNtbSxN1Q0gX9fDWL0+1pXisiKxYhbytxPDMjM1+nBkXlDUjabw2aUwV4JgF8ehE4NhojLAWRdnPx6YetFL1Uv1YKM/M8rpDfhzesXO4yK9fPym50V1Gjq7V6NY2xqv2ac0hMEm1Z5mI+J50UTK8eOIaWdjBFe2dmcuEliPbwaN02c8WijkT1GNmXug+f4d+vqd+P9GlfbNG/cG+GQ3OQD/bM6UdPYvN8KoQbOiFewsvHrJgYomeHvvKB6B56dg1y9OAz8sngktkh8tVzlZwLvaA21v+ofkpbFAHXAQEHZeXgNQec4u/puakq2J0o9rnxJ/Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v/Whk8TosVUsghdewvSRzOuXuFAmhJJU+zWH1qxHjVg=;
 b=V+gjmUOWpt+Z3w4TVZ+FBQ09qdv7EBrVfAFWVg/6NuHbWPD26RhPeLmTk5WG1N+Gyr2orQwhPCmWO3UjfpcvdxT01qmVn2V28izeESnZcZk5o8p9ho9VNagHpQITxGzpeiLtyMctdYtkI6fbvb0fD9PqGD15jxaRQ1DIY3rxxbvrt0u2ezAhahrlSqz8YPWWz6LDvt3g62WVFkQBTQlxQGe7o1Ndbth7ERUInOuts8JaReXajV+lXO7CMd2Qr/5FCoxEnS5gRwUsbDj5lw/iBwYEPIg0ylYbMG4NjJ5opJRjp/GblGRw0h1dw8Cbf7F7HD1AhaO83AYG4jls+5d7ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BL1PR11MB5288.namprd11.prod.outlook.com (2603:10b6:208:316::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Thu, 11 Apr
 2024 01:13:43 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7452.019; Thu, 11 Apr 2024
 01:13:43 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "davidskidmore@google.com" <davidskidmore@google.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "srutherford@google.com"
	<srutherford@google.com>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Wang, Wei W" <wei.w.wang@intel.com>
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
Thread-Topic: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
Thread-Index: AQHah3qOMqOgejWDsE6lTffyy9yei7FcJJkAgAJt44CAABa0AIAAE3AAgAAzlgCAAAskgIAAE5mAgAAfEYCAANyAgIAACmCAgAAHM4CAAAowgIACJcGA
Date: Thu, 11 Apr 2024 01:13:43 +0000
Message-ID: <b1d112bf0ff55073c4e33a76377f17d48dc038ac.camel@intel.com>
References: <ZhQZYzkDPMxXe2RN@google.com>
	 <a17c6f2a3b3fc6953eb64a0c181b947e28bb1de9.camel@intel.com>
	 <ZhQ8UCf40UeGyfE_@google.com>
	 <5faaeaa7bc66dbc4ea86a64ef8e8f9b22fd22ef4.camel@intel.com>
	 <ZhRxWxRLbnrqwQYw@google.com>
	 <957b26d18ba7db611ed6582366066667267d10b8.camel@intel.com>
	 <ZhSb28hHoyJ55-ga@google.com>
	 <8b40f8b1d1fa915116ef1c95a13db0e55d3d91f2.camel@intel.com>
	 <ZhVdh4afvTPq5ssx@google.com>
	 <4ae4769a6f343a2f4d3648e4348810df069f24b7.camel@intel.com>
	 <ZhVsHVqaff7AKagu@google.com>
In-Reply-To: <ZhVsHVqaff7AKagu@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BL1PR11MB5288:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T3QB4olaZRx3P+rIi8ECqlTQiD0Y44fu80P5hSn0U3zq3IZxtH2/x+lg+u6ohe2F7qHKM7kZ+o2SLSMGL/gbceBZ1bB885Hp1Wg16Rfkr/oQvVwe4W9XklpFFx/Fx0utiVNV8rpHGF/zjXTcV2lyMJp5XmoxN3RV6nX6raH7YulXjqVmZ+e5zXwBeUfSziXv+55zsIx4cWTb0gvEIkV3ooC0Zd1U0Gge2UlJHPkePyEGJoKICVgqAR4D+BKaQkB0VQ067L+lY3wMyTavpolBWAbhF/8xkQmAd5AKvDT9l8XX+d67qJhZLeB7mnfpQvHWRw80nCyS2I5jZoLugxUyTARaX2rE88CIY3QSRJcB/UoMRht4DM2lURbn5XjlQeZ/4KO8gR2Nj9w8KvgYgVJwBRy5r0bJ/XBVNC2ayieRyN/K9lTQqRG0J5Ke5t/k6t8hGdB1Oxkjfggy+ZZR0Wca3Elwb1EusaZDBwKc1TjfWYuBKnJjG12mxUbzC2PNq7fi0XKLHWLuWwXBxHHKLeORv2VgECMP1vXDUKQgVcjzOorcoqtZj73dYA9xpHYjglfWTrnZBTeNzQMfCNE/hCcmoebZ82f0pMX5ZJwxYvGau7s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z1hrZVJTM0ZlRTRkQ2U0K2x3SytBamRIMVBHL1R3OUVYQ1dsZU5MQ3FBZ1d5?=
 =?utf-8?B?VFlab0ViN2hZamNzTWxQZE1wUlVpNnhxQkROWGtONDk0bEM2RkYyM2VSZ0xQ?=
 =?utf-8?B?ZHhIV2pHdUo4VHlETkc3RmwzWXpBOWdDOFdzZUF2eVlkd0RtSGFuUEJCWFF1?=
 =?utf-8?B?QWo3OGQydVRvY1NlVFpES2JJRVdEaXdvOEpsZldQNVV6azBSOEM2bXlxQjI0?=
 =?utf-8?B?N0YvK3RselZONDNJNmt4RlhoSzRsanFTeXJSeTVFa3AyM0U1b0pnU3VaUVMx?=
 =?utf-8?B?SmZtYU5hV3hRYnJqbWlUY3BSdFBjWW1UdFBQNUZQTERrK1pXRG1PSzV0SktQ?=
 =?utf-8?B?cC9DK3FRZ3RYRnhhZ3ZCY3FpeUV3UExROWhDdEFpbkdScG5WbGljbjlDTGpZ?=
 =?utf-8?B?d2IrYVVyTlN5MkFoUmFjRm4ySGpidTByQmJNNXBIUnpZK09aSUZMQjVvYkVV?=
 =?utf-8?B?L29UVjVIYlVQSVFkS2IzaEZxa0RJUk5ZQ1VOQXdIY3N5NFNGV25SQW54a09Z?=
 =?utf-8?B?WDBHOFNRMDlYTE9qbkJKbDFnb3pKZmdNWUlHTWJhTGorSmtZZzlCZXVmWTFl?=
 =?utf-8?B?TkRmRWE2MXFCYmNBUDNXTUU3K1RKTG9mOTA3cmwwMEpoWDRpWnp3WTlXUUZs?=
 =?utf-8?B?eXNCL1Y4T2hWYU5SV3oweC9SdG1sSkU0USt3SFl6ZVAzRXp1YzhvOG5QSlFF?=
 =?utf-8?B?Qkp3WmtLZngvd3Zhb0ZGdVJDMmlDRFp2blZ2b3VsQlRQazFBa3VZdlhPZ0Fn?=
 =?utf-8?B?VVRpSXRjL1QxWExOa3hHV1BwdFlBaFFBeTNITk9KNzJ2Z2Z3TEVqTFhqYnRC?=
 =?utf-8?B?WUVxcmgrZmFtb04rbDZhNmZQWGxUcjdqR21vaU5ramZaS2J5SGkwWDZWSVRw?=
 =?utf-8?B?SW4yVlBqcVoyelJtbDZxZHpOQTVQTzd4aTh0U0VJTUsvenpKelUyQlFRKzRi?=
 =?utf-8?B?T05aYlJLakc1MlFpT3lhUDBmMTFTUTFOYzh6aVBGaDVmWWNzcVI3Mk8zbEEw?=
 =?utf-8?B?TVY3NDZoMVFwdHg2VE8zditWV2ZLZjdNL2l1U0czQjIrQldpNVJLNVAyc1kx?=
 =?utf-8?B?UHYvNkY1RUJqM2xNQlRHWHJHNDc2eFpjZ0hGZ0ppWUgxcUZvR3ZWZ3FiUWx4?=
 =?utf-8?B?OTRybGF5SnUxZUVtK1ZFcHk5RDdHaWRWU2U2TzA1S0ExQUU1cXJDd1VTajds?=
 =?utf-8?B?Z01FUW5Ua1kzUTE3djVoRzNZZ3FsTEZ5M0xORVFpS1BkdEdCYmtPaWZKMHhm?=
 =?utf-8?B?ajloT2wvbkM2NzNRaGJMbVJ6TGNVNVI0Y09nVkVmOFNXWjFySWlMUC9BSC9W?=
 =?utf-8?B?Y0x5R0VLZ251a1JzZTdieFlBZEx6KzZsR2VWdURNYWNPWTVJc3FTaWJZcjJn?=
 =?utf-8?B?UUNmeWNKSFBOMW1xM1FJODZ2SEl5MkxqdExNVW9ZRUtYSmo1V2dtQmtqWkgw?=
 =?utf-8?B?K0ROV0dhbytSREowWXdWVHpNQjQwYzRjNVVYb3E3c29rNkZoKzRyQ0hHRXVW?=
 =?utf-8?B?ZE9hVjZhbVpmbjQ5YmR5Nk01UkJ2UXhYb2RuNGtiRUJrVFcrZWViUTNja3R5?=
 =?utf-8?B?aXZMcUdtQ1hSK3dnNUUvamRuUHpDUWc5azRvQ1l4c1pycGhNYmExRkE3VTRY?=
 =?utf-8?B?OUFzbldwdWVHNzJqYVVtUUZ3bGFyZDZLaXllNXlaRFJtbUJTVkFlR054YXlB?=
 =?utf-8?B?bkxGbjFEMkxrNUk4S1NyTlFrd0V0SHh6OFBDNjRIUG1xOTZkMDVocUlLeXkz?=
 =?utf-8?B?am9jSk9Tek5qQzBidytwYVFWSjdjZ3dhbE5XZHlwMXBmMXVOM0tjSlRCanJw?=
 =?utf-8?B?bmxXTllBYlpoSW5vQkJRckVJbUJMQ3laeFV1bEliUzk5ZGFoSnBlMnhuZGFv?=
 =?utf-8?B?bmtROStWK01OS2JtUE9hRU1PL2g5dU5PbkVzTU9nU2FSVlBLeStqUVd5WXEx?=
 =?utf-8?B?eExDQm9ueXkrNWFTQ25MVi9iUEh4dlp0S1dsQkpnRjFtSW1mdXA1L3RxR3pB?=
 =?utf-8?B?OHQ3b0d6YmdTYmpQa2hrOVlHODVtQUM5YzNPVldIRmNRcWx3Uzk0eWgvNFla?=
 =?utf-8?B?V2pKMmdPY0dVWW11Nmp3cUlqcGRYeVlDb3dNY3lMYVozWFV1Vzg0QzA2enJN?=
 =?utf-8?B?NE15VmJHVk5mUXFnblI2akYwNjlLc1Y5VG04M2dxQUlud2ZKUGNVczRaRXho?=
 =?utf-8?Q?TTX7AYGO3Ei0ZEGBdUUsVRA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9D2FB628BAFD734BADA0A2B21DA5C773@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9f48e15-48fd-4113-7c94-08dc59c4a180
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2024 01:13:43.7162
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1hUvc92scETDtizZpQNSx/MSkQzkg97e5eDgFebbgzobM6iW3UN+WiKYdr+GuHXWnabF5nNRiCu6gBbo9PNVY2SZMnreAVvwAeyh68INkMM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5288
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA0LTA5IGF0IDA5OjI2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEhhaGEsIGlmIHRoaXMgaXMgdGhlIGNvbmZ1c2lvbiwgSSBzZWUgd2h5IHlvdSBy
ZWFjdGVkIHRoYXQgd2F5IHRvICJKU09OIi4NCj4gPiBUaGF0IHdvdWxkIGJlIHF1aXRlIHRoZSBj
dXJpb3VzIGNob2ljZSBmb3IgYSBURFggbW9kdWxlIEFQSS4NCj4gPiANCj4gPiBTbyBpdCBpcyBl
YXN5IHRvIGNvbnZlcnQgaXQgdG8gYSBDIHN0cnVjdCBhbmQgZW1iZWQgaXQgaW4gS1ZNLiBJdCdz
IGp1c3Qgbm90DQo+ID4gdGhhdCB1c2VmdWwgYmVjYXVzZSBpdCB3aWxsIG5vdCBuZWNlc3Nhcmls
eSBiZSB2YWxpZCBmb3IgZnV0dXJlIFREWCBtb2R1bGVzLg0KPiANCj4gTm8sIEkgZG9uJ3Qgd2Fu
dCB0byBlbWJlZCBhbnl0aGluZyBpbiBLVk0sIHRoYXQncyB0aGUgZXhhY3Qgc2FtZSBhcyBoYXJk
Y29kaW5nDQo+IGNydWQgaW50byBLVk0sIHdoaWNoIGlzIHdoYXQgSSB3YW50IHRvIGF2b2lkLsKg
IEkgd2FudCB0byBiZSBhYmxlIHRvIHJvbGwgb3V0IGENCj4gbmV3IFREWCBtb2R1bGUgd2l0aCBh
bnkga2VybmVsIGNoYW5nZXMsIGFuZCBJIHdhbnQgdXNlcnNwYWNlIHRvIGJlIGFibGUgdG8NCj4g
YXNzZXJ0DQo+IHRoYXQsIGZvciBhIGdpdmVuIFREWCBtb2R1bGUsIHRoZSBlZmZlY3RpdmUgZ3Vl
c3QgQ1BVSUQgY29uZmlndXJhdGlvbiBhbGlnbnMNCj4gd2l0aA0KPiB1c2Vyc3BhY2UncyBkZXNp
cmVkIHRoZSB2Q1BVIG1vZGVsLCBpLmUuIHRoYXQgdGhlIHZhbHVlIG9mIGZpeGVkIGJpdHMgbWF0
Y2ggdXANCj4gd2l0aCB0aGUgZ3Vlc3QgQ1BVSUQgdGhhdCB1c2Vyc3BhY2Ugd2FudHMgdG8gZGVm
aW5lLg0KPiANCj4gTWF5YmUgdGhhdCBqdXN0IG1lYW5zIGNvbnZlcnRpbmcgdGhlIEpTT04gZmls
ZSBpbnRvIHNvbWUgYmluYXJ5IGZvcm1hdCB0aGF0DQo+IHRoZQ0KPiBrZXJuZWwgY2FuIGFscmVh
ZHkgcGFyc2UuwqAgQnV0IEkgd2FudCBJbnRlbCB0byBjb21taXQgdG8gcHJvdmlkaW5nIHRoYXQN
Cj4gbWV0YWRhdGENCj4gYWxvbmcgd2l0aCBldmVyeSBURFggbW9kdWxlLg0KDQpPb2YuIEl0IHR1
cm5zIG91dCBpbiBvbmUgb2YgdGhlIEpTT04gZmlsZXMgdGhlcmUgaXMgYSBkZXNjcmlwdGlvbiBv
ZiBhIGRpZmZlcmVudA0KaW50ZXJmYWNlIChURFggbW9kdWxlIHJ1bnRpbWUgaW50ZXJmYWNlKSB0
aGF0IHByb3ZpZGVzIGEgd2F5IHRvIHJlYWQgQ1BVSUQgZGF0YQ0KdGhhdCBpcyBjb25maWd1cmVk
IGluIGEgVEQsIGluY2x1ZGluZyBmaXhlZCBiaXRzLiBJdCB3b3JrcyBsaWtlOg0KMS4gVk1NIHF1
ZXJpZXMgd2hpY2ggQ1BVSUQgYml0cyBhcmUgZGlyZWN0bHkgY29uZmlndXJhYmxlLg0KMi4gVk1N
IHByb3ZpZGVzIGRpcmVjdGx5IGNvbmZpZ3VyYWJsZSBDUFVJRCBiaXRzLCBhbG9uZyB3aXRoIFhG
QU0gYW5kDQpBVFRSSUJVVEVTLCB2aWEgVERILk1ORy5JTklULiAoS1ZNX1REWF9JTklUX1ZNKQ0K
My4gVGhlbiBWTU0gY2FuIHVzZSB0aGlzIG90aGVyIGludGVyZmFjZSB2aWEgVERILk1ORy5SRCwg
dG8gcXVlcnkgdGhlIHJlc3VsdGluZw0KdmFsdWVzIG9mIHNwZWNpZmljIENQVUlEIGxlYWZzLg0K
DQpUaGlzIGRvZXMgbm90IHByb3ZpZGUgYSB3YXkgdG8gcXVlcnkgdGhlIGZpeGVkIGJpdHMgc3Bl
Y2lmaWNhbGx5LCBpdCB0ZWxscyB5b3UNCndoYXQgZW5kZWQgdXAgZ2V0dGluZyBjb25maWd1cmlu
ZyBpbiBhIHNwZWNpZmljIFRELCB3aGljaCBpbmNsdWRlcyB0aGUgZml4ZWQNCmJpdHMgYW5kIGFu
eXRoaW5nIGVsc2UuIFNvIHdlIG5lZWQgdG8gZG8gS1ZNX1REWF9JTklUX1ZNIGJlZm9yZSBLVk1f
U0VUX0NQVUlEIGluDQpvcmRlciB0byBoYXZlIHNvbWV0aGluZyB0byBjaGVjayBhZ2FpbnN0LiBC
dXQgdGhlcmUgd2FzIGRpc2N1c3Npb24gb2YNCktWTV9TRVRfQ1BVSUQgb24gQ1BVMCBoYXZpbmcg
dGhlIENQVUlEIHN0YXRlIHRvIHBhc3MgdG8gS1ZNX1REWF9JTklUX1ZNLiBTbyB0aGF0DQp3b3Vs
ZCBuZWVkIHRvIGJlIHNvcnRlZC4NCg0KSWYgd2UgcGFzcyB0aGUgZGlyZWN0bHkgY29uZmlndXJh
YmxlIHZhbHVlcyB3aXRoIEtWTV9URFhfSU5JVF9WTSwgbGlrZSB3ZSBkbw0KdG9kYXksIHRoZW4g
dGhlIGRhdGEgcHJvdmlkZWQgYnkgdGhpcyBpbnRlcmZhY2Ugc2hvdWxkIGFsbG93IHVzIHRvIGNo
ZWNrDQpjb25zaXN0ZW5jeSBiZXR3ZWVuIEtWTV9TRVRfQ1BVSUQgYW5kIHRoZSBhY3R1YWwgY29u
ZmlndXJlZCBURCBDUFVJRCBiZWhhdmlvci4NCkJ1dCB3ZSBzdGlsbCBuZWVkIHRvIHRoaW5rIHRo
cm91Z2ggd2hhdCBndWFyYW50ZWVzIHdlIG5lZWQgZnJvbSB0aGUgVERYIG1vZHVsZQ0KdG8gcHJl
dmVudCBURFggbW9kdWxlIGNoYW5nZXMgZnJvbSBicmVha2luZyB1c2Vyc3BhY2UuIEZvciBleGFt
cGxlIGlmIHNvbWV0aGluZw0KZ29lcyBmcm9tIGZpeGVkIDEgdG8gZml4ZWQgMCwgYW5kIHRoZSBL
Vk1fU0VUX0NQVUlEIGNhbGwgc3RhcnRzIGdldHRpbmcgcmVqZWN0ZWQNCndoZXJlIGl0IGRpZG4n
dCBiZWZvcmUuIFNvbWUgb2YgdGhlIFREWCBkb2NzIGhhdmUgYSBzdGF0ZW1lbnQgb24gaG93IHRv
IGhlbHANCnRoaXMgc2l0dWF0aW9uOg0KDQoiDQpBIHByb3Blcmx5IHdyaXR0ZW4gVk1NIHNob3Vs
ZCBiZSBhYmxlIHRvIGhhbmRsZSB0aGUgZmFjdCB0aGF0IG1vcmUgQ1BVSUQgYml0cw0KYmVjb21l
IGNvbmZpZ3VyYWJsZS4gVGhlIGhvc3QgVk1NIHNob3VsZCBhbHdheXMgY29uc3VsdCB0aGUgbGlz
dCBvZiBkaXJlY3RseQ0KY29uZmlndXJhYmxlIENQVUlEIGxlYXZlcyBhbmQgc3ViLWxlYXZlcywg
YXMgZW51bWVyYXRlZCBieSAyNSBUREguU1lTLlJEL1JEQUxMDQpvciBUREguU1lTLklORk8uIElm
IGEgQ1BVSUQgYml0IGlzIGVudW1lcmF0ZWQgYXMgY29uZmlndXJhYmxlLCBhbmQgdGhlIFZNTSB3
YXMNCm5vdCBkZXNpZ25lZCB0byBjb25maWd1cmUgdGhhdCBiaXQsIHRoZSBWTU0gc2hvdWxkIHNl
dCB0aGUgY29uZmlndXJhdGlvbiBmb3INCnRoYXQgYml0IHRvIDEuIElmIHRoZSBob3N0IFZNTSBu
ZWdsZWN0cyB0byBjb25maWd1cmUgQ1BVSUQgYml0cyB0aGF0IGFyZQ0KY29uZmlndXJhYmxlLCB0
aGVpciB2aXJ0dWFsIHZhbHVlIChhcyBzZWVuIGJ5IGd1ZXN0IFREcykgd2lsbCBiZSAwLg0KIg0K
DQpIb3cgdGhpcyBjb3VsZCB0cmFuc2xhdGUgdG8gc29tZXRoaW5nIHNlbnNpYmxlIGZvciB0aGUg
S1ZNIEFQSSB3ZSBhcmUgZGlzY3Vzc2luZw0KaXMgbm90IGltbWVkaWF0ZWx5IG9idmlvdXMgdG8g
bWUsIGJ1dCBJIG5lZWQgdG8gdGhpbmsgbW9yZSBvbiBpdC4NCg0KV2UgYWxzbyBuZWVkIHRvIHZl
cmlmeSBhIGJpdCBtb3JlIG9uIHRoaXMgbWV0aG9kIG9mIHJlYWRpbmcgQ1BVSUQgZGF0YS4gU28g
dGhpcw0KaXMganVzdCBzb3J0IG9mIGEgc3RhdHVzIHVwZGF0ZSB0byBzaGFyZSB0aGUgZGlyZWN0
aW9uIHdlIGFyZSBoZWFkaW5nLg0K

