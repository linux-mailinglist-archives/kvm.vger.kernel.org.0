Return-Path: <kvm+bounces-18233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 920688D234D
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 20:30:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F2B7DB217C2
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 18:30:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E0FE16E895;
	Tue, 28 May 2024 18:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iNuhmShs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DADB4E1DD;
	Tue, 28 May 2024 18:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716921005; cv=fail; b=dc0F20QZcJcqmBcru9H6TSM5lQyr0bPnxT3VhZYk8xK7pv0KSIEN73owlufRsDHp1cHX1ldjgtvbaxYEtjxPSFThiRrMiy/SGTt/5FAiMS7odeJ2LS4NzPr8pruwDRlM3ubUjRStjEd7twQUaJg6F8HjUQxoaR0UkA8Mwv6SB+A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716921005; c=relaxed/simple;
	bh=7XORO5STiAnb1EJecgF8N3wpFK7nvL+m9Cfsq39F2OM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UTTxfozrmsI1tYR08DYGxs0NMgkY70XLQ1oeiC7J6+heoPooyN2KNq8tmNvudVnbEk7WkF98Lbyi3oV9pRNHpcEJdA3/lH1MAcosFwhBp5PFq6/iuNhGr40hj13OX1Pe8latnESfpH392Q4hwHvUlyHlbZa9sBO1CCzuRxZ+Ji0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iNuhmShs; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716921004; x=1748457004;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7XORO5STiAnb1EJecgF8N3wpFK7nvL+m9Cfsq39F2OM=;
  b=iNuhmShs5hbyEqeTQt1+zaug0WxXouM31n2m5cVHCGLqGwi3X1GjOgxz
   0D9kQT25tCKQFIrjw8AgOkFxxyOy7P9ieLABpw94/HQ18nBYTz2LHrGS6
   r7SW2Ccon6so6xxNU49IvlUjBNHs+Eodm5IRRIksliaUx+Mflu+cJ6pO/
   Wkq8MpGpgx3Aq7dHHnXSmO12h1IeCQmVZGnoxNNARpfk5iOKwlCEQjAA8
   vtfRny9fnTmm4lu/COEF97AyMSoQZBXWghc0ZCdYwFdO5qevZMDk2yCj0
   ALDnGPqcTZIKCuk6ut/wTUBWZQMz+nPMklRKPYfiZC17/opLo/B7Px0MO
   g==;
X-CSE-ConnectionGUID: c2xrZHLTQe+sKfVlf+KybA==
X-CSE-MsgGUID: kZ8otua7TU2GYUgwlAAQDA==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="23895986"
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="23895986"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 11:30:03 -0700
X-CSE-ConnectionGUID: r8n0Tmq7SYmNRaq+WNwqbA==
X-CSE-MsgGUID: VbeKzIqhRLi4h9FSaXqVww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="35772995"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 May 2024 11:30:03 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 11:30:02 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 11:30:02 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 28 May 2024 11:30:02 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 28 May 2024 11:30:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0qtDJoapQtAEs57HsJUtfdzoEhrliZJBMwHGE9nwE1Pi0rvMnezkyuJQbGH48IGsqpnfM8wcrLsjKlATmt/h4Xc6M1jYlcXj89Kc6KTtZft9fmMnMKGPDNOXAXB9cU84XH08qVY1970xyfl3z0sJfeEa9F44slK4SRqdZmA5k2YzetmVqikQtQymszNncLT9LP8QUyulL6Gw1OFApdJs2EY8yq8ShWLzXQbR0mcflTk8GVEr/eBJ3FnoF8KGtCj4reCv7MFr9MSvIePpY9ULeTanT7DH+1vn6rfWxgU24rVMafqJWSbCXr2o4CGYQQefcPvNPRD6wYNBjjm2APcqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7XORO5STiAnb1EJecgF8N3wpFK7nvL+m9Cfsq39F2OM=;
 b=Z9cnvUUlmPgf3VqvvJcLidW1QIgf6UZas2LDOU1/6CEnBcH8pKsCiOGeK6KQI2QRV+z85q0aBUwoqNbFZKSzSLX8k9jwiPglm9/Cnx3DGMd17a90ni3Tnf7OcKdlXhFtA0fuvVTAB2qkSr2hozpVFB03+I2hxMz+qOzHcTEApTFUyXVTCuSvCXHaGjZx9qBTSp7WwnOiBGeUV2VqCCybpiYU/lI0n3c4h9m3kgpZDUTXlKdO7sgcYsnGUR80sPyEHi7Iy+q5tklGU+ESB5AUf8ojEz2Zsjy0QGyVCOKkQMkQY4OQXLwwX9C1rLN8abpbNP/VKcM2VcUjjy4Rs4C5rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ2PR11MB8298.namprd11.prod.outlook.com (2603:10b6:a03:545::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Tue, 28 May
 2024 18:29:59 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7611.030; Tue, 28 May 2024
 18:29:59 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "dmatlack@google.com" <dmatlack@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Topic: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Index: AQHapmNTP3XGfqhyyEaM/KHu10XBU7GZCeQAgAAJxQCAAAs0AIAADfKAgACpkgCAADtVgIAAM8qAgABzkACAAGxrAIAAmmaAgAAQyQCAESg3gIAAFG4A
Date: Tue, 28 May 2024 18:29:59 +0000
Message-ID: <3fa97619ca852854408eec8bb2f7a0ed635b3c1d.camel@intel.com>
References: <12afae41-906c-4bb7-956a-d73734c68010@intel.com>
	 <1d247b658f3e9b14cefcfcf7bca01a652d0845a0.camel@intel.com>
	 <a08779dc-056c-421c-a573-f0b1ba9da8ad@intel.com>
	 <588d801796415df61136ce457156d9ff3f2a2661.camel@intel.com>
	 <021e8ee11c87bfac90e886e78795d825ddab32ee.camel@intel.com>
	 <eb7417cccf1065b9ac5762c4215195150c114ef8.camel@intel.com>
	 <20240516194209.GL168153@ls.amr.corp.intel.com>
	 <55c24448fdf42d383d45601ff6c0b07f44f61787.camel@intel.com>
	 <20240517090348.GN168153@ls.amr.corp.intel.com>
	 <d7b5a1e327d6a91e8c2596996df3ff100992dc6c.camel@intel.com>
	 <20240517191630.GC412700@ls.amr.corp.intel.com>
	 <CABgObfY=RnDFcs8Mxt3RZYmA1nQ24dux3Rhs4hK0ZfeE_OtLUw@mail.gmail.com>
In-Reply-To: <CABgObfY=RnDFcs8Mxt3RZYmA1nQ24dux3Rhs4hK0ZfeE_OtLUw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ2PR11MB8298:EE_
x-ms-office365-filtering-correlation-id: 4504a1ff-5034-4fae-81ed-08dc7f442e64
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?RTc2N21HUkF5eVFBazJLK0Q1OVJndVREclBTejFISWRBTVdtYWlYdDU0NGJO?=
 =?utf-8?B?Rk11dTZRay9oS2NaTGFDU1RQODRJeVByd1pqbWVSSlRvOGRycXJ1ZnczMjFp?=
 =?utf-8?B?STM2anNrTVE3enVOaEVSZU5TaEZxQVZ1NG8wRUhzSDhXWHpHOGJXZVVRaDdu?=
 =?utf-8?B?eFZ2eFRmT01jUHcyUTdRSS9VbWJLTUJVV0lBYW9weWEyUElVWDBDUlY2bEw0?=
 =?utf-8?B?dUIrN3hLbWRRWWJRTVlwbVJTS1JQVjVhUDNvR1luSlBnNUhnS3RDZnUwZVp6?=
 =?utf-8?B?NlFvanVYYWltckR2b0NpY3RtNTU1ejNjOWZGRDFLMUZUckpGNmZOREpadFU0?=
 =?utf-8?B?MnU0d3lGakxKbnZIYzB2VTA1T09yd2szazU3RGFzdVZEU0pJR3hNQ0g5Yk1X?=
 =?utf-8?B?MENlS1NqTkVCdm9GREx2bXZ2YjhkT2kwQWlBdTRFZ0ZWNituZlpoeXJtclE3?=
 =?utf-8?B?ZE5xOUs4YWZZYkF1QldiNzFMNWUwQzBjcUprSytrWjl1ZUVhajNzTE9mY0x4?=
 =?utf-8?B?WHZiUkRpT05VMWVVTFBaU1NWdEpxeXdpcDJoTER1YkZ6QmdVWmdzTWVLdHRI?=
 =?utf-8?B?elYzOUExNzhNMmp3OENxdlh2NDZ3cHEwODNzeTQ1ekNPOXNPUFkvWWY2N3pa?=
 =?utf-8?B?ZWg4VmMya1M1UWIvVEJTMnZTSnYvMGZUNjFiamlTNDZmRWQ4cytuSjhmc0N1?=
 =?utf-8?B?MlBzbGY3a0VZSCthK2F1UFhmRmxSR0ZKT0sxNGsyTFUyY3I5V2llZ1NraE5B?=
 =?utf-8?B?dVdsVUlpK2ZJcTY2Rjk5cFkvd2ZwSWFaWkZwSGVjbzhOMlVvOGJNalRTM0RD?=
 =?utf-8?B?VkJsdUVVSVBVR0EyRXkxR1Z0VHBuNVc3RElOUTdwM3c2WCtFaGlvN0xnVnN3?=
 =?utf-8?B?Q0xNMFMyMUNTZUlNNkNtK1FrWWJRMjI3QW5BSGhKT2xaaXlyNzkvNTRFcmVq?=
 =?utf-8?B?TG5IRjBtQzM2dUpDQ1loOTNFamJxUncvclFNWTNWZmRsYU9YQWxPQUVpbllQ?=
 =?utf-8?B?dW5DV0o5NVdLQmUzSTQzYTlIMVIyaVNhekJZb3lrOUsvZWphNlQzT2VFYVho?=
 =?utf-8?B?dGFJWnI2b0ZuY1ZhMnNiaCtHQXh0em9qa29tRVNoZ2NXdnN4RkxSZlExN1Jr?=
 =?utf-8?B?YnJJNmQ5a29ETUVQYmY5WUZ1d0NHdnlLaGlhYk13TUhvOVpqZGRGVGNXeHB3?=
 =?utf-8?B?SFBiZERFa0tGVlFOTHV6czBOdDZ6QWVFQ3pMV0t4WGJGUE9lSDA5NW9NdURl?=
 =?utf-8?B?WEV5VDNBbHZiNk5tOUNYZFkycWVnc1V1RHE3aTlmYUNzVU9Wc1QxWUNTN0F4?=
 =?utf-8?B?NGYvTlVRUjVnRytHRFJDUGRDSmk0a1NORmFaUFEySE1oOFEydGtTMjdKRHBD?=
 =?utf-8?B?TFRzSUd0elJUdGZTTlFTWk9GQUpiTFI5c1Bja2RyalZ1bnJVekgveDhHbVFj?=
 =?utf-8?B?b21hTzh5QldsMk1MWWo3WENWb21DQzc0dWxGclNTOVJWdkhobElZRTBUVmN0?=
 =?utf-8?B?MHZBL043clR1K3c2R0NPUTcycFdqZVF1eEkrQlZPTVA5Zmp0ZG9nMENTLzY1?=
 =?utf-8?B?bjBNREptVk90UWhJSVJuR3BnNXBSalpGR0lCcE1HTzhlQnZCbnkwZVU5S1BD?=
 =?utf-8?B?aWtLeXQvVDBDRzNsVGRNdmtlU2dsdTgzUGM0dlhTS21YSnBXOU5QeWwrSWJr?=
 =?utf-8?B?aEVvdUljUll4QmxIditkcGJWRnZKNHpSVHBZd2ljNnNUS3VNRUtCWEY3cEsv?=
 =?utf-8?B?b29HK0xGeUtsZEI3RXZ1dVo5MHd4K2tkbXF2MjVJTzlydzF3T25PdzBtNFJ3?=
 =?utf-8?B?WUVOL3RFTmFkWlhBUk5FZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Vy94Vk1CRWQ1L3ZYbDM2M1IxOGo5OUhoRVpvWDZPajIzUHZGRm5TNkVxSHhY?=
 =?utf-8?B?OXZQYUNxTnBON2tBQ1cwUDMzZFpITnl1YitFMXVORWtJWDJ0Qm1USTdMTlM2?=
 =?utf-8?B?dmVwMHpFNDVodkptYWtVNURORjZ4MkZXNldlUUNyM0I1VjJXbm5HempUMmJy?=
 =?utf-8?B?Z2YwYnpWRWNWYnVrSDkvd2xsYW9aLy8zSXdndk5YRXlBZ2QweWljNlpwSita?=
 =?utf-8?B?SWptUFRRdHVnYU5SYkhGODBJZlQvZk04M3Y2QnlINEJVYXg2c0U4STFURGQr?=
 =?utf-8?B?aC9nOXE5cHMwR1pkdm1EeWpUSmU1ZFRKSDhKVDAzZ1M1c0V2RFdrK2xYTlNI?=
 =?utf-8?B?Q1NQYTQybTkvc2N1VklBd2NFVVNjeWpWdkJPV1hJU1N5akI3RDZ4ZzhlK292?=
 =?utf-8?B?aWN5TmpKdjh6Ky9vZXlOeU1WTVNFR3RGK0I2T2VoRkQ5Vk85a09ibmFoaGFs?=
 =?utf-8?B?UUhMZHZ3WURVMExtRUhRNXkzOG80dTl2RysrWCtXOVlRV3hWVlR6dXJOUnli?=
 =?utf-8?B?VkkyUEorbUprZ3cxQnM4RXdBMzNZTjg1ajhEdjBCcHJtSEM2cHFaVFFsM1lO?=
 =?utf-8?B?aVZPNWdYL0FWY2NROCtzdFNCakdpRytWSmZmZC96ZXdsOEFqbXUzM1ZST0lV?=
 =?utf-8?B?U2t5UDlXMHVtZ3N4NzVHUlkvbE5IYWhsMzMxMUxndk9jejFpN2VIUXlrVnVI?=
 =?utf-8?B?Z25YT0UzS0dobVlqS0ZnODR0VXlTZE1zOERNUzFTUUdyOTNTVjZKdXFyOWEw?=
 =?utf-8?B?L3JyZmU5NXY2VXZia2xIWmNaaUVFOWtKMi9pRkl4bTBsQlROV2dxYThBb2Fw?=
 =?utf-8?B?MlM4UXUyblFuUjZ1MG1jQmtGZUlWOEJ0MkIxREZ5R0xaajFYOUtRSktRdUpa?=
 =?utf-8?B?WmcvK2NZMnB2RUJxNFRhR2FCVEN2V1Aza21Uc1R4NnZTeVdESTlxeGRpWEll?=
 =?utf-8?B?UmRsbTdUdncveXB1Tk1CMDU5ZUJ2eU9JTU5XaW5Jay9zczEyRG93T1NOcWI1?=
 =?utf-8?B?ZWkrKzVSNXRINENMUThQQit5ZXlJSlRlQTBmRVJGYXhtZnBNKy85aUVmM2h0?=
 =?utf-8?B?TzlxUDg3S3hieEgzL2dqRWFYWDVpQXJTdnVaaFBIaWE3UHpZMHc3SlJqL1ZS?=
 =?utf-8?B?Rk01OG5YVENMcEtOa3FGSkdzY2RvdXZvcnBYWlFJUmh2c1dudms2ZmJPVUNJ?=
 =?utf-8?B?TEcwR3I0ZUxqYnBkUlZ0Z3ErOGlDdjUvM2htSXY1aUtwVnhzOW9NZnpoZjFm?=
 =?utf-8?B?TjgrL0hYL2lyeC9BVnZreFMyZGVUSldjTjJsamxhclVxVW0rVkJNd2JONkZJ?=
 =?utf-8?B?VVFvbk03MUhCYm4rVEZzRGFzS09DMll1V09Fc0Q2WmlBOFhSNlhFbEVpT0hI?=
 =?utf-8?B?Z3RQR3N4ZnVFNURXeExndENWZk12OXpsdUxaZGhCYkQvUUxEektiWnhyVHBX?=
 =?utf-8?B?dkFzeEI0RXdPaUw4eC9kR3B1elRXWndvaWJnTlRQZ2lySW93QUd4VTkralJm?=
 =?utf-8?B?TFIvT2ZpM2NrRTMrMTVtT1RTaG5OSnU4a1FOWnFnZThLNkt5TjV5K0RZakxm?=
 =?utf-8?B?NG9veXp5d2dXa09nUXFPNS90YmFTYTdhZmg4WTdxK2pheEQ2TlN4alBkeGpz?=
 =?utf-8?B?VHY2MUNmV0NRd3JQTG0zL0pEQWRBTzRiYmR1c21QMjB6UlB6RlN5TVhkWFI0?=
 =?utf-8?B?dk43M3B0eW1RY1QvMVdqSCt0QlBoL3hVaHhpZ1haeEFjWWlvZDd6Q1BuSWpL?=
 =?utf-8?B?ZHpmbEtaTU1GV005aXJ6MVNKcmQ0TTZmN1FtNGk5VWE1YVk2WEtqdVo5R29p?=
 =?utf-8?B?NlVWZStLRVp4K2hTMStaWS84SGxXcFpvS3J4UEtvZUNoVGJXMmRLdlBIck4r?=
 =?utf-8?B?TEZYaFVPWkQ1YlNISTBWeVNmcDBhRy9GQWo4TTVqcGhPc0VDZFZIMWpiNlJv?=
 =?utf-8?B?UnIrSlQ4WVB1d0dxTzNRYTgya1grNm82RHgvekRGYVdSdmpkbndGMEdVS2Y3?=
 =?utf-8?B?NXN1eWt5UjNvcHBSOUZGRGZyK0hTTG80YmlQek1XMUl3aCtrZzZBVkphOUJ2?=
 =?utf-8?B?aW1BZWhKSTYyWFc2R0ltMStST0h6S1piU0JOQ1VRMWc4cUt2bnJXaE1SOHlt?=
 =?utf-8?B?empJNGtCSldMMVFRTXJ4MnJ5K1R0dVdzQ2dFejZYUTRTamhMT1pvdmZIREF5?=
 =?utf-8?B?d0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <18FF42AC3139BB4A83BC129A385B4975@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4504a1ff-5034-4fae-81ed-08dc7f442e64
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2024 18:29:59.2375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DHE9EdJeX1o27kXV7lNSxUU1R8OFMRzbU48APFiIBj5f/Cu2XdG9kxrUCTj46R0Sd3UFcXUwU2rTRqwroECXa9Yu0ImRdaDGAsYq7/6jrV0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8298
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA1LTI4IGF0IDE5OjE2ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiA+ID4gQWZ0ZXIgdGhpcywgZ2ZuX3QncyBuZXZlciBoYXZlIHNoYXJlZCBiaXQuIEl0J3MgYSBz
aW1wbGUgcnVsZS4gVGhlIE1NVQ0KPiA+ID4gbW9zdGx5DQo+ID4gPiB0aGlua3MgaXQncyBvcGVy
YXRpbmcgb24gYSBzaGFyZWQgcm9vdCB0aGF0IGlzIG1hcHBlZCBhdCB0aGUgbm9ybWFsIEdGTi4N
Cj4gPiA+IE9ubHkNCj4gPiA+IHRoZSBpdGVyYXRvciBrbm93cyB0aGF0IHRoZSBzaGFyZWQgUFRF
cyBhcmUgYWN0dWFsbHkgaW4gYSBkaWZmZXJlbnQNCj4gPiA+IGxvY2F0aW9uLg0KPiA+ID4gDQo+
ID4gPiBUaGVyZSBhcmUgc29tZSBuZWdhdGl2ZSBzaWRlIGVmZmVjdHM6DQo+ID4gPiAxLiBUaGUg
c3RydWN0IGt2bV9tbXVfcGFnZSdzIGdmbiBkb2Vzbid0IG1hdGNoIGl0J3MgYWN0dWFsIG1hcHBp
bmcNCj4gPiA+IGFueW1vcmUuDQo+ID4gPiAyLiBBcyBhIHJlc3VsdCBvZiBhYm92ZSwgdGhlIGNv
ZGUgdGhhdCBmbHVzaGVzIFRMQnMgZm9yIGEgc3BlY2lmaWMgR0ZODQo+ID4gPiB3aWxsIGJlDQo+
ID4gPiBjb25mdXNlZC4gSXQgd29uJ3QgZnVuY3Rpb25hbGx5IG1hdHRlciBmb3IgVERYLCBqdXN0
IGxvb2sgYnVnZ3kgdG8gc2VlDQo+ID4gPiBmbHVzaGluZw0KPiA+ID4gY29kZSBjYWxsZWQgd2l0
aCB0aGUgd3JvbmcgZ2ZuLg0KPiA+IA0KPiA+IGZsdXNoX3JlbW90ZV90bGJzX3JhbmdlKCkgaXMg
b25seSBmb3IgSHlwZXItViBvcHRpbWl6YXRpb24uwqAgSW4gb3RoZXIgY2FzZXMsDQo+ID4geDg2
X29wLmZsdXNoX3JlbW90ZV90bGJzX3JhbmdlID0gTlVMTCBvciB0aGUgbWVtYmVyIGlzbid0IGRl
ZmluZWQgYXQgY29tcGlsZQ0KPiA+IHRpbWUuwqAgU28gdGhlIHJlbW90ZSB0bGIgZmx1c2ggZmFs
bHMgYmFjayB0byBmbHVzaGluZyB3aG9sZSByYW5nZS7CoCBJIGRvbid0DQo+ID4gZXhwZWN0IFRE
WCBpbiBoeXBlci1WIGd1ZXN0LsKgIEkgaGF2ZSB0byBhZG1pdCB0aGF0IHRoZSBjb2RlIGxvb2tz
DQo+ID4gc3VwZXJmaWNpYWxseQ0KPiA+IGJyb2tlbiBhbmQgY29uZnVzaW5nLg0KPiANCj4gWW91
IGNvdWxkIGFkZCBhbiAiJiYga3ZtX2hhc19wcml2YXRlX3Jvb3Qoa3ZtKSIgdG8NCj4ga3ZtX2F2
YWlsYWJsZV9mbHVzaF9yZW1vdGVfdGxic19yYW5nZSgpLCBzaW5jZQ0KPiBrdm1faGFzX3ByaXZh
dGVfcm9vdChrdm0pIGlzIHNvcnQgb2YgZXF1aXZhbGVudCB0byAidGhlcmUgaXMgbm8gMToxDQo+
IGNvcnJlc3BvbmRlbmNlIGJldHdlZW4gZ2ZuIGFuZCBQVEUgdG8gYmUgZmx1c2hlZCIuDQo+IA0K
PiBJIGFtIGNvbmZsaWN0ZWQgbXlzZWxmLCBidXQgdGhlIHVwc2lkZXMgYmVsb3cgYXJlIHByZXR0
eSBzdWJzdGFudGlhbC4NCg0KSXQgbG9va3MgbGlrZSBrdm1fYXZhaWxhYmxlX2ZsdXNoX3JlbW90
ZV90bGJzX3JhbmdlKCkgaXMgbm90IGNoZWNrZWQgaW4gbWFueSBvZg0KdGhlIHBhdGhzIHRoYXQg
Z2V0IHRvIHg4Nl9vcHMuZmx1c2hfcmVtb3RlX3RsYnNfcmFuZ2UoKS4NCg0KU28gbWF5YmUgc29t
ZXRoaW5nIGxpa2U6DQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3Qu
aCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgNCmluZGV4IDY1YmJkYTk1YWNiYi4u
ZTA5YmI2YzUwYTBiIDEwMDY0NA0KLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3Qu
aA0KKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KQEAgLTE5NTksMTQgKzE5
NTksNyBAQCBzdGF0aWMgaW5saW5lIGludCBrdm1fYXJjaF9mbHVzaF9yZW1vdGVfdGxicyhzdHJ1
Y3Qga3ZtDQoqa3ZtKQ0KIA0KICNpZiBJU19FTkFCTEVEKENPTkZJR19IWVBFUlYpDQogI2RlZmlu
ZSBfX0tWTV9IQVZFX0FSQ0hfRkxVU0hfUkVNT1RFX1RMQlNfUkFOR0UNCi1zdGF0aWMgaW5saW5l
IGludCBrdm1fYXJjaF9mbHVzaF9yZW1vdGVfdGxic19yYW5nZShzdHJ1Y3Qga3ZtICprdm0sIGdm
bl90IGdmbiwNCi0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHU2NCBucl9wYWdlcykNCi17DQotICAgICAgIGlmICgha3ZtX3g4Nl9vcHMuZmx1c2hfcmVt
b3RlX3RsYnNfcmFuZ2UpDQotICAgICAgICAgICAgICAgcmV0dXJuIC1FT1BOT1RTVVBQOw0KLQ0K
LSAgICAgICByZXR1cm4gc3RhdGljX2NhbGwoa3ZtX3g4Nl9mbHVzaF9yZW1vdGVfdGxic19yYW5n
ZSkoa3ZtLCBnZm4sIG5yX3BhZ2VzKTsNCi19DQoraW50IGt2bV9hcmNoX2ZsdXNoX3JlbW90ZV90
bGJzX3JhbmdlKHN0cnVjdCBrdm0gKmt2bSwgZ2ZuX3QgZ2ZuLCB1NjQgbnJfcGFnZXMpOw0KICNl
bmRpZiAvKiBDT05GSUdfSFlQRVJWICovDQogDQogZW51bSBrdm1faW50cl90eXBlIHsNCmRpZmYg
LS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCmluZGV4IDQz
ZDcwZjRjNDMzZC4uOWRjMWIzZGIyODZkIDEwMDY0NA0KLS0tIGEvYXJjaC94ODYva3ZtL3g4Ni5j
DQorKysgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCkBAIC0xNDA0OCw2ICsxNDA0OCwxNCBAQCBpbnQg
a3ZtX3Nldl9lc19zdHJpbmdfaW8oc3RydWN0IGt2bV92Y3B1ICp2Y3B1LA0KdW5zaWduZWQgaW50
IHNpemUsDQogfQ0KIEVYUE9SVF9TWU1CT0xfR1BMKGt2bV9zZXZfZXNfc3RyaW5nX2lvKTsNCiAN
CitpbnQga3ZtX2FyY2hfZmx1c2hfcmVtb3RlX3RsYnNfcmFuZ2Uoc3RydWN0IGt2bSAqa3ZtLCBn
Zm5fdCBnZm4sIHU2NCBucl9wYWdlcykNCit7DQorICAgICAgIGlmICgha3ZtX3g4Nl9vcHMuZmx1
c2hfcmVtb3RlX3RsYnNfcmFuZ2UgfHwga3ZtX2dmbl9kaXJlY3RfbWFzayhrdm0pKQ0KKyAgICAg
ICAgICAgICAgIHJldHVybiAtRU9QTk9UU1VQUDsNCisNCisgICAgICAgcmV0dXJuIHN0YXRpY19j
YWxsKGt2bV94ODZfZmx1c2hfcmVtb3RlX3RsYnNfcmFuZ2UpKGt2bSwgZ2ZuLCBucl9wYWdlcyk7
DQorfQ0KKw0KIEVYUE9SVF9UUkFDRVBPSU5UX1NZTUJPTF9HUEwoa3ZtX2VudHJ5KTsNCiBFWFBP
UlRfVFJBQ0VQT0lOVF9TWU1CT0xfR1BMKGt2bV9leGl0KTsNCiBFWFBPUlRfVFJBQ0VQT0lOVF9T
WU1CT0xfR1BMKGt2bV9tbWlvKTsNCg0KDQpSZWdhcmRpbmcgdGhlIGt2bV9nZm5fZGlyZWN0X21h
c2soKSB1c2FnZSwgaW4gdGhlIGN1cnJlbnQgV0lQIGNvZGUgd2UgaGF2ZQ0KcmVuYW1lZCB0aGlu
Z3MgYXJvdW5kIHRoZSBjb25jZXB0cyBvZiAibWlycm9yZWQgcm9vdHMiIGFuZCAiZGlyZWN0IG1h
c2tzIi4gVGhlDQptaXJyb3JlZCByb290LCBqdXN0IG1lYW5zICJhbHNvIGdvIG9mZiBhbiB1cGRh
dGUgc29tZXRoaW5nIGVsc2UiIChTLUVQVCkuIFRoZQ0KZGlyZWN0IG1hc2ssIGp1c3QgbWVhbnMg
d2hlbiBvbiB0aGUgZGlyZWN0IHJvb3QsIHNoaWZ0IHRoZSBhY3R1YWwgcGFnZSB0YWJsZQ0KbWFw
cGluZyB1c2luZyB0aGUgbWFzayAoc2hhcmVkIG1lbW9yeSkuIEthaSByYWlzZWQgdGhhdCBhbGwg
VERYIHNwZWNpYWwgc3R1ZmYgaW4NCnRoZSB4ODYgTU1VIGFyb3VuZCBoYW5kbGluZyBwcml2YXRl
IG1lbW9yeSBpcyBjb25mdXNpbmcgZnJvbSB0aGUgU0VWDQpwZXJzcGVjdGl2ZSwgc28gd2Ugd2Vy
ZSB0cnlpbmcgdG8gcmVuYW1lIHRob3NlIHRoaW5ncyB0byBzb21ldGhpbmcgcmVsYXRlZCwgYnV0
DQpnZW5lcmljIGluc3RlYWQgb2YgInByaXZhdGUiLg0KDQpTbyB0aGUgVExCIGZsdXNoIGNvbmZ1
c2lvbiBpcyBtb3JlIGFib3V0IHRoYXQgdGhlIGRpcmVjdCBHRk5zIGFyZSBzaGlmdGVkIGJ5DQpz
b21ldGhpbmcgKGkuZS4ga3ZtX2dmbl9kaXJlY3RfbWFzaygpIHJldHVybnMgbm9uLXplcm8pLg0K

