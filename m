Return-Path: <kvm+bounces-56618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F0DBB40C19
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 19:31:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39A76560526
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 17:31:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EC913451DA;
	Tue,  2 Sep 2025 17:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B8eGzVx2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CC41547EE;
	Tue,  2 Sep 2025 17:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756834298; cv=fail; b=g8fNxVwkr+ISC3rn7z32sHHNEApJcvPFHwXI06HZkaegIKb30CnFREwIZXP//pOLVLYmprOjsSwotTOTHMwpMRFRdlQNNm+YnQfa6uwq7Q2vmKkVYSuFmz+MFKjG1yo8O6+K7VYf93t+MH9268Gx349GxKUbGqO/lU3520FStvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756834298; c=relaxed/simple;
	bh=svak9pNzFJSLp7nuPSq3ufwtMAkArOBls9D7uQAOCzM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ENpE6sYy862PIXgbohi0LA2/4uMJV4YdIwMq29gSKNEkgEXSfFbuhVBM96s4nmWdhq62T4ag8G/WZ7DLct99YlXkE5+Hvl99gwVyxUDXtILKauh8JrvHYiqM9AolDTgUXYG9S57olXJeDGD0s/rfjho0nqwY6Lgjbf6eZh+DsRw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B8eGzVx2; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756834297; x=1788370297;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=svak9pNzFJSLp7nuPSq3ufwtMAkArOBls9D7uQAOCzM=;
  b=B8eGzVx2EScoEGMCYGRmbMe/Jm+5oqdPw41uhxNhQxrrngGX0Wt8DW/K
   m1Djhn0HMlaKLaZBnzhFIUsEtr0BN92oc/3F+jvIimdShEdkMxwinjGlG
   5A8gO6Hx/fBVSCiHoY1qjutu3Db4/OF/2oxNaoVVpz+Frqk1jgHk9kqIM
   ySvtyvOiztepQzgNI0YIkJWSegXni9g4wpTWrlA343PRC3Wgm4zv5Et5J
   dt8/joetpJl54ZCn8loU/zHj4r37msWDy+nFa5e8+knTV53IsgmDprc7S
   6yAy1Bdv5mzpLLrqDw18ew2ff1YWUpzffHXXC9LcNTUV5k3W2tK/v1RQ9
   A==;
X-CSE-ConnectionGUID: MMTad0DnQoKcBtGJxKoZOw==
X-CSE-MsgGUID: cdmPNmp/Qce+GrJzxrZfkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="70499549"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="70499549"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 10:31:36 -0700
X-CSE-ConnectionGUID: 2MrIEwNxSCCdMJZ/URV/mQ==
X-CSE-MsgGUID: 3mZPkTTMSnO0CfSX9Rig1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="170905575"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 10:31:36 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 10:31:35 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 2 Sep 2025 10:31:35 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.57)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 10:31:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HxgIWDTc6jf/uzpx+iAkjvKoY3xnFntDqnN94jSAjvfbKXl3omepZgn8+F/lTYKNNKqhQ2x2WAViqK7B1DeHu6qVCHYbobcp5dbqMBVGgl/bs8/hQ0IOmNp8uMSB3w9+W1XXZdh+RAmWtchWIHLP2ZkD2oNP5BGPeukdcy82EZ1Xh+YInfLk9m7UJGUa0rxkj90Xmvv7Ub3EKhOeTUr4cYQjXyjncFmvCpceNTyjZ4zkmBmv/JYyahRYA08xMKJ7I0MGsjx6To3ymorBOVLcLnOUAXiSH2E/wD7aauumRGe8IHydkz8n2KVj3ma1oZwaB/QJMfJrvqMzp3kGBEBprw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=svak9pNzFJSLp7nuPSq3ufwtMAkArOBls9D7uQAOCzM=;
 b=v6ysB5LqlISOEGVPSoWCSZ8FsZuue2egG124ulPDmcUlyFKk5Swv43r/YN/b2H4rv7Db0A3LC0ZUSI0HrbRx7sVyIwe0eot0e2Rl6+3QHizTY9vAiZmBPcxFdX46ZKgMzBrfPUt6qMlQKgEDO2EAQagX95GkpzLc1MdottfLstER02NQAwG0Yrhh6qL1fdj97O3MRf7cu/vCVwVeXsh4allwY0jBijJ1yOH0wJHL03PvTnEazEsrMJ1+QTB/5xgcPz1eflwu/j9gvSvPNsYpfuLscN8ctOfvPAJq4j91rvuM18SVL4Zoq1QxNcWLzpFwBnPfV5gXux123NtQXuLMHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB8468.namprd11.prod.outlook.com (2603:10b6:610:1ba::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 17:31:30 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9094.015; Tue, 2 Sep 2025
 17:31:30 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>
Subject: Re: [RFC PATCH v2 14/18] KVM: TDX: Fold tdx_sept_zap_private_spte()
 into tdx_sept_remove_private_spte()
Thread-Topic: [RFC PATCH v2 14/18] KVM: TDX: Fold tdx_sept_zap_private_spte()
 into tdx_sept_remove_private_spte()
Thread-Index: AQHcGHjWdWPgXm5ZckCYHTrSqBJUHrSALeOA
Date: Tue, 2 Sep 2025 17:31:30 +0000
Message-ID: <2befe2d7dbdaf369c00c4e946d4283096cc7ba3f.camel@intel.com>
References: <20250829000618.351013-1-seanjc@google.com>
	 <20250829000618.351013-15-seanjc@google.com>
In-Reply-To: <20250829000618.351013-15-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB8468:EE_
x-ms-office365-filtering-correlation-id: 425ddfdb-8b61-4f4d-a2e9-08ddea468dc6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?S0ZJUnpWUXltZmxHZmxtakptMlMwbDB0UGgzcnZPNGRzaCtJaE5qbFkzWFFx?=
 =?utf-8?B?VTk5YWo5U3IvdzB2ODhnSHo2UGU0OHAwR2NBYnQ3aTV6dFlXZmZBL1YxOHZ2?=
 =?utf-8?B?NVdwNlp3M0MxdWZ2STI4MUY1ZWhQVzk0QTJySVdLb2JGczh1MVBubFRERTdG?=
 =?utf-8?B?SllmWnI2MTM3aENZV1hyKzlOaU1UQ2FhS3VFbi96UW9sNjRJWkdxMTlYMk5n?=
 =?utf-8?B?bzgvcW5YQ3pWWDRjQng3ZE5yTE8xQnJuS1VOZmlwOUp6L0hjbFdZdXJqdlND?=
 =?utf-8?B?dENqVzN6M2V5bHo4M01FbTgzck1hUzF0SnZGQ1E1N29QUEJjdWI1cUNxd2Za?=
 =?utf-8?B?a0lqRWFNZytvaDVYelpqaE5LcDJjdG82aVdLRTlUTVhzRE5yejErU1kzSFJn?=
 =?utf-8?B?VjhKVkIySVo3dWlTWW55aS9ReFRtRUVWbkcvdHV1RVhWdmhEeCtkZ21iYzFy?=
 =?utf-8?B?TDlDVnJjd0xremVTVkR0eElaNFNQcVBxUm9GN3NGWEYxY0VuUFFId1Z0eXVU?=
 =?utf-8?B?Q2JSd1ZlazdZa0tNTC95MmJCL01lYmliNFUvRnRuVzJ2Qml6MS9tY0piZ1Bu?=
 =?utf-8?B?dEt6TXo0bkhsbDRpU1FrQzQxbGVRSjZWM2N0SjJRMkoxUHRYVTVJdG5uMDE0?=
 =?utf-8?B?NXExSlVXTGR3ZHpjYU1ta0hqd0piOTErVGplanZlNWhiQUVIbms0L2cyQTBz?=
 =?utf-8?B?UnBCU1lKYzYxcjY3dk5QOXpSMThEbnhZekxheUN2SGYwaFNxT29aTExOM2k0?=
 =?utf-8?B?TytTZHU5ZXpzV09wNnVwVThMWjlGTU8wTllaNzR3dnk5VnYvWXI3cW1XejNY?=
 =?utf-8?B?VTFtcVVlSVdaUTUyMDg5RUovT3pkaVptd0FHU0RFdjVrKzJhczNZaU83cXlF?=
 =?utf-8?B?QjdjVzhJdS9OY2YyWXRYWUhhcnJ6RTVXaU5GOHpJUjJ2L21CVTZ2bEtRSDFF?=
 =?utf-8?B?L04rSWloc2xTVnJrL3NZWUJHQ2hTeEF2dFVWY3k0UTlBalV5cDl5bmtGOGl2?=
 =?utf-8?B?ZTYxUFppWTRoS3lyL1Y1Qkc0OE50b0phZnZPTndrSTNOY3pCOHpXcm4yWkJT?=
 =?utf-8?B?QVBFcitvL2pESjlIV3BMUVNxaW1SUVUrUE8zWmxra3J6TnYwTkI2Vkl3SnNn?=
 =?utf-8?B?cnlKUTRiMmJSL2NFQ2hxbnY3V0FlVk43c3RzOUNxN2ZoazZqWDJNSTE3Z2Jp?=
 =?utf-8?B?OXlKMlJTa01sRXJ3MjlKQ3pDVEZXeWNScmhkWGZ0Q3Q5MGZQNkd0WDg0aTdE?=
 =?utf-8?B?Snkwam53NG9jMWZpTUZ3UWJjcmR3TUMwT2ZvVUtwRGRuVVJ0WUNYMzZGOWpn?=
 =?utf-8?B?WFJmN3cvNGpXZWx2bTkvaTNjSDdrNjRuQWwvNll2U2hocWJwY09yTkc4UktV?=
 =?utf-8?B?U3JoeWd2VUF1NnpJa3RKaHVJNWxRWXNLaGtJbkxPNUpsTUNaaHZ3UGM2b3g0?=
 =?utf-8?B?SkhLQ1kxcmpjcTU0ZklqWklQanV1ejFRbzNFWUVWdGs2Wm5DcTNNS0RQeXJM?=
 =?utf-8?B?a0M0b1U4NHIxbEFvRWdPQzdaUndoT09EMmsrUGw0VTRXWGNiZW1WUTNZV2pq?=
 =?utf-8?B?bDgwRUd1dGo0THEzeS9SYzRLc1FqSHlmUUVYL2gvVkIvL1dyUUp3SjhKRnBB?=
 =?utf-8?B?c1dkbThGT0ZNdXdlT3h5YW5RWXhUVGhka0s3aWdFU05wWHZqRkk5VnV0Si9K?=
 =?utf-8?B?NG4xWVhvK0pyNXdUNG9pMzF4VzdhdVlOdkIzVGxWbGZWVk5nU1lCdHAxVHR3?=
 =?utf-8?B?Z2ZDSUFwYzA3NzJhTVRLWE9HcFRrMFBLMEI1ZkVpMUJJUy96eUlTeHFVbnZm?=
 =?utf-8?B?emUwSUFIdndHN0IraGtQWUpUa21McGVzV1JUQXoyVHYwZ2ZOQmlWY0RCUVEr?=
 =?utf-8?B?SlJMazBJVjUxNFRXU1VTSzNkM2N4SVBDYW9BeWVsV3Q2S3g4VE5pRThMazla?=
 =?utf-8?B?RkVtZW13T1lSdUNHTjBLZlg0elVwOG1MRUszZklDWVUyQ25UYUY1VFMwWDVM?=
 =?utf-8?Q?uiQGnc4rW6tABfbfVxZ5gRQO0zisHg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L3ZaY0tnNENLV2ZoL3N0d05VclVMZlJjNUtoOFh4dWloOUZUWlFCcUpOWXJ2?=
 =?utf-8?B?Z2d4VnRZdDExT0ticVpNZGdURHBPRG0va1VubDdHRHZNNDRNYUxCSlpRdjdl?=
 =?utf-8?B?ZnF3eE8wWGozZnYxS28wd0R5eWo1TnJwbG00QWZxaC9aaDloMWo4ZXE4Q0h3?=
 =?utf-8?B?ZGdSTUxXaHdoY084U2kvbTRiMlQ0dU5USzdEVkV3RmlpeEVRSHhOaWplSTRX?=
 =?utf-8?B?NUZyR1FHaDUxcXVHck1TMUpoczc4bS9jRFp6NEZmWVJ2YXcvMDFjUEsyQ0V6?=
 =?utf-8?B?ZWlvdGduOHJPWk40SDZNeTVSWGJMUGRHZklBOGVlSHpUTkIvVW93VngxeVZT?=
 =?utf-8?B?YlJkUmpJTUdBL2gwSktqcWI0MjFsbldmZk1oUmt4U293elV4Q2h3NTNremc0?=
 =?utf-8?B?QXUwcVpTUVgwZWZUemN2Rlp2N3NuZUhBT3hiK1hQVkcybDVXdC85cEMwb2lW?=
 =?utf-8?B?OTVJM2dpa0tpaVYraWFROXVlaEtHeW9XVTg3Zm5tVFltM3M4eW1MRi9SMCtW?=
 =?utf-8?B?TDBsSTZNUGlWWHZZZlBvWWhCZUdIVUtkQVRwazVVKzVTemJDdUQ3dERtc08y?=
 =?utf-8?B?emhRSDVSR3I5MDVNeThSSWRoblFCTHdaeEl5RC9KQXRpOXpNRndkVUpuczZC?=
 =?utf-8?B?bDBCeStzSWdvOHRWUWFCK01CZzl3cnpDSFFDMG9iMlJJazFtVU9FMTF1cWcw?=
 =?utf-8?B?bmRJRG9BM3FOSGI5N3FyOFIvVTJ5M1Jpd3ZFTDY5cmVhbTJJTEo2dnZtd0Vk?=
 =?utf-8?B?Q21mK1pEVWZhcXpEMDdwc0FoWFluVzRqbEpSSzBLRVpSWmVaTFFhL0I4enhr?=
 =?utf-8?B?RWd4Z21nVlZWNFdCQms1ZkgwQ0ZpOU1hOGJvLzQ3cjBiVzdsaEg1ZmQwa0NI?=
 =?utf-8?B?Z3MrV0QvWUkrZlE3RDRmRkFrejlvMnFxdklhSkpab3BmclFKSVBNOU9xUUo3?=
 =?utf-8?B?NHIvTVZZd0txdkx3Q3R3bkNoTnVkRWFQZFl3VzBpWE4wNFZNVkRBSXU4UUdW?=
 =?utf-8?B?cUJLZEY0QkhMSFZqQkVMNndmNlo0NGQ2a0V4cGlzbm5LQ2gyZXUreXgvKzlO?=
 =?utf-8?B?UDFXWXQrN3JlejFqeWFrb3VFYkdFQ1BGOCtHckJZSDl4TU5YcGN6Wk1xdUN4?=
 =?utf-8?B?SkR0RmRDb0lCRGYzc2tWRTFjcUp5SnZwL3BwVE9hK2tKRlFFNWk3Z21uUFFt?=
 =?utf-8?B?YjRSZ3RtZ3A1eHd4MHA2K2RrclNXZTJMY3NIMFhUc1l3aHI2ZDFaSG1IY0VR?=
 =?utf-8?B?aVRwRXRnSWtrTjdzcFc4cWo2OXAxY2JnU3VqVmk1N3BTeE5nQ204Mmh3L1dX?=
 =?utf-8?B?dlIxM0V0aDRrUDA3TE9HT3REalhBTDJLV25kMmY5Mm9LZHRKcStQWXNEMHBM?=
 =?utf-8?B?U0pScVVHbFkxQnlYOWIwMlk3Y2ZZMHI1RmdTR2ZJU2pZRitkMTlLNEJ4L0Zm?=
 =?utf-8?B?Qkh0RUx0YjFZNkVOMVpVV1V1TzFoZUxLa0hnQXR0alhTTlZ4Z2pHZGFXcDMx?=
 =?utf-8?B?ZUNHbXc5enJ1enIyYVdoajlKaGV6VytNZWo1d3BNa2xkRFdnVDlHaEFIa1lh?=
 =?utf-8?B?SmhDVVVyMlhPc3JST3YwOTNZUzAxelVvS29heWwxOGJ4dlhzZ1FDK1djK3g1?=
 =?utf-8?B?L3RseUNLTXdoeGFTR2VxaS9QMkJPcE4xNlNvZGg2UGxEVHpNdlU5M2FtUW5z?=
 =?utf-8?B?UHo0R1g2QVlmV2VDUDJwUVg0dXhGMUVKVjFGU2J1Z0NKTXEyZHV2VXgwQk8r?=
 =?utf-8?B?OWtmNmNDemVaRFk3NzJGSENIN04zZkxOaTBib3M4Nm9paGwvbXFLNEQrY1lJ?=
 =?utf-8?B?R1lOazIxb0R0bU4venpINm85ZXhIUHA2RG5KUStpK0pDM1NXdDdEcDFiYitS?=
 =?utf-8?B?eGZESXlFOXhxWExZMEwxdklnaVBnUno4USs4dEMvbnRTOU1lR2pJRmtoZHRC?=
 =?utf-8?B?OUNDYlVJNHJ1U0s5dUFlMFpGa2hUenZ2SzBSeGJUYnBQYm5GVU1UOXpoT3BC?=
 =?utf-8?B?NDA0M0F5bHpGaVVrdDJuM2g4M1VZLzJQcjhwa1V2cUtxRjJjL1ZGdTIrWWdR?=
 =?utf-8?B?SFJkUUxzQnBoRGs2bGVCcWZrZk45b1ovUGtzUzZmNnVERHRmYzhFeWlLVUtX?=
 =?utf-8?B?NDRNMU1EeVphVlVKU0pZcWZLNXBCd0dtT3ZWdUpnczhSTXUzTFcvbVdKU3FC?=
 =?utf-8?B?WkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E74DFB710013B341AEA4A92718358804@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 425ddfdb-8b61-4f4d-a2e9-08ddea468dc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2025 17:31:30.3159
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H8U60kfQJVO0wT3944D47PxelpwgBGnFPK0DzXuJ8HOxSp83jUwpm/bIn/19i6LRl7lAlS+Zq701UqZfEReRvLJFSUYrX2zxNjXz3OeDgC4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8468
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTI4IGF0IDE3OjA2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBEbyBUREhfTUVNX1JBTkdFX0JMT0NLIGRpcmVjdGx5IGluIHRkeF9zZXB0X3JlbW92
ZV9wcml2YXRlX3NwdGUoKSBpbnN0ZWFkDQo+IG9mIHVzaW5nIGEgb25lLW9mZiBoZWxwZXIgbm93
IHRoYXQgdGhlIG5yX3ByZW1hcHBlZCB0cmFja2luZyBpcyBnb25lLg0KPiANCj4gT3Bwb3J0dW5p
c3RpY2FsbHkgZHJvcCB0aGUgV0FSTiBvbiBodWdlcGFnZXMsIHdoaWNoIHdhcyBkZWFkIGNvZGUg
KHNlZSB0aGUNCj4gS1ZNX0JVR19PTigpIGluIHRkeF9zZXB0X3JlbW92ZV9wcml2YXRlX3NwdGUo
KSkuDQo+IA0KPiBObyBmdW5jdGlvbmFsIGNoYW5nZSBpbnRlbmRlZC4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiAtLS0NCg0K
QW5kIGNsZWFudXAgc3RyYW5nZSByZXN1bHRhbnQgcmV0dXJuIGVycm9yIHZhbHVlIHNlbWFudGlj
cyBmcm9tIHRoZSByZW1vdmFsIG9mDQpucl9wcmVtYXBwZWQuDQoNClJldmlld2VkLWJ5OiBSaWNr
IEVkZ2Vjb21iZSA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+DQo=

