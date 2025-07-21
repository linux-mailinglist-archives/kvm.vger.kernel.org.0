Return-Path: <kvm+bounces-53030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 667D7B0CCA0
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 23:31:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 351736C103D
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 21:30:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B826623C519;
	Mon, 21 Jul 2025 21:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ez21NqUW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E47172BB9;
	Mon, 21 Jul 2025 21:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753133471; cv=fail; b=rq2zFEPtGP0R+kWQqBmjwWm6LoDo8TTXy2PL8N+YGv2/mFO0wE7T7IR8aU8Bp2YrbLff2yoqKqunpAUDE/T+8ThUe1guKhZZlei0mpL4fjN5pIf7fo3yiNUzkW3/691HdGWCe5G/aJ7cKDGaiEjvsXbg91t0Bql44OwKLGBhC6I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753133471; c=relaxed/simple;
	bh=tp7++hBpcrVTLfUDmuJE0EUJJFo4ra3BkRFifo1kTck=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=F479DSoR459HmJxXWv246K9IIdy1KSwblGqYOFc2JFyiDR6rhLy+Kn/WxduZmevXkhpjvI6lQsLTEJ8kAzBqZcIKaoGkRsNyuuipXvi/fjB8qeO12NkUWLIyJhkyFmqACO24hZzrPmAcUtlKvWE++eO+dXeYRZc40Ovb1JJ8wcI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ez21NqUW; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753133470; x=1784669470;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tp7++hBpcrVTLfUDmuJE0EUJJFo4ra3BkRFifo1kTck=;
  b=Ez21NqUWsDuw1rO6iiXl5iIxOjKMj6r3Nr/VGHObJBzU8+WkGpxTUVmc
   AvVsarzqyX2Z6pof+tIYkC2X2HqEp25p45hZe7XAeN61Uc9Z4JuWnLxRn
   GtmZ2P51IqA6U2wsOdx+AHl3WvaAb5XxBCUh4YNtVeTS5ljL5NB7Nxcnk
   2HQciosTPm4/ZFVlPE5ERWhRNawlstsO9OnzE5njxCg0mOrC9K1IVde62
   2L/Bz1+chE2D6N5PrFHgd5lCtJ4+RHCzBO3gzMiCnMi9YQJGQgwrAw4VE
   wOn/7lm1fVT6djHKvouxqan1BV4hyg8xDa2xcONb0yLMdO9plxcS8jPZB
   w==;
X-CSE-ConnectionGUID: 8SkbGgozTQarUX1ChlKNfA==
X-CSE-MsgGUID: SwTt1u8xSuC7+EFJNT7kEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="65629924"
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="65629924"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 14:31:10 -0700
X-CSE-ConnectionGUID: CaKaFKUPRfKb2qL2ip4+wQ==
X-CSE-MsgGUID: EopG1bkUTT6aoYOgjJRLRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="159279981"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 14:31:09 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 14:31:08 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 21 Jul 2025 14:31:08 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.87)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 14:31:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oNZVUxeSIlIBtp0itUBl1Fx1c0OECe51fkKki85BGUy5+gGAcL/PGzoZEb5CR+dsvLXGoD2R3H5T2J8WNmCJdjXMKZTbOz6qxEPMdfhqd/7yuAa2yMEQV+MjFzvc5cxN0m3u1EFaNmX767SBCbOr5H+copOy+A80+p413pEMfCYs8vVDmoFDlTiBXW++3aSfJOOOU1c7PLyj0uAiQ3mp5aX50+kzNOoLEyGMjrzbPZqaKt14n8U+FIksuwxmtZfCGIUoFaEuKGYwpP/lgt1oozg9yFQiYQ6IeaWrmJ4KgocYmEN4URhUsnBrVRI94H5SBLRbmQSRTVHDZUK66qyqCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tp7++hBpcrVTLfUDmuJE0EUJJFo4ra3BkRFifo1kTck=;
 b=v//PrRphZf8JNf2Z6r8/q0g/XD8U+ZAAPuYwJcF3wMB63lL4INUhlNzRYanqcN9lU+UBuYbMUGriSyXdWH1mTCTmudmKzfUQBZQr6UAV4Ty6l/t85gL1Rk+Mg50558DkKYSk9M/QKtbVaQ+L9QNvnLwFY+R36Hm7h6TM11Hd+1WTZx9V+I7DqyN321ICp/w3fE6XPkrioaodAu/wIyoMrtbuL610S9MCZtTIm0mM2nfCa+jcvRZpA41alCZh6zkrdt0d18ayyqEa9t/n+pHYZqjFda5Z4wR3CohWuU9zqeasOIABhEylci67T2eyph1NOK60+Uv9tLUGWF1R+ZsgyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA0PR11MB4541.namprd11.prod.outlook.com (2603:10b6:806:94::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Mon, 21 Jul
 2025 21:30:39 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8943.029; Mon, 21 Jul 2025
 21:30:39 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "peterz@infradead.org" <peterz@infradead.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
CC: "ashish.kalra@amd.com" <ashish.kalra@amd.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>, "Gao,
 Chao" <chao.gao@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Williams, Dan
 J" <dan.j.williams@intel.com>, "sagis@google.com" <sagis@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>
Subject: Re: [PATCH v4 0/7] TDX host: kexec/kdump support
Thread-Topic: [PATCH v4 0/7] TDX host: kexec/kdump support
Thread-Index: AQHb92MJBuxsDpN9PEeyjEaZ/MCJarQ8km6AgAAce4CAAG+fAA==
Date: Mon, 21 Jul 2025 21:30:39 +0000
Message-ID: <6465cea16f57e2a0bdc97371ef1749c1ed5c197b.camel@intel.com>
References: <cover.1752730040.git.kai.huang@intel.com>
	 <f999349e-accb-dcd6-75f4-eb36e0dda79f@amd.com>
	 <8374a887-9bde-c7c0-ace2-0afe22f1f616@amd.com>
In-Reply-To: <8374a887-9bde-c7c0-ace2-0afe22f1f616@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA0PR11MB4541:EE_
x-ms-office365-filtering-correlation-id: 1e895832-dbc4-45b1-59f4-08ddc89dd6d8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?S3pROG9aVHJLeHhXR2cxcStjaHM2QVozK0I1M04zeVl4L25sSFAxc3N3TFh2?=
 =?utf-8?B?NC9HemU4S1YrL0hINmN1bXd4U2hOL2c1ZldISjlaTHd4QnhyeTBCRmxPbUJX?=
 =?utf-8?B?TENxZEJNMGNYckJVUHZNYWJkUUVBeUNRbVExZG9IU3dFRTZrRWJneXZIS0li?=
 =?utf-8?B?TnhqdlpQQXg0a1QzbWJwMXpnaXR6cE8vdkYyWVNBY3A0QnhpZHA2S28rUHlI?=
 =?utf-8?B?ZW9TN2h5a01FTUtVZHhBd09Zdzg0TmxxNWY3ci94NkNGUk8vd3Y1bThURU0x?=
 =?utf-8?B?MjJTVDljTzJleXVIdE11VWcrOXVkY2lRWFJCRW8yeGIwUHFtK2VINjgvRTMz?=
 =?utf-8?B?ZjhmYVhhSHRibXM3aHo2clh6bU1ybnRVZ2djVlM0clBlWEdIdU1xcjRESGdH?=
 =?utf-8?B?M3diMVVnaUZaWk8zdXgrNDUxQW9PYkFpc2c1TE45R1pDcTVQVHJnUVNTMXQv?=
 =?utf-8?B?MzlicmMzdmZoK3JJQkZQWnYrSEsrd0NpVGJ6ckdjT3gyUmFhaXlyT3Z5N0lm?=
 =?utf-8?B?RnJEZjNRK0ZQbHZ1V0lGQnpWd0pKOWFZSlYyVEU0ZlN3aGtZSXdqUHJ1UU1E?=
 =?utf-8?B?VDI4R09QVkxId0RNUkZxd1QxdXdhaHRwZTdDUmxhZ0FnVlREVEtLZjNJd1h1?=
 =?utf-8?B?SUpWSzFNZERtSkhFMmhGNTA1ZUJQaWdRZlZGaStPY3F1T3lDYUVCT2NMb3RK?=
 =?utf-8?B?WW95VHdKUVZJOCthVWNQd0FVbHJGMUdBczE1UTJtbXptRXhtais5dmM5SEVw?=
 =?utf-8?B?MnpwdU9wUUdHSEw0aUFCaXRhNTQvaFNCcENCcWQwY3Y2WFYzSWdDNlhlV2xN?=
 =?utf-8?B?VDd5cGNETmwvMjZnUVd4ZnRPTkc4aG4yeVJieUttRlhQY3JCcUFpYTlwaWRp?=
 =?utf-8?B?azhkYjNoOWJCaFgyVHRhYnFNdmNaRWNELzNwOVFKTGwyK2cyQWJJZTJTSEk3?=
 =?utf-8?B?aldNS0c0OERmd0xvaW1sMEZITGVXanlHRi9ucnNxMDdjYjF0eTlKWFQ1UVJU?=
 =?utf-8?B?b3Y1YXVsR2JYT2NNdXZWUXcyRWFUd0JubjBVc0Uwd3pXQmFQdGNkMUJNRjhx?=
 =?utf-8?B?cjl0cEgrVXJOVkJaVWVjVXVVL244RENuQ2ZPM3M1a1hLSks4SS9rdFIwSmpP?=
 =?utf-8?B?ak44TGdQYTdTMlJjUUprOGhlajZHRWN0Mjg3OEpyeW90WXB4cjhMQ1RIUlNt?=
 =?utf-8?B?TWpqM1hxa3ZaYWJhcFFBak9NYm9XRDk5cVZFUkhZOUdPMDEyVjlZUTBMem83?=
 =?utf-8?B?dnNURXBGRGVwTFZnT3Y0K0t6RWVvN3hyOTZuSUVLYjZUZDNmcW0xRDFIMjJN?=
 =?utf-8?B?ZGhwWEJhUlArUC8ycUdvdVQ1MjVLdG5OVjAySnpjZzBjdk12U1FSbU91aWhk?=
 =?utf-8?B?VHVjWTNaTlpXbklQeXBpSHJMeGhqNVFKa3ByRWF4Ry8zVHpXOURsek5zRm5h?=
 =?utf-8?B?YXBrTXBOZk1wbGtVTlN0c2ttRGpDVzhFMXpVUVRiRzZOdmlrUmpjY25mb0Jn?=
 =?utf-8?B?ZXRleWRKSDN5V0Z1a0JvT0NaSFBtcWVkbnlDSUVOOVJRN1JaQWdSR1hXalpM?=
 =?utf-8?B?cCtoWnlVeHU3TEFaczlsakxmZVlsL2oyTFZmQlR1VjJrVlI0ejIrRjFlWGh5?=
 =?utf-8?B?aXNKTnYyTXNxWXFwODMyVG9YWFdtVmYzMkFiQ3dsR2svdklsallSRXFSUytl?=
 =?utf-8?B?YjB1b3ZMY3l6YjhFZS9qSWFlUGNFM1lwSjZzRy9ZalVsckRxWCtZNkhvMVM4?=
 =?utf-8?B?bnVuMUtFSGJ4d0xycVVNRGg5S01FZzAyK2VZdy9SdS9Rakl4Z0g5OWtGbUVa?=
 =?utf-8?B?R0JISVNuc3BQZ29SekN2NGNRMUEyNy9XbGZVUDg1alV4U2kvbmRmbjg0MlBL?=
 =?utf-8?B?Ty9JdUtXV0dxeGlQTTBZOERVclhWc2gzUkZvZ016a3krcTREL0h1eis5ZHpE?=
 =?utf-8?B?V2xZUlR5NjlPVjRFaWkvOTZ6NjVCYk8rZ0lkRzBxeVdRT3RTQVBjdXQxcGlX?=
 =?utf-8?B?bWlNUU10RnFRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dld3Nm4wNk5PQlBaQUoyemFSMiszU05MdDBlZTVxWk8rblJ2ZDd1bHl3RVdm?=
 =?utf-8?B?S2JUUXZUL1AvZXFEbDYzd2J0aE1JSGYvVTdnVHYvLzNVZHo2UDFFdVpzU3FM?=
 =?utf-8?B?b2VIWmFLVXJldHhFSjgyZkF5elEwdzlSWnVURndVZ21DbG5XYWZDMWpFcVNY?=
 =?utf-8?B?VFcrVE5vVGZ2Z1NyYjdVNnR4b090SmpSa3JVaFZtdnE0elZKeGRiTmVBMi9X?=
 =?utf-8?B?QlpjOFlubWVtL0JNaGJHdDhpb3VhK2N0Y2d3RkV0MmJqRzMvQWRDSHNRSWl1?=
 =?utf-8?B?bHZZMHhKSk1UMkwralpjVFpUM3VJMEp4Ri9mbm9zRzAxdkt6Z3JSY0ExZGJz?=
 =?utf-8?B?QXBMK0NXV0pMYW82RFRmT3QvNGNaN1dnWktseXUyTC9RcEpHdVFrdzNZa0tH?=
 =?utf-8?B?VzEvUVZOOHVpWXlGenVCNUE5MG5aN0xxbW1zZlFvaXhMN0loME1SbGpFakYw?=
 =?utf-8?B?Yk1kcG55TDlkdlJDeEo2NGhvSEZNZkkrYjBTS3FJakV1QnVld25TbnpJcVRz?=
 =?utf-8?B?WmRINWd6WGdaNHpmRVRXS2pXWnpuOWVCVlgyTGxKRHd2SDhpQzMxSElhMkVa?=
 =?utf-8?B?dHVHdy90dkRreGViaU81NlF3T0krYzNqbTR6djQ4ZUpUUWViZHIvdDk4VURX?=
 =?utf-8?B?RTAxN1VTNmVLaTlEdGd2bytIVnVjM01iUU5JRlBxMkZNbzFkOGE4MHZLSk5J?=
 =?utf-8?B?dXZJdnV4TWE4aTJjTWgxcXhZajgzYnIvc0RRWStRTDVyTVNDOExVcDdSUkNp?=
 =?utf-8?B?M1NNQXM1RzJNNndtK3FldnZFbHR4NkNQY2w4bjRCUGxxS2gzSG5ZUGJLekI4?=
 =?utf-8?B?RzZvMHFZUmJSMmh4R2FQb2l0VTFjM0JKdmVGVEhGN2pTdVdxZ0VzYjl2SVR0?=
 =?utf-8?B?aDI2aWY2UGtnRFhzUkZKSWtDLzlvdnFIR1ZHTXRVZnJzRC9SZEQwbW4yTTBL?=
 =?utf-8?B?MXlnWmlwMDVEeU9XMG56MUwySHM2Z1d2ekRNUGZkV1ZraUUxRzlGREw1SnZ0?=
 =?utf-8?B?cllNSHFmazFhQjhvQ0pnWGNVRGFXMU9QNUUzbWdwQUlveERiM0ltQzJzTXVq?=
 =?utf-8?B?UTN3cnRieXB1QXk2NEpad29qZXBtblMxcWNhcktqdGo2RW9pN1pIVC9nTDl1?=
 =?utf-8?B?dkNZcTJ4bFpZODROMUJ3TDkyWkFmcXk1OVFVaGJmRTNoai84UE93eFE3V2Js?=
 =?utf-8?B?d3czUm05OC90ZmEvODdHcFhncDloU1BEVWNQYnNjZjZmc0dnNWd2TG0vZlQr?=
 =?utf-8?B?bngyeVVjUjkyV0U2YjROZUdSdCt4R0F0Y0N4S3B2OVd1THRzbld6aGtLekg4?=
 =?utf-8?B?MXlGNWJZNEZXMWxiZGlmSWVMTWhRZmpyQmV1UUtnRWt3Z1E1UnpTWTlaQXJq?=
 =?utf-8?B?eDZmd3F2TGNzWUFhMDV5RXdEbzUxWDFUYjFqZ1hqRTBZWXRwU2F1OHFQc2VQ?=
 =?utf-8?B?aHRLczNzUEV1bmtSWUhaRG1yLzBCcE9MNTJiMWpHYnBMeFR1SWxtd1BqSWda?=
 =?utf-8?B?NCtBOXVXNmM1L2dhSXRuRHFUaG5oQ0xFYTBHUTJING0vSHNHcGpVK0lMK2pt?=
 =?utf-8?B?WllHVWthK0dHZGlQSnUyUlJvWWp4eTEvb3FIVS8yT3FjOEhNS01iRlZhYzZN?=
 =?utf-8?B?aWM0RFRXaUY3Sy9TNmdMTVNpaFp6dkZIbTRVOFY1UHdVbmtDTG5YZVVyY2Jl?=
 =?utf-8?B?bEpkeDRjZmN3VWlubnI0eWVjQzNoUjgraXArZEdtSUF5Z1dEMGc0U0FyWXJX?=
 =?utf-8?B?NDhGT0hvNnU1T2lHbzgzR3pIOTByQm5vdG04eXQxdG80YnlUdGZrelp3dzZi?=
 =?utf-8?B?TEM2WTBoNW1pb1ZZVFdjOTE3aDZuUkdGNThGUDducDBJcGxQOUgyY2g5VDhE?=
 =?utf-8?B?ejlzRlUxNWpNeG96T1VYTGN0U0xublVsbmxSSHNpR2hyc2VwVVFRQjkvaURN?=
 =?utf-8?B?TXFUVkdTVjdOSVlUTk9nQ2EycEdpTUdHREJyWVFaNXNYc0dvTjVGYkU4R3Nw?=
 =?utf-8?B?clZmUVdjcWJ5Qmo2QUpad3A0ZkVrbjFlNU5MSnFIMFM0MUJ1a1RkdEViQmx1?=
 =?utf-8?B?OXFINWxJSlBKMnlzWTA3cldtR1h4QndicFNxeTc1R0JuQzZsbFQraC9URVN3?=
 =?utf-8?Q?nmnqy+ocG6InsTtNyzjM9ZVvg?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F7F9F43C2DE17D489885849A3DCB6AF0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e895832-dbc4-45b1-59f4-08ddc89dd6d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2025 21:30:39.6156
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XSUD0BaaAfkPIwRm5AcxUx0Ia0sg4eDKlLlSjNVwa81J9/26NPRtcFEOiOWrRrF+V95O/7jk/h4OLLlypwpTVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4541
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA3LTIxIGF0IDA5OjUwIC0wNTAwLCBUb20gTGVuZGFja3kgd3JvdGU6DQo+
IE9uIDcvMjEvMjUgMDg6MDgsIFRvbSBMZW5kYWNreSB3cm90ZToNCj4gPiBPbiA3LzE3LzI1IDE2
OjQ2LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gPiBUaGlzIHNlcmllcyBpcyB0aGUgbGF0ZXN0IGF0
dGVtcHQgdG8gc3VwcG9ydCBrZXhlYyBvbiBURFggaG9zdCBmb2xsb3dpbmcNCj4gPiA+IERhdmUn
cyBzdWdnZXN0aW9uIHRvIHVzZSBhIHBlcmNwdSBib29sZWFuIHRvIGNvbnRyb2wgV0JJTlZEIGR1
cmluZw0KPiA+ID4ga2V4ZWMuDQo+ID4gPiANCj4gPiA+IEhpIEJvcmlzL1RvbSwNCj4gPiA+IA0K
PiA+ID4gQXMgcmVxdWVzdGVkLCBJIGFkZGVkIHRoZSBmaXJzdCBwYXRjaCB0byBjbGVhbnVwIHRo
ZSBsYXN0IHR3byAndW5zaWduZWQNCj4gPiA+IGludCcgcGFyYW1ldGVycyBvZiB0aGUgcmVsb2Nh
dGVfa2VybmVsKCkgaW50byBvbmUgJ3Vuc2lnbmVkIGludCcgYW5kIHBhc3MNCj4gPiA+IGZsYWdz
IGluc3RlYWQuwqAgVGhlIHBhdGNoIDIgKHBhdGNoIDEgaW4gdjMpIGFsc28gZ2V0cyB1cGRhdGVk
IGJhc2VkIG9uDQo+ID4gPiB0aGF0LsKgIFdvdWxkIHlvdSBoZWxwIHRvIHJldmlldz/CoCBUaGFu
a3MuDQo+ID4gPiANCj4gPiA+IEkgdGVzdGVkIHRoYXQgYm90aCBub3JtYWwga2V4ZWMgYW5kIHBy
ZXNlcnZlX2NvbnRleHQga2V4ZWMgd29ya3MgKHVzaW5nDQo+ID4gPiB0aGUgdG9vbHMvdGVzdGlu
Zy9zZWxmdGVzdHMva2V4ZWMvdGVzdF9rZXhlY19qdW1wLnNoKS7CoCBCdXQgSSBkb24ndCBoYXZl
DQo+ID4gPiBTTUUgY2FwYWJsZSBtYWNoaW5lIHRvIHRlc3QuDQo+ID4gPiANCj4gPiA+IEhpIFRv
bSwgSSBhZGRlZCB5b3VyIFJldmlld2VkLWJ5IGFuZCBUZXN0ZWQtYnkgaW4gdGhlIHBhdGNoIDIg
YW55d2F5DQo+ID4gPiBzaW5jZSBJIGJlbGlldmUgdGhlIGNoYW5nZSBpcyB0cml2aWFsIGFuZCBz
dHJhaWdodGZvcndhcmQpLsKgIEJ1dCBkdWUgdG8NCj4gPiA+IHRoZSBjbGVhbnVwIHBhdGNoLCBJ
IGFwcHJlY2lhdGUgaWYgeW91IGNhbiBoZWxwIHRvIHRlc3QgdGhlIGZpcnN0IHR3bw0KPiA+ID4g
cGF0Y2hlcyBhZ2Fpbi7CoCBUaGFua3MgYSBsb3QhDQo+ID4gDQo+ID4gRXZlcnl0aGluZyBpcyB3
b3JraW5nLCBUaGFua3MhDQo+IA0KPiBTZWUgbXkgY29tbWVudHMgaW4gcGF0Y2ggIzEuIEkgZGlk
bid0IHRlc3Qgd2l0aCBjb250ZXh0IHByZXNlcnZhdGlvbiwgc28NCj4gdGhhdCBiaXQgd2FzIG5l
dmVyIHNldC4gSWYgaXQgd2FzLCBJIHRoaW5rIHRoaW5ncyB3b3VsZCBoYXZlIGZhaWxlZC4NCg0K
SSBhY3R1YWxseSB0ZXN0ZWQgdGhlIHRlc3Rfa2V4ZWNfanVtcC5zaCBpbiBrc2VsZnRlc3QgYXMg
bWVudGlvbmVkIGFib3ZlDQppbiBhIFZNLCBhcyBtZW50aW9uZWQgYWJvdmUuICBJIGdvdCAiIyBr
ZXhlY19qdW1wIHN1Y2NlZWRlZCBbUEFTU10iIHNvIEkNCnRoaW5rIGl0IHdvcmtlZCA6LSkgIEJ1
dCB1bmZvcnR1bmF0ZWx5IEkgZG9uJ3Qga25vdyBob3cgdG8gdGVzdA0KcHJlc2VydmVfY29udGV4
dCBrZXhlYyBpbiBhbnkgb3RoZXIgd2F5Lg0K

