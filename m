Return-Path: <kvm+bounces-73330-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0FuLJVPzrmnZKgIAu9opvQ
	(envelope-from <kvm+bounces-73330-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 17:20:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 359DD23C9DB
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 17:20:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 43552300AB14
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 16:20:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B33233E7174;
	Mon,  9 Mar 2026 16:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e8KuHjyl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3573B8BA2;
	Mon,  9 Mar 2026 16:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773073223; cv=fail; b=SZQ+iYHzFCNAVG1InKvNabluTwyFdqu/MRByZFMVkplLQb+xiMkRxb6pclBtNnMM5DiUp+Dj88Z5586oPIKzGfuwXtUmY5J1je3SZJdD8QGPMux6sr+TGd4PB2x/I0g8IGmO5WMsROSMlWbjjjqWHcux19avawxp+soZXDOzUCY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773073223; c=relaxed/simple;
	bh=Jbjbqt2cHK7Uw0rqgVCItrGse4FsHuIuD3KG7yDs2oE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cz4kGsCJ7SwsBr0Lfdah2Xs7Q0GqwQUo14ccv9sBLEMgIeMor1sePIDvMFph36BYxKtSNGbt4P5SwQ/yEPOrcCtoKcl4vleev9XkWkp5JwUnjk0Yx1A+lmjtotwzusoZs36bYJjMqLxuyKzVKSikakhiAqLNyjGsAX9zPCDe64I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e8KuHjyl; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773073221; x=1804609221;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Jbjbqt2cHK7Uw0rqgVCItrGse4FsHuIuD3KG7yDs2oE=;
  b=e8KuHjylKS1RL7ojkTFEoDgu9PkJj674dFGgQPqk9UDXs9LvvVAUo/PZ
   ZtVruxQNm5L1hRbHoyeGXzSHwxPrMG4oLtqNTNeCEF4eaiEMTQXQCSWdh
   umZ6+xl5ilzMX1RgOaz7ormgokXImDqSTjNKGXTsNAYQddBoWkn7aWrHP
   hgKNaq1pQqrxTH1sx8PpzrBiB/sDo8qOGlc9GZDafv3GSYgDDeYKRNhuE
   ANG8UVp0WRBmzkpX7Uz5XaTqG4famQL7CJojGncbWBemxg00VuylBC0uj
   iL8BhQcZRxZUzSdzPwqxyo3fIUKrOzp4at/e3I+wgz37iC+3auHG6XzJL
   A==;
X-CSE-ConnectionGUID: IqDfW6G1SNGyzpdH6KBzqw==
X-CSE-MsgGUID: pFq07WDpRG6N4IEhVBTKew==
X-IronPort-AV: E=McAfee;i="6800,10657,11723"; a="84737764"
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="84737764"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 09:20:20 -0700
X-CSE-ConnectionGUID: QV6iIHhcT4upUEcDA6jhVg==
X-CSE-MsgGUID: JCHiI8NiQIGPP5ZGquHTZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="242825388"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 09:20:20 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 9 Mar 2026 09:20:19 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 9 Mar 2026 09:20:19 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.26) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 9 Mar 2026 09:20:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YdO2w42frZvjic/GdbMk/7Sr+97KNgmPZxffrbH80mJIGpesqAM3GPlUBEGTpTOG4XISPfNvEZfN/SOSZhgBOXK88wAk98KoJO6zKMcMpmppLVtNkjGDsGuD+jjqugNE/kFIhk+VyM4KlLLDHhve1HpWC0gOU5BLMynlLVUplpM2LkQ8muxIWmC6awoeZKm80DMM1SmSJyIfcO4rRmCePAZdoz9aelzyJKaX7vYRKKOu8n2kXppM26RUj3xoX60X4zn5U5oJUn6EEK6xb0127Yhze6DnO5bmIDZpYVLuaXZzG2iQqoPuq35A0QYlsn+1GaKEAIqRd8VeKh1kBl18JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jbjbqt2cHK7Uw0rqgVCItrGse4FsHuIuD3KG7yDs2oE=;
 b=iVNATDeme/b1H+DmxugfjahevZSzuC9UZi6SucJ5nJJh81UkB+PyHz6c2K/ssCA+WPFUcQlLmJWyMpbKXmv7dkoehYmMmHb9EiFfqRjHlGeuO9DheVk0XJ0vinIaitnIYU3oHywydkVyBgjHmthvAX+iNRLy1FNkUdSeTeYY+k00wHd+b36+iA8jyZxIJvoj5Pg9hjPMc7le8mDGzSrm66ZLrJ7iDuUayZUO6ZP6+T98R6PBzJkYoKJtQ8XILtnTSl5XO0pzm44DFNLv3a9lbKVyn2W1INuau3UrzTwfVi4kEClsaX51RL+L141L2txySO5M9iuy8NG/NPrVuytAFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BL1PR11MB5956.namprd11.prod.outlook.com (2603:10b6:208:387::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.8; Mon, 9 Mar
 2026 16:20:14 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9678.017; Mon, 9 Mar 2026
 16:20:14 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"bp@alien8.de" <bp@alien8.de>, "kas@kernel.org" <kas@kernel.org>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"Huang, Kai" <kai.huang@intel.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "x86@kernel.org" <x86@kernel.org>, "Gao, Chao"
	<chao.gao@intel.com>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"sagis@google.com" <sagis@google.com>, "Verma, Vishal L"
	<vishal.l.verma@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>
Subject: Re: [PATCH 1/4] x86/tdx: Move all TDX error defines into
 <asm/shared/tdx_errno.h>
Thread-Topic: [PATCH 1/4] x86/tdx: Move all TDX error defines into
 <asm/shared/tdx_errno.h>
Thread-Index: AQHcrc5SxJajFNsz/U6fSKZ1hAHrqLWlUFaAgAEVtIA=
Date: Mon, 9 Mar 2026 16:20:14 +0000
Message-ID: <68404c649ffd4dcb4b52bbdb8cf1ee15d8030c0e.camel@intel.com>
References: <20260307010358.819645-1-rick.p.edgecombe@intel.com>
	 <20260307010358.819645-2-rick.p.edgecombe@intel.com>
	 <19ae1ea7f3dc62ac95f5283f2f101066e52450f4.camel@intel.com>
In-Reply-To: <19ae1ea7f3dc62ac95f5283f2f101066e52450f4.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BL1PR11MB5956:EE_
x-ms-office365-filtering-correlation-id: 50158f59-2b90-4465-3058-08de7df7beac
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020|38070700021;
x-microsoft-antispam-message-info: uhA9dhkd7xGugjZxlDETsuztMkCiQCVzndGO6j2fmq7dJMruIO7DDJ5ADXEiu07FPZ/wbzDUd/kVoxv3dMA/s8jfX/TMJwG86FLY38JL2GeOvAFLPv94XX/bWH8HH8706ZWG93YhVkvT5wnTIKWjW32DuFNvjFP6j1gBt4D8jrBz9g1E/jE6H5D7vXrPSG3OQ3ERyYitBQWXwHLTcLOYZYJXFbMCNohCB+OKG1qwzS6qJlKGGbYB1rr5NPtu+Esn2a5xSq56N9nfVkE95+h7Ovbeik6o8CDTYeCF08tVwzSBSRqJ7fwg7cMX+fuOiHyPQXwMYQ56JOr8VwKP01PL6Sh3tU/Lnvl5/6zsiQoVsMOolB9DFp6GvoywccW0eU8+VaiiC+rr3/GGrKllagi/mBlw01Tpp1dZqG3TtUjSx6tq9qgnZgv3JdaMsp9NtCBHpOeEVHG41QBXwsfkki1e7TGaQvtr/cYxr4azSOxDdTBgaH5AtFirr6CNA3FhMK4auF+dmu4uB2HPsatGE1rEAZladX84LJCWaHBCT9TagseCah5dD7t++GzP/JlLJCmfDyaS+4ndoztRRxl02mQYkVoCyomLI7zwF5N1xh/KyZh33svNg7rGBNPm4qohTjmQ6qxDvnIh1mFPZrajsR9PHzZ8LNMXK7MGJ1lL1dzP7NHTEzPDls6aDtgqu9zxelkzNqSmoSlP/OyvhgEo4MoHD0NYseWrlD9YJbueIKL3EdPnom6GqFDQ84Eq/UKI0FNDEELnbEpdKfUlBRcW6wTWJP7zYNCr0hcOo3fNEPlmGC3zppF+YxivE48VPMs/WYj4ij02v1tMBSB5WKiFflOaCg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?czBZWWwyK01lMUJPcXFCZ21EWjFzUisrQ3lIMWtYTHlWTEhTTENpT2Erejcx?=
 =?utf-8?B?dU9LUURNSlQwc2JLbk9QbVdlc0hhNE9UalExWHU1SDIyWm9ya29jdW45WXMr?=
 =?utf-8?B?VG9YREhGRzN5WUt0REpSTW5hdWlyMGQwcTRMQVVoN0M0VXpmYU9vS1NxNHUw?=
 =?utf-8?B?OXZpZGFLMWQ2RW1HK1JNcks4SnBFd2NuWFlnMktpNFhLVkwra3BRdytLeDc1?=
 =?utf-8?B?Y1cxZ1pWL3MzM3IrMFhKa1FWSUI4QXZzQ1NzZlhVRWdxVHdMQlFEQ1NPVU0x?=
 =?utf-8?B?S0E0b2IyeEpPQjNUNHg5VUx6dThkYlF2N2QyTzdUZGJ6bHBiaXRudnBkYUZK?=
 =?utf-8?B?MmRrN01oMUZaaTUzVWlibC9MMnRSejZFZ1QxZXZsQ1hJVVdtREFYVmpkUFBi?=
 =?utf-8?B?MEV0QlF4Y25rNkZQUTlUNXVYeXdZSTN6bkdzTW9XcGtmMzJkMEZ5cDhsb055?=
 =?utf-8?B?cG1ocm9zbVlXYnIrUE96dHNWV0UxLzNyRmp0ZHJ2YWMxcEx6aTBVSnVHWG9K?=
 =?utf-8?B?TzFuZWxON2NDZUN0QTRUSFdKNE1mb2wxbk16QkY0TVA1aUlXMHcvMHdpeFVa?=
 =?utf-8?B?QXBpVTJHMm5ma0h0MjB0Yy9BejdmdDJtY2RMSUowWEJaWWpvOExhcklxcVAy?=
 =?utf-8?B?aGZQMncycFJOMnRGaTNta2gzRjRoNmVVSHFiU0tNY1puU3FYSGdyb05mYlBH?=
 =?utf-8?B?SkNONmcyc1Y0V1krMXFBYXFsY05lL0h3dVlrWU5yUEowbVpDZ3NtM0lOVmFq?=
 =?utf-8?B?bXBvU2wxZG1BSnF3dkgvK2FKczFiYU9tbDBQcmRHaXpBTVhVVEtPR0NSdjJ1?=
 =?utf-8?B?S0NQeVV0TlUwb05kSTFWOXZtcFJ4SldvSzZWV2NGc3hYZURGMVNFZFVPcUF1?=
 =?utf-8?B?eU1xZUhYVkFYL3ljRFRhN1pXRjN6dVdPNks3RUZiNUJ2OEVXNmRaNk51S0Fy?=
 =?utf-8?B?TE02cCthbDBSa3RjRG5xRDBwREt5eFphOEZwOElHdDArZVZwMVdTbFpSZDNZ?=
 =?utf-8?B?Z28wczJoaUdpK0U3TEQ2OW9nRFc4eGxiRnI4ajBHdDBLdU85ODBxMzVuT2cr?=
 =?utf-8?B?MlZwck9UV1QvdnlBemxoSFZodjk2bjNiZUZ2NHl2alBVbjJwWmVsU1FhdnFH?=
 =?utf-8?B?c25sdkhBNGs3SGZtRldZeXZ4Vk1WQU8vbi9jN2VvbjB0TkhZVTdlMlVOKzFz?=
 =?utf-8?B?amhEcHg5RDdUNk1DNEphMVF2U1RYMTgxS1lvK1hyZHMrMnl3dXBwdkhGSHEv?=
 =?utf-8?B?ejI5K1RjNGVzK29sS25vZWFjMVhPaE1SOWxjUXM3M1hEUEpoTXdYWWdNY0Nx?=
 =?utf-8?B?bVh3N2EwQjRrciswTCtrK0Y3UjBEYjNYLzVLK21kTXZiYituUUljNlpraTB3?=
 =?utf-8?B?b1hzMkZkOThxbENKakN3M1RjcFdwNjRLVCtid0hyWDE3SCttOFVYVXpoVlhs?=
 =?utf-8?B?TkNKeVEzWEFCbnhnN0llSE5xV1VaNkdOZ2FWa3NmZGRkMWoxRlljNUw1dndh?=
 =?utf-8?B?YUVzekN4SmpOR3pXL1JUYmY2Sll3aFQ4NlYxSkMzMW5pdW80dUVIcURTMVBt?=
 =?utf-8?B?OEVEaFQ1ZmQwMk0wZ2hVY0VHUUNEeE45ZElQenRjU3BEMW43QlBBTTA0bS9M?=
 =?utf-8?B?MVY1eCtURmFLa243T0dITGhUOU5kYW9wdXUyT0lHKzlIUUNCUTFFcWpmUnMz?=
 =?utf-8?B?ajR4aHk2TktIaFlxTTdOZ1hxbkFic0ViWENRdUlqNHR6QjVPYkI5MEZTVHBN?=
 =?utf-8?B?VmdpRmRJOEkrSjZKWVo3TEVKRXpCYTFnU1psR1kwenlVc1I2eklBN3o1SFow?=
 =?utf-8?B?b0VwbEpDZ3lVVlFiZW1CVzI5OFpMNU55SktlTHo0Q01ISXdIb1E2bC9OSmg5?=
 =?utf-8?B?dlVnWHdHMWE1UEYrbk5iQzVJbmtuTVpxZyt1ZDVuVU1RMk1ubzkybmlTek1B?=
 =?utf-8?B?NVRjOTZIM3pMWVZmQWZkVVdnL01scWlQdnFQbmQySUhjZjVGSTRjOVhxVmph?=
 =?utf-8?B?Q29ZeGI4bVd4WUZqUTRrcnZaYlFENi9UbSttMy8vTXpJWXJyTWE4QS9rdXVq?=
 =?utf-8?B?SzhaZWpINTBBeWxaVjFrTlVNeVB4Qno4cDZTZDV5NklqdlpJUyt1M21GMnRo?=
 =?utf-8?B?TVBobEZ1YnJYcmFubVF5UG05OHNNRDdZVnNCMWJicWo0aC9uYmRncGMzNzVP?=
 =?utf-8?B?ZHFWZEUwU1dpaVAwWkl1OHRId3NWY3BFNTE2T2NMNGhTYnVaUTZ6dGtsM2NN?=
 =?utf-8?B?WFMvZ05OcTI5cWNDUXJOSU90U2FuRUtaRDVtc09WSlMybzloUzh0SzFOeGp5?=
 =?utf-8?B?UFR4eEJzYnRkU0ZnZ2ZUT0dWT3BXR2IwcFNvOW8xNkoxTmdoOWF2WGVaWC9N?=
 =?utf-8?Q?sqCZyvUsMrd4P5Zk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BB4891D8CB083547B576068B1A3D2F9A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: VyUtaYMosTwU7aLMJK/19wUDy/WcnJOv/z3c1AaF4S+uPEILhuq+lI/pzT0wRtQ5uwh/hRflbKPjJNVLmOC002j2HQ2WyrVITkeZ8JAQ1wp97qRikUiKfJYYcgMbYaDhKTHBA7SvLnYDdUw82q8ARdolGWEvNmRn5sbygxwBQEhMF/3X3q8g3UV1AnH5NKnGIGnz+NpnztSDQGDZ2DXkiVnLr4ZEzOJBhAuFqo8vV85Dms1m8wKxdqAJu34dHb1BN4YtrFRMiW25efXpgQcwZNPczF6SXy544+qyudgJQGvqHwmr0KRSAHP9DNI3q19EYza1/XZeZD5ouGloeJyN7Q==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50158f59-2b90-4465-3058-08de7df7beac
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2026 16:20:14.2280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /HrerZihZG7+WvW37wWJzuDn1q809bxABnKY4WlVD1Rx3mG5/vKCh3tkxOL4fXSCrRQMXPec55JdnBE8vXNZoD6M9D+tp3OzCIXQ+xf+qzM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5956
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 359DD23C9DB
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73330-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[19];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

T24gU3VuLCAyMDI2LTAzLTA4IGF0IDIzOjQ3ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBT
ZWVtcyB0aGlzIHBhdGNoIHdhcyBmcm9tIHlvdXIgRFBBTVQgdjQuDQo+IA0KPiBJIG1hZGUgY291
cGxlIG9mIHNtYWxsIGNvbW1lbnRzIHRvIHRoYXQ6DQo+IA0KPiBodHRwczovL2xvcmUua2VybmVs
Lm9yZy9rdm0vNjk2OGRjYjQ0NmZiODU3YjNmMjU0MDMwZTQ4N2Q4ODliNDY0ZDdjZS5jYW1lbEBp
bnRlbC5jb20vDQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS9hZjdjOGYzZWM4NjY4ODcw
OWNjZTU1MGEyZmMxNzExMGUzZmQxMmI3LmNhbWVsQGludGVsLmNvbS8NCj4gDQo+IC4uIGFuZCBz
ZWVtcyB5b3UgYWdyZWVkIHRvIGFkZHJlc3MgdGhlbS4NCg0KT29wcy4gWWVhLCBJIGluY29ycG9y
YXRlZCB0aG9zZSBjaGFuZ2VzIERQQU1UIGJyYW5jaC4gQnV0IGJldHdlZW4NClZpc2hhbCBhbmQg
SSwgaXQgZGlkbid0IG1ha2UgaXQgb3ZlciBoZXJlLiBJJ2xsIHB1bGwgdGhhdCBvbmUgaW4gZm9y
DQpWMi4NCg0KPiANCj4gSWYgeW91IHBsYW4gdG8gYWRkcmVzcyBpbiB0aGUgbmV4dCB2ZXJzaW9u
LCBmcmVlIGZyZWUgdG8gYWRkOg0KPiANCj4gUmV2aWV3ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1
YW5nQGludGVsLmNvbT4NCg0KVGhhbmtzLg0K

