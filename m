Return-Path: <kvm+bounces-50385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11161AE4AE2
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 18:29:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5828B3A8722
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 16:26:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B9B428EBF1;
	Mon, 23 Jun 2025 16:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aewun3IF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8F7274FF9;
	Mon, 23 Jun 2025 16:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750695823; cv=fail; b=LUK+BnNDIypzAaMvEzDrrPXuDEGiV8cI9TeyEGGxdtIVGL4tuXFYKlroZ5TSsdQ/uIsOMUV2OkkZiwwZPTnakehq7o+wJ2sgn8LZAuiQE5fo4NUXfGF9US+5Whp9y384ylKwSJ7hg+NorgqPbOQMf3gWNh1lkVRBkUlfTmFKThE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750695823; c=relaxed/simple;
	bh=hhS6wavxNHWZO8VbxNzr03CVL5mGqlBf+6xN8+FiuAI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bInLR6f1ZEwDXzYXNu1wq4vh1K/uJEo/lkROaePak73slOjBLg6jvkNdoNTiK/o5by2Ut/zTHk/7+bKOuk1Oon8gjrASf9v3/S/N7lXOZ++ziVSrCdVomnt0CCkglSdw8wz4F9w+Tq3XdS0iRG6GHEb7nTW9OrMPzxbhT1K5R/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aewun3IF; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750695821; x=1782231821;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hhS6wavxNHWZO8VbxNzr03CVL5mGqlBf+6xN8+FiuAI=;
  b=aewun3IFg8ER1uW6ze0lex6OesDJfshAfwxLBU/ZntnXOPtWonIAdjAP
   ncuY7sjiyMFrCkHynldTxJm8mv7rcVdRrVT32ucC3qArGcD1NEpfRGx+X
   o25LZpzM98cp+uTkhf77NF3adpXKuiG8/hCUIbxw3V4mzoJ0QTaApw3IU
   G5oIhn3aa9GvMAAQJ2WELyC6jCVirQisLv0s9Pth2gTzhSxy91ylPJgKO
   eQCIhcuLTsxYhJtMB/qfnW4/X5vO91W7LpeLGB+01Zgc6l3HSk3GSZCqe
   gsubsl2fxobPcjFHq4YHMgeOZy9WdmhWLbJJ98Li4jhs2H4XyWVFNU+Gj
   A==;
X-CSE-ConnectionGUID: 1aoo+v2hTbKvD2GQhN7Fug==
X-CSE-MsgGUID: +6jszxbCR7eqnCIXETlVUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11473"; a="63516590"
X-IronPort-AV: E=Sophos;i="6.16,259,1744095600"; 
   d="scan'208";a="63516590"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2025 09:23:39 -0700
X-CSE-ConnectionGUID: dWkExtj+QZuWVCepAWBQYg==
X-CSE-MsgGUID: hFBKTFpKRt+fM1N62xJLbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,259,1744095600"; 
   d="scan'208";a="151124780"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2025 09:23:39 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 23 Jun 2025 09:23:38 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 23 Jun 2025 09:23:38 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.87) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 23 Jun 2025 09:23:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h/+2J+PuIlNY2i/+ut7EcA9UafXlGCu4iv9T4AqsZ93l5gJ3zJ7ZHEYqDMZDrJYqI6SJD30mFQSfU/sTWLIzQKmFmyI2rT9KkE42NoL8yu9HOS/oHSmtDrrtpne24PoJDabeJe4qkxRo5fqi2jfuynivGHbjutQGEj8qQyyIAQ58vHO1dhbyRlxHsOlslt4GwIFNmPAMLuhmkn3XLoU/wEQ9aTgTA7MW7Z/9QgFokPeDX+oMq2e803cyyScmQ+UBJLVhesE3UFYVHNxZuipJIThHbd9aQVDX2UnTnuMNEq0plB1QJvBPw3qkHfBOz6fJAhcUASUYhbA4KhhFqOImpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hhS6wavxNHWZO8VbxNzr03CVL5mGqlBf+6xN8+FiuAI=;
 b=JjvlPRfG6kQl8Fwb/qc+fLr3ZgxOhUnBQHK+7F5xF1k3aqTOTGlnJvyva4daElKrfkfDadPHksEAnTyS2sjM9NNztYPKkRs9sq7JN55Yn6BSV/uVZUFuDsTyOTsOYuS5LTm3jzz++B9PIC320yXLM/czeK4M85SyNnYaAqKjEYnmmXBoS94gVNb1Ym/ezyigBwmpaP02uwJ5gJEapI+CSBxp/qNX4GapGZJt90SU8WXk3le/0w9l1VT7rpu4q0uit2I24stFbbAYZwsykZcOnqntr0KY5iwc2A3jPlMh+Zyq2EixrhK5Qv5aRCs4w7u4L6t06jgxYNF0zVzF+poE5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB6311.namprd11.prod.outlook.com (2603:10b6:8:a6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Mon, 23 Jun
 2025 16:23:32 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Mon, 23 Jun 2025
 16:23:32 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Hunter,
 Adrian" <adrian.hunter@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH V4 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
Thread-Topic: [PATCH V4 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
Thread-Index: AQHb2raQMvS71doOpkSd//tZsUmNFrQFK1QAgANI6wCAAAL4gIAAKpgAgAEMaACAALJ8gIABx94AgABM3ICAACfUAIAAJO8AgAA5jYCABAUmgA==
Date: Mon, 23 Jun 2025 16:23:32 +0000
Message-ID: <2c04ba99e403a277c3d6b9ce0d6a3cb9f808caef.camel@intel.com>
References: <20250611095158.19398-1-adrian.hunter@intel.com>
	 <20250611095158.19398-2-adrian.hunter@intel.com>
	 <CAGtprH_cpbPLvW2rSc2o7BsYWYZKNR6QAEsA4X-X77=2A7s=yg@mail.gmail.com>
	 <e86aa631-bedd-44b4-b95a-9e941d14b059@intel.com>
	 <CAGtprH_PwNkZUUx5+SoZcCmXAqcgfFkzprfNRH8HY3wcOm+1eg@mail.gmail.com>
	 <0df27aaf-51be-4003-b8a7-8e623075709e@intel.com>
	 <aFNa7L74tjztduT-@google.com>
	 <4b6918e4-adba-48b2-931c-4d428a2775fc@intel.com>
	 <aFVvDh7tTTXhX13f@google.com>
	 <1cbf706a7daa837bb755188cf42869c5424f4a18.camel@intel.com>
	 <CAGtprH8+iz1GqgPhH3g8jGA3yqjJXUF7qu6W6TOhv0stsa5Ohg@mail.gmail.com>
	 <1989278031344a14f14b2096bb018652ad6df8c2.camel@intel.com>
	 <CAGtprH9RXM8RGj_GtxjHMQcWcvUPa_FJWXOu7LTQ00C7N5pxiQ@mail.gmail.com>
In-Reply-To: <CAGtprH9RXM8RGj_GtxjHMQcWcvUPa_FJWXOu7LTQ00C7N5pxiQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB6311:EE_
x-ms-office365-filtering-correlation-id: 37da825b-3b9a-4d6f-1749-08ddb2724bd8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VmpqZFN0S1ZwUDhlanRRRmltM1F1bUN2dXNYK2xVN1BGalUwdUllU0VSSDBH?=
 =?utf-8?B?K0ZESFN4cmxYSmRuN0wrVklMempZN0dHdGFKbDBHZm9hSTN2c2FPYnY2ZE5M?=
 =?utf-8?B?K2lma3Yzc2dNemRMQ0lFVVRXWUNvdmtJWnZ0OWo2QjJERHpiNEJSWHNOV3Fk?=
 =?utf-8?B?Q2ZUMTJ3bDhMb3pRQW5vVDRnajFWSm44dG1IdStrK0x0YjBiMjdOZ1ZsUGxN?=
 =?utf-8?B?L28vdzVtVEVBYldudjJ6dzd0UzFuSlNYV0FoUGdKTmJURHMyQjhQQTY3S3B6?=
 =?utf-8?B?SDN1Z3QrVFFLM0VMWEhWZ1FaN3ZOQVlXMGlocFg2SDFFNWoyVTlBSnorL3dN?=
 =?utf-8?B?cWYwMVhpL3dJdkgraVhHOGw1UEVXam1uK2FaV1BoVHVtUEdFYXpBYmFPWFhv?=
 =?utf-8?B?MFVVWlZZVXAvKzhvajVtbDJsMGhBcXEzWERrSDhnUlNENmNqdCtQTjVIemph?=
 =?utf-8?B?ZWlQWk4vSzJNN1Jxd3h5NnJvTmR6OTRyTjFyNTBuMzd6Q09RRFJXWkNrSjNu?=
 =?utf-8?B?ZG9oUGpjT2ZnMkxHTkhPYW9hTjJSZnhCZlFKdi81dS81OVl0UENPVnhhSlVO?=
 =?utf-8?B?MDZHQkVZUzlPcDdUQXZUZGt4MzAybCtkdndaMXFPanp3NVlPZEZOWmFoM0RC?=
 =?utf-8?B?UmFJdERpeXVjaFhoT0ZFRm9OeUNlQUFnY2pORDkvUWgwREs0K2x5YW5HcHRh?=
 =?utf-8?B?RW8zSW4xMlpwcmEyd0VTblJvaFZ3YUE4T1JLVE1VVnBEWUI3cisxSmswcEFu?=
 =?utf-8?B?L2dhS3k2bForWXFrZzEwS0g0NFNnZ0ZPSk10eHZvN05MdGF4NmQrZSt4VHZR?=
 =?utf-8?B?ZXlYRzhwWVlxdE05SEJ5OWJpTC9od1VxTitYU3F2QTVWQWlZcklOdU51SGN4?=
 =?utf-8?B?bi9tbENFSHVmRitUNmY5ZSsxN3lGREo0WkxwbEMwMGloR0dPQWVRRS9aMkRh?=
 =?utf-8?B?SXVqVzRUZ0VWZTFIcXphRDdzRFlYMDE5aTRpSjdLbHlucStOTTFjZ0NsT1dN?=
 =?utf-8?B?Z1lqcG9lQTFleDgzNUMxS3hNaFREMGJGRDQwR2xtUmNrdUxKdGtRTTdOVEh0?=
 =?utf-8?B?SlNzVm9VVUx2ZXI4YVEvTTRzZUsvcGlYQkZSTHJXaWRvNHVsdTlKdXBYU1Qx?=
 =?utf-8?B?bnZzMmhpVWVmeERaZ29CSUVlWEZIZ1RWUFNXWkR4WDVoWlczWjBDR1pBYjl1?=
 =?utf-8?B?UGs0VXNkNDRWZFNocW14U0NoT1g5dDhpRzUzM1NSb0JqMThHbFhjbUFicUtD?=
 =?utf-8?B?T2hsOWVXNzJFeWdFMVRvQUNwUVZza0lpalFIL2xQUVVNUzNkcWdwdHovTjBM?=
 =?utf-8?B?b3ptbi94b1ZWc3Nady9wdXNvc3RBV0lDYUs1UGtoV05SRkExZXNadUdHa0Q3?=
 =?utf-8?B?clhyMlZ1OXVpWWVVN2Q3SGZQOHhSd2JXYTFDdk51alBUOXNpWVUwMTFQaU9F?=
 =?utf-8?B?V2xLMk5Dd3BPblRDRUNadG04L2xRekZzVGY0bEg4aCtUK3ZJay9jTEFocGM1?=
 =?utf-8?B?ejA2YWl5NGZpTDYzSFlpaDZCVzh5dGlqdVJPUm1kVWcxSWkzZFNvVWZDNnZx?=
 =?utf-8?B?SkFMS2NjVDNXU25NZy95YUNEY0NPRDB6NVhCSXN5bWo0Tm56amFqckRadlJF?=
 =?utf-8?B?SUVRUGlmSkdmNWMrS2RlZjA1bjNMMWlJUTBTRzlLQ2pVbDB1WGFXai9MZW42?=
 =?utf-8?B?dHRHVGk0N0ZFUlJwN01DeWN5UEpuMlpWSmxUYzBMNmdkaTZqaXBJcXdadEFm?=
 =?utf-8?B?SXdGNzRRNlR6elBhdnJwSmF3WXJYR0pVcUdraGxFTXNRVFI1cFhaNWRyYlU2?=
 =?utf-8?B?R211enBzc09RbDh6VFIzZ3VMaUhOZEJsTHNNVURQSGw0VWtVMUJRdG9xVnNo?=
 =?utf-8?B?cUtYRW5DMDdxeVpZejVmUVNIejNXODlmdzI0Vk1MYXRna3pCR3dFZ01YekdG?=
 =?utf-8?Q?AAe6H30XADUoyQVXzPQW527YMdC7zzRR?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RkgxYy9HbGtSSmRFdjkzU0g3NERUVys4UllxcURmNW80bEEwMGgxVHZDQWxX?=
 =?utf-8?B?RHR0MytCTkV3OEJsYktpbHFwT0M3R2JLa3BNQVZ1VTFNSTBYM2J6TFpNaCs1?=
 =?utf-8?B?WWE3UFdJL1JkSG9zbGlONldSNHJpRXYyMmZyRnNPUjZ5SXArUW9RdzljdFk0?=
 =?utf-8?B?eVpuT0k5MStpRUovSzFyVnd1cnphUEF3NlNuMXZiSFBXdnQ3aDhlSUFqWW9q?=
 =?utf-8?B?aUpyWFQrdGdLQzd1ZnViTVBrSU5rZjJkUXFRblB4MGplM2JwbHdXMElQS1Ux?=
 =?utf-8?B?ZUYzS2YwbVUzanJNZCt2T2JtZEFtMDhRN0Y0anlkU3Q0KytpUGw2MXRHVGhp?=
 =?utf-8?B?MHhhRzJDVUdnM1JRMU5qcnlPbmpXMURDQ3ZodDNKMmtjOVFzU0g5QnRLTGFu?=
 =?utf-8?B?bVpUT3laRmpMTmtEN2ltU1FadXJjeTNMck5aaFEvTUdLZlVxZFdGMGE0M2NX?=
 =?utf-8?B?ZWJpNmd4WWNEUmZKaWdRbHIxUk5qMm5wR3lTMHBUeWFPRTNXdVg5SlRPcVJN?=
 =?utf-8?B?NEFtbTRwbmt6dCs4VG01MkxScnQzTzFybkszaTgxd1FMU3BiS0ptclBEMFh0?=
 =?utf-8?B?bll3bzU4aWVEa3ZUb1dFcENuZDdjdVV3eENwcnN5a0RDT1hVZVRPV0hSbUsw?=
 =?utf-8?B?SnFCaGxqWGNPckZFaDN0cjkxR3pWZVVoVjlYdlZKdXM4YlZicG4wTUFENWtG?=
 =?utf-8?B?U01tMmFRK1R5VU81RCtiRE1OZG1Wa3JXKzNHMjRRSk5zNklqUHA2SEVXUlJy?=
 =?utf-8?B?L2twU3pFa1Y1SVR2cmhPTExnSHNEOHRwWkttTll5WDZnc3poakZ3czU0OVVV?=
 =?utf-8?B?U29EQnFSVWpiNlVCVGREcUpSM1R4enJacFd6UGg3cE54UEtuZmFLbGJ6dzNa?=
 =?utf-8?B?eGYrZmdvS0R4dmJwT1NMbm45S2lrcmRvbTh1SmJjVUtRZ09nOTBuNkNXektP?=
 =?utf-8?B?R1pFOG1MRC85bHRDc2U5TWdJTHZoOTVwQ3JydFAwQTM3Zzd4Y0NNcDFuclBS?=
 =?utf-8?B?MXo3NFVXeVlpaUZXbFVqdis5YXZuY3B2aDkwblU0MlpIeDNxWVlOdE9iTVFG?=
 =?utf-8?B?NmFKVFoxdzhzaWxBQ0FpOW9pYW5CUElIbDhMaTA5ZUtoczVCdzY5VGhuL1hB?=
 =?utf-8?B?NSswYjFaNDhnbTdXZWtqU0FQb1poR2VHQ3UzbzE4K2M4eDNTejhxZE9QYTdK?=
 =?utf-8?B?VGNKbjdsQ0hBZmNia3ZrRktZa083dXRsRHhycjhaMk5ydFhaY21jYXcvbkJo?=
 =?utf-8?B?M3B1SDdKNHhaeHhNTmJoOFl3bWhuU0JTQUF2RlFWQWhrK1ZraEZWZkdLSDYx?=
 =?utf-8?B?bzVBQlZxMkxQZXZyUXczdkRrKzljRTJRY0xJTWxEV1h2SEpJNXBrOFV2UXBL?=
 =?utf-8?B?THB2NFczMUFjbkpQMi9jRGVySlBFYjhIblJJdmVzK3VhTldGYmVnK3hQWjVF?=
 =?utf-8?B?NEgzbXRiNkVrb2tac3BuYWNKaWE1U0Zsd2dQWUFwNHFOWktnMG5MbldFTkNO?=
 =?utf-8?B?OE50aEZERUhFT2RRMDhLSlY3UFhaRWNCZlY1V2pJRktBUERoYWdGM2gyUDVT?=
 =?utf-8?B?dDlXSTFUb3ROa2NaemVBZHNxcmFMdm42V1FoS0tXcHFrc0tTRG1JSHhGZGFI?=
 =?utf-8?B?enFuUEtWYkFyQVJyT3pBK2xhLzl0MjNueW91T1k2VTRNU0FrSjBtS0QvbGpw?=
 =?utf-8?B?TlJyMUhDYVppWWdieVZzWWpOVm1FcVBFakxkSHU4TEJaellwQ2s4R2xaQUFD?=
 =?utf-8?B?Uy9sYlFRaFhSc09UNDJvVXRXM2FSbVBrMlYzVzcyNmZRMDZaZURraDFqa3BG?=
 =?utf-8?B?Q1hURklZQnFnK082RVpWWURIY2VPMzJkVWtMeXdQSUdYWThKQ2Z4b043Nysz?=
 =?utf-8?B?dlRVdllCaGlia2lCcUVBZ0sxZWpRaXVSVTVKWW1LM3NiUURZMkhndnRURS9R?=
 =?utf-8?B?aUxGeVJBeHFRMmhXb2pYVlFRSjZDT2NXeitZbVNWNVNQbFphbVNlQlIyOEw0?=
 =?utf-8?B?TWVXSFBFS1cxb0oyYThMYm96T0VXL3dadHpjUHFCd3JSYXBOQVNKZG1ybGVL?=
 =?utf-8?B?M21NVkRDTHBNaEZvS2Rqbmo1VkVYZ2lza2R0N1RiZ2FTdWREZFM4ZTlJekNT?=
 =?utf-8?B?S0M0MVFyVVd6R1ZLUTliQTZ6ZUk4aDdXYk0ySmdnTGxETnlzT0FEUXVTZ0Nt?=
 =?utf-8?B?Snc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C4C93DB2F05A7948B822EFBB55B42773@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37da825b-3b9a-4d6f-1749-08ddb2724bd8
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2025 16:23:32.4862
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vd3G9PmiYnuoFE7BVPQrFbPYTa2e1TSiq+RjADJURwHr/zSO59INWKbvf7nR3jOV8NOVHVpN6qruCgTRds9DPmEVNunIE0MxmL2dWcpfxiw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6311
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA2LTIwIGF0IDIwOjAwIC0wNzAwLCBWaXNoYWwgQW5uYXB1cnZlIHdyb3Rl
Og0KPiBDYW4geW91IHByb3ZpZGUgZW5vdWdoIGluZm9ybWF0aW9uIHRvIGV2YWx1YXRlIGhvdyB0
aGUgd2hvbGUgcHJvYmxlbSBpcyBiZWluZw0KPiA+IHNvbHZlZD8gKGl0IHNvdW5kcyBsaWtlIHlv
dSBoYXZlIHRoZSBmdWxsIHNvbHV0aW9uIGltcGxlbWVudGVkPykNCj4gPiANCj4gPiBUaGUgcHJv
YmxlbSBzZWVtcyB0byBiZSB0aGF0IHJlYnVpbGRpbmcgYSB3aG9sZSBURCBmb3IgcmVib290IGlz
IHRvbyBzbG93LiBEb2VzDQo+ID4gdGhlIFMtRVBUIHN1cnZpdmUgaWYgdGhlIFZNIGlzIGRlc3Ry
b3llZD8gSWYgbm90LCBob3cgZG9lcyBrZWVwaW5nIHRoZSBwYWdlcyBpbg0KPiA+IGd1ZXN0bWVt
ZmQgaGVscCB3aXRoIHJlLWZhdWx0aW5nPyBJZiB0aGUgUy1FUFQgaXMgcHJlc2VydmVkLCB0aGVu
IHdoYXQgaGFwcGVucw0KPiA+IHdoZW4gdGhlIG5ldyBndWVzdCByZS1hY2NlcHRzIGl0Pw0KPiAN
Cj4gU0VQVCBlbnRyaWVzIGRvbid0IHN1cnZpdmUgcmVib290cy4NCj4gDQo+IFRoZSBmYXVsdGlu
Zy1pbiBJIHdhcyByZWZlcnJpbmcgdG8gaXMganVzdCBhbGxvY2F0aW9uIG9mIG1lbW9yeSBwYWdl
cw0KPiBmb3IgZ3Vlc3RfbWVtZmQgb2Zmc2V0cy4NCj4gDQo+ID4gDQo+ID4gPiANCj4gPiA+ID4g
DQo+ID4gPiA+IFRoZSBzZXJpZXMgVmlzaGFsIGxpbmtlZCBoYXMgc29tZSBraW5kIG9mIFNFViBz
dGF0ZSB0cmFuc2ZlciB0aGluZy4gSG93IGlzDQo+ID4gPiA+IGl0DQo+ID4gPiA+IGludGVuZGVk
IHRvIHdvcmsgZm9yIFREWD8NCj4gPiA+IA0KPiA+ID4gVGhlIHNlcmllc1sxXSB1bmJsb2NrcyBp
bnRyYWhvc3QtbWlncmF0aW9uIFsyXSBhbmQgcmVib290IHVzZWNhc2VzLg0KPiA+ID4gDQo+ID4g
PiBbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC9jb3Zlci4xNzQ3MzY4MDkyLmdpdC5h
ZnJhbmppQGdvb2dsZS5jb20vI3QNCj4gPiA+IFsyXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9s
a21sL2NvdmVyLjE3NDk2NzI5NzguZ2l0LmFmcmFuamlAZ29vZ2xlLmNvbS8jdA0KPiA+IA0KPiA+
IFRoZSBxdWVzdGlvbiB3YXM6IGhvdyB3YXMgdGhpcyByZWJvb3Qgb3B0aW1pemF0aW9uIGludGVu
ZGVkIHRvIHdvcmsgZm9yIFREWD8gQXJlDQo+ID4geW91IHNheWluZyB0aGF0IGl0IHdvcmtzIHZp
YSBpbnRyYS1ob3N0IG1pZ3JhdGlvbj8gTGlrZSBzb21lIHN0YXRlIGlzIG1pZ3JhdGVkDQo+ID4g
dG8gdGhlIG5ldyBURCB0byBzdGFydCBpdCB1cD8NCj4gDQo+IFJlYm9vdCBvcHRpbWl6YXRpb24g
aXMgbm90IHNwZWNpZmljIHRvIFREWCwgaXQncyBiYXNpY2FsbHkganVzdCBhYm91dA0KPiB0cnlp
bmcgdG8gcmV1c2UgdGhlIHNhbWUgcGh5c2ljYWwgbWVtb3J5IGZvciB0aGUgbmV4dCBib290LiBO
byBzdGF0ZQ0KPiBpcyBwcmVzZXJ2ZWQgaGVyZSBleGNlcHQgdGhlIG1hcHBpbmcgb2YgZ3Vlc3Rf
bWVtZmQgb2Zmc2V0cyB0bw0KPiBwaHlzaWNhbCBtZW1vcnkgcGFnZXMuDQoNCkhtbSwgaXQgZG9l
c24ndCBzb3VuZCBsaWtlIG11Y2ggd29yaywgZXNwZWNpYWxseSBhdCB0aGUgMUdCIGxldmVsLiBJ
IHdvbmRlciBpZg0KaXQgaGFzIHNvbWV0aGluZyB0byBkbyB3aXRoIHRoZSBjb3N0IG9mIHplcm9p
bmcgdGhlIHBhZ2VzLiBJZiB0aGV5IHdlbnQgdG8gYQ0KZ2xvYmFsIGFsbG9jYXRvciBhbmQgYmFj
aywgdGhleSB3b3VsZCBuZWVkIHRvIGJlIHplcm9lZCB0byBtYWtlIHN1cmUgZGF0YSBpcyBub3QN
CmxlYWtlZCB0byBhbm90aGVyIHVzZXJzcGFjZSBwcm9jZXNzLiBCdXQgaWYgaXQgc3RheXMgd2l0
aCB0aGUgZmQsIHRoaXMgY291bGQgYmUNCnNraXBwZWQ/DQoNCkZvciBURFggdGhvdWdoLCBobW0s
IHdlIG1heSBub3QgYWN0dWFsbHkgbmVlZCB0byB6ZXJvIHRoZSBwcml2YXRlIHBhZ2VzIGJlY2F1
c2UNCm9mIHRoZSB0cmFuc2l0aW9uIHRvIGtleWlkIDAuIEl0IHdvdWxkIGJlIGJlbmVmaWNpYWwg
dG8gaGF2ZSB0aGUgZGlmZmVyZW50IFZNcw0KdHlwZXMgd29yayB0aGUgc2FtZS4gQnV0LCB1bmRl
ciB0aGlzIHNwZWN1bGF0aW9uIG9mIHRoZSByZWFsIGJlbmVmaXQsIHRoZXJlIG1heQ0KYmUgb3Ro
ZXIgd2F5cyB0byBnZXQgdGhlIHNhbWUgYmVuZWZpdHMgdGhhdCBhcmUgd29ydGggY29uc2lkZXJp
bmcgd2hlbiB3ZSBoaXQNCmZyaWN0aW9ucyBsaWtlIHRoaXMuIFRvIGRvIHRoYXQga2luZCBvZiBj
b25zaWRlcmF0aW9uIHRob3VnaCwgZXZlcnlvbmUgbmVlZHMgdG8NCnVuZGVyc3RhbmQgd2hhdCB0
aGUgcmVhbCBnb2FsIGlzLg0KDQpJbiBnZW5lcmFsIEkgdGhpbmsgd2UgcmVhbGx5IG5lZWQgdG8g
ZnVsbHkgZXZhbHVhdGUgdGhlc2Ugb3B0aW1pemF0aW9ucyBhcyBwYXJ0DQpvZiB0aGUgdXBzdHJl
YW1pbmcgcHJvY2Vzcy4gV2UgaGF2ZSBhbHJlYWR5IHNlZW4gdHdvIHBvc3QtYmFzZSBzZXJpZXMg
VERYDQpvcHRpbWl6YXRpb25zIHRoYXQgZGlkbid0IHN0YW5kIHVwIHVuZGVyIHNjcnV0aW55LiBJ
dCB0dXJuZWQgb3V0IHRoZSBleGlzdGluZw0KVERYIHBhZ2UgcHJvbW90aW9uIGltcGxlbWVudGF0
aW9uIHdhc24ndCBhY3R1YWxseSBnZXR0aW5nIHVzZWQgbXVjaCBpZiBhdCBhbGwuDQpBbHNvLCB0
aGUgcGFyYWxsZWwgVEQgcmVjbGFpbSB0aGluZyB0dXJuZWQgb3V0IHRvIGJlIG1pc2d1aWRlZCBv
bmNlIHdlIGxvb2tlZA0KaW50byB0aGUgcm9vdCBjYXVzZS4gU28gaWYgd2UgYmxpbmRseSBpbmNv
cnBvcmF0ZSBvcHRpbWl6YXRpb25zIGJhc2VkIG9uIHZhZ3VlDQpvciBwcm9taXNlZCBqdXN0aWZp
Y2F0aW9uLCBpdCBzZWVtcyBsaWtlbHkgd2Ugd2lsbCBlbmQgdXAgbWFpbnRhaW5pbmcgc29tZQ0K
YW1vdW50IG9mIGNvbXBsZXggY29kZSB3aXRoIG5vIHB1cnBvc2UuIFRoZW4gaXQgd2lsbCBiZSBk
aWZmaWN1bHQgdG8gcHJvdmUgbGF0ZXINCnRoYXQgaXQgaXMgbm90IG5lZWRlZCwgYW5kIGp1c3Qg
cmVtYWluIGEgYnVyZGVuLg0KDQpTbyBjYW4gd2UgcGxlYXNlIHN0YXJ0IGV4cGxhaW5pbmcgbW9y
ZSBvZiB0aGUgIndoeSIgZm9yIHRoaXMgc3R1ZmYgc28gd2UgY2FuIGdldA0KdG8gdGhlIGJlc3Qg
dXBzdHJlYW0gc29sdXRpb24/DQo=

