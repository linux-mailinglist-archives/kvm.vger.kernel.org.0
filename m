Return-Path: <kvm+bounces-20911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3691D92693A
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 22:00:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54BA11C21D1F
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 20:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69662186E32;
	Wed,  3 Jul 2024 20:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DtSVUzpS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5413E4C6C;
	Wed,  3 Jul 2024 20:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720036836; cv=fail; b=t0ECEbou4MzEjdLyQzgtpbOB+0XCGGP4RSwpdsyNelvCbH3Y2jLDIXR/JiEjHpkZMw3sTn9JdzLRQJGpllUCHidifTBD6aht+5w1kQlIDpFxjX8QmhOqUFMDIjZh0rvCmZZKD2ycj2lKHTFe6YEJsWFMT/zwXeA0X3Gjk4qmJgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720036836; c=relaxed/simple;
	bh=yHZPs0Wdk6IUbYSc6rRTimnTcdLAofd1xU1P4Cu3ayc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AVL9z8b5wrpc/im8vtXs/SPfxFZHLJXm69w78EtYkjnn4ouLzt8ZdMb1Lfjs8cMvoXIXg24R5eBG2TrJiI0LV1icpQiZ6Bv9QaZ5OfnTHWoVbST8ebgzi4IGHejAWJ34f+yBxntXPdKwAAkciF/s9n/yWTPnmuJl3L49kCGSZWo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DtSVUzpS; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720036834; x=1751572834;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yHZPs0Wdk6IUbYSc6rRTimnTcdLAofd1xU1P4Cu3ayc=;
  b=DtSVUzpSOls6K1Nm88/0AVloxtSYdVzwZzC4vQsa2KR+tCZRuKfZ/piO
   J/ZDPROUOBF1m/pexsHoqesbLkw1qJh1HLgbxZxhMCVAkZFJm+CgaEZTr
   HvPINoG9SnwVA1UHFb2CSGLUa2t4RKWqTZJT5XPsnkDgretaIfiEgTMZf
   PFD/qYBnNa0Kq3ydbBcm0IQDpsf61yxEYOxN0e7Cr9CdWMkrJMRr3W1PV
   xc9kCbEI9nzSwDwy/Ym7wNTmUl0rRiyhZ9cwThyvPWvv4GXkDNmR655N+
   eHdc42zpGmAJusEd4Abhrv0Tjs5MyG+hBw0gtETMIEcz88IUpd/f0mWtn
   w==;
X-CSE-ConnectionGUID: PmnBT3AMROOhigozRGQD4g==
X-CSE-MsgGUID: 7HL3HNGFQKGO9qSuEQPxbw==
X-IronPort-AV: E=McAfee;i="6700,10204,11122"; a="28431871"
X-IronPort-AV: E=Sophos;i="6.09,182,1716274800"; 
   d="scan'208";a="28431871"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2024 13:00:32 -0700
X-CSE-ConnectionGUID: 57rG+ygvSqq68R+P2tqDVA==
X-CSE-MsgGUID: KsF3TUVfQz+hZW6WIow34g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,182,1716274800"; 
   d="scan'208";a="47115027"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jul 2024 13:00:30 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 3 Jul 2024 13:00:28 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 3 Jul 2024 13:00:27 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 3 Jul 2024 13:00:27 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 3 Jul 2024 13:00:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9/e4Y71iL7ylYrR8b8orRoz048Ap/fpnWZTYbhdYrpz/Vjg8RTo4NJr3IAl2hV2JB0xaxONfkxRt8gx32ioVycOZNw8exeGT9sh1SBMCvS2jFcvikyq2CZRdAygRhjPmiKgVcIJKBvoSI3IYiI+JgSpUQKVLFe5sf1VM3tB1XqiVYGJ4RPHcTwVSGCFQWz/9sp3hQfxqoyEVpcym3y8Mzsco/oP982gaUGckIGXuJtxwr3k7cRsr7wZOwyIFkIdiTXu72B3l2R4t6MsJihs0/xRekncQtkmpn76hNaNoysLllRYs6MBBAHZQngIn30HdFkidcErFTAFaAVuGfUbhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yHZPs0Wdk6IUbYSc6rRTimnTcdLAofd1xU1P4Cu3ayc=;
 b=NJS1BZWQ4O/IQTTYi2aWAAKaD43wBxdLVPFf0ywrzzhUNgZdQBGGQ/N5YHD5sTK2Ek7rFb73S+lbfSqCyqAa7vpGcos49Jdf/9k0gx9YIfbE6U0nPTYqOCw3cV2FTw0jIisV+R8aD482hAaZI5qUGzg6lOaX2yvZBRgZpQSnkL7dEZv3JoKF2deRUHypVTKTgWE9B6v1/DUw/UzlBVwCaiH/uUuJGJD7qGYoh/E8c23mIs7Q3NhYHY6hyTmU6nFDU7ha9Ww6glU82mFDoJTlE11w539QbynYbWBv5Ji1uxaO/6CtNxKP0wU/WSaonkD+x+rLB4sSFaS2/swqyOI/9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB6032.namprd11.prod.outlook.com (2603:10b6:510:1d3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.32; Wed, 3 Jul
 2024 20:00:18 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7719.029; Wed, 3 Jul 2024
 20:00:18 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v3 17/17] KVM: x86/tdp_mmu: Take root types for
 kvm_tdp_mmu_invalidate_all_roots()
Thread-Topic: [PATCH v3 17/17] KVM: x86/tdp_mmu: Take root types for
 kvm_tdp_mmu_invalidate_all_roots()
Thread-Index: AQHawpkmqvK9+rV8gk+Fb4hYJXFjCLHRzw4AgADIg4CABASjgIAA908AgAB1KwCAAPZwAIAAW/6AgAwm8gA=
Date: Wed, 3 Jul 2024 20:00:18 +0000
Message-ID: <c2380408eff9fb8501f2feee571e96eab5ca882b.camel@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
	 <20240619223614.290657-18-rick.p.edgecombe@intel.com>
	 <ZnUncmMSJ3Vbn1Fx@yzhao56-desk.sh.intel.com>
	 <0e026a5d31e7e3a3f0eb07a2b75cb4f659d014d5.camel@intel.com>
	 <Znkuh/+oeDeIY68f@yzhao56-desk.sh.intel.com>
	 <d12ce92535710e633ed095286bb8218f624d53bb.camel@intel.com>
	 <ZnpgRsyh8wyswbHm@yzhao56-desk.sh.intel.com>
	 <2f867acb7972d312c046ae3170670931a57377a8.camel@intel.com>
	 <Znt8K7o0gCwjuES+@yzhao56-desk.sh.intel.com>
In-Reply-To: <Znt8K7o0gCwjuES+@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB6032:EE_
x-ms-office365-filtering-correlation-id: f32dee00-5afd-4a29-86bb-08dc9b9ac395
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Ym1EWG45Z1dIQTZpcmhuclBtYy9uMmRKd2t6eVVoMndWNTlPWmc1RFVibTgz?=
 =?utf-8?B?YTFWV0piWnowQWdjR1d2a3BRVFV2NkR5MmRPb1FqYVd6cWJ2eGpBdVVLM1dq?=
 =?utf-8?B?d2VoWm1zVWJOUEtYVm5ZdWsveW5BeVV2TFk5cVNpUVZ5WXhMOEpiVU91T0Fu?=
 =?utf-8?B?TlNtV0l3OGF6d0lKZ0FaS3hsYytJMUdKYnhmbmpHNnhCelh5bnk4NjJ0VUJJ?=
 =?utf-8?B?cmg1ZDN4RWhsL0VCM2ZGWW1RVCs5ekc5S0duUk1ncnFrRGd6bmx2YVI0VExP?=
 =?utf-8?B?aTZlR0tuMTdIZVhPeitjODUrejBNaHYyZ3N2TFhBMkZEMG9xQllnYWtnWlRI?=
 =?utf-8?B?djBuZEgzSmg4dnhvQkR1c3ljN3pFODJOYi9RMEl6VzZjckVTRDhpSWlCUk0y?=
 =?utf-8?B?NHBWQm82LzdTcTNrcEVEcWJDaTRmczVHLzZRbjFGSVV5Tmd5Vm5CWTNEcUk3?=
 =?utf-8?B?eE1CZm40L3IrNE05VThJYm4ySXVDQmlKSFZoc0NBRlhqODNRbzA0VExTK2p4?=
 =?utf-8?B?Y1JoYm9KRDBOMitlWEtlZ2JKaU9SVnIwOHFGN1pWWHNGcm0zNXlQQzErWG9E?=
 =?utf-8?B?bnp6VURlVXZ0N3JRK1BRSUFKbjlQRmMwSDRIcnp6a01hM0c5OWxLRExPQ0d4?=
 =?utf-8?B?MnhkSEx6RDZ3RGJES0FNa29LQ3hOR1BrS09uZVVlUmlTYUxQWmpWQjBsRFpW?=
 =?utf-8?B?U3FCNEZ0L2tvWnU4UFZLU3VLSElXWHVwaVdSTTZhQWQ2OUJqYkVCMTRtamlC?=
 =?utf-8?B?b2dGeFc0dWswdC84VXBDM1gvNzJWYTNkL053SzMyZFUzM0RjOGtBSVRtdGxC?=
 =?utf-8?B?OFAvZmxGNjF2Wld0emlycUcyZVd1bXhaY0ZoVndVWFBqN1NFU2V2dzJiUzhZ?=
 =?utf-8?B?ck1CR3RMVWpYUXJDWnhoZXBEMTV6eUNrVmlieDFWd2VPVjBDNGkwb3pHZ21l?=
 =?utf-8?B?NytHNTUxT096Q1pqU3BoQWIrNFVjbUdMV2VNeVFXd1NxbTlxSDhsQmkwWG5P?=
 =?utf-8?B?M281Y2FTcmVBYWdpMjByZytJYXg2c2UwMFZHZTY4QTNaQ1Y2VDk1cENVN3or?=
 =?utf-8?B?SXlDZkRIbEh5VEhHRGFmWGNuc0kvYXBFdkdCOWNJNHUrM1E5bmtBanM0bDM4?=
 =?utf-8?B?ZE0zclFnYVR0NFV0ZXF5bEhBazlBYmdjM0hxMTlaaXJRWnZiNlNQZkxkWVUv?=
 =?utf-8?B?RU5WbGJXd2hGNk4rS3ZhMlBlTUdIYWJCeDF3YUNDT1gzSGR1bFdwdHg3TzRU?=
 =?utf-8?B?ZTJic1hTTGREUGFjTzNOZTZuUjBEcHAwaWxaWXZnNzBhUG5jMDJDL2tBU3FS?=
 =?utf-8?B?V09ZT0ZHcmk5Z21Nb3liL3RIWHlTcndJOXRlOXVPSVlmc0x4dHJESUVZbnly?=
 =?utf-8?B?V2lIZS9DNFFGMmNLdDFGbkJLSXJPdkNkSUNKbG1WTXBpaVQ4QnBtN3AzcE5N?=
 =?utf-8?B?MGVjdUxvaHMyUnVsTXgyRlNGNjlqeUkwV2MxV21NZmtOMzBWSWdGOVllcjJG?=
 =?utf-8?B?Y1JLRHBJSk5UYVdUeWk3MlhPSjVCRUJ6RE92M1IvbHIxUXN2YStyM2VqeGJK?=
 =?utf-8?B?V0Fva25pUHhYVC9NOGtPS0FDaHl3MExBZVFvTHlFR2VJckxzMkJwTlNjWFVK?=
 =?utf-8?B?UmNMTUVpTXliVzdtZWgwT25zNnlzNVh2aGtDRDBqYVlYQm5welR6SlVXeGMz?=
 =?utf-8?B?d3BPa2xjS3VaRm5XLzZpRWJZWFpnYURJV05sbjVpTzJVWkFrVy96L04vUlYw?=
 =?utf-8?B?U2hKdFNVYXJmK3hESWhRdkdSakF6cmxhTTRpTG1ZYVZRWUJ3eFhoUlR2Sksx?=
 =?utf-8?B?NStDSUVGZVQrZDZqNzJ4RXFKNVBqWUUyRHdBM0VyMjFsUE5qVmJ3Rnk5cXRO?=
 =?utf-8?B?dmJNa3lXNWFJYTBVNGJjcUErcjdtRUYwM05ocklMNHRQcGc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d0FTbXpBbTVNQ0ZLdUExMGZwSkZFN1RkaThOb1NEMWRnMjVybUhWNXBzby9W?=
 =?utf-8?B?WCtCMWVMbEcwaEJTcXFwU0cwVU5XeEhGNWRPcFVPYVhTcUV0cjZIT2NlcmtF?=
 =?utf-8?B?Nkg1Q2wrQ0FIeENOVUo1TnFTWGdReG5RWWZWUW93bmQ3Y1JySjJqQS9BSi9V?=
 =?utf-8?B?MlcyYnlTYmFwTmVkMGtFMjVmTTlpL1FlYkFNVFNZaU1GKzJJam5uU1lhVWRZ?=
 =?utf-8?B?ZEpETTBVOVNJOTNPZTNxL2FPUDczU3dlaTg4RmZhQzFWaFd5NGhvVGdYZXdH?=
 =?utf-8?B?a3NLdUJ4ZmpySmVZOXA2YkYyRTQwM0sycWFjREZSanMyRlZSWjhzc0tsQXg2?=
 =?utf-8?B?MzhTN3RpeDdtbnVTMXBmL3BGMFRPbmxmWFdTTFk2ZE42cmtLVi9LMzdPYXpW?=
 =?utf-8?B?clhWNmpLQWV1UHNqbEhMMDJEbkFDU1ZyUEU4b09sSGVucGlqaG1GMll5R3pk?=
 =?utf-8?B?amVkUnV5VUFjeWpEZU84bnB1QTNHR3BpTmh2Nk9odnFGbWNyZlEreEppTlJS?=
 =?utf-8?B?cG12WENrbTR2UnBDV0MwVzVtak81V29ydWJMb3NXVDZLQnBlR2RMZ2hCdHNK?=
 =?utf-8?B?U3M1aVV4M0l6YjF6RklGV0tJeGozMytkL1lyK2drL3ZFSWhCS0RwS2VQOXVx?=
 =?utf-8?B?UnpiRVFGbnJOZVU2bmFhenphdXhHNUZXRVl5cTZ3QTR6MmpMOGpHbS8yTUpn?=
 =?utf-8?B?dTAzWHFpTk1xQlhJRjJJemVtNU5ndDd4U2hzQy9LTHo0NzBPdEhjSU9tb1E3?=
 =?utf-8?B?ZklHSlVwUVloVGExSHJMeVBkclB3WnNXOGtwVUZTWEJaTGFkanQwTWJxcU5W?=
 =?utf-8?B?VDFFeVpDRUYrZkdwOE5uaGJCdWxHNVhMK1VQeHZ4czNGeTAxMlRzcDFMQlVD?=
 =?utf-8?B?WTlvRVFHRUFDb2dGRXhJZ0tWT0xXWXAxbXNCaENwV09VandzWSsxMDBnY21Q?=
 =?utf-8?B?VUQyZXVMQWlPRUxUVys1c3NFTWVMYVZ0NjFlVUFWYzUvY0pONEgyUG95bTFp?=
 =?utf-8?B?WjdaMDZrYXBuK1VGWjNEL29iNEd2cDBMUHpPZ0NjaSs4aFlXdTJRWmhkMXVN?=
 =?utf-8?B?TkNHODBOWFcxYlFLV2pmZTZtYU55LzNiRlRQQ1ExMktkVTlFWng4ZzZEY2Ni?=
 =?utf-8?B?YnY4bldlcUJuVU4ra1haRzFBeDFaeHhEZFl5ZGVlK3Y0YjdXZ090MUNtZUJ6?=
 =?utf-8?B?RVpZOHhhWXlaZUQxSmRyRmhGVGlWdEhXZXdjbHN4YWpMUStYOEVJV0Q3V0Vx?=
 =?utf-8?B?eU5HaldwK2JmeENYVFR1a1lsWGx5aDhZZUo1T09CVXFiR2hmeEUzY05OeENK?=
 =?utf-8?B?ODNkOHpsd3p4ZzdlY2tTai9janVidi9Od29xeTBnL0dkY1JaaS9TYXY0SzBP?=
 =?utf-8?B?N1JaS2FhZmFnTk1zbHM2a3ZzZFJRMXBRNFErV0VzK0RVTW1iNmVVZmVXUUUw?=
 =?utf-8?B?cnQ4MFpXYmJyckZjTWZLbVp6VEttNUpJNGFFKzBOa0hoaFpTbDlsWXVxWXlE?=
 =?utf-8?B?ZmZGWFhvUnFrS3dTQWVlT0tZVVlKSWdjREphUzZrV0FCVDVlTm0wOUJyUy94?=
 =?utf-8?B?Mm85czdnMWZnYTFLVGdxb051eGMxNG1WWVBDRWdVTnNpV2gzQWV0a3BRMHNx?=
 =?utf-8?B?M1AyTE4xUGx5LzRvYTFVc3lXZVZEelkwSVQ5WVErZkR2aEhpTVpad3lkd2JC?=
 =?utf-8?B?ZEo3ZWRDUnIwNlArT3ErRytwRUJvR3Z2U3EwYThKc0tQNDgvU1pnVHphZDlk?=
 =?utf-8?B?SnR5WW5VNnBUYmhFdDFDdzR0c2t0Tk5yTVhBMVkvQ2lDRTAxN2pGYjNTZWFC?=
 =?utf-8?B?SmRhd2lLWVlUWWlKckxycThienR1aVIrd0ZWQ2NCVVJqTkhWeWQ0N3RTRk5v?=
 =?utf-8?B?bXNQWGtrSXk1dFcwM1RjcFduWEwzZVYyVXR6QnFBajgyZHJhQ3RsU3BSK2p2?=
 =?utf-8?B?NkVkVzFINEVqY2tMN1R4aDRzQTBVbmIvak1jQjVrcnZqTlJuamd6MlVMMVhX?=
 =?utf-8?B?MXVCVmU4b0tvdFpza3RjVlhLOC96V2ZCU09MWFRDNUs1SUJtUkVJQm4wTnQ3?=
 =?utf-8?B?dHJmTGYvNGlEeGgwTU1vV2l1L3N0Z0d2cGxkek9HQWoyc2Q3ckVucXhRR2dC?=
 =?utf-8?B?UUdyVkpOWCtMOXZHYlc0SDFwd2NHbllHaTJML25WK3Z0VUFDM20wcE1LNVhG?=
 =?utf-8?B?RXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C5E37846ABC47489DC44ADA9D94E0CB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f32dee00-5afd-4a29-86bb-08dc9b9ac395
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2024 20:00:18.8208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y3388hCyjYMZZ9FW1yr4Qj9cpJziYE6R0qkb7u6e8F/SeNdtyGQmrLY71AzLbHPOgnd7RGTVKiu+WlI550dnRRvz59q9I7iWs7Q5AYe2BfQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6032
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA2LTI2IGF0IDEwOjI1ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBN
YXliZSBiZXR0ZXIgdGhhbiBhIGNvbW1lbnQuLi4/IE5lZWQgdG8gcHV0IHRoZSB3aG9sZSB0aGlu
ZyB0b2dldGhlciBhbmQNCj4gPiB0ZXN0IGl0DQo+ID4gc3RpbGwuDQo+IEhtbSwgSSB0aGluayBw
YXNzaW5nIEtWTV9ESVJFQ1RfUk9PVFMgb25seSBpbiBrdm1fdGRwX21tdV96YXBfYWxsKCkgaXMg
b2ssDQo+IGJlY2F1c2Uga3ZtX21tdV91bmluaXRfdGRwX21tdSgpIHdpbGwgemFwIGFsbCBpbnZh
bGlkYXRlZCByb290cyBldmVudHVhbGx5LA0KPiB0aG91Z2ggS1ZNX0RJUkVDVF9ST09UUyB8IEtW
TV9JTlZBTElEX1JPT1RTIG1hdGNoZXMgbW9yZSB0byB0aGUgZnVuY3Rpb24gbmFtZQ0KPiB6YXBf
YWxsLg0KPiANCj4gSSdtIG5vdCBjb252aW5jZWQgdGhhdCB0aGUgY2hhbmdlIGluIHRkcF9tbXVf
cm9vdF9tYXRjaCgpIGFib3ZlIGlzIG5lZWRlZC4NCj4gT25jZSBhIHJvb3QgaXMgbWFya2VkIGlu
dmFsaWQsIGl0IHdvbid0IGJlIHJlc3RvcmVkIGxhdGVyLiBEaXN0aW5ndWlzaGluZw0KPiBiZXR3
ZWVuIGludmFsaWQgZGlyZWN0IHJvb3RzIGFuZCBpbnZhbGlkIG1pcnJvciByb290cyB3aWxsIG9u
bHkgcmVzdWx0IGluIG1vcmUNCj4gdW51c2VkIHJvb3RzIGxpbmdlcmluZyB1bm5lY2Vzc2FyaWx5
Lg0KDQpUaGUgbG9naWMgZm9yIGRpcmVjdCByb290cyBpcyBmb3Igbm9ybWFsIFZNcyBhcyB3ZWxs
LiBJbiBhbnkgY2FzZSwgd2Ugc2hvdWxkIG5vdA0KbWl4IGdlbmVyaWMgS1ZNIE1NVSBjaGFuZ2Vz
IGluIHdpdGggbWlycm9yZWQgbWVtb3J5IGFkZGl0aW9ucy4gU28gbGV0J3Mga2VlcCB0aGUNCmV4
aXN0aW5nIGRpcmVjdCByb290IGJlaGF2aW9yIHRoZSBzYW1lLg0KDQoNCg==

