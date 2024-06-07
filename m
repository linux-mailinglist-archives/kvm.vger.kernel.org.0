Return-Path: <kvm+bounces-19101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 67731900E80
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 01:39:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5CAF1F237EC
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 23:39:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9700C140368;
	Fri,  7 Jun 2024 23:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KX0dEZxB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB6FD2F0;
	Fri,  7 Jun 2024 23:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717803563; cv=fail; b=LzO09InCDHU5sfIGde+IBkpM8LCLdJqstoWHcnJA0zTlWlOBdPMcj9Hg6UbT8o6ZVRwYFniqZCcelg5vpJPIB7AW+1VtI4bxGNprVOT6hnM6bCOe+pEPGKlYfa6RAb2JMiXyvn5dmFZ69syeHMRft81FefBhvpcH5v0ZT7UzIe4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717803563; c=relaxed/simple;
	bh=p7VZRNkXahCNP0UQd6So8aB3ccOJLGeragsvPeEnTdw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rQy3gGGK4/BljTsH3W4DafB4Kab6jEAYiHpHDU2vjZ5wGZ2quD03XkSV5seEBgf/dgfzRC9eTzEdVTXaC53e5AkwcIVt6/0OuHI/AybFyKUWak6qf72aZm8LUpBeJaQRRCYnbYeAhxTwg5LQgBwyda7BmWlIEpcQ97oPBBVta4w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KX0dEZxB; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717803561; x=1749339561;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=p7VZRNkXahCNP0UQd6So8aB3ccOJLGeragsvPeEnTdw=;
  b=KX0dEZxB1eDME6qu+5vAIbexmj3VxVCVYskOtUkNCeufNcSmJOYOFtiP
   O02vSk5Bf0igm56XsWXBe/heoblyRiNejila5kMc/e3PsmHw3Ruu9DWC5
   w14cOhNfcQa5er6bw9bFMx7G5CcWQ8GIgYuGrgzXhxnHx3NaWw+CNXjwl
   5Ax0MfmsEL0aCY6DJdu1+jKtlsinZCuLlzqQSMLpTz5TSsRSxIGPGbXRY
   agdFs3I5EQ1aGCfaQ9/uXhqgkDHSnFNc59bDXc+McDCv8kmGcyVvX2H6G
   yhz6Witsosg3IXN0Vio5X3Qbjob3ofG1tVztQ3yo3HVGWSmbRpyJuorpv
   Q==;
X-CSE-ConnectionGUID: 3BpgmCruTHaPIrA6lzFxWg==
X-CSE-MsgGUID: W0Xk+gs9RJu5/HMi0iTFCw==
X-IronPort-AV: E=McAfee;i="6600,9927,11096"; a="25118935"
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="25118935"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2024 16:39:21 -0700
X-CSE-ConnectionGUID: i4pppwHOSqqLiv5TwtYZ9w==
X-CSE-MsgGUID: hN5kj7+LSLGV/h3b19fhTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="38570301"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jun 2024 16:39:21 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 7 Jun 2024 16:39:20 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 7 Jun 2024 16:39:20 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 7 Jun 2024 16:39:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AHgF9GqQCgc1CHSG8JyauPY2Qzj7cX+h6l+pcp7efQ8wDJkNlxfGVSzv3qk6c+rdbyjbDpkZfwrO97BLKSdgsE7VYwS2v5awlj2pHFOkgLEfeGVfItT3DsTKBPqw0MWUJBk+DnV4IIWholEjW1p7vDufOeR+WxHOAixoTkhn4qDr37N2ba2eLu+lUsLqgYABTk24+YWv+3H4iEf2WsfZwCkmA3q7ihEWgYAQGr47rg0M6MOXSYlmU9DixYDQgCpGxPoNAjFJ7CS+tHSaENlGUM5dP+DKD7ov/uL0Hm+3M3013s6zg8ltn87bTG4KJbJ/NJRKHj4+0NiYv5bZhgbzNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p7VZRNkXahCNP0UQd6So8aB3ccOJLGeragsvPeEnTdw=;
 b=TRYZRTpUHfvZV+tVl6P4qKSTmYrLkCP/XaU+/27kHfgyz5M1VKTQzYiawlsnx/12eRw3/jwUV9HsSSzyPUYucetqa2gDKEqoJucCJwnqkCOaaXVJdCDtok+M7wPXceMdCNrPBmXC+qYqAeAj20Ub5SRsTDprT0Bw4TimZU5YryqvQZHMuO/C3/obK+NVo6cNHHQZYIqBbiy80yWCbC1RIhQZTm2xFjO99tLeSI/9YNQ4QGGiXEPvjnzpP12FNFUzhyYazs4TdZ8su2J69E1u03Hbv4P5Tb9joq7Cv/xatm+KAR12oH0T0xScaKg/xNM+Tx+AqQaZ7Ksjh62sFEsQxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MN2PR11MB4613.namprd11.prod.outlook.com (2603:10b6:208:26d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.35; Fri, 7 Jun
 2024 23:39:15 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7633.021; Fri, 7 Jun 2024
 23:39:14 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v2 15/15] KVM: x86/tdp_mmu: Add a helper function to walk
 down the TDP MMU
Thread-Topic: [PATCH v2 15/15] KVM: x86/tdp_mmu: Add a helper function to walk
 down the TDP MMU
Thread-Index: AQHastVsQXE+dJbtzEiSvN+WW827hrG8FTYAgADs7YA=
Date: Fri, 7 Jun 2024 23:39:14 +0000
Message-ID: <af69a8359cd5edf892d68764789de7f357c58d5e.camel@intel.com>
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
	 <20240530210714.364118-16-rick.p.edgecombe@intel.com>
	 <CABgObfbpNN842noAe77WYvgi5MzK2SAA_FYw-=fGa+PcT_Z22w@mail.gmail.com>
In-Reply-To: <CABgObfbpNN842noAe77WYvgi5MzK2SAA_FYw-=fGa+PcT_Z22w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MN2PR11MB4613:EE_
x-ms-office365-filtering-correlation-id: b4a890b7-eb67-4657-e7c8-08dc874b0a7e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?T3BUMm5LN201Q1R0M2xER0gwM29GUVY1cGZLZjFHQmpBZnpmL2xoUTByb0Ev?=
 =?utf-8?B?c2o1MTVGcStiN2g2ZnROc216clhUWkZqdXZtcDFYZzBlcmgrWEw3K0pXN0N6?=
 =?utf-8?B?NkNDRk42UU9BQnJISEVPSkhTSUt1bzg0TTFacFhZT0JENkh4SDl4bVg0ckxP?=
 =?utf-8?B?anE5UE5TeEltYytQcTRsMTNrUTFINXNmZERsUkcwdnczM2VMem1wRWpzZDk3?=
 =?utf-8?B?SFE0VWZPYkJIOVVyMUFpaWtYNVVSQVpzdmhIUlNQTHAzcU42M1lTV3NTVzZy?=
 =?utf-8?B?Tnp4eHpob2NiOGRIbzVvL1Z2ZE0yMmNhbXgveGs5ZlJ6U0xwMG9rTlRDd3h1?=
 =?utf-8?B?NExRYVJZaHZrVVVlUEhOWEpwMklNWFNYcmpYY2NVV3RjVVZIcmthTVFzV25O?=
 =?utf-8?B?RzAzb0VXUktodGJmZm5icWlhNjB0NnZuZ0kwTFJ0TG1RaHk4cU5oR0J5dkhC?=
 =?utf-8?B?dVhHYU8rR0hwcU5pdmNpSFhMNXM0MHowdmQxSVQ1L3NvMWlEOVZmdWllUjIv?=
 =?utf-8?B?SytoMGg0MVIxUzlUYS9KNjMxVmllbklRV0V6U0x1VU1wVHNoditJajFMZzRK?=
 =?utf-8?B?N0hRdWZXYUtqenM5enVHRDJwcDdJNFhOL0diT3BLZkhKQy9zYzc3THFpbUta?=
 =?utf-8?B?Y1NYc25XazU2SzZyS2VSTk5pOHBac3NjSnhyMFl5NmdGYVJsRDl5VVJzMXhR?=
 =?utf-8?B?MmxQNTFqQTFMbTVLZ3k3ajJiWit0MnYrbVR1cjlEengzZkV1K2t3UjdlSGVo?=
 =?utf-8?B?dWlmMnhqcjl4d2NmVm4weVlMQXdaMExPaXd1S0xFWjZ1ZUJJbUlXMlB0RFVO?=
 =?utf-8?B?VS8yOHR4eFg1OURPdDJ4SkxHdHMrazQwYzI5ckFKUFVpblo0WW1kelVjMEdP?=
 =?utf-8?B?bDdUTVEyalhIME5KY0pFYlJETWFLcHgyR1JCUlU1bzVmSjNXdGxTTW9TcC83?=
 =?utf-8?B?ZGlCdk04d2pUMFE2c0xvUjJNS1FQc1pQUWxnd1BkOXdJL3RHMnk1dVlvaWkr?=
 =?utf-8?B?OXV4WDFoQXFCSkttekc3bEdwZkpnVm5PSkMvbGgveXE1ZGhkWnFHODh6cERV?=
 =?utf-8?B?TTMzbDhUcHZ1ZUNRTHVzMnhqa3l3VkFUMldMa0xyZ0YyQnRybmlkQ0k0RWhN?=
 =?utf-8?B?M3pVbVF2TlF1cHFXaTJZQUo1SkhRajUvNGVKd01LeFN2UHkxNk9YTDBQc3BU?=
 =?utf-8?B?ZEtQQUtaTWxLU2VHN3YvaHhBTFNBTTkvVGVRZGZDMDZDL3NuT1FRTnpwSngz?=
 =?utf-8?B?bUNKVmR4eHNIUGg2ajhQWm0zVTFJb1Y5SExacDBTbTdSZ080SDZ1VTJHcTFx?=
 =?utf-8?B?TUVlMVF4aFJMYmpaRlBFcnArQWpmdTlvVk5SNWVrV1FuY3YxMXpBeTI0KzlQ?=
 =?utf-8?B?QnorOTlEelhOQWZkWnB2SjVZQmo0SkI1RzdOWnZpeHMrTGJTelpUZE9MVTRI?=
 =?utf-8?B?cUtaZCtwTGVNbDA1cWhQdWxRUFY2UUdQRC9IQ0g2eE9mN25pV3hIdlUzQzl6?=
 =?utf-8?B?cXVhSzJMOVZMNnNFMk9ndzFjNVQ3NzhhUFRYdWRpSkdkczNSSytGcmMzeEN2?=
 =?utf-8?B?cytkUXRRTmMvbUYycklCYmhZQkwxTVhTR3hwUDRyNmZQeUdqbi9yWEgyZDdF?=
 =?utf-8?B?dWVkcU9YV0YvQThPKzhkcGd2b2NNRmcwbEZPNnNLaUFqUk1uSGRJY215dzdn?=
 =?utf-8?B?bU8xeHhhWElPbk5sY2FpWEV0cXg3QWtDUGg5NDJjbWI4akVhcXp0djBvY1dL?=
 =?utf-8?B?ZWZZMmxRMlJGcnBVRGs0cWdyUXpBalVIcXBRSEJGSnF5RDlBMmtTN1lDTUw5?=
 =?utf-8?Q?wodhegYuTR0xmN3gV/RuY+kAUEfCWGOe1oipM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a2pHRGJQN1IyRGdWYUduWFhNSDRnWUtEOVVFalU1Z2xRZlNnMUtpK1Nsbm02?=
 =?utf-8?B?SmRqOVRqczM4dDR2NXAwNzIxcUh3MGMrUUdnb0dXL0lDVEVLd3hBcUs1UVcr?=
 =?utf-8?B?N0owOFpjREszTG5kazhzdGpId3B0V0toVncydk5CQzJ2clg2VURhSGVKR0oy?=
 =?utf-8?B?OFRLc3g5NGR2OU9iSUxncS9maDNLK1QyeGtmQ3pnZW9JSlM1RmpBR3Vya3dI?=
 =?utf-8?B?U2REbXBqeXRZSEg5NW5RaEc2dlVnbUVKaThiZU9iekdPd1MyZkdUSTVnUEpM?=
 =?utf-8?B?cGMxZk5sckNyc1lEd011Ukx6NUJWZHdyQmVGL3huYVNUTDZyZmxhTTRiQ3Z1?=
 =?utf-8?B?L3VkTldhUUJHODhpZlU4cUk5NExIV1pwK0o4RHhkNnprNVY1M2pvcXpUQnU3?=
 =?utf-8?B?TWVxNG1BbWh4aUVJV1Z5cmVxUGg5eWZXa3hWeHRqMW5Md0VZQkpTSm1tdkg4?=
 =?utf-8?B?Sm5vK1Vuc0VTUlVsdWZsZ2MvT2tiOVU5WFNHUW11N2lrUEpRbng1QUxsM1oy?=
 =?utf-8?B?NnI1amZaekM0YTZINU5Yd2hhcTJCNVVnYzAxUGl1V2l0QTdNZ1Nta2NjZWsy?=
 =?utf-8?B?VGFrenpCRDZBZG05c3NIaUtoU0x2TzZST0FSMGNzVzhRcDBINi9wQ05JdSth?=
 =?utf-8?B?V291dEpZUmUrSmZ4VWExM0EwSXRJMEloaGZmT29tczcwaUZKcS9hYis2bkIr?=
 =?utf-8?B?STJ0K0s1aUhYVWw1UVoyQUt3eVJFZHFVUXR4R3lUUjNDdkZybDgzUEc2YktL?=
 =?utf-8?B?S2p4bjdIWEZrak9mY1VaTmZPdCtraUtPd29rdk8rVUxwRnM2OUNpZWsyaVg2?=
 =?utf-8?B?UlNBWFAweUZ0czZkbFRxWUtQb2VRd0RQMk1kemNvT2czKzF3UTQyZFpEU2FL?=
 =?utf-8?B?UDU2UFpOZW5OYkhzZUw2YnI3K0ptRlN2T0Jwa1FER2VmZys2dThkVFhOTitM?=
 =?utf-8?B?ZzhFWVRqZDVpWUpsNmJ6NnNra0RzR094eHpVMjdyWFIzdE5JczdKOTBvelNi?=
 =?utf-8?B?UzR5Y3JLWW5qUkF4dThuSDNGMDhSUGVFdHVyd0FSTnF6RmJFdVFFUjIvSE0z?=
 =?utf-8?B?VkZzSTlJaXBtNk0wV0NlVktqTDdTTXZNT3h2TUpsTHVyMzJOQ2MvZ3I1eGNH?=
 =?utf-8?B?RFNxMGFVMHIreWU0TjlMUU5jK1dNK3ZmL21oLzk1YWVMSHo5NTVkRjhiRjVV?=
 =?utf-8?B?eGlWZ0hEM3pibzd2blJpSGNHTXR1eTdjM0RYaW1ya3JMb0VyUjRmRkFMTTRT?=
 =?utf-8?B?UkxGbmJUMTZmN2xrWHRaRCtOL3hqOGhvVTJEV3h6V3ZuSm12K0R4azNnckhH?=
 =?utf-8?B?cG9NbFFPMEFxb05NdHNJS0JBeG50VkVyVGI4d2M1Q2ZKMkZxM3VYY2JOckE3?=
 =?utf-8?B?aXpZaTlyRERFdTd1WDJURE1BM0hCd09PK2RUVzR3VmdoOS8ycG1PU0xnMFpN?=
 =?utf-8?B?RURNa243ZUhVRk0yT3RHMm9sdmtLUWF3dmkrQTlJaGg5azQrQ2gwcnVFdDBZ?=
 =?utf-8?B?b051bURxeUgvYUNkVDNnQ0NZRDNEMEJYaEFxVllRcmZTZlFpbkRTSU1ac1F2?=
 =?utf-8?B?VFE2ZnpsNnlBOWxjQnJKc0tmRDlTT1JKb2g3ajFxc1dUcmtsOUJmODZnbXNK?=
 =?utf-8?B?R3VNdEswcHdnRWJkY0haSlUrbHVWaDFsRUpIaU0xT0hzNjYybk9FNUI0SUlG?=
 =?utf-8?B?U2VHUUZyajhHV3J1aUhUQ2xmR1pCK01hakJkWjJ4aTEvcjgrNUh5TVNtanJV?=
 =?utf-8?B?R2dpZkxzT2Y4Qmxoc1dhZlB5YUh1U0FWdlduZEt0YVpOS0U3d3FBZjhXK3R1?=
 =?utf-8?B?L3hSWXV5MkpQNnArYmh0N1JKOVI3WFh2emFGOWJta0szc01BWCs4eFlrODlj?=
 =?utf-8?B?ZEVqY2EvWEhyL3FxemF5aGxheFlzSUZ5aVRHaE5tWGNqOTEvUnJvc3UyNDI0?=
 =?utf-8?B?dHBMQnpGUzRPQUdZa3Q4Qi9MQ3BGRHpjSWFsdkx6eWdNMGNBdDFEcXB6Yjdn?=
 =?utf-8?B?cXFuV3E2RENVaVl6T1FDYUFYWVFmNWVGc0IzZ214VzVmZlFNQjlRV1VQd0Jw?=
 =?utf-8?B?c043RGJCTXprNG9kT1RkaS9wU3FxemdIYnZGMm1NWWVaRFl1M1pONEJSNGJQ?=
 =?utf-8?B?eVFMeGtjS0JQN1ZzVHlRalZGNDdqcFlUK2Z0SnlZOTA1a084M004dUpOekJM?=
 =?utf-8?Q?Bscsal/DNZKujNu8Z70SiJA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4000CB0670B8264AA85E45320823BB22@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4a890b7-eb67-4657-e7c8-08dc874b0a7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2024 23:39:14.7792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w8+UerndrpQEnx78St/YBXf1OrYbXgXHvZJBOGczcplLlk6FB4iFXJXyql5yQMdErnFlCV21LNgIqDwPZ6t/NaBsPmpJuCLgOAEBnDbVAgk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4613
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA2LTA3IGF0IDExOjMxICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiA+IC1pbnQga3ZtX3RkcF9tbXVfZ2V0X3dhbGsoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1NjQg
YWRkciwgdTY0ICpzcHRlcywNCj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBpbnQgKnJvb3RfbGV2ZWwpDQo+ID4gK3N0YXRpYyBpbnQgX19rdm1fdGRw
X21tdV9nZXRfd2FsayhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHU2NCBhZGRyLCB1NjQNCj4gPiAq
c3B0ZXMsDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgZW51bSBrdm1fdGRwX21tdV9yb290X3R5cGVzIHJvb3RfdHlw
ZSkNCj4gPiDCoCB7DQo+ID4gLcKgwqDCoMKgwqDCoCBzdHJ1Y3Qga3ZtX21tdV9wYWdlICpyb290
ID0gcm9vdF90b19zcCh2Y3B1LT5hcmNoLm1tdS0+cm9vdC5ocGEpOw0KPiA+ICvCoMKgwqDCoMKg
wqAgc3RydWN0IGt2bV9tbXVfcGFnZSAqcm9vdCA9IHRkcF9tbXVfZ2V0X3Jvb3QodmNwdSwgcm9v
dF90eXBlKTsNCj4gDQo+IEkgdGhpbmsgdGhpcyBmdW5jdGlvbiBzaG91bGQgdGFrZSB0aGUgc3Ry
dWN0IGt2bV9tbXVfcGFnZSAqIGRpcmVjdGx5Lg0KPiANCj4gPiArew0KPiA+ICvCoMKgwqDCoMKg
wqAgKnJvb3RfbGV2ZWwgPSB2Y3B1LT5hcmNoLm1tdS0+cm9vdF9yb2xlLmxldmVsOw0KPiA+ICsN
Cj4gPiArwqDCoMKgwqDCoMKgIHJldHVybiBfX2t2bV90ZHBfbW11X2dldF93YWxrKHZjcHUsIGFk
ZHIsIHNwdGVzLCBLVk1fRElSRUNUX1JPT1RTKTsNCj4gDQo+IEhlcmUgeW91IHBhc3Mgcm9vdF90
b19zcCh2Y3B1LT5hcmNoLm1tdS0+cm9vdC5ocGEpOw0KDQpJIHNlZS4gSXQgaXMgYW5vdGhlciBj
YXNlIG9mIG1vcmUgaW5kaXJlY3Rpb24gdG8gdHJ5IHRvIHNlbmQgdGhlIGRlY2lzaW9uIG1ha2lu
Zw0KdGhyb3VnaCB0aGUgaGVscGVycy4gV2UgY2FuIHRyeSB0byBvcGVuIGNvZGUgdGhpbmdzIG1v
cmUuDQoNCj4gDQo+ID4gK2ludCBrdm1fdGRwX21tdV9nZXRfd2Fsa19taXJyb3JfcGZuKHN0cnVj
dCBrdm1fdmNwdSAqdmNwdSwgdTY0IGdwYSwNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBrdm1fcGZuX3Qg
KnBmbikNCj4gPiArew0KPiA+ICvCoMKgwqDCoMKgwqAgdTY0IHNwdGVzW1BUNjRfUk9PVF9NQVhf
TEVWRUwgKyAxXSwgc3B0ZTsNCj4gPiArwqDCoMKgwqDCoMKgIGludCBsZWFmOw0KPiA+ICsNCj4g
PiArwqDCoMKgwqDCoMKgIGxvY2tkZXBfYXNzZXJ0X2hlbGQoJnZjcHUtPmt2bS0+bW11X2xvY2sp
Ow0KPiA+ICsNCj4gPiArwqDCoMKgwqDCoMKgIHJjdV9yZWFkX2xvY2soKTsNCj4gPiArwqDCoMKg
wqDCoMKgIGxlYWYgPSBfX2t2bV90ZHBfbW11X2dldF93YWxrKHZjcHUsIGdwYSwgc3B0ZXMsIEtW
TV9NSVJST1JfUk9PVFMpOw0KPiANCj4gYW5kIGxpa2V3aXNlIGhlcmUuDQo+IA0KPiBZb3UgbWln
aHQgYWxzbyBjb25zaWRlciB1c2luZyBhIGt2bV9tbXVfcm9vdF9pbmZvIGZvciB0aGUgbWlycm9y
IHJvb3QsDQo+IGV2ZW4gdGhvdWdoIHRoZSBwZ2QgZmllbGQgaXMgbm90IHVzZWQuDQoNClRoaXMg
Y2FtZSB1cCBvbiB0aGUgbGFzdCB2ZXJzaW9uIGFjdHVhbGx5LiBUaGUgcmVhc29uIGFnYWluc3Qg
aXQgd2FzIHRoYXQgaXQNCnVzZWQgdGhhdCB0aW55IGJpdCBvZiBleHRyYSBtZW1vcnkgZm9yIHRo
ZSBwZ2QuIEl0IGRvZXMgbG9vayBtb3JlIHN5bW1ldHJpY2FsDQp0aG91Z2guDQoNCj4gDQo+IFRo
ZW4gX19rdm1fdGRwX21tdV9nZXRfd2FsaygpIGNhbiB0YWtlIGEgc3RydWN0IGt2bV9tbXVfcm9v
dF9pbmZvICogaW5zdGVhZC4NCg0KQWhoLCBJIHNlZS4gWWVzLCB0aGF0J3MgYSBnb29kIHJlYXNv
bi4NCg0KPiANCj4ga3ZtX3RkcF9tbXVfZ2V0X3dhbGtfbWlycm9yX3BmbigpIGRvZXNuJ3QgYmVs
b25nIGluIHRoaXMgc2VyaWVzLCBidXQNCj4gaW50cm9kdWNpbmcgX19rdm1fdGRwX21tdV9nZXRf
d2FsaygpIGNhbiBzdGF5IGhlcmUuDQoNCk9rLCB3ZSBjYW4gc3BsaXQgaXQuDQoNCj4gDQo+IExv
b2tpbmcgYXQgdGhlIGxhdGVyIHBhdGNoLCB3aGljaCB1c2VzDQo+IGt2bV90ZHBfbW11X2dldF93
YWxrX21pcnJvcl9wZm4oKSwgSSB0aGluayB0aGlzIGZ1bmN0aW9uIGlzIGEgYml0DQo+IG92ZXJr
aWxsLiBJJ2xsIGRvIGEgcHJlLXJldmlldyBvZiB0aGUgaW5pdF9tZW1fcmVnaW9uIGZ1bmN0aW9u
LA0KPiBlc3BlY2lhbGx5IHRoZSB1c2FnZSBvZiBrdm1fZ21lbV9wb3B1bGF0ZToNCj4gDQo+ICvC
oMKgwqAgc2xvdCA9IGt2bV92Y3B1X2dmbl90b19tZW1zbG90KHZjcHUsIGdmbik7DQo+ICvCoMKg
wqAgaWYgKCFrdm1fc2xvdF9jYW5fYmVfcHJpdmF0ZShzbG90KSB8fCAha3ZtX21lbV9pc19wcml2
YXRlKGt2bSwgZ2ZuKSkgew0KPiArwqDCoMKgwqDCoMKgwqAgcmV0ID0gLUVGQVVMVDsNCj4gK8Kg
wqDCoMKgwqDCoMKgIGdvdG8gb3V0X3B1dF9wYWdlOw0KPiArwqDCoMKgIH0NCj4gDQo+IFRoZSBz
bG90c19sb2NrIGlzIHRha2VuLCBzbyBjaGVja2luZyBrdm1fc2xvdF9jYW5fYmVfcHJpdmF0ZSBp
cyB1bm5lY2Vzc2FyeS4NCj4gDQo+IENoZWNraW5nIGt2bV9tZW1faXNfcHJpdmF0ZSBwZXJoYXBz
IHNob3VsZCBhbHNvIGJlIGRvbmUgaW4NCj4ga3ZtX2dtZW1fcG9wdWxhdGUoKSBpdHNlbGYuIEkn
bGwgc2VuZCBhIHBhdGNoLg0KPiANCj4gK8KgwqDCoCByZWFkX2xvY2soJmt2bS0+bW11X2xvY2sp
Ow0KPiArDQo+ICvCoMKgwqAgcmV0ID0ga3ZtX3RkcF9tbXVfZ2V0X3dhbGtfbWlycm9yX3Bmbih2
Y3B1LCBncGEsICZtbXVfcGZuKTsNCj4gK8KgwqDCoCBpZiAocmV0IDwgMCkNCj4gK8KgwqDCoMKg
wqDCoMKgIGdvdG8gb3V0Ow0KPiArwqDCoMKgIGlmIChyZXQgPiBQR19MRVZFTF80Sykgew0KPiAr
wqDCoMKgwqDCoMKgwqAgcmV0ID0gLUVJTlZBTDsNCj4gK8KgwqDCoMKgwqDCoMKgIGdvdG8gb3V0
Ow0KPiArwqDCoMKgIH0NCj4gK8KgwqDCoCBpZiAobW11X3BmbiAhPSBwZm4pIHsNCj4gK8KgwqDC
oMKgwqDCoMKgIHJldCA9IC1FQUdBSU47DQo+ICvCoMKgwqDCoMKgwqDCoCBnb3RvIG91dDsNCj4g
K8KgwqDCoCB9DQo+IA0KPiBJZiB5b3UgcmVxdWlyZSBwcmUtZmF1bHRpbmcsIHlvdSBkb24ndCBu
ZWVkIHRvIHJldHVybiBtbXVfcGZuIGFuZA0KPiB0aGluZ3Mgd291bGQgYmUgc2VyaW91c2x5IHdy
b25nIGlmIHRoZSB0d28gZGlkbid0IG1hdGNoLCB3b3VsZG4ndA0KPiB0aGV5Pw0KDQpZZWEsIEkn
bSBub3Qgc3VyZSB3aHkgaXQgd291bGQgYmUgYSBub3JtYWwgY29uZGl0aW9uLiBNYXliZSBJc2Fr
dSBjYW4gY29tbWVudCBvbg0KdGhlIHRoaW5raW5nPw0KDQo+ICBZb3UgYXJlIGV4ZWN1dGluZyB3
aXRoIHRoZSBmaWxlbWFwX2ludmFsaWRhdGVfbG9jaygpIHRha2VuLCBhbmQNCj4gdGhlcmVmb3Jl
IGNhbm5vdCByYWNlIHdpdGgga3ZtX2dtZW1fcHVuY2hfaG9sZSgpLiAoU29hcGJveCBtb2RlIG9u
Og0KPiB0aGlzIGlzIHRoZSBhZHZhbnRhZ2Ugb2YgcHV0dGluZyB0aGUgbG9ja2luZy9sb29waW5n
IGxvZ2ljIGluIGNvbW1vbg0KPiBjb2RlLCBrdm1fZ21lbV9wb3B1bGF0ZSgpIGluIHRoaXMgY2Fz
ZSkuDQo+IA0KPiBUaGVyZWZvcmUsIEkgdGhpbmsga3ZtX3RkcF9tbXVfZ2V0X3dhbGtfbWlycm9y
X3BmbigpIGNhbiBiZSByZXBsYWNlZCBqdXN0IHdpdGgNCj4gDQo+IGludCBrdm1fdGRwX21tdV9n
cGFfaXNfbWFwcGVkKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTY0IGdwYSkNCj4gew0KPiDCoCBz
dHJ1Y3Qga3ZtICprdm0gPSB2Y3B1LT5rdm0NCj4gwqAgYm9vbCBpc19kaXJlY3QgPSAha3ZtX2hh
c19taXJyb3JlZF90ZHAoLi4uKSB8fCAoZ3BhICYga3ZtLQ0KPiA+YXJjaC5kaXJlY3RfbWFzayk7
DQo+IMKgIGhwYV90IHJvb3QgPSBpc19kaXJlY3QgPyAuLi4gOiAuLi47DQo+IA0KPiDCoCBsb2Nr
ZGVwX2Fzc2VydF9oZWxkKCZ2Y3B1LT5rdm0tPm1tdV9sb2NrKTsNCj4gwqAgcmN1X3JlYWRfbG9j
aygpOw0KPiDCoCBsZWFmID0gX19rdm1fdGRwX21tdV9nZXRfd2Fsayh2Y3B1LCBncGEsIHNwdGVz
LCByb290X3RvX3NwKHJvb3QpKTsNCj4gwqAgcmN1X3JlYWRfdW5sb2NrKCk7DQo+IMKgIGlmIChs
ZWFmIDwgMCkNCj4gwqDCoMKgIHJldHVybiBmYWxzZTsNCj4gDQo+IMKgIHNwdGUgPSBzcHRlc1ts
ZWFmXTsNCj4gwqAgcmV0dXJuIGlzX3NoYWRvd19wcmVzZW50X3B0ZShzcHRlKSAmJiBpc19sYXN0
X3NwdGUoc3B0ZSwgbGVhZik7DQo+IH0NCj4gRVhQT1JUX1NZTUJPTF9HUEwoa3ZtX3RkcF9tbXVf
Z3BhX2lzX21hcHBlZCk7DQo+IA0KPiArwqDCoMKgIHdoaWxlIChyZWdpb24ubnJfcGFnZXMpIHsN
Cj4gK8KgwqDCoMKgwqDCoMKgIGlmIChzaWduYWxfcGVuZGluZyhjdXJyZW50KSkgew0KPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCByZXQgPSAtRUlOVFI7DQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIGJyZWFrOw0KPiArwqDCoMKgwqDCoMKgwqAgfQ0KPiANCj4gQ2hlY2tpbmcgc2lnbmFsX3Bl
bmRpbmcoKSBzaG91bGQgYmUgZG9uZSBpbiBrdm1fZ21lbV9wb3B1bGF0ZSgpIC0NCj4gYWdhaW4s
IEknbGwgdGFrZSBjYXJlIG9mIHRoYXQuIFRoZSByZXN0IG9mIHRoZSBsb29wIGlzIG5vdCBuZWNl
c3NhcnkgLQ0KPiBqdXN0IGNhbGwga3ZtX2dtZW1fcG9wdWxhdGUoKSB3aXRoIHRoZSB3aG9sZSBy
YW5nZSBhbmQgZW5qb3kuIFlvdSBnZXQNCj4gYSBuaWNlIEFQSSB0aGF0IGlzIGNvbnNpc3RlbnQg
d2l0aCB0aGUgaW50ZW5kZWQgS1ZNX1BSRUZBVUxUX01FTU9SWQ0KPiBpb2N0bCwgYmVjYXVzZSBr
dm1fZ21lbV9wb3B1bGF0ZSgpIHJldHVybnMgdGhlIG51bWJlciBvZiBwYWdlcyBpdCBoYXMNCj4g
cHJvY2Vzc2VkIGFuZCB5b3UgY2FuIHVzZSB0aGF0IHRvIG1hc3NhZ2UgYW5kIGNvcHkgYmFjayB0
aGUgc3RydWN0DQo+IGt2bV90ZHhfaW5pdF9tZW1fcmVnaW9uLg0KPiANCj4gK8KgwqDCoMKgwqDC
oMKgIGFyZyA9IChzdHJ1Y3QgdGR4X2dtZW1fcG9zdF9wb3B1bGF0ZV9hcmcpIHsNCj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgLnZjcHUgPSB2Y3B1LA0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCAuZmxhZ3MgPSBjbWQtPmZsYWdzLA0KPiArwqDCoMKgwqDCoMKgwqAgfTsNCj4gK8KgwqDCoMKg
wqDCoMKgIGdtZW1fcmV0ID0ga3ZtX2dtZW1fcG9wdWxhdGUoa3ZtLCBncGFfdG9fZ2ZuKHJlZ2lv
bi5ncGEpLA0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHU2NF90b191c2VyX3B0cihyZWdpb24uc291cmNlX2FkZHIpLA0KPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDEsIHRkeF9nbWVtX3Bvc3RfcG9w
dWxhdGUsICZhcmcpOw0KDQpPayB0aGFua3MgZm9yIHRoZSBlYXJseSBjb21tZW50cy7CoFdlIGNh
biBhbHNvIGRyb3AgdGhvc2UgcGllY2VzIGFzIHRoZXkgbW92ZQ0KaW50byBnbWVtIGNvZGUuDQoN
CldlIHdlcmUgZGlzY3Vzc2luZyBzdGFydGluZyB0byBkbyBzb21lIGVhcmx5IHB1YmxpYyB3b3Jr
IG9uIHRoZSByZXN0IG9mIHRoZSBNTVUNCnNlcmllcyAodGhhdCBpbmNsdWRlcyB0aGlzIHBhdGNo
KSBhbmQgdGhlIHVzZXIgQVBJIGFyb3VuZCBWTSBhbmQgdkNQVSBjcmVhdGlvbi4NCkFzIGluLCBu
b3QgaGF2ZSB0aGUgcGF0Y2hlcyBmdWxseSByZWFkeSwgYnV0IHRvIGp1c3Qgd29yayBvbiBpdCBp
biBwdWJsaWMuIFRoaXMNCndvdWxkIHByb2JhYmx5IGZvbGxvdyBmaW5pc2hpbmcgdGhpcyBzZXJp
ZXMgdXAuDQoNCkl0J3MgYWxsIHRlbnRhdGl2ZSwgYnV0IGp1c3QgdG8gZ2l2ZSBzb21lIGlkZWEg
b2Ygd2hlcmUgd2UncmUgYXQgd2l0aCB0aGUgcmVzdA0Kb2YgdGhlIHNlcmllcy4NCg0K

