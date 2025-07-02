Return-Path: <kvm+bounces-51311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A429AF5D37
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 17:35:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5A0517B6560
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 15:33:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6742D2FC3CF;
	Wed,  2 Jul 2025 15:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F4xjba2S"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD4B2F85CB;
	Wed,  2 Jul 2025 15:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751470081; cv=fail; b=sfM7HGUh5xUAAIveHyIdqDzYPR1IwhkqulNrJMhOaIP6DLF/S7ksCVnUoRtvjFSrvOXDPYsLQ53xihhr8Im/cohtTFba60m3rRnku8rNTinATFhKPZYhnuqUPiNlYJ9dCKALCFkShyR4jGCuI+CJFxTHTcSso21QMBdtJCDqfg8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751470081; c=relaxed/simple;
	bh=+lKdzoN0QGhtr1tp080yrBZXQSlNEJ3UsGrX3ujpQaY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qh8pEt4ciCyloaKsSdDHy6BxC0tWBFgwz57vkZ/s8+KAPiN5uAKUXhC3oYU6xSBR1hTbt1hHwfFEy3nP+6PE85W3nQQn13d5RT0VgKRg9DdhQ7t4ZJC87/8IvvBhBCksMRhqRfR8B2413K+WzEPOHS4hjx4cBV7LdtHzT0qADus=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F4xjba2S; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751470080; x=1783006080;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+lKdzoN0QGhtr1tp080yrBZXQSlNEJ3UsGrX3ujpQaY=;
  b=F4xjba2SPHkEAytfgoMq1Asv6/3938tARCuAJBazOIDbqZkIaCnXeiG1
   OvHEcO+l1/zDogkq1Ey/72pyShZCjmvS2qDZh+P5uuUaxMD5AaFX9DGQ9
   ZkgZcxCnu4NZe9HgkVX0EYJ10KjCuq7F7n+GcJZZqqzPCUN9HCf42gQkg
   6TtSKtbKZiybhjPMy1LtOB4hBXvp2vAPP/k4XyV445NOoP2QauLZ8j07n
   RnmtXBXJl44+4gb4lKNdu1xER0xlIYMOJjlP+JKWi2VjRJx6QhO6sQZtL
   jFlXuGj2Laqj5HNxBLMmeF6KcBglmehh7GYUDX0HjriNC0mzxrUjA5G7U
   w==;
X-CSE-ConnectionGUID: pXCRii2/Qb+hj7gJV4bqtA==
X-CSE-MsgGUID: MW/rxXauRi+FR6VIbUCqfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="53917534"
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="53917534"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 08:27:59 -0700
X-CSE-ConnectionGUID: S5yJ+0G/QPKEmyZWt/zOjA==
X-CSE-MsgGUID: vuMkXnfFSbWpfkq0AVlU4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="185052283"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 08:27:58 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 08:27:57 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 2 Jul 2025 08:27:57 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.49) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 08:27:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pyxDureM943ebmXM79qfqngm7bxjdv1wNSdAtCImj/2bNaNVblsLpnBCVM8A/V3Ywu3o5rWztFRggbyM1Ft5Qw8a9O5bVWKukv0MQHXSKW9gu4f5RbNO23d+BspqvoBulN/ISWlsTQgod1B101GUKo/2jyJa6WUjbaqM3xhn5zXczKOGhd/EqNz0dcXCy+YFf8V8khEZFOhKmCKhqaR/50S904S1ODY+YJ0LnXUg90VWQaHpeIq6i2drXqQ1WX+yJp/4QomvycVArv8h7kf9i/XiZUG3dKp7gHRaI4UMqrDujRZ+sqXuFqmF7NgXR9c79Ucip8nmyTOLR191QUekcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+lKdzoN0QGhtr1tp080yrBZXQSlNEJ3UsGrX3ujpQaY=;
 b=L+ocC3312liVIPbYOPDs/8XBEyv8ApI8+4NBOjn018fl8mFADlVp7hg1Qc+JpVgIrTFuTd5Ictoj0irluSiIaf3feTpNlWz7Fux2yDZRLW6l6QN0bZSEpHYKEHxmxKHKTFw1jIgngq2p0qHAgLwKgH53oZH1iU6/Yt/iIqepeOALfjn5A7ez1lirSYG/NY65iq5Y6+iwtr4YLnqWiYvha2Db6hMJzjPEI69o0yEHmwtu2TaK+1+zMu3VYYnJ7wSvxXEXwluQ7bpddKpT0n267EfMYVWId8Y/C6T5L6gwkcePBgMj+yr5vMNQEkLiL9xnRAJkioVzPX0/wr1FSUqPwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BL3PR11MB6412.namprd11.prod.outlook.com (2603:10b6:208:3bb::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.19; Wed, 2 Jul
 2025 15:26:55 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.018; Wed, 2 Jul 2025
 15:26:55 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"tabba@google.com" <tabba@google.com>, "jroedel@suse.de" <jroedel@suse.de>,
	"Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Topic: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Index: AQHbtMYisXlDVaH8LEKqVl1+c9iQ77PRHICAgAN/mYCAAIg5AIAA1+mAgAPLQICAAIwTAIABF74AgADuIICAIfsagIACKESAgAALWQCAAAHGgIAABSeAgAAA3ACAAAyHAIABVQyAgAAHeoCAABSygIADYjmAgAFIQYCAACKZgIABjCaAgAQxHwCABQ5egIAAzNwAgACQ3gCAAPlVAIAAWTqAgAEvVYCAB1KDAIAAIT4AgADYfACAAJAsgIAAAc2AgAANg4CAAPA2AA==
Date: Wed, 2 Jul 2025 15:26:54 +0000
Message-ID: <67419b2b9addefa0b728bf30099f55edf58964ed.camel@intel.com>
References: <aFp2iPsShmw3rYYs@yzhao56-desk.sh.intel.com>
	 <a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com>
	 <aFvBNromdrkEtPp6@yzhao56-desk.sh.intel.com>
	 <0930ae315759558c52fd6afb837e6a8b9acc1cc3.camel@intel.com>
	 <aF0Kg8FcHVMvsqSo@yzhao56-desk.sh.intel.com>
	 <dab82e2c91c8ad019cda835ef8d528a7101509fa.camel@intel.com>
	 <aGNK2tO2W6+GWtt3@yzhao56-desk.sh.intel.com>
	 <908a8abdf0544d4fba23d3667651c4cfcafa9c4f.camel@intel.com>
	 <aGR5ZYpn3xyfOZhS@yzhao56-desk.sh.intel.com>
	 <f13239faa54062feb9937fe9fc6d087ffcca7ac6.camel@intel.com>
	 <aGSGPc+aovhd/SsN@yzhao56-desk.sh.intel.com>
In-Reply-To: <aGSGPc+aovhd/SsN@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BL3PR11MB6412:EE_
x-ms-office365-filtering-correlation-id: 56fa6c10-13c4-4fc0-8557-08ddb97ce07f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UFE5dXFyQ0lINVZSUEhoWEhlUEFmRFNTdEp4dTIraVBENi9wamN6d01VVWgv?=
 =?utf-8?B?OHp6eUtoM2hITVA5MDJDRDFQUlFiUlJKZ094ajdBMFYxSm1LYjF3U202Q0kr?=
 =?utf-8?B?NDNXNkZJY3ZzSHIwTlB5WExQTFVQeis0RkxCZnlJSU1mSlVRVmtUbGVSclAv?=
 =?utf-8?B?RXRzRHZaemNmRTJsV00xei9xZFI3ejIrRXBKOEhjeEpleFVlYTUxbjNjcWkr?=
 =?utf-8?B?MGR1NHJPNVhBRHB1bEhuN2E3ZC9qZmttVjVWV1ZQZzBOa2k4U2VBQk9uWVpC?=
 =?utf-8?B?TzhvWVR3UDVlWG1yTE1XRWd6WlkvVzI5azJKTEFDaCtuSHRRVUh2dXdHb0hi?=
 =?utf-8?B?OUdyRVRaekFCM3BtbWlsYzV3Tk52TE53UHNpcVd1ZVE1SG9UTWxJT2pQNlp6?=
 =?utf-8?B?S1h1NHlDRU9yZHpSNDJDdnZ1bU9ZckhKc3A5MW13UlQ0YVUwbFhjT01Nanl4?=
 =?utf-8?B?aWJEV3NCNHk5RkdmUWVEaHRkQmE1Rm4vMnZXUVA3d0kwV2NjUzdwMWJRbXRu?=
 =?utf-8?B?aG14YlBqMkxqZDc2S1pHN1pQNjRSZjY4WXJ6Y2twYjEyejErUzVzZWdYUEQv?=
 =?utf-8?B?S0xqQ3NqMG1MVVQvN1dtRXNiTGdVb2Q0MzlML0JrM09YVUZoQ1B0VEZncWsy?=
 =?utf-8?B?MDN1djExM0hPcGcyWEpPVitRL0FwUnM5VW5GRm1XM2YvN3ZLaFYyaGgwU28r?=
 =?utf-8?B?OW5RV1U2L0IxZjVNWlJ6RU9OcWhyM0tmdy9yTUN1QlE2d2V5d0IwdTlDVjFD?=
 =?utf-8?B?TCs1c2t1MUxybkdiV1ZDcXlHVjd6UU4xSEdnaFp2SG5TQTRacHBqVGJVVGtV?=
 =?utf-8?B?T3E1SnNHd0NjMFFhUjJSSlRuL0R0dTlGOU5pVzdOemlWNExEUnROVWZkME5Y?=
 =?utf-8?B?a2l6UjRJbFhidVhlVmNRb3ZKRzJ0UGZFUElOODA2c09FaU80N3NZNUR3UlB5?=
 =?utf-8?B?N3U4MXNxdUFuY2FPSUdMR0s1U2dhSlI5VGF2Z1hCempxNXVlcTM1cTdhdU1G?=
 =?utf-8?B?V2t1K2ZaM2pGVnhYRWJQT1VIY0VDZWR5WjRYRVB1dU1SQ0hVQTNYczNqQ3FL?=
 =?utf-8?B?MlpDRWlVM1M2NGFZUFFqa1Y4aVg2eVZYc284bzRtOHg4TDRxcDNRYVRCbHYx?=
 =?utf-8?B?MFpBMmg2TTJIRzllT1pISkp2ZktjQUxJWFU2NHJxcW5ONkFkVnA4T3BwNzNP?=
 =?utf-8?B?andqNUhhZWlVamZZSVRqNnhSVytZb1Y1Nk9ydWV2Z09yMTFUQ3ppeWhWNWY3?=
 =?utf-8?B?QVZOVkRSZ2tsVVByMDY3WjJyM1lpY0EwRzBDM1dEcFI5M2hiWkdRWjBIdVBI?=
 =?utf-8?B?NzVVY1J4aWx6YmxoTFRWaUtqNk5Xc3Nldno0UkpveEhkNWMwd3BFUlozMW9p?=
 =?utf-8?B?WjVpSU9WVVp0UmtpNnl6eEV5SXQzeW0vQjliQ3o1Vm9vT3U3eWZncGhzOEZh?=
 =?utf-8?B?VVA4NjBYT1Eyd2ozQVdVT2ErNjlHSlFNeENFOE1JcHp1dW51NFg5NlJnN0xG?=
 =?utf-8?B?bDE3RnA3a255dmlUSFJ3OUhZWUs1a2tKVnFQenV5STVWaEV3a1p5SGFtVjVU?=
 =?utf-8?B?a0xlcUNBT0YxY0hWenpKRlhnYWxvd1dxMGI4R0U3UzJOMUZjSndLTUZvQWp6?=
 =?utf-8?B?M1A3YVEwa3ZrUnVaczduK0ViaDBpK29lQThUS0lacFdBR081TWd3aUZxZFcz?=
 =?utf-8?B?N1FDTWVRVDc2RmZveWF1UGlkaTJJZm5ycDRtdjhpdDUrSlNXZmV1b0xUUEVy?=
 =?utf-8?B?Wm1uOFg4WFJmdGZtcC80OVZiMGsveWhQZ3pLU1dnU3ZIMk1GbzRFa2V6ZFVv?=
 =?utf-8?B?UWVxTFQ2N0xoV1l4Umgrd0ZEcS82UVl5ajF1OWVBSFE1VjZYc2NIRlB5OTZw?=
 =?utf-8?B?d3lZcmJYbHh3K1hxVWFXckR6ZFpCdUxpUWRYeDlHT3R0VDIwSXVRWElQM2xm?=
 =?utf-8?B?UWg0c0d3UnpPaWRQQ2tOSXcxaUh2RXRqWGdiOFJzZTI5WHpRbE1ETE5SSVBY?=
 =?utf-8?Q?sVm4yTbb37yFAtFksMqnF/kkfxZhM8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MnRnZEhHTWJqYmNob1dLdzBXNWNYd1BGZi92b1krV1dUSE9LemRxK2pNN0hk?=
 =?utf-8?B?ejBqUm1IL1R2K2VHb3dmeEZhVS9kelE3bk1qRUhnaE5rVHorckVmYzU0QUFF?=
 =?utf-8?B?S2RsQm81eDFnT1ZmUGZSSHU4RW1lRmJVWTNDQnFScFpBUTJRKy9LNkd1MTBn?=
 =?utf-8?B?QjFmcFExR0dYaDNvSzN4emExeFI5TEFHQWlpY2xDTzRlSVBnSDhrTklwSWRK?=
 =?utf-8?B?NUFCNGVjblFOWWlCUURvUDFZNDF3WnpFMU9GdWt0TUwwQmNJOWcxQjVCVy9M?=
 =?utf-8?B?a1kwd0lsNm5HdGdhQ0o5WGg3Yk41VVMxczd2RExtM3RjS3NvSnJuTlh2cXpa?=
 =?utf-8?B?RDgxN3RxWGtaOE5Fbkx6UWRObkVSOTl1MjZQLzlIYTdRcVNZYXhYUGtHWHlP?=
 =?utf-8?B?YktobWp1UTREaENQRWwzNW9GRFpxVTB5ZklhMGRvdTV6MlZmdkl0TUtBdTNj?=
 =?utf-8?B?aGVURzRWV1MrRks4Y0V5R2dmSm5iR2JkZWxEaURCNWNnUjN1Rjl5anJjYU85?=
 =?utf-8?B?Skd2TExzdnR1bVdHMzRRb0JHazIwV0E5Y1dGL3Aza1FIdmJTZzBQeFFjVko3?=
 =?utf-8?B?R0hMa3YvSTN5Vno0VUZFbndBdWZSR3FCQVNUckFmWWVjR3R6dVRBTENBMi9V?=
 =?utf-8?B?ektycCswdElmTS9uT2paU25YVFRVVmwwcXROaHVBeGdHalphanZjOUlNRC91?=
 =?utf-8?B?ZEpwbUdaWmpkT0ttS0QwVm14TXZSbVgrVjY4Uy9Kbjd1U3pqWE5tQXVYUC9q?=
 =?utf-8?B?c0R6bENiQWNLZ2E4SHBhbCs4MmQ4U1hmRnFSMitpQ0xHVENRSi9ickFYRXBh?=
 =?utf-8?B?NHF1U0ZpSWRZR3UvK2Nka2gvc0d2L0QwS2xlUjk1RUw0NU9tb1FhVWhub1pH?=
 =?utf-8?B?NnZmMFNtNmdYbzZxeDVLZTYzVVBDbndtRWlWcEViRkxnKzdncHg2aEpDcjFF?=
 =?utf-8?B?c1BmOU9JdWVGRWloSEhKT0IyU1RmaDcvY0JDbjNEcktXVVh4NnpaNG5EMWVW?=
 =?utf-8?B?QVViMG11aXNoLzgxajVDeWF5c3FVZlIyUU5MUVVWZHRSRTIxM2Mrb1VOdWFV?=
 =?utf-8?B?V1czbmorQ2xzMzBFdVp6anFaaTA3eGcwQ1hrWVc5TnZ6N0lOUE9sSjFBVmVO?=
 =?utf-8?B?c2NMSTl4V3R1Q3pVVlhLWWtlMHorU2MwQ3pWVDE0ODhjUlV6SmFxbVlDNHhT?=
 =?utf-8?B?SG5qYkdYbTFtUk5oSzUveS9semlQYVQ5T0tGc0krZlVaZHZiYk9UR3VIcXBz?=
 =?utf-8?B?V2xDcEoyekJzd1JLQVhBMldOMVhsSGQ3L1g4TGRlbnNLUGp3NFU4czlXbmtn?=
 =?utf-8?B?SEVXcnZXcXBvK2w0aC96bmtMS1hzV2xQaTRMOGw2YUZoeldObUFoanBaMXhH?=
 =?utf-8?B?MkFpMFpWaVBhSk9OcWZ2M3o2b2V3Vk51S253K1VLOG8ybjhNT29mWnpLV09K?=
 =?utf-8?B?b2tTKzk5OE05WEJ5bnNydkNhaDNZYnFCKzdZUU8xdkFtL3kvNVV2bUFCVzVI?=
 =?utf-8?B?a1puK1VQQWdwN0tmcmk5b1ZCM3Jmc0JwcHRPTFBzQ1RMQVRiVmR4Q2tmZTZx?=
 =?utf-8?B?RVlRVS9pYU4xTFVXZWUydzRldmkxNllZZWw5V2pLQlNIV2VpbU0yb2NzZEVL?=
 =?utf-8?B?RnNYNmJoOTZjamZua2k5SWR1ZVBZcGFkRi9Dd1dpa3BGSG83UzRuTWNtS1k2?=
 =?utf-8?B?VG05dDhjbXJzU21oclQralhSSndhWDJyNHF3LzB1KzR4Um5ObDd0TVIyVEt4?=
 =?utf-8?B?SGcrR1FiWUY5Lzk4aG5HN3lkMzN0cDgrRFpGNWxXZkozYzJsYUkwcUI5Z0Rj?=
 =?utf-8?B?ZDB1Y3lvUmNWUk5ZY0tYdGd2MFdLZTlmd29ZVVgyTlVkbzU2N2VGSFplcmlu?=
 =?utf-8?B?ZE1pa3M3aThrVC9KMThMSjdHS1BNOStBekp0bHBuQkRTMXEyQmRaUVc2WWNY?=
 =?utf-8?B?bHEwbC9SOFhSQm9LTWlQekgzQjdkc2NHQkhYUmZzbjBNOER4aXVrRWN1OW9j?=
 =?utf-8?B?Wm9Gb2FFTkYwY21qdm1EM2ZJLzI3dC9rUEZjTFAySHpjT3hZUFVWRnkwTzFK?=
 =?utf-8?B?RXlicG52UThkeWdLSEZ5ekYwMzdvbzBHMDdoV203c0JGUGxUU2QyK0tkQVN6?=
 =?utf-8?B?SDV6bDJRVS9tYjlNNDlNRXQ5TC9QdG9Rb24vYzJnTDF3VEZSUHJ4c0NJQXho?=
 =?utf-8?B?cmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <000FD4F85D56054984B2BFA482EF733A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56fa6c10-13c4-4fc0-8557-08ddb97ce07f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2025 15:26:54.9573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0xXkRng/3UKY6Je33aYLalnp3BN/oJJ5pwn+Fas32Pmnse3GvVuufkowoKrF9Kbb+iXnmNP3NemyPTJsjvx74v/vYJTrMzCUdn6UOYkvub8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6412
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA3LTAyIGF0IDA5OjA3ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBJ
IGRvbid0IHRoaW5rIGJlY2F1c2Ugc29tZSBjb2RlIG1pZ2h0IHJhY2UgaW4gdGhlIGZ1dHVyZSBp
cyBhIGdvb2QgcmVhc29uIHRvDQo+ID4gdGFrZSB0aGUgd3JpdGUgbG9jay4NCj4gDQo+IEkgc3Rp
bGwgcHJlZmVyIHRvIGhvbGQgd3JpdGUgbW11X2xvY2sgcmlnaHQgbm93Lg0KPiANCj4gT3RoZXJ3
aXNlLCB3ZSBhdCBsZWFzdCBuZWVkIHRvIGNvbnZlcnQgZGlzYWxsb3dfbHBhZ2UgdG8gYXRvbWlj
IHZhcmlhYmxlIGFuZA0KPiB1cGRhdGluZyBpdCB2aWEgYW4gYXRvbWljIHdheSwgZS5nLiBjbXB4
Y2hnLiANCj4gDQo+IHN0cnVjdCBrdm1fbHBhZ2VfaW5mbyB7DQo+IMKgwqDCoMKgwqDCoMKgIGlu
dCBkaXNhbGxvd19scGFnZTsNCj4gfTsNCg0KVGhpcyBzZWVtcyBsaWtlIGEgdmFsaWQgcmVhc29u
LiBJIHdhbnRlZCB0byBtYWtlIHN1cmUgdGhlcmUgd2FzIHNvbWUgcmVhc29uLA0KYmVzaWRlcyBp
dCBmZWVscyBzYWZlci4NCg==

