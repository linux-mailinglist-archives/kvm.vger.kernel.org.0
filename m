Return-Path: <kvm+bounces-19150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5935901916
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 03:07:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40E98281ED8
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 01:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AB771C3E;
	Mon, 10 Jun 2024 01:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QhzTaiTK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B4B15A8;
	Mon, 10 Jun 2024 01:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717981620; cv=fail; b=TSfhlR2SrY7zqlLCXVD6LaHqSWEpNH+UOrwbwbQpj/0rM+JLmS0K41V7m6ndMBAGwV918ZLPV5GYw+doL/IDd+bNwI4Ff/weiA3ZKn3tTeTIZ+SZhO49OXjEzhh1ecTWOS3uoUZpgYXX6W8XQ4jBPVJC/AY55KMahfJse8pXrng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717981620; c=relaxed/simple;
	bh=EOOD0/Seq9OisrSKwEf8JyOCulDUjgl2Sr2PIyz1iOc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aWZYoG3BD2Fv/7RI/phaeNVgy6FpU+Syoht/8uMe1G0g0sJkFRAi/gkfn9pkFPbaiA+fSjJD3wX8DTmPCJlQ96jiKA6vdbY+8d/pYXcbi+MFEfZfrezun6Hddju7TdfZgdzytLdgYR0rgPDZVn6rIjB99Q53wQpkie4fPv5aFpY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QhzTaiTK; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717981619; x=1749517619;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EOOD0/Seq9OisrSKwEf8JyOCulDUjgl2Sr2PIyz1iOc=;
  b=QhzTaiTKkcBvY6OPxuCi0Y2PGJqSB+aSKPX7Vre88oPOk3gLpQ9mBs9b
   SF7qHXCHCJSnvqwmbI13RyQbx/Xfr444M5MCipPdT644m8JAHNtVCSlIS
   hBa8LLM6acoNlqD6zNjdatV/qABaXpktX3dWjqEbf6Sw4Cs2dgmP4o+Ej
   n88yykBDc1gd24jaBVQNuwiFnmrhhrq4FGqUE611GhcyFsgzMS+3e20yk
   FsBeSheuA7Gdd/kISJXn47NL4Q4u4r9FYADsd5r6k6VC/Q5fiIIkhki80
   wObUDCSN3ojBhJeNnx+HRLM2HjHvVJx//c3hbthr5MwcY4poJDVha9JOH
   Q==;
X-CSE-ConnectionGUID: xy9Xe+yxS2+uEoYxXqoSyA==
X-CSE-MsgGUID: sSqXGMC6QA60ReWad0YOsg==
X-IronPort-AV: E=McAfee;i="6600,9927,11098"; a="14582671"
X-IronPort-AV: E=Sophos;i="6.08,226,1712646000"; 
   d="scan'208";a="14582671"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2024 18:06:59 -0700
X-CSE-ConnectionGUID: HbzPp2ydRuKgDqWnyy3UVA==
X-CSE-MsgGUID: 3C7KIZuKRvKRzTn+z/Urmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,226,1712646000"; 
   d="scan'208";a="38833824"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Jun 2024 18:06:59 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 9 Jun 2024 18:06:57 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 9 Jun 2024 18:06:57 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 9 Jun 2024 18:06:57 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 9 Jun 2024 18:06:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJnLhSyZ9pG4BazYGAVR99kqIn9jP4HfWG/pBTLhnDvbqHOa/2Wy0mB5C3r7GEwddw+CMMjt1kxPtafGtMvkoCuNvXNTl9DN2HOwOKDAFaEG1lc/iC+zvigXb0DNIbie2FskQ+PKbScZ9MUHJo5FjzoE6vUxtkfGOOkOd17OwnvRHaUXQfnevzUEzCJ4NYTvLkFNSJEeArUTpusske9doglvti1rl7dIugbFZW+pt791ReFL1JakO+5LSIwXl4cJiS6jHfnw/X4XvMQX2FBt0wVlfkWJB7FnXlawSUEClkRI96vwD7CX+DQXlbgHT3UkllS90PTwjbuBrapWtyLdWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EOOD0/Seq9OisrSKwEf8JyOCulDUjgl2Sr2PIyz1iOc=;
 b=Rx0Wcj8PvICz+z2bnOJDaYR7Da2qkw7dppfSaTHRXf/XSL5+2A7xOtj+3Cpsr4A//aRifLkR99Qpa+rp8TvgP+Ne2dMZrKu21dhu2Ye4K66AprhuNu12pih8+1n9NaBGkZX9xxKJCc/sobhNlRt/MYt5E5MsBA+wZgqWWDeO3b6fVIxTlcS/EpU/L0uM7fr4NsKwaO77FNdWVkC6Pp6r1lYAJj6ywpSp4gshJ21XZMF+h3Kuh71j3JtyqY3LdpUrTXEM8WEpgR95pY20QQK1Lg+KsCv+ILaFL3AvwSO3hPOVWxSFNS2DjSC1SqWrxlDDnhp7Th41zoU8jxBDblCXjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB6781.namprd11.prod.outlook.com (2603:10b6:806:25d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Mon, 10 Jun
 2024 01:06:52 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7633.021; Mon, 10 Jun 2024
 01:06:52 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dmatlack@google.com"
	<dmatlack@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v2 13/15] KVM: x86/tdp_mmu: Make mmu notifier callbacks to
 check kvm_process
Thread-Topic: [PATCH v2 13/15] KVM: x86/tdp_mmu: Make mmu notifier callbacks
 to check kvm_process
Thread-Index: AQHastVsvIokCAHBf0eqTex6Vdas6bG8C5UAgADeRoCAALk1AIACnDiA
Date: Mon, 10 Jun 2024 01:06:52 +0000
Message-ID: <65f7f051e541e4d0dbbacb22ad48a11f8696e33b.camel@intel.com>
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
	 <20240530210714.364118-14-rick.p.edgecombe@intel.com>
	 <CABgObfanTZADEEsWwvc5vNHxHSqjazh33DBr2tgu1ywAS6c1Sw@mail.gmail.com>
	 <ffddbc64ddfbf1256b79336864c2203d81df4448.camel@intel.com>
	 <CABgObfbySgLD5V2Si9gURoPfzYrR8n1DSDB16o24MfBwSsusTQ@mail.gmail.com>
In-Reply-To: <CABgObfbySgLD5V2Si9gURoPfzYrR8n1DSDB16o24MfBwSsusTQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB6781:EE_
x-ms-office365-filtering-correlation-id: 4ad1f2fe-079e-41cd-f21d-08dc88e99cef
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?YUNhOTNvUGN6Z2YzRUJRNlVXMGg5cUtDd3Y4MSt3NHFJT2VxNDFkeW1Ic1Nx?=
 =?utf-8?B?R1hEMjF4Qnhub0pDUXV6clRRNU5IUFQwK0NubUY4ZlpGejBianprbnZ4a1J0?=
 =?utf-8?B?S0hrbUlXUnNiYkRRa3QzNTMrVmlBV0JkZm9BdHRzSnRCcHdRcVJxQzlpbEts?=
 =?utf-8?B?MzZIeGNwdFRaejlyMUJHaEtNNHRUcDdkODJLUTQrbGdpQjBWMG1JUFpSSDBT?=
 =?utf-8?B?Qm1hT0wrcmZBeGdUQkp0VDJtbk5yNjlmd2I5MGsralF4cDBTUTFUVEFHSEdu?=
 =?utf-8?B?Z2NjRnozT29NV0RmL1Q5NmZXZ3p6YWJLS2dsSWdtbkMwSSswRUt0d2FYR0VC?=
 =?utf-8?B?b1k5d21ERXd6aTZYNU4zdGlvYmVTMWJPczVCakhjdkFKcXp1Ni81OE5ScXdB?=
 =?utf-8?B?TzBQczNrNzlaQWs4YUNmUk92MUQvYndIb0xtcFV1eG1WTms3ck9kWlB0Rmp1?=
 =?utf-8?B?K1VDaWphVWFDckxRRGxoMi94WTh6ZjBoME5ndllIdWlyQWlWeXVsWVhJVlVk?=
 =?utf-8?B?ZW96OWhvTkd4djAzcnF3eDdybVFTVnY3SzJ3NWNxQmdkSVhuRHppUDdvN0xJ?=
 =?utf-8?B?SStydlcxSkNydFAvMTVWRCtwVGxUek9uMUo3MUpvSC91NitsZVBTQUNNcEl2?=
 =?utf-8?B?TSs5TXg4NWc2TDZUS0kwRVozQlorOUh0bXI4bEwwNXRCSk1IUWgrdEdvU2xu?=
 =?utf-8?B?SlhyalJzUkc3MmJqRnhGMEI4UkxnUE83dkdWNXBVZXNzTzV6WllWR2xmaGFj?=
 =?utf-8?B?TCtRMzduUFhuMnVWM3VtZnpYZXAwMnVHd2tpUDRUY0IwK0hJNVlSZUpGMDB2?=
 =?utf-8?B?MDRpbnU5ZkEyZUpWRUhCbTY2Qm40bjJHZVdQdUFlcXZoMy95cjRZNkl4c24v?=
 =?utf-8?B?ajIvTC9oc3ZpRERHajFoNGRQZzlvUW5FS0R6UDIwaXgvL2QvSld5blI0ZVNm?=
 =?utf-8?B?ZkpYNDJxSGIwRkxtQUwyOFRaUEl6OUVjTmRuWjVEdlBncWx6YzNtVksxNVQ5?=
 =?utf-8?B?VkNPQXVmN0NJWEQ4M21renhNWVBCSlNUbHNocDYwWGNNS1NQSWJEU2lvOE9C?=
 =?utf-8?B?OHI3cjFyekhzSEt2aXM5bUN0TDRzejk0bHVxZXlQdXhMNzFBWjlVcm5CU2lY?=
 =?utf-8?B?VXVjNWFuOU11L1ByVCtwZ0pzQ2hGNzVjTSt1T0VCMTVCajA5RzF0TTVHOVE5?=
 =?utf-8?B?ZmlzYUFzbGhQWHlYU21VVmRFVXI2eGt6SVpZSnIvK0szc2c5V1VoQWNiUEx1?=
 =?utf-8?B?a2tJNWkrUmlGcEVRWEh6Q3BmMkdKZjZKemhhbEdVVkZuaElaTVBMVHg2dGF1?=
 =?utf-8?B?eU5POFkvVFNhZ3ZueU9OVVRMTWZyL3A3M1lTZUxXNHhiSnBSOWwwVnVpK2k0?=
 =?utf-8?B?VVQydVI0K1ZYaVZqaWp0SERVQVllZWJtZ3Q2d1l2V3BXWmcyeTlxa0t5K0lL?=
 =?utf-8?B?OTQ5S1U1aXBnZFJha0lTMUZSUTlZQzhhV1c4M2o3VnQvU3J1QTZlbitNU2xI?=
 =?utf-8?B?SXZyWVdDQjVDYmJJcFFmcG81cm1VcC96MTJTazZuWnVUeVRRcmhyNm1oaGNa?=
 =?utf-8?B?Qk1ucytQcTVTMXhtUXNVTWd3RzE3SlZleXZWZEFuQ3ZzcWhVWnc2MUFiL1Bs?=
 =?utf-8?B?SElaend2WXA0QnNQL0RXcUJDWHBTMTMwMVZ3eVhWaFNCbUc1UFlCTC9xZUYx?=
 =?utf-8?B?akZTbFpOQU03aU1FZUdMTWU3dzExLzRzZjdka0xsYWJ5OG5jSmZUWjRLaStG?=
 =?utf-8?B?aHB6dyt0Vy9tUVlEQ1d2djg2aDBMcDNRamxpZFhsWkt5OGIyZ25sckM4bElv?=
 =?utf-8?Q?qNZiSrhe9FBm1deKVu0NTmr0vfWz6qkHUDhTQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dHVmWDdtMkxZMUJPa1B0elJGNEt5b2hpd3Z2cnFCbUpWQllVL043Nm84RjQr?=
 =?utf-8?B?cFJtRTZpZmVtenVxemtmZ2NndTgxQXd4Y1RYNnEvZGszS1YvZk4zODJlMitO?=
 =?utf-8?B?blFldFNkL1dFY0x1cnhlZGM0M1NpNit3YjdOQ09YODIvTmdVQUN6OGdJbmZG?=
 =?utf-8?B?eGd6NG82M0tWd1VDMXpvM2JZbllwOS9lRWJUZERMWjdDZk9GUnBOb0dJWFVj?=
 =?utf-8?B?NTN3d3RCcVljbUM2dUZOeFR0YTYwd1RFNFVUYmxqQkxzU29uWmRGdUhmSEVm?=
 =?utf-8?B?TGhHa21VWlEvSjNucUdrbzcyUmRXVGh2TkFHRXowbjk5SldHU0pkYTYzY0k1?=
 =?utf-8?B?T0pNbFRoS0h2ZjZCUC9KSU9KeXZqekFwWEFvZzF1cWF1V1RhWG9sendpai9l?=
 =?utf-8?B?QmQzMjNIT01XZzRxeHlWeE9qOE5XTFU1cFFOOXlQT2RXQU8rZk01dkxHd3g4?=
 =?utf-8?B?NEMvcEJkbzJJdTNPN3g3VEhtczFXMXZDVnZYMDhWVmNlWGU4Qkp0Y3U3Tlh3?=
 =?utf-8?B?bnZBZG15N1dYRDJyakFDNzN3cWdiWWNyMU9lNjZZdDZKa3dHWWVyWFU0RWFy?=
 =?utf-8?B?UFFBQm0zN1dOY3R3N0pLdnZ3cUkxK1NJemNRMVM3NjRNTEV1MXIveWJhc0VP?=
 =?utf-8?B?MWtTQi8rSGNYVVk5WlhPVlFUcDZESjRzOGp6RStlTnNPUFFRUDRRWnNmeDNJ?=
 =?utf-8?B?ODFMRElYT1ZmTnozeWt1TmQyallnUGRkTUFncEdqZ3NWKzd6cGtMLzJTZU40?=
 =?utf-8?B?akRNeUJZbXJuNFY4K0xRU0w1d0hDbnBuNHg2VWRvc29oSEw1RXIybi9JSGta?=
 =?utf-8?B?cFd5ZnE2Z2s0Z0N2QThhUGduT29pNEMwWm8veVliaGJaYytDK0J4YzJBNlVz?=
 =?utf-8?B?WGt2aVR1WllYMFhVZnd3emZzTHdSUGw4andsaVJXSlFSRzZ0d0tRNW9xZHFF?=
 =?utf-8?B?SVBMN2VmTVlSSGJiYVBUSlc2UDRPUHZpc1JJRVUxQ1hBUGhUZ3pBQjFMMnR4?=
 =?utf-8?B?ZG1Hb0VQellCcHh0eVNRNUdEa3M4YkJMQWsycUwvdTBsYnNteTdmUEk2TjQ0?=
 =?utf-8?B?TXdNRU9US0xqNC9HN1hscGMyckxwb3YvZG84OU8zTS8rd3hZRUx3dXRsd1Jr?=
 =?utf-8?B?U0RQSTM1TTJSZ0t5ekhXbjd2WVJoMjFMeXh3bFhOTGlyMmJXWXpSNWRhZHcx?=
 =?utf-8?B?YU5kQ0NrWkQ1TEcwVWdUd1YyVU9Fak50TlBKQ0JRSkVub0tlUkIrWTlaK1Qz?=
 =?utf-8?B?bDY5cFZiUTJZZ0pJYTl0UStjNGZZTjV5RHlMa3lJR2lqMmQ3MkN6OFlxNmlX?=
 =?utf-8?B?SlpMSmZ4ckprWjdWVlpNRUh0UVh0Nmp1TWwrc0E3c3ZaZExHQ1RPRnp0NFV3?=
 =?utf-8?B?S3FEcjgxSUloNkdsN3RiU0EwNS9VNHREdzREV3ZpeWNvRHJvaTJKWENXL3V4?=
 =?utf-8?B?a1MxdDEvZWxudkFBckJEZkVteFM3QWV6dTNmdGZjelJVbGVtKzdiYncrZUVo?=
 =?utf-8?B?NW54dEpwWDR3MVM0SnBKRXBLdkdGSGlGZ254MitZREFJUGdFeHNTRTZsVVJ1?=
 =?utf-8?B?KzkwZnlpTW4xWG1xaFdEbzkzQ1dwTjUzYy9pYjJvMzQwNElKNk1oNkpzbEx3?=
 =?utf-8?B?QlVaNFRGR24zeGJNcE1hQVRMeUMvZmtWc0IyRHpkYkZTUW53TTRnOTJFbkkr?=
 =?utf-8?B?VDFnMnJmV3lTaGQxUGM5M0hDRmd1bmtENW5WWFdxaS9CTnVMTjZ6VGo5SnVa?=
 =?utf-8?B?eEJVNVVLUEhUQTgxU2xTbWlVSXBmZjdLOGFKclorUVdEMGVRSkhpYjA4QXRD?=
 =?utf-8?B?djd0bGxqOGwwRElUMmRVd0hSTmVKcmRtOUpaV2g1RlF0ZXNncUlYMGUvVUFk?=
 =?utf-8?B?T1plWWEzcU1NZ05IOTROUmQzRHJabXZjZklHRlhVdkE0bStrK3dHNkZMR3BT?=
 =?utf-8?B?OGFxdVczTGxSK3UwWG5VSmMybVR0eDZGcFAxUnViaG9VeFNRdWRRbFNwdW1z?=
 =?utf-8?B?cVprQi9PSTZ6S2xEZitnSXpreWtNZGJ3Yld4dElyYWNSUUlMRmFyZFFGMlBl?=
 =?utf-8?B?VUNqcGpRYlM3YUpVMXJzUDVEZ1NkbkJlWHY0eW9jakdGRzRUcytkTStia3RB?=
 =?utf-8?B?Ny9TSHh6aEQ3UlhmSk54STlzZkgwa0FRZGgyc0pycjYwRENPOWJmZWZVRTlj?=
 =?utf-8?B?bmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <00CB1E50D2A28C40B6DF4906E3D3B333@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ad1f2fe-079e-41cd-f21d-08dc88e99cef
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2024 01:06:52.1101
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2UvNbCmEF+OjvyzmeQ8ffSl1k2piEBZUDdXTOeBFtZpwqCN7BT2NHgz4IKsvdHR40qi7YlP6ukU8FO8r2Yg0Tex9v4KoiW5H6IGoTAbXeH8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6781
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDI0LTA2LTA4IGF0IDExOjE1ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiA+IEFncmVlICdwcm9jZXNzJyBzdGlja3Mgb3V0LiBTb21laG93IGhhdmluZyBhdHRyX2ZpbHRl
ciBhbmQgYXJncy5hdHRyaWJ1dGVzDQo+ID4gaW4NCj4gPiB0aGUgc2FtZSBzdHJ1Y3QgZmVlbHMg
YSBiaXQgd3JvbmcuIE5vdCB0aGF0IHByb2Nlc3Mgd2FzIGEgbG90IGJldHRlci4NCj4gPiANCj4g
PiBJIGd1ZXNzIGF0dHJfZmlsdGVyIGlzIG1vcmUgYWJvdXQgYWxpYXMgcmFuZ2VzLCBhbmQgYXJn
cy5hdHRyaWJ1dGUgaXMgbW9yZQ0KPiA+IGFib3V0DQo+ID4gY29udmVyc2lvbiB0byB2YXJpb3Vz
IHR5cGVzIG9mIG1lbW9yeSAocHJpdmF0ZSwgc2hhcmVkIGFuZCBpZGVhcyBvZiBvdGhlcg0KPiA+
IHR5cGVzDQo+ID4gSSBndWVzcykuIEJ1dCBzaW5jZSB0b2RheSB3ZSBvbmx5IGhhdmUgcHJpdmF0
ZSBhbmQgc2hhcmVkLCBJIHdvbmRlciBpZiB0aGVyZQ0KPiA+IGlzDQo+ID4gc29tZSB3YXkgdG8g
Y29tYmluZSB0aGVtIHdpdGhpbiBzdHJ1Y3Qga3ZtX2dmbl9yYW5nZT8gSSd2ZSBub3QgdGhvdWdo
dCB0aGlzDQo+ID4gYWxsDQo+ID4gdGhlIHdheSB0aHJvdWdoLg0KPiANCj4gSSB0aGluayBpdCdz
IGJldHRlciB0aGF0IHRoZXkgc3RheSBzZXBhcmF0ZS4gT25lIGlzIGFuIGFyZ3VtZW50DQo+IChh
cmdzLmF0dHJpYnV0ZSksIHRoZSBvdGhlciBpcyBub3QsIGl0IHNob3VsZCBiZSBjbGVhciBlbm91
Z2guDQoNCk9rLCB5ZWEuIExvb2tpbmcgYXQgdGhpcyBtb3JlLCBpdCBtYWtlcyBzZW5zZS4NCg==

