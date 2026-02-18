Return-Path: <kvm+bounces-71267-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EFhYKwAVlmlOZwIAu9opvQ
	(envelope-from <kvm+bounces-71267-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 20:37:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 189261591CA
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 20:37:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0D460303799F
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 19:37:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC24F348457;
	Wed, 18 Feb 2026 19:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="loIU6SgK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9B7347FE1;
	Wed, 18 Feb 2026 19:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771443434; cv=fail; b=Mh4fEL6uAczsx4UbgmbRF4Tm4OpgbbSH3fIUMi5GQxR7++M4MiavAIokZju73EyEQM654yUWzYCED4V2GbhnGT3H5aiic39JTN9eTv6vzYCmNdv/FheeD7ahDtyO/XNGTvTtQvbWM8JzWuZUY4PTkjY5cFQdLR95BSuvHsC5UsE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771443434; c=relaxed/simple;
	bh=8Eg0esLDvl08ASZMfbpa7QGvDQCoC4ZgdplNas4bhqA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JmLGuRnZi44GEnWZ41Ldw0UBxo+EdDMydPNhW+Q2SU4YaqhicajvxN+i6+eHB2Ipq6b0MmhUgOf/w2Ehfj/35aJpUJVulTakZkYys0M40lnvQSgiF1W3DEU2FVP3i04QqOBb/aPQAFrP6aGvKftQXfq+4kFcXzQiw+hGCRMSfHw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=loIU6SgK; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771443433; x=1802979433;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8Eg0esLDvl08ASZMfbpa7QGvDQCoC4ZgdplNas4bhqA=;
  b=loIU6SgK3kC1sfP0yfF6aiIgnnsIZpGzAdoZnplvpOmnKgenxojlX2Cv
   As61XCWp1Tzfg/uGYOVBjlEfdSZd2AM6p+syf4Fr0nuQS4V2vJZZ7Ti/L
   2sRRIDGuHsfmc4I2Mbx+vHi4ybaHmvApB7Sf2FaO1++JUGgLiN125JJJs
   UiTPBJs0T6UTftIo9CMyXKGhHRMCelTdTeYamAQQP/rnTptXYrgA6b4fY
   5GUdE9tX6CPkkyJ0YM2pOwQeP/H0iTPZ523lsUgk+uRte7PIGXww70Q7O
   QIq3svUxa9dQDJN9MdK7mzVXaQiapwE3tHDLbQd/1GP16Qk5KqaMbVs0W
   Q==;
X-CSE-ConnectionGUID: QHXzNftkQBejeSBXCNaXHA==
X-CSE-MsgGUID: w5n1vH6YSiGuWDHShvh10w==
X-IronPort-AV: E=McAfee;i="6800,10657,11705"; a="75137464"
X-IronPort-AV: E=Sophos;i="6.21,298,1763452800"; 
   d="scan'208";a="75137464"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 11:37:12 -0800
X-CSE-ConnectionGUID: LjSx/38pSwaVUnZoUqN95Q==
X-CSE-MsgGUID: fmTapN54Qqa/mrQJRVKu6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,298,1763452800"; 
   d="scan'208";a="218429234"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 11:37:11 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 18 Feb 2026 11:37:11 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 18 Feb 2026 11:37:11 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.13)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 18 Feb 2026 11:37:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VObnUgYQbX7Dw9S0ylYr22oAft5dUuhyBYbo851CTWddp0GD0Hw4O8gD5WfzRjzVJ9joy/EKA/zhgjW4IfPX2DtaA4H8I9w8hy6Ekw32m9XSvCRASXh73CaIDn8tlNhva8tkvLXTAGyLzyETzveElW8pd9uFYsEJGPhx125ah37K9zJowJozFYqZ/pGrzRRvlpiciOgSzCfjiPK1sw48WjDcFFxsXK2DVelQ8QB157Ezhzo0lXQF+p6Bfm8Yp+AiXzplw2ijzOc04QjbiV0S3vaPeTZTwNs7pmdRSijhHOl5fKcYyH9GTt2yIGr/HRn8sozGqx3Jmdd5G9M9MZMhNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Eg0esLDvl08ASZMfbpa7QGvDQCoC4ZgdplNas4bhqA=;
 b=YhsMSomK35TJ8cyPiRZJjIM+c+uHabi7+TXL3ndeCFuqz6UVe6vbNb6EPgEQUkwPfZ8inlz/fSZd4+dIPr3gLswbqRqS5P3onMOyiBw2Rp9oDnDLjdVwWKYktxCJzuoYOnzo5QKtwJnPwQLfXeVuG0OrKxvE9XQyA99wLXF4qbtnmeGhE5yslvQnCMXOsezr9B2p1zSJeGOQYsbBFvoEuRtkTCB67T7e8jFZrq7yyIPEHmoJ1xdQGZj8GchQ3HIKAwkO3fjovTApLOAP71Y8Sz2qjjaBrMvWBbwVDBAj5fu197giFzyia9bSfJK8SSV+R202cklGJ0nlUjjdIl7urQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB6350.namprd11.prod.outlook.com (2603:10b6:8:cd::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.14; Wed, 18 Feb 2026 19:37:08 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9632.010; Wed, 18 Feb 2026
 19:37:08 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "sagis@google.com" <sagis@google.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"Annapurve, Vishal" <vannapurve@google.com>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [RFC PATCH v5 05/45] KVM: TDX: Drop
 kvm_x86_ops.link_external_spt(), use .set_external_spte() for all
Thread-Topic: [RFC PATCH v5 05/45] KVM: TDX: Drop
 kvm_x86_ops.link_external_spt(), use .set_external_spte() for all
Thread-Index: AQHckLzPtDfQFZTNWUquSq6vUJ5iBLVwy46AgACjvoCAF4sogA==
Date: Wed, 18 Feb 2026 19:37:07 +0000
Message-ID: <75fc3f45e24309abef6dae31809012440de6d4ee.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-6-seanjc@google.com>
	 <aYHLlTPeo2fzh02y@yzhao56-desk.sh.intel.com> <aYJU8Som706YkIEO@google.com>
In-Reply-To: <aYJU8Som706YkIEO@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB6350:EE_
x-ms-office365-filtering-correlation-id: fd67d3ea-b07d-4cbe-8c75-08de6f251a5d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?VjcvY3FEWVBQRmFkT2IzNitDeFB0bE5nTm9mSU9tdXhRWUE3T1hsTTJvcHZH?=
 =?utf-8?B?SjFrUnpBdVlYa3phdFo5b2xiVDRJamx3bFdIb0RSa2tYTVRIL1hJY1RMcTAw?=
 =?utf-8?B?cUx0aXB2VVNKTGU0dXE1QTRFNk0xVmhFeVBrdFdSTHZpVUhWSnBROEIrMDBJ?=
 =?utf-8?B?YVJvRVg3YklWZG9tOTdDK1lkYktUMG90Qzk4T3RSL1diRWd5OERHQmpzMlB4?=
 =?utf-8?B?TnNXbUpiQXZja2NvT2I0dUJqa200QmVnZXlGM0JaaDBHOFRXSzdZakc3a2NE?=
 =?utf-8?B?ZEdkMVVrOXBneVNqcDQwbjVaZEJYbEVLak9udGNIMGpHN1YzbkhHa2dFWnVJ?=
 =?utf-8?B?RlJLenVXdlZRbVk5R0xJdVovaW83TnFEL3ZhY3JoNW9xZTUrTjZ0SFJaSUNM?=
 =?utf-8?B?VEpKZ3F4T0pHYkFGYlArMjlQMHRJd21PWWJtT0Uxc25zemhaaDNiaGtwTXR5?=
 =?utf-8?B?bUh5V3lyZEhTc00yN0hXcGpNUmgxQjNlMjdJNjF3U3FpcUNCc0xHdGt0NUNI?=
 =?utf-8?B?TFBWbHdQdTNSaWpFVG52bmR1bW1rcjdOQjRoTUlLZy9kR1VtVVR0VE8vOXMw?=
 =?utf-8?B?NGR4aFJqMTB1M2JObjRRUHlTWWpZcHFxT3dLTkExVEUxeTJSbVdpZkIyZEFw?=
 =?utf-8?B?STZFUFFvT04rbHBPSW5FZ0hOUFJLR2ptMDNpeEZEbDRibmpHTnQwczFaSktK?=
 =?utf-8?B?dy9UdFk3S2tqcm5SWUV6dEl0MTNMYlVhYmtJRFEvRjM0Ri8vUEovYUlJQnNB?=
 =?utf-8?B?Y0lyL1FId1BjeG1VQWxhVUtVQU1HVllUbmc1ZEJ5eTRwYkNPSyt2MGxZdDZw?=
 =?utf-8?B?M0JhSUEvRWk4L2FZaXF5QWU1NnhDZG9vL3ZWTFR3SnRuNXFsaWFmVnVveWNk?=
 =?utf-8?B?aW1OZTR3ekxEck9SRnBGckZnUWludVU2R0c5Sjd2c3VaRllrOWdPMC96YjR4?=
 =?utf-8?B?N1c2OFlwblZlWGY1Rm5yOWYrQmE2OFI1cm5LdDV2UXRka0lzeEI5VGhNMTl0?=
 =?utf-8?B?c3VKVkwvellyMWxXVlJYaG9xbEorVy9PcGhqNHJkUkhiZ3R5QjQxRExPeWNs?=
 =?utf-8?B?TFVWL0U5WWdsSkQ0NVZrbEJrRG1SYWdyNEJaeHZhVjNBSjhiakxZSGNSZ2Ev?=
 =?utf-8?B?bVhUb2ZVemtvQmRHRnZsQVVtayswV2pKQndTbjYrY2Q3dnluc0taV2k1STBB?=
 =?utf-8?B?SWk3WXR2NFQ1WVlEMDV5UDRFOW5TbW9ubkxJSlZmL2k2MlZkdE9NMHZxWHBZ?=
 =?utf-8?B?bldhQ05ocy9kUW9Mck9CSW5NUGdHU2lrVW9OM1RWbk0wdjVLdHd4WU1WdS9U?=
 =?utf-8?B?UVhNR2VTclQzMWdwZ3NyODJIaXlacFdzdWljcFZTcGhuZjJ1bzF4aHdNUXRo?=
 =?utf-8?B?MGJqZDVQM2hYaWRGUXNhazdiTitZcFJCbGUyVyt6cUhoWWN2WWk1elFxZmxj?=
 =?utf-8?B?eFlaTTNOekl0eDJLWWhOQ3RUZWNHU1NLYXRLMGMyR3FlRDRrVHN3YloycExV?=
 =?utf-8?B?QTd1V3F4VzNiMEtEWHRuQWlzWW4vRXplUFNIdDNIbWozQU9sbjVCK245aFZC?=
 =?utf-8?B?OVBzZFhXM1MzRGdSNE5kdC9PSlV2RjVxT2VDS1NRdDgzeWo5OGF2ejdmUlZF?=
 =?utf-8?B?VDUvbmllTHRHeERaRDlyQzc1VDdYanJxSTI3eXJXRFlMNzZhVVpoQmFINUM2?=
 =?utf-8?B?ZWJSWmtyMEF1cTZ0ak52MVJkWnlHL3AxK042ZnpyWDlGaUhzVnl3Zk43ZVV6?=
 =?utf-8?B?cUU4SittQXg1c1FmVUdMSHRqRjdNVENWYnppdTVUVlFsVlVkdW1qVVVaaUJs?=
 =?utf-8?B?dGlxbWRxNlpSLzdzc1VYdlpRMFNHSW9UQVRQWC9vZ1hHeVR3SXM4UFZTRGZM?=
 =?utf-8?B?OEQxVWZueHRuRGNiNlgxNCtxT2tkMk5YRzc4dWd2YWNhTUNqZm9DQ0UyS0lH?=
 =?utf-8?B?V2Y3MHA4L1RrYVFVRGExam5reitOK29wNjUvMDBmL1ZuYlltUVFtQ2V1b0tI?=
 =?utf-8?B?N3dFVTdrSDJ1UWpnVUlXcSthdlhFUmFXTjdhdW11bkpyekFsVkJLRjJSMDhB?=
 =?utf-8?B?clhYdTJVNE8wZVFuWWY3U01OeWNJdGthbDkvT09WdkNZcGdheC9temNLVUNj?=
 =?utf-8?B?emVzN2J4ZmVMaWdyTXIrVndxRVRKaDVia3ZFbC9WRjZ4Q1FIUTIyYitVV0lJ?=
 =?utf-8?Q?n2nEj/i5iNpg3UapIHvN47M=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TmlmZEQ4MkNGRFNsM2tmMXlEbzN5WE5hT3N1NitmemFpSTRTb3VVZEJYV1Bl?=
 =?utf-8?B?VUlIMmM4L1RITEkyUFNDZXlrRVE5em9Ea3FyeVE2L2RISzBnck14SnRVenJw?=
 =?utf-8?B?MEVoRk94MGpSR2ZtY2tzQVJBZmI4cURjd05TZUlhN2RZLzBTU1h1TjJrYlFD?=
 =?utf-8?B?ZWs4Q0I0SGJ3SHRncmxkamtTREFUM3M0R3ZKOHZsZ3craGhzTXlVRVFtbVV5?=
 =?utf-8?B?d2dTQjZ3SnF4VDNJMnZiTjMremh3NyswQnEzKzZaNkhQdG1YUThacnFMbEdv?=
 =?utf-8?B?RGtvNXdrdjNpdmQzYmx2YTR5dkxHOHkrL1lYNTNLaFl3c2Yyd0xXME9UN084?=
 =?utf-8?B?L2hiQThna01uZURteS9QaXZXNWE5QVh3bVo1WmNMSUQ5Zm1ydlZmNXFXeFVp?=
 =?utf-8?B?VjJiNlFHOFdFdXhuN1VuMlo0NnlLanhrOGRuRDcwSDYzdWpmN2Voa1o4d0Fn?=
 =?utf-8?B?Mm4wZThHaHdvT0t5dS9aUy9tNWJkUkh1YytMM3J0b21aZnJDQ0pIMWhnRmNK?=
 =?utf-8?B?c1FRTXFIRnpuQTlET09taFZvZXZCMk1pVnlwRS9LZ3B1ZnQ4ZE0xZXU3S1RH?=
 =?utf-8?B?R3FUdGtQWFJDVm11U1dvNlphcmJCbUUvMzl3YmxDeE9VdkhmTVFwNjkrSTV1?=
 =?utf-8?B?OHdWdnoxWDE3VVluV3V5RXpYUUg4Z3lURyt2SlZzY05yT1hjQklZckNydmsw?=
 =?utf-8?B?WmZ5aFNEZGpmL3FKSmhTaXMvUHUyZGJvVEU1Yk9lQXljVlVaeEN6SGdDNXRE?=
 =?utf-8?B?STdnWGJndm5TbWtYWGxHTERKOXpvVXdjR0RPMUt4TDM4dXJIeGpqVUFYclB3?=
 =?utf-8?B?cjN4NjJpMmtBNDZvUWVVWTFxSkZZd1Jib0Y0T1oyejNMeHJpaFdJRlN4emlz?=
 =?utf-8?B?L3pmZzdUaFpoRGZGR1luU1VPVnBiQ0UwNFhQUWJtenNpaEs1V0pDaWIyZElD?=
 =?utf-8?B?VVB2YUtqQzBJVUtEdWt3TjFvUVBHVi8rUkl4SVl6Q0JkL0FuZzBIVXZtS2FO?=
 =?utf-8?B?d1B6cVE2dzhYd1dIRXVMemNjL1ZEQUpiUnJhZW5aSmoyM3QvZWZ6S3BBRDYz?=
 =?utf-8?B?NVdPbW84enU4ZnlESmRZNWZIK3ZCTjdrUi9mNVRXeS9zOVdPQXpTekZldkRT?=
 =?utf-8?B?bGdrSWhYaFl0VmdFSGtnNlo5dnVLODY5NUp5d05RRzk2bUhOLzF5alFUV2cx?=
 =?utf-8?B?aWp1QTJqU0hnb01uOHNpemYzYXk4RUVKM1BGK1JZTnU3dHdZRGR2VjFsWlhq?=
 =?utf-8?B?VjBwdlRtUzJsNEREUGphT0ZHdTFiRlQveEdsbGx2eHBJSkFIY2ZtdkhXQjda?=
 =?utf-8?B?ZC9Ta3JqUnJHcVdGVis5d21qQXh6aU0xSGRHeUVVclowTjkrSUZJTDl0UHRL?=
 =?utf-8?B?MWRTOGtzd2tVM3VMRG85WDBWWngwbkFvekNXaVN6RDNlK0lEdHhuQ0E5V3Bo?=
 =?utf-8?B?OFptYkdKOXNDNzl3UVNFSlN4Tm55dDFHdExhQU1OODFKYkZORGdTRk9LL1pt?=
 =?utf-8?B?U2dkenVHQ3hJeWtrbmtSTzBuVyt2dHMxbkFuaWw5ZnJBK2FDcHBuZytJWGUz?=
 =?utf-8?B?bFJzbWxwZ2M5dGJWUFA3cVFiOTM4c3JFTXNkTzVFSkFHTFBGa2s1dUU5V3F5?=
 =?utf-8?B?NXR2R0pnekprNTByeW5POUZZaDgvM3pUZi8ydFFFV055bDZTRTFuc1pyeFVL?=
 =?utf-8?B?RzBRandLZkdhU0d2NHdVOEhHSXFhRkpsQ0RDbFFIWUkvR1FURFFyeXEzMkYz?=
 =?utf-8?B?WmFpdEt2eXpRbFdTU1hxaXdFUzZFTEtaRkdyQnJtSTFEKzhYSitGTjhtbEh0?=
 =?utf-8?B?QmZkQWRuYmJBQlpwRzVGVnFzeXR6ZWNLVytZL2dJZ2gzU2M5NEpXeFJaY2I3?=
 =?utf-8?B?c2lDblA2MGtLMGIrbUVFYTVRZWFVbFlHYVRSYkhCclUwNURMblZaMndoNUlW?=
 =?utf-8?B?WkFwbGhqWUdlMVdGdjl6N0s0MzMxd1EvYVViM0JNRFMydFg5UlRvUFlkNjJD?=
 =?utf-8?B?OUdVeWI2UkFVc3lUWW5DZnZmSkx3aGh4My9iQjY1bFNkVVZTNHJ0MmlmMmRF?=
 =?utf-8?B?eXJ6cC9NdTBtY2t0L0FsZ1VTN0JmR1ZNamRYMDhSVWltcC8xTkIvRlRnQitx?=
 =?utf-8?B?alFVaERZdlJTeEZ0cEowbkw5REJ6Ny95ekFYVURsUHNnUUJneUlRMHRZcmt5?=
 =?utf-8?B?Skh4VDRiNDdZY1FrcjVBeXZMcXltbmNSem5Rb0puTVUwckJSSnJLYSsrT0ta?=
 =?utf-8?B?dlZaZHMweWQybk9EKzEwVThkMnNncnpQaUxhUlZjNEFRc0FUeGlHWTh2ZUZt?=
 =?utf-8?B?aGVmY2U3cVBtUEFRSHJacFpQWGJOcGRIQm1jdktVQlpSZU9GQWdoNkIwUnlq?=
 =?utf-8?Q?SYCRIERqju2YeayI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ED13F3230423884CB2CC93F590BD654E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd67d3ea-b07d-4cbe-8c75-08de6f251a5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2026 19:37:07.9934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aosy5JDZezC24x53eb9Id4i15saiJRntDTZVNusvBD3FNxXlf77K3iWl+/yPJvSiVv3hN19jqPqI06VDcUW/IOgtVuBw+2d+AIHVzbuzQQM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6350
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71267-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.996];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 189261591CA
X-Rspamd-Action: no action

T24gVHVlLCAyMDI2LTAyLTAzIGF0IDIwOjA1ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEFuZCBtaXJyb3Jfc3B0ZSAtLT4gbmV3X3NwdGU/DQo+IA0KPiBIbW0sIHlhLCBJ
IG1hZGUgdGhhdCBjaGFuZ2UgbGF0ZXIsIGJ1dCBpdCBjYW4gcHJvYmFibHkgYmUgc2hpZnRlZCBo
ZXJlLg0KDQpTb3JyeSBmb3IgdGhlIGxhdGUgY29tbWVudCBvbiB0aGUgdGlueSBkZXRhaWwsIGJ1
dCB0aGluZ3Mgc2VlbWVkIHRvIGhhdmUgY2FsbWVkDQpkb3duIGVub3VnaCB0byBhdHRlbXB0IHRv
IG1lcmdlIHRoZXNlIGRpc2N1c3Npb25zIGludG8gdGhlIHNuYXJsLg0KDQpJdCBkb2Vzbid0IHF1
aXRlIGZpdCBpbiB0aGlzIHBhdGNowqBiZWNhdXNlIHRoZSBzZXRfZXh0ZXJuYWxfc3B0ZSgpIG9w
IGFsc28gdXNlcw0KdGhlIG1pcnJvcl9wdGUgbmFtZS4gU28gdGhlbiB5b3UgbmVlZCB0byBlaXRo
ZXIgZXhwYW5kIHRoZSBzY29wZSBvZiB0aGUgcGF0Y2ggdG8NCmNoYW5nZSAibWlycm9yIiB0byAi
bmV3IiBhY3Jvc3MgdGhlIGNhbGxjaGFpbiwgb3IgY3JlYXRpbmcgYSBzbWFsbCBtaXNtYXRjaA0K
YmV0d2VlbiB0ZHhfc2VwdF9zZXRfcHJpdmF0ZV9zcHRlKCkgYW5kIHRkeF9zZXB0X2xpbmtfcHJp
dmF0ZV9zcHQoKS4NCg0KVGhlIHBhdGNoIHdoZXJlIGl0IGhhcHBlbnMgaW4gdGhpcyBzZXJpZXMg
bmVlZHMgdG8gYWRkIHRoZSBvbGRfcHRlLCBmb3JjaW5nDQptaXJyb3Jfc3B0ZSB0byBncm93IHNv
bWUgbmV3IG5vbWVuY2xhdHVyZS4gU28gb24gYmFsYW5jZSBJIHRoaW5rIGl0IGZpdHMgYmV0dGVy
DQp0aGVyZSwgYW5kIHdlIHNob3VsZCBsZWF2ZSBpdCBhbG9uZSBoZXJlLiBXZSBjYW4gdXBkYXRl
IGl0IGluDQp0ZHhfc2VwdF9saW5rX3ByaXZhdGVfc3B0KCkgaW4gIktWTTogeDg2L21tdTogUGx1
bWIgdGhlIG9sZF9zcHRlIGludG8NCmt2bV94ODZfb3BzLnNldF9leHRlcm5hbF9zcHRlKCkiLg0K
DQo=

