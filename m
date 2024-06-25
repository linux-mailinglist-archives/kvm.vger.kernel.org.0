Return-Path: <kvm+bounces-20436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 25712915B33
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 02:52:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8827AB229A3
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 00:52:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61B3323746;
	Tue, 25 Jun 2024 00:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PC8lSG1T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEF21E861;
	Tue, 25 Jun 2024 00:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719276701; cv=fail; b=pFbVdLIo+4Ry7J7LZvPB7Byj1t8IGLJoIRytIUTpfWqPtaDfKjExF9QgTmK/Y7qZIhJrA5KTnZ2vMiu+1rekYGkXVQAU+kaAHWgCUKaQGNDqsUlQrqetNWi0hr18otASCeIRml9S5Yh81+m06JREXFj4pkyagGmcxtamabjUyUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719276701; c=relaxed/simple;
	bh=P1PUHAQD+PpO1Httsy+8b2eD/kC3rpws+1gbiAH3lxo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iSW93+XbXZeutpHjrjQqdnny/5qNlZfR5A9IsAZ6CH2L0Q7tWBOc8+9hi4Rst2089zmBrOS5lfWF2FWASglw68jUiV80nI+A24WFGs9LBoz9seRdH2yHASja2HCKSNjFyASc1CHMs9vs9z61urOHcc1WCO85PUih7ZVZGkJzDII=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PC8lSG1T; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719276700; x=1750812700;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=P1PUHAQD+PpO1Httsy+8b2eD/kC3rpws+1gbiAH3lxo=;
  b=PC8lSG1T2Tmi1GRx8FI+v1WQ4mEUZ5BXLh76zF3YtzP2wStuwhmhr2gt
   qJuABe9CKseFumML//SEWkyjHMbS9UcmTR4f8t9mYj2ohGG+/iIQV2jT7
   R7zQXhf12tvshtzFQ9lyr83JP89//Yv+UB4awSf7/RgHYC4pEW3aT37Fz
   /1Rbk7zJrIS0T0yZD6UIFi6O8OiI603Ni/Z12NUxcljFEhnpQfUF2Hoqt
   MZcP+ZNrNybXufzben4C5B6Ye8Ag0gH6DKWvDCsRnTCba6QzXqCMCpWw/
   KoiQhBvdsdsCh2IAtHi9G3vopYJrDdDeVoFROvBnesJtTAbRfxvDDw07c
   w==;
X-CSE-ConnectionGUID: qqZtxnsWQRmJE1KnCqfBAw==
X-CSE-MsgGUID: 3f43tbH/TTuteBcMWzsPdQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11113"; a="12228697"
X-IronPort-AV: E=Sophos;i="6.08,263,1712646000"; 
   d="scan'208";a="12228697"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2024 17:51:39 -0700
X-CSE-ConnectionGUID: tZ7wx00qTOyHfGWfasQUxQ==
X-CSE-MsgGUID: zYyc5KKzRQykZFUCHb+jYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,263,1712646000"; 
   d="scan'208";a="81010659"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Jun 2024 17:51:38 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 24 Jun 2024 17:51:37 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 24 Jun 2024 17:51:37 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 24 Jun 2024 17:51:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lsdCUcxERJj6tYGWM8By+9kOJoU+hqnKhX6yqdYH6DzyQSyvuwex0H+vSfjh9xvd3JoSu3KeYTXrEIp2h22MuZLPBwW4FfQeI1sVWPIzj3+k1qkQEVZrrm77/loJFTotXsmSj/KDAdZiLcJku4oLSVcMqMTLVvRMG4tOAjg7nCRZM162J4x9c+qYMSH80A+e67CPAkkBl4YYyqkrzXo/6UDcKyXlHKyquLXqQjUcAXDTBLiYUwqyA3n7r9kr/mXu+K2IFYjCQAU0Fy1abxkryLyJXFXWFlalWJ6hL8es04JqNbGH6sCbtZCub1rQnIrchrSTk0KAzQ55t4DoSAF6UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P1PUHAQD+PpO1Httsy+8b2eD/kC3rpws+1gbiAH3lxo=;
 b=A3mnwI/vlXJBQTJbUCwnW3tnnecmkEzyL2m9E5xGf69Gn1KPokDvaXC92wOb2hi0IO4He9I0dprslog9CSLq9WPupEHRXD2XIuDpsOn8yehAte4CU+cNWE+iLjKTytCoHO/xQWrKVpmcgJhpfayWTuq1DINwynsBCGkNbFPV7EOa0WN6FNylNa2rfshyzbiaF082zqixzlw2D2W6Oc/PrLUkfAFNLPx/iYiDAYRtiJLJLKzZFp5GUCv25ICXcQag1yUM5wfSyGoknTgd4gz6ZxkWYdL8p2n6jG3oHVJ4hqPrtFjqhJ9Qdbzl6lMKUgspPzL2ELG5xPk0ZiU3qmY58w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB6957.namprd11.prod.outlook.com (2603:10b6:303:22a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.30; Tue, 25 Jun
 2024 00:51:33 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 00:51:33 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v3 13/17] KVM: x86/tdp_mmu: Support mirror root for TDP
 MMU
Thread-Topic: [PATCH v3 13/17] KVM: x86/tdp_mmu: Support mirror root for TDP
 MMU
Thread-Index: AQHawpkqUontib46sU2zk5qqIlBj6LHWnFqAgAESGAA=
Date: Tue, 25 Jun 2024 00:51:33 +0000
Message-ID: <b295497932e8965a3ea805aa4002caa513e0a6b0.camel@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
	 <20240619223614.290657-14-rick.p.edgecombe@intel.com>
	 <Znkup9TbTIfBNzcv@yzhao56-desk.sh.intel.com>
In-Reply-To: <Znkup9TbTIfBNzcv@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB6957:EE_
x-ms-office365-filtering-correlation-id: 27392c95-ef52-4545-76fb-08dc94b0f5af
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|376011|1800799021|366013|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?eGtaVFkxRVI1bHUydXVSeStFQ1JBOTg0QW12YUR5cmNaN2lDeDFibU4zSnRY?=
 =?utf-8?B?M0JpU1VmcjdkdW5XVkRUaG0zdHk5SmI5aVNzeWo0MHBVZUowVEw1V1JIZlZk?=
 =?utf-8?B?ck12RGg2dm5ZOVZjQkNDWW1UdFM0Z2ZMdEJKNUYwV1FiYkQ2ckoyRy9HeXBo?=
 =?utf-8?B?Um9GV0Z4ZVU3Tjc5cm84S3JPcVp0L2JwbmFRRHArbUU3STB3VkN1RHY3MCtB?=
 =?utf-8?B?Ly8vY0JtV2NRZWFrNW1ZQ1hZVGJPN0JzeVpOeTVHRmZKRmZPWEpQUEFlelhi?=
 =?utf-8?B?L2RacUVualVXNVVJcXE5VlVEYVBMcjRuVlVGU3JtMjRQYVMyMGtZNnY4d2E4?=
 =?utf-8?B?c0tmeUxWNVZ0U2hYQlJVSUFIVHhLRFRsUzM4bEkvWjdGdFhTeXhQWDY4SUNN?=
 =?utf-8?B?VDI0VEYzdmVmczJPWnRaYUFxTFozdm9GMlJjRnY5OXlsTUZPRlpZa1U4bmFV?=
 =?utf-8?B?V2pnejE5T2hVQUxwTFY2dTZnTHc1d1JUZmpCZURHSGZueHBOQXF4VzVsQWhV?=
 =?utf-8?B?NjFtclRGV0htS2VQbkpucHdQTEpJdm5Jb1RyVVI1ZVVwVmhmSWNDUElJTTV3?=
 =?utf-8?B?WlZsb2lJcjhIcDlrZkJqZTZYaXo4U2I5RmE1eDNIdEIwbTd4RVlkWmxZTVZG?=
 =?utf-8?B?dER2eHZHRjQ4cC9mY0hiVjlLTCtZT0tObFBWaTJ3N2F2cWZPbHFZTXA3TWo2?=
 =?utf-8?B?cDBVbFNxamFYSkg0aWtXUHJjTklUTjh2SmFCWGpIY1ovdUh1NmxDNFRuTjl5?=
 =?utf-8?B?b3dRd2lTRy9CT3d5SzdiUVR4alI0UCt6L1M4cmZpaFpTT1h6Qk9mRjBHVnJ0?=
 =?utf-8?B?VlFjZDFMMUNFZzU2THN5QTd4LzJLVE5QRDhEQjYyclB5UVVkYS9mNEwxbzk4?=
 =?utf-8?B?aHlGS2VkUkFPL0ZzU0FUa1F4clQrWE5JQ0tUQU5SbitpZWRtWXZRTHQzZEVy?=
 =?utf-8?B?ZU83L3BGRWdCcmNqUHhLaEdDT1I1dkRxdGg0QitkdHREZ0RVVXdHbDlZRmJy?=
 =?utf-8?B?ZFhla3plL2ZyL2VOSUpnNzF4RG83anM5T01MdVM1emVKYjg0S3RXSEo0bXkr?=
 =?utf-8?B?cHB3NjhoNiticUhIWWJobmcwejJTK0I5WUtqRmd5S09PcXRsTzRkV3VDWmZE?=
 =?utf-8?B?U3lxa0VSd2syTVRsZkNtNTFhbDRMeEdxa20vZjRWZ3YvNzlPbUpRWVJab05s?=
 =?utf-8?B?Q0dqSnROWDh6M1hZRHFZSUlvK2wyMGhWYWVFSzZPTmlmZlYzUU1OVCtGZjlK?=
 =?utf-8?B?VTVONGtBalZxVnNHL3hTZlhIWk0wT2xnVkpkSVdnSm1pRUw0OTNzN3NvdWIz?=
 =?utf-8?B?T2JiT1pLRk1nSTJDR3VVWUhyakJ5dW91WnNrMU5TcFFLQ1ZSbFFqV0NSMm4w?=
 =?utf-8?B?NjV4dkJyd3VmcGJuOU8zV05SK0JoZDRsVkpOeEUwdjFmZTV2Z2E3aDIzbDNq?=
 =?utf-8?B?UnkxNTQ4VEVRQTFCVzVLZnZ6cmVlZy96dS8zZXN2TzFsMXBxV0E5S2xRRXRL?=
 =?utf-8?B?QnA3TnpHZWplbFdteTluSFYxWFo2eGVEZ1pSekRMbTJYVGRtMCtTbFdhQlMv?=
 =?utf-8?B?emt1c2RxU3d1N0dmdFdLZGtzNUJNM1RDeFduSnRGUS9GcU5MdVhkcDZHbkdh?=
 =?utf-8?B?V3B0Nm0vMlJaK0UvWWNwb1JXYWw2MDZ1OEkwNEh4ckVuUkVyMVViOEJnY2l0?=
 =?utf-8?B?eGhqcStxdFBPRFdSZERMVVhIRGhMQ1ZLOFB4OVRLYzVYSWovYm0wREtpdHll?=
 =?utf-8?B?M2lxL255TGVYVldjTWs3c3JIZGVpaGtaYVpKbEpadU52bmVPaDVvakMzYmxn?=
 =?utf-8?Q?OP9hWf4LhgBLbM34fEAgWGjaiDjjle/Sv+T14=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(1800799021)(366013)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?REMvWW0zOE9PM0Rrb0gyTEJRanUrOHpHVkZyb0xpYWo4RUdrbHFEeVBOWGdp?=
 =?utf-8?B?WHZkVjV5YjBmKzVCdTJTWmwxdFB3aVBzOGVFRGtMcTdhSWN1eFlYd1J0WHpC?=
 =?utf-8?B?SWdLNjYybDcrMmlERDhzVlhIbWFSMC9tUndyV1RuNWZzK1M2T1EvcXZRTFZK?=
 =?utf-8?B?a05BMWJESWgrN2ZLcHhtSTJNUWNSUythSm9jbE1hck1ObXU0SGZUUS9nMGtB?=
 =?utf-8?B?ZlY2eFdCMVhWWkF5M3ViRGc0a1Myd3c0R1RnOVhDdUhoVU9GVWFRT09aZTc0?=
 =?utf-8?B?ZzliMUFES3Fmd2RKWFBFQW5OTnJLYi9HVWdnekNEcWNxZXo5Y1dZMU8vcU44?=
 =?utf-8?B?bGxSUlJBNE9VU2t1Rm9GdC9uT2N0YjlYWWI2dnNDdys3R05vcjhZOWJhelRk?=
 =?utf-8?B?aFpzUVZkakliZVgreTFHcitYeFVhU0o0YlcxZStmOGxiOGNTb3FMMThlYXpM?=
 =?utf-8?B?WHkyUmY2L0tKcWNBVnMrRU1BbTlpNTRYUHpXOGdpUGpKeGoyNk10d0IvaERD?=
 =?utf-8?B?VDUrY3FEZHl3UDBVQXJRZStVNTdDb01qZUhZVHlGRE95NXhzUWRRYkNzZlA5?=
 =?utf-8?B?OE05MklqNnB2U3pxdU1tbm1FU3dCRUF2OExSb285UHV4WUFjbURjZ3pIdloz?=
 =?utf-8?B?a3ppSVhlaG9oemZTOFFGRmRmOTVtRGtmTW5reU92YUxua0RxUnFLSThXRXpC?=
 =?utf-8?B?QlVqVU4rZm82WEhQamF5b1pSZTZwanIwUlFJMDBYaGJsM0RFOVZHQkNGcmY2?=
 =?utf-8?B?U2ZKUWhnNTF0dVRXQ3NZSmVwWXdYNmM1NExCRS92eGxybEF2dVkvNlk2ZnNy?=
 =?utf-8?B?ZjllYkRaYUNYUVdEZVNGSlBYRmM4ek5ZZmtqOUhvTklrbWEzOURQN1RGUDhC?=
 =?utf-8?B?ZFFLOTBZeXV0dHdYNlpva0pES1VMeXorWkpERXpPcy9SMjJEUVFOTzI5VjUx?=
 =?utf-8?B?bHJKdTQzWkZGOTVtbGRwUDFSWnZGbnkrSThJQjVBK2hXbStZbDVDd0tLaGlp?=
 =?utf-8?B?Q0x5dTd2OTRETy9qUndFbXJYR0ZxVFVaTXNpeHZLMVl5R1krNmFpelhJZVdR?=
 =?utf-8?B?YVdlL2srTTVNTTh1WG1KK3A0cGdZNXBEWHJ3aGtERk1ndUNvY0g2bDZJd2w5?=
 =?utf-8?B?WXpsTjlEenhCMjlndER6eTBuUkhObnBydkVac2hCdEZ2MkxRS1l4SGZ2RlZV?=
 =?utf-8?B?UFVlMjRteTlZUEZURjVUVlFrN21Udng2Tk1EYTNGdnNSMFJrOGxOZlQ2SXpE?=
 =?utf-8?B?K2hXRnFnVk9iTGUwN21NODBPcit0UkR1V0l2SEJsaTU4NlcwU0RFRFNZdExP?=
 =?utf-8?B?KzR1bHJiTEZhcFpNZHRIYmZua0ZlWk5pMFNjNDMzc29tOXRuV20zdXl1WmpJ?=
 =?utf-8?B?NTNMOWxQeFphdnBreFpxNTZwZnp6NWtEbnE4Vzg5dHRqSERkU2U3NDYrOWMz?=
 =?utf-8?B?VHpkVmZmakZPMkVvWGFmSWVEK0gzYXNWZ2s2VlVZVFpnSUxZVlUwTFQyK081?=
 =?utf-8?B?TmhXa1A3MU9Yck5zUVdMb2NlTkRCRk5zbWtHS2RFQWd6YXNidnc3MTZaTmRr?=
 =?utf-8?B?OVVBYzRVRTM5STZHc0hPYjVyOXpwYWdjdFlxaW9TZGMzS2lTMStQNjQ0dzY1?=
 =?utf-8?B?NDhrMEV4b1FZZnIveU9hNEhyZDVybTR6L3pJQUFoM0xLZ0ZWR25ucGFZVFpl?=
 =?utf-8?B?NDdFdndCRnRNZ2VzM1hCS3pOU1NWRUhoYWQrR2YxZnVBM3lWK00wbzgyNGNx?=
 =?utf-8?B?NDRRcXhKU2hzL1ZIdW9JcTF6VHhFKzFnQVNoaU1kZWdXc2RIdGJodmoxQith?=
 =?utf-8?B?c2lMbmUydFNWQ05YVGVSaG0vc2lHNUw0RERWZ3ExWS9kR05XN2VscDU1TWYx?=
 =?utf-8?B?RjlOK0dvNXloTUQ1YTVobDA4d3dOTWRvTlJvK2tTTjdEK21YOHV1azM2Sjg3?=
 =?utf-8?B?cDNvcWVlMkJPUW85UVdqUDN1YWFlYTNnTCszZGVSUWp3RWVtMWYxNE5lTjA5?=
 =?utf-8?B?aHpWUWpjTG80a3ZPRTFmMUw2NEY5UzY4WXF5aWFCY2RxUWhMVHZwVmVZZ3ZG?=
 =?utf-8?B?Y2x5T0FJUFlHT2c2NndBL0pJcUUvclUyTmJtTXFMd1M5d3F6WGdMYUNTcVRj?=
 =?utf-8?B?UDBuY0Jsc1VDWlJGUzRkcXhiSVZ6alZaK0dMWjFhMWlFN3Y1VTJYTEdWVzdl?=
 =?utf-8?Q?4alWkVWfUwl9kz7Ws4/XQ08=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <06FB855C40FC194EA0D0BC364D2509E4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27392c95-ef52-4545-76fb-08dc94b0f5af
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2024 00:51:33.6645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dUNDTjcmfyExAp6mHlmqJFUJ4tdqs/YV0kfZCqa8W32g+42WEZGitlSxxwnLSQ7UM9pf1gl3bSSNAHkjox9V7Q4iRFhAWyCEMbTz9YoKohs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6957
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA2LTI0IGF0IDE2OjMwICswODAwLCBZYW4gWmhhbyB3cm90ZToKPiBPbiBX
ZWQsIEp1biAxOSwgMjAyNCBhdCAwMzozNjoxMFBNIC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90
ZToKPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbW11L21tdS5jIGIvYXJjaC94ODYva3Zt
L21tdS9tbXUuYwo+ID4gaW5kZXggZTljMTc4M2E4NzQzLi4yODdkY2MyNjg1ZTQgMTAwNjQ0Cj4g
PiAtLS0gYS9hcmNoL3g4Ni9rdm0vbW11L21tdS5jCj4gPiArKysgYi9hcmNoL3g4Ni9rdm0vbW11
L21tdS5jCj4gPiBAQCAtMzcwMSw3ICszNzAxLDkgQEAgc3RhdGljIGludCBtbXVfYWxsb2NfZGly
ZWN0X3Jvb3RzKHN0cnVjdCBrdm1fdmNwdQo+ID4gKnZjcHUpCj4gPiDCoMKgwqDCoMKgwqDCoMKg
aW50IHI7Cj4gPiDCoCAKPiA+IMKgwqDCoMKgwqDCoMKgwqBpZiAodGRwX21tdV9lbmFibGVkKSB7
Cj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKga3ZtX3RkcF9tbXVfYWxsb2Nfcm9v
dCh2Y3B1KTsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoa3ZtX2hhc19t
aXJyb3JlZF90ZHAodmNwdS0+a3ZtKSkKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKga3ZtX3RkcF9tbXVfYWxsb2Nfcm9vdCh2Y3B1LCB0cnVlKTsKPiA+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBrdm1fdGRwX21tdV9hbGxvY19yb290KHZj
cHUsIGZhbHNlKTsKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIDA7
Cj4gPiDCoMKgwqDCoMKgwqDCoMKgfQo+IG1tdV9hbGxvY19kaXJlY3Rfcm9vdHMoKSBpcyBjYWxs
ZWQgd2hlbiB2Y3B1LT5hcmNoLm1tdS0+cm9vdC5ocGEgaXMKPiBJTlZBTElEX1BBR0UKPiBpbiBr
dm1fbW11X3JlbG9hZCgpLCB3aGljaCBjb3VsZCBoYXBwZW4gYWZ0ZXIgZGlyZWN0IHJvb3QgaXMg
aW52YWxpZGF0ZWQuCj4gCj4gPiAtdm9pZCBrdm1fdGRwX21tdV9hbGxvY19yb290KHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSkKPiA+ICt2b2lkIGt2bV90ZHBfbW11X2FsbG9jX3Jvb3Qoc3RydWN0IGt2
bV92Y3B1ICp2Y3B1LCBib29sIG1pcnJvcikKPiA+IMKgIHsKPiA+IMKgwqDCoMKgwqDCoMKgwqBz
dHJ1Y3Qga3ZtX21tdSAqbW11ID0gdmNwdS0+YXJjaC5tbXU7Cj4gPiDCoMKgwqDCoMKgwqDCoMKg
dW5pb24ga3ZtX21tdV9wYWdlX3JvbGUgcm9sZSA9IG1tdS0+cm9vdF9yb2xlOwo+ID4gQEAgLTI0
MSw2ICsyNDYsOSBAQCB2b2lkIGt2bV90ZHBfbW11X2FsbG9jX3Jvb3Qoc3RydWN0IGt2bV92Y3B1
ICp2Y3B1KQo+ID4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBrdm0gKmt2bSA9IHZjcHUtPmt2bTsK
PiA+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3Qga3ZtX21tdV9wYWdlICpyb290Owo+ID4gwqAgCj4g
PiArwqDCoMKgwqDCoMKgwqBpZiAobWlycm9yKQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoHJvbGUuaXNfbWlycm9yID0gMTsKPiA+ICsKPiBDb3VsZCB3ZSBhZGQgYSB2YWxpZGl0
eSBjaGVjayBvZiBtaXJyb3Jfcm9vdF9ocGEgdG8gcHJldmVudCBhbiBpbmNvcnJlY3QgcmVmCj4g
Y291bnQgaW5jcmVtZW50IG9mIHRoZSBtaXJyb3Igcm9vdD8KCkkgd2FzIG9yaWdpbmFsbHkgc3Vz
cGljaW91cyBvZiB0aGUgYXN5bW1ldHJ5IG9mIHRoZSB0ZWFyIGRvd24gb2YgbWlycm9yIGFuZApk
aXJlY3Qgcm9vdHMgdnMgdGhlIGFsbG9jYXRpb24uIERvIHlvdSBzZWUgYSBjb25jcmV0ZSBwcm9i
bGVtLCBvciBqdXN0CmFkdm9jYXRpbmcgZm9yIHNhZmV0eT8KCj4gCj4gK8KgwqDCoMKgwqDCoCBp
ZiAobWlycm9yKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKG1tdS0+bWly
cm9yX3Jvb3RfaHBhICE9IElOVkFMSURfUEFHRSkKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuOwo+ICsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgcm9sZS5pc19taXJyb3IgPSB0cnVlOwo+ICvCoMKgwqDCoMKgwqAgfQoK

