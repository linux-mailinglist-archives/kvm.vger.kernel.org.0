Return-Path: <kvm+bounces-62758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39DF8C4CFC2
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 11:21:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06893420930
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 10:08:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 334DB337B9E;
	Tue, 11 Nov 2025 10:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lcmp9KfY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFDE33859A;
	Tue, 11 Nov 2025 10:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762855614; cv=fail; b=dw6uEJR+PbCzorT/zOwOpEFiy+8PSJXYboPHfafmF0FJkIs3AXvLxppABb59h6M1GOKn9y+zwYoJmqx9rbNcyWG5zy/fOv7jAG3H5qKqFCo7obV/4ePI0BY3AICjelnsw2k/KawOWsJ6PmeXX5LmTcqO6ElU+QXXm2ul0FoHfOE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762855614; c=relaxed/simple;
	bh=/gAoGVhgI+ILWVp7CkNiTRR2onAgaaovKv6s3DHU9JU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rNQIBcdCxZUo8klmeghCg6JAccNBXBaPWoURsEmPOwwiyPTt+8ftskd3POt2mD3A1xCm2+gEk9wS6ybjkrLOcMMyed21/GexEIZFWEsjPsxJkfvH2FdsvXaK5Q4YJNGGiGTD+RkIRVdXpTA+4R5y9I9uhi3dGuePNjlaT7PoXf0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lcmp9KfY; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762855613; x=1794391613;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/gAoGVhgI+ILWVp7CkNiTRR2onAgaaovKv6s3DHU9JU=;
  b=Lcmp9KfYZyeXzm84wvS6X8ut0CczXkoK6Q844R6gCuguFUAI1KHT249g
   FbQ/+A4hrV1KbJ+E5Zf0hsxSUALoCVEjS9p/oEOwPjV6XhEmvwMNwJZH7
   reScv2ZGAKc8y9IVHqAd5JEUkhd+UqOELyDlH1sdRq5s/z9E16y5lHCrM
   reD/lKCrz4nuE0LpqkquZJR0fk/tMIa719rbuPicB2Ppfoms5QSBTDN++
   0x8Aa+wRV/8wS1/NQLDukG2BrCJ3GnzwT3npuTq/ZQ9oyrtMoYLvcdK83
   r/AKRfgj1eTc20HQipY2Z6NPFB62kFeNGD/M4Mw3jiF7bnNyPBjAwnvjX
   A==;
X-CSE-ConnectionGUID: gT5GdOPVTqqgqeR/4D+6bQ==
X-CSE-MsgGUID: EsoBJXdTRYyMSkqtlC8EdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="65006537"
X-IronPort-AV: E=Sophos;i="6.19,296,1754982000"; 
   d="scan'208";a="65006537"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 02:06:52 -0800
X-CSE-ConnectionGUID: 8JWXQaGkTf+F2/qIwOTz+Q==
X-CSE-MsgGUID: K3wNxhgcQq+F3ttO+RJWuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,296,1754982000"; 
   d="scan'208";a="188180744"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 02:06:50 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 02:06:50 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 11 Nov 2025 02:06:50 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.27) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 02:06:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K0hr0l9JH1iH/hXuAEOQYGEMY7wp7uGGv+1oyTHSkF3mU8s7n2N8VnqyBj/t8KDKzFu7AwKRBA/YZw0P4CAUuAsWwfBbLMd2sjxcC2628tZ9SuNzNXlcDdqhBcL6umv2J1S/Ws2VDwbviUaMdR1pAJZbY6vz8FUVd9ZD2QiTa4lW81Bcxk/9zFPUd0ftuHfwb+mDUYm0rxbpT5tENB0hCFamfnGH6sAAIiTxllOEEZje8+daCrazaRpf2iCPfFOiX8QzUPULPT+yn4mGUm3M4mLJwdWnOgsHutajkokonsuEG7BnmXQixsCFz+V3dYRAMJ4hNrAwLceCTtGecQF7rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/gAoGVhgI+ILWVp7CkNiTRR2onAgaaovKv6s3DHU9JU=;
 b=gzbSBHs6NFrlO9zhdzJYNFqxTvfb0wL4v6u6lskuAMyMn45o8HNQdattSl6TCuuHwnbIRJ6F6bSfr/lM+a8ilDRzYCRLaxTD8XfVewSVV3vh+1oN16XE1/7Qymo3Bmm2JXhLO23iEmlZLehBlb6CSPNw41y1PiZy6F9xiNMwdMDDSkftc8I7YCuUBKRcJiQeGni5AbBYVKhrWG4qOnd2EZoTy6gjb6KTqMdZJZw+euAAWv7b6KiTJo1sYwpBZXUehUfmCP0/LE/0Pg19yS8fi9iCQx8XRpWEWDjzOfzZ2/xJVfUoK0/LowHx74V3YD3kyKE9ZAMquO03F60cWh7GYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA2PR11MB4923.namprd11.prod.outlook.com (2603:10b6:806:fa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Tue, 11 Nov
 2025 10:06:47 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9320.013; Tue, 11 Nov 2025
 10:06:47 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "kas@kernel.org"
	<kas@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "zhiquan1.li@intel.com"
	<zhiquan1.li@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Miao, Jun"
	<jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>, "pgonda@google.com"
	<pgonda@google.com>
Subject: Re: [RFC PATCH v2 09/23] KVM: x86/tdp_mmu: Add split_external_spt
 hook called during write mmu_lock
Thread-Topic: [RFC PATCH v2 09/23] KVM: x86/tdp_mmu: Add split_external_spt
 hook called during write mmu_lock
Thread-Index: AQHcB3/i1yttwNhYOEKsT4w6b6GxpbTt1sQA
Date: Tue, 11 Nov 2025 10:06:47 +0000
Message-ID: <40651a97d837bc2f2e11c3d487edb4b4e3941a97.camel@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
	 <20250807094320.4565-1-yan.y.zhao@intel.com>
In-Reply-To: <20250807094320.4565-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA2PR11MB4923:EE_
x-ms-office365-filtering-correlation-id: b0f9dd85-d17e-489e-d7e2-08de210a0679
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?ZVB4aFpaSlR4alkzeWRubVFzMWhoYjFIdXZTZUZNamo0dzJKU3hkSVFHNXBp?=
 =?utf-8?B?ZWJtdVU3S0dKdlVxbnhVQllDSmo4bEVCWkxnZGVBQm1yM2JwNG9jK1c2Sndw?=
 =?utf-8?B?VXhhb3ltUGNzS0ttYzlRZnVFd0RxcGdGQ0lFVWZRQldlUGMzY2tSd2VOdWJZ?=
 =?utf-8?B?YkkyWUgweTlCRnJ3MW5uYUZlUys0UmRvTGlYRE9Ba2hqOGp0K3FudDJsWkRk?=
 =?utf-8?B?WWpEM005c1hjb2d1SE51akVkcU11TlZjKzdKZ0tCVzdNNTBCb0RySDBpdkZm?=
 =?utf-8?B?YTVvUlZvTlB1QUI1V2RzdllabEdhOUNqSHR4TUtTaGFYdm9aT2duazZrZ1dy?=
 =?utf-8?B?MEMvSGcrU0QvOW9wN2pIaVBobWlvQ3V2N2V5WXpUeGpBSkZFSUZ0dXh1R0E5?=
 =?utf-8?B?UCs5d0pJYWIzT2hZcnpWVXQyMjFuZkNKVVdHUzNCcEMwOHpWaGVrQ3ZvYlNT?=
 =?utf-8?B?a3g5Vi8wVVJPNmVGbml1M0ZEWExIUUkwcXU5MVMra0QzQUh6VmNhNnNQMjdj?=
 =?utf-8?B?SjI3b3dFUmR3RFJvWDd4eVp5NVJsRWlvZlc1T0ZWR2ljdzlDSmZZaUJqclRM?=
 =?utf-8?B?N2lGOE1RUm1zWmp6QXNPWVZxQitHK0NZdWhTS05nRVpXa09QQkJYcHd1aXlj?=
 =?utf-8?B?TnNFSktodVY5Nno0NmRzbEFTanN5ZXFGZkxUSGdjUW9ZQk5NN2YvblRiRVF0?=
 =?utf-8?B?SXZTWVFURnBFejFVaE1wR3pQejRKT3g0WGNsaXJSSEhkZjZFSTBZRkRrR3R1?=
 =?utf-8?B?WHZLWkVtVmlqc0N3bW5kODVrTWxmcFJwZUlIVkFFVlYzWGYyL0pHVHRqYm1n?=
 =?utf-8?B?V0J5Y0FaNXpRMVBvTWFDRUNVcUdPWnZPNUlISVRWZXJSSkdwd3pzd0dnRTRq?=
 =?utf-8?B?SGplbEpkK3FkdUYyOVV0cHh6S1JxUWJPZFFZblNRVmRvd0xCd09ML1FJa0gr?=
 =?utf-8?B?YVMxeS9aZHp6NjltZmNJTDdiOG42MXBEdWl1ZXg1SEJMd25Bc0hVRWhuRks5?=
 =?utf-8?B?ZWY2STdCQmJ4N3dJZ3FjSHEvMmJZdUF2aEtUK0x3UElLK0FjY2RiTVJnNzZo?=
 =?utf-8?B?Nkd5Zzg2WG10eEtWKzB3SXc4VzdKaG9GRGlPeW0rQjRxZnFmWUFhaDZnUVp0?=
 =?utf-8?B?UHRpT2dZbmxtWGRUUnFQcGlmdi85ajdxN2lLa0dncmRjcFBONlRYZFRGOG5H?=
 =?utf-8?B?dUhvRm9UTWNya29EY3RWdERQR2F0c05ySWFVTjcyczgyaVU1ckR4ZnhGZjRk?=
 =?utf-8?B?Q1pHLzRnQUJ3MFJDSUVCVUhRZGl2Z2c4OU9uS3hyRTBubHR4Ulc1cjV0ajNT?=
 =?utf-8?B?UUc0bU53Sjh0Y05lajVtajFmUDkvMXRENnphRTVIZUVlODh1ZlhKWkJaZ1NQ?=
 =?utf-8?B?N2E4aEcxS1lldTFZSk1HcHpZaUhITUM4UnJZbkZqVXhKL0p4VnRTNGliWHNL?=
 =?utf-8?B?ZlVETmlUajZsbkRBdUF1cUxvd1NFTG40ZUlWZFpyM1hweUJIdDF0MXRqeE5V?=
 =?utf-8?B?bFR4Y2tNZVdpRERQalRoei8wd2c4aWRjcnpPME9uRUthbUF0RjlJRVRIczc0?=
 =?utf-8?B?Z2ZsbFU5MGxtSDFFbHhiOEpUMFFwT08wbE4xdENrMjJFMG5ZSHhreVRPUEd3?=
 =?utf-8?B?N0F2cm9oUFlJT3NlMHBUekpGM2EzQlhlYXNrb1ZWSlFHRzZuMzZkR3haWjZw?=
 =?utf-8?B?UDlVTkY2YUE1T0pNaFZaUys0NndXSGt6MG9VY2tFSXJpT1k3dTZEQnB5RmtB?=
 =?utf-8?B?a1RDQU5HWHpvVEJ2b1lvZmdRUTc4U01YcHFsaG1yN3ppYlIxblMyTzFBUmdG?=
 =?utf-8?B?bjVxTTNzVWQvZWhJczRROU10cEdsK3JsbThaZjF6K0UwVjRrOXovQkgzbE1K?=
 =?utf-8?B?aTdZWnhEaVU5RUlMZnkrdHJRMUhjY1dKNnltRnRIYXAvN1pIQjJKUGk0SGQz?=
 =?utf-8?B?YVNJR3hQSmxaSzNPZHg4OFZHN3FuU1grVndwNThhWDJqblZORFY0cW9UMjZs?=
 =?utf-8?B?SktQWUNiT3dRL1o5U1V4eFZYNXgrMkVhRlZua2ZsR3hNdXVJSXdVN3ZIa3Nx?=
 =?utf-8?Q?ggrv44?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZmVJZTZXTDVVRkxqVDFTa1E5Q1pwdThLbGxsc05MdzFUSS9WN2l4SXc5bGlp?=
 =?utf-8?B?OEt2aFlaMzlZK280VzFMbTFZU2xobW96b0czVmExMmxTeUZqUjRSUW0rbEw0?=
 =?utf-8?B?bTZSMURPQmhoN3gxbnJubDhPQTJINEtqUlA3bm9saSthdzBXT1ZORzRoMDVE?=
 =?utf-8?B?V3NzUWV3U1BlWGk4U1VGSjJ4Z2lsbmZDUm9pdlNCZWhPdnM4dldkYmgzUENp?=
 =?utf-8?B?WTNKMi9BMzFCaHZ6b01EQlVTUG5ySkhUTmpSYlVEdTBVODVwL3ZzVkFMM3Vl?=
 =?utf-8?B?aWY3bVRpbE1xRW1QY0NVVWp0UGlIYkEwdFJaVURnemkyb2lIZ3VlMHAxK3dl?=
 =?utf-8?B?YlZRbm5DNmtmWU1zdlU3RWpPVFF0WVZjeWhRMXEvTnFOU1FnalhibzRNajM1?=
 =?utf-8?B?Q3JkV1ZnOVd0VkpoYXVYWXd1OGJ5RGk2cmhrNHVoYWkzMm9CakhZOGtENDBq?=
 =?utf-8?B?cWRCNkFIZDc1UkdyK1BDQ0psZC9IN1ZaREs0eW83alpxRjZNSjFuU1k3L2Fm?=
 =?utf-8?B?eC8wblZDcWFMVDQ3dExOSU9CMW5EelRmM3g5alpUcHRVYWFyeG1sZGxXbmtL?=
 =?utf-8?B?emFJNmg0V2NmK3MxKy8rN3F5WFpsd1loQkhWS0plQVBueCszNHFMQ3pNQXJC?=
 =?utf-8?B?VHlldGRYVkllKzJUSERpdXFLVkUrZGo2STJFWWRCNHdoQVgybStOVTMxQ0Vj?=
 =?utf-8?B?ekErNWhiVkpha1QrcGhYVUtDbUEzWlAxVXJNQnkzSERkcVlEdmExNGw2NU5w?=
 =?utf-8?B?ZlVHc01IMFFJLy94TEJmU1poNitTUzk0WkJLM2F3Z2ozWXVzK3IrdzJERlNG?=
 =?utf-8?B?OTFwNkhkRDcrRG9tbG5VcVVyY0trcytzU1J0SFNGbDBVdndSTVRQSW9PcytM?=
 =?utf-8?B?ZFVtUXkzam00UTRrenRNTjRUNENIMlpRemtBTlpFbDNyMUhsY2M3UkdjTXpW?=
 =?utf-8?B?TURESHlJOGZjWm0zUFBCd0pQT25wR2tmTGRzalh3UW9tYjIzb24rVC9pb0cz?=
 =?utf-8?B?Sk5UMTUycDVTWUljVzE0SmQ2ZW1NblpOSDY2WFlseHpIV3VOY1d5VkxHT3Jx?=
 =?utf-8?B?V1AwTWpkSW1WQS9RZ0x5dTlFcnFPdnZsTjNJK2EvR3YyeklRZnRPNC9uU2gx?=
 =?utf-8?B?QWk0SVdPdEhUaUtXc3dBa2I2clpYVS9MdHNrZHBHbk5Gc2dpZDJYd25ZT0Jw?=
 =?utf-8?B?ak5jN24vaHhGYVlGQTJ2Tm55cjYrU0huL0dWSmRpc3g1NEgvN0ZJM1h2VEJB?=
 =?utf-8?B?TkR1YU9RUlMrVmhLd0lLZ2F5b0ZWK2xqNWt4aFAyRzZXVWlmRkROYS96alli?=
 =?utf-8?B?b0hQaFprTFlzNW1udGZFaUdlZndQT2tvNmJGL2RKT3QyK0F5T253ZW5VcFU1?=
 =?utf-8?B?WmZWNGFpdzRUeDVmTEFCbnFaa01LT1BXWGNNN0ZCYmFzYjlBdVRlMmhOSjlx?=
 =?utf-8?B?RFpnTzVQRWVsZmNJWDhYc0JkeDcvUFIxTkVrOGsxVDZmWllTVXM2S1k0NFkr?=
 =?utf-8?B?OE1yUHhmTnhYalNnTldBeTJxekpOakNZNnVkKytTSEpYM1lnY2tHajljUXJB?=
 =?utf-8?B?bnk2a0I5V3N1bW1IQVRNWGtrM2U4dDdqMUpFM2ZBcnVzRWRDcWVoVVZqSFZi?=
 =?utf-8?B?cFJ4L1NJU2NOc2Vtcm95SDdEc0pRZzc4R3htUTJmamNWbERRSmFoUThydEJa?=
 =?utf-8?B?VFBla2VBL0EwZ1VjZjc5bUF2SFNiSTZaNEpIb0IyTGZqblhMSTZZUVBIMFhV?=
 =?utf-8?B?bjFibWxLYTh3c2Z4ckJwNm5xMDdJbGQxNkJUNkFoUVhZOGVHcWJuQ3oxRC9H?=
 =?utf-8?B?Qk4wYUl5a2p4K1E3ei81ZTJOOXJtS1hWUFhtbU4xN2ttRmcybE1MRXdwaDQ4?=
 =?utf-8?B?TEgyY3I4TG5md251QVcxanZaSnFMaUtXSCtRRXNJUnB3a1FpblM3TkRDRURn?=
 =?utf-8?B?RjR0V3RoQURycXFzb1FDMzlKWW9RQ0FOejkwaW8zd1hKZGREMWN2WmpNbjRH?=
 =?utf-8?B?d0phTUo0dXIvOWlZdUh3NXJDa3NkWWk1RHQvVCtxQ1JaejhCQVFXc2ZNdngx?=
 =?utf-8?B?THF0ODFSWlZmc2xtdHlnWTZpOUFRVFVNbmRSWDRIUmwrQlhOd1B3VUhlYThj?=
 =?utf-8?Q?ipN02jlDeh+Jyzg5JO4tOcD48?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7590A309F27BBC44803C53D98A70F36C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0f9dd85-d17e-489e-d7e2-08de210a0679
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2025 10:06:47.5026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CndLAIgaL88iQqz/hPWb5C7khxM5YSW21zalh4JJACbEDo2VHvHH4ox28Dq1bxvQ7egpFHzSDKW8SDaVueJQgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4923
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTA3IGF0IDE3OjQzICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gSW50
cm9kdWNlIHRoZSBzcGxpdF9leHRlcm5hbF9zcHQgaG9vayBhbmQgY2FsbCBpdCB3aXRoaW4gdGRw
X21tdV9zZXRfc3B0ZSgpDQo+IGZvciB0aGUgbWlycm9yIHBhZ2UgdGFibGUuDQoNCk5pdDogSSB0
aGluayB5b3UgbmVlZCB0byB1c2Ugc3BsaXRfZXh0ZXJuYWxfc3B0KCkgc2luY2UgaXQncyBhIGZ1
bmN0aW9uLA0KZXZlbiB5b3UgYWxyZWFkeSBtZW50aW9uZWQgaXQgaXMgYSBob29rLg0KDQo+IA0K
PiB0ZHBfbW11X3NldF9zcHRlKCkgaXMgaW52b2tlZCBmb3IgU1BURSB0cmFuc2l0aW9ucyB1bmRl
ciB3cml0ZSBtbXVfbG9jay4NCj4gRm9yIHRoZSBtaXJyb3IgcGFnZSB0YWJsZSwgaW4gYWRkaXRp
b24gdG8gdGhlIHZhbGlkIHRyYW5zaXRpb25zIGZyb20gYQ0KPiBzaGFkb3ctcHJlc2VudCBlbnRy
eSB0byAhc2hhZG93LXByZXNlbnQgZW50cnksIGludHJvZHVjZSBhIG5ldyB2YWxpZA0KPiB0cmFu
c2l0aW9uIGNhc2UgZm9yIHNwbGl0dGluZyBhbmQgcHJvcGFnYXRlIHRoZSB0cmFuc2l0aW9uIHRv
IHRoZSBleHRlcm5hbA0KPiBwYWdlIHRhYmxlIHZpYSB0aGUgaG9vayBzcGxpdF9leHRlcm5hbF9z
cHQuDQoNCkRpdHRvOiBzcGxpdF9leHRlcm5hbF9zcHQoKQ0KDQoNClsuLi5dDQoNCj4gIHN0YXRp
YyBzdHJ1Y3Qga3ZtX21tdV9wYWdlICp0ZHBfbW11X2FsbG9jX3NwX2Zvcl9zcGxpdChib29sIG1p
cnJvcik7DQo+ICtzdGF0aWMgdm9pZCAqZ2V0X2V4dGVybmFsX3NwdChnZm5fdCBnZm4sIHU2NCBu
ZXdfc3B0ZSwgaW50IGxldmVsKTsNCg0KSXMgaXQgcG9zc2libGUgdG8gZ2V0IHJpZCBvZiBzdWNo
IGRlY2xhcmF0aW9ucywgZS5nLiwgYnkgLi4uDQoNCj4gIA0KPiAgc3RhdGljIHZvaWQgdGRwX2Fj
Y291bnRfbW11X3BhZ2Uoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qga3ZtX21tdV9wYWdlICpzcCkN
Cj4gIHsNCj4gQEAgLTM4NCw2ICszODUsMTggQEAgc3RhdGljIHZvaWQgcmVtb3ZlX2V4dGVybmFs
X3NwdGUoc3RydWN0IGt2bSAqa3ZtLCBnZm5fdCBnZm4sIHU2NCBvbGRfc3B0ZSwNCj4gIAlLVk1f
QlVHX09OKHJldCwga3ZtKTsNCj4gIH0NCj4gIA0KPiArc3RhdGljIGludCBzcGxpdF9leHRlcm5h
bF9zcHQoc3RydWN0IGt2bSAqa3ZtLCBnZm5fdCBnZm4sIHU2NCBvbGRfc3B0ZSwNCj4gKwkJCSAg
ICAgIHU2NCBuZXdfc3B0ZSwgaW50IGxldmVsKQ0KPiArew0KPiArCXZvaWQgKmV4dGVybmFsX3Nw
dCA9IGdldF9leHRlcm5hbF9zcHQoZ2ZuLCBuZXdfc3B0ZSwgbGV2ZWwpOw0KPiArCWludCByZXQ7
DQo+ICsNCj4gKwlLVk1fQlVHX09OKCFleHRlcm5hbF9zcHQsIGt2bSk7DQo+ICsNCj4gKwlyZXQg
PSBrdm1feDg2X2NhbGwoc3BsaXRfZXh0ZXJuYWxfc3B0KShrdm0sIGdmbiwgbGV2ZWwsIGV4dGVy
bmFsX3NwdCk7DQo+ICsNCj4gKwlyZXR1cm4gcmV0Ow0KPiArfQ0KDQouLi4gbW92aW5nIHNwbGl0
X2V4dGVybmFsX3NwdCgpIHNvbWV3aGVyZSBlbHNlLCBlLmcuLCBhZnRlcg0Kc2V0X2V4dGVybmFs
X3NwdGVfcHJlc2VudCgpICh3aGljaCBjYWxscyBnZXRfZXh0ZXJuYWxfc3B0KCkpPw0KDQpTaW5j
ZSAuLi4NCg0KPiAgLyoqDQo+ICAgKiBoYW5kbGVfcmVtb3ZlZF9wdCgpIC0gaGFuZGxlIGEgcGFn
ZSB0YWJsZSByZW1vdmVkIGZyb20gdGhlIFREUCBzdHJ1Y3R1cmUNCj4gICAqDQo+IEBAIC03NjUs
MTIgKzc3OCwyMCBAQCBzdGF0aWMgdTY0IHRkcF9tbXVfc2V0X3NwdGUoc3RydWN0IGt2bSAqa3Zt
LCBpbnQgYXNfaWQsIHRkcF9wdGVwX3Qgc3B0ZXAsDQo+ICAJaGFuZGxlX2NoYW5nZWRfc3B0ZShr
dm0sIGFzX2lkLCBnZm4sIG9sZF9zcHRlLCBuZXdfc3B0ZSwgbGV2ZWwsIGZhbHNlKTsNCj4gIA0K
PiAgCS8qDQo+IC0JICogVXNlcnMgdGhhdCBkbyBub24tYXRvbWljIHNldHRpbmcgb2YgUFRFcyBk
b24ndCBvcGVyYXRlIG9uIG1pcnJvcg0KPiAtCSAqIHJvb3RzLCBzbyBkb24ndCBoYW5kbGUgaXQg
YW5kIGJ1ZyB0aGUgVk0gaWYgaXQncyBzZWVuLg0KPiArCSAqIFByb3BhZ2F0ZSBjaGFuZ2VzIG9m
IFNQVEUgdG8gdGhlIGV4dGVybmFsIHBhZ2UgdGFibGUgdW5kZXIgd3JpdGUNCj4gKwkgKiBtbXVf
bG9jay4NCj4gKwkgKiBDdXJyZW50IHZhbGlkIHRyYW5zaXRpb25zOg0KPiArCSAqIC0gcHJlc2Vu
dCBsZWFmIHRvICFwcmVzZW50Lg0KPiArCSAqIC0gcHJlc2VudCBub24tbGVhZiB0byAhcHJlc2Vu
dC4NCj4gKwkgKiAtIHByZXNlbnQgbGVhZiB0byBwcmVzZW50IG5vbi1sZWFmIChzcGxpdHRpbmcp
DQo+ICAJICovDQo+ICAJaWYgKGlzX21pcnJvcl9zcHRlcChzcHRlcCkpIHsNCj4gLQkJS1ZNX0JV
R19PTihpc19zaGFkb3dfcHJlc2VudF9wdGUobmV3X3NwdGUpLCBrdm0pOw0KPiAtCQlyZW1vdmVf
ZXh0ZXJuYWxfc3B0ZShrdm0sIGdmbiwgb2xkX3NwdGUsIGxldmVsKTsNCj4gKwkJaWYgKCFpc19z
aGFkb3dfcHJlc2VudF9wdGUobmV3X3NwdGUpKQ0KPiArCQkJcmVtb3ZlX2V4dGVybmFsX3NwdGUo
a3ZtLCBnZm4sIG9sZF9zcHRlLCBsZXZlbCk7DQo+ICsJCWVsc2UgaWYgKGlzX2xhc3Rfc3B0ZShv
bGRfc3B0ZSwgbGV2ZWwpICYmICFpc19sYXN0X3NwdGUobmV3X3NwdGUsIGxldmVsKSkNCj4gKwkJ
CXNwbGl0X2V4dGVybmFsX3NwdChrdm0sIGdmbiwgb2xkX3NwdGUsIG5ld19zcHRlLCBsZXZlbCk7
DQo+ICsJCWVsc2UNCj4gKwkJCUtWTV9CVUdfT04oMSwga3ZtKTsNCj4gIAl9DQo+IA0KDQouLi4g
c3BsaXRfZXh0ZXJuYWxfc3B0KCkgaXMgb25seSBjYWxsZWQgaGVyZSBpbiB0ZHBfbW11X3NldF9z
cHRlKCkgd2hpY2ggaXMNCndheSBhZnRlciBzZXRfZXh0ZXJuYWxfc3B0ZV9wcmVzZW50KCkgQUZB
SUNULg0K

