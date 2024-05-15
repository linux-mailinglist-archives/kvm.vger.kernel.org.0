Return-Path: <kvm+bounces-17473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2784C8C6EFD
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 01:14:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 944CD1F22D6A
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 23:14:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEDA64EB2C;
	Wed, 15 May 2024 23:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MxLIZvwD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324592A8D7;
	Wed, 15 May 2024 23:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715814889; cv=fail; b=oG2RbzW7VKiWr3BsKGfuznvFq/bR1Cje6hwnlXbuDQEJ9ma2enZVEhlgAJ9/K4m4oS94frv7LQxL8w0knPCFGkeXkt+bc5tgIoC2tkLdhz59XiDXVwEvk2NeRRoUoSENIQdiMOFmbMa3UhKfmG1pQPZSm79/NCBT2BwbRStmlD8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715814889; c=relaxed/simple;
	bh=E6RjEELIfMHopMnjr2FhSuX/FMWcbOjdP+nDHpvQbQA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qx8JGDMcjhrV0tHbTSpX/uYThUGcMOR5fBbD68ZTnVzET2PXLhzoB+nE6VOYA4tMuQ2x4B6zoWkMHc3cNl3f4mSnLdoSL3oVeVoCBGRwwXvi31J7fQ24VDL4zmJglIQchyhN+f1DQETOqnugbFIna2tGD9OA8jeUMB8kf3rIUeE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MxLIZvwD; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715814887; x=1747350887;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=E6RjEELIfMHopMnjr2FhSuX/FMWcbOjdP+nDHpvQbQA=;
  b=MxLIZvwDh/KwhzzqhhQuC/MFYm4eRuZjuNy0N03mXdkd6sEXJr1Hudv/
   xZ/UIJGkfnDj2LFKyNybitctaob0eVS9AFDOl6sYrOZ/hwlmcV/jEUKAW
   8cMLtp9WcQQjZoh+Ntz+M+23KHnlZ8ulH/FbpjDcyLREcGMNOT6+lREgp
   uxYyxBrYEf83IRFyYFlsuhk/liNoJMLyYzMxJGZlSxXd+R9KYBgpfOBak
   eG6MjmdxkZX9yHAUXvHdJBTECkTjf4lmW4AMrhouU8JOakM7ryefKlo/C
   wWIv2UPXDP4OxwCBw+TFVUgUSwNcYKA1xTcGKk+P0+vKw2XOocXrBWvYX
   w==;
X-CSE-ConnectionGUID: y0B9YgmoS5WJQ2QP6k2SYg==
X-CSE-MsgGUID: Rvum6q+vTUiC3z559JsXgg==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="15675581"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="15675581"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 16:14:43 -0700
X-CSE-ConnectionGUID: +JZSCljmR7KzHu/3o8ECRg==
X-CSE-MsgGUID: FzvCl50zTnazvShSUst+Xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="31151246"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 16:14:43 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 16:14:42 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 16:14:42 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 15 May 2024 16:14:42 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 16:14:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nY6YeKxFiTnIkUif3TjL9M7osDhXZxBnQQEDcPk2NzM7AafygCCqzVo6duQ2NQ/5JO5I4lj0i5FcDlRs9fhcY9djoiXKNitpCqx9xKCxNJBarKt/MeEwgbHLzLbXsRv71KCKI5wXgBLwuD+tZN4URkrO3rhFzgSN5m1rz6i072wMrpVN8D7Ll//sPkO2NFhtFQjRKg2FkZQYgbdIrQ56z8qGvkea9tS5FFLeWXNi12tKVSI2pMeMGdMSC/IkBbvhFH30AJfQngM3Qk/5+t6/vLeYelMqjKwNDJrybV17ckcGNi2l9SphjxNwfTKsqzmgsXa6Wviwre7MDSKZR9chAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E6RjEELIfMHopMnjr2FhSuX/FMWcbOjdP+nDHpvQbQA=;
 b=NLoBSO+wgoumglLhQEQLyGGyHQH6XdEzjI/QsuGuPLLHMJYVEiIYoUTvHa/KeqU0PBh/RSYc1odWoQNsnAVfH+JkJOSQXSog+1XH8E6v2WCcQlvq9RIdjQ+OjZ3nMnQgjKSGFsULHOBbXXwFFgm5m2t4udCLVdDE/xabE2+myq1ELA7yyTl3n9XjyBnO8MTNw6FRntr0o54HOrVRbqOrpnZcQ1Sp00IV6OFfXbWEQ5mfaq7wiRsdnyK+3FjKvEoYdjRKgHDJlqaIYUdWImfjl2IwtCBeuxFwK0ZgTijmRiKVf/FtXqv9uXBcU9pFe7anpo4R79Kcau97a8tJPsKwiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB6885.namprd11.prod.outlook.com (2603:10b6:303:21b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Wed, 15 May
 2024 23:14:38 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Wed, 15 May 2024
 23:14:38 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Thread-Topic: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Thread-Index: AQHapmNQnVfe1bKBZ0u4IdlZLB/mxbGYbgKAgAANbQCAAGM8AIAAD92A
Date: Wed, 15 May 2024 23:14:38 +0000
Message-ID: <d4c96caffd2633a70a140861d91794cdb54c7655.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
	 <ZkTWDfuYD-ThdYe6@google.com>
	 <20240515162240.GC168153@ls.amr.corp.intel.com>
	 <eab9201e-702e-46bc-9782-d6dfe3da2127@intel.com>
In-Reply-To: <eab9201e-702e-46bc-9782-d6dfe3da2127@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB6885:EE_
x-ms-office365-filtering-correlation-id: 7b62b3df-b0e7-4c1e-5ae4-08dc7534cb27
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?NGFleWdvOXk1WkVGNG5GZVNLZmJ2ODlCTnh1MG1FZmpKa1R4UlhBVmIwNTFR?=
 =?utf-8?B?WXRkYnlnRHZVUE5Kcnk2bC83WWl3VGdWQm9KN1VVQkhEeE1RTkpaT0JiRTFX?=
 =?utf-8?B?YkUybFN5QnBIZ3RGZkFyTWV2OUttL2ZTUFlZZjZBVG1uOWMvNHpuamFRbWU0?=
 =?utf-8?B?aUpyR2lWanFoRTU4V0ZrbGovbkwvWk9BbWxPUGIzT3RLblh1aUltcmJjMnU4?=
 =?utf-8?B?VXhQMW53K1BxYUFJdWlwOEpPQXdTcUFNZHhPWnA5cTVwWFFzOWRRSkl5cnlj?=
 =?utf-8?B?YTFkbXRiK2dGWStpSjRsd0xHNHlzTFkrQThTNHp3Yi9ocXBwbGF6WWJscndK?=
 =?utf-8?B?eDc3aU5LQ2lsQUtlYm5LTUhYekRKakcyeGhRU0pUYXdIaUNtSXlqbDAxTVNs?=
 =?utf-8?B?Ykx3dWIvWDU4VjhWQzROdy85VjkyY3pvQVNQRVErUjZQZ0ZjbDRHN2x2V0dq?=
 =?utf-8?B?bEVOb1ZLV1RjNTA3Z21VakltVnBBQmdKdVZlYnU4RDkwa1lMME1Ed2JsOGRX?=
 =?utf-8?B?b29yY0RjNlVTdzZvMGd3NWF1c1BxRXFtbyswNkZxdHN0dkNqaktoL1FGNkFx?=
 =?utf-8?B?KzYvd1M4eU5oQTY0bnczbnYza25kSlF6NVJrUm9yemJFaE5MTVZVZ0NSV3V4?=
 =?utf-8?B?WUd1b3ZQcVU5SythWGxXWWo5MUpESkEzSGNUM3RtTFo3WldFNXpiTnBvZHE5?=
 =?utf-8?B?aUVvZ2ViQldxSnUzdlZBUXpIVHZwa3JVWWRyZVBuQ2NLcmRSdG5qd01Bcm50?=
 =?utf-8?B?SXRJREZLclJPanBxWEVnVzBUNnp1Qk44VDA4Tm1OUkZnNUhhOWJ6WXgwRHFS?=
 =?utf-8?B?NXdleUVLQi9LZW1WUU5EOXZUMmVEWGNKaW9QdmhXUTdlempFYkY3VzZNVmFk?=
 =?utf-8?B?aGVqRklSWUlIOTg3ZU03WG9pcENPaEFiWmttcDVQeXRSZi95Y0d5Mm1HdFdF?=
 =?utf-8?B?YVJOOVI2NUVvdEZTY1hqbjZkNVYrcXZXeE9qRy9DQStuYzcwQXp5eC9OdDUx?=
 =?utf-8?B?UWFVWlVjSUxDanFKa1pTb1ZuaGlWTXltNmRrL1FmQnN6dnR0VVZsR0dTbG9B?=
 =?utf-8?B?RlVLS21HQ0QvY2Y5TUhCRVRqWGZlQ3F3Z09qWkRmNEt3Y0QrQ05NK2JlSnQ2?=
 =?utf-8?B?aEtWNGV0VmswRVFSUGE1SDVnNWJld1dzTGZleHZzRjI3ZWFGWVNrOUpGTGZJ?=
 =?utf-8?B?QlU1a1dhaUVZY2VKOGJ1ZlRGcGJTd0VqMHhQeGZrWG43Y21TT2dEbG1ZVFhq?=
 =?utf-8?B?UzR0ZEJKVFVuRFR2Q0ExcHdBZ2JJRE9kY2Z6b21ubkJZclBaQjVsMU5JYUw0?=
 =?utf-8?B?TlNwblViV25YNlNVeFA5MEl2bVNyL25JQnlERnFTSDMvNmJMVGJYTzlLNzFI?=
 =?utf-8?B?RHkrU3FsT1ovZDR3YzBWWFROZWhtVEZDM2t0NUdnVlZ3djJ0Z1VMRU0rNGFr?=
 =?utf-8?B?ZWRDMC9ma2pGV01xUGUraVhjank5ZDRGbnYvRldkNEMrVTJOTDNjazN6enNL?=
 =?utf-8?B?V2lSbE1qVWFmd09ZV0FaS1BBajIxdGhpNFo1MWFZMmh6OTd0bStBbWpNeHlq?=
 =?utf-8?B?NmYzQllhSTZQZXFUMnB3SjBSZlJxZ3FMcXp3eGN6QkQzeTZtMXF5Tm8rNGxt?=
 =?utf-8?B?ZFg2MnUyYjZTYmV2bWpIcDg0Q08xaFZkY3BkMkNrN2M0cDhyUDlhYmZvdkZO?=
 =?utf-8?B?OVRXSG9FNXR6UVBQcktnakR3OEp5c3NqbmVnTVJWcU1nUUdFKzhIOS9BPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z2dnd3pwRWZKVVl6MkFFSTBLejVsL1FFSE9rZlNiRStaK1RzOHN2MkQ2UUZh?=
 =?utf-8?B?MkEyQUp2dXFVbm5FMytiZVFDVE9iZVUwMTlFeFozWUdGQnFTK1BBbW5DUyto?=
 =?utf-8?B?OVhLVDRlT2kyTHM5eElMK282L3J2QnpnMEZvYlgrVVhkNmFoQWpiUXNCdWRM?=
 =?utf-8?B?VmRibTBnQzU5RHlpMGxqNmhUWGV4d2JvQ0RWVHJBOHhmUERFemxpckZPWkJG?=
 =?utf-8?B?Q2ZVT3djM0FYRHNmcUczbzRDb3FNZkxqb0pmSVdNdSszbmlUSWRDOTZSYUQx?=
 =?utf-8?B?OUs4cStlZUFsZFdKVU1aYWdUT2pITjkrZG9lYTJQWEk0YmNGWU5SNEpDb2tC?=
 =?utf-8?B?TWdON29vLytONEx1bHRvYjRxak5WZXIwVnh4UHJBenZuM2xGT2xKMExhWncz?=
 =?utf-8?B?YVZkQVhkQTFIdlpGalBOU1BMSVozVityRGdOU1lyM0RDb240b1ZGNVlSTGd6?=
 =?utf-8?B?dDN4dVRMV0wyaXlYM3NOdUpoRjAvWlFLUnQ5a2hxRERLMVJHeWlSeit4clhS?=
 =?utf-8?B?QzF5M1c5LzR0dlR2eWsxY1JyL1Z3NG93SzFnT2ZNbXUvbGtPQmpTTXE2RHN3?=
 =?utf-8?B?cjVBWHg3MTlnZlB2ZThHL0NveEpnYnAyOG9HQkRsU2pxTFVkbTVVZzhaTnNk?=
 =?utf-8?B?cytIUkNibE45Uy9ZQ2x5cUE2WUFVRFpndWt1Q2dFMXYrVVFuNmZjeE9MV2RW?=
 =?utf-8?B?RE4zN2J3REt5bHVVK0VqNXZtcnd3RkxxRWxWQmpIaVZaazQ4aklqTDJiY1RB?=
 =?utf-8?B?UmxkSUZGaEVIUU9YK1NUZ08zdFBrdzBuMFJIeUlhR05VVkVFL2hPVWprbmJk?=
 =?utf-8?B?RnU1RHRPdWM0Y2ZnNm1BcGVqbFdzMStGTkc1R3FhQXJlWjduR2NscVQvNlIr?=
 =?utf-8?B?TXFzTkpLZWhEZkZCQ2dFNXNxcG0yR1k3ckpHTGUwZmtmeDhNVmtSN2txQmZX?=
 =?utf-8?B?MnZhS3lRY1NwajBvM0NqeDlVYU0zMFpaamJGL2dQd1hqSmhrTE1JejRXU2ZL?=
 =?utf-8?B?M1p0dm1zelgxaEExUW0rZ3h0ZlZLNEwyY0xINnlFZW1FMHdIcGtTdzY1MExC?=
 =?utf-8?B?V2M1ZVltWW9wNmZlT3V4cUNDMGx0bkh1S3llcjRnc25XRWo4K2wzYXhlbFEx?=
 =?utf-8?B?b3IzenBxM09YdFBBNUxzVjZSQ0ZCUk1UU095M1lHVEV5ek1tNGtiWnNtV3I1?=
 =?utf-8?B?RVpFc3dubHd5bVZyMExDMVViWFhoSjNFNmVjbm5hdUpPL25WMDV2bkx1QzJj?=
 =?utf-8?B?ejVzNktrN2RFQmhNejJKQXhRaW84eUVYdlRsaTF3Z0tXR3dFVS81VE8rREgy?=
 =?utf-8?B?QVJTajJNNVlvR3Z6NFhtY0RGbGltWmt1c1RwU3poaVJqT3NGT2Z0UVQxYWs1?=
 =?utf-8?B?QWVteFU2SUtUazEwNjVQWFBvMVFIY0tpT3I3SHRkSGxVRnhSMjU4RHZOMEhO?=
 =?utf-8?B?UCtKTVlydjRkQWRHSjRGVTJjeVowSmRaZE5FZ0dZdGxXSzlEUmY5SitSbHFv?=
 =?utf-8?B?TnhaWjdzQTRpN25hR1hGSlp5cHRia3VLeVhCSlpPVEY3RGxGRUxXckN2VEZH?=
 =?utf-8?B?QjBISVRTMjBETFc2M1g1M2ptR1lMYkZFTXk2NWRTeTJBemVrcE14SHdFZDFm?=
 =?utf-8?B?cG9maVc5T1lEdlJHT09PNkY0NWZQRTRod3FIQVBIbTJFaXprV1NocFBCazRD?=
 =?utf-8?B?ZHlnTXNqSWZIdzRQTkYvZHdRNjc3Q0JSWGJ3Z0tDcFZhVW1aRlN5a04rQk05?=
 =?utf-8?B?NWxSV0NHd2hhQTV5Mlhyc0lNdHpDbWlFTkFhcXVPK3lnNVdiRklMNm02OUtH?=
 =?utf-8?B?NWNlaFJEcjBFRkYzcEZTQnNGZVhNMlVaMXFZUmd5ZHlYSmcrMVEvSG45YVkz?=
 =?utf-8?B?V1l6VmNCdUU0cy9BT2ozY0tQMUE2SHVranJZS1FCMkM0ZDZ0clljVktuMTVQ?=
 =?utf-8?B?OGQyK1h5UWRmMXFoYm9uSkRrVWdpQUd5Ty9NdW9SOFVjSmVMS2JwdGZ1VTZw?=
 =?utf-8?B?NExsSzcwdCtXSzBTNDNadXViWEQ3MFNybUI4SW55eTZtU2lhbXJGcXVsYlNK?=
 =?utf-8?B?c0NOY2VHUEdGQm9OTG5oU0xGT255VFQwamZLaWRKcWJPMXBINW02Zk5FUFJW?=
 =?utf-8?B?ZGZHNHNMVE0yQXFvdVl0Tk8wQjhkYjFnWmdBUUg1K2QxNlZEVktlZWJRMU5y?=
 =?utf-8?Q?NVaPbQ6lxV3yleBqSgLs2h0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F4597987DA3C1A4788631434B68D7BFC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b62b3df-b0e7-4c1e-5ae4-08dc7534cb27
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2024 23:14:38.6307
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eE1XF6PKePvCgdgalOOFliEJBP/CQucVupZk9RAkMvsy0e4ucH2yM2TC94VFMv2N7HqsyAmZaV+kEMip+HWprfxdzoQh74wR6SFCgMLD21I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6885
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA1LTE2IGF0IDEwOjE3ICsxMjAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
IFREWCBoYXMgc2V2ZXJhbCBhc3BlY3RzIHJlbGF0ZWQgdG8gdGhlIFREUCBNTVUuDQo+ID4gMSkg
QmFzZWQgb24gdGhlIGZhdWx0aW5nIEdQQSwgZGV0ZXJtaW5lIHdoaWNoIEtWTSBwYWdlIHRhYmxl
IHRvIHdhbGsuDQo+ID4gwqDCoMKgwqAgKHByaXZhdGUtdnMtc2hhcmVkKQ0KPiA+IDIpIE5lZWQg
dG8gY2FsbCBURFggU0VBTUNBTEwgdG8gb3BlcmF0ZSBvbiBTZWN1cmUtRVBUIGluc3RlYWQgb2Yg
ZGlyZWN0DQo+ID4gbWVtb3J5DQo+ID4gwqDCoMKgwqAgbG9hZC9zdG9yZS7CoCBURFAgTU1VIG5l
ZWRzIGhvb2tzIGZvciBpdC4NCj4gPiAzKSBUaGUgdGFibGVzIG11c3QgYmUgemFwcGVkIGZyb20g
dGhlIGxlYWYuIG5vdCB0aGUgcm9vdCBvciB0aGUgbWlkZGxlLg0KPiA+IA0KPiA+IEZvciAxKSBh
bmQgMiksIHdoYXQgYWJvdXQgc29tZXRoaW5nIGxpa2UgdGhpcz/CoCBURFggYmFja2VuZCBjb2Rl
IHdpbGwgc2V0DQo+ID4ga3ZtLT5hcmNoLmhhc19taXJyb3JlZF9wdCA9IHRydWU7IEkgdGhpbmsg
d2Ugd2lsbCB1c2Uga3ZtX2dmbl9zaGFyZWRfbWFzaygpDQo+ID4gb25seQ0KPiA+IGZvciBhZGRy
ZXNzIGNvbnZlcnNpb24gKHNoYXJlZDwtPnByaXZhdGUpLg0KDQoxIGFuZCAyIGFyZSBub3QgdGhl
IHNhbWUgYXMgIm1pcnJvcmVkIiB0aG91Z2guIFlvdSBjb3VsZCBoYXZlIGEgZGVzaWduIHRoYXQN
Cm1pcnJvcnMgaGFsZiBvZiB0aGUgRVBUIGFuZCBkb2Vzbid0IHRyYWNrIGl0IHdpdGggc2VwYXJh
dGUgcm9vdHMuIEluIGZhY3QsIDENCm1pZ2h0IGJlIGp1c3QgYSBLVk0gZGVzaWduIGNob2ljZSwg
ZXZlbiBmb3IgVERYLg0KDQpXaGF0IHdlIGFyZSByZWFsbHkgdHJ5aW5nIHRvIGRvIGhlcmUgaXMg
bm90IHB1dCAiaXMgdGR4IiBsb2dpYyBpbiB0aGUgZ2VuZXJpYw0KY29kZS4gV2UgY291bGQgcmVs
eSBvbiB0aGUgZmFjdCB0aGF0IFREWCBpcyB0aGUgb25seSBvbmUgd2l0aCBtaXJyb3JlZCBURFAs
IGJ1dA0KdGhhdCBpcyBraW5kIG9mIHdoYXQgd2UgYXJlIGFscmVhZHkgZG9pbmcgd2l0aCBrdm1f
Z2ZuX3NoYXJlZF9tYXNrKCkuDQoNCkhvdyBhYm91dCB3ZSBkbyBoZWxwZXJzIGZvciBlYWNoIG9m
IHlvdXIgYnVsbGV0cywgYW5kIHRoZXkgYWxsIGp1c3QgY2hlY2s6DQp2bV90eXBlID09IEtWTV9Y
ODZfVERYX1ZNDQoNClNvIGxpa2U6DQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL21tdS5oIGIv
YXJjaC94ODYva3ZtL21tdS5oDQppbmRleCBhNTc4ZWEwOWRmYjMuLmMwYmVlZDViMDkwYSAxMDA2
NDQNCi0tLSBhL2FyY2gveDg2L2t2bS9tbXUuaA0KKysrIGIvYXJjaC94ODYva3ZtL21tdS5oDQpA
QCAtMzU1LDQgKzM1NSwxOSBAQCBzdGF0aWMgaW5saW5lIGJvb2wga3ZtX2lzX3ByaXZhdGVfZ3Bh
KGNvbnN0IHN0cnVjdCBrdm0NCiprdm0sIGdwYV90IGdwYSkNCiAgICAgICAgcmV0dXJuIG1hc2sg
JiYgIShncGFfdG9fZ2ZuKGdwYSkgJiBtYXNrKTsNCiB9DQogDQorc3RhdGljIGlubGluZSBib29s
IGt2bV9oYXNfbWlycm9yZWRfdGRwKHN0cnVjdCBrdm0gKmt2bSkNCit7DQorICAgICAgIHJldHVy
biBrdm0tPmFyY2gudm1fdHlwZSA9PSBLVk1fWDg2X1REWF9WTTsNCit9DQorDQorc3RhdGljIGlu
bGluZSBib29sIGt2bV9oYXNfcHJpdmF0ZV9yb290KHN0cnVjdCBrdm0gKmt2bSkNCit7DQorICAg
ICAgIHJldHVybiBrdm0tPmFyY2gudm1fdHlwZSA9PSBLVk1fWDg2X1REWF9WTTsNCit9DQorDQor
c3RhdGljIGlubGluZSBib29sIGt2bV96YXBfbGVhZnNfb25seShzdHJ1Y3Qga3ZtICprdm0pDQor
ew0KKyAgICAgICByZXR1cm4ga3ZtLT5hcmNoLnZtX3R5cGUgPT0gS1ZNX1g4Nl9URFhfVk07DQor
fQ0KKw0KICNlbmRpZg0KDQoNClRoaXMgaXMgc2ltaWxhciB0byB3aGF0IFNlYW4gcHJvcG9zZWQg
ZWFybGllciwgd2UganVzdCBkaWRuJ3QgZ2V0IHRoYXQgZmFyOg0KaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcva3ZtL1poU1lFVkNIcVNPcFZLTWhAZ29vZ2xlLmNvbS8NCg0KDQo+ID4gDQo+ID4gRm9y
IDEpLCBtYXliZSB3ZSBjYW4gYWRkIHN0cnVjdCBrdm1fcGFnZV9mYXVsdC53YWxrX21pcnJvcmVk
X3B0DQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgIChvciB3aGF0ZXZlciBwcmVmZXJhYmxlIG5hbWUp
Pw0KPiA+IA0KPiA+IEZvciAzKSwgZmxhZyBvZiBtZW1zbG90IGhhbmRsZXMgaXQuDQo+ID4gDQo+
ID4gLS0tDQo+ID4gwqDCoCBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oIHwgMyArKysN
Cj4gPiDCoMKgIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykNCj4gPiANCj4gPiBkaWZm
IC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KPiA+IGIvYXJjaC94ODYv
aW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KPiA+IGluZGV4IGFhYmYxNjQ4YTU2YS4uMjE4YjU3NWQy
NGJkIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgNCj4g
PiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQo+ID4gQEAgLTEyODksNiAr
MTI4OSw3IEBAIHN0cnVjdCBrdm1fYXJjaCB7DQo+ID4gwqDCoMKgwqDCoMKgwqDCoHU4IHZtX3R5
cGU7DQo+ID4gwqDCoMKgwqDCoMKgwqDCoGJvb2wgaGFzX3ByaXZhdGVfbWVtOw0KPiA+IMKgwqDC
oMKgwqDCoMKgwqBib29sIGhhc19wcm90ZWN0ZWRfc3RhdGU7DQo+ID4gK8KgwqDCoMKgwqDCoMKg
Ym9vbCBoYXNfbWlycm9yZWRfcHQ7DQo+ID4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBobGlzdF9o
ZWFkIG1tdV9wYWdlX2hhc2hbS1ZNX05VTV9NTVVfUEFHRVNdOw0KPiA+IMKgwqDCoMKgwqDCoMKg
wqBzdHJ1Y3QgbGlzdF9oZWFkIGFjdGl2ZV9tbXVfcGFnZXM7DQo+ID4gwqDCoMKgwqDCoMKgwqDC
oHN0cnVjdCBsaXN0X2hlYWQgemFwcGVkX29ic29sZXRlX3BhZ2VzOw0KPiA+IEBAIC0yMTcxLDgg
KzIxNzIsMTAgQEAgdm9pZCBrdm1fY29uZmlndXJlX21tdShib29sIGVuYWJsZV90ZHAsIGludA0K
PiA+IHRkcF9mb3JjZWRfcm9vdF9sZXZlbCwNCj4gPiDCoMKgIA0KPiA+IMKgwqAgI2lmZGVmIENP
TkZJR19LVk1fUFJJVkFURV9NRU0NCj4gPiDCoMKgICNkZWZpbmUga3ZtX2FyY2hfaGFzX3ByaXZh
dGVfbWVtKGt2bSkgKChrdm0pLT5hcmNoLmhhc19wcml2YXRlX21lbSkNCj4gPiArI2RlZmluZSBr
dm1fYXJjaF9oYXNfbWlycm9yZWRfcHQoa3ZtKSAoKGt2bSktPmFyY2guaGFzX21pcnJvcmVkX3B0
KQ0KPiA+IMKgwqAgI2Vsc2UNCj4gPiDCoMKgICNkZWZpbmUga3ZtX2FyY2hfaGFzX3ByaXZhdGVf
bWVtKGt2bSkgZmFsc2UNCj4gPiArI2RlZmluZSBrdm1fYXJjaF9oYXNfbWlycm9yZWRfcHQoa3Zt
KSBmYWxzZQ0KPiA+IMKgwqAgI2VuZGlmDQo+ID4gwqDCoCANCj4gPiDCoMKgIHN0YXRpYyBpbmxp
bmUgdTE2IGt2bV9yZWFkX2xkdCh2b2lkKQ0KPiANCj4gSSB0aGluayB0aGlzICdoYXNfbWlycm9y
ZWRfcHQnIChvciBhIGJldHRlciBuYW1lKSBpcyBiZXR0ZXIsIGJlY2F1c2UgaXQgDQo+IGNsZWFy
bHkgY29udmV5cyBpdCBpcyBmb3IgdGhlICJwYWdlIHRhYmxlIiwgYnV0IG5vdCB0aGUgYWN0dWFs
IHBhZ2UgdGhhdCANCj4gYW55IHBhZ2UgdGFibGUgZW50cnkgbWFwcyB0by4NCj4gDQo+IEFGQUlD
VCB3ZSBuZWVkIHRvIHNwbGl0IHRoZSBjb25jZXB0IG9mICJwcml2YXRlIHBhZ2UgdGFibGUgaXRz
ZWxmIiBhbmQgDQo+IHRoZSAibWVtb3J5IHR5cGUgb2YgdGhlIGFjdHVhbCBHRk4iLg0KPiANCj4g
RS5nLiwgYm90aCBTRVYtU05QIGFuZCBURFggaGFzIGNvbmNlcHQgb2YgInByaXZhdGUgbWVtb3J5
IiAob2J2aW91c2x5KSwgDQo+IGJ1dCBJIHdhcyB0b2xkIG9ubHkgVERYIHVzZXMgYSBkZWRpY2F0
ZWQgcHJpdmF0ZSBwYWdlIHRhYmxlIHdoaWNoIGlzbid0IA0KPiBkaXJlY3RseSBhY2Nlc3NpYmxl
IGZvciBLVlYuwqAgU0VWLVNOUCBvbiB0aGUgb3RoZXIgaGFuZCBqdXN0IHVzZXMgbm9ybWFsIA0K
PiBwYWdlIHRhYmxlICsgYWRkaXRpb25hbCBIVyBtYW5hZ2VkIHRhYmxlIHRvIG1ha2Ugc3VyZSB0
aGUgc2VjdXJpdHkuDQo+IA0KPiBJbiBvdGhlciB3b3JkcywgSSB0aGluayB3ZSBzaG91bGQgZGVj
aWRlIHdoZXRoZXIgdG8gaW52b2tlIFREUCBNTVUgDQo+IGNhbGxiYWNrIGZvciBwcml2YXRlIG1h
cHBpbmcgKHRoZSBwYWdlIHRhYmxlIGl0c2VsZiBtYXkganVzdCBiZSBub3JtYWwgDQo+IG9uZSkg
ZGVwZW5kaW5nIG9uIHRoZSBmYXVsdC0+aXNfcHJpdmF0ZSwgYnV0IG5vdCB3aGV0aGVyIHRoZSBw
YWdlIHRhYmxlIA0KPiBpcyBwcml2YXRlOg0KPiANCj4gwqDCoMKgwqDCoMKgwqDCoGlmIChmYXVs
dC0+aXNfcHJpdmF0ZSAmJiBrdm1feDg2X29wcy0+c2V0X3ByaXZhdGVfc3B0ZSkNCj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBrdm1feDg2X3NldF9wcml2YXRlX3NwdGUoLi4uKTsN
Cj4gwqDCoMKgwqDCoMKgwqDCoGVsc2UNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqB0ZHBfbW11X3NldF9zcHRlX2F0b21pYyguLi4pOw0KPiANCj4gQW5kIHRoZSAnaGFzX21pcnJv
cmVkX3B0JyBzaG91bGQgYmUgb25seSB1c2VkIHRvIHNlbGVjdCB0aGUgcm9vdCBvZiB0aGUgDQo+
IHBhZ2UgdGFibGUgdGhhdCB3ZSB3YW50IHRvIG9wZXJhdGUgb24uDQo+IA0KPiBUaGlzIGFsc28g
Z2l2ZXMgYSBjaGFuY2UgdGhhdCBpZiB0aGVyZSdzIGFueXRoaW5nIHNwZWNpYWwgbmVlZHMgdG8g
YmUgDQo+IGRvbmUgZm9yIHBhZ2UgYWxsb2NhdGVkIGZvciB0aGUgIm5vbi1sZWFmIiBtaWRkbGUg
cGFnZSB0YWJsZSBmb3IgDQo+IFNFVi1TTlAsIGl0IGNhbiBqdXN0IGZpdC4NCj4gDQo+IE9mIGNv
dXJzZSwgaWYgJ2hhc19taXJyb3JlZF9wdCcgaXMgdHJ1ZSwgd2UgY2FuIGFzc3VtZSB0aGVyZSdz
IGEgc3BlY2lhbCANCj4gd2F5IHRvIG9wZXJhdGUgaXQsIGkuZS4sIGt2bV94ODZfb3BzLT5zZXRf
cHJpdmF0ZV9zcHRlIGV0YyBtdXN0IGJlIHZhbGlkLg0KDQpJdCdzIGdvb2QgcG9pbnQgdGhhdCB3
ZSBhcmUgbWl4aW5nIHVwICJwcml2YXRlIiBpbiB0aGUgY29kZSBmcm9tIFNOUCdzDQpwZXJzcGVj
dGl2ZS4NCg0K

