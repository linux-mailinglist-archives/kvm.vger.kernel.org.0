Return-Path: <kvm+bounces-24675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97B58959196
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 02:06:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5FCDB23E4F
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 00:06:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DD9017F7;
	Wed, 21 Aug 2024 00:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fo8m66cU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3D0182;
	Wed, 21 Aug 2024 00:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724198782; cv=fail; b=UOEimoHMRJY3GeALQ24MZlo/N59Bk7U/3twF5tVxTW9MlPt80I0magZwgOZ0fU3sZQYV1A541jSrntxnsMBpkP8+ObYNIhhP6USv7nOAtfw41bbzgdP+LZ0ltq2+BvO6JXUTeMJI8F0VnowFQuUOEdQROo7Huyo/T5+4PJgRRPQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724198782; c=relaxed/simple;
	bh=KGThXmPZC1mqvPwxikj183RyId4GSIH4dyj/fSmfHFA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cibqxk64YFWkPYdT73pNNrMocdcv4eSpEp0KxrB9ct+0hjAgxS4Gnlz2O3czfdPaZxRC3Ky4HlAODaSk6EMqhsXpe9BPPKUKUl+92Rsx/mJkyum+mliBtiIWr0/4TtJm95DZF2bDNmcTsnesY4vQdae5SoGSvio/xTKAHdfe91M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fo8m66cU; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724198781; x=1755734781;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KGThXmPZC1mqvPwxikj183RyId4GSIH4dyj/fSmfHFA=;
  b=Fo8m66cU4N4pVOqpLLJ6J+ulNvL49PpXvRxhVmlDNo8Kz6p2iLZFNWBo
   0nnADui6fAnjnLi0L0R1LgzbOsG37QGyoYepI2tH7MycAl48WM4ziUA8w
   IiHbqq8oJMHVVrkQ6rEbanN1Gd9d0i8c/dK1fxUvr+uk0iSmSfODEQzPs
   tZA+UJ5WdmgTX+2rIj4yjQsZWiiJym+kW5yt5rVU58L3FgYWgXGvs7VTK
   BNeM3JTaen4+dGvsnD7no20xckU+Q8zU6tNMOT4Y3RmJGgRY0LO5Oax75
   SxDF6c+KQNSk0glnCCzTxLBRRQaZpk8TEPoWam1Pb+KGEDLR9KTjrRU6f
   g==;
X-CSE-ConnectionGUID: tMfTwpqnSI+GVzYJS2tQxg==
X-CSE-MsgGUID: F47aacsXTbWpLiomsPrCVg==
X-IronPort-AV: E=McAfee;i="6700,10204,11170"; a="22151208"
X-IronPort-AV: E=Sophos;i="6.10,163,1719903600"; 
   d="scan'208";a="22151208"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 17:06:19 -0700
X-CSE-ConnectionGUID: WW48wBakTkG7g4sh4pAKaw==
X-CSE-MsgGUID: YWwlgKIJRFGYupf5xVHT3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,163,1719903600"; 
   d="scan'208";a="61443478"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Aug 2024 17:06:19 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 20 Aug 2024 17:06:18 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 20 Aug 2024 17:06:18 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 20 Aug 2024 17:06:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RxRNPhES6TwT2mkPEQKNTPkeL4B3phRteqswIUYl3PQ8+PyS8aLr2fq4+2jTxUIEqR97JQAEjB/JeZbjXYWLjb1FL97H/cuotO1GtDbdwmLzz+mGtPWmfwIovmrrrXO6iH/yJCBLM2nA77Oauhw/bfBfRq6WuzL0aIfh6LmOc3vBjzc+tlTmTKo+otaLoRqL5xmyiWQC3BHwNFmWHlFKr7zXJXfp32slYIapPVB5WThCKDQAsyfEqXPq1L4P4TYhzuZIqgV2sh4goE9QrXTJBvh+ijRTy05K9p4v9H0aRMdqM8Ljg/bAMDhBdRzSBqUT0fzUP2LPlhbsICoRr6kH0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KGThXmPZC1mqvPwxikj183RyId4GSIH4dyj/fSmfHFA=;
 b=I5qf0dn9lbn4QqHAahXQ+3JbmokglpuEi3whMGqRHYTCi3iAsYc918FXfFHJ4luzhKh3cOXvV6pu9NwamGC1Z1Zeb4yqrWcN8UK0QzG4n6fByGhmco9JiPHmA7yHLA49dRNNH8NhwLb56vHu3HPRZ11qQHAh9GUBW4mz4TCkq5VsS0FARIUACpo3I4uLZiZ6rXVbxxCj2v/mSXmBLv+ZY/p3astmUN94WWov4rde7KVFrHnqCeK7Xf8quWOV7ao7HyURhWl4R9M4PxNvsibVJ3PKz6uqApK10hy6+DUf3WnCa3as6qHDatYRF3MLqoTmtKj7f7eBKuCPCGSlgfsQ8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA2PR11MB4780.namprd11.prod.outlook.com (2603:10b6:806:11d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Wed, 21 Aug
 2024 00:06:14 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.7897.014; Wed, 21 Aug 2024
 00:06:14 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "nik.borisov@suse.com" <nik.borisov@suse.com>, "Gao, Chao"
	<chao.gao@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH 11/25] KVM: TDX: Report kvm_tdx_caps in
 KVM_TDX_CAPABILITIES
Thread-Topic: [PATCH 11/25] KVM: TDX: Report kvm_tdx_caps in
 KVM_TDX_CAPABILITIES
Thread-Index: AQHa7QnNXx3t2jn1kkWLgJzVMLHO7LIkiYAAgAnge4CAAnfQAA==
Date: Wed, 21 Aug 2024 00:06:14 +0000
Message-ID: <e08e22e6e87497d23dcf0b2dc4c286c7a8e7d132.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-12-rick.p.edgecombe@intel.com>
	 <ZrrUanu3xYZyIshY@chao-email>
	 <d8cc987e-8007-4820-b493-df2364b31774@suse.com>
In-Reply-To: <d8cc987e-8007-4820-b493-df2364b31774@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA2PR11MB4780:EE_
x-ms-office365-filtering-correlation-id: 21c1b5dd-3dc9-4cc7-1393-08dcc1751279
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Z0dYY200emV1Y0ZORitxVzhxeXlFMWRJT1JOY2NMM2RMYWlheVBHa1RyRVM2?=
 =?utf-8?B?SFlrSXQ1bTZCRndBSi80WGhOTE9LTHRQaUNLQ1NaWldCWnNMNGlEZlZOQkFa?=
 =?utf-8?B?TStFaTdZalZXOWNZNGZmcTM1WkQ5b0ZxUGVHU0dFR1hNeTNUbWJpZnYrZzFN?=
 =?utf-8?B?WDJmR0ozNkdvU2lQaTJibktPUStpYmRGZDRnazJUcUs0cmlya0dGeHorNVF2?=
 =?utf-8?B?bzhSSS9xWHNGUS9NeXdZV0g2ZE1Ka2NGMllKNC9TYXlVZ0ovNkZ5TjlZMk1X?=
 =?utf-8?B?MTZnTUtRTm1lWTNpWFlRaUI5cmZ2cWowN2hYWWdWVHZPc3MzKzdUWGlwS1RM?=
 =?utf-8?B?NnJIK1FyaTA5U0toek1BQ3Zkbis0ZUdKVE1kSTMwemZyTXgwL2R4VUJlMmcx?=
 =?utf-8?B?eE1KKzZkOWdLN0VDMXUwOEYzM0FSczZHbk5ZNWx3K2JIdUtCSzI5L2tMSzdB?=
 =?utf-8?B?SXd6dUdjUTluSlJRNjZzTnMwdnBUaHJldVcweTBRbC84MHJZL1NWNGxheWVP?=
 =?utf-8?B?VWtVSDRZVEhLV25vS3U5azEvU1E1enB5cUZOdWw4Q0JRNzdkZ29RT0VhRW44?=
 =?utf-8?B?dmJ2b1o0emVVcnRhSFRrKzJaUjlib0M1WFc1TkZ6bGU0YXlsS1k5NXRWTWZT?=
 =?utf-8?B?U3BtbkRuMVpIdjVaM01raEF0V2FQMmJqRTMvTFZOaWhrTVJ3eCtLVTUzbzBM?=
 =?utf-8?B?TmNRTEowVytndlVxRWcrTkxFdFhkdW53QmYwYzlMY3pFTkR4KzhrbUx0c25B?=
 =?utf-8?B?UEwvQ2tHd2NxOStJaXZlWWtpcWNBVjFPTkJycTVteEdBM1U3UEtiWUpwN0xF?=
 =?utf-8?B?cWU0Z1lkeGJRMVYya2ltOXdTSkdPUU5oU3JYcEZFT0RDbVJUSXV2YzJneHlO?=
 =?utf-8?B?RHh1OEtTK0crRGk5KzJkNGFFdGNiNTdVNXVZRzhsZXZLMVBpWm9HMnJ6aCtv?=
 =?utf-8?B?Y2RFWVZvSUwzTStIU2o1TXNRaVRjRTRDVW82NzBkbTJ6VXVpdzErbndqS21D?=
 =?utf-8?B?MGs1dHQxb3NtY0gybXhycUdFM2pzOVBIM0ZDbDB4dXBmMkY4Q3VhTnJvSHk5?=
 =?utf-8?B?OXZwekp6S1hlejhXSzhZeDNQQnp5RmxXaDZ1bU9sc2R4UklIODZ4bTYwcVpZ?=
 =?utf-8?B?QXpYaEpvVjBIcXhOc1UyTmluOFVsOThETDRmMXZFbWd1em9xaDhTWDVqNTg1?=
 =?utf-8?B?V3diVnI0aHVVbXdNaHduaXdtSmVEL3Fad0U5UFZQTjNNUHRxTlh1UWs5ZWFU?=
 =?utf-8?B?S2dyNFJtQ3U2Z29xTURvRDRtOGE4amdtWUhsUzNPeFJDSkhaMGs2ZFBodUJv?=
 =?utf-8?B?eHJyR2tra1VSb01Lb1Q5dWpSeG45bTZ6K0NvbjQ4MVM0aVp0NWM0TnRUZ2ZK?=
 =?utf-8?B?TFFyU1pZUGNsWjk5L1lNWjNvSm5icUdNU0R6TGlQUXR6VkVhVENvZUJlQjJP?=
 =?utf-8?B?QXpTdnpkbldIbFJTdytyMWNuMVh3d25pY01VZXBEVlRtcUVmOXMrTnkvWTQ3?=
 =?utf-8?B?M0d4NHhpak1KbTBVRnpPb3oyRllyczM3cS9BZ2xLRVo4RkROcnM4MjVOcmk1?=
 =?utf-8?B?eFVoVUV2MHlPOHhPd2RtMFNHZEpBa3FuRTdaMU9VZTdubE1SLzloQmtxN0pn?=
 =?utf-8?B?TkZKM2ZMbHhqMThFUU9iaTBJT0RhMFZtNmErbXA0SVdlNmNiRFNLU3BlTTFB?=
 =?utf-8?B?VktIcGFwU3ZFbHMvVDB4QVhhZzhRSG8vemVSdlEybDAwR0xRZ1FEMU1LaHNp?=
 =?utf-8?B?ODdIdnNSNUhuajhuaDhmcnRLbTFXZzJzcGVLS2l4SVZCRmRHOEFKaTRDVkJN?=
 =?utf-8?B?ZFZMS1RqdDA0cm5IL0gwMlpKS0xzdGk5N0pWdGg4T2Z1MXNkdmJQWGZiWEpD?=
 =?utf-8?B?RlVJak14cWx3eVArVmNrN1hHSElxNllLbXA2T3lCdFo5aVE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UlE2Rkh4UG9CSlZzTDBkTU00bWl1eC9DejhGZ09tWUpQcklZMHdVRFNOZEdL?=
 =?utf-8?B?dU9SQm81cTNjYTczRkpZVTdDb2dJcUY2dCtVcERTcUhQQ2Z1ZkxiM2xpNVJJ?=
 =?utf-8?B?d0tGeVVOR3JvVEFOd0Q4UkRnazZCNDlKS0dieEFGK0lpc3R1MTBQRzJvbUpQ?=
 =?utf-8?B?WG1uT0l0RERIK3FPWGV4am5GbW5YbXlDZVJWOUE4MmIvYm9yOHRIZ0d2a3lF?=
 =?utf-8?B?SFQzalVwcnFWeGRYMjJQUHMxRVBYSmFRSjducU03ajNzODE2TzN3ZDhsQ2Fl?=
 =?utf-8?B?UzI0SnZUZ0FRT2hsYmRsMkJ4dHVHZEpQOXVPanA2c01pQWlpeTl5RGNqaTZx?=
 =?utf-8?B?VFMzcENBU0JHSEt3TlFMNWxaL242RjJaZ3krTTUvWThaM0VrNW9rcUFaZmRD?=
 =?utf-8?B?Z08wWjZhei9PRkJKdWpPZExIWTRwOUZoS1V2bFNPdzRCaHRWTThLVjJWWk11?=
 =?utf-8?B?TVcya1JTYkRjNUpoTUFKVm9lL2ZvQkdWM2tkUS9qakNEU0xESEJVbVhkZDJ1?=
 =?utf-8?B?ZnovdzhTaEFPR3hVUXpCdm5qYmJhUEs5dWdEY0hYTFBSU016bWp2TE5CeUEv?=
 =?utf-8?B?R2dvd3FIS1J3azV2STY1dmVIS29YVnBhZzBmVzg5YnlxNHUweFlwa0wxUkNH?=
 =?utf-8?B?NW5yNjc5bDFFWlhiV3FSRnl3RGtsSGswZllKTzZmbUJmNUtmRzh0Rm1BOG91?=
 =?utf-8?B?V3FkT1ZPN1hqcHptTE9Yc1NVTHVYODBFSklkYTVCbTRkOGcwam5CVzJpYS83?=
 =?utf-8?B?cDJUbnFXVEREc243L2dPMmVpK1N6dWxoeTFBQTA0c1ViWjFmN3VrRGh4VUg1?=
 =?utf-8?B?RUJhajg5aDNJNmp2YzZQcjd0V3o3LzdmaHJpMmdzbDU0LzVaZ1JDM0NTcmFJ?=
 =?utf-8?B?K284YjZzRyttU3JUaExhQ0FLQnZRREhRdmZUenhWR0xvYjVXLzlVUDNwTitE?=
 =?utf-8?B?OXVkVTRxYVQ4S0xsS1NqbkNxS2Zkd2VaOVJuZFpQU1k2bVY2NWRBSk9BM0R5?=
 =?utf-8?B?V1pqT0ZCVmY4UndhdjNFblhJSmVGT1p3YXdSVDdrK2JLRHcvVWVHTFZYVXBG?=
 =?utf-8?B?MVNRYzVZK29QOExJS1BEajIrWnA2OXJkSjNhdEJuZms3N3FuQzNNeDJTT3p3?=
 =?utf-8?B?dndsYjRDU1l5dGJXVGs4TW11bTFDVXB6dkNsUVNjWmM0Z2I2N0FpdTR5VVhL?=
 =?utf-8?B?R2JNdGVibHAxVnlnYzhwNTBlb1E0V0lQNllkcC91OW1wOVppeTZrWUxZZE1B?=
 =?utf-8?B?bFl0TDRMUWVrOUNMN0ppT21ldTY1T2JUNjVXVEF0RmJ6QnhNeXhDeDl4UXZY?=
 =?utf-8?B?WE1ZY1ovS2RYNjVDRDFSd21nb25WY2tIeGo2MjI2Q3p2dklhcWN2RmFtY1V2?=
 =?utf-8?B?MHBxelZSanlRWTVqZ25nMXNpalJZNmJVN0w4MVJSS3BudENQMVRxNGMxNEpx?=
 =?utf-8?B?SkVsUlFaTjRES1BMbzNqNG45L2RZdFAySGthb3BLRDlJeHhzVkQ2YXhLTjF6?=
 =?utf-8?B?ZmZlTFVlMjZPUERwVEJITFlndmlDdmZYQUJjUElGS25FbUZVMUpyd045UWc3?=
 =?utf-8?B?UEdnM3VCUHVxQUR3YXRqdEgzYi9jSFhtdDRqR3BKMXR5NmJqekJDYndzMDlJ?=
 =?utf-8?B?UkZuakozMEFheE45WnlJL09IK3B1SEUwUlpDVWtWaE50R3ZJMFJKVWJjcElu?=
 =?utf-8?B?dWJmVllaS21uN240eStsQ1BrOHRlRm4xVDVOcmlYTXkvQVJkSXhMTGV2bUQx?=
 =?utf-8?B?MjNqbzhGRlAxM05sVU93REN2RWg4a1JVc1lmOWdSbzhwTWRvb1g2WWZicWNy?=
 =?utf-8?B?QVptQ25ndUl4MTdWTFh0SXRsVU5ISnV1NkdJdWpjOEdBTFA3ZytXL2E3cHdC?=
 =?utf-8?B?MkxPQUQyRXhQSzViNGhLNHJQb05NNDN3UENLeURkRHdKNDVLa3RRd3VhdEZj?=
 =?utf-8?B?WVBSc1FEM2c4T1FkNjJxaTNXaERvRE5EQ1JXajd1SW83M1c4TVloSTE0MVgz?=
 =?utf-8?B?dU9Ca0dYMytGdDVNWExtSXV2dVorZEthSkwxTDkrd0FHNDd0ZjhVbTB4UEdJ?=
 =?utf-8?B?d0ExOTlvd0NQcUtuNHdmOVJVK3VNdzlUclVmb2lrOEdhcGFQVFFNdzcvc2Q4?=
 =?utf-8?B?ZUVYMUd1b0dsVFp4ejlzYnAxNmo1aFp3R3p6RUE4Vkl6bGJySjR1MG9wb0p1?=
 =?utf-8?B?Umc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B9971463BF508347AC220C1C75BF4A26@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21c1b5dd-3dc9-4cc7-1393-08dcc1751279
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2024 00:06:14.4851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3OcKu5kqkdis4f2wTwGp/QopMZNwMqo3Vaej3e/9L/uKvAE9Aals0BkcY7Oqoixz1lHE+hHbXFbmrjsSZRFUEjKoSv7c9He4fA05a0rq/QE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4780
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA4LTE5IGF0IDEzOjI0ICswMzAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+ID4gSSB3b25kZXIgd2h5IHRoaXMgcGF0Y2ggYW5kIHBhdGNoIDkgd2VyZW4ndCBzcXVhc2hl
ZCB0b2dldGhlci4gTWFueSBjaGFuZ2VzDQo+ID4gYWRkZWQgYnkgcGF0Y2ggOSBhcmUgcmVtb3Zl
ZCBoZXJlLg0KPiANCj4gQXMgZmFyIGFzIEkgY2FuIHNlZSB0aGlzIHBhdGNoIGRlcGVuZHMgb24g
dGhlIGNvZGUgaW4gcGF0Y2ggMTAgDQo+IChrdm1fdGR4X2NhcHMpIHNvIHRoaXMgcGF0Y2ggZGVm
aW5pdGVseSBtdXN0IGNvbWUgYWZ0ZXIgY2hhbmdlcyANCj4gaW50cm9kdWNlZCBpbiBwYXRjaCAx
MC4gSG93ZXZlciwgcGF0Y2ggOSBzZWVtcyBjb21wbGV0ZWx5IGluZGVwZW5kZW50IG9mIA0KPiBw
YXRjaCAxMCwgc28gSSB0aGluayBwYXRjaCAxMCBzaG91bGQgYmVjb21lIHBhdGNoIDksIGFuZCBw
YXRjaCA5LzExIA0KPiBzaG91bGQgYmUgc3F1YXNoZWQgaW50byBvbmUgYW5kIGJlY29tZSBwYXRj
aCAxMC4NCg0KWWVzLCB0aGFua3MuIFRoZSBwYXRjaCBvcmRlciBuZWVkcyB0byBiZSBjbGVhbmVk
IHVwLiBUaGlzIHBvc3Rpbmcgd2FzIG1vc3RseQ0KaW50ZW5kZWQgdG8gdHJ5IHRvIHNldHRsZSB0
aGUgd2hvbGUgZ3Vlc3QgQ1BVIGZlYXR1cmUgQVBJIGRlc2lnbi4gSSBwcm9iYWJseQ0Kc2hvdWxk
IGhhdmUgdGFnZ2VkIGl0IFJGQyBpbnN0ZWFkIG9mIGp1c3QgaW5jbHVkaW5nIHRoZSBjb3Zlcmxl
dHRlciBibHVyYjoNCiAgIFBsZWFzZSBmZWVsIGZyZWUgdG8gd2FpdCBmb3IgZnV0dXJlIHJldmlz
aW9ucyB0byBzcGVuZCB0aW1lIHRyeWluZyB0byBjb3JyZWN0DQogICBzbWFsbGVyIGNvZGUgaXNz
dWVzLiBCdXQgSSB3b3VsZCBncmVhdGx5IGFwcHJlY2lhdGUgZGlzY3Vzc2lvbiBvbiB0aGUgb3Zl
cmFsbA0KICAgZGVzaWduIGFuZCBob3cgd2UgYXJlIHdlaWdoaW5nIHRoZSB0cmFkZW9mZnMgZm9y
IHRoZSB1QVBJLg0KICAgDQo=

