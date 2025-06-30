Return-Path: <kvm+bounces-51114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 03F0EAEE98A
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 23:46:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EBAFE3B87F8
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 21:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE00C22FF2D;
	Mon, 30 Jun 2025 21:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SsYVLlk8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FA34A23;
	Mon, 30 Jun 2025 21:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751319967; cv=fail; b=Ee7GuHs7uh55uoF21DEBpV39UIk4wchi7y7oZQHngeLAkVw+/ddhgj1P12ygCw1/Ml76o9KYmPWDnTSLKKtYPNFvO4S5CyhLUAOLes7Sdsm+Kb/5eRYb51gw/A0MGmdkf8TwBH4/4qeRw125drk3MgfBraX1GGW8t4XVGHhhu5c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751319967; c=relaxed/simple;
	bh=g0fm7DJeh6dgjxupz+8V8QeWw3VI79Xu5nYV7utd4cI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XbblxpN4nTkaHhgsYKu3NjO/OcBhl0Q9Fqpw+K2/vytc1BReIMdrwClj7am1Z8u0EVgatBIdMBla6x/Mi0Iv0c+x6CdpQbt2XjHzni3STFAuEF2NPiAXhzMOi1E4DcE5GxzsJxKaYtYnC1q5fQ5/iNSS+qwNkPEjwSlr5RPoju8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SsYVLlk8; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751319961; x=1782855961;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=g0fm7DJeh6dgjxupz+8V8QeWw3VI79Xu5nYV7utd4cI=;
  b=SsYVLlk8wf7WMzMMcQQcCKeaf4pR4CW1A9U9U+4MOJhGj9pIr+1RJnQW
   44fxRsRQFhGmFu61IPZdVLxedvJ71GGHv5SYzB+vwr876tGJF+O7006j/
   lUrKd203NRKczmGSX8kcbIR9YmyD3vjI8w1szsuqH581w3wGltSG6QR3q
   xyTFQPYx57dTN4OuddlCIHlaCTGysI4hbdlWJS6R8atoHVLDDYEqAaTRs
   0SyIHwK5HLQiTxZ4EwtCI3F3iiWQdDzbEvc8Sof92SXKYFhHl5UnDZdPV
   R7eVz8cHqtE1bZT/lVhMHLxb6xr6NmeD4BrKg1l/we3W8h14nGGlAjSmN
   w==;
X-CSE-ConnectionGUID: y+hpGiJZSTK1eonz1+rLdw==
X-CSE-MsgGUID: +KD9AY5aQC6wozBLHMseNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="78998954"
X-IronPort-AV: E=Sophos;i="6.16,278,1744095600"; 
   d="scan'208";a="78998954"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 14:46:00 -0700
X-CSE-ConnectionGUID: X2WtgnReTtuv2BDngwRuiA==
X-CSE-MsgGUID: eXo/VHT6QTS2b47R1p1A8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,278,1744095600"; 
   d="scan'208";a="177239256"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 14:45:59 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 14:45:59 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 30 Jun 2025 14:45:59 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.41)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 14:45:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Prwakbn2Ul8T4aKXaaJemQAteSpXuLHB/rqWWvDUljVX1nsl3TT9tjPP6z1ZHpAQh04MlFf0/J6B+VHiIA4tSywULYSxJ6aX8sAJ/lZxPqG3hDXrodn73B5zoJ4OVydL1UDhfll0LokYtC6ivRRXzARgLJgN5kJfV5/g8F/Bcu0V5XcRvpTx+6mbYqAXPRiekTJwLOYrA4KneSOC4kjwAB9WyGFBqkMzJAf7b8Urj3G+/d95HdHcKZ5orTmn+2z67EOoydTfKa0Zv2wfoOfUiJdur0dzFdKINuHLqAv30xf1OCQPFkvOraDrQEwt3cvXRyeMTD3HbgZY9na9t5RvxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g0fm7DJeh6dgjxupz+8V8QeWw3VI79Xu5nYV7utd4cI=;
 b=QaIUQ4pWO/M43NcjyJFcVRp6VgQZre+EaWR7sHS7G5Xc8r3LlWAL0e+aDbus0rGBsyBKueO9HYdqeSYk5jxWq5tbmEsWxrCFSbfLZ/JkRAK4nMT6veKvWw0OfG976ffCdSQllGJJVpaOwDhIydcJ4mflqms/+3lpFjcmuD5lPP+MwvKMyQydLpgNySSZareSg2n7Bv5Qmclgn/kby2bt5j0kxP7ClUoG32dm0/1Knwfgyh2vTVGOXAdHT93tV5z9BwqC8z+rushCanKwTmSIW0KjdHTGF4/+TtRf6A9ntq8472lwMLU7ES+gEq5qWuDG1/6BhlPcd+IpFY3jaqdZ9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW3PR11MB4763.namprd11.prod.outlook.com (2603:10b6:303:2c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.20; Mon, 30 Jun
 2025 21:45:55 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8880.027; Mon, 30 Jun 2025
 21:45:54 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "ackerleytng@google.com" <ackerleytng@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
	<david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>,
	"Du, Fan" <fan.du@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAozpACAB4/5gIAA7nmAgAAX8oCAAO6tAIAAjZiAgAAGKoCACG6bAIAA3+42gAGE44CAABkngIAACJUAgAGDrACAAALngIABC0kAgAB2RoCAAUnBgIAERXKAgABwaoCAABksgIAAJyQA
Date: Mon, 30 Jun 2025 21:45:54 +0000
Message-ID: <fe6de7e7d72d0eed6c7a8df4ebff5f79259bd008.camel@intel.com>
References: <draft-diqzh606mcz0.fsf@ackerleytng-ctop.c.googlers.com>
	 <diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com>
	 <c69ed125c25cd3b7f7400ed3ef9206cd56ebe3c9.camel@intel.com>
	 <diqz34bolnta.fsf@ackerleytng-ctop.c.googlers.com>
	 <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
	 <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com>
	 <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
	 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
	 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
	 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com>
	 <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
	 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
	 <diqzms9pjaki.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqzms9pjaki.fsf@ackerleytng-ctop.c.googlers.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW3PR11MB4763:EE_
x-ms-office365-filtering-correlation-id: 68596a69-fd47-4b11-ed6e-08ddb81f7d9c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZTkzRmF1SEhlZjJoK1EwUEliTENsSlFkYm9MNE1ROVUvWFo4OXNtWHpRcVZC?=
 =?utf-8?B?U1pIK3lWZmhaTkMxVmF6NjB0K0VESXZaVUhTTFZseVVka2xhd1BKK2hKYzZl?=
 =?utf-8?B?KzdlS1RpMkxjWnIvMjJJQXc4RHpGVjNWWEFlY29KSVBVQnZpNis3clhEeWc3?=
 =?utf-8?B?NkxsZWZzcWZkLzlzaU53Sk9JeXhLNi9DUUhtNnN6OWY1TTgrNEg2YlUzdm9E?=
 =?utf-8?B?VXQ2YU9IWUZrZ3JncmRKUUo2Nm1CcEtPeEd3ZitYSVlBcVZlVGxCYkFRaWpK?=
 =?utf-8?B?TUFsN1lMUjd5RUVFYWtkYklMUUplNXhkekk4L0hXS1JuVkZiOFhBbC9mdmRy?=
 =?utf-8?B?Ym96SjMyNzdGVmU3RWU1NjNFTGJBNnRLdnE5U0ljV3p1Y3ZZZ2loSWllVVdq?=
 =?utf-8?B?QlF6cmtmTUxPOFFGS2hnWjlEaThaaW1GZFFVSm5kcDVFN1JvdFhkNmkyZXRH?=
 =?utf-8?B?VDN6SUtORzVhUi9qSkUxeWdZdDV0ZUJXTXFlL2F2dlZoeUxMdWNwd2h2UE9p?=
 =?utf-8?B?b01DNnlSNVlKRFVabkJjM2JLcW55TWV5TmpOT3BjTEtIbXRWb2tHTW1RWVdZ?=
 =?utf-8?B?MndsRjROUVBWWUkwR0pzdSs4aTYvUTdXVGE4Q1U0VWl0Z1pKc3Y2WkhhOHVB?=
 =?utf-8?B?ZnZLbXBFNG9oNExvT3lGeGNRWW05S3hFRXFvdUdYUWZJZTZUTWdoL3E1cVBC?=
 =?utf-8?B?SFpRWUJ6cHNISlVObjhyQzdFOVQvTUoyM2RudUVveDhDUGpyWHRxeG5NRGFj?=
 =?utf-8?B?Z0hiSk9Lb3U3OHpNV0N2WldBNnlXNmdYL2Jqd3dmdXlhUStNSVNnbk05TnpC?=
 =?utf-8?B?NGNlVG9lckxQOGxJTWo0UUE0YU45N01kK1R1QmdiNmErMVB4eUJqRUhrclA5?=
 =?utf-8?B?VkUvbXRYZFQ0bXkxZ2FIb0k5VURvcmpQQWR6MW43eVkzN3VML2t6T0F4OUtw?=
 =?utf-8?B?dTl6dTllaVhXdFpkNng1SG0rcENiUHAxUGFzYmprcGdYTStwR1lIcDlGUWNt?=
 =?utf-8?B?MW4zVmtWVWhSRGltWnlzM25Ca1dxV2xvOFNJOUhoRzBHRFhDYWpWSEhia2dy?=
 =?utf-8?B?Z2FBKzNtbFd4UkZCaVRYZThBajd3U0p1ZmpCZFF2UXhJTS9Cb1FFVjlzTW1G?=
 =?utf-8?B?WFJtbjR1NW9aYXdaMEREVzdVeENxbzE1cUZXMEhlV2dGOXdCTEVNcXc5VDc4?=
 =?utf-8?B?eVZwNUVTMVN6dlJiY0pnZkpoc2NMRUxKKzdEdGhNeUQzSFdqdStEc2tTVjNI?=
 =?utf-8?B?Y3orUnNRSHUyZktsMG42Nk4zTEEvc1dRTWU2b1NQOElGdkVwMWxGRm13eWhw?=
 =?utf-8?B?OWZYYU1BNXB5MnAyeDlsK2JVR1RSaXpNajNXR3hZTTdEaFhJNThQTG9jaFZK?=
 =?utf-8?B?c0FlRmRRaUJ6TFBMbjBmaWlUN0w5SlJ2Qmhwc0hleVIyNmpCOUlUalV2ci9r?=
 =?utf-8?B?QWNGa01NS0toZ0l1S3VLQk1OOWFuUFlOaHF6c216Qm42U0F2dkdpZHMrd2FB?=
 =?utf-8?B?QVlzditIVkt1bW8raWt6ekpPUVBVL3lHNFlmUDUyc0ZBNkNoSmVWVXJrYzhV?=
 =?utf-8?B?clpSNnhGRmR3bDgwelhZY3VDMmRFNGE2SmRoZStNNUx1Z24xT3lhTU14SFBq?=
 =?utf-8?B?S2p5Vk1Zb2FYZkhjTFdjS29pOTJMNGdmMURQeDRyTGthd3dtUHdQRFd2ZUR0?=
 =?utf-8?B?eFNoeGN3MlFKeG1RRS82Rm9qTGtETEVDSlNrRlJxMFdra2sxZHFFbXZNdDhR?=
 =?utf-8?B?a21wcWR6anFCcHV2NGpCWUJRZU5hY3VZams2ZUtVSkl0Mlh2YXJhOFNSWE40?=
 =?utf-8?B?TGhTUmxvaUVES1lXaHVqUjN6WEdQVHNFNVM0RmUvdkM3eVJWNDI4dnNzSEk1?=
 =?utf-8?B?WlJ4T2x0Q0xUajU1c1FzZGN0ZnlweEw2bkZXeFlzNDB1bG00anVZKzV3NkNP?=
 =?utf-8?B?bXBPN01nbnZwdVloVlBuT1pDenVCN1lMTm5ua3VVU042MHFsanRudkFWQngx?=
 =?utf-8?Q?HjBWur8FiRpqFNNa0I6QJtOXoAgyj8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ckxtR3dGK3c0Z2J2WTQzcjNERGpnQ2ErUUhqME5KdjR2cWxjTk9ySHc4c3dV?=
 =?utf-8?B?ZVl4U1hIYTZVeVpkbFJhSzdMTHM4cldyLzFoQklsMWcxR0J4RjJzeEh1TUUw?=
 =?utf-8?B?clIxYW05RlFXeWwrN21QempaVWNlMTZCem9JWUQ2clJjNlhESzdiVk5xRFV3?=
 =?utf-8?B?aDR5VlhQS2lOVzQ3ZFBkZzlIQ2JwbVhDVWF6cFRvaVlUcFowQktNZEVhNlpM?=
 =?utf-8?B?czlNZDZLeHlISnN4YVJhNmFhRTJ4ZGtLT21CSWl1eUw0M1dYeFlUa1pybEFM?=
 =?utf-8?B?czBzdklLUy9mYS84c1hRQjZRUUZwOGYySUZnUU1HbzlIZnFYb1BQYXh4RE9S?=
 =?utf-8?B?ckRHNDMvRXE5QlhZSjZwakZyc1NVMlZsa2NtVWVyM0NuU0I1YmpzM1FMalVp?=
 =?utf-8?B?TzRnYUxqMmVQdWs0cEVSUDNTZGF2Vy9sL2Z1cllOdjNpd0tJenA3Y2FZL3Rj?=
 =?utf-8?B?STlEVW4yZkdLR3B6VVdFSnJ2Z0FocTNvU01ndWxlUzVIaFU3Vmkram5nNEFm?=
 =?utf-8?B?RGlNbVcyRldobTJDU2w4YUJhQTN2UXcyM3JPWDJHc0dURXJNL0VubEtEd1VM?=
 =?utf-8?B?aVkrWGtnSGlDN3dQMkZ2UWNhTWhxcHZsUnVNQU9qbmVBUVFFRHBXMmg5L3Y2?=
 =?utf-8?B?L0MwNlQzcHRjV1BXTmNYQXRFY09VUk5wYUlMeExnTzNpSXhoem10RUdIUFdY?=
 =?utf-8?B?YTZzZmhjZXp5YnhqY3VTQmd1Wk1BNGdkcnBVVEZ6eUExZk1zUHhxSEFQOTJS?=
 =?utf-8?B?eXZ1NHd4SUthU0loUGxVWEc4S2xmMUZMZlQ2clFxM1p1SzZreDhnVkd1QnJI?=
 =?utf-8?B?YSs5RUFMNlZjRnozM0x0SDFERFBPTU5ERjExaHBFQkJUUzVwVzYwaW42aC8x?=
 =?utf-8?B?Y1dQa2xVeDZTOUZpNXlVQzA4enRoUFVSMk01WE5GOE5Yd3pKNS8vY254OXBq?=
 =?utf-8?B?MkFucXFPaDY0ZDZ4eVlNeC90Z1F5MVFZeVUxSTg2UEh6ek1ZSTVvM1hsb3dx?=
 =?utf-8?B?bUNJMkNBS1BVQ0pWU093UVAxMjh3Z2tYRm0xczFMbjRtcWZYYW9xVUkwNTBD?=
 =?utf-8?B?V1p3Z0ZLR2RWcXBJVzN6WFVtSGo1YVBibHMzcUtRVzVPZmMwbmg1Y082dDlT?=
 =?utf-8?B?cnpVWGtTcXZUZmhXcm5BWnlsOS85cU9DdFdVb0RjanpxZUpzRUUyTzRrK3Q3?=
 =?utf-8?B?bnd0eFl3b0pocU1lSUFMRGdIUFRlTkFha3QrQjV4V1F3RXlRMlFaaW5aV0Y2?=
 =?utf-8?B?VklUQU5BS2c4VFMyZ1FQNXFQTEVUdmZUM2dQWENtM1RTa2Y0RkxEdmc5SDlo?=
 =?utf-8?B?TDEyM3pqMkVqdWZrWXFPVWsrZXo3cEJLSEdnS01hcU5ndi9QK1A2R1Rhd1J5?=
 =?utf-8?B?bUU5Uk5Pd1ZOeEMzVTBPdTQ1OVpqelNJQkc3NTBKMStjaHNXSk9GVHkzYkhN?=
 =?utf-8?B?S0RqbXB6Ym9MczlQbk1SdW1qOEFORTFaazE0UU1ZRDNEYi9ONmd6VG13ZFR1?=
 =?utf-8?B?VVVNdjdjcmNuNXdjUUFlOWF5M3Bpd2dPT0RtYWN0OUpadm1HTUVMZkpnTzRt?=
 =?utf-8?B?c2U4YlRBZHhwSG9WaHY2N0F4OEtpRkZVSTEyQ3pHOGxaR3hybWpmNy9SajJT?=
 =?utf-8?B?V0pTdGN3VlVEK1J0STEzcDZ1SFNQY0gyeG9HQURTZ04yRDhBUWJ4aDVtekpK?=
 =?utf-8?B?dElKS1p3bEZxOHl0blIyS043TUFJT3ljVnBYK0F5M0JpcGszZHRkL2NGaUxp?=
 =?utf-8?B?dWxGclYvM3IyTHJGQkZMTzlvZXBTQmptcWQ5SkpTQU9EYjB6aFhkRjZUTHRw?=
 =?utf-8?B?cnZqVk5KQk9RK3VCZm80eE1QSFFOcCtySnZwNEpDOW5QbE5tNDNKaVIyRWhG?=
 =?utf-8?B?d2RNc3pGdUNkTmthcGMyNGMxY3R3dDY5cEJpTC9GSk5hWTB5bmM2L0cxVDdv?=
 =?utf-8?B?TjhaOGR6Y1pZUURoQmZ5NXZzMTlVQkRXeHhyUHlUOWRBSnEySGRaa2h5OGc5?=
 =?utf-8?B?ZFQ4UnhIa3VsVEt6UHhoTm5VK1FiU1FWOERyMDBDTVQxcTl3ODFaazd2VTdB?=
 =?utf-8?B?YXU3T0JIWElBNlV2bGE0aHdZcU9WcEMrSWU2THBWTWxnalNlWVBZUUlXNXYv?=
 =?utf-8?B?bUNQanM0blBWbi84Q0RSVG0zSTk4Q0JkMjYvWFAvZVRHRE5GZm5hRit0WEUz?=
 =?utf-8?B?UHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <15BFE23E6E991841A5A5C2A0B83BF216@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68596a69-fd47-4b11-ed6e-08ddb81f7d9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2025 21:45:54.6892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d2ZNMWeGvlQYrQ9f7NckIUCFaKjDiFs6YXpcVzRwKfUZmvtvowvoqnupY4dqOLoUXZWvqFeLs5uycSCYHgrbV9teIJaEmkU3w6fzrAz5W5E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4763
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA2LTMwIGF0IDEyOjI1IC0wNzAwLCBBY2tlcmxleSBUbmcgd3JvdGU6DQo+
ID4gU28gZm9yIHRoaXMgd2UgY2FuIGRvIHNvbWV0aGluZyBzaW1pbGFyLiBIYXZlIHRoZSBhcmNo
L3g4NiBzaWRlIG9mIFREWCBncm93DQo+ID4gYQ0KPiA+IG5ldyB0ZHhfYnVnZ3lfc2h1dGRvd24o
KS4gSGF2ZSBpdCBkbyBhbiBhbGwtY3B1IElQSSB0byBraWNrIENQVXMgb3V0IG9mDQo+ID4gU0VB
TU1PREUsIHdiaXZuZCwgYW5kIHNldCBhICJubyBtb3JlIHNlYW1jYWxscyIgYm9vbC4gVGhlbiBh
bnkgU0VBTUNBTExzDQo+ID4gYWZ0ZXINCj4gPiB0aGF0IHdpbGwgcmV0dXJuIGEgVERYX0JVR0dZ
X1NIVVRET1dOIGVycm9yLCBvciBzaW1pbGFyLiBBbGwgVERzIGluIHRoZQ0KPiA+IHN5c3RlbQ0K
PiA+IGRpZS4gWmFwL2NsZWFudXAgcGF0aHMgcmV0dXJuIHN1Y2Nlc3MgaW4gdGhlIGJ1Z2d5IHNo
dXRkb3duIGNhc2UuDQo+ID4gDQo+IA0KPiBEbyB5b3UgbWVhbiB0aGF0IG9uIHVubWFwL3NwbGl0
IGZhaWx1cmU6DQoNCk1heWJlIFlhbiBjYW4gY2xhcmlmeSBoZXJlLiBJIHRob3VnaHQgdGhlIEhX
cG9pc29uIHNjZW5hcmlvIHdhcyBhYm91dCBURFggbW9kdWxlDQpidWdzLiBOb3QgVERYIGJ1c3kg
ZXJyb3JzLCBkZW1vdGUgZmFpbHVyZXMsIGV0Yy4gSWYgdGhlcmUgYXJlICJub3JtYWwiIGZhaWx1
cmVzLA0KbGlrZSB0aGUgb25lcyB0aGF0IGNhbiBiZSBmaXhlZCB3aXRoIHJldHJpZXMsIHRoZW4g
SSB0aGluayBIV1BvaXNvbiBpcyBub3QgYQ0KZ29vZCBvcHRpb24gdGhvdWdoLg0KDQo+ICB0aGVy
ZSBpcyBhIHdheSB0byBtYWtlIDEwMCUNCj4gc3VyZSBhbGwgbWVtb3J5IGJlY29tZXMgcmUtdXNh
YmxlIGJ5IHRoZSByZXN0IG9mIHRoZSBob3N0LCB1c2luZw0KPiB0ZHhfYnVnZ3lfc2h1dGRvd24o
KSwgd2JpbnZkLCBldGM/DQoNCkkgdGhpbmsgc28uIElmIHdlIHRoaW5rIHRoZSBlcnJvciBjb25k
aXRpb25zIGFyZSByYXJlIGVub3VnaCB0aGF0IHRoZSBjb3N0IG9mDQpraWxsaW5nIGFsbCBURHMg
aXMgYWNjZXB0YWJsZSwgdGhlbiB3ZSBzaG91bGQgZG8gYSBwcm9wZXIgUE9DIGFuZCBnaXZlIGl0
IHNvbWUNCnNjcnV0aW55Lg0KDQo+IA0KPiBJZiB5ZXMsIHRoZW4gSSdtIG9uYm9hcmQgd2l0aCB0
aGlzLCBhbmQgaWYgd2UgYXJlIDEwMCUgc3VyZSBhbGwgbWVtb3J5DQo+IGJlY29tZXMgcmUtdXNh
YmxlIGJ5IHRoZSBob3N0IGFmdGVyIGFsbCB0aGUgZXh0ZW5zaXZlIGNsZWFudXAsIHRoZW4gd2UN
Cj4gZG9uJ3QgbmVlZCB0byBIV3BvaXNvbiBhbnl0aGluZy4NCg0KRm9yIGV2ZW50dWFsIHVwc3Ry
ZWFtIGFjY2VwdGFuY2UsIHdlIG5lZWQgdG8gc3RvcCBhbmQgdGhpbmsgZXZlcnkgdGltZSBURFgN
CnJlcXVpcmVzIHNwZWNpYWwgaGFuZGxpbmcgaW4gZ2VuZXJpYyBjb2RlLiBUaGlzIGlzIHdoeSBJ
IHdhbnRlZCB0byBjbGFyaWZ5IGlmDQp5b3UgZ3V5cyB0aGluayB0aGUgc2NlbmFyaW8gY291bGQg
YmUgaW4gYW55IHdheSBjb25zaWRlcmVkIGEgZ2VuZXJpYyBvbmUuDQooSU9NTVUsIGV0YykuDQo=

