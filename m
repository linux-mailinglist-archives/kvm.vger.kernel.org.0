Return-Path: <kvm+bounces-17488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 064578C6F6C
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 02:14:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACA6528274D
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 00:14:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 307064688;
	Thu, 16 May 2024 00:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hjA7lxfy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5573C28;
	Thu, 16 May 2024 00:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715818431; cv=fail; b=ErUpmzwgUBRew4kSVv1v5G3pHXnjbrT8SayxksRLQf8x82bBvXrob9JsZT049wHT9yFnEvhMWixbpdnydfLrYrzdQLBF47U2efHFLCdX/oKmrYbBJyrmuUTPq6OAEcuAqhM9fIOEnLFl9FgL84f6Gkfvfj/79kMW+kYKeHuG3u4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715818431; c=relaxed/simple;
	bh=VOxzja5ImZP0rG3R/6nfl8DnzLtFA1mYcluM8YrFeYs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rrIFu2Dx+jHB5xt4HXLeOSritC4Cfyr2GIOAmOknLEvxmT4fX5lFnrg+DE26DUxGoURuy+SE+7OgH4EgEPrt3fjIHAjhIip8FCIEWKpToxUZpMheZpPXz9s3FPEJkQPyHAxeDnBu25WK8ulqwSQ4pLry5xEwIp0lYywHQIieOtk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hjA7lxfy; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715818430; x=1747354430;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VOxzja5ImZP0rG3R/6nfl8DnzLtFA1mYcluM8YrFeYs=;
  b=hjA7lxfyDiEG1MIToltTrpQDuMe/9SjOoq6U1FYvE+Z2PlXB/S1OjR09
   pSByERYKKv8Jp3xqKLj4sHPDNsQQOvi9xh/qfCMze3WE6E0dXC/BWUSs+
   xMIiVktJdWJNV1ejmDwktfiQ671WGEU5PxJnrxV2tTP2faH6tfjFmqNR/
   c3Mzmb/H3SSLvdYX0rudsUa4iEYeOeQlklmbW5L0aqUZqa/+gOspYMVxq
   WVGHxeDa+vZ56ImVW2j5/m7gm76RykN0P5SKhokuQbTUHqloGudwCtVh1
   Khu+f86/3UWRQ0xthqFT9gebD5T8G1qjMlZRTPtLZfwV4z8nONqxBjR7Y
   A==;
X-CSE-ConnectionGUID: kdI9nnXwTSeflLUQWvcdkA==
X-CSE-MsgGUID: JX9w1IWpQQiGTotVWu2LDg==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="12024338"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="12024338"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 17:13:49 -0700
X-CSE-ConnectionGUID: GyvaqJyWREGt2m1PzRy/WQ==
X-CSE-MsgGUID: xyn5aZHQSnagGRqsj5RzhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="31240473"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 17:13:48 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 17:13:47 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 15 May 2024 17:13:47 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 15 May 2024 17:13:47 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 17:13:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KpSb5MfGUIB2GMMvFlUE6uNMBtyt7LNneBAgiDo6zFh1klev1+qJlJBIGVs8olD2WUylz4ONNFu6A94/0Dh2Q1Cb+1gzh/pnU42jYA8bmSPc7hOkQWGLulh40BVRRXFK3WAFWMvULLCi1Oi4DlqmsrBKKfS3EUQetSmuLHZAyBqYBiUBeISBm8tM2pKe7S72vP5bou5+vyguaQkDyR8N6nU5HpOSAFeX9sxxf0iFB3ik24ecUDPXkEgXH2MGkJRmbsCYwFgCB+zH0xIWfU43GMyl0LAPpiNdEmGm5aYsQJSK8F8k/fDIUCIrwM/5KpE/rBv8avbHX2bW/l6erhkyQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VOxzja5ImZP0rG3R/6nfl8DnzLtFA1mYcluM8YrFeYs=;
 b=kmHLgqmK8QSdB5T4ds1ASu7E7X2EQpGPanHboIkFWh9Idphchj0busE6W8TDirdWJBAGLCl4TjMWjn/gcCiZThkA5K2hit2oknFmKhYS3lMg97mO0vHOgVfduZLsurFzc29kLd3g/WKiLfuqCav+/4BFmY6viTAZ7KkzGPZuNkSpsdDz6CJFkEkFqA2XroTTvkfysb9rBN+TluSDYZWUdHfUtZEHluCjeEvdqu3JRAQjWrLXW3a0gRhJD/qb60NJGXgTDCMSTeikFJlAh5vQxWwddf3B+cKzIxElsnMgz93hxKRm76vJorHfAqg5KRVwGIT4I6Aug1giElNFV0br3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ2PR11MB8345.namprd11.prod.outlook.com (2603:10b6:a03:53c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Thu, 16 May
 2024 00:13:44 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Thu, 16 May 2024
 00:13:44 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "dmatlack@google.com" <dmatlack@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Thread-Topic: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Thread-Index: AQHapmNQnVfe1bKBZ0u4IdlZLB/mxbGYbgKAgAANbQCAAGM8AIAAD92AgAAGrQCAAAnWgA==
Date: Thu, 16 May 2024 00:13:44 +0000
Message-ID: <3879ed41213652da74c5de3e437f732dfb2324d7.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
	 <ZkTWDfuYD-ThdYe6@google.com>
	 <20240515162240.GC168153@ls.amr.corp.intel.com>
	 <eab9201e-702e-46bc-9782-d6dfe3da2127@intel.com>
	 <d4c96caffd2633a70a140861d91794cdb54c7655.camel@intel.com>
	 <66afc965-b3f5-41e5-8b8e-d19e7084b690@intel.com>
In-Reply-To: <66afc965-b3f5-41e5-8b8e-d19e7084b690@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ2PR11MB8345:EE_
x-ms-office365-filtering-correlation-id: 7bf1d87b-7a05-4919-8b36-08dc753d0cbf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?d1Q1TE1nMzBTdEVwUnR0Vkw5dTJsT1RpZFNVdklpZFE5N2tPeXdOVGZ2bVJ4?=
 =?utf-8?B?WWRoSjFLbkJVV1l2TUt5cE5RK1FPeGRLWnl2Q0FDbzlPSTlCODZFdmw2UWlt?=
 =?utf-8?B?eGswaXpyVzY0NWI2S0dCbjJnOUUrdnBkVnNRVjl3TllSTjZQMndxUWZmUTFs?=
 =?utf-8?B?RXg1SytTQ1ZrTlpNeWNHdmxoOEF3LzIvWXVUY0hqbGpNcll2dkZrVUd0ZXc4?=
 =?utf-8?B?MzBHdFFjRFB3Q2NNZVZpQXZTT0VDRjF4RnhSZWw1VWhCcGdkNk8yTVVEdU01?=
 =?utf-8?B?d2s2VGQ0eGVLRUh4cklQb1Z0MzE3ZDJyYzFYL3ZId28yanl4S2gzaDVXQm5W?=
 =?utf-8?B?aC9CNlltNXNuN01PcW1pMFRPQWlIamRsanNmZGt1UGpCRjdjVkVUZDFaOUVh?=
 =?utf-8?B?SmNJdkJhcFJFc3Z0UFVUS1dqNlBScmRaV1lYQ2xzUWUySWc1NG45R3AraWU0?=
 =?utf-8?B?ak1UVTFQQVJzckZDL2xlSTRJanJaaDZKSEZlSFNZT1dSSzV1VDR0aEVrZmg1?=
 =?utf-8?B?aE1oRzFnSjJkQy9VMXRqdDMrWHkyTXphZlJiQkMrcXBaSkxxSkN0bFZidHpq?=
 =?utf-8?B?TGhET0NkczVkdTRCWDduTUV0d1lqZmJKK2pmd1dQR0tMSm9TNDUrbmhHM0l4?=
 =?utf-8?B?ZTIrUnpmQVBQK252Zm9NRDJQbDByRml4ZTdoUkdmR2JRVCtjUm9palB0S3dI?=
 =?utf-8?B?ZmMySEJhNk1odW4yalZrN1VBdDBWMGpGcDBFVFlaU1lrMEh2c2FQeUp0d0o3?=
 =?utf-8?B?Z2dCWTBJMDh0d0U1QWpRUlFPcUZtSmozN1RtTTRBK3QrVXZDTEcxZTIvK2lU?=
 =?utf-8?B?eUlqREp4NVg1cWpsU3U4OXJSOWFXMkR6UC9DNE96YlgyVmxjSjkvczJTWmd6?=
 =?utf-8?B?aHZXbGtwNGRVRFhoM3hRU1ZHVnJUT2NyeXRIc3BidS9XZWlER002cjNVYlox?=
 =?utf-8?B?bmFhZlpMWWFOSEFGL3NDY1Q0K0htUWtPS2pMUzVWVjBuMWNBQU9qMXg3N0sw?=
 =?utf-8?B?UWZWSGRuQkNKK2xpY1FFNWhCVzBEUmVYSVgyVm45VmRERklRQzBaSi90MzhB?=
 =?utf-8?B?eS9jOTUvTXd5ZjFTVXRvREJybUM5QXNpUmtDbVdvNVc4dDVUQ083bmNzU0hP?=
 =?utf-8?B?MFFSSUpraTRTVXNiZEllT2dyTVRZbnlvMlZsRCtoclVGWVVSNHBGK056Qjd5?=
 =?utf-8?B?RW5KZDRwVUZrb1BnWi8yVDFZSWRSK3ZMbzV3YStzbzcrb0ZjNDdPQUtHczB1?=
 =?utf-8?B?WXQ1SHB6N0U2OFgwY2lzT3RpU1ZBallJVlpYOVcxYjc5amRsandydnRHbWlZ?=
 =?utf-8?B?Ky9jOHZxL1hUY0F2eVdRSGo3YjlEbjNCb0pueE93YVBBSUcrVGZxYjdEUHVi?=
 =?utf-8?B?NG81SWRhSTdqQjk5RVF2c1dkNTJYeG1uWXRWV3hPOXM1L29UVWU4b1lVZHBE?=
 =?utf-8?B?Vyt6ZHp6TzRVK3ErVG10bmtERmQxT1JHNkZPcUxRQXFUbEtaTHpOUTlTaWt2?=
 =?utf-8?B?RWxicVdMWGY4RVdtcy9qYlFReWl6dXZxbVVlQnRhNGpqcHJzWkRPVDhNZThv?=
 =?utf-8?B?M0VBTDdkYURXK3FvTm55cDNEeEVZd0cydkI4NkJxa3F2SUd3bnhTNU1EdzA2?=
 =?utf-8?B?dUdRRDBtSWJRZkR0L2N4UTI2MGNhQVN0NVZGci9hQ082ZzJFbURGTm93MFBa?=
 =?utf-8?B?cDVONHhGSTlzSXpqMmwvU0cxVENrSDNSMHI2TzljekU3S05XY3hHck9ZQktt?=
 =?utf-8?B?Q09rREpicm5UWkVWSk1tUzNINmx6OTI1UWRFbE4zNkZjaVk4UU4vVUQvY3RG?=
 =?utf-8?B?WmZwR25RbUF5NU9LUllFQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Vjg4NFBxY3YzYlVlUGtjZGlzV3pjQ3o3bW1uZ2NhZ09jL2pHSkJVeXhmNC81?=
 =?utf-8?B?RW9VNXdmVHBmSEFtN1diUlIwOEtPaUNGV25KVmJiS3lxNDkyTFVxYmEwWFFT?=
 =?utf-8?B?RGFCTnoxcTEzOHQzcmtib1ovbU96Rml3YXhNVlpJVHB3WkpneWx3eElWMVNG?=
 =?utf-8?B?Wlg3c3E2UFBrQUY3b01ObDBJU0tJMWs5OVZOUTdydUpZMGIrZ2hHaUwyQ3Qy?=
 =?utf-8?B?c3FpMzVLdzFRQXNldnFCU2lQWTgvR2JXMEdRbWZDQWtYQkxoTGt4L1A5Umta?=
 =?utf-8?B?TG1QU2N4dVBhTWQrSGdKcENpd1p4cFczR3FjWXRpVlB2TkhJTllVQSt0dzh1?=
 =?utf-8?B?NVNqOVpvbUcvRGJYMldvRmNkTTJDZ1RFMUREZzU0eUdpSEZyWmdZdDhjcTZs?=
 =?utf-8?B?SFltckllVGlDUVlibk42amNEekZyaGIvR0pMakJXcWhEbDdnOG1uRER5Tk03?=
 =?utf-8?B?aFk2a2pqcDYxVXJiUlYrejVWdzFMVnp1ZjRJeWRndWgyUm5UbkQ5TzNHU2VH?=
 =?utf-8?B?OWRrM3B0elYySk1BRWM3cDUyb0FOUnErNzNKdG1DcHVqZ0R1QU9HZ2ZsWXRk?=
 =?utf-8?B?a2syVnA1S2ZPWVRVY2gzWEdONlBqcDU3cjQrM1RkVkdiaDNwWVVhSEJNZnc4?=
 =?utf-8?B?UlBUVHlrWjJ3bEZSRHFjSnJkNmpIUlBXOWJxOFJDVWVqd1c3SmtsZC9GM0JW?=
 =?utf-8?B?NWF0QjB3M2h4YlFPTXBicitVNzY4RExPa2F2dXlsZ2VnL0wxcElRRWtOZ0pT?=
 =?utf-8?B?Z2h4UmF5SnZTTVdCWEorY1RwMjMySzBCR25CRVlpV2ZabytqbXpnNTV6bXdv?=
 =?utf-8?B?N25NTytRZktpa2p6d1FuUUNPL3ZycDRzVEpqOTFwM1Z1RVZibXVpVm9Sa3Vm?=
 =?utf-8?B?Z3lBdnFsZmpKQlFKeCtvckNlUFVUYlIyRHdJcGgvVEw4MWFyaEI1TU85ZVN2?=
 =?utf-8?B?TU9DRnZIbUhyV3BhVVZETmF1Q0JMaCtOMTRqT3FGU0JCY3h4ZWVrOFgya0E5?=
 =?utf-8?B?SU00N200VDFPaGp2YWNneU13YXNVUGlMVDdGL0NHNW01U2lyN05xK2VEcE9I?=
 =?utf-8?B?RXd0TzdtSW1YSXZJRXVhYjZQcnJ1SlZTUzlvSmlZQjMvblRaRk00VXBSODd3?=
 =?utf-8?B?TnJrODJGNDh6WjN4dlM2cFVZVkF3aHRzOHhnTUxzMWlBb0FXMmoxWEJMZG9i?=
 =?utf-8?B?dGFrem1KMzB1Nzg0b3Z0YkxqN0x1d2dUcXFzUzdSd1BYdnpBc3lhNmZyMHRs?=
 =?utf-8?B?blNTUGpBaU52MUtHbWJvZEk3dDJTTjNxODh2aXJMeXlrWEdIditkem1zWnk2?=
 =?utf-8?B?YTIxckhTMlJ4L2loTGJUeUdyMmdsUXRjUzl1N3lIayt4c01ML2Z6SHY4dlo2?=
 =?utf-8?B?OFljRGtiaDBsc1JZOVVoU2tkYkRLaEwzeXJoRGJidzBQdmJCcHQyWlVSdUZZ?=
 =?utf-8?B?VDVOMnI0d0JIUDl2VkxNQWVpMHdUeTk2bTltenNtbk1yR2U2TWg5WDBqU2lV?=
 =?utf-8?B?bHB1d24rYkRkSlArR0pwRy91aEVMYjVadFM0V2pWNTdkT0FyNnBFYkNVNGRx?=
 =?utf-8?B?T1QzSVV0N2xGZjByR2k4SXIxTTJQMWRiMzB1dmtMaHBnVXVjYnpTcXhsL256?=
 =?utf-8?B?NlE5SzJVaEg3V0JBdmd6TzZEYk80MDhrYkRnbytreUYwNHFuWUQwbjZPc3E3?=
 =?utf-8?B?eG04dUFpUjVMdzhQOWNXQVFFbC9MQUVhOFQrSmdBamR3R0dmWnhrSEtYTkJQ?=
 =?utf-8?B?Yk9oQ25Bb2NrNFNpM3VISGFURHVselZ4WEJ2V2lmakhjbXg4UEVCMi90YlRG?=
 =?utf-8?B?TldmV1MreW81alYvYndsUG1JdVdwMDdaRWFVOElCRXB3L2tPWHpQM2U3c2Zp?=
 =?utf-8?B?UFVmekwzMEVoc0diaWUydlpYcHNtKy9aVnN6NmJ3RDR3YURFclc3emc3REND?=
 =?utf-8?B?em9FVHhqbExNdmcyQk44ZEdpamZDY2MrOXltWVQ4VHd1ZE5jTHRzWU5sMnNH?=
 =?utf-8?B?cXhtZ2hlM0FsejB5SGRhWXlXWVlBVkdUYVk4ZThEeUk3YTdZVGM1SFpxTUph?=
 =?utf-8?B?NnlteXhkd0FJT0JQenBjWEgvYUwya0dIQmk3MkRiZFBuV2poOWRlTW0xZzJ3?=
 =?utf-8?B?U3FuM09CalhxcFh6MXVCYmJISmxLbUxSeVljWWx4RmhlWGtWVEltQnIxbVov?=
 =?utf-8?Q?Wh7OMKvuf6uHj46CbnIi6/o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4301E8F1AF240845ADDD43BB8BA5FCD6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bf1d87b-7a05-4919-8b36-08dc753d0cbf
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2024 00:13:44.7046
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FjXIsyNZ4xIvDOc1DEXsaoxkFcDsm9FNPOqCatLFoOuN4uQ/ip/fULMct9w5Nbc3NIjyeSGPL+goivU+tm8cHSn3p1SptJqus9t3HjhCqCo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8345
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA1LTE2IGF0IDExOjM4ICsxMjAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiAN
Cj4gDQo+IE9uIDE2LzA1LzIwMjQgMTE6MTQgYW0sIEVkZ2Vjb21iZSwgUmljayBQIHdyb3RlOg0K
PiA+IE9uIFRodSwgMjAyNC0wNS0xNiBhdCAxMDoxNyArMTIwMCwgSHVhbmcsIEthaSB3cm90ZToN
Cj4gPiA+ID4gVERYIGhhcyBzZXZlcmFsIGFzcGVjdHMgcmVsYXRlZCB0byB0aGUgVERQIE1NVS4N
Cj4gPiA+ID4gMSkgQmFzZWQgb24gdGhlIGZhdWx0aW5nIEdQQSwgZGV0ZXJtaW5lIHdoaWNoIEtW
TSBwYWdlIHRhYmxlIHRvIHdhbGsuDQo+ID4gPiA+IMKgIMKgwqDCoMKgIChwcml2YXRlLXZzLXNo
YXJlZCkNCj4gPiA+ID4gMikgTmVlZCB0byBjYWxsIFREWCBTRUFNQ0FMTCB0byBvcGVyYXRlIG9u
IFNlY3VyZS1FUFQgaW5zdGVhZCBvZiBkaXJlY3QNCj4gPiA+ID4gbWVtb3J5DQo+ID4gPiA+IMKg
IMKgwqDCoMKgIGxvYWQvc3RvcmUuwqAgVERQIE1NVSBuZWVkcyBob29rcyBmb3IgaXQuDQo+ID4g
PiA+IDMpIFRoZSB0YWJsZXMgbXVzdCBiZSB6YXBwZWQgZnJvbSB0aGUgbGVhZi4gbm90IHRoZSBy
b290IG9yIHRoZSBtaWRkbGUuDQo+ID4gPiA+IA0KPiA+ID4gPiBGb3IgMSkgYW5kIDIpLCB3aGF0
IGFib3V0IHNvbWV0aGluZyBsaWtlIHRoaXM/wqAgVERYIGJhY2tlbmQgY29kZSB3aWxsDQo+ID4g
PiA+IHNldA0KPiA+ID4gPiBrdm0tPmFyY2guaGFzX21pcnJvcmVkX3B0ID0gdHJ1ZTsgSSB0aGlu
ayB3ZSB3aWxsIHVzZQ0KPiA+ID4gPiBrdm1fZ2ZuX3NoYXJlZF9tYXNrKCkNCj4gPiA+ID4gb25s
eQ0KPiA+ID4gPiBmb3IgYWRkcmVzcyBjb252ZXJzaW9uIChzaGFyZWQ8LT5wcml2YXRlKS4NCj4g
PiANCj4gPiAxIGFuZCAyIGFyZSBub3QgdGhlIHNhbWUgYXMgIm1pcnJvcmVkIiB0aG91Z2guIFlv
dSBjb3VsZCBoYXZlIGEgZGVzaWduIHRoYXQNCj4gPiBtaXJyb3JzIGhhbGYgb2YgdGhlIEVQVCBh
bmQgZG9lc24ndCB0cmFjayBpdCB3aXRoIHNlcGFyYXRlIHJvb3RzLiBJbiBmYWN0LCAxDQo+ID4g
bWlnaHQgYmUganVzdCBhIEtWTSBkZXNpZ24gY2hvaWNlLCBldmVuIGZvciBURFguDQo+IA0KPiBJ
IGFtIG5vdCBzdXJlIHdoZXRoZXIgSSB1bmRlcnN0YW5kIHRoaXMgY29ycmVjdGx5LsKgIElmIHRo
ZXkgYXJlIG5vdCANCj4gdHJhY2tlZCB3aXRoIHNlcGFyYXRlIHJvb3RzLCBpdCBtZWFucyB0aGV5
IHVzZSB0aGUgc2FtZSBwYWdlIHRhYmxlIChyb290KS4NCg0KVGhlcmUgYXJlIHRocmVlIHJvb3Rz
LCByaWdodD8gU2hhcmVkLCBwcml2YXRlIGFuZCBtaXJyb3JlZC4gU2hhcmVkIGFuZCBtaXJyb3Jl
ZA0KZG9uJ3QgaGF2ZSB0byBiZSBkaWZmZXJlbnQgcm9vdHMsIGJ1dCBpdCBtYWtlcyBzb21lIG9w
ZXJhdGlvbnMgYXJndWFibHkgZWFzaWVyDQp0byBoYXZlIGl0IHRoYXQgd2F5Lg0KDQo+IA0KPiBT
byBJSVVDIHdoYXQgeW91IHNhaWQgaXMgdG8gc3VwcG9ydCAibWlycm9yIFBUIiBhdCBhbnkgc3Vi
LXRyZWUgb2YgdGhlIA0KPiBwYWdlIHRhYmxlPw0KPiANCj4gVGhhdCB3aWxsIG9ubHkgY29tcGxp
Y2F0ZSB0aGluZ3MuwqAgSSBkb24ndCB0aGluayB3ZSBzaG91bGQgY29uc2lkZXIgDQo+IHRoaXMu
wqAgSW4gcmVhbGl0eSwgd2Ugb25seSBoYXZlIFREWCBhbmQgU0VWLVNOUC7CoCBXZSBzaG91bGQg
aGF2ZSBhIA0KPiBzaW1wbGUgc29sdXRpb24gdG8gY292ZXIgYm90aCBvZiB0aGVtLg0KDQpMb29r
IGF0ICJib29sIGlzX3ByaXZhdGUiIGluIGt2bV90ZHBfbW11X21hcCgpLiBEbyB5b3Ugc2VlIGhv
dyBpdCBzd2l0Y2hlcw0KYmV0d2VlbiBkaWZmZXJlbnQgcm9vdHMgaW4gdGhlIGl0ZXJhdG9yPyBU
aGF0IGlzIG9uZSB1c2UuDQoNClRoZSBzZWNvbmQgdXNlIGlzIHRvIGRlY2lkZSB3aGV0aGVyIHRv
IGNhbGwgb3V0IHRvIHRoZSB4ODZfb3BzLiBJdCBoYXBwZW5zIHZpYQ0KdGhlIHJvbGUgYml0IGlu
IHRoZSBzcCwgd2hpY2ggaXMgY29waWVkIGZyb20gdGhlIHBhcmVudCBzcCByb2xlLiBUaGUgcm9v
dCdzIGJpdA0KaXMgc2V0IG9yaWdpbmFsbHkgdmlhIGEga3ZtX2dmbl9zaGFyZWRfbWFzaygpIGNo
ZWNrLg0KDQpCVFcsIHRoZSByb2xlIGJpdCBpcyB0aGUgdGhpbmcgSSdtIHdvbmRlcmluZyBpZiB3
ZSByZWFsbHkgbmVlZCwgYmVjYXVzZSB3ZSBoYXZlDQpzaGFyZWRfbWFzay4gV2hpbGUgdGhlIHNo
YXJlZF9tYXNrIGlzIHVzZWQgZm9yIGxvdHMgb2YgdGhpbmdzIHRvZGF5LCB3ZSBuZWVkDQpzdGls
bCBuZWVkIGl0IGZvciBtYXNraW5nIEdQQXMuIFdoZXJlIGFzIHRoZSByb2xlIGJpdCBpcyBvbmx5
IG5lZWRlZCB0byBrbm93IGlmDQphIFNQIGlzIGZvciBwcml2YXRlICh3aGljaCB3ZSBjYW4gdGVs
bCBmcm9tIHRoZSBHUEEpLg0K

