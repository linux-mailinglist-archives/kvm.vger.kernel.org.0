Return-Path: <kvm+bounces-17754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ABDE8C9B75
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 12:39:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0878B282CAB
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 10:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4A0451C36;
	Mon, 20 May 2024 10:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y8eaWyLZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C73D4E1CE;
	Mon, 20 May 2024 10:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716201550; cv=fail; b=gvIfrDbsRScZF7etn5PKMwJjZjQm0QqamzXMBrbumjXmTXqMPsyy+FWAvxNmsMS+UcwZv1g7UudQMTcEnaQDJTxQ+ndADCPoVRos3dcjYoLsYEgNhqapAF94ajpBpUT6qeNgUTSRlazWfqtOsCL6vE93GPz03LakJOLTy/H7a0M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716201550; c=relaxed/simple;
	bh=W9vHh7rtQvMl4ZHHwf1p8FWg0asFK6NBYJoudhsv8UU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qXxQmSj/JfIyQowZbG7B+6DYjwb7L0JXwdwklX5FEaQfVVSOfDbYUJOMbQ50jGpZrD1nJ4ZhliWyMVGLvRfhZWELttj6j2LMncC2ZjBuyvjACJNlJlUDGnvYeHJX9Vmwb1a9Ms0fXP9Vv43UCfR7IxXLdExf7ffhcBvAkAuC9ZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y8eaWyLZ; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716201549; x=1747737549;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=W9vHh7rtQvMl4ZHHwf1p8FWg0asFK6NBYJoudhsv8UU=;
  b=Y8eaWyLZV9iPhBs1mV3j+G0ReeJgSaQbGSJSp2quutbXkbH9V/IzWD3a
   90hSuDEvZFhpHC0C3PCutKhFYo9PZi37PCq+qd4MTqQH/WrXvbZgeIIu/
   VgA7hZtsHs6ye3WYazxkWAmY3anaRJwkQ/U6POHtD9mCIFYjSErLF7M/O
   gxi1nCriXbLUIADPCTM688oQmqTPNgkQjQbcC372UeJF+JLJvbBtk0aHm
   F3e3QMCZE2UjABbBWisW/yJ8ZNTvae6QTOQvGl5cS9dYKfGtwH0gtP5+I
   q6MNL6AZ5Wd75rtfy0Rv0iXK/L3P+eYyHOtk0YPFw2zFlT2euyjvHvFLX
   g==;
X-CSE-ConnectionGUID: TJfz1bEbTQG4jtqBF6cWjQ==
X-CSE-MsgGUID: ln5hjtQ4RHG1la3l4w7qyA==
X-IronPort-AV: E=McAfee;i="6600,9927,11077"; a="12433840"
X-IronPort-AV: E=Sophos;i="6.08,174,1712646000"; 
   d="scan'208";a="12433840"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 03:39:09 -0700
X-CSE-ConnectionGUID: p9VbQ/pPTXSN0eyXmC6meQ==
X-CSE-MsgGUID: L5Q2ZcbRRtStbrd4eclBeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,174,1712646000"; 
   d="scan'208";a="32520500"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 May 2024 03:39:08 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 03:39:07 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 03:39:07 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 20 May 2024 03:39:07 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 20 May 2024 03:39:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X1QVzKPviWoUIXNjrkj4RmJcUnoPygC0joXCMwPR7KoOnQt/YrONs7z4FAybWMbcohjoYNoXX+Tn++lLfzym2UiykpOwVWJH3TpWWg/bFnrIXGrGmB8J6X76egFjzPsun0iYy+43iMZ3B1cu0fe9mwNxs3QCNKMiJvYhCiN2/GcZMJSTzVX1uMbTvacx3+8NiXRK6xBdOWLZZK6JtsQxUjthD1tfUEfaRAbq2l/5mTHc7F4sYSP8xi9ZMpWGCPMOAAVchNe1OI7A6Ql5hohGoX/4kJ9bTzghlZfa0NuTjzLWaNNBuiZmwgnhCO2tv8Q6x4YFWLFMmOjZuJwQNdWUxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W9vHh7rtQvMl4ZHHwf1p8FWg0asFK6NBYJoudhsv8UU=;
 b=dSLrCdaBxtn3GxgDDHb3n0e4MiCyi0vggiHXU+UX/nA+Xcfl1tBvRJvkTyojk3qxwG6yk9z6vdObbpNCH2n5vGd7PMP/PzNgXYbl+OXKgAYmu0jih7FMuG+2/OqUbBGSGDCQch1eXU82ok0ro5oCqzbj7I4DaxUwomtJAAnwYF2FBXkH2Qojd4V8z0pNRlCp94p2fgy0jtUlHqVF2R+KSpje/1smSU0nW8if298qoMGRVqhC9h+vwx8A1zY2nK97q0BE34/nsVFTCKxgKvznbt/zgd1RfXFzy25PjKocapXF+WYV6OVFU8OZcw/8GNbYhSdg0c2JLMdZtdUgIWCfnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7442.namprd11.prod.outlook.com (2603:10b6:8:14d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.28; Mon, 20 May
 2024 10:38:58 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7587.030; Mon, 20 May 2024
 10:38:58 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "dmatlack@google.com" <dmatlack@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "seanjc@google.com" <seanjc@google.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Topic: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Index: AQHapmOz3jiNvsf7Ck6WlN+dtixHHLGZCeMAgAAJxQCAAAs0AIAADfQAgACpjACAADtaAIAAM8mAgABz1YCAAF5sAIABZ7iAgACnaoCAAtAngA==
Date: Mon, 20 May 2024 10:38:58 +0000
Message-ID: <791ab3de8170d90909f3e053bf91485784d36c61.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
	 <12afae41-906c-4bb7-956a-d73734c68010@intel.com>
	 <1d247b658f3e9b14cefcfcf7bca01a652d0845a0.camel@intel.com>
	 <a08779dc-056c-421c-a573-f0b1ba9da8ad@intel.com>
	 <588d801796415df61136ce457156d9ff3f2a2661.camel@intel.com>
	 <021e8ee11c87bfac90e886e78795d825ddab32ee.camel@intel.com>
	 <eb7417cccf1065b9ac5762c4215195150c114ef8.camel@intel.com>
	 <20240516194209.GL168153@ls.amr.corp.intel.com>
	 <ffd24fa5-b573-4334-95c6-42429fd9ee38@intel.com>
	 <20240517081440.GM168153@ls.amr.corp.intel.com>
	 <b6ca3e0a18d7a472d89eeb48aaa22f5b019a769c.camel@intel.com>
	 <0d48522f37d75d63f09d2a5091e3fa91913531ee.camel@intel.com>
In-Reply-To: <0d48522f37d75d63f09d2a5091e3fa91913531ee.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB7442:EE_
x-ms-office365-filtering-correlation-id: b782a425-1490-4eaa-425d-08dc78b90e2a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?Z0JWcTIxWW9BK1VoTkU5RHlTQzgzeWtDNGNMQmxqRnMzVmlWRVlaNXRyU29B?=
 =?utf-8?B?UG44Qi94YlpSMUdxZUFCSEpQWXR5dmpVTnUwalNUb0ltNnRJYjZVdzlGZVR1?=
 =?utf-8?B?MnZCOEVqbFhPNTRQZ3U0cDRMb0gzQndoMVFXM2xKL2JPdmt0NTViSU4rOU40?=
 =?utf-8?B?OWFXdUw2dEpuQm01Q0Ntb01iNUtkanhkK2hnRjgvbkZ0RHFIb0xXTHRtL25C?=
 =?utf-8?B?THlRK1J2VjdobmluVlpDb0tkbUhmcVRNVHBiU2FoTmtteVRHcjNFUVRVaG5s?=
 =?utf-8?B?cUVkS1JoOUZHUldOeFkyaHpnckxSdmpxdzgvR2piSXo5SlM1eEdYamt3My85?=
 =?utf-8?B?OUFEMkErQTI0dXdxUlZZbm1EMFdJNWJLZ1o5S0RNWFp3OWh6WkFGSkJxSG90?=
 =?utf-8?B?Z0VaUmxKSk5MU3ZwdGNCV1VSRkN2cDJqNGthb3A4QjdCd3VMcE1uMWZZSkJM?=
 =?utf-8?B?V1FVajBPNWVKVnRqZ0Z6ZjZpa1pJOTJlQ1NhYU1PM0hqdHZIUDdkNWtvQXpZ?=
 =?utf-8?B?ak0wWEhvenp1N29wMDBHVkRrWW9YNktTWUdzZGhOdTNVWnF0SnFSNFgrYjFj?=
 =?utf-8?B?amcyR2U3QUN3V2JpY0tST0M5T2N4YUdMQVAyM25Rb0Q3QjJOcmUyYTdGcHNa?=
 =?utf-8?B?TXFMM2NhVW5nY0pyZ0FrRE41L3g5NmIyeVRrWUYyVkZDdThrMVpQRXJubjVa?=
 =?utf-8?B?MmtvbDJTVGQwU3FUbEUya3dqMkF5bzNGenBBZDNsM05xcU9lUEVHRjFvMHVE?=
 =?utf-8?B?K0xxNHl2VFB2bDZEWGlvR0FxR1g2Rmt1VytMUnl5a0tiNFY1U3NxYURTbHRR?=
 =?utf-8?B?bHozQ3FuMFNLWXRucVMzdU9XeDZ1eEFlU2IrOUxsMlZzMUNpcVZwMUVGUEJY?=
 =?utf-8?B?WitnSW9oR2p0dDZqWDlDNWd5bTN3R2FIbHhsdFNGZEwwaVhybU9QYTB2dWFP?=
 =?utf-8?B?YjBvSW00bDF0NGpvUUZUQjR1aVI4Sm9kdFlnTnNRK2xGUHJ0NnEvRkQ4VG5w?=
 =?utf-8?B?OTVNUEIxU0VsWFdXSDd5ZjFzbGxUc0ZkWWV4SW5VWS9KdGw3R3dsRHFVR0ZL?=
 =?utf-8?B?RzBWZlAybWFRQTVXdjBtQUYxOE9KdUV3NTJxV0hpMHR0R3Z5ZjVnYXRkS2Ry?=
 =?utf-8?B?M09qM200V0w2RnhBTWZCMzVVS0Z6MUF0NTlpbWdSNUswUHM4TC9lNlhKbllx?=
 =?utf-8?B?WnBjN3BSN2pQR0J3RFBUUGlZRjJnWXBOMXY2VXI0VnVTbVVjODJNVFMyZlAz?=
 =?utf-8?B?SFQ4bWM0aUttSkFPZDRwY09HcjF1d1FCWU1jeXRFWDJSc3NZZUJNYTlVYlU4?=
 =?utf-8?B?TnY0bTliaDUvMHBHY2dNWFNCb1RnbHhxcEdHSlNTZXg4WFlSelVqTEVHM095?=
 =?utf-8?B?bXB1aytNQVdvWFFJQUVuLytIUG00Z2JiN2FFY0Mrby85d21VSGNPUTZiSXVv?=
 =?utf-8?B?V0hMRm5lcGJETkNMT1BwQ2lqWFplb284NWpPWUdpd2pGQ2hmclp3eFUwam1S?=
 =?utf-8?B?Q3g1d0o3clVEdmZHc2VieHVZVXlzVTRMdmYvMFo1MUJnOENtWmh4SmY2TFhi?=
 =?utf-8?B?M1p4WTQrbHVJZkt0Y3Z2QjRYT0FTTkRsWUh6MWZNOVlnSXJuQUhSTG1ERURx?=
 =?utf-8?B?U2R2U1FyRmF3bHF0TERUL2QzeHhCbVJGTmRkem9jTld5NHN5VDlQOTgwR053?=
 =?utf-8?B?YStrMUdtWm5VZk9BbjBKc0dCenI3WUg1czhBYkhiYzhsUU42bHRhT2RBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QUtKLzh5SzVDU0cwRFVhd1I0SVN2M0xBM0JLa1lFdERKb2t6clBsQmh1QzQ3?=
 =?utf-8?B?WGw5dnpEUGxnUnorcXZrU2tIVEh5bVNaT3FGN01TajArZGhIN0RvQ0d6dlUy?=
 =?utf-8?B?b25tWnZqM3lOOU95ZExQekl6V2lYVEpJZFkxVXRQS0xsVU9wVVJ2WDZWejlB?=
 =?utf-8?B?OGZFMGtEUXIrSDRmQkRtNlQ5bGF4MEFyOEJZNGNSa1ZoeGtzU1ZLNTRybkRF?=
 =?utf-8?B?ajZPanZUK28rdU5USyt5c2RpdDN2K2pOekFqZWEyNnF0QjJjdDRaTlc3bTNr?=
 =?utf-8?B?MUQvVmJzMGR1dzZPUHZiWkh1eFYvM3RmVDJ2bmphQU8vTlBrM1lJUTk1bThF?=
 =?utf-8?B?cUplYW1JTXEzWno0WjdqdzhjZFV5N05FeGxKOXVkTzExdEExVGQxcTVUT3ls?=
 =?utf-8?B?YzJlYXhYaERFL3BNblJSbWMxUkpTYzI1eXVEMHNIdzVHYlNyM1VnaEpBWkJj?=
 =?utf-8?B?UmRta2h6ZW0zcVIrWWY2NWdkcVczVVJpRWNEWkx2UXgzUG9iNEVLaU5JWVpv?=
 =?utf-8?B?VGhiTWkvUjRNcnpwZHRZNDVqRDk0WUhsSFpxajM3Mmlnd2hVajF6SDRKMkJr?=
 =?utf-8?B?UEhrOXFYdmxsQ3Nlc2NKeXhwZHJZTnJXTmg1a0ZQNmVhOFpWUGRNbG1ib1Nt?=
 =?utf-8?B?VzNLMVRzbXN6REh5VG1uelVJRXpXcCtEYUluUVlaUTRERG5NSWtWZGdGeVlQ?=
 =?utf-8?B?K2hVaHF6eldaTk9MaU9reG1QNlJWclZzMklsVi9tQ0xLaDVsR2k2S3ZmckxW?=
 =?utf-8?B?TEtPYjlZZ2QwN0wzK2tGTjJqdjlxT21LaVduSThNVjhTSWZCaVRRVUluY282?=
 =?utf-8?B?aFBlUzIycVF2YjZOeG95NlFCZW01MU5hdnBFK1NVM3lFRWxaOVVrRmtQbXpV?=
 =?utf-8?B?TXY3eDQyR2FRZDAxV2p2N1pYcnhRdzdmNDU5WjBOaFd3eFVKZ09pdnlQMDBn?=
 =?utf-8?B?K3ZzejJYNFhaZlhUa0x3aFhzWTRMT0tYYUdwYUZxZG5ZZWFEdlI0OHhXSGQz?=
 =?utf-8?B?R00zVzBkOXphMm82OGJWQjR4RlZ2VDZNMlpNVU8rMnZNaTgybjA3WUtheHh4?=
 =?utf-8?B?NVMyNFp3cWhGNHJOSzFVU3p0bkM1R0EvbGRBbkV6ckRTcmwvUjJtZEJjellU?=
 =?utf-8?B?aWVoOG42Q2hnMEJVcE9tRUdNazFyVFBheVFOQ3UveWk1NVBmL2ZDRlBmRi9N?=
 =?utf-8?B?cG5TS2NvR0dHbGpLQ2Vya2llOHRLRWdabjk2RnV3cVBxM2Yrc0NNa2hoK1lx?=
 =?utf-8?B?N3FVSnRrdGhWbXNXeGNTMmo0UjBxK3RGTWpyZWxaajF5SzZkZlAzZzZoKzUr?=
 =?utf-8?B?K0Q3aFNXaTlWeDBJbVRLZE9tOWdSclpBTlBMdTZpVnJ2d0RQdWM0aldpdGVs?=
 =?utf-8?B?dldXREg4OWkvQ2llWldQVENFUzFUMU80Q2JORDVSR2UxK3NMb253dDlFUmRR?=
 =?utf-8?B?OTQ3cEpCYzFzV1FDbTNKVlV1TmRrSEp5MFBhRFkzOVI1ZDF4a2RVM3p2SWRk?=
 =?utf-8?B?QjVHSElwUEZiQTNublBNOTVGaDNUZ1AzNmJlS0dKeGFhR2xKNUsycUdLQUpr?=
 =?utf-8?B?NWZJeVo2YXVnM3VYcnEwVUJyaiszdmJKdTFTNUFkb1QvRHh0VStLT0s4K29N?=
 =?utf-8?B?ZXNjdXgyRVp5Y0I1K2M2Q251a1YzNDI3NURHM3NRQnZwbXZKQUk4S1dudHFO?=
 =?utf-8?B?V2h1d2xIRVNXR3hHTXo1UTU2cUxCOVlwSHpZcnpUa01aa25pdTdxWkU0UFZn?=
 =?utf-8?B?Mlg1Y2t2MWk3dFhtZENzaGg1UHBFeGNkaFJ1S3pZTzVDaHdYaHBWZDBGOFFo?=
 =?utf-8?B?ZFZYOTlCRVkrRmNhVmkycHhBTERMUVVMbWZjV0lNWTRUWHlnWlRGS2FKRm9H?=
 =?utf-8?B?N3FZYXZGQ3NHZWpnL2NtWFFxeVNXRmtZeUwxWmNwSzUxN3VtcW5Qa05vM2pq?=
 =?utf-8?B?Wnp4a0VPSFNNbzVkU3d5dzlnMk9FcUR2Szh4YUlZTEQ4eStud1E2b3hSa1h1?=
 =?utf-8?B?YlczR2luU29CS2ZURjhZWXRzMmFEMUpyZE1vK244WWFOZmtLWE1YU2ZHbmZs?=
 =?utf-8?B?RWVCbEV5OEc4NGNtQmdQclRtbHoxa1JKYU80N1hMVHFWazFqWTZucFBOSXhQ?=
 =?utf-8?Q?0wqjwDluiht4QBw1VbgsCdpJS?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3569EEF855705E4AB4984DF912B6BB7F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b782a425-1490-4eaa-425d-08dc78b90e2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2024 10:38:58.1123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GOT8fSddU3DhvUrJtcEni/ZxLMSIaw1K2XCG1nP+XtrkRljh7dQHhV1PoOGgufxKJHP5VGW4oJepc5SYbCIpnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7442
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDI0LTA1LTE4IGF0IDE1OjQxICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gU2F0LCAyMDI0LTA1LTE4IGF0IDA1OjQyICswMDAwLCBIdWFuZywgS2FpIHdyb3Rl
Og0KPiA+IA0KPiA+IE5vLsKgIEkgbWVhbnQgInVzaW5nIGt2bV9tbXVfcGFnZS5yb2xlLm1pcnJv
cmVkX3B0IHRvIGRldGVybWluZSB3aGV0aGVyIHRvDQo+ID4gaW52b2tlIGt2bV94ODZfb3BzOjp4
eF9wcml2YXRlX3NwdCgpIiBpcyBub3QgY29ycmVjdC4NCj4gDQo+IEkgYWdyZWUgdGhpcyBsb29r
cyB3cm9uZy4NCj4gDQo+ID4gwqAgSW5zdGVhZCwgd2Ugc2hvdWxkDQo+ID4gdXNlIGZhdWx0LT5p
c19wcml2YXRlIHRvIGRldGVybWluZToNCj4gPiANCj4gPiDCoMKgwqDCoMKgwqDCoMKgaWYgKGZh
dWx0LT5pc19wcml2YXRlICYmIGt2bV94ODZfb3BzOjp4eF9wcml2YXRlX3NwdCgpKQ0KPiA+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKga3ZtX3g4Nl9vcHM6Onh4X3ByaXZhdGVfc3B0
ZSgpOw0KPiA+IMKgwqDCoMKgwqDCoMKgwqBlbHNlDQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAvLyBub3JtYWwgVERQIE1NVSBvcGVyYXRpb24NCj4gPiANCj4gPiBUaGUgcmVh
c29uIGlzIHRoaXMgcGF0dGVybiB3b3JrcyBub3QganVzdCBmb3IgVERYLCBidXQgYWxzbyBmb3Ig
U05QIChhbmQNCj4gPiBTV19QUk9URUNURURfVk0pIGlmIHRoZXkgZXZlciBuZWVkIHNwZWNpZmlj
IHBhZ2UgdGFibGUgb3BzLg0KPiANCj4gSSB0aGluayB0aGUgcHJvYmxlbSBpcyB0aGVyZSBhcmUg
YSBsb3Qgb2YgdGhpbmdzIHRoYXQgYXJlIG1vcmUgb24gdGhlIG1pcnJvcmVkDQo+IGNvbmNlcHQg
c2lkZToNCj4gIC0gQWxsb2NhdGluZyB0aGUgInJlYWwiIFBURSBwYWdlcyAoaS5lLiBzcC0+cHJp
dmF0ZV9zcHQpDQo+ICAtIFNldHRpbmcgdGhlIFBURSB3aGVuIHRoZSBtaXJyb3IgY2hhbmdlcw0K
PiAgLSBaYXBwaW5nIHRoZSByZWFsIFBURSB3aGVuIHRoZSBtaXJyb3IgaXMgemFwcGVkIChhbmQg
dGhlcmUgaXMgbm8gZmF1bHQpDQo+ICAtIGV0Yw0KPiANCj4gQW5kIG9uIHRoZSBwcml2YXRlIHNp
ZGUgdGhlcmUgaXMganVzdCBrbm93aW5nIHRoYXQgcHJpdmF0ZSBmYXVsdHMgc2hvdWxkIG9wZXJh
dGUNCj4gb24gdGhlIG1pcnJvciByb290Lg0KDQouLi4gYW5kIGlzc3VlIFNFQU1DQUxMIHRvIG9w
ZXJhdGUgdGhlIHJlYWwgcHJpdmF0ZSBwYWdlIHRhYmxlPw0KDQo+IA0KPiBUaGUgeHhfcHJpdmF0
ZV9zcHRlKCkgb3BlcmF0aW9ucyBhcmUgYWN0dWFsbHkganVzdCB1cGRhdGluZyB0aGUgcmVhbCBQ
VEUgZm9yIHRoZQ0KPiBtaXJyb3IuIEluIHNvbWUgd2F5cyBpdCBkb2Vzbid0IGhhdmUgdG8gYmUg
YWJvdXQgInByaXZhdGUiLiBJdCBjb3VsZCBiZSBhIG1pcnJvcg0KPiBvZiBzb21ldGhpbmcgZWxz
ZSBhbmQgc3RpbGwgbmVlZCB0aGUgdXBkYXRlcy4gRm9yIFNOUCBhbmQgb3RoZXJzIHRoZXkgZG9u
J3QgbmVlZA0KPiB0byBkbyBhbnl0aGluZyBsaWtlIHRoYXQuIChBRkFJVSkNCg0KQUZBSUNUIHh4
X3ByaXZhdGVfc3B0ZSgpIHNob3VsZCBpc3N1ZSBTRUFNQ0FMTCB0byBvcGVyYXRlIHRoZSByZWFs
IHByaXZhdGUNCnBhZ2UgdGFibGU/DQoNCj4gDQo+IFNvIGJhc2VkIG9uIHRoYXQsIEkgdHJpZWQg
dG8gY2hhbmdlIHRoZSBuYW1pbmcgb2YgeHhfcHJpdmF0ZV9zcHQoKSB0byByZWZsZWN0DQo+IHRo
YXQuIExpa2U6DQo+IGlmIChyb2xlLm1pcnJvcmVkKQ0KPiAgIHVwZGF0ZV9taXJyb3JlZF9wdGUo
KQ0KPiANCj4gVGhlIFREWCBjb2RlIGNvdWxkIGVuY2Fwc3VsYXRlIHRoYXQgbWlycm9yZWQgdXBk
YXRlcyBuZWVkIHRvIHVwZGF0ZSBwcml2YXRlIEVQVC4NCj4gVGhlbiBJIGhhZCBhIGhlbHBlciB0
aGF0IGFuc3dlcmVkIHRoZSBxdWVzdGlvbiBvZiB3aGV0aGVyIHRvIGhhbmRsZSBwcml2YXRlDQo+
IGZhdWx0cyBvbiB0aGUgbWlycm9yZWQgcm9vdC4NCg0KSSBhbSBmaW5lIHdpdGggdGhpcyB0b28s
IGJ1dCBJIGFtIGFsc28gZmluZSB3aXRoIHRoZSBleGlzdGluZyBwYXR0ZXJuOg0KDQpUaGF0IHdl
IHVwZGF0ZSB0aGUgbWlycm9yZWRfcHQgdXNpbmcgbm9ybWFsIFREUCBNTVUgb3BlcmF0aW9uLCBh
bmQgdGhlbg0KaW52b2tlIHRoZSB4eF9wcml2YXRlX3NwdGUoKSBmb3IgcHJpdmF0ZSBHUEEuDQoN
Ck15IG9ubHkgdHJ1ZSBjb21tZW50IGlzLCB0byBtZSBpdCBzZWVtcyBtb3JlIHJlYXNvbmFibGUg
dG8gaW52b2tlDQp4eF9wcml2YXRlX3NwdGUoKSBiYXNlZCBvbiBmYXVsdC0+aXNfcHJpdmF0ZSwg
YnV0IG5vdCBvbg0KJ3VzZV9taXJyb3JlZF9wdCcuDQoNClNlZSBteSByZXBseSB0byB5b3VyIHF1
ZXN0aW9uIHdoZXRoZXIgU05QIG5lZWRzIHNwZWNpYWwgaGFuZGxpbmcgYmVsb3cuDQoNCj4gDQo+
IFRoZSBGUkVFWkUgc3R1ZmYgYWN0dWFsbHkgbWFkZSBhIGJpdCBtb3JlIHNlbnNlIHRvbywgYmVj
YXVzZSBpdCB3YXMgY2xlYXIgaXQNCj4gd2Fzbid0IGEgc3BlY2lhbCBURFggcHJpdmF0ZSBtZW1v
cnkgdGhpbmcsIGJ1dCBqdXN0IGFib3V0IHRoZSBhdG9taWNpdHkuDQo+IA0KPiBUaGUgcHJvYmxl
bSB3YXMgSSBjb3VsZG4ndCBnZXQgcmlkIG9mIGFsbCBzcGVjaWFsIHRoaW5ncyB0aGF0IGFyZSBw
cml2YXRlIChjYW4ndA0KPiByZW1lbWJlciB3aGF0IG5vdykuDQo+IA0KPiBJIHdvbmRlciBpZiBJ
IHNob3VsZCBnaXZlIGl0IGEgbW9yZSBwcm9wZXIgdHJ5LiBXaGF0IGRvIHlvdSB0aGluaz8NCj4g
DQo+IEF0IHRoaXMgcG9pbnQsIEkgd2FzIGp1c3QgZ29pbmcgdG8gY2hhbmdlIHRoZSAibWlycm9y
ZWQiIG5hbWUgdG8NCj4gInByaXZhdGVfbWlycm9yZWQiLiBUaGVuIGNvZGUgdGhhdCBkb2VzIGVp
dGhlciBtaXJyb3JlZCB0aGluZ3Mgb3IgcHJpdmF0ZSB0aGluZ3MNCj4gYm90aCBsb29rcyBjb3Jy
ZWN0LiBCYXNpY2FsbHkgbWFraW5nIGl0IGNsZWFyIHRoYXQgdGhlIE1NVSBvbmx5IHN1cHBvcnRz
DQo+IG1pcnJvcmluZyBwcml2YXRlIG1lbW9yeS4NCg0KSSBkb24ndCBoYXZlIHByZWZlcmVuY2Ug
b24gbmFtZS4gICJtaXJyb3JlZF9wcml2YXRlIiBhbHNvIHdvcmtzIGZvciBtZS4NCg0KPiANCj4g
PiANCj4gPiBXaGV0aGVyIHdlIGFyZSBvcGVyYXRpbmcgb24gdGhlIG1pcnJvcmVkIHBhZ2UgdGFi
bGUgb3Igbm90IGRvZXNuJ3QgbWF0dGVyLA0KPiA+IGJlY2F1c2Ugd2UgaGF2ZSBhbHJlYWR5IHNl
bGVjdGVkIHRoZSByb290IHBhZ2UgdGFibGUgYXQgdGhlIGJlZ2lubmluZyBvZg0KPiA+IGt2bV90
ZHBfbW11X21hcCgpIGJhc2VkIG9uIHdoZXRoZXIgdGhlIFZNIG5lZWRzIHRvIHVzZSBtaXJyb3Jl
ZCBwdCBmb3INCj4gPiBwcml2YXRlIG1hcHBpbmc6DQo+IA0KPiBJIHRoaW5rIGl0IGRvZXMgbWF0
dGVyLCBlc3BlY2lhbGx5IGZvciB0aGUgb3RoZXIgb3BlcmF0aW9ucyAobm90IGZhdWx0cykuIERp
ZA0KPiB5b3UgbG9vayBhdCB0aGUgb3RoZXIgdGhpbmdzIGNoZWNraW5nIHRoZSByb2xlPw0KDQpZ
ZWFoIEkgc2hvdWxkbid0IHNheSAiZG9lc24ndCBtYXR0ZXIiLiAgSSBtZWFudCB3ZSBjYW4gZ2V0
IHRoaXMgZnJvbSB0aGUNCml0ZXItPnNwZXRwIG9yIHRoZSByb290Lg0KDQo+IA0KPiA+IA0KPiA+
IA0KPiA+IMKgwqDCoMKgwqDCoMKgwqBib29sIG1pcnJvcmVkX3B0ID0gZmF1bHQtPmlzX3ByaXZh
dGUgJiYga3ZtX3VzZV9taXJyb3JlZF9wdChrdm0pOw0KPiA+IA0KPiA+IMKgwqDCoMKgwqDCoMKg
wqB0ZHBfbW11X2Zvcl9lYWNoX3B0ZShpdGVyLCBtbXUsIG1pcnJvcmVkX3B0LCByYXdfZ2ZuLCBy
YXdfZ2ZuICsNCj4gPiAxKSANCj4gPiDCoMKgwqDCoMKgwqDCoMKgew0KPiA+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgLi4uDQo+ID4gwqDCoMKgwqDCoMKgwqDCoH0NCj4gPiANCj4g
PiAjZGVmaW5lIHRkcF9tbXVfZm9yX2VhY2hfcHRlKF9pdGVyLCBfbW11LCBfbWlycm9yZWRfcHQs
IF9zdGFydCwgX2VuZCnCoMKgIFwNCj4gPiDCoMKgwqDCoMKgwqDCoCBmb3JfZWFjaF90ZHBfcHRl
KF9pdGVyLMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFwNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCByb290X3RvX3NwKChfbWlycm9yZWRfcHQpID8gX21tdS0+cHJpdmF0ZV9y
b290X2hwYSA6wqDCoCBcDQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgX21tdS0+cm9vdC5ocGEpLMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgXA0KPiA+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBfc3RhcnQsIF9lbmQpDQo+ID4gDQo+ID4gSWYgeW91IHNvbWVob3cgbmVl
ZHMgdGhlIG1pcnJvcmVkX3B0IGluIGxhdGVyIHRpbWUgd2hlbiBoYW5kbGluZyB0aGUgcGFnZQ0K
PiA+IGZhdWx0LCB5b3UgZG9uJ3QgbmVlZCBhbm90aGVyICJtaXJyb3JlZF9wdCIgaW4gdGRwX2l0
ZXIsIGJlY2F1c2UgeW91IGNhbg0KPiA+IGVhc2lseSBnZXQgaXQgZnJvbSB0aGUgc3B0ZXAgKG9y
IGp1c3QgZ2V0IGZyb20gdGhlIHJvb3QpOg0KPiA+IA0KPiA+IMKgwqDCoMKgwqDCoMKgwqBtaXJy
b3JlZF9wdCA9IHNwdGVwX3RvX3NwKHNwdGVwKS0+cm9sZS5taXJyb3JlZF9wdDsNCj4gPiANCj4g
PiBXaGF0IHdlIHJlYWxseSBuZWVkIHRvIHBhc3MgaW4gaXMgdGhlIGZhdWx0LT5pc19wcml2YXRl
LCBiZWNhdXNlIHdlIGFyZQ0KPiA+IG5vdCBhYmxlIHRvIGdldCB3aGV0aGVyIGEgR1BOIGlzIHBy
aXZhdGUgYmFzZWQgb24ga3ZtX3NoYXJlZF9nZm5fbWFzaygpDQo+ID4gZm9yIFNOUCBhbmQgU1df
UFJPVEVDVEVEX1ZNLg0KPiANCj4gU05QIGFuZCBTV19QUk9URUNURURfVk0gKHRvZGF5KSBkb24n
dCBuZWVkIGRvIGFueXRoaW5nIHNwZWNpYWwgaGVyZSwgcmlnaHQ/DQoNCkNvbmNlcHR1YWxseSwg
SSB0aGluayBTTlAgYWxzbyBuZWVkcyB0byBhdCBsZWFzdCBpc3N1ZSBzb21lIGNvbW1hbmQocykg
dG8NCnVwZGF0ZSB0aGUgUk1QIHRhYmxlIHRvIHJlZmxlY3QgdGhlIEdGTjwtPlBGTiByZWxhdGlv
bnNoaXAuICBGcm9tIHRoaXMNCnBvaW50LCBJIGRvIHNlZSBhIGZpdC4NCg0KSSBicmllZmx5IGxv
b2tlZCBpbnRvIFNOUCBwYXRjaHNldCwgYW5kIEkgYWxzbyByYWlzZWQgdGhlIGRpc2N1c3Npb24g
dGhlcmUNCih3aXRoIHlvdSBhbmQgSXNha3UgY29waWVkKToNCg0KaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvbGttbC8yMDI0MDUwMTA4NTIxMC4yMjEzMDYwLTEtbWljaGFlbC5yb3RoQGFtZC5jb20v
VC8jbThjYTU1NGE2ZDRiYWQ3ZmE5NGRlZGVmY2Y1OTE0ZGYxOWM5YjgwNTENCg0KSSBjb3VsZCBi
ZSB3cm9uZywgdGhvdWdoLg0K

