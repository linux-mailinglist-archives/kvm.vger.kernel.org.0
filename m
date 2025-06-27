Return-Path: <kvm+bounces-50926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 64DF5AEABD1
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 02:40:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1B5F27A87E9
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 00:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFA3D13AC1;
	Fri, 27 Jun 2025 00:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VrFtAWv/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BCC2F4A;
	Fri, 27 Jun 2025 00:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750984833; cv=fail; b=YDO+OnI+2K+SanLcTYtzfPk/OLkEuMZOj3Q643rokQLOruhkGmJndKdTWJgIp9QFm5pb6GcBd0T8xy1vavRn2NTBBEzYVryU4+agvPDqbJkSj6r0QC0AShxaZDtX5Nk7IukaPJz/5cwOGGUPuV70ii3bY0MmMA2+CLn0Yk13yq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750984833; c=relaxed/simple;
	bh=biSLO6LFD2uBMivYFgwORmX9+pfIDq3MOGAu8tVEBNM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sXDXqgyC7dSmbYepCSxV1raV+Xn7YxqUEJvWdY8sNcae/7kmDF3NcorcQEOw7U5Ox4bX53SVW+FTOJSUSMuAeNgYH874R8DfF+ZDAHnwmMoMuSq9F+pd5aFWDKoLkcPVWR5e0MVDKFALZshWVPm4VETHV9v3387oMz45b2cSV/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VrFtAWv/; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750984831; x=1782520831;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=biSLO6LFD2uBMivYFgwORmX9+pfIDq3MOGAu8tVEBNM=;
  b=VrFtAWv/f3Nw8YIqS9qnlHP6OUJYNwb0NfiVnOci4A6QmdSAUCYPx9/a
   40IXE3kZRVkvBvAGZQHQOzHpnTLJfuIaMcBP2E3Cq4xi4LTHZ+jDmag+z
   lro4CsfvQBxP0ydRvU/GwQv1iOwA1HApIfIcfRVxBntP6p+KIW5Ul0K7g
   ONloSW8gS/FuD3rRgLuYyrZWurziTHomu+D2wVRFOnSMYT2Xu6Q429BvJ
   dZrxyi8MfLZw67Ree438GfxPe5FKrF0a+0coy2jV0rBwhVopDAv/OEu/Q
   Kd0CjZOBWGeCXcRnhVGDOK9DkEd69n9oKrtpGWU9SMR8N1+mC3wY7HZZD
   w==;
X-CSE-ConnectionGUID: 6hxFCNFoQGWrdKBhOADqsA==
X-CSE-MsgGUID: 3th+4d64T8uqRLUOX4hrEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="57102997"
X-IronPort-AV: E=Sophos;i="6.16,269,1744095600"; 
   d="scan'208";a="57102997"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 17:40:30 -0700
X-CSE-ConnectionGUID: OddAWLQrQo+avTIAAmCvDw==
X-CSE-MsgGUID: XajzHKxnQgenK5KeWND1rQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,269,1744095600"; 
   d="scan'208";a="152187390"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 17:40:30 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 17:40:29 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 26 Jun 2025 17:40:29 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.50)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 17:40:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OB7pz7ym9hPqyEegvTz2vcihrX8l12Dc6cCx0+lf7B13ABTmVWFOhWoVtTEBR/L+R/dYg3VgFHoAMeezT10AyoDnLWO2Wu4uxV0sCwn14QwNKVMLzxvhf3JNWJzqq25XxZFLyerjDSivHkp8AjN2K2uEh3Kxn7YJuG9rlaE8qthxfqa50F1LZ0Di9c6B8zBy9CYC2kDZKZg/9G+8v7hs7zbboFmribb5L1UAWjnSkKLgenPqlqZFfnxNvfXNhL6xgiDQjj0OmnXDLcgHYg8QzgVcq5yMy9Swz/t1aEC9sNoRijyVrEwBQtaGAD02+gN7+/NwEvqdY13BPHGh1eyg6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=biSLO6LFD2uBMivYFgwORmX9+pfIDq3MOGAu8tVEBNM=;
 b=W14sYcAAKIca0ivpxbcxBz1jcviAM7LfURh3wSpwXLR1JDgLEmZsJ9wjA/UUbM9ACOTxbjxMrKyKJ+SS9mp2vk4RXgNL6/PL5TB8SxTuNocmRsB7gUHdF61+vCA7vfty2nNGmu+xHuqhJnesAw1m5KvWqw7qyMGkU5Ax6XAECjfmEabLQvR0tN7pz7+6XYPnmHKRrBcFIWVtcQCqGwOagXbfSBwkoO1+jRqTdoc38DpeHRVBYrjj1b7Qp+Ln8xHPxkvP8ZBlQwIEdafqmK+a0vO3c1dt7vbR1Oo1on7dyafagV66D9Z8abvxmm4l+1W04DdS5I8Azy7i9vwozfZ+ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB6960.namprd11.prod.outlook.com (2603:10b6:303:226::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Fri, 27 Jun
 2025 00:39:55 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Fri, 27 Jun 2025
 00:39:55 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"Huang, Kai" <kai.huang@intel.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>
CC: "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org"
	<x86@kernel.org>, "sagis@google.com" <sagis@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>
Subject: Re: [PATCH v3 1/6] x86/sme: Use percpu boolean to control wbinvd
 during kexec
Thread-Topic: [PATCH v3 1/6] x86/sme: Use percpu boolean to control wbinvd
 during kexec
Thread-Index: AQHb5ogHnrnjyvYK5UawKKchMn8Ng7QVuv8AgABvVoCAAACaAA==
Date: Fri, 27 Jun 2025 00:39:55 +0000
Message-ID: <4b752f2bd492be6deaa681f04303cdb57d2a3c91.camel@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
	 <b963fcd60abe26c7ec5dc20b42f1a2ebbcc72397.1750934177.git.kai.huang@intel.com>
	 <ffcb59ff61de9b3189cf1f1cc2f331c5d0b54170.camel@intel.com>
	 <065b56f9743a18aa1866153a146a18b46df9ef8f.camel@intel.com>
In-Reply-To: <065b56f9743a18aa1866153a146a18b46df9ef8f.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB6960:EE_
x-ms-office365-filtering-correlation-id: e7c39bd9-1e15-46f7-1473-08ddb5132309
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?ZjdSU3l6a3Bhd09rUWpnWi90dEdEWFpjak9vaUVzSFVwZmZNWGsvUjRzVlZy?=
 =?utf-8?B?a3Jja056ZTNQMmo2R2hJU0ZxUDBoMjFFOFBCWUlDQTVBTmFFdWRFSXQrb2VE?=
 =?utf-8?B?VWlPUkk2dEZ6dDdIdGErOS83dGttT01sajlIWnp4ZEhNSGxiV25NdzlTSit6?=
 =?utf-8?B?Um4wcVY5N3IyWUNVN2ZickVJNDZoTmVZUkNKMDhyOU1YVk1xTWc4c2Y3OUhC?=
 =?utf-8?B?cGNKdzFyaWM0MWxpYmZDMk1FOWt1czhNRXB2dU1POVIvSGY0bGxDYnk4NDA3?=
 =?utf-8?B?czFOWTBZRWd2QjBkMEpzWTFoc1dYL0VFd2ZWcnJab0twdmRMeFFrVnV3S3RD?=
 =?utf-8?B?c29qRW43OWxBdm1kNEZHWmtCaVpvQ1dCN2NCRHA0UVkzdW93VHozZk5MSTdD?=
 =?utf-8?B?ZUcwKzlwbW9MV2MzeTNMOVRNL2pXQmxvdDA1VThYQ3BNYVJMWThvTEFYVThC?=
 =?utf-8?B?TFVqT0NBTWU1UmpyRDRFVk4yMVl6ZXRoYzhNc2hiZHRlU09WVnFqdDdzYTBk?=
 =?utf-8?B?b1lmTFd0OThEaGFHNUl6d0VRNlJXSStsTlQ1RDk5NG5TLzFNVTdiMEV1cjdl?=
 =?utf-8?B?UTdIY29IaE10NWRHWkdDVFdoNWNQdk5qVzJiQkgvU3lwNnlqcHJ4YUlrS21j?=
 =?utf-8?B?MWVTOHlzSFZibUFXQkJ0L05KT3Y0TTRHdnJDRCt4NlUzVm9xaXRIQnNQdnIx?=
 =?utf-8?B?YlJhek5YYVlSU2MycmlwWm5LSHhNWTJWVzVSZ2dLRkFSbkMyelRSS0RsTUxo?=
 =?utf-8?B?amxHdlZ0aHlMcm82K2lUYzZ5Yy81MmRRN1hjMDUvZXB1VjBlREpMelhteC81?=
 =?utf-8?B?RFJuS1dvNDJXVlZyWmtieWVia0NKbjZKZE1LMEhiT1NEQUxHV2FaTHdSYmNV?=
 =?utf-8?B?L1ZrOTE3VlU1RFJaTTF3T1ZvZ2xGK2tVOStxWlFvei9wWmlTZE1DenI1ZzBl?=
 =?utf-8?B?MVlZOUZWNmcvcjJkZGtBUGdOSUNpTUFvQVhqZkR5VjRUL3JoMEdKb3hGSWJT?=
 =?utf-8?B?L0Q0NFlLbUVtZEozdjc1Z1Z0MDlNRXNWZ0hIdGVPbWpKN1hWWTU2c2hCY24x?=
 =?utf-8?B?WG82M0p1eDh6VDIvOWdrdFV4Wk5PZ2NTdTZRYnJ1Tk5hTHBOZkE0eDJ5dFpG?=
 =?utf-8?B?blVYcUphZW1VR2pMbE51LzJhb3N4RmJSanIvem9BcjhOeERsT3JocFNpU0dV?=
 =?utf-8?B?b3JzcFd4TTA1dHhqUXl6cXljSVYxdWdKV0dKRzVNdzdiU0ljZUZ5bHJrT1NW?=
 =?utf-8?B?WTdqQjRDcVNGZXdqd1hOQ3kwMVlrM3hxQmExMm9oeVE5aFl4dTdQRFFKM05B?=
 =?utf-8?B?TUdqMzd0MnRuMVRCMnJsWmNPUUR4NDdNTHFVWHc5bnZFaXQxMU9kNDQySjgy?=
 =?utf-8?B?M09nV3htQnlaVmxrWUFxaTR6NTR2YUdqMjNIdlFkRlllMHdnSDBPZ1VuWHJ5?=
 =?utf-8?B?OU9QWWFaL1ZpQzJZYmtDUTRXNVBnMVBDTTJadzlBQnh1WG96L0FObDExOVRn?=
 =?utf-8?B?UGF4d2hoNkdEN1dtWnkrTDRUSFYyU29UTUdaRTNKVW9Hd3VSYzRGRmlFS1Ur?=
 =?utf-8?B?TWwxUGZMclp0dFVXOTBmaHZDRVB4SkxrbG41T0ovOHZ1RXdsemFGeHVzL0FG?=
 =?utf-8?B?b1BULzhHL0NuQk12NHJzMUc0dHdYeEI0VkVFK0Z4WExyWFNPcFNhbVBISzRO?=
 =?utf-8?B?Slp3NEZrOXFEOE4zb0RiM1JUQXYvYW5PNzlBeXRhaTVsV1VnK25qVzg2b0dJ?=
 =?utf-8?B?VW9rREZqd21GRUlVbG5tQk55aFJ5TW9obUx2bTJicTEyTi9ueStqbXc1djEz?=
 =?utf-8?B?dWRJTjFJTlIvM1RRekVLQjFtVnJId0ZTc250SkVjOW9mWmMvMEhnbUozWmp4?=
 =?utf-8?B?WTl0N2x2ZFFyTDBQKzBKdXdXUlhpYmdtTFJRRXoxbExQeVdhQllPUkkzZEdl?=
 =?utf-8?B?aXRBTFNZcU8zOEYwTGVYeHBrYzJiT2RESElzc2xMVTByQytlVW5sV2JaQXNt?=
 =?utf-8?Q?9j5SpiFzNBkW/PzWY8VzV74+w0pbjc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aTJnWUo4VFgwOGx5VnJBSklWRnp6YStDN1NZVGZtRTMrUmFPbTk5cDEvcENI?=
 =?utf-8?B?VDVXK2kwZWdFVjYvbk9vQXdYL0Y4RDdlWTlvQ1RDTzBOY3R2dVFiaHA3dE9E?=
 =?utf-8?B?V3NoTnlwUzF3MXpJMWozSkZkT05BbU0zWDdDNWNDOUllaUFJM0xSeUt4WFpK?=
 =?utf-8?B?RTQwSWdBOFdLZWlpY2tGeTliT0VTZXg4NlU1S0duWlRCQmpab2lhT1hMeHNp?=
 =?utf-8?B?enlzN3JsZlZhSGd2OFUzWm9nTEFoWFlmSTJzMmF4c3A5ZDZTa2Q2ei8yWWJl?=
 =?utf-8?B?aUFiKytaaFBnSWJDNTdmamIvU0lGaXJJdDkrKzh5VWdjbkZ4N1YyL1Q2ZGxx?=
 =?utf-8?B?clEyUWxRU3FEdjhPNlBqY0IvWFdFQ1RuSmIxVGUrbTZwQlRMVlZValJVTVc3?=
 =?utf-8?B?TUFNRjRGV2VvNFdkT3pLREt6UnZRYnJXTWQ4VW5WOU9MY3lVV1FZbVZEajFl?=
 =?utf-8?B?Z085OXh5UzlHMGlseG5KQ01oNjNUVW50M3ArbHB4bmJpMWhwNmQyNWNIaStC?=
 =?utf-8?B?LzZTeDBhNmxDNGUzZzBjUHpsR05nbk1HdldxT3lJdDVHQkhvdzd2aDh6UDVy?=
 =?utf-8?B?cW84T1hMdURDeVpPN0kvWlA0cTlnUW5oVjNiUEZRZlM4NHpJbm03YWlvRmpK?=
 =?utf-8?B?SWhFMjlGTWhyTE1tM1J3Ym9UbXpWeDZKRjVoSWF6NDhxRW1EMnN4ZUFsdFRy?=
 =?utf-8?B?RkdiN1hWZlZud2ZMQTR1ZnBzdzFoYjBNT1RyWk9vcDBTN1BpR1ovNzBpQmVx?=
 =?utf-8?B?Z2U3OGJmWkNUeTQrVlpjeFdldkt1cnZRQTNCSWJ0RUljWlc0VCtSTmozM2Uy?=
 =?utf-8?B?SVM3ZHlMbHJRaXV4OUxKMmZEaWNtU0Q2MDQzT1JnTFFrRnV4OU5lOU1LMUht?=
 =?utf-8?B?L3Z2am9VeWVqNVkxcGxvRXZXQlNWa2tPYXg1NlIybElUclBGWnhyaVJJZWZk?=
 =?utf-8?B?d3hONEppejRLRWtjTVNLUlN2c0tyRUZaUXI3YUp3K3RGTEZkWnUwN0E2WkNY?=
 =?utf-8?B?VzdReDhsRVJ0QlRGdUZVMzlxN1hya1hoNDZES2lhem0rc3BuNGJnQkprRmZ4?=
 =?utf-8?B?MXREVVRVZkRsRGt5ZlhFd1Rib2dXbUVKdEVpaGRRaEp0aU1CLzYwV21qSUZK?=
 =?utf-8?B?VVdrWXhHblNYMUNVQmU0WCtLSStXOHhUQUhjRnN0c0ZuSVo5NXJmdHRSTWN1?=
 =?utf-8?B?WklqRVo0TFBlL1pzZzBvUE9jZGlOOTdiNFQ1OEFxYzRUR2k1REpiQlFDcXNs?=
 =?utf-8?B?RWFBNFFlWHJaWWFBOWROL0lKY2x0NWtWTE1lZWVBTytCbXo2aVY2K2RDNjFJ?=
 =?utf-8?B?QXZCZmFSOS8zdmZUWWhtWHRhR0plMllZcGUrY2t6c21XTC91aGY4WmxaSUwy?=
 =?utf-8?B?THY1Vkk2elpWdWdKTkJaeUM5Z2ROSTBVZFBMTVZJNHBrSXk1b3ZSN1ZFK0Vw?=
 =?utf-8?B?cFU2RDJZMG16NUorOU03RHc5bFBkL0hLQjZsMjlaS0VMTnZyL1dMQkdNZ0ZF?=
 =?utf-8?B?K3Z6R3hUd3lIK3RFNUxKNzNpSXV4Vk5VRmU2Z0FGRUs4UFpwQXJ3cWhyUFdT?=
 =?utf-8?B?NTUybE5hYW1MRkgzbWZnNWU5SU14YXJCL1M0Vm9jdlVMVVJ6aVAzR2lnNUU3?=
 =?utf-8?B?OGFqaWlxZW5RWEd2Tk9RbUtnT0JGaEttVitER29TK2hEMmNQTlJ3R1BLeERa?=
 =?utf-8?B?WEdtWm1Fa0NNamxsak8rSVdqWXRtS3ZaZUVEbk1OaWVxMWFDNlJubWFaNXpI?=
 =?utf-8?B?K3BwWUJBdkpwU0hSdEF2eWM5dmJxVlYvMnE0QUhpdHJsQTdIbTltUjFKN0Nt?=
 =?utf-8?B?TURZVzdzRUZvZUt3WnZsTGpMRDkvUW5EOVFndU1ZZVBFeExuYVBtLzRTNXg3?=
 =?utf-8?B?cnRPSUJJa21wTWdZYTVmRnNiWUxpUEJZOWsyYndKQVFjSFdCSUN6eEZNZk0x?=
 =?utf-8?B?NFZ3MkhaVjQrMVBmSkxpZTBhVUY1YlYyT3BQbDBNd2Voc0granZibThWVkJM?=
 =?utf-8?B?TWdVMklTNFRDb1crSmw2dHpGbVh6RzYyYVFnTm1RQlNIalVySjA2WHZ2MVpp?=
 =?utf-8?B?aUJFNXg0dVBVV2g1K09BYUV5enVmMTNnQUlPR2pkcGU3Yk56Y0h1LzI1anZP?=
 =?utf-8?B?L3JXeWw3elpURHlVRDBvWVpPTFRHK3IrRkNlb2g0YnRsK2p3aGxiYytFc3VJ?=
 =?utf-8?Q?xqDdW+A0fEdGp0bSVd/LTPc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8AE6D23D051365419DE3AE512F720986@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7c39bd9-1e15-46f7-1473-08ddb5132309
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2025 00:39:55.2735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3dvTqhWaoVsvNmWgdNDN2WgpAPmRiRtVxwndCmhH7ET1v13rdtWdXIbcj+bBlkyiGZKMV3hAOiBmpFSJj0tol7N+zUJZY7gvYpQCpD1vH+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6960
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA2LTI3IGF0IDAwOjM3ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
IEFyZ3VhYmx5IHRoZSBzdXBwb3J0ZWQvZW5hYmxlZCBwYXJ0IGNvdWxkIGJlIG1vdmVkIHRvIGEg
c2VwYXJhdGUgZWFybGllcg0KPiA+IHBhdGNoLg0KPiA+IFRoZSBjb2RlIGNoYW5nZSB3b3VsZCBq
dXN0IGdldCBpbW1lZGlhdGVseSByZXBsYWNlZCwgYnV0IHRoZSBiZW5lZml0IHdvdWxkDQo+ID4g
YmUNCj4gPiB0aGF0IGEgYmlzZWN0IHdvdWxkIHNob3cgd2hpY2ggcGFydCBvZiB0aGUgY2hhbmdl
IHdhcyByZXNwb25zaWJsZS4NCj4gDQo+IEkgYW0gbm90IGEgZmFuIG9mIHNwbGl0dGluZyB0aGUg
bmV3IHZhcmlhYmxlIGFuZCB0aGUgdXNlciBpbnRvIGRpZmZlcmVudA0KPiBwYXRjaGVzLCBhcyBs
b25nIGFzIHRoZSBwYXRjaCBpc24ndCB0b28gYmlnIHRvIHJldmlldy7CoCBZb3UgbmVlZCB0byBy
ZXZpZXcNCj4gdGhlbSB0b2dldGhlciBhbnl3YXkgSSB0aGluaywgc28gYXJndWFibHkgcHV0dGlu
ZyB0aGVtIHRvZ2V0aGVyIGlzIGVhc2llciB0bw0KPiByZXZpZXcuDQoNCkhvdyBhYm91dCBpZiBU
b20gdGhpbmtzIHRoZXJlIGlzIGFueSByaXNrLCB3ZSBjYW4gc3BsaXQgdGhlbSBmb3IgYmlzZWN0
YWJpbGl0eQ0KaGVscC4gT3RoZXJ3aXNlIHJlZHVjZSB0aGUgY2h1cm4uDQo=

