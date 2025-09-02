Return-Path: <kvm+bounces-56612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 269E6B40B4E
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 18:57:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E61074E3102
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 16:57:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28174342C8E;
	Tue,  2 Sep 2025 16:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fefFOIMv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6662C340D8A;
	Tue,  2 Sep 2025 16:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756832220; cv=fail; b=tWlu7/1TXgtB5JaDZMccAkdobf67emAvyibUEs7LKJgXJZtb9IzHSVOVLMK6TxHLIfT4tHipcaTLf22VEKJpvHgjQpfiZ1M3ynUzphxgtcj3CsPGkHBMuXHxxP3qyssY6n05LU9+x3BlCuJAbLnPrJ4hHlELSZEWvmB/sOrDUoQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756832220; c=relaxed/simple;
	bh=24PmH/SnC263RIBOytrdATv7gd/chkh6fnRAC48W1LY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QRPztpbpwOOEx5Td7APCHXmW3Wul7atdR4VslschjCh2umpQ+pNIA3e9ayYRo0PaqfEsRk6rMFFRlvaELDlEZCRGZ/RtOOyvXRHvfDMc9OTuu1WkQoZXTiANfcqLmO4yxA2RqAhwUnig9NQFYqbgDHa8SX3oo48iavXFbWm+fyY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fefFOIMv; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756832218; x=1788368218;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=24PmH/SnC263RIBOytrdATv7gd/chkh6fnRAC48W1LY=;
  b=fefFOIMvZD82wKJdbRYmKfWYam/B+o3S3akmQQLUkq4SLeoGi3x6OIU/
   UuhENFIe768GtT571TFfWphGvh+4bvVSk9DCfSdK6Q6mTnH1YWXiDuPJE
   utTD2BiN5PXcPSeJRovLRNAkoM/mLI8ed9cNc2O4TmVe5Mj+w5zCM2Npb
   3pzuB0nuIBt2OEW3WYzwb5O0Kir1wfQfBlEcYqvL6Dey3ZXTYf4cmIW9E
   uiDLQ61rnWShv4GOPucEujgee3aYfuiNHUDXXl9g89TEkCr5GqkILrHbu
   RxedA5+ISw8SgDFklxKQLM+CeVFp0brE+ZxuES/tXDZ3dBFEhRBEhIMYh
   A==;
X-CSE-ConnectionGUID: xKuSxKXnRNCN+qpSlgb2zA==
X-CSE-MsgGUID: NJxXCEGcRoGoM5kJZVUH4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="76717397"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="76717397"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 09:56:57 -0700
X-CSE-ConnectionGUID: cMi9Y+maR/SK+8Ybz9f+QQ==
X-CSE-MsgGUID: rA4IZLt9R6mE9NtYoLM1yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="172165888"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 09:56:57 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 09:56:56 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 2 Sep 2025 09:56:56 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.40) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 09:56:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B583fNDz78gMpLAK9KT6g0TDxyUFLnDThm96PmCLKc/pOCbNBvjT9AUrYHYX68D6kqTQRyOEFx+T6CuaeBAdXy7A5Nw/WTuz3EO4ytTrtbyZUwXxMfoL3HrbyeqoT8r+LiFcZHq7ejtYjPnHs0LcF5FBTv5LnKzEJLhQ3giVWq+dLAreSU/UDgvlLfHLZy+rfBSDezZyAEwGVZFW47FfZQvPn4EsUt3XbcdTng7M5ywxLsnIIPgoOaT4yzDXCUmKnULIqEld+m4rrJsiz487K+cfcAzUeRdgjjMbchoNPE7UpLsV9B1ddV6mfQ1FxxMEW434QGRYrJ5Ggx7tqQmy+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=24PmH/SnC263RIBOytrdATv7gd/chkh6fnRAC48W1LY=;
 b=wa9SR6lpjCoGebIM1Zb7uKKs7y3sELUHYev2S/pckKqnMNC/MRIEejU52WzpPuFK1W82X5oewYKUUb11EnYQU+aoDwLfkDv9W1z5zmqwDA980j/jybRczJy7soan/QNIe3sTogipYl1BsCcOySrgCEJ0R9sv54gUQPWFLlMWljjd+JFHTjR6ndSS6mcJkaI/qZw4bo5LfPWBrdOrJ21mqooqJRwbK856DH4tl0SQrW4SFF7jweBs9DU0MdYI9puD9eB+OpLAuIzJm7aftfPs7cRWkFGnADgvnDZ+Sxm++VIBNUqSC2HPHcWcbrqbwQ6MT+FROeCYTswxnBc+QFEUiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by SJ0PR11MB5168.namprd11.prod.outlook.com (2603:10b6:a03:2dc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 16:56:53 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d%4]) with mapi id 15.20.9052.017; Tue, 2 Sep 2025
 16:56:51 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "seanjc@google.com" <seanjc@google.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "zhiquan1.li@intel.com"
	<zhiquan1.li@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>, "Miao,
 Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 02/23] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Thread-Topic: [RFC PATCH v2 02/23] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Thread-Index: AQHcB3+cjpXnNi+6okqfIQv/bzXmILR+LVYAgAADmoCAAhU2gA==
Date: Tue, 2 Sep 2025 16:56:50 +0000
Message-ID: <87fe45aae8d0812bd3aec956e407c3cc88234b34.camel@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
	 <20250807094149.4467-1-yan.y.zhao@intel.com>
	 <281ae89b-9fc3-4a9b-87f6-26d2a96cde49@linux.intel.com>
	 <aLVih+zi8gW5zrJY@yzhao56-desk.sh.intel.com>
In-Reply-To: <aLVih+zi8gW5zrJY@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|SJ0PR11MB5168:EE_
x-ms-office365-filtering-correlation-id: 9881bbaf-9958-45a1-6717-08ddea41b657
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dWpmL2xPdGRRRmxrWlVjSld2THYrWmNTWmVLdjhJMml0ZUhpOEp0MEF6ckZK?=
 =?utf-8?B?TExBdi9Ca1g0ZHJWYlljeTJ4cTY4SHBsYWQ1c1ROamMzSStWOE53K00xUWMy?=
 =?utf-8?B?RUo2ekQwMXVUdUxrdzVOVVozbmFqUnZPRGs1ZU1xU010SHEvV3o3R0Y0NFRt?=
 =?utf-8?B?YWVLZGU5WXhxWC9ERFhjcFh5RHg0aml5dk5ORnh0cy9QU2N1Kys3b21UczNF?=
 =?utf-8?B?VlFReE9QSWdiTHY2N05uNHAwL052M3lYZ25BdWxYYndzV3FscitlVW05RG1V?=
 =?utf-8?B?OFptOXFMaXFrT05jQnVXNTZuQndXQjJPWmFTcGFaR2VMeWRwbksrRUg3a0Q5?=
 =?utf-8?B?NG5nTkpnNkxqS0tsMW50M0pEclFIUmZ4VUh0bHlER1FQL01HdDM1bzRWS3Yy?=
 =?utf-8?B?TkpxZ1ZNYVNSeDY2SitrbUphZTlkL3d4ZkxWUmU1Ly9xZFM5TUVnUGIwaTZx?=
 =?utf-8?B?d1h0aXVDYXV6RUhLS21YM0ZFNnNiM1dBNTcydGxFYzAya21wbkJVaWt3Y01p?=
 =?utf-8?B?SGRqM0VOVExPUzhQRmdKbzhjMXdCTUNLWUs5V1FETUp3cXFKak4rT21vN2Ni?=
 =?utf-8?B?bS9VYXJoWUF3OUkxVVczSUZSQ0J0dDVTcXFVMjdFamprYlc4S0gyMzlpd0x0?=
 =?utf-8?B?eU1lYkZzVkFobGIycFluT21tY0JRRjdaMmEvMFd3ZmY0R2RPSmx3Y2FYZVdY?=
 =?utf-8?B?Z2IreldrdlNpS2RPZmNOV3J2VzlQMFYzck84RUMwaCtQekhiOUFxTVZRVzRX?=
 =?utf-8?B?SG9iSzA2V0U2T1NSd0xWYmFaWkExZ0FZUCtIQVBEWFhHaFdpTG9VMG1pMXhC?=
 =?utf-8?B?OG0yQnZWNVhmbjVVQXJqckhiQTkrMXR3UEUzYTVsSVNtTnltdWxwQUVjbXNF?=
 =?utf-8?B?Z2NmVlNWWVJGWjN4TWM2bXMxUVhoTUJGRDNCcURkeUpvTFdSaUh2VnM4bGtN?=
 =?utf-8?B?NEdOclFSK3R3d3pvZUhFQ2pjTFdSWnNrS0NNK2NBVzROZTR0K2Y0RHhiV0Fi?=
 =?utf-8?B?clduZWxMUTRDZm4xUVhicFgySDhyYURISDFpRUwwMUwyL0VJN3ZLdWtZeDRO?=
 =?utf-8?B?elU4S0l6d1FtZWF3OWcvc0hpczVPbW9UakVON3EzM1BqZXYyN2JLcyszNzg5?=
 =?utf-8?B?cmpLbmxJUUFYUmhSYnI2eWpZUkdWY0Y0M3BQVDdVN0FwblJabUZDY0RybG9k?=
 =?utf-8?B?c2orQUNzMmJpSW5QNkx3dlg4UjhoYnhXV1ZDbFV4T05JMVdhRWUyMUlwTDIy?=
 =?utf-8?B?QkNmNFhwRzVYYjRtVnlvcGQ2c1JERnZJZGJRMmV6S0R4WXlLM290V3dsQzhq?=
 =?utf-8?B?dDVISGR0VzRCMFphRmRXblpJWlluQzBEY1ltZFVET3p1Yi9RZEZ1R3g4NDdP?=
 =?utf-8?B?TWlrZEkvcVdMNys4SWRzN2l4YXpMV1FIZDJHV3BRMVd4MWNodkFNSEg5OUdk?=
 =?utf-8?B?Slc2WEZ2aFZ3amtERWtzM3gxczVRZFBQZUpEc3pCRXJndDdOc2xIS0VTcXVB?=
 =?utf-8?B?ZW8zQkIwNFg0azd4VzF2bml6MnJoVFhRVkZPOGtwcFJSUnMvcTBMcXBWOEtW?=
 =?utf-8?B?TUkzTW1kckFKQVU1bDFYeEFIKzZuYU1MVW1sS0ZWbG9FejNmd0lrb2srdnVJ?=
 =?utf-8?B?RHB1cFAvejBROEpzdDlReHJ3aG1Nc2M0MVRCSG5DWVlabFdPdlNtQll6dlU4?=
 =?utf-8?B?dXB0WFJwTjlLQzA5akxQUVVGWk5saEJvWlNKTisxOEFTaDF6ekNJTjlMeTVP?=
 =?utf-8?B?dTVWdUQ3WHBGeWxnMmtiby9JVndab0xieDFSTzQzcEV1VGpHNDRldWJvNjR4?=
 =?utf-8?B?eWc5WlRtT0JtSlQ5dVBPU0ZKVW5VMWRXczg5STRuekZPUENYNFFhTTBORE5J?=
 =?utf-8?B?b0ZHdnc4TkxzbUtmTXRrUkFkZTVLeGhPUWxoOVVhNmZHU0ZmQjFXaVhDYWh1?=
 =?utf-8?B?L2NUOUhWTVRndGhSRVpYcWFmSVhZUFJPcCt2djZMK0hpRkJyT25QKzlTaTZu?=
 =?utf-8?B?ZTUvTjdENHJBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VWhNM0szMUxaVnYyZEQ0aXZyRjdsSW9zWEhSVlN3QUUycVpiU3V5QU53T0Zx?=
 =?utf-8?B?NFBvNnhrVGZwc0ZsUUIxQUk4ZVF5RCtTNlp5L2Rhd09Jd3JWbUJZRXJGbTJM?=
 =?utf-8?B?a0J6SXZUL1lPZVRiTmJ5Mit4NWZvT2xQbEpCQ09kdnYyem85QXVNYjdTZFZk?=
 =?utf-8?B?dExkUlVuRCtLMFNhQUR2TWFvUzIyU3hoM3JBbnVVclFNbW5nRkNGZDFEcUk1?=
 =?utf-8?B?cERsSTVWTjZITjBsaWp4VVp6VWZzVzZZcHQ3RzJlQ0g3KzN2TURkMWtUYzlT?=
 =?utf-8?B?eWNvMlVJOEc4WG1Eb0hmT1RPSlFmdzBQcnhTeXJHN3htVkNVOE5DSU42d3kz?=
 =?utf-8?B?UUVMQW40V1loSCthNm9nVEFNMjdMWlZabDJMQklDaVB3ZUFkMnpiUktsQ09Z?=
 =?utf-8?B?dStXbmxpbm5ZRFpUZjU4U3hDY1hBYU9KYjlDaHJsRnYxMXlXb25XMGVhM1NY?=
 =?utf-8?B?dDQwSHMreDFXY2VvQWxmakswN1gxRTY0NVBNa0VJeTczQVFxc2E0QjZJVEtx?=
 =?utf-8?B?NFIrNmRhSVhBTThRTVNoVUFFZHk4bm5jcWNmTDVidW5MQ0FIR3RVRVdmemI0?=
 =?utf-8?B?c2JWUk9uaVdRelNqbngxeW4zTUx4SHFyY0UxOTM5OUs0Z0pxeVVoMm14Y3Z4?=
 =?utf-8?B?TlRCaEN2SmRIZnZUZWkva1Fkd1Y1WTVlRUlTaFBUcE1YcEI2eWx5a0N2WU9V?=
 =?utf-8?B?Y1hZZWhDeXFsR04wdUJoaFd6NmdjWmtWM0prYURTb2F4REdRSDl6Y3hKZW1z?=
 =?utf-8?B?ZWNzVy9UUTNDd3dLWFpIaHpraE5YSFB6YUs0cGc1Q3BXTWFiZVJDT1lwNmRS?=
 =?utf-8?B?M29CdmcxVWJidTdRR2pZRHA3aWtOL1NadTlzaTJwVXZlVDJhS2puai9NV1NQ?=
 =?utf-8?B?TE02TUpSNXZtdUNtK2xwMTQzcnVSTXl6SHd2blRwTlVEcjhWdUR1Ty9DUlZI?=
 =?utf-8?B?WHdKQ1dQL3VhUDZmTzlSQ0xPL3lrSnpVT3psVmZ5OW1vd2ljdWxrVmhCTGVK?=
 =?utf-8?B?M0lsTGQzTDREZXVmZ1gxZTc5YXJvVjhQSHd0V2s2dVM4R2l3Qmc4bUFjcjFJ?=
 =?utf-8?B?cmlLaWdIOHhleVNPQUZxK3E4Y2YwWTRuQ2hWTnRXK2VEUUVhVHo1VlNUTmkr?=
 =?utf-8?B?V2p2VENmZ3ZNVDZxUjlYVnMwNTlkVUFTUmVLcEQ1bjJWaVNXQWZ3MDJUYTds?=
 =?utf-8?B?cDJIeTJVekdtNXhUVlpQcjU2cjdTdzc0MXRkN0lGekZjdGRDL3NwYzRUNUZR?=
 =?utf-8?B?YTVFUVMyR1I0d0w1NXhNbSt5ZHhHUzUwUytnbUJXcDVxOHBkTktQQzM0Ky9L?=
 =?utf-8?B?cS8wOTlyRG9iNHYzbk5iZ0lwb0NZUTFVdUtzTURMVGMrbkVodlJINVg4QUdu?=
 =?utf-8?B?U1gzd2U4QWNqRmV4RUNuVUpJNFJlTTBNSVBlTTZkL2FXYVh4VlFLV3NwWmVN?=
 =?utf-8?B?UndrRGc4dklBbmd4RW15ZDVrMDZkc08vWS9aQkJ4Z1h6dFBwT21pNGh2TUdj?=
 =?utf-8?B?NC9xSG1DK0VVMGFrRDdxcDdnZ2JzNlpmVjBycldTTnNhZHR4UEhaNDFkTVlo?=
 =?utf-8?B?MkVHaG9iZTVSLzZZcW54RndCaUtSY1ZHNGpNaWxIWFRQMDIxekR5bVdlZjNx?=
 =?utf-8?B?OEc5cm0zQW1pZVBRcnJtWm0xbkMrV1QzOEJUd2lNRmtMalo2R2tDMHhhditC?=
 =?utf-8?B?RDNmSzBXS1d5MUR3b2RrblJjQzJkbmVLdzZqMExoSlJlS0g4V2JvRXhHamNM?=
 =?utf-8?B?U1BielRwVUZ2OWhDeHFMc1F2UnIvcXNZaCt3SVpaWjJUSnoxZkFreFNNMTNK?=
 =?utf-8?B?SGdzcmdIQXZBNGZHWDVWUlk0NElHTjNjL2I1cElPbGxwamN3WklGNVkycCtP?=
 =?utf-8?B?VG9lYTRxamN2TmhTOE85MjJEM1Z3K2VicDdFMFRSUjZsN1RLZ3FTdytTakUx?=
 =?utf-8?B?QUdQbXFRWE9ZTU9NQjFORVZ6NkJRczlvTVh6UisyNDhCK2xaVTZyUndYY0Jh?=
 =?utf-8?B?MXhrYnZLK1FZSzNlRTNURVhxeEhpYnhaQkNlSWM2VWFvdHFHaFJTZGo1Szhk?=
 =?utf-8?B?bTdEeWtHdUJZUEtYYjJkbkZlT1JKY3U1cXloTWFVS2pqcDdwRGpXczZUQTlp?=
 =?utf-8?B?bzlmM1BJbEhPL1hzMC9KejFOaTdFL3hkeG9pUkFhNjA4QXJQbG1KVjFaVnE1?=
 =?utf-8?B?WVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1E2FF44BC6221F4EB3C46A56B94A636F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9881bbaf-9958-45a1-6717-08ddea41b657
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2025 16:56:50.9313
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rf+o8eHbBk9UR6kNg0CC09397wW2ykcy3Ypc33IpzZintSdemudq4r0v5YBUOF59MsonChX3ur9Y5KyTvdqGvvIGUMAe01fNmY7pjkQXFkI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5168
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA5LTAxIGF0IDE3OjA4ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBU
aGUgY292ZXIgbGV0dGVyIG1lbnRpb25zIHRoYXQgdGhlcmUgaXMgYSBuZXcgVERYIG1vZHVsZSBp
biBwbGFubmluZywgd2hpY2gNCj4gPiBkaXNhYmxlcyB0aGUgaW50ZXJydXB0IGNoZWNraW5nLiBJ
IGd1ZXNzIFREWCBtb2R1bGUgd291bGQgbmVlZCB0byBoYXZlIGENCj4gPiBpbnRlcmZhY2UgdG8g
cmVwb3J0IHRoZSBjaGFuZ2UsIEtWTSB0aGVuIGRlY2lkZXMgdG8gZW5hYmxlIGh1Z2UgcGFnZSBz
dXBwb3J0DQo+ID4gb3Igbm90IGZvciBURHM/DQo+IFllcy4gQnV0IEkgZ3Vlc3MgZGV0ZWN0aW5n
IFREWCBtb2R1bGUgdmVyc2lvbiBvciBpZiBpdCBzdXBwb3J0cyBjZXJ0YWluDQo+IGZlYXR1cmUg
aXMgYSBnZW5lcmljIHByb2JsZW0uIGUuZy4sIGNlcnRhaW4gdmVyc2lvbnMgb2YgVERYIG1vZHVs
ZSBoYXZlIGJ1Z3MNCj4gaW4gemVyby1zdGVwIG1pdGlnYXRpb24gYW5kIG1heSBibG9jayB2Q1BV
IGVudGVyaW5nLg0KPiANCg0KV2UgaGFkIHRhbGtlZCBpbiB0aGUgcGFzdCBvZiBub3QgY2hlY2tp
bmcgdmVyc2lvbnMgYmVjYXVzZSBpdCB3b3VsZCByZXF1aXJlIEtWTQ0KdG8ga2VlcCBsb2dpYyBv
ZiB3aGljaCBmZWF0dXJlcyBpbiB3aGljaCBURFggbW9kdWxlLg0KDQpJZiB0aGVyZSBpcyBhIGZs
YWcgd2UgY291bGQgY2hlY2sgaXQsIGJ1dCB3ZSBkaWQgbm90IGFzayBmb3Igb25lIGhlcmUuIFdl
DQphbHJlYWR5IGhhdmUgYSBzaXR1YXRpb24gd2hlcmUgdGhlcmUgYXJlIGJ1ZyBmaXhlcyB0aGF0
IEtWTSBkZXBlbmRzIG9uLCB3aXRoIG5vDQp3YXkgdG8gY2hlY2suDQoNCkkgZ3Vlc3MgdGhlIGRp
ZmZlcmVuY2UgaGVyZSBpcyB0aGF0IGlmIHRoZSBiZWhhdmlvciBpcyBtaXNzaW5nLCBLVk0gaGFz
IGFuDQpvcHRpb24gdG8gY29udGludWUgd2l0aCBqdXN0IHNtYWxsIHBhZ2VzLiBCdXQgYXQgdGhl
IHNhbWUgdGltZSwgaHVnZSBwYWdlcyBpcw0KdmVyeSBsaWtlbHkgdG8gc3VjY2VlZCBpbiBlaXRo
ZXIgY2FzZS4gVGhlICJmZWF0dXJlIiBpcyBjbG9zZXIgdG8gY2xvc2luZyBhDQp0aGVvcmV0aWNh
bCByYWNlLiBTbyB2ZXJ5IG11Y2ggbGlrZSB0aGUgbWFueSBidWdzIHdlIGRvbid0IGNoZWNrIGZv
ci4gSSdtDQpsZWFuaW5nIHRvd2FyZHMgbHVtcGluZyBpdCBpbnRvIHRoYXQgY2F0ZWdvcnkuIEFu
ZCB3ZSBjYW4gYWRkICJob3cgZG8gd2Ugd2FudCB0bw0KY2hlY2sgZm9yIFREWCBtb2R1bGUgYnVn
cyIgdG8gdGhlIGFyY2ggdG9kbyBsaXN0LiBCdXQgaXQncyBwcm9iYWJseSBkb3duIHRoZQ0KbGlz
dCwgaWYgd2UgZXZlbiB3YW50IHRvIGRvIGFueXRoaW5nLg0KDQpXaGF0IGRvIHlvdSB0aGluaz8N
Cg==

