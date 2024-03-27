Return-Path: <kvm+bounces-12895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C32D88ECBB
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 18:36:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 008BA2A3507
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 17:36:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43DA014E2CC;
	Wed, 27 Mar 2024 17:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fMZiKjFj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D00C149DF5;
	Wed, 27 Mar 2024 17:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560976; cv=fail; b=nVGxJ351UIYrHQXtiW/0jHw5zU+XBrg/2O3ki9+PKUi2LuObU+sEnM7OvfXoBcGwplcbZ4pgLgcDUcshqcCO9lXsL9YlBWeVdjNKTBcm1qHG7z8Ut6Y5P5ZYhhbvWDs56TqzEex5g99fMu8L3Fi4vUdHTwJYWy72kB8QIJNdDJ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560976; c=relaxed/simple;
	bh=PtjNCjzCNTLecQDTsbcrMCwheo/ca1bnjXSBa7FWvb8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DmkILDw7IybT+ReHNry1EPvKTdyXEdqUzxf3/HmEksAEwyNPKD5eSWGOWezLUTQ9u1xxDXNysJlGM+LDwPs/fMXl4lE5terNajoSJPak4vH5IHswCP/grmaPOpNa4XU3xcA0Xlh71m7JGfri0ufTyPFZkgGeuh2lft+asd7kYro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fMZiKjFj; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711560975; x=1743096975;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PtjNCjzCNTLecQDTsbcrMCwheo/ca1bnjXSBa7FWvb8=;
  b=fMZiKjFj08q978teyITfbjA6snWxk71zCffXVm9b9WhAHM+WiL7jB2+I
   oKYsjBmdbsMkcPmko5YpNh6s1Oy9+42MnK3NG1P4Xf1fsM3JQw8oyuzI6
   MXx6HJF9181hAt23eeUC5I+qMRLGhToCwoNJdJoZPjuFESkOUThfrxYHr
   d69F3P5PnU9qCwgLAwvN1cUC/eNc2PzAPLfHkRUNeEkZ396L1Zg7bIswJ
   hYn2TEGW3kpRk/3HPcL+vZLMD5e5p6Ab/y23pqcqSDz0+2YiChrPi92eX
   +dZFmnjRlaVED+pvDpBzSb1sA10TNjUiKtUudwexJHfMznLvvvhipD1RA
   A==;
X-CSE-ConnectionGUID: r9Fsm0dCR8y3JrK0FD8aqQ==
X-CSE-MsgGUID: w4SwyHpHTfSgePZCSTCFWw==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="9642336"
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="9642336"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 10:36:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="16997446"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 10:36:14 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 10:36:12 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 10:36:12 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 10:36:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BytS8/3/JzNUw2BC+k81BiVkcDvyfCOHdu18HCjTX7X8ArYQ7xwSMJXe3JWWwVfZvFUYwdeoDeYRHf/8IH9g/qO1+6wM0wpCLOWcW0RmCgjtSHKyo05VuQA1xTawasWqrGvDSHgcZr8PEFO+/t5QioN5objtvxmkFEzFY6oGI/sYeyufX1/1yxuhlX/AU150l3RRF4RaBSVdxqJBWxTjQIDqOKPsqJCen9ddp/+dN/1HdZkRKP7tILCBMl9FQ2Caa2t1awQGQ/Ipc35NT7UeSwCpfH0t/ukvx/OSu4Z03OvVo3uvey3gbJd1l3fd0Uei5lMVSp1OEZ0kgTLfYUuLXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PtjNCjzCNTLecQDTsbcrMCwheo/ca1bnjXSBa7FWvb8=;
 b=Zb374Pfvnv8TMazm32cZIj1NRXP1Ul9BxWmMEOuWtJOS1ip23NkGnIYskwyL1tWIgwjxd/J0/2i7YEojhvaO6ZVPSD8fPNMhMia0EYbt09zN6TCCtrxkDDprX6ySKpRyZh5sdO6+QLoI+D0IBwXLSDlxqmMaH4ZNsBTaArstY+h2ILWAXD7hzb5JZUETZS60KOBZEFPOVJcD9rNqQKC1yqrZGuEPSmV1UiGQphlC7oYnMx+zRNe+WOwoYSI1C5GZ06cofm4C/j6f5LDN/P3RQxw044bAt7vLgv8vu6sG78VMlNyfFxPbhnqFduDWL12uhtkZkh1YZEvxTTJGVDA7yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB7963.namprd11.prod.outlook.com (2603:10b6:510:246::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Wed, 27 Mar
 2024 17:36:07 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.028; Wed, 27 Mar 2024
 17:36:07 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Gao, Chao" <chao.gao@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>, "Chen,
 Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yuan, Hang" <hang.yuan@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages for
 unsupported cases
Thread-Topic: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Thread-Index: AQHadnqpCkdQcpy1UEaf8e2/el3pBrE+L/IAgAGVVQCAABCvgIABmDGAgAFrqACAABw5gIAF68uAgAAN3oCAACgcAIAADqEAgAAC4oCAAAP3AIAAMXQAgAAC04CAAI7TAIAAbmyAgACYeICAAPZDAA==
Date: Wed, 27 Mar 2024 17:36:07 +0000
Message-ID: <34ca8222fcfebf1d9b2ceb20e44582176d2cef24.camel@intel.com>
References: <96fcb59cd53ece2c0d269f39c424d087876b3c73.camel@intel.com>
	 <20240325190525.GG2357401@ls.amr.corp.intel.com>
	 <5917c0ee26cf2bb82a4ff14d35e46c219b40a13f.camel@intel.com>
	 <20240325221836.GO2357401@ls.amr.corp.intel.com>
	 <20240325231058.GP2357401@ls.amr.corp.intel.com>
	 <edcfc04cf358e6f885f65d881ef2f2165e059d7e.camel@intel.com>
	 <20240325233528.GQ2357401@ls.amr.corp.intel.com>
	 <ZgIzvHKobT2K8LZb@chao-email>
	 <20db87741e356e22a72fadeda8ab982260f26705.camel@intel.com>
	 <ZgKt6ljcmnfSbqG/@chao-email>
	 <20240326174859.GB2444378@ls.amr.corp.intel.com>
	 <481141ba-4bdf-40f3-9c32-585281c7aa6f@intel.com>
In-Reply-To: <481141ba-4bdf-40f3-9c32-585281c7aa6f@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB7963:EE_
x-ms-office365-filtering-correlation-id: 69df1825-2e6b-4ff1-1268-08dc4e846269
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0jHtjMejYyrLLNxKGMP2bBUlU9TKOZruCf+H4jSuG6p/b7BmxSWO2jSAHIkdbOyHLTrcXC85qQEosGcF+qwgOvstl4QZ6o3jP6aVq0Cf9dzhqWrB/+PzfEetRXe0psPuIRwM3ubKQ3zVceNpDmlYsq+iHmifv0JYUvpbTfuNjIDS1BSVFdZMU4/cwxW1v5uS8HJEeTuL0mfdU2bprfoPHoUPGsVqcjj4+/D6PeweUROzfwawmm36vaK995vKeTXwynzdCiRUFuTszfMtY30GBPrme2D5xvSdXZ4BTO7ipGM0iRg2jlWovi1ByLzRaRs8AC13Dt6Xe4MRNrOBwvRexsu0xqLkqZxXFMrrPnMgX7HrvhMxEwkLxmxyvda8nUBa3sHhcbpH9q8s7TG2bygyvecdIxFkzqeNxYQ3zhzYxZN3W1MwEuCoG6HrBk5FLUHeLWZXMrcyefXOhvtpvQ5FWM28TCDThFdUZlC0INbl6uM7NWOFRkPOFHv5xT2I60iSPwmNhbkn4ZY9r0pG9bW6akhFfr3VnQbw+qfGKFKFbxSx3omHUUg5xGF2fHED+oeBmgn0HVeOxUJRzzSow5SAdk7jO5QFy6+eRePFAFJNwGTqm0kKAfxM/qYi/M5Q7bhqaLjpGp9El4hZUwawrnYLIln4PgIFrpIVBLwLY5S4hr1H+PgOJlnMet9DRXznCS1gDurh1zwZ6mxoYSKVfahAWA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eGx2aWZQM2hmVEpLdG9XYUVYcFhVbENMc2VWWlpEZTBLOXl0ZGpzWWpaSkl4?=
 =?utf-8?B?Vkd0YmdtUkd0RmoyaHpaUXdOdGJpRDYxdm1mL0FZOW9EaVl2bGRDamJMeGdC?=
 =?utf-8?B?UVJDcjFmMnNJQ0loMXlrTE5iK0ZIQ1Fray8yRTdkeThraS9sRGxHZ0NJNldC?=
 =?utf-8?B?cVZlMm4wNHE0TG9GZjJiSGZ3N1p3ZWtpVjNEa25BSEpuTzN2MmorZzJxWm5q?=
 =?utf-8?B?a2pqUmw1MHZMNUxoMUV1ZGw3N2huMGlJai9taWJyTDROQmZ5emJCeTlvcHFq?=
 =?utf-8?B?LzQ3dExCTXJZYlNMMnpySGFkU211UzZISi8rZTRGSldHNmErYUM3WERJZDR6?=
 =?utf-8?B?NEZtQ2xkbFdqbXBaOFE5Y2lZazAxeXRULzR3eHMrcEpYUVMxRVFHN3VkeUZN?=
 =?utf-8?B?dmlIYXZsck43dytJK0MwelZPUlZ4MXA4VVFnQ2hESDNzU2kzblhKd3pYcnNj?=
 =?utf-8?B?UmhPa0wvRFVOeklYUVRtUWpuR0Rqb2dHRGg4Q3VyNFVCTGVCbnFvNVp2V1oz?=
 =?utf-8?B?QjQ1V0p0dnNia2RmUk9oZkxhbU9zT3dYWFRleVd2ZlhjSnNyTDhnSU5POE9F?=
 =?utf-8?B?cDBhNkp6cGM5RVhWTFFBaTRFcWNwTDE3OVI2RkcraTJjWlBZSlZBUUt1ME1k?=
 =?utf-8?B?SGYzVmM4bXArbmdJeTJocmdUN2pmZWVYelEyQUNNOTRVK1lYWk1sUE15cVF1?=
 =?utf-8?B?MlZvUEVjbFp3dVBVaXN3b05uWnZ5dmJzTWYyZS9sY2wvVVNBS21ITWs0SWsx?=
 =?utf-8?B?dWxXbHZLY1lzdUtGSnBIcGg3WHVkandBK1ZMSEhUYUxveXhxeSswRFVpQ20v?=
 =?utf-8?B?WGczUXJKRzFVa0U1eXorekdyZVdtYmoySGJHcXRwQUhtclRyaUR1K1BocFhW?=
 =?utf-8?B?UDZPSlNHZ2hmNUh6TDJKQlZYOVcrQ3RPbDRkbUlCWTl4aHVsdWdBaGI0Qi9W?=
 =?utf-8?B?d204U1FZeVo4WEZhVUlzeGlJZHFQVXQySXJLSzhPbklEV2FEQmpkZ3dmYzhv?=
 =?utf-8?B?MkhjaXV2M2cwMnNzcGdZckMyQ3ltRitXdFBnY2QycFlFTFB5RUlMcmxJdmpL?=
 =?utf-8?B?S29tV21OU0tzaFNtOFMzSVRxRW1ONCtyNXlTM3pXN3dWR1BidTkwM1hhMXpt?=
 =?utf-8?B?bmpCckg3YWV2WW1zT2RrVFBMS1hTS214MCsvNGUxK0NDRkxlaXpZaUF6MnJO?=
 =?utf-8?B?ZjVTQmhnT1RiOE5OYWlqUlYxZ3BaamMyRFR1c2FTQzRuVUtKMmEyeWhrdVUx?=
 =?utf-8?B?NFJtTFhhVEFXZUJoNzN2dENGUVZPNUZLUUg0OWVKcG5tRzM0NURDUjNSMGt4?=
 =?utf-8?B?QlFUNGQ5TWhrdk5wNEhWVUh6QUVZdTc4OEJnSDNnR2lWK0JWYSs2ZWJRZWRa?=
 =?utf-8?B?VncxQmFSRDhmZWJEK2ZQM0RWK2tJSDkzRWxybXJUZ2RhbFl6bkhnSGZxNE1G?=
 =?utf-8?B?bWFtdDJERHNtY3duRjgzYzRQL3NVM3pod0tZSCtHU2xrb3AyNzUyajQya0Nu?=
 =?utf-8?B?RkZEZUhpRHRYTlpsWTZpejAxWTlEcXdycmU3SjlYS3NDcUhjdjBRQ0FKbzBL?=
 =?utf-8?B?bGc4S3dEd1RpbkZHN0c3enVKajFZMi9hWWdIYU1QbGZlb2xEQWI1TnJMallW?=
 =?utf-8?B?QnhLRXhGKzBtVk01WU5pK282dTZObWMyNlNMSmxOTlV1c0ljU3lNclZjNUZ6?=
 =?utf-8?B?ODhKRzVlYnNoaStVc1VYa2lLMVJqQ280N29iMUUwc2tCLzhSN2hqcFd3b255?=
 =?utf-8?B?cHdhWkpxMDNNU202cTBYSTl0SXBmMmhqajBkVW40eXc4UCtackFJckxYMFU0?=
 =?utf-8?B?K3VTOFVRL2ZZZmUyRHpIcUF5Vi9ERlVCV3E5ZHQrUTJ0THVDVFl3MkJ2R2pU?=
 =?utf-8?B?Vk80aTIvNVcvck4zR3krMlE0ODdZQjlhM1F6dWpyRDZuZHJWSjN0WEFSS2Nv?=
 =?utf-8?B?QW1pOWpPM29JOFAya3ZXbmJRMkQ5bXUvb2FyYmE3M0luTm9NZllvZ3l1SmRR?=
 =?utf-8?B?eHpMMWJNeEdpNkE5dzVrRXJWdlNPZW1KV0IyUFdKaFVhcFQrSTBWQ2xpcnd1?=
 =?utf-8?B?U2dsZFdKQVZ2bjB1VmJvdVZ4bkpraFB1Rm5mLzhDSUtzaDU0bnJIeDliNHJR?=
 =?utf-8?B?a1FpbTlmYTBJUmNlZndlYUhMdEtndFFES3JpOXFDb2FTUG5DeTBqTm9aYWt1?=
 =?utf-8?Q?kJ0pY1OTc9ww1kj4BxONYfg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F5E33A790D32BF40A2F7717AC38FAC94@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69df1825-2e6b-4ff1-1268-08dc4e846269
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2024 17:36:07.2987
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 48OEy3+bHUFcsaC6s8edFZkeuPPYKaLjSxb+tejbPauILHD0wi+WoorsdWMmI96stxGGPgN6O2lQCMR1kDwHYfKnhL528dEBfk5ifQJMFZc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7963
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTAzLTI3IGF0IDEwOjU0ICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiA+
ID4gSWYgUUVNVSBkb2Vzbid0IGNvbmZpZ3VyZSB0aGUgbXNyIGZpbHRlciBsaXN0IGNvcnJlY3Rs
eSwgS1ZNIGhhcyB0byBoYW5kbGUNCj4gPiA+IGd1ZXN0J3MgTVRSUiBNU1IgYWNjZXNzZXMuIElu
IG15IHVuZGVyc3RhbmRpbmcsIHRoZSBzdWdnZXN0aW9uIGlzIEtWTSB6YXANCj4gPiA+IHByaXZh
dGUgbWVtb3J5IG1hcHBpbmdzLiBCdXQgZ3Vlc3RzIHdvbid0IGFjY2VwdCBtZW1vcnkgYWdhaW4g
YmVjYXVzZSBubyBvbmUNCj4gPiA+IGN1cnJlbnRseSByZXF1ZXN0cyBndWVzdHMgdG8gZG8gdGhp
cyBhZnRlciB3cml0ZXMgdG8gTVRSUiBNU1JzLiBJbiB0aGlzIGNhc2UsDQo+ID4gPiBndWVzdHMg
bWF5IGFjY2VzcyB1bmFjY2VwdGVkIG1lbW9yeSwgY2F1c2luZyBpbmZpbml0ZSBFUFQgdmlvbGF0
aW9uIGxvb3ANCj4gPiA+IChhc3N1bWUgU0VQVF9WRV9ESVNBQkxFIGlzIHNldCkuIFRoaXMgd29u
J3QgaW1wYWN0IG90aGVyIGd1ZXN0cy93b3JrbG9hZHMgb24NCj4gPiA+IHRoZSBob3N0LiBCdXQg
SSB0aGluayBpdCB3b3VsZCBiZSBiZXR0ZXIgaWYgd2UgY2FuIGF2b2lkIHdhc3RpbmcgQ1BVIHJl
c291cmNlDQo+ID4gPiBvbiB0aGUgdXNlbGVzcyBFUFQgdmlvbGF0aW9uIGxvb3AuDQo+ID4gDQo+
ID4gUWVtdSBpcyBleHBlY3RlZCB0byBkbyBpdCBjb3JyZWN0bHkuwqAgVGhlcmUgYXJlIG1hbnl3
YXlzIGZvciB1c2Vyc3BhY2UgdG8gZ28NCj4gPiB3cm9uZy7CoCBUaGlzIGlzbid0IHNwZWNpZmlj
IHRvIE1UUlIgTVNSLg0KPiANCj4gVGhpcyBzZWVtcyBpbmNvcnJlY3QuIEtWTSBzaG91bGRuJ3Qg
Zm9yY2UgdXNlcnNwYWNlIHRvIGZpbHRlciBzb21lIA0KPiBzcGVjaWZpYyBNU1JzLiBUaGUgc2Vt
YW50aWMgb2YgTVNSIGZpbHRlciBpcyB1c2Vyc3BhY2UgY29uZmlndXJlcyBpdCBvbiANCj4gaXRz
IG93biB3aWxsLCBub3QgS1ZNIHJlcXVpcmVzIHRvIGRvIHNvLg0KDQpJJ20gb2sganVzdCBhbHdh
eXMgZG9pbmcgdGhlIGV4aXQgdG8gdXNlcnNwYWNlIG9uIGF0dGVtcHQgdG8gdXNlIE1UUlJzIGlu
IGEgVEQsIGFuZCBub3QgcmVseSBvbiB0aGUNCk1TUiBsaXN0LiBBdCBsZWFzdCBJIGRvbid0IHNl
ZSB0aGUgcHJvYmxlbS4NCg==

