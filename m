Return-Path: <kvm+bounces-54526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF985B22B74
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 17:13:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B45547AE251
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 15:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E77642F5320;
	Tue, 12 Aug 2025 15:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eppAt1Qt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A843D2D3744;
	Tue, 12 Aug 2025 15:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755011577; cv=fail; b=ZTUcZ5R/cnYmzV5SgmleHhcc8xuX6+CtEUMbrNqDBNObouaO70bZdrViLy2iA1lW3bOutKcUvVINvAu5CElHCSZDWrLb1pFILmP282Vd1ejbLiqIcX0qV9IDLnoQppny6Rbhb+MdwhS+0Z1SXMmi0/EOeNEpC+sOIiA2S/IcWGM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755011577; c=relaxed/simple;
	bh=t+jQ8l6fCSSREg4oUunGPIRppdMhoEzCf5FrMy9RcBE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DkVrID9TOHdVQplHK+pOzCkiVIL4W4FED2B15qUAdyBxSWlKo1AotZ+mHqPLovbp8pH/7Mh1Qx5ndh0NDGk3+yQZ1v7c/q7cOa4QL1UPF3Bk4NUSrKO8tG+6r8TgeAGCk23hzqCO7Poy+g/YGTIOHmW6P4PSnZ6E5d75Q/Joh4U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eppAt1Qt; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755011576; x=1786547576;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=t+jQ8l6fCSSREg4oUunGPIRppdMhoEzCf5FrMy9RcBE=;
  b=eppAt1QtjFk6gvjT3x229lje7pSnp3ivpicGZ8Rc326ignoOfz/WTnvJ
   pNmWTtTgESqe2qZYPVWm4biLFJ7Rx8D+s8EfBlvgxodMXFSjbXBAe/s0D
   21G2RNzFgJKYXqeb7UKTP/zB0bmi0szF+8SvHn0c+ZjkZT0qFffimKuwt
   QKlgwfTtKSbxHWU99aGvy/FD2mUxEj7n/WHAmDSQzpgZLkbjJQIFPx4m/
   Mcf5HITybtZINuCwd3GSoLIMw4f+HwKbqCLOn4lBQsvTU4DHPTWppDNYH
   jgsvJiSLloZSqJRUZgC1HBBqTATvZYItnuJcZeJEpefRSR6Vu78PFr4zq
   w==;
X-CSE-ConnectionGUID: voTFhAnQTySk6tvW1NkpJw==
X-CSE-MsgGUID: f/WJrQRRRZy5HeombTM/5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="61133919"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="61133919"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 08:12:56 -0700
X-CSE-ConnectionGUID: zQ58l7CwSfKhIc2BZZyc0w==
X-CSE-MsgGUID: yhKDqGiXRX+QprRRhHH8tQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="170666077"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 08:12:55 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 12 Aug 2025 08:12:54 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 12 Aug 2025 08:12:54 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.72)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 12 Aug 2025 08:12:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ksLfVjLWtc5SRYnGkS4RNWSo20ooiW/GLsvpvz4wP5CEC0EFJS3OBlCt/F0fr4vDPrLLavxk199/+F0mYdB5+h1rts2bxaGd+5a7zK8DDungnRWxDllZkUu06Pv3dKk++OvmCVC2dMORiM/mLKxYRggURFeh7F3tRqiQVXN3PI7WO2LAp1GSSCqVcwTFC+fCYYZNdCq3V7+yrCEbDKdWlnF7O8+AkahgvHTpAAmM/3GjYIQcIGQNlvmeU1i2AMNneNoCtra18AmOiBD5iWYL7UXCmTCqCw/s8aLGZIjHDYnoQL7b9EayCW8aQp/l3AbYjDp6H3FwBuBYFByOMkdPIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t+jQ8l6fCSSREg4oUunGPIRppdMhoEzCf5FrMy9RcBE=;
 b=Pf0ZU11SDsUqWWKyXFC9ilM209fSHvPTpx1BdVsw6yz3ANtdTno7TdcV1J9/3oz6+aRFjcvhA15SIhOWMzAiQjoqEaHbLG3Hp5R5ceryO62o81UdhrVvzptVNtefHoY0Dlt4oCr6DS6wmVslU2hquYEoxsVwS5Fr7Cf5sN3QV2hKHuOqZy+Xhm4lrAEQ9L2VJI+NuH+bTolQu1kUxrjv6kZI8wioygRUXoUg7wMnjtRXmGWbAhuVSzRcp9Cg7F5J6Po2qoO0k/pc6HaF36b3rhX5PEOMYFqNZxiUSDjlu2RQz6sXBQpP39QeqFXS805r9B4tzPYL3tDMooQ/mPFT2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB6965.namprd11.prod.outlook.com (2603:10b6:806:2bf::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Tue, 12 Aug
 2025 15:12:52 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9009.018; Tue, 12 Aug 2025
 15:12:52 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kas@kernel.org" <kas@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>, "Huang,
 Kai" <kai.huang@intel.com>, "mingo@redhat.com" <mingo@redhat.com>, "Zhao, Yan
 Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Thread-Topic: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Thread-Index: AQHb2XKrCJQDYmgN9EmkL7mVJaZZf7RZwqaAgAOdgICAAQwrgIAAOwMAgAAILQCAAF0hgIAAd5yA
Date: Tue, 12 Aug 2025 15:12:52 +0000
Message-ID: <57755acf553c79d0b337736eb4d6295e61be722f.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
	 <d432b8b7cfc413001c743805787990fe0860e780.camel@intel.com>
	 <sjhioktjzegjmyuaisde7ui7lsrhnolx6yjmikhhwlxxfba5bh@ss6igliiimas>
	 <c2a62badf190717a251d269a6905872b01e8e340.camel@intel.com>
	 <aJqgosNUjrCfH_WN@google.com>
	 <CAGtprH9TX4s6jQTq0YbiohXs9jyHGOFvQTZD9ph8nELhxb3tgA@mail.gmail.com>
	 <itbtox4nck665paycb5kpu3k54bfzxavtvgrxwj26xlhqfarsu@tjlm2ddtuzp3>
In-Reply-To: <itbtox4nck665paycb5kpu3k54bfzxavtvgrxwj26xlhqfarsu@tjlm2ddtuzp3>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB6965:EE_
x-ms-office365-filtering-correlation-id: 8fe2d0ef-fdb8-4856-1f1f-08ddd9b2b501
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?V2g2VCtNUFRMbVJYYkdlUHlVcjVVbUFBM2JkV3Z0M1VuMDZkaFJ6eUk2WUZL?=
 =?utf-8?B?allTZUJMWlgzZGpOdVRlelhuT1gzWGVsa1dRa0ZJRDVjUko2Rzk1OWtKWk5K?=
 =?utf-8?B?Ym5IdFI4RTJtRjVVeHpGNE1hVUJaVGZ3R2tjUU1RSDAvVzJmcHBmM1RjY1A2?=
 =?utf-8?B?VGtabjlKdlBmY2d3OEFrRk5uMW9aMVQvYklPTU5LdDdFMVcrelFMeC9ia2NZ?=
 =?utf-8?B?dkIwci9remJFNm9xMGJRajh1ZEtFdCtHV3h5SUNzRDlrNHpiTlYrSytHaGd6?=
 =?utf-8?B?V2h3L2xDZU1QS1M4MWdDV3cySEEvNUFEdFVseXc1TWlvVkYwak5TMVU4YkNC?=
 =?utf-8?B?VWlrYkxmR2wwbCtTem9jMkwwcFlQNTVnKzk5L2xCSmFNVVFLWG5uakc3S0pp?=
 =?utf-8?B?aDZENUZYSVpqSXI2dDg3aEhBa2IwdlkvMDd3R1M5VEltWGtvUFFWVXdkb1pp?=
 =?utf-8?B?T3UyR2Z1WUNZdFJDdjc5azFmSjc0REViTWNiUzBxenVCNmE1dkh5Z3NpdzdB?=
 =?utf-8?B?Z1VnS3BBQ21wWWgyUENWUWwvOHZIcDZ5bEtoNEJWY2Nwemt2V0kzMTNOZlFM?=
 =?utf-8?B?YmM1Wmd3SUg3ejZNL1JyS3RIRmk0K3ZZR2hpbS9ZN05JTFVUMWszYkZUTkJ5?=
 =?utf-8?B?OXc5cGJmaWczMklacVpFQ0d6VWlYekhybVZ2Rk5XNGFpOVpJTjNIeWJyNHZW?=
 =?utf-8?B?OTJHdEU3TGtnY1JoV3NLL1JZTWp5czRRdnF3Qy81MWhuWG1CZ1ZCWkx4NkxW?=
 =?utf-8?B?RE1GWXk3WDN5RzJyTENrYldoN1Rmb2UwZkdZT1dvN0VHa2FVUFpEREpETSt1?=
 =?utf-8?B?UmRXZC9BRlJ2SkxMODR3YUdjMjdkeUw1U2o1Y3RjZ0l2bTF2MVlyQ2pmYVhs?=
 =?utf-8?B?R2lNcTdKMmplaC9mclFFdkp5YWplTklPNjdmcXdxd3A5UVRJeDZBd1psRGVK?=
 =?utf-8?B?bVZTVFRMVEtSajVOUkFPbHZEUlh2RktpaVVLOWk1VkQzcGdKVUtEcVo4YzNt?=
 =?utf-8?B?Y2pGVlZWb3pvY1VraDU3cnZJUDB6Q2hZV3YyVDlQek92WEkzaUYzYnloR3M3?=
 =?utf-8?B?ZGxrdnNHcGN3T3hyOXRGdGxxSlBNMjBYSkEyTTVUS0kxRG1RQXZZNmFmK3VB?=
 =?utf-8?B?REsxRmdCc01xdDh5K0luNWpIeTRkRmp1Vks2MXhubVM0WGNISXFJUThKUlh6?=
 =?utf-8?B?SEloZ3JDdHQwLzlrNzM3YjgvQnB5OFMvSHBzWkQ1TVBwSXZNNm9LM0IxNGJv?=
 =?utf-8?B?LzJxY01HeElHNXdhdW50MUo2bzJDNENKaXBBa1NwVzhnZ25OdDZqSU9SbHNC?=
 =?utf-8?B?L2pUWTlLcXlId0kxY000ZTZsYUdGN2JnSVZZZ2NKOUpGdlUzL0V4MDI3OU1p?=
 =?utf-8?B?UHhEbVJQUjB2NDBCZ2ZONXBZbTZySzVYaXFxTzNzcnVYSC9OK0ptdSs1TGN0?=
 =?utf-8?B?ZU1aME1teC9UcjMvZmNnNUJQQ1RySXU1STJTTHJ4TkZhR3ozc0FlWU1PZVdw?=
 =?utf-8?B?VDZLWGJtWHFTeUpLZFQ1V2xhMWRJaktSRG5OamFtMUNIMUlVSUlhTUtsS1o5?=
 =?utf-8?B?YXBmVTRNMXN4UFF4c3ZNai9QZkg5cnl0Q2F6bGx1Z3VlUFhlNWhYTnZrSHFk?=
 =?utf-8?B?OW5QdEh6Tk0zbVhLeTdWdXNmM1l1UCtrZ3d1dmRDU3ZMUW02aW5wNEdtZCtJ?=
 =?utf-8?B?Njd4YSsyWDhRc1YyTmpzeDFUK3VQQ0MrQUZMVjJvSGFoSDFMcDgzamRTdG1k?=
 =?utf-8?B?YW5VWjkrNHF0eVF4VUdUSnBUenVBc2hwVGtGSENJUmVoTUlqcTMrUWRVNGNw?=
 =?utf-8?B?VVZqQU4xTzVFSmN1RlBXUVliWEM4cTU5NjRPYmVrYjBxa3g1TTZMU0kzMHZ5?=
 =?utf-8?B?Nm9QRWh4UHhMaCtWOXRCbFpnZnh5b3FIU1o2S1dxQmlUaC9HOTMzbGx0Nzdn?=
 =?utf-8?B?S2h2QmRKdGNGKzZuek5RNktoYnBxbEFNVndVaVNtdkJsNWtGdURzeXd3Mmdx?=
 =?utf-8?B?WU9lb2N2dDVBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S1dybHVXbWw1dzZSc2JZMEFsQWFiVVhRMXZvYldXWDZ1cWtrc1hNR1ExQWtZ?=
 =?utf-8?B?NnNvMUE0alE3Q1JReW01RURHQWtyYzdQRHJPdTlodVF2ZzFDQlNnOFdjYXc3?=
 =?utf-8?B?UVpaOW5ZZTU3d0tOOUZDd254Qm81ZGdDYTh5bjdBWG5TdHpOZXZYd1RIekRi?=
 =?utf-8?B?d3IwM1djVENPZTFkRmtJbldPTWxHUmJqM04vT1ZneTYyeGFWWlFOVVpNbFA4?=
 =?utf-8?B?cy9VclFIeERQMzNlQy9aYmJjRVJHYjRJeHl4TFZkVncxUU1iditQbjZpUUtY?=
 =?utf-8?B?VWdGU0VnRUp4RVNDdHJjVVo3MkVTbVpOVytaUy90U28vT0Q3emxxaW1jN1Qz?=
 =?utf-8?B?OGxTMG1nMS9VdEtCdkowbWxzZEV5eDhYTkZwK2dBc0pnOG80dnlKRTYrYkFG?=
 =?utf-8?B?QmQ2Tko5ZGtrWEQzblVFVWJuLzhjN3FlN3BsSmwrZlZFWFdqTUdPWDBoZzR1?=
 =?utf-8?B?TU9Zc1VMN0tKWUxGRWRGUTU4VzJ4L0gwL29WRERDTklQWitMZUJUYW1Fbk4r?=
 =?utf-8?B?eDhJelZ6VTdkNWgvS2FHVExpajlQZnB3cE9Wd09MNVlvaFQrVmw5V2llK05t?=
 =?utf-8?B?dlBFc0U3SWx5VERlMWQ2VWQvL2JVRDVXUEtlRUpGNHU0NkNEeVBZeExPSnVC?=
 =?utf-8?B?dzdnV1dLUDFNa0tySmhmNG9qemlVMzhXWjBqQWZZSmpQTVhybTEvZkU2UERG?=
 =?utf-8?B?aitXMDV3Q0lNRmtDV1B2SSt1R2czSTN6RW04YlNXN2VabFhUNXdoRllHWWg0?=
 =?utf-8?B?NURWK2NUdkFjNWVGbU5kRzNydUN4WkEwRUdOT0U2SmgyYTRTazdFQmtjN09j?=
 =?utf-8?B?U0k2RnZDbVRlL0RlTUh3R1VGQWsycFJxNjUvM28wUE5nMVNySTlkc2NxcGJj?=
 =?utf-8?B?a2lJN200aVIzdkk0eGhoZDZDeXBzWlkyRVlNUjhjenFHaE1Ud2JNMStPZ2Ju?=
 =?utf-8?B?N2d6SWxMRENJUGNCdlZSUEZrbXVaOTdldWlITnM1UXlRVkJYbUpIL0cwZjk1?=
 =?utf-8?B?OWM3T0pIeThqMVlBM3JyaG1nNXNtczB1MGlyTkpNTDBZekdhb0NvVjk5Vzl0?=
 =?utf-8?B?MXBHRGZYaHNRVjMraDZkUGFwK3FpWkF1cTRvaExVdFl3VEN6NlJreDc2QXZt?=
 =?utf-8?B?R3FBYW9CUlA1TVNXV0N1by9hd2g5RzNZTzVxektxWk1iYXNtMFNBbmhLNUhY?=
 =?utf-8?B?VlZmVXRnOUl2L2JlNnk4ZUpQSnBVMEhCWEVRV1F4OFNsVStxWXBkWTBFNEM2?=
 =?utf-8?B?bGIwMmlzbXNDUkRTUFRPcno3cjhQS0cwbGE3TzV4RGZCbDVxclZ5S0wwa05L?=
 =?utf-8?B?QjhTdVlNMUJGYkc2cHpIbG1rb09ZTHRVYnlyUUhYdW1kOFhCeFdZSjJmWDk3?=
 =?utf-8?B?RzhieDArQTE4WWY4cFA4YmNIZVpWbW1KcHg0anVkNElWU3g0dHp4SnRnbHdT?=
 =?utf-8?B?NEFsRUxIdERKWlRiSTJvSWs2amc0b2Y5cG9kSUpYcmNtdDF1M2RtTHpZTVpF?=
 =?utf-8?B?eG84bzRTNW5jWUZGL1AzZFIycTQyQU5NaVlLZHI3cW5pcjFuVzBsMytEcllO?=
 =?utf-8?B?L2pQUkZFVkxQU0FmQ2ZKYWpzRm16bCs4MG9idk11TEQ3NWI3Z2FLTy84Sk0y?=
 =?utf-8?B?VWxUajVQam5jUGFUNXdEaEJrYVord0Nwc2drVzRqYnA5cUZSSk1BV2phUzZP?=
 =?utf-8?B?bTQ3Mml4MWp6Zm1NU25oR2ZJMSsyU25PQ2ZOaE5FZnZYcDFMd0QrRWJnN2k4?=
 =?utf-8?B?VHczeXB5WGZ4U2EvbU5teGM3NTQ0NHBaTThxdHZSc0pUVVZmOXkwa0NqeXdm?=
 =?utf-8?B?aHhHcWpvNHJnNUhrZHVQY0tDclRlV3JZcm1GQjR6UTNPbTVjazZRN3JvbVdN?=
 =?utf-8?B?TGhEaXRhUWtzTyt3aExRM3FDT0R5ZjdXYUlMa3RXMS9Pb2tiSkZZZ24yeUNM?=
 =?utf-8?B?WWh1MStTYjg2QTRpWi9JMGhRTURsVEhwN1AyTE1uVU12azJZUHo2SkdtV0dP?=
 =?utf-8?B?ZTlYWVdmN2JoVmtUU1VmR0oyck0wNllGWXltTXJJZWdITlUwTVh3UDIrbUNl?=
 =?utf-8?B?MDNjNUxOWDdEZTR6RjFTYkl6WUJxaWlBbWZQeHVTN1NHelZZMGJFa3d3dVNE?=
 =?utf-8?B?eXdZcFhXMWxJM1ZkZVZoeG5FS2hhQWZnM3BEVWtpKzdpSzZ4RW9qQmJmUE1L?=
 =?utf-8?B?Wnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FF66BC610F099A4193F655AB0D98C3EF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fe2d0ef-fdb8-4856-1f1f-08ddd9b2b501
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2025 15:12:52.0561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tzKkm5Kfe5dDTHlMHiVJnwJx53n5G+jDRNq7xIsiYS/T6xt4HhJtFvRBiuPUaYcPMgIADU65TFUDwZIYCHXMS2H/V56ORlMDuDMRxzLFRWk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6965
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA4LTEyIGF0IDA5OjA0ICswMTAwLCBrYXNAa2VybmVsLm9yZyB3cm90ZToN
Cj4gPiA+IEUuZy4gZm9yIHRoaW5ncyBsaWtlIFREQ1MgcGFnZXMgYW5kIHRvIHNvbWUgZXh0ZW50
IG5vbi1sZWFmIFMtRVBUIHBhZ2VzLA0KPiA+ID4gb24tZGVtYW5kDQo+ID4gPiBQQU1UIG1hbmFn
ZW1lbnQgc2VlbXMgcmVhc29uYWJsZS7CoCBCdXQgZm9yIFBBTVRzIHRoYXQgYXJlIHVzZWQgdG8g
dHJhY2sNCj4gPiA+IGd1ZXN0LWFzc2lnbmVkDQo+ID4gPiBtZW1vcnksIHdoaWNoIGlzIHRoZSB2
YWFhc3QgbWFqb3JpdHkgb2YgUEFNVCBtZW1vcnksIHdoeSBub3QgaG9vaw0KPiA+ID4gZ3Vlc3Rf
bWVtZmQ/DQo+ID4gDQo+ID4gVGhpcyBzZWVtcyBmaW5lIGZvciA0SyBwYWdlIGJhY2tpbmcuIEJ1
dCB3aGVuIFREWCBWTXMgaGF2ZSBodWdlIHBhZ2UNCj4gPiBiYWNraW5nLCB0aGUgdmFzdCBtYWpv
cml0eSBvZiBwcml2YXRlIG1lbW9yeSBtZW1vcnkgd291bGRuJ3QgbmVlZCBQQU1UDQo+ID4gYWxs
b2NhdGlvbiBmb3IgNEsgZ3JhbnVsYXJpdHkuDQo+ID4gDQo+ID4gSUlVQyBndWVzdF9tZW1mZCBh
bGxvY2F0aW9uIGhhcHBlbmluZyBhdCAyTSBncmFudWxhcml0eSBkb2Vzbid0DQo+ID4gbmVjZXNz
YXJpbHkgdHJhbnNsYXRlIHRvIDJNIG1hcHBpbmcgaW4gZ3Vlc3QgRVBUIGVudHJpZXMuIElmIHRo
ZSBEUEFNVA0KPiA+IHN1cHBvcnQgaXMgdG8gYmUgcHJvcGVybHkgdXRpbGl6ZWQgZm9yIGh1Z2Ug
cGFnZSBiYWNraW5ncywgdGhlcmUgaXMgYQ0KPiA+IHZhbHVlIGluIG5vdCBhdHRhY2hpbmcgUEFN
VCBhbGxvY2F0aW9uIHdpdGggZ3Vlc3RfbWVtZmQgYWxsb2NhdGlvbi4NCj4gDQo+IFJpZ2h0Lg0K
PiANCj4gSXQgYWxzbyByZXF1aXJlcyBzcGVjaWFsIGhhbmRsaW5nIGluIG1hbnkgcGxhY2VzIGlu
IGNvcmUtbW0uIExpa2UsIHdoYXQNCj4gaGFwcGVucyBpZiBUSFAgaW4gZ3Vlc3QgbWVtZmQgZ290
IHNwbGl0LiBXaG8gd291bGQgYWxsb2NhdGUgUEFNVCBmb3IgaXQ/DQo+IE1pZ3JhdGlvbiB3aWxs
IGJlIG1vcmUgY29tcGxpY2F0ZWQgdG9vICh3aGVuIHdlIGdldCB0aGVyZSkuDQoNCkkgYWN0dWFs
bHkgd2VudCBkb3duIHRoaXMgcGF0aCB0b28sIGJ1dCB0aGUgcHJvYmxlbSBJIGhpdCB3YXMgdGhh
dCBURFggbW9kdWxlDQp3YW50cyB0aGUgUEFNVCBwYWdlIHNpemUgdG8gbWF0Y2ggdGhlIFMtRVBU
IHBhZ2Ugc2l6ZS4gQW5kIHRoZSBTLUVQVCBzaXplIHdpbGwNCmRlcGVuZCBvbiBydW50aW1lIGJl
aGF2aW9yIG9mIHRoZSBndWVzdC4gSSdtIG5vdCBzdXJlIHdoeSBURFggbW9kdWxlIHJlcXVpcmVz
DQp0aGlzIHRob3VnaC4gS2lyaWxsLCBJJ2QgYmUgY3VyaW91cyB0byB1bmRlcnN0YW5kIHRoZSBj
b25zdHJhaW50IG1vcmUgaWYgeW91DQpyZWNhbGwuDQoNCkJ1dCBpbiBhbnkgY2FzZSwgaXQgc2Vl
bXMgdGhlcmUgYXJlIG11bHRpcGxlIHJlYXNvbnMuDQo=

