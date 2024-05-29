Return-Path: <kvm+bounces-18254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BBA088D2AAA
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 04:14:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72839284339
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 02:14:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45D3B15ADB5;
	Wed, 29 May 2024 02:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lEF3NbKD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934B915AAD6;
	Wed, 29 May 2024 02:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716948839; cv=fail; b=KlSpa866bQxCxh376c4IbFLBfG+dRShbTZbSyZm0L8XzHvhAzqjrPhs4u2UK4ZW2OMZfdnDNHvXqNtMSvPV7fOPP6QnROrjDdLUt2ERxyyXyXnoAX1CAgLO7gJsTLNxOVTJ1bHrNl7R9p+42HXdxucwZ451Xsieicxnj8ELxluo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716948839; c=relaxed/simple;
	bh=wTaKZoEHRLwuTT21h9Ti3qjOWRw1BBUhW/KJUvOtnqw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FCnBOSimljf97lP3ps00AoUO/Clh8oTx8bXL6AibrEIQaviXJuaV26uC3dUC7zZ/ODc6oRLpJgIzd5XsM355n1UNw/by+PYsd+LmNpocbRJOP+SpoW49YVklRA0WTKEAhv/zY1lRyUnmnC4PwCzmkkP3HJY8wkEzPVw6B3IV+uU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lEF3NbKD; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716948838; x=1748484838;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wTaKZoEHRLwuTT21h9Ti3qjOWRw1BBUhW/KJUvOtnqw=;
  b=lEF3NbKDHcsOG3Dk//TtqHHIAUk3D8/8GO4fekGi9vJst4IKo7hfMWid
   NCRhUk+dX9S+I9L3xpO8Z6/Sn1UZZN9u+mpIxW3WtKJYUwgbIZjkjtMKL
   8T1v5BoUkPWf2oLeVHLx9op/cVwn+GPeNbFzGjU2PLNxONkT++pA8Ome2
   BUGUenoiCPA0wQcyQSo3rYPuwLQGrDCS+iyKqV6uSCawNpCXuxwmiOmVq
   KYEwftJANUZofSZNTctWbai6ar4T1zMi8MdmFPivAPJe2EnjbwEL7CRq/
   bgnvu6U2byaJwz9q1TYpGyt4J1MqZI0mEL1ToWjBgCehtNaQjUhWafWTE
   A==;
X-CSE-ConnectionGUID: ugtd2+h6SlqAcs8UDBwxCg==
X-CSE-MsgGUID: KH9507FbRpOSAjJqISeSug==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="13169725"
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="13169725"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 19:13:57 -0700
X-CSE-ConnectionGUID: ZlhpJAtgTeK8Q9qIhlILww==
X-CSE-MsgGUID: DaU2ShHhSLSk3+NDEHHiQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="66464093"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 May 2024 19:13:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 19:13:56 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 28 May 2024 19:13:56 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 28 May 2024 19:13:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bxt080Kv+eH8xChpZk+EQhSEX/BHCgYlJLmwH2VQ4n8/rZ1NajjnsOX3kOq/1ZHjnpwbBzXLqAVYbiXIHNf8GPa2aaDwGjd6WB3nfcSOYf424n3PCgUUQUl8AQMwdjnPAYvmtfzkyPCHFlGQ+hsJK3MhPNnuuv15NBAu5piVZQEJNv822+tI513uhomMLTmSthl+i5wDLJNZX78N1Ogt9b9wzB08el9CqeKwW44/N30BA4egbLzHx/Dt0n0Oim9zkFhLefoRV9CffbOk06CEsbqZ27APBLAWZqbInZkm6DIXXGU1a1WlDQ0Ez0L8agezB8ojB6I0mwim/n8LG906Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wTaKZoEHRLwuTT21h9Ti3qjOWRw1BBUhW/KJUvOtnqw=;
 b=IFgbXwLy+Edtzl6fDnnYoS0s5T3MsnGHKRUUjSuvtT2/v7aReJkrSMEnZ3/ZPhcyqwLGnfP2BWrpxh2afPpFahJTA5Zmn3lEhSNrsc+t4uvJRVbNwMGQZ6+fJ4Uzj7jbr9IrSFxFKE+ZFdAfrMeoqF6Iwo1fCcfG7Xpt8ydqAbHEYFuvUtwVBQKp5cBEMnNuXjfdshqY0dTlwaDEplAVulNNwtKXJl9FuIyQgpbw3vtXODQwH6gh033/lxDjWGYOkY3Qj2G3LaJdyYJo7DfrjKQrIjBkgAcunUGFOiVMZMMWXR4FkHLLnH4HZVAryZF2n9XPissGp7DrJtIAiACxQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA0PR11MB8333.namprd11.prod.outlook.com (2603:10b6:208:491::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Wed, 29 May
 2024 02:13:52 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7611.030; Wed, 29 May 2024
 02:13:52 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "dmatlack@google.com" <dmatlack@google.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Topic: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Index: AQHapmNTP3XGfqhyyEaM/KHu10XBU7GZCeQAgAAJxQCAAAs0AIAADfKAgACpkgCAADtVgIAAM8qAgABzkACAAGxrAIAAmmaAgAAQyQCABP6CgIABBVgAgAAS3ACAAfwwgIAACfeAgAAKoACAAADagIAAAs8AgAE1PACAAOGegIAG2ICAgAAWUoCAAI1vgA==
Date: Wed, 29 May 2024 02:13:52 +0000
Message-ID: <b6217ba2f75366d25ff46cd72dcf671cdc57f340.camel@intel.com>
References: <20240517191630.GC412700@ls.amr.corp.intel.com>
	 <20240520233227.GA29916@ls.amr.corp.intel.com>
	 <a071748328e5c0a85d91ea89bb57c4d23cd79025.camel@intel.com>
	 <20240521161520.GB212599@ls.amr.corp.intel.com>
	 <20240522223413.GC212599@ls.amr.corp.intel.com>
	 <9bc661643e3ce11f32f0bac78a2dbfd62d9cd283.camel@intel.com>
	 <20240522234754.GD212599@ls.amr.corp.intel.com>
	 <4a6e393c6a1f99ee45b9020fbd2ac70f48c980b4.camel@intel.com>
	 <20240523000100.GE212599@ls.amr.corp.intel.com>
	 <35b63d56fe6ebd98c61b7c7ca1680da91c28a4d0.camel@intel.com>
	 <20240524075519.GF212599@ls.amr.corp.intel.com>
	 <31a2b098797b3837597880d5827a727fee9be11e.camel@intel.com>
	 <CABgObfa+vx3euEXwopBBzt7BEVT8MV7HuuLayRKxURnopO3f=w@mail.gmail.com>
In-Reply-To: <CABgObfa+vx3euEXwopBBzt7BEVT8MV7HuuLayRKxURnopO3f=w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA0PR11MB8333:EE_
x-ms-office365-filtering-correlation-id: 0327eeab-5515-4444-1aa4-08dc7f84fc50
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?Z0x3UUlsdmcxNnNNTzVBb0lYWTdUYVdDaEd6VEN2Y2Q5YWdKNTdvSStQMk00?=
 =?utf-8?B?TUlVSXdYbjFnWEdyaEs4Wjc1K0JjTlRFczBTbFI1TXU0K1NmbFZuMkxLMlVZ?=
 =?utf-8?B?MEpySHcvT2VuYktPTHdmM3hlaEtRcTZ3eFdlZkF2a2xzWEQ1eThtRlg1MmdI?=
 =?utf-8?B?U25SM1BWRE5PbzNuSmRpUmU3b3d4K08zR01mSjJzWHRFTzlZN3ZSdXA2d0RG?=
 =?utf-8?B?K0VOT2xqcW0ycmhqSjZOSlo0U1FCbVJyR2NMV2hBbzR5SmVjclRGS2Y3L0xS?=
 =?utf-8?B?WUF4Q0dZdVRBb204VW5iQXE0aEp1K0R3eCt1SWM1aVBydnJydk9FS25KMkxT?=
 =?utf-8?B?ZFA1alU1MzhDZDIxODNwRjBJWTk2anNqdkxjN0pkdkNoeEZuMTdua3NtWEhP?=
 =?utf-8?B?d0hkOHpOWlUvOTFUSVAraEVCeUo0dllhS1dML3N4ei9mMWloQk9mTi9PUlpV?=
 =?utf-8?B?QW1OUlRCaXUrR2FZTFZTQ20zMHo0QUEraVYwL0JUaHBzeVpSU3pITUZ1Z0Ru?=
 =?utf-8?B?ZG9nMVp5TWhSZ3VmOUlKSUoyT2EvV3lncmE4eVJZNGQydmZPM0xaUUsyU3ZE?=
 =?utf-8?B?SlZrSFhGQ2Rmb0l6NEJhdmJuQ3BuWXE0NlR3NGJlcW9jb1k1NG05aUtla3Zp?=
 =?utf-8?B?MkFWalVJQ3hSWWs3NHhpSjVDQzUvUnMydjZHSTg3U2xINUgxOGRYNERWUkNH?=
 =?utf-8?B?WWduSGJtdTFRTkFyU2dSamRtRGQrek44NFlUZGliSzFHb0hzNThIbHplQ0kv?=
 =?utf-8?B?VXFYcDFxV2l2Z29kVFUwU0t2K0JPT2Uvam54QjRnMnpCcENNTGhkL0VDN1JU?=
 =?utf-8?B?R3NVZTdjVTBDcHQwM252eEQ1MXYyWEk4NHNvV1hTTmkrSHNrZ2RIUjFrL3NI?=
 =?utf-8?B?R3ZjMGVRZUJVUE5EaGlGTDZaTWViU0VuaDl1NlRDRVVhOVZPc21RNW5wVnJG?=
 =?utf-8?B?UGVyS09haGx2Mk5vVHFYbFlXb1VtUC9ZN0lpTUxzdUJQRjV2QTRNOTJPNUJs?=
 =?utf-8?B?ZHFTUWxUY2RGWmkwY25xWVFPYnluWnBXT0ZBd2I4c3BKK0QzYnN4U3l6SWZm?=
 =?utf-8?B?aDA3N002NTY4MUQ5ajBvU2ZzTlFOVTQ5bXM3Wmw3VFM2dTdLRE1lbGF2Ti9x?=
 =?utf-8?B?QUdYSUsybmhCSjBiR3BzYk1vc3BJb3J5VXBWN05KQzhhaXl2YTlCcitZbE4y?=
 =?utf-8?B?V3hPd1V3V0hndzFaSWxDNnhLaEUwbW5yZFExWWpkSmdYZlZOOFJPblYyL3p3?=
 =?utf-8?B?TzhReTc5VGRObThaVTZLU2lNaVByNDVQeE1MemZXZEJUUTVvUUl4S25XZVdM?=
 =?utf-8?B?TXdDb1BBdXZPbXVUUFBrOFFHbi9VMVNxT2FveE85VmM4d3IyeWEvOVFpVTV4?=
 =?utf-8?B?U1g0OE9yblZtU1JLSFZaMGc0VGtuRjdMMzZPdnJkbjRrZFJ6UzF3ZndDUkpG?=
 =?utf-8?B?aHA4OS9vWGgwODNHeVJIWUgzNmpYUENSSXZZVjU0U2dLZ2NveUZ3SlJUaWtu?=
 =?utf-8?B?bWpFVys5TnZQeGExY0p4UDJDb0xROTZrSGFrTG1vWW1kTHBqQk40WFI5QmE0?=
 =?utf-8?B?ZFZhRzNVVWlQSnkxYUF1RGlRZDZmQzd0eGpoRXZIVFlxT2IvanIxUCtHWnha?=
 =?utf-8?B?UDRodTJLOWtBM1BtSnRrdERYaHYrNS8zbkJBZFhDSkl4TEVKdEtiYXhjektn?=
 =?utf-8?B?UUdxWjM3azd3aXM3NjRGaXI5WHRwV0RCTDgvbkQ3bXBVMk5Gelo4ZFVsTHdy?=
 =?utf-8?B?R1liUU9COFI1NW80eGRLeWxwWW9NdkdnSmJSa2FFUW5yeVdFVU1Ob2V0ZVJt?=
 =?utf-8?B?dVpkT2ZnRnpCUm1vVCt4dz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWQwWUhxZ296SDlGUUcrYko1MEg5NVdTYmVJK1daVy93TGdTUkZSSUhDV1h4?=
 =?utf-8?B?djg5RDZNNmZxVFc1RFhhQmpQa3pUQ0QzdW1sZFROS2VoeFhIQTk0eWJERWM0?=
 =?utf-8?B?QnJuVk01RlJGMU5rbmpWeXU4U0dTZ1RabmFiZ01pSFRocEt0UzFXQWhQSjlh?=
 =?utf-8?B?clF5Q1RkTkZIMkc1bnVOc1FDbWhHc2NVQ2tBYTdzVjFrbk0zK0xJWkRqYm4z?=
 =?utf-8?B?UVVIcmI3dW43RUxmaWxZZG11bzQyTFE2ZGZUQzN5a2c0V3lKSVVlRSs1emZB?=
 =?utf-8?B?RjVvNTlGRGlHTm1FVndTajAyYWFBd0JESmEvang4em81Z2NiaVpYeWtsOVJz?=
 =?utf-8?B?cGhkODM0MTBrN0NCMjV4K2JZSURuTE9QdHhJT2M2OHJGV0Z4bzNySHBWT1ZJ?=
 =?utf-8?B?WUtsSHIvdkJSMmlQQWtFeFhLSVE1N2Yrb2xRbkVNblJ2bWFRY3pxaElRWmFQ?=
 =?utf-8?B?R1I2UHpBL2c4Yll3OGhZa1l3TEsrbEE1a1daaFNsVTBNOCtXb3dNQXdseHdz?=
 =?utf-8?B?QXk2L3JucGF2SUVtZWRxbHNhc0RoM1c5d3huc2xEbnBoZWtRUDVjUkxyN21J?=
 =?utf-8?B?eGl1ZGpqN1FocnluS3RiNFhoWHo4WFFoYUdZNC9mNEhHYzlBZU5hN0RDOU1K?=
 =?utf-8?B?SlA1TW9KdnB6ZElrNWtMZTBKU01nb0JaMUFyc0lNNlJJYlA1QmxPdXM2UmlX?=
 =?utf-8?B?aE5NSUJTbjcrNDljYVVIK2pwTHdCbEhNdUJwaVdFNjFVMmZic0lWbGtUbDBa?=
 =?utf-8?B?d3BuMHZwdTNPREQyWEFidmIvdmJteDVta2syMDF0SklpM0hBYXNIWXpiRm05?=
 =?utf-8?B?S0dxbGFQOGxMVkYrR1lyWHhKVVBqT2t5WHpNYXhZUzE5OWk0UjVEbXM5VHJ3?=
 =?utf-8?B?ZzM3SnpsQlViQkFIQkpZNjRCRUZnVGtWSXc5NVBBU2d6dzh1Sk5Kc3h4NDB1?=
 =?utf-8?B?M1ZLdkMvQTIzdGIwTFd5ZGlTT1IzeE9pdzE4UXZQRTI1eHptV0lPSUtZakVJ?=
 =?utf-8?B?d0VIVC9JcThBbHBZQ3BBOXBUSTRJd1RhYkNCV21FWHV2ZTR6djVDb2YxK1Fp?=
 =?utf-8?B?eHU3aHUvSHdqR3BFQm01QWtucEt4NWlaQkFONnA4NnVVU3djWEJrUkZMZUdC?=
 =?utf-8?B?NEFCUEVzVUoyMEhaWHl4M1pOZmJyNjFmanFpYk5Ya0RFQzlxdHZCWU9IaUZB?=
 =?utf-8?B?Tjl6OHJlalpsMTB6REUwejJhZ05lKzFpYzFNamRYT1BhQStmU05GR2gzWWNm?=
 =?utf-8?B?K0JsVCtRaUFJSlRiQzc0em1WQjk3OGRNTXpabkVPS3RneElDSGdrN2VIZ3My?=
 =?utf-8?B?ZTJKTzJ6VjNLN21tdzljTXJLTlJJWWxOZW9IZkVLaUljVnYxSGVsbkt6dVlF?=
 =?utf-8?B?UEZFYlpxc2MzZDRHcjVnMkw2SUdEUkpSTjFDTDY2ZWg5eUozZkxmK3BTRzNj?=
 =?utf-8?B?TmpaL1RnWTJQVW9id0FQcWozb2pxY1RKM25oVjl5czhOeDdFeUJDeEhPVXAy?=
 =?utf-8?B?d0NycGNqS0dIK3Y4NHRxNUg1Z2NsS2huakRKNUJzbnE4WCtqNzczOUY1YWJJ?=
 =?utf-8?B?MEI4VTRIdWhJYi96MmttdUM2R0djMlBVVlBJODQxQUJBMlRjVG1tamc4M1ZC?=
 =?utf-8?B?NDdLSU9nOVFHUVpNVkVpZmpDTkY0SkRObmdia1hlNVRKMm5vVUg0eWpQSE96?=
 =?utf-8?B?SHdWYi9VRkZJdENqZzZaYlg3UXdadEZ0ZXhCRE42WndOd3ZnQU5iSkszbFpr?=
 =?utf-8?B?cURnVUQwdGJjVC92YjVZNzlUUFNYUjB3RnozbENjSEYwN2xjZzBQbFlENmoz?=
 =?utf-8?B?NC9COUdOQjlybmp3TXRhdHA3SjduRjhBNmVGeUxWL1RSaHU5bmUrM1hFcUY5?=
 =?utf-8?B?c3kwbHRKUlhvaTVwbC9IUnRuMXF5Yk5PS01sc1V4Y1hrTXFJTWhzSEg5OWpJ?=
 =?utf-8?B?cnNBV0V3b1ZVZTloeFkveWFHQUt0UGdObGIyeC8wN3RkVmgwNHh5SjVmSk05?=
 =?utf-8?B?VU0zU2ZaVW5PN0VsZWgrMDNvVEJadFFpQldIVjA5TjVBSzlJQ0svUlBWVEhJ?=
 =?utf-8?B?djF1bXRmeGdKdnNzdm5RTzJEMDJjK2g5bkJsR0NVckUzSE9YOEJ2WU5MdHdk?=
 =?utf-8?B?Wi9jQXlScThyd3FZWGEzbldCenlFdENKclU2N24yREREV0EzTldJNFBNWkQw?=
 =?utf-8?Q?jetg5Lok+Y5npGKYNo96Bdw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9AEA16C97B98D8468413B1EC42A5290E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0327eeab-5515-4444-1aa4-08dc7f84fc50
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2024 02:13:52.4839
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ajnK8N8Dn5+y5cOdwCVmGM+fnvwrejcD1D+m0f8AdXRarjF/87LhBzN/iJCNrLog9DKA8XDUKkocbDKIjFPmDtYRe00k/1CDWaSBfxuL4cc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8333
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA1LTI4IGF0IDE5OjQ3ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiBUdWUsIE1heSAyOCwgMjAyNCBhdCA2OjI34oCvUE0gRWRnZWNvbWJlLCBSaWNrIFANCj4g
PHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPiB3cm90ZToNCj4gPiA+IEkgZG9uJ3Qgc2VlIGJl
bmVmaXQgb2YgeDg2X29wcy5tYXhfZ2ZuKCkgY29tcGFyZWQgdG8ga3ZtLT5hcmNoLm1heF9nZm4u
DQo+ID4gPiBCdXQgSSBkb24ndCBoYXZlIHN0cm9uZyBwcmVmZXJlbmNlLiBFaXRoZXIgd2F5IHdp
bGwgd29yay4NCj4gPiANCj4gPiBUaGUgbm9uLVREWCBWTSdzIHdvbid0IG5lZWQgcGVyLVZNIGRh
dGEsIHJpZ2h0PyBTbyBpdCdzIGp1c3QgdW5uZWVkZWQgZXh0cmENCj4gPiBzdGF0ZSBwZXItdm0u
DQo+IA0KPiBJdCdzIGp1c3QgYSBjYWNoZWQgdmFsdWUgbGlrZSB0aGVyZSBhcmUgbWFueSBpbiB0
aGUgTU1VLiBJdCdzIGVhc2llcg0KPiBmb3IgbWUgdG8gcmVhZCBjb2RlIHdpdGhvdXQgdGhlIG1l
bnRhbCBvdmVyaGVhZCBvZiBhIGZ1bmN0aW9uIGNhbGwuDQoNCk9rLiBTaW5jZSB0aGlzIGhhcyAo
b3B0aW1pemF0aW9uKSB1dGlsaXR5IGJleW9uZCBURFgsIG1heWJlIGl0J3Mgd29ydGggc3BsaXR0
aW5nDQppdCBvZmYgYXMgYSBzZXBhcmF0ZSBwYXRjaD8gSSB0aGluayBtYXliZSB3ZSdsbCBwdXJz
dWUgdGhpcyBwYXRoIHVubGVzcyB0aGVyZSBpcw0Kb2JqZWN0aW9uLg0KDQo+IA0KPiA+IEZvciBU
RFggaXQgd2lsbCBiZSBiYXNlZCBvbiB0aGUgc2hhcmVkIGJpdCwgc28gd2UgYWN0dWFsbHkgYWxy
ZWFkeSBoYXZlIHRoZQ0KPiA+IHBlci0NCj4gPiB2bSBkYXRhIHdlIG5lZWQuIFNvIHdlIGRvbid0
IGV2ZW4gbmVlZCBib3RoIGdmbl9zaGFyZWRfbWFzayBhbmQgbWF4X2dmbiBmb3INCj4gPiBURFgu
DQo+IA0KPiBCdXQgdGhleSBhcmUgaW5kZXBlbmRlbnQsIGZvciBleGFtcGxlIEFNRCBwbGFjZWQg
dGhlIGVuY3J5cHRpb24gYml0DQo+IGhpZ2hlc3QsIHRoZW4gdGhlIHJlZHVjZWQgcGh5c2ljYWwg
YWRkcmVzcyBzcGFjZSBiaXRzLCB0aGVuIGZpbmFsbHkNCj4gdGhlIHJlc3Qgb2YgdGhlIGdmbi4g
SSB0aGluayBpdCdzIGNvbnNpc3RlbnQgd2l0aCB0aGUga3ZtX2hhc18qDQo+IGFwcHJvYWNoLCB0
byBub3QgYXNzdW1lIG11Y2ggYW5kIGp1c3Qgc3RvcmUgc2VwYXJhdGUgZGF0YS4NCg0KSSBtZWFu
dCBmb3IgYSBURFggc3BlY2lmaWMgeDg2X29wcyBpbXBsZW1lbnRhdGlvbiB3ZSBhbHJlYWR5IGhh
dmUgdGhlIGRhdGENCm5lZWRlZCB0byBjb21wdXRlIGl0IChnZm5fc2hhcmVkX21hc2sgLSAxKS4g
SSBkaWRuJ3QgcmVhbGl6ZSBTRVYgd291bGQgYmVuZWZpdA0KZnJvbSB0aGlzIHRvby4NCg==

