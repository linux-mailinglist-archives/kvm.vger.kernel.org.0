Return-Path: <kvm+bounces-58831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C2378BA1EE6
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 01:09:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C3857401EB
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 23:09:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF18B2ECEAC;
	Thu, 25 Sep 2025 23:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ms8ZNYzi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA36A2ECD1B;
	Thu, 25 Sep 2025 23:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758841753; cv=fail; b=q2OBhbUWJtnIGWOCt7Aj2MA34mEQ6wfafX/UZRdhfoD7eyAyDJEq6gXE3rWMTUTZ9NDuuL7gZGLMJ4OHmnh9gHa1nDAjHLjio2QFtALdEdgtI4GGo/zbpB5qQNDJhybb84viipCeAHf+OaeyRlgQ3KBmM82zFINriSxMRMh40Go=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758841753; c=relaxed/simple;
	bh=4JsbVRCB2QbQny8UY6zOock+iMlM5FIiftqrabVbPWU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UQHJxjmIwzMmkQa1RjPxW22JO5cbZjZEqSSVrzGWsZOPzgPTmnsKpZ9Jbqk6ZJiv5f6b5QmYbUWG/BszUJRh0RIeHuBJAHOdbpKjwH/DqWouCMU3a3L5rmMB8I2KY9aiT6xLULA4DBnR7RKX9oqICPCmRseltEeuwkEqbcNw/Bk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ms8ZNYzi; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758841752; x=1790377752;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4JsbVRCB2QbQny8UY6zOock+iMlM5FIiftqrabVbPWU=;
  b=Ms8ZNYziPZhPH/AtMSQPv6xSA88cl+cCVdSL/3ZrAxCKKCF7cIg/jYhK
   Rd4gygDsV1XMvhoMpNr/ka2maiCvdhpcNY81C2hpXwDd1kvpJUl5KX5CE
   U2nnTY4p0q4FaWPj2BJaSvOzuROSwLWULryy+3SXYq9CCcsf+JxQb5Unp
   2b5GGbE0e6Cw0YN1j/qiFK8wyQ3mozJrO7B0PH8K23GIN3wHG9d5KkRly
   QDQNVi/3bqNl6zp2/6fV0oEJGJ+dFP2faXeiah7Xn166cIOFMf7wU0jNl
   LWqizw9eLpqTNFtLp3BVrKLVKXBjtOWfoSUs7p/BB8lDBoL+cSkJ0sam2
   w==;
X-CSE-ConnectionGUID: 9FlXes+BRDeuZ+Kg00phMA==
X-CSE-MsgGUID: OenMk8cnTRi34mDqbrdzhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="71863589"
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="71863589"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 16:09:10 -0700
X-CSE-ConnectionGUID: O71JByw1QOyQBpaaHNIsrg==
X-CSE-MsgGUID: ItuzoLtTStyu3M05blZJbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="176738326"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 16:09:09 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 25 Sep 2025 16:09:08 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 25 Sep 2025 16:09:08 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.27) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 25 Sep 2025 16:09:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QTT5YC2zuLM/tZ5o09sB7vaJ9ZVCN0CmV1W/jvlVZuJXsY88BAUBMY/CjNsCY//WT3BUdeYfvb0nOIytyy59uvhUp4hVzH0PKIyPaxPkVYRRoyB3B6WcPYEDjRmb0dKAUymEQ9Wh5hECUls9qaPD4OWyRZ2oLHCqXuvl9esVxBRUa4/hLXzJQ8Zheol6p2j2Tm3ZdqpU3yY2tq3qGN/fhOtqMRIlQ9MOBSj3j3Zuisc/inQs/bLPscr3koGeQmWgA5EJ//IC0WDyTWsgGHx7bQlIVXCJboybP0Dq3IMmDZ2No8RyrmI9+vvs0ufkHpy1izm04oHiWYLTz9fpcjMI3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4JsbVRCB2QbQny8UY6zOock+iMlM5FIiftqrabVbPWU=;
 b=Zr1YYxjxMmAsxdawIJCzCymNVlNd/l96ZI7uTPZzNp0+mJu84cYD5XhuBIhBiRiStoAbahLLKk/mRtFbLEXviY4Oe33Zm670BNFCHtflgVpB2ePUUZFKpUjiwVqq7weHV6xOsMmEnmYdqmqdK9nUXbp9Rq8Y5sg6Bhl/NiHmZpTaZnLHe7Z8sEVHuvoW3+cAzPNKDy7aYCPLHQY2mCh8CQyDMUr26aJXsznQ3ElQSoA9Ist63xiOA2RXh3VzHBCQlEZ+O78YEDEZhKaTapZoik94a1+TGKNej2rapZMWMBEO2SX+xF8Sqrca6S3Ek8F5Wq/J4PFslhJ2MXUh8NYdFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM3PPF4C5964328.namprd11.prod.outlook.com (2603:10b6:f:fc00::f1e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 25 Sep
 2025 23:09:05 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 23:09:05 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan
 Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 01/16] x86/tdx: Move all TDX error defines into
 <asm/shared/tdx_errno.h>
Thread-Topic: [PATCH v3 01/16] x86/tdx: Move all TDX error defines into
 <asm/shared/tdx_errno.h>
Thread-Index: AQHcKPMwwODp7//+PEGBZ/2ZnMIQ/bSgSbMAgARHLAA=
Date: Thu, 25 Sep 2025 23:09:05 +0000
Message-ID: <ce717a9a5a7539b38b19115e0d3fa11306ddf9c3.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-2-rick.p.edgecombe@intel.com>
	 <76019bfc-cd06-4a03-9e1e-721cf63637c4@linux.intel.com>
In-Reply-To: <76019bfc-cd06-4a03-9e1e-721cf63637c4@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM3PPF4C5964328:EE_
x-ms-office365-filtering-correlation-id: a2127c5f-6918-4183-0626-08ddfc888610
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?dHBMYnA4N2J3QS9rWEFDcnBvUnl1bnoraFBvQmZwcUhVNTJ2QUpzRHpRSUwy?=
 =?utf-8?B?SWlvcUFWUzFHRGUveFpUNWhCY2Y5d2ZuUUFXcTB0cWVEYnNGZEtadmdGZmF5?=
 =?utf-8?B?andYaWhSUDJjZlRBbjhFbVJvWWxRTG5NRVM1TVdGU1p5bVdmWDNoWGdZcFVQ?=
 =?utf-8?B?dlNHMUxUN2pJSjc2bDlGWDFXZlVsOHAycjdON0p3aWlVZktnWGRZOUtXcEVL?=
 =?utf-8?B?WVVOemRCK3dFNzRUdTJnUW50QTl4YVU5RjY4RCtJd2VxblJoOTFBelpNeVho?=
 =?utf-8?B?T3k3K29Wb0F1SVpMU0NaSld3eVhLcXBRSkFUbll6RWJRdlJBQ0lwdmZsSGhS?=
 =?utf-8?B?OC85d0I0d202RVdlcDVpUmk5NFNyUE0wT0dIbGRTREs2SlArdXhhZ1FWSG9y?=
 =?utf-8?B?VmRCbkliNFROTGM0Zko0djlxRXlZTENlQld1SExRRGQ2OEFTY2lkNWgrMmFL?=
 =?utf-8?B?ckppdlp2TVJrT3dyMzlUaXllR0NBRkhUVTUydTJoZ05ZS2dqYUFiM0dLMlNK?=
 =?utf-8?B?UThXQmw0NFpQRCtmcTBaLzRqY29FSjM1TDErazJaWWJnZDhoS2RtUEVOc1h5?=
 =?utf-8?B?M2luM1ZScTBEbjBtRnF1Mm90RFl5TDMrcGd5VUdCNHB6b1liQ20yYmxZUWdP?=
 =?utf-8?B?bTBWY1VqWXg3cHlNZW1xK2p4MVdFZU54YllKMUFpckdWS0hiVE1Jc3VqZDc0?=
 =?utf-8?B?OHlUSWR0UlVFUXpMd0J6VlA3MTE0bkhvN2wxaE5PTzc3YklUampBK2VjWG9M?=
 =?utf-8?B?L2sxVWtRdkUreUd5YzEvRC82Vjl2YTMrS1M3N2JWSGdUdWpGS3I4bElncmhy?=
 =?utf-8?B?Q3BScTJkSGdNbFd3NmFmWUJhRjhqS2hlbzN4dXpEUkJTc1ZnbWhZT0dkSVVi?=
 =?utf-8?B?b0tpZGUrK1MyRnI4SmJtVW1Uai8zSGM2eUhUVGNzTjVvdlpSUmx4cmtobWFL?=
 =?utf-8?B?TktoUFMvcnN3K3hOS0RhVTdqMFRjWGRmSXBlcFlIQSt6aXdCdlRFbUxBMnhx?=
 =?utf-8?B?Tlhtd0RDNVVXR3ZnMnhkQXJvZWVrQlhEcTVSeldXMU80OTZpcXFOd1F0OGcz?=
 =?utf-8?B?aE80L2I1VGd6bXljOGNQZ2JDNmdxZW1VbjFiNDN4N3NZZUk4cnFYYVlJOElB?=
 =?utf-8?B?N1AxVXFySWNEN2pJdDZBVnM5cGRwaXhXTzVOekFkY1pnNm5NZVBNZFgyZUgr?=
 =?utf-8?B?ZDllWkhCZzViQTkxaEtjaG5mUmdwRmR6NnNSUFBGaXd6dEw2eFlDWTRHc2xF?=
 =?utf-8?B?ZVI1UWxHd1cxVW9hNUw3WkJYOTZDRUZvTDBNUDUxb0NOaVdZOGdMd3g5WWVw?=
 =?utf-8?B?MXdZK3lZeXZTNitkaWFXVmk3YTdwSGw3a243VTRZWHlUME1YdDZiZE5MdWVY?=
 =?utf-8?B?QkY3RUR5M0dyOXZtZXBoMThTY2ZvK242S0ZreWlsQ3pSaGszVHh4L2lmRFRR?=
 =?utf-8?B?K2VYMWpDeVlITUJQeVo5QlFiZnZHcXhsRXRsWDY3MkJQYXVWSEsyRmI2RkVV?=
 =?utf-8?B?dmc0VmR6Q2pIbExvVHVFMVRlbnRXYktGQmQ2WUZBWlA2aW9XNFNXdWlhSnUz?=
 =?utf-8?B?ZGFnRHB5NE5pTkMwd0JMNDhTUllnb3lNMXhGUmk0WXNHTFdxTW5Cd3VIYTgw?=
 =?utf-8?B?SCtBOTIxZFBweW1kOGN5VXpGYXVyNDRDdGtRd1ordXBIRzNUZThGbm1Icm5n?=
 =?utf-8?B?ZG1hN0R6eTdLU2o4SXNSeUtyd1l1WGFuYytKWE9kWGFONmN2RzV3M0NDNGlE?=
 =?utf-8?B?bHNXR2VXQWFhQlUwa3dseUVoT09GL2w4cXY0c3p3NElKdlNmbEp5OVF0U1hB?=
 =?utf-8?B?bFRMNlVuL2UwZTJOUGtjbUNXMCswTFIvcDI3OW4vRmliL0R6bnV3WEU2UVdw?=
 =?utf-8?B?WVlyalZjOEx1NUZUQ3ZuK0xhSkk1Z3R2ZDVQVDZvcGtrMzFlVE5BUU1KbDVl?=
 =?utf-8?B?Z3FCandRUFRUVFZ3UzNrZzN0YXByOWF1Z0dTN1VwVmNkTTE0eDZkNnAzV0Z2?=
 =?utf-8?B?YjNxYy9hZGVRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dzBpejRud1JrNXJmZzFhZ2RpU2JqOHZLREp2bENwSksrUkp0dmlTUk80VlBw?=
 =?utf-8?B?eUtpbDEwYlJ4VVNtRlNKN1hPTHJLT3lZd2Rub2VsRDRwanVZR2s3cU5sMldv?=
 =?utf-8?B?bzhoVGZGVmd0bGY4L2dUa3kzVTZoWmJZMjRrV1pBSWN1dDYzMnhwSE9la0h3?=
 =?utf-8?B?ZDdUaTVFcVBlN2tZTDN6Q04wSjl3eWZ6QlZrNW9DbGZHd3B6QUJza1NqYVJr?=
 =?utf-8?B?bEV0Ym9FVm1YdWNKcWJTNkZQZ1hpQlRUSDdEd2RFL3FaWTBWUElLeUMyYTkz?=
 =?utf-8?B?d0NUV1U1N01meGpYTHBBYlMzT1JOWk52YXVrNGtZYnJZeFhSQTN0Z0FzQVhN?=
 =?utf-8?B?NEc2MG5zeEJKZ0x2Nm4zRWhJa2RFVWJYZlJiWFpjK0hkZEw4SUZuckZ2c0R0?=
 =?utf-8?B?MFNRSld5RlVLNE1hSDkyVVJ2SnoyOWNkdktJM0RBTS9xUnVCVDE2MEdGa1dn?=
 =?utf-8?B?NFhBbFAyelhNQWM1RjhSNkozTk1McUxTdFRGaVlUa2pTa1dNZG1YQUhXUm9I?=
 =?utf-8?B?MUFrMHk0WmMrRlJLd0t3LzYwSjY5M0c3bWFLTzRkLzRDeGJHTWJFUWgrZlQ2?=
 =?utf-8?B?WG9ncFgvSmN0b0RPS2ZoRjBMTnE2MmRQcDBFK0xmTnR5bjB5RXpNeHdER2tI?=
 =?utf-8?B?a0VIRGtkbGU1L1hUN0ZvRFlFSzQxQ1pVMkN2OWl1QTQ5L0twVnkxYmFuWVlB?=
 =?utf-8?B?cmxWVVpjbWN5emExN2dOaWhheHNXQkFkN2trT2lxZlVsVnhqVGUvU0RIclJu?=
 =?utf-8?B?a3QvbEk4SWxtU01OU29JOTljb0JWd0xITWhKV0NGMXJWamlNbGtDN3RhTURr?=
 =?utf-8?B?K2lBMjE2RVFtN3JvSjlIR3pnNjEvM1JCWTNCMjN4dXY2L2NwZ1ZLZkJCRHk2?=
 =?utf-8?B?S0NNSU5IY0xYdmxMRlRSYXE0VEpGVS92WVNKSVZUZ1JwOENyME9DV1JaNHd5?=
 =?utf-8?B?ZlFHVFh3UkxmMlMvUUVKZG9EdUZVOUhCYjJoZmJBRFcwMkhONGFiVGRiaW1w?=
 =?utf-8?B?ZGNIUmlaVm9GLzNmNTBjSnhLU0c3NElLUUsyNHVHNGhrSEpEMTREcTdFSzFa?=
 =?utf-8?B?MTE0TGpvN0NXTkordFRpYVNvUllxRjBBYS9vMkNvOSsrR08rOU1yNkpkNG9o?=
 =?utf-8?B?R0JVdnczVUUrVStXcWVlMVlaQ0VJQnZTampYVmxHWnpRS0sySm52WVcxNVo2?=
 =?utf-8?B?SkVGcnB5WXAyYmJoejMrOHRMNlh3ZXFzbjBScjQzSGEvQTZUL1dWZ2FHa29K?=
 =?utf-8?B?Qnp6ZkIrV2x3RUV1YUVnRFR0clcxOE12NXRHd3pza3NxUXZka2xBUkl3MG1Q?=
 =?utf-8?B?NncvOGk0V1pUbUtLUmJLbFJrSWRURytmdVBTWVUwWTNnY3N4V2ZCTHpWMW1r?=
 =?utf-8?B?ZzJVbXVCWEZFNld4OUdEd25jVi9jdDFNZUd6RXNiT0ZtM1Y0RXhCNUFzZmJL?=
 =?utf-8?B?eWV0OGhHdlR1ejdlSSs3ZmFSQldRRHEzNmNjM0dOREg5Z1FyMzVBUFVUN3Z0?=
 =?utf-8?B?Mzk1S2hsY0xJSFdSMEROeTExMG5lNkVwbkVWUjd1ZG9URXhFR3hUT1pTRGlz?=
 =?utf-8?B?N3RnMDJITVpseUZyYTFsaXB1eFZvMmN4dXZnS09scVpVYko2VTVTaitWay9z?=
 =?utf-8?B?N1dCamdlbVBMcVFRV0dCaHIxZFo3d2VFTWQwK1kvWmlqUkZZdnBzSHF6NC9N?=
 =?utf-8?B?bGlwTUppZVNId3NFRGovRm9QaGk0ZUdNMklzSWdybUpNMUMzd1dBQ2gvbDNQ?=
 =?utf-8?B?MlRjdVhuOVp3SXJnOGhBUy9sS1J3cHhDYWxqR2hnaDQ5cUV0cDhZS2dSRE1O?=
 =?utf-8?B?L1NaVG5mK1IwQ3EvdUt0SHU5SDl0eEdCR05YK3hXYkRIWlZ0aE5obEhOZFIw?=
 =?utf-8?B?STNlL1VqTlVNSEg3OGovNE1GTVJ3NlJleklEakJTTzdieWxtcTlqQ1ZXemE5?=
 =?utf-8?B?ckhENkZCakNyd0tvT1lyOFY3Z05oRWgrdjkyTDZGbEhwdWJqeVVuS3VxaWpP?=
 =?utf-8?B?Tlg0L3RIUW1KRUJIdUpJNThBd2Y1UHRRREtJYjY4MTNpS3Y1aDVvNlh4aEQ0?=
 =?utf-8?B?SUhZSmdBV1pZOE1YYldSdXV5WVBBTnBRNFdERDhsL1l3VkRRV3A4MFJpL00v?=
 =?utf-8?B?MFVCVXY0bmpWOHdTdXFNTXdNVFhpT25rWHBYbEFFOWw0Nml2OVloUE16blNo?=
 =?utf-8?B?WEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FEDB477347F76C408A3CC6A728F6B2F6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2127c5f-6918-4183-0626-08ddfc888610
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2025 23:09:05.1068
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HpfW3RLjJymhwvDcwUWvNyAhUr2QO3/Ka/0ODLxHK603VmJlsWNfvv9jji7q5RG6QMR+PnA8nwrZT51HLfjMZ4iTG8M48yrnPeZvGpaYtfg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF4C5964328
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA5LTIzIGF0IDEzOjQ5ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+ID4g
Ky8qDQo+ID4gKyAqIFNXLWRlZmluZWQgZXJyb3IgY29kZXMuDQo+ID4gKyAqDQo+ID4gKyAqIEJp
dHMgNDc6NDAgPT0gMHhGRiBpbmRpY2F0ZSBSZXNlcnZlZCBzdGF0dXMgY29kZSBjbGFzcyB0aGF0
IG5ldmVyIHVzZWQNCj4gPiBieQ0KPiA+ICsgKiBURFggbW9kdWxlLg0KPiA+ICsgKi8NCj4gPiAr
I2RlZmluZSBURFhfRVJST1IJCQlfQklUVUxMKDYzKQ0KPiA+ICsjZGVmaW5lIFREWF9OT05fUkVD
T1ZFUkFCTEUJCV9CSVRVTEwoNjIpDQo+IA0KPiBURFhfRVJST1IgYW5kIFREWF9OT05fUkVDT1ZF
UkFCTEUgYXJlIGRlZmluZWQgaW4gVERYIHNwZWMgYXMgdGhlIGNsYXNzZXMgb2YNCj4gVERYDQo+
IEludGVyZmFjZSBGdW5jdGlvbnMgQ29tcGxldGlvbiBTdGF0dXMuDQo+IA0KPiBGb3IgY2xhcml0
eSwgaXMgaXQgYmV0dGVyIHRvIG1vdmUgdGhlIHR3byBiZWZvcmUgdGhlICJTVy1kZWZpbmVkIGVy
cm9yIGNvZGVzIg0KPiBjb21tZW50Pw0KDQpUaGlzIGh1bmsgaXMgYSBkaXJlY3QgY29weSwgYW55
IHJlYXNvbiB0byBjaGFuZ2UgaXQgaW4gdGhpcyBwYXRjaD8NCg==

