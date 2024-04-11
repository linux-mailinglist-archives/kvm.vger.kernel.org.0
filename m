Return-Path: <kvm+bounces-14336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D402B8A209C
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 23:03:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B01B282CCE
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:03:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 104D83D0B8;
	Thu, 11 Apr 2024 21:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LDxrUYkV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409F03A8FF;
	Thu, 11 Apr 2024 21:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712869416; cv=fail; b=WmEaXPWCOXhw3hBYElgAffj8DmvzBULsx+BX0ckGS7oLrkwihmnZ2r9DfjTB/E3qy4xClsjnEhhFAXOlYEWTls3I3vw7ydjQt/6qHnd1veQZHHdy3ee9al0MVJc23mPoyMsdpwBqWRv5yyQrxml56I1AC1g4N7bVXdK8eJB8GLs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712869416; c=relaxed/simple;
	bh=b0CMyegXJM51RpCw1xRu8z1/Jo+lV3RTenS+i1e313I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lTv/AaqGp+KzRnCf007PSKgZCg/tTldpz4nRXly655DWFjdITxzlFTPbBJi70GlWgrp4vOKZM8qtepsu32H7WT8FIp+UFhmp4k2fbZVs6KOXBpe+dc6Q+gnU098TG0B4wega9mhnHRIm95VcIFHBwKSJDCT/ysFY6SfXK3GnT0Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LDxrUYkV; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712869414; x=1744405414;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=b0CMyegXJM51RpCw1xRu8z1/Jo+lV3RTenS+i1e313I=;
  b=LDxrUYkVwReb+yIAKM3pou0FedGU6JcZBksVNtrVIX6WfMh7sPBoQOO9
   rRnJvNA+1LRuYYfHAMqawDrkBirESi62xLy0+wBYp4R+9gbieHDDRyvyB
   XvKVcxa44nOtYIn8AzJs4eoVHhUm/hHrI0/uGffXLRfvWxgaIHQN/7Pc8
   go4vHQoy7jcyq2LSogWzKzSqRzD2sR1/S4ipETt95ZH6HzNAMWTpOFnTL
   ddFn4weLQNLCi+Ag9QNE9/GBE9sJBC/J+QMKz/Hr2n4ppSuafWrKK2Pb4
   dbGazkvAHoYNWsM0rYdF+a8LkwQuYWour5ltSFvRE0VX5H3ZuABd5XWK2
   g==;
X-CSE-ConnectionGUID: +TOF9xl4S1uPwg9Nls+wrg==
X-CSE-MsgGUID: EXBiY6p8Ry2C7OuhAZ6QHQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="30790773"
X-IronPort-AV: E=Sophos;i="6.07,194,1708416000"; 
   d="scan'208";a="30790773"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 14:03:34 -0700
X-CSE-ConnectionGUID: VN4Bmr6LRoSLpl6prYIdAw==
X-CSE-MsgGUID: AZzPch2OTkGrQfCjT01wSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,194,1708416000"; 
   d="scan'208";a="51988417"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Apr 2024 14:03:34 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 11 Apr 2024 14:03:33 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 11 Apr 2024 14:03:32 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 11 Apr 2024 14:03:32 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 11 Apr 2024 14:03:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mTbWX1KJmLKOBgNKllKMMHD4UCYySH3GqKSeont9Tk98xzdA/xglXeO6HQR6xU9lF4Ox40dDG1wi+G8C4RFT8cc4viP18QCq0Be4ztKUH79x79J88JRUerjXbLOTwzdvHO8Z+8rVEAfx53O4MUVhvkmEUNZ7uyFG9Zi2HF52z94D4GPpwYK6O6YihJagXinM7iE3pZ+40D59wwZrtM1QTQFnPC4UpsBr8WJRk6TwRKpC2bLlWlQF+CcCVgV8t3dbyFW8xd0JCRM6WxGzms6MrtaFWokHUWimzgzRKxguZh4FQX6C970fJRlSHq3Z6x5bYB4d2GIlUgGwTefsyFYWQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b0CMyegXJM51RpCw1xRu8z1/Jo+lV3RTenS+i1e313I=;
 b=VyYO//Ju6xjeeYchy02evMDezHQz+5H0awXeRqKrNuHSBMcuRGkSIW3sT5B8v6F2QmWYDmetJqHsH6cHpCkzgclbRHWeTZZ390iDO4FWq9Bj41YcZLzjpbOqX1auc9nF2NW3g5GofOUdfWjX+1T86Jh5cCW7dGV+sgPlm0z8wpHbuGL/t8Z2QKi3d/HX5Lig3uelTLwDwWn0udOObrwuXdIKuAEWeoGXAvXHlLLwzqAY53c3ieRCKT0qOn8ncafxEUOnYilCizIGtYScDxgCjFunXC1JE21OV/AACUb4Tjh+YSPBMv/vEOv1/pFycN2dRRzz5PK8gZTJwzxYPhUt6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB8349.namprd11.prod.outlook.com (2603:10b6:806:383::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Thu, 11 Apr
 2024 21:03:24 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7452.019; Thu, 11 Apr 2024
 21:03:24 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>
Subject: Re: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Thread-Topic: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Thread-Index: AQHadnqikJftpAPTRECy6a/NFCG2mbFe2xEAgATEWoCAAAcHAIAAD0CAgAAEuYA=
Date: Thu, 11 Apr 2024 21:03:24 +0000
Message-ID: <6c5626b8ba914d8ceee2cc627851a84a93405abc.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
	 <c11cd64487f8971f9cfa880bface2076eb5b8b6d.camel@intel.com>
	 <20240411192645.GE3039520@ls.amr.corp.intel.com>
	 <54f933223d904871d6e10ef8a6c7c5e9c3ab0122.camel@intel.com>
	 <20240411204629.GF3039520@ls.amr.corp.intel.com>
In-Reply-To: <20240411204629.GF3039520@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB8349:EE_
x-ms-office365-filtering-correlation-id: 5c534586-ff32-4b1e-86b8-08dc5a6ad3ce
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Nuctw+OocpuNkGypEbMt7M7zw9T7qqADNlW1fNSFpg04qyhBUUVMoT+mkydOYZwomWGvfoEGetNwkPLmdy+piyOcZNa6oTLwo9zE+8YM7ipH6GyeHsOnIjWgPbdopidwojY9tJ4H4L8epp6CxCWrLKBmv9I/jmVqaS5mPX4eQHvcePnB+MCE4f4ICexOqc0CSmW+NHKkiFOEf3KaC2lz2sIVqeRUma17rNOVyE4bRVsRyQcprnn/JNiyaIy/y8sRWIT3KesgsuFYn3JdwBXzgNfDaJAovT+F7eJWIEqL3tzJvw2G/EYQDoBJfn4wY8LoQ3Pbyo8kHDzq3PwaUQ8rJJi5J+AiSoXnmoaQn7N+t1OQBVq6HxgpnGAzU7iRTIFkKCguGdTE0VsozeEMOBb1vOv18ALVJm0tRVcmGXkJ6P17mCnmhc+IW7iIz3COj6vW4ch5zy1aAhwTcxadGPvOiPKffgncSBBkhH9yorjUvOaspStKZfnX5BRHg+d+DKZjhGo1FBZDjJsiW/ZEXlNTG8AvJZ/DjC2n1GbN0L5ZAqrOwL8g/sFyEsfqbq3EBtP7rNNi2wqkGbFmJ/EeeNl6m4Cw7L2EMCSqpPLsW5bdYawl2bK7IJG6klSct+lHOkPg6BL8IJNyLCnmYhf9KVKvVY9tu8XnSwEVlqXcMfBh06T9I3ZwYf1xC/lz1l5/B6yf7Ohod0n01bMzt9B7dh85wVOb69tXdrusqSjwHL8/Pb0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TjZpZ3EvZ3k2ZWtzaGlGV2ZsTUluOTg4MzVPNzlORk1WVVJtVzlySlk2Rkw0?=
 =?utf-8?B?VHBLNHZLUjNQWjNuVmdBU1NrRmdhZ0pBbmlLOGd1b1NFSFNBQjNaMml6eWVX?=
 =?utf-8?B?RTM2cHdsY1NSMGJnY2o1ZGs2WTJ0Rk9DRW8yMzlXVzY1bzJhdGJVQ1hKWllu?=
 =?utf-8?B?Z1Z0VGhlaWVLVC9OTnhvRExyOUhHTmxmdkpVWkhDMmdPY242cjVTV0J2OWZI?=
 =?utf-8?B?aytMTGZicUR3Vnp5a2NjbnpLWGgwRFpnZjdYdGFwZU02aDJIMC93RFdIakxE?=
 =?utf-8?B?MjcraERjVnhtbk5EbTJoZTBXSkZzSWFIT3JMZkorNnFGUHN6b3l6SkFUWUNk?=
 =?utf-8?B?WUExUlliLzFCUU9pYk1ralBDdStYWVFjR3hjZmdLY2dxQTh2akZZOUZqTDV0?=
 =?utf-8?B?NnltK2FrUy9EeDZrY1o5UDdPdzUzWEkzOERvVTFZeGFrdDB4MFp3VzNuZFVs?=
 =?utf-8?B?ZU9zYVViYnNjeXZBRCtUb01YL0JXQmlQUmFJY2NxaU5uTkRySUthODdUTExB?=
 =?utf-8?B?NS9Qc2k3a0haNzI1TmxSMGlyR1JvUWRBbklUOUVwZzZBZ1AxYTFWaUJQaFZ2?=
 =?utf-8?B?aDVpcmhUOWRwY1M1UmI1d09nWXZia0JhbER4MlhQY2tTYStZME4rR3gvd3Nt?=
 =?utf-8?B?NUNJa2drQWtCWWkrRlEzblcxelhIa0NFbzdWa1JwNGowK0s2cDFBdTdkY0hh?=
 =?utf-8?B?Zjd4a0dMZWpvSEVqUXlyZDVpbTk2Y05mb212Vnl5ZFJDWmQyZUFlWlNjb243?=
 =?utf-8?B?NXpLVWs2SmczT294bkNJSldLalNRWmdxRlF2Y3RZQUZITmNFMy91Sk5GMHhY?=
 =?utf-8?B?cm8zUUJuZWEvSTFiVFc4VDFuMldHaTNhaTZMTnhVVzAvd200UmEveUZvaWJC?=
 =?utf-8?B?VWFNY1hoWWZsYTFWM3VHL3BNSTZJSWtvbXdBM2FvV1ZEeWtaeWNMUkxLaW1C?=
 =?utf-8?B?ZzhBZHlEWlRFcHlKb0lrblRMM1N5aSt5bjJLRzVlSzhiTG5SZTNCaTVob1A1?=
 =?utf-8?B?aURBVVp3azJFV1FUL0lIdzVwR2t6TW5JR2toM29JTXJzLzhJa1Mra0pqdno0?=
 =?utf-8?B?Tys5clh5YU1lNkdvNTBFR29qb0J3OHlvc2Q4QzZlWFV5bC9jN1RMNTVPK2d5?=
 =?utf-8?B?TnFEdS90NXZPQ3JoR1FOaFJyTVlud3hFdDFlT0Z6YTZVM0NJQ3VPNFZsSlNF?=
 =?utf-8?B?dFBMZ1pEVXhLam9neDBTUmJyWGtnaXg0MzBkS3RMWnhjWVdqYVZwaEF1K0sv?=
 =?utf-8?B?QTREaVJPbWNTUmtFYUZwMkxtbkZrU0lQaVRrbGZJMlI5LzhyaDY0Y2V1UEhv?=
 =?utf-8?B?ZWdmbFFnVnNsbE9VUkUyYWhNT3JqckQ2S2p2S3NyMTd1N05aR1dTK2xPNkp0?=
 =?utf-8?B?Qk5pRjI3dzVVdDJUYXJTYmdySlovOVdFN2NYbjRQaGZkYzRKMU1YME5BUWZu?=
 =?utf-8?B?eEhhL1A2bFlkN1RsdStKK2RkY0NMMUZhTTBsN2ZZbW0yOEVranJIcEtKeWg4?=
 =?utf-8?B?emJCTmRkTGhBd1VQTTRQQUFtSzU4RmZrMUtoZVV1VVhLMzI5VXVnYUw0YTlO?=
 =?utf-8?B?dHpTQTMwbnZRRFg5cEptcXY4aHRNbUtvUnhCY3pZVEZXWWNTZWpDWkxGZkoz?=
 =?utf-8?B?aE40c1FzRDNOVngzOWQ4em5OVGdjWXk4d3RWazcrNmpYRmpjYkNPOStKWmx5?=
 =?utf-8?B?NkhCTkoxL3A3VDVQUUZtQ2JrbmpnNW91WU5WWVZ0a3h2NUh6NGVGU3lWNk9D?=
 =?utf-8?B?S2VzZlllNS94SUFaMlhRM3B6WkNtZkRtZzE4YjNUNlhLNDNleVFQTSs4V0hi?=
 =?utf-8?B?TUV3VDhkc3J0cHh1b0ZPL0RzeHVuVnBpcmVpL2FiWXNndjdLM1dPdldRc1Rn?=
 =?utf-8?B?S1EwNEhvbHdKeDUrNTVMeVFMTmRXUk1pbDhVclI5cnRaeFpyRjFnc09Gci82?=
 =?utf-8?B?QnlFcVpjRXNLSlVVVXFQSjBPb3NDRjJOY2pRVTdrdXNKb0RvMWNmWitsQW9t?=
 =?utf-8?B?OVZWWXI4Y0VaTjVWR1pxL3BicFM4ZlNQeG8yakJHaldVQWZRTy8rcUxrSWFj?=
 =?utf-8?B?TW9BWW5zcDdwMUQ0ZnlIRFNNeE1HZy9YaUQ1RTk0ZVc3TisxOW1jYXRIKy9Q?=
 =?utf-8?B?TzY4eDJ4aWgreTJMU0tmeUtMRFp0Nkx0UUU2dUgwUFJ0dzM5dlpSQTZDWnBs?=
 =?utf-8?Q?skgCD28YTkEMt5+vIYzNOwE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <773B680D3C64F64FA528D9BFF3DAC362@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c534586-ff32-4b1e-86b8-08dc5a6ad3ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2024 21:03:24.5752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cYWc5IKffpK1NSOngxtuFObbdjhnkI4zAPKEudQBC4tLTGb9fN/57ZZ6sDsJq4FByzyXNDYZ8zn2dfQIdEFUDy9Kj7+kEQvSkDz035TS8Ps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8349
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA0LTExIGF0IDEzOjQ2IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gVGh1LCBBcHIgMTEsIDIwMjQgYXQgMDc6NTE6NTVQTSArMDAwMCwNCj4gIkVkZ2Vjb21i
ZSwgUmljayBQIiA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+IHdyb3RlOg0KPiANCj4gPiBP
biBUaHUsIDIwMjQtMDQtMTEgYXQgMTI6MjYgLTA3MDAsIElzYWt1IFlhbWFoYXRhIHdyb3RlOg0K
PiA+ID4gPiANCj4gPiA+ID4gU28gdGhpcyBlbmFibGVzIGZlYXR1cmVzIGJhc2VkIG9uIHhzcyBz
dXBwb3J0IGluIHRoZSBwYXNzZWQgQ1BVSUQsIGJ1dA0KPiA+ID4gPiB0aGVzZQ0KPiA+ID4gPiBm
ZWF0dXJlcyBhcmUgbm90DQo+ID4gPiA+IGRlcGVuZGVudCB4c2F2ZS4gWW91IGNvdWxkIGhhdmUg
Q0VUIHdpdGhvdXQgeHNhdmUgc3VwcG9ydC4gQW5kIGluIGZhY3QNCj4gPiA+ID4gS2VybmVsIElC
VCBkb2Vzbid0IHVzZSBpdC4gVG8NCj4gPiA+ID4gdXRpbGl6ZSBDUFVJRCBsZWFmcyB0byBjb25m
aWd1cmUgZmVhdHVyZXMsIGJ1dCBkaXZlcmdlIGZyb20gdGhlIEhXDQo+ID4gPiA+IG1lYW5pbmcN
Cj4gPiA+ID4gc2VlbXMgbGlrZSBhc2tpbmcgZm9yDQo+ID4gPiA+IHRyb3VibGUuDQo+ID4gPiAN
Cj4gPiA+IFREWCBtb2R1bGUgY2hlY2tzIHRoZSBjb25zaXN0ZW5jeS7CoCBLVk0gY2FuIHJlbHkg
b24gaXQgbm90IHRvIHJlLWltcGxlbWVudA0KPiA+ID4gaXQuDQo+ID4gPiBUaGUgVERYIEJhc2Ug
QXJjaGl0ZWN0dXJlIHNwZWNpZmljYXRpb24gZGVzY3JpYmVzIHdoYXQgY2hlY2sgaXMgZG9uZS4N
Cj4gPiA+IFRhYmxlIDExLjQ6IEV4dGVuZGVkIEZlYXR1cmVzIEVudW1lcmF0aW9uIGFuZCBFeGVj
dXRpb24gQ29udHJvbA0KPiA+IA0KPiA+IFRoZSBwb2ludCBpcyB0aGF0IGl0IGlzIGFuIHN0cmFu
Z2UgaW50ZXJmYWNlLiBXaHkgbm90IHRha2UgWEZBTSBhcyBhDQo+ID4gc3BlY2lmaWMNCj4gPiBm
aWVsZCBpbiBzdHJ1Y3Qga3ZtX3RkeF9pbml0X3ZtPw0KPiANCj4gTm93IEkgc2VlIHlvdXIgcG9p
bnQuIFllcywgd2UgY2FuIGFkZCB4ZmFtIHRvIHN0cnVjdCBrdm1fdGR4X2luaXRfdm0gYW5kDQo+
IG1vdmUgdGhlIGJ1cmRlbiB0byBjcmVhdGUgeGZhbSBmcm9tIHRoZSBrZXJuZWwgdG8gdGhlIHVz
ZXIgc3BhY2UuDQoNCk9oLCByaWdodC4gUWVtdSB3b3VsZCBoYXZlIHRvIGZpZ3VyZSBvdXQgaG93
IHRvIHRha2UgaXQncyBDUFVJRCBiYXNlZCBtb2RlbCBhbmQNCmNvbnZlcnQgaXQgdG8gWEZBTS4g
SSBzdGlsbCB0aGluayBpdCB3b3VsZCBiZSBiZXR0ZXIsIGJ1dCBJIHdhcyBvbmx5IHRoaW5raW5n
IG9mDQppdCBmcm9tIEtWTSdzIHBlcnNwZWN0aXZlLiBXZSBjYW4gc2VlIGhvdyB0aGUgQVBJIGRp
c2N1c3Npb24gb24gdGhlIFBVQ0sgY2FsbA0KcmVzb2x2ZXMuDQo=

