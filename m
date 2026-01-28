Return-Path: <kvm+bounces-69424-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2JCAOUOVemmC8AEAu9opvQ
	(envelope-from <kvm+bounces-69424-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 00:01:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 68FF1A9D06
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 00:01:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C31183017390
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 23:01:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 419A12FFF90;
	Wed, 28 Jan 2026 23:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hRUE1mBT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40C72DECBA;
	Wed, 28 Jan 2026 23:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769641273; cv=fail; b=Se3llWTY/1bxgNbww09RE46401ObnJ/VQvQ5ZQZiR37bMb8pZhDKWy0N85AgAnqv7hyf8XkBYW24u4Yp91x4MlqkPEABx9s3xTpoS6piLFz9OARlvEzbyeqRwDBWc4VbXX80/mJ65XlqknKFC2SGnmvcsI1c6KmSdAhOIIzO1K4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769641273; c=relaxed/simple;
	bh=fsLmn8k3k0PGdUlzA7wmhuow2HqOgPzfBpsa/f38OlQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DTatxQpFgmHgoVyHMh2yLtPZP4JIQt0Lu+kD5/rFTZfiGUiM8JrsW+/vM3JzDY39XH20VhzuV5Xs/7WY7iIctoRToNEjaMj2ceu003yyUq5zWfqYFZvHhZxkgfVJ6+2jBZ7ySK5YYMfL9lJBVGHy7hc5m90aNfNmmLNVPbjdri0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hRUE1mBT; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769641271; x=1801177271;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fsLmn8k3k0PGdUlzA7wmhuow2HqOgPzfBpsa/f38OlQ=;
  b=hRUE1mBTF6ZKncOJRitlgD8X3prJPjqupVxqZJi2EBmKGIWF/tR4JHcH
   ezxQUdnBzLhhfVbsRCcNL5ep1YIUIwCvFBnCy20CDwAsdDNb3UoocyKWz
   OXeihHfXxlGGC1Lm253KhOyZoYQpSumpABy+pbEllZjrQsWLrr3yzHuc2
   Hl7bgkK9DsWrgeFSWYZDHb33Cg2bIXSVZ0AceHa66jNjQI6/yY08pdbZx
   H7cZ744Cb3+Sovb/T0Eafg+rE8eb906xttbi8tdivUguuXcrcM9xqbULL
   vR0k/PBiHUQl0fOMVTI43KdsMkpiZ6KPnAiCqnE6RDk3blLWpd6ycureZ
   g==;
X-CSE-ConnectionGUID: WcxSbbHKRMu6e+c+Hlod8A==
X-CSE-MsgGUID: MEalqPq2R5G1bU3j31hZeA==
X-IronPort-AV: E=McAfee;i="6800,10657,11685"; a="69882295"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="69882295"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 15:01:10 -0800
X-CSE-ConnectionGUID: O3n37O1dSIa5QxxOUsUhPw==
X-CSE-MsgGUID: 0G6M2PSwSOON1c6rJIq58w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="208188394"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 15:01:10 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 15:01:09 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 28 Jan 2026 15:01:09 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.29) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 15:01:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f+F7fgrnJEYWBQ6KTM2cNBOg8lKe6aQGPfLqpsFJuK1QFcqDPWRPC1gDHBwASj3nbyey4pEIh0u1pzexj6DCa032jha8qroqKQlCdvrBnkfoUELJ0Ft8d/crBdhwSALIuZxo3Z3x47U1UpXQSumW9MZC0JbD4F+1iZ4nEkrpRG4ukt9qNdpatzvwfkp1qZLV/uDrim/sknD3GvXKgIIcy3Un7uKAaHBvCdOMnI8TIDQ+eSivR9YmQWDpiEvKOx/K/P2HdlZk4MFa65sB5rWBALqyZ8mu6DDAmGnGm9ogoruSYMTia6p+Y7Gg9JZX+eUSWShWX2789ku7fG9vNu09Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fsLmn8k3k0PGdUlzA7wmhuow2HqOgPzfBpsa/f38OlQ=;
 b=W+8JYi86x6k3wG7abZqlziTqQplbwRM5CeRb8nvVm6+mw8KdpDakiiG0BPpKkO+PTm3/UCh2Oz8XdgD6aqSDDdNqjKdETbI3t2Cjm42nCrCN3UwLgj62OEd1MI47U6qIvFj2RnOYiI/LK/EFvZL5yq3KLhWsda68y4eVBPxlDkbbo/up1DcUYMBqhlg29/X4oofHmLn94tpDtXVaMCTV9G+F8nl5yYgk/53emIDeDWFyVbUH4Rd4yL2DwiB+Sr2gOrQNpk47TlXz0Pzrb+hyhSSocfs3Xc2D9mFIZlLXO2ZEY13vQLiX+Eix11pT2n3+cJ72mqxXrQE+kzgKvMJ3Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SJ5PPF5B09F0799.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::82c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 23:01:03 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9564.007; Wed, 28 Jan 2026
 23:01:03 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "nik.borisov@suse.com" <nik.borisov@suse.com>, "Verma,
 Vishal L" <vishal.l.verma@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"sagis@google.com" <sagis@google.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "paulmck@kernel.org"
	<paulmck@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>
Subject: Re: [PATCH v3 24/26] x86/virt/seamldr: Extend sigstruct to 16KB
Thread-Topic: [PATCH v3 24/26] x86/virt/seamldr: Extend sigstruct to 16KB
Thread-Index: AQHcjHkW6CQuWkGBfEmIiCBzsHzvk7VoOv+A
Date: Wed, 28 Jan 2026 23:01:03 +0000
Message-ID: <c9c648536ed4cd242ce5d7de87cafe352503839f.camel@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
	 <20260123145645.90444-25-chao.gao@intel.com>
In-Reply-To: <20260123145645.90444-25-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SJ5PPF5B09F0799:EE_
x-ms-office365-filtering-correlation-id: 4e756de7-e3ee-46ff-2e34-08de5ec11cbd
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?STV2QVE4WVU4aHEwUE5LS2Y1aUtSNTY2YnRmVmFRZlFNaE9zWEQwY0xCcVkz?=
 =?utf-8?B?UWwycjVNMWgvdDgzN2ZOTVNOS0RqdjhwZmI5aXhRdUM0cnZTMXZ6ZHR5R2lF?=
 =?utf-8?B?cS80YUVGTjQvSlBwcHhsN2FzODFzNm5XYklzaGVmVmg4ekRFUFBXbmJ2cFNj?=
 =?utf-8?B?YWRxU1dpOFA1WUVjS1NFdlBmQnZ5VUluSVc5ZVN2VHRkQlhORWsyMFFqQUxP?=
 =?utf-8?B?UUZzcE9QRWFhMUFpby90OTU1MzN4RDhmdWZVSlhyV3JRRXl4Q2pESFVMOEpZ?=
 =?utf-8?B?V1h1OFdHSlV5S21EczVDdFNycnlIMGpjMVZ6SlpqUm9pOGtGaHFGYzgzcEJT?=
 =?utf-8?B?OS9YaDBzS0NYNjJQQUVrRjR1VGErM2ZxMmxTQmNMTmJVTE1PZ2RsTHZ5YVJk?=
 =?utf-8?B?dkEvQUpaL3pxV2FBM1Z1cTdGRGlSa01oWUhpSkdzUzRXMG5vWXpXcSs4Qm5U?=
 =?utf-8?B?TXZ4UHZSd241djJzSyt0dTFkWStVODhyZUpXUy9HNHdPdTZreWFnT0dYbUd1?=
 =?utf-8?B?Q3d1QnM4cHA2WmMyU3JsMlFKVXJCTTNONmFKdkRnaGlRSmF3UUE2UnR3MVhs?=
 =?utf-8?B?V3RzTVA2V0htdzdBV1Y0aUxGOFpJSTBHcWJBQ21KQWRVVjJSWW4zcHZmN09Q?=
 =?utf-8?B?c0RPTjMvRGptZUhlUW10VEJEMklTSFRoRmJVVzJUdmczTTRWK29rQWdpQXZq?=
 =?utf-8?B?RmZ5S3VwOCthSGZYc3lvUVhuR0xXYlpOY3A2RGIyNEhkZXFVSFU3Z2I5a1Mv?=
 =?utf-8?B?Zllkc21KYkZlK3Rvamw4Ymo4ZWcraVZVSHpjV2lnVTlBZngraHQ5ZTYyWjhQ?=
 =?utf-8?B?VmtPTU13YWtyenZBM3FhT05Pc3k3ZHBVc2NzU3N1bUQ5ODBhaDR4cGZMV1or?=
 =?utf-8?B?UkNoQnBOUCt6MVA2KzE3bmJNTEg5QTNUb3RybVZ1bzZlcmJUcnN0SG5FSjFq?=
 =?utf-8?B?SlNuL0xoTEJRaFJ4UVZOTFhzbzQxSjBiU00rZ2I2alNoU3QxRWRXNzdhdWJ1?=
 =?utf-8?B?aTFEVjVjeVpXSG9xdG1DMFNqeHY5TUdXaWFRSFU2ZWRoVyt2dHF1YzBEVVV0?=
 =?utf-8?B?czFxLzJoLzNMWE1DRUdkRDFLQzZ2WnZySEVCckR3dSszbUFqc3dLcE9hTGxH?=
 =?utf-8?B?M1V5N09YSzR6TFNncndna3o4R2lZWDZCV0g1Q0VLcVRqMDJqeUZWcnE1akpr?=
 =?utf-8?B?SWZ4b3BFdjBrTFBISzQ3eTVMcU5ER3VhOEx6VDFCSGIrUEN5U2QzUTBuQXdB?=
 =?utf-8?B?Y1pWclB6Y3hoeXZDWHZZekMvWkFnemNoa3lZVnpDempjNWdvV1Y3S0FkeEw0?=
 =?utf-8?B?L1JSbklTWVJzYjdob1BsK0d5c2R0VldWUTBOUTdSMGZ0K1BkN2RPdk1JZDRK?=
 =?utf-8?B?c0R0SGhYS2tKRXlWbFFOV3Q5V3g4TzNiSFNQL3BSdHIxM0pjNUlkWUFBTGpv?=
 =?utf-8?B?TFBGVTFaN3pyVmYxR1NHRkYwdHE4ekJjejVZOHU0czJMMFQ2THQ3SVpVd2sr?=
 =?utf-8?B?TWhKc3daNjdLc2R4ZW45bFpEWG1Pd2Q5a0w4ZGNHTUg4ei9aUVBKSGVPWGht?=
 =?utf-8?B?RzZZd3NFNEdxK2tNMy9WQ0hsMGxoMjM0RXIyV0I3eldPMU1FQVU2dmdNUHRi?=
 =?utf-8?B?a3d0YjNZSStqOWdDNlUyVk1vMHlRd21pcExkbk92SE5pdzFxY2FKc1VtMyt5?=
 =?utf-8?B?YXJQMDd5Y0haYWtSQlVtZTBIUXFGSkF0Q1d2MklpdG5ZYmcvSjJmYkZFQjcz?=
 =?utf-8?B?Q2dWV3JlRDdBL212VE13TGxkOCtQQ1pkQ284RlJBNHdnSnNLQVlnU0ZDNEZK?=
 =?utf-8?B?eC91YjNLZFRqQ1VCUVVLSDhBYkZTTUNOOWU0TmZjNHI1T0N0dE92RkhZdzQ1?=
 =?utf-8?B?K2U1L0FpV0diUE45eEJ2a0xyZERMMWdsSDFTMUY3UXZETXpYLytPZnVQRlUw?=
 =?utf-8?B?TDNzemIxMWFuQ1ZKcGpGZzJzaC9LNTdmOU9jOG5KMWxiTWVhdlZwWnVIdnlo?=
 =?utf-8?B?eGZDazRTSjQrV0lLN0ZOODFNUW16clJ6b21OK3A2OWJzSGJKaC9qOHZ2V3BK?=
 =?utf-8?B?clpmUlRxODQ0TUs5K3ppQnN3RUlpMXIwdEt2VTJIWnFyMXBpS01KN2pIdTkz?=
 =?utf-8?B?MDZ0VEJBektTWXdoanF0cjJKSWxZMEluQzFZS3dUcU5FWEZ6UG1tSjRSeXRw?=
 =?utf-8?Q?2ysfa6F3HsaHC/nNX5yXigk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T3pQY1I0Q3RRNkpSdG53NXdqZk9lSkxpd0JlZ1VoVm5FMEZ1N3NzYnVFY20y?=
 =?utf-8?B?MDRFVVcwVnByby9Yc2lNNVFBWEJPaW5yUEVtYnUxVTZRMExrWm9ucjYxRkpL?=
 =?utf-8?B?OFhFazFTd2hrUmNMcVY3Qit4MFdwTHIvcGtKZTk3b0wyWHlFejh3bmtZSGg2?=
 =?utf-8?B?RW5BU3I1UDRSaHByVGlmNFYzZ0NmT3dRdjVnZC9uNDBFbjY0Rk5WMjlBLzY1?=
 =?utf-8?B?dXJBZE5OeFhpeUp2cW92Q1hSR0JPZEFXdld0UjNuOFRWV3laRlpVSzBXc05p?=
 =?utf-8?B?d1FvZ3hCRlprWEtzdHVDU2RPdjJTRi80L2xxbzFIME55YkI3VFJZVlFyejZD?=
 =?utf-8?B?amV5ZUd3a1h5UHk1eitQVWV1aFFnenE5THpPbE1RVDJhb1V2ZDVHc1FndWpL?=
 =?utf-8?B?Y3M1a1huTEU1ZUxCUlRSdzZWYy8rUGdvTjRBM3VsaEtMNXFXbm53dTZTZmRo?=
 =?utf-8?B?UDEyWnNnYUM3d3IwVkFRaEs2a3lGa2FxV01vUXZvSVEya2RoOG41eDljWElZ?=
 =?utf-8?B?MXpIckJiQVhwd29OSFdtMDlmcERpZnkvMHpMNWhUSnNsUE9GMjI3aVJrSWwr?=
 =?utf-8?B?MllRYXVsazJvYzNsUllMaVd1a3BEeFZ2MFg2MlJmOVR0WXZWTVZ0RTY5TTg0?=
 =?utf-8?B?eU1DT2EreXdaQ29rczdwTGFmNGxBT2JsMmFTWVBxenlsQjlGZ3Exc3BqN29T?=
 =?utf-8?B?cUJCdTl4QzEzU3pvWm9QczJ6OGhqMERLWTQ0Y2gxRUZRZzNJcTlST2RoN2Jq?=
 =?utf-8?B?dFppRlhCZzBtRUgwZTdnalFGU3NnMXBBSmhYUkttMzlONU5GSkVWeXl2ZmdB?=
 =?utf-8?B?aUNtVnRNY0tXUk9VUzRHR0lqOWUxRXJYVjFjSDdxODhCNmJVKysybXJaUENj?=
 =?utf-8?B?SDU2cjFRT09QaWZNYmY4RjZ1dG9SajdSNkNjWlQ0alpGWk9WK1lHZ2tuem9l?=
 =?utf-8?B?RHE3MXMvWUNXcFhpQWJDaUhLc0pYRXBsTE4wNmt6SzZoVWI4SENKNTIwSlN5?=
 =?utf-8?B?dDN4QkNYb3RxdmJUZEZkT01SZ2kvOE9DN3QxYldUNXRVVzFSL3BlTlpGWnds?=
 =?utf-8?B?a0RmVW5uOTdTTjBLUk9leUlibVNJN0JtMks0WXJtY0t3RjRvVTAyTUtYUkZC?=
 =?utf-8?B?R2IrUFhsM3FBVmZaV3NaN0VVRVg3R2JNQ3JKdmE2ZHVzMTJYNys3ejcwQkQ1?=
 =?utf-8?B?NWlWQ0dzRFZxaWdUVUZGWEdVTkowbmhNNlhPbG9jSktQdS9seHlvd0pwRkRn?=
 =?utf-8?B?bFh1Vm41eitWbCtNcEYxYXJRdk9OOGp4ZU5vZ3BtcVd0NEFnYVBYR2tzSWNZ?=
 =?utf-8?B?T3lWT1hONzVOTVlPVzNKYzNOMFpJZHZGNWZITC82VXNkYThML3E0VlhoRDQ5?=
 =?utf-8?B?ajAzMnFneDBlQU4xWFcvUFJ6c0pEZXNJVzUyaCt6blBHb0h1Tmo4Q2cvNFE3?=
 =?utf-8?B?TXMxaEFGK1lvYzlXQ3NzN2MvVVpTOEMzWlJFVWxxUVRUR0tRRjlWcDdlTzNZ?=
 =?utf-8?B?NDBDMFRpSHhCSmZRL3l3dmI0U0plejZacEFtNTQ1YjZ4K3hQL1ZmL1hWSis2?=
 =?utf-8?B?MHNGcnR3M1FNRHBvY0FrZTZOMW9iMXBhaGxjR3pWOFJvRzVoaUpaRXpRbDAr?=
 =?utf-8?B?bmVmN1lSRXIwUUQ2VkN2L0dIeWVKdUFMV1dXTm1pek5DL3dDeklVTEVSV3JU?=
 =?utf-8?B?SXlPbDJubFpVcUZrOUR6T3Y2YXVHYi95M080T2x6UnhDYW93ZEM2TTFlSVdi?=
 =?utf-8?B?SVNJMHVrUGVSMGtUZUZYTkF2dWt5T3hIeG5xRGtvUzNDbVo4U0hJQnpJWjRD?=
 =?utf-8?B?eTIwK1VOM3FlQ01taW53dTB4MmZOaXljQm5zRkdDS0hHY0lHRFJ3SzAvUUhl?=
 =?utf-8?B?cXBHSXRDOTFCY1BYQmhyeFEwblFuOW41c0xtTE92S25vdkZYdEt5QTM0b0NJ?=
 =?utf-8?B?TTd6WDRySTBNcnZhWHUrYUVRQXIyOERwMy8yZ2NDZHJoRXpYYkd6MnJJUkhU?=
 =?utf-8?B?SHQ0NEEyZXRXRUxEcmR2NUNLUU9VNTljRm9aNC9yVWFQYVplNFFDTnJwWFh1?=
 =?utf-8?B?N0I3TFZYRWxQOWFYeWloajZESElCeWtXZWp3MzlCTk9IQ3ZvUlhINjU1anlO?=
 =?utf-8?B?dE51cVdnUm1WRVpaZTZMRkVyWjI5TmhmZGdmM1ZNYUpMZklaTW5aaExKd1hw?=
 =?utf-8?B?NW1qRjk4aHRLYzh1NnFtcCtHY2VrM2dZc1JHaGVGVGJtemxBVU1ZY0ZuMWMz?=
 =?utf-8?B?T01UY09jSGxEbXpBOWcvQktkd0xFa3VRb3NWQ0RkYkNqL3JlZmJRR2FkbHVI?=
 =?utf-8?B?anZsN0cxWG1xcWNucUp4V3IzUmZCMFFvU3JKZW5TSTlreU5QVlVjdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C77BB6739B4CB04FBE22D5B5CE90B3D2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e756de7-e3ee-46ff-2e34-08de5ec11cbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2026 23:01:03.6880
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fTaZVtul2R1M9UgpZhHAB38sJD1T7vWqUyn3A/eLpdT0rs9PeK6bXWdvInsX81Vmkya8UIsCSfTGNVzKpY5/mA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF5B09F0799
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69424-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[23];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 68FF1A9D06
X-Rspamd-Action: no action

T24gRnJpLCAyMDI2LTAxLTIzIGF0IDA2OjU1IC0wODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gQ3Vy
cmVudGx5LCBlYWNoIFREWCBNb2R1bGUgaGFzIGEgNEtCIHNpZ3N0cnVjdCB0aGF0IGlzIHBhc3Nl
ZCB0byB0aGUNCj4gUC1TRUFNTERSIGR1cmluZyBtb2R1bGUgdXBkYXRlcyB0byBhdXRoZW50aWNh
dGUgdGhlIFREWCBNb2R1bGUgYmluYXJ5Lg0KPiANCj4gRnV0dXJlIFREWCBNb2R1bGUgdmVyc2lv
bnMgd2lsbCBwYWNrIGFkZGl0aW9uYWwgaW5mb3JtYXRpb24gaW50byB0aGUNCj4gc2lnc3RydWN0
LCB3aGljaCB3aWxsIGV4Y2VlZCB0aGUgY3VycmVudCA0S0Igc2l6ZSBsaW1pdC4NCj4gDQo+IFRv
IGFjY29tbW9kYXRlIHRoaXMsIHRoZSBzaWdzdHJ1Y3QgaXMgYmVpbmcgZXh0ZW5kZWQgdG8gc3Vw
cG9ydCB1cCB0bw0KPiAxNktCLiBVcGRhdGUgc2VhbWxkcl9wYXJhbXMgYW5kIHRkeC1ibG9iIHN0
cnVjdHVyZXMgdG8gaGFuZGxlIHRoZSBsYXJnZXINCj4gc2lnc3RydWN0IHNpemUuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBDaGFvIEdhbyA8Y2hhby5nYW9AaW50ZWwuY29tPg0KPiAtLS0NCj4gIGFy
Y2gveDg2L3ZpcnQvdm14L3RkeC9zZWFtbGRyLmMgfCAyOCArKysrKysrKysrKysrKysrKysrLS0t
LS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMTkgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMo
LSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvc2VhbWxkci5jIGIv
YXJjaC94ODYvdmlydC92bXgvdGR4L3NlYW1sZHIuYw0KPiBpbmRleCBkMmQ4NTExNGQ2YzQuLjll
NzdiMjRmNjU5YyAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3NlYW1sZHIu
Yw0KPiArKysgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvc2VhbWxkci5jDQo+IEBAIC0yOSw2ICsy
OSw4IEBADQo+ICAvKiBQLVNFQU1MRFIgY2FuIGFjY2VwdCB1cCB0byA0OTYgNEtCIHBhZ2VzIGZv
ciBURFggbW9kdWxlIGJpbmFyeSAqLw0KPiAgI2RlZmluZSBTRUFNTERSX01BWF9OUl9NT0RVTEVf
NEtCX1BBR0VTCTQ5Ng0KPiAgDQo+ICsjZGVmaW5lIFNFQU1MRFJfTUFYX05SX1NJR180S0JfUEFH
RVMJNA0KPiArDQo+ICAvKiBzY2VuYXJpbyBmaWVsZCBpbiBzdHJ1Y3Qgc2VhbWxkcl9wYXJhbXMg
Ki8NCj4gICNkZWZpbmUgU0VBTUxEUl9TQ0VOQVJJT19VUERBVEUJCTENCj4gIA0KPiBAQCAtNDAs
OCArNDIsOCBAQA0KPiAgc3RydWN0IHNlYW1sZHJfcGFyYW1zIHsNCj4gIAl1MzIJdmVyc2lvbjsN
Cj4gIAl1MzIJc2NlbmFyaW87DQo+IC0JdTY0CXNpZ3N0cnVjdF9wYTsNCj4gLQl1OAlyZXNlcnZl
ZFsxMDRdOw0KPiArCXU2NAlzaWdzdHJ1Y3RfcGFbU0VBTUxEUl9NQVhfTlJfU0lHXzRLQl9QQUdF
U107DQo+ICsJdTgJcmVzZXJ2ZWRbODBdOw0KPiAgCXU2NAludW1fbW9kdWxlX3BhZ2VzOw0KPiAg
CXU2NAltb2RfcGFnZXNfcGFfbGlzdFtTRUFNTERSX01BWF9OUl9NT0RVTEVfNEtCX1BBR0VTXTsN
Cj4gIH0gX19wYWNrZWQ7DQo+IEBAIC0xMjEsNyArMTIzLDEwIEBAIHN0YXRpYyBzdHJ1Y3Qgc2Vh
bWxkcl9wYXJhbXMgKmFsbG9jX3NlYW1sZHJfcGFyYW1zKGNvbnN0IHZvaWQgKm1vZHVsZSwgdW5z
aWduZWQNCj4gIAlpZiAobW9kdWxlX3NpemUgPiBTRUFNTERSX01BWF9OUl9NT0RVTEVfNEtCX1BB
R0VTICogU1pfNEspDQo+ICAJCXJldHVybiBFUlJfUFRSKC1FSU5WQUwpOw0KPiAgDQo+IC0JaWYg
KCFJU19BTElHTkVEKG1vZHVsZV9zaXplLCBTWl80SykgfHwgc2lnX3NpemUgIT0gU1pfNEsgfHwN
Cj4gKwlpZiAoc2lnX3NpemUgPiBTRUFNTERSX01BWF9OUl9TSUdfNEtCX1BBR0VTICogU1pfNEsp
DQo+ICsJCXJldHVybiBFUlJfUFRSKC1FSU5WQUwpOw0KPiArDQo+ICsJaWYgKCFJU19BTElHTkVE
KG1vZHVsZV9zaXplLCBTWl80SykgfHwgIUlTX0FMSUdORUQoc2lnX3NpemUsIFNaXzRLKSB8fA0K
PiAgCSAgICAhSVNfQUxJR05FRCgodW5zaWduZWQgbG9uZyltb2R1bGUsIFNaXzRLKSB8fA0KPiAg
CSAgICAhSVNfQUxJR05FRCgodW5zaWduZWQgbG9uZylzaWcsIFNaXzRLKSkNCj4gIAkJcmV0dXJu
IEVSUl9QVFIoLUVJTlZBTCk7DQo+IEBAIC0xMzIsMTIgKzEzNywxNyBAQCBzdGF0aWMgc3RydWN0
IHNlYW1sZHJfcGFyYW1zICphbGxvY19zZWFtbGRyX3BhcmFtcyhjb25zdCB2b2lkICptb2R1bGUs
IHVuc2lnbmVkDQo+ICANCj4gIAlwYXJhbXMtPnNjZW5hcmlvID0gU0VBTUxEUl9TQ0VOQVJJT19V
UERBVEU7DQo+ICANCj4gLQkvKg0KPiAtCSAqIERvbid0IGFzc3VtZSBAc2lnIGlzIHBhZ2UtYWxp
Z25lZCBhbHRob3VnaCBpdCBpcyA0S0ItYWxpZ25lZC4NCj4gLQkgKiBBbHdheXMgYWRkIHRoZSBp
bi1wYWdlIG9mZnNldCB0byBnZXQgdGhlIHBoeXNpY2FsIGFkZHJlc3MuDQo+IC0JICovDQo+IC0J
cGFyYW1zLT5zaWdzdHJ1Y3RfcGEgPSAodm1hbGxvY190b19wZm4oc2lnKSA8PCBQQUdFX1NISUZU
KSArDQo+IC0JCQkgICAgICAgKCh1bnNpZ25lZCBsb25nKXNpZyAmIH5QQUdFX01BU0spOw0KPiAr
CXB0ciA9IHNpZzsNCj4gKwlmb3IgKGkgPSAwOyBpIDwgc2lnX3NpemUgLyBTWl80SzsgaSsrKSB7
DQo+ICsJCS8qDQo+ICsJCSAqIERvbid0IGFzc3VtZSBAc2lnIGlzIHBhZ2UtYWxpZ25lZCBhbHRo
b3VnaCBpdCBpcyA0S0ItYWxpZ25lZC4NCj4gKwkJICogQWx3YXlzIGFkZCB0aGUgaW4tcGFnZSBv
ZmZzZXQgdG8gZ2V0IHRoZSBwaHlzaWNhbCBhZGRyZXNzLg0KPiArCQkgKi8NCj4gKwkJcGFyYW1z
LT5zaWdzdHJ1Y3RfcGFbaV0gPSAodm1hbGxvY190b19wZm4ocHRyKSA8PCBQQUdFX1NISUZUKSAr
DQo+ICsJCQkJCSAgKCh1bnNpZ25lZCBsb25nKXB0ciAmIH5QQUdFX01BU0spOw0KPiArCQlwdHIg
Kz0gU1pfNEs7DQo+ICsJfQ0KPiArDQo+ICAJcGFyYW1zLT5udW1fbW9kdWxlX3BhZ2VzID0gbW9k
dWxlX3NpemUgLyBTWl80SzsNCj4gIA0KPiAgCXB0ciA9IG1vZHVsZTsNCg0KTGV0J3MgbW92ZSB0
aGUgZGlzY3Vzc2lvbiBoZXJlIChmcm9tIHBhdGNoIDEzIC0tIHNvcnJ5IGFib3V0IHRoYXQpOg0K
DQpJSVJDIHRoaXMgcGF0Y2gganVzdCBzaW1wbHkgcmUtcHVycG9zZXMgY291cGxlIG9mIHJlc2Vy
dmVkIHNwYWNlIGluDQpTRUFNTERSX1BBUkFNUyAod2hpY2ggaXMgcGFydCBvZiBQLVNFQU1MRFIg
QUJJKSB3L28gZW51bWVyYXRpb24sIGV4cGxpY2l0DQpvcHQtaW4gd2hhdGV2ZXIuICBUaGUgY29k
ZSBjaGFuZ2UgaGVyZSBkb2Vzbid0IGV2ZW4gYnVtcCB1cCBpdHMgdmVyc2lvbi4NCg0KSUlVQywg
aWYgdGhpcyBjb2RlIHJ1biBvbiBhbiBvbGQgcGxhdGZvcm0gd2hlcmUgU0VBTUxEUi5JTlNUQUxM
IHN0aWxsIG9ubHkNCndvcmtzIHdpdGggNEsgU0lHU1RSVUNULCB0aGUgU0VBTUxEUi5JTlNUQUxM
IHdpbGwgb25seSBzZWUgcGFydCBvZiB0aGUNClNJR1NUUlVDVCB0aHVzIHdpbGwgbGlrZWx5IGZh
aWwuDQoNCkhvdyBjYW4gd2Uga25vdyB3aGV0aGVyIGEgZ2l2ZW4gJ3N0cnVjdCB0ZHhfYmxvYicg
Y2FuIHdvcmsgb24gYW4gcGxhdGZvcm0gb3INCm5vdD8gIE9yIGFtIEkgbWlzc2luZyBhbnl0aGlu
Zz8NCg==

