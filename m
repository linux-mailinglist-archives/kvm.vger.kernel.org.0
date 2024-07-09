Return-Path: <kvm+bounces-21242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83A2592C645
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 00:37:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A72A11C2229F
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 22:37:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AC4A189F29;
	Tue,  9 Jul 2024 22:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nVshkg0X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1325F7CF18;
	Tue,  9 Jul 2024 22:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720564623; cv=fail; b=lyLl1dIaB7ewr1bvAa1MMrl3trGEZ/ThCw+seUl6m1ukiEfWmuZgScjt9Tgnu7ywpqW0e+St18D8dY50UzcDZRR6U/Y/Mw2Lu6oBRLa+/j702pZPjgMeUCsmGhM7tVzrq1O2Wgl3IY4nUSBjziWaR1Ntjz+KRh/bPgcr2SkY08s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720564623; c=relaxed/simple;
	bh=fbKUTSQ+/RdgxorLkKB3z9PfDIXta5FieWU4X+uJSuI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=USLmclawq/fJxi/j/9FXKrnhT2JqWVtKVeGcHjWn6mUbc/TSIlWC5oWwO125lRmeWdAoboPl2kYtHXqn1MiiemmAA60o6c/g9PF4jrc9fzFEFnpXwX1NFKFClew6cZiHPqPynJKMGfbGMsphgqrBBibpTnkkAhuZs1ctlNQqL2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nVshkg0X; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720564621; x=1752100621;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fbKUTSQ+/RdgxorLkKB3z9PfDIXta5FieWU4X+uJSuI=;
  b=nVshkg0XY//cCZAWtQObnO+QcoTjXbzRACNXZRTytTdBppQ5+VDvX2yc
   uvo9QUROL4v839FGZe5uwBG4oJpK18FBFpadqniIpMcCN1PJCPwmkm/OH
   qImLKlrjNfIEbHxUsJjmkHxcgfFC7KxbdVKQGOZsOtd4H3+o92ffcyiUz
   drQQPjciGKfFCnCvqWvn8kxjB5MbJUvpdT+lUjTc0xGCAyj1O4DzoS6ii
   BLxSPgJ4AdnB6eKqD2xVvErThX8PBh1tNFEm+GrIDuJRdsvY5VcNennzB
   kebEkt/q5l3KIlqLmPnGbi8jc5GlGZMXxYJpmuLxUS1TpZYMysbMBVtld
   A==;
X-CSE-ConnectionGUID: Ndpsu+7ZTyit8/mtj8NK8w==
X-CSE-MsgGUID: 0X/mtsD7SQKQc1g071tq2g==
X-IronPort-AV: E=McAfee;i="6700,10204,11128"; a="17485733"
X-IronPort-AV: E=Sophos;i="6.09,196,1716274800"; 
   d="scan'208";a="17485733"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2024 15:37:00 -0700
X-CSE-ConnectionGUID: Yt/p9XIERY6Nxo2xr5LozQ==
X-CSE-MsgGUID: bVeRX/YuR+6Ft/47HBXhyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,196,1716274800"; 
   d="scan'208";a="48453703"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Jul 2024 15:37:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 9 Jul 2024 15:36:59 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 9 Jul 2024 15:36:59 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 9 Jul 2024 15:36:59 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 9 Jul 2024 15:36:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QSsCv3faAIxy4OzVMtDjoSg5T57YHRh4Yq12q0x2gzUU3Gzpg5DEe+GsKZbmAU1zkUrtaoqL6vKIrUyc9Cj3f/v8g6a+05cwM/isDeRqLx963ABkILifPocxDyyuuCYl+gNapKjlry2YOw5YvLiptImq+PE29NhJSWjiEC2EJ6p0wOrT8jSGmlDXb37IkkBujM3jezV44nSN6khqDHxXjuQnJZwfifaFB3ldKN0rGybbCSby2RTiadfXwGsLuNKuUMh4yrPBlGlCPHBj26FJXI6PtVGjVgGoDbNhGUdAGsLGZbJM8Xl0On35RsKrPaQ2zycnCao7fYT0LWUmUtop5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fbKUTSQ+/RdgxorLkKB3z9PfDIXta5FieWU4X+uJSuI=;
 b=XNzK9F/zFSsgd1UikfAQKWWCdRq42J1Jbtsqf1hCY3H7YEOHo9fDEfkKR3BO4H1b4RcmJGiWWwU84XgWm8q9JtGDK9nlde+0tP1XzxH5iB5fMnTZmjyTnON/PtoENL5bZ5hWha9WqxdZvuAVYX5jQY2AVupVLHQjLts/Fko32Tt07OdzDllIGjkB0DbJkO3pLHnCvaH4Uz9WqRhuynj/YEAAyIRTy+zxjEXXizFDkQg2c36/ReSsF7tvqQ+SeqSLrSmCZY/R7ClR2CODtEegGbF5sgEQ6s7Y/ReooIUM6Za9cp4IN6B1FljvoeoJ8jhI7f9aGu8O0Eil7B27jNa/Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7287.namprd11.prod.outlook.com (2603:10b6:8:13f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.20; Tue, 9 Jul
 2024 22:36:56 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7741.033; Tue, 9 Jul 2024
 22:36:56 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "dmatlack@google.com" <dmatlack@google.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 13/17] KVM: x86/tdp_mmu: Support mirror root for TDP
 MMU
Thread-Topic: [PATCH v3 13/17] KVM: x86/tdp_mmu: Support mirror root for TDP
 MMU
Thread-Index: AQHawpkqUontib46sU2zk5qqIlBj6LHWnFqAgAESGACAAFF6gIAA+LWAgACO+QCAC/TxAIAA0TOAgAjODgA=
Date: Tue, 9 Jul 2024 22:36:55 +0000
Message-ID: <d33d00b88707961126a24b19f940de43ba6e6c56.camel@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
	 <20240619223614.290657-14-rick.p.edgecombe@intel.com>
	 <Znkup9TbTIfBNzcv@yzhao56-desk.sh.intel.com>
	 <b295497932e8965a3ea805aa4002caa513e0a6b0.camel@intel.com>
	 <ZnpY7Va5ZlAwGZSi@yzhao56-desk.sh.intel.com>
	 <70dab5f4fb69c072493efe4b3198305ae262b545.camel@intel.com>
	 <ZnuhfnLH+m3cV2/U@yzhao56-desk.sh.intel.com>
	 <7268ff80d3825fa6d7a50101358b47d5fbe86d5c.camel@intel.com>
	 <ZoZYryszKWI5IYy5@yzhao56-desk.sh.intel.com>
In-Reply-To: <ZoZYryszKWI5IYy5@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7287:EE_
x-ms-office365-filtering-correlation-id: 36003ee3-d863-4f8d-23c5-08dca067a32c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?alFPekczUWNEeXZ0aWtuOTMyN09LelQxc0N3L0MrNGR4NXJ3bVBvRmpwdCtM?=
 =?utf-8?B?TW5LNHV3SkJpTGxvVHA0NlgzUWFqT0pBSTgyZGQ5QjRaNTNIV2pWZ3Q2K1ls?=
 =?utf-8?B?VnVoS2xQYThHSHFwT2pYQU9Lb1UvUHFzL2JLaDJtK21jMHFHNjNuVHRFZ2pK?=
 =?utf-8?B?bTlJK041WHZWOXM0TG5jY3NTcktzdjY0L0R3NGZ3NTZhSHAwUFR1cFQ4RjFp?=
 =?utf-8?B?d1R4MUNmUWdoM0lKMzZRRFZ3RmdRMEVVbkU5b1JiQ0xVU0dsanBCRUJXS3Ew?=
 =?utf-8?B?ZkhMNlVHSGVTSXM5ZGF4R0dGS2d6VjR3Um5lTGtTbEd1di9YdzBzM1M3VWEr?=
 =?utf-8?B?VkFLTmpBTVlnbzdIVis3a2k0SnNDbmdCYk02M2RuOCtaR2NuUjM0NThKL0Iy?=
 =?utf-8?B?aDYwZjFSeFlRSGVocGFLNUZpVG4zeWhMSVkzSFB3OEs5dCt2dkJlWXFmZWtj?=
 =?utf-8?B?amVKc0l1OGp0YUt1S3BnMDM2ajk2UU5HS0RxUVlQeVFaMWdvN1N3T1JKMkhB?=
 =?utf-8?B?dmJZSDlFZkhEVW84WVBhQ1J1cTdaK2VUZFo2aHpEMFpFMmJ0SkFxRTgrVnBI?=
 =?utf-8?B?RjJKeStWV1VBUHNMUlV5UDBMTUNTMVVORk5KT3c2bjQ4cnpFckVqQVFGaDFp?=
 =?utf-8?B?d2xpMTJNRzlVUzFRNktlcWlmM2xTSWlNS1JSUWNRZXBpMmZEUHNlUmx5cUdm?=
 =?utf-8?B?aFdnczBGQzcyTUxYM1MwUTJDV0U1UHdtUWJSNzkxT3FIMVVGc0xpeGd3MUc0?=
 =?utf-8?B?NzlhbW8vazNhNkcvb3hBL0oxWXlsaTNnMzc4WmtxWGNOaVlIT2xmNkp6N1VH?=
 =?utf-8?B?d2xtTG9xSC93aHh3bEdDMFMxMUtYc2h5cnNUTVRGZmpBSGNTNUZFVWlSSVhR?=
 =?utf-8?B?YWlWNjhSZEpyZVEvVUNkMkZIQjRKZVFNY1ZIRDR4eDZsQzcwVGZ1UHQ1OEVW?=
 =?utf-8?B?M0IxZ3QvRzdENS9OZERmcXJxNFdIbncwY2ZwMjF2UmhVb0VoNHJLL21FcVBs?=
 =?utf-8?B?Z3JNWlRhUUFISk9aeFRLc3NhVEIyMUorb1A0MjNWSnZ4NFVibVZCbzlTZjRq?=
 =?utf-8?B?dExQcEdpYXo0d01MemNqdC9Ha0hvMEVZL1VyZXg2YTJBSTdleHZ2SUxaNGht?=
 =?utf-8?B?NGJkakdZRmRXd010bk9Ia2RMV1FzS2pxa2U2Q1VnVU9oQnpnRXFRamZiNkhh?=
 =?utf-8?B?bXp3TDhMQmtaTVdWck9kR3BWek9ocXY0S0IrUWFmVGlEaG5scVhzait0cnl0?=
 =?utf-8?B?cGJyMEJMWm1xcnJPcHV4dm9RVDROcEZYUlVhdnRDZ3NORDMwSlJ5eDN2Uk5K?=
 =?utf-8?B?ZWxpZ1VaZ0FWa1Zna2JMejZRSGUrdkE4Q0l2Z1V0dkUxdXZpMHkyOTVFSFI2?=
 =?utf-8?B?c3QzeGpKTnVhMTdsR0krbTdGRi9QUnNwUEFwcGlQZTgxK1NkTHpFS01KYUYw?=
 =?utf-8?B?M0xUM3FETS9aL2NQY1J2T2NGVm1zdnA3UlNwR2RoTG9JbTZ2bjhaYVVscVlD?=
 =?utf-8?B?aUFiUFJSZjlhMENqQmVIZzJMMVdHNnY0YzdVMzJDdVV4YktmZGtzdFNIRFoz?=
 =?utf-8?B?MWpyQnlkc0dTcjEvRlNOWWlzeXJ2OS9NY0UrRnFXcEtKY2NsbWl3ZSttRnE1?=
 =?utf-8?B?VlBoQWxUaWI1K25PRlA2T1dNekJwNXd4M25pUVF2cFJFYzdFMUE5OTRtWjJB?=
 =?utf-8?B?aUtpS0V6cUpkbS9SUXluQ3FsOTRySm5XOFBUejBXMEtXdVY4c2pqU2FWalJu?=
 =?utf-8?B?N0RvSUdKTWZjdWJ5UCs5UXJVS1YzYzBSUlFWeThINDY3cXF3Z2FJd2ZOT2dM?=
 =?utf-8?B?YXFzZGsrcnIxODVEbzZNVytYWjJVSEhtcWlyREZKc3AzOXNoUU5iNGI4dWRO?=
 =?utf-8?B?aGk2bkorbUdTaDlwLzRKTHNJK2hkZWdtU2IvQTdOT0k5N2c9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T3JGcWx2bXNHVHJ4amVLaUVrVWhaT3ZvL3N5NGo2N0dFVzJIUnB2VHBFOGFB?=
 =?utf-8?B?MVhMUitpV0FtdWRoc1NkSlF3ZXl3TVZNeVBuNGRWWFZRRUxJZnhXai93VFZX?=
 =?utf-8?B?eDg4Tkw0cGZCaXlMU21FL212WXBwS0Y4d1FDc2x5YXR1UlhTZEd4dHdCRDNn?=
 =?utf-8?B?RXU1SGt1VXRPcFFMS2R5SWhNcUV2WHpZUnZLREdnVmc3UnVNWE9mcUJRdDkv?=
 =?utf-8?B?aVFqTzhGS1N3NG43WGNuckxHT2t6TXZuRkJVK0taU3V0YmxpaHhtUlAvRC8x?=
 =?utf-8?B?ekMwcmhoeGFUS0pESG0xWVpSUFoxN3ZHTysvL3NGcys4S2tudDY2RWUzNnRJ?=
 =?utf-8?B?TGlIa1JWNlZtZEhWQUpJQVREbFRiL0l2WlhSUlV2RzZGVTh1YzFxR2xMckZL?=
 =?utf-8?B?eWkxeGJnT1pmWnhlZk4yNDFGOFdXYjhROG5JbHpDai91YmFjUnNuSDNPRUE3?=
 =?utf-8?B?enptNldVTURURFVVYlhNeURVWUJsM0FQMGRKdWtPRit6T1RsNUtPTEUwQ08r?=
 =?utf-8?B?YVlaWUQxMzBjWEV4MWppZ2d1eTVmcE5KaWN3aGtqOWh2V0MxNDFrcXk4TG1T?=
 =?utf-8?B?TVM4UlJ4RlJYcng2b1Vzd1RnK01XcnBYdDI4NXZzaHIwb0s4emh3VU82RG52?=
 =?utf-8?B?aDZPWm12Tmx1dE1lM3l1MDMwTTFrZWluUC9aVVVqSUtRTWw5V29CT3hWc08v?=
 =?utf-8?B?cGdDdHo3NjhrQ3F0REFMZ0Vxa2dLdkd0bXBVMlhXR25ldmRjVTBvUGh0K2pw?=
 =?utf-8?B?ZzlmYTFTdWNvR3JHZGlMNENkZmkzVmdyYWFybGh0L1M5K0VNQjY2dy9YV0FE?=
 =?utf-8?B?LzVOTS9KZ1BhQWlVVWdSelkyQyt5SXJZR3JjVGpCMVJ0WG41ZW9PUzgvTEhV?=
 =?utf-8?B?clhNNllPcXRidmdtQzE0Zm9JRWZ4d3VseDVXdmNDNlNSekNsSjlVcEhmOWxX?=
 =?utf-8?B?cFFGc1N0OWR0bnhBcy9ldTQvNEZMNTM5VHlQa3NXSWtKeE9WQ0h0UllGa2tz?=
 =?utf-8?B?YThDVHY5YnlzSlVjSW5sUWZMSUxaUHFJeXRnQ2lVTFk5SWJlZmJ2Q0tsWHFS?=
 =?utf-8?B?VktJSm9HeUh1QWI0YTdFL3BjMkNhTW42bmlwYmc4ZGZ5R0JhcDZ3Z3oydU91?=
 =?utf-8?B?R1AvVU51MzdGekhqQWdMd012M2cxR1ZacXU3bDIwZEtMbEtEZCswYlVOZUFR?=
 =?utf-8?B?bUJzTEJMRW4yUkFDTG5xbUxWM2NBTzhiRTFCa0h0TCt2aWNRZXBweXdIWUE0?=
 =?utf-8?B?QXk3d0xwVW5MdlJPNTRIWXg0MXJ4dy9DRHF6M0VKK2RlVGVkc2ZLdWxOSkNL?=
 =?utf-8?B?QUR1b3dVY1BpWW55N0hrdTdHNkZjNG4wR1grZlgwandIbXErZFRNZStnTk9G?=
 =?utf-8?B?M3ZRTHQzeVBLVUFOa3U2R2hQU0Jrc2dHTy9IbzI2RkNkY0E1Rm1xZmxVTzNE?=
 =?utf-8?B?Y2t2bWdETzVXZGJjWmkwZk43S20xUGUvMXZNMmJ4OVZHbEowRHYxRlhXR0pq?=
 =?utf-8?B?bzExZE5oTVBBM3JOTFdsTXBOckI2NWNHYXNWS3pzSWd4c1JSY2hHcmdkR3ZG?=
 =?utf-8?B?ZDk2V0J2bG1iODBIMzF2ckxhM1dpKzVxTEJKcnEyUEpCVFFSRmloSmcxc0l5?=
 =?utf-8?B?TjlRZ3RmSUFteit5Y2tjMzlOUXp6STNndTFhRXpObVpxSGpYTUtkQmZWNVNv?=
 =?utf-8?B?TFVoSXNtYnBnVTJvcEtsZXBNN0V4Q2cyb29ZblBDKzR6QmNVb0luTVdPOFIr?=
 =?utf-8?B?NkFNc3V1ZXEySVBhaGRrejVMRDF2UE41Rm5NcTBOMVBJUU1zbFZEZ2FjT0Nv?=
 =?utf-8?B?NlhMcG02M00wRXVGa3UxbDVSZG5GcytkVTFlUWdsUXVDYm1lZUlBZ09yN2M0?=
 =?utf-8?B?YlU3OGxuSE9hWWRpeXlROGZoMWdFWDlsZVMrZGVMaGVCeE5JZGcwQ3d3UU9k?=
 =?utf-8?B?TTlTWEs2ZG9sdWd2UzN6R2JJQUlIOWluQ2l5YmtuaHNVL1YxUlAxSnFNK1M0?=
 =?utf-8?B?ekdJeWlROXdHRlFGeG13dVJUZ09VY3FHZk9yWENpeHBUMzhkeGFwUDZvL1Ay?=
 =?utf-8?B?VllDQWhwRXpGQ05VVnBxZXUrRGF1TjhRakE5clBLT21KcXBUckIyNTZjbkJG?=
 =?utf-8?B?b2RNcUhyZk1RRElLSzFDK2k3aTB6aWlhdThhMGtuTVpBaW9aS3lkRDhLZiti?=
 =?utf-8?B?Q0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <908D036936ABBD45AAE417854A8A3ED1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36003ee3-d863-4f8d-23c5-08dca067a32c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2024 22:36:55.8962
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: idVgwWR87MmnQNoevWVW9tqavN1SMO4iGH7ykvzrAYq7lmi9mvf4x9qQtlYfkrXlT1GFF1ziPd+l88Bkbd/lW1niFz0jQnrCc2JRFdPnKN0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7287
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA3LTA0IGF0IDE2OjA5ICswODAwLCBZYW4gWmhhbyB3cm90ZToKPiBQZXJo
YXBzIGFsc28gYSBjb21tZW50IGluIGt2bV9tbXVfcmVsb2FkKCkgdG8gYWRkcmVzcyBjb25jZXJu
cyBsaWtlIHdoeQo+IGNoZWNraW5nCj4gb25seSByb290LmhwYSBpbiBrdm1fbW11X3JlbG9hZCgp
IGlzIGVub3VnaC4KClNvdW5kcyBnb29kLCBhbmQgdGhhbmtzIGFnYWluIGZvciBjYXRjaGluZyB0
aGlzLgoKPiAKPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL21tdS5oIGIvYXJjaC94ODYva3Zt
L21tdS5oCj4gaW5kZXggMDM3MzdmM2FhZWViLi5hYmE5OGM4Y2M2N2QgMTAwNjQ0Cj4gLS0tIGEv
YXJjaC94ODYva3ZtL21tdS5oCj4gKysrIGIvYXJjaC94ODYva3ZtL21tdS5oCj4gQEAgLTEyOSw2
ICsxMjksMTUgQEAgdm9pZCBrdm1fbW11X3RyYWNrX3dyaXRlKHN0cnVjdCBrdm1fdmNwdSAqdmNw
dSwgZ3BhX3QKPiBncGEsIGNvbnN0IHU4ICpuZXcsCj4gwqAKPiDCoHN0YXRpYyBpbmxpbmUgaW50
IGt2bV9tbXVfcmVsb2FkKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKPiDCoHsKPiArwqDCoMKgwqDC
oMKgIC8qCj4gK8KgwqDCoMKgwqDCoMKgICogQ2hlY2tpbmcgcm9vdC5ocGEgaXMgc3VmZmljaWVu
dCBldmVuIHdoZW4gS1ZNIGhhcyBtaXJyb3Igcm9vdC4KPiArwqDCoMKgwqDCoMKgwqAgKiBXZSBj
YW4gaGF2ZSBlaXRoZXI6Cj4gK8KgwqDCoMKgwqDCoMKgICogKDEpIG1pcnJvcl9yb290X2hwYSA9
IElOVkFMSURfUEFHRSwgcm9vdC5ocGEgPSBJTlZBTElEX1BBR0UKPiArwqDCoMKgwqDCoMKgwqAg
KiAoMikgbWlycm9yX3Jvb3RfaHBhID0gcm9vdCAswqDCoMKgwqDCoMKgwqAgcm9vdC5ocGEgPSBJ
TlZBTElEX1BBR0UKTG9va3MgZ29vZCB0byBtZSBleGNlcHQgZm9yIHRoZSBzcGFjZSAgXgoKPiAr
wqDCoMKgwqDCoMKgwqAgKiAoMykgbWlycm9yX3Jvb3RfaHBhID0gcm9vdDEswqDCoMKgwqDCoMKg
wqAgcm9vdC5ocGEgPSByb290Mgo+ICvCoMKgwqDCoMKgwqDCoCAqIFdlIGRvbid0IGV2ZXIgaGF2
ZToKPiArwqDCoMKgwqDCoMKgwqAgKsKgwqDCoMKgIG1pcnJvcl9yb290X2hwYSA9IElOVkFMSURf
UEFHRSwgcm9vdC5ocGEgPSByb290Cj4gK8KgwqDCoMKgwqDCoMKgICovCj4gwqDCoMKgwqDCoMKg
wqAgaWYgKGxpa2VseSh2Y3B1LT5hcmNoLm1tdS0+cm9vdC5ocGEgIT0gSU5WQUxJRF9QQUdFKSkK
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIDA7Cj4gwqAKPiBkaWZmIC0t
Z2l0IGEvYXJjaC94ODYva3ZtL21tdS9tbXUuYyBiL2FyY2gveDg2L2t2bS9tbXUvbW11LmMKPiBp
bmRleCBhNWY4MDNmMWQxN2UuLmVlZTM1ZTk1ODk3MSAxMDA2NDQKPiAtLS0gYS9hcmNoL3g4Ni9r
dm0vbW11L21tdS5jCj4gKysrIGIvYXJjaC94ODYva3ZtL21tdS9tbXUuYwo+IEBAIC0zNzA1LDcg
KzM3MDUsOCBAQCBzdGF0aWMgaW50IG1tdV9hbGxvY19kaXJlY3Rfcm9vdHMoc3RydWN0IGt2bV92
Y3B1ICp2Y3B1KQo+IMKgwqDCoMKgwqDCoMKgIGludCByOwo+IMKgCj4gwqDCoMKgwqDCoMKgwqAg
aWYgKHRkcF9tbXVfZW5hYmxlZCkgewo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlm
IChrdm1faGFzX21pcnJvcmVkX3RkcCh2Y3B1LT5rdm0pKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIGlmIChrdm1faGFzX21pcnJvcmVkX3RkcCh2Y3B1LT5rdm0pICYmCj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAhVkFMSURfUEFHRShtbXUtPm1pcnJvcl9y
b290X2hwYSkpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBrdm1fdGRwX21tdV9hbGxvY19yb290KHZjcHUsIHRydWUpOwo+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBrdm1fdGRwX21tdV9hbGxvY19yb290KHZjcHUsIGZhbHNlKTsKPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIDA7Cgo=

