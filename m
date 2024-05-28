Return-Path: <kvm+bounces-18221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 130768D219E
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 18:28:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB0B32869FB
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 16:28:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D0EC17332A;
	Tue, 28 May 2024 16:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jfUxY/pb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDC4172BCE;
	Tue, 28 May 2024 16:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716913671; cv=fail; b=YqkLMHCW5JkR5xrumhrpXgGJAScC9lDyy/ns+lJ7Laha5lBDTRNRK1Muq2D3Y2ZB129bUckVTAKT/G6LOMdraF9XhZJrNAtbeAhC5bmnxecJzoMGCt8jUFaxyiZlutiAWr2i0V1x5euxjyi5tfN9f/HEHfRMbGhW506gy1jXcrc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716913671; c=relaxed/simple;
	bh=zb8c8fJ+LhI1DAg+D+eeSWXuRJBdScVPU72VR6nNENg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=engxp5QAUcmg5vKAf3at6+v3WQCZuvgpqUUT7CIioEXn/Yu9iSVvgQNEus6iAX9Vb3mpJgHG10diMvsItOyTFqMO3aZ5FwoMqPG/9q/8D6ATMcfsB0I7alouI9ln86QbvhPTGFtdND21tbDRVpavtTy0TWZUEOa0TjKXJHhWJGE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jfUxY/pb; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716913670; x=1748449670;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zb8c8fJ+LhI1DAg+D+eeSWXuRJBdScVPU72VR6nNENg=;
  b=jfUxY/pb5D/AQQYo6vIEBAyi0tFAkXzpaGzsft+Y0qrI8FfiajnykT24
   +6n6yMY9ucDnwZ0IRfi7h8sFBUdJWFeLiGbgv4HxNngt1ra1sjcZq6qbD
   NgCH39ZpOqT9bXwOUQhdJjTN19aWHJM5PBO+X7iWDAo0XLP0BmQxWq16h
   SxXI7TdK1hrBfKCvj4UdAuJ6i25tStewOhedO8pOK8hLWvdwQqERbMZRy
   V4zu8iPAcbSP26sUgoZxYj1is5h4Jy2OHHNLYBeLM3NPfgoAIGj6yA+bm
   TqRLHqp0hSc1sb8jAtRbf0CIisHgoqDZ4cyFTaEvxG+fE8IvcTNEvzi8k
   w==;
X-CSE-ConnectionGUID: fGgnVvgNQcmZOdX55+E88g==
X-CSE-MsgGUID: vXmD65k9TgagNDVyYp99Cg==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="24400724"
X-IronPort-AV: E=Sophos;i="6.08,195,1712646000"; 
   d="scan'208";a="24400724"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 09:27:49 -0700
X-CSE-ConnectionGUID: FhFPtWMvT+6t395F4omXKw==
X-CSE-MsgGUID: jxwUe7e0Tnm9ZFpkSai/Ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,195,1712646000"; 
   d="scan'208";a="72565879"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 May 2024 09:27:49 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 09:27:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 09:27:48 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 28 May 2024 09:27:48 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 28 May 2024 09:27:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lkhMRwwLwaHA2XP7xEg4eRCHi3qWNJZu5dlo0bvDqyZfcO1158LvRuCUuAZnBW5Bf7lT/fmaDmc6lczcyCtKFj6YoE6CejQ5dSlub9Sep6s0NHudHKI6mNgAgx/dGPY1mBb7HK2iHOlvFGrEA6wyRH0xYUcCVAb7nDJ/D4hn5CFpc2jRZ+d8QGG6rUZNb0bkHFU6XrCCnunUkdIgGIkrcaTsdgEYt6r4ZNljuwsm+uOXxOzMSJAUJ2SA0TaeiQ0YfBImD0ZU6E3JdT3i87aFkjXg946SKfifRwVa+Hx0ePo2IzZ3MG9WmmAKyuU+Ejv1P68uIjqGzV12qA+4uUogvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zb8c8fJ+LhI1DAg+D+eeSWXuRJBdScVPU72VR6nNENg=;
 b=nMBmg1npcJK69E1HDZY0JlEbDsYfPID3Y2iAo929TFqmE2MMPnt0OwvMSDaaJOkgmAriUDJGm0PxdfDTc/g7wS1DElBURG7h4lpfC3PY2083kmRP10887xiAtdTjLn6VAfLKaOf3ydJlCeaPHqIf41VONPA+9jJai2NSgYDiLfV4Ofv8JHfWK0V1bPD6RtdcrCo9iGNlT6R803Fur1/LqS31Oauhze1UAVU90lvIZoDmKkvIm6OGYLQQqiRBBNfJj6AsqUXuUGmVGrPXM13OlNDExtW5Xj/aycBe6SbL45FrbcB0FxgSDdInNl3/b8mF3Y6DKri0zO0AiwOT+GPbNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BL1PR11MB5253.namprd11.prod.outlook.com (2603:10b6:208:310::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Tue, 28 May
 2024 16:27:46 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7611.030; Tue, 28 May 2024
 16:27:46 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "dmatlack@google.com" <dmatlack@google.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Topic: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Index: AQHapmNTP3XGfqhyyEaM/KHu10XBU7GZCeQAgAAJxQCAAAs0AIAADfKAgACpkgCAADtVgIAAM8qAgABzkACAAGxrAIAAmmaAgAAQyQCABP6CgIABBVgAgAAS3ACAAfwwgIAACfeAgAAKoACAAADagIAAAs8AgAE1PACAAOGegIAG2ICA
Date: Tue, 28 May 2024 16:27:45 +0000
Message-ID: <31a2b098797b3837597880d5827a727fee9be11e.camel@intel.com>
References: <20240517191630.GC412700@ls.amr.corp.intel.com>
	 <20240520233227.GA29916@ls.amr.corp.intel.com>
	 <a071748328e5c0a85d91ea89bb57c4d23cd79025.camel@intel.com>
	 <20240521161520.GB212599@ls.amr.corp.intel.com>
	 <20240522223413.GC212599@ls.amr.corp.intel.com>
	 <9bc661643e3ce11f32f0bac78a2dbfd62d9cd283.camel@intel.com>
	 <20240522234754.GD212599@ls.amr.corp.intel.com>
	 <4a6e393c6a1f99ee45b9020fbd2ac70f48c980b4.camel@intel.com>
	 <20240523000100.GE212599@ls.amr.corp.intel.com>
	 <35b63d56fe6ebd98c61b7c7ca1680da91c28a4d0.camel@intel.com>
	 <20240524075519.GF212599@ls.amr.corp.intel.com>
In-Reply-To: <20240524075519.GF212599@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BL1PR11MB5253:EE_
x-ms-office365-filtering-correlation-id: f093dac8-b97d-4f58-06a0-08dc7f331b6d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?eFhUUUtKTU5JTFo4SWUySVB3MnhRMERTTjR2N0lySnBjeWhOSEJJY0ROUFZT?=
 =?utf-8?B?QmFRQkVnWFhEVUxWRzgyOC9sUkRxcmRTWUZiaGphRUJVKy9Zb2RWcXM4a3dI?=
 =?utf-8?B?MXUxWWdBSmU2aHdsSEVMTUVvOFFGaGl3RnlJRm5QWEd3cnBqcWU0YUduMmNq?=
 =?utf-8?B?Q2ltUDFVdFMvbm9lUkJZeFBkQk9mRHdzSkxHelFzRFJWcUoxRVQyODc1blJ3?=
 =?utf-8?B?dUNNNWRrQ0diZzlKSWNxZFY3UU9CZVljdFMvZ1M1OVBsTkN6dDIwOEREOTRp?=
 =?utf-8?B?WTNGSTNERU9SSVRGdkdXK2F4bmZaMk5JTUswVzJoeFZZSTNSMGVpMWNuNG5Y?=
 =?utf-8?B?UXc2UEd1dG1Eeko3VHJ3T0x5ZFpwMHF2Zks2cWZtUXZMQ2VNdUNUMWVMTVg4?=
 =?utf-8?B?U1BNcTBEY1paTlNGSUx0c2VTRGFka0ZaYXB6SE05WHJ0Ym9IYkN2TzFYQkEz?=
 =?utf-8?B?WDJ0STdxUzBxL3BVR2tvdlRmSFpwZnRRWE1XUCtPaUZNNGQ5dVFkYndGb3RY?=
 =?utf-8?B?UjNtcEs0WWcvU2sxWXZBbFF0TmVmV3EvSFNva0U2bFVMblR4WEVuOXZvSjhK?=
 =?utf-8?B?OU1IMkdhdGxLWmo1RlplR0ltays2VXo1SjhUem5XeGhrVnJPVHg2SUVwTXF2?=
 =?utf-8?B?bFJ3MXByK2tNa2VXUUVvbGljVHJHUSt1d3REWDF1RjN5MnNJcjd2anpYRlpL?=
 =?utf-8?B?U2MrVjJhT0YyUVlWY3N0N0xiNVMrZjNhcktpQ1I4S2lNOFdFemZYUmlXTk9E?=
 =?utf-8?B?QjYvdTYrMFk5aFp0dzZsbU9ySUFwanZMbnQwRFg2Slcxbzlic0p1bS9jMm9Q?=
 =?utf-8?B?Wm9GcHZMMXE3S0YrcTNjcGl0amt2NFU0TDJObCtyN0pQM3JBMGNLSGxBRzh6?=
 =?utf-8?B?cGw2ZVEzekFLK0JoN1hlNHMvUkF3KzFsbWtvNDNlVXFJcVBSMS82dmlwR2dB?=
 =?utf-8?B?SlRLNnkvTnZkd0M5dDlzV2U1TlBXcE5PaEZsQjNhMitxZ1BmUHRicHh6V3cy?=
 =?utf-8?B?ODRqNmN1UXZudlBWbXYrMmxKemJoUCtwNEhZbkFFY1E4L2IxVjJtV1Nidmly?=
 =?utf-8?B?eCs1WHdaT0lyNFAwM1dTb1d5VkUwS2dPWXVUdDJhL3lFTjU5MWpPZlNZRG5t?=
 =?utf-8?B?YXUvcmdnaXJreW16TTNYTThsQWppZzBhL2hTZXhPcXcvc0sxMksybm16YXdy?=
 =?utf-8?B?M2dGUzFXOGNyYVB6OVppRXowUVJJM0Z5a25KQkxIWGpWTHlNVmFJeklGOG1Q?=
 =?utf-8?B?TlAvN1ZGbzNlalNxL3JNMnFsbFlyQzRhc0RjUlZ4R2J5RUYyYXFSQ1cwNUZj?=
 =?utf-8?B?M1hyZXVuRTYwcFBNVGRGdi9GQ1hRa1Q4cms1OTVPajhMVzJRb3I0S0tsYTFY?=
 =?utf-8?B?SWs2ME12Nzg5YlRJYzUxUWFJQmZMemJNWHYyeTA0WmNITlVHaGdFTmUzeVNO?=
 =?utf-8?B?bHdtbVcvSzFKMHlGblNFbDIyUGlMTFdOeUs0d2VDQVdEelVqVnhFa08vU2NY?=
 =?utf-8?B?Z3M5bmE4SGdIRThEMXFBS2wrbGtSdTdZZW1mWmRLejIzVnBmemRmSHE5Q3Rp?=
 =?utf-8?B?ajVOd2RUaURWeG84Tnl4dFZyb2dETnJnclI2ams2d09QOXlOWTNzeDZBcWQ0?=
 =?utf-8?B?VTJYTXZXQzBUaWU0MzhmSC9LMkdTME14U2RHN1RGekZ5SGE3UlNTdzFLclA2?=
 =?utf-8?B?WVhqc3l4UlZTaUhBWGJxNk4zSWJqU2x6cHJFQjhqNFE0ZGFwc05uYzExSlU5?=
 =?utf-8?B?Wm9OS1UvZ3ZrSTFzRmV1RlJBeitVS200dGIySXNGL0RYRmJCUWhvdmIyaHN1?=
 =?utf-8?B?SVdQY3VMdkcvdUF2R2hldz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RkVsOWJRQXNXWXJySUxyUWFGMC9OREdPUWwzS1hMWVZkZTZTSGFRWk9lOE5w?=
 =?utf-8?B?UVZYYkZxUHVYUWFKRUs5WTAxQTcyRjhoVmRpSmJvdmJRSm5QYkxKVnNFZTRj?=
 =?utf-8?B?bjJxak03elphSEMrc2NOZFhFTEZCVytYTUlsZlMxakNEWitLZU5GSGdVSEp1?=
 =?utf-8?B?NjE3UFlKaHVtcFA3UlZIOXlaM09CazhiWFVUNUlTc0M0TVJyOWJsK1lQbXFs?=
 =?utf-8?B?aEJIQ0ttbU9kWTdCcHM5SmRzWUQvMklnM2tPMHZKMzhySkVCWkxQZm1aZFVY?=
 =?utf-8?B?VWFPaWtRU2dFcm8zQ3p0YVJjcDE5V0hPVzIwSk9HRi9ib3N3OW50UnN6emlx?=
 =?utf-8?B?UTRoZ250Q1ltekJEbE94TkIyeEtxWmhwS1Nic0YzK2xPNUQwNkxJRmRudU5Y?=
 =?utf-8?B?SnYvM3dFRmIzU2x4TVZwekpDWWVqRnBxOXpYdE4xYm5KbGw4a3pzN1M5MTMz?=
 =?utf-8?B?VmszSkYrVVk2ZmhCYllLUlBVeU1zdnJpbGU4djRDSlM1NUQ5bWg5NlJJYTkw?=
 =?utf-8?B?YkRqS09oMFQvN0xPVmdBcHVacTA0am44RlpsMXh3MlNtaVU0UGcrMXkwNUNs?=
 =?utf-8?B?Nmp6MXdlNG40UEFCdS9JWUFnUVduNnRITVpCUzhwbjI1MEJ3cEgwMTNJbmla?=
 =?utf-8?B?UTVRNEtsRnl1WnFxY0UvbVdidU5CNWpTMDBPZkpNY1JaMWZTT0NaU2tuajJ0?=
 =?utf-8?B?QU9EQmM1SG9IdXBUT21KMUtVZUxYSlZYTUx1SXZ3dnV2UjdUdE02cmRYODNL?=
 =?utf-8?B?enpsZzdvemR1VFJCRzJtUjZtYjhMNHd3SzdreDV4bmlJTEsraVBSNmJ6cWM4?=
 =?utf-8?B?WkdkQVFiT2lBV3Byb1laUnZzaThCenBYVG9RZDZuaWlzaXVWVTdLVHhNak5B?=
 =?utf-8?B?MFN0dlFJQlduaHEyVWFzdmhNMGRvTENvMlFVNWZqSkNJcmdpYzJxS1JZQzA0?=
 =?utf-8?B?NmxEWWNHTVBodTdTOXVFS3JyYkpEK2JVNzZmL0F3RW0vMnJHZFkxQlZySFo1?=
 =?utf-8?B?TVRlTzlqYlFlU3E0OTVzNXd1QUNXNWNPOUY3am0xalFVbCtWUWhZd3VzV0xM?=
 =?utf-8?B?NXF0bDMySWY3MXl2cjdSWDVlZExtcDdVaHhZUTlIanhOMVNTRFAwYlNrc29Q?=
 =?utf-8?B?Vk5ia3hab2RZd2lDeHBhbE1MNmx2UGNIMlRvQ2tRSUtVczhiV1JaTEZqZFZu?=
 =?utf-8?B?VVFzbThpRmx4aC9tRVI0eURqMXloSFgxZ0tPVmI5Sk0rLy9LSjVtSWpFSlh5?=
 =?utf-8?B?TDYzYm5jZDRhZ01zN0NOdGJ3R1NkMHF6ekhpd3c5RStGR1lMdnJXWkt3U1VW?=
 =?utf-8?B?NXNKNVNOa3E5VjlOUTcrWis1N0FvaTJRUm1KbmhmcEZnL3lBOFBhUjVKeFJp?=
 =?utf-8?B?aGlyd3lLR0dwQjdXQnFCZjVqdW0xS1RsajlOTUN1RFh3ZXBTd2tWbVc0T1pD?=
 =?utf-8?B?N1YweGs0SHBPYlliNXU2ZUZnVmp6T0RCaEVTSW5yVkNYMmJKRnR2Und4VTRS?=
 =?utf-8?B?U3dwd0JtcnZXQlBjbXBzVG5TWHR4NnNIZElGdjFSUEg1SFFaaFVHTG1MM1Q4?=
 =?utf-8?B?MGhGZFRhZy9DK0pwWFhYT25nRms2NGNPT05lNTgxQllBK1BLdWRsYktwdCt1?=
 =?utf-8?B?V0NzUWNEcEowemN1ZGo4aE5aVUYyd3BpMkJzTGxIL2g3dzYzZ1B0cUlKYXdV?=
 =?utf-8?B?QjdpM05zWXdXNlVod2MvdEpRbGVwSVVnYjNkaW9NeEszd2hNN2d1cThvWWxw?=
 =?utf-8?B?QVhnU0w2UFU2OHVubG5XZi9xOEhrcEcydkVicDNHdUNOZjBEVkdOTGNMZEs5?=
 =?utf-8?B?S3l6b0Zjam4wTWVXT2lDUE4yS3pGWitvVi85QVpZZXJ6YWtsRFFTQkFIbW5N?=
 =?utf-8?B?WS9KT05zZFRCWkUyVlA1Y2M3UW1YcUtiVVUzc3NxOXlmL3RIS2RvUEhMNHdn?=
 =?utf-8?B?dytzQjhmRTh1RHNiQkF4enAwNSttNWg5MFQvb0lZZEVWL0g5RmlQcFNUY2VV?=
 =?utf-8?B?dWptdDZJWFFtT25zcnlIWE1ZVFJLbit5RzZYT2tldUVRbDVJejFXVXlXeDBx?=
 =?utf-8?B?RXJnYVhKNFA1RVcvR1REWjRRUHQrLzFhdmhVTUZYWURiWHM5R2I3TzNveEgx?=
 =?utf-8?B?YWh4V0VJNHNkY2dOajJCcm5QVkJGWGE3RGRrMHVzYW1kckxVRzJzWksyMkZ6?=
 =?utf-8?B?enc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <79B721510EADE84582013C1A488AFD1D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f093dac8-b97d-4f58-06a0-08dc7f331b6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2024 16:27:45.9663
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FJjZV0ZlwvA7fNDv2EXtbAbUsxvHG9Jvd/rqA/8vuXyv17A1R5tAys/BICiDcLD4fDhZP27pJih+h8Rz/Sa8Jf4DqYz7bBrwZdAI078njYo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5253
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA1LTI0IGF0IDAwOjU1IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gVGh1LCBNYXkgMjMsIDIwMjQgYXQgMDY6Mjc6NDlQTSArMDAwMCwNCj4gIkVkZ2Vjb21i
ZSwgUmljayBQIiA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+IHdyb3RlOg0KPiANCj4gPiBP
biBXZWQsIDIwMjQtMDUtMjIgYXQgMTc6MDEgLTA3MDAsIElzYWt1IFlhbWFoYXRhIHdyb3RlOg0K
PiA+ID4gT2ssIExldCdzIGluY2x1ZGUgdGhlIHBhdGNoLg0KPiA+IA0KPiA+IFdlIHdlcmUgZGlz
Y3Vzc2luZyBvZmZsaW5lLCB0aGF0IGFjdHVhbGx5IHRoZSBleGlzdGluZyBiZWhhdmlvciBvZg0K
PiA+IGt2bV9tbXVfbWF4X2dmbigpIGNhbiBiZSBpbXByb3ZlZCBmb3Igbm9ybWFsIFZNcy4gSXQg
d291bGQgYmUgbW9yZSBwcm9wZXIgdG8NCj4gPiB0cmlnZ2VyIGl0IG9mZiBvZiB0aGUgR0ZOIHJh
bmdlIHN1cHBvcnRlZCBieSBFUFQgbGV2ZWwsIHRoYW4gdGhlIGhvc3QNCj4gPiBNQVhQQS7CoA0K
PiA+IA0KPiA+IFRvZGF5IEkgd2FzIHRoaW5raW5nLCB0byBmaXggdGhpcyB3b3VsZCBuZWVkIHNv
bXRoaW5nIGxpa2UgYW4NCj4gPiB4ODZfb3BzLm1heF9nZm4oKSwNCj4gPiBzbyBpdCBjb3VsZCBn
ZXQgYXQgVk1YIHN0dWZmICh1c2FnZSBvZiA0LzUgbGV2ZWwgRVBUKS4gSWYgdGhhdCBleGlzdHMg
d2UNCj4gPiBtaWdodA0KPiA+IGFzIHdlbGwganVzdCBjYWxsIGl0IGRpcmVjdGx5IGluIGt2bV9t
bXVfbWF4X2dmbigpLg0KPiA+IA0KPiA+IFRoZW4gZm9yIFREWCB3ZSBjb3VsZCBqdXN0IHByb3Zp
ZGUgYSBURFggaW1wbGVtZW50YXRpb24sIHJhdGhlciB0aGFuIHN0YXNoDQo+ID4gdGhlDQo+ID4g
R0ZOIG9uIHRoZSBrdm0gc3RydWN0PyBJbnN0ZWFkIGl0IGNvdWxkIHVzZSBncGF3IHN0YXNoZWQg
b24gc3RydWN0IGt2bV90ZHguDQo+ID4gVGhlDQo+ID4gb3Agd291bGQgc3RpbGwgbmVlZCB0byBi
ZSB0YWtlIGEgc3RydWN0IGt2bS4NCj4gPiANCj4gPiBXaGF0IGRvIHlvdSB0aGluayBvZiB0aGF0
IGFsdGVybmF0aXZlPw0KPiANCj4gSSBkb24ndCBzZWUgYmVuZWZpdCBvZiB4ODZfb3BzLm1heF9n
Zm4oKSBjb21wYXJlZCB0byBrdm0tPmFyY2gubWF4X2dmbi4NCj4gQnV0IEkgZG9uJ3QgaGF2ZSBz
dHJvbmcgcHJlZmVyZW5jZS4gRWl0aGVyIHdheSB3aWxsIHdvcmsuDQoNClRoZSBub24tVERYIFZN
J3Mgd29uJ3QgbmVlZCBwZXItVk0gZGF0YSwgcmlnaHQ/IFNvIGl0J3MganVzdCB1bm5lZWRlZCBl
eHRyYQ0Kc3RhdGUgcGVyLXZtLg0KDQo+IA0KPiBUaGUgbWF4X2dmbiBmb3IgdGhlIGd1ZXN0IGlz
IHJhdGhlciBzdGF0aWMgb25jZSB0aGUgZ3Vlc3QgaXMgY3JlYXRlZCBhbmQNCj4gaW5pdGlhbGl6
ZWQuwqAgQWxzbyB0aGUgZXhpc3RpbmcgY29kZXMgdGhhdCB1c2UgbWF4X2dmbiBleHBlY3QgdGhh
dCB0aGUgdmFsdWUNCj4gZG9lc24ndCBjaGFuZ2UuwqAgU28gd2UgY2FuIHVzZSB4ODZfb3BzLnZt
X2luaXQoKSB0byBkZXRlcm1pbmUgdGhlIHZhbHVlIGZvcg0KPiBWTVgNCj4gYW5kIFREWC7CoCBJ
ZiB3ZSBpbnRyb2R1Y2VkIHg4Nl9vcHMubWF4X2dmbigpLCB0aGUgaW1wbGVtZW50YXRpb24gd2ls
bCBiZQ0KPiBzaW1wbHkNCj4gcmV0dXJuIGt2bV92bXgtPm1heF9nZm4gb3IgcmV0dXJuIGt2bV90
ZHgtPm1heF9nZm4uIChXZSB3b3VsZCBoYXZlIHNpbWlsYXIgZm9yDQo+IFNWTSBhbmQgU0VWLinC
oCBTbyBJIGRvbid0IHNlZSBiZW5lZml0IG9mIHg4Nl9vcHMubWF4X2dmbigpIHRoYW4NCj4ga3Zt
LT5hcmNoLm1heF9nZm4uDQoNCkZvciBURFggaXQgd2lsbCBiZSBiYXNlZCBvbiB0aGUgc2hhcmVk
IGJpdCwgc28gd2UgYWN0dWFsbHkgYWxyZWFkeSBoYXZlIHRoZSBwZXItDQp2bSBkYXRhIHdlIG5l
ZWQuIFNvIHdlIGRvbid0IGV2ZW4gbmVlZCBib3RoIGdmbl9zaGFyZWRfbWFzayBhbmQgbWF4X2dm
biBmb3IgVERYLg0K

