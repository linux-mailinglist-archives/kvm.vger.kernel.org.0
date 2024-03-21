Return-Path: <kvm+bounces-12344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 215FD881A9A
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 02:17:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63A0CB21536
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 01:17:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F1191C17;
	Thu, 21 Mar 2024 01:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PfLC5EX9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3567EC;
	Thu, 21 Mar 2024 01:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710983862; cv=fail; b=nsfcEbkeRMS5ct1TAzDXv0lNj9025jZvmtBoFtibqTxsLws9SvZj0KfEep9XHc1FE6J2aoojJiYc/3HTNMRhASdGqGk5/ip+zq1O66lSJMoHEXi9Zqa7+vQleIVRwCugoMblCgWo84ujTPfIQJwqIVOh9L83ixPZzaWw6xKneoc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710983862; c=relaxed/simple;
	bh=k5sXlUbT+Uy5MfKP1YFatE5TIvR1K/69L7Cj5ZUD/pU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ev3Mqirur7QPYk7JfViOarSR7PaOjemdJz+cRodhZlIMfAxOZN1NOyNbiqv0oL51hCpAiHiY383zHgfuiVvuVM5bAqIlfY7l2KodHXvEXhZ5xDTKcQbSdqQGxAAAJU+cz7QHvbS/maHjLuwcVg8mjRKMCBtwiVfqXaF1/vBjqQ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PfLC5EX9; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710983861; x=1742519861;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=k5sXlUbT+Uy5MfKP1YFatE5TIvR1K/69L7Cj5ZUD/pU=;
  b=PfLC5EX9aRGqNhWhQ7dRzAdCX3zl1QtGqx0JpFvB5myLKDmkps852zSj
   aRqPZfTac4FPAb0F3HunopNSPwRVGWd/iC0PwoovUZn3lVV7kmZBPRxYl
   WjVCSP4HpHbsoYZ1XRq3pxEha0RMTr7uCBjF7QQVOidlTYGq8rjHHj62+
   rMoKg2KJEnSh94f0H1JBnMUprL4VIkn4iKS3W6NFn/kkAZzZ9/qw2b6xH
   8lHpw6ZIUIEMkPbDz/JjhE5YIerbCLdgbXZAvwr6vACJ+9YWOKRzKYQgQ
   w/EMPaAUQceieYqFKawZv9Wor3zlxGx7vuSsUHpiaElrinR61D9O0opo1
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11019"; a="5886816"
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="5886816"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 18:17:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="14993291"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Mar 2024 18:17:40 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 20 Mar 2024 18:17:39 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 20 Mar 2024 18:17:39 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 20 Mar 2024 18:17:39 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 20 Mar 2024 18:17:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b8KH9NIhjuKArTcrP89PQevEWQpjmMtLCrmcqgFGTAMXboP9zUVNl/oa0G3pYdTEIJV3qIPEEDs1rjW+7zOV7HMwGj+dY8LPZoTTukLUDS5e+lCrBb49nkN19JN/5Yc0MySG9aKeoL45UItHSB1pTn7hbPX6MnqFq68MoXryH8UhFUhtppYvdCUGH3U8eBngURJnWLW+GYSLocyJrdG93Kk4u1P/RJaz1ac2e4jwWaEBMeYSWXT5Tclqh9pCt6jBJD/pnJPgCMzWn3LXUMYkNKp6TiuGR9z0I/oFLJUY6SaHqxFY086ni699ryTF9jE5M7bE8PU7/wGG6cBlyL/ZdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k5sXlUbT+Uy5MfKP1YFatE5TIvR1K/69L7Cj5ZUD/pU=;
 b=JCEUJoTNbpih1mSSqBRzfhnQX7I8Ys12c5P8tcYUKuiQ6UrGNv/fq+UbitzTOTBXt3axIORPtDMyAuMEruqz83wFC4KU/nMx20vrUBqQymPmjwIvGcOVGPGaPaPkR5TUL3KBrbR7BY5awOVVhKVZKmLj9pF6dqpX6Hqjz/4eFn0UtzjYspfa69UG++MOKK64+6kyp6qgwdmOKVXXhaclu/oiHxr+n0oSaTJrMtNiUj1mlz0g8OzIuTlS286SzC2UMgeDIZaZai1RXP1B0sHUdZRWntFQmiLbD5ua7LtrfouRpEGn5ZQAYMkI3BNHNiqbILVznjqabov4A+ehZ5mCwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB8083.namprd11.prod.outlook.com (2603:10b6:8:15e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.11; Thu, 21 Mar
 2024 01:17:36 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.010; Thu, 21 Mar 2024
 01:17:36 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yuan, Hang" <hang.yuan@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages for
 unsupported cases
Thread-Topic: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Thread-Index: AQHadnqpCkdQcpy1UEaf8e2/el3pBrE+L/IAgAGVVQCAABCvgIABmDGA
Date: Thu, 21 Mar 2024 01:17:35 +0000
Message-ID: <f63d19a8fe6d14186aecc8fcf777284879441ef6.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <1ed955a44cd81738b498fe52823766622d8ad57f.1708933498.git.isaku.yamahata@intel.com>
	 <618614fa6c62a232d95da55546137251e1847f48.camel@intel.com>
	 <20240319235654.GC1994522@ls.amr.corp.intel.com>
	 <1c2283aab681bd882111d14e8e71b4b35549e345.camel@intel.com>
In-Reply-To: <1c2283aab681bd882111d14e8e71b4b35549e345.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB8083:EE_
x-ms-office365-filtering-correlation-id: dbab310d-97f4-45c2-0d94-08dc4944b13c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CO8PkqEIvy+J/aq4ij/t9Psokz9Za4eYX+HTeZpjU4sMjqdWaS+4tG3ieIv3yQQ5p3Xo6LRa7qHIrHl0TTAjwbmzhei+CVjo+NIZA8kV6wyNYZShGSLf0yo6u3Xhr55qAZN2yZ4BcZh7BDmihftrurIGaX1tqChwK54JaN6fOZgzoNkVBcDlqDYn7/MbRJziL22FAUy/zM5RxYQ4tCvVfPGhwVI94xonLYoth4vLV4/NfkmsqsGHz0cA4SSGwEjpQu7wAt1+VNYjKLpKDK7mMurWYiCoAtHJyz8e2u0Gr80OxiL1efAE92eb6YEcyzaZRCgBpJR3X5p6Opu7QHmEKscxEEljFkTVO/zM0d5VOyb2rHw2SPOOKEHo7n5N650qSe0VYDIQCeyVthxUVsiAAGytP9mSPzRQOFR1jkzGZqyv8iWm1xz+yMRzgGDWAiF81UdXPY7XsFk0k7C8+pmNWbpXuHoabdN2IJYyoJYZ3pq78waaYWDVjGTieWhHiS56ECvcBV8DJpaNfDnqSu902bi3ydzG+G8OnEDK1MB6f3WtYOa3oCNSb2mUOcc3efv0dYfczjqW1jAyq5tWPrVI3W01t8mSGVZ2Qm1fHPJ9O2jZalfgNO2cFxEpSia1fBn4rOpROZaDaQpZcQNRYHDBauU1cjtL1ZHKzsIBSJpAYSZ0pXsJGQAze3XhoLXzcONC7EOFUszvcmUYx7Ke+QVWh65aTdLbRhpNFMRDxUz/zL0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dE4xdVZ6MW8rSGx1bTA5b1NCbDdOV2x4NERTWVhYQS9nTXBmU2JKSEtLVXdX?=
 =?utf-8?B?bXZCN0t6ejNSTXdCalNqaUlkRlhzUU0wbGtqUkptYkV0b0FLb3liYlljL3Vi?=
 =?utf-8?B?ZEoralBFbEVtYkVnNk83bkZXYkp4bjhmZFVsV1RDMTdwTWVQUEpBRG1jM1FU?=
 =?utf-8?B?YzVOZExNYk9pekt3ZlJCUnpBVUtvM21CaUZoVVlnb3pSTnB5cktvS2p6UXVn?=
 =?utf-8?B?NmR4WGdOMzdGbS9lYlZkLzMxVjdGSWdia1NKRSs0VDN6ayt0bnVKOGxiZkxu?=
 =?utf-8?B?dGpDbElGRGloVkx1UGRVbGVpSmtqRjV2UGFLNDR0UDRLMzJFNm9zb0E3dHVV?=
 =?utf-8?B?SGNYN0xXZ1RsWWtkaUdhcDRSZCtCQkdaQkJhSzlpVmZZdWxvVmJvUkh4Nm1r?=
 =?utf-8?B?ampJbndRMTRmbld4dHJXak0yU3BRTzhCUVk1dUppWkNvdjRjMlJHTmJSeUxo?=
 =?utf-8?B?dEVQZGo3MXl0S1VDZnl1a3czRGRPeGV1M2k0c3lxWTZlVFpTTWF2RzgrU3hP?=
 =?utf-8?B?emd2eHJHOGoxTnYzOERqNjJSdTYvVm50L09lTWlNRmwrNFlLQnpLWUhOblFC?=
 =?utf-8?B?L0RETTZVZVFGelFkWUFpc0pCN3E5OEhqR2NoUG10eTZMZ2tLZFh3SWh3enZa?=
 =?utf-8?B?aFhGRkd2QS9TT2w4YlloZEx5b0w5V0RPcVRuMHdMRFBHT0NXOXk0U0ZkZzl2?=
 =?utf-8?B?OUpacDNrNUtib3dPSk95UlN0TjRJZlBadXFmSnltMDFDeTc5TlN6TnJjeFVs?=
 =?utf-8?B?ZUdXZ1ZpV3NSUGtETEZsQ2RUUUxrS3pRTHdwemNSeGdvNFY2SEtidEF4MDFE?=
 =?utf-8?B?YUxicHlJWW5qcFhnTFFqMjJqaGFjQlpQTEFFSk5ralF0ckJiZVg5NUNyemQ4?=
 =?utf-8?B?R0Nlci9LOXF3OUJXZzBhOWg2bSt4c1pPclVQcFZwdEM1R2dGajQ3bGZ2Ujhi?=
 =?utf-8?B?YnRPaDNiTG1FcnhxRmJrTmZORzUyTGxibkRHUkd1aS9Gd0YzaWg4SWFtOElv?=
 =?utf-8?B?VzMvSUJEZ2czVktNdENscFNCbTJPZHZGMGJtWlpJMVhiRXIvNnMxWFB3R3hE?=
 =?utf-8?B?RWlHQlh1bjZaekJ2ejRJTGpJS1ZqR2RSckNMZ0hmcjllRE53eTB2MmdiazZ5?=
 =?utf-8?B?Q3lrSXBQNGEzSHRHcGZOTkZGd3Z4czJ1SFI2aHZsMGFkay9sdDJwU0pud1JM?=
 =?utf-8?B?NGNuSFZSNmdSdFBPMjRzazBKZTNoYlBZbEdOUkNBMTBvTEtjbmMzaHJOZUR0?=
 =?utf-8?B?T2hPdFdaVVo2MzI3NnpWN3ZvTzFUZ1RBeXdud2NGU3lmamlvc3V3UmJtelFy?=
 =?utf-8?B?dnQrWTB6cGhQM2lIVVJXcU5SNmpwZ1orYUlwWWppZkNEME5BcExqRUVZS1hN?=
 =?utf-8?B?QnprMXN1UlA5NlFTbFBzQUsyMklpSndacGM4ck9tb0dTRUpVY2VKSDdmYldI?=
 =?utf-8?B?VGt4UVl3Y1FCRWZKNnpWck5ZNDl0VlFKaVZPeU1xY21TMllLcmZvSDF5b0xX?=
 =?utf-8?B?ZjlHQ2Vnb01CY0IxU2o2bmV2WUErdDFKS3JzeVVCMFR4ZmZMM05BVGI5bXlS?=
 =?utf-8?B?YlYrR1c3UUx1NjVMU1JKOXJ3QTkyM0xBZTdnMEhTUVU2MmhvZlUyQU82MzNj?=
 =?utf-8?B?bmpkWDRzckJzbnBnTDYwK1BFTUdyd3ZMejZZb0NaVkMweTFHSEp5eDROZkgv?=
 =?utf-8?B?bkRnVURLMmg3c1FSLzdGclNLODlrdndwQmxpK2JQSEpUcXl6Rm1FUDVCT2Jm?=
 =?utf-8?B?dFpBT3NsMEcvakZ0UXQ2T3ZQU3lIRkczWHVWTXpMakFQbmdxR0FJdjJxK01u?=
 =?utf-8?B?RmtIMURjcFQvMjZJQ0FSMzR3MkZTaDIyRWFBNmpVa0Q4ZngvWjVXOTlWcVN1?=
 =?utf-8?B?MGNmZ2xtV09lYU95Y2cvVVg5VHBpc2NmM0s5ODhNdUFRTmgzUVlIOG1xaFhZ?=
 =?utf-8?B?Z29kMWdyVEVzZ2dibkNFRWQxOEdJQWRsMnpvZXFlallBYm5yMHVWY0U4OUZm?=
 =?utf-8?B?U25qYytHNkRXQUpxaFEyWllrQ2ZtZEp1T0g5T1dtSVVRRmtjUy9kQTkwZWJ4?=
 =?utf-8?B?dmY5ek5lNWNncTFUNFI0TTY5ejVhR0ZzRXZFTC9zM01sdjVCWS9WdkZGZHdy?=
 =?utf-8?B?eGhqdHY3K2lQa25rNzU0MXlkZHJhQ2N0UmpHWWxaMUttQTlFVXhFeFc1aElD?=
 =?utf-8?B?NVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <78CA0160A4EC1149B30D72647AF14830@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbab310d-97f4-45c2-0d94-08dc4944b13c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2024 01:17:35.9348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i5H0P0P5pNP5Zj+wkj2iPwYGzCTXIMYQvqpR0UDRvJHNKT5OU7z0O3tIVItNHliUWhNgKrhOHXwW0P7uNJZivLXFNzQTjLSQwh1+b8RcdQ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8083
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTAzLTE5IGF0IDE3OjU2IC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gPiBCZWNhdXNlIFREWCBzdXBwb3J0cyBvbmx5IFdCLCB3ZQ0KPiA+IGlnbm9yZSB0aGUgcmVx
dWVzdCBmb3IgTVRSUiBhbmQgbGFwaWMgcGFnZSBjaGFuZ2UgdG8gbm90IHphcA0KPiA+IHByaXZh
dGUNCj4gPiBwYWdlcyBvbiB1bm1hcHBpbmcgZm9yIHRob3NlIHR3byBjYXNlcw0KPiANCj4gSG1t
LiBJIG5lZWQgdG8gZ28gYmFjayBhbmQgbG9vayBhdCB0aGlzIGFnYWluLiBJdCdzIG5vdCBjbGVh
ciBmcm9tDQo+IHRoZQ0KPiBkZXNjcmlwdGlvbiB3aHkgaXQgaXMgc2FmZSBmb3IgdGhlIGhvc3Qg
dG8gbm90IHphcCBwYWdlcyBpZiByZXF1ZXN0ZWQNCj4gdG8uIEkgc2VlIHdoeSB0aGUgZ3Vlc3Qg
d291bGRuJ3Qgd2FudCB0aGVtIHRvIGJlIHphcHBlZC4NCg0KT2ssIEkgc2VlIG5vdyBob3cgdGhp
cyB3b3Jrcy4gTVRSUnMgYW5kIEFQSUMgemFwcGluZyBoYXBwZW4gdG8gdXNlIHRoZQ0Kc2FtZSBm
dW5jdGlvbjoga3ZtX3phcF9nZm5fcmFuZ2UoKS4gU28gcmVzdHJpY3RpbmcgdGhhdCBmdW5jdGlv
biBmcm9tDQp6YXBwaW5nIHByaXZhdGUgcGFnZXMgaGFzIHRoZSBkZXNpcmVkIGFmZmVjdC4gSSB0
aGluayBpdCdzIG5vdCBpZGVhbA0KdGhhdCBrdm1femFwX2dmbl9yYW5nZSgpIHNpbGVudGx5IHNr
aXBzIHphcHBpbmcgc29tZSByYW5nZXMuIEkgd29uZGVyDQppZiB3ZSBjb3VsZCBwYXNzIHNvbWV0
aGluZyBpbiwgc28gaXQncyBtb3JlIGNsZWFyIHRvIHRoZSBjYWxsZXIuDQoNCkJ1dCBjYW4gdGhl
c2UgY29kZSBwYXRocyBldmVuIGdldCByZWFjaGVzIGluIFREWD8gSXQgc291bmRlZCBsaWtlIE1U
UlJzDQpiYXNpY2FsbHkgd2VyZW4ndCBzdXBwb3J0ZWQuDQo=

