Return-Path: <kvm+bounces-18462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E5AB8D5708
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 02:37:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7D0DAB2268C
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 00:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57289101EC;
	Fri, 31 May 2024 00:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C00GOwHZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2259DEAC0;
	Fri, 31 May 2024 00:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717115820; cv=fail; b=U/QAaaFozW9bjSh+G7EuyVsmQxRVK4LGASMcdJ9fVkHIlxGYltx098g7JrvrkMbckcvpdqF+6YI3f+Dgtfx7OupPykf0xe12YW0c3eODoe0ntS4+0xIxoaUPjbt+8z7/Em1DD2XLz76GU3vC5dcsxUx5Pyi6uNBqcPycQ4jfuo8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717115820; c=relaxed/simple;
	bh=MqGv4y1WtgJSsBgK8YfHt5KSS0ChSgox4qF1pErGv6g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=k+T4QWMoWVzeGfpfEpVZkZ4ALCpfL1uoSxyKOr6JTWLQM7vlHR06zLs9MpJutwxKKwm/wDpFA7dSNqU3LTZ8n+Cz00wzlzcqLEl3tYICxhYoiker2FlDF2rvBuQ+ivewx8uNCUUsWz7OFL/5mgOBbaKOiDrFjeI2Y+NyYV1SHXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C00GOwHZ; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717115819; x=1748651819;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MqGv4y1WtgJSsBgK8YfHt5KSS0ChSgox4qF1pErGv6g=;
  b=C00GOwHZ9Cfbbg9w3HWj0psQ5z3LYsn1cyqrBMCfb2KjV/FeifmfUFtw
   9C62v/2r91bimqTj3PMc+yqLkXCL3B7PwJEuJOQ6lsTtBXlS+l+c8fzCN
   UNuIGNJu5URwJaxn/Uwphh7fdYTZiY/vMdLla7P++VJEjpMBVvmVGbT/j
   TX6YicS91VY8763w0GJ+mVVq6/Y15dZEu2duGJ/gaSoIrqKBsTQkau1c/
   fOnL96s+w/yGI170cz+tzgmBDowK1bx7CUMX9JSKPSRXeAP5i8lOsnruy
   0qwAON+v+kOeNx1/a721/9JRF220kcCOgJzpsSAlkfdB8qa00Dql8ivaq
   Q==;
X-CSE-ConnectionGUID: Z/klRqDgT3WWLzwlzUzo0w==
X-CSE-MsgGUID: 4QnEDiO5RhGUxOsbK+I6zg==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="16590514"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="16590514"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 17:36:58 -0700
X-CSE-ConnectionGUID: 2g590DlqQaG824JsQFFUpQ==
X-CSE-MsgGUID: PY3oSHYTSoqc3vo1qmNHvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="36076408"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 May 2024 17:36:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 17:36:52 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 30 May 2024 17:36:52 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 30 May 2024 17:36:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ncYULVN5aqGY8qPI4umIk9rhqNqBg53MNeDZrN1YIdqDyLRvdnadPjDpu+fql8kQzEW1F65uj9a4XWhUuCK0fSqZGkFUNfHjl2EE0JAFoMdSo8OpTZdw/Swg7/qQjfAQBPBziogLjaKxmgkvsHTkflP0fCFBlygR3a2E1TMJ3E5MqADxNlYHHGnZpBob7YuE2wIOa6aX/mJJuY9Studc3YmN3/zBA8m53eftEoG+1v+JHP4A3AcCZRPxOos7LM1QMgmtagx88HqcDUDzvCkTU/AzGzAvjoADxT79Na56Y0jBiXcb7SPgcAsvm+OOpUx3Lpljkz+1eMfZUFdnuCt3Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MqGv4y1WtgJSsBgK8YfHt5KSS0ChSgox4qF1pErGv6g=;
 b=bJ69lCTqnGhZwHo8GjU5O4IGDNf0sB2I9RhLl4WXhiuTNTM7TAGXZ6IH3kTMa7hMN/NKOObjGXacxvLc4iBZ54hA1ZrQqXzeRmqYawCvXvjNAe7meE6lnE9HKfDfi0OMn5S94TtCmhu0qjUfkDYO0xgbP5Hz2QOyt0NVOFpXHZd05TtOGExQ67xAICRAt9iDDQxf2fNwSOVdIMOBbbYruXPU1beeU9Ii2rYZEEzvadFBFXxOJm7/fNwjesHDzapfqOmbYDRTSOeoR9BCLir6ebL1gMQWaRdhNEijlPGUyGe2lPISGwsCJJeabrHQiYUqc5Fwp4B99i3B+gVA2zPEcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA0PR11MB7694.namprd11.prod.outlook.com (2603:10b6:208:409::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Fri, 31 May
 2024 00:36:50 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7633.021; Fri, 31 May 2024
 00:36:49 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yuan, Hang" <hang.yuan@intel.com>, "Chen,
 Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
Thread-Topic: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
Thread-Index: AQHaaI2/dJkfmwuOl0Kzt5Q4G20a/rGPjNSAgABl+QCAAANegIAAB3kAgAAJ9QCAAO1bAIAFfyEAgBj234CAANvZgIAAtdgAgAAXewA=
Date: Fri, 31 May 2024 00:36:49 +0000
Message-ID: <ab2e918df4191d098b9b6fe87c7f14f2da734a3b.camel@intel.com>
References: <9bd868a287599eb2a854f6983f13b4500f47d2ae.1708933498.git.isaku.yamahata@intel.com>
	 <Zjz7bRcIpe8nL0Gs@google.com>
	 <5ba2b661-0db5-4b49-9489-4d3e72adf7d2@intel.com>
	 <Zj1Ty6bqbwst4u_N@google.com>
	 <49b7402c-8895-4d53-ad00-07ce7863894d@intel.com>
	 <20240509235522.GA480079@ls.amr.corp.intel.com>
	 <Zj4phpnqYNoNTVeP@google.com>
	 <50e09676-4dfc-473f-8b34-7f7a98ab5228@intel.com>
	 <Zle29YsDN5Hff7Lo@google.com>
	 <f2952ae37a2bdaf3eb53858e54e6cc4986c62528.camel@intel.com>
	 <ZliUecH-I1EhN7Ke@google.com>
In-Reply-To: <ZliUecH-I1EhN7Ke@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA0PR11MB7694:EE_
x-ms-office365-filtering-correlation-id: 936c5a83-36e4-4352-983f-08dc8109c29b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?YjFsWnVlckI5eGFJU3JPS3lvMXhNeUdjclREMVRLbTZsMUVNRWVCVmlDeTg4?=
 =?utf-8?B?amdRWmt0NXRmN09uRWN3Mm1aTW5keTBNUG5PYkFwYytNYUdNVXhTY2k0Ykx5?=
 =?utf-8?B?Sm13ejF1MElxUW9SL2Rhb1FLSG83Y2k5OVFQMjU5NHlLcWtnT25CQUZDT0JY?=
 =?utf-8?B?aVBhOVVIWEJvWW5kRkg0MDloQk9raDVFSEswQWNUbER5SktrSk5kZkZxY1N4?=
 =?utf-8?B?V0ljd3dhRkh1UzdPelpLc01jU2lXdDVxQUpLNG9lK2VHUmMyK3VwYlArdnpM?=
 =?utf-8?B?UUtYL28zYWlTMFh6N3hhQm9nbHkrRVpVeWJ1MzdxdTg5Z1Y3bStDU3NyNjRM?=
 =?utf-8?B?YW1yNmtHSDlBUmRNOUFBRWlFblZyS2hKL09MUVdXd1FLalFSQXR1Z2RyUjhw?=
 =?utf-8?B?MUl0L0w3VDBsMGhXNFM2MUtabzlOTFBvNVFEaXFhczhoWmo0SmRFODRFK25Q?=
 =?utf-8?B?ZTdaTHB3K3l5dldCU1ZWNjEyREk3ZUUyNXhuTVpUQkFFK2xxS2pEcXpKUS9u?=
 =?utf-8?B?UkozUW91azY3UXN2VUxZY0RLZDVIbFRPUE81S0w3cTVZY0JscmNkR1p5U3Bm?=
 =?utf-8?B?MTF6RWpjQVYwSnNLd3pFS3I2aW5PTzVJWmhUR2k0VUNBdWlnc3VzRkN5VUFH?=
 =?utf-8?B?Mks1VUFrdkw1NldSdFZnemtCSE1nYUN2UmpMbHBpK1VBRTA5a2dlVWRQMWs5?=
 =?utf-8?B?dGZiMFRyZGppWjhMTlNXQ2dyTnY3REM3UUQwQ2dXTFUvMDVQajFQbzhoRDlL?=
 =?utf-8?B?K085dHk0QllKU3VWZFhIMnJBcC9IV1lqSzF6TjN2K1Q3VThiUjVrc01yMGoy?=
 =?utf-8?B?c3ArNG9NcGRxZisvUGdLUzRWWVNBQnR6d1c4SG5qVW1BZVJtei8xUHhIenR5?=
 =?utf-8?B?cHZxa0pENHJDeXhTMkdFRU9Lak1JekNqRk1SZlQ3K0dralQrRVZNVVNIbVFH?=
 =?utf-8?B?ZXBSb3o2VDJkZWJyc1RJL0dGRFk2S2xxOE9jMzMyMVRBZDFFOTJmcm1hWDd1?=
 =?utf-8?B?UEhlUVNBOU0zRTBucmFYVDgzOFIvM0xxTENYUXE2Z0Y5VnRFVE9MSHJ1WGMz?=
 =?utf-8?B?ak1GbnJZVUt3dlpJcjY0US9lS24xQUM4bGtFZ01rUEQrdGRXNXJZeTltUXRr?=
 =?utf-8?B?VGNhaURLYnpnTVUvNmgvcDZsdU5PaU5Ecys5cmg1RE1xWTUxYkVkOFVlQlVZ?=
 =?utf-8?B?My80MUltS2d4S1ZhVU1NcW5tTGR6QU1valNtVGxXVXh1MDVUN3AxbnNKYXdF?=
 =?utf-8?B?ODRnd3JJV2lMNVVaVjFBblVwMXhuQzFjTVA4Zm5CN3JUWXJIc29jVlFLUTlk?=
 =?utf-8?B?dUZkR010SUwrWUE5UUFJM2FiQzdnQjJZL3VOS0JKdnl1RUY5WE9wK1ZJYTFq?=
 =?utf-8?B?Qy9aQU1BZVJyWU1JeGtLS2lINDhBS0o4ckdRRGQ4UFl4K2k3enZTRXR6SmlU?=
 =?utf-8?B?ci9tZGtsb0tBMVdQMHB5ZlJjSGNHRHJOc0RKU2JzcHgvQmtPdFF3bUtHUVpp?=
 =?utf-8?B?OW1UOWRTRkdrYUNGR2c4TWJKb1dEWnliMi9NcjFxRStkRFc3MjFTejlvZ0o2?=
 =?utf-8?B?TjdjWVc5SmpEMjlCN2E3eUZBMU0zUVFxQlB3VDUyOTBqQUZLVjdVK01oOFVP?=
 =?utf-8?B?OERjTVV1dkJjSHVaQ3JKYzdMS0JFaU41MG82dTlNQW5mU2ZVcGZibno2b1Ar?=
 =?utf-8?B?Y3QwMXdQYTd6UE90a3ovZkZ4T1FwZ3ZabE9VQ3I5aXoyaXVsSzJkQ0JRblJC?=
 =?utf-8?B?LzBobEl3ck0wU2NaRDA0L2xzRXRMM1ltOGt3Z2J4enJlR1hzVHViRkY1aVEx?=
 =?utf-8?B?bE9tT1MvWGpzdmpFLzhuUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WjBpWi8yVlhXSUhWMzZyZkhCd29ra0lDTGhMZzQ4bXpKREljVmhxTnZZdW9F?=
 =?utf-8?B?d2JCQTdOd2hHVy9uL1F1b2g5WkdFTHZBV2srQ1BoSjQvcU9WZnl1eFRKM1dH?=
 =?utf-8?B?SlhXWmtqdDdoTFZSMDFGVEtVU1pDdTJJb0ZYNkhLVTFEYXJrNjd6WU9MVTJ2?=
 =?utf-8?B?MEtHTXZLSWVIVzZBa0JVczROejVMSVFTaUNya2tNUzBkWCtvUWNaZlk3MGpt?=
 =?utf-8?B?QzM1ZmFTNHU4UFFDaHNFRHlZdGVUcUltWnA4Y0haclM5RnhlN2ZxTkV5VnFR?=
 =?utf-8?B?VUJTVERLaHI2eFF1NEE1QTZGVGZ6ZGh2cFB4SjdzWkRiV2pOSnFhUGpUUjIv?=
 =?utf-8?B?ODQvSDFQOGlzWWJCSFE3VDZ0dW5lVGFOeDhuMFlQOTVhOWEydHRQdEFmemIz?=
 =?utf-8?B?bFdkdUFRNTZaa3ZObnNhOFNkc1grUk5hSFZ2bE1sd3Jud0J1WUVqVUUvTVhL?=
 =?utf-8?B?c042aWpFeXR5ZnUzeVpMUXdpdjE2RUFNMGtFNWlMUVhvQkhDNjVreCs0R2hL?=
 =?utf-8?B?QjhaczNxMlErU2dzeGlFQm8vOVAvOUdRNXRUQ24xQ2c0MUozdmlQWlNDMGNL?=
 =?utf-8?B?R214dXo1WTJvMGtNSGNxYjBHbldQVStFUDVvYTFpWWp3S1hhZEhaMFdIZzZB?=
 =?utf-8?B?Zk41U1RjQzJ3dTlBS1lseHpiWWRuZkZBb0thKzNpeGNFQlA5d0grNXhBeSt4?=
 =?utf-8?B?Z1ZNZjg0QVlJbVYwSk5xL0pGdXk0dC9BaExoY2ZpbGZBdVdsSzh1OVpYMGl3?=
 =?utf-8?B?aE5vZllDK3BnVDRtZzUrR1puaGJ5Qkw4SEZHQ2tySUIvY2N5YXEycTgyQ3Vh?=
 =?utf-8?B?bGVQVW5rNkJuZTRLd0NLQytUTE1kWHRIQTBOVFlBN3h6VGxaNWNqYXBtZHBO?=
 =?utf-8?B?K1FIY1FSRHE4OC96cmJzTlFHdktTTVg0UlJDaW5mNEZuQnM1WWhvY0xKc0Rn?=
 =?utf-8?B?VG9nbzdheUdKWkFRU25Wb1c5a0RIUWttaHQ4SVNmM0pHeFlqQzNmNzU5QlBo?=
 =?utf-8?B?V0Q1eExZN1QvR1RMZmVaZXpWa1Q2QS9lVjV4UUkwZjNsdjM5elpibStHVWNw?=
 =?utf-8?B?L0ZuVTBXM1YxUER3VTE5T3MrU2pOa2hZTERuMWV2U2hTK2NaVXVpR0dmUGk3?=
 =?utf-8?B?U040UFF3U2FQZHlaMUpsKzRuS0w4SkV1Y1NtNEtXVWFoc2VzTS9XT1FMRkpl?=
 =?utf-8?B?RWJ6YjN1eU1pbytlOUZVL3RZb2RST2hzbitPS1FBRlJ3RFVzb2l4M2ZUd1gw?=
 =?utf-8?B?VUF2M3hacHhQMEgyQWRRMmtRR0VzUXRKNEtpQUdhclhza1QwNVNBVmZoRnU2?=
 =?utf-8?B?b0VsbjZsL2kyTzRCeU5IN1BqZGQzakZaSE1VdFh1SStBclNoNExxb1UvKzZB?=
 =?utf-8?B?Ny9mZEhsQ2ZnKzBwUlR5V09scXRleENSV0RJRUdzZHZodktoTXZ4RXowVUlo?=
 =?utf-8?B?c1NhRGE4UENEYzA3Q2RDQnBscWlJTlhkRzlNb3FWNDVjMHFsWVhzNE0vdkZZ?=
 =?utf-8?B?bkR0bnE0ZGI5TVgvNm1VRE10eWxCLzZyZTRtNUkrN1AzVVg3L21BNFFxMnJP?=
 =?utf-8?B?Z0R4OWRuWC9MOG5HbTYvY20zQ0hRaFdlQWtUODJDamJJOHo1Tkd1N2UzY25D?=
 =?utf-8?B?QWhPUW5ySk9NcTRTZGtBRzRzUDZ3V29CTmE2anVkaGZqYjRLekxBK2UzNVdC?=
 =?utf-8?B?NFhUSFhkVnlrUmFOMENmUGd6bkRxNFF6VmtBcnlySUdIcVpOdlQ1TUVDeHF4?=
 =?utf-8?B?M0NXeEg3M0dmZ2NWWDNJa2FEbDRsK3NSMVF5MGt6VnhoanQzWFJxREJwWkdI?=
 =?utf-8?B?U0lHcW1aT0ZmZDh6eDllNWhzclJZZUxINFVWVGhxVFYyZW95R2RMVlIxemoy?=
 =?utf-8?B?eWo2QUwxbWhQeTJjdUI3L2d3UC9HeXpJUFJmRzJBNyt0V1Z2WXlxdEpoVXI1?=
 =?utf-8?B?TkErWEhKZ3NYd3V5a3FOMHBIaGRONWgwV0VDL2k1ZlY5WUdENHowdWlGb0hw?=
 =?utf-8?B?Z0wxYkMrTkJ2Nm1kSEF5SU1ITWhDSXB0R3JjUS9SaklNQnlCeTFoSmFURmpv?=
 =?utf-8?B?MWlBOWxqSmhPUEg5WVkzWmh6RkcxeTJ1Skt4c3VZSGUrR0oyMjY4Uy9KeDJT?=
 =?utf-8?B?S2dMeFVpMUhqVHlYTUNDR29EcDdhV2h6Rjc3R2MyZ1V0SWxFVTJQS0wrNE1k?=
 =?utf-8?B?bUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EEE6008B9AD41645B6921248E6C065E8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 936c5a83-36e4-4352-983f-08dc8109c29b
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2024 00:36:49.9365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R+SzrXa44/zcnCblDSlt5kc+xA5BrBNmFROZp3iZS+HOsWnbRGEMW9sXKHKO4g4pnwwSfqfcCHsYZZB2XrvP2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7694
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA1LTMwIGF0IDE2OjEyIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIE1heSAzMCwgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFdl
ZCwgMjAyNC0wNS0yOSBhdCAxNjoxNSAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IEluIHRoZSB1bmxpa2VseSBldmVudCB0aGVyZSBpcyBhIGxlZ2l0aW1hdGUgcmVhc29u
IGZvciBtYXhfdmNwdXNfcGVyX3RkIGJlaW5nDQo+ID4gPiBsZXNzIHRoYW4gS1ZNJ3MgbWluaW11
bSwgdGhlbiB3ZSBjYW4gdXBkYXRlIEtWTSdzIG1pbmltdW0gYXMgbmVlZGVkLiAgQnV0IEFGQUlD
VCwNCj4gPiA+IHRoYXQncyBwdXJlbHkgdGhlb3JldGljYWwgYXQgdGhpcyBwb2ludCwgaS5lLiB0
aGlzIGlzIGFsbCBtdWNoIGFkbyBhYm91dCBub3RoaW5nLg0KPiA+IA0KPiA+IEkgYW0gYWZyYWlk
IHdlIGFscmVhZHkgaGF2ZSBhIGxlZ2l0aW1hdGUgY2FzZTogVEQgcGFydGl0aW9uaW5nLiAgSXNh
a3UNCj4gPiB0b2xkIG1lIHRoZSAnbWF4X3ZjcHVzX3Blcl90ZCcgaXMgbG93ZWQgdG8gNTEyIGZv
ciB0aGUgbW9kdWxlcyB3aXRoIFREDQo+ID4gcGFydGl0aW9uaW5nIHN1cHBvcnRlZC4gIEFuZCBh
Z2FpbiB0aGlzIGlzIHN0YXRpYywgaS5lLiwgZG9lc24ndCByZXF1aXJlDQo+ID4gVEQgcGFydGl0
aW9uaW5nIHRvIGJlIG9wdC1pbiB0byBsb3cgdG8gNTEyLg0KPiANCj4gU28gd2hhdCdzIEludGVs
J3MgcGxhbiBmb3IgdXNlIGNhc2VzIHRoYXQgY3JlYXRlcyBURHMgd2l0aCA+NTEyIHZDUFVzPw0K
DQpJIGRvbid0IHRoaW5rIHdlIGhhdmUgc3VjaCB1c2UgY2FzZXMuICBMZXQgbWUgZG91YmxlIGNo
ZWNrIHdpdGggVERYIG1vZHVsZQ0KZ3V5cy4gIA0KDQoNCj4gDQo+ID4gU28gQUZBSUNUIHRoaXMg
aXNuJ3QgYSB0aGVvcmV0aWNhbCB0aGluZyBub3cuDQo+ID4gDQo+ID4gQWxzbywgSSB3YW50IHRv
IHNheSBJIHdhcyB3cm9uZyBhYm91dCAiTUFYX1ZDUFVTIiBpbiB0aGUgVERfUEFSQU1TIGlzIHBh
cnQNCj4gPiBvZiBhdHRlc3RhdGlvbi4gIEl0IGlzIG5vdC4gIFREUkVQT1JUIGRvc2VuJ3QgaW5j
bHVkZSB0aGUgIk1BWF9WQ1BVUyIsIGFuZA0KPiA+IGl0IGlzIG5vdCBpbnZvbHZlZCBpbiB0aGUg
Y2FsY3VsYXRpb24gb2YgdGhlIG1lYXN1cmVtZW50IG9mIHRoZSBndWVzdC4NCj4gPiANCj4gPiBH
aXZlbiAiTUFYX1ZDUFVTIiBpcyBub3QgcGFydCBvZiBhdHRlc3RhdGlvbiwgSSB0aGluayB0aGVy
ZSdzIG5vIG5lZWQgdG8NCj4gPiBhbGxvdyB1c2VyIHRvIGNoYW5nZSBrdm0tPm1heF92Y3B1cyBi
eSBlbmFibGluZyBLVk1fRU5BQkxFX0NBUCBpb2N0bCgpIGZvcg0KPiA+IEtWTV9DQVBfTUFYX1ZD
UFVTLg0KPiANCj4gU3VyZSwgYnV0IEtWTSB3b3VsZCBzdGlsbCBuZWVkIHRvIGFkdmVydGlzZSB0
aGUgcmVkdWNlZCB2YWx1ZSBmb3IgS1ZNX0NBUF9NQVhfVkNQVVMNCj4gd2hlbiBxdWVyaWVkIHZp
YSBLVk1fQ0hFQ0tfRVhURU5TSU9OLiAgQW5kIHVzZXJzcGFjZSBuZWVkcyB0byBiZSBjb25kaXRp
b25lZCB0bw0KPiBkbyBhIFZNLXNjb3BlZCBjaGVjaywgbm90IGEgc3lzdGVtLXNjb3BlZCBjaGVj
ay4NCg0KT2ggeWVzLg0K

