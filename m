Return-Path: <kvm+bounces-44815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A787AA15FC
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 19:33:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D9C55A315E
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 17:26:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBE44253326;
	Tue, 29 Apr 2025 17:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EKgcsas3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15ACA2472BC;
	Tue, 29 Apr 2025 17:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947560; cv=fail; b=bvV3LI4jN+/omyQCL3K8r6k1WWrqzcRlBAkRPWeIgDENPHsW40z3CK92+L+q9eRxtp30p4G9WW0AZkSsngiMzBen6uqiwk9fQvACvVxbDQ6X9FgQ7CzJBlQjIF6xZJogen4BJGzt+QERsb0E0Em+7ducjUy0C84pX4XxV2bqmxo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947560; c=relaxed/simple;
	bh=Ap8jFjDdZJJGKB0acwkxLrK7/lwt2jHtwo9Dx3WcE4I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ntg3Xv+Sai/ZXjWRodUBZpHtmTNYh6i9jrVcqyMy66QPdtn7kCJOBdJB987gWg89EVQ3QrwR62tWDcN/moA79v4d3JrPrDSyWR+/dwHjmb6G9707OaeYQlDVmoEQwoRuVbfhzKmTZ6cyFx1AuCJq8B/2J3oPFId8xp4zSGkaZwk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EKgcsas3; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745947559; x=1777483559;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Ap8jFjDdZJJGKB0acwkxLrK7/lwt2jHtwo9Dx3WcE4I=;
  b=EKgcsas3i9Bn3E3IBXts/QoXs1hExq8wJle/7GsPYpsI2AHQvtmzJHGy
   7rSqFlGGUjXwPNBBT2Jao+QgA1jCt7dgApB+G4VbsegvVz9cqjs6vaz0T
   YosNSuzNrfkQRzLCD4MefjIzLQBIeNk0x7aR2WGjXvUVXLrUZJohxqlF/
   mg+fx/i36a4yCCCuTm8Rv/aFIYETKg9U9nQRt1+/GUC90STfjxF4Bekr/
   htsCBL4MyyrLEM/HudN1na/oByUWkY+cGo2Rfe1fbfUl3QcvLcV5fW/Mi
   ip/ETCdPJsmRcnBrdjVg/WJjsHCYmD517ap+JP4FBUyzFtpzZVejLkrAL
   w==;
X-CSE-ConnectionGUID: IP8bEGXxS4GIY1VgmDm5Yw==
X-CSE-MsgGUID: r+Ne4hDSRq27H0TwULPydw==
X-IronPort-AV: E=McAfee;i="6700,10204,11418"; a="35197291"
X-IronPort-AV: E=Sophos;i="6.15,249,1739865600"; 
   d="scan'208";a="35197291"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2025 10:25:59 -0700
X-CSE-ConnectionGUID: JxUHZ9FgQNmaUhio1xHmxA==
X-CSE-MsgGUID: 0ICAoVu0S42zytDq5vKDsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,249,1739865600"; 
   d="scan'208";a="134398046"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2025 10:25:58 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 29 Apr 2025 10:25:57 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 29 Apr 2025 10:25:57 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 29 Apr 2025 10:25:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RCAFChevISBvx9I2s1SRXJ30BCBcfrtnHodb8tTV30Pc2oYnEssCdEDxNn77nFq19PVCRcWaq+bMe6RGLXs6j+NYNcIszVP1ok2AY8dpR/DLyQfCyzjhcW25wJzHBva0IKhi97sjTGbw7ezT4Wqxnh1ppzvukbCRnv8lzSbk0f4bKbHjR2vp6rLGDhy+H7vUH6Vr7eU9ZZXjFYbA7eKsoZ4XtHJls0tUVgBvn0DidCOPaoQbfyCaanRsNP7TkZEUVn4VWD3Bq5e0WSEX/GvhlJOXBon7kpOntttQo2whHt5fLu0Cw+CgfWee69LBB1BrCNRdZtVMQOkRKtd5jUT9Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ap8jFjDdZJJGKB0acwkxLrK7/lwt2jHtwo9Dx3WcE4I=;
 b=FAdZZQ3cUGK2F8pqGFFFJlAnwZ7DUozePQqLSASCRIXB8Au2TEEahGv2gIXzTilmG0l+P7jD6hNX0gtcy2RVPDgu1kHQJhlv69/uERglnj4mfZlQlLJDyIl8cAtr2+DSLUI1owwSqEbVv1yc4Dqjf+yNZD5fxykLjlU0U+BXgGLxUUIOfh4wIXj7KXh9WAHnx4/kp79DG2M4IqMwBBz/PbB087XRX1iB9RA22Vyi5pZEU3ZqTPrHYlh4KCfremKSoeJAEa0Fw1OEHes41IoF967oJiJFiFsoEUootJtdgKq09e5mWitcwyaPNFHFMy402oReJ8iG1MdIbtaoIICw9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB7109.namprd11.prod.outlook.com (2603:10b6:806:2ba::17)
 by DM4PR11MB6501.namprd11.prod.outlook.com (2603:10b6:8:88::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8678.34; Tue, 29 Apr 2025 17:25:41 +0000
Received: from SA1PR11MB7109.namprd11.prod.outlook.com
 ([fe80::b270:467d:3ba6:16f0]) by SA1PR11MB7109.namprd11.prod.outlook.com
 ([fe80::b270:467d:3ba6:16f0%3]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 17:25:40 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linxu.intel.com"
	<binbin.wu@linxu.intel.com>
Subject: Re: [PATCH v2 2/4] KVM: VMX: Move apicv_pre_state_restore to
 posted_intr.c
Thread-Topic: [PATCH v2 2/4] KVM: VMX: Move apicv_pre_state_restore to
 posted_intr.c
Thread-Index: AQHbl9ACMiSc4J4NgEOr1VK9VhY717O6jqUAgACZLQA=
Date: Tue, 29 Apr 2025 17:25:40 +0000
Message-ID: <400a69c2c01a230b8aedf684056bdb21eea13261.camel@intel.com>
References: <20250318-vverma7-cleanup_x86_ops-v2-0-701e82d6b779@intel.com>
	 <20250318-vverma7-cleanup_x86_ops-v2-2-701e82d6b779@intel.com>
	 <aBCLFB7BS/vhSAuk@intel.com>
In-Reply-To: <aBCLFB7BS/vhSAuk@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB7109:EE_|DM4PR11MB6501:EE_
x-ms-office365-filtering-correlation-id: 2b3968ad-2227-4824-bfdd-08dd8742dd71
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Y2Mxd1BQYWNOaTF5N1IxaEk0L3NpNzQ0WG9ISDExT1JMaXdBMTFOOHZ2S1ZH?=
 =?utf-8?B?UnFVNDJDRlV2NmxvMHVqVDBsSElTSVREV2QyNVQvalpOM0Q5c3RxMndOVHk3?=
 =?utf-8?B?bFhObnlJNVhySWFQS1I4VmtrMWJFYk9sYXVweWVkaWVlVnljN3JQa21na3pQ?=
 =?utf-8?B?UXB2ZmpzSGg2TGR1SXVZWEd2V0ZEbDY4Y3BZS3FBbTh3U1U5eXhyRHdLL1BZ?=
 =?utf-8?B?YkVIZVhCSmgxNFZjUjI1RUFIL0FpRCtFaVYxTFY5NlNXemxlYkEwRmJTV3Nl?=
 =?utf-8?B?QVdkZW45RXBZLzRkT3BML1luUkRUeUUwY1NRclZTNTlwV3dwbyt6dGp1ejRB?=
 =?utf-8?B?bVFvT1lsWkVScnJsbGx6NjVXaGE0b1JlRnBYZm4zUlFhUTZkdGJVNmJMU1o0?=
 =?utf-8?B?UkZUaGo2aVRLOE1FaWorTHpoZWdGc2kwZFFvQzF3d3dJcTJTNXNhMXFKenpt?=
 =?utf-8?B?QjRhMElMU3loR29EeVZHd1B4TlNtKzNxajNUbVJCbjExOW0ySjl5YUc1Ukts?=
 =?utf-8?B?MW1Fa0tic2IvV2RoeloxNjliTng0dVk3UUpsbVRPQXZWbFlocHhZR0hPYWV4?=
 =?utf-8?B?aXhrNUlPRzUzcGs5STZ1WmFKb3dSOTUrdTVxRWludTRLMWFrY2hYaVhBYTVB?=
 =?utf-8?B?bnhDUEtYdEVIbkxDeDZDNnhTVnpVV21CZnY3cnk2NlZtNGtseitMYzJXTGQ2?=
 =?utf-8?B?RTNGUlk0S2VBa0xrcDgrOXZsLzl1LzJONVVHdmtoZ2NUTGFkb3RHS1ZWVzB4?=
 =?utf-8?B?Q0dRc0JhRjkwYWhZZnNHOGE2UGdQb0pyeDZ2S1R3MHZKaXc0ZTlHNVloeGVi?=
 =?utf-8?B?dXJ2eW9xVTBheTZYdXdweVZYNW43SFhhL3Z6aEpCVkYrUDZla0lNY2tVUHor?=
 =?utf-8?B?NWZuQ0JjNDJ5b0dUTHliSGVja0prM2lKZndTQVZQaTFBd3hscjJRNkpsREEx?=
 =?utf-8?B?NXdRL3gyb2xWRjNZYzU2NElFRjJMNlp1TUNjT2R2QjBVbm5jQUZNTUgyL1kv?=
 =?utf-8?B?WXNkL005VU9OWVREZnplYldsYTJHeC9KQzBjeFVRdkNubFNhOW9jVzUxRkZC?=
 =?utf-8?B?QWtPeVFsakEreldUUFJuRmp0MVU0VUc4dzY0RlRYUUR6VTZEYnRFanRJdFNw?=
 =?utf-8?B?UHYrWmF3MldrUm5oMmhFWmFzTm5vc2V0NDdWREZ3dzZuR2pCNUlxU1NIMWNo?=
 =?utf-8?B?bTlLY3VFZ2hJb2QzdWhkUFFNdzdneDZ5ZDJuQjNZSjBOZXNERDZ1NURBUFFW?=
 =?utf-8?B?bHhreGI3dytLdUZibVpkUk5CMkFWSG1tdncxM2NKeWlFTzJjajNFTGQ5aVYy?=
 =?utf-8?B?NUovSmU4MGxYdzJlUHhleklnaXZPUWM2UXJueHhoUzJEQ3pxR3ZodG9YcE93?=
 =?utf-8?B?OFB1a1QwbjcwWGZTUmdwaHg3WWl0RlkrYUd3eEl0SlhzZmdiQUd2ckNXL2JP?=
 =?utf-8?B?ZWpTSVE3WHd6UmNod3hmTGpqZXlJNkdVZUlCWlpNTXZxalFza01mNXVqSmlY?=
 =?utf-8?B?SzN6a3JtK3BXVVpwdzQxb2lMOUJtZEVSTGF0TDlGRDdyNzhuSER6S01pSGVh?=
 =?utf-8?B?VncxVUdXT3FkUlNja3o0MG05NDhCYnhNY2FJZndRaEYrdFVubVp2bDQxcU1i?=
 =?utf-8?B?VVMzUDlMM0ZPcXdWaDRFNDNscjJZckhWcjE0N0ZlMTVDTXJNRUVIR05NMDV4?=
 =?utf-8?B?Qk5vQ0FnR01TTGMwZjk1SDhhd1RocWVhdUF0eU9kcWNDaEZjOEZkc2ZHTWla?=
 =?utf-8?B?Wkc3QktHMXcvRDRFOWpJQUIyajNJcFc3eW1yQWliL1djS2F0M1hrVng2d1h0?=
 =?utf-8?B?VkM4QytuK293SU54czhZUmpQYzJ3QTRPbU5lVDJ5dG0yNEt0eDg1bDBHMTJn?=
 =?utf-8?B?YXNBQzZta0txM1BOa3djc2NVWDVscTc4dWo1TzhZYjA3MXY2ZGZZamp4OEVo?=
 =?utf-8?B?eWVqeWpwT3lNaEVXSkg2YmxjL1Q3ZVBydTVlZHpQaCtIUCsvQy9qUjhta0hV?=
 =?utf-8?B?WS9DZ1dLUXpBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB7109.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S1Zlb1laZWpCcmF2d1RFdTh2MkFOeVhwc1dLZnEwdVJKOVBoNC85OFlHbkFi?=
 =?utf-8?B?Wkc3UFE2K1BOMUR3dGNTZ1BUckwxakw5MzE3V3g2a2w1RFVCQ2ZXbUxPQ2tm?=
 =?utf-8?B?aGkwSjFkeEVIUXBFL3c3TGNJU1N3SkFYbUR0M0ZaZ044OGVwOEFwdkJlbVdG?=
 =?utf-8?B?ZWYra2p6ekQ5YWhheDUrWlkxWVFJOXl6MDU5enRDQ1VoZyt4T013eG55Rldq?=
 =?utf-8?B?VTJqaTVKdDRYK1QzcmtpQUNLYlZHRExnWktKSmVBSnlGMzRUOWtnd3hXMCtP?=
 =?utf-8?B?dUFKakY2QlA5bGNEY3RTdGQ1amxYa3ZsR3JIclVXN09KN0pKUzYreWlZbTZD?=
 =?utf-8?B?cmpteVFrUnlUU1UzWmVnajNIZEs1UkRQRkY5c2xaZ3ZWdSsyNjdJYTBUTGwr?=
 =?utf-8?B?U2gralVSL2hGdFVQR3V1MzVlaHl2bisrVHg1N0VOZzdrNGlRcjNMUFRhOXZI?=
 =?utf-8?B?bURVWDN5OW9mQ3Zsb2d6TlBJc3QzdHdZVVhrTXdERHdNVngrWm9kaG5xR1Fl?=
 =?utf-8?B?eVZ5MkFVdUV3VFM0TTl3ZVhaSDBrZFRZR2lKZUp3QXdTbEF2bVduSTBhZGl0?=
 =?utf-8?B?amJaZ3Z6RkMyNTgyYzhyaVY2eUprMExONFRsOG5XM2Y5YmRxazI2QUxOeHN5?=
 =?utf-8?B?UmxHVFF6Qmg2bjJERXJ1ekM4ZW5xS2ZMT0d4YzY1N3BwRGVPM1JlcmxhOWN5?=
 =?utf-8?B?RUYzRkxaakxOZjIvUmxjYUYvWkFOTnV5UVhHdFZmMm5PVG52TVBJU2RUTDdQ?=
 =?utf-8?B?MFJHaGR4K29YMHJ4VWJyeUJkbThvYk5GV1FESlVKbEFYTDlIcHQya1dnTDZP?=
 =?utf-8?B?eFBVaytjTm9ubFhTUGgwaWhpdWtrY2xrYWowTjhhTkJRM0NzSkhBeVREZTc4?=
 =?utf-8?B?cFd5bW5zRFRSeE91WlJ0WFkxVVplUkN6djRiSktSOVMxTkRrZExrZDVUTlZE?=
 =?utf-8?B?UG1IWXBsZWZmK3l5YzFReVo1UHdrNmtqbDFObHRtRTUvbjMwMyt3NkZOWmE1?=
 =?utf-8?B?aFNMNWdDc0RzUXNpdUZya0pzREF4VnErTFlDM0RBVXg1TVZMV3U5K0dqYlVm?=
 =?utf-8?B?UGRLemRIa09YWDBDalRxT3BqM1JsSzk3aXhFNU5iRkt5aHlycEwrK1Y0bXI1?=
 =?utf-8?B?L3k3YWR1T1hYc2RrWFlrbDQ3eXh0eG14M2x4RmpERzlPWTUxOFcrSnZxYTha?=
 =?utf-8?B?T05JbWtBWlQzVkpxc29ZdWprRnlvd0kyMDRpMDJrblVTREs5UHFmU0RyZFdO?=
 =?utf-8?B?ZzU1RXU5UUdhakVIZ0VqUk9xTVlrR21mMk04WHNsUkdjOCtyaEErZEpEQVlU?=
 =?utf-8?B?azdmcTQvK2xrbitXa2F5MXN1V1F4ek5IRGppWmtlQmZla3hXSVFQNFF4ZldJ?=
 =?utf-8?B?b0JVVGtGemY1by9ZVEJsSFhwZ053MkE1TU5Sd3JFemRLbll2MktDTmRPUmpO?=
 =?utf-8?B?a3E0enVnL083cXJqVHpnTjNkcEt2TVhSRTZ0ajRCU3JWd3FTSXBUZVZqbXBu?=
 =?utf-8?B?YlJIUjROQUYxeGs3eXR0U1MvbGx5QjZJK3hVekEyS1VSSDdBZUxqSVJRQ2V6?=
 =?utf-8?B?TUIzN2xUd0p1YmhFNDFxS2JFd3V5NUdnRElJV3VXdXB2N05MYlJMOTJIUzdG?=
 =?utf-8?B?Zmd1WU9JWjFZMkxzOENMQVEyeVZNNGhCRERMbEMvVGY1M0FHenBaYk81dFVi?=
 =?utf-8?B?cnJ6VFU4VDdTVGNSSk9SazhtVTc4QUJKTzB5WERlRG9EYUtmTlU2andyRTM3?=
 =?utf-8?B?aDhWOGNzeVRJZHd2MW1rbnFIVENrcEpCNm9hZTIxZVdlUW9jeFVrLzV3Skts?=
 =?utf-8?B?RjE4UXFIRDE2WFZsMTQxUjh2K2pZR3d2bFhJTGcxTkdYUjBoMUlQUXRCQitW?=
 =?utf-8?B?UTRKWURwNHcyNkcxMlJlWnRhU0Noc3JpZzBpcUt6TnBtZzMrcWYxbjM1bDdD?=
 =?utf-8?B?WXRiN3c5ZmVuWlRKOS9qTSswclZ4Z1A5cFR0b2t5c1l0RE5oUzQxa3Bqd01J?=
 =?utf-8?B?WU1lYytENlBhckRNVHVmWFZpNUphclhtWE1PeE13dkZvSXlWMlBXSVlWRzJR?=
 =?utf-8?B?SzVoeUVaemxmVklHVHJ3Q0Y3Y0ZOYm9oQXhmNHk5OXhNWkp1Y1FFeGRGZDN2?=
 =?utf-8?B?SWVSUjFLcGdvSXB2dVJkU0YyTTFraEwvelVFZTBBbll4bUl3WTdEV1p3N1N0?=
 =?utf-8?B?TEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <400B1B465812E64DB6F55A52DE81C9B2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB7109.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b3968ad-2227-4824-bfdd-08dd8742dd71
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2025 17:25:40.9002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /lPwy9sO/cCLdgpAnxRVnWDeO1XB3lYDh/XEoevIu0JpiW3Y6ZE61x2c1lFORCh2nvuVUUAUmk+0AQgXNakBPwjyRc2w+NtVXKcfg+pfTPU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6501
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA0LTI5IGF0IDE2OjE3ICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gT24g
VHVlLCBNYXIgMTgsIDIwMjUgYXQgMTI6MzU6MDdBTSAtMDYwMCwgVmlzaGFsIFZlcm1hIHdyb3Rl
Og0KPiA+IEluIHByZXBhcmF0aW9uIGZvciBhIGNsZWFudXAgb2YgdGhlIHg4Nl9vcHMgc3RydWN0
IGZvciBURFgsIHdoaWNoIHR1cm5zDQo+ID4gc2V2ZXJhbCBvZiB0aGUgb3BzIGRlZmluaXRpb25z
IHRvIG1hY3JvcywgbW92ZSB0aGUNCj4gPiB2dF9hcGljdl9wcmVfc3RhdGVfcmVzdG9yZSgpIGhl
bHBlciBpbnRvIHBvc3RlZF9pbnRyLmMuDQo+IA0KPiBUaGlzIGRvZXNuJ3QgZXhwbGFpbiBob3cg
dGhlIG1vdmVtZW50IGlzIHJlbGF0ZWQgdG8gdGhhdCBjbGVhbnVwLg0KPiANCj4gaG93IGFib3V0
Og0KPiANCj4gSW4gcHJlcGFyYXRpb24gZm9yIGEgY2xlYW51cCBvZiB0aGUga3ZtX3g4Nl9vcHMg
c3RydWN0IGZvciBURFgsIGFsbCB2dF8qDQo+IGZ1bmN0aW9ucyBhcmUgZXhwZWN0ZWQgdG8gYWN0
IGFzIGdsdWUgZnVuY3Rpb25zIHRoYXQgcm91dGUgdG8gZWl0aGVyIHRkeF8qDQo+IG9yIHZteF8q
IGJhc2VkIG9uIHRoZSBWTSB0eXBlLiBTcGVjaWZpY2FsbHksIHRoZSBwYXR0ZXJuIGlzOg0KPiAN
Cj4gdnRfYWJjOg0KPiDCoMKgwqAgaWYgKGlzX3RkKCkpDQo+IMKgwqDCoMKgwqDCoMKgIHJldHVy
biB0ZHhfYWJjKCk7DQo+IMKgwqDCoCByZXR1cm4gdm14X2FiYygpOw0KPiANCj4gQnV0IHZ0X2Fw
aWN2X3ByZV9zdGF0ZV9yZXN0b3JlKCkgZG9lcyBub3QgZm9sbG93IHRoaXMgcGF0dGVybi4gVG8N
Cj4gZmFjaWxpdGF0ZSB0aGF0IGNsZWFudXAsIHJlbmFtZSBhbmQgbW92ZSB2dF9hcGljdl9wcmVf
c3RhdGVfcmVzdG9yZSgpIGludG8NCj4gcG9zdGVkX2ludHIuYy4NCg0KSGkgQ2hhbywNCg0KVGhh
bmtzIGZvciB0aGUgc3VnZ2VzdGlvbiwgSSd2ZSBhZGRlZCB0aGlzIGZvciB0aGUgbmV4dCByZXZp
c2lvbi4NCg0KPiANCj4gPiANCj4gPiBCYXNlZCBvbiBhIHBhdGNoIGJ5IFNlYW4gQ2hyaXN0b3Bo
ZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiANCj4gWW91IGNhbiBjb25zaWRlciBhZGRpbmcg
aGlzIFN1Z2dlc3RlZC1ieS4NCg0KRG9uZS4NCg0KPiANCj4gPiAtc3RhdGljIHZvaWQgdnRfYXBp
Y3ZfcHJlX3N0YXRlX3Jlc3RvcmUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+IC17DQo+ID4g
LQlzdHJ1Y3QgcGlfZGVzYyAqcGkgPSB2Y3B1X3RvX3BpX2Rlc2ModmNwdSk7DQo+IA0KPiBXaXRo
IHRoaXMgcmVtb3ZhbCwgdmNwdV90b19waV9kZXNjKCkgaXMgb25seSB1c2VkIHdpdGhpbiBwb3N0
ZWRfaW50ci5jLiBubw0KPiBuZWVkIHRvIGV4cG9zZSBpdC4NCg0KR29vZCBmaW5kLCBkb25lLg0K

