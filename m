Return-Path: <kvm+bounces-14806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F163E8A71FC
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:12:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA16928341C
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 17:12:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA4D3131E21;
	Tue, 16 Apr 2024 17:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dVG3WmEH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2F284E19;
	Tue, 16 Apr 2024 17:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713287535; cv=fail; b=c0IPOb6SxOI7O+w/AcH3gH6A1uC80WBDaPRHGQOboa2MTj4AKYdH6NDM5tvIcRiVQChDEAQZq4E3BVV1CiWf+aRzpVZZ0KeIOcLfjoSxX1mDy+hlTlzDSAHfA7P/ee8aEkube7LFXgLoBydXr/4KIudzGMMfp6CNQGhPGLK7Wg4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713287535; c=relaxed/simple;
	bh=SOV+cTRgfoS2GXhKv8gOUAOidx0jyY9EoLy1e26ajnw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iA2ZjCR+z67LvVHnt64Hxr/aooTIRD2KRtmLlmezTegYDeeS65lCvoHrJPEDW63+OcjiSQEHbYXQ7NL/wxFelVcl/amXPX085iSXbkz1Mo9WNp2mjR4ho3xpEJp/Wdr17I7LePnfPRgjDCGKhAO0OFNfgjcJPUJwHtBkTyMaE1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dVG3WmEH; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713287534; x=1744823534;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SOV+cTRgfoS2GXhKv8gOUAOidx0jyY9EoLy1e26ajnw=;
  b=dVG3WmEHkTAVZn4KmEmMWc+QfgDfksXImlR8lHuFlelRF/rsN1WO1m3o
   uWyBtZYsCF8OZDILcZZ7mEZeODbRN6kqH2tzIZ4h6CCgBlXl6AOsgC6qB
   x2Xv7mtg5oSmIvrjEhdhkwPIwIHKgsuFlaZ+qm90qclahYbPdXNsC5w4Q
   GwIVncES8OcYiDmbdlxrz5d1MPJLschuctVFqk7bNsoc05ZyOMh9RDq4D
   D+VLCQElp8ueGvLJYM7CW0hIp6kF1RM/s7hQacus6Lg+sZ5JzuT6Yw/oU
   ll409CkDx/zkb1byEd54zldd0BpH7WeNC9J7jBf427IQk4Fg5pQPwWlQo
   A==;
X-CSE-ConnectionGUID: 75Hceo/nRdCMIsKe3hbnSw==
X-CSE-MsgGUID: 3LJCvHm6T7iE6h/gPRruZg==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="26204125"
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="26204125"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 10:12:04 -0700
X-CSE-ConnectionGUID: jsoPm7puSeGXi4RurlBGOg==
X-CSE-MsgGUID: Qu12OnCtTbWekpNWDhJYiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="22212622"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 10:12:00 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 10:12:00 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 10:12:00 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 10:11:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jZ0JXgDW9MV92fQpQqVO3UKJRpaZdR3FWvN2mW80FLqMG1y2BptuyvsEMFMOAUjzWai2hHYSYH7uRLwOV0H6Ls/CkaeAqvPQVBr/305Egs8anfQrMTkofweqBX70fOVIL/Wjx6mPw0UT9iHC/PD3xWkziSwLqby3mZhfbBZ02bq/lxFiEjauSPcyuVoMoYekvg8Mg1Me5dE0O+jjsGXpEJh4HtgdeIjpHErl+5JaxWXJjITkKcfap63kEsgZysxle2g6s5NHYlaZEQIbVkWTtnU84hI/8oBYGzyCXVyHfv+4XCw/HCx4SGDBGx6pclleHz8Intk8+Lsv+RlJ9QiZsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SOV+cTRgfoS2GXhKv8gOUAOidx0jyY9EoLy1e26ajnw=;
 b=CEi0LEZDSKHokkhDAbm420kwgytxDMzrrTlFCUb5XFUwW/aa0eXrsaX+0dt9/MBP5da5NKTNHPLGib8/d9t/yczrhhmh04z9r4VpNu/BUOCW8Utdev5taVOvGu98CauUnZzuG9/o4ghhlGBLBXbD28bJuLnbowkvFc0dB8bHU1DcvjdO0R20d0XagD6M3sYVNLAkgql6vlN/yoNHPFskqTcjX3EEIJ1Fcs0ajBgjQxM1t3Q2wYg9uueqDwdsEpeF1xovyxD/GilwmUPYRKJHurEXHi5cRd1gIt4IssHLWS3IGqXi15OR6O+rmqKHK2pTm1/sDQOhmJZIiQmegCVVLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY5PR11MB6115.namprd11.prod.outlook.com (2603:10b6:930:2c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.26; Tue, 16 Apr
 2024 17:11:57 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7472.027; Tue, 16 Apr 2024
 17:11:57 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "federico.parola@polito.it"
	<federico.parola@polito.it>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v2 07/10] KVM: x86: Always populate L1 GPA for
 KVM_MAP_MEMORY
Thread-Topic: [PATCH v2 07/10] KVM: x86: Always populate L1 GPA for
 KVM_MAP_MEMORY
Thread-Index: AQHaj2zLgtQEfdW4RkWn7ENZRakFjLFrI4QA
Date: Tue, 16 Apr 2024 17:11:57 +0000
Message-ID: <54992d3f470522609d735b8432d0091acb806b75.camel@intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
	 <2f1de1b7b6512280fae4ac05e77ced80a585971b.1712785629.git.isaku.yamahata@intel.com>
In-Reply-To: <2f1de1b7b6512280fae4ac05e77ced80a585971b.1712785629.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY5PR11MB6115:EE_
x-ms-office365-filtering-correlation-id: 017d7021-2e4a-433f-71ea-08dc5e385242
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KIeaPrPAazJCa8uxV2Gb4ijJjRTahorh9XFzzyGdHkf1k1jLVOAx56VHC+vmLq1n4hQpO9Mu2HB3mlzpp/ntnD4ZLfPDrH4Bx8gPoSIia8M+M3Rr+gh8vfBEclTqGyKeKNnpbGY0z6laaxZCrtHsBSUX7ANtvvO2z+pVjBcJedn3U2Z4rk65PRFnEj3XN5D17H7ljhjLPochl8rRQ8hb+PXXKuONhliOsmDGTSi5++eCBoe+4upOjDzxdrRB36hRwm068P6m9Tv4IEdxnbCoWlRQZsRrQikO4ZUwQe0T60DQASToNkyrmAuLizwSyjBpdy4MS2dRa45wALFx97oLlJRj5BdnszNryMPdV1Rt17enMfSQOwBcOw3cpE0pYZgMW4VNXyiblvvhL5zi1BNWdDUAlA6r2soKR9/OacGfyAa7XX6f/RPWusXqiIIx9zte0TgFjwxSiVNbKf0ek3Zz1BZQb0NSrAUc+ptCBekTIG264Vh+3WdVYrfldLf/mEOZ+QZ/wRd2Ud+n7novQll3IMrJHknnGb8Cjsjwrb4N3uusZzNdeECHOiC++zYdRmAzI82xpeVkW4PcltKjG7HF/KqeWsWS5Xw31+I/bqtYld4ulL0ZCQi3OObaguMF5Dx5NHtmACCnmWQZfkhZ8lBcpzvbX9602tOqSNIgUZtv5xc5vzOBt6PkJiDvF5gcWq4HHiadxCHZM0a6S0GsTv5ycsQVWQj0750W85RLlUQyl9g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ODhranZLVGpaUEwzaHZ4UERGaW1kNnZWeVZWbW8zblBLNCtvU2tENXZoMVFw?=
 =?utf-8?B?Lzd6VVRDWkk5bEFmeTU1TjRRMmJZRlBBWDJ5V0F0UFlEYzl3U3RIdm9xNEVZ?=
 =?utf-8?B?WEpvWVNpSUlqeHBuenF0MFh2MGNpUWxxRlZPYllBY2dEQ3AyTXJUL0FFc1hM?=
 =?utf-8?B?NnpZdGV0RE4wZFhiSEZtZEJVaVJXdWwyZENsR1l4a2hqQWhucjJHVHJ2Rlpv?=
 =?utf-8?B?YW5EMEFuNm1kQjdXcExjMTV0dXZONEladEdvZzc0TVJRRzU3QzZFY25UOHBn?=
 =?utf-8?B?dDh5M1dBcktxQmRIUkFnbzlEUUxRNVRaa1VPOHRqbEFjY2VjUmtsQWdpeGg5?=
 =?utf-8?B?eE9MTkRGSEVZTXhXbjM0MnZ5NFhWbnRubURseHVVN0sxOXhQTGdXdzNJMHUw?=
 =?utf-8?B?YVpDNGJoMEVXOC9ESlBTQVhNakQyQzVtRGxLRjl3UDVPVm1nRzliUktrYVZx?=
 =?utf-8?B?cmhEYVNpSUx6ZHBWcGdCY24rME1zRHpMNmJDZFdGK29UdzNpeEZTTmI4UGJK?=
 =?utf-8?B?dzhmcGh3UHlJQVd5UUpYa0hPVW9GREd5cGJIUytLdWcyeHNIRjBsbm96cTcz?=
 =?utf-8?B?emdna04xMmh1MlBxT0htRzFLL1Q1MHdrVXM5NTZSMGoxMTJ4YS83Ujh5MlFE?=
 =?utf-8?B?VDZ4dENMV0x1b0o5OXZWTnA5VkE5WmUzTGZtZFpiUitlNEtsakF1ZXJicFk4?=
 =?utf-8?B?ZDdZQ24zNUtrL3FnbVl0aGU5bzZ5OFVNYTZObzZCcWhNR1BWRlRhVWwzSHlM?=
 =?utf-8?B?Mml2L3BSSVR0d1N5TitEcVIzWWJyMWVrZkRaK3RiUXl1MkpCcVk0VGFlNndq?=
 =?utf-8?B?aEo4U09Xa3BwdjdvVUF3bDVoQTUvVDl5T0dqbWZ6ZndGYzc2OHBtMit6QXNZ?=
 =?utf-8?B?T2NsdjQ4OVNLRWJJaGRlWVI4WnFYaWZ5MkxIcHhXZWRHL01ZRkFrVHpVbTgr?=
 =?utf-8?B?d2l3NEs3WFZHNXd1UEduWFd2a0k1bTdseGVZdGhDd1hnWXdUVXJGbW4zRXpN?=
 =?utf-8?B?aDJhd0g0c3B5Qk43T2ZmOXRHYlJLc3FUS3I2Z2FRdEhJaW1EQ1pZYlYyeElo?=
 =?utf-8?B?YkpicmtodU5QbStTSEFEQWwrc3RRSmVmYmowdjlhdlRxdFBDZUw5U2xVbEVo?=
 =?utf-8?B?bXg2aXVlVm9hZDNjYmc4VEszMWhFQWRoSGxDeUtzNjY5Z0lvRi96NndUUndi?=
 =?utf-8?B?TlhEZ1h1UEFxSlpNYnhZRXZMaHYreXBXR0Y3YVBqenppQndUcGRRVUxUeS9S?=
 =?utf-8?B?WXRoVUljbHlnWVN6VVoxckxHa1g5bHRvS1QyN3g5UUlldVZXM2RLT2VXdTZu?=
 =?utf-8?B?YmZTbk95WlhiMThtWDNsa04rZmtrM3BXTUp6aURMeE1VVy9pL2poYkJ4UUkv?=
 =?utf-8?B?aEl6d2Uza1ptNDdyMjlickhHUUdOZnRkNUZJcktCc054a0ErQTRqRjJNNVRV?=
 =?utf-8?B?cElhaElqMFlhb1Fhb3NqZmJtQjRrcE9yZGZVU1gwbkFQRTZaM1pHSjYzU0hh?=
 =?utf-8?B?RUVqc1BDcks2T014K05UQzFvVllzRjRQU1dSSTRZSFZVVUZOVVJENFVBTDVG?=
 =?utf-8?B?TVdQM2lQQ2JCMzJ1ZVd2WXhqVnhjcmY2RVliL294bzRiS2pTMU1uSXhNZVFs?=
 =?utf-8?B?dGdwaWgwbWhISFBxbklUdGI2bmhyQTFLdXFOeGx5WWtUZHNiVlRHWGxLd0lS?=
 =?utf-8?B?K0ZhL2EwM1RhRzJCb2pXMml6NFN4VWluZ2dyNlhXK2hjSlMyTHRWVG9VV2h0?=
 =?utf-8?B?MFhPbDE2aTBKSXBzRi9mVnRFT3Z6cTEvK2VEQWg4VW42bXZ5SlZGbzQ3K1hr?=
 =?utf-8?B?OU5nUTdQdXR4UURyS0FtRVU3Y29JZEFtQUZoTEN1SHAwTzRkOUZwbHZjRDlO?=
 =?utf-8?B?aEx6NjFTcDlJcENYYUI2TUNWQ2x0WmsxQWJJMVJZemlZRmcyOHBUVVMvcWxE?=
 =?utf-8?B?Vjc4ZkV6OGdQOU1uNzV5bVIwTTd6N0xvMXpxT09OeG1BbUhNVG9aTGQrM2FL?=
 =?utf-8?B?VEpGaGo0ZWhzdDV6Sjl3ZkUzc01HbVZnV2Q5WGtqWFJKOFZmRXdwSVVxVGZD?=
 =?utf-8?B?OFZLUXVnY1VWclIzRldOcDNXVVczb2ZMOU9WNW5veVNQWWV4UVJrbHFVUUph?=
 =?utf-8?B?Nld0M3lIZzFnSkdMbzB1TWNMOHhLVGs3ZDRleFdqbUhzT0pLSW11REtiUzlJ?=
 =?utf-8?Q?W4HVH3/FVlnf9RqJLquxCeI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7D80AB73566F354F9C83457578F7F26C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 017d7021-2e4a-433f-71ea-08dc5e385242
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2024 17:11:57.0981
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KSE5hUBEb0vkv/2Zd3UWPXlnT4YkkDhdWncUphxXHt5G9vAhELn/TnckQn/fhgWk5gVOX9ZEK4FnJg9oKbdPU3L7HYgxBpcE+dRbFp968V4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6115
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA0LTEwIGF0IDE1OjA3IC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6Cj4gK8KgwqDCoMKgwqDCoMKgLyogRm9yY2UgdG8gdXNlIEwxIEdQQSBkZXNwaXRl
IG9mIHZjcHUgTU1VIG1vZGUuICovCj4gK8KgwqDCoMKgwqDCoMKgaXNfc21tID0gISEodmNwdS0+
YXJjaC5oZmxhZ3MgJiBIRl9TTU1fTUFTSyk7Cj4gK8KgwqDCoMKgwqDCoMKgaWYgKGlzX3NtbSB8
fAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoCB2Y3B1LT5hcmNoLm1tdSAhPSAmdmNwdS0+YXJjaC5y
b290X21tdSB8fAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoCB2Y3B1LT5hcmNoLndhbGtfbW11ICE9
ICZ2Y3B1LT5hcmNoLnJvb3RfbW11KSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oHZjcHUtPmFyY2guaGZsYWdzICY9IH5IRl9TTU1fTUFTSzsKCjAtZGF5IGluZm9ybXMgbWUgdGhh
dCB0aGUgZGVmaW5pdGlvbiBmb3IgSEZfU01NX01BU0sgZGVwZW5kcyBvbiBDT05GSUdfS1ZNX1NN
TS4KCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG1tdSA9IHZjcHUtPmFyY2gubW11
Owo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB3YWxrX21tdSA9IHZjcHUtPmFyY2gu
d2Fsa19tbXU7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHZjcHUtPmFyY2gubW11
ID0gJnZjcHUtPmFyY2gucm9vdF9tbXU7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oHZjcHUtPmFyY2gud2Fsa19tbXUgPSAmdmNwdS0+YXJjaC5yb290X21tdTsKPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKga3ZtX21tdV9yZXNldF9jb250ZXh0KHZjcHUpOwo+ICvCoMKg
wqDCoMKgwqDCoH0KPiArCgoK

