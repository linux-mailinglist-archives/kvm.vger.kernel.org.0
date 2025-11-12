Return-Path: <kvm+bounces-62872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7598CC51AB1
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 11:32:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 976E618865E5
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 10:31:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62A0830BF73;
	Wed, 12 Nov 2025 10:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="njLBmagQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D154A3064AB;
	Wed, 12 Nov 2025 10:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762943358; cv=fail; b=u+aU97oYvsHElyQk/Jc6L+1lk+PIsqdLEbAYCGbcfqvq0m7wscEdd604/CoJ87Ta+z40NVDPs/iSqDoF2rPiccC6FIn1TetjdoS+Q3KdvVbjv0LwnUL87rCSGWruobZLb6Ajbl4o4rE28gwBRn0wOtH7D889jmYNBD6X+dDF754=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762943358; c=relaxed/simple;
	bh=NXASJalUdezsB54xTGAr/0qb72CaQ6z413aJrA7A8lI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YeZDt5by60qWYw6HjTMy9TfI5ZTCLHW+fUyBEpgA9MknFNNFZLXV9TKKxce3qgJxRHfvvVOwAv8EAvddKuiNY44NnQQrFJQ4Pyx9PviVzp4NbN9AI6v2KzqKRTFq4HV6ItG4jnf3GMorUHZLeJLDJblEho5YhP0vrlGkucIHW/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=njLBmagQ; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762943355; x=1794479355;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NXASJalUdezsB54xTGAr/0qb72CaQ6z413aJrA7A8lI=;
  b=njLBmagQ7ipPUWkvXseedh3p3NC0rWrzkTZ+2yUCYRf1g2NuWsNgjGOT
   QshXYNhJ7GFwLJojYY3o4C/4azlDwaRLmVWzTAJK9z8Tkjh22dYTrS5IQ
   EuoW/8s0LYLbq4B7nbTTzYpynG7htWIJm9ScGi037cn4MUOpy3AoPm3Rc
   dAN1rquhYx2qLUGeDyY2enwm7zC/w56PDwOp4PFjurTKezyFhTuGRQTRE
   xsTNBv+RVap0kmPNvKBoLKMc4YVZsGXjevI5bs5+dohTfhRAGIb1smAAz
   3bWrCPJnKoW9j6b73iV0paYXeu53Fazra620EbQuff9z0PgBESGTekF3Z
   w==;
X-CSE-ConnectionGUID: yB2Uclm/QxOdhh/MFPXigw==
X-CSE-MsgGUID: rTZrn6/TT2C7CdQQoWsvWA==
X-IronPort-AV: E=McAfee;i="6800,10657,11610"; a="75309216"
X-IronPort-AV: E=Sophos;i="6.19,299,1754982000"; 
   d="scan'208";a="75309216"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 02:29:14 -0800
X-CSE-ConnectionGUID: Trc7/sO3S4+7kCnq/d7Kig==
X-CSE-MsgGUID: 3UE3S2S/S/62YcKTB0jj8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,299,1754982000"; 
   d="scan'208";a="189912195"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 02:29:14 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 02:29:14 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 02:29:14 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.31) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 02:29:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f9VbthiVlAI86mtM9/JMtf4IOosNghQWNf0lk444ZaAoVaEx86ium4VKin+uzLLmP0clv6s1mueJZo6AKSGuuF80dRQW8NYhsG5HM+9Zr84IxWd/vIRJKa6LMgSXD8HvAINhlw1lZ0OVwxJoL/6ubk7q1vxQfiLuOCjl7tgSKPbLHyTgpkDE9uXR7xSbFsYhJ7cHWTRBz2F2oAKDT+ziflmGorHMy/apktnhyoHhLtNS1FCxcaywdHumNX4s8sKm9VqayCXPazzyB3UBKzn3mqu2y9rBCaCIr1plarUQ6EjKgo+ovTMnMcFq+pYcvrZtgdZq/CVeVXetkTyxom0Iaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NXASJalUdezsB54xTGAr/0qb72CaQ6z413aJrA7A8lI=;
 b=qu+1RF3e7fbdY35CQAIROaaVs96uLIX3rW2r2C7AfUorUTLxDfrnaQvVcIWPXyyeG/IULIFi1kWJRz4oasVk1GIOfDTye0kx93MSUzF0rhdBng6yKciYfoqNmQIU9B0bxG5ReZV/5OVwDcjRk1LTmd/d9whvB7w6yr3UF6MDd4GkD10nX6P09Dq8203x770/5Jnu6BSZ8rKxO6WMyDViFkLBBjkhTfUbuy+9CWpCToqUspRKr17mie2xXhQa5Vf/Jj0otb5hAZP9sTuoVh0RTKE7H0MVNF7yatLkLo/7+drn7A92FwS9ht7jwxRrfwj2B2DL+D37uKc4OsRUoizKog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA0PR11MB4526.namprd11.prod.outlook.com (2603:10b6:806:96::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Wed, 12 Nov
 2025 10:29:12 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 10:29:11 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"tabba@google.com" <tabba@google.com>, "Du, Fan" <fan.du@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com"
	<seanjc@google.com>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "zhiquan1.li@intel.com" <zhiquan1.li@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 03/23] x86/tdx: Enhance
 tdh_phymem_page_wbinvd_hkid() to invalidate huge pages
Thread-Topic: [RFC PATCH v2 03/23] x86/tdx: Enhance
 tdh_phymem_page_wbinvd_hkid() to invalidate huge pages
Thread-Index: AQHcB3+qgPjJH8tKFUSGhVyOSb/37LTtyqyAgAGHLgCAAB2CgA==
Date: Wed, 12 Nov 2025 10:29:11 +0000
Message-ID: <858777470674b2ddd594997e94116167dee81705.camel@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
	 <20250807094202.4481-1-yan.y.zhao@intel.com>
	 <fe09cfdc575dcd86cf918603393859b2dc7ebe00.camel@intel.com>
	 <aRRItGMH0ttfX63C@yzhao56-desk.sh.intel.com>
In-Reply-To: <aRRItGMH0ttfX63C@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA0PR11MB4526:EE_
x-ms-office365-filtering-correlation-id: dafc532e-1618-4ffb-b41a-08de21d65214
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?S1lLdUIzSjNWV1l5SmY0SG1tSEYyU1FRQVpMMkRlcFozY1ltemR4Vy9Uazd6?=
 =?utf-8?B?SW5Rb0MrYk1VZ0NaNHpPSEd0TnQ1K1hKTk5Ga211eERvUXlHcnBCRHV5Zzdo?=
 =?utf-8?B?M2NQZDhmZG8wb3ZDd3pHKzBHMmJRNStQUVpEWHVDcEhqT2E5U1NoMnArZzVt?=
 =?utf-8?B?a2lFYndiV2N2UW9SNkViUWlRMkQ4ZnVxN0RVRFlQbGcxVzc1b0o0QkkyNE9q?=
 =?utf-8?B?aHBFNDZMYzQraFlXdWpvc2tzam9BZUtwYzA0Rk05NUtBS212dHlxcjVBMWg1?=
 =?utf-8?B?ck96Ujl4K3cvRUxHbWZNdVhGM0FnRVdNSmt3RTRKMm9kTTdMMHRCNjhWZ3pN?=
 =?utf-8?B?RUFoellsNVNFRUlWR1NDbzhCb0czcE1yZGFIaCt6UmY1K3FLSHBPYU5wQXZo?=
 =?utf-8?B?VmJzQ2xRelV4WWN3Q2FWQmJ6aTNvMzRyaE1lQ1EzdTJaTEhiQzgxak5kSzFN?=
 =?utf-8?B?djJXYWV4L3dFWFh0ZXNtKzFSNW1EeGJVWjY2bHMxSDR1T0NBNldIeVBXTllk?=
 =?utf-8?B?TXBpYUVXa25OSElUY1Fab1JJUWZFR1pPWURKMWQ1R1ZxbEZqc3lPQm1mZjh3?=
 =?utf-8?B?dEdnSFh3SVRGSGdHSzRiWkhtNlVpVjhjcHNpU2NQZ0xydFFxZHNDQk5LeEJV?=
 =?utf-8?B?Q3RSM0hTY01JMTIwdUtrZllGYjNLeUgxcEwwYzZabWJMZ1VUMVNVUkNnQjdh?=
 =?utf-8?B?OC9tbHpVU0h5N2JrZWlyZHZ1RG9raG0yVmNQMTBib1JmU2NYbTZUMm12NGIx?=
 =?utf-8?B?Mi9nR1VlcGIrSUxDVzlrQ3V3YUY5emp4NWpHL1o3bmhkM3VLaDV4bllqU2pa?=
 =?utf-8?B?UXlGUDk0OTJjVVdhSktEdkdGd2NFVUpNM1RFSzRHNGp1YTVYd1JjRERoRHpY?=
 =?utf-8?B?K25SYTllKzc2VHdrbmZ6MjIxd0MwTkZBYXE3akMwaU5hN21JZGI2OHl3MXYy?=
 =?utf-8?B?ZVkrK25FdFJJTHJINzBJTWd1VG8rdVU4RGo3WUs1MTFIUUI5OUQxUG02NTJk?=
 =?utf-8?B?d3I5SjkzVDVPem8rblc2cHpBM2pzZlY0MHBJZDJsZE5CaWgzeXdBOGlEdG9D?=
 =?utf-8?B?b1ErMXBERGkxNXZxNEVMcU9SeHpDSS9hUFVTRjc2L2NTcjlKRXhtMWkzTThO?=
 =?utf-8?B?bnJHcjVLdmwxRFJCQmRQdkJ0N3ZCNHJSUG5hK3hFN25VREVMci9sUGhIdFVF?=
 =?utf-8?B?RC9CQUk3N2JCb0Q2VHFacHBwZzM3T245bkM1clZVQjZ5NkMvaTc5WFoxc1BO?=
 =?utf-8?B?Z3ZNdmY1YkRFcTJqUTFJWndjMGQ2aVM5WXQ5U3ZhL0MvN1IxWTgzaG9qSE5W?=
 =?utf-8?B?a1lCODZiSmRnUUZIWExPOEd2NkJZTUtwNVp6QVA0ckpmSjh3ZDB5M0hSK2ov?=
 =?utf-8?B?OW5CSDVueDFpTE9yYTNnTWxoeFc2aE1oOVVzSE9EczlFb2tTZzZYSHN5YmhG?=
 =?utf-8?B?Umw0S1pXbk80Z1dQTTlZbUdmZGRHZHhlTytBM0RGODZNMitBdmgrWW50VjVT?=
 =?utf-8?B?ZjBGbEtuTGh0MHB1NGkxekZuNmgzVlRjWi9jWkdKUnd1QXc4czRxcWFlaDhx?=
 =?utf-8?B?dkd5YzJ5ZWdBQ2txanlyMXlZSWFEeFNjbUpkSk9nenVHRnVrekVZcWg5c0VB?=
 =?utf-8?B?d2RnVXBmYm1ua2IzUm1qRndWaVBSYU5YQXRlZ2VObTZkNzlkZHBCV0M2MkJi?=
 =?utf-8?B?N2hRQ1N0SmFvNEJMak9zazdaZS9XdDM4K0JGWHlRTFFoRmpsZlFnV0p4TmRR?=
 =?utf-8?B?Qy9EeDRTdlQrb3YxQnFMNzhoWnA1WkJkVmZBNUhWQ0JIamZXTHRhbyttRlkr?=
 =?utf-8?B?Sy9RS2NCZ1JMVzlpdTQycjBuell3OXcvQ1piWXRJckRFbUhBcnRZcTRVbThW?=
 =?utf-8?B?Vm1UODdmZ0F2dWNVUGRoL3NTS0ZMS0VzWXNFREpKQ2oycy81OFJicHNUQXM1?=
 =?utf-8?B?MkFVRGZnellxTnhGU3A3Um1DcmJDU0FzQ29LUmZZcmd0anZQSW5Pd2gvWlJO?=
 =?utf-8?B?S01ZeFBWd3VpVEpLUFpCUlJ0dllSMmJzVGwyZ08vYmlERjhHTzB6ZVo5cEpo?=
 =?utf-8?B?eTVSZkNSRmUrd2VpTUI1bk1zalVXd1NTcUdSQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NHkvcTVORnZ4Rm0rNm02L0xFQ3RWOGo4a20wWlQyaDNRbnYvTWYzRmVZWks3?=
 =?utf-8?B?NjBQcUFqcVNSK3Q3NzNtTEUvcVViNTZXQkJYR00zWk5ZRXdkMWl3T3JJYW9D?=
 =?utf-8?B?V0lCemdGZUJSL2F3S1ZROGY3L1VnbnJrK0lPY0k0MTl6elR1QThkQ0N1bzFF?=
 =?utf-8?B?UzZvQ0hrc3h4YXc0OUZ5WTNZM3J6MVNkOWxnYWZqVTB5UHB5VFliaWsvM3dv?=
 =?utf-8?B?ejJrVlFPNjBObHhtdWQwMTBwbTJXTEhRSlVldi9EZWp6MUVuUnduOEhLN05P?=
 =?utf-8?B?T1QxNGhVQXBkTGQyTW9xeVI2bmc0b1B6NUw3VjgrMXNSRTRxMkVZWExtcTRu?=
 =?utf-8?B?dFdyVWNRNjZ5MVRkczlnWmFqSDdhU2dOQWRGZXBWb2I3OWJWVlhiSVVWOWl5?=
 =?utf-8?B?QUNDZzgybng0OW8xQUJMODFBbzVSOHBGcTZXQU54amtKN0VWaHlpc05LVFZi?=
 =?utf-8?B?bmxBRXBJVTI2NlpZYmhXUjVRS0tSTVNEekpybkZCUDdCMmRYNDFkZEc1SUEr?=
 =?utf-8?B?MGpsRXdzUHhXUjBYUFVQbWw2ekFtUnhJeTZrcThIYXpoZE5YRTB6M0pBa0pw?=
 =?utf-8?B?NlFyQ2gzYzRYeUVuTmpkU2ZpZm54cWhRc2Uxcmh4QWphYVlJVURKaWU4Ylk4?=
 =?utf-8?B?STRHVlR0bHNEWUZsUyszaXB4Smh1T2NtR1NSeDB6dGJZOVV5VkxvS1NFL05C?=
 =?utf-8?B?R1Z4NFRXdnpzRnlMeWxlRklGUVF5SW9sV052NXd6MEZEdFpDQjgrV2VmTmwv?=
 =?utf-8?B?QW5CclUvTUI3VFMxY3MxdVQ3MFRERFJxK29VMGhZWlBkS1J0VkpSOU5HMnhZ?=
 =?utf-8?B?ZktjM1dGV28vbGsvNExwblRiSXNmUTdvUXZrTndkNHN1azVQdlZrZjF1WHBz?=
 =?utf-8?B?QzY2Q2xOYlErdGZQK1lqZGxIMnJXV0hlMTZDM0tNK1UvV3lJNnRUbHhteU45?=
 =?utf-8?B?MFl6Sm9VUmV6ZDhNL3NvaE1CQXlHejB1dXBZd3ZNNzRaeE9KNlRaSkwyR1RZ?=
 =?utf-8?B?REIrcHNjQzg5SW5LNUJpOWdjY1BnN1RISkJ6Rm8vbCtacDdrWUlNMUc5Y1M5?=
 =?utf-8?B?Y2pjRHROSGUxZm1qWGx1cXN0R0dteDNwZDNnUExzVHJOUlRjM3EyNFpieEN2?=
 =?utf-8?B?QVN2WCsrWE8ycWxER1JBdkpUV3c3MkcyQ2hxYU9mYmxxUm51SGdSVUZ2OVg5?=
 =?utf-8?B?bmpLQUs0eVVVMGxpcHZLUmpRdytLOE5vd0J6NGRlZHEvVzQ2cmdDSFh1Wmhs?=
 =?utf-8?B?K1o0eHVROEVMeGVkeWgxS2daQzBINHEyMGtEaFJMYnBrelNrTTVxN3hIem1H?=
 =?utf-8?B?dzJaVXJTZWlqSnB3ejZjUTAxeUZMVklDOEcwanprTjBBS1NiUTNnZ0F6RTAx?=
 =?utf-8?B?V0ZYc3V5QWdrL1hkU2JMZDRKbUEvbVZTcjlDb0k0RWxneVVDRFJHSlFwSk9O?=
 =?utf-8?B?TU5YSjc5Y3BHaW8xem1xNVk5cjJjMEsxRlJlYWN5bW5pelQ1RVJwSlNJOG5Y?=
 =?utf-8?B?OXp6MXdlVTlONWYxYjRqdkQ0bWRnanZ0dWErRHJPamtDVnZPRWV5S3N3dTJC?=
 =?utf-8?B?VmpMZFdvMUpEckw2MXI1RG05bWF3dGx2ZlNEbmZzOHRLRkZuUit3UWp5Nkw3?=
 =?utf-8?B?YktYZ2p6dmdsVmQ5M3RYYnpYWFpsK1JMTVNUR21lT20wVVoyRzhHcjRRc2Rw?=
 =?utf-8?B?Syt4NnBPNDdMS3dsblE5eVpXNXlGaURXeEFFNTB1Zi9BcUppd1pJOFltenov?=
 =?utf-8?B?RkpRNlZsMDFsWERJY0VFbFd5dXM5Tm9PemdBZE1qcmNGWE14akcrVmt0NnMw?=
 =?utf-8?B?aHdPWjA0WGtXa1JxUDJGaE13N25ROTNTVjNGSjd2SkthMVFXemlQbnZWRnND?=
 =?utf-8?B?SWk5QUVqOEt5a0FJVnhFck1HSE5EMWdtN0xoc3lwVnFSa0hOUmJNYlZob2Rp?=
 =?utf-8?B?NFpWYUNIN3NocGNubW5sWncrK0Z4b1ViTzhXYVdZU2hJd2RWd0Z6aktSTkpw?=
 =?utf-8?B?blphVHFyZXJ6bjUvOTVqZHdVWlRmQW9McHBYbmN3R2dNWTQrZWtPZUdJempE?=
 =?utf-8?B?b2ljV0V2enY3cEZyeEhMNWZKL1BhSUo0YWpWdWw3SUprR2dQdS9KYVlPUm5Z?=
 =?utf-8?Q?qyHUsKZ1Z2VnS3MYn8RZ3J3Fz?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B8F2507D6EA91459E78F7D5EB569F48@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dafc532e-1618-4ffb-b41a-08de21d65214
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2025 10:29:11.6486
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5oxmE92yFRGHJm/hG5pGHYgprChKeTTzp9NqZEIzMdKJd8MQJqeODRPcGMozNRdZjgmV/fNp7UCVVe0vftD+WQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4526
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTExLTEyIGF0IDE2OjQzICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gT24g
VHVlLCBOb3YgMTEsIDIwMjUgYXQgMDU6MjM6MzBQTSArMDgwMCwgSHVhbmcsIEthaSB3cm90ZToN
Cj4gPiBPbiBUaHUsIDIwMjUtMDgtMDcgYXQgMTc6NDIgKzA4MDAsIFlhbiBaaGFvIHdyb3RlOg0K
PiA+ID4gLXU2NCB0ZGhfcGh5bWVtX3BhZ2Vfd2JpbnZkX2hraWQodTY0IGhraWQsIHN0cnVjdCBw
YWdlICpwYWdlKQ0KPiA+ID4gK3U2NCB0ZGhfcGh5bWVtX3BhZ2Vfd2JpbnZkX2hraWQodTY0IGhr
aWQsIHN0cnVjdCBmb2xpbyAqZm9saW8sDQo+ID4gPiArCQkJCXVuc2lnbmVkIGxvbmcgc3RhcnRf
aWR4LCB1bnNpZ25lZCBsb25nIG5wYWdlcykNCj4gPiA+IMKgew0KPiA+ID4gKwlzdHJ1Y3QgcGFn
ZSAqc3RhcnQgPSBmb2xpb19wYWdlKGZvbGlvLCBzdGFydF9pZHgpOw0KPiA+ID4gwqAJc3RydWN0
IHRkeF9tb2R1bGVfYXJncyBhcmdzID0ge307DQo+ID4gPiArCXU2NCBlcnI7DQo+ID4gPiArDQo+
ID4gPiArCWlmIChzdGFydF9pZHggKyBucGFnZXMgPiBmb2xpb19ucl9wYWdlcyhmb2xpbykpDQo+
ID4gPiArCQlyZXR1cm4gVERYX09QRVJBTkRfSU5WQUxJRDsNCj4gPiA+IMKgDQo+ID4gPiAtCWFy
Z3MucmN4ID0gbWtfa2V5ZWRfcGFkZHIoaGtpZCwgcGFnZSk7DQo+ID4gPiArCWZvciAodW5zaWdu
ZWQgbG9uZyBpID0gMDsgaSA8IG5wYWdlczsgaSsrKSB7DQo+ID4gPiArCQlhcmdzLnJjeCA9IG1r
X2tleWVkX3BhZGRyKGhraWQsIG50aF9wYWdlKHN0YXJ0LCBpKSk7DQo+ID4gPiDCoA0KPiA+IA0K
PiA+IEp1c3QgRllJOiBzZWVtcyB0aGVyZSdzIGEgc2VyaWVzIHRvIHJlbW92ZSBudGhfcGFnZSgp
IGNvbXBsZXRlbHk6DQo+ID4gDQo+ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtLzIwMjUw
OTAxMTUwMzU5Ljg2NzI1Mi0xLWRhdmlkQHJlZGhhdC5jb20vDQo+IEFoLCB0aGFua3MhDQo+IFRo
ZW4gd2UgY2FuIGdldCByaWQgb2YgdGhlICJ1bnNpZ25lZCBsb25nIGkiLg0KPiANCj4gLSAgICAg
ICBmb3IgKHVuc2lnbmVkIGxvbmcgaSA9IDA7IGkgPCBucGFnZXM7IGkrKykgew0KPiAtICAgICAg
ICAgICAgICAgYXJncy5yY3ggPSBta19rZXllZF9wYWRkcihoa2lkLCBudGhfcGFnZShzdGFydCwg
aSkpOw0KPiArICAgICAgIHdoaWxlIChucGFnZXMtLSkgew0KPiArICAgICAgICAgICAgICAgYXJn
cy5yY3ggPSBta19rZXllZF9wYWRkcihoa2lkLCBzdGFydCsrKTsNCj4gDQoNCllvdSBtYXkgd2Fu
dCB0byBiZSBjYXJlZnVsIGFib3V0IGRvaW5nICcrKycgb24gYSAnc3RydWN0IHBhZ2UgKicuICBJ
IGFtIG5vdA0KZXhwZXJ0LCBidXQgSSBzYXcgYmVsb3cgZGlzY3Vzc2lvbiBvbiB0aGUgdGhyZWFk
IFsqXSB3aGljaCBsZWQgdG8gdGhlIHNlcmllcw0KdG8gZ2V0IHJpZCBvZiBudGhfcGFnZSgpOg0K
DQogID4gDQogID4gSSB3aXNoIHdlIGRpZG4ndCBoYXZlIG50aF9wYWdlKCkgYXQgYWxsLiBJIHJl
YWxseSBkb24ndCB0aGluayBpdCdzIGENCiAgPiB2YWxpZCBvcGVyYXRpb24uIEl0J3MgYmVlbiBh
cm91bmQgZm9yZXZlciwgYnV0IEkgdGhpbmsgaXQgd2FzIGJyb2tlbg0KICA+IGFzIGludHJvZHVj
ZWQsIGV4YWN0bHkgYmVjYXVzZSBJIGRvbid0IHRoaW5rIHlvdSBjYW4gdmFsaWRseSBldmVuIGhh
dmUNCiAgPiBhbGxvY2F0aW9ucyB0aGF0IGNyb3NzIHNlY3Rpb24gYm91bmRhcmllcy4NCg0KICBP
cmRpbmFyeSBidWRkeSBhbGxvY2F0aW9ucyBjYW5ub3QgZXhjZWVkIGEgbWVtb3J5IHNlY3Rpb24s
IGJ1dCBodWdldGxiIGFuZA0KICBkYXggY2FuIHdpdGggZ2lnYW50aWMgZm9saW9zIC4uLiA6KA0K
DQogIFdlIGhhZCBzb21lIHdlaXJkIGJ1Z3Mgd2l0aCB0aGF0LCBiZWNhdXNlIHBlb3BsZSBrZWVw
IGZvcmdldHRpbmcgdGhhdCB5b3UNCiAgY2Fubm90IGp1c3QgdXNlIHBhZ2UrKyB1bmNvbmRpdGlv
bmFsbHkgd2l0aCBzdWNoIGZvbGlvcy4NCg0KU28sIHdoeSBub3QganVzdCBnZXQgdGhlIGFjdHVh
bCBwYWdlIGZvciBlYWNoIGluZGV4IHdpdGhpbiB0aGUgbG9vcD8NCg0KWypdOg0KaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvYWxsL0NBSGstPXdpQ1lmTnA0QUpMQk9SVS1jN1p5UkJVcDY2VzItRXQ2
Y2RRNFJFeC1HeVFfQUBtYWlsLmdtYWlsLmNvbS9ULyNtNDliYTc4ZjVmNjMwYjI3ZmE2ZDNkMDcz
NzI3MWYwNDdhZjU5OWM2MA0K

