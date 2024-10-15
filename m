Return-Path: <kvm+bounces-28880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F113D99E5C9
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 13:35:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB3BE284D42
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 11:35:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0D6C1E7669;
	Tue, 15 Oct 2024 11:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DAYJOcYS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DF91E9073;
	Tue, 15 Oct 2024 11:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992088; cv=fail; b=XT1U4fVepAzWkg/w0QP1fXjN6MdYXB62hoflkVcvWg0YY3GTBNasY36RD2M85RCXFGiTW0VkozBwKt3MJrKAb8hcj8Z6RYZiVbOEQaoGiLpRAhwTCchOPr5dzdyC23A62zANyRLoaWbPgYjLY8mLpnGA7peCckgPrWBePWSRJW8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992088; c=relaxed/simple;
	bh=Ftw+JMCMUh4rstwkujBNDTRTpnTv1A6oAU9xjQiG5F8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=shSaCyF5WfRL2LesxPet73CU3dSHyjyqz/o4Tu0HUQyz4yjhCHFneCsGQKtCHDnT/8nfZMAtFTE+SL1BhXOIL1UtIWt18GN/EcfCAjLCnFTb5V5kyR+aJ0fOIIuxB0rQCQNs9981ptJ8u74BPAsEVNvrNAmTuZwFeq7xWRqhly0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DAYJOcYS; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728992087; x=1760528087;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Ftw+JMCMUh4rstwkujBNDTRTpnTv1A6oAU9xjQiG5F8=;
  b=DAYJOcYS5yAVqgPEzW1bij8/I3I+q4u+Nr8e9r2/Hbb+tV3xb180SUAM
   RPTVmUQSR5C1nFNo9cLrdrG9honNiPnyB36si3cU6bdOIuOqUYhryE8jG
   RD6TpzPxnErJffz9EjuALFCjCZzGYAQKrZmh5Fdf9mxCQ+to5CehRtCkf
   5M3nMsqiuu5aiZHGiKt8cPlLFmNMSiIHeN25O/ZEOGxyNuUS/QWt7YII0
   X72w6zt6af+nBc/oAPAwQgXYoxwureFgBRWrN17RjOM7GZC4P4gFP3viQ
   /iZkt9Pbbw6zY/QaTYW/fx7hGsz+uzhOvFEuzrysKJ3vI5/LMQnF9nOJs
   g==;
X-CSE-ConnectionGUID: 00S2xHOUTg+RwhgUniBv7A==
X-CSE-MsgGUID: 51nOxbXXQZG5Acqpa5/lfA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="38933985"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="38933985"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2024 04:34:46 -0700
X-CSE-ConnectionGUID: 4Np5A5rvS8yTUoFGHuD4XQ==
X-CSE-MsgGUID: I7MX2BDDTEy6yKoOwSdYMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,205,1725346800"; 
   d="scan'208";a="82916438"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Oct 2024 04:34:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 15 Oct 2024 04:34:45 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 15 Oct 2024 04:34:44 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 15 Oct 2024 04:34:44 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 15 Oct 2024 04:34:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qhJBMtD7BCR5gCMo7WXEEmUIqV/vZwzwc1wGrOL0//MVdSTYKogpJ8Rco581pgfAmUb7g2agJTbq+6pKt/FMbmNxV44P8qK3J21HYGo619ulQ60UhGN+0w1PHSpKvi8DHxRs3/67Ib8Y6i/mIftl/54Zu2fFhcgi2xhZvdUdshEd5ATAIHkc3iqfDhUltObuBhVk57gbuK0giW4PwSfKBlSCTV4wnp0cTe092IblroG0rfxXvSaa4j51gxNk2ztTrzUcLwYEmJbXg1L6LGbqLa9VGBdH5AMmi6bTZS6Wb6eqs1yf0Zyfax9EWjq1v/xz+TxdyYYMBi5Oz+J6nLXfuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ftw+JMCMUh4rstwkujBNDTRTpnTv1A6oAU9xjQiG5F8=;
 b=aJ2gIOFNJvPzRbd0bnlpd6sfEm3MWajT9ufc+UjiTwe4szHtdbSkPmCuwh9UVZCbeZHijyrxcjG2x48HO9rBR1lL7rIgD9epEXlIYN54suZwrNJ0E3dlHO9NWcZ26XuA3nGcMcQSughMp+IXOPhvnQ7QlipUkuzLQOH0iNVK0p/TReidUHu2y6ecXzRAjk7GpDuNkpKXnVwvAqfg0la12NqjSudHMbSKAAz0L0ICYitDDRoFjcVl9j2C24KVEByeAeNr8STNHTZ0ep9kjqym9rKacRcZ3gOIwtsMURHIOi9ox8frkPGPF7G8lNGjBdyhHkgaYT+a5DImJtv0x2EM1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB5945.namprd11.prod.outlook.com (2603:10b6:806:239::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.22; Tue, 15 Oct
 2024 11:34:41 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8069.016; Tue, 15 Oct 2024
 11:34:41 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v5 2/8] x86/virt/tdx: Rework TD_SYSINFO_MAP to support
 build-time verification
Thread-Topic: [PATCH v5 2/8] x86/virt/tdx: Rework TD_SYSINFO_MAP to support
 build-time verification
Thread-Index: AQHbHivd+IUQqFqF5E6cA7svqsOn1LKGZtIAgAA3FACAARIygA==
Date: Tue, 15 Oct 2024 11:34:41 +0000
Message-ID: <9a06e2cf469cbca2777ac2c4ef70579e6bb934d5.camel@intel.com>
References: <cover.1728903647.git.kai.huang@intel.com>
	 <f3c63fb80e0de56e15348d078aa3ba1b1aa9b3c6.1728903647.git.kai.huang@intel.com>
	 <c3b1e743-6d34-49ce-8e60-a41038f27c61@intel.com>
	 <670d6d4cab43d_3ee229434@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <670d6d4cab43d_3ee229434@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB5945:EE_
x-ms-office365-filtering-correlation-id: a265b0af-4aa1-439e-a68e-08dced0d5c3c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NzVKMlhieGpoVFVaUTR6RXNPT0NrNXIyQWV5aEFXQU1VUmtOODBWcGh5RVVX?=
 =?utf-8?B?K21uWEtoUm1taHU5RWhmSXZJbFRyRVg1TmhGN3h5ZHZmMVVPYzFMRjFSbjFX?=
 =?utf-8?B?M0hjM1N3L0NWZlJ3emUzNFovK2xwUFUvV2FSRFBDV2dRSlhjcW5aR0ZJbXAv?=
 =?utf-8?B?Z08rQUlZY091UWFyaUFUL001SkRnRFRBUVJNdU5SY1htTmROUmp6aGlEcDU5?=
 =?utf-8?B?dmVVRXgwSkpSRWM0RFpqRkdWUEwxZU12WEkzOW0xbHpnQmNDcmxNcnZqRWZs?=
 =?utf-8?B?UWtueTVnQ2oyR0VMb2pTZkVRS21icUpwMEJ5YUU1STYrU1hxSGcrUHd2dVl4?=
 =?utf-8?B?cXB1WWdpWVRSTXFXRGRVU2NMMFBWMU5KdHljRUxkeXlsb25QQVFDd21ZQ3FK?=
 =?utf-8?B?OFdpaWhrVXNsdnppYXIwT0k3NUtOd1JsYWVzZ0ZhWk1OZGdkVlFseTFCeFU5?=
 =?utf-8?B?bys1L1FhbEViY0VKQkh1ZFUwUnlQa0dUMG1jR2FXeVczak9yNEtGUGJBbUpl?=
 =?utf-8?B?cFg2VndYUFhCOVA1UmVMRkordWVLTTRwemVOWGl6YldkbldzbUR0cmtMaTFz?=
 =?utf-8?B?V2JUMkRkU2haWWFxeUFXa3J0Z3QwcnVSMC9MeVlUbHhtMWFlL3hvNnVxUHB2?=
 =?utf-8?B?QTdoaVMyNFY2aERZaEp0Zk1MSWJ5VW9EYVpPWWgzeU9zNEt0TU16R0sremUr?=
 =?utf-8?B?Q21nU3c5YW1CRXU1L3BSTnFaekxFVXNjVXpEMUhYSjNha3R2RStUUUxXQTNl?=
 =?utf-8?B?UjRBZFJqZisxeFp1eC9maHA1eERHTzJRM0FyOUF5NDNYK0diV3ovUkxicXNr?=
 =?utf-8?B?ZXVyNWw4b29JSTJGRFVIL3diTXZGMDNQTXMvQUh6RzNvaHkycHdYN1QyS1VI?=
 =?utf-8?B?UEwwMm9YeUx2SmRVTHNYcFJiRXVES1VRUGhmdVRvcFpzQnhZVzh0Tml6TXBr?=
 =?utf-8?B?M05udWFjOUhaVjNwYnI0OENVdWlRU3dqN0xiL1NUOEVGa3J0YVBGKzk4d3B0?=
 =?utf-8?B?cmQvMGdobXAzZnlPVzl1ekdSZlhja1pwSHlETjJZZkFMdVpiVmd3b0NMcW9k?=
 =?utf-8?B?U3Nrb1c5TENsaDZsRWZ0SkN5Qk82L3R3d0ZrRURjcUtwUit4RWo2VWI4ZnJH?=
 =?utf-8?B?RHZTWEd0UUVLWnlMdzhiTWVzNER3YndHK1drREVnZWdxNTBSUTdTY3F3V0t1?=
 =?utf-8?B?amdyOGRrNmNDMVptOTFVcXMycUtoZUpaYVkzM3BwNmVtY2Y1ODNrZkxwVVFn?=
 =?utf-8?B?dGhUa3JiK25BUVdUYlo0bHZ4MW51YlArWGJRa09aWjFFQnM0azJsMGxNcGRT?=
 =?utf-8?B?WDA0aC8rdDdkZ20zc082M1oyTU1HcVhGdEhOZ1FwRFQ3M29icGQ5VEVnbGo4?=
 =?utf-8?B?Zmw4STRzWThxbmp4YmxwQVptVWdsZjhQUXRPWXNDWHJiVDZpaVp5cGpPN1pC?=
 =?utf-8?B?c2RXakx1MWNZSlYvNUo5aEFmZ28xS1V4K0RST0h6QmlIRFRFUm40bVJNNHJM?=
 =?utf-8?B?b3M0QktZUWJMU2ppU3NORW5EREs4a2s1M3p4VXhxU3FSVllucDF5ZnY2M1pj?=
 =?utf-8?B?SzFyOWdpVFQyS01DWE9KWDZUSXZvOEpvTWdmMmlRVWxFU3l0Skp2YmVpQkJI?=
 =?utf-8?B?dkNjVWVVSnI1TTNIT2NnMC85VEppOGJnQ0k3V3ZCNVV4aytjamNxbDkyVmJV?=
 =?utf-8?B?aGFFWW5xa3N4V2FTWUVtOXFHM1ZqYTh2anY0SDV0M0dDZEJZLzJIMlFFc1dp?=
 =?utf-8?Q?kS/upJJD4sfFA+zryS3zdd3riFt5/gk6Qj6OF40?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cjJ4TGlURS81aTBBM2QrZGlTNW0yL1UxU2dOeHgxMHZLYkZINVltY2pld29l?=
 =?utf-8?B?MHBxQWwwL0FXT2E3MmJhRXVnam83cGlhdVIzMWF1KzFKeUFkVkE5WTNuay9D?=
 =?utf-8?B?MnJHV1R1VzAxRFBFRnpzTkw1blJkd0lRbEliRGZHcHVTUHFPTEZyYTlFc3Fl?=
 =?utf-8?B?eFk1S2tubmM4eGxsbUJGQnZpVkZ0UW9TR1IxZjBNbUVpV3VlMEN4YWZYalBh?=
 =?utf-8?B?YzVoc3AvYllsb3lpK2JwNVRwNmQzb0Y1WS9OZHJuNEhvTmtHdWdCN3dvOFdu?=
 =?utf-8?B?c3liTGdtUDJPZENvRzE5aGpEQmVlcG14bnEzWm1hQjNGcmFRRWt4VVdOWmlI?=
 =?utf-8?B?Zk5iZWdLMTF5U3Ztbmprak1KTkl2N0VIWkF2UUdQRFRxNnRvQUNlK21LLzlD?=
 =?utf-8?B?WTFrL3hDbjI0UEdEYmlPdjByV201ZUpkcUNKVjZzemVFUWlUaDRvU2hxZ0VE?=
 =?utf-8?B?NHZlcWlJOFd1aXhDaXQ0bFFOSU80d1lralhVNWZXQTZFa2toUzY5VERGcjdt?=
 =?utf-8?B?ODJOTEhQRGNiem1NeHFOYzh2Z1RmdTdOV29CNmprR2g3dnA5UG4vL2NmLzRC?=
 =?utf-8?B?OGRlUnNkM3IzQWVXcXZIbythWFVhUk1yZC96cFUrVmNtc0tpNFIraldXQU4v?=
 =?utf-8?B?QnFFWllMVzJZTkRSTkRlbkhJUWpFeWhkS0lBdWRHN1BJVStuSmZJa096Ykxx?=
 =?utf-8?B?QmRYTndJK2prSDArL3U0WU4wMGJCdlRCalhSR3puYXVCVExmMXh1ZU1Rc1pU?=
 =?utf-8?B?WGdlOG5oSTdIQXYwNTViRGJUUTlnaHlTSkgwVlJrSjM4TjRVOWMzZCtWRmNz?=
 =?utf-8?B?MTdHZkpZWSt4SVEwTkFOOXN6SnpXZDNnK25TMzVrRGVuS1lhdUxwaVJCREM2?=
 =?utf-8?B?QVgxNFVXcE54dTdFOEpZRWxqa2pQSUM2Zi9lK1FzWXdBM3hEVVRRZHR2ckly?=
 =?utf-8?B?ZmpLLzdrRXh3QitsY290YjI0bmVweTh2cDgyT3RwT215SDl6akJWMlU3SUhO?=
 =?utf-8?B?VkE2NHFpU29NMkxra2ZZTFJBcDY5bW94R2YvQ3c5TUdVWUlSVWdsS2RPamxz?=
 =?utf-8?B?SExUSy9pdktNamFrQ0xtbTVTc1hJUWNkR3Uxa3p1QXdRaGl4YzRYb00wS2tr?=
 =?utf-8?B?bTVxSS9zU2NOY0RYRTRVakhUMnRZekxhZVgrM1pIY0l6c2ZpMFBDTjRWdUpT?=
 =?utf-8?B?YTVGbWRhS1FaYVQxNVdFY3JpNnZOcXA5UzRxMUlzZUdKOHd5RG1LSjVSalE3?=
 =?utf-8?B?cUtJSWpqMHROY0FKSVZwQnp3bkJVZE9QZkU4MXh2VHBVVldmd1dYR3FMYjhR?=
 =?utf-8?B?QmFtb1Uxc0hpbHdsd0hra1Vyd1ZXb3ZDR1R3UEtPWW5LN2FWSE90eC81T080?=
 =?utf-8?B?NG8xR3dHS2x6Z1hMckFrTGFBZ0lOajZVcVlYcHNKRW1vTkF2TU0wbWJSVnBB?=
 =?utf-8?B?L0d1cUxpbStvSWs4NG0veDBzMVhyRDNuSHV6Rjk2SHJMNzhwVW53anZDQ3NJ?=
 =?utf-8?B?OW1FaEg3ZERmNXNCVmdMcWRYMnkvWVd4MUVRcUVKcDk1ZHYxbUczTVJqNjlx?=
 =?utf-8?B?bGlhd1NiZERCRCtLMlIzaUs3S1JrZXJCN0doUVpZdHIySU1wUWxwRFdvcWZj?=
 =?utf-8?B?Wlh2eGJXTzk3dG9YR2J3NXBzOGdDTHE5cVpaQzkwQ21CUFMyTlF2Vm9ycXZv?=
 =?utf-8?B?NnF3b2JXVUFqY2hxbS82OVhONU9ub2tTeGdya1JPMmRoZFhhREpuS3dxbmF3?=
 =?utf-8?B?OWROVERRdzVwM3FKaTg5YnF5QUVqa1ptczRzRFRrTm5LSU5vUEtzNTNjbHhk?=
 =?utf-8?B?dUI1aWI2akV5QnlTUjkydlFBWFEyRzRMdGNCZ3dxNjVEZUZ5MHBkOXVvWGoz?=
 =?utf-8?B?bUh1U3BkZTFPTXhNblVOTWZYQkdvbGNPQkxYVUhMczI0S2Z1WHhQdmJSSC9T?=
 =?utf-8?B?MXU3NW5UZnh4OEZTekVIcURodnJHRG9SbXgwY2hhUUVablN0eFZ0V0c5U2I5?=
 =?utf-8?B?bGFRODF3UmZsTlZiUGx0RVZ2TSsxbE5nbFYzUzN6Y21iRTRRZjMza1lCQW5z?=
 =?utf-8?B?MWUzWGFvYjFqZi9FamhxaVhUSXdlRmkxUFhGVGUya0dERC9ZMWY4aEdSK3Vk?=
 =?utf-8?Q?WMiaMIY4UPndkkJ3I5ZXXbJyh?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <55A0A7D5703C834DBA7C013C3AB7113E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a265b0af-4aa1-439e-a68e-08dced0d5c3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2024 11:34:41.7218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mikF0Nkh01OpUXPzCY88XRtEoDdr/mYlkU6lO3bhrvtls+ndFgmpPFH455+FvM56cQqLoUUfQT8DhjappGR7dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5945
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTEwLTE0IGF0IDEyOjEzIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IERhdmUgSGFuc2VuIHdyb3RlOg0KPiA+IE9uIDEwLzE0LzI0IDA0OjMxLCBLYWkgSHVhbmcgd3Jv
dGU6DQo+ID4gPiArI2RlZmluZSBSRUFEX1NZU19JTkZPKF9maWVsZF9pZCwgX21lbWJlcikJCQkJ
XA0KPiA+ID4gKwlyZXQgPSByZXQgPzogcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQxNihNRF9GSUVM
RF9JRF8jI19maWVsZF9pZCwJXA0KPiA+ID4gKwkJCQkJJnN5c2luZm9fdGRtci0+X21lbWJlcikN
Cj4gPiA+ICANCj4gPiA+IC0JcmV0dXJuIDA7DQo+ID4gPiArCVJFQURfU1lTX0lORk8oTUFYX1RE
TVJTLAkgICAgIG1heF90ZG1ycyk7DQo+ID4gPiArCVJFQURfU1lTX0lORk8oTUFYX1JFU0VSVkVE
X1BFUl9URE1SLCBtYXhfcmVzZXJ2ZWRfcGVyX3RkbXIpOw0KPiA+ID4gKwlSRUFEX1NZU19JTkZP
KFBBTVRfNEtfRU5UUllfU0laRSwgICAgcGFtdF9lbnRyeV9zaXplW1REWF9QU180S10pOw0KPiA+
ID4gKwlSRUFEX1NZU19JTkZPKFBBTVRfMk1fRU5UUllfU0laRSwgICAgcGFtdF9lbnRyeV9zaXpl
W1REWF9QU18yTV0pOw0KPiA+ID4gKwlSRUFEX1NZU19JTkZPKFBBTVRfMUdfRU5UUllfU0laRSwg
ICAgcGFtdF9lbnRyeV9zaXplW1REWF9QU18xR10pOw0KPiA+IA0KPiA+IEkga25vdyB3aGF0IERh
biBhc2tlZCBmb3IgaGVyZSwgYnV0IEkgZGlzbGlrZSBob3cgdGhpcyBlbmRlZCB1cC4NCj4gPiAN
Cj4gPiBUaGUgZXhpc3Rpbmcgc3R1ZmYgKmhhcyogdHlwZSBzYWZldHksIGRlc3BpdGUgdGhlIHZv
aWQqLiAgSXQgYXQgbGVhc3QNCj4gPiBjaGVja3MgdGhlIHNpemUsIHdoaWNoIGlzIHRoZSBiaWdn
ZXN0IHByb2JsZW0uDQo+ID4gDQo+ID4gQWxzbywgdGhpcyBpc24ndCByZWFsbHkgYW4gdW5yb2xs
ZWQgbG9vcC4gIEl0IHN0aWxsIGVmZmVjdGl2ZWx5IGhhcw0KPiA+IGdvdG9zLCBqdXN0IGxpa2Ug
dGhlIGZvciBsb29wIGRpZC4gIEl0IGp1c3QgYnVyaWVzIHRoZSBnb3RvIGluIHRoZSAicmV0DQo+
ID4gPSByZXQgPzogIiBjb25zdHJ1Y3QuICBJdCBoaWRlcyB0aGUgY29udHJvbCBmbG93IGxvZ2lj
Lg0KPiA+IA0KPiA+IExvZ2ljYWxseSwgdGhpcyB3aG9sZSBmdW5jdGlvbiBpcw0KPiA+IA0KPiA+
IAlyZXQgPSByZWFkX3NvbWV0aGluZzEoKTsNCj4gPiAJaWYgKHJldCkNCj4gPiAJCWdvdG8gb3V0
Ow0KPiA+IA0KPiA+IAlyZXQgPSByZWFkX3NvbWV0aGluZzIoKTsNCj4gPiAJaWYgKHJldCkNCj4g
PiAJCWdvdG8gb3V0Ow0KPiA+IA0KPiA+IAkuLi4NCj4gPiANCj4gPiBJJ2QgKm11Y2gqIHJhdGhl
ciBoYXZlIHRoYXQgZ290byBiZToNCj4gPiANCj4gPiAJZm9yICgpIHsNCj4gPiAJCXJldCA9IHJl
YWRfc29tZXRoaW5nKCk7DQo+ID4gCQlpZiAocmV0KQ0KPiA+IAkJCWJyZWFrOyAvLyBha2EuIGdv
dG8gb3V0DQo+ID4gCX0NCj4gPiANCj4gPiBUaGFuIGhhdmUgc29tZXRoaW5nICpsb29rKiBsaWtl
IHN0cmFpZ2h0IGNvbnRyb2wgZmxvdyB3aGVuIGl0IGlzbid0Lg0KDQpZZWFoIHVuZGVyc3Rvb2Qu
ICBUaGFua3MgZm9yIGxldHRpbmcgbWUga25vdy4NCg0KVGhlICdmb3IoKSBsb29wJyBhcHByb2Fj
aCB3b3VsZCBuZWVkIHRoZSBvcmlnaW5hbCAnc3RydWN0IGZpZWxkX21hcHBpbmcnIHRvIGhvbGQN
CnRoZSBtYXBwaW5nIGJldHdlZW4gZmllbGQgSUQgYW5kIHRoZSBvZmZzZXQvc2l6ZSBpbmZvLCB0
aG91Z2guDQoNCj4gDQo+IFllYWgsIHRoZSBoaWRpbmcgb2YgdGhlIGNvbnRyb2wgZmxvdyB3YXMg
dGhlIHdlYWtlc3QgcGFydCBvZiB0aGUNCj4gc3VnZ2VzdGlvbi4gTXkgbWFpbiBncmlwZSB3YXMg
cnVudGltZSB2YWxpZGF0aW9uIG9mIGRldGFpbHMgdGhhdCBjb3VsZA0KPiBiZSB2YWxpZGF0ZWQg
YXQgY29tcGlsZSB0aW1lLg0KDQpJIGFtIGxvb2tpbmcgaW50byBob3cgdG8gZG8gYnVpbGQtdGlt
ZSB2ZXJpZmljYXRpb24gd2hpbGUgc3RpbGwgdXNpbmcgdGhlDQpvcmlnaW5hbCAnc3RydWN0IGZp
ZWxkX21hcHBpbmcnIGFwcHJvYWNoLiAgSWYgd2UgY2FuIGRvIHRoaXMsIEkgaG9wZSB0aGlzIGNh
bg0KYWRkcmVzcyB5b3VyIGNvbmNlcm4gYWJvdXQgZG9pbmcgcnVudGltZSBjaGVjayBpbnN0ZWFk
IG9mIGJ1aWxkLXRpbWU/DQoNCkFkcmlhbiBwcm92aWRlZCBvbmUgc3VnZ2VzdGlvbiBbKl0gdGhh
dCB3ZSBjYW4gdXNlIF9fYnVpbHRpbl9jaG9vc2VfZXhwcigpIHRvDQphY2hpZXZlIHRoaXM6DQoN
CiINCkJVSUxEX0JVR19PTigpIHJlcXVpcmVzIGEgZnVuY3Rpb24sIGJ1dCBpdCBpcyBzdGlsbA0K
YmUgcG9zc2libGUgdG8gYWRkIGEgYnVpbGQgdGltZSBjaGVjayBpbiBURF9TWVNJTkZPX01BUA0K
ZS5nLg0KDQojZGVmaW5lIFREX1NZU0lORk9fQ0hFQ0tfU0laRShfZmllbGRfaWQsIF9zaXplKQkJ
CVwNCglfX2J1aWx0aW5fY2hvb3NlX2V4cHIoTURfRklFTERfRUxFX1NJWkUoX2ZpZWxkX2lkKSA9
PSBfc2l6ZSwgX3NpemUsDQoodm9pZCkwKQ0KDQojZGVmaW5lIF9URF9TWVNJTkZPX01BUChfZmll
bGRfaWQsIF9vZmZzZXQsIF9zaXplKQkJXA0KCXsgLmZpZWxkX2lkID0gX2ZpZWxkX2lkLAkJCQlc
DQoJICAub2Zmc2V0ICAgPSBfb2Zmc2V0LAkJCQkJXA0KCSAgLnNpemUJICAgID0gVERfU1lTSU5G
T19DSEVDS19TSVpFKF9maWVsZF9pZCwgX3NpemUpIH0NCg0KI2RlZmluZSBURF9TWVNJTkZPX01B
UChfZmllbGRfaWQsIF9zdHJ1Y3QsIF9tZW1iZXIpCQlcDQoJX1REX1NZU0lORk9fTUFQKE1EX0ZJ
RUxEX0lEXyMjX2ZpZWxkX2lkLAkJXA0KCQkJb2Zmc2V0b2YoX3N0cnVjdCwgX21lbWJlciksCQlc
DQoJCQlzaXplb2YodHlwZW9mKCgoX3N0cnVjdCAqKTApLT5fbWVtYmVyKSkpDQoiDQoNCkkgdHJp
ZWQgdGhpcywgYW5kIGl0IHdvcmtlZCBmb3IgbW9zdCBjYXNlcyB3aGVyZSB0aGUgZmllbGQgSUQg
aXMgYSBzaW1wbGUNCmludGVnZXIgY29uc3RhbnQsIGJ1dCBJIGdvdCBidWlsZCBlcnJvciBmb3Ig
dGhlIENNUnM6DQoNCglmb3IgKHUxNiBpID0gMDsgaSA8IGNtcl9pbmZvLT5udW1fY21yczsgaSsr
KSB7DQoJCWNvbnN0IHN0cnVjdCBmaWVsZF9tYXBwaW5nIGZpZWxkc1tdID0gew0KCQkJVERfU1lT
SU5GT19DTVJJTkZPX01BUChDTVJfQkFTRTAgKyBpLCBjbXJfYmFzZVtpXSksDQoJCQlURF9TWVNJ
TkZPX0NNUklORk9fTUFQKENNUl9TSVpFMCArIGksIGNtcl9zaXplW2ldKSwNCgkJfTsNCgkJLi4u
DQoJfQ0KDQouLiB3aGVyZSBmaWVsZCBJRCBmb3IgQ01SW2ldIGlzIGNhbGN1bGF0ZWQgYnkgQ01S
MC4NCg0KVGhlIE1EX0ZJRUxEX0VMRV9TSVpFKF9maWVsZF9pZCkgd29ya3MgZm9yICdDTVJfQkFT
RTAgKyBpJyBmb3IgQlVJTERfQlVHX09OKCksDQpidXQgc29tZWhvdyB0aGUgY29tcGlsZXIgZmFp
bHMgdG8gZGV0ZXJtaW5lIHRoZSAnTURfRklFTERfRUxFX1NJWkUoX2ZpZWxkX2lkKSA9PQ0KX3Np
emUnIGFzIGEgY29uc3RhbnRfZXhwcmVzcyBhbmQgY2F1c2VkIGJ1aWxkIGZhaWx1cmUuICBJIGFt
IHN0aWxsIGxvb2tpbmcgaW50bw0KdGhpcy4NCg0KWypdDQpodHRwczovL2xvcmUua2VybmVsLm9y
Zy9rdm0vY292ZXIuMTcyMTE4NjU5MC5naXQua2FpLmh1YW5nQGludGVsLmNvbS9ULyNtMzc5Y2Uw
NDFmMDI1ZGMyMGU3YjU4ZmE2ZGJkYzQ4NGMyY2U1M2FmNA0KDQo+IFRoZXJlIGlzIG5vIHJlYWwg
bmVlZCBmb3IgY29udHJvbCBmbG93IGF0IGFsbCwgaS5lLiBlYXJseSBleGl0IGlzIG5vdA0KPiBu
ZWVkZWQgYXMgdGhlc2UgYXJlIG5vdCByZXNvdXJjZXMgdGhhdCBuZWVkIHRvIGJlIHVud291bmQu
IEl0IHNpbXBseQ0KPiBuZWVkcyB0byBjb3VudCB3aGV0aGVyIGFsbCBvZiB0aGUgcmVhZHMgaGFw
cGVuZWQsIHNvIHNvbWV0aGluZyBsaWtlIHRoaXMNCj4gaXMgc3VmZmljaWVudDoNCj4gDQo+ICAg
ICBzdWNjZXNzICs9IFJFQURfU1lTX0lORk8oTUFYX1RETVJTLCAgICAgICAgICAgICBtYXhfdGRt
cnMpOw0KPiAgICAgc3VjY2VzcyArPSBSRUFEX1NZU19JTkZPKE1BWF9SRVNFUlZFRF9QRVJfVERN
UiwgbWF4X3Jlc2VydmVkX3Blcl90ZG1yKTsNCj4gICAgIHN1Y2Nlc3MgKz0gUkVBRF9TWVNfSU5G
TyhQQU1UXzRLX0VOVFJZX1NJWkUsICAgIHBhbXRfZW50cnlfc2l6ZVtURFhfUFNfNEtdKTsNCj4g
ICAgIHN1Y2Nlc3MgKz0gUkVBRF9TWVNfSU5GTyhQQU1UXzJNX0VOVFJZX1NJWkUsICAgIHBhbXRf
ZW50cnlfc2l6ZVtURFhfUFNfMk1dKTsNCj4gICAgIHN1Y2Nlc3MgKz0gUkVBRF9TWVNfSU5GTyhQ
QU1UXzFHX0VOVFJZX1NJWkUsICAgIHBhbXRfZW50cnlfc2l6ZVtURFhfUFNfMUddKTsNCj4gICAg
IA0KPiAgICAgaWYgKHN1Y2Nlc3MgIT0gNSkNCj4gICAgIAlyZXR1cm4gZmFsc2U7DQo+IA0KDQpJ
ZiB3ZSBnbyB3aXRoIHRoaXMgYXBwcm9hY2gsIGl0IHNlZW1zIHdlIGNhbiBldmVuIGdldCByaWQg
b2YgdGhlIEBzdWNjZXNzLg0KDQoJaW50IHJldCA9IDA7DQoNCiNkZWZpbmUgUkVBRF9TWVNfSU5G
TyhfZmllbGRfaWQsIF9tZW1iZXIpCVwNCglyZWFkX3N5c19tZXRhZGF0YV9maWVsZChNRF9GSUVM
RF9JRF8jI19maWVsZF9pZCwgXA0KCSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAmc3lzaW5mb190ZG1yLT5fbWVtYmVyKQ0KDQoJcmV0IHw9IFJFQURfU1lTX0lORk8oTUFYX1RE
TVJTLCBtYXhfdGRtcnMpOw0KCS4uLg0KI3VuZGVmIFJFQURfU1lTX0lORk8NCg0KCXJldHVybiBy
ZXQ7DQoNClRoZSB0ZGhfc3lzX3JkKCkgYWx3YXlzIHJldHVybiAtRUlPIHdoZW4gVERILlNZUy5S
RCBmYWlscywgc28gdGhlIGFib3ZlIGVpdGhlcg0KcmV0dXJuIDAgd2hlbiBhbGwgcmVhZHMgd2Vy
ZSBzdWNjZXNzZnVsIG9yIC1FSU8gd2hlbiB0aGVyZSdzIGFueSBmYWlsZWQuDQoNCkkgY2FuIGFs
c28gZ28gd2l0aCByb3V0ZSBpZiBEYXZlIGlzIGZpbmU/DQo=

