Return-Path: <kvm+bounces-55191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BACA0B2E221
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 18:18:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D69425C561B
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 16:12:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 992E3322C85;
	Wed, 20 Aug 2025 16:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iMLOqu2d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B06E29BDA1;
	Wed, 20 Aug 2025 16:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755706354; cv=fail; b=eYWZyTI7JU5+s8wxVjHPJFkRnPWNgvL7kBF50coDWYb+Xg/iyAQC6GNDbUlbX2npFauH2aib+k+w/FUqUTq4gbyMublfu9TmEMEN9PGTuySyW/a8zUEPq1hvVCXUxQiCca9xbJU/kVrweG2az9M8rgPkiwOjzt4KcZAx+u+Zq5M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755706354; c=relaxed/simple;
	bh=8XftR1tMlChKdAvxfIz/8IiqyF7O+7K2UYCPY+ENbr0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=prXhm9W3w6O2LMDN0Dgcun2+9UUKE2Fwrb7UsS1ZYhOyDJ4gB5UCkL7vL7uGNErR7BxeD+6Aup90NGsEKU61XfDtngxQ8LOSdinrxVk+U/lRfnrnQwHwx1Lio0tptco66DsxxvmuV1jd+TBuPu7YQRBZuL+NgTiHsXUH8PC430k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iMLOqu2d; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755706353; x=1787242353;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8XftR1tMlChKdAvxfIz/8IiqyF7O+7K2UYCPY+ENbr0=;
  b=iMLOqu2dgSkUr+JkD6hJp1jjK2HbEAzMNknyygiFrh5lOE4Ykge4cC9a
   NhWFup/7Y1bm312MlJre8a1I4RKK/APFdx1R7TkvHxzaDzxfSF41nAgD+
   zknRDOHYzDpEiDV7xQQ4UwX41bZhpsMAx+4v0MhwCDTvqWI+AKZw4Jc3/
   8LTcbgZs88oTc86ZJl38ZeL6bmSm2U0CDpVZdGmYtwlp/Rb9NhsILitsY
   eozFHgotEyxLkW7M9ENAqkPodzZR2jTyuU+xgcgkk6xYJM4YUFXllxwYX
   os0lceJ8fyRJ8Zg6/4TvuZ32DD/8WKV5HtAmoV88Xzjx1fax5Own9AQHN
   w==;
X-CSE-ConnectionGUID: FAFKlX9kSESIda67zi4OFw==
X-CSE-MsgGUID: s2iH2gl2TYS2RTLdlJdLEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="57179932"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="57179932"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 09:12:32 -0700
X-CSE-ConnectionGUID: +T/RFYBhT7m1mp0uLcmIZw==
X-CSE-MsgGUID: dLr/z+O0SDOTmmQlnRT0oA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="168115976"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 09:12:32 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 20 Aug 2025 09:12:31 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 20 Aug 2025 09:12:31 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.82)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 20 Aug 2025 09:12:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EtG48O8Tibj2p8qXkJrGp8N3gWxsvFnym9b5XxGlEPF0VzVmWb68KlP+kZXPTJQRgF9G9eHWP5D4CifTQkZk8LMd1SZldp4s4OEKE7yXz/PKi9sEypRrrbiqv3rKqHSd5ZDWlZrzKbr50GigEPllEDCsCG+o4685043T3cjegPkpgdxsPop0QB05oMFi0ffdVeJ46jSxtXFZbbYmUiM2nJwJIY3vK/WxeVN95Q2VCJ3Fi4fTtegvic1iJ1n/mT9QWjc75whCk65yoCk+Qsb/4eSoDQVHEutjdi+4LIlsHiPV0hGTWjKKyoNMXn67znSub8qhX00U+YACv3S2dHbM+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8XftR1tMlChKdAvxfIz/8IiqyF7O+7K2UYCPY+ENbr0=;
 b=dbcb5mnHI1oXHdUT1w0KroLNu7uYWzDE5OoDW00g+HAg8W0aoSai20+oEfGZEsADNCyJ7+m1vEzGqLaH3eVOjtdsQ+uIzcjC5w1m7icWyHK+A9+OLrhcp7Q9jamDoPwD8GJ1WwTJlxJdgF+awGnTq8312k4B/M6jYNOc4MfGr4+3YdrMGagLVPc/t53yiUQD3jG9yCZlV3W8ENsLLZ2vn5hyR4aIAh+XgDA4/p99ehrENtJwfYEGemvx3zt0xwe12QN38yj7N4AliM1dUjVP2X9/wtfPKx8JVR12/dhOHmAo3yCOjtfn6ySmcDNs2X++aOaDf6dsQ+QIWjqpF2v5mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SA0PR11MB7159.namprd11.prod.outlook.com (2603:10b6:806:24b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Wed, 20 Aug
 2025 16:12:29 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%4]) with mapi id 15.20.9031.014; Wed, 20 Aug 2025
 16:12:28 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Hunter, Adrian" <adrian.hunter@intel.com>, Yazen Ghannam
	<yazen.ghannam@amd.com>
CC: Dave Hansen <dave.hansen@linux.intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, Borislav Petkov <bp@alien8.de>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	"x86@kernel.org" <x86@kernel.org>, H Peter Anvin <hpa@zytor.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, "Du,
 Fan" <fan.du@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Gao, Chao"
	<chao.gao@intel.com>
Subject: RE: [PATCH RESEND V2 1/2] x86/mce: Fix missing address mask in
 recovery for errors in TDX/SEAM non-root mode
Thread-Topic: [PATCH RESEND V2 1/2] x86/mce: Fix missing address mask in
 recovery for errors in TDX/SEAM non-root mode
Thread-Index: AQHcESXT796xUqT8/UuG513Iic+TV7RqOyMAgAAGP4CAAAH0gIAAAMYwgAFwbQCAAAJZ0A==
Date: Wed, 20 Aug 2025 16:12:28 +0000
Message-ID: <SJ1PR11MB60831ED23234A274D3DCDD6FFC33A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20250819162436.137625-1-adrian.hunter@intel.com>
 <20250819162436.137625-2-adrian.hunter@intel.com>
 <20250819172846.GA578379@yaz-khff2.amd.com> <aKS5ixhgtCYIvErL@agluck-desk3>
 <4b8b5c89-e8b7-4eec-91eb-1fe43a68cf9c@intel.com>
 <SJ1PR11MB60833C7AE2FA8D8200EA3645FC30A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <2b86c458-f63b-4f74-8fcd-1456ddad4d7a@intel.com>
In-Reply-To: <2b86c458-f63b-4f74-8fcd-1456ddad4d7a@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SA0PR11MB7159:EE_
x-ms-office365-filtering-correlation-id: aa6a8d1d-a2b4-41f8-06f5-08dde0045c17
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aVZpcCtiSklkcVk0NnlZUkNneEwvSUZFSzZTaEIza3ZVUC9EL0xJSnV0VTcy?=
 =?utf-8?B?ZTlxV0RObXE3bXBWcEg4VkorWHNkSmlmQWhpbHorOWhCc2d6eWJTRUFBUW1K?=
 =?utf-8?B?RU5Pd0NnWW9PN1FmQ0kvZnhEY29NcHkzWlptakZwb0FzaEJINTYraFIvdDBL?=
 =?utf-8?B?UDVlNmZKMXAxVWlSem16Slc4OVErWkt5cUVKUTNsSGNmbUtTYWJUTkVNamgx?=
 =?utf-8?B?WlR4SnplQzZzL2xIdFlTb0hUM3hXNUxtTmNsVWU5WUt1OVgvNXJpMkJvVjAv?=
 =?utf-8?B?MGR3VGFrclhDcll6NStkTzU0bTN0VW9lMXcrVFQ3dlFxbVdJVERqZW9VQnNI?=
 =?utf-8?B?b1NiVDI0ZndRK0tzV28xdEdHeWRkdWJRSEM1ampwWWlPdTU5WnR5TzRhQ0Ny?=
 =?utf-8?B?MHN4eTZaZys0RnQvOWM4QUJmREZFckQ2ZzFjZGtxd3hhVDFFRXdGN1B4bmlm?=
 =?utf-8?B?T1MwMUpYaVhrcUw2MWFWMEc4RG1KWHlIbjhXaEY4ZTMxdmtJZGdmTi9qdTZK?=
 =?utf-8?B?M1BRM2VmVUw4QVU2SGVINzM5amJIdzJWeGNEMUo0bVFxZ1B5OGNETXVNeDZj?=
 =?utf-8?B?TXBGSFIvM1AxRUdZR3VXTm9JSE9DQW9pSEJqMG9tOGNrZk5hU3FrODRxN1Vs?=
 =?utf-8?B?ZTA1Mk1LakoyZWtYVEE4T0hodFdEUEhPenE4aHVFNlZ6elJVK3ZuZDY0cDdU?=
 =?utf-8?B?MDYzOEZ5RXJSeEpXNmxUekJJbWpteHdVa3ROdlYwT0ltdVdka1RmM25MOGty?=
 =?utf-8?B?amt0WFI4Tk8wOVJFQ1BGRzM0aDNBN2ZHWkxCZ3JmdUNXMXdhWE9qbEVtM2Jo?=
 =?utf-8?B?NnV3MnlLNzZ5TXdMSFhHV21qcDRLb0ZlLzI5SjF2NUtDR0p0VUxyR2FZT21n?=
 =?utf-8?B?dHMxZlFZUE1mSDNpcGFFQmtFUDdPYXBXSE5GUVdKWjZHQ1BHdVB3T1NTaUR0?=
 =?utf-8?B?NjArZi9YQUc5ZHhvc0VwYlR3eTdOWmtyRnptL3h1c3p5eUIxWStqN2VqVGVk?=
 =?utf-8?B?NGkvNXI1YnIyZzRwT21TR1BHRi9xVEZkVlZVUDBYMkxscUROT3kyRkdDakpr?=
 =?utf-8?B?Skd0ZjBveGRDT3ZBUE45YWFoMndNZnl0eFdhUXNsQm1IRko4aDQrclVMd0dM?=
 =?utf-8?B?bDJZZ3B6SHFRdjFzQzFLZmVWYTF0bXBqeFFiYkN0bVNQdDJGTjEvQjlIT1BL?=
 =?utf-8?B?ejIyU1B6TnVyelFMelJwNG5BdmhmVTYxWGVsQ0pmekF6b1VFVXZXbFMzOHdx?=
 =?utf-8?B?aWFDRjllQVFnc3BJVUMyQTl5RG1yS0hPb2ZZOEF4MmtTbGJSVWR3c214R3Q5?=
 =?utf-8?B?NE5YVW4zSWRLRnFhU2pzd1pGc0hjSmI5a1BvMnlDOTE3cTNEOWNucW1keFBl?=
 =?utf-8?B?ajV2bUZ6SHBmUENTQUZjY0l3VVl1TW9VRTNMQnZ2RStlWUpaLzF3ODFRRFpQ?=
 =?utf-8?B?UklGSllTcjVCWGMxWUdvNWxEdnkvVWdVeE15bnlMK0ExeXBWendQdktINyto?=
 =?utf-8?B?eGcrendHZWVSOENPb2dKTjdoaG55SXRxU3JHTmRoZWJYU0JGVEk0NUFwQ0M3?=
 =?utf-8?B?d1NQU0xwbC9rYmVEOEd5RW1yc1Z2ZGxWYUVaRFozYU0veWFKSHlpZHFJcmRv?=
 =?utf-8?B?aHpaTWFzNk1nSU9MTzhwUFhOY2pDd0FSVS9XcFJaVG8zWmVqWm4yTEZhWnBV?=
 =?utf-8?B?eHduZlF2RENHZ0NEek5neVYway94eTFqdWlxOTlocm5OT3FYN284T05TNWd4?=
 =?utf-8?B?WW5kVW5BWDE3YSs4ZjF5M0txVEhCOFRxcDkyMkc4bUw1bEJvbW5UZVY2bjBG?=
 =?utf-8?B?ZzRNZGpYNFdTRnRiYnN3dE1HcEJxT3JwaUpzSlMvM0lPVmp3aXVqZlFlLzJF?=
 =?utf-8?B?bHg0WS9vVWNMTFdHcEswcjR0ODFnSmQ0cUZaSHZra0hJMTd1Sk9PYXlEQ0tM?=
 =?utf-8?B?eWNrb3Z5VEkyMElPSkJDTzMvNGVhd2NtUEVMcU1WbElyT3QzSm5RYk9KaDNJ?=
 =?utf-8?B?dXJYbENaL1RnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NVB3RUR1czF1UTNUN01ScHdRbHREUHprMkFocmxnTlhjMDB4Qm5pci9EV3ZP?=
 =?utf-8?B?bG5BRUdmOXhEL05FN3pKdkZBTEV4QzNtcWIxQ2RMc05KWjJGS0t6VHZQUElk?=
 =?utf-8?B?NXlQZnYvK0p4QWhsRDM1aTAyMjZzLzVGQU9MWEVsdWtDdytWQ29yWGFzTUk1?=
 =?utf-8?B?bmdSc0dHOVNOYXU0K0RxWjZkUXhhRDU5Y2cxYjEyeFcrUWF4YnBGZVR5WEpC?=
 =?utf-8?B?NGJLODd3NjdoazBXTEpzS05mS0ltb0EwODFMa3VPMnZyZnMxTDgwMFFmRFlR?=
 =?utf-8?B?YkF1N0VhSXVVOE9RcXNPSHBYUGlsaVF0amFmd3ZJZDFMeHBZU0R6Nkc5em5k?=
 =?utf-8?B?RDlxS0FjN3ltTWtrbERzYXo2SEFFai9BUFZDZlVWTVJ3VzEvdTg3UWhhaGNr?=
 =?utf-8?B?QTBhVnArZGFPNG1yY3kwM25vWFBKd05IZmpMMnNycXlwckEySU1lTmdha1Ez?=
 =?utf-8?B?eTg5Vk9oQnp5TERIWXlDTVUwMUFzNUx5cm9aRTBIa2srNzVISWQ1RXptNDJO?=
 =?utf-8?B?MGtxVzZGa3lDOFBTc21sTFNBRkhtTjl5TWVESHFxajFhbWd2SDV2NElmRjBM?=
 =?utf-8?B?UWVIeEFnOEhIVCtmd3JrUTU3V0pUV1V4T3I4d3VjOWhCdGRuMzhBRnRHaWVy?=
 =?utf-8?B?UlpPRXdMV2x5QnFqUHFQMlltbUZKZ25ua0ZZQ0t1Z2VYUHZIVUFhaktJZ3Zh?=
 =?utf-8?B?NWJ2NlU3R2Q1aG4wcGdBU0RqQlRJd3cwMFFSd0gzcmRBZ0c3ZGwrN3VZUUcw?=
 =?utf-8?B?SmhqdnBIakxONzRZRUlSQjBMbERFRng0R1JBYmU1NXhQT1lLYXRmakthaHU1?=
 =?utf-8?B?Vndvc1pld2l3d01OekJORTFWbTB6NFpBbjNQZWNmdUVBVjBkeU5XaDE2bHc0?=
 =?utf-8?B?MllQOXRDbGYxNFpvaUpJQnpBZ1lrdStvNXM1ZnlqREdNdVVsWnYvMkU0TUJp?=
 =?utf-8?B?U1hSVWdKcllRMVVTcUZ3eHQ1R2ZLVVBzZHIvakNoMDFFK2M3ZUwvQnhwWFc4?=
 =?utf-8?B?ajAwcHBaaGE5ZXpzd250SHNxMm5nWlNuVlptTDZHa2tMZEt5WHZ5YndMcEhG?=
 =?utf-8?B?aFZxZGZwUWNkRFhOOWlEK0FIcVlYMXhxencyWndiWkpNSkVDVUJFeHgvbFRP?=
 =?utf-8?B?NWgyWVlhWTQ4VVJEOUg0SHd3K3I2MjdvclNnT0FNL3NvbjIvQjMxUHJNZlJS?=
 =?utf-8?B?cUF0UFdkTXVVQngzQkR3WktiMXpwdjlacGVGRWxZazlxdU9tbk5PNzdDTEp5?=
 =?utf-8?B?T2RhZ2d5aWM5K3RYakx0dEpFbkZOQ24rbmc0dXRvSGsxRmNmamYyZUZnZnNj?=
 =?utf-8?B?OWtkSm4xL1oyNEpINEVlT0Z4V3Y5bFdZMSs4QzdmUGlOaERZT2FkU2puS2or?=
 =?utf-8?B?YXNtV1BnWnZuUjNScnNiaDlCNys0T0FMMGQxN2ZJL1FFa05WUzVkNXg4ZWdY?=
 =?utf-8?B?VFI1MHFJbVBrbEVFaUVwUi85b3B4MmpVM1c0N2ZZOU0rYVBUVkRPRkhYSFlr?=
 =?utf-8?B?T3BnbFg2S1hEcytxNWg0YnRJcVphTTJseWRTbXlwWTI3b290Uk9TVGR0VWFm?=
 =?utf-8?B?cGtHL3dnQkwxOU05R1EwVTBZd05wR1J2UVZyTnN1cURKY1JaYW9jLy9CUjZC?=
 =?utf-8?B?YmNtM0FvV0h6am85RkZvWHZDQ2NSOXhaRnNReENqY01HS1B1SlV0TzQvN1lN?=
 =?utf-8?B?bUpoNmJuZnQ3Slgzc1NJQWxtaCs5V212cjNuNmZkUmFXM0w3QkNTQTdCaW1E?=
 =?utf-8?B?ZFdaa0xERUNCcUVMWHVjRmxTMUxieGhUQ0dNMmhIYTkwK2JIR3lmeXFsTExC?=
 =?utf-8?B?dmRhVTdHeHBDUmd3VVVSV0MzS01rYWxlRm5BUVVyUmMwSE1YS0VzM1hnUXkz?=
 =?utf-8?B?MjlEd1lNL2hTOVlUL1FCVzNLc2xVaVo4UERQT2w0Mjg2YjIvRmwxVkdSd2dN?=
 =?utf-8?B?MEZYbGw3WGYrM2tpVlVFMTh0a3JOaFNLRlpJeHQ5Mk1XMURXVXF4aGN5Y0Nw?=
 =?utf-8?B?eUxNREc3eUphdTdYZnVnb0p6bFYvczF2bXBYT2ZlZ01oNmxjZGFqWk0wbXVX?=
 =?utf-8?B?VHdLL2NzaVBTVlJGbkVOTVNRNVhBaWtLcWllbjliYTd5aXlNMlZRQkJ1a0ZT?=
 =?utf-8?Q?/8/i1/WFMcoxt9GbvD5y5HeOb?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa6a8d1d-a2b4-41f8-06f5-08dde0045c17
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2025 16:12:28.5460
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ruI0etdBWJiLRqrQFGv6QedDaj96cuUmHvdc3SiNXLHiwofWzcZ9u4N40l6M9xkQJx1Eat47gQdEaFfV75Ou7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB7159
X-OriginatorOrg: intel.com

PiA+PiBGb3Igc3RydWN0IG1jZT8gIE1heWJlIHRoYXQgc2hvdWxkIGJlIDIgbmV3IGZpZWxkczoN
Cj4gPj4NCj4gPj4gICAgX191NjQgYWRkcjsgICAgICAgICAgICAgLyogRGVwcmVjYXRlZCAqLw0K
PiA+PiAgICAuLi4NCj4gPj4gICAgX191NjQgbWNpX2FkZHI7ICAgICAgICAgLyogQmFuaydzIE1D
aV9BRERSIE1TUiAqLw0KPiA+PiAgICBfX3U2NCBwaHlzX2FkZHI7ICAgICAgICAvKiBQaHlzaWNh
bCBhZGRyZXNzICovDQo+ID4NCj4gPiBXb3VsZCAiYWRkciIga2VlcCB0aGUgY3VycmVudCAobG93
IGJpdHMgbWFza2VkLCBoaWdoIGJpdHMgcHJlc2VydmVkKSB2YWx1ZT8NCj4NCj4gWWVhaCwgaXQg
d291bGRuJ3QgbWFrZSBtdWNoIHNlbnNlIGlmIHBoeXNfYWRkciB3YXMgdGhlIHNhbWUgYXMgYWRk
ciBhbnl3YXkuDQo+IE5vdCByZWFsbHkgdGhpbmtpbmcNCg0KVGhlIG90aGVyIG9wdGlvbiAoYnV0
IGEgYmFkIG9uZSkgd291bGQgYmU6DQoNCiAgICAgICAgX191NjQgZGVwcmVjYXRlZDsgICAgICAg
Lyogd2FzICJhZGRyIiAqLw0KICAgICAgICAuLi4NCiAgICAgICAgX191NjQgbWNpX2FkZHI7ICAg
ICAgICAgLyogQmFuaydzIE1DaV9BRERSIE1TUiAqLw0KICAgICAgICBfX3U2NCBwaHlzX2FkZHI7
ICAgICAgICAvKiBQaHlzaWNhbCBhZGRyZXNzICovDQoNCndoaWNoIHdvdWxkIGJlIGdvb2QgdG8g
Zm9yY2UgY2xlYW51cCBpbiB0aGUga2VybmVsLCBidXQgYmFkIGZvciBwcmVzZXJ2aW5nDQpBQkkg
KHNpbmNlICJzdHJ1Y3QgbWNlIiBpcyB2aXNpYmxlIHRvIHVzZXIgc3BhY2UgdmlhIC9kZXYvbWNl
bG9nKS4NCg0KLVRvbnkNCg==

