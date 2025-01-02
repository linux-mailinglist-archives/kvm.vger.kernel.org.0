Return-Path: <kvm+bounces-34511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C725A001D2
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 00:33:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E58307A1F6B
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 23:33:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72AA61C07DE;
	Thu,  2 Jan 2025 23:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W73SGew0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75031BEF94;
	Thu,  2 Jan 2025 23:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735860794; cv=fail; b=NsEiz8fFb3PLgQevU+awpgmj5OH9jmxvYcPY95lzUKGqEanjRmv+Kam3LwG0fUlk0dCzhqzT76RHDmksY22QWtuAnO5vP9YcfbfzBISJiadxtUyVdvsOnMhpPp9DhU8BSAvbXr4RmRKfssmyo1Q+H2CKkX238074F2fDawDpmvs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735860794; c=relaxed/simple;
	bh=gS3LmlpeNuPgKHjGl3ERSySQ1a6/w5L9Fd7lgTvbcWI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XaFvdb2vIgSIP44i1XnbeLfTNn6IsicdNWalCS30dbGg4Odi47LL4laS/ZUyRjBVk4nLDNNye6rdBmLGTQKbxO9fYw2DYEoOnegN8pJLSCrlAqyyrx+TL3Ae8tt0bV1aLYZYhe+Ybd3RzntkQFQqG7xg9CN9E26bcOEVYM4f8kE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W73SGew0; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735860793; x=1767396793;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gS3LmlpeNuPgKHjGl3ERSySQ1a6/w5L9Fd7lgTvbcWI=;
  b=W73SGew0+Xpqf1H5wmPSE04uvcwawKG9TqgW8Ng/16pNWAsir2ZWNyva
   RotJ7kMsmkMlSOni3IMsJ1XKeY/HwvOmdzzkP5y5ID+wpGCRxM+RUOfsX
   1vlLnlac+wZ9mqtZkk0r1YvVK57QFM2GeN7vzzD6vkjrKTD+MjtCv4MEW
   JujQDkyHuthrPJcJU92PmnDC9Nhpe77Nt/CgMp5KKCe/rGl+tpSjfzCLP
   tAod0MG2/CYEpfR35xPejZq5UliiPsOjxWM6MWRvp6BhxLVptB95xWSZM
   E9vJGetbIxEjpSFk/0IuZsHocs4Sve9TA5bwRSIKV1QXcNsYz+D1/ocYj
   Q==;
X-CSE-ConnectionGUID: tGjEotEbTT2N2+2tCqd/Vw==
X-CSE-MsgGUID: QWD7FYPmQ2ey+2L6V6xvlA==
X-IronPort-AV: E=McAfee;i="6700,10204,11303"; a="40034031"
X-IronPort-AV: E=Sophos;i="6.12,286,1728975600"; 
   d="scan'208";a="40034031"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2025 15:33:12 -0800
X-CSE-ConnectionGUID: aYLfePKQRtKyLUzGQyfReA==
X-CSE-MsgGUID: VIZ3VTnIRsukySpGiocAeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,286,1728975600"; 
   d="scan'208";a="132490876"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Jan 2025 15:33:12 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 2 Jan 2025 15:33:11 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 2 Jan 2025 15:33:11 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 2 Jan 2025 15:33:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uvXzFgxenIt645CsUkn6/R19R8sR+u6xDTmaybFMjOKPYeWAdiACk4kIOlJMyc++4W9IK7ADkHO0628SNsgahvu5oGSX8tq7QrHthNkgS/k/hPr0PApVwKCiALWN2eBlcf3liaQnTChJODf8/uF9dZNdYDfe9I9NlnyhJH3ZxiNySfaVtwuQzrxz94Xg0Q9mazl6Fpg5iiYkJHxUiVAszVXKZKOs74o1ADkFLoePauAXWiBEt0e7M62qBtil5kETebQ/HjGpXhJkRG4U4PL4SonK642Bqe9PP883w+wuu2AXldjG/Z+31aHyewS1OGzevkLZkentFsiL7ujX42sagA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gS3LmlpeNuPgKHjGl3ERSySQ1a6/w5L9Fd7lgTvbcWI=;
 b=WWeYOyL66ZbLTiAWD/ZJzZLFPsYHw1BPW4XlhURuqU5pUGEAViU03Qx+/S3tso/80fcIXClGm435gsr0qmW1GJ49jhSTBl1Zhe20bgXxt9oZoi15YWlmuOwt5D7zcUedj1SjUpeO54clkANEeOzApZjg6Xy+o3oGRSBueX5rnUJo9x9b28SGwXGGeON+mOYnKAPRw5IR2jZB/bzTuuqyXtgdpjRwANLB0lXkWVqhUsBXgxnNhm5eCHN91br9yzeEscfZ0qlCKIAhj3GY+K0WfZWSZs0Ui/92HnHvhPE1hv4IkNWfj9TpQtPDPrahxO73EJqNTJEZeZL4KrZQp1TXSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB8157.namprd11.prod.outlook.com (2603:10b6:8:187::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.20; Thu, 2 Jan
 2025 23:32:46 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8314.013; Thu, 2 Jan 2025
 23:32:46 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 08/13] x86/virt/tdx: Add SEAMCALL wrappers to add TD
 private pages
Thread-Topic: [PATCH 08/13] x86/virt/tdx: Add SEAMCALL wrappers to add TD
 private pages
Thread-Index: AQHbXCHZnPs8r4rRz0yF1XZL7xOWcLMEJPsA
Date: Thu, 2 Jan 2025 23:32:46 +0000
Message-ID: <c11d9dce9eb334e34ba46e2f17ec3993e3935a31.camel@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
	 <20250101074959.412696-9-pbonzini@redhat.com>
In-Reply-To: <20250101074959.412696-9-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB8157:EE_
x-ms-office365-filtering-correlation-id: d25188eb-260d-465d-95b6-08dd2b85c330
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cWVWYlV1d0R4RmtCZE9SQlpwRHJZd3Jyby83OTJXbTZlQUlDb1FzMjRYNWcx?=
 =?utf-8?B?QVJZUTZCcTh0amdtU25OejZJOUQvUndyaGdiNmY4SmdWckVicGptWGdFTWl2?=
 =?utf-8?B?SlhqVmJoSzczN29nSTMvYXJZV1BZNzFjVnlzakRzVStNVWt0YmRrZk1heUho?=
 =?utf-8?B?Wlh5VHVzQTFlQ3hJSE1ZdzNsQ2JhNEdiQU14UUdrTVZyS1VpVnE5SkZrL2g4?=
 =?utf-8?B?NGF2eGJGM2gzckxaNFo3TGVLTllTaU5pYll2SFVaZnh0QlczL0Z5cnpJTG0z?=
 =?utf-8?B?NVhINUJ1MW84eUIwUTNlWGkvT29HdHcxZVVtcVhiUGZ0SDZjNTVPK0FBekhs?=
 =?utf-8?B?Uno0L3FoSWxaSDRmRys4S2U4QUp0VjlLRGdJdWFUTW1IVk9iYTg2RzZwYlBC?=
 =?utf-8?B?OGg5V0szSnZTWDlVS0NSTUJ4bE1Kc1BWZzIxajlqeTU1ZWhneW0yRmxvVzIx?=
 =?utf-8?B?ZVZKYWIrSXo4VnhKcllFN291b0N5Z3pSSXdWYlRRU3c1NUNjN1pPb2dUczkr?=
 =?utf-8?B?T2xQVjE2VlhGZC94eTA5bzNydXg4RzlYcTFKNFRNTWw5QlNoNlJJNXpiTlpI?=
 =?utf-8?B?Q040VkJrSzg3TUZ1Q0F1UTNhRzI1bjh3U3N1NnJaZ21CYmZBSVR1SWZ3SEJv?=
 =?utf-8?B?QzBpZ1BGMC9QczlxRlRkenBDWndmbkphVWZReGxYTnNteDV0UUtQWDVXY3JD?=
 =?utf-8?B?WEFuSmxyajhQQThleXlhL0pKYkNxWCtMVkFuL0hkOVpuWGZDcGlZcGdXS1o3?=
 =?utf-8?B?L0J4eXlPd2w5eFRaZ2M5b096WVlpb3pGRUtkUXNQeGlxT09OcXd1aGdrcVo0?=
 =?utf-8?B?V0NHRnMyUHA0Q3U3VDEzL0dsMEFnaWFWbmZFa09PelRyTmhxdkV1K1VUMVo3?=
 =?utf-8?B?bUF5NEk0a1RDbUhaNVBQRktIUkZ3RmcvanQzbXlhQnFRNHVsZ0svZHRvY1dX?=
 =?utf-8?B?YnNqUitmK2hYcm5aM1BLTFNyTmlmZkVFTUdYdmZVYjh3QjZTSFRPQ0lzMXdO?=
 =?utf-8?B?YlBSV3VqUk8xNFF1cXpoSTNtZTBUN1JLL0xIcG1MSWpzYjZyVzdpcHZ0cDBj?=
 =?utf-8?B?M1dCUTBjVERrdFlpOTZ5SGZNbXlVNytmMlNKbEN0Sk56OXpvRVhuUnRBNmJ3?=
 =?utf-8?B?MnpZbDQ1dTdJVS9ha1dlU0RrWjZYTURFR1RxY0R6aUd3a010T1R0WmZRMW5J?=
 =?utf-8?B?NEx6TGZmaFlocmhxU0RJdUEwRGQyV1Rhd1lEWS9rcUVzZlhiV0dyVnhZYmRY?=
 =?utf-8?B?UE1zU3U1WnV6eGVsNlJYN0lITTdyYmlVNklqMDVpUkw2NWJDMVkyQml2T1Z1?=
 =?utf-8?B?SDNjS2RnOVpFeGo4ei9sQmZNOWk4UE03anFhbWhDNnZwQVBZR29QK1ZXL1dy?=
 =?utf-8?B?R0tmU2dkT255azdob0tWTStFSFdSM0FJZFozUi80Z3AyTWp4WDJnZkhwUTY2?=
 =?utf-8?B?SUZScXNqNHgvcENOK0J2WUZUUkI0Tlo2eHdTcHp1bVFkbi93TmJLdDV2U21z?=
 =?utf-8?B?cG96TFFuZFBQaHczQTNKQUdMVmE5NDh0d0o4SlBRMlIzUDVtdENFL21tU2tF?=
 =?utf-8?B?dnJIK3RHNlR5SytwbFJ1bGxHbnE3cktjZ0xaWTlURW9ZTlM4REZKcVRsUy9U?=
 =?utf-8?B?UzRKUExGUnBtMVIva3Vja3ZyZ2g5Q3Rtblh4ZDd1MlB1eTIyVmRON2tUbTZT?=
 =?utf-8?B?a3VtVFlKcU8xakcrTE5oVjlkdURzYWwvNDhzYnRkM0RBOGs4Nnl4cXo4MW14?=
 =?utf-8?B?RitCeENTNkxFUUxhYThxQnVUa3VBRjlsczAwTmRZeG5Dcmt5Q0FUT1g5dTJ5?=
 =?utf-8?B?N0EyRmE0bFFMalBsbkJSZHNqL2lSSXBybk90WXRoakUyek5BUXpTRmdXQUVG?=
 =?utf-8?B?K2FwUkJtSHp0bU1PelpxZTE2WCtGRjVoM0tBQlJ3SHRkRkp4Y2wrdGRtdDht?=
 =?utf-8?Q?JSQc6e8tgoGOg3yaXSEZTdBwhcA0R2UU?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bnZXWE16Q0F3UFZZUERGMTdHY2Fib01HaG43bWp4WHNSeS9Kb3Y2clhDendm?=
 =?utf-8?B?THo0MXB2QWJ5cDhYbWEyeWVEUERrS2NObUk2bFM4M0FFcE96Z2oydG0yNzNR?=
 =?utf-8?B?Z2tzZ09uVU0wVzlsb3BNSlZpN0hzekZveEpWcmNYQWs0M3R0b2RjS2NnQ0pX?=
 =?utf-8?B?M09xZUJlT2FuYlFUbWQ2R01jcTg5djJYOHd0QUpRREtLOHUzTWFPZnJ6OTBP?=
 =?utf-8?B?Q1E1TDRYMFAzTU1UbW13bXRaa3R5TmcrVE9WYWdVbzdRVGlaTnh2Q3lURXZF?=
 =?utf-8?B?UkxBMUxJYkFjSDRmc2oyeFVRbDV6V0F6OExTaUFhazBKa1hSQUxYS1VkcVNl?=
 =?utf-8?B?dGZ2d1orazFHUS91SFlFWVd0YUVweU5kdFNSckRHbUhPWVFLenlZVGwvdjUr?=
 =?utf-8?B?Y0JRZllDVUxuL0Q4NnRVT2QwbUtMUEVkZFZjNkhycHlRV20wRjFDMXQ0VjFw?=
 =?utf-8?B?UjBPY2RGb0o0ZlJtMDh6QnJDbzdsUWF1eDYwVGxzaUsvN1ZEWTlhMnluOWcw?=
 =?utf-8?B?NHNnTnl5Q2l4N0FCU2F6Q3JTVFY3UWN2NFUrQXBxaFpZeGNCdnpoYkQrZ00r?=
 =?utf-8?B?SGhQNW5UVHphSG9nYkVtaURhVHVRbXJ6bzFQTElzQ1lEK21KWm5NZVJEeFBv?=
 =?utf-8?B?Qk9xSkZNYlNrSmZMOGVWUm1sUXRYak84TXovVkQxTzZTMXJMaWVybmg5TGF1?=
 =?utf-8?B?SEtDSkFEVmFFang4L1FrQ1RZdit1MXVtWWczNGZyYzQ4SjlHY1J6VmFFazRr?=
 =?utf-8?B?cUwwaWlCbEJkendMU2FzS2JTcVVIOHoyaGtYUEtNdWhyNUNzU2kxTkpPMHhW?=
 =?utf-8?B?RlgrNklleVdoakNRSWV0emw4WFJxNjVLcERTdmtvV0dSNEdkVHpzYlUxZlpU?=
 =?utf-8?B?bWw1bGIxc3NKOGZvRmRESjk0ZFVhWHo1QlhJVEpQM2I1OEdaUmF1RTZTbUFQ?=
 =?utf-8?B?Vnpiak85S2NHZjNmM3BEa2JXM1hyR2huaEJpb0VvZDVDcHJvWndDbnpTRGRM?=
 =?utf-8?B?ZXNmc2dhbzlhZGRZeDlsekhURjdTUGlsMS9HcGcrR01lRyt6aXZpV3hkLzVE?=
 =?utf-8?B?TlY3VU5VdzY5QTRLdjRtaStMYlA5bzRGbU9DaFRaaENvcFM2V2Z3MFhoRlRY?=
 =?utf-8?B?eFhxSUttYlJGZjFrM3RTRFJid08zNklNOUgwUisxMVYvejNkREM5NHVnOW5T?=
 =?utf-8?B?U29TbWIvbWNzVlBRZmNoZzBIcHJoQXVvUDh3QmZpWTY4aDVZNXJpSzVWb21s?=
 =?utf-8?B?MWRDRnFQcFprTjg2WnpxOTJVRkg4clo0Mk1LRFkwdnF0ZW9BenNuTlk1ZXJu?=
 =?utf-8?B?Y1EvTjVBTWZSWS9SNXRsbHlxamFDN2JucU1vcjBuOUVtZ1NwdTBzVlduOXBR?=
 =?utf-8?B?R252ODVJY0ZLVzJEN3ZKREhpTjA0S0dsSGhkVVY0dDlGdXRVVTJnM2RjNXJj?=
 =?utf-8?B?MG5td25RWTJVM1RrUmNab0tKZUkvcUlPeGJxK0NWamR5aGlqb1Evbkx4UURS?=
 =?utf-8?B?T3NEYVpacE9LbmZjUEdPV0V3NE1xbkJ2dDZOQ3NQZFJuL0FmeXVCWkRndkl3?=
 =?utf-8?B?WGlRa0g5TlNDMERvR2ZMeEpoZkl5bWxnQTBsL3J0ZkVqWllUMTBqZ1BsMWxS?=
 =?utf-8?B?amhEOWV2NWZndzBHUklsRHVqbks3SGJSdHJkR1duL3gxYVpzeldHUlhLSHNM?=
 =?utf-8?B?MWhvUlV4WUZhVVNxQ2pLK0NEcEFTelhvdnBsdFh5UWljWFlnemk3ZjhqWWY1?=
 =?utf-8?B?RnFpMUNSdDNjR1BKM2FGcEtQMlVUU3ZGRXFWUmxSZld3azBEaTk5SW5KSkFS?=
 =?utf-8?B?VXBvOHhVTXJTOXR0RHdTbFR1MUJ3M25ucHVBY2JRUmpoVDFuM0ZSNWV0N3dn?=
 =?utf-8?B?ZndteDdxQWFka1BaSFAvY1pPTGd2VlQ2NXJGSXNZUU1lb242Z29iWHJBeWxi?=
 =?utf-8?B?WmJiY2lRU2JWbWNISithYXNIOWlMdUN2cG9lbG9EdWQ3QlRJK1NCNG5sOEFq?=
 =?utf-8?B?Z3JJUERSN3AyZS9FS2dEZzRtdWxlKzJ0eU9pWlRlTEU1TU41R0RWaDhxQzJ1?=
 =?utf-8?B?UVFNTDhDQVVFdTRCOXlxbnpLdFBWajl2am50Z3crbm5IYTlFa3Z4U0NLcWlw?=
 =?utf-8?B?UjlnbTVEeVBMcUZkTGhvN1Rna2FDamQwZHRjeW5CSm0rR1pyWG1YbTllRzFQ?=
 =?utf-8?B?V3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E46ACEBE6BFACC46BC985C02FB0EEADB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d25188eb-260d-465d-95b6-08dd2b85c330
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jan 2025 23:32:46.1738
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QCXL4M4aG4sWCJD62iFQsl+06D5X4X4axyHhhncr+uIw6KM4bv8Bw6CfJY/SvL8iW6NGzRNnZEnF6ag8Qkr6Qxns1HzCb8Sfz+e1mleahu0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8157
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTAxLTAxIGF0IDAyOjQ5IC0wNTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jIGIvYXJjaC94ODYvdmly
dC92bXgvdGR4L3RkeC5jDQo+IGluZGV4IGE5N2E0NzBkZGEyMy4uZjM5MTk3ZDRlYWZjIDEwMDY0
NA0KPiAtLS0gYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gKysrIGIvYXJjaC94ODYv
dmlydC92bXgvdGR4L3RkeC5jDQo+IEBAIC0xNDkxLDYgKzE0OTEsMjYgQEAgdTY0IHRkaF9tbmdf
YWRkY3goc3RydWN0IHRkeF90ZCAqdGQsIHN0cnVjdCBwYWdlICp0ZGNzX3BhZ2UpDQo+ICB9DQo+
ICBFWFBPUlRfU1lNQk9MX0dQTCh0ZGhfbW5nX2FkZGN4KTsNCj4gIA0KPiArdTY0IHRkaF9tZW1f
cGFnZV9hZGQoc3RydWN0IHRkeF90ZCAqdGQsIHU2NCBncGEsIHU2NCBocGEsIHU2NCBzb3VyY2Us
IHU2NCAqcmN4LCB1NjQgKnJkeCkNCj4gK3sNCg0KdTY0IGdwYSBjb3VsZCBiZSBnZm5fdC4NCg0K
aHBhIGFuZCBzb3VyY2Ugc2hvdWxkIGJlIHN0cnVjdCBwYWdlcywgcGVyOg0KaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcva3ZtL2Q5MmU1MzAxLTljYTQtNDY5YS04YWU1LWIzNjQyNmU2NzM1NkBpbnRl
bC5jb20vDQoNCj4gKwlzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzIGFyZ3MgPSB7DQo+ICsJCS5yY3gg
PSBncGEsDQoNClRoaXMgY291bGQgcG90ZW50aWFsbHkgYWxzbyB1c2UgdW5pb24gdGR4X3NlcHRf
Z3BhX21hcHBpbmdfaW5mby4NCg0KPiArCQkucmR4ID0gdGR4X3Rkcl9wYSh0ZCksDQo+ICsJCS5y
OCA9IGhwYSwNCj4gKwkJLnI5ID0gc291cmNlLA0KPiArCX07DQo+ICsJdTY0IHJldDsNCj4gKw0K
PiArCWNsZmx1c2hfY2FjaGVfcmFuZ2UoX192YShocGEpLCBQQUdFX1NJWkUpOw0KPiArCXJldCA9
IHNlYW1jYWxsX3JldChUREhfTUVNX1BBR0VfQURELCAmYXJncyk7DQo+ICsNCj4gKwkqcmN4ID0g
YXJncy5yY3g7DQo+ICsJKnJkeCA9IGFyZ3MucmR4Ow0KDQpTaW1pbGFyIHRvIHRoZSBsYXN0IHBh
dGNoLCB0aGVzZSBjb3VsZCBiZSBleHRlbmRlZF9lcnIxLCBleHRlbmRlZF9lcnIyLg0KDQo+ICsN
Cj4gKwlyZXR1cm4gcmV0Ow0KPiArfQ0KPiArRVhQT1JUX1NZTUJPTF9HUEwodGRoX21lbV9wYWdl
X2FkZCk7DQo+ICsNCj4gIHU2NCB0ZGhfbWVtX3NlcHRfYWRkKHN0cnVjdCB0ZHhfdGQgKnRkLCB1
NjQgZ3BhLCB1NjQgbGV2ZWwsIHU2NCBocGEsIHU2NCAqcmN4LCB1NjQgKnJkeCkNCj4gIHsNCj4g
IAlzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzIGFyZ3MgPSB7DQo+IEBAIC0xNTIyLDYgKzE1NDIsMjUg
QEAgdTY0IHRkaF92cF9hZGRjeChzdHJ1Y3QgdGR4X3ZwICp2cCwgc3RydWN0IHBhZ2UgKnRkY3hf
cGFnZSkNCj4gIH0NCj4gIEVYUE9SVF9TWU1CT0xfR1BMKHRkaF92cF9hZGRjeCk7DQo+ICANCj4g
K3U2NCB0ZGhfbWVtX3BhZ2VfYXVnKHN0cnVjdCB0ZHhfdGQgKnRkLCB1NjQgZ3BhLCB1NjQgaHBh
LCB1NjQgKnJjeCwgdTY0ICpyZHgpDQo+ICt7DQoNCmhwYSBzaG91bGQgYmUgc3RydWN0IHBhZ2Us
IG9yIGFzIFlhbiBoYWQgYmVlbiByZWFkeSB0byBwcm9wb3NlIGEgZm9saW8gYW5kIGlkeC4NCkkg
d291bGQgaGF2ZSB0aG91Z2h0IGEgc3RydWN0IHBhZ2Ugd291bGQgYmUgc3VmZmljaWVudCBmb3Ig
bm93LiBTaGUgYWxzbyBwbGFubmVkDQp0byBhZGQgYSBsZXZlbCBhcmcsIHdoaWNoIHRvZGF5IHNo
b3VsZCBhbHdheXMgYmUgNGssIGJ1dCB3b3VsZCBiZSBuZWVkZWQgZm9yDQpmdXR1cmUgaHVnZSBw
YWdlIHN1cHBvcnQuDQoNCkkgdGhpbmsgd2Ugc2hvdWxkIHRyeSB0byBrZWVwIGl0IGFzIHNpbXBs
ZSBhcyBwb3NzaWJsZSBmb3Igbm93Lg0KDQo+ICsJc3RydWN0IHRkeF9tb2R1bGVfYXJncyBhcmdz
ID0gew0KPiArCQkucmN4ID0gZ3BhLA0KPiArCQkucmR4ID0gdGR4X3Rkcl9wYSh0ZCksDQo+ICsJ
CS5yOCA9IGhwYSwNCj4gKwl9Ow0KPiArCXU2NCByZXQ7DQo+ICsNCj4gKwljbGZsdXNoX2NhY2hl
X3JhbmdlKF9fdmEoaHBhKSwgUEFHRV9TSVpFKTsNCj4gKwlyZXQgPSBzZWFtY2FsbF9yZXQoVERI
X01FTV9QQUdFX0FVRywgJmFyZ3MpOw0KPiArDQo+ICsJKnJjeCA9IGFyZ3MucmN4Ow0KPiArCSpy
ZHggPSBhcmdzLnJkeDsNCg0KU2ltaWxhciB0byB0aGUgb3RoZXJzLCB0aGVzZSBjb3VsZCBiZSBl
eHRlbmRlZF9lcnIxLCBleHRlbmRlZF9lcnIyLg0KDQo+ICsNCj4gKwlyZXR1cm4gcmV0Ow0KPiAr
fQ0KPiArRVhQT1JUX1NZTUJPTF9HUEwodGRoX21lbV9wYWdlX2F1Zyk7DQo+ICsNCj4gIHU2NCB0
ZGhfbW5nX2tleV9jb25maWcoc3RydWN0IHRkeF90ZCAqdGQpDQo+ICB7DQo+ICAJc3RydWN0IHRk
eF9tb2R1bGVfYXJncyBhcmdzID0gew0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvdmlydC92bXgv
dGR4L3RkeC5oIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5oDQo+IGluZGV4IDMwOGQzYWE1
NjVkNy4uODBlNmVmMDA2MDg1IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgv
dGR4LmgNCj4gKysrIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5oDQo+IEBAIC0xNiw4ICsx
NiwxMCBAQA0KPiAgICogVERYIG1vZHVsZSBTRUFNQ0FMTCBsZWFmIGZ1bmN0aW9ucw0KPiAgICov
DQo+ICAjZGVmaW5lIFRESF9NTkdfQUREQ1gJCQkxDQo+ICsjZGVmaW5lIFRESF9NRU1fUEFHRV9B
REQJCTINCj4gICNkZWZpbmUgVERIX01FTV9TRVBUX0FERAkJMw0KPiAgI2RlZmluZSBUREhfVlBf
QUREQ1gJCQk0DQo+ICsjZGVmaW5lIFRESF9NRU1fUEFHRV9BVUcJCTYNCj4gICNkZWZpbmUgVERI
X01OR19LRVlfQ09ORklHCQk4DQo+ICAjZGVmaW5lIFRESF9NTkdfQ1JFQVRFCQkJOQ0KPiAgI2Rl
ZmluZSBUREhfTU5HX1JECQkJMTENCg0K

