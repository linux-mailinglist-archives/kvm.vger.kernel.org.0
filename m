Return-Path: <kvm+bounces-17795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A08A8CA27A
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 21:03:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B57E72821B5
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 19:03:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51F0A1386A5;
	Mon, 20 May 2024 19:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fqlKgprM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EAD1CA81;
	Mon, 20 May 2024 19:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716231820; cv=fail; b=ghv88xrGmfbXJODMV8/2IWDBrwzEZCErl0NxKSA9cktg6TYxcFqMjCsGqxbNN2V4aApvtn9uJ4l6lRTc8pKeJZxsHS6h1p/gIj1m/8PmLH0UK+1qBe4wcy0kUIe0vASpmAxJufypaeWufdYSOjV2mD+RJy5xRJiKGxo5384LRIQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716231820; c=relaxed/simple;
	bh=vE7+rca0Y+tAWWWcH1rIRzSygbn9zaFqMww0BJmnK4Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LlHMopZ4578i95AUd5PcZsCO6xKkxNm+pWwthUNBm1XZRoprUFo0/gitJ35a13OJ+ENy5Ag+4oxZJs2EADqpw/xmJqthaB8kX/ihEWikzGc/3/MhjLc4aLm8jTgR72QhdZPDmjLTN0aMeu/+uQDCfqC+wuJEQMHU1SKvlFp2mmQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fqlKgprM; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716231819; x=1747767819;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vE7+rca0Y+tAWWWcH1rIRzSygbn9zaFqMww0BJmnK4Y=;
  b=fqlKgprMuB6ynnIPMtHasVHDFWBIwX9lpb3hdMvzBGoL0pWWedSTOXRX
   qgPchqn5pA0MZTxGHW3YI+q08682GHiOv1+1a124kBq3DjuelBHu7Mgjv
   0JfCikRZwUkXMJIBDqIzJgJwZH0T9+U8eJxgCeDNd6Po6/nYFbhuc9A4L
   drE2bai78P3WzvxVNe+3Bw/lRTzCCgn6fZzm1TilmpnWA/nywO0Mvk/Uk
   Y7Rj02rLP/lUYdo0mCOtFpBDDYd2NhErsbbJQd/kuDXWVjznS4tViHw+X
   +qHwxURE5t0084oA5DOJUrveNGe+CdYgUkR7G8eFK7PTgowY+JjDFXNiq
   w==;
X-CSE-ConnectionGUID: ofkPUX43Q+a80gkJgA/LTw==
X-CSE-MsgGUID: j3jz4bNyRq+Wy2lIMTg9eA==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12504497"
X-IronPort-AV: E=Sophos;i="6.08,175,1712646000"; 
   d="scan'208";a="12504497"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 12:03:39 -0700
X-CSE-ConnectionGUID: gM3HIQ95T52aHkbXGTwLoA==
X-CSE-MsgGUID: vSqN8Bf4Sh6tLvahd7HTGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,175,1712646000"; 
   d="scan'208";a="32514900"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 May 2024 12:03:38 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 12:03:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 12:03:32 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 20 May 2024 12:03:32 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 20 May 2024 12:03:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xz98IDCwVQcQTUPjOmob6OvkGKF00rgj65nwUqu7pPe1SG8KKJg7S16rl9igPhkspHh8nbN9QL2mOxEbYzqf5MfuGyWWfAOKBFFypGYS1yKUf+wLxMi+55PxQGY0MjGF3LMDs3L1tmHVDQ3xOnfdRCUFe4SRoWgi29PsI0Fj465chFGcRGgUZlTRBBd7ht7D+oiu1JCwiS9BD5rsccVruuLp2WjHzdBQNxHhDzvBsaCVNBoZHyjq4R32Q9mPri9oWb7i198u9ea2kBAt/U9H/tPHfNswDcF2hd7wOTLXPOSF9Yk92lx/NsoMQ11OJri0vqbv44a+xl77nPzRi0Z4Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vE7+rca0Y+tAWWWcH1rIRzSygbn9zaFqMww0BJmnK4Y=;
 b=JeP86h6Ji66XQMra8j/YcNJAsTzXovTVT+MvZd0eorDinct9GAHPrJVzvnnLQd50c45qsYrBydkF4QothM/fYQRuUP8WpoiENPA/TQNkxqvLMlp+G9BAYYJg7tHjy1+B/jFVyg/qJvqpCHtvCj/4nSDtU8gK+t13a0CvXblgeaPeqtAkosYSlS3Ixw1SnC54JOe9cGBDTu61643ATnxzEzO6pA6iDBi2SopKDPyn0LlBZybW/GdAuVpm6Wj/a26KeriAVkTmjxEde1IvdtUZa8sSoreuB9TPrMlQTRaCssGy1fxk1ESlwVoJN50sxQwMZ92gZdj4uAd2fzLwxMqRFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CO1PR11MB5090.namprd11.prod.outlook.com (2603:10b6:303:96::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Mon, 20 May
 2024 19:02:23 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.030; Mon, 20 May 2024
 19:02:23 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dmatlack@google.com"
	<dmatlack@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "Aktas,
 Erdem" <erdemaktas@google.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Topic: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Index: AQHapmNTP3XGfqhyyEaM/KHu10XBU7GZCeQAgAAJxQCAAAs0AIAADfKAgACpkgCAADtVgIAAM8qAgABz1ICAAF5sAIABZ7wAgACnZ4CAAtAtAIAAi4KAgAABJAA=
Date: Mon, 20 May 2024 19:02:23 +0000
Message-ID: <91444be8576ac220fb66cd8546697912988c4a87.camel@intel.com>
References: <a08779dc-056c-421c-a573-f0b1ba9da8ad@intel.com>
	 <588d801796415df61136ce457156d9ff3f2a2661.camel@intel.com>
	 <021e8ee11c87bfac90e886e78795d825ddab32ee.camel@intel.com>
	 <eb7417cccf1065b9ac5762c4215195150c114ef8.camel@intel.com>
	 <20240516194209.GL168153@ls.amr.corp.intel.com>
	 <ffd24fa5-b573-4334-95c6-42429fd9ee38@intel.com>
	 <20240517081440.GM168153@ls.amr.corp.intel.com>
	 <b6ca3e0a18d7a472d89eeb48aaa22f5b019a769c.camel@intel.com>
	 <0d48522f37d75d63f09d2a5091e3fa91913531ee.camel@intel.com>
	 <791ab3de8170d90909f3e053bf91485784d36c61.camel@intel.com>
	 <20240520185817.GA22775@ls.amr.corp.intel.com>
In-Reply-To: <20240520185817.GA22775@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CO1PR11MB5090:EE_
x-ms-office365-filtering-correlation-id: abd38abc-5bce-42aa-7704-08dc78ff61f8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?dzdrcVlXYmNiWjNOVk0rK1k5L1BJWkdRc00vTnExRm9Ld2oyTFJxdGZIVkJj?=
 =?utf-8?B?Z211cXJsLytnU2QrVmZrUzJvTEl2bjB5RnA4aWpCMFRnNjBVT2htYW9VRUdp?=
 =?utf-8?B?TjFRa1J0ZkJEbHNTWVR0clJRUWZQQTVsWW45dU5GU2t2VXpaMTFLUGsxbzdw?=
 =?utf-8?B?cU12NXAwY01WT2JLaEFCRWFCUEFxdjJmTXFvUmE0RVFidjRNTUhKbDh0L1Rp?=
 =?utf-8?B?Z09NdGNJaVVIazdMNVoxRmRZbmV5eE9KQUJFb2JBZWFYaGZIVlVZeVlDWVIy?=
 =?utf-8?B?VlhncnpTY3AxUC96YXgwZ2pTNDkxNHplL0FJeDR6Rk54YjdaVkFxcWFZOFo4?=
 =?utf-8?B?R29VL250TmxwbXhQMU84elZDMEhQWS9vMEJWT0MvUlB4MDVsclhrL1pXRHA0?=
 =?utf-8?B?ZlpJM0NpVVRwdXVHMUZYNDVSSGgvVjJzcEZmTU5aTjJMOW11KzgyT1llcExE?=
 =?utf-8?B?MzYvaEEvd3UyYXVWOHp6c3ZQQWN5VU15SmhKenE3Zk1MSzdBVmIwc2lKUzBm?=
 =?utf-8?B?bkwzZjd6WTV5TFBtaXFUZys2MzErajNkVkhmS2dqa3RtaStHU0twbWxJRHJ4?=
 =?utf-8?B?UkluTmVRWjkyQWRTSFBSMzlTUElVMFF0MC8yWmEwMVFTaDlUTDNSOXdFdlNY?=
 =?utf-8?B?SllGRGx6dGhnbHhUSEhVTzVCdEloaU5wT01POGpBNStiSFpQNVMvSzlSamlx?=
 =?utf-8?B?K0Y2K3EvdzRZRWtMbXNGbkJPSWxPUDR3V1orNm9kZjRQRmdPOFVCdk04N0Vp?=
 =?utf-8?B?V0ZWVDdpM0hYbytoMXRDbm4rQThhckVTRjFlM2RtUy9pTVo2UGgyMTQzb1Rt?=
 =?utf-8?B?TTlleWJVdk5LeSs5emkvdzVsb0k3czBxODJIVlg2NUpSOUdLMXV5amgrNVBK?=
 =?utf-8?B?ZEhuUjV4RjdIb3REMU4reDk0azFrT0VrTHYySGkyd3BNUkdUNFFtc1c2L2JL?=
 =?utf-8?B?dmtxRjZiTm1kSnc5bFJUSHBtdUQyMTRUQnJYY1hzZ3FrdVh6Q0NDZ213WWty?=
 =?utf-8?B?eVZQa0ZWUG5jUXpPK1d5MnNwMG81dDhFVWhhMlcxMHNGUTZLWkVISXdQcERo?=
 =?utf-8?B?bFpoWnZIZ1k2RzZlNnF3QlpTS3ZUZ0RyWXU0aTV0MU5qU251TnV1VUtSZ2Rq?=
 =?utf-8?B?RmxLRFNVUUo3L3NEU3VQSHl2SFMrY2lxNk1OYlprUXlneE85UUd1dkg4WmVR?=
 =?utf-8?B?NHJsYjFNVndMVEdWZTUxSFlOT0oyeGpBQTdZWUxNYTdVcnlYU3o3N2h6eEcw?=
 =?utf-8?B?UzlCTHl4UlZQSkpMR3RnMXlTOHFCZmh6Wnl3QUdFY3dnWmlnLytLbXNFeSs5?=
 =?utf-8?B?TXNrL3dBY1RHMDFmNUcyM29WS1BldEZ3SjA2T21UK1JjMDRNVkNLbmJOM2o5?=
 =?utf-8?B?V1lZYm9UQnRuRXN4VjlrakV3NlJUK2pTWnlwWFBsV2xLQ1NrZmpqa0NBS3J2?=
 =?utf-8?B?TFdkODNmNndhZEM0STc3ODllRld2bmRGOC96SHFxcm5vSzJMQU9Sd1VFa0g5?=
 =?utf-8?B?ZWltb1R6eXpKdXdmTnRmbEcwMUZKNVcxaTQ1Q2JIbWE3NkxmcERiZENwQ0t0?=
 =?utf-8?B?dU42R0VQMW9qWS9BN2NoRDhUK0RhMitrcW1uZ3lJZmtwQmJiMnhhS0ZvSEs2?=
 =?utf-8?B?MmV5OUtGVzZ1bzdMb1RjSUNNT0dDMW1VbUt1a3NpNzRNSnNITy9wMlJXMGR1?=
 =?utf-8?B?UVArTVZVU2l1Y1JNVzhtejBCcnJxU0dTamladkZxVzFEOUhRSVRIMThMNG1D?=
 =?utf-8?B?ajBzSGxrcGJ1TEpRL1FuZDJlaDlQdDFrWnF1aEMyS2NVR0FwSWZtTkJ6N1Zo?=
 =?utf-8?B?TWl0dkNyaDV6Q3Jqa3IwUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cGxIR01Jc1EwbXQvcjhqYnc1TVU2SERLWERmWmljcnU5b1ZCcC9PYjQ5RG0x?=
 =?utf-8?B?UDdxSHp4SlJGMkszN0kxT2t3VTJUZnpQZzNmcXY0cU1RcE4vbDZnalZETlNH?=
 =?utf-8?B?RThoNDB4akMydkp4ckl2cmtJUW1vdFhuYzdzNDRCeVZja1ljZHRMMFBGekto?=
 =?utf-8?B?SXZZaEdUYWxsSm1hZEh0SnhnbDNPdEVpZGJKSVcxT3NuY3I2QVJyNFV3ZEli?=
 =?utf-8?B?Z0k3d0FsYWhFWXBWVTdVSVNnUUJHaUllclFKbkFlRC9SbjBHalYwTWVQWng4?=
 =?utf-8?B?ZmlJdCtqRU9xOExnbXR1UUZaNGV5eFZWM3N6MG9xcEFiS2hJSUdXK2dLdGht?=
 =?utf-8?B?OEhMOC81QmRTRVI1WTN0d3lZM0VkVEI5bzVEbW90LzFGN3NqVTlyOURKTVRF?=
 =?utf-8?B?VFB2MlRjMU9UTzNhdTJVaWhJWnFVZjVZTEZYTUYzc3hFdGh1Ui80bEgraktP?=
 =?utf-8?B?T3F4T1RVWmRVdlQ4R3dTUUNQbTdGN0RTRWV6UjFwS0hVTkl3R3VsSVFqandP?=
 =?utf-8?B?K1NzV1FmV1lsd3NCTGN0eDNpcEpRTVdUajFZZitsOW9jT2c3dkRQb3Nkdk9G?=
 =?utf-8?B?MmpPRzZ2WWpBd09xdVNidGFHbk1WVXNHNFVUNzVyYXI0SnBKT3F4Ym9kYWg1?=
 =?utf-8?B?RWozTXh3dWNvamtrT0g1cDNiVmFsek5iQzZtVExNUGliTkpVU3dSUGJhajZq?=
 =?utf-8?B?WkdRaFNMb2F1dTRKQ1p0a0tTc3owdXJPNnMwZ2o5d3RsdjdzYlJqWmFxK0ZR?=
 =?utf-8?B?eGJIVDRKZVV5SHZPdDcrMkxoTkR0UllxWGVBbnVzZW9OcUoweW9uOU9MM3Fv?=
 =?utf-8?B?M0d1WWJ5bDVtSGpUK3N4dmNSdEZMR2VBM3IrVVlUZExFTEdBcEFUaHBubWhR?=
 =?utf-8?B?cUFlWFJkcWNiZC9hRVg5T3FDZnh2WGIwSFVjTWxQNXJFdTJreHRUK25FWm1t?=
 =?utf-8?B?elRQNlVsUHFZNEtpWHZ1RDQzVWE5REdibTY5K1VjOXZRanRBTExuQ3BjZC90?=
 =?utf-8?B?Uzl1QjlJNS94cGV6dElDQ003MWhiOWlkbExPaFdYTFladjE3RU5YdVVVeUFS?=
 =?utf-8?B?ZlVwT2ppb1hVVnJGSmlrbnVOTTZPTytxcnlMdFZKcWtUd0IyN0s3ZUVROFpn?=
 =?utf-8?B?UzVla0V4ekFkTVlsSExMS3JTZTI4WVYzYUhnSnFPZXNPdElwN3FaM0s5anZD?=
 =?utf-8?B?bVk5S25tV3c4L2I4QXFUUUFOaktZYlhPdDVSQytHQTBoWCsrNFFsOWUvajJN?=
 =?utf-8?B?cGExZHgwY3hqUXUydmZ4MVpYRkRJVkNGQTBodmI3ekhjUGMvVTM1ek5OT0Js?=
 =?utf-8?B?QjA1Y2lVZzMyY2U2OXB5NzYxQ2JhdnNVZXV3dW4rSTc2ZjFqZG1PWlVUOVJV?=
 =?utf-8?B?Y1BKdTJITkNUd1ppVEhDSThzVjBYV0sxZ2tjZlY0YWZtdXRTMngvSDI1Szg3?=
 =?utf-8?B?OGd1dWZ5YlFKY01WVmVqUmFqdjd3VFFtWUpxYm1sVm5nT08rb3BVQmR5WmNO?=
 =?utf-8?B?Z2w3SGlYckZBOFd3SGg2S04vRGgwamJGYTFqb3IvRk5teXMzKzlSNUtCdVdS?=
 =?utf-8?B?Qm5wL1ovaDBKaE4xQy9RTCsxQXRjVzRJWW96UWhwYjZ4KzFZOUFrNmJVZU9H?=
 =?utf-8?B?dStLMkJxN3MzbEpFQWhHUEorVnVFOGVQWG9nQ0thNXBYVVp0MnBablN4Vms0?=
 =?utf-8?B?WHdSOXdTU1FZUjJueGQxcjNPR25pakY1QTdFT3dBekg5NmRqczhaZVphSEwr?=
 =?utf-8?B?enQrRHVKMlpnK2hXRTdVUkVxZ2dmN0FER3pXZ29NdzlJbXJBcVpwUGNhZFBo?=
 =?utf-8?B?QmIwV2hwd3g4RTlwbUhncGxJTXpXclFKRTY0eExNZ0VDY05MR1RXRDJYY0pY?=
 =?utf-8?B?dXVwMkZ5bXBGMVgyZUU2RWt0a3IxNTRNdjNnYlNZUitqR2JoMC8zTVR4ZENP?=
 =?utf-8?B?U3RkRDN3TS9ZVWx4Ri9zYjFCVDhVamdtUWJqL0toRVJPdnBXZnpLM0dDWk5l?=
 =?utf-8?B?MTV5cWxaL3NWbCs5am9WK0FtMTEreC9xZ0dBd255c3RTTXg3cms3RS9UV3NQ?=
 =?utf-8?B?Myt0WE4vUC91emNmRjM5TU9BK3R4Y1luQVZqK0lQeFJhaWhjSHpJVUYxYlRC?=
 =?utf-8?B?ZzA5OTd2MFgxRStTdE1GcWMrcGQyQ0VDalZwZ3AzY2VoRkE0c1hIbmxBUm5w?=
 =?utf-8?B?M0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EBFDCB46E1A2CB49A37F08733725A513@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abd38abc-5bce-42aa-7704-08dc78ff61f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2024 19:02:23.5039
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qLbRdZOHo6rIxOu2a0+uN/C+cbvEnq+c0+4FK59uLCzf7q8VM/4VOkfjKm0HEig+QaHWih+CGdDsGPEeqLxaXRlm0U0EIjbPdxqb3K9EHaE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5090
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA1LTIwIGF0IDExOjU4IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gRm9yIGhvb2sgbmFtZXMsIHdlIGNhbiB1c2UgbWlycm9yZWRfcHJpdmF0ZSBvciByZWZsZWN0
IG9yIGhhbmRsZT8NCj4gKG9yIHdoYXRldmVyIGJldHRlciBuYW1lKQ0KPiANCj4gVGhlIGN1cnJl
bnQgaG9vayBuYW1lcw0KPiDCoCB7bGluaywgZnJlZX1fcHJpdmF0ZV9zcHQoKSwNCj4gwqAge3Nl
dCwgcmVtb3ZlLCB6YXB9X3ByaXZhdGVfc3B0ZSgpDQo+IA0KPiA9Pg0KPiDCoCAjIHVzZSBtaXJy
b3JlZF9wcml2YXRlDQo+IMKgIHtsaW5rLCBmcmVlfV9taXJyb3JlZF9wcml2YXRlX3NwdCgpLA0K
PiDCoCB7c2V0LCByZW1vdmUsIHphcH1fbWlycm9yZWRfcHJpdmF0ZV9zcHRlKCkNCj4gDQo+IMKg
IG9yIA0KPiDCoCAjIHVzZSByZWZsZWN0ICh1cGRhdGUgb3IgaGFuZGxlPykgbWlycm9yZWQgdG8g
cHJpdmF0ZQ0KPiDCoCByZWZsZWN0X3tsaW5rZWQsIGZyZWVlZH1fbWlycm9yZWRfc3B0KCksDQo+
IMKgIHJlZmxlY3Rfe3NldCwgcmVtb3ZlZCwgemFwcGVkfV9taXJyb3JlZF9zcHRlKCkNCg0KcmVm
bGVjdCBpcyBhIG5pY2UgbmFtZS4gSSdtIHRyeWluZyB0aGlzIHBhdGggcmlnaHQgbm93LiBJJ2xs
IHNoYXJlIGEgYnJhbmNoLg0KDQo+IA0KPiDCoCBvciANCj4gwqAgIyBEb24ndCBhZGQgYW55dGhp
bmcuwqAgSSB0aGluayB0aGlzIHdvdWxkIGJlIGNvbmZ1c2luZy4gDQo+IMKgIHtsaW5rLCBmcmVl
fV9zcHQoKSwNCj4gwqAge3NldCwgcmVtb3ZlLCB6YXB9X3NwdGUoKQ0KDQo=

