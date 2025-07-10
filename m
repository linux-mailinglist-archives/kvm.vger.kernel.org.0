Return-Path: <kvm+bounces-52009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ECCF7AFF66E
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 03:34:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40A555A1E47
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 01:34:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C50427EFEE;
	Thu, 10 Jul 2025 01:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WbyIzU3b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5138623B62C;
	Thu, 10 Jul 2025 01:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752111263; cv=fail; b=LpjK7lx5qxqRQagsAiQU6glrTLdV60Uetfi76pCETcMDpTvVX/ipl3RkJVRxZ4p/ZyCWAl4r+j3Nymkw04n3bA+YBmHdCAvObNTe1K0gBKOYHveuXVdL0AXWshAzHn9tmvb3wNiGrS7HSwz9NKnzJbiM6QGCCPVJ2CaeddfeSPg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752111263; c=relaxed/simple;
	bh=aa8Z7AaAjwR37KFP1HIQTWKYs/TGtb1XDCLSov3JppA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FgJJWk3EWZ+XTDuSXQKmEWKX6o896crmUqM2vsOsPT26rp0B6LwvQsjukTP6JmyXP56DPTMEpN5GGLGsumoP9FqNq0fgysqMViDtbxBljip0h/GBmGG5R5j+IEx58I1l2l3VK7LEsCTnUBJ/3isLol9pLbldl+Z32lgLjnPi7es=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WbyIzU3b; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752111263; x=1783647263;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=aa8Z7AaAjwR37KFP1HIQTWKYs/TGtb1XDCLSov3JppA=;
  b=WbyIzU3bQBe31hACNprHjSH8t3MXOiguUvFHG8jKOrfQOC4n+Vct68Ov
   RCKebQy1qKU/uOT8P6K1H8lD5S68t1eOW4uKDEQTq3dWnPKYtJ8RglaVM
   Fs7z1ER36hSK1R8vs1vxJHM+9Nv4g2+5NbQfTK3L9BtF6BptxYd+S860d
   rCBq+fBs1Gg4bu3UcLXqtm5II4O9PHD1e2hsOTVaQWys2Kzd3F0L2lpIj
   h40ZExdZNZVhnzk751zk+Z9WjnYvRpUoOuzjnlUIH/mkthG1IxwvjpWCW
   QzEeRQ+zrs2EwGNHlw7nC9QP1e5J06UbmCTsw0eIsNonNm8s+5TIsWDmR
   Q==;
X-CSE-ConnectionGUID: lJWAto67S826qZV4f+w9Tw==
X-CSE-MsgGUID: PMipBie7QyisIJS+u7h/1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="54103541"
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="54103541"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 18:34:22 -0700
X-CSE-ConnectionGUID: mmjZfavwS+myf73WGQoi2Q==
X-CSE-MsgGUID: SdVc5YGNQ62qhGqlBesGcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="193137988"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 18:34:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 18:34:21 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 9 Jul 2025 18:34:21 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.63) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 18:34:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u74o+bi8XOaSU/MmNuJmnZ3r/3UokEZg6RO0nGhRQpZ1kC4fk0Z7isUf3Dv3u6YdYZ4u8rxbpMnec3I4xg7unL8ycheha1TgNtkaUPo7u7+9P49j14YvEZClIiPIU3kUujb69ge791p71zaLSKUfqOxlBsrQIZ0prpKyVS//ivpQ6J3Opit8sTxmBmI92TLaTz3k4/LbhhsGwLUrLgnHMtF7KLucIO4Dqf9R4FiC8aAFoRbHCUn5Na5sZ6eQiub55yz6kEY0lrzcMII1aWj7Qw1wZjabw6QZdJ7rdqnwFeZ+ZQc+zy/PAC+JcN6K0oU+6jJzKVKR+liELEY5SEVEvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aa8Z7AaAjwR37KFP1HIQTWKYs/TGtb1XDCLSov3JppA=;
 b=p9DOFcyIL2eY60npOTFdQS8wdTdcX1fpPlMA8uvVP745BQmX8PiFls/0KBBf4Qlmb/RFLB/bNjj8Mc2tfdbM2PHUEdxfOpZ7uZtb1tww1+0P3yyOi4TIt/cPgGQa5/4qjmsObZtF7lGeqozNGg7R4S6ZagKNsEkOTFCgNAawaBP0poUX+DRr/Ww2ao27elt9yYF1Tre1phDFbweFIU0WFYoi8HGwH2Ptk3eXoCPm2aI1Np4Dg79ToL7ZkkIM/AlfoXy06H6mKsbJLM7Hjj1asxhGLU+A84Wc+SbVt3iBSMKKjhdWHRVniZDyNvNIyaToi4uiII3WhpwN7FojTcezHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB8155.namprd11.prod.outlook.com (2603:10b6:610:164::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Thu, 10 Jul
 2025 01:34:19 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.028; Thu, 10 Jul 2025
 01:34:19 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Huang,
 Kai" <kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 07/12] KVM: TDX: Preallocate PAMT pages to be used in
 page fault path
Thread-Topic: [PATCHv2 07/12] KVM: TDX: Preallocate PAMT pages to be used in
 page fault path
Thread-Index: AQHb2XK5z3pqTmviV0GHU4wZL5yIRLQqwpsA
Date: Thu, 10 Jul 2025 01:34:19 +0000
Message-ID: <f58bca0331f3ba0bcd55d68f86c2563e6aa70747.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
	 <20250609191340.2051741-8-kirill.shutemov@linux.intel.com>
In-Reply-To: <20250609191340.2051741-8-kirill.shutemov@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB8155:EE_
x-ms-office365-filtering-correlation-id: 54f31837-de08-4470-c9a7-08ddbf51e3fb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?M1h3M0lwQzh0aXdweFQyZUZFYmQwM0hjSnBYT05LS0NsM2w1eC9LOHpCNnhR?=
 =?utf-8?B?VmlxNGtzSzMyNEdyNUhFZEQ2VE16NjM1ZUN2dFpsaFFhQ0pBZWEremtOWC84?=
 =?utf-8?B?b2RFK2xzdlZpMkZydTlPV0Z0OUovaXdmMEhQM3RveUpURXpKYlg2YW81bDAw?=
 =?utf-8?B?RGIyTmxVdnFJbXorU1pRUVFCRzRyQnRUYnRpVVViUUhZVU13eGhGVHlFZVpH?=
 =?utf-8?B?VWkyaEF0UlZIbGFISUhCMVA1eXIwM2lGMTVwVk9oV2tkUFJyY09EVjJ6WW16?=
 =?utf-8?B?Z2ZBcVVydzlsSXdxZFpJMGE3NzJvOXBWbEN5dEppNkU1RTBCSm9yd1MzVnRP?=
 =?utf-8?B?ZFZoL3B5UENjZGhibEN6aFB1QTlEMTVySEhyVnJiL3hwT2FEcHNSNklZRU9M?=
 =?utf-8?B?ZytMQWVIK21lcWhOanpwRE1YeUNLUkhtcCtuYUFDUkVRTTBaWXdHVUJqcmh3?=
 =?utf-8?B?Q3pHTUJaekdrSHd4akpIbTZUYWFob0QyRzRGTkxkRW53OEszMXZLc2FZUHhY?=
 =?utf-8?B?WHRHWFBpY3FySjk1T1pZTHUvdWVVZGNRSE1XcFhvSTBxcDV0N21idUo3akls?=
 =?utf-8?B?UElRSExkWXNtOFNVejFJOUtkaDdZQVA0SUxucjR5MnpnTEhYK2RwakxGWlNv?=
 =?utf-8?B?WElTNWh2SkVWcFFwUnRTM1NBbGZ0ekY3R1BsQi9iZlZGS2VqNk1GS1BWampQ?=
 =?utf-8?B?eUpwWkY3RmE2SEl0elJpYnRwODNCNmxWc21RZm9nL3lFV0xYMCtYTWEzL1Q3?=
 =?utf-8?B?bGRYRHltdHZ4MWVHeXZuZitGeCthZ1p0NFFTV1BYS05DOEFDT3JTM1NtbXJl?=
 =?utf-8?B?aWhnTG8yUTdSM2h0RE5jWFpNSGh2NmdsVlhYcUN6RnRTSFM2Vm9wOVdnZmIx?=
 =?utf-8?B?NHhITkw0NEY3aVVyeWJ6Q2RLY2pDdlF1VEZNc0ZyNUtpRDZ6SGQ5M1RNd0NV?=
 =?utf-8?B?OVJmV0MvV09oYmFXSzJnaUYxalRKT0FGZ3dNWjNZUk9qMUdHbTVDNUlkL1hS?=
 =?utf-8?B?YzVkQnlZaTRZb202eHIrRnB4ZnhjUE9lUnBFeWxNY1ZxRHJnb3NDeWhSdDZu?=
 =?utf-8?B?N1l4ZitiMGtmUFBxQ3huT3hCblNRejQvcmQ3bURnNmd0TWk2dUhmSlNXSmow?=
 =?utf-8?B?WEdmT3dMTldLN3NzV0FKc1pmckFRSzYwckg1cWpSeVdFVGQzUDAvdUJ5elcx?=
 =?utf-8?B?WEFtVUpMV1lUSi9HUHlPVjRIV2lTWW41TkZXeGtyVVAyQVVqc3JFYWtJSHl1?=
 =?utf-8?B?THNjOUxZODdpb1NxTVpPZ015SFFHZUUycGRQOTJ2c0MwSytrV1BFM1hVa2RI?=
 =?utf-8?B?aWtSR1I0Z0pId0VNSTBoZDVzVWNSeWYzZHdJdTRQZ3lDZ1Z6L1I3TEVndUZC?=
 =?utf-8?B?aXVTVWtJa1lYVDFNSDcvZ1JnMlpJQS8rS1dzVHkrQzFheGtNVlU2ZFBrdnk5?=
 =?utf-8?B?b21lbDN5b2ZVNHNYWFlhU1l1WCs2RHorbm1COFRPS0FkMTBHbE02WnhESXRV?=
 =?utf-8?B?dlBtUllEanh3cFVZN0JNNWFqdVhqaXJtcVlta2pnS0ZQTXpUdVpWMUR1V1ZZ?=
 =?utf-8?B?ZFBKa29BQ0ZPRXovNVNJaVZJMU9zQi9qeGU1dzVTWXZ6SmpJZXFjMDUzckto?=
 =?utf-8?B?K2tZNXo2STB4SkNsS05oMHJlNFhLZXAvYXdkOE1Zekc0Nms1N2NqcEIycjlN?=
 =?utf-8?B?ZVo0V1dQa2lFS1ozVTVVY1Z4MU5EZkpPSFdnQ1JVekpVSktuOVcxVGNpbXMy?=
 =?utf-8?B?d0FRZnF4a0ZLNi9hVFVKa09tL2o2YnV4ZThUdFRucElVbzJtWmx6UXdqdzRi?=
 =?utf-8?B?TjQ2TDNvckxrcnhKcGxieHhpQzF1Tndra1JQSnNrRC9jMnpqUlowZHdZbzRv?=
 =?utf-8?B?NVIyMWVKZHZiOFVGalAwdlp6QVZXN0NUUVV5b3lhQVBFellqWFd3SnFBY3dM?=
 =?utf-8?B?bFE5Y3hvODRqMVpQN3prYmhLL09VRXIvOFdEQ2orYzFOSWc0bTJ0NEtKTEZm?=
 =?utf-8?Q?6XB2QZlUCKt12H+MX9EUV50qlmep8A=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TW1VcXduKzdCN0pGQUU4elgyT3F5VmxZTEZQOU9LS2srcXVnSWU0Zmsyb0Ja?=
 =?utf-8?B?Z2Q3RTQyeTZ0ZnI2UnFhQjJEc200MzRRT3MzSmlrRFp4cUlZUVoxZlduUFli?=
 =?utf-8?B?UDFNWW4wVWhXelFKMzhTZSsxU2lFa0lkU0pYZFphNlhZZ3pWbXJ5VDdod2RN?=
 =?utf-8?B?WXpRNDZqdDZhM3cwWjlCbmJjVjIzMGRvbzFtbHV1Zzh2WC9WbjBEL3I4QzNu?=
 =?utf-8?B?MmN0WGxHaUsyRGJIQ1hlcXFhdEc5WlJDMUQ1ZDRHNEhZUE04aTZZOWo0Y2ZC?=
 =?utf-8?B?dk8vTEUrK1U0ZzdBVUphK1RFd2prL0pXV1RkV2FXM2thZWJrUllrbnNQM1M3?=
 =?utf-8?B?L3NkTVJLakZqNUMzOTFFdTdlTGN3d045dDA5ZnBGS3BZVVZ2b25sMENEVFZR?=
 =?utf-8?B?dFRxTVVpUGpkbTNuZnlpVWFjVWVPK3JPaEY2VEJSV01JQWY3QTkwaHhaQUda?=
 =?utf-8?B?c1pyZzdPNFpvRGVSSkVMaVQvNnFGeTZlNm9VcFNvZm5xL204RVNoRTRTbzJW?=
 =?utf-8?B?UHRTSnhQRG1sb0dTMU16T0prL0NrWE1aajBJZC9ydFlxL2VNR2dKMk43ZGNs?=
 =?utf-8?B?eHAyaGxzTS9ZT0JDYVFIREIrQ2RJYVBwSnRFalZZdlc0Nk55cTBjYm1meHFK?=
 =?utf-8?B?Q05BQktoU0lxUnNPc3hGUk9odHR5elJUdGtnLzJJNmdLREcwb0lwZmFyTFFB?=
 =?utf-8?B?K0FQYkNxMHJYU3U5MVVEQVFVZ1Nra0NlQSszc1c0Skc4ZG44TWozQ2VkdUNx?=
 =?utf-8?B?VjFhWTRnUXpCNDRIb1ZCZEovVDJ4dm1rRlE2aSsxN1lidUxZelVZZVFuYXB4?=
 =?utf-8?B?anM1T3l6VS9tQjYxZ29mU3ZPYnZ4SUE0aGJsWHd3K2FJblhLNzdJeHlTajRj?=
 =?utf-8?B?eHBuTnVHbzlFNjJWSGUrcGFvd1N4QUFmeTlRa2htRU9IdHQ1YlhXUXlmbWdV?=
 =?utf-8?B?YlN6QVlFNUFTalNMVVFOR2tpMktCcUFVM280QzJnTzV5bjVzZitoL3ZBRzVE?=
 =?utf-8?B?K3FkczN2MW1JbmRzSDQrdW9reW1QMDV3Q2lLQnVnN3lFRGY3NGJSMlhpQmk1?=
 =?utf-8?B?OFc0V3NzcHYxblYvSFQrT3IydElNODFBdWNkdjlab1Y1N1JkQThTM1IxL3NV?=
 =?utf-8?B?d3Z2OHRXb1ZMd2RPaytteFNsdDRUWExmNWRyb2owN1ZqYTdHaWcwZkNpUjFD?=
 =?utf-8?B?eTRUbjhTTkoxNlQwQmJpaFp4aHlyTk9ON05MWEFDMS9hc051SHY0OHFRRmZ3?=
 =?utf-8?B?QzU2TXpkYWkyRWdobkdJU3ZodVgvNEUxTzhTNlVWTmVmU2hFOHo0cWo4NlRa?=
 =?utf-8?B?NEF3ZVlJVWlVRWxhUHhnSWhHVFFHd0FoQVduWjlTQ2tuVW43MUVMQml6UDZU?=
 =?utf-8?B?bUk3OGFKcGZTSFRLa25OV2lxeStBUXdrQzMzR21HZzNvVVJmL20xK1BONGVR?=
 =?utf-8?B?enkya1RrY08waUR6TGp6Tmlld21KRmNNRUlmb0hWeXFvYkpVdG04MnZic1oy?=
 =?utf-8?B?MU8vMVY1MzJvajJNcUcvdzRSbnJtWUdTaVc5WXJqWklMblRJNkJzaVBhSFdY?=
 =?utf-8?B?VmE4ZWlYVHM3d2hDU2ZlL3V5KzViNHlwTGEvV1ZYc1VkL1VhR2xsR3pWeDNy?=
 =?utf-8?B?ZEFRcjRKcUJlTVc1blAybnh4d0FnZEZkZVcrUml3ZVRIL2NkbS9QWUV5czY3?=
 =?utf-8?B?Njg4TXl2Uy8xUTVMN2tiRjN6amJxK0JpMTEvTDNLK3pHMDBNelVTMHhxZk5p?=
 =?utf-8?B?RklzMEFuOVg2QWQxdzhIeWJDQXhCNE12Zk9ONXZ1QndtdDJPNVE5ckNoWE0z?=
 =?utf-8?B?TjVsWUM4ODVob2Q2emR3bG9mVG83eVlHaEJ1NzRDV1BmWkk0aEx2R0JwN1hM?=
 =?utf-8?B?N3U4VWIxTmYrRFVOMG5sa0dGd256YWVPbzBjMHVCbDdmK2pUc25QSTduaVlm?=
 =?utf-8?B?UDVzSHNKWUdHR3ZHWTNGcVVYNEUva09TWDk3VVRRS1MvdmVxbmNUdWNHMGdS?=
 =?utf-8?B?QnBGck82YTVlVG5sOHBPajF0alIrR1RWRDVVRkM5TGp3Wnl4TlJqNFA0dGdM?=
 =?utf-8?B?VmppemNXRlJISVlpMmlOcHJ0M3pUWmdVYTNDMGU2NURDYWFIUmFlWUNMVnlY?=
 =?utf-8?B?cDRWbUQ5VVdxZStlZzN4MUNKU2tKdUVJSkx0MUIrY1dITEQ2QWM0VmNDU3Yz?=
 =?utf-8?B?SUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <07D047FB6228B0468EF25BFDC6F6A828@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54f31837-de08-4470-c9a7-08ddbf51e3fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2025 01:34:19.4333
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p3pEJ+YTT/MYloJv7Lmw8a1Z+EZp+anPVkAoops/wvQglyR7u1YXnKGFZFPNJx9FS20wURN2f2r71we2q5LqzexOPj+auZ5XcJFlwyXiS80=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8155
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA2LTA5IGF0IDIyOjEzICswMzAwLCBLaXJpbGwgQS4gU2h1dGVtb3Ygd3Jv
dGU6DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbW11L21tdS5jIGIvYXJjaC94ODYva3Zt
L21tdS9tbXUuYw0KPiBpbmRleCBjYmM4NGM2YWJjMmUuLmQ5OWJiMjdiNWIwMSAxMDA2NDQNCj4g
LS0tIGEvYXJjaC94ODYva3ZtL21tdS9tbXUuYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vbW11L21t
dS5jDQo+IEBAIC02MTYsNiArNjE2LDEyIEBAIHN0YXRpYyBpbnQgbW11X3RvcHVwX21lbW9yeV9j
YWNoZXMoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBib29sIG1heWJlX2luZGlyZWN0KQ0KPiDCoAkJ
aWYgKHIpDQo+IMKgCQkJcmV0dXJuIHI7DQo+IMKgCX0NCj4gKw0KPiArCXIgPSBrdm1fbW11X3Rv
cHVwX21lbW9yeV9jYWNoZSgmdmNwdS0+YXJjaC5wYW10X3BhZ2VfY2FjaGUsDQo+ICsJCQkJwqDC
oMKgwqDCoMKgIHRkeF9ucl9wYW10X3BhZ2VzKCkgKiBQVDY0X1JPT1RfTUFYX0xFVkVMKTsNCj4g
KwlpZiAocikNCj4gKwkJcmV0dXJuIHI7DQo+ICsNCg0KU2hvdWxkbid0IHRoaXMgYmUgb25seSBm
b3IgVEQgdkNQVXM/DQo=

