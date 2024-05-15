Return-Path: <kvm+bounces-17432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 088678C675C
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 15:28:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BC8C1C2206D
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 13:28:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AC66127B45;
	Wed, 15 May 2024 13:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XchzQjsv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF183BB4D;
	Wed, 15 May 2024 13:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715779682; cv=fail; b=pneD6lthHQiGFEsAUuMciRBRjcQXlg5raouRK2Xj2xpwWPiAh0/QUIX2ENDezn6j4ND/XFTJjFPAXqq76yulVPCCzNrQTkvxeNjmQqN5MZ10UAoRk44urzwaLpgHbWPwFWYlgsl5r5NVy01FWrHRU2CQX2b3PX9t2riZhKsAsXM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715779682; c=relaxed/simple;
	bh=AQvYw22rdE1fFcqqbEwLv26/Pa5pwlSTDmA+9gsLEAk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JY47R8T2xMjiTYQ546xCi1BkUxIEi/sEvDlJ9il43qU7VvImbBOhz8i2t9MIZRA3qTnPkJB3Q01gmqz9YVsXc7Sa7HVrUDq9gSt/oOchMzF2sOvWhXSeIDEIUL/s5WV0DhwsjWNCrjhWMjE+/g4Bb8TyEayTXZeYz1+CIWAAfJ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XchzQjsv; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715779680; x=1747315680;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AQvYw22rdE1fFcqqbEwLv26/Pa5pwlSTDmA+9gsLEAk=;
  b=XchzQjsv9TRqyzNELlVsw6zfoCgKZMtGeoB24g4OlQcx7FYwB4vACfdU
   wZfDbPGYHUbjgnnNM65oJPYkjwMKTHHQm8Za6k8fWUp2h1z5aZKXxJ8JE
   7xGpx0ncmyBqJJFMrhd5xlhaDu6jElfVhm0MfYuIT4/jv59xJeK9+Px3G
   +8ObKW6/lsF0V5Ts9I6qPv3fUWntB5i0vzvVkalIsd+5fE7sjEminPyg6
   6sj7WHWd2qYAVUthAoNy//50gng6IgNKqZY5YPPbYkx3HlpynJmhRKXkg
   wvLN8swocFgMRSNDYtUwk6Zn7jR5TDsgEyUk/6B8njysKQL1Jqcqbd/2O
   Q==;
X-CSE-ConnectionGUID: az9pUfdzRXOp9hdN7sn4uQ==
X-CSE-MsgGUID: Be2XHoA7TmC1h4a3AjQrZA==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="11699077"
X-IronPort-AV: E=Sophos;i="6.08,161,1712646000"; 
   d="scan'208";a="11699077"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 06:28:00 -0700
X-CSE-ConnectionGUID: ff8PH1JJTBW4zG4pGRylHw==
X-CSE-MsgGUID: Y3TpZ3hRRFi93uR+DTazFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,161,1712646000"; 
   d="scan'208";a="31181950"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 06:27:59 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 06:27:59 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 15 May 2024 06:27:58 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 06:27:58 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 06:27:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T3wgpZR7IcHgOPTLZtq62pR88EKsDWkszWfpoPs8kNYnzPKTszEqfa2oyb3BAZjmHqm1ZcIkl4MACeOH7fDUOS5tPNhqNEjnCaiWRsGxUW9xU9mbs50rpO60/pYp3+OdkIZJxNZ8lcL+mpG/48t5Po8nTMFP5UrXeIREZfEGAztH9KM9/lvfc1zLo930QP/lLo5ZiNeBlOSV2rJDbygtg4fxsPUzFkLlqSVSwvgfrA9BCf0ceW+UTc9+1b1VZHcI95SEJbouUah9w4ryW5MTgo/4LKgzqaU/Oqc+WmGmUorRhcsy9xmyO03YduglCbIWF9XkRZpbvDe2J6DtonYsGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AQvYw22rdE1fFcqqbEwLv26/Pa5pwlSTDmA+9gsLEAk=;
 b=JSMzgjhYnHyuxr9zfwxwVJea6t6gEXIjr26xwlhulb0b9TPTnstuNHX4aYrCIdRiBM/eySA4aNJcLYBZe2rhgnlPzfT4FIpLGfH3S6R2smmArLywL5PV9ly8GPOoneZh08f3Y15nYk8pZIg+lpe5o+QYbArRTZx0C4/erPUq5SAFSVOHePUPzdX5zr8UAuKh1fyH55nJRYxzdEufYdcU4w1y7IrNg3LKjAPfAWg3gkE4/OVLtxwoEVke/+60JruqMO8EO4TysE25Ek2HfwPqPDKbyvfjs+fHHqg10QpKnhyYQIsr65k0hc9W1KCX8xtnIai3REplogUMhEiT33q0mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB5041.namprd11.prod.outlook.com (2603:10b6:303:90::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Wed, 15 May
 2024 13:27:55 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.052; Wed, 15 May 2024
 13:27:53 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>
CC: "sagis@google.com" <sagis@google.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Thread-Topic: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Thread-Index: AQHapmOKCd9Tk+nzHU+YKIOK0Uqx/LGYSpWA
Date: Wed, 15 May 2024 13:27:53 +0000
Message-ID: <621f313d3ab43e3d5988a7192a047de588e4c1f5.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
In-Reply-To: <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO1PR11MB5041:EE_
x-ms-office365-filtering-correlation-id: 84d42a00-8f0f-447e-969c-08dc74e2d368
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?b3RWRW96ZDFKVW9GdEdXazlaTmZGak1lOWN6aVZoQk1tMGU0QkwyckVUV09w?=
 =?utf-8?B?Z0x4c1daVHpSN3hZWUNiR2NKdk83RkRWZmF5Tzh0MVE5UGJ3dnVYV0wrZW9P?=
 =?utf-8?B?clY5bGo2TEVKcXc5N001cGRPSTJTclpSRk1NNHBHbXowcDZVNmo1R2RtQ2pi?=
 =?utf-8?B?UVNPTFo0VVNSMWV6YTVvOXBPKzRwN3U1TFpqbGQrd05BZXk1bUxIalA4WWc3?=
 =?utf-8?B?U20xWnlsWTBZY0VJUTMwcU81QUxqYTExUFZhU2V3QnNmQmR5R1hvNU10ZjZu?=
 =?utf-8?B?cGdaS2ZoNDZhaHJXZGx3eTJFZ0lGYzQraTdoRXlxeVFGVW1LQytodG8vTTZq?=
 =?utf-8?B?b1V6ZDBtMVhaeENXN0RVeTlHMFNUTHdFanRtbTFweFQrVGNZS0FNSWROVEc4?=
 =?utf-8?B?QStvelNoY3VhQ2ZHSDZ0VXRlN1ZoVHRxWlJVYy9PWXNucFNGOXpVdjU4R3Z3?=
 =?utf-8?B?YmVIZEdDL2U4WCtKNjVuVmZRSEpkcFFNRmFiYmJhN2t1eTJndm8ralBpWjdi?=
 =?utf-8?B?cmg2S1RCUVlDZmxFWUlWWERTcnFOZ2N1SXlxY3g4QUR3ZkUyOXpTS3B0QW5B?=
 =?utf-8?B?alZWQlEzT0tZQ1lsV1cwbVMxK2ZBY09pb0VHb1JGZWhRNnhxV2syTTgyQ0Y5?=
 =?utf-8?B?aHVPNmtuZkRaL0g0ZWcxaDRSbElWcTZ4RnA0YVZGbit1anlRL0t5YjRzUTMy?=
 =?utf-8?B?NDluYmhXcElMcFJTc1BvOEc3cGViOW5tNlZscGNpdXdsNmtnVXVRUzhXYjQy?=
 =?utf-8?B?aWl3TEJacU45L2dackw2TXZaOC9NbnVPV3VmTm9IZVA1S2lTMVR5SE9hTlB6?=
 =?utf-8?B?amNoNDZFd2JVU3hGMWY1TUx6SXdyMXZEeGRUNzhiM05Ic25OTERKcEo4eitL?=
 =?utf-8?B?c1pqTklqbVRxaW9iclNPM2dqeDhZQXErNk1teXQwc2hVWml3cG9mSjloQ1J2?=
 =?utf-8?B?TDVuczM0cnBvWmN1bWNaQ211NjZTbHpydU5kZE1MS2N1SlErbGpWT0lTdzc0?=
 =?utf-8?B?a00rUEovTzRJaHdXRFpKL296d01sK3RqM2NacDlCd0xFZmpHVE8zRFJvVWR1?=
 =?utf-8?B?L0NJWU1xY0o3ZTU5OVA5cVYzK0tKRnVkcXBucU5wT2h4L3grbVZ2OFAwd2Y5?=
 =?utf-8?B?YnlUUzdJZUR1N2JSbHJDQ3NRSkx6Tk5YYUxlQ3VqbC8wNElPNXI2aGlqWUFu?=
 =?utf-8?B?TFpUbTZoOEppQUN5d3pZcElFb1FyVkswYkhYWmRlQTgyVHJ1aWxFTWlpcDNJ?=
 =?utf-8?B?cGZJaTFKZmwwNi9FQSt4VVJHYnk1Z0dDM29QMHZDMzlVU3dHWElsZFRLUzlq?=
 =?utf-8?B?VzZZZ3BLVlJCL3NVYnZ1UkJkSzhNVDZjTnBXbHdSSUtWemN6dm04RVIvd2k0?=
 =?utf-8?B?SHFYUXl6UmJ6VnVuT2NBRkpmNVdOb20rd1Q5K2FYZHl3ZCtzMU90cUh2V2ph?=
 =?utf-8?B?cTRITHlibXZBUXNYWng3bWcralp2REczM3pFU1laT2ZmUTAvalBmMHovYkk3?=
 =?utf-8?B?OE1RYWk4NHl1S2lraUxwUEcvSFNaN2ltTm5mcklMeFc5ak5Wem5EWkpiNFVJ?=
 =?utf-8?B?MENkdFZqVjNSZG1DVk11Smc1cTY3eHMvckpnWnB4VnQxNWdSckJKQngvZkJO?=
 =?utf-8?B?b3c1cWtFd1BqbjdNM0VwWFB2TlNwQjVncEtzSzNmdjV3MUVXVzVpVFlqcnl0?=
 =?utf-8?B?YzZRYWRvTHAyQzdUTjBhUE9QVUxoNzBrbGtzejNCNkwwZEtvcHo0WXN3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eGYzV1hrRWZlOUxWYXRnbHpDRUZ1bzNVTXJidDlwTlJhOVVKUFJNTW1sNHlZ?=
 =?utf-8?B?UDVab3J5Wm1sVVQ5N0pjQU9VNTZuL0dZZ1JmNis2QzFuTnJrRCtGMzZ2dkZv?=
 =?utf-8?B?N0NuRXNUK2Q3VnNhVy9XVEltYzMrRXdtWFk0OXR5MTdUUzlkeFo1anBuRWxP?=
 =?utf-8?B?Y3R4cG80Q1NpaGVtcWtYbE92clp6STdGT2RwV0pNVjdHdDB1WVVHeStKaWpj?=
 =?utf-8?B?STVBa1dGRUpVbWtpUVhjblNCdzNoNU5obkg0K0Y2c2pYbjN3VHBoaWJTbG9N?=
 =?utf-8?B?SXVPTTYxUytjazdKYTMvTGkvSG8xa1FvbjlVNGwraG5wQ1UySFZVTzZBMDg2?=
 =?utf-8?B?Wjl2a3J4UG5ySm95d1JaUjJXdHhWUHBFTys2L3Z6MWdwRnZOc3puY3VKVUEy?=
 =?utf-8?B?S1NlNE5nRUY2MFpKbzZxaHZ2alB0dEtaNXZ6Rmw5OWU0cUoyVGR1cGJEZVNq?=
 =?utf-8?B?NThWOFBDRUtSTlNoRmpjUHpscHVYKzNRclgzSlZQcGh1aGV6eStONEw5SFBD?=
 =?utf-8?B?ait0ODJtNU40ZUhxNDVMZC81b2h5QjZWUWd4bit5STR0N1RaZDd3S1ZuWG9z?=
 =?utf-8?B?OUNMaVJWUlZpTm10ZDlqdlpBZFkvK0kxNjdhbUpXUkwzRnFSK3V3RitCdmRk?=
 =?utf-8?B?NHd2akI2M1JLMWlDcjIycFRlckRkTUpoMHZXUlVGdkRXSDBhemQ5M3ZPZ3lW?=
 =?utf-8?B?YTk1elZ1ZDZyTzlxUTA5cTN2WHg0ZDBkOWJBNXAvOXBtRVRqNUthdFllQnJj?=
 =?utf-8?B?UldEWm4vWDJhVXRvNlpaSTI0amdqZmlwWkhGYlA1OEdtUS93ay9tMWo2RzZa?=
 =?utf-8?B?YjM0dFF2Y0NmYldFL3RuTkowbTZDajVSRXdsTzZtY29JS29FdnBrU0xGVkFJ?=
 =?utf-8?B?MGZNMVJSTldEOWQrSlpjY29UTWh2UitPUjBCbUJtYzRSYzYxaWJrZ2tzdVl6?=
 =?utf-8?B?U0tDY0RNNzA2Zk5LMWRINW9RLzdRSElKNFRXWEhBaWIvTXJJSXdRQU10dndM?=
 =?utf-8?B?Wk85Zmg5SlMydlRBNTJsTjYzMDlXcWNHUHdBWjg4Rkhka0w4enIxRHFnTnpK?=
 =?utf-8?B?YXNuZ0NNdmM4SkFqdGNabkloRTRVazByTFhCWUFlSG9peGhlZzB1dHd3NVQ5?=
 =?utf-8?B?RWM0aU5Xc0xHKzRUcGdEQ2RFRHZPRWlpUnV2THdObmQrdXc2UjRmaXVVdWgx?=
 =?utf-8?B?TGhOeEtyYnprRk1yQWdiUXhVTkd3UGVYMUtsZFlOZXJHMW92ZWZzeW5TbW15?=
 =?utf-8?B?VGdvdUNJVFFuQTZjSGplWmFuT0xMbUpreFBQYUVTN3ZrYmxIaVJnYTMxZlAz?=
 =?utf-8?B?Ny85M3hGa3dNeFNLME9FS0NiQk00V1JQOVNoNVJqMlhlb0VOS1pNWk5nbmgw?=
 =?utf-8?B?UnJqemJJRi8vS1pqcGxtV2MvWlp2bVZCazh3U3poNDlRRWY0bDN3ZmlnU0N6?=
 =?utf-8?B?YWRKQ1RXTW5pSnN2d3BKVWtFNzl1bXZMczZ1aWdMQ1BDd0VITE01dkZPYit3?=
 =?utf-8?B?bk1McUJIeGFKZUtJZVlTcVNhT3ViR1FObmVvcEM2c1dhSjYxVEVQOFA3RjRr?=
 =?utf-8?B?Nk9GZDJES0VzbXhCcnM2RWVBQjhaUUZkS0t4RmJsdW1yWW5uWVZrVFR6N1Rw?=
 =?utf-8?B?emVNZUZjTGV2UUFkeUpCemNQZmF0UEJtZ0VscVd0MFRHNnExNUE3Ni9PMVZI?=
 =?utf-8?B?LzZSVC9XSXhmSHZpbUZrdm9lMDNybVI5cktyTkpqaGpDbWNiUUhzK0U1Vmwy?=
 =?utf-8?B?MXY4cmFkd1dUQ3J3L3lxRnFZdysybGV6aWNWeldxd3BYbk1KbWkwNVViWTdO?=
 =?utf-8?B?ZEV6eG1tb28rYTVLQzJNbnJ0T2M5UE9SVmptUFNEcXRVd3hCczFvc2gwM1Ez?=
 =?utf-8?B?cGJZOS9HNHMwVzFQVVkyT216eHhyZ0lGdnV0ZXROdFJDYmhhdmxNcnhlYVEr?=
 =?utf-8?B?UVp6QTBTcmdIRE5OR0NCUHNTY251TWRiM01vLzZnN3ZSRWZsb3RQajExVUc0?=
 =?utf-8?B?UWJTRlFtM05Ybjh2SWhYODZyWlBzTTMxb3pZU21VdmpWaDVXL0xLMk9kUElm?=
 =?utf-8?B?RGQ4UmFGeVZ2RG9ESWprcGRYaXpvdWZoY1BvZ3NDWXVkUUxpVS9kVGFDUCtP?=
 =?utf-8?Q?YYAbDhb5vrJq0ye2dBQlV8IMi?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5E181DA7C998D5418FCD9C3D9D5E9709@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84d42a00-8f0f-447e-969c-08dc74e2d368
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2024 13:27:53.7832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DzbKedz5X1ADLfV+GOtSgUBSKrpWq8mBanpQhOnnI9fVqZwG6SEjiFoXqFZj5fL2Bsqi/u+yZ5clwDeXgsoyiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5041
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA1LTE0IGF0IDE3OjU5IC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gV2hlbiB2aXJ0dWFsaXppbmcgc29tZSBDUFUgZmVhdHVyZXMsIEtWTSB1c2VzIGt2bV96YXBf
Z2ZuX3JhbmdlKCkgdG8gemFwDQo+IGd1ZXN0IG1hcHBpbmdzIHNvIHRoZXkgY2FuIGJlIGZhdWx0
ZWQgaW4gd2l0aCBkaWZmZXJlbnQgUFRFIHByb3BlcnRpZXMuDQo+IA0KPiBGb3IgVERYIHByaXZh
dGUgbWVtb3J5IHRoaXMgdGVjaG5pcXVlIGlzIGZ1bmRhbWVudGFsbHkgbm90IHBvc3NpYmxlLg0K
PiBSZW1hcHBpbmcgcHJpdmF0ZSBtZW1vcnkgcmVxdWlyZXMgdGhlIGd1ZXN0IHRvICJhY2NlcHQi
IGl0LCBhbmQgYWxzbyB0aGUNCj4gbmVlZGVkIFBURSBwcm9wZXJ0aWVzIGFyZSBub3QgY3VycmVu
dGx5IHN1cHBvcnRlZCBieSBURFggZm9yIHByaXZhdGUNCj4gbWVtb3J5Lg0KPiANCj4gVGhlc2Ug
Q1BVIGZlYXR1cmVzIGFyZToNCj4gMSkgTVRSUiB1cGRhdGUNCj4gMikgQ1IwLkNEIHVwZGF0ZQ0K
PiAzKSBOb24tY29oZXJlbnQgRE1BIHN0YXR1cyB1cGRhdGUNCj4gNCkgQVBJQ1YgdXBkYXRlDQo+
IA0KPiBTaW5jZSB0aGV5IGNhbm5vdCBiZSBzdXBwb3J0ZWQsIHRoZXkgc2hvdWxkIGJlIGJsb2Nr
ZWQgZnJvbSBiZWluZw0KPiBleGVyY2lzZWQgYnkgYSBURC4gSW4gdGhlIGNhc2Ugb2YgQ1JPLkNE
LCB0aGUgZmVhdHVyZSBpcyBmdW5kYW1lbnRhbGx5IG5vdA0KPiBzdXBwb3J0ZWQgZm9yIFREWCBh
cyBpdCBjYW5ub3Qgc2VlIHRoZSBndWVzdCByZWdpc3RlcnMuIEZvciBBUElDVg0KPiBpbmhpYml0
IGl0IGluIGZ1dHVyZSBjaGFuZ2VzLg0KPiANCj4gR3Vlc3QgTVRSUiBzdXBwb3J0IGlzIG1vcmUg
b2YgYW4gaW50ZXJlc3RpbmcgY2FzZS4gU3VwcG9ydGVkIHZlcnNpb25zIG9mDQo+IHRoZSBURFgg
bW9kdWxlIGZpeCB0aGUgTVRSUiBDUFVJRCBiaXQgdG8gMSwgYnV0IGFzIHByZXZpb3VzbHkgZGlz
Y3Vzc2VkLA0KPiBpdCBpcyBub3QgcG9zc2libGUgdG8gZnVsbHkgc3VwcG9ydCB0aGUgZmVhdHVy
ZS4gVGhpcyBsZWF2ZXMgS1ZNIHdpdGggYQ0KPiBmZXcgb3B0aW9uczoNCj4gIC0gU3VwcG9ydCBh
IG1vZGlmaWVkIHZlcnNpb24gb2YgdGhlIGFyY2hpdGVjdHVyZSB3aGVyZSB0aGUgY2FjaGluZw0K
PiAgICBhdHRyaWJ1dGVzIGFyZSBpZ25vcmVkIGZvciBwcml2YXRlIG1lbW9yeS4NCj4gIC0gRG9u
J3Qgc3VwcG9ydCBNVFJScyBhbmQgdHJlYXQgdGhlIHNldCBNVFJSIENQVUlEIGJpdCBhcyBhIFRE
WCBNb2R1bGUNCj4gICAgYnVnLg0KPiANCj4gV2l0aCB0aGUgYWRkaXRpb25hbCBjb25zaWRlcmF0
aW9uIHRoYXQgbGlrZWx5IGd1ZXN0IE1UUlIgc3VwcG9ydCBpbiBLVk0NCj4gd2lsbCBiZSBnb2lu
ZyBhd2F5LCB0aGUgbGF0ZXIgb3B0aW9uIGlzIHRoZSBiZXN0LiBQcmV2ZW50IE1UUlIgTVNSIHdy
aXRlcw0KPiBmcm9tIGNhbGxpbmcga3ZtX3phcF9nZm5fcmFuZ2UoKSBpbiBmdXR1cmUgY2hhbmdl
cy4NCj4gDQo+IExhc3RseSwgdGhlIG1vc3QgaW50ZXJlc3RpbmcgY2FzZSBpcyBub24tY29oZXJl
bnQgRE1BIHN0YXR1cyB1cGRhdGVzLg0KPiBUaGVyZSBpc24ndCBhIHdheSB0byByZWplY3QgdGhl
IGNhbGwuIEtWTSBpcyBqdXN0IG5vdGlmaWVkIHRoYXQgdGhlcmUgaXMgYQ0KPiBub24tY29oZXJl
bnQgRE1BIGRldmljZSBhdHRhY2hlZCwgYW5kIGV4cGVjdGVkIHRvIGFjdCBhY2NvcmRpbmdseS4g
Rm9yDQo+IG5vcm1hbCBWTXMgdG9kYXksIHRoYXQgbWVhbnMgdG8gc3RhcnQgcmVzcGVjdGluZyBn
dWVzdCBQQVQuIEhvd2V2ZXIsDQo+IHJlY2VudGx5IHRoZXJlIGhhcyBiZWVuIGEgcHJvcG9zYWwg
dG8gYXZvaWQgZG9pbmcgdGhpcyBvbiBzZWxmc25vb3AgQ1BVcw0KPiAoc2VlIGxpbmspLiBPbiBz
dWNoIENQVXMgaXQgc2hvdWxkIG5vdCBiZSBwcm9ibGVtYXRpYyB0byBzaW1wbHkgYWx3YXlzDQo+
IGNvbmZpZ3VyZSB0aGUgRVBUIHRvIGhvbm9yIGd1ZXN0IFBBVC4gSW4gZnV0dXJlIGNoYW5nZXMg
VERYIGNhbiBlbmZvcmNlDQo+IHRoaXMgYmVoYXZpb3IgZm9yIHNoYXJlZCBtZW1vcnksIHJlc3Vs
dGluZyBpbiBzaGFyZWQgbWVtb3J5IGFsd2F5cw0KPiByZXNwZWN0aW5nIGd1ZXN0IFBBVCBmb3Ig
VERYLiBTbyBrdm1femFwX2dmbl9yYW5nZSgpIHdpbGwgbm90IG5lZWQgdG8gYmUNCj4gY2FsbGVk
IGluIHRoaXMgY2FzZSBlaXRoZXIuDQo+IA0KPiBVbmZvcnR1bmF0ZWx5LCB0aGlzIHdpbGwgcmVz
dWx0IGluIGRpZmZlcmVudCBjYWNoZSBhdHRyaWJ1dGVzIGJldHdlZW4NCj4gcHJpdmF0ZSBhbmQg
c2hhcmVkIG1lbW9yeSwgYXMgcHJpdmF0ZSBtZW1vcnkgaXMgYWx3YXlzIFdCIGFuZCBjYW5ub3Qg
YmUNCj4gY2hhbmdlZCBieSB0aGUgVk1NIG9uIGN1cnJlbnQgVERYIG1vZHVsZXMuIEJ1dCBpdCBj
YW4ndCByZWFsbHkgYmUgaGVscGVkDQo+IHdoaWxlIGFsc28gc3VwcG9ydGluZyBub24tY29oZXJl
bnQgRE1BIGRldmljZXMuDQo+IA0KPiBTaW5jZSBhbGwgY2FsbGVycyB3aWxsIGJlIHByZXZlbnRl
ZCBmcm9tIGNhbGxpbmcga3ZtX3phcF9nZm5fcmFuZ2UoKSBpbg0KPiBmdXR1cmUgY2hhbmdlcywg
cmVwb3J0IGEgYnVnIGFuZCB0ZXJtaW5hdGUgdGhlIGd1ZXN0IGlmIG90aGVyIGZ1dHVyZQ0KPiBj
aGFuZ2VzIHRvIEtWTSByZXN1bHQgaW4gdHJpZ2dlcmluZyBrdm1femFwX2dmbl9yYW5nZSgpIGZv
ciBhIFRELg0KPiANCj4gRm9yIGxhY2sgb2YgYSBiZXR0ZXIgbWV0aG9kIGN1cnJlbnRseSwgdXNl
IGt2bV9nZm5fc2hhcmVkX21hc2soKSB0bw0KPiBkZXRlcm1pbmUgaWYgcHJpdmF0ZSBtZW1vcnkg
Y2Fubm90IGJlIHphcHBlZCAoYXMgaW4gVERYLCB0aGUgb25seSBWTSB0eXBlDQo+IHRoYXQgc2V0
cyBpdCkuDQo+IA0KPiBMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNDAzMDkw
MTA5MjkuMTQwMzk4NC02LXNlYW5qY0Bnb29nbGUuY29tLw0KPiBTaWduZWQtb2ZmLWJ5OiBSaWNr
IEVkZ2Vjb21iZSA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+DQo+IC0tLQ0KPiBURFggTU1V
IFBhcnQgMToNCj4gIC0gUmVtb3ZlIHN1cHBvcnQgZnJvbSAiS1ZNOiB4ODYvdGRwX21tdTogWmFw
IGxlYWZzIG9ubHkgZm9yIHByaXZhdGUgbWVtb3J5Ig0KPiAgLSBBZGQgdGhpcyBLVk1fQlVHX09O
KCkgaW5zdGVhZA0KPiAtLS0NCj4gIGFyY2gveDg2L2t2bS9tbXUvbW11LmMgfCAxMSArKysrKysr
KysrLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkN
Cj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbW11L21tdS5jIGIvYXJjaC94ODYva3Zt
L21tdS9tbXUuYw0KPiBpbmRleCBkNWNmNWIxNWExMGUuLjgwODgwNWIzNDc4ZCAxMDA2NDQNCj4g
LS0tIGEvYXJjaC94ODYva3ZtL21tdS9tbXUuYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vbW11L21t
dS5jDQo+IEBAIC02NTI4LDggKzY1MjgsMTcgQEAgdm9pZCBrdm1femFwX2dmbl9yYW5nZShzdHJ1
Y3Qga3ZtICprdm0sIGdmbl90IGdmbl9zdGFydCwgZ2ZuX3QgZ2ZuX2VuZCkNCj4gIA0KPiAgCWZs
dXNoID0ga3ZtX3JtYXBfemFwX2dmbl9yYW5nZShrdm0sIGdmbl9zdGFydCwgZ2ZuX2VuZCk7DQo+
ICANCj4gLQlpZiAodGRwX21tdV9lbmFibGVkKQ0KPiArCWlmICh0ZHBfbW11X2VuYWJsZWQpIHsN
Cj4gKwkJLyoNCj4gKwkJICoga3ZtX3phcF9nZm5fcmFuZ2UoKSBpcyB1c2VkIHdoZW4gTVRSUiBv
ciBQQVQgbWVtb3J5DQo+ICsJCSAqIHR5cGUgd2FzIGNoYW5nZWQuICBURFggY2FuJ3QgaGFuZGxl
IHphcHBpbmcgdGhlIHByaXZhdGUNCj4gKwkJICogbWFwcGluZywgYnV0IGl0J3Mgb2sgYmVjYXVz
ZSBLVk0gZG9lc24ndCBzdXBwb3J0IGVpdGhlciBvZg0KPiArCQkgKiB0aG9zZSBmZWF0dXJlcyBm
b3IgVERYLiBJbiBjYXNlIGEgbmV3IGNhbGxlciBhcHBlYXJzLCBCVUcNCj4gKwkJICogdGhlIFZN
IGlmIGl0J3MgY2FsbGVkIGZvciBzb2x1dGlvbnMgd2l0aCBwcml2YXRlIGFsaWFzZXMuDQo+ICsJ
CSAqLw0KPiArCQlLVk1fQlVHX09OKGt2bV9nZm5fc2hhcmVkX21hc2soa3ZtKSwga3ZtKTsNCj4g
IAkJZmx1c2ggPSBrdm1fdGRwX21tdV96YXBfbGVhZnMoa3ZtLCBnZm5fc3RhcnQsIGdmbl9lbmQs
IGZsdXNoKTsNCj4gKwl9DQo+ICANCj4gIAlpZiAoZmx1c2gpDQo+ICAJCWt2bV9mbHVzaF9yZW1v
dGVfdGxic19yYW5nZShrdm0sIGdmbl9zdGFydCwgZ2ZuX2VuZCAtIGdmbl9zdGFydCk7DQoNCmt2
bV96YXBfZ2ZuX3JhbmdlKCkgbG9va3MgYSBnZW5lcmljIGZ1bmN0aW9uLiAgSSB0aGluayBpdCBt
YWtlcyBtb3JlIHNlbnNlDQp0byBsZXQgdGhlIGNhbGxlcnMgdG8gZXhwbGljaXRseSBjaGVjayB3
aGV0aGVyIFZNIGlzIFREWCBndWVzdCBhbmQgZG8gdGhlDQpLVk1fQlVHX09OKCk/DQoNCg==

